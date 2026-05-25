---
description: One iteration of fast continuous ASM→C decomp. Pick a candidate, convert, verify, commit, push, compact. Designed to be driven by `/loop /decomp-step` — move fast, revert ruthlessly on failure, lean on the cache so each iteration is cheap.
---

You are the **decomp workhorse**. The infrastructure is fast:
- Incremental verify means a green pass is ~5s.
- Per-fn cache means only changed-radius pairs replay.
- There are thousands of candidate functions still in ASM.

Goal each iteration: **one converted function, committed and pushed.**
Don't agonize. Don't deeply debug. If it doesn't go cleanly, revert and pick another. Move.

## Timing (record at iteration start)

Before picking a candidate, capture the start wall-clock:

```sh
date -u +%s > /tmp/decomp_step_start
```

You'll write a stats row at the end. Don't skip this — running stats are what tell us if the workhorse is getting faster, slower, or stuck.

## Pick (≤1 minute)

Find a fn meeting ALL of:
- Not in `tools/decomp_manifest.txt`.
- Address ends in `0`, `4`, `8`, or `C` (4-aligned — `decomp_trampoline` only works there).
- 4-12 thumb instructions.
- Pure leaf or near-leaf. No `mov lr, pc; bx`, no `svc`, no flag-dependent callers (callers immediately doing `beq/bne` after the `bl`).

One-liner to surface candidates:
```sh
for f in asm/asm*.s; do awk '/thumb_func_start/{n=$NF; s=NR; next} /thumb_func_end/{print NR-s, n}' "$f"; done | sort -n | head -50
```
Then cross-check against the manifest, the address (`tools/function_symbols.txt`), and a quick ASM glance.

If the first candidate looks tricky, **skip it** and pick another. Don't reason your way through an awkward one when there are thousands.

## Convert (3-5 minutes)

- Write `src/c/<lowercase_name>.c` — include `"types.h"`, match the ASM semantically. Use the r5/r10 register-asm pattern (`[[reference_struct_offsets]]` for byte offsets — don't re-grep `.inc` files).
- Wrap the asm with `.ifndef DECOMP_<sym>` / `.else` / `decomp_trampoline <sym>_c, <pad>` / `.endif`. Pad = `original_byte_size - 8`.
- Append `<sym>` to `tools/decomp_manifest.txt`.

## Verify (~5-60s)

Capture the verify wall-clock — useful signal in the stats row:

```sh
/usr/bin/time -f "%e" -o /tmp/decomp_step_verify make verify
```

Three outcomes:

- **Green (0 failed):** commit + push + compact + done. Move to next iteration.
- **Red, obvious fix** (wrong offset, miscounted padding, u8 vs u16): fix it, re-verify. ONE retry.
- **Red after retry, or non-obvious failure:** revert and pick another.
  ```sh
  git checkout asm/<file>.s tools/decomp_manifest.txt && rm src/c/<file>.c
  ```
  Then pick a new candidate. **Do not spend more than 5 minutes debugging a single function.** The pipeline is fast; throwput beats persistence on any individual fn.

## Commit + push (1 minute)

One-liner subject like the existing convention: `Convert sub_XXXXXXX — <one-line semantic>`.
Body only if non-obvious. `Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>` trailer.

```sh
git add asm/<file>.s src/c/<new>.c tools/decomp_manifest.txt
git commit -m "Convert <sym> — <one-line>"
git push
```

## Stats — append a row before compact

Write one TSV row to `.claude/decomp_stats.tsv` capturing this
iteration. Columns:

```
ts	symbol	status	total_s	verify_s	retries	notes
```

- `ts`: ISO 8601 UTC (`date -u +%Y-%m-%dT%H:%M:%SZ`)
- `symbol`: the function name (or `-` if the iteration bailed before picking)
- `status`: `pass` | `revert` | `bail`
- `total_s`: `$(($(date -u +%s) - $(cat /tmp/decomp_step_start)))`
- `verify_s`: contents of `/tmp/decomp_step_verify` (or `-` if you didn't reach verify)
- `retries`: number of verify retries this iteration (0 on first-try pass)
- `notes`: short reason on revert/bail (`bad alignment`, `unfamiliar pattern`, `agbcc miscompile?`); `-` on clean pass

Append, don't overwrite. Create the file with a header row if missing.
One row per iteration — pass and revert both count.

After appending, **glance at the last 10 rows**. If the trend is
worsening (median total_s climbing, retry rate up), flag it to the
user in your reply. Otherwise just append silently.

```sh
[ -f .claude/decomp_stats.tsv ] || \
  printf 'ts\tsymbol\tstatus\ttotal_s\tverify_s\tretries\tnotes\n' \
  > .claude/decomp_stats.tsv
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$SYM" "$STATUS" \
  "$TOTAL" "$VERIFY" "$RETRIES" "$NOTES" \
  >> .claude/decomp_stats.tsv
```

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
- Debugging a verify failure for more than 5 minutes. Revert.
- Writing long commit messages explaining the conversion. The diff is the doc.
- Quoting verify output verbatim in your reply. State the result and move.
- Calling subagents. The work is sequential and cheap; no parallelism win.
- Skipping the stats row. Every iteration writes one — pass, revert, or bail. The data is the only way to spot drift.

## Stop conditions

Bail to the user (don't compact) when:
- 3 consecutive candidates revert. Suggests a real issue (build broken, infra regression).
- `make verify` itself errors (not just fails — actually errors, e.g. build error unrelated to your change).
- You hit a gotcha not covered in memory or this skill that's worth a human decision.
