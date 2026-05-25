// bn6f-track — verification harness for the MMBN6F decomp.
// Links libmgba directly. See issues/concerns/10-emulator-requirements.md.
//
// Modes:
//   bn6f-track smoke   ROM [FRAMES]
//   bn6f-track track   ROM FRAMES SYMBOLS [OUTPUT]
//   bn6f-track record  ROM FRAMES SYMBOLS SESSION_DIR FN_ADDR [FN_ADDR...]
//   bn6f-track replay  ROM SESSION_DIR
//
// SYMBOLS is the file produced by `make function-symbols` —
// one "0xADDR NAME" per line.

#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]
#![allow(dead_code)]

pub(crate) mod mgba_sys {
    include!(concat!(env!("OUT_DIR"), "/mgba_sys.rs"));
}

mod cache;
mod snapshot;

use std::cell::RefCell;
use std::collections::{HashMap, HashSet};
use std::env;
use std::ffi::CString;
use std::fs;
use std::io::Write;
use std::mem::MaybeUninit;
use std::process;
use std::ptr;
use std::time::Instant;

// ---------------------------------------------------------------------
// Logger: silence libmgba's chatty default output
// ---------------------------------------------------------------------

unsafe extern "C" fn silent_log(
    _logger: *mut mgba_sys::mLogger,
    _category: i32,
    _level: mgba_sys::mLogLevel,
    _fmt: *const i8,
    _args: *mut mgba_sys::__va_list_tag,
) {
}

static mut SILENT_LOGGER: mgba_sys::mLogger = mgba_sys::mLogger {
    log: Some(silent_log),
    filter: ptr::null_mut(),
};

fn silence_libmgba_logger() {
    unsafe {
        #[allow(static_mut_refs)]
        mgba_sys::mLogSetDefaultLogger(&mut SILENT_LOGGER);
    }
}

// ---------------------------------------------------------------------
// Core wrapper
// ---------------------------------------------------------------------

struct Core {
    raw: *mut mgba_sys::mCore,
    _video_buf: Vec<u8>,
    /// Boxed mDebugger so it has a stable address — libmgba stores a
    /// raw pointer to it. None until attach_debugger() is called.
    debugger: Option<Box<mgba_sys::mDebugger>>,
    /// libmgba 0.11 split the per-instance callbacks (`custom`,
    /// `entered`, …) off the orchestrator and onto a separate
    /// mDebuggerModule.  We hold the single CUSTOM module here so
    /// it outlives the attach.
    dbg_module: Option<Box<mgba_sys::mDebuggerModule>>,
}

impl Core {
    fn new(rom_path: &str) -> Result<Self, String> {
        let c_path = CString::new(rom_path).map_err(|e| e.to_string())?;
        let raw = unsafe { mgba_sys::mCoreFind(c_path.as_ptr()) };
        if raw.is_null() {
            return Err(format!("mCoreFind returned null for {rom_path}"));
        }

        unsafe {
            let init = (*raw).init.expect("mCore.init is null");
            if !init(raw) {
                return Err("core.init() returned false".into());
            }
        }

        let mut video_buf = vec![0u8; 256 * 160 * 4];
        unsafe {
            let set_video = (*raw).setVideoBuffer.expect("mCore.setVideoBuffer is null");
            set_video(raw, video_buf.as_mut_ptr() as *mut _, 256);
        }

        let load_ok = unsafe { mgba_sys::mCoreLoadFile(raw, c_path.as_ptr()) };
        if !load_ok {
            return Err(format!("mCoreLoadFile failed for {rom_path}"));
        }

        let port_name = CString::new("bn6f-track").unwrap();
        let frameskip: i32 = std::env::var("BN6F_TRACK_FRAMESKIP")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or(i32::MAX);
        unsafe {
            mgba_sys::mCoreConfigInit(&mut (*raw).config, port_name.as_ptr());
            // Frameskip: render 1 of every (N+1) frames. We never read
            // the video buffer (no display, no screenshot capture); set
            // to i32::MAX so the per-frame `frameskipCounter` (signed
            // decrement, reset on negative) effectively never reaches
            // zero — the PPU's per-scanline draw / finishFrame path is
            // skipped for the lifetime of the run. Game timing is
            // unaffected: frameskip gates only drawScanline/finishFrame
            // in libmgba's video.c, not VBlank IRQ, vcount, or
            // game-side frame callbacks.
            //
            // Must be set BEFORE mCoreLoadConfig: _GBACoreLoadConfig in
            // libmgba propagates `core->opts.frameskip → gba->video.frameskip`
            // only at that call site (not on reset).
            (*raw).opts.frameskip = frameskip;
            mgba_sys::mCoreLoadConfig(raw);
        }

        unsafe {
            let reset = (*raw).reset.expect("mCore.reset is null");
            reset(raw);
        }

        Ok(Core { raw, _video_buf: video_buf, debugger: None, dbg_module: None })
    }

    /// Attach a custom debugger module in CALLBACK mode. The `custom`
    /// callback fires once per executed instruction; we use it to do
    /// our own O(1) PC dispatch instead of paying libmgba's per-bp
    /// linear scan (which saturates the bloom filter at ~5K hooks and
    /// degrades to 0.4 fps at 13K hooks).
    ///
    /// libmgba 0.11 split mDebugger into an orchestrator + a list of
    /// mDebuggerModules carrying the per-module callbacks.  We
    /// initialise the orchestrator, attach it to the core, then
    /// attach our single CUSTOM module that holds the callbacks.
    ///
    /// We deliberately do NOT register breakpoints via libmgba —
    /// `checkBreakpoints` is still called per step but with an empty
    /// list it's a no-op.
    fn attach_debugger(&mut self) {
        let mut dbg: Box<mgba_sys::mDebugger> = unsafe {
            Box::new(MaybeUninit::zeroed().assume_init())
        };
        let mut module: Box<mgba_sys::mDebuggerModule> = unsafe {
            Box::new(MaybeUninit::zeroed().assume_init())
        };
        module.type_ = mgba_sys::mDebuggerType_DEBUGGER_CUSTOM;
        module.custom = Some(custom_cb);
        // libmgba 0.11 only invokes `custom` when `needsCallback` is
        // set on the module — the orchestrator's CALLBACK-state loop
        // gates on the flag (see mDebuggerRunTimeout).
        module.needsCallback = true;
        // `entered` is unused (no breakpoints fire), but keep a handler
        // installed so libmgba doesn't crash if it ever does dispatch.
        module.entered = Some(entered_cb);

        unsafe {
            mgba_sys::mDebuggerInit(&mut *dbg as *mut _);
            mgba_sys::mDebuggerAttach(&mut *dbg as *mut _, self.raw);
            mgba_sys::mDebuggerAttachModule(&mut *dbg as *mut _, &mut *module as *mut _);
            // DEBUGGER_CALLBACK = step + check + custom per instruction.
            (*dbg).state = mgba_sys::mDebuggerState_DEBUGGER_CALLBACK;
        }
        self.debugger = Some(dbg);
        self.dbg_module = Some(module);
        // Sanity-check that the direct-read offsets used inside
        // `custom_cb` (gprs[15] at i32 index 15, cpsr.packed at i32
        // index 16 within ARMCore) still agree with libmgba's
        // readRegister. If a future libmgba bump reorders ARMCore
        // this trips loudly rather than silently producing garbage
        // PCs in the hot path.
        self.verify_cpu_layout();
    }

    /// Cross-check direct ARMCore field reads against libmgba's
    /// readRegister. One-time at debugger attach, so the per-step hot
    /// path stays branch-free.
    fn verify_cpu_layout(&self) {
        let core = self.raw;
        unsafe {
            let read = (*core).readRegister.expect("mCore.readRegister is null");
            let mut pc_named: i32 = 0;
            let mut cpsr_named: i32 = 0;
            let pc_name = std::ffi::CString::new("r15").unwrap();
            let cpsr_name = std::ffi::CString::new("cpsr").unwrap();
            let _ = read(core, pc_name.as_ptr(), &mut pc_named);
            let _ = read(core, cpsr_name.as_ptr(), &mut cpsr_named);
            let cpu = (*core).cpu as *const i32;
            let pc_direct = *cpu.add(15);
            let cpsr_direct = *cpu.add(16);
            assert_eq!(
                pc_direct, pc_named,
                "ARMCore.gprs[15] offset drift: direct={pc_direct:#x} named={pc_named:#x}",
            );
            assert_eq!(
                cpsr_direct, cpsr_named,
                "ARMCore.cpsr offset drift: direct={cpsr_direct:#x} named={cpsr_named:#x}",
            );
        }
    }

    /// Register a breakpoint at `address`. Returns the bp id (or -1 on
    /// failure). The id is opaque to us — what we actually use is the
    /// address that fires (info->address) inside the entered callback.
    fn set_breakpoint(&mut self, address: u32) -> isize {
        let dbg = self.debugger.as_mut().expect("attach_debugger() first");
        let module = self.dbg_module.as_mut().expect("attach_debugger() first");
        let bp = mgba_sys::mBreakpoint {
            id: 0,
            address,
            segment: -1,
            type_: mgba_sys::mBreakpointType_BREAKPOINT_HARDWARE,
            condition: ptr::null_mut(),
            disabled: false,
            isTemporary: false,
        };
        unsafe {
            let set = (*dbg.platform)
                .setBreakpoint
                .expect("platform.setBreakpoint is null");
            // libmgba 0.11 added the module pointer as the 2nd arg
            // (so the platform knows which module gets `entered`
            // when the bp fires).
            set(dbg.platform, &mut **module as *mut _, &bp)
        }
    }

    fn run_frames(&self, n: u32) {
        unsafe {
            let run_frame = (*self.raw).runFrame.expect("mCore.runFrame is null");
            for _ in 0..n {
                run_frame(self.raw);
            }
        }
    }

    /// Drive N frames through the debugger run loop, so breakpoints fire.
    /// `progress_every` > 0 prints `i/n frames` every N frames to stderr.
    fn run_frames_debugged(&mut self, n: u32, progress_every: u32) {
        let dbg = self.debugger.as_mut().expect("attach_debugger() first").as_mut();
        for i in 0..n {
            unsafe { mgba_sys::mDebuggerRunFrame(dbg as *mut _); }
            if progress_every > 0 && (i + 1) % progress_every == 0 {
                eprintln!("  [progress] {}/{} frames", i + 1, n);
            }
        }
    }

