//! orchestrate.rs — drive the full per-patch validation.
//!
//! Phase 1 (sequential): build orig ROM
//! Phase 2 (sequential, manifest-locked): build each per-patch ROM
//! Phase 3 (parallel): rayon fan-out, each worker spawns
//!                     `bn6f-validate hash` subprocess
//! Phase 4 (parallel): rayon fan-out, each worker spawns
//!                     `bn6f-validate compare` subprocess
//!
//! Subprocess fan-out keeps it simple and isolates any mGBA-global
//! state per worker (each subprocess has its own process address
//! space). On a 12-core machine, ~12 hash jobs run concurrently.

use rayon::prelude::*;
use std::fs;
use std::io::{BufRead, BufReader, Write};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};
use std::time::Instant;

#[derive(Clone)]
struct Bk2 {
    stem: String,
    input_path: PathBuf,
    state_path: Option<PathBuf>,
    frame_count: usize,
}

pub struct RunArgs {
    pub start: Option<usize>,
    pub end: Option<usize>,
    pub patches: Vec<String>,
    pub jobs: usize,
    pub videos: bool,
    pub no_build: bool,
    pub exe: PathBuf, // self-path for subprocess fan-out
}

pub fn run(args: RunArgs) -> Result<(), String> {
    let root = git_root()?;
    let manifest = root.join("tools/decomp_manifest.txt");
    let bk2_dir = root.join("tests/fixtures/demos/bk2");
    let build = root.join("build");
    let roms_dir = build.join("roms");
    let hashes_dir = build.join("hashes");
    let videos_dir = build.join("videos");
    let results_csv = build.join("validate_results.csv");

    fs::create_dir_all(&roms_dir).map_err(|e| e.to_string())?;
    fs::create_dir_all(&hashes_dir).map_err(|e| e.to_string())?;
    if args.videos {
        fs::create_dir_all(&videos_dir).map_err(|e| e.to_string())?;
    }

    // ----- canonical patch list (every `.ifndef DECOMP_*` in asm/*.s) -----
    let all_patches = canonical_patches(&root)?;
    let selected = select_patches(&all_patches, &args)?;
    eprintln!(
        "[validate] {} patches selected ({} .. {})",
        selected.len(),
        selected.first().map(String::as_str).unwrap_or("-"),
        selected.last().map(String::as_str).unwrap_or("-")
    );

    let bk2s = discover_bk2s(&bk2_dir)?;
    eprintln!(
        "[validate] {} bk2 fixtures: {:?}",
        bk2s.len(),
        bk2s.iter().map(|b| &b.stem).collect::<Vec<_>>()
    );

    // ----- Phase 1: build orig ROM -----
    let orig_rom = roms_dir.join("bn6f_orig.gba");
    if !args.no_build || !orig_rom.exists() {
        eprintln!("[phase 1] building orig ROM...");
        restore_manifest(&root, &manifest)?;
        make_target(&root, "all")?;
        fs::copy(build.join("bn6f.gba"), &orig_rom).map_err(|e| e.to_string())?;
        eprintln!("[phase 1] orig → {}", orig_rom.display());
    }

    // ----- Phase 2: build per-patch ROMs (sequential, manifest-locked) -----
    let mut patch_roms: Vec<(usize, String, PathBuf)> = Vec::new();
    if args.no_build {
        for p in &selected {
            let idx = global_index(&all_patches, p);
            let rom = roms_dir.join(format!("bn6f_{:07}_{}.gba", idx, p));
            if !rom.exists() {
                return Err(format!("--no-build but {} missing", rom.display()));
            }
            patch_roms.push((idx, p.clone(), rom));
        }
    } else {
        eprintln!("[phase 2] building {} per-patch ROMs...", selected.len());
        let t0 = Instant::now();
        for (i, p) in selected.iter().enumerate() {
            let idx = global_index(&all_patches, p);
            eprintln!("  [{}/{}] #{:04} {}", i + 1, selected.len(), idx, p);
            if let Err(e) = build_patch_rom(&root, &manifest, &build, &roms_dir, idx, p) {
                eprintln!("    FAILED: {}", e);
                continue;
            }
            let rom = roms_dir.join(format!("bn6f_{:07}_{}.gba", idx, p));
            patch_roms.push((idx, p.clone(), rom));
        }
        restore_manifest(&root, &manifest)?;
        eprintln!("[phase 2] done in {:.0}s", t0.elapsed().as_secs_f64());
    }

    // ----- Phase 3: hash all (rom × bk2) pairs in parallel -----
    let mut hash_jobs: Vec<(PathBuf, Bk2)> = Vec::new();
    for b in &bk2s {
        hash_jobs.push((orig_rom.clone(), b.clone()));
    }
    for (_, _, rom) in &patch_roms {
        for b in &bk2s {
            hash_jobs.push((rom.clone(), b.clone()));
        }
    }
    eprintln!(
        "[phase 3] hashing {} (rom × bk2) jobs with j={}",
        hash_jobs.len(),
        args.jobs
    );
    rayon::ThreadPoolBuilder::new()
        .num_threads(args.jobs)
        .build_global()
        .ok();

    let t0 = Instant::now();
    let done = std::sync::atomic::AtomicUsize::new(0);
    let total = hash_jobs.len();
    let hash_results: Vec<(String, String, i32, u128)> = hash_jobs
        .par_iter()
        .map(|(rom, bk2)| {
            let r = hash_one(
                &args.exe,
                rom,
                bk2,
                &hashes_dir,
                if args.videos { Some(&videos_dir) } else { None },
            );
            let d = done.fetch_add(1, std::sync::atomic::Ordering::SeqCst) + 1;
            if d % 10 == 0 || d == total {
                let rate = d as f64 / t0.elapsed().as_secs_f64().max(0.001);
                let eta = (total - d) as f64 / rate.max(0.001);
                eprintln!(
                    "  [{d}/{total}] {} × {}  rate={:.1}/s eta={:.0}s",
                    rom_stem(rom),
                    bk2.stem,
                    rate,
                    eta
                );
            }
            r
        })
        .collect();
    eprintln!("[phase 3] hashed in {:.0}s", t0.elapsed().as_secs_f64());
    let hash_failures: Vec<_> = hash_results.iter().filter(|r| r.2 != 0).collect();
    if !hash_failures.is_empty() {
        eprintln!(
            "[phase 3] {} job(s) failed (first 5: {:?})",
            hash_failures.len(),
            hash_failures.iter().take(5).map(|r| (&r.0, &r.1)).collect::<Vec<_>>()
        );
    }

    // ----- Phase 4: compare each (patch × bk2) against orig -----
    let mut compare_jobs: Vec<(String, String)> = Vec::new();
    for (idx, p, _) in &patch_roms {
        let rs = format!("{:07}_{}", idx, p);
        for b in &bk2s {
            compare_jobs.push((rs.clone(), b.stem.clone()));
        }
    }
    eprintln!(
        "[phase 4] comparing {} (patch × bk2) pairs",
        compare_jobs.len()
    );
    let t0 = Instant::now();
    let rows: Vec<(String, String, String, i64)> = compare_jobs
        .par_iter()
        .map(|(rs, bs)| compare_one(&args.exe, &hashes_dir, rs, bs))
        .collect();
    eprintln!("[phase 4] compared in {:.0}s", t0.elapsed().as_secs_f64());

    // ----- summary -----
    let mut by_patch: std::collections::BTreeMap<String, Vec<(String, String, i64)>> =
        Default::default();
    for (rs, bs, verdict, first) in &rows {
        by_patch
            .entry(rs.clone())
            .or_default()
            .push((bs.clone(), verdict.clone(), *first));
    }

    let n_pass = by_patch
        .values()
        .filter(|v| v.iter().all(|(_, verdict, _)| verdict == "PASS"))
        .count();
    let n_fail = by_patch.len() - n_pass;

    eprintln!();
    eprintln!("=== summary ===");
    eprintln!("  patches tested: {}", by_patch.len());
    eprintln!("  PASS (all bk2s match): {}", n_pass);
    eprintln!("  FAIL (>=1 bk2 differs): {}", n_fail);
    if n_fail > 0 {
        eprintln!();
        eprintln!("  first 20 failures:");
        let mut i = 0;
        for (rs, entries) in &by_patch {
            for (bs, verdict, first) in entries {
                if verdict != "PASS" {
                    eprintln!(
                        "    {} × {}: {} (first diff frame: {})",
                        rs, bs, verdict, first
                    );
                    i += 1;
                    if i >= 20 {
                        break;
                    }
                }
            }
            if i >= 20 {
                break;
            }
        }
    }

    // ----- CSV output -----
    fs::create_dir_all(results_csv.parent().unwrap()).ok();
    let mut f = fs::File::create(&results_csv).map_err(|e| e.to_string())?;
    writeln!(f, "rom_stem,bk2,verdict,first_diff_frame").map_err(|e| e.to_string())?;
    let mut sorted = rows.clone();
    sorted.sort();
    for (rs, bs, verdict, first) in &sorted {
        writeln!(f, "{},{},{},{}", rs, bs, verdict, first).map_err(|e| e.to_string())?;
    }
    eprintln!();
    eprintln!("results → {}", results_csv.display());

    Ok(())
}

