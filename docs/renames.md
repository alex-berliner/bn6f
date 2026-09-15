# Symbol renames applied from the bn reimplementation's findings

The `bn` reimplementation project (a Rust port of this game's battle engine, built
against this disassembly) established what many address-only symbols here actually
do, and recorded it in three places:

1. `// bn ...` comment notes already committed into this repo's own `asm/*.s`,
   `data/*.s` and `include/**` files (branch `bn-notes`);
2. the port's Rust sources, whose comments cite this disassembly's routines by
   their address names (`/home/box/Code/bn/src/*.rs`);
3. the port's docs and ticket results (`/home/box/Code/bn/docs/**`,
   `TODO.md`, `TODO_ARCHIVE.md`).

This file maps every symbol renamed on that evidence, so a citation of an OLD name
anywhere outside this repo still resolves. The address is kept as the suffix of
every new name, so the address itself always resolves too.

Renames were applied only where a note, a cited Rust comment, or a doc states the
role outright. Symbols whose role is only guessed at, hedged, or inferred from a
coverage ranking were deliberately left alone.

Format: `old -> new` — evidence.

## Mettaur AI (`asm/asm31.s`)

Evidence for the whole block: the `bn/reference wt/zero-layers` and
`wt/mettaur-ai` notes already in `asm/asm31.s` (at the head of
`MettaurDecide_8109FD6`), which walk the entire machine state by state and say
it was measured live against the real ROM; corroborated by
`/home/box/Code/bn/src/ai.rs:19-36`, `/home/box/Code/bn/src/objects.rs:255-479`,
`/home/box/Code/bn/src/actor.rs:55,176-177`, `/home/box/Code/bn/src/battle.rs:48`
and `/home/box/Code/bn/docs/coverage/plan-interpreters.md:268-271,375-388`.

| old | new | evidence |
|---|---|---|
| `sub_8109FD6` | `MettaurDecide_8109FD6` | "0x08 is THIS function, sub_8109FD6, the decision loop" — asm31.s wt/mettaur-ai note; src/ai.rs:19 |
| `off_8109FF0` | `MettaurDecideStates_8109FF0` | "sub_8109FD6's OWN 5 states, off_8109FF0" — same note; src/ai.rs:36 |
| `sub_810A004` | `MettaurDecideCheckStatusAndRow_810A004` | "[0] … the Param4==0 spawn-pause gate, then two status-flag gates … then a row compare" — same note; src/objects.rs:289 |
| `sub_810A080` | `MettaurDecideArmHopToRow_810A080` | "[1] … arms a hop toward the target row … the SAME direction every time" — same note; src/objects.rs:292 |
| `sub_810A0BA` | `MettaurDecideConfused_810A0BA` | "[2] … UNREACHED without BLIND/CONFUSED" — same note; src/objects.rs:296 |
| `off_810A0CC` | `MettaurDecideConfusedSteps_810A0CC` | the 2-entry sub-state table `sub_810A0BA` dispatches on (`oAIState_Unk_02`) |
| `sub_810A0D4` | `MettaurConfusedArmRandomHop_810A0D4` | "sub_810A0D4 arms a RANDOM-direction hop (sub_810A254)" — same note; src/objects.rs:302 |
| `sub_810A0EE` | `MettaurConfusedRollAttack_810A0EE` | "sub_810A0EE then ROLLS: GetPositiveSignedRNG()&0xf, <2 (2/16) -> state [3]" — same note; src/objects.rs:450 |
| `sub_810A126` | `MettaurDecideChooseAttack_810A126` | "[3] sub_810A126 … object_setAttack0(0xb) -> CurAction 0xB" — same note; src/objects.rs:299 |
| `sub_810A204` | `MettaurDecideArmGuard_810A204` | "[4] (sub_810A204 …, a flat 0x28-frame wait before forcing CurAction 0xC, GUARD)" — same note; src/objects.rs:479 |
| `sub_810A21A` | `MettaurHopTowardTargetRow_810A21A` | "arms a hop toward the target row (sub_810A21A, one panel, the SAME direction every time — no RNG)" — same note; src/objects.rs:268 |
| `sub_810A254` | `MettaurHopRandomRow_810A254` | "sub_810A254 … GetPositiveSignedRNG()&1 picks which neighbour row to try first" — same note; src/objects.rs:414 |
| `dword_810A2A4` | `MettaurRandomHopRowOrders_810A2A4` | "dword_810A2A4's own byte sequence 01 FF 01 00 gives the two try-orders" — same note |
| `sub_8109CBC` | `MettaurWaitThenExitAttack_8109CBC` | "0x09 is sub_8109CBC, a plain 'count oAIAttackVars_Unk_10 down to 0, then object_exitAttackState' waiter" — same note; src/objects.rs:318 |
| `sub_8109CE6` | `MettaurHopExec_8109CE6` | "0x0A is the HOP executor (sub_8109CE6/off_8109CF8)" — same note; src/ai.rs:22 |
| `off_8109CF8` | `MettaurHopSteps_8109CF8` | same note: "four raw-byte-indexed sub-steps" |
| `sub_8109D08` | `MettaurHopReservePanel_8109D08` | "reserve the target panel and spawn a dust effect … for 3 frames" — same note; src/objects.rs:256 |
| `sub_8109D70` | `MettaurHopCommitPanel_8109D70` | "commit PanelX/PanelY for 3 more" — same note |
| `sub_8109D98` | `MettaurHopArmCooldown_8109D98` | "clear the moving flag and arm byte_8109F46[Version] frames of cooldown" — same note |
| `sub_8109DBA` | `MettaurHopFinish_8109DBA` | "then set Unk_1a=1 and object_exitAttackState" — same note; src/objects.rs:255 |
| `sub_8109DD2` | `MettaurAttackExec_8109DD2` | "0x0B is the ATTACK executor (sub_8109DD2/off_8109DE4)" — same note; src/ai.rs:27 |
| `off_8109DE4` | `MettaurAttackSteps_8109DE4` | same note |
| `sub_8109DEC` | `MettaurAttackSwing_8109DEC` | "sub_8109DEC holds anim 1 for a 0x40-frame countdown … spawns the shockwave … when it reads 0x1b" — same note; src/actor.rs:176 |
| `sub_8109E4A` | `MettaurAttackRecover_8109E4A` | "THEN sub_8109E4A holds a SEPARATE 0x28 (40) frame recovery" — same note; src/actor.rs:177 |
| `sub_8109E7A` | `MettaurGuardExec_8109E7A` | "0x0C is the GUARD executor (sub_8109E7A/off_8109E8C)" — same note; src/ai.rs:32 |
| `off_8109E8C` | `MettaurGuardSteps_8109E8C` | same note |
| `byte_8109F28` | `MettaurWaveDamageByVersion_8109F28` | "byte_8109F28[Version] (a packed u32, low 16 bits = {10,30,50,70,50,100} for Version 0..5)" — same note; src/battle.rs:48 |
| `byte_8109F40` | `MettaurWaveFamilyByVersion_8109F40` | "reads byte_8109F40[Version] into AIAttackVars_Unk_0c (a 'family' tag)" — same note; src/objects.rs:471 |
| `byte_8109F46` | `MettaurHopCooldownByVersion_8109F46` | "byte_8109F46 = { 0x1e, 0x18, 0x12, 0xc, 0x12, 0xc }, indexed by oAIData_Version_16" — same note; src/actor.rs:55 |

New named constants (`asm/asm31.s`, above `MettaurDecideStates_8109FF0`):
`METTAUR_DECIDE_*` (the five decision-state jump offsets), `METTAUR_ACTION_*`
(the CurAction values this AI sets) and the measured frame counts
`METTAUR_POST_SPAWN_PAUSE_FRAMES`, `METTAUR_CONFUSED_IDLE_FRAMES`,
`METTAUR_CONFUSED_ROLL_MASK`, `METTAUR_CONFUSED_ROLL_ATTACK_MAX`,
`METTAUR_ATTACK_POSE_FRAMES`, `METTAUR_ATTACK_COUNTER_FRAME`,
`METTAUR_ATTACK_SHOCKWAVE_FRAME`, `METTAUR_ATTACK_RECOVER_FRAMES`,
`METTAUR_GUARD_WAIT_FRAMES`, `METTAUR_HOP_RESERVE_FRAMES`,
`METTAUR_HOP_COMMIT_FRAMES` — all from the same note's measurements.

## Battle sequencer and battle FSM (`asm/asm00_1.s`, `ewram.s`)