    /// Drive N frames with per-frame joypad input. `inputs[i]` is the
    /// "pressed" bitmask for frame i (1 = held, our convention — not
    /// the GBA hardware's inverted KEYINPUT). If the input log is
    /// shorter than `n`, the remaining frames run with no buttons.
    /// Bits: A=0x1 B=0x2 SEL=0x4 START=0x8 R=0x10 L=0x20 U=0x40 D=0x80
    ///       Rshoulder=0x100 Lshoulder=0x200.
    /// `progress_every` > 0 prints `i/n frames` every N frames to stderr.
    fn run_frames_debugged_with_input(
        &mut self,
        n: u32,
        inputs: &[u16],
        progress_every: u32,
    ) {
        let set_keys = unsafe { (*self.raw).setKeys.expect("mCore.setKeys is null") };
        let raw = self.raw;
        let dbg = self.debugger.as_mut().expect("attach_debugger() first").as_mut();
        for i in 0..n {
            let mask = inputs.get(i as usize).copied().unwrap_or(0) as u32;
            unsafe {
                set_keys(raw, mask);
                mgba_sys::mDebuggerRunFrame(dbg as *mut _);
            }
            if progress_every > 0 && (i + 1) % progress_every == 0 {
                eprintln!("  [progress] {}/{} frames", i + 1, n);
            }
        }
    }

    fn pc(&self) -> u32 {
        let mut out: i32 = 0;
        let reg = CString::new("r15").unwrap();
        unsafe {
            let read_reg = (*self.raw).readRegister.expect("mCore.readRegister is null");
            read_reg(self.raw, reg.as_ptr(), &mut out);
        }
        out as u32
    }

    fn frame_counter(&self) -> u32 {
        unsafe {
            let fc = (*self.raw).frameCounter.expect("mCore.frameCounter is null");
            fc(self.raw)
        }
    }
}

impl Drop for Core {
    fn drop(&mut self) {
        // Drop debugger first (still references core); then deinit core.
        self.debugger.take();
        unsafe {
            if let Some(deinit) = (*self.raw).deinit {
                deinit(self.raw);
            }
        }
    }
}

// ---------------------------------------------------------------------
// Custom debugger callback
// ---------------------------------------------------------------------
//
// `entered` fires whenever the debugger's run loop detects a breakpoint
// hit. We bump a thread-local counter for the hit PC. Thread-local
// rather than a struct field on mDebugger because Rust closures over
// extern "C" fn aren't possible, and we don't want to extend the C
// struct via #[repr(C)] subclassing here.

/// Bitset over instruction-aligned addresses, used to answer "is this
/// PC a known function entry?" in O(1) without going through a
/// HashSet probe. Allocated once per record/track run, indexed by
/// `(pc - base) >> 1` (Thumb-aware: 2-byte instruction alignment).
///
/// HashSet on the hot path was ~30-50 ns per call (hash + probe);
/// this is ~2-5 ns (compare + shift + load + bittest). At billions
/// of per-instruction callbacks per `make verify`, that adds up.
struct EntryBitset {
    base: u32,
    /// Number of valid slot positions (= bits.len() * 64).
    capacity: u32,
    bits: Vec<u64>,
}

impl EntryBitset {
    fn empty() -> Self {
        Self { base: 0x08000000, capacity: 0, bits: Vec::new() }
    }

    /// Build from a slice of addresses. Anything outside the ROM
    /// window [base, base + capacity*2) is silently dropped — the
    /// addresses we care about (function entries) live in ROM.
    fn from_addrs(addrs: &[u32]) -> Self {
        const ROM_BASE: u32 = 0x08000000;
        // Size to cover the highest in-ROM address with one slot of
        // slop. 2-byte stride keeps Thumb half-words distinguishable.
        let max_in_rom = addrs
            .iter()
            .copied()
            .filter(|&a| a >= ROM_BASE)
            .max()
            .unwrap_or(ROM_BASE);
        let span_bytes = max_in_rom - ROM_BASE + 4;
        let slot_count = (span_bytes / 2) + 1;
        let words = ((slot_count + 63) / 64) as usize;
        let mut bits = vec![0u64; words];
        for &a in addrs {
            if a >= ROM_BASE {
                let idx = (a - ROM_BASE) >> 1;
                if idx < slot_count {
                    bits[(idx >> 6) as usize] |= 1u64 << (idx & 63);
                }
            }
        }
        Self { base: ROM_BASE, capacity: slot_count, bits }
    }

    #[inline(always)]
    fn contains(&self, pc: u32) -> bool {
        if pc < self.base {
            return false;
        }
        let idx = (pc - self.base) >> 1;
        if idx >= self.capacity {
            return false;
        }
        let word = unsafe { *self.bits.get_unchecked((idx >> 6) as usize) };
        (word >> (idx & 63)) & 1 != 0
    }
}

thread_local! {
    /// Bitset of function-entry addresses (replaces a HashSet on the
    /// per-instruction hot path). RefCell so record()/track() can
    /// install it at startup, and custom_cb reads it billions of
    /// times per run.
    static ENTRIES: RefCell<EntryBitset> = RefCell::new(EntryBitset::empty());
    /// Map from function entry to (exclusive) end address — used to tell
    /// whether a branch-to-entry came from OUTSIDE the function (real
    /// call) or from INSIDE (loop iteration like start_copyMemory's
    /// `bne 80001d8 <start_copyMemory>` from within its body). Set to
    /// the next entry's address in sorted order.
    static FN_END: RefCell<HashMap<u32, u32>> = RefCell::new(HashMap::new());
    /// Total branch-into-entry events, matching the BizHawk baseline
    /// (counts loop iterations too).
    static HITS: RefCell<HashMap<u32, u64>> = RefCell::new(HashMap::new());
    /// Call counts: branch-into-entry only when source was outside the
    /// function. This is the "real" call count per function.
    static CALLS: RefCell<HashMap<u32, u64>> = RefCell::new(HashMap::new());
    /// Exit counts (matched returns).
    static EXITS: RefCell<HashMap<u32, u64>> = RefCell::new(HashMap::new());
    /// Forward callgraph edges captured during the bk2 run: caller
    /// fn_addr → set of callee fn_addrs it dispatched via BL. Drives
    /// incremental verification — each fn's "code radius" is the
    /// transitive closure of fns it calls; if no byte in that radius
    /// changed in the decomp ROM since the last green run, its
    /// captured pairs are still passing and can be skipped.
    /// Edges where the caller is top-level (no PENDING parent) are
    /// dropped — they don't contribute to any captured fn's radius.
    static CALLGRAPH: RefCell<HashMap<u32, HashSet<u32>>>
        = RefCell::new(HashMap::new());
    /// Pending-return stack: each (return_addr, fn_addr) gets pushed at
    /// a real call site and popped when control returns there. Bounded
    /// to keep pathological flow from leaking unbounded memory.
    static PENDING: RefCell<Vec<(u32, u32)>> = const { RefCell::new(Vec::new()) };
    /// Cached register-name CStrings.
    static PC_REG: CString = CString::new("r15").unwrap();
    static CPSR_REG: CString = CString::new("cpsr").unwrap();
    static LR_REG: CString = CString::new("r14").unwrap();
    /// Previous true_pc (= last executed instruction address). Used to
    /// detect branches and to classify "called from inside vs outside".
    static LAST_TRUE_PC: RefCell<u32> = const { RefCell::new(0) };

    // ----- record-mode state -----
    /// Functions we want to record entry snapshots for. Empty in
    /// `track` mode; populated in `record` mode.
    static RECORD_TARGETS: RefCell<HashSet<u32>> = RefCell::new(HashSet::new());
    /// Each entry snapshot captured during a record run. We don't try
    /// to track natural exits — instead, after the demo we run each
    /// entry to its captured LR with IRQs disabled, isolating the
    /// function's effect from IRQ-driven cycle drift.
    static RECORD_ENTRIES: RefCell<Vec<RecordedEntry>> = RefCell::new(Vec::new());
    /// Cap captures per target so a multi-minute input-driven demo
    /// doesn't OOM (each snapshot is ~288 KB; capping at 50/target
    /// keeps a 100-target run well under a gigabyte). 0 = uncapped.
    static RECORD_PER_TARGET_CAP: RefCell<usize> = const { RefCell::new(50) };
    /// Dedup identical entry snapshots per target — if a function is
    /// called repeatedly with the same (regs, EWRAM, IWRAM), only the
    /// first call is kept. Massively shrinks input-driven sessions
    /// (e.g. verify-spam) where the same per-frame poll hits with no
    /// state change. Savestate bytes are intentionally NOT in the hash
    /// — they include timers/scheduler/prefetch which advance every
    /// frame and would defeat the dedup.
    static RECORD_DEDUP_ENABLED: RefCell<bool> = const { RefCell::new(true) };
    /// Per-target set of snapshot hashes already captured.
    static RECORD_SEEN_HASHES: RefCell<HashMap<u32, HashSet<u64>>>
        = RefCell::new(HashMap::new());
    /// Count of entries skipped due to dedup, reported at end of record.
    static RECORD_DEDUP_SKIPPED: RefCell<usize> = const { RefCell::new(0) };
    /// Per-fn count of unique entries captured. Replaces the
    /// previous O(N) linear-scan over RECORD_ENTRIES for the cap
    /// check, and is the source of truth for "captured N entries"
    /// reporting under opt 11 (which pipelines entries off-thread).
    static RECORD_PER_FN_COUNT: RefCell<HashMap<u32, usize>>
        = RefCell::new(HashMap::new());
    /// Channel sender installed by `record()`. When Some, captured
    /// entries are dispatched to a worker pool that runs phase 2
    /// concurrently with phase 1. When None (e.g. `track` mode),
    /// captures fall through to RECORD_ENTRIES.
    static RECORD_SENDER:
        RefCell<Option<std::sync::mpsc::SyncSender<RecordedEntry>>>
        = const { RefCell::new(None) };
}

const PENDING_MAX: usize = 4096;

struct RecordedEntry {
    fn_addr: u32,
    captured_lr: u32,
    entry: snapshot::Snapshot,
}

