//! bn6f-harness CLI — boots the substrate and prints its vitals.
//!
//! The real guarantees live in `cargo test` (B0/B1 bricks); this binary is a
//! quick smoke run of the same library surface.
//!
//! Usage:
//!   bn6f-harness [ROM] [BIOS]
//!   ROM default:  <repo>/build/bn6f.gba
//!   BIOS default: $BN6F_BIOS, else the documented local fallback; whatever
//!   resolves must pass the never-HLE gate (official size + CRC32) to load.

use bn6f_harness::{bios, emu};

fn main() {
    let mut args = std::env::args().skip(1);
    let rom = args.next().unwrap_or_else(|| bn6f_harness::DEFAULT_ROM.into());
    let bios = args.next().or_else(bios::find).unwrap_or_else(|| {
        eprintln!("error: no BIOS found — set BN6F_BIOS or pass a path as arg 2");
        std::process::exit(1);
    });

    if let Err(e) = run(&rom, &bios) {
        eprintln!("error: {e}");
        std::process::exit(1);
    }
}

fn run(rom: &str, bios: &str) -> Result<(), String> {
    let mut core = emu::Core::new(rom)?;
    core.load_bios(bios)?;
    core.reset()?;

    println!("OK: core up, ROM + verified real BIOS loaded, reset complete.");
    println!("  rom:   {rom}");
    println!("  bios:  {bios} (official, crc32 verified)");
    println!("  title: {:?}", core.rom_title());

    for _ in 0..60 {
        core.run_frame();
    }
    println!("  state: {} bytes, hash {:#018x} after 60 frames", core.state_size(), core.state_hash()?);
    Ok(())
}
