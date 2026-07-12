//! The never-HLE gate [F6e, F7c]: the harness refuses any BIOS that is not
//! the official GBA BIOS image. Enforced in code (Core::load_bios calls
//! `verify`), not as a checklist — a wrong-or-missing BIOS cannot boot a core.
//!
//! Identity check = size 16384 + IEEE CRC32 0x81977335 (the No-Intro value
//! for the official BIOS; SHA1 300c20df6731a33952ded8c436f7f186d25d3492).
//! Note: mGBA's "Official GBA BIOS detected" log line quotes 0xBAAE187F —
//! that is mGBA's internal checksum, not IEEE CRC32.

pub const GBA_BIOS_SIZE: usize = 16384;
pub const GBA_BIOS_CRC32: u32 = 0x8197_7335;

/// Documented local fallback; prefer `BN6F_BIOS`. The safety property does
/// not depend on the path — whatever is found must still pass `verify`.
pub const FALLBACK_PATH: &str = "/home/alex/gbabiosworld.bin";

/// Resolve the BIOS path: `BN6F_BIOS` env var, else the documented fallback
/// if it exists. `None` means "no candidate" (caller decides skip vs error).
pub fn find() -> Option<String> {
    if let Some(p) = std::env::var_os("BN6F_BIOS") {
        return Some(p.to_string_lossy().into_owned());
    }
    if std::path::Path::new(FALLBACK_PATH).exists() {
        return Some(FALLBACK_PATH.into());
    }
    None
}

/// Verify `path` is the official GBA BIOS. Error strings name the gate
/// ("never-HLE") and the reason, per the plan's explicit-refusal requirement.
pub fn verify(path: &str) -> Result<(), String> {
    let bytes =
        std::fs::read(path).map_err(|e| format!("never-HLE gate: BIOS unreadable at {path}: {e}"))?;
    if bytes.len() != GBA_BIOS_SIZE {
        return Err(format!(
            "never-HLE gate: refusing {path}: size {} != {GBA_BIOS_SIZE} — not the official GBA BIOS",
            bytes.len()
        ));
    }
    let crc = crc32(&bytes);
    if crc != GBA_BIOS_CRC32 {
        return Err(format!(
            "never-HLE gate: refusing {path}: crc32 {crc:#010x} != {GBA_BIOS_CRC32:#010x} — not the official GBA BIOS"
        ));
    }
    Ok(())
}

/// IEEE CRC32 (reflected, init/xorout 0xFFFFFFFF) — bitwise, no table; 16 KB
/// inputs make speed irrelevant.
pub fn crc32(data: &[u8]) -> u32 {
    let mut crc: u32 = 0xFFFF_FFFF;
    for &b in data {
        crc ^= b as u32;
        for _ in 0..8 {
            let mask = (crc & 1).wrapping_neg();
            crc = (crc >> 1) ^ (0xEDB8_8320 & mask);
        }
    }
    !crc
}