unsafe extern "C" fn entered_cb(
    _module: *mut mgba_sys::mDebuggerModule,
    _reason: mgba_sys::mDebuggerEntryReason,
    _info: *mut mgba_sys::mDebuggerEntryInfo,
) {
    // No-op. We don't register libmgba breakpoints so this shouldn't
    // fire, but keep an installed handler to avoid NULL-deref crashes
    // if some other code path triggers mDebuggerEnter.
}

/// Per-instruction callback. The performance-critical path.
///
/// Algorithm: after each step, gprs[15] is the prefetch-advanced PC.
/// Recover the address of the just-executed instruction:
///   ARM   (T=0): true_pc = gprs[15] - 8
///   Thumb (T=1): true_pc = gprs[15] - 4
///
/// A function entry counts as a hit only when control TRANSITIONS into
/// it (true_pc is in ENTRIES *and* the previous instruction wasn't its
/// immediate predecessor by instruction-length). This avoids counting
/// every iteration of an internal loop whose body happens to sit one
/// instruction past the entry.
unsafe extern "C" fn custom_cb(module: *mut mgba_sys::mDebuggerModule) {
    // libmgba 0.11 passes the module pointer (not the orchestrator);
    // follow `module->p->core` back to the core.
    let dbg = unsafe { (*module).p };
    let core = unsafe { (*dbg).core };

    // Read PC + CPSR directly from the ARMCore struct rather than
    // going through (*core).readRegister — two function-pointer
    // indirections + name-based dispatch per executed instruction is
    // the dominant cost in this callback. ARMCore opens with
    //   int32_t gprs[16]; union PSR cpsr; ...
    // so gprs[15] is at offset 60 and cpsr.packed (the first member
    // of the union) is at offset 64. Layout is verified once at
    // attach time — see verify_cpu_layout.
    let cpu = unsafe { (*core).cpu as *const i32 };
    let pc = unsafe { *cpu.add(15) } as u32;
    let cpsr = unsafe { *cpu.add(16) } as u32;

    // libmgba's own checkBreakpoints uses: pc_to_match = gprs[15] - instructionLength.
    // Use the same convention so our hits align with libmgba's bp-fire
    // semantics.
    let thumb = (cpsr & (1 << 5)) != 0;
    let instr_len: u32 = if thumb { 2 } else { 4 };
    let true_pc = pc.wrapping_sub(instr_len);

    let last = LAST_TRUE_PC.with(|c| *c.borrow());
    let is_branch = true_pc != last.wrapping_add(instr_len);
    LAST_TRUE_PC.with(|c| *c.borrow_mut() = true_pc);

    if is_branch {
        // 1. EXIT detection: did this branch land us at the top
        //    pending return address? Pop and credit the exit.
        let popped = PENDING.with(|p| {
            let mut p = p.borrow_mut();
            if let Some(&(ret_addr, _)) = p.last() {
                if ret_addr == true_pc {
                    return p.pop();
                }
            }
            None
        });
        if let Some((_ret_addr, fn_addr)) = popped {
            EXITS.with(|h| {
                *h.borrow_mut().entry(fn_addr).or_insert(0) += 1;
            });
        }


        // 2. ENTRY detection: branch landed on a known function entry.
        let is_entry = ENTRIES.with(|e| e.borrow().contains(true_pc));
        if is_entry {
            HITS.with(|h| {
                *h.borrow_mut().entry(true_pc).or_insert(0) += 1;
            });

            // Was the source inside this function's body? If so, this
            // is an internal loop iteration (e.g. start_copyMemory's
            // `bne 80001d8`), not a real call — skip CALLS and PENDING.
            let internal = FN_END.with(|e| {
                e.borrow()
                    .get(&true_pc)
                    .map(|&end| last >= true_pc && last < end)
                    .unwrap_or(false)
            });

            if !internal {
                CALLS.with(|h| {
                    *h.borrow_mut().entry(true_pc).or_insert(0) += 1;
                });

                // Inspect the source instruction at `last` to decide
                // whether to push onto PENDING. Only true calls (BL /
                // Thumb BL Lo half / BLX) update LR with a useful
                // return address. Plain `b` / `bx Rn` tail-calls leave
                // LR unchanged and shouldn't enter the stack — pushing
                // them leaks (the callee returns to the *original*
                // caller, leaving the tail-caller's pending entry
                // stale forever).
                let bl_call = if thumb {
                    // Thumb BL is a 16-bit pair. The 2nd half (the one
                    // that actually performs the branch + updates LR)
                    // has top 5 bits == 0b11111.
                    let read16 = unsafe { (*core).busRead16.unwrap_unchecked() };
                    let val = unsafe { read16(core, last) } as u16;
                    (val >> 11) == 0x1F
                } else {
                    // ARM BL: bits[27:24] = 0b1011. (Distinguishes BL
                    // from B which has 0b1010.) Pure BX (register) has
                    // a different encoding; we treat it as non-call.
                    let read32 = unsafe { (*core).busRead32.unwrap_unchecked() };
                    let val = unsafe { read32(core, last) };
                    ((val >> 24) & 0xF) == 0xB
                };

                if bl_call {
                    // r14 = gprs[14], direct read (see custom_cb hot path).
                    let lr_i = unsafe { *cpu.add(14) };
                    let ret_addr = (lr_i as u32) & !1u32;
                    // Callgraph edge: caller = current top of PENDING
                    // (the fn this call is nested inside). None if the
                    // call originated top-level — those don't matter
                    // for any captured fn's radius.
                    let caller = PENDING.with(|p| {
                        p.borrow().last().map(|&(_, fn_addr)| fn_addr)
                    });
                    if let Some(caller_addr) = caller {
                        CALLGRAPH.with(|m| {
                            m.borrow_mut()
                                .entry(caller_addr)
                                .or_default()
                                .insert(true_pc);
                        });
                    }
                    PENDING.with(|p| {
                        let mut p = p.borrow_mut();
                        if p.len() < PENDING_MAX {
                            p.push((ret_addr, true_pc));
                        }
                    });

                    // Record-mode: snapshot entry state if this fn is
                    // in the target set. We capture the snapshot AND
                    // the captured LR; the actual "expected exit" is
                    // computed later by an isolated (IRQ-disabled)
                    // re-run of each captured entry.
                    let is_target =
                        RECORD_TARGETS.with(|t| t.borrow().contains(&true_pc));
                    if is_target {
                        // Cap captures per target. ~288 KB per snapshot
                        // (EWRAM + IWRAM); with a few hundred targets and
                        // a multi-minute demo, unbounded retention OOMs.
                        // When dedup is on, the cap counts uniques.
                        let cap = RECORD_PER_TARGET_CAP.with(|c| *c.borrow());
                        let already = RECORD_PER_FN_COUNT.with(
                            |m| *m.borrow().get(&true_pc).unwrap_or(&0)
                        );
                        if cap == 0 || already < cap {
                            let snap = snapshot::Snapshot::capture(core);
                            let dedup_on =
                                RECORD_DEDUP_ENABLED.with(|c| *c.borrow());
                            let is_new = if dedup_on {
                                let h = snapshot_dedup_hash(&snap);
                                RECORD_SEEN_HASHES.with(|m| {
                                    m.borrow_mut()
                                        .entry(true_pc)
                                        .or_default()
                                        .insert(h)
                                })
                            } else {
                                true
                            };
                            if is_new {
                                RECORD_PER_FN_COUNT.with(|m| {
                                    *m.borrow_mut().entry(true_pc).or_insert(0) += 1;
                                });
                                let rec = RecordedEntry {
                                    fn_addr: true_pc,
                                    captured_lr: ret_addr,
                                    entry: snap,
                                };
                                // If record() has installed a worker
                                // channel (opt 11), pipeline the entry
                                // off-thread for immediate phase 2
                                // processing. Otherwise fall through to
                                // RECORD_ENTRIES (still used by code
                                // paths that don't install a sender).
                                let sent = RECORD_SENDER.with(|s| -> Option<RecordedEntry> {
                                    let borrowed = s.borrow();
                                    match borrowed.as_ref() {
                                        Some(tx) => {
                                            // SyncSender::send blocks on
                                            // a full bounded channel —
                                            // natural backpressure on the
                                            // emulator thread if workers
                                            // can't keep up.
                                            tx.send(rec).ok();
                                            None
                                        }
                                        None => Some(rec),
                                    }
                                });
                                if let Some(rec) = sent {
                                    RECORD_ENTRIES.with(|s| {
                                        s.borrow_mut().push(rec);
                                    });
                                }
                            } else {
                                RECORD_DEDUP_SKIPPED
                                    .with(|c| *c.borrow_mut() += 1);
                            }
                        }
                    }
                }
            }
        }
    }
}

/// Hash an entry snapshot for dedup. Covers what the function "sees"
/// at entry: regs + EWRAM + IWRAM. Excludes the libmgba savestate
/// blob, which carries timer/scheduler state that drifts every frame
/// and would prevent any meaningful dedup.
fn snapshot_dedup_hash(s: &snapshot::Snapshot) -> u64 {
    use std::collections::hash_map::DefaultHasher;
    use std::hash::{Hash, Hasher};
    let mut h = DefaultHasher::new();
    s.regs.hash(&mut h);
    s.ewram.hash(&mut h);
    s.iwram.hash(&mut h);
    h.finish()
}

// ---------------------------------------------------------------------
// Symbol table I/O
// ---------------------------------------------------------------------

/// Parse "0xADDR NAME" lines into a Vec<(addr, name)>.
fn read_symbols(path: &str) -> Result<Vec<(u32, String)>, String> {
    let text = fs::read_to_string(path).map_err(|e| format!("read {path}: {e}"))?;
    let mut out = Vec::new();
    for line in text.lines() {
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        let mut parts = line.splitn(2, char::is_whitespace);
        let addr_s = parts.next().ok_or("empty line")?;
        let name = parts.next().ok_or("missing name")?.trim().to_string();
        let addr_s = addr_s.strip_prefix("0x").unwrap_or(addr_s);
        let addr = u32::from_str_radix(addr_s, 16)
            .map_err(|e| format!("bad addr {addr_s:?}: {e}"))?;
        out.push((addr, name));
    }
    Ok(out)
}

// ---------------------------------------------------------------------
// Modes
// ---------------------------------------------------------------------

