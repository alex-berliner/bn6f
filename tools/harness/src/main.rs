//! bn6f-harness — validation harness, built from first principles.
//!
//! B0 (current): create an mGBA core, load the ROM and the *real* BIOS, reset,
//! and confirm the ROM is mapped by reading its title off the bus. No frames,
//! hashing, or traces yet — those are later bricks.
//!
//! All `unsafe` lives in the `emu` wrapper over libmgba's FFI (`sys`); this
//! file is safe Rust orchestration only.
//!
//! Usage:
//!   bn6f-harness [ROM] [BIOS]
//!   defaults: ROM=build/bn6f.gba  BIOS=/home/alex/gbabiosworld.bin

mod emu;
mod sys;

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
    let mut core = emu::Core::new(rom)?;
    core.load_bios(bios)?;
    core.reset()?;

    println!("OK: core up, ROM + real BIOS loaded, reset complete.");
    println!("  rom:   {rom}");
    println!("  bios:  {bios}");
    println!("  title: {:?}", core.rom_title());
    Ok(())
}
