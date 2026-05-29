// bn6f-validate — compare orig vs per-patch playback by per-frame
// pixel hash. Lossy mp4 optional alongside the hashes.
//
// Subcommands:
//   hash <rom> --input <bk2.input> [--state <bk2.ss>] [--frames N] --out <hashes.txt>
//   video <rom> --input <bk2.input> [--state <bk2.ss>] [--frames N] --out <video.mp4>
//   both  <rom> --input <bk2.input> [--state <bk2.ss>] [--frames N] --hashes PATH --video PATH
//   compare <orig-hashes.txt> <patched-hashes.txt>
//
// `hash` is the correctness signal. Per-frame SHA256 over the
// emulator's framebuffer RGB pixels — deterministic, encoder-free.
//
// `video` is for visual review (libx264 CRF 28 mp4). The encoder is
// non-deterministic across runs but the decoded pixels still represent
// the same emulator state — visually it's fine for spot checks.
//
// `both` does one emulator pass that produces both outputs.
//
// `compare` diffs two hash streams. Reports first-divergent frame,
// total divergent frames, and exit code 0 = identical, 1 = differ.

#![allow(non_upper_case_globals, non_camel_case_types, non_snake_case)]
#![allow(dead_code, deref_nullptr, unused_unsafe)]

mod mgba_sys {
    include!(concat!(env!("OUT_DIR"), "/mgba_sys.rs"));
}

mod orchestrate;

use sha2::{Digest, Sha256};
use std::ffi::CString;
use std::fs::{self, File};
use std::io::{BufRead, BufReader, BufWriter, Read, Write};
use std::mem::MaybeUninit;
use std::os::raw::c_void;
use std::path::Path;
use std::process;
use std::time::Instant;

const GBA_W: usize = 240;
const GBA_H: usize = 160;
// libmgba renders into a 256-pitch buffer; visible area is the
// leftmost 240 px of each row.
const FB_STRIDE_PX: usize = 256;

struct Core {
    raw: *mut mgba_sys::mCore,
    // 32-bit ABGR framebuffer (libmgba 0.11 default build).
    video_buf: Vec<u32>,
}

impl Core {
    fn new(rom: &str) -> Result<Self, String> {
        unsafe {
            let rom_c = CString::new(rom).map_err(|e| e.to_string())?;
            let raw = mgba_sys::mCoreFind(rom_c.as_ptr());
            if raw.is_null() {
                return Err(format!("mCoreFind returned null for {rom}"));
            }
            let init = (*raw).init.ok_or("init null")?;
            if !init(raw) {
                return Err(format!("mCore.init failed for {rom}"));
            }
            mgba_sys::mCoreInitConfig(raw, std::ptr::null());

            // setVideoBuffer must happen before loadROM/reset so the PPU
            // init points at our buffer. 32-bit ABGR pixels (libmgba 0.11
            // default, not COLOR_16_BIT).
            let mut video_buf = vec![0u32; FB_STRIDE_PX * GBA_H];
            let set_buf = (*raw).setVideoBuffer.ok_or("setVideoBuffer null")?;
            set_buf(raw, video_buf.as_mut_ptr(), FB_STRIDE_PX);

            let load_rom = (*raw).loadROM.ok_or("loadROM null")?;
            let vf = mgba_sys::VFileOpen(rom_c.as_ptr(), libc::O_RDONLY);
            if vf.is_null() {
                return Err(format!("VFileOpen failed for {rom}"));
            }
            if !load_rom(raw, vf) {
                return Err(format!("loadROM failed for {rom}"));
            }

            let reset = (*raw).reset.ok_or("reset null")?;
            reset(raw);

            Ok(Core { raw, video_buf })
        }
    }

    fn set_frameskip(&self, val: i32) {
        unsafe {
            let cfg_key = CString::new("frameskip").unwrap();
            mgba_sys::mCoreConfigSetIntValue(&mut (*self.raw).config, cfg_key.as_ptr(), val);
            let reload = (*self.raw).reloadConfigOption.expect("reloadConfigOption");
            reload(self.raw, cfg_key.as_ptr(), &mut (*self.raw).config);
        }
    }