fn smoke_test(rom: &str, frames: u32) {
    println!("=== bn6f-track smoke test ===");
    println!("rom: {rom}");
    println!("frames: {frames}");

    for pass in 1..=2 {
        let t0 = Instant::now();
        let core = Core::new(rom).unwrap_or_else(|e| {
            eprintln!("Core::new failed: {e}");
            process::exit(1);
        });
        core.run_frames(frames);
        let elapsed = t0.elapsed();
        let pc = core.pc();
        let frame = core.frame_counter();
        let fps = frames as f64 / elapsed.as_secs_f64();
        println!(
            "pass {pass}: after {frame} frames, PC = 0x{pc:08X}, wall = {:.3}s ({fps:.0} fps)",
            elapsed.as_secs_f64()
        );
    }
}

fn load_input_file(path: &str) -> Vec<u16> {
    let bytes = fs::read(path).unwrap_or_else(|e| {
        eprintln!("read input {path}: {e}");
        process::exit(1);
    });
    if bytes.len() % 2 != 0 {
        eprintln!("input file {path} has odd byte count {}", bytes.len());
        process::exit(1);
    }
    bytes.chunks_exact(2).map(|c| u16::from_le_bytes([c[0], c[1]])).collect()
}

fn track(rom: &str, frames: u32, symbols_path: &str, output: Option<&str>, input_path: Option<&str>) {
    eprintln!("=== bn6f-track function tracker ===");
    eprintln!("rom: {rom}");
    eprintln!("frames: {frames}");
    eprintln!("symbols: {symbols_path}");
    let inputs: Vec<u16> = if let Some(p) = input_path {
        let v = load_input_file(p);
        eprintln!("input: {p}  {} frames of joypad masks", v.len());
        v
    } else {
        Vec::new()
    };

    let symbols = read_symbols(symbols_path).unwrap_or_else(|e| {
        eprintln!("read_symbols: {e}");
        process::exit(1);
    });
    let names: HashMap<u32, String> = symbols.iter().cloned().collect();
    eprintln!("loaded {} unique function symbols", names.len());

    HITS.with(|h| h.borrow_mut().clear());
    CALLS.with(|h| h.borrow_mut().clear());
    EXITS.with(|h| h.borrow_mut().clear());
    CALLGRAPH.with(|m| m.borrow_mut().clear());
    PENDING.with(|p| p.borrow_mut().clear());
    LAST_TRUE_PC.with(|c| *c.borrow_mut() = 0);
    ENTRIES.with(|e| {
        let addrs: Vec<u32> = symbols.iter().map(|(a, _)| *a).collect();
        *e.borrow_mut() = EntryBitset::from_addrs(&addrs);
    });
    // Build FN_END: for each entry, the address of the next entry in
    // sorted order. Body = [entry, next_entry).
    FN_END.with(|m| {
        let mut m = m.borrow_mut();
        m.clear();
        let mut sorted: Vec<u32> = symbols.iter().map(|(a, _)| *a).collect();
        sorted.sort();
        sorted.dedup();
        for window in sorted.windows(2) {
            m.insert(window[0], window[1]);
        }
        if let Some(&last) = sorted.last() {
            m.insert(last, u32::MAX);
        }
    });

    let mut core = Core::new(rom).unwrap_or_else(|e| {
        eprintln!("Core::new failed: {e}");
        process::exit(1);
    });
    core.attach_debugger();
    let armed = symbols.len();
    eprintln!("armed {} hooks via O(1) PC dispatcher", armed);

    let t0 = Instant::now();
    if inputs.is_empty() {
        core.run_frames_debugged(frames, 0);
    } else {
        core.run_frames_debugged_with_input(frames, &inputs, 0);
    }
    let elapsed = t0.elapsed();
    let final_frame = core.frame_counter();
    let fps = frames as f64 / elapsed.as_secs_f64();
    eprintln!(
        "emulated {final_frame} frames in {:.3}s ({fps:.1} fps)",
        elapsed.as_secs_f64()
    );

    // Collect + sort hits, gather calls/exits alongside.
    let calls_map: HashMap<u32, u64> = CALLS.with(|h| h.borrow().clone());
    let exits_map: HashMap<u32, u64> = EXITS.with(|h| h.borrow().clone());
    let mut hits_vec: Vec<(u32, u64, u64, u64)> = HITS.with(|h| {
        h.borrow()
            .iter()
            .map(|(&a, &c)| {
                let calls = calls_map.get(&a).copied().unwrap_or(0);
                let exits = exits_map.get(&a).copied().unwrap_or(0);
                (a, c, calls, exits)
            })
            .collect()
    });
    hits_vec.sort_by(|a, b| b.1.cmp(&a.1).then(a.0.cmp(&b.0)));
    let total_hits: u64 = hits_vec.iter().map(|t| t.1).sum();
    let total_calls: u64 = hits_vec.iter().map(|t| t.2).sum();
    let total_exits: u64 = hits_vec.iter().map(|t| t.3).sum();
    let cleanly_paired = hits_vec.iter().filter(|t| t.2 == t.3).count();
    let pending_remaining = PENDING.with(|p| p.borrow().len());

    let mut sink: Box<dyn Write> = match output {
        Some(p) => Box::new(fs::File::create(p).unwrap_or_else(|e| {
            eprintln!("create {p}: {e}");
            process::exit(1);
        })),
        None => Box::new(std::io::stdout()),
    };

    writeln!(sink, "# bn6f-track function tracker: {rom}").unwrap();
    writeln!(sink, "# Frames: {frames}  (no input)").unwrap();
    writeln!(
        sink,
        "# Functions hooked: {armed}  Functions fired: {}",
        hits_vec.len()
    )
    .unwrap();
    writeln!(
        sink,
        "# Total hits: {total_hits}  calls: {total_calls}  exits: {total_exits}"
    )
    .unwrap();
    writeln!(
        sink,
        "# Cleanly paired (calls == exits): {} of {}  pending leftover: {}",
        cleanly_paired,
        hits_vec.len(),
        pending_remaining
    )
    .unwrap();
    writeln!(
        sink,
        "# Replay wall time: {:.3} sec ({:.1} fps)",
        elapsed.as_secs_f64(),
        fps
    )
    .unwrap();
    writeln!(
        sink,
        "# --- hits ---  addr        hits    calls    exits  name"
    )
    .unwrap();
    for (addr, hits, calls, exits) in &hits_vec {
        let name = names
            .get(addr)
            .map(String::as_str)
            .unwrap_or("<unknown>");
        writeln!(
            sink,
            "0x{addr:08X}  {hits:>8} {calls:>8} {exits:>8}  {name}"
        )
        .unwrap();
    }

    if let Some(p) = output {
        eprintln!("wrote {p}");
    }
}

// ---------------------------------------------------------------------
// record — run a session and capture (entry, exit) snapshot pairs for
// a specified set of target functions. Output layout:
//   <session_dir>/<fn_name>/N.entry.bin
//   <session_dir>/<fn_name>/N.exit.bin
// ---------------------------------------------------------------------

