// Record-output cache for the bk2 verify workflow.
//
// The record pass (run bk2 → capture function entry snapshots + expected
// exit deltas) depends only on the ORIGINAL ROM, the bk2 file, and which
// function addresses we're targeting. The DECOMP ROM doesn't enter that
// computation — replay-and-diff happens later, against whatever decomp
// build we want to check.
//
// Steady-state decomp work changes only the decomp ROM (orig is the
// fixed reference; bk2 fixtures are stable; manifest only changes when
// adding/removing a target). So 99% of `make verify` invocations could
// in principle skip the entire record pass and go straight to replay,
// IF we cache the record-pass output on disk.
//
// Cache layout (per-function granularity so adding one target only
// invalidates that target's slot — the other ~hundreds stay hot):
//
//   <cache_dir>/
//     <orig_rom_sha[:12]>/                     # invalidates on ROM change
//       <bk2_sha[:12]>/                        # one dir per bk2 fixture
//         <fn_name>/                           # one dir per target fn
//           0000.entry.bin                     # captured entry snapshot
//           0000.exit.delta.bin                # expected exit delta
//           0001.entry.bin
//           ...
//
// On a cache hit for a (orig, bk2, fn) triple, we copy/hardlink the
// pair files into the session dir and skip recording that fn. On a
// 100% hit across all targets, we skip the bk2 emulation entirely.
//
// Cache reads/writes are best-effort: a missing or corrupt cache slot
// just falls back to recording. We never error out on cache I/O.

use sha1::{Digest, Sha1};
use std::fs;
use std::path::{Path, PathBuf};

/// Hex-encoded SHA1 of a file's contents, truncated to 12 chars.
/// 12 hex chars = 48 bits ≈ 2.8e14 distinct values, ample for our
/// cache cardinality (handfuls of ROM/bk2 hashes per project).
pub fn sha1_file_short(path: &Path) -> Result<String, String> {
    let bytes = fs::read(path).map_err(|e| format!("read {}: {e}", path.display()))?;
    let mut h = Sha1::new();
    h.update(&bytes);
    let digest = h.finalize();
    Ok(hex_lower(&digest[..6]))
}

fn hex_lower(b: &[u8]) -> String {
    let mut s = String::with_capacity(b.len() * 2);
    for &byte in b {
        s.push_str(&format!("{byte:02x}"));
    }
    s
}

/// Locator for one bk2's slice of the cache.
pub struct Bk2CacheDir {
    pub root: PathBuf,
}

impl Bk2CacheDir {
    pub fn open(cache_dir: &Path, orig_rom_sha: &str, bk2_sha: &str) -> std::io::Result<Self> {
        let root = cache_dir.join(orig_rom_sha).join(bk2_sha);
        fs::create_dir_all(&root)?;
        Ok(Bk2CacheDir { root })
    }

    /// Per-function cache directory.
    pub fn fn_dir(&self, fn_name: &str) -> PathBuf {
        self.root.join(fn_name)
    }

    /// Has this function's slot been *considered* in a prior record
    /// pass? "Cached" includes "considered but produced no pairs"
    /// (target was in RECORD_TARGETS but the function never fired in
    /// this bk2). We treat the existence of the function's cache
    /// directory as the source of truth — pair files OR the
    /// `.recorded` marker both signal a completed prior pass.
    pub fn is_fn_cached(&self, fn_name: &str) -> bool {
        self.fn_dir(fn_name).exists()
    }

    /// Stamp a marker so empty (target-considered-but-didn't-fire)
    /// slots are still detected as cached on the next run. Called
    /// after record() for every fn in the run's target set.
    pub fn mark_considered(&self, fn_name: &str) -> std::io::Result<()> {
        let d = self.fn_dir(fn_name);
        fs::create_dir_all(&d)?;
        let marker = d.join(".recorded");
        if !marker.exists() {
            fs::File::create(&marker)?;
        }
        Ok(())
    }

    /// Path to the forward-callgraph manifest written by record()
    /// (caller_name TAB callee1,callee2,... per line). Used by
    /// incremental verify to compute each fn's "code radius".
    pub fn callgraph_path(&self) -> PathBuf {
        self.root.join("callgraph.txt")
    }

    /// Path to the per-fn pass-cache: maps fn_name → sha hex of the
    /// decomp ROM bytes covering its code radius (self + transitive
    /// callees) at the time of its last green replay. If the current
    /// radius hash matches the recorded one, all pairs for that fn
    /// are skippable.
    pub fn pair_pass_path(&self) -> PathBuf {
        self.root.join("pair_pass.txt")
    }
}

/// Read a simple `name\tcsv,values` text file into a Vec of pairs.
/// Empty file / missing file → empty result. Used for callgraph
/// and pair_pass storage — JSON would need a dep, KV format is
/// trivial to parse.
pub fn read_kv_csv(path: &Path) -> Vec<(String, Vec<String>)> {
    let Ok(data) = fs::read_to_string(path) else { return Vec::new(); };
    data.lines()
        .filter(|l| !l.is_empty())
        .filter_map(|l| {
            let (k, v) = l.split_once('\t')?;
            let vs: Vec<String> = if v.is_empty() {
                Vec::new()
            } else {
                v.split(',').map(|s| s.to_string()).collect()
            };
            Some((k.to_string(), vs))
        })
        .collect()
}

/// Write the inverse of read_kv_csv. Sorted output for stable on-disk
/// representation (so diffs against a previous green run are minimal).
pub fn write_kv_csv(path: &Path, entries: &[(String, Vec<String>)]) -> std::io::Result<()> {
    let mut sorted: Vec<&(String, Vec<String>)> = entries.iter().collect();
    sorted.sort_by(|a, b| a.0.cmp(&b.0));
    let mut out = String::new();
    for (k, vs) in sorted {
        out.push_str(k);
        out.push('\t');
        out.push_str(&vs.join(","));
        out.push('\n');
    }
    fs::write(path, out)
}