    fn load_savestate_from_path(&self, path: &str) -> Result<(), String> {
        let bytes = strip_bk2_state_prefix(path)?;
        self.load_savestate_from_bytes(&bytes, path)
    }

    /// Load a mGBA savestate from in-memory bytes. Strips the
    /// BizHawk 4-byte prefix if present.
    fn load_savestate_from_bytes(&self, raw: &[u8], src_label: &str) -> Result<(), String> {
        let mut bytes = raw.to_vec();
        fn looks_like_mgba_magic(b: &[u8]) -> bool {
            b.len() >= 4 && b[1] == 0 && b[2] == 0 && b[3] == 0x01
        }
        if !looks_like_mgba_magic(&bytes) && bytes.len() >= 4 && looks_like_mgba_magic(&bytes[4..]) {
            bytes.drain(..4);
        }
        unsafe {
            let vf = mgba_sys::VFileFromMemory(
                bytes.as_ptr() as *mut c_void,
                bytes.len(),
            );
            if vf.is_null() {
                return Err("VFileFromMemory null".into());
            }
            let ok = mgba_sys::mCoreLoadStateNamed(self.raw, vf, 0);
            ((*vf).close.expect("vfile close"))(vf);
            if !ok {
                return Err(format!("mCoreLoadStateNamed failed for {src_label}"));
            }
        }
        drop(bytes);
        Ok(())
    }

    fn run_frame(&self, keys: u32) {
        unsafe {
            let set_keys = (*self.raw).setKeys.expect("setKeys");
            let run_frame = (*self.raw).runFrame.expect("runFrame");
            set_keys(self.raw, keys);
            run_frame(self.raw);
        }
    }

    /// Hash the visible 240×160 RGB pixels in the current framebuffer.
    /// Each pixel is 32-bit ABGR (libmgba 0.11 default). Hash the raw
    /// bytes — no need to decode since identical raw bytes ↔ identical
    /// pixels.
    fn hash_frame(&self) -> [u8; 32] {
        let mut h = Sha256::new();
        for y in 0..GBA_H {
            let row = &self.video_buf[y * FB_STRIDE_PX..y * FB_STRIDE_PX + GBA_W];
            let bytes = unsafe {
                std::slice::from_raw_parts(row.as_ptr() as *const u8, row.len() * 4)
            };
            h.update(bytes);
        }
        h.finalize().into()
    }
}

impl Drop for Core {
    fn drop(&mut self) {
        unsafe {
            if let Some(deinit) = (*self.raw).deinit {
                deinit(self.raw);
            }
        }
    }
}

// Send wrapper so we can pass cores between rayon worker threads;
// each Core is only ever touched by one thread.
unsafe impl Send for Core {}

/// BizHawk .ss files prepend a 4-byte header before the inner mGBA
/// savestate. Detect via magic: mGBA savestates start with
/// versionMagic = 0x010000XX (LE) where XX is the savestate format
/// version. If the first 4 bytes don't look like that magic but bytes
/// 4..8 do, strip 4 bytes.
fn strip_bk2_state_prefix(path: &str) -> Result<Vec<u8>, String> {
    let mut bytes =
        fs::read(path).map_err(|e| format!("read {path}: {e}"))?;
    fn looks_like_mgba_magic(b: &[u8]) -> bool {
        b.len() >= 4 && b[1] == 0 && b[2] == 0 && b[3] == 0x01
    }
    if !looks_like_mgba_magic(&bytes) && looks_like_mgba_magic(&bytes[4..]) {
        bytes.drain(..4);
    }
    Ok(bytes)
}

fn load_input_file(path: &str) -> Result<Vec<u16>, String> {
    let bytes = fs::read(path).map_err(|e| format!("read {path}: {e}"))?;
    // 4 bytes/frame: u16 LE mask + u16 LE pad
    Ok(bytes
        .chunks_exact(4)
        .map(|c| u16::from_le_bytes([c[0], c[1]]))
        .collect())
}

