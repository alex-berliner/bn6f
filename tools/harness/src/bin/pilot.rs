//! pilot — drive the game with a scripted keypad, watch it via screenshots.
//!
//! This is the harness-native fixture recorder: an input script replayed
//! against the deterministic core (B1) *is* a recording. Screenshots let a
//! human — or an agent — see the game to decide the next inputs.
//!
//! Script format (one directive per line, `#` comments):
//!   hold <frame> <KEYS|->    set the held keypad from this frame ('-' none)
//!   tap <frame> <KEYS>       press KEYS for 2 frames on top of the current
//!                            hold, then release back to it
//!   end <frame>              total frames to run (required, last)
//! KEYS: '+'-joined from A B START SELECT UP DOWN LEFT RIGHT L R
//!
//! Usage:
//!   pilot --script f.inputs [--from state.bin] [--save-state out.bin]
//!         [--png out.png] [--png-every N:dir] [--rom path] [--bios path]

use bn6f_harness::emu::{Core, Snapshot, VIDEO_H, VIDEO_W};
use bn6f_harness::{bios, DEFAULT_ROM};

fn key_bit(name: &str) -> Result<u16, String> {
    Ok(match name {
        "A" => 1 << 0,
        "B" => 1 << 1,
        "SELECT" => 1 << 2,
        "START" => 1 << 3,
        "RIGHT" => 1 << 4,
        "LEFT" => 1 << 5,
        "UP" => 1 << 6,
        "DOWN" => 1 << 7,
        "R" => 1 << 8,
        "L" => 1 << 9,
        other => return Err(format!("unknown key {other:?}")),
    })
}

fn parse_keys(spec: &str) -> Result<u16, String> {
    if spec == "-" {
        return Ok(0);
    }
    spec.split('+').try_fold(0u16, |acc, k| Ok(acc | key_bit(k)?))
}

struct Script {
    /// (frame, absolute key state) — sorted by frame.
    changes: Vec<(u64, u16)>,
    end: u64,
}

fn parse_script(text: &str) -> Result<Script, String> {
    let mut changes: Vec<(u64, u16)> = Vec::new();
    let mut held: u16 = 0;
    let mut end: Option<u64> = None;
    for (ln, raw) in text.lines().enumerate() {
        let line = raw.split('#').next().unwrap().trim();
        if line.is_empty() {
            continue;
        }
        let err = |m: &str| format!("script line {}: {m}: {raw:?}", ln + 1);
        let mut it = line.split_whitespace();
        let verb = it.next().unwrap();
        let frame: u64 = it
            .next()
            .ok_or_else(|| err("missing frame"))?
            .parse()
            .map_err(|_| err("bad frame"))?;
        if let Some((last, _)) = changes.last() {
            if frame < *last {
                return Err(err("frames must be non-decreasing"));
            }
        }
        match verb {
            "hold" => {
                held = parse_keys(it.next().ok_or_else(|| err("missing keys"))?)
                    .map_err(|m| err(&m))?;
                changes.push((frame, held));
            }
            "tap" => {
                let keys = parse_keys(it.next().ok_or_else(|| err("missing keys"))?)
                    .map_err(|m| err(&m))?;
                changes.push((frame, held | keys));
                changes.push((frame + 2, held));
            }
            "end" => end = Some(frame),
            _ => return Err(err("unknown directive")),
        }
    }
    Ok(Script {
        changes,
        end: end.ok_or("script has no `end <frame>` directive")?,
    })
}

fn write_png(path: &str, pixels: &[u32]) -> Result<(), String> {
    let file = std::fs::File::create(path).map_err(|e| format!("{path}: {e}"))?;
    let mut enc = png::Encoder::new(std::io::BufWriter::new(file), VIDEO_W as u32, VIDEO_H as u32);
    enc.set_color(png::ColorType::Rgb);
    enc.set_depth(png::BitDepth::Eight);
    let mut w = enc.write_header().map_err(|e| e.to_string())?;
    let mut rgb = Vec::with_capacity(VIDEO_W * VIDEO_H * 3);
    for p in pixels {
        // mGBA desktop default is 32-bit XRGB.
        rgb.push((p >> 16) as u8);
        rgb.push((p >> 8) as u8);
        rgb.push(*p as u8);
    }
    w.write_image_data(&rgb).map_err(|e| e.to_string())
}

