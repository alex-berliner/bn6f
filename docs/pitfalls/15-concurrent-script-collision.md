# 15 — concurrent script runs collide on shared state

**Class:** test infrastructure / scripting
**Severity:** corrupted ROMs, Bus errors, manifest mangling
**Status:** mitigated by PID-stamped temp files + run-one-at-a-time discipline

## Symptom

Strange failures in the per-patch scripts:

- `Bus error (core dumped)` from `bn6f-track recvideo` on tutorial
- `cp: cannot stat '/tmp/m_header_NNNNN.txt'` errors
- Random patches showing as identical-md5 outputs when they shouldn't
- Verdicts ("PASS"/"FAIL") interleaved with stale output from a
  previous run

## Why

The per-patch scripts modify `tools/decomp_manifest.txt` (the project's
sole source of truth for which functions are decompiled). If two
script instances run concurrently:

- Both try to back up the manifest at the same time
- Both modify it for their per-patch loop
- Both call `make decompile` — the resulting ROM is whichever
  manifest state happened to be on disk when `make` ran
- Both want to restore the original on exit — last-writer wins

The result is a build that doesn't reflect either script's intended
patch set, and downstream binaries (decomp ROMs, mp4s) capture
nonsense.

Worst case I hit: I killed a per_patch_videos.sh run, edited the
script for the prefix-naming change, restarted it. But the kill
didn't fully clean up — a child `recvideo` process was still running
against a now-corrupt ROM, producing the bus errors.

## How to detect

```sh
ps aux | grep -E "per_patch|bn6f-track" | grep -v grep
```

If you see more than the one process you expected, you have collision.
Also: any "cp: cannot stat" or sha mismatches suggest another script
deleted your temp files mid-run.

## Fix

Three layers of defense:

### 1. PID-stamped temp files

Every per-patch script uses `$$` (the script's PID) in temp file
names:

```bash
BACKUP=/tmp/m_backup_$$.txt
HEADER=/tmp/m_header_$$.txt
JOBS=/tmp/per_patch_jobs_$$.txt
```

Two concurrent runs use different temp files; neither clobbers the
other's state. (They still collide on the manifest, see below.)

### 2. Sanity check before backing up

```bash
LIVE_ENTRIES=$(grep -cv "^#\|^$" tools/decomp_manifest.txt 2>/dev/null || echo 0)
if [ "$LIVE_ENTRIES" -lt 100 ]; then
    echo "ERROR: manifest only has $LIVE_ENTRIES entries — refusing"
    exit 2
fi
```

If a previous run left the manifest in a partial state, refuse to
back it up — would lose the real manifest.

### 3. Run one manifest-touching script at a time

The autonomous loop is sequential by design — only one
manifest-modifying script runs at a time. Background tasks
notify on completion; the next script starts only after.

If you're running scripts manually, just don't parallel-launch them.

## When this bit us

Repeatedly during the autonomous loop's early hours. The video gen
script and last-frame check would race when I tried to kick them off
in parallel for speed. After establishing the sequential discipline +
PID temp files + manifest sanity checks, no more bus errors or
collision bugs.

The combined-test script and the per-patch sweep scripts can't run
in parallel either — same root cause.

## Could we parallelize?

Yes — by separating "build" from "run":

1. Pre-build N decomp ROMs sequentially (touching manifest)
2. Save each ROM to a unique path
3. Run the per-patch evaluations in parallel, against the saved ROMs
   (no manifest touching)

`tools/per_patch_videos.sh` already does this for the render phase
(15 ROMs built sequentially, 45 videos rendered in parallel via
`xargs -P`). The same pattern could be applied to last-frame check.

## Related

- `tools/per_patch_last_frame.sh`
- `tools/per_patch_videos.sh` (parallel render phase)
- `tools/per_patch_combined_test.sh`