/// Extract inputs + savestate bytes directly from a .bk2 file.
///
/// A .bk2 is a zip containing:
///   - `Input Log.txt`   — text, one `|...|` line per frame in
///                         BizHawk's button-bitmap format
///   - `Core.bin.zst`    — zstd-compressed BizHawk-wrapped mGBA
///                         savestate (4-byte prefix + state). Present
///                         iff the recording started from a savestate;
///                         coldboot.bk2 has no savestate.
///
/// LogKey format (header line in Input Log.txt):
///   `LogKey:#Tilt X|Tilt Y|Tilt Z|Light Sensor|Up|Down|Left|Right|Start|Select|B|A|L|R|Power|`
/// Per-frame line:
///   `|    0,    0,    0,    0,UDLRSeBALR.|`
/// We skip the 4 tilt/sensor numeric columns and read the button bitmap
/// (one char per button, dot = unpressed, letter = pressed).
fn load_bk2(path: &str) -> Result<(Vec<u16>, Option<Vec<u8>>), String> {
    let file = fs::File::open(path).map_err(|e| format!("open {path}: {e}"))?;
    let mut zip = zip::ZipArchive::new(file)
        .map_err(|e| format!("bk2 {path} isn't a valid zip: {e}"))?;

    // Read Input Log.txt
    let input_log = {
        let mut entry = zip
            .by_name("Input Log.txt")
            .map_err(|e| format!("bk2 {path} missing Input Log.txt: {e}"))?;
        let mut s = String::new();
        use std::io::Read;
        entry
            .read_to_string(&mut s)
            .map_err(|e| format!("read Input Log.txt: {e}"))?;
        s
    };
    let inputs = parse_input_log(&input_log)?;

    // Read Core.bin.zst if present
    let state = match zip.by_name("Core.bin.zst") {
        Ok(mut entry) => {
            let mut compressed = Vec::new();
            use std::io::Read;
            entry
                .read_to_end(&mut compressed)
                .map_err(|e| format!("read Core.bin.zst: {e}"))?;
            let decoded = zstd::decode_all(&compressed[..])
                .map_err(|e| format!("zstd decode Core.bin.zst: {e}"))?;
            Some(decoded)
        }
        Err(_) => None,
    };

    Ok((inputs, state))
}

/// Parse BizHawk's Input Log.txt → per-frame GBA REG_KEYINPUT-style masks.
///
/// LogKey order: Up, Down, Left, Right, Start, Select, B, A, L, R, Power
/// Our mask bits (REG_KEYINPUT, 0=pressed in hardware but mGBA's setKeys
/// uses positive-logic: bit set = pressed):
///   bit 0=A, 1=B, 2=Select, 3=Start, 4=Right, 5=Left, 6=Up, 7=Down, 8=R, 9=L
fn parse_input_log(text: &str) -> Result<Vec<u16>, String> {
    // (bizhawk_button_index_in_bitmap, our_bit_position)
    // The 4 tilt/light columns precede the button bitmap, separated by
    // a comma. We split on the comma after the last numeric column.
    let bit_map: &[(usize, u32)] = &[
        (0, 6), // Up
        (1, 7), // Down
        (2, 5), // Left
        (3, 4), // Right
        (4, 3), // Start
        (5, 2), // Select
        (6, 1), // B
        (7, 0), // A
        (8, 9), // L
        (9, 8), // R
        // index 10 = Power; no GBA mask bit, ignore.
    ];

    let mut out = Vec::new();
    for line in text.lines() {
        let line = line.trim();
        if !line.starts_with('|') || !line.ends_with('|') {
            continue;
        }
        // Strip leading `|` and trailing `|`, drop the 4 numeric columns
        // (split on `,`, the button bitmap is the last segment), then
        // read button chars.
        let inner = &line[1..line.len() - 1];
        let last_comma = match inner.rfind(',') {
            Some(c) => c,
            None => continue,
        };
        let bitmap = &inner[last_comma + 1..];
        let chars: Vec<char> = bitmap.chars().collect();
        let mut mask: u16 = 0;
        for (idx, bit) in bit_map {
            if let Some(c) = chars.get(*idx) {
                if *c != '.' && *c != ' ' {
                    mask |= 1 << bit;
                }
            }
        }
        out.push(mask);
    }
    Ok(out)
}