fn record(
    rom: &str,
    frames: u32,
    symbols_path: &str,
    session_dir: &str,
    target_hex: &[String],
    input_path: Option<&str>,
    state_path: Option<&str>,
    dedup: bool,
    progress_every: u32,
    verbose: bool,
) {
    eprintln!("=== bn6f-track record ===");
    eprintln!("rom: {rom}  frames: {frames}");
    eprintln!("session: {session_dir}");
    eprintln!("dedup: {}", if dedup { "on" } else { "off" });
    if progress_every > 0 {
        eprintln!("progress: every {progress_every} frames");
    }
    if let Some(p) = state_path {
        eprintln!("start savestate: {p}");
    }
    let inputs: Vec<u16> = if let Some(p) = input_path {
        let v = load_input_file(p);
        eprintln!("input: {p}  {} frames of joypad masks", v.len());
        v
    } else {
        Vec::new()
    };

    let symbols = read_symbols(symbols_path).unwrap_or_else(|e| {
        eprintln!("read_symbols: {e}");
        process::exit(1);
    });
    let names: HashMap<u32, String> = symbols.iter().cloned().collect();

    // Parse target addresses (hex strings with optional 0x).
    let targets: Vec<u32> = target_hex
        .iter()
        .map(|s| {
            let s = s.trim().strip_prefix("0x").unwrap_or(s);
            u32::from_str_radix(s, 16).unwrap_or_else(|e| {
                eprintln!("bad target addr {s}: {e}");
                process::exit(1);
            })
        })
        .collect();
    eprintln!("targets: {}", targets.len());
    if verbose {
        for t in &targets {
            let name = names.get(t).map(String::as_str).unwrap_or("<unknown>");
            eprintln!("  0x{t:08X}  {name}");
        }
    }

    // Reset tracker state.
    HITS.with(|h| h.borrow_mut().clear());
    CALLS.with(|h| h.borrow_mut().clear());
    EXITS.with(|h| h.borrow_mut().clear());
    CALLGRAPH.with(|m| m.borrow_mut().clear());
    PENDING.with(|p| p.borrow_mut().clear());
    LAST_TRUE_PC.with(|c| *c.borrow_mut() = 0);
    RECORD_ENTRIES.with(|s| s.borrow_mut().clear());
    RECORD_DEDUP_ENABLED.with(|c| *c.borrow_mut() = dedup);
    RECORD_SEEN_HASHES.with(|m| m.borrow_mut().clear());
    RECORD_DEDUP_SKIPPED.with(|c| *c.borrow_mut() = 0);
    RECORD_PER_FN_COUNT.with(|m| m.borrow_mut().clear());
    ENTRIES.with(|e| {
        let addrs: Vec<u32> = symbols.iter().map(|(a, _)| *a).collect();
        *e.borrow_mut() = EntryBitset::from_addrs(&addrs);
    });
    FN_END.with(|m| {
        let mut m = m.borrow_mut();
        m.clear();
        let mut sorted: Vec<u32> = symbols.iter().map(|(a, _)| *a).collect();
        sorted.sort();
        sorted.dedup();
        for window in sorted.windows(2) {
            m.insert(window[0], window[1]);
        }
        if let Some(&last) = sorted.last() {
            m.insert(last, u32::MAX);
        }
    });
    RECORD_TARGETS.with(|t| {
        let mut t = t.borrow_mut();
        t.clear();
        for &a in &targets {
            t.insert(a);
        }
    });

    // Set up the pipelined phase 2 worker (opt 11). Captured entries
    // from the per-instruction callback are shipped through a bounded
    // channel to a rayon-driven worker pool that runs isolated_run_to
    // and writes pairs to disk concurrently with phase 1's emulation.
    fs::create_dir_all(session_dir).unwrap();
    use std::sync::atomic::{AtomicUsize, Ordering};
    let (tx, rx) = std::sync::mpsc::sync_channel::<RecordedEntry>(64);
    let names_arc = std::sync::Arc::new(names);
    let rom_arc = std::sync::Arc::new(rom.to_string());
    let session_dir_arc = std::sync::Arc::new(session_dir.to_string());
    let wrote = std::sync::Arc::new(AtomicUsize::new(0));
    let failed = std::sync::Arc::new(AtomicUsize::new(0));
    let seq_map = std::sync::Arc::new(
        std::sync::Mutex::new(HashMap::<u32, usize>::new())
    );
    let dir_done = std::sync::Arc::new(
        std::sync::Mutex::new(HashSet::<u32>::new())
    );

    let pump = {
        let names = names_arc.clone();
        let rom = rom_arc.clone();
        let session_dir = session_dir_arc.clone();
        let wrote = wrote.clone();
        let failed = failed.clone();
        let seq_map = seq_map.clone();
        let dir_done = dir_done.clone();
        std::thread::spawn(move || {
            use rayon::prelude::*;
            rx.into_iter().par_bridge().for_each(|rec: RecordedEntry| {
                let name = names
                    .get(&rec.fn_addr)
                    .map(String::as_str)
                    .unwrap_or("<unknown>")
                    .to_string();
                // Per-fn sequence number — assigned at worker time via
                // a shared map. Workers race; the resulting seq order
                // is non-deterministic across runs, but unique per
                // (fn_addr, seq) within a run, which is all replay needs.
                let seq = {
                    let mut m = seq_map.lock().unwrap();
                    let entry = m.entry(rec.fn_addr).or_insert(0);
                    let s = *entry;
                    *entry = s + 1;
                    s
                };
                let fn_dir = format!("{}/{}", session_dir, name);
                {
                    let mut d = dir_done.lock().unwrap();
                    if d.insert(rec.fn_addr) {
                        fs::create_dir_all(&fn_dir).unwrap();
                    }
                }
                match isolated_run_to(&rom, &rec.entry, rec.captured_lr) {
                    Ok(exit) => {
                        let entry_path =
                            format!("{fn_dir}/{seq:04}.entry.bin");
                        let exit_path =
                            format!("{fn_dir}/{seq:04}.exit.delta.bin");
                        rec.entry
                            .write_to(std::path::Path::new(&entry_path))
                            .unwrap();
                        let delta =
                            snapshot::ExitDelta::from_pair(&rec.entry, &exit);
                        delta
                            .write_to(std::path::Path::new(&exit_path))
                            .unwrap();
                        wrote.fetch_add(1, Ordering::Relaxed);
                    }
                    Err(e) => {
                        failed.fetch_add(1, Ordering::Relaxed);
                        eprintln!(
                            "  {name} #{seq:04} isolated run failed: {e}"
                        );
                    }
                }
            });
        })
    };

    // Install sender so custom_cb pipelines captures into the pump.
    RECORD_SENDER.with(|s| *s.borrow_mut() = Some(tx));

    let mut core = Core::new(rom).unwrap_or_else(|e| {
        eprintln!("Core::new failed: {e}");
        process::exit(1);
    });
    // Optional: start the demo from a user-supplied mGBA savestate
    // (e.g. captured via the GUI's Save State menu) instead of from
    // reset. The harness then records calls during `frames` of
    // emulation starting from that scene.
    if let Some(p) = state_path {
        if let Err(e) = snapshot::load_savestate_file(core.raw, std::path::Path::new(p)) {
            eprintln!("load savestate {p}: {e}");
            process::exit(1);
        }
    }
    core.attach_debugger();

    let t0 = Instant::now();
    if inputs.is_empty() {
        core.run_frames_debugged(frames, progress_every);
    } else {
        core.run_frames_debugged_with_input(frames, &inputs, progress_every);
    }
    let elapsed = t0.elapsed();
    eprintln!(
        "emulated {} frames in {:.3}s ({:.1} fps)",
        core.frame_counter(),
        elapsed.as_secs_f64(),
        frames as f64 / elapsed.as_secs_f64()
    );
    drop(core); // release the demo core

    // Close the channel: drop the sender. Workers drain any remaining
    // queued entries, then par_bridge returns and the pump thread exits.
    RECORD_SENDER.with(|s| s.borrow_mut().take());

    let captured = RECORD_PER_FN_COUNT
        .with(|m| m.borrow().values().sum::<usize>());
    let dedup_skipped = RECORD_DEDUP_SKIPPED.with(|c| *c.borrow());
    if dedup && dedup_skipped > 0 {
        eprintln!(
            "captured {captured} target entries ({dedup_skipped} dropped by dedup); waiting for phase 2 to drain..."
        );
    } else {
        eprintln!(
            "captured {captured} target entries; waiting for phase 2 to drain..."
        );
    }

    pump.join().expect("phase 2 pump thread panicked");

    eprintln!(
        "wrote {} pairs to {} ({} entries failed isolated run)",
        wrote.load(Ordering::Relaxed),
        &*session_dir_arc,
        failed.load(Ordering::Relaxed)
    );
}

// ---------------------------------------------------------------------
// isolated_run_to — load an entry snapshot into a fresh core, mask
// IRQs (CPSR.I = 1), single-step until PC reaches `target`, capture
// and return the exit snapshot. Used by both record (to compute the
// expected exit on the oracle ROM) and replay (to compute the actual
// exit on the candidate ROM).
//
// We mask IRQs so the comparison is unaffected by cycle-drift between
// the ASM and C versions of the function — IRQ handlers would
// otherwise mutate memory/registers differently between the two.
// ---------------------------------------------------------------------

thread_local! {
    /// Per-thread Core pool keyed by ROM path. Each rayon worker
    /// builds a Core once on first use and reuses it across
    /// `isolated_run_to` calls. Phase 2 (oracle) and phase 3
    /// (decompile) use different ROM paths within the same process,
    /// so the cache must be keyed — a worker thread will see both.
    ///
    /// Cores are leaked at thread exit (libmgba deinit is not invoked).
    /// Bounded leak: one Core per rayon worker × number of distinct
    /// ROM paths (≤ 2 in practice).
    static CORE_POOL: RefCell<HashMap<String, Core>> = RefCell::new(HashMap::new());
}

fn isolated_run_to(
    rom: &str,
    entry: &snapshot::Snapshot,
    target: u32,
) -> Result<snapshot::Snapshot, String> {
    CORE_POOL.with(|pool| -> Result<snapshot::Snapshot, String> {
        let mut pool = pool.borrow_mut();
        if !pool.contains_key(rom) {
            let c = Core::new(rom).map_err(|e| format!("Core::new: {e}"))?;
            pool.insert(rom.to_string(), c);
        }
        let core = pool.get_mut(rom).expect("just inserted");
        let raw = core.raw;
        entry.restore(raw)?;

        // Mask IRQ at the CPU level (CPSR.I = bit 7) so cycle drift
        // between ASM and C versions can't show up as different IRQ
        // interleavings.
        let cpsr_name = CString::new("cpsr").unwrap();
        let pc_name = CString::new("r15").unwrap();
        unsafe {
            let read = (*raw).readRegister.unwrap_unchecked();
            let write = (*raw).writeRegister.unwrap_unchecked();
            let mut cpsr_i: i32 = 0;
            read(raw, cpsr_name.as_ptr(), &mut cpsr_i);
            let cpsr = (cpsr_i as u32) | 0x80;
            write(raw, cpsr_name.as_ptr(), cpsr as i32);
        }

        const MAX_STEPS: usize = 1_000_000;
        let mut steps = 0usize;
        unsafe {
            let step_fn = (*raw).step.expect("core.step is null");
            let read = (*raw).readRegister.expect("readRegister is null");
            loop {
                if steps >= MAX_STEPS {
                    return Err(format!(
                        "didn't reach LR 0x{target:08X} in {MAX_STEPS} steps"
                    ));
                }
                step_fn(raw);
                steps += 1;
                let mut pc_i: i32 = 0;
                let mut cpsr_i: i32 = 0;
                read(raw, pc_name.as_ptr(), &mut pc_i);
                read(raw, cpsr_name.as_ptr(), &mut cpsr_i);
                let cpsr = cpsr_i as u32;
                let instr_len = if (cpsr & (1 << 5)) != 0 { 2 } else { 4 };
                let true_pc = (pc_i as u32).wrapping_sub(instr_len);
                if true_pc == target {
                    break;
                }
            }
        }
        Ok(snapshot::Snapshot::capture(raw))
    })
}

// ---------------------------------------------------------------------
// replay — for each fixture in the session dir, load the entry
// snapshot into a freshly-loaded ROM, step until PC reaches the
// captured LR, snapshot the exit, diff against the recorded exit.
// ---------------------------------------------------------------------

