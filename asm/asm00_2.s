
	thumb_func_start sub_800ED80
sub_800ED80:
	ldr r1, [r0,#oAIData_Unk_7c]
	ldr r2, off_800ED8C // =eUsedAIDataBitfield 
	ldr r3, [r2]
	bic r3, r1
	str r3, [r2]
	mov pc, lr
off_800ED8C:
	.word eUsedAIDataBitfield
	thumb_func_end sub_800ED80

// symdb: Fetches the chip a battle object has selected for use, either from its side's card hand (for hand-driven actors) or from the object's own chip field.
// symdb: int battle_getSelectedChipForUse_800ED90(BattleObject* obj) -> r0 = chip ID, r1 = chip sub-
// symdb: value, r2 = combined power value, r3 = ChipsHeld; V set by last flag-setting op
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getSelectedChipForUse_800ED90.yaml
	thumb_func_start battle_getSelectedChipForUse_800ED90
battle_getSelectedChipForUse_800ED90:
	push {r5,r7,lr}
	mov r5, r0

	ldrh r0, [r5,#oBattleObject_NameID]
	bl unpackVerActorTyAndAIIdx_800F29C
	cmp r0, #2
	bne loc_800EDC6

	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getBattleHandAddr_8010018
	ldrb r1, [r0]
	add r1, r1, r1
	add r0, r0, r1
	add r0, #2
	mov r7, r0
	ldrh r0, [r7]
	mov r1, #0
	bl battle_chipElementWeaknessBonus_800EF34
	ldrh r2, [r7,#0x18]
	add r2, r2, r0
	ldrh r0, [r7,#0x24]
	add r2, r2, r0
	ldrh r1, [r7,#0xc]
	ldrh r0, [r7]
	ldrb r3, [r5,#oBattleObject_ChipsHeld]
	pop {r5,r7,pc}
loc_800EDC6:
	ldrh r0, [r5,#oBattleObject_Chip]
	mov r1, #0
	mov r2, #0
	ldrb r3, [r5,#oBattleObject_ChipsHeld]
	pop {r5,r7,pc}
	thumb_func_end battle_getSelectedChipForUse_800ED90

// symdb: Gather state/info fields for a battle object, branching on whether it is an actor (type 2) — actor path reads hand-slot data and calls sub_800EF34, otherwise returns chip metadata.
// symdb: // In:  r0 = battle object ptr, r1 = caller-saved value forwarded to sub_800EF34, //      r4 =
// symdb: preserved-through value, r10 / lr used by caller // Out: r0..r4 = (see details); nz/c/v/lr
// symdb: clobbered; r5..r7 preserved SubEdd0Out getBattleObjectStateInfo_800EDD0(u32 obj, u32 callerR1,
// symdb: u32 r4_in);
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getBattleObjectStateInfo_800EDD0.yaml
	thumb_local_start
getBattleObjectStateInfo_800EDD0:
	push {r5-r7,lr}
	sub sp, sp, #4
	str r1, [sp]
	mov r5, r0
	ldrh r0, [r5,#oBattleObject_NameID]
	bl unpackVerActorTyAndAIIdx_800F29C
	cmp r0, #2
	bne loc_800EE1A
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getBattleHandAddr_8010018
	mov r4, r0
	ldrb r6, [r0]
	add r1, r6, r6
	add r0, r0, r1
	add r0, #2
	mov r7, r0
	ldrh r0, [r7]
	ldr r1, [sp]
	bl battle_chipElementWeaknessBonus_800EF34
	mov r3, r1
	ldrh r2, [r7,#0x18]
	add r2, r2, r0
	ldrh r0, [r7,#0x24]
	add r2, r2, r0
	ldrh r1, [r7,#0xc]
	ldrh r0, [r7]
	mov r7, #0x44 
	add r7, r7, r6
	ldrb r7, [r4,r7]
	add r6, #0x3e 
	ldrb r4, [r4,r6]
	lsl r4, r4, #8
	add r4, r4, r7
	b loc_800EE22
loc_800EE1A:
	ldrh r0, [r5,#oBattleObject_Chip]
	mov r1, #0
	mov r2, #0
	ldrb r3, [r5,#oBattleObject_ChipsHeld]
loc_800EE22:
	add sp, sp, #4
	pop {r5-r7,pc}
	thumb_func_end getBattleObjectStateInfo_800EDD0

	thumb_local_start
sub_800EE26:
	push {r5-r7,lr}
	mov r5, r0
	ldrh r0, [r5,#oBattleObject_NameID]
	bl unpackVerActorTyAndAIIdx_800F29C
	cmp r0, #2
	bne loc_800EE8E
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	mov r6, r0
	bl sub_800EE98
	ldrh r0, [r6,#0x34]
	mov r1, #0
	bl battle_chipElementWeaknessBonus_800EF34
	push {r0,r1}
	// idx
	ldrh r0, [r6,#0x34]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#0xf]
	strb r0, [r7,#oAIAttackVars_Unk_1d]
	ldrh r0, [r6,#0x34]
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_chipEffectDispatcher_80109A4
	mov r1, r0
	pop {r2,r3}
	push {r1-r3}
	// idx
	ldrh r0, [r6,#0x34]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#9]
	pop {r1-r3}
	mov r4, #2
	tst r0, r4
	beq loc_800EE7A
	ldrh r4, [r6,#0x36]
	add r2, r2, r4
	mov r4, #0
	strh r4, [r6,#0x36]
loc_800EE7A:
	mov r4, #4
	tst r0, r4
	beq loc_800EE88
	ldrh r4, [r6,#0x38]
	add r2, r2, r4
	mov r4, #0
	strh r4, [r6,#0x38]
loc_800EE88:
	mov r4, #0
	ldrh r0, [r6,#0x34]
	b locret_800EE96
loc_800EE8E:
	ldrh r0, [r5,#oBattleObject_Chip]
	mov r1, #0
	mov r2, #0
	ldrb r3, [r5,#oBattleObject_ChipsHeld]
locret_800EE96:
	pop {r5-r7,pc}
	thumb_func_end sub_800EE26

	thumb_local_start
sub_800EE98:
	push {r0-r4,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	ldrh r1, [r6,#0x34]
	bl sub_802E830
	mov r4, r0
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	tst r0, r0
	bne loc_800EEBA
	mov r0, r4
	bl sub_801E2BA
	mov r0, #0x8d
	bl PlaySoundEffect
loc_800EEBA:
	// idx
	ldrh r0, [r6,#0x34]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r4, r0
	ldrb r0, [r4,#0x16] // ChipData.unk_16
	mov r1, #0x80
	tst r0, r1
	bne locret_800EEE2
	ldrb r0, [r4,#0x7] // ChipData.elemIdx
	add r0, r0, r0
	ldr r1, off_800EEF4 // =byte_800EEF8 
	ldrh r0, [r1,r0]
	ldr r2, off_800EEF0 // =word_200F3C4
	add r3, r6, r6
	strh r0, [r2,r3]
	ldrh r1, [r6,#0x28]
	sub r1, r1, r0
	bge loc_800EEE0
	mov r1, #0
loc_800EEE0:
	strh r1, [r6,#0x28]
locret_800EEE2:
	pop {r0-r4,pc}
	.word 0, 0
	.byte 0, 0, 0, 0
	.balign 4, 0
off_800EEF0:
	.word word_200F3C4
off_800EEF4:
	.word byte_800EEF8
byte_800EEF8:
	.byte 0x0, 0x15, 0x0, 0x2A, 0x0, 0x40, 0xFF, 0xFF, 0xFF, 0xFF
	thumb_func_end sub_800EE98

	thumb_local_start
sub_800EF02:
	push {r5-r7,lr}
	mov r6, r0
	ldrh r0, [r5,#oBattleObject_NameID]
	bl unpackVerActorTyAndAIIdx_800F29C
	cmp r0, #2
	bne loc_800EF2A
	mov r0, r6
	mov r1, #0
	bl battle_chipElementWeaknessBonus_800EF34
	push {r0,r1}
	mov r0, r6
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_chipEffectDispatcher_80109A4
	mov r1, r0
	pop {r2,r3}
	mov r0, r6
	b locret_800EF32
loc_800EF2A:
	ldrh r0, [r5,#oBattleObject_Chip]
	mov r1, #0
	mov r2, #0
	ldrb r3, [r5,#oBattleObject_ChipsHeld]
locret_800EF32:
	pop {r5-r7,pc}
	thumb_func_end sub_800EF02

// symdb: Computes an elemental chip bonus (additive damage + element id) based on the selected chip and the user's Navi/custom-equipment profile.
// symdb: (r0 = chipID, r1 = ?) -> r0 = damageBonus, r1 = elementID ; side effects: none beyond the final
// symdb: barrier-hit adjustment
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_chipElementWeaknessBonus_800EF34.yaml
	thumb_local_start
battle_chipElementWeaknessBonus_800EF34:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r1, [sp]
	mov r4, r0
	mov r6, #0
	mov r7, #0
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800EF54
	mov r0, r4
	ldr r1, [sp]
	bl battle_getNaviCustStyleStatBoostFromChip_800F09E
	b loc_800F094
loc_800EF54:
	ldr r0, dword_800F208 // =0xffff 
	cmp r0, r4
	bne loc_800EF5C
	b loc_800F090
loc_800EF5C:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #1
	beq loc_800EF6A
	cmp r0, #0xd
	bne loc_800EF8E
loc_800EF6A:
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800EF8C
	ldrb r1, [r0,#6]
	cmp r1, #0
	bne loc_800EF8C
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800EF8C
	mov r7, #2
	add r6, #0x32 
	b loc_800F090
loc_800EF8C:
	b loc_800F058
loc_800EF8E:
	cmp r0, #0xe
	beq loc_800EF96
	cmp r0, #2
	bne loc_800EFB8
loc_800EF96:
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F058
	ldrb r1, [r0,#6]
	cmp r1, #2
	bne loc_800F058
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F058
	mov r7, #6
	add r6, #0x32 
	b loc_800F090
loc_800EFB8:
	cmp r0, #0xf
	beq loc_800EFC0
	cmp r0, #3
	bne loc_800EFE2
loc_800EFC0:
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F058
	ldrb r1, [r0,#6]
	cmp r1, #5
	bne loc_800F058
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F058
	mov r7, #6
	add r6, #0x32 
	b loc_800F090
loc_800EFE2:
	cmp r0, #0x14
	beq loc_800EFEA
	cmp r0, #8
	bne loc_800F00C
loc_800EFEA:
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F058
	ldrb r1, [r0,#6]
	cmp r1, #8
	bne loc_800F058
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F058
	mov r7, #7
	add r6, #0xa
	b loc_800F090
loc_800F00C:
	cmp r0, #0x10
	beq loc_800F014
	cmp r0, #4
	bne loc_800F02E
loc_800F014:
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F058
	ldrb r1, [r0,#6]
	cmp r1, #6
	bne loc_800F058
	mov r7, #8
	add r6, #0x1e
	b loc_800F090
loc_800F02E:
	cmp r0, #0x15
	beq loc_800F036
	cmp r0, #9
	bne loc_800F058
loc_800F036:
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F058
	ldrb r1, [r0,#6]
	cmp r1, #9
	bne loc_800F058
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F058
	mov r7, #8
	add r6, #0xa
	b loc_800F090
loc_800F058:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xb
	blt loc_800F090
	cmp r0, #0x16
	bgt loc_800F090
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F090
	ldrb r1, [r0,#6]
	cmp r1, #0xa
	bne loc_800F090
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F090
	bl GetBattleMode
	cmp r0, #1
	beq loc_800F090
	mov r7, #9
	add r6, #0x1e
	b loc_800F090
loc_800F090:
	mov r0, r6
	mov r1, r7
loc_800F094:
	mov r2, r4
	bl battle_addBarrierHitAdjust_800F1DC
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	thumb_func_end battle_chipElementWeaknessBonus_800EF34

// symdb: For a chip ID and the current navi stat byte, looks up a custom-style "stat boost" pairing in the chip table and a per-team table, returning the bonus byte.
// symdb: (r0 = chipId, r1 = naviStatsByte, r5 = battleObjectPtr) -> r0 = baseBoost (0 or param), r1 =
// symdb: bonusIndex (0 or 0xC..0x12) ; side effects: reads alliance-team table and a 15-byte-wide lookup
// symdb: at 0x02021300
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getNaviCustStyleStatBoostFromChip_800F09E.yaml
	thumb_local_start
battle_getNaviCustStyleStatBoostFromChip_800F09E:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r1, [sp]
	mov r4, r0
	mov r6, #0
	mov r7, #0
	ldr r0, dword_800F208 // =0xffff 
	cmp r0, r4
	beq loc_800F0DE
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #1
	bne loc_800F0E0
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F0DC
	ldrb r1, [r0,#6]
	cmp r1, #0
	bne loc_800F0DC
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F0DC
	mov r7, #0xc
	add r6, #0
	b loc_800F1BE
loc_800F0DC:
	b loc_800F1D4
loc_800F0DE:
	b loc_800F1D4
loc_800F0E0:
	cmp r0, #2
	bne loc_800F106
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F1D4
	ldrb r1, [r0,#6]
	cmp r1, #2
	bne loc_800F1D4
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F1D4
	mov r7, #0xd
	add r6, #0
	b loc_800F1BE
loc_800F106:
	cmp r0, #3
	bne loc_800F12C
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F1D4
	ldrb r1, [r0,#6]
	cmp r1, #5
	bne loc_800F1D4
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F1D4
	mov r7, #0xe
	add r6, #0
	b loc_800F1BE
loc_800F12C:
	cmp r0, #4
	bne loc_800F14A
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F1D4
	ldrb r1, [r0,#6]
	cmp r1, #6
	bne loc_800F1D4
	mov r7, #0xf
	add r6, #0
	b loc_800F1BE
loc_800F14A:
	cmp r0, #8
	bne loc_800F170
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F1D4
	ldrb r1, [r0,#6]
	cmp r1, #8
	bne loc_800F1D4
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F1D4
	mov r7, #0x10
	add r6, #0
	b loc_800F1BE
loc_800F170:
	cmp r0, #9
	bne loc_800F196
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F1D4
	ldrb r1, [r0,#6]
	cmp r1, #9
	bne loc_800F1D4
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F1D4
	mov r7, #0x11
	add r6, #0
	b loc_800F1BE
loc_800F196:
	cmp r0, #0xa
	bne loc_800F1BC
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_800F1D4
	ldrb r1, [r0,#6]
	cmp r1, #9
	bne loc_800F1D4
	ldrb r1, [r0,#9]
	mov r2, #1
	tst r1, r2
	bne loc_800F1D4
	mov r7, #0x12
	add r6, #0
	b loc_800F1BE
loc_800F1BC:
	b loc_800F1D4
loc_800F1BE:
	bl battle_getObjectAllianceTeam_800F49E
	cmp r0, #0xff
	beq loc_800F1D4
	mov r1, r7
	sub r1, #0xc
	mov r2, #0xf
	mul r1, r2
	add r0, r0, r1
	ldr r1, off_800F20C // =byte_8021300 
	ldrb r6, [r1,r0]
loc_800F1D4:
	mov r0, r6
	mov r1, r7
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	thumb_func_end battle_getNaviCustStyleStatBoostFromChip_800F09E

// symdb: If the incoming hit/event type targets a barrier (types 0x5F-0x61 or 0x150) and the battle object has an active barrier, adds 50 (0x32) to the value passed in r0.
// symdb: u32 battle_addBarrierHitAdjust(u32 value /*r0*/, u32 arg1 /*r1, preserved*/, u32 hitType /*r2*/,
// symdb: BattleObject* obj /*r5*/); // returns possibly adjusted value in r0; also returns collision ptr
// symdb: in r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_addBarrierHitAdjust_800F1DC.yaml
	thumb_local_start
battle_addBarrierHitAdjust_800F1DC:
	push {r1,r6,r7,lr}
	ldr r3, off_800F210 // =0x150 
	cmp r2, r3
	beq loc_800F1EC
	cmp r2, #0x5f 
	blt locret_800F204
	cmp r2, #0x61 
	bgt locret_800F204
loc_800F1EC:
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r2, [r3,#oCollisionData_Barrier]
	cmp r2, #0
	beq locret_800F204
	cmp r2, #0x10
	bge locret_800F204
	cmp r2, #8
	bne loc_800F202
	ldrb r2, [r3,#oCollisionData_Unk_16]
	cmp r2, #0
	beq locret_800F204
loc_800F202:
	add r0, #0x32 
locret_800F204:
	pop {r1,r6,r7,pc}
	.balign 4, 0
dword_800F208:
	.word 0xFFFF
off_800F20C:
	.word byte_8021300
off_800F210:
	.word 0x150
	thumb_func_end battle_addBarrierHitAdjust_800F1DC

	.equiv enemy_getStruct1_struct_spriteIndex0, 0x00 // u8
	.equiv enemy_getStruct1_struct_spriteIndex1, 0x01 // u8
	.equiv enemy_getStruct1_struct_Unk_02, 0x02 // u8
	.equiv enemy_getStruct1_struct_Unk_03, 0x03 // u8
	.equiv enemy_getStruct1_struct_Unk_04, 0x04 // u8
	.equiv enemy_getStruct1_struct_Element, 0x05 // u8
	.equiv enemy_getStruct1_struct_SecondaryElementWeakness, 0x06 // u8
	.equiv enemy_getStruct1_struct_HasShadow, 0x07 // bool

// symdb: Resolves an enemy index to a pointer to its per-enemy struct by looking up actor type (virus/navi/player) and AI index tables.
// symdb: enemy_resolveStructByActorType(u16 enemy_idx) -> (void *struct_ptr /*r0*/, u32 ai_index_x4
// symdb: /*r2*/); clobbers r1, lr, NZC flags; V flag also reported as output by callers
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/enemy_getStruct1.yaml
	thumb_func_start enemy_getStruct1
enemy_getStruct1:
	push {lr}

	bl GetVerActorTyAndAIIdx_80182B4 // (enemy_idx: u16) -> *const (version: u8, actor_type: ActorType, ai_index: u8)

	// index by actor_type * 4
	ldrb r2, [r0,#1] /*+6*/
	lsl r2, r2, #2
	ldr r1, off_800F22C // =off_800F230 
	ldr r1, [r1,r2]

	// index by ai_index * 4
	ldrb r2, [r0,#2]
	lsl r2, r2, #2
	ldr r0, [r1,r2]

	pop {pc}
	.balign 4, 0
off_800F22C:
	.word off_800F230
off_800F230:
	// virus
	.word off_81090D0
	// navi
	.word off_80F24D8
	// player
	.word off_80EA814
	thumb_func_end enemy_getStruct1

// struct {elem_hp: u16, unk_02: u16, elem_damage: u16}

	.equiv enemy_getStruct2_struct_ElemHP, 0x00 // u16
	.equiv enemy_getStruct2_struct_Unk_02, 0x02 // u8
	.equiv enemy_getStruct2_struct_UnkFlags_03, 0x03 // u8
	.equiv enemy_getStruct2_struct_ElemDamage, 0x04 // u16

// where for elem_hp and elem_dmg, in a `.hword 0xXYYY` `X` is likely elem and `YYY` is hp/damage.
// symdb: Resolves an enemy index to a pointer into a per-version 6-byte data record, selected by actor type (virus/navi/player) and AI index.
// symdb: u8* enemy_getStruct2(u16 enemy_idx) -> r0 = pointer to 6-byte per-version record (r3 = 6 as a
// symdb: side effect, r1/r2 clobbered)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/enemy_getStruct2.yaml
	thumb_func_start enemy_getStruct2
enemy_getStruct2:
	push {lr}

	bl GetVerActorTyAndAIIdx_80182B4 // (enemy_idx: u16) -> *const (version: u8, actor_type: ActorType, ai_index: u8)

	// Index by actor_type * 4
	ldrb r2, [r0,#1]
	lsl r2, r2, #2
	ldr r1, off_800F25C // =off_800F260 
	ldr r1, [r1,r2]

	// Index by ai_index * 4
	ldrb r2, [r0,#2]
	lsl r2, r2, #2
	ldr r1, [r1,r2]

	// Index by version * size
	ldrb r2, [r0,#0]
	mov r3, #6
	mul r2, r3
	add r0, r1, r2

	pop {pc}
	.balign 4, 0
off_800F25C:
	.word off_800F260
off_800F260:
	// virus
	.word off_8109150
	// navi
	.word off_80F253C
	// player
	.word off_80EA8D8
	thumb_func_end enemy_getStruct2

// symdb: Resolves an arm/part slot id (0xCD..0xFF) to a 5-byte record of (x, y, ?, ?, ?) from a packed table, or otherwise returns the AI struct's first two bytes for normal actor ids.
// symdb: (r0 = slotOrActorIndex) -> r0 = x, r1 = y, r2 = ?, r3 = ?, r4 = ? ; no side effects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/enemy_getArmPosition_800F26C.yaml
	thumb_func_start enemy_getArmPosition_800F26C
enemy_getArmPosition_800F26C:
	push {lr}
	mov r2, #0xcd
	sub r2, r0, r2
	mov r1, #0x32 
	cmp r2, r1
	bls loc_800F286
	bl enemy_getStruct1
	ldrb r1, [r0,#1]
	ldrb r0, [r0]
	mov r2, #0
	mov r3, #0
	pop {pc}
loc_800F286:
	sub r0, #0xcd
	mov r1, #5
	mul r0, r1
	ldr r3, off_800F4D4 // =byte_8021220 
	add r3, r3, r0
	ldrb r0, [r3]
	ldrb r1, [r3,#1]
	ldrb r2, [r3,#2]
	ldrb r4, [r3,#4]
	ldrb r3, [r3,#3]
	pop {pc}
	thumb_func_end enemy_getArmPosition_800F26C

// symdb: Unpack an enemy's {version, actor type, AI index} record into registers.
// symdb: (r0 = enemy index) -> r0 = actor type, r1 = AI index, r2 = version (bytes 1, 2, 0 of the record
// symdb: GetVerActorTyAndAIIdx_80182B4 returns)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/unpackVerActorTyAndAIIdx_800F29C.yaml
	thumb_func_start unpackVerActorTyAndAIIdx_800F29C
unpackVerActorTyAndAIIdx_800F29C:
	push {lr}
	bl GetVerActorTyAndAIIdx_80182B4 // (enemy_idx: u16) -> *const (version: u8, actor_type: ActorType, ai_index: u8)
	ldrb r2, [r0]
	ldrb r1, [r0,#2]
	ldrb r0, [r0,#1]
	pop {pc}
	thumb_func_end unpackVerActorTyAndAIIdx_800F29C

	thumb_func_start sub_800F2AA
sub_800F2AA:
	push {lr}
	ldrh r1, [r5,#oBattleObject_NameID]
	bl nullsub_3
	pop {pc}
	thumb_func_end sub_800F2AA

// symdb: Empty placeholder subroutine that does nothing and immediately returns to the caller.
// symdb: void nullsub_3(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_3.yaml
	thumb_local_start
nullsub_3:
	mov pc, lr
	thumb_func_end nullsub_3

// symdb: Starts an animation on a battle object by storing the animation ID and marking it as pending with 0xFF.
// symdb: (u32 anim, r5 battleObject, ...) -> u32 (returns 0xFF); also returns r1 = battleObject->NameID
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_setAnimation.yaml
	thumb_func_start object_setAnimation
object_setAnimation:
	push {lr}
	ldrh r1, [r5,#oBattleObject_NameID]
	bl nullsub_3
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	pop {pc}
	thumb_func_end object_setAnimation

// symdb: Refresh the battle object's sprite facing/arm position each frame (player objects get a custom arm-position write, others use the tracked-arm table).
// symdb: (r5 = battleObject) -> void ; side effects: updates the object's sprite flip and arm-position
// symdb: table entry
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_refreshSpriteAndArm_800F2C6.yaml
	thumb_func_start battleObject_refreshSpriteAndArm_800F2C6
battleObject_refreshSpriteAndArm_800F2C6:
	push {lr}
	bl object_getFlip // () -> int
	bl sprite_setFlip
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	tst r0, r0
	beq locret_800F2EE
	ldrb r1, [r0,#oAIData_ActorType]
	cmp r1, #2
	bne loc_800F2EA
	mov r0, #3
	bl battleObject_computeAIStepForwardDeltaX_8018856
	neg r1, r1
	bl battleObject_setCustomGaugeBarAnimate_801DC06
	pop {pc}
loc_800F2EA:
	bl battleRefreshTrackedObjectArmPos_801DBD4
locret_800F2EE:
	pop {pc}
	thumb_func_end battleObject_refreshSpriteAndArm_800F2C6

	thumb_local_start
sub_800F2F0:
	push {lr}
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_78]
	bl sub_800F2FC
	pop {pc}
	thumb_func_end sub_800F2F0

	thumb_func_start sub_800F2FC
sub_800F2FC:
	push {lr}
	ldrb r1, [r0,#0x12]
	ldrb r2, [r5,#oBattleObject_PanelX]
	mov r0, #0
	sub r1, r1, r2
	beq locret_800F316
	bgt loc_800F30C
	mov r0, #1
loc_800F30C:
	ldrb r1, [r5,#oBattleObject_Alliance]
	eor r0, r1
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl battleObject_refreshSpriteAndArm_800F2C6
locret_800F316:
	pop {pc}
	thumb_func_end sub_800F2FC

// symdb: Stores a value into a battle object's AI data at offset oAIData_Unk_78, if the object has AI data.
// symdb: void battle_SetObjectAIDataField78(u32 value /*r0*/, BattleObject* obj /*r5*/); // returns r1 =
// symdb: AI data pointer (or NULL), clobbers NZ
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_SetObjectAIDataField78_800F318.yaml
	thumb_local_start
battle_SetObjectAIDataField78_800F318:
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	tst r1, r1
	beq locret_800F320

	str r0, [r1,#oAIData_Unk_78]

locret_800F320: // endif
	mov pc, lr
	thumb_func_end battle_SetObjectAIDataField78_800F318

// symdb: Consume one chip from the battle object's queue and clear the current chip ID when the queue empties
// symdb: (r5 = BattleObject*) -> ; side effects: writes r5->ChipsHeld, conditionally writes r5->Chip;
// symdb: clobbers r0 and NZCV
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_decrementChipHeldAndClearChip_800F322.yaml
	thumb_func_start battleObject_decrementChipHeldAndClearChip_800F322
battleObject_decrementChipHeldAndClearChip_800F322:
	ldrb r0, [r5,#oBattleObject_ChipsHeld]
	cmp r0, #0
	beq locret_800F332
	sub r0, #1
	strb r0, [r5,#oBattleObject_ChipsHeld]
	bne locret_800F332
	sub r0, #1
	strh r0, [r5,#oBattleObject_Chip]
locret_800F332:
	mov pc, lr
	thumb_func_end battleObject_decrementChipHeldAndClearChip_800F322

// symdb: Computes the OAM palette bank for a battle object from its AI data's actor type, version, and unk03 (variant) fields.
// symdb: u8 battle_getObjectPalette_800F334(BattleObject* obj /* r5 */) -> r0 = palette index; also
// symdb: returns r1 = actorType, r2 = version (or version*unk03 for viruses); clobbers r3, NZCV;
// symdb: preserves nothing extra
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getBattleObjectPalette_800F334.yaml
	thumb_local_start
getBattleObjectPalette_800F334: // (obj: * BattleObject $r5) -> u8
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrb r1, [r0,#oAIData_ActorType]
	ldrb r2, [r0,#oAIData_Version_16]
	ldrb r3, [r0,#oAIData_Unk_03]

	cmp r1, #ACTOR_TYPE_VIRUS
	bne loc_800F346

	mul r2, r3 // varies palette by version
	mov r0, r2
	mov pc, lr

loc_800F346:
	ldr r0, off_800F350 // =byte_800F354 
	ldrb r0, [r0,r2]
	mul r0, r3
	mov pc, lr
	.balign 4, 0
off_800F350:
	.word byte_800F354
byte_800F354:
	.byte 0x0, 0x0, 0x0, 0x0, 0x3, 0x1, 0x0, 0x0
	thumb_func_end getBattleObjectPalette_800F334

// symdb: Dispatches an actor to its type-specific AI/behavior handler table entry (virus, navi, or player) via a shared dispatch helper.
// symdb: void sub_800F35C(void); // r0-r1 in = passed through to dispatched handler, r2-r12 out =
// symdb: whatever the dispatched handler leaves
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_dispatchActorHandlerByType_800F35C.yaml
	thumb_local_start
battle_dispatchActorHandlerByType_800F35C:
	push {lr}
	ldr r0, off_800F368 // =off_800F36C 
	bl indexByActorTypeAndAIIdxThenDispatch_800F420
	pop {pc}
	.balign 4, 0
off_800F368:
	.word off_800F36C
off_800F36C:
	// virus
	.word off_8109250
	// navi
	.word off_80F2604
	// player
	.word off_80EA9A0
	thumb_func_end battle_dispatchActorHandlerByType_800F35C

// symdb: Thin wrapper that hands the battle actor's per-type dispatch table (virus/navi/player) to the actor-type+AI-index dispatcher and tail-calls it.
// symdb: battle_dispatchActorByTypeAndAIIdx_800F378(void *actor /* r0 */) — tail-calls
// symdb: indexByActorTypeAndAIIdxThenDispatch_800F420(r0 = &off_800F388); r1–r12, c and v flags pass
// symdb: through unchanged to the eventual handler/caller.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_dispatchActorByTypeAndAIIdx_800F378.yaml
	thumb_func_start battle_dispatchActorByTypeAndAIIdx_800F378
battle_dispatchActorByTypeAndAIIdx_800F378:
	push {lr}
	ldr r0, pool_800F384 // =off_800F388 
	bl indexByActorTypeAndAIIdxThenDispatch_800F420
	pop {pc}
	.balign 4, 0
pool_800F384:
	.word off_800F388
off_800F388:
	// virus
	.word off_81092D0
	// navi
	.word off_80F2668
	// player
	.word off_80EAA04
	thumb_func_end battle_dispatchActorByTypeAndAIIdx_800F378

// symdb: Tail-calls the shared actor dispatcher with a 3-entry table of handler tables, so each actor's AI handler is chosen by its actor type and AI index and run with all caller registers forwarded.
// symdb: void battle_dispatchActorAIByTypeAndAIIdx(void) — in: r4-r12 carry per-actor/context state to
// symdb: the dispatched handler (r0 is overwritten); out: whatever the dispatched handler returns, r4-r12
// symdb: passed through.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_dispatchActorAIByTypeAndAIIdx_800F394.yaml
	thumb_local_start
battle_dispatchActorAIByTypeAndAIIdx_800F394:
	push {lr}
	ldr r0, off_800F3A0 // =off_800F3A4 
	bl indexByActorTypeAndAIIdxThenDispatch_800F420
	pop {pc}
	.balign 4, 0
off_800F3A0:
	.word off_800F3A4
off_800F3A4:
	.word off_8109350
	.word off_80F26CC
	.word off_80EAA68
	thumb_func_end battle_dispatchActorAIByTypeAndAIIdx_800F394

	thumb_local_start
sub_800F3B0:
	push {lr}
	ldr r0, off_800F3BC // =off_800F3C0 
	bl indexByActorTypeAndAIIdxThenDispatch_800F420
	pop {pc}
	.balign 4, 0
off_800F3BC:
	.word off_800F3C0
off_800F3C0:
	.word off_81093D0
	.word off_80F2730
	.word off_80EAACC
	thumb_func_end sub_800F3B0

	thumb_local_start
sub_800F3CC:
	push {lr}
	ldr r0, off_800F3D8 // =off_800F3DC 
	bl indexByActorTypeAndAIIdxThenDispatch_800F420
	pop {pc}
	.balign 4, 0
off_800F3D8:
	.word off_800F3DC
off_800F3DC:
	.word off_8109450
	.word off_80F2794
	.word off_80EAB30
	thumb_func_end sub_800F3CC

// symdb: AI dispatch thunk that loads a three-entry handler table and tail-calls the generic actor-type/AI-index dispatcher to run the matching enemy AI routine.
// symdb: void sub_800F3E8(void); // all args/results pass through to the dispatched handler; contract is
// symdb: that of the handler chosen by indexByActorTypeAndAIIdxThenDispatch_800F420
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ai_dispatchByTypeAndIndex_800F3E8.yaml
	thumb_local_start
ai_dispatchByTypeAndIndex_800F3E8:
	push {lr}
	ldr r0, off_800F3F4 // =off_800F3F8 
	bl indexByActorTypeAndAIIdxThenDispatch_800F420
	pop {pc}
	.balign 4, 0
off_800F3F4:
	.word off_800F3F8
off_800F3F8:
	.word off_81094D0
	.word off_80F27F8
	.word off_80EAB94
	thumb_func_end ai_dispatchByTypeAndIndex_800F3E8

// symdb: Battle-side trampoline that hands the current actor's type/AI-index handler table to the shared actor dispatch routine and jumps to it.
// symdb: void battle_dispatchActorTurnByTypeAndAIIdx(void); // no register inputs of its own; tail-calls
// symdb: indexByActorTypeAndAIIdxThenDispatch_800F420
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_dispatchActorTurnByTypeAndAIIdx_800F404.yaml
	thumb_local_start
battle_dispatchActorTurnByTypeAndAIIdx_800F404:
	push {lr}
	ldr r0, off_800F410 // =off_800F414 
	bl indexByActorTypeAndAIIdxThenDispatch_800F420
	pop {pc}
	.balign 4, 0
off_800F410:
	.word off_800F414
off_800F414:
	.word off_8109550
	.word off_80F285C
	.word off_80EABF8
	thumb_func_end battle_dispatchActorTurnByTypeAndAIIdx_800F404

	thumb_local_start
indexByActorTypeAndAIIdxThenDispatch_800F420:
	push {lr}

	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldrb r1, [r3,#oAIData_ActorType]
	lsl r1, r1, #2
	ldr r2, [r0,r1]

	ldrb r1, [r3,#oAIData_AIIndex]
	lsl r1, r1, #2
	ldr r0, [r2,r1]
	mov lr, pc
	bx r0

	pop {pc}
	thumb_func_end indexByActorTypeAndAIIdxThenDispatch_800F420

	thumb_local_start
sub_800F436:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r2, [sp]
	mov r6, r0
	mov r7, r1
	bl object_getFrontDirection // () -> int
	mov r4, r0
loc_800F446:
	add r6, r6, r4
	mov r0, r6
	mov r1, r7
	bl object_isValidPanel
	beq loc_800F462
	mov r0, r6
	mov r1, r7
	bl object_getPanelParameters
	ldr r1, [sp]
	tst r0, r1
	bne loc_800F466
	b loc_800F446
loc_800F462:
	mov r0, #0
	b loc_800F468
loc_800F466:
	mov r0, #1
loc_800F468:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	thumb_func_end sub_800F436

	thumb_func_start sub_800F46C
sub_800F46C:
	push {lr}
	bl GetBattlePanelColumnPattern
	cmp r0, #0x38 
	beq loc_800F482
	cmp r0, #0x30 
	beq loc_800F482
	cmp r0, #0x3c 
	beq loc_800F482
	ldrb r0, [r5,#oBattleObject_DirectionFlip]
	pop {pc}
loc_800F482:
	mov r0, #0
	pop {pc}
	thumb_func_end sub_800F46C

	thumb_func_start sub_800F486
sub_800F486:
	cmp r0, #0xd3
	beq loc_800F49A
	cmp r0, #0xda
	beq loc_800F49A
	cmp r0, #0xe9
	beq loc_800F49A
	cmp r0, #0xea
	beq loc_800F49A
	mov r0, #1
	mov pc, lr
loc_800F49A:
	mov r0, #0
	mov pc, lr
	thumb_func_end sub_800F486

// symdb: Returns the alliance-team entry for a battle object's Alliance field from the allianceTeams table.
// symdb: u32 battle_getObjectAllianceTeam(struct BattleObject* obj /* r5 */; returns r0 =
// symdb: allianceTeams[obj->Alliance], r1 = &allianceTeams; clobbers NZ flags)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getObjectAllianceTeam_800F49E.yaml
	thumb_func_start battle_getObjectAllianceTeam_800F49E
battle_getObjectAllianceTeam_800F49E:
	ldr r1, off_800F4D8 // =dword_203CFA0 
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	mov pc, lr
	thumb_func_end battle_getObjectAllianceTeam_800F49E

	thumb_local_start
sub_800F4A8:
	ldr r1, off_800F4DC // =dword_203F7E0 
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	mov pc, lr
	thumb_func_end sub_800F4A8

	thumb_local_start
sub_800F4B2:
	push {lr}
	ldr r1, off_800F4E0 // =dword_203F7E0 
	ldrb r2, [r5,#oBattleObject_Alliance]
	lsl r2, r2, #2
	ldr r3, [r1,r2]
	sub r3, r3, r0
	str r3, [r1,r2]
	push {r0}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	cmp r0, #0
	pop {r0}
	bne locret_800F4D2
	bl TakeBugfrags
locret_800F4D2:
	pop {pc}
	.balign 4, 0
off_800F4D4:
	.word byte_8021220
off_800F4D8:
	.word dword_203CFA0
off_800F4DC:
	.word dword_203F7E0
off_800F4E0:
	.word dword_203F7E0
	thumb_func_end sub_800F4B2

	thumb_local_start
sub_800F4E4:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, r1
	bl object_isValidPanel
	beq loc_800F4FE
	mov r0, r6
	mov r1, r7
	ldr r2, dword_800F504 // =0x10 
	ldr r3, dword_800F508 // =0x3880080 
	bl object_checkPanelParameters
	pop {r6,r7,pc}
loc_800F4FE:
	mov r0, #0
	pop {r6,r7,pc}
	.balign 4, 0
dword_800F504:
	.word 0x10
dword_800F508:
	.word 0x3880080
	thumb_func_end sub_800F4E4

	thumb_local_start
sub_800F50C:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, r1
	bl object_isValidPanel
	beq loc_800F526
	mov r0, r6
	mov r1, r7
	ldr r2, dword_800F52C // =0x10 
	ldr r3, dword_800F530 // =0xf880080 
	bl object_checkPanelParameters
	pop {r6,r7,pc}
loc_800F526:
	mov r0, #0
	pop {r6,r7,pc}
	.balign 4, 0
dword_800F52C:
	.word 0x10
dword_800F530:
	.word 0xF880080
	thumb_func_end sub_800F50C

	thumb_local_start
sub_800F534:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, r1
	bl object_isValidPanel
	beq loc_800F54E
	mov r0, r6
	mov r1, r7
	ldr r2, dword_800F554 // =0x10 
	ldr r3, dword_800F558 // =0x3800000 
	bl object_checkPanelParameters
	pop {r6,r7,pc}
loc_800F54E:
	mov r0, #0
	pop {r6,r7,pc}
	.balign 4, 0
dword_800F554:
	.word 0x10
dword_800F558:
	.word 0x3800000
	thumb_func_end sub_800F534

	thumb_local_start
sub_800F55C:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, r1
	bl object_isValidPanel
	beq loc_800F580
	ldrb r0, [r5,#oBattleObject_Unk_0c]
	sub r0, #1
	lsl r0, r0, #3
	ldr r3, off_800F584 // =byte_800F588 
	add r3, r3, r0
	ldr r2, [r3]
	ldr r3, [r3,#4]
	mov r0, r6
	mov r1, r7
	bl object_checkPanelParameters
	pop {r6,r7,pc}
loc_800F580:
	mov r0, #0
	pop {r6,r7,pc}
	.balign 4, 0
off_800F584:
	.word byte_800F588
byte_800F588:
	.byte 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x80, 0x3, 0x10, 0x0, 0x0, 0x0, 0x20
	.byte 0x0, 0x80, 0x3
	thumb_func_end sub_800F55C

	thumb_local_start
sub_800F598:
	push {r4,r6,r7,lr}
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	mov r0, #1
	ldr r1, [r3,#oCollisionData_FlagsFromCollision]
	mov r2, #0x54 
	ldr r2, [r3,r2]
	orr r1, r2
	ldr r2, dword_800F600 // =0xf3000000 
	tst r1, r2
	beq loc_800F5BC
	ldr r2, dword_800F5F8 // =0xa2000000 
	tst r1, r2
	bne loc_800F5B6
	neg r0, r0
	b loc_800F5C6
loc_800F5B6:
	ldr r2, dword_800F5FC // =0x51000000 
	tst r1, r2
	beq loc_800F5C6
loc_800F5BC:
	mov r0, #0
	mov r1, #0
	mov r2, #0
	mov r3, #0
	pop {r4,r6,r7,pc}
loc_800F5C6:
	push {r0}
	ldrb r1, [r3,#oCollisionData_HitModifierFinal]
	lsr r1, r1, #2
	mov r2, #0
loc_800F5CE:
	lsr r1, r1, #1
	bcs loc_800F5DA
	add r2, #1
	cmp r2, #4
	blt loc_800F5CE
	b loc_800F5E4
loc_800F5DA:
	mov r1, #3
	mul r2, r1
	ldr r1, off_800F5F4 // =byte_800F604 
	add r2, r2, r1
	b loc_800F5E4
loc_800F5E4:
	mov r1, #0
	ldrsb r1, [r2,r1]
	mul r0, r1
	mov r1, #1
	ldrsb r1, [r2,r1]
	ldrb r2, [r2,#2]
	pop {r3}
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_800F5F4:
	.word byte_800F604
dword_800F5F8:
	.word 0xA2000000
dword_800F5FC:
	.word 0x51000000
dword_800F600:
	.word 0xF3000000
byte_800F604:
	.byte 0xFF, 0x0, 0x6, 0x1, 0x0, 0x6, 0xFF, 0x0, 0x1, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0
	.byte 0x0
	thumb_func_end sub_800F598

	thumb_func_start setFieldBattleObject_800F614
// something to do with spawning actual field battle objects
// r0 is battle object
// r1 is alliance
// r2 is some param
setFieldBattleObject_800F614:
	push {lr}
	mov r3, #0xc
	mul r3, r1
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	add r1, r1, r3
	lsl r3, r2, #3
	add r1, r1, r3
	add r1, #oBattleState_Unk_a0
	tst r2, r2
	bne loc_800F648
	ldr r2, [r1]
	ldr r3, [r1,#4]
	tst r2, r2
	bne loc_800F636
	str r0, [r1]
	b locret_800F654
loc_800F636:
	tst r3, r3
	bne loc_800F63E
	str r0, [r1,#4]
	b locret_800F654
loc_800F63E:
	str r3, [r1]
	str r0, [r1,#4]
	mov r3, #0
	strh r3, [r2,#oBattleObject_HP]
	b locret_800F654
loc_800F648:
	ldr r2, [r1]
	str r0, [r1]
	tst r2, r2
	beq locret_800F654
	mov r3, #0
	strh r3, [r2,#oBattleObject_HP]
locret_800F654:
	pop {pc}
	thumb_func_end setFieldBattleObject_800F614

	thumb_func_start clearEntryOfBattleStateBattleObjectList_800F656
clearEntryOfBattleStateBattleObjectList_800F656:
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	add r0, #oBattleState_Unk_a0
	mov r1, #0
loc_800F65E:
	ldr r2, [r0]
	cmp r2, r5
	bne loc_800F668
	mov r2, #0
	str r2, [r0]
loc_800F668:
	add r0, #4
	add r1, #1
	cmp r1, #6
	blt loc_800F65E
	mov pc, lr
	thumb_func_end clearEntryOfBattleStateBattleObjectList_800F656

	thumb_func_start sub_800F672
sub_800F672:
	push {lr}
	bl battle_isBattleOver
	tst r0, r0
	bne loc_800F690
	bl battle_isTimeStop
	bne locret_800F6AA
	bl battle_isPaused
	bne locret_800F6AA
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bne loc_800F69A
loc_800F690:
	bl object_clearCollisionRegion // () -> void
	mov r0, #0
	strh r0, [r5,#oBattleObject_HP]
	pop {pc}
loc_800F69A:
	cmp r0, #0xb4
	bhi locret_800F6AA
	lsr r0, r0, #2
	bcc locret_800F6AA
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
locret_800F6AA:
	pop {pc}
	thumb_func_end sub_800F672

	thumb_local_start
sub_800F6AC:
	push {r5,lr}
	strb r2, [r0,#0x1c]
	strb r3, [r0,#0x1d]
	strb r4, [r0,#0x1e]
	str r6, [r0,#0x2c]
	mov r5, r0
	ldr r0, off_800F944 // =0x400 
	tst r1, r1
	beq loc_800F6C0
	ldr r0, off_800F948 // =0x800 
loc_800F6C0:
	bl object_setFlag2
	pop {r5,pc}
	thumb_func_end sub_800F6AC

	thumb_local_start
sub_800F6C6:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x14
	mov r7, sp
	ldrb r0, [r5,#0x16]
	lsl r0, r0, #3
	ldr r6, off_800F740 // =off_800F748 
	add r6, r6, r0
	ldr r2, [r6]
	ldr r3, [r6,#4]
	bl object_getPanelsFiltered
	mov r1, r0
	beq loc_800F6F6
	push {r1}
	bl GetPositiveSignedRNG
	pop {r1}
	svc 6
	ldrb r0, [r7,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	add sp, sp, #0x14
	pop {r4,r6,r7,pc}
loc_800F6F6:
	ldrb r0, [r5,#0x16]
	lsl r0, r0, #3
	ldr r6, off_800F744 // =byte_800F758 
	add r6, r6, r0
	ldr r2, [r6]
	ldr r3, [r6,#4]
	bl object_getPanelsExceptCurrentFiltered
	mov r1, r0
	beq loc_800F720
	push {r1}
	bl GetPositiveSignedRNG
	pop {r1}
	svc 6
	ldrb r0, [r7,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	add sp, sp, #0x14
	pop {r4,r6,r7,pc}
loc_800F720:
	mov r2, #0
	mov r3, #0
	bl object_getPanelsFiltered
	push {r0}
	bl GetPositiveSignedRNG
	pop {r1}
	svc 6
	ldrb r0, [r7,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	add sp, sp, #0x14
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_800F740:
	.word off_800F748
off_800F744:
	.word byte_800F758
off_800F748:
	.word LCDControl
	.word 0x0
	.word 0x8000000
	.word 0x0
byte_800F758:
	.byte 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0
	.byte 0x0
	thumb_func_end sub_800F6C6

	thumb_local_start
sub_800F768:
	push {lr}
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	ldrh r2, [r5,#oBattleObject_X16]
	lsl r2, r2, #0x10
	ldrh r3, [r5,#oBattleObject_Y16]
	lsl r3, r3, #0x10
	sub r2, r0, r2
	sub r0, r1, r3
	mov r1, r2
	push {r0,r1}
	push {r5}
	bl calcAngle_800117C
	pop {r5}
	strb r0, [r5,#oBattleObject_Unk_0c]
	mov r1, #8
	lsl r1, r1, #0x10
	push {r1}
	bl sub_80011A0
	str r0, [r5,#oBattleObject_XVelocity]
	str r1, [r5,#oBattleObject_YVelocity]
	pop {r4}
	pop {r0,r1}
	lsr r0, r0, #8
	mov r2, r0
	mul r0, r2
	lsr r1, r1, #8
	mov r2, r1
	mul r1, r2
	add r0, r0, r1
	svc 8
	lsl r0, r0, #8
	mov r1, r4
	svc 6
	tst r0, r0
	beq loc_800F7C4
	push {r0}
	mov r1, r0
	mov r0, #0x40 
	lsl r0, r0, #0x10
	svc 6
	str r0, [r5,#oBattleObject_ZVelocity]
	pop {r0}
	pop {pc}
loc_800F7C4:
	mov r0, #8
	lsl r0, r0, #0x10
	str r0, [r5,#oBattleObject_ZVelocity]
	mov r0, #0
	str r0, [r5,#oBattleObject_XVelocity]
	str r0, [r5,#oBattleObject_YVelocity]
	mov r0, #8
	pop {pc}
	thumb_func_end sub_800F768

	thumb_local_start
sub_800F7D4:
	mov r0, #1
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	add r1, #oBattleState_Unk_a0
	mov r2, #0
loc_800F7DE:
	ldr r3, [r1]
	tst r3, r3
	beq loc_800F7FA
	ldrb r4, [r3,#2]
	cmp r4, #0x93
	bne loc_800F7F0
	ldrb r4, [r3,#1]
	beq loc_800F7FA
	b locret_800F804
loc_800F7F0:
	ldrb r4, [r3,#2]
	cmp r4, #0x84
	bne locret_800F804
	ldrb r4, [r3,#1]
	bne locret_800F804
loc_800F7FA:
	add r1, #4
	add r2, #1
	cmp r2, #8
	blt loc_800F7DE
	mov r0, #0
locret_800F804:
	mov pc, lr
	thumb_func_end sub_800F7D4

	thumb_local_start
sub_800F806:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	add r0, #oBattleState_Unk_a0
	mov r1, #0
loc_800F810:
	ldr r2, [r0]
	cmp r2, r5
	beq loc_800F81E
	add r0, #4
	add r1, #1
	cmp r1, #6
	blt loc_800F810
loc_800F81E:
	ldr r0, off_800F824 // =byte_800F828 
	ldrb r0, [r0,r1]
	pop {pc}
	.balign 4, 0
off_800F824:
	.word byte_800F828
byte_800F828:
	.byte 0x0, 0x0, 0x1, 0x0, 0x0, 0x1, 0xFF, 0x0, 0x20, 0xB5, 0xAA, 0x7D
	.byte 0xEB, 0x6A, 0x5, 0x1C, 0x44, 0x48, 0x9, 0x42, 0x2, 0xD0, 0x44, 0x48
	.byte 0xAA, 0x75, 0xEB, 0x62, 0xA, 0xF0, 0x92, 0xFC, 0x20, 0xBD, 0x10, 0xB5
	.byte 0x6C, 0x6D, 0xA8, 0x7C, 0xE9, 0x7C, 0xFD, 0xF7, 0x5A, 0xF8, 0x0, 0x24
	.byte 0x81, 0x78, 0x5, 0x29, 0x0, 0xD1, 0x1, 0x24, 0x6B, 0x6D, 0x82, 0x33
	.byte 0x5, 0x21, 0x0, 0x20, 0x1A, 0x88, 0x12, 0x19, 0xE2, 0x40, 0x1A, 0x80
	.byte 0x80, 0x18, 0x2, 0x33, 0x1, 0x39, 0xF7, 0xDC, 0x1D, 0xF0, 0xCA, 0xFA
	.byte 0x6B, 0x6D, 0x80, 0x33, 0x18, 0x80, 0x10, 0xBD
	thumb_func_end sub_800F806

	thumb_func_start sub_800F884
sub_800F884:
	push {r5,lr}
	mov r5, r0
	beq locret_800F896
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	tst r0, r0
	beq locret_800F896
	ldr r0, dword_800F954 // =0x8000
	bl object_setFlag2
locret_800F896:
	pop {r5,pc}
	thumb_func_end sub_800F884

	thumb_func_start sub_800F898
sub_800F898:
	push {r5,lr}
	mov r5, r0
	beq locret_800F8AE
	bl sub_800F884
	ldr r0, [r5,#0x54]
	tst r0, r0
	beq locret_800F8AE
	ldr r0, dword_800F958 // =0x40000
	bl object_setFlag2
locret_800F8AE:
	pop {r5,pc}
	thumb_func_end sub_800F898

	thumb_func_start sub_800F8B0
sub_800F8B0:
	push {r4,r5,lr}
	mov r4, r5
	mov r5, r0
	beq locret_800F8CC
	bl sub_800F884
	ldr r0, [r5,#0x54]
	tst r0, r0
	beq locret_800F8CC
	ldr r0, dword_800F95C // =0x100000 
	ldrb r1, [r4,#oBattleObject_Alliance]
	lsl r0, r1
	bl object_setFlag2
locret_800F8CC:
	pop {r4,r5,pc}
	thumb_func_end sub_800F8B0

	thumb_func_start sub_800F8CE
sub_800F8CE:
	push {r4,lr}
	mov r4, #2
	ldr r1, dword_800F958 // =0x40000
	tst r0, r1
	beq loc_800F90A
	mov r4, #0
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	cmp r0, #0
	bne loc_800F8E8
	mov r0, #1
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	mov r0, #0x14
	strh r0, [r5,#oBattleObject_Timer]
loc_800F8E8:
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	orr r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	ldrh r0, [r5,#oBattleObject_Timer]
	mov r1, #2
	tst r0, r1
	bne loc_800F900
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
loc_800F900:
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bgt loc_800F90A
	mov r4, #1
loc_800F90A:
	mov r0, r4
	pop {r4,pc}
	thumb_func_end sub_800F8CE

	thumb_func_start sub_800F90E
sub_800F90E:
	push {r4,r6,lr}
	mov r4, r0
	bl object_getFlag2
	ldr r1, dword_800F960 // =0x200000
	tst r0, r1
	beq loc_800F922
	mov r0, #1
	lsl r0, r0, #8
	orr r4, r0
loc_800F922:
	ldrb r0, [r5,#oBattleObject_CurAnim]
	lsl r0, r0, #0x10
	orr r4, r0
	mov r0, r5
	bl sprite_getPalette
	lsl r0, r0, #0x18
	orr r4, r0
	bl sprite_getUnk0x2c
	mov r6, #0x34 
	add r6, r6, r5
	ldmia r6!, {r1-r3}
	bl sub_80E996E
	pop {r4,r6,pc}
	.balign 4, 0
off_800F944:
	.word 0x400
off_800F948:
	.word 0x800
	.word 0x1000
	.word 0x2000
dword_800F954:
	.word 0x8000
dword_800F958:
	.word 0x40000
dword_800F95C:
	.word 0x100000
dword_800F960:
	.word 0x200000
	thumb_func_end sub_800F90E

// symdb: For the current battle object in r5, returns the panel it would walk onto next given its facing alliance (or 0 if invalid / sliding)
// symdb: (r0 = unused arg passed to dirOffsetFromAlliance) -> r0 = next-panel-X, r1 = next-panel-Y ;
// symdb: returns (r0,r1) = (PanelX,PanelY) when valid, otherwise r0=0,r1=undefined
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_tryGetNextPanelInFacingDirection_800F964.yaml
	thumb_func_start battleObject_tryGetNextPanelInFacingDirection_800F964
battleObject_tryGetNextPanelInFacingDirection_800F964:
	push {r6,r7,lr}
	mov r6, r0
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xc
	tst r0, r1
	bne loc_800F994
	mov r0, r6
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl dirOffsetFromAlliance_800F9DE
	ldrb r6, [r5,#oBattleObject_PanelX]
	add r6, r6, r0
	ldrb r7, [r5,#oBattleObject_PanelY]
	add r7, r7, r1
	mov r0, r6
	mov r1, r7
	bl playerObjectMovingToPanelValidityRelated_800E618
	beq loc_800F994
	mov r0, r6
	mov r1, r7
	pop {r6,r7,pc}
loc_800F994:
	mov r0, #0
	pop {r6,r7,pc}
	thumb_func_end battleObject_tryGetNextPanelInFacingDirection_800F964

	thumb_func_start sub_800F998
sub_800F998:
	push {r4,r6,r7,lr}
	sub sp, sp, #0xc
	mov r6, r0
	mov r7, r1
	lsl r2, r2, #2
	ldr r3, off_800F9FC // =byte_800FA00 
	ldr r2, [r3,r2]
	str r2, [sp]
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xc
	tst r0, r1
	bne loc_800F9D8
	mov r4, #0
loc_800F9B6:
	add r0, sp, #0
	ldrb r0, [r0,r4]
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl dirOffsetFromAlliance_800F9DE
	add r0, r0, r6
	add r1, r1, r7
	str r0, [sp,#4]
	str r1, [sp,#8]
	bl playerObjectMovingToPanelValidityRelated_800E618
	ldr r0, [sp,#4]
	ldr r1, [sp,#8]
	bne loc_800F9DA
	add r4, #1
	cmp r4, #4
	blt loc_800F9B6
loc_800F9D8:
	mov r0, #0
loc_800F9DA:
	add sp, sp, #0xc
	pop {r4,r6,r7,pc}
	thumb_func_end sub_800F998

// symdb: Returns a dy/dx direction offset for a given direction index, remapping the source direction through object_getAllianceDirection.
// symdb: u32 sub_800F9DE(u32 r0 /* direction index */, u32 r1 /* source direction */, u32 lr) -> (r0 /*
// symdb: dy*alliance_dir */, r1 /* dx */); clobbers nz,c,v; preserves r4
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/dirOffsetFromAlliance_800F9DE.yaml
	thumb_local_start
dirOffsetFromAlliance_800F9DE:
	push {r4,lr}
	add r0, r0, r0
	ldr r4, off_800F9F8 // =byte_800FA14 
	add r4, r4, r0
	mov r0, r1
	bl object_getAllianceDirection
	mov r1, #0
	ldrsb r1, [r4,r1]
	mul r0, r1
	mov r1, #1
	ldrsb r1, [r4,r1]
	pop {r4,pc}
	.balign 4, 0
off_800F9F8:
	.word byte_800FA14
off_800F9FC:
	.word byte_800FA00
byte_800FA00:
	.byte 0x0, 0x0, 0x0, 0x0, 0x1, 0x3, 0x2, 0x4, 0x2, 0x4, 0x1, 0x3, 0x3, 0x2, 0x4, 0x1, 0x4
	.byte 0x1, 0x3, 0x2
byte_800FA14:
	.byte 0, 0
	.byte 0, -1
	.byte 0, 1
	.byte -1, 0
	.byte 1, 0
	.byte 0, 0
	thumb_func_end dirOffsetFromAlliance_800F9DE

	thumb_func_start sub_800FA20
sub_800FA20:
	push {lr}
	sub sp, sp, #0x18
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl dirOffsetFromAlliance_800F9DE
	str r0, [sp]
	str r1, [sp,#4]
	tst r1, r1
	bne loc_800FA42
	bl sub_8010368
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	ldr r4, [sp]
	bl sub_800D120
	b loc_800FA50
loc_800FA42:
	bl sub_8010368
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	ldr r4, [sp,#4]
	bl sub_800D15A
loc_800FA50:
	add sp, sp, #0x18
	pop {pc}
	thumb_func_end sub_800FA20

	thumb_func_start playerObject_checkDirectionButtons_800FA54
playerObject_checkDirectionButtons_800FA54:
	push {r6,r7,lr}
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xc
	tst r0, r1
	bne loc_800FA9C
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrh r1, [r0,#oAIData_JoypadHeld]
	mov r6, #1
	mov r2, #0x40 
	tst r1, r2
	bne loc_800FA88
	mov r6, #2
	mov r2, #0x80
	tst r1, r2
	bne loc_800FA88
	mov r6, #4
	mov r2, #0x10
	tst r1, r2
	bne loc_800FA88
	mov r6, #3
	mov r2, #0x20 
	tst r1, r2
	bne loc_800FA88
	b loc_800FA9C
loc_800FA88:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xf
	tst r0, r1
	beq loc_800FA98
	ldr r2, off_800FAA0 // =byte_800FAA4 
	ldrb r6, [r2,r6]
loc_800FA98:
	mov r0, r6
	pop {r6,r7,pc}
loc_800FA9C:
	mov r0, #0
	pop {r6,r7,pc}
	.balign 4, 0
off_800FAA0:
	.word byte_800FAA4
byte_800FAA4:
	.byte 0x0, 0x2, 0x1, 0x4, 0x3, 0x0, 0x0, 0x0
	thumb_func_end playerObject_checkDirectionButtons_800FA54

// symdb: Spawns a type-3 battle object on the panel in front of the given battle object and finishes its setup with an alliance-dependent stats byte.
// symdb: (r0, r1, r2, r3 = effect params, r5 = battle object) -> r0-r3 = sub_800FAF6 results; preserves
// symdb: r4-r7, clobbers flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_SpawnObjectOnFrontPanel_800FAAC.yaml
	thumb_func_start battle_SpawnObjectOnFrontPanel_800FAAC
battle_SpawnObjectOnFrontPanel_800FAAC:
	push {r4,r6,r7,lr}
	sub sp, sp, #8
	mov r4, r0
	mov r6, r1
	mov r7, r3
	bl object_getFrontDirection // () -> int
	ldrb r1, [r5,#oBattleObject_PanelX]
	add r0, r0, r1
	ldrb r1, [r5,#oBattleObject_PanelY]
	str r0, [sp]
	str r1, [sp,#4]
	mov r3, r7
	bl battle_SpawnAndInitObjectType3_80C4FFE
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #2
	bl GetBattleNaviStatsByte
	mov r2, r0
	ldr r0, [sp]
	ldr r1, [sp,#4]
	bl scanFrontPanels_800FAF6
	add sp, sp, #8
	pop {r4,r6,r7,pc}
	thumb_func_end battle_SpawnObjectOnFrontPanel_800FAAC

// symdb: Stores the player's current HP into the battle state (oBattleState_Unk_34), keeping a snapshot of the player's HP for later comparison.
// symdb: void battle_snapshotPlayerHP(void); // in: r10 = toolkit; out: r2 as left by battle_findPlayer,
// symdb: flags clobbered; r4-r6 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_snapshotPlayerHP_800FAE0.yaml
	thumb_func_start battle_snapshotPlayerHP_800FAE0
battle_snapshotPlayerHP_800FAE0:
	push {r4,lr}
	mov r4, r10
	ldr r4, [r4,#oToolkit_BattleStatePtr]
	ldrb r0, [r4,#oBattleState_Unk_0d]
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	tst r0, r0
	beq locret_800FAF4
	ldrh r1, [r0,#oBattleObject_HP]
	strh r1, [r4,#oBattleState_Unk_34]
locret_800FAF4:
	pop {r4,pc}
	thumb_func_end battle_snapshotPlayerHP_800FAE0

// symdb: Walks an object forward panel-by-panel up to 5 panels and returns a per-column result byte (e.g. free panel range) used by battle panel/state logic.
// symdb: u8 scanFrontPanels_800FAF6(u32 x, u32 y, u32 column, struct BattleObject* object /* r5 */) ->
// symdb: r0=tableByte, r1=index, r2=6, flags from col*6 + steps
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/scanFrontPanels_800FAF6.yaml
	thumb_func_start scanFrontPanels_800FAF6
scanFrontPanels_800FAF6:
	push {r4,r6,r7,lr}
	sub sp, sp, #8
	str r2, [sp,#4]
	mov r6, r0
	mov r7, r1
	bl object_getFrontDirection // () -> int
	mov r4, r0
	mov r0, #0
	str r0, [sp]
loc_800FB0A:
	mov r0, r6
	mov r1, r7
	bl object_getPanelParameters
	tst r0, r0
	beq loc_800FB2C
	ldr r1, off_800FB48 // =byte_800FB4C 
	ldrb r2, [r5,#oBattleObject_Alliance]
	lsl r2, r2, #2
	ldr r1, [r1,r2]
	tst r0, r1
	bne loc_800FB2C
	ldr r0, [sp]
	add r0, #1
	str r0, [sp]
	add r6, r6, r4
	b loc_800FB0A
loc_800FB2C:
	ldr r0, [sp]
	cmp r0, #5
	ble loc_800FB34
	mov r0, #5
loc_800FB34:
	ldr r1, [sp,#4]
	mov r2, #6
	mul r1, r2
	add r1, r1, r0
	ldr r0, off_800FB44 // =byte_80209CC
	ldrb r0, [r0,r1]
	add sp, sp, #8
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_800FB44:
	.word byte_80209CC
off_800FB48:
	.word byte_800FB4C
byte_800FB4C:
	.byte 0x80, 0x0, 0x88, 0xD, 0x80, 0x0, 0x88, 0xE
	thumb_func_end scanFrontPanels_800FAF6

// symdb: Player AI: if A-pressed/held, try to fire the queued attack chip for the controlled battle object, clearing the pending-input flag and returning the chosen chip id, damage and attack boost.
// symdb: (r5 = *BattleObject, r10 = *Toolkit) -> r0 = chip id (u16), r1 = damage (u16), r2 = attack boost
// symdb: (u16); side effects mutate AIData+0x44 flags, AIData+0xA0 AttackVars and call object_setAttack2
// symdb: / useChipRelated_80127C0 / sub_80117BA / sub_8012CB2.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/playerAI_tryExecuteAttackChip_800FB54.yaml
	thumb_func_start playerAI_tryExecuteAttackChip_800FB54
playerAI_tryExecuteAttackChip_800FB54:
	push {r4,r7,lr}
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #oAIData_AttackVars
	bl object_getFlag // () -> int
	ldr r1, off_800FC28 // =0x1000 
	tst r0, r1
	bne loc_800FB70
	bl GetAIData_Unk_44_Flag
	mov r4, r0
	// 0x4, 0x8 set when A is pressed or held
	// see pwrAtkRelated_readsFromJoypad_8012FC8
	ldr r1, dword_800FED4 // =0x1000c 
	and r4, r1
	bne loc_800FB74
loc_800FB70:
	ldr r0, dword_800FC2C // =0xffff 
	pop {r4,r7,pc}
loc_800FB74:
	mov r0, #0
	mov r1, #8
	tst r4, r1
	beq loc_800FBEE
	mov r0, r5
	bl getBattleObjectStateInfo_800EDD0
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#6]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	cmp r0, #0xa
	bne loc_800FB9A
	mov r2, #0xa0
	add r2, r2, r1
	mov r0, #0
	strh r0, [r2,#oAIAttackVars_Unk_14]
	ldrb r1, [r1,#oAIData_BeastOutAPwrAtk]
	b loc_800FB9C
loc_800FB9A:
	ldrb r1, [r1,#oAIData_APwrAtk]
loc_800FB9C:
	cmp r1, #0x18
	beq loc_800FBE6
	cmp r1, #0xff
	beq loc_800FBEE
	cmp r1, #0xd
	beq loc_800FBEC
	cmp r1, #0x1f
	beq loc_800FBEC
	cmp r1, #0x20 
	beq loc_800FBEC
	cmp r1, #0x29 
	beq loc_800FBEC
	cmp r1, #0x2d 
	beq loc_800FBEC
	cmp r1, #5
	beq loc_800FBEC
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	mov r0, r1
	bl sub_80117BA
	push {r0}
	bl object_setAttack2
	pop {r0}
	cmp r0, #0x52 
	beq loc_800FBE0
	cmp r0, #0x41 
	bne loc_800FC18
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xf
	bne loc_800FC18
loc_800FBE0:
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_1d]
	b loc_800FC18
loc_800FBE6:
	bl sub_8012CB2
	b loc_800FBEE
loc_800FBEC:
	mov r0, #1
loc_800FBEE:
	bl useChipRelated_80127C0
	bl object_setAttack2
	ldrb r0, [r7,#oAIAttackVars_Unk_1b]
	cmp r0, #0
	bne loc_800FC0C
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0
	cmp r0, #0xb
	blt loc_800FC18
	cmp r0, #0x18
	bgt loc_800FC18
loc_800FC0C:
	// idx
	ldrh r0, [r7,#oAIAttackVars_Unk_14]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#0xf]
	strb r0, [r7,#oAIAttackVars_Unk_1d]
	b loc_800FC18
loc_800FC18:
	ldr r0, dword_800FED4 // =0x1000c 
	bl ClearAIData_Unk_44_Flag
	ldrh r0, [r7,#oAIAttackVars_Unk_14]
	ldrh r1, [r7,#oAIAttackVars_Damage]
	ldrh r2, [r7,#oAIAttackVars_AttackBoost]
	pop {r4,r7,pc}
	.balign 4, 0
off_800FC28:
	.word 0x1000
dword_800FC2C:
	.word 0xFFFF
	thumb_func_end playerAI_tryExecuteAttackChip_800FB54

	thumb_func_start sub_800FC30
sub_800FC30:
	push {r4,r7,lr}
	mov r0, r5
	mov r1, #0
	bl getBattleObjectStateInfo_800EDD0
	ldr r1, dword_800FED8 // =0xffff 
	cmp r0, r1
	beq locret_800FC7A
	mov r1, #0x52 
	cmp r0, r1
	beq loc_800FC58
	mov r1, #0x53 
	cmp r0, r1
	beq loc_800FC58
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#9]
	mov r1, #1
	tst r0, r1
	beq loc_800FC5C
loc_800FC58:
	ldr r0, dword_800FED8 // =0xffff 
	b locret_800FC7A
loc_800FC5C:
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #0xa0
	mov r0, #0
	bl useChipRelated_80127C0
	ldr r1, off_800FCB8 // =byte_800FCD5
	// comparing with pointer???
	cmp r0, r1
	beq locret_800FC7A
	bl object_setAttack2
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_1d]
	ldrh r0, [r7,#oAIAttackVars_Unk_14]
	ldrh r1, [r7,#oAIAttackVars_Damage]
	ldrh r2, [r7,#oAIAttackVars_AttackBoost]
locret_800FC7A:
	pop {r4,r7,pc}
	thumb_func_end sub_800FC30

// symdb: Draws the next card from an alliance's deck into its battle hand during card selection, stopping at a full hand or an empty deck.
// symdb: void battle_drawCardToHand_800FC7C(BattleObject* obj /* r5 */); leaves r1 = next card id (or
// symdb: 0xFFFF), r2 = 0xFFFF deck-end marker, r3 = hand address; sets c/v per the final CMP (hand count
// symdb: vs 5, card vs 0xFFFF) or ADD (count+1), clobbers r0 and nz flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_drawCardToHand_800FC7C.yaml
	thumb_func_start battle_drawCardToHand_800FC7C
battle_drawCardToHand_800FC7C:
	push {lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getBattleHandAddr_8010018
	mov r3, r0
	ldrb r0, [r3]
	cmp r0, #5
	bge locret_800FC9C
	lsl r1, r0, #1
	add r1, #2
	ldrh r1, [r3,r1]
	ldr r2, dword_800FED8 // =0xffff 
	cmp r1, r2
	beq locret_800FC9C
	add r0, #1
	strb r0, [r3]
locret_800FC9C:
	pop {pc}
	thumb_func_end battle_drawCardToHand_800FC7C

// symdb: Looks up a chip's class byte from one of two ROM tables and returns a flag indicating which table was used.
// symdb: u32 sub_800FC9E(u32 class, u32 code); // returns table byte in r2, flag (0 or 8) in r1
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chip_class_lookup_800FC9E.yaml
	thumb_func_start chip_class_lookup_800FC9E
chip_class_lookup_800FC9E:
	cmp r0, #0
	bne loc_800FCAA
	ldr r0, off_800FCB4 // =byte_800FCBC 
	ldrb r2, [r0,r1]
	mov r1, #0
	mov pc, lr
loc_800FCAA:
	ldr r1, off_800FCB8 // =byte_800FCD5 
	ldrb r2, [r0,r1]
	mov r1, #8
	mov pc, lr
	.balign 4, 0
off_800FCB4:
	.word byte_800FCBC
off_800FCB8:
	.word byte_800FCD5
byte_800FCBC:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xB, 0xC, 0x1, 0x2, 0x3
	.byte 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC
byte_800FCD5:
	.byte 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0x0, 0x0, 0x0
	thumb_func_end chip_class_lookup_800FC9E

	thumb_local_start
sub_800FCE4:
	push {lr}
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	bl chip_class_lookup_800FC9E
	pop {pc}
	thumb_func_end sub_800FCE4

	thumb_func_start sub_800FCFC
sub_800FCFC:
	ldr r1, off_800FEDC // =byte_80212BB 
	ldrb r0, [r1,r0]
	ldrb r2, [r5,#oBattleObject_Param1]
	ldr r1, off_800FD58 // =byte_800FD5C 
	ldrb r1, [r1,r2]
	mul r0, r1
	mov pc, lr
	thumb_func_end sub_800FCFC

// symdb: Compute a per-battle-actor beast-out cost multiplier (NaviStats 0x29 * mapping byte) for AI choice
// symdb: (r5 = BattleObject) -> r0 = byte_80212BB[mapping_idx(NaviStats_0x29)] * cost_factor ; side
// symdb: effects: clobbers r4,r7,nz,cv
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_aiActorKind_getBeastOutCostBase_800FD0A.yaml
	thumb_local_start
battle_aiActorKind_getBeastOutCostBase_800FD0A:
	push {r4,r7,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r1, off_800FEE0 // =byte_80212BB 
	ldrb r7, [r1,r0]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	cmp r0, #2
	bne loc_800FD26
	mov r0, #4
	b loc_800FD40
loc_800FD26:
	ldrb r0, [r4,#oAIData_ActorType]
	cmp r0, #2
	bne loc_800FD3A
	bl GetAIDataUnk0x48Flag
	ldr r1, dword_800FEE4 // =0x200
	tst r0, r1
	beq loc_800FD3A
	mov r0, #1
	b loc_800FD40
loc_800FD3A:
	ldrb r2, [r4,#oAIData_Version_16]
	ldr r1, off_800FD58 // =byte_800FD5C 
	ldrb r0, [r1,r2]
loc_800FD40:
	mul r0, r7
	pop {r4,r7,pc}
	thumb_func_end battle_aiActorKind_getBeastOutCostBase_800FD0A

	thumb_local_start
sub_800FD44:
	push {lr}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r1, off_800FEE8 // =byte_80212BB 
	ldrb r0, [r1,r0]
	mov r1, #1
	mul r0, r1
	pop {pc}
	.balign 4, 0
off_800FD58:
	.word byte_800FD5C
byte_800FD5C:
	.byte 0x0, 0x0, 0x0, 0x2, 0x3, 0x0, 0x0, 0x0
	thumb_func_end sub_800FD44

	thumb_local_start
sub_800FD64:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#0xd]
	mov r1, #0x29
	bl GetBattleNaviStatsByte
	add r0, r0, r0
	ldr r2, off_800FD84 // =byte_800FD88
	add r2, r2, r0
	mov r0, #0
	ldrsb r0, [r2,r0]
	mov r1, #1
	ldrsb r1, [r2,r1]
	pop {pc}
	.balign 4, 0
	thumb_func_end sub_800FD64

off_800FD84:
	.word byte_800FD88
byte_800FD88:
	.byte 0x0, 0xC9, 0x0, 0xBD, 0xF8, 0xC5, 0xF4, 0xAC, 0x0, 0xC0
	.byte 0x3, 0xB8, 0xFC, 0xB8, 0xFF, 0xC2, 0xFB, 0xBA, 0xFB, 0xB1
	.byte 0x4, 0xC4, 0x0, 0xC9

	thumb_local_start
dead_800FDA0:
	push {r5, lr}
	push {r1}
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	add r5, r0, #0
	pop {r1}
	beq loc_800FDB4
	mov r0, #4
	bl SetAIData_Unk_44_Flag
loc_800FDB4:
	pop {r5, pc}
	thumb_func_end dead_800FDA0

// symdb: Wrapper that resets the working object's counter timer to the default 0x10 frames via object_setCounterTime.
// symdb: void object_setDefaultCounterTime(void) — reads r5, r10, lr; everything else (r0-r3, lr, c, v,
// symdb: nz) reflects whatever object_setCounterTime leaves behind
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_setDefaultCounterTime.yaml
	thumb_func_start object_setDefaultCounterTime
object_setDefaultCounterTime:
	push {lr}
	mov r0, #0x10
	bl object_setCounterTime
	pop {pc}
	thumb_func_end object_setDefaultCounterTime

	thumb_func_start setChipsForPlayerObjects_800FDC0
setChipsForPlayerObjects_800FDC0:
	push {r4-r6,lr}
	mov r4, r10
	ldr r4, [r4,#oToolkit_BattleStatePtr]
	add r4, #oBattleState_AlivePlayerActors
	mov r6, #0
loc_800FDCA:
	ldr r5, [r4]
	tst r5, r5
	beq loc_800FDE0
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	tst r0, r0
	beq loc_800FDE0
	ldrb r1, [r0,#oAIData_ActorType]
	cmp r1, #2
	bne loc_800FDE0
	bl setChipsForPlayerObject_800FDEA
loc_800FDE0:
	add r4, #4
	add r6, #1
	cmp r6, #8
	blt loc_800FDCA
	pop {r4-r6,pc}
	thumb_func_end setChipsForPlayerObjects_800FDC0

// symdb: Records how many chips a battle object holds from its alliance's hand and the first chip's ID onto the battle object.
// symdb: void setChipsFromAllianceHand_800FDEA(BattleObject* obj /*r5*/) — also passes r4/lr as scratch
// symdb: inputs; leaves r1 = address of the 0xFFFF terminator entry, r2 = r3 = 0xFFFF in the output
// symdb: registers, preserves r4/r5, clobbers nzcv flags.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/setChipsForPlayerObject_800FDEA.yaml
	thumb_local_start
setChipsForPlayerObject_800FDEA:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getBattleHandAddr_8010018
	ldrb r1, [r0]
	add r1, r1, r1
	add r1, #2
	add r1, r1, r0
	mov r0, #0
	ldr r3, dword_800FED8 // =0xffff 
	ldrh r4, [r1]
loc_800FE00:
	ldrh r2, [r1]
	cmp r2, r3
	beq loc_800FE0C
	add r0, #1
	add r1, #2
	b loc_800FE00
loc_800FE0C:
	strb r0, [r5,#oBattleObject_ChipsHeld]
	strh r4, [r5,#oBattleObject_Chip]
	pop {r4,pc}
	thumb_func_end setChipsForPlayerObject_800FDEA

// symdb: Reads a halfword from an AI parameter table indexed by the battle object's AI version, with a special multiplier-scaled entry for AI version 4.
// symdb: u16 battle_aiGetVersionedTableEntry_ADDRESS(const void* table, BattleObject* obj) — r0 = table
// symdb: base, r5 = battle object; returns r0 = table value (halfword), r1 = AI data pointer, r2 =
// symdb: version*2 or the multiplier byte; flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_aiGetVersionedTableEntry_800FE12.yaml
	thumb_func_start battle_aiGetVersionedTableEntry_800FE12
battle_aiGetVersionedTableEntry_800FE12:
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	ldrb r2, [r1,#oAIData_Version_16]
	cmp r2, #4
	beq loc_800FE20
	add r2, r2, r2
	ldrh r0, [r0,r2]
	mov pc, lr
loc_800FE20:
	ldrb r2, [r1,#oAIData_Unk_0c]
	ldrh r0, [r0,#8]
	mul r0, r2
	mov pc, lr
	thumb_func_end battle_aiGetVersionedTableEntry_800FE12

	thumb_func_start sub_800FE28
sub_800FE28:
	push {lr}
	push {r0}
	bl battle_getAiDifficultyTier_800FE36
	pop {r1}
	ldrb r0, [r0,r1]
	pop {pc}
	thumb_func_end sub_800FE28

// symdb: Reads the enemy's AI data difficulty byte and maps it to a tier (0-2), but only for AI data version 4.
// symdb: int sub_800FE36(battle object in r5) -> r0 = tier (0-2, or version byte on early exit), r1 = AI
// symdb: data pointer, r2 = raw difficulty byte (version 4 only); NZCV set by the last comparison
// symdb: performed
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getAiDifficultyTier_800FE36.yaml
	thumb_func_start battle_getAiDifficultyTier_800FE36
battle_getAiDifficultyTier_800FE36:
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r1,#oAIData_Version_16]
	cmp r0, #4
	beq loc_800FE40
	mov pc, lr
loc_800FE40:
	mov r0, #0
	ldrb r2, [r1,#oAIData_Unk_0c]
	cmp r2, #3
	ble locret_800FE50
	mov r0, #1
	cmp r2, #6
	ble locret_800FE50
	mov r0, #2
locret_800FE50:
	mov pc, lr
	thumb_func_end battle_getAiDifficultyTier_800FE36

// symdb: Counts how many Navi bonus-stat fields are currently set on the allied BattleObject.
// symdb: u32 countActiveNaviBonuses_800FE52(u32 r5_battleObject); // r0 = active bonus count; r4, r6
// symdb: preserved; NZCV clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/countActiveNaviBonuses_800FE52.yaml
	thumb_func_start countActiveNaviBonuses_800FE52
countActiveNaviBonuses_800FE52:
	push {r4,lr}
	mov r4, #0
	mov r1, #0x31 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #1
	bne loc_800FE62
	add r4, #1
loc_800FE62:
	mov r1, #0x13
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800FE6E
	add r4, #1
loc_800FE6E:
	mov r1, #0x14
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800FE7A
	add r4, #1
loc_800FE7A:
	mov r1, #0x16
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800FE86
	add r4, #1
loc_800FE86:
	mov r1, #0x54 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800FE92
	add r4, #1
loc_800FE92:
	mov r1, #0x24 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800FE9E
	add r4, #1
loc_800FE9E:
	mov r1, #0x18
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800FEAA
	add r4, #1
loc_800FEAA:
	mov r1, #0x19
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800FEB6
	add r4, #1
loc_800FEB6:
	mov r1, #0x1a
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800FEC2
	add r4, #1
loc_800FEC2:
	mov r1, #0x63 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_800FECE
	add r4, #1
loc_800FECE:
	mov r0, r4
	pop {r4,pc}
	.balign 4, 0
dword_800FED4:
	.word 0x1000C
dword_800FED8:
	.word 0xFFFF
off_800FEDC:
	.word byte_80212BB
off_800FEE0:
	.word byte_80212BB
dword_800FEE4:
	.word 0x200
off_800FEE8:
	.word byte_80212BB
	thumb_func_end countActiveNaviBonuses_800FE52

// symdb: Initialize the battle object's AI data block, picking values from the live Navi stats or from a per-alliance template table based on the alliance byte.
// symdb: void sub_800FEEC(u32 r5_battleObject, u32 r10_unused, void* lr); /* returns u32 r6_aidata;
// symdb: clobbers nz c v r0 r1 r2 r4 lr */
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_initAIData_800FEEC.yaml
	thumb_local_start
battleObject_initAIData_800FEEC:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_800FF36
	bl GetBattleMode
	cmp r0, #9
	bne loc_800FF0A
	mov r1, #0x44 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	b loc_800FF0C
loc_800FF0A:
	mov r0, #0xff
loc_800FF0C:
	strb r0, [r4,#oAIData_Unk_04]
	mov r1, #4
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	strb r0, [r4,#oAIData_BButton]
	mov r1, #5
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl ai_setBeastOutPwrAtk_800FFAA
	mov r1, #0x39 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	strb r0, [r4,#oAIData_APwrAtk]
	mov r1, #7
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	strb r0, [r4,#oAIData_BLeftAbility]
	mov r0, #0xff
	strb r0, [r4,#oAIData_BeastOutAPwrAtk]
	pop {r4,pc}
loc_800FF36:
	mov r2, #6
	mul r0, r2
	ldr r1, off_800FFE0 // =byte_8020354 
	add r0, r0, r1
	ldrb r1, [r0]
	strb r1, [r4,#oAIData_Unk_04]
	ldrb r1, [r0,#1]
	strb r1, [r4,#oAIData_APwrAtk]
	ldrb r1, [r0,#2]
	strb r1, [r4,#oAIData_BButton]
	push {r0}
	ldrb r0, [r0,#3]
	bl ai_setBeastOutPwrAtk_800FFAA
	pop {r0}
	ldrb r1, [r0,#4]
	strb r1, [r4,#oAIData_BLeftAbility]
	ldrb r1, [r0,#5]
	strb r1, [r4,#oAIData_BeastOutAPwrAtk]
	pop {r4,pc}
	thumb_func_end battleObject_initAIData_800FEEC

// symdb: Refreshes the battling Navi's AI data block (B-button, attack powers, BeastOut power) from the alliance's navi-stats table each turn/setup.
// symdb: void sub_800FF5E(void /* battle object in r5 */); /* clobbers r0,r1,r2,lr; flags NZCV; preserves
// symdb: r4,r6 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_800FF5E.yaml
	thumb_local_start
sub_800FF5E:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne locret_800FFA8
	bl GetBattleMode
	cmp r0, #9
	bne loc_800FF7C
	mov r1, #0x44 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	b loc_800FF7E
loc_800FF7C:
	mov r0, #0xff
loc_800FF7E:
	strb r0, [r4,#oAIData_Unk_04]
	mov r1, #4
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	strb r0, [r4,#oAIData_BButton]
	mov r1, #5
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl ai_setBeastOutPwrAtk_800FFAA
	mov r1, #0x39 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	strb r0, [r4,#oAIData_APwrAtk]
	mov r1, #7
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	strb r0, [r4,#oAIData_BLeftAbility]
	mov r0, #0xff
	strb r0, [r4,#oAIData_BeastOutAPwrAtk]
	pop {r4,pc}
locret_800FFA8:
	pop {r4,pc}
	thumb_func_end sub_800FF5E

// symdb: Writes the AI's held power-attack id, making any Beast Out value (0x21-0x26) stick until replaced, and fixes the B-button remap while in Beast state.
// symdb: u32 ai_setBeastOutPwrAtk(AIData* ai /* r4 */, u8 value /* r0 */); returns report in r2 (value
// symdb: written when in Beast state, otherwise the caller's incoming r2 passes through)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ai_setBeastOutPwrAtk_800FFAA.yaml
	thumb_local_start
ai_setBeastOutPwrAtk_800FFAA:
	push {lr}
	cmp r0, #0x21 
	blt loc_800FFB4
	cmp r0, #0x26 
	ble loc_800FFBE
loc_800FFB4:
	ldrb r1, [r4,#oAIData_BPwrAtk]
	cmp r1, #0x21 
	blt loc_800FFBE
	cmp r1, #0x26 
	ble loc_800FFC0
loc_800FFBE:
	strb r0, [r4,#oAIData_BPwrAtk]
loc_800FFC0:
	ldrb r0, [r4,#oAIData_BPwrAtk]
	cmp r0, #0x21 
	blt locret_800FFDE
	cmp r0, #0x26 
	bgt locret_800FFDE
	ldrb r0, [r4,#oAIData_BButton]
	mov r2, #0
	cmp r0, #4
	beq loc_800FFDC
	cmp r0, #3
	beq loc_800FFDC
	mov r2, #0x2b 
	cmp r0, #0x2c 
	bne locret_800FFDE
loc_800FFDC:
	strb r2, [r4,#oAIData_BButton]
locret_800FFDE:
	pop {pc}
	.balign 4, 0
off_800FFE0:
	.word byte_8020354
	thumb_func_end ai_setBeastOutPwrAtk_800FFAA

	thumb_func_start SetAIData_Unk_44_Flag
SetAIData_Unk_44_Flag:
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldr r1, [r3,#oAIData_Unk_44]
	orr r1, r0
	str r1, [r3,#oAIData_Unk_44]
	mov pc, lr
	thumb_func_end SetAIData_Unk_44_Flag

// symdb: Clears the bit(s) selected by the mask in a battle object's AI-data flags word at offset Unk_44, likely releasing an AI state/condition flag mid-battle.
// symdb: void ClearAIData_Unk_44_Flag(u32 mask /* r0 */, BattleObject *obj /* r5 */); returns updated
// symdb: flags in r1, AI data pointer in r3, NZ flags set on the updated value; tail-calls via lr.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ClearAIData_Unk_44_Flag.yaml
	thumb_func_start ClearAIData_Unk_44_Flag
ClearAIData_Unk_44_Flag:
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldr r1, [r3,#oAIData_Unk_44]
	bic r1, r0
	str r1, [r3,#oAIData_Unk_44]
	mov pc, lr
	thumb_func_end ClearAIData_Unk_44_Flag

	thumb_local_start
sub_800FFF8:
	ldr r3, [r5,#0x58]
	ldr r0, [r3,#0x44]
	mov pc, lr
	thumb_func_end sub_800FFF8

// symdb: Returns a boolean-style flag stored at offset 0x44 of a battle object's AI data block.
// symdb: u32 BattleObject_GetAIFlag44(battle_object *obj in r5); returns flag in r0, AI data pointer in
// symdb: r3
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/GetAIData_Unk_44_Flag.yaml
	thumb_func_start GetAIData_Unk_44_Flag
GetAIData_Unk_44_Flag:
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r3,#oAIData_Unk_44]
	mov pc, lr
	thumb_func_end GetAIData_Unk_44_Flag

	thumb_func_start getCurChipInBattleHand_8010004
getCurChipInBattleHand_8010004:
	push {lr}
loc_8010006:
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getBattleHandAddr_8010018
	mov r2, r0
	ldrb r1, [r2]
	add r1, r1, r1
	add r1, #2
	ldrh r0, [r2,r1]
	pop {pc}
	thumb_func_end getCurChipInBattleHand_8010004

// symdb: Returns the address of a battle hand slot, indexing the hand array at 0x20349C0 in 0x50-byte strides.
// symdb: u32* getBattleHandSlotAddress(u32 handIndex); // in r0 = slot index, returns r0 = slot address,
// symdb: r1 = hand array base
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getBattleHandAddr_8010018.yaml
	thumb_func_start getBattleHandAddr_8010018
getBattleHandAddr_8010018:
	mov r1, #0x50 
	mul r0, r1
	ldr r1, off_801021C // =byte_20349C0 
	add r0, r0, r1
	mov pc, lr
	thumb_func_end getBattleHandAddr_8010018

// symdb: Returns the AI data pointer of the player-side (or opponent-side, per argument) battle object.
// symdb: bool battle_getPlayerAIData(bool alliance) -> AIData* (r0 in: alliance flag, r0 out:
// symdb: BattleObject.AIDataPtr)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getPlayerAIData_8010022.yaml
	thumb_local_start
battle_getPlayerAIData_8010022:
	push {lr}
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	ldr r0, [r0,#oBattleObject_AIDataPtr]
	pop {pc}
	thumb_func_end battle_getPlayerAIData_8010022

// symdb: Returns a palette index computed from a battle object's Navi (B-side) stats and AI data, used to recolor a navi sprite palette.
// symdb: (r5 = battleObject) -> r0 = palette index ; no other side effects (callee-saved r4/r7 restored)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_pickPaletteIndexForNavi_801002C.yaml
	thumb_func_start battle_pickPaletteIndexForNavi_801002C
battle_pickPaletteIndexForNavi_801002C:
	push {r4,r7,lr}
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r7,#oAIData_ActorType]
	cmp r0, #2
	bne loc_801009C
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_8010096
	mov r4, #2
	bl GetAIDataUnk0x48Flag
	ldr r1, off_8010220 // =0x200 
	tst r0, r1
	beq loc_8010050
	mov r4, #1
	b loc_8010082
loc_8010050:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, #0
	cmp r0, #0
	beq loc_801006A
	cmp r0, #0xb
	beq loc_801006A
	cmp r0, #0xc
	beq loc_801006A
	ldr r1, off_8010224 // =byte_80203EA 
	ldrb r4, [r1,r0]
	b loc_801009E
loc_801006A:
	mov r1, #0xe
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, #4
	cmp r0, #0xff
	beq loc_8010078
	mov r4, #0
loc_8010078:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_801009E
loc_8010082:
	mov r1, #0x10
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_8010092
	mov r1, #5
	mul r0, r1
	add r0, #0x12
loc_8010092:
	add r4, r4, r0
	b loc_801009E
loc_8010096:
	bl battle_aiActorKind_getBeastOutCostBase_800FD0A
	pop {r4,r7,pc}
loc_801009C:
	mov r4, #0
loc_801009E:
	mov r0, r4
	pop {r4,r7,pc}
	.balign 4, 0
	.word byte_80100A8
byte_80100A8:
	.byte 0x0, 0x5, 0x14, 0xA, 0xF, 0x0, 0x0, 0x0, 0x10, 0xB5, 0x4, 0x24
	.byte 0xFA, 0x21, 0x89, 0x0, 0x88, 0x42, 0xA, 0xDA, 0x0, 0x24, 0xFA, 0x21
	.byte 0x49, 0x18, 0x88, 0x42, 0x5, 0xDA, 0x3, 0x24, 0xEB, 0x21, 0x49, 0x18
	.byte 0x88, 0x42, 0x0, 0xDA, 0x2, 0x24, 0x20, 0x1C, 0x10, 0xBD, 0x10, 0xB5
	.byte 0x29, 0x21, 0x3, 0xF0, 0x4B, 0xFB, 0x0, 0x28, 0x1, 0xD1, 0x1, 0x20
	.byte 0x10, 0xBD, 0xFF, 0xF7, 0x2D, 0xFE, 0x10, 0xBD
	thumb_func_end battle_pickPaletteIndexForNavi_801002C

// symdb: Updates a battle object's navi sprite palette, using a dedicated handler for cross/beast transformed states and a computed palette otherwise.
// symdb: void battle_refreshNaviSpritePaletteFromForm(void *battleObj /* r0 */, ... /* r2-r7,r10 pass
// symdb: through to helpers */) -> palette-related values in r0/r1 from sub_801002C path
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_refreshNaviSpritePaletteFromForm_80100EC.yaml
	thumb_func_start battle_refreshNaviSpritePaletteFromForm_80100EC
battle_refreshNaviSpritePaletteFromForm_80100EC:
	push {lr}
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0x17
	blt loc_8010102
	cmp r0, #0x18
	bgt loc_8010102
	bl sub_8016A38
	b locret_801010A
loc_8010102:
	bl battle_pickPaletteIndexForNavi_801002C
	bl sprite_setPalette // (int pallete) -> void
locret_801010A:
	pop {pc}
	thumb_func_end battle_refreshNaviSpritePaletteFromForm_80100EC

	thumb_local_start
sub_801010C:
	push {lr}
	ldrb r0, [r5,#0x16]
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	ldr r0, [r0,#0x58]
	str r0, [r5,#0x58]
	pop {pc}
	thumb_func_end sub_801010C

// symdb: Clears the Power Attack (PwrAtk) state and button fields in the battle object's AIAttackVars sub-struct and then runs the lone helper sub_80E1662.
// symdb: (r5 = BattleObject*) -> void ; clears AIAttackVars.Unk_1d = 0, AIAttackVars.Unk_1e = 0 (u16),
// symdb: then tail-calls sub_80E1662 with r5 preserved
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ai_clearPwrAtkStateFromBattleObject_801011A.yaml
	thumb_func_start ai_clearPwrAtkStateFromBattleObject_801011A
ai_clearPwrAtkStateFromBattleObject_801011A:
	push {lr}
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	add r0, #0xa0
	mov r1, #0
	strb r1, [r0,#oAIAttackVars_Unk_1d]
	strh r1, [r0,#oAIAttackVars_Unk_1e]
	bl battleObject_clearAIDataUnknown_80E1662
	pop {pc}
	thumb_func_end ai_clearPwrAtkStateFromBattleObject_801011A

	thumb_local_start
sub_801012C:
	push {r4,r7,lr}
	mov r7, #0x50 
	ldr r4, [r5,#0x54]
	bl object_getFlag // () -> int
	mov r1, #4
	tst r0, r1
	beq loc_8010152
	ldrb r0, [r5]
	mov r1, #2
	bic r0, r1
	strb r0, [r5]
	ldr r0, [r4,r7]
	tst r0, r0
	bne locret_8010160
	bl sub_80E4D8A
	str r0, [r4,r7]
	b locret_8010160
loc_8010152:
	ldr r0, [r4,r7]
	tst r0, r0
	beq locret_8010160
	bl sub_80E4DA2
	mov r0, #0
	str r0, [r4,r7]
locret_8010160:
	pop {r4,r7,pc}
	thumb_func_end sub_801012C

// symdb: Counts down a battle object's collision-data timer once per tick, plays sound 0x94 when it hits zero, and toggles the object's flag bit 4 each call.
// symdb: void sub_8010162(void); // reads battle-object pointer from r5->oBattleObject_CollisionDataPtr;
// symdb: uses r4 as the collision-data pointer for the flag helpers; clobbers r0-r2 and flags, preserves
// symdb: r3-r7 and r10
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_tickCollisionTimer_8010162.yaml
	thumb_local_start
battle_tickCollisionTimer_8010162:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	ldrh r1, [r4,#oCollisionData_Unk_26]
	ldr r2, dword_8010228 // =0xffff 
	cmp r1, r2
	beq loc_801017E
	sub r1, #1
	blt loc_8010190
	strh r1, [r4,#oCollisionData_Unk_26]
	tst r1, r1
	bne loc_801017E
	mov r0, #0x94
	bl PlaySoundEffect
loc_801017E:
	bl object_getFlag // () -> int
	ldr r1, dword_801022C // =0x400000 
	tst r0, r1
	bne loc_8010190
	mov r0, #OBJECT_FLAGS_UNK_4
	bl object_setFlag1 // (int a1) -> void
	b locret_8010196
loc_8010190:
	mov r0, #4
	bl object_clearFlag // (int bitfield) -> void
locret_8010196:
	pop {r4,pc}
	thumb_func_end battle_tickCollisionTimer_8010162

// symdb: Consumes a battle object's pending hit counter from its collision data, but only when the collision actually produced effect flags.
// symdb: void sub_8010198(battle_object *obj /* r5 */); returns r3 = obj->collisionDataPtr; clobbers r0,
// symdb: r1 and NZ flags; caller passes lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_objectClearPendingHitIfCollisionProcessed_8010198.yaml
	thumb_local_start
battle_objectClearPendingHitIfCollisionProcessed_8010198:
	push {lr}
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldrh r1, [r3,#oCollisionData_Unk_26]
	tst r1, r1
	beq locret_80101AC
	ldr r0, [r3,#oCollisionData_FlagsFromCollision]
	tst r0, r0
	beq locret_80101AC
	mov r0, #0
	strh r0, [r3,#oCollisionData_Unk_26]
locret_80101AC:
	pop {pc}
	thumb_func_end battle_objectClearPendingHitIfCollisionProcessed_8010198

	thumb_func_start sub_80101AE
sub_80101AE:
	push {lr}
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r1,#oCollisionData_Unk_26]
	mov r0, #OBJECT_FLAGS_UNK_4
	bl object_setFlag1 // (int a1) -> void
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	pop {pc}
	thumb_func_end sub_80101AE

// symdb: Resets a battle object's collision state, zeroing a collision counter and clearing its "in collision" flag bit.
// symdb: void battle_resetCollisionState(void) // r5 = battle object; returns r1/r2 from
// symdb: object_clearFlag; no flags guaranteed
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_resetCollisionState_80101C4.yaml
	thumb_func_start battle_resetCollisionState_80101C4
battle_resetCollisionState_80101C4:
	push {lr}
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	mov r0, #0
	strh r0, [r1,#oCollisionData_Unk_26]
	mov r0, #4
	bl object_clearFlag // (int bitfield) -> void
	pop {pc}
	thumb_func_end battle_resetCollisionState_80101C4

	thumb_func_start sub_80101D4
sub_80101D4:
	push {r4,lr}
	mov r4, r0
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xc
	beq loc_80101EE
	cmp r0, #0x12
	blt locret_80101F6
	cmp r0, #0x16
	ble loc_80101EE
	cmp r0, #0x18
	bne locret_80101F6
loc_80101EE:
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	strb r4, [r0,#oBattleObject_CurAnim]
	mov r1, #0xff
	strb r1, [r0,#oBattleObject_CurAnimCopy]
locret_80101F6:
	pop {r4,pc}
	thumb_func_end sub_80101D4

// symdb: Resolves the PET Navi id for battle-status purposes, returning a fallback when the Pet Navi is unset and a gate event and config flag both allow it.
// symdb: u8 sub_80101F8(void) /* r10,lr in; r0,r1,r3,r4,lr out; nz,c,v set */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getPetNaviStatus_80101F8.yaml
	thumb_func_start getPetNaviStatus_80101F8
getPetNaviStatus_80101F8:
	push {r4,lr}
	bl GetCurPETNavi // () -> u8
	mov r4, r0
	cmp r4, #0
	bne loc_8010216
	movflag EVENT_163
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_8010216
	bl notZero_eByte200AD04
	beq loc_8010216
	mov r4, #0xd
loc_8010216:
	mov r0, r4
	pop {r4,pc}
	.balign 4, 0
off_801021C:
	.word byte_20349C0
off_8010220:
	.word 0x200
off_8010224:
	.word byte_80203EA
dword_8010228:
	.word 0xFFFF
dword_801022C:
	.word 0x400000
	thumb_func_end getPetNaviStatus_80101F8

// symdb: Per-frame AI tick that drains 1 HP from a battle object at a fixed interval read from its navi-stats byte 0x18, skipping objects at/below 1 HP.
// symdb: void battle_tickAiSelfDrain_8010230(BattleObject *obj /* r5 */); // caller passes obj in r5;
// symdb: preserved r4/r6; returns carry+overflow from last flag-setting op
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_tickAiSelfDrain_8010230.yaml
	thumb_local_start
battle_tickAiSelfDrain_8010230:
	push {r4,lr}
	bl battle_isTimeStop
	bne locret_8010268
	bl battle_isPaused
	bne locret_8010268
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r5,#oBattleObject_HP]
	cmp r0, #1
	ble locret_8010268
	mov r1, #0x18
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r1, off_80102A0 // =byte_80102A4 
	ldrb r0, [r1,r0]
	tst r0, r0
	beq loc_8010264
	ldrb r3, [r4,#oAIData_Unk_09]
	add r3, #1
	strb r3, [r4,#oAIData_Unk_09]
	cmp r3, r0
	blt locret_8010268
	mov r0, #1
	bl object_subtractHP
loc_8010264:
	mov r0, #0
	strb r0, [r4,#oAIData_Unk_09]
locret_8010268:
	pop {r4,pc}
	thumb_func_end battle_tickAiSelfDrain_8010230

// symdb: Per-frame poison-tick handler for the current battle object — decrements a per-AIData poison counter and applies 1 HP once the counter hits its table-based period.
// symdb: (r5 = current battle object, r10 = toolkit) -> r0 = 0 ; side effects: subtracts 1 HP from the
// symdb: object via object_subtractHP when the poison counter elapses; clears the counter on early exit
// symdb: and on reset
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_processPoisonTick_801026A.yaml
	thumb_local_start
battleObject_processPoisonTick_801026A:
	push {r4,lr}
	bl battle_isTimeStop
	bne locret_801029E
	bl battle_isPaused
	bne locret_801029E
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r5,#oBattleObject_HP]
	cmp r0, #1
	ble locret_801029E
	ldrb r0, [r4,#oAIData_Unk_12]
	ldr r1, off_80102A0 // =byte_80102A4 
	ldrb r0, [r1,r0]
	tst r0, r0
	beq loc_801029A
	ldrb r3, [r4,#oAIData_Unk_09]
	add r3, #1
	strb r3, [r4,#oAIData_Unk_09]
	cmp r3, r0
	blt locret_801029E
	mov r0, #1
	bl object_subtractHP
loc_801029A:
	mov r0, #0
	strb r0, [r4,#oAIData_Unk_09]
locret_801029E:
	pop {r4,pc}
	.balign 4, 0
off_80102A0:
	.word byte_80102A4
byte_80102A4:
	.byte 0x0, 0x28, 0x23, 0x1E, 0x19, 0x14, 0xF, 0xA
	thumb_func_end battleObject_processPoisonTick_801026A

	thumb_func_start handleCustHPBug_80102AC
handleCustHPBug_80102AC:
	push {r4-r6,lr}
	mov r4, r0
	bl battle_GetObjectByteAt14_800A9E2
	mov r1, #5
	tst r0, r1
	beq locret_80102F0
	mov r0, r4
	mov r1, #oNaviStats_CustHPBug
	bl GetBattleNaviStatsByte
	ldr r1, off_80102F4 // =byte_80102F8 
	ldrb r6, [r1,r0]
	tst r6, r6
	beq locret_80102F0
	mov r0, r4
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r5, r0
	beq locret_80102F0
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r5,#oBattleObject_HP]
	cmp r0, #1
	ble locret_80102F0
	ldrb r3, [r4,#oAIData_Unk_0a]
	add r3, #1
	strb r3, [r4,#oAIData_Unk_0a]
	cmp r3, r6
	blt locret_80102F0
	mov r0, #1
	bl object_subtractHP
	mov r0, #0
	strb r0, [r4,#oAIData_Unk_0a]
locret_80102F0:
	pop {r4-r6,pc}
	.balign 4, 0
off_80102F4:
	.word byte_80102F8
byte_80102F8:
	.byte 0x0, 0x28, 0x1E, 0x14, 0xA, 0x5, 0x3, 0x2
	thumb_func_end handleCustHPBug_80102AC

	thumb_func_start sub_8010300
sub_8010300:
	mov r2, r10
	ldr r2, [r2,#oToolkit_BattleStatePtr]
	lsl r1, r1, #2
	add r1, #oBattleState_AliveBattleActors
	ldr r1, [r2,r1]
	ldr r1, [r1,#oBattleObject_AIDataPtr]
	ldr r1, [r1,#oAIData_Unk_48]
	and r0, r1
	mov pc, lr
	thumb_func_end sub_8010300

// symdb: Sets one or more flag bits in a battle object's AI data word at offset 0x48 (read-modify-write with OR).
// symdb: void SetAIDataUnk0x48Flag(u32 flagBits r0, BattleObject *obj r5); returns r1 = updated word, r3
// symdb: = AI data pointer; clobbers NZ flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetAIDataUnk0x48Flag.yaml
	thumb_func_start SetAIDataUnk0x48Flag
SetAIDataUnk0x48Flag:
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldr r1, [r3,#oAIData_Unk_48]
	orr r1, r0
	str r1, [r3,#oAIData_Unk_48]
	mov pc, lr
	thumb_func_end SetAIDataUnk0x48Flag

	thumb_func_start ClearAIDataUnk0x48Flag
ClearAIDataUnk0x48Flag:
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldr r1, [r3,#oAIData_Unk_48]
	bic r1, r0
	str r1, [r3,#oAIData_Unk_48]
	mov pc, lr
	thumb_func_end ClearAIDataUnk0x48Flag

	thumb_local_start
sub_8010326:
	ldr r3, [r5,#0x58]
	str r0, [r3,#0x48]
	mov pc, lr
	thumb_func_end sub_8010326

	thumb_func_start GetAIDataUnk0x48Flag
GetAIDataUnk0x48Flag:
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r3,#oAIData_Unk_48]
	mov pc, lr
	thumb_func_end GetAIDataUnk0x48Flag

// symdb: Picks a byte from a per-navi lookup table for the currently equipped cross/beast navi, returning fixed values 1 (special battle mode) or 4 (no navi) as fallbacks.
// symdb: u8 battle_getCrossNaviTableByte_8010332(void); /* in: r5, r6, r10 passed by callers but ignored
// symdb: here; r4 must be preserved; out: r0 = table byte or 1/4 sentinel; clobbers r1, lr, NZCV */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getCrossNaviTableByte_8010332.yaml
	thumb_func_start battle_getCrossNaviTableByte_8010332
battle_getCrossNaviTableByte_8010332:
	push {r4,lr}
	bl GetBattleMode
	cmp r0, #9
	bne loc_8010340
	mov r0, #1
	b locret_8010360
loc_8010340:
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_8010350
	mov r1, #4
	mov r0, r1
	pop {r4,pc}
loc_8010350:
	mov r4, #0xb
	mul r4, r0
	mov r1, #0x2b 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r1, off_8010364 // =byte_8020FE0 
	add r1, r1, r4
	ldrb r0, [r1,r0]
locret_8010360:
	pop {r4,pc}
	.balign 4, 0
off_8010364:
	.word byte_8020FE0
	thumb_func_end battle_getCrossNaviTableByte_8010332

	thumb_local_start
sub_8010368:
	push {lr}
	bl object_getFlag // () -> int
	ldr r1, off_8010384 // =byte_8010388 
	mov r2, #0x10
	tst r0, r2
	beq loc_8010378
	add r1, #0x10
loc_8010378:
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #3
	add r1, r1, r0
	ldr r2, [r1]
	ldr r3, [r1,#4]
	pop {pc}
	.balign 4, 0
off_8010384:
	.word byte_8010388
byte_8010388:
	.byte 0x10, 0x0, 0x0, 0x0, 0xA0, 0x0, 0x88, 0xF, 0x30, 0x0, 0x0, 0x0, 0x80
	.byte 0x0, 0x88, 0xF, 0x0, 0x0, 0x0, 0x0, 0xA0, 0x0, 0x88, 0xF, 0x20, 0x0
	.byte 0x0, 0x0, 0x80, 0x0, 0x88, 0xF
	thumb_func_end sub_8010368

// symdb: Reads the battle object's "alliance" stats byte (index 0x31) and normalizes it to a faction value, returning 3 when set and 0 when not.
// symdb: int battle_GetAllianceFactionFromBattleObject(void* r5_battleObject /* object also passed in r6
// symdb: and preserved */); returns r0 = 3 or 0, passes r6 through unchanged
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_GetAllianceFactionFromBattleObject_80103A8.yaml
	thumb_func_start battle_GetAllianceFactionFromBattleObject_80103A8
battle_GetAllianceFactionFromBattleObject_80103A8:
	push {lr}
	mov r1, #0x31 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0
	tst r0, r0
	beq loc_80103B8
	mov r1, #3
loc_80103B8:
	mov r0, r1
	pop {pc}
	thumb_func_end battle_GetAllianceFactionFromBattleObject_80103A8

	thumb_func_start battle_findPlayer
// r0 = alliance
battle_findPlayer: // (alliance: bool) -> * BattleObject
	push {r4-r6,lr}
	mov r6, r10
	ldr r6, [r6,#oToolkit_BattleStatePtr]
	mov r1, #0x10
	mul r0, r1
	add r0, #oBattleState_BattleActors
	add r6, r6, r0
	mov r4, #0
loc_80103CC:
	ldr r5, [r6]
	tst r5, r5
	beq loc_80103DC
	ldrh r0, [r5,#oBattleObject_NameID]
	bl unpackVerActorTyAndAIIdx_800F29C
	cmp r0, #2
	beq loc_80103E8
loc_80103DC:
	add r5, #3 // ??? useless loop, doesn't even read all entries
	add r4, #1
	cmp r4, #BATTLE_ACTORS_PER_SIDE
	blt loc_80103CC
	mov r0, #NULL
	pop {r4-r6,pc}
loc_80103E8:
	mov r0, r5
	pop {r4-r6,pc}
	thumb_func_end battle_findPlayer

// symdb: Runs the standard pre-battle-update routine (sub_800A7E2) and then returns the player's battle object pointer.
// symdb: void sub_80103EC(void); /* preserves r4-r6, r10; returns player BattleObject* in r0 with c/v
// symdb: flags from battle_findPlayer's tail */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_preUpdateAndGetPlayerObject_80103EC.yaml
	thumb_func_start battle_preUpdateAndGetPlayerObject_80103EC
battle_preUpdateAndGetPlayerObject_80103EC:
	push {lr}
	bl battle_getStateByte0d_800A7E2
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	pop {pc}
	thumb_func_end battle_preUpdateAndGetPlayerObject_80103EC

// symdb: Finds the closest enemy BattleObject to a panel (panel coords passed via stack) and returns it
// symdb: (r0 = actorIndex 0..3 [OpponentActors slot index], r5 = self BattleObject*) -> r0 = closest
// symdb: enemy BattleObject* (or NULL); side effects: stack scratch for two (X,Y) pairs
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_findClosestEnemyBattleObject_80103F8.yaml
	thumb_func_start battleObject_findClosestEnemyBattleObject_80103F8
battleObject_findClosestEnemyBattleObject_80103F8:
	push {r4-r7,lr}
	sub sp, sp, #8
	ldrb r1, [r5,#oBattleObject_PanelX]
	str r1, [sp]
	ldrb r1, [r5,#oBattleObject_PanelY]
	str r1, [sp,#4]
	mov r6, r10
	ldr r6, [r6,#oToolkit_BattleStatePtr]
	mov r1, #0x10
	mul r0, r1
	add r0, #oBattleState_BattleActors
	add r6, r6, r0
	mov r4, #4
	mov r7, #0
loc_8010414:
	ldr r5, [r6]
	tst r5, r5
	beq loc_8010454
	ldrb r0, [r5,#oBattleObject_CurState]
	cmp r0, #8
	beq loc_8010454
	ldrh r0, [r5,#oBattleObject_NameID]
	bl unpackVerActorTyAndAIIdx_800F29C
	cmp r0, #2
	beq loc_8010432
	cmp r0, #0
	beq loc_8010432
	cmp r0, #1
	bne loc_8010454
loc_8010432:
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	add r3, sp, #0
	bl sub_8010460
	cmp r7, #0
	beq loc_8010452
	push {r0}
	ldrb r0, [r7,#oBattleObject_PanelX]
	ldrb r1, [r7,#oBattleObject_PanelY]
	add r3, sp, #4
	bl sub_8010460
	pop {r1}
	cmp r0, r1
	ble loc_8010454
loc_8010452:
	mov r7, r5
loc_8010454:
	add r6, #4
	sub r4, #1
	bne loc_8010414
	mov r0, r7
	add sp, sp, #8
	pop {r4-r7,pc}
	thumb_func_end battleObject_findClosestEnemyBattleObject_80103F8

	thumb_local_start
sub_8010460:
	ldr r2, [r3]
	sub r0, r2, r0
	mov r2, r0
	mul r0, r2
	ldr r2, [r3,#4]
	sub r1, r2, r1
	mov r2, r1
	mul r1, r2
	add r0, r0, r1
	mov pc, lr
	thumb_func_end sub_8010460

	thumb_func_start sub_8010474
sub_8010474:
	push {lr}
	ldr r2, [r5,#oBattleObject_CollisionDataPtr]
	strh r4, [r2,#oCollisionData_FlashingInvisTimer]
	mov r0, #OBJECT_FLAGS_INVIS
	bl object_setFlag1 // (int a1) -> void
	mov r0, #0x93
	bl PlaySoundEffect
	pop {pc}
	thumb_func_end sub_8010474

	thumb_func_start sub_8010488
sub_8010488:
	push {r4,r7,lr}
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #oAIData_AttackVars
	ldrb r0, [r7,#oAIAttackVars_Unk_1b]
	cmp r0, #0
	beq loc_80104B6
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	ldrb r1, [r7,#oAIAttackVars_Unk_0c]
	add r1, r1, r1
	add r1, #0x36 
	ldrh r2, [r7,#oAIAttackVars_Damage]
	ldrh r3, [r7,#oAIAttackVars_Unk_0e]
	add r2, r2, r3
	ldrh r3, [r0,r1]
	add r3, r3, r2
	strh r3, [r0,r1]
	mov r0, #0x58 
	add r0, #0xff
	bl PlaySoundEffect
	pop {r4,r7,pc}
loc_80104B6:
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	mov r2, r1
	mov r1, r0
	push {r1,r2}
	bl object_getEnemyDirection
	pop {r1,r2}
	lsl r0, r0, #0x12
	add r1, r1, r0
	mov r3, #0x30 
	lsl r3, r3, #0x10
	mov r4, #0
	bl sub_80E1D7A
	mov r0, #0x90
	bl PlaySoundEffect
	pop {r4,r7,pc}
	thumb_func_end sub_8010488

	thumb_func_start sub_80104E0
sub_80104E0:
	push {r4,r7,lr}
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	mov r2, r1
	mov r1, r0
	push {r1,r2}
	bl object_getEnemyDirection
	pop {r1,r2}
	lsl r0, r0, #0x12
	add r1, r1, r0
	mov r3, #0x30 
	lsl r3, r3, #0x10
	mov r4, #0
loc_8010500:
	bl sub_80E1D7A
	mov r0, #0x90
	bl PlaySoundEffect
	pop {r4,r7,pc}
	thumb_func_end sub_80104E0

	thumb_func_start sub_801050C
sub_801050C:
	push {r4,r6,r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0xc
	mul r0, r1
	add r0, #oBattleState_Unk_a0
	mov r7, r10
	ldr r7, [r7,#oToolkit_BattleStatePtr]
	add r7, r7, r0
	mov r6, #0
loc_801051E:
	ldr r0, [r7]
	tst r0, r0
	beq loc_801053E
	ldrh r1, [r0,#0x24]
	tst r1, r1
	beq loc_801053E
	ldrh r1, [r0,#0x26]
	strh r1, [r0,#0x24]
	add r0, #0x34 
	ldmia r0!, {r1-r3}
	mov r4, #6
	bl spawn_t1_0x0_EffectObject
	mov r0, #SOUND_UNK_8A
	bl PlaySoundEffect
loc_801053E:
	add r7, #4
	add r6, #1
	cmp r6, #3
	blt loc_801051E
	pop {r4,r6,r7,pc}
	thumb_func_end sub_801050C

// symdb: Adds a damage amount to the battle object's AI TotalDamageTaken stat, clamping the running total at 0xFFFF.
// symdb: void battle_aiAddTotalDamageTaken(battleObject* obj /* r5 */, u32 damage /* r0 */); // preserves
// symdb: r4 (== r0 on entry), returns r2 = 0xFFFF
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_aiAddTotalDamageTaken_8010548.yaml
	thumb_local_start
battle_aiAddTotalDamageTaken_8010548:
	push {r4,lr}
	mov r4, r0
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrh r1, [r0,#oAIData_TotalDamageTaken]
	add r1, r1, r4
	ldr r2, dword_80108EC // =0xffff 
	cmp r1, r2
	ble loc_801055A
	mov r1, r2
loc_801055A:
	strh r1, [r0,#oAIData_TotalDamageTaken]
	pop {r4,pc}
	thumb_func_end battle_aiAddTotalDamageTaken_8010548

	thumb_func_start sub_801055E
sub_801055E:
	push {lr}
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	ldr r0, [r0,#oBattleObject_AIDataPtr]
	ldrh r0, [r0,#oAIData_TotalDamageTaken]
	pop {pc}
	thumb_func_end sub_801055E

	thumb_func_start sub_801056A
sub_801056A:
	push {r7,lr}
	sub sp, sp, #0xc
	str r0, [sp]
	str r1, [sp,#4]
	str r2, [sp,#8]
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	str r0, [r7,#oAIData_Unk_68]
	add r7, #0xa0
	ldr r0, off_80108F0 // =0x810 
	bl ClearAIDataUnk0x48Flag
	mov r0, #0x40 
	bl dispatch_801DACC // (a0: flags32) -> ()
	bl sub_800E9FA
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getTable2036720EntryFields_802CE78
	str r1, [r7,#oAIAttackVars_Damage]
	strh r2, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_14]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	ldr r0, [sp,#4]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	ldr r0, [sp,#8]
	strb r0, [r7,#oAIAttackVars_Unk_03]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	tst r0, r0
	beq loc_80105BE
	ldrh r0, [r7,#oAIAttackVars_Unk_14]
	tst r0, r0
	beq loc_80105BE
	ldrh r1, [r7,#oAIAttackVars_Damage]
	ldrh r2, [r7,#oAIAttackVars_AttackBoost]
	bl sub_801EB18
loc_80105BE:
	ldr r1, [sp]
	ldr r2, off_80108F4 // =0x200 
	tst r1, r2
	beq loc_80105D2
	mov r0, #0x47 
	bl object_setAttack0
	bl sub_80EE90C
	b loc_80105EE
loc_80105D2:
	ldr r2, off_80108F8 // =0x400 
	tst r1, r2
	beq loc_80105E4
	mov r0, #0x48 
	bl object_setAttack0
	bl sub_80EEA3C
	b loc_80105EE
loc_80105E4:
	mov r0, #0x4b 
	bl object_setAttack0
	bl sub_80EED56
loc_80105EE:
	add sp, sp, #0xc
	pop {r7,pc}
	thumb_func_end sub_801056A

	thumb_func_start sub_80105F2
sub_80105F2:
	push {r7,lr}
	sub sp, sp, #0x10
	str r0, [sp]
	str r1, [sp,#4]
	str r2, [sp,#8]
	str r3, [sp,#0xc]
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	str r0, [r7,#oAIData_Unk_68]
	add r7, #0xa0
	ldr r0, off_80108F0 // =0x810 
	bl ClearAIDataUnk0x48Flag
	mov r0, #0x40 
	bl dispatch_801DACC // (a0: flags32) -> ()
	bl sub_800E9FA
	ldr r0, [sp,#0xc]
	str r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_14]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	ldr r0, [sp,#4]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	ldr r0, [sp,#8]
	strb r0, [r7,#oAIAttackVars_Unk_03]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	tst r0, r0
	beq loc_8010646
	ldrh r0, [r7,#oAIAttackVars_Unk_14]
	tst r0, r0
	beq loc_8010646
	ldrh r1, [r7,#oAIAttackVars_Damage]
	ldrh r2, [r7,#oAIAttackVars_AttackBoost]
	bl sub_801EB18
loc_8010646:
	ldr r1, [sp]
	ldr r2, off_80108F4 // =0x200 
	tst r1, r2
	beq loc_8010656
	mov r0, #0x47 
	bl object_setAttack0
	b loc_801065C
loc_8010656:
	mov r0, #0x48 
	bl object_setAttack0
loc_801065C:
	add sp, sp, #0x10
	pop {r7,pc}
	thumb_func_end sub_80105F2

// symdb: When the battle-effects low-HP flag and navi stats low-HP bit are set and HP has dropped to 25% or less of max, clears the navi stats flag and fires a panel tile effect at the object's position.
// symdb: u32 battle_lowHPTileTrigger_8010660(u32 objPtr /*r5*/, u32 r2, u32 r3) -> r0..r3, C, V
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_lowHPTileTrigger_8010660.yaml
	thumb_func_start battle_lowHPTileTrigger_8010660
battle_lowHPTileTrigger_8010660:
	push {r4,r6,r7,lr}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_80106B8
	mov r1, #0xd
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xff
	beq loc_80106B8
	mov r2, #4
	tst r0, r2
	beq loc_80106B8
	ldrh r0, [r5,#oBattleObject_MaxHP]
	lsr r0, r0, #2
	ldrh r1, [r5,#oBattleObject_HP]
	cmp r0, r1
	bcc loc_80106B8
	mov r1, #0xd
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #4
	bic r0, r2
	mov r2, r0
	mov r1, #0xd
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	mov r2, #0
	mov r3, #0
	mov r4, #2
	mov r6, #0
	ldr r7, dword_80106BC // =0x17b 
	bl sub_80E90FE
	mov r2, r0
	mov r1, #1
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl sub_800BF16
	mov r0, #1
	pop {r4,r6,r7,pc}
loc_80106B8:
	mov r0, #0
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_80106BC:
	.word 0x17B
	thumb_func_end battle_lowHPTileTrigger_8010660

// symdb: Battle chip handler: clears the opponent Navi's stats-byte 0x0D bit 1 (an "invisible/busy" marker) when gates pass, then triggers an animation/spawn on the opponent's panel.
// symdb: u32 sub_80106C0(u32 chip_index /* r0 */, BattleObject* self_obj /* r5 */, u8 opponent_alliance
// symdb: /* r6 */, flags out nz); returns 1 on success, 0 if any gate fails
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_applyInvisibleClear_80106C0.yaml
	thumb_func_start battle_applyInvisibleClear_80106C0
battle_applyInvisibleClear_80106C0:
	push {r4,r6,r7,lr}
	mov r4, r0
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_8010738
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	mov r6, r0
	mov r1, #0xd
	bl GetBattleNaviStatsByte
	cmp r0, #0xff
	beq loc_8010738
	mov r2, #2
	tst r0, r2
	beq loc_8010738
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#7]
	cmp r1, #1
	beq loc_80106F6
	cmp r1, #2
	bne loc_8010738
loc_80106F6:
	mov r0, r6
	mov r1, #0xd
	bl GetBattleNaviStatsByte
	mov r2, #2
	bic r0, r2
	mov r2, r0
	mov r1, #0xd
	mov r0, r6
	bl SetBattleNaviStatsByte
	mov r0, r6
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	push {r5}
	mov r5, r0
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	mov r2, #0
	mov r3, #0
	mov r4, #1
	mov r6, #0
	ldr r7, dword_801073C // =0x17a 
	bl sub_80E90FE
	mov r2, r0
	mov r1, #1
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl sub_800BF16
	pop {r5}
	mov r0, #1
	pop {r4,r6,r7,pc}
loc_8010738:
	mov r0, #0
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_801073C:
	.word 0x17A
	thumb_func_end battle_applyInvisibleClear_80106C0

// symdb: Attempts to steal a chip from the enemy Navi by clearing their anti-steal flag and spawning a steal effect at their panel; returns whether the steal was performed.
// symdb: (r0 = chipID, r5 = actor BattleObject / caller context, r10 = toolkit) -> r0 = 1 on success, 0
// symdb: if any guard failed
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_stealChipFromEnemyNavi_8010740.yaml
	thumb_func_start battleObject_stealChipFromEnemyNavi_8010740
battleObject_stealChipFromEnemyNavi_8010740:
	push {r4,r6,r7,lr}
	mov r4, r0
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_80107B6
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	mov r6, r0
	mov r1, #0xd
	bl GetBattleNaviStatsByte
	cmp r0, #0xff
	beq loc_80107B6
	mov r2, #1
	tst r0, r2
	beq loc_80107B6
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#0x16]
	mov r2, #2
	tst r1, r2
	beq loc_80107B6
	mov r0, r6
	mov r1, #0xd
	bl GetBattleNaviStatsByte
	mov r2, #1
	bic r0, r2
	mov r2, r0
	mov r1, #0xd
	mov r0, r6
	bl SetBattleNaviStatsByte
	mov r0, r6
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	push {r5}
	mov r5, r0
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	mov r2, #0
	mov r3, #0
	lsl r4, r4, #0x10
	mov r6, #0
	ldr r7, off_80107BC // =0x179 
	bl sub_80E90FE
	mov r2, r0
	mov r1, #1
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl sub_800BF16
	pop {r5}
	mov r0, #1
	pop {r4,r6,r7,pc}
loc_80107B6:
	mov r0, #0
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_80107BC:
	.word 0x179
	thumb_func_end battleObject_stealChipFromEnemyNavi_8010740

// symdb: Tests the battle-effects bitmask's bit 3 and returns 3 when that flag is set (Custom+ disabled), otherwise 0.
// symdb: int battle_IsNoCustomPlusActive(void) // r10 in (ignored by body), r3 out = 3 if effect bit set
// symdb: else 0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_IsNoCustomPlusActive_80107C0.yaml
	thumb_func_start battle_IsNoCustomPlusActive_80107C0
battle_IsNoCustomPlusActive_80107C0:
	push {lr}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne loc_80107D0
	mov r3, #0
	pop {pc}
loc_80107D0:
	mov r3, #3
	pop {pc}
	thumb_func_end battle_IsNoCustomPlusActive_80107C0

// symdb: Per-frame housekeeping for a battle object: tick down AI timers (chip lockout, unk 0x15) and alliance entry counters at offsets 0x2E, 0x3A and 0x3C, except when battle time is stopped.
// symdb: void battle_tickBattleObject_80107D4(void); // in: r5 = battle object pointer, r10 = ?, r4 =
// symdb: preserved by callee across the call; out: r4 unchanged
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_tickBattleObject_80107D4.yaml
	thumb_func_start battle_tickBattleObject_80107D4
battle_tickBattleObject_80107D4:
	push {r4,lr}
	bl battle_isTimeStop
	bne locret_801081E
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r4,#oAIData_ChipLockoutTimer]
	tst r0, r0
	beq loc_80107E8
	sub r0, #1
	strb r0, [r4,#oAIData_ChipLockoutTimer]
loc_80107E8:
	ldrb r0, [r4,#oAIData_Unk_15]
	tst r0, r0
	beq loc_80107F2
	sub r0, #1
	strb r0, [r4,#oAIData_Unk_15]
loc_80107F2:
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	mov r4, r0
	ldrb r0, [r4]
	tst r0, r0
	beq locret_801081E
	ldrh r1, [r4,#0x2e]
	tst r1, r1
	beq loc_801080A
	sub r1, #1
	strh r1, [r4,#0x2e]
loc_801080A:
	ldrh r1, [r4,#0x3a]
	tst r1, r1
	beq loc_8010814
	sub r1, #1
	strh r1, [r4,#0x3a]
loc_8010814:
	ldrh r1, [r4,#0x3c]
	tst r1, r1
	beq locret_801081E
	sub r1, #1
	strh r1, [r4,#0x3c]
locret_801081E:
	pop {r4,pc}
	thumb_func_end battle_tickBattleObject_80107D4

	thumb_func_start sub_8010820
sub_8010820:
	push {r4,lr}
	mov r0, #0xff
	and r4, r0
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	bl GetBattleNaviStatsByte
	add r2, r0, r4
	cmp r2, #0xa
	blt loc_8010836
	mov r2, #9
loc_8010836:
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	bl SetBattleNaviStatsByte
loc_801083E:
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	push {r1-r3}
	ldrh r0, [r5,#oBattleObject_NameID]
	mov r1, #0x20 
	ldrb r2, [r5,#oBattleObject_Alliance]
	ldrb r3, [r5,#oBattleObject_DirectionFlip]
	bl getBattleArmPositionMaybe_8018810
	lsl r0, r0, #0x10
	lsl r4, r1, #0x10
	pop {r1-r3}
	add r1, r1, r0
	add r3, r3, r4
	mov r4, #0x31 
	bl spawn_t1_0x0_EffectObject
	mov r0, #0x1a
	add r0, #0xff
	bl PlaySoundEffect
	pop {r4,pc}
	thumb_func_end sub_8010820

// symdb: Sets the battle object's secondary-element weakness using stat look-ups of the actor's and its foe NaviStats.
// symdb: () -> void ; side effects: writes SecondaryElementWeakness and SecondaryElement on the actor's
// symdb: CollisionData (r5->r0 via battle object lookup)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_setupSecondaryElementWeaknessFromNaviStats_801086C.yaml
	thumb_func_start battleObject_setupSecondaryElementWeaknessFromNaviStats_801086C
battleObject_setupSecondaryElementWeaknessFromNaviStats_801086C:
	push {r4,lr}
	ldr r4, off_80108B0 // =byte_80108B8 
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_8010890
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_8010888
	ldrb r0, [r4,r0]
	b loc_8010892
loc_8010888:
	mov r1, #0x10
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	b loc_8010892
loc_8010890:
	ldrb r0, [r4,r0]
loc_8010892:
	bl battleObject_setElement_8019F8C
	ldr r4, off_80108B4 // =byte_80108D1 
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_80108A8
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
loc_80108A8:
	ldrb r0, [r4,r0]
	bl battleObject_SetSecondaryElementWeakness_8019F9E
	pop {r4,pc}
	.balign 4, 0
off_80108B0:
	.word byte_80108B8
off_80108B4:
	.word byte_80108D1
byte_80108B8:
	.byte 0x0, 0x1, 0x3, 0x0, 0x0, 0x1, 0x2, 0x4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x3, 0x0, 0x0
	.byte 0x1, 0x2, 0x4, 0x0, 0x0, 0x0, 0x0, 0x0
byte_80108D1:
	.byte 0x0, 0x0, 0x0, 0x10, 0x20, 0x0, 0x0, 0x0, 0x80, 0x40, 0x40, 0x0
	.byte 0x0, 0x0, 0x0, 0x10, 0x20, 0x0, 0x0, 0x0, 0x80, 0x40, 0x40, 0x0
	.byte 0x0, 0x0, 0x0
dword_80108EC:
	.word 0xFFFF
off_80108F0:
	.word 0x810
off_80108F4:
	.word 0x200
off_80108F8:
	.word 0x400
	thumb_func_end battleObject_setupSecondaryElementWeaknessFromNaviStats_801086C

	thumb_func_start sub_80108FC
sub_80108FC:
	push {r4,r6,r7,lr}
	bl getBattleHandAddr_8010018
	b loc_8010906
	push {r4,r6,r7,lr}
loc_8010906:
	mov r7, r0
	ldrb r4, [r7]
loc_801090A:
	add r0, r4, r4
	add r0, #2
	ldrh r1, [r7,r0]
	ldr r2, dword_801099C // =0xffff 
	cmp r1, r2
	beq locret_801092A
	ldr r2, off_80109A0 // =0x190 
	sub r1, r1, r2
	cmp r1, #0xa
	bhi loc_8010926
	mov r0, r4
	bl sub_801092C
	b loc_801090A
loc_8010926:
	add r4, #1
	b loc_801090A
locret_801092A:
	pop {r4,r6,r7,pc}
	thumb_func_end sub_80108FC

	thumb_local_start
sub_801092C:
	push {lr}
loc_801092E:
	add r1, r0, #1
	push {r0,r1}
	bl sub_8010940
	pop {r0,r1}
	add r0, #1
	cmp r0, #5
	blt loc_801092E
	pop {pc}
	thumb_func_end sub_801092C

	thumb_local_start
sub_8010940:
	push {r4-r6,lr}
	add r4, r0, r0
	add r5, r1, r1
	mov r2, #2
	add r2, r2, r4
	mov r3, #2
	add r3, r3, r5
	ldrh r6, [r7,r3]
	strh r6, [r7,r2]
	mov r2, #0xe
	add r2, r2, r4
	mov r3, #0xe
	add r3, r3, r5
	ldrh r6, [r7,r3]
	strh r6, [r7,r2]
	mov r2, #0x1a
	add r2, r2, r4
	mov r3, #0x1a
	add r3, r3, r5
	ldrh r6, [r7,r3]
	strh r6, [r7,r2]
	mov r2, #0x26 
	add r2, r2, r4
	mov r3, #0x26 
	add r3, r3, r5
	ldrh r6, [r7,r3]
	strh r6, [r7,r2]
	mov r2, #0x32 
	add r2, r2, r4
	mov r3, #0x32 
	add r3, r3, r5
	ldrh r6, [r7,r3]
	strh r6, [r7,r2]
	mov r2, #0x3e 
	add r2, r2, r0
	mov r3, #0x3e 
	add r3, r3, r1
	ldrb r6, [r7,r3]
	strb r6, [r7,r2]
	mov r2, #0x44 
	add r2, r2, r0
	mov r3, #0x44 
	add r3, r3, r1
	ldrb r6, [r7,r3]
	strb r6, [r7,r2]
	pop {r4-r6,pc}
dword_801099C:
	.word 0xFFFF
off_80109A0:
	.word 0x190
	thumb_func_end sub_8010940

// symdb: Dispatches a battle chip's "use" handler from the static chip data, then jumps into it with (r0=chipID, r1=targetStruct).
// symdb: (r0 = chipID, r1 = user data pointer) -> r0 = return value from the dispatched handler ; side
// symdb: effects: jumps through a handler table indexed by ChipData[chipID].Unk_1a (offset 0x1a in the
// symdb: 44-byte chip record), threads into the per-chip effect routine.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_chipEffectDispatcher_80109A4.yaml
	thumb_func_start battle_chipEffectDispatcher_80109A4
battle_chipEffectDispatcher_80109A4:
	push {r4,r7,lr}
	mov r7, r0
	mov r4, r1
	ldr r2, dword_80109D8 // =0xffff 
	cmp r0, r2
	beq loc_80109D0
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrh r0, [r0,#0x1a]
	mov r2, #0xfa
	lsl r2, r2, #2
	cmp r0, r2
	blt locret_80109D2
	sub r0, r0, r2
	lsl r0, r0, #2
	ldr r2, off_80109D4 // =off_80109DC 
	ldr r2, [r0,r2]
	mov r0, r7
	mov r1, r4
	mov lr, pc
	bx r2
	pop {r4,r7,pc}
loc_80109D0:
	mov r0, #0
locret_80109D2:
	pop {r4,r7,pc}
	.balign 4, 0
off_80109D4:
	.word off_80109DC
dword_80109D8:
	.word 0xFFFF
off_80109DC:
	.word sub_8010A90+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010AE4+1
	.word sub_8010B78+1
	.word sub_8010BD0+1
	.word sub_8010BF0+1
	.word sub_8010C06+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	.word battle_chargePwrAtk_8010C50+1
	thumb_func_end battle_chipEffectDispatcher_80109A4

	thumb_local_start
sub_8010A90:
	push {r4,lr}
	mov r4, r1
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne loc_8010ACE
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	add r0, #oBattleState_AliveOpponentActors
	neg r1, r4
	add r1, r1, r1
	add r1, #3
	mov r3, #0
loc_8010AAC:
	ldr r2, [r0]
	tst r2, r2
	beq loc_8010ABA
	ldrh r2, [r2,#oBattleObject_HP]
	cmp r2, r3
	blt loc_8010ABA
	mov r3, r2
loc_8010ABA:
	add r0, #4
	sub r1, #1
	bgt loc_8010AAC
	mov r2, #0xfa
	add r2, r2, r2
	cmp r3, r2
	ble loc_8010ACA
	mov r3, r2
loc_8010ACA:
	mov r0, r3
	pop {r4,pc}
loc_8010ACE:
	mov r0, #1
	eor r0, r4
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	ldrh r0, [r0,#oBattleObject_HP]
	mov r1, #0xfa
	add r1, r1, r1
	cmp r0, r1
	ble locret_8010AE2
	mov r0, r1
locret_8010AE2:
	pop {r4,pc}
	thumb_func_end sub_8010A90

	thumb_local_start
sub_8010AE4:
	push {r4,lr}
	mov r4, r1
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrh r1, [r0,#0x1a]
	ldr r2, off_8010D28 // =0x3e9 
	sub r1, r1, r2
	mov r2, #0x28 
	mul r2, r4
	ldr r3, off_8010D2C // =byte_203EB00 
	add r3, r3, r2
	add r2, r1, r1
	ldrh r0, [r3,r2]
	mov r4, r1
	bl memory_bcd_8000D84
	mov r1, #0
	ldr r2, off_8010B24 // =byte_8010B2C 
loc_8010B08:
	ldr r3, [r2]
	cmp r0, r3
	ble loc_8010B16
	add r2, #4
	add r1, #1
	cmp r1, #0xa
	blt loc_8010B08
loc_8010B16:
	mov r0, #0x16
	mul r0, r4
	add r1, r1, r1
	ldr r2, off_8010D30 // =byte_8020E54
	add r2, r2, r1
	ldrh r0, [r2,r0]
	pop {r4,pc}
	.balign 4, 0
off_8010B24:
	.word byte_8010B2C
	.word byte_8010B54
byte_8010B2C:
	.byte 0x0, 0x10, 0x0, 0x0, 0x0, 0x12, 0x0, 0x0, 0x0, 0x14, 0x0, 0x0, 0x0, 0x16
	.byte 0x0, 0x0, 0x0, 0x18, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0, 0x0, 0x22, 0x0, 0x0
	.byte 0x0, 0x24, 0x0, 0x0, 0x0, 0x26, 0x0, 0x0, 0x0, 0x28, 0x0, 0x0
byte_8010B54:
	.byte 0xD2, 0x0, 0xD2, 0x0, 0x64, 0x0, 0xD2, 0x0, 0x64, 0x0, 0x5F
	.byte 0x0, 0xE6, 0x0, 0xAF, 0x0, 0x69, 0x0, 0x64, 0x0, 0xDC, 0x0
	.byte 0xB4, 0x0, 0xD2, 0x0, 0x20, 0x0, 0xA5, 0x0, 0x64, 0x0, 0x28
	.byte 0x0, 0x64, 0x0
	thumb_func_end sub_8010AE4

	thumb_local_start
sub_8010B78:
	push {lr}
	push {r0,r1}
	bl battle_testFlag0x40_800A8F8
	pop {r0,r1}
	beq loc_8010B92
	mov r0, r1
	bl getEntryPtr_2036120_1D0_802E070
	ldrh r0, [r0,#0x28]
	ldr r1, off_8010D34 // =0x1500 
	add r0, r0, r1
	b loc_8010B96
loc_8010B92:
	bl battle_getTotalDamageTakenForActor_801DFE4
loc_8010B96:
	mov r1, r0
	mov r0, #0xa
	lsr r1, r1, #7
	cmp r1, #0x80
	bge locret_8010BCE
	cmp r1, #0x40 
	bgt loc_8010BB0
	mov r0, #0x16
	mul r0, r1
	mov r1, #0x40 
	svc 6
	add r0, #0xa
	b locret_8010BCE
loc_8010BB0:
	cmp r1, #0x70 
	bgt loc_8010BC2
	sub r1, #0x40 
	mov r0, #0x60 
	mul r0, r1
	mov r1, #0x30 
	svc 6
	add r0, #0x20 
	b locret_8010BCE
loc_8010BC2:
	sub r1, #0x70 
	mov r0, #0x80
	mul r0, r1
	mov r1, #0xf
	svc 6
	add r0, #0x80
locret_8010BCE:
	pop {pc}
	thumb_func_end sub_8010B78

	thumb_local_start
sub_8010BD0:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, r1
	mov r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	tst r0, r0
	beq locret_8010BEE
	ldrh r1, [r0,#oBattleObject_HP]
	ldrh r0, [r0,#oBattleObject_MaxHP]
	sub r0, r0, r1
	ldr r1, off_8010D38 // =0x1f4 
	cmp r0, r1
	ble locret_8010BEE
	mov r0, r1
locret_8010BEE:
	pop {r6,r7,pc}
	thumb_func_end sub_8010BD0

	thumb_local_start
sub_8010BF0:
	push {lr}
	mov r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	tst r0, r0
	beq locret_8010C04
	ldrh r0, [r0,#oBattleObject_HP]
	mov r1, #0x64 
	svc 6
	mov r0, r1
locret_8010C04:
	pop {pc}
	thumb_func_end sub_8010BF0

	thumb_local_start
sub_8010C06:
	push {r4,lr}
	mov r4, r1
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne loc_8010C36
	mov r0, #0
	mov r1, #0
	mov r2, r10
	ldr r2, [r2,#oToolkit_BattleStatePtr]
	add r2, #oBattleState_AliveOpponentActors
loc_8010C1E:
	ldr r3, [r2]
	tst r3, r3
	beq loc_8010C2C
	ldrh r3, [r3,#oBattleObject_MaxHP]
	cmp r3, r0
	blt loc_8010C2C
	mov r0, r3
loc_8010C2C:
	add r2, #4
	add r1, #1
	cmp r1, #3
	blt loc_8010C1E
	b loc_8010C44
loc_8010C36:
	mov r0, #1
	eor r0, r4
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	tst r0, r0
	beq locret_8010C4E
	ldrh r0, [r0,#oBattleObject_MaxHP]
loc_8010C44:
	lsr r0, r0, #1
	ldr r1, dword_8010D3C // =0x3e7 
	cmp r0, r1
	ble locret_8010C4E
	mov r0, r1
locret_8010C4E:
	pop {r4,pc}
	thumb_func_end sub_8010C06

// symdb: Charge the player's PowerAttack timer for a chip based on a chip ID and battle alliance.
// symdb: (r0 = chip_id, r1 = alliance_bool) -> r0 = power-atk charge time in frames (0x1e) ; side
// symdb: effects: may write player BattleObject
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_chargePwrAtk_8010C50.yaml
	thumb_local_start
battle_chargePwrAtk_8010C50:
	push {r4-r6,lr}
	mov r4, r0
	mov r6, r1
	mov r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r5, r0
	tst r5, r5
	beq locret_8010C74
	// idx
	mov r0, r4
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrh r0, [r0,#0x1a]
	ldr r1, dword_8010D40 // =0x3ff 
	sub r0, r0, r1
	mov r1, r6
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
locret_8010C74:
	pop {r4-r6,pc}
	thumb_func_end battle_chargePwrAtk_8010C50

	thumb_func_start sub_8010C76
sub_8010C76:
	push {r4,lr}
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrh r1, [r0,#0x1a]
	ldr r2, off_8010D28 // =0x3e9 
	cmp r1, r2
	blt loc_8010CB0
	sub r1, r1, r2
	ldr r3, off_8010D44 // =unk_20018C0 
	add r4, r1, r1
	ldrh r0, [r3,r4]
	bl memory_bcd_8000D84
	mov r1, #0
	ldr r2, off_8010CB4 // =byte_8010CB8
loc_8010C94:
	ldr r3, [r2]
	cmp r0, r3
	ble loc_8010CA2
	add r2, #4
	add r1, #1
	cmp r1, #0xa
	blt loc_8010C94
loc_8010CA2:
	mov r0, #0xb
	mul r0, r4
	add r1, r1, r1
	ldr r2, off_8010D48 // =byte_8020E54
	add r2, r2, r1
	ldrh r0, [r2,r0]
	pop {r4,pc}
loc_8010CB0:
	mov r0, r1
	pop {r4,pc}
	.balign 4, 0
off_8010CB4:
	.word byte_8010CB8
byte_8010CB8:
	.byte 0x0, 0x10, 0x0, 0x0, 0x0, 0x12, 0x0, 0x0, 0x0, 0x14, 0x0, 0x0, 0x0, 0x16
	.byte 0x0, 0x0, 0x0, 0x18, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0, 0x0, 0x22, 0x0, 0x0
	.byte 0x0, 0x24, 0x0, 0x0, 0x0, 0x26, 0x0, 0x0, 0x0, 0x28, 0x0, 0x0
	thumb_func_end sub_8010C76

	thumb_func_start sub_8010CE0
sub_8010CE0:
	push {r4,lr}
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrh r1, [r0,#0x1a]
	ldr r2, off_8010D28 // =0x3e9 
	cmp r1, r2
	blt loc_8010D00
	sub r1, r1, r2
	add r4, r1, r1
	mov r0, #0xb
	mul r0, r4
	mov r1, #0xa
	ldr r2, off_8010D4C // =byte_8020E54
	add r2, r2, r1
	ldrh r0, [r2,r0]
	pop {r4,pc}
loc_8010D00:
	mov r0, r1
	pop {r4,pc}
	thumb_func_end sub_8010CE0

// symdb: Looks up a 2-byte beast power-Atk base entry at byte_80212D4 + 2*idx and forwards (idx, two table bytes) to sub_8012642.
// symdb: (r0 = beast-power-Atk table index) -> r0 = ... (forwarded from callee, captured as 0x1e) ; no
// symdb: side effects in this frame
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_beastPwrAtk_addScaledBaseFromIndex_8010D04.yaml
	thumb_local_start
battle_beastPwrAtk_addScaledBaseFromIndex_8010D04:
	push {lr}
	mov r2, #2
	mul r0, r2
	ldr r2, off_8010D50 // =byte_80212D4
	add r2, r2, r0
	ldrb r0, [r2]
	ldrb r1, [r2,#1]
	bl battle_beastPwrAtk_addScaledBase_8012642
	pop {pc}
	thumb_func_end battle_beastPwrAtk_addScaledBaseFromIndex_8010D04

	thumb_local_start
sub_8010D18:
	lsl r0, r0, #2
	ldr r1, off_8010D54 // =dword_203CDF0 
	ldr r0, [r1,r0]
	mov pc, lr
	thumb_func_end sub_8010D18

// symdb: Trivial stub that always returns 0 (false); no game logic, likely a disabled/removed hook.
// symdb: int stub_alwaysReturnsFalse_8010D20(void) /* in: lr only (r4 saved/restored); out: r0 = 0 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/stub_alwaysReturnsFalse_8010D20.yaml
	thumb_func_start stub_alwaysReturnsFalse_8010D20
stub_alwaysReturnsFalse_8010D20:
	push {r4,lr}
	mov r4, #0
	mov r0, r4
	pop {r4,pc}
off_8010D28:
	.word 0x3E9
off_8010D2C:
	.word byte_203EB00
off_8010D30:
	.word byte_8020E54
off_8010D34:
	.word 0x1500
off_8010D38:
	.word 0x1F4
dword_8010D3C:
	.word 0x3E7
dword_8010D40:
	.word 0x3FF
off_8010D44:
	.word unk_20018C0
off_8010D48:
	.word byte_8020E54
off_8010D4C:
	.word byte_8020E54
off_8010D50:
	.word byte_80212D4
off_8010D54:
	.word dword_203CDF0
	thumb_func_end stub_alwaysReturnsFalse_8010D20

// symdb: Dispatcher over a 5-entry handler table (ids 0-4); an id of 0xFF, or one flagged by the validator, is rejected and returns 0xFFFF instead of running a handler.
// symdb: int dispatchHandlerById(int id /*r0*/, ... /*r2, r3 passed through to handler*/); returns
// symdb: handler's r0/r1 with r4 = 0, or 0xFFFF on rejection; r6 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/dispatchHandlerById_8010D58.yaml
	thumb_local_start
dispatchHandlerById_8010D58:
	push {r6,lr}
	lsl r6, r0, #2
	cmp r0, #0xff
	beq loc_8010D7C
	bl sub_800F4A8
	cmp r0, #1
	blt loc_8010D70
	mov r0, #1
	bl sub_800F4B2
	b loc_8010D7C
loc_8010D70:
	ldr r1, off_8010D80 // =off_8010D84 
	ldr r0, [r1,r6]
	mov lr, pc
	bx r0
	mov r4, #0
	b locret_8010D7E
loc_8010D7C:
	ldr r0, dword_8010DCC // =0xffff 
locret_8010D7E:
	pop {r6,pc}
	.balign 4, 0
off_8010D80:
	.word off_8010D84
off_8010D84:
	.word sub_8010D98+1
	.word sub_8010DA2+1
	.word sub_8010DAC+1
	.word sub_8010DB6+1
	.word sub_8010DC0+1
	thumb_func_end dispatchHandlerById_8010D58

	thumb_local_start
sub_8010D98:
	push {lr}
	mov r0, #0x47 
	bl sub_800EF02
	pop {pc}
	thumb_func_end sub_8010D98

	thumb_local_start
sub_8010DA2:
	push {lr}
	mov r0, #0x1e
	bl sub_800EF02
	pop {pc}
	thumb_func_end sub_8010DA2

	thumb_local_start
sub_8010DAC:
	push {lr}
	mov r0, #0x9a
	bl sub_800EF02
	pop {pc}
	thumb_func_end sub_8010DAC

	thumb_local_start
sub_8010DB6:
	push {lr}
	mov r0, #0xb1
	bl sub_800EF02
	pop {pc}
	thumb_func_end sub_8010DB6

	thumb_local_start
sub_8010DC0:
	push {lr}
	mov r0, #0xc0
	bl sub_800EF02
	pop {pc}
	.balign 4, 0
dword_8010DCC:
	.word 0xFFFF
	thumb_func_end sub_8010DC0

// symdb: Tiny trampoline that reads a battle object's name ID and tail-calls the name-popup handler with it.
// symdb: void sub_8010DD0(battle object in r5); returns whatever sub_8010DDA returns in r0 (r1 scratch),
// symdb: flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_objectNameIdToPopupHandler_8010DD0.yaml
	thumb_func_start battle_objectNameIdToPopupHandler_8010DD0
battle_objectNameIdToPopupHandler_8010DD0:
	push {lr}
	ldrh r0, [r5,#oBattleObject_NameID]
	bl battle_DispatchEnemyAiRoutine_8010DDA
	pop {pc}
	thumb_func_end battle_objectNameIdToPopupHandler_8010DD0

// symdb: Battle AI dispatcher — looks up an enemy's AI routine by actor type and AI index and tail-calls it.
// symdb: battle_DispatchEnemyAiRoutine(u16 enemy_idx /* r0 */); mostly pass-through: r3-r12 are forwarded
// symdb: untouched, r0-r2 and flags carry the AI routine's entry state (r0 = routine address, r1 =
// symdb: actor_type*4, r2 = 0, Z=1/N=0/C=0); LR set to 0x8010DF4 for the AI routine, which returns
// symdb: through "pop {pc}" to this function's caller
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_DispatchEnemyAiRoutine_8010DDA.yaml
	thumb_local_start
battle_DispatchEnemyAiRoutine_8010DDA:
	push {lr}
	bl GetVerActorTyAndAIIdx_80182B4 // (enemy_idx: u16) -> *const (version: u8, actor_type: ActorType, ai_index: u8)
	ldrb r1, [r0,#1]
	lsl r1, r1, #2
	ldrb r2, [r0,#2]
	lsl r2, r2, #2
	ldr r0, off_8010E08 // =off_8010E0C 
	ldr r0, [r0,r1]
	ldr r0, [r0,r2]
	mov r2, #0
	mov lr, pc
	bx r0
	pop {pc}
	thumb_func_end battle_DispatchEnemyAiRoutine_8010DDA

	thumb_func_start sub_8010DF6
sub_8010DF6:
	push {lr}
	lsl r0, r0, #2
	lsl r1, r1, #2
	ldr r3, off_8010E08 // =off_8010E0C 
	ldr r3, [r3,r0]
	ldr r3, [r3,r1]
	mov lr, pc
	bx r3
	pop {pc}
off_8010E08:
	.word off_8010E0C
off_8010E0C:
	.word off_8010E18
	.word off_8010EA4
	.word off_8010EA4
off_8010E18:
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
off_8010EA4:
	.word nullsub_42+1
	.word sub_8010F6A+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_8010F7A+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_8010F86+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_8010F96+1
	.word sub_8010FD8+1
	.word nullsub_43+1
	.word sub_8011004+1
	.word nullsub_43+1
	.word sub_8010FAC+1
	.word sub_8010FC2+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_8011366+1
off_8010F08:
	.word sub_80112E0+1
	.word sub_80112EA+1
	.word sub_80112F4+1
	.word sub_80112FE+1
	.word sub_8011308+1
	.word sub_8011312+1
	.word sub_8011330+1
	.word sub_801131C+1
	.word sub_8011326+1
	.word sub_801133A+1
	.word nullsub_43+1
	.word sub_8011366+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_8011352+1
	.word sub_8011356+1
	.word sub_801135A+1
	.word sub_801135E+1
	.word sub_8011362+1
	.word nullsub_43+1
	.word sub_8011366+1
	thumb_func_end sub_8010DF6

// symdb: Empty stub that does nothing and returns immediately.
// symdb: void nullsub_42(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_42.yaml
	thumb_local_start
nullsub_42:
	mov pc, lr
	thumb_func_end nullsub_42

	thumb_local_start
sub_8010F6A:
	push {r4,lr}
	mov r4, #2
	lsl r2, r2, #0x10
	add r4, r4, r2
	bl battle_spawnObject56LinkedToOwner_80C44A8
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	pop {r4,pc}
	thumb_func_end sub_8010F6A

	thumb_local_start
sub_8010F7A:
	push {r4,lr}
	mov r4, #0
	bl sub_80C41D8
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	pop {r4,pc}
	thumb_func_end sub_8010F7A

	thumb_local_start
sub_8010F86:
	push {r4,lr}
	mov r4, #0xb
	lsl r2, r2, #0x10
	add r4, r4, r2
	bl battle_spawnObject56LinkedToOwner_80C44A8
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	pop {r4,pc}
	thumb_func_end sub_8010F86

	thumb_local_start
sub_8010F96:
	push {r4,lr}
	mov r4, #3
	lsl r2, r2, #0x10
	add r4, r4, r2
	mov r2, #0xa
	lsl r2, r2, #0x18
	add r4, r4, r2
	bl battle_spawnObject56LinkedToOwner_80C44A8
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	pop {r4,pc}
	thumb_func_end sub_8010F96

	thumb_local_start
sub_8010FAC:
	push {r4,lr}
	mov r4, #0
	lsl r2, r2, #0x10
	add r4, r4, r2
	mov r2, #0xd
	lsl r2, r2, #0x18
	add r4, r4, r2
	bl battle_spawnObject56LinkedToOwner_80C44A8
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	pop {r4,pc}
	thumb_func_end sub_8010FAC

	thumb_local_start
sub_8010FC2:
	push {r4,lr}
	mov r4, #0x10
	lsl r2, r2, #0x10
	add r4, r4, r2
	mov r2, #0x14
	lsl r2, r2, #0x18
	add r4, r4, r2
	bl battle_spawnObject56LinkedToOwner_80C44A8
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	pop {r4,pc}
	thumb_func_end sub_8010FC2

	thumb_local_start
sub_8010FD8:
	push {r4,lr}
	push {r2}
	mov r4, #6
	lsl r2, r2, #0x10
	add r4, r4, r2
	mov r2, #0x14
	lsl r2, r2, #0x18
	add r4, r4, r2
	bl battle_spawnObject56LinkedToOwner_80C44A8
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	pop {r2}
	mov r4, #7
	lsl r2, r2, #0x10
	add r4, r4, r2
	mov r2, #0x28 
	lsl r2, r2, #0x18
	add r4, r4, r2
	bl battle_spawnObject56LinkedToOwner_80C44A8
	str r0, [r5,#oBattleObject_ExtraVars]
	pop {r4,pc}
	thumb_func_end sub_8010FD8

	thumb_local_start
sub_8011004:
	push {r4,lr}
	mov r4, #0xf
	lsl r2, r2, #0x10
	add r4, r4, r2
	mov r2, #1
	lsl r2, r2, #8
	add r4, r4, r2
	mov r2, #9
	lsl r2, r2, #0x18
	add r4, r4, r2
	bl battle_spawnObject56LinkedToOwner_80C44A8
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	pop {r4,pc}
	thumb_func_end sub_8011004

// symdb: Tiny helper that reads the NameID field of a battle object (passed in r5) and tail-calls sub_801102A with it.
// symdb: void sub_8011020(void) — takes the battle object pointer implicitly in r5; returns whatever
// symdb: sub_801102A returns in r0 (not forwarded here; it branches via pop {pc} after the call returns)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getObjectNameID_8011020.yaml
	thumb_func_start battle_getObjectNameID_8011020
battle_getObjectNameID_8011020:
	push {lr}
	ldrh r0, [r5,#oBattleObject_NameID]
	bl battle_callActorActionHandler_801102A
	pop {pc}
	thumb_func_end battle_getObjectNameID_8011020

// symdb: Dispatches an actor's action handler by (ActorType, AIIndex) via a 2D jump table.
// symdb: (r0 = actorNameID: u8) -> r0 = handlerRoutinePtr: u32 (moved to lr and jumped to)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_callActorActionHandler_801102A.yaml
	thumb_local_start
battle_callActorActionHandler_801102A:
	push {lr}
	bl GetVerActorTyAndAIIdx_80182B4 // (enemy_idx: u16) -> *const (version: u8, actor_type: ActorType, ai_index: u8)
	ldrb r1, [r0,#1]
	lsl r1, r1, #2
	ldrb r2, [r0,#2]
	lsl r2, r2, #2
	ldr r0, off_8011058 // =off_801105C 
	ldr r0, [r0,r1]
	ldr r0, [r0,r2]
	mov lr, pc
	bx r0
	pop {pc}
	thumb_func_end battle_callActorActionHandler_801102A

	thumb_func_start sub_8011044
sub_8011044:
	push {lr}
	lsl r0, r0, #2
	lsl r1, r1, #2
	ldr r2, off_8011058 // =off_801105C 
	ldr r2, [r2,r0]
	ldr r2, [r2,r1]
	mov lr, pc
	bx r2
	pop {pc}
	.balign 4, 0x00
off_8011058:
	.word off_801105C
off_801105C:
	.word off_8011068
	.word off_80110F4
	.word off_80110F4
off_8011068:
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
off_80110F4:
	.word battle_object_detachRelatedObject2_80111B8+1
	.word sub_80111CA+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_80111DC+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_80111EE+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_8011200+1
	.word sub_8011236+1
	.word nullsub_43+1
	.word sub_8011256+1
	.word nullsub_43+1
	.word sub_8011212+1
	.word sub_8011224+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_801140E+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word nullsub_43+1
	.word sub_801140E+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_801140E+1
	.word sub_801140E+1
	.word sub_801140E+1
	.word sub_801140E+1
	.word sub_801140E+1
	.word nullsub_43+1
	.word sub_801140E+1
	thumb_func_end sub_8011044

// symdb: Detaches a battle object's "related object 2" attachment, running that object's removal routine first if one is attached.
// symdb: void battle_object_detachRelatedObject2(BattleObject* obj /* r5 */); clobbers r0, r1, lr; sets
// symdb: NZ flags from the cleared/zero pointer
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_object_detachRelatedObject2_80111B8.yaml
	thumb_local_start
battle_object_detachRelatedObject2_80111B8:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq locret_80111C8
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_80111C8:
	pop {pc}
	thumb_func_end battle_object_detachRelatedObject2_80111B8

	thumb_local_start
sub_80111CA:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq locret_80111DA
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_80111DA:
	pop {pc}
	thumb_func_end sub_80111CA

	thumb_local_start
sub_80111DC:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq locret_80111EC
	bl sub_80C4204
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_80111EC:
	pop {pc}
	thumb_func_end sub_80111DC

	thumb_local_start
sub_80111EE:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq locret_80111FE
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_80111FE:
	pop {pc}
	thumb_func_end sub_80111EE

	thumb_local_start
sub_8011200:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq locret_8011210
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_8011210:
	pop {pc}
	thumb_func_end sub_8011200

	thumb_local_start
sub_8011212:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq locret_8011222
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_8011222:
	pop {pc}
	thumb_func_end sub_8011212

	thumb_local_start
sub_8011224:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq locret_8011234
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_8011234:
	pop {pc}
	thumb_func_end sub_8011224

	thumb_local_start
sub_8011236:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq loc_8011246
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
loc_8011246:
	ldr r0, [r5,#oBattleObject_ExtraVars]
	tst r0, r0
	beq locret_8011254
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_ExtraVars]
locret_8011254:
	pop {pc}
	thumb_func_end sub_8011236

	thumb_local_start
sub_8011256:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq locret_8011266
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_8011266:
	pop {pc}
	thumb_func_end sub_8011256

// symdb: Dispatches a mode index in r0 to one of 24 handler functions via a jump table
// symdb: void dispatchMode_8011268(u32 mode /* r0 */, lr); clobbers r0-r3, r4-r12, nzcv; no preserved
// symdb: regs
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8011268.yaml
	thumb_func_start sub_8011268
sub_8011268:
	push {lr}
	mov r2, #0
	lsl r0, r0, #2
	ldr r1, off_8011278 // =off_801127C 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {pc}
off_8011278:
	.word off_801127C
off_801127C:
	.word nullsub_42+1
	.word sub_80112E0+1
	.word sub_80112EA+1
	.word sub_80112F4+1
	.word sub_80112FE+1
	.word sub_8011308+1
	.word sub_8011312+1
	.word sub_8011330+1
	.word sub_801131C+1
	.word sub_8011326+1
	.word sub_801133A+1
	.word nullsub_43+1
	.word sub_8011366+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_8011352+1
	.word sub_8011356+1
	.word sub_801135A+1
	.word sub_801135E+1
	.word sub_8011362+1
	.word nullsub_43+1
	.word sub_8011366+1
	thumb_func_end sub_8011268

	thumb_local_start
sub_80112E0:
	push {lr}
	ldr r0, off_80114D8 // =0x104 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_80112E0

	thumb_local_start
sub_80112EA:
	push {lr}
	ldr r0, off_80114DC // =0x108 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_80112EA

	thumb_local_start
sub_80112F4:
	push {lr}
	ldr r0, dword_80114E0 // =0x10a 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_80112F4

	thumb_local_start
sub_80112FE:
	push {lr}
	ldr r0, off_80114E4 // =0x10c 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_80112FE

	thumb_local_start
sub_8011308:
	push {lr}
	ldr r0, off_80114E8 // =0x111 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_8011308

	thumb_local_start
sub_8011312:
	push {lr}
	ldr r0, off_80114EC // =0x105 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_8011312

	thumb_local_start
sub_801131C:
	push {lr}
	ldr r0, off_80114F0 // =0x109 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_801131C

	thumb_local_start
sub_8011326:
	push {lr}
	ldr r0, off_80114F4 // =0x10d 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_8011326

	thumb_local_start
sub_8011330:
	push {lr}
	ldr r0, dword_80114F8 // =0x10e 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_8011330

	thumb_local_start
sub_801133A:
	push {lr}
	ldr r0, dword_80114FC // =0x112 
	bl sub_8011344
	pop {pc}
	thumb_func_end sub_801133A

	thumb_local_start
sub_8011344:
	push {r4,lr}
	lsl r4, r2, #0x10
	add r4, r4, r0
	bl battle_spawnObject56LinkedToOwner_80C44A8
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	pop {r4,pc}
	thumb_func_end sub_8011344

	thumb_local_start
sub_8011352:
	mov r3, #2
	b loc_8011368

	thumb_local_start
sub_8011356:
	mov r3, #4
	b loc_8011368

	thumb_local_start
sub_801135A:
	mov r3, #6
	b loc_8011368

	thumb_local_start
sub_801135E:
	mov r3, #8
	b loc_8011368

	thumb_local_start
sub_8011362:
	mov r3, #0xa
	b loc_8011368

	thumb_local_start
sub_8011366:
	mov r3, #0

loc_8011368:
	push {r4,r6,lr}
	mov r6, r3
	ldr r4, off_8011500 // =0xa0c 
	lsl r2, r2, #0x10
	orr r4, r2
	mov r2, #1
	bl spawn_t1_0x47_probablyGeneric_80C468C
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r6, #0
	bne locret_8011382
	bl sub_80C46C0
locret_8011382:
	pop {r4,r6,pc}
	thumb_func_end sub_8011352
	thumb_func_end sub_8011356
	thumb_func_end sub_801135A
	thumb_func_end sub_801135E
	thumb_func_end sub_8011362
	thumb_func_end sub_8011366

	thumb_func_start sub_8011384
sub_8011384:
	push {lr}
	lsl r0, r0, #2
	ldr r1, off_8011394 // =off_8011398 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {pc}
	.balign 4, 0x00
off_8011394:
	.word off_8011398
off_8011398:
	.word battle_object_detachRelatedObject2_80111B8+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word sub_80113FC+1
	.word nullsub_43+1
	.word sub_801140E+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_801140E+1
	.word sub_801140E+1
	.word sub_801140E+1
	.word sub_801140E+1
	.word sub_801140E+1
	.word nullsub_43+1
	.word sub_801140E+1
	thumb_func_end sub_8011384

	thumb_local_start
sub_80113FC:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq locret_801140C
	bl sub_80C44C8
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_801140C:
	pop {pc}
	thumb_func_end sub_80113FC

	thumb_local_start
sub_801140E:
	push {lr}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #NULL
	beq locret_801141E
	bl sub_80C46B0
	mov r0, #NULL
	str r0, [r5,#oBattleObject_RelatedObject2Ptr]
locret_801141E:
	pop {pc}
	thumb_func_end sub_801140E

// symdb: Dispatches a menu/UI control value: if r0 is 0, forwards r1 to sub_8011268; otherwise forwards r0 to sub_8010DF6 with selector 2.
// symdb: void sub_8011420(u32 r0, u32 r1); // no return; clobbers r0-r4, flags
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8011420.yaml
	thumb_func_start sub_8011420
sub_8011420:
	push {lr}
	cmp r0, #0
	bne loc_801142E
	mov r0, r1
	bl sub_8011268
	pop {pc}
loc_801142E:
	mov r1, r0
	mov r0, #2
	bl sub_8010DF6
	pop {pc}
	thumb_func_end sub_8011420

	thumb_local_start
sub_8011438:
	push {lr}
	cmp r0, #0
	bne loc_8011446
	mov r0, r1
	bl sub_8011384
	pop {pc}
loc_8011446:
	mov r1, r0
	mov r0, #2
	bl sub_8011044
	pop {pc}
	thumb_func_end sub_8011438

// symdb: Dispatches a per-AI-type "actor finished" handler for a battle object, usually ending the actor's current animation.
// symdb: void battle_RunObjectActorEndHandler_8011450(BattleObject* obj /* r5 */); clobbers r0-r4,
// symdb: r6-r12, flags, lr; r1/r2 still hold aiIndex/aiDataPtr on the actorType==0 early return
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8011450.yaml
	thumb_func_start sub_8011450
sub_8011450:
	push {lr}
	ldr r2, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r2,#oAIData_ActorType]
	ldrb r1, [r2,#oAIData_AIIndex]
	cmp r0, #0
	beq locret_8011468
	lsl r1, r1, #2
	ldr r0, off_801146C // =off_8011470 
	ldr r1, [r1,r0]
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	mov lr, pc
	bx r1
locret_8011468:
	pop {pc}
	.balign 4, 0
off_801146C:
	.word off_8011470
off_8011470:
	.word battle_EndObjectCurrentAnim_80C44D2+1
	.word battle_EndObjectCurrentAnim_80C44D2+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word battle_EndObjectCurrentAnim_80C44D2+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word battle_EndObjectCurrentAnim_80C44D2+1
	.word sub_80FF668+1
	.word nullsub_43+1
	.word battle_EndObjectCurrentAnim_80C44D2+1
	.word nullsub_43+1
	.word battle_EndObjectCurrentAnim_80C44D2+1
	.word battle_EndObjectCurrentAnim_80C44D2+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word nullsub_43+1
	.word sub_80C46B6+1
	thumb_func_end sub_8011450

// symdb: Empty stub that does nothing and immediately returns; kept as a no-op hook point by the game.
// symdb: void nullsub_43(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_43.yaml
	thumb_local_start
nullsub_43:
	mov pc, lr
	.balign 4, 0x00
off_80114D8:
	.word 0x104
off_80114DC:
	.word 0x108
dword_80114E0:
	.word 0x10A
off_80114E4:
	.word 0x10C
off_80114E8:
	.word 0x111
off_80114EC:
	.word 0x105
off_80114F0:
	.word 0x109
off_80114F4:
	.word 0x10D
dword_80114F8:
	.word 0x10E
dword_80114FC:
	.word 0x112
off_8011500:
	.word 0xA0C
	thumb_func_end nullsub_43

// symdb: Loads a battle object's sprite/animation, sets its shadow flag, installs a collision-data slot, configures collision data and horizontal flip, returning 1 on success.
// symdb: (r0 = packed sprite/anim/shadow params, r1 = packed collision-init params, r5 = BattleObject*,
// symdb: r10 = Toolkit*) -> r0 = 1 on success, 0 if no collision slot was free ; side effects: writes
// symdb: CurAnim/CurAnimCopy on the object, allocates/links a CollisionData block, populates it, sets
// symdb: sprite flip bits.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_initSpriteAndCollision_8011504.yaml
	thumb_func_start battleObject_initSpriteAndCollision_8011504
battleObject_initSpriteAndCollision_8011504:
	push {r6,r7,lr}
	mov r6, r0
loc_8011508:
	mov r7, r1
	mov r0, #0x80
	lsl r1, r6, #0x10
	lsr r1, r1, #0x18
	lsl r2, r6, #0x18
	lsr r2, r2, #0x18
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	lsr r0, r6, #0x18
	tst r0, r0
	beq loc_8011528
	bl sprite_hasShadow
	b loc_801152C
loc_8011528:
	bl sprite_noShadow // () -> void
loc_801152C:
	lsl r0, r6, #8
	lsr r0, r0, #0x18
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	bl object_createCollisionData
	tst r0, r0
	bne loc_8011540
	pop {r6,r7,pc}
loc_8011540:
	lsr r1, r7, #0x18
	lsl r2, r7, #8
	lsr r2, r2, #0x18
	lsl r3, r7, #0x10
	lsr r3, r3, #0x18
	bl object_setupCollisionData
	bl object_getFlip // () -> int
	bl sprite_setFlip
	mov r0, #1
	pop {r6,r7,pc}
	thumb_func_end battleObject_initSpriteAndCollision_8011504

// symdb: Fills in the base battle-object fields (position, element, related object, flags) for a newly spawned battle entity.
// symdb: void BasicBattleObjectInitialize(BattleObject* obj, u8 panelX, u8 panelY, u8 element,
// symdb: BattleObject* related, u32 damageStaminaCounterDisabler) -> r1 = alliance/flip value of related
// symdb: object
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/BasicBattleObjectInitialize.yaml
	thumb_func_start BasicBattleObjectInitialize
BasicBattleObjectInitialize:
	strb r1, [r0,#oBattleObject_PanelX]
	strb r2, [r0,#oBattleObject_PanelY]
	strb r3, [r0,#oBattleObject_Element]
	str r6, [r0,#oBattleObject_DamageAndStaminaDamageCounterDisabler]
	ldrh r1, [r5,#oBattleObject_AllianceAndDirectionFlip]
	strh r1, [r0,#oBattleObject_AllianceAndDirectionFlip]
	str r5, [r0,#oBattleObject_RelatedObject1Ptr]
	mov pc, lr
	thumb_func_end BasicBattleObjectInitialize

	thumb_func_start basicHandleBattleObjectDamage_801156A
basicHandleBattleObjectDamage_801156A:
	push {lr}
	sub sp, sp, #0x10
	str r0, [sp,#8]
	mov r0, #0
	str r0, [sp,#4]
	bl object_spawnHiteffect
	bl calcFinalDamageAsPanelDamage1to5SumReturnFinalDamage_r0_PanelDamage6_r1_800E3BE
	str r0, [sp]
	ldr r2, [sp,#8]
	cmp r2, #1
	beq loc_8011594
	ldrh r1, [r5,#oBattleObject_HP]
	sub r1, r1, r0
	strh r1, [r5,#oBattleObject_HP]
	bgt loc_8011594
	mov r0, #0
	sub r0, #1
	str r0, [sp,#4]
	b loc_80115C2
loc_8011594:
	bl sprite_clearFinalPalette
	ldr r0, [sp]
	tst r0, r0
	beq loc_80115C2
	bl sprite_forceWhitePalette
	ldr r0, [sp,#8]
	cmp r0, #0
	beq loc_80115B0
	cmp r0, #2
	beq loc_80115B8
	mov r0, #1
	b loc_80115C0
loc_80115B0:
	mov r0, #SOUND_UNK_85
	bl PlaySoundEffect
	b loc_80115BE
loc_80115B8:
	mov r0, #0x6d 
	bl PlaySoundEffect
loc_80115BE:
	mov r0, #0
loc_80115C0:
	str r0, [sp,#4]
loc_80115C2:
	ldr r0, [sp]
	tst r0, r0
	beq loc_80115C8
loc_80115C8:
	ldr r0, [sp,#4]
	add sp, sp, #0x10
	pop {pc}
	thumb_func_end basicHandleBattleObjectDamage_801156A

	thumb_local_start
sub_80115CE:
	push {lr}
	sub sp, sp, #0x10
	str r0, [sp,#8]
	mov r0, #0
	str r0, [sp,#4]
	bl object_spawnHiteffect
	bl calcFinalDamageAsPanelDamage1to5SumReturnFinalDamage_r0_PanelDamage6_r1_800E3BE
	str r0, [sp]
	str r1, [sp,#0xc]
	add r0, r0, r1
	ldr r2, [sp,#8]
	tst r2, r2
	bne loc_80115FC
	ldrh r1, [r5,#0x24]
	sub r1, r1, r0
	strh r1, [r5,#0x24]
	bgt loc_80115FC
	mov r0, #0
	sub r0, #1
	str r0, [sp,#4]
	b loc_801161E
loc_80115FC:
	bl sprite_clearFinalPalette
	ldr r0, [sp]
	tst r0, r0
	beq loc_801161E
	bl sprite_forceWhitePalette
	ldr r0, [sp,#8]
	tst r0, r0
	beq loc_8011614
	mov r0, #1
	b loc_801161C
loc_8011614:
	mov r0, #SOUND_UNK_85
	bl PlaySoundEffect
	mov r0, #0
loc_801161C:
	str r0, [sp,#4]
loc_801161E:
	ldr r0, [sp]
	tst r0, r0
	beq loc_8011624
loc_8011624:
	ldr r0, [sp,#4]
	add sp, sp, #0x10
	pop {pc}
	thumb_func_end sub_80115CE

	thumb_func_start object_applyDamage
object_applyDamage:
	push {r4,lr}
	bl basicHandleBattleObjectDamage_801156A
	cmp r0, #0
	beq locret_801164A
	push {r0}
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #0
	bl spawn_t1_0x0_EffectObject
	mov r0, #SOUND_HIT_BOMB_1
	bl PlaySoundEffect
	pop {r0}
locret_801164A:
	pop {r4,pc}
	thumb_func_end object_applyDamage

	thumb_func_start sub_801164C
sub_801164C:
	push {lr}
	push {r0,r1}
	sub r2, r2, r0
	sub r3, r3, r1
	mul r2, r6
	mul r3, r6
	push {r3}
	mov r0, r2
	mov r1, r7
	svc 6
	pop {r3}
	push {r0}
	mov r0, r3
	mov r1, r7
	svc 6
	mov r1, r0
	pop {r0}
	mov r2, r0
	mov r3, r1
	pop {r0,r1}
	add r0, r0, r2
	add r1, r1, r3
	pop {pc}
	.word 0
	.byte 0, 0
	thumb_func_end sub_801164C

	thumb_func_start object_setAttack0
object_setAttack0:
	mov r2, #0
	b loc_8011698
	thumb_func_end object_setAttack0

	thumb_func_start object_setAttack1
object_setAttack1:
	mov r2, #1
	b loc_8011698
	thumb_func_end object_setAttack1

	thumb_func_start object_setAttack2
object_setAttack2:
	mov r2, #2
	b loc_8011698

	thumb_func_start object_setAttack3
object_setAttack3:
	mov r2, #3
	b loc_8011698

	thumb_func_start object_setAttack4
object_setAttack4:
	mov r2, #4
	b loc_8011698

	thumb_func_start object_setAttack5
object_setAttack5:
	mov r2, #5
	b loc_8011698

loc_8011698:
	push {lr}
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	add r1, #0xa0
	strh r0, [r1,#oAIAttackVars_Unk_00]
	strb r2, [r1,#oAIAttackVars_Unk_1c]
	bl ai_clearPwrAtkStateFromBattleObject_801011A
	pop {pc}
	thumb_func_end object_setAttack2
	thumb_func_end object_setAttack3
	thumb_func_end object_setAttack4
	thumb_func_end object_setAttack5

// symdb: Initializes AI attack vars (Unk_0c/Unk_03/Unk_18/Unk_2c), sets the battle object's AttackVar[4] to 0x10, and immediately steps the AI attack state machine.
// symdb: (r0 = byte to Unk_0c, r1 = u16 to Unk_18, r2 = byte to Unk_03, r5 = BattleObject*, r10 =
// symdb: toolkit) -> r0 = original r0 ; side effects writes AIAttackVars at AIDataPtr + 0xa0, then sets
// symdb: object AttackVar[4] = 0x10 and runs one step of the AI attack state machine
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/aiAttack_initVarsAndStart_80116AE.yaml
	thumb_func_start aiAttack_initVarsAndStart_80116AE
aiAttack_initVarsAndStart_80116AE:
	push {r4,r7,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	mov r7, #0xa0
	add r7, r7, r4
	strb r0, [r7,#oAIAttackVars_Unk_0c]
	strh r1, [r7,#oAIAttackVars_Unk_18]
	strb r2, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_2c]
	mov r0, #0x10
	bl object_setAttack4
	bl aiAttack_stepStateMachine_80EB04C
	pop {r4,r7,pc}
	// never reached??
	mov r0, #0x3f 
	bl object_setAttack4
	bl sub_80EB234
	pop {r4,r7,pc}
	thumb_func_end aiAttack_initVarsAndStart_80116AE

	thumb_func_start sub_80116D8
sub_80116D8:
	push {r7,lr}
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #0xa0
	strb r0, [r7,#oAIAttackVars_Unk_0c]
	strh r1, [r7,#oAIAttackVars_Unk_18]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_2c]
	mov r0, #0x10
	bl object_setAttack4
	bl aiAttack_stepStateMachine_80EB04C
	pop {r7,pc}
	thumb_func_end sub_80116D8

	thumb_local_start
sub_80116F6:
	push {r7,lr}
	ldr r7, [r5,#0x58]
	add r7, #0xa0
	strb r0, [r7,#0x16]
	strb r1, [r7,#0x17]
	strb r2, [r7,#0x18]
	mov r0, #2
	strb r0, [r7,#3]
	str r3, [r7,#0x2c]
	mov r0, #0x10
	bl object_setAttack4
	bl aiAttack_stepStateMachine_80EB04C
	pop {r7,pc}
	thumb_func_end sub_80116F6

	thumb_func_start object_exitAttackState
object_exitAttackState:
	push {r6,r7,lr}
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurAnim]
	b loc_801171E

// symdb: Tears down a battle object's current AI attack: zeroes attack-vars scratch, applies per-mode cleanup (chip lockout / Unk_15), clears AI-data flags, clears the power-atk state, clears the using-action bit, and parks the object in CurAction=8 with the AIAttackVars timer reset.
// symdb: (r5 = battle object) -> void ; side effects: writes AIData + AIAttackVars + CurAction of the
// symdb: object in r5, modifies the global AIData flags at Unk_44 (mask 0x1000003F), calls
// symdb: battleObject_clearPwrAtkState_8012EA8 and object_clearFlag(OBJECT_FLAGS_USING_ACTION).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/object_exitAttackState_801171C.yaml
	thumb_func_start object_exitAttackState_801171C
object_exitAttackState_801171C:
	push {r6,r7,lr}
loc_801171E:
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	mov r7, #0xa0
	add r7, r7, r1
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_1b]
	ldrb r6, [r7,#oAIAttackVars_Unk_1c]
	cmp r6, #4
	beq loc_8011754
	cmp r6, #2
	bne loc_8011736
	ldrb r0, [r7,#oAIAttackVars_Unk_05]
	strb r0, [r1,#oAIData_ChipLockoutTimer]
loc_8011736:
	cmp r6, #3
	bne loc_801173E
	ldrb r0, [r7,#oAIAttackVars_Unk_05]
	strb r0, [r1,#oAIData_Unk_15]
loc_801173E:
	mov r0, #0
	strb r0, [r1,#oAIData_Unk_1a]
	ldr r0, dword_8011760 // =0x1000003f 
	bl ClearAIData_Unk_44_Flag
	bl battleObject_clearPwrAtkState_8012EA8
	mov r0, #1
	lsl r0, r0, #0x16
	bl object_clearFlag // (int bitfield) -> void
loc_8011754:
	mov r0, #8
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_Unk_00]
	pop {r6,r7,pc}
	.balign 4, 0
dword_8011760:
	.word 0x1000003F
	thumb_func_end object_exitAttackState
	thumb_func_end object_exitAttackState_801171C

	thumb_func_start calledOnBAtkProbInit_8011764
calledOnBAtkProbInit_8011764:
	push {r6,r7,lr}
	ldr r6, [r5,#oBattleObject_AIDataPtr]
	mov r7, #oAIData_AttackVars
	add r7, r7, r6
	ldr r1, off_80117D0 // =off_80117D4 
	ldrb r0, [r6,#oAIData_BButton]
	lsl r0, r0, #2
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r6,r7,pc}
	thumb_func_end calledOnBAtkProbInit_8011764

	thumb_func_start sub_801177A
sub_801177A:
	push {r6,r7,lr}
	ldr r6, [r5,#oBattleObject_AIDataPtr]
	mov r7, #oAIData_AttackVars
	add r7, r7, r6
	ldr r1, off_80117D0 // =off_80117D4 
	ldrb r0, [r6,#oAIData_Unk_04]
	lsl r0, r0, #2
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r6,r7,pc}
	thumb_func_end sub_801177A

	thumb_func_start sub_8011790
sub_8011790:
	push {r6,r7,lr}
	mov r7, #oAIData_AttackVars
	add r7, r7, r6
	ldr r1, off_80117D0 // =off_80117D4 
	ldrb r0, [r6,#oAIData_BLeftAbility]
	lsl r0, r0, #2
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r6,r7,pc}
	thumb_func_end sub_8011790

	thumb_func_start sub_80117A4
sub_80117A4:
	push {r6,r7,lr}
	ldr r6, [r5,#oBattleObject_AIDataPtr]
	mov r7, #oAIData_AttackVars
	add r7, r7, r6
	ldr r1, off_80117D0 // =off_80117D4 
	ldrb r0, [r6,#oAIData_BPwrAtk]
	lsl r0, r0, #2
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r6,r7,pc}
	thumb_func_end sub_80117A4

	thumb_local_start
sub_80117BA:
	push {r6,r7,lr}
	ldr r6, [r5,#oBattleObject_AIDataPtr]
	mov r7, #oAIData_AttackVars
	add r7, r7, r6
	ldr r1, off_80117D0 // =off_80117D4 
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r6,r7,pc}
	.byte 0, 0
off_80117D0:
	.word off_80117D4
off_80117D4:
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x0
	.word busterBugChargeShotDamageCalcHappensHere_8011A7E+1 // 0x1
	.word sub_8011ADA+1 // 0x2
	.word sub_8011AF2+1 // 0x3
	.word sub_8011B4A+1 // 0x4
	.word nullsub_44+1 // 0x5
	.word sub_8011BA2+1 // 0x6
	.word greatfireAPwrAtk_init_8011BD0+1 // 0x7
	.word sub_8011BE8+1 // 0x8
	.word sub_8011C00+1 // 0x9
	.word sub_8011C18+1 // 0xa
	.word sub_8011C38+1 // 0xb
	.word spoutcrossBPwrAtk_init_8011C5E+1 // 0xc
	.word nullsub_44+1 // 0xd
	.word nullsub_44+1 // 0xe
	.word sub_8011C88+1 // 0xf
	.word sub_8011CA8+1 // 0x10
	.word sub_8011CB4+1 // 0x11
	.word slashcrossBPwrAtk_init_8011CD6+1 // 0x12
	.word nullsub_44+1 // 0x13
	.word sub_8011CF8+1 // 0x14
	.word sub_8011D20+1 // 0x15
	.word sub_8011D38+1 // 0x16
	.word sub_8011D54+1 // 0x17
	.word nullsub_44+1 // 0x18
	.word sub_8011D74+1 // 0x19
	.word sub_8011D9C+1 // 0x1a
	.word sub_8011DBC+1 // 0x1b
	.word sub_8011DDC+1 // 0x1c
	.word sub_8011DFC+1 // 0x1d
	.word sub_8011E1C+1 // 0x1e
	.word nullsub_44+1 // 0x1f
	.word nullsub_44+1 // 0x20
	.word sub_8011E40+1 // 0x21
	.word sub_8011E78+1 // 0x22
	.word sub_8011EAC+1 // 0x23
	.word sub_8011ED0+1 // 0x24
	.word sub_8011EF0+1 // 0x25
	.word sub_8011F10+1 // 0x26
	.word sub_8011F44+1 // 0x27
	.word sub_8011F64+1 // 0x28
	.word nullsub_44+1 // 0x29
	.word sub_8011F84+1 // 0x2a
	.word sub_8011F8C+1 // 0x2b
	.word sub_8011FCE+1 // 0x2c
	.word nullsub_44+1 // 0x2d
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x2e
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x2f
	.word sub_8012018+1 // 0x30
	.word sub_8012044+1 // 0x31
	.word sub_801206E+1 // 0x32
	.word sub_801208A+1 // 0x33
	.word sub_80120A6+1 // 0x34
	.word sub_80120CC+1 // 0x35
	.word sub_80120D6+1 // 0x36
	.word sub_80120FE+1 // 0x37
	.word nullsub_44+1 // 0x38
	.word sub_8012124+1 // 0x39
	.word sub_8012144+1 // 0x3a
	.word sub_801216E+1 // 0x3b
	.word sub_8012194+1 // 0x3c
	.word sub_80121BC+1 // 0x3d
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x3e
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x3f
	.word sub_80121DC+1 // 0x40
	.word sub_80121F8+1 // 0x41
	.word sub_8012210+1 // 0x42
	.word sub_8012228+1 // 0x43
	.word sub_8012240+1 // 0x44
	.word tomahawkmanBPwrAtk_init_8012258+1 // 0x45
	.word sub_8012278+1 // 0x46
	.word sub_8012292+1 // 0x47
	.word sub_80122AA+1 // 0x48
	.word sub_80122C2+1 // 0x49
	.word sub_80122DA+1 // 0x4a
	.word sub_80122F2+1 // 0x4b
	.word sub_801230C+1 // 0x4c
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x4d
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x4e
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x4f
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x50
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x51
	.word sub_8012326+1 // 0x52
	.word loc_801232A+1 // 0x53
	.word sub_801233C+1 // 0x54
	.word sub_8012346+1 // 0x55
	.word sub_8012350+1 // 0x56
	.word sub_801235A+1 // 0x57
	.word sub_8012364+1 // 0x58
	.word sub_801236E+1 // 0x59
	.word sub_8012378+1 // 0x5a
	.word sub_8012382+1 // 0x5b
	.word sub_801238C+1 // 0x5c
	.word sub_8012396+1 // 0x5d
	.word sub_80123A0+1 // 0x5e
	.word bubbleSpreadBPwrAtk_init_80123AA+1 // 0x5f
	.word sub_80123C8+1 // 0x60
	.word sub_80123D2+1 // 0x61
	.word sub_80123DC+1 // 0x62
	.word sub_80123E6+1 // 0x63
	.word sub_80123F0+1 // 0x64
	.word sub_80123FA+1 // 0x65
	.word sub_8012404+1 // 0x66
	.word sub_801240E+1 // 0x67
	.word sub_8012418+1 // 0x68
	.word sub_8012422+1 // 0x69
	.word sub_801242C+1 // 0x6a
	.word sub_8012436+1 // 0x6b
	.word sub_8012440+1 // 0x6c
	.word sub_801244A+1 // 0x6d
	.word sub_801245A+1 // 0x6e
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x6f
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x70
	.word sub_8012464+1 // 0x71
	.word sub_8012484+1 // 0x72
	.word sub_801248E+1 // 0x73
	.word sub_8012498+1 // 0x74
	.word sub_80124B8+1 // 0x75
	.word sub_80124C2+1 // 0x76
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x77
	.word sub_80124CC+1 // 0x78
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x79
	.word sub_80124D6+1 // 0x7a
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x7b
	.word sub_80124E0+1 // 0x7c
	.word sub_80124EA+1 // 0x7d
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x7e
	.word sub_80124F4+1 // 0x7f
	.word sub_80124FE+1 // 0x80
	.word sub_801251C+1 // 0x81
	.word megamanChargeShotBPwrAtk_init_8011A26+1 // 0x82
	.word sub_8012526+1 // 0x83
	.word sub_8012536+1 // 0x84
	.word sub_8012540+1 // 0x85
	.word sub_801254A+1 // 0x86
	.word sub_8012552+1 // 0x87
	.word sub_801255C+1 // 0x88
	.word sub_8012572+1 // 0x89
	.word sub_801257C+1 // 0x8a
	.word sub_8012586+1 // 0x8b
	.word sub_80125AC+1 // 0x8c
	.word sub_80125D0+1 // 0x8d
	.word sub_8012608+1 // 0x8e
	.word sub_8012612+1 // 0x8f
	.word sub_801261E+1 // 0x90
	.word sub_8012628+1 // 0x91
	.word sub_8012632+1 // 0x92
	.word sub_801263A+1 // 0x93
	thumb_func_end sub_80117BA

	thumb_local_start
nullsub_44:
	mov pc, lr
	thumb_func_end nullsub_44

// symdb: MegaMan's charge shot: burns one primary RNG draw per shot and, stat-gated, runs sub_8013D5E (a weighted 1/2 pick) whose outcome sends the shot down a second RNG-consuming path.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/megamanChargeShotBPwrAtk_init_8011A26.yaml
	thumb_local_start
megamanChargeShotBPwrAtk_init_8011A26: // JP: 0x8012036
	push {r4,lr}
	bl sub_8013D5E
	cmp r0, #0
	beq loc_8011A44
	cmp r0, #1
	bne loc_8011A3A
	bl sub_8011ADA
	pop {r4,pc}
loc_8011A3A:
	cmp r0, #2
	bne loc_8011A44
	bl busterBugChargeShotDamageCalcHappensHere_8011A7E
	pop {r4,pc}
loc_8011A44:
	bl computeBeastDamageCap_801265A
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r1, #0x4d 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, r0
	cmp r4, #0
	beq loc_8011A74
	bl GetPositiveSignedRNG
	mov r1, #1
	cmp r4, #0x1e
	blt loc_8011A6E
	mov r1, #7
loc_8011A6E:
	and r0, r1
	beq loc_8011A74
	mov r4, #0
loc_8011A74:
	strb r4, [r7,#oAIAttackVars_Unk_0c]
	mov r1, #0
	strb r1, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0x11
	pop {r4,pc}
	thumb_func_end megamanChargeShotBPwrAtk_init_8011A26

// symdb: AI attack-damage calculation for the Buster-bug-style charge shot: fills an AI attack-vars struct with damage derived from Attack (+1 if the user is a beast transformation), a randomized counter field, and zeroes the rest, then returns 0x16.
// symdb: u32 battle_aiAttackDamageCalcBusterBug_8011A7E(u8 /*ignored*/ r5 /*= battle object (navi)*/, u8
// symdb: /*ignored*/ r10, aiAttackVars_t *r7 /*inout*/, void (*into) lr); // r0/r1/r2/r3/r5/r6/r7/lr
// symdb: clobbered, NZ set, return value in r0 = 0x16
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/busterBugChargeShotDamageCalcHappensHere_8011A7E.yaml
	thumb_local_start
busterBugChargeShotDamageCalcHappensHere_8011A7E:
	push {r4,lr}
	mov r1, #oNaviStats_Attack
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	add r0, #1
	push {r0}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	cmp r0, #5
	pop {r0}
	bne loc_8011A98
	mov r0, #1
loc_8011A98:
	mov r1, #0xa
	mul r0, r1
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r1, #oNaviStats_Unk_4f 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, r0
	tst r4, r4
	beq loc_8011AC2
	cmp r4, #6
	beq loc_8011AC4
	bl GetPositiveSignedRNG
	mov r1, #1
	cmp r4, #9
	beq loc_8011ABC
	cmp r4, #0x23 
	bne loc_8011ABE
loc_8011ABC:
	mov r1, #7
loc_8011ABE:
	and r0, r1
	beq loc_8011AC4
loc_8011AC2:
	mov r4, #6
loc_8011AC4:
	str r4, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_03]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x16
	pop {r4,pc}
	thumb_func_end busterBugChargeShotDamageCalcHappensHere_8011A7E

	thumb_local_start
sub_8011ADA:
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_03]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	strh r0, [r7,#oAIAttackVars_Damage]
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x33 
	mov pc, lr
	thumb_func_end sub_8011ADA

	thumb_local_start
sub_8011AF2:
	push {lr}
	bl computeBeastDamageCap_801265A
	cmp r0, #5
	ble loc_8011AFE
	mov r0, #5
loc_8011AFE:
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r1, #0x4d 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r1, #0
	strb r1, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_30]
	bl battle_testFlag0x40_800A8F8
	beq loc_8011B2C
	bl battle_getAllianceEntryStatus_802E4B8
	cmp r0, #0xd
	beq loc_8011B38
loc_8011B2C:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0
	cmp r0, #0x18
	bne loc_8011B3E
loc_8011B38:
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_0e]
	mov r1, #8
loc_8011B3E:
	strb r1, [r7,#oAIAttackVars_Unk_0d]
	mov r1, #0
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	str r1, [r0,#oAIData_Unk_68]
	mov r0, #0x1e
	pop {pc}
	thumb_func_end sub_8011AF2

	thumb_local_start
sub_8011B4A:
	push {lr}
	bl computeBeastDamageCap_801265A
	cmp r0, #5
	ble loc_8011B56
	mov r0, #5
loc_8011B56:
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r1, #0x4d 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r1, #0
	strb r1, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_30]
	bl battle_testFlag0x40_800A8F8
	beq loc_8011B84
	bl battle_getAllianceEntryStatus_802E4B8
	cmp r0, #0xd
	beq loc_8011B90
loc_8011B84:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0
	cmp r0, #0x17
	bne loc_8011B96
loc_8011B90:
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_0e]
	mov r1, #8
loc_8011B96:
	strb r1, [r7,#oAIAttackVars_Unk_0d]
	mov r1, #0
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	str r1, [r0,#oAIData_Unk_68]
	mov r0, #0x1d
	pop {pc}
	thumb_func_end sub_8011B4A

	thumb_local_start
sub_8011BA2:
	push {lr}
	mov r0, #0x1e
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	ldr r0, off_8011BCC // =0x23c 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x27 
	pop {pc}
	.balign 4, 0
off_8011BCC:
	.word 0x23C
	thumb_func_end sub_8011BA2

	thumb_local_start
greatfireAPwrAtk_init_8011BD0:
	push {lr}
	mov r0, #0x32 
	mov r1, #0x1e
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x35 
	pop {pc}
	thumb_func_end greatfireAPwrAtk_init_8011BD0

	thumb_local_start
sub_8011BE8:
	push {lr}
	mov r0, #0xa
	mov r1, #0xa
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x86
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x3a 
	pop {pc}
	thumb_func_end sub_8011BE8

	thumb_local_start
sub_8011C00:
	push {lr}
	mov r0, #0x28 
	mov r1, #0x1e
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #3
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x3c 
	pop {pc}
	thumb_func_end sub_8011C00

	thumb_local_start
sub_8011C18:
	push {lr}
	mov r0, #0x1e
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x20 
	strb r0, [r7,#oAIAttackVars_Unk_02]
	ldr r0, dword_8011C34 // =0x2d3d00 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x3d 
	pop {pc}
	.balign 4, 0
dword_8011C34:
	.word 0x2D3D00
	thumb_func_end sub_8011C18

	thumb_local_start
sub_8011C38:
	push {lr}
	mov r0, #0x28 
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #3
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #1
	lsl r0, r0, #8
	add r0, #0xf
	lsl r0, r0, #8
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x3e 
	pop {pc}
	thumb_func_end sub_8011C38

	thumb_local_start
spoutcrossBPwrAtk_init_8011C5E: // spoutcross CS initialize? // JP: 801225e
	push {lr}
	mov r0, #0x14
	mov r1, #0xa
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_03]
	ldr r0, dword_8011C84 // =0xd 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x25 
	pop {pc}
	.balign 4, 0
dword_8011C84:
	.word 0xD
	thumb_func_end spoutcrossBPwrAtk_init_8011C5E

	thumb_local_start
sub_8011C88:
	push {lr}
	mov r0, #0x28 
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0x20 
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x3f 
	pop {pc}
	thumb_func_end sub_8011C88

	thumb_local_start
sub_8011CA8:
	mov r0, #0x14
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0x28 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x1c
	mov pc, lr
	thumb_func_end sub_8011CA8

	thumb_local_start
sub_8011CB4:
	push {r4,lr}
	mov r0, #0
	bl useChipRelated_80127C0
	cmp r0, #0x53 
	beq loc_8011CC4
	cmp r0, #0x54 
	bne loc_8011CCA
loc_8011CC4:
	mov r1, #1
	strb r1, [r7,#oAIAttackVars_Unk_04]
	b locret_8011CD4
loc_8011CCA:
	cmp r0, #0x40 
	bne loc_8011CD2
	mov r0, #0x11
	strb r0, [r7,#oAIAttackVars_Unk_03]
loc_8011CD2:
	mov r0, #0x41 
locret_8011CD4:
	pop {r4,pc}
	thumb_func_end sub_8011CB4

	thumb_local_start
slashcrossBPwrAtk_init_8011CD6: // JP: 0x80122d2
	push {lr}
	mov r0, #0x3c 
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x10
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0x80
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_0c]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x41 
	pop {pc}
	thumb_func_end slashcrossBPwrAtk_init_8011CD6

	thumb_local_start
sub_8011CF8:
	push {lr}
	mov r0, #0x28 
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0
	cmp r0, #4
	beq loc_8011D16
	mov r1, #1
loc_8011D16:
	strb r1, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x45 
	pop {pc}
	thumb_func_end sub_8011CF8

	thumb_local_start
sub_8011D20:
	push {lr}
	mov r0, #0x46 
	mov r1, #0x1e
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x9e
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x40 
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x46 
	pop {pc}
	thumb_func_end sub_8011D20

	thumb_local_start
sub_8011D38:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x9e
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x28 
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x4a 
	pop {pc}
	thumb_func_end sub_8011D38

	thumb_local_start
sub_8011D54:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x5a 
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x10
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x1a
	pop {pc}
	thumb_func_end sub_8011D54

	thumb_local_start
sub_8011D74:
	push {lr}
	mov r0, #0xa
	mov r1, #0xa
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x10
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	ldr r0, off_8011D98 // =0x1800 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x4d 
	pop {pc}
	.balign 4, 0
off_8011D98:
	.word 0x1800
	thumb_func_end sub_8011D74

	thumb_local_start
sub_8011D9C:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x9e
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x32 
	mov r1, #0x1e
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x80
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x4c 
	pop {pc}
	thumb_func_end sub_8011D9C

	thumb_local_start
sub_8011DBC:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x9e
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x32 
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x4e 
	pop {pc}
	thumb_func_end sub_8011DBC

	thumb_local_start
sub_8011DDC:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x9e
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x46 
	mov r1, #0x1e
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x4f 
	pop {pc}
	thumb_func_end sub_8011DDC

	thumb_local_start
sub_8011DFC:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x9e
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x50 
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x10
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x50 
	pop {pc}
	thumb_func_end sub_8011DFC

	thumb_local_start
sub_8011E1C:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x9e
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x32 
	mov r1, #0xa
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #2
	strh r0, [r7,#oAIAttackVars_Unk_12]
	mov r0, #0x52 
	pop {pc}
	thumb_func_end sub_8011E1C

	thumb_local_start
sub_8011E40:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x14
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x80
	strb r0, [r7,#oAIAttackVars_Unk_02]
	bl sub_800F4A8
	cmp r0, #1
	blt loc_8011E68
	mov r0, #1
	bl sub_800F4B2
	mov r0, #0xc8
	mov r1, #6
	b loc_8011E6C
loc_8011E68:
	mov r0, #0x50 
	mov r1, #0
loc_8011E6C:
	strh r0, [r7,#oAIAttackVars_Damage]
	strb r1, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x13
	pop {pc}
	thumb_func_end sub_8011E40

	thumb_local_start
sub_8011E78:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x14
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #3
	strb r0, [r7,#oAIAttackVars_Unk_02]
	bl sub_800F4A8
	cmp r0, #1
	blt loc_8011EA0
	mov r0, #1
	bl sub_800F4B2
	mov r0, #0xc8
	ldr r1, dword_8011F34 // =0x100c02 
	b loc_8011EA4
loc_8011EA0:
	mov r0, #0x28 
	ldr r1, dword_8011F38 // =0x100501 
loc_8011EA4:
	strh r0, [r7,#oAIAttackVars_Damage]
	str r1, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x1f
	pop {pc}
	thumb_func_end sub_8011E78

	thumb_local_start
sub_8011EAC:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x14
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x64 
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r1, #8
	strb r1, [r7,#oAIAttackVars_Unk_03]
	ldr r0, off_8011F3C // =0x300 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x1c
	pop {pc}
	thumb_func_end sub_8011EAC

	thumb_local_start
sub_8011ED0:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x14
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x28 
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x32 
	pop {pc}
	thumb_func_end sub_8011ED0

	thumb_local_start
sub_8011EF0:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x14
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #3
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x64 
	strh r0, [r7,#oAIAttackVars_Damage]
	ldr r0, dword_8011F40 // =0x3c1000 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x42 
	pop {pc}
	thumb_func_end sub_8011EF0

	thumb_local_start
sub_8011F10:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x14
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x64 
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r1, #1
	strb r1, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x1c
	pop {pc}
dword_8011F34:
	.word 0x100C02
dword_8011F38:
	.word 0x100501
off_8011F3C:
	.word 0x300
dword_8011F40:
	.word 0x3C1000
	thumb_func_end sub_8011F10

	thumb_local_start
sub_8011F44:
	push {lr}
	mov r0, #0x1e
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x56 
	pop {pc}
	thumb_func_end sub_8011F44

	thumb_local_start
sub_8011F64:
	push {lr}
	mov r0, #0x32 
	mov r1, #0xa
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x10
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x57 
	pop {pc}
	thumb_func_end sub_8011F64

	thumb_local_start
sub_8011F84:
	mov r0, #0x28 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x58 
	mov pc, lr
	thumb_func_end sub_8011F84

	thumb_local_start
sub_8011F8C:
	push {lr}
	ldrb r0, [r6,#oAIData_Unk_0d]
	cmp r0, #0
	bne loc_8011F9A
	bl megamanChargeShotBPwrAtk_init_8011A26
	b locret_8011FCC
loc_8011F9A:
	sub r0, #1
	strb r0, [r6,#oAIData_Unk_0d]
	add r0, #0x6c 
	ldrb r0, [r6,r0]
	ldr r2, off_8012010 // =byte_80E98C0
	mov r1, #0xf
	and r1, r0
	lsl r1, r1, #1
	ldrh r1, [r2,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	str r0, [r7,#oAIAttackVars_Unk_30]
	mov r0, #0xc8
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r1, #2
	strb r1, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0x11
locret_8011FCC:
	pop {pc}
	thumb_func_end sub_8011F8C

	thumb_local_start
sub_8011FCE:
	push {lr}
	ldrb r0, [r6,#oAIData_Unk_0d]
	cmp r0, #0
	bne loc_8011FDC
	bl sub_8011AF2
	b locret_801200E
loc_8011FDC:
	sub r0, #1
	strb r0, [r6,#oAIData_Unk_0d]
	add r0, #0x6c 
	ldrb r0, [r6,r0]
	ldr r2, off_8012014 // =byte_80E98C0
	mov r1, #0xf
	and r1, r0
	lsl r1, r1, #1
	ldrh r1, [r2,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	str r0, [r7,#oAIAttackVars_Unk_30]
	mov r0, #0xc8
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r1, #2
	strb r1, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0x11
locret_801200E:
	pop {pc}
	.balign 4, 0
off_8012010:
	.word byte_80E98C0
off_8012014:
	.word byte_80E98C0
	thumb_func_end sub_8011FCE

	thumb_local_start
sub_8012018:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r1, #0x48 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	strh r0, [r7,#oAIAttackVars_Damage]
	ldr r0, off_8012040 // =0x114 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x28 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x2b 
	pop {pc}
	.balign 4, 0
off_8012040:
	.word 0x114
	thumb_func_end sub_8012018

	thumb_local_start
sub_8012044:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_04]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x50 
	mov r1, #0xa
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x13
	pop {pc}
	thumb_func_end sub_8012044

	thumb_local_start
sub_801206E:
	push {lr}
	mov r0, #0x48 
	bl loc_80126EA
	push {r0}
	mov r0, #0x14
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	pop {r0}
	pop {pc}
	thumb_func_end sub_801206E

	thumb_local_start
sub_801208A:
	push {lr}
	mov r0, #0x49 
	bl loc_80126EA
	push {r0}
	mov r0, #0x14
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	pop {r0}
	pop {pc}
	thumb_func_end sub_801208A

	thumb_local_start
sub_80120A6:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #3
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	strh r0, [r7,#oAIAttackVars_Damage]
	ldr r0, off_80120C8 // =0x114 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x28 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x2b 
	pop {pc}
	.balign 4, 0x00
off_80120C8:
	.word 0x114
	thumb_func_end sub_80120A6

	thumb_local_start
sub_80120CC:
	push {lr}
	mov r0, #0x2b 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80120CC

	thumb_local_start
sub_80120D6:
	push {lr}
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x50 
	mov r1, #0xa
	bl battle_beastPwrAtk_addScaledBase_8012642
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x13
	pop {pc}
	thumb_func_end sub_80120D6

	thumb_local_start
sub_80120FE:
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x32 
	strh r0, [r7,#oAIAttackVars_Damage]
	ldr r0, off_8012120 // =0x114 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x28 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x2b 
	mov pc, lr
	.byte 0, 0
off_8012120:
	.word 0x114
	thumb_func_end sub_80120FE

	thumb_local_start
sub_8012124:
	push {lr}
	mov r1, #1
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	add r0, #1
	mov r1, #5
	mul r0, r1
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x85
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #6
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_Unk_12]
	mov r0, #0x5d 
	pop {pc}
	thumb_func_end sub_8012124

	thumb_local_start
sub_8012144:
	push {lr}
	mov r1, #1
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	add r0, #1
	mov r1, #0xa
	mul r0, r1
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, #6
	lsl r0, r0, #0x18
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x38 
	pop {pc}
	thumb_func_end sub_8012144

	thumb_local_start
sub_801216E:
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #3
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	strh r0, [r7,#oAIAttackVars_Damage]
	ldr r0, off_8012190 // =0x214 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x28 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x2b 
	mov pc, lr
	.byte 0, 0
off_8012190:
	.word 0x214
	thumb_func_end sub_801216E

	thumb_local_start
sub_8012194:
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x32 
	strh r0, [r7,#oAIAttackVars_Damage]
	ldr r0, off_80121B8 // =0x114 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x28 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x2b 
	mov pc, lr
	.balign 4, 0x00
off_80121B8:
	.word 0x114
	thumb_func_end sub_8012194

	thumb_local_start
sub_80121BC:
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_03]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x32 
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x1e
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #0x46 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x5a 
	mov pc, lr
	thumb_func_end sub_80121BC

	thumb_local_start
sub_80121DC:
	push {lr}
	mov r0, #0
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x1e
	strb r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_80121DC

	thumb_local_start
sub_80121F8:
	push {lr}
	mov r0, #0xa
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_80121F8

	thumb_local_start
sub_8012210:
	push {lr}
	mov r0, #0xe
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_8012210

	thumb_local_start
sub_8012228:
	push {lr}
	mov r0, #4
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_8012228

	thumb_local_start
sub_8012240:
	push {lr}
	mov r0, #2
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #3
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_8012240

	thumb_local_start
tomahawkmanBPwrAtk_init_8012258:
	push {lr}
	mov r0, #0xc
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x1e
	strb r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x1e
	strb r0, [r7,#oAIAttackVars_Unk_0d]
	mov r0, #9
	pop {pc}
	thumb_func_end tomahawkmanBPwrAtk_init_8012258

	thumb_local_start
sub_8012278:
	push {lr}
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #6
	strb r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #6
	strb r0, [r7,#oAIAttackVars_Unk_0d]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_8012278

	thumb_local_start
sub_8012292:
	push {lr}
	mov r0, #6
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_8012292

	thumb_local_start
sub_80122AA:
	push {lr}
	mov r0, #8
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_80122AA

	thumb_local_start
sub_80122C2:
	push {lr}
	mov r0, #0x12
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_80122C2

	thumb_local_start
sub_80122DA:
	push {lr}
	mov r0, #0x10
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_beastPwrAtk_addScaledBaseFromIndex_8010D04
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #9
	pop {pc}
	thumb_func_end sub_80122DA

	thumb_local_start
sub_80122F2:
	push {lr}
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #6
	strb r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #6
	strb r0, [r7,#oAIAttackVars_Unk_0d]
	mov r0, #0xb
	pop {pc}
	thumb_func_end sub_80122F2

	thumb_local_start
sub_801230C:
	push {lr}
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #6
	strb r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #6
	strb r0, [r7,#oAIAttackVars_Unk_0d]
	mov r0, #0xc
	pop {pc}
	thumb_func_end sub_801230C

	thumb_local_start
sub_8012326:
	mov r0, #1
	b loc_801232C
loc_801232A:
	mov r0, #3
loc_801232C:
	lsl r0, r0, #8
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x1e
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x94
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x5c 
	mov pc, lr
	thumb_func_end sub_8012326

	thumb_local_start
sub_801233C:
	push {lr}
	mov r0, #3
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801233C

	thumb_local_start
sub_8012346:
	push {lr}
	ldr r0, off_80126D0 // =0x17c 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012346

	thumb_local_start
sub_8012350:
	push {lr}
	mov r0, #0x44 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012350

	thumb_local_start
sub_801235A:
	push {lr}
	mov r0, #0xa2
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801235A

	thumb_local_start
sub_8012364:
	push {lr}
	mov r0, #0x39 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012364

	thumb_local_start
sub_801236E:
	push {lr}
	mov r0, #0x1f
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801236E

	thumb_local_start
sub_8012378:
	push {lr}
	mov r0, #9
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012378

	thumb_local_start
sub_8012382:
	push {lr}
	mov r0, #0x45 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012382

	thumb_local_start
sub_801238C:
	push {lr}
	mov r0, #0x51 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801238C

	thumb_local_start
sub_8012396:
	push {lr}
	mov r0, #0xc7
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012396

	thumb_local_start
sub_80123A0:
	push {lr}
	mov r0, #0x90
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80123A0

	thumb_local_start
bubbleSpreadBPwrAtk_init_80123AA:
	push {lr}
	mov r0, #0x46 
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_03]
	ldr r0, dword_80123C4 // =0x7 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x25 
	pop {pc}
dword_80123C4:
	.word 0x7
	thumb_func_end bubbleSpreadBPwrAtk_init_80123AA

	thumb_local_start
sub_80123C8:
	push {lr}
	mov r0, #0x77 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80123C8

	thumb_local_start
sub_80123D2:
	push {lr}
	mov r0, #1
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80123D2

	thumb_local_start
sub_80123DC:
	push {lr}
	mov r0, #0x40 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80123DC

	thumb_local_start
sub_80123E6:
	push {lr}
	mov r0, #0x65 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80123E6

	thumb_local_start
sub_80123F0:
	push {lr}
	mov r0, #0x4e 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80123F0

	thumb_local_start
sub_80123FA:
	push {lr}
	mov r0, #0xca
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80123FA

	thumb_local_start
sub_8012404:
	push {lr}
	mov r0, #7
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012404

	thumb_local_start
sub_801240E:
	push {lr}
	mov r0, #0x96
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801240E

	thumb_local_start
sub_8012418:
	push {lr}
	mov r0, #0x4f 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012418

	thumb_local_start
sub_8012422:
	push {lr}
	mov r0, #0x50 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012422

	thumb_local_start
sub_801242C:
	push {lr}
	mov r0, #0xa4
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801242C

	thumb_local_start
sub_8012436:
	push {lr}
	mov r0, #8
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012436

	thumb_local_start
sub_8012440:
	push {lr}
	mov r0, #0xf
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012440

	thumb_local_start
sub_801244A:
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x8a
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	ldr r0, dword_80126D4 // =0x33c00 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x5e 
	mov pc, lr
	thumb_func_end sub_801244A

	thumb_local_start
sub_801245A:
	push {lr}
	ldr r0, off_80126D8 // =0x17d 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801245A

	thumb_local_start
sub_8012464:
	push {lr}
	ldr r0, dword_80126DC // =0x17e 
	bl battleObject_stealChipFromEnemyNavi_8010740
	tst r0, r0
	beq loc_8012478
	bl object_exitAttackState
	mov r0, #8
	b locret_8012482
loc_8012478:
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0x78 
	strb r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x1c
locret_8012482:
	pop {pc}
	thumb_func_end sub_8012464

	thumb_local_start
sub_8012484:
	push {lr}
	mov r0, #0x49 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012484

	thumb_local_start
sub_801248E:
	push {lr}
	mov r0, #0x1e
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801248E

	thumb_local_start
sub_8012498:
	push {lr}
	mov r0, #0x28 
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_03]
	ldr r0, dword_80124B4 // =0x8 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x25 
	pop {pc}
	.balign 4, 0x00
dword_80124B4:
	.word 0x8
	thumb_func_end sub_8012498

	thumb_local_start
sub_80124B8:
	push {lr}
	mov r0, #0x13
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80124B8

	thumb_local_start
sub_80124C2:
	push {lr}
	mov r0, #0x83
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80124C2

	thumb_local_start
sub_80124CC:
	push {lr}
	mov r0, #0x14
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80124CC

	thumb_local_start
sub_80124D6:
	push {lr}
	mov r0, #0x22 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80124D6

	thumb_local_start
sub_80124E0:
	push {lr}
	mov r0, #0x48 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80124E0

	thumb_local_start
sub_80124EA:
	push {lr}
	mov r0, #0x36 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80124EA

	thumb_local_start
sub_80124F4:
	push {lr}
	mov r0, #0x34 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_80124F4

	thumb_local_start
sub_80124FE:
	push {lr}
	mov r0, #0x32 
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_03]
	ldr r0, dword_8012518 // =0x4 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #2
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0x25 
	pop {pc}
dword_8012518:
	.word 0x4
	thumb_func_end sub_80124FE

	thumb_local_start
sub_801251C:
	push {lr}
	mov r0, #0x59 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801251C

	thumb_local_start
sub_8012526:
	mov r0, #9
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0x78 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0x1c
	mov pc, lr
	thumb_func_end sub_8012526

	thumb_local_start
sub_8012536:
	push {lr}
	mov r0, #0x8e
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012536

	thumb_local_start
sub_8012540:
	push {lr}
	mov r0, #0x33 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012540

	thumb_local_start
sub_801254A:
	mov r0, #0x14
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0x1c
	mov pc, lr
	thumb_func_end sub_801254A

	thumb_local_start
sub_8012552:
	push {lr}
	mov r0, #0x3c 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012552

	thumb_local_start
sub_801255C:
	push {lr}
	mov r0, #0x25 
	bl loc_80126EA
	mov r1, #0x28 
	strb r1, [r7,#oAIAttackVars_Unk_05]
	mov r1, #3
	strb r1, [r7,#oAIAttackVars_Unk_1c]
	mov r1, #1
	strb r1, [r7,#oAIAttackVars_Unk_0d]
	pop {pc}
	thumb_func_end sub_801255C

	thumb_local_start
sub_8012572:
	push {lr}
	mov r0, #0x56 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012572

	thumb_local_start
sub_801257C:
	push {lr}
	ldr r0, off_80126E0 // =0x11e
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801257C

	thumb_local_start
sub_8012586:
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	mov r0, #0x32 
	strh r0, [r7,#oAIAttackVars_Damage]
	ldr r0, off_80125A8 // =0x114 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x28 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x2b 
	mov pc, lr
off_80125A8:
	.word 0x114
	thumb_func_end sub_8012586

	thumb_local_start
sub_80125AC:
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #3
	strb r0, [r7,#oAIAttackVars_Unk_03]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	strh r0, [r7,#oAIAttackVars_Damage]
	ldr r0, off_80125CC // =0x214 
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x28 
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0x2b 
	mov pc, lr
off_80125CC:
	.word 0x214
	thumb_func_end sub_80125AC

	thumb_local_start
sub_80125D0:
	push {lr}
	mov r1, #1
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	add r0, #1
	mov r1, #0xa
	mul r0, r1
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_02]
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_03]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	strh r0, [r7,#oAIAttackVars_Unk_0a]
	strb r0, [r7,#oAIAttackVars_Unk_05]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_0c]
	mov r1, #0x4f 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #6
	tst r0, r0
	beq loc_8012602
	mov r1, r0
loc_8012602:
	str r1, [r7,#oAIAttackVars_Unk_0c]
	mov r0, #0x16
	pop {pc}
	thumb_func_end sub_80125D0

	thumb_local_start
sub_8012608:
	push {lr}
	mov r0, #0x47 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012608

	thumb_local_start
sub_8012612:
	push {lr}
	bl megamanChargeShotBPwrAtk_init_8011A26
	mov r1, #1
	strb r1, [r7,#oAIAttackVars_Unk_03]
	pop {pc}
	thumb_func_end sub_8012612

	thumb_local_start
sub_801261E:
	push {lr}
	mov r0, #0x74 
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_801261E

	thumb_local_start
sub_8012628:
	push {lr}
	mov r0, #0x17
	bl loc_80126EA
	pop {pc}
	thumb_func_end sub_8012628

	thumb_local_start
sub_8012632:
	push {lr}
	bl sub_8012124
	pop {pc}
	thumb_func_end sub_8012632

	thumb_local_start
sub_801263A:
	push {lr}
	bl sub_8012144
	pop {pc}
	thumb_func_end sub_801263A

// symdb: Battle helper: add (baseDamage * beastOutMulti) to running total, with the multiplier clamped to 5.
// symdb: (r0 = currentDamageTotal, r1 = baseDamage) -> r0 = currentDamageTotal + baseDamage *
// symdb: clamp(beastDamageCap, 0, 5) ; r1 unchanged
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_beastPwrAtk_addScaledBase_8012642.yaml
	thumb_local_start
battle_beastPwrAtk_addScaledBase_8012642:
	push {lr}
	push {r0,r1}
	bl computeBeastDamageCap_801265A
	mov r2, r0
	cmp r2, #5
	ble loc_8012652
	mov r2, #5
loc_8012652:
	pop {r0,r1}
	mul r1, r2
	add r0, r0, r1
	pop {pc}
	thumb_func_end battle_beastPwrAtk_addScaledBase_8012642

// symdb: Battle damage cap used while the player navi is beast-out / transformed; returns 1 in beast-out, otherwise alliance + navi bonus + transformation bonus, clamped to 0xa.
// symdb: u32 computeBeastDamageCap_801265A(u32 battle_object /* r5 */); /* clobbers r0-r3, r6, lr;
// symdb: preserves r4-r5; flags clobbered */
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/computeBeastDamageCap_801265A.yaml
	thumb_func_start computeBeastDamageCap_801265A
computeBeastDamageCap_801265A:
	push {lr}
	mov r1, #oNaviStats_NaviIndex
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	push {r0}
	mov r1, #1
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	ldr r2, off_801269C // =byte_80126A4
	ldrb r1, [r2,r1]
	add r0, r0, r1
	push {r0}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	cmp r0, #5
	bne loc_8012684
	pop {r0}
	mov r0, #1
	b loc_8012692
loc_8012684:
	mov r1, #oNaviStats_Transformation 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r1, off_80126A0 // =off_80126B0 
	ldrb r1, [r1,r0]
	pop {r0}
	add r0, r0, r1
loc_8012692:
	cmp r0, #0xa
	ble locret_8012698
	mov r0, #0xa
locret_8012698:
	pop {pc}
	.balign 4, 0
off_801269C:
	.word byte_80126A4
off_80126A0:
	.word off_80126B0
byte_80126A4:
	.byte 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1
off_80126B0:
	.word 0x100
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
off_80126D0:
	.word 0x17C
dword_80126D4:
	.word 0x33C00
off_80126D8:
	.word 0x17D
dword_80126DC:
	.word 0x17E
off_80126E0:
	.word 0x11E
	thumb_func_end computeBeastDamageCap_801265A

	thumb_func_start somethingWriteChipParams_80126E4
somethingWriteChipParams_80126E4:
	push {r4,r6,r7,lr}
	mov r4, #1
	b loc_80126F6
loc_80126EA:
	push {r4,r6,r7,lr}
	mov r4, #0
	b loc_80126F6
	push {r4,r6,r7,lr}
	ldr r7, [r5,#0x58]
	add r7, #0xa0
loc_80126F6:
	strh r0, [r7,#oAIAttackVars_Unk_14]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r6, r0
	ldr r1, [r6,#0x10]
	str r1, [r7,#oAIAttackVars_Unk_0c]
	ldrh r0, [r7,#oAIAttackVars_Unk_14]
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl battle_chipEffectDispatcher_80109A4
	ldrb r1, [r6,#0xa]
	lsl r1, r1, #0x10
	add r1, r1, r0
	str r1, [r7,#oAIAttackVars_Damage]
	ldrb r1, [r6,#0x14] // chip use delay?
	strb r1, [r7,#oAIAttackVars_Unk_05]
	mov r1, #0
	strh r1, [r7,#oAIAttackVars_AttackBoost]
	ldrb r1, [r6,#0xc]
	strb r1, [r7,#oAIAttackVars_Unk_03]
	ldrb r1, [r6,#4]
	ldrb r2, [r6,#6]
	ldr r0, off_80129E0 // =byte_80129E4
	ldrb r0, [r0,r2]
	orr r1, r0
	strb r1, [r7,#oAIAttackVars_Unk_02]
	mov r1, #0
	strb r1, [r7,#oAIAttackVars_Unk_04]
	tst r4, r4
	beq loc_801273A
	ldrb r0, [r5,#oBattleObject_Alliance]
	ldrh r1, [r7,#oAIAttackVars_Unk_14]
	bl incrementRecordCounterByte_8021D14
loc_801273A:
	ldrb r0, [r6,#0xb]
	pop {r4,r6,r7,pc}
	thumb_func_end somethingWriteChipParams_80126E4

	thumb_local_start
sub_801273E:
	push {r4,r6,r7,lr}
	ldrb r0, [r5,#0x16]
	push {r0}
	bl object_getAllianceDirection
	mov r6, r0
	pop {r0}
	lsl r1, r0, #3
	ldr r7, off_8012778 // =byte_8012780
	add r7, r7, r1
	ldr r2, [r7]
	ldr r3, [r7,#4]
	ldr r7, off_801277C // =word_8012790 
	ldrb r0, [r7,r0]
loc_801275A:
	mov r1, #3
loc_801275C:
	push {r0-r3,r6}
	bl object_checkPanelParameters
	tst r0, r0
	pop {r0-r3,r6}
	bne locret_8012776
	sub r1, #1
	bne loc_801275C
	add r0, r0, r6
	sub r4, r0, #1
	cmp r4, #6
	bls loc_801275A
	mov r0, #0
locret_8012776:
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8012778:
	.word byte_8012780
off_801277C:
	.word word_8012790
byte_8012780:
	.byte 0x0, 0x0, 0x20, 0x0, 0x20, 0x0, 0x0, 0x0, 0x20, 0x0, 0x40, 0x0, 0x0
	.byte 0x0, 0x0, 0x0
word_8012790:
	.hword 0x601
	thumb_func_end sub_801273E

	thumb_func_start sub_8012792
sub_8012792:
	push {r4,r6,r7,lr}
	mov r4, r1
	mov r6, r2
	mov r7, r3
loc_801279A:
	sub r0, #4
	bmi loc_80127BC
	sub r7, #1
	ldr r2, [r6,r0]
	ldrb r1, [r7]
	ldrh r3, [r2,r1]
	tst r3, r3
	beq loc_80127B8
	cmp r4, r3
	bne loc_801279A
	add r1, #2
	strb r1, [r7]
	ldr r3, [r2,r1]
	tst r3, r3
	bne loc_801279A
loc_80127B8:
	lsr r0, r0, #2
	pop {r4,r6,r7,pc}
loc_80127BC:
	mov r0, #0xff
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8012792

	thumb_local_start
useChipRelated_80127C0: // called when you use a chip
	push {r4,r6,r7,lr}
	sub sp, sp, #0x1c
	str r0, [sp]
	bl GetAIData_Unk_44_Flag
	ldr r1, dword_80128F4 // =0x10000 
	tst r1, r4
	bne loc_80127DA
	mov r0, r5
	ldr r1, [sp]
	bl getBattleObjectStateInfo_800EDD0
	b loc_80127E4
loc_80127DA:
	mov r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_1b]
	mov r0, r5
	bl sub_800EE26
loc_80127E4:
	str r0, [sp,#4]
	str r1, [sp,#8]
	str r2, [sp,#0xc]
	str r3, [sp,#0x10]
	mov r6, #0xff
	and r6, r4
	str r6, [sp,#0x14]
	lsr r4, r4, #8
	str r4, [sp,#0x18]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r4, r0
	ldrb r0, [r4,#0x1f]
	bl dispatchHandlerById_8010D58
	ldr r3, dword_80128F8 // =0xffff 
	cmp r0, r3
	beq loc_8012822
	str r0, [sp,#4]
	str r1, [sp,#8]
	str r2, [sp,#0xc]
	mov r3, #0
	str r3, [sp,#0x10]
	mov r6, #0xff
	and r6, r4
	str r6, [sp,#0x14]
	lsr r4, r4, #8
	str r4, [sp,#0x18]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r4, r0
loc_8012822:
	ldr r0, [sp,#4]
	strh r0, [r7,#oAIAttackVars_Unk_14]
	bl somethingWriteChipParams_80126E4
	ldr r0, [sp]
	strb r0, [r7,#oAIAttackVars_Unk_04]
	ldr r0, [sp,#8]
	strh r0, [r7,#oAIAttackVars_Damage]
	ldr r0, [sp]
	bl battle_getNaviTypeFamilyConstant_8012C7C
	tst r0, r0
	beq loc_801284E
	ldrh r1, [r7,#oAIAttackVars_Damage]
	cmp r0, #0xff
	bne loc_8012844
	mov r0, r1
loc_8012844:
	add r1, r1, r0
	strh r1, [r7,#oAIAttackVars_Damage]
	mov r0, #SOUND_HIT_87
	bl PlaySoundEffect
loc_801284E:
	ldr r0, [sp,#0xc]
	strh r0, [r7,#oAIAttackVars_AttackBoost]
	mov r0, r5
	ldrh r1, [r7,#oAIAttackVars_Unk_14]
	ldrh r2, [r7,#oAIAttackVars_Damage]
	ldr r3, [sp]
	bl battle_aiClassifyChipCategory_8012A38
	strh r0, [r7,#oAIAttackVars_Damage]
	tst r1, r1
	beq loc_8012880
	cmp r1, #1
	bne loc_8012872
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x80
	bl battle_setPlayerNaviStatsField0E_8015BEC
	b loc_801287A
loc_8012872:
	cmp r1, #2
	bne loc_8012880
	bl battleObject_markUsedAction_80143A6
loc_801287A:
	mov r0, #SOUND_HIT_87
	bl PlaySoundEffect
loc_8012880:
	ldrh r0, [r7,#oAIAttackVars_Damage]
	ldr r1, [sp,#0x14]
	bl sub_8012C34
	strh r0, [r7,#oAIAttackVars_Damage]
	ldrh r0, [r7,#oAIAttackVars_Unk_14]
	ldrh r1, [r7,#oAIAttackVars_Damage]
	bl battle_orChipCrossNaviFlag_8012C4A
	strh r0, [r7,#oAIAttackVars_Damage]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #6
	beq loc_80128A2
	cmp r0, #0x12
	bne loc_80128C0
loc_80128A2:
	// spoutcross chip heal?
	ldrb r0, [r4,#4]
	cmp r0, #2
	bne loc_80128C0
	ldrb r0, [r4,#9]
	mov r1, #1
	tst r0, r1
	bne loc_80128C0
	mov r1, #0x3e 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	add r0, #0x13
	mov r1, #0x14
	svc 6
	mov r2, r0
	b loc_80128C2
loc_80128C0:
	mov r2, #0
loc_80128C2:
	push {r2}
	mov r1, #0x50 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	pop {r2}
	add r0, r0, r2
	beq loc_80128D6
	mov r1, #0
	bl battleObject_applyHPAndHandleSpecial_800E2FC
loc_80128D6:
	ldrb r0, [r4,#9]
	mov r1, #4
	tst r0, r1
	beq loc_80128E8
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #6
	mov r2, #1
	bl tableAddSaturatedByte_800AB46
loc_80128E8:
	ldrh r0, [r7,#oAIAttackVars_Unk_14]
	bl sub_800B79A
	ldrb r0, [r4,#0xb]
	add sp, sp, #0x1c
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_80128F4:
	.word 0x10000
dword_80128F8:
	.word 0xFFFF
	thumb_func_end useChipRelated_80127C0

	thumb_local_start
sub_80128FC:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r1, [sp]
	mov r4, r0
	ldrb r6, [r5,#0x12]
	ldrb r7, [r5,#0x13]
	mov r0, r6
	mov r1, r7
	bl object_getPanelDataOffset
	tst r0, r0
	beq loc_8012950
	ldrb r1, [r0,#2]
	cmp r1, #6
	bne loc_8012998
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #7
	beq loc_8012928
	cmp r0, #0x13
	bne loc_8012998
loc_8012928:
	ldr r0, [sp]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_8012998
	mov r2, #1
	tst r1, r2
	bne loc_8012998
	ldrb r1, [r0,#6]
	cmp r1, #3
	bne loc_8012998
	mov r0, r6
	mov r1, r7
	mov r2, #2
	bl object_setPanelType
	mov r0, #1
	b loc_8012952
loc_8012950:
	mov r0, #0
loc_8012952:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	thumb_func_end sub_80128FC

	thumb_func_start sub_8012956
sub_8012956:
	ldrb r3, [r0]
	tst r3, r3
	bne loc_8012998
	ldrb r3, [r0,#2]
	add r3, #1
	strb r3, [r0,#2]
	cmp r3, #0xc
	ble loc_801296C
	mov r3, #1
	strb r3, [r0]
	b loc_8012998
loc_801296C:
	ldrb r3, [r0,#1]
	add r2, r3, r3
	add r3, #1
	cmp r3, #3
	blt loc_8012978
	mov r3, #0
loc_8012978:
	strb r3, [r0,#1]
	add r2, #4
	strh r1, [r0,r2]
	ldrh r1, [r0,#4]
	ldrh r2, [r0,#6]
	orr r1, r2
	ldrh r2, [r0,#8]
	orr r1, r2
	mov r2, #0x22 
	and r1, r2
	cmp r1, #0x22 
	bne loc_8012998
	mov r3, #1
	strb r3, [r0]
	mov r0, #1
	mov pc, lr
loc_8012998:
	mov r0, #0
	mov pc, lr
	thumb_func_end sub_8012956

	thumb_func_start sub_801299C
sub_801299C:
	push {lr}
	// size
	mov r1, #0x10
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end sub_801299C

	thumb_local_start
sub_80129A6:
	push {r7,lr}
	strh r0, [r7,#0x14]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldr r1, [r0,#0x10]
	str r1, [r7,#0xc]
	ldrb r1, [r0,#0xa]
	lsl r1, r1, #0x10
	ldrh r2, [r0,#0x1a]
	add r1, r1, r2
	str r1, [r7,#8]
	ldrb r1, [r0,#0x14]
	strb r1, [r7,#5]
	mov r1, #0
	strh r1, [r7,#6]
	ldrb r1, [r0,#0xc]
	strb r1, [r7,#3]
	ldrb r1, [r0,#4]
	ldrb r2, [r0,#6]
	ldr r3, off_80129E0 // =byte_80129E4
	ldrb r2, [r3,r2]
	orr r1, r2
	strb r1, [r7,#2]
	ldrb r0, [r0,#0xb]
	pop {r7,pc}
	.word 0
	.byte 0, 0, 0, 0
	.balign 4, 0
off_80129E0:
	.word byte_80129E4
byte_80129E4:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x80, 0x40, 0x0, 0x20, 0x10, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0
	thumb_func_end sub_80129A6

	thumb_local_start
sub_80129F4:
	push {r7,lr}
	sub sp, sp, #0x18
	ldrb r0, [r5,#0x16]
	lsl r0, r0, #3
	ldr r1, off_8012A24 // =off_8012A28 
	add r1, r1, r0
	ldr r2, [r1]
	ldr r3, [r1,#4]
	add r7, sp, #0
	bl object_getPanelsFiltered
	mov r7, r0
	beq loc_8012A20
	bl GetPositiveSignedRNG
	mov r1, r7
	svc 6
	add r0, sp, #0
	ldrb r0, [r0,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
loc_8012A20:
	add sp, sp, #0x18
	pop {r7,pc}
	.balign 4, 0
off_8012A24:
	.word off_8012A28
off_8012A28:
	.word 0x30
	.word 0xF880080, 0x10, 0xF8800A0
	thumb_func_end sub_80129F4

// symdb: Classifies the navi's selected chip into one of a small set of AI categories (emotion=Beast/Transform, power-attack armed, HP-full-restore, AI power-attack, dark/invis special chip) and OR-s 0x8000 into the caller's chip-bits word.
// symdb: (r0 = *BattleObject, r1 = chipIdx, r2 = chipBitsInOut, r3 = someCtxOrBits, r10 = *Toolkit) -> r0
// symdb: = chipBitsOut (with 0x8000 OR'd if any category matched), r1 = categoryClass {0,1,2,4,6} ; side
// symdb: effects: r2..r7 trashed, NZCV clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_aiClassifyChipCategory_8012A38.yaml
	thumb_local_start
battle_aiClassifyChipCategory_8012A38:
	push {r4-r7,lr}
	sub sp, sp, #0xc
	mov r5, r0
	str r1, [sp]
	str r2, [sp,#4]
	str r3, [sp,#8]
	mov r6, #0
	// idx
	mov r0, r1
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r4, r0
	ldrb r1, [r4,#9]
	mov r2, #2
	tst r1, r2
	beq loc_8012AB4
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	cmp r0, #2
	bne loc_8012A64
	mov r6, #1
	b loc_8012AAC
loc_8012A64:
	cmp r0, #3
	bne loc_8012A6C
	mov r6, #2
	b loc_8012AAC
loc_8012A6C:
	ldr r0, [sp]
	ldr r1, [sp,#8]
	bl sub_8012AFA
	tst r0, r0
	beq loc_8012A7C
	mov r6, #4
	b loc_8012AAC
loc_8012A7C:
	ldr r0, [sp]
	ldr r1, [sp,#8]
	bl battle_chipMatchesHpFullRestoreAiBranch_8012B4E
	tst r0, r0
	beq loc_8012A8C
	mov r6, #6
	b loc_8012AAC
loc_8012A8C:
	ldr r0, [sp]
	ldr r1, [sp,#8]
	bl ai_decidePowerAttack_8012BA2
	tst r0, r0
	beq loc_8012A9C
	mov r6, #6
	b loc_8012AAC
loc_8012A9C:
	ldr r0, [sp]
	bl battle_isChipSpecialDarkInvisQualifying_8012ABC
	tst r0, r0
	beq loc_8012AAA
	mov r6, #4
	b loc_8012AAC
loc_8012AAA:
	b loc_8012AB4
loc_8012AAC:
	ldr r0, [sp,#4]
	ldr r1, dword_8012DE4 // =0x8000 
	orr r0, r1
	str r0, [sp,#4]
loc_8012AB4:
	ldr r0, [sp,#4]
	mov r1, r6
	add sp, sp, #0xc
	pop {r4-r7,pc}
	thumb_func_end battle_aiClassifyChipCategory_8012A38

// symdb: Checks whether a battle object's current chip qualifies for some special chip-related condition and returns 1 or 0.
// symdb: bool sub_8012ABC(void* battleObject) — r0 in is the battle object; r0 out is 1 when qualified, 0
// symdb: otherwise; r2 is scratch-clobbered (2 on early bail, 1 after flag tests); r6 and r7 preserved.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_isChipSpecialDarkInvisQualifying_8012ABC.yaml
	thumb_local_start
battle_isChipSpecialDarkInvisQualifying_8012ABC:
	push {r6,r7,lr}
	mov r7, #0
	mov r6, r0
	bl GetBattleMode
	cmp r0, #1
	beq loc_8012AF6
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0x17
	blt loc_8012AF6
	cmp r0, #0x18
	bgt loc_8012AF6
	mov r7, #0
	// idx
	mov r0, r6
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_8012AF6
	mov r2, #1
	tst r1, r2
	bne loc_8012AF6
	ldrb r1, [r0,#6]
	cmp r1, #0xa
	bne loc_8012AF6
	mov r7, #1
loc_8012AF6:
	mov r0, r7
	pop {r6,r7,pc}
	thumb_func_end battle_isChipSpecialDarkInvisQualifying_8012ABC

// symdb: Tests whether the battle object's current chip is a qualifying power-attack chip with its trigger armed (special navi/form only, chip kind 4 with the right trait bits, plus an AI-state/button check unless force-armed).
// symdb: u8 sub_8012AFA(u32 battleObject, u8 forceArmed, u32 ownerObject) -> u8; r0/r1/r5 in, r0 out, r2
// symdb: clobbered by tst-mask writes, r6/r7 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8012AFA.yaml
	thumb_local_start
sub_8012AFA:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, #0
	mov r4, r1
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #7
	beq loc_8012B1A
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #7
	beq loc_8012B1A
	cmp r0, #0x13
	bne loc_8012B4A
loc_8012B1A:
	mov r7, #0
	// idx
	mov r0, r6
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_8012B4A
	mov r2, #1
	tst r1, r2
	bne loc_8012B4A
	ldrb r1, [r0,#4]
	cmp r1, #4
	bne loc_8012B4A
	cmp r4, #0
	bne loc_8012B48
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r1,#oAIData_PwrAtkState]
	cmp r0, #2
	bne loc_8012B4A
	ldrb r0, [r1,#oAIData_PwrAtkButton]
	cmp r0, #1
	bne loc_8012B4A
loc_8012B48:
	mov r7, #1
loc_8012B4A:
	mov r0, r7
	pop {r6,r7,pc}
	thumb_func_end sub_8012AFA

// symdb: Chip-selection AI predicate: returns true (r0=1) only for the "HP full restore" branch when the ali
// symdb: u32 battle_chipMatchesHpFullRestoreAiBranch_8012B4E(u32 chip_id /*r0*/, u32 forceMatch /*r1*/,
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_chipMatchesHpFullRestoreAiBranch_8012B4E.yaml
	thumb_local_start
battle_chipMatchesHpFullRestoreAiBranch_8012B4E:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, #0
	mov r4, r1
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #6
	beq loc_8012B6E
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #6
	beq loc_8012B6E
	cmp r0, #0x12
	bne loc_8012B9E
loc_8012B6E:
	mov r7, #0
	// idx
	mov r0, r6
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_8012B9E
	mov r2, #1
	tst r1, r2
	bne loc_8012B9E
	ldrb r1, [r0,#4]
	cmp r1, #2
	bne loc_8012B9E
	cmp r4, #0
	bne loc_8012B9C
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r1,#oAIData_PwrAtkState]
	cmp r0, #2
	bne loc_8012B9E
	ldrb r0, [r1,#oAIData_PwrAtkButton]
	cmp r0, #1
	bne loc_8012B9E
loc_8012B9C:
	mov r7, #1
loc_8012B9E:
	mov r0, r7
	pop {r6,r7,pc}
	thumb_func_end battle_chipMatchesHpFullRestoreAiBranch_8012B4E

// symdb: AI decision helper that returns whether the AI Navi should perform a PowerAttack this turn, gated by alliance=0xB, a selected chip with element type 5 (Break) and specific chip flags, and only when the AI's PowerAttack state/button indicate a button-1 press while r4=0.
// symdb: u32 sub_8012BA2(u32 navi /*r0*/, u32 r4_arg /*r1*/, u32 ai_obj /*r5*/, u32 chip_idx /*r6*/);
// symdb: flags NZ set from result
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ai_decidePowerAttack_8012BA2.yaml
	thumb_local_start
ai_decidePowerAttack_8012BA2:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, #0
	mov r4, r1
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xb
	bne loc_8012BE4
	mov r7, #0
	// idx
	mov r0, r6
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_8012BE4
	mov r2, #1
	tst r1, r2
	bne loc_8012BE4
	ldrb r1, [r0,#6]
	cmp r1, #5
	bne loc_8012BE4
	cmp r4, #0
	bne loc_8012BE2
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r1,#oAIData_PwrAtkState]
	cmp r0, #2
	bne loc_8012BE4
	ldrb r0, [r1,#oAIData_PwrAtkButton]
	cmp r0, #1
	bne loc_8012BE4
loc_8012BE2:
	mov r7, #1
loc_8012BE4:
	mov r0, r7
	pop {r6,r7,pc}
	thumb_func_end ai_decidePowerAttack_8012BA2

	thumb_local_start
sub_8012BE8:
	push {r6,r7,lr}
	mov r7, #0
	mov r6, r0
	mov r4, r1
	bl GetBattleMode
	cmp r0, #1
	beq loc_8012C30
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xb
	blt loc_8012C30
	cmp r0, #0x16
	bgt loc_8012C30
	mov r7, #0
	mov r0, r6
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_8012C30
	mov r2, #1
	tst r1, r2
	bne loc_8012C30
	ldrb r1, [r0,#6]
	cmp r1, #0xa
	bne loc_8012C30
	cmp r4, #0
	bne loc_8012C2E
	ldr r0, [r5,#0x58]
	ldrb r0, [r0,#0x1d]
	cmp r0, #2
	bne loc_8012C30
loc_8012C2E:
	mov r7, #1
loc_8012C30:
	mov r0, r7
	pop {r6,r7,pc}
	thumb_func_end sub_8012BE8

// symdb: Merge two flag bits (0x4000 and 0x2000) into a value, selected by bits 2 and 4 of a mask argument
// symdb: u32 sub_8012C34(u32 value /*r0*/, u32 selectorBits /*r1*/); returns value | 0x4000 (if
// symdb: selectorBits&2) | 0x2000 (if selectorBits&4); r3 trashed (=4)
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8012C34.yaml
	thumb_local_start
sub_8012C34:
	ldr r2, dword_8012DE8 // =0x4000 
	mov r3, #2
	tst r1, r3
	beq loc_8012C3E
	orr r0, r2
loc_8012C3E:
	ldr r2, off_8012DEC // =0x2000 
	mov r3, #4
	tst r1, r3
	beq locret_8012C48
	orr r0, r2
locret_8012C48:
	mov pc, lr
	thumb_func_end sub_8012C34

// symdb: Looks up the chip in a given slot and, when it is a particular navi/cross-type chip whose battle navi's stats byte 0x2C reads 4 or 0x10, ORs the 0x1000 bit into the caller's flags word.
// symdb: u32 sub_8012C4A(u32 chipSlot, u32 flagsWord) -> u32 flagsWord (r0 in: chip slot index, r1 in:
// symdb: flags word, r0 out: flags word with possible 0x1000 bit added; r2 is scratch left holding 1 or
// symdb: 2; r1/lr clobbered, r4/r5/r6 preserved, nzcv clobbered)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_orChipCrossNaviFlag_8012C4A.yaml
	thumb_local_start
battle_orChipCrossNaviFlag_8012C4A:
	push {r4,lr}
	mov r4, r1
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_8012C78
	mov r2, #1
	tst r1, r2
	bne loc_8012C78
	ldrb r1, [r0,#6]
	cmp r1, #0xa
	bne loc_8012C78
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #4
	beq loc_8012C74
	cmp r0, #0x10
	bne loc_8012C78
loc_8012C74:
	ldr r0, off_8012DF0 // =0x1000 
	orr r4, r0
loc_8012C78:
	mov r0, r4
	pop {r4,pc}
	thumb_func_end battle_orChipCrossNaviFlag_8012C4A

// symdb: Reads a battle object's navi-type byte (alliance stats offset 0x2C) and maps the two navi-type families {2,0x0E} and {3,0x0F} to the constants 0x4000 and 0x28, returning 0 for anything else (or if the object pointer is null).
// symdb: u32 battle_getNaviTypeFamilyConstant_8012C7C(BattleObject* obj /* r0 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getNaviTypeFamilyConstant_8012C7C.yaml
	thumb_local_start
battle_getNaviTypeFamilyConstant_8012C7C:
	push {r4,lr}
	mov r4, r0
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #2
	beq loc_8012C8E
	cmp r0, #0xe
	bne loc_8012C94
loc_8012C8E:
	tst r4, r4
	bne loc_8012CAA
	b loc_8012CA2
loc_8012C94:
	cmp r0, #3
	beq loc_8012C9C
	cmp r0, #0xf
	bne loc_8012CA2
loc_8012C9C:
	tst r4, r4
	bne loc_8012CAE
	b loc_8012CA2
loc_8012CA2:
	mov r0, #0
	pop {r4,pc}
	mov r0, #0xff
	pop {r4,pc}
loc_8012CAA:
	ldr r0, dword_8012DE8 // =0x4000 
	pop {r4,pc}
loc_8012CAE:
	mov r0, #0x28 
	pop {r4,pc}
	thumb_func_end battle_getNaviTypeFamilyConstant_8012C7C

	thumb_local_start
sub_8012CB2:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x14
	mov r6, sp
	ldrb r3, [r5,#oBattleObject_Alliance]
	mov r2, #1
	eor r3, r2
	mov r1, #0
	mov r2, #0xba
	mov r0, r6
	bl object_getEnemyByNameRange
	mov r4, r0
	lsl r0, r0, #2
	add r0, r0, r6
	ldrb r3, [r5,#oBattleObject_Alliance]
	mov r2, #1
	eor r3, r2
	ldr r1, off_8012DF4 // =0x100 
	ldr r2, dword_8012DF8 // =0x1c3 
	bl object_getEnemyByNameRange
	add r4, r4, r0
	beq loc_8012D20
	mov r0, #0x10
	add r0, r0, r6
	bl sub_8012D24
	add r6, #0x10
	mov r4, #3
loc_8012CEC:
	push {r6,r7}
	ldrb r0, [r6]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	mov r2, #0x10
	push {r0-r3}
	mov r0, #0x1e
	mov r1, #0x14
	bl battle_beastPwrAtk_addScaledBase_8012642
	mov r6, #0x8a
	lsl r6, r6, #0x10
	orr r6, r0
	pop {r0-r3}
	mov r7, #0
	bl sub_80C7F20
	pop {r6,r7}
	add r6, #1
	sub r4, #1
	bne loc_8012CEC
	mov r0, #2
	mov r1, #0x14
	bl camera_initShakeEffect_80302a8
loc_8012D20:
	add sp, sp, #0x14
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8012CB2

	thumb_local_start
sub_8012D24:
	push {r4-r7,lr}
	mov r7, r0
	mov r0, #0
	str r0, [r7]
	mov r3, r4
loc_8012D2E:
	ldr r2, [r6]
	ldrb r0, [r2,#oBattleObject_PanelX]
	ldrb r1, [r2,#oBattleObject_PanelY]
	lsl r1, r1, #4
	orr r0, r1
	strb r0, [r7]
	add r7, #1
	add r6, #4
	sub r3, #1
	bne loc_8012D2E
	cmp r4, #3
	beq loc_8012D5C
	cmp r4, #2
	beq loc_8012D54
	sub r7, #1
	ldrb r0, [r7]
	strb r0, [r7,#1]
	strb r0, [r7,#2]
	b loc_8012D5E
loc_8012D54:
	sub r7, #2
	ldrb r0, [r7,#1]
	strb r0, [r7,#2]
	b loc_8012D5E
loc_8012D5C:
	sub r7, #3
loc_8012D5E:
	bl sub_8012D70
	pop {r4-r7,pc}
	thumb_func_end sub_8012D24

	thumb_local_start
sub_8012D64:
	push {lr}
	mov r0, #0
	mov r1, #1
	bl sub_8012D8C
	pop {pc}
	thumb_func_end sub_8012D64

	thumb_local_start
sub_8012D70:
	push {lr}
	mov r0, #0
	mov r1, #1
	bl sub_8012D8C
	mov r0, #0
	mov r1, #2
	bl sub_8012D8C
	mov r0, #1
	mov r1, #2
	bl sub_8012D8C
	pop {pc}
	thumb_func_end sub_8012D70

	thumb_local_start
sub_8012D8C:
	push {r4,r6,lr}
	mov r4, r0
	mov r6, r1
	ldrb r0, [r7,r4]
	ldrb r1, [r7,r6]
	cmp r0, r1
	bne locret_8012DB6
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	bl object_reservePanel
	bl sub_8012DB8
	strb r0, [r7,r6]
	ldrb r0, [r7,r4]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	bl object_removePanelReserve
locret_8012DB6:
	pop {r4,r6,pc}
	thumb_func_end sub_8012D8C

	thumb_local_start
sub_8012DB8:
	push {lr}
	ldr r3, off_8012DD0 // =byte_8012DD4
	bl GetAllianceDependentPanelParamArgs
	bl sub_8015C94
	cmp r0, #0
	beq locret_8012DCC
	lsl r1, r1, #4
	orr r0, r1
locret_8012DCC:
	pop {pc}
	.balign 4, 0
off_8012DD0:
	.word byte_8012DD4
byte_8012DD4:
	.byte 0x20, 0x0, 0x0, 0x0, 0x80, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xA0, 0x0
	.byte 0x0, 0x0
dword_8012DE4:
	.word 0x8000
dword_8012DE8:
	.word 0x4000
off_8012DEC:
	.word 0x2000
off_8012DF0:
	.word 0x1000
off_8012DF4:
	.word 0x100
dword_8012DF8:
	.word 0x1C3
	thumb_func_end sub_8012DB8

// symdb: Advances one frame of virtual-joypad edge state for a player-controlled battle navi, including a frozen-input mirror used during TimeStop.
// symdb: void battle_updateNaviAIJoypad(u32 naviIndex /*r0*/) – reads AI data via
// symdb: battle_getPlayerAIData_8010022; leaves c,v set by last internal test/cmp; clobbers r0,lr;
// symdb: preserves r4,r5,r6
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_updateNaviAIJoypad_8012DFC.yaml
	thumb_func_start battle_updateNaviAIJoypad_8012DFC
battle_updateNaviAIJoypad_8012DFC:
	push {r4,r6,lr}
	mov r7, r0
	bl battle_getPlayerAIData_8010022
	mov r4, r0
	bl battle_isBattleOver
	tst r0, r0
	bne loc_8012E64
	mov r0, r7
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte
	cmp r0, #0x17
	blt loc_8012E1E
	cmp r0, #0x18
	ble locret_8012E62
loc_8012E1E:
	ldr r1, off_8012E70 // =dword_2036820 
	mov r3, #8
	mul r3, r7
	add r1, r1, r3
	ldrh r6, [r1,#2]
	mov r3, r6
	ldrh r2, [r4,#oAIData_JoypadHeld]
	strh r2, [r4,#oAIData_JoypadReleased]
	strh r3, [r4,#oAIData_JoypadHeld]
	mvn r0, r2
	and r0, r3
	strh r0, [r4,#oAIData_JoypadPressed]
	mvn r0, r3
	and r0, r2
	strh r0, [r4,#oAIData_JoypadUp]
	bl battle_isTimeStop
	bne loc_8012E4E
	mov r0, #0
	strh r0, [r4,#oAIData_Unk_30]
	strh r0, [r4,#oAIData_Unk_2a]
	strh r0, [r4,#oAIData_Unk_2c]
	strh r0, [r4,#oAIData_Unk_2e]
	b locret_8012E62
loc_8012E4E:
	mov r3, r6
	ldrh r2, [r4,#oAIData_Unk_2a]
	strh r2, [r4,#oAIData_Unk_30]
	strh r3, [r4,#oAIData_Unk_2a]
	mvn r0, r2
	and r0, r3
	strh r0, [r4,#oAIData_Unk_2c]
	mvn r0, r3
	and r0, r2
	strh r0, [r4,#oAIData_Unk_2e]
locret_8012E62:
	pop {r4,r6,pc}
loc_8012E64:
	mov r1, #0
	strh r1, [r4,#oAIData_JoypadHeld]
	strh r1, [r4,#oAIData_JoypadReleased]
	strh r1, [r4,#oAIData_JoypadPressed]
	strh r1, [r4,#oAIData_JoypadUp]
	pop {r4,r6,pc}
	.balign 4, 0
off_8012E70:
	.word dword_2036820
	thumb_func_end battle_updateNaviAIJoypad_8012DFC

// symdb: Per-frame AI tick on the player's AIData: if the battle isn't over or paused, run the AI joypad helpers; otherwise clear the four AI joypad latches.
// symdb: (r5 = *AIData, r10 = *Toolkit) -> void ; side effects: writes
// symdb: AIData.JoypadHeld/Pressed/Up/Released
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_playerAIUpdate_8012E74.yaml
	thumb_func_start battleObject_playerAIUpdate_8012E74
battleObject_playerAIUpdate_8012E74:
	push {r4,r6,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	bl battle_isBattleOver
	tst r0, r0
	bne loc_8012E90
	bl battle_isPaused
	bne locret_8012E8E
	bl battle_runPwrAtkRelated_8012EA0
	bl battle_ai_updatePowerAttackCharge_8012EBC
locret_8012E8E:
	pop {r4,r6,pc}
loc_8012E90:
	mov r1, #0
	strh r1, [r4,#oAIData_JoypadHeld]
	strh r1, [r4,#oAIData_JoypadReleased]
	strh r1, [r4,#oAIData_JoypadPressed]
	strh r1, [r4,#oAIData_JoypadUp]
	pop {r4,r6,pc}
	.word dword_2036820
	thumb_func_end battleObject_playerAIUpdate_8012E74

// symdb: tail-call passthrough that runs the PWR-atk / joypad-related update
// symdb: (in = r5, r10, lr) -> out r0 = result of pwrAtkRelated_readsFromJoypad_8012FC8 ; no side effects
// symdb: beyond callee
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_runPwrAtkRelated_8012EA0.yaml
	thumb_local_start
battle_runPwrAtkRelated_8012EA0:
	push {lr}
	bl pwrAtkRelated_readsFromJoypad_8012FC8
	pop {pc}
	thumb_func_end battle_runPwrAtkRelated_8012EA0

// symdb: Clears the active PwrAtk (charged/Press A) state of a battle object: zeros the AIData charge-related bytes and clears the 0x60000 flag in the AI flag word.
// symdb: (r5 = BattleObjectPtr) -> r0 = 0x60000 ; side effects: writes AIData offsets 0x1b/0x1d/0x1e to 0
// symdb: and clears bits 0x60000 in AIData Unk_44
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_clearPwrAtkState_8012EA8.yaml
	thumb_func_start battleObject_clearPwrAtkState_8012EA8
battleObject_clearPwrAtkState_8012EA8:
	push {lr}
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0
	strb r0, [r3,#oAIData_PwrAtkState]
	strb r0, [r3,#oAIData_PwrAtkCurChargeTime]
	strb r0, [r3,#oAIData_PwrAtkButton]
	ldr r0, dword_8012FAC // =0x60000 
	bl ClearAIData_Unk_44_Flag
	pop {pc}
	thumb_func_end battleObject_clearPwrAtkState_8012EA8

// symdb: Advances the AI battle object's power-attack (B/A-button) charge timer when not time-stopped and the AI is holding the appropriate button.
// symdb: (r5 = AIDataPtr, r10 = toolkit/BattleStatePtr) -> void ; side effects: mutates AIData
// symdb: PwrAtkButton, PwrAtkCurChargeTime, PwrAtkState
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_ai_updatePowerAttackCharge_8012EBC.yaml
	thumb_local_start
battle_ai_updatePowerAttackCharge_8012EBC:
	push {r4,r6,r7,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	bl battle_isTimeStop
	bne locret_8012F3C
	bl returnBoolIfAIDataFlagsAreSet_8012F3E
	beq loc_8012F34
	ldrb r0, [r4,#oAIData_PwrAtkButton]
	bl DeterminePowerAttackChargeTime
	mov r7, r0
	bl GetAIData_Unk_44_Flag
	mov r3, #0
	ldr r1, dword_8012FAC // =0x60000 
	tst r0, r1
	bne loc_8012EE2
	b loc_8012F34
loc_8012EE2:
	ldr r1, dword_8012FB0 // =0x20000 
	tst r0, r1
	beq loc_8012EF8
	ldrb r0, [r4,#oAIData_PwrAtkButton]
	mov r1, #1
	strb r1, [r4,#oAIData_PwrAtkButton]
	cmp r0, #1
	beq loc_8012F14
	cmp r0, #0
	bne loc_8012F0E
	b loc_8012F14
loc_8012EF8:
	ldr r1, dword_8012FB4 // =0x40000 
	tst r0, r1
	beq loc_8012F14
	ldrb r0, [r4,#oAIData_PwrAtkButton]
	mov r1, #2
	strb r1, [r4,#oAIData_PwrAtkButton]
	cmp r0, #2
	beq loc_8012F14
	cmp r0, #0
	bne loc_8012F0E
	b loc_8012F14
loc_8012F0E:
	mov r0, #0
	strb r0, [r4,#oAIData_PwrAtkCurChargeTime]
	strb r0, [r4,#oAIData_PwrAtkState]
loc_8012F14:
	ldrb r0, [r4,#oAIData_PwrAtkCurChargeTime]
	add r0, #1
	strb r0, [r4,#oAIData_PwrAtkCurChargeTime]
	cmp r0, #0xa
	blt loc_8012F30
	mov r3, #1
	cmp r0, r7
	blt loc_8012F30
	strb r7, [r4,#oAIData_PwrAtkCurChargeTime]
	mov r3, #2
	b loc_8012F30
// dead code
	mov r0, #0
	strb r0, [r4,#oAIData_PwrAtkCurChargeTime]
	mov r3, #0
loc_8012F30:
	strb r3, [r4,#oAIData_PwrAtkState]
	pop {r4,r6,r7,pc}
loc_8012F34:
	mov r0, #0
	strb r0, [r4,#oAIData_PwrAtkButton]
	strb r0, [r4,#oAIData_PwrAtkCurChargeTime]
	strb r0, [r4,#oAIData_PwrAtkState]
locret_8012F3C:
	pop {r4,r6,r7,pc}
	thumb_func_end battle_ai_updatePowerAttackCharge_8012EBC

// symdb: Returns 1 when the current AI data reports the A button held (0x44 flag word free of 0x1000002F bits, 0x48 word with 0x200 clear and 0x10 set), else 0.
// symdb: bool checkAIData(void); // in: r5 = AI data pointer (passed through to the flag getters); out:
// symdb: r0 = 0/1, NZ flags set from r0; r3 left over from the last callee
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/returnBoolIfAIDataFlagsAreSet_8012F3E.yaml
	thumb_local_start
returnBoolIfAIDataFlagsAreSet_8012F3E:
	push {lr}
	// reads flag set when A is pressed
	bl GetAIData_Unk_44_Flag
	ldr r1, dword_8012FB8 // =0x1000002f 
	tst r0, r1
	bne loc_8012F5E
	bl GetAIDataUnk0x48Flag
	ldr r1, off_8012FBC // =0x200 
	tst r0, r1
	bne loc_8012F5E
	mov r1, #0x10
	tst r0, r1
	beq loc_8012F5E
	mov r0, #1
	pop {pc}
loc_8012F5E:
	mov r0, #0
	pop {pc}
	thumb_func_end returnBoolIfAIDataFlagsAreSet_8012F3E

// symdb: Computes the charge-frame duration of a navi's B/A power attack from the battle object's AI data, picking the A-side length and falling back to a Beast-Out length when the navi is transformed with an elementless chip.
// symdb: u32 determinePowerAttackChargeTime(u32 selector, u32 battleObject /* in r5 */); /* r0 in:
// symdb: B-button selector vs. A button; r0 out: charge frames (or 0xFF when no AI entry), r1 out: index
// symdb: into powerAttackChargeTimes table, r4 preserved, NZCV trashed */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/DeterminePowerAttackChargeTime.yaml
	thumb_local_start
DeterminePowerAttackChargeTime:
	push {r4,r7,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]

	mov r7, #oAIData_BPwrAtk
	cmp r0, #JOYPAD_B
	beq .gotAIDataPwrAtkStructOffset

	mov r7, #oAIData_APwrAtk
	mov r1, #oNaviStats_Transformation 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #TF_GREGARBEAST
	blt .gotAIDataPwrAtkStructOffset
	cmp r0, #TF_FALZARBEASTOVER
	bgt .gotAIDataPwrAtkStructOffset

	bl getCurChipInBattleHand_8010004
	ldr r1, dword_8012FC0 // =0xffff 
	// will never succeed
	// the operation which reads the current chip
	// does not set control codes
	// and the previous instruction that sets control
	// codes will always set nonzero
	beq .gotAIDataPwrAtkStructOffset

	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#oChipData_ChipElement]
	cmp r0, #CHIP_ELEM_NONE
	bne .gotAIDataPwrAtkStructOffset
	mov r7, #oAIData_BeastOutAPwrAtk

.gotAIDataPwrAtkStructOffset
	mov r1, #3
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	lsl r3, r0, #1
	mov r0, #0xff
	ldrb r1, [r4,r7]
	cmp r1, #0xff
	beq .returnMaxChargeTime
	mov r2, #0xa
	mul r1, r2
	add r1, r1, r3
	ldr r2, off_8012FC4 // =powerAttackChargeTimes_8020404 
	ldrh r0, [r2,r1]
.returnMaxChargeTime
	pop {r4,r7,pc}
	.balign 4, 0
dword_8012FAC:
	.word 0x60000
dword_8012FB0:
	.word 0x20000
dword_8012FB4:
	.word 0x40000
dword_8012FB8:
	.word 0x1000002F
off_8012FBC:
	.word 0x200
dword_8012FC0:
	.word 0xFFFF
off_8012FC4:
	.word powerAttackChargeTimes_8020404
	thumb_func_end DeterminePowerAttackChargeTime

	thumb_local_start
pwrAtkRelated_readsFromJoypad_8012FC8:
	push {r4,r6,r7,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	bl GetAIData_Unk_44_Flag
	mov r6, r0
	bl battle_isTimeStop
	beq loc_8013008
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_canAllianceAct_800A772
	tst r0, r0
	bne loc_8012FE4
	pop {r4,r6,r7,pc}
loc_8012FE4:
	ldr r1, off_80133B0 // =0x800 
	tst r1, r6
	bne locret_8013006
	bl getCurChipInBattleHand_8010004
	add r1, r0, #1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	beq locret_8013006
	ldrh r0, [r4,#oAIData_Unk_2c]
	mov r1, #1
	tst r0, r1
	bne loc_8013000
	b locret_8013006
loc_8013000:
	ldr r0, off_80133B0 // =0x800 
	bl SetAIData_Unk_44_Flag
locret_8013006:
	pop {r4,r6,r7,pc}
loc_8013008:
	bl battle_testFlag0x40_800A8F8
	beq loc_8013044
	ldrh r1, [r4,#oAIData_JoypadPressed]
	mov r2, #4
	tst r1, r2
	beq loc_8013044
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	ldrh r0, [r0,#0x28]
	ldr r1, off_80133B4 // =0x1500 
	cmp r0, r1
	bge loc_801303C
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	ldrb r1, [r5,#oBattleObject_Alliance]
	cmp r0, r1
	bne loc_8013044
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	bl sub_801EC44
	b loc_8013044
loc_801303C:
	ldr r0, off_80133B8 // =timer_2000000 
	bl SetAIData_Unk_44_Flag
	b locret_8013234
loc_8013044:
	bl GetBattleMode
	cmp r0, #1
	beq loc_801309C
	ldrh r7, [r4,#oAIData_JoypadHeld]
	bl GetAIDataUnk0x48Flag
	ldr r1, off_80133BC // =0x400 
	tst r0, r1
	bne loc_8013072
	bl battle_getFlags
	mov r1, #2
	tst r0, r1
	beq loc_801309C
	ldrh r0, [r4,#oAIData_JoypadPressed]
	ldr r1, off_80133C0 // =0x300 
	tst r0, r1
	beq loc_801309C
	mov r0, #0x10
	bl battle_setFlags
	b locret_8013234
loc_8013072:
	ldrh r7, [r4,#oAIData_JoypadPressed]
	ldr r1, off_80133C0 // =0x300 
	tst r7, r1
	beq loc_801309C
	ldrb r0, [r5,#oBattleObject_DirectionFlip]
	cmp r0, #0
	beq loc_801308E
	ldr r0, off_80133C4 // =0x1000 
	bl SetAIData_Unk_44_Flag
	ldr r0, off_80133C8 // =0x2000 
	bl ClearAIData_Unk_44_Flag
	b loc_801309C
loc_801308E:
	ldr r0, off_80133C8 // =0x2000 
	bl SetAIData_Unk_44_Flag
	ldr r0, off_80133C4 // =0x1000 
	bl ClearAIData_Unk_44_Flag
	b loc_801309C
loc_801309C:
	ldrh r7, [r4,#oAIData_JoypadHeld]
	bl GetAIData_Unk_44_Flag
	ldr r1, dword_80133CC // =0x60000 
	tst r0, r1
	bne loc_80130D0
	bl aiTrySelectChipFromHand_801336C
	beq loc_80130BC
	mov r1, #1
	tst r7, r1
	beq loc_80130BC
	ldr r0, dword_80133D0 // =0x20000 
	bl SetAIData_Unk_44_Flag
	b loc_8013130
loc_80130BC:
	bl aiAttackingBuster_8013396
	beq loc_80130D0
	mov r1, #2
	tst r7, r1
	beq loc_8013130
	ldr r0, dword_80133D4 // =0x40000 
	bl SetAIData_Unk_44_Flag
	b loc_8013130
loc_80130D0:
	ldr r1, dword_80133D0 // =0x20000 
	tst r0, r1
	beq loc_80130FA
	ldrh r0, [r4,#oAIData_JoypadPressed]
	mov r1, #2
	tst r0, r1
	beq loc_80130EC
	ldr r0, dword_80133D0 // =0x20000 
	bl ClearAIData_Unk_44_Flag
	ldr r0, dword_80133D4 // =0x40000 
	bl SetAIData_Unk_44_Flag
	b loc_8013130
loc_80130EC:
	bl aiTrySelectChipFromHand_801336C
	beq loc_801312A
	mov r0, #1
	tst r7, r0
	beq loc_801312A
	b loc_8013130
loc_80130FA:
	ldr r1, dword_80133D4 // =0x40000 
	tst r0, r1
	beq loc_8013130
	bl aiTrySelectChipFromHand_801336C
	beq loc_801311C
	ldrh r0, [r4,#oAIData_JoypadPressed]
	mov r1, #1
	tst r0, r1
	beq loc_801311C
	ldr r0, dword_80133D4 // =0x40000 
	bl ClearAIData_Unk_44_Flag
	ldr r0, dword_80133D0 // =0x20000 
	bl SetAIData_Unk_44_Flag
	b loc_8013130
loc_801311C:
	bl aiAttackingBuster_8013396
	beq loc_801312A
	mov r0, #2
	tst r7, r0
	beq loc_801312A
	b loc_8013130
loc_801312A:
	ldr r0, dword_80133CC // =0x60000 
	bl ClearAIData_Unk_44_Flag
loc_8013130:
	ldrb r0, [r4,#oAIData_BLeftAbility]
	cmp r0, #0xff
	beq loc_8013176
	ldrb r0, [r4,#oAIData_Unk_15]
	tst r0, r0
	bne loc_8013176
	ldrh r2, [r4,#oAIData_JoypadPressed]
	ldrb r0, [r4,#oAIData_Unk_13]
	tst r0, r0
	bne loc_801314E
	mov r1, #2
	tst r2, r1
	beq loc_8013176
	mov r0, #8
	strb r0, [r4,#oAIData_Unk_13]
loc_801314E:
	mov r1, #0x20 
	ldrb r3, [r5,#oBattleObject_DirectionFlip]
	tst r3, r3
	beq loc_8013158
	mov r1, #0x10
loc_8013158:
	tst r2, r1
	beq loc_801316C
	ldrh r2, [r4,#oAIData_JoypadHeld]
	mov r1, #2
	tst r1, r2
	beq loc_801316C
	mov r0, #0x10
	bl SetAIData_Unk_44_Flag
	b loc_8013172
loc_801316C:
	sub r0, #1
	strb r0, [r4,#oAIData_Unk_13]
	b loc_8013176
loc_8013172:
	mov r0, #0
	strb r0, [r4,#oAIData_Unk_13]
loc_8013176:
	ldrb r1, [r4,#oAIData_BButton]
	cmp r1, #0xff
	beq loc_80131D8
	mov r2, #3
	tst r2, r6
	bne loc_80131D8
	cmp r1, #4
	beq loc_801318E
	cmp r1, #0x2c 
	beq loc_801318E
	cmp r1, #3
	bne loc_80131B4
loc_801318E:
	mov r1, #oNaviStats_Transformation 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #TF_TENGUBEAST
	beq loc_801319C
	cmp r0, #TF_DUSTBEAST
	bne loc_80131A6
loc_801319C:
	bl GetAIData_Unk_44_Flag
	mov r1, #0x10
	tst r0, r1
	bne loc_80131D8
loc_80131A6:
	bl GetAIData_Unk_44_Flag
	ldr r1, dword_80133D8 // =0x10000 
	tst r0, r1
	bne loc_80131D8
	ldrh r0, [r4,#oAIData_JoypadHeld]
	b loc_80131BE
loc_80131B4:
	ldrh r0, [r4,#oAIData_JoypadPressed]
	ldrb r1, [r4,#oAIData_BPwrAtk]
	cmp r1, #0xff
	beq loc_80131BE
	ldrh r0, [r4,#oAIData_JoypadUp]
loc_80131BE:
	mov r1, #JOYPAD_B
	tst r0, r1
	beq loc_80131D8
	mov r0, #1
	ldrb r1, [r4,#oAIData_PwrAtkButton]
	cmp r1, #JOYPAD_B
	bne loc_80131D4
	ldrb r1, [r4,#oAIData_PwrAtkState]
	cmp r1, #2
	bne loc_80131D4
	mov r0, #2
loc_80131D4:
	bl SetAIData_Unk_44_Flag
loc_80131D8:
	bl GetBattleMode
	cmp r0, #9 // dustman minigame
	bne loc_80131EE
	ldrh r0, [r4,#oAIData_JoypadPressed]
	mov r1, #1
	tst r0, r1
	beq loc_80131EE
	ldr r0, dword_80133DC // =0x10000000 
	bl SetAIData_Unk_44_Flag
loc_80131EE:
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_canAllianceAct_800A772
	tst r0, r0
	beq locret_8013234
	mov r1, #0xc
	tst r1, r6
	bne locret_8013234
	bl getCurChipInBattleHand_8010004
	ldr r1, dword_80133E0 // =0xffff 
	cmp r0, r1
	beq locret_8013234
	bl aiTrySelectChipFromHand_801336C
	bne loc_8013218
	ldrh r0, [r4,#oAIData_JoypadPressed]
	mov r1, #1
	tst r0, r1
	bne loc_8013220
	b locret_8013234
loc_8013218:
	ldrh r0, [r4,#oAIData_JoypadUp]
	mov r1, #1
	tst r0, r1
	beq locret_8013234
loc_8013220:
	mov r0, #4
	ldrb r1, [r4,#oAIData_PwrAtkButton]
	cmp r1, #1
	bne loc_8013230
	ldrb r1, [r4,#oAIData_PwrAtkState]
	cmp r1, #2
	bne loc_8013230
	mov r0, #8
loc_8013230:
	bl SetAIData_Unk_44_Flag
locret_8013234:
	pop {r4,r6,r7,pc}
	thumb_func_end pwrAtkRelated_readsFromJoypad_8012FC8

// symdb: Decides whether the enemy AI may play the chip currently sitting in its battle hand this frame, considering chip ID, alliance, element and the owner's element/attack modifiers.
// symdb: in r0 = chip ID to test -> r0 = 1 if the AI is allowed to use the chip, 0 if it is blocked
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ai_tryUseChipFromHand_8013236.yaml
	thumb_local_start
ai_tryUseChipFromHand_8013236:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r0, [sp]
	ldr r1, off_80133E4 // =0x190 
	cmp r0, r1
	blt loc_8013244
	b loc_8013360
loc_8013244:
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r7, r0
	ldrb r4, [r7,#6]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r6, r0
	ldrb r1, [r7,#9]
	cmp r6, #2
	bne loc_801326C
	cmp r4, #0xa
	bne loc_801326C
	mov r0, #2
	tst r0, r1
	beq loc_801326C
	mov r0, #1
	tst r0, r1
	bne loc_801326C
	b loc_8013366
loc_801326C:
	cmp r6, #3
	beq loc_8013274
	cmp r6, #0xf
	bne loc_8013290
loc_8013274:
	ldr r2, [sp]
	cmp r2, #0x4c 
	blt loc_801327E
	cmp r2, #0x4f 
	ble loc_8013282
loc_801327E:
	cmp r4, #5
	bne loc_8013290
loc_8013282:
	mov r0, #2
	tst r0, r1
	beq loc_8013290
	mov r0, #1
	tst r0, r1
	bne loc_8013290
	b loc_8013366
loc_8013290:
	cmp r6, #0xb
	blt loc_801329E
	cmp r6, #0x16
	bgt loc_801329E
	cmp r4, #0xa
	bne loc_801329E
	b loc_8013366
loc_801329E:
	cmp r6, #7
	beq loc_80132A6
	cmp r6, #0x13
	bne loc_80132BA
loc_80132A6:
	ldrb r3, [r7,#6]
	cmp r3, #3
	bne loc_80132BA
	mov r0, #2
	tst r0, r1
	beq loc_80132BA
	mov r0, #1
	tst r0, r1
	bne loc_80132BA
	b loc_8013366
loc_80132BA:
	cmp r6, #6
	beq loc_80132C2
	cmp r6, #0x12
	bne loc_80132D6
loc_80132C2:
	ldrb r3, [r7,#6]
	cmp r3, #1
	bne loc_80132D6
	mov r0, #2
	tst r0, r1
	beq loc_80132D6
	mov r0, #1
	tst r0, r1
	bne loc_80132D6
	b loc_8013366
loc_80132D6:
	cmp r6, #9
	beq loc_80132DE
	cmp r6, #0x15
	bne loc_80132F0
loc_80132DE:
	cmp r4, #9
	bne loc_80132F0
	mov r0, #2
	tst r0, r1
	beq loc_80132F0
	mov r0, #1
	tst r0, r1
	bne loc_80132F0
	b loc_8013366
loc_80132F0:
	cmp r6, #5
	beq loc_80132F8
	cmp r6, #0x11
	bne loc_801330C
loc_80132F8:
	ldrb r3, [r7,#6]
	cmp r3, #0
	bne loc_801330C
	mov r0, #2
	tst r0, r1
	beq loc_801330C
	mov r0, #1
	tst r0, r1
loc_8013308:
	bne loc_801330C
	b loc_8013366
loc_801330C:
	bl battle_getObjectAllianceTeam_800F49E
	cmp r0, #0xff
	beq loc_8013360
	mov r6, r0
	ldr r4, off_80133E8 // =byte_8021369 
	ldrb r1, [r7,#9]
	mov r0, #2
	tst r0, r1
	beq loc_8013338
	mov r0, #1
	tst r0, r1
	bne loc_8013360
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldrb r3, [r7,#6]
	cmp r0, #5
	bne loc_8013338
	cmp r3, #0
	bne loc_8013360
	b loc_801335A
loc_8013338:
	cmp r0, #6
	bne loc_8013344
	cmp r3, #1
	bne loc_8013360
	add r4, #1
	b loc_801335A
loc_8013344:
	cmp r0, #7
	bne loc_8013350
	cmp r3, #3
	bne loc_8013360
	add r4, #2
	b loc_801335A
loc_8013350:
	cmp r0, #0xb
	bne loc_8013360
	cmp r3, #5
	bne loc_8013360
	add r4, #3
loc_801335A:
	ldrb r0, [r4]
	cmp r6, r0
	bge loc_8013366
loc_8013360:
	mov r0, #0
	add sp, sp, #4
	pop {r4,r6,r7,pc}
loc_8013366:
	mov r0, #1
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	thumb_func_end ai_tryUseChipFromHand_8013236

// symdb: Checks whether the enemy AI may play the chip waiting in its battle hand this frame (no attack-power hint set, AI condition flags allow acting, hand not empty) and if so performs the chip selection via sub_8013236.
// symdb: bool sub_801336C(battleObject* obj /* r4, r5 = the battle object */, ...)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/aiTrySelectChipFromHand_801336C.yaml
	thumb_local_start
aiTrySelectChipFromHand_801336C:
	push {lr}
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r1,#oAIData_APwrAtk]
	cmp r0, #0xff
	bne loc_801337C
	ldrb r0, [r1,#oAIData_BeastOutAPwrAtk]
	cmp r0, #0xff
	beq loc_8013392
loc_801337C:
	bl returnBoolIfAIDataFlagsAreSet_8012F3E
	beq loc_8013392
	bl getCurChipInBattleHand_8010004
	ldr r1, dword_80133E0 // =0xffff 
	cmp r0, r1
	beq loc_8013392
	bl ai_tryUseChipFromHand_8013236
	pop {pc}
loc_8013392:
	mov r0, #0
	pop {pc}
	thumb_func_end aiTrySelectChipFromHand_801336C

// symdb: Returns nz whether the battle object's AI is currently executing a buster attack
// symdb: bool aiAttackingBuster_8013396(u32* battle_object /* r5 */); // r0 nz on true, 0 on false;
// symdb: clobbers r1 r3 lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/aiAttackingBuster_8013396.yaml
	thumb_local_start
aiAttackingBuster_8013396:
	push {lr}
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r1,#oAIData_BPwrAtk]
	cmp r0, #0xff
	beq loc_80133AA
	bl returnBoolIfAIDataFlagsAreSet_8012F3E
	beq loc_80133AA
	mov r0, #1
	pop {pc}
loc_80133AA:
	mov r0, #0
	pop {pc}
	.balign 4, 0
off_80133B0:
	.word 0x800
off_80133B4:
	.word 0x1500
off_80133B8:
	.word timer_2000000
off_80133BC:
	.word 0x400
off_80133C0:
	.word 0x300
off_80133C4:
	.word 0x1000
off_80133C8:
	.word 0x2000
dword_80133CC:
	.word 0x60000
dword_80133D0:
	.word 0x20000
dword_80133D4:
	.word 0x40000
dword_80133D8:
	.word 0x10000
dword_80133DC:
	.word 0x10000000
dword_80133E0:
	.word 0xFFFF
off_80133E4:
	.word 0x190
off_80133E8:
	.word byte_8021369
	thumb_func_end aiAttackingBuster_8013396

// symdb: Initializes seven battle slot entries (via init_8013B4E) in the fixed order {0,6,7,8,9,A,B}, the second of two hard-coded init orders.
// symdb: void battle_initSlotsOrderPhaseB_80133EC(void); // no meaningful inputs; clobbers
// symdb: r0,r1,flags,LR; preserves r5,r6 (pushed/popped)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_initSlotsOrderPhaseB_80133EC.yaml
	thumb_func_start battle_initSlotsOrderPhaseB_80133EC
battle_initSlotsOrderPhaseB_80133EC:
	push {r5,r6,lr}
	mov r0, #0x4 // (off_8013410 - 0x801340c)
	ldr r6, off_8013408 // =off_801340C 
	ldr r6, [r6,r0]
	mov r5, #0
loc_80133F6:
	mov r0, r5
	ldrb r1, [r6,r5]
	bl init_8013B4E // (bool a1, int a2) -> void
	add r5, #1
	cmp r5, #7
	blt loc_80133F6
	pop {r5,r6,pc}
	.balign 4, 0
off_8013408:
	.word off_801340C
off_801340C:
	.word byte_8013414
off_8013410:
	.word byte_801341B
byte_8013414:
	.byte 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0xB
byte_801341B:
	.byte 0x0, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB
	thumb_func_end battle_initSlotsOrderPhaseB_80133EC

// symdb: Initializes the BattleNavi stats record for one navi index with the default stat set.
// symdb: void battle_InitNaviStatsByIndex(u32 naviIndex /* r0 */); returns r2 = eBattleNaviStats0 (array
// symdb: base)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_InitNaviStatsByIndex_8013422.yaml
	thumb_func_start battle_InitNaviStatsByIndex_8013422
battle_InitNaviStatsByIndex_8013422:
	push {lr}
	ldr r2, off_8013434 // =eBattleNaviStats0
	mov r1, #0x64 
	mul r0, r1
	add r0, r0, r2
	bl initNaviStats_WithDefaultStatsMaybe_8013438 // (void *struct) -> void
	pop {pc}
	.balign 4, 0
off_8013434:
	.word eBattleNaviStats0
	thumb_func_end battle_InitNaviStatsByIndex_8013422

// (void *struct) -> void
// symdb: Initialize a 0x64-byte Navi battle-stats structure to its default values
// symdb: void battleNaviStatsInit_8013438(void *stats /* r0 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/initNaviStats_WithDefaultStatsMaybe_8013438.yaml
	thumb_func_start initNaviStats_WithDefaultStatsMaybe_8013438
initNaviStats_WithDefaultStatsMaybe_8013438:
	push {r4,lr}
	mov r4, r0
	// memBlock
	mov r0, r4
	// size
	mov r1, #0x64 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #1
	mov r1, #0x20 
	strb r0, [r4,r1]
	mov r0, #1
	strb r0, [r4,#5]
	mov r0, #0xff
	strb r0, [r4,#7]
	mov r0, #0
	strb r0, [r4,#0x18]
	mov r0, #0
	strb r0, [r4,#0x19]
	mov r0, #0
	strb r0, [r4,#8]
	mov r0, #4
	strb r0, [r4,#9]
	mov r0, #5
	strb r0, [r4,#0xa]
	mov r0, #5
	strb r0, [r4,#0xb]
	mov r0, #1
	strb r0, [r4,#0xc]
	mov r0, #0
	strb r0, [r4,#0xd]
	mov r0, #0
	mov r1, #0x26 
	strb r0, [r4,r1]
	mov r0, #0xff
	strb r0, [r4,#0x12]
	mov r0, #0x1f
	mov r1, #0x27 
	strb r0, [r4,r1]
	mov r0, #0
	mov r1, #0x28 
	strb r0, [r4,r1]
	mov r0, #0x99
	mov r1, #0xe
	strb r0, [r4,r1]
	mov r0, #0x64 
	mov r1, #0x40 
	strh r0, [r4,r1]
	mov r1, #0x42 
	strh r0, [r4,r1]
	mov r1, #0x3e 
	strh r0, [r4,r1]
	mov r0, #0
	mov r1, #0x2c 
	strb r0, [r4,r1]
	mov r0, #0
	mov r1, #0x2d 
	strb r0, [r4,r1]
	mov r0, #0xff
	mov r1, #0x2e 
loc_80134AC:
	strb r0, [r4,r1]
	add r1, #1
	cmp r1, #0x30 
	ble loc_80134AC
	mov r0, #0xff
	mov r1, #0x56 
loc_80134B8:
	strb r0, [r4,r1]
	add r1, #1
	cmp r1, #0x5b 
	ble loc_80134B8
	mov r0, #3
	mov r1, #0x21 
	strb r0, [r4,r1]
	pop {r4,pc}
	thumb_func_end initNaviStats_WithDefaultStatsMaybe_8013438

	thumb_func_start sub_80134C8
sub_80134C8:
	push {r4,lr}
	mov r4, r0
	// memBlock
	mov r0, r4
	// size
	mov r1, #0x64 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #1
	mov r1, #0x20 
	strb r0, [r4,r1]
	mov r0, #1
	strb r0, [r4,#5]
	mov r0, #0xff
	strb r0, [r4,#7]
	mov r0, #0
	strb r0, [r4,#0x18]
	mov r0, #0
	strb r0, [r4,#0x19]
	mov r0, #0
	strb r0, [r4,#8]
	mov r0, #4
	strb r0, [r4,#9]
	mov r0, #5
	strb r0, [r4,#0xa]
	mov r0, #5
	strb r0, [r4,#0xb]
	mov r0, #1
	strb r0, [r4,#0xc]
	mov r0, #0
	strb r0, [r4,#0xd]
	mov r0, #0
	mov r1, #0x26 
	strb r0, [r4,r1]
	mov r0, #0xff
	strb r0, [r4,#0x12]
	mov r0, #0x1f
	mov r1, #0x27 
	strb r0, [r4,r1]
	mov r0, #0
	mov r1, #0x28 
	strb r0, [r4,r1]
	mov r0, #0x99
	mov r1, #0xe
	strb r0, [r4,r1]
	ldr r0, off_8013550 // =0x1f4 
	mov r1, #0x40 
	strh r0, [r4,r1]
	mov r1, #0x42 
	strh r0, [r4,r1]
	mov r1, #0x3e 
	strh r0, [r4,r1]
	mov r0, #2
	strb r0, [r4,#1]
	strb r0, [r4,#2]
	strb r0, [r4,#3]
	mov r0, #0
	mov r1, #0x2c 
	strb r0, [r4,r1]
	mov r0, #0xff
	mov r1, #0x2e 
	strb r0, [r4,r1]
	mov r1, #0x2f 
	strb r0, [r4,r1]
	mov r1, #0x30 
	strb r0, [r4,r1]
	mov r0, #1
	mov r1, #0x21 
	strb r0, [r4,r1]
	pop {r4,pc}
	.balign 4, 0
off_8013550:
	.word 0x1F4
	thumb_func_end sub_80134C8

	thumb_func_start sub_8013554
sub_8013554:
	push {r4,lr}
	mov r4, r0
	// memBlock
	mov r0, r4
	// size
	mov r1, #0x64 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #0x46 
	strb r0, [r4,#4]
	mov r0, #0xff
	strb r0, [r4,#5]
	mov r0, #0xff
	strb r0, [r4,#7]
	mov r0, #0
	strb r0, [r4,#0x18]
	mov r0, #0
	strb r0, [r4,#0x19]
	mov r0, #0
	strb r0, [r4,#8]
	mov r0, #4
	strb r0, [r4,#9]
	mov r0, #5
	strb r0, [r4,#0xa]
	mov r0, #5
	strb r0, [r4,#0xb]
	mov r0, #1
	strb r0, [r4,#0xc]
	mov r0, #0
	strb r0, [r4,#0xd]
	mov r0, #0
	mov r1, #0x26 
	strb r0, [r4,r1]
	mov r0, #0xff
	strb r0, [r4,#0x12]
	mov r0, #0x1f
	mov r1, #0x27 
	strb r0, [r4,r1]
	mov r0, #0
	mov r1, #0x28 
	strb r0, [r4,r1]
	mov r0, #0x99
	mov r1, #0xe
	strb r0, [r4,r1]
	mov r0, #1
	mov r1, #0x42 
	bl GetNaviStatsHword
	mov r1, #0x40 
	strh r0, [r4,r1]
	mov r1, #0x42 
	strh r0, [r4,r1]
	mov r1, #0x3e 
	strh r0, [r4,r1]
	mov r0, #0
	mov r1, #0x2c 
	strb r0, [r4,r1]
	mov r0, #7
	mov r1, #0x29 
	strb r0, [r4,r1]
	mov r0, #0
	mov r1, #0x2d 
	strb r0, [r4,r1]
	mov r0, #0xff
	mov r1, #0x2e 
loc_80135D2:
	strb r0, [r4,r1]
	add r1, #1
	cmp r1, #0x30 
	ble loc_80135D2
	mov r0, #0xff
	mov r1, #0x56 
loc_80135DE:
	strb r0, [r4,r1]
	add r1, #1
	cmp r1, #0x5b 
	ble loc_80135DE
	pop {r4,pc}
	thumb_func_end sub_8013554

	thumb_func_start sub_80135E8
sub_80135E8:
	push {r4,lr}
	mov r4, r0
	// memBlock
	mov r0, r4
	// size
	mov r1, #0x64 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #0x4c 
	strb r0, [r4,#4]
	mov r0, #0x4b 
	mov r1, #0x44 
	strb r0, [r4,r1]
	mov r0, #0xff
	strb r0, [r4,#5]
	mov r0, #0xff
	strb r0, [r4,#7]
	mov r0, #0
	strb r0, [r4,#0x18]
	mov r0, #0
	strb r0, [r4,#0x19]
	mov r0, #0
	strb r0, [r4,#8]
	mov r0, #4
	strb r0, [r4,#9]
	mov r0, #5
	strb r0, [r4,#0xa]
	mov r0, #5
	strb r0, [r4,#0xb]
	mov r0, #1
	strb r0, [r4,#0xc]
	mov r0, #0
	strb r0, [r4,#0xd]
	mov r0, #0
	mov r1, #0x26 
	strb r0, [r4,r1]
	mov r0, #0xff
	strb r0, [r4,#0x12]
	mov r0, #0x1f
	mov r1, #0x27 
	strb r0, [r4,r1]
	mov r0, #0
	mov r1, #0x28 
	strb r0, [r4,r1]
	mov r0, #0x99
	mov r1, #0xe
	strb r0, [r4,r1]
	mov r0, #1
	mov r1, #0x42 
	bl GetNaviStatsHword
	mov r1, #0x40 
	strh r0, [r4,r1]
	mov r1, #0x42 
	strh r0, [r4,r1]
	mov r1, #0x3e 
	strh r0, [r4,r1]
	mov r0, #0
	mov r1, #0x2c 
	strb r0, [r4,r1]
	mov r0, #0xa
	mov r1, #0x29 
	strb r0, [r4,r1]
	mov r0, #0
	mov r1, #0x2d 
	strb r0, [r4,r1]
	mov r0, #0xff
	mov r1, #0x2e 
loc_801366C:
	strb r0, [r4,r1]
	add r1, #1
	cmp r1, #0x30 
	ble loc_801366C
	mov r0, #0xff
	mov r1, #0x56 
loc_8013678:
	strb r0, [r4,r1]
	add r1, #1
	cmp r1, #0x5b 
	ble loc_8013678
	pop {r4,pc}
	thumb_func_end sub_80135E8

// (int idx) -> void*
// symdb: Returns the address of a navi's entry in the battle navi stats table for a given navi index.
// symdb: NaviStats* GetBattleNaviStatsAddr(int index); // r0 = index, returns r0 =
// symdb: &eBattleNaviStats0[index]; r1 also ends up holding the table base, flags set by the final ADD
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattleNaviStatsAddr.yaml
	thumb_func_start GetBattleNaviStatsAddr
GetBattleNaviStatsAddr: // (alliance: bool) -> * NaviStats
	mov r1, #oNaviStats_Size
	mul r0, r1
	ldr r1, =eBattleNaviStats0
	add r0, r0, r1
	mov pc, lr
// 801368C
	.pool
	thumb_func_end GetBattleNaviStatsAddr

	thumb_local_start
GetBattleNaviStats203CB10Addr:
	mov r1, #oNaviStats_Size
	mul r0, r1
	ldr r1, off_801369C // =eBattleNaviStats203CB10 
	add r0, r0, r1
	mov pc, lr
	.balign 4, 0x00
off_801369C:
	.word eBattleNaviStats203CB10
	thumb_func_end GetBattleNaviStats203CB10Addr

	thumb_local_start
GetBattleNaviStats2034A60Addr:
	mov r1, #oNaviStats_Size
	mul r0, r1
	ldr r1, off_80136AC // =eBattleNaviStats2034A60 
	add r0, r0, r1
	mov pc, lr
	.balign 4, 0x00
off_80136AC:
	.word eBattleNaviStats2034A60
	thumb_func_end GetBattleNaviStats2034A60Addr

// symdb: Writes a single byte at a given offset into the NaviStats record of the requested Navi (alliance side), e.g. updating a netbattle stat.
// symdb: void SetBattleNaviStatsByte(bool alliance, u32 fieldOffset, u8 value)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetBattleNaviStatsByte.yaml
	thumb_local_start
SetBattleNaviStatsByte:
	push {r6,r7,lr}
	mov r6, r1
	mov r7, r2
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	strb r7, [r0,r6]
	pop {r6,r7,pc}
	thumb_func_end SetBattleNaviStatsByte

	thumb_local_start
SetBattleNaviStatsHword:
	push {r6,r7,lr}
	mov r6, r1
	mov r7, r2
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	strh r7, [r0,r6]
	pop {r6,r7,pc}
	thumb_func_end SetBattleNaviStatsHword

// symdb: Reads a single byte from either side's NaviStats record at a caller-chosen offset
// symdb: u8 GetBattleNaviStatsByte(bool side /*r0*/, u32 offset /*r1*/)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattleNaviStatsByte.yaml
	thumb_func_start GetBattleNaviStatsByte
GetBattleNaviStatsByte:
	push {r6,lr}
	mov r6, r1
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	ldrb r0, [r0,r6]
	pop {r6,pc}
	thumb_func_end GetBattleNaviStatsByte

	thumb_func_start GetBattleNaviStatsSignedByte
GetBattleNaviStatsSignedByte:
	push {r6,lr}
	mov r6, r1
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	ldrsb r0, [r0,r6]
	pop {r6,pc}
	thumb_func_end GetBattleNaviStatsSignedByte

// symdb: Reads one halfword field out of the current battle navi's NaviStats struct, with the field chosen by an offset in r1.
// symdb: u16 GetBattleNaviStatsHword(bool alliance /*r0*/, u32 statOffset /*r1*/) — returns the halfword
// symdb: in r0; r6 preserved, r1 clobbered, flags clobbered.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattleNaviStatsHword.yaml
	thumb_func_start GetBattleNaviStatsHword
GetBattleNaviStatsHword:
	push {r6,lr}
	mov r6, r1
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	ldrh r0, [r0,r6]
	pop {r6,pc}
	thumb_func_end GetBattleNaviStatsHword

	thumb_func_start SetNaviStatsByte
// (bool structSel, int a2, u8 a3) -> void
// symdb: Writes one byte into a NaviStats record (record index normalized to 0/1) via the toolkit's NaviStats pointer.
// symdb: void SetNaviStatsByte(int record /*r0, normalized to 0/1*/, int fieldOffset /*r1*/, u8 value
// symdb: /*r2*/, Toolkit* toolkit /*r10*/); returns r0 = record * oNaviStats_Size, r3 = address of
// symdb: written byte
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetNaviStatsByte.yaml
SetNaviStatsByte:
    // type safety, ensure bool (0, 1)
	cmp r0, #0
	beq loc_80136F6
	mov r0, #1
loc_80136F6:
    // Toolkit->S20047CC_Ptrs[oS20047CC*a1 + a2] = a3
	mov r3, #oNaviStats_Size
	mul r0, r3
	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0
	strb r2, [r3,r1]
	mov pc, lr
	thumb_func_end SetNaviStatsByte

// symdb: Reads a single byte from one of the two navi-stats records (MegaMan's or a second navi's) in the save data.
// symdb: u8 GetNaviStatsByte(u32 useSecondRecord, u32 fieldOffset) via r0=selector, r1=field offset,
// symdb: r10=toolkit; returns r0=byte, r3=address of the byte read
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetNaviStatsByte.yaml
	thumb_func_start GetNaviStatsByte
GetNaviStatsByte:
	cmp r0, #0
	beq loc_801370A
	mov r0, #1
loc_801370A:
	mov r3, #oNaviStats_Size
	mul r0, r3
	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0
	ldrb r0, [r3,r1]
	mov pc, lr
	thumb_func_end GetNaviStatsByte

	thumb_local_start
GetNaviStatsByte_8013718:
	cmp r0, #0
	beq loc_801371E
	mov r0, #1
loc_801371E:
	mov r3, #oNaviStats_Size
	mul r0, r3
	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0
	ldrb r0, [r3,r1]
	mov pc, lr
	thumb_func_end GetNaviStatsByte_8013718

	thumb_local_start
SetNaviStatsHword:
	cmp r0, #0
	beq loc_8013732
	mov r0, #1
loc_8013732:
	mov r3, #oNaviStats_Size
	mul r0, r3
	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0
	strh r2, [r3,r1]
	mov pc, lr
	thumb_func_end SetNaviStatsHword

	thumb_local_start
GetNaviStatsHword:
	cmp r0, #0
	beq loc_8013746
	mov r0, #1
loc_8013746:
	mov r3, #oNaviStats_Size
	mul r0, r3
	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0
	ldrh r0, [r3,r1]
	mov pc, lr
	thumb_func_end GetNaviStatsHword

// FIX THESE NAMES
// symdb: Writes one byte into the NaviStats record of the navi a battle object represents, selecting the real record or its ghost copy based on the object's alliance flag.
// symdb: void SetBattleNaviStatsByte_AllianceFromBattleObject(u8* stats_offset = r1, u8 value = r2,
// symdb: BattleObject* obj = r5); // calls GetBattleNaviStatsAddr(alliance = [r5+oBattleObject_Alliance])
// symdb: to get &NaviStats, then stores value at statsOffset within it
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetBattleNaviStatsByte_AllianceFromBattleObject.yaml
	thumb_func_start SetBattleNaviStatsByte_AllianceFromBattleObject
SetBattleNaviStatsByte_AllianceFromBattleObject:
	push {r6,r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r6, r1
	mov r7, r2
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	strb r7, [r0,r6]
	pop {r6,r7,pc}
	thumb_func_end SetBattleNaviStatsByte_AllianceFromBattleObject

	thumb_func_start SetBattleNaviStatsHword_AllianceFromBattleObject
SetBattleNaviStatsHword_AllianceFromBattleObject:
	push {r6,r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r6, r1
	mov r7, r2
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	strh r7, [r0,r6]
	pop {r6,r7,pc}
	thumb_func_end SetBattleNaviStatsHword_AllianceFromBattleObject

// symdb: Read one NaviStats byte for the battle object's side (alliance).
// symdb: (r1 = stat offset, r5 = battle object) -> r0 = NaviStats(alliance of r5)[r1]
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattleNaviStatsByte_AllianceFromBattleObject.yaml
	thumb_func_start GetBattleNaviStatsByte_AllianceFromBattleObject
GetBattleNaviStatsByte_AllianceFromBattleObject:
	push {r6,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r6, r1
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	ldrb r0, [r0,r6]
	pop {r6,pc}
	thumb_func_end GetBattleNaviStatsByte_AllianceFromBattleObject

	thumb_local_start
GetBattleNaviStatsByte_AllianceFromBattleObject_8013782:
	push {r6,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r6, r1
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	ldrb r0, [r0,r6]
	pop {r6,pc}
	thumb_func_end GetBattleNaviStatsByte_AllianceFromBattleObject_8013782

	thumb_func_start GetBattleNaviStatsHword_AllianceFromBattleObject
GetBattleNaviStatsHword_AllianceFromBattleObject:
	push {r6,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r6, r1
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	ldrh r0, [r0,r6]
	pop {r6,pc}
	thumb_func_end GetBattleNaviStatsHword_AllianceFromBattleObject

// (int a1, int a2, int a3) -> void
// symdb: Writes one byte into the NaviStats record belonging to the navi currently selected in the PET.
// symdb: void SetCurPETNaviStatsByte(int statsSelector /*r0*/, int fieldOffset /*r1*/, u8 value /*r2*/);
// symdb: trashes r0, r3, flags(nzcv); preserves r1, r2
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetCurPETNaviStatsByte.yaml
	thumb_func_start SetCurPETNaviStatsByte
SetCurPETNaviStatsByte:
	push {lr}
	push {r1,r2}
	bl GetNaviStatsIndexGivenCurPETNavi // (int idx) -> bool8
	pop {r1,r2}
	mov r3, #oNaviStats_Size
	mul r0, r3
	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0
	strb r2, [r3,r1]
	pop {pc}
	thumb_func_end SetCurPETNaviStatsByte

// (int a1, int a2) -> u8
// symdb: Reads one byte of the NaviStats struct for the navi currently selected on the PET, at a caller-chosen field offset.
// symdb: int GetCurPETNaviStatsByte(u32 naviStatsFieldOffset /*r1*/); // r0 in: unused by caller? passed
// symdb: to helper via GetNaviStatsIndexGivenCurPETNavi; out: byte value; r3 out: address of byte read;
// symdb: c,v out: flags from base+offset add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetCurPETNaviStatsByte.yaml
	thumb_func_start GetCurPETNaviStatsByte
GetCurPETNaviStatsByte:
	push {lr}
	push {r1}
	bl GetNaviStatsIndexGivenCurPETNavi // (int idx) -> bool8
	pop {r1}
	mov r3, #oNaviStats_Size
	mul r0, r3
	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0
	ldrb r0, [r3,r1]
	pop {pc}
	thumb_func_end GetCurPETNaviStatsByte

	thumb_local_start
GetCurPetNaviStatsSignedByte:
	push {lr}
	push {r1}
	bl GetNaviStatsIndexGivenCurPETNavi // (int idx) -> bool8
	pop {r1}
	mov r3, #oNaviStats_Size
	mul r0, r3
	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0
	ldrsb r0, [r3,r1]
	pop {pc}
	thumb_func_end GetCurPetNaviStatsSignedByte

	thumb_func_start SetCurPETNaviStatsHword
// (int structSelectIdx, int structOffset, u16 val) -> void
// symdb: Writes a 16-bit value into a field of the NaviStats entry for the navi currently selected on the PET.
// symdb: void SetCurPETNaviStatsHword(naviId r0, fieldOffset r1, value r2, toolkit r10); out: r0 = entry
// symdb: offset, r3 = written address, flags from the base+offset add; r1/r2 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetCurPETNaviStatsHword.yaml
SetCurPETNaviStatsHword:
	push {lr}
	// Toolkit->NaviStatsPtr[oNaviStats_Size*GetNaviStatsIndexGivenCurPETNavi(a1)+a2] = a3
	push {r1,r2}
	bl GetNaviStatsIndexGivenCurPETNavi // (int idx) -> bool8
	pop {r1,r2}
	mov r3, #oNaviStats_Size
	mul r0, r3
	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0
	strh r2, [r3,r1]
	pop {pc}
	thumb_func_end SetCurPETNaviStatsHword

// symdb: Reads one u16 stat field of the navi currently selected on the PET from the toolkit's navi stats table.
// symdb: u16 GetCurPETNaviStatsHword(u8 which_navi, u8 which_stat); also sets r3 = address read from, c/v
// symdb: from the base+offset addition, and nz from the load
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetCurPETNaviStatsHword.yaml
	thumb_func_start GetCurPETNaviStatsHword
GetCurPETNaviStatsHword: // (which_navi: u8, which_stat: u8) -> u16
	push {lr}
  
	// return Toolkit->S20047CC_Ptrs[100*GetNaviStatsIndexGivenCurPETNavi(a1)+a2]

	push {r1}
	bl GetNaviStatsIndexGivenCurPETNavi // (int idx) -> bool8
	pop {r1}

	mov r3, #oNaviStats_Size
	mul r0, r3

	mov r3, r10
	ldr r3, [r3,#oToolkit_NaviStatsPtr]
	add r3, r3, r0

	ldrh r0, [r3,r1]

	pop {pc}
	thumb_func_end GetCurPETNaviStatsHword

	thumb_func_start GetBattleNaviStats203CB10Byte
GetBattleNaviStats203CB10Byte:
	push {r4,lr}
	mov r4, r1
	bl GetBattleNaviStats203CB10Addr
	ldrb r0, [r0,r4]
	pop {r4,pc}
	thumb_func_end GetBattleNaviStats203CB10Byte

	thumb_local_start
GetBattleNaviStats203CB10Hword:
	push {r4,lr}
	mov r4, r1
	bl GetBattleNaviStats203CB10Addr
	ldrh r0, [r0,r4]
	pop {r4,pc}
	thumb_func_end GetBattleNaviStats203CB10Hword

	thumb_func_start GetBattleNaviStats2034A60Byte
GetBattleNaviStats2034A60Byte:
	push {r6,lr}
	mov r6, r1
	bl GetBattleNaviStats2034A60Addr
	ldrb r0, [r0,r6]
	pop {r6,pc}
	thumb_func_end GetBattleNaviStats2034A60Byte

	thumb_local_start
GetBattleNaviStats2034A60Hword:
	push {r6,lr}
	mov r6, r1
	bl GetBattleNaviStats2034A60Addr
	ldrh r0, [r0,r6]
	pop {r6,pc}
	thumb_func_end GetBattleNaviStats2034A60Hword

	thumb_func_start initNaviStats203CCE0_8013846
initNaviStats203CCE0_8013846:
	push {r4,lr}
	mov r0, #0
	bl GetNaviStats203CCE0Addr
	bl initNaviStats_WithDefaultStatsMaybe_8013438 // (void *struct) -> void
	pop {r4,pc}
	thumb_func_end initNaviStats203CCE0_8013846

	thumb_func_start GetNaviStats203CCE0Addr
GetNaviStats203CCE0Addr:
	mov r1, #oNaviStats_Size
	mul r0, r1
	ldr r1, off_8013860 // =eNaviStats203CCE0
	add r0, r0, r1
	mov pc, lr
	.byte 0, 0
off_8013860:
	.word eNaviStats203CCE0
	thumb_func_end GetNaviStats203CCE0Addr

	thumb_func_start SetNaviStats203CCE0Byte
SetNaviStats203CCE0Byte:
	push {r6,r7,lr}
	mov r0, #0
	mov r6, r1
	mov r7, r2
	bl GetNaviStats203CCE0Addr
	strb r7, [r0,r6]
	pop {r6,r7,pc}
	thumb_func_end SetNaviStats203CCE0Byte

	thumb_func_start SetNaviStats203CCE0Hword
SetNaviStats203CCE0Hword:
	push {r6,r7,lr}
	mov r0, #0
	mov r6, r1
	mov r7, r2
	bl GetNaviStats203CCE0Addr
	strh r7, [r0,r6]
	pop {r6,r7,pc}
	thumb_func_end SetNaviStats203CCE0Hword

	thumb_func_start GetNaviStats203CCE0Byte
GetNaviStats203CCE0Byte:
	push {r6,lr}
	mov r0, #0
	mov r6, r1
	bl GetNaviStats203CCE0Addr
	ldrb r0, [r0,r6]
	pop {r6,pc}
	thumb_func_end GetNaviStats203CCE0Byte

	thumb_local_start
sub_8013892:
	push {r6,r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	mov r6, r0
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0xa
	strh r0, [r5,#oBattleObject_StaminaDamageCounterDisabler]
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne loc_80138BC
	ldr r1, dword_8013908 // =0x10000 
	tst r0, r1
	bne loc_80138BC
	mov r1, #0xe
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xff
	beq loc_80138D2
loc_80138BC:
	mov r1, #0xf
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, r0
	mov r1, #0
	bl sub_8015C2C
	mov r1, #0xe
	mov r2, r0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
loc_80138D2:
	mov r1, #6
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_80138F2
	push {r0}
	bl sub_801A7CC
	pop {r4}
	push {r7}
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	mov r7, #0x60 
	add r7, r7, r0
	bl sub_80E0D98
	pop {r7}
loc_80138F2:
	mov r1, #0x21 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_8013900
	bl sub_801443C
loc_8013900:
	b loc_8013918
	.balign 4, 0
	.word 0x20000
dword_8013908:
	.word 0x10000
	thumb_func_end sub_8013892

	thumb_local_start
sub_801390C:
	push {r6,r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	mov r6, r0
	ldr r7, [r5,#oBattleObject_AIDataPtr]
loc_8013918:
	ldrb r0, [r6,#5]
	strb r0, [r7,#oAIData_BPwrAtk]
	ldrb r0, [r6,#7]
	strb r0, [r7,#oAIData_BLeftAbility]
	ldr r0, off_8013CA8 // =0x8000000
	bl object_clearFlag // (int bitfield) -> void
	bl object_clearInvulnerableTime
	ldr r0, [r7,#oAIData_Unk_50]
	tst r0, r0
	beq loc_8013938
	bl sub_80E5410
	mov r0, #0
	str r0, [r7,#oAIData_Unk_50]
loc_8013938:
	b loc_8013956
	thumb_func_end sub_801390C

	thumb_func_start sub_801393A
sub_801393A:
	push {r6,r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	mov r6, r0
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0x2c 
	ldrb r0, [r6,r1]
	cmp r0, #0
	bne loc_8013956
	ldrb r0, [r6,#5]
	strb r0, [r7,#oAIData_BPwrAtk]
	ldrb r0, [r6,#7]
	strb r0, [r7,#oAIData_BLeftAbility]
loc_8013956:
	mov r0, #0x20 
	ldrb r1, [r6,#0x1b]
	tst r1, r1
	beq loc_8013970
	bl object_setFlag1 // (int a1) -> void
	bl battle_IsNoCustomPlusActive_80107C0
	mov r1, #0x10
	mov r2, #2
	bl object_updateCollisionData
	b loc_8013980
loc_8013970:
	bl object_clearFlag // (int bitfield) -> void
	bl battle_IsNoCustomPlusActive_80107C0
	mov r1, #1
	mov r2, #2
	bl object_updateCollisionData
loc_8013980:
	mov r0, #0x10
	ldrb r1, [r6,#0x1c]
	tst r1, r1
	beq loc_801398E
	bl object_setFlag1 // (int a1) -> void
	b loc_8013992
loc_801398E:
	bl object_clearFlag // (int bitfield) -> void
loc_8013992:
	ldr r0, off_8013CAC // =timer_2000000 
	bl object_setFlag1 // (int a1) -> void
	mov r0, #1
	lsl r0, r0, #0x12
	ldrb r1, [r6,#0x1d]
	tst r1, r1
	beq loc_80139A8
	bl object_setFlag1 // (int a1) -> void
	b loc_80139AC
loc_80139A8:
	bl object_clearFlag // (int bitfield) -> void
loc_80139AC:
	mov r0, #1
	lsl r0, r0, #0x11
	mov r2, #0x23 
	ldrb r1, [r6,r2]
	tst r1, r1
	beq loc_80139BE
	bl object_setFlag1 // (int a1) -> void
	b locret_80139C2
loc_80139BE:
	bl object_clearFlag // (int bitfield) -> void
locret_80139C2:
	pop {r6,r7,pc}
	thumb_func_end sub_801393A

// symdb: On a live player BattleObject, spawns the pink counter-hit ring (obj 0x5E) when the player is in beast-out mode and the AIData+0x5c counter-target pointer is still unset.
// symdb: (r5 = *BattleObject, r10 = *Toolkit) -> void ; side effects: allocates obj 0x5E
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_playerCounterSpawnPinkRingIfReady_80139C4.yaml
	thumb_func_start battleObject_playerCounterSpawnPinkRingIfReady_80139C4
battleObject_playerCounterSpawnPinkRingIfReady_80139C4:
	push {r7,lr}

	ldr r7, [r5,#oBattleObject_AIDataPtr]

	ldrh r0, [r5,#oBattleObject_HP]
	tst r0, r0
	beq locret_80139F4

	ldrb r0, [r7,#oAIData_ActorType]
	cmp r0, #ACTOR_TYPE_PLAYER
	bne locret_80139F4

	ldrb r0, [r7,#oAIData_AIIndex]
	cmp r0, #0xb
	bgt locret_80139F4

	ldrb r0, [r5,#oBattleObject_Alliance]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	cmp r0, #2
	bne locret_80139F4

	add r7, #oAIData_Unk_5c
	ldr r0, [r7]
	tst r0, r0
	bne locret_80139F4

	// The parameter this gets don't seem to agree with what we pass it. r2 is mood from above, but here it asks for y.
	mov r1, #4
	mov r3, #0x10
	bl SpawnCounterPinkRingMaybe_80C4C12 // (x_maybe: u32 , y_maybe: u32 , z_maybe: u32 , params_maybe: u32 , obj: * BattleObject $r5, a7: *u32 $r7) -> * BattleObject

locret_80139F4:
	pop {r7,pc}
	thumb_func_end battleObject_playerCounterSpawnPinkRingIfReady_80139C4

// symdb: Applies a per-turn status/elemental effect (e.g. poison, paralyze, freeze, root, blind, soft-delete) to the navi represented by `r5`'s BattleObject using the byte at `CollisionData+0xA4/0xA5`.
// symdb: (r5 = BattleObject*, r10 = Toolkit*, ...caller-saved r4..r12/lr) -> void
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_applyStatusEffectOnTurnEnd_80139F6.yaml
	thumb_local_start
battleObject_applyStatusEffectOnTurnEnd_80139F6:
	push {r4,lr}
	sub sp, sp, #8
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0xa4
	ldrb r1, [r4,r1]
	str r1, [sp]
	tst r1, r1
	bne loc_8013A08
	b loc_8013ADC
loc_8013A08:
	mov r2, #0xa5
	ldrb r2, [r4,r2]
	str r2, [sp,#4]
	cmp r1, #0x18
	beq loc_8013A16
	cmp r1, #0x19
	bne loc_8013A26
loc_8013A16:
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r2, [sp,#4]
	add r2, r2, r0
	cmp r2, #7
	ble loc_8013ACA
	mov r2, #7
	b loc_8013ACA
loc_8013A26:
	cmp r1, #0x54 
	bne loc_8013A34
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	ldr r2, [sp,#4]
	add r2, r2, r0
	b loc_8013ACA
loc_8013A34:
	cmp r1, #0xff
	bne loc_8013A48
	mov r1, #0x14
	str r1, [sp]
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	add r2, r0, #4
	ble loc_8013A46
	mov r2, #4
loc_8013A46:
	b loc_8013ACA
loc_8013A48:
	cmp r1, #0xfe
	bne loc_8013A5E
	mov r1, #0x12
	mov r2, #4
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0x13
	mov r2, #4
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	b loc_8013ADC
loc_8013A5E:
	cmp r1, #0xfb
	bne loc_8013A68
	bl sub_8014080
	b loc_8013ADC
loc_8013A68:
	cmp r1, #0xfa
	bne loc_8013A7E
	mov r1, #0x12
	mov r2, #4
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0x13
	mov r2, #2
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	b loc_8013ADC
loc_8013A7E:
	cmp r1, #0xf9
	bne loc_8013A94
	mov r1, #0x12
	mov r2, #4
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0x13
	mov r2, #1
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	b loc_8013ADC
loc_8013A94:
	cmp r1, #0xf8
	bne loc_8013AB4
	bl sub_80140EE
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	ldr r0, dword_8013CB0 // =0x100000 
	add r3, r3, r0
	mov r4, #0xe
	bl object_spawnRelatedChildEffect_80E08C4
	mov r0, #0x8e
	bl PlaySoundEffect
	b loc_8013ADC
loc_8013AB4:
	cmp r1, #0xf5
	bne loc_8013ACA
	mov r1, #0x12
	mov r2, #3
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0x13
	mov r2, #1
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	b loc_8013ADC
loc_8013ACA:
	ldr r1, [sp]
	cmp r1, #0x64 
	bge loc_8013ADC
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_801393A
	bl sub_801469C
loc_8013ADC:
	bl sub_800FF5E
	add sp, sp, #8
	pop {r4,pc}
	thumb_func_end battleObject_applyStatusEffectOnTurnEnd_80139F6

// symdb: Applies an alliance-style chip stat bonus (stat 0x18 or 0x19) read from the battle object's collision data, capped at 7.
// symdb: void applyChipAllianceEffect_8013AE4(struct BattleObject* r5_battleObject)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/applyChipAllianceEffect_8013AE4.yaml
	thumb_local_start
applyChipAllianceEffect_8013AE4:
	push {lr}
	sub sp, sp, #8
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0xa4
	ldrb r1, [r3,r1]
	str r1, [sp]
	tst r1, r1
	beq loc_8013B1C
	mov r2, #0xa5
	ldrb r2, [r3,r2]
	str r2, [sp,#4]
	cmp r1, #0x18
	beq loc_8013B02
	cmp r1, #0x19
	bne loc_8013B1C
loc_8013B02:
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r2, [sp,#4]
	add r2, r2, r0
	cmp r2, #7
	ble loc_8013B12
	mov r2, #7
	b loc_8013B12
loc_8013B12:
	ldr r1, [sp]
	cmp r1, #0x64 
	bge loc_8013B1C
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
loc_8013B1C:
	add sp, sp, #8
	pop {pc}
	thumb_func_end applyChipAllianceEffect_8013AE4

// symdb: When a battle object's collision data reports event 0x18, adds the amount in the next collision byte to the AI's counter at oAIData_Unk_12, clamping it at 7.
// symdb: void sub_8013B20(battle_object *r5 /* in r5, object whose CollisionDataPtr/AIDataPtr are read
// symdb: */); clobbers r0-r3, NZCV-defined; preserves r4
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_aiAddCounterFromCollision_8013B20.yaml
	thumb_local_start
battle_aiAddCounterFromCollision_8013B20:
	push {r4,lr}
	sub sp, sp, #8
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0xa4
	ldrb r1, [r3,r1]
	str r1, [sp]
	tst r1, r1
	beq loc_8013B4A
	mov r2, #0xa5
	ldrb r2, [r3,r2]
	str r2, [sp,#4]
	cmp r1, #0x18
	bne loc_8013B4A
	ldrb r0, [r4,#oAIData_Unk_12]
	ldr r2, [sp,#4]
	add r2, r2, r0
	cmp r2, #7
	ble loc_8013B48
	mov r2, #7
loc_8013B48:
	strb r2, [r4,#oAIData_Unk_12]
loc_8013B4A:
	add sp, sp, #8
	pop {r4,pc}
	thumb_func_end battle_aiAddCounterFromCollision_8013B20

// (bool a1, int a2) -> void
	thumb_func_start init_8013B4E
init_8013B4E:
	push {r4,r6,r7,lr}
	cmp r0, #0
	beq loc_8013B56
	mov r0, #1
loc_8013B56:
	mov r4, r1
	mov r7, r10
	ldr r7, [r7,#oToolkit_NaviStatsPtr]
	mov r2, #oNaviStats_Size 
	mul r0, r2
	add r7, r7, r0
	b loc_8013B6E
	thumb_func_end init_8013B4E

// (int idx, int a2) -> void
	thumb_func_start init_8013B64
init_8013B64:
	push {r4,r6,r7,lr}
	mov r4, r1
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	mov r7, r0
loc_8013B6E:
	mov r0, r7
	bl initNaviStats_WithDefaultStatsMaybe_8013438 // (void *struct) -> void
	mov r0, #0x10
	mul r0, r4
	ldr r6, off_8013CB4 // =byte_80210DD 
	add r6, r6, r0
	mov r1, #oNaviStats_NaviIndex 
	strb r4, [r7,r1]
	ldrb r0, [r6]
	add r0, r0, r0
	mov r1, #oNaviStats_CurHP 
	strh r0, [r7,r1]
	mov r1, #oNaviStats_MaxHP 
	strh r0, [r7,r1]
	mov r1, #oNaviStats_MaxBaseHP 
	strh r0, [r7,r1]
	ldrb r0, [r6,#1]
	mov r1, #oNaviStats_SuperArmor 
	strb r0, [r7,r1]
	ldrb r0, [r6,#2]
	strb r0, [r7,#oNaviStats_FloatShoes]
	ldrb r0, [r6,#3]
	strb r0, [r7,#oNaviStats_AirShoes]
	ldrb r0, [r6,#4]
	mov r1, #oNaviStats_UnderShirt
	strb r0, [r7,r1]
	ldrb r0, [r6,#5]
	strb r0, [r7,#oNaviStats_FstBarr]
	ldrb r0, [r6,#6]
	strb r0, [r7,#oNaviStats_MegaLevel]
	ldrb r0, [r6,#7]
	strb r0, [r7,#oNaviStats_GigaLevel]
	ldrb r0, [r6,#8]
	strb r0, [r7,#oNaviStats_BButton]
	ldrb r0, [r6,#9]
	strb r0, [r7,#oNaviStats_BPwrAtk]
	ldrb r0, [r6,#0xa]
	strb r0, [r7,#oNaviStats_BLeftAbility]
	ldrb r0, [r6,#0xb]
	mov r1, #0x46 
	strh r0, [r7,r1]
	ldrb r0, [r6,#0xc]
	mov r1, #0x4a 
	strh r0, [r7,r1]
	ldrb r0, [r6,#0xd]
	mov r1, #0x48 
	strh r0, [r7,r1]
	ldrb r0, [r6,#0xe]
	strb r0, [r7]
	ldrb r0, [r6,#0xf]
	mov r1, #0x39 
	strb r0, [r7,r1]
	pop {r4,r6,r7,pc}
	thumb_func_end init_8013B64

	thumb_local_start
sub_8013BDA:
	push {r4,r6,r7,lr}
	mov r7, r0
	mov r4, r1
	mov r0, r7
	bl initNaviStats_WithDefaultStatsMaybe_8013438 // (void *struct) -> void
	mov r0, #0x10
	mul r0, r4
	ldr r6, off_8013CB8 // =byte_80210DD 
	add r6, r6, r0
	mov r1, #0x29 
	strb r4, [r7,r1]
	add r0, r4, r4
	ldr r1, off_8013CBC // =dword_802F0A8
	ldrh r0, [r0,r1]
	mov r1, #0x40 
	strh r0, [r7,r1]
	mov r1, #0x42 
	strh r0, [r7,r1]
	mov r1, #0x3e 
	strh r0, [r7,r1]
	ldrb r0, [r6,#1]
	mov r1, #0x23 
	strb r0, [r7,r1]
	ldrb r0, [r6,#2]
	strb r0, [r7,#0x1b]
	ldrb r0, [r6,#3]
	strb r0, [r7,#0x1c]
	ldrb r0, [r6,#4]
	mov r1, #0x1d
	strb r0, [r7,r1]
	ldrb r0, [r6,#5]
	strb r0, [r7,#6]
	ldrb r0, [r6,#6]
	strb r0, [r7,#0xb]
	ldrb r0, [r6,#7]
	strb r0, [r7,#0xc]
	ldrb r0, [r6,#8]
	strb r0, [r7,#4]
	ldrb r0, [r6,#9]
	strb r0, [r7,#5]
	ldrb r0, [r6,#0xa]
	strb r0, [r7,#7]
	ldrb r0, [r6,#0xb]
	mov r1, #0x46 
	strh r0, [r7,r1]
	ldrb r0, [r6,#0xc]
	mov r1, #0x4a 
	strh r0, [r7,r1]
	ldrb r0, [r6,#0xd]
	mov r1, #0x48 
	strh r0, [r7,r1]
	ldrb r0, [r6,#0xe]
	strb r0, [r7]
	ldrb r0, [r6,#0xf]
	mov r1, #0x39 
	strb r0, [r7,r1]
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8013BDA

	thumb_local_start
sub_8013C4E:
	push {r4,r6,lr}
	ldr r0, dword_8013CC0 // =0x20000 
	bl object_clearFlag // (int bitfield) -> void
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r6, r0
	lsl r6, r6, #2
	ldr r1, off_8013C6C // =off_8013C70 
	ldr r1, [r6,r1]
	mov lr, pc
	bx r1
	pop {r4,r6,pc}
	.balign 4, 0
off_8013C6C:
	.word off_8013C70
off_8013C70:
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	.word nullsub_28+1
	thumb_func_end sub_8013C4E

	thumb_local_start
nullsub_28:
	mov pc, lr
	.balign 4, 0x00
off_8013CA8:
	.word 0x8000001
off_8013CAC:
	.word 0x2000000
dword_8013CB0:
	.word 0x100000
off_8013CB4:
	.word byte_80210DD
off_8013CB8:
	.word byte_80210DD
off_8013CBC:
	.word dword_802F0A8
dword_8013CC0:
	.word 0x20000
	thumb_func_end nullsub_28

// symdb: Navi-AI panel-altering behavior: with a probability tied to the Navi's stats, converts/recolors/cracks/breaks the panel under the Navi's feet and plays a panel-type SFX.
// symdb: void sub_8013CC4(u32 obj, u32 param, /* via r5 */ u32 battleObject); // clobbers r0-r3, r4-r7,
// symdb: r10, lr; flags NZCV
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/naviAi_changePanel_8013CC4.yaml
	thumb_func_start naviAi_changePanel_8013CC4
naviAi_changePanel_8013CC4:
	push {r4-r7,lr}
	mov r6, r0
	mov r7, r1
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrb r1, [r0,#oAIData_ActorType]
	cmp r1, #2
	bne locret_8013D3C
	mov r1, #0x13
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, r0
	beq locret_8013D3C
	bl GetPositiveSignedRNG
	mov r1, #7
	and r0, r1
	sub r4, #1
	cmp r0, r4
	bgt locret_8013D3C
	mov r1, #0x12
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, r0
	mov r0, r6
	mov r1, r7
	bl object_getPanelDataOffset
	ldrb r5, [r0,#oPanelData_Type]
	cmp r5, #1
	beq locret_8013D3C
	cmp r5, #0
	beq locret_8013D3C
	cmp r4, #1
	bne loc_8013D12
	mov r0, r6
	mov r1, r7
	bl object_breakPanel_dup2
	b locret_8013D3C
loc_8013D12:
	cmp r4, #3
	bne loc_8013D20
	mov r0, r6
	mov r1, r7
	bl object_crackPanelDup1
	b locret_8013D3C
loc_8013D20:
	mov r0, r6
	mov r1, r7
	mov r2, r4
	bl object_setPanelType
	cmp r4, r5
	beq locret_8013D3C
	add r1, r4, r4
	ldr r0, off_8013D40 // =byte_8013D44 
	ldrh r0, [r0,r1]
	tst r0, r0
	beq locret_8013D3C
	bl PlaySoundEffect
locret_8013D3C:
	pop {r4-r7,pc}
	.balign 4, 0
off_8013D40:
	.word byte_8013D44
byte_8013D44:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x90, 0x0, 0xA4, 0x0, 0x1B, 0x1
	.byte 0x18, 0x1, 0x1C, 0x1, 0xFC, 0x0, 0xFC, 0x0, 0xFC, 0x0, 0xFC, 0x0
	thumb_func_end naviAi_changePanel_8013CC4

// symdb: Stat-gated weighted pick for the charge shot: builds a 16-entry list from NaviStats bytes 0x14 (1s) and 0x15 (2s), then one primary draw & 0xF picks from it; 0 when both stats are 0.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8013D5E.yaml
	thumb_func_start sub_8013D5E
sub_8013D5E:
	push {r4-r7,lr}
	sub sp, sp, #0x10
	mov r4, #0
	add r7, sp, #0
	str r4, [sp]
	str r4, [sp,#4]
	str r4, [sp,#8]
	str r4, [sp,#0xc]
	mov r1, #0x14
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #1
loc_8013D76:
	sub r0, #1
	blt loc_8013D80
	strb r1, [r7,r4]
	add r4, #1
	b loc_8013D76
loc_8013D80:
	mov r1, #0x15
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #2
loc_8013D88:
	sub r0, #1
	blt loc_8013D92
	strb r1, [r7,r4]
	add r4, #1
	b loc_8013D88
loc_8013D92:
	bl GetRNG // () -> u32?
	mov r1, #0xf
	and r0, r1
	ldrb r0, [r7,r0]
	add sp, sp, #0x10
	pop {r4-r7,pc}
	thumb_func_end sub_8013D5E

// symdb: Per-frame AI tick for a battle navi that gates on three navi-stat fields, runs a 60-frame decision timer, picks a new AI state from a 16-slot weighted table using positive RNG, and dispatches to one of four action routines.
// symdb: void sub_8013DA0(u32 /*r5*/ battleObject, u32 /*r10*/ ?, u32 /*lr*/ link); clobbers nzcv r0-r3
// symdb: r12 lr; preserves r4 r5 r6 r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_naviAI_tick_8013DA0.yaml
	thumb_func_start battle_naviAI_tick_8013DA0
battle_naviAI_tick_8013DA0:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x10
	bl battle_isPaused
	bne loc_8013E38
	mov r1, #0x24 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	tst r0, r0
	beq loc_8013E38
	mov r1, #0x21 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	tst r0, r0
	beq loc_8013E38
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_8013DD2
	bl battleObject_markUsedAction_80143A6
	bl sub_8014446
	b loc_8013E38
loc_8013DD2:
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r4,#oAIData_Unk_3a]
	add r0, #1
	strh r0, [r4,#oAIData_Unk_3a]
	cmp r0, #0x3c 
	blt loc_8013E38
	mov r0, #0
	strh r0, [r4,#oAIData_Unk_3a]
	bl battleObject_markUsedAction_80143A6
	bl sub_8014446
	ldrb r6, [r4,#oAIData_Unk_0b]
	ldr r0, off_8013E3C // =byte_8013E44
	mov r2, #0
	mov r7, #0
loc_8013DF2:
	ldrb r1, [r0,r2]
	cmp r1, r6
	bne loc_8013E00
	mov r1, #1
	cmp r6, #0
	beq loc_8013E00
	mov r1, #0
loc_8013E00:
	add r3, sp, #0
	strb r1, [r3,r7]
	add r7, #1
	add r2, #1
	cmp r2, #0x10
	blt loc_8013DF2
	bl GetPositiveSignedRNG
	mov r1, r7
	svc 6
	add r0, sp, #0
	ldrb r0, [r0,r1]
	strb r0, [r4,#oAIData_Unk_0b]
	cmp r0, #2
	beq loc_8013E2E
	cmp r0, #1
	beq loc_8013E34
	ldr r1, off_8013E40 // =dword_8013E54
	ldrb r1, [r1,r0]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_setPlayerNaviStatsField0E_8015BEC
	b loc_8013E38
loc_8013E2E:
	bl sub_80143CE
	b loc_8013E38
loc_8013E34:
	bl sub_801443C
loc_8013E38:
	add sp, sp, #0x10
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8013E3C:
	.word byte_8013E44
off_8013E40:
	.word dword_8013E54
byte_8013E44:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x2, 0x3
dword_8013E54:
	.word 0xFF003C99
	thumb_func_end battle_naviAI_tick_8013DA0

// symdb: Reads the battle object's alliance navi stats byte 0x1A and dispatches one of nine handlers from a table, randomizing among entries 1-4 or 5-8 when the byte is 9 or 10.
// symdb: void sub_8013E58(r5, r10); r5/r10 passed through to callees, r4 = 0 or 4 (half selector) on
// symdb: tail-call, r1 = table base; r4 preserved for caller
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8013E58.yaml
	thumb_local_start
sub_8013E58:
	push {r4,lr}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne loc_8013E6C
	bl GetBattleMode
	cmp r0, #1
	beq loc_8013E6C
loc_8013E6C:
	mov r1, #0x1a
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, #0
	cmp r0, #9
	beq loc_8013E7E
	mov r4, #4
	cmp r0, #0xa
	bne loc_8013E8A
loc_8013E7E:
	bl GetRNG // () -> u32?
	mov r1, #3
	and r0, r1
	add r0, r0, r4
	add r0, #1
loc_8013E8A:
	lsl r0, r0, #2
	ldr r1, off_8013E98 // =off_8013E9C 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r4,pc}
	.balign 4, 0
off_8013E98:
	.word off_8013E9C
off_8013E9C:
	.word nullsub_45+1
	.word sub_8013EC2+1
	.word sub_8013ECC+1
	.word sub_8013ED6+1
	.word sub_8013EE6+1
	.word sub_8013EF0+1
	.word sub_8013EFA+1
	.word sub_8013F04+1
	.word sub_8013F14+1
	thumb_func_end sub_8013E58

// symdb: Empty stub that does nothing and immediately returns; likely a placeholder for a removed or disabled call site.
// symdb: void nullsub_45(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_45.yaml
	thumb_local_start
nullsub_45:
	mov pc, lr
	thumb_func_end nullsub_45

	thumb_local_start
sub_8013EC2:
	push {r4,lr}
	ldr r4, off_80141BC // =0x12c 
	bl sub_8010474
	pop {r4,pc}
	thumb_func_end sub_8013EC2

	thumb_local_start
sub_8013ECC:
	push {lr}
	ldr r0, off_80141BC // =0x12c 
	bl object_setInvulnerableTime
	pop {pc}
	thumb_func_end sub_8013ECC

	thumb_local_start
sub_8013ED6:
	push {lr}
	ldr r0, off_80141BC // =0x12c 
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r1,#oCollisionData_BlindTimer]
	mov r0, #0x20 
	bl object_setFlag2
	pop {pc}
	thumb_func_end sub_8013ED6

	thumb_local_start
sub_8013EE6:
	push {lr}
	ldr r0, off_80141BC // =0x12c 
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r1,#oCollisionData_Unk_1e]
	pop {pc}
	thumb_func_end sub_8013EE6

	thumb_local_start
sub_8013EF0:
	push {r4,lr}
	ldr r4, off_80141C0 // =0x258 
	bl sub_8010474
	pop {r4,pc}
	thumb_func_end sub_8013EF0

	thumb_local_start
sub_8013EFA:
	push {lr}
	ldr r0, off_80141C0 // =0x258 
	bl object_setInvulnerableTime
	pop {pc}
	thumb_func_end sub_8013EFA

	thumb_local_start
sub_8013F04:
	push {lr}
	ldr r0, off_80141C0 // =0x258 
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r1,#oCollisionData_BlindTimer]
	mov r0, #0x20 
	bl object_setFlag2
	pop {pc}
	thumb_func_end sub_8013F04

	thumb_local_start
sub_8013F14:
	push {lr}
	ldr r0, off_80141C0 // =0x258 
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r1,#oCollisionData_Unk_1e]
	pop {pc}
	thumb_func_end sub_8013F14

// symdb: After a hit lands, sums the three panel-damage slots on the attacker's collision record; if any damage was dealt, updates the AI's "did damage" latch and dispatches to the per-alliance damage handler (null for one team, sub_8013F82/F8C/F96 for the others).
// symdb: void handlePanelDamage_8013F1E(u32 obj /* r5 */); /* reads r5, returns nothing; flags NZVC
// symdb: clobbered */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/handlePanelDamage_8013F1E.yaml
	thumb_local_start
handlePanelDamage_8013F1E:
	push {lr}
	bl object_getFlag2
	ldr r1, off_80141C4 // =0x104 
	tst r0, r1
	beq locret_8013F68
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	ldr r0, [r1,#oCollisionData_FlagsFromCollision]
	cmp r0, #0
	beq locret_8013F68
	// misaligned word reads, base is 0x82
	add r1, #oCollisionData_PanelDamage1
	ldr r0, [r1,#oCollisionData_PanelDamage1and2 - oCollisionData_PanelDamage1]
	ldr r2, [r1,#oCollisionData_PanelDamage3and4 - oCollisionData_PanelDamage1]
	add r0, r0, r2
	ldr r2, [r1,#oCollisionData_PanelDamage5and6 - oCollisionData_PanelDamage1]
	add r0, r0, r2
	cmp r0, #0
	beq locret_8013F68
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrb r1, [r5,#oBattleObject_PreventAnim]
	cmp r1, #0
	bne loc_8013F4E
	strb r1, [r0,#oAIData_Unk_1c]
	b loc_8013F58
loc_8013F4E:
	ldrb r1, [r0,#oAIData_Unk_1c]
	cmp r1, #0
	bne locret_8013F68
	mov r1, #1
	strb r1, [r0,#oAIData_Unk_1c]
loc_8013F58:
	mov r1, #0x16
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	lsl r0, r0, #2
	ldr r1, off_8013F6C // =off_8013F70 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
locret_8013F68:
	pop {pc}
	.balign 4, 0
off_8013F6C:
	.word off_8013F70
off_8013F70:
	.word nullsub_46+1
	.word sub_8013F82+1
	.word sub_8013F8C+1
	.word sub_8013F96+1
	thumb_func_end handlePanelDamage_8013F1E

// symdb: Empty do-nothing stub that returns immediately to the caller.
// symdb: void nullsub_46(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_46.yaml
	thumb_local_start
nullsub_46:
	mov pc, lr
	thumb_func_end nullsub_46

	thumb_local_start
sub_8013F82:
	push {lr}
	mov r0, #0x32 
	bl object_setCollisionStatusEffect2
	pop {pc}
	thumb_func_end sub_8013F82

	thumb_local_start
sub_8013F8C:
	push {lr}
	mov r0, #0x22 
	bl object_setCollisionStatusEffect2
	pop {pc}
	thumb_func_end sub_8013F8C

	thumb_local_start
sub_8013F96:
	push {lr}
	mov r1, #0x18
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	add r0, #1
	cmp r0, #7
	bgt locret_8013FAC
	mov r2, r0
	mov r1, #0x18
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
locret_8013FAC:
	pop {pc}
	thumb_func_end sub_8013F96

// symdb: Rolls a d8 against a battle object's navi stat byte 0x11, returning 1 (success) if the roll is within the stat value.
// symdb: int battle_RollNaviStatChance(void *battleObj /* r4 */); -> r0 = 1 on success, 0 on fail; sets
// symdb: NZ/C/V from the final CMP (or from the stat==0 exit)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_RollNaviStatChance_8013FAE.yaml
	thumb_func_start battle_RollNaviStatChance_8013FAE
battle_RollNaviStatChance_8013FAE:
	push {r4,lr}
	mov r1, #0x11
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, r0
	beq locret_8013FCE
	bl GetRNG // () -> u32?
	mov r1, #7
	and r0, r1
	sub r1, r4, #1
	cmp r0, r1
	bgt loc_8013FCC
	mov r0, #1
	pop {r4,pc}
loc_8013FCC:
	mov r0, #0
locret_8013FCE:
	pop {r4,pc}
	thumb_func_end battle_RollNaviStatChance_8013FAE

// symdb: Deal a non-lethal hit to the player — subtract the damage amount from the player's HP but never below 1, then play the hit sound effect.
// symdb: void battle_damagePlayerLeave1HP(u32 damage /* r0 */); clobbers r0, r1, lr and NZCV; preserves
// symdb: r3-r7, r10
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_damagePlayerLeave1HP_8013FD0.yaml
	thumb_func_start battle_damagePlayerLeave1HP_8013FD0
battle_damagePlayerLeave1HP_8013FD0:
	push {r5,lr}
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r5, r0
	beq locret_8013FF6
	mov r1, #0x54 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	tst r0, r0
	beq locret_8013FF6
	ldrh r1, [r5,#0x24]
	cmp r1, r0
	bgt loc_8013FEC
	sub r0, r1, #1
loc_8013FEC:
	bl object_subtractHP
	mov r0, #SOUND_HIT_6B
	bl PlaySoundEffect
locret_8013FF6:
	pop {r5,pc}
	thumb_func_end battle_damagePlayerLeave1HP_8013FD0

// symdb: Deals a poison-style damage tick to a battle object, sized by its navi stats byte 0x3D, but never dropping its HP below 1.
// symdb: void sub_8013FF8(u32 r4, BattleObject* r5 /* object */, u32 r6); // preserves r4/r6, returns
// symdb: r1/r2 and flags from the damage path
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_applyNaviStatDamageTick_8013FF8.yaml
	thumb_local_start
battle_applyNaviStatDamageTick_8013FF8:
	push {lr}
	mov r1, #0x3d 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	tst r0, r0
	beq locret_8014016
	sub r2, r0, #1
	ldrh r1, [r5,#oBattleObject_HP]
	cmp r1, #1
	beq locret_8014016
	cmp r1, r2
	bgt loc_8014012
	sub r0, r1, #1
loc_8014012:
	bl object_subtractHP
locret_8014016:
	pop {pc}
	thumb_func_end battle_applyNaviStatDamageTick_8013FF8

	thumb_func_start GetNaviStatsIndexGivenCurPETNavi
// (int idx) -> bool8
// symdb: Translates the currently selected PET navi ID into which navi-stats slot it uses: Megaman uses slot 0, all other navis use slot 1.
// symdb: u8 GetNaviStatsIndexGivenCurPETNavi(u8 naviId) // in: r0 = current PET navi ID; out: r0 = navi-
// symdb: stats index (0 or 1); clobbers r1 only for the table address
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetNaviStatsIndexGivenCurPETNavi.yaml
GetNaviStatsIndexGivenCurPETNavi:
    // return CurPETNaviToNaviStatsIndexTable[a1]
	// maps Megaman to use index 0, and all other navis
	// to use index 1
	ldr r1, =CurPETNaviToNaviStatsIndexTable
	ldrb r0, [r1,r0]
	mov pc, lr
	thumb_func_end GetNaviStatsIndexGivenCurPETNavi

	thumb_func_start GetNaviStatsAddrGivenCurPETNavi
// (int a1) -> void*
// symdb: Returns a pointer to the NaviStats struct (entry size 0x64) for the navi currently selected in the PET.
// symdb: Next GetNaviStatsAddrGivenCurPETNavi(int currentPETNaviId, Toolkit *toolkit /* r10 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetNaviStatsAddrGivenCurPETNavi.yaml
GetNaviStatsAddrGivenCurPETNavi:
	push {lr}
	// return &Toolkit->S20047CC_Ptrs[100*GetNaviStatsIndexGivenCurPETNavi(a1)]
	bl GetNaviStatsIndexGivenCurPETNavi // (int idx) -> bool8
	mov r1, #0x64 
	mul r0, r1
	mov r1, r10
	ldr r1, [r1,#oToolkit_NaviStatsPtr]
	add r0, r0, r1
	pop {pc}
	// 8014030
	.pool
	.balign 4, 0
CurPETNaviToNaviStatsIndexTable:
	.byte 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1
	thumb_func_end GetNaviStatsAddrGivenCurPETNavi

// symdb: Per-tick HP regeneration for the player, healing ceil(navi stat 0x3E/10) HP and showing the heal effect and sound when regeneration is enabled.
// symdb: void sub_8014040(int alliance /* r0: which side's player to regenerate */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_playerHPRegenTick_8014040.yaml
	thumb_func_start battle_playerHPRegenTick_8014040
battle_playerHPRegenTick_8014040:
	push {r4,r5,lr}
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r5, r0
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne locret_801407E
	mov r1, #0x36 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #1
	bne locret_801407E
	mov r1, #0x3e 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	add r0, #9
	mov r1, #0xa
	svc 6
	bl object_addHP
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #6
	bl spawn_t1_0x0_EffectObject
	mov r0, #SOUND_UNK_8A
	bl PlaySoundEffect
locret_801407E:
	pop {r4,r5,pc}
	thumb_func_end battle_playerHPRegenTick_8014040

	thumb_local_start
sub_8014080:
	push {lr}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne locret_80140EC
	mov r0, #1
	lsl r0, r0, #0x11
	bl object_clearFlag // (int bitfield) -> void
	mov r1, #0x23 
	mov r2, #0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r0, #0x20 
	bl object_clearFlag // (int bitfield) -> void
	bl battle_IsNoCustomPlusActive_80107C0
	mov r1, #1
	mov r2, #2
	bl object_updateCollisionData
	mov r1, #0x1b
	mov r2, #0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r0, #1
	lsl r0, r0, #0x12
	bl object_clearFlag // (int bitfield) -> void
	mov r1, #0x1d
	mov r2, #0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r0, #0x10
	bl object_clearFlag // (int bitfield) -> void
	mov r1, #0x1c
	mov r2, #0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #7
	mov r2, #0xff
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne locret_80140EC
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0xff
	strb r1, [r0,#oAIData_BLeftAbility]
locret_80140EC:
	pop {pc}
	thumb_func_end sub_8014080

	thumb_local_start
sub_80140EE:
	push {lr}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne locret_801414E
	mov r0, #1
	lsl r0, r0, #0x11
	bl object_clearFlag // (int bitfield) -> void
	mov r1, #0x23 
	mov r2, #0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r0, #0x20 
	bl object_clearFlag // (int bitfield) -> void
	bl battle_IsNoCustomPlusActive_80107C0
	mov r1, #1
	mov r2, #2
	bl object_updateCollisionData
	mov r1, #0x1b
	mov r2, #0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r0, #0x10
	bl object_clearFlag // (int bitfield) -> void
	mov r1, #0x1c
	mov r2, #0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #7
	mov r2, #0xff
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_801414A
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0xff
	strb r1, [r0,#oAIData_BLeftAbility]
loc_801414A:
	bl sub_801469C
locret_801414E:
	pop {pc}
	thumb_func_end sub_80140EE

// symdb: Returns 2/1/0 depending on which of two unlock/stat flags (0x38, then 0x37) is set on the currently equipped PET Navi.
// symdb: int getCurNaviStatTier(void) // preserves r4, r10; result in r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getCurNaviStatTier_8014150.yaml
	thumb_func_start getCurNaviStatTier_8014150
getCurNaviStatTier_8014150:
	push {r4,lr}
	mov r4, #2
	bl GetCurPETNavi // () -> u8
	mov r1, #0x38 
	bl GetCurPETNaviStatsByte // (int a1, int a2) -> u8
	tst r0, r0
	bne loc_8014174
	mov r4, #1
	bl GetCurPETNavi // () -> u8
	mov r1, #0x37 
	bl GetCurPETNaviStatsByte // (int a1, int a2) -> u8
	tst r0, r0
	bne loc_8014174
	mov r4, #0
loc_8014174:
	mov r0, r4
	pop {r4,pc}
	thumb_func_end getCurNaviStatTier_8014150

// symdb: Reads two stat slots (kind 8) of the current navi, indexes a 12-byte table with stat1*3+stat0, and hands the looked-up value (0x10/0x20/0x40) to sub_801DF8C.
// symdb: void sub_8014178(void); // in: r4, r6 preserved across call, lr; out: byte passed to sub_801DF8C
// symdb: in r0; clobbers r0, r1, lr, NZ flags; C/V reflect the final index add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_applyNaviStatTableEntry_8014178.yaml
	thumb_func_start battle_applyNaviStatTableEntry_8014178
battle_applyNaviStatTableEntry_8014178:
	push {r4,lr}
	mov r0, #0
	mov r1, #8
	bl GetBattleNaviStatsByte
	mov r4, r0
	mov r0, #1
	mov r1, #8
	bl GetBattleNaviStatsByte
	mov r1, #3
	mul r0, r1
	add r0, r0, r4
	ldr r4, off_801419C // =byte_80141A0 
	ldrb r0, [r4,r0]
	bl battle_setEnemyCountFromNaviStats_801DF8C
	pop {r4,pc}
	.balign 4, 0
off_801419C:
	.word byte_80141A0
byte_80141A0:
	.byte 0x20, 0x40, 0x10, 0x40, 0x40, 0x20, 0x10, 0x20, 0x10
	.byte 0x0, 0x0, 0x0
	thumb_func_end battle_applyNaviStatTableEntry_8014178

// symdb: Sets the current PET navi's Beast Out counter to 3, re-arming the Beast Out turn limit (e.g. when a Beast Out transformation ends).
// symdb: void SetBeastOutCounterTo3(void); /* in: r10 (PET context used by GetCurPETNavi), lr; clobbers
// symdb: r0-r3, flags; returns to caller via pop {pc} */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetBeastOutCounterTo3.yaml
	thumb_func_start SetBeastOutCounterTo3
SetBeastOutCounterTo3:
	push {lr}
	bl GetCurPETNavi // () -> u8
	mov r1, #oNaviStats_BeastOutCounter
	mov r2, #3
	bl SetCurPETNaviStatsByte // (int a1, int a2, int a3) -> void
	pop {pc}
	.balign 4, 0
off_80141BC:
	.word 0x12C
off_80141C0:
	.word 0x258
off_80141C4:
	.word 0x104
	thumb_func_end SetBeastOutCounterTo3

// symdb: Initializes a player BattleObject's HP and MaxHP from NaviStats, optionally clamps MaxHP by a battle-effect flag, and conditionally triggers sub_801E0BC for the enemy-side network invert.
// symdb: (r5 = *BattleObject) -> (flags Z) ; side effects: writes [r5+0x24..0x27] (HP/MaxHP) and may call
// symdb: sub_801E0BC
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_initPlayerMaxHPFromStats_80141C8.yaml
	thumb_local_start
battleObject_initPlayerMaxHPFromStats_80141C8:
	push {lr}
	mov r1, #0x42 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	strh r0, [r5,#oBattleObject_HP]
	strh r0, [r5,#oBattleObject_MaxHP]
	bl GetBattleEffects // () -> int
	mov r1, #4
	tst r0, r1
	bne loc_80141E6
	mov r1, #0x40 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	strh r0, [r5,#oBattleObject_HP]
loc_80141E6:
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	bne locret_80141F2
	bl sub_801E0BC
locret_80141F2:
	pop {pc}
	thumb_func_end battleObject_initPlayerMaxHPFromStats_80141C8

// symdb: Raises a flag (0x400) in the battle AI data's 0x48 field unless the board uses a standard column pattern or the battle is the Dustman mini game.
// symdb: void sub_80141F4(void); // no meaningful inputs/outputs; r1/r3 pass through from callees, only
// symdb: flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_EnableAIUnk0x48FlagForNonstandardBoard_80141F4.yaml
	thumb_local_start
battle_EnableAIUnk0x48FlagForNonstandardBoard_80141F4:
	push {lr}
	bl GetBattlePanelColumnPattern
	cmp r0, #0x38 // default pattern
	beq locret_8014214
	cmp r0, #0x30 // disadvantaged
	beq locret_8014214
	cmp r0, #0x3c // advantaged
	beq locret_8014214
	bl GetBattleMode
	cmp r0, #BATTLE_MODE_DUSTMAN_MINI_GAME
	beq locret_8014214
	ldr r0, dword_80142D8 // =0x400 
	bl SetAIDataUnk0x48Flag
locret_8014214:
	pop {pc}
	thumb_func_end battle_EnableAIUnk0x48FlagForNonstandardBoard_80141F4

	thumb_func_start sub_8014216
sub_8014216:
	push {lr}
	mov r0, #0x20 
	bl ClearAIDataUnk0x48Flag
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getBattleHandAddr_8010018
	add r0, #0x26 
	mov r1, #0xc
	bl ZeroFillByHalfword
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_8014256
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	tst r0, r0
	bne loc_8014256
	push {r5}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r5, r0
	beq loc_8014254
	bl releaseSlotByValue_801DC36
loc_8014254:
	pop {r5}
loc_8014256:
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	lsl r0, r0, #2
	ldr r1, off_8014268 // =off_801426C 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {pc}
	.balign 4, 0
off_8014268:
	.word off_801426C
off_801426C:
	.word sub_801429C+1
	.word nullsub_47+1
	.word nullsub_47+1
	.word nullsub_47+1
	.word nullsub_47+1
	.word nullsub_47+1
	.word nullsub_47+1
	.word nullsub_47+1
	.word nullsub_47+1
	.word nullsub_47+1
	.word nullsub_47+1
	.word nullsub_47+1
	thumb_func_end sub_8014216

	thumb_local_start
sub_801429C:
	push {lr}
	bl sub_80144CA
	pop {pc}
	thumb_func_end sub_801429C

	thumb_local_start
sub_80142A4:
	push {lr}
	mov r0, #0x20 
	bl SetAIDataUnk0x48Flag
	pop {pc}
	thumb_func_end sub_80142A4

	thumb_local_start
nullsub_47:
	mov pc, lr
	thumb_func_end nullsub_47

// symdb: If the active battle effects flag a damage-over-time status, writes a fixed pending damage of 10 to the battle object.
// symdb: void battle_applyStatusTickDamage(BattleObject* obj /* r5 */); reads battle effect flags via
// symdb: GetBattleEffects(); r10 is passed by callers but never read
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_applyStatusTickDamage_80142B0.yaml
	thumb_local_start
battle_applyStatusTickDamage_80142B0:
	push {lr}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq locret_80142C0
	mov r0, #0xa
	strh r0, [r5,#oBattleObject_Damage]
locret_80142C0:
	pop {pc}
	thumb_func_end battle_applyStatusTickDamage_80142B0

// symdb: If the active battle effects include flag 0x8, writes a self-damage value of 10 into the battle object's collision data.
// symdb: void battle_applySelfDamageFromBattleEffect(r5 battleObject, r10) // reads r5 = battle object;
// symdb: out r0 = battle effects or 0xA, r1 = 8 or collision ptr, nz from last op
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_applySelfDamageFromBattleEffect_80142C2.yaml
	thumb_func_start battle_applySelfDamageFromBattleEffect_80142C2
battle_applySelfDamageFromBattleEffect_80142C2:
	push {lr}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq locret_80142D4
	mov r0, #0xa
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r1,#oCollisionData_SelfDamage]
locret_80142D4:
	pop {pc}
	.balign 4, 0
dword_80142D8:
	.word 0x400
	thumb_func_end battle_applySelfDamageFromBattleEffect_80142C2

// symdb: Tests several hostility/anger-related criteria for a battle object and sets the "anger" ObjectFlag2 bit if any condition triggers.
// symdb: (r5 = battle object, r10 = toolkit) -> none ; side effects: may set OBJECT_FLAGS_2_UNK_BIT_21
// symdb: (0x200) on the object's CollisionData.ObjectFlags2
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_checkAngerTrigger_80142DC.yaml
	thumb_local_start
battleObject_checkAngerTrigger_80142DC:
	push {r4,lr}
	bl GetBattleMode
	cmp r0, #1
	beq locret_8014324
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne locret_8014324
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne locret_8014324
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x15
	tst r0, r1
	bne locret_8014324
	bl battleObject_aiGetUnk4cPtr_801442C
	cmp r0, #0x78 
	bge loc_801431C
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	add r0, #0x80
	ldrh r0, [r0]
	lsr r0, r0, #1
	cmp r0, #0x96
	bge loc_801431C
	b locret_8014324
loc_801431C:
	mov r0, #1
	lsl r0, r0, #9
	bl object_setFlag2
locret_8014324:
	pop {r4,pc}
	thumb_func_end battleObject_checkAngerTrigger_80142DC

// symdb: Per-frame anger-state maintenance for the player-side battle actor: on the anger trigger sets the anger flag and a 600-frame oAIData_Anger timer, counts it down, and clears anger on expiry or when the emotion already supersedes it.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_updatePlayerAngerState_8014326.yaml
	thumb_local_start
battle_updatePlayerAngerState_8014326:
	push {r4,lr}
	ldrh r0, [r5,#oBattleObject_NameID]
	bl unpackVerActorTyAndAIIdx_800F29C
	cmp r0, #2
	bne locret_80143A4
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r4,#oAIData_AIIndex]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	cmp r0, #5
	beq loc_8014394
	cmp r0, #1
	beq loc_8014394
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x15
	tst r0, r1
	bne loc_801437A
	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #9
	tst r0, r1
	beq locret_80143A4
	mov r0, r1
	bl object_clearFlag2
	mov r0, #1
	lsl r0, r0, #0x15
	bl object_setFlag1 // (int a1) -> void
	mov r0, #0x96
	lsl r0, r0, #2
	strh r0, [r4,#oAIData_Anger]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x80
	bl battle_setPlayerNaviStatsField0E_8015BEC
	b locret_80143A4
loc_801437A:
	mov r0, #1
	lsl r0, r0, #9
	bl object_clearFlag2
	ldrh r0, [r4,#oAIData_Anger]
	tst r0, r0
	beq loc_801438E
	sub r0, #1
	strh r0, [r4,#oAIData_Anger]
	bgt locret_80143A4
loc_801438E:
	bl battleObject_markUsedAction_80143A6
	b locret_80143A4
loc_8014394:
	mov r0, #1
	lsl r0, r0, #9
	bl object_clearFlag2
	mov r0, #1
	lsl r0, r0, #0x15
	bl object_clearFlag // (int bitfield) -> void
locret_80143A4:
	pop {r4,pc}
	thumb_func_end battle_updatePlayerAngerState_8014326

// symdb: Sets the navi alliance's navi-stats `Unk_0e` flag to 0x80 for the AI actor in r5, clears the global `USING_ACTION`/`FLINCHING` object flags, and zeros the actor's AIData Anger and Unk_4c fields.
// symdb: (r5 = *BattleObject whose AIDataPtr is set up) -> r0 = 0 ; side effects: clears
// symdb: `object_clearFlag(1<<0x15)` and `object_clearFlag2(0x200)`, writes 0x80 to NaviStats+0xe, writes
// symdb: 0 to AIData.Anger and AIData.Unk_4c
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_markUsedAction_80143A6.yaml
	thumb_func_start battleObject_markUsedAction_80143A6
battleObject_markUsedAction_80143A6:
	push {lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	mov r1, #0x80
	strb r1, [r0,#0xe]
	b loc_80143B6

	thumb_func_start sub_80143B4
sub_80143B4:
	push {lr}
loc_80143B6:
	mov r0, #1
	lsl r0, r0, #0x15
	bl object_clearFlag // (int bitfield) -> void
	ldr r0, off_80144B4 // =0x200 
	bl object_clearFlag2
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0
	strh r0, [r1,#oAIData_Anger]
	str r0, [r1,#oAIData_Unk_4c]
	pop {pc}
	thumb_func_end battleObject_markUsedAction_80143A6
	thumb_func_end sub_80143B4

	thumb_local_start
sub_80143CE:
	push {lr}
	bl battle_aiAIDataUnk32IsZero_801445C
	bne locret_80143E2
	bl battle_checkAIDataUnk36IsNonZero_8014490
	bne locret_80143E2
	ldr r0, off_80144B4 // =0x200 
	bl object_setFlag2
locret_80143E2:
	pop {pc}
	thumb_func_end sub_80143CE

// symdb: If a battle object's AI data has any anger built up, flashes its sprite with the enraged red color shader (0xF).
// symdb: void battle_updateAngerTint(battleObj in r5); out: r3, flags c/v preserved from caller, nz set
// symdb: by the anger test; lr consumed
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_updateAngerTint_80143E4.yaml
	thumb_local_start
battle_updateAngerTint_80143E4:
	push {lr}
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r0,#oAIData_Anger]
	tst r0, r0
	beq locret_80143F4
	ldr r0, dword_80143F8 // =0xf 
	bl sprite_setColorShader
locret_80143F4:
	pop {pc}
	.balign 4, 0
dword_80143F8:
	.word 0xF
	thumb_func_end battle_updateAngerTint_80143E4

// symdb: Runs one battle object's AI update, doing nothing while time-stop or the pause menu is active.
// symdb: void sub_80143FC(object *r5, battleCtx *r10); /* preserved: none; clobbers r0, r1, lr, NZC, V (V
// symdb: only via the AI callee) */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_runObjectAI_80143FC.yaml
	thumb_local_start
battle_runObjectAI_80143FC:
	push {lr}
	bl battle_isTimeStop
	bne locret_801441E
	bl battle_isPaused
	bne locret_801441E
	bl object_getFlag // () -> int
	ldr r1, off_8014420 // =0xc00 
	tst r0, r1
	beq loc_801441A
	bl battle_incrementAIDataUnk4c_8014432
	b locret_801441E
loc_801441A:
	bl battle_clearAIDataField4c_8014424
locret_801441E:
	pop {pc}
	.balign 4, 0
off_8014420:
	.word 0xC00
	thumb_func_end battle_runObjectAI_80143FC

// symdb: Clears the AI data word at offset 0x4c for a battle object's AI, returning 0 in r1.
// symdb: void battle_clearAIDataField4c(BattleObject* obj /* r5 */) returns u32 /* r1 = 0 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_clearAIDataField4c_8014424.yaml
	thumb_local_start
battle_clearAIDataField4c_8014424:
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0
	str r1, [r0,#oAIData_Unk_4c]
	mov pc, lr
	thumb_func_end battle_clearAIDataField4c_8014424

// symdb: Loads AIData +0x4c from a BattleObject for the AI script helpers
// symdb: (r5 = BattleObject*) -> r0 = *(BattleObject->AIData + 0x4c) ; side effects none
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_aiGetUnk4cPtr_801442C.yaml
	thumb_local_start
battleObject_aiGetUnk4cPtr_801442C:
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_4c]
	mov pc, lr
	thumb_func_end battleObject_aiGetUnk4cPtr_801442C

// symdb: Increments the AIData.Unk_4c counter for the current battle object's AI data.
// symdb: (r5 = current BattleObject*) -> r0 = AIData* ; side effect: AIData+0x4c += 1
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_incrementAIDataUnk4c_8014432.yaml
	thumb_local_start
battle_incrementAIDataUnk4c_8014432:
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r1, [r0,#oAIData_Unk_4c]
	add r1, #1
	str r1, [r0,#oAIData_Unk_4c]
	mov pc, lr
	thumb_func_end battle_incrementAIDataUnk4c_8014432

	thumb_func_start sub_801443C
sub_801443C:
	push {lr}
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldr r0, dword_80144B8 // =0xffff 
	strh r0, [r3,#oAIData_Unk_32]
	pop {pc}
	thumb_func_end sub_801443C

	thumb_func_start sub_8014446
sub_8014446:
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0
	strh r0, [r3,#oAIData_Unk_32]
	mov pc, lr
	thumb_func_end sub_8014446

	thumb_local_start
sub_801444E:
	push {lr}
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	ldr r3, [r0,#0x58]
	mov r0, #0
	strh r0, [r3,#0x32]
	pop {pc}
	thumb_func_end sub_801444E

// symdb: Returns true iff the calling BattleObject's AIData `Unk_32` (u16) field equals zero, leaving the flag set.
// symdb: (r5 = BattleObject*) -> r0 = value of AIData->Unk_32; flags Z/C/V reflect `cmp r0, #0`
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_aiAIDataUnk32IsZero_801445C.yaml
	thumb_local_start
battle_aiAIDataUnk32IsZero_801445C:
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r0,#oAIData_Unk_32]
	cmp r0, #0
	mov pc, lr
	thumb_func_end battle_aiAIDataUnk32IsZero_801445C

// symdb: Empty stub function that does nothing and returns immediately.
// symdb: void nullsub_6(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_6.yaml
	thumb_local_start
nullsub_6:
	mov pc, lr
	thumb_func_end nullsub_6

	thumb_local_start
sub_8014466:
	push {lr}
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldr r0, off_80144BC // =0x3c0 
	strh r0, [r3,#oAIData_Unk_36]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0
	bl battle_setPlayerNaviStatsField0E_8015BEC
	pop {pc}
	thumb_func_end sub_8014466

	thumb_local_start
sub_8014478:
	push {lr}
	ldr r3, [r5,#0x58]
	mov r0, #0
	strh r0, [r3,#0x36]
	pop {pc}
	thumb_func_end sub_8014478

	thumb_local_start
sub_8014482:
	push {lr}
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	ldr r3, [r0,#0x58]
	mov r0, #0
	strh r0, [r3,#0x36]
	pop {pc}
	thumb_func_end sub_8014482

// symdb: Returns whether the battle object's AIData `Unk_36` halfword is non-zero (sets r0 to that value and Z flag accordingly)
// symdb: (r5 = BattleObject*) -> r0 = AIData->Unk_36 (halfword, zero-extended) ; Z set when that halfword
// symdb: is 0
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_checkAIDataUnk36IsNonZero_8014490.yaml
	thumb_local_start
battle_checkAIDataUnk36IsNonZero_8014490:
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r0,#oAIData_Unk_36]
	cmp r0, #0
	mov pc, lr
	thumb_func_end battle_checkAIDataUnk36IsNonZero_8014490

// symdb: Applies a 1-HP gradual damage tick (e.g. poison) to a battle object once per call when its AI-data flag is armed, skipping if the battle is over or HP is already 1.
// symdb: void sub_8014498(BattleObject *obj /*r5*/); // r5 = battle object, r10 passed but unused;
// symdb: returns r3 = obj->AIDataPtr (oBattleObject_AIDataPtr) for the caller, except on the battle-over
// symdb: early return; clobbers r0, r1, flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_tickPoisonHpLoss_8014498.yaml
	thumb_local_start
battle_tickPoisonHpLoss_8014498:
	push {lr}
	bl battle_isBattleOver
	tst r0, r0
	bne locret_80144B2
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r3,#oAIData_Unk_36]
	cmp r0, #0
	beq locret_80144B2
	ldrh r1, [r5,#oBattleObject_HP]
	sub r1, #1
	beq locret_80144B2
	strh r1, [r5,#oBattleObject_HP]
locret_80144B2:
	pop {pc}
	.balign 4, 0
off_80144B4:
	.word 0x200
dword_80144B8:
	.word 0xFFFF
off_80144BC:
	.word 0x3C0
	thumb_func_end battle_tickPoisonHpLoss_8014498

// symdb: Runs the start-of-turn "open" processing for a battle object — clears its chip-hand buffer, resets AI state, handles the control-inverting status effect against the opposing player, and rebuilds the object's collision/panel setup.
// symdb: void battle_beginTurnOpenProcess(BattleObject* obj /*r5*/, u32 fullPath /*r7*/) — r5 = battle
// symdb: object to process on entry; second entry sub_80144CA is the same routine with r7 forced to 1;
// symdb: returns nothing meaningful (r0-r3, flags clobbered, callee-saved r4/r7 restored)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_beginTurnOpenProcess_80144C0.yaml
	thumb_func_start battle_beginTurnOpenProcess_80144C0
battle_beginTurnOpenProcess_80144C0:
	push {r4,r7,lr}
	mov r7, #0
	bl sub_801390C
	b loc_80144CE

	thumb_local_start
sub_80144CA:
	push {r4,r7,lr}
	mov r7, #1
loc_80144CE:
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getBattleHandAddr_8010018
	add r0, #0x26 
	mov r1, #0xc
	bl ZeroFillByHalfword
	mov r0, #0x20 
	bl ClearAIDataUnk0x48Flag
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_801450C
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	tst r0, r0
	bne loc_801450C
	push {r5}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r5, r0
	beq loc_801450A
	bl releaseSlotByValue_801DC36
loc_801450A:
	pop {r5}
loc_801450C:
	bl battle_IsNoCustomPlusActive_80107C0
	mov r0, r3
	bl battle_SetObjectHitModifier_8019F86
	mov r0, #1
	bl object_setCollisionRegion
	bl battleObject_clearPwrAtkState_8012EA8
	tst r7, r7
	bne loc_8014528
	bl battleObject_initAIData_800FEEC
loc_8014528:
	bl sub_8014536
	bl battleObject_setupSecondaryElementWeaknessFromNaviStats_801086C
	bl battle_applySelfDamageFromBattleEffect_80142C2
	pop {r4,r7,pc}
	thumb_func_end battle_beginTurnOpenProcess_80144C0
	thumb_func_end sub_80144CA

	thumb_local_start
sub_8014536:
	push {r6,lr}
	ldr r6, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	lsl r0, r0, #2
	ldr r1, off_801454C // =JumpTable8014550
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r6,pc}
	.balign 4, 0
off_801454C:
	.word JumpTable8014550
JumpTable8014550:
	.word nullsub_51+1
	.word nullsub_50+1
	.word nullsub_52+1
	.word nullsub_53+1
	.word nullsub_54+1
	.word nullsub_55+1
	.word nullsub_56+1
	.word sub_80145C2+1
	.word SetObjectAirshoeFlag+1
	.word SetObjectSuperArmorFlag+1
	.word nullsub_4+1
	.word sub_80145EC+1
	.word sub_8014606+1
	.word sub_8014650+1
	.word sub_8014650+1
	.word sub_8014650+1
	.word sub_8014650+1
	.word sub_8014650+1
	.word sub_8014606+1
	.word sub_801462A+1
	.word sub_8014606+1
	.word sub_8014640+1
	.word sub_8014606+1
	.word sub_8014650+1
	.word sub_8014674+1
	thumb_func_end sub_8014536

// symdb: Empty stub that immediately returns; a placeholder for a removed debug or routine call.
// symdb: void nullsub_51(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_51.yaml
	thumb_local_start
nullsub_51:
	mov pc, lr
	thumb_func_end nullsub_51

	thumb_local_start
nullsub_52:
	mov pc, lr
	thumb_func_end nullsub_52

	thumb_local_start
nullsub_50:
	mov pc, lr
	thumb_func_end nullsub_50

	thumb_local_start
nullsub_53:
	mov pc, lr
	thumb_func_end nullsub_53

	thumb_local_start
nullsub_54:
	mov pc, lr
	thumb_func_end nullsub_54

	thumb_local_start
nullsub_55:
	mov pc, lr
	thumb_func_end nullsub_55

	thumb_local_start
nullsub_56:
	mov pc, lr
	thumb_func_end nullsub_56

	thumb_local_start
sub_80145C2:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_07]
	cmp r0, #1
	beq locret_80145D2
	bl battle_clearObjectStatusFlagsAndTimers_801A264
locret_80145D2:
	pop {pc}
	thumb_func_end sub_80145C2

	thumb_local_start
SetObjectAirshoeFlag:
	push {lr}
	mov r0, #OBJECT_FLAGS_AIRSHOE
	bl object_setFlag1 // (int a1) -> void
	pop {pc}
	thumb_func_end SetObjectAirshoeFlag

	thumb_local_start
// (BattleObject *obj@R5) -> void
SetObjectSuperArmorFlag:
	push {lr}
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_SUPERARMOR_BIT
	bl object_setFlag1 // (int a1) -> void
	pop {pc}
	thumb_func_end SetObjectSuperArmorFlag

	thumb_local_start
nullsub_4:
	mov pc, lr
	thumb_func_end nullsub_4

	thumb_local_start
sub_80145EC:
	push {r7,lr}
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_SUPERARMOR_BIT
	bl object_setFlag1 // (int a1) -> void
	mov r7, #0x40 
	add r7, r7, r6
	ldr r0, [r7]
	cmp r0, #0
	bne locret_8014604
	bl sub_80E1620
locret_8014604:
	pop {r7,pc}
	thumb_func_end sub_80145EC

	thumb_local_start
sub_8014606:
	push {r7,lr}
	mov r0, #0x30 
	bl object_setFlag1 // (int a1) -> void
	bl battle_IsNoCustomPlusActive_80107C0
	mov r1, #0x10
	mov r2, #2
	bl object_updateCollisionData
	mov r7, #0x40 
	add r7, r7, r6
	ldr r0, [r7]
	cmp r0, #0
	bne locret_8014628
	bl sub_80E1620
locret_8014628:
	pop {r7,pc}
	thumb_func_end sub_8014606

	thumb_local_start
sub_801462A:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_07]
	cmp r0, #1
	beq loc_801463A
	bl battle_clearObjectStatusFlagsAndTimers_801A264
loc_801463A:
	bl sub_8014606
	pop {pc}
	thumb_func_end sub_801462A

	thumb_local_start
sub_8014640:
	push {lr}
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_SUPERARMOR_BIT
	bl object_setFlag1 // (int a1) -> void
	bl sub_8014606
	pop {pc}
	thumb_func_end sub_8014640

	thumb_local_start
sub_8014650:
	push {r7,lr}
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_SUPERARMOR_BIT
	bl object_setFlag1 // (int a1) -> void
	mov r7, #0x40 
	add r7, r7, r6
	ldr r0, [r7]
	cmp r0, #0
	bne loc_8014668
	bl sub_80E1620
loc_8014668:
	ldr r0, dword_80147D8 // =0xffff 
	bl object_setInvulnerableTime
	bl sub_802D310
	pop {r7,pc}
	thumb_func_end sub_8014650

	thumb_local_start
sub_8014674:
	push {r7,lr}
	ldr r0, dword_80147DC // =GameHeader
	bl object_setFlag1 // (int a1) -> void
	bl battle_IsNoCustomPlusActive_80107C0
	mov r1, #0x10
	mov r2, #2
	bl object_updateCollisionData
	mov r7, #0x40 
	add r7, r7, r6
	ldr r0, [r7]
	cmp r0, #0
	bne loc_8014696
	bl sub_80E1620
loc_8014696:
	bl sub_802D310
	pop {r7,pc}
	thumb_func_end sub_8014674

	thumb_local_start
sub_801469C:
	push {r6,lr}
	ldr r6, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	lsl r0, r0, #2
	ldr r1, off_80146B4 // =off_80146B8 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r6,pc}
	.balign 4, 0
off_80146B4:
	.word off_80146B8
off_80146B8:
	.word nullsub_801471C
	.word nullsub_801471E
	.word nullsub_8014720
	.word nullsub_8014722
	.word nullsub_8014724
	.word nullsub_8014726
	.word nullsub_8014728
	.word sub_801472A+1
	.word sub_801473C+1
	.word sub_8014746+1
	.word nullsub_5+1
	.word sub_8014754+1
	.word sub_8014760+1
	.word sub_8014754+1
	.word sub_8014754+1
	.word sub_8014754+1
	.word sub_8014754+1
	.word sub_8014754+1
	.word sub_8014760+1
	.word sub_8014776+1
	.word sub_8014760+1
	.word sub_801478C+1
	.word sub_8014760+1
	.word sub_801479C+1
	.word sub_80147B2+1
	thumb_func_end sub_801469C

	thumb_local_start
nullsub_801471C:
	mov pc, lr
	thumb_func_end nullsub_801471C

	thumb_local_start
nullsub_801471E:
	mov pc, lr
	thumb_func_end nullsub_801471E

	thumb_local_start
nullsub_8014720:
	mov pc, lr
	thumb_func_end nullsub_8014720

	thumb_local_start
nullsub_8014722:
	mov pc, lr
	thumb_func_end nullsub_8014722

	thumb_local_start
nullsub_8014724:
	mov pc, lr
	thumb_func_end nullsub_8014724

	thumb_local_start
nullsub_8014726:
	mov pc, lr
	thumb_func_end nullsub_8014726

	thumb_local_start
nullsub_8014728:
	mov pc, lr
	thumb_func_end nullsub_8014728

	thumb_local_start
sub_801472A:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_07]
	cmp r0, #1
	beq locret_801473A
	bl battle_clearObjectStatusFlagsAndTimers_801A264
locret_801473A:
	pop {pc}
	thumb_func_end sub_801472A

	thumb_local_start
sub_801473C:
	push {lr}
	mov r0, #OBJECT_FLAGS_AIRSHOE
	bl object_setFlag1 // (int a1) -> void
	pop {pc}
	thumb_func_end sub_801473C

	thumb_local_start
sub_8014746:
	push {lr}
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_SUPERARMOR_BIT
	bl object_setFlag1 // (int a1) -> void
	pop {pc}
	thumb_func_end sub_8014746

	thumb_local_start
nullsub_5:
	mov pc, lr
	thumb_func_end nullsub_5

	thumb_local_start
sub_8014754:
	push {r7,lr}
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_SUPERARMOR_BIT
	bl object_setFlag1 // (int a1) -> void
	pop {r7,pc}
	thumb_func_end sub_8014754

	thumb_local_start
sub_8014760:
	push {lr}
	mov r0, #0x30 
	bl object_setFlag1 // (int a1) -> void
	bl battle_IsNoCustomPlusActive_80107C0
	mov r1, #0x10
	mov r2, #2
	bl object_updateCollisionData
	pop {pc}
	thumb_func_end sub_8014760

	thumb_local_start
sub_8014776:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_07]
	cmp r0, #1
	beq loc_8014786
	bl battle_clearObjectStatusFlagsAndTimers_801A264
loc_8014786:
	bl sub_8014760
	pop {pc}
	thumb_func_end sub_8014776

	thumb_local_start
sub_801478C:
	push {lr}
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_SUPERARMOR_BIT
	bl object_setFlag1 // (int a1) -> void
	bl sub_8014760
	pop {pc}
	thumb_func_end sub_801478C

	thumb_local_start
sub_801479C:
	push {r7,lr}
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_SUPERARMOR_BIT
	bl object_setFlag1 // (int a1) -> void
	ldr r0, dword_80147D8 // =0xffff 
	bl object_setInvulnerableTime
	bl sub_802D310
	pop {r7,pc}
	thumb_func_end sub_801479C

	thumb_local_start
sub_80147B2:
	push {lr}
	mov r0, #0x30 
	bl object_setFlag1 // (int a1) -> void
	bl battle_IsNoCustomPlusActive_80107C0
	mov r1, #0x10
	mov r2, #2
	bl object_updateCollisionData
	ldr r0, dword_80147E0 // =0x8000000
	bl object_setFlag1 // (int a1) -> void
	ldr r0, dword_80147D8 // =0xffff 
	bl object_setInvulnerableTime
	bl sub_802D310
	pop {pc}
	.balign 4, 0
dword_80147D8:
	.word 0xFFFF
dword_80147DC:
	.word 0x8000030
dword_80147E0:
	.word 0x8000000
	thumb_func_end sub_80147B2

	thumb_func_start sub_80147E4
// r0 - byte_203F558
// r1 - byte_203F658
// symdb: Installs two 0x10-byte chatbox text/portrait descriptor blocks, copying each into both the live chatbox state (dword_20367F0) and the cached copies (unk_203A980 / unk_203A990), then resets the word counter and flags the state as active.
// symdb: void sub_80147E4(const u32 *src0 /* r0 = byte_203F558 */, const u32 *src1 /* r1 = byte_203F658
// symdb: */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_80147E4.yaml
sub_80147E4:
	push {r5-r7,lr}
	ldr r5, off_8014820 // =dword_20367F0 
	mov r6, r0
	mov r7, r1

	// r5 - dword_20367F0
	// r6 - byte_203F558
	// r7 - byte_203F658

	// CopyWords(byte_203F558, dword_20367F0+8, 0x10)
	mov r1, #8
	add r1, r1, r5
	mov r2, #0x10
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	// CopyWords(byte_203F558, unk_203A980, 0x10)
	mov r0, r6
	ldr r1, off_8014824 // =unk_203A980 
	mov r2, #0x10
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	// CopyWords(byte_203F658, dword_20367F0+0x18, 0x10)
	mov r0, r7
	mov r1, #0x18
	add r1, r1, r5
	mov r2, #0x10
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	// CopyWords(byte_203F658, unk_203A990
	mov r0, r7
	ldr r1, off_8014828 // =unk_203A990 
	mov r2, #0x10
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	mov r0, #0
	str r0, [r5]
	mov r0, #1
	strb r0, [r5,#0x4] // (byte_20367F4 - 0x20367f0)
	pop {r5-r7,pc}
	.balign 4, 0
off_8014820:
	.word dword_20367F0
off_8014824:
	.word unk_203A980
off_8014828:
	.word unk_203A990
	thumb_func_end sub_80147E4

// symdb: Resets the counter in the tracking struct at 0x20367F0 to zero and sets its active flag, starting/restarting whatever count it tracks.
// symdb: void sub_801482C(void) /* returns struct pointer in r1 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/timer_resetAndStart_801482C.yaml
	thumb_func_start timer_resetAndStart_801482C
timer_resetAndStart_801482C:
	ldr r1, off_8014838 // =dword_20367F0 
	mov r0, #0
	str r0, [r1]
	mov r0, #1
	strb r0, [r1,#0x4] // (byte_20367F4 - 0x20367f0)
	mov pc, lr
off_8014838:
	.word dword_20367F0
	thumb_func_end timer_resetAndStart_801482C

// symdb: Dispatches a battle controller state to one of three step handlers indexed by an internal byte.
// symdb: (no caller-supplied inputs) -> r0 = sub-handler's r0 ; side effects: reads controller-state byte
// symdb: at dword_20367F0, calls one of three handlers, returns handler's r0 and writes handler's r0 back
// symdb: to dword_20367F0+4.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_runControllerStep_801483C.yaml
	thumb_func_start battle_runControllerStep_801483C
battle_runControllerStep_801483C:
	push {r5-r7,lr}
	ldr r5, off_801485C // =dword_20367F0 
	mov r6, #8
	add r6, r6, r5
	mov r7, #0x18
	add r7, r7, r5
	ldr r1, off_8014858 // =off_8014860 
	ldrb r0, [r5]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	ldrb r0, [r5,#0x4] // (byte_20367F4 - 0x20367f0)
	pop {r5-r7,pc}
	.balign 4, 0
off_8014858:
	.word off_8014860
off_801485C:
	.word dword_20367F0
off_8014860:
	.word sub_801486C+1
	.word battle_dispatchBeastOutEvent_80148CC+1
	.word sub_8014A00+1
	thumb_func_end battle_runControllerStep_801483C

// symdb: Steps the action timer in two BattleObject slots, triggers beast-out when eligible, and reports whether either slot holds a pending (type-assigned-but-idle) entry.
// symdb: void battle_stepSlotsAndCheckBeastGate_801486C(BattleSlot *slotA /* r6 */, BattleSlot *slotB /*
// symdb: r7 */, u32 *result /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801486C.yaml
	thumb_local_start
sub_801486C:
	push {r4,lr}
	mov r4, #0
	ldrb r0, [r6,#4]
	cmp r0, #0xff
	beq loc_801487E
	ldr r0, [r6,#8]
	bl sub_802DCDE
	b loc_8014888
loc_801487E:
	ldrb r0, [r6]
	cmp r0, #0xff
	beq loc_8014888
	mov r4, #1
	b loc_8014898
loc_8014888:
	ldr r0, [r6,#8]
	bl canBattleObjectBeastOut_80159C6
	beq loc_8014898
	ldr r0, [r6,#8]
	bl sub_8015994
	b loc_8014898
loc_8014898:
	ldrb r0, [r7,#4]
	cmp r0, #0xff
	beq loc_80148A6
	ldr r0, [r7,#8]
	bl sub_802DCDE
	b loc_80148B0
loc_80148A6:
	ldrb r0, [r7]
	cmp r0, #0xff
	beq loc_80148B0
	mov r4, #1
	b loc_80148C0
loc_80148B0:
	ldr r0, [r7,#8]
	bl canBattleObjectBeastOut_80159C6
	beq loc_80148C0
	ldr r0, [r7,#8]
	bl sub_8015994
	b loc_80148C0
loc_80148C0:
	mov r0, #8
	tst r4, r4
	beq loc_80148C8
	mov r0, #4
loc_80148C8:
	str r0, [r5]
	pop {r4,pc}
	thumb_func_end sub_801486C

// symdb: Beast Out sub-state dispatch for an actor: dispatches on actor type to a per-event routine
// symdb: (r5 = actor-related state) -> tail-call to one of three routines; returns their result
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_dispatchBeastOutEvent_80148CC.yaml
	thumb_local_start
battle_dispatchBeastOutEvent_80148CC:
	push {lr}
	ldr r1, off_80148DC // =off_80148E0 
	ldrb r0, [r5,#1]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
off_80148DC:
	.word off_80148E0
off_80148E0:
	.word battle_toggleBattleScreenFadeOrSomething_80148EC+1
	.word activateCrossHappensHere_8014944+1
	.word battle_runBeastOutIntro_801498E+1
	thumb_func_end battle_dispatchBeastOutEvent_80148CC

// symdb: Drives the post-battle intro/outro fade-out for turn-end-of-beast-sp behaviour: kicks the screen fade, dispatches a large flag payload, then waits for it to finish and dispatches the next payload.
// symdb: (r5 = S20047CC*, r10 = toolkit) -> no return value ; writes S20047CC+0x1, S20047CC+0x2,
// symdb: S20047CC+0x3 and triggers SetScreenFade / dispatch_801DACC.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_toggleBattleScreenFadeOrSomething_80148EC.yaml
	thumb_local_start
battle_toggleBattleScreenFadeOrSomething_80148EC:
	push {lr}
	ldrb r0, [r5,#3]
	tst r0, r0
	bne loc_8014912
	bl GetBattleMode
	cmp r0, #1
	bne loc_8014900
	mov r0, #0x70 
	b loc_8014902
loc_8014900:
	mov r0, #0x44 
loc_8014902:
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	ldr r0, dword_8014940 // =0x4000 
	bl dispatch_801DACC // (a0: flags32) -> ()
	mov r0, #4
	strb r0, [r5,#3]
loc_8014912:
	bl IsScreenFadeActive // () -> zf
	tst r0, r0
	bne locret_801493E
	bl GetBattleMode
	cmp r0, #1
	bne loc_8014926
	mov r0, #0xa0
	b loc_8014932
loc_8014926:
	bl TestBattleFlag_0x40
	bne loc_8014930
	mov r0, #0x90
	b loc_8014932
loc_8014930:
	ldr r0, dword_80149EC // =0x20080 
loc_8014932:
	bl dispatch_801DACC // (a0: flags32) -> ()
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_801493E:
	pop {pc}
	.balign 4, 0
dword_8014940:
	.word 0x4000
	thumb_func_end battle_toggleBattleScreenFadeOrSomething_80148EC

	thumb_local_start
activateCrossHappensHere_8014944:
	push {lr}
	ldrb r0, [r5,#3]
	tst r0, r0
	bne loc_801496A
	ldrb r0, [r6]
	cmp r0, #0xff
	beq loc_8014958
	ldr r0, [r6,#8]
	bl sub_801596E
loc_8014958:
	ldrb r0, [r7]
	cmp r0, #0xff
	beq loc_8014964
	ldr r0, [r7,#8]
	bl sub_801596E
loc_8014964:
	mov r0, #4
	strb r0, [r5,#3]
	b locret_801498C
loc_801496A:
	ldr r0, [r6,#8]
	bl battleObject_checkAIUnk0x48Flag0x80_801597C
	tst r0, r0
	bne locret_801498C
	ldr r0, [r7,#8]
	bl battleObject_checkAIUnk0x48Flag0x80_801597C
	tst r0, r0
	bne locret_801498C
	mov r0, #0xff
	strb r0, [r6]
	strb r0, [r7]
	mov r0, #8
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_801498C:
	pop {pc}
	thumb_func_end activateCrossHappensHere_8014944

// symdb: Triggers and runs the fade/screen transition for the Beast Out pet-transformation intro and dispatches the next battle step.
// symdb: (r5 = beast-state scratch, r10 = toolkit) -> r0 = 1 if fade is still active (exits early),
// symdb: otherwise void-like ; side effects: starts a screen fade, writes [r5,#0] and [r5,#3], dispatches
// symdb: a battle step
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_runBeastOutIntro_801498E.yaml
	thumb_local_start
battle_runBeastOutIntro_801498E:
	push {lr}
	ldrb r0, [r5,#3]
	tst r0, r0
	bne loc_80149AE
	bl GetBattleMode
	cmp r0, #1
	bne loc_80149A2
	mov r0, #0x6c 
	b loc_80149A4
loc_80149A2:
	mov r0, #0x40 
loc_80149A4:
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #4
	strb r0, [r5,#3]
loc_80149AE:
	bl IsScreenFadeActive // () -> zf
	tst r0, r0
	bne locret_80149EA
	bl battle_IsBattleEnding_800A97A
	push {r0}
	bl GetBattleMode
	cmp r0, #1
	pop {r0}
	bne loc_80149CA
	ldr r1, dword_80149F0 // =0x40a0 
	b loc_80149DA
loc_80149CA:
	push {r0}
	bl TestBattleFlag_0x40
	pop {r0}
	bne loc_80149D8
	ldr r1, dword_80149F4 // =0x4090 
	b loc_80149DA
loc_80149D8:
	ldr r1, dword_80149F8 // =0x24080 
loc_80149DA:
	tst r0, r0
	beq loc_80149E0
	ldr r1, dword_80149FC // =0x4080 
loc_80149E0:
	mov r0, r1
	bl dispatch_801DA48
	mov r0, #8
	str r0, [r5]
locret_80149EA:
	pop {pc}
	.balign 4, 0
dword_80149EC:
	.word 0x20080
dword_80149F0:
	.word 0x40A0
dword_80149F4:
	.word 0x4090
dword_80149F8:
	.word 0x24080
dword_80149FC:
	.word 0x4080
	thumb_func_end battle_runBeastOutIntro_801498E

	thumb_local_start
sub_8014A00:
	push {lr}
	ldr r0, [r6,#8]
	bl battle_isObjectInSpecialAiState_80159A2
	tst r0, r0
	bne locret_8014A36
	ldr r0, [r7,#8]
	bl battle_isObjectInSpecialAiState_80159A2
	tst r0, r0
	bne locret_8014A36
	ldr r0, [r6,#8]
	bl ai_CheckSpecialFlagPair_802DCEC
	tst r0, r0
	bne locret_8014A36
	mov r0, #0xff
	strb r0, [r6,#4]
	ldr r0, [r7,#8]
	bl ai_CheckSpecialFlagPair_802DCEC
	tst r0, r0
	bne locret_8014A36
	mov r0, #0xff
	strb r0, [r7,#4]
	mov r0, #0
	strb r0, [r5,#4]
locret_8014A36:
	pop {pc}
	thumb_func_end sub_8014A00

// symdb: Dispatch handler for an AIData beast-out/transform action: picks the per-state sub-routine based on Alliance/NaviStats, clears the action flag if not applicable.
// symdb: side effects only (no return value to callers); reads r5 = AIData*, r7 = AIAttackVars*,
// symdb: reads/writes AIData->Unk_48 flag, Alliance via r5, AIAttackVars->Unk_00
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_runBeastTransformationAction_8014A38.yaml
	thumb_local_start
battle_runBeastTransformationAction_8014A38:
	push {lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	cmp r0, #1
	blt loc_8014AA8
	cmp r0, #0x18
	bgt loc_8014AA8
	cmp r0, #0x17
	blt loc_8014A58
	ldr r1, off_8014AEC // =off_8014AF0 
	ldrb r0, [r7,#oAIAttackVars_Unk_00]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	b loc_8014A98
loc_8014A58:
	cmp r0, #0xd
	blt loc_8014A72
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xa
	bgt loc_8014A8E
	ldr r1, off_8014AD8 // =off_8014ADC 
	ldrb r0, [r7,#oAIAttackVars_Unk_00]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	b loc_8014A98
loc_8014A72:
	cmp r0, #0xb
	blt loc_8014A82
	ldr r1, off_8014AC4 // =off_8014AC8 
	ldrb r0, [r7,#oAIAttackVars_Unk_00]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	b loc_8014A98
loc_8014A82:
	ldr r1, off_8014AB0 // =off_8014AB4 
	ldrb r0, [r7,#oAIAttackVars_Unk_00]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	b loc_8014A98
loc_8014A8E:
	ldr r1, off_8014B00 // =off_8014B04 
	ldrb r0, [r7,#oAIAttackVars_Unk_00]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
loc_8014A98:
	bl GetAIDataUnk0x48Flag
	ldr r1, dword_8014B14 // =0x80000 
	tst r0, r1
	bne locret_8014AA6
	bl battleObject_updateSpriteAnimIfChanged_801BCD0
locret_8014AA6:
	pop {pc}
loc_8014AA8:
	mov r0, #0x80
	bl ClearAIDataUnk0x48Flag
	pop {pc}
	.balign 4, 0
off_8014AB0:
	.word off_8014AB4
off_8014AB4:
	.word sub_8014B18+1
	.word sub_8014B98+1
	.word battle_runTransformationIntroStep_8014BEE+1
	.word battle_aiAttackTickBeastSp_8014CC0+1
off_8014AC4:
	.word off_8014AC8
off_8014AC8:
	.word sub_8014D08+1
	.word sub_8014D70+1
	.word battle_ai_attackVars_step3_8014E08+1
	.word object_aiAttackVarsExitState_8014F04+1
off_8014AD8:
	.word off_8014ADC
off_8014ADC:
	.word sub_8014F40+1
	.word sub_8014FA8+1
	.word sub_8015040+1
	.word sub_8015128+1
off_8014AEC:
	.word off_8014AF0
off_8014AF0:
	.word sub_801516C+1
	.word sub_80151D4+1
	.word sub_80152C8+1
	.word sub_80153B0+1
off_8014B00:
	.word off_8014B04
off_8014B04:
	.word sub_80153EC+1
	.word sub_801544C+1
	.word sub_80154C8+1
	.word sub_80155CC+1
dword_8014B14:
	.word 0x80000
	thumb_func_end battle_runBeastTransformationAction_8014A38

	thumb_local_start
sub_8014B18:
	push {r4,lr}
	ldr r0, dword_8014B94 // =0x80000 
	bl SetAIDataUnk0x48Flag
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	bl object_clearInvulnerableTime
	bl sub_800F46C
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl battleObject_refreshSpriteAndArm_800F2C6
	bl battleObject_clearPwrAtkState_8012EA8
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_5c]
	bl sub_80C4C3A
	bl sub_80158FA
	mov r0, #6
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #9
	bne loc_8014B8A
	ldrb r0, [r5,#oBattleObject_CurAnim]
	cmp r0, #0x16
	bne loc_8014B8A
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	ldr r0, dword_8014B94 // =0x80000 
	bl ClearAIDataUnk0x48Flag
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_8014B8A
	mov r1, #1
	strb r1, [r0,#oBattleObject_Param3]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_8014B8A:
	mov r0, #4
	strh r0, [r7,#oAIAttackVars_Unk_00]
	pop {r4,pc}
	.word 0x80111C40
	.balign 4, 0
dword_8014B94:
	.word 0x80000
	thumb_func_end sub_8014B18

	thumb_local_start
sub_8014B98:
	push {r4,r6,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8014BCA
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bmi loc_8014BAA
	b locret_8014BEC
loc_8014BAA:
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	mov r4, r0
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	mov r3, #0x14
	bl sub_80BC844
	mov r0, #0x28 
	add r0, #8
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_30]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8014BCA:
	ldr r0, [r7,#oAIAttackVars_Unk_30]
	add r0, #1
	cmp r0, #6
	bgt loc_8014BD8
	str r0, [r7,#oAIAttackVars_Unk_30]
	bl sprite_forceWhitePalette
loc_8014BD8:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_8014BEC
	mov r0, #6
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #8
	strh r0, [r7,#oAIAttackVars_Unk_00]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_30]
locret_8014BEC:
	pop {r4,r6,pc}
	thumb_func_end sub_8014B98

// symdb: Transformation-intro step for the player navi (state 2 of the off_8014AB4 step table): sets up the new form's sprite/name/per-form init, plays the log-in SFX, then after a 10-frame countdown hands off to the turn-open processing.
// symdb: void battle_runTransformationIntroStep(u32 r5 /* battle object */, u32 r7 /* AIAttackVars */) :
// symdb: r5 r7 -> [r5 r10]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_runTransformationIntroStep_8014BEE.yaml
	thumb_local_start
battle_runTransformationIntroStep_8014BEE:
	push {r4,lr}
	bl sprite_forceWhitePalette
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8014C9E
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_8011384
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	bl chip_class_lookup_800FC9E
	mov r0, #0x80
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	bl sprite_hasShadow
	mov r0, #0
	bl object_setAnimation
	ldrb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl sprite_forceWhitePalette
	bl object_setCoordinatesFromPanels // () -> void
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Unk_10]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	mov r1, #0x2c 
	mov r2, r0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #1
	blt loc_8014C72
	cmp r0, #0x18
	bgt loc_8014C72
	bl battle_setObjectTextId_8015B22
loc_8014C72:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #0
	push {r0}
	bl sub_8011268
	pop {r0}
	mov r0, #3
	bl battleObject_computeAIStepForwardDeltaX_8018856
	neg r1, r1
	bl battleObject_setCustomGaugeBarAnimate_801DC06
	mov r0, #0x8d
	bl PlaySoundEffect
	mov r0, #SOUND_LOG_IN_77
	bl PlaySoundEffect
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8014C9E:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bgt locret_8014CBE
	bl battle_beginTurnOpenProcess_80144C0
	bl battleObject_markUsedAction_80143A6
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x80
	bl battle_setPlayerNaviStatsField0E_8015BEC
	bl object_clearInvulnerableTime
	mov r0, #0xc
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_8014CBE:
	pop {r4,pc}
	thumb_func_end battle_runTransformationIntroStep_8014BEE

// symdb: Per-tick AI attack update that cancels the Beast Out spam (atkvars Unk_10) once elapsed and tears down its state.
// symdb: (r5 = ActorBattleObjectPtr, r6 = ?, r7 = ActorAIDataPtr, r10 = ToolkitPtr, lr = caller) -> r0 =
// symdb: new Alliance value passed to sub_800AB2E ; side effects: edits ActorAIData->AttackVars offsets
// symdb: 0x01 and 0x10, clears AIData bits 0x80 / 0x80000, AIData->Unk_44 bits 0x80008600, battle-state
// symdb: flags 0x20, then calls object_exitAttackState
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_aiAttackTickBeastSp_8014CC0.yaml
	thumb_local_start
battle_aiAttackTickBeastSp_8014CC0:
	push {r4,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8014CD0
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8014CD0:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_8014CFE
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0xb
	mov r2, #1
	bl sub_800AB2E
	mov r0, #0x80
	bl ClearAIDataUnk0x48Flag
	mov r0, #0x20 
	bl battle_clearFlags
	ldr r0, dword_8014D00 // =0x80000 
	bl ClearAIDataUnk0x48Flag
	ldr r0, dword_8014D04 // =0x80008600 
	bl ClearAIData_Unk_44_Flag
	bl object_exitAttackState
locret_8014CFE:
	pop {r4,pc}
	.balign 4, 0
dword_8014D00:
	.word 0x80000
dword_8014D04:
	.word 0x80008600
	thumb_func_end battle_aiAttackTickBeastSp_8014CC0

	thumb_local_start
sub_8014D08:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	bl object_clearInvulnerableTime
	bl sub_800F46C
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl battleObject_refreshSpriteAndArm_800F2C6
	bl battleObject_clearPwrAtkState_8012EA8
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_5c]
	bl sub_80C4C3A
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	bl sub_80158FA
	mov r0, #0x11
	strb r0, [r5,#oBattleObject_CurAnim]
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_8014D5A
	mov r1, #1
	strb r1, [r0,#oBattleObject_Param3]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_8014D5A:
	mov r0, #6
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #0xc
	mov r1, #5
	bl sprite_decompressTemp
	mov r0, #4
	strh r0, [r7,#oAIAttackVars_Unk_00]
	pop {r4,pc}
	.word 0x80111C40
	thumb_func_end sub_8014D08

	thumb_local_start
sub_8014D70:
	push {r4,r6,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8014DE6
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bmi loc_8014D82
	b locret_8014DF2
loc_8014D82:
	ldr r0, dword_8014E04 // =0x80000 
	bl SetAIDataUnk0x48Flag
	mov r0, #0xf7
	bl PlaySoundEffect
	mov r4, #0x2e 
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #8
	orr r4, r0
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	bl spawn_t1_0x0_EffectObject
	cmp r0, #0
	beq loc_8014DDE
	mov r1, #0x36 
	strh r1, [r0,#oBattleObject_Timer]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #4
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
	ldr r0, [r5,#oBattleObject_Y]
	ldr r1, dword_8014DF8 // =0xc00000 
	add r0, r0, r1
	str r0, [r5,#oBattleObject_Y]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #2
	mov r2, #1
	bl sub_800AB2E
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	ldr r1, off_8014DFC // =0x1cc 
	cmp r0, #0xb
	beq loc_8014DD0
	ldr r1, off_8014E00 // =0x1cd 
loc_8014DD0:
	mov r0, r1
	bl PlaySoundEffect
	mov r0, #2
	mov r1, #0x3c 
	bl sub_80302B6
loc_8014DDE:
	mov r0, #0x36 
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8014DE6:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_8014DF2
	mov r0, #8
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_8014DF2:
	pop {r4,r6,pc}
	.word 0x200000
	.balign 4, 0
dword_8014DF8:
	.word 0xC00000
off_8014DFC:
	.word 0x1CC
off_8014E00:
	.word 0x1CD
dword_8014E04:
	.word 0x80000
	thumb_func_end sub_8014D70

// symdb: AI step 3 for a battle object's attack vars — plays the load/charge-in animation, sets a 10-frame counter, plays a sound, and on expiry runs the turn-open / sprite-restoration cleanup and sets the next state to 0xC.
// symdb: (r5 = battle object, r7 = AI attack vars, r10 = toolkit, lr = ret) -> void ; no return value to
// symdb: callers
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_ai_attackVars_step3_8014E08.yaml
	thumb_local_start
battle_ai_attackVars_step3_8014E08:
	push {r4,lr}
	bl sprite_forceWhitePalette
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8014EB8
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_8011384
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	bl chip_class_lookup_800FC9E
	mov r0, #0x80
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	bl sprite_hasShadow
	mov r0, #0
	bl object_setAnimation
	ldrb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl object_setCoordinatesFromPanels // () -> void
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bl sprite_forceWhitePalette
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	mov r1, #0x2c 
	mov r2, r0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r4, dword_8014F00 // =0x30e00 
	bl sub_80E11E0
	mov r0, #1
	add r0, #0xff
	bl PlaySoundEffect
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #1
	blt loc_8014E92
	cmp r0, #0x18
	bgt loc_8014E92
	bl battle_setObjectTextId_8015B22
loc_8014E92:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #0
	bl sub_8011268
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq loc_8014EA8
	mov r1, #0
	strb r1, [r0,#oBattleObject_Param3]
loc_8014EA8:
	mov r0, #3
	bl battleObject_computeAIStepForwardDeltaX_8018856
	neg r1, r1
	bl battleObject_setCustomGaugeBarAnimate_801DC06
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8014EB8:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bgt locret_8014EFE
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	mov r1, #0
	cmp r0, #2
	bne loc_8014ECE
	mov r1, #1
loc_8014ECE:
	push {r1}
	bl battle_beginTurnOpenProcess_80144C0
	bl battleObject_markUsedAction_80143A6
	pop {r0}
	cmp r0, #0
	beq loc_8014EE6
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0xff
	bl battle_setPlayerNaviStatsField0E_8015BEC
loc_8014EE6:
	bl object_clearInvulnerableTime
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_8014EFA
	push {r5}
	mov r5, r0
	bl sprite_clearFinalPalette
	pop {r5}
loc_8014EFA:
	mov r0, #0xc
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_8014EFE:
	pop {r4,pc}
	.balign 4, 0
dword_8014F00:
	.word 0x30E00
	thumb_func_end battle_ai_attackVars_step3_8014E08

// symdb: Countdown-then-exit routine for an AI attack-vars state, clearing AI/battle flags and tearing the object out of its attack state.
// symdb: (r7 = BattleObject*, r6 = related object?, r5 = related object?, r10 = toolkit) -> side effects
// symdb: only (no value returned to callers); clears AI flag 0x80 and the AI Unk_44 flag 0x80000000,
// symdb: clears battle-state flag 0x20, and exits the object's attack state via object_exitAttackState.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/object_aiAttackVarsExitState_8014F04.yaml
	thumb_local_start
object_aiAttackVarsExitState_8014F04:
	push {r4,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8014F14
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8014F14:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_8014F38
	mov r0, #0x80
	bl ClearAIDataUnk0x48Flag
	mov r0, #0x20 
	bl battle_clearFlags
	ldr r0, dword_8014F3C // =0x80000 
	bl ClearAIDataUnk0x48Flag
	ldr r0, dword_80152B4 // =0x80008600 
	bl ClearAIData_Unk_44_Flag
	bl object_exitAttackState
locret_8014F38:
	pop {r4,pc}
	.balign 4, 0
dword_8014F3C:
	.word 0x80000
	thumb_func_end object_aiAttackVarsExitState_8014F04

	thumb_local_start
sub_8014F40:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	bl object_clearInvulnerableTime
	bl sub_800F46C
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl battleObject_refreshSpriteAndArm_800F2C6
	bl battleObject_clearPwrAtkState_8012EA8
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_5c]
	bl sub_80C4C3A
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	bl sub_80158FA
	mov r0, #0x11
	strb r0, [r5,#oBattleObject_CurAnim]
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_8014F92
	mov r1, #1
	strb r1, [r0,#oBattleObject_Param3]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_8014F92:
	mov r0, #6
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #0xc
	mov r1, #5
	bl sprite_decompressTemp
	mov r0, #4
	strh r0, [r7,#oAIAttackVars_Unk_00]
	pop {r4,pc}
	.word 0x80111C40
	thumb_func_end sub_8014F40

	thumb_local_start
sub_8014FA8:
	push {r4,r6,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_801501E
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bmi loc_8014FBA
	b locret_801502A
loc_8014FBA:
	ldr r0, dword_801503C // =0x80000 
	bl SetAIDataUnk0x48Flag
	mov r0, #0xf7
	bl PlaySoundEffect
	mov r4, #0x2e 
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #8
	orr r4, r0
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	bl spawn_t1_0x0_EffectObject
	cmp r0, #0
	beq loc_8015016
	mov r1, #0x36 
	strh r1, [r0,#oBattleObject_Timer]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #4
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
	ldr r0, [r5,#oBattleObject_Y]
	ldr r1, dword_8015030 // =0xc00000 
	add r0, r0, r1
	str r0, [r5,#oBattleObject_Y]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #2
	mov r2, #1
	bl sub_800AB2E
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	ldr r1, off_8015034 // =0x1cc 
	cmp r0, #0x12
	blt loc_8015008
	ldr r1, off_8015038 // =0x1cd 
loc_8015008:
	mov r0, r1
	bl PlaySoundEffect
	mov r0, #2
	mov r1, #0x3c 
	bl sub_80302B6
loc_8015016:
	mov r0, #0x36 
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_801501E:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_801502A
	mov r0, #8
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_801502A:
	pop {r4,r6,pc}
	.word 0x200000
	.balign 4, 0
dword_8015030:
	.word 0xC00000
off_8015034:
	.word 0x1CC
off_8015038:
	.word 0x1CD
dword_801503C:
	.word 0x80000
	thumb_func_end sub_8014FA8

	thumb_local_start
sub_8015040:
	push {r4,lr}
	bl sprite_forceWhitePalette
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8015100
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_8011384
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	bl chip_class_lookup_800FC9E
	mov r0, #0x80
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	bl sprite_hasShadow
	mov r0, #0
	bl object_setAnimation
	ldrb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl object_setCoordinatesFromPanels // () -> void
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bl sprite_forceWhitePalette
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	mov r1, #0x2c 
	mov r2, r0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r4, dword_8015124 // =0x30e00 
	bl sub_80E11E0
	mov r0, #1
	add r0, #0xff
	bl PlaySoundEffect
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #1
	blt loc_80150CA
	cmp r0, #0x18
	bgt loc_80150CA
	bl battle_setObjectTextId_8015B22
loc_80150CA:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #0
	push {r0}
	bl sub_8011268
	pop {r0}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_80150F0
	mov r1, #0
	strb r1, [r0,#oBattleObject_CurAnim]
	mov r1, #0
	strb r1, [r0,#oBattleObject_Param3]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_80150F0:
	mov r0, #3
	bl battleObject_computeAIStepForwardDeltaX_8018856
	neg r1, r1
	bl battleObject_setCustomGaugeBarAnimate_801DC06
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8015100:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bgt locret_8015120
	bl battle_beginTurnOpenProcess_80144C0
	bl battleObject_markUsedAction_80143A6
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x80
	bl battle_setPlayerNaviStatsField0E_8015BEC
	bl object_clearInvulnerableTime
	mov r0, #0xc
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_8015120:
	pop {r4,pc}
	.balign 4, 0
dword_8015124:
	.word 0x30E00
	thumb_func_end sub_8015040

	thumb_local_start
sub_8015128:
	push {r4,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8015138
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8015138:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_8015166
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0xb
	mov r2, #1
	bl sub_800AB2E
	mov r0, #0x80
	bl ClearAIDataUnk0x48Flag
	ldr r0, dword_8015168 // =0x80000 
	bl ClearAIDataUnk0x48Flag
	mov r0, #0x20 
	bl battle_clearFlags
	ldr r0, dword_80152B4 // =0x80008600 
	bl ClearAIData_Unk_44_Flag
	bl object_exitAttackState
locret_8015166:
	pop {r4,pc}
	.balign 4, 0
dword_8015168:
	.word 0x80000
	thumb_func_end sub_8015128

	thumb_local_start
sub_801516C:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	bl object_clearInvulnerableTime
	bl sub_800F46C
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl battleObject_refreshSpriteAndArm_800F2C6
	bl battleObject_clearPwrAtkState_8012EA8
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_5c]
	bl sub_80C4C3A
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	bl sub_80158FA
	mov r0, #0x11
	strb r0, [r5,#oBattleObject_CurAnim]
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_80151BE
	mov r1, #1
	strb r1, [r0,#oBattleObject_Param3]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_80151BE:
	mov r0, #6
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #0xc
	mov r1, #5
	bl sprite_decompressTemp
	mov r0, #4
	strh r0, [r7,#oAIAttackVars_Unk_00]
	pop {r4,pc}
	.word 0x80111C40
	thumb_func_end sub_801516C

	thumb_local_start
sub_80151D4:
	push {r4,r6,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8015288
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bmi loc_80151E6
	b locret_80152A6
loc_80151E6:
	ldr r0, dword_80152B0 // =0x80000 
	bl SetAIDataUnk0x48Flag
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	sub r0, #0x17
	lsl r6, r0, #0x11
	mov r4, #0x3f 
	add r4, r4, r0
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #8
	orr r4, r0
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	ldr r0, dword_80152B8 // =0x200000 
	add r3, r3, r0
	bl spawn_t1_0x0_EffectObject
	cmp r0, #0
	beq loc_801527C
	mov r1, #0x36 
	strh r1, [r0,#oBattleObject_Timer]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #4
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
	mov r0, #0x9b
	add r0, #0xff
	bl PlaySoundEffect
	mov r4, #0x3e 
	orr r4, r6
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #8
	orr r4, r0
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	ldr r0, dword_80152B8 // =0x200000 
	add r3, r3, r0
	bl spawn_t1_0x0_EffectObject
	cmp r0, #0
	beq loc_801527C
	mov r1, #0x45 
	strh r1, [r0,#oBattleObject_Timer]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #4
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
	ldr r0, [r5,#oBattleObject_Y]
	ldr r1, dword_80152BC // =0xc00000 
	add r0, r0, r1
	str r0, [r5,#oBattleObject_Y]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #2
	mov r2, #1
	bl sub_800AB2E
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	ldr r1, off_80152C0 // =0x1cc 
	cmp r0, #0x17
	beq loc_801526E
	ldr r1, off_80152C4 // =0x1cd 
loc_801526E:
	mov r0, r1
	bl PlaySoundEffect
	mov r0, #2
	mov r1, #0x4b 
	bl sub_80302B6
loc_801527C:
	mov r0, #0x36 
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bl sub_80EA438
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8015288:
	ldr r0, [r7,#oAIAttackVars_Unk_10]
	cmp r0, #0x35 
	beq loc_8015292
	cmp r0, #0x25 
	bne loc_801529A
loc_8015292:
	mov r0, #0x9b
	add r0, #0xff
	bl PlaySoundEffect
loc_801529A:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_80152A6
	mov r0, #8
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_80152A6:
	pop {r4,r6,pc}
	.word 0x200000, 0xC00000
	.balign 4, 0
dword_80152B0:
	.word 0x80000
dword_80152B4:
	.word 0x80008600
dword_80152B8:
	.word 0x200000
dword_80152BC:
	.word 0xC00000
off_80152C0:
	.word 0x1CC
off_80152C4:
	.word 0x1CD
	thumb_func_end sub_80151D4

	thumb_local_start
sub_80152C8:
	push {r4,lr}
	bl sprite_forceWhitePalette
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_801537C
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_8011384
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	bl chip_class_lookup_800FC9E
	mov r0, #0x80
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	bl sprite_hasShadow
	mov r0, #0
	bl object_setAnimation
	ldrb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl object_setCoordinatesFromPanels // () -> void
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bl battle_clearObjectStatusFlagsAndTimers_801A264
	bl sprite_forceWhitePalette
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	mov r1, #0x2c 
	mov r2, r0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r4, dword_80153AC // =0x30e00 
	bl sub_80E11E0
	mov r0, #1
	add r0, #0xff
	bl PlaySoundEffect
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #1
	blt loc_8015356
	cmp r0, #0x18
	bgt loc_8015356
	bl battle_setObjectTextId_8015B22
loc_8015356:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #0
	bl sub_8011268
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq loc_801536C
	mov r1, #0
	strb r1, [r0,#oBattleObject_Param3]
loc_801536C:
	mov r0, #3
	bl battleObject_computeAIStepForwardDeltaX_8018856
	neg r1, r1
	bl battleObject_setCustomGaugeBarAnimate_801DC06
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_801537C:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bgt locret_80153A8
	bl battle_beginTurnOpenProcess_80144C0
	bl battleObject_markUsedAction_80143A6
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x80
	bl battle_setPlayerNaviStatsField0E_8015BEC
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_80153A4
	push {r5}
	mov r5, r0
	bl sprite_clearFinalPalette
	pop {r5}
loc_80153A4:
	mov r0, #0xc
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_80153A8:
	pop {r4,pc}
	.balign 4, 0
dword_80153AC:
	.word 0x30E00
	thumb_func_end sub_80152C8

	thumb_local_start
sub_80153B0:
	push {r4,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_80153C0
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_80153C0:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_80153E4
	mov r0, #0x80
	bl ClearAIDataUnk0x48Flag
	ldr r0, dword_80153E8 // =0x80000 
	bl ClearAIDataUnk0x48Flag
	mov r0, #0x20 
	bl battle_clearFlags
	ldr r0, dword_8015610 // =0x80008600 
	bl ClearAIData_Unk_44_Flag
	bl object_exitAttackState
locret_80153E4:
	pop {r4,pc}
	.balign 4, 0
dword_80153E8:
	.word 0x80000
	thumb_func_end sub_80153B0

	thumb_local_start
sub_80153EC:
	push {r4,lr}
	ldr r0, dword_8015448 // =0x80000 
	bl SetAIDataUnk0x48Flag
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	bl object_clearInvulnerableTime
	bl sub_800F46C
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl battleObject_refreshSpriteAndArm_800F2C6
	bl battleObject_clearPwrAtkState_8012EA8
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_5c]
	bl sub_80C4C3A
	bl sub_80158FA
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_8015438
	mov r1, #1
	strb r1, [r0,#oBattleObject_Param3]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_8015438:
	mov r0, #6
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strh r0, [r7,#oAIAttackVars_Unk_00]
	pop {r4,pc}
	.balign 4, 0
	.word 0x80111C40
dword_8015448:
	.word 0x80000
	thumb_func_end sub_80153EC

	thumb_local_start
sub_801544C:
	push {r4,r6,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8015480
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bmi loc_801545E
	b locret_80154C6
loc_801545E:
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	sub r0, #0xc
	mov r4, r0
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	mov r3, #0x14
	bl sub_80BC844
	mov r0, #0x28 
	add r0, #8
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_30]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8015480:
	ldr r0, [r7,#oAIAttackVars_Unk_30]
	add r0, #1
	cmp r0, #6
	bgt loc_801549E
	str r0, [r7,#oAIAttackVars_Unk_30]
	bl sprite_forceWhitePalette
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_801549E
	push {r5}
	mov r5, r0
	bl sprite_forceWhitePalette
	pop {r5}
loc_801549E:
	cmp r0, #7
	bne loc_80154B2
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_80154B2
	push {r5}
	mov r5, r0
	bl sprite_clearFinalPalette
	pop {r5}
loc_80154B2:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_80154C6
	mov r0, #6
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #8
	strh r0, [r7,#oAIAttackVars_Unk_00]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_30]
locret_80154C6:
	pop {r4,r6,pc}
	thumb_func_end sub_801544C

	thumb_local_start
sub_80154C8:
	push {r4,lr}
	bl sprite_forceWhitePalette
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_8015594
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_80154E2
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_80154E2:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_8011384
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	bl chip_class_lookup_800FC9E
	mov r0, #0x80
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	bl sprite_hasShadow
	mov r0, #0
	bl object_setAnimation
	ldrb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl object_setCoordinatesFromPanels // () -> void
	mov r0, #0xa
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bl sprite_forceWhitePalette
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_ai_getActorInfo_801595E
	mov r1, #0x2c 
	mov r2, r0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #1
	blt loc_801555A
	cmp r0, #0x18
	bgt loc_801555A
	bl battle_setObjectTextId_8015B22
loc_801555A:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #0
	push {r0}
	bl sub_8011268
	pop {r0}
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_8015578
	mov r1, #0
	strb r1, [r0,#oBattleObject_CurAnim]
	mov r1, #0
	strb r1, [r0,#oBattleObject_Param3]
loc_8015578:
	mov r0, #3
	bl battleObject_computeAIStepForwardDeltaX_8018856
	neg r1, r1
	bl battleObject_setCustomGaugeBarAnimate_801DC06
	mov r0, #0x8d
	bl PlaySoundEffect
	mov r0, #SOUND_LOG_IN_77
	bl PlaySoundEffect
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_8015594:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bgt locret_80155C4
	bl battle_beginTurnOpenProcess_80144C0
	bl battleObject_markUsedAction_80143A6
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x80
	bl battle_setPlayerNaviStatsField0E_8015BEC
	bl object_clearInvulnerableTime
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_80155C0
	push {r5}
	mov r5, r0
	bl sprite_clearFinalPalette
	pop {r5}
loc_80155C0:
	mov r0, #0xc
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_80155C4:
	pop {r4,pc}
	.balign 4, 0x00
	.word 0x31400
	thumb_func_end sub_80154C8

	thumb_local_start
sub_80155CC:
	push {r4,lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_80155DC
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_80155DC:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_801560A
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0xb
	mov r2, #1
	bl sub_800AB2E
	mov r0, #0x80
	bl ClearAIDataUnk0x48Flag
	ldr r0, dword_801560C // =0x80000 
	bl ClearAIDataUnk0x48Flag
	mov r0, #0x20 
	bl battle_clearFlags
	ldr r0, dword_8015610 // =0x80008600 
	bl ClearAIData_Unk_44_Flag
	bl object_exitAttackState
locret_801560A:
	pop {r4,pc}
	.balign 4, 0
dword_801560C:
	.word 0x80000
dword_8015610:
	.word 0x80008600
	thumb_func_end sub_80155CC

	thumb_local_start
sub_8015614:
	push {lr}
	ldr r1, off_8015624 // =off_8015628 
	ldrb r0, [r7,#oAIAttackVars_Unk_00]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
off_8015624:
	.word off_8015628
off_8015628:
	.word sub_801562C+1
	thumb_func_end sub_8015614

	thumb_local_start
sub_801562C:
	push {r4,lr}
	bl sprite_forceWhitePalette
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	beq loc_801563A
	b loc_801573C
loc_801563A:
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_8015648
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_8015648:
	mov r0, #0
	ldr r1, [r5,#oBattleObject_Unk_5c]
	lsl r1, r1, #0x10
	lsr r1, r1, #0x18
	cmp r1, #4
	beq loc_801565C
	cmp r1, #6
	beq loc_801565C
	cmp r1, #7
	bne loc_801565E
loc_801565C:
	mov r0, #1
loc_801565E:
	add r0, #1
	strb r0, [r7,#oAIAttackVars_Unk_01]
	mov r0, #0x8e
	bl PlaySoundEffect
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	bl sub_800F46C
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl battleObject_refreshSpriteAndArm_800F2C6
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r0, #0x14
	lsl r0, r0, #0x10
	add r3, r3, r0
	mov r4, #3
	bl spawn_t1_0x0_EffectObject
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #4
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
	ldr r0, off_8015928 // =loc_8001440 
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #0x10
	bl object_clearFlag2
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_1f]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_8011384
	mov r0, #0
	mov r1, #0
	bl chip_class_lookup_800FC9E
	mov r0, #0x80
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	bl sprite_hasShadow
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	cmp r0, #2
	beq loc_80156DC
	mov r0, #0
	bl object_setAnimation
loc_80156DC:
	ldrb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl sprite_forceWhitePalette
	bl sub_80158CC
	mov r1, #0x2c 
	mov r2, #0
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r0, #0
	bl battle_setObjectTextId_8015B22
	bl battle_beginTurnOpenProcess_80144C0
	bl sub_80143B4
	bl object_clearInvulnerableTime
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #0
	bl sub_8011268
	mov r0, #3
	bl battleObject_computeAIStepForwardDeltaX_8018856
	neg r1, r1
	bl battleObject_setCustomGaugeBarAnimate_801DC06
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	str r0, [r1,#oAIData_Unk_40]
	mov r0, #0xa1
	add r0, #0xff
	strh r0, [r5,#oBattleObject_NameID]
	mov r0, #0x1e
	strh r0, [r7,#oAIAttackVars_Unk_10]
loc_801573C:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bgt locret_8015764
	ldr r0, dword_801592C // =0x1000863d 
	bl ClearAIData_Unk_44_Flag
	ldr r0, dword_8015930 // =0x200900 
	bl ClearAIDataUnk0x48Flag
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	cmp r0, #2
	beq loc_801575C
	bl object_exitAttackState
	b locret_8015764
loc_801575C:
	ldr r0, [r5,#oBattleObject_Unk_5c]
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	mov r0, #0
	str r0, [r5,#oBattleObject_Unk_5c]
locret_8015764:
	pop {r4,pc}
	thumb_func_end sub_801562C

	thumb_local_start
sub_8015766:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	mov r6, #1
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #0xa0
	bl sprite_forceWhitePalette
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	beq loc_801577C
	b loc_801589C
loc_801577C:
	mov r0, #4
	bl battle_setFlags
	mov r0, #0x8e
	bl PlaySoundEffect
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	bl sub_8011450
	bl sub_800F46C
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl battleObject_refreshSpriteAndArm_800F2C6
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r0, #0x14
	lsl r0, r0, #0x10
	add r3, r3, r0
	mov r4, #3
	bl spawn_t1_0x0_EffectObject
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #4
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
	ldr r0, dword_8015934 // =0x80111c40 
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #0x10
	bl object_clearFlag2
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_1f]
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_80157EE
	mov r1, #1
	strb r1, [r0,#oBattleObject_Param3]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_80157EE:
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	str r0, [sp]
	bl sub_8011384
	mov r1, #0
	ldr r0, [sp]
	cmp r0, #0xa
	ble loc_801580A
	mov r1, #0xb
	cmp r0, #0x11
	ble loc_801580A
	mov r1, #0xc
loc_801580A:
	str r1, [sp]
	mov r0, #0
	bl chip_class_lookup_800FC9E
	mov r0, #0x80
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	bl sprite_hasShadow
	mov r0, #0
	bl object_setAnimation
	ldrb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl sprite_forceWhitePalette
	mov r1, #0x2c 
	ldr r2, [sp]
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r0, [sp]
	bl battle_setObjectTextId_8015B22
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x80
	bl battle_setPlayerNaviStatsField0E_8015BEC
	bl battle_beginTurnOpenProcess_80144C0
	bl sub_80143B4
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #0
	bl sub_8011268
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	cmp r0, #0
	beq loc_8015878
	mov r1, #1
	strb r1, [r0,#oBattleObject_Param3]
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #0x14
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
loc_8015878:
	mov r0, #3
	bl battleObject_computeAIStepForwardDeltaX_8018856
	neg r1, r1
	bl battleObject_setCustomGaugeBarAnimate_801DC06
	bl object_clearInvulnerableTime
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	bl object_clearCollisionRegion // () -> void
	mov r0, #0x1e
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_801589C:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bgt loc_80158C6
	ldr r0, dword_8015938 // =0x240800 
	bl ClearAIDataUnk0x48Flag
	ldr r0, [r5,#oBattleObject_RelatedObject2Ptr]
	tst r0, r0
	beq loc_80158B4
	mov r1, #0
	strb r1, [r0,#oBattleObject_Param3]
loc_80158B4:
	mov r0, #4
	bl battle_clearFlags
	mov r0, #1
	bl object_setCollisionRegion
	mov r0, #0
	strh r0, [r7,#oAIAttackVars_Unk_00]
	mov r6, #0
loc_80158C6:
	mov r0, r6
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8015766

	thumb_local_start
sub_80158CC:
	push {lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	mov r1, #0x80
	strb r1, [r0,#0xe]
	bl GetBattleMode
	cmp r0, #1
	beq locret_80158F8
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xb
	blt locret_80158F8
	cmp r0, #0x16
	bgt loc_80158F4
	bl sub_801443C
	b locret_80158F8
loc_80158F4:
	bl sub_8014466
locret_80158F8:
	pop {pc}
	thumb_func_end sub_80158CC

	thumb_local_start
sub_80158FA:
	push {lr}
	ldr r0, dword_8015924 // =0x80111c40 
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #0x10
	bl object_clearFlag2
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_1f]
	ldr r0, dword_801593C // =0x200800 
	bl ClearAIDataUnk0x48Flag
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0
	strh r1, [r0,#oCollisionData_Unk_2c]
	strh r1, [r0,#oCollisionData_Unk_2a]
	strh r1, [r0,#oCollisionData_Unk_1c]
	str r1, [r0,#oCollisionData_Unk_58]
	str r1, [r0,#oCollisionData_Unk_60]
	pop {pc}
	.balign 4, 0
dword_8015924:
	.word 0x80111C40
off_8015928:
	.word 0x8001440
dword_801592C:
	.word 0x1000863D
dword_8015930:
	.word 0x200900
dword_8015934:
	.word 0x80111C40
dword_8015938:
	.word 0x240800
dword_801593C:
	.word 0x200800
	thumb_func_end sub_80158FA

// symdb: Resets the record at byte_203CED0 (marker byte and dword at +4 set to 0xFF) and stores the value returned by sub_80103EC at +8.
// symdb: void initRecord_203CED0(void) /* r4, r5, r6, r10 pass through untouched; caller sees the c/v
// symdb: flags left by sub_80103EC */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8015940.yaml
	thumb_func_start sub_8015940
sub_8015940:
	push {r5,lr}
	ldr r5, off_8015B34 // =byte_203CED0 
	mov r1, #0xff
	strb r1, [r5]
	strb r1, [r5,#0x4] // (dword_203CED4 - 0x203ced0)
	bl battle_preUpdateAndGetPlayerObject_80103EC
	str r0, [r5,#0x8] // (byte_203CED8 - 0x203ced0)
	pop {r5,pc}
	thumb_func_end sub_8015940

	thumb_func_start sub_8015952
sub_8015952:
	push {r4,lr}
	ldr r4, off_8015B38 // =byte_203CED0 
	strb r0, [r4]
	strb r1, [r4,#0x1] // (byte_203CED1 - 0x203ced0)
	strb r2, [r4,#0x3] // (byte_203CED3 - 0x203ced0)
	pop {r4,pc}
	thumb_func_end sub_8015952

// symdb: Reads three AIData fields (ActorType, AIIndex, Unk_03) for the AI slot given by r0 and returns them in r0/r1/r3.
// symdb: (r0 = aiSlotIndex) -> r0 = ActorType, r1 = AIIndex, r3 = Unk_03 ; side effects: none (leaf)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_ai_getActorInfo_801595E.yaml
	thumb_local_start
battle_ai_getActorInfo_801595E:
	mov r3, #0x10
	mul r3, r0
	ldr r0, off_8015B3C // =unk_203A980 
	add r3, r3, r0
	ldrb r0, [r3]
	ldrb r1, [r3,#1]
	ldrb r3, [r3,#3]
	mov pc, lr
	thumb_func_end battle_ai_getActorInfo_801595E

	thumb_local_start
sub_801596E:
	push {r5,lr}
	mov r5, r0
	beq locret_801597A
	ldr r0, dword_8015B40 // =0x4000 
	bl SetAIData_Unk_44_Flag
locret_801597A:
	pop {r5,pc}
	thumb_func_end sub_801596E

// symdb: Returns 1 if battle object AIData has Unk_48 & 0x80 set, else 0 (nullptr-safe).
// symdb: (r0 = *BattleObject) -> r0 = 0 or 1 ; side effects: none
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_checkAIUnk0x48Flag0x80_801597C.yaml
	thumb_local_start
battleObject_checkAIUnk0x48Flag0x80_801597C:
	push {r5,lr}
	mov r5, r0
	beq locret_8015992
	bl GetAIDataUnk0x48Flag
	mov r2, #0
	mov r1, #0x80
	tst r0, r1
	beq loc_8015990
	mov r2, #1
loc_8015990:
	mov r0, r2
locret_8015992:
	pop {r5,pc}
	thumb_func_end battleObject_checkAIUnk0x48Flag0x80_801597C

	thumb_local_start
sub_8015994:
	push {r5,lr}
	mov r5, r0
	beq locret_80159A0
	mov r0, #0x40 
	bl SetAIData_Unk_44_Flag
locret_80159A0:
	pop {r5,pc}
	thumb_func_end sub_8015994

// symdb: Returns whether a battle object's AI data has one of two special-state flags set (0x100 in the +0x48 flag word or 0x40 in the +0x44 flag word).
// symdb: u32 battle_isObjectInSpecialAiState_80159A2(BattleObject* object); // r0 = object pointer (NULL
// symdb: allowed); returns 1/0 in r0; c and v always clear on return, n/z reflect the result; r5 and r7
// symdb: preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_isObjectInSpecialAiState_80159A2.yaml
	thumb_local_start
battle_isObjectInSpecialAiState_80159A2:
	push {r5,r7,lr}
	mov r7, #0
	mov r5, r0
	beq loc_80159C2
	mov r7, #1
	bl GetAIDataUnk0x48Flag
	ldr r1, off_8015B44 // =0x100 
	tst r0, r1
	bne loc_80159C2
	bl GetAIData_Unk_44_Flag
	mov r1, #0x40 
	tst r0, r1
	bne loc_80159C2
	mov r7, #0
loc_80159C2:
	mov r0, r7
	pop {r5,r7,pc}
	thumb_func_end battle_isObjectInSpecialAiState_80159A2

// symdb: Tests whether a battle object may currently beast-out / cross over (sets an AI state flag and validates the Navi's transformation state).
// symdb: u32 canBattleObjectBeastOut_80159C6(u32 battle_obj /* r0 */); /* returns 0/1 (flags NZ) */
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/canBattleObjectBeastOut_80159C6.yaml
	thumb_local_start
canBattleObjectBeastOut_80159C6:
	push {r5,r6,lr}
	mov r6, #0
	mov r5, r0
	beq .failure
	bl GetBattleMode
	cmp r0, #1
	beq .isCrossoverBattle
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrb r1, [r0,#oAIData_Unk_0f]
	tst r1, r1
	bne .failure
	mov r1, #2
	strb r1, [r0,#oAIData_Unk_0f]
	mov r1, #oNaviStats_BeastOutCounter 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne .failure
	bl sub_801443C
.isCrossoverBattle
	mov r1, #oNaviStats_Transformation 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xb
	blt .failure
	cmp r0, #0x18
	bgt .failure
	bl GetBattleMode
	cmp r0, #1
	beq .isCrossoverBattle_2
	mov r1, #oNaviStats_BeastOutCounter 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne .failure
.isCrossoverBattle_2
	mov r6, #1
.failure
	mov r0, r6
	pop {r5,r6,pc}
	thumb_func_end canBattleObjectBeastOut_80159C6

// symdb: Decrements a one-byte countdown timer stored in a battle object's AI data (offset 0x0F) when that timer is enabled and the object's navi stats byte 0x29 is clear.
// symdb: void sub_8015A16(BattleObject* obj /* r0 */); // inputs: r0 = battle object, r5/r6 passed
// symdb: through and preserved; outputs: r1 = AI data pointer (or 0x29 stats id on bail-outs), r2 = new
// symdb: timer value; clobbers r0, NZCV flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_TickAIDataTimer0f_8015A16.yaml
	thumb_func_start battle_TickAIDataTimer0f_8015A16
battle_TickAIDataTimer0f_8015A16:
	push {r5,lr}
	mov r5, r0
	beq locret_8015A36
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne locret_8015A36
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	ldrb r2, [r1,#oAIData_Unk_0f]
	cmp r2, #0xff
	beq locret_8015A36
	tst r2, r2
	beq locret_8015A36
	sub r2, #1
	strb r2, [r1,#oAIData_Unk_0f]
locret_8015A36:
	pop {r5,pc}
	thumb_func_end battle_TickAIDataTimer0f_8015A16

// symdb: Ticks the Navi's stat 0x21 countdown timer down by one if the gate flag is clear, the navi isn't paused, and the status-kind is in range.
// symdb: u32 sub_8015A38(u32 battleObject /* r0 */); // -> r0 = 0; r2 trashed; r5/r6/r7 preserved; NZCV
// symdb: clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8015A38.yaml
	thumb_func_start sub_8015A38
sub_8015A38:
	push {r5,r7,lr}
	mov r7, #0
	mov r5, r0
	beq loc_8015A7C
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_8015A7C
	mov r1, #0x17
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xb
	beq loc_8015A7C
	cmp r0, #0xc
	beq loc_8015A7C
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xb
	blt loc_8015A66
	cmp r0, #0x18
	ble loc_8015A68
loc_8015A66:
	b loc_8015A7C
loc_8015A68:
	mov r1, #0x21 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_8015A7C
	sub r0, #1
	mov r2, r0
	mov r1, #0x21 
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
loc_8015A7C:
	mov r0, r7
	pop {r5,r7,pc}
	thumb_func_end sub_8015A38

	thumb_local_start
sub_8015A80:
	push {r5,lr}
	mov r5, r0
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0xb
	blt loc_8015A92
	cmp r0, #0x18
	ble locret_8015AA4
loc_8015A92:
	mov r1, #0x21 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #3
	bge locret_8015AA4
	add r2, r0, #1
	mov r1, #0x21 
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
locret_8015AA4:
	pop {r5,pc}
	thumb_func_end sub_8015A80

	thumb_func_start sub_8015AA6
sub_8015AA6:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x10
	str r0, [sp]
	str r1, [sp,#4]
	bl object_getFrontDirection // () -> int
	str r0, [sp,#8]
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #2
	ldr r1, off_8015AF4 // =off_8015AF8 
	ldr r0, [r1,r0]
	str r0, [sp,#0xc]
loc_8015ABE:
	ldr r0, [sp]
	ldr r1, [sp,#4]
	bl object_isValidPanel
	beq loc_8015AEE
	ldr r0, [sp]
	ldr r1, [sp,#4]
	bl object_getPanelParameters
	ldr r1, [sp,#0xc]
	tst r0, r1
	beq loc_8015AE4
	ldr r0, [sp]
	ldr r1, [sp,#4]
	mov r2, #0
	mov r3, #0
	mov r6, #0
	bl sub_80CC0B2
loc_8015AE4:
	ldr r0, [sp]
	ldr r1, [sp,#8]
	add r0, r0, r1
	str r0, [sp]
	b loc_8015ABE
loc_8015AEE:
	add sp, sp, #0x10
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8015AF4:
	.word off_8015AF8
off_8015AF8:
	.word LCDControl
	.word 0x8000000
	thumb_func_end sub_8015AA6

	thumb_func_start sub_8015B00
sub_8015B00:
	push {lr}
	bl object_getFrontDirection // () -> int
	add r0, r0, r0
	ldrb r1, [r5,#oBattleObject_PanelX]
	add r0, r0, r1
	ldrb r1, [r5,#oBattleObject_PanelY]
	ldr r2, dword_8015B48 // =0x10000 
	ldr r3, dword_8015B4C // =0xf800000 
	push {r0,r1}
	bl object_checkPanelParameters
	tst r0, r0
	pop {r0,r1}
	bne locret_8015B20
	mov r0, #0
locret_8015B20:
	pop {pc}
	thumb_func_end sub_8015B00

// symdb: Writes a text/name ID into a battle object's NameID field, mapping id 0 to the default 0x1A0.
// symdb: void battle_setObjectTextId(u16 textId /*r0*/, struct BattleObject* obj /*r5*/)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_setObjectTextId_8015B22.yaml
	thumb_local_start
battle_setObjectTextId_8015B22:
	ldr r1, off_8015B50 // =0x1a0 
	cmp r0, #0
	beq loc_8015B2E
	sub r1, r0, #1
	add r1, #0xad
	add r1, #0xff
loc_8015B2E:
	strh r1, [r5,#oBattleObject_NameID]
	mov pc, lr
	.balign 4, 0
off_8015B34:
	.word byte_203CED0
off_8015B38:
	.word byte_203CED0
off_8015B3C:
	.word unk_203A980
dword_8015B40:
	.word 0x4000
off_8015B44:
	.word 0x100
dword_8015B48:
	.word 0x10000
dword_8015B4C:
	.word 0xF800000
off_8015B50:
	.word 0x1A0
	thumb_func_end battle_setObjectTextId_8015B22

// symdb: Thin thumb wrapper that tail-calls possiblyGetBattleEmotion_8015B64 to fetch the player's current battle emotion/transformation state.
// symdb: (u8 alliance /* r0 */) -> (enum8? emotion /* r0 */, u8 transformation /* r1 */, u8 mood /* r2
// symdb: */, u8 beastOutCounter /* r3 */); flags c, v passed through from the callee
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/callPossiblyGetBattleEmotion_8015B54.yaml
	thumb_func_start callPossiblyGetBattleEmotion_8015B54
callPossiblyGetBattleEmotion_8015B54: // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	push {lr}
	bl possiblyGetBattleEmotion_8015B64 // (alliance: bool) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	pop {pc}
	thumb_func_end callPossiblyGetBattleEmotion_8015B54

	thumb_func_start sub_8015B5C
sub_8015B5C:
	push {lr}
	bl sub_8015BA8
	pop {pc}
	thumb_func_end sub_8015B5C

// symdb: Picks the player's current battle emotion (face/sprite state) from AI anger/chip flags and the navi's mood, returning it alongside transformation, mood and Beast Out counter from NaviStats.
// symdb: u32 battle_getPlayerEmotion(u32 alliance /*r0: false=player side?*/); -> r0 = emotion (0..5), r1
// symdb: = NaviStats.Transformation, r2 = NaviStats.Mood, r3 = NaviStats.BeastOutCounter, C = set unless
// symdb: emotion 0 or early-out on AIData.Unk_36, V = clear; r4-r6 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/possiblyGetBattleEmotion_8015B64.yaml
	thumb_local_start
possiblyGetBattleEmotion_8015B64: // (alliance: bool) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	push {r4-r6,lr}

	mov r4, r0
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats

	mov r6, r0

	mov r0, r4
	bl battle_findPlayer // (alliance: bool) -> * BattleObject

	mov r5, r0
	ldr r4, [r5,#oBattleObject_AIDataPtr]

	mov r1, #oNaviStats_Transformation 
	ldrb r1, [r6,r1]
	ldrb r2, [r6,#oNaviStats_Mood]

	mov r0, #5

	ldrh r3, [r4,#oAIData_Unk_36]
	tst r3, r3
	bne loc_8015BA2 /*+20*/

	cmp r2, #0
	beq loc_8015BA2 /*+24*/

	mov r0, #3

	ldrh r3, [r4,#oAIData_Anger]
	tst r3, r3
	bne loc_8015BA2 /*+2c*/

	mov r0, #1

	ldrh r3, [r4,#oAIData_Unk_32]
	tst r3, r3
	bne loc_8015BA2 /*+34*/

	mov r0, #2

	cmp r2, #0xff
	beq loc_8015BA2 /*+3a*/

	mov r0, #0

loc_8015BA2:

	mov r3, #oNaviStats_BeastOutCounter 
	ldrb r3, [r6,r3]

	pop {r4-r6,pc}
	thumb_func_end possiblyGetBattleEmotion_8015B64

	thumb_local_start
sub_8015BA8:
	push {r4-r6,lr}
	mov r4, r0
	bl GetBattleNaviStats2034A60Addr
	mov r6, r0
	mov r0, r4
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r5, r0
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0x2c 
	ldrb r1, [r6,r1]
	ldrb r2, [r6,#0xe]
	mov r0, #5
	ldrh r3, [r4,#oAIData_Unk_36]
	tst r3, r3
	beq loc_8015BE6
	cmp r2, #0
	beq loc_8015BE6
	mov r0, #3
	ldrh r3, [r4,#oAIData_Anger]
	tst r3, r3
	bne loc_8015BE6
	mov r0, #1
	ldrh r3, [r4,#oAIData_Unk_32]
	tst r3, r3
	beq loc_8015BE6
	mov r0, #2
	cmp r2, #0xff
	beq loc_8015BE6
	mov r0, #0
loc_8015BE6:
	mov r3, #0x21 
	ldrb r3, [r6,r3]
	pop {r4-r6,pc}
	thumb_func_end sub_8015BA8

// symdb: Writes a one-byte value to offset 0x0E of the given side's player NaviStats, but only when the player object exists and is in a state accepted by two state-check helpers.
// symdb: void battle_setPlayerNaviStatsField0E(u32 alliance, u8 value) // r0 = alliance flag, r1 = byte
// symdb: to store; flags on return are those left by the last executed call
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_setPlayerNaviStatsField0E_8015BEC.yaml
	thumb_func_start battle_setPlayerNaviStatsField0E_8015BEC
battle_setPlayerNaviStatsField0E_8015BEC:
	push {r4-r6,lr}
	mov r6, r0
	mov r4, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	cmp r0, #0
	beq locret_8015C10
	mov r5, r0
	bl battle_aiAIDataUnk32IsZero_801445C
	bne locret_8015C10
	bl battle_checkAIDataUnk36IsNonZero_8014490
	bne locret_8015C10
	mov r0, r6
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	strb r4, [r0,#0xe]
locret_8015C10:
	pop {r4-r6,pc}
	thumb_func_end battle_setPlayerNaviStatsField0E_8015BEC

// symdb: Lowers the active Navi's mood by a given amount, clamping it at a minimum of 1.
// symdb: void navi_DecreaseMood(bool alliance /* r0: flag passed to GetBattleNaviStatsAddr */, u32 amount
// symdb: /* r1 */); returns flags from CMP (reduced mood vs 1) in c/v/nz
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/navi_DecreaseMood_8015C12.yaml
	thumb_local_start
navi_DecreaseMood_8015C12:
	push {r4,lr}
	mov r4, r1
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	ldrb r1, [r0,#oNaviStats_Mood]
	tst r1, r1
	beq locret_8015C2A
	sub r1, r1, r4
	cmp r1, #1
	bge loc_8015C28
	mov r1, #1
loc_8015C28:
	strb r1, [r0,#oNaviStats_Mood]
locret_8015C2A:
	pop {r4,pc}
	thumb_func_end navi_DecreaseMood_8015C12

// symdb: Trivial stub that always returns the constant 128 (0x80)
// symdb: void sub_8015C2C(void) -> returns 0x80 in r0
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8015C2C.yaml
	thumb_local_start
sub_8015C2C:
	push {lr}
	mov r0, #0x80
	pop {pc}
	thumb_func_end sub_8015C2C

// symdb: Resets the Mood byte of every one of the 7 navi stats entries to 0.
// symdb: void ZeroAllNaviStatsMood(void); // in: r10 (context base, passed through to SetNaviStatsByte),
// symdb: out: r0-r3 clobbered by last helper call, flags from final cmp
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ZeroAllNaviStatsMood.yaml
	thumb_func_start ZeroAllNaviStatsMood
ZeroAllNaviStatsMood:
	push {r4,lr}
	mov r4, #0
.setNaviMoodLoop
	mov r0, r4
	mov r1, #oNaviStats_Mood
	mov r2, #0
	bl SetNaviStatsByte
	add r4, #1
	cmp r4, #7
	blt .setNaviMoodLoop
	pop {r4,pc}
	thumb_func_end ZeroAllNaviStatsMood

// symdb: Random relative panel picker (alliance-aware): collects the filtered panels except the object's current one via the alliance's filter callback, rolls GetPositiveSignedRNG % count and decodes the byte (x = low 3 bits, y = high nibble); with no valid panel it returns the object's current panel (0 draws).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8015C48.yaml
	thumb_func_start sub_8015C48
sub_8015C48:
	push {r7,lr}
	sub sp, sp, #0x18
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #3
	ldr r1, off_8015C80 // =byte_8015C84
	add r0, r0, r1
	ldr r2, [r0]
	ldr r3, [r0,#4]
	add r7, sp, #0
	bl object_getPanelsExceptCurrentFiltered
	tst r0, r0
	beq loc_8015C78
	mov r7, r0
	bl GetPositiveSignedRNG
	mov r1, r7
	svc 6
	add r0, sp, #0
	ldrb r0, [r0,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	b loc_8015C7C
loc_8015C78:
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
loc_8015C7C:
	add sp, sp, #0x18
	pop {r7,pc}
	.balign 4, 0
off_8015C80:
	.word byte_8015C84
byte_8015C84:
	.byte 0x10, 0x0, 0x0, 0x0, 0xA0, 0x0, 0x88, 0xF, 0x30, 0x0, 0x0, 0x0, 0x80
	.byte 0x0, 0x88, 0xF
	thumb_func_end sub_8015C48

// symdb: Random panel picker (no filter callback): GetPositiveSignedRNG % count over the filtered panel list except the current panel, decoding x = low 3 bits / y = high nibble; returns the current panel when none is valid (0 draws).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8015C94.yaml
	thumb_func_start sub_8015C94
sub_8015C94:
	push {r7,lr}
	sub sp, sp, #0x18
	add r7, sp, #0
	bl object_getPanelsExceptCurrentFiltered
	tst r0, r0
	beq loc_8015CB8
	mov r7, r0
	bl GetPositiveSignedRNG
	mov r1, r7
	svc 6
	add r0, sp, #0
	ldrb r0, [r0,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	b loc_8015CBC
loc_8015CB8:
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
loc_8015CBC:
	add sp, sp, #0x18
	pop {r7,pc}
	thumb_func_end sub_8015C94

	thumb_func_start sub_8015CC0
sub_8015CC0:
	push {lr}
	sub sp, sp, #0x34
	str r0, [sp,#8]
	str r1, [sp,#0xc]
	str r2, [sp,#0x18]
	str r3, [sp,#0x1c]
	str r4, [sp,#0x28]
	mov r0, #0
	str r0, [sp,#0x20]
	str r0, [sp,#0x24]
	str r0, [sp,#0x2c]
	str r0, [sp,#0x30]
	ldrb r0, [r5,#oBattleObject_Alliance]
	ldrb r1, [r5,#oBattleObject_DirectionFlip]
	bl object_getAllianceDirection
	neg r0, r0
	str r0, [sp,#0x10]
	ldr r1, [sp,#8]
	add r1, r1, r0
	str r1, [sp,#8]
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #2
	ldr r1, off_8015D74 // =byte_8015D78 
	ldr r0, [r1,r0]
	str r0, [sp,#0x14]
loc_8015CF4:
	ldr r0, [sp,#8]
	ldr r1, [sp,#0xc]
	bl object_getPanelParameters
	ldr r1, [sp,#0x14]
	tst r0, r1
	beq loc_8015D16
	ldr r2, [sp,#8]
	str r2, [sp,#0x2c]
	ldr r2, [sp,#0xc]
	str r2, [sp,#0x30]
	ldr r0, [sp,#0x24]
	add r0, #1
	str r0, [sp,#0x24]
	ldr r1, [sp,#0x28]
	cmp r0, r1
	bgt loc_8015D52
loc_8015D16:
	ldr r0, [sp,#0x24]
	ldr r1, [sp,#0x28]
	cmp r0, r1
	bne loc_8015D40
	ldr r0, [sp,#8]
	ldr r1, [sp,#0xc]
	ldr r2, [sp,#0x18]
	ldr r3, [sp,#0x1c]
	bl object_checkPanelParameters
	tst r0, r0
	beq loc_8015D40
	ldr r0, [sp,#8]
	ldr r1, [sp,#0xc]
	lsl r1, r1, #4
	orr r0, r1
	add r1, sp, #0
	ldr r2, [sp,#0x20]
	strb r0, [r1,r2]
	add r2, #1
	str r2, [sp,#0x20]
loc_8015D40:
	ldr r0, [sp,#8]
	ldr r1, [sp,#0x10]
	add r0, r0, r1
	str r0, [sp,#8]
	ldr r1, [sp,#0xc]
	bl object_isValidPanel
	tst r0, r0
	bne loc_8015CF4
loc_8015D52:
	ldr r0, [sp,#0x20]
	tst r0, r0
	beq loc_8015D6A
	bl GetPositiveSignedRNG
	ldr r1, [sp,#0x20]
	svc 6
	add r0, sp, #0
	ldrb r0, [r0,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
loc_8015D6A:
	ldr r2, [sp,#0x2c]
	ldr r3, [sp,#0x30]
	add sp, sp, #0x34
	pop {pc}
	.balign 4, 0
off_8015D74:
	.word byte_8015D78
byte_8015D78:
	.byte 0x0, 0x0, 0x80, 0x1, 0x0, 0x0, 0x80, 0x2
	thumb_func_end sub_8015CC0

	thumb_func_start panelFlagCheck_8015D80
// r0 - panel X
// r1 - panel Y
// r2 - panel set flags
// r3 - panel clear flags
// r4 - relative panel offsets
// symdb: Filtered random relative panel picker used by AI: walks a candidate panel list (relative offsets, 0x7F terminator), transforms each by the object's facing (object_getEnemyDirection), checks the panel, and rolls GetPositiveSignedRNG (svc 6) over the survivors; 0 candidates -> 0 draws.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/panelFlagCheck_8015D80.yaml
panelFlagCheck_8015D80:
	push {r4,lr}
	sub sp, sp, #0x38
	str r0, [sp,#0x1c]
	str r1, [sp,#0x20]
	str r2, [sp,#0x24]
	str r3, [sp,#0x28]
	bl object_getEnemyDirection
	str r0, [sp,#0x18]
	mov r0, #0
	str r0, [sp,#0x2c]
loc_8015D96:
	mov r0, #0
	ldrsb r0, [r4,r0]
	cmp r0, #0x7f
	beq loc_8015DD4
	ldr r1, [sp,#0x18]
	mul r0, r1
	ldr r2, [sp,#0x1c]
	add r0, r0, r2
	mov r1, #1
	ldrsb r1, [r4,r1]
	ldr r2, [sp,#0x20]
	add r1, r1, r2
	str r0, [sp,#0x30]
	str r1, [sp,#0x34]
	ldr r2, [sp,#0x24]
	ldr r3, [sp,#0x28]
	bl object_checkPanelParameters
	tst r0, r0
	beq loc_8015DD0
	ldr r0, [sp,#0x30]
	ldr r1, [sp,#0x34]
	lsl r1, r1, #4
	orr r0, r1
	ldr r1, [sp,#0x2c]
	add r2, sp, #0
	strb r0, [r2,r1]
	add r1, #1
	str r1, [sp,#0x2c]
loc_8015DD0:
	add r4, #2
	b loc_8015D96
loc_8015DD4:
	ldr r0, [sp,#0x2c]
	tst r0, r0
	beq loc_8015DEC
	bl GetPositiveSignedRNG
	ldr r1, [sp,#0x2c]
	svc 6
	add r0, sp, #0
	ldrb r0, [r0,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
loc_8015DEC:
	add sp, sp, #0x38
	pop {r4,pc}
	thumb_func_end panelFlagCheck_8015D80

	thumb_local_start
sub_8015DF0:
	push {r4,lr}
	sub sp, sp, #0x38
	str r2, [sp,#0x24]
	str r3, [sp,#0x28]
	mov r0, #0
	str r0, [sp,#0x2c]
loc_8015DFC:
	ldrb r0, [r4]
	cmp r0, #0x7f
	beq loc_8015E2A
	ldrb r1, [r4,#1]
	str r0, [sp,#0x30]
	str r1, [sp,#0x34]
	ldr r2, [sp,#0x24]
	ldr r3, [sp,#0x28]
	bl object_checkPanelParameters
	tst r0, r0
	beq loc_8015E26
	ldr r0, [sp,#0x30]
	ldr r1, [sp,#0x34]
	lsl r1, r1, #4
	orr r0, r1
	ldr r1, [sp,#0x2c]
	add r2, sp, #0
	strb r0, [r2,r1]
	add r1, #1
	str r1, [sp,#0x2c]
loc_8015E26:
	add r4, #2
	b loc_8015DFC
loc_8015E2A:
	ldr r0, [sp,#0x2c]
	tst r0, r0
	beq loc_8015E42
	bl GetPositiveSignedRNG
	ldr r1, [sp,#0x2c]
	svc 6
	add r0, sp, #0
	ldrb r0, [r0,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
loc_8015E42:
	add sp, sp, #0x38
	pop {r4,pc}
	thumb_func_end sub_8015DF0

	thumb_func_start GetRandomRelativePanelFiltered
// input:
// r0 - panelx
// r1 - panely
// r2 - panel params that should be set
// r3 - panel params that should be clear
// r4 - which list of relative panel offsets
// r6 - alliance direction
// returns:
// r0 - random panelx
// r1 - random panely
// r2 - number of available panels
// symdb: Picks a random reachable panel relative to a given panel, indexing PanelOffsetListsPointerTable by the caller's panel id.
// symdb: u32 getRandomRelativePanelFiltered_8015E46(u32 r0, u32 r1, u32 r2, u32 r3, u32 panel_index, u32
// symdb: r6) -> r0,r1,r2,r3,r5 + nz/c/v flags preserved across the call
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetRandomRelativePanelFiltered.yaml
GetRandomRelativePanelFiltered:
	push {r4,r7,lr}
	ldr r7, =PanelOffsetListsPointerTable
	lsl r4, r4, #2
	ldr r4, [r7,r4]
	bl _GetRandomRelativePanelFiltered
	pop {r4,r7,pc}
	// 8015E54
	.pool
	thumb_func_end GetRandomRelativePanelFiltered

	thumb_local_start
// GetRandomRelativePanelFilteredFromList
// symdb: Filtered random relative panel picker: transforms candidate relative panels by the alliance direction, validates them (object_checkPanelParameters) and picks one with GetPositiveSignedRNG % valid_count; no valid panel -> 0 draws.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/_GetRandomRelativePanelFiltered.yaml
_GetRandomRelativePanelFiltered:
	push {r4,r6,lr}
	sub sp, sp, #0x38
	str r0, [sp,#0x1c] // oStack_PanelX
	str r1, [sp,#0x20] // oStack_PanelY
	str r2, [sp,#0x24] // oStack_SetPanelParams
	str r3, [sp,#0x28] // oStack_ClearPanelParams
	mov r0, r6
	bl object_getAllianceDirection
	str r0, [sp,#0x2c] // oStack_Direction
	mov r6, #0
.loop
	mov r0, #0
	ldrsb r0, [r4,r0]
	cmp r0, #0x7f
	beq .doneCheckingPanels
	mov r1, #1
	ldrsb r1, [r4,r1]
	ldr r2, [sp,#0x2c] // oStack_Direction
	mul r0, r2 // direction is signed, 1 or -1
	ldr r2, [sp,#0x1c] // oStack_PanelX
	add r0, r0, r2
	str r0, [sp,#0x30] // oStack_RelativePanelX
	ldr r2, [sp,#0x20] // oStack_PanelY
	add r1, r1, r2
	str r1, [sp,#0x34] // oStack_RelativePanelY
	ldr r2, [sp,#0x24] // oStack_SetPanelParams
	ldr r3, [sp,#0x28] // oStack_ClearPanelParams
	bl object_checkPanelParameters
	tst r0, r0
	beq .notMatchingPanelParams
	ldr r0, [sp,#0x30] // oStack_RelativePanelX
	ldr r1, [sp,#0x34] // oStack_RelativePanelY
	lsl r1, r1, #4
	orr r0, r1
	add r1, sp, #0
	strb r0, [r1,r6]
	add r6, #1
.notMatchingPanelParams
	add r4, #2
	b .loop
.doneCheckingPanels
	mov r2, r6
	mov r0, r6
	beq .noPanelMatch
	bl GetPositiveSignedRNG
	mov r1, r6
	svc 6
	add r0, sp, #0
	ldrb r0, [r0,r1]
	lsr r1, r0, #4 // r1 = panel y
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d // r0 = panel x
	mov r2, r6
.noPanelMatch
	add sp, sp, #0x38
	pop {r4,r6,pc}
	thumb_func_end _GetRandomRelativePanelFiltered

	thumb_local_start
sub_8015EC6:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x10
	ldrb r0, [r5,#0x16]
	lsl r0, r0, #2
	ldr r1, off_8015F30 // =byte_8015F38 
	ldr r2, [r1,r0]
	mov r3, #0
	add r7, sp, #0
	bl object_getPanelsExceptCurrentFiltered
	mov r4, r0
	beq loc_8015F2A
	mov r6, #6
	add r7, sp, #0
loc_8015EE2:
	ldrb r0, [r7]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	ldrb r0, [r5,#0x13]
	sub r0, r0, r1
	cmp r0, #0
	bge loc_8015EF4
	neg r0, r0
loc_8015EF4:
	cmp r0, r6
	bge loc_8015EFC
	mov r6, r0
	str r1, [sp,#4]
loc_8015EFC:
	sub r4, #1
	bgt loc_8015EE2
	ldrb r0, [r5,#0x16]
	lsl r0, r0, #3
	ldr r1, off_8015F34 // =byte_8015F40
	add r1, r1, r0
	ldr r2, [r1]
	ldr r3, [r1,#4]
	ldr r0, [sp,#4]
	add r7, sp, #0
	bl object_getPanelsInRowFiltered
	mov r4, r0
	beq loc_8015F2A
	bl GetPositiveSignedRNG
	mov r1, r4
	svc 6
	add r0, sp, #0
	ldrb r0, [r0,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
loc_8015F2A:
	add sp, sp, #0x10
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8015F30:
	.word byte_8015F38
off_8015F34:
	.word byte_8015F40
byte_8015F38:
	.byte 0x0, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0x8
byte_8015F40:
	.byte 0x10, 0x0, 0x0, 0x0, 0xA0, 0x0, 0x88, 0xF, 0x30, 0x0, 0x0, 0x0, 0x80
	.byte 0x0, 0x88, 0xF, 0x10, 0xB5, 0xA8, 0x7D, 0xC0, 0x0, 0x6, 0x49, 0x40, 0x18
	.byte 0x2, 0x68, 0x43, 0x68, 0x3, 0x4C, 0xA8, 0x7C, 0xE9, 0x7C, 0xFF, 0xF7, 0xC
	.byte 0xFF, 0x10, 0xBD, 0x0, 0x0
	.word byte_8015F84
	.word byte_8015F74
byte_8015F74:
	.byte 0x10, 0x0, 0x0, 0x0, 0xA0, 0x0, 0x88, 0xF, 0x30, 0x0, 0x0, 0x0, 0x80
	.byte 0x0, 0x88, 0xF
byte_8015F84:
	.byte 0x0, 0xFF, 0x0, 0x1, 0x7F, 0x0, 0x0, 0x0, 0x80, 0xB5, 0x81, 0xB0
	.byte 0xA8, 0x7D, 0xE9, 0x7D, 0x0, 0xAF, 0xF7, 0xF7, 0x2B, 0xF9, 0x7, 0x1C
	.byte 0x8, 0xD0, 0xEB, 0xF7, 0xC8, 0xFA, 0x39, 0x1C, 0x6, 0xDF, 0x0, 0xA8
	.byte 0x40, 0x5C, 0x1, 0x9, 0x40, 0x7, 0x40, 0xF, 0x1, 0xB0, 0x80, 0xBD
	.byte 0x80, 0xB5, 0x81, 0xB0, 0xA8, 0x7D, 0xE9, 0x7D, 0x0, 0xAF, 0xF7, 0xF7
	.byte 0x57, 0xF9, 0x7, 0x1C, 0x8, 0xD0, 0xEB, 0xF7, 0xB4, 0xFA, 0x39, 0x1C
	.byte 0x6, 0xDF, 0x0, 0xA8, 0x40, 0x5C, 0x1, 0x9, 0x40, 0x7, 0x40, 0xF
	.byte 0x1, 0xB0, 0x80, 0xBD, 0x80, 0xB5, 0x81, 0xB0, 0xA8, 0x7D, 0xE9, 0x7D
	.byte 0x0, 0xAF, 0xF7, 0xF7, 0x8B, 0xF9, 0x7, 0x1C, 0x8, 0xD0, 0xEB, 0xF7
	.byte 0xA0, 0xFA, 0x39, 0x1C, 0x6, 0xDF, 0x0, 0xA8, 0x40, 0x5C, 0x1, 0x9
	.byte 0x40, 0x7, 0x40, 0xF, 0x1, 0xB0, 0x80, 0xBD
	thumb_func_end sub_8015EC6

	thumb_func_start sub_8016004
sub_8016004:
	push {r7,lr}
	sub sp, sp, #0x18
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	add r7, sp, #0
	bl sub_801632C
	mov r7, r0
	beq loc_8016038
	bl GetPositiveSignedRNG
	mov r1, r7
	svc 6
	add r2, sp, #0
	ldrb r0, [r2,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	mov r3, #1
	ldrb r2, [r5,#oBattleObject_PanelX]
	sub r2, r2, r0
	bge loc_8016034
	mov r3, #0
loc_8016034:
	ldrb r2, [r5,#oBattleObject_Alliance]
	eor r2, r3
loc_8016038:
	add sp, sp, #0x18
	pop {r7,pc}
	.word byte_8016040
	.balign 4, 0
byte_8016040:
	.byte 0x0, 0x0, 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x40, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0xD0, 0xB5, 0x8D, 0xB0, 0xA8, 0x7D, 0x7, 0x90, 0xE9, 0x7D, 0xC, 0x91, 0xC0, 0x0
	.byte 0x3D, 0x49, 0x9, 0x18, 0xA, 0x68, 0x4B, 0x68, 0x0, 0xAF, 0xF6, 0xF7, 0xFC, 0xFE, 0x7
	.byte 0x1C, 0x6E, 0xD0, 0x0, 0x24, 0x0, 0x26
loc_8016074:
	add r0, sp, #0
	ldrb r0, [r0,r6]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	ldrb r1, [r5,#0x12]
	ldr r2, [sp,#0x1c]
	ldr r3, [sp,#0x30]
	eor r2, r3
	tst r2, r2
	bne loc_8016090
	cmp r0, r1
	bgt loc_8016094
	b loc_801609E
loc_8016090:
	cmp r0, r1
	bge loc_801609E
loc_8016094:
	add r0, sp, #0
	ldrb r0, [r0,r6]
	add r1, sp, #0x18
	strb r0, [r1,r4]
	add r4, #1
loc_801609E:
	add r6, #1
	cmp r6, r7
	blt loc_8016074
	tst r4, r4
	beq loc_8016114
loc_80160A8:
	mov r7, r4
	add r1, sp, #0x18
	ldrb r0, [r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	str r0, [sp,#0x20]
	str r1, [sp,#0x24]
	ldrb r2, [r5,#0x12]
	sub r0, r0, r2
	cmp r0, #0
	bge loc_80160C2
	neg r0, r0
loc_80160C2:
	str r0, [sp,#0x28]
	ldrb r2, [r5,#0x13]
	sub r1, r1, r2
	cmp r1, #0
	bge loc_80160CE
	neg r1, r1
loc_80160CE:
	str r1, [sp,#0x2c]
	mov r6, #1
loc_80160D2:
	cmp r6, r7
	bge loc_801610E
	add r1, sp, #0x18
	ldrb r0, [r1,r6]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	ldrb r2, [r5,#0x12]
	sub r2, r2, r0
	cmp r2, #0
	bge loc_80160EA
	neg r2, r2
loc_80160EA:
	ldrb r3, [r5,#0x13]
	sub r3, r3, r1
	cmp r3, #0
	bge loc_80160F4
	neg r3, r3
loc_80160F4:
	ldr r4, [sp,#0x28]
	cmp r2, r4
	bgt loc_801610A
	blt loc_8016102
	ldr r4, [sp,#0x24]
	cmp r1, r4
	blt loc_8016102
loc_8016102:
	str r0, [sp,#0x20]
	str r1, [sp,#0x24]
	str r2, [sp,#0x28]
	str r3, [sp,#0x2c]
loc_801610A:
	add r6, #1
	b loc_80160D2
loc_801610E:
	ldr r0, [sp,#0x20]
	ldr r1, [sp,#0x24]
	b loc_801614E
loc_8016114:
	mov r4, #0
	mov r6, #0
loc_8016118:
	add r0, sp, #0
	ldrb r0, [r0,r6]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	ldrb r1, [r5,#0x12]
	ldr r2, [sp,#0x1c]
	ldr r3, [sp,#0x30]
	eor r2, r3
	tst r2, r2
	bne loc_8016134
	cmp r0, r1
	blt loc_8016138
	b loc_8016142
loc_8016134:
	cmp r0, r1
	ble loc_8016142
loc_8016138:
	add r0, sp, #0
	ldrb r0, [r0,r6]
	add r1, sp, #0x18
	strb r0, [r1,r4]
	add r4, #1
loc_8016142:
	add r6, #1
	cmp r6, r7
	blt loc_8016118
	tst r4, r4
	bne loc_80160A8
	mov r0, #0
loc_801614E:
	add sp, sp, #0x34
	pop {r4,r6,r7,pc}
	.balign 4, 0x00
	.word byte_8016158
byte_8016158:
	.byte 0x0, 0x0, 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x40, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0xB5, 0xA8, 0x7D, 0xC2, 0x0, 0xB, 0x49, 0x89, 0x18, 0xA, 0x68, 0x4B, 0x68
	.byte 0x1, 0x21, 0x48, 0x40, 0xE9, 0x7C, 0xF6, 0xF7, 0x83, 0xFF, 0x0, 0x42, 0xA, 0xD1, 0xA8
	.byte 0x7D, 0xC2, 0x0, 0x5, 0x49, 0x89, 0x18, 0xA, 0x68, 0x4B, 0x68, 0x1, 0x21, 0x48, 0x40
	.byte 0xE9, 0x7C, 0xF6, 0xF7, 0x76, 0xFF, 0x0, 0xBD
	.word byte_80161A4
	.word byte_80161B4
byte_80161A4:
	.byte 0x20, 0x0, 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x40, 0x0, 0x20
	.byte 0x0, 0x0, 0x0
byte_80161B4:
	.byte 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0
	.byte 0x0, 0x80, 0xB5, 0x88, 0xB0, 0x0, 0x92, 0x1, 0x93, 0xA8, 0x7C, 0xE9, 0x7C, 0x5, 0xF0
	.byte 0xA4, 0xFC, 0xE8, 0x7C, 0x0, 0x9A, 0x1, 0x9B, 0x2, 0xAF, 0xF6, 0xF7, 0xE3, 0xFE, 0x0
	.byte 0x42, 0x7, 0xD1, 0xE8, 0x7C, 0x0, 0x9A, 0x1, 0x9B, 0x2, 0xAF, 0xF6, 0xF7, 0x11, 0xFF
	.byte 0x0, 0x42, 0x9, 0xD0, 0x7, 0x1C, 0xEB, 0xF7, 0x9C, 0xF9, 0x39, 0x1C, 0x6, 0xDF, 0x2
	.byte 0xA8, 0x40, 0x5C, 0x1, 0x9, 0x40, 0x7, 0x40, 0xF, 0x3, 0xB4, 0xA8, 0x7C, 0xE9, 0x7C
	.byte 0x5, 0xF0, 0x9A, 0xFC, 0x3, 0xBC, 0x8, 0xB0, 0x80, 0xBD
	thumb_func_end sub_8016004

	thumb_func_start sub_8016218
sub_8016218:
	push {r4,lr}
	sub sp, sp, #0x10
	bl object_getFrontDirection // () -> int
	str r0, [sp]
	ldrb r1, [r5,#oBattleObject_PanelX]
	add r0, r0, r1
	str r0, [sp,#4]
	ldrb r0, [r5,#oBattleObject_Alliance]
	lsl r0, r0, #2
	ldr r1, off_8016288 // =byte_8016290 
	ldr r0, [r1,r0]
	str r0, [sp,#0xc]
loc_8016232:
	mov r4, #0
	str r1, [sp,#8]
	ldr r0, [sp,#4]
	mov r1, #2
	bl object_isValidPanel
	beq loc_801626C
loc_8016240:
	ldrb r0, [r5,#oBattleObject_PanelY]
	sub r0, #1
	mov r1, #3
	mul r0, r1
	ldr r1, off_801628C // =byte_8016298
	add r1, r1, r0
	ldrb r1, [r1,r4]
	str r1, [sp,#8]
	ldr r0, [sp,#4]
	bl object_getPanelParameters
	ldr r1, [sp,#0xc]
	tst r0, r1
	bne loc_8016270
	add r4, #1
	cmp r4, #3
	blt loc_8016240
	ldr r0, [sp]
	ldr r1, [sp,#4]
	add r1, r1, r0
	str r1, [sp,#4]
	b loc_8016232
loc_801626C:
	mov r0, #0
	b loc_8016282
loc_8016270:
	ldr r0, [sp,#4]
	ldr r1, [sp,#8]
	mov r3, #1
	ldrb r2, [r5,#oBattleObject_PanelX]
	sub r2, r2, r0
	bge loc_801627E
	mov r3, #0
loc_801627E:
	ldrb r2, [r5,#oBattleObject_Alliance]
	eor r2, r3
loc_8016282:
	add sp, sp, #0x10
	pop {r4,pc}
	.byte 0x0, 0x0
	.balign 4, 0
off_8016288:
	.word byte_8016290
off_801628C:
	.word byte_8016298
byte_8016290:
	.byte 0x0, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0x8
byte_8016298:
	.byte 0x1, 0x2, 0x3, 0x2, 0x1, 0x3, 0x3, 0x1, 0x2, 0x0, 0x0, 0x0, 0xB8, 0x7D, 0xF9
	.byte 0x7D, 0xF7, 0x46, 0xC0, 0xB5, 0x86, 0xB0, 0x4, 0x90, 0x6, 0x91, 0x0, 0xAF, 0xF6, 0xF7
	.byte 0x9C, 0xFF, 0x0, 0x42, 0x2C, 0xD0, 0x5, 0x90, 0x0, 0x26, 0x0, 0x27, 0x4, 0x98, 0x6
	.byte 0x99, 0xF8, 0xF7, 0x2, 0xF8, 0x2, 0x1C, 0x0, 0xA9, 0x88, 0x5D, 0x1, 0x9, 0x40, 0x7
	.byte 0x40, 0xF, 0x80, 0x18, 0xF6, 0xF7, 0xE, 0xFB, 0x4, 0x9A, 0x92, 0x0, 0xE, 0x49, 0x89
	.byte 0x58, 0x8, 0x42, 0x7, 0xD1, 0xD, 0x49, 0x8, 0x42, 0x4, 0xD0, 0x0, 0xA9, 0x1, 0xAA
	.byte 0x88, 0x5D, 0xD0, 0x55, 0x1, 0x37, 0x1, 0x36, 0x5, 0x98, 0x86, 0x42, 0xE0, 0xDB, 0x38
	.byte 0x1C, 0x8, 0xD0, 0xEB, 0xF7, 0x15, 0xF9, 0x39, 0x1C, 0x6, 0xDF, 0x1, 0xA8, 0x40, 0x5C
	.byte 0x1, 0x9, 0x40, 0x7, 0x40, 0xF, 0x6, 0xB0, 0xC0, 0xBD, 0x0, 0x0
	.word byte_8016324
	.word 0x10000
byte_8016324:
	.byte 0x0, 0x0, 0x80, 0x1, 0x0, 0x0, 0x80, 0x2
	thumb_func_end sub_8016218

	thumb_func_start sub_801632C
sub_801632C:
	push {r4-r7,lr}
	mov r1, r0
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	lsl r1, r1, #2
	ldr r2, off_8016368 // =byte_801636C 
	ldr r1, [r2,r1]
	add r0, r0, r1
	mov r1, #0
	mov r6, #0
loc_8016340:
	push {r0,r1}
	lsl r1, r1, #2
	ldr r0, [r0,r1]
	tst r0, r0
	beq loc_801635A
	ldrb r1, [r0,#0x12]
	ldrb r2, [r0,#0x13]
	mov r0, r1
	mov r1, r2
	lsl r1, r1, #4
	orr r0, r1
	strb r0, [r7,r6]
	add r6, #1
loc_801635A:
	pop {r0,r1}
	add r1, #1
	cmp r1, #4
	blt loc_8016340
	mov r0, r6
	pop {r4-r7,pc}
	.balign 4, 0
off_8016368:
	.word byte_801636C
byte_801636C:
	.byte 0x80, 0x0, 0x0, 0x0, 0x90, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_801632C

	thumb_func_start RunSpawnAnimationMaybe_8016380
RunSpawnAnimationMaybe_8016380:
	push {lr}
	ldr r0, [r5,#oBattleObject_AIDataPtr]

	ldrb r0, [r0,#oAIData_Unk_02]
	cmp r0, #0
	bne loc_8016390

	bl battle_object_runPhaseHandler_8016396
	b locret_8016394

loc_8016390:

	bl sub_80164A0
locret_8016394:
	pop {pc}
	thumb_func_end RunSpawnAnimationMaybe_8016380

// symdb: Dispatches the battle object in R5 to the handler for its current phase (0, 4 or 8), tail-calling it via a jump table.
// symdb: void battle_object_runPhaseHandler(void) — reads oBattleObject_CurPhase from the object in R5;
// symdb: passes the phase byte in R0 and the handler's own Thumb entry address in R1; all other registers
// symdb: and flags pass through to the handler and its return value to the caller.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_object_runPhaseHandler_8016396.yaml
	thumb_local_start
battle_object_runPhaseHandler_8016396:
	push {lr}
	ldr r1, off_80163A4 // =off_80163A8 
	ldrb r0, [r5,#oBattleObject_CurPhase]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
off_80163A4:
	.word off_80163A8
off_80163A8:
	.word battleObject_joinAlly_80163B4+1
	.word battle_object_tickHitFlashAlpha_801641A+1
	.word battle_objectIntroEntryAndActedSetup_8016460+1
	thumb_func_end battle_object_runPhaseHandler_8016396

// symdb: Phase-update step for a battle object that joins the player's side: flag it as friendly, set its init state, or play the ally-join sound and transition to phase 4.
// symdb: void sub_80163B4(void /* r5=obj, r10=toolkit */); clobbers r0,r1,r2,r3,lr and NZCV; preserves
// symdb: r4-r7,r5,r10. Returns: r0 = phase status / last ST value, r1 = 2.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObject_joinAlly_80163B4.yaml
	thumb_local_start
battleObject_joinAlly_80163B4:
	push {lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_80163E2
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r1, [r1,#oBattleState_Unk_0d]
	ldrb r0, [r5,#oBattleObject_Alliance]
	eor r0, r1
	bne loc_80163D6
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	orr r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	mov r0, #8
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	b locret_8016418
loc_80163D6:
	mov r0, #0
	bl list_tryAddUniqueEntry_800AA1A
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	b loc_8016410
loc_80163E2:
	bl battle_getStateUnk5c_800139A
	mov r1, #1
	tst r0, r1
	beq loc_8016410
	mov r0, #0
	bl battleObject_isCurrentTurnBattleObject_800AA06
	tst r0, r0
	beq loc_8016410
	mov r0, #0x94
	bl PlaySoundEffect
	mov r0, #2
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #0x10
	strh r0, [r5,#oBattleObject_Timer2]
	mov r0, #0
	bl sprite_setAlpha_8002c7a

	mov r0, #4
	strb r0, [r5,#oBattleObject_CurPhase]

	pop {pc}
loc_8016410:
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
locret_8016418:
	pop {pc}
	thumb_func_end battleObject_joinAlly_80163B4

// symdb: Per-tick update for a battle object that animates a hit-flash (mosaic + alpha) for a fixed duration, then advances the object to phase "8".
// symdb: void sub_801641A(u32 r5_battleObj, u32 r1_unused) /* -> r1, clobbers nzcv r0 r2 r3 lr; preserves
// symdb: r4 r7 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_object_tickHitFlashAlpha_801641A.yaml
	thumb_local_start
battle_object_tickHitFlashAlpha_801641A:
	push {lr}
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bne locret_801645E
	mov r0, #2
	strh r0, [r5,#oBattleObject_Timer]
	ldrh r0, [r5,#oBattleObject_Timer2]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer2]
	beq loc_801644C
	push {r0}
	mov r1, r0
	bl sprite_setMosaicSize
	pop {r0}
	sub r0, #0x10
	neg r0, r0
	bl sprite_setAlpha_8002c7a
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	orr r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	b locret_801645E
loc_801644C:
	bl sprite_disableAlpha
	bl sprite_clearMosaic
	mov r0, #0
	bl battleObject_removeFromNextList_800AA40

	mov r0, #8
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]

locret_801645E:
	pop {pc}
	thumb_func_end battle_object_tickHitFlashAlpha_801641A

// symdb: During the battle intro, plays an object's entry effect (unless it belongs to the currently acting side), then marks it as having acted and resets its phase counter.
// symdb: void battle_objectIntroEntryAndActedSetup_8016460(BattleObject* obj /*r5*/, Toolkit* toolkit
// symdb: /*r10*/, u32 unused_r4 /*r4 preserved*/); returns flags nz c v and r0 = state>>2 when the intro
// symdb: gate fails
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_objectIntroEntryAndActedSetup_8016460.yaml
	thumb_local_start
battle_objectIntroEntryAndActedSetup_8016460:
	push {lr}
	bl battle_getStateUnk5c_800139A
	lsr r0, r0, #2
	bcc locret_801649E
	bl GetBattleMode
	cmp r0, #6
	beq loc_801647E
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r1, [r1,#oBattleState_Unk_0d]
	ldrb r0, [r5,#oBattleObject_Alliance]
	eor r0, r1
	beq loc_8016496
loc_801647E:
	mov r0, #0
	mov r1, #0

	ldrh r2, [r5,#oBattleObject_NameID]
	cmp r2, #0x49 
	blt loc_8016492

	cmp r2, #0x4e 
	bgt loc_8016492

	mov r0, #0x20 
	neg r0, r0
	mov r1, #3
loc_8016492:
	bl sub_801DC7C
loc_8016496:

	mov r0, #1
	strb r0, [r5,#oBattleObject_CurAction]

	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_801649E:
	pop {pc}
	thumb_func_end battle_objectIntroEntryAndActedSetup_8016460

	thumb_local_start
sub_80164A0:
	push {lr}
	ldr r1, off_80164B0 // =off_80164B4 
	ldrb r0, [r5,#oBattleObject_CurPhase]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.byte 0, 0
off_80164B0:
	.word off_80164B4
off_80164B4:
	.word sub_80164C0+1
	.word sub_8016520+1
	.word sub_801657E+1
	thumb_func_end sub_80164A0

	thumb_local_start
sub_80164C0:
	push {lr}
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	ldrb r0, [r5,#oBattleObject_PanelX]
	strb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_reservePanel
	bl object_clearCollisionRegion // () -> void
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	mov r0, #0x94
	bl PlaySoundEffect
	mov r0, #0x14
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #0x1e
	strh r0, [r5,#oBattleObject_Timer2]
	mov r1, #0x1f
	mov r0, r1
	lsl r0, r0, #5
	add r0, r0, r1
	lsl r0, r0, #5
	add r0, r0, r1
	bl sprite_setColorShader
	ldr r0, dword_801651C // =0xffff 
	bl object_setInvulnerableTime
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #6
	bl spawn_t1_0x0_EffectObject
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #4
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
	mov r0, #4
	strb r0, [r5,#oBattleObject_CurPhase]
	pop {pc}
	.balign 4, 0
dword_801651C:
	.word 0xFFFF
	thumb_func_end sub_80164C0

	thumb_local_start
sub_8016520:
	push {lr}
	ldrh r0, [r5,#oBattleObject_Timer]
	cmp r0, #0
	beq loc_8016552
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bne loc_801655A
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #0x10
	lsl r4, r4, #0x10
	add r3, r3, r4
	mov r4, #3
	bl spawn_t1_0x0_EffectObject
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #4
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
	mov r0, #0x2a 
	add r0, #0xff
	bl PlaySoundEffect
loc_8016552:
	ldrh r0, [r5,#oBattleObject_Timer2]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer2]
	beq loc_8016574
loc_801655A:
	ldrh r0, [r5,#oBattleObject_Timer2]
	mov r1, r0
	lsl r1, r1, #5
	add r1, r1, r0
	lsl r1, r1, #5
	add r0, r0, r1
	bl sprite_setColorShader
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	orr r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	b locret_801657C
loc_8016574:
	bl sprite_zeroColorShader
	mov r0, #8
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_801657C:
	pop {pc}
	thumb_func_end sub_8016520

	thumb_local_start
sub_801657E:
	push {lr}
	bl GetBattleMode
	cmp r0, #6
	beq loc_8016594
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r1, [r1,#oBattleState_Unk_0d]
	ldrb r0, [r5,#oBattleObject_Alliance]
	eor r0, r1
	beq loc_801659C
loc_8016594:
	mov r0, #0
	mov r1, #0
	bl sub_801DC7C
loc_801659C:
	bl object_clearInvulnerableTime
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	mov r0, #1
	bl object_setCollisionRegion

	mov r0, #1
	strb r0, [r5,#oBattleObject_CurAction]

	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	pop {pc}
	thumb_func_end sub_801657E

// symdb: Sets a battle object's current action to 8 and clears its current phase (and phase-initialized flag), returning 0.
// symdb: void battle_ResetObjectActionState(BattleObject* obj /* passed in r5 */); also returns r0 = 0
// symdb: and sets NZ flags from that zero
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_ResetObjectActionState_80165B8.yaml
	thumb_func_start battle_ResetObjectActionState_80165B8
battle_ResetObjectActionState_80165B8:
	mov r0, #8
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	mov pc, lr
	thumb_func_end battle_ResetObjectActionState_80165B8

// symdb: Per-frame update dispatcher for a battle object - runs a flagged-object handler, skips while paused, otherwise tail-calls the object's current-phase handler from a 2-entry table.
// symdb: void battle_objectUpdateDispatchPhase_80165C2(void); /* object in r5; r0/flags from phase
// symdb: handler passed through to caller */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_objectUpdateDispatchPhase_80165C2.yaml
	thumb_func_start battle_objectUpdateDispatchPhase_80165C2
battle_objectUpdateDispatchPhase_80165C2:
	push {lr}
	bl object_getFlag // () -> int
	ldr r1, dword_80165EC // =0x40000000 
	tst r0, r1
	bne loc_80165E0
	bl battle_isPaused
	bne locret_80165E4
	ldr r1, off_80165E8 // =off_80165F0 
	ldrb r0, [r5,#oBattleObject_CurPhase]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
loc_80165E0:
	bl sub_8016EC4
locret_80165E4:
	pop {pc}
	.balign 4, 0
off_80165E8:
	.word off_80165F0
dword_80165EC:
	.word 0x40000000
off_80165F0:
	.word battle_teardownObject_80165F8+1
	.word battle_fadeOutAndDespawnSelfActor_801664E+1
	thumb_func_end battle_objectUpdateDispatchPhase_80165C2

// symdb: Teardown routine for a single battle object: clears its collision region and result, releases its slot, blanks chip/related-object state, clears AI/barrier data, dispatches a version-specific actor init based on the enemy record, optionally signals the battle is over, and sets the object's phase to 4.
// symdb: void battle_teardownObject_80165F8(void);   // r5 = oBattleObject * (input; not written through)
// symdb: // lr = return address (preserved across the call, popped as pc at end)   // returns in r0 the
// symdb: value 4 (0x4) and sets nz/c/v
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_teardownObject_80165F8.yaml
	thumb_local_start
battle_teardownObject_80165F8:
	push {lr}
	bl object_clearCollisionRegion // () -> void
	bl battle_ClearObjectCollisionResult_801A5E2
	bl battle_resetCollisionState_80101C4
	bl releaseSlotByValue_801DC36
	mov r0, #0
	strb r0, [r5,#oBattleObject_ChipsHeld]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Chip]
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	bl battle_clearAIDataAndBarrier_801A7F4
	ldrh r0, [r5,#oBattleObject_NameID]
	bl GetVerActorTyAndAIIdx_80182B4 // (enemy_idx: u16) -> *const (version: u8, actor_type: ActorType, ai_index: u8)
	ldrb r1, [r0,#1]
	cmp r1, #0
	bne loc_801663A
	ldrb r1, [r0]
	cmp r1, #4
	bge loc_8016634
	ldrb r0, [r0,#2]
	bl battleObject_incrementCollisionRegion_802D644
	b loc_801663A
loc_8016634:
	ldrb r0, [r0,#2]
	bl sub_802D65E
loc_801663A:
	ldrb r0, [r5,#oBattleObject_Param2]
	cmp r0, #1
	bge loc_8016644
	bl relatedToIsBattleOver_800A11C
loc_8016644:
	bl battle_dispatchDestroyEvents_802EF5C
	mov r0, #4
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	pop {pc}
	thumb_func_end battle_teardownObject_80165F8

// symdb: Phase-gated per-frame tick for an in-battle actor that fades to white, then clears alliance targeting, releases its panel reservation, removes itself from the alive-actor list, zeros its AIData+0x74, and finally queues itself for destruction.
// symdb: (r5 = self BattleObject; r10 = Toolkit) -> r0 non-zero ; side effects mutates self BattleObject
// symdb: Timer / PhaseInitialized / CurState / ObjectHeader Flags, self AIData+0x74, sprite palette,
// symdb: alliance target slot, alive-actor list, panel reservation.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_fadeOutAndDespawnSelfActor_801664E.yaml
	thumb_local_start
battle_fadeOutAndDespawnSelfActor_801664E:
	push {r4,r7,lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_8016672
	bl battle_isTimeStop
	bne locret_80166AC
	bl battle_bumpTimerAndReloadSubcount_800AE44
	mov r4, #0
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #0x74 
	bl battle_spawnLinkedObject_80E1A6A
	mov r0, #0x20 
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_8016672:
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bge loc_80166A4
	bl battle_ClearAllianceTargetSlotIfSelf_802CDD0
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	mov r0, r5
	bl RemoveGivenAliveBattleActorFromList
	mov r1, #0
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	str r1, [r0,#oAIData_Unk_74]
	bl battle_getObjectNameID_8011020
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	mov r0, #CUR_STATE_DESTROY
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	b locret_80166AC
loc_80166A4:
	lsr r0, r0, #2
	bcc locret_80166AC
	bl sprite_forceWhitePalette
locret_80166AC:
	pop {r4,r7,pc}
	thumb_func_end battle_fadeOutAndDespawnSelfActor_801664E

	thumb_func_start sub_80166AE
sub_80166AE:
	push {lr}
	bl ai_dispatchByTypeAndIndex_800F3E8
	pop {pc}
	thumb_func_end sub_80166AE

// symdb: Dispatches an AI-specific callback based on the BattleObject's Unk_1f field, used by attack-event functions
// symdb: (r5 = BattleObject*) -> tail-call to one of two helpers (r0 = ..., preserved in r5) ; side
// symdb: effects: jumps to sub_80166D0 or sub_8016730 via a function pointer table indexed by the
// symdb: object's Unk_1f byte
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_dispatchAIDispatchByType_80166B6.yaml
	thumb_local_start
battle_dispatchAIDispatchByType_80166B6:
	push {lr}
	ldr r1, off_80166C4 // =off_80166C8 
	ldrb r0, [r5,#oBattleObject_Unk_1f]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
off_80166C4:
	.word off_80166C8
off_80166C8:
	.word sub_80166D0+1
	.word battleObject_stepMoveToFuturePanel_8016730+1
	thumb_func_end battle_dispatchAIDispatchByType_80166B6

	thumb_local_start
sub_80166D0:
	push {r6,r7,lr}
	mov r0, #1
	lsl r0, r0, #0xc
	bl object_setFlag1 // (int a1) -> void
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	bl object_setCollisionPanelsToCurrent
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	bl battle_objectResolveContactOffset_800E468
	strb r0, [r5,#oBattleObject_Unk_1c]
	strb r1, [r5,#oBattleObject_Unk_1d]
	strb r2, [r5,#oBattleObject_Unk_1b]
	tst r2, r2
	beq loc_8016716
	ldrb r3, [r5,#oBattleObject_PanelX]
	add r0, r0, r3
	ldrb r3, [r5,#oBattleObject_PanelY]
	add r1, r1, r3
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_reservePanel
	mov r0, #4
	strb r0, [r5,#oBattleObject_Unk_1e]
	mov r0, #4
	strb r0, [r5,#oBattleObject_Unk_1f]
	pop {r6,r7,pc}
loc_8016716:
	ldrb r0, [r5,#oBattleObject_Unk_0f]
	cmp r0, #3
	bne loc_8016722
	mov r0, #5
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	strh r0, [r1,#oAIData_Unk_38]
loc_8016722:
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0f]
	mov r0, #1
	lsl r0, r0, #0xc
	bl object_clearFlag // (int bitfield) -> void
	pop {r6,r7,pc}
	thumb_func_end sub_80166D0

// symdb: Per-frame step of a battle object's "moving to its future panel" state (slide / approach), decrementing the timer and finishing by either reverting to standing or starting a new sub-step.
// symdb: (r5 = BattleObject*) -> void ; side effects: panel reserve/release, write to battle object
// symdb: fields, possibly AI data word, clear/leave object collision flags
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_stepMoveToFuturePanel_8016730.yaml
	thumb_local_start
battleObject_stepMoveToFuturePanel_8016730:
	push {r4,r6,r7,lr}
	ldrb r0, [r5,#oBattleObject_Unk_1e]
	sub r0, #1
	strb r0, [r5,#oBattleObject_Unk_1e]
	bgt loc_801680E
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_getPanelDataOffset
	ldrb r4, [r0,#oPanelData_Type]
	cmp r4, #7
	bne loc_8016768
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r0,#oCollisionData_PrimaryElement]
	cmp r0, #2
	beq loc_8016768
	ldrb r0, [r5,#oBattleObject_Unk_1b]
	add r0, #1
	strb r0, [r5,#oBattleObject_Unk_1b]
	b loc_80167B2
loc_8016768:
	cmp r4, #9
	blt loc_80167B2
	cmp r4, #0xc
	bgt loc_80167B2
	bl object_getFlag // () -> int
	mov r1, #0x24 
	tst r0, r1
	bne loc_80167B2
	ldrb r0, [r5,#oBattleObject_Unk_0f]
	cmp r0, #3
	bne loc_8016788
	mov r0, #5
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	strh r0, [r1,#oAIData_Unk_38]
	b loc_80167E6
loc_8016788:
	mov r0, #0x1c
	ldrsb r0, [r5,r0]
	mov r1, #0x1d
	ldrsb r1, [r5,r1]
	ldrb r2, [r5,#oBattleObject_Alliance]
	bl sub_801683C
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r1,#oCollisionData_Direction]
	mov r0, #3
	strb r0, [r5,#oBattleObject_Unk_0f]
	bl battle_objectResolveContactOffset_800E468
	strb r0, [r5,#oBattleObject_Unk_1c]
	strb r1, [r5,#oBattleObject_Unk_1d]
	tst r2, r2
	beq loc_80167E6
	ldrb r0, [r5,#oBattleObject_Unk_1b]
	add r0, #1
	strb r0, [r5,#oBattleObject_Unk_1b]
	b loc_80167B2
loc_80167B2:
	ldrb r0, [r5,#oBattleObject_Unk_1b]
	sub r0, #1
	strb r0, [r5,#oBattleObject_Unk_1b]
	ble loc_80167E6
	mov r2, #0x1c
	ldrsb r2, [r5,r2]
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	add r0, r0, r2
	mov r2, #0x1d
	ldrsb r2, [r5,r2]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	add r1, r1, r2
	mov r6, r0
	mov r7, r1
	bl battle_objectCheckPanelByAlliance_800E5AC
	beq loc_80167E6
	mov r0, #4
	strb r0, [r5,#oBattleObject_Unk_1e]
	mov r0, r6
	mov r1, r7
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_reservePanel
	pop {r4,r6,r7,pc}
loc_80167E6:
	mov r0, #0x1c
	ldrsb r0, [r5,r0]
	mov r1, #0x1d
	ldrsb r1, [r5,r1]
	ldrb r2, [r5,#oBattleObject_Alliance]
	bl sub_801683C
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r1,#oCollisionData_Direction]
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_1f]
	mov r0, #1
	lsl r0, r0, #0xc
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0f]
	bl object_setCollisionPanelsToCurrent
	pop {r4,r6,r7,pc}
loc_801680E:
	mov r0, #0x1c
	ldrsb r0, [r5,r0]
	ldr r2, dword_8016834 // =0xa0000 
	mul r2, r0
	ldr r0, [r5,#oBattleObject_X]
	add r0, r0, r2
	str r0, [r5,#oBattleObject_X]
	mov r0, #0x1d
	ldrsb r0, [r5,r0]
	ldr r2, dword_8016838 // =0x60000 
	mul r2, r0
	ldr r0, [r5,#oBattleObject_Y]
	add r0, r0, r2
	str r0, [r5,#oBattleObject_Y]
	bl object_setPanelsFromCoordinates
	bl object_setCollisionPanelsToCurrent
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_8016834:
	.word 0xA0000
dword_8016838:
	.word 0x60000
	thumb_func_end battleObject_stepMoveToFuturePanel_8016730

	thumb_local_start
sub_801683C:
	tst r2, r2
	beq loc_8016842
	neg r0, r0
loc_8016842:
	mov r3, #4
	tst r0, r0
	beq loc_801684E
	bgt loc_801685C
	mov r3, #3
	b loc_801685C
loc_801684E:
	mov r3, #1
	tst r1, r1
	beq loc_801685A
	blt loc_801685C
	mov r3, #2
	b loc_801685C
loc_801685A:
	mov r3, #5
loc_801685C:
	mov r0, r3
	mov pc, lr
	thumb_func_end sub_801683C

// symdb: Recolor a battle object's sprite as a warm/cool gradient depending on its navi version.
// symdb: (r5 = BattleObjectPtr, r10 = ToolkitPtr) -> r0 = 0 ; side effects: writes the object's high-
// symdb: nibble sprite color shader via sprite_setColorShader.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_updateColorShader_8016860.yaml
	thumb_local_start
battleObject_updateColorShader_8016860:
	push {r4,lr}
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0x17
	blt loc_8016870
	cmp r0, #0x18
	ble locret_80168A2
loc_8016870:
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq locret_80168A2
	cmp r0, #0x56 
	beq locret_80168A2
	bl object_getFlag // () -> int
	mov r1, #8
	tst r0, r1
	beq locret_80168A2
	mov r4, #5
	bl GetBattleMode
	cmp r0, #1
	bne loc_8016890
	mov r4, #0
loc_8016890:
	bl battle_getStateUnk40_800A704
	mov r1, #0x1f
	and r0, r1
	ldr r1, off_80168A4 // =byte_80168A8
	ldrb r0, [r1,r0]
	lsl r0, r4
	bl sprite_setColorShader
locret_80168A2:
	pop {r4,pc}
	.balign 4, 0
off_80168A4:
	.word byte_80168A8
byte_80168A8:
	.byte 0x0, 0x2, 0x4, 0x6, 0x8, 0xA, 0xC, 0xE, 0x10, 0x12, 0x14, 0x16
	.byte 0x18, 0x1A, 0x1C, 0x1E, 0x1E, 0x1C, 0x1A, 0x18, 0x16, 0x14, 0x12, 0x10
	.word byte_80A0C0E
	.word 0x20406
	thumb_func_end battleObject_updateColorShader_8016860

// symdb: Tints the current battle object's sprite with the color shader only when it has status flag 0x800, choosing no-tint/full-tint from a bit of battle_getStateUnk40_800A704.
// symdb: void sub_80168C8(void); // reads r5 (battle object/state context) and r10 (frame/state
// symdb: pointer?); returns r3 plus NZC flags from the flag test path; calls object_getFlag,
// symdb: battle_getStateUnk40_800A704, sprite_setColorShader
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_applyStatusSpriteTint_80168C8.yaml
	thumb_local_start
battle_applyStatusSpriteTint_80168C8:
	push {lr}
	bl object_getFlag // () -> int
	mov r1, #8
	lsl r1, r1, #8
	tst r0, r1
	beq locret_80168E6
	bl battle_getStateUnk40_800A704
	mov r1, #2
	and r0, r1
	ldr r1, off_80168E8 // =dword_80168EC
	ldrh r0, [r1,r0]
	bl sprite_setColorShader
locret_80168E6:
	pop {pc}
	.balign 4, 0
off_80168E8:
	.word dword_80168EC
dword_80168EC:
	.word 0x3FF0000
	thumb_func_end battle_applyStatusSpriteTint_80168C8

// symdb: If the object's state flags have bit 16 set, re-tints the object's sprites with the fixed palette shader 0x7E94.
// symdb: void object_applyTintIfFlag16(object in r0 /* passed through to object_getFlag; r5 also live-in
// symdb: per caller analysis */) -> returns r3 from object_getFlag; clears carry (c=0)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_applyTintIfFlag16_80168F0.yaml
	thumb_local_start
object_applyTintIfFlag16_80168F0:
	push {lr}
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x10
	tst r0, r1
	beq locret_8016904
	ldr r0, word_8016908 // =0x7e94
	bl sprite_setColorShader
locret_8016904:
	pop {pc}
	.balign 4, 0
word_8016908:
	.hword 0x7E94
	thumb_func_end object_applyTintIfFlag16_80168F0

// symdb: Recolors the current battle object's sprite (normal or inverted/white) depending on a bit of the current battle state, if the object opts in via flag 0x4000.
// symdb: void sub_801690A(void); // reads current object via r5/r10; out r3 = value left by
// symdb: sprite_setColorShader
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_applyStateSpriteColorShader_801690A.yaml
	thumb_local_start
battle_applyStateSpriteColorShader_801690A:
	push {lr}
	bl object_getFlag // () -> int
	mov r1, #0x40 
	lsl r1, r1, #8
	tst r0, r1
	beq locret_8016928
	bl battle_getStateUnk40_800A704
	mov r1, #2
	and r0, r1
	ldr r1, off_801692C // =word_8016930
	ldrh r0, [r1,r0]
	bl sprite_setColorShader
locret_8016928:
	pop {pc}
	.balign 4, 0
off_801692C:
	.word word_8016930
word_8016930:
	.hword 0x0, 0xFFFF
	thumb_func_end battle_applyStateSpriteColorShader_801690A

	thumb_func_start blindVisualHandledHere_8016934
blindVisualHandledHere_8016934:
	push {lr}
	bl battle_isTimeStop
	bne loc_8016944
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	orr r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
loc_8016944:
	bl object_getFlag // () -> int
	ldr r1, off_8016A28 // =0x100 
	tst r0, r1
	bne locret_80169BC
	ldr r1, dword_8016A2C // =0x202 
	tst r0, r1
	beq loc_8016964
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	ldrh r0, [r0,#oCollisionData_FlashingInvisTimer]
	lsr r0, r0, #2
	bcc loc_8016964
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #OBJECT_FLAG_VISIBLE
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
loc_8016964:
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r0, [r1,#oBattleState_Unk_0d]
	ldrb r1, [r5,#oBattleObject_Alliance]
	eor r0, r1
	beq loc_8016998
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	tst r0, r0
	beq locret_80169BC
	push {r5}
	mov r5, r0
	bl object_getFlag // () -> int
	ldr r1, off_8016A30 // =0x2000 
	tst r0, r1
	pop {r5}
	beq locret_80169BC
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #OBJECT_FLAG_VISIBLE
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	b locret_80169BC
loc_8016998:
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq locret_80169BC
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r0,#oAIData_ActorType]
	cmp r0, #2
	bne locret_80169BC
	mov r0, #5
	bl dispatch_801DA48
	bl object_getFlag // () -> int
	ldr r1, off_8016A34 // =0x2000 
	tst r0, r1
	beq locret_80169BC
	mov r0, #5
	bl dispatch_801DACC // (a0: flags32) -> ()
locret_80169BC:
	pop {pc}
	thumb_func_end blindVisualHandledHere_8016934

	thumb_func_start handleRenderBlindForSpecificObjectsMaybe_80169BE
handleRenderBlindForSpecificObjectsMaybe_80169BE:
	push {lr}
	bl battle_isTimeStop
	bne loc_80169CE
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	orr r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
loc_80169CE:
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r0, [r1,#oBattleState_Unk_0d]
	ldrb r1, [r5,#oBattleObject_Alliance]
	eor r0, r1
	beq loc_8016A02
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	tst r0, r0
	beq locret_8016A26
	push {r5}
	mov r5, r0
	bl object_getFlag // () -> int
	ldr r1, off_8016A30 // =0x2000 
	tst r0, r1
	pop {r5}
	beq locret_8016A26
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	b locret_8016A26
loc_8016A02:
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq locret_8016A26
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r0,#oAIData_ActorType]
	cmp r0, #2
	bne locret_8016A26
	mov r0, #5
	bl dispatch_801DA48
	bl object_getFlag // () -> int
	ldr r1, off_8016A34 // =0x2000 
	tst r0, r1
	beq locret_8016A26
	mov r0, #5
	bl dispatch_801DACC // (a0: flags32) -> ()
locret_8016A26:
	pop {pc}
	.balign 4, 0
off_8016A28:
	.word 0x100
dword_8016A2C:
	.word 0x202
off_8016A30:
	.word 0x2000
off_8016A34:
	.word 0x2000
	thumb_func_end handleRenderBlindForSpecificObjectsMaybe_80169BE

	thumb_local_start
sub_8016A38:
	push {r4,lr}
	ldr r4, off_8016A60 // =byte_8016A68
	cmp r0, #0x18
	bne loc_8016A42
	ldr r4, off_8016A64 // =byte_8016A9C
loc_8016A42:
	bl battle_getStateUnk40_800A704
	mov r1, #0x1a
	svc 6
	lsl r1, r1, #1
	ldrh r0, [r4,r1]
	bl sprite_setColorShader
	pop {r4,pc}
	.word 0x0
	.word 0x0
	.word 0x0
	.balign 4, 0
off_8016A60:
	.word byte_8016A68
off_8016A64:
	.word byte_8016A9C
byte_8016A68:
	.byte 0x0, 0x0, 0x0, 0x0, 0x41, 0x0, 0x61, 0x4, 0x81, 0x8, 0xC2, 0xC, 0xE2
	.byte 0x10, 0x2, 0x11, 0x43, 0x15, 0x83, 0x19, 0xC3, 0x1D, 0xE4, 0x21, 0x4, 0x22
	.byte 0x4, 0x22, 0xE4, 0x21, 0xC3, 0x1D, 0x83, 0x19, 0x43, 0x15, 0x2, 0x11, 0xE2
	.byte 0x10, 0xC2, 0xC, 0xA2, 0xC
	.word byte_8610881
	.word 0x4210441
byte_8016A9C:
	.byte 0x0, 0x0, 0x0, 0x0, 0x2, 0x4, 0x23, 0x4
	.word 0x8660444
	.word 0x8880887
	.word 0xCCC0CAA
	.word 0x110F0CEE
	.word 0x11101110
	.word 0xCEE110F
	.word 0xCAA0CCC
	.word 0x8870888
	.word 0x8650866
	.word 0x4430444
	.word 0x4210422
	thumb_func_end sub_8016A38

	thumb_local_start
sub_8016AD0:
	push {lr}
	bl battle_getStateUnk40_800A704
	mov r1, #0x1a // (battleObject_initAndRunAI_8016B02 - 0x8016ae8)
	svc 6
	ldr r0, off_8016AE4 // =off_8016AE8 
	ldrb r0, [r0,r1]
	bl sprite_setPalette // (int pallete) -> void
	pop {pc}
	.balign 4, 0
off_8016AE4:
	.word off_8016AE8
off_8016AE8:
	.word unk_2020000
	.byte 0x2, 0x2, 0x2, 0x2, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x2, 0x2, 0x2
	.byte 0x2, 0x2, 0x2, 0x2, 0x2
	thumb_func_end sub_8016AD0

// symdb: Battle object per-frame handler that initializes an object's AI on first call, dispatches its AI handler, then commits a pending state transition if one was staged in Unk_5c
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> void ; side effects: clears OBJECT_FLAGS_INVULNERABLE in
// symdb: the collision data, dispatches AI, resets collision state, mutates object fields
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_initAndRunAI_8016B02.yaml
	thumb_func_start battleObject_initAndRunAI_8016B02
battleObject_initAndRunAI_8016B02:
	push {lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_8016B20
	ldr r0, dword_8016BD4 // =0x100000 
	bl object_clearFlag // (int bitfield) -> void
	bl battle_dispatchActorAIByTypeAndAIIdx_800F394
	bl battle_resetCollisionState_80101C4
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_8016B20:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xb
	tst r0, r1
	bne locret_8016B34
	ldr r0, [r5,#oBattleObject_Unk_5c]
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	mov r0, #0
	str r0, [r5,#oBattleObject_Unk_5c]
locret_8016B34:
	pop {pc}
	thumb_func_end battleObject_initAndRunAI_8016B02

	thumb_func_start sub_8016B36
sub_8016B36:
	push {lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_8016B5C
	ldr r0, dword_8016BD4 // =0x100000 
	bl object_clearFlag // (int bitfield) -> void
	bl sub_800F3B0
	bl battle_resetCollisionState_80101C4
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	mov r0, #0x19
	add r0, #0xff
	bl PlaySoundEffect
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_8016B5C:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x10
	tst r0, r1
	bne locret_8016B70
	ldr r0, [r5,#oBattleObject_Unk_5c]
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	mov r0, #0
	str r0, [r5,#oBattleObject_Unk_5c]
locret_8016B70:
	pop {pc}
	thumb_func_end sub_8016B36

	thumb_func_start sub_8016B72
sub_8016B72:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_8016B9A
	ldr r0, dword_8016BD4 // =0x100000 
	bl object_clearFlag // (int bitfield) -> void
	bl sub_800F3CC
	bl battle_resetCollisionState_80101C4
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	mov r0, #0x2e 
	add r0, #0xff
	bl PlaySoundEffect
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_8016B9A:
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r2, #0x2c 
	ldrsh r1, [r0,r2]
	lsr r1, r1, #2
	mov r0, #0x1f
	and r0, r1
	ldr r1, off_8016BD8 // =byte_8016BDC 
	ldrsb r0, [r1,r0]
	ldrh r1, [r4,#oAIData_Unk_3c]
	add r0, r0, r1
	strh r0, [r5,#oBattleObject_Z16]
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x1f
	tst r0, r1
	bne locret_8016BD0
	mov r0, #0x25 
	add r0, #0xff
	bl PlaySoundEffect
	ldr r0, [r5,#oBattleObject_Unk_5c]
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	mov r0, #0
	str r0, [r5,#oBattleObject_Unk_5c]
	ldrh r0, [r4,#oAIData_Unk_3c]
	strh r0, [r5,#oBattleObject_Z16]
locret_8016BD0:
	pop {r4,pc}
	.balign 4, 0
dword_8016BD4:
	.word 0x100000
off_8016BD8:
	.word byte_8016BDC
byte_8016BDC:
	.byte 0x1, 0x2, 0x3, 0x4, 0x4, 0x5, 0x5, 0x6, 0x6, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1, 0x0, 0xFF
	.byte 0xFE, 0xFD, 0xFC, 0xFC, 0xFB, 0xFB, 0xFA, 0xFA, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF, 0x0
	thumb_func_end sub_8016B72

// symdb: Per-tick battle-object wobble driver that snapshots the rest pose, applies random X/Z variance while a counter is armed, and restores the rest pose when it expires.
// symdb: void stepBattleObjectWobble_8016BFC(u32 /*r5*/ obj);   inputs:  r5 = battle object pointer
// symdb: outputs: r1 = variance result X (wobble path) or collision-data+0x80 halfword (rest path)
// symdb: r4 = preserved from caller   clobbers: r0, r1, r2, r3, NZCV (r4/r6/r7 preserved)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/stepBattleObjectWobble_8016BFC.yaml
	thumb_local_start
stepBattleObjectWobble_8016BFC:
	push {lr}
	ldrb r0, [r5,#oBattleObject_PreventAnim]
	tst r0, r0
	bne loc_8016C14
	ldrh r0, [r5,#oBattleObject_X16]
	strh r0, [r5,#oBattleObject_Unk_30]
	ldrh r0, [r5,#oBattleObject_Z16]
	strh r0, [r5,#oBattleObject_Unk_32]
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_19]
	mov r0, #4
	strb r0, [r5,#oBattleObject_PreventAnim]
loc_8016C14:
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0x80
	ldrh r1, [r0,r1]
	tst r1, r1
	beq loc_8016C22
	mov r0, #0x1e
	strb r0, [r5,#oBattleObject_Unk_19]
loc_8016C22:
	ldrb r0, [r5,#oBattleObject_Unk_19]
	tst r0, r0
	beq loc_8016C44
	sub r0, #1
	strb r0, [r5,#oBattleObject_Unk_19]
	ldrh r1, [r5,#oBattleObject_Unk_30]
	lsl r1, r1, #0x10
	ldr r2, [r5,#oBattleObject_Y]
	ldrh r3, [r5,#oBattleObject_Unk_32]
	lsl r3, r3, #0x10
	mov r0, #3
	bl AddRandomVarianceToTwoCoords
	mov r0, #0x34 
	add r0, r0, r5
	stmia r0!, {r1-r3}
	b locret_8016C4C
loc_8016C44:
	ldrh r0, [r5,#oBattleObject_Unk_30]
	strh r0, [r5,#oBattleObject_X16]
	ldrh r0, [r5,#oBattleObject_Unk_32]
	strh r0, [r5,#oBattleObject_Z16]
locret_8016C4C:
	pop {pc}
	thumb_func_end stepBattleObjectWobble_8016BFC

// symdb: Performs a battle object's destroy-phase cleanup (releases panel reserves, frees its collision slot, decrements alliance counter, marks phase initialized=4, then drops the object).
// symdb: (r5 = BattleObject*; r10 = toolkit) -> void ; side effects: mutates battle object, AI data,
// symdb: collision slot, panel reserves, alliance counter
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_destroy_8016C4E.yaml
	thumb_func_start battleObject_destroy_8016C4E
battleObject_destroy_8016C4E:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne locret_8016C88
	bl RemoveBattleObjectPanelReserves
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	bl object_freeCollisionData
	bl battle_DecrementAllianceCounterSlot4_800A104
	ldrb r0, [r4,#oAIData_Unk_0e]
	cmp r0, #0xff
	beq loc_8016C72
	ldrh r1, [r5,#oBattleObject_HP]
	mov r0, #0xff
	strb r0, [r4,#oAIData_Unk_0e]
loc_8016C72:
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	ldrb r1, [r4,#oAIData_Unk_02]
	cmp r1, #0
	beq locret_8016C88
	mov r0, r4
	beq loc_8016C84
	bl sub_800ED80
loc_8016C84:
	bl object_freeMemory
locret_8016C88:
	pop {r4,pc}
	thumb_func_end battleObject_destroy_8016C4E

// symdb: Generic battle-object destructor that releases the object's panel tile reserves, its collision data, and the object's memory.
// symdb: void object_genericDestroy(void); // r5 = battle object pointer, clobbers r0-r3 and flags,
// symdb: preserves r5-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_genericDestroy.yaml
	thumb_func_start object_genericDestroy
object_genericDestroy:
	push {lr}
	bl RemoveBattleObjectPanelReserves
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	bl object_freeCollisionData
	bl object_freeMemory
	pop {pc}
	thumb_func_end object_genericDestroy

	thumb_func_start sub_8016C9C
sub_8016C9C:
	push {lr}
	bl object_freeMemory
	pop {pc}
	thumb_func_end sub_8016C9C

// symdb: When the battle is running and the object's alliance differs from the battle's emotion-state byte, and that emotion state is 2 (an "enemy of the player's emotion"?), and the collision-data counter-timer is non-zero, applies a palette-color-shader (from the table at 0x8016CE4, indexed by Unk_40 & 2) to this battle object's sprite; otherwise leaves the sprite shader alone.
// symdb: (r5 = BattleObjectPtr, r10 = ToolkitPtr) -> void ; side effects may write the sprite-block
// symdb: color-shader of this BattleObject via sprite_setColorShader
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_applyEmotionShaderIfCounterReady_8016CA4.yaml
	thumb_local_start
battleObject_applyEmotionShaderIfCounterReady_8016CA4:
	push {lr}
	bl battle_isBattleOver
	tst r0, r0
	bne locret_8016CDE
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r1, [r1,#oBattleState_Unk_0d]
	ldrb r0, [r5,#oBattleObject_Alliance]
	eor r1, r0
	beq locret_8016CDE
	mov r1, #1
	eor r0, r1
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	cmp r0, #2
	bne locret_8016CDE
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r3,#oCollisionData_CounterTimer]
	tst r0, r0
	beq locret_8016CDE
	bl battle_getStateUnk40_800A704
	mov r1, #2
	and r0, r1
	ldr r1, off_8016CE0 // =dword_8016CE4
	ldrh r0, [r1,r0]
	bl sprite_setColorShader
locret_8016CDE:
	pop {pc}
	.balign 4, 0
off_8016CE0:
	.word dword_8016CE4
dword_8016CE4:
	.word 0x7C000000
	thumb_func_end battleObject_applyEmotionShaderIfCounterReady_8016CA4

// symdb: Reads a battle object's state byte and tail-jumps to one of three per-state handlers, passing the state byte through.
// symdb: void sub_8016CE8(struct BattleObject* obj /* in r5 */); // r0 = state byte and r1 = handler
// symdb: address passed on to the selected handler; all other registers pass through untouched
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObjectStateDispatcher_8016CE8.yaml
	thumb_func_start battleObjectStateDispatcher_8016CE8
battleObjectStateDispatcher_8016CE8:
	push {lr}
	ldr r1, off_8016CF8 // =off_8016CFC 
	ldrb r0, [r5,#oBattleObject_Unk_0d]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
off_8016CF8:
	.word off_8016CFC
off_8016CFC:
	.word battleAdvanceObjectPhase_8016D08+1
	.word battleObject_landOnDestinationPanel_8016D8C+1
	.word battle_objectCountdownPhaseOrReset_8016E3C+1
	thumb_func_end battleObjectStateDispatcher_8016CE8

// symdb: Advances a single battle object one step through its panel-movement phase: promotes the future panel, dispatches the actor's turn, resolves collisions, then queues the next panel displacement or resets the object to idle.
// symdb: battleAdvanceObjectPhase_8016D08(r5 = BattleObject *obj) -> r0 = 4|8 (sub-phase state), r1/r2 =
// symdb: callee residue, nz from r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleAdvanceObjectPhase_8016D08.yaml
	thumb_local_start
battleAdvanceObjectPhase_8016D08:
	push {r6,r7,lr}
	mov r0, #1
	lsl r0, r0, #0x14
	bl object_setFlag1 // (int a1) -> void
	bl battle_dispatchActorTurnByTypeAndAIIdx_800F404
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	ldr r0, dword_8016D80 // =0x1000 
	bl object_clearFlag // (int bitfield) -> void
	bl battle_resetCollisionState_80101C4
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	bl sub_800E45E
	strb r0, [r5,#oBattleObject_Unk_1c]
	strb r1, [r5,#oBattleObject_Unk_1d]
	strb r2, [r5,#oBattleObject_PhaseInitialized]
	tst r2, r2
	beq loc_8016D74
	mov r1, #0x1c
	ldrsb r1, [r5,r1]
	ldr r0, dword_8016D84 // =0xa0000 
	mul r0, r1
	str r0, [r5,#oBattleObject_XVelocity]
	ldrb r6, [r5,#oBattleObject_PanelX]
	add r6, r6, r1
	mov r1, #0x1d
	ldrsb r1, [r5,r1]
	ldr r0, dword_8016D88 // =0x60000 
	mul r0, r1
	str r0, [r5,#oBattleObject_YVelocity]
	ldrb r7, [r5,#oBattleObject_PanelY]
	add r7, r7, r1
	mov r0, r6
	mov r1, r7
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_reservePanel
	mov r0, #4
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r6,r7,pc}
loc_8016D74:
	mov r0, #0x18
	strb r0, [r5,#oBattleObject_CurPhase]
	mov r0, #8
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r6,r7,pc}
	.balign 4, 0
dword_8016D80:
	.word 0x1000
dword_8016D84:
	.word 0xA0000
dword_8016D88:
	.word 0x60000
	thumb_func_end battleAdvanceObjectPhase_8016D08

// symdb: Advances a battle object toward its reserved destination panel and snaps the FuturePanelX/Y, releasing/re-reserving panels as it crosses panel boundaries.
// symdb: in=(r5 = oBattleObject*) ; out= r4/r5/r6/r7 caller-saved, r0 not surfaced as a meaningful value
// symdb: (write to memory only); no return to caller other than saving r4, jumps via `pop {r4,pc}`.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_landOnDestinationPanel_8016D8C.yaml
	thumb_local_start
battleObject_landOnDestinationPanel_8016D8C:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	mov r2, r0
	mov r4, r1
	ldr r1, [r5,#oBattleObject_X]
	ldr r0, [r5,#oBattleObject_XVelocity]
	add r0, r0, r1
	str r0, [r5,#oBattleObject_X]
	bl IsR2BetweenR0AndR1
	tst r0, r0
	bne loc_8016DBC
	mov r2, r4
	ldr r1, [r5,#oBattleObject_Y]
	ldr r0, [r5,#oBattleObject_YVelocity]
	add r0, r0, r1
	str r0, [r5,#oBattleObject_Y]
	bl IsR2BetweenR0AndR1
	tst r0, r0
	beq loc_8016E2A
loc_8016DBC:
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_getPanelDataOffset
	ldrb r4, [r0,#oPanelData_Type]
	cmp r4, #7
	bne loc_8016DE2
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r0,#oCollisionData_PrimaryElement]
	cmp r0, #2
	beq loc_8016DE2
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	add r0, #1
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	b loc_8016DE4
loc_8016DE2:
	b loc_8016DE4
loc_8016DE4:
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	sub r0, #1
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	ble loc_8016E14
	mov r2, #0x1c
	ldrsb r2, [r5,r2]
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	add r0, r0, r2
	mov r2, #0x1d
	ldrsb r2, [r5,r2]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	add r1, r1, r2
	mov r6, r0
	mov r7, r1
	bl battle_objectCheckPanelByAlliance_800E5AC
	beq loc_8016E14
	mov r0, r6
	mov r1, r7
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_reservePanel
	pop {r4,pc}
loc_8016E14:
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #0x14
	strb r0, [r5,#oBattleObject_CurPhase]
	mov r0, #8
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r4,pc}
loc_8016E2A:
	bl object_setPanelsFromCoordinates
	bl object_updateCollisionPanels
	pop {r4,pc}
	.word 0xA0000, 0x60000
	thumb_func_end battleObject_landOnDestinationPanel_8016D8C

// symdb: Decrements a battle object's phase counter each tick and, when it expires, resets the object's flags and hands its saved state word back to the state machine.
// symdb: void sub_8016E3C(battle object in r5); returns decremented phase in r0 (0 on the reset path),
// symdb: also sets r1/r2, NZCV and lr per caller contract
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_objectCountdownPhaseOrReset_8016E3C.yaml
	thumb_local_start
battle_objectCountdownPhaseOrReset_8016E3C:
	push {lr}
	ldrb r0, [r5,#oBattleObject_CurPhase]
	sub r0, #1
	strb r0, [r5,#oBattleObject_CurPhase]
	bge locret_8016E5E
	ldr r0, dword_8016E60 // =0x101000 
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #0x10
	bl object_clearFlag2
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_1f]
	ldr r0, [r5,#oBattleObject_Unk_5c]
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	mov r0, #0
	str r0, [r5,#oBattleObject_Unk_5c]
locret_8016E5E:
	pop {pc}
	.balign 4, 0
dword_8016E60:
	.word 0x101000
	thumb_func_end battle_objectCountdownPhaseOrReset_8016E3C

// symdb: Drives one battle object's sprite animation per frame, gated on time/pause/HP and a few object flags.
// symdb: void sub_8016E64(u32 battleObj /* r5 */); // preserves r4, r5; clobbers r0-r3, lr, N/Z/C/V;
// symdb: outputs only r5
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObject_updateSprite_8016E64.yaml
	thumb_func_start battleObject_updateSprite_8016E64
battleObject_updateSprite_8016E64:
	push {lr}
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #8
	tst r0, r1
	bne locret_8016EBE
	bl battle_isTimeStop
	bne locret_8016EBE
	ldrh r0, [r5,#oBattleObject_NameID]
	cmp r0, #0x49 
	blt loc_8016E7E
	cmp r0, #0x4e 
	ble loc_8016E84
loc_8016E7E:
	ldrh r0, [r5,#oBattleObject_HP]
	tst r0, r0
	beq locret_8016EBE
loc_8016E84:
	bl GetBattleMode
	cmp r0, #1
	beq loc_8016E92
	bl battle_isPaused
	bne locret_8016EBE
loc_8016E92:
	bl object_getFlag // () -> int
	ldr r1, dword_8016EC0 // =0x80110c00 
	tst r0, r1
	bne locret_8016EBE
	bl object_getFlag2
	mov r1, #8
	tst r0, r1
	bne locret_8016EBE
	ldrb r0, [r5,#oBattleObject_CurAnim]
	ldrb r1, [r5,#oBattleObject_CurAnimCopy]
	cmp r0, r1
	beq loc_8016EBA
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	ldrb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnimCopy]
loc_8016EBA:
	bl sprite_update
locret_8016EBE:
	pop {pc}
	.balign 4, 0
dword_8016EC0:
	.word 0x80110C00
	thumb_func_end battleObject_updateSprite_8016E64

	thumb_func_start sub_8016EC4
sub_8016EC4:
	push {lr}
	ldr r1, JumpTable8016ED8_p // =JumpTable8016ED8
	ldrb r0, [r5,#oBattleObject_CurPhase]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
JumpTable8016ED8_p:
	.word JumpTable8016ED8
JumpTable8016ED8:
	.word sub_8016EE0+1
	.word sub_8016F1A+1
	thumb_func_end sub_8016EC4

	thumb_local_start
sub_8016EE0:
	push {lr}
	bl object_clearCollisionRegion // () -> void
	bl battle_ClearObjectCollisionResult_801A5E2
	bl battle_resetCollisionState_80101C4
	bl releaseSlotByValue_801DC36
	mov r0, #0
	strb r0, [r5,#oBattleObject_ChipsHeld]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Chip]
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	bl battle_clearAIDataAndBarrier_801A7F4
	ldrb r0, [r5,#oBattleObject_Param2]
	cmp r0, #1
	bge loc_8016F0C
	bl relatedToIsBattleOver_800A11C
loc_8016F0C:
	bl battle_dispatchDestroyEvents_802EF5C
	mov r0, #0
	strh r0, [r5,#oBattleObject_HP]
	mov r0, #4
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	pop {pc}
	thumb_func_end sub_8016EE0

	thumb_local_start
sub_8016F1A:
	push {r4,lr}
	bl battle_isTimeStop
	bne locret_8016F54
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #0x14
	bl spawn_t1_0x0_EffectObject
	ldrb r1, [r0,#oObjectHeader_Flags]
	mov r2, #4
	orr r1, r2
	strb r1, [r0,#oObjectHeader_Flags]
	bl battle_ClearAllianceTargetSlotIfSelf_802CDD0
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_74]
	bl sub_80E1A86
	mov r0, r5
	bl RemoveGivenAliveBattleActorFromList
	mov r0, #CUR_STATE_DESTROY
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
locret_8016F54:
	pop {r4,pc}
	thumb_func_end sub_8016F1A

// symdb: Init-state handler of an enemy-navi battle object: loads its sprite/animation/palette/flip from the enemy data record, sets element and secondary weakness, builds collision data with ability flags, queues the name popup and advances to the update state.
// symdb: void battleObject_initNaviObject(u32 r5 /* battle object */) : r5 -> [r4 r5 r6 r7 r10] (r0 =
// symdb: CUR_STATE_UPDATE on the captured exits)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_initNaviObject_8016F56.yaml
	thumb_func_start battleObject_initNaviObject_8016F56
battleObject_initNaviObject_8016F56:
	push {r4,r6,r7,lr}

	// will dispatch some logic based on the alliance/ai index, but most are nullsubs. 
	bl battle_dispatchActorHandlerByType_800F35C

	ldr r6, [r5,#oBattleObject_AIDataPtr]

	ldrh r0, [r5,#oBattleObject_NameID]
	bl enemy_getStruct1
	mov r7, r0

	mov r0, #0x80
	ldrb r1, [r7,#enemy_getStruct1_struct_spriteIndex0]
	ldrb r2, [r7,#enemy_getStruct1_struct_spriteIndex1]
	bl sprite_load // (int a1, int a2, int a3) ->

	ldrb r0, [r7,#enemy_getStruct1_struct_HasShadow]
	cmp r0, #FALSE
	bne loc_8016F7C
	// if there is no shadow

	bl sprite_noShadow // () -> void
	b loc_8016F80

loc_8016F7C: // else

	bl sprite_hasShadow

loc_8016F80: // endif

	mov r0, #0
	strb r0, [r5,#oBattleObject_CurAnim]

	mov r1, #0xff
	strb r1, [r5,#oBattleObject_CurAnimCopy]

	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void

	bl getBattleObjectPalette_800F334 // (obj: * BattleObject $r5) -> u8
	bl sprite_setPalette // (int pallete) -> void

	bl object_getFlip // () -> int
	bl sprite_setFlip

	ldrb r0, [r7,#enemy_getStruct1_struct_Element]
	ldrb r1, [r5,#oBattleObject_Element]
	orr r1, r0
	strb r1, [r5,#oBattleObject_Element]

	bl GetBattleMode
	cmp r0, #6
	bne loc_8016FBE /*+2e*/

	ldrb r0, [r7,#enemy_getStruct1_struct_Unk_04]
	ldr r1, off_80170A0 // =byte_80170A4
	ldrb r0, [r1,r0]
	cmp r0, #0
	bne loc_8016FBE /*+38*/

	mov r0, #0
	str r0, [r5,#oBattleObject_DamageAndStaminaDamageCounterDisabler]

loc_8016FBE: // endif

	bl object_createCollisionData
	tst r0, r0
	bne loc_8016FCC

	bl object_freeMemory
	b locret_8017092

loc_8016FCC: // endif

	push {r0}
	ldrh r0, [r5,#oBattleObject_NameID]
	bl enemy_getStruct2
	ldrb r4, [r0,#enemy_getStruct2_struct_UnkFlags_03]
	pop {r0}

	mov r1, #1
	mov r2, #2

	mov r3, #4
	tst r4, r3
	beq loc_8016FE6

	mov r1, #0x10
	mov r2, #2

loc_8016FE6: // endif

	mov r3, #3
	bl object_setupCollisionData

	ldrb r0, [r7,#enemy_getStruct1_struct_SecondaryElementWeakness]
	bl battleObject_SetSecondaryElementWeakness_8019F9E

	mov r3, #0x10
	tst r4, r3
	beq loc_8017000

	mov r0, #1
	lsl r0, r0, #0x1b
	bl object_setFlag1 // (int a1) -> void

loc_8017000: // endif

	mov r3, #8
	tst r4, r3
	beq loc_801700E

	// Sets OBJECT_FLAGS_AFFECTED_BY_ICE
	mov r0, #1
	lsl r0, r0, #25
	bl object_setFlag1 // (int a1) -> void

loc_801700E: // endif

	mov r3, #4
	tst r4, r3
	beq loc_801701A

	mov r0, #OBJECT_FLAGS_FLOATSHOE
	bl object_setFlag1 // (int a1) -> void

loc_801701A: // endif

	mov r3, #2
	tst r4, r3
	beq loc_8017026

	mov r0, #OBJECT_FLAGS_AIRSHOE
	bl object_setFlag1 // (int a1) -> void

loc_8017026: // endif

	mov r3, #1
	tst r4, r3
	beq loc_8017034

	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_SUPERARMOR_BIT
	bl object_setFlag1 // (int a1) -> void

loc_8017034: // endif

	bl battleObject_registerCustomArm_801DB84

	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject

	bl battle_SetObjectAIDataField78_800F318

	bl GetBattlePanelColumnPattern

	cmp r0, #0x38 
	beq loc_801705C /*+18*/

	cmp r0, #0x30 
	beq loc_801705C /*+1c*/

	cmp r0, #0x3c 
	beq loc_801705C /*+20*/

	bl sub_800F2F0
	b loc_8017064

loc_801705C: // else

	mov r0, #0
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl battleObject_refreshSpriteAndArm_800F2C6

loc_8017064: // endif

	bl battle_objectNameIdToPopupHandler_8010DD0

	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	mov r1, #0x3e 
	bl GetBattleNaviStatsHword
	mov r1, #0x64 
	svc 6 // div

	cmp r0, #0xa
	ble loc_8017080

	mov r0, #0xa
	b loc_8017086

loc_8017080:
	cmp r0, #0
	bgt loc_8017086

	mov r0, #1

loc_8017086:

	ldr r1, [r5,#oBattleObject_AIDataPtr]
	strb r0, [r1,#oAIData_Unk_0c]

	bl battle_dispatchActorByTypeAndAIIdx_800F378

	mov r0, #CUR_STATE_UPDATE
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]

locret_8017092:
	pop {r4,r6,r7,pc}
	.word 0, 0
	.byte 0, 0, 0, 0
	.balign 4, 0
off_80170A0:
	.word byte_80170A4
byte_80170A4:
	.byte 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0
	thumb_func_end battleObject_initNaviObject_8016F56

// symdb: If the battle is not paused, dispatches to a CurPhase-specific handler for the BattleObject in r5 via a 2-entry tail-call table; otherwise returns immediately.
// symdb: (r5 = BattleObject*, r10 = Toolkit) -> r0 = whatever the dispatched handler (battleObject_destroy_80170E4 /
// symdb: sub_8017122) returns (a per-phase status/result byte)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_dispatchPhaseByPaused_80170C4.yaml
	thumb_func_start battleObject_dispatchPhaseByPaused_80170C4
battleObject_dispatchPhaseByPaused_80170C4:
	push {lr}
	bl battle_isPaused
	bne locret_80170D6
	ldr r1, off_80170D8 // =off_80170DC 
	ldrb r0, [r5,#oBattleObject_CurPhase]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
locret_80170D6:
	pop {pc}
	.balign 4, 0
off_80170D8:
	.word off_80170DC
off_80170DC:
	.word battleObject_destroy_80170E4+1
	.word battleObject_runWindRecoveryState_8017122+1
	thumb_func_end battleObject_dispatchPhaseByPaused_80170C4

// symdb: Destroy handler for a battle object — clears its collision state, charges, chips, AI/barrier, sprite flip, decrements alliance, dispatches destroy events, and sets phase to 0x4 (CUR_STATE_UPDATE).
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> void ; side effects: many object fields overwritten;
// symdb: calls sub-battle functions
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_destroy_80170E4.yaml
	thumb_local_start
battleObject_destroy_80170E4:
	push {lr}
	bl object_clearCollisionRegion // () -> void
	bl battle_ClearObjectCollisionResult_801A5E2
	bl battle_resetCollisionState_80101C4
	bl battleObject_clearPwrAtkState_8012EA8
	bl releaseSlotByValue_801DC36
	mov r0, #0
	strb r0, [r5,#oBattleObject_ChipsHeld]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Chip]
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl battle_clearAIDataAndBarrier_801A7F4
	ldrb r0, [r5,#oBattleObject_Param2]
	cmp r0, #1
	bge loc_8017118
	bl relatedToIsBattleOver_800A11C
loc_8017118:
	bl battle_dispatchDestroyEvents_802EF5C
	mov r0, #4
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	pop {pc}
	thumb_func_end battleObject_destroy_80170E4

// symdb: Per-frame update for the Wind-style recovery state of a battle object: on first entry, freezes animation and spawns a linked wind effect + sparkle effect with an 0x5A-frame timer; once the timer expires, releases any reserved panel, removes the actor from the alive list, clears alliance targeting, and destroys the object.
// symdb: (r5 = BattleObject*, r3/r10/lr not really inputs — r3 is destroyed, r10 = toolkit) -> void ;
// symdb: side effects: writes to AIData, spawns two battle objects, removes panel reservation, removes
// symdb: the actor from BattleState.AliveBattleActors, sets CUR_STATE_DESTROY.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_runWindRecoveryState_8017122.yaml
	thumb_local_start
battleObject_runWindRecoveryState_8017122:
	push {r4,r7,lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_8017168
	bl battle_isTimeStop
	bne locret_80171A4
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r2, [r5,#oBattleObject_AIDataPtr]
	str r0, [r2,#oAIData_Unk_68]
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r4, #1
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #0x74 
	bl battle_spawnLinkedObject_80E1A6A
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #0x20 
	lsl r4, r4, #0x10
	add r3, r3, r4
	mov r4, #3
	bl spawn_t1_0x0_EffectObject
	mov r1, #0x5a 
	strh r1, [r0,#oBattleObject_Timer]
	mov r0, #0x5a 
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_8017168:
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bge loc_801719C
	bl battle_ClearAllianceTargetSlotIfSelf_802CDD0
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_74]
	bl sub_80E1A86
	bl battle_getObjectNameID_8011020
	mov r0, r5
	bl RemoveGivenAliveBattleActorFromList
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	mov r0, #CUR_STATE_DESTROY
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	b locret_80171A4
loc_801719C:
	lsr r0, r0, #2
	bcc locret_80171A4
	bl sprite_forceWhitePalette
locret_80171A4:
	pop {r4,r7,pc}
	thumb_func_end battleObject_runWindRecoveryState_8017122

	thumb_func_start sub_80171A6
sub_80171A6:
	push {lr}
	bl battle_isPaused
	bne locret_80171B8
	ldr r1, off_80171BC // =off_80171C0 
	ldrb r0, [r5,#oBattleObject_CurPhase]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
locret_80171B8:
	pop {pc}
	.balign 4, 0
off_80171BC:
	.word off_80171C0
off_80171C0:
	.word sub_80171CC+1
	.word sub_80171D8+1
	.word sub_8017274+1
	thumb_func_end sub_80171A6

	thumb_local_start
sub_80171CC:
	push {lr}
	bl battleObject_destroy_80170E4
	bl musicGameState_8000784 // () -> void
	pop {pc}
	thumb_func_end sub_80171CC

	thumb_local_start
sub_80171D8:
	push {r4,r7,lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_801722C
	bl battle_isTimeStop
	bne locret_8017272
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r2, [r5,#oBattleObject_AIDataPtr]
	str r0, [r2,#oAIData_Unk_68]
	ldrh r0, [r5,#oBattleObject_NameID]
	ldr r1, dword_80172E8 // =0x173 
	cmp r0, r1
	blt loc_8017200
	ldr r1, dword_80172EC // =0x17e 
	cmp r0, r1
	ble loc_8017204
loc_8017200:
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAnim]
loc_8017204:
	mov r4, #1
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #0x74 
	bl battle_spawnLinkedObject_80E1A6A
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #0x20 
	lsl r4, r4, #0x10
	add r3, r3, r4
	mov r4, #3
	bl spawn_t1_0x0_EffectObject
	mov r1, #0x5a 
	strh r1, [r0,#oBattleObject_Timer]
	mov r0, #0x5a 
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_801722C:
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bge loc_801726A
	bl battle_ClearAllianceTargetSlotIfSelf_802CDD0
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldr r0, [r0,#oAIData_Unk_74]
	bl sub_80E1A86
	bl battle_getObjectNameID_8011020
	mov r0, r5
	bl RemoveGivenAliveBattleActorFromList
	mov r0, #4
	mov r1, #4
	bl SetScreenFade // (int a1, int a2) -> void
	mov r4, #1
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #0x74 
	bl battle_spawnLinkedObject_80E1A6A
	mov r0, #8
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	b locret_8017272
loc_801726A:
	lsr r0, r0, #2
	bcc locret_8017272
	bl sprite_forceWhitePalette
locret_8017272:
	pop {r4,r7,pc}
	thumb_func_end sub_80171D8

	thumb_local_start
sub_8017274:
	push {r4,lr}
	bl IsScreenFadeActive // () -> zf
	tst r0, r0
	bne loc_8017284
	mov r0, #CUR_STATE_DESTROY
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	b locret_801728C
loc_8017284:
	lsr r0, r0, #2
	bcc locret_801728C
	bl sprite_forceWhitePalette
locret_801728C:
	pop {r4,pc}
	thumb_func_end sub_8017274

// symdb: Applies a hit-flash darken shader to the sprite of the current acting battle object when the battle is in the "enemy-being-hit" flag state.
// symdb: void battle_applyHitFlashShadeToActor_801728E(void);   // in:  r5 = battle object; r10 = unknown
// symdb: caller state; lr = return   // out: r3, r4 = (clobbered, used by caller); r10 preserved   //
// symdb: clobbers: nzcv r0, r1, lr   // preserved: r4
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_applyDimmerShaderTo_801728E.yaml
	thumb_local_start
battle_applyDimmerShaderTo_801728E:
	push {lr}
	bl battle_testFlag0x40_800A8F8
	tst r0, r0
	beq locret_80172C0
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq locret_80172C0
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	mov r1, #0x50 
	ldrb r1, [r0,r1]
	tst r1, r1
	beq locret_80172C0
	bl battle_getStateUnk40_800A704
	mov r1, #0x1f
	and r0, r1
	ldr r1, off_80172C4 // =byte_80172C8
	ldrb r0, [r1,r0]
	lsl r1, r0, #5
	add r0, r0, r1
	bl sprite_setColorShader
locret_80172C0:
	pop {pc}
	.balign 4, 0
off_80172C4:
	.word byte_80172C8
byte_80172C8:
	.byte 0x0, 0x2, 0x4, 0x6, 0x8, 0xA, 0xC, 0xE, 0x10, 0x12, 0x14, 0x16
	.byte 0x18, 0x1A, 0x1C, 0x1E, 0x1E, 0x1C, 0x1A, 0x18, 0x16, 0x14, 0x12, 0x10
	.word byte_80A0C0E
	.word 0x20406
dword_80172E8:
	.word 0x173
dword_80172EC:
	.word 0x17E
	thumb_func_end battle_applyDimmerShaderTo_801728E

	thumb_func_start playerObject_init_80172F0
playerObject_init_80172F0:
	push {r4,r7,lr}
	bl battle_dispatchActorHandlerByType_800F35C
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x17
	bl GetBattleNaviStatsByte
	mov r2, r0
	mov r1, #0x2c 
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	bl chip_class_lookup_800FC9E
	mov r0, #0x80
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	bl sprite_hasShadow
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl battle_pickPaletteIndexForNavi_801002C
	bl sprite_setPalette // (int pallete) -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl battle_applyStatusTickDamage_80142B0
	bl object_createCollisionData
	tst r0, r0
	bne loc_801735A
	bl object_freeMemory
	b locret_80173F2
loc_801735A:
	push {r0}
	bl battle_IsNoCustomPlusActive_80107C0
	pop {r0}
	mov r1, #1
	mov r2, #2
	bl object_setupCollisionData
	bl battleObject_initPlayerMaxHPFromStats_80141C8
	bl sub_8013892
	bl battleObject_setupSecondaryElementWeaknessFromNaviStats_801086C
	mov r1, #0x29
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_801738A
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl battle_setObjectTextId_8015B22
loc_801738A:
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x2c
	bl GetBattleNaviStatsByte
	bl sub_8011268
	bl battle_beginTurnOpenProcess_80144C0
	bl sub_8013E58
	bl battleObject_registerCustomArm_801DB84
	mov r0, #3
	bl battleObject_computeAIStepForwardDeltaX_8018856
	neg r1, r1
	bl battleObject_setCustomGaugeBarAnimate_801DC06
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_80173C6
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	tst r0, r0
	beq loc_80173C6
	bl releaseSlotByValue_801DC36
loc_80173C6: .align 1, 0
	bl battle_EnableAIUnk0x48FlagForNonstandardBoard_80141F4
	mov r7, #0x58 
	add r7, r7, r4
	bl spawnChargeShotChargeObject_80E0F02
	bl battle_dispatchActorByTypeAndAIIdx_800F378
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte
	cmp r0, #0
	bne loc_80173E6
	bl battle_objectNameIdToPopupHandler_8010DD0
loc_80173E6:
	bl battle_setupAllianceEntryKind3_802DFC8
	bl battle_applyNaviStatDamageTick_8013FF8
	mov r0, #CUR_STATE_UPDATE
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
locret_80173F2:
	pop {r4,r7,pc}
	thumb_func_end playerObject_init_80172F0

// symdb: Forces every sprite into its white flash palette and dispatches the battle object's current phase handler via the jump table at off_801740C.
// symdb: void R5_battleObject (in r5); returns r5/r10 (object), r1 (handler address), r8/r9/r11/r12
// symdb: untouched by the wrapper; nz/c/v clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_80173F4.yaml
	thumb_func_start sub_80173F4
sub_80173F4:
	push {lr}
	bl sprite_forceWhitePalette
	ldr r1, off_8017408 // =off_801740C 
	ldrb r0, [r5,#oBattleObject_CurPhase]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0
off_8017408:
	.word off_801740C
off_801740C:
	.word battle_destroyBattleObject_801741C+1
	.word sub_801746E+1
	.word battle_objectTickTimerAndSetPhaseC_80174AA+1
	.word battle_tickIntroState_80174BE+1
	thumb_func_end sub_80173F4

// symdb: Resets a battle object to its post-destroy / dormant state: clears its collision region/state, PwrAtk charge, AI data, slot reservation, future-panel reservation, chip counters, sprite flip, alliance bookkeeping, and dispatches destroy-subevents; marks CurPhaseAndPhaseInitialized with phase 4.
// symdb: (r5 = oBattleObject*, r10 = oToolkit*) -> r1 (clobbered), r5 (preserved) ; no meaningful return;
// symdb: tailcalls render/cleanup subevents and tail-pops
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_destroyBattleObject_801741C.yaml
	thumb_local_start
battle_destroyBattleObject_801741C:
	push {lr}
	bl object_clearCollisionRegion // () -> void
	bl battle_ClearObjectCollisionResult_801A5E2
	bl battle_resetCollisionState_80101C4
	bl battleObject_clearPwrAtkState_8012EA8
	bl releaseSlotByValue_801DC36
	mov r0, #0
	strb r0, [r5,#oBattleObject_ChipsHeld]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Chip]
	bl object_getFlip // () -> int
	bl sprite_setFlip
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	bl battle_clearAIDataAndBarrier_801A7F4
	ldr r2, [r5,#oBattleObject_AIDataPtr]
	ldr r1, [r2,#oAIData_Unk_58]
	tst r1, r1
	beq loc_801745A
	mov r1, #0
	str r1, [r2,#oAIData_Unk_58]
loc_801745A:
	ldrb r0, [r5,#oBattleObject_Param2]
	cmp r0, #1
	bge loc_8017464
	bl relatedToIsBattleOver_800A11C
loc_8017464:
	bl battle_dispatchDestroyEvents_802EF5C
	mov r0, #4
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	pop {pc}
	thumb_func_end battle_destroyBattleObject_801741C

// symdb: Starts a battle object's destruction sequence (sets anim 2, clears paired object and AI scratch, plays sound 0x6C, spawns two effect objects at the object's position, and arms a 21-frame countdown into phase 8); no-op while time stop is active.
// symdb: void sub_801746E(u32 /*r5*/ obj) -> r1 (callee return), r5 (does r10 hold?); clobbers r0 r2 r3
// symdb: r4 lr; flags NZCV affected. Inputs via r5 (obj) and lr.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801746E.yaml
	thumb_local_start
sub_801746E:
	push {lr}
	bl battle_isTimeStop
	bne locret_80174A8
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0
	str r0, [r1,#oAIData_Unk_5c]
	str r0, [r1,#oAIData_Unk_68]
	mov r0, #0x6c 
	bl PlaySoundEffect
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #3
	bl spawn_t1_0x0_EffectObject
	bl spawn_t1_0x0_EffectObject
	mov r0, #0x15
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #8
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_80174A8:
	pop {pc}
	thumb_func_end sub_801746E

// symdb: Decrements a battle object's action timer each tick; when it expires, resets the timer to 0 and moves the object into phase 0xC.
// symdb: void battle_objectTickTimerAndSetPhaseC(BattleObject *obj /* r5 */); returns current timer value
// symdb: in r0, flags from the decrement
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_objectTickTimerAndSetPhaseC_80174AA.yaml
	thumb_local_start
battle_objectTickTimerAndSetPhaseC_80174AA:
	push {lr}
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bne locret_80174BC
	mov r0, #0
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #0xc
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_80174BC:
	pop {pc}
	thumb_func_end battle_objectTickTimerAndSetPhaseC_80174AA

// symdb: Tick a battle object's intro timer, ramping sprite mosaic and alpha until they clear and the state action phase is marked initialized.
// symdb: void sub_80174BE(void);   // in:  r5 = battle object pointer (object header + battle fields)
// symdb: // out: r0 = return value (timer half while ramping, 8 when intro finishes);   //
// symdb: r1/r5/r8/r9/r10/r11/r12 clobbered   // flags: NZCV clobbered; outgoing flags equal CMP(0, half -
// symdb: 0x10) mid-ramp,   //        CMP(0x20, 0x20) (Z=1, C=1) on the terminal branch   // uses:
// symdb: sprite_setMosaicSize, sprite_setAlpha_8002c7a, sprite_clearMosaic,   //
// symdb: sprite_disableAlpha, battle_ClearAllianceTargetSlotIfSelf_802CDD0,   //
// symdb: battle_getObjectNameID_8011020
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_tickIntroState_80174BE.yaml
	thumb_local_start
battle_tickIntroState_80174BE:
	push {lr}
	ldrh r0, [r5,#oBattleObject_Timer]
	add r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	cmp r0, #0x20 
	beq loc_80174E0
	lsr r0, r0, #1
	push {r0}
	mov r1, r0
	bl sprite_setMosaicSize
	pop {r0}
	sub r0, #0x10
	neg r0, r0
	bl sprite_setAlpha_8002c7a
	pop {pc}
loc_80174E0:
	bl sprite_clearMosaic
	bl sprite_disableAlpha
	bl battle_ClearAllianceTargetSlotIfSelf_802CDD0
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	bl battle_getObjectNameID_8011020
	mov r0, #8
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	pop {pc}
	thumb_func_end battle_tickIntroState_80174BE

// symdb: Flinch action handler (CurAction 3, 'on flinch' in the PlayerObjectAIAttackJumptables annotation): dispatches the AI, commits the pushed-back FuturePanel position, plays animation 1 for 23 frames, then ends the action.
// symdb: void battleObject_actionFlinch(u32 r5 /* battle object */) : r5 -> [r5 r10] (captured exits r0 =
// symdb: Timer countdown)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_actionFlinch_80174FE.yaml
	thumb_func_start battleObject_actionFlinch_80174FE
battleObject_actionFlinch_80174FE:
	push {lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_8017582
	bl ai_dispatchByTypeAndIndex_800F3E8
	ldr r0, dword_80175B0 // =0x400400 
	bl object_setFlag1 // (int a1) -> void
	bl battle_object_clearFlagsAndCollisionCounter_801A284
	bl battleObject_clearHitFlags_801A29A
	bl battleObject_resetCollisionState_801A2B0
	bl battle_resetCollisionState_80101C4
	ldr r0, dword_80175B4 // =0x20005f 
	bl ClearAIDataUnk0x48Flag
	ldr r0, dword_80175A4 // =0x100041 
	bl object_clearFlag // (int bitfield) -> void
	bl battleObject_clearPwrAtkState_8012EA8
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xc
	tst r0, r1
	bne loc_8017554
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #0
	str r0, [r5,#oBattleObject_Z]
loc_8017554:
	mov r0, #1
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	bl sub_8011450
	bl object_getFlip // () -> int
	bl sprite_setFlip
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #3
	mov r2, #1
	bl tableAddSaturatedByte_800AB46
	mov r0, #0x17
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_8017582:
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bge locret_80175A2
	ldr r0, dword_80175B0 // =0x400400 
	bl object_clearFlag // (int bitfield) -> void
	ldr r0, byte_80175A8 // =0x3f
	bl ClearAIData_Unk_44_Flag
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #8
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_80175A2:
	pop {pc}
	.balign 4, 0
dword_80175A4:
	.word 0x100041
byte_80175A8:
	.byte 0x3F, 0x4, 0x0, 0x10, 0x0, 0x4, 0x0, 0x0
dword_80175B0:
	.word 0x400400
dword_80175B4:
	.word 0x20005F
	thumb_func_end battleObject_actionFlinch_80174FE

// symdb: Paralyze action handler (CurAction 4, 'on paralyze' in the action tables): commits the pushed-back position, plays animation 2, then waits out the paralysis counter (shortened by button mashing) before ending the action.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_actionParalyze_80175B8.yaml
	thumb_func_start battleObject_actionParalyze_80175B8
battleObject_actionParalyze_80175B8:
	push {lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_8017628
	bl battle_dispatchActorAIByTypeAndAIIdx_800F394
	ldr r0, dword_8017674 // =0x400000 
	bl object_setFlag1 // (int a1) -> void
	ldr r0, byte_801766C // =0x41
	bl object_clearFlag // (int bitfield) -> void
	bl battle_resetCollisionState_80101C4
	ldr r0, dword_8017684 // =0x20005f 
	bl ClearAIDataUnk0x48Flag
	bl battleObject_clearPwrAtkState_8012EA8
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xc
	tst r0, r1
	bne loc_8017602
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #0
	str r0, [r5,#oBattleObject_Z]
loc_8017602:
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	bl object_getFlip // () -> int
	bl sprite_setFlip
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #3
	mov r2, #1
	bl tableAddSaturatedByte_800AB46
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_8017628:
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrh r1, [r0,#oAIData_JoypadPressed]
	tst r1, r1
	beq loc_8017646
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r2, #0x1c
	ldrsh r1, [r0,r2]
	sub r1, #1
	strh r1, [r0,r2]
	bgt loc_8017646
	mov r1, #0
	strh r1, [r0,r2]
	ldr r0, off_8017678 // =0x800 
	bl object_clearFlag // (int bitfield) -> void
loc_8017646:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xb
	tst r0, r1
	bne locret_801766A
	ldr r0, dword_801767C // =0x1000003f 
	bl ClearAIData_Unk_44_Flag
	ldr r0, dword_8017680 // =0x400000 
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #8
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_801766A:
	pop {pc}
	.balign 4, 0
byte_801766C:
	.byte 0x41, 0x4, 0x10, 0x0, 0x0, 0x4, 0x0, 0x0
dword_8017674:
	.word 0x400000
off_8017678:
	.word 0x800
dword_801767C:
	.word 0x1000003F
dword_8017680:
	.word 0x400000
dword_8017684:
	.word 0x20005F
	thumb_func_end battleObject_actionParalyze_80175B8

	thumb_func_start sub_8017688
sub_8017688:
	push {lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_8017708
	bl sub_800F3B0
	ldr r0, dword_8017754 // =0x400000 
	bl object_setFlag1 // (int a1) -> void
	ldr r0, byte_801774C // =0x41
	bl object_clearFlag // (int bitfield) -> void
	bl battle_resetFlashingInvisTimer_801A67E
	bl battle_resetCollisionState_80101C4
	bl object_clearInvulnerableTime
	mov r0, #0x19
	add r0, #0xff
	bl PlaySoundEffect
	ldr r0, dword_8017764 // =0x20005f 
	bl ClearAIDataUnk0x48Flag
	bl battleObject_clearPwrAtkState_8012EA8
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xc
	tst r0, r1
	bne loc_80176E2
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #0
	str r0, [r5,#oBattleObject_Z]
loc_80176E2:
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	bl object_getFlip // () -> int
	bl sprite_setFlip
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #3
	mov r2, #1
	bl tableAddSaturatedByte_800AB46
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_8017708:
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrh r1, [r0,#oAIData_JoypadPressed]
	tst r1, r1
	beq loc_8017726
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r2, #0x2a 
	ldrsh r1, [r0,r2]
	sub r1, #1
	strh r1, [r0,r2]
	bgt loc_8017726
	mov r1, #0
	strh r1, [r0,r2]
	ldr r0, dword_8017758 // =0x10000 
	bl object_clearFlag // (int bitfield) -> void
loc_8017726:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x10
	tst r0, r1
	bne locret_801774A
	ldr r0, dword_801775C // =0x1000003f 
	bl ClearAIData_Unk_44_Flag
	ldr r0, dword_8017760 // =0x400000 
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #8
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_801774A:
	pop {pc}
	.balign 4, 0
byte_801774C:
	.byte 0x41, 0x4, 0x10, 0x0, 0x0, 0x4, 0x0, 0x0
dword_8017754:
	.word 0x400000
dword_8017758:
	.word 0x10000
dword_801775C:
	.word 0x1000003F
dword_8017760:
	.word 0x400000
dword_8017764:
	.word 0x20005F
	thumb_func_end sub_8017688

// symdb: Per-frame update for a battle object's jump/landing sequence — initialises the hop on the first tick, decays a hop timer while a button is held, reads a Z arc from a lookup table, and ends the hop with a sound, Z=0 and CurState=CUR_STATE_UPDATE.
// symdb: (r5 = BattleObject*) -> void ; side effects: writes BattleObject fields (PhaseInitialized,
// symdb: CollisionData flags, CurAnim/CurAnimCopy, Z, PanelX/PanelY, RelatedObject1Ptr, AIData+0x68),
// symdb: plays sound effects (0x12E = takeoff, 0x125 = landing), reads joypad from AIData, increments
// symdb: byte_203EAE0[Alliance][3] by 1 saturated.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_jumpLandStep_8017768.yaml
	thumb_func_start battleObject_jumpLandStep_8017768
battleObject_jumpLandStep_8017768:
	push {lr}
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	tst r0, r0
	bne loc_80177E4
	bl sub_800F3CC
	ldr r0, dword_8017850 // =0x400000 
	bl object_setFlag1 // (int a1) -> void
	ldr r0, byte_8017848 // =0x41
	bl object_clearFlag // (int bitfield) -> void
	bl battle_resetCollisionState_80101C4
	bl object_clearInvulnerableTime
	mov r0, #0x2e 
	add r0, #0xff
	bl PlaySoundEffect
	ldr r0, dword_8017860 // =0x20005f 
	bl ClearAIDataUnk0x48Flag
	bl battleObject_clearPwrAtkState_8012EA8
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xc
	tst r0, r1
	bne loc_80177BE
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #0
	str r0, [r5,#oBattleObject_Z]
loc_80177BE:
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	bl object_getFlip // () -> int
	bl sprite_setFlip
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #3
	mov r2, #1
	bl tableAddSaturatedByte_800AB46
	mov r0, #4
	strb r0, [r5,#oBattleObject_PhaseInitialized]
loc_80177E4:
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrh r1, [r0,#oAIData_JoypadPressed]
	tst r1, r1
	beq loc_8017802
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r2, #0x2c 
	ldrsh r1, [r0,r2]
	sub r1, #1
	strh r1, [r0,r2]
	bgt loc_8017802
	mov r1, #0
	strh r1, [r0,r2]
	ldr r0, dword_8017854 // =0x80000000 
	bl object_clearFlag // (int bitfield) -> void
loc_8017802:
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r2, #0x2c 
	ldrsh r1, [r0,r2]
	lsr r1, r1, #2
	mov r0, #0x1f
	and r0, r1
	ldr r1, off_8017864 // =byte_8017868 
	ldrsb r0, [r1,r0]
	lsl r0, r0, #0x10
	str r0, [r5,#oBattleObject_Z]
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x1f
	tst r0, r1
	bne locret_8017846
	ldr r0, dword_8017858 // =0x1000003f 
	bl ClearAIData_Unk_44_Flag
	ldr r0, dword_801785C // =0x400000 
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #0
	str r0, [r5,#oBattleObject_Z]
	mov r0, #0x25 
	add r0, #0xff
	bl PlaySoundEffect
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #8
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_8017846:
	pop {pc}
	.balign 4, 0
byte_8017848:
	.byte 0x41, 0x4, 0x10, 0x0, 0x0, 0x4, 0x0, 0x0
dword_8017850:
	.word 0x400000
dword_8017854:
	.word 0x80000000
dword_8017858:
	.word 0x1000003F
dword_801785C:
	.word 0x400000
dword_8017860:
	.word 0x20005F
off_8017864:
	.word byte_8017868
byte_8017868:
	.byte 0x1, 0x2, 0x3, 0x4, 0x4, 0x5, 0x5, 0x6, 0x6, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1, 0x0, 0xFF
	.byte 0xFE, 0xFD, 0xFC, 0xFC, 0xFB, 0xFB, 0xFA, 0xFA, 0xFA, 0xFB, 0xFC, 0xFD, 0xFE, 0xFF, 0x0
	thumb_func_end battleObject_jumpLandStep_8017768

// symdb: Turn-end handler for a battle object that optionally runs an enemy AI cleanup (sub_80E1620) and then marks the object as having acted (CurAction = 8, phase cleared).
// symdb: void sub_8017888(battle_object *obj /* r5 */); returns r0 = 0; clobbers r0-r3, r7 (scratch,
// symdb: restored), flags NZ set from "mov r0,#0"
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_endTurnMarkActed_8017888.yaml
	thumb_func_start battle_endTurnMarkActed_8017888
battle_endTurnMarkActed_8017888:
	push {r4,r7,lr}
	bl battle_testFlag0x40_800A8F8
	beq loc_80178AC
	ldrh r0, [r5,#oBattleObject_NameID]
	bl GetVerActorTyAndAIIdx_80182B4 // (enemy_idx: u16) -> *const (version: u8, actor_type: ActorType, ai_index: u8)
	ldrb r1, [r0,#1]
	cmp r1, #2
	bne loc_80178AC
	mov r7, #0x40 
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	add r7, r7, r0
	ldr r0, [r7]
	cmp r0, #0
	bne loc_80178AC
	bl sub_80E1620
loc_80178AC:
	mov r0, #8
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	pop {r4,r7,pc}
	thumb_func_end battle_endTurnMarkActed_8017888

// symdb: Tail-call dispatch on a battle object's oBattleObject_Unk_0d selector to one of three handlers (sub_80178D4 / sub_8017992 / sub_8017A38).
// symdb: void dispatchBattleObjectHandler_80178B6(     /* r5 */ battleObject* obj,     /* r10 */ unused,
// symdb: /* lr */ return_addr );
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_80178B6.yaml
	thumb_func_start sub_80178B6
sub_80178B6:
	push {lr}
	ldr r1, off_80178C4 // =off_80178C8 
	ldrb r0, [r5,#oBattleObject_Unk_0d]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
off_80178C4:
	.word off_80178C8
off_80178C8:
	.word battleObject_initMoveStep_80178D4+1
	.word sub_8017992+1
	.word sub_8017A38+1
	thumb_func_end sub_80178B6

// symdb: Kicks off an actor's move one panel in the chosen direction by reserving the destination panel, computing a constant X/Y velocity from the row/col offset, and setting the end-of-move waiting state (or a fallback halt state if the destination panel can't be used).
// symdb: (r5 = battleObject) -> r0 = 0x4 or 0x8 ; side effects: writes AIData Unk_68 = 0,
// symdb: RelatedObject1Ptr = 0, sets CurAnim, copies FuturePanelXY -> PanelXY, sets XVelocity/YVelocity,
// symdb: reserves next panel, etc.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_initMoveStep_80178D4.yaml
	thumb_local_start
battleObject_initMoveStep_80178D4:
	push {r6,r7,lr}
	bl battle_dispatchActorTurnByTypeAndAIIdx_800F404
	ldr r0, dword_8017A90 // =0x500000 
	bl object_setFlag1 // (int a1) -> void
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	bl object_getFlag // () -> int
	mov r2, #2
	mov r1, #1
	lsl r1, r1, #0xb
	tst r0, r1
	bne loc_8017900
	mov r2, #1
	ldr r1, dword_8017A94 // =0x20000 
	tst r0, r1
	beq loc_8017900
	mov r2, #0
loc_8017900:
	strb r2, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	bl sub_8011450
	bl battleObject_clearPwrAtkState_8012EA8
	bl object_getFlip // () -> int
	bl sprite_setFlip
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #0
	strh r0, [r5,#oBattleObject_Z_3c]
	ldr r0, dword_8017A98 // =0x1441 
	bl object_clearFlag // (int bitfield) -> void
	bl battle_resetCollisionState_80101C4
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #3
	mov r2, #1
	bl tableAddSaturatedByte_800AB46
	bl sub_800E45E
	strb r0, [r5,#oBattleObject_Unk_1c]
	strb r1, [r5,#oBattleObject_Unk_1d]
	strh r2, [r5,#oBattleObject_Timer2]
	tst r2, r2
	beq loc_8017988
	ldrb r3, [r5,#oBattleObject_PanelX]
	add r0, r0, r3
	ldrb r3, [r5,#oBattleObject_PanelY]
	add r1, r1, r3
	mov r6, r0
	mov r7, r1
	bl battle_objectCheckPanelByAlliance_800E5AC
	beq loc_8017988
	mov r1, #0x1c
	ldrsb r1, [r5,r1]
	ldr r0, dword_8017A9C // =0xa0000 
	mul r0, r1
	str r0, [r5,#oBattleObject_XVelocity]
	mov r1, #0x1d
	ldrsb r1, [r5,r1]
	ldr r0, dword_8017AA0 // =0x60000 
	mul r0, r1
	str r0, [r5,#oBattleObject_YVelocity]
	mov r0, r6
	mov r1, r7
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_reservePanel
	mov r0, #4
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r6,r7,pc}
loc_8017988:
	mov r0, #0x18
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #8
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r6,r7,pc}
	thumb_func_end battleObject_initMoveStep_80178D4

	thumb_local_start
sub_8017992:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	mov r2, r0
	mov r4, r1
	ldr r1, [r5,#oBattleObject_X]
	ldr r0, [r5,#oBattleObject_XVelocity]
	add r0, r0, r1
	str r0, [r5,#oBattleObject_X]
	bl IsR2BetweenR0AndR1
	tst r0, r0
	bne loc_80179C2
	mov r2, r4
	ldr r1, [r5,#oBattleObject_Y]
	ldr r0, [r5,#oBattleObject_YVelocity]
	add r0, r0, r1
	str r0, [r5,#oBattleObject_Y]
	bl IsR2BetweenR0AndR1
	tst r0, r0
	beq loc_8017A2E
loc_80179C2:
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_getPanelDataOffset
	ldrb r4, [r0,#oPanelData_Type]
	cmp r4, #7
	bne loc_80179E8
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r0,#oCollisionData_PrimaryElement]
	cmp r0, #2
	beq loc_80179E8
	ldrh r0, [r5,#oBattleObject_Timer2]
	add r0, #1
	strh r0, [r5,#oBattleObject_Timer2]
	b loc_80179E8
loc_80179E8:
	ldrh r0, [r5,#oBattleObject_Timer2]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer2]
	ble loc_8017A18
	mov r2, #0x1c
	ldrsb r2, [r5,r2]
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	add r0, r0, r2
	mov r2, #0x1d
	ldrsb r2, [r5,r2]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	add r1, r1, r2
	mov r6, r0
	mov r7, r1
	bl battle_objectCheckPanelByAlliance_800E5AC
	beq loc_8017A18
	mov r0, r6
	mov r1, r7
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_reservePanel
	pop {r4,pc}
loc_8017A18:
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #0x14
	strh r0, [r5,#oBattleObject_Timer]
	mov r0, #8
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r4,pc}
loc_8017A2E:
	bl object_setPanelsFromCoordinates
	bl object_updateCollisionPanels
	pop {r4,pc}
	thumb_func_end sub_8017992

// symdb: Battle object timer tick: when the per-object timer expires, either flip to action 4 (clear stuck flag) or run the full knock-down/recovery sequence (action 8).
// symdb: void battleObject_tickTimer_8017A38(void);  // r5 = object pointer in
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8017A38.yaml
	thumb_local_start
sub_8017A38:
	push {lr}
	ldrh r0, [r5,#oBattleObject_Timer]
	sub r0, #1
	strh r0, [r5,#oBattleObject_Timer]
	bge locret_8017A8E
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xb
	tst r0, r1
	beq loc_8017A5E
	ldr r0, dword_8017AA4 // =0x100000 
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #4
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	b locret_8017A8E
loc_8017A5E:
	ldr r0, dword_8017AA8 // =0x501800 
	bl object_clearFlag // (int bitfield) -> void
	ldr r0, dword_8017AAC // =0x1000043f 
	bl ClearAIData_Unk_44_Flag
	ldr r0, dword_8017AB0 // =0x200000 
	bl ClearAIDataUnk0x48Flag
	mov r0, #0x10
	bl object_clearFlag2
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_1f]
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	bl sub_8011450
	mov r0, #8
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_8017A8E:
	pop {pc}
	.balign 4, 0
dword_8017A90:
	.word 0x500000
dword_8017A94:
	.word 0x20000
dword_8017A98:
	.word 0x1441
dword_8017A9C:
	.word 0xA0000
dword_8017AA0:
	.word 0x60000
dword_8017AA4:
	.word 0x100000
dword_8017AA8:
	.word 0x501800
dword_8017AAC:
	.word 0x1000043F
dword_8017AB0:
	.word 0x200000
	thumb_func_end sub_8017A38

// symdb: AI player actor's chip-use battle action: validates and launches the currently selected battle chip, draws a replacement, and handles the post-hit jitter animation
// symdb: (r5 = *BattleObject) -> void ; no return value to caller
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_aiPlayerUseChipAction_8017AB4.yaml
	thumb_local_start
battle_aiPlayerUseChipAction_8017AB4:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x50
	ldrh r0, [r5,#oBattleObject_NameID]
	bl unpackVerActorTyAndAIIdx_800F29C
	cmp r0, #2
	bne loc_8017B64
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_8017B64
	bl GetAIData_Unk_44_Flag
	ldr r1, off_8017C94 // =0x800 
	tst r0, r1
	beq loc_8017B64
	bl sub_800BEDA
	tst r0, r0
	beq loc_8017B5E
	bl getCurChipInBattleHand_8010004
	add r1, r0, #1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	beq loc_8017B5E
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#9]
	mov r1, #1
	tst r0, r1
	beq loc_8017B5E
	mov r0, #0
	add r7, sp, #0
	bl useChipRelated_80127C0
	cmp r0, #0x15
	bne loc_8017B26
	push {r7}
	ldr r6, [r7,#8]
	ldr r4, [r7,#0xc]
	ldrb r1, [r7,#3]
	lsl r1, r1, #2
	ldr r3, off_8017BB8 // =off_802CCB4 
	ldr r3, [r3,r1]
	ldrb r2, [r7,#2]
	ldrh r1, [r7,#6]
	lsl r1, r1, #0x10
	ldrh r7, [r7,#0x14]
	add r7, r7, r1
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	mov lr, pc
	bx r3
	pop {r7}
	b loc_8017B4A
loc_8017B26:
	cmp r0, #0x1b
	bne loc_8017B48
	push {r7}
	ldrb r2, [r7,#2]
	ldrb r3, [r7,#3]
	ldr r4, [r7,#0xc]
	ldr r6, [r7,#8]
	ldrh r1, [r7,#6]
	lsl r1, r1, #0x10
	ldrh r7, [r7,#0x14]
	add r7, r7, r1
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	bl sub_80E192C
	pop {r7}
	b loc_8017B4A
loc_8017B48:
	b loc_8017B5E
loc_8017B4A:
	mov r2, r0
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0
	bl loc_800BF30
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl sub_800B8EE
	bl battle_drawCardToHand_800FC7C
loc_8017B5E:
	ldr r0, off_8017C98 // =0x80c 
	bl ClearAIData_Unk_44_Flag
loc_8017B64:
	ldrb r0, [r5,#oBattleObject_PreventAnim]
	tst r0, r0
	bne loc_8017B7A
	ldrh r0, [r5,#oBattleObject_X16]
	strh r0, [r5,#oBattleObject_Unk_30]
	ldrh r0, [r5,#oBattleObject_Z16]
	strh r0, [r5,#oBattleObject_Unk_32]
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_19]
	mov r0, #4
	strb r0, [r5,#oBattleObject_PreventAnim]
loc_8017B7A:
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0x80
	ldrh r1, [r0,r1]
	tst r1, r1
	beq loc_8017B88
	mov r0, #0x1e
	strb r0, [r5,#oBattleObject_Unk_19]
loc_8017B88:
	ldrb r0, [r5,#oBattleObject_Unk_19]
	tst r0, r0
	beq loc_8017BAA
	sub r0, #1
	strb r0, [r5,#oBattleObject_Unk_19]
	ldrh r1, [r5,#oBattleObject_Unk_30]
	lsl r1, r1, #0x10
	ldr r2, [r5,#oBattleObject_Y]
	ldrh r3, [r5,#oBattleObject_Unk_32]
	lsl r3, r3, #0x10
	mov r0, #3
	bl AddRandomVarianceToTwoCoords
	mov r0, #0x34 
	add r0, r0, r5
	stmia r0!, {r1-r3}
	b loc_8017BB2
loc_8017BAA:
	ldrh r0, [r5,#oBattleObject_Unk_30]
	strh r0, [r5,#oBattleObject_X16]
	ldrh r0, [r5,#oBattleObject_Unk_32]
	strh r0, [r5,#oBattleObject_Z16]
loc_8017BB2:
	add sp, sp, #0x50
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8017BB8:
	.word off_802CCB4
	.word off_802CD5C
	thumb_func_end battle_aiPlayerUseChipAction_8017AB4

// symdb: AI attack dispatcher: branches on the queued-AttackUnk_48 flag/word to run one of several attack routines, often leaving the queued 0x1c AttackVars slot to run.
// symdb: (r5 = battle object pointer) -> r0 = 0 ; side effects: clobbers AIData flag bits, clears/queues
// symdb: an AttackVars slot, calls an attack routine (sub_8014A38 / sub_8015614 / sub_802D714 /
// symdb: sub_802D926 / object_setAttack0) depending on the queued flag, then returns 0.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_ai_dispatchQueuedAttacks_8017BC0.yaml
	thumb_local_start
battle_ai_dispatchQueuedAttacks_8017BC0:
	push {r4,r6,r7,lr}
	ldr r6, [r5,#oBattleObject_AIDataPtr]
	mov r7, #0xa0
	add r7, r7, r6
	bl GetAIDataUnk0x48Flag
	mov r1, #0x80
	tst r0, r1
	beq loc_8017BD8
	bl battle_runBeastTransformationAction_8014A38
	pop {r4,r6,r7,pc}
loc_8017BD8:
	bl GetAIDataUnk0x48Flag
	ldr r1, off_8017C9C // =0x100 
	tst r0, r1
	beq loc_8017BE8
	bl sub_8015614
	pop {r4,r6,r7,pc}
loc_8017BE8:
	bl GetAIDataUnk0x48Flag
	ldr r1, off_8017CA0 // =0x1000 
	tst r0, r1
	beq loc_8017BF8
	bl sub_802D714
	pop {r4,r6,r7,pc}
loc_8017BF8:
	bl GetAIDataUnk0x48Flag
	ldr r1, off_8017CA4 // =0x2000 
	tst r0, r1
	beq loc_8017C0C
	mov r0, #0
	strb r0, [r7,#oAIAttackVars_Unk_03]
	bl sub_802D926
	pop {r4,r6,r7,pc}
loc_8017C0C:
	bl GetAIData_Unk_44_Flag
	ldr r1, dword_8017CA8 // =0x4000 
	tst r0, r1
	beq loc_8017C2A
	mov r0, r1
	bl ClearAIData_Unk_44_Flag
	mov r0, #0x80
	bl SetAIDataUnk0x48Flag
	mov r0, #0x1c
	bl object_setAttack0
	pop {r4,r6,r7,pc}
loc_8017C2A:
	bl GetAIData_Unk_44_Flag
	mov r1, #0x40 
	tst r0, r1
	beq loc_8017C56
	mov r0, r1
	bl ClearAIData_Unk_44_Flag
	ldr r0, off_8017C9C // =0x100 
	bl SetAIDataUnk0x48Flag
	mov r0, #0
	str r0, [r5,#oBattleObject_Unk_5c]
	ldr r0, [r5,#oBattleObject_Unk_5c]
	tst r0, r0
	bne loc_8017C4E
	ldr r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	str r0, [r5,#oBattleObject_Unk_5c]
loc_8017C4E:
	mov r0, #0x1c
	bl object_setAttack0
	pop {r4,r6,r7,pc}
loc_8017C56:
	bl GetAIData_Unk_44_Flag
	ldr r1, off_8017CAC // =LCDControl 
	tst r0, r1
	beq loc_8017C74
	mov r0, r1
	bl ClearAIData_Unk_44_Flag
	ldr r0, off_8017CA0 // =0x1000 
	bl SetAIDataUnk0x48Flag
	mov r0, #0x1c
	bl object_setAttack0
	pop {r4,r6,r7,pc}
loc_8017C74:
	bl GetAIData_Unk_44_Flag
	ldr r1, byte_8017CB0 // =0x0 
	tst r0, r1
	beq locret_8017C92
	mov r0, r1
	bl ClearAIData_Unk_44_Flag
	ldr r0, off_8017CA4 // =0x2000 
	bl SetAIDataUnk0x48Flag
	mov r0, #0x1c
	bl object_setAttack0
	pop {r4,r6,r7,pc}
locret_8017C92:
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8017C94:
	.word 0x800
off_8017C98:
	.word 0x80C
off_8017C9C:
	.word 0x100
off_8017CA0:
	.word 0x1000
off_8017CA4:
	.word 0x2000
dword_8017CA8:
	.word 0x4000
off_8017CAC:
	.word LCDControl
byte_8017CB0:
	.byte 0x0, 0x0, 0x0, 0x8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end battle_ai_dispatchQueuedAttacks_8017BC0

	thumb_func_start sub_8017CC0
sub_8017CC0:
	push {lr}
	ldr r1, off_8017CD0 // =off_8017CD4 
	ldrb r0, [r5,#oBattleObject_Unk_0d]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.byte 0, 0
off_8017CD0:
	.word off_8017CD4
off_8017CD4:
	.word sub_8017CE0+1
	.word sub_8017D64+1
	.word sub_8017E0A+1
	thumb_func_end sub_8017CC0

	thumb_local_start
sub_8017CE0:
	push {r6,r7,lr}
	mov r0, #1
	lsl r0, r0, #0x14
	bl object_setFlag1 // (int a1) -> void
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	ldr r0, off_8017D58 // =0x1040 
	bl object_clearFlag // (int bitfield) -> void
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	bl sub_800F598
	strb r0, [r5,#oBattleObject_Unk_1c]
	strb r1, [r5,#oBattleObject_Unk_1d]
	strb r2, [r5,#oBattleObject_PhaseInitialized]
	tst r2, r2
	beq loc_8017D4E
	ldrb r3, [r5,#oBattleObject_PanelX]
	add r0, r0, r3
	ldrb r3, [r5,#oBattleObject_PanelY]
	add r1, r1, r3
	mov r6, r0
	mov r7, r1
	bl sub_800F50C
	beq loc_8017D4E
	mov r1, #0x1c
	ldrsb r1, [r5,r1]
	ldr r0, dword_8017D5C // =0xa0000 
	mul r0, r1
	str r0, [r5,#oBattleObject_XVelocity]
	mov r1, #0x1d
	ldrsb r1, [r5,r1]
	ldr r0, dword_8017D60 // =0x60000 
	mul r0, r1
	str r0, [r5,#oBattleObject_YVelocity]
	mov r0, r6
	mov r1, r7
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_reservePanel
	mov r0, #4
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r6,r7,pc}
loc_8017D4E:
	mov r0, #0x18
	strb r0, [r5,#oBattleObject_CurPhase]
	mov r0, #8
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r6,r7,pc}
	.balign 4, 0
off_8017D58:
	.word 0x1040
dword_8017D5C:
	.word 0xA0000
dword_8017D60:
	.word 0x60000
	thumb_func_end sub_8017CE0

	thumb_local_start
sub_8017D64:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	mov r2, r0
	mov r4, r1
	ldr r1, [r5,#oBattleObject_X]
	ldr r0, [r5,#oBattleObject_XVelocity]
	add r0, r0, r1
	str r0, [r5,#oBattleObject_X]
	bl IsR2BetweenR0AndR1
	tst r0, r0
	bne loc_8017D94
	mov r2, r4
	ldr r1, [r5,#oBattleObject_Y]
	ldr r0, [r5,#oBattleObject_YVelocity]
	add r0, r0, r1
	str r0, [r5,#oBattleObject_Y]
	bl IsR2BetweenR0AndR1
	tst r0, r0
	beq loc_8017E00
loc_8017D94:
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r0,#oCollisionData_PrimaryElement]
	cmp r0, #2
	beq loc_8017DBA
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_getPanelDataOffset
	ldrb r0, [r0,#oPanelData_Type]
	cmp r0, #7
	bne loc_8017DBA
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	add r0, #1
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	b loc_8017DBA
loc_8017DBA:
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	sub r0, #1
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	ble loc_8017DEA
	mov r2, #0x1c
	ldrsb r2, [r5,r2]
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	add r0, r0, r2
	mov r2, #0x1d
	ldrsb r2, [r5,r2]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	add r1, r1, r2
	mov r6, r0
	mov r7, r1
	bl sub_800F50C
	beq loc_8017DEA
	mov r0, r6
	mov r1, r7
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_reservePanel
	pop {r4,pc}
loc_8017DEA:
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #0x14
	strb r0, [r5,#oBattleObject_CurPhase]
	mov r0, #8
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r4,pc}
loc_8017E00:
	bl object_setPanelsFromCoordinates
	bl object_updateCollisionPanels
	pop {r4,pc}
	thumb_func_end sub_8017D64

	thumb_local_start
sub_8017E0A:
	push {lr}
	ldrb r0, [r5,#oBattleObject_CurPhase]
	sub r0, #1
	strb r0, [r5,#oBattleObject_CurPhase]
	bge locret_8017E24
	mov r0, #1
	lsl r0, r0, #0x14
	bl object_clearFlag // (int bitfield) -> void
	ldr r0, [r5,#oBattleObject_Unk_5c]
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	mov r0, #0
	str r0, [r5,#oBattleObject_Unk_5c]
locret_8017E24:
	pop {pc}
	thumb_func_end sub_8017E0A

	thumb_func_start sub_8017E26
sub_8017E26:
	push {lr}
	ldr r1, off_8017E34 // =off_8017E38 
	ldrb r0, [r5,#oBattleObject_Unk_0d]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
off_8017E34:
	.word off_8017E38
off_8017E38:
	.word sub_8017E44+1
	.word sub_8017F38+1
	.word sub_8017FE6+1
	thumb_func_end sub_8017E26

	thumb_local_start
sub_8017E44:
	push {r4,r6,r7,lr}
	mov r0, #1
	lsl r0, r0, #0x14
	bl object_setFlag1 // (int a1) -> void
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	ldr r0, off_8017F2C // =0x1040 
	bl object_clearFlag // (int bitfield) -> void
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	bl sub_800F598
	strb r0, [r5,#oBattleObject_Unk_1c]
	strb r1, [r5,#oBattleObject_Unk_1d]
	strb r3, [r5,#oBattleObject_Unk_0c]
	mov r2, #6
	strb r2, [r5,#oBattleObject_PhaseInitialized]
	tst r2, r2
	beq loc_8017F08
	mov r4, #0
	ldrb r2, [r5,#oBattleObject_Unk_0c]
	cmp r2, #1
	beq loc_8017E88
	add r4, #4
loc_8017E88:
	ldrb r0, [r5,#oBattleObject_Unk_1c]
	cmp r0, r2
	beq loc_8017E90
	add r4, #2
loc_8017E90:
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	bl object_getPanelParameters
	ldrb r2, [r5,#oBattleObject_Unk_0c]
	mov r1, #0x20 
	tst r0, r1
	beq loc_8017EA2
	add r4, #1
loc_8017EA2:
	ldr r0, off_8017F20 // =byte_8017F24
	ldrb r0, [r0,r4]
	cmp r0, #0
	beq loc_8017EC8
	strb r0, [r5,#oBattleObject_Unk_0c]
	mov r0, #0x1c
	ldrsb r0, [r5,r0]
	mov r1, #0x1d
	ldrsb r1, [r5,r1]
	ldrb r3, [r5,#oBattleObject_PanelX]
	add r0, r0, r3
	ldrb r3, [r5,#oBattleObject_PanelY]
	add r1, r1, r3
	mov r6, r0
	mov r7, r1
	bl sub_800F55C
	beq loc_8017F08
	b loc_8017EE6
loc_8017EC8:
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0c]
	mov r0, #0x1c
	ldrsb r0, [r5,r0]
	mov r1, #0x1d
	ldrsb r1, [r5,r1]
	ldrb r3, [r5,#oBattleObject_PanelX]
	add r0, r0, r3
	ldrb r3, [r5,#oBattleObject_PanelY]
	add r1, r1, r3
	mov r6, r0
	mov r7, r1
	bl sub_800F534
	beq loc_8017F08
loc_8017EE6:
	mov r1, #0x1c
	ldrsb r1, [r5,r1]
	ldr r0, dword_8017F30 // =0xa0000 
	mul r0, r1
	str r0, [r5,#oBattleObject_XVelocity]
	mov r1, #0x1d
	ldrsb r1, [r5,r1]
	ldr r0, dword_8017F34 // =0x60000 
	mul r0, r1
	str r0, [r5,#oBattleObject_YVelocity]
	mov r0, r6
	mov r1, r7
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	mov r0, #4
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r4,r6,r7,pc}
loc_8017F08:
	mov r0, #0x18
	strb r0, [r5,#oBattleObject_CurPhase]
	mov r0, #8
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r4,r6,r7,pc}
	.word 0, 0, 0
	.balign 4, 0
off_8017F20:
	.word byte_8017F24
byte_8017F24:
	.byte 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x2, 0x2
off_8017F2C:
	.word 0x1040
dword_8017F30:
	.word 0xA0000
dword_8017F34:
	.word 0x60000
	thumb_func_end sub_8017E44

	thumb_local_start
sub_8017F38:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	mov r2, r0
	mov r4, r1
	ldr r1, [r5,#oBattleObject_X]
	ldr r0, [r5,#oBattleObject_XVelocity]
	add r0, r0, r1
	str r0, [r5,#oBattleObject_X]
	bl IsR2BetweenR0AndR1
	tst r0, r0
	bne loc_8017F68
	mov r2, r4
	ldr r1, [r5,#oBattleObject_Y]
	ldr r0, [r5,#oBattleObject_YVelocity]
	add r0, r0, r1
	str r0, [r5,#oBattleObject_Y]
	bl IsR2BetweenR0AndR1
	tst r0, r0
	beq loc_8017FDC
loc_8017F68:
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r0,#oCollisionData_PrimaryElement]
	cmp r0, #2
	beq loc_8017F8E
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_getPanelDataOffset
	ldrb r0, [r0,#oPanelData_Type]
	cmp r0, #7
	bne loc_8017F8E
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	add r0, #1
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	b loc_8017F8E
loc_8017F8E:
	ldrb r0, [r5,#oBattleObject_PhaseInitialized]
	sub r0, #1
	strb r0, [r5,#oBattleObject_PhaseInitialized]
	ble loc_8017FC6
	mov r2, #0x1c
	ldrsb r2, [r5,r2]
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	add r0, r0, r2
	mov r2, #0x1d
	ldrsb r2, [r5,r2]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	add r1, r1, r2
	mov r6, r0
	mov r7, r1
	ldrb r2, [r5,#oBattleObject_Unk_0c]
	cmp r2, #0
	bne loc_8017FB6
	bl sub_800F534
	b loc_8017FBA
loc_8017FB6:
	bl sub_800F55C
loc_8017FBA:
	beq loc_8017FC6
	mov r0, r6
	mov r1, r7
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	pop {r4,pc}
loc_8017FC6:
	ldrh r0, [r5,#oBattleObject_FuturePanelXY]
	strh r0, [r5,#oBattleObject_PanelXY]
	bl object_setCoordinatesFromPanels // () -> void
	bl object_updateCollisionPanels
	mov r0, #0x14
	strb r0, [r5,#oBattleObject_CurPhase]
	mov r0, #8
	strb r0, [r5,#oBattleObject_Unk_0d]
	pop {r4,pc}
loc_8017FDC:
	bl object_setPanelsFromCoordinates
	bl object_updateCollisionPanels
	pop {r4,pc}
	thumb_func_end sub_8017F38

	thumb_local_start
sub_8017FE6:
	push {lr}
	ldrb r0, [r5,#oBattleObject_CurPhase]
	sub r0, #1
	strb r0, [r5,#oBattleObject_CurPhase]
	bge locret_8018000
	mov r0, #1
	lsl r0, r0, #0x14
	bl object_clearFlag // (int bitfield) -> void
	ldr r0, [r5,#oBattleObject_Unk_5c]
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	mov r0, #0
	str r0, [r5,#oBattleObject_Unk_5c]
locret_8018000:
	pop {pc}
	thumb_func_end sub_8017FE6

	thumb_local_start
sub_8018002:
	push {lr}
	ldr r1, off_8018010 // =off_8018014 
	ldrb r0, [r5,#oBattleObject_PreventAnim]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
off_8018010:
	.word off_8018014
off_8018014:
	.word sub_801802C+1
	.word sub_8018076+1
	.word sub_8018094+1
	.word sub_80180A8+1
	.word sub_80180EC+1
	.word nullsub_57+1
	thumb_func_end sub_8018002

	thumb_local_start
sub_801802C:
	push {lr}
	bl object_getFlag2
	mov r2, #0
	ldr r1, off_8018294 // =0x400 
	tst r0, r1
	bne loc_801803C
	mov r2, #1
loc_801803C:
	strb r2, [r5,#oBattleObject_Alliance]
	ldr r0, off_8018298 // =0xc00 
	bl object_clearFlag2
	ldr r0, off_801829C // =LCDControl 
	bl object_setFlag1 // (int a1) -> void
	mov r0, #0x40 
	lsl r0, r0, #0x10
	ldr r1, [r5,#oBattleObject_Z]
	sub r0, r0, r1
	mov r1, #0x20 
	svc 6
	str r0, [r5,#oBattleObject_ZVelocity]
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	mov r0, #0x20 
	strb r0, [r5,#oBattleObject_Unk_19]
	mov r0, #0x2b 
	add r0, #0xff
	bl PlaySoundEffect
	bl object_clearCollisionRegion // () -> void
	mov r0, #4
	strb r0, [r5,#oBattleObject_PreventAnim]
	pop {pc}
	thumb_func_end sub_801802C

	thumb_local_start
sub_8018076:
	push {lr}
	ldr r0, [r5,#oBattleObject_Z]
	ldr r1, [r5,#oBattleObject_ZVelocity]
	add r0, r0, r1
	str r0, [r5,#oBattleObject_Z]
	ldrb r0, [r5,#oBattleObject_Unk_19]
	sub r0, #1
	strb r0, [r5,#oBattleObject_Unk_19]
	bne locret_8018092
	mov r0, #0x40 
	lsl r0, r0, #0x10
	str r0, [r5,#oBattleObject_Z]
	mov r0, #8
	strb r0, [r5,#oBattleObject_PreventAnim]
locret_8018092:
	pop {pc}
	thumb_func_end sub_8018076

	thumb_local_start
sub_8018094:
	push {lr}
	ldrh r0, [r5,#oBattleObject_Unk_1e_Unk_1f]
	strb r0, [r5,#oBattleObject_Unk_19]
	ldrh r0, [r5,#oBattleObject_X16]
	strh r0, [r5,#oBattleObject_Unk_30]
	ldrh r0, [r5,#oBattleObject_Z16]
	strh r0, [r5,#oBattleObject_Unk_32]
	mov r0, #0xc
	strb r0, [r5,#oBattleObject_PreventAnim]
	pop {pc}
	thumb_func_end sub_8018094

	thumb_local_start
sub_80180A8:
	push {r7,lr}
	ldrh r1, [r5,#oBattleObject_Unk_30]
	lsl r1, r1, #0x10
	ldr r2, [r5,#oBattleObject_Y]
	ldrh r3, [r5,#oBattleObject_Unk_32]
	lsl r3, r3, #0x10
	mov r0, #3
	bl AddRandomVarianceToTwoCoords
	mov r7, #0x34 
	add r7, r7, r5
	stmia r7!, {r1-r3}
	ldrb r0, [r5,#oBattleObject_Unk_19]
	sub r0, #1
	strb r0, [r5,#oBattleObject_Unk_19]
	bne locret_80180EA
	ldrh r0, [r5,#oBattleObject_Unk_30]
	strh r0, [r5,#oBattleObject_X16]
	ldrh r0, [r5,#oBattleObject_Unk_32]
	strh r0, [r5,#oBattleObject_Z16]
	ldrb r0, [r5,#oBattleObject_Unk_1c]
	ldrb r1, [r5,#oBattleObject_Unk_1d]
	strb r0, [r5,#oBattleObject_FuturePanelX]
	strb r1, [r5,#oBattleObject_FuturePanelY]
	bl sub_800F768
	strb r0, [r5,#oBattleObject_Unk_19]
	mov r0, #0xd
	add r0, #0xff
	bl PlaySoundEffect
	mov r0, #0x10
	strb r0, [r5,#oBattleObject_PreventAnim]
locret_80180EA:
	pop {r7,pc}
	thumb_func_end sub_80180A8

	thumb_local_start
sub_80180EC:
	push {r4,r6,r7,lr}
	mov r7, #0x34 
	add r7, r7, r5
	ldmia r7!, {r0-r4,r6}
	add r0, r0, r3
	add r1, r1, r4
	sub r2, r2, r6
	mov r7, #0x34 
	add r7, r7, r5
	stmia r7!, {r0-r2}
	ldrb r0, [r5,#oBattleObject_Unk_19]
	sub r0, #1
	strb r0, [r5,#oBattleObject_Unk_19]
	bne locret_8018132
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r0, [r5,#oBattleObject_PanelX]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_setCoordinatesFromPanels // () -> void
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	ldrb r2, [r5,#oBattleObject_Element]
	mov r3, #0
	ldr r4, dword_8018134 // =0x6050001 
	ldr r6, [r5,#oBattleObject_DamageAndStaminaDamageCounterDisabler]
	mov r7, #3
	bl object_spawnDimmingCollisionRegion
	mov r0, #0
	strh r0, [r5,#oBattleObject_HP]
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
locret_8018132:
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_8018134:
	.word 0x6050001
	thumb_func_end sub_80180EC

	thumb_local_start
nullsub_57:
	mov pc, lr
	thumb_func_end nullsub_57

	thumb_local_start
sub_801813A:
	push {lr}
	ldr r1, off_8018148 // =off_801814C 
	ldrb r0, [r5,#oBattleObject_PreventAnim]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
off_8018148:
	.word off_801814C
off_801814C:
	.word sub_8018154+1
	.word sub_8018186+1
	thumb_func_end sub_801813A

	thumb_local_start
sub_8018154:
	push {lr}
	bl object_getFlag2
	ldr r1, dword_80182A0 // =0x10000000 
	ldr r2, off_80182A4 // =0x1000 
	tst r0, r2
	bne loc_8018164
	ldr r1, dword_80182A8 // =0x20000000 
loc_8018164:
	mov r0, r1
	bl object_setFlag1 // (int a1) -> void
	ldr r0, off_80182AC // =0x3000 
	bl object_clearFlag2
	mov r0, #0x3c 
	strb r0, [r5,#oBattleObject_Unk_19]
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	bl object_removePanelReserve
	bl object_clearCollisionRegion // () -> void
	mov r0, #4
	strb r0, [r5,#oBattleObject_PreventAnim]
	pop {pc}
	thumb_func_end sub_8018154

	thumb_local_start
sub_8018186:
	push {r4,lr}
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	orr r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	ldrb r0, [r5,#oBattleObject_Unk_19]
	lsr r0, r0, #2
	bcs loc_80181AA
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #0x42 
	bl spawn_t1_0x0_EffectObject
loc_80181AA:
	ldrb r0, [r5,#oBattleObject_Unk_19]
	sub r0, #1
	strb r0, [r5,#oBattleObject_Unk_19]
	bne locret_80181F4
	bl sub_800F806
	mov r4, #1
	lsl r4, r4, #8
	add r4, r4, r0
	lsl r4, r4, #8
	bl clearEntryOfBattleStateBattleObjectList_800F656
	mov r0, r5
	bl sub_80E544C
	bl object_getFlag // () -> int
	ldr r1, dword_80182A0 // =0x10000000 
	tst r0, r1
	beq loc_80181E2
	add r4, #3
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	ldrb r2, [r5,#oBattleObject_Alliance]
	ldr r6, [r5,#oBattleObject_DamageAndStaminaDamageCounterDisabler]
	bl sub_80CFBC4
	b loc_80181F0
loc_80181E2:
	mov r4, #1
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	ldrb r2, [r5,#oBattleObject_Alliance]
	ldr r6, [r5,#oBattleObject_DamageAndStaminaDamageCounterDisabler]
	bl sub_80D99EC
loc_80181F0:
	mov r0, #CUR_STATE_DESTROY
	str r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
locret_80181F4:
	pop {r4,pc}
	thumb_func_end sub_8018186

	thumb_local_start
hideSummonsWhenBlind_80181F6:
	push {lr}
	bl battle_isTimeStop
	bne loc_8018206
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	orr r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
loc_8018206:
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r0, [r1,#oBattleState_Unk_0d]
	ldrb r1, [r5,#oBattleObject_Alliance]
	eor r0, r1
	beq locret_801823A
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	tst r0, r0
	beq locret_801823A
	push {r5}
	mov r5, r0
	bl object_getFlag // () -> int
	ldr r1, off_80182B0 // =0x2000 
	tst r0, r1
	pop {r5}
	beq locret_801823A
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #2
	bic r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	b locret_801823A
locret_801823A:
	pop {pc}
	thumb_func_end hideSummonsWhenBlind_80181F6

	thumb_local_start
sub_801823C:
	push {lr}
	bl hideSummonsWhenBlind_80181F6
	ldrb r0, [r5,#oBattleObject_PreventAnim]
	tst r0, r0
	bne loc_8018258
	ldrh r0, [r5,#oBattleObject_X16]
	strh r0, [r5,#oBattleObject_Unk_30]
	ldrh r0, [r5,#oBattleObject_Z16]
	strh r0, [r5,#oBattleObject_Unk_32]
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_19]
	mov r0, #4
	strb r0, [r5,#oBattleObject_PreventAnim]
loc_8018258:
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0x80
	ldrh r1, [r0,r1]
	tst r1, r1
	beq loc_8018266
	mov r0, #0x1e
	strb r0, [r5,#oBattleObject_Unk_19]
loc_8018266:
	ldrb r0, [r5,#oBattleObject_Unk_19]
	tst r0, r0
	beq loc_8018288
	sub r0, #1
	strb r0, [r5,#oBattleObject_Unk_19]
	ldrh r1, [r5,#oBattleObject_Unk_30]
	lsl r1, r1, #0x10
	ldr r2, [r5,#oBattleObject_Y]
	ldrh r3, [r5,#oBattleObject_Unk_32]
	lsl r3, r3, #0x10
	mov r0, #3
	bl AddRandomVarianceToTwoCoords
	mov r0, #0x34 
	add r0, r0, r5
	stmia r0!, {r1-r3}
	b locret_8018290
loc_8018288:
	ldrh r0, [r5,#oBattleObject_Unk_30]
	strh r0, [r5,#oBattleObject_X16]
	ldrh r0, [r5,#oBattleObject_Unk_32]
	strh r0, [r5,#oBattleObject_Z16]
locret_8018290:
	pop {pc}
	.balign 4, 0
off_8018294:
	.word 0x400
off_8018298:
	.word 0xC00
off_801829C:
	.word LCDControl
dword_80182A0:
	.word 0x10000000
off_80182A4:
	.word 0x1000
dword_80182A8:
	.word 0x20000000
off_80182AC:
	.word 0x3000
off_80182B0:
	.word 0x2000
	thumb_func_end sub_801823C

// If we change the data here, the virus that ends up spawning will be different. In sprite, AI, attack pattern, HP, etc.
// Only the name of the original virus remains
// symdb: Looks up the battle enemy's per-index {game version, actor type, AI index} record
// symdb: u16 enemy_idx (r0) -> const u8* record (r0); clobbers r1, NZC; preserves nothing
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetVerActorTyAndAIIdx_80182B4.yaml
	thumb_func_start GetVerActorTyAndAIIdx_80182B4
GetVerActorTyAndAIIdx_80182B4: // (enemy_idx: u16) -> *const (version: u8, actor_type: ActorType, ai_index: u8)
	mov r1, #3
	mul r1, r0
	ldr r0, off_80182C0 // =EnemyVerActorTyAndAIIdxTable
	add r0, r0, r1
	mov pc, lr
	.byte 0, 0
off_80182C0:
	.word EnemyVerActorTyAndAIIdxTable
// symdb: 3 bytes per enemy id: version, actor type, AI index (GetVerActorTyAndAIIdx_80182B4).
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/EnemyVerActorTyAndAIIdxTable.yaml
EnemyVerActorTyAndAIIdxTable:
	// Version, ActorType,        AIIndex
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x00 // 0x0

	// Mettaur
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0x1
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0x2
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0x3
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0x4
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0x5
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0x6

	.byte 0x00, ACTOR_TYPE_VIRUS, 0x02 // 0x7
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x02 // 0x8
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x02 // 0x9
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x02 // 0xa
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x02 // 0xb
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x02 // 0xc
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x03 // 0xd
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x03 // 0xe
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x03 // 0xf
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x03 // 0x10
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x03 // 0x11
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x03 // 0x12
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x04 // 0x13
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x04 // 0x14
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x04 // 0x15
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x04 // 0x16
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x04 // 0x17
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x04 // 0x18
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x05 // 0x19
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x05 // 0x1a
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x05 // 0x1b
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x05 // 0x1c
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x05 // 0x1d
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x05 // 0x1e
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x06 // 0x1f
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x06 // 0x20
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x06 // 0x21
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x06 // 0x22
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x06 // 0x23
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x06 // 0x24
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x07 // 0x25
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x07 // 0x26
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x07 // 0x27
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x07 // 0x28
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x07 // 0x29
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x07 // 0x2a
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x08 // 0x2b
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x08 // 0x2c
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x08 // 0x2d
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x08 // 0x2e
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x08 // 0x2f
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x08 // 0x30
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x09 // 0x31
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x09 // 0x32
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x09 // 0x33
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x09 // 0x34
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x09 // 0x35
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x09 // 0x36
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x0a // 0x37
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x0a // 0x38
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x0a // 0x39
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x0a // 0x3a
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x0a // 0x3b
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x0a // 0x3c
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x0b // 0x3d
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x0b // 0x3e
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x0b // 0x3f
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x0b // 0x40
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x0b // 0x41
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x0b // 0x42
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x0c // 0x43
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x0c // 0x44
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x0c // 0x45
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x0c // 0x46
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x0c // 0x47
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x0c // 0x48
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x0d // 0x49
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x0d // 0x4a
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x0d // 0x4b
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x0d // 0x4c
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x0d // 0x4d
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x0d // 0x4e
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x0e // 0x4f
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x0e // 0x50
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x0e // 0x51
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x0e // 0x52
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x0e // 0x53
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x0e // 0x54
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x0f // 0x55
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x0f // 0x56
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x0f // 0x57
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x0f // 0x58
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x0f // 0x59
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x0f // 0x5a
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x10 // 0x5b
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x10 // 0x5c
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x10 // 0x5d
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x10 // 0x5e
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x10 // 0x5f
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x10 // 0x60
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x11 // 0x61
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x11 // 0x62
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x11 // 0x63
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x11 // 0x64
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x11 // 0x65
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x11 // 0x66
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x12 // 0x67
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x12 // 0x68
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x12 // 0x69
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x12 // 0x6a
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x12 // 0x6b
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x12 // 0x6c
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x13 // 0x6d
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x13 // 0x6e
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x13 // 0x6f
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x13 // 0x70
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x13 // 0x71
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x13 // 0x72
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x14 // 0x73
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x14 // 0x74
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x14 // 0x75
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x14 // 0x76
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x14 // 0x77
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x14 // 0x78
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x15 // 0x79
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x15 // 0x7a
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x15 // 0x7b
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x15 // 0x7c
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x15 // 0x7d
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x15 // 0x7e
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x16 // 0x7f
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x16 // 0x80
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x16 // 0x81
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x16 // 0x82
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x16 // 0x83
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x16 // 0x84

	// Gunner
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x17 // 0x85
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x17 // 0x86
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x17 // 0x87
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x17 // 0x88
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x17 // 0x89
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x17 // 0x8a

	.byte 0x00, ACTOR_TYPE_VIRUS, 0x18 // 0x8b
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x18 // 0x8c
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x18 // 0x8d
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x18 // 0x8e
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x18 // 0x8f
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x18 // 0x90
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x19 // 0x91
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x19 // 0x92
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x19 // 0x93
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x19 // 0x94
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x19 // 0x95
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x19 // 0x96
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x1a // 0x97
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x1a // 0x98
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x1a // 0x99
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x1a // 0x9a
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x1a // 0x9b
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x1a // 0x9c
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x1b // 0x9d
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x1b // 0x9e
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x1b // 0x9f
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x1b // 0xa0
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x1b // 0xa1
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x1b // 0xa2
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x1c // 0xa3
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x1c // 0xa4
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x1c // 0xa5
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x1c // 0xa6
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x1c // 0xa7
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x1c // 0xa8
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x1d // 0xa9
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x1d // 0xaa
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x1d // 0xab
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x1d // 0xac
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x1d // 0xad
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x1d // 0xae
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x1e // 0xaf
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x1e // 0xb0
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x1e // 0xb1
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x1e // 0xb2
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x1e // 0xb3
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x1e // 0xb4
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x1f // 0xb5
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x1f // 0xb6
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x1f // 0xb7
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x1f // 0xb8
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x1f // 0xb9
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x1f // 0xba
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xbb
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xbc
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xbd
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xbe
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xbf
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xc0
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xc1
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xc2
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xc3
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xc4
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xc5
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xc6
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xc7
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xc8
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xc9
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xca
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xcb
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xcc
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xcd
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xce
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xcf
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xd0
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xd1
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xd2
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xd3
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xd4
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xd5
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xd6
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xd7
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xd8
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xd9
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xda
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xdb
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xdc
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xdd
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xde
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xdf
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xe0
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xe1
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xe2
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xe3
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xe4
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xe5
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xe6
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xe7
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xe8
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xe9
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xea
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xeb
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xec
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xed
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xee
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xef
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xf0
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xf1
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xf2
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xf3
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xf4
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xf5
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xf6
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xf7
	.byte 0x01, ACTOR_TYPE_VIRUS, 0x01 // 0xf8
	.byte 0x02, ACTOR_TYPE_VIRUS, 0x01 // 0xf9
	.byte 0x03, ACTOR_TYPE_VIRUS, 0x01 // 0xfa
	.byte 0x04, ACTOR_TYPE_VIRUS, 0x01 // 0xfb
	.byte 0x05, ACTOR_TYPE_VIRUS, 0x01 // 0xfc
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xfd
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xfe
	.byte 0x00, ACTOR_TYPE_VIRUS, 0x01 // 0xff

	// Navis from here on (except one at 0x112 apparently?)
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x100
	.byte 0x00, ACTOR_TYPE_NAVI, 0x01 // 0x101
	.byte 0x01, ACTOR_TYPE_NAVI, 0x01 // 0x102
	.byte 0x02, ACTOR_TYPE_NAVI, 0x01 // 0x103
	.byte 0x03, ACTOR_TYPE_NAVI, 0x01 // 0x104
	.byte 0x04, ACTOR_TYPE_NAVI, 0x01 // 0x105
	.byte 0x05, ACTOR_TYPE_NAVI, 0x01 // 0x106
	.byte 0x00, ACTOR_TYPE_NAVI, 0x02 // 0x107
	.byte 0x01, ACTOR_TYPE_NAVI, 0x02 // 0x108
	.byte 0x02, ACTOR_TYPE_NAVI, 0x02 // 0x109
	.byte 0x03, ACTOR_TYPE_NAVI, 0x02 // 0x10a
	.byte 0x04, ACTOR_TYPE_NAVI, 0x02 // 0x10b
	.byte 0x05, ACTOR_TYPE_NAVI, 0x02 // 0x10c
	.byte 0x00, ACTOR_TYPE_NAVI, 0x03 // 0x10d
	.byte 0x01, ACTOR_TYPE_NAVI, 0x03 // 0x10e
	.byte 0x02, ACTOR_TYPE_NAVI, 0x03 // 0x10f
	.byte 0x03, ACTOR_TYPE_NAVI, 0x03 // 0x110
	.byte 0x04, ACTOR_TYPE_NAVI, 0x03 // 0x111
	.byte 0x05, 0x00, 0x03 // 0x112
	.byte 0x00, ACTOR_TYPE_NAVI, 0x04 // 0x113
	.byte 0x01, ACTOR_TYPE_NAVI, 0x04 // 0x114
	.byte 0x02, ACTOR_TYPE_NAVI, 0x04 // 0x115
	.byte 0x03, ACTOR_TYPE_NAVI, 0x04 // 0x116
	.byte 0x04, ACTOR_TYPE_NAVI, 0x04 // 0x117
	.byte 0x05, ACTOR_TYPE_NAVI, 0x04 // 0x118
	.byte 0x00, ACTOR_TYPE_NAVI, 0x05 // 0x119
	.byte 0x01, ACTOR_TYPE_NAVI, 0x05 // 0x11a
	.byte 0x02, ACTOR_TYPE_NAVI, 0x05 // 0x11b
	.byte 0x03, ACTOR_TYPE_NAVI, 0x05 // 0x11c
	.byte 0x04, ACTOR_TYPE_NAVI, 0x05 // 0x11d
	.byte 0x05, ACTOR_TYPE_NAVI, 0x05 // 0x11e
	.byte 0x00, ACTOR_TYPE_NAVI, 0x06 // 0x11f
	.byte 0x01, ACTOR_TYPE_NAVI, 0x06 // 0x120
	.byte 0x02, ACTOR_TYPE_NAVI, 0x06 // 0x121
	.byte 0x03, ACTOR_TYPE_NAVI, 0x06 // 0x122
	.byte 0x04, ACTOR_TYPE_NAVI, 0x06 // 0x123
	.byte 0x05, ACTOR_TYPE_NAVI, 0x06 // 0x124
	.byte 0x00, ACTOR_TYPE_NAVI, 0x07 // 0x125
	.byte 0x01, ACTOR_TYPE_NAVI, 0x07 // 0x126
	.byte 0x02, ACTOR_TYPE_NAVI, 0x07 // 0x127
	.byte 0x03, ACTOR_TYPE_NAVI, 0x07 // 0x128
	.byte 0x04, ACTOR_TYPE_NAVI, 0x07 // 0x129
	.byte 0x05, ACTOR_TYPE_NAVI, 0x07 // 0x12a
	.byte 0x00, ACTOR_TYPE_NAVI, 0x08 // 0x12b
	.byte 0x01, ACTOR_TYPE_NAVI, 0x08 // 0x12c
	.byte 0x02, ACTOR_TYPE_NAVI, 0x08 // 0x12d
	.byte 0x03, ACTOR_TYPE_NAVI, 0x08 // 0x12e
	.byte 0x04, ACTOR_TYPE_NAVI, 0x08 // 0x12f
	.byte 0x05, ACTOR_TYPE_NAVI, 0x08 // 0x130
	.byte 0x00, ACTOR_TYPE_NAVI, 0x09 // 0x131
	.byte 0x01, ACTOR_TYPE_NAVI, 0x09 // 0x132
	.byte 0x02, ACTOR_TYPE_NAVI, 0x09 // 0x133
	.byte 0x03, ACTOR_TYPE_NAVI, 0x09 // 0x134
	.byte 0x04, ACTOR_TYPE_NAVI, 0x09 // 0x135
	.byte 0x05, ACTOR_TYPE_NAVI, 0x09 // 0x136
	.byte 0x00, ACTOR_TYPE_NAVI, 0x0a // 0x137
	.byte 0x01, ACTOR_TYPE_NAVI, 0x0a // 0x138
	.byte 0x02, ACTOR_TYPE_NAVI, 0x0a // 0x139
	.byte 0x03, ACTOR_TYPE_NAVI, 0x0a // 0x13a
	.byte 0x04, ACTOR_TYPE_NAVI, 0x0a // 0x13b
	.byte 0x05, ACTOR_TYPE_NAVI, 0x0a // 0x13c
	.byte 0x00, ACTOR_TYPE_NAVI, 0x0b // 0x13d
	.byte 0x01, ACTOR_TYPE_NAVI, 0x0b // 0x13e
	.byte 0x02, ACTOR_TYPE_NAVI, 0x0b // 0x13f
	.byte 0x03, ACTOR_TYPE_NAVI, 0x0b // 0x140
	.byte 0x04, ACTOR_TYPE_NAVI, 0x0b // 0x141
	.byte 0x05, ACTOR_TYPE_NAVI, 0x0b // 0x142
	.byte 0x00, ACTOR_TYPE_NAVI, 0x0c // 0x143
	.byte 0x01, ACTOR_TYPE_NAVI, 0x0c // 0x144
	.byte 0x02, ACTOR_TYPE_NAVI, 0x0c // 0x145
	.byte 0x03, ACTOR_TYPE_NAVI, 0x0c // 0x146
	.byte 0x04, ACTOR_TYPE_NAVI, 0x0c // 0x147
	.byte 0x05, ACTOR_TYPE_NAVI, 0x0c // 0x148
	.byte 0x00, ACTOR_TYPE_NAVI, 0x0d // 0x149
	.byte 0x01, ACTOR_TYPE_NAVI, 0x0d // 0x14a
	.byte 0x02, ACTOR_TYPE_NAVI, 0x0d // 0x14b
	.byte 0x03, ACTOR_TYPE_NAVI, 0x0d // 0x14c
	.byte 0x04, ACTOR_TYPE_NAVI, 0x0d // 0x14d
	.byte 0x05, ACTOR_TYPE_NAVI, 0x0d // 0x14e
	.byte 0x00, ACTOR_TYPE_NAVI, 0x0e // 0x14f
	.byte 0x01, ACTOR_TYPE_NAVI, 0x0e // 0x150
	.byte 0x02, ACTOR_TYPE_NAVI, 0x0e // 0x151
	.byte 0x03, ACTOR_TYPE_NAVI, 0x0e // 0x152
	.byte 0x04, ACTOR_TYPE_NAVI, 0x0e // 0x153
	.byte 0x05, ACTOR_TYPE_NAVI, 0x0e // 0x154
	.byte 0x00, ACTOR_TYPE_NAVI, 0x0f // 0x155
	.byte 0x01, ACTOR_TYPE_NAVI, 0x0f // 0x156
	.byte 0x02, ACTOR_TYPE_NAVI, 0x0f // 0x157
	.byte 0x03, ACTOR_TYPE_NAVI, 0x0f // 0x158
	.byte 0x04, ACTOR_TYPE_NAVI, 0x0f // 0x159
	.byte 0x05, ACTOR_TYPE_NAVI, 0x0f // 0x15a
	.byte 0x00, ACTOR_TYPE_NAVI, 0x10 // 0x15b
	.byte 0x01, ACTOR_TYPE_NAVI, 0x10 // 0x15c
	.byte 0x02, ACTOR_TYPE_NAVI, 0x10 // 0x15d
	.byte 0x03, ACTOR_TYPE_NAVI, 0x10 // 0x15e
	.byte 0x04, ACTOR_TYPE_NAVI, 0x10 // 0x15f
	.byte 0x05, ACTOR_TYPE_NAVI, 0x10 // 0x160
	.byte 0x00, ACTOR_TYPE_NAVI, 0x11 // 0x161
	.byte 0x01, ACTOR_TYPE_NAVI, 0x11 // 0x162
	.byte 0x02, ACTOR_TYPE_NAVI, 0x11 // 0x163
	.byte 0x03, ACTOR_TYPE_NAVI, 0x11 // 0x164
	.byte 0x04, ACTOR_TYPE_NAVI, 0x11 // 0x165
	.byte 0x05, ACTOR_TYPE_NAVI, 0x11 // 0x166
	.byte 0x00, ACTOR_TYPE_NAVI, 0x12 // 0x167
	.byte 0x01, ACTOR_TYPE_NAVI, 0x12 // 0x168
	.byte 0x02, ACTOR_TYPE_NAVI, 0x12 // 0x169
	.byte 0x03, ACTOR_TYPE_NAVI, 0x12 // 0x16a
	.byte 0x04, ACTOR_TYPE_NAVI, 0x12 // 0x16b
	.byte 0x05, ACTOR_TYPE_NAVI, 0x12 // 0x16c
	.byte 0x00, ACTOR_TYPE_NAVI, 0x13 // 0x16d
	.byte 0x01, ACTOR_TYPE_NAVI, 0x13 // 0x16e
	.byte 0x02, ACTOR_TYPE_NAVI, 0x13 // 0x16f
	.byte 0x03, ACTOR_TYPE_NAVI, 0x13 // 0x170
	.byte 0x04, ACTOR_TYPE_NAVI, 0x13 // 0x171
	.byte 0x05, ACTOR_TYPE_NAVI, 0x13 // 0x172
	.byte 0x00, ACTOR_TYPE_NAVI, 0x14 // 0x173
	.byte 0x01, ACTOR_TYPE_NAVI, 0x14 // 0x174
	.byte 0x02, ACTOR_TYPE_NAVI, 0x14 // 0x175
	.byte 0x03, ACTOR_TYPE_NAVI, 0x14 // 0x176
	.byte 0x04, ACTOR_TYPE_NAVI, 0x14 // 0x177
	.byte 0x05, ACTOR_TYPE_NAVI, 0x14 // 0x178
	.byte 0x00, ACTOR_TYPE_NAVI, 0x15 // 0x179
	.byte 0x01, ACTOR_TYPE_NAVI, 0x15 // 0x17a
	.byte 0x02, ACTOR_TYPE_NAVI, 0x15 // 0x17b
	.byte 0x03, ACTOR_TYPE_NAVI, 0x15 // 0x17c
	.byte 0x04, ACTOR_TYPE_NAVI, 0x15 // 0x17d
	.byte 0x05, ACTOR_TYPE_NAVI, 0x15 // 0x17e
	.byte 0x00, ACTOR_TYPE_NAVI, 0x16 // 0x17f
	.byte 0x01, ACTOR_TYPE_NAVI, 0x16 // 0x180
	.byte 0x02, ACTOR_TYPE_NAVI, 0x16 // 0x181
	.byte 0x03, ACTOR_TYPE_NAVI, 0x16 // 0x182
	.byte 0x04, ACTOR_TYPE_NAVI, 0x16 // 0x183
	.byte 0x05, ACTOR_TYPE_NAVI, 0x16 // 0x184
	.byte 0x00, ACTOR_TYPE_NAVI, 0x17 // 0x185
	.byte 0x01, ACTOR_TYPE_NAVI, 0x17 // 0x186
	.byte 0x02, ACTOR_TYPE_NAVI, 0x17 // 0x187
	.byte 0x03, ACTOR_TYPE_NAVI, 0x17 // 0x188
	.byte 0x04, ACTOR_TYPE_NAVI, 0x17 // 0x189
	.byte 0x05, ACTOR_TYPE_NAVI, 0x17 // 0x18a
	.byte 0x00, ACTOR_TYPE_NAVI, 0x18 // 0x18b
	.byte 0x01, ACTOR_TYPE_NAVI, 0x18 // 0x18c
	.byte 0x02, ACTOR_TYPE_NAVI, 0x18 // 0x18d
	.byte 0x03, ACTOR_TYPE_NAVI, 0x18 // 0x18e
	.byte 0x04, ACTOR_TYPE_NAVI, 0x18 // 0x18f
	.byte 0x05, ACTOR_TYPE_NAVI, 0x18 // 0x190
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x191
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x192
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x193
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x194
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x195
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x196
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x197
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x198
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x199
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x19a
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x19b
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x19c
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x19d
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x19e
	.byte 0x00, ACTOR_TYPE_NAVI, 0x00 // 0x19f

	// Players

  // MegaMan
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x00 // 0x1a0

	.byte 0x00, ACTOR_TYPE_PLAYER, 0x01 // 0x1a1
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x02 // 0x1a2
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x03 // 0x1a3
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x04 // 0x1a4
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x05 // 0x1a5
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x06 // 0x1a6
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x07 // 0x1a7
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x08 // 0x1a8
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x09 // 0x1a9
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x0a // 0x1aa
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x0b // 0x1ab
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x19 // 0x1ac
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x1a // 0x1ad
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x1b // 0x1ae
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x1c // 0x1af
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x1d // 0x1b0
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x1e // 0x1b1
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x1f // 0x1b2
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x20 // 0x1b3
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x21 // 0x1b4
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x22 // 0x1b5
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x23 // 0x1b6
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x24 // 0x1b7
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x25 // 0x1b8
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x26 // 0x1b9
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x27 // 0x1ba
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x28 // 0x1bb
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x29 // 0x1bc
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x2a // 0x1bd
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x2b // 0x1be
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x2c // 0x1bf
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x2d // 0x1c0
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x2e // 0x1c1
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x2f // 0x1c2
	.byte 0x00, ACTOR_TYPE_PLAYER, 0x30 // 0x1c3
	thumb_func_end GetVerActorTyAndAIIdx_80182B4

	thumb_func_start getBattleArmPositionMaybe_8018810
// r0 - name id
// r1 - ???
// r2 - alliance
// r3 - direction flip
// symdb: Returns the mirrored (x, y) attachment offset of an arm/part slot on a battle object, or the fixed default pair (0, 7) for invalid slot ids 0xCD..0xFF.
// symdb: (int armId /*r0*/, int index /*r1*/, int objA /*r2*/, int objB /*r3*/) -> (int x /*r0*/, int y
// symdb: /*r1*/, int flip /*r2*/); r4-r6 preserved, NZCV clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getBattleArmPositionMaybe_8018810.yaml
getBattleArmPositionMaybe_8018810:
	push {r4-r6,lr}
	cmp r0, #0xcd
	blt loc_801881A
	cmp r0, #0xff
	ble loc_801883C
loc_801881A:
	mov r4, r1
	mov r5, r2
	mov r6, r3
	bl enemy_getArmPosition_800F26C
	mov r2, r4
	bl getIndexedSignedBytePair_8018842
	push {r0,r1}
	mov r0, r5
	mov r1, r6
	bl object_getFlipDirection // (int a1, int a2) -> int
	mov r2, r0
	pop {r0,r1}
	mul r0, r2
	pop {r4-r6,pc}
loc_801883C:
	mov r0, #0
	mov r1, #7
	pop {r4-r6,pc}
	thumb_func_end getBattleArmPositionMaybe_8018810

// symdb: Fetches a two-byte table entry (two signed bytes) selected by an index, with the table base supplied by a helper call.
// symdb: int getIndexedSignedBytePair(int baseArg0, int baseArg1, int index) — returns entry byte0 in r0
// symdb: and byte1 in r1, both sign-extended (s8); r2-r4 not returned modified (r4 preserved)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getIndexedSignedBytePair_8018842.yaml
	thumb_func_start getIndexedSignedBytePair_8018842
getIndexedSignedBytePair_8018842:
	push {r4,lr}
	add r4, r2, r2
	bl getAnmSeqRowIndexTableEntry_8018886
	add r4, r4, r0
	mov r0, #0
	ldrsb r0, [r4,r0]
	mov r1, #1
	ldrsb r1, [r4,r1]
	pop {r4,pc}
	thumb_func_end getIndexedSignedBytePair_8018842

// symdb: Computes the per-frame X-axis step the AI moves toward an enemy based on a chip-class table, signed by the object's facing direction.
// symdb: (r0 = chipClassTableIdx, r5 = BattleObjectPtr) -> r0 = signed X-step multiplier for AI movement
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_computeAIStepForwardDeltaX_8018856.yaml
	thumb_local_start
battleObject_computeAIStepForwardDeltaX_8018856:
	push {lr}
	push {r0}
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	bl chip_class_lookup_800FC9E
	mov r0, r1
	mov r1, r2
	pop {r2}
	bl getIndexedSignedBytePair_8018842
	push {r0,r1}
	bl object_getFrontDirection // () -> int
	mov r2, r0
	pop {r0,r1}
	mul r0, r2
	pop {pc}
	thumb_func_end battleObject_computeAIStepForwardDeltaX_8018856

// symdb: Looks up a per-form entry in one of three animation sequence tables indexed by a form id and row index, optionally remapped by a 16-byte remap table.
// symdb: (r0 = formID, r1 = rowIdx) -> r0 = pointer to a 0x44-byte row inside one of three variant tables
// symdb: ; side effects: none (leaf, returns via mov pc, lr)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getAnmSeqRowIndexTableEntry_8018886.yaml
	thumb_local_start
getAnmSeqRowIndexTableEntry_8018886:
	cmp r0, #0
	bne loc_801888E
	ldr r2, off_80188AC // =byte_80188B0
	ldrb r1, [r2,r1]
loc_801888E:
	ldr r2, off_801889C // =off_80188A0 
	ldr r0, [r2,r0]
	mov r3, #0x44 
	mul r1, r3
	add r0, r0, r1
	mov pc, lr
	.balign 4, 0
off_801889C:
	.word off_80188A0
off_80188A0:
	.word byte_80188C0
	.word byte_801898C
	.word byte_80191C8
off_80188AC:
	.word byte_80188B0
byte_80188B0:
	.byte 0x0, 0x1, 0x1, 0x1, 0x1, 0x1, 0x2, 0x2, 0x2, 0x2, 0x2, 0x1, 0x2, 0x0, 0x0, 0x0
byte_80188C0:
	.byte 0x2, 0x0, 0x2, 0x0, 0x2, 0x0, 0x8, 0x30, 0x8, 0x30, 0x8, 0x30, 0x10
	.byte 0x0, 0x10, 0x18, 0x10, 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18
	.byte 0x18, 0x18, 0x17, 0x19, 0x18, 0x18, 0x28, 0x1A, 0x5, 0xB, 0x1F, 0x19, 0x28
	.byte 0x1A, 0x14, 0x19, 0x2, 0x10, 0x18, 0x18, 0x18, 0x19, 0x18, 0x17, 0x16, 0x19
	.byte 0x1C, 0x19, 0x2, 0x12, 0x58, 0x10, 0x78, 0xFC, 0xF8, 0x10, 0x40, 0x10, 0x2
	.byte 0x0, 0x0, 0x0, 0x6, 0x0, 0x6, 0x0, 0x6, 0x0, 0x10, 0x2C, 0x10, 0x2C
	.byte 0x10, 0x2C, 0x18, 0x0, 0x1B, 0x11, 0x18, 0x11, 0x26, 0x12, 0x1F, 0x12, 0x1F
	.byte 0x12, 0x1D, 0x11, 0x23, 0x11, 0x23, 0x13, 0x23, 0x11, 0x33, 0x14, 0x8, 0xA
	.byte 0x29, 0x14, 0x30, 0x13, 0x20, 0x13, 0x6, 0x10, 0x23, 0x12, 0x20, 0x12, 0x20
	.byte 0x10, 0x20, 0x13, 0x24, 0x11, 0x8, 0x10, 0x68, 0x8, 0x7C, 0xF6, 0xF8, 0x18
	.byte 0x50, 0xE
	.word 0x4000006
	.word 0x18041004
	.word 0x40091004
	.word 0x40094009
	.word 0x25100010
	.word 0x26182610
	.word 0x26112611
	.word 0x26162612
	.word 0x25182716
	.word 0x17092728
	.word 0x2728281D
	.word 0x20042712
	.word 0x27162616
	.word 0x27142718
	.word 0x20042619
	.word byte_8721C58
	.word 0x22411CF8
	.word loc_8040A04
byte_801898C:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x12, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1C, 0x0, 0x18, 0x4, 0x18, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x2, 0xFE, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x7, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x2A, 0x3, 0x28, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x4, 0xB, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x13, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x5, 0xB
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x39, 0x0, 0x34, 0x7, 0x31, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x18, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x18, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0xC, 0x18, 0x19, 0x28, 0x14, 0x0, 0x18, 0x0, 0x14, 0x0, 0x0, 0x3, 0x18
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x32, 0x0, 0x30, 0x3, 0x28, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x2, 0x8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x13, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x9
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2D, 0x0, 0x2B, 0x5, 0x28, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0xE, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x13, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0xC
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2A, 0x0, 0x28, 0x0, 0x28, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x10, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x6
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x28, 0x0, 0x21, 0x4, 0x22, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xC, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x15, 0x18, 0x19, 0x28, 0x14, 0x0, 0xC, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x38, 0x0, 0x33, 0x4, 0x24, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x3, 0x8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x16, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0xA
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2C, 0x0, 0x23, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xC, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x10, 0x18, 0x19, 0x28, 0x14, 0x0, 0xC, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x3A, 0x0, 0x33, 0x2, 0x39, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x13, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x18, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x8, 0x18, 0x19, 0x28, 0x14, 0x0, 0x18, 0x0, 0x14, 0x0, 0x0, 0x0, 0x10
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x31, 0x0, 0x28, 0x5, 0x25, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x10, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x5
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2E, 0x0, 0x23, 0x19, 0x1B, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0xC, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x26, 0x0, 0x26, 0x3, 0x1B, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x4, 0xFE, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x16, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2B, 0x0, 0x2B, 0x6, 0x30, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x7, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x14, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x16, 0x18, 0x19, 0x28, 0x14, 0x0, 0x14, 0x0, 0x14, 0x0, 0x0, 0x2, 0x6
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x38, 0x0, 0x38, 0x6, 0x2B, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x5, 0xC, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x16, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0xC, 0x18, 0x19, 0x28, 0x14, 0x0, 0x16, 0x0, 0x14, 0x0, 0x0, 0x8, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x40, 0x8, 0x40, 0xB, 0x28, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x8, 0x16, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4, 0x20, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x10, 0x18, 0x19, 0x28, 0x14, 0x4, 0x20, 0x0, 0x14, 0x0, 0x0, 0x0, 0x4
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x3F, 0x0, 0x3A, 0x3, 0x2B, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x6, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x17, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x1B, 0x18, 0x19, 0x4E, 0xFA, 0x0, 0x17, 0x0, 0x14, 0x0, 0x0, 0x8, 0x2
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x38, 0x0, 0x30, 0x6, 0x30, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x1, 0xF, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x18, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x10, 0x4D, 0x14, 0x28, 0x14, 0x0, 0x18, 0x0, 0x14, 0x0, 0x0, 0x2, 0x12
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x36, 0x0, 0x36, 0x0, 0x1F, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x14, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x8
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x32, 0x0, 0x30, 0x3, 0x2A, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x2, 0x8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x18, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x8
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x25, 0x0, 0x23, 0x7, 0x1C, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.word 0x8000000
	.byte 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C
	.byte 0x19, 0x0, 0x16, 0x18, 0x19, 0x28, 0x14, 0x0, 0x8
	.byte 0x0, 0x14, 0x0, 0x0, 0x3, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0xF8, 0x41, 0xFB, 0x3C, 0x2, 0x3E
	.byte 0x0, 0x0, 0x0, 0x0, 0x10, 0x18, 0x18, 0x18, 0x12
	.byte 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18
	.byte 0x18, 0x18, 0x0, 0x0, 0xFE, 0x1B, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x14, 0x19, 0x17, 0x18, 0x1A
	.byte 0x18, 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x0, 0x10, 0x18
	.byte 0x19, 0x28, 0x14, 0xF8, 0x28, 0x0, 0x14, 0x0, 0x0
	.byte 0x0, 0x10, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x39, 0x0, 0x32, 0x0, 0x3A, 0x0, 0x0, 0x0, 0x0
	.byte 0x10, 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12
	.byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x14, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x16, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A
	.byte 0x1C, 0x19, 0x2, 0x10, 0x18, 0x19, 0x28, 0x14, 0x0
	.byte 0x16, 0x0, 0x14, 0x0, 0x0, 0x7, 0x4, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x2E, 0x0, 0x29, 0x0
	.byte 0x30, 0x0, 0x0, 0x0, 0x0, 0x10, 0x18, 0x18, 0x18
	.byte 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18
	.byte 0x18, 0x18, 0x18, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18
	.byte 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x0, 0x10
	.byte 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0
	.byte 0x0, 0x0, 0xA, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0xFD, 0x30, 0x0, 0x28, 0x4, 0x2C, 0x0, 0x0, 0x0
	.byte 0x0, 0x10, 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18
	.byte 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0
	.byte 0x0, 0xFC, 0xE, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0xE, 0x18, 0x19, 0x28, 0x14
	.byte 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0xC, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x18, 0x0, 0x18
	.byte 0xFC, 0xD, 0x0, 0x0, 0x0, 0x0, 0x10, 0x18, 0x18
	.byte 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18
	.byte 0x18, 0x18, 0x18, 0x18, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17
	.byte 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x0
	.byte 0xC, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14
	.byte 0x0, 0x0, 0x0, 0xF0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x26, 0x0, 0x26, 0xD, 0x17, 0x0, 0x0
	.byte 0x0, 0x0, 0x10, 0x18, 0x18, 0x18, 0x12, 0x18, 0x12
	.byte 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18
	.byte 0x0, 0x0, 0x4, 0x2, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17
	.byte 0x18, 0x1A, 0x1C, 0x19, 0x0, 0xE, 0x18, 0x19, 0x28
	.byte 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x7, 0x2
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x40, 0x0
	.byte 0x3D, 0x1, 0x3B, 0x0, 0x0, 0x0, 0x0, 0x10, 0x18
	.byte 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18
	.byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0, 0x0, 0x10
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xFE, 0x16, 0x19
	.byte 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C, 0x19
	.byte 0x0, 0x10, 0x18, 0x19, 0x28, 0x14, 0xFE, 0x16, 0x0
	.byte 0x14, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x6, 0x3F, 0x5, 0x3F, 0x9, 0x37, 0x0
	.byte 0x0, 0x0, 0x0, 0x10, 0x18, 0x18, 0x18, 0x12, 0x18
	.byte 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18
	.byte 0x18, 0x0, 0x0, 0x6, 0x10, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x4, 0x20, 0x19, 0x17, 0x18, 0x1A, 0x18
	.byte 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x6, 0x14, 0x18, 0x19
	.byte 0x28, 0x14, 0x4, 0x20, 0x0, 0x14, 0x0, 0x0, 0xA
	.byte 0x8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x38
	.byte 0x8, 0x38, 0xA, 0x38, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18
	.byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C
	.byte 0x19, 0x4, 0x14, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10
	.byte 0x0, 0x14, 0x0, 0x0, 0x0, 0x0
byte_80191C8:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x12, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x8, 0x0, 0x8, 0x0, 0x8, 0x6, 0x35, 0x8, 0x37, 0x8, 0x37, 0x18, 0x0, 0x16, 0x16, 0x10
	.byte 0x16, 0x1A, 0x16, 0x12, 0x17, 0x18, 0x17, 0x14, 0x16, 0x18, 0x16, 0x1A, 0x17, 0x18, 0x16, 0x3B, 0x19
	.byte 0x8, 0x10, 0x21, 0x18, 0x28, 0x18, 0x16, 0x18, 0x2, 0x18, 0x1A, 0x16, 0x18, 0x17, 0x18, 0x15, 0x18
	.byte 0x17, 0x1C, 0x16, 0x2, 0x10, 0x5B, 0xE, 0x78, 0xFB, 0xFC, 0x1C, 0x43, 0x10, 0x6, 0x8, 0x0, 0x0
	.byte 0x0, 0x14, 0x0, 0x14, 0x0, 0x14, 0x2, 0x46, 0x2, 0x46, 0x2, 0x46, 0x10, 0x0, 0xC, 0x2B, 0xC
	.byte 0x2B, 0x14, 0x2C, 0xE, 0x2C, 0xE, 0x2D, 0xE, 0x2C, 0x14, 0x2C, 0x14, 0x2D, 0x14, 0x2C, 0x23, 0x2E
	.byte 0x2, 0x1E, 0x1B, 0x2F, 0x24, 0x2D, 0x10, 0x2E, 0x0, 0x20, 0x14, 0x2C, 0x12, 0x2D, 0x14, 0x2B, 0x14
	.byte 0x2E, 0x17, 0x2D, 0x2, 0x22, 0x58, 0x1C, 0x70, 0x10, 0xF8, 0x1C, 0x40, 0x28, 0x2, 0x10, 0x2, 0xA
	.byte 0x0, 0x0, 0x3, 0x8, 0x0, 0x0, 0x8, 0x32, 0x8, 0x30, 0x8, 0x30, 0x1A, 0x0, 0x18, 0x1A, 0x10
	.byte 0x19, 0x20, 0x18, 0x1A, 0x18, 0x1C, 0x18, 0x1E, 0x1A, 0x20, 0x18, 0x22, 0x1A, 0x20, 0x18, 0x30, 0x1A
	.byte 0x4, 0xA, 0x24, 0x1A, 0x2C, 0x1A, 0x1C, 0x1A, 0x4, 0x12, 0x20, 0x18, 0x20, 0x19, 0x18, 0x18, 0x22
	.byte 0x1A, 0x23, 0x18, 0x0, 0x12, 0x62, 0x10, 0x7C, 0xFC, 0xF6, 0x16, 0x40, 0x16, 0x3, 0x0, 0x0, 0xA
	.byte 0x3, 0xA, 0x6, 0xE, 0x3, 0xA, 0xC, 0x3C, 0xC, 0x38, 0xE, 0x38, 0x18, 0x0, 0x17, 0x25, 0x10
	.byte 0x24, 0x1E, 0x24, 0x18, 0x24, 0x18, 0x25, 0x17, 0x24, 0x1A, 0x24, 0x1E, 0x25, 0x20, 0x24, 0x2C, 0x25
	.byte 0x8, 0xE, 0x23, 0x26, 0x2A, 0x25, 0x18, 0x26, 0x8, 0x1A, 0x1E, 0x24, 0x1C, 0x25, 0x18, 0x26, 0x1C
	.byte 0x26, 0x20, 0x24, 0x8, 0xE, 0x5E, 0x1A, 0x78, 0x8, 0xF2, 0x20, 0x40, 0x20, 0x4, 0x8, 0x0, 0x10
	.byte 0x0, 0x0, 0x0, 0xA, 0x0, 0x0, 0x10, 0x30, 0x4, 0x2E, 0x10, 0x24, 0x1C, 0x0, 0xE, 0x11, 0x10
	.byte 0x11, 0x16, 0x10, 0x10, 0x10, 0x12, 0x11, 0x10, 0x11, 0x16, 0x11, 0x16, 0x12, 0x16, 0x10
	.word 0x8001230
	.byte 0x20, 0x12, 0x26, 0x12, 0x12, 0x12, 0x0, 0x14, 0x16
	.byte 0x10, 0x16, 0x11, 0x14, 0x10, 0x16, 0x12, 0x16, 0x11
	.byte 0x0, 0x8, 0x50, 0x8, 0x70, 0xF8, 0xFC, 0x18, 0x3C
	.byte 0xE, 0x0, 0x0, 0x0, 0x8, 0x0, 0xFC, 0x0, 0x0
	.byte 0x0, 0xFC, 0x3, 0x2A, 0x0, 0x26, 0x4, 0x26, 0x10
	.byte 0x0, 0xE, 0xE, 0x8, 0x10, 0x16, 0xD, 0x10, 0xC
	.byte 0x10, 0xC, 0x10, 0xE, 0x14, 0xD, 0x15, 0xD, 0x16
	.byte 0xC, 0x20, 0xE, 0x0, 0x8, 0x1E, 0xE, 0x20, 0x10
	.byte 0x12, 0xE, 0x0, 0x10, 0x16, 0xC, 0x14, 0xD, 0x10
	.byte 0x10, 0x14, 0xD, 0x16, 0xD, 0x0, 0x8, 0x58, 0x4
	.byte 0x78, 0xF0, 0xF8, 0x10, 0x40, 0x8, 0x0, 0x0, 0x0
	.byte 0x0
	.word 0x8040000
	.byte 0x0, 0x0, 0xA, 0x36, 0xA, 0x32, 0xA, 0x2E, 0x18, 0x0, 0xD
	.byte 0x15, 0xD, 0x15, 0x16, 0x14, 0x10, 0x14, 0x12, 0x14, 0x12, 0x14
	.byte 0x16, 0x15, 0x16, 0x15, 0x14, 0x14
	.word 0x8061622
	.byte 0x1F, 0x15, 0x22, 0x15, 0x12, 0x15, 0x4, 0x16, 0x16
	.byte 0x14, 0x16, 0x15, 0x10, 0x14, 0x16, 0x15
	.word 0x8061416
	.byte 0x58, 0xB, 0x78, 0xF8, 0x4, 0x16, 0x40, 0x10, 0x0, 0x0, 0x8
	.byte 0x8, 0x2, 0x18, 0x0, 0x1E, 0x2, 0x18, 0x2, 0x4E, 0x2, 0x48
	.byte 0x6, 0x4E, 0x14, 0x0, 0x10, 0x33, 0x10, 0x32, 0x14, 0x32, 0xE
	.byte 0x32, 0x10, 0x32, 0xE, 0x32, 0x13, 0x32, 0x16, 0x33, 0x15, 0x31
	.byte 0x28, 0x33, 0x5, 0x20, 0x20, 0x30, 0x20, 0x33, 0x10, 0x33, 0x0
	.byte 0x28, 0x16, 0x32, 0x13, 0x32, 0x10, 0x30, 0x13, 0x33, 0x16, 0x32
	.byte 0x5, 0x20, 0x58, 0x1C, 0x78, 0x10, 0xF8, 0x25, 0x40, 0x28, 0x2
	.byte 0x8, 0x4, 0x18, 0xFC, 0x4, 0xFE, 0x16, 0xFC, 0x4, 0x0, 0x40
	.byte 0x0, 0x40, 0x0, 0x3A, 0x16, 0x0, 0xC, 0x21, 0xC, 0x21, 0x10
	.byte 0x20, 0x8, 0x20, 0x10, 0x20, 0x10, 0x20, 0x10, 0x20, 0x10, 0x21
	.byte 0xE, 0x1F, 0x28, 0x21, 0xFC, 0x10, 0x1E, 0x21, 0x1E, 0x20, 0xE
	.byte 0x21, 0xFE, 0x16, 0x10, 0x20, 0x10, 0x20, 0x10, 0x20, 0xE, 0x21
	.byte 0x12, 0x1F, 0xFC, 0x10, 0x58, 0x10, 0x78, 0x0, 0xFE, 0x16, 0x40
	.byte 0x16, 0xFC, 0x8, 0x0, 0x0, 0x2, 0x6, 0x2, 0x6, 0x2, 0x6
	.byte 0x0, 0x3F, 0x0, 0x3C, 0x8, 0x3D, 0x1D, 0x0, 0x17, 0x1D, 0x10
	.byte 0x18, 0x1E, 0x1D, 0x18, 0x1D, 0x19, 0x1D, 0x1B, 0x1D, 0x1D, 0x1C
	.byte 0x20, 0x1D, 0x1B, 0x1C, 0x42, 0x1F, 0x0, 0x19, 0x27, 0x1E, 0x2B
	.byte 0x1F, 0x1B, 0x1E, 0x0, 0x19, 0x20, 0x1D, 0x20, 0x1E, 0x1C, 0x1C
	.byte 0x1D, 0x1F, 0x1E, 0x1E, 0x0, 0x19, 0x6A, 0x14, 0x76, 0xFF, 0x0
	.byte 0x19, 0x4E, 0x18, 0x0, 0x4, 0x0, 0x0, 0x4, 0x0, 0x4, 0x0
	.byte 0x4, 0x0, 0xA, 0x32, 0xA, 0x32, 0xA, 0x32, 0x10, 0x0, 0x10
	.byte 0x18, 0x10, 0x18, 0x1B, 0x19, 0x14, 0x1A, 0x14, 0x1A, 0x14, 0x19
	.byte 0x18, 0x18, 0x18, 0x1B, 0x18, 0x19, 0x2B, 0x1C, 0x6, 0xC, 0x1E
	.byte 0x1B, 0x28, 0x1B, 0x14, 0x1B, 0x2, 0x14, 0x18, 0x1A, 0x18, 0x1B
	.byte 0x18, 0x17, 0x18, 0x1B, 0x1B, 0x19, 0x4, 0x16, 0x5A, 0x8, 0x72
	.byte 0xFC, 0xF8, 0x14, 0x44, 0x16, 0x4, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x8, 0x48, 0x8, 0x48, 0x8, 0x48, 0x0
	.byte 0x0, 0x0, 0x0, 0x10, 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18
	.byte 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0, 0x4
	.byte 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17
	.byte 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x0, 0x12, 0x18
	.byte 0x19, 0x28, 0x14, 0x0, 0x23, 0x0, 0x14, 0x0, 0x0, 0x8, 0x10
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4, 0x40, 0x8, 0x3D, 0xA
	.byte 0x3D, 0x10, 0x0, 0x0, 0x0, 0x10, 0x18, 0x18, 0x18, 0x12, 0x18
	.byte 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0
	.byte 0x0, 0xA, 0x10, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x0
	.byte 0x12, 0x18, 0x19, 0x28, 0x14, 0xF8, 0x18, 0x0, 0x14, 0x0, 0x0
	.byte 0xFC, 0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xF9, 0x40, 0x0
	.byte 0x40, 0x1, 0x39, 0x0, 0x0, 0x0, 0x0, 0x10, 0x18, 0x18, 0x18
	.byte 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18
	.byte 0x18, 0x0, 0x0, 0x0, 0x9, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C
	.byte 0x19, 0x0, 0x12, 0x18, 0x19, 0x28, 0x14, 0xF0, 0x18, 0x0, 0x14
	.byte 0x0, 0x0, 0x0, 0xFD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x4D, 0x0, 0x48, 0x0, 0x48, 0x0, 0x0, 0x0, 0x0, 0x10, 0x18
	.byte 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18
	.byte 0x18, 0x18, 0x18, 0x0, 0x0, 0x0, 0x1A, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18
	.byte 0x1A, 0x1C, 0x19, 0x0, 0x12, 0x18, 0x19, 0x28, 0x14, 0xF6, 0x26
	.byte 0x0, 0x14, 0x0, 0x0, 0x0, 0x9, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0xFC, 0x48, 0xFC, 0x46, 0xFE, 0x42, 0x0, 0x0, 0x0, 0x0
	.byte 0x10, 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18
	.byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0, 0xFD, 0x1B, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18
	.byte 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x0, 0x12, 0x18, 0x19, 0x28, 0x14
	.byte 0xF0, 0x1C, 0x0, 0x14, 0x0, 0x0, 0xFE, 0x4, 0xFC, 0x18, 0xFC
	.byte 0x1E, 0xFC, 0x18, 0x0, 0x50, 0x0, 0x48, 0x0, 0x48, 0x10, 0x0
	.byte 0x0, 0x0, 0x10, 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12
	.byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0, 0x0, 0x20
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xFC, 0x28, 0x19, 0x17, 0x18
	.byte 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x0, 0x28, 0x18, 0x19
	.byte 0x28, 0x14, 0xF8, 0x28, 0x0, 0x14, 0x0, 0x0, 0xF8, 0x16, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x3C, 0x8, 0x3A, 0x8, 0x38
	.byte 0x0, 0x0, 0x0, 0x0, 0x10, 0x18, 0x18, 0x18, 0x12, 0x18, 0x12
	.byte 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0
	.byte 0x4, 0xD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x19
	.byte 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x0, 0x12
	.byte 0x18, 0x19, 0x28, 0x14, 0xF4, 0x1E, 0x0, 0x14, 0x0, 0x0, 0x6
	.byte 0x8, 0x0, 0x10, 0x0, 0x0, 0x0, 0x0, 0xA, 0x46, 0xA, 0x40
	.byte 0xC, 0x40, 0x0, 0x0, 0x0, 0x0, 0xE, 0x2A, 0x18, 0x18, 0x12
	.byte 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18
	.byte 0x0, 0x0, 0x4, 0x14, 0x1A, 0x2A, 0x0, 0x0, 0xC, 0x2A, 0x0
	.byte 0x10, 0x19, 0x17, 0x18, 0x1A, 0x10, 0x28, 0x18, 0x1A, 0x1C, 0x19
	.byte 0x4, 0x14, 0x18, 0x19, 0x28, 0x14, 0xFC, 0x22, 0x0, 0x14, 0x0
	.byte 0x0, 0x8, 0x10, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x18, 0x18
	.byte 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18, 0x18, 0x18
	.byte 0x18, 0x18, 0x0, 0x0, 0x3C, 0x1B, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17, 0x18, 0x1A
	.byte 0x1C, 0x19, 0x0, 0x12, 0x18, 0x19, 0x28, 0x14, 0x0, 0x10, 0x0
	.byte 0x14, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10
	.byte 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18, 0x18, 0x18
	.byte 0x18, 0x18, 0x18, 0x18, 0x0, 0x0, 0xF0, 0xA, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x10, 0x19, 0x17, 0x18, 0x1A, 0x18, 0x17
	.byte 0x18, 0x1A, 0x1C, 0x19, 0x0, 0x12, 0x18, 0x19, 0x28, 0x14, 0x0
	.byte 0x10, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0, 0xFC, 0x18, 0xFC, 0x1E
	.byte 0xFC, 0x18, 0x0, 0x50, 0x0, 0x48, 0x0, 0x48, 0x10, 0x0, 0x0
	.byte 0x0, 0x10, 0x18, 0x18, 0x18, 0x12, 0x18, 0x12, 0x18, 0x12, 0x18
	.byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0, 0x0, 0x0, 0x20, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0xFC, 0x28, 0x19, 0x17, 0x18, 0x1A
	.byte 0x18, 0x17, 0x18, 0x1A, 0x1C, 0x19, 0x0, 0x28, 0x18, 0x19, 0x28
	.byte 0x14, 0xF8, 0x28, 0x0, 0x14, 0x0, 0x0, 0xF8, 0x16, 0x6, 0x0
	.byte 0x6, 0x0, 0x6, 0x0, 0x10, 0x2A, 0x10, 0x2C, 0x10, 0x2C, 0x18
	.byte 0x0, 0x1B, 0x11, 0x18, 0x11, 0x23, 0x11, 0x1D, 0x11, 0x1D, 0x11
	.byte 0x1D, 0x11, 0x23, 0x11, 0x23, 0x11, 0x23, 0x11, 0x30, 0x13, 0x8
	.byte 0x10, 0x23, 0x15, 0x30, 0x13, 0xFF, 0x1A, 0x6, 0x10, 0x20, 0x11
	.byte 0x20, 0x12, 0x20, 0x10, 0x23, 0x12, 0x24, 0x12, 0x8, 0x10, 0x23
	.byte 0x12, 0x30, 0x14, 0xF8, 0x18, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0
	.byte 0x4, 0x10, 0x4, 0x18, 0x4, 0x10, 0x8, 0x40, 0x8, 0x40, 0x8
	.byte 0x40, 0x10, 0x0, 0x10, 0x25, 0x10, 0x26, 0x18, 0x26, 0x11, 0x26
	.byte 0x12, 0x26, 0x12, 0x26, 0x18, 0x26, 0x18, 0x26, 0x18, 0x25, 0x28
	.byte 0x28, 0x4, 0x20, 0x18, 0x27, 0x28, 0x27, 0x12, 0x27, 0x4, 0x20
	.byte 0x18, 0x26, 0x16, 0x27, 0x18, 0x27, 0x18, 0x27, 0x19, 0x26, 0x4
	.byte 0x20, 0x18, 0x27, 0x28, 0x26, 0xF8, 0x1C, 0x0, 0x14, 0x0, 0x0
	.byte 0x0, 0x0
	thumb_func_end getAnmSeqRowIndexTableEntry_8018886

// symdb: Resets the collision system by clearing the active-collision bitfield, reinitializing all 32 collision data slots with unique one-hot index bits, and clearing the collision scratch buffer.
// symdb: void sub_801986C(void); // reads toolkit ptr from r10; preserves r2-r5 and r10; clobbers
// symdb: r0,r1,lr and NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/collision_resetAllHitData_801986C.yaml
	thumb_func_start collision_resetAllHitData_801986C
collision_resetAllHitData_801986C:
	push {r4,r5,lr}
	ldr r1, off_80198E4 // =eActiveCollisionDataBitfield 
	mov r0, #0
	str r0, [r1]
	mov r5, #1
	lsl r5, r5, #0x1f
	mov r4, r10
	ldr r4, [r4,#oToolkit_CollisionDataPtr]
loc_801987C:
	// memBlock
	mov r0, r4
	// size
	mov r1, #oCollisionData_Size
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	str r5, [r4,#oCollisionData_CollisionIndexBit]
	add r4, #oCollisionData_Size
	lsr r5, r5, #1
	bne loc_801987C
	bl clearScratchBuffer_2034F60_8019FA4
	pop {r4,r5,pc}
	thumb_func_end collision_resetAllHitData_801986C

// symdb: Allocates one of 32 collision-data slots for a battle object, zeroing it and linking it to the object.
// symdb: (u32 *bitfield not taken directly; r10 toolkit, r5 battle object) -> CollisionData *slot (r0; 0
// symdb: if none free)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_createCollisionData.yaml
	thumb_func_start object_createCollisionData
object_createCollisionData:
	push {r4,lr}
	mov r0, r10
	// memBlock
	ldr r0, [r0,#oToolkit_CollisionDataPtr]
	ldr r3, off_80198E4 // =eActiveCollisionDataBitfield 
	ldr r2, [r3]
	mov r1, #1
	lsl r1, r1, #0x1f
loc_80198A0:
	tst r2, r1
	beq loc_80198AE
	add r0, #0xa8
	lsr r1, r1, #1
	bne loc_80198A0
	mov r0, #0
	pop {r4,pc}
loc_80198AE:
	orr r2, r1
	str r2, [r3]
	mov r4, r0
	// size
	mov r1, #0x44
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #0x48
	// memBlock
	add r0, r0, r4
	// size
	mov r1, #0x60
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, r4
	mov r1, #1
	strb r1, [r0]
	str r0, [r5,#oBattleObject_CollisionDataPtr]
	pop {r4,pc}
	thumb_func_end object_createCollisionData

// symdb: Disables a collision data slot and clears its index bit in the engine-wide active-collision bitfield (NULL-safe).
// symdb: void object_freeCollisionData(struct CollisionData *r0); // r0 = collision data slot (NULL
// symdb: allowed); clobbers r1, r2, r3 and N/Z flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_freeCollisionData.yaml
	thumb_func_start object_freeCollisionData
object_freeCollisionData:
	tst r0, r0
	beq locret_80198E0
	mov r1, #0
	strb r1, [r0,#oCollisionData_Enabled]
	ldr r2, [r0,#oCollisionData_CollisionIndexBit]
	ldr r3, off_80198E4 // =eActiveCollisionDataBitfield 
	ldr r1, [r3]
	bic r1, r2
	str r1, [r3]
locret_80198E0:
	mov pc, lr
	.balign 4, 0
off_80198E4:
	.word eActiveCollisionDataBitfield
byte_80198E8:
	.byte 0x7F
byte_80198E9:
	.byte 0x0, 0x0, 0x7F
byte_80198EC:
	.byte 0x0, 0x0, 0x1, 0x0, 0x7F
byte_80198F1:
	.byte 0x1, 0x0, 0x7F
byte_80198F4:
	.byte 0x0, 0x0, 0x0, 0xFF, 0x0, 0x1, 0x7F
byte_80198FB:
	.byte 0x0, 0xFF, 0x0, 0x1, 0x7F
byte_8019900:
	.byte 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x7F
byte_8019907:
	.byte 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x3, 0x0, 0x7F
byte_8019910:
	.byte 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x3, 0x0, 0x4, 0x0, 0x5, 0x0, 0x7F
byte_801991D:
	.byte 0x0, 0x0, 0x0, 0xFF, 0x0, 0x1, 0x1, 0x0, 0xFF, 0x0, 0x7F
byte_8019928:
	.byte 0x0, 0xFF, 0x0, 0x1, 0x1, 0x0, 0xFF, 0x0, 0x7F
byte_8019931:
	.byte 0x0, 0x0, 0x1, 0xFF, 0xFF, 0x1, 0x1, 0x1, 0xFF, 0xFF, 0x7F
byte_801993C:
	.byte 0x1, 0xFF, 0xFF, 0x1, 0x1, 0x1, 0xFF, 0xFF, 0x7F
byte_8019945:
	.byte 0x0, 0x0, 0x1, 0xFF, 0x1, 0x1, 0x7F
byte_801994C:
	.byte 0x1, 0xFF, 0x1, 0x1, 0x7F
byte_8019951:
	.byte 0x0, 0x0, 0x0, 0xFF, 0x0, 0x1, 0x1, 0x0, 0xFF, 0x0, 0x1, 0xFF, 0xFF
	.byte 0x1, 0x1, 0x1, 0xFF, 0xFF, 0x7F
byte_8019964:
	.byte 0x0, 0xFF, 0x0, 0x1, 0x1, 0x0, 0xFF, 0x0, 0x1, 0xFF, 0xFF, 0x1, 0x1
	.byte 0x1, 0xFF, 0xFF, 0x7F
byte_8019975:
	.byte 0x0, 0x0, 0x0, 0xFF, 0x0, 0x1, 0x1, 0x0, 0x1, 0xFF, 0x1, 0x1, 0x7F
byte_8019982:
	.byte 0x0, 0x0, 0x1, 0xFF, 0xFF, 0x1, 0x7F
byte_8019989:
	.byte 0x0, 0x0, 0xFF, 0xFF, 0x1, 0x1, 0x7F
byte_8019990:
	.byte 0x0, 0x0, 0x0, 0xFF, 0x0, 0x1, 0x1, 0x0, 0x7F
byte_8019999:
	.byte 0x0, 0x0, 0x1, 0xFF, 0x1, 0x1, 0x1, 0x0, 0x7F
byte_80199A2:
	.byte 0x0, 0x0, 0x1, 0xFF, 0x7F
byte_80199A7:
	.byte 0x0, 0x0, 0x1, 0x1, 0x7F
byte_80199AC:
	.byte 0x0, 0x0, 0x0, 0xFF, 0x7F
byte_80199B1:
	.byte 0x0, 0x0, 0x0, 0x1, 0x7F
byte_80199B6:
	.byte 0x0, 0x0, 0x1, 0xFF, 0x1, 0x0, 0x1, 0x1, 0x2, 0xFF, 0x2, 0x0, 0x2, 0x1, 0x7F
byte_80199C5:
	.byte 0x0, 0x0, 0x1, 0xFF, 0x1, 0x0, 0x1, 0x1, 0x2, 0xFF, 0x2, 0x0, 0x2, 0x1, 0x3
	.byte 0xFF, 0x3, 0x0, 0x3, 0x1, 0x7F
byte_80199DA:
	.byte 0x0, 0x0, 0x1, 0xFF, 0x1, 0x0, 0x1, 0x1, 0x2, 0xFF, 0x2, 0x0, 0x2, 0x1, 0x3
	.byte 0xFF, 0x3, 0x0, 0x3, 0x1, 0x4, 0xFF, 0x4, 0x0, 0x4, 0x1, 0x7F
byte_80199F5:
	.byte 0x0, 0x0, 0x1, 0x0, 0xFF, 0x0, 0x7F
byte_80199FC:
	.byte 0x1, 0x0, 0xFF, 0x0, 0x7F
byte_8019A01:
	.byte 0x0, 0x0, 0xFF, 0xFF, 0xFF, 0x1, 0x7F
byte_8019A08:
	.byte 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x3, 0x0, 0x4, 0x0, 0x7F
byte_8019A13:
	.byte 0x0, 0x0, 0x0, 0xFF, 0x0, 0x1, 0x1, 0x0, 0x1, 0xFF, 0x1, 0x1, 0x2, 0x0, 0x2
	.byte 0xFF, 0x2, 0x1, 0x3, 0x0, 0x3, 0xFF, 0x3, 0x1, 0x7F
byte_8019A2C:
	.byte 0xFF, 0xFF, 0x0, 0xFF, 0x1, 0xFF, 0x0, 0x0, 0xFF, 0x1, 0x0, 0x1
	.byte 0x1, 0x1, 0x7F
byte_8019A3B:
	.byte 0x0, 0xFF, 0x1, 0xFF, 0x2, 0xFF, 0x3, 0xFF, 0x4, 0xFF, 0x5, 0xFF
	.byte 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x3, 0x0, 0x4, 0x0, 0x5, 0x0
	.byte 0x0, 0x1, 0x1, 0x1, 0x2, 0x1, 0x3, 0x1, 0x4, 0x1, 0x5, 0x1
	.byte 0x7F
byte_8019A60:
	.byte 0x0, 0xFF, 0x1, 0xFF, 0x2, 0xFF, 0xFF, 0x0, 0x0, 0x0, 0x1, 0x0, 0xFE
	.byte 0x1, 0xFF, 0x1, 0x0, 0x1, 0x7F
byte_8019A73:
	.byte 0xFE, 0xFF, 0xFF, 0xFF, 0x0, 0xFF, 0xFF, 0x0, 0x0, 0x0, 0x1
	.byte 0x0, 0x0, 0x1, 0x1, 0x1, 0x2, 0x1, 0x7F
byte_8019A86:
	.byte 0xFE, 0xFE, 0xFF, 0xFE, 0x0, 0xFE, 0x1, 0xFE, 0x2, 0xFE
	.byte 0xFE, 0xFF, 0xFF, 0xFF, 0x0, 0xFF, 0x1, 0xFF, 0x2, 0xFF
	.byte 0xFE, 0x0, 0xFF, 0x0, 0x0, 0x0, 0x1, 0x0, 0x2, 0x0
	.byte 0xFE, 0x1, 0xFF, 0x1, 0x0, 0x1, 0x1, 0x1, 0x2, 0x1
	.byte 0xFE, 0x2, 0xFF, 0x2, 0x0, 0x2, 0x1, 0x2, 0x2, 0x2
	.byte 0x7F
byte_8019AB9:
	.byte 0x0, 0xFF, 0x1, 0xFF, 0x2, 0xFF, 0x3, 0xFF, 0x4, 0xFF, 0x5, 0xFF
	.byte 0x5, 0x0, 0x0, 0x1, 0x1, 0x1, 0x2, 0x1, 0x3, 0x1, 0x4, 0x1
	.byte 0x5, 0x1, 0x7F
byte_8019AD4:
	.byte 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x2, 0xFF, 0x2, 0x1, 0x7F
byte_8019ADF:
	.byte 0x0, 0xFF, 0x1, 0xFF, 0x2, 0xFF, 0x1, 0x0, 0x0, 0x1, 0x1, 0x1, 0x2, 0x1
	.byte 0x7F
byte_8019AEE:
	.byte 0x0, 0xFF, 0x0, 0x1, 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x3, 0x0, 0x4, 0x0, 0x5, 0x0
	.byte 0x7F
byte_8019AFF:
	.byte 0x0, 0x0, 0xFF, 0x0, 0xFE, 0x0, 0x7F
byte_8019B06:
	.byte 0x5, 0xFE, 0x4, 0xFE, 0x3, 0xFE, 0x2, 0xFE, 0x1, 0xFE, 0x0, 0xFE
	.byte 0xFF, 0xFE, 0xFE, 0xFE, 0xFD, 0xFE, 0xFC, 0xFE, 0xFB, 0xFE, 0x5, 0x2
	.byte 0x4, 0x2, 0x3, 0x2, 0x2, 0x2, 0x1, 0x2, 0x0, 0x2, 0xFF, 0x2
	.byte 0xFE, 0x2, 0xFD, 0x2, 0xFC, 0x2, 0xFB, 0x2, 0x5, 0xFF, 0x4, 0xFF
	.byte 0x3, 0xFF, 0x2, 0xFF, 0xFE, 0xFF, 0xFD, 0xFF, 0xFC, 0xFF, 0xFB, 0xFF
	.byte 0x5, 0x1, 0x4, 0x1, 0x3, 0x1, 0x2, 0x1, 0xFE, 0x1, 0xFD, 0x1
	.byte 0xFC, 0x1, 0xFB, 0x1, 0x5, 0x0, 0x4, 0x0, 0x3, 0x0, 0x2, 0x0
	.byte 0xFE, 0x0, 0xFD, 0x0, 0xFC, 0x0, 0xFB, 0x0, 0x7F
byte_8019B63:
	.byte 0x0, 0x0, 0x0, 0xFE, 0x0, 0xFF, 0x0, 0x1, 0x0, 0x2, 0x7F
byte_8019B6E:
	.byte 0x0, 0xFE, 0x0, 0xFF, 0x0, 0x1, 0x0, 0x2, 0x7F
	.balign 4, 0
PanelOffsetListsPointerTable::
	.word byte_80198E8
	.word byte_80198E9
	.word byte_80198EC
	.word byte_80198F1
	.word byte_80198F4
	.word byte_80198FB
	.word byte_8019900
	.word byte_8019907
	.word byte_8019910
	.word byte_801991D
	.word byte_8019928
	.word byte_8019931
	.word byte_801993C
	.word byte_8019945
	.word byte_801994C
	.word byte_8019951
	.word byte_8019964
	.word byte_8019975
	.word byte_8019982
	.word byte_8019989
	.word byte_8019990
	.word byte_8019999
	.word byte_80199A2
	.word byte_80199A7
	.word byte_80199AC
	.word byte_80199B1
	.word byte_80199B6 // this specific value is (sort of) referenced directly
	.word byte_80199C5
	.word byte_80199DA
	.word byte_80199F5
	.word byte_80199FC
	.word byte_8019A01
	.word byte_8019A08
	.word byte_8019A13
	.word byte_8019A2C
	.word byte_8019A3B
	.word byte_8019A60
	.word byte_8019A73
	.word byte_8019A86
	.word byte_8019AB9
	.word byte_8019AD4
	.word byte_8019ADF
	.word byte_8019AEE
	.word byte_8019AFF
	.word byte_8019B06
	.word byte_8019B63
	.word byte_8019B6E
byte_8019C34::
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0, 0x0
	.byte 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x40, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x60, 0x0, 0x10, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0, 0x0
	.byte 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
byte_8019C7C:
	.word 0x0, 0x0
	.word 0x8410080, 0x4210080
	.word 0x55800200, 0xaa800200
	.word 0x51800100, 0xa2800100
	.word 0x80000080, 0x40000080
	.word 0x15800000, 0x2a800000
	.word 0x80000082, 0x40000082
	.word 0x80002080, 0x40002080
	.word 0x80000090, 0x40000090
	.word 0x80000180, 0x40000180
	.word 0x80000088, 0x40000088
	.word 0x80000084, 0x40000084
	.word 0x20010080, 0x10010080
	.word 0x55840000, 0xaa840000
	.word 0x810082, 0x810082
	.word 0xff800002, 0xff800002
	.word 0x8510080, 0x4310080
	.word 0x80002480, 0x40002480
	.word 0x80000880, 0x40000880
	.word 0x2010080, 0x1010080
	.word 0x55800000, 0xaa800000
	.word 0x8000008a, 0x4000008a
	.word 0x80000086, 0x40000086
	.word 0x8000008e, 0x4000008e
	.word 0x50000000, 0xa0000000
	.word 0x8000008c, 0x4000008c
	.word 0x8000009e, 0x4000009e
	.word 0x800040a0, 0x400040a0
	.word 0x80002088, 0x40002088
	.word 0x8000009c, 0x4000009c
	.word 0x4280, 0x4280
	.word 0x80040082, 0x40040082
	.word 0x80000888, 0x40000888
	.word 0x8004008a, 0x4004008a
	.word 0xc004808e, 0xc004808e
	.word 0x80000, 0x80000
	.word 0x80000c88, 0x40000c88
	.word 0x80000480, 0x40000480
	.word 0xc0040088, 0xc0040088
	.word 0xc0048082, 0xc0048082
	.word 0x80002086, 0x40002086
	.word 0x2010082, 0x1010082
	.word 0x3d800000, 0x3e800000
	.word 0x80000488, 0x40000488
	.word 0x8000408c, 0x4000408c
	.word 0x8000408a, 0x4000408a
	.word 0x80004086, 0x40004086
	.word 0x80004088, 0x40004088
	.word 0x8000408e, 0x4000408e
	.word 0x80005084, 0x40005084
	.word 0x80005080, 0x40005080
	.word 0xc004000e, 0xc004000e
	.word 0x80004084, 0x40004084
	.word 0x8410082, 0x4210082
	.word 0x80004082, 0x40004082
	.word 0x201008a, 0x101008a
	.word 0xf800000, 0xf800000
	.word 0x8510082, 0x4310082
	.word 0x841008a, 0x421008a
	.word 0x20010082, 0x10010082
	.word 0x8000408a, 0x4000408a
	.word 0x80, 0x80
	.word 0x2110080, 0x1110080
	.word 0x851008a, 0x431008a
	.word 0x20012080, 0x10012080
	.word 0x4000000, 0x8000000
	.word 0x80002090, 0x40002090
	.word 0x40080, 0x40080
	.word 0x20050080, 0x10050080
	.word 0x8000208a, 0x4000208a
	.word 0x800140a0, 0x400140a0
	.word 0x800000a0, 0x400000a0
	.word 0xc0040080, 0xc0040080
	.word 0x3f800000, 0x3f800000
	.word 0x80000482, 0x40000482
	.word 0x80000c88, 0x40000c88
	.word 0x2014082, 0x1014082
	.word 0x55000200, 0xaa000200
	.word 0x2010088, 0x1010088
	.word 0x81008a, 0x81008a
	.word 0x8412080, 0x4212080
	.word 0x8410092, 0x4210092
	.word 0x80001080, 0x40001080
	.word 0x8412082, 0x4212082
	.word 0x80002092, 0x40002092
	.word 0x841009a, 0x421009a
	.word 0x80000884, 0x40000884
	.word 0x800000b2, 0x400000b2
	.word 0xc0044080, 0xc0044080
	thumb_func_end object_freeCollisionData

// symdb: Applies SelfDamage flag bits to a battle object's CollisionData: clears/clamps SelfDamage, doubles it on DAMAGE_DOUBLE, sets status/hit modifiers on DAMAGE_PARALYZE/DAMAGE_UNINSTALL, and dispatches sub_801A4D0 for DAMAGE_ERASECROSS_SKULL_HIT/DAMAGE_NOTHING.
// symdb: (r0 = CollisionData* @0x02XXXXXX, r1 = ???) -> r0 = ??? ; side effects: mutates CollisionData
// symdb: fields SelfDamage (0x2e), StatusEffectBase (0x10), HitModifierBase (0x0e); calls sub_801A4D0.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/object_applySelfCollision_8019F44.yaml
	thumb_local_start
object_applySelfCollision_8019F44:
	push {r4,r6,r7,lr}
	mov r7, r0
	ldrh r4, [r7,#oCollisionData_SelfDamage]
	mov r0, r4
	lsl r0, r0, #0x15
	lsr r0, r0, #0x15
	strh r0, [r7,#oCollisionData_SelfDamage]
	lsl r4, r4, #0x11
	bcc loc_8019F5C
	ldrh r0, [r7,#oCollisionData_SelfDamage]
	add r0, r0, r0
	strh r0, [r7,#oCollisionData_SelfDamage]
loc_8019F5C:
	lsl r4, r4, #1
	bcc loc_8019F68
	mov r0, #0x10
	strb r0, [r7,#oCollisionData_StatusEffectBase]
	mov r0, #1
	strb r0, [r7,#oCollisionData_HitModifierBase]
loc_8019F68:
	lsl r4, r4, #1
	bcc loc_8019F74
	mov r0, #0xf8
	bl sub_801A4D0
	pop {r4,r6,r7,pc}
loc_8019F74:
	lsl r4, r4, #1
	bcc loc_8019F80
	mov r0, #0xf7
	bl sub_801A4D0
	bcc loc_8019F80
loc_8019F80:
	lsl r4, r4, #1
	bcc locret_8019F84
locret_8019F84:
	pop {r4,r6,r7,pc}
	thumb_func_end object_applySelfCollision_8019F44

// symdb: Stores a hit modifier value into a battle object's collision data and returns the collision data pointer.
// symdb: u32* battle_SetObjectHitModifier(u8 hitModifier /* r0 */, BattleObject* obj /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_SetObjectHitModifier_8019F86.yaml
	thumb_func_start battle_SetObjectHitModifier_8019F86
battle_SetObjectHitModifier_8019F86:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r1,#oCollisionData_HitModifierBase]
	mov pc, lr
	thumb_func_end battle_SetObjectHitModifier_8019F86

// symdb: Writes a packed-elements byte into both BattleObject.Element and CollisionData.{PrimaryElement,SecondaryElement}, splitting the low/high nibbles.
// symdb: (r0 = packed element byte, r5 = *BattleObject) -> side effects only; r2 clobbered to 0
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_setElement_8019F8C.yaml
	thumb_func_start battleObject_setElement_8019F8C
battleObject_setElement_8019F8C:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r5,#oBattleObject_Element]
	mov r2, #0xf
	and r2, r0
	strb r2, [r1,#oCollisionData_PrimaryElement]
	mov r2, #0xf0
	and r0, r2
	strb r0, [r1,#oCollisionData_SecondaryElement]
	mov pc, lr
	thumb_func_end battleObject_setElement_8019F8C

// symdb: Sets the secondary element weakness of a battle object's collision data.
// symdb: void battleObject_SetSecondaryElementWeakness(battleObject_t* obj /* r5 */, u8 element /* r0 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObject_SetSecondaryElementWeakness_8019F9E.yaml
	thumb_local_start
battleObject_SetSecondaryElementWeakness_8019F9E:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r1,#oCollisionData_SecondaryElementWeakness]
	mov pc, lr
	thumb_func_end battleObject_SetSecondaryElementWeakness_8019F9E

// symdb: Zero-fills the 0xA0-byte scratch buffer at 0x2034F60, leaving r2/r3 untouched for the caller.
// symdb: (void) -> void; inputs r2, r3 (preserved verbatim), lr; outputs r2 (passed back through);
// symdb: clobbers r0, r1, lr, flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/clearScratchBuffer_2034F60_8019FA4.yaml
	thumb_local_start
clearScratchBuffer_2034F60_8019FA4:
	push {lr}
	// memBlock
	ldr r0, off_8019FB0 // =unk_2034F60 
	// size
	mov r1, #0xa0
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	.balign 4, 0
off_8019FB0:
	.word unk_2034F60
	thumb_func_end clearScratchBuffer_2034F60_8019FA4

/* r0 = collision data offset
   r1 = self collision type
   r2 = target collision type
   r3 = collision modifier*/
// symdb: Initializes a battle object's collision-data block from its parent object, resolves self/target collision-type flag tables, applies a time-stop bit, and finalizes via sub_8019F44.
// symdb: void object_setupCollisionData(u32 outCollisionPtr, u32 selfTableIdx, u32 targetTableIdx, u8
// symdb: hitModifierBase /* r3 */, u32 parentBattleObject /* r5 */, u32 unused_r10) -> {u32 r0, u32 r1,
// symdb: u32 r6} (clobbers r3, lr, flags NZCV)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_setupCollisionData.yaml
	thumb_func_start object_setupCollisionData
object_setupCollisionData:
	push {r4,r7,lr}
	mov r7, r0
	str r5, [r7,#oCollisionData_ParentObjectPtr]
	strb r3, [r7,#oCollisionData_HitModifierBase]
	ldrb r3, [r5,#oBattleObject_Element]
	mov r4, #0xf
	and r4, r3
	strb r4, [r7,#oCollisionData_PrimaryElement]
	mov r4, #0xf0
	and r3, r4
	strb r3, [r7,#oCollisionData_SecondaryElement]
	ldrh r4, [r5,#oBattleObject_AllianceAndDirectionFlip]
	strh r4, [r7,#oCollisionData_AllianceAndDirectionFlip]
	lsl r4, r4, #2
	ldrh r3, [r5,#oBattleObject_PanelXY]
	strh r3, [r7,#oCollisionData_PanelXY]
	mov r3, #1
	strb r3, [r7,#oCollisionData_Region]
	ldrh r3, [r5,#oBattleObject_StaminaDamageCounterDisabler]
	strb r3, [r7,#oCollisionData_StaminaDamageCounterDisabler]
	ldrh r3, [r5,#oBattleObject_Damage]
	strh r3, [r7,#oCollisionData_SelfDamage]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r4, r2
	bl object_getTableEntry_801A0BA
	str r0, [r7,#oCollisionData_SelfCollisionTypeFlags]
	bl battle_isTimeStop
	tst r0, r0
	beq loc_8019FFC
	mov r1, #1
	lsl r1, r1, #0x10
	ldr r2, [r7,#oCollisionData_SelfCollisionTypeFlags]
	orr r2, r1
	str r2, [r7,#oCollisionData_SelfCollisionTypeFlags]
loc_8019FFC:
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, r4
	bl object_getTableEntry_801A0BA
	str r0, [r7,#oCollisionData_TargetCollisionTypeFlags]
	mov r0, r7
	bl object_applySelfCollision_8019F44
	pop {r4,r7,pc}
	thumb_func_end object_setupCollisionData

// symdb: THUMB trampoline that tail-invokes the ARM helper _object_removeCollisionData to tear down an object's collision data.
// symdb: void object_removeCollisionData(void) — arguments passed implicitly in r4-r7 and r10; returns
// symdb: results in r1-r3 and the nzcv flags; r4-r7 preserved, r0/r1-r3/lr clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_removeCollisionData.yaml
	thumb_func_start object_removeCollisionData
object_removeCollisionData:
	push {r4-r7,lr}
	ldr r0, off_801A0C8 // =_object_removeCollisionData+1 
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	thumb_func_end object_removeCollisionData

// symdb: Refreshes a battle object's collision state for the current frame while it is present in a collision, clearing one-shot hit/status data (unless time is stopped) and then running the shared collision handler.
// symdb: void object_presentCollisionData(void) // r5 = battle object, r1 = new collision flags, r3 =
// symdb: context for the collision handler; preserves r4-r7, returns r0-r3 as left by object_updateCollisionPanels_300777C
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_presentCollisionData.yaml
	thumb_func_start object_presentCollisionData
object_presentCollisionData:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	ldr r2, [r4,#oCollisionData_FlagsFromCollision]
	ldr r0, [r4,#oCollisionData_Unk_54]
	orr r0, r2
	str r1, [r4,#oCollisionData_Unk_54]
	bl battle_isTimeStop
	tst r0, r0
	bne loc_801A034
	mov r0, #0
	strb r0, [r4,#oCollisionData_HitModifierFinal]
	strb r0, [r4,#oCollisionData_Unk_03]
	str r0, [r4,#oCollisionData_Unk_54]
loc_801A034:
	mov r1, #0
	strb r1, [r4,#oCollisionData_StatusEffectFinal]
	mov r0, #0x68 
	add r0, r0, r4
	mov r1, #0x40 
	bl ZeroFillByHalfword
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	ldr r3, off_801A0CC // =object_updateCollisionPanels_300777C+1 
	mov lr, pc
	bx r3
	pop {r4,pc}
	thumb_func_end object_presentCollisionData

// symdb: Syncs a battle object's panel position into its collision record and recomputes its facing direction for the move.
// symdb: void object_updateCollisionPanels(/* r5 */ BattleObject* obj)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_updateCollisionPanels.yaml
	thumb_func_start object_updateCollisionPanels
object_updateCollisionPanels:
	push {r4,r6,lr}
	ldr r6, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r2, [r6,#oCollisionData_PanelX]
	ldrb r3, [r6,#oCollisionData_PanelY]
	ldrb r0, [r5,#oBattleObject_PanelX]
	strb r0, [r6,#oCollisionData_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	strb r1, [r6,#oCollisionData_PanelY]
	ldrb r4, [r5,#oBattleObject_Alliance]
	bl sub_800E994
	strb r0, [r6,#oCollisionData_Direction]
	pop {r4,r6,pc}
	thumb_func_end object_updateCollisionPanels

// symdb: Copies a battle object's current panel X/Y coordinates into its collision data record.
// symdb: void object_syncCollisionDataPanelPos(BattleObject* obj /* r5 */); clobbers r0-r2, preserves r4
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_setCollisionPanelsToCurrent.yaml
	thumb_func_start object_setCollisionPanelsToCurrent
object_setCollisionPanelsToCurrent:
	push {r4,lr}
	ldr r2, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r5,#oBattleObject_PanelX]
	strb r0, [r2,#oCollisionData_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	strb r1, [r2,#oCollisionData_PanelY]
	pop {r4,pc}
	thumb_func_end object_setCollisionPanelsToCurrent

// () -> void
// symdb: Clears a battle object's collision region byte, effectively removing it from its current collision region.
// symdb: void object_clearCollisionRegion(struct BattleObject* object /* r5 */) /* returns r0 =
// symdb: object->collisionDataPtr, r1 = 0, flags NZ from r1 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_clearCollisionRegion.yaml
	thumb_func_start object_clearCollisionRegion
object_clearCollisionRegion:
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0
	strb r1, [r0,#oCollisionData_Region]
	mov pc, lr
	thumb_func_end object_clearCollisionRegion

// symdb: Stores a region index byte into a battle object's collision data and returns the collision data pointer.
// symdb: void object_setCollisionRegion(u8 region /* r0 */, struct BattleObject* obj /* r5 */) -> struct
// symdb: CollisionData* /* r1 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_setCollisionRegion.yaml
	thumb_func_start object_setCollisionRegion
object_setCollisionRegion:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r1,#oCollisionData_Region]
	mov pc, lr
	thumb_func_end object_setCollisionRegion

// symdb: Refreshes a battle object's collision record (hit modifier, pending damage, both sides' collision type flags) and re-evaluates it, marking bit 16 while time is stopped.
// symdb: void object_updateCollisionData(u32 ownElement /*r1*/, u32 otherElement /*r2*/, u8 hitModifier
// symdb: /*r3*/, BattleObject* obj /*r5*/); clobbers r0-r3,r6,r7(saved),lr; sets nz cv from
// symdb: battle_isTimeStop path
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/object_updateCollisionData.yaml
	thumb_func_start object_updateCollisionData
object_updateCollisionData:
	push {r4,r7,lr}
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	strb r3, [r7,#oCollisionData_HitModifierBase]
	ldrh r3, [r5,#oBattleObject_Damage]
	strh r3, [r7,#oCollisionData_SelfDamage]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r4, r2
	bl object_getTableEntry_801A0BA
	str r0, [r7,#oCollisionData_SelfCollisionTypeFlags]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, r4
	bl object_getTableEntry_801A0BA
	str r0, [r7,#oCollisionData_TargetCollisionTypeFlags]
	bl battle_isTimeStop
	tst r0, r0
	beq loc_801A0B2
	mov r1, #1
	lsl r1, r1, #0x10
	ldr r2, [r7,#oCollisionData_SelfCollisionTypeFlags]
	orr r2, r1
	str r2, [r7,#oCollisionData_SelfCollisionTypeFlags]
loc_801A0B2:
	mov r0, r7
	bl object_applySelfCollision_8019F44
	pop {r4,r7,pc}
	thumb_func_end object_updateCollisionData

// symdb: Reads a 32-bit entry (likely a handler/function pointer) from the two-dimensional lookup table at byte_8019C7C using a row/column index pair.
// symdb: u32 object_getTableEntry(u32 column /*r0*/, u32 row /*r1*/); returns the table entry in r0; also
// symdb: leaves r1 = byte offset of the entry within the table, r3 = table base, and C/V set as if by ADD
// symdb: r1, r1, r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_getTableEntry_801A0BA.yaml
	thumb_local_start
object_getTableEntry_801A0BA:
	lsl r0, r0, #2
	ldr r3, off_801A0D0 // =byte_8019C7C
	lsl r1, r1, #3
	add r1, r1, r0
	ldr r0, [r3,r1]
	mov pc, lr
	.balign 4, 0x00
off_801A0C8:
	.word _object_removeCollisionData+1
off_801A0CC:
	.word object_updateCollisionPanels_300777C+1
off_801A0D0:
	.word byte_8019C7C
	thumb_func_end object_getTableEntry_801A0BA

	thumb_func_start object_spawnCollisionEffect
object_spawnCollisionEffect:
	push {r4,r6,lr}
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldr r6, [r3,#oCollisionData_FlagsFromCollision]
	ldr r1, dword_801A13C // =0x3f800000 
	tst r6, r1
	beq locret_801A0FE
	mov r1, #1
	tst r6, r1
	bne locret_801A0FE
	ldrb r0, [r3,#oCollisionData_HitEffect]
	cmp r0, #0xff
	beq locret_801A0FE
	mov r4, r0
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r0, #0xf
	bl AddRandomVarianceToTwoCoords
	bl object_spawnRelatedChildEffect_80E08C4
locret_801A0FE:
	pop {r4,r6,pc}
	thumb_func_end object_spawnCollisionEffect

// symdb: Spawns the visual hit-effect child object at the panel the battle object currently occupies, jittered around the panel center.
// symdb: (r5 = BattleObject*) -> r0 = 0x2 (seldomly read) ; side effects: may spawn a child effect object
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_spawnHitEffectAtPanel_801A100.yaml
	thumb_func_start battleObject_spawnHitEffectAtPanel_801A100
battleObject_spawnHitEffectAtPanel_801A100:
	push {r4,r6,lr}
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldr r6, [r3,#oCollisionData_FlagsFromCollision]
	ldr r1, dword_801A13C // =0x3f800000 
	tst r6, r1
	beq locret_801A138
	mov r1, #1
	tst r6, r1
	bne locret_801A138
	ldrb r0, [r3,#oCollisionData_HitEffect]
	cmp r0, #0xff
	beq locret_801A138
	mov r4, r0
	ldr r0, [r5,#oBattleObject_X]
	ldr r1, [r5,#oBattleObject_Y]
	bl convertXYToPanelXY_800E258
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	mov r2, r1
	mov r1, r0
	mov r3, #0x10
	lsl r3, r3, #0x10
	mov r0, #0xf
	bl AddRandomVarianceToTwoCoords
	bl object_spawnRelatedChildEffect_80E08C4
locret_801A138:
	pop {r4,r6,pc}
	.balign 4, 0
dword_801A13C:
	.word 0x3F800000
	thumb_func_end battleObject_spawnHitEffectAtPanel_801A100

// symdb: Stores the hit-effect type (e.g. what visual/effect kind a collision hit produces) into a battle object's collision data.
// symdb: void object_setCollisionHitEffect(u8 hitEffect /*r0*/, struct BattleObject* obj /*r5*/); returns
// symdb: r3 = obj->CollisionDataPtr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_setCollisionHitEffect.yaml
	thumb_func_start object_setCollisionHitEffect
object_setCollisionHitEffect:
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r3,#oCollisionData_HitEffect]
	mov pc, lr
	thumb_func_end object_setCollisionHitEffect

	thumb_func_start sub_801A146
sub_801A146:
	ldrb r0, [r5,#oBattleObject_Element]
	mov r3, #0xf
	and r0, r3
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r3,#oCollisionData_HitEffect]
	mov pc, lr
	thumb_func_end sub_801A146

// (int a1) -> void
// symdb: ORs the given flag bits into a battle object's CollisionData ObjectFlags1 word.
// symdb: void object_setFlag1(uint32 flags /* r0 */, BattleObject *obj /* r5 */); returns r1 =
// symdb: CollisionData pointer, r2 = updated ObjectFlags1, sets NZ from the result
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_setFlag1.yaml
	thumb_func_start object_setFlag1
object_setFlag1:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	ldr r2, [r1,#oCollisionData_ObjectFlags1]
	orr r2, r0
	str r2, [r1,#oCollisionData_ObjectFlags1]
	mov pc, lr
	thumb_func_end object_setFlag1

// (int bitfield) -> void
// symdb: Clears the given bit(s) of a battle object's ObjectFlags1 in its collision data.
// symdb: void object_clearFlag(u32 flagMask r0, BattleObject *obj r5); returns r1 = collision data ptr,
// symdb: r2 = updated flags; NZ from updated flags; lr used as return address
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_clearFlag.yaml
	thumb_func_start object_clearFlag
object_clearFlag:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	ldr r2, [r1,#oCollisionData_ObjectFlags1]
	bic r2, r0
	str r2, [r1,#oCollisionData_ObjectFlags1]
	mov pc, lr
	thumb_func_end object_clearFlag

// () -> int
// symdb: Returns the first object-flag word from a battle object's collision data.
// symdb: (r5 = battle object*) -> Next /* r0 = collision data ObjectFlags1 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_getFlag.yaml
	thumb_func_start object_getFlag
object_getFlag:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	ldr r0, [r1,#oCollisionData_ObjectFlags1]
	mov pc, lr
	thumb_func_end object_getFlag

// symdb: Sets the given bits in a battle object's "flags 2" word inside its collision data.
// symdb: void object_setFlag2(u32 flagBits r0, BattleObject *obj r5); returns collision-data pointer in
// symdb: r1 and the new flags in r2, with NZ set from the updated flags.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_setFlag2.yaml
	thumb_func_start object_setFlag2
object_setFlag2:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	ldr r2, [r1,#oCollisionData_ObjectFlags2]
	orr r2, r0
	str r2, [r1,#oCollisionData_ObjectFlags2]
	mov pc, lr
	thumb_func_end object_setFlag2

// symdb: Clears caller-specified bits in a battle object's ObjectFlags2 collision flag field.
// symdb: void object_clearObjectFlags2(u32 flagBits /* r0 */, BattleObject* obj /* r5 */); returns r1 =
// symdb: collision data ptr, r2 = updated flags, NZ set from updated flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_clearFlag2.yaml
	thumb_func_start object_clearFlag2
object_clearFlag2:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	ldr r2, [r1,#oCollisionData_ObjectFlags2]
	bic r2, r0
	str r2, [r1,#oCollisionData_ObjectFlags2]
	mov pc, lr
	thumb_func_end object_clearFlag2

// symdb: Returns the ObjectFlags2 word from a battle object's collision data.
// symdb: int object_getFlag2(void *obj /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_getFlag2.yaml
	thumb_func_start object_getFlag2
object_getFlag2:
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	ldr r0, [r1,#oCollisionData_ObjectFlags2]
	mov pc, lr
	thumb_func_end object_getFlag2

// symdb: Ticks the per-object poison-panel timer on the current battle object and heals +1 HP per tick when standing on a Holy Panel (panel type 6, element Wood=4) outside of pause/time-stop.
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> r0 = 2 (constant return after `bl battle_isTimeStop`
// symdb: falls through) ; side effects: writes to oCollisionData_PoisonPanelTimer and the halfword at
// symdb: oBattleObject+0x8c, may call object_addHP(1)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/object_updatePoisonPanelStatus_801A186.yaml
	thumb_local_start
object_updatePoisonPanelStatus_801A186:
	push {r7,lr}
	bl battle_isTimeStop
	bne locret_801A1FA
	bl battle_isPaused
	bne locret_801A1FA
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r7,#oCollisionData_Region]
	cmp r0, #0
	beq locret_801A1FA
	ldrb r0, [r7,#oCollisionData_PanelX]
	ldrb r1, [r7,#oCollisionData_PanelY]
	bl object_getPanelDataOffset
	tst r0, r0
	beq locret_801A1FA
	ldrb r0, [r0,#oPanelData_Type]
	cmp r0, #4
	bne loc_801A1CE
	bl object_getFlag // () -> int
	ldr r1, dword_801A1FC // =GameHeader
	tst r0, r1
	bne loc_801A1CE
	ldrb r0, [r7,#oCollisionData_PoisonPanelTimer]
	sub r0, #1
	strb r0, [r7,#oCollisionData_PoisonPanelTimer]
	bge locret_801A1FA
	mov r0, #6
	strb r0, [r7,#oCollisionData_PoisonPanelTimer]
	mov r1, #0x8c
	ldrh r0, [r7,r1]
	add r0, #1
	strh r0, [r7,r1]
	pop {r7,pc}
loc_801A1CE:
	mov r1, #0
	strb r1, [r7,#oCollisionData_PoisonPanelTimer]
	cmp r0, #6
	bne locret_801A1FA
	ldrb r0, [r5,#oBattleObject_Element]
	mov r1, #0xf
	and r0, r1
	cmp r0, #4
	bne locret_801A1FA
	mov r2, r10
	ldr r2, [r2,#oToolkit_BattleStatePtr]
	ldrb r0, [r2,#oBattleState_Unk_0e]
	ldrh r1, [r5,#oBattleObject_HP]
	cmp r1, #9
	bgt loc_801A1EE
	ldrb r0, [r2,#oBattleState_Unk_16]
loc_801A1EE:
	tst r0, r0
	bne locret_801A1FA
	mov r0, #1
	bl object_addHP
	pop {r7,pc}
locret_801A1FA:
	pop {r7,pc}
	.balign 4, 0
dword_801A1FC:
	.word 0x8000028
	thumb_func_end object_updatePoisonPanelStatus_801A186

// symdb: Handles a battle-object collision event, clearing a "damage" state and lowering the Navi's mood on the opposing side.
// symdb: (r5 = attacker BattleObjectPtr, r10 = ToolkitPtr) -> void ; no return value (clobbers
// symdb: r2,r3,r4,r5,r6; leaves flags undefined)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_onCollision_801A200.yaml
	thumb_local_start
battleObject_onCollision_801A200:
	push {r4,r6,lr}
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801A256
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	mov r2, #0x90
	ldrh r1, [r4,r2]
	tst r1, r1
	beq loc_801A24C
	ldr r2, dword_801A524 // =0x8000 
	tst r1, r2
	beq loc_801A24C
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r2, #1
	eor r0, r2
	mov r6, r0
	mov r1, #oNaviStats_Transformation
	bl GetBattleNaviStatsByte
	mov r2, r0
	cmp r2, #0
	beq loc_801A236
	cmp r2, #0xb
	beq loc_801A236
	cmp r2, #0xc
	bne loc_801A24C
loc_801A236:
	bl battle_aiAIDataUnk32IsZero_801445C
	bne loc_801A24C
	bl battle_checkAIDataUnk36IsNonZero_8014490
	bne loc_801A24C
	mov r0, r6
	mov r1, #0xff
	bl battle_setPlayerNaviStatsField0E_8015BEC
	b loc_801A24C
loc_801A24C:
	mov r1, #0x8e
	ldrh r1, [r4,r1]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl navi_DecreaseMood_8015C12
locret_801A256:
	pop {r4,r6,pc}
	thumb_func_end battleObject_onCollision_801A200

// symdb: Writes a status-effect base value into the collision data of a battle object.
// symdb: void object_setCollisionStatusEffect1(u8 statusEffectBase /* r0 */, struct BattleObject* obj /*
// symdb: r5 */); returns the collision-data pointer in r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_setCollisionStatusEffect1.yaml
	thumb_func_start object_setCollisionStatusEffect1
object_setCollisionStatusEffect1:
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r3,#oCollisionData_StatusEffectBase]
	mov pc, lr
	thumb_func_end object_setCollisionStatusEffect1

	thumb_local_start
object_setCollisionStatusEffect2:
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r3,#oCollisionData_StatusEffectFinal]
	mov pc, lr
	thumb_func_end object_setCollisionStatusEffect2

// symdb: Clears a battle object's status/affliction flags in both flag words and zeroes all of its collision status timers (blind, etc.).
// symdb: void sub_801A264(BattleObject* r5); /* sets r0=0 and Z on return; clobbers r0-r3, lr */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_clearObjectStatusFlagsAndTimers_801A264.yaml
	thumb_func_start battle_clearObjectStatusFlagsAndTimers_801A264
battle_clearObjectStatusFlagsAndTimers_801A264:
	push {lr}
	ldr r0, dword_801A528 // =0x8001e800 
	bl object_clearFlag // (int bitfield) -> void
	ldr r0, dword_801A52C // =0x300e8 
	bl object_clearFlag2
	mov r0, #0
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r3,#oCollisionData_Unk_1c]
	strh r0, [r3,#oCollisionData_Unk_1e]
	strh r0, [r3,#oCollisionData_BlindTimer]
	strh r0, [r3,#oCollisionData_Unk_22]
	strh r0, [r3,#oCollisionData_Unk_2a]
	strh r0, [r3,#oCollisionData_Unk_2c]
	pop {pc}
	thumb_func_end battle_clearObjectStatusFlagsAndTimers_801A264

// symdb: Clears a battle object's 0x800 status flag and secondary flag 8, then zeroes a halfword in its collision data (likely a hit/interaction counter).
// symdb: void battle_object_clearFlagsAndCollisionCounter(BattleObject* obj /* r5 */); returns collision
// symdb: pointer in r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_object_clearFlagsAndCollisionCounter_801A284.yaml
	thumb_func_start battle_object_clearFlagsAndCollisionCounter_801A284
battle_object_clearFlagsAndCollisionCounter_801A284:
	push {lr}
	ldr r0, off_801A530 // =0x800 
	bl object_clearFlag // (int bitfield) -> void
	mov r0, #8
	bl object_clearFlag2
	mov r0, #0
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r3,#oCollisionData_Unk_1c]
	pop {pc}
	thumb_func_end battle_object_clearFlagsAndCollisionCounter_801A284

// symdb: Clears the object's hit/flinch flag bits (0x10000 in both flag words) and resets a collision-data halfword, ending the object's current hit state.
// symdb: void battleObject_clearHitFlags(BattleObject *obj /* r5 */); clobbers r0-r3, sets NZ from r0
// symdb: (=0)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObject_clearHitFlags_801A29A.yaml
	thumb_func_start battleObject_clearHitFlags_801A29A
battleObject_clearHitFlags_801A29A:
	push {lr}
	ldr r0, dword_801A534 // =0x10000 
	bl object_clearFlag // (int bitfield) -> void
	ldr r0, dword_801A534 // =0x10000 
	bl object_clearFlag2
	mov r0, #0
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r3,#oCollisionData_Unk_2a]
	pop {pc}
	thumb_func_end battleObject_clearHitFlags_801A29A

// symdb: Clears a battle object's active-collision state, resetting its flags, collision timer, and restoring its Z position from its AI data block.
// symdb: void battleObject_resetCollisionState(r5 = battle object); // lr in, clobbers r0/lr/nz; contract
// symdb: says callers read back r1-r3 (r3 = collision data pointer, r1/r2 unmodeled)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObject_resetCollisionState_801A2B0.yaml
	thumb_func_start battleObject_resetCollisionState_801A2B0
battleObject_resetCollisionState_801A2B0:
	push {lr}
	ldr r0, dword_801A538 // =0x80000000 
	bl object_clearFlag // (int bitfield) -> void
	ldr r0, dword_801A53C // =0x20000 
	bl object_clearFlag2
	mov r0, #0
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	strh r0, [r3,#oCollisionData_Unk_2c]
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r0,#oAIData_Unk_3c]
	strh r0, [r5,#oBattleObject_Z16]
	pop {pc}
	thumb_func_end battleObject_resetCollisionState_801A2B0

// symdb: Clears the queue/Chip field of a BattleObject when its CollisionData FlagsFromCollision has bit 0x10 set; if the actor is a PLAYER it also pops a slot back into the hand.
// symdb: (r5 = *BattleObject) -> ; side effects — writes r5->Chip = 0xFFFF and ChipsHeld = 0, and on the
// symdb: PLAYER branch increments the hand slot's count, popping the chip back to the battle hand.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_clearChipSelectionOnAirShoe_801A2CC.yaml
	thumb_local_start
battleObject_clearChipSelectionOnAirShoe_801A2CC:
	push {lr}
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldr r0, [r3,#oCollisionData_FlagsFromCollision]
	mov r1, #0x10
	tst r0, r1
	beq locret_801A306
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	ldrb r1, [r0,#oAIData_ActorType]
	cmp r1, #2
	beq loc_801A2EA
	ldr r0, dword_801A540 // =0xffff 
	strh r0, [r5,#oBattleObject_Chip]
	mov r0, #0
	strb r0, [r5,#oBattleObject_ChipsHeld]
	pop {pc}
loc_801A2EA:
	ldr r0, dword_801A540 // =0xffff 
	strh r0, [r5,#oBattleObject_Chip]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getBattleHandAddr_8010018
	ldrb r1, [r0]
	lsl r2, r1, #1
	add r2, #2
	ldrh r2, [r0,r2]
	ldr r3, dword_801A540 // =0xffff 
	cmp r2, r3
	beq locret_801A306
	add r1, #1
	strb r1, [r0]
locret_801A306:
	pop {pc}
	thumb_func_end battleObject_clearChipSelectionOnAirShoe_801A2CC

// symdb: Flips a battle object's alliance to the opposite side, then adds its collision-data halfword at +0x92 into that side's AI data byte oAIData_Unk_10.
// symdb: void battle_toggleAllianceAndAccumulateCollisionToAiData(BattleObject* object /* r5 */); also
// symdb: saves/restores r4; no meaningful return value
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_toggleAllianceAndAccumulateCollisionToAiData_801A308.yaml
	thumb_local_start
battle_toggleAllianceAndAccumulateCollisionToAiData_801A308:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	bl battle_getPlayerAIData_8010022
	mov r4, r0
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	mov r2, #0x92
	ldrh r0, [r3,r2]
	ldrb r1, [r4,#oAIData_Unk_10]
	add r1, r1, r0
	strb r1, [r4,#oAIData_Unk_10]
	pop {r4,pc}
	thumb_func_end battle_toggleAllianceAndAccumulateCollisionToAiData_801A308

// symdb: Heal the opposing battle actor by the counter-damage stored in their AIData Unk_10, then spawn a +HP effect object and play the heal sound.
// symdb: (r5 = self BattleObjectPtr) -> (r5/r10 preserved; no return value)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_applyCounterHealAndSpawnEffect_801A324.yaml
	thumb_local_start
battle_applyCounterHealAndSpawnEffect_801A324:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	bl battle_getPlayerAIData_8010022
	mov r4, r0
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	mov r2, #0x92
	ldrh r0, [r3,r2]
	ldrb r1, [r4,#oAIData_Unk_10]
	add r1, r1, r0
	strb r1, [r4,#oAIData_Unk_10]
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldrb r4, [r3,#oAIData_Unk_10]
	mov r0, #0
	strb r0, [r3,#oAIData_Unk_10]
	ldrh r0, [r5,#oBattleObject_MaxHP]
	mov r1, #0xa
	svc 6
	mul r0, r4
	tst r0, r0
	beq locret_801A368
	bl object_addHP
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #6
	bl spawn_t1_0x0_EffectObject
	mov r0, #SOUND_UNK_8A
	bl PlaySoundEffect
locret_801A368:
	pop {r4,pc}
	thumb_func_end battle_applyCounterHealAndSpawnEffect_801A324

// symdb: Decrements an AIData ice-freeze counter and clears the object's frozen/immobilized flags when it expires on a cracked panel.
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> void
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/object_tickIcePanelFreeze_801A36A.yaml
	thumb_local_start
object_tickIcePanelFreeze_801A36A:
	push {r4,r7,lr}
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_isPaused
	bne loc_801A38A
	bl battle_isTimeStop
	bne loc_801A38A
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	ldrh r0, [r1,#oAIData_Unk_38]
	tst r0, r0
	beq loc_801A38A
	sub r0, #1
	strh r0, [r1,#oAIData_Unk_38]
	bgt loc_801A38A
	b loc_801A3B8
loc_801A38A:
	bl object_getFlag // () -> int
	ldr r1, dword_801A544 // =0x100040 
	tst r0, r1
	bne locret_801A3D8
	ldrb r0, [r7,#oCollisionData_PanelX]
	ldrb r1, [r7,#oCollisionData_PanelY]
	bl object_getPanelDataOffset
	ldrb r1, [r0,#oPanelData_Type]
	cmp r1, #9
	blt loc_801A3AC
	cmp r1, #0xc
	bgt loc_801A3AC
	bl sub_801A400
	pop {r4,r7,pc}
loc_801A3AC:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x13
	tst r0, r1
	beq locret_801A3D8
loc_801A3B8:
	mov r0, #1
	lsl r0, r0, #0x13
	bl object_clearFlag // (int bitfield) -> void
	ldrb r0, [r7,#oCollisionData_PanelX]
	ldrb r1, [r7,#oCollisionData_PanelY]
	bl object_getPanelDataOffset
	tst r0, r0
	beq locret_801A3D8
	ldrb r1, [r0,#oPanelData_Type]
	cmp r1, #7
	bne locret_801A3D8
	bl sub_801A3DA
	pop {r4,r7,pc}
locret_801A3D8:
	pop {r4,r7,pc}
	thumb_func_end object_tickIcePanelFreeze_801A36A

	thumb_local_start
sub_801A3DA:
	push {r7,lr}
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r7,#oCollisionData_PrimaryElement]
	cmp r0, #2
	beq locret_801A3FE
	bl object_getFlag // () -> int
	mov r1, #0x24 
	tst r0, r1
	bne locret_801A3FE
	ldr r1, off_801A548 // =timer_2000000 
	tst r0, r1
	beq locret_801A3FE
	mov r0, #0x10
	bl object_setFlag2
	mov r0, #2
	strb r0, [r5,#oBattleObject_Unk_0f]
locret_801A3FE:
	pop {r7,pc}
	thumb_func_end sub_801A3DA

	thumb_local_start
sub_801A400:
	push {r7,lr}
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	ldrh r1, [r7,#oAIData_Unk_38]
	tst r1, r1
	bne locret_801A41E
	bl object_getFlag // () -> int
	mov r1, #0x24 
	tst r0, r1
	bne locret_801A41E
	mov r0, #0x10
	bl object_setFlag2
	mov r0, #3
	strb r0, [r5,#oBattleObject_Unk_0f]
locret_801A41E:
	pop {r7,pc}
	thumb_func_end sub_801A400

// symdb: Decrements the CollisionData::CounterTimer of the battle object held in r5 by 1 when non-zero
// symdb: (r5 = BattleObject*) -> r0 = decremented value (only when timer was non-zero) ; modifies the
// symdb: held byte; Z flag set if branch taken (timer was 0)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_tickCounterTimer_801A420.yaml
	thumb_local_start
battleObject_tickCounterTimer_801A420:
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r3,#oCollisionData_CounterTimer]
	tst r0, r0
	beq locret_801A42C
	sub r0, #1
	strb r0, [r3,#oCollisionData_CounterTimer]
locret_801A42C:
	mov pc, lr
	thumb_func_end battleObject_tickCounterTimer_801A420

// symdb: While a battle object is being hit, computes its arm position and spawns the hit/damage effect there.
// symdb: void sub_801A42E(battleObject* obj /* r5 */, void* r4 /* preserved only */, ...); no meaningful
// symdb: return (r0-r3 clobbered, r4-r7 preserved)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_spawnHitEffectAtArm_801A42E.yaml
	thumb_local_start
battle_spawnHitEffectAtArm_801A42E:
	push {r4,lr}
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0x74 
	ldrb r1, [r0,r1]
	cmp r1, #0
	beq locret_801A45A
	mov r1, #0x80
	ldrh r1, [r0,r1]
	cmp r1, #0
	beq locret_801A45A
	ldrh r0, [r5,#oBattleObject_NameID]
	mov r1, #5
	ldrb r2, [r5,#oBattleObject_Alliance]
	ldrb r3, [r5,#oBattleObject_DirectionFlip]
	bl getBattleArmPositionMaybe_8018810
	lsl r3, r1, #0x10
	lsl r1, r0, #0x10
	mov r2, #0
	mov r4, #0
	bl sub_80E8124
locret_801A45A:
	pop {r4,pc}
	thumb_func_end battle_spawnHitEffectAtArm_801A42E

// symdb: Handles a crouch/slide result of 0x40 in the object's collision flag set: flips the partner's alliance state, adds the player's churn-row column 8 counter, resets the object counter-timer, refreshes the chatbox window panel, and plays the "crouch" sound effect.
// symdb: (r5 = BattleObjectPtr, r10 = ToolkitPtr) -> void ; side effects: sub_802E032(0x1500),
// symdb: tableAddSaturatedByte_800AB46(...), PlaySoundEffect(SOUND_SELECT_86), sub_801E270 (window panel
// symdb: update)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_handleCollisionCrouchSlideReset_801A45C.yaml
	thumb_local_start
battle_handleCollisionCrouchSlideReset_801A45C:
	push {r4,r6,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	ldr r6, [r4,#oCollisionData_FlagsFromCollision]
	mov r2, #0x40 
	tst r6, r2
	beq locret_801A4A4
	bl battle_testFlag0x40_800A8F8
	tst r0, r0
	beq loc_801A47C
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	ldr r1, off_801A54C // =0x1500 
	bl sub_802E032
loc_801A47C:
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	mov r1, #8
	mov r2, #1
	bl tableAddSaturatedByte_800AB46
	mov r0, #0
	strb r0, [r4,#oCollisionData_CounterTimer]
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801A4A4
	bl sub_801E270
	push {r0}
	mov r0, #SOUND_SELECT_86
	bl PlaySoundEffect
	pop {r0}
locret_801A4A4:
	pop {r4,r6,pc}
	thumb_func_end battle_handleCollisionCrouchSlideReset_801A45C

// symdb: If a battle object was just hit by an arm-style attack (hit type 0xF4 or 0xF7), computes where the attacker's arm connects and spawns the corresponding battle effect there.
// symdb: void battle_spawnArmHitEffect_801A4A6(battleObject* obj /* r5 */); also reads r4/r6/r7 per the
// symdb: caller contract but does not use them; preserves r4-r7, returns r3 and the c/v flags as left by
// symdb: sub_80E8124
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_spawnArmHitEffect_801A4A6.yaml
	thumb_local_start
battle_spawnArmHitEffect_801A4A6:
	push {r4,lr}
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0xa4
	ldrb r1, [r0,r1]
	cmp r1, #0xf4
	beq loc_801A4B6
	cmp r1, #0xf7
	bne locret_801A4CE
loc_801A4B6:
	ldrh r0, [r5,#oBattleObject_NameID]
	mov r1, #5
	ldrb r2, [r5,#oBattleObject_Alliance]
	ldrb r3, [r5,#oBattleObject_DirectionFlip]
	bl getBattleArmPositionMaybe_8018810
	lsl r3, r1, #0x10
	lsl r1, r0, #0x10
	mov r2, #0
	mov r4, #3
	bl sub_80E8124
locret_801A4CE:
	pop {r4,pc}
	thumb_func_end battle_spawnArmHitEffect_801A4A6

	thumb_func_start sub_801A4D0
sub_801A4D0:
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	lsl r1, r1, #8
	add r1, r1, r0
	mov r0, #0x12
	strh r1, [r3,r0]
	mov pc, lr
	thumb_func_end sub_801A4D0

	thumb_func_start sub_801A4DC
sub_801A4DC:
	push {r4,r5,lr}
	ldr r2, [r5,#oBattleObject_CollisionDataPtr]
	mov r5, r1
	ldr r1, [r2,#oCollisionData_Unk_7c]
	ldr r2, off_801A550 // =eCollisionData 
	mov r3, #0
loc_801A4E8:
	cmp r5, #4
	blt loc_801A502
	tst r1, r1
	beq loc_801A502
	lsl r1, r1, #1
	bcc loc_801A4FE
	ldr r4, [r2,#oCollisionData_ParentObjectPtr]
	str r4, [r0]
	add r0, #4
	add r3, #1
	sub r5, #4
loc_801A4FE:
	add r2, #oCollisionData_Size
	b loc_801A4E8
loc_801A502:
	mov r0, r3
	pop {r4,r5,pc}
	thumb_func_end sub_801A4DC

// symdb: Battle AI: if the target battle object's collision data has a non-zero damage multiplier and non-zero DamageElements flags, set AIData Unk_44 bit 0x80000000
// symdb: (r5 = AI work pointer) -> void ; may set AIData Unk_44 flag and clobber r0/r1/r3
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_ai_markWindBoxReady_801A506.yaml
	thumb_local_start
battle_ai_markWindBoxReady_801A506:
	push {lr}
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	mov r0, #0x75 
	ldrb r0, [r3,r0]
	cmp r0, #0
	beq locret_801A520
	mov r0, #0x80
	ldrh r0, [r3,r0]
	cmp r0, #0
	beq locret_801A520
	ldr r0, dword_801A538 // =0x80000000 
	bl SetAIData_Unk_44_Flag
locret_801A520:
	pop {pc}
	.balign 4, 0
dword_801A524:
	.word 0x8000
dword_801A528:
	.word 0x8001E800
dword_801A52C:
	.word 0x300E8
off_801A530:
	.word 0x800
dword_801A534:
	.word 0x10000
dword_801A538:
	.word 0x80000000
dword_801A53C:
	.word 0x20000
dword_801A540:
	.word 0xFFFF
dword_801A544:
	.word 0x100040
off_801A548:
	.word 0x2000000
off_801A54C:
	.word 0x1500
off_801A550:
	.word eCollisionData
	thumb_func_end battle_ai_markWindBoxReady_801A506

// symdb: Applies the battle object's current status effect to itself by patching a collision-data field and setting an object flag from a status-effect table.
// symdb: void sub_801A554(r5=battle object) -> r2 (left over from last flag helper); clobbers
// symdb: r0,r1,r2,r3,lr and flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObject_applyStatusEffect_801A554.yaml
	thumb_local_start
battleObject_applyStatusEffect_801A554:
	push {lr}
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r3,#oCollisionData_StatusEffectFinal]
	cmp r0, #0
	beq locret_801A58C
	push {r0}
	lsr r1, r0, #4
	sub r1, #1
	lsl r1, r1, #2
	ldr r2, off_801A7B0 // =off_80209EC 
	ldr r2, [r2,r1]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x19
	add r2, r2, r0
	ldrh r1, [r2,#4]
	ldrb r0, [r2,#6]
	strh r1, [r3,r0]
	ldr r0, [r2]
	bl object_setFlag2
	pop {r0}
	cmp r0, #0x50 
	blt locret_801A58C
	cmp r0, #0x55 
	bgt locret_801A58C
	mov r0, #6
	bl object_clearFlag2
locret_801A58C:
	pop {pc}
	thumb_func_end battleObject_applyStatusEffect_801A554

	thumb_local_start
sub_801A58E:
	push {lr}
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r0, [r3,#oCollisionData_StatusEffectFinal]
	cmp r0, #0
	beq locret_801A5B8
	lsr r1, r0, #4
	cmp r1, #1
	bne locret_801A5B8
	sub r1, #1
	lsl r1, r1, #2
	ldr r2, off_801A7B4 // =off_80209EC 
	ldr r2, [r2,r1]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x19
	add r2, r2, r0
	ldrh r1, [r2,#4]
	ldrb r0, [r2,#6]
	strh r1, [r3,r0]
	ldr r0, [r2]
	bl object_setFlag2
locret_801A5B8:
	pop {pc}
	thumb_func_end sub_801A58E

	thumb_local_start
sub_801A5BA:
	push {lr}
	ldr r3, [r0,#0x54]
	cmp r1, #0
	beq locret_801A5E0
	mov r0, r1
	lsr r1, r1, #4
	sub r1, #1
	lsl r1, r1, #2
	ldr r2, off_801A7B8 // =off_80209EC 
	ldr r2, [r2,r1]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x19
	add r2, r2, r0
	ldrh r1, [r2,#4]
	ldrb r0, [r2,#6]
	strh r1, [r3,r0]
	ldr r0, [r2]
	bl object_setFlag2
locret_801A5E0:
	pop {pc}
	thumb_func_end sub_801A5BA

// symdb: Clears a battle object's collision result fields, resetting whatever hit/interaction outcome was stored in its collision data.
// symdb: void battle_ClearObjectCollisionResult(r5 = BattleObject*) /* returns via mov pc, lr; clobbers
// symdb: r0-r2, NZ flags */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_ClearObjectCollisionResult_801A5E2.yaml
	thumb_func_start battle_ClearObjectCollisionResult_801A5E2
battle_ClearObjectCollisionResult_801A5E2:
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0
	str r1, [r0,#oCollisionData_Unk_48]
	mov r2, #0x4c 
	str r1, [r0,r2]
	mov pc, lr
	thumb_func_end battle_ClearObjectCollisionResult_801A5E2

// symdb: Per-tick handler that decrements and finishes a battle object's flashing/invisibility duration, clearing the invis flag and playing the disappearance SFX.
// symdb: (r5 = BattleObjectPtr) -> void ; side effects: mutates FlashingInvisTimer and
// symdb: ObjectFlags1/ObjectFlags2 of r5->CollisionDataPtr; may call PlaySoundEffect(0x94)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_handleFlashingInvisTick_801A5EE.yaml
	thumb_local_start
battleObject_handleFlashingInvisTick_801A5EE:
	push {r6,lr}
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801A642
	ldr r6, [r5,#oBattleObject_CollisionDataPtr]
	ldrh r0, [r6,#oCollisionData_FlashingInvisTimer]
	tst r0, r0
	bne loc_801A610
	bl object_getFlag2
	mov r1, #2
	tst r0, r1
	beq loc_801A610
	mov r0, #0x78 
	strh r0, [r6,#oCollisionData_FlashingInvisTimer]
loc_801A610:
	mov r0, #2
	bl object_clearFlag2
	ldrh r0, [r6,#oCollisionData_FlashingInvisTimer]
	tst r0, r0
	beq loc_801A632
	sub r0, #1
	strh r0, [r6,#oCollisionData_FlashingInvisTimer]
	bgt loc_801A63A
	bl object_getFlag // () -> int
	mov r1, #2
	tst r0, r1
	beq loc_801A632
	mov r0, #0x94
	bl PlaySoundEffect
loc_801A632:
	ldr r0, dword_801A644 // =0x202 
	bl object_clearFlag // (int bitfield) -> void
	b locret_801A642
loc_801A63A:
	mov r0, #1
	lsl r0, r0, #9
	bl object_setFlag1 // (int a1) -> void
locret_801A642:
	pop {r6,pc}
	.balign 4, 0
dword_801A644:
	.word 0x202
	thumb_func_end battleObject_handleFlashingInvisTick_801A5EE

// symdb: Ends a fighter's post-hit flashing-invisibility by clearing the flash countdown in its collision data, once the hit flag is set and no persistent invisibility remains.
// symdb: battle_clearInvisFlashTimer(battleObj r5, battleState r10) -> collisionData r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_clearInvisFlashTimer_801A648.yaml
	thumb_local_start
battle_clearInvisFlashTimer_801A648:
	push {lr}
	bl battle_isPaused
	bne locret_801A66A
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	ldrh r1, [r3,#oCollisionData_FlashingInvisTimer]
	tst r1, r1
	beq locret_801A66A
	ldr r0, [r3,#oCollisionData_FlagsFromCollision]
	mov r1, #4
	tst r0, r1
	beq locret_801A66A
	ldr r1, off_801A7BC // =0x1000 
	tst r0, r1
	bne locret_801A66A
	mov r0, #0
	strh r0, [r3,#oCollisionData_FlashingInvisTimer]
locret_801A66A:
	pop {pc}
	thumb_func_end battle_clearInvisFlashTimer_801A648

	thumb_func_start sub_801A66C
sub_801A66C:
	push {lr}
	ldr r1, [r5,#oBattleObject_CollisionDataPtr]
	mov r0, #0x78 
	strh r0, [r1,#oCollisionData_FlashingInvisTimer]
	mov r0, #1
	lsl r0, r0, #9
	bl object_setFlag1 // (int a1) -> void
	pop {pc}
	thumb_func_end sub_801A66C

// symdb: Clears a battle object's "flashing while invisible" timer in its collision data and returns the collision data pointer.
// symdb: battle_resetFlashingInvisTimer(struct BattleObject* obj /* r5 */) -> struct CollisionData* /* r3
// symdb: */; clobbers r0 and NZ flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_resetFlashingInvisTimer_801A67E.yaml
	thumb_func_start battle_resetFlashingInvisTimer_801A67E
battle_resetFlashingInvisTimer_801A67E:
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	mov r0, #0
	strh r0, [r3,#oCollisionData_FlashingInvisTimer]
	mov pc, lr
	thumb_func_end battle_resetFlashingInvisTimer_801A67E

	thumb_local_start
sub_801A686:
	push {r4,lr}
	ldr r4, [r5,#0x54]
	mov r0, #0
	strb r0, [r4,#0xf]
	strb r0, [r4,#0x11]
	mov r1, #0xa4
	strh r0, [r4,r1]
	mov r0, #0x80
	add r0, r0, r4
	mov r1, #0x14
	bl ZeroFillByHalfword
	ldr r0, dword_801A7C0 // =0x106 
	bl object_clearFlag2
	pop {r4,pc}
	thumb_func_end sub_801A686

	thumb_local_start
sub_801A6A6:
	push {r4,lr}
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	add r0, #0x80
	mov r1, #0x14
	bl ZeroFillByHalfword
	pop {r4,pc}
	thumb_func_end sub_801A6A6

// symdb: When the given battle object registers a collision hit, increments its alliance navi stat at offset 0x18 by one, capped at 7.
// symdb: void battle_incrementAllianceStatOnCollisionHit(BattleObject *obj /* r5 */); clobbers r0-r3,
// symdb: flags; preserves r4 (caller's collision-data pointer restored)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_incrementAllianceStatOnCollisionHit_801A6B4.yaml
	thumb_local_start
battle_incrementAllianceStatOnCollisionHit_801A6B4:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_checkHPDigit4State_801A6E8
	cmp r0, #0
	beq locret_801A6D4
	mov r1, #0x18
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	add r2, r0, #1
	cmp r2, #7
	ble loc_801A6CE
	mov r2, #7
loc_801A6CE:
	mov r1, #0x18
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
locret_801A6D4:
	pop {r4,pc}
	thumb_func_end battle_incrementAllianceStatOnCollisionHit_801A6B4

// symdb: Runs a battle object's collision check and zeroes the object's HP if the check reports a hit.
// symdb: void battle_objectDieOnCollisionHit(battle_object* obj /*r5*/); // extra args/scratch in r4
// symdb: (collision data, forwarded to sub_801A6E8) and r7; contract reports r2/r4/r7 as outputs
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_objectDieOnCollisionHit_801A6D6.yaml
	thumb_local_start
battle_objectDieOnCollisionHit_801A6D6:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_checkHPDigit4State_801A6E8
	cmp r0, #0
	beq locret_801A6E6
	mov r0, #0
	strh r0, [r5,#oBattleObject_HP]
locret_801A6E6:
	pop {r4,pc}
	thumb_func_end battle_objectDieOnCollisionHit_801A6D6

// symdb: Checks whether a battle object's HP, converted to BCD, contains a digit 4, and manages a per-object state byte (+0xA4) that gates whatever effect depends on that.
// symdb: u32 checkHPDigit4(void *stateObj /* r4: object with u8 state at +0xA4 */, void *hpObj /* r5:
// symdb: object whose u16 HP at oBattleObject_HP is read */); returns r0 = 1 if the state is already
// symdb: flagged (0xF4) or the HP readout has a 4 digit, else 0. Clobbers r1-r3 and flags; r4/r5/r7
// symdb: preserved.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_checkHPDigit4State_801A6E8.yaml
	thumb_local_start
battle_checkHPDigit4State_801A6E8:
	push {lr}
	mov r0, #0
	mov r1, #0xa4
	ldrb r1, [r4,r1]
	cmp r1, #0xf7
	beq loc_801A6FC
	cmp r1, #0xf4
	bne locret_801A71E
	mov r0, #1
	b locret_801A71E
loc_801A6FC:
	ldrh r0, [r5,#oBattleObject_HP]
	bl memory_bcdConvert
	mov r3, #0
loc_801A704:
	mov r1, #0xf
	and r1, r0
	cmp r1, #4
	bne loc_801A70E
	mov r3, #1
loc_801A70E:
	lsr r0, r0, #4
	cmp r0, #0
	bne loc_801A704
	mov r0, r3
	cmp r0, #0
	bne locret_801A71E
	mov r1, #0xa4
	strb r0, [r4,r1]
locret_801A71E:
	pop {pc}
	thumb_func_end battle_checkHPDigit4State_801A6E8

// symdb: When a battle object receives collision event 0xF6, raises two of its navi battle stats (offsets 0x18 and 0x19) by 2 each, capped at 7, then runs a follow-up handler.
// symdb: void sub_801A720(BattleObject* obj /* r5 */); preserves r4/r6/r7, clobbers r0-r3 and lr, and
// symdb: leaves C/V set from the final comparison (the event-type cmp on the early-exit path, the cap
// symdb: check or sub_801A77A otherwise)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_buffTwoStatsPlus2OnEventF6_801A720.yaml
	thumb_local_start
battle_buffTwoStatsPlus2OnEventF6_801A720:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0xa4
	ldrb r1, [r4,r1]
	cmp r1, #0xf6
	bne locret_801A758
	mov r1, #0x18
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	add r2, r0, #2
	cmp r2, #7
	ble loc_801A73A
	mov r2, #7
loc_801A73A:
	mov r1, #0x18
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #0x19
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	add r2, r0, #2
	cmp r2, #7
	ble loc_801A74E
	mov r2, #7
loc_801A74E:
	mov r1, #0x19
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_801A77A
locret_801A758:
	pop {r4,pc}
	thumb_func_end battle_buffTwoStatsPlus2OnEventF6_801A720

// symdb: Enemy AI hook that, when the battle object stands on a particular panel type (collision byte 0xF6), moves the AI's Unk_12 target marker two columns forward (capped at column 7) and runs the follow-up AI routine.
// symdb: void sub_801A75A(u32 column /*r2*/, BattleObject *obj /*r5*/) — r4 is caller state that is
// symdb: preserved; Z flag comes back from "collisionByte == 0xF6" when the panel check fails
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_aiAimTwoColumnsAheadOnSpecialPanel_801A75A.yaml
	thumb_local_start
battle_aiAimTwoColumnsAheadOnSpecialPanel_801A75A:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0xa4
	ldrb r1, [r4,r1]
	cmp r1, #0xf6
	bne locret_801A778
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r3,#oAIData_Unk_12]
	add r0, r2, #2
	cmp r0, #7
	ble loc_801A772
	mov r0, #7
loc_801A772:
	strb r0, [r3,#oAIData_Unk_12]
	bl sub_801A77A
locret_801A778:
	pop {r4,pc}
	thumb_func_end battle_aiAimTwoColumnsAheadOnSpecialPanel_801A75A

	thumb_local_start
sub_801A77A:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0xa4
	ldrb r1, [r4,r1]
	cmp r1, #0xf6
	bne locret_801A7AC
	mov r0, #8
	bl object_setFlag2
	mov r0, #0x96
	strh r0, [r4,#oCollisionData_Unk_1c]
	ldrh r0, [r5,#oBattleObject_NameID]
	ldr r1, dword_801A7C4 // =0x173 
	sub r0, r0, r1
	bmi loc_801A79C
	cmp r0, #0xb
	ble loc_801A7A6
loc_801A79C:
	mov r0, #0x20 
	bl object_setFlag2
	ldr r0, off_801A7C8 // =0x4b0 
	strh r0, [r4,#oCollisionData_BlindTimer]
loc_801A7A6:
	mov r0, #0
	mov r1, #0xa4
	strb r0, [r4,r1]
locret_801A7AC:
	pop {r4,pc}
	.balign 4, 0
off_801A7B0:
	.word off_80209EC
off_801A7B4:
	.word off_80209EC
off_801A7B8:
	.word off_80209EC
off_801A7BC:
	.word 0x1000
dword_801A7C0:
	.word 0x106
dword_801A7C4:
	.word 0x173
off_801A7C8:
	.word 0x4B0
	thumb_func_end sub_801A77A

	thumb_func_start sub_801A7CC
sub_801A7CC:
	ldr r3, [r5,#oBattleObject_CollisionDataPtr]
	strb r0, [r3,#oCollisionData_Barrier]
	ldr r1, off_801A7F0 // =byte_8020B8C 
	ldrb r1, [r1,r0]
	strb r1, [r3,#oCollisionData_Unk_14]
	mov r1, #6
	mul r0, r1
	ldr r1, off_801A7EC // =byte_8020B2C 
	add r0, r0, r1
	ldrh r1, [r0]
	strb r1, [r3,#oCollisionData_Unk_16]
	ldrh r1, [r0,#2]
	strb r1, [r3,#oCollisionData_Unk_17]
	ldrh r1, [r0,#4]
	strh r1, [r3,#oCollisionData_Unk_1a_1b]
	mov pc, lr
	.balign 4, 0
off_801A7EC:
	.word byte_8020B2C
off_801A7F0:
	.word byte_8020B8C
	thumb_func_end sub_801A7CC

// symdb: Clears a battle object's AI state field (oAIData_Unk_60) and removes its barrier flag in its collision data.
// symdb: battle_clearAIDataAndBarrier(BattleObject *obj /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_clearAIDataAndBarrier_801A7F4.yaml
	thumb_func_start battle_clearAIDataAndBarrier_801A7F4
battle_clearAIDataAndBarrier_801A7F4:
	mov r0, #0
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_60]
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0
	strb r1, [r0,#oCollisionData_Barrier]
	mov pc, lr
	thumb_func_end battle_clearAIDataAndBarrier_801A7F4

// symdb: Per-frame update of a BattleObject's barrier status (incl. Wood/Aqua barrier countdown, panel-type interactions, and reset of damage/hit modifiers).
// symdb: (r5 = BattleObjectPtr, r10 = Toolkit) -> void ; clobbers flags, r0-r4, r6, lr
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_updateBarrierStatus_801A802.yaml
	thumb_local_start
battleObject_updateBarrierStatus_801A802:
	push {r4,r6,lr}
	bl battle_isPaused
	beq loc_801A80C
	pop {r4,r6,pc}
loc_801A80C:
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	ldrb r6, [r4,#oCollisionData_Barrier]
	cmp r6, #0
	bne loc_801A816
	b locret_801A9A2
loc_801A816:
	cmp r6, #0xa
	bne loc_801A822
	ldrh r0, [r4,#oCollisionData_Unk_16]
	tst r0, r0
	beq loc_801A860
	b loc_801A82C
loc_801A822:
	cmp r6, #8
	bne loc_801A82C
	ldrh r0, [r4,#oCollisionData_Unk_16]
	tst r0, r0
	beq loc_801A860
loc_801A82C:
	mov r0, #0x77 
	ldrb r0, [r4,r0]
	mov r1, #0x20 
	tst r0, r1
	bne loc_801A83E
	ldr r0, [r4,#oCollisionData_Unk_6c]
	ldr r1, off_801A9B0 // =0xa20 
	tst r0, r1
	beq loc_801A860
loc_801A83E:
	cmp r6, #8
	bne loc_801A84A
	ldrh r0, [r4,#oCollisionData_Unk_16]
	tst r0, r0
	beq loc_801A860
	b loc_801A854
loc_801A84A:
	cmp r6, #0xa
	bne loc_801A854
	ldrh r0, [r4,#oCollisionData_Unk_16]
	tst r0, r0
	beq loc_801A860
loc_801A854:
	mov r6, #0x10
	strb r6, [r4,#oCollisionData_Barrier]
	mov r0, #0
	strh r0, [r4,#oCollisionData_Unk_16]
	ldrb r0, [r4,#oCollisionData_HitModifierFinal]
	strb r0, [r4,#oCollisionData_Unk_15]
loc_801A860:
	cmp r6, #8
	beq loc_801A888
	cmp r6, #0xa
	beq loc_801A8AE
	ldrb r0, [r4,#oCollisionData_Barrier]
	cmp r0, #0x10
	beq loc_801A874
	bl battle_isTimeStop
	bne loc_801A8E0
loc_801A874:
	ldrh r0, [r4,#oCollisionData_Unk_1a_1b]
	ldr r1, dword_801A9B4 // =0xffff 
	cmp r0, r1
	beq loc_801A8E0
	sub r0, #1
	strh r0, [r4,#oCollisionData_Unk_1a_1b]
	bgt loc_801A8E0
	mov r0, #0
	strb r0, [r4,#oCollisionData_Barrier]
	b loc_801A8E0
loc_801A888:
	ldrh r1, [r4,#oCollisionData_Unk_16]
	tst r1, r1
	bne loc_801A8E0
	bl battle_isTimeStop
	bne loc_801A8AC
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #7
	beq loc_801A8AC
	cmp r0, #6
	beq loc_801A8AC
	ldrh r0, [r4,#oCollisionData_Unk_1a_1b]
	add r0, #1
	strh r0, [r4,#oCollisionData_Unk_1a_1b]
	cmp r0, #0xf0
	blt loc_801A8AC
	mov r0, #1
	strh r0, [r4,#oCollisionData_Unk_16]
loc_801A8AC:
	b locret_801A9A2
loc_801A8AE:
	ldrh r1, [r4,#oCollisionData_Unk_16]
	tst r1, r1
	beq loc_801A8CA
	cmp r1, #0xc8
	bge loc_801A8C6
	ldrb r0, [r4,#oCollisionData_Unk_1a]
	add r0, #1
	cmp r0, #6
	blt loc_801A8C6
	add r1, #1
	strh r1, [r4,#oCollisionData_Unk_16]
	mov r0, #0
loc_801A8C6:
	strb r0, [r4,#oCollisionData_Unk_1a]
	b loc_801A8E0
loc_801A8CA:
	bl battle_isTimeStop
	bne locret_801A9A2
	ldrb r0, [r4,#oCollisionData_Unk_1b]
	add r0, #1
	strb r0, [r4,#oCollisionData_Unk_1b]
	cmp r0, #0x78 
	blt locret_801A9A2
	mov r0, #0xc8
	strh r0, [r4,#oCollisionData_Unk_16]
	b locret_801A9A2
	.balign 4, 0
loc_801A8E0: .align 1, 0
	cmp r6, #8
	bne loc_801A8FA
	mov r1, #oCollisionData_ElecElementDamage
	ldrh r1, [r4,r1]
	tst r1, r1
	beq loc_801A8FA
	mov r2, #oCollisionData_Unk_78
	ldrh r2, [r4,r2]
	mov r1, #oCollisionData_PanelDamage4
	ldrh r0, [r4,r1]
	add r0, r0, r2
	strh r0, [r4,r1]
	b loc_801A90A
loc_801A8FA:
	ldrb r0, [r4,#oCollisionData_Unk_14]
	cmp r0, #0
	beq loc_801A916
	lsl r0, r0, #1
	add r0, #oCollisionData_PrimaryElementDamages
	ldrh r0, [r4,r0]
	cmp r0, #0
	beq loc_801A916
loc_801A90A:
	mov r0, #0
	strb r0, [r4,#oCollisionData_Barrier]
	mov r0, #0
	strh r0, [r4,#oCollisionData_Unk_1a_1b]
	strb r0, [r4,#oCollisionData_Unk_16]
	b locret_801A9A2
loc_801A916:
	mov r0, #0x94
	ldrh r0, [r4,r0]
	mov r1, #0x96
	ldrh r1, [r4,r1]
	add r0, r0, r1
	mov r1, #0x98
	ldrh r1, [r4,r1]
	add r0, r0, r1
	mov r1, #0x9a
	ldrh r1, [r4,r1]
	add r0, r0, r1
	mov r1, #0x9c
	ldrh r1, [r4,r1]
	add r0, r0, r1
	push {r0,r4}
	ldrb r0, [r4,#oCollisionData_PanelX]
	ldrb r1, [r4,#oCollisionData_PanelY]
	bl object_getPanelDataOffset
	ldrb r0, [r0,#oPanelData_Type]
	cmp r0, #5
	pop {r0,r4}
	bne loc_801A948
	add r0, #1
	lsr r0, r0, #1
loc_801A948:
	ldrb r1, [r4,#oCollisionData_Unk_17]
	cmp r0, r1
	blt loc_801A96E
	ldrb r1, [r4,#oCollisionData_Unk_16]
	sub r1, r1, r0
	strb r1, [r4,#oCollisionData_Unk_16]
	bgt loc_801A96E
	cmp r6, #8
	beq loc_801A968
	cmp r6, #0xa
	beq loc_801A968
	ldrb r0, [r4,#oCollisionData_Barrier]
	cmp r0, #0x10
	beq loc_801A968
	mov r0, #0
	strb r0, [r4,#oCollisionData_Barrier]
loc_801A968:
	mov r0, #0
	strh r0, [r4,#oCollisionData_Unk_1a_1b]
	strb r0, [r4,#oCollisionData_Unk_16]
loc_801A96E:
	mov r0, #0
	mov r1, #0x82
	add r1, r1, r4
	strh r0, [r1]
	strh r0, [r1,#2]
	strh r0, [r1,#4]
	strh r0, [r1,#6]
	strh r0, [r1,#8]
	mov r1, #0x8e
	strh r0, [r4,r1]
	mov r1, #0x90
	strh r0, [r4,r1]
	mov r1, #0x92
	strh r0, [r4,r1]
	strb r0, [r4,#oCollisionData_HitModifierFinal]
	strb r0, [r4,#oCollisionData_StatusEffectFinal]
	mov r1, #0xa4
	strh r0, [r4,r1]
	mov r1, #0x74 
	strh r0, [r4,r1]
	mov r1, #0x76 
	strb r0, [r4,r1]
	mov r0, #0x50 
	ldr r1, [r4,#oCollisionData_FlagsFromCollision]
	bic r1, r0
	str r1, [r4,#oCollisionData_FlagsFromCollision]
locret_801A9A2:
	pop {r4,r6,pc}
	thumb_func_end battleObject_updateBarrierStatus_801A802

	thumb_local_start
sub_801A9A4:
	ldr r0, [r5,#0x54]
	ldrb r0, [r0,#0x16]
	mov pc, lr
	thumb_func_end sub_801A9A4

	thumb_local_start
sub_801A9AA:
	ldr r1, [r5,#0x54]
	strb r0, [r1,#0x16]
	mov pc, lr
off_801A9B0:
	.word 0xA20
dword_801A9B4:
	.word 0xFFFF
	thumb_func_end sub_801A9AA

// symdb: Per-frame collision/damage processing pipeline for a battle object: the base navi-AI variant, skipping battleObject_applyStatusEffect for NameIDs 0x125-0x12A.
// symdb: void battleObject_processCollisionResults(u32 r5 /* battle object */) : r5 -> [r4 r5 r10]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_processCollisionResults_801A9B8.yaml
	thumb_func_start battleObject_processCollisionResults_801A9B8
battleObject_processCollisionResults_801A9B8:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801AA3C
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801AA3C
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801AA3C
	bl battleObject_updateBarrierStatus_801A802
	bl object_updatePoisonPanelStatus_801A186
	bl object_tickIcePanelFreeze_801A36A
	bl battle_tickAiSelfDrain_8010230
	bl battleObject_handleImpact_802CFF8
	bl hiveBlockHappensHere_802CEF4
	bl battle_incrementAllianceStatOnCollisionHit_801A6B4
	bl battle_buffTwoStatsPlus2OnEventF6_801A720
	bl applyChipAllianceEffect_8013AE4
	bl battleObject_applyHitModifierFlags_801AEB0
	bl battle_applyFlattenHitStatus_800EB26
	ldrh r0, [r5,#oBattleObject_NameID]
	ldr r1, dword_801AA40 // =0x125 
	cmp r0, r1
	blt loc_801AA1C
	ldr r1, dword_801AA44 // =0x12a 
	cmp r0, r1
	ble loc_801AA20
loc_801AA1C:
	bl battleObject_applyStatusEffect_801A554
loc_801AA20:
	bl battleObject_clearChipSelectionOnAirShoe_801A2CC
	bl battle_toggleAllianceAndAccumulateCollisionToAiData_801A308
	bl object_calculateFinalDamage1
	bl battleObject_tickCounterTimer_801A420
	bl battle_objectClearPendingHitIfCollisionProcessed_8010198
	bl battle_clearInvisFlashTimer_801A648
	bl object_spawnHiteffect
locret_801AA3C:
	pop {r4,r7,pc}
	.balign 4, 0
dword_801AA40:
	.word 0x125
dword_801AA44:
	.word 0x12A
	thumb_func_end battleObject_processCollisionResults_801A9B8

// symdb: Per-frame battle-object update driver that clears leftover hit-flash palette and, when its barrier/collision-data is gone, bails out early; otherwise fans out into the object's panel/status/damage/AI/impact handlers.
// symdb: (r5 = *BattleObject, r10 = *Toolkit) -> void ; side effects: clears sprite high-palette nibble,
// symdb: tears down collision data when its Enable bit + DEAD flag are set, then runs ~20 child handlers
// symdb: updating collision damage, hit-flash timer, status effect, counter timer, AI self-drain, impact,
// symdb: hive, alliance stats, etc.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_runPerFrameUpdate_801AA48.yaml
	thumb_func_start battleObject_runPerFrameUpdate_801AA48
battleObject_runPerFrameUpdate_801AA48:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801AABE
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801AABE
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801AABE
	bl battleObject_updateBarrierStatus_801A802
	bl object_updatePoisonPanelStatus_801A186
	bl object_tickIcePanelFreeze_801A36A
	bl battle_tickAiSelfDrain_8010230
	bl battleObject_handleImpact_802CFF8
	bl hiveBlockHappensHere_802CEF4
	bl battle_incrementAllianceStatOnCollisionHit_801A6B4
	bl battle_buffTwoStatsPlus2OnEventF6_801A720
	bl applyChipAllianceEffect_8013AE4
	bl sub_801AF0E
	bl battle_applyFlattenHitStatus_800EB26
	bl battleObject_applyStatusEffect_801A554
	bl battleObject_clearChipSelectionOnAirShoe_801A2CC
	bl battle_toggleAllianceAndAccumulateCollisionToAiData_801A308
	bl object_calculateFinalDamage1
	bl battleObject_tickCounterTimer_801A420
	bl battle_objectClearPendingHitIfCollisionProcessed_8010198
	bl battle_clearInvisFlashTimer_801A648
	bl object_spawnHiteffect
locret_801AABE:
	pop {r4,r7,pc}
	thumb_func_end battleObject_runPerFrameUpdate_801AA48

// symdb: Per-frame collision/damage processing pipeline for a battle object: the navi-AI variant that skips battle_tickAiSelfDrain when the battle mode is 0xA, and applies the status effect unconditionally.
// symdb: void battleObject_processCollisionResultsByMode(u32 r5 /* battle object */) : r5 -> [r4 r5 r10]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_processCollisionResultsByMode_801AAC0.yaml
	thumb_func_start battleObject_processCollisionResultsByMode_801AAC0
battleObject_processCollisionResultsByMode_801AAC0:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801AB3E
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801AB3E
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801AB3E
	bl battleObject_updateBarrierStatus_801A802
	bl object_updatePoisonPanelStatus_801A186
	bl object_tickIcePanelFreeze_801A36A
	bl GetBattleMode
	cmp r0, #0xa
	beq loc_801AB02
	bl battle_tickAiSelfDrain_8010230
loc_801AB02:
	bl battleObject_handleImpact_802CFF8
	bl hiveBlockHappensHere_802CEF4
	bl battle_incrementAllianceStatOnCollisionHit_801A6B4
	bl battle_buffTwoStatsPlus2OnEventF6_801A720
	bl applyChipAllianceEffect_8013AE4
	bl battleObject_applyHitModifierFlags_801AEB0
	bl battle_applyFlattenHitStatus_800EB26
	bl battleObject_applyStatusEffect_801A554
	bl battleObject_clearChipSelectionOnAirShoe_801A2CC
	bl battle_toggleAllianceAndAccumulateCollisionToAiData_801A308
	bl object_calculateFinalDamage1
	bl battleObject_tickCounterTimer_801A420
	bl battle_objectClearPendingHitIfCollisionProcessed_8010198
	bl battle_clearInvisFlashTimer_801A648
	bl object_spawnHiteffect
locret_801AB3E:
	pop {r4,r7,pc}
	thumb_func_end battleObject_processCollisionResultsByMode_801AAC0

// symdb: Per-frame battle object update: clear final palette, optionally tear down collision data, and run the full per-tick pipeline (barrier/poison/ice, impact, hive, alliance stats, alliance flip, damage, flatten, counter, hit-effect).
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> void ; r4/r7 preserved
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_handleCollisionAndStatusTick_801AB40.yaml
	thumb_func_start battleObject_handleCollisionAndStatusTick_801AB40
battleObject_handleCollisionAndStatusTick_801AB40:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801ABB6
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801ABB6
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801ABB6
	bl battleObject_updateBarrierStatus_801A802
	bl object_updatePoisonPanelStatus_801A186
	bl object_tickIcePanelFreeze_801A36A
	bl battle_tickAiSelfDrain_8010230
	bl battleObject_handleImpact_802CFF8
	bl hiveBlockHappensHere_802CEF4
	bl battle_incrementAllianceStatOnCollisionHit_801A6B4
	bl battle_buffTwoStatsPlus2OnEventF6_801A720
	bl applyChipAllianceEffect_8013AE4
	bl sub_801AF0E
	bl battle_applyFlattenHitStatus_800EB26
	bl sub_801A58E
	bl battleObject_clearChipSelectionOnAirShoe_801A2CC
	bl battle_toggleAllianceAndAccumulateCollisionToAiData_801A308
	bl object_calculateFinalDamage1
	bl battleObject_tickCounterTimer_801A420
	bl battle_objectClearPendingHitIfCollisionProcessed_8010198
	bl battle_clearInvisFlashTimer_801A648
	bl object_spawnHiteffect
locret_801ABB6:
	pop {r4,r7,pc}
	thumb_func_end battleObject_handleCollisionAndStatusTick_801AB40

// symdb: Per-frame collision/damage processing pipeline for an enemy battle object (r5): the enemy-side variant of the family, with a pause gate, AI hit hooks and HitModifierFinal flag reactions.
// symdb: void battleObject_processCollisionResultsForEnemy(u32 r5 /* battle object */) : r5 -> [r4 r5
// symdb: r10] (nz c v r0-r3, r12 clobbered for callers)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_processCollisionResultsForEnemy_801ABB8.yaml
	thumb_func_start battleObject_processCollisionResultsForEnemy_801ABB8
battleObject_processCollisionResultsForEnemy_801ABB8:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801AC6A
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801AC6A
	bl battle_isPaused
	tst r0, r0
	bne locret_801AC6A
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801AC6A
	bl battleObject_updateBarrierStatus_801A802
	bl object_updatePoisonPanelStatus_801A186
	bl object_tickIcePanelFreeze_801A36A
	bl battle_objectDieOnCollisionHit_801A6D6
	bl battle_aiAimTwoColumnsAheadOnSpecialPanel_801A75A
	bl battle_aiAddCounterFromCollision_8013B20
	bl battleObject_processPoisonTick_801026A
	ldrb r4, [r7,#oCollisionData_HitModifierFinal]
	mov r1, #0x3c 
	tst r4, r1
	beq loc_801AC46
	mov r1, #0x40 
	tst r4, r1
	beq loc_801AC32
	bl object_getFlag // () -> int
	mov r1, #0x40 
	tst r0, r1
	bne loc_801AC46
	mov r0, #1
	lsl r0, r0, #8
	bl object_setFlag2
	mov r0, #4
	bl object_clearFlag2
	mov r0, #1
	strb r0, [r5,#oBattleObject_Unk_0f]
	b loc_801AC46
loc_801AC32:
	bl object_getFlag // () -> int
	ldr r1, dword_801AF38 // =0x100040 
	tst r0, r1
	bne loc_801AC46
	mov r0, #0x10
	bl object_setFlag2
	mov r0, #1
	strb r0, [r5,#oBattleObject_Unk_0f]
loc_801AC46:
	bl battle_applyFlattenHitStatus_800EB26
	bl battleObject_applyStatusEffect_801A554
	bl battleObject_clearChipSelectionOnAirShoe_801A2CC
	bl battle_toggleAllianceAndAccumulateCollisionToAiData_801A308
	bl object_calculateFinalDamage1
	bl battleObject_tickCounterTimer_801A420
	bl battle_objectClearPendingHitIfCollisionProcessed_8010198
	bl battle_clearInvisFlashTimer_801A648
	bl object_spawnHiteffect
locret_801AC6A:
	pop {r4,r7,pc}
	thumb_func_end battleObject_processCollisionResultsForEnemy_801ABB8

// symdb: Per-frame collision resolution pipeline for the active battle object
// symdb: void sub_801AC6C(u32 r4, u32 r5, u32 r6, u32 r8, u32 r9, u32 r10, u32 r11, u32 r12) -> r5, r8,
// symdb: r9, r10, r11, r12; flags NZCV clobbered; r4 and r7 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObject_processCollisionResultsForPlayer_801AC6C.yaml
	thumb_func_start battleObject_processCollisionResultsForPlayer_801AC6C
battleObject_processCollisionResultsForPlayer_801AC6C:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801AD10
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801AD10
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801AD10
	bl battleObject_updateBarrierStatus_801A802
	bl object_updatePoisonPanelStatus_801A186
	bl object_tickIcePanelFreeze_801A36A
	bl battle_tickAiSelfDrain_8010230
	bl battleObject_handleImpact_802CFF8
	bl hiveBlockHappensHere_802CEF4
	bl battle_incrementAllianceStatOnCollisionHit_801A6B4
	bl battle_buffTwoStatsPlus2OnEventF6_801A720
	bl battleObject_applyStatusEffectOnTurnEnd_80139F6
	bl battleObject_applyHitModifierFlags_801AEB0
	bl battle_applyFlattenHitStatus_800EB26
	bl handlePanelDamage_8013F1E
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #7
	beq loc_801ACEC
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #7
	beq loc_801ACEC
	cmp r0, #0x13
	beq loc_801ACEC
	mov r1, #0x52 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	tst r0, r0
	bne loc_801ACEC
	bl battleObject_applyStatusEffect_801A554
loc_801ACEC:
	bl battleObject_clearChipSelectionOnAirShoe_801A2CC
	bl battle_applyCounterHealAndSpawnEffect_801A324
	bl object_calculateFinalDamage1
	bl battleObject_tickCounterTimer_801A420
	bl battle_runObjectAI_80143FC
	bl battleObject_checkAngerTrigger_80142DC
	bl battle_objectClearPendingHitIfCollisionProcessed_8010198
	bl battle_clearInvisFlashTimer_801A648
	bl object_spawnHiteffect
locret_801AD10:
	pop {r4,r7,pc}
	thumb_func_end battleObject_processCollisionResultsForPlayer_801AC6C

// symdb: Tear down / wind down a battle object's collision after a hit, applying the flag-0x100 shield effect when applicable, then recompute final damage and spawn the hit spark.
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> void ; side effects: clears sprite final-palette high
// symdb: nibble, frees or mutates CollisionData, sets ObjectFlags2 bits 0x100 / clears bit 0x4, writes
// symdb: object/0x0F = 1, recomputes FinalDamage, may spawn hit effect
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/object_finishCollisionHitReaction_801AD12.yaml
	thumb_func_start object_finishCollisionHitReaction_801AD12
object_finishCollisionHitReaction_801AD12:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801AD68
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801AD68
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801AD68
	ldrb r4, [r7,#oCollisionData_HitModifierFinal]
	bl object_getFlag // () -> int
	mov r1, #0x40 
	tst r0, r1
	bne loc_801AD60
	mov r1, #0x40 
	tst r4, r1
	beq loc_801AD60
	mov r0, #1
	lsl r0, r0, #8
	bl object_setFlag2
	mov r0, #4
	bl object_clearFlag2
	mov r0, #1
	strb r0, [r5,#oBattleObject_Unk_0f]
loc_801AD60:
	bl object_calculateFinalDamage2
	bl object_spawnHiteffect
locret_801AD68:
	pop {r4,r7,pc}
	thumb_func_end object_finishCollisionHitReaction_801AD12

	thumb_func_start sub_801AD6A
sub_801AD6A:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801AD9C
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801AD9C
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801AD9C
	bl object_calculateFinalDamage2
	bl object_spawnHiteffect
locret_801AD9C:
	pop {r4,r7,pc}
	thumb_func_end sub_801AD6A

// symdb: Applies a collision hit to a battle object: guards against battle flags/dead targets, on HitModifierFinal bit 0x40 marks the hit state (ObjectFlags2 0x100, clear 0x4, Unk_0f=1), then recomputes final damage and spawns the hit effect.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/object_applyCollisionHit_801AD9E.yaml
	thumb_func_start object_applyCollisionHit_801AD9E
object_applyCollisionHit_801AD9E:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801ADF8
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801ADF8
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801ADF8
	ldrb r4, [r7,#oCollisionData_HitModifierFinal]
	bl object_getFlag // () -> int
	mov r1, #0x40 
	tst r0, r1
	bne loc_801ADF0
	mov r1, #0x40 
	tst r4, r1
	beq loc_801ADF0
	mov r0, #1
	lsl r0, r0, #8
	bl object_setFlag2
	mov r0, #4
	bl object_clearFlag2
	bl sub_801A6A6
	mov r0, #1
	strb r0, [r5,#oBattleObject_Unk_0f]
loc_801ADF0:
	bl object_calculateFinalDamage2
	bl object_spawnHiteffect
locret_801ADF8:
	pop {r4,r7,pc}
	thumb_func_end object_applyCollisionHit_801AD9E

	thumb_func_start sub_801ADFA
sub_801ADFA:
	push {r4,r7,lr}
	bl sprite_clearFinalPalette
	ldr r7, [r5,#oBattleObject_CollisionDataPtr]
	bl battle_getFlags
	mov r1, #1
	tst r0, r1
	beq locret_801AE54
	bl object_removeCollisionData
	bl battle_isBattleOver
	tst r0, r0
	bne locret_801AE54
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne locret_801AE54
	bl sub_801AE56
	ldrb r4, [r7,#oCollisionData_HitModifierFinal]
	bl object_getFlag // () -> int
	mov r1, #0x40 
	tst r0, r1
	bne loc_801AE4C
	mov r1, #0x40 
	tst r4, r1
	beq loc_801AE4C
	mov r0, #1
	lsl r0, r0, #8
	bl object_setFlag2
	mov r0, #4
	bl object_clearFlag2
	mov r0, #1
	strb r0, [r5,#oBattleObject_Unk_0f]
loc_801AE4C:
	bl object_calculateFinalDamage2
	bl object_spawnHiteffect
locret_801AE54:
	pop {r4,r7,pc}
	thumb_func_end sub_801ADFA

	thumb_local_start
sub_801AE56:
	ldr r0, [r7,#oCollisionData_FlagsFromCollision]
	ldr r1, off_801AF3C // =0x1000 
	tst r0, r1
	bne locret_801AE90
	ldrb r0, [r7,#oCollisionData_HitModifierFinal]
	mov r1, #0x40 
	tst r0, r1
	bne locret_801AE90
	mov r1, #0
	ldr r0, [r7,#oCollisionData_FlagsFromCollision]
	ldr r3, dword_801AE98 // =0xa2000000 
	tst r3, r0
	beq loc_801AE72
	add r1, #1
loc_801AE72:
	ldr r3, dword_801AE9C // =0x51000000 
	tst r3, r0
	beq loc_801AE7A
	add r1, #2
loc_801AE7A:
	ldr r2, off_801AE94 // =byte_801AEA0
	ldrb r1, [r2,r1]
	cmp r1, #0xff
	beq locret_801AE90
	mov r2, #0x61 
	ldrb r3, [r7,r1]
	orr r3, r2
	strb r3, [r7,r1]
	ldrb r1, [r7,#oCollisionData_HitModifierFinal]
	orr r1, r2
	strb r1, [r7,#oCollisionData_HitModifierFinal]
locret_801AE90:
	mov pc, lr
	.balign 4, 0
off_801AE94:
	.word byte_801AEA0
dword_801AE98:
	.word 0xA2000000
dword_801AE9C:
	.word 0x51000000
byte_801AEA0:
	.byte 0xFF, 0xF, 0xF, 0xFF, 0xF, 0xFF, 0xFF, 0xFF, 0xF, 0xFF
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	thumb_func_end sub_801AE56

// symdb: Translate the HitModifierFinal byte of a battle object's collision data into ObjectFlags2 side-effects and Unk_0f updates.
// symdb: (r5 = BattleObject*, r7 = ?, lr) -> void (returns nothing to callers; r0/r1/r2/r4 are scratch
// symdb: and r4/r7/lr are restored)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_applyHitModifierFlags_801AEB0.yaml
	thumb_local_start
battleObject_applyHitModifierFlags_801AEB0:
	push {r4,r7,lr}
	ldrb r4, [r7,#oCollisionData_HitModifierFinal]
	bl object_getFlag // () -> int
	ldr r1, dword_801AF40 // =0x220000 superarmor or anger
	tst r0, r1
	bne loc_801AECA
	mov r1, #1
	tst r4, r1
	beq loc_801AECA
	mov r0, #4
	bl object_setFlag2
loc_801AECA:
	mov r1, #2
	tst r4, r1
	beq loc_801AED6
	mov r0, #2
	bl object_setFlag2
loc_801AED6:
	mov r1, #0x3c
	tst r4, r1
	beq locret_801AF0C
	mov r1, #0x40 
	tst r4, r1
	beq loc_801AEF8
	mov r0, #1
	lsl r0, r0, #8
	bl object_setFlag2
	mov r0, #4
	bl object_clearFlag2
	mov r0, #1
	strb r0, [r5,#oBattleObject_Unk_0f]
	strb r0, [r5,#oBattleObject_Unk_0f]
	b locret_801AF0C
loc_801AEF8:
	bl object_getFlag // () -> int
	ldr r1, dword_801AF38 // =0x100040 
	tst r0, r1
	bne locret_801AF0C
	mov r0, #0x10
	bl object_setFlag2
	mov r0, #1
	strb r0, [r5,#oBattleObject_Unk_0f]
locret_801AF0C:
	pop {r4,r7,pc}
	thumb_func_end battleObject_applyHitModifierFlags_801AEB0

	thumb_local_start
sub_801AF0E:
	push {r4,r7,lr}
	ldrb r4, [r7,#oCollisionData_HitModifierFinal]
	bl object_getFlag // () -> int
	ldr r1, dword_801AF40 // =0x220000 
	tst r0, r1
	bne loc_801AF28
	mov r1, #1
	tst r4, r1
	beq loc_801AF28
	mov r0, #4
	bl object_setFlag2
loc_801AF28:
	mov r1, #2
	tst r4, r1
	beq locret_801AF34
	mov r0, #2
	bl object_setFlag2
locret_801AF34:
	pop {r4,r7,pc}
	.balign 4, 0
dword_801AF38:
	.word 0x100040
off_801AF3C:
	.word 0x1000
dword_801AF40:
	.word 0x220000
	thumb_func_end sub_801AF0E

	thumb_func_start ai_eventuallyRunsAIAttack_801AF44
ai_eventuallyRunsAIAttack_801AF44:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r0, [sp]
	ldr r6, [r5,#oBattleObject_CollisionDataPtr]
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	bl battle_isPaused
	tst r0, r0
	beq loc_801AF5E
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq loc_801AF5E
	b loc_801B142
loc_801AF5E:
	bl battle_spawnHitEffectAtArm_801A42E
	bl battle_spawnArmHitEffect_801A4A6
	bl battle_handleCollisionCrouchSlideReset_801A45C
	bl battle_ai_markWindBoxReady_801A506
	bl applyDamageToPlayer_801ba12
	bl battleObject_clearCollisionIfHitAction_801BADE
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801AF84
	b loc_801B142
loc_801AF84:
	bl object_getFlag2
	mov r1, #1
	tst r0, r1
	beq loc_801AFA4
	mov r0, r1
	bl object_clearFlag2
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_INVULNERABLE
	bl object_setFlag1 // (int a1) -> void
	mov r0, #2
	bl object_setAttack0
	b loc_801B142
loc_801AFA4:
	bl GetAIDataUnk0x48Flag
	ldr r1, off_801B1AC // =0x2000 
	tst r0, r1
	beq loc_801AFB0
	b loc_801B18E
loc_801AFB0:
	bl GetAIDataUnk0x48Flag
	ldr r1, dword_801B1B4 // =0x10000 
	tst r0, r1
	beq loc_801AFBC
	b loc_801B18E
loc_801AFBC:
	bl GetAIDataUnk0x48Flag
	ldr r1, dword_801B1B8 // =0x20000 
	tst r0, r1
	beq loc_801AFC8
	b loc_801B18E
loc_801AFC8:
	bl GetAIDataUnk0x48Flag
	ldr r1, dword_801B1BC // =0x40000 
	tst r0, r1
	beq loc_801AFDC
	bl sub_8015766
	tst r0, r0
	beq loc_801AFDC
	b loc_801B1A0
loc_801AFDC:
	bl battle_isTimeStop
	beq loc_801AFE4
	b loc_801B142
loc_801AFE4:
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	bl GetAIData_Unk_44_Flag
	ldr r1, off_801B1A8 // =0x8000000
	tst r0, r1
	beq loc_801B006
	mov r0, r1
	bl ClearAIData_Unk_44_Flag
	ldr r0, off_801B1AC // =0x2000 
	bl SetAIDataUnk0x48Flag
	mov r0, #0x4c 
	bl object_setAttack0
	b loc_801B18E
loc_801B006:
	bl GetAIData_Unk_44_Flag
	ldr r1, dword_801B1B0 // =0x40000000 
	tst r0, r1
	beq loc_801B024
	mov r0, r1
	bl ClearAIData_Unk_44_Flag
	ldr r0, dword_801B1B4 // =0x10000 
	bl SetAIDataUnk0x48Flag
	mov r0, #0x30 
	bl object_setAttack0
	b loc_801B18E
loc_801B024:
	bl GetAIData_Unk_44_Flag
	ldr r1, dword_801B1C0 // =0x80000000 
	tst r0, r1
	beq loc_801B052
	mov r0, r1
	bl ClearAIData_Unk_44_Flag
	ldrh r0, [r5,#oBattleObject_NameID]
	ldr r1, off_801B38C // =0x1ac 
	cmp r0, r1
	blt loc_801B052
	add r1, #0x15
	cmp r0, r1
	bgt loc_801B052
	ldr r0, dword_801B1BC // =0x40000 
	bl SetAIDataUnk0x48Flag
	bl object_exitAttackState
	bl sub_8015766
	b loc_801B1A0
loc_801B052:
	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801B0AA
	mov r0, r1
	bl object_clearFlag2
	ldr r0, [r5,#oBattleObject_Unk_5c]
	tst r0, r0
	bne loc_801B06E
	ldr r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	str r0, [r5,#oBattleObject_Unk_5c]
loc_801B06E:
	bl ai_clearPwrAtkStateFromBattleObject_801011A
	bl battleObject_clearHitFlags_801A29A
	bl battleObject_resetCollisionState_801A2B0
	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #0xe
	tst r0, r1
	bne loc_801B096
	mov r1, #2
	tst r0, r1
	bne loc_801B092
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #4
	beq loc_801B096
loc_801B092:
	bl battle_object_clearFlagsAndCollisionCounter_801A284
loc_801B096:
	mov r0, #1
	lsl r0, r0, #0xe
	bl object_clearFlag2
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurPhase]
	strb r0, [r5,#oBattleObject_Unk_0d]
	b loc_801B142
loc_801B0AA:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x14
	tst r0, r1
	beq loc_801B0BC
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	b loc_801B142
loc_801B0BC:
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0d]
	bl object_getFlag2
	mov r1, #0x10
	tst r0, r1
	beq loc_801B0D6
	mov r0, r1
	bl object_clearFlag2
	bl battle_dispatchAIDispatchByType_80166B6
	b loc_801B0EC
loc_801B0D6:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0xc
	tst r0, r1
	beq loc_801B0E8
	bl battle_dispatchAIDispatchByType_80166B6
	b loc_801B0EC
loc_801B0E8:
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_1f]
loc_801B0EC:
	bl object_getFlag2
	mov r1, #4
	tst r0, r1
	beq loc_801B126
	mov r0, r1
	bl object_clearFlag2
	bl ai_clearPwrAtkStateFromBattleObject_801011A
	bl battle_object_postAction4CheckClearFlags_801BA92
	push {r0}
	bl battle_checkObjectAction6Flag_801BABE
	pop {r1}
	orr r0, r1
	beq loc_801B118
	mov r1, #2
	tst r0, r1
	bne loc_801B118
	b loc_801B11E
loc_801B118:
	mov r0, #3
	bl object_setAttack0
loc_801B11E:
	mov r0, #1
	lsl r0, r0, #0xe
	bl object_clearFlag2
loc_801B126:
	bl battleObject_handleFlashingInvisTick_801A5EE
	bl object_tickStatusEffectTimers_800E730
	bl battle_tickCollisionTimer_8010162
	bl battle_updatePlayerAngerState_8014326
	bl nullsub_6
	bl battle_tickPoisonHpLoss_8014498
	bl battle_DecrementAllianceTimer_802E1D8
loc_801B142:
	bl sprite_zeroColorShader
	mov r0, #1
	lsl r0, r0, #0xe
	bl object_clearFlag2
	bl battle_updateAngerTint_80143E4
	bl battle_applyStateSpriteColorShader_801690A
	bl battleObject_updateColorShader_8016860
	bl battle_applyStatusSpriteTint_80168C8
	bl object_applyTintIfFlag16_80168F0
	bl blindVisualHandledHere_8016934
	bl battleObject_applyEmotionShaderIfCounterReady_8016CA4
	bl battle_applyDimmerShaderTo_801728E
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne loc_801B18E
	bl battle_isPaused
	beq loc_801B188
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq loc_801B188
	b loc_801B19C
loc_801B188:
	bl battle_isTimeStop
	bne loc_801B196
loc_801B18E:
	ldr r0, [sp]
	bl RunAIAttack // (extra_ai_attack_jumptable: * [* Fn]) -> ()
	b loc_801B1A0
loc_801B196:
	bl battle_aiPlayerUseChipAction_8017AB4
	b loc_801B1A0
loc_801B19C:
	bl battle_ai_dispatchQueuedAttacks_8017BC0
loc_801B1A0:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	.word 0x40000
	.balign 4, 0
off_801B1A8:
	.word 0x8000000
off_801B1AC:
	.word 0x2000
dword_801B1B0:
	.word 0x40000000
dword_801B1B4:
	.word 0x10000
dword_801B1B8:
	.word 0x20000
dword_801B1BC:
	.word 0x40000
dword_801B1C0:
	.word 0x80000000
	thumb_func_end ai_eventuallyRunsAIAttack_801AF44

	thumb_func_start battle_801B1C4
battle_801B1C4:
	push {r6,r7,lr}

	.equiv stack_801B1C4_JumpTable, 0x00

	sub sp, sp, #4

	str r0, [sp, #stack_801B1C4_JumpTable]

	ldr r6, [r5,#oBattleObject_CollisionDataPtr]

	bl battle_isPaused
	tst r0, r0
	beq loc_801B21C /*+0e*/

	bl object_getFlag2
	ldr r1, dword_801B390 // =OBJECT_FLAGS_2_DO_UPDATE_COLLISION_PANELS
	tst r0, r1
	beq loc_801B1E8

	bl object_updateCollisionPanels
	ldr r0, dword_801B390 // =OBJECT_FLAGS_2_DO_UPDATE_COLLISION_PANELS
	bl object_clearFlag2

loc_801B1E8: // endif

	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq loc_801B21C

	bl object_getFlag // () -> int
	ldr r1, dword_801B384 // =OBJECT_FLAGS_UNK_30 | OBJECT_FLAGS_DEAD
	tst r0, r1
	beq loc_801B1FA
	// if OBJECT_FLAGS_UNK_30 set || OBJECT_FLAGS_DEAD set

	b loc_801B338

loc_801B1FA: // endif

	// return if OBJECT_FLAGS_2_UNK_BIT_15 not set
	bl object_getFlag2
	ldr r1, dword_801B388 // =OBJECT_FLAGS_2_UNK_BIT_15
	tst r0, r1
	beq loc_801B21A

	mov r0, r1
	bl object_clearFlag2

	ldr r0, dword_801B384 // =OBJECT_FLAGS_UNK_30 | OBJECT_FLAGS_DEAD
	bl object_setFlag1 // (int a1) -> void

	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAction]

	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]

	b loc_801B338

loc_801B21A:
	b locret_801B37A

loc_801B21C:

	bl battle_spawnHitEffectAtArm_801A42E
	bl battle_spawnArmHitEffect_801A4A6
	bl battle_handleCollisionCrouchSlideReset_801A45C
	bl battleObject_clearCollisionIfHitAction_801BADE

	mov r0, #oCollisionData_FinalDamage
	ldrh r0, [r6,r0]
	tst r0, r0
	beq loc_801B24E

	push {r0}
	bl sprite_forceWhitePalette
	mov r0, #SOUND_HIT_6D
	bl PlaySoundEffect
	bl battle_resetFlashingInvisTimer_801A67E
	pop {r0}

	bl object_subtractHP
	tst r1, r1
	beq loc_801B260

loc_801B24E:
	mov r0, #oCollisionData_PanelDamage6
	ldrh r0, [r6,r0]
	bl object_subtractHP
	bl battleObject_killIfBubbleFlag_801B9BC
	ldrh r0, [r5,#oBattleObject_HP]
	tst r0, r0
	bne loc_801B266

loc_801B260: // HP reached zero
	mov r0, #1
	bl object_setFlag2

loc_801B266:
	bl battleObject_onCollision_801A200

	// branch if OBJECT_FLAGS_DEAD set
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne loc_801B338

	bl object_getFlag2
	mov r1, #OBJECT_FLAGS_2_UNK_BIT_00
	tst r0, r1
	beq loc_801B298
	// if OBJECT_FLAGS_2_UNK_BIT_00 set

	mov r0, r1
	bl object_clearFlag2

	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_INVULNERABLE
	bl object_setFlag1 // (int a1) -> void

	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAction]

	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]

	b loc_801B338

loc_801B298: // endif

	bl battle_isTimeStop
	bne loc_801B338

	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]

	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #8 // OBJECT_FLAGS_2_UNK_BIT_08
	tst r0, r1
	beq loc_801B2D6
	// if OBJECT_FLAGS_2_UNK_BIT_08 set

	mov r0, r1
	bl object_clearFlag2

	bl battleObject_clearHitFlags_801A29A
	bl battleObject_resetCollisionState_801A2B0
	bl battle_object_postAction4CheckClearFlags_801BA92

	ldr r0, [r5,#oBattleObject_Unk_5c]
	tst r0, r0
	bne loc_801B2CA

	ldr r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	str r0, [r5,#oBattleObject_Unk_5c]

loc_801B2CA: // endif

	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]

	mov r0, #0
	strb r0, [r5,#oBattleObject_CurPhase]
	strb r0, [r5,#oBattleObject_Unk_0d]

	b loc_801B338

loc_801B2D6: // endif

	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x14 // OBJECT_FLAGS_IMMOBILIZED
	tst r0, r1
	beq loc_801B2E8
	// if OBJECT_FLAGS_IMMOBILIZED set

	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	b loc_801B338

loc_801B2E8: // endif

	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0d]

	bl object_getFlag2
	mov r1, #OBJECT_FLAGS_2_UNK_BIT_04
	tst r0, r1
	beq loc_801B302
	// if OBJECT_FLAGS_2_UNK_BIT_04 set

	mov r0, r1
	bl object_clearFlag2

	bl battle_dispatchAIDispatchByType_80166B6
	b loc_801B318

loc_801B302: // endif

	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #12 // OBJECT_FLAGS_SLIDING
	tst r0, r1
	beq loc_801B314
	// if OBJECT_FLAGS_SLIDING set

	bl battle_dispatchAIDispatchByType_80166B6
	b loc_801B318

loc_801B314: // endif

	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_1f]

loc_801B318:

	ldrh r0, [r6,#oCollisionData_FlashingInvisTimer]
	tst r0, r0
	beq loc_801B324

	sub r0, #1
	strh r0, [r6,#oCollisionData_FlashingInvisTimer]
	bgt loc_801B32C

loc_801B324:
	ldr r0, dword_801B380 // =OBJECT_FLAGS_FLASHING | OBJECT_FLAGS_INVIS
	bl object_clearFlag // (int bitfield) -> void
	b loc_801B334
loc_801B32C:
	mov r0, #1
	lsl r0, r0, #9 // OBJECT_FLAGS_FLASHING
	bl object_setFlag1 // (int a1) -> void
loc_801B334:
	bl object_tickStatusEffectTimers_800E730

loc_801B338:

	bl sprite_zeroColorShader

	mov r0, #1
	lsl r0, r0, #14 // OBJECT_FLAGS_2_UNK_BIT_14
	bl object_clearFlag2

	bl battle_applyStateSpriteColorShader_801690A
	bl battleObject_updateColorShader_8016860
	bl battle_applyStatusSpriteTint_80168C8
	bl object_applyTintIfFlag16_80168F0

	bl blindVisualHandledHere_8016934

	bl battleObject_applyEmotionShaderIfCounterReady_8016CA4

	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8 // OBJECT_FLAGS_DEAD
	tst r0, r1
	bne loc_801B36E
	// if OBJECT_FLAGS_DEAD clear

	bl battle_isTimeStop
	bne loc_801B376

loc_801B36E: // endif

	ldr r0, [sp, #stack_801B1C4_JumpTable]
	bl RunAIAttack // (extra_ai_attack_jumptable: * [* Fn]) -> ()
	b locret_801B37A

loc_801B376: // else

	bl stepBattleObjectWobble_8016BFC

locret_801B37A: // endif
	add sp, sp, #4
	pop {r6,r7,pc}
	.balign 4, 0
dword_801B380:
	.word OBJECT_FLAGS_FLASHING | OBJECT_FLAGS_INVIS
dword_801B384:
	.word OBJECT_FLAGS_UNK_30 | OBJECT_FLAGS_DEAD
dword_801B388:
	.word OBJECT_FLAGS_2_UNK_BIT_15
off_801B38C:
	.word 0x1AC
dword_801B390:
	.word OBJECT_FLAGS_2_DO_UPDATE_COLLISION_PANELS
	thumb_func_end battle_801B1C4

// symdb: Applies a battle object's pending collision damage (white flash, hit SFX, HP subtraction, defeat/status transitions) and then dispatches its CurAction handler from the caller-supplied table.
// symdb: void battleObject_dispatchActionHandler(r0 = handler table (function pointers indexed by
// symdb: CurAction*4), u32 r5 /* battle object */) : r0 r5 -> [r5 r10]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_dispatchActionHandler_801B394.yaml
	thumb_func_start battleObject_dispatchActionHandler_801B394
battleObject_dispatchActionHandler_801B394: // JP: 0x801b904
	push {r6,r7,lr}
	sub sp, sp, #4
	str r0, [sp]
	ldr r6, [r5,#oBattleObject_CollisionDataPtr]
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0x80
	ldrh r0, [r6,r0]
	tst r0, r0
	beq loc_801B3BC
	push {r0}
	bl sprite_forceWhitePalette
	mov r0, #SOUND_UNK_85
	bl PlaySoundEffect
	pop {r0}
	bl object_subtractHP
	tst r1, r1
	beq loc_801B3DA
loc_801B3BC:
	ldr r0, [r6,#oCollisionData_FlagsFromCollision]
	ldr r1, dword_801B4BC // =0xc800002 
	tst r0, r1
	beq loc_801B3CA
	mov r0, #0
	strh r0, [r5,#oBattleObject_HP]
	b loc_801B3DA
loc_801B3CA:
	bl object_getFlag2
	ldr r1, dword_801B4D0 // =0x8000 
	tst r0, r1
	bne loc_801B3DA
	ldrh r0, [r5,#oBattleObject_HP]
	tst r0, r0
	bne loc_801B3E0
loc_801B3DA:
	mov r0, #1
	bl object_setFlag2
loc_801B3E0:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne loc_801B4A2
	bl object_getFlag2
	mov r1, #1
	tst r0, r1
	beq loc_801B40E
	mov r0, r1
	bl object_clearFlag2
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_INVULNERABLE
	bl object_setFlag1 // (int a1) -> void
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	b loc_801B4A2
loc_801B40E:
	bl object_getFlag2
	ldr r1, off_801B4C0 // =0xc00 
	tst r0, r1
	beq loc_801B41E
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B428
loc_801B41E:
	bl object_getFlag // () -> int
	ldr r1, off_801B4C4 // =LCDControl 
	tst r0, r1
	beq loc_801B42E
loc_801B428:
	bl sub_8018002
	b loc_801B4B6
loc_801B42E:
	bl object_getFlag2
	ldr r1, off_801B4C8 // =0x3000 
	tst r0, r1
	beq loc_801B43E
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B448
loc_801B43E:
	bl object_getFlag // () -> int
	ldr r1, dword_801B4CC // =0x30000000 
	tst r0, r1
	beq loc_801B44E
loc_801B448:
	bl sub_801813A
	b loc_801B4B6
loc_801B44E:
	bl battle_isTimeStop
	beq loc_801B460
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq loc_801B4A2
	bl sub_801823C
	b loc_801B4B6
loc_801B460:
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801B48C
	mov r0, r1
	bl object_clearFlag2
	ldr r0, [r5,#oBattleObject_Unk_5c]
	tst r0, r0
	bne loc_801B480
	ldr r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	str r0, [r5,#oBattleObject_Unk_5c]
loc_801B480:
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurPhase]
	strb r0, [r5,#oBattleObject_Unk_0d]
	b loc_801B4A2
loc_801B48C:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x14
	tst r0, r1
	beq loc_801B49E
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	b loc_801B4A2
loc_801B49E:
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0d]
loc_801B4A2:
	bl sprite_zeroColorShader
	bl hideSummonsWhenBlind_80181F6
	ldrb r0, [r5,#oBattleObject_CurAction]
	lsl r0, r0, #2
	ldr r1, [sp]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
loc_801B4B6:
	add sp, sp, #4
	pop {r6,r7,pc}
	.balign 4, 0
dword_801B4BC:
	.word 0xC800002
off_801B4C0:
	.word 0xC00
off_801B4C4:
	.word LCDControl
off_801B4C8:
	.word 0x3000
dword_801B4CC:
	.word 0x30000000
dword_801B4D0:
	.word 0x8000
	thumb_func_end battleObject_dispatchActionHandler_801B394

	thumb_func_start sub_801B4D4
sub_801B4D4:
	push {r6,r7,lr}
	sub sp, sp, #4
	str r0, [sp]
	ldr r6, [r5,#oBattleObject_CollisionDataPtr]
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0x80
	ldrh r0, [r6,r0]
	tst r0, r0
	beq loc_801B4FC
	push {r0}
	bl sprite_forceWhitePalette
	mov r0, #SOUND_UNK_85
	bl PlaySoundEffect
	pop {r0}
	bl object_subtractHP
	tst r1, r1
	beq loc_801B516
loc_801B4FC:
	ldr r0, [r6,#oCollisionData_FlagsFromCollision]
	ldr r1, dword_801B5F8 // =0xc800002 
	tst r0, r1
	beq loc_801B506
	b loc_801B516
loc_801B506:
	bl object_getFlag2
	ldr r1, dword_801B60C // =0x8000 
	tst r0, r1
	bne loc_801B516
	ldrh r0, [r5,#oBattleObject_HP]
	tst r0, r0
	bne loc_801B51C
loc_801B516:
	mov r0, #1
	bl object_setFlag2
loc_801B51C:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne loc_801B5DE
	bl object_getFlag2
	mov r1, #1
	tst r0, r1
	beq loc_801B54A
	mov r0, r1
	bl object_clearFlag2
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_INVULNERABLE
	bl object_setFlag1 // (int a1) -> void
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	b loc_801B5DE
loc_801B54A:
	bl object_getFlag2
	ldr r1, off_801B5FC // =0xc00 
	tst r0, r1
	beq loc_801B55A
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B564
loc_801B55A:
	bl object_getFlag // () -> int
	ldr r1, off_801B600 // =LCDControl 
	tst r0, r1
	beq loc_801B56A
loc_801B564:
	bl sub_8018002
	b loc_801B5F2
loc_801B56A:
	bl object_getFlag2
	ldr r1, off_801B604 // =0x3000 
	tst r0, r1
	beq loc_801B57A
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B584
loc_801B57A:
	bl object_getFlag // () -> int
	ldr r1, dword_801B608 // =0x30000000 
	tst r0, r1
	beq loc_801B58A
loc_801B584:
	bl sub_801813A
	b loc_801B5F2
loc_801B58A:
	bl battle_isTimeStop
	beq loc_801B59C
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq loc_801B5DE
	bl sub_801823C
	b loc_801B5F2
loc_801B59C:
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801B5C8
	mov r0, r1
	bl object_clearFlag2
	ldr r0, [r5,#oBattleObject_Unk_5c]
	tst r0, r0
	bne loc_801B5BC
	ldr r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	str r0, [r5,#oBattleObject_Unk_5c]
loc_801B5BC:
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurPhase]
	strb r0, [r5,#oBattleObject_Unk_0d]
	b loc_801B5DE
loc_801B5C8:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x14
	tst r0, r1
	beq loc_801B5DA
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	b loc_801B5DE
loc_801B5DA:
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0d]
loc_801B5DE:
	bl sprite_zeroColorShader
	bl hideSummonsWhenBlind_80181F6
	ldrb r0, [r5,#oBattleObject_CurAction]
	lsl r0, r0, #2
	ldr r1, [sp]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
loc_801B5F2:
	add sp, sp, #4
	pop {r6,r7,pc}
	.balign 4, 0
dword_801B5F8:
	.word 0xC800002
off_801B5FC:
	.word 0xC00
off_801B600:
	.word LCDControl
off_801B604:
	.word 0x3000
dword_801B608:
	.word 0x30000000
dword_801B60C:
	.word 0x8000
	thumb_func_end sub_801B4D4

	thumb_func_start sub_801B610
sub_801B610:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r0, [sp]
	ldr r6, [r5,#oBattleObject_CollisionDataPtr]
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0x80
	ldrh r0, [r6,r0]
	tst r0, r0
	beq loc_801B638
	push {r0}
	bl sprite_forceWhitePalette
	mov r0, #SOUND_UNK_85
	bl PlaySoundEffect
	pop {r0}
	bl object_subtractHP
	tst r1, r1
	beq loc_801B656
loc_801B638:
	ldr r0, [r6,#oCollisionData_FlagsFromCollision]
	ldr r1, dword_801B738 // =0x800002 
	tst r0, r1
	beq loc_801B646
	mov r0, #0
	strh r0, [r5,#oBattleObject_HP]
	b loc_801B656
loc_801B646:
	bl object_getFlag2
	ldr r1, dword_801B73C // =0x8000 
	tst r0, r1
	bne loc_801B656
	ldrh r0, [r5,#oBattleObject_HP]
	tst r0, r0
	bne loc_801B65C
loc_801B656:
	mov r0, #1
	bl object_setFlag2
loc_801B65C:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne loc_801B71E
	bl object_getFlag2
	mov r1, #1
	tst r0, r1
	beq loc_801B68A
	mov r0, r1
	bl object_clearFlag2
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_INVULNERABLE
	bl object_setFlag1 // (int a1) -> void
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	b loc_801B71E
loc_801B68A:
	bl object_getFlag2
	ldr r1, off_801B740 // =0xc00 
	tst r0, r1
	beq loc_801B69A
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B6A4
loc_801B69A:
	bl object_getFlag // () -> int
	ldr r1, off_801B744 // =LCDControl 
	tst r0, r1
	beq loc_801B6AA
loc_801B6A4:
	bl sub_8018002
	b loc_801B732
loc_801B6AA:
	bl object_getFlag2
	ldr r1, off_801B748 // =0x3000 
	tst r0, r1
	beq loc_801B6BA
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B6C4
loc_801B6BA:
	bl object_getFlag // () -> int
	ldr r1, dword_801B74C // =0x30000000 
	tst r0, r1
	beq loc_801B6CA
loc_801B6C4:
	bl sub_801813A
	b loc_801B732
loc_801B6CA:
	bl battle_isTimeStop
	beq loc_801B6DC
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq loc_801B71E
	bl sub_801823C
	b loc_801B732
loc_801B6DC:
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801B708
	mov r0, r1
	bl object_clearFlag2
	ldr r0, [r5,#oBattleObject_Unk_5c]
	tst r0, r0
	bne loc_801B6FC
	ldr r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	str r0, [r5,#oBattleObject_Unk_5c]
loc_801B6FC:
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurPhase]
	strb r0, [r5,#oBattleObject_Unk_0d]
	b loc_801B71E
loc_801B708:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x14
	tst r0, r1
	beq loc_801B71A
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	b loc_801B71E
loc_801B71A:
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0d]
loc_801B71E:
	bl sprite_zeroColorShader
	bl hideSummonsWhenBlind_80181F6
	ldrb r0, [r5,#oBattleObject_CurAction]
	lsl r0, r0, #2
	ldr r1, [sp]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
loc_801B732:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_801B738:
	.word 0x800002
dword_801B73C:
	.word 0x8000
off_801B740:
	.word 0xC00
off_801B744:
	.word LCDControl
off_801B748:
	.word 0x3000
dword_801B74C:
	.word 0x30000000
	thumb_func_end sub_801B610

	thumb_func_start sub_801B750
sub_801B750:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r0, [sp]
	ldr r6, [r5,#oBattleObject_CollisionDataPtr]
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0x80
	ldrh r0, [r6,r0]
	tst r0, r0
	beq loc_801B778
	push {r0}
	bl sprite_forceWhitePalette
	mov r0, #SOUND_UNK_85
	bl PlaySoundEffect
	pop {r0}
	bl object_subtractHP
	tst r1, r1
	beq loc_801B796
loc_801B778:
	ldr r0, [r6,#oCollisionData_FlagsFromCollision]
	ldr r1, dword_801B870 // =0xc800002 
	tst r0, r1
	beq loc_801B786
	mov r0, #0
	strh r0, [r5,#oBattleObject_HP]
	b loc_801B796
loc_801B786:
	bl object_getFlag2
	ldr r1, dword_801B874 // =0x8000 
	tst r0, r1
	bne loc_801B796
	ldrh r0, [r5,#oBattleObject_HP]
	tst r0, r0
	bne loc_801B79C
loc_801B796:
	mov r0, #1
	bl object_setFlag2
loc_801B79C:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne loc_801B858
	bl object_getFlag2
	mov r1, #1
	tst r0, r1
	beq loc_801B7CA
	mov r0, r1
	bl object_clearFlag2
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_INVULNERABLE
	bl object_setFlag1 // (int a1) -> void
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	b loc_801B858
loc_801B7CA:
	bl object_getFlag2
	ldr r1, off_801BAFC // =0xc00 
	tst r0, r1
	beq loc_801B7DA
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B7E4
loc_801B7DA:
	bl object_getFlag // () -> int
	ldr r1, off_801BB00 // =LCDControl 
	tst r0, r1
	beq loc_801B7EA
loc_801B7E4:
	bl sub_8018002
	b loc_801B86C
loc_801B7EA:
	bl object_getFlag2
	ldr r1, off_801BB04 // =0x3000 
	tst r0, r1
	beq loc_801B7FA
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B804
loc_801B7FA:
	bl object_getFlag // () -> int
	ldr r1, dword_801BB08 // =0x30000000 
	tst r0, r1
	beq loc_801B80A
loc_801B804:
	bl sub_801813A
	b loc_801B86C
loc_801B80A:
	bl battle_isTimeStop
	beq loc_801B816
	bl sub_801823C
	b loc_801B86C
loc_801B816:
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801B842
	mov r0, r1
	bl object_clearFlag2
	ldr r0, [r5,#oBattleObject_Unk_5c]
	tst r0, r0
	bne loc_801B836
	ldr r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	str r0, [r5,#oBattleObject_Unk_5c]
loc_801B836:
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurPhase]
	strb r0, [r5,#oBattleObject_Unk_0d]
	b loc_801B858
loc_801B842:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x14
	tst r0, r1
	beq loc_801B854
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	b loc_801B858
loc_801B854:
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0d]
loc_801B858:
	bl sprite_zeroColorShader
	bl hideSummonsWhenBlind_80181F6
	ldrb r0, [r5,#oBattleObject_CurAction]
	lsl r0, r0, #2
	ldr r1, [sp]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
loc_801B86C:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_801B870:
	.word 0xC800002
dword_801B874:
	.word 0x8000
	thumb_func_end sub_801B750

// symdb: Per-frame per-object "action state machine" step for a battle object: handles freeze/sleep/paralysis/flash damage reactions, then dispatches to a per-CurAction handler via the jump table in r0.
// symdb: (r0 = ptr to per-CurAction function table, r5 = BattleObject*) -> r0 = void ; side effects:
// symdb: writes to BattleObject (HP, CurAction, CurPhase, flags, PreventAnim, AIData+0x5c, etc.), plays
// symdb: sound 0x85 on hit, may re-white-palette/zero-shader via sprite helpers, tail-calls one of the
// symdb: CurAction handlers.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_runCurActionState_801B878.yaml
	thumb_func_start battleObject_runCurActionState_801B878
battleObject_runCurActionState_801B878:
	push {r6,r7,lr}
	sub sp, sp, #4
	str r0, [sp]
	ldr r6, [r5,#oBattleObject_CollisionDataPtr]
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0x80
	ldrh r0, [r6,r0]
	tst r0, r0
	beq loc_801B8A0
	push {r0}
	bl sprite_forceWhitePalette
	mov r0, #SOUND_UNK_85
	bl PlaySoundEffect
	pop {r0}
	bl object_subtractHP
	tst r1, r1
	beq loc_801B8C4
loc_801B8A0:
	ldr r0, [r6,#oCollisionData_FlagsFromCollision]
	ldr r1, dword_801B9A4 // =0xc800002 
	tst r0, r1
	beq loc_801B8B4
	ldr r0, [r5,#oBattleObject_ExtraVars+4]
	cmp r0, #0
	bne loc_801B8B4
	mov r0, #0
	strh r0, [r5,#oBattleObject_HP]
	b loc_801B8C4
loc_801B8B4:
	bl object_getFlag2
	ldr r1, dword_801B9B8 // =0x8000 
	tst r0, r1
	bne loc_801B8C4
	ldrh r0, [r5,#oBattleObject_HP]
	tst r0, r0
	bne loc_801B8CA
loc_801B8C4:
	mov r0, #1
	bl object_setFlag2
loc_801B8CA:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	bne loc_801B98C
	bl object_getFlag2
	mov r1, #1
	tst r0, r1
	beq loc_801B8F8
	mov r0, r1
	bl object_clearFlag2
	mov r0, #1
	lsl r0, r0, #OBJECT_FLAGS_INVULNERABLE
	bl object_setFlag1 // (int a1) -> void
	mov r0, #2
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strh r0, [r5,#oBattleObject_CurPhaseAndPhaseInitialized]
	b loc_801B98C
loc_801B8F8:
	bl object_getFlag2
	ldr r1, off_801B9A8 // =0xc00 
	tst r0, r1
	beq loc_801B908
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B912
loc_801B908:
	bl object_getFlag // () -> int
	ldr r1, off_801B9AC // =LCDControl 
	tst r0, r1
	beq loc_801B918
loc_801B912:
	bl sub_8018002
	b loc_801B9A0
loc_801B918:
	bl object_getFlag2
	ldr r1, off_801B9B0 // =0x3000 
	tst r0, r1
	beq loc_801B928
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	b loc_801B932
loc_801B928:
	bl object_getFlag // () -> int
	ldr r1, dword_801B9B4 // =0x30000000 
	tst r0, r1
	beq loc_801B938
loc_801B932:
	bl sub_801813A
	b loc_801B9A0
loc_801B938:
	bl battle_isTimeStop
	beq loc_801B94A
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #0
	beq loc_801B98C
	bl sub_801823C
	b loc_801B9A0
loc_801B94A:
	mov r0, #0
	strb r0, [r5,#oBattleObject_PreventAnim]
	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801B976
	mov r0, r1
	bl object_clearFlag2
	ldr r0, [r5,#oBattleObject_Unk_5c]
	tst r0, r0
	bne loc_801B96A
	ldr r0, [r5,#oBattleObject_CurStateActionPhaseAndPhaseInitialized]
	str r0, [r5,#oBattleObject_Unk_5c]
loc_801B96A:
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	mov r0, #0
	strb r0, [r5,#oBattleObject_CurPhase]
	strb r0, [r5,#oBattleObject_Unk_0d]
	b loc_801B98C
loc_801B976:
	bl object_getFlag // () -> int
	mov r1, #1
	lsl r1, r1, #0x14
	tst r0, r1
	beq loc_801B988
	mov r0, #5
	strb r0, [r5,#oBattleObject_CurAction]
	b loc_801B98C
loc_801B988:
	mov r0, #0
	strb r0, [r5,#oBattleObject_Unk_0d]
loc_801B98C:
	bl sprite_zeroColorShader
	bl hideSummonsWhenBlind_80181F6
	ldrb r0, [r5,#oBattleObject_CurAction]
	lsl r0, r0, #2
	ldr r1, [sp]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
loc_801B9A0:
	add sp, sp, #4
	pop {r6,r7,pc}
	.balign 4, 0
dword_801B9A4:
	.word 0xC800002
off_801B9A8:
	.word 0xC00
off_801B9AC:
	.word LCDControl
off_801B9B0:
	.word 0x3000
dword_801B9B4:
	.word 0x30000000
dword_801B9B8:
	.word 0x8000
	thumb_func_end battleObject_runCurActionState_801B878

// symdb: If the object's AIData says it's a clean-trigger kill and the related battle object has the 0x100 object flag (BUBBLED), set HP to 0 to mark it dead.
// symdb: (r5 = BattleObject*) -> void ; side effect: may zero oBattleObject_HP on the related object
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_killIfBubbleFlag_801B9BC.yaml
	thumb_local_start
battleObject_killIfBubbleFlag_801B9BC:
	push {r5,lr}
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	tst r3, r3
	beq locret_801B9E4
	ldrb r0, [r3,#oAIData_Unk_02]
	cmp r0, #1
	bne locret_801B9E4
	ldr r0, [r3,#oAIData_Unk_54]
	tst r0, r0
	beq locret_801B9E4
	push {r5}
	mov r5, r0
	bl object_getFlag // () -> int
	pop {r5}
	ldr r1, off_801BB0C // =0x100 
	tst r0, r1
	beq locret_801B9E4
	mov r0, #0
	strh r0, [r5,#oBattleObject_HP]
locret_801B9E4:
	pop {r5,pc}
	thumb_func_end battleObject_killIfBubbleFlag_801B9BC

// symdb: Runs one step of an enemy's "extra AI attack" script by dispatching through the caller's handler table or the shared AIAttackJumptable based on the object's CurAction.
// symdb: void battle_runAIAttackDispatcher_801b9e6(u32 **callerAttackTable /* r0 */, BattleObject *obj /*
// symdb: r5 */) — does not return to its own caller; the selected handler returns directly to
// symdb: RunAIAttack's caller. r4/r6/r7 are set to the object's aiData/aiState/attackVars for the
// symdb: handler, then restored. Flags NZC (and V) pass through to the handler.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/RunAIAttack.yaml
	thumb_local_start
RunAIAttack: // (extra_ai_attack_jumptable: * [* Fn]) -> ()
	push {r4,r6,r7,lr}
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	mov r6, #oAIData_AIState
	add r6, r6, r4 // r6 = AI state
	mov r7, #oAIData_AttackVars
	add r7, r7, r4 // r7 = current attack variable region

	ldrb r1, [r5,#oBattleObject_CurAction]
	cmp r1, #0x10
	blt loc_801BA08 /*+10*/

	sub r1, #0x10
	ldr r0, off_801BB10 // =AIAttackJumptable

	ldrb r2, [r7,#oAIAttackVars_Unk_1d]
	cmp r2, #1
	bne loc_801BA08 /*+1a*/

	bl sub_80EAD9C
	b locret_801BA10

loc_801BA08:
	// Index by CurAction * 4 or (CurAction - 0x10) * 4
	lsl r1, r1, #2
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
locret_801BA10:
	pop {r4,r6,r7,pc}
	thumb_func_end RunAIAttack

// symdb: Applies pending collision damage to the player battle object, clamping it for the undershirt/shield flag, playing the hurt SFX (or its dark-network variant), flashing the sprite white if alive, subtracting the collision HP-bar value, and handling death flags (AI alliance side vs normal object).
// symdb: void applyDamageToPlayer_801ba12(u32 player /* r5 */, u32 collision /* r6 */, u32 r10_val); /*
// symdb: inputs:  r5=player BattleObject*, r6=collision data*, r10 unused-and-preserved, lr=return
// symdb: outputs: r2 r4 r5 r6 r7 r10 (preserved per contract)    clobbers: N Z C V, r0 r1 r3, lr */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/applyDamageToPlayer_801ba12.yaml
	thumb_local_start
applyDamageToPlayer_801ba12:
	push {r4,lr}
	mov r0, #oCollisionData_FinalDamage
	ldrh r4, [r6,r0]
	tst r4, r4
	beq loc_801BA68
	mov r0, r4
	bl battle_aiAddTotalDamageTaken_8010548
	ldrh r1, [r5,#oBattleObject_HP]
	cmp r1, #1
	ble loc_801BA3A
	// undershirt?
	bl object_getFlag // () -> int
	ldr r1, dword_801BB14 // =0x40000 
	tst r0, r1
	beq loc_801BA3A
	ldrh r1, [r5,#oBattleObject_HP]
	cmp r1, r4
	bgt loc_801BA3A
	sub r4, r1, #1
loc_801BA3A:
	mov r0, r4
	bl object_subtractHP
	push {r1}
	mov r4, #0x6d 
	ldrh r0, [r5,#oBattleObject_NameID]
	bl unpackVerActorTyAndAIIdx_800F29C
	cmp r0, #2
	bne loc_801BA58
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	bne loc_801BA58
	mov r4, #0x6b 
loc_801BA58:
	mov r0, r4
	bl PlaySoundEffect
	pop {r1}
	tst r1, r1
	beq loc_801BA76
	bl sprite_forceWhitePalette
loc_801BA68:
	mov r0, #0x8c
	ldrh r0, [r6,r0]
	bl object_subtractHP
	ldrh r0, [r5,#oBattleObject_HP]
	tst r0, r0
	bne loc_801BA8C
loc_801BA76:
	bl battle_isAllianceActiveAndAiFlag0x4000_802DD2A
	tst r0, r0
	beq loc_801BA86
	ldr r0, off_801BB18 // =0x8000000
	bl SetAIData_Unk_44_Flag
	b loc_801BA8C
loc_801BA86:
	mov r0, #1
	bl object_setFlag2
loc_801BA8C:
	bl battleObject_onCollision_801A200
	pop {r4,pc}
	thumb_func_end applyDamageToPlayer_801ba12

// symdb: After a battle object finishes action 4, clears its flag2 bits and collision counter once its "done" condition is met.
// symdb: int battle_object_postAction4CheckClearFlags_801BA92(struct BattleObject* obj /* r5 */); returns
// symdb: 0 (not action 4), 1 (action 4 but still flagged/waiting), or 2 (flags just cleared); r4
// symdb: preserved, r0-r3 clobbered, flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_object_postAction4CheckClearFlags_801BA92.yaml
	thumb_local_start
battle_object_postAction4CheckClearFlags_801BA92:
	push {r4,lr}
	mov r4, #0
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #4
	bne loc_801BABA
	mov r4, #1
	bl object_getFlag2
	mov r1, #1
	lsl r1, r1, #0xe
	tst r0, r1
	bne loc_801BABA
	bl object_getFlag2
	mov r1, #2
	tst r0, r1
	beq loc_801BABA
	bl battle_object_clearFlagsAndCollisionCounter_801A284
	mov r4, #2
loc_801BABA:
	mov r0, r4
	pop {r4,pc}
	thumb_func_end battle_object_postAction4CheckClearFlags_801BA92

// symdb: Checks a battle object's current action and returns a state code: 0 if the action is not 6, 1 if action 6 without flag-2 bit set, and 2 if action 6 with flag-2 set, running sub_801A29A as a side effect in the last case.
// symdb: int battle_checkObjectActionFlag6(BattleObject *obj /* r5 */); returns 0/1/2 in r0; flags on
// symdb: exit reflect the returned value (final "mov r0, r4" is an adds r0, r4, #0).
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_checkObjectAction6Flag_801BABE.yaml
	thumb_local_start
battle_checkObjectAction6Flag_801BABE:
	push {r4,lr}
	mov r4, #0
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #6
	bne loc_801BADA
	mov r4, #1
	bl object_getFlag2
	mov r1, #2
	tst r0, r1
	beq loc_801BADA
	bl battleObject_clearHitFlags_801A29A
	mov r4, #2
loc_801BADA:
	mov r0, r4
	pop {r4,pc}
	thumb_func_end battle_checkObjectAction6Flag_801BABE

// symdb: If a battle object's current action is a hit (7) and a related field is non-zero, reset its collision state; returns 1 if a reset happened, else 0
// symdb: (r5 = AIData*, r6 = BattleObject*) -> r0 = 0/1 ; side effects: may call
// symdb: battleObject_resetCollisionState_801A2B0 (mutates r5's AIData+0x78 BattleObject pointer and
// symdb: BattleObject structure)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_clearCollisionIfHitAction_801BADE.yaml
	thumb_local_start
battleObject_clearCollisionIfHitAction_801BADE:
	push {r4,lr}
	mov r4, #0
	ldrb r0, [r5,#oBattleObject_CurAction]
	cmp r0, #7
	bne loc_801BAF6
	mov r0, #0x80
	ldrh r0, [r6,r0]
	cmp r0, #0
	beq loc_801BAF6
	bl battleObject_resetCollisionState_801A2B0
	mov r4, #1
loc_801BAF6:
	mov r0, r4
	pop {r4,pc}
	.balign 4, 0
off_801BAFC:
	.word 0xC00
off_801BB00:
	.word LCDControl
off_801BB04:
	.word 0x3000
dword_801BB08:
	.word 0x30000000
off_801BB0C:
	.word 0x100
off_801BB10:
	.word AIAttackJumptable
dword_801BB14:
	.word 0x40000
off_801BB18:
	.word 0x8000000
	thumb_func_end battleObject_clearCollisionIfHitAction_801BADE

// symdb: Attempts to claim (reserve) the panel under one object for another object, marking the panel reserved and flagging the reserving object; fails if there is no panel or it is already reserved.
// symdb: bool object_reservePanel(ObjectHeader *targetObject /*r0*/, u32 unused /*r1*/, ObjectHeader
// symdb: *reserverObject /*r5*/); returns 1 on successful reservation, 0 if the target has no panel or
// symdb: the panel is already reserved; sets NZ flags from the return value, clobbers r1-r3 (r2 carries
// symdb: the prior reserver pointer on failure)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_reservePanel.yaml
	thumb_func_start object_reservePanel
object_reservePanel: // JP: 0x801bf38
	push {lr}
	bl object_getPanelDataOffset
	tst r0, r0
	beq loc_801BB42
	ldr r2, [r0,#oPanelData_ReserverObjectPtr]
	tst r2, r2
	bne loc_801BB42
	str r5, [r0,#oPanelData_ReserverObjectPtr]
	ldr r1, [r0,#oPanelData_Flags]
	mov r2, #0x80
	orr r1, r2
	str r1, [r0,#oPanelData_Flags]
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #0x20 
	orr r0, r1
	strb r0, [r5,#oObjectHeader_Flags]
	mov r0, #1
	pop {pc}
loc_801BB42:
	mov r0, #0
	pop {pc}
	thumb_func_end object_reservePanel

// symdb: Releases a battle panel previously reserved by a given object, clearing its reserver pointer and reserved flag.
// symdb: int object_removePanelReserve(panelLookup r0/r1, void *requestingObject r5); returns 1 if the
// symdb: reservation was cleared, 0 otherwise; N/Z reflect the boolean result, C/V carry over from the
// symdb: reserver comparison on failure/success paths
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_removePanelReserve.yaml
	thumb_func_start object_removePanelReserve
object_removePanelReserve:
	push {lr}
	bl object_getPanelDataOffset
	tst r0, r0
	beq loc_801BB66
	ldr r1, [r0,#oPanelData_ReserverObjectPtr]
	cmp r1, r5
	bne loc_801BB66
	mov r1, #0
	str r1, [r0,#oPanelData_ReserverObjectPtr]
	ldr r1, [r0,#oPanelData_Flags]
	mov r2, #0x80
	bic r1, r2
	str r1, [r0,#oPanelData_Flags]
	mov r0, #1
	pop {pc}
loc_801BB66:
	mov r0, #0
	pop {pc}
	thumb_func_end object_removePanelReserve

	thumb_local_start
sub_801BB6A:
	push {lr}
	bl object_getPanelDataOffset
	tst r0, r0
	beq locret_801BB76
	ldr r0, [r0,#0x1c]
locret_801BB76:
	pop {pc}
	thumb_func_end sub_801BB6A

// symdb: Releases every panel reserve on the 7x4 battlefield that is owned by the given battle object, if that object holds any.
// symdb: void RemoveBattleObjectPanelReserves(ObjectHeader* obj /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/RemoveBattleObjectPanelReserves.yaml
	thumb_local_start
RemoveBattleObjectPanelReserves:
	push {r6,r7,lr}
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #0x20 
	tst r0, r1
	beq locret_801BBA8
	mov r7, #4
loc_801BB84:
	mov r6, #7
loc_801BB86:
	mov r0, r6
	mov r1, r7
	bl object_getPanelDataOffset
	cmp r0, #0
	beq loc_801BBA0
	ldr r1, [r0,#oPanelData_ReserverObjectPtr]
	cmp r1, r5
	bne loc_801BBA0
	mov r0, r6
	mov r1, r7
	bl object_removePanelReserve
loc_801BBA0:
	sub r6, #1
	bne loc_801BB86
	sub r7, #1
	bne loc_801BB84
locret_801BBA8:
	pop {r6,r7,pc}
	.balign 4, 0x00
	thumb_func_end RemoveBattleObjectPanelReserves

// symdb: Per-frame sprite ticker for one battle object — reloads the object's animation if it changed and advances it, skipping when the battle is paused, time is stopped, or the object's flags forbid updates.
// symdb: void object_updateSprite(r5 = battle object header ptr, r10 = battle state); trashes r0-r3,
// symdb: preserves r4; returns caller-facing r0/r1/N/Z from the last callee run (r2-r5 and C/V are pass-
// symdb: through leftovers)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_updateSprite.yaml
	thumb_func_start object_updateSprite
object_updateSprite:
	push {lr}
	bl battle_isPaused
	bne locret_801BBF2
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #1
	tst r0, r1
	beq locret_801BBF2
	mov r1, #8
	tst r0, r1
	bne locret_801BBF2
	mov r1, #0x10
	tst r0, r1
	bne loc_801BBCE
	bl battle_isTimeStop
	bne locret_801BBF2
loc_801BBCE:
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	tst r0, r0
	beq loc_801BBDA
	ldrb r0, [r5,#oBattleObject_PreventAnim]
	tst r0, r0
	bne locret_801BBF2
loc_801BBDA:
	ldrb r0, [r5,#oBattleObject_CurAnim]
	ldrb r1, [r5,#oBattleObject_CurAnimCopy]
	cmp r0, r1
	beq loc_801BBEE
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	ldrb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnimCopy]
loc_801BBEE:
	bl sprite_update
locret_801BBF2:
	pop {pc}
	thumb_func_end object_updateSprite

// symdb: Advances one battle object's sprite animation unless the battle is paused, the object has no sprite, or a time stop has frozen its animation.
// symdb: void object_updateSpriteTimestop(battle_object *obj /* r5 */, void *unused /* r4 */, void
// symdb: *unused2 /* r10 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_updateSpriteTimestop.yaml
	thumb_func_start object_updateSpriteTimestop
object_updateSpriteTimestop:
	push {lr}
	bl battle_isPaused
	bne locret_801BC22
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #1
	tst r0, r1
	beq locret_801BC22
	mov r1, #8
	tst r0, r1
	bne locret_801BC22
	ldrb r0, [r5,#oBattleObject_CurAnim]
	ldrb r1, [r5,#oBattleObject_CurAnimCopy]
	cmp r0, r1
	beq loc_801BC1E
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	ldrb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnimCopy]
loc_801BC1E:
	bl sprite_update
locret_801BC22:
	pop {pc}
	thumb_func_end object_updateSpriteTimestop

// symdb: Advance a battle object's sprite animation (load+set on change, update on no-change) unless paused/invisible/sprite-frozen or in a non-time-stopped state when the object isn't flagged to update during time-stop.
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> void ; side effects: may load sprite animation data, set
// symdb: sprite animation index, run sprite_update, write CurAnimCopy
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_tickSpriteAnim_801BC24.yaml
	thumb_func_start battleObject_tickSpriteAnim_801BC24
battleObject_tickSpriteAnim_801BC24:
	push {lr}
	bl battle_isPaused
	bne locret_801BC62
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #1
	tst r0, r1
	beq locret_801BC62
	mov r1, #8
	tst r0, r1
	bne locret_801BC62
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #0x10
	tst r0, r1
	bne loc_801BC48
	bl battle_isTimeStop
	bne locret_801BC62
loc_801BC48:
	ldrb r0, [r5,#oBattleObject_CurAnim]
	ldrb r1, [r5,#oBattleObject_CurAnimCopy]
	cmp r0, r1
	beq loc_801BC5E
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	ldrb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	pop {pc}
loc_801BC5E:
	bl sprite_update
locret_801BC62:
	pop {pc}
	thumb_func_end battleObject_tickSpriteAnim_801BC24

// symdb: Advances one battle object's sprite for the current frame, skipping it when inactive, sprite-update-locked, caught by an active timestop, or when collision-attached with animation locked.
// symdb: void UpdateBattleObjectSprite(struct BattleObject *obj /* r5 */, struct BattleSpriteState *state
// symdb: /* r10 */, lr /* lr */); returns nothing (NZ/C/V and r0..r5 left as last callee, or as the tst
// symdb: that branched)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/UpdateBattleObjectSprite.yaml
	thumb_func_start UpdateBattleObjectSprite
UpdateBattleObjectSprite:
	push {lr}
	ldrb r0, [r5,#oObjectHeader_Flags]

	mov r1, #OBJECT_FLAG_ACTIVE
	tst r0, r1
	beq .doNotUpdateSprite

	mov r1, #OBJECT_FLAG_STOP_SPRITE_UPDATE
	tst r0, r1
	bne .doNotUpdateSprite

	mov r1, #OBJECT_FLAG_UPDATE_DURING_TIMESTOP
	tst r0, r1
	bne .notTimestop

	bl battle_isTimeStop
	bne .doNotUpdateSprite

.notTimestop

	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	tst r0, r0
	beq .noCollision

	ldrb r0, [r5,#oBattleObject_PreventAnim]
	tst r0, r0
	bne .doNotUpdateSprite

.noCollision

	ldrb r0, [r5,#oBattleObject_CurAnim]
	ldrb r1, [r5,#oBattleObject_CurAnimCopy]
	cmp r0, r1
	beq .animNotChanged

	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	ldrb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnimCopy]

.animNotChanged

	bl sprite_update

.doNotUpdateSprite

	pop {pc}
	thumb_func_end UpdateBattleObjectSprite

// symdb: Steps the sprite of a battle object whose logic is paused (time-stop immune), syncing its sprite animation state to the object's currently selected animation and advancing one frame.
// symdb: void object_updatePausedSprite_801BCA6(u32 obj /* r5 */, void *ctx /* r10 */); // uses lr;
// symdb: clobbers nzcv r0-r5 (no other clobber contract)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_updateSpritePaused.yaml
	thumb_func_start object_updateSpritePaused
object_updateSpritePaused:
	push {lr}
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #1
	tst r0, r1
	beq locret_801BCCE
	bl battle_isTimeStop
	bne locret_801BCCE
	ldrb r0, [r5,#oBattleObject_CurAnim]
	ldrb r1, [r5,#oBattleObject_CurAnimCopy]
	cmp r0, r1
	beq loc_801BCCA
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	ldrb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnimCopy]
loc_801BCCA:
	bl sprite_update
locret_801BCCE:
	pop {pc}
	thumb_func_end object_updateSpritePaused

// symdb: Refreshes a battle object's sprite animation index whenever CurAnim changes, then ticks the sprite one frame.
// symdb: (r5 = BattleObject* this, lr = return) -> (r0, r1, r2, r3 clobbered; r4, r5, lr preserved for
// symdb: tail-call; void return)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_updateSpriteAnimIfChanged_801BCD0.yaml
	thumb_func_start battleObject_updateSpriteAnimIfChanged_801BCD0
battleObject_updateSpriteAnimIfChanged_801BCD0:
	push {lr}
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #8
	tst r0, r1
	bne locret_801BCF2
	ldrb r0, [r5,#oBattleObject_CurAnim]
	ldrb r1, [r5,#oBattleObject_CurAnimCopy]
	cmp r0, r1
	beq loc_801BCEE
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	ldrb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnimCopy]
loc_801BCEE:
	bl sprite_update
locret_801BCF2:
	pop {pc}
	thumb_func_end battleObject_updateSpriteAnimIfChanged_801BCD0

// symdb: Battle-object per-frame animation dispatcher: applies pause/timestop/stop-sprite-update flags, syncs CurAnim into the sprite slot, loads frame data, and ticks sprite_update.
// symdb: (r5 = BattleObject*) -> void ; side effects: reads/writes object header flags and sprite slot;
// symdb: calls sprite_setAnimation / sprite_loadAnimationData / sprite_update.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_animationAndSpriteUpdate_801BCF4.yaml
	thumb_func_start battleObject_animationAndSpriteUpdate_801BCF4
battleObject_animationAndSpriteUpdate_801BCF4:
	push {lr}
	bl battle_isPaused
	bne locret_801BD3A
	ldrb r0, [r5,#oObjectHeader_Flags]
	mov r1, #1
	tst r0, r1
	beq locret_801BD3A
	mov r1, #8
	tst r0, r1
	bne locret_801BD3A
	mov r1, #0x10
	tst r0, r1
	bne loc_801BD16
	bl battle_isTimeStop
	bne locret_801BD3A
loc_801BD16:
	ldr r0, [r5,#oBattleObject_CollisionDataPtr]
	tst r0, r0
	beq loc_801BD22
	ldrb r0, [r5,#oBattleObject_PreventAnim]
	tst r0, r0
	bne locret_801BD3A
loc_801BD22:
	ldrb r0, [r5,#oBattleObject_CurAnim]
	ldrb r1, [r5,#oBattleObject_CurAnimCopy]
	cmp r0, r1
	beq loc_801BD36
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	ldrb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnimCopy]
loc_801BD36:
	bl sprite_update
locret_801BD3A:
	pop {pc}
	thumb_func_end battleObject_animationAndSpriteUpdate_801BCF4

	thumb_func_start sub_801BD3C
sub_801BD3C:
	push {r4,r6,r7,lr}
	mov r6, r8
	push {r6}
	mov r8, r7
	push {r0-r3}
	mov r0, r4
	bl object_getAllianceDirection
	mov r6, r0
	pop {r0-r3}
	lsl r3, r3, #0x19
	bcs loc_801BDA2
	beq loc_801BD9C
	lsr r3, r3, #0x17
	ldr r7, off_801BE68 // =PanelOffsetListsPointerTable
	ldr r7, [r7,r3]
	mov r3, #0
loc_801BD5E:
	push {r0,r1}
	ldrsb r4, [r7,r3]
	cmp r4, #0x7f
	beq loc_801BD9A
	mul r4, r6
	add r0, r0, r4
	add r3, #1
	ldrsb r4, [r7,r3]
	add r1, r1, r4
	add r3, #1
	push {r0-r3}
	bl object_isValidPanel
	tst r0, r0
	pop {r0-r3}
	beq loc_801BD96
	push {r0-r3}
	push {r2}
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	pop {r2}
	mov r4, r2
	mov r2, r1
	mov r1, r0
	mov r3, r8
	bl spawn_t1_0x0_EffectObject
	pop {r0-r3}
loc_801BD96:
	pop {r0,r1}
	b loc_801BD5E
loc_801BD9A:
	pop {r0,r1}
loc_801BD9C:
	pop {r0}
	mov r8, r0
	pop {r4,r6,r7,pc}
loc_801BDA2:
	lsr r3, r3, #0x16
	mov r4, r2
	mov r1, #3
	ldr r7, off_801BE6C // =byte_8019C34
	add r7, r7, r3
	ldr r2, [r7]
	ldr r3, [r7,#4]
loc_801BDB0:
	mov r0, #6
loc_801BDB2:
	push {r0-r3}
	bl object_checkPanelParameters
	tst r0, r0
	pop {r0-r3}
	beq loc_801BDD0
	push {r0-r3}
	bl object_getCoordinatesForPanels // (int a1, int a2) -> (int n1, int n2)
	mov r2, r1
	mov r1, r0
	mov r3, #0
	bl spawn_t1_0x0_EffectObject
	pop {r0-r3}
loc_801BDD0:
	sub r0, #1
	bne loc_801BDB2
	sub r1, #1
	bne loc_801BDB0
	pop {r0}
	mov r8, r0
	pop {r4,r6,r7,pc}
	thumb_func_end sub_801BD3C

	thumb_func_start AddRandomVarianceToTwoCoords
// adds variance to input coords determined by randint(-mask/2,mask/2+1)
// randint is inclusive
// input args seem to (always?) be X and Z
// symdb: Jitters two coordinates by a centered random offset (range set by a mask), applied in the high half of a fixed-point value, using one GetRNG roll for both.
// symdb: void AddRandomVarianceToTwoCoords(u32 mask in r0, s32* coordA in r1, s32* coordB in r3); returns
// symdb: updated r1 and r3; r2, r4, r6, r7 preserved; clobbers r0 and the NZCV flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/AddRandomVarianceToTwoCoords.yaml
AddRandomVarianceToTwoCoords:
	push {r4,r6,r7,lr}
	push {r0-r3}
	bl GetRNG // () -> u32?
	mov r7, r0
	pop {r0-r3}
	mov r4, r7
	// r4 = RNG() & r0
	and r4, r0
	// r4 = (RNG() & r0) - (r0>>1)
	lsr r6, r0, #1
	sub r4, r4, r6
	lsl r4, r4, #0x10
	// r1 += ((RNG() & r0) - (r0>>1))<<16
	add r1, r1, r4
	lsr r7, r7, #0x10
	and r7, r0
	lsr r0, r0, #1
	sub r7, r7, r0
	lsl r7, r7, #0x10
	// r3 += ((RNG() >> 16) & r0 - (r0>>1))<<16
	add r3, r3, r7
	pop {r4,r6,r7,pc}
	thumb_func_end AddRandomVarianceToTwoCoords

// symdb: Computes an 8-way direction bitmask describing which of the 8 grid directions point B lies in relative to point A (i.e. the step needed to go from A toward B).
// symdb: u32 calc8DirBitmaskTowardsPoint(s32 x_a /*r0*/, s32 y_a /*r1*/, s32 x_b /*r2*/, s32 y_b /*r3*/);
// symdb: returns direction bits in r0; leaves C/V set from the final SUBS r1, r1, r3 (callers may rely on
// symdb: this)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/calc8DirBitmaskTowardsPoint_801BE04.yaml
	thumb_func_start calc8DirBitmaskTowardsPoint_801BE04
calc8DirBitmaskTowardsPoint_801BE04:
	sub r0, r0, r2
	bgt loc_801BE0E
	blt loc_801BE12
	mov r0, #0
	b loc_801BE14
loc_801BE0E:
	mov r0, #8
	b loc_801BE14
loc_801BE12:
	mov r0, #4
loc_801BE14:
	sub r1, r1, r3
	bgt loc_801BE22
	blt loc_801BE1E
	mov r1, #0
	b loc_801BE24
loc_801BE1E:
	mov r1, #1
	b loc_801BE24
loc_801BE22:
	mov r1, #2
loc_801BE24:
	orr r0, r1
	mov pc, lr
	thumb_func_end calc8DirBitmaskTowardsPoint_801BE04

// symdb: Empty stub function that does nothing and immediately returns; placeholder left in the build.
// symdb: void nullsub_10(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_10.yaml
	thumb_func_start nullsub_10
nullsub_10:
	mov pc, lr
	thumb_func_end nullsub_10

	thumb_func_start sub_801BE2A
sub_801BE2A:
	push {r6,r7,lr}
	mov r6, r0
	mov r0, #0x80
	lsl r1, r6, #0x10
	lsr r1, r1, #0x18
	lsl r2, r6, #0x18
	lsr r2, r2, #0x18
	bl sprite_load // (int a1, int a2, int a3) ->
	bl sprite_loadAnimationData // () -> void
	lsr r0, r6, #0x18
	tst r0, r0
	beq loc_801BE4C
	bl sprite_hasShadow
	b loc_801BE50
loc_801BE4C:
	bl sprite_noShadow // () -> void
loc_801BE50:
	lsl r0, r6, #8
	lsr r0, r0, #0x18
	strb r0, [r5,#oBattleObject_CurAnim]
	mov r0, #0xff
	strb r0, [r5,#oBattleObject_CurAnimCopy]
	bl object_getFlip // () -> int
	bl sprite_setFlip
	mov r0, #1
	pop {r6,r7,pc}
	.balign 4, 0
off_801BE68:
	.word PanelOffsetListsPointerTable
off_801BE6C:
	.word byte_8019C34
	thumb_func_end sub_801BE2A

// symdb: Resets a battery of battle-related RAM buffers to zero and initialises the main one.
// symdb: void sub_801BE70(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/resetBattleBuffers_801BE70.yaml
	thumb_func_start resetBattleBuffers_801BE70
resetBattleBuffers_801BE70:
	push {lr}
	// memBlock
	ldr r0, off_801BFE8 // =eStruct2035280
	// size
	mov r1, #0x60 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r2, #0x20 
	ldr r1, off_801BFE8 // =eStruct2035280
	strh r2, [r1,#0x22] // (word_20352A2 - 0x2035280)
	mov r2, #0
	sub r2, #1
	strh r2, [r1,#0x26] // (word_20352A6 - 0x2035280)
	// memBlock
	ldr r0, off_801BEA8 // =dword_20352E0 
	// size
	mov r1, #0x30 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	// memBlock
	ldr r0, off_801BEAC // =byte_203EB50 
	// size
	mov r1, #0x50 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	ldr r0, off_801BEB0 // =dword_203CA48 
	mov r1, #0
	str r1, [r0]
	str r1, [r0,#0x4] // (dword_203CA4C - 0x203ca48)
	ldr r1, off_801BEB4 // =dword_20367E0 
	mov r0, #0
	str r0, [r1]
	pop {pc}
	.balign 4, 0
off_801BEA8:
	.word dword_20352E0
off_801BEAC:
	.word byte_203EB50
off_801BEB0:
	.word dword_203CA48
off_801BEB4:
	.word dword_20367E0
	thumb_func_end resetBattleBuffers_801BE70

// symdb: Sets caller-supplied bit(s) in the flag word at eStruct2035280+0x44 (ORs r0 into it) and returns the updated word in r2.
// symdb: void sub_801BEB8(u32 bits /* r0 */); out: r1 = eStruct2035280, r2 = updated word, NZ flags set
// symdb: from result
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/flagSetBits_eStruct2035280_801BEB8.yaml
	thumb_func_start flagSetBits_eStruct2035280_801BEB8
flagSetBits_eStruct2035280_801BEB8:
	ldr r1, off_801BFE8 // =eStruct2035280
	ldr r2, [r1,#0x44] // (dword_20352C4 - 0x2035280)
	orr r2, r0
	str r2, [r1,#0x44] // (dword_20352C4 - 0x2035280)
	mov pc, lr
	thumb_func_end flagSetBits_eStruct2035280_801BEB8

// symdb: Clears (turns off) the flag bits selected by the mask in r0 in the flag word at eStruct2035280+0x44.
// symdb: u32 flags_clearBits_20352C4(u32 mask) // in: r0 = bit mask; out: r1 = eStruct2035280, r2 =
// symdb: updated flag word, NZ flags set from it
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/flags_clearBits_20352C4_801BEC2.yaml
	thumb_func_start flags_clearBits_20352C4_801BEC2
flags_clearBits_20352C4_801BEC2:
	ldr r1, off_801BFE8 // =eStruct2035280
	ldr r2, [r1,#0x44] // (dword_20352C4 - 0x2035280)
	bic r2, r0
	str r2, [r1,#0x44] // (dword_20352C4 - 0x2035280)
	mov pc, lr
	thumb_func_end flags_clearBits_20352C4_801BEC2

// symdb: ORs the given bit mask into the request/flag dword at eStruct2035280+0x40 (dword_20352C0).
// symdb: void eStruct2035280_SetRequestBits(u32 bits /* r0 */); // leaves struct ptr in r1 and updated
// symdb: dword in r2, sets/clears NZ from the OR result
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eStruct2035280_SetRequestBits_801BECC.yaml
	thumb_func_start eStruct2035280_SetRequestBits_801BECC
eStruct2035280_SetRequestBits_801BECC:
	ldr r1, off_801BFE8 // =eStruct2035280
	ldr r2, [r1,#0x40] // (dword_20352C0 - 0x2035280)
	orr r2, r0
	str r2, [r1,#0x40] // (dword_20352C0 - 0x2035280)
	mov pc, lr
	thumb_func_end eStruct2035280_SetRequestBits_801BECC

// symdb: Clears the bits selected by the mask in r0 within the flags word at dword_20352C0 and leaves the updated value's NZ flags set for caller branching.
// symdb: void flags_clearBits_eStruct2035280(u32 mask /* r0 */) -> returns u32 base in r1, u32 newValue
// symdb: in r2, flags NZ from newValue
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/flags_clearBits_eStruct2035280_801BED6.yaml
	thumb_func_start flags_clearBits_eStruct2035280_801BED6
flags_clearBits_eStruct2035280_801BED6:
	ldr r1, off_801BFE8 // =eStruct2035280
	ldr r2, [r1,#0x40] // (dword_20352C0 - 0x2035280)
	bic r2, r0
	str r2, [r1,#0x40] // (dword_20352C0 - 0x2035280)
	mov pc, lr
	thumb_func_end flags_clearBits_eStruct2035280_801BED6

// symdb: Iterates a 16-bit dispatch mask at Struct2035280+0x40 and calls matching battle update handlers in order until exhausted
// symdb: (no explicit return; pairs of `[mask_bit, handler]` are walked LSB-first) -> void; side effects:
// symdb: invokes a sequence of battle handlers
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_dispatchFlaggedUpdates_801BEE0.yaml
	thumb_func_start battle_dispatchFlaggedUpdates_801BEE0
battle_dispatchFlaggedUpdates_801BEE0:
	push {r5-r7,lr}
	ldr r5, off_801BFE8 // =eStruct2035280
	ldr r6, off_801BF00 // =off_801BF04 
	ldr r7, [r5,#0x40] // (dword_20352C0 - 0x2035280)
loc_801BEE8:
	lsr r7, r7, #1
	bcs loc_801BEF2
	beq locret_801BEFC
	add r6, #4
	b loc_801BEE8
loc_801BEF2:
	ldr r0, [r6]
	mov lr, pc
	bx r0
	add r6, #4
	b loc_801BEE8
locret_801BEFC:
	pop {r5-r7,pc}
	.balign 4, 0
off_801BF00:
	.word off_801BF04
off_801BF04:
	.word battle_loadChipPreviewGfxInit_801BFEE+1
	.word battle_loadChipPreviewGfxDefault_801BFF8+1
	.word battleObject_updateHPMeters_801C168+1
	.word sub_801C368+1
	.word battleObject_tickCustomGauge_801C470+1
	.word sub_801C4AE+1
	.word nullsub_58+1
	.word battle_tickLowHpWarning_801C840+1
	.word object_countdownTimer_801CA0C+1
	.word nullsub_58+1
	.word battle_initObjectStoryFlags_801C984+1
	.word nullsub_58+1
	.word sub_801CA28+1
	.word nullsub_58+1
	.word battleObject_updateAnimAndState_801CADC+1
	.word sub_801CE28+1
	.word sub_801D1D8+1
	.word battle_playCounterHitSound_801C5F4+1
	.word sub_801D2A0+1
	.word sub_801D450+1
	.word sub_801D514+1
	.word sub_801D548+1
	.word sub_801D590+1
	.word sub_801D71A+1
	thumb_func_end battle_dispatchFlaggedUpdates_801BEE0

// symdb: Run the callbacks whose bits are set in eStruct2035280+0x44, lowest bit first.
// symdb: (r10) -> for each set bit k of [eStruct2035280 + 0x44]: call off_801BF88[k]; r5-r7 preserved
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/runFlaggedCallbacks_801BF64.yaml
	thumb_func_start runFlaggedCallbacks_801BF64
runFlaggedCallbacks_801BF64:
	push {r5-r7,lr}
	ldr r5, off_801BFE8 // =eStruct2035280
	ldr r6, off_801BF84 // =off_801BF88 
	ldr r7, [r5,#0x44] // (dword_20352C4 - 0x2035280)
loc_801BF6C:
	lsr r7, r7, #1
	bcs loc_801BF76
	beq locret_801BF80
	add r6, #4
	b loc_801BF6C
loc_801BF76:
	ldr r0, [r6]
	mov lr, pc
	bx r0
	add r6, #4
	b loc_801BF6C
locret_801BF80:
	pop {r5-r7,pc}
	.balign 4, 0
off_801BF84:
	.word off_801BF88
off_801BF88:
	.word battle_RequestEndBattle_801C06E+1
	.word battle_drawChipCountsOAMWithRetvalZero_801C078+1
	.word battle_renderHpOverlays_801C202+1
	.word sub_801C416+1
	.word battle_drawTimerTiles_801C4E4+1
	.word sub_801C576+1
	.word battle_drawSelectedChipNameAndDamage_801C6EE+1
	.word sub_801C906+1
	.word nullsub_58+1
	.word sub_801C9E4+1
	.word syncCurrentFieldsAndNotify_801C9A4+1
	.word nullsub_58+1
	.word sub_801CA34+1
	.word sub_801CA80+1
	.word palette_QueueObjectPalettePair_801CDEC+1
	.word state_dispatchHandler_801CF0E+1
	.word sub_801D1F6+1
	.word battle_drawOrderBGSelectionArrows_801C640+1
	.word sub_801D2A4+1
	.word sub_801D47A+1
	.word nullsub_58+1
	.word sub_801D564+1
	.word sub_801D65C+1
	.word sub_801D792+1
off_801BFE8:
	.word eStruct2035280
	thumb_func_end runFlaggedCallbacks_801BF64

// symdb: Empty stub that immediately returns to the caller; performs no game action.
// symdb: void nullsub_58(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_58.yaml
	thumb_local_start
nullsub_58:
	mov pc, lr
	thumb_func_end nullsub_58

// symdb: Battle chip-preview GFx init trampoline that passes the "open chip preview" flag (=1) into sub_801C002, which is the project's hand-table chip-preview GFX loader.
// symdb: (none — only uses callee-saved r4, r6, r7, r10, lr) -> void ; side effects: triggers the chip-
// symdb: preview GFX load via r0=1
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_loadChipPreviewGfxInit_801BFEE.yaml
	thumb_local_start
battle_loadChipPreviewGfxInit_801BFEE:
	push {lr}
	mov r0, #1
	bl battle_loadChipPreviewGfxFromHandTable_801C002
	pop {pc}
	thumb_func_end battle_loadChipPreviewGfxInit_801BFEE

// symdb: Wrapper that calls sub_801C002 with r0=0 to load chip preview graphics from the hand table using default index 0
// symdb: (r0 = ...) -> r0 = ... ; side effects: clobbers r0-r3, may clobber r4-r7 (preserved), branches
// symdb: to sub_801C002
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_loadChipPreviewGfxDefault_801BFF8.yaml
	thumb_local_start
battle_loadChipPreviewGfxDefault_801BFF8:
	push {lr}
	mov r0, #0
	bl battle_loadChipPreviewGfxFromHandTable_801C002
	pop {pc}
	thumb_func_end battle_loadChipPreviewGfxDefault_801BFF8

// symdb: Loads the per-slot chip icon GFX (0x80 bytes per entry, 6 slots) for the chip-selection preview panel from the active-hand table, using either the chip database's sprite or a fixed "special effect" override tile.
// symdb: (r0 = actor_side_tag: 0 or 1) -> r0 = 0 ; side effects: 6 DMA queue ops into VRAM at
// symdb: 0x6016a00..0x6016c80
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_loadChipPreviewGfxFromHandTable_801C002.yaml
	thumb_local_start
battle_loadChipPreviewGfxFromHandTable_801C002:
	push {r4,r6,r7,lr}
	push {r0}
	ldr r4, off_801C148 // =dword_20352E0 
	mov r6, #6
	ldr r7, dword_801C14C // =0x6016a00 
loc_801C00C:
	ldrb r0, [r4]
	cmp r0, #0
	beq loc_801C062
	ldrb r0, [r4,#3]
	ldr r1, [sp]
	cmp r0, r1
	bne loc_801C062
	ldr r0, [r4,#4]
	bl battle_getSelectedChipForUse_800ED90
	cmp r3, #0
	beq loc_801C062
	ldr r1, [sp]
	cmp r1, #1
	bne loc_801C048
	push {r0}
	bl GetBattleMode
	cmp r0, #1
	pop {r0}
	beq loc_801C048
	push {r0}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	pop {r0}
	beq loc_801C048
	ldr r0, off_801C160 // =dword_872CE94 
	b loc_801C05A
loc_801C048:
	ldr r2, dword_801C150 // =0xffff 
	cmp r0, r2
	bne loc_801C050
	mov r0, #0
loc_801C050:
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldr r0, [r0,#0x20]
loc_801C05A:
	mov r1, r7
	mov r2, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_801C062:
	add r4, #8
	add r7, #0x80
	sub r6, #1
	bne loc_801C00C
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	thumb_func_end battle_loadChipPreviewGfxFromHandTable_801C002

// symdb: Wrapper that passes 1 to sub_801C082, requesting the battle to end.
// symdb: void battle_RequestEndBattle_ADDRESS(void); // tail-calls sub_801C082(1)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_RequestEndBattle_801C06E.yaml
	thumb_local_start
battle_RequestEndBattle_801C06E:
	push {lr}
	mov r0, #1
	bl battle_drawChipCountsOAM_801C082
	pop {pc}
	thumb_func_end battle_RequestEndBattle_801C06E

// symdb: Trivial battle helper that calls battle_drawChipCountsOAM_801C082 with r0=0 and returns 0.
// symdb: () -> r0 = 0 ; side effects: delegates to battle_drawChipCountsOAM_801C082(r0=0)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_drawChipCountsOAMWithRetvalZero_801C078.yaml
	thumb_local_start
battle_drawChipCountsOAMWithRetvalZero_801C078:
	push {lr}
	mov r0, #0
	bl battle_drawChipCountsOAM_801C082
	pop {pc}
	thumb_func_end battle_drawChipCountsOAMWithRetvalZero_801C078

// symdb: Iterates an array of 6 chip-count OAM slots at dword_20352E0, projecting each owning battle object's screen X/Y and queuing an OAM entry for that actor's selected chip with a run of stacked OAM tiles.
// symdb: (r0 = playerAlliance?) -> r0 = 0 ; side effects: queues OAM entries via sub_802FE28
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_drawChipCountsOAM_801C082.yaml
	thumb_local_start
battle_drawChipCountsOAM_801C082:
	push {r4-r7,lr}
	push {r0}
	ldr r4, off_801C148 // =dword_20352E0 
	mov r6, #6
	ldr r7, dword_801C158 // =0xab50 
loc_801C08C:
	ldrb r0, [r4]
	cmp r0, #0
	beq loc_801C13A
	ldrb r0, [r4,#3]
	ldr r1, [sp]
	cmp r0, r1
	bne loc_801C13A
	push {r5}
	ldr r5, [r4,#4]
	bl GetAIDataUnk0x48Flag
	ldr r1, dword_801C164 // =0x100000 
	tst r0, r1
	pop {r5}
	bne loc_801C13A
	ldr r0, [r4,#4]
	bl battle_getSelectedChipForUse_800ED90
	cmp r3, #0
	beq loc_801C13A
	push {r6}
	mov r5, r3
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	bl object_getAllianceDirection
	push {r0}
	ldr r0, [r4,#4]
	ldrb r1, [r0,#0x17]
	ldrb r0, [r0,#0x16]
	bl object_getFlipDirection // (int a1, int a2) -> int
	push {r0}
	ldr r0, [r4,#4]
	add r0, #0x34 
	bl projectObjectToScreen_800362C
	cmp r2, #0
	beq loc_801C136
	ldr r2, [sp]
	ldr r3, [sp,#4]
	mul r3, r2
	lsl r3, r3, #3
	push {r0}
	mov r2, #1
	ldrsb r2, [r4,r2]
	ldr r3, [sp,#8]
	mul r2, r3
	pop {r0}
	sub r2, r2, r3
	add r0, r0, r2
	sub r0, #8
	ldr r2, dword_801C15C // =0x1ff 
	and r0, r2
	mov r2, #2
	ldrsb r2, [r4,r2]
	add r1, r1, r2
	mov r2, #0xff
	and r1, r2
	lsl r0, r0, #0x10
	add r6, r0, r1
loc_801C108:
	ldr r0, dword_801C154 // =0x40000000 
	mov r1, r7
	add r0, r0, r6
	mov r2, #2
	mov r3, r5
	add r3, #0xd0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldr r0, [sp,#4]
	ldr r1, [sp]
	mul r0, r1
	mov r1, #2
	lsl r1, r1, #0x10
	mul r1, r0
	sub r6, r6, r1
	lsr r0, r6, #8
	lsl r0, r0, #8
	sub r6, #2
	mov r1, #0xff
	and r6, r1
	orr r6, r0
	sub r5, #1
	bne loc_801C108
loc_801C136:
	add sp, sp, #8
	pop {r6}
loc_801C13A:
	add r4, #8
	add r7, #4
	sub r6, #1
	bne loc_801C08C
	add sp, sp, #4
	pop {r4-r7,pc}
	.balign 4, 0
off_801C148:
	.word dword_20352E0
dword_801C14C:
	.word 0x6016A00
dword_801C150:
	.word 0xFFFF
dword_801C154:
	.word 0x40000000
dword_801C158:
	.word 0xAB50
dword_801C15C:
	.word 0x1FF
off_801C160:
	.word dword_872CE94
dword_801C164:
	.word 0x100000
	thumb_func_end battle_drawChipCountsOAM_801C082

// symdb: Per-frame update loop that drives the 4 battle HP/Damage meter UI bars (read actor HP, dispatch into one of two update paths, store current HP back)
// symdb: () -> r0 = 1 ; side effects: writes 4 * 0x14-byte meter entries at `byte_203EB50`
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_updateHPMeters_801C168.yaml
	thumb_local_start
battleObject_updateHPMeters_801C168:
	push {r4,r6,lr}
	ldr r4, off_801C334 // =byte_203EB50 
	mov r6, #4
loc_801C16E:
	ldrb r1, [r4]
	mov r0, #1
	tst r1, r0
	beq loc_801C1C8
	ldr r2, [r4,#0xc]
	ldrh r0, [r4,#2]
	ldrh r1, [r2,#0x24]
	cmp r1, #0
	bne loc_801C186
	mov r0, #0
	strb r0, [r4]
	b loc_801C1C6
loc_801C186:
	mov r2, #0
	cmp r0, r1
	beq loc_801C19E
	blt loc_801C190
	mov r2, #4
loc_801C190:
	ldr r3, off_801C338 // =off_801C33C 
	ldr r2, [r3,r2]
	mov lr, pc
	bx r2
	ldr r2, dword_801C364 // =0xb0b0b0b 
	str r2, [r4,#0x10]
	b loc_801C1C6
loc_801C19E:
	ldr r2, [r4,#0xc]
	ldr r2, [r2,#0x54]
	ldrb r2, [r2,#8]
	cmp r2, #0
	beq loc_801C1B2
	mov r2, #1
	strb r2, [r4,#8]
	mov r2, #2
	strb r2, [r4,#9]
	b loc_801C1C6
loc_801C1B2:
	ldrb r1, [r4,#9]
	cmp r1, #0
	beq loc_801C1C8
	sub r1, #1
	strb r1, [r4,#9]
	bne loc_801C1C6
	mov r1, #0
	strb r1, [r4,#8]
	ldr r1, dword_801C364 // =0xb0b0b0b 
	str r1, [r4,#0x10]
loc_801C1C6:
	strh r0, [r4,#2]
loc_801C1C8:
	add r4, #0x14
	sub r6, #1
	bne loc_801C16E
	pop {r4,r6,pc}
	thumb_func_end battleObject_updateHPMeters_801C168

	thumb_local_start
sub_801C1D0:
	mov r2, #2
	strb r2, [r4,#8]
	mov r2, #0xa
	strb r2, [r4,#9]
	mov r2, r1
	sub r2, r2, r0
	asr r2, r2, #3
	add r2, #2
	add r0, r0, r2
	cmp r0, r1
	ble locret_801C1E8
	mov r0, r1
locret_801C1E8:
	mov pc, lr
	thumb_func_end sub_801C1D0

// symdb: Marks a state object as active/animating and moves a value one ease-out step toward a target value, clamping so it never overshoots.
// symdb: int easeValueTowardTarget(int value /*r0*/, int target /*r1*/, StateObj *obj /*r4*/); returns
// symdb: new value in r0, step taken in r2; flags set by the cmp against target (then possibly
// symdb: overwritten by the clamp path)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/easeValueTowardTarget_801C1EA.yaml
	thumb_local_start
easeValueTowardTarget_801C1EA:
	mov r2, #1
	strb r2, [r4,#8]
	strb r2, [r4,#9]
	mov r2, r0
	sub r2, r2, r1
	asr r2, r2, #3
	add r2, #2
	sub r0, r0, r2
	cmp r0, r1
	bge locret_801C200
	mov r0, r1
locret_801C200:
	mov pc, lr
	thumb_func_end easeValueTowardTarget_801C1EA

// symdb: Render the four floating battle HP readouts (players + enemies) by queueing one OAM entry per active panel, drawing the HP digits and conditionally loading battle portraits.
// symdb: (r10 = toolkit) -> void ; side effects: queues OAM entries, decompresses portrait tiles into
// symdb: VRAM, reads/writes small per-portrait state on byte_203EB50
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_renderHpOverlays_801C202.yaml
	thumb_local_start
battle_renderHpOverlays_801C202:
	push {r4-r7,lr}
	sub sp, sp, #8
	mov r7, sp
	ldr r4, off_801C334 // =byte_203EB50 
	ldr r5, dword_801C344 // =0x6016600 
	mov r6, #4
	mov r3, #0
loc_801C210:
	ldrb r1, [r4]
	mov r0, #2
	tst r1, r0
	beq loc_801C286
	bl renderHpDigits_801C296
	bl chatbox_uploadFrameTileGFX_801C304
	ldrb r0, [r4]
	mov r1, #8
	tst r0, r1
	beq loc_801C22C
	mov r0, #0
	str r0, [r7,#4]
loc_801C22C:
	push {r3}
	mov r0, #0
	mov r1, r10
	ldr r1, [r1,#oToolkit_CameraPtr]
	ldr r1, [r1,#oCamera_Y]
	asr r1, r1, #0x10
	neg r1, r1
	ldrb r2, [r4]
	mov r3, #4
	tst r2, r3
	beq loc_801C24E
	ldrb r0, [r4,#4]
	ldr r2, [r7,#4]
	add r0, r0, r2
	ldrb r2, [r4,#5]
	add r1, r1, r2
	b loc_801C26A
loc_801C24E:
	ldr r0, [r4,#0xc]
	add r0, #0x34 
	bl projectObjectToScreen_800362C
	cmp r2, #0
	beq loc_801C284
	mov r2, #4
	ldrsb r2, [r4,r2]
	add r0, r0, r2
	ldr r2, [r7,#4]
	add r0, r0, r2
	mov r2, #5
	ldrsb r2, [r4,r2]
	add r1, r1, r2
loc_801C26A:
	lsl r0, r0, #0x10
	orr r0, r1
	ldr r2, dword_801C360 // =0x1ff00ff 
	and r0, r2
	ldr r2, dword_801C358 // =0x80004000 
	orr r0, r2
	ldr r1, dword_801C35C // =0xeb30 
	ldr r2, [sp]
	add r1, r1, r2
	mov r2, #2
	mov r3, #0xdf
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
loc_801C284:
	pop {r3}
loc_801C286:
	add r4, #0x14
	add r3, #8
	add r5, #0x80
	add r5, #0x80
	sub r6, #1
	bne loc_801C210
	add sp, sp, #8
	pop {r4-r7,pc}
	thumb_func_end battle_renderHpOverlays_801C202

	thumb_local_start
// print HP?
// symdb: Render an HP readout into a 4-nibble buffer, masking unchanged digits and precomputing a right-justified x offset.
// symdb: void sub_801C296(u32 r3, void* src_obj /* r4 */, u32 r6, void* dst_readout /* r7 */); preserves
// symdb: r3, r4, r6, r7; clobbers r0, r1, r2, lr, nzcv.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/renderHpDigits_801C296.yaml
renderHpDigits_801C296:
	push {r3,r6,lr}
	ldrh r0, [r4,#2]
	ldrb r1, [r4]
	mov r2, #0x10
	tst r1, r2
	beq loc_801C2A8
	ldr r1, [r4,#0xc]
	ldrh r1, [r1,#0x26]
	sub r0, r1, r0
loc_801C2A8:
	bl memory_bcdConvert
	mov r2, #0xf
	mov r1, r0
	and r1, r2
	strb r1, [r7]
	lsr r1, r0, #4
	and r1, r2
	strb r1, [r7,#1]
	lsr r1, r0, #8
	and r1, r2
	strb r1, [r7,#2]
	lsr r1, r0, #0xc
	and r1, r2
	strb r1, [r7,#3]
	bl countHexDigits_8000C5C
	lsl r1, r0, #2
	mov r2, #0x20 
	sub r2, r2, r1
	neg r2, r2
	str r2, [r7,#4]
	mov r1, #0xa
loc_801C2D6:
	cmp r0, #4
	bge loc_801C2E0
	strb r1, [r7,r0] // store blank character in HP?
	add r0, #1
	b loc_801C2D6
loc_801C2E0:
	ldr r1, [r4,#0x10]
	ldr r0, [r7]
	str r0, [r4,#0x10]
	mov r3, #0
loc_801C2E8:
	mov r2, #0xf
	and r2, r0
	mov r6, #0xf
	and r6, r1
	cmp r2, r6
	bne loc_801C2F6
	mov r2, #0xb
loc_801C2F6:
	strb r2, [r7,r3]
	lsr r0, r0, #8
	lsr r1, r1, #8
	add r3, #1
	cmp r3, #4
	blt loc_801C2E8
	pop {r3,r6,pc}
	thumb_func_end renderHpDigits_801C296

// symdb: Chatbox text/frame GFX upload helper — copies 0x20 bytes (one tile row) from each of the 4 chatbox GFX source slots to VRAM, skipping slot 0x0B, and chaining a second upload 0x80 bytes further into the destination.
// symdb: (r4 = arm, r5 = dest base in VRAM, r7 = index table base) -> r0 = dest end pointer ; r4/r5/r6/r7
// symdb: preserved
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/chatbox_uploadFrameTileGFX_801C304.yaml
	thumb_local_start
chatbox_uploadFrameTileGFX_801C304:
	push {r3-r6,lr}
	ldrb r0, [r4,#8]
	lsl r0, r0, #2
	ldr r4, off_801C348 // =off_801C34C 
	ldr r4, [r4,r0]
	mov r6, #3
loc_801C310:
	ldrb r0, [r7,r6]
	cmp r0, #0xb
	beq loc_801C32A
	lsl r0, r0, #2
	ldr r0, [r4,r0]
	mov r1, r5
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r0, r0, r2
	add r1, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_801C32A:
	add r5, #0x20 
	sub r6, #1
	bpl loc_801C310
	pop {r3-r6,pc}
	.balign 4, 0
off_801C334:
	.word byte_203EB50
off_801C338:
	.word off_801C33C
off_801C33C:
	.word sub_801C1D0+1
	.word easeValueTowardTarget_801C1EA+1
dword_801C344:
	.word 0x6016600
off_801C348:
	.word off_801C34C
off_801C34C:
	.word off_801D854
	.word off_801D880
	.word off_801D8AC
dword_801C358:
	.word 0x80004000
dword_801C35C:
	.word 0xEB30
dword_801C360:
	.word 0x1FF00FF
dword_801C364:
	.word 0xB0B0B0B
	thumb_func_end chatbox_uploadFrameTileGFX_801C304

	thumb_local_start
sub_801C368:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	bl sub_802D1B4
	ldr r1, dword_801C444 // =0x600c980 
	push {r0}
	bl sub_801C3A4
	pop {r0}
	ldr r1, off_801C454 // =byte_3001670 
	mov r2, #0
	bl sub_801C3EE
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	bl sub_802D1BE
	ldr r1, dword_801C448 // =0x600ca40 
	push {r0}
	bl sub_801C3A4
	pop {r0}
	ldr r1, off_801C458 // =word_3001684 
	mov r2, #1
	bl sub_801C3EE
	pop {pc}
	thumb_func_end sub_801C368

	thumb_local_start
sub_801C3A4:
	push {r4,r6,r7,lr}
	mov r6, r1
	cmp r0, #0x64 
	bne loc_801C3B2
	mov r0, #1
	lsl r0, r0, #8
	b loc_801C3C8
loc_801C3B2:
	cmp r0, #0xa
	bge loc_801C3BE
	mov r1, #0xaa
	lsl r1, r1, #4
	orr r0, r1
	b loc_801C3C8
loc_801C3BE:
	bl memory_bcdConvert
	mov r1, #0xa
	lsl r1, r1, #8
	orr r0, r1
loc_801C3C8:
	mov r4, r0
	mov r7, #3
loc_801C3CC:
	sub r1, r7, #1
	lsl r1, r1, #2
	mov r0, r4
	lsr r0, r1
	mov r1, #0xf
	and r0, r1
	ldr r1, off_801C44C // =off_801D8D8 
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	mov r1, r6
	mov r2, #0x40 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r6, #0x40 
	sub r7, #1
	bne loc_801C3CC
	pop {r4,r6,r7,pc}
	thumb_func_end sub_801C3A4

	thumb_local_start
sub_801C3EE:
	push {r4,r6,r7,lr}
	mov r3, #0
	cmp r0, #0x3c 
	bgt loc_801C3FE
	add r3, #4
	cmp r0, #0x19
	bgt loc_801C3FE
	add r3, #4
loc_801C3FE:
	mov r0, #0xc
	mul r0, r2
	add r3, r3, r0
	ldr r0, off_801C46C // =off_801D92C 
	ldr r0, [r0,r3]
	mov r2, #0x14
	cmp r3, #0xc
	blt loc_801C410
	sub r2, #8
loc_801C410:
	bl QueueWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r4,r6,r7,pc}
	thumb_func_end sub_801C3EE

	thumb_local_start
sub_801C416:
	push {r4,r5,lr}
	// j
	mov r0, #0x11
	// i
	mov r1, #0x12
	// tileBlock32x32
	mov r2, #0
	// tileIds
	ldr r3, tileIds // =byte_801D904
	mov r4, #0xa
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	ldr r0, dword_801C45C // =0x40780090 
	ldr r1, dword_801C460 // =0x9768 
	mov r2, #1
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldr r0, dword_801C464 // =0x40a80090 
	ldr r1, dword_801C468 // =0x976c 
	mov r2, #1
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	pop {r4,r5,pc}
	.balign 4, 0
dword_801C444:
	.word 0x600C980
dword_801C448:
	.word 0x600CA40
off_801C44C:
	.word off_801D8D8
tileIds:
	.word byte_801D904
off_801C454:
	.word byte_3001670
off_801C458:
	.word word_3001684
dword_801C45C:
	.word 0x40780090
dword_801C460:
	.word 0x9768
dword_801C464:
	.word 0x40A80090
dword_801C468:
	.word 0x976C
off_801C46C:
	.word off_801D92C
	thumb_func_end sub_801C416

// symdb: Drives the player's custom gauge forward each frame; on hitting 0x4000 sets the battle-flags custom-full bit and plays the full-gauge SFX.
// symdb: (no args; r10 = battle toolkit) -> void ; side effects: reads/writes r5+0x20/0x22, sets battle
// symdb: flags, plays SE 0x8F
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_tickCustomGauge_801C470.yaml
	thumb_local_start
battleObject_tickCustomGauge_801C470:
	push {lr}
	bl battle_isPaused
	bne locret_801C4AC
	bl battle_isTimeStop
	bne locret_801C4AC
	bl battle_getFlags
	mov r1, #2
	tst r0, r1
	bne locret_801C4AC
	ldrh r0, [r5,#0x22]
	ldrh r1, [r5,#0x20]
	ldr r2, dword_801C4DC // =0x4000 
	add r0, r0, r1
	strh r0, [r5,#0x20]
	cmp r0, r2
	blt locret_801C4AC
	strh r2, [r5,#0x20]
	bl battle_IsBattleEnding_800A97A
	cmp r0, #0
	bne locret_801C4AC
	mov r0, #2
	bl battle_setFlags
	mov r0, #0x8f
	bl PlaySoundEffect
locret_801C4AC:
	pop {pc}
	thumb_func_end battleObject_tickCustomGauge_801C470

	thumb_local_start
sub_801C4AE:
	push {lr}
	bl battle_getFlags
	mov r1, #2
	tst r0, r1
	bne locret_801C4DA
	bl sub_800A70C
	ldr r1, dword_801C4DC // =0x4000 
	mul r0, r1
	ldr r1, off_801C4E0 // =0x2d0 
	svc 6
	strh r0, [r5,#0x20]
	ldr r1, dword_801C4DC // =0x4000 
	cmp r0, r1
	bne locret_801C4DA
	mov r0, #2
	bl battle_setFlags
	mov r0, #0x8f
	bl PlaySoundEffect
locret_801C4DA:
	pop {pc}
	.balign 4, 0
dword_801C4DC:
	.word 0x4000
off_801C4E0:
	.word 0x2D0
	thumb_func_end sub_801C4AE

// symdb: Draws BG tile-id patterns (story-sequence 2 related) based on a counter threshold
// symdb: (r5 = some battle-state ptr, r10 = toolkit) -> void ; side-effect: writes BG tile-id map blocks
// symdb: via bg_write* helpers
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_drawTimerTiles_801C4E4.yaml
	thumb_local_start
battle_drawTimerTiles_801C4E4:
	push {r4-r6,lr}
	bl battle_IsBattleEnding_800A97A
	cmp r0, #0
	bne locret_801C574
	ldrh r6, [r5,#0x20]
	ldr r2, dword_801C6D8 // =0x4000 
	cmp r6, r2
	blt loc_801C534
	ldrb r6, [r5]
	add r6, #1
	cmp r6, #0x70 
	blt loc_801C500
	mov r6, #0
loc_801C500:
	strb r6, [r5]
	mov r0, r6
	mov r1, #7
	svc 6
	mov r1, #3
	and r0, r1
	ldr r3, dword_801C6B8 // =0x9232 
	add r3, r3, r0
	mov r0, #7
	mov r1, #1
	mov r2, #3
	mov r4, #0x10
	mov r5, #1
	bl call_sub_3005EBA
	mov r0, #8
	and r0, r6
	ldr r3, off_801C6BC // =byte_801C6C0
	add r3, r3, r0
	mov r0, #0xd
	mov r1, #1
	mov r2, #3
	mov r4, #4
	bl bg_writeTileIdRow_80018E0
	b locret_801C574
loc_801C534:
	mov r0, #7
	mov r1, #1
	mov r2, #3
	ldr r3, dword_801C6B4 // =0x9222 
	mov r4, #0x10
	push {r5}
	mov r5, #1
	bl call_sub_3005EBA
	pop {r5}
	lsr r4, r6, #0xa
	cmp r4, #0
	beq loc_801C55C
	mov r0, #7
	mov r1, #1
	mov r2, #3
	ldr r3, dword_801C6B0 // =0x922a 
	mov r5, #1
	bl call_sub_3005EBA
loc_801C55C:
	lsr r6, r6, #7
	mov r0, #7
	and r0, r6
	ldr r3, dword_801C6B4 // =0x9222 
	add r3, r3, r0
	lsr r6, r6, #3
	mov r0, #7
	add r0, r0, r6
	mov r1, #1
	mov r2, #3
	bl bgmap_WriteTileIdAtBlock_800187C
locret_801C574:
	pop {r4-r6,pc}
	thumb_func_end battle_drawTimerTiles_801C4E4

	thumb_local_start
sub_801C576:
	push {r4-r6,lr}
	bl battle_IsBattleEnding_800A97A
	cmp r0, #0
	bne locret_801C5F2
	ldrh r6, [r5,#0x20]
	ldr r2, dword_801C6D8 // =0x4000 
	cmp r6, r2
	blt loc_801C5B2
	ldrb r6, [r5]
	add r6, #1
	cmp r6, #0x70 
	blt loc_801C592
	mov r6, #0
loc_801C592:
	strb r6, [r5]
	mov r0, r6
	mov r1, #7
	svc 6
	mov r1, #3
	and r0, r1
	ldr r3, dword_801C6B8 // =0x9232 
	add r3, r3, r0
	mov r0, #7
	mov r1, #1
	mov r2, #3
	mov r4, #0x10
	mov r5, #1
	bl call_sub_3005EBA
	b locret_801C5F2
loc_801C5B2:
	mov r0, #7
	mov r1, #1
	mov r2, #3
	ldr r3, dword_801C6B4 // =0x9222 
	mov r4, #0x10
	push {r5}
	mov r5, #1
	bl call_sub_3005EBA
	pop {r5}
	lsr r4, r6, #0xa
	cmp r4, #0
	beq loc_801C5DA
	mov r0, #7
	mov r1, #1
	mov r2, #3
	ldr r3, dword_801C6B0 // =0x922a 
	mov r5, #1
	bl call_sub_3005EBA
loc_801C5DA:
	lsr r6, r6, #7
	mov r0, #7
	and r0, r6
	ldr r3, dword_801C6B4 // =0x9222 
	add r3, r3, r0
	lsr r6, r6, #3
	mov r0, #7
	add r0, r0, r6
	mov r1, #1
	mov r2, #3
	bl bgmap_WriteTileIdAtBlock_800187C
locret_801C5F2:
	pop {r4-r6,pc}
	thumb_func_end sub_801C576

// symdb: Plays a "counter hit" SFX from a small lookup table when the AIData's Anger/Timer tier increases between ticks, but only if battle flag 0x40 is set.
// symdb: (r5 = AIData*, r10 = Toolkit*, lr) -> no meaningful r0 return; side effects:
// symdb: PlaySoundEffect(r0=???)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_playCounterHitSound_801C5F4.yaml
	thumb_local_start
battle_playCounterHitSound_801C5F4:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_MainJumptableIndexPtr]
	ldrb r1, [r0]
	cmp r1, #0x50 
	beq locret_801C63E
	ldrb r0, [r5,#0x18]
	strb r0, [r5,#0x19]
	mov r2, #0
	ldrh r0, [r5,#0x20]
	ldr r1, off_801C6D0 // =0x1500 
	cmp r0, r1
	blt loc_801C620
	add r2, #1
	ldr r1, off_801C6D4 // =0x2a00 
	cmp r0, r1
	blt loc_801C620
	add r2, #1
	ldr r1, dword_801C6D8 // =0x4000 
	cmp r0, r1
	bne loc_801C620
	add r2, #1
loc_801C620:
	strb r2, [r5,#0x18]
	bl battle_testFlag0x40_800A8F8
	cmp r0, #1
	bne locret_801C63E
	ldrb r0, [r5,#0x18]
	ldrb r1, [r5,#0x19]
	cmp r0, r1
	ble locret_801C63E
	sub r0, #1
	lsl r0, r0, #1
	ldr r1, off_801C6E4 // =byte_801C6E8
	ldrh r0, [r1,r0]
	bl PlaySoundEffect
locret_801C63E:
	pop {pc}
	thumb_func_end battle_playCounterHitSound_801C5F4

// symdb: Renders the battle BG tile-id blocks and arrow indicators used by the turn-order selection BG overlay
// symdb: (r5 = *Toolkit, r10 = ?, lr) -> r0 = ?, nz/c/v ; side effects: queue GFX transfers and write BG
// symdb: tile-ids
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_drawOrderBGSelectionArrows_801C640.yaml
	thumb_local_start
battle_drawOrderBGSelectionArrows_801C640:
	push {r4-r6,lr}
	bl battle_IsBattleEnding_800A97A
	cmp r0, #0
	bne locret_801C6AE
	mov r0, #7
	mov r1, #1
	mov r2, #3
	ldr r3, dword_801C6B4 // =0x9222 
	mov r4, #0x10
	push {r5}
	mov r5, #1
	bl call_sub_3005EBA
	pop {r5}
	ldrh r6, [r5,#0x20]
	lsr r4, r6, #0xa
	cmp r4, #0
	beq loc_801C678
	mov r0, #7
	mov r1, #1
	mov r2, #3
	ldr r3, dword_801C6B0 // =0x922a 
	push {r5}
	mov r5, #1
	bl call_sub_3005EBA
	pop {r5}
loc_801C678:
	ldr r0, dword_801C6D8 // =0x4000 
	cmp r0, r6
	beq loc_801C696
	lsr r6, r6, #7
	mov r0, #7
	and r0, r6
	ldr r3, dword_801C6B4 // =0x9222 
	add r3, r3, r0
	lsr r6, r6, #3
	mov r0, #7
	add r0, r0, r6
	mov r1, #1
	mov r2, #3
	bl bgmap_WriteTileIdAtBlock_800187C
loc_801C696:
	ldrb r3, [r5,#0x18]
	cmp r3, #0
	bne loc_801C69E
	sub r3, #2
loc_801C69E:
	mov r2, #0x20 
	sub r3, #1
	mul r3, r2
	ldr r0, off_801C6DC // =byte_86E1CD8 
	add r0, r0, r3
	ldr r1, off_801C6E0 // =unk_3001A80 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
locret_801C6AE:
	pop {r4-r6,pc}
	.balign 4, 0
dword_801C6B0:
	.word 0x922A
dword_801C6B4:
	.word 0x9222
dword_801C6B8:
	.word 0x9232
off_801C6BC:
	.word byte_801C6C0
byte_801C6C0:
	.byte 0x36, 0x92, 0x37, 0x92, 0x38, 0x92, 0x39, 0x92, 0x3A
	.byte 0x92, 0x3B, 0x92, 0x3C, 0x92, 0x3D, 0x92
off_801C6D0:
	.word 0x1500
off_801C6D4:
	.word 0x2A00
dword_801C6D8:
	.word 0x4000
off_801C6DC:
	.word byte_86E1CD8
off_801C6E0:
	.word unk_3001A80
off_801C6E4:
	.word byte_801C6E8
byte_801C6E8:
	.byte 0x6A, 0x1, 0x69, 0x1, 0x8F, 0x0
	thumb_func_end battle_drawOrderBGSelectionArrows_801C640

// symdb: Draws the battle actor's selected chip as name text plus a right-aligned damage number (and optional second value / marker glyph) into the battle BG tile map; does nothing when no chip is selected.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_drawSelectedChipNameAndDamage_801C6EE.yaml
	thumb_local_start
battle_drawSelectedChipNameAndDamage_801C6EE:
	push {r4-r7,lr}
	mov r0, #0
	push {r0}
	push {r0}
	push {r0}
	push {r0}
	push {r0}
	push {r0}
	push {r0}
	push {r0}
	push {r0}
	push {r0}
	push {r0}
	push {r0}
	mov r0, #0
	mov r1, #0x12
	mov r2, #3
	mov r3, #0
	mov r4, #0x11
	mov r5, #2
	bl call_sub_3005EBA
	ldr r0, off_801C83C // =eStruct2035280
	ldr r0, [r0,#0x48] // (dword_20352C8 - 0x2035280)
	bl battle_getSelectedChipForUse_800ED90
	cmp r3, #0
	beq loc_801C818
	str r0, [sp]
	str r1, [sp,#4]
	str r2, [sp,#8]
	bl chip_SelectNameTextTable_8027D10
	ldr r2, off_801C81C // =byte_203EBA0 
	ldr r3, dword_801C820 // =0x600cb00 
	mov r4, #8
	mov r5, #1
	ldr r6, off_801C824 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	mov r7, r0
	mov r4, r0
	mov r0, #0
	mov r1, #0x12
	mov r2, #3
	ldr r3, off_801C828 // =byte_801D944
	bl bg_writeTileIdRow_80018E0
	mov r0, #0
	mov r1, #0x13
	mov r2, #3
	ldr r3, off_801C82C // =byte_801D954 
	mov r4, r7
	bl bg_writeTileIdRow_80018E0
	// idx
	ldr r0, [sp]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#9]
	mov r2, #2
	tst r1, r2
	beq loc_801C818
	ldr r0, [sp,#4]
	bl memory_bcdConvert
	mov r4, r0
	bl countHexDigits_8000C5C
	mov r3, r0
	mov r6, r3
	add r2, sp, #0xc
	lsl r0, r0, #1
	add r2, r2, r0
	sub r2, #2
	ldr r1, dword_801C830 // =0xd1b8 
loc_801C786:
	mov r0, #0xf
	and r0, r4
	lsl r0, r0, #1
	add r0, r0, r1
	strh r0, [r2]
	add r0, #1
	strh r0, [r2,#0x12]
	sub r2, #2
	lsr r4, r4, #4
	sub r3, #1
	bne loc_801C786
	ldr r0, [sp,#8]
	cmp r0, #0
	beq loc_801C7DE
	bl memory_bcdConvert
	mov r4, r0
	bl countHexDigits_8000C5C
	mov r3, r0
	mov r2, r6
	lsl r2, r2, #1
	add r2, #0xc
	add r2, sp
	ldr r1, dword_801C834 // =0xd1ce 
	strh r1, [r2]
	add r1, #1
	strh r1, [r2,#0x12]
	lsl r0, r0, #1
	add r2, r2, r0
	add r6, r6, r3
	add r6, #1
	ldr r1, dword_801C830 // =0xd1b8 
loc_801C7C8:
	mov r0, #0xf
	and r0, r4
	lsl r0, r0, #1
	add r0, r0, r1
	strh r0, [r2]
	add r0, #1
	strh r0, [r2,#0x12]
	sub r2, #2
	lsr r4, r4, #4
	sub r3, #1
	bne loc_801C7C8
loc_801C7DE:
	ldr r0, off_801C83C // =eStruct2035280
	ldr r0, [r0,#0x48] // (dword_20352C8 - 0x2035280)
	ldr r1, [sp]
	mov r3, #0
	bl battle_aiClassifyChipCategory_8012A38
	tst r1, r1
	beq loc_801C806
	mov r2, r6
	lsl r2, r2, #1
	add r2, #0xc
	add r2, sp
	ldr r1, dword_801C838 // =0xd1d2 
	strh r1, [r2]
	add r1, #1
	strh r1, [r2,#0x12]
	add r1, #1
	strh r1, [r2,#2]
	add r1, #1
	strh r1, [r2,#0x14]
loc_801C806:
	mov r0, r7
	// j
	add r0, #0
	// i
	mov r1, #0x12
	// tileBlock32x32
	mov r2, #3
	// tileIds
	add r3, sp, #0xc
	mov r4, #9
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
loc_801C818:
	add sp, sp, #0x30
	pop {r4-r7,pc}
	.balign 4, 0
off_801C81C:
	.word byte_203EBA0
dword_801C820:
	.word 0x600CB00
off_801C824:
	.word dword_86B7AE0
off_801C828:
	.word byte_801D944
off_801C82C:
	.word byte_801D954
dword_801C830:
	.word 0xD1B8
dword_801C834:
	.word 0xD1CE
dword_801C838:
	.word 0xD1D2
off_801C83C:
	.word eStruct2035280
	thumb_func_end battle_drawSelectedChipNameAndDamage_801C6EE

// symdb: Battle per-frame updater that bumps an internal "low-HP" timer, plays SOUND_LOW_HP every 0x2d frames while the alive-player-actor count is non-zero, and animates the navi's HP gauge toward the live HP value.
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> void ; side effects: PlaySoundEffect(SOUND_LOW_HP),
// symdb: mutates r5[BButton_offset], r5[Unk_03], r5[Unk_05], r5[Unk_24] and r5[Unk_26]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_tickLowHpWarning_801C840.yaml
	thumb_local_start
battle_tickLowHpWarning_801C840:
	push {r7,lr}
	ldr r7, [r5,#0x48]
	bl GetBattleMode
	cmp r0, #6
	bne loc_801C85A
	mov r0, #oBattleState_AlivePlayerActors
	mov r7, r10
	ldr r7, [r7,#oToolkit_BattleStatePtr]
	add r7, r7, r0
	ldr r7, [r7]
	tst r7, r7
	beq locret_801C904
loc_801C85A:
	bl battle_isBattleOver
	tst r0, r0
	bne loc_801C886
	bl battle_isPaused
	bne loc_801C886
	ldrh r1, [r7,#0x24]
	ldrh r2, [r7,#0x26]
	lsr r2, r2, #2
	cmp r1, r2
	bgt loc_801C886
	ldrb r0, [r5,#6]
	add r0, #1
	strb r0, [r5,#6]
	cmp r0, #0x2d 
	blt loc_801C886
	mov r0, #0
	strb r0, [r5,#6]
	mov r0, #SOUND_LOW_HP
	bl PlaySoundEffect
loc_801C886:
	ldrb r0, [r5,#0x1c]
	cmp r0, #0
	beq loc_801C890
	ldrh r0, [r7,#0x24]
	strh r0, [r5,#0x24]
loc_801C890:
	ldrh r1, [r5,#0x26]
	mov r2, #0xff
	lsl r2, r2, #8
	add r2, #0xff
	cmp r1, r2
	beq loc_801C8A2
	ldrh r3, [r5,#0x26]
	strh r3, [r5,#0x24]
	b loc_801C8A6
loc_801C8A2:
	ldrh r1, [r7,#0x24]
	ldrh r3, [r5,#0x24]
loc_801C8A6:
	cmp r1, r3
	beq loc_801C8DE
	bgt loc_801C8C2
	mov r0, #2
	strb r0, [r5,#3]
	mov r2, r3
	sub r2, r2, r1
	asr r2, r2, #3
	add r2, #4
	sub r3, r3, r2
	cmp r3, r1
	bge loc_801C8D6
	mov r3, r1
	b loc_801C8D6
loc_801C8C2:
	mov r0, #1
	strb r0, [r5,#3]
	mov r2, r1
	sub r2, r2, r3
	asr r2, r2, #3
	add r2, #4
	add r3, r3, r2
	cmp r3, r1
	ble loc_801C8D6
	mov r3, r1
loc_801C8D6:
	strh r3, [r5,#0x24]
	mov r0, #0xf
	strb r0, [r5,#5]
	pop {r7,pc}
loc_801C8DE:
	ldrb r0, [r5,#5]
	cmp r0, #0
	beq loc_801C8EA
	sub r0, #1
	strb r0, [r5,#5]
	bne locret_801C904
loc_801C8EA:
	ldrh r0, [r5,#0x26]
	mov r2, #0xff
	lsl r2, r2, #8
	add r2, #0xff
	cmp r0, r2
	bne loc_801C900
	mov r0, #2
	ldrh r2, [r7,#0x26]
	lsr r2, r2, #2
	cmp r1, r2
	ble loc_801C902
loc_801C900:
	mov r0, #0
loc_801C902:
	strb r0, [r5,#3]
locret_801C904:
	pop {r7,pc}
	thumb_func_end battle_tickLowHpWarning_801C840

// symdb: redraws a field object's four-digit HP readout by stamping right-aligned digit glyphs into background tile block 3 and queuing the companion 32-byte tile upload for VRAM
// symdb: void drawNumberLabel_801C906(void); /* r5 in: label object; r4-r7 preserved; r3/r4-r7 out:
// symdb: leftover from callee, r4-r7 restored to entry values */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801C906.yaml
	thumb_local_start
sub_801C906:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x10
	mov r6, sp
	ldrh r0, [r5,#0x24]
	bl memory_bcdConvert
	mov r2, r0
	bl countHexDigits_8000C5C
	lsl r0, r0, #2
	ldr r1, dword_801C980 // =0xaaaa 
	lsl r1, r0
	orr r2, r1
	push {r5}
	ldr r5, dword_801C97C // =0xd1a0 
	mov r1, r6
	add r1, #8
	mov r3, #6
loc_801C92A:
	mov r0, #0xf
	and r0, r2
	lsl r0, r0, #1
	add r0, r0, r5
	strh r0, [r6,r3]
	add r0, #1
	strh r0, [r1,r3]
	lsr r2, r2, #4
	sub r3, #2
	bpl loc_801C92A
	ldr r5, [sp]
	ldrb r0, [r5,#1]
	// j
	add r0, #1
	// i
	ldrb r1, [r5,#2]
	// tileBlock32x32
	mov r2, #3
	// tileIds
	mov r3, r6
	mov r4, #4
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r5}
	ldrb r0, [r5,#3]
	lsl r0, r0, #5
	ldr r3, off_801C96C // =off_801C970 
	ldr r1, [r3]
	add r0, r0, r1
	ldr r1, [r3,#0x4] // (off_801C974 - 0x801c970)
	ldr r2, [r3,#0x8] // (dword_801C978 - 0x801c970)
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add sp, sp, #0x10
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_801C96C:
	.word off_801C970
off_801C970:
	.word dword_86E1C78
off_801C974:
	.word byte_3001B00
dword_801C978:
	.word 0x20
dword_801C97C:
	.word 0xD1A0
dword_801C980:
	.word 0xAAAA
	thumb_func_end sub_801C906

// symdb: Initializes an AIData struct's BLeftAbility (offset 0x7) and Unk_09 (offset 0x9) from story flags 0 and 1.
// symdb: (r5 = AIDataPtr, r10 = ToolkitPtr) -> void ; side effects: writes [r5+7] and [r5+9]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_initObjectStoryFlags_801C984.yaml
	thumb_local_start
battle_initObjectStoryFlags_801C984:
	push {lr}
	mov r0, #0
	bl battle_getStoryFlagFromBattleState_802CE60
	cmp r0, #0
	beq loc_801C992
	mov r0, #1
loc_801C992:
	strb r0, [r5,#7]
	mov r0, #1
	bl battle_getStoryFlagFromBattleState_802CE60
	cmp r0, #0
	beq loc_801C9A0
	mov r0, #1
loc_801C9A0:
	strb r0, [r5,#9]
	pop {pc}
	thumb_func_end battle_initObjectStoryFlags_801C984

// symdb: Compares two target byte fields of a struct against their "current" copies and, whenever they differ, updates the copy and raises a notification event (6 for the first field, 0x1A for the second) via sub_801C9C8.
// symdb: void sub_801C9A4(struct* r5); // r4, r6, r7, r10 also live on entry (passed through to
// symdb: sub_801C9C8); returns nothing meaningful in r0-r3; flags and r0/r1 reflect the final
// symdb: compare/callee call
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/syncCurrentFieldsAndNotify_801C9A4.yaml
	thumb_local_start
syncCurrentFieldsAndNotify_801C9A4:
	push {lr}
	ldrb r1, [r5,#7]
	ldrb r0, [r5,#8]
	cmp r0, r1
	beq loc_801C9B6
	strb r1, [r5,#8]
	mov r0, #6
	bl background_drawPresetTileBlock_801C9C8
loc_801C9B6:
	ldrb r1, [r5,#9]
	ldrb r0, [r5,#0xa]
	cmp r0, r1
	beq locret_801C9C6
	strb r1, [r5,#0xa]
	mov r0, #0x1a
	bl background_drawPresetTileBlock_801C9C8
locret_801C9C6:
	pop {pc}
	thumb_func_end syncCurrentFieldsAndNotify_801C9A4

// symdb: Copies one entry (a 4x2 block of 8x8 tile ids) from a preset background table into tile block 3 of the background layer at column r0, fixed row 2.
// symdb: void background_drawPresetTileBlock(u32 j /* dest column */, u32 backgroundId /* entry index */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/background_drawPresetTileBlock_801C9C8.yaml
	thumb_local_start
background_drawPresetTileBlock_801C9C8:
	push {r4,r5,lr}
	lsl r1, r1, #4
	ldr r3, off_801C9E0 // =byte_801D964 
	// tileIds
	add r3, r3, r1
	// i
	mov r1, #2
	// tileBlock32x32
	mov r2, #3
	mov r4, #4
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4,r5,pc}
	.balign 4, 0
off_801C9E0:
	.word byte_801D964
	thumb_func_end background_drawPresetTileBlock_801C9C8

	thumb_local_start
sub_801C9E4:
	push {lr}
	ldr r0, dword_801C9FC // =0x8064403f 
	ldr r1, dword_801CA00 // =0xe370 
	mov r2, #0
	mov r3, #6
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldr r0, dword_801CA04 // =0x84803f 
	ldr r1, dword_801CA08 // =0xe378 
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	pop {pc}
	.balign 4, 0
dword_801C9FC:
	.word 0x8064403F
dword_801CA00:
	.word 0xE370
dword_801CA04:
	.word 0x84803F
dword_801CA08:
	.word 0xE378
	thumb_func_end sub_801C9E4

// symdb: Decrements an 8-bit countdown timer on an object each call and dispatches event 0x100 once it reaches zero.
// symdb: void sub_801CA0C(struct Object* r5)  /* r5 preserved; returns flags and r0 of "SUBS timer,#1"
// symdb: while counting, r0=timer value; on expiry r0-r3/flags are those left by the two callees */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_countdownTimer_801CA0C.yaml
	thumb_local_start
object_countdownTimer_801CA0C:
	push {lr}
	ldrb r0, [r5,#0xb]
	sub r0, #1
	strb r0, [r5,#0xb]
	bne locret_801CA26
	mov r0, #1
	lsl r0, r0, #8
	bl flags_clearBits_eStruct2035280_801BED6
	mov r0, #1
	lsl r0, r0, #8
	bl dispatch_801DACC // (a0: flags32) -> ()
locret_801CA26:
	pop {pc}
	thumb_func_end object_countdownTimer_801CA0C

	thumb_local_start
sub_801CA28:
	ldrb r0, [r5]
	add r0, #1
	mov r1, #0x3f 
	and r0, r1
	strb r0, [r5]
	mov pc, lr
	thumb_func_end sub_801CA28

	thumb_local_start
sub_801CA34:
	push {r4-r6,lr}
	ldrb r6, [r5,#0xb]
	ldr r0, off_801CA78 // =dword_801CA7C 
	ldrb r6, [r0,r6]
	ldrb r0, [r5]
	mov r1, #0x1f
	and r1, r0
	bne locret_801CA72
	cmp r0, #0x20 
	bge loc_801CA5E
	mov r0, #0x16
	// j
	sub r0, r0, r6
	// i
	mov r1, #4
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_801CA74 // =byte_801D984
	mov r4, #8
	add r4, r4, r6
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	b locret_801CA72
loc_801CA5E:
	mov r0, #0x16
	sub r0, r0, r6
	mov r1, #4
	mov r2, #3
	mov r3, #0
	mov r4, #8
	add r4, r4, r6
	mov r5, #2
	bl call_sub_3005EBA
locret_801CA72:
	pop {r4-r6,pc}
	.balign 4, 0
off_801CA74:
	.word byte_801D984
off_801CA78:
	.word dword_801CA7C
dword_801CA7C:
	.word 0x30200
	thumb_func_end sub_801CA34

// symdb: Draw up to 4 two-row strips of 9 tiles with CopyBackgroundTiles, at columns 0x1E - [table at r5 + 0x28] (0xFF ends the table).
// symdb: (r5 = struct with a halfword column table at +0x28)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_801CA80.yaml
	thumb_local_start
sub_801CA80:
	push {r4-r7,lr}
	sub sp, sp, #0x24
	// i
	mov r1, #0
	mov r6, r5
	add r6, #0x28 
loc_801CA8A:
	mov r7, sp
	ldrh r2, [r6]
	cmp r2, #0xff
	beq loc_801CAD4
	ldr r0, dword_801CAD8 // =0xd1da 
	mov r3, #9
	mul r3, r1
	add r0, r0, r3
	add r5, r0, #1
	mov r3, #0
loc_801CA9E:
	strh r0, [r7,r3]
	add r0, #2
	add r3, #2
	cmp r3, #0x12
	bne loc_801CA9E
	add r7, #0x12
	mov r0, r5
	mov r3, #0
loc_801CAAE:
	strh r0, [r7,r3]
	add r0, #2
	add r3, #2
	cmp r3, #0x12
	bne loc_801CAAE
	mov r0, #0x1e
	// j
	sub r0, r0, r2
	// tileBlock32x32
	mov r2, #0
	// tileIds
	mov r3, sp
	mov r4, #9
	mov r5, #2
	push {r1}
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r1}
	add r1, #2
	add r6, #2
	cmp r1, #8
	bne loc_801CA8A
loc_801CAD4:
	add sp, sp, #0x24
	pop {r4-r7,pc}
	.balign 4, 0
dword_801CAD8:
	.word 0xD1DA
	thumb_func_end sub_801CA80

// symdb: Battle-object per-frame anim/state update: refreshes CurAnim when NegaWisp (id 0x29) flag set, ticks a future-panel timer/anim, and dispatches to either sub_801CC34 or battle_updateObjectAnim_801CB38.
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> void ; side effects: writes r5+0x14/0x15/0x1f, calls
// symdb: GetBattleNaviStatsByte/sub_801CC34/battle_updateObjectAnim_801CB38/sub_801CC94
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_updateAnimAndState_801CADC.yaml
	thumb_local_start
battleObject_updateAnimAndState_801CADC:
	push {lr}
	ldrb r0, [r5,#0x17]
	cmp r0, #0xff
	bne loc_801CAF0
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte
loc_801CAF0:
	ldrb r1, [r5,#0x14]
	cmp r1, #0
	beq loc_801CB10
	sub r1, #1
	strb r1, [r5,#0x14]
	bne loc_801CB02
	strb r0, [r5,#0x15]
	cmp r0, #0
	beq loc_801CB2C
loc_801CB02:
	mov r2, #2
	tst r1, r2
	beq loc_801CB22
	ldrb r0, [r5,#0x1f]
	cmp r0, #0
	bne loc_801CB26
	b loc_801CB2C
loc_801CB10:
	ldrb r1, [r5,#0x15]
	cmp r0, r1
	beq loc_801CB1E
	cmp r1, #0xff
	beq loc_801CB1E
	mov r1, #0xa
	strb r1, [r5,#0x14]
loc_801CB1E:
	cmp r0, #0
	beq loc_801CB2C
loc_801CB22:
	cmp r0, #0
	beq loc_801CB2C
loc_801CB26:
	bl battleObject_loadBeastOutFormGfx_801CC34
	b loc_801CB30
loc_801CB2C:
	bl battle_updateObjectAnim_801CB38
loc_801CB30:
	strb r0, [r5,#0x15]
	bl battle_ai_tickPwrAtkPresses_801CC94
	pop {pc}
	thumb_func_end battleObject_updateAnimAndState_801CADC

// symdb: Advances a battle object's animation state machine and queues its tile, cell, and pattern GFX transfers to VRAM.
// symdb: void sub_801CB38(u32 /* saved */ r0, u32 obj /* r5 */, u32 /* r10 */) -> u32 r0, u32 r3, u32 r4,
// symdb: u32 r5, u32 r6, u32 r7 (clobbers nzcv, r1, r2, lr)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_updateObjectAnim_801CB38.yaml
	thumb_local_start
battle_updateObjectAnim_801CB38:
	push {r0,r4,r6,r7,lr}
	mov r7, #0
	ldrb r0, [r5,#0x13]
	cmp r0, #0xff
	bne loc_801CB54
	mov r0, #0
	strb r0, [r5,#0x13]
	bl battleObject_resolveEmotionPalette_801E6A8
	strb r0, [r5,#0x10]
	strb r0, [r5,#0x11]
	strb r1, [r5,#0xe]
	strb r1, [r5,#0xd]
	b loc_801CBA2
loc_801CB54:
	mov r1, #0x4c 
	ldrb r0, [r5,r1]
	cmp r0, #0
	beq loc_801CB60
	ldrb r1, [r5,#0xe]
	b loc_801CBA2
loc_801CB60:
	ldrb r0, [r5,#0x17]
	cmp r0, #0
	beq loc_801CB72
	ldrb r0, [r5,#0x16]
	cmp r0, #0
	bne loc_801CB72
	bl battleObject_resolveEmotionPalette_801E6A8
	b loc_801CB76
loc_801CB72:
	bl sub_801E69C
loc_801CB76:
	ldrb r2, [r5,#0x14]
	cmp r2, #0
	beq loc_801CB80
	strb r0, [r5,#0x10]
	b loc_801CBA2
loc_801CB80:
	ldrb r2, [r5,#0x10]
	cmp r0, r2
	bne loc_801CB94
	ldrb r2, [r5,#0xe]
	cmp r1, r2
	beq loc_801CBA2
	ldrb r3, [r5,#0xe]
	strb r3, [r5,#0xd]
	strb r1, [r5,#0xe]
	b loc_801CBA2
loc_801CB94:
	strb r2, [r5,#0x11]
	ldrb r3, [r5,#0xe]
	strb r3, [r5,#0xd]
	strb r0, [r5,#0x10]
	strb r1, [r5,#0xe]
	mov r1, #0xc
	strb r1, [r5,#0x13]
loc_801CBA2:
	cmp r0, #5
	bge loc_801CBBE
	cmp r0, #3
	beq loc_801CBBE
	ldrb r1, [r5,#0x13]
	mov r7, r1
	cmp r1, #0
	beq loc_801CBBE
	sub r2, r1, #1
	strb r2, [r5,#0x13]
	mov r2, #2
	and r2, r1
	beq loc_801CBBE
	ldrb r0, [r5,#0x11]
loc_801CBBE:
	mov r4, r0
	mov r6, r1
	lsl r0, r0, #2
	ldr r1, off_801CD04 // =off_801CD08 
	ldr r0, [r1,r0]
	ldr r1, dword_801CD68 // =0x6017680 
	ldr r2, off_801CD6C // =0x100 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	push {r0-r3}
	bl battle_shouldUseSimpleAnimMode_801D814
	tst r0, r0
	pop {r0-r3}
	bne loc_801CBEC
	ldr r0, off_801CD64 // =dword_872D914 
	ldr r1, dword_801CD68 // =0x6017680 
	ldr r2, off_801CD6C // =0x100 
	add r1, r1, r2
	ldr r2, off_801CD70 // =0x80 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	b loc_801CC0A
loc_801CBEC:
	ldrb r1, [r5,#0xe]
	mov r2, #2
	and r2, r7
	beq loc_801CBF6
	ldrb r1, [r5,#0xd]
loc_801CBF6:
	mov r0, #0xa
	sub r0, r0, r1
	mov r1, #0x80
	mul r0, r1
	ldr r1, off_801CDC4 // =dword_872E994 
	add r0, r0, r1
	ldr r1, dword_801CDC8 // =0x6017780 
	mov r2, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_801CC0A:
	ldrb r1, [r5,#0x10]
	cmp r1, #3
	bne loc_801CC24
	ldrb r1, [r5,#0x13]
	cmp r1, #0
	beq loc_801CC24
	sub r2, r1, #1
	strb r2, [r5,#0x13]
	mov r2, #2
	and r2, r1
	beq loc_801CC24
	ldr r0, off_801CD7C // =byte_801CD80
	b loc_801CC2A
loc_801CC24:
	lsl r0, r4, #5
	ldr r1, off_801CD74 // =dword_872F114 
	add r0, r0, r1
loc_801CC2A:
	ldr r1, off_801CD78 // =byte_30016D0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r0,r4,r6,r7,pc}
	thumb_func_end battle_updateObjectAnim_801CB38

// symdb: Queues GFX/vram transfers for a battle object's beast-out form change and picks the emotion palette
// symdb: (r0 = emotionIdx (1-based), r4 = ?, r5 = BattleObject*, r10 = Toolkit*) -> r0 = emotionIdx
// symdb: (unchanged) ; side effects: GFX/VRAM queued via QueueEightWordAlignedGFXTransfer; writes
// symdb: BattleObject+0x10 and +0x11
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_loadBeastOutFormGfx_801CC34.yaml
	thumb_local_start
battleObject_loadBeastOutFormGfx_801CC34:
	push {r0,r4,r7,lr}
	sub sp, sp, #0x30
	mov r2, r0
	sub r0, #1
	ldr r1, off_801CDD8 // =byte_801CDDC
	ldrb r0, [r1,r0]
	str r0, [sp]
	ldrb r1, [r5,#0x15]
	cmp r2, r1
	beq loc_801CC64
	ldr r2, off_801CD6C // =0x100 
	mul r0, r2
	ldr r1, off_801CDCC // =byte_872D094
	add r0, r0, r1
	ldr r1, dword_801CD68 // =0x6017680 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, off_801CDD4 // =byte_872D014 
	add r1, r1, r2
	mov r2, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #0xff
	strb r0, [r5,#0x10]
loc_801CC64:
	bl battleObject_resolveEmotionPalette_801E6A8
	mov r1, #0
	ldrb r2, [r5,#0x17]
	cmp r2, #0xff
	bne loc_801CC76
	cmp r0, #3
	bne loc_801CC76
	mov r1, #1
loc_801CC76:
	ldrb r0, [r5,#0x10]
	strb r1, [r5,#0x10]
	ldr r0, [sp]
	mov r2, #0x40 
	mul r0, r2
	ldr r2, off_801CDD0 // =dword_872D694 
	add r0, r0, r2
	mov r2, #0x20 
	mul r1, r2
	add r0, r0, r1
	ldr r1, off_801CD78 // =byte_30016D0 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add sp, sp, #0x30
	pop {r0,r4,r7,pc}
	thumb_func_end battleObject_loadBeastOutFormGfx_801CC34

// symdb: AI tick that, when any allied Navi bonus is active, randomly queues one or two "PwrAtk" button presses (with a 12-tick inter-press delay) into AIData and refreshes a 0x20-byte blank GFX region.
// symdb: (r5 = *mut AIData, r10 = *Toolkit, lr) -> void ; side effects: writes AIData+PwrAtkState (0x1d),
// symdb: AIData+Unk_15/Unk_0f/PwrAtkButton/Unk_38 areas; may call QueueEightWordAlignedGFXTransfer(0x20
// symdb: zeros -> 0x030016d0); pushes/pops r5; calls r10-anchored helpers
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_ai_tickPwrAtkPresses_801CC94.yaml
	thumb_local_start
battle_ai_tickPwrAtkPresses_801CC94:
	push {lr}
	ldrb r0, [r5,#0x1d]
	cmp r0, #0
	bne loc_801CCDE
	ldrh r1, [r5,#0x38]
	sub r1, #1
	bne loc_801CCDA
	ldrb r0, [r5,#0x15]
	cmp r0, #0
	beq loc_801CCB0
	ldrb r0, [r5,#0x17]
	cmp r0, #0xff
	beq loc_801CCB6
	b loc_801CCD8
loc_801CCB0:
	ldrb r0, [r5,#0x1e]
	cmp r0, #0
	bne loc_801CCC8
loc_801CCB6:
	push {r5}
	bl battle_preUpdateAndGetPlayerObject_80103EC
	mov r5, r0
	bl countActiveNaviBonuses_800FE52
	pop {r5}
	cmp r0, #0
	beq loc_801CCD8
loc_801CCC8:
	bl GetPositiveSignedRNGSecondary
	mov r1, #1
	and r1, r0
	add r1, #1
	strb r1, [r5,#0x1d]
	mov r0, #0xc
	strb r0, [r5,#0xf]
loc_801CCD8:
	mov r1, #0x14
loc_801CCDA:
	strh r1, [r5,#0x38]
	b locret_801CD00
loc_801CCDE:
	ldrb r1, [r5,#0xf]
	sub r2, r1, #1
	strb r2, [r5,#0xf]
	bne loc_801CCF0
	ldrb r0, [r5,#0x1d]
	sub r0, #1
	strb r0, [r5,#0x1d]
	mov r0, #0xc
	strb r0, [r5,#0xf]
loc_801CCF0:
	mov r0, #2
	tst r0, r1
	beq locret_801CD00
	ldr r0, off_801CDA0 // =byte_801CDA4
	ldr r1, off_801CD78 // =byte_30016D0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
locret_801CD00:
	pop {pc}
	.balign 4, 0
off_801CD04:
	.word off_801CD08
off_801CD08:
	.word dword_872D814
	.word dword_872D994
	.word dword_872DB14
	.word byte_872DC94
	.word dword_872DE14
	.word byte_872DF94
	.word dword_872E094
	.word dword_872E194
	.word dword_872E294
	.word dword_872E394
	.word dword_872E494
	.word dword_872E594
	.word dword_872E694
	.word dword_872E794
	.word dword_872E894
	.word byte_872DF94
	.word dword_872E094
	.word dword_872E194
	.word dword_872E294
	.word dword_872E394
	.word dword_872EF14
	.word dword_872EF14
	.word byte_872F014
off_801CD64:
	.word dword_872D914
dword_801CD68:
	.word 0x6017680
off_801CD6C:
	.word 0x100
off_801CD70:
	.word 0x80
off_801CD74:
	.word dword_872F114
off_801CD78:
	.word byte_30016D0
off_801CD7C:
	.word byte_801CD80
byte_801CD80:
	.byte 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF
	.byte 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F
	.byte 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF
	.byte 0x7F, 0xFF, 0x7F, 0xFF, 0x7F
off_801CDA0:
	.word byte_801CDA4
byte_801CDA4:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
off_801CDC4:
	.word dword_872E994
dword_801CDC8:
	.word 0x6017780
off_801CDCC:
	.word byte_872D094
off_801CDD0:
	.word dword_872D694
off_801CDD4:
	.word byte_872D014
off_801CDD8:
	.word byte_801CDDC
byte_801CDDC:
	.byte 0x0, 0x1, 0x2, 0x3, 0x4, 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x0, 0x80, 0x52, 0x3
	.byte 0x2
	thumb_func_end battle_ai_tickPwrAtkPresses_801CC94

// symdb: Queues two palette transfers (two paired palette blobs) for an object, targeting slots selected by the object's byte at +0x12, skipping objects whose state byte at +0x0F is 5 or 6.
// symdb: void palette_QueueObjectPalettePair(Obj *obj /* r5; r4/r6/r7 passed in but unused, preserved */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/palette_QueueObjectPalettePair_801CDEC.yaml
	thumb_local_start
palette_QueueObjectPalettePair_801CDEC:
	push {r4-r6,lr}
	ldrb r0, [r5,#0xf]
	cmp r0, #6
	beq locret_801CE14
	cmp r0, #5
	beq locret_801CE14
	ldrb r4, [r5,#0x12]
	lsl r4, r4, #0x10
	mov r2, #0
	mov r3, #0
	ldr r0, dword_801CE18 // =0x80004012 
	add r0, r0, r4
	ldr r1, dword_801CE1C // =0xcbb4 
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldr r0, dword_801CE20 // =0x40200012 
	add r0, r0, r4
	ldr r1, dword_801CE24 // =0xcbbc 
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
locret_801CE14:
	pop {r4-r6,pc}
	.balign 4, 0
dword_801CE18:
	.word 0x80004012
dword_801CE1C:
	.word 0xCBB4
dword_801CE20:
	.word 0x40200012
dword_801CE24:
	.word 0xCBBC
	thumb_func_end palette_QueueObjectPalettePair_801CDEC

// symdb: Advances the shared state-machine step counter and dispatches to the current mode's per-frame tick handler via a 4-entry jump table.
// symdb: void stateMachine_stepDispatch_801CE28(void /* lr = caller return */); /* reads/writes
// symdb: byte_2036840 state block; clobbers r0-r12, nzcv; preserves r5, r10 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801CE28.yaml
	thumb_local_start
sub_801CE28:
	push {r5,lr}
	ldr r5, off_801CE54 // =byte_2036840 
	ldrb r0, [r5,#0x7] // (byte_2036847 - 0x2036840)
	add r0, #1
	cmp r0, #5
	bne loc_801CE44
	ldrb r1, [r5]
	cmp r1, #4
	bne loc_801CE44
	ldrb r1, [r5,#0x8] // (byte_2036848 - 0x2036840)
	cmp r1, #2
	beq loc_801CE46
	cmp r1, #4
	beq loc_801CE46
loc_801CE44:
	strb r0, [r5,#0x7] // (byte_2036847 - 0x2036840)
loc_801CE46:
	ldr r1, off_801CE58 // =off_801CE5C 
	ldrb r0, [r5]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r5,pc}
	.balign 4, 0
off_801CE54:
	.word byte_2036840
off_801CE58:
	.word off_801CE5C
off_801CE5C:
	.word screenFadeOutStepTick_801CE6C+1
	.word chatbox_stepTextPrinter_801CE92+1
	.word flags_clearWordSlicesTaskStep_801CED2+1
	.word event_raiseFlag8000AndDispatch_801CEFA+1
	thumb_func_end sub_801CE28

// symdb: Ticks a staged screen fade-out, dropping the fade parameter by 0x20 each step until the work block advances to state 4.
// symdb: void sub_801CE6C(u8* work /* r5 */); calls sub_802FE7A(0, 0x40, 0xE0 - 0x20*work[7], work[6]);
// symdb: returns r0 = step counter (0 on finishing tick); preserves r4-r7; c/v from `cmp counter,#5`, nz
// symdb: from `movs r0,#0` only on the finishing tick
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/screenFadeOutStepTick_801CE6C.yaml
	thumb_local_start
screenFadeOutStepTick_801CE6C:
	push {lr}
	ldrb r0, [r5,#7]
	mov r1, #0x20 
	mul r0, r1
	mov r2, #0xe0
	sub r2, r2, r0
	ldrb r3, [r5,#6]
	mov r0, #0
	mov r1, #0x40 
	bl sprite_setAffineTransform_802FE7A
	ldrb r0, [r5,#7]
	cmp r0, #5
	blt locret_801CE90
	mov r0, #4
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#7]
locret_801CE90:
	pop {pc}
	thumb_func_end screenFadeOutStepTick_801CE6C

// symdb: Picks a text-advance delay based on the message window's current line/state and starts the text printer, ending the message (object state 8) once the state reaches 0x30.
// symdb: void chatbox_stepTextPrinter(struct MessageWindow *win /* r5 */) -> r0 = win->msgState, flags
// symdb: from CMP r0,#0x30; preserves r4-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chatbox_stepTextPrinter_801CE92.yaml
	thumb_local_start
chatbox_stepTextPrinter_801CE92:
	push {lr}
	ldrb r0, [r5,#7]
	cmp r0, #1
	beq loc_801CEB2
	cmp r0, #2
	beq loc_801CEB6
	cmp r0, #3
	beq loc_801CEAE
	cmp r0, #0x2e 
	beq loc_801CEB6
	cmp r0, #0x2f 
	beq loc_801CEB2
	cmp r0, #0x30 
	bne loc_801CEC2
loc_801CEAE:
	mov r2, #0x40 
	b loc_801CEB8
loc_801CEB2:
	mov r2, #0x34 
	b loc_801CEB8
loc_801CEB6:
	mov r2, #0x38 
loc_801CEB8:
	mov r0, #0
	mov r1, #0x40 
	ldrb r3, [r5,#6]
	bl sprite_setAffineTransform_802FE7A
loc_801CEC2:
	ldrb r0, [r5,#7]
	cmp r0, #0x30 
	blt locret_801CED0
	mov r0, #8
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#7]
locret_801CED0:
	pop {pc}
	thumb_func_end chatbox_stepTextPrinter_801CE92

// symdb: One step of a multi-frame task that gradually clears a slice of an event flag word, finishing the task once all slices are done.
// symdb: void sub_801CED2(taskState in r5); clobbers r0-r3 and flags; r4-r7 preserved; returns with r0 =
// symdb: step counter (or 0xC when finished) and NZ/C/V from the cmp r0,#5 / final strb
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/flags_clearWordSlicesTaskStep_801CED2.yaml
	thumb_local_start
flags_clearWordSlicesTaskStep_801CED2:
	push {lr}
	ldrb r0, [r5,#7]
	mov r1, #0x20 
	mul r0, r1
	mov r2, #0x40 
	add r2, r2, r0
	ldrb r3, [r5,#6]
	mov r0, #0
	mov r1, #0x40 
	bl sprite_setAffineTransform_802FE7A
	ldrb r0, [r5,#7]
	cmp r0, #5
	blt locret_801CEF8
	ldrb r0, [r5,#6]
	bl flags_clearFlagWordBit_802FE6A
	mov r0, #0xc
	strb r0, [r5]
locret_801CEF8:
	pop {pc}
	thumb_func_end flags_clearWordSlicesTaskStep_801CED2

// symdb: Raises the event/scene flag 0x8000 via sub_801BED6 and then hands the same flag to dispatcher sub_801DACC so the pending event or transition takes effect.
// symdb: void sub_801CEFA(void) // no incoming registers; returns via pop {pc}, r0-r3 and flags end up
// symdb: clobbered by the calls
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/event_raiseFlag8000AndDispatch_801CEFA.yaml
	thumb_local_start
event_raiseFlag8000AndDispatch_801CEFA:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0xf
	bl flags_clearBits_eStruct2035280_801BED6
	mov r0, #1
	lsl r0, r0, #0xf
	bl dispatch_801DACC // (a0: flags32) -> ()
	pop {pc}
	thumb_func_end event_raiseFlag8000AndDispatch_801CEFA

// symdb: State-machine dispatcher that reads the current state index from a work block and tail-calls the matching handler from a 5-entry ROM table.
// symdb: void sub_801CF0E(void); /* r7 in/out preserved around the handler call; NZC set by the state*4
// symdb: shift; control passes to the handler, which returns to this function's caller */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/state_dispatchHandler_801CF0E.yaml
	thumb_local_start
state_dispatchHandler_801CF0E:
	push {r7,lr}
	ldr r7, off_801CF20 // =byte_2036840 
	ldrb r0, [r7,#0x8] // (byte_2036848 - 0x2036840)
	lsl r0, r0, #2
	ldr r1, off_801CF24 // =off_801CF28 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r7,pc}
	.balign 4, 0
off_801CF20:
	.word byte_2036840
off_801CF24:
	.word off_801CF28
off_801CF28:
	.word sub_801CF3C+1
	.word sub_801CF3C+1
	.word sub_801CF3C+1
	.word sub_801CF9E+1
	.word sub_801D048+1
	thumb_func_end state_dispatchHandler_801CF0E

// () -> void
// symdb: Issues 5 DMA tile-map fills (incrementing row addresses) and optionally 1 BG-map fill, driven by a parameter block at r7.
// symdb: void dmaFillMapTiles_801CF3C(u32 r7_paramBlock); /* outputs: r1=fill_count, r2=0, r3=0;
// symdb: preserves r4-r7 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801CF3C.yaml
	thumb_local_start
sub_801CF3C:
	// :param r7:
	push {r4-r7,lr}
	ldrb r0, [r7,#2]
	lsl r0, r0, #0x10
	ldrb r1, [r7,#3]
	add r1, r1, r0
	ldr r0, dword_801CF90 // =0x80004100 
	add r0, r0, r1
	ldrb r1, [r7,#6]
	lsl r1, r1, #0x19
	orr r0, r1
	ldr r1, dword_801CF94 // =0xb370 
	mov r2, #0
	mov r3, #0
	mov r5, #0x20 
	lsl r5, r5, #0x10
	mov r4, #5
loc_801CF5C:
	mov r6, r0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r0, r6
	add r0, r0, r5
	add r1, #8
	sub r4, #1
	bne loc_801CF5C
	ldrb r0, [r7,#8]
	cmp r0, #1
	bne locret_801CF8E
	ldrb r0, [r7,#4]
	lsl r0, r0, #0x10
	ldrb r1, [r7,#5]
	add r1, r1, r0
	ldr r0, dword_801CF98 // =0x40000100 
	add r0, r0, r1
	ldrb r1, [r7,#6]
	lsl r1, r1, #0x19
	orr r0, r1
	ldr r1, word_801CF9C // =0xb398
	mov r2, #0
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
locret_801CF8E:
	pop {r4-r7,pc}
	.balign 4, 0
dword_801CF90:
	.word 0x80004100
dword_801CF94:
	.word 0xB370
dword_801CF98:
	.word 0x40000100
word_801CF9C:
	.hword 0xB398
	thumb_func_end sub_801CF3C

	thumb_local_start
sub_801CF9E:
	push {r4-r6,lr}
	ldrb r0, [r7,#2]
	lsl r0, r0, #0x10
	ldrb r1, [r7,#3]
	add r1, r1, r0
	ldr r0, dword_801D028 // =0x8100 
	add r0, r0, r1
	ldrb r1, [r7,#6]
	lsl r1, r1, #0x19
	orr r0, r1
	ldr r1, dword_801D02C // =0xb370 
	mov r2, #0
	mov r3, #6
	mov r5, #8
	lsl r5, r5, #0x10
	ldrb r4, [r7,#9]
loc_801CFBE:
	mov r6, r0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r0, r6
	add r0, r0, r5
	add r1, #2
	sub r4, #1
	bne loc_801CFBE
	ldrb r1, [r7,#0xa]
	cmp r1, #0
	beq locret_801D026
	mov r4, #4
	sub r4, r4, r1
	lsl r4, r4, #0x13
	ldr r6, dword_801D028 // =0x8100 
	sub r0, r0, r6
	sub r0, r0, r4
	ldr r6, dword_801D030 // =0x80004100 
	add r0, r0, r6
	ldr r1, dword_801D034 // =0xb380 
	mov r6, r0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r0, r6
	mov r5, #0x20 
	lsl r5, r5, #0x10
	add r0, r0, r5
	ldrb r1, [r7,#0xb]
	cmp r1, #0
	beq loc_801D012
	mov r4, #4
	sub r4, r4, r1
	lsl r4, r4, #0x13
	sub r0, r0, r4
	ldr r1, dword_801D038 // =0xb388 
	mov r6, r0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r0, r6
	mov r5, #0x20 
	lsl r5, r5, #0x10
	add r0, r0, r5
loc_801D012:
	ldrb r1, [r7,#0xc]
	cmp r1, #0
	beq locret_801D026
	ldr r1, dword_801D040 // =0xc000c000 
	bic r0, r1
	ldr r1, dword_801D03C // =0x40000100 
	orr r0, r1
	ldr r1, dword_801D044 // =0xb390 
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
locret_801D026:
	pop {r4-r6,pc}
	.balign 4, 0
dword_801D028:
	.word 0x8100
dword_801D02C:
	.word 0xB370
dword_801D030:
	.word 0x80004100
dword_801D034:
	.word 0xB380
dword_801D038:
	.word 0xB388
dword_801D03C:
	.word 0x40000100
dword_801D040:
	.word 0xC000C000
dword_801D044:
	.word 0xB390
	thumb_func_end sub_801CF9E

	thumb_local_start
sub_801D048:
	push {r4-r7,lr}
	bl sub_801CF3C // () -> void
	ldrb r0, [r7]
	cmp r0, #8
	blt loc_801D070
	ldrb r0, [r7,#0xe]
	cmp r0, #0
	bne locret_801D128
	mov r0, #1
	strb r0, [r7,#0xe]
	mov r0, #9
	mov r1, #5
	mov r2, #3
	mov r3, #0
	mov r4, #0xc
	mov r5, #2
	bl call_sub_3005EBA
	b locret_801D128
loc_801D070:
	push {r4-r7}
	ldr r0, off_801D1C4 // =TextScript86F0374 
	mov r1, #2
	ldr r2, off_801D1C8 // =byte_203C4E0 
	ldr r3, dword_801D1CC // =0x6009360 
	mov r4, #2
	mov r5, #1
	ldr r6, off_801D1D0 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	// j
	mov r0, #0xe
	// i
	mov r1, #5
	// tileIds
	ldr r3, off_801D18C // =byte_801D190
	// tileBlock32x32
	mov r2, #3
	mov r4, #2
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7}
	ldrh r0, [r7,#0xc]
	bl sub_801D12A
	ldr r7, off_801D1D4 // =byte_2036840 
	ldrh r0, [r7,#0xc] // (word_203684C - 0x2036840)
	bl countHexDigits_8000C5C
	cmp r0, #4
	beq loc_801D0FE
	cmp r0, #3
	beq loc_801D0DA
	cmp r0, #2
	beq loc_801D0C8
	ldr r1, [sp,#4]
	lsr r1, r1, #0x10
	str r1, [sp]
	mov r0, #0
	str r0, [sp,#4]
	ldr r1, [sp,#0xc]
	lsr r1, r1, #0x10
	str r1, [sp,#8]
	mov r0, #0
	str r0, [sp,#0xc]
	b loc_801D0FE
loc_801D0C8:
	ldr r2, [sp,#4]
	str r2, [sp]
	mov r0, #0
	str r0, [sp,#4]
	ldr r2, [sp,#0xc]
	str r2, [sp,#8]
	mov r0, #0
	str r0, [sp,#0xc]
	b loc_801D0FE
loc_801D0DA:
	ldr r1, [sp]
	ldr r2, [sp,#4]
	mov r0, r2
	lsl r2, r2, #0x10
	lsr r1, r1, #0x10
	orr r1, r2
	str r1, [sp]
	lsr r0, r0, #0x10
	str r0, [sp,#4]
	ldr r1, [sp,#8]
	ldr r2, [sp,#0xc]
	mov r0, r2
	lsl r2, r2, #0x10
	lsr r1, r1, #0x10
	orr r1, r2
	str r1, [sp,#8]
	lsr r0, r0, #0x10
	str r0, [sp,#0xc]
loc_801D0FE:
	ldrh r0, [r7,#0xa] // (word_203684A - 0x2036840)
	bl sub_801D12A
	// j
	mov r0, #9
	// i
	mov r1, #5
	// tileBlock32x32
	mov r2, #3
	// tileIds
	mov r3, sp
	mov r4, #4
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r0-r3}
	// j
	mov r0, #0x11
	// i
	mov r1, #5
	// tileBlock32x32
	mov r2, #3
	// tileIds
	mov r3, sp
	mov r4, #4
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r0-r3}
locret_801D128:
	pop {r4-r7,pc}
	thumb_func_end sub_801D048

	thumb_local_start
sub_801D12A:
	mov r4, r0
	mov r7, lr
	bl countHexDigits_8000C5C
	mov r2, r4
	mov r6, #4
	sub r6, r6, r0
	ldr r1, dword_801D198 // =0xd1b9 
	mov r3, #2
loc_801D13C:
	mov r0, #0xf
	and r0, r2
	lsl r0, r0, #1
	add r0, r0, r1
	lsl r4, r0, #0x10
	lsr r2, r2, #4
	mov r0, #0xf
	and r0, r2
	lsl r0, r0, #1
	add r0, r0, r1
	orr r0, r4
	push {r0}
	lsr r2, r2, #4
	sub r3, #1
	bne loc_801D13C
	ldr r0, [sp]
	ldr r1, [sp,#4]
	ldr r2, dword_801D19C // =0x10001 
	sub r0, r0, r2
	sub r1, r1, r2
	push {r0,r1}
	lsl r6, r6, #3
	ldr r3, off_801D1A0 // =byte_801D1A4
	ldr r2, [r3,r6]
	add r6, #4
	ldr r3, [r3,r6]
	mov r6, sp
	mov r1, #0
loc_801D174:
	ldr r0, [r6,r1]
	and r0, r2
	str r0, [r6,r1]
	add r1, #4
	ldr r0, [r6,r1]
	and r0, r3
	str r0, [r6,r1]
	add r1, #4
	cmp r1, #0x10
	bne loc_801D174
	mov pc, r7
	.balign 4, 0
off_801D18C:
	.word byte_801D190
byte_801D190:
	.byte 0x9B, 0xD0, 0x9D, 0xD0, 0x9C, 0xD0, 0x9E, 0xD0
dword_801D198:
	.word 0xD1B9
dword_801D19C:
	.word 0x10001
off_801D1A0:
	.word byte_801D1A4
byte_801D1A4:
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0
	.byte 0x0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x0, 0x0
	.byte 0x0, 0x0, 0xFF, 0xFF, 0xFF, 0xFF, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0xFF, 0xFF
off_801D1C4:
	.word TextScript86F0374
off_801D1C8:
	.word byte_203C4E0
dword_801D1CC:
	.word 0x6009360
off_801D1D0:
	.word dword_86B7AE0
off_801D1D4:
	.word byte_2036840
	thumb_func_end sub_801D12A

	thumb_local_start
sub_801D1D8:
	push {lr}
	ldr r3, off_801D27C // =unk_2036850 
	ldrb r0, [r3,#0x7] // (byte_2036857 - 0x2036850)
	sub r0, #1
	strb r0, [r3,#0x7] // (byte_2036857 - 0x2036850)
	bne locret_801D1F4
	mov r0, #1
	lsl r0, r0, #0x10
	bl flags_clearBits_eStruct2035280_801BED6
	mov r0, #1
	lsl r0, r0, #0x10
	bl dispatch_801DACC // (a0: flags32) -> ()
locret_801D1F4:
	pop {pc}
	thumb_func_end sub_801D1D8

	thumb_local_start
sub_801D1F6:
	push {r4-r7,lr}
	ldr r7, off_801D27C // =unk_2036850 
	ldrb r0, [r7,#0x2] // (word_2036852 - 0x2036850)
	lsl r0, r0, #0x10
	ldrb r1, [r7,#0x3] // (word_2036852+1 - 0x2036850)
	add r1, r1, r0
	ldr r0, dword_801D280 // =0x8000 
	add r0, r0, r1
	ldr r1, dword_801D284 // =0xb394 
	mov r2, #0
	mov r3, #6
	mov r5, #8
	lsl r5, r5, #0x10
	ldrb r4, [r7,#0x9] // (byte_2036859 - 0x2036850)
loc_801D212:
	mov r6, r0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r0, r6
	add r0, r0, r5
	add r1, #2
	sub r4, #1
	bne loc_801D212
	ldrb r1, [r7,#0xa] // (byte_203685A - 0x2036850)
	cmp r1, #0
	beq locret_801D27A
	mov r4, #4
	sub r4, r4, r1
	lsl r4, r4, #0x13
	ldr r6, dword_801D280 // =0x8000 
	sub r0, r0, r6
	sub r0, r0, r4
	ldr r6, dword_801D288 // =0x80004000 
	add r0, r0, r6
	ldr r1, dword_801D28C // =0xb3a4 
	mov r6, r0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r0, r6
	mov r5, #0x20 
	lsl r5, r5, #0x10
	add r0, r0, r5
	ldrb r1, [r7,#0xb] // (byte_203685B - 0x2036850)
	cmp r1, #0
	beq loc_801D266
	mov r4, #4
	sub r4, r4, r1
	lsl r4, r4, #0x13
	sub r0, r0, r4
	ldr r1, dword_801D290 // =0xb3ac 
	mov r6, r0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r0, r6
	mov r5, #0x20 
	lsl r5, r5, #0x10
	add r0, r0, r5
loc_801D266:
	ldrb r1, [r7,#0xc] // (byte_203685C - 0x2036850)
	cmp r1, #0
	beq locret_801D27A
	ldr r1, dword_801D298 // =0xc000c000 
	bic r0, r1
	ldr r1, dword_801D294 // =0x40000000 
	orr r0, r1
	ldr r1, dword_801D29C // =0xb390 
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
locret_801D27A:
	pop {r4-r7,pc}
	.balign 4, 0
off_801D27C:
	.word unk_2036850
dword_801D280:
	.word 0x8000
dword_801D284:
	.word 0xB394
dword_801D288:
	.word 0x80004000
dword_801D28C:
	.word 0xB3A4
dword_801D290:
	.word 0xB3AC
dword_801D294:
	.word 0x40000000
dword_801D298:
	.word 0xC000C000
dword_801D29C:
	.word 0xB390
	thumb_func_end sub_801D1F6

	thumb_local_start
sub_801D2A0:
	push {lr}
	pop {pc}
	thumb_func_end sub_801D2A0

	thumb_local_start
sub_801D2A4:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	push {r5}
	// j
	mov r0, #1
	// i
	mov r1, #0x12
	// tileBlock32x32
	mov r2, #0
	// tileIds
	ldr r3, off_801D340 // =byte_801D9B4
	mov r4, #0x1c
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r5}
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#0x16]
	bl sub_802E066
	str r0, [sp]
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#0x16]
	bl sub_802E440
	mov r1, #0
	mov r2, #0
	ldr r3, [sp]
	bl sub_801D344
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#0x16]
	bl sub_802E44A
	ldr r1, dword_801D330 // =0x280
	ldr r2, dword_801D334 // =0x200
	ldr r3, [sp]
	bl sub_801D344
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#0x16]
	bl sub_802E454
	ldr r1, dword_801D338 // =0x500
	ldr r2, dword_801D33C // =0x400
	ldr r3, [sp]
	bl sub_801D344
	ldrb r0, [r5,#0x1a]
	cmp r0, #0
	beq loc_801D32A
	ldrh r0, [r5,#0x30]
	add r0, #1
	strh r0, [r5,#0x30]
	mov r1, #0x20 
	and r0, r1
	beq loc_801D32A
	push {r5}
	ldrb r0, [r5,#0x1a]
	sub r0, #1
	mov r1, #0xa
	mul r0, r1
	add r0, #1
	mov r1, #0x12
	mov r2, #0
	mov r3, #0
	mov r4, #9
	mov r5, #2
	bl call_sub_3005EBA
	pop {r5}
loc_801D32A:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_801D330:
	.word 0x280
dword_801D334:
	.word 0x200
dword_801D338:
	.word 0x500
dword_801D33C:
	.word 0x400
off_801D340:
	.word byte_801D9B4
	thumb_func_end sub_801D2A4

	thumb_local_start
sub_801D344:
	push {r4-r7,lr}
	sub sp, sp, #0x10
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	str r0, [sp]
	str r1, [sp,#4]
	str r2, [sp,#8]
	str r3, [sp,#0xc]
	ldr r1, dword_801D3E4 // =0x1ff 
	cmp r0, r1
	bne loc_801D36C
	ldr r1, dword_801D3D0 // =0x600c940 
	ldr r2, [sp,#4]
	add r1, r1, r2
	mov r3, #0xa
	bl sub_801D3F8
	ldr r0, off_801D3F4 // =TextScript86F0300 
	mov r1, #0x1c
	b loc_801D3A2
loc_801D36C:
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r3, [r0,#7]
	cmp r3, #2
	ble loc_801D378
	mov r3, #0
loc_801D378:
	lsl r3, r3, #2
	ldr r0, off_801D3BC // =off_801D3C0 
	ldr r0, [r0,r3]
	ldr r1, off_801D3D4 // =off_801D3D8 
	ldr r1, [r1,r3]
	ldr r2, [sp,#0xc]
	cmp r2, r1
	bge loc_801D390
	mov r1, #0x20 
	mov r2, #0x14
	mul r1, r2
	add r0, r0, r1
loc_801D390:
	ldr r1, dword_801D3D0 // =0x600c940 
	ldr r2, [sp,#4]
	add r1, r1, r2
	ldr r2, off_801D3CC // =0x280 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, [sp]
	bl chip_SelectNameTextTable_8027D10
loc_801D3A2:
	ldr r2, off_801D3E8 // =unk_203A380 
	ldr r3, dword_801D3EC // =0x600d0c0 
	ldr r4, [sp,#8]
	add r2, r2, r4
	add r3, r3, r4
	mov r4, #8
	mov r5, #1
	ldr r6, off_801D3F0 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	add sp, sp, #0x10
	pop {r4-r7,pc}
	.balign 4, 0
off_801D3BC:
	.word off_801D3C0
off_801D3C0:
	.word dword_86E9A2C
	.word dword_86E9F2C
	.word dword_86EA42C
off_801D3CC:
	.word 0x280
dword_801D3D0:
	.word 0x600C940
off_801D3D4:
	.word off_801D3D8
off_801D3D8:
	.word 0x1500
	.word 0x2A00
	.word 0x4000
dword_801D3E4:
	.word 0x1FF
off_801D3E8:
	.word unk_203A380
dword_801D3EC:
	.word 0x600D0C0
off_801D3F0:
	.word dword_86B7AE0
off_801D3F4:
	.word TextScript86F0300
	thumb_func_end sub_801D344

	thumb_local_start
sub_801D3F8:
	push {r0-r4,lr}
	ldr r0, off_801D40C // =byte_801D410
	mov r4, r3
	mov r2, #0x40 
loc_801D400:
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r1, r1, r2
	sub r4, #1
	bne loc_801D400
	pop {r0-r4,pc}
	.balign 4, 0
off_801D40C:
	.word byte_801D410
byte_801D410:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_801D3F8

	thumb_local_start
sub_801D450:
	push {lr}
	bl battle_isPaused
	tst r0, r0
	bne locret_801D478
	bl battle_isTimeStop
	bne locret_801D478
	ldrh r0, [r5,#0x34]
	add r0, #1
	cmp r0, #6
	blt loc_801D476
	ldrh r1, [r5,#0x36]
	add r1, #1
	cmp r1, #6
	blt loc_801D472
	mov r1, #0
loc_801D472:
	strh r1, [r5,#0x36]
	mov r0, #0
loc_801D476:
	strh r0, [r5,#0x34]
locret_801D478:
	pop {pc}
	thumb_func_end sub_801D450

	thumb_local_start
sub_801D47A:
	push {r4-r6,lr}
	ldrh r0, [r5,#0x36]
	mov r1, #1
	and r1, r0
	ldr r2, off_801D508 // =0x40 
	mul r1, r2
	ldr r0, off_801D500 // =dword_86E98CC 
	add r0, r0, r1
	ldr r1, dword_801D504 // =0x6017900 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	bl getEntryPtr_2036120_1D0_802E070
	ldrh r1, [r0,#0x3e]
	mov r4, #0x50 
	mul r4, r1
	lsl r4, r4, #0x10
	ldrh r1, [r5,#0x36]
	cmp r1, #3
	blt loc_801D4AA
	sub r1, #3
loc_801D4AA:
	ldr r0, off_801D50C // =dword_801D510
	ldrb r0, [r0,r1]
	mov r2, #3
	mov r3, #0
	ldr r1, dword_801D4F0 // =0x80044080 
	add r0, r0, r1
	add r0, r0, r4
	mov r1, #0x14
	lsl r1, r1, #0x10
	add r0, r0, r1
	ldr r1, dword_801D4F4 // =0xc3c0 
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r2, #3
	mov r3, #0
	ldr r0, dword_801D4F8 // =0x8090 
	add r0, r0, r4
	ldr r1, dword_801D4FC // =0xc3c8 
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r2, #3
	mov r3, #0
	ldr r0, dword_801D4F8 // =0x8090 
	add r0, r0, r4
	mov r1, #0x48 
	lsl r1, r1, #0x10
	add r0, r0, r1
	mov r1, #1
	lsl r1, r1, #0x1c
	orr r0, r1
	ldr r1, dword_801D4FC // =0xc3c8 
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	pop {r4-r6,pc}
	.balign 4, 0
dword_801D4F0:
	.word 0x80044080
dword_801D4F4:
	.word 0xC3C0
dword_801D4F8:
	.word 0x8090
dword_801D4FC:
	.word 0xC3C8
off_801D500:
	.word dword_86E98CC
dword_801D504:
	.word 0x6017900
off_801D508:
	.word 0x40
off_801D50C:
	.word dword_801D510
dword_801D510:
	.word 0x10300
	thumb_func_end sub_801D47A

	thumb_local_start
sub_801D514:
	push {lr}
	ldrh r0, [r5,#0x32]
	sub r0, #1
	strh r0, [r5,#0x32]
	bne loc_801D526
	ldr r0, dword_801D544 // =0x100000 
	bl flags_clearBits_eStruct2035280_801BED6
	b loc_801D53A
loc_801D526:
	mov r1, #0xf
	and r1, r0
	bne locret_801D540
	mov r1, #0x10
	tst r1, r0
	beq loc_801D53A
	ldr r0, dword_801D544 // =0x100000 
	bl dispatch_801DA48
	b locret_801D540
loc_801D53A:
	ldr r0, dword_801D544 // =0x100000 
	bl dispatch_801DACC // (a0: flags32) -> ()
locret_801D540:
	pop {pc}
	.balign 4, 0
dword_801D544:
	.word 0x100000
	thumb_func_end sub_801D514

	thumb_local_start
sub_801D548:
	push {lr}
	ldrb r0, [r5,#0x1b]
	sub r0, #1
	strb r0, [r5,#0x1b]
	bne locret_801D562
	mov r0, #1
	lsl r0, r0, #0x15
	bl flags_clearBits_eStruct2035280_801BED6
	mov r0, #1
	lsl r0, r0, #0x15
	bl dispatch_801DACC // (a0: flags32) -> ()
locret_801D562:
	pop {pc}
	thumb_func_end sub_801D548

	thumb_local_start
sub_801D564:
	push {r4-r7,lr}
	ldr r0, dword_801D580 // =0x406c0000 
	ldr r1, dword_801D584 // =0xd368 
	mov r2, #0
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldr r0, dword_801D588 // =0x7c8000 
	ldr r1, dword_801D58C // =0xd36c 
	mov r2, #0
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	pop {r4-r7,pc}
	.balign 4, 0
dword_801D580:
	.word 0x406C0000
dword_801D584:
	.word 0xD368
dword_801D588:
	.word 0x7C8000
dword_801D58C:
	.word 0xD36C
	thumb_func_end sub_801D564

	thumb_local_start
sub_801D590:
	push {r4,r6,r7,lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	bl getEntryPtr_2036120_1D0_802E070
	ldrh r1, [r0,#0x36]
	cmp r1, #0
	bne loc_801D5AC
	ldrh r1, [r0,#0x38]
	cmp r1, #0
	beq locret_801D618
	ldr r0, off_801D630 // =dword_86E960C 
	b loc_801D5BA
loc_801D5AC:
	ldr r0, off_801D62C // =dword_86E958C 
	push {r1}
	ldr r1, dword_801D638 // =0x6017680 
	mov r2, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	b loc_801D5CE
loc_801D5BA:
	push {r1}
	ldr r1, dword_801D638 // =0x6017680 
	mov r2, #0x60 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, off_801D650 // =dword_86A5D60 
	ldr r1, dword_801D63C // =0x60176e0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_801D5CE:
	ldr r0, off_801D654 // =dword_86E966C 
	ldr r1, dword_801D640 // =0x6017700 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r4, #0
	pop {r0}
	bl memory_bcdConvert
	mov r7, #0xf
	and r7, r0
	lsr r0, r0, #4
	mov r6, #0xf
	and r6, r0
	lsr r0, r0, #4
	ldr r1, dword_801D644 // =0x6017720 
	cmp r0, #0
	beq loc_801D5FA
	add r4, #1
	bl sub_801D61A
	add r1, #0x20 
loc_801D5FA:
	mov r0, r6
	bl sub_801D61A
	add r1, #0x20 
	mov r0, r7
	bl sub_801D61A
	add r1, #0x20 
	cmp r4, #0
	bne locret_801D618
	ldr r0, off_801D650 // =dword_86A5D60 
	ldr r1, dword_801D64C // =0x6017760 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
locret_801D618:
	pop {r4,r6,r7,pc}
	thumb_func_end sub_801D590

	thumb_local_start
sub_801D61A:
	push {r1,lr}
	mov r2, #0x20 
	mul r0, r2
	ldr r3, off_801D634 // =off_86E968C 
	add r0, r0, r3
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r1,pc}
	.balign 4, 0
off_801D62C:
	.word dword_86E958C
off_801D630:
	.word dword_86E960C
off_801D634:
	.word off_86E968C
dword_801D638:
	.word 0x6017680
dword_801D63C:
	.word 0x60176E0
dword_801D640:
	.word 0x6017700
dword_801D644:
	.word 0x6017720
	.word 0x6017740
dword_801D64C:
	.word 0x6017760
off_801D650:
	.word dword_86A5D60
off_801D654:
	.word dword_86E966C
	.word off_86E968C
	thumb_func_end sub_801D61A

	thumb_local_start
sub_801D65C:
	push {r4-r7,lr}
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#0x16]
	bl getBattleHandAddr_8010018
	ldrb r1, [r0]
	add r1, #1
	lsl r1, r1, #1
	ldrh r0, [r0,r1]
	ldr r1, dword_801D6D4 // =0xffff 
	cmp r0, r1
	bne locret_801D6C8
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#0x16]
	bl getEntryPtr_2036120_1D0_802E070
	ldrh r1, [r0,#0x36]
	cmp r1, #0
	bne loc_801D688
	ldrh r1, [r0,#0x38]
	cmp r1, #0
	beq locret_801D6C8
loc_801D688:
	ldr r1, [r5,#0x48]
	mov r0, #0x34 
	add r0, r0, r1
	bl projectObjectToScreen_800362C
	cmp r2, #0
	beq locret_801D6C8
	bl sub_801D6D8
	mov r2, #0xff
	add r2, r2, r2
	add r2, #1
	and r0, r2
	lsl r0, r0, #0x10
	mov r2, #0xff
	and r1, r2
	add r6, r0, r1
	ldr r1, dword_801D6D0 // =0xc7b4 
	ldr r0, dword_801D6CC // =0x40004000 
	add r0, r0, r6
	mov r2, #2
	mov r3, #0
	push {r0,r1}
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	pop {r0,r1}
	add r0, #9
	add r1, #4
	mov r2, #2
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
locret_801D6C8:
	pop {r4-r7,pc}
	.balign 4, 0
dword_801D6CC:
	.word 0x40004000
dword_801D6D0:
	.word 0xC7B4
dword_801D6D4:
	.word 0xFFFF
	thumb_func_end sub_801D65C

	thumb_local_start
sub_801D6D8:
	push {lr}
	push {r0,r1}
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#0x16]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte
	add r0, r0, r0
	ldr r3, off_801D6FC // =dword_801D700
	add r3, r3, r0
	pop {r0,r1}
	mov r2, #0
	ldrsb r2, [r3,r2]
	add r0, r0, r2
	mov r2, #1
	ldrsb r2, [r3,r2]
	add r1, r1, r2
	pop {pc}
	.balign 4, 0
off_801D6FC:
	.word dword_801D700
dword_801D700:
	.word 0xBDF8C9F8
	.word 0xACF4C5F8
	.word 0xB8FBC000
	.word 0xC2FFB8FC
	.word 0xB1F7BAFB
	.word 0xC4FAC4FC
	.hword 0xB3F7
	thumb_func_end sub_801D6D8

	thumb_local_start
sub_801D71A:
	push {r4,r7,lr}
	mov r0, #oBattleState_AliveOpponentActors
	mov r7, r10
	ldr r7, [r7,#oToolkit_BattleStatePtr]
	add r7, r7, r0
	ldr r7, [r7]
	tst r7, r7
	beq locret_801D790
	ldrh r1, [r7,#0x24]
	mov r3, #0x50 
	ldrh r3, [r5,r3]
	cmp r1, r3
	beq loc_801D770
	bgt loc_801D74E
	mov r0, #2
	mov r4, #0x52 
	strb r0, [r5,r4]
	mov r2, r3
	sub r2, r2, r1
	asr r2, r2, #3
	add r2, #4
	sub r3, r3, r2
	cmp r3, r1
	bge loc_801D764
	mov r3, r1
	b loc_801D764
loc_801D74E:
	mov r0, #1
	mov r4, #0x52 
	strb r0, [r5,r4]
	mov r2, r1
	sub r2, r2, r3
	asr r2, r2, #3
	add r2, #4
	add r3, r3, r2
	cmp r3, r1
	ble loc_801D764
	mov r3, r1
loc_801D764:
	mov r4, #0x50 
	strh r3, [r5,r4]
	mov r0, #0xf
	mov r4, #0x54 
	strb r0, [r5,r4]
	pop {r4,r7,pc}
loc_801D770:
	mov r4, #0x54 
	ldrb r0, [r5,r4]
	cmp r0, #0
	beq loc_801D780
	sub r0, #1
	mov r4, #0x54 
	strb r0, [r5,r4]
	bne locret_801D790
loc_801D780:
	mov r0, #2
	ldrh r2, [r7,#0x26]
	lsr r2, r2, #2
	cmp r1, r2
	ble loc_801D78C
	mov r0, #0
loc_801D78C:
	mov r4, #0x52 
	strb r0, [r5,r4]
locret_801D790:
	pop {r4,r7,pc}
	thumb_func_end sub_801D71A

	thumb_local_start
sub_801D792:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x10
	mov r6, sp
	mov r4, #0x50 
	ldrh r0, [r5,r4]
	bl memory_bcdConvert
	mov r2, r0
	bl countHexDigits_8000C5C
	lsl r0, r0, #2
	ldr r1, dword_801D810 // =0xaaaa 
	lsl r1, r0
	orr r2, r1
	push {r5}
	ldr r5, dword_801D80C // =0xc1a0 
	mov r1, r6
	add r1, #8
	mov r3, #6
loc_801D7B8:
	mov r0, #0xf
	and r0, r2
	lsl r0, r0, #1
	add r0, r0, r5
	strh r0, [r6,r3]
	add r0, #1
	strh r0, [r1,r3]
	lsr r2, r2, #4
	sub r3, #2
	bpl loc_801D7B8
	ldr r5, [sp]
	mov r0, #0x18
	// j
	add r0, #1
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	mov r3, r6
	mov r4, #4
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r5}
	mov r4, #0x52 
	ldrb r0, [r5,r4]
	lsl r0, r0, #5
	ldr r3, off_801D7FC // =off_801D800 
	ldr r1, [r3]
	add r0, r0, r1
	ldr r1, [r3,#0x4] // (off_801D804 - 0x801d800)
	ldr r2, [r3,#0x8] // (dword_801D808 - 0x801d800)
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add sp, sp, #0x10
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_801D7FC:
	.word off_801D800
off_801D800:
	.word dword_86E1C78
off_801D804:
	.word unk_3001AE0
dword_801D808:
	.word 0x20
dword_801D80C:
	.word 0xC1A0
dword_801D810:
	.word 0xAAAA
	thumb_func_end sub_801D792

// symdb: Returns 1 when the battle's object animation stepper should use a "simple" code path, based on battle mode, two event flags, a battle-flag bit, and a battle-effects bit; otherwise 0.
// symdb: (r10 = ToolkitPtr) -> r0 = 0 or 1 (bool)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_shouldUseSimpleAnimMode_801D814.yaml
	thumb_local_start
battle_shouldUseSimpleAnimMode_801D814:
	push {r4,lr}
	mov r4, #0
	bl GetBattleMode
	cmp r0, #1
	beq loc_801D84A
	cmp r0, #5
	beq loc_801D848
	movflag EVENT_163
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_801D84A
	bl TestBattleFlag_0x40
	bne loc_801D84A
	bl GetBattleEffects // () -> int
	ldr r1, dword_801D850 // =0x200000 
	tst r0, r1
	bne loc_801D84A
	movflag EVENT_E0
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_801D84A
loc_801D848:
	mov r4, #1
loc_801D84A:
	mov r0, r4
	pop {r4,pc}
	.balign 4, 0
dword_801D850:
	.word 0x200000
off_801D854:
	.word dword_86E0AB8
	.word dword_86E0AF8
	.word dword_86E0B38
	.word dword_86E0B78
	.word dword_86E0BB8
	.word dword_86E0BF8
	.word dword_86E0C38
	.word dword_86E0C78
	.word dword_86E0CB8
	.word dword_86E0CF8
	.word dword_86B7AE0
off_801D880:
	.word dword_86E0D38
	.word dword_86E0D78
	.word dword_86E0DB8
	.word dword_86E0DF8
	.word dword_86E0E38
	.word dword_86E0E78
	.word dword_86E0EB8
	.word dword_86E0EF8
	.word dword_86E0F38
	.word dword_86E0F78
	.word dword_86B7AE0
off_801D8AC:
	.word dword_86E0FB8
	.word dword_86E0FF8
	.word dword_86E1038
	.word dword_86E1078
	.word dword_86E10B8
	.word dword_86E10F8
	.word dword_86E1138
	.word dword_86E1178
	.word dword_86E11B8
	.word dword_86E11F8
	.word dword_86B7AE0
off_801D8D8:
	.word dword_86B7B20
	.word dword_86B7B60
	.word dword_86B7BA0
	.word dword_86B7BE0
	.word dword_86B7C20
	.word dword_86B7C60
	.word dword_86B7CA0
	.word dword_86B7CE0
	.word dword_86B7D20
	.word dword_86B7D60
	.word dword_86B7AE0
byte_801D904:
	.byte 0x4C, 0xD2, 0x4E, 0xD2, 0x50, 0xD2, 0x4A, 0xD2, 0x0
	.byte 0x0, 0x0, 0x0, 0x52, 0xD2, 0x54, 0xD2, 0x56, 0xD2
	.byte 0x4A, 0xD2, 0x4D, 0xD2, 0x4F, 0xD2, 0x51, 0xD2, 0x4B
	.byte 0xD2, 0x0, 0x0, 0x0, 0x0, 0x53, 0xD2, 0x55, 0xD2
	.byte 0x57, 0xD2, 0x4B, 0xD2
off_801D92C:
	.word dword_86F2E00
	.word dword_86F2E20
	.word dword_86F2E40
	.word dword_86F2E14
	.word dword_86F2E34
	.word dword_86F2E54
byte_801D944:
	.byte 0x58, 0xD2, 0x5A, 0xD2, 0x5C, 0xD2, 0x5E, 0xD2, 0x60
	.byte 0xD2, 0x62, 0xD2, 0x64, 0xD2, 0x66, 0xD2
byte_801D954:
	.byte 0x59, 0xD2, 0x5B, 0xD2, 0x5D, 0xD2, 0x5F, 0xD2, 0x61
	.byte 0xD2, 0x63, 0xD2, 0x65, 0xD2, 0x67, 0xD2
byte_801D964:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xCC
	.byte 0xD1, 0xCC, 0xD1, 0xCC, 0xD1, 0xCC, 0xD1, 0xCD, 0xD1, 0xCD, 0xD1, 0xCD, 0xD1, 0xCD, 0xD1
byte_801D984:
	.byte 0xAB, 0xA0, 0xAC, 0xA0, 0xAD, 0xA0, 0xAE, 0xA0, 0xAF
	.byte 0xA0, 0xB0, 0xA0, 0xB1, 0xA0, 0xB2, 0xA0, 0xB3, 0xA0
	.byte 0xB4, 0xA0, 0xB5, 0xA0, 0xB6, 0xA0, 0xB7, 0xA0, 0xB8
	.byte 0xA0, 0xB9, 0xA0, 0xBA, 0xA0, 0xBB, 0xA0, 0xBC, 0xA0
	.byte 0xBD, 0xA0, 0xBE, 0xA0, 0xBF, 0xA0, 0xC0, 0xA0, 0xC1
	.byte 0xA0, 0xC2, 0xA0
byte_801D9B4:
	.byte 0x86, 0xD2, 0x88, 0xD2, 0x8A, 0xD2, 0x8C, 0xD2, 0x8E
	.byte 0xD2, 0x90, 0xD2, 0x92, 0xD2, 0x94, 0xD2, 0x0, 0x0
	.byte 0x0, 0x0, 0x96, 0xD2, 0x98, 0xD2, 0x9A, 0xD2, 0x9C
	.byte 0xD2, 0x9E, 0xD2, 0xA0, 0xD2, 0xA2, 0xD2, 0xA4, 0xD2
	.byte 0x0, 0x0, 0x0, 0x0, 0xA6, 0xD2, 0xA8, 0xD2, 0xAA
	.byte 0xD2, 0xAC, 0xD2, 0xAE, 0xD2, 0xB0, 0xD2, 0xB2, 0xD2
	.byte 0xB4, 0xD2, 0x87, 0xD2, 0x89, 0xD2, 0x8B, 0xD2, 0x8D
	.byte 0xD2, 0x8F, 0xD2, 0x91, 0xD2, 0x93, 0xD2, 0x95, 0xD2
	.byte 0x0, 0x0, 0x0, 0x0, 0x97, 0xD2, 0x99, 0xD2, 0x9B
	.byte 0xD2, 0x9D, 0xD2, 0x9F, 0xD2, 0xA1, 0xD2, 0xA3, 0xD2
	.byte 0xA5, 0xD2, 0x0, 0x0, 0x0, 0x0, 0xA7, 0xD2, 0xA9
	.byte 0xD2, 0xAB, 0xD2, 0xAD, 0xD2, 0xAF, 0xD2, 0xB1, 0xD2
	.byte 0xB3, 0xD2, 0xB5, 0xD2
	thumb_func_end battle_shouldUseSimpleAnimMode_801D814

// symdb: Per-frame battle-scene setup — queues the battle scene's graphics transfers, sets a render-info value, and refreshes the stored player battle object pointer.
// symdb: void sub_801DA24(void); /* r10 = toolkit base in, clobbers r0-r2, lr; no meaningful outputs (c/v
// symdb: flag residue only) */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_sceneFrameSetup_801DA24.yaml
	thumb_func_start battle_sceneFrameSetup_801DA24
battle_sceneFrameSetup_801DA24:
	push {lr}
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	ldr r0, dword_801DA44 // =0x1f09 
	strh r0, [r1,#oRenderInfo_Unk_0a]
	// dataList
	ldr r0, off_801DA40 // =off_801ECB4 
	bl QueueGFXTransfersInList // (u32 *dataRefs) -> void
	bl battle_preUpdateAndGetPlayerObject_80103EC
	ldr r1, off_801DB50 // =eStruct2035280
	str r0, [r1,#0x48] // (dword_20352C8 - 0x2035280)
	pop {pc}
	.balign 4, 0
off_801DA40:
	.word off_801ECB4
dword_801DA44:
	.word 0x1F09
	thumb_func_end battle_sceneFrameSetup_801DA24

	thumb_func_start dispatch_801DA48
dispatch_801DA48:
	push {r5-r7,lr}
	ldr r5, off_801DB50 // =eStruct2035280
	ldr r6, off_801DA68 // =off_801DA6C 
	mov r7, r0
loc_801DA50:
	lsr r7, r7, #1
	bcs loc_801DA5A
	beq locret_801DA64
	add r6, #4
	b loc_801DA50
loc_801DA5A:
	ldr r0, [r6]
	mov lr, pc
	bx r0
	add r6, #4
	b loc_801DA50
locret_801DA64:
	pop {r5-r7,pc}
	.balign 4, 0
off_801DA68:
	.word off_801DA6C
off_801DA6C:
	.word battle_setUnkFlagBit0_eStruct2035280_801DB60+1
	.word sub_801DB78+1
	.word battle_setFlag0x04_eStruct2035280_801DC6E+1
	.word sub_801DD7C+1
	.word setupBattleBackground_801DDF6+1
	.word sub_801DE3C+1
	.word battle_setUnkFlags44_0x40_801E006+1
	.word background_applyFixedTilePatch_801E03E+1
	.word sub_801E1E4+1
	.word sub_801E144+1
	.word battle_loadModeGfx_801E10E+1
	.word sub_801E376+1
	.word sub_801E468+1
	.word sub_801E4F4+1
	.word sub_801E5EC+1
	.word sub_801E748+1
	.word sub_801EB0C+1
	.word sub_801DE82+1
	.word sub_801EB7C+1
	.word sub_801EBDE+1
	.word sub_801E3E4+1
	.word sub_801EC38+1
	.word sub_801EC90+1
	.word sub_801E07C+1
	thumb_func_end dispatch_801DA48

	thumb_func_start dispatch_801DACC
dispatch_801DACC: // (a0: flags32) -> ()
	push {r5-r7,lr}
	ldr r5, off_801DB50 // =eStruct2035280
	ldr r6, off_801DAEC // =off_801DAF0 

	ldr r7, [r5,#oStruct2035280_UnkFlags_44]
	and r7, r0

loop_801DAD6:
	lsr r7, r7, #1
	bcs loc_801DAE0
	beq locret_801DAEA
	add r6, #4
	b loop_801DAD6
loc_801DAE0:

	// disabling this causes messed up graphics in the cust menu in battle. Particularly
	// in the navi icon, and battle start. Chip icons and chip images remain untouched.
	ldr r0, [r6]
	mov lr, pc
	bx r0

	add r6, #4
	b loop_801DAD6
locret_801DAEA:
	pop {r5-r7,pc}
	.balign 4, 0
off_801DAEC:
	.word off_801DAF0
off_801DAF0:
	// 0x00 (0x00)
	.word sub_801DB54+1
	// 0x04 (0x01)
	.word sub_801DB6C+1
	// 0x08 (0x02)
	.word sub_801DC60+1
	// 0x0C (0x03)
	.word sub_801DD60+1
	// 0x10 (0x04)
	.word sub_801DDD8+1
	// 0x14 (0x05)
	.word sub_801DE1E+1
	// 0x18 (0x06)
	.word chatbox_openMessageWindow_801DFEA+1
	// 0x1C (0x07)
	.word battle_spawnObjectFromRecord_801E022+1
	// 0x20 (0x08)
	.word battle_redrawCommandMenuWindow_801E1A4+1
	// 0x24 (0x09)
	.word sub_801E138+1
	// 0x28 (0x0A)
	.word event_markStepDoneAndPlayFinishEffects_801E0DC+1
	// 0x2C (0x0B)
	.word sub_801E35A+1
	// 0x30 (0x0C)
	.word sub_801E44C+1
	// 0x34 (0x0D)
	.word sub_801E4B0+1
	// 0x38 (0x0E)
	.word sub_801E5E0+1
	// 0x3C (0x0F)
	.word sub_801E73C+1
	// 0x40 (0x10)
	.word sub_801EB00+1
	// 0x44 (0x11)
	.word sub_801DE64+1
	// 0x48 (0x12)
	.word sub_801EB50+1
	// 0x4C (0x13)
	.word sub_801EBD2+1
	// 0x50 (0x14)
	.word sub_801E3C4+1
	// 0x54 (0x15)
	.word sub_801EC2C+1
	// 0x58 (0x16)
	.word sub_801EC84+1
	// 0x5C (0x17)
	.word sub_801E060+1
off_801DB50:
	.word eStruct2035280
	thumb_func_end dispatch_801DACC

// symdb: One-line wrapper that invokes sub_801BEC2 with argument 1; its game meaning depends entirely on that callee.
// symdb: void sub_801DB54(void); // trampoline: enters with lr only, returns whatever sub_801BEC2 leaves
// symdb: in r0-r2 and flags
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_801DB54.yaml
	thumb_local_start
sub_801DB54:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0
	bl flags_clearBits_20352C4_801BEC2
	pop {pc}
	thumb_func_end sub_801DB54

// symdb: Sets the flag bit 0x1 in eStruct2035280+0x44 (story-battle related flag word)
// symdb: () -> r0 = 1 ; side effects ORs 0x1 into eStruct2035280+0x44 and returns the updated word in r2
// symdb: (via callee)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_setUnkFlagBit0_eStruct2035280_801DB60.yaml
	thumb_local_start
battle_setUnkFlagBit0_eStruct2035280_801DB60:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end battle_setUnkFlagBit0_eStruct2035280_801DB60

// symdb: Tiny thunk that invokes sub_801BEC2 with the constant argument 2; effect depends entirely on what sub_801BEC2 does with its argument.
// symdb: void sub_801DB6C(void) /* trashes r0-r2, lr and the flags; passes r0=2 to sub_801BEC2 */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_801DB6C.yaml
	thumb_local_start
sub_801DB6C:
	push {lr}
	mov r0, #1
	lsl r0, r0, #1
	bl flags_clearBits_20352C4_801BEC2
	pop {pc}
	thumb_func_end sub_801DB6C

// symdb: One-line tail-call wrapper that invokes sub_801BEB8 with the constant argument 2.
// symdb: void sub_801DB78(void) -> returns whatever sub_801BEB8 returns in r0-r2, with N/Z/C as left by
// symdb: sub_801BEB8; callers read r0, r1, r2, NZ, C and lr, and pass no registers in.
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_801DB78.yaml
	thumb_local_start
sub_801DB78:
	push {lr}
	mov r0, #1
	lsl r0, r0, #1
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end sub_801DB78

// symdb: Claims a free slot in dword_20352E0's 6-slot custom-arm table for this battle object's NameID and stores its mirrored arm attachment offset, then links the battle object into it.
// symdb: (r5 = battleObject) -> r0 = 1 ; side effects: writes to the 6-slot table at 0x020352E0 (per-
// symdb: entry 8 bytes: status, x, y, ptr)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_registerCustomArm_801DB84.yaml
	thumb_local_start
battleObject_registerCustomArm_801DB84:
	push {r4,r6,r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl battle_networkInvert
	ldr r4, off_801DC5C // =dword_20352E0 
	mov r3, #6
loc_801DB90:
	ldrb r2, [r4]
	cmp r2, #0
	beq loc_801DB9C
	ldr r1, [r4,#4]
	cmp r1, r5
	beq locret_801DBD2
loc_801DB9C:
	add r4, #8
	sub r3, #1
	bne loc_801DB90
	ldr r4, off_801DC5C // =dword_20352E0 
	mov r3, #6
loc_801DBA6:
	ldrb r2, [r4]
	cmp r2, #0
	beq loc_801DBB6
	add r4, #8
	sub r3, #1
	bne loc_801DBA6
	mov r0, #1
	b locret_801DBD2
loc_801DBB6:
	strb r0, [r4,#3]
	ldrh r0, [r5,#oBattleObject_NameID]
	mov r1, #3
	ldrb r2, [r5,#oBattleObject_Alliance]
	ldrb r3, [r5,#oBattleObject_DirectionFlip]
	bl getBattleArmPositionMaybe_8018810
	neg r1, r1
	sub r1, #8
	strb r0, [r4,#1]
	strb r1, [r4,#2]
	str r5, [r4,#4]
	mov r0, #1
	strb r0, [r4]
locret_801DBD2:
	pop {r4,r6,r7,pc}
	thumb_func_end battleObject_registerCustomArm_801DB84

// symdb: Finds the tracking-table slot (6 slots at 0x20352E0) that holds the given battle object and rewrites its stored x/y arm position, returning 1 if the object is not tracked.
// symdb: int battleRefreshTrackedObjectArmPos_801DBD4(void); // in: r5 = battle object ptr; out: r0 = 0
// symdb: if slot found/updated, 1 if not tracked; C set/V clear, NZ clear on the not-found path
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleRefreshTrackedObjectArmPos_801DBD4.yaml
	thumb_func_start battleRefreshTrackedObjectArmPos_801DBD4
battleRefreshTrackedObjectArmPos_801DBD4:
	push {r4,r6,r7,lr}
	ldr r4, off_801DC5C // =dword_20352E0 
	mov r3, #6
loc_801DBDA:
	ldrb r2, [r4]
	cmp r2, #0
	beq loc_801DBE6
	ldr r0, [r4,#4]
	cmp r0, r5
	beq loc_801DBF0
loc_801DBE6:
	add r4, #8
	sub r3, #1
	bne loc_801DBDA
	mov r0, #1
	b locret_801DC04
loc_801DBF0:
	ldrh r0, [r5,#oBattleObject_NameID]
	mov r1, #3
	ldrb r2, [r5,#oBattleObject_Alliance]
	ldrb r3, [r5,#oBattleObject_DirectionFlip]
	bl getBattleArmPositionMaybe_8018810
	neg r1, r1
	sub r1, #8
	strb r0, [r4,#1]
	strb r1, [r4,#2]
locret_801DC04:
	pop {r4,r6,r7,pc}
	thumb_func_end battleRefreshTrackedObjectArmPos_801DBD4

// symdb: Searches a small 6-entry custom-gauge animation slot table for an entry matching the caller's battle-object pointer (r5) and, if found, stores the requested panel coords and panel-index byte into that slot.
// symdb: (r0 = animId/u8, r1 = panelX | (panelY<<8)) -> r0 = 1 if no match found (slot scan exhausted),
// symdb: else r0 = passed-in animId ; side effects: writes to the matched entry in the dword_20352E0
// symdb: 6-entry slot table at +1 (anim id) and +2 (panelX-1, panelY-1)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_setCustomGaugeBarAnimate_801DC06.yaml
	thumb_local_start
battleObject_setCustomGaugeBarAnimate_801DC06:
	push {r4,r6,r7,lr}
	sub sp, sp, #8
	str r0, [sp]
	str r1, [sp,#4]
	ldr r4, off_801DC5C // =dword_20352E0 
	mov r3, #6
loc_801DC12:
	ldrb r2, [r4]
	cmp r2, #0
	beq loc_801DC1E
	ldr r0, [r4,#4]
	cmp r0, r5
	beq loc_801DC28
loc_801DC1E:
	add r4, #8
	sub r3, #1
	bne loc_801DC12
	mov r0, #1
	b loc_801DC32
loc_801DC28:
	ldr r0, [sp]
	ldr r1, [sp,#4]
	sub r1, #8
	strb r0, [r4,#1]
	strb r1, [r4,#2]
loc_801DC32:
	add sp, sp, #8
	pop {r4,r6,r7,pc}
	thumb_func_end battleObject_setCustomGaugeBarAnimate_801DC06

// symdb: Searches a six-entry slot table for the first occupied entry matching a given value and frees (zeroes) that slot, returning 0 on success or 1 if no match was found.
// symdb: int releaseSlotByValue(u32 value /* r5 */); /* also called with r4, r6, r7, lr preserved; r0 = 0
// symdb: if a slot was cleared, 1 if none matched; c/v set by the last comparison (value match or final
// symdb: loop decrement); r2 = last flag byte read, r3 = slots left unexamined */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/releaseSlotByValue_801DC36.yaml
	thumb_func_start releaseSlotByValue_801DC36
releaseSlotByValue_801DC36:
	push {r4,r6,r7,lr}
	ldr r4, off_801DC5C // =dword_20352E0 
	mov r3, #6
loc_801DC3C:
	ldrb r2, [r4]
	cmp r2, #0
	beq loc_801DC48
	ldr r0, [r4,#4]
	cmp r0, r5
	beq loc_801DC52
loc_801DC48:
	add r4, #8
	sub r3, #1
	bne loc_801DC3C
	mov r0, #1
	b locret_801DC58
loc_801DC52:
	mov r0, #0
	str r0, [r4]
	str r0, [r4,#4]
locret_801DC58:
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_801DC5C:
	.word dword_20352E0
	thumb_func_end releaseSlotByValue_801DC36

	thumb_local_start
sub_801DC60:
	push {lr}
	mov r0, #1
	mov r1, #2
	lsl r0, r1
	bl flags_clearBits_20352C4_801BEC2
	pop {pc}
	thumb_func_end sub_801DC60

// symdb: Sets the bit 0x04 of the flag word at eStruct2035280+0x44 (no inputs, no outputs).
// symdb: () -> (no caller-visible return; flag word at eStruct2035280+0x44 |= 0x04)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_setFlag0x04_eStruct2035280_801DC6E.yaml
	thumb_local_start
battle_setFlag0x04_eStruct2035280_801DC6E:
	push {lr}
	mov r0, #1
	mov r1, #2
	lsl r0, r1
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end battle_setFlag0x04_eStruct2035280_801DC6E

// symdb: Claims a slot in the four-slot battle status list at 0x203EB50 for a battle object, caching its name ID and HP for the status UI.
// symdb: /* r0=param0, r1=param1, r5=battle object -> r0; preserves r4,r6,r7 */ u32 sub_801DC7C(u8
// symdb: param0, u8 param1, struct BattleObject *obj);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801DC7C.yaml
	thumb_func_start sub_801DC7C
sub_801DC7C:
	push {r4,r6,r7,lr}
	ldr r6, off_801DD58 // =byte_203EB50 
	mov r3, #4
loc_801DC82:
	ldrb r2, [r6]
	cmp r2, #0
	beq loc_801DC98
	ldr r2, [r6,#0xc]
	cmp r2, r5
	beq loc_801DC94
	add r6, #0x14
	sub r3, #1
	bne loc_801DC82
loc_801DC94:
	mov r0, #1
	b locret_801DCCA
loc_801DC98:
	ldrh r2, [r5,#oBattleObject_NameID]
	strh r2, [r6,#6]
	mov r3, #3
	cmp r2, #0xeb
	beq loc_801DCAA
	cmp r2, #0x49 
	blt loc_801DCAC
	cmp r2, #0x4e 
	bgt loc_801DCAC
loc_801DCAA:
	mov r3, #0x1b
loc_801DCAC:
	strb r3, [r6]
	strb r0, [r6,#4]
	strb r1, [r6,#5]
	ldrh r2, [r5,#oBattleObject_HP]
	strh r2, [r6,#2]
	ldr r0, dword_801DD5C // =0xb0b0b0b 
	str r0, [r6,#0x10]
	str r5, [r6,#0xc]
	mov r0, #0
	strb r0, [r6,#8]
	strb r0, [r6,#9]
	mov r0, #4
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #0
locret_801DCCA:
	pop {r4,r6,r7,pc}
	thumb_func_end sub_801DC7C

	thumb_func_start sub_801DCCC
sub_801DCCC:
	sub sp, sp, #8
	str r0, [sp]
	str r1, [sp,#4]
	ldr r2, off_801DD58 // =byte_203EB50 
	mov r3, #4
	mov r1, #1
loc_801DCD8:
	ldrb r0, [r2]
	tst r0, r1
	beq loc_801DCF0
	ldr r0, [r2,#0xc]
	cmp r0, r5
	bne loc_801DCF0
	ldr r0, [sp]
	strb r0, [r2,#4]
	ldr r0, [sp,#4]
	strb r0, [r2,#5]
	mov r0, #0
	b loc_801DCF8
loc_801DCF0:
	add r2, #0x14
	sub r3, #1
	bne loc_801DCD8
	mov r0, #1
loc_801DCF8:
	add sp, sp, #8
	mov pc, lr
	thumb_func_end sub_801DCCC

	thumb_local_start
sub_801DCFC:
	sub sp, sp, #8
	str r0, [sp]
	str r1, [sp,#4]
	ldr r2, off_801DD58 // =byte_203EB50 
	mov r3, #4
	mov r1, #1
loc_801DD08:
	ldrb r0, [r2]
	tst r0, r1
	beq loc_801DD28
	ldr r0, [r2,#0xc]
	cmp r0, r5
	bne loc_801DD28
	ldr r0, [sp]
	strb r0, [r2,#4]
	ldr r0, [sp,#4]
	strb r0, [r2,#5]
	ldrb r0, [r2]
	mov r1, #4
	orr r0, r1
	strb r0, [r2]
	mov r0, #0
	b loc_801DD30
loc_801DD28:
	add r2, #0x14
	sub r3, #1
	bne loc_801DD08
	mov r0, #1
loc_801DD30:
	add sp, sp, #8
	mov pc, lr
	thumb_func_end sub_801DCFC

// symdb: Scans a four-slot table (entries at byte_203EB50) for an active record whose id equals r5, clears its flag byte, and returns success.
// symdb: // r5 = id to match (caller-owned) // returns r0: 0 = cleared a matching record; 1 = no match //
// symdb: clobbers r1, r2, r3 and N/Z/C/V u8 search_handleEndById_801DD34(u32 id /* r5 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801DD34.yaml
	thumb_func_start sub_801DD34
sub_801DD34:
	ldr r2, off_801DD58 // =byte_203EB50 
	mov r3, #4
	mov r1, #1
loc_801DD3A:
	ldrb r0, [r2]
	tst r0, r1
	beq loc_801DD4C
	ldr r0, [r2,#0xc]
	cmp r0, r5
	bne loc_801DD4C
	mov r0, #0
	strb r0, [r2]
	b locret_801DD54
loc_801DD4C:
	add r2, #0x14
	sub r3, #1
	bne loc_801DD3A
	mov r0, #1
locret_801DD54:
	mov pc, lr
	.balign 4, 0
off_801DD58:
	.word byte_203EB50
dword_801DD5C:
	.word 0xB0B0B0B
	thumb_func_end sub_801DD34

	thumb_local_start
sub_801DD60:
	push {r4,r5,lr}
	mov r0, #1
	lsl r0, r0, #3
	bl flags_clearBits_20352C4_801BEC2
	mov r0, #0x11
	mov r1, #0x12
	mov r2, #0
	mov r3, #0
	mov r4, #0xc
	mov r5, #2
	bl call_sub_3005EBA
	pop {r4,r5,pc}
	thumb_func_end sub_801DD60

	thumb_local_start
sub_801DD7C:
	push {lr}
	mov r0, #1
	lsl r0, r0, #3
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end sub_801DD7C

	thumb_local_start
sub_801DD88:
	push {lr}
	ldr r0, off_801DDA0 // =off_801DDA4 
	bl QueueGFXTransfersInList // (u32 *dataRefs) -> void
	mov r0, #8
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #8
	bl dispatch_801DA48
	pop {pc}
	.balign 4, 0
off_801DDA0:
	.word off_801DDA4
off_801DDA4:
	.word dword_86BA0A0
	.word 0x600C940
	.word 0x40
	.word dword_86F2E00
	.word 0x3001670
	.word 0x20
	.word byte_86F2D00
	.word 0x6016D00
	.word 0x80
	.word byte_86F2D80
	.word 0x6016D80
	.word 0x80
	.word 0x0
	thumb_func_end sub_801DD88

// symdb: Small wrapper that issues one fixed chatbox/window setup call with hardcoded dimensions (6, 0, 3, 0, 18, 2) and then a follow-up animate/wait call (0x10, 4).
// symdb: void sub_801DDD8(void); // caller's r4/r5 are used as scratch and restored; returns whatever
// symdb: r0-r3 and NZCV the second callee leaves
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_801DDD8.yaml
	thumb_local_start
sub_801DDD8:
	push {r4,r5,lr}
	mov r0, #6
	mov r1, #0
	mov r2, #3
	mov r3, #0
	mov r4, #0x12
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	mov r1, #4
	lsl r0, r1
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end sub_801DDD8

// symdb: Sets up the battle background: queues a small GFX transfer into VRAM, copies background tiles, then enables flag bit 4 on the eStruct2035280 structure.
// symdb: void sub_801DDF6(void)   // inputs:  none (callee-saved registers only)   // outputs: none   //
// symdb: clobbers: nz c v (flags); caller-saved r0,r1,r2,r3 used for args   // preserved: r4, r5
// symdb: (saved/restored around body), r6, r7, r10, lr (preserved through body)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/setupBattleBackground_801DDF6.yaml
	thumb_local_start
setupBattleBackground_801DDF6:
	push {r4,r5,lr}
	ldr r0, off_801DEC4 // =dword_86E1C78 
	ldr r1, off_801DEC8 // =unk_3001A80 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	// j
	mov r0, #6
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_801DEBC // =word_801ED6C 
	mov r4, #0x12
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r0, #1
	mov r1, #4
	lsl r0, r1
	bl flagSetBits_eStruct2035280_801BEB8
	pop {r4,r5,pc}
	thumb_func_end setupBattleBackground_801DDF6

	thumb_local_start
sub_801DE1E:
	push {r4,r5,lr}
	mov r0, #6
	mov r1, #0
	mov r2, #3
	mov r3, #0
	mov r4, #0x12
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	mov r1, #5
	lsl r0, r1
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end sub_801DE1E

	thumb_local_start
sub_801DE3C:
	push {r4,r5,lr}
	ldr r0, off_801DEC4 // =dword_86E1C78 
	ldr r1, off_801DEC8 // =unk_3001A80 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	// j
	mov r0, #6
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_801DEBC // =word_801ED6C 
	mov r4, #0x12
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r0, #1
	mov r1, #5
	lsl r0, r1
	bl flagSetBits_eStruct2035280_801BEB8
	pop {r4,r5,pc}
	thumb_func_end sub_801DE3C

	thumb_local_start
sub_801DE64:
	push {r4,r5,lr}
	mov r0, #6
	mov r1, #0
	mov r2, #3
	mov r3, #0
	mov r4, #0x12
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	mov r1, #0x11
	lsl r0, r1
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end sub_801DE64

	thumb_local_start
sub_801DE82:
	push {r4,r5,lr}
	ldrb r0, [r5,#0x18]
	cmp r0, #0
	bne loc_801DE8C
	sub r0, #2
loc_801DE8C:
	mov r2, #0x20 
	sub r0, #1
	mul r0, r2
	ldr r1, off_801DECC // =byte_86E1CD8 
	add r0, r0, r1
	ldr r1, off_801DEC8 // =unk_3001A80 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	// j
	mov r0, #6
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_801DEC0 // =word_801EDB4 
	mov r4, #0x12
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r0, #1
	mov r1, #0x11
	lsl r0, r1
	bl flagSetBits_eStruct2035280_801BEB8
	pop {r4,r5,pc}
	.balign 4, 0
off_801DEBC:
	.word word_801ED6C
off_801DEC0:
	.word word_801EDB4
off_801DEC4:
	.word dword_86E1C78
off_801DEC8:
	.word unk_3001A80
off_801DECC:
	.word byte_86E1CD8
	thumb_func_end sub_801DE82

// symdb: Resets the custom gauge state, reloads its tile graphics from ROM into VRAM, and starts the custom gauge's init/dispatch routine.
// symdb: void custGauge_Init(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/custGauge_Init_801DED0.yaml
	thumb_func_start custGauge_Init_801DED0
custGauge_Init_801DED0:
	push {lr}
	bl ClearCustGauge
	ldr r0, off_801DF6C // =dword_86E489C 
	ldr r1, dword_801DF70 // =0x600c440 
	ldr r2, off_801DF74 // =0x380 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #0x10
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #0x10
	bl dispatch_801DA48
	pop {pc}
	thumb_func_end custGauge_Init_801DED0

	thumb_func_start sub_801DEEE
sub_801DEEE:
	push {lr}
	bl ClearCustGauge
	ldr r0, off_801DF6C // =dword_86E489C 
	ldr r1, dword_801DF70 // =0x600c440 
	ldr r2, off_801DF74 // =0x380 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #0x20 
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #0x20 
	bl dispatch_801DA48
	pop {pc}
	thumb_func_end sub_801DEEE

	thumb_func_start sub_801DF0C
sub_801DF0C:
	push {lr}
	bl ClearCustGauge
	// dataList
	ldr r0, off_801DF5C // =off_801DF60 
	bl QueueGFXTransfersInList // (u32 *dataRefs) -> void
	mov r0, #1
	lsl r0, r0, #0x11
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0x11
	bl dispatch_801DA48
	ldr r1, off_801E0D8 // =eStruct2035280
	mov r0, #0
	strb r0, [r1,#0x18] // (byte_2035298 - 0x2035280)
	strb r0, [r1,#0x19] // (byte_2035299 - 0x2035280)
	pop {pc}
	thumb_func_end sub_801DF0C

	thumb_local_start
sub_801DF32:
	push {lr}
	bl ClearCustGauge
	// dataList
	ldr r0, off_801DF5C // =off_801DF60 
	bl QueueGFXTransfersInList // (u32 *dataRefs) -> void
	ldr r0, off_801DF80 // =dword_86E1C78 
	ldr r1, off_801DF84 // =byte_3001B00 
	ldr r2, dword_801DF88 // =0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #1
	lsl r0, r0, #0x11
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0x11
	bl dispatch_801DA48
	pop {pc}
	.balign 4, 0
off_801DF5C:
	.word off_801DF60
off_801DF60:
	.word dword_86E4C1C
	.word 0x600C7C0
	.word 0x180
off_801DF6C:
	.word dword_86E489C
dword_801DF70:
	.word 0x600C440
off_801DF74:
	.word 0x380
	.word 0x0
	.word 0x1500
off_801DF80:
	.word dword_86E1C78
off_801DF84:
	.word byte_3001B00
dword_801DF88:
	.word 0x20
	thumb_func_end sub_801DF32

// symdb: Stores the looked-up enemy-virus count (0x10/0x20/0x40) into eStruct2035280.NaviStatusGfxIdx (offset 0x22).
// symdb: (r0 = u16 enemyVirusCount) -> void ; side effect: writes r0 as a u16 to eStruct2035280+0x22
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_setEnemyCountFromNaviStats_801DF8C.yaml
	thumb_func_start battle_setEnemyCountFromNaviStats_801DF8C
battle_setEnemyCountFromNaviStats_801DF8C:
	ldr r1, off_801E0D8 // =eStruct2035280
	strh r0, [r1,#0x22] // (word_20352A2 - 0x2035280)
	mov pc, lr
	thumb_func_end battle_setEnemyCountFromNaviStats_801DF8C

// symdb: Resets the in-battle custom gauge, zeroing its progress counter and clearing its gauge-related flag bits.
// symdb: void ClearCustGauge(in u32 r10 /* unused by body, passed through context */, out u32 r1, out u32
// symdb: r2 /* results from battle_clearFlags */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ClearCustGauge.yaml
	thumb_func_start ClearCustGauge
ClearCustGauge:
	push {lr}
	ldr r1, off_801E0D8 // =eStruct2035280
	mov r0, #0
	strh r0, [r1,#0x20] // (word_20352A0 - 0x2035280)
	mov r0, #0x12
	bl battle_clearFlags
	pop {pc}
	thumb_func_end ClearCustGauge

	thumb_func_start SetCustGauge
SetCustGauge:
	push {r1,lr}
	ldr r1, dword_801DFB4 // =0x4000 
	cmp r0, r1
	ble loc_801DFAC
	mov r0, r1
loc_801DFAC:
	ldr r1, off_801E0D8 // =eStruct2035280
	strh r0, [r1,#0x20] // (word_20352A0 - 0x2035280)
	pop {r1,pc}
	.balign 4, 0
dword_801DFB4:
	.word 0x4000
	thumb_func_end SetCustGauge

	thumb_func_start sub_801DFB8
sub_801DFB8:
	push {lr}
	ldr r2, off_801E0D8 // =eStruct2035280
	ldrh r1, [r2,#0x20] // (word_20352A0 - 0x2035280)
	add r0, r0, r1
	ldr r1, dword_801DFCC // =0x4000 
	cmp r0, r1
	ble loc_801DFC8
	mov r0, r1
loc_801DFC8:
	strh r0, [r2,#0x20] // (word_20352A0 - 0x2035280)
	pop {pc}
	.balign 4, 0
dword_801DFCC:
	.word 0x4000
	thumb_func_end sub_801DFB8

	thumb_local_start
sub_801DFD0:
	push {lr}
	ldr r2, off_801E0D8 // =eStruct2035280
	ldrh r1, [r2,#0x20] // (word_20352A0 - 0x2035280)
	sub r1, r1, r0
	bge loc_801DFDC
	mov r1, #0
loc_801DFDC:
	strh r1, [r2,#0x20] // (word_20352A0 - 0x2035280)
	pop {pc}
	.word 0x4000
	thumb_func_end sub_801DFD0

// symdb: Returns the cumulative damage-taken counter (TotalDamageTaken) for the actor's AIData.
// symdb: () -> r0 = u16 TotalDamageTaken for the currently-bound AIData record
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getTotalDamageTakenForActor_801DFE4.yaml
	thumb_func_start battle_getTotalDamageTakenForActor_801DFE4
battle_getTotalDamageTakenForActor_801DFE4:
	ldr r0, off_801E0D8 // =eStruct2035280
	ldrh r0, [r0,#0x20] // (word_20352A0 - 0x2035280)
	mov pc, lr
	thumb_func_end battle_getTotalDamageTakenForActor_801DFE4

// symdb: Lays out a standard dialogue message window (18x3 cells at the screen origin, box style 0x11 on layer 2) and activates it with mode 0x40.
// symdb: void sub_801DFEA(void); // returns r0 = 0x40, r1/r2 as left by sub_801BEC2, r3 = 0, flags from
// symdb: the lsl (N=0,Z=0,C=0); r4-r7 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chatbox_openMessageWindow_801DFEA.yaml
	thumb_local_start
chatbox_openMessageWindow_801DFEA:
	push {r4,r5,lr}
	mov r0, #0
	mov r1, #0x12
	mov r2, #3
	mov r3, #0
	mov r4, #0x11
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	lsl r0, r0, #6
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end chatbox_openMessageWindow_801DFEA

// symdb: Sets bit 0x40 in the eStruct2035280 flags word (offset 0x44) to mark some battle state flag.
// symdb: (none) -> r0 = 0x40 ; side effect: ORs 0x40 into eStruct2035280+0x44 via
// symdb: flagSetBits_eStruct2035280_801BEB8
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_setUnkFlags44_0x40_801E006.yaml
	thumb_local_start
battle_setUnkFlags44_0x40_801E006:
	push {lr}
	mov r0, #1
	lsl r0, r0, #6
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end battle_setUnkFlags44_0x40_801E006

	thumb_local_start
sub_801E012:
	push {r4,r6,r7,lr}
	mov r0, #0x40 
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #0x40 
	bl dispatch_801DA48
	pop {r4,r6,r7,pc}
	thumb_func_end sub_801E012

// symdb: Spawns a battle object from a small record (two ID bytes at r5+1/r5+2) with fixed placement/parameter values, then calls sub_801BEC2 with 0x80.
// symdb: void battle_spawnObjectFromRecord(SpawnRecord* record /* r5 */) // reads record[1], record[2];
// symdb: outputs whatever call_sub_3005EBA/sub_801BEC2 leave in r0-r3, N=Z=V per sub_801BEC2, C=0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_spawnObjectFromRecord_801E022.yaml
	thumb_local_start
battle_spawnObjectFromRecord_801E022:
	push {r4,r5,lr}
	ldrb r0, [r5,#1]
	ldrb r1, [r5,#2]
	mov r2, #3
	mov r3, #0
	mov r4, #6
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	lsl r0, r0, #7
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end battle_spawnObjectFromRecord_801E022

// symdb: Writes a fixed 6x2-tile patch of tile IDs into background tile block 3 at coordinates stored in eStruct2035280, then flags the background update.
// symdb: void sub_801E03E(void); // no meaningful register inputs; r4/r5 preserved, clobbers r0-r3, sets
// symdb: NZCV (Z clear, N set, C clear from the 1<<7 shift)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/background_applyFixedTilePatch_801E03E.yaml
	thumb_local_start
background_applyFixedTilePatch_801E03E:
	push {r4,r5,lr}
	ldr r3, off_801E0D8 // =eStruct2035280
	// j
	ldrb r0, [r3,#0x1] // (byte_2035281 - 0x2035280)
	// i
	ldrb r1, [r3,#0x2] // (byte_2035282 - 0x2035280)
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_801E05C // =byte_801EDFC
	mov r4, #6
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r0, #1
	lsl r0, r0, #7
	bl flagSetBits_eStruct2035280_801BEB8
	pop {r4,r5,pc}
	.balign 4, 0
off_801E05C:
	.word byte_801EDFC
	thumb_func_end background_applyFixedTilePatch_801E03E

	thumb_local_start
sub_801E060:
	push {r4,r5,lr}
	mov r0, #0x18
	mov r1, #0
	mov r2, #3
	mov r3, #0
	mov r4, #6
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	lsl r0, r0, #0x17
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end sub_801E060

	thumb_local_start
sub_801E07C:
	push {r4,r5,lr}
	ldr r3, off_801E0D8 // =eStruct2035280
	// j
	mov r0, #0x18
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_801E09C // =byte_801EDFC
	mov r4, #6
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r0, #1
	lsl r0, r0, #0x17
	bl flagSetBits_eStruct2035280_801BEB8
	pop {r4,r5,pc}
	.balign 4, 0
off_801E09C:
	.word byte_801EDFC
	thumb_func_end sub_801E07C

// symdb: Posts a battle subsystem event to eStruct2035280 by copying a halfword from +0x24 of a pointer at +0x48 into the struct's own +0x24, storing r0/r1 into byte fields, ORing bit 0x80 into the request dword, then dispatching with mask 0x80.
// symdb: (r0 = param0 -> byte_2035281, r1 = param1 -> byte_2035282, r10 = toolkit) -> void ; side
// symdb: effects: writes Struct2035280+0x24/0x1/0x2, ORs 0x80 into Struct2035280+0x40, then calls
// symdb: dispatch_801DA48(r0=0x80)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_eStruct2035280_postEvent_801E0A0.yaml
	thumb_func_start battle_eStruct2035280_postEvent_801E0A0
battle_eStruct2035280_postEvent_801E0A0:
	push {lr}
	ldr r3, off_801E0D8 // =eStruct2035280
	ldr r2, [r3,#0x48] // (dword_20352C8 - 0x2035280)
	ldrh r2, [r2,#0x24]
	strh r2, [r3,#0x24] // (word_20352A4 - 0x2035280)
	strb r0, [r3,#0x1] // (byte_2035281 - 0x2035280)
	strb r1, [r3,#0x2] // (byte_2035282 - 0x2035280)
	mov r0, #0x80
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #0x80
	bl dispatch_801DA48
	pop {pc}
	thumb_func_end battle_eStruct2035280_postEvent_801E0A0

	thumb_local_start
sub_801E0BC:
	push {lr}
	ldr r1, off_801E0D8 // =eStruct2035280
	ldr r0, [r1,#0x48] // (dword_20352C8 - 0x2035280)
	ldrh r0, [r0,#0x24]
	strh r0, [r1,#0x24] // (word_20352A4 - 0x2035280)
	pop {pc}
	thumb_func_end sub_801E0BC

// symdb: Trivial setter that writes a halfword value into field 0x26 of the struct at 0x2035280.
// symdb: void setStruct2035280Field26(u16 value /* r0 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/setStruct2035280Field26_801E0C8.yaml
	thumb_func_start setStruct2035280Field26_801E0C8
setStruct2035280Field26_801E0C8:
	push {r5,lr}
	ldr r5, off_801E0D8 // =eStruct2035280
	strh r0, [r5,#0x26] // (word_20352A6 - 0x2035280)
	pop {r5,pc}
	thumb_func_end setStruct2035280Field26_801E0C8

	thumb_func_start sub_801E0D0
sub_801E0D0:
	push {lr}
	ldr r3, off_801E0D8 // =eStruct2035280
	strb r0, [r3,#0x1c] // (byte_203529C - 0x2035280)
	pop {pc}
off_801E0D8:
	.word eStruct2035280
	thumb_func_end sub_801E0D0

// symdb: Marks two state bytes of an event/quest struct as done (0xFF), plays effects 6 and 0x1A, and clears event flag bit 0x400 at 0x20352C4.
// symdb: void sub_801E0DC(u8* r5 /* struct pointer, at least 11 bytes */); clobbers r0-r3 and the scratch
// symdb: copy of r4/r5; preserves the caller's r4, r5; returns with NZ set from 0x400 and C=0 (see
// symdb: quirks)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/event_markStepDoneAndPlayFinishEffects_801E0DC.yaml
	thumb_local_start
event_markStepDoneAndPlayFinishEffects_801E0DC:
	push {r4,r5,lr}
	mov r0, #0xff
	strb r0, [r5,#8]
	strb r0, [r5,#0xa]
	mov r0, #6
	mov r1, #2
	mov r2, #3
	mov r3, #0
	mov r4, #4
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #0x1a
	mov r1, #2
	mov r2, #3
	mov r3, #0
	mov r4, #4
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	lsl r0, r0, #0xa
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end event_markStepDoneAndPlayFinishEffects_801E0DC

// symdb: Queues the battle mode's graphics tiles for DMA unless the battle mode is 6, then sets flag 0x400 in the eStruct at 0x2035280 to signal the GFX was prepared.
// symdb: void sub_801E10E(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_loadModeGfx_801E10E.yaml
	thumb_local_start
battle_loadModeGfx_801E10E:
	push {lr}
	bl GetBattleMode
	cmp r0, #6
	beq loc_801E122
	ldr r0, off_801E12C // =dword_86E1C78 
	ldr r1, off_801E130 // =unk_3001A80 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_801E122:
	mov r0, #1
	lsl r0, r0, #0xa
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	.balign 4, 0
off_801E12C:
	.word dword_86E1C78
off_801E130:
	.word unk_3001A80
	.word dword_86E1C78
	thumb_func_end battle_loadModeGfx_801E10E

	thumb_local_start
sub_801E138:
	push {lr}
	mov r0, #1
	lsl r0, r0, #9
	bl flags_clearBits_20352C4_801BEC2
	pop {pc}
	thumb_func_end sub_801E138

	thumb_local_start
sub_801E144:
	push {lr}
	mov r0, #1
	lsl r0, r0, #9
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	.word dword_86E1C78
	.word unk_3001A80
	.word dword_86E1C78
	thumb_func_end sub_801E144

// symdb: Plays the "Beast Out" transformation transition: clears/loads beast-out graphics, fires dispatch effects, and plays the SE 0x9f jingle.
// symdb: (r10 = toolkit) -> side effects only; side effects: clears bit 0x10000 of dword_20352C0,
// symdb: dispatches flags 0x10000 and 0x200, queues a 3-entry GFX transfer list, plays sound 0x9f
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_playBeastOutSequence_801E15C.yaml
	thumb_func_start battle_playBeastOutSequence_801E15C
battle_playBeastOutSequence_801E15C:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0x10
	bl flags_clearBits_eStruct2035280_801BED6
	mov r0, #1
	lsl r0, r0, #0x10
	bl dispatch_801DACC // (a0: flags32) -> ()
	// dataList
	ldr r0, off_801E184 // =off_801E188 
	bl QueueGFXTransfersInList // (u32 *dataRefs) -> void
	mov r0, #1
	lsl r0, r0, #9
	bl dispatch_801DA48
	mov r0, #0x9f
	bl PlaySoundEffect
	pop {pc}
	.balign 4, 0
off_801E184:
	.word off_801E188
off_801E188:
	.word dword_86E611C
	.word 0x6016E00
	.word 0x140
	.word byte_86F2900
	.word 0x30016B0
	.word 0x20
	.word 0x0
	thumb_func_end battle_playBeastOutSequence_801E15C

// symdb: Redraws the battle command-menu window frame (narrowed while the custom screen is open), clears battle flag 0x100, and advances the menu state if the battle is still running with the custom screen closed.
// symdb: void sub_801E1A4(BattleWork* work /* r5 */); preserves r4-r6; returns callee-side r0-r3 and
// symdb: flags (cmp results, or dispatch_801DA48's flags on the dispatch path)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_redrawCommandMenuWindow_801E1A4.yaml
	thumb_local_start
battle_redrawCommandMenuWindow_801E1A4:
	push {r4-r6,lr}
	mov r6, #6
	ldrb r0, [r5,#0xc]
	cmp r0, #2
	beq loc_801E1B0
	mov r6, #0
loc_801E1B0:
	mov r0, #7
	lsr r1, r6, #1
	add r0, r0, r1
	mov r1, #2
	mov r2, #3
	mov r3, #0
	mov r4, #0x11
	sub r4, r4, r6
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	lsl r0, r0, #8
	bl flags_clearBits_20352C4_801BEC2
	bl battle_isBattleOver
	cmp r0, #1
	beq locret_801E1E2
	cmp r6, #0
	bne locret_801E1E2
	mov r0, #1
	lsl r0, r0, #0xa
	bl dispatch_801DA48
locret_801E1E2:
	pop {r4-r6,pc}
	thumb_func_end battle_redrawCommandMenuWindow_801E1A4

// symdb: Redraw the 2-row background strip of a window/dialog object, picking between a narrow and full-width tile layout, and mark the background dirty.
// symdb: void drawWindowBackdrop_801E1E4(void); // r5 in = window object; r4-r12 and lr are preserved;
// symdb: r0-r3 and lr return with the last callee's leftovers; NZCV clobbered.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801E1E4.yaml
	thumb_local_start
sub_801E1E4:
	push {r4-r6,lr}
	mov r6, #9
	ldrb r0, [r5,#0xc]
	cmp r0, #2
	beq loc_801E1F8
	mov r6, #0
	mov r0, #1
	lsl r0, r0, #0xa
	bl dispatch_801DACC // (a0: flags32) -> ()
loc_801E1F8:
	mov r0, #7
	lsr r1, r6, #1
	// j
	add r0, r0, r1
	// i
	mov r1, #2
	// tileBlock32x32
	mov r2, #3
	ldr r3, off_801E220 // =word_801EE14 
	cmp r6, #9
	bne loc_801E20A
	// tileIds
	ldr r3, off_801E224 // =word_801EE58 
loc_801E20A:
	mov r4, #0x11
	sub r4, r4, r6
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r0, #1
	lsl r0, r0, #8
	bl flagSetBits_eStruct2035280_801BEB8
	pop {r4-r6,pc}
	.balign 4, 0
off_801E220:
	.word word_801EE14
off_801E224:
	.word word_801EE58
	thumb_func_end sub_801E1E4

// symdb: Draws a scripted message/text window onto the eStruct2035280 VRAM target for a given display mode, falling back to a default mode when the caller passes 2.
// symdb: u8 mode /* r0, rewritten to 0x13 when == 2 */; r4..r7 preserved; flags clobbered (nz/c/v).
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eStruct2035280_DrawMessageMode_801E228.yaml
	thumb_func_start eStruct2035280_DrawMessageMode_801E228
eStruct2035280_DrawMessageMode_801E228:
	push {r4-r7,lr}
	cmp r0, #2
	bne loc_801E230
	mov r0, #0x13
loc_801E230:
	mov r7, r0
	ldr r6, off_801E4AC // =eStruct2035280
	ldr r1, [r6,#0x40] // (dword_20352C0 - 0x2035280)
	mov r0, #1
	lsl r0, r0, #8
	tst r1, r0
	beq loc_801E242
	bl dispatch_801DACC // (a0: flags32) -> ()
loc_801E242:
	mov r0, #0x3c 
	strb r0, [r6,#0xb] // (byte_203528B - 0x2035280)
	mov r0, #0
	strb r0, [r6,#0xc] // (byte_203528C - 0x2035280)
	ldr r0, off_801E438 // =TextScript86F0374 
	mov r1, r7
	ldr r2, off_801E43C // =byte_203C4E0 
	ldr r3, dword_801E440 // =0x6009560 
	mov r4, #0x11
	mov r5, #1
	ldr r6, off_801E444 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	mov r0, #1
	lsl r0, r0, #8
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #8
	bl dispatch_801DA48
	pop {r4-r7,pc}
	thumb_func_end eStruct2035280_DrawMessageMode_801E228

// symdb: Window panel update: dispatches any pending open request, refreshes timer/visible state, and renders script text into the window's VRAM tiles.
// symdb: void sub_801E270(u32 r10, u32 lr); // returns: r0 = final dispatch_801DA48 result,
// symdb: r2/r5/r7/r8/r9/r10/r11/r12 also clobbered // clobbers: nz,c,v, r1, r3, lr; preserves: r4, r5,
// symdb: r6, r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801E270.yaml
	thumb_local_start
sub_801E270:
	push {r4-r7,lr}
	ldr r6, off_801E4AC // =eStruct2035280
	ldr r0, [r6,#0x40] // (dword_20352C0 - 0x2035280)
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801E28C
	ldrb r0, [r6,#0xc] // (byte_203528C - 0x2035280)
	cmp r0, #0
	beq locret_801E2B8
	mov r0, #1
	lsl r0, r0, #8
	bl dispatch_801DACC // (a0: flags32) -> ()
loc_801E28C:
	mov r0, #0x3c 
	strb r0, [r6,#0xb] // (byte_203528B - 0x2035280)
	mov r0, #1
	strb r0, [r6,#0xc] // (byte_203528C - 0x2035280)
	ldr r0, off_801E438 // =TextScript86F0374 
	mov r1, #0xe
	ldr r2, off_801E43C // =byte_203C4E0 
	ldr r3, dword_801E440 // =0x6009560 
	mov r4, #0x11
	mov r5, #1
	ldr r6, off_801E444 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	mov r0, #1
	lsl r0, r0, #8
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #8
	bl dispatch_801DA48
locret_801E2B8:
	pop {r4-r7,pc}
	thumb_func_end sub_801E270

	thumb_func_start sub_801E2BA
sub_801E2BA:
	push {r4-r7,lr}
	push {r0}
	ldr r6, off_801E4AC // =eStruct2035280
	ldr r0, [r6,#0x40] // (dword_20352C0 - 0x2035280)
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801E2D8
	ldrb r0, [r6,#0xc] // (byte_203528C - 0x2035280)
	cmp r0, #0
	beq loc_801E312
	mov r0, #1
	lsl r0, r0, #8
	bl dispatch_801DACC // (a0: flags32) -> ()
loc_801E2D8:
	mov r0, #0x3c 
	strb r0, [r6,#0xb] // (byte_203528B - 0x2035280)
	mov r0, #2
	strb r0, [r6,#0xc] // (byte_203528C - 0x2035280)
	mov r1, r10
	ldr r1, [r1,#oToolkit_Unk200a220_Ptr]
	ldr r0, [sp]
	str r0, [r1,#8]
	mov r1, #0xf
	cmp r0, #0
	bne loc_801E2F0
	mov r1, #0x10
loc_801E2F0:
	ldr r0, off_801E438 // =TextScript86F0374 
	ldr r2, off_801E43C // =byte_203C4E0 
	ldr r3, dword_801E440 // =0x6009560 
	mov r4, #0xa
	mov r5, #1
	ldr r6, off_801E444 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	mov r0, #1
	lsl r0, r0, #8
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #8
	bl dispatch_801DA48
loc_801E312:
	pop {r0}
	pop {r4-r7,pc}
	push {r4-r7,lr}
	ldr r6, off_801E4AC // =eStruct2035280
	ldr r0, [r6,#0x40] // (dword_20352C0 - 0x2035280)
	mov r1, #1
	lsl r1, r1, #8
	tst r0, r1
	beq loc_801E32C
	mov r0, #1
	lsl r0, r0, #8
	bl dispatch_801DACC // (a0: flags32) -> ()
loc_801E32C:
	mov r0, #0x3c 
	strb r0, [r6,#0xb] // (byte_203528B - 0x2035280)
	mov r0, #3
	strb r0, [r6,#0xc] // (byte_203528C - 0x2035280)
	ldr r0, off_801E438 // =TextScript86F0374 
	mov r1, #0x11
	ldr r2, off_801E43C // =byte_203C4E0 
	ldr r3, dword_801E440 // =0x6009560 
	mov r4, #0x11
	mov r5, #1
	ldr r6, off_801E444 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	mov r0, #1
	lsl r0, r0, #8
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #8
	bl dispatch_801DA48
	pop {r4-r7,pc}
	thumb_func_end sub_801E2BA

	thumb_local_start
sub_801E35A:
	push {r4,r5,lr}
	mov r0, #0xb
	mov r1, #0
	mov r2, #3
	mov r3, #0
	mov r4, #8
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	lsl r0, r0, #0xb
	bl flags_clearBits_eStruct2035280_801BED6
	pop {r4,r5,pc}
	thumb_func_end sub_801E35A

	thumb_local_start
sub_801E376:
	push {r4,r5,lr}
	// j
	mov r0, #0xb
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_801E394 // =byte_801EE78
	mov r4, #8
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r0, #1
	lsl r0, r0, #0xb
	bl flagSetBits_eStruct2035280_801BEB8
	pop {r4,r5,pc}
	.balign 4, 0
off_801E394:
	.word byte_801EE78
	thumb_func_end sub_801E376

	thumb_func_start sub_801E398
sub_801E398:
	push {r4-r7,lr}
	mov r7, r0
	ldr r0, off_801E438 // =TextScript86F0374 
	mov r1, r7
	add r1, #3
	ldr r2, off_801E43C // =byte_203C4E0 
	ldr r3, dword_801E440 // =0x6009560 
	mov r4, #8
	mov r5, #1
	ldr r6, off_801E444 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	mov r0, #1
	lsl r0, r0, #0xb
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0xb
	bl dispatch_801DA48
	pop {r4-r7,pc}
	thumb_func_end sub_801E398

	thumb_local_start
sub_801E3C4:
	push {r4,r5,lr}
	mov r0, #0xb
	mov r1, #0x10
	mov r2, #3
	mov r3, #0
	mov r4, #8
	mov r5, #2
	bl call_sub_3005EBA
	ldr r0, dword_801E3E0 // =0x100000 
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	.balign 4, 0
dword_801E3E0:
	.word 0x100000
	thumb_func_end sub_801E3C4

	thumb_local_start
sub_801E3E4:
	push {r4,r5,lr}
	// j
	mov r0, #0xb
	// i
	mov r1, #0x10
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_801E404 // =byte_801EF10
	mov r4, #8
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	ldr r0, dword_801E400 // =0x100000 
	bl flagSetBits_eStruct2035280_801BEB8
	pop {r4,r5,pc}
	.balign 4, 0
dword_801E400:
	.word 0x100000
off_801E404:
	.word byte_801EF10
	thumb_func_end sub_801E3E4

	thumb_func_start sub_801E408
sub_801E408:
	push {r4-r7,lr}
	ldr r1, off_801E4AC // =eStruct2035280
	mov r0, #0x32 
	strh r0, [r1,#0x32] // (word_20352B2 - 0x2035280)
	ldr r0, off_801E438 // =TextScript86F0374 
	mov r1, #0x12
	ldr r2, off_801E43C // =byte_203C4E0 
	ldr r3, dword_801E448 // =0x60098e0 
	mov r4, #0xa
	mov r5, #1
	ldr r6, off_801E444 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	mov r0, #1
	lsl r0, r0, #0x14
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0x14
	bl dispatch_801DA48
	pop {r4-r7,pc}
	.balign 4, 0
off_801E438:
	.word TextScript86F0374
off_801E43C:
	.word byte_203C4E0
dword_801E440:
	.word 0x6009560
off_801E444:
	.word dword_86B7AE0
dword_801E448:
	.word 0x60098E0
	thumb_func_end sub_801E408

	thumb_local_start
sub_801E44C:
	push {r4,r5,lr}
	mov r0, #0x13
	mov r1, #4
	mov r2, #3
	mov r3, #0
	mov r4, #0xb
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	lsl r0, r0, #0xc
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end sub_801E44C

	thumb_local_start
sub_801E468:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0xc
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end sub_801E468

	thumb_func_start sub_801E474
sub_801E474:
	push {lr}
	ldr r1, off_801E4AC // =eStruct2035280
	strb r0, [r1,#0xb] // (byte_203528B - 0x2035280)
	ldr r1, off_801E49C // =off_801E4A0 
	lsl r0, r0, #2
	// dataList
	ldr r0, [r1,r0]
	bl QueueGFXTransfersInList // (u32 *dataRefs) -> void
	ldr r1, off_801E4AC // =byte_2035280 
	mov r0, #0x3f 
	strb r0, [r1]
	mov r0, #1
	lsl r0, r0, #0xc
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0xc
	bl dispatch_801DA48
	pop {pc}
	.balign 4, 0
off_801E49C:
	.word off_801E4A0
off_801E4A0:
	.word off_801EF30
	.word off_801EF4C
	.word off_801EF68
off_801E4AC:
	.word eStruct2035280
	thumb_func_end sub_801E474

// symdb: Walks the custom-chip slot table on a struct and dispatches each filled slot to the IWRAM chip handler twice (modes 0 and 3), then clears the "0x2000" bit of the global state flag word.
// symdb: void sub_801E4B0(void);  /* in: r5 = owner struct, r10 and lr pass through; clobbers r0-r3,
// symdb: r4-r7, NZCV */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_801E4B0.yaml
	thumb_local_start
sub_801E4B0:
	push {r4-r6,lr}
	mov r1, #0
	mov r6, r5
	add r6, #0x28 
loc_801E4B8:
	ldrh r2, [r6]
	cmp r2, #0xff
	beq loc_801E4EA
	cmp r2, #9
	blt loc_801E4C4
	mov r2, #8
loc_801E4C4:
	mov r0, #0x1d
	sub r0, r0, r2
	add r4, r2, #1
	mov r5, #2
	mov r2, #0
	mov r3, #0
	push {r1}
	push {r0,r1,r3-r5}
	bl call_sub_3005EBA
	pop {r0,r1,r3-r5}
	mov r2, #3
	bl call_sub_3005EBA
	pop {r1}
	add r1, #2
	add r6, #2
	cmp r1, #8
	bne loc_801E4B8
loc_801E4EA:
	mov r0, #1
	lsl r0, r0, #0xd
	bl flags_clearBits_20352C4_801BEC2
	pop {r4-r6,pc}
	thumb_func_end sub_801E4B0

	thumb_local_start
sub_801E4F4:
	push {r4-r7,lr}
	sub sp, sp, #0x28
	mov r7, #0x28 
	add r7, r7, r5
	mov r4, #0
loc_801E4FE:
	ldrh r6, [r7]
	cmp r6, #0xff
	beq loc_801E568
	cmp r6, #0
	beq loc_801E560
	cmp r6, #9
	blt loc_801E51C
	mov r6, #9
	mov r3, sp
	add r2, r3, r6
	add r2, r2, r6
	ldr r0, word_801E5D8 // =0xd1d6
	add r0, #2
	add r1, r0, #1
	b loc_801E536
loc_801E51C:
	mov r3, sp
	add r2, r3, r6
	add r2, r2, r6
	add r2, #2
	// r2 = sp + r6*2 + 2
	ldr r0, word_801E5D8 // =0xd1d6
	strh r0, [r3]
	add r0, #1
	strh r0, [r2]
	add r3, #2
	add r2, #2
	add r0, #1
	add r1, r0, #1
	beq loc_801E542
loc_801E536:
	strh r0, [r3]
	strh r1, [r2]
	add r2, #2
	add r3, #2
	sub r6, #1
	bne loc_801E536
loc_801E542:
	// i
	mov r1, r4
	// tileBlock32x32
	mov r2, #3
	// tileIds
	mov r3, sp
	push {r4}
	mov r0, #0x1d
	ldrb r4, [r7]
	cmp r4, #9
	blt loc_801E554
	mov r4, #8
loc_801E554:
	// j
	sub r0, r0, r4
	add r4, #1
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4}
loc_801E560:
	add r7, #2
	add r4, #2
	cmp r4, #8
	blt loc_801E4FE
loc_801E568:
	mov r0, #1
	lsl r0, r0, #0xd
	bl flagSetBits_eStruct2035280_801BEB8
	add sp, sp, #0x28
	pop {r4-r7,pc}
	thumb_func_end sub_801E4F4

// This renders virus name texts in battle
// Disabling it would just cause the rendered names to disappear.
// symdb: Loads the enemy viruses' name IDs for up to four slots, renders each name into its own text/gfx tile slice, and queues the tile buffer for VRAM upload.
// symdb: void RetrieveAndRenderEnemyVirusNamesInBattle_801E574(void);  // no game-side args/return; uses
// symdb: r10/lr from caller, leaves r2/r3/r4/r5/r6/r8/r9/r10/r11/r12 as clobbered outputs
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/RetrieveAndRenderEnemyVirusNamesInBattle_801E574.yaml
	thumb_func_start RetrieveAndRenderEnemyVirusNamesInBattle_801E574
RetrieveAndRenderEnemyVirusNamesInBattle_801E574: // () -> ()
	push {r4,r5,r7,lr}

	mov r1, #0xff
	ldr r0, off_801E77C // =eStruct2035280
	add r0, #oStruct2035280_VirusNameIdxU16Arr
	strh r1, [r0, #0x00]
	strh r1, [r0, #0x02]
	strh r1, [r0, #0x04]
	strh r1, [r0, #0x06]

	mov r4, r0

	bl LoadVirusNameIDsForUpToFourSlots_800A998 // (name_id_arr: *mut [u16; 4]) -> u8

	push {r0}
	pop {r0}

	ldr r2, off_801E5C8 // =byte_203EBA0 
	ldr r3, dword_801E5CC // =0x600bb40 
	ldr r6, off_801E5D0 // =dword_86B7AE0 

loop_801E594:
	push {r0,r2-r4,r6}
	ldrh r0, [r4]
	push {r2,r3}
	bl selectVirusOrNaviNamesAndWhich_800EC56 // (a1: u16?) -> (Textscript*, u8?)
	pop {r2,r3}
	mov r4, #9
	mov r5, #1
	mov r7, #0
	bl renderTextGfx_8045F8C
	mov r7, r0
	pop {r0,r2-r4,r6}
	ldr r1, off_801E5D4 // =0x240 
	add r2, r2, r1
	add r3, r3, r1
	strh r7, [r4]
	add r4, #2
	sub r0, #1
	bne loop_801E594

	mov r0, #1
	lsl r0, r0, #0xd
	bl dispatch_801DA48

	pop {r4,r5,r7,pc}
	.balign 4, 0
off_801E5C8:
	.word byte_203EBA0
dword_801E5CC:
	.word 0x600BB40
off_801E5D0:
	.word dword_86B7AE0
off_801E5D4:
	.word 0x240
word_801E5D8:
	.hword 0xD1D6, 0x0, 0x1A0, 0x0
	thumb_func_end RetrieveAndRenderEnemyVirusNamesInBattle_801E574

// symdb: One-line wrapper that invokes sub_801BEC2 with the fixed argument 0x4000 (1<<14), contributing nothing else.
// symdb: void sub_801E5E0(void) — tail-behaves as Next sub_801BEC2(int arg /* 0x4000 */); callers pass
// symdb: only lr, and see through r0-r2, NZC and lr from the callee.
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_801E5E0.yaml
	thumb_local_start
sub_801E5E0:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0xe
	bl flags_clearBits_20352C4_801BEC2
	pop {pc}
	thumb_func_end sub_801E5E0

// symdb: One-argument thunk that calls sub_801BEB8 with r0 = 0x4000 (1 << 14), passing the callee's results straight back to the caller.
// symdb: void sub_801E5EC(void); /* in: lr only; out: r0-r2, N/Z/C and lr as produced by sub_801BEB8 */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_801E5EC.yaml
	thumb_local_start
sub_801E5EC:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0xe
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end sub_801E5EC

// symdb: Resets the per-battle work area at 0x2035280 and kicks off the battle scene by raising and dispatching request bit 0x4000.
// symdb: sub_801E5F8(void) -> void; inputs r3-r12+lr are pass-through/ignored (r4/r5 saved and restored),
// symdb: r0/r1/lr and NZCV clobbered, no meaningful return values
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_initSceneStart_801E5F8.yaml
	thumb_func_start battle_initSceneStart_801E5F8
battle_initSceneStart_801E5F8:
	push {r4,r5,lr}
	ldr r5, off_801E77C // =eStruct2035280
	mov r0, #0
	strb r0, [r5,#0x12] // (byte_2035292 - 0x2035280)
	mov r0, #0xff
	strb r0, [r5,#0x13] // (byte_2035293 - 0x2035280)
	strb r0, [r5,#0x17] // (eStruct2035280_NaviStatusGfxIdx17 - 0x2035280)
	mov r0, #0xff
	strb r0, [r5,#0x15] // (byte_2035295 - 0x2035280)
	mov r1, #0x78 
	strh r1, [r5,#0x38] // (word_20352B8 - 0x2035280)
	mov r4, #0
	bl GetBattleEffects // () -> int
	ldr r1, dword_801E654 // =0x200000 
	tst r0, r1
	bne loc_801E63E
	bl GetBattleMode
	cmp r0, #1
	beq loc_801E63E
	cmp r0, #2
	beq loc_801E63E
	cmp r0, #3
	beq loc_801E63E
	cmp r0, #4
	beq loc_801E63E
	cmp r0, #5
	beq loc_801E63E
	cmp r0, #8
	beq loc_801E63E
	bl eventFlag1720IsSet_813BF1C
	beq loc_801E63E
	mov r4, #1
loc_801E63E:
	strb r4, [r5,#0x1e] // (byte_203529E - 0x2035280)
	mov r0, #1
	lsl r0, r0, #0xe
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0xe
	bl dispatch_801DA48
	pop {r4,r5,pc}
	.balign 4, 0
dword_801E654:
	.word 0x200000
	thumb_func_end battle_initSceneStart_801E5F8

	thumb_func_start sub_801E658
sub_801E658:
	mov r0, #0
	ldr r1, off_801E77C // =eStruct2035280
	strb r0, [r1,#0x1e] // (byte_203529E - 0x2035280)
	mov pc, lr
	thumb_func_end sub_801E658

	thumb_func_start sub_801E660
sub_801E660:
	push {r4,r6,lr}
	mov r4, r0
	ldr r2, off_801E6FC // =byte_801E700 
	ldrb r6, [r2,r4]
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#0x16]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	cmp r4, #0xb
	beq loc_801E678
	cmp r4, #0xc
	bne loc_801E684
loc_801E678:
	ldr r2, off_801E6F0 // =byte_801E6F4
	ldrb r0, [r2,r0]
	cmp r0, #3
	bne loc_801E696
	add r6, #1
	b loc_801E696
loc_801E684:
	cmp r4, #1
	blt loc_801E696
	cmp r4, #0xa
	bgt loc_801E696
	ldr r2, off_801E6F0 // =byte_801E6F4
	ldrb r0, [r2,r0]
	cmp r0, #2
	bne loc_801E696
	add r6, #5
loc_801E696:
	mov r0, r6
	mov r1, r3
	pop {r4,r6,pc}
	thumb_func_end sub_801E660

	thumb_local_start
sub_801E69C:
	push {r4,r6,lr}
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#0x16]
	bl sub_8015B5C
	b loc_801E6B2
	thumb_func_end sub_801E69C

// symdb: Looks up the emotion palette/effect index for a battle object's current emotion/transformation, with special-cased boosts for BeastOut/transformed states.
// symdb: (r5 = BattleObject*) -> r0 = emotion/pose id, r1 = r3 (some flag from caller) ; side effects:
// symdb: clobbers r4, r6
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_resolveEmotionPalette_801E6A8.yaml
	thumb_local_start
battleObject_resolveEmotionPalette_801E6A8:
	push {r4,r6,lr}
	ldr r0, [r5,#0x48]
	ldrb r0, [r0,#oBattleObject_Alliance]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
loc_801E6B2:
	cmp r1, #0
	bne loc_801E6BE
	ldr r2, off_801E6F0 // =byte_801E6F4
	ldrb r0, [r2,r0]
	mov r1, r3
	b locret_801E6EE
loc_801E6BE: .align 1, 0
	mov r4, r1
	ldr r2, off_801E6FC // =byte_801E700 
	ldrb r6, [r2,r4]
	cmp r4, #0xb
	beq loc_801E6CC
	cmp r4, #0xc
	bne loc_801E6D8
loc_801E6CC:
	ldr r2, off_801E6F0 // =byte_801E6F4
	ldrb r0, [r2,r0]
	cmp r0, #3
	bne loc_801E6EA
	add r6, #1
	b loc_801E6EA
loc_801E6D8:
	cmp r4, #1
	blt loc_801E6EA
	cmp r4, #0xa
	bgt loc_801E6EA
	ldr r2, off_801E6F0 // =byte_801E6F4
	ldrb r0, [r2,r0]
	cmp r0, #2
	bne loc_801E6EA
	add r6, #5
loc_801E6EA:
	mov r0, r6
	mov r1, r3
locret_801E6EE:
	pop {r4,r6,pc}
off_801E6F0:
	.word byte_801E6F4
byte_801E6F4:
	.byte 0x0, 0x2, 0x3, 0x1, 0x5, 0x4, 0x0, 0x0
off_801E6FC:
	.word byte_801E700
byte_801E700:
	.byte 0x0, 0x5, 0x6, 0x7, 0x8, 0x9, 0x5, 0x6, 0x7, 0x8, 0x9, 0x14, 0x14, 0xF, 0x10, 0x11, 0x12, 0x13, 0xf, 0x10, 0x11, 0x12, 0x13, 0x16, 0x16, 0x0, 0x0, 0x0
	thumb_func_end battleObject_resolveEmotionPalette_801E6A8

// symdb: Writes a one-byte value into oStruct2035280 + 0x12 (the Navi status GFX index slot) and returns the input untouched.
// symdb: (r0 = new GFX index byte, lr = return) -> r0 = unchanged ; side effect: strb r0 to (off_801E77C
// symdb: + 0x12) [byte_2035292]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_setNaviStatusGfx_801E71C.yaml
	thumb_func_start battle_setNaviStatusGfx_801E71C
battle_setNaviStatusGfx_801E71C:
	push {r1,lr}
	ldr r1, off_801E77C // =eStruct2035280
	strb r0, [r1,#0x12] // (byte_2035292 - 0x2035280)
	pop {r1,pc}
	thumb_func_end battle_setNaviStatusGfx_801E71C

// symdb: Records a new navi status graphics index and status value into the navi status state block, carrying over the previous display index and flagging a pending update.
// symdb: void naviStatus_SetGfxAndStatus(u8 gfxIdx /*r0*/, u8 status /*r1*/); returns displayIdx in r2,
// symdb: clobbers r0 and flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/naviStatus_SetGfxAndStatus_801E724.yaml
	thumb_func_start naviStatus_SetGfxAndStatus_801E724
naviStatus_SetGfxAndStatus_801E724:
	push {r5,lr}
	ldr r5, off_801E77C // =eStruct2035280
	ldrb r2, [r5,#0x17] // (eStruct2035280_NaviStatusGfxIdx17 - 0x2035280)
	cmp r2, #0xff
	bne loc_801E730
	ldrb r2, [r5,#0x15] // (byte_2035295 - 0x2035280)
loc_801E730:
	strb r2, [r5,#0x1f] // (byte_203529F - 0x2035280)
	strb r1, [r5,#0x16] // (byte_2035296 - 0x2035280)
	strb r0, [r5,#0x17] // (eStruct2035280_NaviStatusGfxIdx17 - 0x2035280)
	mov r0, #0xff
	strb r0, [r5,#0x13] // (byte_2035293 - 0x2035280)
	pop {r5,pc}
	thumb_func_end naviStatus_SetGfxAndStatus_801E724

// symdb: Two-instruction wrapper that invokes sub_801BEC2 with the constant 0x8000 (1 << 15); nothing better than "argument-8000 thunk to sub_801BEC2" can be said until the callee is identified.
// symdb: void sub_801E73C(void); // in: lr (return address); out: r0 = 0x8000 (argument forwarded into
// symdb: sub_801BEC2), r1/r2 = whatever sub_801BEC2 leaves, nz/c = flags from the final 'lsl r0, r0,
// symdb: #0xf', lr = 0x0801E747 (BL return address)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801E73C.yaml
	thumb_local_start
sub_801E73C:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0xf
	bl flags_clearBits_20352C4_801BEC2
	pop {pc}
	thumb_func_end sub_801E73C

// symdb: One-line wrapper that tail-calls sub_801BEB8 with argument 0x8000 (bit 15 set).
// symdb: void sub_801E748(void); /* tail-calls sub_801BEB8(0x8000); r0-r2, NZC and LR returned through
// symdb: from the callee */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_801E748.yaml
	thumb_local_start
sub_801E748:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0xf
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end sub_801E748

// symdb: Checks whether the cross-net (double/linked battle) state flag is set and whether the linked partner session has reached the expected mode, returning 0/1/2 accordingly.
// symdb: u32 sub_801E754(void) — takes no meaningful inputs (r1/r2/lr are scratch, r1 and r2 preserved);
// symdb: returns in r0: 0 = bit 15 of dword_20352C0 clear, 1 = flag set but partner state doesn't match,
// symdb: 2 = flag set and partner mode == 4. C/V are left from the caller's last flag-setting instruction
// symdb: (carry clear on the early-exit path); N/Z reflect the last test.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/comm_checkCrossNetBattleReady_801E754.yaml
	thumb_func_start comm_checkCrossNetBattleReady_801E754
comm_checkCrossNetBattleReady_801E754:
	push {r1,r2,lr}
	ldr r2, off_801E77C // =eStruct2035280
	ldr r1, [r2,#0x40] // (dword_20352C0 - 0x2035280)
	mov r0, #1
	lsl r0, r0, #0xf
	and r0, r1
	beq locret_801E778
	mov r0, #1
	ldr r2, off_801E924 // =byte_2036840 
	ldrb r1, [r2,#0x8] // (byte_2036848 - 0x2036840)
	cmp r1, #4
	beq loc_801E770
	cmp r1, #2
	bne locret_801E778
loc_801E770:
	ldrb r1, [r2]
	cmp r1, #4
	bne locret_801E778
	mov r0, #2
locret_801E778:
	pop {r1,r2,pc}
	.balign 4, 0
off_801E77C:
	.word eStruct2035280
	thumb_func_end comm_checkCrossNetBattleReady_801E754

	thumb_func_start sub_801E780
sub_801E780:
	ldr r2, off_801E924 // =byte_2036840 
	ldrb r1, [r2,#0x8] // (byte_2036848 - 0x2036840)
	cmp r1, #4
	beq loc_801E78C
	cmp r1, #2
	bne locret_801E790
loc_801E78C:
	mov r0, #0x2d 
	strb r0, [r2,#0x7] // (byte_2036847 - 0x2036840)
locret_801E790:
	mov pc, lr
	thumb_func_end sub_801E780

// symdb: Kicks off a battle sub-effect (intro/effect animation) identified by a kind byte: guards re-entry via eStruct2035280+0x40 bit 0x8000, allocates a sprite slot, picks the per-kind handler from off_801E944, runs it, then arms the eStruct request bit.
// symdb: (r0 = kind, r1 = aux/param1, r2 = aux/param2, r3 = aux/param3) -> r0 = 0 on success, 1 if the
// symdb: effect is already busy or no slot was free; side effects: writes 9 bytes at byte_2036840, sets
// symdb: eStruct2035280+0x40 bit 0x8000, calls dispatch_801DA48(0x8000) and dispatch_801DACC(0x100) when
// symdb: kind==0x24
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_dispatchKindEffect_801E792.yaml
	thumb_func_start battle_dispatchKindEffect_801E792
battle_dispatchKindEffect_801E792:
	push {r4-r7,lr}
	sub sp, sp, #0xc
	str r0, [sp]
	str r1, [sp,#4]
	str r2, [sp,#8]
	str r3, [sp,#0xc]
	ldr r3, off_801E824 // =eStruct2035280
	ldr r3, [r3,#0x40] // (dword_20352C0 - 0x2035280)
	mov r0, #1
	lsl r0, r0, #0xf
	tst r0, r3
	bne loc_801E81C
	ldr r5, off_801E924 // =byte_2036840 
	mov r2, #0
	strb r2, [r5,#0x7] // (byte_2036847 - 0x2036840)
	strb r2, [r5]
	bl battle_allocateActorIndex_802FE48
	cmp r0, #0xff
	beq loc_801E81C
	strb r0, [r5,#0x6] // (byte_2036846 - 0x2036840)
	mov r3, r0
	mov r0, #0
	mov r1, #0x40 
	mov r2, #0xe0
	bl sprite_setAffineTransform_802FE7A
	ldr r0, [sp]
	cmp r0, #0
	bne loc_801E7D8
	ldr r1, [sp,#4]
	cmp r1, #0
	beq loc_801E7D8
	mov r0, #0x30 
	str r0, [sp]
loc_801E7D8:
	strb r0, [r5,#0x1] // (byte_2036841 - 0x2036840)
	ldr r1, off_801E928 // =pt_801EF84 
	ldr r4, [r1,r0]
	ldrh r0, [r4]
	strh r0, [r5,#0x2] // (word_2036842 - 0x2036840)
	ldrb r0, [r4,#2]
	strb r0, [r5,#0x8] // (byte_2036848 - 0x2036840)
	lsl r0, r0, #2
	ldr r6, off_801E940 // =off_801E944 
	ldr r6, [r6,r0]
	ldr r0, [sp]
	ldr r1, [sp,#4]
	ldr r2, [sp,#8]
	ldr r3, [sp,#0xc]
	mov lr, pc
	bx r6
	mov r0, #1
	lsl r0, r0, #0xf
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0xf
	bl dispatch_801DA48
	ldrb r0, [r5,#0x1] // (byte_2036841 - 0x2036840)
	cmp r0, #0x24 
	bne loc_801E816
	mov r0, #1
	lsl r0, r0, #8
	bl dispatch_801DACC // (a0: flags32) -> ()
loc_801E816:
	mov r0, #0
	add sp, sp, #0xc
	pop {r4-r7,pc}
loc_801E81C:
	mov r0, #1
	add sp, sp, #0xc
	pop {r4-r7,pc}
	.balign 4, 0
off_801E824:
	.word eStruct2035280
	thumb_func_end battle_dispatchKindEffect_801E792

// symdb: Stores a byte value clamped to a maximum of 99 into a struct field, then calls a helper to refresh whatever depends on it.
// symdb: void sub_801E828(u8 value /*r1*/, struct* ptr /*r5*/); sets flags and r0-r3 via the tail call
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/setByteFieldCapped99_801E828.yaml
	thumb_local_start
setByteFieldCapped99_801E828:
	push {lr}
	cmp r1, #0x63 
	ble loc_801E830
	mov r1, #0x63 
loc_801E830:
	strb r1, [r5,#9]
	bl battle_queueScoreAndTiles_801E838
	pop {pc}
	thumb_func_end setByteFieldCapped99_801E828

// symdb: Battle graphics helper that queues VRAM OBJ-tile transfers from a 5×4 source-tile list, optionally draws a 2-digit BCD score into the score-digit tile area, and always copies a fixed background tile.
// symdb: void sub_801E838(u32 tile_list /* r4 */, u32 battle_state /* r5 */); // preserves r4–r7;
// symdb: clobbers r0–r3, NZCV from final QueueEightWordAlignedGFXTransfer
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_queueScoreAndTiles_801E838.yaml
	thumb_local_start
battle_queueScoreAndTiles_801E838:
	push {r4-r7,lr}
	add r7, r4, #4
	mov r4, #5
	ldr r1, dword_801E92C // =0x6016e00 
	mov r2, #0x20 
loc_801E842:
	mov r6, #4
loc_801E844:
	ldr r0, [r7]
	ldr r3, off_801E958 // =byte_801FDC0
	cmp r0, r3
	beq loc_801E84E
	add r7, #4
loc_801E84E:
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r0, #0x20 
	add r1, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	sub r1, #0x60 
	sub r6, #1
	bne loc_801E844
	add r1, #0x80
	sub r4, #1
	bne loc_801E842
	ldrb r0, [r5,#8]
	cmp r0, #1
	bne loc_801E8C0
	ldr r0, [r7]
	ldr r1, off_801E958 // =byte_801FDC0
	cmp r0, r1
	bne loc_801E876
	add r7, #4
loc_801E876:
	ldrh r0, [r7]
	strh r0, [r5,#4]
	ldrb r0, [r5,#9]
	bl memory_bcdConvert
	mov r7, #0xf
	and r7, r0
	lsr r6, r0, #4
	bne loc_801E890
	mov r6, #0xa
	ldrb r0, [r5,#4]
	sub r0, #4
	strb r0, [r5,#4]
loc_801E890:
	ldr r3, off_801E930 // =off_801FD64 
	lsl r6, r6, #2
	ldr r6, [r3,r6]
	lsl r7, r7, #2
	ldr r7, [r3,r7]
	mov r2, #0x20 
	ldr r1, dword_801E934 // =0x6017300 
	mov r0, r6
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r1, #0x20 
	mov r0, r7
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, r6
	add r0, #0x20 
	add r1, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, r7
	add r0, #0x20 
	add r1, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_801E8C0:
	ldr r0, off_801E938 // =byte_86F2900 
	ldr r1, off_801E93C // =byte_30016B0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r4-r7,pc}
	thumb_func_end battle_queueScoreAndTiles_801E838

// symdb: Calls a helper with r4 = 0, then if the caller's value was 0x50 and a flag byte in the r5 struct is set, subtracts 0x10 from a counter byte in that struct.
// symdb: void condDecrementByte2By10h(u32 value /*r0*/, State* state /*r5*/); value must already be in r0
// symdb: and the struct pointer in r5 by the caller (Thumb ABI: r5 is callee-saved, so this is an
// symdb: internal helper relying on r5 being live). Returns r0 and flags encoding which branch was taken.
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_801E8CC.yaml
	thumb_local_start
sub_801E8CC:
	push {r4,lr}
	mov r4, #0
	push {r0}
	bl sub_801E95C
	pop {r0}
	cmp r0, #0x50 
	bne locret_801E8E8
	ldrb r0, [r5,#0xc]
	cmp r0, #0
	beq locret_801E8E8
	ldrb r0, [r5,#2]
	sub r0, #0x10
	strb r0, [r5,#2]
locret_801E8E8:
	pop {r4,pc}
	thumb_func_end sub_801E8CC

	thumb_local_start
sub_801E8EA:
	push {lr}
	mov r3, #0
	strb r3, [r5,#0xe]
	bl sub_801E8FA
	bl battle_queueScoreAndTiles_801E838
	pop {pc}
	thumb_func_end sub_801E8EA

	thumb_local_start
sub_801E8FA:
	push {r4,lr}
	bl sub_801EAEC
	mov r4, r2
	mov r0, r1
	bl memory_bcdConvert
	strh r0, [r5,#0xa]
	mov r0, r4
	bl memory_bcdConvert
	strh r2, [r5,#0xc]
	pop {r4,pc}
	thumb_func_end sub_801E8FA

	thumb_func_start sub_801E914
sub_801E914:
	push {r4,r5,lr}
	ldr r5, off_801E924 // =byte_2036840 
	mov r2, r1
	mov r1, r0
	bl sub_801E8FA
	pop {r4,r5,pc}
	.balign 4, 0
off_801E924:
	.word byte_2036840
off_801E928:
	.word pt_801EF84
dword_801E92C:
	.word 0x6016E00
off_801E930:
	.word off_801FD64
dword_801E934:
	.word 0x6017300
off_801E938:
	.word byte_86F2900
off_801E93C:
	.word byte_30016B0
off_801E940:
	.word off_801E944
off_801E944:
	.word setByteFieldCapped99_801E828+1
	.word setByteFieldCapped99_801E828+1
	.word setByteFieldCapped99_801E828+1
	.word sub_801E8CC+1
	.word sub_801E8EA+1
off_801E958:
	.word byte_801FDC0
	thumb_func_end sub_801E914

	thumb_local_start
sub_801E95C:
	push {r4-r7,lr}
	mov r6, #0
	strb r6, [r5,#7]
	strb r6, [r5]
	strb r6, [r5,#1]
	strh r6, [r5,#0xa]
	strb r6, [r5,#0xc]
	strh r3, [r5,#4]
	push {r1,r2,r4,r5}
	ldrh r0, [r5,#4]
	bl chip_SelectNameTextTable_8027D10
	bl selectPlayerSide_801EA5A
	mov r4, #8
	mov r5, #1
	ldr r6, off_801EAA0 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	pop {r2-r5}
	strb r0, [r5,#9]
	push {r2,r3}
	// idx
	ldrh r0, [r5,#4]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#9]
	mov r1, #2
	tst r0, r1
	pop {r2,r3}
	beq loc_801E9FC
	ldr r0, dword_801EAE4 // =0x8000 
	tst r0, r2
	beq loc_801E9A6
	bic r2, r0
	mov r0, #1
	strb r0, [r5,#0xc]
loc_801E9A6:
	ldr r0, dword_801EAE8 // =0x7800 
	bic r2, r0
	cmp r2, #0
	beq loc_801E9FC
	push {r3-r5}
	lsl r6, r4, #2
	mov r0, r2
	bl memory_bcdConvert
	mov r4, r0
	bl countHexDigits_8000C5C
	strb r0, [r5,#0xa]
	ldr r1, dword_801EA6C // =0xaaaa 
	lsl r0, r0, #2
	lsl r1, r0
	orr r4, r1
	ldr r1, off_801EA78 // =dword_801EA7C 
	ldr r1, [r1,r6]
	bl sub_801EA34
	pop {r0,r4,r5}
	ldr r1, dword_801EAE8 // =0x7800 
	bic r0, r1
	cmp r0, #0
	beq loc_801E9FC
	push {r4}
	bl memory_bcdConvert
	mov r4, r0
	bl countHexDigits_8000C5C
	add r1, r0, #1
	strb r1, [r5,#0xb]
	ldr r1, dword_801EA70 // =0xaaab 
	lsl r0, r0, #2
	lsl r1, r0
	orr r4, r1
	ldr r1, off_801EA84 // =dword_801EA88 
	ldr r1, [r1,r6]
	bl sub_801EA34
	pop {r4}
loc_801E9FC:
	ldrb r1, [r5,#9]
	ldrb r0, [r5,#0xa]
	add r1, r1, r0
	ldrb r0, [r5,#0xb]
	add r1, r1, r0
	mov r0, #0xf
	sub r0, r0, r1
	lsl r0, r0, #2
	ldrb r1, [r5,#0xc]
	lsl r1, r1, #4
	mul r1, r4
	sub r0, r0, r1
	ldrb r1, [r5,#2]
	add r0, r0, r1
	strb r0, [r5,#2]
	ldr r0, off_801EA90 // =dword_86E1C78 
	ldr r1, off_801EA94 // =byte_30016B0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	// dataList
	ldr r0, off_801EAAC // =off_801EAB0 
	bl QueueGFXTransfersInList // (u32 *dataRefs) -> void
	mov r0, #0
	pop {r4-r7,pc}
	pop {r1-r3,r5}
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_801E95C

// symdb: Queues four pairs of 0x20-byte GFX transfers (a base chunk and a +0x20 chunk to destination+0x80), stepping the destination back by 0x20 each time and indexing the source table off_801FD90 by the low-to-high nibbles of r4.
// symdb: void sub_801EA34(u32 r1, u32 r4);  // r1 = current VRAM destination, r4 = packed nibble
// symdb: selector; preserves r5, r6; clobbers nz,c,v and r0,r2,r3,r7,lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801EA34.yaml
	thumb_local_start
sub_801EA34:
	push {r6,lr}
	ldr r6, off_801EA74 // =off_801FD90 
	mov r7, #4
	mov r2, #0x20 
loc_801EA3C:
	mov r0, #0xf
	and r0, r4
	lsl r0, r0, #2
	ldr r0, [r6,r0]
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r0, r0, r2
	add r1, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	sub r1, #0xa0
	lsr r4, r4, #4
	sub r7, #1
	bne loc_801EA3C
	pop {r6,pc}
	thumb_func_end sub_801EA34

// symdb: Picks player-side VRAM and palette-byte bases from a side flag the caller left at sp+8, returning them in r2/r3.
// symdb: void selectPlayerSide_801EA5A(void) /* in: [sp+8] side flag; out: r2 base, r3 pal_base; clobbers
// symdb: nz c v */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/selectPlayerSide_801EA5A.yaml
	thumb_local_start
selectPlayerSide_801EA5A:
	ldr r2, [sp,#8]
	cmp r2, #1
	beq loc_801EA66
	ldr r2, off_801EA98 // =byte_203EDA0 
	ldr r3, dword_801EA9C // =0x6016e00 
	mov pc, lr
loc_801EA66:
	ldr r2, off_801EAA4 // =byte_203EFA0 
	ldr r3, dword_801EAA8 // =0x6017280 
	mov pc, lr
	.balign 4, 0
dword_801EA6C:
	.word 0xAAAA
dword_801EA70:
	.word 0xAAAB
off_801EA74:
	.word off_801FD90
off_801EA78:
	.word dword_801EA7C
dword_801EA7C:
	.word 0x6017060
	.word 0x60174E0
off_801EA84:
	.word dword_801EA88
dword_801EA88:
	.word 0x6017160
	.word 0x60175E0
off_801EA90:
	.word dword_86E1C78
off_801EA94:
	.word byte_30016B0
off_801EA98:
	.word byte_203EDA0
dword_801EA9C:
	.word 0x6016E00
off_801EAA0:
	.word dword_86B7AE0
off_801EAA4:
	.word byte_203EFA0
dword_801EAA8:
	.word 0x6017280
off_801EAAC:
	.word off_801EAB0
off_801EAB0:
	.word dword_86BA120
	.word 0x6017200
	.word 0x20
	.word byte_86BA140
	.word 0x6017240
	.word 0x20
	.word dword_86B7BA0
	.word 0x6017220
	.word 0x20
	.word byte_86B7BC0
	.word 0x6017260
	.word 0x20
	.word 0x0
dword_801EAE4:
	.word 0x8000
dword_801EAE8:
	.word 0x7800
	thumb_func_end selectPlayerSide_801EA5A

	thumb_local_start
sub_801EAEC:
	ldr r3, dword_801EAFC // =0x270f 
	cmp r1, r3
	ble loc_801EAF4
	mov r1, r3
loc_801EAF4:
	cmp r2, r3
	ble locret_801EAFA
	mov r2, r3
locret_801EAFA:
	mov pc, lr
dword_801EAFC:
	.word 0x270F
	thumb_func_end sub_801EAEC

	thumb_local_start
sub_801EB00:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0x10
	bl flags_clearBits_20352C4_801BEC2
	pop {pc}
	thumb_func_end sub_801EB00

	thumb_local_start
sub_801EB0C:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0x10
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end sub_801EB0C

	thumb_func_start sub_801EB18
sub_801EB18:
	push {r4,r5,lr}
	mov r4, #0x50 // (pt_801EFD4 - 0x801ef84)
	ldr r3, off_801EB4C // =pt_801EF84 
	ldr r3, [r3,r4]
	ldr r5, off_801EB48 // =unk_2036850 
	ldrh r4, [r3]
	strh r4, [r5,#0x2] // (word_2036852 - 0x2036850)
	ldrb r4, [r3,#0x2] // (byte_801F556 - 0x801f554)
	strb r4, [r5,#0x8] // (byte_2036858 - 0x2036850)
	mov r4, #1
	mov r3, r0
	bl sub_801E95C
	mov r4, #0x3c 
	strb r4, [r5,#0x7] // (byte_2036857 - 0x2036850)
	mov r0, #1
	lsl r0, r0, #0x10
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0x10
	bl dispatch_801DA48
	pop {r4,r5,pc}
	.balign 4, 0
off_801EB48:
	.word unk_2036850
off_801EB4C:
	.word pt_801EF84
	thumb_func_end sub_801EB18

	thumb_local_start
sub_801EB50:
	push {r4,r5,lr}
	mov r0, #0
	mov r1, #0x12
	mov r2, #3
	mov r3, #0
	mov r4, #0x1e
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #0
	mov r1, #0x12
	mov r2, #0
	mov r3, #0
	mov r4, #0x1e
	mov r5, #2
	bl call_sub_3005EBA
	mov r0, #1
	lsl r0, r0, #0x12
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end sub_801EB50

	thumb_local_start
sub_801EB7C:
	push {lr}
	// j
	mov r0, #0
	// i
	mov r1, #0x12
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_801EB98 // =byte_801EE98
	mov r4, #0x1e
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r0, #1
	lsl r0, r0, #0x12
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}

	.balign 4, 0
off_801EB98:
	.word byte_801EE98
	thumb_func_end sub_801EB7C

	thumb_local_start
sub_801EB9C:
	push {r4,r6,r7,lr}
	ldr r0, off_801EBC0 // =dword_86EA92C 
	ldr r1, off_801EBC4 // =unk_3001AC0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #1
	lsl r0, r0, #0x12
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0x12
	bl dispatch_801DA48
	mov r0, #0
	ldr r1, off_801ECB0 // =eStruct2035280
	strb r0, [r1,#0x1a] // (byte_203529A - 0x2035280)
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_801EBC0:
	.word dword_86EA92C
off_801EBC4:
	.word unk_3001AC0
	thumb_func_end sub_801EB9C

	thumb_local_start
sub_801EBC8:
	ldr r1, off_801ECB0 // =eStruct2035280
	strb r0, [r1,#0x1a] // (byte_203529A - 0x2035280)
	mov r0, #0
	strh r0, [r1,#0x30] // (word_20352B0 - 0x2035280)
	mov pc, lr
	thumb_func_end sub_801EBC8

	thumb_local_start
sub_801EBD2:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0x13
	bl flags_clearBits_20352C4_801BEC2
	pop {pc}
	thumb_func_end sub_801EBD2

	thumb_local_start
sub_801EBDE:
	push {lr}
	ldr r0, off_801EBF4 // =dword_86E97CC 
	ldr r1, dword_801EBF8 // =0x6017800 
	ldr r2, off_801EBFC // =0x100 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #1
	lsl r0, r0, #0x13
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	.balign 4, 0
off_801EBF4:
	.word dword_86E97CC
dword_801EBF8:
	.word 0x6017800
off_801EBFC:
	.word 0x100
	push {lr}
	ldr r0, off_801EC24 // =dword_86E9A0C 
	ldr r1, off_801EC28 // =byte_30016D0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, dword_801EC20 // =0x80000 
	bl eStruct2035280_SetRequestBits_801BECC
	ldr r0, dword_801EC20 // =0x80000 
	bl dispatch_801DA48
	mov r0, #0
	ldr r1, off_801ECB0 // =eStruct2035280
	strh r0, [r1,#0x34] // (word_20352B4 - 0x2035280)
	pop {pc}
dword_801EC20:
	.word 0x80000
off_801EC24:
	.word dword_86E9A0C
off_801EC28:
	.word byte_30016D0
	thumb_func_end sub_801EBDE

	thumb_local_start
sub_801EC2C:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0x15
	bl flags_clearBits_20352C4_801BEC2
	pop {pc}
	thumb_func_end sub_801EC2C

	thumb_local_start
sub_801EC38:
	push {lr}
	mov r0, #1
	lsl r0, r0, #0x15
	bl flagSetBits_eStruct2035280_801BEB8
	pop {pc}
	thumb_func_end sub_801EC38

	thumb_func_start sub_801EC44
sub_801EC44:
	push {r4,r6,r7,lr}
	ldr r0, off_801EC74 // =dword_86E994C 
	ldr r1, dword_801EC78 // =0x6016d00 
	mov r2, #0xc0
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, off_801EC7C // =dword_86E9A0C 
	ldr r1, off_801EC80 // =byte_30016F0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #1
	lsl r0, r0, #0x15
	bl eStruct2035280_SetRequestBits_801BECC
	mov r0, #1
	lsl r0, r0, #0x15
	bl dispatch_801DA48
	ldr r1, off_801ECB0 // =eStruct2035280
	mov r0, #0x3c 
	strb r0, [r1,#0x1b] // (byte_203529B - 0x2035280)
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_801EC74:
	.word dword_86E994C
dword_801EC78:
	.word 0x6016D00
off_801EC7C:
	.word dword_86E9A0C
off_801EC80:
	.word byte_30016F0
	thumb_func_end sub_801EC44

	thumb_local_start
sub_801EC84:
	push {r4,r5,lr}
	mov r0, #1
	lsl r0, r0, #0x16
	bl flags_clearBits_20352C4_801BEC2
	pop {r4,r5,pc}
	thumb_func_end sub_801EC84

	thumb_local_start
sub_801EC90:
	push {r4,r5,lr}
	ldr r0, off_801ECA8 // =dword_86E9A0C 
	ldr r1, off_801ECAC // =byte_30016D0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #1
	lsl r0, r0, #0x16
	bl flagSetBits_eStruct2035280_801BEB8
	pop {r4,r5,pc}
	.balign 4, 0
off_801ECA8:
	.word dword_86E9A0C
off_801ECAC:
	// <endpool>
	.word byte_30016D0
	thumb_func_end sub_801EC90

off_801ECB0:
	.word eStruct2035280
/*For debugging purposes, connect comment at any range!*/