/// Resolve the (inputs, optional savestate bytes) tuple from either
/// a bk2 file, or from a separate --input/--state pair (legacy).
fn resolve_replay_source(
    bk2_path: Option<&str>,
    input_path: Option<&str>,
    state_path: Option<&str>,
) -> Result<(Vec<u16>, Option<Vec<u8>>, String), String> {
    if let Some(p) = bk2_path {
        let (inputs, state) = load_bk2(p)?;
        return Ok((inputs, state, p.to_string()));
    }
    let ip = input_path.ok_or_else(|| "--input or --bk2 required".to_string())?;
    let inputs = load_input_file(ip)?;
    let state = match state_path {
        Some(sp) => Some(fs::read(sp).map_err(|e| format!("read {sp}: {e}"))?),
        None => None,
    };
    Ok((inputs, state, ip.to_string()))
}

/// Per-frame hashing pass.
fn run_hash(
    rom: &str,
    bk2_path: Option<&str>,
    input_path: Option<&str>,
    state_path: Option<&str>,
    frames: Option<u32>,
    out: &str,
) -> Result<(), String> {
    let (inputs, state_bytes, src_label) =
        resolve_replay_source(bk2_path, input_path, state_path)?;
    let n = frames.map(|f| f as usize).unwrap_or(inputs.len()).min(inputs.len());

    let core = Core::new(rom)?;
    if let Some(b) = &state_bytes {
        core.load_savestate_from_bytes(b, &src_label)?;
    }

    let f = File::create(out).map_err(|e| format!("create {out}: {e}"))?;
    let mut w = BufWriter::new(f);
    writeln!(w, "# bn6f-validate hash run").map_err(|e| e.to_string())?;
    writeln!(w, "# rom: {rom}").ok();
    writeln!(w, "# source: {src_label}").ok();
    writeln!(w, "# frames: {n}").ok();
    writeln!(w, "# format: <frame_index> <sha256_hex>").ok();

    let t0 = Instant::now();
    for i in 0..n {
        let mask = inputs[i] as u32;
        core.run_frame(mask);
        let h = core.hash_frame();
        let hex = hex32(&h);
        writeln!(w, "{i} {hex}").map_err(|e| e.to_string())?;
    }
    eprintln!(
        "hash: {} frames in {:.2}s → {out}",
        n,
        t0.elapsed().as_secs_f64()
    );
    Ok(())
}

fn hex32(b: &[u8; 32]) -> String {
    const C: &[u8; 16] = b"0123456789abcdef";
    let mut s = String::with_capacity(64);
    for &x in b {
        s.push(C[(x >> 4) as usize] as char);
        s.push(C[(x & 0xF) as usize] as char);
    }
    s
}

/// mp4 render pass (libx264 CRF 28). Separate from hashing because
/// the encoder is non-deterministic; if you want both, use `both`.
fn run_video(
    rom: &str,
    bk2_path: Option<&str>,
    input_path: Option<&str>,
    state_path: Option<&str>,
    frames: Option<u32>,
    out: &str,
) -> Result<(), String> {
    let (inputs, state_bytes, src_label) =
        resolve_replay_source(bk2_path, input_path, state_path)?;
    let n = frames.map(|f| f as usize).unwrap_or(inputs.len()).min(inputs.len());

    let core = Core::new(rom)?;
    if let Some(b) = &state_bytes {
        core.load_savestate_from_bytes(b, &src_label)?;
    }
    core.set_frameskip(0);

    let mut enc = open_video_encoder(&core, out)?;

    let t0 = Instant::now();
    for i in 0..n {
        let mask = inputs[i] as u32;
        core.run_frame(mask);
    }
    close_video_encoder(&mut enc);
    eprintln!(
        "video: {} frames in {:.2}s → {out}",
        n,
        t0.elapsed().as_secs_f64()
    );
    Ok(())
}

