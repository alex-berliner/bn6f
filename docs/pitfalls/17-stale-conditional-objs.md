# 17 — stale conditional-compiled C objects after manifest change

**Class:** test infrastructure / make dependencies
**Severity:** wrong binary (stale C objects linked in)
**Status:** mitigated by `clean-conditional-objs` between builds

## Symptom

You change `tools/decomp_manifest.txt` (add or remove a patch), run
`make decompile`, and the resulting ROM has objects from the *previous*
manifest. New patches don't take effect; removed patches still run.

## Why

The decomp build links C objects from `build/c/*.o`. Each `.o` is
compiled with `-DDECOMP_<sym>=1` flags derived from the manifest.

If the manifest changes but the `.o` file's mtime is already newer
than its source (because it was compiled under the previous manifest),
make sees no reason to rebuild it. The stale `.o` carries the old
`-D` flags baked in (or, more subtly, was compiled with different
header `.ifndef` resolution paths).

The conditional-compilation logic uses `#ifdef DECOMP_<sym>` to
toggle code paths. Once a `.o` is built with a given `DECOMP_<sym>`
state, it can only be changed by recompiling — but the source `.c`
file's mtime didn't change, so make won't.

Combined with the flags-file stale-mtime issue (pitfall 07), this can
silently produce a ROM that doesn't match any well-defined manifest
state.

## How to detect

Add or remove a patch, build, then:

```sh
md5sum build/bn6f.gba
```

If the md5 didn't change between the two manifest states, you're
hitting this.

Or check the build output for what got compiled:

```sh
make decompile 2>&1 | grep "agbcc.*\.c"
```

If the file you expected isn't there, make doesn't think it needs
recompiling.

## Fix

`make clean-conditional-objs` removes all conditional-compiled
objects + the flags file:

```sh
make clean-conditional-objs
make decompile
```

This forces full recompilation. All per-patch scripts call
`clean-conditional-objs` before each `make decompile`:

```bash
make clean-conditional-objs >/dev/null 2>&1
make decompile -s >/dev/null 2>&1
```

The cost is small (~30s for full conditional rebuild) and prevents
silent wrong-build bugs.

## Related

- `Makefile::clean-conditional-objs`
- `docs/pitfalls/07-stale-flags-file-mtime.md`
- The per-patch scripts that always call it
