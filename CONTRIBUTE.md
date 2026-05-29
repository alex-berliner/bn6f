# Contributing

This repo supports two contribution tracks. Pick the one matching what
you're working on.

## C decompilation

Converting an ASM function to a validated C reimplementation. End-to-end
guide:

→ [docs/decomp-workflow.md](docs/decomp-workflow.md)

Open blockers + work queue:

→ [issues/decomp-blockers.md](issues/decomp-blockers.md)

How conversions are validated (per-frame pixel-hash vs orig):

→ [tools/bn6f-validate/README.md](tools/bn6f-validate/README.md)

## Pure disassembly / labelling

Adding labels, symbol names, struct definitions, or pseudocode to the
ASM side. The build must still produce a ROM matching the retail
sha1 (`make all` succeeds).

- Document functions, files, or data by adding comments or changing
  symbol names in the asm and header files. Refactor so all files stay
  in sync.
- Document or identify structs, enums, etc. — see `include/structs/`,
  `constants/`, and `structs/`.
- Every asm file has a sibling header in `inc/` that defines its
  public symbols and external references.
- Label EWRAM and IWRAM symbols in `ewram.s` and `iwram.s`.
- `docs/decomps/` has some pseudocode notes; treat as hints, not
  ground truth.

### Validity Checking

All changes must produce an identical ROM:

```
make all
```

The sha1 check at the end of `make all` will fail if your edits drift
from the retail bytes.

## Both tracks

Use `git grep` liberally — the codebase has consistent symbol naming
once you know what you're looking for. Cross-reference against:

- `docs/documenting/` — function/data documentation conventions
- `issues/concerns/` — calling convention, ABI, IRQ, etc. reference docs
- [docs/build.md](docs/build.md) — toolchain layout, what to do when the build breaks

---
_Last updated: 2026-05-29 12:49:47 -0400_