/// Single-pass hash + video.
fn run_both(
    rom: &str,
    bk2_path: Option<&str>,
    input_path: Option<&str>,
    state_path: Option<&str>,
    frames: Option<u32>,
    hashes_out: &str,
    video_out: &str,
) -> Result<(), String> {
    let (inputs, state_bytes, src_label) =
        resolve_replay_source(bk2_path, input_path, state_path)?;
    let n = frames.map(|f| f as usize).unwrap_or(inputs.len()).min(inputs.len());

    let core = Core::new(rom)?;
    if let Some(b) = &state_bytes {
        core.load_savestate_from_bytes(b, &src_label)?;
    }
    core.set_frameskip(0);

    let mut enc = open_video_encoder(&core, video_out)?;
    let f = File::create(hashes_out).map_err(|e| format!("create {hashes_out}: {e}"))?;
    let mut w = BufWriter::new(f);
    writeln!(w, "# bn6f-validate hash run").ok();
    writeln!(w, "# rom: {rom}").ok();
    writeln!(w, "# source: {src_label}").ok();
    writeln!(w, "# frames: {n}").ok();
    writeln!(w, "# format: <frame_index> <sha256_hex>").ok();

    let t0 = Instant::now();
    for i in 0..n {
        let mask = inputs[i] as u32;
        core.run_frame(mask);
        let h = core.hash_frame();
        let hex = hex32(&h);
        writeln!(w, "{i} {hex}").map_err(|e| e.to_string())?;
    }
    close_video_encoder(&mut enc);
    eprintln!(
        "both: {} frames in {:.2}s → hashes={hashes_out}, video={video_out}",
        n,
        t0.elapsed().as_secs_f64()
    );
    Ok(())
}

fn open_video_encoder(
    core: &Core,
    out_path: &str,
) -> Result<Box<mgba_sys::FFmpegEncoder>, String> {
    let mut enc: Box<mgba_sys::FFmpegEncoder> =
        unsafe { Box::new(MaybeUninit::zeroed().assume_init()) };
    let out_c = CString::new(out_path).map_err(|e| e.to_string())?;
    let vcodec = CString::new("libx264").unwrap();
    let acodec = CString::new("aac").unwrap();
    let container = CString::new("mp4").unwrap();
    unsafe {
        mgba_sys::FFmpegEncoderInit(&mut *enc as *mut _);
        // -vbr is CRF; -28 = CRF 28 ~ small files, good enough quality.
        if !mgba_sys::FFmpegEncoderSetVideo(
            &mut *enc as *mut _,
            vcodec.as_ptr(),
            -28,
            0,
        ) {
            return Err("FFmpegEncoderSetVideo failed".into());
        }
        if !mgba_sys::FFmpegEncoderSetAudio(
            &mut *enc as *mut _,
            acodec.as_ptr(),
            128_000,
        ) {
            return Err("FFmpegEncoderSetAudio failed".into());
        }
        if !mgba_sys::FFmpegEncoderSetContainer(
            &mut *enc as *mut _,
            container.as_ptr(),
        ) {
            return Err("FFmpegEncoderSetContainer failed".into());
        }
        mgba_sys::FFmpegEncoderSetDimensions(&mut *enc as *mut _, GBA_W as i32, GBA_H as i32);
        mgba_sys::FFmpegEncoderSetInputSampleRate(&mut *enc as *mut _, 32_768);
        if !mgba_sys::FFmpegEncoderOpen(&mut *enc as *mut _, out_c.as_ptr()) {
            return Err(format!("FFmpegEncoderOpen failed for {out_path}"));
        }
        let set_av = (*core.raw).setAVStream.expect("setAVStream");
        set_av(core.raw, &mut enc.d as *mut _);
    }
    Ok(enc)
}

fn close_video_encoder(enc: &mut Box<mgba_sys::FFmpegEncoder>) {
    unsafe {
        mgba_sys::FFmpegEncoderClose(&mut **enc as *mut _);
    }
}

