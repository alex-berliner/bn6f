//! The function map: every `func_start` label joined to its linked address.
//! Produced by `make funcmap` (scripts/gen_function_map.py) into
//! `build/bn6f_functions.tsv`. This is the profiler's index — call counts
//! and coverage are reported per entry here.

use std::path::Path;

#[derive(Debug, Clone)]
pub struct Function {
    pub name: String,
    /// Linked entry address (even; the Thumb bit is not set here).
    pub addr: u32,
    pub thumb: bool,
}

impl Function {
    /// True for the IWRAM-resident routines (copied to 0x03xxxxxx at
    /// runtime) — a distinct relocation class the profiler must still count.
    pub fn is_iwram(&self) -> bool {
        self.addr >> 24 == 0x03
    }
}

/// Default map path: <repo>/build/bn6f_functions.tsv.
pub const DEFAULT_MAP: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../build/bn6f_functions.tsv");

/// Parse a function map (`<addr_hex>\t<name>\t<isa>` per line), sorted by
/// address on return.
pub fn load(path: &str) -> Result<Vec<Function>, String> {
    let text = std::fs::read_to_string(path).map_err(|e| format!("{path}: {e}"))?;
    let mut out = Vec::new();
    for (n, line) in text.lines().enumerate() {
        if line.trim().is_empty() {
            continue;
        }
        let mut f = line.split('\t');
        let (a, name, isa) = (f.next(), f.next(), f.next());
        let (Some(a), Some(name), Some(isa)) = (a, name, isa) else {
            return Err(format!("{path}:{}: expected addr\\tname\\tisa", n + 1));
        };
        let addr = u32::from_str_radix(a.trim(), 16).map_err(|e| format!("{path}:{}: {e}", n + 1))?;
        out.push(Function { name: name.to_string(), addr, thumb: isa.trim() == "thumb" });
    }
    out.sort_by_key(|f| f.addr);
    Ok(out)
}

/// True if the default map has been generated.
pub fn default_exists() -> bool {
    Path::new(DEFAULT_MAP).exists()
}

#[cfg(test)]
mod tests {
    // The generated map is a build artifact; absent in a bare CI checkout.
    fn map() -> Option<Vec<super::Function>> {
        if !super::default_exists() {
            assert!(std::env::var_os("CI").is_some(), "run `make funcmap`");
            return None;
        }
        Some(super::load(super::DEFAULT_MAP).expect("load map"))
    }

    #[test]
    fn map_has_all_functions() {
        let Some(fns) = map() else { return };
        assert_eq!(fns.len(), 2751, "function count drifted from the disassembly");
    }

    #[test]
    fn known_function_resolves() {
        let Some(fns) = map() else { return };
        let f = fns.iter().find(|f| f.name == "SetInterruptCallback").expect("SetInterruptCallback");
        assert_eq!(f.addr, 0x0800_024c);
        assert!(f.thumb);
        assert!(!f.is_iwram());
    }

    #[test]
    fn addresses_are_even_and_sorted() {
        let Some(fns) = map() else { return };
        assert!(fns.windows(2).all(|w| w[0].addr <= w[1].addr), "not sorted");
        assert!(fns.iter().all(|f| f.addr & 1 == 0), "odd entry address");
        // Both relocation classes are present.
        assert!(fns.iter().any(|f| f.is_iwram()), "no IWRAM functions");
        assert!(fns.iter().any(|f| f.addr >> 24 == 0x08), "no ROM functions");
    }
}
