//! bn6f-harness — validation harness rebuilt from first principles.
//!
//! Brick -1 (the smallest possible start): create an mGBA core, load the
//! ROM and the *real* BIOS, and reset. No frames, no hashing, no traces yet.
//! The only thing this proves is that the substrate comes up and the ROM is
//! actually mapped on the bus. Everything else builds on top of this.
//!
//! Usage:
//!   bn6f-harness [ROM] [BIOS]
//!   defaults: ROM=build/bn6f.gba  BIOS=/home/alex/gbabiosworld.bin

#![allow(non_upper_case_globals, non_camel_case_types, non_snake_case, dead_code)]

mod mgba_sys {
    include!(concat!(env!("OUT_DIR"), "/mgba_sys.rs"));
}

use std::ffi::CString;

const DEFAULT_ROM: &str = "build/bn6f.gba";
const DEFAULT_BIOS: &str = "/home/alex/gbabiosworld.bin";

fn main() {
    let mut args = std::env::args().skip(1);
    let rom = args.next().unwrap_or_else(|| DEFAULT_ROM.into());
    let bios = args.next().unwrap_or_else(|| DEFAULT_BIOS.into());

    if let Err(e) = run(&rom, &bios) {
        eprintln!("error: {e}");
        std::process::exit(1);
    }
}

fn run(rom: &str, bios: &str) -> Result<(), String> {
    unsafe {
        let rom_c = CString::new(rom).map_err(|e| e.to_string())?;
        let bios_c = CString::new(bios).map_err(|e| e.to_string())?;

        // 1. Create a core for this ROM (mGBA dispatches by file content).
        let core = mgba_sys::mCoreFind(rom_c.as_ptr());
        if core.is_null() {
            return Err(format!("mCoreFind returned null for {rom} (unrecognised ROM?)"));
        }

        // 2. Initialise the core.
        let init = (*core).init.ok_or("mCore.init is null")?;
        if !init(core) {
            return Err("mCore.init() returned false".into());
        }

        // 3. Config: insist on the real BIOS, no HLE skip. (The old harness
        //    skipped BIOS; we never will — see cyow Feature 6e / 7c.)
        mgba_sys::mCoreInitConfig(core, std::ptr::null());
        set_cfg_int(core, "useBios", 1);
        set_cfg_int(core, "skipBios", 0);

        // 4. Load the ROM.
        let load_rom = (*core).loadROM.ok_or("mCore.loadROM is null")?;
        let rom_vf = mgba_sys::VFileOpen(rom_c.as_ptr(), 0 /* O_RDONLY */);
        if rom_vf.is_null() {
            return Err(format!("VFileOpen failed for ROM {rom}"));
        }
        if !load_rom(core, rom_vf) {
            return Err(format!("loadROM() returned false for {rom}"));
        }

        // 5. Load the real BIOS (biosID 0 = the only GBA BIOS).
        let load_bios = (*core).loadBIOS.ok_or("mCore.loadBIOS is null")?;
        let bios_vf = mgba_sys::VFileOpen(bios_c.as_ptr(), 0 /* O_RDONLY */);
        if bios_vf.is_null() {
            return Err(format!("VFileOpen failed for BIOS {bios}"));
        }
        if !load_bios(core, bios_vf, 0) {
            return Err(format!("loadBIOS() returned false for {bios}"));
        }

        // 6. Reset. With useBios && !skipBios the CPU boots through the real
        //    BIOS boot sequence rather than jumping straight to the cart.
        let reset = (*core).reset.ok_or("mCore.reset is null")?;
        reset(core);

        // Prove the cart is actually mapped: read the 12-byte game title from
        // the cartridge header at 0x080000A0.
        let title = read_rom_title(core);

        println!("OK: core up, ROM + real BIOS loaded, reset complete.");
        println!("  rom:   {rom}");
        println!("  bios:  {bios}");
        println!("  title: {title:?}");

        // 7. Teardown.
        if let Some(deinit) = (*core).deinit {
            deinit(core);
        }
    }
    Ok(())
}

unsafe fn set_cfg_int(core: *mut mgba_sys::mCore, key: &str, val: i32) {
    let k = CString::new(key).unwrap();
    mgba_sys::mCoreConfigSetIntValue(&mut (*core).config, k.as_ptr(), val);
}

/// Read the cartridge-header game title (offset 0x0A0, up to 12 bytes) via the
/// CPU bus — confirms the ROM is genuinely mapped, not just accepted by loadROM.
unsafe fn read_rom_title(core: *mut mgba_sys::mCore) -> String {
    let read8 = (*core).busRead8.expect("busRead8 is null");
    let mut bytes = Vec::new();
    for i in 0..12u32 {
        let b = read8(core, 0x0800_00A0 + i) as u8;
        if b == 0 {
            break;
        }
        bytes.push(b);
    }
    String::from_utf8_lossy(&bytes).into_owned()
}