/// Diff two hash files line-by-line.
/// Returns (total_frames, first_diff_frame_opt, total_diff_count).
fn run_compare(orig: &str, patched: &str) -> Result<i32, String> {
    let a = BufReader::new(File::open(orig).map_err(|e| format!("open {orig}: {e}"))?);
    let b = BufReader::new(File::open(patched).map_err(|e| format!("open {patched}: {e}"))?);

    let parse = |line: &str| -> Option<(u64, String)> {
        if line.starts_with('#') || line.is_empty() {
            return None;
        }
        let mut it = line.split_whitespace();
        let idx: u64 = it.next()?.parse().ok()?;
        let hex = it.next()?.to_string();
        Some((idx, hex))
    };

    let mut a_lines = a.lines().filter_map(|l| l.ok()).filter_map(|l| parse(&l));
    let mut b_lines = b.lines().filter_map(|l| l.ok()).filter_map(|l| parse(&l));

    let mut total = 0u64;
    let mut diffs = 0u64;
    let mut first_diff: Option<u64> = None;
    loop {
        match (a_lines.next(), b_lines.next()) {
            (Some((ai, ah)), Some((bi, bh))) => {
                total += 1;
                if ai != bi {
                    return Err(format!(
                        "frame index mismatch at row {total}: {ai} vs {bi}"
                    ));
                }
                if ah != bh {
                    diffs += 1;
                    if first_diff.is_none() {
                        first_diff = Some(ai);
                    }
                }
            }
            (None, None) => break,
            (Some((ai, _)), None) => {
                return Err(format!(
                    "orig has more frames than patched (orig still at {ai})"
                ));
            }
            (None, Some((bi, _))) => {
                return Err(format!(
                    "patched has more frames than orig (patched still at {bi})"
                ));
            }
        }
    }

    match first_diff {
        None => {
            println!("RESULT: pass frames={total}");
            Ok(0)
        }
        Some(f) => {
            println!(
                "RESULT: fail frames={total} first_diff={f} diff_count={diffs}"
            );
            Ok(1)
        }
    }
}

fn usage(prog: &str) -> ! {
    eprintln!(
        "\nbn6f-validate — per-frame pixel-hash and video-render harness\n\n\
         Usage:\n\
           {prog} hash    ROM --input PATH [--state PATH] [--frames N] --out PATH\n\
           {prog} video   ROM --input PATH [--state PATH] [--frames N] --out PATH\n\
           {prog} both    ROM --input PATH [--state PATH] [--frames N] --hashes PATH --video PATH\n\
           {prog} compare ORIG.txt PATCHED.txt\n\
           {prog} run     [--start N] [--end N] [--patch NAME]... [-j N]\n\
                          [--videos] [--no-build]\n\n\
         hash    Emit per-frame SHA256 of framebuffer RGB → text file.\n\
                 The reliable correctness signal (encoder-free).\n\
         video   Render libx264 CRF 28 mp4 for visual review.\n\
                 Encoder is non-deterministic; treat as visual aid only.\n\
         both    Single emulator pass producing both outputs.\n\
         compare Diff two hash files. Exit 0 = identical, 1 = differ.\n\
         run     Orchestrator. Builds orig + per-patch ROMs sequentially,\n\
                 hashes (rom x bk2) in parallel with j workers, compares\n\
                 each patch's hashes to orig's. CSV at build/validate_results.csv.\n"
    );
    process::exit(2);
}

/// No-op for now. mGBA's HLE BIOS will print every SWI to stderr;
/// the Python driver redirects 2>/dev/null when running per-patch
/// jobs in bulk. Direct CLI use just lives with the spam.
fn silence_libmgba() {}