// ----- helpers ---------------------------------------------------------------

fn git_root() -> Result<PathBuf, String> {
    let out = Command::new("git")
        .args(["rev-parse", "--show-toplevel"])
        .output()
        .map_err(|e| e.to_string())?;
    if !out.status.success() {
        return Err("git rev-parse failed".into());
    }
    Ok(PathBuf::from(
        String::from_utf8_lossy(&out.stdout).trim().to_string(),
    ))
}

fn canonical_patches(root: &Path) -> Result<Vec<String>, String> {
    let asm = root.join("asm");
    let re = regex_lite::IfndefRe::new();
    let mut seen = std::collections::BTreeSet::<String>::new();
    let mut files: Vec<_> = fs::read_dir(&asm).map_err(|e| e.to_string())?
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|p| p.extension().and_then(|s| s.to_str()) == Some("s"))
        .collect();
    files.sort();
    for f in &files {
        let text = fs::read_to_string(f).map_err(|e| format!("{}: {e}", f.display()))?;
        for line in text.lines() {
            if let Some(name) = re.match_line(line) {
                seen.insert(name.to_string());
            }
        }
    }
    Ok(seen.into_iter().collect())
}

fn select_patches(all: &[String], args: &RunArgs) -> Result<Vec<String>, String> {
    if !args.patches.is_empty() {
        let mut bad = Vec::new();
        let mut sel = Vec::new();
        for p in &args.patches {
            if all.iter().any(|x| x == p) {
                sel.push(p.clone());
            } else {
                bad.push(p.clone());
            }
        }
        if !bad.is_empty() {
            return Err(format!("unknown patches: {:?}", bad));
        }
        return Ok(sel);
    }
    let start = args.start.unwrap_or(1);
    let end = args.end.unwrap_or(all.len());
    if start < 1 || end < start || end > all.len() {
        return Err(format!(
            "range {start}..{end} out of bounds (have {} patches)",
            all.len()
        ));
    }
    Ok(all[start - 1..end].to_vec())
}

