# Previous work — record before clean-slate reset (2026-06-04)

We are rebuilding the decomp **harness and process from first principles**.
As "brick -1" we reset the working tree to the **pre-decomp base** and remove
all the decomp/harness/tooling/review work built since, recording it here so any
of it can be restored verbatim from git. **Nothing is lost — it's all in history.**

## The two anchors

| | commit | meaning |
|---|---|---|
| **Base (reset target)** | `adc8595b` | last pristine disassembly commit, *before* any C-decomp work. Parent of the first decomp commit `46cb3e36` ("Set up decomp verification harness on libmgba+Rust"). |
| **Tip (everything we're shelving)** | `e6bb4969` | HEAD at reset time — the full accumulated decomp effort. |

Span removed: **324 commits** (`46cb3e36..e6bb4969`), all decomp/harness/tooling/
docs/review — verified: no base-disassembly continuation landed in that range.

## What was removed (by category — not enumerated patch-by-patch)

- **C conversions** — `src/c/` (491 tracked files: the C reimplementations plus
  their harness glue). The authoritative list of *which* functions were converted
  is `tools/decomp_manifest.txt` (**534 entries**), preserved in git at the tip.
- **In-place trampolines** — `.ifndef DECOMP_<sym>` trampoline blocks injected
  into **28 `asm/*.s`** files (reverted to pristine), plus the
  `decomp_trampoline` / `DECOMP_VTABLE_WRAPPER` / `DECOMP_FLAG_WRAPPER` macros in
  `include/macros/function.inc`, the `decompile` target + defsym logic in the
  `Makefile`, and `ld_script_decompile.ld`.
- **Old validation harness** — `tools/bn6f-validate/` (Rust pixel-hash validator),
  vendored `tools/libmgba/`, plus `tests/` (bk2 fixtures + harness scripts).
- **Decomp tooling** — `tools/wrap_decomp.py`, `tools/function_card.py`,
  `tools/validate_asm.py`, `tools/decomp_manifest.txt`, `tools/claim.py`/`AGENTS.md`
  (already removed earlier this session), `tools/find_decomp_candidates.py`.
- **Planning / review docs** — `cyow/` (this toolkit review, 38 files),
  `token_todo.md`, `structs_plan.md`, `issues/`, decomp `docs/`, and assorted
  Claude-added `constants/` headers.

`.claude/` (memory, cron history) and the new from-scratch harness scaffold
`tools/harness/` are **kept**.

## How to restore

Everything is recoverable from the tip commit. To bring back the whole prior
state into the working tree:

```bash
git checkout e6bb4969 -- .        # restore every tracked file as of the tip
```

Selective restore (examples):

```bash
git checkout e6bb4969 -- tools/bn6f-validate   # just the old validator
git checkout e6bb4969 -- src/c                 # just the C conversions
git show e6bb4969:tools/decomp_manifest.txt    # the list of converted symbols
git checkout e6bb4969 -- asm/                  # the trampolined asm (don't mix w/ base!)
git checkout e6bb4969 -- tools/libmgba         # vendored emulator lib (see note)
```

**Note on `tools/libmgba/`:** the vendored mGBA build (`lib/*.so` + `include/`)
was tracked, so it was removed from disk too. The new harness
(`tools/harness/`) binds to it via `build.rs` (`../libmgba`), so restore it
with the command above the first time you build a brick that needs the emulator.
The new untracked scaffold `tools/harness/` survived the reset.

To inspect the cyow review without restoring: `git show e6bb4969:cyow/00-index.md`.

---
_Last updated: 2026-06-04 14:06:40 -0400_
