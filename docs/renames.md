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