The state word and its two tables were read in this repo (the "THE GENERIC
BANNER SEQUENCER's state table" note above `BannerSequencerStates_8008038`) and
measured live by the bn project. `eBattleSequencerState_203CA70`'s low byte and
`eBattleState.Index_01` are both PRE-MULTIPLIED byte offsets into their tables,
so a handler's name carries the state VALUE, not the row index — the convention
the port uses too (`SEQ_20`, `SEQ_24`, `SEQ_00`, `SEQ_04`, `SEQ_08`).

Two rows are confirmed independently of the table, which is what makes the
whole index->state scheme safe to name from:
`bannerSeqState1C_80083E4` is the handler running while the state reads 0x1C
(`docs/coverage/battlestart_gunner.md:57-59`, "on Start it writes 0x1C -> 8 at
frame 11, PC 0x080083F8, inside sub_80083E4"), and `battleFsmState08_8009338`
is stated outright as "State 0x08's handler" (`battlestart_gunner.md:74-77`).

| old | new | evidence |
|---|---|---|
| `dword_203CA70` | `eBattleSequencerState_203CA70` | "the battle/banner sequencer state word (ewram.s:3040); its low byte is the state" — src/battle.rs:1719; TODO_ARCHIVE.md:3031 (T9c) |
| `off_8008038` | `BannerSequencerStates_8008038` | "the sequencer's state jump table, entries 0..9 = states 0x00..0x24" — src/battle.rs:1164; this file's own note |
| `sub_800801C` | `stepBannerSequencer_800801C` | "The banner task sub_800801C … dispatch table off_8008038 indexed by the byte dword_203CA70 holds" — docs/coverage/battlestart_gunner.md:60-62 |
| `sub_800840C` | `bannerSeqState00Settle_800840C` | "entry 0 = state 0x00, the post-window settle" — src/objects.rs:72/74; TODO_ARCHIVE.md:3071 (T7c) |
| `sub_8008064` | `bannerSeqState04BannerWait_8008064` | "entry 1 = state 0x04, the banner wait … writes 0x08 only when sub_801E754's banner-idle check returns 0" — src/objects.rs:72-73; TODO_ARCHIVE.md:3016 (T7d); the `// bn T7u` note in this file |
| `sub_80080D2` | `bannerSeqState08Fight_80080D2` | "entry 2 = state 0x08, the fight itself; writes 0x20 after PauseBattle" — src/battle.rs:1165,2548; TODO_ARCHIVE.md:1433 (F5) |
| `sub_80081A4` | `bannerSeqState0CWinCount_80081A4` | "entry 3 = state 0x0C, the WIN/RESULT countdown … tears the HUD down via sub_801BED6(0xE4C53)" — src/battle.rs:4549; TODO_ARCHIVE.md:2187 (F27b) |
| `sub_800825A` | `bannerSeqState10LoseCount_800825A` | "0x0C/0x10 count the end (sub_80081A4 win, sub_800825A lose)" — src/battle.rs:1166 |
| `sub_80082DC` | `bannerSeqState14MessageCount_80082DC` | "0x14 is sub_80082DC's message count" — src/battle.rs:1167 |
| `sub_800834A` | `bannerSeqState18_800834A` | table position only (its role is disputed, see the note below) |
| `sub_80083E4` | `bannerSeqState1C_80083E4` | "on Start it writes 0x1C -> 8 at frame 11, PC 0x080083F8, inside sub_80083E4" — docs/coverage/battlestart_gunner.md:57-59 |
| `sub_8008452` | `bannerSeqState20WindowOpening_8008452` | "entry 8 = state 0x20, the window opening"; "leaves 0x20 on sub_802D6C4's return" — src/objects.rs:71/76; TODO_ARCHIVE.md:3071 (T7c) |
| `sub_8008492` | `bannerSeqState24WindowOpen_8008492` | "entry 9 = state 0x24, the window open … never writes the state word" — src/objects.rs:71/77; TODO_ARCHIVE.md:2999 (T7d) |
| `sub_800A152` | `getBattleOutcome_800A152` | "all-dead (sub_800A152==1 …)"; "6-9 are a sibling branch entered only when sub_800A152() returns 7" — TODO_ARCHIVE.md:1434 (F5), :774 (C2) |
| `sub_800A21C` | `isCustGaugeFullAndBattleLive_800A21C` | "answers 'is the custom gauge 0x4000, with no time stop and the battle not over'" — src/battle.rs:2738; docs/coverage/battle_full.md:1559 |
| `sub_8009158` | `dispatchBattleFsm_8009158` | "the battle-FSM dispatcher sub_8009158 … table off_80091BC" — docs/coverage/battlestart_gunner.md:63-65 |
| `off_80091BC` | `BattleFsmStates_80091BC` | same |
| `sub_80091F0` `sub_80092A0` `sub_8009338` `sub_800938A` `sub_800945C` `sub_80094DA` `sub_800951E` `sub_8009552` `sub_8009594` `sub_80095C8` | `battleFsmState00_…` … `battleFsmState24_…` | the table plus the two independently-confirmed rows above; 0x0C is "the Index_01 = 0x0C handler; the only caller of sub_800801C" (battlestart_gunner.md:62-64) |

## Battle HUD elements (`asm/asm00_2.s`)

Evidence throughout: `/home/box/Code/bn/src/fixture.rs:84-86`,
`src/hudtiles.rs:78-87`, `src/battle.rs:2374,4549-4595`, `src/emotion.rs:17-18`,
and the ticket results at `TODO_ARCHIVE.md:2187-2294` (F27b, F33), all measured
with `--watch-write` on the mask.

| old | new | evidence |
|---|---|---|
| `sub_801BECC` | `setBattleHudElements_801BECC` | "banner re-set bit 15 via sub_801BECC" — TODO_ARCHIVE.md:2567 (F33d); src/battle.rs:4556 |
| `sub_801BED6` | `clearBattleHudElements_801BED6` | "sub_80081A4 -> sub_801BED6(0xE4C53)" clears elements 0/1/4/10/14 — TODO_ARCHIVE.md:2187 (F27b) |
| `sub_801BEE0` | `updateBattleHudElements_801BEE0` | "update sub_801BEE0 asm00_2.s:25540-25563 / off_801BF04" — TODO_ARCHIVE.md:2294 (F33) |
| `off_801BF04` | `BattleHudUpdateHandlers_801BF04` | same |
| `sub_801BF64` | `drawBattleHudElements_801BF64` | "draw sub_801BF64 :25564-25599 / off_801BF88" — same |
| `off_801BF88` | `BattleHudDrawHandlers_801BF88` | same; src/hudtiles.rs:79 "slot 4 is the custom-gauge draw" |
| `sub_801BFF8` / `sub_801C002` | `updateQueuedChipIcons_801BFF8` / `updateQueuedChipIcon_801C002` | "queued-chip ICON is battle-HUD element 1 (updater sub_801BFF8 -> sub_801C002(0))" — src/battle.rs:4591 |
| `sub_801C078` / `sub_801C082` | `drawQueuedChipIcons_801C078` / `drawQueuedChipIcon_801C082` | src/battle.rs:4592 |
| `dword_20352E0` | `eQueuedChipIconSlots_20352E0` | "the six slots at dword_20352E0" — src/battle.rs:4593; TODO_ARCHIVE.md:1613 (F11) |
| `sub_801C470` | `updateCustGauge_801C470` | "the CUSTOM gauge is battle-HUD element 4 … updater sub_801C470" — src/battle.rs:2374 |
| `sub_801C4E4` | `drawCustGauge_801C4E4` | "draws bar 0x9232+((t div 7)&3) … and marker byte_801C6C0[t&8] off one counter t at 0x02035280, no phase" — TODO_ARCHIVE.md:1509 (F6) |
| `byte_801C6C0` | `CustGaugeMarkerTiles_801C6C0` | same |
| `sub_801C6EE` | `drawQueuedChipName_801C6EE` | "element 6 chip name + damage (sub_801C6EE :26619)" — TODO_ARCHIVE.md:2294 (F33) |
| `sub_801CADC` / `sub_801CDEC` | `updateEmotionWindow_801CADC` / `drawEmotionWindow_801CDEC` | "the emotion window is battle-HUD element 14 … draw sub_801CDEC :27554-27583" — TODO_ARCHIVE.md:2187 (F27b) |
| `sub_801E754` | `isBannerBusy_801E754` | "sub_801E754 = dword_20352C0 & 0x8000"; state 0x04 "writes 0x08 only when [it] returns 0" — TODO_ARCHIVE.md:2999,3016 (T7d) |
| `sub_801E792` | `spawnBannerRecord_801E792` | "the ENEMY DELETED banner up 49..106 (sub_801E792 asm00_2.s:31055-31112)" — TODO_ARCHIVE.md:2750 (F32b); src/battle.rs:1184 |
| `sub_801E838` | `uploadBannerText_801E838` | "the banner/message text uploader: 8x16 font cells, uploads twenty cells as five 32x16 objects" — src/banner.rs:7; the routine's own note in this repo |
| `sub_801E95C` | `buildChipNamePopup_801E95C` | "the chip-name popup BUILDER" — src/battle.rs:4115; the routine's own note |
| `sub_801EA34` | `queueChipPowerDigits_801EA34` | the routine's own note in this repo ("Queue four decimal digits of a chip's power figure into OBJ tiles") |
| `sub_801EA5A` | `getChipNamePopupBuffers_801EA5A` | the routine's own note ("Pick the chip-name popup's text buffer and OBJ tile destination for a player index") |
| `sub_801DFB8` | `AddToCustGauge_801DFB8` | "the gauge accessor at 0x020352a0" — src/battle.rs:1657; the body adds r0 and clamps at CUST_GAUGE_FULL, beside the existing `SetCustGauge`/`ClearCustGauge` |
| `sub_801E71C` | `setChipWindowSlideX_801E71C` | its only callers pass `CHIP_WINDOW_SLIDE_FROM - slideCounter` from the chip window's slide (asm03_0.s:979), and "the emotion window's OAM x takes the chip window's slide counter eStruct2035280+0x12 = SLIDE_FROM - x, added by sub_801CDEC" — TODO_ARCHIVE.md:2294 (F33), measured to the pixel |
| `sub_801DA24` | `initChipWindowBg3_801DA24` | "The game draws it on BG3 — char block 2, screen block 31 (sub_801DA24)" — src/custom.rs:3; the `wt/zero-layers` note already in this repo (BG3CNT 0x1f09, peeked live) |

New struct fields on `Struct2035280` (`include/structs/Struct2035280.inc`), each
replacing a raw offset the code carried with an address in a trailing comment:
`CustGaugeFlowCounter` (+0x00), `ChipWindowSlideX` (+0x12, was `byte_2035292`),
`CustGaugeValue` (+0x20, was `word_20352A0`), `HudElementMask` (+0x40, was
`dword_20352C0`).

New constants (`constants/enums/battle_constants.inc`): `BATTLE_SEQ_*` (the ten
sequencer states, with canon's own measured run over one battle),
`BATTLE_FSM_STATE_*`, `CUST_GAUGE_FULL` (0x4000), `CUST_GAUGE_FLOW_PERIOD`
(112 = lcm(28,16)), `CHIP_WINDOW_SLIDE_FROM`/`CHIP_WINDOW_SLIDE_STEP`.

### Left alone here, deliberately

- `sub_801483C` — two sources disagree. `TODO_ARCHIVE.md:3071` (T7c) reads it as
  the gate `bannerSeqState00Settle_800840C` waits on, and `src/battle.rs:2627`
  calls it "the slide-out idle"; `docs/coverage/battlestart_gunner.md:40-42`
  records the surrounding narrative as REFUTED. Not named.
- `sub_80084F0` and its table `off_8008508` — a SECOND dispatcher over the same
  `eBattleSequencerState_203CA70` word with its own seven-entry table, reached
  from a different battle-FSM state (`sub_800980E`). No source names its states,
  so it keeps its address names; a comment now points at the sharing.
- `sub_800834A`'s role: the note above the table says entries 6-9 "never run on
  the ordinary path", but T7u's chain `SEQ_08 -> SEQ_20 -> SEQ_24 -> ...` and the
  state-0x08 handler's own `mov r0, #0x20` put entries 8 and 9 squarely on it.
  Entries 8/9 are named for their state; entries 6/7 are named for their state
  and nothing more.

## Chip-select window, its art and Program Advance (`asm/asm03_0.s`)

`eS20364C0.JumpOffset01` selects a row of `ChipWindowStates_8026AA4` and is, like
the battle sequencer's state word, a PRE-MULTIPLIED byte offset — which is why
the code writes 4, 0x2c and 0x40 into it. The handlers are named for that value.
Three rows are confirmed against their own writers inside this file (state 0x00
writes 4 and 0x2c; state 0x04 writes 0x40 on a pick), and
`docs/coverage/battlestart_gunner.md:79-92` walks the same machine live.

| old | new | evidence |
|---|---|---|
| `sub_8026A28` | `isChipWindowReady_8026A28` | "the 'window ready' signal sub_8026A28 gates on … dispatches on eS20364C0's top FSM byte JumpOffset00" — docs/coverage/battlestart_gunner.md:79-99 |
| `sub_8026A50` / `sub_8026A6C` | `chipWindowReadyState00_8026A50` / `chipWindowReadyState08_8026A6C` | "state 0 sub_8026A50 returns 0 (and self-advances to 4) … state 8 sub_8026A6C returns Unk_04" — battlestart_gunner.md:81-84 |
| `off_8026AA4` | `ChipWindowStates_8026AA4` | the table `custMenuMainMaybe_8026A88` dispatches JumpOffset01 through |
| `sub_8026B04` | `chipWindowState00SlideIn_8026B04` | "State 0x00 of the chip window: THE SLIDE-IN" — this repo's own note; src/custom.rs:6; TODO_ARCHIVE.md:1742 (F18) |
| `sub_8026CCC` | `chipWindowState04Interactive_8026CCC` | "State 0x04 of the chip window: the interactive wait" — this repo's own note |
| `sub_8026BF4` | `chipWindowState08SlideOut_8026BF4` | "the window SLIDE-OUT routine: 0 -> 0x78 at 0xc, clears vacated columns with the blank tile" — src/custom.rs:1091; TODO_ARCHIVE.md:1552 (F3) |
| `sub_8027548` | `chipWindowState40Selected_8027548` | reached by the `JumpOffset01 = 0x40` write state 0x04 makes on a pick — docs/coverage/battlestart_gunner.md:100-102 and the code itself |
| the other 20 rows | `chipWindowStateXX_…` | their row in `ChipWindowStates_8026AA4` (state value = row offset), the scheme confirmed by the three writers above |
| `byte_8026C88` | `ChipWindowBlankTile_8026C88` | "clears the columns the window has vacated with the blank tile (byte_8026C88)" — src/custom.rs:710; TODO_ARCHIVE.md:1552 (F3) |
| `dword_8026CC8` | `ChipWindowCameraPanStep_8026CC8` | "every slide-out call adds dword_8026CC8 = 0x18000 to the camera's y at Camera+0x34" — src/custom.rs:1096; TODO_ARCHIVE.md:2119 (F29) |
| `sub_8029D80` | `blankChipNameStrip_8029D80` | "CopyBackgroundTiles of tile 0 over the 7x2 chip-NAME region" — src/battle.rs:2602; TODO_ARCHIVE.md:1741 (F18) |
| `sub_8029C08` | `drawChipWindowMark_8029C08` | "queues the regular-chip MARK during the slide; returns early once RenderInfo+0x18 passes 0x67" — src/custom.rs:153; TODO_ARCHIVE.md:2629 (F37f) |
| `sub_8028820` | `drawChipCursorBracket_8028820` | "Draws the highlight bracket around the chip the cursor is on, and BLINKS it" — this repo's own note; src/custom.rs:107; TODO_ARCHIVE.md:76 (A2) |
| `sub_802A220` | `pollChipWindowSelection_802A220` | "When sub_802A220 reports a selection it zeroes +0x40 again on the way out" — this repo's own note; docs/coverage/battlestart_gunner.md:103-105 |
| `sub_8028894` / `sub_80288D0` | `placeSlotCursorBracket_8028894` / `placeOkCursorBracket_80288D0` | "the SLOT cursor-bracket placement … the OK cursor-bracket placement (0x58, 0x6b)" — src/custom.rs:296-302 |
| `byte_80288B0` / `byte_80288E4` | `SlotCursorBracketCorners_80288B0` / `OkCursorBracketCorners_80288E4` | "byte_80288B0 for a slot, byte_80288E4 for OK … four words each of dy, 0, dx, flags" — src/custom.rs:305 |
| `byte_86E625C` / `dword_86E1D38` | `ChipWindowMap_86E625C` / `ChipWindowTiles_86E1D38` | "the 15x20 map byte_86E625C in palette bank 9"; "The tiles are dword_86E1D38" — src/custom.rs:4,7 |
| `byte_8027B2C` / `sub_8027CCC` | `ChipWindowMapPatches_8027B2C` / `applyChipWindowMapPatches_8027CCC` | "the game overwrites 27 rectangles with running VRAM tile ids (byte_8027B2C via sub_8027CCC) … eight bytes: x, y, w, h, bank and the column-major flag" — src/custom.rs:10,237 |
| `dword_802A7CC` / `sub_8027E90` | `ChipWindowSlotTemplate_802A7CC` / `initChipWindowSlots_8027E90` | "sub_8027E90 copies the template dword_802A7CC into the twelve per-slot records" — src/custom.rs:92 |
| `sub_80281D4` | `drawChipWindowSlotRow_80281D4` | "Draws the offered chips' icons/code letters in the first slot row" — src/custom.rs:973 |
| `sub_8028204` / `dword_86E591C` | `drawChipWindowCodeLetters_8028204` / `ChipCodeGlyphs_86E591C` | "The blank code glyph, dword_86E591C[0x1b] (sub_8028204)" — src/custom.rs:224 |
| `sub_8028310` / `byte_86E601C` | `drawEmptyChipIcon_8028310` / `EmptyChipIcon_86E601C` | "the empty icon byte_86E601C where there is no chip (sub_8028310)" — src/custom.rs:14 |
| `sub_8028320` | `drawChipWindowOkBox_8028320` | "the live OK box (sub_8028320)" — src/custom.rs:17 |
| `sub_80283C8` / `byte_8028470` | `pickChipIconPaletteBank_80283C8` / `ChipIconPaletteBanks_8028470` | "maps the slot record's selectable byte through byte_8028470 to bank 11 or 12" — src/custom.rs:78 |
| `sub_8028476` | `drawChipCard_8028476` | "sub_8028476 draws nothing for the empty slot types" — src/custom.rs:997 |
| `sub_80284E2` | `drawChipCardPicture_80284E2` | "A card picture is 7 x 6 tiles (sub_80284E2 copies 0x540 bytes)" — src/chips.rs:10 |
| `sub_802869E` | `drawChipCardDamageRow_802869E` | "sub_802869E draws the row" (the card's attack-power row) — src/custom.rs:1285 |
| `sub_8028D6C` / `sub_8028E4C` / `sub_8029032` | `addChipPick_8028D6C` / `canChipJoinPicks_8028E4C` / `undoChipPick_8029032` | "A on a slot ADDS it … while the pick fits sub_8028E4C's rule"; "B undoes the last pick" — src/custom.rs:32-34; src/chips.rs:13 |
| `sub_802A40C` | `getChipsOfferedPerWindow_802A40C` | "Chips offered per window: the base count before Custom parts (sub_802A40C)" — src/custom.rs:86 |
| `sub_8027EE8` / `sub_802945A` / `sub_80293F8` | `offerDeckChipsToWindow_8027EE8` / `packDeckEntries_802945A` / `blankPickedDeckSlots_80293F8` | src/deck.rs:8-10 |
| `off_802BCB0` / `off_802BC60` | `PARecipePtrsA_802BCB0` / `PARecipePtrsB_802BC60` | "43 pointers byte_802BA60..byte_802BB92, terminated .word NULL"; "20 pointers byte_802BB98..byte_802BC56" — docs/recon/T10.md:14 |
| `off_80295C0` / `sub_80295C8` / `sub_802961A` | `PAMatchers_80295C0` / `paMatchCodeId_80295C8` / `paMatchExact_802961A` | "code-id extraction sub_80295C8 … exact-match sub_802961A" — docs/recon/T10.md:15 |
| `sub_8029520` | `matchPARecipes_8029520` | "sub_8029520 walks recipe lists" — docs/recon/T10.md:13 |
| `dword_2033000` / `byte_20366C0` | `ePAScratch_2033000` / `eSelectedChipCodes_20366C0` | "scratch dword_2033000 (zeroed 0x48 bytes)"; "selected-chip code array" — docs/recon/T10.md:10,18 |

`oS20364C0_Extra_Unk_40` -> `oS20364C0_Extra_WindowFrameCounter`, on the note
already in `include/structs/S20364C0.inc` ("the window's OWN FRAME COUNTER, and
it is the phase of the highlight bracket's blink") and `TODO_ARCHIVE.md:76` (A2).

## RenderInfo's BG registers (`include/structs/RenderInfo.inc`)

`render_800172C` copies this struct's +0x04..+0x3c straight to BG0CNT onward, so
every offset here is a known hardware register. The mapping was worked out and
then confirmed live (`--watch` on 0x0200ac58 through a chip-window slide) by the
bn project's AUDIT wave 3d "bg3-merge" ticket, whose note is still at the head of
the file. These field renames also replaced 25 raw `[rX,#0xNN]` accesses across
`asm/asm03_0.s`, `asm03_1_1.s`, `asm03_2.s`, `asm36.s` and `asm00_0.s`.

`Unk_0a` -> `BG3Control_0a`, `Unk_0c` -> `BG0HOfs_0c`, `Unk_0e` -> `BG0VOfs_0e`,
`Unk_10` -> `BG1HOfs_10`, `Unk_12` -> `BG1VOfs_12`, `Unk_14` -> `BG2HOfs_14`,
`Unk_16` -> `BG2VOfs_16`, `Unk_18` -> `BG3HOfs_18`, `Unk_1a` -> `BG3VOfs_1a`
(each as `oRenderInfo_<new>`).

## Enemy identity, the per-AIIndex tables, the virus dispatch, the Gunner and the shockwave

| old | new | evidence |
|---|---|---|
| `byte_80182C4` | `VerActorTyAIIdxTable_80182C4` | "the enemy identity table: 3-byte records `version, ACTOR_TYPE_*, ai_index`, indexed by enemy id" — docs/recon/T10.md:21; TODO_ARCHIVE.md:2976 (T12); src/gunner.rs:269 |
| `off_8109050` | `AIThinkTables_8109050` | "think off_8109050 32 words … Think words are CurAction-indexed state-HANDLER TABLE pointers … not routines" — TODO_ARCHIVE.md:2976 (T12); docs/coverage/plan-interpreters.md:266 |
| `off_81090D0` | `AIEnemyStruct1Ptrs_81090D0` | "virus sub-table off_81090D0 (32 ptrs; MettaurEnemyStruct1_8109BD0 at idx 1, GunnerEnemyStruct1_8112B94 at 0x5C)" — docs/recon/T10.md:22 |
| `off_8109150` | `AIEnemyStruct2Ptrs_8109150` | "off_8109150 -> elem_hp u16 @0x00 with spot-checks Mettaur 0x0028 and Gunner 0x003C" — TODO_ARCHIVE.md:2976 (T12); docs/recon/T10.md:23 |
| `off_81091D0` | `AIActHandlers_81091D0` | "act off_81091D0 … called via bx r0" — TODO_ARCHIVE.md:2976 (T12) |
| `off_80B8204` | `T1ActorTypeHandlers_80B8204` | "It reads oBattleObject_AIDataPtr->ActorType and picks one of three handlers below (virus/navi/player)" — this repo's own AUDIT wave 3c note at t1_0x0_80B81EC; docs/coverage/plan-interpreters.md:258 |
| `battleObject_dispatch_8108F50` | `virusObject_dispatch_8108F50` | CORRECTION of an over-broad existing name: "the 'virus' branch of t1_0x0_80B81EC's ActorType dispatch … ONE caller" — this repo's own note; "virus dispatch: CurState 3-table then unconditionally sub_8016E64" — plan-interpreters.md:261 |
| `off_8108F68` | `VirusObjectStateHandlers_8108F68` | "the CurState 3-table off_8108F68 -- sub_8016F56 / battle_8108F74 / sub_8016C4E" — src/objects.rs:119 |
| `battle_8108F74` | `virusObject_update_8108F74` | "per-frame enemy body: sub_81095D0, sub_801ABB8, NameID gates, then AIIndex -> battle_801B1C4 + behavior table + attack table" — plan-interpreters.md:262 |
| `sub_80F2330` | `naviObject_dispatch_80F2330` | "navi -> sub_80F2330" arm of the same three-way — plan-interpreters.md:258; src/objects.rs:126 |
| `sub_8016E64` | `runEnemyAttackAnim_8016E64` | "the dispatch tail: the attack-anim driver sub_8016E64" — src/objects.rs:163; plan-interpreters.md:261; and this repo's own older comment "disabling this causes enemy attack animations to cease playing" |
| `sub_8016BFC` | `runAIAttackDuringTimestop_8016BFC` | "then the RunAIAttack tail (or sub_8016BFC in timestop)" — src/objects.rs:108; plan-interpreters.md:263 |
| `sub_81130E4` `sub_81130F0` `sub_81130FC` `sub_8113108` | `gunnerMaterialize04_…` … `07_…` | "0x10-0x1C \| sub_81130E4/0F0/0FC/108+1 \| materialize" — docs/coverage/gunner.md:29; each body clears RelatedObject1Ptr then delegates to a shared appear routine |
| `sub_8113114` | `gunnerClearRelatedObject_8113114` | the body those four share |
| `sub_8112F4E` | `gunnerAttackExec_8112F4E` | "The CurAction 0x0A arm (the ATTACK the gunner actually fires) is itself a 4-arm state machine dispatched through off_8112F60" — gunner.md:44-48 |
| `off_8112F60` | `GunnerAttackSteps_8112F60` | same |
| `sub_8112F70` | `gunnerAttackAimCursor_8112F70` | "0=sub_8112F70 (aim cursor)" — gunner.md:47; src/gunner.rs:385. CONTESTED: TODO_ARCHIVE.md:3410 (T9k, an unmerged NEGATIVE ticket) calls it "spawn projectile". The detailed reading wins; the index is kept in the table's comment either way. |
| `sub_8112FBA` | `gunnerAttackLockCursor_8112FBA` | "4=sub_8112FBA (cursor locked, fire setup)" — gunner.md:47; src/gunner.rs:388 (same T9k caveat) |
| `sub_8113002` | `gunnerAttackFireShots_8113002` | "8=sub_8113002 (firing 3 shots 10 frames apart)" — gunner.md:47-48; src/gunner.rs:391 |
| `ai_8113038` | `gunnerAttackRecover_8113038` | "12=ai_8113038 (recover 24 frames)" — gunner.md:48 |
| `sub_8113162` | `gunnerRowCheck_8113162` | "the gunner's CurAction transitions to 0x0A via sub_8113162's row-check"; "attacks only when an opponent stands somewhere ahead in its row" — gunner.md:74-75; src/gunner.rs:5 |
| `sub_80E3CC4` | `lockOnCursor_update_80E3CC4` | "The lock-on CURSOR's update (t4_0x30_80E3B70): moves at the version's speed … locks 24 frames and hands the panel back" — src/gunner.rs:35 |
| `byte_80C6B00` | `ShockwaveHopTable_80C6B00` | "THE SHOCKWAVE'S PER-HOP TABLE: 16 rows of 4 bytes, indexed by Param1 * 4" — this repo's own note; TODO_ARCHIVE.md:46 (A1) |
| `off_80C6B58` / `sub_80C6B64` | `ShockwaveSegmentStates_80C6B58` / `shockwaveSegmentInit_80C6B64` | "state 0 sub_80C6B64 loads the sprite then falls through to object_updateSprite the same frame" — TODO_ARCHIVE.md:2053 (F25d); src/battle.rs:3514 |
| `sub_80C6C14` | `shockwaveSegmentUpdate_80C6C14` | "object_highlightCurrentCollisionPanels is called unconditionally from sub_80C6C14 … the CurState-1 handler" — TODO_ARCHIVE.md:89 (A3); src/battle.rs:3519 |
| `sub_80C6C6A` | `shockwaveSegmentHop_80C6C6A` | "the old segment's sub_80C6C6A spawns it" — src/shot.rs:51,60 |
| `sub_80C6CBA` | `shockwaveSegmentDepart_80C6CBA` | "the old one stays put and keeps looping until its own animation reports its last frame" — src/shot.rs:101 |
| `sub_80C6CE4` | `spawnShockwaveSegment_80C6CE4` | "spawns a whole new object on the next panel" — src/shot.rs:99; and the Mettaur swing calls it at counter 0x1b |
| `sub_80C6CFC` | `applyShockwavePanelEffect_80C6CFC` | "+3 the panel effect, handed to sub_80C6CFC: 0xff does nothing, 3 calls object_crackPanel, 1 breaks" — this repo's own note on the hop table |

New vocabulary: a header block above `AIThinkTables_8109050` describing the four
parallel 32-word tables, what a think word actually is, and T12's two
known-answer checks, plus `NUM_AI_INDICES`; a header on
`VerActorTyAIIdxTable_80182C4` giving the row shape, the 452 rows and the
PLAYER tail with no think/act entry; `enemy_getStruct2_struct_RowStride`,
`ENEMY_ELEM_FIGURE_MASK` and `ENEMY_ELEM_SHIFT` beside `enemy_getStruct2`;
a role comment on every row of `ForGunner_8113078`; and
`GUNNER_ATTACK_AIM/LOCK/FIRE/RECOVER` plus the measured
`GUNNER_SHOTS`/`GUNNER_SHOT_GAP`/`GUNNER_RECOVER_FRAMES`/`GUNNER_LOCK_FRAMES`.

### Left alone here, deliberately

- `sub_8112D9C` — gunner.md calls it the CurAction 0x2C "guard/cleanup",
  `docs/coverage/opening_integrated.md:104` calls it a state dispatcher that is
  explicitly NOT the materialize, and `docs/trace/t9g/README.md:117-119` calls it
  a 234-frame heartbeat. All three may be the same thing, but no source commits,
  so it keeps its address name and the table now carries all three readings.
- `sub_80165B8`, `sub_80165C2`, `sub_80166AE`, `sub_8016B02`, `sub_8016CE8`,
  `sub_8016B36`, `sub_8016B72`, `RunSpawnAnimationMaybe_8016380` — these sit in
  several AIs' CurAction tables at once, so the per-enemy role names the docs
  give them (e.g. "the Gunner's idle") would be wrong on the symbol.
- `off_810C6F0` and the other 29 unnamed think tables — `docs/inventory/enemies.md`
  maps each to an AIIndex but not to an enemy, so there is no descriptive name to
  give them; the new header on `AIThinkTables_8109050` says how to read the index.

## The RESULT window and the busting level (`asm/asm03_0.s`, `asm/asm00_1.s`)

Evidence throughout: `/home/box/Code/bn/src/results.rs` (the port of this whole
window, which cites each routine as it reproduces it) and the F8/F21/F21c/F21d/
F34/T7w ticket results, which timed the chain frame by frame against captures.

| old | new | evidence |
|---|---|---|
| `sub_802C34E` | `showResultWindow_802C34E` | "puts up the RESULT window after the last enemy is deleted, or the LOSER window when the player is … redrawn from column -30" — src/results.rs:3; and this repo's own AUDIT wave 3d note |
| `sub_802BD60` | `resultWindowDriver_802BD60` | "driver sub_802BD60" — TODO_ARCHIVE.md:1816 (F21); "the slide's tilemap redraw -- CopyBackgroundTiles(...), not a scroll" — src/results.rs:713 |
| `sub_802BE36` | `resultWindowSlideTick_802BE36` | "the slide tick sub_802BE36 adds 2 to that signed byte"; "16 px/frame is exactly results::SLIDE_STEP" — src/results.rs:59; TODO.md:432 (T7w) |
| `sub_802BED4` / `sub_802BEFC` | `resultWindowHandover_802BED4` / `resultWindowArmPrompt_802BEFC` | "the one-frame handover state after the slide"; "sets [r5,#3]=8 so sub_802BF0C starts blinking" — src/results.rs:183,186 |
| `sub_802BF0C` | `resultWindowWaitForA_802BF0C` | "The WAIT state: blinks the prompt on bit 3 of the global frame counter and rewrites the ten cells every frame" — src/results.rs:795; TODO_ARCHIVE.md:2355 (F34) |
| `sub_802C810` | `drawResultPrompt_802C810` | "Writes the ten cells at window (2,14)" — src/results.rs:126 |
| `sub_802C4B6` | `blitResultWindowRect_802C4B6` | "The rectangle blit helper (x, y, src, w, h)" — src/results.rs:128 |
| `byte_802C834` / `byte_802C848` | `ResultPromptBlankRun_802C834` / `ResultPromptPressARun_802C848` | "Ten copies of tile 0xc4 … the flat window face run, state 0"; "Tiles 0xba..0xc3 … the PRESS A BUTTON prompt run, state 1" — src/results.rs:129,131 |
| `sub_802C280` | `dismissResultWindow_802C280` | "waits for A or Start, holds 0x14 more frames, then fades the screen out" — src/results.rs:7 |
| `sub_802C4E8` | `drawResultClearTime_802C4E8` | "Draws the clear TIME: five BCD digits right-to-left at row 4" — src/results.rs:10 |
| `byte_802C538` | `ResultClearTimeDigitCols_802C538` | "DIGIT_COLS … provenance: derived -- sub_802C4E8; byte_802C538" — src/results.rs:106 |
| `dword_802C548` | `ResultClearTimeCap_802C548` | "The clear time is capped at 9'59\"99 (dword_802C548)" — src/results.rs:89 |
| `sub_802C6EC` | `drawResultLevel_802C6EC` | "Draws the LEVEL readout at row 6 cols 16-20" — src/results.rs:192 |
| `sub_802C044` | `revealResultReward_802C044` | "draws the 42 coin tiles one per frame in PrimaryRNG-shuffled order" — src/results.rs:284; TODO_ARCHIVE.md:1816 (F21) |
| `sub_802C0A4` | `countResultRewardCooldown_802C0A4` | "Counts that 0x1e cooldown down, ending in the actual grant plus jingle" — src/results.rs:293 |
| `sub_802CA5C` | `enqueueResultMark_802CA5C` | "Enqueues the RESULT mark object at ([r5+6]*8+13) & 0x1ff" — src/results.rs:372; TODO_ARCHIVE.md:1583 (F8) |
| `dword_8732814` / `dword_8733394` | `ResultWindowPalettes_8732814` / `ResultRewardPalette_8733394` | "96 B (window banks 9-11) and 32 B (reward bank 12)" — src/results.rs:42 |
| `byte_203EAE0` | `eBustingCounters_203EAE0` | "the game's per-alliance counters (byte_203EAE0; sub_800AC20)" — src/results.rs:206 |
| `sub_800AC20` | `computeBustingLevel_800AC20` | "The busting-level scorer (time base, hits, moves, multi-deletions, counter hits)" — src/results.rs:206 |
| `off_800ADDC` / `byte_800AE00` | `BustingLevelTimeGates_800ADDC` / `BustingLevelTimeBases_800AE00` | "Time gives a base of 6/5/4/3 at or under 5.00, 12.00 and 36.00 seconds (off_800ADDC, byte_800AE00)" — src/results.rs:218 |

New vocabulary: the whole driver chain, in order with what each link does and
the 107-frame offset from the sequencer edge, is written above
`resultWindowDriver_802BD60`, together with `RESULT_SLIDE_STEP_COLUMNS`,
`RESULT_REWARD_TILES` and `RESULT_REWARD_COOLDOWN_FRAMES`.

## Backdrop, audio, sprites/palettes, panels, the buster and thrown chips

| old | new | evidence |
|---|---|---|
| `off_807FB98` | `BattleBackdropGFXAnimScript_807FB98` | "the script is off_807FB98 (data/dat20.s:140-172): TEN 4-frame entries, then NINETEEN 8-frame entries, a 192-frame loop" — TODO_ARCHIVE.md:364 (A7), VERIFIED EXACT against a live dump; src/backdrop.rs:69 |
| `byte_807FE40` … `byte_807FDF8` | `BattleBackdropTiles0_807FE40` … `Tiles6_807FDF8` | "FRAMES[0]=E40, [1]=CD8, [2]=C90, [3]=D20, [4]=D68, [5]=DB0, [6]=DF8" — TODO_ARCHIVE.md:317 (A7); src/backdrop.rs:74-76 |
| `dword_8617488` | `GFXAnimTileBlob_8617488` | "slice those tiles out of the blob at dword_8617488" — TODO_ARCHIVE.md:328 (A7); src/backdrop.rs:36. NOT named for the backdrop: this disassembly shows the same blob is the gfx_src of five more GFXAnim scripts, the warp animations in maps/CentralArea, GreenArea, SeasideArea and SkyACDCArea. |
| `sub_8001C94` | `applyGFXAnimStepTiles_8001C94` | "the per-element glyph tile assembler + ONE queued QueueEightWordAlignedGFXTransfer … it writes char-block art, never the BG1 map" — TODO.md:407 (F36c, which REFUTES the "BG1 seam transition" reading several earlier tickets assumed); src/backdrop.rs:27 |
| `byte_8156D6C` | `ToneDataSoundBuster6A_8156D6C` | "type 0x9 = square1, duty 0 = 12.5%, sweep byte 0x1F …" — src/battle.rs:80 |
| `byte_81B82EC` / `dword_81B82FC` | `SongTrackSoundBuster6A_81B82EC` / `SongHeaderSoundBuster6A_81B82FC` | "its song header (dword_81B82FC) is one track"; "That song's single TRACK" — src/battle.rs:79 |
| `dword_8156D78` | `ToneDataSoundHit6B_8156D78` | "The ToneData (voicegroup entry) that points at that sample" — this repo's own note |
| `byte_81597A0` | `WaveDataSoundHit6B_81597A0` | "SOUND_HIT_6B's SAMPLE: an M4A/MP2K WaveData, 16-byte header then raw PCM" — this repo's own note; TODO_ARCHIVE.md:757 (B3a) |
| `byte_81B8308` / `dword_81B8318` | `SongTrackSoundHit6B_81B8308` / `SongHeaderSoundHit6B_81B8318` | "The SongHeader for SOUND_HIT_6B … this header -> voicegroup -> wave" — this repo's own note; TODO_ARCHIVE.md:649 (B3c) |
| `sub_80BCF7A` | `playBusterFireSound_80BCF7A` | "SOUND_BUSTER_6A (id 0x6A …, played at the fire phase by sub_80BCF7A)" — TODO_ARCHIVE.md:3211 (T13) |
| `sub_800BF5C` | `getAllianceAnnouncerBlock_800BF5C` | "alliance -> &byte_203CF00[alliance * 0x50]" — this repo's own note |
| `byte_203CF00` | `eAllianceAnnouncerBlocks_203CF00` | same |
| `sub_800B892` | `getChipNamePopupSyncByte_800B892` | "a synchronisation byte between the two sides' popup announcers, not a property of any chip" — this repo's own note; TODO_ARCHIVE.md:799 (C4) |
| `sub_800B89C` | `clearAllianceAnnouncerSlot_800B89C` | "sub_800B89C zeroes it" — same note; the body zeroes byte 1 and the word at +8 |
| `byte_20349C0` | `eBattleHands_20349C0` | "Each combatant's battle-hand lives at byte_20349C0 + alliance*0x50" — this repo's own note; src/battle.rs:1278 |
| `sub_800FC7C` | `advanceBattleHandChipIndex_800FC7C` | "sub_800FC7C advances the count" — same note; src/battle.rs:1280 |
| `sub_800C01C` | `buildPanelTileLayout_800C01C` | "Produces the field's panel TILE LAYOUT" — src/field.rs:6 |
| `sub_800C0BA` | `drawPanelHighlight_800C0BA` | "a solid block of one tile over a panel for a single frame" — src/field.rs:38 |
| `sub_800C380` | `tickPanels_800C380` | "the per-frame PANEL TICK (Type vs Animation…)" — src/field.rs:195 |
| `sub_800C488` | `tickBrokenPanelRegen_800C488` | "The broken-panel REGEN timer: 0x258 frames (0x1e0 in battle mode 1)" — src/field.rs:178; TODO_ARCHIVE.md:604 (B2) |
| `byte_203CB04` | `ePanelTickCounter_203CB04` | "counter byte_203CB04 (reload 0x8c)" — docs/recon/T10.md:46 |
| `sub_80028C0` | `storeObjectOamSlot_80028C0` | "is **not** the player. It is three instructions — store one byte of dword_200F340 into byte_200F389[r0] — i.e. OAM-slot bookkeeping" — docs/coverage/plan-interpreters.md:61-65 (a recorded refutation) |
| `sub_8002818` | `stageObjPalette_8002818` | "stages a 16-colour palette into the IWRAM OBJ-palette mirror at slot Unk_15 >> 4; not an allocator" — docs/recon/F39a.md:161 |
| `byte_3001550` | `iObjPaletteMirror_3001550` | "0x03001550 holds 16 x 32 bytes: an IWRAM mirror of the 16 OBJ palettes" — docs/recon/F39a.md:162 |
| `sub_3005EF0` / `off_3005F20` | `blendStagedObjPalette_3005EF0` / `ObjPaletteBlendModes_3005F20` | "a colour-blend of the 16 staged words in place, not an allocator: r0 = blend param, r2 = jump index into off_3005F20" — docs/recon/F39a.md:163 |
| `sub_8002874` | `loadObjAffineMatrix_8002874` | "affine-matrix load (gated by getSpriteDrawGateFlags_80466D8 bit 0x20)" — docs/recon/F39a.md:43 |
| `sub_801641A` | `materializeObject_801641A` | "the materialize/appear phase handler: Timer/Timer2 countdown, mosaic+alpha ramp … teardown -> phase 8" — docs/recon/F39a.md:46; docs/coverage/opening_integrated.md:170; and the `// bn F38e/F38h` notes already at the routine, which also record that it does NOT move y |
| `sub_801A5EE` | `applyMercyInvulnerability_801A5EE` | "the flash timer is seeded to 0x78 in the post-hit invulnerability handler"; "canon's routine (sub_801A5EE) sets the 120" — src/actor.rs:223; TODO_ARCHIVE.md:1691 (F14) |
| `sub_80EB450` / `sub_80EB502` | `busterFirePhase_80EB450` / `busterHoldPhase_80EB502` | "sub_80EB450 is the FIRE phase and leaves after 5 ticks"; "then sub_80EB502 HOLDS for Unk_12 frames" — src/actor.rs:64-66; TODO_ARCHIVE.md:2274 (F31b) |
| `sub_800FAAC` / `sub_800FAF6` | `getBusterHoldLength_800FAAC` / `countFreePanelsAheadForBuster_800FAF6` | "it reads the navi's Rapid stat and hands it with the FRONT panel to sub_800FAF6"; "walks forward while the panel is valid and unmasked, caps the count at 5" — src/actor.rs:69-71 |
| `byte_80209CC` | `BusterHoldFramesByRapid_80209CC` | "byte_80209CC[Rapid*6 + min(free panels ahead,5)] … three exact predictions" — TODO_ARCHIVE.md:2274 (F31b) |
| `byte_800FB4C` | `BusterWalkStopPanelMask_800FB4C` | "The alliance MASK of panel parameters that stops the forward walk" — src/actor.rs:476 |
| `sub_80C5C9C` | `thrownBombObject_update_80C5C9C` | "The flight of a thrown chip object (battle object type 3 sub-type 8)" — this repo's own note; src/battle.rs:971 |
| `byte_80C5D58` | `ThrownBombLaunchParams_80C5D58` | "three words, X velocity 0x0002E666, gravity 0xFFFFD800 and Z velocity 0x00020666" — this repo's own note; src/battle.rs:750 |
| `sub_80C5DBC` | `spawnThrownBomb_80C5DBC` | "MiniBomb's THROWN-BOMB spawn (t3_0x8_80C5BB0): 4 px ahead, 0x30 up" — src/battle.rs:746 |
| `dword_80C5D7C` | `ThrownBombLandRegionByParam1_80C5D7C` | "the region byte dword_80C5D7C[Param1] is 1 for MiniBomb and 0xf for BigBomb" — src/battle.rs:945 |
| `off_80EB6F8` | `ThrownChipSpawnersBySubfamily_80EB6F8` | "Spawners for a thrown chip, indexed by the chip's SUBFAMILY" — this repo's own note; src/battle.rs:907 |
| `sub_80D47C0` / `dword_80D4A18` | `vDollObject_update_80D47C0` / `VDollGravity_80D4A18` | "VDoll's doll in flight … gravity (dword_80D4A18 = 0xFFFFE000)" — this repo's own note; src/battle.rs:349 |
| `sub_80D9E94` / `dword_80D9F28` | `bugBombObject_update_80D9E94` / `BugBombGravity_80D9F28` | "BugBomb's ball in flight … the gravity is the constant dword_80D9F28" — this repo's own note; src/battle.rs:341 |
| `sub_80C7EC8` | `spawnDeathDebris_80C7EC8` | "the falling-body/debris spawner … Calls bl GetRNG twice" — docs/coverage/battle_full.md:1503 |
| `sub_80AA4C0` | `rollRandomEncounter_80AA4C0` | "the enemy list is built inside frame 60 by sub_80AA4C0 from the settings pointer" — TODO_ARCHIVE.md:3036 (T9c); and the encounter-roll note already at the routine in this repo |
| `sub_80AA5F4` | `selectEncounterTableForMap_80AA5F4` | "encounter selection at map-group/map-number level (0x10-stride records, 0xff terminator)" — docs/recon/T10.md:62 |
| `byte_80B5347` / `byte_80B5354` | `EnemySetupMettaurGunner_80B5347` / `EnemySetupThreeMettaur_80B5354` | "BattleSettings record 6 … setup byte_80B5347: … Mettaur + Gunner"; "byte_80B5354, the three-Mettaur record" — TODO_ARCHIVE.md:3038 (T9c), :3098 (T9b), both verified by a sweep |

New vocabulary: `BATTLE_BACKDROP_SCROLL_X_STEP`/`_Y_STEP`/`_SHIFT`/`_PERIOD` (896,
measured frame-against-frame) and `BATTLE_BACKDROP_ART_PERIOD` (192) above the
scroll callback; a header on the backdrop's GFXAnim script giving its ten-then-
nineteen entry shape and the one-frame offset from the scroll's zero; the index
formula and the three measured predictions on `BusterHoldFramesByRapid_80209CC`;
and a comment on `sub_80084F0` recording that it is a SECOND dispatcher over the
same sequencer state word with its own table.

## Player/navi core, the chip attack families and OBJ emission

| old | new | evidence |
|---|---|---|
| `sub_8012E74` / `sub_8013DA0` / `sub_801AC6C` | `readPlayerInput_8012E74` / `playerAiTick_8013DA0` / `playerStateDispatch_801AC6C` | "the per-tick work (input read sub_8012E74, AI tick sub_8013DA0 …)"; "state-machine dispatch sub_801AC6C" — src/objects.rs:63-64; docs/coverage/battle_full.md:1546 |
| `sub_8012DFC` | `refreshAIDataFromJoypad_8012DFC` | "input refresh sub_8012DFC … runs from 0x08, never from 0x0C"; "refreshes the TWO alliance players' AIData" — TODO_ARCHIVE.md:2567 (F33d), :1433 (F5) |
| `sub_800FB54` | `useChipFromHand_800FB54` | "CurAction 0x08->0x14 at 0x0801169A via sub_800FB54 -> object_setAttack2" — TODO_ARCHIVE.md:1487 (F5b), measured with --watch-write |
| `sub_80EB088` / `sub_80EB128` / `sub_80EB194` / `sub_80EB1C4` | `naviMoveLeave_…` / `Travel` / `Arrive` / `Recover` | "the move state machine, which runs one step per frame across sub_80EB088 -> sub_80EB128 -> sub_80EB194 -> sub_80EB1C4 … 4 leaving frames, 5 arriving" — src/actor.rs:36 |
| `sub_8010332` | `getNaviMoveRecoveryFrames_8010332` | "The recovery length is per-navi and defaults to 4" — src/actor.rs:38; the body returns 4 when the NaviStats byte is 0 |
| `byte_8012DD4` | `MoveDestinationFilterMask_8012DD4` | "the game's destination filter rejects by the panel's reserve and occupant flags (byte_8012DD4 …)" — src/actor.rs:776 |
| `sub_8017122` | `enemyNaviDeathBlink_8017122` | "An enemy navi blinks white for 0x5a frames" — src/actor.rs:236 |
| `sub_80174FE` / `sub_80173F4` | `playerFlinchAction_80174FE` / `playerDeleteAction_80173F4` | "flinch 0x03 (sub_80174FE, PlayerObjectAIAttackJumptables[3])"; "Jumptable [2] — the DELETE CurAction 0x02" — src/actor.rs:644,647; the tables in this repo already comment the flinch slot |
| `sub_801A7CC` / `sub_801A802` / `byte_8020B2C` | `barrierTakeDamage_801A7CC` / `barrierBreak_801A802` / `BarrierHpByType_8020B2C` | "A Barrier chip's remaining HP … hits are taken off it"; "and it breaks at zero"; "Barrier's HP for type 1 is 10 (byte_8020B2C)" — src/actor.rs:377-378; src/battle.rs:650 |
| `sub_801265A` | `getBusterDamage_801265A` | "Buster damage is Attack + 1 for MegaMan" — src/battle.rs:70 |
| `byte_80210DD` | `NaviBaseHpByRow_80210DD` | "byte_80210DD (data/dat01.s:295) row 0 gives 50 * 2 = 100" — src/battle.rs:52 |
| `sub_800FE12` | `readPerVersionHword_800FE12` | "The version column comes from the AI data's version byte (sub_800FE12)" — src/battle.rs:66. NOTE: the body does more than read the byte — it indexes a caller-supplied per-Version u16 table with it, special-casing Version 4. The name follows the body; a comment at the routine spells the special case out. |
| `sub_80F2180` | `shotImpact_80F2180` | "played from the shot-impact handler sub_80F2180" — docs/coverage/audio-buster.md:26 |
| `sub_800A3E4` / `sub_800A570` | `buildBattleFolder_800A3E4` / `shuffleBattleFolder_800A570` | "The game builds it once in the battle intro (sub_800A3E4) by copying the PET navi's folder into eBattleFolder"; "shuffling it with the secondary generator (sub_800A570)" — src/deck.rs:3,7 |
| `off_80F24D8` / `off_80F253C` / `off_80F25A0` | `NaviEnemyStruct1Ptrs_…` / `NaviEnemyStruct2Ptrs_…` / `NaviActHandlers_…` | "navi sub-tables off_80F24D8 (EnemyStruct1 …) … off_80F253C … Entry routines off_80F25A0" — docs/recon/T10.md:30 |
| `off_80EA814` / `off_80EA8D8` | `PlayerEnemyStruct1Ptrs_80EA814` / `PlayerEnemyStruct2Ptrs_80EA8D8` | "player tables off_80EA814 (EnemyStruct1 …)" — docs/recon/T10.md:38 |
| `off_80117D4` | `ChargeShotHandlersByTransformation_80117D4` | "charge-shot dispatch off_80117D4", with a 25-row TF_* table — docs/SCOPE.md:781-810 |
| `sub_80EB644` / `byte_80EB738` | `miniBombAttack_80EB644` / `HeldBombObjectBySubfamily_80EB738` | "MiniBomb (attack family 0x12, sub_80EB644)"; "The held object takes byte_80EB738's packed row" — src/battle.rs:450,858 |
| `sub_80EB776` / `byte_80EBA18` / `byte_80EBAD8` / `byte_80EBB64` | `swordAttack_80EB776` / `SwordHitShapeBySubfamily_…` / `SwordArcBySubfamily_…` / `SwordObjectBySubfamily_…` | "The swords (attack family 0x13, sub_80EB776)"; "The hit shape is byte_80EBA18's first byte per subfamily"; "The arc's animation is byte_80EBAD8 per subfamily"; "The sword object is byte_80B8BD4's row … (byte_80EBB64)" — src/battle.rs:250,4173,4193,3093 |
| `sub_80EBC28` | `cannonAttack_80EBC28` | "Cannon and HiCannon (attack family 0x14, sub_80EBC28)" — src/battle.rs:472 |
| `sub_80EBF10` / `sub_80EBF6E` / `dword_80EBFEC` / `dword_80EBFF0` | `vulcanAttack_80EBF10` / `vulcanFireShots_80EBF6E` / `VulcanShotsBySubfamily_…` / `VulcanShotFanOffsets_…` | "Vulcan1 (attack family 0x17, sub_80EBF10)"; "Vulcan fires every 0xa frames, sub_80EBF6E"; "Shots per Vulcan, from the subfamily (dword_80EBFEC = 0xA050403)"; "the per-shot vertical FAN bytes 0x20181008" — src/battle.rs:490,497,4354; src/shot.rs:89 |
| `sub_80EC884` / `byte_80EC870` | `airShotAttack_80EC884` / `RecovHealBySubfamily_80EC870` | "AirShot (attack family 0x21, sub_80EC884)"; "the amounts are byte_80EC870, one per subfamily" — src/battle.rs:620,643 |
| `sub_80E0754` / `sub_80C6548` | `areaGrabMoveBoundary_80E0754` / `spawnAreaGrabOrb_80C6548` | "AreaGrab moves the boundary a column at a time (sub_80E0754)"; "AreaGrab's steal orb: the type-3 object 0xf (sub_80C6548 -> t3_0xf_80C6414)" — src/field.rs:209; src/battle.rs:690 |
| `byte_80B8BD4` | `TempObjectRecords_80B8BD4` | "The temp-attack/effect OBJECT RECORD table: one row per effect giving [effect list, index, anim, palette, …]" — src/shot.rs:29 |
| `byte_80E0398` | `EffectObjectRows_80E0398` | "The type-4 EFFECT ROW table (row 3 the deletion effect, row 6 the heal, rows 0x16-0x1a the sword arcs/blades)" — src/battle.rs:4101 |
| `off_80C4E70` / `sub_80C4E7C` / `sub_80C4F02` | `StraightShotStates_80C4E70` / `straightShotInit_80C4E7C` / `straightShotTravel_80C4F02` | "state 0 is sub_80C4E7C (off_80C4E70), which is what loads the sprite and its animation data"; "decrements Timer and moves one panel once it drops below zero" — src/shot.rs:205-206, :6; TODO_ARCHIVE.md:2136 (F31) |
| `sub_80C6A08` / `sub_80C6A50` | `vulcanSeedTravel_80C6A08` / `vulcanSeedHitSpark_80C6A50` | "t3_0x12_80C6946 into sub_80C6A08: one panel a frame, stopped by the first thing it hits"; "only the hit spark sub_80C6A50 shows" — src/objects.rs:215,217 |
| `sub_8002694` / `sub_3006440` | `emitObjectSpriteOam_8002694` / `emitObjEntry_3006440` | "reached via sub_8002694 -> sub_3006440"; "Emit iff (ObjectSprite.Unk_03 & 0x02) != 0 && (ObjectSprite.Unk_03 & 0x10) == 0" — docs/recon/F39a.md:26,40 |
| `sub_80466D8` | `getSpriteDrawGateFlags_80466D8` | "return byte of sub_80466D8 bit 0x40 skips the palette+affine loads … bit 0x80 skips only sub_8002818; bit 0x20 gates sub_8002874" — docs/recon/F39a.md:43 |
| `sub_801BC24` | `object_updateSpriteRebindOnly_801BC24` | "the rebind-only variant -- on a changed animation it rebinds and returns WITHOUT ticking" — src/spr.rs:485; docs/coverage/plan-interpreters.md:58 |

## Contradictions found between the sources

Recorded here because a later reader will hit them too. Where the disassembly's
own older comment was the losing side, a CORRECTION line was added beside it
rather than deleting what it said.

1. `BannerSequencerStates_8008038` entries 6-9. This repo's own note said all
   four "never run on the ordinary path"; T7c's measured run of a whole battle
   and this file's own `mov r0, #0x20` after `bl PauseBattle` put entries 8 and 9
   on it. Corrected in place. The same passage also shows two numbering
   conventions over one table — `TODO_ARCHIVE.md:774` (C2) counts ENTRIES,
   `TODO_ARCHIVE.md:3071` (T7c) counts STATES; entry N is state N*4.
2. `sub_8001C94`. Several ticket premises (F36b, F37i-l) call it a BG1 scroll
   seam handler on a 60-frame cadence and conflate it with
   `BGScrollCB_BG1Diagonal3to2Scroll`, a different routine 480 lines earlier.
   `TODO.md:407` (F36c) refutes both: it assembles per-element glyph tiles and
   queues one transfer of char-block art, and never touches the BG1 map. The
   name follows F36c.
3. `sub_801C6EE` carries three roles across the docs — HUD element 6 (chip name
   and damage), "the BG3 slide", and "the canon per-sprite palette source". The
   third is refuted by its own ticket's result (`TODO.md:355`, which redirects to
   `stageObjPalette_8002818`). The name follows the first, which is measured.
4. `sub_801641A`: F38d says the appearing state has "per-step y motion" here;
   F38e read the body and refutes it. The refutation is already a note in the file.
5. `sub_8112F70` / `sub_8112FBA`: `docs/coverage/gunner.md:47` and `src/gunner.rs`
   say aim cursor / cursor locked; `TODO_ARCHIVE.md:3410` (T9k, an unmerged
   NEGATIVE) says spawn projectile / buster cursor. Named after the first; the
   table comment keeps the sub-state index so either reading resolves.
6. `sub_800FE12`: `src/battle.rs:66` describes it as reading the AI data's version
   byte; the body reads that byte and then indexes a caller-supplied per-Version
   u16 table with it, special-casing Version 4. Named after the body.
7. `eStruct2035280+0x12`: T7d calls it a "post-window banner composite corrector",
   F33 measured it as the chip window's slide position and predicted -117980 px
   from that reading. Named after F33; both readings kept at the routine.
8. `sub_801483C`: `TODO_ARCHIVE.md:3071` (T7c) reads it as the gate the sequencer's
   settle state waits on and `src/battle.rs:2627` as "the slide-out idle";
   `docs/coverage/battlestart_gunner.md:40-42` records the surrounding narrative as
   REFUTED by T9c's verifier. Left unnamed.
9. `sub_800938A`: F5's premise says it "forces CurState back to idle when the
   banner sequencer returns 6"; F5's own result says the `cmp r0,#6` it hangs on
   "is irrelevant". Named for its FSM state (0x0C) instead, which both agree on.
10. `sub_80C7EC8`: one ticket (T7v) calls it an RNG-cadence mirror that ticks once
   per frame in its Why and a death-debris spawner in its Result. Named after the
   Result, which `docs/coverage/battle_full.md:1503` corroborates.
11. `dword_8617488` was named for the battle backdrop by both the bn docs and the
   port; this disassembly shows four overworld areas' warp animations use the same
   blob. Named `GFXAnimTileBlob_8617488` instead.

## Deliberately left unnamed

- `sub_801483C`, `sub_8112D9C`, `sub_800834A`'s role, `sub_8029110` — sources
  disagree or hedge (see above, and the per-section notes).
- `sub_80084F0` and `off_8008508` — a second dispatcher over the same sequencer
  state word; no source names its seven states. A comment now records the sharing.
- The shared CurAction helpers `sub_80165B8`, `sub_80165C2`, `sub_80166AE`,
  `sub_8016B02`, `sub_8016CE8`, `sub_8016B36`, `sub_8016B72` — several AIs' tables
  point at each, so the per-enemy roles the docs give them would be wrong on the
  symbol.
- `off_810C6F0` and the other 29 unnamed think tables — `docs/inventory/enemies.md`
  maps each to an AIIndex but not to an enemy.
- `sub_8016F56`, `sub_8016C4E`, `sub_81095D0`, `sub_801ABB8`, `sub_8003400`,
  `sub_80AA824`, `sub_80AA6A4`, `sub_8009C1C` and the rest of the bare
  cross-references — cited with no role stated anywhere. (`sub_8009C1C` in
  particular is attributed to ticket F11, whose own result never mentions it.)
- `byte_81130A8` / `byte_81130C6` — both cited as "the cursor's LOCK duration (24
  frames)"; nothing says which is which.
- `comp_825BFC4` — the Gunner's compressed sprite. Renaming it would mean renaming
  `data/sprites/comp_825BFC4.lz77` and its `.incbin`, which is a different change.
- `sub_800B8C2` — the note names it alongside the announcer-slot accessors, but its
  body compares byte 0, not the sync byte at byte 1, and no source says what for.
- The ~1,650 rows of `docs/coverage/battle_full.md` and `mettaur.md` that are pure
  hotness rankings. They carry file/line and call counts, which is useful for
  deciding what to read next, but no role.
