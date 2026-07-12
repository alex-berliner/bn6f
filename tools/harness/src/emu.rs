//! Safe wrapper over the libmgba core.
//!
//! Project rule: keep `unsafe` minimal and contained. Every `unsafe` block in
//! the harness lives here, each scoped to a single FFI operation with a
//! `SAFETY:` note. The rest of the harness builds on the safe API below.
//!
//! Invariant upheld by this type: `raw` is a non-null, initialized `mCore` for
//! the whole lifetime of the `Core`. That invariant is what lets these methods
//! present a safe interface despite calling raw FFI internally.

use crate::sys;
use std::ffi::CString;

pub struct Core {
    raw: *mut sys::mCore,
}

impl Core {
    /// Create an mGBA core for `rom_path` (mGBA dispatches by file content),
    /// initialize it, require the real BIOS (no HLE skip), and load the ROM.
    pub fn new(rom_path: &str) -> Result<Self, String> {
        silence_default_logger();
        let rom_c = CString::new(rom_path).map_err(|e| e.to_string())?;

        // SAFETY: mCoreFind takes a valid C string; returns a core ptr or null.
        let raw = unsafe { sys::mCoreFind(rom_c.as_ptr()) };
        if raw.is_null() {
            return Err(format!("mCoreFind returned null for {rom_path} (unrecognised ROM?)"));
        }

        // SAFETY: raw is non-null; `init` is its optional initializer fn ptr.
        let init = unsafe { (*raw).init }.ok_or("mCore.init is null")?;
        // SAFETY: init is this core's own initializer, called once on raw.
        if !unsafe { init(raw) } {
            return Err("mCore.init() returned false".into());
        }
        // SAFETY: raw is now an initialized core; set up its config struct.
        unsafe { sys::mCoreInitConfig(raw, std::ptr::null()) };

        // Invariant established (non-null + initialized): wrap it.
        let mut core = Core { raw };

        // Second invariant: the platform is GBA, so `(*raw).cpu` is an
        // ARMCore — that's what lets pc()/lr()/cpsr() cast it safely.
        // SAFETY: type invariant; platform is the core's own fn ptr.
        let platform = unsafe { (*raw).platform }.ok_or("mCore.platform is null")?;
        // SAFETY: pure query on a valid core.
        if unsafe { platform(raw) } != sys::mPlatform_mPLATFORM_GBA {
            return Err("core is not a GBA core".into());
        }

        core.set_config_int("useBios", 1); // require the real BIOS...
        core.set_config_int("skipBios", 0); // ...never HLE
        core.load_rom(rom_path)?;
        Ok(core)
    }

    fn set_config_int(&mut self, key: &str, val: i32) {
        let k = CString::new(key).expect("config key has no interior NUL");
        // SAFETY: type invariant on self.raw; k is a valid C string for the call.
        unsafe { sys::mCoreConfigSetIntValue(&mut (*self.raw).config, k.as_ptr(), val) };
    }

    fn load_rom(&mut self, path: &str) -> Result<(), String> {
        let p = CString::new(path).map_err(|e| e.to_string())?;
        // SAFETY: type invariant; loadROM is the core's own optional fn ptr.
        let load = unsafe { (*self.raw).loadROM }.ok_or("mCore.loadROM is null")?;
        // SAFETY: p is a valid C string for the duration of the open.
        let vf = unsafe { sys::VFileOpen(p.as_ptr(), 0 /* O_RDONLY */) };
        if vf.is_null() {
            return Err(format!("VFileOpen failed for ROM {path}"));
        }
        // SAFETY: load is the core's loader; vf is a fresh VFile it takes over.
        if !unsafe { load(self.raw, vf) } {
            return Err(format!("loadROM() returned false for {path}"));
        }
        Ok(())
    }

    /// Load the BIOS image from `path` (biosID 0 = the only GBA BIOS).
    ///
    /// Gate, not convention: refuses anything that fails the never-HLE check
    /// (official-BIOS size + CRC32) before the core ever sees it. [F6e, F7c]
    pub fn load_bios(&mut self, path: &str) -> Result<(), String> {
        crate::bios::verify(path)?;
        let p = CString::new(path).map_err(|e| e.to_string())?;
        // SAFETY: type invariant; loadBIOS is the core's own optional fn ptr.
        let load = unsafe { (*self.raw).loadBIOS }.ok_or("mCore.loadBIOS is null")?;
        // SAFETY: p is a valid C string for the duration of the open.
        let vf = unsafe { sys::VFileOpen(p.as_ptr(), 0 /* O_RDONLY */) };
        if vf.is_null() {
            return Err(format!("VFileOpen failed for BIOS {path}"));
        }
        // SAFETY: load is the core's BIOS loader; vf is a fresh VFile it takes over.
        if !unsafe { load(self.raw, vf, 0) } {
            return Err(format!("loadBIOS() returned false for {path}"));
        }
        Ok(())
    }

