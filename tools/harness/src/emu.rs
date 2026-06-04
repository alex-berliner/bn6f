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
    pub fn load_bios(&mut self, path: &str) -> Result<(), String> {
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

impl Drop for Core {
    fn drop(&mut self) {
        // SAFETY: type invariant — raw is a valid core; deinit frees it once.
        if let Some(deinit) = unsafe { (*self.raw).deinit } {
            // SAFETY: deinit is the core's own teardown, called once at drop.
            unsafe { deinit(self.raw) };
        }
    }
}