fn discover_bk2s(bk2_dir: &Path) -> Result<Vec<Bk2>, String> {
    let mut out = Vec::new();
    let mut inps: Vec<_> = fs::read_dir(bk2_dir)
        .map_err(|e| e.to_string())?
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|p| p.extension().and_then(|s| s.to_str()) == Some("input"))
        .collect();
    inps.sort();
    for inp in inps {
        let stem = inp.file_stem().unwrap().to_string_lossy().to_string();
        let ss = bk2_dir.join(format!("{}.ss", stem));
        let state_path = if ss.exists() && fs::metadata(&ss).map(|m| m.len() > 0).unwrap_or(false) {
            Some(ss)
        } else {
            None
        };
        let frame_count = fs::metadata(&inp).map(|m| (m.len() / 4) as usize).unwrap_or(0);
        out.push(Bk2 {
            stem,
            input_path: inp,
            state_path,
            frame_count,
        });
    }
    Ok(out)
}

fn global_index(all: &[String], name: &str) -> usize {
    all.iter().position(|x| x == name).unwrap_or(0) + 1
}

fn restore_manifest(root: &Path, _manifest: &Path) -> Result<(), String> {
    let rc = Command::new("git")
        .args(["checkout", "--", "tools/decomp_manifest.txt"])
        .current_dir(root)
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .map_err(|e| e.to_string())?;
    if !rc.success() {
        return Err("git checkout manifest failed".into());
    }
    // touch
    Command::new("touch")
        .arg("tools/decomp_manifest.txt")
        .current_dir(root)
        .status()
        .ok();
    Ok(())
}

fn make_target(root: &Path, target: &str) -> Result<(), String> {
    let rc = Command::new("make")
        .args([target, "-s"])
        .current_dir(root)
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .map_err(|e| e.to_string())?;
    if !rc.success() {
        return Err(format!("make {target} failed"));
    }
    Ok(())
}

