---
description: One iteration of fast continuous ASM→C decomp. Pick a candidate, convert, verify, commit, push, compact. Designed to be driven by `/loop /decomp-step` — move fast, revert ruthlessly on failure, lean on the cache so each iteration is cheap.
---

You are the **decomp workhorse**. The infrastructure is fast:
- Incremental verify means a green pass is ~5s.
- Per-fn cache means only changed-radius pairs replay.
- There are thousands of candidate functions still in ASM.

Goal each iteration: **a batch of 3-5 converted functions, committed individually, pushed.**

Verify is the bottleneck (~57s per run) — its cost is fixed regardless of how many fns are added between runs. Batching N conversions per verify cuts wall-time ~N×.

Don't agonize. Don't deeply debug. If a batch goes red, pick out the failing fn(s), revert just those, and ship the rest. Move.

## Timing (record at iteration start)

Before picking a candidate, capture the start wall-clock:

```sh
date -u +%s > /tmp/decomp_step_start
```

You'll write a stats row at the end. Don't skip this — running stats are what tell us if the workhorse is getting faster, slower, or stuck.

## Pick a batch (≤2 minutes)

Choose **3-5** candidates. Each must meet ALL of:
- Not in `tools/decomp_manifest.txt`.
- Address ends in `0`, `4`, `8`, or `C` (4-aligned — `decomp_trampoline` only works there).
- 4-12 thumb instructions.
- Pure leaf or near-leaf. No `mov lr, pc; bx`, no `svc`, no flag-dependent callers (callers immediately doing `beq/bne` after the `bl`).
- **Multi-return check:** if ASM writes both r0 AND r1 (and doesn't immediately overwrite r1), grep callers for use of r1 after the `bl`. If any does `cmp r1`, `mov X, r1`, etc., skip — a plain `return foo;` C version silently drops the r1 return and breaks those callers. (Cautionary tale: `screenFade_80062C8` looked trivial; npc.s caller does `cmp r1, #0; beq ...`.)
- **No vtable callees.** If `.word <sym>` appears in any asm file (= sym is in a function-pointer table), it's called via `mov lr, pc; bx rN` indirection. That pattern sets `lr` WITHOUT the thumb bit; the original returns with `mov pc, lr` which preserves thumb mode, but agbcc-compiled C returns with `bx lr` which interworks based on lr's bit 0 — and `lr` has bit 0 = 0, so `bx lr` switches to ARM mode → caller's next instruction is misinterpreted → massive silent failures. Check: `grep ".word <sym>" asm/*.s` before picking. (Cautionary tale: `sub_81231E0` looked like a 4-instr trivial u16 write; vtable-dispatched from `asm32.s` table `off_81211D0`; entire cluster of 5 twins all blew up.)

One-liner to surface candidates:
```sh
for f in asm/asm*.s; do awk '/thumb_func_start/{n=$NF; s=NR; next} /thumb_func_end/{print NR-s, n}' "$f"; done | sort -n | head -50
```
Then cross-check against the manifest, the address (`tools/function_symbols.txt`), and a quick ASM glance.

If the first candidate looks tricky, **skip it** and pick another. Don't reason your way through an awkward one when there are thousands.

Prefer candidates that look like prior conversions you've shipped — twins of fns already in the manifest (same Toolkit-field pattern, same EWRAM-zero pattern) are very fast since you already know the offsets.

## Convert each (3-5 minutes per fn)

For every candidate in the batch:

- Write `src/c/<lowercase_name>.c` — include `"types.h"`, match the ASM semantically. Use the r5/r10 register-asm pattern (`[[reference_struct_offsets]]` for byte offsets — don't re-grep `.inc` files).
- Wrap the asm with `.ifndef DECOMP_<sym>` / `.else` / `decomp_trampoline <sym>_c, <pad>` / `.endif`. Pad = `original_byte_size - 8`.
- Append `<sym>` to `tools/decomp_manifest.txt`.

Keep a mental (or actual) list of `(symbol, asm_file, c_file)` so you can later revert specific fns surgically.

## Verify the batch (~57s)

```sh
/usr/bin/time -f "%e" -o /tmp/decomp_step_verify make verify 2>&1 | tee /tmp/decomp_step_log
```

Inspect the log:

- **Green (`0 failed` across all sessions):** all conversions are good. Skip to "Commit individually".
- **Red:** parse the log for `[FAIL] <fn_name>:` lines AND `first failure: ...` lines. Each FAIL line names a fn whose pairs broke. That's your suspect set.

  Some failing fns may be *callers* of a buggy new conversion (their radius includes a regressed callee). The buggy fn itself usually fails too. Look at the SHARED set of fns named in FAIL lines — anything in your batch that also appears there is a suspect.

  For each suspect fn in your batch:
  1. Try ONE obvious-fix attempt (wrong offset, miscounted pad, u8 vs u16 vs u32, missing `register asm("rN")`, signed-vs-unsigned).
  2. If the obvious fix isn't apparent or doesn't help, **revert just that fn**:
     ```sh
     git checkout asm/<file>.s            # restores the pre-trampoline block + the matching manifest line
     git checkout tools/decomp_manifest.txt
     # re-apply OTHER batch members' manifest edits + asm edits if needed
     rm src/c/<bad>.c
     ```
     A cleaner approach: keep each batch member's edits as a separate uncommitted diff (use `git stash` per fn) so you can re-apply selectively. Or just revert the whole batch and pick the survivors to re-apply.

  3. Re-verify. If still red, revert another suspect. Iterate until green.
  4. If you can't get to green after reverting all suspects in the batch, something else is broken — bail to the user.

**Time budget for batch failure resolution: ≤10 minutes.** Beyond that, revert the whole batch and bail.

## Commit individually + push (1-2 minutes total)

Each surviving fn gets its OWN commit so history stays grep-able by symbol. The verify pass result is the same — we just chose the units of commit independently from the units of verification.

```sh
# Stage + commit per-fn
for sym in <list_of_surviving_syms>; do
  git add asm/<asm_file_for_$sym>.s src/c/<c_file_for_$sym>.c tools/decomp_manifest.txt
  git commit -m "Convert $sym — <one-line>"
done
git push  # one push after all commits
```

The manifest gets added repeatedly across the per-fn commits — that's fine, git will only diff the relevant manifest line into each commit because the cumulative file already has all the new lines.

## Stats — one row per fn in the batch

Append one TSV row per fn to `.claude/decomp_stats.tsv`. Columns:

```
ts	symbol	status	total_s	verify_s	overhead_s	retries	notes
```

- `ts`: ISO 8601 UTC (same `ts` for all rows in this batch — they share a verify)
- `symbol`: function name
- `status`: `pass` | `revert` | `bail`
- `total_s`: `(now - start) / batch_size` (amortised wall cost per fn)
- `verify_s`: contents of `/tmp/decomp_step_verify` (per-fn share = `verify_s / batch_size`; record the unaccelerated verify time here — easier to reason about)
- `overhead_s`: `total_s - (verify_s / batch_size)` — your own work per fn (picking, reading asm, writing C, debugging failures). **This is the lever you control.** If verify is 57s and you're spending 60s per fn on overhead, the verify isn't the bottleneck anymore — you are.
- `retries`: number of verify retries this iteration (0 on first-try green)
- `notes`: `-` on pass, short reason on revert (`offset wrong`, `r5-asm clobber`, `pad miscount`, `vtable callee`), `bail: <why>` on bail

Create the header row if the file is new. After appending, glance at
the last ~10 rows — if median total_s is climbing or retry rate is
up, flag it in your reply. Otherwise silent.

## Memory write — BEFORE compact

If this iteration surfaced **a generalizable lesson** the next iteration will want, write it to memory now. Examples:
- A new struct offset not in `[[reference_struct_offsets]]` (extend it).
- A new register/calling convention pattern.
- A non-obvious macro behavior or build gotcha.
- A class of ASM you should AVOID picking (saves time on candidate selection).

Most iterations have nothing to save. Skip unless a future-you would clearly benefit.

## Compact — last action

`/compact`. This iteration's context (the asm searches, verify output, false starts) is no longer load-bearing — it's in git, manifest, memory, and cache. Free the tokens.

**Never compact before commit + memory write.** Compaction summarizes; specifics get lost.

## Anti-patterns to avoid

- Reading the entire asm file. Use targeted grep/awk.
- Trying to understand an unfamiliar pattern from scratch. Skip the candidate.
- Debugging a single fn for more than 5 minutes after a batch failure. Revert that fn, ship the rest.
- Picking a batch where multiple members touch the same asm block (their `.ifndef` wraps would collide). Always pick fns from distinct edit locations.
- Picking a batch all in one tight call cluster. If they all call each other and one breaks, they ALL break — making suspect identification harder. Prefer diversity.
- Batching > 5. Suspect identification gets confusing; the per-batch failure radius widens.
- Writing long commit messages explaining the conversion. The diff is the doc.
- Quoting verify output verbatim in your reply. State counts and move.
- Calling subagents. The work is sequential and cheap; no parallelism win.
- Skipping stats rows. Every fn — pass, revert, or bail — gets a row.

## Stop conditions

Bail to the user (don't compact) when:
- 3 consecutive candidates revert. Suggests a real issue (build broken, infra regression).
- `make verify` itself errors (not just fails — actually errors, e.g. build error unrelated to your change).
- You hit a gotcha not covered in memory or this skill that's worth a human decision.