    /// Reset the core. With useBios && !skipBios, boots through the real BIOS.
    pub fn reset(&mut self) -> Result<(), String> {
        // SAFETY: type invariant; reset is the core's own optional fn ptr.
        let reset = unsafe { (*self.raw).reset }.ok_or("mCore.reset is null")?;
        // SAFETY: resetting a valid initialized core.
        unsafe { reset(self.raw) };
        Ok(())
    }

    /// Read one byte from the CPU bus at `addr`.
    pub fn bus_read8(&self, addr: u32) -> u8 {
        // SAFETY: type invariant; busRead8 is the core's own fn ptr.
        let read = unsafe { (*self.raw).busRead8 }.expect("busRead8 is null");
        // SAFETY: read is the core's bus reader; any u32 address is valid input.
        unsafe { read(self.raw, addr) as u8 }
    }

    /// Advance emulation by exactly one video frame.
    pub fn run_frame(&mut self) {
        // SAFETY: type invariant; runFrame is the core's own fn ptr.
        let f = unsafe { (*self.raw).runFrame }.expect("runFrame is null");
        // SAFETY: running one frame on a valid, ROM-loaded, reset core.
        unsafe { f(self.raw) };
    }

    /// Size in bytes of the core's serialized full state.
    pub fn state_size(&self) -> usize {
        // SAFETY: type invariant; stateSize is the core's own fn ptr.
        let f = unsafe { (*self.raw).stateSize }.expect("stateSize is null");
        // SAFETY: pure query on a valid core.
        unsafe { f(self.raw) }
    }

    /// Serialize the full machine state (CPU, memories, IO, timers, video,
    /// audio — the raw mCore state struct; savedata lives outside it).
    pub fn save_state(&mut self) -> Result<Snapshot, String> {
        let len = self.state_size();
        let mut buf = vec![0u64; len.div_ceil(8)];
        // SAFETY: type invariant; saveState is the core's own fn ptr.
        let f = unsafe { (*self.raw).saveState }.ok_or("mCore.saveState is null")?;
        // SAFETY: buf provides >= len writable bytes, 8-aligned (Vec<u64>) —
        // the serializer stores through typed pointers into it.
        if !unsafe { f(self.raw, buf.as_mut_ptr() as *mut std::os::raw::c_void) } {
            return Err("saveState() returned false".into());
        }
        Ok(Snapshot { buf, len })
    }

    /// Restore a state previously produced by `save_state` on a same-ROM core.
    pub fn load_state(&mut self, snap: &Snapshot) -> Result<(), String> {
        let want = self.state_size();
        if snap.len != want {
            return Err(format!("snapshot size {} != core state size {want}", snap.len));
        }
        // SAFETY: type invariant; loadState is the core's own fn ptr.
        let f = unsafe { (*self.raw).loadState }.ok_or("mCore.loadState is null")?;
        // SAFETY: snap.buf holds len initialized, 8-aligned bytes to read from.
        if !unsafe { f(self.raw, snap.buf.as_ptr() as *const std::os::raw::c_void) } {
            return Err("loadState() returned false".into());
        }
        Ok(())
    }

    /// FNV-1a fingerprint of the full serialized state.
    pub fn state_hash(&mut self) -> Result<u64, String> {
        Ok(crate::fnv1a64(self.save_state()?.bytes()))
    }

    /// The GBA's ARM7TDMI. Valid because `new()` asserted mPLATFORM_GBA.
    fn arm(&self) -> *mut sys::ARMCore {
        // SAFETY: type invariant + the platform assert in new(): on a GBA
        // core, `cpu` points at the (initialized) ARMCore for the core's
        // whole lifetime.
        unsafe { (*self.raw).cpu as *mut sys::ARMCore }
    }

    /// CPSR, raw. Bit 5 = Thumb, low 5 bits = privilege mode.
    pub fn cpsr(&self) -> u32 {
        // SAFETY: arm() is valid; `packed` reads the whole PSR union.
        unsafe { (*self.arm()).__bindgen_anon_1.__bindgen_anon_1.cpsr.packed as u32 }
    }

    pub fn is_thumb(&self) -> bool {
        self.cpsr() & 0x20 != 0
    }

    /// General-purpose register `n` (0..=15). r15 is the raw pipeline PC.
    pub fn gpr(&self, n: usize) -> u32 {
        assert!(n < 16, "gpr index {n}");
        // SAFETY: arm() is valid; gprs is a fixed [i32; 16].
        unsafe { (*self.arm()).__bindgen_anon_1.__bindgen_anon_1.gprs[n] as u32 }
    }

    /// Address of the next instruction the CPU will execute.
    ///
    /// At an instruction boundary mGBA keeps r15 one fetch ahead (ARMWritePC
    /// leaves r15 = target + width; the second pipeline advance happens
    /// inside the step), so exec = r15 - width. Pinned empirically by the B2
    /// test: pc() == 0x00000000 at reset.
    pub fn pc(&self) -> u32 {
        let width = if self.is_thumb() { 2 } else { 4 };
        self.gpr(15).wrapping_sub(width)
    }

