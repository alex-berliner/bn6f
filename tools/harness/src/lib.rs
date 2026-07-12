//! bn6f-harness — validation harness, built from first principles.
//!
//! Library surface: `emu` (the one unsafe FFI wrapper over libmgba), `bios`
//! (the never-HLE gate), and small pure helpers. The `bn6f-harness` binary and
//! the test suite are thin users of this crate.
//!
//! Brick status: B0 (substrate) + B1 (determinism/snapshot fidelity) live
//! here, enforced by `cargo test`. See docs/development_plan.md.

pub mod bios;
pub mod emu;
pub mod sys;

/// Default ROM: <repo>/build/bn6f.gba, resolved relative to this crate
/// (tools/harness) so it works from any cwd.
pub const DEFAULT_ROM: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../build/bn6f.gba");

/// FNV-1a 64-bit. Deterministic across runs/processes (unlike std's SipHash),
/// no dependencies; plenty for state fingerprints (we compare, never store).
pub fn fnv1a64(data: &[u8]) -> u64 {
    let mut h: u64 = 0xcbf2_9ce4_8422_2325;
    for &b in data {
        h ^= b as u64;
        h = h.wrapping_mul(0x0000_0100_0000_01b3);
    }
    h
}

#[cfg(test)]
mod tests {
    use crate::emu::Core;

    const TITLE: &str = "MEGAMAN6_FXX";

    /// ROM + verified-BIOS paths, or None to skip (CI has no BIOS by design;
    /// locally, missing fixtures are an error, not a skip).
    fn fixtures() -> Option<(String, String)> {
        let rom_ok = std::path::Path::new(crate::DEFAULT_ROM).exists();
        match (rom_ok, crate::bios::find()) {
            (true, Some(bios)) => Some((crate::DEFAULT_ROM.into(), bios)),
            _ if std::env::var_os("CI").is_some() => {
                eprintln!("skipping: ROM/BIOS fixtures unavailable in CI");
                None
            }
            (rom_ok, bios) => panic!(
                "fixtures missing (ROM built: {rom_ok}, BIOS: {bios:?}) — \
                 run `make all` and/or set BN6F_BIOS"
            ),
        }
    }

    fn boot(rom: &str, bios: &str) -> Core {
        let mut core = Core::new(rom).expect("core");
        core.load_bios(bios).expect("bios");
        core.reset().expect("reset");
        core
    }

    // B0: substrate loads ROM + real BIOS and the ROM is genuinely mapped.
    #[test]
    fn b0_title_reads_off_bus() {
        let Some((rom, bios)) = fixtures() else { return };
        let core = boot(&rom, &bios);
        assert_eq!(core.rom_title(), TITLE);
    }

    // B0: never-HLE gate — a present-but-unofficial BIOS is refused, with the
    // reason in the error. (Runs in CI too: needs only the ROM + a temp file.)
    #[test]
    fn b0_wrong_bios_refused() {
        if !std::path::Path::new(crate::DEFAULT_ROM).exists() {
            if std::env::var_os("CI").is_some() {
                eprintln!("skipping: ROM not built in CI");
                return;
            }
            panic!("ROM missing — run `make all`");
        }
        let dir = std::env::temp_dir();
        let fake = dir.join("bn6f_harness_fake_bios.bin");
        std::fs::write(&fake, vec![0u8; crate::bios::GBA_BIOS_SIZE]).expect("write fake bios");
        let mut core = Core::new(crate::DEFAULT_ROM).expect("core");
        let err = core
            .load_bios(fake.to_str().unwrap())
            .expect_err("unofficial BIOS must be refused");
        assert!(err.contains("never-HLE"), "refusal must state the gate: {err}");
    }

    // B1a: determinism — two cold boots running the same N frames agree.
    #[test]
    fn b1_same_run_twice_same_hash() {
        let Some((rom, bios)) = fixtures() else { return };
        let hash = |()| {
            let mut core = boot(&rom, &bios);
            for _ in 0..90 {
                core.run_frame();
            }
            core.state_hash().expect("hash")
        };
        assert_eq!(hash(()), hash(()));
    }

