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
