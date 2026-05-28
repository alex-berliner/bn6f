# 08 — manifest drift from failed trap restore

**Class:** test infrastructure / script reliability
**Severity:** corrupt subsequent builds
**Status:** mitigated by `git checkout` between batches + sanity checks

## Symptom

`tools/decomp_manifest.txt` accumulates extra entries between runs of
the per-patch scripts. What should be 534 entries becomes 542, 550, or
worse. Subsequent builds use the wrong patch set.

## Why

The per-patch scripts back up the live manifest, modify it
(swapping in just one or a few patches per iteration), and restore
the backup at exit via a bash `trap`:

```bash
BACKUP=/tmp/m_backup_$$.txt
cp tools/decomp_manifest.txt "$BACKUP"
trap 'cp "$BACKUP" tools/decomp_manifest.txt && touch tools/decomp_manifest.txt' EXIT INT TERM
```

The trap fires on `EXIT`, `INT`, and `TERM` — covering normal exit,
Ctrl-C, and kill. But the trap **does not fire on**:

- `kill -9` (SIGKILL)
- segmentation fault in the script's children (sometimes)
- the script being interrupted between manifest-modify and trap-setup
- the harness ending the bash session before the trap runs

When trap doesn't fire, the manifest stays in whatever modified state
the script last left it — typically with one extra patch entry
appended.

Run again. Same thing happens, adds another entry. Run N times,
accumulate N extra entries.

## How to detect

```sh
git diff tools/decomp_manifest.txt
```

If you see `+entry_name` lines you didn't intentionally add, you've
drifted.

The autonomous loop checks for this implicitly: every batch starts
with `git checkout tools/decomp_manifest.txt` to reset to the
canonical version. If drift exists, the checkout silently fixes it.

## Fix

### 1. git checkout between runs

```sh
git checkout tools/decomp_manifest.txt
touch tools/decomp_manifest.txt
```

This is the cheap defensive reset. The autonomous loop does this
between every batch.

### 2. Sanity check before backing up

The scripts check:

```bash
LIVE_ENTRIES=$(grep -cv "^#\|^$" tools/decomp_manifest.txt 2>/dev/null || echo 0)
if [ "$LIVE_ENTRIES" -lt 100 ]; then
    echo "ERROR: manifest only has $LIVE_ENTRIES entries — refusing"
    exit 2
fi
```

If the manifest is a partial stub (from a prior interrupted run that
left only a few entries), refuse to back it up — that would lose the
real manifest entries.

### 3. PID-stamped temp file names

`$BACKUP=/tmp/m_backup_$$.txt` — using `$$` (script PID) prevents two
concurrent script runs from clobbering each other's backups.

## When this bit us

Multiple times during the autonomous loop. The drift was first noticed
when a manifest sanity check reported "542 entries" instead of 534.
Adding `git checkout` between batches eliminated the recurrence.

## Related

- `tools/per_patch_last_frame.sh` (trap + sanity check)
- `tools/per_patch_videos.sh` (same)
- `tools/per_patch_combined_test.sh` (same)