fn arg(args: &[String], name: &str) -> Option<String> {
    args.iter().position(|a| a == name).map(|i| {
        args.get(i + 1)
            .unwrap_or_else(|| panic!("{name} needs a value"))
            .clone()
    })
}

fn main() {
    if let Err(e) = run() {
        eprintln!("error: {e}");
        std::process::exit(1);
    }
}

fn run() -> Result<(), String> {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let script_path = arg(&args, "--script").ok_or("--script is required")?;
    let script = parse_script(
        &std::fs::read_to_string(&script_path).map_err(|e| format!("{script_path}: {e}"))?,
    )?;

    let rom = arg(&args, "--rom").unwrap_or_else(|| DEFAULT_ROM.into());
    let bios = arg(&args, "--bios")
        .or_else(bios::find)
        .ok_or("no BIOS: set BN6F_BIOS or pass --bios")?;

    let mut core = Core::new(&rom)?;
    core.install_video_buffer();
    core.load_bios(&bios)?;
    core.reset()?;
    if let Some(p) = arg(&args, "--from") {
        let bytes = std::fs::read(&p).map_err(|e| format!("{p}: {e}"))?;
        core.load_state(&Snapshot::from_bytes(&bytes))?;
    }

    let png_every: Option<(u64, String)> = arg(&args, "--png-every").map(|spec| {
        let (n, dir) = spec.split_once(':').expect("--png-every N:dir");
        (n.parse().expect("--png-every N must be a number"), dir.to_string())
    });
    // Per-frame frame-hash trace (the oracle's regression artifact, D1): one
    // hex observable_hash per frame. `--check-trace` replays and reports the
    // first frame that diverges from a stored trace instead of writing one.
    let trace_out = arg(&args, "--trace");
    let check_trace: Option<Vec<u64>> = arg(&args, "--check-trace")
        .map(|p| -> Result<Vec<u64>, String> {
            std::fs::read_to_string(&p)
                .map_err(|e| format!("{p}: {e}"))?
                .lines()
                .filter(|l| !l.trim().is_empty() && !l.starts_with('#'))
                .map(|l| u64::from_str_radix(l.trim().trim_start_matches("0x"), 16).map_err(|e| e.to_string()))
                .collect()
        })
        .transpose()?;
    let mut trace: Vec<u64> = Vec::new();

    let mut next_change = 0usize;
    for frame in 0..script.end {
        while next_change < script.changes.len() && script.changes[next_change].0 == frame {
            core.set_keys(script.changes[next_change].1);
            next_change += 1;
        }
        core.run_frame();
        if trace_out.is_some() || check_trace.is_some() {
            let h = core.observable_hash();
            if let Some(expected) = &check_trace {
                let want = expected.get(frame as usize).copied();
                if want != Some(h) {
                    return Err(format!(
                        "trace mismatch at frame {frame}: got {h:#018x}, expected {}",
                        want.map(|w| format!("{w:#018x}")).unwrap_or_else(|| "(past end of trace)".into())
                    ));
                }
            }
            trace.push(h);
        }
        if let Some((n, dir)) = &png_every {
            if (frame + 1) % n == 0 {
                write_png(&format!("{dir}/f{:06}.png", frame + 1), core.frame_pixels())?;
            }
        }
    }
    if let Some(p) = &trace_out {
        let body: String = trace.iter().map(|h| format!("{h:016x}\n")).collect();
        std::fs::write(p, body).map_err(|e| format!("{p}: {e}"))?;
    }
    if let Some(expected) = &check_trace {
        if expected.len() != trace.len() {
            return Err(format!(
                "trace length mismatch: replay {} frames, stored {}",
                trace.len(),
                expected.len()
            ));
        }
        println!("trace OK: {} frames match {script_path}", trace.len());
    }

    if let Some(p) = arg(&args, "--png") {
        write_png(&p, core.frame_pixels())?;
    }
    if let Some(p) = arg(&args, "--save-state") {
        std::fs::write(&p, core.save_state()?.bytes()).map_err(|e| format!("{p}: {e}"))?;
    }
    println!(
        "pilot: ran {} frames of {script_path}; state hash {:#018x}",
        script.end,
        core.state_hash()?
    );
    Ok(())
}