fn replay(rom: &str, session_dir: &str, verbose: bool) {
    eprintln!("=== bn6f-track replay ===");
    eprintln!("rom: {rom}  session: {session_dir}");
    if !verbose {
        eprintln!("(quiet mode — only printing failures; pass --verbose for full output)");
    }

    // Walk session_dir/<fn_name>/N.{entry,exit}.bin
    let mut by_fn: HashMap<String, Vec<usize>> = HashMap::new();
    let session = std::path::Path::new(session_dir);
    let entries = fs::read_dir(session).unwrap_or_else(|e| {
        eprintln!("can't read {session_dir}: {e}");
        process::exit(1);
    });
    for entry in entries.flatten() {
        let path = entry.path();
        if !path.is_dir() {
            continue;
        }
        let fn_name = path.file_name().unwrap().to_string_lossy().to_string();
        let mut seqs: Vec<usize> = Vec::new();
        for sub in fs::read_dir(&path).unwrap().flatten() {
            let fname = sub.file_name().to_string_lossy().to_string();
            if let Some(seq_str) = fname.strip_suffix(".entry.bin") {
                if let Ok(seq) = seq_str.parse::<usize>() {
                    seqs.push(seq);
                }
            }
        }
        seqs.sort();
        by_fn.insert(fn_name, seqs);
    }

    use rayon::prelude::*;

    let mut total_pairs = 0usize;
    let mut total_pass = 0usize;
    let mut total_fail = 0usize;

    // Each fixture's replay is independent — Core::new spawns its own
    // libmgba instance, no shared mutable state. Parallelize.
    for (fn_name, seqs) in &by_fn {
        let results: Vec<(usize, Result<String, String>)> = seqs
            .par_iter()
            .map(|&seq| {
                let entry_path =
                    session.join(fn_name).join(format!("{seq:04}.entry.bin"));
                let exit_path =
                    session.join(fn_name).join(format!("{seq:04}.exit.delta.bin"));
                let expected_entry =
                    snapshot::Snapshot::read_from(&entry_path).map_err(|e| e.to_string())?;
                let expected_delta =
                    snapshot::ExitDelta::read_from(&exit_path).map_err(|e| e.to_string())?;
                let actual_exit =
                    replay_single(rom, &expected_entry, &expected_delta)?;
                let diff = snapshot::diff_delta(
                    &expected_delta,
                    &expected_entry,
                    &actual_exit,
                );
                if diff.is_clean() {
                    Ok(String::new())
                } else {
                    Err(describe_diff(&diff))
                }
            })
            .enumerate()
            .map(|(i, r)| (seqs[i], r))
            .collect();

        let mut pass = 0usize;
        let mut fail = 0usize;
        let mut first_fail_msg = String::new();
        for (_, r) in &results {
            total_pairs += 1;
            match r {
                Ok(_) => pass += 1,
                Err(e) => {
                    fail += 1;
                    if first_fail_msg.is_empty() {
                        first_fail_msg = e.clone();
                    }
                }
            }
        }
        total_pass += pass;
        total_fail += fail;
        let tag = if fail == 0 { "PASS" } else { "FAIL" };
        if verbose || fail > 0 {
            println!("[{tag}] {fn_name}: {pass}/{} pairs", pass + fail);
        }
        if !first_fail_msg.is_empty() {
            println!("       first failure: {first_fail_msg}");
        }
    }
    println!(
        "\nTotal: {total_pass}/{total_pairs} pairs passed ({total_fail} failed)"
    );
    if total_fail > 0 {
        process::exit(1);
    }
}

fn replay_single(
    rom: &str,
    entry: &snapshot::Snapshot,
    expected_delta: &snapshot::ExitDelta,
) -> Result<snapshot::Snapshot, String> {
    let _ = expected_delta;
    // Captured LR in r14 is the function's return address (Thumb bit
    // possibly set).
    let target = entry.regs[14] & !1u32;
    isolated_run_to(rom, entry, target)
}

fn describe_diff(d: &snapshot::DiffSummary) -> String {
    if let Some((i, exp, act)) = d.must_match_reg_mismatches().next() {
        return format!(
            "{} mismatch: expected 0x{exp:08X}, got 0x{act:08X}",
            snapshot::REG_NAMES[*i]
        );
    }
    if d.ewram_diff_bytes > 0 {
        let first = d.ewram_first_diff.unwrap_or(0);
        return format!(
            "EWRAM diff: {} bytes (first at 0x0200{:04X})",
            d.ewram_diff_bytes,
            first
        );
    }
    if d.iwram_diff_bytes > 0 {
        let first = d.iwram_first_diff.unwrap_or(0);
        return format!(
            "IWRAM diff: {} bytes (first at 0x0300{:04X})",
            d.iwram_diff_bytes,
            first
        );
    }
    String::new()
}

// ---------------------------------------------------------------------
// verify-all — orchestrator for the bk2 fleet.
//
// Replaces the prior make `-j` fan-out. Owns:
//   • cache lookup/promote per (orig_rom, bk2, fn),
//   • cross-bk2 parallelism (one record thread per bk2; shared
//     rayon pool for the per-bk2 phase-2 pump),
//   • single replay pass across all populated session dirs against
//     the decomp ROM,
//   • unified pass/fail reporting.
//
// The Makefile shrinks to: build orig.gba, build decomp.gba, hand off.
// ---------------------------------------------------------------------

/// Per-bk2 metadata derived from the demos tree. `state` and `input`
/// follow the same resolution order the Makefile used: prefer a folder
/// (`bk2/<stem>/state.ss*`, `bk2/<stem>/inputs.input`) then a flat
/// sibling (`bk2/<stem>.ss*`, `bk2/<stem>.input`).
struct Bk2Job {
    stem: String,
    bk2_path: std::path::PathBuf,
    state_path: std::path::PathBuf,
    input_path: std::path::PathBuf,
    frame_count: u32,
}

fn discover_bk2_jobs(demos_root: &str) -> Result<Vec<Bk2Job>, String> {
    let bk2_dir = std::path::Path::new(demos_root).join("bk2");
    let mut bk2_files: Vec<std::path::PathBuf> = fs::read_dir(&bk2_dir)
        .map_err(|e| format!("read_dir {}: {e}", bk2_dir.display()))?
        .flatten()
        .map(|e| e.path())
        .filter(|p| p.extension().map(|x| x == "bk2").unwrap_or(false))
        .collect();
    bk2_files.sort();

    let mut jobs = Vec::with_capacity(bk2_files.len());
    for bk2 in bk2_files {
        let stem = bk2.file_stem().unwrap().to_string_lossy().into_owned();
        let folder = bk2_dir.join(&stem);

        let state_path = first_existing(&[
            folder.join("state.ss"),
            folder.join("state.ss1"),
            folder.join("state.ss2"),
            bk2_dir.join(format!("{stem}.ss")),
            bk2_dir.join(format!("{stem}.ss1")),
            bk2_dir.join(format!("{stem}.ss2")),
        ])
        .ok_or_else(|| format!("no savestate for {stem}"))?;

        let input_path = first_existing(&[
            folder.join("inputs.input"),
            bk2_dir.join(format!("{stem}.input")),
        ])
        .ok_or_else(|| format!("no .input file for {stem} (run tools/bk2_extract.py)"))?;

        // .input is packed 4 bytes per frame.
        let frame_count = (fs::metadata(&input_path)
            .map_err(|e| format!("stat {}: {e}", input_path.display()))?
            .len()
            / 4) as u32;

        jobs.push(Bk2Job { stem, bk2_path: bk2, state_path, input_path, frame_count });
    }
    Ok(jobs)
}

fn first_existing(candidates: &[std::path::PathBuf]) -> Option<std::path::PathBuf> {
    candidates.iter().find(|p| p.exists()).cloned()
}

