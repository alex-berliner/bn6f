# 07e — vendored libmgba .so in git

## What it is
A prebuilt `libmgba.so.0.11.0` (2.6 MB) committed to the repo with the
soname symlink chain. Pinned at 0.11 for savestate-version coverage
(reads 0.7–0.11; Debian/Ubuntu ship 0.10). Rebuild instructions in the
libmgba README.

## Pro
- Validator builds with no system mgba dependency; exact reproducibility.

## Con / open
- 2.6 MB opaque binary blob in git history; grows the repo, and a binary
  nobody can diff. Per [[feedback_libmgba_mod_permission]] the user has
  authorized patching/rebuilding the vendored libmgba, so this is a
  living artifact, not frozen — which makes "binary in git" more of a
  maintenance question (rebuild discipline) than a one-time cost.

## Rating
**OK — consider making it a build artifact, if cheap.** (2026-05-30)
Acceptable as-is, but prefer building the `.so` as a build step rather
than committing the 2.6 MB blob — **only if it's not a lot of work.**
- [ ] Evaluate effort: a `make`/cargo step that builds libmgba 0.11 from
      a pinned source (commit/tag) into `build/` or `tools/libmgba/`.
- [ ] If low-effort, do it (drop the committed blob); if it pulls in a
      heavy cmake/source-fetch dependency, leave the vendored `.so`.
- Ties to [[feedback_libmgba_mod_permission]] (rebuild already authorized).

---
_Last updated: 2026-05-30 12:41:33 -0400_