fn build_patch_rom(
    root: &Path,
    manifest: &Path,
    build: &Path,
    roms_dir: &Path,
    idx: usize,
    name: &str,
) -> Result<(), String> {
    // Preserve comments + blank lines as the header.
    let raw = fs::read_to_string(manifest).map_err(|e| e.to_string())?;
    let mut new = String::new();
    for line in raw.lines() {
        if line.starts_with('#') || line.trim().is_empty() {
            new.push_str(line);
            new.push('\n');
        }
    }
    new.push_str(name);
    new.push('\n');
    fs::write(manifest, new).map_err(|e| e.to_string())?;
    Command::new("touch").arg(manifest).status().ok();

    make_target(root, "clean-conditional-objs").ok();
    make_target(root, "decompile")?;

    let dst = roms_dir.join(format!("bn6f_{:07}_{}.gba", idx, name));
    fs::copy(build.join("bn6f.gba"), &dst).map_err(|e| e.to_string())?;
    Ok(())
}

fn rom_stem(p: &Path) -> String {
    p.file_stem()
        .and_then(|s| s.to_str())
        .map(|s| s.trim_start_matches("bn6f_").to_string())
        .unwrap_or_default()
}

fn hash_one(
    exe: &Path,
    rom: &Path,
    bk2: &Bk2,
    hashes_dir: &Path,
    videos_dir: Option<&Path>,
) -> (String, String, i32, u128) {
    let rs = rom_stem(rom);
    let hash_out = hashes_dir.join(format!("{}__{}.txt", rs, bk2.stem));
    let mut cmd = Command::new(exe);
    if videos_dir.is_some() {
        cmd.arg("both");
    } else {
        cmd.arg("hash");
    }
    cmd.arg(rom);
    cmd.args(["--input", bk2.input_path.to_str().unwrap()]);
    if let Some(s) = &bk2.state_path {
        cmd.args(["--state", s.to_str().unwrap()]);
    }
    if let Some(vd) = videos_dir {
        let vp = vd.join(format!("{}__{}.mp4", rs, bk2.stem));
        cmd.args(["--hashes", hash_out.to_str().unwrap()]);
        cmd.args(["--video", vp.to_str().unwrap()]);
    } else {
        cmd.args(["--out", hash_out.to_str().unwrap()]);
    }
    let t0 = Instant::now();
    let rc = cmd
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .map(|s| s.code().unwrap_or(255))
        .unwrap_or(255);
    (rs, bk2.stem.clone(), rc, t0.elapsed().as_millis())
}

fn compare_one(
    exe: &Path,
    hashes_dir: &Path,
    rom_stem: &str,
    bk2: &str,
) -> (String, String, String, i64) {
    let orig = hashes_dir.join(format!("orig__{}.txt", bk2));
    let patched = hashes_dir.join(format!("{}__{}.txt", rom_stem, bk2));
    if !orig.exists() || !patched.exists() {
        return (rom_stem.into(), bk2.into(), "MISSING".into(), -1);
    }
    let out = Command::new(exe)
        .args(["compare", orig.to_str().unwrap(), patched.to_str().unwrap()])
        .output();
    match out {
        Ok(o) => {
            let line = String::from_utf8_lossy(&o.stdout).trim().to_string();
            if line.contains("pass") {
                (rom_stem.into(), bk2.into(), "PASS".into(), -1)
            } else {
                let first = line
                    .split_whitespace()
                    .find_map(|tok| tok.strip_prefix("first_diff="))
                    .and_then(|s| s.parse::<i64>().ok())
                    .unwrap_or(-1);
                (rom_stem.into(), bk2.into(), "FAIL".into(), first)
            }
        }
        Err(_) => (rom_stem.into(), bk2.into(), "ERROR".into(), -1),
    }
}

// Tiny home-grown .ifndef DECOMP_<sym> matcher so we don't pull in
// the regex crate just for this.
mod regex_lite {
    pub struct IfndefRe;
    impl IfndefRe {
        pub fn new() -> Self {
            Self
        }
        pub fn match_line<'a>(&self, line: &'a str) -> Option<&'a str> {
            let trimmed = line.trim_start();
            let rest = trimmed.strip_prefix(".ifndef")?.trim_start();
            let name = rest.strip_prefix("DECOMP_")?;
            // Sym ends at whitespace or end of line.
            let end = name
                .find(|c: char| c.is_whitespace())
                .unwrap_or(name.len());
            Some(&name[..end])
        }
    }
}

#[allow(dead_code)]
fn read_lines(p: &Path) -> Result<Vec<String>, String> {
    let f = fs::File::open(p).map_err(|e| e.to_string())?;
    BufReader::new(f).lines().collect::<Result<_, _>>().map_err(|e| e.to_string())
}