fn verify_all(
    orig_rom: &str,
    decomp_rom: &str,
    symbols_path: &str,
    targets_hex: &[String],
    demos_root: &str,
    cache_dir: &str,
    parallel: usize,
) {
    eprintln!("=== bn6f-track verify-all ===");
    eprintln!("orig:   {orig_rom}");
    eprintln!("decomp: {decomp_rom}");
    eprintln!("cache:  {cache_dir}");

    let symbols = read_symbols(symbols_path).unwrap_or_else(|e| {
        eprintln!("read_symbols: {e}");
        process::exit(1);
    });
    let names: HashMap<u32, String> = symbols.iter().cloned().collect();

    // Parse + resolve target addresses to names. A target that isn't in
    // the symbol table is a hard error — caching by name needs a name.
    let target_addrs: Vec<u32> = targets_hex
        .iter()
        .map(|s| {
            let s = s.trim().strip_prefix("0x").unwrap_or(s);
            u32::from_str_radix(s, 16).unwrap_or_else(|e| {
                eprintln!("bad target addr {s}: {e}");
                process::exit(1);
            })
        })
        .collect();
    let target_names: Vec<String> = target_addrs
        .iter()
        .map(|a| {
            names.get(a).cloned().unwrap_or_else(|| {
                eprintln!("target 0x{a:08X} has no symbol — can't cache it");
                process::exit(1);
            })
        })
        .collect();

    let jobs = discover_bk2_jobs(demos_root).unwrap_or_else(|e| {
        eprintln!("discover bk2: {e}");
        process::exit(1);
    });
    eprintln!("bk2 fleet: {} demos, {} target functions", jobs.len(), target_addrs.len());

    let orig_sha = cache::sha1_file_short(std::path::Path::new(orig_rom))
        .unwrap_or_else(|e| { eprintln!("hash orig: {e}"); process::exit(1); });
    eprintln!("orig sha: {orig_sha}");

    // Phase A: per-bk2 record (cache-miss only). One thread per bk2 up
    // to `parallel`. Each record's inner phase-2 pump uses rayon's
    // global pool — work-steals across all bk2s concurrently.
    //
    // Important design choice: record writes directly into the cache
    // directory (no staging into a session dir). The cache IS the
    // session. Saves an O(N pairs) hardlink/copy round-trip on every
    // partial-miss run (used to cost ~20s on a fleet of two bk2s);
    // also keeps the on-disk layout to one source of truth.
    use std::sync::Mutex;
    let job_queue: Mutex<Vec<Bk2Job>> = Mutex::new(jobs);
    let any_failure = std::sync::atomic::AtomicBool::new(false);
    let bk2_cache_roots: Mutex<Vec<(String, std::path::PathBuf)>> =
        Mutex::new(Vec::new());

    std::thread::scope(|s| {
        for _ in 0..parallel.max(1) {
            let job_queue = &job_queue;
            let target_addrs = &target_addrs;
            let target_names = &target_names;
            let symbols_path = &symbols_path;
            let orig_sha = &orig_sha;
            let bk2_cache_roots = &bk2_cache_roots;
            let cache_dir = cache_dir;
            let orig_rom = orig_rom;
            let any_failure = &any_failure;
            s.spawn(move || {
                loop {
                    let job = { job_queue.lock().unwrap().pop() };
                    let Some(job) = job else { break; };
                    match record_one_bk2_with_cache(
                        orig_rom, symbols_path, &job, target_addrs,
                        target_names, orig_sha, cache_dir,
                    ) {
                        Ok(root) => {
                            bk2_cache_roots.lock().unwrap()
                                .push((job.stem.clone(), root));
                        }
                        Err(e) => {
                            eprintln!("[{}] record failed: {e}", job.stem);
                            any_failure.store(true, std::sync::atomic::Ordering::Relaxed);
                        }
                    }
                }
            });
        }
    });

    if any_failure.load(std::sync::atomic::Ordering::Relaxed) {
        eprintln!("verify-all: one or more bk2 records failed");
        process::exit(1);
    }

    // Phase B: replay every populated cache root vs decomp ROM.
    //
    // Incremental verification (Opt D): for each fn in each cache root,
    // compute the "code radius" sha = sha1 of decomp_rom bytes covering
    // the fn AND every fn it transitively calls (per the callgraph
    // captured during record). A fn whose radius sha matches its last
    // green-replay sha (stored in `pair_pass.txt` next to the cache)
    // is provably still passing — its bytes and every callee's bytes
    // are unchanged since the last green run, so every captured pair
    // for it will still pass. Skip those pairs entirely. On a typical
    // edit touching 1-3 fns, this prunes ~9670 of 9677 pairs.
    eprintln!("\n--- phase B: replay vs decomp ---");
    let session_dirs: Vec<(String, std::path::PathBuf)> =
        bk2_cache_roots.into_inner().unwrap();

    // One-time setup: decomp ROM bytes + per-fn (start, end_exclusive)
    // ranges. End is the next fn's start in sorted symbol order (same
    // convention as FN_END used during record).
    let decomp_bytes = fs::read(decomp_rom).unwrap_or_else(|e| {
        eprintln!("read decomp rom: {e}");
        process::exit(1);
    });
    let fn_ranges = build_fn_ranges(&symbols);

    use rayon::prelude::*;
    let mut work: Vec<(String, std::path::PathBuf, String, usize)> = Vec::new();
    let mut per_session_count: HashMap<String, (usize, usize)> = HashMap::new();
    // Per (session, fn): radius_sha used for the skip decision. After
    // replay completes we record radius_sha back to disk only for fns
    // whose pairs all passed.
    let mut session_fn_radius: HashMap<(String, String), String> = HashMap::new();
    let mut session_skipped: HashMap<String, usize> = HashMap::new();

    for (sname, cache_root) in &session_dirs {
        per_session_count.entry(sname.clone()).or_insert((0, 0));

        // Load the bk2's callgraph + last-pass cache. Missing
        // callgraph.txt (e.g. cache populated by an older version)
        // disables incremental for this bk2 — safer than over-skipping.
        let callgraph_path = cache_root.join("callgraph.txt");
        let pair_pass_path = cache_root.join("pair_pass.txt");
        let has_callgraph = callgraph_path.exists();
        let callgraph: HashMap<String, Vec<String>> = cache::read_kv_csv(&callgraph_path)
            .into_iter().collect();
        let prior_pass: HashMap<String, String> = cache::read_kv_csv(&pair_pass_path)
            .into_iter().filter_map(|(k, mut vs)| vs.pop().map(|v| (k, v)))
            .collect();

        let Ok(rd) = fs::read_dir(cache_root) else { continue; };
        for fn_entry in rd.flatten() {
            let fn_path = fn_entry.path();
            if !fn_path.is_dir() { continue; }
            let fn_name = fn_entry.file_name().to_string_lossy().into_owned();

            let radius_sha = if has_callgraph {
                radius_sha_for(&fn_name, &callgraph, &fn_ranges, &decomp_bytes)
            } else {
                String::new()
            };

            // Skip if prior pass exists at the same radius sha. Empty
            // sha (no callgraph data) never matches a real one, so
            // this gracefully falls through to running all pairs.
            if has_callgraph && !radius_sha.is_empty()
                && prior_pass.get(&fn_name) == Some(&radius_sha)
            {
                *session_skipped.entry(sname.clone()).or_insert(0) += 1;
                continue;
            }

            session_fn_radius.insert(
                (sname.clone(), fn_name.clone()), radius_sha,
            );

            let Ok(sub_rd) = fs::read_dir(&fn_path) else { continue; };
            for sub in sub_rd.flatten() {
                let fname = sub.file_name().to_string_lossy().into_owned();
                if let Some(seq_str) = fname.strip_suffix(".entry.bin") {
                    if let Ok(seq) = seq_str.parse::<usize>() {
                        work.push((sname.clone(), fn_path.clone(), fn_name.clone(), seq));
                    }
                }
            }
        }
    }
    let total_skipped: usize = session_skipped.values().sum();
    eprintln!(
        "phase B: {} pairs to run, {} fns skipped via incremental cache",
        work.len(), total_skipped,
    );

    let results: Vec<(String, String, bool)> = work.par_iter().map(|(sname, fn_dir, fn_name, seq)| {
        let entry_p = fn_dir.join(format!("{seq:04}.entry.bin"));
        let exit_p  = fn_dir.join(format!("{seq:04}.exit.delta.bin"));
        let ok = || -> Result<bool, String> {
            let ee = snapshot::Snapshot::read_from(&entry_p).map_err(|e| e.to_string())?;
            let ed = snapshot::ExitDelta::read_from(&exit_p).map_err(|e| e.to_string())?;
            let ax = replay_single(decomp_rom, &ee, &ed)?;
            Ok(snapshot::diff_delta(&ed, &ee, &ax).is_clean())
        }();
        (sname.clone(), fn_name.clone(), ok.unwrap_or(false))
    }).collect();

    // Tally per (session, fn) so we know which fns can be marked as
    // "passed at this radius sha" for next-run skip eligibility.
    let mut fn_pass: HashMap<(String, String), (usize, usize)> = HashMap::new();
    let mut grand_pairs = 0usize;
    let mut grand_pass = 0usize;
    let mut grand_fail = 0usize;
    for (sname, fn_name, ok) in results {
        let e = per_session_count.entry(sname.clone()).or_insert((0, 0));
        let f = fn_pass.entry((sname, fn_name)).or_insert((0, 0));
        if ok { e.0 += 1; f.0 += 1; } else { e.1 += 1; f.1 += 1; }
        grand_pairs += 1;
        if ok { grand_pass += 1 } else { grand_fail += 1 }
    }

    // Carry forward last-pass cache entries we skipped this run (they
    // remain valid since we didn't touch the inputs), then merge in
    // fresh passes from the just-completed run. Write back per bk2.
    for (sname, cache_root) in &session_dirs {
        let pair_pass_path = cache_root.join("pair_pass.txt");
        let mut merged: HashMap<String, String> = cache::read_kv_csv(&pair_pass_path)
            .into_iter().filter_map(|(k, mut vs)| vs.pop().map(|v| (k, v)))
            .collect();
        for ((sn, fn_name), (pass, fail)) in &fn_pass {
            if sn != sname { continue; }
            if *fail == 0 {
                if let Some(radius) = session_fn_radius
                    .get(&(sname.clone(), fn_name.clone()))
                {
                    if !radius.is_empty() {
                        merged.insert(fn_name.clone(), radius.clone());
                    }
                }
            } else {
                // Don't poison the cache with a stale "pass" if this
                // run regressed.
                let _ = pass;
                merged.remove(fn_name);
            }
        }
        let entries: Vec<(String, Vec<String>)> = merged.into_iter()
            .map(|(k, v)| (k, vec![v]))
            .collect();
        if let Err(e) = cache::write_kv_csv(&pair_pass_path, &entries) {
            eprintln!("[{sname}] write pair_pass: {e}");
        }
    }

    for (name, (p, f)) in &per_session_count {
        let skipped = session_skipped.get(name).copied().unwrap_or(0);
        eprintln!(
            "[{name}] {p}/{} pairs ({f} failed; {skipped} fns skipped)",
            p + f,
        );
    }

    if grand_pairs == 0 {
        println!(
            "\nverify-all: all {total_skipped} fns trusted via incremental cache (no pairs needed replay)"
        );
    } else {
        println!(
            "\nverify-all: {grand_pass}/{grand_pairs} pairs passed ({grand_fail} failed); {total_skipped} fns trusted via incremental cache"
        );
    }
    if grand_fail > 0 {
        process::exit(1);
    }
}

/// Build (start, end_exclusive) byte ranges per fn name from a sorted
/// symbol list. End = next fn's start; tail fn extends to ROM end
/// (we cap at u32::MAX; the decomp ROM read clips at its true length).
fn build_fn_ranges(symbols: &[(u32, String)]) -> HashMap<String, (u32, u32)> {
    let mut by_addr: Vec<(u32, String)> = symbols.to_vec();
    by_addr.sort_by_key(|(a, _)| *a);
    let mut out = HashMap::new();
    for i in 0..by_addr.len() {
        let (start, name) = (by_addr[i].0, by_addr[i].1.clone());
        let end = by_addr.get(i + 1).map(|(a, _)| *a).unwrap_or(u32::MAX);
        out.insert(name, (start, end));
    }
    out
}

/// Compute sha1 of the concatenated decomp-ROM bytes covering `fn_name`
/// and every fn it transitively calls (per the captured callgraph).
/// Sorting the closure makes the hash stable across callgraph
/// permutations. Hex-truncated to 12 chars to match the rest of the
/// cache's key conventions.
fn radius_sha_for(
    fn_name: &str,
    callgraph: &HashMap<String, Vec<String>>,
    fn_ranges: &HashMap<String, (u32, u32)>,
    decomp_bytes: &[u8],
) -> String {
    const ROM_BASE: u32 = 0x08000000;
    // BFS over callees.
    let mut closure: Vec<String> = Vec::new();
    let mut visited: HashSet<String> = HashSet::new();
    let mut queue: Vec<String> = vec![fn_name.to_string()];
    while let Some(cur) = queue.pop() {
        if !visited.insert(cur.clone()) { continue; }
        closure.push(cur.clone());
        if let Some(callees) = callgraph.get(&cur) {
            for c in callees {
                if !visited.contains(c) {
                    queue.push(c.clone());
                }
            }
        }
    }
    closure.sort();

    use sha1::{Digest, Sha1};
    let mut h = Sha1::new();
    for name in &closure {
        let Some(&(start, end)) = fn_ranges.get(name) else { continue; };
        if start < ROM_BASE { continue; }
        let lo = (start - ROM_BASE) as usize;
        let hi = (end.saturating_sub(ROM_BASE)) as usize;
        let hi = hi.min(decomp_bytes.len());
        if lo >= decomp_bytes.len() || lo >= hi { continue; }
        h.update(&decomp_bytes[lo..hi]);
    }
    let digest = h.finalize();
    let mut s = String::with_capacity(12);
    for &b in &digest[..6] {
        s.push_str(&format!("{b:02x}"));
    }
    s
}

