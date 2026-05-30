# 07f — bindgen + MGBA_PREFIX override

## What it is
`bn6f-validate/build.rs` generates Rust FFI via bindgen from the vendored
headers, allowlisting only the symbols used (`mCore*`, `VFile*`,
`FFmpegEncoder*`, `mLog*`). Links the vendored `.so`, sets rpath.
`MGBA_PREFIX=/usr` overrides to a system install.

## Pro
- Narrow allowlist keeps the generated binding surface small and the
  build fast. The `MGBA_PREFIX` escape hatch is clean — lets a dev use a
  system or self-built mgba without editing build.rs.

## Con / open
- bindgen + libclang is a heavyweight build-time dep; binding layout is
  tied to the exact header set vendored alongside the `.so` (they must
  stay in sync on rebuild — ties to 07e).

## Rating
**GOOD (explained).** (2026-05-30) bindgen auto-generates the Rust↔C glue
declarations from libmgba's C headers so they don't have to be
hand-written; the allowlist limits generation to the few symbols used
(`mCore*`/`VFile*`/...). `MGBA_PREFIX` repoints it at a different mgba
install (e.g. `/usr`). Only real cost: needs libclang at build time, and
the generated bindings must match the vendored headers (ties to 07e). No
change needed.

---
_Last updated: 2026-05-30 12:41:37 -0400_
