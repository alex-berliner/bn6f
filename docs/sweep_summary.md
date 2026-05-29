# Autonomous validation sweep — final summary

Sweep of all 528 patchable functions (every `.ifndef DECOMP_<sym>` in
`asm/*.s`). Validated individually via `per_patch_last_frame.sh` and
in composition via `per_patch_combined_test.sh`. Wall time: ~5 hours
of autonomous loop iterations.

## Headline result

- **527 of 528 patches PASS** the last-frame PPM check individually
  (99.8%)
- **527 of 527 PASS** when enabled simultaneously (full composition
  verified by combined-test 1-528)
- **1 hard FAIL**: `cutsceneCamera_focusCameraOnPlayerMaybe_8036faa`
  (issue [#12](../issues/decomp-blockers.md), investigated 2 cycles,
  skipped for later)

## Honest coverage breakdown

Last-frame PPM PASS doesn't mean the patched function was actually
exercised by the bk2. `tools/build_bk2_coverage.sh` produced
per-bk2 hit lists; `tools/patch_bk2_xref.sh` cross-references against
patches.

| Validation status | Count | % | Meaning |
|---|---|---|---|
| Exercised + PASS | 336 | 63.6% | Real validation — function actually called during a bk2 |
| Unexercised + PASS | 191 | 36.2% | Build-PASS only — ROM links cleanly, function never invoked |
| Hard FAIL | 1 | 0.2% | issue #12, deferred |

Of 336 truly-verified patches:

| Coverage class | Count |
|---|---|
| Exercised only by coldboot | 0 |
| Exercised only by intro | 15 |
| Exercised only by tutorial | 81 |
| Exercised by intro + tutorial | varies |
| Exercised by all 3 bk2s | 77 |

Tutorial.bk2 is the most exhaustive: it exercises 258 of the 336
exercised patches (76%).

## What the 192 unexercised patches need

They fall into recognizable categories — code paths the 3 current
bk2s don't reach:

- **Mail / messaging**: `addMail_*`, `chatbox_*` variants for
  unreached dialogs
- **Save/load + encryption**: `encryption_*`, `encryption_save_*` —
  no save triggered in fixtures
- **Shop / item**: `getOffsetToQuantityOfChip*`, related navi/chip
  shop helpers
- **NaviStats variants**: most `GetNaviStats*` / `SetNaviStats*` —
  stats lookups in unexplored paths
- **Scenario effects**: `getField0x18OfScenarioEffectState*`,
  scenario-specific cutscene helpers
- **BBS / multiplayer**: most `sub_813Dxxx`, `sub_8140xxx`,
  `sub_8146xxx` — BBS/multiplayer code never invoked
- **Battle variants we don't reach**: AI data flag setters, panel
  alliance timers, etc.

To validate these, we need additional bk2 fixtures covering:

1. A save game (exercises encryption + save subsystem)
2. A shop visit (chip/subchip/item shops)
3. A NaviCust edit session
4. A folder edit (chip swap, navi change)
5. A multiplayer / Network Battle setup
6. Mail/email interactions
7. Boss battle / different-from-tutorial battle scenarios
8. Cutscene-heavy chapter playthrough

Each new bk2 adds ~6 minutes per per-patch sweep batch (existing fixtures
already amortize the cost). Estimated 4-6 new fixtures would push
exercised coverage from 63% to >90%.

## What the sweep validates (concretely)

For the 336 exercised patches:

- Each, enabled individually, produces a decomp ROM whose last-frame
  pixel output matches orig byte-for-byte across coldboot, intro, and
  intro_to_end_tutorial
- The full 527-patch composition (combined-test) produces the same
  byte-equal last frame as orig on all 3 bk2s
- The agbcc / trampoline / interworking quirks documented in
  `docs/pitfalls/*` are either avoided or worked around in every
  exercised C port

For the 192 unexercised patches:

- The decomp build with each one enabled links cleanly
- The trampoline + extension-space body bytes don't break the rest
  of the ROM's behavior on existing fixtures
- The C body's correctness when actually invoked is **unverified**

## Notable discoveries during the sweep

These were all discovered and documented during the autonomous loop;
see `docs/pitfalls/` for detailed write-ups:

1. **agbcc union-padding bug** (pitfall #01) — affected
   `battle_setFlags_c` / `battle_clearFlags_c` and would affect any
   struct with `union` declarations. Workaround: raw byte offsets.
2. **Trampoline cycle drift** (pitfall #02) — proven empirically with
   the ByteFill experiment. Naked-asm passthrough still produces
   drift-class lockstep divergence. Resolution: drift classifier +
   end-state correctness.
3. **gcc r10 save/restore** (pitfall #04) — using `register asm("r10")`
   makes gcc emit 8 extra cycles per `bl` call. Switching to absolute
   `eToolkit` reference removes the overhead.
4. **libx264 non-determinism** (pitfall #10) — identical pixel input
   produces different mp4 bytes. `cmp -s` on mp4s is unreliable for
   correctness.
5. **recvideo vs framebuf mismatch** (pitfall #12) — recvideo's
   encoded frame 100 doesn't match framebuf's frame 100. Visual-only;
   correctness uses framebuf.
6. **Most patches aren't exercised** (this report) — the coverage
   gap is the most consequential finding for next steps.

## Outputs delivered

- **527 per-patch ROMs verified** individually
- **528 per-patch video sets** rendered (`build/videos/0000NNN_<name>/`)
- **3 bk2 hit-list metadata files** (`tests/fixtures/demos/bk2/*.hits.txt`)
- **Patch × bk2 cross-reference** (`build/patch_bk2_xref.csv`,
  `build/patch_bk2_xref.md`)
- **20 pitfall documents** under `docs/pitfalls/`
- **Issues #11 (agbcc union) and #12 (cutsceneCamera fail)** logged
  for future work

## What's next

1. **Investigate issue #12** with deeper tools (lockstep at frame
   delta, slack profiler around the call site, careful r10 trace).
   This is the only individually-failing patch.
2. **Add bk2 fixtures** for the unreached code paths listed above.
   Each new fixture is a one-time cost that converts ~30 unexercised
   patches into truly-verified ones.
3. **Parallelized lockstep sweep** on the 336 exercised patches as
   a deeper second-stage check (~5-7 hours wall time with the
   existing parallelism pattern from `per_patch_videos.sh`). Catches
   any transient mid-bk2 bugs that converge to identical end-state.
4. **Verification model documentation**: the project's verification
   stack (per-call snapshot + last-frame PPM + combined-test +
   coverage cross-ref + drift classifier) now forms a coherent
   layered model. Worth a unified write-up in `docs/verification.md`.

The sweep crossed a meaningful threshold: with 527 individually-PASSed
patches, the decomp build is on track. The honest coverage gap (192
unexercised) is the next bottleneck and is addressable mechanically.