#[allow(clippy::too_many_arguments)]
fn record_one_bk2_with_cache(
    orig_rom: &str,
    symbols_path: &str,
    job: &Bk2Job,
    target_addrs: &[u32],
    target_names: &[String],
    orig_sha: &str,
    cache_dir: &str,
) -> Result<std::path::PathBuf, String> {
    let bk2_sha = cache::sha1_file_short(&job.input_path)?;
    let cache = cache::Bk2CacheDir::open(
        std::path::Path::new(cache_dir), orig_sha, &bk2_sha,
    ).map_err(|e| format!("open cache: {e}"))?;

    // Split targets into cached vs uncached. `cached` doesn't need any
    // action — replay walks the cache dir directly.
    let mut cached_n = 0usize;
    let mut uncached: Vec<(u32, String)> = Vec::new();
    for (addr, name) in target_addrs.iter().zip(target_names.iter()) {
        if cache.is_fn_cached(name) {
            cached_n += 1;
        } else {
            uncached.push((*addr, name.clone()));
        }
    }
    eprintln!(
        "[{}] cache: {} hit, {} miss",
        job.stem, cached_n, uncached.len()
    );

    if !uncached.is_empty() {
        // record() writes directly into the cache root: pairs land in
        // <cache_root>/<fn_name>/NNNN.{entry,exit.delta}.bin, matching
        // the per-fn cache layout. No staging into a session dir, no
        // post-promote step.
        let uncached_hex: Vec<String> =
            uncached.iter().map(|(a, _)| format!("{a:08X}")).collect();
        record(
            orig_rom,
            job.frame_count,
            symbols_path,
            cache.root.to_str().unwrap(),
            &uncached_hex,
            job.input_path.to_str(),
            job.state_path.to_str(),
            /*dedup=*/ true,
            /*progress=*/ 0,
            /*verbose=*/ false,
        );

        // Stamp every uncached fn as "considered" so a target that was
        // in RECORD_TARGETS but never fired in this bk2 still counts
        // as cached on the next run. Without this, those targets show
        // up as miss every run and the cache never fully warms.
        for (_, name) in &uncached {
            cache.mark_considered(name)
                .map_err(|e| format!("mark considered {name}: {e}"))?;
        }

        // Persist the forward callgraph for incremental verify.
        // Snapshot the thread_local CALLGRAPH (populated during record)
        // and translate addrs → names so the file is portable across
        // builds. Top-level / unknown callers/callees are dropped.
        let symbols = read_symbols(symbols_path).map_err(|e| e.to_string())?;
        let addr_to_name: HashMap<u32, String> =
            symbols.into_iter().collect();
        let edges: Vec<(String, Vec<String>)> = CALLGRAPH.with(|m| {
            m.borrow().iter().filter_map(|(caller, callees)| {
                let cname = addr_to_name.get(caller)?.clone();
                let mut named: Vec<String> = callees.iter()
                    .filter_map(|a| addr_to_name.get(a).cloned())
                    .collect();
                named.sort();
                named.dedup();
                Some((cname, named))
            }).collect()
        });
        cache::write_kv_csv(&cache.callgraph_path(), &edges)
            .map_err(|e| format!("write callgraph: {e}"))?;
    }

    Ok(cache.root.clone())
}

fn usage(prog: &str) -> ! {
    eprintln!(
        "usage:\n  {prog} smoke  ROM [FRAMES]\n  {prog} track  ROM FRAMES SYMBOLS [OUTPUT]\n  {prog} record ROM FRAMES SYMBOLS SESSION_DIR [--input P] [--state P] [--no-dedup] [--progress N] [--verbose|-v] FN_ADDR [FN_ADDR...]\n  {prog} replay ROM SESSION_DIR [--verbose|-v]\n  {prog} verify-all --orig ROM --decomp ROM --symbols PATH --demos-root DIR --cache-dir DIR [--parallel N] FN_ADDR [FN_ADDR...]\n\nLegacy positional form (deprecated):\n  {prog} ROM FRAMES SYMBOLS [OUTPUT]   (= track)\n  {prog} ROM [FRAMES]                  (= smoke)"
    );
    process::exit(2);
}

fn main() {
    silence_libmgba_logger();

    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        usage(&args[0]);
    }

    // Subcommand dispatch with legacy fallback to keep `make track` working.
    match args[1].as_str() {
        "smoke" => {
            let rom = args.get(2).unwrap_or_else(|| usage(&args[0]));
            let frames: u32 = args.get(3).and_then(|s| s.parse().ok()).unwrap_or(60);
            smoke_test(rom, frames);
        }
        "track" => {
            // track <rom> <frames> <symbols> [output] [--input <path>]
            let rom = args.get(2).unwrap_or_else(|| usage(&args[0]));
            let frames: u32 = args.get(3).and_then(|s| s.parse().ok()).unwrap_or(300);
            let symbols = args.get(4).unwrap_or_else(|| usage(&args[0]));
            let mut rest = &args[5..];
            let mut output: Option<&str> = None;
            if let Some(a) = rest.first() {
                if a != "--input" {
                    output = Some(a.as_str());
                    rest = &rest[1..];
                }
            }
            let mut input_path: Option<&str> = None;
            if rest.first().map(String::as_str) == Some("--input") {
                input_path = rest.get(1).map(String::as_str);
                if input_path.is_none() {
                    eprintln!("--input needs a path");
                    usage(&args[0]);
                }
            }
            track(rom, frames, symbols, output, input_path);
        }
        "record" => {
            // record <rom> <frames> <symbols> <session_dir>
            //        [--input <path>] [--state <path>] <targets...>
            let rom = args.get(2).unwrap_or_else(|| usage(&args[0]));
            let frames: u32 =
                args.get(3).and_then(|s| s.parse().ok()).unwrap_or_else(|| usage(&args[0]));
            let symbols = args.get(4).unwrap_or_else(|| usage(&args[0]));
            let session_dir = args.get(5).unwrap_or_else(|| usage(&args[0]));
            let mut rest = &args[6..];
            let mut input_path: Option<String> = None;
            let mut state_path: Option<String> = None;
            let mut dedup = true;
            let mut progress_every: u32 = 0;
            let mut verbose = false;
            // Accept --input, --state, --no-dedup, --progress, --verbose
            // in any order; all optional.
            loop {
                match rest.first().map(String::as_str) {
                    Some("--input") => {
                        input_path = rest.get(1).cloned();
                        if input_path.is_none() {
                            eprintln!("--input needs a path");
                            usage(&args[0]);
                        }
                        rest = &rest[2..];
                    }
                    Some("--state") => {
                        state_path = rest.get(1).cloned();
                        if state_path.is_none() {
                            eprintln!("--state needs a path");
                            usage(&args[0]);
                        }
                        rest = &rest[2..];
                    }
                    Some("--no-dedup") => {
                        dedup = false;
                        rest = &rest[1..];
                    }
                    Some("--progress") => {
                        progress_every = rest.get(1).and_then(|s| s.parse().ok())
                            .unwrap_or_else(|| {
                                eprintln!("--progress needs a non-negative integer");
                                usage(&args[0]);
                            });
                        rest = &rest[2..];
                    }
                    Some("--verbose") | Some("-v") => {
                        verbose = true;
                        rest = &rest[1..];
                    }
                    _ => break,
                }
            }
            if rest.is_empty() {
                usage(&args[0]);
            }
            let targets: Vec<String> = rest.to_vec();
            record(rom, frames, symbols, session_dir, &targets,
                   input_path.as_deref(), state_path.as_deref(), dedup,
                   progress_every, verbose);
        }
        "replay" => {
            let rom = args.get(2).unwrap_or_else(|| usage(&args[0]));
            let session_dir = args.get(3).unwrap_or_else(|| usage(&args[0]));
            let verbose = args[4..].iter().any(|a| a == "--verbose" || a == "-v");
            replay(rom, session_dir, verbose);
        }
        "verify-all" => {
            let mut orig: Option<String> = None;
            let mut decomp: Option<String> = None;
            let mut symbols: Option<String> = None;
            let mut demos_root: Option<String> = None;
            let mut cache_dir: Option<String> = None;
            let mut parallel: usize = std::thread::available_parallelism()
                .map(|n| n.get()).unwrap_or(4);
            let mut rest = &args[2..];
            loop {
                match rest.first().map(String::as_str) {
                    Some("--orig") => { orig = rest.get(1).cloned(); rest = &rest[2..]; }
                    Some("--decomp") => { decomp = rest.get(1).cloned(); rest = &rest[2..]; }
                    Some("--symbols") => { symbols = rest.get(1).cloned(); rest = &rest[2..]; }
                    Some("--demos-root") => { demos_root = rest.get(1).cloned(); rest = &rest[2..]; }
                    Some("--cache-dir") => { cache_dir = rest.get(1).cloned(); rest = &rest[2..]; }
                    Some("--parallel") => {
                        parallel = rest.get(1).and_then(|s| s.parse().ok())
                            .unwrap_or_else(|| { eprintln!("--parallel needs N"); usage(&args[0]); });
                        rest = &rest[2..];
                    }
                    _ => break,
                }
            }
            let orig = orig.unwrap_or_else(|| { eprintln!("--orig required"); usage(&args[0]); });
            let decomp = decomp.unwrap_or_else(|| { eprintln!("--decomp required"); usage(&args[0]); });
            let symbols = symbols.unwrap_or_else(|| { eprintln!("--symbols required"); usage(&args[0]); });
            let demos_root = demos_root.unwrap_or_else(|| { eprintln!("--demos-root required"); usage(&args[0]); });
            let cache_dir = cache_dir.unwrap_or_else(|| { eprintln!("--cache-dir required"); usage(&args[0]); });
            if rest.is_empty() {
                eprintln!("verify-all needs at least one FN_ADDR");
                usage(&args[0]);
            }
            let targets: Vec<String> = rest.to_vec();
            verify_all(&orig, &decomp, &symbols, &targets, &demos_root, &cache_dir, parallel);
        }
        // Legacy positional form: first positional is the ROM. We keep
        // this so existing Makefile targets and scripts continue to work.
        _ => {
            let rom = &args[1];
            let frames: u32 = args.get(2).and_then(|s| s.parse().ok()).unwrap_or(60);
            match args.get(3) {
                Some(symbols) => track(rom, frames, symbols, args.get(4).map(String::as_str), None),
                None => smoke_test(rom, frames),
            }
        }
    }
}