fn main() {
    silence_libmgba();
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        usage(&args[0]);
    }
    match args[1].as_str() {
        "hash" | "video" | "both" => {
            let rom = args.get(2).unwrap_or_else(|| usage(&args[0])).clone();
            let mut bk2_path: Option<String> = None;
            let mut input_path: Option<String> = None;
            let mut state_path: Option<String> = None;
            let mut frames: Option<u32> = None;
            let mut out: Option<String> = None;
            let mut hashes_out: Option<String> = None;
            let mut video_out: Option<String> = None;
            let mut i = 3;
            while i < args.len() {
                match args[i].as_str() {
                    "--bk2"   => { bk2_path = args.get(i+1).cloned(); i += 2; }
                    "--input" => { input_path = args.get(i+1).cloned(); i += 2; }
                    "--state" => { state_path = args.get(i+1).cloned(); i += 2; }
                    "--frames" => {
                        frames = args.get(i+1).and_then(|s| s.parse().ok());
                        i += 2;
                    }
                    "--out" => { out = args.get(i+1).cloned(); i += 2; }
                    "--hashes" => { hashes_out = args.get(i+1).cloned(); i += 2; }
                    "--video" => { video_out = args.get(i+1).cloned(); i += 2; }
                    other => {
                        eprintln!("unknown flag: {other}");
                        usage(&args[0]);
                    }
                }
            }
            if bk2_path.is_none() && input_path.is_none() {
                eprintln!("--bk2 or --input required");
                usage(&args[0]);
            }
            let res = match args[1].as_str() {
                "hash" => {
                    let out = out.unwrap_or_else(|| {
                        eprintln!("--out required"); usage(&args[0]);
                    });
                    run_hash(&rom, bk2_path.as_deref(), input_path.as_deref(),
                             state_path.as_deref(), frames, &out)
                }
                "video" => {
                    let out = out.unwrap_or_else(|| {
                        eprintln!("--out required"); usage(&args[0]);
                    });
                    run_video(&rom, bk2_path.as_deref(), input_path.as_deref(),
                              state_path.as_deref(), frames, &out)
                }
                "both" => {
                    let h = hashes_out.unwrap_or_else(|| {
                        eprintln!("--hashes required"); usage(&args[0]);
                    });
                    let v = video_out.unwrap_or_else(|| {
                        eprintln!("--video required"); usage(&args[0]);
                    });
                    run_both(&rom, bk2_path.as_deref(), input_path.as_deref(),
                             state_path.as_deref(), frames, &h, &v)
                }
                _ => unreachable!(),
            };
            if let Err(e) = res {
                eprintln!("error: {e}");
                process::exit(1);
            }
        }
        "compare" => {
            let orig = args.get(2).unwrap_or_else(|| usage(&args[0]));
            let patched = args.get(3).unwrap_or_else(|| usage(&args[0]));
            match run_compare(orig, patched) {
                Ok(c) => process::exit(c),
                Err(e) => {
                    eprintln!("error: {e}");
                    process::exit(2);
                }
            }
        }
        "run" => {
            let mut start: Option<usize> = None;
            let mut end: Option<usize> = None;
            let mut patches: Vec<String> = Vec::new();
            let mut jobs: usize = std::thread::available_parallelism()
                .map(|n| n.get())
                .unwrap_or(4);
            let mut videos = false;
            let mut no_build = false;
            let mut i = 2;
            while i < args.len() {
                match args[i].as_str() {
                    "--start" => {
                        start = args.get(i + 1).and_then(|s| s.parse().ok());
                        i += 2;
                    }
                    "--end" => {
                        end = args.get(i + 1).and_then(|s| s.parse().ok());
                        i += 2;
                    }
                    "--patch" => {
                        if let Some(p) = args.get(i + 1) {
                            patches.push(p.clone());
                        }
                        i += 2;
                    }
                    "-j" | "--jobs" => {
                        jobs = args.get(i + 1).and_then(|s| s.parse().ok()).unwrap_or(jobs);
                        i += 2;
                    }
                    "--videos" => {
                        videos = true;
                        i += 1;
                    }
                    "--no-build" => {
                        no_build = true;
                        i += 1;
                    }
                    _ => {
                        eprintln!("unknown arg: {}", args[i]);
                        usage(&args[0]);
                    }
                }
            }
            let exe = std::env::current_exe()
                .unwrap_or_else(|_| std::path::PathBuf::from(&args[0]));
            let res = orchestrate::run(orchestrate::RunArgs {
                start,
                end,
                patches,
                jobs,
                videos,
                no_build,
                exe,
            });
            if let Err(e) = res {
                eprintln!("error: {e}");
                process::exit(1);
            }
        }
        _ => usage(&args[0]),
    }
}

// libc for O_RDONLY only; no other libc deps.
mod libc {
    pub const O_RDONLY: i32 = 0;
}

// Read-from-path helper retained for any future stdin-style paths.
#[allow(dead_code)]
fn read_all(path: &Path) -> std::io::Result<Vec<u8>> {
    let mut f = fs::File::open(path)?;
    let mut v = Vec::new();
    f.read_to_end(&mut v)?;
    Ok(v)
}