    // B1b: snapshot fidelity — restore + continue replays identically.
    // Canonical hashes: the A side never crossed a restore, the B side did,
    // so both are canonicalized before comparing (see emu::canonical_state).
    #[test]
    fn b1_snapshot_restore_continue_same_hash() {
        let Some((rom, bios)) = fixtures() else { return };
        let mut core = boot(&rom, &bios);
        for _ in 0..45 {
            core.run_frame();
        }
        let snap = core.save_state().expect("snapshot");
        for _ in 0..45 {
            core.run_frame();
        }
        let a = core.canonical_hash().expect("hash A");

        core.load_state(&snap).expect("restore");
        for _ in 0..45 {
            core.run_frame();
        }
        let b = core.canonical_hash().expect("hash B");
        assert_eq!(a, b);
    }

    // B1b': canonicalization is a fixed point — one save/load roundtrip
    // reaches it and further roundtrips change nothing. Pins the assumption
    // canonical_state relies on; also regresses mGBA's derived-audio-field
    // recompute staying confined (it was 8 bytes at 0x130..0x153 when
    // measured — if this ever grows teeth, this test is the tripwire).
    #[test]
    fn b1_canonicalization_idempotent() {
        let Some((rom, bios)) = fixtures() else { return };
        let mut core = boot(&rom, &bios);
        for _ in 0..45 {
            core.run_frame();
        }
        let c1 = core.canonical_state().expect("canonical 1");
        let c2 = core.canonical_state().expect("canonical 2");
        assert_eq!(c1.bytes(), c2.bytes(), "canonical form is not a fixed point");
    }

    // B1c: sensitivity self-test — the hash must actually track state.
    #[test]
    fn b1_hash_changes_across_frames() {
        let Some((rom, bios)) = fixtures() else { return };
        let mut core = boot(&rom, &bios);
        for _ in 0..45 {
            core.run_frame();
        }
        let n = core.state_hash().expect("hash N");
        core.run_frame();
        let n1 = core.state_hash().expect("hash N+1");
        assert_ne!(n, n1, "state hash blind: N and N+1 frames hash equal");
    }

    // B2: execution control — stop exactly at a chosen PC, twice over.
    //
    // Symbol-free: scan forward from a snapshot for the first genuine call
    // (BL writeback: LR becomes call-site + width, privilege mode unchanged
    // — rejects IRQ entry, whose LR is banked with a mode switch — and the
    // branch actually left fall-through — rejects `pop {lr}`), requiring an
    // entry PC not already executed in the scan window. Determinism then
    // guarantees the first occurrence of that entry is at exactly step k,
    // so run_to_pc from the restored snapshot must stop there in exactly k
    // steps. Finally the callee must come back to the matching return.
    #[test]
    fn b2_run_to_pc_entry_and_return() {
        let Some((rom, bios)) = fixtures() else { return };
        let mut core = boot(&rom, &bios);
        // Pipeline-math pin: from reset the first instruction is the ARM
        // reset vector at 0x00000000.
        assert_eq!(core.pc(), 0, "pc() pipeline adjustment wrong at reset");

        for _ in 0..240 {
            core.run_frame();
        }
        let snap = core.save_state().expect("snapshot");

        let mut seen = std::collections::HashSet::new();
        let mut found = None;
        let mut steps: u64 = 0;
        for _ in 0..200_000u64 {
            let (pc0, lr0, cpsr0) = (core.pc(), core.lr(), core.cpsr());
            let width = if core.is_thumb() { 2u32 } else { 4u32 };
            seen.insert(pc0);
            core.step();
            steps += 1;
            let (pc1, lr1, cpsr1) = (core.pc(), core.lr(), core.cpsr());
            if lr1 != lr0
                && (cpsr1 & 0x1F) == (cpsr0 & 0x1F)
                && (lr1 & !1) == pc0.wrapping_add(width)
                && pc1 != (lr1 & !1)
                && !seen.contains(&pc1)
            {
                found = Some((pc1, lr1 & !1, steps));
                break;
            }
        }
        let (entry, ret, k) = found.expect("no clean BL boundary in 200k steps");

        core.load_state(&snap).expect("restore");
        let taken = core.run_to_pc(entry, k + 16).expect("seek entry");
        assert_eq!(taken, k, "run_to_pc did not stop at the scanned boundary");
        assert_eq!(core.pc(), entry);

        let taken_ret = core.run_to_pc(ret, 5_000_000).expect("seek matching return");
        assert!(taken_ret > 0, "return seek took zero steps");
        assert_eq!(core.pc(), ret);
    }

    // Pure self-test of the BIOS gate's checksum (runs everywhere, no files).
    #[test]
    fn crc32_known_vector() {
        // IEEE CRC32 of "123456789" is 0xCBF43926 — the standard check value.
        assert_eq!(crate::bios::crc32(b"123456789"), 0xCBF4_3926);
    }
}