    /// Link register (return address as the CPU sees it, Thumb bit included).
    pub fn lr(&self) -> u32 {
        self.gpr(14)
    }

    /// Execute exactly one CPU instruction (events included, mGBA `step`).
    pub fn step(&mut self) {
        // SAFETY: type invariant; step is the core's own fn ptr.
        let f = unsafe { (*self.raw).step }.expect("step is null");
        // SAFETY: stepping a valid, ROM-loaded, reset core.
        unsafe { f(self.raw) };
    }

    /// Step until the next instruction to execute is at `target` (Thumb bit
    /// ignored). Checks before stepping, so a core already at `target` takes
    /// 0 steps. Returns the number of steps taken; errors if `max_steps`
    /// isn't enough — never runs unbounded.
    pub fn run_to_pc(&mut self, target: u32, max_steps: u64) -> Result<u64, String> {
        let target = target & !1;
        for taken in 0..=max_steps {
            if self.pc() == target {
                return Ok(taken);
            }
            self.step();
        }
        Err(format!(
            "run_to_pc: {target:#010x} not reached within {max_steps} steps (pc now {:#010x})",
            self.pc()
        ))
    }

    /// Serialize in *canonical* form: save → load → save.
    ///
    /// mGBA's deserializer recomputes a handful of derived audio-scheduler
    /// fields instead of trusting the image (PSG ch1/ch2 envelope timing and
    /// last-update stamps — serialize.h offsets 0x00130–0x00153; measured: 8
    /// bytes differ, nothing propagates). A state that has crossed a restore
    /// therefore never byte-matches one that hasn't, even when emulation is
    /// identical. Canonicalizing both sides before comparing keeps parity
    /// exact over all authoritative state — nothing is masked; the derived
    /// fields are compared in recomputed form. The extra load is a real
    /// restore, so this mutates nothing observable (asserted by the
    /// idempotence test in lib.rs).
    pub fn canonical_state(&mut self) -> Result<Snapshot, String> {
        let s = self.save_state()?;
        self.load_state(&s)?;
        self.save_state()
    }

    /// FNV-1a fingerprint of the canonical serialized state — use this
    /// whenever the states being compared may differ in restore history.
    pub fn canonical_hash(&mut self) -> Result<u64, String> {
        Ok(crate::fnv1a64(self.canonical_state()?.bytes()))
    }

    /// Cartridge-header game title (offset 0x0A0, up to 12 bytes) read off the
    /// bus — confirms the ROM is genuinely mapped, not merely accepted by load.
    pub fn rom_title(&self) -> String {
        let mut bytes = Vec::new();
        for i in 0..12u32 {
            let b = self.bus_read8(0x0800_00A0 + i);
            if b == 0 {
                break;
            }
            bytes.push(b);
        }
        String::from_utf8_lossy(&bytes).into_owned()
    }
}

/// mGBA's default logger prints every core message to stdout; route it to a
/// no-op instead so harness/test output stays readable. Idempotent.
fn silence_default_logger() {
    static ONCE: std::sync::Once = std::sync::Once::new();
    ONCE.call_once(|| {
        unsafe extern "C" fn noop(
            _logger: *mut sys::mLogger,
            _category: std::os::raw::c_int,
            _level: sys::mLogLevel,
            _format: *const std::os::raw::c_char,
            _args: *mut sys::__va_list_tag,
        ) {
        }
        static mut SILENT: sys::mLogger = sys::mLogger {
            log: Some(noop as _),
            filter: std::ptr::null_mut(),
        };
        // SAFETY: SILENT lives for the program; mGBA only calls its fn ptr.
        unsafe { sys::mLogSetDefaultLogger(std::ptr::addr_of_mut!(SILENT)) };
    });
}

/// Full serialized core state. Storage is `Vec<u64>` so the buffer is
/// 8-aligned — the mGBA serializer reads/writes it through typed pointers.
pub struct Snapshot {
    buf: Vec<u64>,
    len: usize,
}

impl Snapshot {
    pub fn bytes(&self) -> &[u8] {
        // SAFETY: buf owns >= len bytes, all initialized (zero-filled at
        // alloc, then written by saveState); u64 storage reads fine as bytes.
        unsafe { std::slice::from_raw_parts(self.buf.as_ptr() as *const u8, self.len) }
    }

    pub fn len(&self) -> usize {
        self.len
    }

    pub fn is_empty(&self) -> bool {
        self.len == 0
    }
}

impl Drop for Core {
    fn drop(&mut self) {
        // SAFETY: type invariant — raw is a valid core; deinit frees it once.
        if let Some(deinit) = unsafe { (*self.raw).deinit } {
            // SAFETY: deinit is the core's own teardown, called once at drop.
            unsafe { deinit(self.raw) };
        }
    }
}
