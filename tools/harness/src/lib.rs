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
pub mod symbols;
pub mod sys;

/// Default ROM: <repo>/build/bn6f.gba, resolved relative to this crate
/// (tools/harness) so it works from any cwd.
pub const DEFAULT_ROM: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../build/bn6f.gba");

/// FNV-1a 64-bit. Deterministic across runs/processes (unlike std's SipHash),
/// no dependencies; plenty for state fingerprints (we compare, never store).
pub const FNV_OFFSET: u64 = 0xcbf2_9ce4_8422_2325;

/// Fold more bytes into a running FNV-1a hash (start from `FNV_OFFSET`).
pub fn fnv1a64_update(mut h: u64, data: &[u8]) -> u64 {
    for &b in data {
        h ^= b as u64;
        h = h.wrapping_mul(0x0000_0100_0000_01b3);
    }
    h
}

pub fn fnv1a64(data: &[u8]) -> u64 {
    fnv1a64_update(FNV_OFFSET, data)
}

#[cfg(test)]
mod tests {
    use crate::emu::Core;

    const TITLE: &str = "MEGAMAN6_FXX";

    // libmgba's exec hook (used by profiling) is a process global, and cargo
    // runs tests in parallel. A profiling core executing while any other core
    // executes would race on that global / the counter buffers. Gate it:
    // normal runs take a shared lock, profiling takes an exclusive one, so no
    // core executes concurrently with a profiling core (normal runs still
    // parallelize with each other).
    static EXEC: std::sync::RwLock<()> = std::sync::RwLock::new(());
    fn run_guard() -> std::sync::RwLockReadGuard<'static, ()> {
        EXEC.read().unwrap_or_else(|e| e.into_inner())
    }
    fn profile_guard() -> std::sync::RwLockWriteGuard<'static, ()> {
        EXEC.write().unwrap_or_else(|e| e.into_inner())
    }

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
        let _g = run_guard();
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
        let _g = run_guard();
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
        let _g = run_guard();
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
        let _g = run_guard();
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

    /// Step forward to the first *genuine* call boundary and stop there.
    ///
    /// A step counts as a call when: LR changed to call-site + width
    /// (BL writeback; the Thumb BL pair's first half writes a far-off
    /// value and is rejected), privilege mode is unchanged (rejects IRQ
    /// entry, whose LR is banked with a mode switch), the branch actually
    /// left fall-through (rejects `pop {lr}`), and the callee entry was
    /// never executed in the scan window (so, by determinism, its first
    /// occurrence is at exactly the returned step count).
    ///
    /// Returns (entry, return_address, steps_from_start).
    fn first_clean_call(core: &mut Core, max_steps: u64) -> Option<(u32, u32, u64)> {
        let mut seen = std::collections::HashSet::new();
        let mut steps: u64 = 0;
        for _ in 0..max_steps {
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
                return Some((pc1, lr1 & !1, steps));
            }
        }
        None
    }

    // B2: execution control — stop exactly at a chosen PC, twice over.
    // Determinism guarantees the scanned entry's first occurrence is at
    // exactly step k, so run_to_pc from the restored snapshot must stop
    // there in exactly k steps; then the callee must come back to the
    // matching return.
    #[test]
    fn b2_run_to_pc_entry_and_return() {
        let _g = run_guard();
        let Some((rom, bios)) = fixtures() else { return };
        let mut core = boot(&rom, &bios);
        // Pipeline-math pin: from reset the first instruction is the ARM
        // reset vector at 0x00000000.
        assert_eq!(core.pc(), 0, "pc() pipeline adjustment wrong at reset");

        for _ in 0..240 {
            core.run_frame();
        }
        let snap = core.save_state().expect("snapshot");
        let (entry, ret, k) =
            first_clean_call(&mut core, 200_000).expect("no clean BL boundary in 200k steps");

        core.load_state(&snap).expect("restore");
        let taken = core.run_to_pc(entry, k + 16).expect("seek entry");
        assert_eq!(taken, k, "run_to_pc did not stop at the scanned boundary");
        assert_eq!(core.pc(), entry);

        let taken_ret = core.run_to_pc(ret, 5_000_000).expect("seek matching return");
        assert!(taken_ret > 0, "return seek took zero steps");
        assert_eq!(core.pc(), ret);
    }

    // B3: the differential atom, proven on identity and on seeded faults.
    //
    // Snapshot at a real function's entry → run to its return → canonical
    // hash A; restore → run again → hash B; A must equal B (the machinery
    // itself introduces no divergence). Then mutation suite v0: the same
    // differential must go RED on a poked return register, an IWRAM byte,
    // and an EWRAM byte — "never trust a check you haven't watched fail."
    //
    // Timing masks are intentionally absent here: no drifted code exists
    // yet to watch a mask fail against; they arrive with the Phase 2
    // validator (see development plan).
    #[test]
    fn b3_identity_differential_and_mutants() {
        let _g = run_guard();
        let Some((rom, bios)) = fixtures() else { return };
        let mut core = boot(&rom, &bios);
        for _ in 0..240 {
            core.run_frame();
        }
        let (_, ret, _) =
            first_clean_call(&mut core, 200_000).expect("no clean BL boundary in 200k steps");
        // The scan parked us exactly at the callee's entry: this snapshot is
        // the differential's pre-state.
        let at_entry = core.save_state().expect("entry snapshot");
        const BUDGET: u64 = 5_000_000;

        let mut run_leg = |core: &mut Core| -> u64 {
            core.load_state(&at_entry).expect("restore");
            core.run_to_pc(ret, BUDGET).expect("run to return");
            core.canonical_hash().expect("hash")
        };
        let a = run_leg(&mut core);
        let b = run_leg(&mut core);
        assert_eq!(a, b, "identity differential diverged");

        // Mutant 1: corrupted return value (the archetypal conversion bug).
        core.load_state(&at_entry).expect("restore");
        core.run_to_pc(ret, BUDGET).expect("run to return");
        core.set_gpr(0, core.gpr(0) ^ 1);
        assert_ne!(core.canonical_hash().expect("hash"), a, "r0 poke went undetected");

        // Mutant 2: single flipped IWRAM byte.
        core.load_state(&at_entry).expect("restore");
        core.run_to_pc(ret, BUDGET).expect("run to return");
        core.bus_write8(0x0300_1000, core.bus_read8(0x0300_1000) ^ 0xFF);
        assert_ne!(core.canonical_hash().expect("hash"), a, "IWRAM poke went undetected");

        // Mutant 3: single flipped EWRAM byte.
        core.load_state(&at_entry).expect("restore");
        core.run_to_pc(ret, BUDGET).expect("run to return");
        core.bus_write8(0x0200_4000, core.bus_read8(0x0200_4000) ^ 0xFF);
        assert_ne!(core.canonical_hash().expect("hash"), a, "EWRAM poke went undetected");
    }

    fn boot_with_video(rom: &str, bios: &str) -> Core {
        let mut core = Core::new(rom).expect("core");
        core.install_video_buffer();
        core.load_bios(bios).expect("bios");
        core.reset().expect("reset");
        core
    }

    // Oracle determinism: the per-frame observable trace is reproducible.
    // (The permanent oracle must itself be deterministic before it can judge
    // anything — same input ⇒ same trace.)
    #[test]
    fn oracle_trace_deterministic() {
        let _g = run_guard();
        let Some((rom, bios)) = fixtures() else { return };
        let trace = |()| -> Vec<u64> {
            let mut core = boot_with_video(&rom, &bios);
            (0..400)
                .map(|_| {
                    core.run_frame();
                    core.observable_hash()
                })
                .collect()
        };
        assert_eq!(trace(()), trace(()));
    }

    // Oracle sensitivity: the observable hash tracks the displayed frame.
    // Over the animated boot (BIOS splash → GAME BOY logo → title), the
    // trace must take many distinct values — a stuck/blind hash would not.
    // (A single static dialogue frame can legitimately repeat, so we assert
    // on the variety across a span, not on one frame vs the next.)
    #[test]
    fn oracle_tracks_display() {
        let _g = run_guard();
        let Some((rom, bios)) = fixtures() else { return };
        let mut core = boot_with_video(&rom, &bios);
        let distinct: std::collections::HashSet<u64> = (0..600)
            .map(|_| {
                core.run_frame();
                core.observable_hash()
            })
            .collect();
        assert!(distinct.len() > 20, "observable hash barely varies over boot: {} distinct", distinct.len());
    }

    // Oracle mutation suite v0 — "never trust a check you haven't watched
    // fail." Corrupting any single compositor input (a VRAM tile byte, an
    // OAM attribute, a palette color) must move the observable hash. 16-bit
    // pokes: GBA OAM/PAL ignore/mirror 8-bit writes.
    #[test]
    fn oracle_catches_compositor_corruption() {
        let _g = run_guard();
        let Some((rom, bios)) = fixtures() else { return };
        let mut core = boot_with_video(&rom, &bios);
        for _ in 0..2000 {
            core.run_frame();
        }
        let base = core.observable_hash();

        for (label, addr) in [
            ("VRAM tile", 0x0600_0000u32),
            ("OAM attr", 0x0700_0010u32),
            ("palette color", 0x0500_0020u32),
        ] {
            let orig = core.bus_read16(addr);
            core.bus_write16(addr, orig ^ 0x5A5A);
            assert_ne!(core.observable_hash(), base, "{label} corruption not caught");
            core.bus_write16(addr, orig); // restore, so cases are independent
            assert_eq!(core.observable_hash(), base, "{label} restore left residue");
        }
    }

    // Profiler: after a run, the exec-hook has counted real coverage —
    // many functions hit, a known boot function (SetInterruptCallback) hit,
    // and at least one IWRAM-resident routine (0x03xxxxxx) hit.
    #[test]
    fn profiler_counts_coverage() {
        let _g = profile_guard();
        let Some((rom, bios)) = fixtures() else { return };
        if !crate::symbols::default_exists() {
            assert!(std::env::var_os("CI").is_some(), "run `make funcmap`");
            return;
        }
        let fns = crate::symbols::load(crate::symbols::DEFAULT_MAP).expect("map");
        let mut core = boot_with_video(&rom, &bios);
        core.enable_profiling();
        for _ in 0..900 {
            core.run_frame();
        }
        let covered = fns.iter().filter(|f| core.exec_count(f.addr) > 0).count();
        assert!(covered > 100, "only {covered} functions covered over 900 frames");
        assert!(core.exec_count(0x0800_024c) > 0, "SetInterruptCallback never ran");
        assert!(
            fns.iter().any(|f| f.is_iwram() && core.exec_count(f.addr) > 0),
            "no IWRAM-resident function counted"
        );
    }

    // The exec hook is observation-only: a profiled run must produce exactly
    // the same machine state as an unprofiled one. (If counting ever perturbs
    // timing/state, this is the tripwire.)
    #[test]
    fn profiling_does_not_perturb_state() {
        let _g = profile_guard();
        let Some((rom, bios)) = fixtures() else { return };
        let mut profiled = boot_with_video(&rom, &bios);
        profiled.enable_profiling();
        for _ in 0..300 {
            profiled.run_frame();
        }
        let hp = profiled.canonical_hash().expect("hash profiled");
        profiled.disable_profiling();

        let mut plain = boot_with_video(&rom, &bios);
        for _ in 0..300 {
            plain.run_frame();
        }
        let hu = plain.canonical_hash().expect("hash plain");
        assert_eq!(hp, hu, "profiling perturbed emulation state");
    }

    // Pure self-test of the BIOS gate's checksum (runs everywhere, no files).
    #[test]
    fn crc32_known_vector() {
        // IEEE CRC32 of "123456789" is 0xCBF43926 — the standard check value.
        assert_eq!(crate::bios::crc32(b"123456789"), 0xCBF4_3926);
    }
}
