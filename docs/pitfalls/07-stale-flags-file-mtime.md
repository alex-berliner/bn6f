# 07 — stale flags-file mtime

**Class:** test infrastructure / make dependency tracking
**Severity:** wrong build (uses stale conditional compilation flags)
**Status:** mitigated by `clean-conditional-objs` + cp/touch pattern

## Symptom

You change `tools/decomp_manifest.txt`, run `make decompile`, and
something's off: the build uses the old set of `-DDECOMP_*` flags,
producing a ROM that doesn't reflect the new manifest. May appear
as patches "not taking effect" or stale C objects being linked.

## Why

The decomp build flow:

1. `tools/decomp_manifest.txt` lists which functions are decompiled
2. `build/decomp_flags.txt` is derived from the manifest — contains
   `-DDECOMP_<sym>=1` lines, one per enabled patch
3. `make decompile` rebuilds objects that depend on those flags

`build/decomp_flags.txt` is rebuilt only when `tools/decomp_manifest.txt`
is *newer*. Make uses mtime to decide.

Here's the bug class: when restoring a backed-up manifest, the
intuitive command is:

```sh
mv build/decomp_manifest.bak tools/decomp_manifest.txt
```

`mv` **preserves the source file's mtime**. The backup was created
earlier (when the per-patch script started), so its mtime is older
than the current `build/decomp_flags.txt` (which was written for
whatever the LAST manifest was).

Result: manifest claims version A, but make sees flags-file as newer,
skips regen, uses stale flags from version B.

## How to detect

If you're seeing patches not take effect:

```sh
ls -la tools/decomp_manifest.txt build/decomp_flags.txt
```

If `decomp_flags.txt` is *newer* than the manifest, you're hitting
this.

## Fix

Two complementary fixes:

### 1. cp + touch pattern (never mv)

Instead of `mv backup current`, use:

```sh
cp build/decomp_manifest.bak tools/decomp_manifest.txt
touch tools/decomp_manifest.txt
```

`touch` forces the mtime to "now," so make sees it as newer than
flags-file and regenerates.

### 2. clean-conditional-objs

The makefile target `make clean-conditional-objs` removes
`build/decomp_flags.txt` and the conditional-compiled C objects.
Running it forces full regen on the next `make decompile`:

```sh
make clean-conditional-objs
make decompile
```

The per-patch scripts use both: they cp+touch the restored manifest
*and* call `make clean-conditional-objs` to be extra safe.

## Where this bit us

The `make videos` target had this bug — the trap restored the manifest
with `mv`, leaving the next `make decompile` using stale flags.
Symptom: nopatch ROM didn't actually match orig because the manifest
"restore" was a no-op from make's perspective.

Fix landed in commit `65883aa8` (verify-strict era).

## Related

- `Makefile` (look for `clean-conditional-objs` target)
- Memory implicit in per_patch_videos.sh / per_patch_last_frame.sh
  trap handlers
