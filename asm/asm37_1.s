
	thumb_func_start sub_814187C
sub_814187C:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	mov r0, r5
	add r0, #8
	mov r1, #0x10
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #0x50 
	strb r0, [r5,#0x10] // (dword_2001020 - 0x2001010)
	movflag EVENT_700
	bl SetEventFlagFromImmediate
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_814187C

	thumb_local_start
sub_814189A:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	bl sub_814187C
	bl sub_81418F0
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_814189A

	thumb_local_start
sub_81418AA:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	mov r0, #1
	strb r0, [r5,#0xd] // (dword_200101C+1 - 0x2001010)
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_81418AA

	thumb_local_start
sub_81418B6:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	mov r0, #0
	strb r0, [r5,#0xd] // (dword_200101C+1 - 0x2001010)
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_81418B6

	thumb_local_start
sub_81418C2:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	mov r0, #0
	strb r0, [r5,#0xe] // (dword_200101C+2 - 0x2001010)
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_81418C2

	thumb_local_start
sub_81418CE:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	mov r0, #1
	strb r0, [r5,#0xe] // (dword_200101C+2 - 0x2001010)
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_81418CE

// symdb: Writes a pair of bytes (likely x/y coordinates) into the beast-spread struct eStruct2001010 at offsets 0x14/0x15.
// symdb: (r0 = first byte, r1 = second byte) -> r0 = ?; no flags set
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/beast_setSpawnCoords.yaml
	thumb_local_start
beast_setSpawnCoords:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	strb r0, [r5,#0x14] // (dword_2001024 - 0x2001010)
	strb r1, [r5,#0x15] // (dword_2001024+1 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end beast_setSpawnCoords

// symdb: reads AIData.Version_15..Version_17 into r0..r2 from the EWRAM AIData struct
// symdb: () -> r0 = AIData.Unk_15, r1 = AIData.Version_16, r2 = AIData.Version_14 ; no side effects
// symdb: beyond register output
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getAIDataVersionFields_81418E4.yaml
	thumb_func_start battle_getAIDataVersionFields_81418E4
battle_getAIDataVersionFields_81418E4:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	ldrb r0, [r5,#0x16] // (dword_2001024+2 - 0x2001010)
	ldrb r1, [r5,#0x15] // (dword_2001024+1 - 0x2001010)
	ldrb r2, [r5,#0x14] // (dword_2001024 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end battle_getAIDataVersionFields_81418E4

	thumb_func_start sub_81418F0
sub_81418F0:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	mov r0, #0
	bl getSetFlagCount
	push {r0}
	mov r0, #1
	bl getSetFlagCount
	push {r0}
	mov r0, #2
	bl getSetFlagCount
	pop {r1,r2}
	add r0, r0, r1
	add r0, r0, r2
	strb r0, [r5,#0x16] // (dword_2001024+2 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end sub_81418F0

// symdb: Records a map-anchored trigger point (position offset by a per-index pair, size 12x8) into the eStruct2001010 slot, tagging it with the current map group/number.
// symdb: (r0 = base x, r1 = base y, r2 = param stored at +0x24, r3 = index into byte_8141958 offset
// symdb: table) -> r0 = 0 (clobbered); writes eStruct2001010+0x18..0x3B
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_setWarpTrigger.yaml
	thumb_local_start
ow_setWarpTrigger:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	ldr r4, off_8141954 // =byte_8141958 
	lsl r6, r3, #3
	add r4, r4, r6
	ldr r6, [r4]
	add r0, r0, r6
	ldr r6, [r4,#4]
	add r1, r1, r6
	str r0, [r5,#0x1c] // (dword_200102C - 0x2001010)
	str r1, [r5,#0x20] // (dword_2001030 - 0x2001010)
	str r2, [r5,#0x24] // (dword_2001034 - 0x2001010)
	strb r3, [r5,#0x1b] // (dword_2001028+3 - 0x2001010)
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	ldrb r0, [r7,#oGameState_MapGroup]
	strb r0, [r5,#0x18] // (dword_2001028 - 0x2001010)
	ldrb r0, [r7,#oGameState_MapNumber]
	strb r0, [r5,#0x19] // (dword_2001028+1 - 0x2001010)
	mov r0, #0
	strb r0, [r5,#0x1a] // (dword_2001028+2 - 0x2001010)
	add r5, #0x18
	mov r0, #0xc
	strb r0, [r5,#0x10] // (byte_2001038 - 0x2001028)
	mov r0, #8
	strb r0, [r5,#0x11] // (byte_2001039 - 0x2001028)
	mov r0, #0xff
	strb r0, [r5,#0x12] // (byte_200103A - 0x2001028)
	mov r0, #0xff
	strb r0, [r5,#0x13] // (byte_200103B - 0x2001028)
	pop {r4-r7,pc}
	.balign 4, 0
off_8141954:
	.word byte_8141958
	thumb_func_end ow_setWarpTrigger

byte_8141958:
	.word 0x00FF0000, 0x00FF0000, 0x00180000, 0x00000000, 0x00FF0000, 0x00FF0000, 0x00000000, 0x00180000
	.word 0x00FF0000, 0x00FF0000, 0xFFE80000, 0x00000000, 0x00FF0000, 0x00FF0000, 0x00000000, 0xFFE80000

// symdb: Getter returning the address of the field at offset 0x18 of the struct at 0x02001010 (eStruct2001010).
// symdb: () -> r0 = &eStruct2001010 + 0x18; no flags set meaningfully (does not affect caller logic).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_getField18Ptr.yaml
	thumb_local_start
e_getField18Ptr:
	push {r4-r7, lr}
	ldr r0, off_8141B14 // =eStruct2001010
	add r0, #0x18
	pop {r4-r7, pc}
	thumb_func_end e_getField18Ptr

// symdb: Beast-SP Battle AI per-frame dispatch (init sub-mode, run AI, conditionally run sub-routines) returning 0.
// symdb: (r10 = ToolkitPtr) -> r0 = 0 ; updates r4–r7/r8/r9/r12, calls many subsystems, may call
// symdb: chatbox_mask_eFlags2009F38
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_performBeastOutBattleAiTick_81419A0.yaml
	thumb_func_start battle_performBeastOutBattleAiTick_81419A0
battle_performBeastOutBattleAiTick_81419A0:
	push {r4-r7,lr}
	ldr r5, off_8141B14 // =eStruct2001010 
	bl pet_testIsMapGroupAllowed_8141AA8
	bne loc_8141A0C
	ldrb r0, [r5,#0x3] // (byte_2001013 - 0x2001010)
	tst r0, r0
	beq loc_81419CC
	mov r0, #0
	strb r0, [r5,#0x3] // (byte_2001013 - 0x2001010)
	bl sub_80468BA
	mov r0, #1
	mov r1, #0
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
	mov r0, #2
	mov r1, #1
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
loc_81419CC:
	bl battle_callAIDispatch_8046818
	bl battleObject_updateSpriteGfxForAll_8046854
	bl battle_gfx_renderLatticeOrSpinner_811E0BA
	bl IsCutsceneScriptNonNull // () -> !zf
	bne loc_8141A0C
	bl owPlayer_isBusyOrCutsceneActive_809E462
	bne loc_8141A0C
	bl IsScreenFadeActive // () -> zf
	beq loc_8141A0C
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_8141A0C
	mov r0, r10
	ldr r0, [r0,#oToolkit_GameStatePtr]
	ldrb r0, [r0,#oGameState_SubsystemIndex]
	cmp r0, #4
	bne loc_8141A0C
	bl battle_canBeastOut_8141AD2
	bne loc_8141A08
	bl battle_beastSpEvolveStep_8141A10
	b loc_8141A0C
loc_8141A08:
	bl battleObject_tickBeastOutActionCooldown_8141A70
loc_8141A0C:
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end battle_performBeastOutBattleAiTick_81419A0

// symdb: Per-frame Beast+ form-evolution trigger: watches a counter on the active battle object and calls StartCutscene to play one of the Beast+ evolution scenes (params 5/6/7) when the threshold is reached.
// symdb: (r5 = *BattleObject) -> void ; side effects: writes BattleObject fields, may call StartCutscene
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_beastSpEvolveStep_8141A10.yaml
	thumb_local_start
battle_beastSpEvolveStep_8141A10:
	push {r4-r7,lr}
	ldrb r0, [r5,#0xd]
	tst r0, r0
	bne locret_8141A6A
	mov r0, #2
	strb r0, [r5,#0xb]
	ldrb r0, [r5,#0xc]
	sub r0, #1
	strb r0, [r5,#0xc]
	bgt locret_8141A6A
	mov r0, #0
	strb r0, [r5,#0xc]
	ldrb r0, [r5,#0x10]
	tst r0, r0
	ble loc_8141A36
	sub r0, #1
	strb r0, [r5,#0x10]
	mov r0, #0x1e
	strb r0, [r5,#0xc]
loc_8141A36:
	ldrb r0, [r5,#0x10]
	cmp r0, #0x27 
	bne loc_8141A4A
	ldrb r0, [r5,#0x13]
	tst r0, r0
	bne locret_8141A6A
	mov r0, #1
	strb r0, [r5,#0x13]
	mov r1, #5
	b loc_8141A62
loc_8141A4A:
	cmp r0, #0x13
	bne loc_8141A5C
	ldrb r0, [r5,#0x17]
	tst r0, r0
	bne locret_8141A6A
	mov r0, #1
	strb r0, [r5,#0x17]
	mov r1, #6
	b loc_8141A62
loc_8141A5C:
	cmp r0, #0
	bne loc_8141ACA
	mov r1, #7
loc_8141A62:
	ldr r0, off_8141A6C // =byte_808A128 // CutsceneScript
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
	bne loc_8141ABC
locret_8141A6A:
	pop {r4-r7,pc}
	.balign 4, 0
off_8141A6C:
	.word byte_808A128 // CutsceneScript
	thumb_func_end battle_beastSpEvolveStep_8141A10

// symdb: Ticks and gates a BattleObject's "Beast Out" Power-Atk-charge state machine (cooldown/charge timer and rearm logic)
// symdb: (r5 = BattleObject*) -> (none returned; flags may_write); side effects on the object's fields
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_tickBeastOutActionCooldown_8141A70.yaml
	thumb_local_start
battleObject_tickBeastOutActionCooldown_8141A70:
	push {r4-r7,lr}
	ldrb r0, [r5,#0xd]
	tst r0, r0
	bne locret_8141AA6
	mov r0, #0
	strb r0, [r5,#0x13]
	strb r0, [r5,#0x17]
	mov r0, #0x1e
	strb r0, [r5,#0xc]
	ldrb r0, [r5,#0xb]
	sub r0, #1
	strb r0, [r5,#0xb]
	bgt locret_8141AA6
	ldrb r0, [r5,#0x11]
	sub r0, #1
	blt loc_8141A92
	strb r0, [r5,#0x11]
loc_8141A92:
	ldrb r0, [r5,#0x10]
	add r0, #1
	cmp r0, #0x50 
	bgt loc_8141AA2
	strb r0, [r5,#0x10]
	mov r0, #2
	strb r0, [r5,#0xb]
	b locret_8141AA6
loc_8141AA2:
	mov r0, #0
	strb r0, [r5,#0x11]
locret_8141AA6:
	pop {r4-r7,pc}
	thumb_func_end battleObject_tickBeastOutActionCooldown_8141A70

// symdb: Checks whether the current map group is in the PET-menu's allowed "beast-sp" map whitelist.
// symdb: () -> r0 = bool (0 = allowed, 1 = not allowed / flag set); flags Z set on success path
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/pet_testIsMapGroupAllowed_8141AA8.yaml
	thumb_local_start
pet_testIsMapGroupAllowed_8141AA8:
	push {r4-r7,lr}
	mov r0, #1
	bl TestPETMenuDataFlag
	bne loc_8141ACE
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	ldrh r7, [r7,#oGameState_MapGroup]
	mov r6, #0
	ldr r4, off_8141B04 // =byte_8141B08 
loc_8141ABC:
	ldrh r0, [r4,r6]
	tst r0, r0
	beq loc_8141ACE
	cmp r0, r7
	beq loc_8141ACA
	add r6, #2
	b loc_8141ABC
loc_8141ACA:
	mov r0, #0
	pop {r4-r7,pc}
loc_8141ACE:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end pet_testIsMapGroupAllowed_8141AA8

// symdb: Returns 0 when beast-out is allowed for the player's current location, 1 otherwise (used to gate the beast-out input handling)
// symdb: () -> r0 = bool (0 = beast-out permitted, 1 = not permitted) ; side effects: reads toolkit
// symdb: GameState->MapGroup and an AIData[0x11]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_canBeastOut_8141AD2.yaml
	thumb_local_start
battle_canBeastOut_8141AD2:
	push {r4-r7,lr}
	movflag EVENT_701
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_8141B00
	ldrb r0, [r5,#0x11]
	tst r0, r0
	bne loc_8141B00
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	ldrh r7, [r7,#oGameState_MapGroup]
	mov r6, #0
	ldr r4, off_8141B04 // =byte_8141B08 
loc_8141AEE:
	ldrh r0, [r4,r6]
	tst r0, r0
	beq loc_8141B00
	cmp r0, r7
	beq loc_8141AFC
	add r6, #2
	b loc_8141AEE
loc_8141AFC:
	mov r0, #0
	pop {r4-r7,pc}
loc_8141B00:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_8141B04:
	.word byte_8141B08
byte_8141B08:
	.byte 0x91, 0x0, 0x91, 0x1, 0x91, 0x2, 0x88, 0x3, 0x0, 0x0, 0x0, 0x0
off_8141B14:
	.word eStruct2001010
off_8141B18:
	.word off_8141B30
	.word off_8141C9C
	.word off_8141E1C
off_8141B24:
	.word byte_8141C84
	.word byte_8141E04
	.word byte_8141F64
off_8141B30:
	.word byte_8141B48
	.word byte_8141B90
	.word byte_8141BC8
	.word byte_8141C00
	.word byte_8141C48
	.word 0x0
byte_8141B48:
	.byte 0x14, 0xF8, 0xFE, 0xFA, 0xFF, 0x1, 0x0, 0x18, 0x1E, 0x0
	.byte 0x1, 0x14, 0x6, 0x4, 0x0, 0x1, 0x14, 0x6, 0x4, 0x8
	.byte 0x1E, 0x0, 0x2, 0x14, 0x6, 0x4, 0x8, 0x1E, 0x0, 0x2
	.byte 0x14, 0x6, 0x4, 0x8, 0x1E, 0x0, 0x1, 0x14, 0x6, 0x4
	.byte 0x8, 0x1E, 0x0, 0x1, 0x14, 0x6, 0x4, 0x8, 0x1E, 0x0
	.byte 0x2, 0x14, 0x6, 0x4, 0x8, 0x1E, 0x0, 0x2, 0x14, 0x6
	.byte 0x4, 0x8, 0x1E, 0x8, 0x1, 0x10, 0x87, 0x1B, 0x14, 0x8
	.byte 0x0, 0x0
byte_8141B90:
	.byte 0x14, 0xC6, 0xFF, 0x2D, 0x0, 0x1, 0x0, 0x18, 0x1E, 0x0, 0x1
	.byte 0x1E, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1E, 0x8, 0x4, 0x18
	.byte 0x1E, 0x0, 0x1, 0x1E, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1E
	.byte 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1E, 0x8, 0x4, 0x18, 0x1E
	.byte 0x0, 0x1, 0x1E, 0x8, 0x4
byte_8141BC1:
	.byte 0x8, 0x1, 0x10
	.word byte_8141BC1
byte_8141BC8:
	.byte 0x14, 0x28, 0x0, 0x14, 0x0, 0x2, 0x0, 0x18, 0x1E, 0x0, 0x1, 0x1E
	.byte 0x10, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1E, 0x10, 0x4, 0x18, 0x1E, 0x0
	.byte 0x1, 0x1E, 0x10, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E, 0x10, 0x4, 0x18
	.byte 0x1E, 0x0, 0x2, 0x1E, 0x10, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E, 0x10
	.byte 0x4
byte_8141BF9:
	.byte 0x8, 0x1, 0x10
	.word byte_8141BF9
byte_8141C00:
	.byte 0x14, 0xA6, 0xFF, 0xE8, 0x0, 0x2, 0x0, 0x18, 0x1E, 0x0, 0x1
	.byte 0x1E, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E, 0x8, 0x4, 0x18
	.byte 0x1E, 0x0, 0x1, 0x1E, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E
	.byte 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1E, 0x8, 0x4, 0x18, 0x1E
	.byte 0x0, 0x2, 0x1E, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1E, 0x8
	.byte 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E, 0x8, 0x4, 0x18, 0x1E
byte_8141C41:
	.byte 0x8, 0x1, 0x10
	.word byte_8141C41
byte_8141C48:
	.byte 0x14, 0xFA, 0xFE, 0xAC, 0x0, 0x1, 0x0, 0x18, 0x1E, 0x0, 0x1
	.byte 0x14, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x14, 0x8, 0x4, 0x18
	.byte 0x1E, 0x0, 0x2, 0x14, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x14
	.byte 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0xE6, 0x8, 0x4, 0x18, 0x1E
	.byte 0x0, 0x2, 0x14, 0x8, 0x4, 0x18, 0x1E, 0x8, 0x1, 0x10, 0x7B
	.byte 0x1C, 0x14, 0x8, 0x0, 0x0
byte_8141C84:
	.byte 0x5, 0xE, 0x0, 0x0, 0x0, 0x0, 0x4C, 0x0, 0x0, 0x0, 0xC4, 0xFE, 0x0, 0x0
	.byte 0x40, 0x0, 0x3, 0x0, 0x0, 0x0, 0xFF, 0x0, 0x0, 0x0
off_8141C9C:
	.word byte_8141CB4
	.word byte_8141CF0
	.word byte_8141D38
	.word byte_8141D80
	.word byte_8141DC8
	.word 0x0
byte_8141CB4:
	.byte 0x14, 0x8, 0x0, 0x2E, 0xFF, 0x1, 0x0, 0x18, 0x1E, 0x0, 0x1, 0x14
	.byte 0x6, 0x4, 0x8, 0x14, 0x0, 0x3, 0x14, 0x6, 0x4, 0x8, 0x14, 0x0
	.byte 0x1, 0x14, 0x6, 0x4, 0x8, 0x14, 0x0, 0x3, 0x14, 0x6, 0x4, 0x8
	.byte 0x14, 0x0, 0x1, 0x14, 0x6, 0x4, 0x8, 0x14, 0x0, 0x3, 0x14, 0x6
	.byte 0x4, 0x8, 0x14, 0x8, 0x1, 0x10, 0xE7, 0x1C, 0x14, 0x8, 0x0, 0x0
byte_8141CF0:
	.byte 0x14, 0x52, 0xFF, 0x44, 0x0, 0x1, 0x0, 0x18, 0x1E, 0x0, 0x1
	.byte 0x1E, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1E, 0x8, 0x4, 0x18
	.byte 0x1E, 0x0, 0x0, 0x1E, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x0, 0x1E
	.byte 0x8, 0x4, 0x18, 0x1E, 0x0, 0x3, 0x1E, 0x8, 0x4, 0x18, 0x1E
	.byte 0x0, 0x3, 0x1E, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E, 0x8
	.byte 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E, 0x8, 0x4, 0x18, 0x1E
byte_8141D31:
	.byte 0x8, 0x1, 0x10
	.word byte_8141D31
byte_8141D38:
	.byte 0x14, 0xFC, 0xFF, 0xE8, 0xFF, 0x1, 0x0, 0x18, 0x1E, 0x0
	.byte 0x1, 0x14, 0x6, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x14, 0x6
	.byte 0x4, 0x18, 0x1E, 0x0, 0x1, 0x14, 0x6, 0x4, 0x18, 0x1E
	.byte 0x0, 0x2, 0x14, 0x6, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x14
	.byte 0x6, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x14, 0x6, 0x4, 0x18
	.byte 0x1E, 0x0, 0x1, 0x14, 0x6, 0x4, 0x18, 0x1E, 0x0, 0x2
	.byte 0x14, 0x6, 0x4, 0x18, 0x1E
byte_8141D79:
	.byte 0x8, 0x1, 0x10
	.word byte_8141D79
byte_8141D80:
	.byte 0x14, 0x54, 0x1, 0x17, 0xFF, 0x1, 0x0, 0x18, 0x1E, 0x0, 0x1
	.byte 0x1A, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1A, 0x8, 0x4, 0x18
	.byte 0x1E, 0x0, 0x1, 0x1A, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1A
	.byte 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1A, 0x8, 0x4, 0x18, 0x1E
	.byte 0x0, 0x1, 0x1A, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1A, 0x8
	.byte 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1A, 0x8, 0x4, 0x18, 0x1E
byte_8141DC1:
	.byte 0x8, 0x1, 0x10
	.word byte_8141DC1
byte_8141DC8:
	.byte 0x14, 0xA8, 0x0, 0xC2, 0x0, 0x2, 0x0, 0x18, 0x1E, 0x0, 0x2, 0x1E
	.byte 0x10, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E, 0x10, 0x4, 0x18, 0x1E, 0x0
	.byte 0x1, 0x1E, 0x10, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1E, 0x10, 0x4, 0x18
	.byte 0x1E, 0x0, 0x2, 0x1E, 0x10, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E, 0x10
	.byte 0x4, 0x18, 0x1E, 0x8, 0x1, 0x10, 0xFB, 0x1D, 0x14, 0x8, 0x0, 0x0
byte_8141E04:
	.byte 0x5, 0xE, 0x0, 0x0, 0x0, 0x0, 0x86, 0x0, 0x0, 0x0, 0x88, 0xFE, 0x0, 0x0
	.byte 0x0, 0x0, 0x3, 0x0, 0x0, 0x0, 0xFF, 0x0, 0x0, 0x0
off_8141E1C:
	.word byte_8141E34
	.word byte_8141E7C
	.word byte_8141EC4
	.word byte_8141EF0
	.word byte_8141F1C
	.word 0x0
byte_8141E34:
	.byte 0x14, 0xE, 0x1, 0xE8, 0xFE, 0x2, 0x0, 0x18, 0x1E, 0x0, 0x2, 0x14
	.byte 0x6, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x14, 0x6, 0x4, 0x18, 0x1E, 0x0
	.byte 0x2, 0x14, 0x6, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x14, 0x6, 0x4, 0x18
	.byte 0x1E, 0x0, 0x2, 0x14, 0x6, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x14, 0x6
	.byte 0x4, 0x18, 0x1E, 0x0, 0x2, 0x14, 0x6, 0x4, 0x18, 0x1E, 0x0, 0x2
	.byte 0x14, 0x6, 0x4, 0x18, 0x1E
byte_8141E75:
	.byte 0x8, 0x1, 0x10
	.word byte_8141E75
byte_8141E7C:
	.byte 0x14, 0xDA, 0x0, 0xB4, 0xFF, 0x2, 0x0, 0x18, 0x1E, 0x0, 0x2
	.byte 0x1A, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1A, 0x8, 0x4, 0x18
	.byte 0x1E, 0x0, 0x2, 0x1A, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1A
	.byte 0x8, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1A, 0x8, 0x4, 0x18, 0x1E
	.byte 0x0, 0x1, 0x1A, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1A, 0x8
	.byte 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1A, 0x8, 0x4, 0x18, 0x1E
byte_8141EBD:
	.byte 0x8, 0x1, 0x10
	.word byte_8141EBD
byte_8141EC4:
	.byte 0x14, 0x9E, 0xFF, 0xE, 0x0, 0x3, 0x0, 0x18, 0x1E, 0x0, 0x3, 0x1E
	.byte 0x10, 0x4, 0x18, 0x1E, 0x0, 0x0, 0x1E, 0x10, 0x4, 0x18, 0x1E, 0x0
	.byte 0x3, 0x1E, 0x10, 0x4, 0x18, 0x1E, 0x0, 0x0, 0x1E, 0x10, 0x4, 0x18
	.byte 0x1E
byte_8141EE9:
	.byte 0x8, 0x1, 0x10
	.word byte_8141EE9
byte_8141EF0:
	.byte 0x14, 0xDC, 0xFE, 0xFE, 0xFF, 0x1, 0x0, 0x18, 0x1E, 0x0
	.byte 0x1, 0x1E, 0x8, 0x4, 0x18, 0x1E, 0x0, 0x2, 0x1E, 0x8
	.byte 0x4, 0x18, 0x1E, 0x0, 0x1, 0x1E, 0x8, 0x4, 0x18, 0x1E
	.byte 0x0, 0x2, 0x1E, 0x8, 0x4, 0x18, 0x1E
byte_8141F15:
	.byte 0x8, 0x1, 0x10
	.word byte_8141F15
byte_8141F1C:
	.byte 0x14, 0x6A, 0x0, 0xD2, 0xFF, 0x3, 0x0, 0x18, 0x1E, 0x0, 0x3
	.byte 0x14, 0x6, 0x4, 0x18, 0x1E, 0x0, 0x0, 0x1E, 0x6, 0x4, 0x18
	.byte 0x1E, 0x0, 0x3, 0x1E, 0x6, 0x4, 0x18, 0x1E, 0x0, 0x0, 0x1E
	.byte 0x6, 0x4, 0x18, 0x1E, 0x0, 0x3, 0x1E, 0x6, 0x4, 0x18, 0x1E
	.byte 0x0, 0x0, 0x1E, 0x6, 0x4, 0x18, 0x1E, 0x0, 0x3, 0x1E, 0x6
	.byte 0x4, 0x18, 0x1E, 0x0, 0x0, 0x1E, 0x6, 0x4, 0x18, 0x1E
byte_8141F5D:
	.byte 0x8, 0x1, 0x10
	.word byte_8141F5D
byte_8141F64:
	.byte 0x5, 0xE, 0x0, 0x0, 0x0, 0x0, 0xA0, 0x1, 0x0, 0x0, 0xEE, 0xFE, 0x0, 0x0
	.byte 0x0, 0x0, 0x3, 0x0, 0x0, 0x0, 0xFF, 0x0, 0x0, 0x0
	thumb_func_end battle_canBeastOut_8141AD2

// symdb: Looks up a per-MapGroup beast-spread config; if the matching flag set hasn't been processed yet (or coords don't match), zeros a battle object buffer, spawns a set of scriptable overworld map objects (MapGroup-indexed) flagged by per-slot story flags, optionally drives a "beast spread" cutscene, then locks the elevator/jack-out state and clears setup flags.
// symdb: (no args; uses r5 + r10 + lr from the caller) -> r0 = 0 or 0x10 (post-test Carry/non-carry
// symdb: result); side effects: clears/loads `unk_2000BE0` (0x140 bytes), clears flag 0x700/0x702, may
// symdb: start cutscene `byte_8089DF4` and call `gameState_setUnk09_8001172(0x54)`.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/beast_spawnObjectsAndSetup_8141F7C.yaml
	thumb_local_start
beast_spawnObjectsAndSetup_8141F7C:
	push {r4-r7,lr}
	mov r1, r10
	ldr r1, [r1,#0x3c]
	ldrb r2, [r1,#4]
	ldrb r3, [r1,#0xc]
	ldrb r0, [r1,#5]
	ldrb r1, [r1,#0xd]
	lsl r0, r0, #2
	lsl r1, r1, #2
	push {r0-r3}
	movflag EVENT_700
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	pop {r0-r3}
	bne loc_8141FA4
	cmp r2, r3
	bne loc_8141FA4
	cmp r0, r1
	beq loc_8141FB4
loc_8141FA4:
	push {r0-r7}
	ldr r0, off_8142130 // =unk_2000BE0 
	ldr r1, dword_8142038 // =0x140 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	bl sub_814189A
	pop {r0-r7}
loc_8141FB4:
	bl battle_getEnemyIndexFromMapGroup_8142080
	lsl r0, r0, #2
	ldr r7, off_8142034 // =off_8141B18 
	ldr r7, [r7,r0]
	mov r4, #0
loc_8141FC0:
	ldr r0, [r7]
	tst r0, r0
	beq loc_8141FE4
	mov r0, r4
	bl beast_getMapGroupIdBase
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8141FDE
	push {r4-r7}
	mov r0, #0xd
	bl SpawnOverworldMapObject
	pop {r4-r7}
loc_8141FDE:
	add r4, #1
	add r7, #4
	b loc_8141FC0
loc_8141FE4:
	bl battle_getEnemyIndexFromMapGroup_8142080
	ldr r1, off_8142040 // =dword_8142044 
	ldrb r0, [r1,r0]
	mov r1, #0xf
	bl beast_setSpawnCoords
	bl battle_getEnemyIndexFromMapGroup_8142080
	ldr r7, off_814203C // =off_8141B24 
	lsl r0, r0, #2
	ldr r0, [r7,r0]
	bl SpawnObjectsFromList // (data: *const MapObjectSpawnData) -> i32
	movflag EVENT_702
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_814201A
	ldr r0, off_8142048 // =byte_8089DF4 // CutsceneScript
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
	movflag EVENT_702
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
loc_814201A:
	bl owMapObject_isHoveringElevator_0809E3A2
	beq loc_814202A
	mov r0, #0x54 
	bl gameState_setUnk09_8001172
	bl reqBBS_setFlag_e17b0f7_8140A00
loc_814202A:
	movflag EVENT_700
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_8142034:
	.word off_8141B18
dword_8142038:
	.word 0x140
off_814203C:
	.word off_8141B24
off_8142040:
	.word dword_8142044
dword_8142044:
	.word 0xFF050505
off_8142048:
	.word byte_8089DF4 // CutsceneScript
	thumb_func_end beast_spawnObjectsAndSetup_8141F7C

	thumb_local_start
sub_814204C:
	push {r4-r7,lr}
	pop {r4-r7,pc}
	thumb_func_end sub_814204C

// symdb: Returns an AI data pointer for the given enemy slot using the toolkit/enemy-index lookup table.
// symdb: (r0 = enemyIndex) -> r0 = ptr (in r7, copied to r0 on exit); r10 = toolkit (preserved by callee-
// symdb: saved)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getAIDataForEnemyIndex_8142050.yaml
	thumb_func_start battle_getAIDataForEnemyIndex_8142050
battle_getAIDataForEnemyIndex_8142050:
	push {r4-r6,lr}
	lsl r4, r0, #2
	bl battle_getEnemyIndexFromMapGroup_8142080
	lsl r0, r0, #2
	ldr r7, off_8142064 // =off_8141B18 
	ldr r7, [r7,r0]
	ldr r7, [r7,r4]
	pop {r4-r6,pc}
	.balign 4, 0
off_8142064:
	.word off_8141B18
	thumb_func_end battle_getAIDataForEnemyIndex_8142050

// symdb: Returns a pointer to one of up to four AIData slots stored at unk_2000BE0, indexed by r0.
// symdb: (r0 = actor index 0..3) -> r0 = &unk_2000BE0 + r0 * 0x28 ; no side effects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getAIDataPtr_8142068.yaml
	thumb_func_start battle_getAIDataPtr_8142068
battle_getAIDataPtr_8142068:
	ldr r6, off_8142130 // =unk_2000BE0 
	mov r1, #0x28 
	mul r0, r1
	add r6, r6, r0
	mov pc, lr
	thumb_func_end battle_getAIDataPtr_8142068

// symdb: Resets the Cybeast spread-attack spawn coordinates in eStruct2001010 to a default/off-screen pair (0, 15).
// symdb: (no args used) -> r0 = 0; flags clobbered by bl
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/beast_clearSpawnCoords.yaml
	thumb_local_start
beast_clearSpawnCoords:
	push {r4-r7,lr}
	mov r0, #0
	mov r1, #0xf
	bl beast_setSpawnCoords
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end beast_clearSpawnCoords

// symdb: Looks up an index in a small 3-entry table (byte_81420A8) by matching against the current MapGroup, returning the table index or 0xff.
// symdb: (r10 = ToolkitPtr, lr = return) -> r0 = index (0..n) or 0xff if no match/empty entry
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getEnemyIndexFromMapGroup_8142080.yaml
	thumb_func_start battle_getEnemyIndexFromMapGroup_8142080
battle_getEnemyIndexFromMapGroup_8142080:
	push {r4-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	ldrh r7, [r7,#oGameState_MapGroup]
	mov r6, #0
	ldr r4, off_81420A4 // =byte_81420A8 
loc_814208C:
	ldrh r0, [r4,r6]
	tst r0, r0
	beq loc_81420A0
	cmp r0, r7
	beq loc_814209A
	add r6, #2
	b loc_814208C
loc_814209A:
	lsr r0, r6, #1
	tst r0, r0
	pop {r4-r7,pc}
loc_81420A0:
	mov r0, #0xff
	pop {r4-r7,pc}
	.balign 4, 0
off_81420A4:
	.word byte_81420A8
byte_81420A8:
	.byte 0x91, 0x0, 0x91, 0x1, 0x91, 0x2, 0x0, 0x0
	thumb_func_end battle_getEnemyIndexFromMapGroup_8142080

	thumb_func_start sub_81420B0
sub_81420B0:
	push {r4-r7,lr}
	bl battle_getEnemyIndexFromMapGroup_8142080
	ldr r1, off_81420C0 // =dword_81420C4 
	ldrb r0, [r1,r0]
	lsl r0, r0, #0x10
	pop {r4-r7,pc}
	.balign 4, 0
off_81420C0:
	.word dword_81420C4
dword_81420C4:
	.word 0x404080
	thumb_func_end sub_81420B0

// symdb: Given a group index into byte_8142120, returns how many of its contiguous event flags (base..base+count) are currently set, by tallying TestEventFlag results.
// symdb: (r0 = index into flag-group table at byte_8142120) -> r0 = number of set flags in that group;
// symdb: flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getSetFlagCount.yaml
	thumb_func_start getSetFlagCount
getSetFlagCount:
	push {r4-r7,lr}
	ldr r7, off_814211C // =byte_8142120 
	lsl r0, r0, #2
	add r7, r7, r0
	mov r4, #0
	mov r6, #0
loc_81420D4:
	ldrh r0, [r7,#2]
	cmp r4, r0
	bge loc_81420EC
	ldrh r0, [r7]
	add r0, r0, r4
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_81420E8
	add r6, #1
loc_81420E8:
	add r4, #1
	b loc_81420D4
loc_81420EC:
	mov r0, r6
	pop {r4-r7,pc}
	thumb_func_end getSetFlagCount

// symdb: Returns a per-MapGroup base value from a small table plus the caller's local index, used by the beast-spread object setup to build flag/object IDs for the current map group.
// symdb: (r0 = local index/id to offset) -> r0 = tableBase[currentMapGroup] + r0; flags clobbered by call
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/beast_getMapGroupIdBase.yaml
	thumb_func_start beast_getMapGroupIdBase
beast_getMapGroupIdBase:
	push {r4-r7,lr}
	mov r4, r0
	bl battle_getEnemyIndexFromMapGroup_8142080
	ldr r1, off_814211C // =byte_8142120 
	lsl r0, r0, #2
	ldrh r0, [r1,r0]
	add r0, r0, r4
	pop {r4-r7,pc}
	thumb_func_end beast_getMapGroupIdBase

	thumb_local_start
sub_8142102:
	push {r4-r7,lr}
	bl battle_getEnemyIndexFromMapGroup_8142080
	ldr r1, off_814211C // =byte_8142120 
	lsl r0, r0, #2
	add r1, r1, r0
	ldrh r0, [r1]
	ldrh r1, [r1,#2]
	mov r0, r0
	mov r2, r1
	bl ClearEventFlagRange // (u16 entryFlagBitfield) -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_814211C:
	.word byte_8142120
byte_8142120:
	.byte 0x10, 0x7, 0x5, 0x0, 0x20, 0x7, 0x5, 0x0, 0x30, 0x7, 0x5, 0x0, 0x0, 0x0
	.byte 0x0, 0x0
off_8142130:
	.word unk_2000BE0
	thumb_func_end sub_8142102

// symdb: Resets the scenario-effect state block at 0x2000780 and sets story flag EVENT_740, returning 0.
// symdb: () -> r0 = 0; zeroes 0x40 bytes at eScenarioEffectState2000780+8, sets event flag 740
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/clearScenarioEffectState.yaml
	thumb_func_start clearScenarioEffectState
clearScenarioEffectState:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	mov r0, r5
	add r0, #8
	mov r1, #0x40 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	movflag EVENT_740
	bl SetEventFlagFromImmediate
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end clearScenarioEffectState

// symdb: Clears the active/enable byte (offset 0xD) of the scenario effect state at 0x2000780 and returns 0.
// symdb: () -> r0 = 0; no flags meaningful (values pushed/popped, clobbered by strb use of r0 only)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_disableScenarioEffect.yaml
	thumb_local_start
e_disableScenarioEffect:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	mov r0, #0
	strb r0, [r5,#0xd] // (byte_200078D - 0x2000780)
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end e_disableScenarioEffect

	thumb_local_start
sub_814215A:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	mov r0, #1
	strb r0, [r5,#0xd] // (byte_200078D - 0x2000780)
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_814215A

// symdb: Writes a one-byte value (likely a cutscene/scenario effect parameter) into the global scenario effect state, as part of Beast Out / Soul Unleash application.
// symdb: (r0 = byte value to store) -> r0 = destroyed; no flags meaningful
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/scenario_setEffectState0E.yaml
	thumb_local_start
scenario_setEffectState0E:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	strb r0, [r5,#0xe] // (byte_200078E - 0x2000780)
	pop {r4-r7,pc}
	thumb_func_end scenario_setEffectState0E

// symdb: returns true (r0=1 -> 7) while the per-battle scenario-effect state at eScenarioEffectState2000780+0xE is non-zero, serving as a guard for the scenario-effect handlers
// symdb: () -> r0 = 1 if scenario-effect state+0xE != 0 else 0 ; sets NZ, clobbers r4, restores lr via
// symdb: tail-call
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleScenarioEffect_isActive_814216E.yaml
	thumb_func_start battleScenarioEffect_isActive_814216E
battleScenarioEffect_isActive_814216E:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	ldrb r0, [r5,#0xe] // (byte_200078E - 0x2000780)
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end battleScenarioEffect_isActive_814216E

	thumb_local_start
sub_8142178:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	ldrb r0, [r5,#0xe] // (byte_200078E - 0x2000780)
	add r0, #1
	strb r0, [r5,#0xe] // (byte_200078E - 0x2000780)
	pop {r4-r7,pc}
	thumb_func_end sub_8142178

// symdb: Decrements by one the counter byte at offset 0x0E of the scenario-effect state structure when an overworld event finishes.
// symdb: (no args used) -> r0 = decremented value; no flags returned (popped with pc)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_scenarioEffectDecrementCounter.yaml
	thumb_func_start e_scenarioEffectDecrementCounter
e_scenarioEffectDecrementCounter:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	ldrb r0, [r5,#0xe] // (byte_200078E - 0x2000780)
	sub r0, #1
	strb r0, [r5,#0xe] // (byte_200078E - 0x2000780)
	pop {r4-r7,pc}
	thumb_func_end e_scenarioEffectDecrementCounter

// symdb: Returns whether a given scenario effect slot is currently active.
// symdb: (r0 = slot index 0..N) -> r0 = non-zero if the slot is active, zero otherwise ; sets nz/cv via
// symdb: tst; no other side effects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_checkScenarioEffectActive_8142190.yaml
	thumb_func_start battle_checkScenarioEffectActive_8142190
battle_checkScenarioEffectActive_8142190:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	add r0, #0x10
	ldrb r0, [r5,r0]
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end battle_checkScenarioEffectActive_8142190

// symdb: Returns nonzero (Z flag cleared) if any of the four state bytes at eScenarioEffectState+0x10..0x13 is set, else zero.
// symdb: () -> r0 = sum of bytes [0x10..0x13] of eScenarioEffectState2000780; Z set iff all four are 0
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_scenarioEffectStateCountersAnySet.yaml
	thumb_func_start e_scenarioEffectStateCountersAnySet
e_scenarioEffectStateCountersAnySet:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	ldrb r0, [r5,#0x10] // (dword_2000790 - 0x2000780)
	ldrb r1, [r5,#0x11] // (dword_2000790+1 - 0x2000780)
	add r0, r0, r1
	ldrb r1, [r5,#0x12] // (dword_2000790+2 - 0x2000780)
	add r0, r0, r1
	ldrb r1, [r5,#0x13] // (dword_2000790+3 - 0x2000780)
	add r0, r0, r1
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end e_scenarioEffectStateCountersAnySet

	thumb_func_start sub_81421B2
sub_81421B2:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	mov r1, r0
	add r1, #0x10
	ldrb r0, [r5,r1]
	sub r2, r0, #1
	blt loc_81421C4
	strb r2, [r5,r1]
	mov r0, r2
loc_81421C4:
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_81421B2

// symdb: Setter that stores a one-byte value into field 0xB of the scenario effect state struct at 0x2000780.
// symdb: (r0 = byte value) -> r0 = unchanged (caller-saved only); no flags used
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_setScenarioEffectStateB.yaml
	thumb_func_start e_setScenarioEffectStateB
e_setScenarioEffectStateB:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	strb r0, [r5,#0xb] // (byte_200078B - 0x2000780)
	pop {r4-r7,pc}
	thumb_func_end e_setScenarioEffectStateB

// symdb: Returns the byte at offset 0xB of the scenario/effect state (eScenarioEffectState2000780).
// symdb: () -> r0 = byte at state + 0xB ; no side effects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getScenarioEffectStateField_81421D0.yaml
	thumb_func_start battle_getScenarioEffectStateField_81421D0
battle_getScenarioEffectStateField_81421D0:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	ldrb r0, [r5,#0xb] // (byte_200078B - 0x2000780)
	pop {r4-r7,pc}
	thumb_func_end battle_getScenarioEffectStateField_81421D0

// symdb: Returns the address of a sub-struct inside the scenario/effect global state (base 0x02000780 + 0x18).
// symdb: () -> r0 = 0x02000798 ; no other writes (callee-saved r4-r7/lr preserved)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_scenarioEffectStateAddr_81421D8.yaml
	thumb_func_start battleObject_scenarioEffectStateAddr_81421D8
battleObject_scenarioEffectStateAddr_81421D8:
	push {r4-r7,lr}
	ldr r0, off_8142308 // =eScenarioEffectState2000780 
	add r0, #0x18
	pop {r4-r7,pc}
	thumb_func_end battleObject_scenarioEffectStateAddr_81421D8

	thumb_func_start getField0x18OfScenarioEffectState2000780_81421e0
getField0x18OfScenarioEffectState2000780_81421e0:
	push {r4-r7,lr}
	ldr r0, off_8142308 // =eScenarioEffectState2000780 
	ldr r0, [r0,#0x18] // (byte_2000798 - 0x2000780)
	pop {r4-r7,pc}
	thumb_func_end getField0x18OfScenarioEffectState2000780_81421e0

	thumb_local_start
sub_81421E8:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	mov r4, #0
loc_81421EE:
	ldr r1, [r5,#0x18]
	tst r1, r1
	beq loc_81421FE
	cmp r0, r1
	beq loc_81421FC
	add r5, #4
	b loc_81421EE
loc_81421FC:
	mov r4, #1
loc_81421FE:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_81421E8

	thumb_func_start sub_8142204
sub_8142204:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	ldr r1, [r5,#0x28] // (byte_20007A8 - 0x2000780)
	add r2, r1, #1
	str r2, [r5,#0x28] // (byte_20007A8 - 0x2000780)
	lsl r1, r1, #2
	add r1, #0x2c 
	ldr r2, off_814221C // =dword_8142220 
	ldrb r0, [r2,r0]
	str r0, [r5,r1]
	pop {r4-r7,pc}
	.balign 4, 0
off_814221C:
	.word dword_8142220
dword_8142220:
	.word 0x1E140A00
	thumb_func_end sub_8142204

// symdb: Pops the most recent entry off the scenario-effect state's LIFO stack (0-based count at +0x28, entries at +0x2C), returning it, or 0 if the stack is empty.
// symdb: () -> r0 = popped entry (0 if empty); flags from tst on r0 (Z set when empty)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_popScenarioEffectEntry.yaml
	thumb_func_start e_popScenarioEffectEntry
e_popScenarioEffectEntry:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	mov r6, #0
	ldr r4, [r5,#0x28] // (byte_20007A8 - 0x2000780)
	sub r4, #1
	blt loc_8142238
	str r4, [r5,#0x28] // (byte_20007A8 - 0x2000780)
	lsl r4, r4, #2
	add r4, #0x2c 
	ldr r6, [r5,r4]
loc_8142238:
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end e_popScenarioEffectEntry

// symdb: Clears a flag/counter field (offset 0x28) of the scenario effect state struct at 0x2000780.
// symdb: () -> r0 = 0 (clobbered); writes 0 to byte_20007A8 (eScenarioEffectState2000780 + 0x28); no
// symdb: flags of use
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_clearScenarioEffectStateFlag.yaml
	thumb_func_start e_clearScenarioEffectStateFlag
e_clearScenarioEffectStateFlag:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	mov r0, #0
	str r0, [r5,#0x28] // (byte_20007A8 - 0x2000780)
	pop {r4-r7,pc}
	thumb_func_end e_clearScenarioEffectStateFlag

// symdb: Per-frame battle object update: clears a one-shot scenario flag, dispatches AI, and refreshes sprites.
// symdb: () -> r0 = 0 (always returns 0)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_perFrameUpdate_8142248.yaml
	thumb_func_start battleObject_perFrameUpdate_8142248
battleObject_perFrameUpdate_8142248:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	bl battle_getBeastOutAvailability_81422BE
	bne loc_8142272
	ldrb r0, [r5,#0x3] // (byte_2000783 - 0x2000780)
	tst r0, r0
	beq loc_814226A
	mov r0, #0
	strb r0, [r5,#0x3] // (byte_2000783 - 0x2000780)
	bl sub_80468BA
	mov r0, #3
	mov r1, #0
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
loc_814226A:
	bl battle_callAIDispatch_8046818
	bl battleObject_updateSpriteGfxForAll_8046854
loc_8142272:
	bl battleObject_emptyStub_8142C90
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end battleObject_perFrameUpdate_8142248

	thumb_func_start sub_814227A
sub_814227A:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	bl GetSoulWeaponsMapIndex
	ldr r1, off_8142290 // =byte_8142294 
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	str r0, [r5,#0x10] // (dword_2000790 - 0x2000780)
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_8142290:
	.word byte_8142294
byte_8142294:
	.byte 0x2, 0x2, 0x1, 0x1, 0x2, 0x2, 0x4, 0x1, 0x3, 0x4, 0x4, 0x2, 0x4, 0x4, 0x3, 0x3, 0x3
	.byte 0x3, 0x3, 0x3, 0x3, 0x5, 0x4, 0x3, 0x4, 0x6, 0x4, 0x6, 0x3, 0x4, 0x5, 0x3
	thumb_func_end sub_814227A

// symdb: Zeroes the dword at offset 0x10 of the scenario-effect state struct, resetting one scenario effect value.
// symdb: () -> r0 = 0; writes 0 to eScenarioEffectState2000780+0x10
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_clearScenarioEffectValue.yaml
	thumb_func_start e_clearScenarioEffectValue
e_clearScenarioEffectValue:
	push {r4-r7,lr}
	ldr r5, off_8142308 // =eScenarioEffectState2000780 
	mov r0, #0
	str r0, [r5,#0x10] // (dword_2000790 - 0x2000780)
	pop {r4-r7,pc}
	thumb_func_end e_clearScenarioEffectValue

// symdb: Returns 0 only when the current soul-weapon beast is unlocked and its required event flags are set; otherwise 1.
// symdb: () -> r0 = bool (0 = beast available, 1 = unavailable) ; side effects: clobbers r0-r3,r4-r7
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getBeastOutAvailability_81422BE.yaml
	thumb_local_start
battle_getBeastOutAvailability_81422BE:
	push {r4-r7,lr}
	mov r0, #1
	bl TestPETMenuDataFlag
	bne loc_81422F0
	bl GetSoulWeaponsMapIndex
	mov r4, r0
	cmp r4, #0xff
	beq loc_81422F0
	bl battle_getSoulWeaponBase_81427CE
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_81422F0
	ldr r1, off_81422F4 // =byte_81422F8 
	lsl r4, r4, #1
	ldrh r0, [r1,r4]
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_81422F0
	mov r0, #0
	pop {r4-r7,pc}
loc_81422F0:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_81422F4:
	.word byte_81422F8
byte_81422F8:
	.byte 0x86, 0x6, 0x87, 0x6, 0x88, 0x6, 0x89, 0x6, 0x8A, 0x6, 0x8B
	.byte 0x6, 0x8C, 0x6, 0x8D, 0x6
off_8142308:
	.word eScenarioEffectState2000780
off_814230C:
	.word byte_814232C
	.word byte_814234C
	.word byte_814237C
	.word byte_81423B0
	.word byte_81423E8
	.word byte_8142424
	.word byte_8142468
	.word byte_81424BC
byte_814232C:
	.byte 0x79, 0x83, 0x2, 0x1, 0x81, 0x7E, 0x1, 0x2, 0x82, 0x7E, 0x2
	.byte 0x1, 0x88, 0x81, 0x2, 0x1, 0x89, 0x81, 0x1, 0x2, 0x89, 0x80
	.byte 0x0, 0x1, 0x89, 0x7F, 0x0, 0x2, 0x0, 0x0, 0xFF, 0xFF
byte_814234C:
	.byte 0x7C, 0x86, 0x2, 0x1, 0x7D, 0x86, 0x1, 0x2, 0x7D, 0x87, 0x2
	.byte 0x1, 0x7E, 0x86, 0x3, 0x1, 0x83, 0x7F, 0x1, 0x1, 0x84, 0x7F
	.byte 0x1, 0x2, 0x85, 0x7F, 0x1, 0x1, 0x83, 0x78, 0x0, 0x1, 0x83
	.byte 0x77, 0x0, 0x2, 0x84, 0x77, 0x1, 0x2, 0x84, 0x76, 0x1, 0x1
	.byte 0x0, 0x0, 0xFF, 0xFF
byte_814237C:
	.byte 0x7D, 0x84, 0x1, 0x1, 0x7E, 0x84, 0x1, 0x3, 0x7E, 0x83, 0x1
	.byte 0x1, 0x82, 0x84, 0x1, 0x2, 0x83, 0x84, 0x2, 0x2, 0x82, 0x83
	.byte 0x1, 0x1, 0x82, 0x81, 0x3, 0x2, 0x83, 0x81, 0x0, 0x2, 0x83
	.byte 0x80, 0x0, 0x1, 0x7F, 0x7C, 0x3, 0x2, 0x80, 0x7C, 0x3, 0x1
	.byte 0x81, 0x7C, 0x2, 0x3, 0x0, 0x0, 0xFF, 0xFF
byte_81423B0:
	.byte 0x7B, 0x81, 0x0, 0x3, 0x7C, 0x81, 0x1, 0x2, 0x7C, 0x80, 0x0
	.byte 0x2, 0x7C, 0x7F, 0x0, 0x1, 0x81, 0x7E, 0x2, 0x2, 0x84, 0x7E
	.byte 0x1, 0x1, 0x86, 0x86, 0x2, 0x2, 0x86, 0x85, 0x2, 0x3, 0x86
	.byte 0x84, 0x2, 0x2, 0x87, 0x85, 0x2, 0x2, 0x87, 0x84, 0x3, 0x2
	.byte 0x75, 0x8C, 0x3, 0x2, 0x77, 0x8C, 0x2, 0x2, 0x0, 0x0, 0xFF
	.byte 0xFF
byte_81423E8:
	.byte 0x79, 0x89, 0x0, 0x3, 0x7A, 0x89, 0x1, 0x2, 0x7B, 0x89, 0x0
	.byte 0x1, 0x88, 0x81, 0x1, 0x2, 0x88, 0x80, 0x1, 0x2, 0x88, 0x7F
	.byte 0x3, 0x2, 0x88, 0x7E, 0x3, 0x1, 0x8A, 0x7F, 0x3, 0x1, 0x85
	.byte 0x75, 0x3, 0x2, 0x84, 0x75, 0x3, 0x3, 0x83, 0x75, 0x2, 0x2
	.byte 0x83, 0x76, 0x2, 0x1, 0x7C, 0x7D, 0x2, 0x3, 0x7B, 0x7D, 0x2
	.byte 0x3, 0x0, 0x0, 0xFF, 0xFF
byte_8142424:
	.byte 0x76, 0x85, 0x2, 0x1, 0x77, 0x85, 0x1, 0x2, 0x75, 0x84, 0x1
	.byte 0x1, 0x76, 0x84, 0x1, 0x2, 0x77, 0x84, 0x3, 0x3, 0x78, 0x84
	.byte 0x1, 0x1, 0x76, 0x83, 0x1, 0x1, 0x77, 0x83, 0x1, 0x1, 0x8B
	.byte 0x79, 0x3, 0x3, 0x8B, 0x78, 0x3, 0x3, 0x8B, 0x77, 0x2, 0x2
	.byte 0x8B, 0x76, 0x0, 0x1, 0x8D, 0x78, 0x0, 0x3, 0x8C, 0x78, 0x0
	.byte 0x3, 0x84, 0x72, 0x0, 0x3, 0x82, 0x72, 0x1, 0x2, 0x0, 0x0
	.byte 0xFF, 0xFF
byte_8142468:
	.byte 0x82, 0x86, 0x2, 0x3, 0x82, 0x88, 0x2, 0x3, 0x83, 0x87, 0x2
	.byte 0x3, 0x84, 0x87, 0x0, 0x2, 0x87, 0x81, 0x2, 0x1, 0x88, 0x81
	.byte 0x1, 0x2, 0x89, 0x81, 0x1, 0x2, 0x87, 0x80, 0x2, 0x1, 0x89
	.byte 0x80, 0x3, 0x2, 0x87, 0x7F, 0x2, 0x3, 0x88, 0x7F, 0x1, 0x1
	.byte 0x89, 0x7F, 0x3, 0x3, 0x7D, 0x84, 0x1, 0x2, 0x7D, 0x83, 0x3
	.byte 0x3, 0x7D, 0x82, 0x3, 0x3, 0x7D, 0x81, 0x1, 0x3, 0x7D, 0x7B
	.byte 0x2, 0x3, 0x77, 0x82, 0x1, 0x1, 0x75, 0x83, 0x0, 0x1, 0x75
	.byte 0x82, 0x2, 0x3, 0x0, 0x0, 0xFF, 0xFF
byte_81424BC:
	.byte 0x8B, 0x81, 0x1, 0x1, 0x8A, 0x81, 0x1, 0x1, 0x89, 0x81, 0x0
	.byte 0x3, 0x84, 0x83, 0x1, 0x1, 0x83, 0x83, 0x1, 0x2, 0x82, 0x83
	.byte 0x3, 0x3, 0x83, 0x82, 0x3, 0x3, 0x83, 0x81, 0x3, 0x2, 0x85
	.byte 0x7E, 0x0, 0x3, 0x7E, 0x85, 0x0, 0x3, 0x7D, 0x85, 0x3, 0x2
	.byte 0x7E, 0x84, 0x0, 0x2, 0x7E, 0x81, 0x0, 0x1, 0x7D, 0x81, 0x1
	.byte 0x2, 0x7D, 0x80, 0x1, 0x1, 0x7D, 0x7D, 0x2, 0x1, 0x7D, 0x7C
	.byte 0x1, 0x3, 0x7E, 0x7B, 0x3, 0x3, 0x7D, 0x7B, 0x1, 0x1, 0x7C
	.byte 0x7B, 0x1, 0x2, 0x0, 0x0, 0xFF, 0xFF
	thumb_func_end battle_getBeastOutAvailability_81422BE

// symdb: Applies the SoulWeapons (Beast Out / Soul Unleash) map state: clears per-weapon flags, spawns overworld objects, drives the BBS request flag and value, and starts the matching cutscene.
// symdb: (no args — uses r10 = Toolkit) -> void ; side effects: many event flags cleared/set, one OW map
// symdb: object spawned per unacquired slot, BBS flag e17b0f7 set, AIData.Unk_15 set from a per-map
// symdb: table, and possibly StartCutscene(byte_8089448, 0)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/soulWeapons_apply_8142510.yaml
	thumb_local_start
soulWeapons_apply_8142510:
	push {r4-r7,lr}
	movflag EVENT_1650
	mov r2, #0x18
	bl SetEventFlagRangeFromImmediate // (u8 entryIdx, u8 byteFlagIdx, int numEntries) -> void
	bl battle_getSoulWeaponBase_81427CE
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq locret_81425FC
	bl getSoulWeaponsMapParam
	mov r6, #1
	movflag EVENT_740
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_814253E
	mov r6, #0
	bl clearSoulWeaponsMapState
loc_814253E:
	mov r0, #0
	bl scenario_setEffectState0E
	bl GetSoulWeaponsMapIndex
	ldr r7, off_8142600 // =off_814230C 
	lsl r0, r0, #2
	ldr r7, [r7,r0]
	ldr r5, off_81428D0 // =byte_2006670 
	mov r4, #0
loc_8142552:
	ldrh r0, [r7]
	tst r0, r0
	beq loc_8142594
	tst r6, r6
	bne loc_8142566
	strh r0, [r5,#4]
	ldrb r0, [r7,#3]
	strb r0, [r5,#2]
	ldrb r0, [r7,#2]
	strb r0, [r5,#3]
loc_8142566:
	mov r0, r4
	bl soulWeapons_getFormDataOffset
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_814258C
	push {r4-r7}
	mov r0, #0xf
	bl SpawnOverworldMapObject
	pop {r4-r7}
	bl sub_8142178
	ldr r0, dword_8142604 // =0x1650 
	add r0, r0, r4
	mov r0, r0
	bl ClearEventFlag // (u16 entryFlagBitfield) -> void
loc_814258C:
	add r4, #1
	add r5, #8
	add r7, #4
	b loc_8142552
loc_8142594:
	bl reqBBS_setFlag_e17b0f7_8140A00
	mov r0, #0x21 
	bl ow_setMapMusic
	movflag EVENT_28
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_81425B4
	bl GetSoulWeaponsMapIndex
	cmp r0, #6
	bge loc_81425B4
	bl loc_80353EA
loc_81425B4:
	bl GetSoulWeaponsMapIndex
	ldr r1, off_814260C // =byte_8142610 
	ldrb r1, [r1,r0]
	mov r0, r10
	ldr r0, [r0,#0x3c]
	strb r1, [r0,#0x15]
	movflag EVENT_744
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_81425D4
	ldr r0, off_8142608 // =byte_8089448 // CutsceneScript
	mov r1, #0                                                                                                        
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()                                                                                                        
loc_81425D4:
	movflag EVENT_740
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_742
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_743
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_746
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_747
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
locret_81425FC:
	pop {r4-r7,pc}
	.byte 0x0, 0x0
	.balign 4, 0
off_8142600:
	.word off_814230C
dword_8142604:
	.word 0x1650
off_8142608:
	.word byte_8089448 // CutsceneScript
off_814260C:
	.word byte_8142610
byte_8142610:
	.byte 0x2D, 0x2D, 0x2D, 0x3C, 0x3C, 0x3C, 0x96, 0x96
	thumb_func_end soulWeapons_apply_8142510

// symdb: Overworld per-frame cutscene dispatcher: checks soul-weapon / beast / cross-progress event flags and fires the matching cutscene scripts, clearing them once handled.
// symdb: (in r10 = *Toolkit, lr = return) -> no caller-visible result; side effects = sets/clears
// symdb: EVENT_742/743/746/747 and may StartCutscene with one of three scripts
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/cutscene_dispatchEventFlags_8142618.yaml
	thumb_local_start
cutscene_dispatchEventFlags_8142618:
	push {r4-r7,lr}
	bl check_playerCanAdvanceForward_8034C36
	beq loc_814266C
	bl battle_getSoulWeaponBase_81427CE
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_814266C
	movflag EVENT_742
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_814264A
	mov r3, r10
	ldr r3, [r3,#0x3c]
	ldrb r0, [r3,#0x11]
	tst r0, r0
	beq loc_814267C
	movflag EVENT_742
	bl SetEventFlagFromImmediate
	b loc_814267C
loc_814264A:
	movflag EVENT_743
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_814265E
	movflag EVENT_743
	bl SetEventFlagFromImmediate
	b loc_814267C
loc_814265E:
	bl sub_80357AE
	bne loc_814266C
	ldr r0, off_81426B8 // =byte_8089554 // CutsceneScript
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
loc_814266C:
	movflag EVENT_742
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_743
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
loc_814267C:
	movflag EVENT_746
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_8142690

	ldr r0, off_81426BC // =byte_80893CC // CutsceneScript
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()

	beq loc_8142690
loc_8142690:
	movflag EVENT_747
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_81426A4
	ldr r0, off_81426C0 // =dword_8089128 // CutsceneScript
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
	beq loc_81426A4
loc_81426A4:
	movflag EVENT_746
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_747
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	pop {r4-r7,pc}
	.byte 0x0, 0x0
	.balign 4, 0
off_81426B8:
	.word byte_8089554 // CutsceneScript
off_81426BC:
	.word byte_80893CC // CutsceneScript
off_81426C0:
	.word dword_8089128 // CutsceneScript
	.byte 0x82, 0x4E, 0x8, 0x21, 0x48, 0x43, 0x36, 0x18
	thumb_func_end cutscene_dispatchEventFlags_8142618

	thumb_local_start
nullsub_37:
	mov pc, lr
	thumb_func_end nullsub_37

	thumb_func_start GetSoulWeaponsMapIndex
GetSoulWeaponsMapIndex:
	push {r4-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	ldrh r7, [r7,#oGameState_MapId]
	mov r6, #0
	ldr r4, =SoulWeaponsMaps 
.findMapLoop
	ldrh r0, [r4,r6]
	tst r0, r0
	beq .mapNotFound
	cmp r0, r7
	beq .mapFound
	add r6, #2
	b .findMapLoop
.mapFound
	lsr r0, r6, #1
	tst r0, r0
	pop {r4-r7,pc}
.mapNotFound
	mov r0, #0xff
	pop {r4-r7,pc}
	.balign 4, 0
	.pool // 81426F4
SoulWeaponsMaps:
	map_id CENTRAL_AREA1
	map_id CENTRAL_AREA2
	map_id CENTRAL_AREA3
	map_id SEASIDE_AREA1
	map_id SEASIDE_AREA2
	map_id SEASIDE_AREA3
	map_id UNDERGROUND1
	map_id UNDERGROUND2
	.hword 0
	thumb_func_end GetSoulWeaponsMapIndex

// symdb: Counts how many of the soul-weapon flags unlocked for the current soul-weapons map entry are set.
// symdb: () -> r0 = number of set flags in the soul-weapon flag range; flags clobbered by callees
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getSoulWeaponsUnlockedCount.yaml
	thumb_local_start
getSoulWeaponsUnlockedCount:
	push {r4-r7,lr}
	bl GetSoulWeaponsMapIndex
	ldr r7, off_8142770 // =byte_8142774 
	lsl r0, r0, #1
	ldrh r7, [r7,r0]
	bl getSoulWeaponsMapParam
	mov r4, r0
	mov r6, #0
loc_814271E:
	sub r4, #1
	blt loc_8142730
	add r0, r7, r4
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_814271E
	add r6, #1
	b loc_814271E
loc_8142730:
	mov r0, r6
	pop {r4-r7,pc}
	thumb_func_end getSoulWeaponsUnlockedCount

// symdb: Clears the per-map Soul/Beast event-flag block via sub_814278C's count, zeroes the 0xA0-byte state buffer at byte_2006670, and conditionally re-invokes sub_814227A if the flag from sub_81427F2 is still set.
// symdb: (r0 = current map id) -> void; ZF from final TestEventFlag
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/clearSoulWeaponsMapState.yaml
	thumb_local_start
clearSoulWeaponsMapState:
	push {r4-r7,lr}
	bl GetSoulWeaponsMapIndex
	ldr r7, off_8142770 // =byte_8142774 
	lsl r0, r0, #1
	ldrh r7, [r7,r0]
	bl getSoulWeaponsMapParam
	mov r4, r0
loc_8142746:
	sub r4, #1
	blt loc_8142754
	add r0, r7, r4
	mov r0, r0
	bl ClearEventFlag // (u16 entryFlagBitfield) -> void
	b loc_8142746
loc_8142754:
	ldr r0, off_81428D0 // =byte_2006670 
	ldr r1, byte_8142774+20 // =0xa0 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	bl getSoulWeaponId
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq locret_814276C
	bl sub_814227A
locret_814276C:
	pop {r4-r7,pc}
	.byte 0x0, 0x0
	.balign 4, 0
off_8142770:
	.word byte_8142774
byte_8142774:
	.byte 0x50, 0x7, 0x64, 0x7, 0x78, 0x7, 0x8C, 0x7, 0xA0, 0x7, 0xB4
	.byte 0x7, 0xC8, 0x7, 0xDC, 0x7, 0x0, 0x0, 0x0, 0x0, 0xA0, 0x0
	.byte 0x0, 0x0
	thumb_func_end clearSoulWeaponsMapState

// symdb: Returns a per-map parameter byte (0x7,0xB,0xC,0xD,0xE,0x10,0x14,0x14) for the current SoulWeapons map, using GetSoulWeaponsMapIndex as the lookup index.
// symdb: (takes args passed through to GetSoulWeaponsMapIndex, likely r0 = map or weapon id) -> r0 =
// symdb: byte_814279C[index]; flags from the ldrb
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getSoulWeaponsMapParam.yaml
	thumb_local_start
getSoulWeaponsMapParam:
	push {r4-r7,lr}
	bl GetSoulWeaponsMapIndex
	ldr r7, off_8142798 // =byte_814279C 
	ldrb r0, [r7,r0]
	pop {r4-r7,pc}
	.balign 4, 0
off_8142798:
	.word byte_814279C
byte_814279C:
	.byte 0x7, 0xB, 0xC, 0xD, 0xE, 0x10, 0x14, 0x14
	thumb_func_end getSoulWeaponsMapParam

// symdb: Computes an offset into a per-Beast-Out/Soul form data table: looks up the form's base offset and adds the given index to it.
// symdb: (r0 = form/entry id, also passed to GetSoulWeaponsMapIndex) -> r0 =
// symdb: baseOffset[GetSoulWeaponsMapIndex(id)] + id; flags not meaningful
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/soulWeapons_getFormDataOffset.yaml
	thumb_func_start soulWeapons_getFormDataOffset
soulWeapons_getFormDataOffset:
	push {r4-r7,lr}
	mov r4, r0
	bl GetSoulWeaponsMapIndex
	ldr r1, off_81427B8 // =byte_81427BC 
	lsl r0, r0, #1
	ldrh r0, [r1,r0]
	add r0, r0, r4
	pop {r4-r7,pc}
	.balign 4, 0
off_81427B8:
	.word byte_81427BC
byte_81427BC:
	.byte 0x50, 0x7, 0x64, 0x7, 0x78, 0x7, 0x8C, 0x7, 0xA0, 0x7, 0xB4
	.byte 0x7, 0xC8, 0x7, 0xDC, 0x7, 0x0, 0x0
	thumb_func_end soulWeapons_getFormDataOffset

// symdb: Returns a SoulWeapons per-row base value (0x7F0..0x7F7) indexed by the current SoulWeapons map index.
// symdb: () -> r0 = u16 base value (0x7F0..0x7F7)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getSoulWeaponBase_81427CE.yaml
	thumb_func_start battle_getSoulWeaponBase_81427CE
battle_getSoulWeaponBase_81427CE:
	push {r4-r7,lr}
	bl GetSoulWeaponsMapIndex
	ldr r1, off_81427DC // =byte_81427E0 
	lsl r0, r0, #1
	ldrh r0, [r1,r0]
	pop {r4-r7,pc}
	.balign 4, 0
off_81427DC:
	.word byte_81427E0
byte_81427E0:
	.byte 0xF0, 0x7, 0xF1, 0x7, 0xF2, 0x7, 0xF3, 0x7, 0xF4, 0x7, 0xF5
	.byte 0x7, 0xF6, 0x7, 0xF7, 0x7, 0x0, 0x0
	thumb_func_end battle_getSoulWeaponBase_81427CE

// symdb: Calls GetSoulWeaponsMapIndex and returns a 16-bit per-soul-weapon ID from the byte_8142804 lookup table (halfword stride, 8 entries 0x686-0x68D with a 0x0000 padding).
// symdb: (r0 = ? passed through to GetSoulWeaponsMapIndex) -> r0 = halfword ID from byte_8142804[index];
// symdb: no flag use
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getSoulWeaponId.yaml
	thumb_local_start
getSoulWeaponId:
	push {r4-r7,lr}
	bl GetSoulWeaponsMapIndex
	ldr r1, off_8142800 // =byte_8142804 
	lsl r0, r0, #1
	ldrh r0, [r1,r0]
	pop {r4-r7,pc}
	.balign 4, 0
off_8142800:
	.word byte_8142804
byte_8142804:
	.byte 0x86, 0x6, 0x87, 0x6, 0x88, 0x6, 0x89, 0x6, 0x8A, 0x6, 0x8B
	.byte 0x6, 0x8C, 0x6, 0x8D, 0x6, 0x0, 0x0
	thumb_func_end getSoulWeaponId

// symdb: Computes an index into the 256x256 map tile array (byte_2006670) for the tile under the cursor (camera position plus a caller-supplied 16.16 offset).
// symdb: (r0 = 16.16 x-offset added to camera cursor x, r1 = 16.16 y-offset) -> r0 = tile index (x +
// symdb: y*256) into byte_2006670; flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_getCursorMapTileIndex.yaml
	thumb_func_start ow_getCursorMapTileIndex
ow_getCursorMapTileIndex:
	push {r4-r7,lr}
	ldr r5, off_81428D0 // =byte_2006670 
	push {r0,r1}
	bl GetSoulWeaponCursorCameraOffsetForMap
	pop {r3,r4}
	asr r3, r3, #0x10
	asr r4, r4, #0x10
	add r0, r0, r3
	add r1, r1, r4
	asr r0, r0, #5
	asr r1, r1, #5
	add r0, #0x80
	add r1, #0x80
	mov r5, #0x80
	lsl r5, r5, #1
	mul r1, r5
	add r0, r0, r1
	pop {r4-r7,pc}
	thumb_func_end ow_getCursorMapTileIndex

	thumb_local_start
// probably needed since the "grid" where
// the evil spirits can exist depends on the map
GetSoulWeaponCursorCameraOffsetForMap:
	push {r4-r7,lr}
	bl GetSoulWeaponsMapIndex
	ldr r3, =SoulWeaponMapBasedCameraOffsets
	lsl r0, r0, #1
	add r3, r3, r0
	mov r0, #0
	ldrsb r0, [r3,r0]
	mov r1, #1
	ldrsb r1, [r3,r1]
	pop {r4-r7,pc}
	.balign 4, 0
	.pool // 8142854
SoulWeaponMapBasedCameraOffsets:
	.byte 0x0, 0x0, 0x8, -0x8
	.byte -0x8, 0x8, 0x8, 0x8
	.byte 0x8, 0x8, 0x10, 0x0
	.byte 0xC, 0x4, 0x4, -0x4
	thumb_func_end GetSoulWeaponCursorCameraOffsetForMap

	thumb_func_start GetSoulWeaponCursorCameraCoords
// get camera coords for when using a soul weapon
GetSoulWeaponCursorCameraCoords:
	push {r4-r7,lr}
	mov r1, #0x80
	lsl r1, r1, #1 // r1 = 0x100
	svc 6
	mov r2, r0
	mov r0, r1
	mov r1, r2
	sub r0, #0x80
	sub r1, #0x80
	lsl r0, r0, #5
	lsl r1, r1, #5
	push {r0,r1}
	bl GetSoulWeaponCursorCameraOffsetForMap
	pop {r3,r4}
	sub r0, r3, r0
	sub r1, r4, r1
	add r0, #0x10
	add r1, #0x10
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	mov r2, #0
	pop {r4-r7,pc}
	thumb_func_end GetSoulWeaponCursorCameraCoords

// symdb: Returns one of 8 directions pointing from one soul-weapon cursor to another, from their camera-space coordinates.
// symdb: (r0 = first cursor selector, r1 = second cursor selector) -> r0 = 8-way direction index 0..7
// symdb: from first cursor to second; clobbers r1-r3, lr
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getSoulWeaponCursorDir8.yaml
	thumb_func_start getSoulWeaponCursorDir8
getSoulWeaponCursorDir8:
	push {r4-r7,lr}
	mov r4, r1
	bl GetSoulWeaponCursorCameraCoords
	push {r0,r1}
	mov r0, r4
	bl GetSoulWeaponCursorCameraCoords
	pop {r2,r3}
	sub r0, r0, r2
	sub r1, r3, r1
	bl calcAngle_800117C
	add r0, #0x10
	lsr r0, r0, #4
	mov r1, #0xf
	and r0, r1
	lsr r0, r0, #1
	sub r0, #1
	mov r1, #7
	and r0, r1
	pop {r4-r7,pc}
	thumb_func_end getSoulWeaponCursorDir8

// symdb: Returns a pointer to the nth BattleObject entry in the EWRAM `byte_2006670` array (8-byte stride).
// symdb: (r0 = index) -> r0 = &byte_2006670[index*8] ; no side effects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_getByIndex_81428C2.yaml
	thumb_func_start battleObject_getByIndex_81428C2
battleObject_getByIndex_81428C2:
	push {r4-r7,lr}
	ldr r5, off_81428D0 // =byte_2006670 
	mov r1, #8
	mul r0, r1
	add r0, r0, r5
	pop {r4-r7,pc}
	.byte 0, 0
off_81428D0:
	.word byte_2006670
	thumb_func_end battleObject_getByIndex_81428C2

// symdb: Returns the chosen 8-way direction index for the soul-weapon/beast cursor: if the player's facing has bit0 set, returns the result of sub_8142952(state, facing, 1) directly; otherwise compares the two neighbour directions (facing-1 and facing+1) by their camera-distance from the player and returns the index whose cursor is farther away.
// symdb: (r0 = cursor state from sub_8142990? passed implicitly) -> r0 = chosen direction index (0-7); no
// symdb: meaningful flags
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/selectSoulWeaponCursorDir.yaml
	thumb_func_start selectSoulWeaponCursorDir
selectSoulWeaponCursorDir:
	push {r4-r7,lr}
	sub sp, sp, #0x10
	bl sub_8142990
	mov r4, r0
	bl GetOWPlayerFacingDirection
	mov r1, #1
	tst r0, r1
	beq loc_81428F6
	mov r1, r0
	mov r0, r4
	mov r2, #1
	bl movePackedCoordsByDir
	add sp, sp, #0x10
	pop {r4-r7,pc}
loc_81428F6:
	sub r1, r0, #1
	add r7, r0, #1
	mov r0, #7
	and r7, r0
	and r1, r0
	mov r0, r4
	mov r2, #1
	bl movePackedCoordsByDir
	mov r6, r0
	mov r0, r4
	mov r1, r7
	mov r2, #1
	bl movePackedCoordsByDir
	mov r7, r0
	bl ReadOWPlayerObjectCoords
	str r0, [sp]
	str r1, [sp,#4]
	mov r0, r6
	bl GetSoulWeaponCursorCameraCoords
	ldr r2, [sp]
	ldr r3, [sp,#4]
	sub r0, r0, r2
	sub r1, r1, r3
	bl calc_hypotFixed12
	str r0, [sp,#8]
	mov r0, r7
	bl GetSoulWeaponCursorCameraCoords
	ldr r2, [sp]
	ldr r3, [sp,#4]
	sub r0, r0, r2
	sub r1, r1, r3
	bl calc_hypotFixed12
	ldr r1, [sp,#8]
	cmp r0, r1
	ble loc_814294C
	mov r7, r6
loc_814294C:
	mov r0, r7
	add sp, sp, #0x10
	pop {r4-r7,pc}
	thumb_func_end selectSoulWeaponCursorDir

// symdb: Offsets a packed (x | y<<8) coordinate pair by a cardinal-direction step taken from a table, scaled by r2, and returns the repacked halfword.
// symdb: (r0 = packed coords, x in low byte / y in high byte; r1 = direction entry index; r2 = step
// symdb: multiplier) -> r0 = new packed coords (x&0xFF | y<<8); flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/movePackedCoordsByDir.yaml
	thumb_local_start
movePackedCoordsByDir:
	push {r4-r7,lr}
	mov r6, r2
	ldr r7, off_814297C // =byte_8142980 
	lsl r1, r1, #1
	add r7, r7, r1
	mov r4, r0
	mov r0, #0xff
	and r0, r4
	lsr r1, r4, #8
	mov r2, #0
	ldrsb r2, [r7,r2]
	mov r3, #1
	ldrsb r3, [r7,r3]
	mul r2, r6
	mul r3, r6
	add r0, r0, r2
	add r1, r1, r3
	lsl r1, r1, #8
	orr r0, r1
	pop {r4-r7,pc}
	.balign 4, 0x00
off_814297C:
	.word byte_8142980
byte_8142980:
	.byte 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0xFF, 0x0, 0x0, 0x0, 0x0, 0xFF
	thumb_func_end movePackedCoordsByDir

	thumb_func_start sub_8142990
sub_8142990:
	push {r4-r7,lr}
	bl ReadOWPlayerObjectCoords
	bl ow_getCursorMapTileIndex
	pop {r4-r7,pc}
	thumb_func_end sub_8142990

// symdb: Returns 1 if two packed (x,y) tile positions are the same or 4-neighbors (Manhattan distance <= 1), else 0.
// symdb: (r0 = packed pos A (hi=x<<8|lo? hi byte x, lo byte y), r1 = packed pos B) -> r0 = 1 if |dx|+|dy|
// symdb: <= 1 else 0; sets flags via tst
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/get_isAdjacentPos.yaml
	thumb_local_start
get_isAdjacentPos:
	push {r4-r7,lr}
	mov r7, #0
	lsr r2, r0, #8
	mov r3, #0xff
	and r3, r0
	lsr r4, r1, #8
	mov r5, #0xff
	and r5, r1
	sub r2, r2, r4
	sub r3, r3, r5
	cmp r2, #0
	bge loc_81429B6
	neg r2, r2
loc_81429B6:
	cmp r3, #0
	bge loc_81429BC
	neg r3, r3
loc_81429BC:
	add r2, r2, r3
	cmp r2, #1
	bgt loc_81429C4
	mov r7, #1
loc_81429C4:
	mov r0, r7
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end get_isAdjacentPos

// symdb: Writes the per-direction player-coordinate delta table into a scenario-effect buffer, indexed by the player's overworld facing direction.
// symdb: (no explicit r0/r1) -> r0 = nothing to caller (out is only r3/r5 which the caller restores);
// symdb: side effects: writes a variable number of u32 entries to *r6 = buffer returned from
// symdb: battleObject_scenarioEffectStateAddr_81421D8, indexed by player's facing direction
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_scenarioEffectInitPlayerOffsetMatrix_81429CA.yaml
	thumb_func_start battleObject_scenarioEffectInitPlayerOffsetMatrix_81429CA
battleObject_scenarioEffectInitPlayerOffsetMatrix_81429CA:
	push {r4-r7,lr}
	bl battleObject_scenarioEffectStateAddr_81421D8
	mov r6, r0
	// size
	mov r1, #0x10
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	bl sub_8142990
	mov r4, r0
	bl battle_getScenarioEffectStateField_81421D0
	ldr r7, off_8142A18 // =off_8142A1C 
	lsl r0, r0, #2
	ldr r7, [r7,r0]
	bl GetOWPlayerFacingDirection
	lsr r0, r0, #1
	lsl r0, r0, #1
	add r7, r7, r0
loc_81429F2:
	mov r2, #0
	ldrsb r2, [r7,r2]
	mov r3, #1
	ldrsb r3, [r7,r3]
	cmp r2, #0x7f
	beq locret_8142A14
	mov r0, #0xff
	and r0, r4
	lsr r1, r4, #8
	add r0, r0, r2
	add r1, r1, r3
	lsl r1, r1, #8
	orr r0, r1
	str r0, [r6]
	add r6, #4
	add r7, #8
	b loc_81429F2
locret_8142A14:
	pop {r4-r7,pc}
	.balign 4, 0
off_8142A18:
	.word off_8142A1C
off_8142A1C:
	.word byte_8142A2C
	.word byte_8142A3C
	.word byte_8142A54
	.word byte_8142A74
byte_8142A2C:
	.byte 0x1, 0x0, 0x0, 0x1, 0xFF, 0x0, 0x0, 0xFF, 0x7F, 0x7F, 0x7F, 0x7F
	.byte 0x7F, 0x7F, 0x7F, 0x7F
byte_8142A3C:
	.byte 0x1, 0x0, 0x0, 0x1, 0xFF, 0x0, 0x0, 0xFF, 0x2, 0x0, 0x0, 0x2, 0xFE, 0x0
	.byte 0x0, 0xFE, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F
byte_8142A54:
	.byte 0x1, 0x0, 0x0, 0x1, 0xFF, 0x0, 0x0, 0xFF, 0x1, 0xFF, 0xFF, 0x1, 0xFF
	.byte 0x1, 0x1, 0xFF, 0x1, 0x1, 0x1, 0x1, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x7F
	.byte 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F
byte_8142A74:
	.byte 0x3, 0x0, 0x0, 0x3, 0xFD, 0x0, 0x0, 0xFD, 0x7F, 0x7F, 0x7F, 0x7F
	.byte 0x7F, 0x7F, 0x7F, 0x7F
	thumb_func_end battleObject_scenarioEffectInitPlayerOffsetMatrix_81429CA

	thumb_func_start sub_8142A84
sub_8142A84:
	push {r4-r7,lr}
	mov r7, r0
	ldr r5, off_8142AAC // =eOverworldMapObjects
	mov r4, #0
	mov r6, #0
loc_8142A8E:
	bl battleObject_getPanelChipByIndexAtPlayerPos_8142B28
	beq loc_8142A9C
	bl sub_81421E8
	beq loc_8142A9C
	add r6, #1
loc_8142A9C:
	add r5, #0x78 
	add r4, #1
	cmp r4, #0x38 
	blt loc_8142A8E
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	.balign 4, 0
off_8142AAC:
	.word eOverworldMapObjects
	thumb_func_end sub_8142A84

// symdb: Returns whether the current scenario id (field 0x18 of the scenario effect state) appears in the 20-entry table at byte_2006670.
// symdb: () -> r0 = 1 if found, 0 if not; flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_scenarioIsActive.yaml
	thumb_local_start
e_scenarioIsActive:
	push {r4-r7,lr}
	ldr r5, off_8142C8C // =byte_2006670 
	bl getField0x18OfScenarioEffectState2000780_81421e0
	mov r7, r0
	mov r4, #0
	mov r6, #0
loc_8142ABE:
	ldrh r0, [r5,#4]
	tst r0, r0
	beq loc_8142ACC
	cmp r0, r7
	bne loc_8142ACC
	mov r6, #1
	b loc_8142AD4
loc_8142ACC:
	add r5, #8
	add r4, #1
	cmp r4, #0x14
	blt loc_8142ABE
loc_8142AD4:
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end e_scenarioIsActive

	thumb_func_start sub_8142ADA
sub_8142ADA:
	push {r4-r7,lr}
	ldr r5, off_8142C8C // =byte_2006670 
	mov r4, #0
	mov r6, #0
loc_8142AE2:
	ldrh r0, [r5,#4]
	tst r0, r0
	beq loc_8142AF6
	bl sub_8142990
	ldrh r1, [r5,#4]
	bl get_isAdjacentPos
	beq loc_8142AF6
	add r6, #1
loc_8142AF6:
	add r5, #8
	add r4, #1
	cmp r4, #0x14
	blt loc_8142AE2
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_8142ADA

// symdb: Iterates the overworld map object array (eOverworldMapObjects), calling battleObject_getPanelChipByIndexAtPlayerPos_8142B28 per entry, and counts how many objects' returned "panel chip" value matches r0; returns that count (0 if none match).
// symdb: (r0 = key chip value, r10 = toolkit) -> r0 = match count ; side effects: walks the global OW
// symdb: map-object array of 0x38 (56) entries and consumes r0..r5/r6/r7
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/owMapObject_countByChipOrSomething_8142B04.yaml
	thumb_func_start owMapObject_countByChipOrSomething_8142B04
owMapObject_countByChipOrSomething_8142B04:
	push {r4-r7,lr}
	mov r7, r0
	ldr r5, off_8142B54 // =eOverworldMapObjects
	mov r4, #0
	mov r6, #0
loc_8142B0E:
	bl battleObject_getPanelChipByIndexAtPlayerPos_8142B28
	beq loc_8142B1A
	cmp r0, r7
	bne loc_8142B1A
	add r6, #1
loc_8142B1A:
	add r5, #0x78 
	add r4, #1
	cmp r4, #0x38 
	blt loc_8142B0E
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end owMapObject_countByChipOrSomething_8142B04

// symdb: Looks up the battle object at the player's current overworld tile and returns its panel chip id (the halfword at offset 4), or 0 if no object matches
// symdb: (r5 = pointer to a battle object state with bytes at +0 and +1 used) -> r0 = halfword from
// symdb: matching object's +4, or 0 ; no side effects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_getPanelChipByIndexAtPlayerPos_8142B28.yaml
	thumb_local_start
battleObject_getPanelChipByIndexAtPlayerPos_8142B28:
	push {r4-r7,lr}
	mov r4, #0
	ldrb r0, [r5]
	mov r1, #1
	tst r0, r0
	beq loc_8142B4C
	ldrb r0, [r5,#1]
	cmp r0, #0xf
	bne loc_8142B4C
	bl ReadOWPlayerObjectCoords
	ldr r0, [r5,#0x14]
	cmp r0, r2
	bne loc_8142B4C
	ldrb r0, [r5,#4]
	bl battleObject_getByIndex_81428C2
	ldrh r4, [r0,#4]
loc_8142B4C:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	.balign 4, 0
off_8142B54:
	.word eOverworldMapObjects
	thumb_func_end battleObject_getPanelChipByIndexAtPlayerPos_8142B28

// symdb: Walks the 20-entry, 8-byte-stride table at byte_2006670 twice: first matching entries whose ID equals the current scenario effect's 0x18 field, then matching via sub_8142990/sub_814299C validation, returning the matching entry's 8-way direction from getSoulWeaponCursorDir8, or 0xFF if none.
// symdb: () -> r0 = direction 0-7 of the matching soul-weapon cursor, or 0xFF if no entry matches; calls
// symdb: only, no flags of interest
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getSoulWeaponCursorDir8ByEffect.yaml
	thumb_func_start getSoulWeaponCursorDir8ByEffect
getSoulWeaponCursorDir8ByEffect:
	push {r4-r7,lr}
	ldr r5, off_8142C8C // =byte_2006670 
	mov r4, #0
	mov r6, #0xff
loc_8142B60:
	ldrh r0, [r5,#4]
	tst r0, r0
	beq loc_8142B7E
	bl getField0x18OfScenarioEffectState2000780_81421e0
	ldrh r1, [r5,#4]
	cmp r0, r1
	bne loc_8142B7E
	bl sub_8142990
	ldrh r1, [r5,#4]
	bl getSoulWeaponCursorDir8
	mov r6, r0
	b loc_8142BB2
loc_8142B7E:
	add r5, #8
	add r4, #1
	cmp r4, #0x14
	blt loc_8142B60
	ldr r5, off_8142C8C // =byte_2006670 
	mov r4, #0
loc_8142B8A:
	ldrh r0, [r5,#4]
	tst r0, r0
	beq loc_8142BAA
	bl sub_8142990
	ldrh r1, [r5,#4]
	bl get_isAdjacentPos
	beq loc_8142BAA
	bl sub_8142990
	ldrh r1, [r5,#4]
	bl getSoulWeaponCursorDir8
	mov r6, r0
	b loc_8142BB2
loc_8142BAA:
	add r5, #8
	add r4, #1
	cmp r4, #0x14
	blt loc_8142B8A
loc_8142BB2:
	mov r0, r6
	pop {r4-r7,pc}
	thumb_func_end getSoulWeaponCursorDir8ByEffect

	thumb_func_start sub_8142BB6
sub_8142BB6:
	push {r4-r7,lr}
	ldr r5, off_8142C8C // =byte_2006670 
	mov r4, #0
loc_8142BBC:
	ldrh r0, [r5,#4]
	tst r0, r0
	beq loc_8142BEA
	bl sub_81421E8
	beq loc_8142BEA
	mov r0, #4
	strb r0, [r5,#6]
	push {r0-r7}
	ldrh r0, [r5,#4]
	bl GetSoulWeaponCursorCameraCoords
	mov r3, r2
	mov r2, r1
	mov r1, r0
	mov r0, #0x13
	mov r4, #0
	bl sub_8004822
	pop {r0-r7}
	mov r0, #0x6d 
	bl PlaySoundEffect
loc_8142BEA:
	add r5, #8
	add r4, #1
	cmp r4, #0x14
	blt loc_8142BBC
	pop {r4-r7,pc}
	thumb_func_end sub_8142BB6

	thumb_func_start sub_8142BF4
sub_8142BF4:
	push {r4-r7,lr}
	mov r7, #0x14
	b loc_8142BFE
	thumb_func_end sub_8142BF4

	thumb_func_start sub_8142BFA
sub_8142BFA:
	push {r4-r7,lr}
	mov r7, #0xc
loc_8142BFE:
	ldr r5, off_8142C8C // =byte_2006670 
	mov r4, #0
loc_8142C02:
	ldrh r0, [r5,#4]
	tst r0, r0
	beq loc_8142C16
	bl sub_8142990
	ldrh r1, [r5,#4]
	bl get_isAdjacentPos
	beq loc_8142C16
	strb r7, [r5,#6]
loc_8142C16:
	add r5, #8
	add r4, #1
	cmp r4, #0x14
	blt loc_8142C02
	pop {r4-r7,pc}
	thumb_func_end sub_8142BFA

// symdb: counts active battle entries whose team byte matches the given team id
// symdb: (r0 = team id) -> r0 = count ; side effects: none (clobbers nzcv, r4-r7)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_countAliveActorsOnTeam_8142C20.yaml
	thumb_func_start battle_countAliveActorsOnTeam_8142C20
battle_countAliveActorsOnTeam_8142C20:
	push {r4-r7,lr}
	mov r7, r0
	ldr r5, off_8142C8C // =byte_2006670 
	mov r4, #0
	mov r6, #0
loc_8142C2A:
	ldrh r0, [r5,#4]
	tst r0, r0
	beq loc_8142C38
	ldrb r0, [r5,#6]
	cmp r0, r7
	bne loc_8142C38
	add r6, #1
loc_8142C38:
	add r5, #8
	add r4, #1
	cmp r4, #0x14
	blt loc_8142C2A
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end battle_countAliveActorsOnTeam_8142C20

// symdb: Subtracts the given damage from the currently selected navi's HP and plays hit feedback (effect at player coords, camera shake, hit SFX).
// symdb: (r0 = damage amount) -> r0 = sound-effect id from last PlaySoundEffect call; writes new HP via
// symdb: sub_80010EC
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_dealDamageToCurrentNavi.yaml
	thumb_func_start ow_dealDamageToCurrentNavi
ow_dealDamageToCurrentNavi:
	push {r4-r7,lr}
	mov r4, r0
	bl GetCurPETNavi // () -> u8
	bl GetMaxAndCurHPForCurPETNavi_80010D4 // (which_navi: u8) -> (u16, u16)
	sub r4, r0, r4
	bge loc_8142C58
	mov r4, #0
loc_8142C58:
	bl GetCurPETNavi // () -> u8
	mov r1, r4
	bl sub_80010EC
	bl ReadOWPlayerObjectCoords
	mov r3, r2
	mov r2, r1
	mov r1, r0
	mov r0, #0x13
	mov r4, #4
	bl sub_8004822
	mov r0, #1
	mov r1, #0x14
	bl camera_initShakeEffect_80302a8
	mov r0, #SOUND_HIT_6B
	bl PlaySoundEffect
	mov r0, #0xd
	add r0, #0xff
	bl PlaySoundEffect
	pop {r4-r7,pc}
	.balign 4, 0
off_8142C8C:
	.word byte_2006670
	thumb_func_end ow_dealDamageToCurrentNavi

// symdb: empty stub function that immediately returns to its caller
// symdb: (lr) -> ; no side effects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_emptyStub_8142C90.yaml
	thumb_local_start
battleObject_emptyStub_8142C90:
	push {r4-r7,lr}
	pop {r4-r7,pc}
	thumb_func_end battleObject_emptyStub_8142C90

// symdb: Queues a 0x420-byte VRAM DMA of Beast+ special-scenario tile graphics from ROM into BG VRAM.
// symdb: () -> r0 = queued transfer (src dword_8619730, dest 0x6006C00, size 0x420); no return value
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/init_queueBeastSpGfx.yaml
	thumb_func_start init_queueBeastSpGfx
init_queueBeastSpGfx:
	push {lr}
	ldr r0, off_8142CA4 // =dword_8619730 
	ldr r1, dword_8142CA8 // =0x6006c00 
	ldr r2, off_8142CAC // =0x420 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {pc}
	.balign 4, 0
off_8142CA4:
	.word dword_8619730
dword_8142CA8:
	.word 0x6006C00
off_8142CAC:
	.word 0x420
	thumb_func_end init_queueBeastSpGfx

	thumb_func_start sub_8142CB0
sub_8142CB0:
	push {r4-r7,lr}
	ldr r5, off_8142D54 // =eMapTilesState200be70 
	bl sub_8142D58
	bl sub_8142DA0
	ldr r5, [r5,#0xc] // (dword_200BE7C - 0x200be70)
	ldr r1, [r5,#8]
	add r1, r1, r5
	add r0, r0, r1
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_8142CB0

// symdb: Stamps one tile-block pattern, selected by index, from a template table into the overworld map-tile grid.
// symdb: (r0 = destination tile-grid buffer (eMapTilesState-style struct), r1 = template index) -> r0 =
// symdb: none; flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_stampMapTileTemplate.yaml
	thumb_func_start ow_stampMapTileTemplate
ow_stampMapTileTemplate:
	push {r4-r7,lr}
	ldr r5, off_8142D54 // =eMapTilesState200be70 
	ldrb r4, [r5]
	mov r5, r0
	lsl r1, r1, #2
	ldr r6, off_8142D40 // =off_8142D44 
	ldr r6, [r6,r1]
	ldrh r0, [r6,#6]
	strh r0, [r5,#6]
	ldrh r0, [r6,#8]
	strh r0, [r5,#8]
	mov r7, #1
	mov r1, #8
	mov r2, #1
loc_8142CE4:
	mov r3, r1
	mul r3, r2
	add r3, r3, r7
	lsl r3, r3, #1
	ldrh r0, [r6,r3]
	mov r3, r4
	mul r3, r2
	add r3, r3, r7
	lsl r3, r3, #1
	strh r0, [r5,r3]
	add r7, #1
	cmp r7, #7
	blt loc_8142CE4
	mov r7, #1
	mov r1, #8
	mov r2, #2
loc_8142D04:
	mov r3, r1
	mul r3, r2
	add r3, r3, r7
	lsl r3, r3, #1
	ldrh r0, [r6,r3]
	mov r3, r4
	mul r3, r2
	add r3, r3, r7
	lsl r3, r3, #1
	strh r0, [r5,r3]
	add r7, #1
	cmp r7, #7
	blt loc_8142D04
	mov r7, #3
	mov r1, #8
	mov r2, #3
loc_8142D24:
	mov r3, r1
	mul r3, r2
	add r3, r3, r7
	lsl r3, r3, #1
	ldrh r0, [r6,r3]
	mov r3, r4
	mul r3, r2
	add r3, r3, r7
	lsl r3, r3, #1
	strh r0, [r5,r3]
	add r7, #1
	cmp r7, #5
	blt loc_8142D24
	pop {r4-r7,pc}
	.balign 4, 0
off_8142D40:
	.word off_8142D44
off_8142D44:
	.word dword_8619B50
	.word byte_8619B90
	thumb_func_end ow_stampMapTileTemplate

// symdb: Register-saving trampoline (push r4-r7/lr, bl sub_80307D8, pop) used as a callback that triggers sub_80307D8 to repaint both tilemap layers of the overworld map window centered on the camera.
// symdb: () -> r0 = result of sub_80307D8 (unknown); r4-r7 clobbered (saved/restored)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_redrawMapTilemapsCb.yaml
	thumb_func_start ow_redrawMapTilemapsCb
ow_redrawMapTilemapsCb:
	push {r4-r7,lr}
	bl ow_redrawTilemapAtCamera
	pop {r4-r7,pc}
	.balign 4, 0
off_8142D54:
	.word eMapTilesState200be70
	thumb_func_end ow_redrawMapTilemapsCb

	thumb_local_start
sub_8142D58:
	push {r4-r7,lr}
	ldr r5, off_8142E04 // =eMapTilesState200be70 
	ldr r6, off_8142E08 // =unk_2000B40 
	ldrb r4, [r5]
	ldrb r0, [r6,#0x8] // (byte_2000B48 - 0x2000b40)
	mov r1, #0x80
	cmp r0, r1
	blt loc_8142D84
	sub r0, r0, r1
	mov r7, r0
	lsl r0, r0, #1
	mul r0, r4
	mov r1, r7
	mov r2, #4
	mul r1, r2
	sub r0, r0, r1
	lsl r0, r0, #1
	mov r4, r0
	bl ow_getAreaMapTilesOffset
	sub r0, r0, r4
	b locret_8142D9E
loc_8142D84:
	sub r0, r1, r0
	mov r7, r0
	lsl r0, r0, #1
	mul r0, r4
	mov r1, r7
	mov r2, #4
	mul r1, r2
	sub r0, r0, r1
	lsl r0, r0, #1
	mov r4, r0
	bl ow_getAreaMapTilesOffset
	add r0, r0, r4
locret_8142D9E:
	pop {r4-r7,pc}
	thumb_func_end sub_8142D58

	thumb_local_start
sub_8142DA0:
	push {r4-r7,lr}
	push {r0}
	ldr r5, off_8142E04 // =eMapTilesState200be70 
	ldr r6, off_8142E08 // =unk_2000B40 
	ldrb r4, [r5]
	ldrb r0, [r6,#0x9] // (byte_2000B49 - 0x2000b40)
	mov r1, #0x80
	cmp r0, r1
	blt loc_8142DCC
	sub r0, r0, r1
	mov r7, r0
	lsl r0, r0, #1
	mul r0, r4
	mov r1, r7
	mov r2, #4
	mul r1, r2
	add r0, r0, r1
	lsl r0, r0, #1
	mov r4, r0
	pop {r0}
	add r0, r0, r4
	b locret_8142DE4
loc_8142DCC:
	sub r0, r1, r0
	mov r7, r0
	lsl r0, r0, #1
	mul r0, r4
	mov r1, r7
	mov r2, #4
	mul r1, r2
	add r0, r0, r1
	lsl r0, r0, #1
	mov r4, r0
	pop {r0}
	sub r0, r0, r4
locret_8142DE4:
	pop {r4-r7,pc}
	thumb_func_end sub_8142DA0

// symdb: Returns a per-area halfword constant (from a 4-entry table) selected by the current overworld map area, with map group 0x85 forced to entry 3.
// symdb: () -> r0 = halfword from byte_8142E0C[2*areaIndex]; no flags meaningfully used
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_getAreaMapTilesOffset.yaml
	thumb_local_start
ow_getAreaMapTilesOffset:
	push {lr}
	mov r1, r10
	ldr r1, [r1,#oToolkit_GameStatePtr]
	ldrb r2, [r1,#oGameState_MapGroup]
	cmp r2, #0x85
	bne loc_8142DF6
	mov r1, #3
	b loc_8142DF8
loc_8142DF6:
	ldrb r1, [r1,#5]
loc_8142DF8:
	lsl r1, r1, #1
	ldr r2, off_8142E00 // =byte_8142E0C 
	ldrh r0, [r2,r1]
	pop {pc}
	.balign 4, 0
off_8142E00:
	.word byte_8142E0C
off_8142E04:
	.word eMapTilesState200be70
off_8142E08:
	.word unk_2000B40
byte_8142E0C:
	.byte 0x50, 0x3C, 0xD0, 0x45, 0x90, 0x4A, 0xC0, 0x49
off_8142E14:
	.word byte_8142E24
	.word byte_8142E7C
off_8142E1C:
	.word byte_8142E48
	.word byte_8142EA0
byte_8142E24:
	.byte 0x0, 0xFF, 0xE, 0xFF, 0xCE, 0xFF, 0x0, 0x0, 0x1, 0xFF, 0xD2
	.byte 0x0, 0x72, 0x1, 0x0, 0x0, 0x2, 0xFF, 0x30, 0x0, 0xB0, 0xFE
	.byte 0x20, 0x0, 0x3, 0xFF, 0xCE, 0xFF, 0x6E, 0x1, 0x0, 0x0, 0xFF
	.byte 0x4, 0x0, 0x0
byte_8142E48:
	.byte 0x0, 0xFF, 0x50, 0x0, 0x92, 0xFF, 0x20, 0x0, 0x1, 0xFF, 0xD2
	.byte 0xFF, 0xD0, 0xFF, 0x0, 0x0, 0x2, 0xFF, 0x72, 0x1, 0xCE, 0xFF
	.byte 0x0, 0x0, 0x3, 0xFF, 0x54, 0xFF, 0x6C, 0x1, 0x0, 0x0, 0x4
	.byte 0xFF, 0x10, 0xFF, 0x4E, 0x0, 0x0, 0x0, 0x5, 0xFF, 0x30, 0x0
	.byte 0x30, 0xFE, 0x20, 0x0, 0xFF, 0x6, 0x0, 0x0
byte_8142E7C:
	.byte 0x0, 0xFF, 0x68, 0xFF, 0x8, 0x0, 0x20, 0x0, 0x1, 0xFF, 0x48
	.byte 0xFF, 0x7A, 0xFE, 0x0, 0x0, 0x2, 0xFF, 0xC, 0xFF, 0x14, 0x2
	.byte 0x0, 0x0, 0x3, 0xFF, 0xA4, 0x1, 0xB6, 0xFF, 0x20, 0x0, 0xFF
	.byte 0x4, 0x0, 0x0
byte_8142EA0:
	.byte 0x0, 0xFF, 0xC, 0xFF, 0x38, 0xFF, 0x0, 0x0, 0x1, 0xFF, 0x88
	.byte 0x1, 0x32, 0x0, 0x20, 0x0, 0x2, 0xFF, 0xA6, 0x0, 0xB8, 0x0
	.byte 0x0, 0x0, 0x3, 0xFF, 0xA4, 0xFF, 0xBA, 0x1, 0x0, 0x0, 0x4
	.byte 0xFF, 0x28, 0x0, 0xFC, 0x1, 0x0, 0x0, 0xFF, 0x5, 0x0, 0x0
	thumb_func_end ow_getAreaMapTilesOffset

	thumb_local_start
sub_8142ECC:
	push {r4-r7,lr}
	bl ow_crowLessonGetTextId
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8142FBA
	mov r1, r10
	ldr r1, [r1,#oToolkit_GameStatePtr]
	ldrb r2, [r1,#oGameState_MapGroup]
	ldrb r3, [r1,#oGameState_LastMapGroup]
	ldrb r0, [r1,#oGameState_MapNumber]
	ldrb r1, [r1,#oGameState_LastMapNumber]
	lsl r0, r0, #2
	lsl r1, r1, #2
	push {r0-r3}
	movflag EVENT_960
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	pop {r0-r3}
	bne loc_8142F00
	cmp r2, r3
	bne loc_8142F00
	cmp r0, r1
	beq loc_8142F08
loc_8142F00:
	push {r0-r7}
	bl clearCybercrowLesson
	pop {r0-r7}
loc_8142F08:
	bl sub_8143088
	lsl r0, r0, #2
	ldr r7, off_8142FC0 // =off_8142E14 
	ldr r7, [r7,r0]
	mov r4, #0
loc_8142F14:
	ldrb r0, [r7]
	cmp r0, #0xff
	beq loc_8142F44
	mov r0, r4
	bl ow_getEventFlagIds
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8142F3E
	push {r4-r7}
	mov r0, #0x16
	ldrh r1, [r7,#2]
	lsl r1, r1, #0x10
	ldrh r2, [r7,#4]
	lsl r2, r2, #0x10
	ldrh r3, [r7,#6]
	lsl r3, r3, #0x10
	bl SpawnOverworldMapObject
	pop {r4-r7}
loc_8142F3E:
	add r4, #1
	add r7, #8
	b loc_8142F14
loc_8142F44:
	ldrb r0, [r7,#1]
	bl sub_81433C2
	bl sub_8143088
	lsl r0, r0, #2
	ldr r7, off_8142FC4 // =off_8142E1C 
	ldr r7, [r7,r0]
	mov r4, #0
loc_8142F56:
	ldrb r0, [r7]
	cmp r0, #0xff
	beq loc_8142F8C
	mov r0, r4
	bl ow_getEventFlagIds
	mov r0, r1
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8142F86
	push {r4-r7}
	mov r0, #1
	lsl r0, r0, #8
	orr r4, r0
	mov r0, #0x16
	ldrh r1, [r7,#2]
	lsl r1, r1, #0x10
	ldrh r2, [r7,#4]
	lsl r2, r2, #0x10
	ldrh r3, [r7,#6]
	lsl r3, r3, #0x10
	bl SpawnOverworldMapObject
	pop {r4-r7}
loc_8142F86:
	add r4, #1
	add r7, #8
	b loc_8142F56
loc_8142F8C:
	ldr r5, off_8143084 // =byte_2000D20 
	mov r4, #0
loc_8142F90:
	ldrb r0, [r5]
	tst r0, r0
	beq loc_8142FA6
	push {r4-r7}
	mov r0, #0x18
	mov r1, #0
	mov r2, #0
	mov r3, #0
	bl SpawnOverworldMapObject
	pop {r4-r7}
loc_8142FA6:
	add r5, #0x14
	add r4, #1
	cmp r4, #8
	blt loc_8142F90
	bl reqBBS_processCompletedRewards
	movflag EVENT_960
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
loc_8142FBA:
	mov r0, #0
	pop {r4-r7,pc}
	.byte 0x0, 0x0
	.balign 4, 0
off_8142FC0:
	.word off_8142E14
off_8142FC4:
	.word off_8142E1C
	thumb_func_end sub_8142ECC

// symdb: Per-frame overworld handler for the Cybercrow lesson spot: a denied forward/jack-in press begins a flag-staged cutscene sequence with the crows.
// symdb: () -> r0 = 0 always; runs each frame while the player stands at the spot, setting/clearing
// symdb: EVENT_962/EVENT_963 and starting cutscenes as side effects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_crowLessonInteraction.yaml
	thumb_local_start
ow_crowLessonInteraction:
	push {r4-r7,lr}
	bl check_playerCanAdvanceForward_8034C36
	beq loc_814305E
	bl ow_crowLessonGetTextId
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_814305E
	bl sub_8143314
	bl ow_crowLessonCheckCrowCollisions
	movflag EVENT_962
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_8143010
	mov r3, r10
	ldr r3, [r3,#oToolkit_GameStatePtr]
	ldrb r0, [r3,#oGameState_CoordInteractionTriggered]
	tst r0, r0
	beq loc_8143048
	bl ow_crowLessonFlagCheck
	beq loc_8143008
	movflag EVENT_962
	bl SetEventFlagFromImmediate
	b loc_8143048
loc_8143008:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	b loc_8143048
loc_8143010:
	movflag EVENT_963
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_8143024
	movflag EVENT_963
	bl SetEventFlagFromImmediate
	b loc_8143048
loc_8143024:
	bl sub_80357AE
	bne loc_8143038
	ldr r0, off_8143080 // =byte_808C2F0 // CutsceneScript
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
	mov r0, #1
	bl ow_crowLessonSubtractCounter
loc_8143038:
	movflag EVENT_962
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_963
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
loc_8143048:
	bl e_countSetEventFlags
	bne loc_814306E
	bl sub_8143088
	ldr r1, off_8143074 // =off_8143078 // [*const CutsceneScript; 2]
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
loc_814305E:
	movflag EVENT_962
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_963
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
loc_814306E:
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_8143074: 
  .word off_8143078 // [*const CutsceneScript; 2]
off_8143078: // [*const CutsceneScript; 2]
  .word byte_808C004
	.word byte_808C0F4
off_8143080:
	.word byte_808C2F0 // CutsceneScript
off_8143084:
	.word byte_2000D20
	thumb_func_end ow_crowLessonInteraction

	thumb_func_start sub_8143088
sub_8143088:
	push {r4-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	ldrh r7, [r7,#oGameState_MapGroup]
	mov r6, #0
	ldr r4, off_81430AC // =byte_81430B0 
loc_8143094:
	ldrh r0, [r4,r6]
	tst r0, r0
	beq loc_81430A8
	cmp r0, r7
	beq loc_81430A2
	add r6, #2
	b loc_8143094
loc_81430A2:
	lsr r0, r6, #1
	tst r0, r0
	pop {r4-r7,pc}
loc_81430A8:
	mov r0, #0xff
	pop {r4-r7,pc}
	.balign 4, 0
off_81430AC:
	.word byte_81430B0
byte_81430B0:
	.byte 0x92, 0x0, 0x92, 0x1, 0x0, 0x0
	thumb_func_end sub_8143088

// symdb: Computes overworld event flag ID(s) for an index, using a per-area base table.
// symdb: (r0 = flag index u8) -> r0 = flagId = areaBase[index] + flagIndex (and r1 = second flagId from
// symdb: paired table entry); no flags
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_getEventFlagIds.yaml
	thumb_func_start ow_getEventFlagIds
ow_getEventFlagIds:
	push {r4-r7,lr}
	mov r4, r0
	bl sub_8143088
	ldr r1, off_81430D0 // =byte_81430D4 
	lsl r0, r0, #2
	add r1, r1, r0
	ldrh r0, [r1]
	ldrh r1, [r1,#2]
	add r0, r0, r4
	add r1, r1, r4
	pop {r4-r7,pc}
	.balign 4, 0
off_81430D0:
	.word byte_81430D4
byte_81430D4:
	.byte 0x70, 0x9, 0x78, 0x9, 0x80, 0x9, 0x88, 0x9
	thumb_func_end ow_getEventFlagIds

// symdb: Returns one of two text/message IDs (0x96E/0x96F) for the Cybercrow lesson spot, chosen by a state value from a helper.
// symdb: () -> r0 = message/text ID (halfword 0x96E or 0x96F from table dword_81430F0); no flag
// symdb: guarantees
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_crowLessonGetTextId.yaml
	thumb_local_start
ow_crowLessonGetTextId:
	push {r4-r7,lr}
	bl sub_8143088
	ldr r1, off_81430EC // =dword_81430F0 
	lsl r0, r0, #1
	ldrh r0, [r1,r0]
	pop {r4-r7,pc}
	.balign 4, 0
off_81430EC:
	.word dword_81430F0
dword_81430F0:
	.word 0x96F096E
	thumb_func_end ow_crowLessonGetTextId

// symdb: Processes a table of BBS request completions: stores each entry's word into the per-request status array and sets the request's completion event flag.
// symdb: (no args used) -> r0 = 0; calls SetEventFlag and reqBBS_setFlag; clobbers r0-r4
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/reqBBS_processCompletedRewards.yaml
	thumb_local_start
reqBBS_processCompletedRewards:
	push {r4-r7,lr}
	bl reqBBS_setFlag_e17b0f7_8140A00
	bl sub_8143088
	ldr r4, off_8143164 // =off_8143168 
	lsl r0, r0, #2
	ldr r4, [r4,r0]
loc_8143104:
	ldrb r0, [r4]
	tst r0, r0
	beq loc_8143128
	ldr r1, off_8143190 // =unk_2011EA0 
	mov r2, #4
	mul r0, r2
	add r1, r1, r0
	ldr r0, [r4,#4]
	str r0, [r1]
	ldr r0, dword_8143194 // =0x16f1 
	ldrb r1, [r4]
	sub r1, #1
	add r0, r0, r1
	mov r0, r0
	bl SetEventFlag
	add r4, #8
	b loc_8143104
loc_8143128:
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end reqBBS_processCompletedRewards

	thumb_local_start
sub_814312C:
	push {r4-r7,lr}
	bl reqBBS_clearFlag_8140A0C
	bl sub_8143088
	ldr r4, off_8143164 // =off_8143168 
	lsl r0, r0, #2
	ldr r4, [r4,r0]
loc_814313C:
	ldrb r0, [r4]
	tst r0, r0
	beq loc_8143160
	ldr r1, off_8143190 // =unk_2011EA0 
	mov r2, #4
	mul r0, r2
	add r1, r1, r0
	mov r0, #0
	str r0, [r1]
	ldr r0, dword_8143194 // =0x16f1 
	ldrb r1, [r4]
	sub r1, #1
	add r0, r0, r1
	mov r0, r0
	bl ClearEventFlag // (u16 entryFlagBitfield) -> void
	add r4, #8
	b loc_814313C
loc_8143160:
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_8143164:
	.word off_8143168
off_8143168:
	.word byte_8143170
	.word byte_8143184
byte_8143170:
	.byte 0x2, 0xFF, 0xFF, 0xFF, 0x2, 0x5, 0x5, 0x8, 0xC, 0xFF, 0xFF, 0xFF
	.byte 0x2, 0x5, 0xFF, 0x8, 0x0, 0x0, 0x0, 0x0
byte_8143184:
	.byte 0x1, 0xFF, 0xFF, 0xFF, 0x2, 0x5, 0x1, 0x8, 0x0, 0x0, 0x0, 0x0
off_8143190:
	.word unk_2011EA0
dword_8143194:
	.word 0x16F1
	thumb_func_end sub_814312C

// symdb: Counts the number of set event flags in a fixed group (size from sub_81433CA, base id from sub_81430B6) and returns the count in r0 with Z set when every flag in the group is set, used by ow_crowLessonInteraction to gate cutscene stages.
// symdb: () -> r0 = number of set flags; flags Z set iff r0 == total flags in group (r1 = total), N/C per
// symdb: cmp
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_countSetEventFlags.yaml
	thumb_func_start e_countSetEventFlags
e_countSetEventFlags:
	push {r4-r7,lr}
	bl e_getFlagTotal
	mov r6, r0
	mov r0, #0
	bl ow_getEventFlagIds
	mov r7, r0
	mov r4, #0
loc_81431AA:
	mov r0, r7
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_81431B4
	add r4, #1
loc_81431B4:
	add r7, #1
	sub r6, #1
	bgt loc_81431AA
	bl e_getFlagTotal
	mov r1, r0
	mov r0, r4
	cmp r0, r1
	pop {r4-r7,pc}
	thumb_func_end e_countSetEventFlags

// symdb: Resets the Cybercrow lesson state: runs sub_814339C, zero-fills the 0xA0-byte crow-records array at byte_2000D20, and calls sub_81430B6(0) twice with each result passed to ClearEventFlagRange(8).
// symdb: () -> void; clobbers r0-r2, calls sub_814339C, ZeroFillByWord, sub_81430B6, ClearEventFlagRange
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/clearCybercrowLesson.yaml
	thumb_local_start
clearCybercrowLesson:
	push {r4-r7,lr}
	ldr r5, off_8143398 // =byte_2000D20 
	bl e_initMinigameEffectSlot2
	mov r0, r5
	ldr r1, off_81431F4 // =0xa0 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #0
	bl ow_getEventFlagIds
	mov r0, r0
	mov r2, #8
	bl ClearEventFlagRange // (u16 entryFlagBitfield) -> void
	mov r0, #0
	bl ow_getEventFlagIds
	mov r0, r1
	mov r2, #8
	bl ClearEventFlagRange // (u16 entryFlagBitfield) -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_81431F4:
	.word 0xA0
	thumb_func_end clearCybercrowLesson

// symdb: Returns a pointer to one of the eight Cybercrow crow records (index * 0x14 into byte_2000D20).
// symdb: (r0 = record index) -> r0 = &byte_2000D20[index * 0x14] (0x14-byte crow record); flags not
// symdb: meaningful
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_cybercrowGetCrowRecord.yaml
	thumb_func_start ow_cybercrowGetCrowRecord
ow_cybercrowGetCrowRecord:
	push {r4-r7,lr}
	ldr r5, off_8143398 // =byte_2000D20 
	mov r1, #0x14
	mul r0, r1
	add r0, r0, r5
	pop {r4-r7,pc}
	thumb_func_end ow_cybercrowGetCrowRecord

// symdb: Calls sub_81431F8 to obtain a struct pointer, then writes a random halfword in range 30–93 ([GetRNG & 0x3F] + 0x1E) at offset +6 of that struct, used as a frame-delay timer.
// symdb: () -> r0 = undefined; stores halfword timer into [crowState+6]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/init_setRandomTimer.yaml
	thumb_func_start init_setRandomTimer
init_setRandomTimer:
	push {r4-r7,lr}
	bl ow_cybercrowGetCrowRecord
	mov r5, r0
	bl GetRNG // () -> u32?
	mov r1, #0x3f 
	and r1, r0
	ldr r0, dword_814321C // =0x1e 
	add r0, r0, r1
	strh r0, [r5,#6]
	pop {r4-r7,pc}
	.balign 4, 0
dword_814321C:
	.word 0x1E
	thumb_func_end init_setRandomTimer

// symdb: Cybercrow record r0 gets a new random countdown at +0x02 of 0x1E + (GetRNG & 0x3F) frames (30-93), and its state byte becomes 1 unless it is 3 (sub_81432FA).
// symdb: (r0 = crow slot index 0-7) -> r0 = the record's state byte from before the call (sub_81432FA's
// symdb: ldrb), r1 = 0x14; r4-r7 preserved (push/pop r4-r7); clobbers r2, r3, lr and the flags. One
// symdb: primary GetRNG.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8143220.yaml
	thumb_func_start sub_8143220
sub_8143220:
	push {r4-r7,lr}
	mov r4, r0
	bl ow_cybercrowGetCrowRecord
	mov r5, r0
	bl GetRNG // () -> u32?
	mov r1, #0x3f 
	and r1, r0
	ldr r0, dword_8143244 // =0x1e 
	add r0, r0, r1
	strh r0, [r5,#2]
	mov r0, r4
	mov r1, #1
	bl ow_cybercrowSetCrowRecordState
	pop {r4-r7,pc}
	.balign 4, 0
dword_8143244:
	.word 0x1E
	thumb_func_end sub_8143220

// symdb: Per-crow proximity check for the Cybercrow lesson: when an active crow's position is within the collision threshold of another active crow (delta hypot < 6<<16), flag that crow into state 2 via sub_81432FA.
// symdb: () -> void; for each active crow record whose position comes within 6.0 of another active crow,
// symdb: invokes sub_81432FA(crowIndex, 2) and moves on
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_crowLessonCheckCrowCollisions.yaml
	thumb_local_start
ow_crowLessonCheckCrowCollisions:
	push {r4-r7,lr}
	mov r6, #0
	ldr r7, off_8143398 // =byte_2000D20 
loc_814324E:
	ldrb r0, [r7]
	tst r0, r0
	beq loc_814328A
	add r4, r6, #1
	mov r5, r7
	add r5, #0x14
loc_814325A:
	ldrb r0, [r5]
	tst r0, r0
	beq loc_8143282
	ldr r0, [r5,#8]
	ldr r1, [r5,#0xc]
	ldr r2, [r7,#8]
	ldr r3, [r7,#0xc]
	sub r0, r0, r2
	sub r1, r1, r3
	bl calc_hypotFixed12
	mov r1, #6
	lsl r1, r1, #0x10
	cmp r0, r1
	bge loc_8143282
	mov r0, r6
	mov r1, #2
	bl ow_cybercrowSetCrowRecordState
	b loc_814328A
loc_8143282:
	add r5, #0x14
	add r4, #1
	cmp r4, #8
	blt loc_814325A
loc_814328A:
	add r7, #0x14
	add r6, #1
	cmp r6, #8
	blt loc_814324E
	pop {r4-r7,pc}
	thumb_func_end ow_crowLessonCheckCrowCollisions

// symdb: Per-frame loop over 8 Cybercrow lesson records at byte_2000D20: for each active slot, marks +1 = 8 when the player is within 0xFA<<16 hypot distance of the crow's position, then calls sub_81432FA(i, 1) for every active slot.
// symdb: (void) -> void; touches byte_2000D20 slots (+0 state read, +1 written 8 when player near), calls
// symdb: sub_81432FA(i, 1) per active slot
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/t3_tickCrows.yaml
	thumb_func_start t3_tickCrows
t3_tickCrows:
	push {r4-r7,lr}
	mov r4, #0
	ldr r5, off_8143398 // =byte_2000D20 
loc_814329A:
	ldrb r0, [r5]
	tst r0, r0
	beq loc_81432CE
	mov r0, r10
	ldr r0, [r0,#oToolkit_GameStatePtr]
	ldr r0, [r0,#oGameState_OverworldPlayerObjectPtr]
	ldr r2, [r0,#0x20]
	ldr r3, [r0,#0x1c]
	ldr r0, [r5,#0xc]
	ldr r1, [r5,#8]
	sub r0, r0, r2
	sub r1, r1, r3
	bl calc_hypotFixed12
	ldrb r1, [r5]
	mov r2, #0xfa
	lsl r2, r2, #0x10
	cmp r0, r2
	bge loc_81432C6
	mov r1, #3
	mov r0, #8
	strb r0, [r5,#1]
loc_81432C6:
	mov r0, r4
	mov r1, #1
	bl ow_cybercrowSetCrowRecordState
loc_81432CE:
	add r5, #0x14
	add r4, #1
	cmp r4, #8
	blt loc_814329A
	pop {r4-r7,pc}
	thumb_func_end t3_tickCrows

	thumb_local_start
sub_81432D8:
	push {r4-r7,lr}
	mov r6, #0
	mov r4, #0
	ldr r5, off_8143398 // =byte_2000D20 
loc_81432E0:
	ldrb r0, [r5]
	tst r0, r0
	beq loc_81432EC
	cmp r0, #3
	bne loc_81432EC
	add r6, #1
loc_81432EC:
	add r5, #0x14
	add r4, #1
	cmp r4, #8
	blt loc_81432E0
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_81432D8

// symdb: Writes a new state byte into one of the eight Cybercrow crow records unless it is locked at state 3.
// symdb: (r0 = crow record index, r1 = new state value) -> r0 = record pointer (side-effect only); no
// symdb: meaningful flags
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_cybercrowSetCrowRecordState.yaml
	thumb_local_start
ow_cybercrowSetCrowRecordState:
	push {r4-r7,lr}
	mov r4, r1
	bl ow_cybercrowGetCrowRecord
	mov r5, r0
	ldrb r0, [r5]
	cmp r0, #3
	beq locret_814330C
	strb r4, [r5]
locret_814330C:
	pop {r4-r7,pc}
	.byte 0, 0
	.word 0x1E
	thumb_func_end ow_cybercrowSetCrowRecordState

// symdb: Spawns a crow into the first free slot of byte_2000D20 (max 6 active): 2 primary GetRNG calls — one raw heading stored at +4, one & 0xF0 (<<1) angle on a fixed radius around the player via math_cosTable / math_sinTable — then SpawnOverworldMapObject(type 0x18).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8143314.yaml
	thumb_local_start
sub_8143314:
	push {r4-r7,lr}
	ldr r5, off_8143398 // =byte_2000D20 
	bl crow_decrementCounter
	bne locret_814338E
	bl sub_814343A
	mov r4, #0
loc_8143324:
	ldrb r0, [r5]
	tst r0, r0
	bne loc_8143386
	mov r0, #1
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
	bl GetRNG // () -> u32?
	strh r0, [r5,#4]
	mov r0, r4
	bl init_setRandomTimer
	mov r0, r4
	bl sub_8143220
	push {r4-r7}
	bl GetRNG // () -> u32?
	mov r1, #0xf0
	and r0, r1
	lsl r0, r0, #1
	ldr r1, off_8143390 // =math_cosTable
	ldr r2, off_8143394 // =math_sinTable
	ldrsh r1, [r1,r0]
	ldrsh r2, [r2,r0]
	mov r0, #0x80
	lsl r0, r0, #4
	mul r1, r0
	mul r2, r0
	lsl r1, r1, #5
	lsl r2, r2, #5
	mov r0, r10
	ldr r0, [r0,#oToolkit_GameStatePtr]
	ldr r0, [r0,#oGameState_OverworldPlayerObjectPtr]
	ldr r3, [r0,#0x1c]
	sub r1, r3, r1
	str r1, [r5,#8]
	ldr r3, [r0,#0x20]
	sub r2, r3, r2
	str r2, [r5,#0xc]
	mov r0, #0x18
	mov r1, #0
	mov r2, #0
	mov r3, #0
	bl SpawnOverworldMapObject
	pop {r4-r7}
	b locret_814338E
loc_8143386:
	add r5, #0x14
	add r4, #1
	cmp r4, #6
	blt loc_8143324
locret_814338E:
	pop {r4-r7,pc}
	.balign 4, 0
off_8143390:
	.word math_cosTable
off_8143394:
	.word math_sinTable
off_8143398:
	.word byte_2000D20
	thumb_func_end sub_8143314

// symdb: Initializes the effect-slot-2 work area at eStruct2001010+8 (zero-fills 0x40 bytes), runs sub_81433D2(5) and the RNG/sub-write helpers sub_8143406/sub_814343A, and returns 0.
// symdb: () -> r0 = 0 (success); no flags relied on by caller
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_initMinigameEffectSlot2.yaml
	thumb_local_start
e_initMinigameEffectSlot2:
	push {r4-r7,lr}
	mov r0, #2
	bl initMinigameEffect_8003a64
	ldr r5, off_81434E0 // =eStruct2001010 
	mov r0, r5
	// memBlock
	add r0, #8
	// size
	mov r1, #0x40 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #5
	bl sub_81433D2
	bl sub_8143406
	bl sub_814343A
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end e_initMinigameEffectSlot2

	thumb_local_start
sub_81433C2:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	strb r0, [r5,#0x8] // (byte_2001018 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end sub_81433C2

// symdb: returns the stored total flag count (byte at +8 of eStruct2001010) that callers compare against a counted number of set flags
// symdb: () -> r0 = u8 total count stored at eStruct2001010+8; preserves r4-r7
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_getFlagTotal.yaml
	thumb_local_start
e_getFlagTotal:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	ldrb r0, [r5,#0x8] // (byte_2001018 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end e_getFlagTotal

	thumb_local_start
sub_81433D2:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	strb r0, [r5,#0x9] // (byte_2001019 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end sub_81433D2

// symdb: Returns nonzero when the crow-lesson event flag at eStruct2001010+0x9 is set
// symdb: (void) -> r0 = flag byte from eStruct2001010+0x9 (0 or nonzero); flags set by tst
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_crowLessonFlagCheck.yaml
	thumb_func_start ow_crowLessonFlagCheck
ow_crowLessonFlagCheck:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	ldrb r0, [r5,#0x9] // (byte_2001019 - 0x2001010)
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end ow_crowLessonFlagCheck

// symdb: Adds r0 to a byte in the eStruct2001010 struct and saturates the result at 5.
// symdb: (r0 = amount to add) -> byte at eStruct2001010+9 clamped-increased; flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_addByteSaturatingAt5.yaml
	thumb_func_start e_addByteSaturatingAt5
e_addByteSaturatingAt5:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	ldrb r1, [r5,#0x9] // (byte_2001019 - 0x2001010)
	add r1, r1, r0
	cmp r1, #5
	ble loc_81433F2
	mov r1, #5
loc_81433F2:
	strb r1, [r5,#0x9] // (byte_2001019 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end e_addByteSaturatingAt5

// symdb: Subtracts r0 from the crow-lesson counter at eStruct2001010+0x9, clamping the result at zero.
// symdb: (r0 = amount to subtract) -> r0 preserved; counter at byte_2001019 becomes max(counter - r0, 0);
// symdb: flags set by the SUB
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_crowLessonSubtractCounter.yaml
	thumb_local_start
ow_crowLessonSubtractCounter:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	ldrb r1, [r5,#0x9] // (byte_2001019 - 0x2001010)
	sub r1, r1, r0
	bge loc_8143402
	mov r1, #0
loc_8143402:
	strb r1, [r5,#0x9] // (byte_2001019 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end ow_crowLessonSubtractCounter

// symdb: Writes GetRNG & 3 into eStruct2001010 + 0xA (byte_200101A); meaning unknown (the vidsync doc flags it the same way).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8143406.yaml
	thumb_local_start
sub_8143406:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	bl GetRNG // () -> u32?
	mov r1, #3
	and r0, r1
	strb r0, [r5,#0xa] // (byte_200101A - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end sub_8143406

	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	sub sp, sp, #0x10
	mov r0, sp
	mov r1, #0x10
	mov r2, #0x20 
	bl ByteFill // (u8 *mem, int byteCount, u8 byte) -> void
	mov r0, sp
	mov r1, #0
	ldrb r2, [r5,#0xa] // (byte_200101A - 0x2001010)
	strb r1, [r0,r2]
	mov r1, #4
	bl pickWeightedIndex_8000E3A
	strb r0, [r5,#0xa] // (byte_200101A - 0x2001010)
	add sp, sp, #0x10
	pop {r4-r7,pc}
// symdb: Uniform 3-way pick through pickWeightedIndex_8000E3A with the weight table {5,5,5} - the result is always 0, so it only burns 2-8 primary draws; stores 5 into dword_200101C (the Cybercrow spawn cooldown).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_814343A.yaml
	thumb_local_start
sub_814343A:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	sub sp, sp, #0x10
	// mem
	mov r0, sp
	// byteCount
	mov r1, #0x10
	// byte
	mov r2, #0x20 
	bl ByteFill // (u8 *mem, int byteCount, u8 byte) -> void
	mov r0, sp
	mov r1, #3
	bl pickWeightedIndex_8000E3A
	ldr r1, off_8143460 // =byte_8143464 
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	str r0, [r5,#0xc] // (dword_200101C - 0x2001010)
	add sp, sp, #0x10
	mov r0, #0
	pop {r4-r7,pc}
off_8143460:
	.word byte_8143464
byte_8143464:
	.byte 0x5, 0x0, 0x0, 0x0, 0x5, 0x0, 0x0, 0x0, 0x5, 0x0, 0x0, 0x0
	thumb_func_end sub_814343A

// symdb: Decrements a saturating counter in the crow/bird system struct (eStruct2001010+0xC), clamping at zero and returning the new value.
// symdb: () -> r0 = new counter value (old value - 1, min 0); flags set from final value (Z if zero, N if
// symdb: negative before clamp)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/crow_decrementCounter.yaml
	thumb_local_start
crow_decrementCounter:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	ldr r0, [r5,#0xc] // (dword_200101C - 0x2001010)
	sub r0, #1
	bge loc_814347C
	mov r0, #0
loc_814347C:
	str r0, [r5,#0xc] // (dword_200101C - 0x2001010)
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end crow_decrementCounter

	thumb_func_start sub_8143482
sub_8143482:
	push {r4-r7,lr}
	ldr r5, off_81434E0 // =eStruct2001010 
	bl sub_81434BA
	bne loc_81434B6
	ldrb r0, [r5,#0x3] // (byte_2001013 - 0x2001010)
	tst r0, r0
	beq loc_81434AE
	mov r0, #0
	strb r0, [r5,#0x3] // (byte_2001013 - 0x2001010)
	bl sub_80468BA
	mov r0, #8
	mov r1, #0
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
	mov r0, #9
	mov r1, #1
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
loc_81434AE:
	bl battle_callAIDispatch_8046818
	bl battleObject_updateSpriteGfxForAll_8046854
loc_81434B6:
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_8143482

	thumb_local_start
sub_81434BA:
	push {r4-r7,lr}
	mov r0, #1
	bl TestPETMenuDataFlag
	bne loc_81434DC
	bl sub_8143088
	cmp r0, #0xff
	beq loc_81434DC
	bl ow_crowLessonGetTextId
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_81434DC
	mov r0, #0
	pop {r4-r7,pc}
loc_81434DC:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_81434E0:
	.word eStruct2001010
byte_81434E4:
	.byte 0xCC, 0x0, 0x38, 0xFF, 0x5, 0x5, 0x2, 0x0, 0x8C, 0x0, 0xF2, 0x0
	.byte 0x7, 0x7, 0x2, 0x0, 0x1C, 0x0, 0xBE, 0x0, 0x5, 0x5, 0x3, 0x0
	.byte 0x42, 0xFF, 0x28, 0x0, 0x7, 0x7, 0x3, 0x0, 0xEC, 0xFE, 0x24, 0xFF
	.byte 0x1, 0x1, 0x3, 0x0
byte_814350C:
	.byte 0x1E, 0x1, 0x6C, 0xFF, 0x3, 0x3, 0x2, 0x0, 0x54, 0x0, 0x72, 0x0
	.byte 0x5, 0x5, 0x2, 0x0, 0x6, 0x0, 0x5C, 0x1, 0x5, 0x5, 0x3, 0x0
	.byte 0xFE, 0xFD, 0x5C, 0x0, 0x3, 0x3, 0x2, 0x0
byte_814352C:
	.byte 0x5E, 0x1, 0x6A, 0xFF, 0x3, 0x3, 0x2, 0x0, 0x82, 0x0, 0x72, 0x1
	.byte 0x5, 0x5, 0x2, 0x0, 0x3A, 0xFF, 0xDA, 0x1, 0x1, 0x1, 0x3, 0x0
	.byte 0x9E, 0xFE, 0x78, 0x0, 0x7, 0x7, 0x2, 0x0, 0xA8, 0xFE, 0x10, 0x0
	.byte 0x1, 0x1, 0x2, 0x0, 0x52, 0x0, 0xA6, 0xFE, 0x7, 0x7, 0x3, 0x0
	.byte 0xA4, 0x0, 0x7E, 0xFE, 0x5, 0x5, 0x3, 0x0
byte_8143564:
	.byte 0xFE, 0x0, 0xCC, 0xFF, 0x7, 0x7, 0x2, 0x0, 0xA6, 0x0, 0xF2, 0x0
	.byte 0x5, 0x5, 0x2, 0x0, 0x24, 0x0, 0x40, 0x1, 0x7, 0x7, 0x3, 0x0
	.byte 0x82, 0xFE, 0x92, 0x1, 0x5, 0x5, 0x2, 0x0, 0x9E, 0xFE, 0x68, 0xFF
	.byte 0x3, 0x3, 0x2, 0x0, 0x9E, 0xFF, 0xC, 0xFF, 0x7, 0x7, 0x2, 0x0
	.byte 0x7E, 0x0, 0xC, 0xFF, 0x3, 0x3, 0x2, 0x0
byte_814359C:
	.byte 0xB4, 0x0, 0x42, 0xFF, 0x5, 0x5, 0x82, 0x0, 0xDE, 0x0, 0x7, 0x7
	.byte 0x8, 0x0, 0xB4, 0x0, 0x5, 0x5, 0x42, 0xFF, 0x14, 0x0, 0x7, 0x7
	.byte 0x0, 0xFF, 0x1A, 0xFF, 0x1, 0x1
byte_81435BA:
	.byte 0x14, 0x1, 0x80, 0xFF, 0x3, 0x3, 0x36, 0x0, 0x72, 0x0, 0x5, 0x5
	.byte 0xE6, 0xFF, 0x52, 0x1, 0x5, 0x5, 0xF4, 0xFD, 0x76, 0x0, 0x3, 0x3
byte_81435D2:
	.byte 0x54, 0x1, 0x7E, 0xFF, 0x3, 0x3, 0x6E, 0x0, 0x7C, 0x1, 0x5, 0x5
	.byte 0x48, 0xFF, 0xDA, 0x1, 0x1, 0x1, 0x94, 0xFE, 0x6A, 0x0, 0x7, 0x7
	.byte 0xB6, 0xFE, 0x1A, 0x0, 0x1, 0x1, 0x5A, 0x0, 0xBA, 0xFE, 0x3, 0x3
	.byte 0xB8, 0x0, 0x76, 0xFE, 0x1, 0x1
byte_81435FC:
	.byte 0xF4, 0x0, 0xB8, 0xFF, 0x7, 0x7, 0x92, 0x0, 0xFC, 0x0, 0x5, 0x5
	.byte 0x24, 0x0, 0x32, 0x1, 0x7, 0x7, 0x96, 0xFE, 0x9C, 0x1, 0x1, 0x1
	.byte 0x94, 0xFE, 0x7C, 0xFF, 0x3, 0x3, 0x94, 0xFF, 0x20, 0xFF, 0x3, 0x3
	.byte 0x74, 0x0, 0x20, 0xFF, 0x3, 0x3, 0x0, 0x0
byte_8143628:
	.byte 0xCC, 0x0, 0x14, 0xFF, 0x5, 0x5, 0xA8, 0x0, 0xF2, 0x0, 0x1, 0x1
	.byte 0x1C, 0x0, 0xF3, 0x0, 0x3, 0x3, 0xE, 0xFF, 0x32, 0x0, 0x5, 0x5
	.byte 0xEC, 0xFE, 0x52, 0xFF, 0x3, 0x3
byte_8143646:
	.byte 0x44, 0x1, 0x6C, 0xFF, 0x3, 0x3, 0x54, 0x0, 0x54, 0x0, 0x7, 0x7
	.byte 0x6, 0x0, 0x8E, 0x1, 0x1, 0x1, 0x22, 0xFE, 0x5C, 0x0, 0x1, 0x1
byte_814365E:
	.byte 0x84, 0x1, 0x6A, 0xFF, 0x3, 0x3, 0x86, 0x0, 0x52, 0x1, 0x7, 0x7
	.byte 0x2, 0xFF, 0xDA, 0x1, 0x5, 0x5, 0xBC, 0xFE, 0x7A, 0x0, 0x1, 0x1
	.byte 0xA6, 0xFE, 0xF2, 0xFF, 0x7, 0x7, 0x26, 0x0, 0xAA, 0xFE, 0x5, 0x5
	.byte 0xA4, 0x0, 0xA8, 0xFE, 0x3, 0x3
byte_8143688:
	.byte 0x26, 0x1, 0xCC, 0xFF, 0x3, 0x3, 0xA6, 0x0, 0xCC, 0x0, 0x1, 0x1
	.byte 0x24, 0x0, 0x70, 0x1, 0x5, 0x5, 0x82, 0xFE, 0x66, 0x1, 0x7, 0x7
	.byte 0xC8, 0xFE, 0x66, 0xFF, 0x1, 0x1, 0xC4, 0xFF, 0xC, 0xFF, 0x3, 0x3
	.byte 0xA4, 0x0, 0xC, 0xFF, 0x1, 0x1, 0x0, 0x0
byte_81436B4:
	.byte 0x0, 0x20, 0x1, 0x0, 0x3C, 0x0, 0xC8, 0x0, 0x9E, 0xFF, 0x3C
	.byte 0x0, 0x2, 0x0, 0x0, 0x0
byte_81436C4:
	.byte 0x0, 0x20, 0x2, 0x0, 0x2D, 0x0, 0xA0, 0x0, 0x28, 0x0, 0xA0, 0x0
	.byte 0x2, 0x0, 0x0, 0x0, 0x0, 0x20, 0x2, 0x0, 0x2D, 0x0, 0xA0, 0x0
	.byte 0x6, 0xFF, 0x8E, 0x0, 0x2, 0x0, 0x0, 0x0
byte_81436E4:
	.byte 0x0, 0x80, 0x2, 0x0, 0x28, 0x0, 0x8C, 0x0, 0xBC, 0x0, 0x8E, 0x0
	.byte 0x2, 0x0, 0x0, 0x0, 0x0, 0x80, 0x2, 0x0, 0x28, 0x0, 0x8C, 0x0
	.byte 0x3E, 0xFF, 0x14, 0x1, 0x2, 0x0, 0x0, 0x0
byte_8143704:
	.byte 0x0, 0x80, 0x2, 0x0, 0x28, 0x0, 0x8C, 0x0, 0x50, 0xFF, 0xF2
	.byte 0x0, 0x2, 0x0, 0x0, 0x0, 0x0, 0x80, 0x2, 0x0, 0x28, 0x0
	.byte 0x8C, 0x0, 0xC0, 0x0, 0x6A, 0xFF, 0x2, 0x0, 0x0, 0x0
byte_8143724:
	.byte 0xAE, 0x0, 0x32, 0x0, 0x40, 0x0, 0x0, 0x4, 0x54, 0x0, 0xCE, 0xFF
	.byte 0x40, 0x0, 0x1, 0x0, 0x96, 0xFF, 0xC0, 0xFF, 0x40, 0x0, 0x1, 0x1
	.byte 0x94, 0xFF, 0x1E, 0x0, 0x40, 0x0, 0x1, 0x2, 0x4, 0x0, 0x9E, 0x0
	.byte 0x40, 0x0, 0x1, 0x3, 0x2E, 0xFF, 0xB8, 0x0, 0x40, 0x0, 0x1, 0x6
	.byte 0xAC, 0xFE, 0xF4, 0x0, 0x40, 0x0, 0x0, 0x5
byte_814375C:
	.byte 0x26, 0x1, 0xAA, 0x0, 0x40, 0x0, 0x0, 0x4, 0x54, 0x0, 0x3E, 0x0
	.byte 0x40, 0x0, 0x1, 0x0, 0x64, 0xFF, 0xAC, 0xFF, 0x40, 0x0, 0x0, 0x5
	.byte 0xE2, 0xFF, 0xD6, 0xFF, 0x40, 0x0, 0x1, 0x6, 0xC8, 0xFE, 0xF8, 0xFF
	.byte 0x40, 0x0, 0x1, 0x2, 0xD0, 0xFE, 0xBC, 0x0, 0x40, 0x0, 0x1, 0x3
	.byte 0x38, 0x0, 0xE2, 0x0, 0x40, 0x0, 0x1, 0x1
byte_8143794:
	.byte 0xA4, 0xFF, 0xCC, 0x1, 0x40, 0x0, 0x0, 0x4, 0xA2, 0xFF, 0x70
	.byte 0x0, 0x40, 0x0, 0x0, 0x5, 0xC2, 0x0, 0x4C, 0xFF, 0x40, 0x0
	.byte 0x0, 0x6, 0xDC, 0x0, 0xAA, 0x0, 0x40, 0x0, 0x1, 0x0, 0x42
	.byte 0xFF, 0xCE, 0x0, 0x40, 0x0, 0x1, 0x1, 0x26, 0xFF, 0x5A, 0xFF
	.byte 0x40, 0x0, 0x1, 0x2, 0x0, 0x0, 0x0, 0x0, 0x40, 0x0, 0x1
	.byte 0x3
byte_81437CC:
	.byte 0xE6, 0x0, 0x4C, 0x0, 0x40, 0x0, 0x0, 0x3, 0xC2, 0xFF, 0xD0
	.byte 0x0, 0x40, 0x0, 0x0, 0x4, 0x62, 0xFE, 0xD0, 0xFF, 0x40, 0x0
	.byte 0x0, 0x5, 0xF4, 0xFE, 0x4A, 0xFF, 0x40, 0x0, 0x0, 0x6, 0x16
	.byte 0xFF, 0xA, 0x1, 0x40, 0x0, 0x1, 0x0, 0x18, 0xFF, 0xAC, 0xFF
	.byte 0x40, 0x0, 0x1, 0x1, 0xC8, 0x0, 0x8A, 0xFF, 0x40, 0x0, 0x1
	.byte 0x2
off_8143804:
	.word byte_8143814
	.word byte_81438D0
off_814380C:
	.word byte_81438B8
	.word byte_8143960
byte_8143814:
	.byte 0x0, 0xFF, 0x78, 0x7B, 0x1, 0xFF, 0x78, 0x7C, 0x2, 0xFF
	.byte 0x78, 0x7D, 0x3, 0xFF, 0x78, 0x7E, 0x4, 0xFF, 0x76, 0x82
	.byte 0x5, 0xFF, 0x77, 0x82, 0x6, 0xFF, 0x78, 0x82, 0x7, 0xFF
	.byte 0x77, 0x86, 0x8, 0xFF, 0x78, 0x86, 0x9, 0xFF, 0x7D, 0x83
	.byte 0xA, 0xFF, 0x7D, 0x84, 0xB, 0xFF, 0x7D, 0x85, 0xC, 0xFF
	.byte 0x7E, 0x82, 0xD, 0xFF, 0x7E, 0x83, 0xE, 0xFF, 0x7E, 0x85
	.byte 0xF, 0xFF, 0x7F, 0x82, 0x10, 0xFF, 0x7F, 0x83, 0x11, 0xFF
	.byte 0x7F, 0x84, 0x12, 0xFF, 0x7F, 0x85, 0x13, 0xFF, 0x82, 0x86
	.byte 0x14, 0xFF, 0x82, 0x87, 0x15, 0xFF, 0x86, 0x83, 0x16, 0xFF
	.byte 0x86, 0x82, 0x17, 0xFF, 0x82, 0x7F, 0x18, 0xFF, 0x83, 0x7E
	.byte 0x19, 0xFF, 0x84, 0x7E, 0x1A, 0xFF, 0x83, 0x7F, 0x1B, 0xFF
	.byte 0x84, 0x7F, 0x1C, 0xFF, 0x85, 0x7E, 0x1D, 0xFF, 0x86, 0x7E
	.byte 0x1E, 0xFF, 0x86, 0x7A, 0x1F, 0xFF, 0x86, 0x7B, 0x20, 0xFF
	.byte 0x86, 0x7C, 0x21, 0xFF, 0x81, 0x77, 0x22, 0xFF, 0x82, 0x77
	.byte 0x23, 0xFF, 0x83, 0x77, 0x24, 0xFF, 0x7F, 0x79, 0x25, 0xFF
	.byte 0x7F, 0x7A, 0x26, 0xFF, 0x7B, 0x76, 0x27, 0xFF, 0x7C, 0x76
	.byte 0xFF, 0x28, 0x0, 0x0
byte_81438B8:
	.byte 0x86, 0x84
	.byte 0x86, 0x79
	.byte 0x80, 0x77
	.byte 0x7E, 0x84
	.byte 0x76, 0x86
	.byte 0x75, 0x82
	.byte 0x0, 0x0
	.byte 0x0, 0x0
	.byte 0x0, 0x0
	.byte 0x0, 0x0
	.byte 0xFF, 0xFF
	.byte 0x0, 0x0
byte_81438D0:
	.byte 0x0, 0xFF, 0x74, 0x87, 0x1, 0xFF, 0x75, 0x87, 0x2, 0xFF
	.byte 0x7A, 0x80, 0x3, 0xFF, 0x7B, 0x80, 0x4, 0xFF, 0x7C, 0x80
	.byte 0x5, 0xFF, 0x7D, 0x80, 0x6, 0xFF, 0x7D, 0x81, 0x7, 0xFF
	.byte 0x7D, 0x82, 0x8, 0xFF, 0x7D, 0x84, 0x9, 0xFF, 0x7D, 0x85
	.byte 0xA, 0xFF, 0x7F, 0x7F, 0xB, 0xFF, 0x7F, 0x81, 0xC, 0xFF
	.byte 0x7F, 0x82, 0xD, 0xFF, 0x81, 0x7F, 0xE, 0xFF, 0x81, 0x80
	.byte 0xF, 0xFF, 0x84, 0x80, 0x10, 0xFF, 0x84, 0x81, 0x11, 0xFF
	.byte 0x84, 0x82, 0x12, 0xFF, 0x85, 0x84, 0x13, 0xFF, 0x86, 0x84
	.byte 0x14, 0xFF, 0x81, 0x87, 0x15, 0xFF, 0x82, 0x87, 0x16, 0xFF
	.byte 0x87, 0x84, 0x17, 0xFF, 0x83, 0x87, 0x18, 0xFF, 0x84, 0x87
	.byte 0x19, 0xFF, 0x88, 0x84, 0x1A, 0xFF, 0x7D, 0x7B, 0x1B, 0xFF
	.byte 0x83, 0x7B, 0x1C, 0xFF, 0x80, 0x77, 0x1D, 0xFF, 0x81, 0x77
	.byte 0x1E, 0xFF, 0x82, 0x77, 0x1F, 0xFF, 0x84, 0x79, 0x20, 0xFF
	.byte 0x85, 0x79, 0x21, 0xFF, 0x86, 0x79, 0x22, 0xFF, 0x83, 0x79
	.byte 0xFF, 0x23, 0x0, 0x0
byte_8143960:
	.byte 0x7D, 0x7F
	.byte 0x79, 0x80
	.byte 0x7D, 0x83
	.byte 0x7F, 0x80
	.byte 0x7F, 0x83
	.byte 0x84, 0x7F
	.byte 0x0, 0x0
	.byte 0x0, 0x0
	.byte 0x0, 0x0
	.byte 0x0, 0x0
	.byte 0xFF, 0xFF
	.byte 0x0, 0x0
	thumb_func_end sub_81434BA

// symdb: Groundman minigame overworld tick: sets event flags 0x1670..0x169F, returns early if sub_8143C18's flag is set, updates a coordinate state, spawns overworld map object 0x2B for each per-map grid entry whose flag is unset, and if EVENT_D36 is set starts the cutscene script at byte_8093358 (param 0) before clearing D30/D34/D35/D36.
// symdb: () -> r0 = 0; no flags guaranteed — clears event flags 0x1670..0x169F, D30, D34, D35, D36 and
// symdb: spawns overworld map objects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_groundmanMinigameTick.yaml
	thumb_local_start
ow_groundmanMinigameTick:
	push {r4-r7,lr}
	movflag EVENT_1670
	mov r2, #0x30 
	bl SetEventFlagRangeFromImmediate // (u8 entryIdx, u8 byteFlagIdx, int numEntries) -> void
	bl get_groundmanMinigameMapId
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8143A46
	mov r1, r10
	ldr r1, [r1,#0x3c]
	ldrb r2, [r1,#4]
	ldrb r3, [r1,#0xc]
	ldrb r0, [r1,#5]
	ldrb r1, [r1,#0xd]
	lsl r0, r0, #2
	lsl r1, r1, #2
	push {r0-r3}
	movflag EVENT_D30
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	pop {r0-r3}
	bne loc_81439B6
	cmp r2, r3
	bne loc_81439B6
	cmp r0, r1
	beq loc_81439BE
loc_81439B6:
	push {r0-r7}
	bl sub_8143C30
	pop {r0-r7}
loc_81439BE:
	bl GetGroundmanMinigameMapIndex
	lsl r0, r0, #2
	ldr r7, off_8143A4C // =off_8143804 
	ldr r7, [r7,r0]
	mov r4, #0
loc_81439CA:
	ldrb r0, [r7]
	cmp r0, #0xff
	beq loc_8143A02
	mov r0, r4
	bl sub_8143B5E
	mov r6, r1
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_81439FC
	mov r0, r6
	bl ClearEventFlag // (u16 entryFlagBitfield) -> void
	push {r4-r7}
	ldrh r0, [r7,#2]
	bl ConvertGroundmanMinigameGridCoordsToMapCoords
	mov r3, r2
	mov r2, r1
	mov r1, r0
	mov r0, #0x2b 
	bl SpawnOverworldMapObject
	pop {r4-r7}
loc_81439FC:
	add r4, #1
	add r7, #4
	b loc_81439CA
loc_8143A02:
	ldrb r0, [r7,#1]
	bl sub_8143F58
	bl saveGroundmanMinigameData
	bl ow_switchGroundmanNpcList
	movflag EVENT_D36
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_8143A2E
	ldr r0, off_8143A50 // =byte_8093358 // CutsceneScript
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
	bl e_setCutsceneActive
	movflag EVENT_D36
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
loc_8143A2E:
	movflag EVENT_D30
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_D34
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_D35
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
loc_8143A46:
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_8143A4C:
	.word off_8143804
off_8143A50:
	.word byte_8093358 // CutsceneScript
	thumb_func_end ow_groundmanMinigameTick

// symdb: GroundMan minigame cutscene dispatcher: checks the player may auto-advance, progresses event flags D34/D35, then selects and starts one of several cutscenes (byte_8092DE8/byte_80933B8/dword_8143B1C table/byte_809326C) gated by sub_8143BB0, sub_8143D4C and sub_8143F72, always clearing D34/D35 on exit.
// symdb: () -> void; flags: event flags D34/D35 modified, ZF from check_playerCanAdvanceForward controls
// symdb: early exit
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_groundmanStartCutscene.yaml
	thumb_local_start
ow_groundmanStartCutscene:
	push {r4-r7,lr}
	bl check_playerCanAdvanceForward_8034C36
	beq loc_8143B04
	bl get_groundmanMinigameMapId
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8143B04
	movflag EVENT_D34
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_8143A86
	mov r3, r10
	ldr r3, [r3,#0x3c]
	ldrb r0, [r3,#0x11]
	tst r0, r0
	beq loc_8143AD6
	movflag EVENT_D34
	bl SetEventFlagFromImmediate
	b loc_8143AD6
loc_8143A86:
	movflag EVENT_D35
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_8143A9A
	movflag EVENT_D35
	bl SetEventFlagFromImmediate
	b loc_8143AD6
loc_8143A9A:
	bl sub_80357AE
	bne loc_8143AC6
	bl sub_8143DEA
	bl groundmanMinigameFindActiveEntry
	beq loc_8143AC6
	bl sub_8143EA4
	bl sub_8143BB0
	bne loc_8143ABE
	ldr r0, off_8143B24 // =byte_8092DE8 // CutsceneScript
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
	b loc_8143AC6
loc_8143ABE:
	ldr r0, off_8143B2C // =byte_80933B8 // CutsceneScript
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
loc_8143AC6:
	movflag EVENT_D34
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_D35
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
loc_8143AD6:
	bl countSetEventFlags
	cmp r0, r1
	bne loc_8143AF0
	bl GetGroundmanMinigameMapIndex
	ldr r1, off_8143B18 // =dword_8143B1C // [*const CutsceneScript; 2]
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	mov r1, #0
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
	bne loc_8143B04
loc_8143AF0:
	bl sub_8143F72
	bne locret_8143B14
	bl GetGroundmanMinigameMapIndex
	mov r1, r0
	ldr r0, off_8143B28 // =byte_809326C // CutsceneScript
	bl StartCutscene // (script: *const CutsceneScript, param: u32) -> ()
	bne loc_8143B04
loc_8143B04:
	movflag EVENT_D34
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	movflag EVENT_D35
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
locret_8143B14:
	pop {r4-r7,pc}
	.balign 4, 0
off_8143B18:
	.word dword_8143B1C // [*const CutsceneScript; 2]
dword_8143B1C: // [*const CutsceneScript; 2]
	.word cutscenescript_8092C78
	.word byte_8092A98
off_8143B24:
	.word byte_8092DE8 // CutsceneScript
off_8143B28:
	.word byte_809326C // CutsceneScript
off_8143B2C:
	.word byte_80933B8 // CutsceneScript
	thumb_func_end ow_groundmanStartCutscene

	thumb_local_start
GetGroundmanMinigameMapIndex:
	push {r4-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	ldrh r7, [r7,#oGameState_MapGroup]
	mov r6, #0
	ldr r4, =GroundmanMinigameMaps 
.findMapLoop
	ldrh r0, [r4,r6]
	tst r0, r0
	beq .mapNotFound
	cmp r0, r7
	beq .mapFound
	add r6, #2
	b .findMapLoop
.mapFound
	lsr r0, r6, #1
	tst r0, r0
	pop {r4-r7,pc}
.mapNotFound
	mov r0, #0xff
	pop {r4-r7,pc}
	.balign 4, 0
	.pool // 8143B54
GroundmanMinigameMaps:
	map_id CENTRAL_AREA1
	map_id CENTRAL_AREA2
	.hword 0
	thumb_func_end GetGroundmanMinigameMapIndex

	thumb_func_start sub_8143B5E
sub_8143B5E:
	push {r4-r7,lr}
	mov r4, r0
	bl GetGroundmanMinigameMapIndex
	lsl r3, r0, #1
	ldr r0, off_8143B78 // =dword_8143B7C 
	ldrh r0, [r0,r3]
	add r0, r0, r4
	ldr r1, off_8143B80 // =dword_8143B84 
	ldrh r1, [r1,r3]
	add r1, r1, r4
	pop {r4-r7,pc}
	.balign 4, 0
off_8143B78:
	.word dword_8143B7C
dword_8143B7C:
	.word 0xD680D38
off_8143B80:
	.word dword_8143B84
dword_8143B84:
	.word 0x16701670
	thumb_func_end sub_8143B5E

	thumb_func_start GetGroundmanMinigameProgGridCoordsAndTextScriptIndex
GetGroundmanMinigameProgGridCoordsAndTextScriptIndex:
	push {r4-r7,lr}
	mov r4, r0
	bl GetGroundmanMinigameMapIndex
	lsl r0, r0, #2
	ldr r3, off_8143BEC // =groundmanMinigameMapActiveFlags_8143bf0 
	ldr r3, [r3,r0]
	sub r2, r4, r3

	ldr r7, off_8143BAC // =off_814380C 
	ldr r7, [r7,r0]
	lsl r1, r2, #1
	ldrh r1, [r7,r1]

	ldr r7, groundmanMinigameMapActiveFlags_8143bf0 // =EVENT_D98
	sub r2, r4, r7
	add r2, #0x14
	mov r0, r4
	pop {r4-r7,pc}
	.balign 4, 0
off_8143BAC:
	.word off_814380C
	thumb_func_end GetGroundmanMinigameProgGridCoordsAndTextScriptIndex

	thumb_func_start sub_8143BB0
sub_8143BB0:
	push {r4-r7,lr}
	mov r4, r0
	bl GetGroundmanMinigameMapIndex
	lsl r0, r0, #2
	ldr r7, off_8143BF8 // =off_814380C 
	ldr r7, [r7,r0]
	ldr r5, off_8143BEC // =groundmanMinigameMapActiveFlags_8143bf0 
	ldr r5, [r5,r0]
	mov r6, #0
	mvn r6, r6
	lsr r6, r6, #0x10
loc_8143BC8:
	ldrh r0, [r7]
	cmp r0, r6
	beq loc_8143BE8
	tst r0, r0
	beq loc_8143BE2
	cmp r0, r4
	bne loc_8143BE2
	mov r0, r5
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8143BE8
	mov r0, #1
	pop {r4-r7,pc}
loc_8143BE2:
	add r5, #1
	add r7, #2
	b loc_8143BC8
loc_8143BE8:
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_8143BEC:
	.word groundmanMinigameMapActiveFlags_8143bf0
groundmanMinigameMapActiveFlags_8143bf0:
	.word EVENT_D98, EVENT_DA2
off_8143BF8:
	.word off_814380C
	thumb_func_end sub_8143BB0

	thumb_local_start
sub_8143BFC:
	push {r4-r7,lr}
	bl GetGroundmanMinigameMapIndex
	ldr r1, off_8143C0C // =byte_8143C10 
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	pop {r4-r7,pc}
	.balign 4, 0
off_8143C0C:
	.word byte_8143C10
byte_8143C10:
	.byte 0x78, 0x1E, 0x0, 0x0, 0x4C, 0x1D, 0x0, 0x0
	thumb_func_end sub_8143BFC

// symdb: Returns a map ID (0xD32 or 0xD33) looked up from the current Groundman minigame map index.
// symdb: () -> r0 = halfword map ID from table dword_8143C2C indexed by GetGroundmanMinigameMapIndex;
// symdb: flags from ldrh
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/get_groundmanMinigameMapId.yaml
	thumb_local_start
get_groundmanMinigameMapId:
	push {r4-r7,lr}
	bl GetGroundmanMinigameMapIndex
	ldr r1, off_8143C28 // =dword_8143C2C 
	lsl r0, r0, #1
	ldrh r0, [r1,r0]
	pop {r4-r7,pc}
	.balign 4, 0
off_8143C28:
	.word dword_8143C2C
dword_8143C2C:
	.word 0xD330D32
	thumb_func_end get_groundmanMinigameMapId

	thumb_local_start
sub_8143C30:
	push {r4-r7,lr}
	bl e_resetEffectStruct
	mov r0, #0
	bl sub_8143B5E
	mov r0, r0
	mov r2, #0x30 
	bl ClearEventFlagRange // (u16 entryFlagBitfield) -> void
	movflag EVENT_D98
	mov r2, #0xa
	bl ClearEventFlagRangeFromImmediate // (u8 entryIdx, u8 byteFlagIdx, int numEntries) -> void
	movflag EVENT_DA2
	mov r2, #0xa
	bl ClearEventFlagRangeFromImmediate // (u8 entryIdx, u8 byteFlagIdx, int numEntries) -> void
	bl sub_8143BFC
	bl e_setFieldC
	pop {r4-r7,pc}
	thumb_func_end sub_8143C30

// symdb: Looks up the Groundman minigame result map index, swaps the overworld NPC spawn list to one of two hardcoded lists via npc_freeAllObjectsThenSpawnObjectsFromList, then sets event flag 1721.
// symdb: () -> r0 = undefined; sets EVENT_1721, replaces overworld NPC list via
// symdb: npc_freeAllObjectsThenSpawnObjectsFromList
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_switchGroundmanNpcList.yaml
	thumb_local_start
ow_switchGroundmanNpcList:
	push {r4-r7,lr}
	bl GetGroundmanMinigameMapIndex
	ldr r1, off_8143C7C // =off_8143C80 
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	bl npc_freeAllObjectsThenSpawnObjectsFromList // (ptr: [*const NPCScript]) -> ()
	movflag EVENT_1721
	bl SetEventFlagFromImmediate
	pop {r4-r7,pc}
	.balign 4, 0
off_8143C7C:
	.word off_8143C80
off_8143C80:
	.word off_8072C10
	.word off_8073650
	thumb_func_end ow_switchGroundmanNpcList

// symdb: Saves current GroundMan minigame progress for the active map index: sets the BBS request flag (0x7 of event byte 0x17) and EVENT_1BB, then walks the map's 8-byte entry table at off_8143D0C, copying each entry's +4 32-bit value into unk_2011EA0[id*4] and setting event flag 0x16F0+id for each nonzero entry, returning 0.
// symdb: (no meaningful args) -> r0 = 0; sets EVENT_1BB and event flags 0x16F0+item
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/saveGroundmanMinigameData.yaml
	thumb_local_start
saveGroundmanMinigameData:
	push {r4-r7,lr}
	bl reqBBS_setFlag_e17b0f7_8140A00
	movflag EVENT_1BB
	bl SetEventFlagFromImmediate
	bl GetGroundmanMinigameMapIndex
	ldr r4, off_8143D08 // =off_8143D0C 
	lsl r0, r0, #2
	ldr r4, [r4,r0]
loc_8143CA0:
	ldrb r0, [r4]
	tst r0, r0
	beq loc_8143CC4
	ldr r1, off_8143D44 // =unk_2011EA0 
	mov r2, #4
	mul r0, r2
	add r1, r1, r0
	ldr r0, [r4,#4]
	str r0, [r1]
	ldr r0, dword_8143D48 // =0x16f1 
	ldrb r1, [r4]
	sub r1, #1
	add r0, r0, r1
	mov r0, r0
	bl SetEventFlag
	add r4, #8
	b loc_8143CA0
loc_8143CC4:
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end saveGroundmanMinigameData

// symdb: Clears BBS flag, event flag 0x1BB, then for the selected groundman minigame map table, zeros per-slot records at unk_2011EA0+index*4 and clears event flags 0x16F0+index for each nonzero entry.
// symdb: () -> r0 = 0; no flags relevant
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/clearGroundmanMinigameState.yaml
	thumb_local_start
clearGroundmanMinigameState:
	push {r4-r7,lr}
	bl reqBBS_clearFlag_8140A0C
	movflag EVENT_1BB
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	bl GetGroundmanMinigameMapIndex
	ldr r4, off_8143D08 // =off_8143D0C 
	lsl r0, r0, #2
	ldr r4, [r4,r0]
loc_8143CE0:
	ldrb r0, [r4]
	tst r0, r0
	beq loc_8143D04
	ldr r1, off_8143D44 // =unk_2011EA0 
	mov r2, #4
	mul r0, r2
	add r1, r1, r0
	mov r0, #0
	str r0, [r1]
	ldr r0, dword_8143D48 // =0x16f1 
	ldrb r1, [r4]
	sub r1, #1
	add r0, r0, r1
	mov r0, r0
	bl ClearEventFlag // (u16 entryFlagBitfield) -> void
	add r4, #8
	b loc_8143CE0
loc_8143D04:
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_8143D08:
	.word off_8143D0C
off_8143D0C:
	.word byte_8143D14
	.word byte_8143D30
byte_8143D14:
	.byte 0x1, 0xFF, 0xFF, 0xFF, 0x2, 0x14, 0xFF, 0x8, 0x4, 0xFF, 0xFF
	.byte 0xFF, 0x2, 0x14, 0x5, 0x8, 0x5, 0xFF, 0xFF, 0xFF, 0x2, 0x14
	.byte 0xFF, 0x8, 0x0, 0x0, 0x0, 0x0
byte_8143D30:
	.byte 0x1, 0xFF, 0xFF, 0xFF, 0x2, 0x14, 0x1, 0x8, 0x2, 0xFF, 0xFF
	.byte 0xFF, 0x2, 0x14, 0x3, 0x8, 0x0, 0x0, 0x0, 0x0
off_8143D44:
	.word unk_2011EA0
dword_8143D48:
	.word 0x16F1
	thumb_func_end clearGroundmanMinigameState

// symdb: Counts how many event flags in a dynamic list are currently set, returning the set count (r0) and total list size (r1).
// symdb: () -> r0 = number of set flags, r1 = total number of flags in the list; Z set if count is 0
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/countSetEventFlags.yaml
	thumb_func_start countSetEventFlags
countSetEventFlags:
	push {r4-r7,lr}
	bl get_eStruct2001010Field10
	mov r7, r0
	mov r4, #0
	mov r6, #0
loc_8143D58:
	mov r0, r4
	bl sub_8143B5E
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_8143D68
	add r6, #1
loc_8143D68:
	add r4, #1
	cmp r4, r7
	blt loc_8143D58
	bl get_eStruct2001010Field10
	mov r1, r0
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end countSetEventFlags

	thumb_local_start
sub_8143D7A:
	push {r4-r7,lr}
	push {r0,r1}
	bl GetGroundmanMinigameGridOffsetsForMap
	pop {r3,r4}
	asr r3, r3, #0x10
	asr r4, r4, #0x10
	add r0, r0, r3
	add r1, r1, r4
	asr r0, r0, #5
	asr r1, r1, #5
	add r0, #0x80
	add r1, #0x80
	mov r5, #0x80
	lsl r5, r5, #1
	mul r1, r5
	add r0, r0, r1
	pop {r4-r7,pc}
	thumb_func_end sub_8143D7A

	thumb_local_start
// get the map coordinate grid offsets of the current map
// offsets that are added to scaled grid coordinates
// to align with the map grid visually
GetGroundmanMinigameGridOffsetsForMap:
	push {r4-r7,lr}
	bl GetGroundmanMinigameMapIndex
	ldr r3, =GroundmanMinigameMapBasedGridOffsets 
	lsl r0, r0, #1
	add r3, r3, r0
	mov r0, #0
	ldrsb r0, [r3,r0]
	mov r1, #1
	ldrsb r1, [r3,r1]
	pop {r4-r7,pc}
	.balign 4, 0
	.pool // 8143DB4
GroundmanMinigameMapBasedGridOffsets:
	.byte 0, 0
	.byte 8, -8
	thumb_func_end GetGroundmanMinigameGridOffsetsForMap

	thumb_func_start ConvertGroundmanMinigameGridCoordsToMapCoords
// convert groundman minigame grid coordinates to map coordinates
ConvertGroundmanMinigameGridCoordsToMapCoords:
	push {r4-r7,lr}
	mov r1, #0x80
	lsl r1, r1, #1 // r1 = 0x100
	svc 6
	mov r2, r0
	mov r0, r1
	mov r1, r2
	sub r0, #0x80
	sub r1, #0x80
	lsl r0, r0, #5
	lsl r1, r1, #5
	push {r0,r1}
	bl GetGroundmanMinigameGridOffsetsForMap
	pop {r3,r4}
	sub r0, r3, r0
	sub r1, r4, r1
	add r0, #0x10
	add r1, #0x10
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	mov r2, #0
	pop {r4-r7,pc}
	thumb_func_end ConvertGroundmanMinigameGridCoordsToMapCoords

	thumb_func_start sub_8143DEA
sub_8143DEA:
	push {r4-r7,lr}
	sub sp, sp, #0x10
	bl sub_8143EA4
	mov r4, r0
	bl GetOWPlayerFacingDirection
	mov r1, #1
	tst r0, r1
	beq loc_8143E0C
	mov r1, r0
	mov r0, r4
	mov r2, #1
	bl grid_stepPackedTileCoordsInDirection
	add sp, sp, #0x10
	pop {r4-r7,pc}
loc_8143E0C:
	sub r1, r0, #1
	add r7, r0, #1
	mov r0, #7
	and r7, r0
	and r1, r0
	mov r0, r4
	mov r2, #1
	bl grid_stepPackedTileCoordsInDirection
	mov r6, r0
	mov r0, r4
	mov r1, r7
	mov r2, #1
	bl grid_stepPackedTileCoordsInDirection
	mov r7, r0
	bl ReadOWPlayerObjectCoords
	str r0, [sp]
	str r1, [sp,#4]
	mov r0, r6
	bl ConvertGroundmanMinigameGridCoordsToMapCoords
	ldr r2, [sp]
	ldr r3, [sp,#4]
	sub r0, r0, r2
	sub r1, r1, r3
	bl calc_hypotFixed12
	str r0, [sp,#8]
	mov r0, r7
	bl ConvertGroundmanMinigameGridCoordsToMapCoords
	ldr r2, [sp]
	ldr r3, [sp,#4]
	sub r0, r0, r2
	sub r1, r1, r3
	bl calc_hypotFixed12
	ldr r1, [sp,#8]
	cmp r0, r1
	ble loc_8143E62
	mov r7, r6
loc_8143E62:
	mov r0, r7
	add sp, sp, #0x10
	pop {r4-r7,pc}
	thumb_func_end sub_8143DEA

// symdb: Steps a packed (x|y<<8) tile coordinate n tiles in a facing direction using a per-direction (dx,dy) table.
// symdb: (r0 = packed coords (low byte x, high byte y), r1 = direction index 0-7, r2 = step count) -> r0
// symdb: = packed coords moved (x + dx*n, y + dy*n)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/grid_stepPackedTileCoordsInDirection.yaml
	thumb_func_start grid_stepPackedTileCoordsInDirection
grid_stepPackedTileCoordsInDirection:
	push {r4-r7,lr}
	mov r6, r2
	ldr r7, off_8143E90 // =byte_8143E94 
	lsl r1, r1, #1
	add r7, r7, r1
	mov r4, r0
	mov r0, #0xff
	and r0, r4
	lsr r1, r4, #8
	mov r2, #0
	ldrsb r2, [r7,r2]
	mov r3, #1
	ldrsb r3, [r7,r3]
	mul r2, r6
	mul r3, r6
	add r0, r0, r2
	add r1, r1, r3
	lsl r1, r1, #8
	orr r0, r1
	pop {r4-r7,pc}
off_8143E90:
	.word byte_8143E94
byte_8143E94:
	.byte 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0xFF, 0x0, 0x0, 0x0, 0x0, 0xFF
	thumb_func_end grid_stepPackedTileCoordsInDirection

	thumb_func_start sub_8143EA4
sub_8143EA4:
	push {r4-r7,lr}
	bl ReadOWPlayerObjectCoords
	bl sub_8143D7A
	pop {r4-r7,pc}
	thumb_func_end sub_8143EA4

// symdb: Returns an 8-way direction index pointing from one Groundman-minigame grid cell to another.
// symdb: (r0 = packed grid coords of point A, r1 = packed grid coords of point B) -> r0 = direction 0-7
// symdb: from A to B; flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/groundmanMinigameGridDirBetween.yaml
	thumb_func_start groundmanMinigameGridDirBetween
groundmanMinigameGridDirBetween:
	push {r4-r7,lr}
	mov r4, r1
	bl ConvertGroundmanMinigameGridCoordsToMapCoords
	push {r0,r1}
	mov r0, r4
	bl ConvertGroundmanMinigameGridCoordsToMapCoords
	pop {r2,r3}
	sub r0, r0, r2
	sub r1, r3, r1
	bl calcAngle_800117C
	add r0, #0x10
	lsr r0, r0, #4
	mov r1, #0xf
	and r0, r1
	lsr r0, r0, #1
	sub r0, #1
	mov r1, #7
	and r0, r1
	pop {r4-r7,pc}
	thumb_func_end groundmanMinigameGridDirBetween

// symdb: Looks up the Groundman minigame's per-map entry table and returns the list index of the first entry whose event flag is still unset and whose u16 field matches the given value.
// symdb: (r0 = value to match against entry halfword, e.g. an id/position in the current minigame map) ->
// symdb: r0 = 1 if a match found else 0, r1 = matching list index or 0xFF if none; flags clobbered by bl
// symdb: calls
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/groundmanMinigameFindActiveEntry.yaml
	thumb_func_start groundmanMinigameFindActiveEntry
groundmanMinigameFindActiveEntry:
	push {r4-r7,lr}
	mov r6, r0
	bl GetGroundmanMinigameMapIndex
	lsl r0, r0, #2
	ldr r7, off_8143F18 // =off_8143804 
	ldr r7, [r7,r0]
	mov r4, #0
loc_8143EEC:
	ldrb r0, [r7]
	cmp r0, #0xff
	beq loc_8143F12
	mov r0, r4
	bl sub_8143B5E
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8143F0C
	ldrh r0, [r7,#2]
	cmp r0, r6
	bne loc_8143F0C
	mov r1, r4
	mov r0, #1
	pop {r4-r7,pc}
loc_8143F0C:
	add r4, #1
	add r7, #4
	b loc_8143EEC
loc_8143F12:
	mov r1, #0xff
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_8143F18:
	.word off_8143804
	thumb_func_end groundmanMinigameFindActiveEntry

	thumb_local_start
sub_8143F1C:
	push {r4-r7,lr}
	pop {r4-r7,pc}
	thumb_func_end sub_8143F1C

// symdb: Initializes the eStruct2001010 effect state: selects effect type 5 and clears its 0x40-byte data block.
// symdb: () -> r0 = 0; no flags meaningful
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_resetEffectStruct.yaml
	thumb_local_start
e_resetEffectStruct:
	push {r4-r7,lr}
	mov r0, #5
	bl initMinigameEffect_8003a64
	ldr r5, off_81440D4 // =eStruct2001010 
	mov r0, r5
	// memBlock
	add r0, #8
	// size
	mov r1, #0x40 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end e_resetEffectStruct

// symdb: sets the cutscene/event-active flag byte in the global event state struct (entry point sets 1; the call_8143F3C entry sets 0)
// symdb: (no args) -> r0 = 0; writes byte_2001019 (eStruct2001010+9) = 1, or 0 when entered at
// symdb: call_8143F3C
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_setCutsceneActive.yaml
	thumb_local_start
e_setCutsceneActive:
	mov r0, #1
	b loc_8143F3E
call_8143F3C::
	mov r0, #0
loc_8143F3E:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	strb r0, [r5,#0x9] // (byte_2001019 - 0x2001010)
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end e_setCutsceneActive

	thumb_local_start
sub_8143F48:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	strb r0, [r5,#0x8] // (byte_2001018 - 0x2001010)
	pop {r4-r7,pc}
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	ldrb r0, [r5,#0x8] // (byte_2001018 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end sub_8143F48

	thumb_local_start
sub_8143F58:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	str r0, [r5,#0x10] // (dword_2001020 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end sub_8143F58

// symdb: Trivial getter returning the dword at offset 0x10 of the eStruct2001010 structure.
// symdb: () -> r0 = *(u32*)(eStruct2001010+0x10)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/get_eStruct2001010Field10.yaml
	thumb_local_start
get_eStruct2001010Field10:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	ldr r0, [r5,#0x10] // (dword_2001020 - 0x2001010)
	pop {r4-r7,pc}
	thumb_func_end get_eStruct2001010Field10

// symdb: Stores a 0/1 enable-disable word into field 0xC of the global struct at 0x2001010.
// symdb: (r0 = value (observed 0 or 1)) -> r0 = value; Z flag set per tst r0,r0 (unused by callers)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_setFieldC.yaml
	thumb_func_start e_setFieldC
e_setFieldC:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	str r0, [r5,#0xc] // (dword_200101C - 0x2001010)
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end e_setFieldC

	thumb_func_start sub_8143F72
sub_8143F72:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	ldr r0, [r5,#0xc] // (dword_200101C - 0x2001010)
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_8143F72

// symdb: Ticks down a countdown counter in eStruct2001010 while a fade is active in a specific subsystem, unless a flag byte blocks it.
// symdb: () -> r0 = undefined; no flags relied on; reads caller's r5 as a structure pointer
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_decrementCountdown.yaml
	thumb_local_start
e_decrementCountdown:
	push {r4-r7,lr}
	ldrb r0, [r5,#9]
	tst r0, r0
	bne locret_8143F8E
	ldr r5, off_81440D4 // =eStruct2001010 
	ldr r0, [r5,#0xc] // (dword_200101C - 0x2001010)
	sub r0, #1
	blt locret_8143F8E
	str r0, [r5,#0xc] // (dword_200101C - 0x2001010)
locret_8143F8E:
	pop {r4-r7,pc}
	thumb_func_end e_decrementCountdown

	thumb_func_start sub_8143F90
sub_8143F90:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	bl sub_8143F72
	mov r4, r0
	bl sub_8143BFC
	mov r1, r0
	mov r0, #0x28 
	lsl r0, r0, #0x10
	svc 6
	mul r0, r4
	pop {r4-r7,pc}
	thumb_func_end sub_8143F90

// symdb: Initializes fields at +0x14/+0x18/+0x1C of the state struct eStruct2001010 before the caller enters state 0xC.
// symdb: () -> r0 = 0; writes dword_2001024 = 0, dword_2001028 = 0, dword_200102C = 0x2000; clobbers
// symdb: r4-r7
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/e_resetStateFields.yaml
	thumb_func_start e_resetStateFields
e_resetStateFields:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	mov r0, #0
	str r0, [r5,#0x14] // (dword_2001024 - 0x2001010)
	ldr r0, dword_8143FBC // =0x0 
	str r0, [r5,#0x18] // (dword_2001028 - 0x2001010)
	ldr r0, dword_8143FC0 // =0x2000 
	str r0, [r5,#0x1c] // (dword_200102C - 0x2001010)
	pop {r4-r7,pc}
dword_8143FBC:
	.word 0x0
dword_8143FC0:
	.word 0x2000
	thumb_func_end e_resetStateFields

	thumb_func_start sub_8143FC4
sub_8143FC4:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	ldr r0, [r5,#0x14] // (dword_2001024 - 0x2001010)
	cmp r0, #0
	bne loc_8143FD6
	mov r0, #0xb9
	add r0, #0xff
	bl PlaySoundEffect
loc_8143FD6:
	ldr r0, [r5,#0x14] // (dword_2001024 - 0x2001010)
	ldr r1, [r5,#0x18] // (dword_2001028 - 0x2001010)
	ldr r2, [r5,#0x1c] // (dword_200102C - 0x2001010)
	add r0, r0, r1
	add r1, r1, r2
	cmp r0, #0
	blt loc_8143FF6
	mov r3, #0x64 
	lsl r3, r3, #0x10
	cmp r0, r3
	blt loc_8143FFE
	mov r0, #0x64 
	lsl r0, r0, #0x10
	neg r1, r1
	add r1, r1, r2
	b loc_8143FFE
loc_8143FF6:
	mov r0, #0
	lsl r0, r0, #0x10
	neg r1, r1
	add r1, r1, r2
loc_8143FFE:
	str r0, [r5,#0x14] // (dword_2001024 - 0x2001010)
	str r1, [r5,#0x18] // (dword_2001028 - 0x2001010)
	str r2, [r5,#0x1c] // (dword_200102C - 0x2001010)
	pop {r4-r7,pc}
	.hword 0x0
	.word 0x0
	.word 0x2000
	thumb_func_end sub_8143FC4

	thumb_func_start sub_8144010
sub_8144010:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	ldr r0, [r5,#0x14] // (dword_2001024 - 0x2001010)
	asr r0, r0, #0x10
	cmp r0, #0
	blt loc_8144024
	cmp r0, #0x64 
	blt loc_8144026
	mov r0, #0x64 
	b loc_8144026
loc_8144024:
	mov r0, #0
loc_8144026:
	ldr r2, off_814403C // =byte_8144040 
	mov r1, #0
loc_814402A:
	ldrb r3, [r2,r1]
	cmp r0, r3
	blt locret_8144038
	add r1, #1
	cmp r1, #4
	ble loc_814402A
	mov r1, #4
locret_8144038:
	pop {r4-r7,pc}
	.balign 4, 0
off_814403C:
	.word byte_8144040
byte_8144040:
	.byte 0x1B, 0x35, 0x4A, 0x5A, 0x64, 0x0, 0x0, 0x0
	thumb_func_end sub_8144010

// symdb: On a one-shot flag, initializes three AI chip-queue slots for the multi-enemy actors 0xE/0xC/0xD, then each frame runs AI dispatch, sprite gfx updates, a sub_804691A(3)/sprite_buildGaugeTiles step, and a fade+subsystem-4 cleanup before the common tail.
// symdb: () -> r0 = 0; flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_initMultiEnemyAIAndTick.yaml
	thumb_func_start battle_initMultiEnemyAIAndTick
battle_initMultiEnemyAIAndTick:
	push {r4-r7,lr}
	ldr r5, off_81440D4 // =eStruct2001010 
	bl get_groundmanMinigameSkipCondition
	bne loc_81440A6
	ldrb r0, [r5,#0x3] // (byte_2001013 - 0x2001010)
	tst r0, r0
	beq loc_814407E
	mov r0, #0
	strb r0, [r5,#0x3] // (byte_2001013 - 0x2001010)
	bl sub_80468BA
	mov r0, #0xe
	mov r1, #0
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
	mov r0, #0xc
	mov r1, #1
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
	mov r0, #0xd
	mov r1, #2
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
loc_814407E:
	bl battle_callAIDispatch_8046818
	bl battleObject_updateSpriteGfxForAll_8046854
	mov r0, #3
	bl battle_testEntityStateFlag
	beq loc_8144092
	bl sprite_buildGaugeTiles
loc_8144092:
	bl IsScreenFadeActive // () -> zf
	beq loc_81440A6
	mov r0, r10
	ldr r0, [r0,#oToolkit_GameStatePtr]
	ldrb r0, [r0,#oGameState_SubsystemIndex]
	cmp r0, #4
	bne loc_81440A6
	bl e_decrementCountdown
loc_81440A6:
	bl sub_8143F1C
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end battle_initMultiEnemyAIAndTick

// symdb: Boolean gate for the Groundman minigame: returns 1 (skip/do nothing) once a PET-menu flag or event flag is set or the player isn't on a minigame map, else 0.
// symdb: () -> r0 = 1 if any completion/skip condition holds (PET menu flag set, map index 0xFF, event
// symdb: flag set), else r0 = 0
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/get_groundmanMinigameSkipCondition.yaml
	thumb_local_start
get_groundmanMinigameSkipCondition:
	push {r4-r7,lr}
	mov r0, #1
	bl TestPETMenuDataFlag
	bne loc_81440D0
	bl GetGroundmanMinigameMapIndex
	cmp r0, #0xff
	beq loc_81440D0
	bl get_groundmanMinigameMapId
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_81440D0
	mov r0, #0
	pop {r4-r7,pc}
loc_81440D0:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_81440D4:
	.word eStruct2001010
	thumb_func_end get_groundmanMinigameSkipCondition

/*For debugging purposes, connect comment at any range!*/
