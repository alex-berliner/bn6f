
	thumb_local_start
sub_8026450:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x10
	str r6, [sp]
	str r7, [sp,#4]
	str r0, [sp,#8]
	str r1, [sp,#0xc]
	mov r4, r2
	bl object_getFrontDirection // () -> int
	mov r6, r0
loc_8026464:
	mov r0, #0
	ldrsb r0, [r4,r0]
	cmp r0, #0x7f
	beq loc_80264A2
	mul r0, r6
	ldr r2, [sp,#8]
	add r0, r0, r2
	bmi loc_802649E
	cmp r0, #6
	bgt loc_802649E
	mov r1, r0
	mul r1, r6
	ldr r2, [sp]
	mul r2, r6
	cmp r1, r2
	bgt loc_802649E
	mov r1, #1
	ldrsb r1, [r4,r1]
	ldr r2, [sp,#0xc]
	add r1, r1, r2
	bmi loc_802649E
	cmp r1, #3
	bgt loc_802649E
	push {r0,r1}
	bl sub_800E680
	cmp r0, #0
	pop {r0,r1}
	bne loc_80264A4
loc_802649E:
	add r4, #2
	b loc_8026464
loc_80264A2:
	mov r0, #0
loc_80264A4:
	add sp, sp, #0x10
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8026450

	thumb_local_start
sub_80264A8:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x10
	str r6, [sp]
	str r7, [sp,#4]
	str r0, [sp,#8]
	str r1, [sp,#0xc]
	mov r4, r2
	bl object_getFrontDirection // () -> int
	mov r6, r0
loc_80264BC:
	mov r0, #0
	ldrsb r0, [r4,r0]
	cmp r0, #0x7f
	beq loc_802650A
	mul r0, r6
	ldr r2, [sp,#8]
	add r0, r0, r2
	bmi loc_8026506
	cmp r0, #6
	bgt loc_8026506
	mov r1, r0
	mul r1, r6
	ldr r2, [sp]
	mul r2, r6
	cmp r1, r2
	bgt loc_8026506
	mov r1, #1
	ldrsb r1, [r4,r1]
	ldr r2, [sp,#0xc]
	add r1, r1, r2
	bmi loc_8026506
	cmp r1, #3
	bgt loc_8026506
	push {r0,r1}
	bl sub_800E680
	cmp r0, #0
	pop {r0,r1}
	beq loc_8026506
	ldr r2, [sp]
	ldr r3, [sp,#4]
	push {r0,r1}
	bl sub_8026510
	cmp r0, #0
	pop {r0,r1}
	bne loc_802650C
loc_8026506:
	add r4, #2
	b loc_80264BC
loc_802650A:
	mov r0, #0
loc_802650C:
	add sp, sp, #0x10
	pop {r4,r6,r7,pc}
	thumb_func_end sub_80264A8

	thumb_local_start
sub_8026510:
	push {r4,r6,r7,lr}
	mov r6, r2
	mov r7, r3
	push {r0,r1}
	bl object_getFrontDirection // () -> int
	mov r4, r0
	pop {r0,r1}
loc_8026520:
	push {r0,r1}
	ldr r3, off_8026540 // =byte_8026544
	bl GetAllianceDependentPanelParamArgs
	bl object_checkPanelParameters
	cmp r0, #0
	pop {r0,r1}
	beq loc_802653C
	add r0, r0, r4
	cmp r0, r6
	bne loc_8026520
	mov r0, #1
	b locret_802653E
loc_802653C:
	mov r0, #0
locret_802653E:
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8026540:
	.word byte_8026544
byte_8026544:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x80, 0x5, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x80
	.byte 0xA
	thumb_func_end sub_8026510

	thumb_func_start battle_beastJumpLockOn_8026554
// exe6g: 8026964
battle_beastJumpLockOn_8026554:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, r1
	// panel check
	cmp r0, #1
	blt loc_802656A
	cmp r0, #6
	bgt loc_802656A
	cmp r1, #1
	blt loc_802656A
	cmp r1, #3
	ble loc_802656C
loc_802656A:
	mov r2, #0
loc_802656C:
	lsl r2, r2, #2
	ldr r3, off_8026580 // =jt_8026584 exe6g 8026994
	ldr r2, [r3,r2]
	mov lr, pc
	bx r2
	pop {r6,r7,pc}
	.word 0
	.byte 0, 0, 0, 0
	.balign 4, 0
off_8026580:
	.word jt_8026584
jt_8026584:
	.word sub_802661C+1
	.word sub_8026622+1
	.word sub_8026650+1
	.word sub_802665A+1
	.word sub_8026668+1
	.word sub_8026672+1
	.word sub_802667C+1
	.word sub_802668A+1
	.word sub_8026694+1
	.word sub_802669E+1
	.word sub_80266AC+1
	.word sub_80266BA+1
	.word sub_80266DE+1
	.word sub_80266E8+1
	.word sub_80266F2+1
	.word sub_8026704+1
	.word sub_802670E+1
	.word sub_802671C+1
	.word sub_8026726+1
	thumb_func_end battle_beastJumpLockOn_8026554

	thumb_local_start
sub_80265D0:
	push {r4,lr}
	push {r0}
	mov r0, r6
	ldr r4, off_80267E8 // =byte_8026735 
loc_80265D8:
	ldr r2, [sp]
	mov r1, r7
	bl sub_8026450
	cmp r0, #0
	bne loc_80265FA
	bl object_getFrontDirection // () -> int
	mov r1, #0
	ldrsb r1, [r4,r1]
	cmp r1, #0x7f
	beq loc_80265F8
	add r4, #1
	mul r0, r1
	add r0, r0, r6
	b loc_80265D8
loc_80265F8:
	mov r0, #0
loc_80265FA:
	add sp, sp, #4
	pop {r4,pc}
	thumb_func_end sub_80265D0

	thumb_local_start
sub_80265FE:
	push {r6,r7,lr}
	mov r6, r0
	mov r7, r1
	mov r1, #2
	beq locret_802661A
	mov r1, #2
	push {r0,r1}
	bl sub_800E680
	cmp r0, #0
	pop {r0,r1}
	bne locret_802661A
	mov r0, r6
	mov r1, r7
locret_802661A:
	pop {r6,r7,pc}
	thumb_func_end sub_80265FE

	thumb_local_start
sub_802661C:
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	mov pc, lr
	thumb_func_end sub_802661C

	thumb_local_start
sub_8026622:
	push {r4,lr}
	mov r1, r7
	ldr r2, off_80267EC // =byte_802673C 
	ldrb r3, [r5,#oBattleObject_PanelY]
	cmp r1, r3
	bne loc_8026630
	ldr r2, off_80267F0 // =byte_802673A 
loc_8026630:
	ldr r4, off_80267F4 // =byte_8026730 
loc_8026632:
	ldrb r0, [r5,#oBattleObject_PanelX]
	bl sub_8026450
	cmp r0, #0
	bne locret_802664E
	mov r1, #0
	ldrsb r1, [r4,r1]
	cmp r1, #0x7f
	beq locret_802664E
	add r4, #1
	add r1, r1, r7
	mov r0, r6
	ldr r2, off_80267F8 // =byte_802673C 
	b loc_8026632
locret_802664E:
	pop {r4,pc}
	thumb_func_end sub_8026622

	thumb_local_start
sub_8026650:
	push {lr}
	ldr r0, off_80267FC // =byte_8026753 
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_8026650

	thumb_local_start
sub_802665A:
	push {lr}
	ldr r0, off_8026800 // =byte_802675A 
	bl sub_80265D0
	bl sub_80265FE
	pop {pc}
	thumb_func_end sub_802665A

	thumb_local_start
sub_8026668:
	push {lr}
	ldr r0, off_8026804 // =byte_8026761 
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_8026668

	thumb_local_start
sub_8026672:
	push {lr}
	ldr r0, off_8026808 // =byte_802676E 
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_8026672

	thumb_local_start
sub_802667C:
	push {lr}
	ldr r0, off_802680C // =byte_8026781 
	bl sub_80265D0
	bl sub_80265FE
	pop {pc}
	thumb_func_end sub_802667C

	thumb_local_start
sub_802668A:
	push {lr}
	ldr r0, off_8026810 // =byte_802678E 
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_802668A

	thumb_local_start
sub_8026694:
	push {lr}
	ldr r0, off_8026814 // =byte_8026791 
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_8026694

	thumb_local_start
sub_802669E:
	push {lr}
	ldr r0, off_8026818 // =byte_8026794 
	bl sub_80265D0
	bl sub_80265FE
	pop {pc}
	thumb_func_end sub_802669E

	thumb_local_start
sub_80266AC:
	push {lr}
	mov r0, r6
	mov r1, r7
	ldr r2, off_802681C // =byte_802679B 
	bl sub_80264A8
	pop {pc}
	thumb_func_end sub_80266AC

	thumb_local_start
sub_80266BA:
	push {lr}
	mov r2, #0
	ldrb r0, [r5,#oBattleObject_Alliance]
	ldrb r1, [r5,#oBattleObject_DirectionFlip]
	eor r0, r1
	mov r1, #1
	eor r0, r1
	mov r1, #5
	mul r0, r1
	add r0, #1
	cmp r0, r6
	bne loc_80266D4
	mov r2, #2
loc_80266D4:
	ldr r0, off_8026820 // =byte_80267A6 
	add r0, r0, r2
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_80266BA

	thumb_local_start
sub_80266DE:
	push {lr}
	ldr r0, off_8026824 // =byte_80267AB 
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_80266DE

	thumb_local_start
sub_80266E8:
	push {lr}
	ldr r0, off_8026828 // =byte_80267AE 
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_80266E8

	thumb_local_start
sub_80266F2:
	push {lr}
	mov r0, r6
	mov r1, r7
	ldr r2, off_802682C // =byte_802679B 
	bl sub_8026450
	bl sub_80265FE
	pop {pc}
	thumb_func_end sub_80266F2

	thumb_local_start
sub_8026704:
	push {lr}
	ldr r0, off_8026830 // =byte_80267B9 
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_8026704

	thumb_local_start
sub_802670E:
	push {lr}
	ldr r0, off_8026834 // =byte_8026791 
	bl sub_80265D0
	bl sub_80265FE
	pop {pc}
	thumb_func_end sub_802670E

	thumb_local_start
sub_802671C:
	push {lr}
	ldr r0, off_8026838 // =byte_80267CC 
	bl sub_80265D0
	pop {pc}
	thumb_func_end sub_802671C

	thumb_local_start
sub_8026726:
	push {lr}
	ldr r0, off_802683C // =byte_80267D5 
	bl sub_80265D0
	pop {pc}
	.balign 4, 0
byte_8026730:
	.byte 0xFF, 0x1, 0xFE, 0x2, 0x7F
byte_8026735:
	.byte 0xFF, 0xFE, 0xFD, 0xFC, 0x7F
byte_802673A:
	.byte 0x1, 0x0
byte_802673C:
	.byte 0x0, 0x0, 0x1, 0x0, 0xFF, 0x0, 0x2, 0x0, 0xFE, 0x0, 0x3, 0x0, 0xFD, 0x0
	.byte 0x4, 0x0, 0xFC, 0x0, 0x5, 0x0, 0xFB, 0x0, 0x7F
byte_8026753:
	.byte 0xFF, 0x0, 0xFF, 0xFF, 0xFF, 0x1, 0x7F
byte_802675A:
	.byte 0xFF, 0xFF, 0xFF, 0x1, 0xFF, 0x0, 0x7F
byte_8026761:
	.byte 0xFE, 0x0, 0xFF
	.byte 0x0, 0xFE, 0xFF, 0xFF, 0xFF, 0xFE, 0x1, 0xFF, 0x1, 0x7F
byte_802676E:
	.byte 0xFD, 0x0, 0xFE, 0x0, 0xFF, 0x0, 0xFD, 0xFF, 0xFE, 0xFF
	.byte 0xFF, 0xFF, 0xFD, 0x1, 0xFE, 0x1, 0xFF, 0x1, 0x7F
byte_8026781:
	.byte 0xFF, 0x0, 0xFF, 0xFF, 0xFF, 0x1, 0xFE, 0x0, 0xFE, 0xFF
	.byte 0xFE, 0x1, 0x7F
byte_802678E:
	.byte 0xFE, 0x0, 0x7F
byte_8026791:
	.byte 0xFD, 0x0, 0x7F
byte_8026794:
	.byte 0xFE, 0x0, 0xFE, 0xFF, 0xFE, 0x1, 0x7F
byte_802679B:
	.byte 0xFB, 0x0, 0xFC, 0x0, 0xFD, 0x0, 0xFE, 0x0, 0xFF, 0x0, 0x7F
byte_80267A6:
	.byte 0x0, 0x0, 0xFE, 0x0, 0x7F
byte_80267AB:
	.byte 0xFF, 0x0, 0x7F
byte_80267AE:
	.byte 0xFF, 0x0, 0xFE, 0xFF, 0xFE, 0x1, 0x1, 0xFF, 0x1, 0x1, 0x7F
byte_80267B9:
	.byte 0xFD, 0x0, 0xFC, 0x0, 0xFD, 0xFF, 0xFD, 0x1, 0xFC, 0xFF
	.byte 0xFC, 0x1, 0xFE, 0x0, 0xFE, 0xFF, 0xFE, 0x1, 0x7F
byte_80267CC:
	.byte 0xFE, 0x0, 0xFE, 0xFF, 0xFE, 0x1, 0xFF, 0x0, 0x7F
byte_80267D5:
	.byte 0xFF, 0x0, 0xFF, 0xFF, 0xFF, 0x1, 0x0, 0xFF, 0x0, 0x1, 0x1, 0xFF
	.byte 0x1, 0x1, 0x1, 0x0, 0x7F, 0x0, 0x0
off_80267E8:
	.word byte_8026735
off_80267EC:
	.word byte_802673C
off_80267F0:
	.word byte_802673A
off_80267F4:
	.word byte_8026730
off_80267F8:
	.word byte_802673C
off_80267FC:
	.word byte_8026753
off_8026800:
	.word byte_802675A
off_8026804:
	.word byte_8026761
off_8026808:
	.word byte_802676E
off_802680C:
	.word byte_8026781
off_8026810:
	.word byte_802678E
off_8026814:
	.word byte_8026791
off_8026818:
	.word byte_8026794
off_802681C:
	.word byte_802679B
off_8026820:
	.word byte_80267A6
off_8026824:
	.word byte_80267AB
off_8026828:
	.word byte_80267AE
off_802682C:
	.word byte_802679B
off_8026830:
	.word byte_80267B9
off_8026834:
	.word byte_8026791
off_8026838:
	.word byte_80267CC
off_802683C:
	.word byte_80267D5
	thumb_func_end sub_8026726

// symdb: One-time-per-run init of the battle custom (chip-select) screen: resets battle state words, loads the chip-select tilemap/OBJ graphics, initialises the eS20364C0 state (NaviIndex, folder chip count, selectable PET-Navi candidates) and advances the battle phase counter.
// symdb: void battle_initCustomScreen(void) : r10 (toolkit) -> [r2 r3 r4 r5 r6 r8 r9] (callee-saved
// symdb: restored)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_initCustomScreen_8026840.yaml
	thumb_func_start battle_initCustomScreen_8026840
battle_initCustomScreen_8026840:
	push {r4-r7,lr}
	mov r2, r10
	ldr r2, [r2,#oToolkit_BattleStatePtr]
	ldrb r0, [r2,#oBattleState_Unk_07]
	cmp r0, #0
	bne loc_8026858
	// memBlock
	ldr r0, off_80269CC // =dword_20349A0 
	// size
	mov r1, #0x14
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	bl battle_setUnk20349A5Flag_802A210
loc_8026858:
	bl ClearCustGauge
	ldr r0, dword_8026994 // =0x30172 
	bl dispatch_801DACC // (a0: flags32) -> ()
	ldr r0, off_8026998 // =0x400 
	bl dispatch_801DACC // (a0: flags32) -> ()
	ldr r0, dword_802699C // =0x20130 
	bl flags_clearBits_eStruct2035280_801BED6
	mov r4, #0
	ldr r5, off_8026BF0 // =eS20364C0 
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte
	cmp r0, #0
	bne loc_8026898
	bl sub_8029F70
	tst r0, r0
	beq loc_8026898
	bl battle_getActorEmotion_802A564
	cmp r0, #5
	beq loc_8026898
	bl countUnmaskedEventFlags_8029EC8
	mov r4, r0
loc_8026898:
	ldr r0, off_80269A0 // =byte_86E625C 
	tst r4, r4
	beq loc_80268A0
	ldr r0, off_80269A4 // =byte_86E64B4 
loc_80268A0:
	ldr r1, off_80269C8 // =unk_2035000 
	ldr r2, off_80269A8 // =0x258 
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	mov r2, #0x9b
	ldr r6, off_80269AC // =byte_8027B2C 
loc_80268AC:
	ldr r0, dword_80269B0 // =0xfff 
	and r0, r2
	ldrb r2, [r6,#4]
	lsl r2, r2, #0xc
	orr r2, r0
	ldrb r0, [r6]
	ldrb r1, [r6,#1]
	ldrb r3, [r6,#2]
	ldrb r4, [r6,#3]
	ldrb r5, [r6,#5]
	bl sub_8027CCC
	add r6, #6
	ldrb r0, [r6]
	cmp r0, #0xff
	bne loc_80268AC
	// memBlock
	ldr r0, off_8026BF0 // =eS20364C0 
	// size
	mov r1, #0x70 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	ldr r5, off_8026BF0 // =eS20364C0 
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte
	strb r0, [r5,#0x10]
	strb r0, [r5,#0x11]
	strb r0, [r5,#0x15]
	mov r0, #0
	strh r0, [r5,#0x3a]
	strh r0, [r5,#0x38]
	ldr r5, off_8026BF0 // =eS20364C0 
	mov r1, #1
	strb r1, [r5,#0x4]
	mov r0, #0xff
	strb r0, [r5,#0xc]
	bl sub_8029F70
	tst r0, r0
	beq loc_802690E
	bl battle_getActorEmotion_802A564
	cmp r0, #5
	beq loc_802690E
	bl sub_8029EF8
	strb r0, [r5,#0x18]
loc_802690E:
	bl gfx_flushDataListAndContinue_802811C
	mov r0, #0x1a
	strb r0, [r5,#0x9]
	mov r0, #0
	sub r0, #1
	strh r0, [r5,#0x20] // (word_20364E0 - 0x20364c0)
	mov r2, r10
	ldr r2, [r2,#oToolkit_BattleStatePtr]
	ldrb r0, [r2,#oBattleState_Unk_07]
	add r1, r0, #1
	strb r1, [r2,#oBattleState_Unk_07]
	cmp r0, #0
	bne loc_8026936
	bl GetBattleMode
	ldr r1, off_80269B8 // =byte_80269BC
	ldrb r0, [r1,r0]
	strb r0, [r5,#0xc] // (byte_20364CC - 0x20364c0)
	b loc_802694C
loc_8026936:
	bl GetBattleMode
	mov r1, #5
	cmp r0, r1
	bne loc_802694C
	bl battle_getActorEmotion_802A564
	tst r3, r3
	bne loc_802694C
	mov r0, #5
	strb r0, [r5,#0xc] // (byte_20364CC - 0x20364c0)
loc_802694C:
	bl tickBeastOutCounter_802A49C
	bl battle_updateBeastOutCounter_802A40C
	bl battle_compactFolderChipList_802945A
	bl expireBattleFlag_802A646
	bl battle_countFolderChips_8027D58
	strb r0, [r5,#0x5] // (dword_20364C4+1 - 0x20364c0)
	bl sub_8027E2C
	mov r0, #1
	bl sub_8028250
	mov r1, #4
loc_802696E:
	ldr r0, dword_80269B4 // =0x1ff 
	push {r1}
	bl sprite_CopyObjTilesToVramSlot_80281D4
	ldr r0, [sp]
	mov r1, #0
	mov r2, #1
	bl sub_8029CD4
	pop {r1}
	sub r1, #1
	bpl loc_802696E
	bl sub_8028476
	bl sub_8015940
	bl battle_ClearPendingEventFlag_802A0EC
	pop {r4-r7,pc}
	.balign 4, 0
dword_8026994:
	.word 0x30172
off_8026998:
	.word 0x400
dword_802699C:
	.word 0x20130
off_80269A0:
	.word byte_86E625C
off_80269A4:
	.word byte_86E64B4
off_80269A8:
	.word 0x258
off_80269AC:
	.word byte_8027B2C
dword_80269B0:
	.word 0xFFF
dword_80269B4:
	.word 0x1FF
off_80269B8:
	.word byte_80269BC
byte_80269BC:
	.byte 0xFF, 0xFF, 0x0, 0x1, 0x2, 0x3, 0xFF, 0xFF, 0x6, 0xFF, 0xFF
	.byte 0xFF
off_80269C8:
	.word unk_2035000
off_80269CC:
	.word dword_20349A0
	thumb_func_end battle_initCustomScreen_8026840

// symdb: Queries some global status via sub_800A9E2 with argument 0 and reduces the result to a boolean that is true when bits 0 or 2 are set.
// symdb: int checkStatusBits0Or2(void); returns 1 if (statusValue & 0x5) != 0 else 0; carry and overflow
// symdb: flags from the inner call pass through to the caller
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_80269D0.yaml
	thumb_local_start
sub_80269D0:
	push {lr}
	mov r0, #0
	bl battle_GetObjectByteAt14_800A9E2
	mov r1, #5
	and r0, r1
	beq locret_80269E0
	mov r0, #1
locret_80269E0:
	pop {pc}
	thumb_func_end sub_80269D0

// symdb: Tests two status bytes at RAM eS20364C0 against a set of "blocking" values and returns 1 if either matches, 0 otherwise (preserving the final CMP flags).
// symdb: void sub_80269E2(void); /* in: lr; out: r0 (0 or 1); clobbers nz c v r1; preserves r5 */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_80269E2.yaml
	thumb_local_start
sub_80269E2:
	push {r5,lr}
	mov r0, #0
	ldr r5, off_8026BF0 // =eS20364C0 
	ldrb r1, [r5]
	cmp r1, #0
	beq loc_8026A24
	cmp r1, #8
	beq loc_8026A24
	ldrb r1, [r5,#0x1] // (eS20364C0+1 - 0x20364c0)
	cmp r1, #0
	beq loc_8026A24
	cmp r1, #8
	beq loc_8026A24
	cmp r1, #4
	beq loc_8026A24
	cmp r1, #0xc
	beq loc_8026A24
	cmp r1, #0x2c 
	beq loc_8026A24
	cmp r1, #0x30 
	beq loc_8026A24
	cmp r1, #0x34 
	beq loc_8026A24
	cmp r1, #0x10
	beq loc_8026A24
	cmp r1, #0x14
	beq loc_8026A24
	cmp r1, #0x18
	beq loc_8026A24
	cmp r1, #0x1c
	beq loc_8026A24
	cmp r1, #0x20 
	bne locret_8026A26
loc_8026A24:
	mov r0, #1
locret_8026A26:
	pop {r5,pc}
	thumb_func_end sub_80269E2

// symdb: Dispatches one tick of the eS20364C0 state machine via its jump table
// symdb: void sub_8026A28(void); /* uses r5 for the state object; passes state byte in r0 and jump-table
// symdb: entry in r1 to the handler; whatever r0,r2-r4,r6,r8-r12 the handler returns is returned to the
// symdb: caller; r5 is preserved; clobbers r1,r7,lr and flags nzcv */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8026A28.yaml
	thumb_func_start sub_8026A28
sub_8026A28:
	push {r5,lr}
	ldr r5, off_8026BF0 // =eS20364C0 
	ldr r1, off_8026A38 // =off_8026A3C 

	ldrb r0, [r5, #oS20364C0_JumpOffset00]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1

	pop {r5,pc}
	.balign 4, 0
off_8026A38:
	.word off_8026A3C
off_8026A3C:
	.word sub_8026A50+1 // (self: * S20364C0 $r5) -> u8
	.word custMenuMainMaybe_8026A88+1 // (self: * S20364C0 $r5) -> u8
	.word object_runFrameUpdate_8026A6C+1 // (self: * S20364C0 $r5) -> u8
	.word 0x100
	.word eStruct200F360
	thumb_func_end sub_8026A28

// symdb: Queries some value via sub_802FE48, stores it on the object, starts sub_802FE7A with (0,0x40,0x40,value), then moves the object to state 4 and returns 0.
// symdb: u8 sub_8026A50(S20364C0* self /* r5 */); /* returns 0 in r0, sets Z=1 N=0, clobbers r1-r3 */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8026A50.yaml
	thumb_local_start
sub_8026A50: // (self: * S20364C0 $r5) -> u8
	push {lr}
	bl sub_802FE48
	strb r0, [r5,#oS20364C0_Unk_0e]
	mov r3, r0
	mov r1, #0x40 
	mov r2, #0x40 
	mov r0, #0
	bl sub_802FE7A
	mov r0, #4
	str r0, [r5]
	mov r0, #0
	pop {pc}
	thumb_func_end sub_8026A50

// symdb: Runs an object's standard per-frame update sequence and returns its state byte.
// symdb: u8 object_runFrameUpdate(Object* self /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_runFrameUpdate_8026A6C.yaml
	thumb_local_start
object_runFrameUpdate_8026A6C: // (self: * S20364C0 $r5) -> u8
	push {lr}
	bl battle_customGauge_EndTurn_8027D78
	ldrb r0, [r5,#0xe]
	bl flags_clearFlagWordBit_802FE6A
	bl sub_80062EC
	bl sound_playCrossTransformationJingle_802A3CC // () -> ()
	bl battle_DispatchPendingEvent_802A0F8
	ldrb r0, [r5,#4]
	pop {pc}
	thumb_func_end object_runFrameUpdate_8026A6C

// symdb: One-frame step of the custom-menu state machine: dispatches the handler for the current state, then runs the shared per-frame update.
// symdb: void custMenuStep_8026A88(void) /* out: r0 = 0 (Z set, N clear); r5 preserved; other regs per
// symdb: callees */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/custMenuMainMaybe_8026A88.yaml
	thumb_local_start
custMenuMainMaybe_8026A88: // (self: * S20364C0 $r5) -> u8
	push {r5,lr}
	ldr r5, off_8026BF0 // =eS20364C0 
	ldr r1, off_8026AA0 // =off_8026AA4 

	ldrb r0, [r5,#oS20364C0_JumpOffset01]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1

	bl sub_802A2B0 // (self: * S20364C0 $r5) -> ()

	mov r0, #0
	pop {r5,pc}
	.balign 4, 0
off_8026AA0:
	.word off_8026AA4
off_8026AA4:
	// 0x00
	.word sub_8026B04+1 // (self: * S20364C0 $r5) -> ()
	// 0x04
	.word custMenuUpdateWaitSelectionState_8026CCC+1 // (self: * S20364C0 $r5) -> ()
	// 0x08
	.word scrollStrip_update_8026BF4+1 // (self: * S20364C0 $r5) -> ()
	// 0x0C
	.word sub_8026D06+1 // (self: * S20364C0 $r5) -> ()
	// 0x10
	.word sub_8026DB0+1 // (self: * S20364C0 $r5) -> ()
	// 0x14
	.word battle_endChipSelectionBeginTurn_8026DC4+1 // (self: * S20364C0 $r5) -> ()
	// 0x18
	.word chatbox_stateMaybeFinishText_8026E4C+1 // (self: * S20364C0 $r5) -> ()
	// 0x1C
	.word battle_updateObjectByKind_8026E98+1 // (self: * S20364C0 $r5) -> ()
	// 0x20
	.word battle_runTutorialDialog_8026FC0+1 // (self: * S20364C0 $r5) -> ()
	// 0x24
	.word sub_8027044+1 // (self: * S20364C0 $r5) -> ()
	// 0x28
	.word sub_80271F8+1 // (self: * S20364C0 $r5) -> ()
	// 0x2C
	.word sub_802728C+1 // (self: * S20364C0 $r5) -> ()
	// 0x30
	.word sub_80273A4+1 // (self: * S20364C0 $r5) -> ()
	// 0x34
	.word chatbox_resetTextStateIfHidden_80273EC+1 // (self: * S20364C0 $r5) -> ()
	// 0x38
	.word sub_8027406+1 // (self: * S20364C0 $r5) -> ()
	// 0x3C
	.word sub_802753E+1 // (self: * S20364C0 $r5) -> ()
	// 0x40
	.word sub_8027548+1 // (self: * S20364C0 $r5) -> ()
	// 0x44
	.word sub_80275EC+1 // (self: * S20364C0 $r5) -> ()
	// 0x48
	.word sub_802770C+1 // (self: * S20364C0 $r5) -> ()
	// 0x4C
	.word sub_8027834+1 // (self: * S20364C0 $r5) -> ()
	// 0x50
	.word sub_802790C+1 // (self: * S20364C0 $r5) -> ()
	// 0x54
	.word sub_802794A+1 // (self: * S20364C0 $r5) -> ()
	// 0x58
	.word sub_8026E78+1 // (self: * S20364C0 $r5) -> ()
	// 0x5C
	.word sub_8027A58+1 // (self: * S20364C0 $r5) -> ()
	thumb_func_end custMenuMainMaybe_8026A88

// symdb: Drives the tile-animation/wipe state of a battle custom-menu object, scrolling tiles and the camera, then transitions to either the wait-selection or trigger-selection phase.
// symdb: void sub_8026B04(u32 self /* r5 */, u32 toolkit /* r10 */, u32 r4, u32 r6 /* forwarded into
// symdb: sub_8029C08 */); clobbers r0 r1 r2 r3 r8 r9 r11 r12 lr, flags
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8026B04.yaml
	thumb_local_start
sub_8026B04: // (self: * S20364C0 $r5) -> ()
	push {lr}

	ldrb r0, [r5,#oS20364C0_Unk_02]
	cmp r0, #0
	bne loc_8026B38

	mov r0, #SOUND_SELECT_79
	bl PlaySoundEffect

	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]

	mov r0, #0x78 
	strh r0, [r1,#0x18]

	mov r0, #0
	bl sub_801E71C

	mov r0, #0x80
	bl dispatch_801DACC // (a0: flags32) -> ()

	mov r0, #0xf
	mov r1, #0
	bl sub_801E0A0

	mov r0, #0xf
	str r0, [r5,#0x44]
	mov r0, #0x78 
	str r0, [r5,#0x40]

	strb r0, [r5,#oS20364C0_Unk_02]
loc_8026B38:
	ldr r0, [r5,#0x40]
	sub r0, #0xc
	push {r0,r4,r6,r7}
	mov r6, #4
	and r6, r0
	lsr r6, r6, #2
	add r6, #1
loc_8026B46:
	ldr r0, [r5,#0x44]
	sub r0, #1
	str r0, [r5,#0x44]
	ldr r4, off_8026DAC // =unk_2035000 
	lsl r0, r0, #1
	add r4, r4, r0
	lsr r0, r0, #1
	mov r1, #0
	mov r2, #3
	mov r7, #0x14
loc_8026B5A:
	push {r0,r1}
	ldrh r3, [r4]
	mov r2, #3
	bl bgmap_WriteTileIdAtBlock_800187C
	pop {r0,r1}
	add r1, #1
	add r4, #0x1e
	sub r7, #1
	bne loc_8026B5A
	sub r6, #1
	bne loc_8026B46
	pop {r0,r4,r6,r7}

	push {r0}
	bl GetBattleMode
	cmp r0, #1
	pop {r0}
	beq loc_8026B8C

	mov r2, r10
	ldr r2, [r2,#oToolkit_CameraPtr]
	ldr r1, [r2,#0x34]
	ldr r3, dword_8026CC8 // =0x18000 
	sub r1, r1, r3
	str r1, [r2,#0x34]
loc_8026B8C:
	str r0, [r5,#0x40]
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r0, [r1,#0x18]
	push {r0}
	mov r1, r0
	mov r0, #0x78 
	sub r0, r0, r1
	bl sub_801E71C
	pop {r0}
	cmp r0, #0
	bne loc_8026BE8

	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_07]
	cmp r0, #1
	bne loc_8026BB6

	bl RetrieveAndRenderEnemyVirusNamesInBattle_801E574 // () -> ()

	b loc_8026BC2
loc_8026BB6:
	mov r0, #0
	bl battle_damagePlayerLeave1HP_8013FD0
	mov r0, #1
	bl battle_damagePlayerLeave1HP_8013FD0
loc_8026BC2:
	ldrb r0, [r5,#oS20364C0_Unk_0c]
	cmp r0, #0xff
	beq loc_8026BE0
	cmp r0, #5
	bne loc_8026BD6
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#7]
	cmp r0, #5
	bge loc_8026BE0
loc_8026BD6:

	// 0x00: trigger sub_802728C via custMenuMainMaybe_8026A88
	mov r0, #0x2c 
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]

	b loc_8026BE8
loc_8026BE0:

	// 0x00: trigger custMenuUpdateWaitSelectionState_8026CCC via custMenuMainMaybe_8026A88
	mov r0, #4
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]

loc_8026BE8:
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	pop {pc}
	.balign 4, 0
off_8026BF0:
	.word eS20364C0
	thumb_func_end sub_8026B04

// symdb: Per-frame scroll-strip update — init gate, copy zero-tile columns, advance scroll, shift camera, and notify the scroll subsystem.
// symdb: void sub_8026BF4(struct S20364C0 *self /* r5 */, struct Toolkit *toolkit /* r10 */); /* clobbers
// symdb: r0-r3,r6-r9,r11-r12,nzcv; preserves r5-r7 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/scrollStrip_update_8026BF4.yaml
	thumb_local_start
scrollStrip_update_8026BF4: // (self: * S20364C0 $r5) -> ()
	push {lr}

	ldrb r0, [r5,#oS20364C0_Unk_02]
	cmp r0, #FALSE
	bne loc_8026C14

	// set to NULL
	str r0, [r5,#oS20364C0_Extra_Unk_44]
	str r0, [r5,#oS20364C0_Extra_Unk_40]

	mov r0, #TRUE
	strb r0, [r5,#oS20364C0_Unk_02]

	ldr r0, off_8026CC4 // =0x2000 
	bl dispatch_801DACC // (a0: flags32) -> ()

	bl sub_8029D80

	mov r0, #BATTLE_STATE_UNK_11_FLAG_UNK_BIT_02
	bl clearBattleStateUnk11Flag_800A9D6 // (flags: flags8) -> ()

loc_8026C14: // endif

	ldr r0, [r5,#oS20364C0_Extra_Unk_40]
	add r0, #0xc
	push {r0,r4-r7}
	mov r7, r5
	mov r6, #4
	and r6, r0
	lsr r6, r6, #2
	mov r0, #1
	eor r6, r0
	add r6, #1

loop_8026C28:
	ldr r0, [r7,#0x44]
	add r0, #1
	str r0, [r7,#0x44]
	// j
	sub r0, #1
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_8026C84 // =byte_8026C88
	mov r4, #1
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()

	sub r6, #1
	bne loop_8026C28

	pop {r0,r4-r7}

	push {r0}
	bl GetBattleMode
	cmp r0, #1
	pop {r0}
	beq loc_8026C5C

	mov r2, r10
	ldr r2, [r2,#oToolkit_CameraPtr]
	ldr r1, [r2,#0x34]
	ldr r3, dword_8026CC8 // =0x18000 
	add r1, r1, r3
	str r1, [r2,#0x34]

loc_8026C5C: // endif

	str r0, [r5,#0x40]
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r0, [r1,#0x18]

	push {r0}
	mov r1, r0
	mov r0, #0x78 
	sub r0, r0, r1
	bl sub_801E71C
	pop {r0}
	cmp r0, #0x78 
	bne loc_8026C7E

	ldrb r0, [r5,#0xb]
	strb r0, [r5,#1]
	mov r0, #0
	strb r0, [r5,#2]

loc_8026C7E: // endif

	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	pop {pc}
	.balign 4, 0
off_8026C84:
	.word byte_8026C88
byte_8026C88:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
off_8026CC4:
	.word 0x2000
dword_8026CC8:
	.word 0x18000
	thumb_func_end scrollStrip_update_8026BF4

// symdb: Per-frame update for a custom-menu object while the player hasn't confirmed a selection yet; once a selection is made it latches the result and switches the object to its next state handler.
// symdb: void custMenuUpdateWaitSelectionState_8026CCC(S20364C0 *self /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/custMenuUpdateWaitSelectionState_8026CCC.yaml
	thumb_local_start
custMenuUpdateWaitSelectionState_8026CCC: // (self: * S20364C0 $r5) -> ()
	push {r7,lr}

	bl sub_802A220
	cmp r0, #0xff
	beq loc_8026CE6

	strh r0, [r5,#oS20364C0_Unk_38]

	// 0x04: trigger sub_8027548 via custMenuMainMaybe_8026A88
	mov r0, #0x40 
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strb r0, [r5,#oS20364C0_Unk_02]

	mov r0, #0
	str r0, [r5,#0x40]

	b locret_8026D04
loc_8026CE6:
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	bl custMenuSomeHandler_8028B74 // (self: * S20364C0 $r5) -> ()
	bl sub_8028820
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	bl sub_802899C
	bl battle_endingBgUpdate_8029D34
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
locret_8026D04:
	pop {r7,pc}
	thumb_func_end custMenuUpdateWaitSelectionState_8026CCC

	thumb_local_start
sub_8026D06: // (self: * S20364C0 $r5) -> ()
	push {r4,r5,lr}
	mov r3, r10
	ldr r3, [r3,#oToolkit_RenderInfoPtr]
	ldrb r0, [r5,#2]
	cmp r0, #2
	beq loc_8026D9A
	cmp r0, #0
	bne loc_8026D46
	mov r0, #1
	strb r0, [r5,#2]
	mov r0, #0x78 
	strh r0, [r3,#0x18]
	mov r0, #0
	bl sub_801E71C
	ldr r0, off_8026DA8 // =0x2000 
	bl dispatch_801DACC // (a0: flags32) -> ()
	bl sub_8029D80
	mov r0, #0
	mov r1, #0
	mov r2, #3
	mov r3, #0
	mov r4, #0xf
	mov r5, #0x14
	bl call_sub_3005EBA
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	b locret_8026DA6
loc_8026D46:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_Pressed]
	cmp r0, #0
	bne loc_8026D5C
	push {r3}
	bl sub_802A220
	pop {r3}
	cmp r0, #0xff
	beq locret_8026DA6
loc_8026D5C:
	mov r0, #2
	strb r0, [r5,#2]
	mov r0, #0
	strh r0, [r3,#0x18]
	mov r0, #0x78 
	bl sub_801E71C
	push {r4,r5}
	// j
	mov r0, #0
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_8026DAC // =unk_2035000 
	mov r4, #0xf
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4,r5}
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#7]
	cmp r0, #1
	bne locret_8026DA6
	ldr r0, off_8026DA8 // =0x2000 
	bl dispatch_801DA48
	b locret_8026DA6
loc_8026D9A:
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_8026DA6:
	pop {r4,r5,pc}
	.balign 4, 0
off_8026DA8:
	.word 0x2000
off_8026DAC:
	.word unk_2035000
	thumb_func_end sub_8026D06

	thumb_local_start
sub_8026DB0: // (self: * S20364C0 $r5) -> ()
	push {lr}
	bl sub_802B734
	cmp r0, #0
	beq locret_8026DC2
	mov r0, #0x14
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_8026DC2:
	pop {pc}
	thumb_func_end sub_8026DB0

// symdb: Turn-transition handler of the chip-selection state machine (S20364C0): runs the once-per-turn custom-gauge teardown + folder tally + restart snapshot, transfers the hand on the first turn, then requests the next state.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_endChipSelectionBeginTurn_8026DC4.yaml
	thumb_local_start
battle_endChipSelectionBeginTurn_8026DC4: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldrb r0, [r5,#2]
	cmp r0, #0
	bne loc_8026DEC
	bl battle_customGauge_EndTurn_8027D78
	mov r0, #1
	strb r0, [r5,#2]
	bl folder_tallyChipsByClass_802A4FC
	bl battle_backupStateForRestart_800B3A2
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_8026DEC
	mov r0, #0
	bl sub_801E474
loc_8026DEC:
	ldr r0, dword_8026E44 // =0x56789123 
	bl battle_doBothTrackedIdsMatch_800B46C
	tst r0, r0
	beq locret_8026E40
	bl sub_800B460
	bl transferBattleHandNaviStats_800B3D8
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_8026E14
	ldr r0, off_8026E48 // =0x1000 
	bl flags_clearBits_eStruct2035280_801BED6
	ldr r0, off_8026E48 // =0x1000 
	bl dispatch_801DACC // (a0: flags32) -> ()
loc_8026E14:
	mov r0, #2
	bl dispatch_801DA48
	mov r0, #2
	bl eStruct2035280_SetRequestBits_801BECC
	ldrb r0, [r5,#0xc]
	cmp r0, #0xff
	beq loc_8026E3C
	cmp r0, #3
	beq loc_8026E3C
	cmp r0, #4
	beq loc_8026E3C
	cmp r0, #5
	beq loc_8026E3C
	mov r0, #0x30 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b locret_8026E40
loc_8026E3C:
	mov r0, #8
	strb r0, [r5]
locret_8026E40:
	pop {pc}
	.balign 4, 0
dword_8026E44:
	.word 0x56789123
off_8026E48:
	.word 0x1000
	thumb_func_end battle_endChipSelectionBeginTurn_8026DC4

// symdb: Chatbox state-machine step that waits for text printing to finish, then plays a sound effect and moves the chatbox to state 4.
// symdb: void sub_8026E4C(ChatboxState *self /* r5: struct S20364C0 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chatbox_stateMaybeFinishText_8026E4C.yaml
	thumb_local_start
chatbox_stateMaybeFinishText_8026E4C: // (self: * S20364C0 $r5) -> ()
	push {lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	cmp r0, #0
	beq loc_8026E64
	bl sub_802A220
	cmp r0, #0xff
	beq loc_8026E72
	bl chatbox_8040818
loc_8026E64:
	mov r0, #0x9e
	bl PlaySoundEffect
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
loc_8026E72:
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	pop {pc}
	thumb_func_end chatbox_stateMaybeFinishText_8026E4C

	thumb_local_start
sub_8026E78: // (self: * S20364C0 $r5) -> ()
	push {lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	cmp r0, #0
	bne loc_8026E92
	mov r0, #0x9e
	bl PlaySoundEffect
	mov r0, #0x54 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
loc_8026E92:
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	pop {pc}
	thumb_func_end sub_8026E78

// symdb: Runs one update step for a battle object, dispatching to the handler matching the object's kind byte and passing in a battle-effect flag.
// symdb: void battle_updateObjectByKind_8026E98(S20364C0 *self /* in R5 */); also reads
// symdb: GetBattleEffects() and clobbers/sets NZ from the effect check
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_updateObjectByKind_8026E98.yaml
	thumb_local_start
battle_updateObjectByKind_8026E98: // (self: * S20364C0 $r5) -> ()
	push {r4,lr}
	mov r4, #0
	bl GetBattleEffects // () -> int
	ldr r1, dword_8027040 // =0x200000 
	tst r0, r1
	beq loc_8026EA8
	mov r4, #4
loc_8026EA8:
	ldr r1, off_8026EB8 // =off_8026EBC 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	pop {r4,pc}
	.balign 4, 0
off_8026EB8:
	.word off_8026EBC
off_8026EBC:
	.word runBattleDialog_8026EC8+1
	.word sub_8026F1A+1
	.word sub_8026FAA+1
	thumb_func_end battle_updateObjectByKind_8026E98

// symdb: Picks and runs the battle tutorial / battle-run text script and plays the unselect jingle.
// symdb: void sub_8026EC8(u32 base_r4 /* r4 */, u32 state_ptr /* r5 */); // out: r2 r3 r5 r6 r10;
// symdb: clobbers nzcv r0 r1 lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/runBattleDialog_8026EC8.yaml
	thumb_local_start
runBattleDialog_8026EC8:
	push {lr}
	bl GetBattleEffects // () -> int
	mov r1, #0x20 
	tst r0, r1
	bne loc_8026F04
	mov r0, #8
	strh r0, [r5,#2]
	bl GetBattleMode
	cmp r0, #5
	bne loc_8026EEA
	ldr r0, off_802702C // =TextScriptFirstBattleTutorials
	mov r1, #0xc // (TextScriptPtrArr8027BDC - 0x8027bd0)
	ldr r0, [r0,r1]
	mov r1, #0x23 
	b loc_8026F0E
loc_8026EEA:
	ldrb r0, [r5,#0xc]
	cmp r0, #0xff
	beq loc_8026EFE
	ldr r0, off_802702C // =TextScriptFirstBattleTutorials
	ldrb r1, [r5,#0xc]
	lsl r2, r1, #2
	ldr r0, [r0,r2]
	ldr r2, off_8027030 // =byte_8027034
	ldrb r1, [r2,r1]
	b loc_8026F0E
loc_8026EFE:
	mov r1, #3
	add r1, r1, r4
	b loc_8026F0C
loc_8026F04:
	mov r0, #4
	strh r0, [r5,#2]
	mov r1, #0
	add r1, r1, r4
loc_8026F0C:
	ldr r0, off_8027008 // =TextScriptBattleRunDialog
loc_8026F0E:
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	mov r0, #SOUND_UNSELECT_7B
	bl PlaySoundEffect
	pop {pc}
	thumb_func_end runBattleDialog_8026EC8

// symdb: Run-away (L button) attempt: t = (NaviStats+0x3E + 4) / 5 vs BattleSettings.Unk_01; if not an auto-win, a threshold byte from off_8027014 indexed by the attempt counter dword_20349A8 decides via one GetRNGSecondary ((r & 0xF) < threshold); writes the outcome (2 escaped) to S20364C0+4.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8026F1A.yaml
	thumb_local_start
sub_8026F1A:
	push {r4,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	cmp r0, #0
	beq loc_8026F34
	bl sub_802A220
	cmp r0, #0xff
	beq locret_8026FA8
	bl chatbox_8040818
	b loc_8026FA0
loc_8026F34:
	bl chatbox_GetState_8045F4C
	cmp r0, #1
	beq loc_8026FA0
	mov r0, #0xff
	ldr r1, off_802700C // =byte_20366C0 
	strb r0, [r1]
	bl GetBattleSettingsUnk01
	mov r4, r0
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#0xd]
	mov r1, #0x3e 
	bl GetBattleNaviStatsHword
	add r0, #4
	mov r1, #5
	svc 6
	cmp r0, r4
	bgt loc_8026F8E
	mov r3, #8
	lsr r2, r0, #1
	add r0, r0, r2
	cmp r4, r0
	blt loc_8026F72
	sub r3, #4
	add r0, r0, r2
	cmp r4, r0
	blt loc_8026F72
	sub r3, #4
loc_8026F72:
	ldr r2, off_8027010 // =off_8027014 
	ldr r3, [r2,r3]
	ldr r1, off_802703C // =dword_20349A0 
	ldr r0, [r1,#0x8] // (dword_20349A8 - 0x20349a0)
	add r2, r0, #1
	str r2, [r1,#0x8] // (dword_20349A8 - 0x20349a0)
	ldrb r4, [r3,r0]
	bl GetRNGSecondary // () -> void
	mov r1, #1
	mov r2, #0xf
	and r0, r2
	cmp r0, r4
	bge loc_8026F92
loc_8026F8E:
	mov r0, #2
	strb r0, [r5,#4]
loc_8026F92:
	mov r0, #0x20 
	strb r0, [r5,#0xb]
	mov r0, #8
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b locret_8026FA8
loc_8026FA0:
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_8026FA8:
	pop {r4,pc}
	thumb_func_end sub_8026F1A

	thumb_local_start
sub_8026FAA:
	push {lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	cmp r0, #0
	bne locret_8026FBE
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_8026FBE:
	pop {pc}
	thumb_func_end sub_8026FAA

// symdb: Drives the "battle is about to run away" tutorial dialog: on first entry it fires the tutorial script (paged 1 or 2 + offset from battle effects) and marks the tutorial seen; on later entries it waits for chatbox flag 0x80 to clear, then arms a 0x14-timer and clears state.
// symdb: void battle_runTutorialDialog_8026FC0(struct S20364C0 *self /* r5 */); // outputs:
// symdb: r2/r3/r4/r5/r6 (scratch); clobbers NZ/C/V, r0, r1, lr; preserves r4-r7 in this function
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_runTutorialDialog_8026FC0.yaml
	thumb_local_start
battle_runTutorialDialog_8026FC0: // (self: * S20364C0 $r5) -> ()
	push {r4,lr}
	mov r4, #0
	bl GetBattleEffects // () -> int
	ldr r1, dword_8027040 // =0x200000 
	tst r0, r1
	beq loc_8026FD0
	mov r4, #4
loc_8026FD0:
	ldrb r0, [r5,#2]
	cmp r0, #0
	bne loc_8026FF2
	mov r0, #1
	strb r0, [r5,#2]
	bl battle_ClearPendingEventFlag_802A0EC
	mov r1, #1
	ldrb r0, [r5,#4]
	cmp r0, #2
	beq loc_8026FE8
	mov r1, #2
loc_8026FE8:
	add r1, r1, r4
	ldr r0, off_8027008 // =TextScriptBattleRunDialog
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	b locret_8027004
loc_8026FF2:
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	cmp r0, #0
	bne locret_8027004
	mov r0, #0x14
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_8027004:
	pop {r4,pc}
	.balign 4, 0
off_8027008:
	.word TextScriptBattleRunDialog
off_802700C:
	.word byte_20366C0
off_8027010:
	.word off_8027014
// symdb: Run-away threshold rows for sub_8026F1A: { 4, 8, 15 }, { 8, 12, 15 }, { 12, 14, 15 }; the row is picked by how the battle's busting level compares to the escape stat, the byte index is the attempt counter dword_20349A8.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/off_8027014.yaml
off_8027014:
	.word byte_8027020
	.word byte_8027023
	.word byte_8027026
byte_8027020:
	.byte 0x4, 0x8, 0xF
byte_8027023:
	.byte 0x8, 0xC, 0xF
byte_8027026:
	.byte 0xC, 0xE, 0xF, 0x0, 0x0, 0x0
off_802702C:
	.word TextScriptFirstBattleTutorials
off_8027030:
	.word byte_8027034
byte_8027034:
	.byte 0xD, 0xE, 0xC, 0x23, 0x23, 0x23, 0x6, 0x0
off_802703C:
	.word dword_20349A0
dword_8027040:
	.word 0x200000
	thumb_func_end battle_runTutorialDialog_8026FC0

	thumb_local_start
sub_8027044: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldr r1, off_802705C // =off_8027060 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	bl sub_802899C
	pop {pc}
	.balign 4, 0
off_802705C:
	.word off_8027060
off_8027060:
	.word sub_802707C+1
	.word sub_80270D0+1
	.word sub_80270EA+1
	.word sub_8027118+1
	.word sub_8027134+1
	.word sub_8027150+1
	.word sub_80271C2+1
	thumb_func_end sub_8027044

	thumb_local_start
sub_802707C:
	push {r4,lr}
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #0xb
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r4, r0
	ldrb r0, [r4,#6]
	cmp r0, #0
	beq loc_8027094
	mov r0, #0xd
	b loc_8027096
loc_8027094:
	ldrb r0, [r4,#5]
loc_8027096:
	mov r1, #0x80
	mul r0, r1
	ldr r1, off_80270CC // =byte_8725894 
	add r0, r0, r1
	ldr r1, dword_80270C0 // =0x60172c0 
	mov r2, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldrb r0, [r5,#8]
	mov r1, #0x10
	mul r0, r1
	add r0, #0x18
	str r0, [r5,#0x44]
	ldr r0, off_80270C4 // =byte_872CF94 
	ldr r1, off_80270C8 // =byte_30016F0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #4
	strh r0, [r5,#2]
	pop {r4,pc}
	.balign 4, 0
dword_80270C0:
	.word 0x60172C0
off_80270C4:
	.word byte_872CF94
off_80270C8:
	.word byte_30016F0
off_80270CC:
	.word byte_8725894
	thumb_func_end sub_802707C

	thumb_local_start
sub_80270D0:
	push {lr}
	bl sub_80298D8
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	cmp r0, #0x10
	blt locret_80270E8
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #8
	strh r0, [r5,#2]
locret_80270E8:
	pop {pc}
	thumb_func_end sub_80270D0

	thumb_local_start
sub_80270EA:
	push {lr}
	ldr r0, [r5,#0x44]
	sub r0, #2
	str r0, [r5,#0x44]
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	cmp r0, #8
	blt loc_8027112
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #0x34 
	mov r1, #0x20 
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x91
	bl PlaySoundEffect
	mov r0, #0xc
	strh r0, [r5,#2]
loc_8027112:
	bl sub_80298D8
	pop {pc}
	thumb_func_end sub_80270EA

	thumb_local_start
sub_8027118:
	push {lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne loc_802712E
	mov r0, #0x10
	strh r0, [r5,#2]
	mov r0, #0x30 
	mov r1, #0x20 
	bl SetScreenFade // (int a1, int a2) -> void
loc_802712E:
	bl sub_80298D8
	pop {pc}
	thumb_func_end sub_8027118

	thumb_local_start
sub_8027134:
	push {lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne loc_802714A
	mov r0, #4
	mov r1, #0x20 
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x14
	strh r0, [r5,#2]
loc_802714A:
	bl sub_80298D8
	pop {pc}
	thumb_func_end sub_8027134

	thumb_local_start
sub_8027150:
	push {r4,lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne loc_80271BC
	ldrb r3, [r5,#8]
	sub r3, #1
	mov r2, #0x48 
	add r2, r2, r3
	add r2, r2, r5
loc_8027164:
	cmp r3, #0
	beq loc_8027188
	sub r2, #1
	ldrb r0, [r2]
	strb r0, [r2,#1]
	push {r2,r3}
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	mov r1, r3
	bl sprite_CopyObjTilesToVramSlot_80281D4
	pop {r2,r3}
	sub r3, #1
	b loc_8027164
loc_8027188:
	mov r0, #0xb
	strb r0, [r2]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r1, #2
	strb r1, [r0,#7]
	ldrb r1, [r0,#6]
	cmp r1, #0
	beq loc_802719E
	mov r0, #0xd
	b loc_80271A0
loc_802719E:
	ldrb r0, [r0,#5]
loc_80271A0:
	mov r1, #0
	bl sub_80281E4
	bl customScreen_ExitSequence_8028E32
	mov r0, #0
	mov r1, #0x20 
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x92
	bl PlaySoundEffect
	mov r0, #0x18
	strh r0, [r5,#2]
loc_80271BC:
	bl sub_80298D8
	pop {r4,pc}
	thumb_func_end sub_8027150

	thumb_local_start
sub_80271C2:
	push {lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_80271F2
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	ldrb r2, [r5,#0xc]
	cmp r2, #3
	bne locret_80271F2
	ldr r0, off_80271F4 // =TextScriptFirstBattleTutorials
	lsl r2, r2, #2
	ldr r0, [r0,r2]
	mov r1, #0xa
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	mov r0, #4
	strb r0, [r5,#0xd]
	mov r0, #0x34 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_80271F2:
	pop {pc}
	.balign 4, 0
off_80271F4:
	.word TextScriptFirstBattleTutorials
	thumb_func_end sub_80271C2

// symdb: Shuffle-once state machine step: dispatches on S20364C0+2 to sub_802721C (state 0: initial shuffle) or sub_802723A (state 4: ticking shuffles + finish), then sub_8029C08 and sub_802899C.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_80271F8.yaml
	thumb_local_start
sub_80271F8: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldr r1, off_8027210 // =off_8027214 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	bl sub_802899C
	pop {pc}
	.balign 4, 0
off_8027210:
	.word off_8027214
off_8027214:
	.word sub_802721C+1
	.word sub_802723A+1
	thumb_func_end sub_80271F8

	thumb_local_start
sub_802721C:
	push {lr}
	mov r0, #0
	str r0, [r5,#0x40]
	bl sub_8029788
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r1, #2
	strb r1, [r0,#7]
	bl customScreen_ExitSequence_8028E32
	mov r0, #4
	strh r0, [r5,#2]
	pop {pc}
	thumb_func_end sub_802721C

	thumb_local_start
sub_802723A:
	push {lr}
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	mov r1, #3
	and r1, r0
	bne locret_802728A
	lsr r0, r0, #2
	cmp r0, #8
	blt loc_802727A
	bl sub_802983C
	ldrb r0, [r5,#0x16]
	add r0, #1
	strb r0, [r5,#0x16]
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r2, #0
	ldrb r1, [r0,#4]
	sub r1, #1
	strb r1, [r0,#4]
	bne loc_802726A
	mov r2, #1
loc_802726A:
	strb r2, [r0,#7]
	bl sub_8028476
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b loc_802727E
loc_802727A:
	bl sub_8029688
loc_802727E:
	bl customScreen_ExitSequence_8028E32
	mov r0, #0x14
	add r0, #0xff
	bl PlaySoundEffect
locret_802728A:
	pop {pc}
	thumb_func_end sub_802723A

// symdb: Battle chat window dispatcher: runs one of five state handlers picked by the chat object's state byte, then calls the common follow-up update.
// symdb: void sub_802728C(void); // r5 = chat window object pointer (in) // r4 = caller-saved word,
// symdb: preserved across this call (out unchanged) // clobbers r0,r1,r2,r3,r6,r7,r8,r9,r10,r11,r12,lr;
// symdb: flags NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802728C.yaml
	thumb_local_start
sub_802728C: // (self: * S20364C0 $r5) -> ()
	push {r4,lr}
	ldr r4, [r5,#0x40]
	ldr r1, off_80272A0 // =off_80272A4 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	pop {r4,pc}
	.balign 4, 0
off_80272A0:
	.word off_80272A4
off_80272A4:
	.word battle_loadObjTableEntryAndSetState4_80272B8+1
	.word sub_80272D0+1
	.word chatbox_setState4IfFlag80Clear_8027320+1
	.word sub_8027332+1
	.word sub_8027394+1
	thumb_func_end sub_802728C

// symdb: Loads a word from a lookup table (indexed by the object's +0xC id) into the object's +0x40 field and switches the object to state 4.
// symdb: void battle_loadObjTableEntryAndSetState4(Obj* r5); // writes obj->field40 (u32) and obj->state2
// symdb: (u16=4); returns r0=4, r1=table base; nz/c set by "mov r0,#4" and the shifted-out bit of
// symdb: (r5+0xC)<<2 (never set for byte values)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_loadObjTableEntryAndSetState4_80272B8.yaml
	thumb_local_start
battle_loadObjTableEntryAndSetState4_80272B8:
	push {lr}
	ldrb r0, [r5,#0xc]
	lsl r0, r0, #2
	ldr r1, off_80272CC // =off_8027BEC 
	ldr r0, [r1,r0]
	str r0, [r5,#0x40]
	mov r0, #4
	strh r0, [r5,#2]
	pop {pc}
	.balign 4, 0x00
off_80272CC:
	.word off_8027BEC
	thumb_func_end battle_loadObjTableEntryAndSetState4_80272B8

	thumb_local_start
sub_80272D0:
	push {lr}
	ldrb r0, [r4]
	cmp r0, #0
	beq loc_80272E6
	cmp r0, #1
	beq loc_80272FE
	cmp r0, #2
	beq loc_8027308
	mov r0, #0x10
	strh r0, [r5,#2]
	b locret_8027318
loc_80272E6:
	mov r0, #8
	strh r0, [r5,#2]
	ldr r0, off_802731C // =TextScriptFirstBattleTutorials
	ldrb r1, [r5,#0xc]
	lsl r1, r1, #2
	ldr r0, [r0,r1]
	ldrb r1, [r4,#1]
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	add r4, #2
	str r4, [r5,#0x40]
	b locret_8027318
loc_80272FE:
	mov r0, #0xc
	strh r0, [r5,#2]
	mov r0, #0x50 
	str r0, [r5,#0x44]
	b locret_8027318
loc_8027308:
	ldrb r1, [r4,#1]
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#0xd]
	bl battle_setPlayerNaviStatsField0E_8015BEC
	add r4, #2
	str r4, [r5,#0x40]
locret_8027318:
	pop {pc}
	.balign 4, 0
off_802731C:
	.word TextScriptFirstBattleTutorials
	thumb_func_end sub_80272D0

// symdb: If chatbox event flag 0x80 (eFlags2009F38) is clear, sets a chatbox state/halfword field to 4.
// symdb: int sub_8027320(uint16_t *stateField /* r5: struct with u16 field at +2 */, int r1 /* unused */,
// symdb: void *lr /* return */); /* returns r0 = flag-test result, sets nz/c/v from the cmp/move */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chatbox_setState4IfFlag80Clear_8027320.yaml
	thumb_local_start
chatbox_setState4IfFlag80Clear_8027320:
	push {lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	cmp r0, #0
	bne locret_8027330
	mov r0, #4
	strh r0, [r5,#2]
locret_8027330:
	pop {pc}
	thumb_func_end chatbox_setState4IfFlag80Clear_8027320

// symdb: Drives one step of a battle script batch: spawns each 3-byte entry via sub_8001040 until the batch terminator, then waits out a frame timer (cuttable by A or B near the end) before advancing the script state to 4.
// symdb: u32 sub_8027332(u32 r4 /* entry-list pos */, u32 r5 /* owner object */, u32 r10 /* toolkit */);
// symdb: // returns r3 (joypad ptr if buttons read, else last sub_8001040 r3); clobbers r0,r1,r2,r3,r4,lr
// symdb: and NZCV; preserves r5,r6,r7,r10
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8027332.yaml
	thumb_local_start
sub_8027332:
	push {lr}
	add r4, #1
loc_8027336:
	push {r4}
	ldrb r0, [r4,#2]
	mov r1, #0x80
	bic r0, r1
	lsl r0, r0, #2
	ldr r2, off_8027384 // =byte_8027388
	ldr r2, [r2,r0]
	ldr r3, dword_8027390 // =0xb37a 
	ldrb r0, [r4]
	ldrb r1, [r4,#1]
	mov r4, #1
	bl sub_8001040
	pop {r4}
	ldrb r0, [r4,#2]
	add r4, #3
	mov r1, #0x80
	tst r0, r1
	beq loc_8027336
	ldr r0, [r5,#0x44]
	sub r0, #1
	str r0, [r5,#0x44]
	beq loc_802737C
	cmp r0, #0x44 
	bgt locret_8027382
	mov r3, r10
	ldr r3, [r3,#oToolkit_JoypadPtr]
	ldrh r0, [r3,#2]
	mov r1, #1
	tst r0, r1
	bne loc_802737C
	ldrh r0, [r3,#4]
	mov r1, #2
	tst r0, r1
	beq locret_8027382
loc_802737C:
	str r4, [r5,#0x40]
	mov r0, #4
	strh r0, [r5,#2]
locret_8027382:
	pop {pc}
	.balign 4, 0
off_8027384:
	.word byte_8027388
byte_8027388:
	.byte 0x0, 0x0, 0x0, 0x40, 0x0, 0x0, 0x0, 0x60
dword_8027390:
	.word 0xB37A
	thumb_func_end sub_8027332

// symdb: Puts the battle object at r5 into state 4 and zeroes its halfword field (likely a timer/counter), returning 0.
// symdb: void sub_8027394(battle_obj_t* obj /* r5 */); returns r0 = 0 with N/Z flags set from that 0
// symdb: (Z=1)
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8027394.yaml
	thumb_local_start
sub_8027394:
	push {lr}
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	pop {pc}
	.word dword_20349A0
	thumb_func_end sub_8027394

// symdb: Dispatch a battle object's per-frame handler by reading its mode byte and tail-calling the corresponding entry.
// symdb: void sub_80273A4(r5=*self, r10=preserved, lr=preserved) -> r2 r3 r5 r6 r8 r9 r10 r11 r12
// symdb: (handler returns); clobbers nz,c,v r0 r1 r7 lr; r4 preserved.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_80273A4.yaml
	thumb_local_start
sub_80273A4: // (self: * S20364C0 $r5) -> ()
	push {r4,lr}
	ldr r4, [r5,#0x40]
	ldr r1, off_80273B4 // =off_80273B8 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r4,pc}
off_80273B4:
	.word off_80273B8
off_80273B8:
	.word battle_object_SelectHandlerByMode_80273CC+1
	.word sub_80272D0+1
	.word chatbox_setState4IfFlag80Clear_8027320+1
	.word sub_8027332+1
	.word sub_80273E4+1
	thumb_func_end sub_80273A4

// symdb: Picks a battle object's next routine from a per-mode pointer table and flags the object with state 4.
// symdb: void sub_80273CC(battleobj *r5); /* returns r0=4, r1=table base, NZ from r0=4 (clear), C from
// symdb: mode<<2 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_object_SelectHandlerByMode_80273CC.yaml
	thumb_local_start
battle_object_SelectHandlerByMode_80273CC:
	push {lr}
	ldrb r0, [r5,#0xc]
	lsl r0, r0, #2
	ldr r1, off_80273E0 // =off_8027C84 
	ldr r0, [r1,r0]
	str r0, [r5,#0x40]
	mov r0, #4
	strh r0, [r5,#2]
	pop {pc}
	.byte 0, 0
off_80273E0:
	.word off_8027C84
	thumb_func_end battle_object_SelectHandlerByMode_80273CC

// symdb: Sets the byte pointed to by r5 to the constant 8 and returns 8, likely writing a state/enum value into some object field.
// symdb: u8 setByteTo8(void *stateByte) — takes r5 = pointer to a byte; stores 8 there, returns r0 = 8
// symdb: with NZ flags set from it; does not touch r5's caller value.
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_80273E4.yaml
	thumb_local_start
sub_80273E4:
	push {lr}
	mov r0, #8
	strb r0, [r5]
	pop {pc}
	thumb_func_end sub_80273E4

// symdb: If the chatbox is not currently flagged as shown, resets the textbox object's active text state and then runs its per-frame update.
// symdb: void chatbox_resetTextStateIfHidden(S20364C0 *self /* in r5 */) ; reads eFlags2009F38 bit 0x80,
// symdb: returns nothing
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chatbox_resetTextStateIfHidden_80273EC.yaml
	thumb_local_start
chatbox_resetTextStateIfHidden_80273EC: // (self: * S20364C0 $r5) -> ()
	push {lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	cmp r0, #0
	bne loc_8027400
	ldrb r0, [r5,#0xd]
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
loc_8027400:
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	pop {pc}
	thumb_func_end chatbox_resetTextStateIfHidden_80273EC

	thumb_local_start
sub_8027406: // (self: * S20364C0 $r5) -> ()
	push {r4,lr}
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r4, r0
	ldr r1, off_8027424 // =off_8027428 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	bl sub_802899C
	pop {r4,pc}
	.balign 4, 0
off_8027424:
	.word off_8027428
off_8027428:
	.word sub_8027434+1
	.word sub_8027458+1
	.word sub_802750C+1
	thumb_func_end sub_8027406

	thumb_local_start
sub_8027434:
	push {lr}
	mov r0, #0x18
	str r0, [r5,#0x40]
	mov r0, #0
	str r0, [r5,#0x44]
	mov r0, #0
	mov r1, #0x5f 
	strb r0, [r5,r1]
loc_8027444:
	ldr r1, dword_8027508 // =0xffff 
	mov r2, #0x60 
	add r2, r2, r5
	strh r1, [r2,r0]
	add r0, #2
	cmp r0, #0x10
	blt loc_8027444
	mov r0, #4
	strh r0, [r5,#2]
	pop {pc}
	thumb_func_end sub_8027434

	thumb_local_start
sub_8027458:
	push {r4,r6,lr}
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	mov r1, #0x19
	svc 6
	tst r1, r1
	bne loc_80274CE
	ldrb r0, [r5,#8]
	cmp r0, #0
	beq loc_80274F0
	add r0, #0x47 
	ldrb r0, [r5,r0]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r4, r0
	ldrb r1, [r0]
	cmp r1, #0
	bne loc_80274F0
	ldrb r1, [r0,#4]
	mov r2, #1
	tst r1, r2
	beq loc_802748E
	mov r2, r10
	ldr r2, [r2,#oToolkit_BattleStatePtr]
	mov r1, #0
	strb r1, [r2,#0x17]
loc_802748E:
	ldr r2, [r0,#8]
	ldrh r0, [r2]
	ldr r3, dword_8027508 // =0xffff 
	strh r3, [r2]
	mov r1, #0x5f 
	ldrb r1, [r5,r1]
	lsl r2, r1, #1
	mov r3, #0x60 
	add r3, r3, r2
	strh r0, [r5,r3]
	add r1, #1
	mov r2, #0x5f 
	strb r1, [r5,r2]
	ldrb r1, [r5,#8]
	sub r1, #1
	strb r1, [r5,#8]
	ldr r0, dword_8027504 // =0x1ff 
	bl sprite_CopyObjTilesToVramSlot_80281D4
	ldrb r0, [r5,#8]
	mov r1, #0
	mov r2, #0
	bl sub_8029CD4
	bl sub_8028476
	mov r0, #0x97
	add r0, #0xff
	bl PlaySoundEffect
	mov r0, #0x14
	str r0, [r5,#0x44]
loc_80274CE:
	ldr r0, [r5,#0x44]
	tst r0, r0
	beq loc_80274E4
	sub r0, #1
	str r0, [r5,#0x44]
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r1, #3
	strb r1, [r0,#7]
	b locret_8027500
loc_80274E4:
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r1, #0
	strb r1, [r0,#7]
	b locret_8027500
loc_80274F0:
	bl battle_compactFolderChipList_802945A
	bl sub_80294E0
	bl sub_802A61A
	mov r0, #8
	strh r0, [r5,#2]
locret_8027500:
	pop {r4,r6,pc}
	.balign 4, 0
dword_8027504:
	.word 0x1FF
dword_8027508:
	.word 0xFFFF
	thumb_func_end sub_8027458

	thumb_local_start
sub_802750C:
	push {lr}
	ldr r0, [r5,#0x30]
	add r0, #1
	str r0, [r5,#0x30]
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r2, #0
	ldrb r1, [r0,#4]
	sub r1, #1
	strb r1, [r0,#4]
	bne loc_8027526
	mov r2, #2
loc_8027526:
	strb r2, [r0,#7]
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov r0, #0x83
	add r0, #0xff
	bl PlaySoundEffect
	bl customScreen_ExitSequence_8028E32
	pop {pc}
	thumb_func_end sub_802750C

	thumb_local_start
sub_802753E: // (self: * S20364C0 $r5) -> ()
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov pc, lr
	thumb_func_end sub_802753E

	thumb_local_start
sub_8027548: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldr r1, off_8027560 // =off_8027564 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	bl sub_802899C
	pop {pc}
	.balign 4, 0
off_8027560:
	.word off_8027564
off_8027564:
	.word sub_8027574+1
	.word sub_8027580+1
	.word sub_802759E+1
	.word sub_80275D8+1
	thumb_func_end sub_8027548

	thumb_local_start
sub_8027574:
	push {lr}
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #4
	strh r0, [r5,#2]
	pop {pc}
	thumb_func_end sub_8027574

	thumb_local_start
sub_8027580:
	push {lr}
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	cmp r0, #0x10
	blt locret_802759C
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #4
	mov r1, #0x20 
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #8
	strh r0, [r5,#2]
locret_802759C:
	pop {pc}
	thumb_func_end sub_8027580

	thumb_local_start
sub_802759E:
	push {r4,lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_80275D2
	mov r0, #0
	mov r1, #0x20 
	bl SetScreenFade // (int a1, int a2) -> void
	ldrh r0, [r5,#0x38]
	strh r0, [r5,#0x3a]
	ldrh r0, [r5,#0x3a]
	mov r1, #1
	lsl r1, r0
	ldr r3, off_80275D4 // =dword_20349A0 
	ldrh r0, [r3,#0xe] // (word_20349AE - 0x20349a0)
	orr r0, r1
	strh r0, [r3,#0xe] // (word_20349AE - 0x20349a0)
	ldrh r0, [r5,#0x3a]
	bl sub_802A0C8
	mov r0, #0x92
	bl PlaySoundEffect
	mov r0, #0xc
	strh r0, [r5,#2]
locret_80275D2:
	pop {r4,pc}
	.balign 4, 0
off_80275D4:
	.word dword_20349A0
	thumb_func_end sub_802759E

	thumb_local_start
sub_80275D8:
	push {lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_80275EA
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_80275EA:
	pop {pc}
	thumb_func_end sub_80275D8

	thumb_local_start
sub_80275EC: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldr r1, off_8027600 // =off_8027604 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	pop {pc}
	.balign 4, 0
off_8027600:
	.word off_8027604
off_8027604:
	.word sub_8027618+1
	.word sub_8027624+1
	.word sub_8027658+1
	.word sub_8027672+1
	.word sub_80276D6+1
	thumb_func_end sub_80275EC

	thumb_local_start
sub_8027618:
	push {lr}
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #4
	strh r0, [r5,#2]
	pop {pc}
	thumb_func_end sub_8027618

	thumb_local_start
sub_8027624:
	push {lr}
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	cmp r0, #0x10
	blt locret_8027656
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #0x64 
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #1
	mov r1, #0x28 
	bl sub_80302B6
	mov r0, #0x94
	add r0, #0xff
	bl PlaySoundEffect
	mov r0, #0xbc
	bl PlaySoundEffect
	mov r0, #8
	strh r0, [r5,#2]
locret_8027656:
	pop {pc}
	thumb_func_end sub_8027624

	thumb_local_start
sub_8027658:
	push {r4,r6,lr}
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	cmp r0, #0x32 
	blt locret_8027670
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_8027670
	mov r0, #0xc
	strh r0, [r5,#2]
locret_8027670:
	pop {r4,r6,pc}
	thumb_func_end sub_8027658

	thumb_local_start
sub_8027672:
	push {r4,r6,lr}
	mov r0, #0
	bl sub_802A040
	ldrb r3, [r5,#8]
	sub r3, #1
	mov r2, #0x48 
	add r2, r2, r3
	add r2, r2, r5
	ldrb r6, [r2]
loc_8027686:
	cmp r3, #0
	beq loc_80276AA
	sub r2, #1
	ldrb r0, [r2]
	strb r0, [r2,#1]
	push {r2,r3}
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	mov r1, r3
	bl sprite_CopyObjTilesToVramSlot_80281D4
	pop {r2,r3}
	sub r3, #1
	b loc_8027686
loc_80276AA:
	mov r1, #0x48 
	add r1, r1, r5
	strb r6, [r1]
	mov r0, r6
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	mov r1, #0
	bl sprite_CopyObjTilesToVramSlot_80281D4
	bl customScreen_ExitSequence_8028E32
	mov r0, #0x60 
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x10
	strh r0, [r5,#2]
	pop {r4,r6,pc}
	thumb_func_end sub_8027672

	thumb_local_start
sub_80276D6:
	push {lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_8027706
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	ldrb r2, [r5,#0xc]
	cmp r2, #3
	bne locret_8027706
	ldr r0, off_8027708 // =TextScriptFirstBattleTutorials
	lsl r2, r2, #2
	ldr r0, [r0,r2]
	mov r1, #0xa
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	mov r0, #4
	strb r0, [r5,#0xd]
	mov r0, #0x34 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_8027706:
	pop {pc}
	.balign 4, 0
off_8027708:
	.word TextScriptFirstBattleTutorials
	thumb_func_end sub_80276D6

	thumb_local_start
sub_802770C: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldr r1, off_8027720 // =off_8027724 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	pop {pc}
	.balign 4, 0
off_8027720:
	.word off_8027724
off_8027724:
	.word sub_8027738+1
	.word sub_802774C+1
	.word sub_802777C+1
	.word sub_8027796+1
	.word sub_8027806+1
	thumb_func_end sub_802770C

	thumb_local_start
sub_8027738:
	push {lr}
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #1
	strb r0, [r5,#0x17]
	mov r0, #1
	strb r0, [r5,#0xf]
	mov r0, #4
	strh r0, [r5,#2]
	pop {pc}
	thumb_func_end sub_8027738

	thumb_local_start
sub_802774C:
	push {lr}
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #0x64 
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #1
	mov r1, #0x28 
	bl sub_80302B6
	mov r0, #0x94
	add r0, #0xff
	bl PlaySoundEffect
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r0, #0xbc
	bl PlaySoundEffect
	mov r0, #8
	strh r0, [r5,#2]
	pop {pc}
	thumb_func_end sub_802774C

	thumb_local_start
sub_802777C:
	push {r4,r6,lr}
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	cmp r0, #0x32 
	blt locret_8027794
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_8027794
	mov r0, #0xc
	strh r0, [r5,#2]
locret_8027794:
	pop {r4,r6,pc}
	thumb_func_end sub_802777C

	thumb_local_start
sub_8027796:
	push {r4,r6,lr}
	mov r4, #0
	bl battle_getActorEmotion_802A564
	cmp r0, #1
	bne loc_80277A4
	mov r4, #0xc
loc_80277A4:
	mov r0, r4
	bl sub_802A040
	ldrb r3, [r5,#8]
	sub r3, #1
	mov r2, #0x48 
	add r2, r2, r3
	add r2, r2, r5
	ldrb r6, [r2]
loc_80277B6:
	cmp r3, #0
	beq loc_80277DA
	sub r2, #1
	ldrb r0, [r2]
	strb r0, [r2,#1]
	push {r2,r3}
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	mov r1, r3
	bl sprite_CopyObjTilesToVramSlot_80281D4
	pop {r2,r3}
	sub r3, #1
	b loc_80277B6
loc_80277DA:
	mov r1, #0x48 
	add r1, r1, r5
	strb r6, [r1]
	bl sub_802A034
	mov r1, #0
	bl sprite_CopyObjTilesToVramSlot_80281D4
	mov r0, #0xb
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r1, #2
	strb r1, [r0,#7]
	bl customScreen_ExitSequence_8028E32
	mov r0, #0x60 
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x10
	strh r0, [r5,#2]
	pop {r4,r6,pc}
	thumb_func_end sub_8027796

	thumb_local_start
sub_8027806:
	push {lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_802782E
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	ldrb r2, [r5,#0xc]
	cmp r2, #3
	bne locret_802782E
	mov r0, #4
	strb r0, [r5,#0xc]
	mov r0, #4
	strb r0, [r5,#0xd]
	mov r0, #0x2c 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_802782E:
	pop {pc}
	.word TextScriptFirstBattleTutorials
	thumb_func_end sub_8027806

	thumb_local_start
sub_8027834: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldrb r0, [r5,#2]
	cmp r0, #0
	bne loc_802784A
	str r0, [r5,#0x44]
	str r0, [r5,#0x40]
	mov r0, #1
	strb r0, [r5,#2]
	mov r0, #SOUND_SELECT_7A
	bl PlaySoundEffect
loc_802784A:
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	cmp r0, #0x14
	bgt loc_80278C8
	mov r1, #3
	svc 6
	tst r1, r1
	bne loc_80278D6
	ldr r0, [r5,#0x44]
	cmp r0, #3
	bge loc_802786A
	lsl r0, r0, #2
	ldr r1, off_80278DC // =off_80278E0 
	ldr r0, [r1,r0]
	b loc_8027876
loc_802786A:
	ldrb r0, [r5,#0x18]
	sub r0, #1
	lsl r0, r0, #2
	add r0, #0xc
	ldr r1, off_80278DC // =off_80278E0 
	ldr r0, [r1,r0]
loc_8027876:
	ldr r1, off_8027B24 // =unk_2035000 
	ldr r2, off_8027900 // =0x258 
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	push {r4-r6}
	mov r2, #0xe1
	ldr r6, off_8027904 // =byte_8027B4A 
loc_8027884:
	ldr r0, dword_8027908 // =0xfff 
	and r0, r2
	ldrb r2, [r6,#4]
	lsl r2, r2, #0xc
	orr r2, r0
	ldrb r0, [r6]
	ldrb r1, [r6,#1]
	ldrb r3, [r6,#2]
	ldrb r4, [r6,#3]
	ldrb r5, [r6,#5]
	bl sub_8027CCC
	add r6, #6
	ldrb r0, [r6]
	cmp r0, #0xff
	bne loc_8027884
	pop {r4-r6}
	push {r4,r5}
	// j
	mov r0, #0
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_8027B24 // =unk_2035000 
	mov r4, #0xf
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4,r5}
	ldr r0, [r5,#0x44]
	cmp r0, #3
	bge loc_80278C8
	ldr r0, [r5,#0x44]
	add r0, #1
	str r0, [r5,#0x44]
	b loc_80278D6
loc_80278C8:
	mov r0, #0x54 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	bl sub_802794A // (self: * S20364C0 $r5) -> ()
	b locret_80278DA
loc_80278D6:
	bl sub_80279C8
locret_80278DA:
	pop {pc}
	.balign 4, 0
off_80278DC:
	.word off_80278E0
off_80278E0:
	.word byte_86E670C
	.word byte_86E6964
	.word byte_86E6BBC
	.word byte_86E6E14
	.word byte_86E706C
	.word byte_86E72C4
	.word byte_86E751C
	.word byte_86E7774
off_8027900:
	.word 0x258
off_8027904:
	.word byte_8027B4A
dword_8027908:
	.word 0xFFF
	thumb_func_end sub_8027834

	thumb_local_start
sub_802790C: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldrb r0, [r5,#2]
	cmp r0, #0
	bne loc_8027922
	str r0, [r5,#0x44]
	str r0, [r5,#0x40]
	mov r0, #1
	strb r0, [r5,#2]
	mov r0, #SOUND_UNK_7D
	bl PlaySoundEffect
loc_8027922:
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	cmp r0, #5
	ble loc_8027940
	bl sub_80279FC
	bl sub_80279C8
	bl sub_8028476
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
loc_8027940:
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	bl sub_802899C
	pop {pc}
	thumb_func_end sub_802790C

	thumb_local_start
sub_802794A: // (self: * S20364C0 $r5) -> ()
	push {r7,lr}
	ldrb r0, [r5,#2]
	cmp r0, #0
	bne loc_802795C
	str r0, [r5,#0x44]
	str r0, [r5,#0x40]
	mov r0, #1
	strb r0, [r5,#2]
	b loc_8027964
loc_802795C:
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	bl sub_8028A78
loc_8027964:
	bl sub_80279C8
	mov r4, #0
loc_802796A:
	ldrb r1, [r5,#0x1b]
	cmp r4, r1
	bne loc_802798A
	mov r2, #0
	ldr r1, dword_80279C4 // =0x55 
	add r1, r1, r4
	ldrb r0, [r5,r1]
	cmp r0, #0
	beq loc_802797E
	mov r2, #5
loc_802797E:
	ldr r1, off_80279C0 // =0x50 
	add r1, r1, r4
	ldrb r0, [r5,r1]
	add r0, r0, r2
	bl sub_8029EAC
loc_802798A:
	add r4, #1
	ldrb r2, [r5,#0x18]
	cmp r4, r2
	blt loc_802796A
	mov r0, #0
loc_8027994:
	mov r2, #2
	ldrb r1, [r5,#0x1b]
	cmp r0, r1
	bne loc_802799E
	mov r2, #0
loc_802799E:
	ldr r1, off_80279C0 // =0x50 
	add r1, r1, r0
	ldrb r1, [r5,r1]
	push {r0}
	bl sub_8029D94
	pop {r0}
	add r0, #1
	ldrb r2, [r5,#0x18]
	cmp r0, r2
	blt loc_8027994
	bl sub_80289E4
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	pop {r7,pc}
	.balign 4, 0
off_80279C0:
	.word 0x50
dword_80279C4:
	.word 0x55
	thumb_func_end sub_802794A

	thumb_local_start
sub_80279C8:
	push {r4,lr}
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	bl sub_802899C
	bl battle_endingBgUpdate_8029D34
	mov r4, #4
loc_80279D8:
	mov r0, r4
	mov r1, #0
	ldrb r2, [r5,#8]
	sub r2, #1
	cmp r0, r2
	bgt loc_80279E6
	mov r1, #1
loc_80279E6:
	mov r2, #0
	bl sub_8029CD4
	sub r4, #1
	bpl loc_80279D8
	bl customScreen_ExitSequence_8028E32
	pop {r4,pc}
	.balign 4, 0x00
	.word 0x1FF
	thumb_func_end sub_80279C8

	thumb_local_start
sub_80279FC:
	push {lr}
	ldr r0, off_8027A48 // =byte_86E64B4 
	ldr r1, off_8027B24 // =unk_2035000 
	ldr r2, off_8027A4C // =0x258 
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	push {r4-r6}
	mov r2, #0x9b
	ldr r6, off_8027A50 // =byte_8027B2C 
loc_8027A0E:
	ldr r0, dword_8027A54 // =0xfff 
	and r0, r2
	ldrb r2, [r6,#4]
	lsl r2, r2, #0xc
	orr r2, r0
	ldrb r0, [r6]
	ldrb r1, [r6,#1]
	ldrb r3, [r6,#2]
	ldrb r4, [r6,#3]
	ldrb r5, [r6,#5]
	bl sub_8027CCC
	add r6, #6
	ldrb r0, [r6]
	cmp r0, #0xff
	bne loc_8027A0E
	pop {r4-r6}
	push {r4,r5}
	// j
	mov r0, #0
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_8027B24 // =unk_2035000 
	mov r4, #0xf
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4,r5}
	pop {pc}
	.balign 4, 0
off_8027A48:
	.word byte_86E64B4
off_8027A4C:
	.word 0x258
off_8027A50:
	.word byte_8027B2C
dword_8027A54:
	.word 0xFFF
	thumb_func_end sub_80279FC

	thumb_local_start
sub_8027A58: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldr r1, off_8027A70 // =off_8027A74 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_8029C08 // (self: * S20364C0 $r5) -> ()
	bl sub_802899C
	pop {pc}
	.balign 4, 0
off_8027A70:
	.word off_8027A74
off_8027A74:
	.word sub_8027A84+1
	.word sub_8027A90+1
	.word sub_8027AAE+1
	.word sub_8027ADE+1
	thumb_func_end sub_8027A58

	thumb_local_start
sub_8027A84:
	push {lr}
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #4
	strh r0, [r5,#2]
	pop {pc}
	thumb_func_end sub_8027A84

	thumb_local_start
sub_8027A90:
	push {lr}
	ldr r0, [r5,#0x40]
	add r0, #1
	str r0, [r5,#0x40]
	cmp r0, #0x10
	blt locret_8027AAC
	mov r0, #0
	str r0, [r5,#0x40]
	mov r0, #4
	mov r1, #0x20 
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #8
	strh r0, [r5,#2]
locret_8027AAC:
	pop {pc}
	thumb_func_end sub_8027A90

	thumb_local_start
sub_8027AAE:
	push {r4,r6,lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_8027ADC
	mov r0, #0
	mov r1, #0x20 
	bl SetScreenFade // (int a1, int a2) -> void
	ldrb r0, [r5,#0x1a]
	bl sub_802A088
	bl sub_80279FC
	bl sub_80279C8
	bl sub_8028476
	mov r0, #0x92
	bl PlaySoundEffect
	mov r0, #0xc
	strh r0, [r5,#2]
locret_8027ADC:
	pop {r4,r6,pc}
	thumb_func_end sub_8027AAE

	thumb_local_start
sub_8027ADE:
	push {lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_8027B1A
	bl sub_80279FC
	bl sub_80279C8
	bl sub_8028476
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	ldrb r2, [r5,#0xc]
	cmp r2, #6
	bne locret_8027B1A
	ldr r0, off_8027B1C // =TextScriptFirstBattleTutorials
	lsl r2, r2, #2
	ldr r0, [r0,r2]
	mov r1, #2
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	mov r0, #4
	strb r0, [r5,#0xd]
	mov r0, #0x34 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_8027B1A:
	pop {pc}
	.balign 4, 0
off_8027B1C:
	.word TextScriptFirstBattleTutorials
	.word eS20364C0
off_8027B24:
	.word unk_2035000
	.word dword_20349A0
byte_8027B2C:
	.byte 0x2
byte_8027B2D:
	.byte 0x1
byte_8027B2E:
	.byte 0x8
byte_8027B2F:
	.byte 0x2
byte_8027B30:
	.byte 0x9
byte_8027B31:
	.byte 0x1, 0x2, 0x3, 0x7, 0x6, 0xA, 0x0, 0x2, 0x9, 0x1, 0x2, 0x9, 0x0, 0x3, 0x9, 0x2, 0x2
	.byte 0xB, 0x0, 0x6, 0x9, 0x3, 0x2, 0x9, 0x1
byte_8027B4A:
	.byte 0x1
byte_8027B4B:
	.byte 0xD
byte_8027B4C:
	.byte 0x2
byte_8027B4D:
	.byte 0x2
byte_8027B4E:
	.byte 0xB
byte_8027B4F:
	.byte 0x0, 0x1, 0xF, 0x2, 0x1, 0x9, 0x0, 0x3, 0xD, 0x2, 0x2, 0xB, 0x0, 0x3, 0xF
	.byte 0x2, 0x1, 0x9, 0x0, 0x5, 0xD, 0x2, 0x2, 0xB, 0x0, 0x5, 0xF, 0x2, 0x1, 0x9
	.byte 0x0, 0x7, 0xD, 0x2, 0x2, 0xB, 0x0, 0x7, 0xF, 0x2, 0x1, 0x9, 0x0, 0x9, 0xD
	.byte 0x2, 0x2, 0xB, 0x0, 0x9, 0xF, 0x2, 0x1, 0x9, 0x0, 0x1, 0x10, 0x2, 0x2, 0xB
	.byte 0x0, 0x1, 0x12, 0x2, 0x1, 0x9, 0x0, 0x3, 0x10, 0x2, 0x2, 0xB, 0x0, 0x3, 0x12
	.byte 0x2, 0x1, 0x9, 0x0, 0x5, 0x10, 0x2, 0x2, 0xB, 0x0, 0x5, 0x12, 0x2, 0x1, 0x9
	.byte 0x0, 0x7, 0x10, 0x2, 0x2, 0xB, 0x0, 0x7, 0x12, 0x2, 0x1, 0x9, 0x0, 0x9, 0x10
	.byte 0x2, 0x2, 0xB, 0x0, 0x9, 0x12, 0x2, 0x1, 0x9, 0x0, 0xB, 0x11, 0x4, 0x2, 0x9
	.byte 0x0, 0xC, 0x3, 0x2, 0xA, 0xB, 0x0, 0xFF, 0x0
TextScriptFirstBattleTutorials:
	.word TextScriptBattleTut1
	.word TextScriptBattleTutAreaGrab
	.word TextScriptBattleTutFullSynchro
TextScriptPtrArr8027BDC:
	.word TextScriptDadCybeastTut
	.word TextScriptDadCybeastTut
	.word TextScriptDadCybeastTut
	.word TextScriptShukoCrossTut
off_8027BEC:
	.word byte_8027C08
	.word byte_8027C38
	.word byte_8027C50
	.word byte_8027C64
	.word byte_8027C70
	.word dword_8027C7C
	.word dword_8027C80
byte_8027C08:
	.byte 0x0, 0x0, 0x1, 0x78, 0x4E, 0x80, 0x0, 0x2, 0x1, 0x40, 0x80, 0x80
	.byte 0x0, 0x3, 0x1, 0x4A, 0x30, 0x80, 0x0, 0x4, 0x1, 0x42, 0x56, 0x80
	.byte 0x0, 0x5, 0x1, 0x8E, 0x58, 0x1, 0xB6, 0x88, 0x81, 0x0, 0x6, 0x1
	.byte 0x12, 0x72, 0x0, 0x32, 0x72, 0x80, 0x0, 0x8, 0x3, 0x0, 0x0, 0x0
byte_8027C38:
	.byte 0x0, 0x0, 0x1, 0x12, 0x72, 0x80, 0x0, 0x1, 0x1, 0x22, 0x72, 0x80
	.byte 0x0, 0x2, 0x1, 0x10, 0x7E, 0x0, 0x20, 0x7E, 0x80, 0x0, 0x4, 0x3
byte_8027C50:
	.byte 0x0, 0x0, 0x1, 0xA2, 0x20, 0x80, 0x0, 0x3, 0x2, 0xFF, 0x1, 0xA2
	.byte 0x20, 0x80, 0x0, 0x4, 0x3, 0x0, 0x0, 0x0
byte_8027C64:
	.byte 0x0, 0x0, 0x1, 0x6A, 0x7D, 0x81, 0x0, 0x1, 0x3, 0x0, 0x0, 0x0
byte_8027C70:
	.byte 0x0, 0x5, 0x1, 0xA2, 0x20, 0x80, 0x0, 0xA, 0x3, 0x0, 0x0, 0x0
dword_8027C7C:
	.word 0x31900
dword_8027C80:
	.word 0x30100
off_8027C84:
	.word byte_8027CA0
	.word byte_8027CB5
	.word byte_8027CC4
	.word byte_8027CC5
	.word byte_8027CC6
	.word byte_8027CC7
	.word dword_8027CC8
byte_8027CA0:
	.byte 0x0, 0x11, 0x1, 0x2E, 0xE, 0x80, 0x0, 0x12, 0x1, 0x48, 0x40
	.byte 0x80, 0x0, 0x13, 0x1, 0x78, 0x10, 0x80, 0x0, 0x15, 0x3
byte_8027CB5:
	.byte 0x0, 0x10, 0x1, 0x8C, 0x52, 0x0, 0x8C, 0x6A, 0x0, 0x8C, 0x82
	.byte 0x80, 0x0, 0x11, 0x3
byte_8027CC4:
	.byte 0x3
byte_8027CC5:
	.byte 0x3
byte_8027CC6:
	.byte 0x3
byte_8027CC7:
	.byte 0x3
dword_8027CC8:
	.word 0x3
	thumb_func_end sub_8027ADE

// symdb: Stamps a width×height rectangle of running u16 tile indices into the 0x02035000 grid buffer at the given starting cell, optionally numbering down columns rather than across rows, and returns the next index after the block.
// symdb: in: r0 column, r1 row, r2 firstTile, r3 width, r4 height, r5 numberingOrder (1 = column-wise);
// symdb: out: r2 tile index following the rectangle; r6 and r7 also nominally preserved by push/pop;
// symdb: clobbers: n z c v; preserved: r0, r1, r3-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8027CCC.yaml
	thumb_local_start
sub_8027CCC:
	push {r0,r1,r3-r7,lr}
	mov r6, #1
	cmp r5, #1
	bne loc_8027CD6
	mul r6, r4
loc_8027CD6:
	mov r5, #0x1e
	mul r1, r5
	lsl r0, r0, #1
	add r1, r1, r0
	ldr r0, off_8027D0C // =unk_2035000 
	add r1, r1, r0
	mov r5, r3
	mov r7, r2
loc_8027CE6:
	mov r0, r1
	mov r3, r5
	mov r2, r7
loc_8027CEC:
	strh r2, [r0]
	add r0, #2
	add r2, r2, r6
	sub r3, #1
	bne loc_8027CEC
	add r1, #0x1e
	cmp r6, #1
	beq loc_8027D04
	add r7, #1
	sub r2, r2, r6
	add r2, #1
	b loc_8027D06
loc_8027D04:
	mov r7, r2
loc_8027D06:
	sub r4, #1
	bne loc_8027CE6
	pop {r0,r1,r3-r7,pc}
	.balign 4, 0
off_8027D0C:
	.word unk_2035000
	thumb_func_end sub_8027CCC

// symdb: Splits a battle chip id into one of two chip-name text tables plus an index into the chosen table.
// symdb: u32* chip_SelectNameTextTable(u32 chipId /* r0 */); /* returns table ptr in r0, index in r1 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chip_SelectNameTextTable_8027D10.yaml
	thumb_func_start chip_SelectNameTextTable_8027D10
chip_SelectNameTextTable_8027D10:
	mov r1, r0
	lsl r1, r1, #0x17
	lsr r1, r1, #0x17
	ldr r0, off_8027D28 // =off_8027D2C 
	cmp r1, #0xff
	ble loc_8027D22
	add r0, #4
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
loc_8027D22:
	ldr r0, [r0]
	mov pc, lr
	.balign 4, 0x00
off_8027D28:
	.word off_8027D2C
off_8027D2C:
	.word TextScriptChipNames0
off_8027D30:
	.word TextScriptChipNames1
	thumb_func_end chip_SelectNameTextTable_8027D10

// (int chipID) -> void*
// symdb: Given a chip id, returns the pointer to that chip's description text-script table and the chip's index within it, switching to a second table for ids above 0xFF.
// symdb: u32* chip_getDescriptionScript_8027D34(u32 chipId /* r0, low 9 bits */); // returns table
// symdb: pointer in r0, index in r1; flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chip_getScript_8027D34.yaml
	thumb_local_start
chip_getScript_8027D34:
	mov r1, r0
	lsl r1, r1, #0x17
	lsr r1, r1, #0x17
	ldr r0, off_8027D4C // =off_8027D50 
	cmp r1, #0xff
	ble loc_8027D46
	add r0, #4
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
loc_8027D46:
	ldr r0, [r0]
	mov pc, lr
	.balign 4, 0x00
off_8027D4C:
	.word off_8027D50
off_8027D50:
	.word TextScriptChipDescriptions0
off_8027D54:
	.word TextScriptChipDesc1
	thumb_func_end chip_getScript_8027D34

// symdb: Counts how many chips (up to 30) are stored in the equipped battle folder before its 0xFFFF terminator entry.
// symdb: int battle_countFolderChips(void); // in: lr only; out: r0 = chip count, r2 = pointer to
// symdb: terminator entry (or one past slot 30 if none), r3 = entries left unscanned; preserves r4
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_countFolderChips_8027D58.yaml
	thumb_local_start
battle_countFolderChips_8027D58:
	push {r4,lr}
	ldr r2, off_8027F0C // =eBattleFolder 
	ldr r1, dword_8027D74 // =0xffff 
	mov r3, #0x1e
loc_8027D60:
	ldrh r4, [r2]
	cmp r4, r1
	beq loc_8027D6C
	add r2, #2
	sub r3, #1
	bne loc_8027D60
loc_8027D6C:
	mov r0, #0x1e
	sub r0, r0, r3
	pop {r4,pc}
	.balign 4, 0
dword_8027D74:
	.word 0xFFFF
	thumb_func_end battle_countFolderChips_8027D58

// symdb: End-of-turn Custom Gauge handler that clears the gauge state, posts an end-of-turn request, and dispatches the correct teardown/init path based on battle state, flag 0x40, and battle mode.
// symdb: void battle_customGauge_EndTurn_8027D78(void); // in: r10 = Toolkit pointer, lr = return //
// symdb: out/clobber: r0-r4, r8-r12; flags n/z/c/v
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_customGauge_EndTurn_8027D78.yaml
	thumb_local_start
battle_customGauge_EndTurn_8027D78:
	push {lr}
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	mov r0, #0
	strh r0, [r1,#0x18]
	bl sub_801E71C
	mov r0, #0x80
	bl dispatch_801DACC // (a0: flags32) -> ()
	mov r0, #0
	mov r1, #0
	bl sub_801E0A0
	ldr r0, off_8027E14 // =0x400 
	bl eStruct2035280_SetRequestBits_801BECC
	ldr r0, off_8027E14 // =0x400 
	bl dispatch_801DA48
	bl battle_IsBattleEnding_800A97A
	tst r0, r0
	bne locret_8027E10
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#7]
	cmp r0, #1
	bne loc_8027DD4
	bl battle_testFlag0x40_800A8F8
	cmp r0, #0
	beq loc_8027DC0
	bl sub_801DF0C
	b locret_8027E10
loc_8027DC0:
	bl GetBattleMode
	cmp r0, #1
	bne loc_8027DCE
	bl sub_801DEEE
	b locret_8027E10
loc_8027DCE:
	bl custGauge_Init_801DED0
	b locret_8027E10
loc_8027DD4:
	bl battle_testFlag0x40_800A8F8
	cmp r0, #0
	beq loc_8027DEA
	ldr r0, dword_8027E18 // =0x20000 
	bl dispatch_801DA48
	ldr r0, dword_8027E18 // =0x20000 
	bl eStruct2035280_SetRequestBits_801BECC
	b locret_8027E10
loc_8027DEA:
	bl ClearCustGauge
	bl GetBattleMode
	cmp r0, #1
	bne loc_8027E04
	mov r0, #0x20 
	bl dispatch_801DA48
	mov r0, #0x20 
	bl eStruct2035280_SetRequestBits_801BECC
	b locret_8027E10
loc_8027E04:
	mov r0, #0x10
	bl dispatch_801DA48
	mov r0, #0x10
	bl eStruct2035280_SetRequestBits_801BECC
locret_8027E10:
	pop {pc}
	.balign 4, 0
off_8027E14:
	.word 0x400
dword_8027E18:
	.word 0x20000
	thumb_func_end battle_customGauge_EndTurn_8027D78

// (int a1) -> void*
// symdb: Return the address of active-chip entry r0 (12 bytes per entry).
// symdb: (r0 = slot) -> r0 = &activeChips[slot], r1 = activeChips
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getLocOfActiveChips_8027E1C.yaml
	thumb_local_start
getLocOfActiveChips_8027E1C:
	mov r1, #0xc
	mul r0, r1
	ldr r1, off_8027E28 // =unk_20365C0 
	add r0, r0, r1
	mov pc, lr
	.balign 4, 0x00
off_8027E28:
	.word unk_20365C0
	thumb_func_end getLocOfActiveChips_8027E1C

	thumb_local_start
sub_8027E2C:
	push {r4,r6,r7,lr}
	mov r0, #0
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r4, r0
	// size
	mov r1, #0x90
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	bl battle_updateBeastOutCounter_802A40C
	bl resetBattleRecordSlots_8027E90
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_17]
	cmp r0, #0
	beq loc_8027E52
	mov r0, #1
	strb r0, [r4,#4]
loc_8027E52:
	ldrb r6, [r5,#6]
	bl battle_BuildFolderEntryRecords_8027EE8
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	ldrb r1, [r5,#0x10]
	cmp r1, #0
	bne loc_8027E70
	ldrb r2, [r5,#0x15]
	cmp r1, r2
	beq loc_8027E70
	bl sub_8015B5C
	b loc_8027E74
loc_8027E70:
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
loc_8027E74:
	mov r7, r1
	bl sub_8027F10
	bl battle_spawnMirrorFacingHelper_80280E0
	bl selectChipTableEntryIntoActiveSlot9_80280A2
	bl sub_8027F42
	bl table_findFirstOccupiedEntry_8028050
	bl folder_findFirstChipWithFlag_802806C
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8027E2C

// symdb: Initializes the 12-entry battle-record slot array from a ROM template and sets the panel-mode/panel-flag header bytes based on the current battle mode.
// symdb: void resetBattleRecordSlots_8027E90(u32* slotArray)  // in: r4=slot array base; clobbers r0..r3,
// symdb: r6, lr; preserves r4, r5; sets NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/resetBattleRecordSlots_8027E90.yaml
	thumb_local_start
resetBattleRecordSlots_8027E90:
	push {r6,lr}
	mov r3, #0xc
	mov r2, r4
	ldr r1, off_8027EE4 // =dword_802A7CC 

loc_8027E98:
	ldr r0, [r1]
	str r0, [r2]
	mov r0, #0
	str r0, [r2,#4]
	str r0, [r2,#8]
	add r1, #4
	add r2, #0xc
	sub r3, #1
	bne loc_8027E98

	bl GetBattleMode
	cmp r0, #1
	bne loc_8027EC2
	ldr r0, off_8028118 // =dword_20349A0 
	ldrb r0, [r0,#0x4] // (byte_20349A4 - 0x20349a0)
	cmp r0, #0
	bne locret_8027EE0
	mov r0, #3
	mov r1, #0x84
	strb r0, [r4,r1]
	b locret_8027EE0
loc_8027EC2:
	bl checkBattleEventGate_8029FB4
	tst r0, r0
	beq locret_8027EE0
	mov r6, #1
	bl sub_802A57E
	tst r0, r0
	beq loc_8027ED6
	mov r6, #0
loc_8027ED6:
	mov r0, #2
	mov r1, #0x84
	strb r0, [r4,r1]
	mov r1, #0x8b
	strb r6, [r4,r1]
locret_8027EE0:
	pop {r6,pc}
	.balign 4, 0
off_8027EE4:
	.word dword_802A7CC
	thumb_func_end resetBattleRecordSlots_8027E90

// symdb: Fills 12-byte records with pointers to each chip entry in the battle folder (eBattleFolder), writing up to a caller-given slot limit.
// symdb: void sub_8027EE8(FolderRecord* dst /*r4*/, FolderHeader* src /*r5*/, u32 maxSlots /*r6*/);
// symdb: returns r2=0, r3=0 on success; on early-out r3 holds the folder's entry count byte
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_BuildFolderEntryRecords_8027EE8.yaml
	thumb_local_start
battle_BuildFolderEntryRecords_8027EE8:
	push {r4,r6,lr}
	ldrb r3, [r5,#5]
	cmp r3, #0
	beq locret_8027F0A
	cmp r6, #0
	beq locret_8027F0A
	cmp r3, r6
	blt loc_8027EFA
	mov r3, r6
loc_8027EFA:
	mov r2, #0
	ldr r1, off_8027F0C // =eBattleFolder 
loc_8027EFE:
	strb r2, [r4]
	str r1, [r4,#8]
	add r4, #0xc
	add r1, #2
	sub r3, #1
	bne loc_8027EFE
locret_8027F0A:
	pop {r4,r6,pc}
	.balign 4, 0
off_8027F0C:
	.word eBattleFolder
	thumb_func_end battle_BuildFolderEntryRecords_8027EE8

	thumb_local_start
sub_8027F10:
	push {r4,r6,lr}
	ldrb r0, [r5,#0x10]
	cmp r0, #0
	bne locret_8027F40
	cmp r7, #0xa
	beq loc_8027F20
	cmp r7, #0x16
	bne loc_8027F38
loc_8027F20:
	mov r0, #8
	mov r1, #0x60 
	add r1, r1, r4
	strb r0, [r1]
	mov r0, #9
	strb r0, [r1,#0xc]
	mov r0, #1
	ldr r2, [r5,#0x30]
	sub r0, r0, r2
	strb r0, [r1,#4]
	mov r0, #1
	strb r0, [r1,#7]
loc_8027F38:
	mov r0, #0xb
	strb r0, [r1,#3]
	mov r0, #7
	strb r0, [r1,#0xe]
locret_8027F40:
	pop {r4,r6,pc}
	thumb_func_end sub_8027F10

	thumb_local_start
sub_8027F42:
	push {r4,r6,r7,lr}
	mov r6, #0xb
loc_8027F46:
	mov r0, r6
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r7, r0
	ldrb r0, [r7]
	cmp r0, #0xa
	beq loc_8027F64
	cmp r0, #0xb
	beq loc_8027F64
	bl battle_clearActiveChipIfMegaGiga_8027F6A
	bl battle_updateActiveChipSlotId_8027F84
	bl sub_8027FDC
loc_8027F64:
	sub r6, #1
	bpl loc_8027F46
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8027F42

// symdb: After a Mega (0xA) or Giga (0xB) chip is chosen as the active chip, clears the active-chip selection index back to 0xFF (none).
// symdb: void battle_clearActiveChipIfMegaGiga(struct ActiveChipState* state) // r7 = pointer to
// symdb: folder/active-chip state block; only reads/writes its byte at +1
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_clearActiveChipIfMegaGiga_8027F6A.yaml
	thumb_local_start
battle_clearActiveChipIfMegaGiga_8027F6A:
	push {r7,lr}
	ldrb r0, [r7,#1]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r0, [r0]
	mov r1, #0xff
	cmp r0, #0xa
	beq loc_8027F7E
	cmp r0, #0xb
	bne locret_8027F82
loc_8027F7E:
	mov r0, #0xff
	strb r0, [r7,#1]
locret_8027F82:
	pop {r7,pc}
	thumb_func_end battle_clearActiveChipIfMegaGiga_8027F6A

// symdb: Looks up and stores the chip ID for the currently highlighted battle-chip slot, with a special swap for slots 5/9.
// symdb: void sub_8027F84(u32 r6_slotIndex, void* r7_chipSlotStruct);   // in: r6 = slot index (0..11,
// symdb: can be 0xA for out-of-range), r7 -> chip slot struct   //   r7[0] = slot byte (compared against
// symdb: 5 and 9)   //   r7[2] = chip ID field (read for getLocOfActiveChips lookup, written on exit)
// symdb: // out: r7[2] updated to either the looked-up chip ID or 0xFF clamp   // clobbers: r0, r1, r6,
// symdb: r7, LR, flags N Z C V   // preserved: r4
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_updateActiveChipSlotId_8027F84.yaml
	thumb_local_start
battle_updateActiveChipSlotId_8027F84:
	push {r6,r7,lr}
	ldrb r0, [r7,#2]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r0, [r0]
	mov r1, #0xff
	cmp r0, #0xa
	beq loc_8027F98
	cmp r0, #0xb
	bne locret_8027FC2
loc_8027F98:
	ldr r0, off_8027FC4 // =off_802A7FC 
	cmp r6, #0xa
	beq loc_8027FB0
	cmp r6, #5
	blt loc_8027FB0
	ldr r0, off_8027FC8 // =byte_802A804 
	ldrb r1, [r7]
	cmp r1, #9
	beq loc_8027FAE
	cmp r1, #5
	bne loc_8027FB0
loc_8027FAE:
	sub r6, #1
loc_8027FB0:
	ldr r1, off_8027FCC // =byte_8027FD0
	ldrb r1, [r1,r6]
	add r0, r0, r1
	bl sub_8028034
	cmp r0, r6
	bne loc_8027FC0
	mov r0, #0xff
loc_8027FC0:
	strb r0, [r7,#2]
locret_8027FC2:
	pop {r6,r7,pc}
	.balign 4, 0
off_8027FC4:
	.word off_802A7FC
off_8027FC8:
	.word byte_802A804
off_8027FCC:
	.word byte_8027FD0
byte_8027FD0:
	.byte 0x7, 0x6, 0x5, 0x4, 0x2, 0x11, 0x10, 0xF, 0x7, 0x1, 0x0, 0x0
	thumb_func_end battle_updateActiveChipSlotId_8027F84

// symdb: Per-frame update for the chip-select screen's "currently selected/active" chip pointer (state[3]), using a small id-indexed lookup table.
// symdb: void sub_8027FDC(void); // inputs:  r6 = chip id (0..0xB), r7 -> state struct (u8[?]) //
// symdb: outputs: r6 unchanged; state[3] rewritten (clobbers the caller's 'active chip' byte) //
// symdb: clobbers: r0, r1, flags N/Z/C/V; preserves r4, r6, r7, lr
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8027FDC.yaml
	thumb_local_start
sub_8027FDC:
	push {r6,r7,lr}
	ldrb r0, [r7,#3]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r0, [r0]
	mov r1, #0xff
	cmp r0, #0xa
	beq loc_8027FF0
	cmp r0, #0xb
	bne locret_802801A
loc_8027FF0:
	ldr r0, off_802801C // =byte_802A817
	cmp r6, #0xa
	beq loc_8028008
	cmp r6, #5
	blt loc_8028008
	ldr r0, off_8028020 // =byte_802A81F 
	ldrb r1, [r7]
	cmp r1, #8
	beq loc_8028006
	cmp r1, #4
	bne loc_8028008
loc_8028006:
	add r6, #1
loc_8028008:
	ldr r1, off_8028024 // =byte_8028028
	ldrb r1, [r1,r6]
	add r0, r0, r1
	bl sub_8028034
	cmp r0, r6
	bne loc_8028018
	mov r0, #0xff
loc_8028018:
	strb r0, [r7,#3]
locret_802801A:
	pop {r6,r7,pc}
	.balign 4, 0
off_802801C:
	.word byte_802A817
off_8028020:
	.word byte_802A81F
off_8028024:
	.word byte_8028028
byte_8028028:
	.byte 0x1, 0x2, 0x3, 0x5, 0x7, 0x1, 0x2, 0x3, 0x4, 0x5, 0x0, 0x0
	thumb_func_end sub_8027FDC

	thumb_local_start
sub_8028034:
	push {r4,lr}
	mov r4, r0
loc_8028038:
	ldrb r0, [r4]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r0, [r0]
	cmp r0, #0xa
	beq loc_8028048
	cmp r0, #0xb
	bne loc_802804C
loc_8028048:
	add r4, #1
	b loc_8028038
loc_802804C:
	ldrb r0, [r4]
	pop {r4,pc}
	thumb_func_end sub_8028034

// symdb: Scans a table of 12-byte entries for the first one whose leading byte is not the empty marker 0x0A/0x0B, and stores its index (or 0x0A if none) into record+7.
// symdb: void sub_8028050(u8 *cursor /*r4*/, u8 *record /*r5*/); tailcalls r6, preserved r4/r6, clobbers
// symdb: flags and r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/table_findFirstOccupiedEntry_8028050.yaml
	thumb_local_start
table_findFirstOccupiedEntry_8028050:
	push {r4,r6,lr}
	mov r6, #0
loc_8028054:
	ldrb r0, [r4]
	cmp r0, #0xa
	beq loc_802805E
	cmp r0, #0xb
	bne loc_8028068
loc_802805E:
	add r4, #0xc
	add r6, #1
	cmp r6, #0xc
	bne loc_8028054
	mov r6, #0xa
loc_8028068:
	strb r6, [r5,#7]
	pop {r4,r6,pc}
	thumb_func_end table_findFirstOccupiedEntry_8028050

// symdb: Scans ten folder/slot entries and records the index of the first one whose chip has flag 0x20 set in its chip-data status byte, skipping the scan if a result was already stored.
// symdb: void folder_findFirstChipWithFlag_802806C(void) /* r4 = slot list base, r5 = owner struct;
// symdb: r2/r3/r5 pass through; r4, r6 preserved; NZCV clobbered */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/folder_findFirstChipWithFlag_802806C.yaml
	thumb_local_start
folder_findFirstChipWithFlag_802806C:
	push {r4,r6,lr}
	ldrb r0, [r5,#7]
	cmp r0, #0
	bne locret_80280A0
	mov r6, #0
loc_8028076:
	ldrb r0, [r4]
	cmp r0, #0
	bne loc_8028094
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl sub_802A53C
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#9]
	mov r1, #0x20 
	tst r0, r1
	bne loc_802809E
loc_8028094:
	add r4, #0xc
	add r6, #1
	cmp r6, #0xa
	bne loc_8028076
	b locret_80280A0
loc_802809E:
	strb r6, [r5,#7]
locret_80280A0:
	pop {r4,r6,pc}
	thumb_func_end folder_findFirstChipWithFlag_802806C

// symdb: Registers one entry of an 11-entry halfword chip-selection table into the object at R5 and points active-chip slot 9 at it, skipping entries already flagged as taken.
// symdb: void selectChipTableEntryIntoActiveSlot9(R5Object* obj /* r5 */); // in: r4 (preserved), r5;
// symdb: out: r2 = (1 << index) when index is in 1..11 (set even if the entry turns out to be taken);
// symdb: clobbers nzcv, r0, r1, lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/selectChipTableEntryIntoActiveSlot9_80280A2.yaml
	thumb_local_start
selectChipTableEntryIntoActiveSlot9_80280A2:
	push {r4,lr}
	ldrb r0, [r5,#0x10]
	cmp r0, #0
	beq locret_80280DA
	cmp r0, #0xb
	bgt locret_80280DA
	ldr r1, off_8028118 // =dword_20349A0 
	ldrh r1, [r1,#0xc] // (word_20349AC - 0x20349a0)
	mov r2, #1
	lsl r2, r0
	tst r1, r2
	bne locret_80280DA
	sub r0, #1
	lsl r0, r0, #1
	ldr r1, off_80280DC // =byte_802A828 
	add r4, r0, r1
	ldrh r0, [r4]
	strh r0, [r5,#0x22]
	mov r0, #9
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r1, #0
	strb r1, [r0]
	mov r1, #0
	strb r1, [r0,#4]
	mov r1, #0x22 
	add r1, r1, r5
	str r1, [r0,#8]
locret_80280DA:
	pop {r4,pc}
	.balign 4, 0
off_80280DC:
	.word byte_802A828
	thumb_func_end selectChipTableEntryIntoActiveSlot9_80280A2

// symdb: When a trigger condition passes, initializes a helper object entry (kind 4) in the battle object array that mirrors the source object's left/right facing.
// symdb: void sub_80280E0(battlework* r4, sourceobj* r5 /* +0x10 state, +0x16 facing */); /* r6, r10
// symdb: ambient inputs per callers; returns r2 = r5->facing on the setup path; Z set if dir==0 path
// symdb: taken */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_spawnMirrorFacingHelper_80280E0.yaml
	thumb_local_start
battle_spawnMirrorFacingHelper_80280E0:
	push {r4,lr}
	ldrb r0, [r5,#0x10]
	cmp r0, #0
	bne locret_8028114
	bl battle_checkActiveSlot8NaviStatReady_802A5DA
	tst r0, r0
	beq locret_8028114
	mov r0, #4
	mov r1, #0x60 
	add r1, r1, r4
	strb r0, [r1]
	mov r0, #5
	strb r0, [r1,#0xc]
	mov r0, #1
	ldrb r2, [r5,#0x16]
	sub r0, r0, r2
	strb r0, [r1,#4]
	tst r0, r0
	bne loc_802810C
	mov r0, #1
	strb r0, [r1,#7]
loc_802810C:
	mov r0, #0xb
	strb r0, [r1,#3]
	mov r0, #7
	strb r0, [r1,#0xe]
locret_8028114:
	pop {r4,pc}
	.balign 4, 0
off_8028118:
	.word dword_20349A0
	thumb_func_end battle_spawnMirrorFacingHelper_80280E0

// symdb: Queues all pending GFX transfers for the dataList at off_802A744, then tail-calls sub_802812C with the byte at [r5+0x10].
// symdb: void gfx_flushDataListAndContinue(struct State* r5 /* plus passthrough args r2-r3 */); returns
// symdb: whatever sub_802812C returns in r0-r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/gfx_flushDataListAndContinue_802811C.yaml
	thumb_local_start
gfx_flushDataListAndContinue_802811C:
	push {lr}
	// dataList
	ldr r0, off_8028154 // =off_802A744 
	bl QueueGFXTransfersInList // (u32 *dataRefs) -> void
	ldrb r0, [r5,#0x10]
	bl gfx_queueIndexedRecordTiles_802812C
	pop {pc}
	thumb_func_end gfx_flushDataListAndContinue_802811C

// symdb: Queues the tile graphics of an indexed 0x80-byte record for VRAM transfer, split into two 0x40-byte halves at 0x060170E0/0x06017160, plus a linked 0x20-byte chunk to IWRAM at byte_30016B0.
// symdb: void gfx_queueIndexedRecordTiles(u32 recordIndex /* r0 */); preserves r4-r7, clobbers flags and
// symdb: r0-r3/lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/gfx_queueIndexedRecordTiles_802812C.yaml
	thumb_local_start
gfx_queueIndexedRecordTiles_802812C:
	push {r4,lr}
	mov r4, r0
	bl getIndexed80hRecordPtr_8028164
	ldr r1, dword_8028158 // =0x60170e0 
	mov r2, #0x40 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r0, r0, r2
	ldr r1, dword_802815C // =0x6017160 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, r4
	bl getPermutedRecord32_8028172
	ldr r1, off_8028160 // =byte_30016B0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r4,pc}
	.balign 4, 0
off_8028154:
	.word off_802A744
dword_8028158:
	.word 0x60170E0
dword_802815C:
	.word 0x6017160
off_8028160:
	.word byte_30016B0
	thumb_func_end gfx_queueIndexedRecordTiles_802812C

// symdb: Maps an index through a lookup table and returns the pointer to that entry's 0x80-byte record in the dat38_86F5834 data table.
// symdb: u8* getIndexed80hRecordPtr(u8 index)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getIndexed80hRecordPtr_8028164.yaml
	thumb_local_start
getIndexed80hRecordPtr_8028164:
	ldr r1, off_8028198 // =byte_802819C 
	ldrb r0, [r1,r0]
	mov r1, #0x80
	mul r0, r1
	ldr r1, off_8028180 // =byte_86F5834
	add r0, r0, r1
	mov pc, lr
	thumb_func_end getIndexed80hRecordPtr_8028164

// symdb: Maps a small index through a fixed permutation table and returns the address of the corresponding 32-byte record in a table at byte_86E56FC.
// symdb: int sub_8028172(int index) -> record* (r0 = index in, r0 = pointer out; r1 clobbered)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getPermutedRecord32_8028172.yaml
	thumb_local_start
getPermutedRecord32_8028172:
	ldr r1, off_8028188 // =off_802818C 
	ldrb r0, [r1,r0]
	mov r1, #0x20 
	mul r0, r1
	ldr r1, off_8028184 // =byte_86E56FC 
	add r0, r0, r1
	mov pc, lr
	.balign 4, 0
off_8028180:
	.word byte_86F5834
off_8028184:
	.word byte_86E56FC
off_8028188:
	.word off_802818C
off_802818C:
	.word unk_2010100
	.byte 0x3, 0x0, 0x4, 0x1, 0x5, 0x2, 0x6, 0x0
off_8028198:
	.word byte_802819C
byte_802819C:
	.byte 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6
	thumb_func_end getPermutedRecord32_8028172

// symdb: Returns the element/attribute data pointer for a battle chip, falling back to a default blob for the "no chip" sentinel id 0x1FF.
// symdb: void* battle_getChipElementData(i32 which_chip /* r0 */); preserves r1/r2; clobbers flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getChipElementData_80281A8.yaml
	thumb_local_start
battle_getChipElementData_80281A8:
	push {r1,r2,lr}
	ldr r2, dword_80283AC // =0x1ff 
	and r0, r2
	cmp r0, r2
	bne loc_80281B6
	ldr r0, off_80281C0 // =byte_86E601C 
	pop {r1,r2,pc}
loc_80281B6:
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldr r0, [r0,#0x20]
	pop {r1,r2,pc}
	.balign 4, 0
off_80281C0:
	.word byte_86E601C
	thumb_func_end battle_getChipElementData_80281A8

// symdb: Queues one 0x80-byte chunk of a graphics DMA transfer, using a helper to set up the next source/destination pair.
// symdb: gfx_QueueNextChunkedGfxTransfer(u32 src /*r0*/, u32 dest /*r1*/, ... /*r3 = context for
// symdb: sub_80281A8*/) -> u32 /*r1 = dest + 0x80*/; preserves r2-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/gfx_QueueNextChunkedGfxTransfer_80281C4.yaml
	thumb_local_start
gfx_QueueNextChunkedGfxTransfer_80281C4:
	push {r2,r3,lr}
	bl battle_getChipElementData_80281A8
	mov r2, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r1, #0x80
	pop {r2,r3,pc}
	thumb_func_end gfx_QueueNextChunkedGfxTransfer_80281C4

// symdb: Thin wrapper that targets one 0x80-byte OBJ tile slot in VRAM (0x0600A4A0 + 0x80*slot) and calls the tile-loading helper sub_80281C4 on it.
// symdb: void sprite_CopyObjTilesToVramSlot(u32 slot /* r1 */, ... /* r0 and r2..r7 pass through to
// symdb: sub_80281C4 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_CopyObjTilesToVramSlot_80281D4.yaml
	thumb_local_start
sprite_CopyObjTilesToVramSlot_80281D4:
	push {r1,r2,lr}
	mov r2, #0x80
	mul r2, r1
	ldr r1, dword_80281FC // =0x600a4a0 
	add r1, r1, r2
	bl gfx_QueueNextChunkedGfxTransfer_80281C4
	pop {r1,r2,pc}
	thumb_func_end sprite_CopyObjTilesToVramSlot_80281D4

	thumb_local_start
sub_80281E4:
	push {r1-r3,lr}
	mov r2, #0x80
	mul r1, r2
	ldr r3, dword_80281FC // =0x600a4a0 
	add r1, r1, r3
	mul r0, r2
	ldr r3, off_8028200 // =byte_8725894 
	add r0, r0, r3
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r1-r3,pc}
	.balign 4, 0
dword_80281FC:
	.word 0x600A4A0
off_8028200:
	.word byte_8725894
	thumb_func_end sub_80281E4

// symdb: Queues a single 0x40-byte chunk of a graphics transfer to the destination pointer in r1, then advances r1 past the chunk.
// symdb: gfx_QueueNext64ByteChunk(dest /* r1 in/out, advanced by 0x40 */) -> void; clobbers r0 (source
// symdb: address), preserves r2-r7; flags set by the r1 += 0x40 add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/gfx_QueueNext64ByteChunk_8028204.yaml
	thumb_local_start
gfx_QueueNext64ByteChunk_8028204:
	push {r2,r3,lr}
	bl data_getRecordPtrById_8028214
	mov r2, #0x40 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r1, #0x40 
	pop {r2,r3,pc}
	thumb_func_end gfx_QueueNext64ByteChunk_8028204

// symdb: Returns a pointer to a 64-byte data record selected by id, with ids 0x1B/0x1C rerouted to a special record and out-of-range ids clamped to the last table entry.
// symdb: void* data_getRecordPtrById(u32 id); // in: r0 = record id; r2 and lr preserved (lr is the
// symdb: return); out: r0 = record pointer; flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/data_getRecordPtrById_8028214.yaml
	thumb_local_start
data_getRecordPtrById_8028214:
	push {r2,lr}
	cmp r0, #0x1b
	beq loc_802822A
	cmp r0, #0x1c
	beq loc_802822A
	blt loc_8028222
	mov r0, #0x1b
loc_8028222:
	lsl r0, r0, #6
	ldr r2, off_8028230 // =dword_86E591C 
	add r0, r0, r2
	pop {r2,pc}
loc_802822A:
	ldr r0, off_8028234 // =byte_802A700 
	pop {r2,pc}
	.balign 4, 0
off_8028230:
	.word dword_86E591C
off_8028234:
	.word byte_802A700
	thumb_func_end data_getRecordPtrById_8028214

// symdb: Wipes one 0xC0-byte OBJ tile slot in VRAM (base 0x6009C20, entry index in r0) by filling it via sub_80281C4, used to free/reset a sprite's tile space.
// symdb: void sprite_clearObjVramEntry(u32 entryIndex /* r0 */); r2-r7 preserved; flags clobbered by
// symdb: callee
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_clearObjVramEntry_8028238.yaml
	thumb_local_start
sprite_clearObjVramEntry_8028238:
	push {lr}
	mov r1, #0xc0
	mul r0, r1
	ldr r1, dword_802824C // =0x6009c20 
	add r1, r1, r0
	ldr r0, dword_80283AC // =0x1ff 
	bl gfx_QueueNextChunkedGfxTransfer_80281C4
	pop {pc}
	.balign 4, 0
dword_802824C:
	.word 0x6009C20
	thumb_func_end sprite_clearObjVramEntry_8028238

	thumb_local_start
sub_8028250:
	push {r4-r7,lr}
	push {r0}
	mov r0, #0
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r4, r0
	mov r7, #0xc
	ldr r1, dword_8028358 // =0x6009c20 
loc_8028260:
	ldrb r0, [r4]
	lsl r0, r0, #2
	ldr r2, off_802836C // =off_8028370 
	ldr r0, [r2,r0]
	mov lr, pc
	bx r0
	add r4, #0xc
	sub r7, #1
	bne loc_8028260
	pop {r0}
	cmp r0, #0
	bne loc_802827E
	bl bg_ReloadTileBlock3Screen_80283B0
	b locret_8028282
loc_802827E:
	bl sub_80283C8
locret_8028282:
	pop {r4-r7,pc}
	thumb_func_end sub_8028250

// symdb: Streams the chip-icon tiles for one entry of the chip selection screen into the queued graphics transfer.
// symdb: void chipSelect_QueueEntryIconGfx_8028284(void); // entry struct in r4 (callee-local); clobbers
// symdb: r0-r1, r12?, lr, flags; preserves r2-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chipSelect_QueueEntryIconGfx_8028284.yaml
	thumb_local_start
chipSelect_QueueEntryIconGfx_8028284:
	push {r4,lr}
	ldrb r0, [r4,#7]
	cmp r0, #2
	bne loc_8028290
	ldr r0, dword_80283AC // =0x1ff 
	b loc_8028298
loc_8028290:
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
loc_8028298:
	bl gfx_QueueNextChunkedGfxTransfer_80281C4
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	lsr r0, r0, #9
	bl gfx_QueueNext64ByteChunk_8028204
	pop {r4,pc}
	thumb_func_end chipSelect_QueueEntryIconGfx_8028284

// symdb: Empty stub function that does nothing and immediately returns.
// symdb: void nullsub_14(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_14.yaml
	thumb_local_start
nullsub_14:
	mov pc, lr
	thumb_func_end nullsub_14

	thumb_local_start
sub_80282AE:
	push {lr}
	ldr r0, off_80283A0 // =byte_86E79CC
	ldr r2, off_80283A4 // =0x100 
	ldrb r3, [r4,#7]
	cmp r3, #0
	beq loc_80282BC
	add r0, r0, r2
loc_80282BC:
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {pc}
	thumb_func_end sub_80282AE

	thumb_local_start
sub_80282C2:
	push {lr}
	ldr r0, off_80283A0 // =byte_86E79CC
	ldr r2, off_80283A4 // =0x100 
	add r0, r0, r2
	add r0, r0, r2
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {pc}
	thumb_func_end sub_80282C2

	thumb_local_start
sub_80282D2:
	push {lr}
	ldr r0, off_802835C // =dword_86E441C 
	ldr r2, off_8028364 // =0x180 
	ldrb r3, [r4,#7]
	mul r3, r2
	add r0, r0, r3
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r1, #0xc0
	add r1, #0xc0
	pop {pc}
	thumb_func_end sub_80282D2

	thumb_local_start
sub_80282E8:
	push {lr}
	ldrb r0, [r4,#7]
	cmp r0, #2
	bne loc_80282F4
	ldr r0, dword_80283AC // =0x1ff 
	b loc_80282FC
loc_80282F4:
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
loc_80282FC:
	bl gfx_QueueNextChunkedGfxTransfer_80281C4
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	lsr r0, r0, #9
	bl gfx_QueueNext64ByteChunk_8028204
	pop {pc}
	thumb_func_end sub_80282E8

// symdb: Runs the standard end-of-battle-action bookkeeping, resetting a battle counter with 0x1FF and then firing scripted action 0x1D.
// symdb: void battle_endActionSetup(void) // no meaningful inputs; returns to caller via lr (r0-r1
// symdb: clobbered, flags clobbered, r2-r7 preserved)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_endActionSetup_8028310.yaml
	thumb_local_start
battle_endActionSetup_8028310:
	push {lr}
	ldr r0, dword_80283AC // =0x1ff 
	bl gfx_QueueNextChunkedGfxTransfer_80281C4
	mov r0, #0x1d
	bl gfx_QueueNext64ByteChunk_8028204
	pop {pc}
	thumb_func_end battle_endActionSetup_8028310

// symdb: Queues a chunk of battle graphics into a destination buffer, choosing between a fixed ROM chunk and a table-driven chunk based on R7.
// symdb: void sub_8028320(mut dest r1, arg r2, arg r4, arg r5, arg r6, selector r7); clobbers r0-r3 and
// symdb: nz/c/v, preserves r4-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_loadGfxChunkBySelector_8028320.yaml
	thumb_local_start
battle_loadGfxChunkBySelector_8028320:
	push {lr}
	cmp r7, #1
	bne loc_8028334
	ldr r0, off_80283A0 // =byte_86E79CC
	ldr r2, off_80283A8 // =0x300 
	add r0, r0, r2
	ldr r2, off_80283A4 // =0x100 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	b locret_802833E
loc_8028334:
	ldr r0, off_8028368 // =byte_802A700 
	mov r3, #3
	bl sub_802868C
	add r1, #0xc0
locret_802833E:
	pop {pc}
	thumb_func_end battle_loadGfxChunkBySelector_8028320

	thumb_local_start
sub_8028340:
	push {lr}
	ldr r0, off_8028360 // =dword_86E4D9C 
	ldr r2, off_8028364 // =0x180 
	ldrb r3, [r4,#7]
	mul r3, r2
	add r0, r0, r3
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r1, #0xc0
	add r1, #0xc0
	pop {pc}
	.balign 4, 0
dword_8028358:
	.word 0x6009C20
off_802835C:
	.word dword_86E441C
off_8028360:
	.word dword_86E4D9C
off_8028364:
	.word 0x180
off_8028368:
	.word byte_802A700
off_802836C:
	.word off_8028370
off_8028370:
	.word chipSelect_QueueEntryIconGfx_8028284+1
	.word nullsub_14+1
	.word sub_80282AE+1
	.word sub_80282C2+1
	.word sub_80282D2+1
	.word nullsub_14+1
	.word sub_80282E8+1
	.word sub_80282E8+1
	.word sub_8028340+1
	.word nullsub_14+1
	.word battle_endActionSetup_8028310+1
	.word battle_loadGfxChunkBySelector_8028320+1
off_80283A0:
	.word byte_86E79CC
off_80283A4:
	.word 0x100
off_80283A8:
	.word 0x300
dword_80283AC:
	.word 0x1FF
	thumb_func_end sub_8028340

// symdb: Runs a companion setup routine (sub_80283C8) and then loads a 15x6-tile background screen from the tile map at unk_2035186 into 32x32 tile block 3.
// symdb: void sub_80283B0(void) — takes no meaningful inputs (r4/r5/r10 are caller state it must
// symdb: preserve); returns nothing, with r0-r3 and NZCV left as CopyBackgroundTiles leaves them
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/bg_ReloadTileBlock3Screen_80283B0.yaml
	thumb_local_start
bg_ReloadTileBlock3Screen_80283B0:
	push {r4,r5,lr}
	bl sub_80283C8
	// j
	mov r0, #0
	// i
	mov r1, #0xd
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_8028468 // =unk_2035186 
	mov r4, #0xf
	mov r5, #6
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4,r5,pc}
	thumb_func_end bg_ReloadTileBlock3Screen_80283B0

// symdb: Sets the OBPalette index on each of the ten active-chip icon sprites on the custom-screen based on the slot's chip kind.
// symdb: void recolorActiveChipIcons_80283C8(void); // returns in r0/r1/r2 various leftovers (see
// symdb: details); clobbers r6,r7; preserves r4,r5; returns via lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_80283C8.yaml
	thumb_local_start
sub_80283C8:
	push {r4,r5,lr}
	mov r0, #0
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r7, r0
	mov r6, #0
loc_80283D4:
	mov r2, #0
	ldrb r0, [r7]
	cmp r0, #1
	beq loc_802842C
	cmp r0, #2
	beq loc_802842C
	cmp r0, #3
	beq loc_802842C
	cmp r0, #0xa
	beq loc_8028400
	cmp r0, #6
	beq loc_80283F8
	cmp r0, #7
	beq loc_80283F8
	cmp r0, #0
	beq loc_80283F8
	mov r2, #4
	b loc_8028400
loc_80283F8:
	ldrb r0, [r7,#7]
	cmp r0, #1
	bne loc_8028400
	mov r2, #2
loc_8028400:
	ldr r4, off_8028438 // =off_802843C 
	lsl r0, r6, #2
	ldr r4, [r4,r0]
	ldr r1, off_802846C // =byte_8028470
	ldrh r2, [r1,r2]
	ldr r1, dword_8028464 // =0x3ff 
	ldrh r0, [r4]
	and r0, r1
	orr r0, r2
	strh r0, [r4]
	ldrh r0, [r4,#2]
	and r0, r1
	orr r0, r2
	strh r0, [r4,#2]
	ldrh r0, [r4,#0x1e]
	and r0, r1
	orr r0, r2
	strh r0, [r4,#0x1e]
	ldrh r0, [r4,#0x20]
	and r0, r1
	orr r0, r2
	strh r0, [r4,#0x20]
loc_802842C:
	add r7, #0xc
	add r6, #1
	cmp r6, #0xa
	blt loc_80283D4
	pop {r4,r5,pc}
	.balign 4, 0
off_8028438:
	.word off_802843C
off_802843C:
	.word unk_2035188
	.word unk_203518C
	.word unk_2035190
	.word unk_2035194
	.word unk_2035198
	.byte 0xE2, 0x51, 0x3, 0x2, 0xE6, 0x51, 0x3, 0x2, 0xEA, 0x51, 0x3
	.byte 0x2, 0xEE, 0x51, 0x3, 0x2, 0xF2, 0x51, 0x3, 0x2
dword_8028464:
	.word 0x3FF
off_8028468:
	.word unk_2035186
off_802846C:
	.word byte_8028470
byte_8028470:
	.byte 0x0, 0xB0, 0x0, 0xC0, 0x0, 0x90
	thumb_func_end sub_80283C8

// symdb: For a battle object, look up the side's active-chip entry and dispatch on its kind byte to the matching handler (chip activation, beast-out palette GFX, or one of several chip-side effects).
// symdb: // void sub_8028476(u32 r5_battleObject) //   reads r2 r3 r5 r6 r8 r9 r10 r11 r12 lr as inputs,
// symdb: ignores them //   writes r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 lr as outputs (whichever callees
// symdb: leave behind) //   clobbers N Z C V and r0 //   preserves r4, r7 //   uses r5 as the battle
// symdb: object pointer and reads its side byte at +7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8028476.yaml
	thumb_local_start
sub_8028476:
	push {lr}
	ldrb r0, [r5,#7]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r1, [r0]
	cmp r1, #0
	beq loc_80284AA
	cmp r1, #1
	beq loc_80284B8
	cmp r1, #2
	beq loc_80284BE
	cmp r1, #4
	beq loc_80284C4
	cmp r1, #5
	beq loc_80284C4
	cmp r1, #6
	beq loc_80284CA
	cmp r1, #7
	beq loc_80284CA
	cmp r1, #3
	beq loc_80284D4
	cmp r1, #8
	beq loc_80284DA
	cmp r1, #9
	beq loc_80284DA
	b locret_80284E0
loc_80284AA:
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	bl sub_80284E2
	b locret_80284E0
loc_80284B8:
	bl beastout_QueuePaletteGFXAndSheets_80286D4
	b locret_80284E0
loc_80284BE:
	bl sub_802871C
	b locret_80284E0
loc_80284C4:
	bl sub_80287A4
	b locret_80284E0
loc_80284CA:
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	bl sub_80285FE
	b locret_80284E0
loc_80284D4:
	bl sub_8028754
	b locret_80284E0
loc_80284DA:
	bl sub_802877C
	b locret_80284E0
locret_80284E0:
	pop {pc}
	thumb_func_end sub_8028476

	thumb_local_start
sub_80284E2:
	push {r4,lr}
	sub sp, sp, #0x10
	str r0, [sp]
	push {r0-r7}
	bl chip_SelectNameTextTable_8027D10
	ldr r2, off_8028674 // =byte_203C4E0 
	ldr r3, dword_8028678 // =0x6009360 
	mov r4, #8
	mov r5, #1
	ldr r6, off_802867C // =dword_86B7AE0 
	mov r7, #8
	bl renderTextGfx_8045F8C
	pop {r0-r7}
	ldr r0, [sp]
	ldr r1, dword_8028688 // =0x1ff 
	and r0, r1
	push {r0}
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r1, [r1,#oBattleState_Unk_0d]
	bl sub_80109A4
	str r0, [sp,#0x10]
	pop {r0}
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	str r0, [sp,#4]
	ldr r0, [r0,#0x24]
	cmp r0, #0
	beq loc_8028536
	ldr r1, dword_802865C // =0x6009560 
	ldr r2, dword_8028660 // =0x540
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, [sp,#4]
	ldr r0, [r0,#0x28]
	ldr r1, off_8028664 // =unk_3001AA0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_8028536:
	ldr r1, [sp,#4]
	ldrb r0, [r1,#7]
	ldrb r1, [r1,#9]
	cmp r0, #2
	ble loc_8028544
	mov r0, #0
	b loc_802854C
loc_8028544:
	mov r2, #0x20 
	tst r1, r2
	beq loc_802854C
	mov r0, #3
loc_802854C:
	mov r2, #0x20 
	mul r0, r2
	ldr r1, off_8028818 // =byte_86E587C 
	add r0, r0, r1
	ldr r1, off_802881C // =unk_3001A80 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, [sp]
	lsr r0, r0, #9
	cmp r0, #0x1c
	bne loc_8028564
	mov r0, #0x1b
loc_8028564:
	mov r1, #0x40 
	mul r0, r1
	ldr r1, off_8028640 // =dword_86E2E98 
	add r0, r0, r1
	ldr r1, dword_8028644 // =0x6009aa0 
	mov r2, #0x40 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, [sp,#4]
	ldrb r1, [r0,#9]
	mov r2, #0x12
	and r1, r2
	str r1, [sp,#8]
	ldrb r0, [r0,#6]
	push {r0}
	mov r2, #0x80
	mul r0, r2
	ldr r1, off_8028648 // =dword_86E3598 
	add r0, r0, r1
	ldr r1, dword_802864C // =0x6009ae0 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r0}
	mov r2, #0xc
	mul r0, r2
	ldr r1, off_8028680 // =dword_86E3B18 
	add r0, r0, r1
	ldr r1, off_8028684 // =unk_3001AD4 
	bl QueueWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, [sp,#8]
	cmp r0, #0
	beq loc_80285C6
	ldr r0, [sp]
	cmp r0, #0x55 
	bne loc_80285B8
	mov r4, #0xaa
	lsl r4, r4, #4
	add r4, #0xa
	mov r0, #3
	str r0, [sp,#8]
	b loc_80285D4
loc_80285B8:
	ldr r0, [sp,#0xc]
	bl memory_bcdConvert
	mov r4, r0
	bl countHexDigits_8000C5C
	str r0, [sp,#8]
loc_80285C6:
	mov r3, #3
	sub r3, r3, r0
	beq loc_80285D4
	ldr r0, off_8028668 // =byte_802A6C0 
	ldr r1, dword_8028654 // =0x6009b60 
	bl sub_802868C
loc_80285D4:
	ldr r3, [sp,#8]
	cmp r3, #0
	beq loc_80285FA
	ldr r1, dword_8028658 // =0x6009be0 
loc_80285DC:
	mov r0, #0xf
	and r0, r4
	lsr r4, r4, #4
	mov r2, #0x40 
	mul r0, r2
	ldr r2, off_8028650 // =dword_86E411C 
	add r0, r0, r2
	mov r2, #0x40 
	push {r3}
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r3}
	sub r1, #0x40 
	sub r3, #1
	bne loc_80285DC
loc_80285FA:
	add sp, sp, #0x10
	pop {r4,pc}
	thumb_func_end sub_80284E2

	thumb_local_start
sub_80285FE:
	push {r4,lr}
	push {r0-r7}
	bl chip_SelectNameTextTable_8027D10
	ldr r2, off_8028674 // =byte_203C4E0 
	ldr r3, dword_8028678 // =0x6009360 
	mov r4, #8
	mov r5, #1
	ldr r6, off_802867C // =dword_86B7AE0 
	mov r7, #8
	bl renderTextGfx_8045F8C
	pop {r0-r7}
	ldr r1, dword_8028688 // =0x1ff 
	and r0, r1
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r4, r0
	ldr r0, [r0,#0x24]
	cmp r0, #0
	beq loc_802863A
	ldr r1, dword_802865C // =0x6009560 
	ldr r2, dword_8028660 // =0x540
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, [r4,#0x28]
	ldr r1, off_8028664 // =unk_3001AA0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_802863A:
	bl beastout_LoadSelectionScreenSpriteSheets_802869E
	pop {r4,pc}
	.balign 4, 0
off_8028640:
	.word dword_86E2E98
dword_8028644:
	.word 0x6009AA0
off_8028648:
	.word dword_86E3598
dword_802864C:
	.word 0x6009AE0
off_8028650:
	.word dword_86E411C
dword_8028654:
	.word 0x6009B60
dword_8028658:
	.word 0x6009BE0
dword_802865C:
	.word 0x6009560
dword_8028660:
	.word 0x540
off_8028664:
	.word unk_3001AA0
off_8028668:
	.word byte_802A6C0
	.word byte_802A680
	.word byte_203C4E0
off_8028674:
	.word byte_203C4E0
dword_8028678:
	.word 0x6009360
off_802867C:
	.word dword_86B7AE0
off_8028680:
	.word dword_86E3B18
off_8028684:
	.word unk_3001AD4
dword_8028688:
	.word 0x1FF
	thumb_func_end sub_80285FE

	thumb_local_start
sub_802868C:
	push {r0-r4,lr}
	mov r4, r3
	mov r2, #0x40 
loc_8028692:
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r1, r1, r2
	sub r4, #1
	bne loc_8028692
	pop {r0-r4,pc}
	thumb_func_end sub_802868C

// symdb: Loads the three sprite sheets used by the Beast Out selection screen into VRAM slots 1-3 via sub_802868C.
// symdb: void sub_802869E(int r2 /* forwarded to sub_802868C, untouched */); returns with r1=0x6009B60
// symdb: and r3=3 from the last call setup
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/beastout_LoadSelectionScreenSpriteSheets_802869E.yaml
	thumb_local_start
beastout_LoadSelectionScreenSpriteSheets_802869E:
	push {lr}
	ldr r1, dword_80286C0 // =0x6009aa0 
	ldr r0, off_80286D0 // =byte_802A6C0 
	mov r3, #1
	bl sub_802868C
	ldr r1, dword_80286C4 // =0x6009ae0 
	ldr r0, off_80286CC // =byte_802A680 
	mov r3, #2
	bl sub_802868C
	ldr r1, dword_80286C8 // =0x6009b60 
	ldr r0, off_80286D0 // =byte_802A6C0 
	mov r3, #3
	bl sub_802868C
	pop {pc}
	.balign 4, 0
dword_80286C0:
	.word 0x6009AA0
dword_80286C4:
	.word 0x6009AE0
dword_80286C8:
	.word 0x6009B60
off_80286CC:
	.word byte_802A680
off_80286D0:
	.word byte_802A6C0
	thumb_func_end beastout_LoadSelectionScreenSpriteSheets_802869E

// symdb: Beast-Out selection helper: calls sub_80287D2, then queues two GFX DMA tiles (map+tileset) chosen by the state's alliance byte, then loads selection-screen sprite sheets.
// symdb: void sub_80286D4(void); // in: r5 = state pointer; out: r1..r7, lr clobbered; r4-r7 preserved;
// symdb: NZCV clobbered.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/beastout_QueuePaletteGFXAndSheets_80286D4.yaml
	thumb_local_start
beastout_QueuePaletteGFXAndSheets_80286D4:
	push {lr}
	bl loadOneSpriteTileRow_80287D2
	ldr r0, off_8028704 // =off_8028708 
	ldrb r1, [r5,#8]
	cmp r1, #0
	beq loc_80286E4
	mov r1, #4
loc_80286E4:
	push {r1}
	ldr r0, [r0,r1]
	ldr r1, dword_80287F0 // =0x6009560 
	ldr r2, dword_80287F4 // =0x540
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r1}
	ldr r0, off_8028710 // =off_8028714 
	ldr r0, [r0,r1]
	ldr r1, off_80287FC // =unk_3001AA0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	bl beastout_LoadSelectionScreenSpriteSheets_802869E
	pop {pc}
	.balign 4, 0
off_8028704:
	.word off_8028708
off_8028708:
	.word dword_8722AF4
	.word dword_87225B4
off_8028710:
	.word off_8028714
off_8028714:
	.word dword_8725874
	.word dword_87257F4
	thumb_func_end beastout_QueuePaletteGFXAndSheets_80286D4

	thumb_local_start
sub_802871C:
	push {lr}
	bl loadOneSpriteTileRow_80287D2
	ldr r0, off_802874C // =byte_8723034 
	ldr r1, dword_80287F0 // =0x6009560 
	ldr r2, dword_80287F4 // =0x540
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #0xb
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r0, [r0,#6]
	mov r1, #0x20 
	mul r1, r0
	ldr r0, off_8028750 // =dword_8725814 
	add r0, r0, r1
	ldr r1, off_80287FC // =unk_3001AA0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	bl beastout_LoadSelectionScreenSpriteSheets_802869E
	pop {pc}
	.balign 4, 0
off_802874C:
	.word byte_8723034
off_8028750:
	.word dword_8725814
	thumb_func_end sub_802871C

	thumb_local_start
sub_8028754:
	push {lr}
	bl loadOneSpriteTileRow_80287D2
	ldr r0, off_8028774 // =dword_87225B4 
	ldr r1, dword_80287F0 // =0x6009560 
	ldr r2, dword_80287F4 // =0x540
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, off_8028778 // =dword_87257D4 
	ldr r1, off_80287FC // =unk_3001AA0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	bl beastout_LoadSelectionScreenSpriteSheets_802869E
	pop {pc}
	.balign 4, 0
off_8028774:
	.word dword_87225B4
off_8028778:
	.word dword_87257D4
	thumb_func_end sub_8028754

	thumb_local_start
sub_802877C:
	push {lr}
	bl loadOneSpriteTileRow_80287D2
	ldr r0, off_802879C // =dword_8733E74 
	ldr r1, dword_80287F0 // =0x6009560 
	ldr r2, dword_80287F4 // =0x540
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, off_80287A0 // =dword_87343D4 
	ldr r1, off_80287FC // =unk_3001AA0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	bl beastout_LoadSelectionScreenSpriteSheets_802869E
	pop {pc}
	.balign 4, 0
off_802879C:
	.word dword_8733E74
off_80287A0:
	.word dword_87343D4
	thumb_func_end sub_802877C

	thumb_local_start
sub_80287A4:
	push {lr}
	ldrb r1, [r0]
	cmp r1, #5
	bne loc_80287AE
	sub r0, #0xc
loc_80287AE:
	ldrb r0, [r0,#4]
	push {r0}
	bl loadOneSpriteTileRow_80287D2
	ldr r0, off_80287EC // =dword_8722AF4 
	ldr r1, dword_80287F0 // =0x6009560 
	ldr r2, dword_80287F4 // =0x540
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, off_80287F8 // =dword_8725854 
	ldr r1, off_80287FC // =unk_3001AA0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	bl beastout_LoadSelectionScreenSpriteSheets_802869E
	pop {r0}
	pop {pc}
	thumb_func_end sub_80287A4

// symdb: Prime the engine's sprite descriptor slot from the local descriptor table and queue a 0x20-byte tile row of sprite graphics from ROM into VRAM.
// symdb: void sub_80287D2(/* r2 r4 r5 r6 r7 preserved, lr preserved */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/loadOneSpriteTileRow_80287D2.yaml
	thumb_local_start
loadOneSpriteTileRow_80287D2:
	push {lr}
	ldr r1, dword_8028808 // =0x6009360 
	ldr r0, off_802880C // =byte_802A6C0 
	mov r3, #8
	bl sub_802868C
	ldr r0, off_8028818 // =byte_86E587C 
	ldr r1, off_802881C // =unk_3001A80 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {pc}
	.balign 4, 0
off_80287EC:
	.word dword_8722AF4
dword_80287F0:
	.word 0x6009560
dword_80287F4:
	.word 0x540
off_80287F8:
	.word dword_8725854
off_80287FC:
	.word unk_3001AA0
	.word 0x6009AA0
	.word byte_802A6C0
dword_8028808:
	.word 0x6009360
off_802880C:
	.word byte_802A6C0
	.word dword_86E411C
	.word 0x6009BE0
off_8028818:
	.word byte_86E587C
off_802881C:
	.word unk_3001A80
	thumb_func_end loadOneSpriteTileRow_80287D2

	thumb_local_start
sub_8028820:
	push {r4-r6,lr}
	ldrb r0, [r5,#7]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r0, [r0]
	lsl r0, r0, #2
	ldr r1, off_8028868 // =jt_802886C 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	ldr r5, [r5,#0x40]
	mov r4, #1
	lsr r5, r5, #3
	and r5, r4
	sub r0, #3
	sub r1, #3
	lsl r0, r0, #0x10
	add r0, r0, r1
	mov r4, r0
	mov r2, #1
	mov r3, #0
	ldr r1, dword_8028864 // =0xb764 
	add r1, r1, r5
	lsl r5, r5, #4
	add r5, r5, r6
	mov r6, #0xc
loc_8028854:
	ldr r0, [r5,r6]
	add r0, r0, r4
	bl fifo_pushRecord16_8009FF8
	sub r6, #4
	bpl loc_8028854
	pop {r4-r6,pc}
	.balign 4, 0
dword_8028864:
	.word 0xB764
off_8028868:
	.word jt_802886C
jt_802886C:
	.word sub_8028894+1
	.word loadConstArgsAndPairTable_80288D0+1
	.word sub_8028904+1
	.word sub_8028968+1
	.word sub_8028938+1
	.word sub_8028938+1
	.word sub_8028894+1
	.word sub_8028894+1
	.word sub_8028938+1
	.word sub_8028938+1
	thumb_func_end sub_8028820

// symdb: Reads an ID byte from a work area and returns a pair of structure offsets (r0 = id*16+8, r1 = 0x68 or 0x80) plus the address of a small lookup table in r6.
// symdb: int sub_8028894(void* r5) // in: r5 = struct pointer whose +7 byte is the ID, lr = return; out:
// symdb: r0 = (id % group)*16 + 8, r1 = 0x68 or 0x68+0x18, r6 = &byte_80288B0, NZCV set from the final
// symdb: add
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8028894.yaml
	thumb_local_start
sub_8028894:
	push {lr}
	ldr r6, off_80288AC // =byte_80288B0
	mov r1, #0
	ldrb r0, [r5,#7]
	cmp r0, #5
	blt loc_80288A4
	mov r1, #0x18
	sub r0, #5
loc_80288A4:
	lsl r0, r0, #4
	add r0, #8
	add r1, #0x68 
	pop {pc}
	.balign 4, 0
off_80288AC:
	.word byte_80288B0
byte_80288B0:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xE, 0x10, 0xE, 0x0, 0xE, 0x30, 0xE
	.byte 0x0, 0x0, 0x20, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0xC, 0x10, 0xC, 0x0
	.byte 0xC, 0x30, 0xC, 0x0, 0x1, 0x20
	thumb_func_end sub_8028894

// symdb: Pure constant-setup stub that returns fixed arguments (0x5B, 0x6E) and a pointer to a 16-entry byte-pair table for the caller's next operation, likely dialog/menu or animation parameters.
// symdb: void sub_80288D0(void) -> r0=0x5B, r1=0x6E, r6=&byte_80288E4; NZCV set as if by CMP 0x70,2 (N=0
// symdb: Z=0 C=1 V=0); no inputs besides lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/loadConstArgsAndPairTable_80288D0.yaml
	thumb_local_start
loadConstArgsAndPairTable_80288D0:
	push {lr}
	mov r0, #0x58 
	mov r1, #0x70 
	add r0, #3
	sub r1, #2
	ldr r6, off_80288E0 // =byte_80288E4
	pop {pc}
	.byte 0, 0
off_80288E0:
	.word byte_80288E4
byte_80288E4:
	.byte 0x2, 0x0, 0x1, 0x0, 0x2, 0x0, 0x16, 0x10, 0x14, 0x0, 0x16, 0x30
	.byte 0x14, 0x0, 0x1, 0x20, 0x4, 0x0, 0x3, 0x0, 0x4, 0x0, 0x14, 0x10
	.byte 0x12, 0x0, 0x14, 0x30, 0x12, 0x0, 0x3, 0x20
	thumb_func_end loadConstArgsAndPairTable_80288D0

	thumb_local_start
sub_8028904:
	push {lr}
	mov r0, #0x58 
	mov r1, #0x88
	add r0, #3
	sub r1, #1
	ldr r6, off_8028914 // =byte_8028918
	pop {pc}
	.balign 4, 0x00
off_8028914:
	.word byte_8028918
byte_8028918:
	.byte 0x2, 0x0, 0x1, 0x0, 0x2, 0x0, 0x16, 0x10, 0xE, 0x0, 0x16, 0x30, 0xE
	.byte 0x0, 0x1, 0x20, 0x3, 0x0, 0x2, 0x0, 0x3, 0x0, 0x15, 0x10, 0xD, 0x0
	.byte 0x15, 0x30, 0xD, 0x0, 0x2, 0x20
	thumb_func_end sub_8028904

	thumb_local_start
sub_8028938:
	push {lr}
	mov r0, #0x38 
	mov r1, #0x80
	ldr r6, off_8028944 // =byte_8028948 
	pop {pc}
	.balign 4, 0x00
off_8028944:
	.word byte_8028948
byte_8028948:
	.byte 0x2, 0x0, 0x2, 0x0, 0x2, 0x0, 0x1C, 0x10, 0x14, 0x0, 0x1C, 0x30
	.byte 0x14, 0x0, 0x2, 0x20, 0x4, 0x0, 0x4, 0x0, 0x4, 0x0, 0x1A, 0x10
	.byte 0x12, 0x0, 0x1A, 0x30, 0x12, 0x0, 0x4, 0x20
	thumb_func_end sub_8028938

	thumb_local_start
sub_8028968:
	push {lr}
	mov r0, #0x58 
	mov r1, #0x88
	add r0, #3
	sub r1, #2
	ldr r6, off_8028978 // =byte_802897C
	pop {pc}
	.balign 4, 0x00
off_8028978:
	.word byte_802897C
byte_802897C:
	.byte 0x2, 0x0, 0x2, 0x0, 0x2, 0x0, 0x16, 0x10, 0xE, 0x0, 0x16, 0x30, 0xE
	.byte 0x0, 0x2, 0x20, 0x3, 0x0, 0x3, 0x0, 0x3, 0x0, 0x15, 0x10, 0xD, 0x0
	.byte 0x15, 0x30, 0xD, 0x0, 0x3, 0x20
	thumb_func_end sub_8028968

// symdb: During an active battle effect, queues a 0x200-byte graphics block (selected by the object's gfx-bank field) into VRAM at 0x6016CC0, then pushes a cartridge-side FIFO record.
// symdb: void battleStreamingGfxTransfer_802899C(u32 /*r5*/ battleObj, u32 /*r10*/ toolkit)     /*
// symdb: preserves: r4-r7 */     /* returns: nz/c/v set on the not-skipped path (whatever
// symdb: fifo_pushRecord16_8009FF8 leaves),        or nz/c/v from the `cmp r0,#0` early-exit path; r0-r3
// symdb: clobbered. */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802899C.yaml
	thumb_local_start
sub_802899C:
	push {r4-r6,lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#0x17]
	cmp r0, #0
	beq locret_80289CE
	ldr r5, [r5,#0x40]
	mov r4, #7
	and r4, r5
	bne loc_80289C2
	mov r3, #8
	and r3, r5
	lsl r3, r3, #6
	ldr r0, off_80289D8 // =dword_86E1238 
	ldr r1, dword_80289DC // =0x6016cc0 
	ldr r2, dword_80289E0 // =0x200
	add r0, r0, r3
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_80289C2:
	ldr r0, dword_80289D0 // =0x80020064 
	ldr r1, dword_80289D4 // =0xb766 
	mov r2, #1
	mov r3, #0
	bl fifo_pushRecord16_8009FF8
locret_80289CE:
	pop {r4-r6,pc}
	.balign 4, 0
dword_80289D0:
	.word 0x80020064
dword_80289D4:
	.word 0xB766
off_80289D8:
	.word dword_86E1238
dword_80289DC:
	.word 0x6016CC0
dword_80289E0:
	.word 0x200
	thumb_func_end sub_802899C

	thumb_local_start
sub_80289E4:
	push {r4-r6,lr}
	mov r0, #8
	mov r1, #8
	ldrb r2, [r5,#0x1b]
	mov r3, #0x10
	mul r2, r3
	add r1, r1, r2
	ldr r5, [r5,#0x40]
	mov r4, #1
	lsr r5, r5, #3
	and r5, r4
	sub r0, #3
	sub r1, #3
	lsl r0, r0, #0x10
	add r0, r0, r1
	mov r4, r0
	mov r2, #1
	mov r3, #0
	ldr r1, dword_8028A28 // =0xe792 
	add r1, r1, r5
	add r1, r1, r5
	ldr r5, off_8028A2C // =byte_8028A30 
	mov r6, #0
loc_8028A12:
	ldr r0, [r5,r6]
	add r0, r0, r4
	cmp r6, #0x10
	bne loc_8028A1C
	add r1, #1
loc_8028A1C:
	bl fifo_pushRecord16_8009FF8
	add r6, #4
	cmp r6, #0x48 
	blt loc_8028A12
	pop {r4-r6,pc}
	.balign 4, 0
dword_8028A28:
	.word 0xE792
off_8028A2C:
	.word byte_8028A30
byte_8028A30:
	.byte 0x2, 0x0, 0x3, 0x0, 0x2, 0x0, 0x43, 0x10, 0xC, 0x0, 0x43, 0x30, 0xC
	.byte 0x0, 0x3, 0x20, 0x2, 0x0, 0xB, 0x0, 0x2, 0x0, 0x13, 0x0, 0x2, 0x0
	.byte 0x1B, 0x0, 0x2, 0x0, 0x23, 0x0, 0x2, 0x0, 0x2B, 0x0, 0x2, 0x0, 0x33
	.byte 0x0, 0x2, 0x0, 0x3B, 0x0, 0xC, 0x0, 0xB, 0x20, 0xC, 0x0, 0x13, 0x20
	.byte 0xC, 0x0, 0x1B, 0x20, 0xC, 0x0, 0x23, 0x20, 0xC, 0x0, 0x2B, 0x20, 0xC
	.byte 0x0, 0x33, 0x20, 0xC, 0x0, 0x3B, 0x20
	thumb_func_end sub_80289E4

	thumb_local_start
sub_8028A78:
	push {r4,lr}
	ldrb r4, [r5,#0x1b]
	ldrb r0, [r5,#0x19]
	tst r0, r0
	bne loc_8028B00
	ldrh r0, [r7,#4]
	mov r1, #0x40 
	tst r0, r1
	beq loc_8028A98
	sub r4, #1
	cmp r4, #0
	bge loc_8028AAA
	ldrb r1, [r5,#0x18]
	sub r1, #1
	mov r4, r1
	b loc_8028AAA
loc_8028A98:
	mov r1, #0x80
	tst r0, r1
	beq loc_8028ABA
	add r4, #1
	ldrb r1, [r5,#0x18]
	sub r1, #1
	cmp r4, r1
	ble loc_8028AAA
	mov r4, #0
loc_8028AAA:
	strb r4, [r5,#0x1b]
	ldrb r0, [r5,#0x18]
	cmp r0, #1
	ble locret_8028B66
	mov r0, #SOUND_MENU_CUR_MOVE
	bl PlaySoundEffect
	b locret_8028B66
loc_8028ABA:
	ldrh r0, [r7,#2]
	mov r1, #1
	tst r0, r1
	beq loc_8028B00
	bl custMenu_80298F4
	cmp r0, #0
	bne locret_8028B66
	mov r0, r4
	ldr r1, dword_8028B70 // =0x55 
	add r1, r1, r0
	ldrb r0, [r5,r1]
	cmp r0, #1
	beq loc_8028AF8
	mov r0, #1
	strb r0, [r5,r1]
	mov r0, r4
	ldr r1, off_8028B6C // =0x50 
	add r1, r1, r0
	ldrb r0, [r5,r1]
	strb r0, [r5,#0x1a]
	mov r0, #1
	strb r0, [r5,#0x19]
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r0, #0x5c 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b locret_8028B66
loc_8028AF8:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	b locret_8028B66
loc_8028B00:
	ldrh r0, [r7,#2]
	mov r1, #2
	tst r0, r1
	beq loc_8028B1A
	bl battleTutorial_first_checkTextStep_8029B1C
	cmp r0, #0
	bne locret_8028B66
	mov r0, #0x50 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b locret_8028B66
loc_8028B1A:
	mov r1, #8
	tst r0, r1
	beq loc_8028B34
	mov r1, #0xa
	strb r1, [r5,#7]
	mov r0, #0x50 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov r0, #SOUND_MENU_CUR_MOVE
	bl PlaySoundEffect
	b locret_8028B66
loc_8028B34:
	mov r1, #4
	tst r0, r1
	beq loc_8028B3C
	b locret_8028B66
loc_8028B3C:
	ldr r1, off_8028CC4 // =0x100 
	tst r0, r1
	beq locret_8028B66
	ldrb r0, [r5,#7]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldr r0, off_8028B68 // =TextScriptChipDesc86EF4D4
	ldrb r1, [r5,#0x1b]
	ldr r2, off_8028B6C // =0x50 
	add r2, r2, r1
	ldrb r1, [r5,r2]
	add r1, #5
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	mov r0, #0x9c
	bl PlaySoundEffect
	mov r0, #0x58 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_8028B66:
	pop {r4,pc}
	.balign 4, 0
off_8028B68:
	.word TextScriptChipDesc86EF4D4
off_8028B6C:
	.word 0x50
dword_8028B70:
	.word 0x55
	thumb_func_end sub_8028A78

	thumb_local_start
custMenuSomeHandler_8028B74: // (self: * S20364C0 $r5) -> ()
	push {r4,lr}
  
	ldrb r0, [r5,#oS20364C0_ChipSelectCursorPos]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*

	mov r4, r0
	ldrh r0, [r7,#4]
	mov r1, #0xc0
	tst r0, r1
	beq loc_8028BC2
	push {r0}
	bl GetBattleMode
	cmp r0, #1
	pop {r0}
	beq loc_8028BBE

	ldrb r2, [r5,#oS20364C0_Unk_10]
	cmp r2, #0
	bne loc_8028BBE

	ldrb r2, [r5,#oS20364C0_Unk_17]
	tst r2, r2
	bne loc_8028BBE

	ldrb r2, [r5,#oS20364C0_Unk_18]
	tst r2, r2
	beq loc_8028BBE

	mov r1, #0x40 
	tst r0, r1
	beq loc_8028BBE

	ldrb r0, [r5,#oS20364C0_ChipSelectCursorPos]
	cmp r0, #0xa
	beq loc_8028BB4

	cmp r0, #4
	bgt loc_8028BBE
loc_8028BB4:

	// trigger sub_8027834 via custMenuMainMaybe_8026A88
	mov r0, #0x4c 
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]

	b locret_8028C96
loc_8028BBE:
	ldrb r0, [r4,#1]
	b loc_8028BD4
loc_8028BC2:
	mov r1, #0x20 
	tst r0, r1
	beq loc_8028BCC
	ldrb r0, [r4,#2]
	b loc_8028BD4
loc_8028BCC:
	mov r1, #0x10
	tst r0, r1
	beq loc_8028BEC
	ldrb r0, [r4,#3]
loc_8028BD4:
	cmp r0, #0xff
	beq locret_8028C96
loc_8028BD8:
	ldrb r1, [r5,#oS20364C0_ChipSelectCursorPos]
	cmp r0, r1
	beq loc_8028BE6

	strb r0, [r5,#oS20364C0_ChipSelectCursorPos]

	mov r0, #SOUND_MENU_CUR_MOVE
	bl PlaySoundEffect
loc_8028BE6:
	bl sub_8028476
	b locret_8028C96
loc_8028BEC:
	ldrh r0, [r7,#oJoypad_Pressed]
	mov r1, #1
	tst r0, r1
	beq loc_8028C18
	bl custMenu_80298F4
	cmp r0, #0
	bne locret_8028C96

	ldrb r0, [r4]
	lsl r0, r0, #2
	ldr r1, off_8028C98 // =off_8028C9C 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0

	cmp r0, #0
	bne locret_8028C96

	ldrb r0, [r5,#oS20364C0_Unk_0c]
	cmp r0, #0xff
	beq locret_8028C96

	bl firstBattleTutorial_step_8029A56
	b locret_8028C96
loc_8028C18:
	mov r1, #2
	tst r0, r1
	beq loc_8028C2C
	bl battleTutorial_first_checkTextStep_8029B1C
	cmp r0, #0
	bne locret_8028C96
	bl customScreen_ExitAction_8029032
	b locret_8028C96
loc_8028C2C:
	mov r1, #8
	tst r0, r1
	beq loc_8028C36
	mov r0, #0xa
	b loc_8028BD8
loc_8028C36:
	mov r1, #4
	tst r0, r1
	beq loc_8028C46

	// trigger sub_8026D06 via custMenuMainMaybe_8026A88
	mov r0, #0xc
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]

	b locret_8028C96
loc_8028C46:
	ldr r1, off_8028CC4 // =0x100 
	tst r0, r1
	beq loc_8028C80

	ldrb r0, [r5,#oS20364C0_ChipSelectCursorPos]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*

	ldrb r1, [r0]
	cmp r1, #6
	beq loc_8028C60
	cmp r1, #7
	beq loc_8028C60
	cmp r1, #0
	bne locret_8028C96
loc_8028C60:
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	bl chip_getScript_8027D34 // (int chipID) -> void*
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()

	mov r0, #0x9c
	bl PlaySoundEffect

	// trigger chatbox_stateMaybeFinishText_8026E4C via custMenuMainMaybe_8026A88
	mov r0, #0x18
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]

	b locret_8028C96
loc_8028C80:
	ldr r1, off_8028CC8 // =0x200 
	tst r0, r1
	beq locret_8028C96
	bl GetBattleMode
	cmp r0, #1
	beq locret_8028C96

	// trigger battle_updateObjectByKind_8026E98 via custMenuMainMaybe_8026A88
	mov r0, #0x1c
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]

locret_8028C96:
	pop {r4,pc}
	.balign 4, 0
off_8028C98:
	.word off_8028C9C
off_8028C9C:
	.word sub_8028CCC+1
	.word custMenuPressOK_8028D3A+1
	.word sub_8028D6C+1
	.word sub_8028DBC+1
	.word sub_8028DD6+1
	.word sub_8028DD6+1
	.word nullsub_59+1
	.word nullsub_59+1
	.word sub_8028E04+1
	.word sub_8028E04+1
off_8028CC4:
	.word 0x100
off_8028CC8:
	.word 0x200
	thumb_func_end custMenuSomeHandler_8028B74

	thumb_local_start
sub_8028CCC:
	push {lr}
	ldrb r0, [r4,#7]
	cmp r0, #0
	bne loc_8028D30
	ldrb r0, [r5,#8]
	cmp r0, #5
	bge loc_8028D30
	add r1, r0, #1
	strb r1, [r5,#8]
	add r0, #0x48 
	ldrb r1, [r5,#7]
	strb r1, [r5,r0]
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	ldrb r1, [r5,#8]
	sub r1, #1
	bl sprite_CopyObjTilesToVramSlot_80281D4
	ldrb r0, [r5,#8]
	sub r0, #1
	mov r1, #1
	mov r2, #0
	bl sub_8029CD4
	ldrb r0, [r5,#7]
	bl sprite_clearObjVramEntry_8028238
	mov r0, #2
	strb r0, [r4,#7]
	bl customScreen_ExitSequence_8028E32
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r0, #1
	strb r0, [r5,#0xf]
	mov r0, #0
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl sub_802A00C
	tst r0, r0
	beq locret_8028D38
	mov r0, #0x44 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b locret_8028D38
loc_8028D30:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	mov r0, #1
locret_8028D38:
	pop {pc}
	thumb_func_end sub_8028CCC

// symdb: Handles confirming with OK in the Custom Screen menu, running the chosen action handler, switching state, and playing the select sound.
// symdb: Next custMenuPressOK_8028D3A(void); r5 in = menu state struct (oS20364C0_*), r0 out = 0, Z set
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/custMenuPressOK_8028D3A.yaml
	thumb_local_start
custMenuPressOK_8028D3A:
	push {lr}
	bl sub_8029110
	bl sub_80293F8

	ldrb r0, [r5,#oS20364C0_Unk_19]
	tst r0, r0
	beq loc_8028D50

	bl sub_802937A
	b loc_8028D5A
loc_8028D50:

	ldrh r0, [r5,#oS20364C0_Unk_3a]
	tst r0, r0
	beq loc_8028D5A
  
	bl sub_80293B0

loc_8028D5A: // endif

	// trigger scrollStrip_update_8026BF4 via custMenuMainMaybe_8026A88
	mov r0, #8
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]

	mov r0, #SOUND_SELECT_82
	bl PlaySoundEffect

	mov r0, #0
	pop {pc}
	thumb_func_end custMenuPressOK_8028D3A

	thumb_local_start
sub_8028D6C:
	push {lr}
	ldrb r0, [r4,#7]
	cmp r0, #0
	bne loc_8028DB2

	ldrb r0, [r5,#oS20364C0_NumChipsSelected]
	cmp r0, #5
	bge loc_8028DB2

	add r1, r0, #1
	strb r1, [r5,#oS20364C0_NumChipsSelected]

	add r0, #0x48 
	ldrb r1, [r5,#oS20364C0_ChipSelectCursorPos]
	strb r1, [r5,r0]
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl sub_802A034
	ldrb r1, [r5,#8]
	sub r1, #1
	bl sprite_CopyObjTilesToVramSlot_80281D4
	ldrb r0, [r5,#8]
	sub r0, #1
	mov r1, #1
	mov r2, #0
	bl sub_8029CD4
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect

	// trigger sub_802770C via custMenuMainMaybe_8026A88
	mov r0, #0x48 
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]

	mov r0, #0
	b locret_8028DBA
loc_8028DB2:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	mov r0, #1
locret_8028DBA:
	pop {pc}
	thumb_func_end sub_8028D6C

	thumb_local_start
sub_8028DBC:
	push {lr}
	bl battle_getStateByte0d_800A7E2

	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?

	mov r1, #1
	strb r1, [r0,#8]

	ldr r0, off_8028F80 // =dword_20349A0 
	strb r1, [r0,#0x4] // (byte_20349A4 - 0x20349a0)

	bl custMenuPressOK_8028D3A

	mov r0, #0

	pop {pc}
	thumb_func_end sub_8028DBC

// symdb: Shuffle-once button handler (custom screen, active slot 8): a chip of type 4/5 whose enabled byte is 0 starts the shuffle state machine (jump 0x28 -> sub_80271F8) with sound 0x82; a nonzero enabled byte plays SOUND_CANT_JACK_IN instead.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8028DD6.yaml
	thumb_local_start
sub_8028DD6:
	push {lr}
	ldrb r1, [r4]
	cmp r1, #5
	bne loc_8028DE0
	sub r4, #0xc
loc_8028DE0:
	ldrb r0, [r4,#7]
	cmp r0, #0
	bne loc_8028DFA

	// trigger sub_80271F8 via custMenuMainMaybe_8026A88
	mov r0, #0x28 
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]
  
	mov r0, #0x83
	add r0, #0xff
	bl PlaySoundEffect
	mov r0, #0
	b locret_8028E02
loc_8028DFA:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	mov r0, #1
locret_8028E02:
	pop {pc}
	thumb_func_end sub_8028DD6

	thumb_local_start
sub_8028E04:
	push {r6,r7,lr}
	ldrb r1, [r4]
	cmp r1, #9
	bne loc_8028E0E
	sub r4, #0xc
loc_8028E0E:
	ldrb r0, [r4,#7]
	cmp r0, #0
	bne loc_8028E26
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r0, #0x38 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov r0, #0
	b locret_8028E2E
loc_8028E26:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	mov r0, #1
locret_8028E2E:
	pop {r6,r7,pc}
	thumb_func_end sub_8028E04

	thumb_local_start
nullsub_59:
	mov pc, lr
	thumb_func_end nullsub_59

// symdb: Runs the close-out sequence when leaving the Custom screen, then returns to the previous menu state.
// symdb: void customScreen_ExitSequence_8028E32(void)  // no meaningful inputs; r0=0 is passed to the
// symdb: final sub-call
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/customScreen_ExitSequence_8028E32.yaml
	thumb_local_start
customScreen_ExitSequence_8028E32:
	push {lr}
	bl classifyActiveChipElements_8028E4C
	bl updateCustomScreen_WhenUnselectingChip_8028EC8 // () -> void
	bl battle_updateActiveChipSlotB_state_8028F48
	bl battle_updateExtraSlotChipKeepFlag_8028F84
	mov r0, #0
	bl sub_8028250
	pop {pc}
	thumb_func_end customScreen_ExitSequence_8028E32

// symdb: Walks r5's chip list, classifying chips by element/ID and writing element code and ID sentinel back to r5.
// symdb: void sub_8028E4C(void);  /* inputs: r2 r4 r5 r6 r7 r10 lr; outputs: r2 r3 r4 r5 r6 r7; clobbers
// symdb: r0 r1 r3 lr */
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/classifyActiveChipElements_8028E4C.yaml
	thumb_local_start
classifyActiveChipElements_8028E4C:
	push {r4,r6,r7,lr}
	mov r6, #0
	sub r6, #1
	mov r7, #0x1a
	mov r0, #0
	strb r0, [r5,#0xa]
	ldrb r3, [r5,#8]
	cmp r3, #0
	beq loc_8028EC2
	mov r4, #0x48 
loc_8028E60:
	push {r3}
	ldrb r0, [r5,r4]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	pop {r3}
	ldrb r1, [r0]
	cmp r1, #0
	bne loc_8028EBC
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	lsr r1, r0, #9
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	push {r0}
	bl chipIDIs13f_8029FF4 // (int a1) -> bool
	tst r0, r0
	pop {r0}
	bne loc_8028EBC
	cmp r1, #0x1b
	blt loc_8028E96
	cmp r1, #0x1c
	bgt loc_8028E96
	strb r1, [r5,#0xa]
	b loc_8028EBC
loc_8028E96:
	cmp r1, #0x1a
	beq loc_8028EA8
	cmp r7, #0x1a
	beq loc_8028EA6
	cmp r7, r1
	beq loc_8028EA8
	mov r7, #0xff
	b loc_8028EA8
loc_8028EA6:
	mov r7, r1
loc_8028EA8:
	mov r1, #0
	sub r1, #1
	cmp r1, r6
	beq loc_8028EBA
	cmp r0, r6
	beq loc_8028EBC
	mov r6, #0
	sub r6, #2
	b loc_8028EBC
loc_8028EBA:
	mov r6, r0
loc_8028EBC:
	add r4, #1
	sub r3, #1
	bne loc_8028E60
loc_8028EC2:
	strh r6, [r5,#0x20]
	strb r7, [r5,#9]
	pop {r4,r6,r7,pc}
	thumb_func_end classifyActiveChipElements_8028E4C

// () -> void
// symdb: After a chip is unselected on the Custom Screen, scan the 10 active-chip slots and mark each empty slot's selection flag (slot+7) as selectable or not based on the current selection count, active-chip ID, monocode, and active chip-code (including the 0x1B/0x1C special codes and 0x1A star wildcard).
// symdb: void updateCustomScreen_WhenUnselectingChip_8028EC8(void /* r5=state, r10 */);   /* inputs:  r5
// symdb: = custom-screen state pointer    *          r10 = (caller-saved scratch)    * outputs: r3 = 0;
// symdb: r4/r5/r6/r7 preserved    * clobbers: nz,c,v from r0,r1,r2,lr    */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/updateCustomScreen_WhenUnselectingChip_8028EC8.yaml
	thumb_local_start
updateCustomScreen_WhenUnselectingChip_8028EC8:
	push {r4,r6,r7,lr}
	mov r0, #0
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	// save active chips
	mov r4, r0
	// max 10 in memory
	mov r3, #0xa
chipCodeSelectLoopStar_8028ED4:
	// check if the slot contains a chip?
	ldrb r0, [r4]
	cmp r0, #0
	bne chipCodeSelectLoopInc_8028F40
	// check if the chip is already selected
	ldrb r0, [r4,#7]
	cmp r0, #2
	beq chipCodeSelectLoopInc_8028F40
	// check number of selected chips
	ldrb r0, [r5,#8]
	cmp r0, #5
	bge chipCodeSelectFalse_8028F3C
	// load pointer
	// load chip data
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	// code
	lsr r1, r0, #9
	// ID
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	// assume chip can be selected
	mov r6, #0
	push {r0}
	bl chipIDIs13f_8029FF4 // (int a1) -> bool
	tst r0, r0
	pop {r0}
	bne chipCodeSelectTrue_8028F3E
	// codes 0x1b, 0x1c are special codes
	cmp r1, #0x1b
	blt chipCodeSelectNormal_8028F16
	cmp r1, #0x1c
	bgt chipCodeSelectNormal_8028F16
	// special active chip code
	ldrb r0, [r5,#0xa]
	cmp r0, #0
	beq chipCodeSelectTrue_8028F3E
	// if the active code is not the special chip codoe
	// return false!
	cmp r0, r1
	bne chipCodeSelectFalse_8028F3C
	b chipCodeSelectTrue_8028F3E
chipCodeSelectNormal_8028F16:
	mov r7, #0x20 
	// r2 = active chip
	ldrsh r2, [r5,r7]
	mov r7, #0
	sub r7, #1
	// if active chip == -1: any chip works
	cmp r2, r7
	beq chipCodeSelectMonocode_8028F26
	// the only case chip code is ignores is
	// if all chips are the same type
	cmp r0, r2
	beq chipCodeSelectTrue_8028F3E
chipCodeSelectMonocode_8028F26:
	// at this point, all chips are different?
	// if not monocode, can't be selected
	ldrb r2, [r5,#9]
	cmp r2, #0xff
	beq chipCodeSelectFalse_8028F3C
	// check if all chips are (*) so far
	cmp r2, #0x1a
	bgt chipCodeSelectNotStar_8028F32
	beq chipCodeSelectTrue_8028F3E
chipCodeSelectNotStar_8028F32:
	// check if selected chip is (*)
	cmp r1, #0x1a
	bgt chipCodeSelectNotStar2_8028F38
	beq chipCodeSelectTrue_8028F3E
chipCodeSelectNotStar2_8028F38:
	// check if the selected chip has the same code as active code
	cmp r1, r2
	beq chipCodeSelectTrue_8028F3E
chipCodeSelectFalse_8028F3C:
	mov r6, #1
chipCodeSelectTrue_8028F3E:
	strb r6, [r4,#7]
chipCodeSelectLoopInc_8028F40:
	// increment loop
	add r4, #0xc
	sub r3, #1
	bne chipCodeSelectLoopStar_8028ED4
	pop {r4,r6,r7,pc}
	thumb_func_end updateCustomScreen_WhenUnselectingChip_8028EC8

// symdb: Updates the substate byte (+7) of active-chip-list slot 11 (the chip being handled on the custom screen) based on the battle object's state, either clearing it to 0 when the chip may be unmarked or setting it to 1 otherwise.
// symdb: void sub_8028F48(/* r5 */ BattleObj* battleObj); // uses caller-set r4-r7,r10 only as pass-
// symdb: through; returns r2/r3/r4-r7 unchanged, clobbers r0,r1,lr and NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_updateActiveChipSlotB_state_8028F48.yaml
	thumb_local_start
battle_updateActiveChipSlotB_state_8028F48:
	push {r4,r6,r7,lr}
	mov r0, #0xb
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r4, r0
	ldrb r0, [r4]
	cmp r0, #2
	bne locret_8028F7C
	ldrb r0, [r4,#7]
	cmp r0, #2
	beq locret_8028F7C
	ldrb r0, [r5,#8]
	cmp r0, #5
	bge loc_8028F78
	bl sub_802A57E
	tst r0, r0
	beq loc_8028F78
	ldrb r0, [r5,#0x19]
	tst r0, r0
	bne loc_8028F78
	mov r0, #0
	strb r0, [r4,#7]
	b locret_8028F7C
loc_8028F78:
	mov r0, #1
	strb r0, [r4,#7]
locret_8028F7C:
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8028F80:
	.word dword_20349A0
	thumb_func_end battle_updateActiveChipSlotB_state_8028F48

// symdb: Updates the "chip is still on the field" state byte (offset 7) of active-chip slot 8, keeping it alive only while the chip it is linked to in the chip-selection state still has an active slot.
// symdb: void battle_updateExtraSlotChipKeepFlag_8028F84(void) — inputs r4 (unused here but preserved),
// symdb: r5 (chip-selection state pointer), r6/r7 preserved; no meaningful return value; clobbers r0, r1,
// symdb: lr, flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_updateExtraSlotChipKeepFlag_8028F84.yaml
	thumb_local_start
battle_updateExtraSlotChipKeepFlag_8028F84:
	push {r4,r6,r7,lr}
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r4, r0
	ldrb r0, [r4]
	cmp r0, #8
	bne locret_8028FBE
	ldrb r0, [r4,#7]
	cmp r0, #2
	beq locret_8028FBE
	ldrb r0, [r4,#7]
	cmp r0, #3
	beq loc_8028FBA
	ldrb r0, [r5,#8]
	cmp r0, #0
	beq loc_8028FBA
	add r0, #0x47 
	ldrb r0, [r5,r0]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r1, [r0]
	cmp r1, #0
	bne loc_8028FBA
	mov r0, #0
	strb r0, [r4,#7]
	b locret_8028FBE
loc_8028FBA:
	mov r0, #1
	strb r0, [r4,#7]
locret_8028FBE:
	pop {r4,r6,r7,pc}
	thumb_func_end battle_updateExtraSlotChipKeepFlag_8028F84

	thumb_local_start
sub_8028FC0:
	push {r4,r6,r7,lr}
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r4, r0
	ldrb r0, [r4]
	cmp r0, #6
	bne locret_8029030
	ldrb r0, [r5,#8]
	cmp r0, #0
	beq loc_802901C
	add r0, #0x47 
	ldrb r0, [r5,r0]
	mov r7, r0
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r1, [r0]
	cmp r1, #0
	bne loc_802901C
	ldrb r1, [r0,#5]
	cmp r1, #0
	bne loc_802901C
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	mov r6, r0
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#9]
	mov r1, #2
	tst r0, r1
	beq loc_802901C
	ldrb r0, [r4,#7]
	cmp r0, #2
	beq loc_8029010
	mov r0, #0
	strb r0, [r4,#7]
loc_8029010:
	ldrb r0, [r4,#0x13]
	cmp r0, #2
	beq locret_8029030
	mov r0, #0
	strb r0, [r4,#0x13]
	b locret_8029030
loc_802901C:
	ldrb r0, [r4,#7]
	cmp r0, #2
	beq loc_8029026
	mov r0, #1
	strb r0, [r4,#7]
loc_8029026:
	ldrb r0, [r4,#0x13]
	cmp r0, #2
	beq locret_8029030
	mov r0, #1
	strb r0, [r4,#0x13]
locret_8029030:
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8028FC0

// symdb: Handles the confirm/exit action on the custom-screen chip submenu: clears a pending jack-in if nothing is selected, or pops the highlighted chip slot, redrawing tile data and updating the slot count, before exiting the custom screen.
// symdb: void sub_8029032(u32 *state_ptr /* r5 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/customScreen_ExitAction_8029032.yaml
	thumb_local_start
customScreen_ExitAction_8029032:
	push {r4,lr}
	ldrb r0, [r5,#8]
	cmp r0, #0
	bne loc_8029066
	ldrb r0, [r5,#0x19]
	tst r0, r0
	bne loc_8029048
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	b locret_8029104
loc_8029048:
	ldrb r0, [r5,#0x1b]
	ldr r1, dword_802910C // =0x55 
	add r1, r1, r0
	mov r0, #0
	strb r0, [r5,r1]
	mov r0, #0
	strb r0, [r5,#0x1a]
	strb r0, [r5,#0x19]
	mov r0, #0xd3
	add r0, #0xff
	bl PlaySoundEffect
	bl battle_ClearPendingEventFlag_802A0EC
	b loc_80290F6
loc_8029066:
	add r0, #0x47 
	ldrb r0, [r5,r0]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r4, r0
	ldrb r0, [r4]
	cmp r0, #2
	bne loc_80290A4
	ldrb r1, [r5,#8]
	sub r1, #1
	strb r1, [r5,#8]
	ldr r0, dword_8029108 // =0x1ff 
	bl sprite_CopyObjTilesToVramSlot_80281D4
	ldrb r0, [r5,#8]
	mov r1, #0
	mov r2, #0
	bl sub_8029CD4
	bl battle_ClearPendingEventFlag_802A0EC
	mov r0, #SOUND_EXIT_SUBMENU
	bl PlaySoundEffect
	mov r0, #0xd3
	add r0, #0xff
	bl PlaySoundEffect
	mov r0, #0
	strb r0, [r5,#0x17]
	b loc_80290F2
loc_80290A4:
	ldr r0, [r4,#8]
	ldrh r0, [r0]
	bl sub_802A00C
	tst r0, r0
	beq loc_80290C2
	mov r0, #SOUND_EXIT_SUBMENU
	bl PlaySoundEffect
	mov r0, #0xd3
	add r0, #0xff
	bl PlaySoundEffect
	bl battle_ClearPendingEventFlag_802A0EC
loc_80290C2:
	ldrb r1, [r5,#8]
	sub r1, #1
	strb r1, [r5,#8]
	ldr r0, dword_8029108 // =0x1ff 
	bl sprite_CopyObjTilesToVramSlot_80281D4
	ldrb r0, [r5,#8]
	mov r1, #0
	mov r2, #0
	bl sub_8029CD4
	ldrb r0, [r4,#5]
	cmp r0, #0
	beq loc_80290F2
	mov r1, #0
	strb r1, [r4,#5]
	ldrb r1, [r4,#4]
	mov r2, #0x3e 
	bic r1, r2
	strb r1, [r4,#4]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	mov r1, #0
	strb r1, [r0,#7]
loc_80290F2:
	mov r0, #0
	strb r0, [r4,#7]
loc_80290F6:
	bl customScreen_ExitSequence_8028E32
	bl sub_8028476
	mov r0, #SOUND_EXIT_SUBMENU
	bl PlaySoundEffect
locret_8029104:
	pop {r4,pc}
	.balign 4, 0
dword_8029108:
	.word 0x1FF
dword_802910C:
	.word 0x55
	thumb_func_end customScreen_ExitAction_8029032

	thumb_local_start
sub_8029110:
	push {r4,r6,r7,lr}

	mov r0, #0x14
	strb r0, [r5,#oS20364C0_Unk_0b]

	// memBlock
	ldr r0, off_80293D4 // =dword_2033000 
	// size
	mov r1, #0x48 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	ldr r4, off_80293D4 // =dword_2033000 
	ldr r6, off_80293CC // =byte_20366C0 
	mov r3, #6
	mov r0, #0
	sub r0, #1
loc_8029128:
	strh r0, [r4]
	strh r0, [r6,#0x32]
	add r4, #2
	add r6, #2
	sub r3, #1
	bne loc_8029128
	ldr r4, off_80293D4 // =dword_2033000 

	ldrb r7, [r5,#oS20364C0_NumChipsSelected]
	cmp r7, #0
	beq loc_80291E6

	mov r6, #0x48 
	ldr r3, off_80293CC // =byte_20366C0 
loc_8029140:
	ldrb r0, [r5,r6]
	push {r3}
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	pop {r3}
	ldrb r1, [r0]
	cmp r1, #2
	bne loc_8029156
	bl sub_8029344
	b loc_80291AC
loc_8029156:
	cmp r1, #0
	bne loc_802915E
	ldrb r1, [r0,#4]
	strh r1, [r4,#0x3c]
loc_802915E:
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	strh r0, [r3,#0x32]
	lsr r1, r0, #9
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	strh r0, [r4]
	strh r1, [r4,#0x30]
	ldr r1, off_80293D8 // =0x190 
	cmp r0, r1
	blt loc_802918C
	push {r0}
	sub r0, r0, r1
	add r0, #1
	mov r1, #1
	lsl r1, r0
	ldr r0, dword_80293F4 // =dword_20349A0
	ldrh r2, [r0,#0xc] // (word_20349AC - 0x20349a0)
	orr r2, r1
	strh r2, [r0,#0xc] // (word_20349AC - 0x20349a0)
	pop {r0}
loc_802918C:
	push {r3}
	push {r0}
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r1, [r1,#0xd]
	bl sub_80109A4
	strh r0, [r4,#0xc]
	pop {r0}
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#6]
	strh r1, [r4,#0x24]
	pop {r3}
	add r4, #2
	add r3, #2
loc_80291AC:
	add r6, #1
	sub r7, #1
	bne loc_8029140
	ldr r0, off_80293CC // =byte_20366C0 
	add r0, #0x32 
	mov r1, #0
	bl sub_8029520
	cmp r0, #0
	beq loc_80291E2
	push {r0-r2}
	bl sub_8029328
	cmp r0, #0
	pop {r0-r2}
	bne loc_80291E2
	push {r0-r2}
	bl sub_80292CC
	pop {r0-r2}
	lsr r1, r1, #1
	ldr r3, off_80293CC // =byte_20366C0 
	add r3, #0x32 
	bl sub_802B6F2
	mov r0, #0x10
	strb r0, [r5,#0xb]
loc_80291E2:
	bl processChipCommandQueue_8029224
loc_80291E6:
	ldr r2, off_80293D4 // =dword_2033000 
	ldr r6, off_80293CC // =byte_20366C0 
	ldr r4, off_80293D0 // =byte_20366FE 
	mov r0, #0

	ldrb r3, [r5,#oS20364C0_NumChipsSelected]
	cmp r3, #0
	bne loc_80291F6

	mov r0, #0xff
loc_80291F6:
	strb r0, [r6]
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#7]
	sub r0, #1
	mov r3, #6
loc_8029202:
	ldrh r7, [r2]
	strh r7, [r6,#2]
	ldrh r7, [r2,#0xc]
	strh r7, [r6,#0xe]
	ldrh r7, [r2,#0x18]
	strh r7, [r6,#0x1a]
	mov r1, #0
	strh r1, [r6,#0x26]
	strb r0, [r4]
	ldrh r7, [r2,#0x3c]
	strb r7, [r4,#6]
	add r6, #2
	add r4, #1
	add r2, #2
	sub r3, #1
	bne loc_8029202
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8029110

// symdb: Walks the chip-use command queue at 0x2033000, validating opcodes against chip attributes and applying per-opcode side effects.
// symdb: void sub_8029224(u32 r3 /* target object for status-bit merge */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/processChipCommandQueue_8029224.yaml
	thumb_local_start
processChipCommandQueue_8029224:
	push {r4,r6,r7,lr}
	ldr r4, off_80293D4 // =dword_2033000 
	add r4, #2
	mov r7, #0
	sub r7, #1
	mov r6, #0
loc_8029230:
	ldrsh r0, [r4,r6]
	cmp r0, r7
	beq locret_80292CA
	cmp r0, #0xc0
	beq loc_8029252
	cmp r0, #0xc1
	beq loc_802924C
	cmp r0, #0xc3
	beq loc_8029252
	cmp r0, #0xb8
	beq loc_8029252
	cmp r0, #0xb9
	beq loc_8029258
	b loc_80292C6
loc_802924C:
	mov r1, #4
	mov r2, #0
	b loc_802925C
loc_8029252:
	mov r1, #2
	mov r2, #0
	b loc_802925C
loc_8029258:
	mov r1, #2
	mov r2, #1
loc_802925C:
	sub r0, r4, #2
	// idx
	ldrh r0, [r0]
	push {r1,r2}
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	pop {r1,r2}
	ldrb r0, [r0,#9]
	tst r0, r1
	beq loc_80292C6
	tst r0, r2
	bne loc_80292C6
	ldrsh r0, [r4,r6]
	cmp r0, #0xb8
	beq loc_8029286
	cmp r0, #0xb9
	beq loc_8029292
	ldrh r0, [r4,#0xc]
	ldrh r1, [r4,#0x16]
	add r1, r1, r0
	strh r1, [r4,#0x16]
	b loc_802929C
loc_8029286:
	sub r0, r4, #2
	ldrh r1, [r0,#0x3c]
	mov r2, #2
	orr r1, r2
	strh r1, [r0,#0x3c]
	b loc_802929C
loc_8029292:
	sub r0, r4, #2
	ldrh r1, [r0,#0x3c]
	mov r2, #4
	orr r1, r2
	strh r1, [r0,#0x3c]
loc_802929C:
	ldrh r0, [r3,#0x3c]
	mov r1, #1
	and r1, r0
	ldrh r0, [r3,#0x3a]
	orr r0, r1
	strh r0, [r3,#0x3a]
	mov r2, r4
	add r3, r4, #2
loc_80292AC:
	ldrh r0, [r3,#0x3c]
	strh r0, [r2,#0x3c]
	ldrh r0, [r3,#0xc]
	strh r0, [r2,#0xc]
	ldrh r0, [r3,#0x24]
	strh r0, [r2,#0x24]
	ldrsh r0, [r3,r6]
	strh r0, [r2,r6]
	add r3, #2
	add r2, #2
	cmp r0, r7
	bne loc_80292AC
	sub r4, #2
loc_80292C6:
	add r4, #2
	b loc_8029230
locret_80292CA:
	pop {r4,r6,r7,pc}
	thumb_func_end processChipCommandQueue_8029224

	thumb_local_start
sub_80292CC:
	push {r4,r6,r7,lr}
	ldr r4, off_80293D4 // =dword_2033000 
	add r4, r4, r1
	lsl r3, r2, #1
	add r6, r4, r3
	sub r7, r2, #1
	strh r0, [r4]
	push {r0}
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r1, [r1,#0xd]
	bl sub_80109A4
	strh r0, [r4,#0xc]
	pop {r0}
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r1, [r0,#6]
	strh r1, [r4,#0x24]
	mov r2, #0x3e 
loc_80292F4:
	ldrh r0, [r4,r2]
	mov r1, #1
	and r1, r0
	ldrh r0, [r4,#0x3c]
	orr r0, r1
	strh r0, [r4,#0x3c]
	add r2, #2
	sub r7, #1
	bne loc_80292F4
	add r4, #2
	mov r7, #0
	sub r7, #1
	mov r1, #0
loc_802930E:
	ldrh r0, [r6,#0x3c]
	strh r0, [r4,#0x3c]
	ldrh r0, [r6,#0xc]
	strh r0, [r4,#0xc]
	ldrh r0, [r6,#0x24]
	strh r0, [r4,#0x24]
	ldrsh r0, [r6,r1]
	strh r0, [r4,r1]
	add r6, #2
	add r4, #2
	cmp r0, r7
	bne loc_802930E
	pop {r4,r6,r7,pc}
	thumb_func_end sub_80292CC

	thumb_local_start
sub_8029328:
	push {r4,lr}
	ldr r4, off_80293D4 // =dword_2033000 
	add r4, r4, r1
	add r4, #0x3c 
	mov r3, #0xfe
	mov r0, #0
loc_8029334:
	ldrh r1, [r4]
	and r1, r3
	beq loc_802933C
	add r0, #1
loc_802933C:
	add r4, #2
	sub r2, #1
	bne loc_8029334
	pop {r4,pc}
	thumb_func_end sub_8029328

	thumb_local_start
sub_8029344:
	push {r0-r4,r6,lr}
	mov r0, #0
	bl sub_802A11C
	mov r6, r0
	bl battle_getActorEmotion_802A564
	cmp r0, #1
	bne loc_802935A
	ldr r4, dword_80293E4 // =0x18 
	b loc_8029368
loc_802935A:
	cmp r1, #0
	bne loc_8029362
	ldr r4, dword_80293E0 // =0xc 
	b loc_8029368
loc_8029362:
	ldr r4, dword_80293EC // =0x12 
	sub r1, #6
	add r4, r4, r1
loc_8029368:
	mov r0, r4
	mov r1, #0
	mov r2, r6
	bl sub_8015952
	mov r0, #1
	ldr r1, dword_80293F4 // =dword_20349A0
	strb r0, [r1,#0x10] // (byte_20349B0 - 0x20349a0)
	pop {r0-r4,r6,pc}
	thumb_func_end sub_8029344

	thumb_local_start
sub_802937A:
	push {r0-r4,lr}
	ldr r4, dword_80293E8 // =0x6 
	bl battle_getActorEmotion_802A564
	cmp r1, #0xb
	blt loc_8029388
	ldr r4, dword_80293EC // =0x12 
loc_8029388:
	mov r0, #1
	bl sub_802A11C
	mov r2, r0

	ldrb r0, [r5,#oS20364C0_Unk_1a]
	add r0, r0, r4
	mov r1, #0
	bl sub_8015952

	ldrb r0, [r5,#oS20364C0_Unk_1a]
	ldr r1, dword_80293E8 // =0x6 
	add r0, r0, r1
	sub r0, #1
	mov r3, #1
	lsl r3, r0
	ldr r2, dword_80293F4 // =dword_20349A0
	ldr r1, [r2]
	orr r1, r3
	str r1, [r2]
	pop {r0-r4,pc}
	thumb_func_end sub_802937A

	thumb_local_start
sub_80293B0:
	push {r0-r4,lr}
	ldrh r0, [r5,#oS20364C0_Unk_3a]
	sub r0, #1
	ldr r1, dword_80293F0 // =0xd 
	add r0, r0, r1
	mov r1, #0
	mov r2, #3
	bl sub_8015952
	ldrb r0, [r3,#5]
	add r0, #1
	strb r0, [r3,#5]
	pop {r0-r4,pc}
	.balign 4, 0
off_80293CC:
	.word byte_20366C0
off_80293D0:
	.word byte_20366FE
off_80293D4:
	.word dword_2033000
off_80293D8:
	.word 0x190
	.word byte_20349C0
dword_80293E0:
	.word 0xC
dword_80293E4:
	.word 0x18
dword_80293E8:
	.word 0x6
dword_80293EC:
	.word 0x12
dword_80293F0:
	.word 0xD
dword_80293F4:
	.word 0x20349A0
	thumb_func_end sub_80293B0

// symdb: Walks the player's selected-chip list and resets each active chip's in-flight state (clears firing flag, writes -1 sentinel to hit counter, decrements battle-state active-chip count).
// symdb: void custom_resetSelectedChipState_80293F8(u32 r5 /* chip-select HUD base (oS20364C0) */, u32
// symdb: r10 /* toolkit base (oToolkit_BattleStatePtr) */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_80293F8.yaml
	thumb_local_start
sub_80293F8:
	push {r4,r6,r7,lr}
	mov r7, #0
	sub r7, #1

	ldrb r4, [r5,#oS20364C0_NumChipsSelected]
	cmp r4, #0
	beq locret_8029458

	mov r6, #0x48 
loc_8029406:
	ldrb r0, [r5,r6]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r1, [r0]
	cmp r1, #2
	bne loc_8029426
	push {r0,r1}
	bl GetBattleMode
	cmp r0, #1
	pop {r0,r1}
	bne loc_8029452
	ldrb r0, [r0,#4]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r1, [r0]
loc_8029426:
	cmp r1, #0
	bne loc_8029452
	ldrb r1, [r0,#4]
	mov r2, #1
	tst r1, r2
	beq loc_802943A
	mov r2, r10
	ldr r2, [r2,#oToolkit_BattleStatePtr]
	mov r1, #0
	strb r1, [r2,#0x17]
loc_802943A:
	ldr r0, [r0,#8]
	strh r7, [r0]
	mov r2, r10
	ldr r2, [r2,#oToolkit_BattleStatePtr]
	mov r1, #0x44 
	ldrb r3, [r2,r1]
	tst r3, r3
	beq loc_8029452
	mov r1, #0x45 
	ldrb r3, [r2,r1]
	sub r3, #1
	strb r3, [r2,r1]
loc_8029452:
	add r6, #1
	sub r4, #1
	bne loc_8029406
locret_8029458:
	pop {r4,r6,r7,pc}
	thumb_func_end sub_80293F8

// symdb: Compacts the current battle folder chip list in eBattleFolder by dropping empty (0xFFFF) slots and padding the tail so it always holds 30 entries.
// symdb: void battle_compactFolderChipList_802945A(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_compactFolderChipList_802945A.yaml
	thumb_local_start
battle_compactFolderChipList_802945A:
	push {r4,r6,r7,lr}
	ldr r3, off_8029510 // =eBattleFolder 
	mov r4, #0
	mov r6, #0
	mov r2, #0x1e
	mov r7, #0
	sub r7, #1
loc_8029468:
	ldrsh r0, [r3,r4]
	cmp r0, r7
	beq loc_8029474
	strh r0, [r3,r6]
	add r6, #2
	sub r2, #1
loc_8029474:
	add r4, #2
	cmp r4, #0x3c 
	blt loc_8029468
	cmp r2, #0
	beq locret_8029486
loc_802947E:
	strh r7, [r3,r6]
	add r6, #2
	sub r2, #1
	bne loc_802947E
locret_8029486:
	pop {r4,r6,r7,pc}
	thumb_func_end battle_compactFolderChipList_802945A

	thumb_local_start
sub_8029488:
	push {r4,r6,r7,lr}
	mov r4, r10
	ldr r4, [r4,#oToolkit_BattleStatePtr]
	mov r0, #0x44 
	ldrb r0, [r4,r0]
	tst r0, r0
	beq locret_80294DE
	mov r0, #0x45 
	ldrb r6, [r4,r0]
	ldrb r1, [r5,#6]
	sub r2, r1, #1
	cmp r6, r2
	beq loc_80294A8
	cmp r6, r2
	blt loc_80294D8
	b locret_80294DE
loc_80294A8:
	ldr r3, off_8029510 // =eBattleFolder 
	lsl r6, r6, #1
	add r3, r3, r6
	mov r7, #4
	ldrsh r0, [r3,r7]
	mov r1, #0
	sub r1, #1
	cmp r0, r1
	beq loc_80294D8
	mov r7, #0
	ldrsh r1, [r3,r7]
	mov r7, #2
	ldrsh r2, [r3,r7]
	mov r7, #0
	strh r0, [r3,r7]
	mov r7, #2
	strh r1, [r3,r7]
	mov r7, #4
	strh r2, [r3,r7]
	mov r0, #0x45 
	ldrb r1, [r4,r0]
	add r1, #1
	strb r1, [r4,r0]
	b locret_80294DE
loc_80294D8:
	mov r0, #0x44 
	mov r1, #0
	strb r1, [r4,r0]
locret_80294DE:
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8029488

	thumb_local_start
sub_80294E0:
	push {r4,r6,r7,lr}
	mov r0, #0x5f 
	ldrb r6, [r5,r0]
loc_80294E6:
	ldr r3, off_8029510 // =eBattleFolder 
	mov r4, #0
	mov r7, #0
	sub r7, #1
loc_80294EE:
	ldrsh r1, [r3,r4]
	cmp r1, r7
	bne loc_8029502
	sub r1, r6, #1
	lsl r1, r1, #1
	mov r2, #0x60 
	add r2, r2, r1
	ldrh r0, [r5,r2]
	strh r0, [r3,r4]
	b loc_8029508
loc_8029502:
	add r4, #2
	cmp r4, #0x3c 
	blt loc_80294EE
loc_8029508:
	sub r6, #1
	cmp r6, #0
	bgt loc_80294E6
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8029510:
	.word eBattleFolder
	thumb_func_end sub_80294E0

	thumb_local_start
sub_8029514:
	push {r4-r7,lr}
	sub sp, sp, #0x20
	mov r7, sp
	mov r2, #1
	str r2, [r7,#0x1c]
	b loc_802952A
	thumb_func_end sub_8029514

	thumb_local_start
sub_8029520:
	push {r4-r7,lr}
	sub sp, sp, #0x20
	mov r7, sp
	mov r2, #0
	str r2, [r7,#0x1c]
loc_802952A:
	str r1, [r7,#0x18]
	mov r4, #0
	sub r4, #1
	mov r5, #0
	mov r6, #0xa
loc_8029534:
	ldrsh r1, [r0,r5]
	cmp r1, r4
	beq loc_802954C
	lsr r2, r1, #9
	lsl r1, r1, #0x17
	lsr r1, r1, #0x17
	strh r1, [r7,r5]
	strh r2, [r7,r6]
	add r5, #2
	add r6, #2
	cmp r5, #0xa
	bne loc_8029534
loc_802954C:
	mov r0, #0
	lsr r5, r5, #1
	cmp r5, #3
	blt loc_80295B0
	mov r6, #0
loc_8029556:
	ldr r4, off_80295B4 // =off_802BCB0 
	ldr r0, [r7,#0x1c]
	cmp r0, #0
	beq loc_8029560
	ldr r4, off_80295B8 // =off_802BC60 
loc_8029560:
	ldr r3, [r4]
	cmp r3, #0
	beq loc_80295A6
	ldrb r2, [r3]
	cmp r5, r2
	blt loc_80295A2
	ldrb r0, [r3,#1]
	ldr r1, off_80295BC // =off_80295C0 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	cmp r0, #0
	beq loc_80295A2
	push {r1-r3}
	ldr r1, [r7,#0x18]
	bl sub_8029652
	pop {r1-r3}
	cmp r0, #0
	beq loc_80295A2
	push {r0-r3}
	ldr r0, [r7,#0x1c]
	cmp r0, #0
	pop {r0-r3}
	beq loc_802959C
	push {r0-r3}
	ldr r0, [r7,#0x18]
	cmp r0, #0
	pop {r0-r3}
	bne loc_80295B0
loc_802959C:
	bl sub_802963C
	b loc_80295B0
loc_80295A2:
	add r4, #4
	b loc_8029560
loc_80295A6:
	add r6, #2
	sub r5, #1
	cmp r5, #3
	bge loc_8029556
	mov r0, #0
loc_80295B0:
	add sp, sp, #0x20
	pop {r4-r7,pc}
	.balign 4, 0
off_80295B4:
	.word off_802BCB0
off_80295B8:
	.word off_802BC60
off_80295BC:
	.word off_80295C0
off_80295C0:
	.word battle_scanChipSeq_80295C8+1
	.word matchHalfwordPatternEntry_802961A+1
	thumb_func_end sub_8029520

// symdb: Validates a run of consecutive chip codes in the battle buffer against a target and a trailing descending sub-sequence pattern, returning the owning chip's data field on success.
// symdb: battle_scanChipSeq_80295C8(r2=count, r3=data_ptr, r6=buffer_offset, r7=buffer_base) -> (r0, r1,
// symdb: nzcv)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_scanChipSeq_80295C8.yaml
	thumb_local_start
battle_scanChipSeq_80295C8:
	push {r2,r4-r6,lr}
	mov r5, r2
	ldrh r1, [r3,#4]
loc_80295CE:
	ldrh r0, [r7,r6]
	cmp r0, r1
	bne loc_8029616
	add r6, #2
	sub r2, #1
	bne loc_80295CE
	mov r2, #0
	add r6, #8
	ldrh r0, [r7,r6]
	add r0, #1
loc_80295E2:
	ldrh r1, [r7,r6]
	cmp r1, #0x1a
	bne loc_80295FA
	cmp r2, #0
	bne loc_80295F6
	cmp r0, #0x1b
	bne loc_80295F6
	sub r0, r6, #2
	ldrh r0, [r7,r0]
	add r0, #2
loc_80295F6:
	sub r1, r0, #1
	add r2, #1
loc_80295FA:
	sub r0, #1
	cmp r0, r1
	bne loc_8029616
	sub r6, #2
	sub r5, #1
	bne loc_80295E2
	cmp r2, #1
	bgt loc_8029616
	cmp r0, #0
	blt loc_8029616
	ldrh r0, [r3,#2]
	mov r1, r6
	sub r1, #8
	b locret_8029618
loc_8029616:
	mov r0, #0
locret_8029618:
	pop {r2,r4-r6,pc}
	thumb_func_end battle_scanChipSeq_80295C8

// symdb: Compares a run of halfwords from a buffer against one pattern record and, on a full match, returns that record's result value.
// symdb: i32 matchHalfwordPatternEntry(u32 count /*r2*/, struct record* rec /*r3*/, u32 stride /*r6*/,
// symdb: u16* src /*r7*/) -> result in r0 (rec->result halfword on success, 0 on mismatch), r1 = stride
// symdb: on success / the mismatched expected halfword on failure; NZ set from final move, C/V from the
// symdb: last halfword compare
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/matchHalfwordPatternEntry_802961A.yaml
	thumb_local_start
matchHalfwordPatternEntry_802961A:
	push {r2,r4,r7,lr}
	mov r4, r3
	add r4, #4
	add r7, r7, r6
loc_8029622:
	ldrh r0, [r7]
	ldrh r1, [r4]
	cmp r0, r1
	bne loc_8029638
	add r4, #2
	add r7, #2
	sub r2, #1
	bne loc_8029622
	ldrh r0, [r3,#2]
	mov r1, r6
	b locret_802963A
loc_8029638:
	mov r0, #0
locret_802963A:
	pop {r2,r4,r7,pc}
	thumb_func_end matchHalfwordPatternEntry_802961A

	thumb_local_start
sub_802963C:
	push {r0-r3,lr}
	bl encryption_applyPack_8006e70 // (int idx_20008A0) -> void
	ldr r1, off_802967C // =0x140 
	sub r0, r0, r1
	ldr r1, off_8029680 // =0x1f60 
	add r0, r0, r1
	mov r0, r0
	bl SetEventFlag
	pop {r0-r3,pc}
	thumb_func_end sub_802963C

	thumb_local_start
sub_8029652:
	push {r4,lr}
	ldr r3, off_8029684 // =dword_203CA48 
	lsl r1, r1, #2
	add r3, r3, r1
	ldr r2, off_802967C // =0x140 
	sub r2, r0, r2
	mov r1, #7
	and r1, r2
	lsr r2, r2, #3
	add r3, r3, r2
	ldrb r4, [r3]
	mov r2, #1
	lsl r2, r1
	tst r4, r2
	beq loc_8029674
	mov r0, #0
	b locret_8029678
loc_8029674:
	orr r4, r2
	strb r4, [r3]
locret_8029678:
	pop {r4,pc}
	.balign 4, 0
off_802967C:
	.word 0x140
off_8029680:
	.word 0x1F60
off_8029684:
	.word dword_203CA48
	thumb_func_end sub_8029652

// symdb: Shuffle-once, per-tick step: copies the hand's eligible chips into dword_2033000, shuffles them with ShuffleHwordList_SecondaryRNG and writes them back into eBattleFolder — one secondary-RNG shuffle per tick (8 ticks, from sub_802723A).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8029688.yaml
	thumb_local_start
sub_8029688:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	mov r0, #0
	str r0, [sp]
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	mov r0, #0x44 
	ldrb r0, [r1,r0]
	tst r0, r0
	beq loc_80296A2
	mov r0, #0x45 
	ldrb r0, [r1,r0]
	str r0, [sp]
loc_80296A2:
	ldr r7, off_8029784 // =dword_2033000 
	ldr r6, off_80298D4 // =eBattleFolder 
	ldrb r4, [r5,#6]
	cmp r4, #0
	beq loc_80296DE
	mov r3, #0
	mov r2, #0
loc_80296B0:
	mov r0, r3
	push {r2,r3}
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	pop {r2,r3}
	ldrb r1, [r0]
	cmp r1, #0
	bne loc_80296D8
	ldrb r1, [r0,#7]
	cmp r1, #2
	beq loc_80296D6
	ldrb r1, [r0,#4]
	mov r0, #1
	tst r1, r0
	bne loc_80296D6
	ldrh r0, [r6]
	strh r0, [r7]
	add r7, #2
	add r2, #1
loc_80296D6:
	add r6, #2
loc_80296D8:
	add r3, #1
	sub r4, #1
	bne loc_80296B0
loc_80296DE:
	ldrb r3, [r5,#5]
	ldrb r0, [r5,#6]
	sub r3, r3, r0
	bmi loc_802970C
	beq loc_802970C
loc_80296E8:
	ldr r0, [sp]
	tst r0, r0
	beq loc_80296FE
	lsl r0, r0, #1
	ldr r1, off_80298D4 // =eBattleFolder 
	add r0, r0, r1
	cmp r0, r6
	bne loc_80296FE
	add r6, #4
	sub r3, #2
	b loc_802970A
loc_80296FE:
	ldrh r0, [r6]
	strh r0, [r7]
	add r6, #2
	add r7, #2
	add r2, #1
	sub r3, #1
loc_802970A:
	bne loc_80296E8
loc_802970C:
	cmp r2, #0
	beq loc_802977E
	ldr r0, off_8029784 // =dword_2033000 
	mov r7, r0
	mov r1, r2
	bl ShuffleHwordList_SecondaryRNG
	ldrb r4, [r5,#6]
	cmp r4, #0
	beq loc_8029750
	ldr r6, off_80298D4 // =eBattleFolder 
	mov r3, #0
loc_8029724:
	mov r0, r3
	push {r3}
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	pop {r3}
	ldrb r1, [r0]
	cmp r1, #0
	bne loc_802974A
	ldrb r1, [r0,#7]
	cmp r1, #2
	beq loc_8029748
	ldrb r1, [r0,#4]
	mov r0, #1
	tst r1, r0
	bne loc_8029748
	ldrh r0, [r7]
	strh r0, [r6]
	add r7, #2
loc_8029748:
	add r6, #2
loc_802974A:
	add r3, #1
	sub r4, #1
	bne loc_8029724
loc_8029750:
	ldrb r3, [r5,#5]
	ldrb r0, [r5,#6]
	sub r3, r3, r0
	bmi loc_802977E
	beq loc_802977E
loc_802975A:
	ldr r0, [sp]
	tst r0, r0
	beq loc_8029770
	lsl r0, r0, #1
	ldr r1, off_80298D4 // =eBattleFolder 
	add r0, r0, r1
	cmp r0, r6
	bne loc_8029770
	add r6, #4
	sub r3, #2
	b loc_802977C
loc_8029770:
	ldrh r0, [r7]
	strh r0, [r6]
	add r6, #2
	add r7, #2
	add r2, #1
	sub r3, #1
loc_802977C:
	bne loc_802975A
loc_802977E:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_8029784:
	.word dword_2033000
	thumb_func_end sub_8029688

// symdb: Shuffle-once, first step: copies the hand's eligible chips (eBattleFolder[0 .. S20364C0+6), skipping used (slot byte 2) and disabled (bit 0 of +4)) into word_2036660 and shuffles that buffer with ShuffleHwordList_SecondaryRNG in two segments split at byte_80298C8[kind] (all-zero table = one segment).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8029788.yaml
	thumb_local_start
sub_8029788:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	mov r0, #0
	str r0, [sp]
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	mov r0, #0x44 
	ldrb r0, [r1,r0]
	tst r0, r0
	beq loc_80297A2
	mov r0, #0x45 
	ldrb r0, [r1,r0]
	str r0, [sp]
loc_80297A2:
	ldr r7, off_80298C0 // =word_2036660 
	ldr r6, off_80298D4 // =eBattleFolder 
	mov r3, #0
	mov r2, #0
	ldrb r4, [r5,#6]
	cmp r4, #0
	beq loc_80297E0
loc_80297B0:
	mov r0, r3
	push {r2,r3}
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	pop {r2,r3}
	ldrb r1, [r0]
	cmp r1, #0
	bne loc_80297D8
	ldrb r1, [r0,#7]
	cmp r1, #2
	beq loc_80297D6
	ldrb r1, [r0,#4]
	mov r0, #1
	tst r1, r0
	bne loc_80297D6
	ldrh r0, [r6]
	strh r0, [r7]
	add r7, #2
	add r2, #1
loc_80297D6:
	add r6, #2
loc_80297D8:
	add r3, #1
	sub r4, #1
	bne loc_80297B0
	mov r4, r2
loc_80297E0:
	ldrb r3, [r5,#5]
	ldrb r0, [r5,#6]
	sub r3, r3, r0
	bmi loc_802980E
	beq loc_802980E
loc_80297EA:
	ldr r0, [sp]
	tst r0, r0
	beq loc_8029800
	lsl r0, r0, #1
	ldr r1, off_80298D4 // =eBattleFolder 
	add r0, r0, r1
	cmp r0, r6
	bne loc_8029800
	add r6, #4
	sub r3, #2
	b loc_802980C
loc_8029800:
	ldrh r0, [r6]
	strh r0, [r7]
	add r6, #2
	add r7, #2
	add r2, #1
	sub r3, #1
loc_802980C:
	bne loc_80297EA
loc_802980E:
	cmp r2, #0
	beq loc_8029838
	ldr r0, off_80298C0 // =word_2036660 
	push {r0,r2}
	ldr r1, off_80298C4 // =byte_80298C8
	ldrb r3, [r1,r4]
	cmp r3, #0
	beq loc_802982A
	mov r1, r4
	mov r2, r4
	push {r3}
	bl ShuffleHwordList_SecondaryRNG
	pop {r3}
loc_802982A:
	pop {r0,r2}
	sub r2, r2, r3
	lsl r3, r3, #1
	add r0, r0, r3
	mov r1, r2
	bl ShuffleHwordList_SecondaryRNG
loc_8029838:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	thumb_func_end sub_8029788

// symdb: Shuffle-once, final step: copies the shuffled snapshot word_2036660 back over the hand's eligible slots in eBattleFolder (no shuffle here).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_802983C.yaml
	thumb_local_start
sub_802983C:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	mov r0, #0
	str r0, [sp]
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	mov r0, #0x44 
	ldrb r0, [r1,r0]
	tst r0, r0
	beq loc_8029856
	mov r0, #0x45 
	ldrb r0, [r1,r0]
	str r0, [sp]
loc_8029856:
	ldr r7, off_80298C0 // =word_2036660 
	ldr r6, off_80298D4 // =eBattleFolder 
	ldrb r4, [r5,#6]
	cmp r4, #0
	beq loc_802988E
	mov r3, #0
loc_8029862:
	mov r0, r3
	push {r3}
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	pop {r3}
	ldrb r1, [r0]
	cmp r1, #0
	bne loc_8029888
	ldrb r1, [r0,#7]
	cmp r1, #2
	beq loc_8029886
	ldrb r1, [r0,#4]
	mov r0, #1
	tst r1, r0
	bne loc_8029886
	ldrh r0, [r7]
	strh r0, [r6]
	add r7, #2
loc_8029886:
	add r6, #2
loc_8029888:
	add r3, #1
	sub r4, #1
	bne loc_8029862
loc_802988E:
	ldrb r3, [r5,#5]
	ldrb r0, [r5,#6]
	sub r3, r3, r0
	bmi loc_80298BC
	beq loc_80298BC
loc_8029898:
	ldr r0, [sp]
	tst r0, r0
	beq loc_80298AE
	lsl r0, r0, #1
	ldr r1, off_80298D4 // =eBattleFolder 
	add r0, r0, r1
	cmp r0, r6
	bne loc_80298AE
	add r6, #4
	sub r3, #2
	b loc_80298BA
loc_80298AE:
	ldrh r0, [r7]
	strh r0, [r6]
	add r6, #2
	add r7, #2
	add r2, #1
	sub r3, #1
loc_80298BA:
	bne loc_8029898
loc_80298BC:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_80298C0:
	.word word_2036660
off_80298C4:
	.word byte_80298C8
byte_80298C8:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
off_80298D4:
	.word eBattleFolder
	thumb_func_end sub_802983C

	thumb_local_start
sub_80298D8:
	push {lr}
	ldr r0, dword_80298EC // =0x40600000 
	ldr r1, [r5,#0x44]
	add r0, r0, r1
	ldr r1, dword_80298F0 // =0xd796 
	mov r2, #1
	mov r3, #0
	bl fifo_pushRecord16_8009FF8
	pop {pc}
	.balign 4, 0
dword_80298EC:
	.word 0x40600000
dword_80298F0:
	.word 0xD796
	thumb_func_end sub_80298D8

// symdb: Per-frame handler for the first battle tutorial custMenu: polls the current tutorial state's check routine and, if it yields a message, plays it through the chatbox while parking the menu.
// symdb: int custMenu_firstBattleTutorialTick_80298F4(custMenu* menu /* r5 */); returns r0 = 1 when a
// symdb: text script was started this frame, 0 otherwise (no tutorial active, no check for this state, or
// symdb: the check produced nothing). r2/r3 are returned as the callees leave them; r4-r7/r10 preserved.
// symdb: Flags clobbered (nzcv).
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/custMenu_80298F4.yaml
	thumb_local_start
custMenu_80298F4:
	push {lr}
	ldrb r0, [r5,#0xc]
	cmp r0, #0xff
	beq loc_80299B2
	cmp r0, #0
	beq loc_8029918
	cmp r0, #1
	beq loc_8029924
	cmp r0, #3
	beq loc_8029930
	cmp r0, #4
	beq loc_802993C
	cmp r0, #5
	beq loc_802993C
	cmp r0, #6
	beq loc_8029948
	mov r0, #0
	b locret_802996C
loc_8029918:
	bl sub_802996E
	cmp r0, #0
	beq locret_802996C
	mov r1, r0
	b loc_8029952
loc_8029924:
	bl battle_getPrepStatus_80299B6
	cmp r0, #0
	beq locret_802996C
	mov r1, r0
	b loc_8029952
loc_8029930:
	bl sub_80299FA
	cmp r0, #0
	beq locret_802996C
	mov r1, r0
	b loc_8029952
loc_802993C:
	bl sub_8029A1E
	cmp r0, #0
	beq locret_802996C
	mov r1, r0
	b loc_8029952
loc_8029948:
	bl sub_8029A36
	cmp r0, #0
	beq locret_802996C
	mov r1, r0
loc_8029952:
	ldr r0, off_8029C04 // =TextScriptFirstBattleTutorials
	ldrb r2, [r5,#0xc]
	lsl r2, r2, #2
	ldr r0, [r0,r2]
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	ldrb r0, [r5,#1]
	strb r0, [r5,#0xd]
	mov r0, #0x34 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov r0, #1
locret_802996C:
	pop {pc}
	thumb_func_end custMenu_80298F4

	thumb_local_start
sub_802996E:
	push {lr}
	ldrb r0, [r5,#7]
	cmp r0, #0xa
	bne loc_80299B2
	ldrb r0, [r5,#8]
	cmp r0, #0
	bne loc_8029980
	mov r0, #0xc
	b locret_80299B4
loc_8029980:
	cmp r0, #2
	bge loc_8029994
	mov r3, #0x48 
	ldrb r0, [r5,r3]
	cmp r0, #0
	beq loc_8029990
	cmp r0, #2
	bne loc_80299AE
loc_8029990:
	mov r0, #0xb
	b locret_80299B4
loc_8029994:
	mov r3, #0x48 
	add r3, r3, r5
	ldrb r0, [r3]
	ldrb r1, [r3,#1]
	cmp r0, r1
	blt loc_80299A6
	mov r2, r0
	mov r0, r1
	mov r1, r2
loc_80299A6:
	cmp r0, #0
	bne loc_80299AE
	cmp r1, #2
	beq loc_80299B2
loc_80299AE:
	mov r0, #0x17
	b locret_80299B4
loc_80299B2:
	mov r0, #0
locret_80299B4:
	pop {pc}
	thumb_func_end sub_802996E

// symdb: Inspects a battle object's prep-state/mode/slot fields and returns a preparation-status code (0/8/9/0xD) for the navi-cust battle flow.
// symdb: u8 battle_getPrepStatus_80299B6(void *obj /* r5 */);  // returns status in r0, leaves r3 = 0x48
// symdb: or 0x49 (or untouched on early exit)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getPrepStatus_80299B6.yaml
	thumb_local_start
battle_getPrepStatus_80299B6:
	push {lr}
	ldrb r0, [r5,#7]
	cmp r0, #0xa
	bne loc_80299F6
	ldrb r0, [r5,#8]
	cmp r0, #0
	beq loc_80299F2
	cmp r0, #1
	beq loc_80299E6
	mov r3, #0x48 
	ldrb r0, [r5,r3]
	add r3, #1
	ldrb r1, [r5,r3]
	cmp r0, #0
	bne loc_80299DA
	cmp r1, #1
	beq loc_80299F6
	b loc_80299EE
loc_80299DA:
	cmp r0, #1
	bne loc_80299F2
	cmp r1, #0
	bne loc_80299F2
	mov r0, #9
	b locret_80299F8
loc_80299E6:
	mov r3, #0x48 
	ldrb r0, [r5,r3]
	cmp r0, #0
	bne loc_80299F2
loc_80299EE:
	mov r0, #0xd
	b locret_80299F8
loc_80299F2:
	mov r0, #8
	b locret_80299F8
loc_80299F6:
	mov r0, #0
locret_80299F8:
	pop {pc}
	thumb_func_end battle_getPrepStatus_80299B6

	thumb_local_start
sub_80299FA:
	push {lr}
	ldrb r0, [r5,#7]
	cmp r0, #0xa
	beq loc_8029A10
	cmp r0, #0xb
	beq loc_8029A1A
	ldrb r0, [r5,#0x17]
	tst r0, r0
	bne loc_8029A1A
	mov r0, #0x24 
	b locret_8029A1C
loc_8029A10:
	ldrb r0, [r5,#0x17]
	tst r0, r0
	bne loc_8029A1A
	mov r0, #0x25 
	b locret_8029A1C
loc_8029A1A:
	mov r0, #0
locret_8029A1C:
	pop {pc}
	thumb_func_end sub_80299FA

	thumb_local_start
sub_8029A1E:
	push {lr}
	ldrb r0, [r5,#7]
	cmp r0, #0xb
	bne loc_8029A32
	bl battle_getActorEmotion_802A564
	tst r3, r3
	bne loc_8029A32
	mov r0, #0x26 
	b locret_8029A34
loc_8029A32:
	mov r0, #0
locret_8029A34:
	pop {pc}
	thumb_func_end sub_8029A1E

	thumb_local_start
sub_8029A36:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#7]
	cmp r0, #1
	bne loc_8029A52
	ldrb r0, [r5,#0x19]
	tst r0, r0
	bne loc_8029A52
	ldrb r0, [r5,#1]
	cmp r0, #0x54 
	beq loc_8029A52
	mov r0, #4
	b locret_8029A54
loc_8029A52:
	mov r0, #0
locret_8029A54:
	pop {pc}
	thumb_func_end sub_8029A36

// symdb: Advances the first-battle tutorial chatbox driver one tick, running a tutorial text script when its state predicate succeeds.
// symdb: void firstBattleTutorial_step_8029A56(struct FirstBattleTutorialObj* obj /* r5 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/firstBattleTutorial_step_8029A56.yaml
	thumb_local_start
firstBattleTutorial_step_8029A56:
	push {lr}
	ldrb r0, [r5,#0xc]
	cmp r0, #0xff
	beq locret_8029AA8
	cmp r0, #0
	beq loc_8029A6C
	cmp r0, #1
	beq loc_8029A78
	cmp r0, #3
	beq loc_8029A84
	b locret_8029AA8
loc_8029A6C:
	bl battle_getObjectStatusCode_8029AAA
	cmp r0, #0
	beq locret_8029AA8
	mov r1, r0
	b loc_8029A90
loc_8029A78:
	bl entity_getActionIndex_8029ADA
	cmp r0, #0
	beq locret_8029AA8
	mov r1, r0
	b loc_8029A90
loc_8029A84:
	bl sub_8029B16
	cmp r0, #0
	beq locret_8029AA8
	mov r1, r0
	b loc_8029A90
loc_8029A90:
	ldr r0, off_8029C04 // =TextScriptFirstBattleTutorials
	ldrb r2, [r5,#0xc]
	lsl r2, r2, #2
	ldr r0, [r0,r2]
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	ldrb r0, [r5,#1]
	strb r0, [r5,#0xd]
	mov r0, #0x34 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_8029AA8:
	pop {pc}
	thumb_func_end firstBattleTutorial_step_8029A56

// symdb: Maps a battle object's mode (+7) and sub-state (+8) bytes to a numeric status code for other battle logic.
// symdb: u32 battle_getObjectStatusCode_8029AAA(u32 r5 /* battle object ptr */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getObjectStatusCode_8029AAA.yaml
	thumb_local_start
battle_getObjectStatusCode_8029AAA:
	push {lr}
	ldrb r0, [r5,#7]
	cmp r0, #0
	beq loc_8029AC4
	cmp r0, #2
	beq loc_8029AC4
	cmp r0, #0xa
	beq loc_8029AD2
	ldrb r0, [r5,#8]
	cmp r0, #2
	bgt loc_8029AD6
	mov r0, #0x16
	b locret_8029AD8
loc_8029AC4:
	ldrb r0, [r5,#8]
	cmp r0, #1
	bne loc_8029ACE
	mov r0, #9
	b locret_8029AD8
loc_8029ACE:
	mov r0, #0xe
	b locret_8029AD8
loc_8029AD2:
	mov r0, #0x10
	b locret_8029AD8
loc_8029AD6:
	mov r0, #0
locret_8029AD8:
	pop {pc}
	thumb_func_end battle_getObjectStatusCode_8029AAA

// symdb: Picks an animation/action index for an entity based on its current state (byte 7) and detail (byte 8).
// symdb: u8 entity_getActionIndex_8029ADA(void); // r5 = entity struct, returns action index in r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/entity_getActionIndex_8029ADA.yaml
	thumb_local_start
entity_getActionIndex_8029ADA:
	push {lr}
	ldrb r0, [r5,#7]
	cmp r0, #0
	beq loc_8029AF4
	cmp r0, #1
	beq loc_8029AFE
	cmp r0, #0xa
	beq loc_8029B0E
	ldrb r0, [r5,#8]
	cmp r0, #2
	bge loc_8029B12
	mov r0, #7
	b locret_8029B14
loc_8029AF4:
	ldrb r0, [r5,#8]
	cmp r0, #1
	bne loc_8029B12
	mov r0, #5
	b locret_8029B14
loc_8029AFE:
	ldrb r0, [r5,#8]
	cmp r0, #2
	blt loc_8029B0A
	bne loc_8029B12
	mov r0, #0xa
	b locret_8029B14
loc_8029B0A:
	mov r0, #6
	b locret_8029B14
loc_8029B0E:
	mov r0, #0xf
	b locret_8029B14
loc_8029B12:
	mov r0, #0
locret_8029B14:
	pop {pc}
	thumb_func_end entity_getActionIndex_8029ADA

	thumb_local_start
sub_8029B16:
	push {lr}
	mov r0, #0
	pop {pc}
	thumb_func_end sub_8029B16

// symdb: First-battle tutorial text trigger — for the current tutorial step, asks a per-step checker if a chatbox script should play, runs it, and moves the task into its post-text wait state.
// symdb: u32 tutorialTextUpdate(void* work /* r5 */); returns 1 if a script started, 0 otherwise; reads
// symdb: r5=work, clobbers r0-r3 and flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleTutorial_first_checkTextStep_8029B1C.yaml
	thumb_local_start
battleTutorial_first_checkTextStep_8029B1C:
	push {lr}
	ldrb r0, [r5,#0xc]
	cmp r0, #0xff
	beq loc_8029BA8
	cmp r0, #0
	beq loc_8029B3C
	cmp r0, #1
	beq loc_8029B48
	cmp r0, #3
	beq loc_8029B54
	cmp r0, #4
	beq loc_8029B54
	cmp r0, #6
	beq loc_8029B60
	mov r0, #0
	b locret_8029B84
loc_8029B3C:
	bl sub_8029B86
	cmp r0, #0
	beq locret_8029B84
	mov r1, r0
	b loc_8029B6A
loc_8029B48:
	bl sub_8029BAC
	cmp r0, #0
	beq locret_8029B84
	mov r1, r0
	b loc_8029B6A
loc_8029B54:
	bl sub_8029BD6
	cmp r0, #0
	beq locret_8029B84
	mov r1, r0
	b loc_8029B6A
loc_8029B60:
	bl sub_8029BE6
	cmp r0, #0
	beq locret_8029B84
	mov r1, r0
loc_8029B6A:
	ldr r0, off_8029C04 // =TextScriptFirstBattleTutorials
	ldrb r2, [r5,#0xc]
	lsl r2, r2, #2
	ldr r0, [r0,r2]
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	ldrb r0, [r5,#1]
	strb r0, [r5,#0xd]
	mov r0, #0x34 
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov r0, #1
locret_8029B84:
	pop {pc}
	thumb_func_end battleTutorial_first_checkTextStep_8029B1C

	thumb_local_start
sub_8029B86:
	push {lr}
	ldrb r0, [r5,#8]
	cmp r0, #0
	beq loc_8029BA8
	cmp r0, #2
	bgt loc_8029BA8
	mov r3, #0x47 
	add r3, r3, r0
	ldrb r3, [r5,r3]
	cmp r3, #0
	beq loc_8029BA0
	cmp r3, #2
	bne loc_8029BA8
loc_8029BA0:
	mov r1, #5
	mul r0, r1
	add r0, #5
	b locret_8029BAA
loc_8029BA8:
	mov r0, #0
locret_8029BAA:
	pop {pc}
	thumb_func_end sub_8029B86

	thumb_local_start
sub_8029BAC:
	push {lr}
	ldrb r0, [r5,#8]
	cmp r0, #0
	beq loc_8029BD2
	cmp r0, #2
	bgt loc_8029BD2
	mov r3, #0x47 
	add r3, r3, r0
	ldrb r3, [r5,r3]
	cmp r0, #1
	bne loc_8029BCA
	cmp r3, #0
	bne loc_8029BD2
	mov r0, #0xb
	b locret_8029BD4
loc_8029BCA:
	cmp r3, #1
	bne loc_8029BD2
	mov r0, #0xc
	b locret_8029BD4
loc_8029BD2:
	mov r0, #0
locret_8029BD4:
	pop {pc}
	thumb_func_end sub_8029BAC

	thumb_local_start
sub_8029BD6:
	push {lr}
	ldrb r0, [r5,#8]
	cmp r0, #1
	bne loc_8029BE2
	mov r0, #0x27 
	b locret_8029BE4
loc_8029BE2:
	mov r0, #0
locret_8029BE4:
	pop {pc}
	thumb_func_end sub_8029BD6

	thumb_local_start
sub_8029BE6:
	push {lr}
	ldrb r0, [r5,#8]
	cmp r0, #0
	bne loc_8029BFE
	ldrb r0, [r5,#0x19]
	tst r0, r0
	beq loc_8029BFE
	ldrb r0, [r5,#1]
	cmp r0, #0x54 
	beq loc_8029BFE
	mov r0, #5
	b locret_8029C00
loc_8029BFE:
	mov r0, #0
locret_8029C00:
	pop {pc}
	.balign 4, 0
off_8029C04:
	.word TextScriptFirstBattleTutorials
	thumb_func_end sub_8029BE6

	thumb_local_start
sub_8029C08: // (self: * S20364C0 $r5) -> ()
	push {lr}

	ldrb r0, [r5,#oS20364C0_JumpOffset01]
	cmp r0, #0x48 
	beq loc_8029C14

	cmp r0, #0x44 
	bne loc_8029C18

loc_8029C14:
	mov r1, #0
	b loc_8029C22
loc_8029C18:
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	ldrh r1, [r1,#0x18]
	cmp r1, #0x67 
	bgt locret_8029C9A
loc_8029C22:
	mov r0, #0x57 
	sub r0, r0, r1
	ldr r1, dword_8029CA4 // =0x1ff 
	and r0, r1
	lsl r0, r0, #0x10
	ldr r1, dword_8029C9C // =0x800001fc 
	add r0, r0, r1

	ldrb r1, [r5,#oS20364C0_Unk_0f]
	cmp r1, #2

	blt loc_8029C46
	cmp r1, #6
	bgt loc_8029C46
	sub r0, #1
	cmp r1, #3
	blt loc_8029C46
	cmp r1, #4
	bgt loc_8029C46
	sub r0, #1
loc_8029C46:
	cmp r1, #5
	blt loc_8029C54
	cmp r1, #0xb
	bgt loc_8029C54
	mov r1, #1
	lsl r1, r1, #0x10
	add r0, r0, r1
loc_8029C54:
	cmp r1, #2
	blt loc_8029C62
	cmp r1, #3
	bgt loc_8029C62
	mov r1, #1
	lsl r1, r1, #0x10
	sub r0, r0, r1
loc_8029C62:
	ldrb r1, [r5,#oS20364C0_Unk_0e]
	lsl r1, r1, #0x19
	orr r0, r1
	ldr r1, dword_8029CA0 // =0xb782 
	mov r2, #1
	mov r3, #0
	bl fifo_pushRecord16_8009FF8
	ldrb r0, [r5,#oS20364C0_Unk_0f]
	cmp r0, #0
	beq locret_8029C9A
	cmp r0, #0x14
	blt loc_8029C82
	mov r0, #0
	strb r0, [r5,#oS20364C0_Unk_0f]
	b locret_8029C9A
loc_8029C82:
	add r1, r0, #1
	strb r1, [r5,#oS20364C0_Unk_0f]
	sub r0, #1
	ldr r1, off_8029CA8 // =byte_8029CAC
	lsl r0, r0, #1
	add r2, r0, #1
	ldrb r2, [r1,r2]
	ldrb r0, [r1,r0]
	mov r1, r2
	ldrb r3, [r5,#oS20364C0_Unk_0e]
	bl sub_802FE7A
locret_8029C9A:
	pop {pc}
	.balign 4, 0
dword_8029C9C:
	.word 0x800001FC
dword_8029CA0:
	.word 0xB782
dword_8029CA4:
	.word 0x1FF
off_8029CA8:
	.word byte_8029CAC
byte_8029CAC:
	.byte 0x0, 0x40, 0x20, 0x3C, 0x40, 0x3A, 0x60, 0x38, 0x80
	.byte 0x37, 0xA0, 0x36, 0xB0, 0x36, 0xC0, 0x36, 0xD0, 0x37
	.byte 0xD8, 0x38, 0xE0, 0x39, 0xE8, 0x3A, 0xEC, 0x3B, 0xF0
	.byte 0x3C, 0xF4, 0x3D, 0xF8, 0x3E, 0xFB, 0x3F, 0xFE, 0x40
	.byte 0x0, 0x40, 0x0, 0x0
	thumb_func_end sub_8029C08

	thumb_local_start
sub_8029CD4:
	push {r4-r6,lr}
	mov r4, #0x89
	lsl r1, r1, #1
	add r4, r4, r1
	mov r1, #0x1e
	lsl r0, r0, #1
	add r0, #3
	mul r0, r1
	add r0, #0x16
	ldr r1, off_8029D30 // =unk_2035000 
	add r1, r1, r0
	ldr r3, off_8029D14 // =byte_8029D18
	mov r5, #0
loc_8029CEE:
	ldrh r6, [r3,r5]
	add r5, #2
	ldrh r0, [r3,r5]
	add r5, #2
	add r0, r0, r4
	strh r0, [r1,r6]
	cmp r5, #0x10
	bne loc_8029CEE
	cmp r2, #0
	bne locret_8029D12
	// j
	mov r0, #0
	// i
	mov r1, #3
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_8029D28 // =unk_203505A 
	mov r4, #0xf
	mov r5, #0xa
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
locret_8029D12:
	pop {r4-r6,pc}
	.balign 4, 0
off_8029D14:
	.word byte_8029D18
byte_8029D18:
	.byte 0x0, 0x0, 0x0, 0x90, 0x1E, 0x0, 0x1, 0x90, 0x6, 0x0, 0x0, 0x94, 0x24
	.byte 0x0, 0x1, 0x94
off_8029D28:
	.word unk_203505A
	.word 0x3FF
off_8029D30:
	.word unk_2035000
	thumb_func_end sub_8029CD4

// symdb: While a battle is ending, swaps the background tile block 3 strip for the ending sequence, or delegates to a late-phase handler past phase 0x1C.
// symdb: void battle_endingBgUpdate_8029D34(void) // r5=battle_state (phase @ +0x40, &0x1F), r4 forwarded
// symdb: to sub_8029D80; clobbers r0-r3, preserves r4-r7; NZCVV undefined
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_endingBgUpdate_8029D34.yaml
	thumb_local_start
battle_endingBgUpdate_8029D34:
	push {r4,r5,lr}
	bl battle_IsBattleEnding_800A97A
	cmp r0, #0
	beq locret_8029D5E
	ldr r0, [r5,#0x40]
	mov r1, #0x1f
	and r0, r1
	cmp r0, #0x1c
	blt loc_8029D4E
	bl sub_8029D80
	b locret_8029D5E
loc_8029D4E:
	// j
	mov r0, #0xf
	// i
	mov r1, #4
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_8029D60 // =byte_8029D64 
	mov r4, #7
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
locret_8029D5E:
	pop {r4,r5,pc}
	.balign 4, 0
off_8029D60:
	.word byte_8029D64
byte_8029D64:
	.byte 0x8D, 0x90, 0x8E, 0x90, 0x8F, 0x90, 0x90, 0x90, 0x91
	.byte 0x90, 0x92, 0x90, 0x93, 0x90, 0x94, 0x90, 0x95, 0x90
	.byte 0x96, 0x90, 0x97, 0x90, 0x98, 0x90, 0x99, 0x90, 0x9A
	.byte 0x90
	thumb_func_end battle_endingBgUpdate_8029D34

// symdb: Fixed-argument wrapper that invokes call_sub_3005EBA with the constant set (0xF, 4, 3, 0, 7, 2) and returns its r1-r3 results.
// symdb: void sub_8029D80(void); /* out: r1, r2, r3 = callee results passed through; r4-r7 preserved */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8029D80.yaml
	thumb_local_start
sub_8029D80:
	push {r4,r5,lr}
	mov r0, #0xf
	mov r1, #4
	mov r2, #3
	mov r3, #0
	mov r4, #7
	mov r5, #2
	bl call_sub_3005EBA
	pop {r4,r5,pc}
	thumb_func_end sub_8029D80

	thumb_local_start
sub_8029D94:
	push {r4-r7,lr}
	mov r6, r0
	mov r7, r1
	mov r0, #0
	cmp r2, #2
	blt loc_8029DA2
	mov r0, #5
loc_8029DA2:
	add r0, r0, r1
	ldr r1, off_8029DDC // =0x240 
	mul r0, r1
	ldr r1, off_8029DD8 // =dword_86E7DCC 
	add r0, r0, r1
	ldr r1, off_8029DDC // =0x240 
	mov r2, r6
	mul r1, r2
	ldr r2, dword_8029DE0 // =0x600a720 
	add r1, r1, r2
	ldr r2, off_8029DDC // =0x240 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #1
	mov r1, #1
	lsl r6, r6, #1
	add r1, r1, r6
	mov r2, #3
	ldr r3, off_8029DE4 // =byte_8029DF8 
	mov r4, #0x12
	mul r4, r6
	add r3, r3, r4
	mov r4, #9
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_8029DD8:
	.word dword_86E7DCC
off_8029DDC:
	.word 0x240
dword_8029DE0:
	.word 0x600A720
off_8029DE4:
	.word byte_8029DF8
	.word byte_8029E1C
	.word byte_8029E40
	.word byte_8029E64
	.word byte_8029E88
byte_8029DF8:
	.byte 0x39, 0xA1, 0x3A, 0xA1, 0x3B, 0xA1, 0x3C, 0xA1, 0x3D
	.byte 0xA1, 0x3E, 0xA1, 0x3F, 0xA1, 0x40, 0xA1, 0x41, 0xA1
	.byte 0x42, 0xA1, 0x43, 0xA1, 0x44, 0xA1, 0x45, 0xA1, 0x46
	.byte 0xA1, 0x47, 0xA1, 0x48, 0xA1, 0x49, 0xA1, 0x4A, 0xA1
byte_8029E1C:
	.byte 0x4B, 0xA1, 0x4C, 0xA1, 0x4D, 0xA1, 0x4E, 0xA1, 0x4F
	.byte 0xA1, 0x50, 0xA1, 0x51, 0xA1, 0x52, 0xA1, 0x53, 0xA1
	.byte 0x54, 0xA1, 0x55, 0xA1, 0x56, 0xA1, 0x57, 0xA1, 0x58
	.byte 0xA1, 0x59, 0xA1, 0x5A, 0xA1, 0x5B, 0xA1, 0x5C, 0xA1
byte_8029E40:
	.byte 0x5D, 0xA1, 0x5E, 0xA1, 0x5F, 0xA1, 0x60, 0xA1, 0x61
	.byte 0xA1, 0x62, 0xA1, 0x63, 0xA1, 0x64, 0xA1, 0x65, 0xA1
	.byte 0x66, 0xA1, 0x67, 0xA1, 0x68, 0xA1, 0x69, 0xA1, 0x6A
	.byte 0xA1, 0x6B, 0xA1, 0x6C, 0xA1, 0x6D, 0xA1, 0x6E, 0xA1
byte_8029E64:
	.byte 0x6F, 0xA1, 0x70, 0xA1, 0x71, 0xA1, 0x72, 0xA1, 0x73
	.byte 0xA1, 0x74, 0xA1, 0x75, 0xA1, 0x76, 0xA1, 0x77, 0xA1
	.byte 0x78, 0xA1, 0x79, 0xA1, 0x7A, 0xA1, 0x7B, 0xA1, 0x7C
	.byte 0xA1, 0x7D, 0xA1, 0x7E, 0xA1, 0x7F, 0xA1, 0x80, 0xA1
byte_8029E88:
	.byte 0x81, 0xA1, 0x82, 0xA1, 0x83, 0xA1, 0x84, 0xA1, 0x85
	.byte 0xA1, 0x86, 0xA1, 0x87, 0xA1, 0x88, 0xA1, 0x89, 0xA1
	.byte 0x8A, 0xA1, 0x8B, 0xA1, 0x8C, 0xA1, 0x8D, 0xA1, 0x8E
	.byte 0xA1, 0x8F, 0xA1, 0x90, 0xA1, 0x91, 0xA1, 0x92, 0xA1
	thumb_func_end sub_8029D94

	thumb_local_start
sub_8029EAC:
	push {lr}
	mov r1, #0x20 
	mul r0, r1
	ldr r1, off_8029EC0 // =dword_86E944C 
	add r0, r0, r1
	ldr r1, off_8029EC4 // =unk_3001AA0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {pc}
	.balign 4, 0
off_8029EC0:
	.word dword_86E944C
off_8029EC4:
	.word unk_3001AA0
	thumb_func_end sub_8029EAC

// symdb: Returns the count of 5 listed event flags that are currently set in the save data and not yet masked off in the "0x20349A0" state word (bits 5..9).
// symdb: u32 countUnmaskedEventFlags_8029EC8(void); // r10/lr in; r0 = count out; NZCV clobbered; r4,r6
// symdb: preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/countUnmaskedEventFlags_8029EC8.yaml
	thumb_local_start
countUnmaskedEventFlags_8029EC8:
	push {r4,r6,lr}
	mov r4, #0
	mov r6, #0
loc_8029ECE:
	mov r0, r4
	lsl r0, r0, #2
	ldr r1, off_8029F48 // =byte_8029F4C
	ldr r0, [r1,r0]
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_8029EEE
	ldr r3, off_8029F6C // =dword_20349A0 
	ldr r3, [r3]
	mov r0, #1
	lsl r0, r4
	lsl r0, r0, #5
	and r3, r0
	bne loc_8029EEE
	add r6, #1
loc_8029EEE:
	add r4, #1
	cmp r4, #5
	blt loc_8029ECE
	mov r0, r6
	pop {r4,r6,pc}
	thumb_func_end countUnmaskedEventFlags_8029EC8

// symdb: Builds a list of selectable PET-Navi candidates in the caller's work area, skipping locked, masked, and currently-active ones.
// symdb: u32 sub_8029EF8(void);   // inputs:  R5 = pointer to caller's work buffer   // outputs: R0 =
// symdb: number of candidates listed (also written through R5)   // clobbers: R0..R3, LR; preserves R4,
// symdb: R5, R6; flags NZCV trashed   // calls: TestEventFlag (R0 = flag id), GetCurPETNaviStatsByte
// symdb: (R0=0, R1=0x17)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8029EF8.yaml
	thumb_local_start
sub_8029EF8:
	push {r4-r6,lr}
	mov r4, #0
	mov r6, #0
loc_8029EFE:
	mov r0, r4
	lsl r0, r0, #2
	ldr r1, off_8029F48 // =byte_8029F4C
	ldr r0, [r1,r0]
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_8029F3C
	ldr r3, off_8029F6C // =dword_20349A0 
	ldr r3, [r3]
	mov r0, #1
	lsl r0, r4
	lsl r0, r0, #5
	and r3, r0
	bne loc_8029F3C
	mov r0, #0
	mov r1, #0x17
	bl GetCurPETNaviStatsByte // (int a1, int a2) -> u8
	ldr r1, dword_8029F68 // =0x6 
	add r1, r1, r4
	cmp r0, r1
	beq loc_8029F3C
	ldr r2, off_8029F60 // =0x50 
	add r2, r2, r6
	strb r4, [r5,r2]
	ldr r2, dword_8029F64 // =0x55 
	add r2, r2, r6
	mov r3, #0
	strb r3, [r5,r2]
	add r6, #1
loc_8029F3C:
	add r4, #1
	cmp r4, #5
	blt loc_8029EFE
	mov r0, r6
	pop {r4-r6,pc}
	.balign 4, 0
off_8029F48:
	.word byte_8029F4C
byte_8029F4C:
	.byte 0xE7, 0x0, 0x0, 0x0, 0xE8, 0x0, 0x0, 0x0, 0xE9, 0x0, 0x0, 0x0, 0xEA
	.byte 0x0, 0x0, 0x0, 0xEB, 0x0, 0x0, 0x0
off_8029F60:
	.word 0x50
dword_8029F64:
	.word 0x55
dword_8029F68:
	.word 0x6
off_8029F6C:
	.word dword_20349A0
	thumb_func_end sub_8029EF8

// symdb: Returns a yes/no battle condition that is always true in battle mode 8, mode-dependent with veto checks (a battle-effects bit, event flag 163, battle flag 0x40) in modes 0/0xA/0xB, and false in all other modes.
// symdb: bool sub_8029F70(void* obj /* r5 */, ... /* r10 passed but unread */); out r0 = 1 if condition
// symdb: met else 0; preserves r4, clobbers r1/r3/lr and NZCV via helper calls
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8029F70.yaml
	thumb_local_start
sub_8029F70:
	push {r4,lr}
	mov r4, #0
	bl GetBattleMode
	cmp r0, #8
	beq loc_8029FAA
	cmp r0, #0
	beq loc_8029F88
	cmp r0, #0xa
	beq loc_8029F88
	cmp r0, #0xb
	bne loc_8029FAC
loc_8029F88:
	bl GetBattleEffects // () -> int
	ldr r1, dword_8029FB0 // =0x200000 
	tst r0, r1
	bne loc_8029FAC
	movflag EVENT_163
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_8029FA4
	ldrb r0, [r5,#0x10]
	cmp r0, #0
	beq loc_8029FAA
	b loc_8029FAC
loc_8029FA4:
	bl TestBattleFlag_0x40
	bne loc_8029FAC
loc_8029FAA:
	mov r4, #1
loc_8029FAC:
	mov r0, r4
	pop {r4,pc}
	.balign 4, 0
dword_8029FB0:
	.word 0x200000
	thumb_func_end sub_8029F70

// symdb: Returns 1 when the battle event gate is open (battle mode 5, or normal mode with no sub-state and the expected event/flag/effect conditions), else 0
// symdb: u32 sub_8029FB4(u32 r5_battleState); // out: r0 gateOpen, r4 preserved; clobbers nz c v r1 r3 lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/checkBattleEventGate_8029FB4.yaml
	thumb_local_start
checkBattleEventGate_8029FB4:
	push {r4,lr}
	mov r4, #0
	bl GetBattleMode
	cmp r0, #5
	beq loc_8029FEA
	ldrb r0, [r5,#0x10]
	cmp r0, #0
	bne loc_8029FEC
	movflag EVENT_163
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_8029FEC
	bl TestBattleFlag_0x40
	bne loc_8029FEC
	bl GetBattleEffects // () -> int
	ldr r1, dword_8029FF0 // =0x200000 
	tst r0, r1
	bne loc_8029FEC
	movflag EVENT_E0
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_8029FEC
loc_8029FEA:
	mov r4, #1
loc_8029FEC:
	mov r0, r4
	pop {r4,pc}
	.balign 4, 0
dword_8029FF0:
	.word 0x200000
	thumb_func_end checkBattleEventGate_8029FB4

// (int a1) -> bool
// symdb: Returns 1 if the given chip ID matches either of the two chip IDs stored in the table at dword_802A02C, else 0.
// symdb: bool u32 chipIDIsInSpecialPair(u32 chipID /* r0 */); preserves r1-r7; clobbers flags only
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chipIDIs13f_8029FF4.yaml
	thumb_local_start
chipIDIs13f_8029FF4:
	push {r1-r7,lr}
	mov r3, #0
	ldr r1, off_802A028 // =dword_802A02C 
	ldr r2, [r1]
	cmp r0, r2
	beq loc_802A006
	ldr r2, [r1,#0x4] // (dword_802A030 - 0x802a02c)
	cmp r0, r2
	bne loc_802A008
loc_802A006:
	mov r3, #1
loc_802A008:
	mov r0, r3
	pop {r1-r7,pc}
	thumb_func_end chipIDIs13f_8029FF4

// symdb: Returns 1 if the low 9 bits of the given ID equal a special configured value (0x13F in this build), else 0.
// symdb: int checkIdMatchesSpecialValue(u32 id); /* preserves r1-r7; returns bool in r0 with Z set iff
// symdb: true */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802A00C.yaml
	thumb_local_start
sub_802A00C:
	push {r1-r7,lr}
	mov r3, #0
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	ldr r1, off_802A028 // =dword_802A02C 
	ldr r2, [r1]
	cmp r0, r2
	beq loc_802A022
	ldr r2, [r1,#0x4] // (dword_802A030 - 0x802a02c)
	cmp r0, r2
	bne loc_802A024
loc_802A022:
	mov r3, #1
loc_802A024:
	mov r0, r3
	pop {r1-r7,pc}
	.balign 4, 0
off_802A028:
	.word dword_802A02C
dword_802A02C:
	.word 0x13F
dword_802A030:
	.word 0x13F
	thumb_func_end sub_802A00C

	thumb_local_start
sub_802A034:
	push {r1-r7,lr}
	ldr r0, dword_802A03C // =0x13f 
	pop {r1-r7,pc}
	.balign 4, 0x00
dword_802A03C:
	.word 0x13F
	thumb_func_end sub_802A034

	thumb_local_start
sub_802A040:
	push {r4,r6,r7,lr}
	ldr r1, dword_802A084 // =0xc 
	add r6, r0, r1
	tst r0, r0
	bne loc_802A072
	push {r5}
	ldr r5, off_802A114 // =eStruct2035280
	ldr r0, [r5,#0x48] // (dword_20352C8 - 0x2035280)
	ldrb r0, [r0,#0x16]
	ldrb r1, [r5,#0x17] // (eStruct2035280_NaviStatusGfxIdx17 - 0x2035280)
	cmp r1, #0
	beq loc_802A064
	ldrb r1, [r5,#0x16] // (byte_2035296 - 0x2035280)
	cmp r1, #0
	bne loc_802A064
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	b loc_802A068
loc_802A064:
	bl sub_8015B5C
loc_802A068:
	pop {r5}
	cmp r1, #0
	beq loc_802A072
	ldr r2, dword_802A0E4 // =0xc 
	add r6, r1, r2
loc_802A072:
	push {r5}
	ldr r5, off_802A114 // =eStruct2035280
	mov r0, r6
	bl sub_801E660
	mov r2, #0x4c // (byte_20352CC - 0x2035280)
	strb r0, [r5,r2]
	pop {r5}
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_802A084:
	.word 0xC
	thumb_func_end sub_802A040

	thumb_local_start
sub_802A088:
	push {r4,r6,r7,lr}
	ldr r1, dword_802A0E0 // =0x6 
	add r6, r0, r1
	push {r5}
	ldr r5, off_802A114 // =eStruct2035280
	ldr r0, [r5,#0x48] // (dword_20352C8 - 0x2035280)
	ldrb r0, [r0,#0x16]
	ldrb r1, [r5,#0x17] // (eStruct2035280_NaviStatusGfxIdx17 - 0x2035280)
	cmp r1, #0
	beq loc_802A0A8
	ldrb r1, [r5,#0x16] // (byte_2035296 - 0x2035280)
	cmp r1, #0
	bne loc_802A0A8
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	b loc_802A0AC
loc_802A0A8:
	bl sub_8015B5C
loc_802A0AC:
	pop {r5}
	cmp r1, #0xb
	blt loc_802A0B6
	ldr r2, dword_802A0E4 // =0xc 
	add r6, r6, r2
loc_802A0B6:
	push {r5}
	ldr r5, off_802A114 // =eStruct2035280
	mov r0, r6
	bl sub_801E660
	mov r2, #0x4c // (byte_20352CC - 0x2035280)
	strb r0, [r5,r2]
	pop {r5}
	pop {r4,r6,r7,pc}
	thumb_func_end sub_802A088

	thumb_local_start
sub_802A0C8:
	push {lr}
	sub r0, #1
	ldr r1, dword_802A0E8 // =0xd 
	add r0, r0, r1
	push {r5}
	ldr r5, off_802A114 // =eStruct2035280
	bl sub_801E660
	mov r2, #0x4c // (byte_20352CC - 0x2035280)
	strb r0, [r5,r2]
	pop {r5}
	pop {pc}
	.balign 4, 0
dword_802A0E0:
	.word 0x6
dword_802A0E4:
	.word 0xC
dword_802A0E8:
	.word 0xD
	thumb_func_end sub_802A0C8

// symdb: Clears the byte flag at byte_20352CC (offset 0x4C of eStruct2035280), marking the battle/event it tracks as finished.
// symdb: void sub_802A0EC(void); // in: lr only; out: r1=0, r2=0x4C, NZ set from "mov r2,#0x4C"; clobbers
// symdb: r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_ClearPendingEventFlag_802A0EC.yaml
	thumb_local_start
battle_ClearPendingEventFlag_802A0EC:
	push {lr}
	ldr r0, off_802A114 // =eStruct2035280
	mov r1, #0
	mov r2, #0x4c // (byte_20352CC - 0x2035280)
	strb r1, [r0,r2]
	pop {pc}
	thumb_func_end battle_ClearPendingEventFlag_802A0EC

// symdb: Checks the battle's pending-event flag and, if an event is queued, dispatches event flags 0x4000, then always clears the pending-event state.
// symdb: void sub_802A0F8(void); // no meaningful inputs; returns after side effects, NZ flags from the
// symdb: pending-event test survive into the clear call
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_DispatchPendingEvent_802A0F8.yaml
	thumb_local_start
battle_DispatchPendingEvent_802A0F8:
	push {lr}
	ldr r0, off_802A114 // =eStruct2035280
	mov r1, #0
	mov r2, #0x4c // (byte_20352CC - 0x2035280)
	ldrb r1, [r0,r2]
	tst r1, r1
	beq loc_802A10C
	ldr r0, dword_802A118 // =0x4000 
	bl dispatch_801DACC // (a0: flags32) -> ()
loc_802A10C:
	bl battle_ClearPendingEventFlag_802A0EC
	pop {pc}
	.balign 4, 0
off_802A114:
	.word eStruct2035280
dword_802A118:
	.word 0x4000
	thumb_func_end battle_DispatchPendingEvent_802A0F8

	thumb_local_start
sub_802A11C:
	push {r4,lr}
	ldr r1, off_802A144 // =byte_802A148
	lsl r0, r0, #2
	ldr r4, [r1,r0]
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#0xd]
	mov r1, #0x32 
	bl GetBattleNaviStatsSignedByte
	add r0, r0, r4
	cmp r0, #9
	ble loc_802A13A
	mov r0, #9
	b locret_802A140
loc_802A13A:
	cmp r0, #0
	bge locret_802A140
	mov r0, #1
locret_802A140:
	pop {r4,pc}
	.balign 4, 0
off_802A144:
	.word byte_802A148
byte_802A148:
	.byte 0x1, 0x0, 0x0, 0x0, 0x3, 0x0, 0x0, 0x0
	thumb_func_end sub_802A11C

	.byte 0xD0, 0xB5, 0xFF, 0x24, 0x3
	.byte 0xF0, 0x6E, 0xF8, 0x0, 0x28, 0x2C, 0xD1, 0x17, 0x4F, 0x78, 0x79, 0xFF, 0x28
	.byte 0x28, 0xD0, 0xF6, 0xF0, 0xF6, 0xFC, 0xFF, 0x28, 0x24, 0xD0, 0x6, 0x1C, 0x29
	.byte 0x7C, 0x88, 0x42, 0x20, 0xD0, 0x0, 0x28, 0x4, 0xD1, 0x3, 0xF0, 0x65, 0xF8
	.byte 0x8, 0x21, 0x8, 0x42, 0x18, 0xD1, 0x69, 0x7D, 0x88, 0x42, 0x11, 0xD0, 0xF9
	.byte 0x89, 0x1, 0x22, 0x82, 0x40, 0x11, 0x42, 0x11, 0xD1, 0x3, 0xF0, 0x58, 0xF8
	.byte 0x8, 0x21, 0x8, 0x42, 0x4, 0xD1, 0x30, 0x1C, 0x0, 0x20, 0x0, 0x28, 0x8
	.byte 0xD0, 0x6, 0xE0, 0x78, 0x79, 0x2, 0x28, 0x4, 0xDA, 0x30, 0x1C, 0x0, 0x20
	.byte 0x0, 0x28, 0x0, 0xD0, 0x34, 0x1C, 0x20, 0x1C, 0xD0, 0xBD, 0x0, 0x0, 0xA0
	.byte 0x49, 0x3, 0x2, 0x80, 0xB5, 0x82, 0xB0, 0x6F, 0x46, 0x3, 0xF0, 0x3E, 0xF8
	.byte 0x8, 0x21, 0x8, 0x42, 0x18, 0xD1, 0xFF, 0x21, 0x38, 0x1C, 0x1, 0x80, 0x41
	.byte 0x80, 0x81, 0x80, 0xC1, 0x80, 0xE0, 0xF7, 0xDC, 0xFB, 0x38, 0x88, 0x9, 0x49
	.byte 0x88, 0x42, 0xC, 0xDB, 0x8, 0x4A, 0x90, 0x42, 0x9, 0xDC, 0x40, 0x1A, 0x6
	.byte 0x21, 0x6, 0xDF, 0x1, 0x30, 0x1, 0x21, 0x81, 0x40, 0x2C, 0x4B, 0xD8, 0x89
	.byte 0x8, 0x43, 0xD8, 0x81, 0x2, 0xB0, 0x80, 0xBD, 0x0, 0x0, 0x1, 0x1, 0x0
	.byte 0x0, 0x42, 0x1, 0x0, 0x0


// symdb: If the battle state's field oBattleState_Unk_15 is nonzero, writes 0xFF to byte_20349A5 (an unknown battle work buffer's byte 5), likely signaling a pending state/advance request.
// symdb: void sub_802A210(r5 = battle state ptr); sets c/v from (Unk_15 != 0) comparison; returns r3 =
// symdb: 0x20349A0 when Unk_15 != 0 (callers read r3, per contract)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_setUnk20349A5Flag_802A210.yaml
	thumb_local_start
battle_setUnk20349A5Flag_802A210:
	push {lr}
	ldrb r0, [r5,#oBattleState_Unk_15]
	cmp r0, #0
	beq locret_802A21E
	ldr r3, off_802A2AC // =dword_20349A0 
	mov r0, #0xff
	strb r0, [r3,#0x5] // (byte_20349A5 - 0x20349a0)
locret_802A21E:
	pop {pc}
	thumb_func_end battle_setUnk20349A5Flag_802A210

// symdb: Returns a panel-slot candidate for an automated/navi selection in battle, or 0xFF when no candidate qualifies.
// symdb: u8 battle_pickPanelCandidate_802A220(     r2  /* unused (legacy scratch) */,     r5  /* in:
// symdb: caller struct; reads +0x3A word as a slot id to skip */,     r10 /* in: Toolkit/Task pointer;
// symdb: reads +oToolkit_BattleStatePtr */,     lr) -> u8 (r0, also returned in r4); flags: nz/v/c set
// symdb: per callees
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802A220.yaml
	thumb_local_start
sub_802A220:
	push {r4,r6,r7,lr}
	mov r4, #0xff
	movflag EVENT_163
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_802A2A2
	bl GetBattleEffects // () -> int
	ldr r1, dword_802A2A8 // =0x200000 
	tst r0, r1
	bne loc_802A2A2
	bl GetBattleMode
	cmp r0, #0
	beq loc_802A248
	cmp r0, #0xa
	beq loc_802A248
	cmp r0, #0xb
	bne loc_802A2A2
loc_802A248:
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#0xd]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte
	cmp r0, #1
	blt loc_802A25C
	cmp r0, #0xb
	ble loc_802A2A2
loc_802A25C:
	ldr r7, off_802A2AC // =dword_20349A0 
	ldrb r0, [r7,#0x5] // (byte_20349A5 - 0x20349a0)
	cmp r0, #0xff
	beq loc_802A2A2
	bl sub_8120B54
	cmp r0, #0xff
	beq loc_802A2A2
	mov r6, r0
	ldrh r1, [r5,#0x3a]
	cmp r0, r1
	beq loc_802A2A2
	ldrh r1, [r7,#0xe] // (word_20349AE - 0x20349a0)
	mov r2, #1
	lsl r2, r0
	tst r1, r2
	bne loc_802A2A2
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne loc_802A292
	mov r0, r6
	mov r0, #1
	cmp r0, #0
	beq loc_802A2A2
	b loc_802A2A0
loc_802A292:
	ldrb r0, [r7,#0x5] // (byte_20349A5 - 0x20349a0)
	cmp r0, #2
	bge loc_802A2A2
	mov r0, r6
	mov r0, #1
	cmp r0, #0
	beq loc_802A2A2
loc_802A2A0:
	mov r4, r6
loc_802A2A2:
	mov r0, r4
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_802A2A8:
	.word 0x200000
off_802A2AC:
	.word dword_20349A0
	thumb_func_end sub_802A220

	thumb_local_start
sub_802A2B0: // (self: * S20364C0 $r5) -> ()
	push {lr}
	ldr r1, off_802A2D4 // =off_802A2D8 

	ldrb r0, [r5,#oS20364C0_JumpOffset12]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1

	ldrb r0, [r5,#oS20364C0_Unk_14]
	add r0, #1
	mov r1, #0x3f 
	and r0, r1
	strb r0, [r5,#oS20364C0_Unk_14]
	bne locret_802A2D2

	ldrb r0, [r5,#oS20364C0_JumpOffset12]
	cmp r0, #0
	beq locret_802A2D2

	cmp r0, #3
	beq locret_802A2D2

locret_802A2D2:
	pop {pc}
	.balign 4, 0
off_802A2D4:
	.word off_802A2D8
off_802A2D8:
	.word fadeScreenAndAdvanceState_802A2E8+1 // (self: * S20364C0 $r5) -> ()
	.word sub_802A30C+1 // (self: * S20364C0 $r5) -> ()
	.word sub_802A33E+1 // (self: * S20364C0 $r5) -> ()
	.word sub_802A362+1 // (self: * S20364C0 $r5) -> ()
	thumb_func_end sub_802A2B0

// symdb: If a condition (sub_802A394) is met, starts a screen fade (0x54 and 0x5C with length 0xA) and advances this object's state machine to step 4.
// symdb: void sub_802A2E8(S20364C0 *self /* r5 */) -> void; flags NZ returned (from CMP r0,#0 or the
// symdb: final MOV r0,#4)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/fadeScreenAndAdvanceState_802A2E8.yaml
	thumb_local_start
fadeScreenAndAdvanceState_802A2E8: // (self: * S20364C0 $r5) -> ()
	push {lr}
	bl chipSelect_selectedSlotChipHasAttr20_802A394
	cmp r0, #0
	beq locret_802A30A
	mov r0, #0x54 
	mov r1, #0xa
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x5c 
	mov r1, #0xa
	bl loc_8006274 // (int a1, int a2) -> void
	mov r0, #0
	strb r0, [r5,#oS20364C0_Unk_13]

	mov r0, #4
	strb r0, [r5,#oS20364C0_JumpOffset12]

locret_802A30A:
	pop {pc}
	thumb_func_end fadeScreenAndAdvanceState_802A2E8

	thumb_local_start
sub_802A30C: // (self: * S20364C0 $r5) -> ()
	push {r4,lr}
	ldrb r4, [r5,#oS20364C0_Unk_13]
	ldr r2, off_802A3E8 // =byte_802A3F4 
	ldrh r2, [r2,r4]
	ldr r1, dword_802A3F0 // =0xffff 
	mov r0, #0x1f
	bl sound_dispatchSoundRequest_8000642 // (idx: u8, a1: ?, a2: ?) -> ()
	ldr r2, off_802A3EC // =byte_802A400 
	ldrh r2, [r2,r4]
	ldr r1, dword_802A3F0 // =0xffff 
	mov r0, #0x16
	bl sound_dispatchSoundRequest_8000642 // (idx: u8, a1: ?, a2: ?) -> ()
	add r4, #2
	strb r4, [r5,#oS20364C0_Unk_13]
	bl IsScreenFadeActive // () -> zf
	bl isScreenFadeActive_80062FC // () -> zf
	cmp r0, #0
	bne locret_802A33C

	mov r0, #8
	strb r0, [r5,#oS20364C0_JumpOffset12]

locret_802A33C:
	pop {r4,pc}
	thumb_func_end sub_802A30C

	thumb_local_start
sub_802A33E: // (self: * S20364C0 $r5) -> ()
	push {lr}
	bl chipSelect_selectedSlotChipHasAttr20_802A394
	cmp r0, #0
	bne locret_802A360
	mov r0, #0x50 
	mov r1, #0xa
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x58 
	mov r1, #0xa
	bl loc_8006274 // (int a1, int a2) -> void
	mov r0, #0
	strb r0, [r5,#oS20364C0_Unk_13]

	mov r0, #0xc
	strb r0, [r5,#oS20364C0_JumpOffset12]

locret_802A360:
	pop {pc}
	thumb_func_end sub_802A33E

	thumb_local_start
sub_802A362: // (self: * S20364C0 $r5) -> ()
	push {r4,lr}
	ldrb r4, [r5,#oS20364C0_Unk_13]
	ldr r2, off_802A3EC // =byte_802A400 
	ldrh r2, [r2,r4]
	ldr r1, dword_802A3F0 // =0xffff 
	mov r0, #0x1f
	bl sound_dispatchSoundRequest_8000642 // (idx: u8, a1: ?, a2: ?) -> ()
	ldr r2, off_802A3E8 // =byte_802A3F4 
	ldrh r2, [r2,r4]
	ldr r1, dword_802A3F0 // =0xffff 
	mov r0, #0x16
	bl sound_dispatchSoundRequest_8000642 // (idx: u8, a1: ?, a2: ?) -> ()
	add r4, #2
	strb r4, [r5,#oS20364C0_Unk_13]
	bl IsScreenFadeActive // () -> zf
	bl isScreenFadeActive_80062FC // () -> zf
	cmp r0, #0
	bne locret_802A392

	mov r0, #0
	strb r0, [r5,#oS20364C0_JumpOffset12]

locret_802A392:
	pop {r4,pc}
	thumb_func_end sub_802A362

// symdb: On the chip-select screen, checks whether the chip pending in the currently selected regular/custom slot has ChipData attribute bit 0x20 set, returning 1 if so.
// symdb: bool sub_802A394(ChipSelectState* state /* r5 */); also reads (but per contract ignores/passes
// symdb: through) r2,r3,r4,r6,r7,r10,lr; returns r0 = 0/1, r1 = incidental value (slot byte, 0x20, or
// symdb: stale input value), preserves r3-r7; clobbers NZCV.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chipSelect_selectedSlotChipHasAttr20_802A394.yaml
	thumb_local_start
chipSelect_selectedSlotChipHasAttr20_802A394:
	push {r4,lr}
	mov r4, #0
	ldrb r0, [r5,#1]
	cmp r0, #0x18
	beq loc_802A3A2
	cmp r0, #4
	bne loc_802A3C8
loc_802A3A2:
	ldrb r0, [r5,#7]
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r1, [r0]
	cmp r1, #0
	bne loc_802A3C8
	ldr r0, [r0,#8]
	ldrh r0, [r0]
	bl getChipID_802A54E // (int a1) -> int
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#9]
	mov r1, #0x20 
	tst r0, r1
	beq loc_802A3C8
	mov r4, #1
loc_802A3C8:
	mov r0, r4
	pop {r4,pc}
	thumb_func_end chipSelect_selectedSlotChipHasAttr20_802A394

// symdb: Fires the two-part sound effect for the start of a Cross/Beast transformation — a jingle (0x1F) immediately followed by a roar (0x16).
// symdb: void sub_802A3CC(void); // no meaningful inputs; r4-r7/r10 pass through untouched, C/V flags
// symdb: propagate from the sound dispatcher
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sound_playCrossTransformationJingle_802A3CC.yaml
	thumb_local_start
sound_playCrossTransformationJingle_802A3CC: // () -> ()
	push {lr}

	mov r0, #0x1f
	ldr r1, dword_802A3F0 // =0xffff 
	mov r2, #0x80
	add r2, #0x80
	bl sound_dispatchSoundRequest_8000642 // (idx: u8, a1: ?, a2: ?) -> ()

	mov r0, #0x16
	ldr r1, dword_802A3F0 // =0xffff 
	mov r2, #0x80
	add r2, #0x80
	bl sound_dispatchSoundRequest_8000642 // (idx: u8, a1: ?, a2: ?) -> ()
	pop {pc}
	.balign 4, 0
off_802A3E8:
	.word byte_802A3F4
off_802A3EC:
	.word byte_802A400
dword_802A3F0:
	.word 0xFFFF
byte_802A3F4:
	.byte 0x0, 0x1, 0xE0, 0x0, 0xC0, 0x0, 0xA0, 0x0, 0x80, 0x0, 0x80, 0x0
byte_802A400:
	.byte 0x80, 0x0, 0x80, 0x0, 0xA0, 0x0, 0xC0, 0x0, 0xE0, 0x0, 0x0, 0x1
	thumb_func_end sound_playCrossTransformationJingle_802A3CC

// symdb: Computes the beast-transformation turn counter for the current Navi and stores it into the caller's buffer at offset 6.
// symdb: void sub_802A40C(u8* dest /* r5 */, const Toolkit* toolkit /* r10 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_updateBeastOutCounter_802A40C.yaml
	thumb_local_start
battle_updateBeastOutCounter_802A40C:
	push {r4,r6,r7,lr}
	mov r7, #0
	mov r6, r10
	ldr r6, [r6,#oToolkit_BattleStatePtr]
	bl GetBattleMode
	cmp r0, #2
	beq loc_802A42C
	cmp r0, #3
	beq loc_802A42C
	cmp r0, #4
	beq loc_802A42C
	cmp r0, #5
	beq loc_802A42C
	cmp r0, #8
	bne loc_802A430
loc_802A42C:
	mov r0, #5
	b loc_802A498
loc_802A430:
	ldrb r0, [r6,#oBattleState_Unk_0d]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	mov r4, #1
	cmp r1, #0xa
	beq loc_802A442
	cmp r1, #0x16
	beq loc_802A442
	mov r4, #0
loc_802A442:
	ldrb r0, [r6,#oBattleState_Unk_0d]
	mov r1, #0xa
	bl GetBattleNaviStatsByte
	ldr r1, off_802A4F8 // =dword_20349A0 
	ldrb r1, [r1,#0x11] // (byte_20349B1 - 0x20349a0)
	add r0, r0, r1
	cmp r0, #8
	ble loc_802A45A
	mov r7, r0
	sub r7, #8
	mov r0, #8
loc_802A45A:
	tst r4, r4
	bne loc_802A470
	push {r0}
	bl battle_isBeastOverEnabled_802A5A0
	tst r0, r0
	pop {r0}
	beq loc_802A470
	mov r0, #0xa
	ldr r7, off_802A4F8 // =dword_20349A0 
	ldrb r7, [r7,#0x11] // (byte_20349B1 - 0x20349a0)
loc_802A470:
	push {r0}
	ldrb r0, [r6,#oBattleState_Unk_0d]
	mov r1, #0x63 
	bl GetBattleNaviStatsByte
	mov r1, r0
	pop {r0}
	cmp r1, #0
	beq loc_802A498
	ldrb r2, [r6,#oBattleState_Unk_07]
	cmp r2, r1
	blt loc_802A498
	sub r2, r2, r1
	add r2, #1
	sub r7, r7, r2
	bpl loc_802A498
	add r0, r0, r7
	cmp r0, #2
	bge loc_802A498
	mov r0, #2
loc_802A498:
	strb r0, [r5,#6]
	pop {r4,r6,r7,pc}
	thumb_func_end battle_updateBeastOutCounter_802A40C

// symdb: Per-frame tick that increments a beast-out counter (clamped to 3) when the current battle emotion reads 5 or 0x11 under non-boss battle modes, and resets it otherwise.
// symdb: void tickBeastOutCounter_802A49C(void); // inputs:  r5 (battle entity object), r10 (toolkit/BTL
// symdb: state wrapper), r4/r6 preserved // outputs: r1 = dword_20349A0 (address of the counter struct,
// symdb: left in r1 for caller) // clobbers: r0, r2, r3, lr, flags N/Z/C/V
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/tickBeastOutCounter_802A49C.yaml
	thumb_local_start
tickBeastOutCounter_802A49C:
	push {lr}
	bl GetBattleMode
	cmp r0, #2
	beq loc_802A4F0
	cmp r0, #3
	beq loc_802A4F0
	cmp r0, #4
	beq loc_802A4F0
	cmp r0, #5
	beq loc_802A4F0
	cmp r0, #8
	beq loc_802A4F0
	ldrb r0, [r5,#0x10]
	cmp r0, #0
	bne loc_802A4F0
	ldrb r1, [r5,#0x15]
	cmp r0, r1
	bne loc_802A4CE
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	b loc_802A4D8
loc_802A4CE:
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	bl sub_8015B5C
loc_802A4D8:
	cmp r1, #5
	beq loc_802A4E0
	cmp r1, #0x11
	bne loc_802A4F0
loc_802A4E0:
	ldr r1, off_802A4F8 // =dword_20349A0 
	ldrb r0, [r1,#0x11] // (byte_20349B1 - 0x20349a0)
	add r0, #1
	cmp r0, #3
	ble loc_802A4EC
	mov r0, #3
loc_802A4EC:
	strb r0, [r1,#0x11] // (byte_20349B1 - 0x20349a0)
	b locret_802A4F6
loc_802A4F0:
	ldr r1, off_802A4F8 // =dword_20349A0 
	mov r0, #0
	strb r0, [r1,#0x11] // (byte_20349B1 - 0x20349a0)
locret_802A4F6:
	pop {pc}
	.balign 4, 0
off_802A4F8:
	.word dword_20349A0
	thumb_func_end tickBeastOutCounter_802A49C

// symdb: Counts the chips in the currently loaded folder by class (standard/mega/giga) into a per-class tally array.
// symdb: void sub_802A4FC(void); /* preserves r4/r6/r7; sets NZ and clears C/V on all exits via the final
// symdb: CMP */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/folder_tallyChipsByClass_802A4FC.yaml
	thumb_local_start
folder_tallyChipsByClass_802A4FC:
	push {r4,r6,r7,lr}
	ldr r0, off_802A534 // =byte_20366C0 
	ldrb r0, [r0]
	cmp r0, #0xff
	beq locret_802A532
	ldr r4, off_802A534 // =byte_20366C0 
	mov r0, #0x32 
	add r4, r4, r0
	mov r6, #0xff
	lsl r6, r6, #8
	add r6, #0xff
	ldr r7, off_802A538 // =dword_20367E0 
loc_802A514:
	ldrh r0, [r4]
	cmp r0, r6
	beq locret_802A532
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrb r0, [r0,#7]
	cmp r0, #2
	bgt loc_802A52E
	ldrb r1, [r7,r0]
	add r1, #1
	strb r1, [r7,r0]
loc_802A52E:
	add r4, #2
	b loc_802A514
locret_802A532:
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_802A534:
	.word byte_20366C0
off_802A538:
	.word dword_20367E0
	thumb_func_end folder_tallyChipsByClass_802A4FC

	thumb_local_start
sub_802A53C:
	push {r1-r7,lr}
	mov r4, r0
	bl sub_800AFBA
	bne loc_802A54A
	mov r0, r4
	pop {r1-r7,pc}
loc_802A54A:
	ldr r0, dword_802A560 // =0x3785 
	pop {r1-r7,pc}
	thumb_func_end sub_802A53C

// (int a1) -> int
	thumb_local_start
getChipID_802A54E:
	push {r1-r7,lr}
	mov r4, r0
	bl tooManyGigasMegasAntiCheatHappensHere_800B022 // (int a1) ->
	bne loc_802A55C
	mov r0, r4
	pop {r1-r7,pc}
loc_802A55C:
	ldr r0, dword_802A560 // =0x3785 
	pop {r1-r7,pc}
	.balign 4, 0
dword_802A560:
	.word 0x3785
	thumb_func_end getChipID_802A54E

// symdb: Fetches the current battle emotion/mood state for a battle actor, dispatching between the normal emotion lookup and an alternate path based on a flag on the actor.
// symdb: (r10=toolkit, r5=battle object, r4/r6 unused) -> (r0=emotion enum8?, r1=transformation, r2=mood,
// symdb: r3=beast_out_counter)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getActorEmotion_802A564.yaml
	thumb_local_start
battle_getActorEmotion_802A564:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	ldrb r1, [r5,#0x15]
	cmp r1, #0
	bne loc_802A578
	bl callPossiblyGetBattleEmotion_8015B54 // (alliance: u8) -> (res0: enum8?, transformation: u8, mood: u8, beast_out_counter: u8)
	b locret_802A57C
loc_802A578:
	bl sub_8015B5C
locret_802A57C:
	pop {pc}
	thumb_func_end battle_getActorEmotion_802A564

	thumb_local_start
sub_802A57E:
	push {r4,lr}
	mov r4, #0
	bl battle_getActorEmotion_802A564
	cmp r0, #5
	beq loc_802A59C
	cmp r0, #1
	bne loc_802A596
	ldr r0, off_802A740 // =dword_20349A0 
	ldrb r0, [r0,#0x10] // (byte_20349B0 - 0x20349a0)
	tst r0, r0
	beq loc_802A59C
loc_802A596:
	cmp r1, #0xb
	bge loc_802A59C
	mov r4, #1
loc_802A59C:
	mov r0, r4
	pop {r4,pc}
	thumb_func_end sub_802A57E

// symdb: Returns 1 when the beast transformation (Beast Over) is active for this battle, 0 otherwise.
// symdb: bool battle_isBeastOverEnabled_802A5A0(/* r10 */ Toolkit *toolkit); -> r0 = 1/0; r4, r6
// symdb: preserved; flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_isBeastOverEnabled_802A5A0.yaml
	thumb_local_start
battle_isBeastOverEnabled_802A5A0:
	push {r4,lr}
	mov r4, #0
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r1, [r0]
	cmp r1, #8
	beq loc_802A5D6
	bl GetBattleMode
	cmp r0, #1
	beq loc_802A5D6
	cmp r0, #6
	beq loc_802A5D6
	cmp r0, #7
	beq loc_802A5D6
	cmp r0, #9
	beq loc_802A5D6
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	mov r1, #0x61 
	bl GetBattleNaviStatsByte
	cmp r0, #1
	bne loc_802A5D6
	mov r4, #1
loc_802A5D6:
	mov r0, r4
	pop {r4,pc}
	thumb_func_end battle_isBeastOverEnabled_802A5A0

// symdb: Returns 1 when active chip slot 8 holds a chip, the battle is a regular mode, and the current navi's stats-table byte 0x60 reads 1.
// symdb: bool sub_802A5DA(void); // inputs: r10 = Toolkit*, r4/r6 passed through and preserved; returns
// symdb: r0 = 0 or 1; clobbers r1, flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_checkActiveSlot8NaviStatReady_802A5DA.yaml
	thumb_local_start
battle_checkActiveSlot8NaviStatReady_802A5DA:
	push {r4,lr}
	mov r4, #0
	mov r0, #8
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r1, [r0]
	cmp r1, #8
	beq loc_802A616
	bl GetBattleMode
	cmp r0, #0
	beq loc_802A604
	cmp r0, #5
	beq loc_802A604
	cmp r0, #8
	beq loc_802A604
	cmp r0, #0xa
	beq loc_802A604
	cmp r0, #0xb
	beq loc_802A604
	b loc_802A616
loc_802A604:
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	mov r1, #0x60 
	bl GetBattleNaviStatsByte
	cmp r0, #1
	bne loc_802A616
	mov r4, #1
loc_802A616:
	mov r0, r4
	pop {r4,pc}
	thumb_func_end battle_checkActiveSlot8NaviStatReady_802A5DA

	thumb_local_start
sub_802A61A:
	push {r4,r6,lr}
	mov r4, #0
	bl battle_countFolderChips_8027D58
	ldrb r1, [r5,#6]
	cmp r0, r1
	bge loc_802A62C
	mov r6, r0
	b loc_802A62E
loc_802A62C:
	mov r6, r1
loc_802A62E:
	mov r0, r4
	bl getLocOfActiveChips_8027E1C // (int a1) -> void*
	ldrb r1, [r0,#7]
	cmp r1, #2
	bne loc_802A63E
	mov r1, #0
	strb r1, [r0,#7]
loc_802A63E:
	add r4, #1
	cmp r4, r6
	blt loc_802A62E
	pop {r4,r6,pc}
	thumb_func_end sub_802A61A

// symdb: Clears a battle-state flag at state+0x44 once the state's counter at state+0x45 reaches/exceeds a threshold read from the source object at r5+6.
// symdb: void Next(uint32_t source /* r5 */, void /* r10 -> oToolkit_BattleStatePtr */);   /* trashes r0,
// symdb: r1, r3 and N/Z/C/V flags; preserves nothing */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/expireBattleFlag_802A646.yaml
	thumb_local_start
expireBattleFlag_802A646:
	push {lr}
	mov r3, r10
	ldr r3, [r3,#oToolkit_BattleStatePtr]
	mov r0, #0x44 
	ldrb r0, [r3,r0]
	tst r0, r0
	beq locret_802A664
	mov r0, #0x45 
	ldrb r0, [r3,r0]
	ldrb r1, [r5,#6]
	cmp r0, r1
	bge locret_802A664
	mov r0, #0x44 
	mov r1, #0
	strb r1, [r3,r0]
locret_802A664:
	pop {pc}
	.balign 4, 0x00
	thumb_func_end expireBattleFlag_802A646

off_802A668::
	.word eS20364C0
	.word unk_2035000
	.word unk_20365C0
	.word eBattleFolder
	.byte 0xFF, 0x1, 0x0, 0x0, 0x20, 0x9C, 0x0, 0x6
byte_802A680:
	.byte 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77
	.byte 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77
	.byte 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77
	.byte 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77
	.byte 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77
	.byte 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77
	.byte 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77, 0x77
	.byte 0x77
byte_802A6C0:
	.byte 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88
	.byte 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88
	.byte 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88
	.byte 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88
	.byte 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88
	.byte 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88
	.byte 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88, 0x88
	.byte 0x88
byte_802A700:
	.byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11
	.byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11
	.byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11
	.byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11
	.byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11
	.byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11
	.byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11
	.byte 0x11
off_802A740:
	.word dword_20349A0
off_802A744:
	.word dword_86E55BC
	.word 0x6016C80
	.word 0x40
	.word dword_86E55FC
	.word 0x6016F40
	.word 0x100
	.word byte_86E587C
	.word 0x3001A80
	.word 0x20
	.word dword_86E57FC
	.word 0x6017240
	.word 0x80
	.word dword_86B7AE0
	.word 0x6017040
	.word 0x40
	.word dword_86B7AE0
	.word 0x6017080
	.word 0x40
	.word dword_86B7AE0
	.word 0x60170C0
	.word 0x20
	.word dword_86B7AE0
	.word 0x6017120
	.word 0x40
	.word dword_86B7AE0
	.word 0x60171A0
	.word 0x40
	.word dword_86B7AE0
	.word 0x60171E0
	.word 0x40
	.word dword_86B7AE0
	.word 0x6017220
	.word 0x20
	.word 0x0

/// Seems to feed into the first word of most entries in unk_20365C0
/// [u32; 12]
dword_802A7CC:
	.word 0x10A050A
	.word 0x200060A
	.word 0x301070A
	.word 0x402080A
	.word 0xA03090A
	.word 0x60B000A
	.word 0x705010A
	.word 0x806020A
	.word 0x907030B
	.word 0xB08040B
	.word 0x40B01
	.word 0x5090A0B
  
off_802A7FC:
	.word EnterMap_RealWorldMapGroupJumptable
	.word 0xA000102
byte_802A804:
	.byte 0x9, 0x8, 0x7, 0x6, 0x5, 0xB, 0xA, 0x7, 0x6, 0x5, 0x2, 0x1, 0x0, 0xB, 0xA
	.byte 0x6, 0x5, 0xB, 0xA
byte_802A817:
	.byte 0x0
	.word 0x08030201
	.byte 0x4, 0x9, 0xA
byte_802A81F:
	.byte 0x5, 0x6, 0x7, 0x8, 0x9, 0xB, 0xA, 0x0, 0x0
byte_802A828:
	.byte 0x90, 0xF, 0x91, 0x9, 0x92, 0x25, 0x93, 0x15, 0x94, 0x5
	.byte 0x95, 0x1, 0x96, 0x27, 0x97, 0x27, 0x98, 0xD, 0x99, 0x7
	.byte 0x9A, 0x3, 0x0, 0x0
byte_802A840:
	.byte 0x6C, 0xB3, 0x68, 0xB3, 0x64, 0xB3, 0xFF, 0xFF
byte_802A848:
	.byte 0x73, 0xB3, 0x73, 0xB3, 0x73, 0xB3, 0x73, 0xB3, 0x73
	.byte 0xB3, 0x73, 0xB3, 0x72, 0xB3, 0x72, 0xB3, 0x72, 0xB3
	.byte 0x72, 0xB3, 0x72, 0xB3, 0x72, 0xB3, 0x0, 0x0
dword_802A862:
	.word 0xB374

	thumb_func_start sub_802A866
sub_802A866:
	push {lr}
	bl sub_802B298
	// size
	mov r1, #0x40 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	bl sub_802B298
	mov r1, #1
	strb r1, [r0,#7]
	pop {pc}
	thumb_func_end sub_802A866

	thumb_func_start sub_802A87C
sub_802A87C:
	push {r5,lr}
	bl sub_802B298
	mov r5, r0
	ldr r1, off_802A894 // =off_802A898 
	ldrb r0, [r5]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	ldrb r0, [r5,#4]
	pop {r5,pc}
	.balign 4, 0
off_802A894:
	.word off_802A898
off_802A898:
	.word sub_802A8A4+1
	.word sub_802A974+1
	.word sub_802A934+1
	thumb_func_end sub_802A87C

	thumb_local_start
sub_802A8A4:
	push {lr}
	movflag EVENT_197
	bl SetEventFlagFromImmediate
	movflag EVENT_1AD
	bl SetEventFlagFromImmediate
	bl decomp_802B060
	ldr r0, off_802A918 // =unk_2035000 
	ldr r1, dword_802A91C // =0x9070 
	ldr r2, dword_802A920 // =0x6008e00 
	bl sub_802B4D4
	ldr r0, off_802A918 // =unk_2035000 
	ldr r1, dword_802A924 // =0x90d4 
	ldr r2, dword_802A928 // =0x6009a80 
	bl sub_802B51C
	ldr r0, off_802A914 // =unk_2031000 
	bl sub_802B2A0
	strh r0, [r5,#0x1e]
	mov r0, #0
	ldr r1, off_802A90C // =dword_8129180 
	bl sub_8120CC8
	strb r0, [r5,#0xc]
	strb r1, [r5,#0xd]
	mov r0, #0
	strb r0, [r5,#0xf]
	strb r0, [r5,#0x12]
	mvn r0, r0
	strb r0, [r5,#0x10]
	strb r0, [r5,#0x11]
	ldr r0, off_802A914 // =unk_2031000 
	ldr r1, off_802A92C // =decomp_2032000 
	bl sub_802B358
	ldr r0, off_802A930 // =unk_2030E60 
	ldr r1, off_802A914 // =unk_2031000 
	bl sub_802B438
	mov r0, #4
	str r0, [r5]
	ldr r0, dword_802A910 // =0x20000 
	bl dispatch_801DACC // (a0: flags32) -> ()
	pop {pc}
	.balign 4, 0
off_802A90C:
	.word dword_8129180
dword_802A910:
	.word 0x20000
off_802A914:
	.word unk_2031000
off_802A918:
	.word unk_2035000
dword_802A91C:
	.word 0x9070
dword_802A920:
	.word 0x6008E00
dword_802A924:
	.word 0x90D4
dword_802A928:
	.word 0x6009A80
off_802A92C:
	.word decomp_2032000
off_802A930:
	.word unk_2030E60
	thumb_func_end sub_802A8A4

	thumb_local_start
sub_802A934:
	push {lr}
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r2, [r1,#oBattleState_Unk_04]
	strb r2, [r1,#oBattleState_Unk_12]
	mov r0, #0x80
	add r0, r0, r1
	add r1, #0xd0
	lsl r2, r2, #2
	beq loc_802A966
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	ldr r0, dword_802A96C // =0x820080 
	bl dispatch_801DA48
	ldr r0, dword_802A96C // =0x820080 
	bl eStruct2035280_SetRequestBits_801BECC
	ldr r0, dword_802A970 // =0x4 
	bl dispatch_801DACC // (a0: flags32) -> ()
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	mov r0, #0
	strh r0, [r1,#oRenderInfo_Unk_18]
loc_802A966:
	mov r0, #1
	strb r0, [r5,#4]
	pop {pc}
	.balign 4, 0
dword_802A96C:
	.word 0x820080
dword_802A970:
	.word 0x4
	thumb_func_end sub_802A934

	thumb_local_start
sub_802A974:
	push {r5,lr}
	ldr r1, off_802A984 // =off_802A988 
	ldrb r0, [r5,#1]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r5,pc}
	.balign 4, 0x00
off_802A984:
	.word off_802A988
off_802A988:
	.word sub_802A9B4+1
	.word sub_802A9D0+1
	.word sub_802ABD0+1
	.word sub_802ABF4+1
	.word sub_802AD84+1
	.word sub_802AE14+1
	.word sub_802AE5C+1
	.word sub_802AE84+1
	.word sub_802AEB8+1
	.word sub_802AED8+1
	.word sub_802ADFC+1
	thumb_func_end sub_802A974

	thumb_local_start
sub_802A9B4:
	push {lr}
	bl sub_802AF6C
	bne locret_802A9CC
	mov r0, #4
	strb r0, [r5,#1]
	mov r1, #0
	ldrb r0, [r5,#0x10]
	cmp r0, #0xff
	beq loc_802A9CA
	mov r1, #1
loc_802A9CA:
	strb r1, [r5,#2]
locret_802A9CC:
	pop {pc}
	.byte 0, 0
	thumb_func_end sub_802A9B4

	thumb_local_start
sub_802A9D0:
	push {r4-r7,lr}
	ldrh r0, [r5,#0x24]
	strh r0, [r5,#0x26]
	ldrh r0, [r5,#0x20]
	strh r0, [r5,#0x22]
	ldrb r0, [r5,#2]
	tst r0, r0
	beq loc_802AA7C
	bl sub_802B0EC
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	mov r1, #1
	tst r0, r1
	beq loc_802AA0E
	ldrb r0, [r5,#0x10]
	cmp r0, #0xff
	bne loc_802A9FE
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	b loc_802AB98
loc_802A9FE:
	mov r0, #SOUND_SELECT_82
	bl PlaySoundEffect
	mov r0, #8
	strb r0, [r5,#1]
	mov r0, #0
	strb r0, [r5,#2]
	b loc_802AA54
loc_802AA0E:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	mov r1, #2
	tst r0, r1
	beq loc_802AA54
	ldrb r0, [r5,#0x11]
	cmp r0, #0xff
	beq loc_802AA2A
	bl sub_802B5B0
	mov r0, #0xff
	strb r0, [r5,#0x11]
	b loc_802AA38
loc_802AA2A:
	ldrb r0, [r5,#0x10]
	cmp r0, #0xff
	beq loc_802AA38
	bl sub_802B5B0
	mov r0, #0xff
	strb r0, [r5,#0x10]
loc_802AA38:
	mov r0, #0
	strb r0, [r5,#2]
	ldr r0, off_802ABB4 // =unk_2031000 
	ldr r1, off_802ABB8 // =decomp_2032000 
	bl sub_802B358
	ldr r0, off_802ABCC // =unk_2030E60 
	ldr r1, off_802ABB4 // =unk_2031000 
	bl sub_802B438
	mov r0, #SOUND_EXIT_SUBMENU
	bl PlaySoundEffect
	b loc_802AB98
loc_802AA54:
	ldrb r0, [r5,#0x10]
	cmp r0, #0xff
	beq loc_802AA62
	ldrb r0, [r5,#0x11]
	cmp r0, #0xff
	beq loc_802AA62
	b loc_802AB98
loc_802AA62:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	mov r1, #0x20 
	tst r0, r1
	bne loc_802AA70
	b loc_802AB98
loc_802AA70:
	mov r0, #0
	strb r0, [r5,#2]
	mov r0, #SOUND_MENU_CUR_MOVE
	bl PlaySoundEffect
	b loc_802AB98
loc_802AA7C:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	ldr r1, off_802ABC8 // =0x200 
	tst r0, r1
	beq loc_802AA9A
	mov r0, #0x1c
	strb r0, [r5,#1]
	mov r0, #0
	bl RunTextScriptBattleRunDialog
	mov r0, #SOUND_UNSELECT_7B
	bl PlaySoundEffect
	b loc_802AB98
loc_802AA9A:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	ldr r1, off_802ABC4 // =0x100 
	tst r0, r1
	beq loc_802AAC8
	ldrh r0, [r5,#0x24]
	ldrh r1, [r5,#0x20]
	add r0, r0, r1
	lsl r0, r0, #1
	ldr r1, off_802ABB4 // =unk_2031000 
	ldrh r0, [r1,r0]
	ldr r1, dword_802ABBC // =0xffff 
	cmp r0, r1
	beq loc_802AB98
	bl sub_802B5DC
	mov r0, #0x18
	strb r0, [r5,#1]
	mov r0, #0x9c
	bl PlaySoundEffect
	b loc_802AB98
loc_802AAC8:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	mov r1, #0x10
	tst r0, r1
	beq loc_802AAE0
	mov r0, #4
	strb r0, [r5,#2]
	mov r0, #SOUND_MENU_CUR_MOVE
	bl PlaySoundEffect
	b loc_802AB98
loc_802AAE0:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	mov r1, #5
	mov r2, #0
	mov r3, #0
	bl sub_811F7F8
	tst r0, r0
	beq loc_802AB20
	ldrh r0, [r5,#0x24]
	ldrh r1, [r5,#0x26]
	cmp r0, r1
	bne loc_802AB0E
	ldrh r0, [r5,#0x20]
	ldrh r1, [r5,#0x22]
	cmp r0, r1
	beq loc_802AB98
	ldr r0, off_802ABCC // =unk_2030E60 
	ldr r1, off_802ABB4 // =unk_2031000 
	bl sub_802B438
	b loc_802AB98
loc_802AB0E:
	ldr r0, off_802ABB4 // =unk_2031000 
	ldr r1, off_802ABB8 // =decomp_2032000 
	bl sub_802B358
	ldr r0, off_802ABCC // =unk_2030E60 
	ldr r1, off_802ABB4 // =unk_2031000 
	bl sub_802B438
	b loc_802AB98
loc_802AB20:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	mov r1, #1
	tst r0, r1
	beq loc_802AB94
	mov r3, #0x10
	ldrb r0, [r5,#0x10]
	cmp r0, #0xff
	beq loc_802AB36
	mov r3, #0x11
loc_802AB36:
	ldrh r0, [r5,#0x24]
	ldrh r1, [r5,#0x20]
	add r0, r0, r1
	ldr r7, off_802ABB4 // =unk_2031000 
	lsl r4, r0, #1
	ldrh r6, [r7,r4]
	ldr r2, dword_802ABBC // =0xffff 
	cmp r6, r2
	beq loc_802AB64
	ldr r7, off_802ABC0 // =byte_802B5FC
	lsl r4, r6, #3
	add r4, #4
	ldrh r6, [r7,r4]
	ldrh r4, [r5,#0x12]
	add r4, r4, r6
	cmp r4, #0x32 
	bgt loc_802AB64
	ldrb r1, [r5,#0x10]
	cmp r0, r1
	beq loc_802AB64
	ldrb r1, [r5,#0x11]
	cmp r0, r1
	bne loc_802AB6C
loc_802AB64:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	b loc_802AB98
loc_802AB6C:
	strb r0, [r5,r3]
	ldrb r0, [r5,#0x12]
	add r0, r0, r6
	strb r0, [r5,#0x12]
	cmp r3, #0x11
	bne loc_802AB7C
	mov r0, #4
	strb r0, [r5,#2]
loc_802AB7C:
	ldr r0, off_802ABB4 // =unk_2031000 
	ldr r1, off_802ABB8 // =decomp_2032000 
	bl sub_802B358
	ldr r0, off_802ABCC // =unk_2030E60 
	ldr r1, off_802ABB4 // =unk_2031000 
	bl sub_802B438
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	b loc_802AB98
loc_802AB94:
	bl sub_802B560
loc_802AB98:
	mov r0, #0x10
	bl sub_802B15C
	mov r0, #0x11
	bl sub_802B15C
	ldrb r0, [r5,#2]
	tst r0, r0
	bne loc_802ABAE
	bl sub_802B1E4
loc_802ABAE:
	bl sub_802B270
	pop {r4-r7,pc}
	.balign 4, 0
off_802ABB4:
	.word unk_2031000
off_802ABB8:
	.word decomp_2032000
dword_802ABBC:
	.word 0xFFFF
off_802ABC0:
	.word byte_802B5FC
off_802ABC4:
	.word 0x100
off_802ABC8:
	.word 0x200
off_802ABCC:
	.word unk_2030E60
	thumb_func_end sub_802A9D0

	thumb_local_start
sub_802ABD0:
	push {lr}
	bl sub_802AFD4
	bne locret_802ABEC
	mov r0, #0xc
	strb r0, [r5,#1]
	mov r0, #0
	strb r0, [r5,#2]
	strb r0, [r5,#3]
	ldrb r0, [r5,#0x10]
	lsl r0, r0, #1
	ldr r1, off_802ABF0 // =unk_2031000 
	ldrh r0, [r1,r0]
	strb r0, [r5,#7]
locret_802ABEC:
	pop {pc}
	.balign 4, 0
off_802ABF0:
	.word unk_2031000
	thumb_func_end sub_802ABD0

	thumb_local_start
sub_802ABF4:
	push {lr}
	ldr r1, off_802AC04 // =off_802AC08 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
off_802AC04:
	.word off_802AC08
off_802AC08:
	.word sub_802AC10+1
	.word sub_802AC6E+1
	thumb_func_end sub_802ABF4

	thumb_local_start
sub_802AC10:
	push {lr}
	ldrb r0, [r5,#3]
	cmp r0, #0
	bne loc_802AC4E
	mov r0, #1
	strb r0, [r5,#3]
	ldrb r0, [r5,#5]
	cmp r0, #2
	blt loc_802AC2C
	mov r0, #0
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b locret_802AC6C
loc_802AC2C:
	ldrb r0, [r5,#7]
	sub r0, #1
	mov r1, #6
	mul r0, r1
	add r0, #1
	bl sub_802AEEA
	ldrb r2, [r5,#5]
	lsl r2, r2, #2
	add r2, #0x30 
	str r0, [r5,r2]
	ldrb r2, [r5,#5]
	add r2, #0xa
	strb r1, [r5,r2]
	mov r0, #2
	strb r0, [r5,#8]
	strb r0, [r5,#9]
loc_802AC4E:
	bl sub_802AF38
	ldrb r1, [r0,#9]
	cmp r1, #1
	bne locret_802AC6C
	mov r1, #0
	strh r1, [r0,#0x12]
	bl sub_802AF28
	mov r0, #0x28 
	strb r0, [r5,#1]
	mov r0, #4
	strh r0, [r5,#2]
	mov r0, #8
	str r0, [r5,#0x3c]
locret_802AC6C:
	pop {pc}
	thumb_func_end sub_802AC10

	thumb_local_start
sub_802AC6E:
	push {lr}
	mov r3, r10
	ldr r3, [r3,#oToolkit_JoypadPtr]
	ldrh r0, [r3,#oJoypad_LowSensitivityHeld]
	mov r1, #0x40 
	tst r0, r1
	beq loc_802AC8C
	ldrb r1, [r5,#9]
	cmp r1, #1
	ble loc_802AC8C
	sub r1, #1
	strb r1, [r5,#9]
	bl sub_802B5D0
	b loc_802AD48
loc_802AC8C:
	mov r1, #0x80
	tst r0, r1
	beq loc_802ACA2
	ldrb r1, [r5,#9]
	cmp r1, #3
	bge loc_802ACA2
	add r1, #1
	strb r1, [r5,#9]
	bl sub_802B5D0
	b loc_802AD48
loc_802ACA2:
	mov r1, #0x20 
	tst r0, r1
	beq loc_802ACB8
	ldrb r1, [r5,#8]
	cmp r1, #1
	ble loc_802ACB8
	sub r1, #1
	strb r1, [r5,#8]
	bl sub_802B5D0
	b loc_802AD48
loc_802ACB8:
	mov r1, #0x10
	tst r0, r1
	beq loc_802ACCE
	ldrb r1, [r5,#8]
	cmp r1, #3
	bge loc_802ACCE
	add r1, #1
	strb r1, [r5,#8]
	bl sub_802B5D0
	b loc_802AD48
loc_802ACCE:
	mov r1, #1
	tst r0, r1
	beq loc_802AD34
	ldrb r0, [r5,#8]
	ldrb r1, [r5,#9]
	bl object_getPanelParameters
	ldr r1, dword_802AD6C // =0xf800000 
	tst r0, r1
	bne loc_802ACEA
	ldr r1, dword_802AD70 // =0x10 
	and r0, r1
	cmp r0, r1
	beq loc_802ACF2
loc_802ACEA:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	b loc_802AD48
loc_802ACF2:
	bl sub_802AF38
	bl sub_802AF28
	mov r0, #SOUND_SELECT_67
	bl PlaySoundEffect
	ldrb r0, [r5,#5]
	add r0, #1
	strb r0, [r5,#5]
	cmp r0, #2
	blt loc_802AD1C
loc_802AD0A:
	ldr r0, off_802AD78 // =TextScript8736D74
	mov r1, #0x28 
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	mov r0, #0x14
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b loc_802AD48
loc_802AD1C:
	ldrb r0, [r5,#0x11]
	cmp r0, #0xff
	beq loc_802AD0A
	lsl r0, r0, #1
	ldr r1, off_802AD74 // =unk_2031000 
	ldrh r0, [r1,r0]
	strb r0, [r5,#7]
	mov r0, #0xc
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b loc_802AD48
loc_802AD34:
	mov r1, #2
	tst r0, r1
	beq loc_802AD48
	mov r0, #SOUND_UNSELECT_68
	bl PlaySoundEffect
	mov r0, #0x10
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
loc_802AD48:
	ldr r0, dword_802AD80 // =0x2a0000 
	push {r0}
	mov r0, sp
	ldrb r1, [r5,#8]
	mov r2, #5
	mul r1, r2
	sub r1, #3
	strb r1, [r0]
	ldrb r1, [r5,#9]
	mov r2, #3
	mul r1, r2
	add r1, #7
	strb r1, [r0,#1]
	pop {r0}
	bl sub_802AF0E
	pop {pc}
	.balign 4, 0
dword_802AD6C:
	.word 0xF800000
dword_802AD70:
	.word 0x10
off_802AD74:
	.word unk_2031000
off_802AD78:
	.word TextScript8736D74
	.word 0x0
dword_802AD80:
	.word 0x2A0000
	thumb_func_end sub_802AC6E

	thumb_local_start
sub_802AD84:
	push {lr}
	ldrb r0, [r5,#3]
	cmp r0, #0
	bne loc_802ADB0
	mov r0, #1
	strb r0, [r5,#3]
	bl sub_802AF38
	mov r5, r0
	ldr r2, [r0,#0x58]
	mov r1, #1
	strb r1, [r2,#2]
	bl sub_800EC3C
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r0, [r1,#oBattleState_Unk_08]
	sub r0, #1
	strb r0, [r1,#oBattleState_Unk_08]
	ldrb r0, [r1,#oBattleState_Unk_04]
	sub r0, #1
	strb r0, [r1,#oBattleState_Unk_04]
loc_802ADB0:
	bl sub_802AF38
	ldrb r1, [r0]
	cmp r1, #0
	bne locret_802ADF8
	ldrb r0, [r5,#5]
	add r0, #0xa
	ldrb r0, [r5,r0]
	cmp r0, #0
	beq loc_802ADC8
	bl sub_8002ADE
loc_802ADC8:
	ldrb r0, [r5,#5]
	tst r0, r0
	bne loc_802ADD8
	mov r0, #0
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b locret_802ADF8
loc_802ADD8:
	sub r0, #1
	strb r0, [r5,#5]
	bl sub_802AF38
	ldrb r1, [r0,#0x12]
	strb r1, [r5,#8]
	ldrb r1, [r0,#0x13]
	strb r1, [r5,#9]
	mov r1, #0
	strh r1, [r0,#0x12]
	bl sub_802AF28
	mov r0, #0x28 
	strb r0, [r5,#1]
	mov r0, #8
	str r0, [r5,#0x3c]
locret_802ADF8:
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_802AD84

	thumb_local_start
sub_802ADFC:
	push {lr}
	ldr r0, [r5,#0x3c]
	sub r0, #1
	str r0, [r5,#0x3c]
	bne locret_802AE12
	mov r0, #0xc
	strb r0, [r5,#1]
	mov r0, #4
	strh r0, [r5,#2]
	bl sub_802AF0E
locret_802AE12:
	pop {pc}
	thumb_func_end sub_802ADFC

	thumb_local_start
sub_802AE14:
	push {lr}
	mov r0, #0x20 
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	beq locret_802AE5A
	bl chatbox_GetState_8045F4C
	tst r0, r0
	beq loc_802AE52
	mov r0, #0x10
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	ldrb r0, [r5,#5]
	sub r0, #1
	strb r0, [r5,#5]
	bl sub_802AF38
	ldrb r1, [r0,#0x12]
	strb r1, [r5,#8]
	ldrb r1, [r0,#0x13]
	strb r1, [r5,#9]
	mov r1, #0
	strh r1, [r0,#0x12]
	bl sub_802AF28
	mov r0, #0xc
	strb r0, [r5,#1]
	mov r0, #4
	strh r0, [r5,#2]
	b loc_802AE56
loc_802AE52:
	mov r0, #8
	str r0, [r5]
loc_802AE56:
	bl chatbox_8040818
locret_802AE5A:
	pop {pc}
	thumb_func_end sub_802AE14

	thumb_local_start
sub_802AE5C:
	push {lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_802AE70
	mov r0, #0x9e
	bl PlaySoundEffect
	mov r0, #4
	strb r0, [r5,#1]
loc_802AE70:
	mov r0, #0x10
	bl sub_802B15C
	mov r0, #0x11
	bl sub_802B15C
	bl sub_802B270
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_802AE5C

	thumb_local_start
sub_802AE84:
	push {lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_802AEA6
	bl chatbox_GetState_8045F4C
	tst r0, r0
	beq loc_802AE9C
	mov r0, #4
	strb r0, [r5,#1]
	b loc_802AEA6
loc_802AE9C:
	mov r0, #1
	bl RunTextScriptBattleRunDialog
	mov r0, #0x20 
	strb r0, [r5,#1]
loc_802AEA6:
	mov r0, #0x10
	bl sub_802B15C
	mov r0, #0x11
	bl sub_802B15C
	bl sub_802B270
	pop {pc}
	thumb_func_end sub_802AE84

	thumb_local_start
sub_802AEB8:
	push {lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_802AEC6
	mov r0, #0x24 
	strb r0, [r5,#1]
loc_802AEC6:
	mov r0, #0x10
	bl sub_802B15C
	mov r0, #0x11
	bl sub_802B15C
	bl sub_802B270
	pop {pc}
	thumb_func_end sub_802AEB8

	thumb_local_start
sub_802AED8:
	push {lr}
	bl sub_802AFD4
	bne locret_802AEE8
	bl battle_stateGotoPhase14_800AABC
	mov r0, #8
	strb r0, [r5]
locret_802AEE8:
	pop {pc}
	thumb_func_end sub_802AED8

	thumb_local_start
sub_802AEEA:
	push {r5-r7,lr}
	mov r6, r0
	bl enemy_getStruct1
	ldrb r1, [r0,#1]
	ldrb r0, [r0]
	bl sprite_decompress
	mov r7, r0
	mov r0, r6
	mov r1, #2
	mov r2, #2
	mov r3, #0
	mov r5, #0
	bl sub_80076A0
	mov r1, r7
	pop {r5-r7,pc}
	thumb_func_end sub_802AEEA

	thumb_local_start
sub_802AF0E:
	push {r5,lr}
	bl sub_802AF38
	ldrb r1, [r5,#8]
	strb r1, [r0,#0x12]
	strb r1, [r0,#0x14]
	ldrb r1, [r5,#9]
	strb r1, [r0,#0x13]
	strb r1, [r0,#0x15]
	mov r5, r0
	bl object_setCoordinatesFromPanels // () -> void
	pop {r5,pc}
	thumb_func_end sub_802AF0E

	thumb_local_start
sub_802AF28:
	push {r5,lr}
	mov r5, r0
	ldr r0, dword_802AF34 // =0x80000 
	bl object_setFlag2
	pop {r5,pc}
	.balign 4, 0
dword_802AF34:
	.word 0x80000
	thumb_func_end sub_802AF28

	thumb_local_start
sub_802AF38:
	ldrb r0, [r5,#5]
	lsl r0, r0, #2
	add r0, #0x30 
	ldr r0, [r5,r0]
	mov pc, lr
	thumb_func_end sub_802AF38

	thumb_local_start
sub_802AF42:
	push {r5,lr}
	ldrb r0, [r5,#5]
	sub r0, #1
	strb r0, [r5,#5]
	bl sub_802AF38
	mov r5, r0
	ldr r2, [r0,#0x58]
	mov r1, #1
	strb r1, [r2,#2]
	bl sub_800EC3C
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r0, [r1,#8]
	sub r0, #1
	strb r0, [r1,#8]
	ldrb r0, [r1,#4]
	sub r0, #1
	strb r0, [r1,#4]
	pop {r5,pc}
	thumb_func_end sub_802AF42

	thumb_local_start
sub_802AF6C:
	push {r4-r7,lr}
	ldrb r0, [r5,#2]
	tst r0, r0
	bne loc_802AF8C
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	mov r0, #0x78 
	strh r0, [r1,#oRenderInfo_Unk_18]
	mov r0, #SOUND_SELECT_79
	bl PlaySoundEffect
	mov r0, #0xf
	str r0, [r5,#0x3c]
	mov r0, #0x78 
	str r0, [r5,#0x38]
	strb r0, [r5,#2]
loc_802AF8C:
	ldr r0, [r5,#0x38]
	sub r0, #0xc
	push {r0,r4,r6,r7}
	mov r6, #4
	and r6, r0
	lsr r6, r6, #2
	add r6, #1
loc_802AF9A:
	ldr r0, [r5,#0x3c]
	sub r0, #1
	str r0, [r5,#0x3c]
	ldr r4, off_802B08C // =unk_2035000 
	lsl r0, r0, #1
	add r4, r4, r0
	lsr r0, r0, #1
	mov r1, #0
	mov r2, #3
	mov r7, #0x14
loc_802AFAE:
	push {r0,r1}
	ldrh r3, [r4]
	mov r2, #3
	bl bgmap_WriteTileIdAtBlock_800187C
	pop {r0,r1}
	add r1, #1
	add r4, #0x1e
	sub r7, #1
	bne loc_802AFAE
	sub r6, #1
	bne loc_802AF9A
	pop {r0,r4,r6,r7}
	str r0, [r5,#0x38]
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r0, [r1,#oRenderInfo_Unk_18]
	cmp r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_802AF6C

	thumb_local_start
sub_802AFD4:
	push {r4-r7,lr}
	ldrb r0, [r5,#2]
	tst r0, r0
	bne loc_802AFE4
	str r0, [r5,#0x3c]
	str r0, [r5,#0x38]
	mov r0, #4
	strb r0, [r5,#2]
loc_802AFE4:
	ldr r0, [r5,#0x38]
	add r0, #0xc
	push {r0,r4-r7}
	mov r7, r5
	mov r6, #4
	and r6, r0
	lsr r6, r6, #2
	mov r0, #1
	eor r6, r0
	add r6, #1
loc_802AFF8:
	ldr r0, [r7,#0x3c]
	add r0, #1
	str r0, [r7,#0x3c]
	// j
	sub r0, #1
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_802B020 // =byte_802B024
	mov r4, #1
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	sub r6, #1
	bne loc_802AFF8
	pop {r0,r4-r7}
	str r0, [r5,#0x38]
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r0, [r1,#oRenderInfo_Unk_18]
	cmp r0, #0x78 
	pop {r4-r7,pc}
	.balign 4, 0
off_802B020:
	.word byte_802B024
byte_802B024:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_802AFD4

	thumb_local_start
decomp_802B060:
	push {lr}
	// a1; src: (*a1)<<1>>1, dest= (u32)a1[8]
	ldr r0, initRefs // =initRefs_802B070 
	bl decompAndCopyData // (u32 *initRefs) -> void
	pop {pc}
	.balign 4, 0
initRefs:
	.word initRefs_802B070
initRefs_802B070:
	.word comp_86DD59C + COMPRESSED_PTR_FLAG
	.word 0x6008020
	.word decomp_2032000

	.word comp_86DDAD0 + COMPRESSED_PTR_FLAG
	.word unk_2030E60
	.word decomp_2032000

	.word comp_86DD9B4 + COMPRESSED_PTR_FLAG
off_802B08C:
	.word unk_2035000
	.word decomp_2032000

	.word byte_86DDB24
	.word unk_3001A80
	.word 0x20

	.word byte_86C9D6C
	.word byte_30016B0
	.word 0x20

	.word comp_86C9BD4 + COMPRESSED_PTR_FLAG
	.word 0x6016C80
	.word decomp_2032000

	.word comp_86C9D38 + COMPRESSED_PTR_FLAG
	.word 0x6016E00
	.word decomp_2032000

	.word comp_86DDB44 + COMPRESSED_PTR_FLAG
	.word 0x6016E40
	.word decomp_2032000

	.word comp_86DDB7C + COMPRESSED_PTR_FLAG
	.word 0x6016E80
	.word decomp_2032000

	.word CompText86D6974 + COMPRESSED_PTR_FLAG
	.word eTextScript2030860
	.word decomp_2032000

	.word NULL
	thumb_func_end decomp_802B060

	thumb_local_start
sub_802B0EC:
	push {r4-r7,lr}
	mov r7, #4
	ldr r6, off_802B118 // =dword_802B11C 
loc_802B0F2:
	ldr r0, [r6]
	lsl r0, r0, #0x10
	ldr r1, [r6,#4]
	orr r0, r1
	ldr r1, dword_802B114 // =0x10002 
	ldrb r2, [r5,#0xf]
	ldr r3, off_802B110 // =byte_802A848 
	ldr r4, [r6,#8]
	bl sub_811FAF4
	add r6, #0x10
	sub r7, #1
	bgt loc_802B0F2
	strb r0, [r5,#0xf]
	pop {r4-r7,pc}
	.balign 4, 0
off_802B110:
	.word byte_802A848
dword_802B114:
	.word 0x10002
off_802B118:
	.word dword_802B11C
dword_802B11C:
	.word 0x56
dword_802B120:
	.word 0x79
byte_802B124:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x6A, 0x0, 0x0, 0x0, 0x79, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x10, 0x0, 0x0, 0x0, 0x0, 0x56, 0x0, 0x0, 0x0, 0x8A, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0, 0x0, 0x0, 0x6A, 0x0, 0x0, 0x0, 0x8A
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_802B0EC

	thumb_local_start
sub_802B15C:
	push {r4-r7,lr}
	ldrb r2, [r5,r0]
	cmp r2, #0xff
	beq locret_802B194
	ldrh r0, [r5,#0x24]
	cmp r2, r0
	blt locret_802B194
	add r1, r0, #5
	cmp r2, r1
	bge locret_802B194
	sub r5, r2, r0
	lsl r5, r5, #4
	mov r7, #4
	ldr r6, off_802B1A0 // =dword_802B1A4 
loc_802B178:
	ldr r0, [r6]
	lsl r0, r0, #0x10
	ldr r1, [r6,#4]
	add r1, r1, r5
	orr r0, r1
	ldr r1, dword_802B19C // =0x10002 
	mov r2, #0
	ldr r3, off_802B198 // =dword_802A862
	ldr r4, [r6,#8]
	bl sub_811FAF4
	add r6, #0x10
	sub r7, #1
	bgt loc_802B178
locret_802B194:
	pop {r4-r7,pc}
	.balign 4, 0
off_802B198:
	.word dword_802A862
dword_802B19C:
	.word 0x10002
off_802B1A0:
	.word dword_802B1A4
dword_802B1A4:
	.word 0xC
dword_802B1A8:
	.word 0xF
byte_802B1AC:
	.byte 0x0, 0x40, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4E, 0x0, 0x0, 0x0, 0xF, 0x0, 0x0
	.byte 0x0, 0x0, 0x40, 0x0, 0x10, 0x0, 0x0, 0x0, 0x0, 0xC, 0x0, 0x0, 0x0, 0x1B, 0x0
	.byte 0x0, 0x0, 0x0, 0x40, 0x0, 0x20, 0x0, 0x0, 0x0, 0x0, 0x4E, 0x0, 0x0, 0x0, 0x1B
	.byte 0x0, 0x0, 0x0, 0x0, 0x40, 0x0, 0x30, 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_802B15C

	thumb_local_start
sub_802B1E4:
	push {r4-r7,lr}
	ldrh r0, [r5,#0x1e]
	tst r0, r0
	beq locret_802B1FE
	mov r0, #2
	mov r1, #0x12
	mov r2, #0x20 
	mov r3, #0xc
	ldr r4, off_802B200 // =byte_802A840 
	ldr r6, dword_802B208 // =0x40000000 
	ldr r7, dword_802B204 // =0x10002 
	bl sub_802B20C
locret_802B1FE:
	pop {r4-r7,pc}
	.balign 4, 0
off_802B200:
	.word byte_802A840
dword_802B204:
	.word 0x10002
dword_802B208:
	.word 0x40000000
	thumb_func_end sub_802B1E4

	thumb_local_start
sub_802B20C:
	push {r4-r7,lr}
	sub sp, sp, #0x1c
	str r1, [sp]
	str r2, [sp,#4]
	str r3, [sp,#8]
	str r4, [sp,#0xc]
	str r6, [sp,#0x10]
	lsl r0, r0, #0x10
	ldr r1, [sp]
	ldr r3, [sp,#4]
	tst r3, r3
	bne loc_802B228
	mov r2, #0
	b loc_802B22A
loc_802B228:
	ldrh r2, [r5,r3]
loc_802B22A:
	mov r3, #0x10
	mul r2, r3
	add r1, r1, r2
	orr r0, r1
	mov r1, r7
	ldr r2, [sp,#8]
	ldrb r2, [r5,r2]
	str r2, [sp,#0x14]
	mov r3, #0xf
	and r2, r3
	ldr r3, [sp,#0xc]
	ldr r4, [sp,#0x10]
	bl sub_811FAF4
	ldr r1, [sp,#0x14]
	lsr r1, r1, #4
	sub r1, #1
	bne loc_802B258
	ldr r1, off_802B26C // =dword_8129180 
	bl sub_8120CC8
	ldr r2, [sp,#8]
	strb r0, [r5,r2]
loc_802B258:
	ldr r2, [sp,#8]
	ldrb r0, [r5,r2]
	mov r3, #0xf
	and r0, r3
	lsl r1, r1, #4
	orr r0, r1
	strb r0, [r5,r2]
	add sp, sp, #0x1c
	pop {r4-r7,pc}
	.balign 4, 0
off_802B26C:
	.word dword_8129180
	thumb_func_end sub_802B20C

	thumb_local_start
sub_802B270:
	push {r4-r7,lr}
	ldr r0, dword_802B28C // =0x62 
	mov r1, #0xc
	lsl r0, r0, #0x10
	orr r0, r1
	ldr r1, dword_802B290 // =0x10002 
	ldrh r2, [r5,#0x1e]
	ldrh r3, [r5,#0x24]
	mov r4, #7
	ldr r6, dword_802B294 // =0xb370 
	mov r7, #0x48 
	bl object_computeAndQueueOamEntry_811FA98
	pop {r4-r7,pc}
	.balign 4, 0
dword_802B28C:
	.word 0x62
dword_802B290:
	.word 0x10002
dword_802B294:
	.word 0xB370
	thumb_func_end sub_802B270

	thumb_local_start
sub_802B298:
	ldr r0, off_802B29C // =eS20364C0 
	mov pc, lr
off_802B29C:
	.word eS20364C0
	thumb_func_end sub_802B298

	thumb_func_start sub_802B2A0
sub_802B2A0:
	push {r4-r7,lr}
	mov r7, r0
	ldr r1, dword_802B350 // =0x1b 
	lsl r1, r1, #1
	// byte
	mov r2, #0xff
	bl ByteFill // (u8 *mem, int byteCount, u8 byte) -> void
	mov r6, #0
	mov r4, #0
loc_802B2B2:
	ldr r0, off_802B2DC // =byte_802B2E0
	lsl r1, r4, #2
	ldr r0, [r0,r1]
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	beq loc_802B2CE
	ldr r1, dword_802B354 // =0x197 
	ldr r0, off_802B2DC // =byte_802B2E0
	lsl r2, r4, #2
	ldr r0, [r0,r2]
	sub r0, r0, r1
	add r0, #1
	strh r0, [r7,r6]
loc_802B2CE:
	add r6, #2
	add r4, #1
	ldr r0, dword_802B350 // =0x1b 
	cmp r4, r0
	blt loc_802B2B2
	lsr r0, r6, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_802B2DC:
	.word byte_802B2E0
byte_802B2E0:
	.byte 0x97, 0x1, 0x0, 0x0, 0x98, 0x1, 0x0, 0x0, 0x99, 0x1, 0x0, 0x0, 0x9A
	.byte 0x1, 0x0, 0x0, 0x9B, 0x1, 0x0, 0x0, 0x9C, 0x1, 0x0, 0x0, 0x9D, 0x1
	.byte 0x0, 0x0, 0x9E, 0x1, 0x0, 0x0, 0x9F, 0x1, 0x0, 0x0, 0xA1, 0x1, 0x0
	.byte 0x0, 0xA2, 0x1, 0x0, 0x0, 0xA4, 0x1, 0x0, 0x0, 0xA5, 0x1, 0x0, 0x0
	.byte 0xA6, 0x1, 0x0, 0x0, 0xA7, 0x1, 0x0, 0x0, 0xA8, 0x1, 0x0, 0x0, 0xA9
	.byte 0x1, 0x0, 0x0, 0xAA, 0x1, 0x0, 0x0, 0xAB, 0x1, 0x0, 0x0, 0xAC, 0x1
	.byte 0x0, 0x0, 0xAD, 0x1, 0x0, 0x0, 0xAE, 0x1, 0x0, 0x0, 0xAF, 0x1, 0x0
	.byte 0x0, 0xB0, 0x1, 0x0, 0x0, 0xB1, 0x1, 0x0, 0x0, 0xB2, 0x1, 0x0, 0x0
	.byte 0xB3, 0x1, 0x0, 0x0, 0xB4, 0x1, 0x0, 0x0
dword_802B350:
	.word 0x1B
dword_802B354:
	.word 0x197
	thumb_func_end sub_802B2A0

	thumb_func_start sub_802B358
sub_802B358:
	push {r4-r7,lr}
	sub sp, sp, #8
	str r1, [sp,#4]
	mov r4, r0
	mov r6, #0
	str r6, [sp]
loc_802B364:
	mov r7, #8
	ldrh r0, [r5,#0x24]
	add r6, r6, r0
	ldrb r1, [r5,#0x10]
	cmp r1, #0xff
	beq loc_802B380
	cmp r6, r1
	beq loc_802B37E
	ldrb r1, [r5,#0x11]
	cmp r1, #0xff
	beq loc_802B380
	cmp r6, r1
	bne loc_802B380
loc_802B37E:
	mov r7, #0xc
loc_802B380:
	lsl r6, r6, #1
	ldrh r0, [r4,r6]
	ldr r1, dword_802B3E0 // =0xffff 
	cmp r0, r1
	bne loc_802B392
	mov r1, #0x29 
	ldr r0, off_802B3DC // =TextScript8736D74
	mov r7, #0xc
	b loc_802B3AC
loc_802B392:
	lsl r2, r0, #3
	add r2, #4
	ldr r1, off_802B3D8 // =byte_802B5FC
	ldrh r1, [r1,r2]
	ldrb r2, [r5,#0x12]
	add r1, r1, r2
	cmp r1, #0x32 
	ble loc_802B3A4
	mov r7, #0xc
loc_802B3A4:
	lsl r0, r0, #1
	ldr r1, off_802B3F4 // =byte_802B3F8
	ldrh r1, [r1,r0]
	ldr r0, off_802B3F0 // =TextScriptVirusChipNames 
loc_802B3AC:
	ldr r6, [sp]
	mov r2, #0x28 
	lsl r2, r2, #4
	mul r6, r2
	ldr r2, [sp,#4]
	push {r4-r7}
	add r2, r2, r6
	ldr r3, dword_802B3E8 // =0x6008e00 
	add r3, r3, r6
	mov r4, #0xa
	mov r5, #1
	ldr r6, off_802B3E4 // =dword_86B7AE0 
	bl renderTextGfx_8045F8C
	pop {r4-r7}
	ldr r6, [sp]
	add r6, #1
	str r6, [sp]
	cmp r6, #5
	blt loc_802B364
	add sp, sp, #8
	pop {r4-r7,pc}
	.balign 4, 0
off_802B3D8:
	.word byte_802B5FC
off_802B3DC:
	.word TextScript8736D74
dword_802B3E0:
	.word 0xFFFF
off_802B3E4:
	.word dword_86B7AE0
dword_802B3E8:
	.word 0x6008E00
	.word decomp_2032000
off_802B3F0:
	.word TextScriptVirusChipNames
off_802B3F4:
	.word byte_802B3F8
byte_802B3F8:
	.byte 0x0, 0x0, 0x1, 0x0, 0x7, 0x0, 0xD, 0x0, 0x13, 0x0, 0x19, 0x0, 0x1F, 0x0
	.byte 0x25, 0x0, 0x2B, 0x0, 0x31, 0x0, 0x37, 0x0, 0x3D, 0x0, 0x43, 0x0, 0x49, 0x0
	.byte 0x4F, 0x0, 0x55, 0x0, 0x5B, 0x0, 0x61, 0x0, 0x67, 0x0, 0x6D, 0x0, 0x73, 0x0
	.byte 0x79, 0x0, 0x7F, 0x0, 0x85, 0x0, 0x8B, 0x0, 0x91, 0x0, 0x97, 0x0, 0x9D, 0x0
	.byte 0xA3, 0x0, 0xA9, 0x0, 0xAF, 0x0, 0x1F, 0x0
	thumb_func_end sub_802B358

	thumb_func_start sub_802B438
sub_802B438:
	push {r4-r7,lr}
	sub sp, sp, #0x18
	str r0, [sp,#0x10]
	str r1, [sp,#0x14]
	mov r0, #0
	str r0, [sp,#4]
	str r0, [sp]
	str r0, [sp,#0xc]
loc_802B448:
	ldr r4, [sp,#0x14]
	ldrh r0, [r5,#0x24]
	ldrh r1, [r5,#0x20]
	add r1, r1, r0
	lsl r1, r1, #1
	ldrh r0, [r4,r1]
	ldr r1, dword_802B4D0 // =0xffff 
	cmp r0, r1
	bne loc_802B45E
	mov r0, #0
	b loc_802B46E
loc_802B45E:
	lsl r1, r0, #3
	ldr r2, [sp,#4]
	lsl r2, r2, #1
	add r1, r1, r2
	ldr r4, off_802B4C8 // =byte_802B5FC
	ldrh r0, [r4,r1]
	bl memory_bcdConvert
loc_802B46E:
	mov r7, r0
	mov r6, #0x10
loc_802B472:
	mov r1, #0x20 
	sub r1, r1, r6
	mov r2, r7
	lsl r2, r1
	lsr r2, r1
	sub r6, #4
	lsr r2, r6
	tst r2, r2
	bne loc_802B492
	ldr r0, [sp,#0xc]
	tst r0, r0
	bne loc_802B492
	tst r6, r6
	beq loc_802B492
	mov r2, #0xa
	b loc_802B496
loc_802B492:
	mov r0, #1
	str r0, [sp,#0xc]
loc_802B496:
	mov r0, #0x20 
	mul r0, r2
	ldr r1, [sp,#0x10]
	add r0, r0, r1
	ldr r1, dword_802B4CC // =0x6009a80 
	ldr r3, [sp]
	mov r2, #0x20 
	mul r3, r2
	add r1, r1, r3
	bl QueueWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r0, [sp]
	add r0, #1
	str r0, [sp]
	cmp r6, #0
	bgt loc_802B472
	mov r0, #0
	str r0, [sp,#0xc]
	ldr r0, [sp,#4]
	add r0, #1
	str r0, [sp,#4]
	cmp r0, #3
	blt loc_802B448
	add sp, sp, #0x18
	pop {r4-r7,pc}
	.balign 4, 0
off_802B4C8:
	.word byte_802B5FC
dword_802B4CC:
	.word 0x6009A80
dword_802B4D0:
	.word 0xFFFF
	thumb_func_end sub_802B438

	thumb_func_start sub_802B4D4
sub_802B4D4:
	push {r4-r7,lr}
	sub sp, sp, #4
	str r1, [sp]
	mov r7, r0
	add r7, #4
	add r7, #0x3c 
	mov r1, #0x1e
	add r4, r7, r1
	mov r0, r2
	ldr r1, off_802B518 // =0xc80 
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	mov r5, #5
loc_802B4EE:
	mov r6, #0
	ldr r3, [sp]
	push {r4,r7}
loc_802B4F4:
	strh r3, [r7]
	add r3, #1
	strh r3, [r4]
	add r3, #1
	add r7, #2
	add r4, #2
	add r6, #1
	cmp r6, #0xa
	blt loc_802B4F4
	pop {r4,r7}
	str r3, [sp]
	add r7, #0x3c 
	add r4, #0x3c 
	sub r5, #1
	bgt loc_802B4EE
	add sp, sp, #4
	pop {r4-r7,pc}
	.balign 4, 0
off_802B518:
	.word 0xC80
	thumb_func_end sub_802B4D4

	thumb_func_start sub_802B51C
sub_802B51C:
	push {r4-r7,lr}
	sub sp, sp, #4
	str r1, [sp]
	mov r7, r0
	add r7, #0xa
	ldr r3, off_802B55C // =0x1a4 
	add r7, r7, r3
	mov r1, #0x1e
	add r4, r7, r1
	mov r5, #3
loc_802B530:
	mov r6, #0
	ldr r3, [sp]
	push {r4,r7}
loc_802B536:
	strh r3, [r7]
	add r3, #1
	add r7, #2
	add r6, #1
	cmp r6, #4
	blt loc_802B536
	pop {r4,r7}
	str r3, [sp]
	add r7, #0x3c 
	sub r5, #1
	cmp r5, #1
	bgt loc_802B530
	sub r7, #2
	tst r5, r5
	bne loc_802B530
	add sp, sp, #4
	pop {r4-r7,pc}
	.word 0x180
	.balign 4, 0
off_802B55C:
	.word 0x1A4
	thumb_func_end sub_802B51C

	thumb_local_start
sub_802B560:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	mov r1, #2
	tst r0, r1
	beq locret_802B5A2
	mov r1, #0x11
	ldrb r0, [r5,r1]
	cmp r0, #0xff
	bne loc_802B57E
	mov r1, #0x10
	ldrb r0, [r5,r1]
	cmp r0, #0xff
	beq locret_802B5A2
loc_802B57E:
	push {r1}
	ldrb r0, [r5,r1]
	bl sub_802B5B0
	pop {r1}
	mov r0, #0xff
	strb r0, [r5,r1]
	ldr r0, off_802B5A4 // =unk_2031000 
	ldr r1, off_802B5A8 // =decomp_2032000 
	bl sub_802B358
	ldr r0, off_802B5AC // =unk_2030E60 
	ldr r1, off_802B5A4 // =unk_2031000 
	bl sub_802B438
	mov r0, #SOUND_EXIT_SUBMENU
	bl PlaySoundEffect
locret_802B5A2:
	pop {pc}
	.balign 4, 0
off_802B5A4:
	.word unk_2031000
off_802B5A8:
	.word decomp_2032000
off_802B5AC:
	.word unk_2030E60
	thumb_func_end sub_802B560

	thumb_local_start
sub_802B5B0:
	lsl r0, r0, #1
	ldr r1, off_802B5C8 // =unk_2031000 
	ldrh r0, [r1,r0]
	lsl r0, r0, #3
	add r0, #4
	ldr r1, off_802B5CC // =byte_802B5FC
	ldrh r0, [r1,r0]
	ldrb r1, [r5,#0x12]
	sub r1, r1, r0
	strb r1, [r5,#0x12]
	mov pc, lr
	.balign 4, 0
off_802B5C8:
	.word unk_2031000
off_802B5CC:
	.word byte_802B5FC
	thumb_func_end sub_802B5B0

	thumb_local_start
sub_802B5D0:
	push {lr}
	mov r0, #SOUND_UNK_66
	bl PlaySoundEffect
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_802B5D0

	thumb_local_start
sub_802B5DC:
	push {lr}
	mov r1, r0
	ldr r0, off_802B5E8 // =eTextScript2030860
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	pop {pc}
	.balign 4, 0
off_802B5E8:
	.word eTextScript2030860
	thumb_func_end sub_802B5DC

	thumb_local_start
RunTextScriptBattleRunDialog:
	push {lr}
	mov r1, r0
	ldr r0, off_802B5F8 // =TextScriptBattleRunDialog
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	pop {pc}
	.balign 4, 0
off_802B5F8:
	.word TextScriptBattleRunDialog
byte_802B5FC:
	// this looks like text
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x28, 0x0, 0xA, 0x0, 0xA, 0x0, 0x0
	.byte 0x0, 0x46, 0x0, 0x14, 0x0, 0xA, 0x0, 0x0, 0x0, 0x82, 0x0, 0x28, 0x0, 0x14, 0x0
	.byte 0x0, 0x0, 0x5A, 0x0, 0x1E, 0x0, 0x14, 0x0, 0x0, 0x0, 0x64, 0x0, 0x32, 0x0, 0x1E
	.byte 0x0, 0x0, 0x0, 0x50, 0x0, 0x14, 0x0, 0xA, 0x0, 0x0, 0x0, 0x82, 0x0, 0x46, 0x0
	.byte 0x1E, 0x0, 0x0, 0x0, 0x3C, 0x0, 0x14, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x82, 0x0, 0x0
	.byte 0x0, 0x1E, 0x0, 0x0, 0x0, 0x50, 0x0, 0x0, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x50, 0x0
	.byte 0x14, 0x0, 0x14, 0x0, 0x0, 0x0, 0x96, 0x0, 0x32, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x64, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x50, 0x0, 0xA, 0x0, 0x14, 0x0, 0x0, 0x0
	.byte 0x3C, 0x0, 0x14, 0x0, 0x14, 0x0, 0x0, 0x0, 0xC8, 0x0, 0x64, 0x0, 0x28, 0x0, 0x0
	.byte 0x0, 0x64, 0x0, 0x1E, 0x0, 0x28, 0x0, 0x0, 0x0, 0x78, 0x0, 0x28, 0x0, 0x1E, 0x0
	.byte 0x0, 0x0, 0x64, 0x0, 0x1E, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x8C, 0x0, 0x1E, 0x0, 0x14
	.byte 0x0, 0x0, 0x0, 0x64, 0x0, 0x14, 0x0, 0xA, 0x0, 0x0, 0x0, 0x82, 0x0, 0x5, 0x0
	.byte 0x14, 0x0, 0x0, 0x0, 0x3C, 0x0, 0xA, 0x0, 0x14, 0x0, 0x0, 0x0, 0x8C, 0x0, 0x14
	.byte 0x0, 0x1E, 0x0, 0x0, 0x0, 0xB4, 0x0, 0x64, 0x0, 0x28, 0x0, 0x0, 0x0, 0x82, 0x0
	.byte 0x3C, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x64, 0x0, 0x14, 0x0, 0x14, 0x0, 0x0, 0x0, 0x78
	.byte 0x0, 0x32, 0x0, 0x28, 0x0, 0x0, 0x0, 0x64, 0x0, 0x28, 0x0, 0x1E, 0x0, 0x0, 0x0
	thumb_func_end RunTextScriptBattleRunDialog

	thumb_func_start sub_802B6EC
sub_802B6EC:
	push {r4-r7,lr}
	mov r6, #1
	b loc_802B6F6
	thumb_func_end sub_802B6EC

	thumb_local_start
sub_802B6F2:
	push {r4-r7,lr}
	mov r6, #0
loc_802B6F6:
	push {r0-r3}
	// memBlock
	ldr r0, off_802BA44 // =word_2036660 
	// size
	mov r1, #0x20 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r7, #0
	cmp r6, #0
	beq loc_802B708
	mov r7, #0x1c
loc_802B708:
	lsl r7, r7, #9
	pop {r0-r3}
	ldr r5, off_802BA44 // =word_2036660 
	strh r0, [r5,#0x4] // (word_2036664 - 0x2036660)
	strb r1, [r5,#0x6] // (byte_2036666 - 0x2036660)
	strb r2, [r5,#0x7] // (byte_2036667 - 0x2036660)
	mov r6, r5
	add r6, #0x14
	mov r1, #0
	sub r1, #1
	mov r4, #0xff
	mov r2, #0
loc_802B720:
	add r4, #1
	ldrsh r0, [r3,r2]
	orr r0, r7
	strh r0, [r6]
	add r3, #2
	add r6, #2
	cmp r0, r1
	bne loc_802B720
	strb r4, [r5,#0x8] // (byte_2036668 - 0x2036660)
	pop {r4-r7,pc}
	thumb_func_end sub_802B6F2

	thumb_func_start sub_802B734
sub_802B734:
	push {r5,lr}
	ldr r5, off_802BA44 // =word_2036660 
	ldr r0, [r5,#0xc] // (dword_203666C - 0x2036660)
	add r0, #1
	str r0, [r5,#0xc] // (dword_203666C - 0x2036660)
	ldr r1, off_802B74C // =off_802B750 
	ldrb r0, [r5]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r5,pc}
	.balign 4, 0
off_802B74C:
	.word off_802B750
off_802B750:
	.word sub_802B75C+1
	.word sub_802B76C+1
	.word sub_802B766+1
	thumb_func_end sub_802B734

	thumb_local_start
sub_802B75C:
	push {lr}
	mov r0, #4
	str r0, [r5]
	mov r0, #0
	pop {pc}
	thumb_func_end sub_802B75C

	thumb_local_start
sub_802B766:
	push {lr}
	mov r0, #1
	pop {pc}
	thumb_func_end sub_802B766

	thumb_local_start
sub_802B76C:
	push {r5,lr}
	ldr r5, off_802BA44 // =word_2036660 
	ldr r1, off_802B780 // =off_802B784 
	ldrb r0, [r5,#0x1] // (word_2036660+1 - 0x2036660)
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	mov r0, #0
	pop {r5,pc}
	.balign 4, 0
off_802B780:
	.word off_802B784
off_802B784:
	.word sub_802B7A0+1
	.word sub_802B7E0+1
	.word sub_802B80C+1
	.word sub_802B8E0+1
	.word sub_802B920+1
	.word sub_802B9B8+1
	.word sub_802B9D4+1
	thumb_func_end sub_802B76C

	thumb_local_start
sub_802B7A0:
	push {lr}
	ldrb r0, [r5,#2]
	cmp r0, #0
	bne loc_802B7BC
	mov r0, #1
	strb r0, [r5,#2]
	mov r0, #0
	bl sub_802B9FE
	mov r0, #0x14
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	b locret_802B7DE
loc_802B7BC:
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_802B7DE
	mov r0, #0x24 
	ldrb r1, [r5,#7]
	cmp r1, #0
	bne loc_802B7CE
	mov r0, #0x34 
loc_802B7CE:
	bl sub_801E792
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov r0, #0
	str r0, [r5,#0x10]
locret_802B7DE:
	pop {pc}
	thumb_func_end sub_802B7A0

	thumb_local_start
sub_802B7E0:
	push {lr}
	ldrb r0, [r5,#2]
	cmp r0, #0
	bne loc_802B7F4
	bl comm_checkCrossNetBattleReady_801E754
	cmp r0, #2
	bne locret_802B80A
	mov r0, #1
	strb r0, [r5,#2]
loc_802B7F4:
	ldr r0, [r5,#0x10]
	add r0, #1
	cmp r0, #0x14
	blt loc_802B808
	mov r0, #8
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov r0, #0
	str r0, [r5,#0xc]
loc_802B808:
	str r0, [r5,#0x10]
locret_802B80A:
	pop {pc}
	thumb_func_end sub_802B7E0

	thumb_local_start
sub_802B80C:
	push {lr}
	bl sub_802B9E4
	ldr r0, [r5,#0x10]
	add r1, r0, #1
	str r1, [r5,#0x10]
	mov r1, #7
	tst r0, r1
	bne locret_802B8AE
	mov r3, r0
	lsr r0, r0, #2
	add r0, #0x14
	ldrh r0, [r5,r0]
	push {r0-r7}
	bl chip_SelectNameTextTable_8027D10
	ldr r2, off_802B990 // =0x48 
	mul r2, r3
	ldr r3, dword_802B9A4 // =0x6009560 
	add r3, r3, r2
	ldr r2, off_802B9A0 // =byte_203C4E0 
	mov r4, #9
	mov r5, #1
	ldr r6, off_802B9A8 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	pop {r0-r7}
	push {r3-r7}
	lsl r2, r0, #0x17
	lsr r2, r2, #0x17
	ldr r1, off_802B99C // =0x160 
	cmp r2, r1
	bge loc_802B86A
	lsr r1, r0, #9
	ldr r0, off_802B9AC // =TextScript86F0300 
	ldr r2, off_802B990 // =0x48 
	mul r2, r3
	ldr r3, dword_802B9B4 // =0x6009760 
	add r3, r3, r2
	ldr r2, off_802B9B0 // =byte_203C6E0 
	mov r4, #1
	mov r5, #1
	ldr r6, off_802B9A8 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
loc_802B86A:
	pop {r3-r7}
	ldr r0, [r5,#0x10]
	lsr r0, r0, #3
	ldrb r1, [r5,#6]
	cmp r0, r1
	blt loc_802B888
	sub r0, r0, r1
	ldrb r1, [r5,#7]
	cmp r0, r1
	bge loc_802B888
	mov r0, #0x91
	bl PlaySoundEffect
	ldr r0, dword_802B998 // =0xa0ab 
	b loc_802B88A
loc_802B888:
	ldr r0, dword_802B994 // =0xd0ab 
loc_802B88A:
	mov r2, #0x12
	lsr r3, r3, #3
	mul r2, r3
	add r0, r0, r2
	ldr r1, [r5,#0x10]
	lsr r1, r1, #3
	bl sub_802B8B0
	ldr r0, [r5,#0x10]
	lsr r0, r0, #3
	add r0, #1
	ldrb r1, [r5,#8]
	cmp r0, r1
	blt locret_802B8AE
	mov r0, #0xc
	strb r0, [r5,#1]
	mov r0, #0
	str r0, [r5,#0x10]
locret_802B8AE:
	pop {pc}
	thumb_func_end sub_802B80C

	thumb_local_start
sub_802B8B0:
	push {r4,r5,lr}
	sub sp, sp, #0x24
	mov r2, sp
	mov r3, #9
loc_802B8B8:
	strh r0, [r2]
	add r0, #1
	strh r0, [r2,#0x12]
	add r0, #1
	add r2, #2
	sub r3, #1
	bne loc_802B8B8
	mov r3, sp
	mov r0, #3
	mul r1, r0
	add r1, #5
	bl sub_802BA18
	mov r2, #3
	mov r4, #9
	mov r5, #2
	bl sub_802BA24
	add sp, sp, #0x24
	pop {r4,r5,pc}
	thumb_func_end sub_802B8B0

	thumb_local_start
sub_802B8E0:
	push {lr}
	bl sub_802B9E4
	ldr r0, [r5,#0x10]
	add r0, #1
	str r0, [r5,#0x10]
	cmp r0, #0x18
	blt locret_802B91E
	push {r4-r7}
	ldrb r1, [r5,#6]
	mov r0, #3
	mul r1, r0
	add r1, #5
	ldrb r5, [r5,#7]
	mul r5, r0
	sub r5, #1
	ldr r0, off_802BA44 // =word_2036660 
	bl sub_802BA18
	mov r2, #3
	mov r3, #0
	mov r4, #9
	bl sub_802BA34
	pop {r4-r7}
	mov r0, #0x10
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov r0, #0
	str r0, [r5,#0x10]
locret_802B91E:
	pop {pc}
	thumb_func_end sub_802B8E0

	thumb_local_start
sub_802B920:
	push {lr}
	bl sub_802B9E4
	ldr r0, [r5,#0x10]
	add r0, #1
	str r0, [r5,#0x10]
	cmp r0, #0x60 
	bge loc_802B96E
	cmp r0, #0x10
	bne locret_802B98C
	ldr r0, dword_802B998 // =0xa0ab 
	mov r2, #0x12
	ldrb r1, [r5,#6]
	mul r2, r1
	add r0, r0, r2
	bl sub_802B8B0
	push {r4-r7}
	ldrh r0, [r5,#4]
	bl chip_SelectNameTextTable_8027D10
	ldr r2, off_802B990 // =0x48 
	ldrb r3, [r5,#6]
	lsl r3, r3, #3
	mul r2, r3
	ldr r3, dword_802B9A4 // =0x6009560 
	add r3, r3, r2
	ldr r2, off_802B9A0 // =byte_203C4E0 
	mov r4, #9
	mov r5, #1
	ldr r6, off_802B9A8 // =dword_86B7AE0 
	mov r7, #0
	bl renderTextGfx_8045F8C
	pop {r4-r7}
	mov r0, #0x92
	bl PlaySoundEffect
	b locret_802B98C
loc_802B96E:
	mov r0, #0x14
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	bl sub_801E780
	bl sub_802BA18
	mov r1, #5
	mov r2, #3
	mov r3, #0
	mov r4, #9
	mov r5, #0xe
	bl sub_802BA34
locret_802B98C:
	pop {pc}
	.balign 4, 0
off_802B990:
	.word 0x48
dword_802B994:
	.word 0xD0AB
dword_802B998:
	.word 0xA0AB
off_802B99C:
	.word 0x160
off_802B9A0:
	.word byte_203C4E0
dword_802B9A4:
	.word 0x6009560
off_802B9A8:
	.word dword_86B7AE0
off_802B9AC:
	.word TextScript86F0300
off_802B9B0:
	.word byte_203C6E0
dword_802B9B4:
	.word 0x6009760
	thumb_func_end sub_802B920

	thumb_local_start
sub_802B9B8:
	push {lr}
	bl comm_checkCrossNetBattleReady_801E754
	cmp r0, #0
	bne locret_802B9D2
	mov r0, #0x18
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	mov r0, #0x10
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
locret_802B9D2:
	pop {pc}
	thumb_func_end sub_802B9B8

	thumb_local_start
sub_802B9D4:
	push {lr}
	bl IsScreenFadeActive // () -> zf
	cmp r0, #0
	bne locret_802B9E2
	mov r0, #8
	str r0, [r5]
locret_802B9E2:
	pop {pc}
	thumb_func_end sub_802B9D4

	thumb_local_start
sub_802B9E4:
	push {r0,r1,lr}
	ldr r0, [r5,#0xc]
	mov r1, #3
	tst r0, r1
	bne locret_802B9FC
	lsr r0, r0, #4
	and r0, r1
	cmp r0, #3
	bne loc_802B9F8
	mov r0, #1
loc_802B9F8:
	bl sub_802B9FE
locret_802B9FC:
	pop {r0,r1,pc}
	thumb_func_end sub_802B9E4

	thumb_local_start
sub_802B9FE:
	push {r1-r3,lr}
	lsl r0, r0, #3
	ldr r1, off_802BA10 // =byte_802BA48 
	add r0, r0, r1
	ldr r1, off_802BA14 // =unk_3001AA0 
	mov r2, #8
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r1-r3,pc}
	.balign 4, 0
off_802BA10:
	.word byte_802BA48
off_802BA14:
	.word unk_3001AA0
	thumb_func_end sub_802B9FE

	thumb_local_start
sub_802BA18:
	mov r0, r10
	ldr r0, [r0,#oToolkit_RenderInfoPtr]
	ldrh r0, [r0,#oRenderInfo_Unk_18]
	asr r0, r0, #3
	add r0, #1
	mov pc, lr
	thumb_func_end sub_802BA18

	thumb_local_start
sub_802BA24:
	push {r6,lr}
	ldr r6, off_802BA44 // =word_2036660 
	ldrb r6, [r6,#0x7] // (byte_2036667 - 0x2036660)
	cmp r6, #0
	beq locret_802BA32
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
locret_802BA32:
	pop {r6,pc}
	thumb_func_end sub_802BA24

	thumb_local_start
sub_802BA34:
	push {r6,lr}
	ldr r6, off_802BA44 // =word_2036660 
	ldrb r6, [r6,#0x7] // (byte_2036667 - 0x2036660)
	cmp r6, #0
	beq locret_802BA42
	bl call_sub_3005EBA
locret_802BA42:
	pop {r6,pc}
	.balign 4, 0
off_802BA44:
	.word word_2036660
byte_802BA48:
	.byte 0x0, 0x0, 0xFF, 0x7F, 0xA5, 0x14, 0x0, 0x0, 0x0, 0x0, 0xF0, 0x43
	.byte 0xA5, 0x14, 0x0, 0x0, 0x0, 0x0, 0x1F, 0x42, 0xA5, 0x14, 0x0, 0x0
byte_802BA60:
	.byte 0x3, 0x4, 0x53, 0x1, 0x47, 0x0, 0x48, 0x0, 0x49, 0x0
byte_802BA6A:
	.byte 0x3, 0x4, 0x53, 0x1, 0x47, 0x0, 0x4A, 0x0, 0x4B, 0x0
byte_802BA74:
	.byte 0x3, 0x4, 0x56, 0x1, 0x46, 0x0, 0x46, 0x0, 0x98, 0x0
byte_802BA7E:
	.byte 0x3, 0x4, 0x57, 0x1, 0xBA, 0x0, 0xBC, 0x0, 0xBB, 0x0
byte_802BA88:
	.byte 0x3, 0x4, 0x4E, 0x1, 0x22, 0x0, 0x23, 0x0, 0x24, 0x0
byte_802BA92:
	.byte 0x3, 0x4, 0x58, 0x1, 0x4A, 0x0, 0x4B, 0x0, 0xE2, 0x0
byte_802BA9C:
	.byte 0x3, 0x4, 0x59, 0x1, 0x96, 0x0, 0x96, 0x0, 0x2D, 0x1
byte_802BAA6:
	.byte 0x3, 0x4, 0x59, 0x1, 0x96, 0x0, 0x96, 0x0, 0x32, 0x1
byte_802BAB0:
	.byte 0x3, 0x4, 0x5B, 0x1, 0x8B, 0x0, 0xC3, 0x0, 0xB9, 0x0
byte_802BABA:
	.byte 0x3, 0x4, 0x5C, 0x1, 0xE2, 0x0, 0xBA, 0x0, 0x10, 0x1
byte_802BAC4:
	.byte 0x3, 0x4, 0x5C, 0x1, 0x12, 0x1, 0xBA, 0x0, 0xE0, 0x0
byte_802BACE:
	.byte 0x3, 0x4, 0x5D, 0x1, 0x16, 0x1, 0x17, 0x1, 0x18, 0x1
byte_802BAD8:
	.byte 0x4, 0x4, 0x5A, 0x1, 0x6D, 0x0, 0x3F, 0x0, 0x24, 0x0, 0x27, 0x0
byte_802BAE4:
	.byte 0x3, 0x0, 0x40, 0x1, 0x1, 0x0
byte_802BAEA:
	.byte 0x3, 0x0, 0x41, 0x1, 0x2, 0x0
byte_802BAF0:
	.byte 0x3, 0x0, 0x42, 0x1, 0x3, 0x0
byte_802BAF6:
	.byte 0x3, 0x0, 0x51, 0x1, 0x17, 0x0
byte_802BAFC:
	.byte 0x3, 0x0, 0x43, 0x1, 0x14, 0x0
byte_802BB02:
	.byte 0x3, 0x0, 0x44, 0x1, 0x15, 0x0
byte_802BB08:
	.byte 0x3, 0x0, 0x45, 0x1, 0x16, 0x0
byte_802BB0E:
	.byte 0x3, 0x0, 0x46, 0x1, 0x6B, 0x0
byte_802BB14:
	.byte 0x3, 0x0, 0x47, 0x1, 0x6C, 0x0
byte_802BB1A:
	.byte 0x3, 0x0, 0x48, 0x1, 0x6D, 0x0
byte_802BB20:
	.byte 0x3, 0x0, 0x52, 0x1, 0x9, 0x0
byte_802BB26:
	.byte 0x3, 0x0, 0x52, 0x1, 0xA, 0x0
byte_802BB2C:
	.byte 0x3, 0x0, 0x52, 0x1, 0xB, 0x0
byte_802BB32:
	.byte 0x3, 0x0, 0x55, 0x1, 0x32, 0x0
byte_802BB38:
	.byte 0x3, 0x0, 0x54, 0x1, 0x13, 0x0
byte_802BB3E:
	.byte 0x3, 0x0, 0x4F, 0x1, 0x90, 0x0
byte_802BB44:
	.byte 0x3, 0x0, 0x4F, 0x1, 0xC8, 0x0
byte_802BB4A:
	.byte 0x3, 0x0, 0x4F, 0x1, 0xC9, 0x0
byte_802BB50:
	.byte 0x3, 0x0, 0x49, 0x1, 0x5C, 0x0
byte_802BB56:
	.byte 0x3, 0x0, 0x4A, 0x1, 0x5D, 0x0
byte_802BB5C:
	.byte 0x3, 0x0, 0x4B, 0x1, 0x5E, 0x0
byte_802BB62:
	.byte 0x3, 0x0, 0x4C, 0x1, 0x40, 0x0
byte_802BB68:
	.byte 0x3, 0x0, 0x4C, 0x1, 0x41, 0x0
byte_802BB6E:
	.byte 0x3, 0x0, 0x4C, 0x1, 0x42, 0x0
byte_802BB74:
	.byte 0x3, 0x0, 0x4D, 0x1, 0x7B, 0x0
byte_802BB7A:
	.byte 0x3, 0x0, 0x4D, 0x1, 0x7C, 0x0
byte_802BB80:
	.byte 0x3, 0x0, 0x4D, 0x1, 0x7D, 0x0
byte_802BB86:
	.byte 0x3, 0x0, 0x50, 0x1, 0x5F, 0x0
byte_802BB8C:
	.byte 0x3, 0x0, 0x50, 0x1, 0x60, 0x0
byte_802BB92:
	.byte 0x3, 0x0, 0x50, 0x1, 0x61, 0x0
byte_802BB98:
	.byte 0x3, 0x4, 0x40, 0x1, 0x1, 0x0, 0x1, 0x0, 0xC, 0x0
byte_802BBA2:
	.byte 0x3, 0x4, 0x41, 0x1, 0x2, 0x0, 0x2, 0x0, 0xD, 0x0
byte_802BBAC:
	.byte 0x3, 0x4, 0x42, 0x1, 0x3, 0x0, 0x3, 0x0, 0xE, 0x0
byte_802BBB6:
	.byte 0x3, 0x4, 0x43, 0x1, 0x14, 0x0, 0x14, 0x0, 0x6E, 0x0
byte_802BBC0:
	.byte 0x3, 0x4, 0x44, 0x1, 0x15, 0x0, 0x15, 0x0, 0x6F, 0x0
byte_802BBCA:
	.byte 0x3, 0x4, 0x45, 0x1, 0x16, 0x0, 0x16, 0x0, 0x70, 0x0
byte_802BBD4:
	.byte 0x3, 0x4, 0x46, 0x1, 0x6B, 0x0, 0x6B, 0x0, 0x2E, 0x0
byte_802BBDE:
	.byte 0x3, 0x4, 0x47, 0x1, 0x6C, 0x0, 0x6C, 0x0, 0x2E, 0x0
byte_802BBE8:
	.byte 0x3, 0x4, 0x48, 0x1, 0x6D, 0x0, 0x6D, 0x0, 0x2E, 0x0
byte_802BBF2:
	.byte 0x3, 0x4, 0x49, 0x1, 0x5C, 0x0, 0x5C, 0x0, 0x5, 0x0
byte_802BBFC:
	.byte 0x3, 0x4, 0x4A, 0x1, 0x5D, 0x0, 0x5D, 0x0, 0x6, 0x0
byte_802BC06:
	.byte 0x3, 0x4, 0x4B, 0x1, 0x5E, 0x0, 0x5E, 0x0, 0x7, 0x0
byte_802BC10:
	.byte 0x3, 0x4, 0x4C, 0x1, 0x40, 0x0, 0x41, 0x0, 0x42, 0x0
byte_802BC1A:
	.byte 0x3, 0x4, 0x4D, 0x1, 0x7B, 0x0, 0x7C, 0x0, 0x7D, 0x0
byte_802BC24:
	.byte 0x3, 0x4, 0x4F, 0x1, 0x90, 0x0, 0xC8, 0x0, 0xC9, 0x0
byte_802BC2E:
	.byte 0x3, 0x4, 0x50, 0x1, 0x5F, 0x0, 0x60, 0x0, 0x61, 0x0
byte_802BC38:
	.byte 0x3, 0x4, 0x51, 0x1, 0x17, 0x0, 0x17, 0x0, 0x30, 0x0
byte_802BC42:
	.byte 0x3, 0x4, 0x52, 0x1, 0x9, 0x0, 0xA, 0x0, 0xB, 0x0
byte_802BC4C:
	.byte 0x3, 0x4, 0x55, 0x1, 0x32, 0x0, 0x32, 0x0, 0x33, 0x0
byte_802BC56:
	.byte 0x3, 0x4, 0x54, 0x1, 0x13, 0x0, 0x13, 0x0, 0x4A, 0x0
off_802BC60:
	.word byte_802BB98
	.word byte_802BBA2
	.word byte_802BBAC
	.word byte_802BBB6
	.word byte_802BBC0
	.word byte_802BBCA
	.word byte_802BBD4
	.word byte_802BBDE
	.word byte_802BBE8
	.word byte_802BBF2
	.word byte_802BBFC
	.word byte_802BC06
	.word byte_802BC10
	.word byte_802BC1A
	.word byte_802BC24
	.word byte_802BC2E
	.word byte_802BC38
	.word byte_802BC42
	.word byte_802BC4C
	.word byte_802BC56
off_802BCB0:
	.word byte_802BA60
	.word byte_802BA6A
	.word byte_802BA74
	.word byte_802BA7E
	.word byte_802BA88
	.word byte_802BA92
	.word byte_802BA9C
	.word byte_802BAA6
	.word byte_802BAB0
	.word byte_802BABA
	.word byte_802BAC4
	.word byte_802BACE
	.word byte_802BAD8
	.word byte_802BAE4
	.word byte_802BAEA
	.word byte_802BAF0
	.word byte_802BAF6
	.word byte_802BAFC
	.word byte_802BB02
	.word byte_802BB08
	.word byte_802BB0E
	.word byte_802BB14
	.word byte_802BB1A
	.word byte_802BB20
	.word byte_802BB26
	.word byte_802BB2C
	.word byte_802BB32
	.word byte_802BB38
	.word byte_802BB3E
	.word byte_802BB44
	.word byte_802BB4A
	.word byte_802BB50
	.word byte_802BB56
	.word byte_802BB5C
	.word byte_802BB62
	.word byte_802BB68
	.word byte_802BB6E
	.word byte_802BB74
	.word byte_802BB7A
	.word byte_802BB80
	.word byte_802BB86
	.word byte_802BB8C
	.word byte_802BB92
	.word NULL
	thumb_func_end sub_802BA34

	thumb_func_start sub_802BD60
sub_802BD60:
	push {r5,lr}
	ldr r5, off_802BDAC // =eS20364C0 
	mov r0, #1
	strb r0, [r5,#0x5]
	bl battle_getStateTableEntryPtr_802C8EA
	str r0, [r5,#0x18]
	ldrb r0, [r5,#0x6]
	strb r0, [r5,#0x7]
	ldr r1, off_802BD9C // =off_802BDA0 
	ldrb r0, [r5]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	push {r5}
	mov r1, #0x6
	// j
	ldrsb r0, [r5,r1]
	// i
	mov r1, #2
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_802BDB0 // =unk_2034B30 
	mov r4, #0x18
	mov r5, #0x12
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r5}
	bl sub_802C460
	ldrb r0, [r5,#5]
	pop {r5,pc}
	.balign 4, 0
off_802BD9C:
	.word off_802BDA0
off_802BDA0:
	.word sub_802BDB4+1
	.word sub_802BDC0+1
	.word sub_802C348+1
off_802BDAC:
	.word eS20364C0
off_802BDB0:
	.word unk_2034B30
	thumb_func_end sub_802BD60

// symdb: Runs helper sub_802C97E, then stores 4 into the word at r5, likely advancing a battle state/phase counter to its next step.
// symdb: void sub_802BDB4(r4 context?, r5 outStatePtr, r10 work?); writes u32 4 to *r5; returns with NZCV
// symdb: set from r0==4 and r0-r3 clobbered (r4, r5 preserved)
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802BDB4.yaml
	thumb_local_start
sub_802BDB4:
	push {lr}
	bl battle_checkTimerWindowSubstate_802C97E
	mov r0, #4
	str r0, [r5]
	pop {pc}
	thumb_func_end sub_802BDB4

	thumb_local_start
sub_802BDC0:
	push {lr}
	ldr r1, off_802BDD8 // =off_802BDDC 
	ldrb r0, [r5,#1]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_802C85C
	bl sound_pushRequest_802CA5C
	pop {pc}
	.balign 4, 0
off_802BDD8:
	.word off_802BDDC
off_802BDDC:
	.word sub_802BDF0+1
	.word sub_802BE90+1
	.word sub_802C280+1
	.word sub_802C2D0+1
	.word battle_advanceFade_802C328+1
	thumb_func_end sub_802BDC0

	thumb_local_start
sub_802BDF0:
	push {lr}
	ldr r1, off_802BE00 // =off_802BE04 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.byte 0, 0
off_802BE00:
	.word off_802BE04
off_802BE04:
	.word objStepFinishSetState4_802BE0C+1
	.word sub_802BE36+1
	thumb_func_end sub_802BDF0

// symdb: Finalizes a state-machine step for the object in r5 — triggers call_sub_3005EBA with fixed arguments (0,0,3,0,6,2), resets the toolkit render-info frame counter, calls sub_801E0A0(0,0), then advances the object's state halfword at +2 to 4.
// symdb: void sub_802BE0C(void); callers pass garbage in r0-r3 but r5 must hold the object pointer and
// symdb: r10 the toolkit pointer; r4/r5 are preserved; returns with r0=4 and NZ flags set from "mov
// symdb: r0,#4", r1-r3 as left by sub_801E0A0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/objStepFinishSetState4_802BE0C.yaml
	thumb_local_start
objStepFinishSetState4_802BE0C:
	push {r4,r5,lr}
	push {r5}
	mov r0, #0
	mov r1, #0
	mov r2, #3
	mov r3, #0
	mov r4, #6
	mov r5, #2
	bl call_sub_3005EBA
	pop {r5}
	mov r3, r10
	ldr r3, [r3,#oToolkit_RenderInfoPtr]
	mov r0, #0
	strh r0, [r3,#oRenderInfo_Unk_18]
	mov r1, #0
	bl sub_801E0A0
	mov r0, #4
	strh r0, [r5,#2]
	pop {r4,r5,pc}
	thumb_func_end objStepFinishSetState4_802BE0C

// symdb: Per-frame tick for a battle object: bumps its progress counter, transitions it to the follow-up state when the animation tops out, and (unless the object is in mode 2) refreshes its component and display.
// symdb: void sub_802BE36(struct BattleObject *r5 /* r5 in/out */); inputs:  r5 = object pointer outputs:
// symdb: r5 preserved; r6, r7 as left by sub_802C6EC (last callee) clobbers: r0, r1, r2, r3, r4, lr;
// symdb: flags NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802BE36.yaml
	thumb_local_start
sub_802BE36:
	push {lr}
	mov r1, #6
	ldrsb r0, [r5,r1]
	add r0, #2
	strb r0, [r5,#6]
	cmp r0, #3
	blt loc_802BE50
	mov r0, #3
	strb r0, [r5,#6]
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
loc_802BE50:
	ldrb r0, [r5,#4]
	cmp r0, #2
	beq locret_802BE66
	mov r1, #0
	ldr r0, [r5,#0x1c]
	ldrb r1, [r5,#0xe]
	bl sub_802C4E8
	ldrb r0, [r5,#8]
	bl sub_802C6EC
locret_802BE66:
	pop {pc}
	.balign 4, 0
pool_802BE68:
	.word byte_802BE6C
byte_802BE6C:
	.byte 0x0, 0x5, 0x0, 0x0, 0x0, 0x12, 0x0, 0x0, 0x0, 0x36, 0x0, 0x0, 0x0, 0x30
	.byte 0x0, 0x0, 0x0, 0x40, 0x0, 0x0, 0x0, 0x50, 0x0, 0x0, 0x0, 0x30, 0x0, 0x0
	.byte 0x0, 0x45, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0
	thumb_func_end sub_802BE36

// symdb: Dispatches the battle object in r5 to the per-state handler chosen by [r5+2] via a four-entry jump table at off_802BEA4.
// symdb: void dispatchBattleObjectState(u32 object /* r5 */); // passes through r2, r4, r6, r7, r10 to
// symdb: the handler unchanged; // handler's return lives in r5-r12 (passed back to caller as-is)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802BE90.yaml
	thumb_local_start
sub_802BE90:
	push {lr}
	ldr r1, off_802BEA0 // =off_802BEA4 
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.byte 0, 0
off_802BEA0:
	.word off_802BEA4
off_802BEA4:
	.word sub_802BEB4+1
	.word dispatchBattleObjectBehavior_802BF4C+1
	.word sub_802C170+1
	.word runObjectStateHandler_802C1D4+1
	thumb_func_end sub_802BE90

// symdb: Trampoline that reads a battle object's type byte and tail-calls the matching per-type handler (input-queue pop, tick countdown, or animation state picker) through the table at A_off_802BEC8.
// symdb: void battle_objectDispatchByType_802BEB4(void /* r5 = object pointer */);   reads:   r5 (object
// symdb: base), [r5+3] (type byte), table at A_off_802BEC8   writes:  none of its own; output registers
// symdb: r5–r12 plus r0–r4 and flags are            whatever the dispatched handler returns   status:  nz
// symdb: c v clobbered by the handler; lr pushed/popped, otherwise preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802BEB4.yaml
	thumb_local_start
sub_802BEB4:
	push {lr}
	ldr r1, off_802BEC4 // =off_802BEC8 
	ldrb r0, [r5,#3]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
off_802BEC4:
	.word off_802BEC8
off_802BEC8:
	.word custMenu_handleInputQueuePop_802BED4+1
	.word object_countdownTick_802BEFC+1
	.word battle_pickObjectAnimState_802BF0C+1
	thumb_func_end sub_802BEB4

// symdb: Custom-menu state handler that pops the next halfword from the menu input queue, backing out to the state dispatcher if the queue is empty, otherwise storing the entry and advancing the menu state with a hold timer.
// symdb: void custMenu_handleInputQueuePop_802BED4(/* r5 */ CustomMenuObj *menu); // lr clobbered;
// symdb: returns R0 = 0 (queue empty) or 4 (consumed), NZ set from R0, c/v untouched, R1 = Unk_0c byte on
// symdb: consumed path
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/custMenu_handleInputQueuePop_802BED4.yaml
	thumb_local_start
custMenu_handleInputQueuePop_802BED4:
	push {lr}

	bl queue_popHalfword_802C8D4
	tst r0, r0
	bne loc_802BEE8

	// trigger scrollStrip_update_8026BF4 via custMenuMainMaybe_8026A88
	mov r0, #8
	strb r0, [r5,#oS20364C0_JumpOffset01]

	mov r0, #0
	strh r0, [r5,#oS20364C0_Unk_02]

	b locret_802BEFA
loc_802BEE8:

	strh r0, [r5,#oS20364C0_Unk_10]

	mov r0, #1
	ldrb r1, [r5,#oS20364C0_Unk_0c]

	tst r1, r1
	bne loc_802BEF4

	mov r0, #0x1e
loc_802BEF4:
	strb r0, [r5,#oS20364C0_Unk_0b]
	mov r0, #4
	strb r0, [r5,#oS20364C0_Unk_03]
locret_802BEFA:
	pop {pc}
	thumb_func_end custMenu_handleInputQueuePop_802BED4

// symdb: Ticks down a per-object countdown byte at +0xB and advances the object's state byte at +3 to 8 when it expires.
// symdb: int object_countdownTick_ADDRESS(Object *r5); /* in: r5 = object struct, lr = return; out: r0 =
// symdb: decremented counter (or 8 when expired), NZCV flags set by SUBS/MOVS */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_countdownTick_802BEFC.yaml
	thumb_local_start
object_countdownTick_802BEFC:
	push {lr}
	ldrb r0, [r5,#0xb]
	sub r0, #1
	strb r0, [r5,#0xb]
	bne locret_802BF0A
	mov r0, #8
	strb r0, [r5,#3]
locret_802BF0A:
	pop {pc}
	thumb_func_end object_countdownTick_802BEFC

// symdb: Chooses an animation/state index for a battle object — either a scripted state derived from the object's +0xC byte, or a 0/1 alternation driven by bit 3 of the global frame counter — and passes it to sub_802C810.
// symdb: battle_pickObjectAnimState_802BF0C(BattleObj *obj /* r5 */, u32 r6, Toolkit *r10); no return
// symdb: value; preserves r5/r6/r10; calls sub_802C810 with r0 = state index and r7 = context pointer
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_pickObjectAnimState_802BF0C.yaml
	thumb_local_start
battle_pickObjectAnimState_802BF0C:
	push {lr}
	ldr r7, off_802BF48 // =dword_2036820 
	ldrh r0, [r7,#0x4] // (dword_2036824 - 0x2036820)
	add r7, #8
	ldrh r1, [r7,#0x4] // (dword_203682C - 0x2036828)
	orr r0, r1
	mov r1, #1
	tst r0, r1
	beq loc_802BF34
	ldrb r0, [r5,#0xc]
	cmp r0, #1
	ble loc_802BF28
	mov r0, #0xc
	b loc_802BF2A
loc_802BF28:
	mov r0, #4
loc_802BF2A:
	strh r0, [r5,#2]
	mov r0, #0
	bl sub_802C810
	b locret_802BF44
loc_802BF34:
	mov r7, r10
	ldr r7, [r7,#oToolkit_CurFramePtr]
	ldrh r0, [r7]
	mov r1, #8
	and r0, r1
	lsr r0, r0, #3
	bl sub_802C810
locret_802BF44:
	pop {pc}
	.balign 4, 0
off_802BF48:
	.word dword_2036820
	thumb_func_end battle_pickObjectAnimState_802BF0C

// symdb: Dispatches a battle-object behavior update to one of three handlers selected by a per-object state byte at [R5+3].
// symdb: void sub_802BF4C(void);   // in: R5=object pointer, R2/R4/R6/R7/R10=scratch; out: r0..r4,lr
// symdb: clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/dispatchBattleObjectBehavior_802BF4C.yaml
	thumb_local_start
dispatchBattleObjectBehavior_802BF4C:
	push {lr}
	ldr r1, off_802BF5C // =off_802BF60 
	ldrb r0, [r5,#3]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
off_802BF5C:
	.word off_802BF60
off_802BF60:
	.word setupChipListVisual_802BF6C+1
	.word sub_802C044+1
	.word sub_802C0A4+1
	thumb_func_end dispatchBattleObjectBehavior_802BF4C

// symdb: Refills and shuffles the 42-slot chip pool, then queues tile+palette image transfers for a chip or soul preview based on the packed id stored in the caller struct.
// symdb: void sub_802BF6C(u32 toolkit /* r5 */) -> /* r7: chip data ptr or pool base */; r0=4, NZ set
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/setupChipListVisual_802BF6C.yaml
	thumb_local_start
setupChipListVisual_802BF6C:
	push {lr}
	mov r0, #0
	ldr r7, off_802C01C // =unk_2035320 
loc_802BF72:
	strb r0, [r7,r0]
	add r0, #1
	cmp r0, #0x2a 
	bmi loc_802BF72
	mov r0, r7
	mov r1, #0x2a 
	mov r2, #0x2a 
	bl ShuffleByteList_PrimaryRNG
	ldrh r0, [r5,#0x10]
	ldr r1, dword_802C040 // =0xffff 
	cmp r0, r1
	beq loc_802BFC0
	bl decodePackedIdFields_802C54C
	tst r0, r0
	bne loc_802BFA2
	// idx
	mov r0, r1
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r7, r0
	ldr r0, [r7,#0x24]
	ldr r1, [r7,#0x28]
	b loc_802BFE4
loc_802BFA2:
	cmp r0, #1
	bne loc_802BFAC
	ldr r0, off_802C014 // =dword_8732E54 
	ldr r1, off_802C018 // =dword_8733394 
	b loc_802BFE4
loc_802BFAC:
	cmp r0, #2
	bne loc_802BFC0
	tst r1, r1
	beq loc_802BFBA
	ldr r0, off_802C020 // =dword_87333B4 
	ldr r1, off_802C024 // =dword_87338F4 
	b loc_802BFE4
loc_802BFBA:
	ldr r0, off_802C028 // =dword_8733914 
	ldr r1, off_802C02C // =dword_8733E54 
	b loc_802BFE4
loc_802BFC0:
	cmp r0, #3
	bne loc_802BFE0
	mov r2, #0
	cmp r1, #1
	ble loc_802BFD8
	mov r2, #0x20 
	cmp r1, #2
	ble loc_802BFD8
	mov r2, #0x40 
	cmp r1, #3
	ble loc_802BFD8
	mov r2, #0x60 
loc_802BFD8:
	ldr r0, off_802C03C // =dword_87343F4 
	ldr r1, off_802C038 // =dword_8734934 
	add r1, r1, r2
	b loc_802BFE4
loc_802BFE0:
	ldr r0, off_802C030 // =dword_8733E74 
	ldr r1, off_802C034 // =dword_87343B4 
loc_802BFE4:
	push {r5}
	push {r1}
	ldr r1, dword_802C00C // =0x600bd00 
	mov r2, #0x2a 
	lsl r2, r2, #6
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r1}
	mov r0, r1
	ldr r1, off_802C010 // =unk_3001AE0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r5}
	mov r0, #0
	strb r0, [r5,#0xb]
	mov r0, #4
	strb r0, [r5,#3]
	pop {pc}
	.balign 4, 0
dword_802C00C:
	.word 0x600BD00
off_802C010:
	.word unk_3001AE0
off_802C014:
	.word dword_8732E54
off_802C018:
	.word dword_8733394
off_802C01C:
	.word unk_2035320
off_802C020:
	.word dword_87333B4
off_802C024:
	.word dword_87338F4
off_802C028:
	.word dword_8733914
off_802C02C:
	.word dword_8733E54
off_802C030:
	.word dword_8733E74
off_802C034:
	.word dword_87343B4
off_802C038:
	.word dword_8734934
off_802C03C:
	.word dword_87343F4
dword_802C040:
	.word 0xFFFF
	thumb_func_end setupChipListVisual_802BF6C

	thumb_local_start
sub_802C044:
	push {lr}
	sub sp, sp, #0x74
	mov r6, sp
	add r0, r6, #4
	bl sub_802C588
	ldrb r0, [r5,#0xb]
	cmp r0, #0x2a 
	bmi loc_802C060
	mov r0, #8
	strb r0, [r5,#3]
	mov r0, #0x1e
	strb r0, [r5,#0xb]
	b loc_802C09A
loc_802C060:
	push {r0,r5}
	ldr r7, off_802C0A0 // =unk_2035320 
	ldrb r0, [r7,r0]
	lsl r1, r0, #1
	add r1, #4
	ldrh r1, [r6,r1]
	strh r1, [r6]
	mov r1, #7
	svc 6
	mov r2, r0
	mov r0, r1
	mov r1, r2
	add r0, #0xe
	add r1, #0xa
	mov r2, r6
	mov r3, #1
	mov r4, #1
	bl blitTileBlockToRowBuffer_802C4B6
	pop {r0,r5}
	add r0, #1
	strb r0, [r5,#0xb]
	mov r1, #3
	and r0, r1
	cmp r0, #3
	bne loc_802C09A
	mov r0, #SOUND_UNK_7E
	bl PlaySoundEffect
loc_802C09A:
	add sp, sp, #0x74
	pop {pc}
	.balign 4, 0
off_802C0A0:
	.word unk_2035320
	thumb_func_end sub_802C044

	thumb_local_start
sub_802C0A4:
	push {lr}
	ldrb r0, [r5,#0xb]
	sub r0, #1
	strb r0, [r5,#0xb]
	bne locret_802C160
	ldrh r0, [r5,#0x10]
	ldr r1, dword_802C164 // =0xffff 
	cmp r0, r1
	beq loc_802C15C
	bl decodePackedIdFields_802C54C
	tst r0, r0
	bne loc_802C114
	// idx
	mov r0, r1
	mov r1, r2
	mov r2, #1
	push {r0,r1}
	ldrb r3, [r5,#4]
	cmp r3, #2
	beq loc_802C106
	push {r0-r2,r4,r6,r7}
	mov r4, r1
	ldr r1, dword_802C16C // =0x136 
	cmp r0, r1
	bgt loc_802C0E2
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldr r1, [r0]
	ldr r2, dword_802C168 // =0xffffffff 
	cmp r1, r2
	bne loc_802C0E6
loc_802C0E2:
	pop {r0-r2,r4,r6,r7}
	b loc_802C106
loc_802C0E6:
	ldrb r1, [r0]
	cmp r1, r4
	beq loc_802C0FE
	ldrb r1, [r0,#1]
	cmp r1, r4
	beq loc_802C0FE
	ldrb r1, [r0,#2]
	cmp r1, r4
	beq loc_802C0FE
	ldrb r1, [r0,#3]
	cmp r1, r4
	bne loc_802C0E2
loc_802C0FE:
	pop {r0-r2,r4,r6,r7}
	push {r0}
	pop {r0}
	b loc_802C106
loc_802C106:
	pop {r0,r1}
	bl sub_802C75C
	mov r0, #0x96
	bl PlaySoundEffect
	b loc_802C15C
loc_802C114:
	cmp r0, #1
	bne loc_802C12A
	mov r0, r1
	push {r0}
	pop {r0}
	bl textWindow_openDialog_802C5B0
	mov r0, #0x95
	bl PlaySoundEffect
	b loc_802C15C
loc_802C12A:
	cmp r0, #2
	bne loc_802C148
	mov r0, r1
	bl sub_802C646
	mov r0, #0x95
	bl PlaySoundEffect
	mov r0, #0x1e
	strb r0, [r5,#0xb]
	mov r0, #8
	strb r0, [r5,#2]
	mov r0, #0
	strb r0, [r5,#3]
	b locret_802C160
loc_802C148:
	cmp r0, #3
	bne loc_802C15C
	mov r0, r1
	push {r0}
	pop {r0}
	bl sub_802C5E6
	mov r0, #0x95
	bl PlaySoundEffect
loc_802C15C:
	mov r0, #0
	strh r0, [r5,#2]
locret_802C160:
	pop {pc}
	.balign 4, 0
dword_802C164:
	.word 0xFFFF
dword_802C168:
	.word 0xFFFFFFFF
dword_802C16C:
	.word 0x136
	thumb_func_end sub_802C0A4

	thumb_local_start
sub_802C170:
	push {lr}
	ldrb r0, [r5,#3]
	tst r0, r0
	bne loc_802C1B8
	ldrb r0, [r5,#0xb]
	sub r0, #1
	strb r0, [r5,#0xb]
	bne locret_802C1CC
	ldrh r0, [r5,#0x10]
	bl decodePackedIdFields_802C54C
	mov r0, r1
	push {r0,r5}
	mov r7, r10
	ldr r7, [r7,#oToolkit_BattleStatePtr]
	push {r0}
	bl battle_preUpdateAndGetPlayerObject_80103EC
	mov r5, r0
	pop {r0}
	tst r0, r0
	bne loc_802C1A2
	ldrh r0, [r5,#oBattleObject_MaxHP]
	strh r0, [r5,#oBattleObject_HP]
	b loc_802C1A6
loc_802C1A2:
	bl object_addHP
loc_802C1A6:
	mov r0, #SOUND_UNK_8A
	bl PlaySoundEffect
	ldrh r0, [r5,#oBattleObject_HP]
	strh r0, [r7,#oBattleState_Unk_34]
	pop {r0,r5}
	mov r0, #4
	strb r0, [r5,#3]
	b locret_802C1CC
loc_802C1B8:
	ldr r7, [r5,#0x18]
	ldrh r0, [r7,#4]
	add r7, #8
	ldrh r1, [r7,#4]
	orr r0, r1
	mov r1, #9
	tst r0, r1
	beq loc_802C1C8
loc_802C1C8:
	mov r0, #0
	strh r0, [r5,#2]
locret_802C1CC:
	pop {pc}
	.byte 0, 0
	.word eStruct2035280
	thumb_func_end sub_802C170

// symdb: Tiny tail-call dispatcher that jumps to one of two per-object handler routines chosen by a state byte stored in the object, passing the caller straight through.
// symdb: Next runObjectStateHandler(Object *obj /* R5 */) — reads obj->state (byte at +3), calls
// symdb: table[obj->state] with R0=obj->state, R1=handler address, LR=address of the following `pop
// symdb: {pc}`; NZCV and R0-R12/LR return whatever the chosen handler leaves in them.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/runObjectStateHandler_802C1D4.yaml
	thumb_local_start
runObjectStateHandler_802C1D4:
	push {lr}
	ldr r1, off_802C1E4 // =off_802C1E8 
	ldrb r0, [r5,#3]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
off_802C1E4:
	.word off_802C1E8
off_802C1E8:
	.word initShuffledOrderTable42_802C1F0+1
	.word sub_802C218+1
	thumb_func_end runObjectStateHandler_802C1D4

// symdb: Fills the 0x2A-byte table at unk_2035320 with values 0..0x29, shuffles it into a random order with the primary RNG, and resets the progress fields of the associated state struct.
// symdb: void sub_802C1F0(State* state /* r5 */, void* r4, void* r6); // r4/r6 passed through by callers
// symdb: but unused here; returns NZ (and C/V) from the constant 4 written to state->field3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/initShuffledOrderTable42_802C1F0.yaml
	thumb_local_start
initShuffledOrderTable42_802C1F0:
	push {lr}
	mov r0, #0
	ldr r7, off_802C214 // =unk_2035320 
loc_802C1F6:
	strb r0, [r7,r0]
	add r0, #1
	cmp r0, #0x2a 
	bmi loc_802C1F6
	mov r0, r7
	mov r1, #0x2a 
	mov r2, #0x2a 
	bl ShuffleByteList_PrimaryRNG
	mov r0, #0
	strb r0, [r5,#0xb]
	mov r0, #4
	strb r0, [r5,#3]
	pop {pc}
	.balign 4, 0
off_802C214:
	.word unk_2035320
	thumb_func_end initShuffledOrderTable42_802C1F0

// symdb: Chip Folder screen opening: wipe the row buffer, draw the 7x6 folder window, then advance the screen object to its next state and seed its frame timer.
// symdb: void sub_802C218(struct ChipFolderScreen* r5); // returns r5 unchanged; preserves r5, r7;
// symdb: clobbers r0-r4, r6, nzcv, lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802C218.yaml
	thumb_local_start
sub_802C218:
	push {lr}
	sub sp, sp, #0x74
	mov r6, sp
	add r0, r6, #4
	bl chipFolder_ClearTilemapArea_802C59C
	b loc_802C22C
	ldrb r0, [r5,#0xb]
	cmp r0, #0x2a 
	bmi loc_802C244
loc_802C22C:
	mov r0, #0xe
	mov r1, #0xa
	add r2, r6, #4
	mov r3, #7
	mov r4, #6
	bl blitTileBlockToRowBuffer_802C4B6
	mov r0, #4
	strh r0, [r5,#2]
	mov r0, #0x1e
	strb r0, [r5,#0xb]
	b loc_802C278
loc_802C244:
	push {r0,r5}
	ldr r7, off_802C27C // =unk_2035320 
	ldrb r0, [r7,r0]
	lsl r1, r0, #1
	add r1, #4
	ldrh r1, [r6,r1]
	strh r1, [r6]
	mov r1, #7
	svc 6
	mov r2, r0
	mov r0, r1
	mov r1, r2
	add r0, #0xe
	add r1, #9
	mov r2, r6
	mov r3, #1
	mov r4, #1
	bl blitTileBlockToRowBuffer_802C4B6
	pop {r0,r5}
	add r0, #1
	strb r0, [r5,#0xb]
	mov r1, #3
	and r0, r1
	cmp r0, #3
	bne loc_802C278
loc_802C278:
	add sp, sp, #0x74
	pop {pc}
	.balign 4, 0
off_802C27C:
	.word unk_2035320
	thumb_func_end sub_802C218

	thumb_local_start
sub_802C280:
	push {lr}
	ldrb r0, [r5,#3]
	tst r0, r0
	bne loc_802C2A2
	ldr r7, off_802C2CC // =dword_2036820 
	ldrh r0, [r7,#0x4] // (dword_2036824 - 0x2036820)
	add r7, #8
	ldrh r1, [r7,#0x4] // (dword_203682C - 0x2036828)
	orr r0, r1
	mov r1, #9
	tst r0, r1
	beq locret_802C2C8
	mov r0, #0x14
	strb r0, [r5,#0xb]
	mov r0, #4
	strb r0, [r5,#3]
	b locret_802C2C8
loc_802C2A2:
	ldrb r0, [r5,#0xb]
	sub r0, #1
	strb r0, [r5,#0xb]
	bne locret_802C2C8
	mov r0, #0
	mov r1, #0xa
	bl table_GetByte16Row_203EAE0_800AB3A
	cmp r0, #0
	beq loc_802C2C0
	mov r0, #0xc
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	b loc_802C4B2
loc_802C2C0:
	mov r0, #0x10
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_802C2C8:
	pop {pc}
	.balign 4, 0
off_802C2CC:
	.word dword_2036820
	thumb_func_end sub_802C280

	thumb_local_start
sub_802C2D0:
	push {lr}
	ldrb r0, [r5,#2]
	cmp r0, #1
	beq loc_802C2FA
	mov r1, #6
	ldrsb r0, [r5,r1]
	add r0, #2
	strb r0, [r5,#6]
	cmp r0, #0x1e
	blt locret_802C320
	mov r0, #0
	mov r1, #0xa
	bl table_GetByte16Row_203EAE0_800AB3A
	mov r1, r0
	ldr r0, off_802C324 // =TextScriptYouGotNewVirusData
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	mov r0, #1
	strb r0, [r5,#2]
	b locret_802C320
loc_802C2FA:
	push {r5}
	mov r0, #0x1d
	mov r1, #2
	mov r2, #3
	mov r3, #0
	mov r4, #1
	mov r5, #0x12
	bl call_sub_3005EBA
	pop {r5}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	cmp r0, #0
	bne locret_802C320
	mov r0, #0x10
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_802C320:
	pop {pc}
	.balign 4, 0
off_802C324:
	.word TextScriptYouGotNewVirusData
	thumb_func_end sub_802C2D0

// symdb: Advances a battle state object's screen-fade: kicks off the fade if not yet started, polls liveness, and parks the object in state 8 while the fade is still in progress.
// symdb: void Next(u32* battle_obj /* r5 */);   // kicks SetScreenFade(0xC, 0x10) on first entry (byte
// symdb: @+3 == 0),   // then on every call reads IsScreenFadeActive(); while Z clear   // (still fading)
// symdb: writes 8 to battle_obj[0] and yields 8, else   // yields whatever r0 the liveness check
// symdb: produced.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_advanceFade_802C328.yaml
	thumb_local_start
battle_advanceFade_802C328:
	push {lr}
	ldrb r0, [r5,#3]
	tst r0, r0
	bne loc_802C33C
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #4
	strb r0, [r5,#3]
loc_802C33C:
	bl IsScreenFadeActive // () -> zf
	beq locret_802C346
	mov r0, #8
	str r0, [r5]
locret_802C346:
	pop {pc}
	thumb_func_end battle_advanceFade_802C328

// symdb: Zeroes a single state byte at offset 5 of a struct passed in r5 and returns 0 with flags set.
// symdb: void sub_802C348(void* r5); // clears *(u8*)(r5+5); returns r0 = 0 with NZ flags set
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802C348.yaml
	thumb_local_start
sub_802C348:
	mov r0, #0
	strb r0, [r5,#5]
	mov pc, lr
	thumb_func_end sub_802C348

// symdb: Sets up the battle result screen: copies the 12-byte result record (r0 = unk_2035260, record battle state +0x0D) into eS20364C0 (reward at +0x14 = 0x020364D4), passes the reward to eStruct200A008 (+4, the reward given), and queues the screen's graphics, the PET navi's included.
// symdb: void setupNaviDisplay_802C34E(u32 r0 /*naviAttributeBase*/, u32 r10 /*toolkit*/, int /*lr*/);
// symdb: preserves r4-r7; clobbers r0-r3, NZCV, lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/setupNaviDisplay_802C34E.yaml
	thumb_func_start setupNaviDisplay_802C34E
setupNaviDisplay_802C34E:
	push {r4-r7,lr}
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r1, [r1,#oBattleState_Unk_0d]
	mov r2, #0xc
	mul r1, r2
	add r0, r0, r1
	mov r4, r0
	ldr r0, off_802C3F4 // =eS20364C0 
	mov r7, r0
	mov r1, #0x20 
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()
	ldrb r0, [r4]
	strb r0, [r7,#0x4] // (dword_20364C4 - 0x20364c0)
	ldrb r0, [r4,#1]
	strb r0, [r7,#0x8] // (byte_20364C8 - 0x20364c0)
	ldrb r0, [r4,#3]
	strb r0, [r7,#0xd] // (byte_20364CD - 0x20364c0)
	ldr r0, [r4,#4]
	str r0, [r7,#0x1c] // (dword_20364DC - 0x20364c0)
	ldr r0, [r4,#8]
	str r0, [r7,#0x14] // (unk_20364D4 - 0x20364c0)
	ldrh r0, [r7,#0x14] // (unk_20364D4 - 0x20364c0)
	bl eStruct200A008_setUnk04
	ldrh r0, [r7,#0x16] // (word_20364D6 - 0x20364c0)
	bl eStruct200A008_setUnk06
	mov r1, #0xe2
	strb r1, [r7,#0x6] // (dword_20364C4+2 - 0x20364c0)
	ldrb r0, [r7,#0x4] // (dword_20364C4 - 0x20364c0)
	ldr r6, off_802C430 // =off_802C434 
	lsl r1, r0, #2
	ldr r0, [r6,r1]
	ldr r1, off_802C440 // =unk_2034B30 
	mov r2, #0x36 
	lsl r2, r2, #4
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	ldrb r0, [r7,#0x4] // (dword_20364C4 - 0x20364c0)
	ldr r7, off_802C3F8 // =off_802C3FC 
	mov r1, #0xc
	mul r1, r0
	add r7, r7, r1
	ldr r0, [r7]
	ldr r1, [r7,#4]
	ldr r2, [r7,#8]
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r0, #0
	mov r1, #0x60 
	mul r0, r1
	ldr r7, off_802C420 // =off_802C424 
	ldr r1, [r7]
	add r0, r0, r1
	ldr r1, [r7,#0x4] // (off_802C428 - 0x802c424)
	ldr r2, [r7,#0x8] // (off_802C42C - 0x802c424)
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	ldr r7, off_802C444 // =off_802C448 
	ldr r0, [r7]
	ldr r1, [r7,#0x4] // (dword_802C44C - 0x802c448)
	ldr r2, [r7,#0x8] // (off_802C450 - 0x802c448)
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	bl GetCurPETNavi // () -> u8
	bl getIndexed80hRecordPtr_8028164
	ldr r1, dword_802C458 // =0x6014000 
	mov r2, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	bl GetCurPETNavi // () -> u8
	bl getPermutedRecord32_8028172
	ldr r1, off_802C45C // =byte_30016B0 
	mov r2, #0x20 
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_802C3F4:
	.word eS20364C0
off_802C3F8:
	.word off_802C3FC
off_802C3FC:
	.word byte_872F3F4
	.word 0x6008020
	.word 0xE60
	.word byte_8730254
	.word 0x6008020
	.word 0xF00
	.word dword_8731154
	.word 0x6008020
	.word 0xCA0
off_802C420:
	.word off_802C424
off_802C424:
	.word dword_8732814
off_802C428:
	.word unk_3001A80
off_802C42C:
	.word 0x60
off_802C430:
	.word off_802C434
off_802C434:
	.word dword_8731DF4
	.word dword_8732154
	.word dword_87324B4
off_802C440:
	.word unk_2034B30
off_802C444:
	.word off_802C448
off_802C448:
	.word dword_8732874
dword_802C44C:
	.word 0x6009400
off_802C450:
	.word 0x5E0
	.word 0xFFFF
dword_802C458:
	.word 0x6014000
off_802C45C:
	.word byte_30016B0
	thumb_func_end setupNaviDisplay_802C34E

// symdb: Reads two byte positions from an object, scans the span between them (via sub_802C490), and if something is found along the way raises a type-3 notification.
// symdb: void scanSpanBetween(Object* obj) — object pointer passed in r5; r4, r6, r7, r10 are inputs the
// symdb: callee must preserve; returns nothing meaningful, but c/v and r1-r3 are left as side effects of
// symdb: the early-out CMP and the callees.
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802C460.yaml
	thumb_local_start
sub_802C460:
	push {r4,r5,lr}
	mov r0, #6
	ldrsb r0, [r5,r0]
	mov r1, #7
	ldrsb r1, [r5,r1]
	cmp r0, r1
	beq locret_802C48E
	bgt loc_802C476
	sub r4, r1, r0
	add r0, #0x18
	b loc_802C47A
loc_802C476:
	sub r4, r0, r1
	mov r0, r1
loc_802C47A:
	mov r1, #2
	mov r5, #0x12
	bl sub_802C490
	tst r2, r2
	beq locret_802C48E
	mov r2, #3
	mov r3, #0
	bl call_sub_3005EBA
locret_802C48E:
	pop {r4,r5,pc}
	thumb_func_end sub_802C460

	thumb_local_start
sub_802C490:
	push {r6,lr}
	mov r6, #0
	add r2, r0, r4
	cmp r0, #0x1d
	bgt loc_802C4B2
	cmp r0, #0
	bge loc_802C4A0
	mov r0, #0
loc_802C4A0:
	cmp r2, #0
	blt loc_802C4B2
	cmp r2, #0x1d
	ble loc_802C4AA
	mov r2, #0x1d
loc_802C4AA:
	sub r4, r2, r0
	tst r4, r4
	beq loc_802C4B2
	mov r6, #1
loc_802C4B2:
	mov r2, r6
	pop {r6,pc}
	thumb_func_end sub_802C490

// symdb: Blits a width x height block of halfwords (e.g. a tilemap slice) into the 24-halfword-wide buffer at unk_2034B30 at a given x/y offset.
// symdb: void sub_802C4B6(u32 x /*r0*/, u32 y /*r1*/, const u16* src /*r2*/, u32 width /*r3*/, u32 height
// symdb: /*r4*/); clobbers r0-r2 (r0=width, r1=height, r2=one past src end), sets flags from final cmp
// symdb: r1, r4
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/blitTileBlockToRowBuffer_802C4B6.yaml
	thumb_local_start
blitTileBlockToRowBuffer_802C4B6:
	push {r5-r7,lr}
	ldr r7, off_802C4E4 // =unk_2034B30 
	mov r5, #0x18
	mul r1, r5
	add r0, r0, r1
	add r0, r0, r0
	add r7, r7, r0
	mov r5, r7
	mov r1, #0
loc_802C4C8:
	mov r0, #0
loc_802C4CA:
	ldrh r6, [r2]
	strh r6, [r7]
	add r7, #2
	add r2, #2
	add r0, #1
	cmp r0, r3
	bne loc_802C4CA
	add r5, #0x30 
	mov r7, r5
	add r1, #1
	cmp r1, r4
	bne loc_802C4C8
	pop {r5-r7,pc}
	.balign 4, 0
off_802C4E4:
	.word unk_2034B30
	thumb_func_end blitTileBlockToRowBuffer_802C4B6

// symdb: draws a time value as a five-digit M'SS"CC timer on the battle BG using tiles starting at 0xA0 and palette (palette + 9), capped at 9'59"99
// symdb: u32 time in r0, u32 palette in r1; returns r5 preserved, r6/r7 left pointing at the digit
// symdb: x-table and a stack slot for callers
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802C4E8.yaml
	thumb_local_start
sub_802C4E8:
	push {r5,lr}
	sub sp, sp, #4
	mov r6, sp
	push {r1}
	bl memory_bcd_8000D84
	ldr r1, dword_802C548 // =0x95999 
	cmp r0, r1
	ble loc_802C4FC
	mov r0, r1
loc_802C4FC:
	pop {r1}
	add r1, #9
	lsl r1, r1, #0xc
	ldr r4, off_802C544 // =0xa0 
	orr r4, r1
	mov r3, #0
	ldr r7, off_802C540 // =byte_802C538
loc_802C50A:
	mov r1, #0xf
	and r1, r0
	add r1, r1, r1
	mov r2, r4
	add r2, r2, r1
	strh r2, [r6]
	add r2, #1
	strh r2, [r6,#2]
	push {r0,r3,r4,r6,r7}
	ldrb r0, [r7,r3]
	mov r1, #4
	mov r2, r6
	mov r3, #1
	mov r4, #2
	bl blitTileBlockToRowBuffer_802C4B6
	pop {r0,r3,r4,r6,r7}
	lsr r0, r0, #4
	add r3, #1
	cmp r3, #5
	bmi loc_802C50A
	add sp, sp, #4
	pop {r5,pc}
	.balign 4, 0
byte_802C538:
	.byte 0x14, 0x13, 0x11, 0x10, 0xE, 0x0, 0x0, 0x0
off_802C540:
	.word byte_802C538
off_802C544:
	.word 0xA0
dword_802C548:
	.word 0x95999
	thumb_func_end sub_802C4E8

// symdb: Decodes a packed 16-bit ID into a 2-bit group plus index/sub-index fields, treating 0xFFFF as a 'none' sentinel.
// symdb: Next sub_802C54C(u32 packedId) /* r0 in: packed id; r0 out: group (0-3, or 0xFF for sentinel),
// symdb: r1 out: low field, r2 out: middle field (group 0 only); clobbers nzcv */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/decodePackedIdFields_802C54C.yaml
	thumb_local_start
decodePackedIdFields_802C54C:
	ldr r1, dword_802C584 // =0xffff 
	cmp r0, r1
	beq loc_802C580
	lsr r1, r0, #0xe
	bne loc_802C560
	lsr r2, r0, #9
	lsl r1, r0, #0x17
	lsr r1, r1, #0x17
	mov r0, #0
	b locret_802C582
loc_802C560:
	cmp r1, #1
	bne loc_802C56C
	lsl r1, r0, #0x12
	lsr r1, r1, #0x12
	mov r0, #1
	b locret_802C582
loc_802C56C:
	cmp r1, #2
	bne loc_802C578
	lsl r1, r0, #0x12
	lsr r1, r1, #0x12
	mov r0, #2
	b locret_802C582
loc_802C578:
	lsl r1, r0, #0x12
	lsr r1, r1, #0x12
	mov r0, #3
	b locret_802C582
loc_802C580:
	mov r0, #0xff
locret_802C582:
	mov pc, lr
	.balign 4, 0
dword_802C584:
	.word 0xFFFF
	thumb_func_end decodePackedIdFields_802C54C

// symdb: Writes 42 consecutive halfword values (0xC1E8..0xC211) to memory at r0, most plausibly the tile-index field of a run of OAM entries for one large sprite/animation frame.
// symdb: void sprite_FillConsecutiveTileIndices(u16 *dst /*r0*/); returns with r0 = dst+0x54 (past the
// symdb: filled range), r1 = 0xC212 (one past last value written), r2 = 0 (exhausted counter); clobbers
// symdb: flags, preserves nothing
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802C588.yaml
	thumb_local_start
sub_802C588:
	ldr r1, dword_802C598 // =0xc1e8 
	mov r2, #0x2a 
loc_802C58C:
	strh r1, [r0]
	add r1, #1
	add r0, #2
	sub r2, #1
	bne loc_802C58C
	mov pc, lr
	.balign 4, 0
dword_802C598:
	.word 0xC1E8
	thumb_func_end sub_802C588

// symdb: Fills a 42-halfword tilemap region (e.g. the chip folder screen) with the blank tile entry 0x90C6.
// symdb: void sub_802C59C(u16 *dst /* r0 */); clobbers r0-r2 and NZCV flags, returns via lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chipFolder_ClearTilemapArea_802C59C.yaml
	thumb_local_start
chipFolder_ClearTilemapArea_802C59C:
	ldr r1, dword_802C5AC // =0x90c6 
	mov r2, #0x2a 
loc_802C5A0:
	strh r1, [r0]
	add r0, #2
	sub r2, #1
	bne loc_802C5A0
	mov pc, lr
	.balign 4, 0
dword_802C5AC:
	.word 0x90C6
	thumb_func_end chipFolder_ClearTilemapArea_802C59C

// symdb: Opens an in-game text/dialog window — records the caller's value in the toolkit state struct, blits the window's text graphics to VRAM, and queues the window's tilemap/draw update job.
// symdb: (r0 = value to record) -> r1, r2 (and r3) = results of the queued draw job; r4-r9 preserved;
// symdb: flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/textWindow_openDialog_802C5B0.yaml
	thumb_local_start
textWindow_openDialog_802C5B0:
	push {r4-r7,lr}
	sub sp, sp, #0x70
	mov r6, sp
	mov r7, r10
	ldr r7, [r7,#oToolkit_Unk200a220_Ptr]
	str r0, [r7,#8]
	push {r6}
	ldr r0, off_802C6AC // =TextScript8736D74
	mov r1, #5
	ldr r2, off_802C6A8 // =unk_2035320 
	ldr r3, dword_802C6B4 // =0x600ba80 
	mov r4, #0xa
	mov r5, #1
	ldr r6, off_802C6B0 // =dword_86B7AE0 
	mov r7, #8
	bl renderTextGfx_8045F8C
	mov r0, #2
	mov r1, #0xc
	ldr r2, off_802C6C0 // =byte_802C6C4
	mov r3, #0xa
	mov r4, #2
	bl blitTileBlockToRowBuffer_802C4B6
	pop {r6}
	add sp, sp, #0x70
	pop {r4-r7,pc}
	thumb_func_end textWindow_openDialog_802C5B0

	thumb_local_start
sub_802C5E6:
	push {r5,lr}
	sub sp, sp, #8
	tst r0, r0
	bne loc_802C5F4
	mov r0, #4
	str r0, [sp,#4]
	b loc_802C61C
loc_802C5F4:
	str r0, [sp]
	bl memory_bcdConvert
	bl countHexDigits_8000C5C
	str r0, [sp,#4]
	ldr r0, [sp]
	mov r7, r10
	ldr r7, [r7,#oToolkit_Unk200a220_Ptr]
	str r0, [r7,#8]
	ldr r0, off_802C6AC // =TextScript8736D74
	mov r1, #6
	ldr r2, off_802C6BC // =unk_20354E0 
	ldr r3, dword_802C6B8 // =0x600bc40 
	mov r4, #3
	mov r5, #1
	ldr r6, off_802C6B0 // =dword_86B7AE0 
	mov r7, #8
	bl renderTextGfx_8045F8C
loc_802C61C:
	ldr r0, [sp,#4]
	mov r1, #1
	ldr r2, off_802C6A8 // =unk_2035320 
	ldr r3, dword_802C6B4 // =0x600ba80 
	mov r4, #0xa
	sub r4, r4, r0
	mov r5, #1
	ldr r6, off_802C6B0 // =dword_86B7AE0 
	mov r7, #8
	ldr r0, off_802C6AC // =TextScript8736D74
	bl renderTextGfx_8045F8C
	mov r0, #2
	mov r1, #0xc
	ldr r2, off_802C6C0 // =byte_802C6C4
	mov r3, #0xa
	mov r4, #2
	bl blitTileBlockToRowBuffer_802C4B6
	add sp, sp, #8
	pop {r5,pc}
	thumb_func_end sub_802C5E6

	thumb_local_start
sub_802C646:
	push {r5,lr}
	sub sp, sp, #8
	tst r0, r0
	bne loc_802C654
	mov r0, #4
	str r0, [sp,#4]
	b loc_802C67C
loc_802C654:
	str r0, [sp]
	bl memory_bcdConvert
	bl countHexDigits_8000C5C
	str r0, [sp,#4]
	ldr r0, [sp]
	mov r7, r10
	ldr r7, [r7,#oToolkit_Unk200a220_Ptr]
	str r0, [r7,#8]
	ldr r0, off_802C6AC // =TextScript8736D74
	mov r1, #6
	ldr r2, off_802C6BC // =unk_20354E0 
	ldr r3, dword_802C6B8 // =0x600bc40 
	mov r4, #3
	mov r5, #1
	ldr r6, off_802C6B0 // =dword_86B7AE0 
	mov r7, #8
	bl renderTextGfx_8045F8C
loc_802C67C:
	ldr r0, [sp,#4]
	add r1, r0, #6
	ldr r2, off_802C6A8 // =unk_2035320 
	ldr r3, dword_802C6B4 // =0x600ba80 
	mov r4, #0xa
	sub r4, r4, r0
	mov r5, #1
	ldr r6, off_802C6B0 // =dword_86B7AE0 
	mov r7, #8
	ldr r0, off_802C6AC // =TextScript8736D74
	bl renderTextGfx_8045F8C
	mov r0, #2
	mov r1, #0xc
	ldr r2, off_802C6C0 // =byte_802C6C4
	mov r3, #0xa
	mov r4, #2
	bl blitTileBlockToRowBuffer_802C4B6
	add sp, sp, #8
	pop {r5,pc}
	.balign 4, 0
off_802C6A8:
	.word unk_2035320
off_802C6AC:
	.word TextScript8736D74
off_802C6B0:
	.word dword_86B7AE0
dword_802C6B4:
	.word 0x600BA80
dword_802C6B8:
	.word 0x600BC40
off_802C6BC:
	.word unk_20354E0
off_802C6C0:
	.word byte_802C6C4
byte_802C6C4:
	.byte 0xD4, 0x91, 0xD6, 0x91, 0xD8, 0x91, 0xDA, 0x91, 0xDC
	.byte 0x91, 0xDE, 0x91, 0xE0, 0x91, 0xE2, 0x91, 0xE4, 0x91
	.byte 0xE6, 0x91, 0xD5, 0x91, 0xD7, 0x91, 0xD9, 0x91, 0xDB
	.byte 0x91, 0xDD, 0x91, 0xDF, 0x91, 0xE1, 0x91, 0xE3, 0x91
	.byte 0xE5, 0x91, 0xE7, 0x91
	thumb_func_end sub_802C646

// symdb: Renders a 0-11 counter value as digit glyphs (values over 10 clamped and shown as a single special "11" glyph) and blits it into a UI row buffer.
// symdb: void sub_802C6EC(u32 value /* r0, 0..11 */); callers see r5-r7 back but these are incidental (r7
// symdb: is whatever blitTileBlockToRowBuffer_802C4B6 leaves), r4 preserved, flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802C6EC.yaml
	thumb_local_start
sub_802C6EC:
	push {r4-r6,lr}
	sub sp, sp, #0x1c
	cmp r0, #0xb
	ble loc_802C6F6
	mov r0, #0xb
loc_802C6F6:
	str r0, [sp,#0x14]
	ldr r0, dword_802C758 // =0x90a0 
	add r0, #0x14
	mov r3, #5
	add r2, sp, #0
loc_802C700:
	strh r0, [r2]
	add r1, r0, #1
	strh r1, [r2,#0xa]
	add r2, #2
	sub r3, #1
	bgt loc_802C700
	mov r4, #8
	add r4, sp
	ldr r6, dword_802C758 // =0x90a0 
	ldr r0, [sp,#0x14]
	cmp r0, #0xb
	blt loc_802C724
	mov r1, #1
	lsl r1, r1, #0xc
	add r6, r6, r1
	mov r5, #0xb
	mov r0, #1
	b loc_802C72E
loc_802C724:
	bl memory_bcdConvert
	mov r5, r0
	bl countHexDigits_8000C5C
loc_802C72E:
	mov r1, #0xf
	and r1, r5
	add r1, r1, r1
	add r1, r1, r6
	strh r1, [r4]
	add r2, r1, #1
	strh r2, [r4,#0xa]
	lsr r5, r5, #4
	sub r4, #2
	sub r0, #1
	bgt loc_802C72E
	mov r0, #0x10
	mov r1, #6
	add r2, sp, #0
	mov r3, #5
	mov r4, #2
	bl blitTileBlockToRowBuffer_802C4B6
	add sp, sp, #0x1c
	pop {r4-r6,pc}
	.balign 4, 0
dword_802C758:
	.word 0x90A0
	thumb_func_end sub_802C6EC

	thumb_local_start
sub_802C75C:
	push {r5,lr}
	sub sp, sp, #0x70
	mov r6, sp
	push {r0,r1,r6}
	mov r1, #0xff
	and r1, r0
	lsr r0, r0, #8
	lsl r0, r0, #2
	ldr r2, off_802C7C0 // =off_802C7C4 
	ldr r0, [r2,r0]
	ldr r2, off_802C7CC // =unk_2035320 
	ldr r3, dword_802C7D0 // =0x600ba80 
	mov r4, #8
	mov r5, #1
	ldr r6, off_802C7D4 // =dword_86B7AE0 
	mov r7, #8
	bl renderTextGfx_8045F8C
	mov r0, #2
	mov r1, #0xc
	ldr r2, off_802C7E8 // =byte_802C7EC 
	mov r3, #9
	mov r4, #2
	bl blitTileBlockToRowBuffer_802C4B6
	pop {r0,r1,r6}
	push {r0,r1,r6}
	ldr r2, dword_802C7E0 // =0x91e4 
	strh r2, [r6]
	add r2, #1
	strh r2, [r6,#2]
	mov r0, #0xb
	mov r1, #0xc
	mov r2, r6
	mov r3, #1
	mov r4, #2
	bl blitTileBlockToRowBuffer_802C4B6
	pop {r0,r1,r6}
	ldr r0, off_802C7D8 // =TextScript86EF71C 
	ldr r2, off_802C7E4 // =unk_2035520 
	ldr r3, dword_802C7DC // =0x600bc80 
	mov r4, #1
	mov r5, #1
	ldr r6, off_802C7D4 // =dword_86B7AE0 
	mov r7, #8
	bl renderTextGfx_8045F8C
	add sp, sp, #0x70
	pop {r5,pc}
	.balign 4, 0
off_802C7C0:
	.word off_802C7C4
off_802C7C4:
	.word TextScriptChipNames0
	.word TextScriptChipNames1
off_802C7CC:
	.word unk_2035320
dword_802C7D0:
	.word 0x600BA80
off_802C7D4:
	.word dword_86B7AE0
off_802C7D8:
	.word TextScript86EF71C
dword_802C7DC:
	.word 0x600BC80
dword_802C7E0:
	.word 0x91E4
off_802C7E4:
	.word unk_2035520
off_802C7E8:
	.word byte_802C7EC
byte_802C7EC:
	.byte 0xD4, 0x91, 0xD6, 0x91, 0xD8, 0x91, 0xDA, 0x91, 0xDC
	.byte 0x91, 0xDE, 0x91, 0xE0, 0x91, 0xE2, 0x91, 0xC5, 0x90
	.byte 0xD5, 0x91, 0xD7, 0x91, 0xD9, 0x91, 0xDB, 0x91, 0xDD
	.byte 0x91, 0xDF, 0x91, 0xE1, 0x91, 0xE3, 0x91, 0xC5, 0x90
	thumb_func_end sub_802C75C

	thumb_local_start
sub_802C810:
	push {r5,lr}
	ldr r2, off_802C828 // =off_802C82C 
	lsl r0, r0, #2
	ldr r2, [r2,r0]
	mov r0, #2
	mov r1, #0xe
	mov r3, #0xa
	mov r4, #1
	bl blitTileBlockToRowBuffer_802C4B6
	pop {r5,pc}
	.balign 4, 0
off_802C828:
	.word off_802C82C
off_802C82C:
	.word byte_802C834
	.word byte_802C848
byte_802C834:
	.byte 0xC4, 0x90, 0xC4, 0x90, 0xC4, 0x90, 0xC4, 0x90, 0xC4
	.byte 0x90, 0xC4, 0x90, 0xC4, 0x90, 0xC4, 0x90, 0xC4, 0x90
	.byte 0xC4, 0x90
byte_802C848:
	.byte 0xBA, 0x90, 0xBB, 0x90, 0xBC, 0x90, 0xBD, 0x90, 0xBE
	.byte 0x90, 0xBF, 0x90, 0xC0, 0x90, 0xC1, 0x90, 0xC2, 0x90
	.byte 0xC3, 0x90
	thumb_func_end sub_802C810

	thumb_local_start
sub_802C85C:
	push {lr}
	ldrb r0, [r5,#0xf]
	tst r0, r0
	beq locret_802C882
	mov r7, r10
	ldr r7, [r7,#oToolkit_CurFramePtr]
	ldrh r0, [r7]
	mov r1, #0x10
	and r0, r1
	lsr r0, r0, #4
	lsl r0, r0, #2
	ldr r2, off_802C884 // =off_802C888 
	ldr r2, [r2,r0]
	mov r0, #0xa
	mov r1, #4
	mov r3, #4
	mov r4, #2
	bl blitTileBlockToRowBuffer_802C4B6
locret_802C882:
	pop {pc}
	.balign 4, 0
off_802C884:
	.word off_802C888
off_802C888:
	.word byte_802C890
	.word byte_802C8A0
byte_802C890:
	.byte 0xB4, 0x90, 0xB4, 0x90, 0xB4, 0x90, 0xB4, 0x90, 0xB5
	.byte 0x90, 0xB5, 0x90, 0xB5, 0x90, 0xB5, 0x90
byte_802C8A0:
	.byte 0xC7, 0x90, 0xC8, 0x90, 0xC9, 0x90, 0xCA, 0x90, 0xCB
	.byte 0x90, 0xCC, 0x90, 0xCD, 0x90, 0xCE, 0x90
	thumb_func_end sub_802C85C

	thumb_local_start
sub_802C8B0:
	push {lr}
	sub sp, sp, #0xc
	str r0, [sp]
	str r1, [sp,#8]
	bl GetPositiveSignedRNG
	lsr r0, r0, #8
	ldr r1, [sp,#8]
	svc 6
	mov r0, #0
	ldr r7, [sp]
loc_802C8C6:
	ldrb r2, [r7,r0]
	sub r1, r1, r2
	blt loc_802C8D0
	add r0, #1
	b loc_802C8C6
loc_802C8D0:
	add sp, sp, #0xc
	pop {pc}
	thumb_func_end sub_802C8B0

// symdb: Pops the next halfword entry from an in-struct FIFO queue, returning 0 when it is empty.
// symdb: u16 queue_popHalfword(void *state /* r5 */); // in: r5 = queue state, lr = return; out: r0 =
// symdb: value (0 if empty), r1 = read index, r2 = entry offset/count; flags c/v set by the last CMP/ADD,
// symdb: nz clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/queue_popHalfword_802C8D4.yaml
	thumb_local_start
queue_popHalfword_802C8D4:
	mov r0, #0
	ldrb r1, [r5,#0xc]
	ldrb r2, [r5,#0xd]
	cmp r1, r2
	bge locret_802C8E8
	add r2, r1, r1
	add r2, #0x14
	ldrh r0, [r5,r2]
	add r1, #1
	strb r1, [r5,#0xc]
locret_802C8E8:
	mov pc, lr
	thumb_func_end queue_popHalfword_802C8D4

// symdb: Returns a pointer to the 8-byte entry of the table at dword_2036820 selected by the current battle state's Unk_0d field.
// symdb: battle_getStateTableEntryPtr(toolkit in r10) -> entryPtr out r0, index*8 out r2; clobbers r1;
// symdb: NZCV set by the final address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getStateTableEntryPtr_802C8EA.yaml
	thumb_local_start
battle_getStateTableEntryPtr_802C8EA:
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r2, [r1,#oBattleState_Unk_0d]
	mov r1, #8
	mul r2, r1
	ldr r0, off_802CAFC // =dword_2036820 
	add r0, r0, r2
	mov pc, lr
	thumb_func_end battle_getStateTableEntryPtr_802C8EA

// symdb: Fills the 12-byte battle-result record (target passed in r0, e.g. 0x0203CBE4): +0 mode (0, or 1/2 from GetBattleEffects bit 8 + state nibbles), +1 busting level (BattleState+0x1E), +3 the count of nonzero rewards, +4 battle time, +8 reward 1, +0xA reward 2 (BattleState+0x36).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_802C8FA.yaml
	thumb_func_start sub_802C8FA
sub_802C8FA:
	push {r5-r7,lr}
	mov r7, r0
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne loc_802C90C
	mov r0, #0
	b loc_802C91A
loc_802C90C:
	bl battle_getStateByteNibbles_800A832
	mov r2, r0
	mov r0, #1
	cmp r2, #1
	beq loc_802C91A
	mov r0, #2
loc_802C91A:
	strb r0, [r7]
	bl battle_getStateUnk40_800A704
	str r0, [r7,#4]
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_1e]
	strb r0, [r7,#1]
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne loc_802C960
	bl battle_preUpdateAndGetPlayerObject_80103EC
	mov r5, r0
	ldrb r2, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r2, r1
	lsl r0, r2, #3
	add r0, #0x4c 
	mov r6, r10
	ldr r6, [r6,#oToolkit_BattleStatePtr]
	add r0, r0, r6
	add r2, #8
	ldrb r1, [r6,r2]
	ldrb r2, [r7,#1]
	ldrh r3, [r5,#oBattleObject_HP]
	ldrh r4, [r5,#oBattleObject_MaxHP]
	ldrb r5, [r5,#oBattleObject_Alliance]
	bl sub_80AA8E0
	strh r0, [r7,#8]
	strh r1, [r7,#0xa]
	b loc_802C96C
loc_802C960:
	ldrb r0, [r7,#1]
	bl sub_80AAC8C
	strh r0, [r7,#8]
	mov r1, #0
	strh r1, [r7,#0xa]
loc_802C96C:
	mov r2, #0
	tst r0, r0
	beq loc_802C974
	add r2, #1
loc_802C974:
	tst r1, r1
	beq loc_802C97A
	add r2, #1
loc_802C97A:
	strb r2, [r7,#3]
	pop {r5-r7,pc}
	thumb_func_end sub_802C8FA

// symdb: Classifies a battle object's timer at [r5+0x1C] against a per-battle-state time window and stores the resulting sub-state (0/1/2) into [r5+0x0E].
// symdb: int sub_802C97E(BattleObj *r5, BattleStateCtx *r10); // returns 0 = window done/absent, 1 =
// symdb: inside window, 2 = window not started; also sets [r5+0x0E]=result, [r5+0x0F]=1 when before or
// symdb: inside the window; clobbers r0-r3, preserves r4; flags from adds r0,result
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_checkTimerWindowSubstate_802C97E.yaml
	thumb_local_start
battle_checkTimerWindowSubstate_802C97E:
	push {r4,lr}
	mov r4, #0
	bl battle_getStateByte0d_800A7E2
	bl battle_findSpecificBossOnOpposingSide_802CA1E
	cmp r0, #0xff
	beq loc_802C9B2
	mov r4, #2
	ldr r1, off_802CB00 // =unk_20018C0 
	add r0, r0, r0
	ldrh r2, [r1,r0]
	ldr r3, [r5,#0x1c]
	cmp r3, r2
	bge loc_802C99E
	b loc_802C9AE
loc_802C99E:
	mov r4, #1
	ldr r1, off_802CB04 // =unk_2000260 
	ldrh r2, [r1,r0]
	ldr r3, [r5,#0x1c]
	cmp r3, r2
	blt loc_802C9AE
	mov r4, #0
	b loc_802C9B2
loc_802C9AE:
	mov r0, #1
	strb r0, [r5,#0xf]
loc_802C9B2:
	mov r0, r4
	strb r0, [r5,#0xe]
	pop {r4,pc}
	thumb_func_end battle_checkTimerWindowSubstate_802C97E

// symdb: Records this battle's value (u32 at battle state +0x40) into the per-slot best/running record tables chosen by the state's byte at +0x0D, keeping the lowest value seen.
// symdb: void battle_updateSlotBestRecords_802C9B8(void); // no direct args: reads battle state via
// symdb: helpers; preserves r4/r5, returns with v flag set by the last value comparison
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_updateSlotBestRecords_802C9B8.yaml
	thumb_func_start battle_updateSlotBestRecords_802C9B8
battle_updateSlotBestRecords_802C9B8:
	push {r4,lr}
	bl battle_getStateUnk40_800A704
	mov r4, r0
	bl battle_getStateByte0d_800A7E2
	bl battle_findSpecificBossOnOpposingSide_802CA1E
	cmp r0, #0xff
	beq locret_802C9E8
	ldr r1, off_802CB08 // =unk_20018C0 
	add r0, r0, r0
	ldrh r2, [r1,r0]
	cmp r4, r2
	bge loc_802C9DE
	strh r4, [r1,r0]
	ldr r1, off_802CB0C // =unk_2000260 
	strh r4, [r1,r0]
	b locret_802C9E8
loc_802C9DE:
	ldr r1, off_802CB10 // =unk_2000260 
	ldrh r2, [r1,r0]
	cmp r4, r2
	bge locret_802C9E8
	strh r4, [r1,r0]
locret_802C9E8:
	pop {r4,pc}
	thumb_func_end battle_updateSlotBestRecords_802C9B8

// symdb: When battle effect bit 3 (0x8) is active, copies the halfword at offset +8 between the two side effect buffers (unk_2035260/unk_203526C), regenerating a 0xFFFF "empty" value from the destination's byte at +1.
// symdb: void sub_802C9EA(void); /* in: r4/r5/r10 (r10 = toolkit ptr, preserved), lr; out: r0-r7
// symdb: clobbered, c/v/nz flags clobbered, r4/r5 preserved */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_syncEffectSlotBetweenBuffers_802C9EA.yaml
	thumb_func_start battle_syncEffectSlotBetweenBuffers_802C9EA
battle_syncEffectSlotBetweenBuffers_802C9EA:
	push {lr}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq locret_802CA1C
	ldr r6, off_802CB14 // =unk_203526C 
	ldr r7, off_802CB18 // =unk_2035260 
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_10]
	tst r0, r0
	beq loc_802CA08
	ldr r6, off_802CB1C // =unk_2035260 
	ldr r7, off_802CB20 // =unk_203526C 
loc_802CA08:
	ldr r0, [r6,#8]
	str r0, [r7,#8]
	ldrh r0, [r6,#8]
	ldr r1, dword_802CB24 // =0xffff 
	cmp r0, r1
	bne locret_802CA1C
	ldrb r0, [r7,#1]
	bl sub_80AABA4
	strh r0, [r7,#8]
locret_802CA1C:
	pop {pc}
	thumb_func_end battle_syncEffectSlotBetweenBuffers_802C9EA

// symdb: Scans the four enemy slots on the side opposite to the given side and, if one is a version-2, actor-type-1 enemy with AI index under 0x14, returns its AI index minus 1, else 0xFF.
// symdb: u8 battle_findSpecificBossOnOpposingSide_802CA1E(u8 sideIndex /*r0, 0 or 1*/); (reads r10 =
// symdb: toolkit; destroys r1 on return, callers ignore it)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_findSpecificBossOnOpposingSide_802CA1E.yaml
	thumb_local_start
battle_findSpecificBossOnOpposingSide_802CA1E:
	push {r4,r5,lr}
	mov r1, #1
	eor r0, r1
	mov r1, #8
	mul r0, r1
	add r0, #0x4c 
	mov r5, r10
	ldr r5, [r5,#oToolkit_BattleStatePtr]
	add r5, r5, r0
	mov r4, #0
loc_802CA32:
	ldrh r0, [r5]
	bl GetVerActorTyAndAIIdx_80182B4 // (enemy_idx: u16) -> *const (version: u8, actor_type: ActorType, ai_index: u8)
	ldrb r1, [r0,#1]
	cmp r1, #1
	bne loc_802CA50
	ldrb r1, [r0,#2]
	cmp r1, #0x14
	bge loc_802CA50
	ldrb r1, [r0]
	cmp r1, #2
	bne loc_802CA50
	ldrb r0, [r0,#2]
	sub r0, #1
	pop {r4,r5,pc}
loc_802CA50:
	add r5, #2
	add r4, #1
	cmp r4, #4
	blt loc_802CA32
	mov r0, #0xff
	pop {r4,r5,pc}
	thumb_func_end battle_findSpecificBossOnOpposingSide_802CA1E

// symdb: Packs a sound ID from a request struct into a FIFO record and sends it to the ARM7 sound handler.
// symdb: void sound_pushRequest_802CA5C(/* r5 */ struct SoundRequest *req); // no meaningful return;
// symdb: flags/regs out are just fifo_pushRecord16's leftovers
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sound_pushRequest_802CA5C.yaml
	thumb_local_start
sound_pushRequest_802CA5C:
	push {lr}
	mov r0, #6
	ldrsb r0, [r5,r0]
	lsl r0, r0, #3
	add r0, #0xd
	ldr r1, dword_802CB28 // =0x1ff 
	and r0, r1
	lsl r0, r0, #0x10
	add r0, #0x15
	ldr r1, dword_802CB2C // =0xffff00ff 
	and r0, r1
	ldr r1, dword_802CB30 // =0x40000000 
	add r0, r0, r1
	ldr r1, dword_802CB34 // =0xb200 
	mov r2, #0
	mov r3, #0
	bl fifo_pushRecord16_8009FF8
	pop {pc}
	thumb_func_end sound_pushRequest_802CA5C

// symdb: Checks two dirty/update flags (unk04, unk06) on the singleton struct at 0x200A008 and runs the shared redraw pair (sub_802C54C + sub_802CAA6) once per set flag.
// symdb: void sub_802CA82(void); /* in: nothing meaningful (r4-r7 preserved); out: nothing; called via
// symdb: BL, returns to caller */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eStruct200A008_redrawOnDirtyFlags_802CA82.yaml
	thumb_func_start eStruct200A008_redrawOnDirtyFlags_802CA82
eStruct200A008_redrawOnDirtyFlags_802CA82:
	push {r4,lr}
	bl eStruct200A008_getUnk04
	cmp r0, #0
	beq loc_802CA94
	bl decodePackedIdFields_802C54C
	bl sub_802CAA6
loc_802CA94:
	bl eStruct200A008_getUnk06
	cmp r0, #0
	beq locret_802CAA4
	bl decodePackedIdFields_802C54C
	bl sub_802CAA6
locret_802CAA4:
	pop {r4,pc}
	thumb_func_end eStruct200A008_redrawOnDirtyFlags_802CA82

// symdb: Applies a battle reward: type 0 = GiveChips (or TakeChips when the state nibble is 2), type 1 = GiveZenny, type 2 = nothing (HP), type 3 = bug frags — called from eStruct200A008_redrawOnDirtyFlags_802CA82 when the reward is given on leaving the result screen.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_802CAA6.yaml
	thumb_local_start
sub_802CAA6:
	push {lr}
	cmp r0, #0
	bne loc_802CADE
	mov r0, r1
	mov r1, r2
	mov r2, #1
	push {r0-r2}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	beq loc_802CACE
	bl battle_getStateByteNibbles_800A832
	cmp r0, #1
	beq loc_802CACE
	cmp r0, #2
	beq loc_802CAD6
	pop {r0-r2}
	pop {pc}
loc_802CACE:
	pop {r0-r2}
	bl GiveChips
	pop {pc}
loc_802CAD6:
	pop {r0-r2}
	bl TakeChips // (int idx, int searchItem, int off) -> void*
	pop {pc}
loc_802CADE:
	cmp r0, #1
	bne loc_802CAEA
	mov r0, r1
	bl GiveZenny
	pop {pc}
loc_802CAEA:
	cmp r0, #2
	bne loc_802CAF0
	pop {pc}
loc_802CAF0:
	cmp r0, #3
	bne locret_802CAFA
	mov r0, r1
	bl GiveBugfrags
locret_802CAFA:
	pop {pc}
	.balign 4, 0
off_802CAFC:
	.word dword_2036820
off_802CB00:
	.word unk_20018C0
off_802CB04:
	.word unk_2000260
off_802CB08:
	.word unk_20018C0
off_802CB0C:
	.word unk_2000260
off_802CB10:
	.word unk_2000260
off_802CB14:
	.word unk_203526C
off_802CB18:
	.word unk_2035260
off_802CB1C:
	.word unk_2035260
off_802CB20:
	.word unk_203526C
dword_802CB24:
	.word 0xFFFF
dword_802CB28:
	.word 0x1FF
dword_802CB2C:
	.word 0xFFFF00FF
dword_802CB30:
	.word 0x40000000
dword_802CB34:
	.word 0xB200
	thumb_func_end sub_802CAA6

	thumb_func_start sub_802CB38
sub_802CB38:
	push {r4,r6,r7,lr}
	ldr r7, off_802CB74 // =dword_203EAD0 
	strh r0, [r7,#0x8] // (word_203EAD8 - 0x203ead0)
	strh r1, [r7,#0xa] // (word_203EADA - 0x203ead0)
	mov r2, #0xff
	cmp r0, r1
	beq loc_802CB4E
	mov r2, #0
	cmp r0, r1
	blt loc_802CB4E
	mov r2, #1
loc_802CB4E:
	strb r2, [r5,#0x10]
	mov r4, #3
	cmp r2, #0xff
	beq loc_802CB66
	mov r6, r2
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	mov r4, #2
	eor r0, r6
	beq loc_802CB66
	mov r4, #1
loc_802CB66:
	strb r4, [r7,#0x7] // (dword_203EAD4+3 - 0x203ead0)
	mov r0, #0
	str r0, [r7]
	strh r0, [r7,#0xc] // (word_203EADC - 0x203ead0)
	strh r0, [r7,#0xe] // (word_203EADE - 0x203ead0)
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_802CB74:
	.word dword_203EAD0
	thumb_func_end sub_802CB38

	thumb_func_start sub_802CB78
sub_802CB78:
	push {r5,lr}
	ldr r5, off_802CBA0 // =dword_203EAD0 
	mov r0, #1
	strb r0, [r5,#0x4] // (dword_203EAD4 - 0x203ead0)
	ldr r1, off_802CB90 // =off_802CB94 
	ldrb r0, [r5]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	ldrb r0, [r5,#0x4] // (dword_203EAD4 - 0x203ead0)
	ldrb r1, [r5,#0x7] // (dword_203EAD4+3 - 0x203ead0)
	pop {r5,pc}
	.balign 4, 0
off_802CB90:
	.word off_802CB94
off_802CB94:
	.word sub_802CBA4+1
	.word sub_802CBAC+1
	.word sub_802CCAE+1
off_802CBA0:
	.word dword_203EAD0
	thumb_func_end sub_802CB78

	thumb_local_start
sub_802CBA4:
	push {lr}
	mov r0, #4
	str r0, [r5]
	pop {pc}
	thumb_func_end sub_802CBA4

	thumb_local_start
sub_802CBAC:
	push {lr}
	ldr r1, off_802CBBC // =off_802CBC0 
	ldrb r0, [r5,#1]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
off_802CBBC:
	.word off_802CBC0
off_802CBC0:
	.word sub_802CBCC+1
	.word sub_802CBF2+1
	.word sub_802CC8C+1
	thumb_func_end sub_802CBAC

	thumb_local_start
sub_802CBCC:
	push {lr}
	ldrh r1, [r5,#8]
	ldrh r2, [r5,#0xa]
	mov r3, r10
	ldr r3, [r3,#oToolkit_BattleStatePtr]
	ldrb r3, [r3,#oBattleState_Unk_0d]
	tst r3, r3
	beq loc_802CBE2
	mov r3, r2
	mov r2, r1
	mov r1, r3
loc_802CBE2:
	mov r0, #0x28 
	bl sub_801E792
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
	pop {pc}
	thumb_func_end sub_802CBCC

	thumb_local_start
sub_802CBF2:
	push {lr}
	ldr r1, off_802CC00 // =off_802CC04
	ldrb r0, [r5,#2]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
off_802CC00:
	.word off_802CC04
off_802CC04:
	.word sub_802CC10+1
	.word sub_802CC1A+1
	.word sub_802CC50+1
	thumb_func_end sub_802CBF2

	thumb_local_start
sub_802CC10:
	mov r0, #0x3c // word_3C
	strb r0, [r5,#5]
	mov r0, #4
	strb r0, [r5,#2]
	mov pc, lr
	thumb_func_end sub_802CC10

	thumb_local_start
sub_802CC1A:
	push {lr}
	ldrb r0, [r5,#5]
	sub r0, #1
	strb r0, [r5,#5]
	beq loc_802CC3E
	bl GetPositiveSignedRNG
	mov r4, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	ldr r1, dword_802CC4C // =0x270e 
	svc 6
	strh r1, [r5,#0xc]
	lsr r0, r4, #0x10
	ldr r1, dword_802CC4C // =0x270e 
	svc 6
	strh r1, [r5,#0xe]
	b loc_802CC42
loc_802CC3E:
	mov r0, #8
	strh r0, [r5,#2]
loc_802CC42:
	ldrh r0, [r5,#0xc]
	ldrh r1, [r5,#0xe]
	bl sub_801E914
	pop {pc}
	.balign 4, 0
dword_802CC4C:
	.word 0x270E
	thumb_func_end sub_802CC1A

	thumb_local_start
sub_802CC50:
	push {lr}
	ldrb r0, [r5,#3]
	tst r0, r0
	bne loc_802CC60
	mov r0, #0x78 
	strb r0, [r5,#5]
	mov r0, #4
	strb r0, [r5,#3]
loc_802CC60:
	ldrb r0, [r5,#5]
	sub r0, #1
	strb r0, [r5,#5]
	beq loc_802CC82
	ldrh r0, [r5,#8]
	ldrh r1, [r5,#0xa]
	mov r2, r10
	ldr r2, [r2,#oToolkit_BattleStatePtr]
	ldrb r2, [r2,#oBattleState_Unk_0d]
	tst r2, r2
	beq loc_802CC7C
	mov r2, r1
	mov r1, r0
	mov r0, r2
loc_802CC7C:
	bl sub_801E914
	b locret_802CC8A
loc_802CC82:
	mov r0, #8
	strb r0, [r5,#1]
	mov r0, #0
	strh r0, [r5,#2]
locret_802CC8A:
	pop {pc}
	thumb_func_end sub_802CC50

	thumb_local_start
sub_802CC8C:
	push {lr}
	ldrb r0, [r5,#2]
	tst r0, r0
	bne loc_802CCA0
	bl sub_801E780
	mov r0, #0x1e
	strb r0, [r5,#5]
	mov r0, #4
	strb r0, [r5,#2]
loc_802CCA0:
	ldrb r0, [r5,#5]
	sub r0, #1
	strb r0, [r5,#5]
	bne locret_802CCAC
	mov r0, #8
	str r0, [r5]
locret_802CCAC:
	pop {pc}
	thumb_func_end sub_802CC8C

	thumb_local_start
sub_802CCAE:
	mov r0, #0
	strb r0, [r5,#4]
	mov pc, lr
off_802CCB4:
	.word sub_80E07E0+1 // 0x0
	.word sub_80E7546+1 // 0x1
	.word sub_80E2F24+1 // 0x2
	.word sub_80E2566+1 // 0x3
	.word sub_80E3B50+1 // 0x4
	.word sub_80E2B5A+1 // 0x5
	.word sub_80E46B6+1 // 0x6
	.word sub_80E7464+1 // 0x7
	.word sub_80E3128+1 // 0x8
	.word sub_80E5EA8+1 // 0x9
	.word sub_80E3242+1 // 0xa
	.word sub_80E349E+1 // 0xb
	.word sub_80E59C6+1 // 0xc
	.word sub_80E5F78+1 // 0xd
	.word sub_80E67E6+1 // 0xe
	.word sub_80E2D76+1 // 0xf
	.word sub_80E4288+1 // 0x10
	.word sub_80E4164+1 // 0x11
	.word sub_80E76D4+1 // 0x12
	.word sub_80E7600+1 // 0x13
	.word spawnBattleTrapMaybe_80E353E+1 // 0x14
	.word sub_80E7008+1 // 0x15
	.word sub_80E7FBA+1 // 0x16
	.word sub_80E70A6+1 // 0x17
	.word sub_80E723E+1 // 0x18
	.word sub_80E24B8+1 // 0x19
	.word sub_80E49A2+1 // 0x1a
	.word sub_80E64E8+1 // 0x1b
	.word sub_80E7CA8+1 // 0x1c
	.word sub_80E7F16+1 // 0x1d
	.word spawnDblHeroSetupObject_80E8058+1 // 0x1e
	.word sub_80E81B4+1 // 0x1f
	.word sub_80E8BC0+1 // 0x20
	.word spawnSunMoonObject_80E8ADC+1 // 0x21
	.word 0x0 // 0x22
	.word 0x0 // 0x23
	.word sub_80E91B8+1 // 0x24
	.word sub_80E943E+1 // 0x25
	.word sub_80E979C+1 // 0x26
	.word 0x0 // 0x27
	.word 0x0 // 0x28
	.word sub_80E92EE+1 // 0x29
off_802CD5C:
	.word sub_80C0DD8+1
	.word sub_80C2A4C+1
	.word sub_80B921A+1
	.word sub_80B9432+1
	.word sub_80BA1B0+1
	.word sub_80BB7F6+1
	.word sub_80BBAC6+1
	.word sub_80B9750+1
	.word sub_80B999A+1
	.word sub_80B9F0E+1
	.word sub_80BBDE8+1
	.word sub_80BC0DA+1
	.word sub_80B9014+1
	.word sub_80B9B6E+1
	.word sub_80BA660+1
	.word sub_80BA920+1
	.word sub_80BAE16+1
	.word sub_80B84EC+1
	.word NULL
	.word NULL
	.word sub_80BD9A2+1
	.word sub_80BE3E8+1
	.word sub_80BF160+1
	.word sub_80EA11C+1
	.word sub_80BFCD0+1
	.word spawnType1Object_0x24_80BF6AE+1
	.word spawnBassChipObject_80C3B30+1
	.word sub_80C3E98+1
	.word sub_80C2F96+1
	thumb_func_end sub_802CCAE

// symdb: If the current-target slot of the caller's alliance record points back at the caller, clears it to null.
// symdb: battle_ClearAllianceTargetSlotIfSelf(battleObject* obj /* r5 */) -> u32 prevTarget /* r1 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_ClearAllianceTargetSlotIfSelf_802CDD0.yaml
	thumb_func_start battle_ClearAllianceTargetSlotIfSelf_802CDD0
battle_ClearAllianceTargetSlotIfSelf_802CDD0:
	ldr r0, off_802CE50 // =dword_203CFB0 
	ldrb r1, [r5,#oBattleObject_Alliance]
	tst r1, r1
	beq loc_802CDDA
	add r0, #0xc
loc_802CDDA:
	ldr r1, [r0,#8]
	cmp r1, r5
	bne locret_802CDE4
	mov r1, #0
	str r1, [r0,#8]
locret_802CDE4:
	mov pc, lr
	thumb_func_end battle_ClearAllianceTargetSlotIfSelf_802CDD0

// symdb: Detach the BattleObject passed in r5 from its alliance's tracking slot in the battle arena, clearing the slot if it currently owns it.
// symdb: void sub_802CDE6(struct BattleObject *r5 /* in */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObject_DetachFromAllianceSlot_802CDE6.yaml
	thumb_func_start battleObject_DetachFromAllianceSlot_802CDE6
battleObject_DetachFromAllianceSlot_802CDE6:
	ldr r0, off_802CE50 // =dword_203CFB0 
	ldrb r1, [r5,#oBattleObject_Alliance]
	tst r1, r1
	bne loc_802CDF0
	add r0, #0xc
loc_802CDF0:
	ldr r1, [r0,#4]
	cmp r1, r5
	bne locret_802CDFC
	mov r1, #0
	str r1, [r0,#4]
	str r1, [r0,#8]
locret_802CDFC:
	mov pc, lr
	thumb_func_end battleObject_DetachFromAllianceSlot_802CDE6

// symdb: Wraps two 32-bit counters at dword_203CFB0 and dword_203CFB0+0xC down to their low 16 bits, discarding the upper halves.
// symdb: void sub_802CDFE(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/wrapCountersAt203CFB0ToU16_802CDFE.yaml
	thumb_func_start wrapCountersAt203CFB0ToU16_802CDFE
wrapCountersAt203CFB0ToU16_802CDFE:
	ldr r0, off_802CE50 // =dword_203CFB0 
	ldr r1, [r0]
	lsl r1, r1, #0x10
	str r1, [r0]
	add r0, #0xc
	ldr r1, [r0]
	lsl r1, r1, #0x10
	str r1, [r0]
	mov pc, lr
	thumb_func_end wrapCountersAt203CFB0ToU16_802CDFE

// symdb: Updates one side's battle counter for the object's alliance, either adding the tracked object's stored increment to the given value or raising the counter's recorded maximum.
// symdb: u32 battle_updateSideCounter(u32 amount /*r0*/, BattleObject *object /*r5*/); // returns updated
// symdb: amount in r0 and the counter block's tracked-object pointer in r2; clobbers r1, r3 and NZCV
// symdb: flags
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802CE10.yaml
	thumb_func_start sub_802CE10
sub_802CE10:
	ldr r1, off_802CE50 // =dword_203CFB0 
	ldrb r2, [r5,#oBattleObject_Alliance]
	tst r2, r2
	beq loc_802CE1A
	add r1, #0xc
loc_802CE1A:
	ldr r2, [r1,#8]
	cmp r5, r2
	bne loc_802CE26
	ldrh r3, [r1,#2]
	add r0, r0, r3
	mov pc, lr
loc_802CE26:
	ldrh r3, [r1]
	cmp r0, r3
	bls locret_802CE2E
	strh r0, [r1]
locret_802CE2E:
	mov pc, lr
	thumb_func_end sub_802CE10

// symdb: Returns 1 if the current battle object's entry in the battle order table matches R5 and its next pointer is non-zero, else 0 (used to validate the caller as the front-of-order battler of its team).
// symdb: bool checkBattleOrderMatch_802CE30(void); /* in: r5 = battle object; out: r0 = 0/1, NZ flags */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/checkBattleOrderMatch_802CE30.yaml
	thumb_func_start checkBattleOrderMatch_802CE30
checkBattleOrderMatch_802CE30:
	ldr r0, off_802CE50 // =dword_203CFB0 
	ldrb r1, [r5,#oBattleObject_Alliance]
	tst r1, r1
	bne loc_802CE3A
	add r0, #0xc
loc_802CE3A:
	ldr r1, [r0,#4]
	cmp r1, r5
	bne loc_802CE4A
	ldr r1, [r0,#8]
	tst r1, r1
	beq loc_802CE4A
	mov r0, #1
	mov pc, lr
loc_802CE4A:
	mov r0, #0
	mov pc, lr
	.balign 4, 0
off_802CE50:
	.word dword_203CFB0
	thumb_func_end checkBattleOrderMatch_802CE30

// symdb: Zero-fills the fixed 0x20-byte work buffer at unk_2036720 (IWRAM), preserving r2/r3 for the caller.
// symdb: void clearWorkBuffer_2036720_32bytes(void); /* in: r2, r3 (forwarded untouched), lr; out: r2, r3
// symdb: preserved, c/v per ZeroFillByWord */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/zeroFill_802CE54.yaml
	thumb_func_start zeroFill_802CE54
zeroFill_802CE54:
	push {lr}
	// memBlock
	ldr r0, off_802D020 // =unk_2036720 
	// size
	mov r1, #0x20 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end zeroFill_802CE54

// symdb: Looks up one 16-byte entry from a battle table, scrambling the index with the current battle's shuffle key so the returned entry is shuffled but deterministic per battle.
// symdb: battle_getShuffledTableEntry(u32 index /* r0 */) -> entryHalfword0 /* r0 */, entryWord4 /* r1
// symdb: */, entryHalfword2 /* r2 */; uses r10 = toolkit
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802CE60.yaml
	thumb_func_start sub_802CE60
sub_802CE60:
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldrb r1, [r1,#oBattleState_Unk_0d]
	eor r0, r1
	mov r1, #0x10
	mul r0, r1
	ldr r1, off_802D024 // =unk_2036720 
	add r0, r0, r1
	ldr r1, [r0,#4]
	ldrh r2, [r0,#2]
	ldrh r0, [r0]
	mov pc, lr
	thumb_func_end sub_802CE60

// symdb: Reads the 16-byte record at index r0 of the table at 0x2036720 and returns its four fields in r0-r3.
// symdb: u32 entryIndex -> (r0 = u16 field0, r1 = u32 field1, r2 = u16 field2, r3 = u32 field3); c/v set
// symdb: by the address ADDS
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getTable2036720EntryFields_802CE78.yaml
	thumb_func_start getTable2036720EntryFields_802CE78
getTable2036720EntryFields_802CE78:
	mov r1, #0x10
	mul r0, r1
	ldr r1, off_802D028 // =unk_2036720 
	add r0, r0, r1
	ldr r3, [r0,#8]
	ldr r1, [r0,#4]
	ldrh r2, [r0,#2]
	ldrh r0, [r0]
	mov pc, lr
	thumb_func_end getTable2036720EntryFields_802CE78

	thumb_func_start sub_802CE8A
sub_802CE8A:
	push {r4-r6,lr}
	mov r6, r2
	mov r5, r3
	ldrb r2, [r0,#oBattleObject_Alliance]
	mov r3, #0x10
	mul r2, r3
	ldr r3, off_802D02C // =unk_2036720 
	add r3, r3, r2
	strh r1, [r3]
	str r6, [r3,#4]
	strh r5, [r3,#2]
	str r0, [r3,#8]
	str r4, [r3,#0xc]
	pop {r4-r6,pc}
	thumb_func_end sub_802CE8A

	thumb_func_start sub_802CEA6
sub_802CEA6:
	mov r1, #0x10
	mul r1, r0
	ldr r0, off_802D030 // =unk_2036720 
	add r0, r0, r1
	mov r1, #0
	strh r1, [r0]
	strh r1, [r0,#4]
	strh r1, [r0,#2]
	str r1, [r0,#8]
	ldr r1, [r0,#0xc]
	tst r1, r1
	beq locret_802CEC6
	mov r2, #1
	strb r2, [r1,#5]
	mov r1, #0
	str r1, [r0,#0xc]
locret_802CEC6:
	mov pc, lr
	thumb_func_end sub_802CEA6

// symdb: Walks a fixed two-slot table at 0x2036720 and, for each slot whose entry pointer is set and whose "busy" halfword flag at +0x24 is clear, invokes a shared handler (sub_802CEA6) with that entry's byte at +0x16.
// symdb: void sub_802CEC8(void); /* out: r4 = &unk_2036720[1] (base + 0x10) */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/runPendingHandlerForEntryPair_802CEC8.yaml
	thumb_func_start runPendingHandlerForEntryPair_802CEC8
runPendingHandlerForEntryPair_802CEC8:
	push {lr}
	ldr r4, off_802D034 // =unk_2036720 
	ldr r0, [r4,#0x8] // (dword_2036728 - 0x2036720)
	tst r0, r0
	beq loc_802CEDE
	ldrh r1, [r0,#0x24]
	tst r1, r1
	bne loc_802CEDE
	ldrb r0, [r0,#0x16]
	bl sub_802CEA6
loc_802CEDE:
	add r4, #0x10
	ldr r0, [r4,#0x8] // (dword_2036738 - 0x2036730)
	tst r0, r0
	beq locret_802CEF2
	ldrh r1, [r0,#0x24]
	tst r1, r1
	bne locret_802CEF2
	ldrb r0, [r0,#0x16]
	bl sub_802CEA6
locret_802CEF2:
	pop {pc}
	thumb_func_end runPendingHandlerForEntryPair_802CEC8

// symdb: Resolves a collision outcome for a hive/AntiSword battle object, updating the hive-broken/hive-rebuilt/AntiSword AI flags and clearing the per-panel damage scratch buffer.
// symdb: void hive_block_802CEF4(u32 *object /* r5 */); /* preserves r4,r5,r6,r7,r10; clobbers
// symdb: r0-r3,lr,flags */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/hiveBlockHappensHere_802CEF4.yaml
	thumb_func_start hiveBlockHappensHere_802CEF4
hiveBlockHappensHere_802CEF4:
	push {r4,r6,r7,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	bl GetAIDataUnk0x48Flag
	ldr r1, dword_802D038 // =0x200000 riskyhoney hive up
	tst r0, r1
	beq loc_802CF30
	mov r1, #oCollisionData_PanelDamage2
	ldrh r1, [r4,r1]
	cmp r1, #0
	bne loc_802CF30
	mov r0, #oCollisionData_PanelDamage1
	add r0, r0, r4
	ldrh r2, [r0,#oCollisionData_PanelDamage1 - oCollisionData_PanelDamage1]
	ldrh r1, [r0,#oCollisionData_PanelDamage3 - oCollisionData_PanelDamage1]
	orr r2, r1
	ldrh r1, [r0,#oCollisionData_PanelDamage4 - oCollisionData_PanelDamage1]
	orr r2, r1
	ldrh r1, [r0,#oCollisionData_PanelDamage5 - oCollisionData_PanelDamage1]
	orr r2, r1
	cmp r2, #0
	beq loc_802CFB8
	ldr r3, [r5,#oBattleObject_AIDataPtr]
	add r3, #0xa0
	mov r0, #1
	str r0, [r3,#oAIAttackVars_Unk_30]
	mov r0, #0x6e 
	bl PlaySoundEffect
	b loc_802CFB8
loc_802CF30:
	mov r6, #0xa
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getTable2036720EntryFields_802CE78
	mov r7, r0
	cmp r0, #0xbb
	beq loc_802CF56
	ldr r1, dword_802D03C // =0x157 
	cmp r0, r1
	beq loc_802CF56
	push {r0}
	bl GetAIDataUnk0x48Flag
	ldr r1, off_802D040 // =0x800 
	tst r0, r1
	pop {r0}
	beq loc_802CF96
	mov r7, #0xbb
	mov r6, #1
loc_802CF56:
	bl GetAIData_Unk_44_Flag
	ldr r1, dword_802D044 // =0x8200 
	tst r0, r1
	bne loc_802CFB8
	ldr r0, [r4,#oCollisionData_FlagsFromCollision]
	ldr r1, dword_802D048 // =0xff800000 
	tst r0, r1
	beq locret_802CFF6
	mov r0, #0x82
	add r0, r0, r4
	ldrh r2, [r0]
	ldrh r1, [r0,#2]
	add r2, r2, r1
	ldrh r1, [r0,#4]
	add r2, r2, r1
	ldrh r1, [r0,#6]
	add r2, r2, r1
	ldrh r1, [r0,#8]
	add r2, r2, r1
	cmp r2, r6
	bge loc_802CF88
	cmp r6, #1
	beq loc_802CFB8
	b locret_802CFF6
loc_802CF88:
	ldr r0, off_802D04C // =0x200 
	cmp r7, #0xbb
	beq loc_802CF90
	ldr r0, dword_802D050 // =0x8000 
loc_802CF90:
	bl SetAIData_Unk_44_Flag
	b loc_802CFB8
loc_802CF96:
	cmp r0, #0xbc
	bne locret_802CFF6
	bl GetAIData_Unk_44_Flag
	ldr r1, off_802D054 // =0x400 
	tst r0, r1
	bne loc_802CFB8
	ldr r0, [r4,#oCollisionData_FlagsFromCollision]
	ldr r1, off_802D058 // =0x2000 
	tst r0, r1
	beq locret_802CFF6
	ldr r1, dword_802D05C // =0x20000 
	tst r0, r1
	bne locret_802CFF6
	ldr r0, off_802D054 // =0x400 // AntiSword triggered flag?
	bl SetAIData_Unk_44_Flag
loc_802CFB8:
	mov r0, #0
	mov r1, #oCollisionData_PanelDamage1
	add r1, r1, r4
	strh r0, [r1,#oCollisionData_PanelDamage1 - oCollisionData_PanelDamage1]
	strh r0, [r1,#oCollisionData_PanelDamage2 - oCollisionData_PanelDamage1]
	strh r0, [r1,#oCollisionData_PanelDamage3 - oCollisionData_PanelDamage1]
	strh r0, [r1,#oCollisionData_PanelDamage4 - oCollisionData_PanelDamage1]
	strh r0, [r1,#oCollisionData_PanelDamage5 - oCollisionData_PanelDamage1]
	mov r1, #oCollisionData_Unk_8e
	strh r0, [r4,r1]
	mov r1, #oCollisionData_Unk_90
	strh r0, [r4,r1]
	mov r1, #oCollisionData_Unk_92
	strh r0, [r4,r1]
	mov r1, #0x74 
	str r0, [r4,r1]
	strb r0, [r4,#oCollisionData_HitModifierFinal]
	strb r0, [r4,#oCollisionData_StatusEffectFinal]
	mov r1, #0xa4
	strh r0, [r4,r1]
	strh r0, [r4,#oCollisionData_Unk_1c]
	strh r0, [r4,#oCollisionData_Unk_2a]
	strh r0, [r4,#oCollisionData_Unk_2c]
	mov r1, #0x40 
	ldr r0, [r4,#oCollisionData_FlagsFromCollision]
	bic r0, r1
	str r0, [r4,#oCollisionData_FlagsFromCollision]
	ldr r1, dword_802D060 // =0x301be 
	ldr r0, [r4,#oCollisionData_ObjectFlags2]
	bic r0, r1
	str r0, [r4,#oCollisionData_ObjectFlags2]
locret_802CFF6:
	pop {r4,r6,r7,pc}
	thumb_func_end hiveBlockHappensHere_802CEF4

// symdb: If the battle object in r5 has its impact/shockwave trigger flag set, look up its alliance in table 0x2036720 and apply an impact effect and SFX.
// symdb: void sub_802CFF8(u32 *battle_object /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObject_handleImpact_802CFF8.yaml
	thumb_func_start battleObject_handleImpact_802CFF8
battleObject_handleImpact_802CFF8:
	push {r4,lr}
	ldr r4, [r5,#oBattleObject_CollisionDataPtr]
	mov r1, #0x76 
	ldrb r0, [r4,r1]
	mov r1, #0x40 
	tst r0, r1
	beq locret_802D01C
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getTable2036720EntryFields_802CE78
	cmp r0, #0
	beq locret_802D01C
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl sub_802CEA6
	mov r0, #0x8e
	bl PlaySoundEffect
locret_802D01C:
	pop {r4,pc}
	.balign 4, 0
off_802D020:
	.word unk_2036720
off_802D024:
	.word unk_2036720
off_802D028:
	.word unk_2036720
off_802D02C:
	.word unk_2036720
off_802D030:
	.word unk_2036720
off_802D034:
	.word unk_2036720
dword_802D038:
	.word 0x200000
dword_802D03C:
	.word 0x157
off_802D040:
	.word 0x800
dword_802D044:
	.word 0x8200
dword_802D048:
	.word 0xFF800000
off_802D04C:
	.word 0x200
dword_802D050:
	.word 0x8000
off_802D054:
	.word 0x400
off_802D058:
	.word 0x2000
dword_802D05C:
	.word 0x20000
dword_802D060:
	.word 0x301BE
	thumb_func_end battleObject_handleImpact_802CFF8

// symdb: Returns the address of one 0x20-byte entry (selected by index) within the IWRAM array at byte_203C4A0.
// symdb: struct20* getTableEntryPtr32_802D064(u32 index); // in: r0 = entry index, lr = return address;
// symdb: out: r0 = &base[index*0x20]; flags NZCV set from the final address addition
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getTableEntryPtr32_802D064.yaml
	thumb_func_start getTableEntryPtr32_802D064
getTableEntryPtr32_802D064: // (a0: bool) -> * ?
	mov r1, #0x20 
	mul r0, r1
	ldr r1, off_802D214 // =byte_203C4A0 
	add r0, r0, r1
	mov pc, lr
	.byte 0, 0
	thumb_func_end getTableEntryPtr32_802D064

	thumb_func_start sub_802D070
sub_802D070:
	push {lr}
	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?
	push {r0}
	// size
	mov r1, #0x20 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {r3}
	mov r0, #0
	strb r0, [r3,#0x10]
	mov r0, #0x64 
	strb r0, [r3,#0xd]
	strb r0, [r3,#0xf]
	pop {pc}
	thumb_func_end sub_802D070

// symdb: Fetches a state struct via sub_802D064 (selected by the flag in r0), clears its byte at +0x10, and sets the two bytes at +0xD and +0xF to 100.
// symdb: void initStateCounters100(bool selector /* r0 */); returns the struct pointer in r0 and 100 in
// symdb: r1 (NZCV reflect r1); tail of the call chain passes lr through
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/initStateCounters100_802D08C.yaml
	thumb_func_start initStateCounters100_802D08C
initStateCounters100_802D08C:
	push {lr}
	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?
	mov r1, #0
	strb r1, [r0,#0x10]
	mov r1, #0x64 
	strb r1, [r0,#0xd]
	strb r1, [r0,#0xf]
	pop {pc}
	thumb_func_end initStateCounters100_802D08C

	thumb_local_start
sub_802D09E:
	push {r4,r6,lr}
	mov r6, r0
	mov r4, r1
	ldrb r0, [r5,#0x12]
	ldrb r1, [r5,#0x13]
	mov r3, #0x10
	lsl r3, r3, #0x10
	mul r3, r4
	mov r0, r4
	mov r0, r6
	mov r1, #7
	bl tableAddSaturatedByte_800AB46
	pop {r4,r6,pc}
	thumb_func_end sub_802D09E

	thumb_local_start
sub_802D0BA:
	push {lr}
	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?
	mov r1, #0
	str r1, [r0]
	str r1, [r0,#4]
	pop {pc}
	thumb_func_end sub_802D0BA

	thumb_local_start
sub_802D0C8:
	push {r4,r7,lr}
	sub sp, sp, #0x10
	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?
	mov r7, r0
	bl battle_getStateByte0d_800A7E2
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r2, r0
	ldrh r0, [r2,#0x24]
	mov r1, #0x64 
	mul r0, r1
	ldrh r1, [r2,#0x26]
	sub r2, r1, #1
	add r0, r0, r2
	svc 6
	strb r0, [r7,#0xc]
	bl battle_getStateByte0d_800A7E2
	mov r3, #1
	eor r3, r0
	ldr r1, dword_802D218 // =0x17f 
	ldr r2, dword_802D218 // =0x17f 
	add r0, sp, #0
	bl object_getEnemyByNameRange
	tst r0, r0
	beq loc_802D112
	ldr r2, [sp]
	ldrh r0, [r2,#0x24]
	mov r1, #0x64 
	mul r0, r1
	ldrh r1, [r2,#0x26]
	sub r2, r1, #1
	add r0, r0, r2
	svc 6
loc_802D112:
	strb r0, [r7,#0xe]
	add sp, sp, #0x10
	pop {r4,r7,pc}
	thumb_func_end sub_802D0C8

	thumb_local_start
sub_802D118:
	push {r6,r7,lr}
	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?
	mov r7, r0
	bl sub_800A856
	mov r1, #0
	cmp r0, #0
	beq loc_802D138
	mov r1, #1
	cmp r0, #2
	beq loc_802D138
	mov r1, #2
	cmp r0, #1
	beq loc_802D138
	mov r1, #0
loc_802D138:
	strb r1, [r7,#0x11]
	strb r1, [r7,#0x10]
	bl sub_800A70C
	strh r0, [r7,#0x14]
	pop {r6,r7,pc}
	thumb_func_end sub_802D118

	thumb_local_start
sub_802D144:
	push {lr}
	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?
	mov r1, #0
	strb r1, [r0,#8]
	pop {pc}
	thumb_func_end sub_802D144

// symdb: Zeroes the 32-bit word at dword_2006740 (some counter or state flag) and returns.
// symdb: void sub_802D150(void); /* clobbers r0, r1, NZ flags; tail-free "return to caller" via mov pc,
// symdb: lr */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802D150.yaml
	thumb_func_start sub_802D150
sub_802D150:
	ldr r1, off_802D21C // =dword_2006740 
	mov r0, #0
	str r0, [r1]
	mov pc, lr
	thumb_func_end sub_802D150

	thumb_func_start sub_802D158
sub_802D158:
	ldr r1, off_802D220 // =dword_2006740 
	str r0, [r1]
	mov pc, lr
	thumb_func_end sub_802D158

	thumb_func_start sub_802D15E
sub_802D15E:
	ldr r1, off_802D224 // =dword_2006740 
	ldr r0, [r1]
	mov pc, lr
	thumb_func_end sub_802D15E

	thumb_local_start
sub_802D164:
	ldr r1, off_802D228 // =dword_2006740
	ldr r2, [r1]
	add r2, r2, r0
	ldr r3, dword_802D22C // =0xf423f 
	cmp r2, r3
	ble loc_802D172
	mov r2, r3
loc_802D172:
	str r2, [r1]
	mov pc, lr
	thumb_func_end sub_802D164

	thumb_local_start
sub_802D176:
	ldr r1, off_802D230 // =dword_2006740
	ldr r2, [r1]
	sub r2, r2, r0
	bge loc_802D180
	mov r2, #0
loc_802D180:
	str r2, [r1]
	mov pc, lr
	thumb_func_end sub_802D176

	thumb_local_start
sub_802D184:
	push {r4,r7,lr}
	mov r4, r0
	mov r7, #0
	bl battle_getStateByteNibbles_800A832
	cmp r0, #1
	bne loc_802D194
	add r7, #0xa
loc_802D194:
	mov r0, r4
	mov r1, #9
	bl table_GetByte16Row_203EAE0_800AB3A
	tst r0, r0
	beq loc_802D1A2
	add r7, #0xa
loc_802D1A2:
	mov r0, r4
	mov r1, #7
	bl table_GetByte16Row_203EAE0_800AB3A
	mov r1, #2
	mul r0, r1
	add r7, r7, r0
	mov r0, r7
	pop {r4,r7,pc}
	thumb_func_end sub_802D184

	thumb_func_start sub_802D1B4
sub_802D1B4:
	push {lr}
	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?
	ldrb r0, [r0,#0xd]
	pop {pc}
	thumb_func_end sub_802D1B4

	thumb_func_start sub_802D1BE
sub_802D1BE:
	push {lr}
	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?
	ldrb r0, [r0,#0xf]
	pop {pc}
	thumb_func_end sub_802D1BE

	thumb_local_start
sub_802D1C8:
	push {r4,r5,lr}
	mov r1, #0xc
	mul r0, r1
	add r0, #0x84
	mov r4, r10
	ldr r4, [r4,#oToolkit_BattleStatePtr]
	add r4, r4, r0
	mov r5, #0
loc_802D1D8:
	ldr r0, [r4]
	tst r0, r0
	beq loc_802D1E2
	bl sub_800EC3C
loc_802D1E2:
	add r4, #4
	add r5, #1
	cmp r5, #3
	blt loc_802D1D8
	pop {r4,r5,pc}
	thumb_func_end sub_802D1C8

	thumb_local_start
sub_802D1EC:
	push {lr}
	bl battle_getStateByte0d_800A7E2
	bl getTableEntryPtr32_802D064 // (a0: bool) -> * ?
	ldrb r1, [r0,#0x12]
	cmp r1, #0
	bne loc_802D1FE
	pop {pc}
loc_802D1FE:
	cmp r1, #2
	bne loc_802D208
	mov r2, #0
	strb r2, [r0,#0xd]
	pop {pc}
loc_802D208:
	cmp r1, #1
	bne locret_802D212
	mov r2, #0
	strb r2, [r0,#0xf]
	pop {pc}
locret_802D212:
	pop {pc}
	.balign 4, 0
off_802D214:
	.word byte_203C4A0
dword_802D218:
	.word 0x17F
off_802D21C:
	.word dword_2006740
off_802D220:
	.word dword_2006740
off_802D224:
	.word dword_2006740
off_802D228:
	.word dword_2006740
dword_802D22C:
	.word 0xF423F
off_802D230:
	.word dword_2006740
	thumb_func_end sub_802D1EC

// symdb: The current battle's mode, from the battle state's settings.
// symdb: (r10 = toolkit) -> r0 = GetBattleModeFromBattleSettings([[toolkit + oToolkit_BattleStatePtr] +
// symdb: oBattleState_BattleSettings])
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattleMode.yaml
	thumb_func_start GetBattleMode
GetBattleMode:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldr r0, [r0,#oBattleState_BattleSettings]
	bl GetBattleModeFromBattleSettings
	pop {pc}
	thumb_func_end GetBattleMode

// symdb: Returns the battle mode (flag battle, HP battle, etc.) selected in the passed battle settings struct.
// symdb: Next GetBattleModeFromBattleSettings(BattleSettings *settings); // r0 = settings ptr, returns r0
// symdb: = mode byte, no flags or other regs touched
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattleModeFromBattleSettings.yaml
	thumb_local_start
GetBattleModeFromBattleSettings:
	ldrb r0, [r0,#3]
	mov pc, lr
	thumb_func_end GetBattleModeFromBattleSettings

// () -> int
// symdb: Returns the battle-effects bitmask for the currently active battle by reading it out of the current battle state's battle settings.
// symdb: int GetBattleEffects(void) — in: r10 (toolkit pointer), lr; out: r0 (battle-effects bitmask from
// symdb: GetBattleEffectsFromBattleSettings)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattleEffects.yaml
	thumb_func_start GetBattleEffects
GetBattleEffects:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldr r0, [r0,#oBattleState_BattleSettings]
	bl GetBattleEffectsFromBattleSettings // () -> int
	pop {pc}
	thumb_func_end GetBattleEffects

// () -> int
// symdb: Returns the "optional battle effects" settings word (e.g. battle modifiers like Custom+ effects) from the current battle settings struct.
// symdb: Next GetBattleEffectsFromBattleSettings(BattleSettings *settings); (r0 = BattleSettings ptr in,
// symdb: r0 = effects word out; returns via mov pc, lr, so it works from both ARM->THUMB? no, it stays in
// symdb: the caller's state)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattleEffectsFromBattleSettings.yaml
	thumb_func_start GetBattleEffectsFromBattleSettings
GetBattleEffectsFromBattleSettings:
	ldr r0, [r0,#oBattleSettings_UnkOptSettings]
	mov pc, lr
	thumb_func_end GetBattleEffectsFromBattleSettings

// symdb: Returns the "Unk01" battle-settings value for the currently running battle.
// symdb: Next GetCurrentBattleSettingsUnk01(tools in r10) -> u32 in r0
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/GetBattleSettingsUnk01.yaml
	thumb_local_start
GetBattleSettingsUnk01:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldr r0, [r0,#oBattleState_BattleSettings]
	bl GetBattleSettingsUnk01FromBattleSettings
	pop {pc}
	thumb_func_end GetBattleSettingsUnk01

// symdb: Returns byte at offset 1 of the battle settings struct, an unknown settings field.
// symdb: Next GetBattleSettingsUnk01FromBattleSettings(u8 *battleSettings /* r0 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattleSettingsUnk01FromBattleSettings.yaml
	thumb_func_start GetBattleSettingsUnk01FromBattleSettings
GetBattleSettingsUnk01FromBattleSettings:
	ldrb r0, [r0,#1]
	mov pc, lr
	thumb_func_end GetBattleSettingsUnk01FromBattleSettings

// symdb: Thin wrapper that returns the current battle panel column pattern from the active battle's settings.
// symdb: Next GetBattlePanelColumnPattern(Toolkit* toolkit @ r10) -> Next pattern @ r0 (return address
// symdb: passed through in lr as a tail call)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattlePanelColumnPattern.yaml
	thumb_func_start GetBattlePanelColumnPattern
GetBattlePanelColumnPattern:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldr r0, [r0,#oBattleState_BattleSettings]
	bl GetBattlePanelColumnPatternFromBattleSettings
	pop {pc}
	thumb_func_end GetBattlePanelColumnPattern

// symdb: Returns the battle panel column pattern byte stored at offset 6 of the battle settings struct.
// symdb: u8 GetBattlePanelColumnPatternFromBattleSettings(void* battleSettings); // in: r0 = battle
// symdb: settings ptr, out: r0 = byte at +6
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetBattlePanelColumnPatternFromBattleSettings.yaml
	thumb_local_start
GetBattlePanelColumnPatternFromBattleSettings:
	ldrb r0, [r0,#6]
	mov pc, lr
	thumb_func_end GetBattlePanelColumnPatternFromBattleSettings

// () -> BattleSettings*
	thumb_func_start getBattleSettings_200AF60
getBattleSettings_200AF60:
	ldr r0, off_802D2E4 // =BattleSettings_200AF60 
	mov pc, lr
	thumb_func_end getBattleSettings_200AF60

// (BattleSettings *src) -> void
	thumb_func_start copyBattleSettingsTo_200AF60
copyBattleSettingsTo_200AF60:
	push {lr}
	ldr r1, off_802D2E8 // =BattleSettings_200AF60 
	mov r2, #0x10
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	pop {pc}
	thumb_func_end copyBattleSettingsTo_200AF60

// (int mask) -> void
	thumb_func_start battleSettings_setFlags_unkSettings
battleSettings_setFlags_unkSettings:
	ldr r1, off_802D2EC // =BattleSettings_200AF60 
	ldr r2, [r1,#0x8] // BattleSettings.UnknownOptionalSettings
	orr r2, r0
	str r2, [r1,#0x8] // BattleSettings.UnknownOptionalSettings
	mov pc, lr
	thumb_func_end battleSettings_setFlags_unkSettings

// (int mask) -> void
	thumb_local_start
battlteSettings_clearFlags_UnkSettings:
	ldr r1, off_802D2F0 // =BattleSettings_200AF60 
	ldr r2, [r1,#0x8] // BattleSettings.UnknownOptionalSettings
	bic r2, r0
	str r2, [r1,#0x8] // BattleSettings.UnknownOptionalSettings
	mov pc, lr
	thumb_func_end battlteSettings_clearFlags_UnkSettings

// () -> u32
	thumb_local_start
battleSettings_getUnkOptSettings:
	ldr r1, off_802D2F4 // =BattleSettings_200AF60 
	ldr r0, [r1,#0x8] // BattleSettings.UnknownOptionalSettings
	mov pc, lr
	thumb_func_end battleSettings_getUnkOptSettings

// (u32 unkOptSettings) -> void
	thumb_local_start
battleSettings_setUnkOptSettings:
	ldr r1, off_802D2F8 // =BattleSettings_200AF60 
	str r0, [r1,#0x8] // BattleSettings.UnknownOptionalSettings
	mov pc, lr
	thumb_func_end battleSettings_setUnkOptSettings

// (u8 background) -> void
	thumb_func_start battleSettings_setBackground
battleSettings_setBackground:
	ldr r1, off_802D2FC // =BattleSettings_200AF60 
	strb r0, [r1,#0x4] // BattleSettings.background
	mov pc, lr
	thumb_func_end battleSettings_setBackground

// () -> BattleSettings*
	thumb_func_start battleSettings_802D2B2
battleSettings_802D2B2:
	push {r4,r6,r7,lr}
	bl battleSettings_getUnkOptSettings // () -> u32
	mov r4, r0
	mov r7, r10
	ldr r7, [r7,#oToolkit_BattleStatePtr]
	ldrb r0, [r7,#oBattleState_Unk_1a]
	sub r0, #1
	add r0, r0, r0
	ldr r6, off_802D300 // =byte_203CA50 
	add r6, r6, r0
	ldrb r0, [r6]
	bl getBattleSettingsFromList1 // (int battleSettingsIdx) -> BattleSettings*
	bl copyBattleSettingsTo_200AF60 // (BattleSettings *src) -> void
	mov r0, r4
	bl battleSettings_setUnkOptSettings // (u32 unkOptSettings) -> void
	ldrb r0, [r6,#1]
	bl battleSettings_setBackground // (u8 background) -> void
	bl getBattleSettings_200AF60 // () -> BattleSettings*
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_802D2E4:
	.word BattleSettings_200AF60
off_802D2E8:
	.word BattleSettings_200AF60
off_802D2EC:
	.word BattleSettings_200AF60
off_802D2F0:
	.word BattleSettings_200AF60
off_802D2F4:
	.word BattleSettings_200AF60
off_802D2F8:
	.word BattleSettings_200AF60
off_802D2FC:
	.word BattleSettings_200AF60
off_802D300:
	.word byte_203CA50
	.word 0, 0
	.byte 0, 0, 0, 0
	thumb_func_end battleSettings_802D2B2

	thumb_func_start sub_802D310
sub_802D310:
	ldr r0, [r5,#oBattleObject_AIDataPtr]
	sub r0, #0xf
	add r0, #0xff
	mov r1, #0
	str r1, [r0]
	str r1, [r0,#4]
	str r1, [r0,#8]
	str r1, [r0,#0xc]
	mov pc, lr
	thumb_func_end sub_802D310

	thumb_func_start sub_802D322
sub_802D322:
	push {r4,r6,r7,lr}
	ldr r6, [r5,#oBattleObject_AIDataPtr]
	sub r6, #0xf
	add r6, #0xff
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #0xa0
	ldrb r0, [r6,#8]
	cmp r0, #0
	bne loc_802D33C
	mov r0, #1
	strb r0, [r6,#8]
	mov r0, #8
	strh r0, [r6]
loc_802D33C:
	ldr r1, off_802D348 // =off_802D34C 
	ldrb r0, [r6]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_802D348:
	.word off_802D34C
off_802D34C:
	.word sub_802D358+1
	.word sub_802D3A8+1
	.word sub_802D3CA+1
	thumb_func_end sub_802D322

	thumb_local_start
sub_802D358:
	push {r4,lr}
	ldrh r0, [r6,#4]
	cmp r0, #3
	bgt loc_802D37A
	bl sub_80E164A
	ldrb r2, [r5,#oBattleObject_Alliance]
	bl ifPanelFlagSetFindBattleActorWithCollisionOnPanelXY_80E7486
	mov r4, r0
	beq loc_802D37A
	ldr r0, [r4,#oBattleObject_CollisionDataPtr]
	ldr r0, [r0,#oCollisionData_ObjectFlags1]
	mov r1, #1
	lsl r1, r1, #9
	tst r0, r1
	bne loc_802D3A0
loc_802D37A:
	bl getCurChipInBattleHand_8010004
	ldr r3, dword_802D628 // =0xffff 
	cmp r0, r3
	beq loc_802D3A0
	mov r0, #4
	bl SetAIData_Unk_44_Flag
	bl sub_800FB54
	ldr r3, dword_802D628 // =0xffff 
	cmp r0, r3
	beq loc_802D3A0
	mov r0, #0
	strh r0, [r6,#4]
	mov r0, #8
	strh r0, [r6]
	mov r0, #1
	b locret_802D3A6
loc_802D3A0:
	mov r0, #4
	strh r0, [r6]
	mov r0, #0
locret_802D3A6:
	pop {r4,pc}
	thumb_func_end sub_802D358

	thumb_local_start
sub_802D3A8:
	push {lr}
	mov r0, #8
	strh r0, [r6]
	ldrh r0, [r6,#4]
	cmp r0, #2
	bgt loc_802D3BE
	ldrb r0, [r5,#oBattleObject_PanelY]
	bl battle_pickRandomRowObjectFields_810971A
	cmp r0, #0
	beq loc_802D3C6
loc_802D3BE:
	mov r0, #0
	strh r0, [r6,#4]
	mov r0, #2
	b locret_802D3C8
loc_802D3C6:
	mov r0, #0
locret_802D3C8:
	pop {pc}
	thumb_func_end sub_802D3A8

	thumb_local_start
sub_802D3CA:
	push {lr}
	bl object_getFlag // () -> int
	ldr r3, off_802D62C // =byte_802D410 
	mov r1, #0x10
	tst r0, r1
	beq loc_802D3DA
	ldr r3, off_802D630 // =byte_802D420
loc_802D3DA:
	bl GetAllianceDependentPanelParamArgs
	bl sub_802D430
	strb r0, [r7,#oAIAttackVars_Unk_16]
	strb r1, [r7,#oAIAttackVars_Unk_17]
	mov r0, #0
	str r0, [r7,#oAIAttackVars_Unk_2c]
	str r0, [r7,#oAIAttackVars_Unk_30]
	mov r1, #8
	mov r2, #2
	mov r0, #5
	bl sub_80116AE
	ldrh r0, [r6,#4]
	add r0, #1
	strh r0, [r6,#4]
	mov r0, #0
	strh r0, [r6]
	mov r0, #3
	pop {pc}
	.word 0, 0
	.byte 0, 0, 0, 0
	.balign 4, 0
byte_802D410:
	.byte 0x10, 0x0, 0x0, 0x0, 0xA0, 0x0, 0x88, 0xF, 0x30, 0x0, 0x0, 0x0, 0x80
	.byte 0x0, 0x88, 0xF
byte_802D420:
	.byte 0x0, 0x0, 0x0, 0x0, 0xA0, 0x0, 0x88, 0xF, 0x20, 0x0, 0x0, 0x0, 0x80
	.byte 0x0, 0x88, 0xF
	thumb_func_end sub_802D3CA

	thumb_local_start
// choose beast over panel?
sub_802D430:
	push {r4,r6,r7,lr}
	sub sp, sp, #0x20
	str r2, [sp]
	str r3, [sp,#4]
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	bl object_reservePanel
	add r7, sp, #8
	mov r4, #1
	mov r6, #0
loc_802D446:
	mov r0, r4
	bl battle_pickRandomRowObjectFields_810971A
	cmp r0, #0
	beq loc_802D46C
	ldr r2, [sp]
	ldr r3, [sp,#4]
	push {r4}
	mov r4, #0
	bl sub_8015CC0
	lsl r1, r1, #4
	orr r0, r1
	strb r0, [r7]
	cmp r0, #0
	beq loc_802D468
	add r6, #1
loc_802D468:
	add r7, #1
	pop {r4}
loc_802D46C:
	add r4, #1
	cmp r4, #3
	ble loc_802D446
	cmp r6, #0
	bne loc_802D4A4
	add r7, sp, #8
	mov r4, #1
	mov r6, #0
loc_802D47C:
	mov r0, r4
	bl battle_pickRandomRowObjectFields_810971A
	cmp r0, #0
	beq loc_802D494
	mov r0, r4
	ldr r2, [sp]
	ldr r3, [sp,#4]
	bl object_getPanelsInRowFiltered
	add r6, r6, r0
	add r7, r7, r0
loc_802D494:
	add r4, #1
	cmp r4, #3
	ble loc_802D47C
	cmp r6, #0
	bne loc_802D4A4
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	b loc_802D4B6
loc_802D4A4:
	bl GetPositiveSignedRNG
	mov r1, r6
	svc 6
	add r0, sp, #8
	ldrb r0, [r0,r1]
	lsr r1, r0, #4
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
loc_802D4B6:
	push {r0,r1}
	ldrb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	pop {r0,r1}
	add sp, sp, #0x20
	pop {r4,r6,r7,pc}
	thumb_func_end sub_802D430

	thumb_func_start sub_802D4C6
sub_802D4C6:
	push {r4,r6,r7,lr}
	ldr r6, [r5,#oBattleObject_AIDataPtr]
	sub r6, #0xf
	add r6, #0xff
	ldr r7, [r5,#oBattleObject_AIDataPtr]
	add r7, #0xa0
	ldr r1, off_802D4E0 // =off_802D4E4 
	ldrb r0, [r6]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r4,r6,r7,pc}
	.byte 0, 0
off_802D4E0:
	.word off_802D4E4
off_802D4E4:
	.word sub_802D4F0+1
	.word sub_802D588+1
	.word sub_802D3CA+1
	thumb_func_end sub_802D4C6

	thumb_local_start
sub_802D4F0:
	push {r4,lr}
	ldrb r0, [r6,#8]
	cmp r0, #0
	bne loc_802D504
	mov r0, #1
	strb r0, [r6,#8]
	mov r0, #0x83
	add r0, #0xff
	bl PlaySoundEffect
loc_802D504:
	ldrh r0, [r6,#4]
	cmp r0, #3
	bgt loc_802D524
	bl sub_80E164A
	ldrb r2, [r5,#oBattleObject_Alliance]
	bl ifPanelFlagSetFindBattleActorWithCollisionOnPanelXY_80E7486
	mov r4, r0
	beq loc_802D524
	ldr r0, [r4,#oBattleObject_CollisionDataPtr]
	ldr r0, [r0,#oCollisionData_ObjectFlags1]
	mov r1, #1
	lsl r1, r1, #9
	tst r0, r1
	bne loc_802D56C
loc_802D524:
	mov r0, #0
	strh r0, [r6,#4]
	bl sub_802D5A8
	strh r0, [r7,#oAIAttackVars_Unk_14]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r4, r0
	ldrb r1, [r4,#0xc]
	strb r1, [r7,#oAIAttackVars_Unk_03]
	ldr r1, [r4,#0x10]
	str r1, [r7,#oAIAttackVars_Unk_0c]
	ldrh r1, [r4,#0x1a]
	strh r1, [r7,#oAIAttackVars_Damage]
	ldrb r1, [r4,#0xa]
	mov r0, #0x80
	orr r1, r0
	strh r1, [r7,#oAIAttackVars_Unk_0a]
	ldrh r0, [r7,#oAIAttackVars_Unk_14]
	ldr r1, dword_802D634 // =0x153 
	cmp r0, r1
	bne loc_802D55A
	// idx
	mov r0, #0x52 
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	ldrh r1, [r0,#0x1a]
	strh r1, [r7,#oAIAttackVars_Damage]
loc_802D55A:
	ldrb r0, [r4,#0xb]
	bl object_setAttack5
	ldrb r0, [r4,#0xf]
	strb r0, [r7,#oAIAttackVars_Unk_1d]
	mov r0, #8
	strh r0, [r6]
	mov r0, #1
	b locret_802D586
loc_802D56C:
	mov r0, #4
	strh r0, [r6]
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r1, #6
	cmp r0, #0xb
	beq loc_802D580
	cmp r0, #0xc
	bne loc_802D582
loc_802D580:
	mov r0, #2
loc_802D582:
	strh r0, [r6,#6]
	mov r0, #0
locret_802D586:
	pop {r4,pc}
	thumb_func_end sub_802D4F0

	thumb_local_start
sub_802D588:
	push {lr}
	ldrb r0, [r5,#oBattleObject_PanelY]
	bl battle_pickRandomRowObjectFields_810971A
	cmp r0, #0
	beq loc_802D5A0
	ldrh r0, [r6,#6]
	sub r0, #1
	strh r0, [r6,#6]
	beq loc_802D5A0
	mov r0, #2
	b locret_802D5A6
loc_802D5A0:
	mov r0, #8
	strh r0, [r6]
	mov r0, #0
locret_802D5A6:
	pop {pc}
	thumb_func_end sub_802D588

	thumb_local_start
sub_802D5A8:
	push {r4,r6,lr}
	mov r1, #0x3e 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	mov r1, #0x64 
	svc 6
	mov r1, #0
	cmp r0, #1
	ble loc_802D5C2
	sub r1, r0, #1
	cmp r1, #9
	ble loc_802D5C2
	mov r1, #9
loc_802D5C2:
	mov r6, r1
	mov r0, #6
	mul r0, r1
	ldr r4, off_802D5E0 // =byte_802D5E4
	add r4, r4, r0
	bl GetPositiveSignedRNG
	mov r1, #3
	cmp r6, #9
	bne loc_802D5D8
	mov r1, #6
loc_802D5D8:
	svc 6
	lsl r1, r1, #1
	ldrh r0, [r4,r1]
	pop {r4,r6,pc}
	.balign 4, 0
off_802D5E0:
	.word byte_802D5E4
byte_802D5E4:
	.byte 0x1, 0x0, 0x36, 0x0, 0x48, 0x0, 0x1, 0x0, 0x37, 0x0, 0x48, 0x0, 0x2
	.byte 0x0, 0x38, 0x0, 0x49, 0x0, 0xC, 0x0, 0x15, 0x0, 0x4C, 0x0, 0x3, 0x0
	.byte 0x19, 0x0, 0x4D, 0x0, 0xD, 0x0, 0x20, 0x0, 0x4E, 0x0, 0x10, 0x0, 0x29
	.byte 0x0, 0x4F, 0x0, 0xE, 0x0, 0x34, 0x0, 0x54, 0x0, 0xE, 0x0, 0x32, 0x0
	.byte 0x53, 0x1, 0x16, 0x0, 0x1A, 0x0, 0x21, 0x0, 0x2A, 0x0, 0x8, 0x0, 0x53
	.byte 0x1, 0x0, 0x0
dword_802D628:
	.word 0xFFFF
off_802D62C:
	.word byte_802D410
off_802D630:
	.word byte_802D420
dword_802D634:
	.word 0x153
	thumb_func_end sub_802D5A8

// symdb: Zero-fills the 32-byte work buffer at byte_2000070 (IWRAM), leaving r2/r3 untouched so it can be called through a function pointer with context.
// symdb: void memBlock_ClearWorkArea(int passthrough_r2, int passthrough_r3) /* inputs: r2, r3, lr;
// symdb: outputs: r2, r3 (unchanged); clobbers r0, r1, lr, NZCV */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/memBlock_ClearWorkArea_802D638.yaml
	thumb_func_start memBlock_ClearWorkArea_802D638
memBlock_ClearWorkArea_802D638:
	push {lr}
	// memBlock
	ldr r0, off_802D68C // =byte_2000070
	// size
	mov r1, #0x20 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end memBlock_ClearWorkArea_802D638

// symdb: Increments one byte-sized counter in an IWRAM array (byte_2000070) selected by index, saturating at 255 instead of wrapping.
// symdb: void sub_802D644(u32 index /* r0 */); returns r2 = incremented (possibly clamped) value, flags
// symdb: from cmp against 0xFF
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802D644.yaml
	thumb_func_start sub_802D644
sub_802D644:
	ldr r1, off_802D690 // =byte_2000070
	ldrb r2, [r1,r0]
	add r2, #1
	cmp r2, #0xff
	bgt locret_802D650
	strb r2, [r1,r0]
locret_802D650:
	mov pc, lr
	thumb_func_end sub_802D644

	thumb_func_start sub_802D652
sub_802D652:
	ldr r1, off_802D694 // =byte_2000070
	ldrb r0, [r1,r0]
	mov pc, lr
	thumb_func_end sub_802D652

	thumb_local_start
sub_802D658:
	ldr r2, off_802D698 // =byte_2000070
	strb r1, [r2,r0]
	mov pc, lr
	thumb_func_end sub_802D658

	thumb_func_start sub_802D65E
sub_802D65E:
	push {r4,lr}
	mov r4, r0
	movflag EVENT_1D8
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq locret_802D68A
	ldr r1, dword_802D69C // =0x196 
	add r1, r1, r4
	mov r0, r1
	bl TestEventFlag // (flag: u16) -> !zf
	bne locret_802D68A
	cmp r4, #0xd
	beq locret_802D68A
	cmp r4, #0xa
	beq locret_802D68A
	mov r0, #0
	mov r1, #0xa
	mov r2, r4
	bl sub_800AB2E
locret_802D68A:
	pop {r4,pc}
	.balign 4, 0
off_802D68C:
	.word byte_2000070
off_802D690:
	.word byte_2000070
off_802D694:
	.word byte_2000070
off_802D698:
	.word byte_2000070
dword_802D69C:
	.word 0x196
	thumb_func_end sub_802D65E

// symdb: Initialises the battle's player-tracking block at the start of a battle, caching pointers to the player's and enemy's side objects.
// symdb: void sub_802D6A0(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_initPlayerTracker_802D6A0.yaml
	thumb_func_start battle_initPlayerTracker_802D6A0
battle_initPlayerTracker_802D6A0:
	push {r5-r7,lr}
	ldr r5, off_802D6C0 // =dword_203C970 
	mov r0, #0
	str r0, [r5]
	mov r0, #0
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	str r0, [r5,#0x8] // (dword_203C978 - 0x203c970)
	mov r0, #1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	str r0, [r5,#0xc] // (dword_203C97C - 0x203c970)
	mov r0, #1
	strb r0, [r5,#0x4] // (byte_203C974 - 0x203c970)
	pop {r5-r7,pc}
	.balign 4, 0
off_802D6C0:
	.word dword_203C970
	thumb_func_end battle_initPlayerTracker_802D6A0

// symdb: Ticks a two-slot state machine stored at dword_203C970, advancing or polling its two child objects and returning the state byte at offset +4.
// symdb: void tick_stateMachine_802D6C4(void) /* returns u8 state in r0; NZ flags reflect that byte */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802D6C4.yaml
	thumb_func_start sub_802D6C4
sub_802D6C4:
	push {r5,lr}
	ldr r5, off_802D710 // =dword_203C970 
	ldrb r0, [r5,#0x3] // (dword_203C970+3 - 0x203c970)
	tst r0, r0
	bne loc_802D6F4
	ldr r0, [r5,#0x8] // (dword_203C978 - 0x203c970)
	bl sub_802DD1E
	tst r0, r0
	beq loc_802D6DE
	ldr r0, [r5,#0x8] // (dword_203C978 - 0x203c970)
	bl sub_802DD10
loc_802D6DE:
	ldr r0, [r5,#0xc] // (dword_203C97C - 0x203c970)
	bl sub_802DD1E
	tst r0, r0
	beq loc_802D6EE
	ldr r0, [r5,#0xc] // (dword_203C97C - 0x203c970)
	bl sub_802DD10
loc_802D6EE:
	mov r0, #4
	strb r0, [r5,#0x3] // (dword_203C970+3 - 0x203c970)
	b loc_802D70C
loc_802D6F4:
	ldr r0, [r5,#0x8] // (dword_203C978 - 0x203c970)
	bl sub_802DD4A
	tst r0, r0
	bne loc_802D70C
	ldr r0, [r5,#0xc] // (dword_203C97C - 0x203c970)
	bl sub_802DD4A
	tst r0, r0
	bne loc_802D70C
	mov r0, #0
	strb r0, [r5,#0x4] // (byte_203C974 - 0x203c970)
loc_802D70C:
	ldrb r0, [r5,#0x4] // (byte_203C974 - 0x203c970)
	pop {r5,pc}
	.balign 4, 0
off_802D710:
	.word dword_203C970
	thumb_func_end sub_802D6C4

	thumb_func_start sub_802D714
sub_802D714:
	push {lr}
	ldr r1, off_802D728 // =off_802D72C 
	ldrb r0, [r7,#oAIAttackVars_Unk_00]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	bl sub_801BCD0
	pop {pc}
	.balign 4, 0
off_802D728:
	.word off_802D72C
off_802D72C:
	.word sub_802D738+1
	.word sub_802D7A0+1
	.word sub_802D8F0+1
	thumb_func_end sub_802D714

	thumb_local_start
sub_802D738:
	push {lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_802D78A
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	mov r0, #0
	str r0, [r5,#oBattleObject_Z]
	bl object_updateCollisionPanels
	bl sub_800F46C
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl sub_800F2C6
	ldr r0, dword_802D798 // =0x1c41 
	bl object_clearFlag // (int bitfield) -> void
	ldr r1, dword_802D79C // =0x10 
	bl object_clearFlag2
	mov r0, #4
	bl object_setAnimation
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	mov r0, #1
	bl object_setCollisionRegion
	mov r0, #4
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_802D78A:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bgt locret_802D796
	mov r0, #4
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_802D796:
	pop {pc}
	.balign 4, 0
dword_802D798:
	.word 0x1C41
dword_802D79C:
	.word 0x10
	thumb_func_end sub_802D738

	thumb_local_start
sub_802D7A0:
	push {r4,lr}
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_8011384
	bl battle_getObjectNameID_8011020
	bl sub_80143A6
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x29 
	bl GetBattleNaviStats2034A60Byte
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	cmp r0, r1
	bne loc_802D7E8
	ldrh r2, [r5,#oBattleObject_HP]
	mov r1, #0x40 
	bl SetBattleNaviStatsHword_AllianceFromBattleObject
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	ldrb r1, [r5,#oBattleObject_Alliance]
	mov r2, #0x64 
	mul r2, r1
	ldr r1, off_802D8EC // =eBattleNaviStats2034A60 
	add r1, r1, r2
	mov r2, #0x64 
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
loc_802D7E8:
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x29 
	bl GetBattleNaviStats2034A60Byte
	push {r0}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl sub_802DCCC
	pop {r1}
	cmp r0, r1
	bne loc_802D81A
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	mov r1, r0
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r2, #0x64 
	mul r2, r0
	ldr r0, off_802D8EC // =eBattleNaviStats2034A60 
	add r0, r0, r2
	mov r2, #0x64 
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	b loc_802D822
loc_802D81A:
	mov r1, r0
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl init_8013B64 // (int idx, int a2) -> void
loc_802D822:
	bl sub_801393A
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte
	strb r0, [r4,#oAIData_AIIndex]
	add r0, #0xff
	add r0, #0xa1
	strh r0, [r5,#oBattleObject_NameID]
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
	mov r0, #3
	strb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl sub_801002C
	bl sprite_setPalette // (int pallete) -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_802D88C
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	bl sub_8011268
	b loc_802D890
loc_802D88C:
	bl battle_objectNameIdToPopupHandler_8010DD0
loc_802D890:
	bl battle_dispatchActorByTypeAndAIIdx_800F378
	bl battle_clearObjectStatusFlagsAndTimers_801A264
	bl sub_80143A6
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	bne loc_802D8B8
	mov r1, #0x42 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	push {r0}
	mov r1, #0x40 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	pop {r1}
	b loc_802D8C0
loc_802D8B8:
	ldrb r1, [r5,#oBattleObject_Alliance]
	bl sub_802DD70
	mov r1, r0
loc_802D8C0:
	strh r0, [r5,#oBattleObject_HP]
	strh r1, [r5,#oBattleObject_MaxHP]
	mov r0, #1
	bl sub_801E0D0
	bl battleRefreshTrackedObjectArmPos_801DBD4
	bl sub_800EA0E
	ldr r0, off_802DCA4 // =0x8000000 
	bl object_clearFlag // (int bitfield) -> void
	bl sub_801086C
	bl sub_8014216
	bl object_clearInvulnerableTime
	mov r0, #8
	strh r0, [r7,#oAIAttackVars_Unk_00]
	pop {r4,pc}
	.balign 4, 0
off_802D8EC:
	.word eBattleNaviStats2034A60
	thumb_func_end sub_802D7A0

	thumb_local_start
sub_802D8F0:
	push {lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_802D900
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_802D900:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_802D924
	mov r0, #0
	bl sub_801E0D0
	ldr r0, dword_802DCA8 // =0x4000 
	bl SetAIDataUnk0x48Flag
	ldr r0, off_802DCAC // =0x1800 
	bl ClearAIDataUnk0x48Flag
	ldr r0, dword_802DCB0 // =0x8600 
	bl ClearAIData_Unk_44_Flag
	bl object_exitAttackState
locret_802D924:
	pop {pc}
	thumb_func_end sub_802D8F0

	thumb_func_start sub_802D926
sub_802D926:
	push {lr}
	ldr r1, off_802D940 // =off_802D944 
	ldrb r0, [r7,#oAIAttackVars_Unk_00]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	ldrb r0, [r7,#oAIAttackVars_Unk_03]
	cmp r0, #0
	bne locret_802D93C
	bl sub_801BCD0
locret_802D93C:
	pop {pc}
	.balign 4, 0
off_802D940:
	.word off_802D944
off_802D944:
	.word sub_802D950+1
	.word sub_802D9B0+1
	.word sub_802DA78+1
	thumb_func_end sub_802D926

	thumb_local_start
sub_802D950:
	push {lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_802D9A2
	ldrb r0, [r5,#oBattleObject_FuturePanelX]
	strb r0, [r5,#oBattleObject_PanelX]
	ldrb r1, [r5,#oBattleObject_FuturePanelY]
	strb r1, [r5,#oBattleObject_PanelY]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	mov r0, #0
	str r0, [r5,#oBattleObject_Z]
	bl object_updateCollisionPanels
	bl sub_800F46C
	strb r0, [r5,#oBattleObject_DirectionFlip]
	bl sub_800F2C6
	ldr r0, dword_802DCB4 // =0x1c41 
	bl object_clearFlag // (int bitfield) -> void
	mov r1, #0x10
	bl object_clearFlag2
	mov r0, #4
	bl object_setAnimation
	mov r0, #0
	str r0, [r5,#oBattleObject_RelatedObject1Ptr]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	str r0, [r1,#oAIData_Unk_68]
	ldr r1, [r5,#oBattleObject_AIDataPtr]
	mov r0, #0
	str r0, [r1,#oAIData_Unk_5c]
	mov r0, #4
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_802D9A2:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bgt locret_802D9AE
	mov r0, #4
	strh r0, [r7,#oAIAttackVars_Unk_00]
locret_802D9AE:
	pop {pc}
	thumb_func_end sub_802D950

	thumb_local_start
sub_802D9B0:
	push {r4,lr}
	bl battle_getObjectNameID_8011020
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	mov r1, r0
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r2, #0x64 
	mul r2, r0
	ldr r0, off_802DCB8 // =eBattleNaviStats2034A60 
	add r0, r0, r2
	mov r2, #0x64 
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	ldr r4, [r5,#oBattleObject_AIDataPtr]
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte
	strb r0, [r4,#oAIData_AIIndex]
	add r0, #0xff
	add r0, #0xa1
	strh r0, [r5,#oBattleObject_NameID]
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
	mov r0, #3
	strb r0, [r5,#oBattleObject_CurAnim]
	strb r0, [r5,#oBattleObject_CurAnim]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl sub_801002C
	bl sprite_setPalette // (int pallete) -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl battle_objectNameIdToPopupHandler_8010DD0
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #0
	bl sub_8011268
	bl battle_clearObjectStatusFlagsAndTimers_801A264
	bl battle_beginTurnOpenProcess_80144C0
	bl sub_80143B4
	mov r1, #0x40 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	strh r0, [r5,#oBattleObject_HP]
	mov r1, #0x42 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	strh r0, [r5,#oBattleObject_MaxHP]
	mov r0, #1
	bl sub_801E0D0
	bl battleRefreshTrackedObjectArmPos_801DBD4
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl sub_80108FC
	bl sub_800EA0E
	ldr r0, off_802DCA4 // =0x8000000 
	bl object_clearFlag // (int bitfield) -> void
	bl sub_801086C
	bl sub_8014216
	bl object_clearInvulnerableTime
	mov r0, #8
	strh r0, [r7,#oAIAttackVars_Unk_00]
	pop {r4,pc}
	thumb_func_end sub_802D9B0

	thumb_local_start
sub_802DA78:
	push {lr}
	ldrb r0, [r7,#oAIAttackVars_Unk_01]
	tst r0, r0
	bne loc_802DA88
	mov r0, #0x14
	strh r0, [r7,#oAIAttackVars_Unk_10]
	mov r0, #4
	strb r0, [r7,#oAIAttackVars_Unk_01]
loc_802DA88:
	ldrh r0, [r7,#oAIAttackVars_Unk_10]
	sub r0, #1
	strh r0, [r7,#oAIAttackVars_Unk_10]
	bge locret_802DAA6
	mov r0, #0
	bl sub_801E0D0
	ldr r0, dword_802DCBC // =0x6800 
	bl ClearAIDataUnk0x48Flag
	ldr r0, dword_802DCC0 // =0x4008600 
	bl ClearAIData_Unk_44_Flag
	bl object_exitAttackState
locret_802DAA6:
	pop {pc}
	thumb_func_end sub_802DA78

	thumb_local_start
sub_802DAA8:
	push {lr}
	ldr r1, off_802DAB8 // =off_802DABC 
	ldrb r0, [r7]
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {pc}
	.balign 4, 0x00
off_802DAB8:
	.word off_802DABC
off_802DABC:
	.word sub_802DACC+1
	.word sub_802DB58+1
	.word sub_802DB80+1
	.word sub_802DC66+1
	thumb_func_end sub_802DAA8

	thumb_local_start
sub_802DACC:
	push {lr}
	bl sprite_forceWhitePalette
	ldrb r0, [r7,#1]
	tst r0, r0
	bne loc_802DB4A
	mov r0, #4
	bl battle_setFlags
	ldrb r0, [r5,#0x14]
	strb r0, [r5,#0x12]
	ldrb r1, [r5,#0x15]
	strb r1, [r5,#0x13]
	bl object_removePanelReserve
	bl object_setCoordinatesFromPanels // () -> void
	mov r0, #0
	str r0, [r5,#0x3c]
	bl object_updateCollisionPanels
	bl sub_800F46C
	strb r0, [r5,#0x17]
	bl sub_800F2C6
	ldrb r0, [r5,#0x14]
	ldrb r1, [r5,#0x15]
	bl object_reservePanel
	bl object_clearCollisionRegion // () -> void
	ldr r0, dword_802DCB4 // =0x1c41 
	bl object_clearFlag // (int bitfield) -> void
	mov r1, #0x10
	bl object_clearFlag2
	mov r0, #2
	bl object_setAnimation
	mov r0, #0x34 
	add r0, r0, r5
	ldmia r0!, {r1-r3}
	mov r4, #3
	bl spawn_t1_0x0_EffectObject
	bl spawn_t1_0x0_EffectObject
	mov r0, #0
	str r0, [r5,#0x4c]
	ldr r1, [r5,#0x58]
	str r0, [r1,#0x68]
	ldr r1, [r5,#0x58]
	mov r0, #0
	str r0, [r1,#0x5c]
	mov r0, #0x6c 
	bl PlaySoundEffect
	mov r0, #0xa
	strh r0, [r7,#0x10]
	mov r0, #4
	strb r0, [r7,#1]
loc_802DB4A:
	ldrh r0, [r7,#0x10]
	sub r0, #1
	strh r0, [r7,#0x10]
	bgt locret_802DB56
	mov r0, #4
	strh r0, [r7]
locret_802DB56:
	pop {pc}
	thumb_func_end sub_802DACC

	thumb_local_start
sub_802DB58:
	push {lr}
	bl sprite_forceWhitePalette
	ldrb r0, [r7,#1]
	tst r0, r0
	bne loc_802DB72
	mov r0, #4
	bl object_setAnimation
	mov r0, #4
	strh r0, [r7,#0x10]
	mov r0, #4
	strb r0, [r7,#1]
loc_802DB72:
	ldrh r0, [r7,#0x10]
	sub r0, #1
	strh r0, [r7,#0x10]
	bgt locret_802DB7E
	mov r0, #8
	strh r0, [r7]
locret_802DB7E:
	pop {pc}
	thumb_func_end sub_802DB58

	thumb_local_start
sub_802DB80:
	push {r4,lr}
	bl battle_getObjectNameID_8011020
	ldrb r0, [r5,#0x16]
	bl GetBattleNaviStatsAddr // (alliance: bool) -> * NaviStats
	mov r1, r0
	ldrb r0, [r5,#0x16]
	mov r2, #0x64 
	mul r2, r0
	ldr r0, off_802DCC4 // =eBattleNaviStats2034A60 
	add r0, r0, r2
	mov r2, #0x64 
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	ldr r4, [r5,#0x58]
	ldrb r0, [r5,#0x16]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte
	strb r0, [r4,#1]
	add r0, #0xff
	add r0, #0xa1
	strh r0, [r5,#0x28]
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
	mov r0, #3
	strb r0, [r5,#0x10]
	strb r0, [r5,#0x10]
	bl sprite_setAnimation // (u8 a1) -> void
	bl sprite_loadAnimationData // () -> void
	bl sub_801002C
	bl sprite_setPalette // (int pallete) -> void
	bl object_getFlip // () -> int
	bl sprite_setFlip
	bl battle_objectNameIdToPopupHandler_8010DD0
	mov r1, #0x2c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r2, #0
	bl sub_8011268
	bl battle_clearObjectStatusFlagsAndTimers_801A264
	bl battle_beginTurnOpenProcess_80144C0
	bl sub_80143B4
	mov r1, #0x40 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	strh r0, [r5,#0x24]
	mov r1, #0x42 
	bl GetBattleNaviStatsHword_AllianceFromBattleObject
	strh r0, [r5,#0x26]
	mov r0, #1
	bl sub_801E0D0
	bl battleRefreshTrackedObjectArmPos_801DBD4
	ldrb r0, [r5,#0x16]
	bl sub_80108FC
	bl sub_800EA0E
	bl sub_801A66C
	ldrb r0, [r5,#0x14]
	ldrb r1, [r5,#0x15]
	bl object_removePanelReserve
	ldr r0, off_802DCA4 // =0x8000000 
	bl object_clearFlag // (int bitfield) -> void
	bl sub_801086C
	bl sub_8014216
	bl object_clearInvulnerableTime
	ldrb r0, [r5,#0x16]
	bl battle_networkInvert
	tst r0, r0
	beq loc_802DC60
	mov r0, #0
	mov r1, #0
	bl sub_801DC7C
loc_802DC60:
	mov r0, #0xc
	strh r0, [r7]
	pop {r4,pc}
	thumb_func_end sub_802DB80

	thumb_local_start
sub_802DC66:
	push {lr}
	ldrb r0, [r7,#1]
	tst r0, r0
	bne loc_802DC7C
	mov r0, #1
	bl object_setCollisionRegion
	mov r0, #4
	strh r0, [r7,#0x10]
	mov r0, #4
	strb r0, [r7,#1]
loc_802DC7C:
	ldrh r0, [r7,#0x10]
	sub r0, #1
	strh r0, [r7,#0x10]
	bgt locret_802DCA0
	mov r0, #0
	bl sub_801E0D0
	ldr r0, dword_802DCBC // =0x6800 
	bl ClearAIDataUnk0x48Flag
	ldr r0, dword_802DCC8 // =0xc008600 
	bl ClearAIData_Unk_44_Flag
	mov r0, #4
	bl battle_clearFlags
	bl object_exitAttackState
locret_802DCA0:
	pop {pc}
	.balign 4, 0
off_802DCA4:
	.word 0x8000000
dword_802DCA8:
	.word 0x4000
off_802DCAC:
	.word 0x1800
dword_802DCB0:
	.word 0x8600
dword_802DCB4:
	.word 0x1C41
off_802DCB8:
	.word eBattleNaviStats2034A60
dword_802DCBC:
	.word 0x6800
dword_802DCC0:
	.word 0x4008600
off_802DCC4:
	.word eBattleNaviStats2034A60
dword_802DCC8:
	.word 0xC008600
	thumb_func_end sub_802DC66

	thumb_local_start
sub_802DCCC:
	mov r1, #0x10
	mul r0, r1
	ldr r1, off_802DE40 // =unk_203A980 
	add r1, r1, r0
	ldrb r0, [r1,#4]
	mov pc, lr
	thumb_func_end sub_802DCCC

	thumb_local_start
sub_802DCD8:
	ldr r1, off_802DE44 // =byte_203CED0
	strb r0, [r1,#0x4] // (dword_203CED4 - 0x203ced0)
	mov pc, lr
	thumb_func_end sub_802DCD8

	thumb_func_start sub_802DCDE
sub_802DCDE:
	push {r5,lr}
	mov r5, r0
	beq locret_802DCEA
	ldr r0, off_802DE48 // =0x4000000 
	bl SetAIData_Unk_44_Flag
locret_802DCEA:
	pop {r5,pc}
	thumb_func_end sub_802DCDE

// symdb: AI helper that reports whether a battler's AI data has either of two special state flags (0x1000 at +0x48 or 0x4000000 at +0x44) set.
// symdb: bool ai_CheckSpecialFlagPair_802DCEC(u32 aiIndex); // in: r0 = AI/battler parameter; out: r0 = 1
// symdb: if either flag is set, else 0; clobbers r1, r3, NZ; clears C and V; preserves caller's r5/r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ai_CheckSpecialFlagPair_802DCEC.yaml
	thumb_func_start ai_CheckSpecialFlagPair_802DCEC
ai_CheckSpecialFlagPair_802DCEC:
	push {r5,r7,lr}
	mov r7, #0
	mov r5, r0
	beq loc_802DD0C
	mov r7, #1
	bl GetAIDataUnk0x48Flag
	ldr r1, off_802DE4C // =0x1000 
	tst r0, r1
	bne loc_802DD0C
	bl GetAIData_Unk_44_Flag
	ldr r1, off_802DE48 // =0x4000000 
	tst r0, r1
	bne loc_802DD0C
	mov r7, #0
loc_802DD0C:
	mov r0, r7
	pop {r5,r7,pc}
	thumb_func_end ai_CheckSpecialFlagPair_802DCEC

	thumb_local_start
sub_802DD10:
	push {r5,lr}
	mov r5, r0
	beq locret_802DD1C
	ldr r0, off_802DE50 // =0x8000000 
	bl SetAIData_Unk_44_Flag
locret_802DD1C:
	pop {r5,pc}
	thumb_func_end sub_802DD10

// symdb: Vestigial stub that ignores its arguments and always returns 0 with Z set.
// symdb: int stub_802DD1E(void); // inputs: r0 (ignored), r5/r7 (preserved, never read); outputs: r0 = 0,
// symdb: N=0 Z=1 C=0 V=0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802DD1E.yaml
	thumb_local_start
sub_802DD1E:
	push {r5,r7,lr}
	mov r7, #0
	mov r5, r0
	beq loc_802DD26
loc_802DD26:
	mov r0, r7
	pop {r5,r7,pc}
	thumb_func_end sub_802DD1E

// symdb: Returns 1 only when the battle object's navi-stats alliance byte (0x29) is set AND the AI-data flag word has bit 0x4000 set, else 0.
// symdb: bool sub_802DD2A(BattleObject* obj /* r0 */); // out: r0 = 0/1, r1/r3 clobbered, flags set by
// symdb: final adds r0,r7,#0
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_isAllianceActiveAndAiFlag0x4000_802DD2A.yaml
	thumb_func_start battle_isAllianceActiveAndAiFlag0x4000_802DD2A
battle_isAllianceActiveAndAiFlag0x4000_802DD2A:
	push {r7,lr}
	mov r7, #0
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	cmp r0, #0
	beq loc_802DD46
	bl GetAIDataUnk0x48Flag
	ldr r1, dword_802DE54 // =0x4000 
	tst r0, r1
	beq loc_802DD46
	ldr r1, off_802DE58 // =0x2000 
	mov r7, #1
loc_802DD46:
	mov r0, r7
	pop {r7,pc}
	thumb_func_end battle_isAllianceActiveAndAiFlag0x4000_802DD2A

	thumb_local_start
sub_802DD4A:
	push {r5,lr}
	mov r5, r0
	beq locret_802DD60
	bl GetAIDataUnk0x48Flag
	mov r2, #0
	ldr r1, off_802DE58 // =0x2000 
	tst r0, r1
	beq loc_802DD5E
	mov r2, #1
loc_802DD5E:
	mov r0, r2
locret_802DD60:
	pop {r5,pc}
	thumb_func_end sub_802DD4A

	thumb_local_start
sub_802DD62:
	ldr r1, [r0,#0x58]
	ldrb r2, [r1,#0x18]
	tst r2, r2
	beq locret_802DD6E
	sub r2, #1
	strb r2, [r1,#0x18]
locret_802DD6E:
	mov pc, lr
	thumb_func_end sub_802DD62

	thumb_local_start
sub_802DD70:
	push {r4,lr}
	mov r4, #0xe
	mul r4, r0
	mov r0, r1
	add r0, r0, r0
	add r4, r4, r0
	ldr r1, off_802DD84 // =byte_802DD88
	ldrh r0, [r1,r4]
	pop {r4,pc}
	.balign 4, 0x00
off_802DD84:
	.word byte_802DD88
byte_802DD88:
	.byte 0xE7, 0x3, 0xE7, 0x3, 0xE7, 0x3, 0xE7, 0x3, 0xE7, 0x3, 0xE7
	.byte 0x3, 0xE7, 0x3, 0x64, 0x0, 0x96, 0x0, 0xB4, 0x0, 0xC8, 0x0
	.byte 0xE6, 0x0, 0xFA, 0x0, 0x2C, 0x1, 0x82, 0x0, 0x82, 0x0, 0x82
	.byte 0x0, 0x96, 0x0, 0xB4, 0x0, 0xC8, 0x0, 0xFA, 0x0, 0x96, 0x0
	.byte 0x96, 0x0, 0x96, 0x0, 0x96, 0x0, 0x96, 0x0, 0xB4, 0x0, 0xE6
	.byte 0x0, 0x96, 0x0, 0x96, 0x0, 0x96, 0x0, 0x96, 0x0, 0xB4, 0x0
	.byte 0xC8, 0x0, 0xFA, 0x0, 0xC8, 0x0, 0xC8, 0x0, 0xFA, 0x0, 0x18
	.byte 0x1, 0x2C, 0x1, 0x4A, 0x1, 0xC2, 0x1, 0x96, 0x0, 0x96, 0x0
	.byte 0x96, 0x0, 0x96, 0x0, 0x96, 0x0, 0x96, 0x0, 0xC8, 0x0, 0x64
	.byte 0x0, 0x96, 0x0, 0xB4, 0x0, 0xC8, 0x0, 0xE6, 0x0, 0xFA, 0x0
	.byte 0x2C, 0x1, 0x64, 0x0, 0x96, 0x0, 0x82, 0x0, 0x96, 0x0, 0xB4
	.byte 0x0, 0xC8, 0x0, 0xFA, 0x0, 0xB4, 0x0, 0xB4, 0x0, 0xB4, 0x0
	.byte 0xB4, 0x0, 0xB4, 0x0, 0xB4, 0x0, 0xE6, 0x0, 0x96, 0x0, 0x96
	.byte 0x0, 0x96, 0x0, 0x96, 0x0, 0xB4, 0x0, 0xC8, 0x0, 0xFA, 0x0
	.byte 0xC8, 0x0, 0xC8, 0x0, 0xFA, 0x0, 0x18, 0x1, 0x2C, 0x1, 0x4A
	.byte 0x1, 0xC2, 0x1, 0x96, 0x0, 0x96, 0x0, 0x96, 0x0, 0x96, 0x0
	.byte 0x96, 0x0, 0x96, 0x0, 0xC8, 0x0, 0x0, 0x0
off_802DE40:
	.word unk_203A980
off_802DE44:
	.word byte_203CED0
off_802DE48:
	.word 0x4000000
off_802DE4C:
	.word 0x1000
off_802DE50:
	.word 0x8000000
dword_802DE54:
	.word 0x4000
off_802DE58:
	.word 0x2000
	thumb_func_end sub_802DD70

// symdb: When test-battle flag 0x40 is set, runs the sub_802E2C4 handler for indices 0 and 1; otherwise does nothing.
// symdb: void sub_802DE5C(void)
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802DE5C.yaml
	thumb_func_start sub_802DE5C
sub_802DE5C:
	push {lr}
	bl TestBattleFlag_0x40
	beq locret_802DE70
	mov r0, #0
	bl sub_802E2C4
	mov r0, #1
	bl sub_802E2C4
locret_802DE70:
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_802DE5C

	thumb_local_start
sub_802DE74:
	push {r7,lr}
	ldrb r0, [r5,#0x16]
	bl getBattleHandAddr_8010018
	mov r7, r0
	ldrb r0, [r7,#1]
	tst r0, r0
	beq loc_802DEA0
	sub r0, #1
	strb r0, [r7,#1]
	add r2, r7, #2
	mov r3, #0
loc_802DE8C:
	ldrh r0, [r2,#2]
	strh r0, [r2]
	ldrh r0, [r2,#0xe]
	strh r0, [r2,#0xc]
	ldrh r0, [r2,#0x1a]
	strh r0, [r2,#0x18]
	add r2, #2
	add r3, #1
	cmp r3, #5
	blt loc_802DE8C
loc_802DEA0:
	ldrb r0, [r5,#0x16]
	bl getEntryPtr_2036120_1D0_802E070
	mov r1, #1
	mov r2, #0x53 
	strb r1, [r0,r2]
	pop {r7,pc}
	thumb_func_end sub_802DE74

	thumb_local_start
sub_802DEAE:
	push {r4,lr}
	ldr r4, dword_802DED0 // =0xffff 
	ldr r1, [r5,#0x58]
	ldrb r1, [r1,#0x19]
	tst r1, r1
	bne loc_802DECC
	bl object_getFlag // () -> int
	ldr r1, off_802DED4 // =0x1000 
	tst r0, r1
	bne loc_802DECC
	ldrb r0, [r5,#0x16]
	bl getBattleHandAddr_8010018
	ldrh r4, [r0,#2]
loc_802DECC:
	mov r0, r4
	pop {r4,pc}
	.balign 4, 0
dword_802DED0:
	.word 0xFFFF
off_802DED4:
	.word 0x1000
	thumb_func_end sub_802DEAE

	thumb_local_start
sub_802DED8:
	push {r4,r6,r7,lr}
	ldrb r0, [r5,#0x16]
	bl getEntryPtr_2036120_1D0_802E070
	mov r6, r0
	ldrb r0, [r5,#0x16]
	bl getBattleHandAddr_8010018
	ldrh r2, [r0,#0x1a]
	ldrh r1, [r0,#0xe]
	ldrh r0, [r0,#2]
	ldr r3, dword_802DF30 // =0xffff 
	cmp r0, r3
	beq locret_802DF2E
	push {r0}
	mov r7, r2
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r4, r0
	ldrb r0, [r4,#9]
	mov r1, #2
	tst r0, r1
	beq loc_802DF14
	ldrh r3, [r6,#0x36]
	add r7, r7, r3
	mov r1, #4
	tst r0, r1
	beq loc_802DF14
	ldrh r3, [r6,#0x38]
	add r7, r7, r3
loc_802DF14:
	mov r2, r7
	pop {r0}
	push {r0,r2}
	ldrb r1, [r5,#0x16]
	bl sub_80109A4
	mov r1, r0
	pop {r0,r2}
	push {r0-r2}
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r3, r0
	pop {r0-r2}
locret_802DF2E:
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_802DF30:
	.word 0xFFFF
	thumb_func_end sub_802DED8

	thumb_local_start
sub_802DF34:
	push {r4,r7,lr}
	push {r1,r2}
	ldr r7, [r5,#0x58]
	add r7, #0xa0
	strh r0, [r7,#0x14]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r4, r0
	pop {r1,r2}
	strh r1, [r7,#8]
	strh r2, [r7,#6]
	ldrb r1, [r0,#0xa]
	strh r1, [r7,#0xa]
	ldrh r1, [r0,#4]
	strh r1, [r7,#2]
	ldr r1, [r0,#0x10]
	str r1, [r7,#0xc]
	ldrb r1, [r0,#0xc]
	strb r1, [r7,#3]
	ldrb r1, [r0,#0x14]
	strb r1, [r7,#5]
	mov r1, #0
	strh r1, [r7]
	strb r1, [r7,#4]
	ldrb r0, [r0,#0xb]
	bl object_setAttack0
	mov r0, #0x40 
	bl dispatch_801DACC // (a0: flags32) -> ()
	ldrb r0, [r5,#0x16]
	ldrh r1, [r7,#0x14]
	bl incrementRecordCounterByte_8021D14
	ldrb r0, [r4,#9]
	mov r1, #4
	tst r0, r1
	beq locret_802DF8A
	ldrb r0, [r5,#0x16]
	mov r1, #6
	mov r2, #1
	bl tableAddSaturatedByte_800AB46
locret_802DF8A:
	pop {r4,r7,pc}
	thumb_func_end sub_802DF34

	thumb_local_start
sub_802DF8C:
	push {r7,lr}
	push {r1,r2}
	ldr r7, [r5,#0x58]
	add r7, #0xa0
	strh r0, [r7,#0x14]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	pop {r1,r2}
	strh r1, [r7,#8]
	strh r2, [r7,#6]
	ldrb r1, [r0,#0xa]
	strh r1, [r7,#0xa]
	ldrh r1, [r0,#4]
	strh r1, [r7,#2]
	ldr r1, [r0,#0x10]
	str r1, [r7,#0xc]
	ldrb r1, [r0,#0xc]
	strb r1, [r7,#3]
	ldrb r1, [r0,#0x14]
	strb r1, [r7,#5]
	mov r1, #0
	strh r1, [r7]
	strb r1, [r7,#4]
	ldrb r0, [r0,#0xb]
	bl object_setAttack0
	mov r0, #0x40 
	bl dispatch_801DACC // (a0: flags32) -> ()
	pop {r7,pc}
	thumb_func_end sub_802DF8C

// symdb: Allocates and zero-fills the per-alliance entry in the shared 0x1D0-byte entry pool for a battle object's alliance, and if battle flag 0x40 is set, initializes it as an active kind-3 entry anchored at the object's panel X and notifies sub_802E07C.
// symdb: void battle_setupAllianceEntryKind3(BattleObject* obj /* r5 */); // no meaningful return value;
// symdb: r4 ends up holding the new entry pointer per the readable C, though the contract lists r4 as
// symdb: preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_setupAllianceEntryKind3_802DFC8.yaml
	thumb_func_start battle_setupAllianceEntryKind3_802DFC8
battle_setupAllianceEntryKind3_802DFC8:
	push {r4,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	mov r4, r0
	mov r1, #0xe8
	// size
	add r1, r1, r1
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	bl battle_testFlag0x40_800A8F8
	beq locret_802DFFA
	mov r0, #1
	strb r0, [r4]
	mov r0, #0xff
	strb r0, [r4,#0xb]
	mov r0, #1
	strb r0, [r4,#0x10]
	ldrb r0, [r5,#oBattleObject_PanelX]
	strb r0, [r4,#0x11]
	mov r0, #3
	strb r0, [r4,#0xe]
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl sub_802E07C
locret_802DFFA:
	pop {r4,pc}
	thumb_func_end battle_setupAllianceEntryKind3_802DFC8

// symdb: Clears the battle work buffer and hooks up the battle object table at the start of battle setup.
// symdb: void battle_initWorkArea(void) /* preserves and returns r2/r3/r4 untouched */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_initWorkArea_802DFFC.yaml
	thumb_func_start battle_initWorkArea_802DFFC
battle_initWorkArea_802DFFC:
	push {r4,lr}

	// memBlock
	ldr r0, off_802E208 // =unk_2036120 
	mov r1, #0xe8
	lsl r1, r1, #2
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()

	ldr r0, off_802E20C // =eT1BattleObject0 
	ldr r1, off_802E210 // =unk_20362F0 
	str r0, [r1,#0x44] // (dword_2036334 - 0x20362f0)

	bl zeroFill_802E544

	pop {r4,pc}
	thumb_func_end battle_initWorkArea_802DFFC

	thumb_func_start zeroFill_802E014
zeroFill_802E014:
	push {r4,lr}

	// memBlock
	ldr r0, off_802E214 // =unk_2036120 
	// size
	mov r1, #0x60 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()

	// memBlock
	ldr r0, off_802E218 // =unk_20362F0 
	// size
	mov r1, #0x60 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()

	ldr r0, off_802E21C // =eT1BattleObject0 
	ldr r1, off_802E220 // =unk_20362F0 
	str r0, [r1,#0x44] // (dword_2036334 - 0x20362f0)

	bl zeroFill_802E544

	pop {r4,pc}
	thumb_func_end zeroFill_802E014

	thumb_func_start sub_802E032
sub_802E032:
	push {lr}
	push {r1}
	bl getEntryPtr_2036120_1D0_802E070
	pop {r1}
	mov r2, r0
	ldrh r0, [r2,#0x28]
	add r0, r0, r1
	ldr r1, dword_802E224 // =0x4000 
	cmp r0, r1
	ble loc_802E04A
	mov r0, r1
loc_802E04A:
	strh r0, [r2,#0x28]
	pop {pc}
	thumb_func_end sub_802E032

	thumb_func_start sub_802E04E
sub_802E04E:
	push {lr}
	push {r1}
	bl getEntryPtr_2036120_1D0_802E070
	pop {r1}
	mov r2, r0
	ldrh r0, [r2,#0x28]
	sub r0, r0, r1
	bge loc_802E062
	mov r0, #0
loc_802E062:
	strh r0, [r2,#0x28]
	pop {pc}
	thumb_func_end sub_802E04E

	thumb_func_start sub_802E066
sub_802E066:
	push {lr}
	bl getEntryPtr_2036120_1D0_802E070
	ldrh r0, [r0,#0x28]
	pop {pc}
	thumb_func_end sub_802E066

// symdb: Computes the address of entry `r0` of a fixed-stride (0x1D0-byte) record array based at unk_2036120, returning it in r0 with the array base in r1.
// symdb: void* getEntryPtr_2036120_1D0(u32 index /* r0 */); // also leaves r1 = array base (unk_2036120),
// symdb: sets NZCV from the final address addition
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getEntryPtr_2036120_1D0_802E070.yaml
	thumb_func_start getEntryPtr_2036120_1D0_802E070
getEntryPtr_2036120_1D0_802E070:
	mov r1, #0xe8
	add r1, r1, r1
	mul r0, r1
	ldr r1, off_802E228 // =unk_2036120 
	add r0, r0, r1
	mov pc, lr
	thumb_func_end getEntryPtr_2036120_1D0_802E070

	thumb_local_start
sub_802E07C:
	push {lr}
	bl getEntryPtr_2036120_1D0_802E070
	mov r1, #0
	strb r1, [r0,#3]
	strh r1, [r0,#0x2a]
	mov r2, #0x50 
	strb r1, [r0,r2]
	mvn r1, r1
	str r1, [r0,#0x18]
	str r1, [r0,#0x1c]
	str r1, [r0,#0x20]
	mov r1, #0xb4
	strb r1, [r0,#2]
	pop {pc}
	thumb_func_end sub_802E07C

// symdb: Tests whether the 0x40 bit of the current battle flags word is set, returning the masked result so callers can branch on it directly.
// symdb: int battle_testFlag0x40(u32 ctx /* passed in r10, forwarded to battle_getFlags */); returns
// symdb: nonzero (the masked 0x40 bit) in r0 when the flag is set, 0 otherwise; also sets NZ flags from
// symdb: the result; r1 clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/TestBattleFlag_0x40.yaml
	thumb_func_start TestBattleFlag_0x40
TestBattleFlag_0x40:
	push {lr}
	bl battle_getFlags
	mov r1, #0x40 
	and r0, r1
	pop {pc}
	thumb_func_end TestBattleFlag_0x40

	thumb_local_start
sub_802E0A6:
	push {lr}
	bl GetPositiveSignedRNG
	mov r4, #7
	and r4, r0
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r1, off_802E0C0 // =byte_802E0C4
	ldrb r0, [r1,r0]
	add r0, r0, r4
	pop {pc}
	.balign 4, 0
off_802E0C0:
	.word byte_802E0C4
byte_802E0C4:
	.byte 0xC, 0x5, 0x1E, 0xA, 0x5, 0xF, 0x14, 0x3, 0x14, 0x1E, 0x1E
	.byte 0xA, 0x28, 0x0, 0x0, 0x0
	thumb_func_end sub_802E0A6

	thumb_local_start
sub_802E0D4:
	push {r7,lr}
	ldr r7, [r5,#0x58]
	add r7, #0xa0
	push {r0-r2}
	mov r1, #0x29
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r3, r0
	pop {r0-r2}
	strb r0, [r7,#0x16]
	strb r1, [r7,#0x17]
	strh r2, [r7,#0x18]
	mov r0, #2
	strb r0, [r7,#3]
	mov r0, #0x10
	bl object_setAttack4
	bl aiAttack_stepStateMachine_80EB04C
	pop {r7,pc}
	strb r0, [r7,#0x16]
	strb r1, [r7,#0x17]
	strh r2, [r7,#0x18]
	mov r0, #2
	strb r0, [r7,#3]
	mov r0, #0x3f
	bl object_setAttack4
	bl sub_80EB234
	pop {r7,pc}
	thumb_func_end sub_802E0D4

// symdb: Sets battle flag 0x40 when the current battle is a network-style "gate" fight (gate-byte nonzero, or network battle with event flag 0x1722 set), skipping crossover, tomahawk/dustman minigames, virus battler, and while the 0x200000 battle effect is active.
// symdb: void sub_802E112(void); /* uses r10/lr from caller, clobbers nzcv r0-r3 lr */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802E112.yaml
	thumb_func_start sub_802E112
sub_802E112:
	push {lr}
	bl GetBattleMode
	cmp r0, #1 // crossover
	beq locret_802E154
	cmp r0, #7 // tomahawk minigame
	beq locret_802E154
	cmp r0, #9 // dustman minigame
	beq locret_802E154
	cmp r0, #6 // virus battler
	beq locret_802E154
	bl GetBattleEffects // () -> int
	// ???
	ldr r1, dword_802E22C // =0x200000 
	tst r0, r1
	bne locret_802E154
	bl notZero_eByte200AD04
	cmp r0, #0
	bne loc_802E14E
	bl GetBattleEffects // () -> int
	mov r1, #8 // network battle
	tst r0, r1
	beq locret_802E154
	movflag EVENT_1722_BEAST_LINK_GATE_RELATED
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq locret_802E154
loc_802E14E:
	mov r0, #0x40 
	bl battle_setFlags
locret_802E154:
	pop {pc}
	thumb_func_end sub_802E112

// symdb: If battle flag 0x40 is set, refreshes the custom-gauge display using the matched AI entry's CustomGauge field.
// symdb: (no caller-visible inputs; uses r10 = Toolkit) -> no return value; side effects: may call
// symdb: SetCustGauge to refresh the custom gauge
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_updateCustGaugeFromAI_802E156.yaml
	thumb_func_start battle_updateCustGaugeFromAI_802E156
battle_updateCustGaugeFromAI_802E156:
	push {r4,lr}
	bl TestBattleFlag_0x40
	beq locret_802E170
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	bl getEntryPtr_2036120_1D0_802E070
	mov r4, r0
	ldrh r0, [r0,#0x28]
	bl SetCustGauge
locret_802E170:
	pop {r4,pc}
	.balign 4, 0
	.word DebugStr802E180
	.word DebugStr802E187
	.word DebugStr802E1A2
DebugStr802E180:
	.hword 0x20D
	.asciz "%04x"
DebugStr802E187:
	.hword 0x219
	.ascii "%04x\n"
	.ascii "%04x\n"
	.ascii "%04x\n"
	.ascii "%04x\n"
	.asciz "%04x"
DebugStr802E1A2:
	.hword 0x814
	.asciz "%02x,%02x,%04x"
	.byte 0x0
	thumb_func_end battle_updateCustGaugeFromAI_802E156

	thumb_local_start
sub_802E1B4:
	ldr r2, off_802E230 // =0x139 
	cmp r0, r2
	ble locret_802E1BC
	mov r0, #0
locret_802E1BC:
	mov pc, lr
	thumb_func_end sub_802E1B4

	thumb_func_start sub_802E1BE
sub_802E1BE:
	push {r7,lr}
	ldr r7, off_802E234 // =0x1e0 
	bl battle_testFlag0x40_800A8F8
	tst r0, r0
	beq loc_802E1CC
	ldr r7, off_802E238 // =0x168 
loc_802E1CC:
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	strb r4, [r0,#0xb]
	strh r7, [r0,#0x2e]
	pop {r7,pc}
	thumb_func_end sub_802E1BE

// symdb: Ticks down (by one per call) the halfword timer at +0x30 of the record sub_802E070 looks up for the given battle object's alliance, and returns the new timer value in r1.
// symdb: u16 battle_DecrementAllianceTimer(void) /* caller sets r5 = battle object ptr; returns r1 =
// symdb: timer after decrement (0 if already 0); clobbers r0, flags, lr */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_DecrementAllianceTimer_802E1D8.yaml
	thumb_func_start battle_DecrementAllianceTimer_802E1D8
battle_DecrementAllianceTimer_802E1D8:
	push {lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	ldrh r1, [r0,#0x30]
	cmp r1, #0
	beq locret_802E1EA
	sub r1, #1
	strh r1, [r0,#0x30]
locret_802E1EA:
	pop {pc}
	thumb_func_end battle_DecrementAllianceTimer_802E1D8

	thumb_local_start
sub_802E1EC:
	push {lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	mov r1, #0
	mov r2, #0x40 
	strb r1, [r0,r2]
	mov r2, #0x41 
	strb r1, [r0,r2]
	ldr r0, dword_802E23C // =0x1f00000 
	bl ClearAIData_Unk_44_Flag
	pop {pc}
	.balign 4, 0
off_802E208:
	.word unk_2036120
off_802E20C:
	.word eT1BattleObject0
off_802E210:
	.word unk_20362F0
off_802E214:
	.word unk_2036120
off_802E218:
	.word unk_20362F0
off_802E21C:
	.word eT1BattleObject0
off_802E220:
	.word unk_20362F0
dword_802E224:
	.word 0x4000
off_802E228:
	.word unk_2036120
dword_802E22C:
	.word 0x200000
off_802E230:
	.word 0x139
off_802E234:
	.word 0x1E0
off_802E238:
	.word 0x168
dword_802E23C:
	.word 0x1F00000
	thumb_func_end sub_802E1EC

// symdb: Copies one 0x3C-halfword palette entry, selected by index from a pointer table, into the palette buffer at unk_2008170.
// symdb: void loadIndexedPaletteToBuffer(int index /*r0*/); // preserves r3; clobbers r0-r2, flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/loadIndexedPaletteToBuffer_802E240.yaml
	thumb_func_start loadIndexedPaletteToBuffer_802E240
loadIndexedPaletteToBuffer_802E240:
	push {lr}
	lsl r0, r0, #2
	ldr r1, off_802E25C // =off_802E260 
	// src
	ldr r0, [r1,r0]
	// dest
	ldr r1, off_802E280 // =unk_2008170 
	// halfwordCount
	mov r2, #0x3c 
	bl CopyHalfwords // (u16 *src, u16 *dest, int halfwordCount) -> void
	pop {pc}
	thumb_func_end loadIndexedPaletteToBuffer_802E240

	thumb_local_start
sub_802E252:
	lsl r0, r0, #2
	ldr r1, off_802E25C // =off_802E260 
	ldr r0, [r1,r0]
	mov pc, lr
	.balign 4, 0x00
off_802E25C:
	.word off_802E260
off_802E260:
	.word byte_802167C
	.word byte_8021820
	.word byte_802185C
	.word byte_8021898
	.word byte_80218D4
	.word byte_8021910
	.word byte_802194C
	.word byte_8021988
off_802E280:
	.word unk_2008170
	thumb_func_end sub_802E252

	thumb_local_start
sub_802E284:
	lsl r0, r0, #2
	ldr r1, off_802E28C // =off_802E290 
	ldr r0, [r1,r0]
	mov pc, lr
off_802E28C:
	.word off_802E290
off_802E290:
	.word byte_802167C
	.word byte_80216B8
	.word byte_80216F4
	.word byte_8021730
	.word byte_802176C
	.word byte_80217A8
	.word byte_80217E4
	.word byte_8021820
	.word byte_802185C
	.word byte_8021898
	.word byte_80218D4
	.word byte_8021910
	.word byte_802194C
	thumb_func_end sub_802E284

	thumb_local_start
sub_802E2C4:
	push {r4-r7,lr}
	sub sp, sp, #4
	mov r6, r0
	bl getEntryPtr_2036120_1D0_802E070
	mov r7, r0
	ldrb r0, [r7]
	tst r0, r0
	bne loc_802E2D8
	b loc_802E40A
loc_802E2D8:
	mov r0, r6
	bl sub_802E558
	str r1, [sp]
	ldr r1, dword_802E428 // =0x1ff 
	and r0, r1
	strh r0, [r7,#0x24]
	bl battle_isPaused
	tst r0, r0
	beq loc_802E2F0
	b loc_802E406
loc_802E2F0:
	bl battle_isTimeStop
	beq loc_802E2F8
	b loc_802E406
loc_802E2F8:
	mov r0, r6
	bl sub_802E69C
	mov r1, r0
	mov r0, r6
	bl sub_802E032
	bl battle_isBattleOver
	tst r0, r0
	beq loc_802E310
	b loc_802E406
loc_802E310:
	mov r4, #1
	mov r0, #0x50 
	ldrb r0, [r7,r0]
	tst r0, r0
	bne loc_802E31C
	mov r4, #0
loc_802E31C:
	ldrh r0, [r7,#0x24]
	tst r0, r0
	bne loc_802E324
	b loc_802E406
loc_802E324:
	ldrh r1, [r7,#0x26]
	cmp r0, r1
	bne loc_802E32C
	b loc_802E406
loc_802E32C:
	// idx
	ldrh r0, [r7,#0x24]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r5, r0
	tst r4, r4
	bne loc_802E396
	ldrb r0, [r5,#9]
	mov r1, #0x20 
	tst r0, r1
	beq loc_802E344
	mov r0, #1
	b loc_802E346
loc_802E344:
	ldrb r0, [r5,#7]
loc_802E346:
	add r0, r0, r0
	ldr r1, off_802E414 // =byte_802E430 
	ldrh r2, [r1,r0]
	ldrh r1, [r7,#0x28]
	cmp r1, r2
	blt loc_802E37A
	ldr r0, [sp]
	cmp r0, #0
	bne loc_802E366
	mov r0, r6
	ldrh r1, [r7,#0x24]
	bl sub_802E82A
	cmp r0, #0xff
	bne loc_802E366
	b loc_802E37A
loc_802E366:
	ldrh r1, [r7,#0x24]
	mov r0, r6
	ldr r2, [sp]
	bl sub_802E62A
	tst r0, r0
	beq loc_802E37A
	b loc_802E406
	mov r1, #0
	b loc_802E37C
loc_802E37A:
	mov r1, #1
loc_802E37C:
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0,#oBattleState_Unk_0d]
	cmp r0, r6
	bne loc_802E406
	tst r1, r1
	beq loc_802E390
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
loc_802E390:
	bl sub_801EC44
	b loc_802E406
loc_802E396:
	ldrh r0, [r7,#0x28]
	ldr r1, off_802E418 // =0x1500 
	cmp r0, r1
	blt loc_802E37A
	ldr r2, [sp]
	cmp r2, #0
	bne loc_802E3C2
	mov r0, r6
	ldrh r1, [r7,#0x24]
	bl sub_802E830
	cmp r0, #0xff
	beq loc_802E406
	push {r0}
	mov r0, r6
	bl battle_networkInvert
	tst r0, r0
	pop {r0}
	bne loc_802E3C2
	bl sub_801E2BA
loc_802E3C2:
	ldrh r1, [r7,#0x24]
	mov r0, r6
	ldr r2, [sp]
	bl sub_802E5FC
	push {r4}
	mov r0, r6
	bl battle_networkInvert
	mov r1, r0
	mov r0, #0x18
	add r0, r0, r7
	mov r4, r6
	bl sub_8029514
	pop {r4}
	strh r0, [r7,#0x2a]
	strb r1, [r7,#4]
	strb r2, [r7,#5]
	tst r0, r0
	beq loc_802E402
	mov r0, r6
	ldrh r1, [r7,#0x2a]
	ldr r2, [sp]
	bl sub_802E62A
	mov r0, r6
	bl sub_802E07C
	mov r0, #0
	strh r0, [r7,#0x28]
	b loc_802E406
loc_802E402:
	mov r0, #0xb4
	strb r0, [r7,#2]
loc_802E406:
	ldrh r0, [r7,#0x24]
	strh r0, [r7,#0x26]
loc_802E40A:
	mov r0, r6
	bl sub_802E790
	add sp, sp, #4
	pop {r4-r7,pc}
	.balign 4, 0
off_802E414:
	.word byte_802E430
off_802E418:
	.word 0x1500
	.word byte_802E43A
	.word 0x4
	.word 0x8
dword_802E428:
	.word 0x1FF
	.word word_200F3C4
byte_802E430:
	.byte 0x0, 0x15, 0x0, 0x2A, 0x0, 0x40, 0xFF, 0xFF, 0xFF, 0xFF
byte_802E43A:
	.byte 0x1, 0x1, 0x1, 0x0, 0x0, 0x0
	thumb_func_end sub_802E2C4

	thumb_func_start sub_802E440
sub_802E440:
	push {lr}
	bl sub_802E490
	ldrh r0, [r0]
	pop {pc}
	thumb_func_end sub_802E440

	thumb_func_start sub_802E44A
sub_802E44A:
	push {lr}
	bl sub_802E490
	ldrh r0, [r0,#2]
	pop {pc}
	thumb_func_end sub_802E44A

	thumb_func_start sub_802E454
sub_802E454:
	push {lr}
	bl sub_802E490
	ldrh r0, [r0,#4]
	pop {pc}
	thumb_func_end sub_802E454

	thumb_func_start sub_802E45E
sub_802E45E:
	push {r4,r5,lr}
	mov r4, r1
	bl sub_802E490
	mov r5, r0
	add r0, #6
	mov r1, #0x3c 
	ldr r2, dword_802E48C // =0xffff 
	bl HalfwordFill
	ldrh r0, [r4]
	strh r0, [r5]
	ldrh r0, [r4,#2]
	strh r0, [r5,#2]
	ldrh r0, [r4,#4]
	strh r0, [r5,#4]
	// src
	add r0, r4, #6
	// dest
	add r1, r5, #6
	// halfwordCount
	mov r2, #0x36 
	bl CopyHalfwords // (u16 *src, u16 *dest, int halfwordCount) -> void
	pop {r4,r5,pc}
	.balign 4, 0
dword_802E48C:
	.word 0xFFFF
	thumb_func_end sub_802E45E

	thumb_local_start
sub_802E490:
	mov r1, #0x42 
	mul r0, r1
	ldr r1, off_802E49C // =byte_203CA80 
	add r0, r0, r1
	mov pc, lr
	.balign 4, 0x00
off_802E49C:
	.word byte_203CA80
	thumb_func_end sub_802E490

	thumb_local_start
sub_802E4A0:
	push {r6,lr}
	ldr r1, [r5,#0x58]
	mov r0, #0
	strb r0, [r1,#0x1e]
	bl sub_8012EA8
	ldr r0, dword_802E4B4 // =0x40000 
	bl ClearAIData_Unk_44_Flag
	pop {r6,pc}
	.balign 4, 0
dword_802E4B4:
	.word 0x40000
	thumb_func_end sub_802E4A0

// symdb: Looks up the battle object's alliance entry and returns a status code depending on which flag bytes are set in it.
// symdb: // in: r5 = battle object ptr (oBattleObject_Alliance read) // out: r0 = status code (9, 0xD, or
// symdb: 1); r1 = 0x54 left behind on the +0x54-check paths // clobbers: NZCV; r7 preserved
// symdb: (pushed/popped) int getAllianceEntryStatus(void /* r5=this */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getAllianceEntryStatus_802E4B8.yaml
	thumb_func_start battle_getAllianceEntryStatus_802E4B8
battle_getAllianceEntryStatus_802E4B8:
	push {r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	mov r7, r0
	mov r0, #0x50 
	ldrb r0, [r7,r0]
	tst r0, r0
	beq loc_802E4CE
	mov r0, #9
	pop {r7,pc}
loc_802E4CE:
	mov r1, #0x54 
	ldrb r0, [r7,r1]
	tst r0, r0
	beq loc_802E4DA
	mov r0, #0xd
	pop {r7,pc}
loc_802E4DA:
	mov r0, #1
	pop {r7,pc}
	.byte 0, 0
	.word 0xA000
	thumb_func_end battle_getAllianceEntryStatus_802E4B8

// symdb: Consumes two one-shot AI-data flag triggers (0x02000000 and 0x20000000) for a battle object, applying them as a timer-set on its alliance's panel/entry and as an indefinite invulnerability on the object itself.
// symdb: void sub_802E4E4(u32 /*battle object*/ r5); clobbers nz, c, v, r0, r1, r2, r3, lr; preserves r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802E4E4.yaml
	thumb_func_start sub_802E4E4
sub_802E4E4:
	push {r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	mov r7, r0
	bl GetAIData_Unk_44_Flag
	ldr r1, off_802E534 // =timer_2000000 
	tst r0, r1
	beq loc_802E508
	mov r0, r1
	bl ClearAIData_Unk_44_Flag
	mov r0, #1
	mov r1, #0x50 
	strb r0, [r7,r1]
	bl sub_802E1EC
loc_802E508:
	bl GetAIData_Unk_44_Flag
	ldr r1, dword_802E538 // =0x20000000 
	tst r0, r1
	beq locret_802E530
	mov r0, r1
	bl ClearAIData_Unk_44_Flag
	mov r0, #1
	mov r1, #0x54 
	strb r0, [r7,r1]
	bl sub_802E1EC
	ldr r0, off_802E53C // =0x1e0 
	strh r0, [r7,#0x30]
	ldr r0, dword_802E540 // =0xffff 
	bl object_setInvulnerableTime
	bl sub_802D310
locret_802E530:
	pop {r7,pc}
	.byte 0x0, 0x0
	.balign 4, 0
off_802E534:
	.word timer_2000000
dword_802E538:
	.word 0x20000000
off_802E53C:
	.word 0x1E0
dword_802E540:
	.word 0xFFFF
	thumb_func_end sub_802E4E4

// symdb: Zero-fills the fixed 0x170-byte work buffer at IWRAM address unk_20000A0.
// symdb: void clearWorkBuffer_20000A0(uint32 r2_passthrough); /* r2 in: forwarded to ZeroFillByByte, must
// symdb: be preserved; returns r2 unchanged; clobbers r0, r1, lr, flags */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/zeroFill_802E544.yaml
	thumb_local_start
zeroFill_802E544:
	push {lr}
	ldr r0, off_802E554 // =unk_20000A0 
	mov r1, #0x71 
	add r1, #0xff
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	.balign 4, 0
off_802E554:
	.word unk_20000A0
	thumb_func_end zeroFill_802E544

	thumb_local_start
sub_802E558:
	push {r4,r6,r7,lr}
	mov r6, r0
	bl getEntryPtr_2036120_1D0_802E070
	ldrh r0, [r7,#0x2c]
	ldr r1, dword_802E584 // =0xffff 
	cmp r0, r1
	beq loc_802E574
	bl sub_802E1B4
	tst r0, r0
	beq loc_802E574
	mov r1, #0
	pop {r4,r6,r7,pc}
loc_802E574:
	mov r1, #0x4c 
	ldrb r0, [r7,r1]
	tst r0, r0
	bne loc_802E57C
loc_802E57C:
	mov r0, #0
	pop {r4,r6,r7,pc}
	mov r0, #0
	pop {r4,r6,r7,pc}
	.balign 4, 0
dword_802E584:
	.word 0xFFFF
	thumb_func_end sub_802E558

	thumb_local_start
sub_802E588:
	push {r4-r7,lr}
	sub sp, sp, #0xc
	str r0, [sp]
	str r1, [sp,#4]
	str r2, [sp,#8]
	bl getBattleHandAddr_8010018
	mov r7, r0
	ldr r0, [sp]
	bl getEntryPtr_2036120_1D0_802E070
	mov r6, r0
	ldr r0, [sp,#4]
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r4, r0
	ldrb r0, [r7,#1]
	cmp r0, #5
	bge loc_802E5CA
	add r0, r0, r0
	add r0, #2
	add r5, r7, r0
	ldr r0, [sp,#4]
	strh r0, [r5]
	ldrh r1, [r4,#0x1a]
	strh r1, [r5,#0xc]
	mov r0, #0
	strh r0, [r5,#0x18]
	strh r0, [r5,#0x24]
	ldrb r0, [r7,#1]
	add r0, #1
	strb r0, [r7,#1]
	b loc_802E5CE
loc_802E5CA:
	mov r0, #0
	b loc_802E5F4
loc_802E5CE:
	ldr r0, [sp]
	ldr r1, [sp,#8]
	bl sub_802E674
	ldr r0, [sp]
	tst r0, r0
	bne loc_802E5F2
	ldr r0, [sp,#8]
	cmp r0, #0
	bne loc_802E5F2
	ldr r0, off_802E5F8 // =EVENT_2020 
	ldr r1, [sp,#4]
	add r0, r0, r1
	mov r0, r0
	bl SetEventFlag
	bl encryption_80070bc
loc_802E5F2:
	mov r0, #1
loc_802E5F4:
	add sp, sp, #0xc
	pop {r4-r7,pc}
	.balign 4, 0
off_802E5F8:
	.word EVENT_2020
	thumb_func_end sub_802E588

	thumb_local_start
sub_802E5FC:
	push {r4-r6,lr}
	mov r4, r0
	mov r5, r1
	mov r6, r2
	bl getEntryPtr_2036120_1D0_802E070
	ldrb r1, [r0,#3]
	cmp r1, #5
	bge loc_802E626
	add r1, r1, r1
	add r1, #0x18
	strh r5, [r0,r1]
	ldrb r1, [r0,#3]
	add r1, #1
	strb r1, [r0,#3]
	mov r0, r4
	mov r1, r6
	bl sub_802E674
	mov r0, #1
	b locret_802E628
loc_802E626:
	mov r0, #0
locret_802E628:
	pop {r4-r6,pc}
	thumb_func_end sub_802E5FC

	thumb_local_start
sub_802E62A:
	push {r4-r7,lr}
	sub sp, sp, #0xc
	str r0, [sp]
	str r1, [sp,#4]
	str r2, [sp,#8]
	ldr r0, [sp]
	bl getEntryPtr_2036120_1D0_802E070
	ldr r1, [sp,#4]
	strh r1, [r0,#0x34]
	ldr r0, [sp]
	tst r0, r0
	bne loc_802E65A
	ldr r0, [sp,#8]
	cmp r0, #0
	bne loc_802E65A
	ldr r0, off_802E670 // =EVENT_2020 
	ldr r1, [sp,#4]
	add r0, r0, r1
	mov r0, r0
	bl SetEventFlag
	bl encryption_80070bc
loc_802E65A:
	ldr r0, [sp]
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r5, r0
	ldr r0, dword_802E944 // =0x10000 
	bl SetAIData_Unk_44_Flag
	mov r0, #1
	add sp, sp, #0xc
	pop {r4-r7,pc}
	.balign 4, 0
off_802E670:
	.word EVENT_2020
	thumb_func_end sub_802E62A

	thumb_local_start
sub_802E674:
	push {r7,lr}
	mov r7, r1
	tst r1, r1
	beq locret_802E696
	bl sub_802E490
	ldr r2, dword_802E698 // =0xffff 
	sub r7, #1
	add r7, r7, r7
	add r7, #0
	ldrh r1, [r0,#6]
	strh r1, [r0,r7]
	strh r2, [r0,#6]
	add r0, #6
	mov r1, #0x1e
	bl sub_8000EB6
locret_802E696:
	pop {r7,pc}
	.balign 4, 0
dword_802E698:
	.word 0xFFFF
	thumb_func_end sub_802E674

	thumb_local_start
sub_802E69C:
	push {lr}
	mov r0, #0x50 
	ldrb r0, [r7,r0]
	tst r0, r0
	bne locret_802E6D4
	ldrb r1, [r7,#6]
	cmp r1, #1
	beq locret_802E6D4
	ldrh r0, [r7,#0x28]
	ldr r1, off_802E6D8 // =word_802E6DC 
	mov r3, #0
loc_802E6B2:
	ldrh r2, [r1]
	cmp r0, r2
	blt loc_802E6C0
	add r1, #4
	add r3, #1
	cmp r3, #3
	blt loc_802E6B2
loc_802E6C0:
	ldrh r0, [r1,#2]
	ldrh r1, [r7,#0x3a]
	tst r1, r1
	beq loc_802E6CA
	add r0, r0, r0
loc_802E6CA:
	ldrh r1, [r7,#0x3c]
	tst r1, r1
	beq locret_802E6D4
	add r0, #1
	lsr r0, r0, #1
locret_802E6D4:
	pop {pc}
	.balign 4, 0
off_802E6D8:
	.word word_802E6DC
word_802E6DC:
	.hword 0x1500
word_802E6DE:
	.hword 0x19
	.byte 0x0, 0x29, 0x19, 0x0, 0x0, 0x40, 0xC, 0x0, 0x0, 0x40, 0xC, 0x0
	thumb_func_end sub_802E69C

	thumb_local_start
sub_802E6EC:
	push {r5-r7,lr}
	sub sp, sp, #0x3c
	bl sub_802E490
	mov r7, r0
	add r0, sp, #0
	mov r1, #0x3c 
	ldr r2, dword_802E948 // =0xffff 
	bl HalfwordFill
	add r6, sp, #0
	ldr r2, dword_802E948 // =0xffff 
	mov r3, #0
	ldrh r0, [r7]
	cmp r0, r2
	beq loc_802E712
	add r1, r3, r3
	strh r0, [r6,r1]
	add r3, #1
loc_802E712:
	ldrh r0, [r7,#2]
	cmp r0, r2
	beq loc_802E71E
	add r1, r3, r3
	strh r0, [r6,r1]
	add r3, #1
loc_802E71E:
	ldrh r0, [r7,#4]
	cmp r0, r2
	beq loc_802E72A
	add r1, r3, r3
	strh r0, [r6,r1]
	add r3, #1
loc_802E72A:
	add r5, r7, #6
loc_802E72C:
	ldrh r0, [r5]
	cmp r0, r2
	beq loc_802E73C
	add r1, r3, r3
	strh r0, [r6,r1]
	add r3, #1
	add r5, #2
	b loc_802E72C
loc_802E73C:
	tst r3, r3
	beq loc_802E78C
	add r0, sp, #0
	mov r1, r3
	mov r2, r3
	push {r3}
	bl ShuffleHwordList_PrimaryRNG
	pop {r3}
	add r6, sp, #0
	ldr r2, dword_802E948 // =0xffff 
	ldrh r0, [r7]
	cmp r0, r2
	beq loc_802E760
	ldrh r0, [r6]
	strh r0, [r7]
	add r6, #2
	sub r3, #1
loc_802E760:
	ldrh r0, [r7,#2]
	cmp r0, r2
	beq loc_802E76E
	ldrh r0, [r6]
	strh r0, [r7,#2]
	add r6, #2
	sub r3, #1
loc_802E76E:
	ldrh r0, [r7,#4]
	cmp r0, r2
	beq loc_802E77C
	ldrh r0, [r6]
	strh r0, [r7,#4]
	add r6, #2
	sub r3, #1
loc_802E77C:
	add r5, r7, #6
loc_802E77E:
	ldrh r0, [r6]
	sub r3, #1
	blt loc_802E78C
	strh r0, [r5]
	add r5, #2
	add r6, #2
	b loc_802E77E
loc_802E78C:
	add sp, sp, #0x3c
	pop {r5-r7,pc}
	thumb_func_end sub_802E6EC

	thumb_local_start
sub_802E790:
	push {r6,r7,lr}
	mov r6, r0
	bl getEntryPtr_2036120_1D0_802E070
	mov r7, r0
	bl battle_isBattleOver
	tst r0, r0
	bne locret_802E828
	mov r1, #0x4c 
	ldrb r0, [r7,r1]
	tst r0, r0
	beq locret_802E828
	mov r1, #0x4d 
	ldrb r0, [r7,r1]
	tst r0, r0
	bne loc_802E7E2
	mov r0, r6
	bl battle_networkInvert
	tst r0, r0
	bne loc_802E7C8
	ldr r0, dword_802E94C // =0x80000 
	bl flags_clearBits_eStruct2035280_801BED6
	ldr r0, dword_802E94C // =0x80000 
	bl flags_clearBits_20352C4_801BEC2
loc_802E7C8:
	mov r0, r6
	bl battle_networkInvert
	tst r0, r0
	bne loc_802E7D6
	bl sub_801E408
loc_802E7D6:
	mov r0, #0x32 
	mov r1, #0x4e 
	strb r0, [r7,r1]
	mov r0, #1
	mov r1, #0x4d 
	strb r0, [r7,r1]
loc_802E7E2:
	mov r1, #0x4e 
	ldrb r0, [r7,r1]
	sub r0, #1
	strb r0, [r7,r1]
	blt loc_802E80C
	mov r1, #0xa
	svc 6
	cmp r1, #9
	bne locret_802E828
	mov r0, r6
	bl sub_802E6EC
	mov r0, r6
	bl battle_networkInvert
	tst r0, r0
	bne locret_802E80A
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
locret_802E80A:
	pop {r6,r7,pc}
loc_802E80C:
	mov r0, r6
	bl battle_networkInvert
	tst r0, r0
	bne loc_802E822
	ldr r0, dword_802E94C // =0x80000 
	bl eStruct2035280_SetRequestBits_801BECC
	ldr r0, dword_802E94C // =0x80000 
	bl flagSetBits_eStruct2035280_801BEB8
loc_802E822:
	mov r0, #0
	mov r1, #0x4c 
	strb r0, [r7,r1]
locret_802E828:
	pop {r6,r7,pc}
	thumb_func_end sub_802E790

	thumb_local_start
sub_802E82A:
	push {r4-r7,lr}
	mov r7, #0
	b loc_802E834
	thumb_func_end sub_802E82A

	thumb_func_start sub_802E830
sub_802E830:
	push {r4-r7,lr}
	mov r7, #1
loc_802E834:
	mov r4, r0
	mov r5, r1
	// idx
	mov r0, r1
	bl getChip8021DA8 // (which_chip: i32) -> *const ChipData
	mov r6, r0
	mov r0, r4
	bl getEntryPtr_2036120_1D0_802E070
	add r0, #0x60 
	ldrb r2, [r0,r5]
	ldrb r1, [r6,#0x1e]
	cmp r2, r1
	bge loc_802E85C
	add r2, #1
	cmp r7, #0
	beq loc_802E858
	strb r2, [r0,r5]
loc_802E858:
	sub r0, r1, r2
	pop {r4-r7,pc}
loc_802E85C:
	mov r0, #0xff
	pop {r4-r7,pc}
	thumb_func_end sub_802E830

	thumb_local_start
sub_802E860:
	push {lr}
	bl getEntryPtr_2036120_1D0_802E070
	mov r1, #0x4c 
	ldrb r0, [r0,r1]
	pop {pc}
	thumb_func_end sub_802E860

	thumb_local_start
sub_802E86C:
	push {r4,r5,lr}
	ldr r5, dword_802E948 // =0xffff 
	mov r4, r0
	bl sub_802E440
	cmp r0, r5
	bne loc_802E892
	mov r0, r4
	bl sub_802E44A
	cmp r0, r5
	bne loc_802E892
	mov r0, r4
	bl sub_802E454
	cmp r0, r5
	bne loc_802E892
	mov r0, #0
	pop {r4,r5,pc}
loc_802E892:
	mov r0, #1
	pop {r4,r5,pc}
	thumb_func_end sub_802E86C

	thumb_local_start
sub_802E896:
	push {lr}
	ldr r0, off_802E950 // =unk_2000370 
	mov r1, #0x71 
	add r1, #0xff
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end sub_802E896

	thumb_local_start
sub_802E8A4:
	push {r6,r7,lr}
	ldr r2, off_802E954 // =0x170 
	mul r2, r0
	ldr r0, off_802E958 // =unk_203A0A0 
	add r0, r0, r2
	ldr r6, dword_802E948 // =0xffff 
	mov r7, #0
	mov r2, #0
loc_802E8B4:
	ldrb r1, [r0,r2]
	tst r1, r1
	beq loc_802E8D2
	cmp r1, r7
	blt loc_802E8D2
	bgt loc_802E8CE
	push {r0-r2}
	bl GetRNGSecondary // () -> void
	lsr r3, r0, #0x1c
	lsr r0, r3
	pop {r0-r2}
	bcc loc_802E8D2
loc_802E8CE:
	mov r6, r2
	mov r7, r1
loc_802E8D2:
	add r2, #1
	ldr r3, off_802E954 // =0x170 
	cmp r2, r3
	blt loc_802E8B4
	mov r0, r6
	pop {r6,r7,pc}
	thumb_func_end sub_802E8A4

	thumb_local_start
sub_802E8DE:
	push {r4,r5,lr}
	mov r4, #0
	mov r5, #0
	bl sub_802E490
	ldr r2, dword_802E948 // =0xffff 
loc_802E8EA:
	ldrh r1, [r0]
	cmp r1, r2
	beq loc_802E8F2
	add r4, #1
loc_802E8F2:
	add r0, #2
	add r5, #1
	cmp r5, #0x21 
	blt loc_802E8EA
	mov r0, r4
	pop {r4,r5,pc}
	thumb_func_end sub_802E8DE

	thumb_local_start
sub_802E8FE:
	push {r4-r7,lr}
	mov r6, r0
	mov r7, r1
	mov r5, r2
	mov r0, r2
	bl object_getAllianceDirection
	mov r4, r0
loc_802E90E:
	add r6, r6, r4
	mov r0, r6
	mov r1, r7
	bl object_isValidPanel
	beq loc_802E92E
	mov r0, r6
	mov r1, r7
	bl object_getPanelParameters
	lsl r1, r5, #2
	ldr r2, off_802E938 // =off_802E93C 
	ldr r1, [r2,r1]
	tst r0, r1
	bne loc_802E932
	b loc_802E90E
loc_802E92E:
	mov r0, #0
	pop {r4-r7,pc}
loc_802E932:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_802E938:
	.word off_802E93C
off_802E93C:
	.word 0x4000000
	.word 0x8000000
dword_802E944:
	.word 0x10000
dword_802E948:
	.word 0xFFFF
dword_802E94C:
	.word 0x80000
off_802E950:
	.word unk_2000370
off_802E954:
	.word 0x170
off_802E958:
	.word unk_203A0A0
	thumb_func_end sub_802E8FE

	thumb_local_start
sub_802E95C:
	push {r4,r6,r7,lr}
	mov r7, r0
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, r0
	ldr r6, [r5,#0x58]
	add r6, #0xa0
	bl battle_testFlag0x40_800A8F8
	tst r0, r0
	bne loc_802E978
	ldr r1, off_802E9D4 // =off_802E9D8 
	b loc_802E97A
loc_802E978:
	ldr r1, off_802EA04 // =off_802EA08 
loc_802E97A:
	lsl r0, r7, #2
	ldr r1, [r1,r0]
	lsl r0, r4, #2
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	push {r0}
	push {r0}
	mov r1, #0x3c 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r2, off_802E9E4 // =off_802E9E8 
	lsl r1, r7, #2
	ldr r2, [r1,r2]
	add r1, r4, r4
	ldrh r1, [r2,r1]
	pop {r2}
	cmp r2, #2
	bne loc_802E9A8
	tst r0, r0
	beq loc_802E9AA
	mov r1, #0xa
	b loc_802E9AA
loc_802E9A8:
	lsl r1, r0
loc_802E9AA:
	strh r1, [r6,#8]
	ldr r2, off_802E9F4 // =off_802E9F8 
	lsl r1, r7, #2
	ldr r2, [r1,r2]
	ldrb r1, [r2,r4]
	mov r0, #0x80
	tst r1, r0
	bne loc_802E9C4
	lsl r1, r1, #8
	ldrb r0, [r5,#0x16]
	bl sub_802E032
	b loc_802E9D0
loc_802E9C4:
	mov r0, #0x7f
	and r1, r0
	lsl r1, r1, #8
	ldrb r0, [r5,#0x16]
	bl sub_802E04E
loc_802E9D0:
	pop {r0}
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_802E9D4:
	.word off_802E9D8
off_802E9D8:
	.word off_802EA14
	.word off_802EA7C
	.word off_802EAB0
off_802E9E4:
	.word off_802E9E8
off_802E9E8:
	.word byte_802EAE4
	.word byte_802EAFE
	.word byte_802EB18
off_802E9F4:
	.word off_802E9F8
off_802E9F8:
	.word byte_802EB32
	.word byte_802EB3F
	.word byte_802EB4C
off_802EA04:
	.word off_802EA08
off_802EA08:
	.word off_802EA48
	.word off_802EA7C
	.word off_802EAB0
off_802EA14:
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
off_802EA48:
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
	.word sub_802EB5C+1
off_802EA7C:
	.word sub_802EB60+1
	.word sub_802EB60+1
	.word sub_802EB60+1
	.word sub_802EB60+1
	.word sub_802EB60+1
	.word sub_802EB60+1
	.word sub_802EB60+1
	.word sub_802EBA8+1
	.word sub_802EB60+1
	.word sub_802EB60+1
	.word sub_802EB60+1
	.word sub_802EB60+1
	.word sub_802EB60+1
off_802EAB0:
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
	.word sub_802EB80+1
byte_802EAE4:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
byte_802EAFE:
	.byte 0x1, 0x0, 0x1, 0x0, 0x3, 0x0, 0x2, 0x0, 0x1, 0x0, 0x2, 0x0, 0x2, 0x0, 0x0, 0x0, 0x1
	.byte 0x0, 0x3, 0x0, 0x2, 0x0, 0x1, 0x0, 0x3, 0x0
byte_802EB18:
	.byte 0x0, 0x0, 0x5, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x2, 0x0, 0xA, 0x0, 0xA, 0x0, 0xA
	.byte 0x0, 0x0, 0x0, 0xA, 0x0, 0xA, 0x0, 0x5, 0x0, 0xA, 0x0
byte_802EB32:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
byte_802EB3F:
	.byte 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x85, 0x2, 0x2, 0x2, 0x2, 0x2
byte_802EB4C:
	.byte 0x85, 0xA, 0xA, 0x0, 0xA, 0xA, 0xA, 0x5, 0x85, 0xA, 0xA
	.byte 0xA, 0xA, 0x0, 0x0, 0x0
	thumb_func_end sub_802E95C

	thumb_local_start
sub_802EB5C:
	mov r0, #0
	mov pc, lr
	thumb_func_end sub_802EB5C

	thumb_local_start
sub_802EB60:
	push {lr}
	mov r0, #0
	strb r0, [r6,#2]
	mov r0, #0
	strb r0, [r6,#3]
	strb r0, [r6,#4]
	strh r0, [r6,#6]
	strh r0, [r6,#0xa]
	strb r0, [r6,#5]
	mov r0, #0
	str r0, [r6,#0xc]
	mov r0, #0x11
	bl object_setAttack0
	mov r0, #2
	pop {pc}
	thumb_func_end sub_802EB60

	thumb_local_start
sub_802EB80:
	push {lr}
	mov r0, #0
	strb r0, [r6,#2]
	mov r0, #3
	strb r0, [r6,#3]
	mov r0, #0
	strb r0, [r6,#4]
	strb r0, [r6,#5]
	strh r0, [r6,#6]
	strh r0, [r6,#0xa]
	strh r0, [r6,#8]
	ldr r0, off_802EBA4 // =0x23c 
	str r0, [r6,#0xc]
	mov r0, #0x2b 
	bl object_setAttack0
	mov r0, #1
	pop {pc}
	.balign 4, 0
off_802EBA4:
	.word 0x23C
	thumb_func_end sub_802EB80

	thumb_local_start
sub_802EBA8:
	push {lr}
	mov r0, #0
	strb r0, [r6,#2]
	mov r0, #3
	strb r0, [r6,#3]
	mov r0, #0
	strb r0, [r6,#4]
	strb r0, [r6,#5]
	strh r0, [r6,#6]
	strh r0, [r6,#0xa]
	strh r0, [r6,#8]
	ldr r0, off_802EBCC // =0x13c 
	str r0, [r6,#0xc]
	mov r0, #0x2b 
	bl object_setAttack0
	mov r0, #1
	pop {pc}
	.balign 4, 0
off_802EBCC:
	.word 0x13C
	thumb_func_end sub_802EBA8

	thumb_local_start
sub_802EBD0:
	push {r6,lr}
	mov r1, #2
	mov r2, #4
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r6, [r5,#0x58]
	add r6, #0xa0
	bl sub_802ECFE
	pop {r6,pc}
	thumb_func_end sub_802EBD0

	thumb_local_start
sub_802EBE4:
	push {r6,lr}
	ldrb r0, [r5,#0x16]
	mov r1, #2
	bl GetBattleNaviStats203CB10Byte
	mov r2, r0
	mov r1, #2
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r6, [r5,#0x58]
	add r6, #0xa0
	bl sub_802ECFE
	pop {r6,pc}
	thumb_func_end sub_802EBE4

	thumb_local_start
sub_802EC00:
	push {r4,r6,r7,lr}
	mov r7, r0
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	mov r4, r0
	mov r2, #4
	mov r1, #2
	bl SetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r6, [r5,#0x58]
	add r6, #0xa0
	ldr r1, off_802EC28 // =off_802EC2C 
	lsl r0, r7, #2
	ldr r1, [r1,r0]
	lsl r0, r4, #2
	ldr r1, [r1,r0]
	mov lr, pc
	bx r1
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_802EC28:
	.word off_802EC2C
off_802EC2C:
	.word off_802EC3C
	.word off_802EC6C
	.word off_802EC9C
	.word off_802ECCC
off_802EC3C:
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
	.word sub_802ECFE+1
off_802EC6C:
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
	.word sub_802EDBC+1
off_802EC9C:
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
	.word sub_802ED8A+1
off_802ECCC:
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	.word sub_802EDE8+1
	thumb_func_end sub_802EC00

	thumb_local_start
nullsub_34:
	mov pc, lr
	thumb_func_end nullsub_34

	thumb_local_start
sub_802ECFE:
	push {lr}
	bl sub_8013D5E
	cmp r0, #0
	beq loc_802ED0E
	bl sub_802ED68
	pop {pc}
loc_802ED0E:
	mov r0, #0
	strb r0, [r6,#2]
	mov r0, #0
	strb r0, [r6,#3]
	strb r0, [r6,#4]
	strh r0, [r6,#6]
	strh r0, [r6,#0xa]
	strb r0, [r6,#5]
	mov r0, #0
	str r0, [r6,#0xc]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r1, off_802ED4C // =byte_802ED5C 
	ldrb r0, [r1,r0]
	strh r0, [r6,#8]
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r1, off_802ED48 // =byte_802ED50 
	ldrb r0, [r0,r1]
	bl sub_802EEA2
	mov r0, #0x11
	bl object_setAttack0
	mov r0, #0
	mov r1, #0
	pop {pc}
	.balign 4, 0
off_802ED48:
	.word byte_802ED50
off_802ED4C:
	.word byte_802ED5C
byte_802ED50:
	.byte 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2, 0x2
byte_802ED5C:
	.byte 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3, 0x3
	thumb_func_end sub_802ECFE

	thumb_local_start
sub_802ED68:
	push {lr}
	mov r0, #0
	strb r0, [r6,#2]
	mov r0, #0
	strb r0, [r6,#3]
	strb r0, [r6,#4]
	strb r0, [r6,#5]
	strh r0, [r6,#6]
	strh r0, [r6,#0xa]
	strh r0, [r6,#8]
	str r0, [r6,#0xc]
	mov r0, #0x33 
	bl object_setAttack0
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_802ED68

	thumb_local_start
sub_802ED8A:
	push {lr}
	mov r0, #0
	strb r0, [r6,#2]
	mov r0, #3
	strb r0, [r6,#3]
	mov r0, #0
	strb r0, [r6,#4]
	strb r0, [r6,#5]
	strh r0, [r6,#6]
	strh r0, [r6,#0xa]
	strh r0, [r6,#8]
	ldr r0, off_802EDB8 // =0x23c 
	str r0, [r6,#0xc]
	mov r0, #0x8b
	bl sub_802EEA2
	mov r0, #0x2b 
	bl object_setAttack0
	mov r0, #1
	mov r1, #0
	pop {pc}
	.balign 4, 0
off_802EDB8:
	.word 0x23C
	thumb_func_end sub_802ED8A

	thumb_local_start
sub_802EDBC:
	push {lr}
	mov r0, #0
	strb r0, [r6,#2]
	mov r0, #0
	strb r0, [r6,#3]
	strb r0, [r6,#4]
	strh r0, [r6,#6]
	strh r0, [r6,#0xa]
	strb r0, [r6,#5]
	mov r0, #0
	str r0, [r6,#0xc]
	mov r0, #0x28 
	strh r0, [r6,#8]
	mov r0, #0xa
	bl sub_802EEA2
	mov r0, #0x16
	bl object_setAttack0
	mov r0, #1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_802EDBC

	thumb_local_start
sub_802EDE8:
	push {lr}
	pop {pc}
	thumb_func_end sub_802EDE8

	thumb_local_start
sub_802EDEC:
	push {lr}
	mov r0, #0x8c
	strh r0, [r6,#8]
	mov r0, #0x94
	strh r0, [r6,#0xa]
	mov r0, #0
	str r0, [r6,#0xc]
	mov r0, #1
	strb r0, [r6,#3]
	mov r0, #1
	strb r0, [r6,#4]
	mov r0, #0x13
	bl object_setAttack0
	mov r0, #0x95
	bl sub_802EEA2
	mov r0, #1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_802EDEC

	thumb_local_start
sub_802EE14:
	push {lr}
	pop {pc}
	thumb_func_end sub_802EE14

	thumb_local_start
sub_802EE18:
	push {lr}
	bl GetPositiveSignedRNG
	mov r4, #7
	and r4, r0
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	ldr r1, off_802EE30 // =byte_802EE34
	ldrb r0, [r1,r0]
	add r0, r0, r4
	pop {pc}
	.balign 4, 0
off_802EE30:
	.word byte_802EE34
byte_802EE34:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_802EE18

	thumb_local_start
sub_802EE40:
	push {lr}
	cmp r0, #3
	beq loc_802EE5C
	push {r0}
	mov r1, #0x29 
	bl GetBattleNaviStatsByte_AllianceFromBattleObject
	pop {r1}
	mov r2, #3
	mul r0, r2
	add r0, r0, r1
	ldr r1, off_802EE60 // =byte_802EE64 
	ldrb r0, [r1,r0]
	pop {pc}
loc_802EE5C:
	mov r0, #0
	pop {pc}
	.balign 4, 0
off_802EE60:
	.word byte_802EE64
byte_802EE64:
	.byte 0x0, 0x3C, 0x0, 0x0, 0x3C, 0x0, 0x0, 0x3C, 0x0, 0x0, 0x3C, 0x0, 0x0
	.byte 0x3C, 0x0, 0x0, 0x3C, 0x0, 0x0, 0x3C, 0x0, 0x0, 0x3C, 0x0, 0x0, 0x3C
	.byte 0x0, 0x0, 0x3C, 0x0, 0x0, 0x3C, 0x0, 0x0, 0x3C, 0x0, 0x0, 0xB5, 0x3
	.byte 0xB4, 0x3C, 0x21, 0xE4, 0xF7, 0x71, 0xFC, 0x6, 0xBC, 0x0, 0x42, 0x2, 0xD0
	.byte 0x9, 0x42, 0x0, 0xD1, 0x8, 0x22, 0x10, 0x1C, 0x0, 0xBD
	thumb_func_end sub_802EE40

	thumb_local_start
sub_802EEA2:
	push {lr}
	mov r1, #0x80
	tst r0, r1
	bne loc_802EEB4
	lsl r1, r0, #8
	ldrb r0, [r5,#0x16]
	bl sub_802E032
	b locret_802EEC0
loc_802EEB4:
	mov r1, #0x7f
	and r1, r0
	lsl r1, r1, #8
	ldrb r0, [r5,#0x16]
	bl sub_802E04E
locret_802EEC0:
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_802EEA2

	thumb_local_start
sub_802EEC4:
	push {r4,r7,lr}
	sub sp, sp, #8
	ldrb r0, [r5,#0x16]
	bl sub_802EFEE
	mov r7, r0
	beq loc_802EF44
	bl object_getEnemyDirection
	neg r4, r0
	ldrb r0, [r5,#0x16]
	bl getEntryPtr_2036120_1D0_802E070
	ldrb r1, [r0,#0xe]
	mul r1, r4
	ldrb r0, [r7,#0x12]
	add r0, r0, r1
	ldrb r1, [r7,#0x13]
	str r0, [sp]
	str r1, [sp,#4]
	bl object_getPanelDataOffset
	tst r0, r0
	beq loc_802EF00
	ldr r0, [sp]
	ldr r1, [sp,#4]
	bl sub_802EFD8
	beq loc_802EF18
	b loc_802EF12
loc_802EF00:
	mov r1, #0
	ldr r0, [sp]
	cmp r0, #1
	bgt loc_802EF0A
	mov r1, #1
loc_802EF0A:
	ldrb r0, [r5,#0x16]
	eor r0, r1
	beq loc_802EF18
	b loc_802EF2E
loc_802EF12:
	ldr r0, [sp]
	ldr r1, [sp,#4]
	b loc_802EF3A
loc_802EF18:
	ldrb r0, [r5,#0x16]
	ldr r3, off_802EF48 // =byte_802EF4C 
	lsl r2, r0, #3
	add r3, r3, r2
	ldr r2, [r3]
	ldr r3, [r3,#4]
	ldr r1, [sp,#4]
	bl object_getClosestPanelMatchingRowFiltered
	ldr r1, [sp,#4]
	b loc_802EF44
loc_802EF2E:
	ldrb r0, [r5,#0x16]
	mov r1, #5
	mul r0, r1
	add r0, #1
	str r0, [sp]
	ldr r1, [sp,#4]
loc_802EF3A:
	bl sub_802EFD8
	beq loc_802EF44
	ldr r0, [sp]
	ldr r1, [sp,#4]
loc_802EF44:
	add sp, sp, #8
	pop {r4,r7,pc}
	.balign 4, 0
off_802EF48:
	.word byte_802EF4C
byte_802EF4C:
	.byte 0x0, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0
	thumb_func_end sub_802EEC4

// symdb: If a condition check (sub_800A8F8) reports active, drives the sub_802EF74 state machine twice with argument 0 then 1.
// symdb: void sub_802EF5C(void); returns whatever flags/r0-r2 the last callee left
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802EF5C.yaml
	thumb_func_start sub_802EF5C
sub_802EF5C:
	push {lr}
	bl battle_testFlag0x40_800A8F8
	cmp r0, #0
	beq locret_802EF72
	mov r0, #0
	bl sub_802EF74
	mov r0, #1
	bl sub_802EF74
locret_802EF72:
	pop {pc}
	thumb_func_end sub_802EF5C

	thumb_local_start
sub_802EF74:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r0, [sp]
	bl battle_testFlag0x40_800A8F8
	cmp r0, #0
	beq loc_802EFD4
	mov r4, #4
	mov r7, #0
	ldr r0, [sp]
	mov r1, #1
	eor r0, r1
	bl sub_802EFEE
	tst r0, r0
	beq loc_802EFD4
	cmp r0, r5
	bne loc_802EFD4
	ldr r0, [sp]
	lsl r0, r0, #4
	add r0, #0x80
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	add r0, r0, r1
loc_802EFA4:
	ldr r6, [r0]
	tst r6, r6
	beq loc_802EFC0
	tst r7, r7
	bne loc_802EFB2
	mov r7, r6
	b loc_802EFC0
loc_802EFB2:
	push {r0}
	mov r0, r6
	mov r1, r7
	bl sub_802F006
	mov r7, r0
	pop {r0}
loc_802EFC0:
	add r0, #4
	sub r4, #1
	bgt loc_802EFA4
	ldr r0, [sp]
	mov r1, #1
	eor r0, r1
	mov r1, r7
	bl sub_802EFF8
	mov r0, r7
loc_802EFD4:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	thumb_func_end sub_802EF74

	thumb_local_start
sub_802EFD8:
	push {lr}
	bl object_getPanelDataOffset
	ldrb r1, [r0,#3]
	ldrb r0, [r5,#0x16]
	cmp r0, r1
	beq loc_802EFEA
	mov r0, #0
	pop {pc}
loc_802EFEA:
	mov r0, #1
	pop {pc}
	thumb_func_end sub_802EFD8

	thumb_local_start
sub_802EFEE:
	push {lr}
	bl getEntryPtr_2036120_1D0_802E070
	ldr r0, [r0,#0x44]
	pop {pc}
	thumb_func_end sub_802EFEE

	thumb_local_start
sub_802EFF8:
	push {lr}
	push {r1}
	bl getEntryPtr_2036120_1D0_802E070
	pop {r1}
	str r1, [r0,#0x44]
	pop {pc}
	thumb_func_end sub_802EFF8

	thumb_local_start
sub_802F006:
	push {r4-r7,lr}
	mov r6, r0
	mov r7, r1
	ldrb r0, [r5,#oBattleObject_Alliance]
	mov r1, #1
	eor r0, r1
	bl battle_findPlayer // (alliance: bool) -> * BattleObject
	mov r5, r0
	beq loc_802F05E
	bl object_getEnemyDirection
	ldrb r2, [r5,#oBattleObject_PanelX]
	add r2, r2, r0
	ldrb r0, [r6,#oBattleObject_PanelX]
	sub r0, r0, r2
	ldrb r1, [r7,#oBattleObject_PanelX]
	sub r1, r1, r2
	ldrb r2, [r5,#oBattleObject_Alliance]
	tst r2, r2
	beq loc_802F034
	neg r0, r0
	neg r1, r1
loc_802F034:
	cmp r0, r1
	bcc loc_802F05E
	bhi loc_802F062
	ldrb r2, [r5,#oBattleObject_PanelY]
	ldrb r0, [r6,#oBattleObject_PanelY]
	sub r0, r0, r2
	cmp r0, #0
	bge loc_802F046
	neg r0, r0
loc_802F046:
	ldrb r1, [r7,#oBattleObject_PanelY]
	sub r1, r1, r2
	cmp r1, #0
	bge loc_802F050
	neg r1, r1
loc_802F050:
	cmp r0, r1
	blt loc_802F05E
	bgt loc_802F062
	ldrb r0, [r6,#oBattleObject_PanelY]
	ldrb r1, [r7,#oBattleObject_PanelY]
	cmp r0, r1
	bge loc_802F062
loc_802F05E:
	mov r0, r6
	pop {r4-r7,pc}
loc_802F062:
	mov r0, r7
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_802F006

	thumb_func_start sub_802F068
sub_802F068:
	push {r7,lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	mov r7, r0
	ldrb r0, [r7,#2]
	tst r0, r0
	beq loc_802F07E
	sub r0, #1
	strb r0, [r7,#2]
	bne locret_802F082
loc_802F07E:
	bl sub_802F084
locret_802F082:
	pop {r7,pc}
	thumb_func_end sub_802F068

	thumb_local_start
sub_802F084:
	push {lr}
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl getEntryPtr_2036120_1D0_802E070
	ldrb r1, [r0,#3]
	tst r1, r1
	beq loc_802F096
	mov r1, #0
	strh r1, [r0,#0x28]
loc_802F096:
	ldrb r0, [r5,#oBattleObject_Alliance]
	bl sub_802E07C
	ldr r0, off_802F0A4 // =timer_2000000 
	bl ClearAIData_Unk_44_Flag
	pop {pc}
	.balign 4, 0
off_802F0A4:
	.word timer_2000000
// event flags, pooled here for some reason
dword_802F0A8:
	.hword 0x3E8, 0x3E8, 0x44C, 0x44C
	.hword 0x4B0, 0x514, 0x384, 0x3E8
	.hword 0x4B0, 0x3E8, 0x44C, 0x514
	.hword 0x384, 0x0
	thumb_func_end sub_802F084

// symdb: Clears the entire event-flags array in the toolkit's event-flag buffer, resetting all 630 story/scene flags.
// symdb: void sub_802F0C4(void); // r10 = toolkit ptr in; r2, r3 preserved pass-through; NZCV clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/toolkit_ClearAllEventFlags_802F0C4.yaml
	thumb_func_start toolkit_ClearAllEventFlags_802F0C4
toolkit_ClearAllEventFlags_802F0C4:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_EventFlagsPtr]
	ldr r1, off_802F0D4 // =0x4ec 
	bl ZeroFillByHalfword
	pop {pc}
	.balign 4, 0
off_802F0D4:
	.word 630 * 2
	thumb_func_end toolkit_ClearAllEventFlags_802F0C4

// symdb: Clears a group of 2 event flag halfwords (32 flag bits) starting at offset 0x2DE in the toolkit's event flags buffer.
// symdb: void sub_802F0D8(void); /* reads r10 (toolkit ptr); r2/r3 preserved; clobbers r0,r1,lr,NZCV */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eventflags_ClearTwoHalfwordsAt2DE_802F0D8.yaml
	thumb_func_start eventflags_ClearTwoHalfwordsAt2DE_802F0D8
eventflags_ClearTwoHalfwordsAt2DE_802F0D8:
	push {lr}
	ldr r0, dword_802F0EC // =0x2de 
	mov r1, r10
	ldr r1, [r1,#oToolkit_EventFlagsPtr]
	add r0, r0, r1
	ldr r1, dword_802F0F0 // =0x2 
	bl ZeroFillByHalfword
	pop {pc}
	.balign 4, 0
dword_802F0EC:
	.word 0x2DE
dword_802F0F0:
	.word 0x2
	thumb_func_end eventflags_ClearTwoHalfwordsAt2DE_802F0D8

// symdb: Zeroes a fixed run of 0x16 halfwords in the toolkit's event flag array starting at offset 0x2C8, resetting that block of flags.
// symdb: void sub_802F0F4(void) /* reads toolkit from r10; preserves r2, r3; returns r2 unchanged */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eventFlags_ClearRangeAt2C8_802F0F4.yaml
	thumb_func_start eventFlags_ClearRangeAt2C8_802F0F4
eventFlags_ClearRangeAt2C8_802F0F4:
	push {lr}
	ldr r0, off_802F108 // =0x2c8 
	mov r1, r10
	ldr r1, [r1,#oToolkit_EventFlagsPtr]
	add r0, r0, r1
	ldr r1, dword_802F10C // =0x16 
	bl ZeroFillByHalfword
	pop {pc}
	.balign 4, 0
off_802F108:
	.word 0x2C8
dword_802F10C:
	.word 0x16
	thumb_func_end eventFlags_ClearRangeAt2C8_802F0F4

// The following event flag related functions have an additional way to enter the function
// where it interprets the event flag as two 8 bit registers
// This takes less space as it only requires 4 bytes to load two 8bit immediates into two registers
// than to load a halfword from memory into a single register
// it would also require aligning to a word boundary which may take additional space

/* (r0:u8 flagUpper, r1:u8 flagLower) -> void
   clobbers: r0,r1,r3
   ignores: r2,r4-r9,r11,r12 */
// symdb: Set one event (story progress) flag (flag as two bytes)
// symdb: (r0 = flag high byte, r1 = flag low byte) -> sets the flag; r0 = the byte with the flag's bit
// symdb: set, r1 = mask, r3 = byte address; N/Z from the new byte (orr), C = 0, V from the address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetEventFlagFromImmediate.yaml
	thumb_func_start SetEventFlagFromImmediate
SetEventFlagFromImmediate:
// merge r0 and r1 into a halfword
	lsl r0, r0, #8
	orr r0, r1
// fallthrough
	thumb_func_end SetEventFlagFromImmediate


// Sets a flag at eEventFlags
// r0 - flag to set

/* (r0:u16 flagToSet) -> void
   clobbers: r0,r1,r3
   ignores: r2,r4-r9,r11,r12 */
// symdb: Set one event (story progress) flag
// symdb: (r0 = flag) -> sets the flag; r0 = the byte with the flag's bit set, r1 = mask, r3 = byte
// symdb: address; N/Z from the new byte (orr), C = 0, V from the address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetEventFlag.yaml
	thumb_func_start SetEventFlag
SetEventFlag:
	mov r3, r10
	ldr r3, [r3,#oToolkit_EventFlagsPtr]

	// get byte offset of flag in memory
	lsr r1, r0, #3
	add r3, r3, r1 // r3 = r3 + (flag >> 3)

	// get bit number of flag in memory
	lsl r0, r0, #29
	lsr r0, r0, #29 // r0 &= 0x7. gets bit offset of flag

	// translate that bit number into a bitmask
	mov r1, #0x80
	lsr r1, r0 // r1 = 0x80 >> r0

	// set the flag
	ldrb r0, [r3]
	orr r0, r1
	strb r0, [r3]
	mov pc, lr
	thumb_func_end SetEventFlag

/* (r0:u8 flagUpper, r1:u8 flagLower) -> void
   clobbers: r0,r1,r3
   ignores: r2,r4-r9,r11-r12 */
// symdb: Clear one event (story progress) flag (flag as two bytes)
// symdb: (r0 = flag high byte, r1 = flag low byte) -> clears the flag; r0 = the byte with the bit
// symdb: cleared, r1 = mask, r3 = byte address; N/Z from the new byte (bic), C = 0, V from the address
// symdb: add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ClearEventFlagFromImmediate.yaml
	thumb_func_start ClearEventFlagFromImmediate
ClearEventFlagFromImmediate: // (flag: u16) -> ()
	lsl r0, r0, #8
	orr r0, r1
// fallthrough

// Clears a flag at eEventFlags
// r0 - flag to clear

/* (r0:u16 flagToClear) -> void
   clobbers: r0,r1,r3
   ignores: r2,r4-r9,r11,r12 */
// symdb: Clear one event (story progress) flag
// symdb: (r0 = flag) -> clears the flag; r0 = the byte with the bit cleared, r1 = mask, r3 = byte
// symdb: address; N/Z from the new byte (bic), C = 0, V from the address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ClearEventFlag.yaml
	thumb_func_start ClearEventFlag
ClearEventFlag:
	mov r3, r10
	ldr r3, [r3,#oToolkit_EventFlagsPtr]

	// get byte offset of flag in memory
	lsr r1, r0, #3
	add r3, r3, r1 // r3 = r3 + (flag >> 3)

	// get bit number of flag in memory
	lsl r0, r0, #29
	lsr r0, r0, #29 // r0 &= 0x7. gets bit offset of flag

	// translate that bit number into a bitmask
	mov r1, #0x80
	lsr r1, r0 // r1 = 0x80 >> r0

	// clear the flag
	ldrb r0, [r3]
	bic r0, r1
	strb r0, [r3]
	mov pc, lr
	thumb_func_end ClearEventFlag
	thumb_func_end ClearEventFlagFromImmediate

/* (r0:u8 flagUpper, r1:u8 flagLower) -> void
   clobbers: r0,r1,r3
   ignores: r2,r4-r9,r11,r12 */
// symdb: Toggle one event (story progress) flag (flag as two bytes)
// symdb: (r0 = flag high byte, r1 = flag low byte) -> toggles the flag; r0 = the byte with the bit
// symdb: flipped, r1 = mask, r3 = byte address; N/Z from the new byte (eor), C = 0, V from the address
// symdb: add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ToggleEventFlagFromImmediate.yaml
	thumb_func_start ToggleEventFlagFromImmediate
ToggleEventFlagFromImmediate:
	lsl r0, r0, #8
	orr r0, r1
// fallthrough
	thumb_func_end ToggleEventFlagFromImmediate

// Toggle a flag at eEventFlags
// r0 - flag to toggle

/* (r0:u16 flagToToggle) -> void
   clobbers: r0,r1,r3
   ignores: r2,r4-r9,r11,r12 */
// symdb: Toggle one event (story progress) flag
// symdb: (r0 = flag) -> toggles the flag; r0 = the byte with the bit flipped, r1 = mask, r3 = byte
// symdb: address; N/Z from the new byte (eor), C = 0, V from the address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ToggleEventFlag.yaml
	thumb_func_start ToggleEventFlag
ToggleEventFlag:
	mov r3, r10
	ldr r3, [r3,#oToolkit_EventFlagsPtr]

	// get byte offset of flag in memory
	lsr r1, r0, #3
	add r3, r3, r1 // r3 = r3 + (flag >> 3)

	// get bit number of flag in memory
	lsl r0, r0, #29
	lsr r0, r0, #29

	// translate that bit number into a bitmask
	mov r1, #0x80
	lsr r1, r0 // r1 = 0x80 >> r0

	// toggle the flag
	ldrb r0, [r3]
	eor r0, r1
	strb r0, [r3]
	mov pc, lr
	thumb_func_end ToggleEventFlag

/* (r0:u8 eventGroupOffset, r1:u8 byteAndFlagOffset) -> !zf
   clobbers: r0,r1,r3
   ignores: r2,r4-r9,r11,r12 */
// symdb: Test one event (story progress) flag (flag as two bytes)
// symdb: (r0 = flag high byte, r1 = flag low byte) -> Z clear if the flag is set (tst r0, r1); r0 = the
// symdb: flag's byte, r1 = mask, r3 = byte address; C = 0, V from the address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/TestEventFlagFromImmediate.yaml
	thumb_func_start TestEventFlagFromImmediate
TestEventFlagFromImmediate: // (flag: u16) -> !zf
	lsl r0, r0, #8
	orr r0, r1
// fallthrough
	thumb_func_end TestEventFlagFromImmediate

// Test a flag at eEventFlags
// r0[15:3] = event byte offset
// r0[2:0] = event bit offset

/* (r0:u16 flagToTest) -> !zf
   clobbers: r0,r1,r3
   ignores: r2,r4-r9,r11,r12 */
// symdb: Test one event (story progress) flag
// symdb: (r0 = flag) -> Z clear if the flag is set (tst r0, r1); r0 = the flag's byte, r1 = mask, r3 =
// symdb: byte address; C = 0, V from the address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/TestEventFlag.yaml
	thumb_func_start TestEventFlag
TestEventFlag: // (flag: u16) -> !zf
	mov r3, r10
	ldr r3, [r3,#oToolkit_EventFlagsPtr]

	// get byte offset of flag in memory
	lsr r1, r0, #3
	add r3, r3, r1 // r3 = r3 + (flag >> 3)

	// get bit number of flag in memory
	lsl r0, r0, #29
	lsr r0, r0, #29

	// translate that bit number into a bitmask
	mov r1, #0x80
	lsr r1, r0 // r1 = 0x80 >> r0

	// test the flag
	ldrb r0, [r3]
	tst r0, r1
	mov pc, lr
	thumb_func_end TestEventFlag

/* (r0:u8 flagUpper, r1:u8 flagLower, r2:uint numEntries) -> void
   preserves: r4,r5,lr
   clobbers: r0-r3
   ignores: r6-r9,r11,r12*/
// symdb: Set a run of consecutive event flags (flag as two bytes)
// symdb: (r0 = flag high byte, r1 = flag low byte, r2 = count) -> sets flags first .. first + count - 1
// symdb: (at least one: the loop is `sub r2,#1; bgt`); r0 = last byte's new value, r1 = last mask, r2 =
// symdb: counter after the loop, r3 = last byte address; NZCV from the last `sub r2, #1`; r4, r5
// symdb: preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetEventFlagRangeFromImmediate.yaml
	thumb_func_start SetEventFlagRangeFromImmediate
SetEventFlagRangeFromImmediate:
	lsl r0, r0, #8
	orr r0, r1
// fallthrough
	thumb_func_end SetEventFlagRangeFromImmediate


// Set multiple flags in sequence starting at the flag in r0 (i.e. r0, r0+1, r0+2 etc.)
// Number of flags to set is in r2

/* (r0:u16 flagRangeStart, r2:uint numEntries) -> void
   preserves: r4,r5,lr
   clobbers: r0-r3
   ignores: r6-r9,r11,r12*/
// symdb: Set a run of consecutive event flags
// symdb: (r0 = flag, r2 = count) -> sets flags first .. first + count - 1 (at least one: the loop is `sub
// symdb: r2,#1; bgt`); r0 = last byte's new value, r1 = last mask, r2 = counter after the loop, r3 = last
// symdb: byte address; NZCV from the last `sub r2, #1`; r4, r5 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetEventFlagRange.yaml
	thumb_func_start SetEventFlagRange
SetEventFlagRange:
	push {r4,r5,lr}
	mov r4, r10
	ldr r4, [r4,#oToolkit_EventFlagsPtr]
	mov r5, r0

// r2 = number of event flags left to set
// r4 = eEventFlags
// r5 = current event flag
.setEventFlagRangeLoop
	// load invariants
	mov r3, r4
	mov r0, r5

	// get byte offset of flag in memory
	lsr r1, r0, #3
	add r3, r3, r1 // r3 = r3 + (flag >> 3)

	// get bit number of flag in memory
	lsl r0, r0, #29
	lsr r0, r0, #29

	// translate that bit number into a bitmask
	mov r1, #0x80
	lsr r1, r0

	// set the flag
	ldrb r0, [r3]
	orr r0, r1
	strb r0, [r3]

	// loop check
	add r5, #1 // current event flag + 1
	sub r2, #1 // loop counter
	bgt .setEventFlagRangeLoop
	pop {r4,r5,pc}
	thumb_func_end SetEventFlagRange

/* (r0:u8 flagUpper, r1:u8 flagLower, r2:uint numEntries) -> void
   preserves: r4,r5,lr
   clobbers: r0-r3
   ignores: r6-r9,r11,r12*/
// symdb: Clear a run of consecutive event flags (flag as two bytes)
// symdb: (r0 = flag high byte, r1 = flag low byte, r2 = count) -> clears flags first .. first + count - 1
// symdb: (at least one: the loop is `sub r2,#1; bgt`); r0 = last byte's new value, r1 = last mask, r2 =
// symdb: counter after the loop, r3 = last byte address; NZCV from the last `sub r2, #1`; r4, r5
// symdb: preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ClearEventFlagRangeFromImmediate.yaml
	thumb_func_start ClearEventFlagRangeFromImmediate
ClearEventFlagRangeFromImmediate:
	lsl r0, r0, #8
	orr r0, r1
// fallthrough
	thumb_func_end ClearEventFlagRangeFromImmediate

// Clears multiple flags in sequence starting at the flag in r0 (i.e. r0, r0+1, r0+2 etc.)
// Number of flags to clear is in r2

/* (r0:u16 flagRangeStart, r2:uint numEntries) -> void
   preserves: r4,r5,lr
   clobbers: r0-r3
   ignores: r6-r9,r11,r12*/
// symdb: Clear a run of consecutive event flags
// symdb: (r0 = flag, r2 = count) -> clears flags first .. first + count - 1 (at least one: the loop is
// symdb: `sub r2,#1; bgt`); r0 = last byte's new value, r1 = last mask, r2 = counter after the loop, r3 =
// symdb: last byte address; NZCV from the last `sub r2, #1`; r4, r5 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ClearEventFlagRange.yaml
	thumb_func_start ClearEventFlagRange
ClearEventFlagRange:
	push {r4,r5,lr}
	mov r4, r10
	ldr r4, [r4,#oToolkit_EventFlagsPtr]
	mov r5, r0

// r2 = number of event flags left to clear
// r4 = eEventFlags
// r5 = current event flag
.clearEventFlagRangeLoop
	// load invariants
	mov r3, r4
	mov r0, r5

	// get byte offset of flag in memory
	lsr r1, r0, #3
	add r3, r3, r1 // r3 = r3 + (flag >> 3)

	// get bit number of flag in memory
	lsl r0, r0, #29
	lsr r0, r0, #29

	// translate that bit number into a bitmask
	mov r1, #0x80
	lsr r1, r0

	// clear the flag
	ldrb r0, [r3]
	bic r0, r1
	strb r0, [r3]

	// loop check
	add r5, #1 // current event flag + 1
	sub r2, #1 // loop counter
	bgt .clearEventFlagRangeLoop
	pop {r4,r5,pc}
	thumb_func_end ClearEventFlagRange

/* (r0:u8 flagUpper, r1:u8 flagLower, r2:uint numEntries) -> void
   preserves: r4,r5,lr
   clobbers: r0-r3
   ignores: r6-r9,r11,r12*/
// symdb: Toggle a run of consecutive event flags (flag as two bytes)
// symdb: (r0 = flag high byte, r1 = flag low byte, r2 = count) -> toggles flags first .. first + count -
// symdb: 1 (at least one: the loop is `sub r2,#1; bgt`); r0 = last byte's new value, r1 = last mask, r2 =
// symdb: counter after the loop, r3 = last byte address; NZCV from the last `sub r2, #1`; r4, r5
// symdb: preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ToggleEventFlagRangeFromImmediate.yaml
	thumb_local_start
ToggleEventFlagRangeFromImmediate:
	lsl r0, r0, #8
	orr r0, r1
// fallthrough
	thumb_func_end ToggleEventFlagRangeFromImmediate

// Toggles multiple flags in sequence starting at the flag in r0 (i.e. r0, r0+1, r0+2 etc.)
// Number of flags to toggle is in r2

/* (r0:u16 flagRangeStart, r2:uint numEntries) -> void
   preserves: r4,r5
   clobbers: r0-r3
   ignores: r6-r9,r11,r12*/
// symdb: Toggle a run of consecutive event flags
// symdb: (r0 = flag, r2 = count) -> toggles flags first .. first + count - 1 (at least one: the loop is
// symdb: `sub r2,#1; bgt`); r0 = last byte's new value, r1 = last mask, r2 = counter after the loop, r3 =
// symdb: last byte address; NZCV from the last `sub r2, #1`; r4, r5 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ToggleEventFlagRange.yaml
	thumb_local_start
ToggleEventFlagRange:
	push {r4,r5,lr}
	mov r4, r10
	ldr r4, [r4,#oToolkit_EventFlagsPtr]
	mov r5, r0

// r2 = number of event flags left to toggle
// r4 = eEventFlags
// r5 = current event flag
.toggleEventFlagRangeLoop
	// load invariants
	mov r3, r4
	mov r0, r5

	// get byte offset of flag in memory
	lsr r1, r0, #3
	add r3, r3, r1 // r3 = r3 + (flag >> 3)

	// get bit number of flag in memory
	lsl r0, r0, #29
	lsr r0, r0, #29

	// translate that bit number into a bitmask
	mov r1, #0x80
	lsr r1, r0

	// toggle the flag
	ldrb r0, [r3]
	eor r0, r1
	strb r0, [r3]

	// loop check
	add r5, #1 // current event flag + 1
	sub r2, #1 // loop counter
	bgt .toggleEventFlagRangeLoop
	pop {r4,r5,pc}
	thumb_func_end ToggleEventFlagRange

/* (r0:u8 flagUpper, r1:u8 flagLower, r2:uint numEntries) -> zf
   preserves: r4-r7,lr
   clobbers: r0-r3
   ignores: r6-r9,r11,r12*/
// symdb: Test a run of consecutive event flags (flag as two bytes)
// symdb: (r0 = flag high byte, r1 = flag low byte, r2 = count) -> r0 = 1 if every flag in the range is
// symdb: set, else 0; Z from r0 (tst r0, r0); C/V from cmp(set count, count); r1 = last mask, r2 = loop
// symdb: counter after `sub r2,#1; bgt` (0 for count >= 1), r3 = last byte address; r4-r7 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/TestEventFlagRangeFromImmediate.yaml
	thumb_func_start TestEventFlagRangeFromImmediate
TestEventFlagRangeFromImmediate:
	lsl r0, r0, #8
	orr r0, r1
// fallthrough
	thumb_func_end TestEventFlagRangeFromImmediate

// Tests multiple flags in sequence starting at the flag in r0 (i.e. r0, r0+1, r0+2 etc.)
// Number of flags to tests is in r2

/* (r0:u16 flagRangeStart, r2:uint numEntries) -> zf
   preserves: r4-r7,lr
   clobbers: r0-r3
   ignores: r8-r9,r11,r12*/
// symdb: Test a run of consecutive event flags
// symdb: (r0 = flag, r2 = count) -> r0 = 1 if every flag in the range is set, else 0; Z from r0 (tst r0,
// symdb: r0); C/V from cmp(set count, count); r1 = last mask, r2 = loop counter after `sub r2,#1; bgt` (0
// symdb: for count >= 1), r3 = last byte address; r4-r7 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/TestEventFlagRange.yaml
	thumb_func_start TestEventFlagRange
TestEventFlagRange:
	push {r4-r7,lr}
	mov r7, r2
	mov r4, r10
	ldr r4, [r4,#oToolkit_EventFlagsPtr]
	mov r5, r0
	mov r6, #0

// r2 = number of event flags left to test
// r4 = eEventFlags
// r5 = current event flag
// r6 = number of event flags set
// r7 = range of event flags to test
.testEventFlagRangeLoop
	// load invariants
	mov r3, r4
	mov r0, r5

	// get byte offset of flag in memory
	lsr r1, r0, #3
	add r3, r3, r1 // r3 = r3 + (flag >> 3)

	// get bit number of flag in memory
	lsl r0, r0, #29
	lsr r0, r0, #29

	// translate that bit number into a bitmask
	mov r1, #0x80
	lsr r1, r0

	// test the flag and increment counter if set
	ldrb r0, [r3]
	tst r0, r1
	beq .flagNotSet
	add r6, #1
.flagNotSet
	// loop check
	add r5, #1 // current event flag + 1
	sub r2, #1 // loop counter
	bgt .testEventFlagRangeLoop

// return zero if not all flags were set
	mov r0, #0
	cmp r6, r7
	bne .notAllFlagsSet
	mov r0, #1
.notAllFlagsSet
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end TestEventFlagRange

// file boundary?
	.balign 4, 0x00

// symdb: Records a newly received mail by setting its event flag and companion flag (mailId + 0x80), then pushes the mail's inbox slot (mailId - 0x1CA0) to the front of the inbox entry list and increments the inbox entry count.
// symdb: void addMail_802f238(u32 mailId /* r0 */); /* clobbers r0, r1, r2, r3, c, v; preserves r4, r6,
// symdb: r7; trashes nz */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/addMail_802f238.yaml
	thumb_func_start addMail_802f238
addMail_802f238:
	push {r4,r6,r7,lr}
	mov r7, r0
	mov r0, r0
	bl SetEventFlag
	mov r0, r7
	add r0, #0x80
	mov r0, r0
	bl SetEventFlag
	ldr r1, off_802F2C4 // =0x1ca0 
	sub r7, r7, r1
	ldr r2, off_802F2DC // =byte_2006530 
	ldr r6, off_802F2E0 // =dword_2001140 
	ldr r0, [r6]
	mov r4, r0
	tst r4, r4
	beq loc_802F268
	sub r1, r0, #1
loc_802F25E:
	ldrb r3, [r2,r1]
	strb r3, [r2,r0]
	sub r0, #1
	sub r1, #1
	bge loc_802F25E
loc_802F268:
	strb r7, [r2]
	add r4, #1
	str r4, [r6]
	pop {r4,r6,r7,pc}
	thumb_func_end addMail_802f238

	thumb_local_start
sub_802F270:
	push {r4,r6,r7,lr}
	sub sp, sp, #4
	str r0, [sp]
	ldr r1, off_802F2C4 // =0x1ca0 
	sub r7, r0, r1
	ldr r6, off_802F2E0 // =dword_2001140 
	ldr r1, [r6]
	ldr r2, off_802F2DC // =byte_2006530 
loc_802F280:
	ldrb r0, [r2]
	cmp r0, r7
	beq loc_802F28E
	add r2, #1
	sub r1, #1
	bgt loc_802F280
	b loc_802F2BC
loc_802F28E:
	cmp r1, #1
	ble loc_802F29E
	add r3, r2, #1
	ldrb r0, [r3]
	strb r0, [r2]
	add r2, #1
	sub r1, #1
	b loc_802F28E
loc_802F29E:
	mov r0, #0x80
	strb r0, [r2]
	ldrb r0, [r6]
	sub r0, #1
	str r0, [r6]
	ldr r0, [sp]
	mov r7, r0
	mov r0, r0
	bl ClearEventFlag // (u16 entryFlagBitfield) -> void
	mov r0, r7
	add r0, #0x80
	mov r0, r0
	bl ClearEventFlag // (u16 entryFlagBitfield) -> void
loc_802F2BC:
	add sp, sp, #4
	pop {r4,r6,r7,pc}
	.word 0x1D20
	.balign 4, 0
off_802F2C4:
	.word 0x1CA0
	thumb_func_end sub_802F270

// symdb: Clears the 0x80-byte palette scratch buffer at byte_2006530 (fills with 0x80) and zeros dword_2001140, used to reset palette animation state.
// symdb: void resetPaletteScratch_802F2C8(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/resetPaletteScratch_802F2C8.yaml
	thumb_func_start resetPaletteScratch_802F2C8
resetPaletteScratch_802F2C8:
	push {lr}
	// mem
	ldr r0, off_802F2DC // =byte_2006530 
	// byteCount
	mov r1, #0x80
	// byte
	mov r2, #0x80
	bl ByteFill // (u8 *mem, int byteCount, u8 byte) -> void
	ldr r0, off_802F2E0 // =dword_2001140 
	mov r1, #0
	str r1, [r0]
	pop {pc}
	.balign 4, 0
off_802F2DC:
	.word byte_2006530
off_802F2E0:
	.word dword_2001140
byte_802F2E4:
	gfx_anim_manual_pal_transform transform_type=0x00000004 ptr5=iPalette3001B60 index=0x00 num_pals=0x0E
	gfx_anim_data data=0x80000842 delay=0x00000001

byte_802F2F8:
	gfx_anim_data data=0x80001084 delay=0x00000001
	gfx_anim_data data=0x800018C6 delay=0x00000001
	gfx_anim_data data=0x80002108 delay=0x00000001
	gfx_anim_data data=0x8000294A delay=0x00000001
	gfx_anim_data data=0x8000318C delay=0x00000001
	gfx_anim_data data=0x800039CE delay=0x00000001
	gfx_anim_data data=0x80004210 delay=0x00000001
	gfx_anim_end

dword_802F334:
	gfx_anim_manual_pal_transform transform_type=0x00000004 ptr5=iPallete3001750 index=0x01 num_pals=0x01
	gfx_anim_data data=0x80000842 delay=0x00000001
	gfx_anim_jump dest=byte_802F2F8

off_802F350:
	gfx_anim_pal_copy dest=unk_3001A40 size=0x00000020 index=0x04
	gfx_anim_data_ptr ptr=byte_87F93B4 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F93D4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F93F4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9414 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9434 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F9414 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F93F4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F93D4 delay=0x00000007
	gfx_anim_loop

off_802F3A0:
	gfx_anim_pal_copy dest=unk_3001A60 size=0x00000020 index=0x05
	gfx_anim_data_ptr ptr=byte_87F9454 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F9474 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9494 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F94B4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F94D4 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F94B4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9494 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9474 delay=0x00000007
	gfx_anim_loop

off_802F3F0:
	gfx_anim_pal_copy dest=unk_3001A80 size=0x00000020 index=0x06
	gfx_anim_data_ptr ptr=byte_87F94F4 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F9514 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9534 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9554 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9574 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F9554 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9534 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9514 delay=0x00000007
	gfx_anim_loop

off_802F440:
	gfx_anim_pal_copy dest=unk_3001AA0 size=0x00000020 index=0x07
	gfx_anim_data_ptr ptr=byte_87F9594 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F95B4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F95D4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F95F4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9614 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F95F4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F95D4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F95B4 delay=0x00000007
	gfx_anim_loop

off_802F490:
	gfx_anim_pal_copy dest=byte_3001B00 size=0x00000020 index=0x08
	gfx_anim_data_ptr ptr=byte_87F96D4 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F96F4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9714 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9734 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9754 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F9734 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9714 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F96F4 delay=0x00000007
	gfx_anim_loop

off_802F4E0:
	gfx_anim_pal_copy dest=unk_3001B20 size=0x00000020 index=0x09
	gfx_anim_data_ptr ptr=byte_87F9774 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F9794 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F97B4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F97D4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F97F4 delay=0x00000024
	gfx_anim_data_ptr ptr=byte_87F97D4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F97B4 delay=0x00000007
	gfx_anim_data_ptr ptr=byte_87F9794 delay=0x00000007
	gfx_anim_loop

	thumb_func_end resetPaletteScratch_802F2C8

// Start Module StartScreen_

/// Breaks on partial Capcom logo fade from logoScreen_finish_803D2A6
	thumb_func_start startScreen_init_802F530
startScreen_init_802F530: // () -> void
	push {lr}

  // implies eStartScreen size
	ldr r0, off_802F570 // =eStartScreen
	mov r1, #0x20 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()

  // trigger startscreen_render_802F544 via main_
	mov r1, r10
	ldr r1, [r1,#oToolkit_MainJumptableIndexPtr]
	mov r0, #0
	strb r0, [r1]

	pop {pc}
	thumb_func_end startScreen_init_802F530

// symdb: Renders one frame of the title/start screen by animating the "Press Start" prompt, dispatching the current start-screen state's handler, and ticking the RNG.
// symdb: void startscreen_render_802F544(void); // inputs : r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 lr //
// symdb: outputs: r4 r5 r6 r7 r8 r9 r10 r11 r12 // clobbers: r0 r1 r2 r3 lr; flags NZ C V // preserved:
// symdb: r4 r5 r6 r7 (r4-r7 explicitly restored to caller via pop)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startscreen_render_802F544.yaml
	thumb_func_start startscreen_render_802F544
startscreen_render_802F544: // () ->
	push {r4-r7,lr}
	bl startScreen_AnimatePressStart_803E938

	ldr r5, off_802F570 // =eStartScreen
	ldr r0, off_802F55C // =jt_802F560 

	ldrb r1, [r5, #oStartScreen_JumpTableOff_00]
	ldr r0, [r0,r1]
	
  mov lr, pc
  bx r0
	
  bl GetRNG // () -> u32?
  pop {r4-r7,pc}
  .balign 4, 0
off_802F55C:
	.word jt_802F560
jt_802F560:
	.word startScreen_initGfx_802F574+1 // (self: *mut StartScreen $r5) -> ()
	.word startscreen_802F60C+1 // (self: * StartScreen $r5) -> ()
	.word startScreen_RunStateHandler_802F63C+1 // (self: * StartScreen $r5) -> ()
	.word load_game_802F756+1 // (self: * StartScreen $r5) -> ()
off_802F570:
	.word eStartScreen
	thumb_func_end startscreen_render_802F544

/// Disabling this causes black screen after Capcom Logo
// symdb: Initialise the title/start screen: set up video, load its GFX anims, fade in from black, and build the main-menu cursor (1–3 choices depending on save data and a "test zero" flag).
// symdb: void startScreen_init_802F574(struct StartScreen *self /* r5 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_initGfx_802F574.yaml
	thumb_local_start
startScreen_initGfx_802F574: // (self: *mut StartScreen $r5) -> ()
	push {lr}

	mov r0, #0xb
	bl toolkit_applyOverlayPalette_80015FC

	ldr r0, off_802F7E4 // =0x1140 
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()

	bl renderInfo_8001788 // () -> ()

	bl renderInfo_80017A0 // () -> ()

  /// Disabling this causes responsive black start screen with some graphics noise
	bl startScreen_initGfx_802FCC0

	mov r0, #0xc
	mov r1, #0xff
	bl SetScreenFade // (int a1, int a2) -> void

	bl musicGameState_8000784 // () -> void

	ldr r0, off_802F5EC // =pt_802F5F0 
	bl LoadGFXAnims // (gfx_anim_data_arr: * FFStop32<[GFXAnimScript]>) -> ()

  // trigger startscreen_802F60C via startscreen_render_802F544
	mov r0, #4
	strb r0, [r5, #oStartScreen_JumpTableOff_00]

	mov r0, #0
	strb r0, [r5, #oStartScreen_Unk_02]

	bl sub_803FA42

	bl sub_803F838 // () -> !zf
	bne loc_802F5BE

	mov r0, #1
	strb r0, [r5, #oStartScreen_Unk_02]

	bl GetTitleScreenIconCount // () -> (u8, u16)
	strb r0, [r5, #oStartScreen_Unk_0C]
	strh r1, [r5, #oStartScreen_AchievmentFlags]

loc_802F5BE:
	ldrb r0, [r5, #oStartScreen_Unk_02]
	tst r0, r0
	bne loc_802F5D4

	mov r6, #0
	mov r7, #1

  // Was this a condition stubbed out?
	bl startScreen_TstZero // () -> !zf
	beq loc_802F5E2

	mov r0, #0
	mov r7, #2
	b loc_802F5E2
loc_802F5D4:
	mov r6, #1
	mov r7, #2

	bl startScreen_TstZero // () -> !zf
	beq loc_802F5E2

	mov r6, #1
	mov r7, #3

loc_802F5E2:
	strb r6, [r5,#oStartScreen_CurrCursorPos]
	strb r7, [r5,#oStartScreen_NumChoices]

	mov r0, #0
	strb r0, [r5,#oStartScreen_Unk_03]

	pop {pc}
	.balign 4, 0
off_802F5EC:
	.word pt_802F5F0
pt_802F5F0:
	.word off_802F350
	.word off_802F3A0
	.word off_802F3F0
	.word off_802F440
	.word off_802F490
	.word off_802F4E0
	.word 0xFFFFFFFF
	thumb_func_end startScreen_initGfx_802F574

// symdb: Start screen state 4: runs the single handler of its sub-table (startscreen_render_trigger_802F624).
// symdb: void startscreen_802F60C(StartScreen *self /* r5 */)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/startscreen_802F60C.yaml
	thumb_local_start
startscreen_802F60C: // (self: * StartScreen $r5) -> ()
	push {lr}

	ldr r0, off_802F61C // =off_802F620 

  // There is only one valid choice!
	ldrb r1, [r5, #oStartScreen_JumpTableOff_01]
	ldr r0, [r0,r1]

	mov lr, pc
	bx r0

	pop {pc}
	.balign 4, 0x00
off_802F61C:
	.word off_802F620
off_802F620:
	.word startscreen_render_trigger_802F624+1 // (self: *mut StartScreen $r5) -> ()
	thumb_func_end startscreen_802F60C

// symdb: Sets the title screen's LCD control (0x1741) and moves the start screen to state 8 (the title menu), substate 0.
// symdb: void startscreen_render_trigger_802F624(StartScreen *self /* r5 */)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/startscreen_render_trigger_802F624.yaml
	thumb_local_start
startscreen_render_trigger_802F624: // (self: *mut StartScreen $r5) -> ()
	push {lr}

	ldr r0, dword_802F638 // =0x1741 
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()

  // trigger startScreen_RunStateHandler_802F63C via startscreen_render_802F544
	mov r0, #8
	strb r0, [r5, #oStartScreen_JumpTableOff_00]

	mov r0, #0
	strb r0, [r5, #oStartScreen_JumpTableOff_01]

	pop {pc}
	.balign 4, 0
dword_802F638:
	.word 0x1741
	thumb_func_end startscreen_render_trigger_802F624

// symdb: Start-screen state dispatcher — reads the screen's state byte, calls the matching state handler from a 5-entry jump table, then runs the common per-frame routine.
// symdb: void startScreen_RunStateHandler(StartScreen* self /* r5 */); clobbers r0-r3, r12, lr and flags;
// symdb: handlers are tail-style bx calls using lr-as-pc
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_RunStateHandler_802F63C.yaml
	thumb_local_start
startScreen_RunStateHandler_802F63C: // (self: * StartScreen $r5) -> ()
	push {lr}

	ldr r0, off_802F650 // =jt_802F654 

	ldrb r1, [r5, #oStartScreen_JumpTableOff_01]
	ldr r0, [r0,r1]

	mov lr, pc
	bx r0

	bl loadTitleBlob_802FB10 // () -> void

	pop {pc}
	.balign 4, 0
off_802F650:
	.word jt_802F654
jt_802F654:

  // where is it triggered?
	.word startScreen_init_802F668+1 // (self: *mut StartScreen $r5) -> ()

	.word sub_802F6A4+1 // (self: *mut StartScreen $r5) -> ()
	.word sub_802F6B2+1 // (self: *mut StartScreen $r5) -> ()

  // where is it triggered?
	.word startScreen_UpdateAndRenderFrame_802F704+1 // (self: *mut StartScreen $r5) -> ()

	.word startScreen_update_802F710+1 // (self: *mut StartScreen $r5) -> ()
	thumb_func_end startScreen_RunStateHandler_802F63C

/// breaks right after Capcom logo
// symdb: Initializes (or restarts) the title/start screen — clears counters, resets the menu cursor, starts the title music, loads background tiles, fades in, and advances to state 4.
// symdb: (self: StartScreen * in r5) -> void; clobbers r0-r4, lr, flags; preserves r5-r7, r10
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_init_802F668.yaml
	thumb_local_start
startScreen_init_802F668: // (self: *mut StartScreen $r5) -> ()
	push {lr}

	mov r0, #0
	strb r0, [r5,#0xe]
	strb r0, [r5,#0xf]

	ldr r0, dword_802F69C // =0xa46 
	strh r0, [r5,#4]

	mov r0, #1
	bl music_80005F2 // (bg_music_indicator: u8) -> ()

	mov r0, #0xa
	bl toolkit_applyOverlayPalette_80015FC

	ldr r0, off_802F6A0 // =0x1340 
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()

	mov r0, #0
	strb r0, [r5,#6]

	bl copyBGTiles_802FD3C

	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void

  // trigger sub_802F6A4 via startScreen_RunStateHandler_802F63C
	mov r0, #4
	strb r0, [r5, #oStartScreen_JumpTableOff_01]

	pop {pc}
	.balign 4, 0
dword_802F69C:
	.word 0xA46
off_802F6A0:
	.word 0x1340
	thumb_func_end startScreen_init_802F668

// symdb: Title menu substate 4: waits until the screen fade has finished, then advances to substate 8.
// symdb: void sub_802F6A4(StartScreen *self /* r5 */)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_802F6A4.yaml
	thumb_local_start
sub_802F6A4: // (self: *mut StartScreen $r5) -> ()
	push {r4,lr}

	bl IsScreenFadeActive // () -> zf
	beq locret_802F6B0

  // trigger sub_802F6B2 via startScreen_RunStateHandler_802F63C
	mov r0, #8
	strb r0, [r5, #oStartScreen_JumpTableOff_01]

locret_802F6B0:
	pop {r4,pc}
	thumb_func_end sub_802F6A4

// symdb: Per-frame title-screen tick that counts down, plays the title jingle at a fixed value, and on START input fades into the main menu.
// symdb: void sub_802F6B2(u16 timer /* @r5+4 */,                  void *menu /* @r2 */,
// symdb: u32 screenCtx /* @r10 */,                  void *lr /* return addr */)   -> /* out */ r8 r9 r10
// symdb: r11 r12; // clobbers nzcv r0 r1 r2 r3 r7 lr; preserves r4 r5 r6 r8 r9 r12
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802F6B2.yaml
	thumb_local_start
sub_802F6B2: // (self: *mut StartScreen $r5) -> ()
	push {r4,lr}

	ldrh r0, [r5,#4]
	cmp r0, #0
	bgt loc_802F6C8

  // trigger startScreen_update_802F710 via startScreen_RunStateHandler_802F63C
	mov r0, #0x10
	strb r0, [r5, #oStartScreen_JumpTableOff_01]

	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void

	b locret_802F6FA

loc_802F6C8:

	sub r0, #1
	strh r0, [r5,#4]

	ldr r1, off_802F6FC // =0x12c 
	cmp r0, r1
	bne loc_802F6E0

	push {r0,r5}
	mov r0, #0x1f
	mov r1, #0x10
	bl sound_dispatchCueHandler_800068A

	pop {r0,r5}

	b locret_802F6FA

loc_802F6E0:
	ldrh r0, [r5,#4]
	ldr r1, dword_802F700 // =0xa0a 
	cmp r0, r1
	bge locret_802F6FA

	bl startScreen_IsTitleAnimationFinished_803E928

	bne locret_802F6FA

	bl sub_802FD54 // (self: *mut StartScreen $r5) -> ()
	bl menu_onStartPressBeginTransition_802F7E8
	bl sub_802F88E

locret_802F6FA:
	pop {r4,pc}
	.balign 4, 0
off_802F6FC:
	.word 0x12C
dword_802F700:
	.word 0xA0A
	thumb_func_end sub_802F6B2

/// Breaks right after interacting with "PRESS START"
// symdb: Advances the title/start screen by one frame — runs its state update, then redraws it.
// symdb: void startScreen_UpdateAndRenderFrame(StartScreen* self /* r5 */); no meaningful return
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_UpdateAndRenderFrame_802F704.yaml
	thumb_local_start
startScreen_UpdateAndRenderFrame_802F704: // (self: *mut StartScreen $r5) -> ()
	push {lr}
	bl sub_802F81C
	bl startScreen_updateFrame_802F8D8 // (self: *mut StartScreen $r5) -> ()
	pop {pc}
	thumb_func_end startScreen_UpdateAndRenderFrame_802F704

// symdb: Per-frame update for the start/title screen; advances fade transition and triggers game-load via the render dispatch table once the fade counter is non-zero, otherwise tears down and resets visuals/animation when the fade has finished.
// symdb: void sub_802F710(void *self /* r5 */); clobbers r0-r3, lr, N/Z/C/V
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_update_802F710.yaml
	thumb_local_start
startScreen_update_802F710: // (self: *mut StartScreen $r5) -> ()
	push {lr}

	ldrh r0, [r5,#4]
	cmp r0, #0
	ble loc_802F71C

	bl startScreen_updateFrame_802F8D8 // (self: *mut StartScreen $r5) -> ()

loc_802F71C:

	bl IsScreenFadeActive // () -> zf
	beq locret_802F754

	ldrh r0, [r5,#4]
	cmp r0, #0
	ble loc_802F72E

  // This seems to be for quickly writing 0x0C to JO00, and 0x00 to JO01
  // trigger load_game_802F756 via startscreen_render_802F544
	mov r0, #0xc
	strh r0, [r5, #oStartScreen_JumpTableOff_00]

	b locret_802F754
loc_802F72E:
	bl zeroFill_e20094C0
	bl palette_clearEPalette20097a0_80023A8
	bl call_803D1AC // () -> void
	bl sub_81440D8 // static () -> void
	bl zeroFill_813D960
	bl clear_e200AD04 // () -> ()
	mov r0, #0
	bl sub_803F6B0
	bl loc_803F512
	bl init_eStartScreenAnimationControl200B1A0_1

locret_802F754:
	pop {pc}
	thumb_func_end startScreen_update_802F710

/// Breaks on pressing Main screen "Continue" once.
/// Disabling this causes "Continue" to click, sound effect to play, but then we get stuck in a black screen.
// symdb: Start screen state 12: leaves the title screen for the chosen menu entry (new game, continue, or the third choice) and switches the main loop to the game.
// symdb: void load_game_802F756(StartScreen *self /* r5 */)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/load_game_802F756.yaml
	thumb_local_start
load_game_802F756: // (self: * StartScreen $r5) -> ()
	push {lr}

	mov r7, r10

  // Disabling this causes "Continue" to click, sound effect to play, but then we get stuck in a black screen.
  // trigger cbGameState_80050EC via main_
	ldr r0, [r7,#oToolkit_MainJumptableIndexPtr]
	mov r1, #4
	strb r1, [r0]

	ldr r0, off_802F7E4 // =0x1140 
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()

	bl zeroFill_813D960

	ldrb r0, [r5,#8]

	cmp r0, #FALSE
	beq loc_802F776

	cmp r0, #TRUE
	beq loc_802F79A

	b loc_802F7B6
loc_802F776:

	bl resetOverworldScene_800260C

	bl initNewGameData_8004DF0

  // EnterMap is triggered via cbGameState_80050EC here
	bl scenario_prepareEnterMap_8004D48

	bl sub_81440D8 // static () -> void

	bl rfu_REQ_stopMode

	ldrb r0, [r5,#2]
	tst r0, r0
	beq locret_802F7E0

	movflag EVENT_1704
	bl SetEventFlagFromImmediate
	b locret_802F7E0
loc_802F79A:
	ldrb r0, [r5,#2]
	tst r0, r0
	beq loc_802F7B6

	bl scenario_prepareEnterMap_8004D48

	movflag EVENT_1704
	bl SetEventFlagFromImmediate

	bl sub_81440D8 // static () -> void

	bl rfu_REQ_stopMode

	b locret_802F7E0

loc_802F7B6:
	mov r0, #0
	bl sub_813D90C

	bl scenario_prepareEnterMap_8004D48

	bl sub_8039570

	bl clearStruct200BC30_803EBAC

	mov r0, #0xc
	bl eStruct200BC30_setJumpOffset00

	ldrb r0, [r5,#2]
	tst r0, r0
	beq loc_802F7DC

	movflag EVENT_1704
	bl SetEventFlagFromImmediate
loc_802F7DC:
	bl sub_81440D8 // static () -> void
locret_802F7E0:
	pop {pc}
	.balign 4, 0
off_802F7E4:
	.word 0x1140
	thumb_func_end load_game_802F756

// symdb: On a menu screen, while Start is held, clears the screen's work area, plays the select sound, stores the next state (0x0C) in the caller's object, and preloads the two GFX animation scripts for the follow-up screen.
// symdb: void sub_802F7E8(void); // in: r5 = caller's object (state field at +1), r10 = toolkit ptr
// symdb: (copied to r7 for callees); out: state byte set to 0x0C, r10 possibly updated by LoadGFXAnim
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/menu_onStartPressBeginTransition_802F7E8.yaml
	thumb_local_start
menu_onStartPressBeginTransition_802F7E8:
	push {lr}
	mov r7, r10
	ldr r0, [r7,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#2]
	mov r1, #8
	tst r1, r0
	beq locret_802F810
	bl zeroFill_813D960
	mov r0, #0xc
	strb r0, [r5,#1]
	mov r0, #SOUND_SELECT_67
	bl PlaySoundEffect
	ldr r0, off_802F814 // =byte_802F2E4 
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	ldr r0, off_802F818 // =dword_802F334 
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
locret_802F810:
	pop {pc}
	.balign 4, 0
off_802F814:
	.word byte_802F2E4
off_802F818:
	.word dword_802F334
	thumb_func_end menu_onStartPressBeginTransition_802F7E8

// symdb: Handles menu navigation inputs (Start to exit, L/R to cycle selection index) for a small in-game menu.
// symdb: void sub_802F81C(u32 toolkit_ptr /* r10 */, u8 *menu_state /* r5 */, u32 arg2 /* r2 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802F81C.yaml
	thumb_local_start
sub_802F81C:
	push {lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	ldrh r0, [r7,#oJoypad_Pressed]
	mov r1, #9
	tst r1, r0
	beq loc_802F848
	bl IsScreenFadeActive // () -> zf
	beq locret_802F88C
	bl musicGameState_8000784 // () -> void
	mov r0, #0x9d
	bl PlaySoundEffect
	mov r0, #0x10
	strb r0, [r5,#1]
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	b locret_802F88C
loc_802F848:
	ldrh r0, [r7,#4]
	mov r1, #0x40 
	tst r1, r0
	beq loc_802F86A
	ldrb r0, [r5,#8]
	mov r1, r0
	sub r0, #1
	bge loc_802F85C
	ldrb r0, [r5,#9]
	sub r0, #1
loc_802F85C:
	strb r0, [r5,#8]
	cmp r0, r1
	beq locret_802F88C
	mov r0, #SOUND_UNK_66
	bl PlaySoundEffect
	b locret_802F88C
loc_802F86A:
	ldrh r0, [r7,#4]
	mov r1, #0x80
	tst r1, r0
	beq locret_802F88C
	ldrb r0, [r5,#8]
	mov r1, r0
	add r0, #1
	ldrb r2, [r5,#9]
	cmp r0, r2
	blt loc_802F880
	mov r0, #0
loc_802F880:
	strb r0, [r5,#8]
	cmp r0, r1
	beq locret_802F88C
	mov r0, #SOUND_UNK_66
	bl PlaySoundEffect
locret_802F88C:
	pop {pc}
	thumb_func_end sub_802F81C

// symdb: Per-frame refresh hook that, during frames 0-32 of a 64-frame cycle, resubmits an object's GFX request table (5 entries) to the script list runner for a Toolkit referenced by r10.
// symdb: void sub_802F88E(u32 toolkit /* r10 */); /* no return; clobbers r0-r3, lr, N/Z/C/V; preserves
// symdb: r4-r7 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802F88E.yaml
	thumb_local_start
sub_802F88E:
	push {r4-r7,lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_CurFramePtr]
	ldrh r0, [r0]
	mov r1, #0x3f 
	and r0, r1
	cmp r0, #0x20 
	bgt locret_802F8A4
	ldr r0, off_802F8A8 // =byte_802F8AC
	bl scriptListRun_8001158 // () -> void
locret_802F8A4:
	pop {r4-r7,pc}
	.balign 4, 0
off_802F8A8:
	.word byte_802F8AC
byte_802F8AC:
	.byte 0x78, 0x40, 0x34, 0x80, 0x1, 0x20, 0x0, 0x0, 0x78, 0x40
	.byte 0x54, 0x80, 0x9, 0x20, 0x0, 0x0, 0x78, 0x40, 0x74, 0x80
	.byte 0x11, 0x20, 0x0, 0x0, 0x78, 0x40, 0x94, 0x80, 0x19, 0x20
	.byte 0x0, 0x0, 0x78, 0x80, 0xB4, 0x0, 0x21, 0x20, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_802F88E

// symdb: Per-frame title screen drawing: steps the animation counters, places the cursor, runs the OAM scripts and one script per achievement flag set.
// symdb: void sub_802F8D8(StartScreen *self /* r5 */)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/startScreen_updateFrame_802F8D8.yaml
	thumb_local_start
startScreen_updateFrame_802F8D8: // (self: *mut StartScreen $r5) -> ()
	push {r4-r7,lr}
	ldrb r0, [r5,#6]
	add r0, #1
	cmp r0, #0x12
	blt loc_802F8E4
	mov r0, #0
loc_802F8E4:
	strb r0, [r5,#6]
	ldrb r0, [r5,#7]
	add r0, #1
	cmp r0, #0x40 
	blt loc_802F8F0
	mov r0, #0
loc_802F8F0:
	strb r0, [r5,#7]
	ldrb r0, [r5,#6]
	lsl r0, r0, #1
	ldr r1, off_802F96C // =byte_802F970
	ldrh r1, [r1,r0]
	ldrb r2, [r5,#8]
	lsl r2, r2, #2
	ldr r0, off_802F95C // =byte_802F960
	ldr r0, [r0,r2]
	mov r2, #0
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldrb r0, [r5,#8]
	bl sprite_submitOamSet_802F994
	ldrb r0, [r5,#2]
	tst r0, r0
	bne loc_802F924
	bl notZero_eByte200AD04
	bne loc_802F936
	bl startScreen_TstZero // () -> !zf
	beq loc_802F936
	b loc_802F936
loc_802F924:
	ldrb r0, [r5,#8]
	bl playOamSeq_802F9EC
	bl notZero_eByte200AD04
	bne loc_802F936
	bl startScreen_TstZero // () -> !zf
	beq loc_802F936
loc_802F936:
	bl startScreen_runTriggerHandler_802FC9C // (self: *const StartScreen $r5) -> ()
	bl startScreen_playFlaggedSfx_802FC70 // (self: *const StartScreen $r5) -> ()
	bl startScreen_playSoundIfFlagSet_802FB64 // (self: *const StartScreen $r5) -> ()
	bl startScreen_fadeOutUpdateIfFlag40_802FB90 // (self: *const StartScreen $r5) -> ()
	bl startScreen_dispatchIfFlag20_802FBB4 // (self: *const StartScreen $r5) -> ()
	bl startScreen_playSoundIfFlagSet_802FBD8 // (self: *const StartScreen $r5) -> ()
	bl startScreen_printTextIfFlag3_802FBFC // (self: *const StartScreen $r5) -> ()
	bl startScreen_onStatusBit2_802FC28 // (self: *const StartScreen $r5) -> ()
	bl startScreen_playSfxIfFlagSet_802FC4C // (self: *const StartScreen $r5) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_802F95C:
	.word byte_802F960
byte_802F960:
	.byte 0x71, 0x0, 0x49, 0x40, 0x80, 0x0, 0x49, 0x40, 0x91, 0x0
	.byte 0x49, 0x40
off_802F96C:
	.word byte_802F970
byte_802F970:
	.byte 0x40, 0x11, 0x40, 0x11, 0x40, 0x11, 0x40, 0x11, 0x40
	.byte 0x11, 0x40, 0x11, 0x44, 0x11, 0x44, 0x11, 0x44, 0x11
	.byte 0x44, 0x11, 0x44, 0x11, 0x44, 0x11, 0x48, 0x11, 0x48
	.byte 0x11, 0x48, 0x11, 0x48, 0x11, 0x48, 0x11, 0x48, 0x11
	thumb_func_end startScreen_updateFrame_802F8D8

// symdb: Selects one of three ROM OAM sprite data sets by index and passes it to the sprite rendering routine for on-screen submission.
// symdb: void sprite_submitOamSet_802F994(u32 index /*0-2*/); // clobbers: r0, r1, c, v; preserves r4-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_submitOamSet_802F994.yaml
	thumb_local_start
sprite_submitOamSet_802F994:
	push {r4-r7,lr}
	ldr r1, off_802F9A4 // =off_802F9A8 
	lsl r0, r0, #2
	ldr r0, [r0,r1]
	bl scriptListRun_8001158 // () -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_802F9A4:
	.word off_802F9A8
off_802F9A8:
	.word byte_802F9B4
	.word byte_802F9D0
	.word byte_802F9D0
byte_802F9B4:
	.byte 0x70, 0x40, 0x58, 0x80, 0x23, 0x30, 0x0, 0x0, 0x70, 0x40
	.byte 0x78, 0x80, 0x2B, 0x30, 0x0, 0x0, 0x70, 0x0, 0x98, 0x40
	.byte 0x33, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
byte_802F9D0:
	.byte 0x70, 0x40, 0x58, 0x80, 0x23, 0x40, 0x0, 0x0, 0x70, 0x40
	.byte 0x78, 0x80, 0x2B, 0x40, 0x0, 0x0, 0x70, 0x0, 0x98, 0x40
	.byte 0x33, 0x40, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end sprite_submitOamSet_802F994

// symdb: Plays one of a small set of 7-byte-per-frame OAM animation sequences by indexing into a 3-entry pointer table.
// symdb: void playOamSeq_802F9EC(u32 index /* r0 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/playOamSeq_802F9EC.yaml
	thumb_local_start
playOamSeq_802F9EC:
	push {r4-r7,lr}
	ldr r1, off_802F9FC // =off_802FA00 
	lsl r0, r0, #2
	ldr r0, [r0,r1]
	bl scriptListRun_8001158 // () -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_802F9FC:
	.word off_802FA00
off_802FA00:
	.word byte_802FA28
	.word byte_802FA0C
	.word byte_802FA28
byte_802FA0C:
	.byte 0x7F, 0x40, 0x58, 0x80, 0x37, 0x30, 0x0, 0x0, 0x7F, 0x40
	.byte 0x78, 0x80, 0x3F, 0x30, 0x0, 0x0, 0x7F, 0x0, 0x98, 0x40
	.byte 0x47, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
byte_802FA28:
	.byte 0x7F, 0x40, 0x58, 0x80, 0x37, 0x40, 0x0, 0x0, 0x7F, 0x40
	.byte 0x78, 0x80, 0x3F, 0x40, 0x0, 0x0, 0x7F, 0x0, 0x98, 0x40
	.byte 0x47, 0x40, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end playOamSeq_802F9EC

	thumb_local_start
dead_802FA44: // (self: *const StartScreen? $r5) -> ()
	push {r4-r7,lr}
	ldrb r1, [r5,#9]
	cmp r1, #3
	blt loc_802FA58
	ldr r1, off_802FA70 // =off_802FA74 
	lsl r0, r0, #2
	ldr r0, [r0,r1]
	bl scriptListRun_8001158 // () -> void
	b locret_802FA62
loc_802FA58:
	ldr r1, off_802FA64 // =off_802FA68 
	lsl r0, r0, #2
	ldr r0, [r0,r1]
	bl scriptListRun_8001158 // () -> void
locret_802FA62:
	pop {r4-r7,pc}
	.balign 4, 0
off_802FA64:
	.word off_802FA68
off_802FA68:
	.word byte_802FAEC
	.word byte_802FAC8
off_802FA70:
	.word off_802FA74
off_802FA74:
	.word byte_802FAA4
	.word byte_802FAA4
	.word byte_802FA80
byte_802FA80:
	.byte 0x80, 0x40, 0x58, 0x80, 0x4B, 0x30, 0x0, 0x0, 0x80, 0x40
	.byte 0x78, 0x80, 0x53, 0x30, 0x0, 0x0, 0x80, 0x0, 0x98, 0x40
	.byte 0x5B, 0x30, 0x0, 0x0, 0x80, 0x80, 0xA8, 0x0, 0x5F, 0x30
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
byte_802FAA4:
	.byte 0x80, 0x40, 0x58, 0x80, 0x4B, 0x40, 0x0, 0x0, 0x80, 0x40
	.byte 0x78, 0x80, 0x53, 0x40, 0x0, 0x0, 0x80, 0x0, 0x98, 0x40
	.byte 0x5B, 0x40, 0x0, 0x0, 0x80, 0x80, 0xA8, 0x0, 0x5F, 0x40
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
byte_802FAC8:
	.byte 0x70, 0x40, 0x58, 0x80, 0x4B, 0x30, 0x0, 0x0, 0x70, 0x40
	.byte 0x78, 0x80, 0x53, 0x30, 0x0, 0x0, 0x70, 0x0, 0x98, 0x40
	.byte 0x5B, 0x30, 0x0, 0x0, 0x70, 0x80, 0xA8, 0x0, 0x5F, 0x30
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
byte_802FAEC:
	.byte 0x70, 0x40, 0x58, 0x80, 0x4B, 0x40, 0x0, 0x0, 0x70, 0x40
	.byte 0x78, 0x80, 0x53, 0x40, 0x0, 0x0, 0x70, 0x0, 0x98, 0x40
	.byte 0x5B, 0x40, 0x0, 0x0, 0x70, 0x80, 0xA8, 0x0, 0x5F, 0x40
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end dead_802FA44

// () -> void
// symdb: Loads the title-screen VRAM/tile blob (byte_802FB20) by handing it to sub_8001158.
// symdb: void sub_802FB10(void);  // inputs: none read; clobbers: r0-r3, lr, NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/loadTitleBlob_802FB10.yaml
	thumb_local_start
loadTitleBlob_802FB10:
	push {r4-r7,lr}
	ldr r0, off_802FB1C // =byte_802FB20
	bl scriptListRun_8001158 // () -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_802FB1C:
	.word byte_802FB20
byte_802FB20:
	.byte 0x7E, 0x0, 0x0, 0x80, 0x80, 0x61, 0x0, 0x0, 0x7E, 0x0, 0x20
	.byte 0x80, 0x90, 0x61, 0x0, 0x0, 0x7E, 0x0, 0x40, 0x80, 0xA0, 0x61
	.byte 0x0, 0x0, 0x7E, 0x0, 0x60, 0x80, 0xB0, 0x61, 0x0, 0x0, 0x7E
	.byte 0x0, 0x80, 0x80, 0xC0, 0x61, 0x0, 0x0, 0x7E, 0x0, 0xA0, 0x80
	.byte 0xD0, 0x61, 0x0, 0x0, 0x7E, 0x0, 0xC0, 0x80, 0xE0, 0x61, 0x0
	.byte 0x0, 0x7E, 0x0, 0xE0, 0x80, 0xF0, 0x61, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0
	thumb_func_end loadTitleBlob_802FB10

// symdb: On the start/title screen, if the screen state halfword has flag 0x80 set, feeds the small audio command table at byte_802FB7C to the sound sequencer helper sub_8001158 (e.g. a jingle/cursor sound), otherwise does nothing.
// symdb: void sub_802FB64(const StartScreen* self /* r5 */) /* clobbers r0,r1,r2,r3, flags; sets C,V */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_playSoundIfFlagSet_802FB64.yaml
	thumb_local_start
startScreen_playSoundIfFlagSet_802FB64: // (self: *const StartScreen $r5) -> ()
	push {lr}
	ldrh r0, [r5,#0xa]
	mov r1, #0x80
	tst r0, r1
	beq locret_802FB74
	ldr r0, off_802FB78 // =byte_802FB7C
	bl scriptListRun_8001158 // () -> void
locret_802FB74:
	pop {pc}
	.balign 4, 0
off_802FB78:
	.word byte_802FB7C
byte_802FB7C:
	.byte 0x2, 0x40, 0x4, 0x80, 0x80, 0x92, 0x0, 0x0, 0x12, 0x40, 0x4
	.byte 0x40, 0x88, 0x92, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end startScreen_playSoundIfFlagSet_802FB64

// symdb: On the start screen, when state field 0xA has flag 0x40 set, runs one step of the fade/transition routine driven by the parameter table byte_802FBA8.
// symdb: void sub_802FB90(StartScreen *self /* r5 */); outputs: r2/r3/c/v as left by sub_8001158; r4-r7
// symdb: preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_fadeOutUpdateIfFlag40_802FB90.yaml
	thumb_local_start
startScreen_fadeOutUpdateIfFlag40_802FB90: // (self: *const StartScreen $r5) -> ()
	push {lr}
	ldrh r0, [r5,#0xa]
	mov r1, #0x40 
	tst r0, r1
	beq locret_802FBA0
	ldr r0, off_802FBA4 // =byte_802FBA8
	bl scriptListRun_8001158 // () -> void
locret_802FBA0:
	pop {pc}
	.balign 4, 0
off_802FBA4:
	.word byte_802FBA8
byte_802FBA8:
	.byte 0x4, 0x40, 0x2C, 0x80, 0x20, 0x82, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end startScreen_fadeOutUpdateIfFlag40_802FB90

// symdb: Checks the start-screen object's state halfword for flag 0x20 and, if set, hands a ROM-based record (byte_802FBCC) to helper sub_8001158.
// symdb: void startScreen_dispatchIfFlag20_802FBB4(const StartScreen *self /* r5 */); caller-saved r0-r3,
// symdb: flags c/v returned as-is, nz set by the tst
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_dispatchIfFlag20_802FBB4.yaml
	thumb_local_start
startScreen_dispatchIfFlag20_802FBB4: // (self: *const StartScreen $r5) -> ()
	push {lr}
	ldrh r0, [r5,#0xa]
	mov r1, #0x20 
	tst r0, r1
	beq locret_802FBC4
	ldr r0, off_802FBC8 // =byte_802FBCC
	bl scriptListRun_8001158 // () -> void
locret_802FBC4:
	pop {pc}
	.balign 4, 0
off_802FBC8:
	.word byte_802FBCC
byte_802FBCC:
	.byte 0x4, 0x40, 0x54, 0x80, 0x30, 0x82, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end startScreen_dispatchIfFlag20_802FBB4

// symdb: On the title/start screen, plays a fixed sound or voice clip when status bit 0x10 is set.
// symdb: void startScreen_playSoundIfFlagSet_802FBD8(StartScreen *screen /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_playSoundIfFlagSet_802FBD8.yaml
	thumb_local_start
startScreen_playSoundIfFlagSet_802FBD8: // (self: *const StartScreen $r5) -> ()
	push {lr}
	ldrh r0, [r5,#0xa]
	mov r1, #0x10
	tst r0, r1
	beq locret_802FBE8
	ldr r0, off_802FBEC // =byte_802FBF0
	bl scriptListRun_8001158 // () -> void
locret_802FBE8:
	pop {pc}
	.balign 4, 0
off_802FBEC:
	.word byte_802FBF0
byte_802FBF0:
	.byte 0x4, 0x40, 0x7C, 0x80, 0x40, 0x82, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end startScreen_playSoundIfFlagSet_802FBD8

// symdb: On the title/start screen, if the screen's state field has bit 3 set, hands a two-entry text/sprite descriptor table to the text printer helper sub_8001158.
// symdb: void startScreen_printTextIfFlag3_802FBFC(const StartScreen *screen /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_printTextIfFlag3_802FBFC.yaml
	thumb_local_start
startScreen_printTextIfFlag3_802FBFC: // (self: *const StartScreen $r5) -> ()
	push {lr}
	ldrh r0, [r5,#0xa]
	mov r1, #8
	tst r0, r1
	beq locret_802FC0C
	ldr r0, off_802FC10 // =byte_802FC14
	bl scriptListRun_8001158 // () -> void
locret_802FC0C:
	pop {pc}
	.balign 4, 0
off_802FC10:
	.word byte_802FC14
byte_802FC14:
	.byte 0x14, 0x40, 0x8E, 0x80, 0x10, 0x72, 0x0, 0x0, 0x24, 0x40
	.byte 0x8E, 0x40, 0x18, 0x72, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end startScreen_printTextIfFlag3_802FBFC

// symdb: Start-screen helper that, when the screen state word has bit 2 set, hands a small parameter table (byte_802FC40) to the generic handler sub_8001158.
// symdb: void startScreen_onStatusBit2(const StartScreen* self /* r5 */); // reads u16 at self+0xA; no
// symdb: meaningful return value, clobbers r0-r3 and flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_onStatusBit2_802FC28.yaml
	thumb_local_start
startScreen_onStatusBit2_802FC28: // (self: *const StartScreen $r5) -> ()
	push {lr}
	ldrh r0, [r5,#0xa]
	mov r1, #4
	tst r0, r1
	beq locret_802FC38
	ldr r0, off_802FC3C // =byte_802FC40
	bl scriptListRun_8001158 // () -> void
locret_802FC38:
	pop {pc}
	.balign 4, 0
off_802FC3C:
	.word byte_802FC40
byte_802FC40:
	.byte 0x4, 0x40, 0xA4, 0x80, 0x50, 0x82, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end startScreen_onStatusBit2_802FC28

// symdb: On the start/title screen, plays a sound effect (via sub_8001158) when the screen's state field has bit 1 set, otherwise does nothing.
// symdb: void startScreen_playSfxIfFlagSet(const StartScreen *self /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_playSfxIfFlagSet_802FC4C.yaml
	thumb_local_start
startScreen_playSfxIfFlagSet_802FC4C: // (self: *const StartScreen $r5) -> ()
	push {lr}
	ldrh r0, [r5,#0xa]
	mov r1, #2
	tst r0, r1
	beq locret_802FC5C
	ldr r0, off_802FC60 // =byte_802FC64
	bl scriptListRun_8001158 // () -> void
locret_802FC5C:
	pop {pc}
	.balign 4, 0
off_802FC60:
	.word byte_802FC64
byte_802FC64:
	.byte 0x4, 0x40, 0xCC, 0x80, 0x60, 0x82, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end startScreen_playSfxIfFlagSet_802FC4C

// symdb: Start-screen per-frame helper that, when bit 0x100 of the screen state halfword is set, triggers the sound/effect described by the parameter table byte_802FC88.
// symdb: void startScreen_playFlaggedSfx_802FC70(const StartScreen *self /*r5*/) — reads r5; calls into
// symdb: sub_8001158 with r0 = &byte_802FC88; returns with r4-r7 preserved (caller must reload them per
// symdb: the contract, the callee preserves them); C is cleared by the mask-setup shift on the early-out
// symdb: path, N/Z reflect (state & 0x100), V untouched.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_playFlaggedSfx_802FC70.yaml
	thumb_local_start
startScreen_playFlaggedSfx_802FC70: // (self: *const StartScreen $r5) -> ()
	push {lr}
	ldrh r0, [r5,#0xa]
	mov r1, #0x10
	lsl r1, r1, #4
	tst r0, r1
	beq locret_802FC82
	ldr r0, off_802FC84 // =byte_802FC88
	bl scriptListRun_8001158 // () -> void
locret_802FC82:
	pop {pc}
	.balign 4, 0
off_802FC84:
	.word byte_802FC88
byte_802FC88:
	.byte 0x14, 0x40, 0x40, 0x80, 0x0, 0x72, 0x0, 0x0, 0x24, 0x40
	.byte 0x40, 0x40, 0x8, 0x72, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end startScreen_playFlaggedSfx_802FC70

// symdb: Start-screen hook that, when state flag 0x200 in the screen-state word is set, passes a fixed parameter block to the generic sub_8001158 handler and otherwise does nothing.
// symdb: void sub_802FC9C(const StartScreen *self /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_runTriggerHandler_802FC9C.yaml
	thumb_local_start
startScreen_runTriggerHandler_802FC9C: // (self: *const StartScreen $r5) -> ()
	push {lr}
	ldrh r0, [r5,#0xa]
	mov r1, #0x20 
	lsl r1, r1, #4
	tst r0, r1
	beq locret_802FCAE
	ldr r0, off_802FCB0 // =byte_802FCB4
	bl scriptListRun_8001158 // () -> void
locret_802FCAE:
	pop {pc}
	.balign 4, 0
off_802FCB0:
	.word byte_802FCB4
byte_802FCB4:
	.byte 0x16, 0x40, 0x6C, 0x80, 0x70, 0xA2, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0
	thumb_func_end startScreen_runTriggerHandler_802FC9C

// symdb: Initializes the title-screen graphics by clearing VRAM, decompressing the start-screen asset tables, and zeroing the 0x30025c0 GFX region.
// symdb: void startScreen_initGfx_802FCC0(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_initGfx_802FCC0.yaml
	thumb_local_start
startScreen_initGfx_802FCC0:
	push {r4-r7,lr}
	bl zeroFillVRAM // () -> ()
	// initRefs
	ldr r0, off_802FCD4 // =initRefs_802FCD8 
	bl decompAndCopyData // (u32 *initRefs) -> void
	bl ZeroFillGFX30025c0
	pop {r4-r7,pc}
	.balign 4, 0
off_802FCD4:
	.word initRefs_802FCD8
initRefs_802FCD8:
	.word comp_87F36A0 + COMPRESSED_PTR_FLAG
	.word 0x6013000
	.word eDecompBuffer2013A00

	.word byte_87F40F4
	.word byte_3001610
	.word 0xA0

	.word comp_87F3370 + COMPRESSED_PTR_FLAG
	.word 0x6010020
	.word eDecompBuffer2013A00

	.word dword_87F3620
	.word byte_3001590
	.word 0x80

	.word comp_87F4394 + COMPRESSED_PTR_FLAG
	.word 0x6000000
	.word eDecompBuffer2013A00

	.word dword_87F4194
	.word palette_3001960
	.word 0x1C0

	.word byte_86A48C0
	.word 0x6012800
	.word 0x180

	.word dword_86A5500
	.word byte_3001570
	.word 0x20

	.word NULL
	thumb_func_end startScreen_initGfx_802FCC0

// symdb: Blits a fixed 32x20-tile background tile map (byte_87F8EB0) into 32x32 tile block 1 of the BG.
// symdb: void bg_CopyFixedTileMap_32x20(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyBGTiles_802FD3C.yaml
	thumb_local_start
copyBGTiles_802FD3C:
	push {r5,lr}
	// j
	mov r0, #0
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #1
	// tileIds
	ldr r3, off_802FD50 // =byte_87F8EB0 
	mov r4, #0x20 
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r5,pc}
	.balign 4, 0
off_802FD50:
	.word byte_87F8EB0
	thumb_func_end copyBGTiles_802FD3C

// symdb: Refreshes the StartScreen object's state byte based on a precondition test and a mode flag.
// symdb: void sub_802FD54(u32 /*r5*/ self); // preserves r4-r7; clobbers r0,r1,lr,nz
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_802FD54.yaml
	thumb_local_start
sub_802FD54: // (self: *mut StartScreen $r5) -> ()
	push {r4-r7,lr}
	bl startScreen_TstZero // () -> !zf
	beq locret_802FD68
	mov r1, #2
	ldrb r0, [r5,#2]
	tst r0, r0
	beq loc_802FD66
	mov r1, #3
loc_802FD66:
	strb r1, [r5,#9]
locret_802FD68:
	pop {r4-r7,pc}
	.balign 4, 0
	.word eStartScreenAnimationControl200B1A0
off_802FD70::
	.word unk_30025B0
dword_802FD74:
	.word 0x8
	.word unk_3002580
	.byte 0x4, 0x0, 0x0, 0x0, 0xB0, 0xE, 0x0, 0x3, 0xA0, 0x2, 0x0, 0x0, 0x70, 0x21
	.byte 0x0, 0x3, 0x4, 0x0, 0x0, 0x0
byte_802FD90:
	.byte 0xB0, 0x25, 0x0, 0x3, 0x8, 0x0, 0x0, 0x0, 0x80, 0x25, 0x0, 0x3, 0x4
	.byte 0x0, 0x0, 0x0, 0xB0, 0xE, 0x0, 0x3, 0xE0, 0x0, 0x0, 0x0, 0x70, 0x21
	.byte 0x0, 0x3, 0x4, 0x0, 0x0, 0x0
	thumb_func_end sub_802FD54

// End Module StartScreen_

/// Breaks on reset twice
/// Breaks on "Continue"
/// Breaks on entering and existing PET menus
// symdb: Resets the sprite layer lists and the sprite pool from layout table 0 (iSpriteLayerLists, iSpritePool, iSpritePoolUsed).
// symdb: void sub_802FDB0(void); leaves r3 = end of the table walked, which callers may read
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_802FDB0.yaml
	thumb_func_start sub_802FDB0
sub_802FDB0:
	mov r0, #0
	b loc_802FDB6
// symdb: Second entry of sub_802FDB0: resets the sprite layer lists and pool from layout table 1.
// symdb: void loc_802FDB4(void); leaves r3 = end of the table walked
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/loc_802FDB4.yaml
loc_802FDB4:
	mov r0, #4
loc_802FDB6:
	ldr r1, off_802FDF0 // =off_802FDF4 
	ldr r0, [r1,r0]
	push {r4,lr}
    mov r4, r0
    
    ldr r1, off_802FE08 // =iSpriteLayerLists 
	mov r2, #0x20 
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	
    mov r2, #0
	mvn r2, r2
	mov r3, r4
	mov r4, #4
loc_802FDCE:
	ldr r0, [r3]
	ldr r1, [r3,#4]
	bl WordFill
	
    add r3, #8
	sub r4, #1
	cmp r4, #0
	bgt loc_802FDCE
	
    ldr r0, off_802FE04 // =iSpritePool 
	ldr r1, off_802FDFC // =0x400 
	bl ZeroFillByEightWords // (int a1, int a2) -> void

	ldr r0, off_802FE00 // =iSpritePoolUsed 
	mov r1, #0
	str r1, [r0]
	pop {r4,pc}
	.balign 4, 0
off_802FDF0:
	.word off_802FDF4
off_802FDF4:
	.word off_802FD70
	.word byte_802FD90
off_802FDFC:
	.word 0x400
off_802FE00:
	.word iSpritePoolUsed
off_802FE04:
	.word iSpritePool
off_802FE08:
	.word iSpriteLayerLists
	thumb_func_end sub_802FDB0

// symdb: Copies the entire shadow OAM (iOamShadow, 0x400 bytes) into hardware OAM at 0x7000000, an end-of-frame sprite buffer flush.
// symdb: void oam_FlushShadowOamToHardware_802FE0C(/* preserved passthrough in r3 */); registers: in r3
// symdb: (ignored, passed through unchanged), out r3 (same value); clobbers r0-r2, lr, NZC flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyObjAttributesToIWRAM_802FE0C.yaml
	thumb_func_start copyObjAttributesToIWRAM_802FE0C
copyObjAttributesToIWRAM_802FE0C:
	push {lr}
	ldr r0, off_802FE1C // =iOamShadow
	ldr r1, dword_802FE20 // =0x7000000 
	ldr r2, off_802FE24 // =0x400 
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	pop {pc}
	.balign 4, 0
off_802FE1C:
	.word iOamShadow
dword_802FE20:
	.word 0x7000000
off_802FE24:
	.word 0x400
	thumb_func_end copyObjAttributesToIWRAM_802FE0C

// (u32 a1, u16 a2, int notUsed, int a4) -> void
// symdb: Thumb→ARM tail-call trampoline that forwards r0–r3 and lr into sprite_queueOamEntry and returns straight to this function's caller.
// symdb: void sub_802FE28(u32 r0, u32 r1, u32 r2, u32 r3);   // lr = caller return   // preserved: r4,
// symdb: r5, r6, r7   // clobbers : NZCV (flags), r0, r4–r7, lr via tail call   // tail-calls
// symdb: sprite_queueOamEntry (ARM, +1) with identical r0..r3 and lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_queueOamEntryThunk_802FE28.yaml
	thumb_func_start sprite_queueOamEntryThunk_802FE28
sprite_queueOamEntryThunk_802FE28:
	push {r4,lr}
	ldr r4, off_802FE34 // =sprite_queueOamEntry+1 
	mov lr, pc
	bx r4
	pop {r4,pc}
	.balign 4, 0x00
off_802FE34:
	.word sprite_queueOamEntry+1
	thumb_func_end sprite_queueOamEntryThunk_802FE28

	thumb_local_start
sub_802FE38:
	push {r4,lr}
	ldr r4, off_802FE44 // =sprite_queueOamEntries+1 
	mov lr, pc
	bx r4
	pop {r4,pc}
	.balign 4, 0x00
off_802FE44:
	.word sprite_queueOamEntries+1
	thumb_func_end sub_802FE38

// symdb: Allocates one of 16 ID slots tracked in a bitfield at dword_2009A2C, returning the slot index (or 0xFF when all are taken).
// symdb: u32 allocSlotFromBitmap16(void); // in: lr only; out: r0 = slot index 0..15 or 0xFF if full, r1
// symdb: = updated bitmap word, r2 = mask of the bit claimed, r3 = &dword_2009A2C; clobbers NZCV
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_802FE48.yaml
	thumb_func_start sub_802FE48
sub_802FE48:
	ldr r3, off_802FF44 // =dword_2009A2C 
	ldr r1, [r3]
	mov r2, #0x80
	lsl r2, r2, #0x18
	mov r0, #0
loc_802FE52:
	tst r1, r2
	beq loc_802FE60
	lsr r2, r2, #1
	add r0, #1
	cmp r0, #0x10
	bge loc_802FE66
	b loc_802FE52
loc_802FE60:
	orr r1, r2
	str r1, [r3]
	mov pc, lr
loc_802FE66:
	mov r0, #0xff
	mov pc, lr
	thumb_func_end sub_802FE48

// symdb: Clears one bit, selected by an MSB-first index in r0, in the 32-bit flag word at dword_2009A2C.
// symdb: void flags_clearFlagWordBit(u8 bitIndex /* r0, 0 = bit 31 of the word ... 31 = bit 0 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/flags_clearFlagWordBit_802FE6A.yaml
	thumb_func_start flags_clearFlagWordBit_802FE6A
flags_clearFlagWordBit_802FE6A:
	ldr r3, off_802FF44 // =dword_2009A2C 
	ldr r1, [r3]
	mov r2, #0x80
	lsl r2, r2, #0x18
	lsr r2, r0
	bic r1, r2
	str r1, [r3]
	mov pc, lr
	thumb_func_end flags_clearFlagWordBit_802FE6A

	thumb_func_start sub_802FE7A
sub_802FE7A:
	push {r4-r7,lr}
	lsr r1, r1, #2
	lsr r2, r2, #2
	push {r0-r2}
	ldr r0, off_802FF48 // =word_200A6F0 
	mov r6, r0
	mov r1, #0xc
	mul r1, r3
	add r0, r0, r1
	add r3, #0x10
	mov r1, #0xc
	mul r1, r3
	add r6, r6, r1
	mov r5, #0
	mov r2, #0
	strb r2, [r6,#8]
	pop {r2}
	strb r2, [r0,#8]
	lsl r2, r2, #1
	pop {r3}
	mov r7, r3
	bl sub_802FF10
	strb r3, [r0,#9]
	mov r3, r7
	ldr r1, off_802FF0C // =math_cosTable 
	ldrsh r4, [r1,r5]
	mul r4, r3
	lsr r4, r4, #4
	strh r4, [r6]
	ldrsh r4, [r1,r2]
	mul r4, r3
	lsr r4, r4, #4
	strh r4, [r0]
	ldr r1, off_802FF08 // =math_sinTable 
	ldrsh r4, [r1,r5]
	mul r4, r3
	lsr r4, r4, #4
	strh r4, [r6,#2]
	ldrsh r4, [r1,r2]
	mul r4, r3
	lsr r4, r4, #4
	strh r4, [r0,#2]
	pop {r3}
	mov r7, r3
	bl sub_802FF10
	strb r3, [r0,#0xa]
	mov r3, r7
	ldr r1, off_802FF0C // =math_cosTable 
	ldrsh r4, [r1,r5]
	mul r4, r3
	lsr r4, r4, #4
	strh r4, [r6,#6]
	ldrsh r4, [r1,r2]
	mul r4, r3
	lsr r4, r4, #4
	strh r4, [r0,#6]
	ldr r1, off_802FF08 // =math_sinTable 
	ldrsh r4, [r1,r5]
	neg r4, r4
	mul r4, r3
	lsr r4, r4, #4
	strh r4, [r6,#4]
	ldrsh r4, [r1,r2]
	neg r4, r4
	mul r4, r3
	lsr r4, r4, #4
	strh r4, [r0,#4]
	pop {r4-r7,pc}
	.balign 4, 0
off_802FF08:
	.word math_sinTable
off_802FF0C:
	.word math_cosTable
	thumb_func_end sub_802FE7A

	thumb_local_start
sub_802FF10:
	push {r1,r2}
	mov r1, #0x10
	lsl r1, r1, #4
	mov r2, #0
	cmp r3, #0
	beq loc_802FF26
loc_802FF1C:
	cmp r1, r3
	blt loc_802FF26
	sub r1, r1, r3
	add r2, #1
	b loc_802FF1C
loc_802FF26:
	mov r3, r2
	pop {r1,r2}
	mov pc, lr
	thumb_func_end sub_802FF10

// symdb: Resets a global state word to 0 and zeroes a 0x180-byte work buffer, likely preparing shared game/battle scratch state for reuse.
// symdb: void state_resetAndClearBuffer(void); // r2/r3 preserved, r0/r1/lr clobbered, flags whatever
// symdb: ZeroFillByEightWords leaves
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/cleareMemory_802FF2C.yaml
	thumb_func_start cleareMemory_802FF2C
cleareMemory_802FF2C:
	push {lr}
	ldr r0, off_802FF44 // =dword_2009A2C 
	mov r1, #0
	str r1, [r0]
	ldr r0, off_802FF48 // =word_200A6F0 
	ldr r1, off_802FF40 // =0x180 
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	pop {pc}
	.balign 4, 0
off_802FF40:
	.word 0x180
off_802FF44:
	.word dword_2009A2C
off_802FF48:
	.word word_200A6F0
	thumb_func_end cleareMemory_802FF2C

// file bounds: Here we enter clearly camera territory

	thumb_func_start camera_init_802FF4C
// r3 - map group
// r4 - map number
// only map related data is a jumptable index
// that's the same for every map group type
// symdb: Initialize the field camera for a newly entered map: clear its block, set movement limits from the map size, snap it to the player's position, pick the shake setting for the map group, and run the camera update chain.
// symdb: (r0: u32 player_x, r1: u32 player_y, r2: u32 player_z, r3: u32 map_group, r4: u32 map_number,
// symdb: r10: *const Toolkit) -> (); preserves r5-r9/r12, leaves nz/c/v clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_init_802FF4C.yaml
camera_init_802FF4C: // (player_x: u32, player_y: u32, player_z: u32, map_group: u8, map_number: u8) -> ()
	push {r5-r7,lr}
	mov r5, r8
	mov r6, r9
	mov r7, r12
	push {r5-r7}
	push {r3,r4}

	push {r0-r2}

	mov r5, r10
	ldr r5, [r5,#oToolkit_CameraPtr]
	ldrb r0, [r5,#oCamera_Unk_03]
	ldr r1, [r5,#oCamera_Unk_14]
	push {r0,r1,r5}
	mov r0, r10
	// memBlock
	ldr r0, [r0,#oToolkit_CameraPtr]
	// size
	mov r1, #0x4c 
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()

	pop {r0,r1,r5}
	strb r0, [r5,#oCamera_Unk_03]
	str r1, [r5,#oCamera_Unk_14]

	ldr r0, off_802FFF0 // =eMapTilesState200be70

	ldrb r3, [r0,#oMapTilesState200be70_MapWidth]
	sub r3, #0x1e
	lsl r3, r3, #0x12
	str r3, [r5,#oCamera_Unk_1c]

	neg r3, r3
	str r3, [r5,#oCamera_Unk_18]

	ldrb r3, [r0,#oMapTilesState200be70_MapHeight] // (byte_200BE71 - 0x200be70)
	sub r3, #0x14
	lsl r3, r3, #0x12
	str r3, [r5,#oCamera_Unk_20]

	neg r3, r3
	str r3, [r5,#oCamera_Unk_24]

	pop {r1-r3}
	str r1, [r5,#oCamera_X]
	str r2, [r5,#oCamera_Y]
	str r3, [r5,#oCamera_Z]

	mov r1, #0
	strh r1, [r5,#oCamera_Unk_04]
	strh r1, [r5,#oCamera_Unk_06]

	pop {r0,r1}

	cmp r0, #0xf0
	bge loc_802FFB8

	cmp r0, #0xe0
	bge loc_802FFBC

	cmp r0, #0xd0
	bge loc_802FFC0

	cmp r0, #0x80
	bge loc_802FFB2

	ldr r3, off_802FFE8 // =off_8033770 // [*const [u8]; REAL_WORLD_NUM_GROUPS]
	b loc_802FFC4
loc_802FFB2:
	ldr r3, off_802FFEC // =off_803378C // [Nullable<*const [u8]>; REAL_WORLD_NUM_GROUPS]
	sub r0, #0x80
	b loc_802FFC4
loc_802FFB8:
	mov r0, #8
	b loc_802FFCA
loc_802FFBC:
	mov r0, #0xc
	b loc_802FFCA
loc_802FFC0:
	mov r0, #0x10
	b loc_802FFCA
loc_802FFC4:
	lsl r0, r0, #2
	ldr r3, [r3,r0]
	// bad read? [off_8033770+mapGroup] is byte array
	// but doesn't actually matter since all values
	// of all arrays are the same
	ldr r0, [r3,r1]
loc_802FFCA:
	strb r0, [r5,#oCamera_Unk_02]
	bl camera_doShakeEffect_80301e8
	bl camera_dispatchUpdate_8030054
	bl sub_80302D0
	bl camera_SavePosition_803011A
	pop {r5-r7}
	mov r8, r5
	mov r9, r6
	mov r12, r7
	pop {r5-r7,pc}
	.balign 4, 0
off_802FFE8:
	.word off_8033770 // [*const [u8]; REAL_WORLD_NUM_GROUPS]
off_802FFEC:
	.word off_803378C // [Nullable<*const [u8]>; REAL_WORLD_NUM_GROUPS]
off_802FFF0:
	.word eMapTilesState200be70
	thumb_func_end camera_init_802FF4C

	thumb_func_start camera_802FFF4
camera_802FFF4:
	push {r4-r7,lr}
	mov r0, r8
	mov r1, r9
	mov r2, r12
	push {r0-r2}
	mov r5, r10
	ldr r5, [r5,#oToolkit_CameraPtr]
	ldr r0, off_8030030 // =off_8030034 
	ldrb r1, [r5,#oCamera_Unk_03]
	lsl r1, r1, #2
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	bl camera_doShakeEffect_80301e8
	bl camera_dispatchUpdate_8030054
	ldr r0, off_803003C // =off_8030040
	ldrb r1, [r5,#oCamera_Unk_02]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	bl camera_SavePosition_803011A
	pop {r0-r2}
	mov r8, r0
	mov r9, r1
	mov r12, r2
	pop {r4-r7,pc}
	.balign 4, 0
off_8030030:
	.word off_8030034
off_8030034:
	.word nullsub_7+1
	.word camera_LoadPositionFromSource_8030126+1
off_803003C:
	.word off_8030040
off_8030040:
	.word sub_8030136+1
	.word sub_8030136+1
	.word camera_applyScrollToBgLayers_8030158+1
	.word sub_8030194+1
	.word sub_8030136+1
	thumb_func_end camera_802FFF4

// symdb: Camera object update dispatcher — reads the camera's mode byte and jumps to the matching camera update handler from a small jump table.
// symdb: void camera_dispatchUpdate_8030054(void) — takes everything via registers/flags as-is (r5 =
// symdb: camera object); tail-returns whatever the selected handler leaves in registers and flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_dispatchUpdate_8030054.yaml
	thumb_local_start
camera_dispatchUpdate_8030054:
	push {lr}
	ldr r0, off_8030064 // =off_8030068
	ldrb r1, [r5,#oCamera_Unk_02]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {pc}
	.balign 4, 0x00
off_8030064:
	.word off_8030068
off_8030068:
	.word camera_updateDerivedOffsets_803007C+1
	.word camera_updateDerivedOffsets_803007C+1
	.word sub_80300AC+1
	.word sub_8030104+1
	.word camera_updateDerivedOffsets_803007C+1
	thumb_func_end camera_dispatchUpdate_8030054

// symdb: Recomputes two derived 16.16 fixed-point values in the camera state (offsets +4/+6) from the pending scroll target nextX/nextY/nextZ, negating the results.
// symdb: void camera_updateDerivedOffsets_803007C(Camera* cam /* r5 */); callers read back r1, r2, r4,
// symdb: r6, r7, r8 and the nzcv flags (final flags come from the last `neg r6, r6`, i.e. 0 - shifted)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_updateDerivedOffsets_803007C.yaml
	thumb_local_start
camera_updateDerivedOffsets_803007C:
	mov r1, #0x0 // byte_0
	ldr r4, [r5,#oCamera_nextX_3c]
	sub r1, r1, r4
	mov r6, #0
	ldr r4, [r5,#oCamera_nextY_40]
	sub r6, r6, r4
	mov r7, r6
	mov r8, r1
	add r1, r1, r6
	asr r1, r1, #0x10
	neg r1, r1
	strh r1, [r5,#oCamera_Unk_04]
	mov r6, r7
	mov r2, r8
	sub r6, r6, r2
	asr r6, r6, #1
	mov r4, #0
	sub r6, r6, r4
	ldr r2, [r5,#oCamera_nextZ_44]
	add r6, r6, r2
	asr r6, r6, #0x10
	neg r6, r6
	strh r6, [r5,#oCamera_Unk_06]
	mov pc, lr
	thumb_func_end camera_updateDerivedOffsets_803007C

	thumb_local_start
sub_80300AC:
	ldr r1, [r5,#oCamera_nextX_3c]
	ldr r2, [r5,#oCamera_Unk_18]
	cmp r1, r2
	bge loc_80300B6
	mov r1, r2
loc_80300B6:
	ldr r2, [r5,#oCamera_Unk_1c]
	cmp r1, r2
	ble loc_80300BE
	mov r1, r2
loc_80300BE:
	str r1, [r5,#oCamera_nextX_3c]
	asr r1, r1, #0x10
	strh r1, [r5,#oCamera_Unk_04]
	ldr r6, [r5,#oCamera_nextZ_44]
	ldr r4, [r5,#oCamera_nextY_40]
	ldr r2, [r5,#oCamera_Unk_24]
	add r2, r2, r6
	cmp r4, r2
	bge loc_80300D2
	mov r4, r2
loc_80300D2:
	ldr r2, [r5,#oCamera_Unk_20]
	add r2, r2, r6
	cmp r4, r2
	ble loc_80300DC
	mov r4, r2
loc_80300DC:
	str r4, [r5,#oCamera_nextY_40]
	mov r6, r4
	ldr r4, [r5,#oCamera_nextZ_44]
	ldr r2, [r5,#oCamera_Unk_24]
	add r2, r2, r6
	str r2, [r5,#oCamera_Unk_2c]
	cmp r4, r2
	bge loc_80300EE
	mov r4, r2
loc_80300EE:
	ldr r2, [r5,#oCamera_Unk_20]
	add r2, r2, r6
	str r2, [r5,#oCamera_Unk_28]
	cmp r4, r2
	ble loc_80300FA
	mov r4, r2
loc_80300FA:
	str r4, [r5,#oCamera_nextZ_44]
	sub r6, r6, r4
	asr r6, r6, #0x10
	strh r6, [r5,#oCamera_Unk_06]
locret_8030102:
	mov pc, lr
	thumb_func_end sub_80300AC

	thumb_local_start
sub_8030104:
	ldr r4, [r5,#oCamera_nextX_3c]
	asr r4, r4, #0x10
	add r4, #0x80
	add r4, #8
	strh r4, [r5,#oCamera_Unk_04]
	ldr r4, [r5,#oCamera_nextY_40]
	asr r4, r4, #0x10
	add r4, #0x80
	add r4, #0x30 
	strh r4, [r5,#oCamera_Unk_06]
	mov pc, lr
	thumb_func_end sub_8030104

// symdb: Copies the camera's current x/y position into its saved-position fields (Unk_04->Unk_08, Unk_06->Unk_0a).
// symdb: void camera_SavePosition(Camera* cam /* r5 */) /* returns r1 = saved y; lr = return */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_SavePosition_803011A.yaml
	thumb_local_start
camera_SavePosition_803011A:
	ldrh r1, [r5,#oCamera_Unk_04]
	strh r1, [r5,#oCamera_Unk_08]
	ldrh r1, [r5,#oCamera_Unk_06]
	strh r1, [r5,#oCamera_Unk_0a]
	mov pc, lr
	thumb_func_end camera_SavePosition_803011A

// symdb: Empty no-op stub that immediately returns; a placeholder for a removed or disabled feature call site.
// symdb: void nullsub_7(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_7.yaml
	thumb_local_start
nullsub_7:
	mov pc, lr
	thumb_func_end nullsub_7

// symdb: Copies a camera position (X/Y/Z) from the data block pointed to by the camera object's field oCamera_Unk_14 into the camera's own X/Y/Z fields.
// symdb: void sub_8030126(camera in r5); returns r7 = source block pointer, r2 = copied Z value
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_LoadPositionFromSource_8030126.yaml
	thumb_local_start
camera_LoadPositionFromSource_8030126:
	ldr r7, [r5,#oCamera_Unk_14]
	ldr r2, [r7]
	str r2, [r5,#oCamera_X]
	ldr r2, [r7,#4]
	str r2, [r5,#oCamera_Y]
	ldr r2, [r7,#8]
	str r2, [r5,#oCamera_Z]
	mov pc, lr
	thumb_func_end camera_LoadPositionFromSource_8030126

	thumb_local_start
sub_8030136:
	ldrh r1, [r5,#oCamera_Unk_04]
	ldrh r2, [r5,#oCamera_Unk_08]
	sub r1, r1, r2
	ldrh r4, [r5,#oCamera_Unk_06]
	ldrh r2, [r5,#oCamera_Unk_0a]
	sub r4, r4, r2
	mov r0, r10
	ldr r0, [r0,#oToolkit_RenderInfoPtr]
	ldrh r6, [r0,#oRenderInfo_Unk_10]
	add r6, r6, r1
	ldrh r7, [r0,#oRenderInfo_Unk_12]
	add r7, r7, r4
	strh r6, [r0,#oRenderInfo_Unk_10]
	strh r7, [r0,#oRenderInfo_Unk_12]
	strh r6, [r0,#oRenderInfo_Unk_14]
	strh r7, [r0,#oRenderInfo_Unk_16]
	mov pc, lr
	thumb_func_end sub_8030136

// symdb: Applies the camera's frame-to-frame movement delta to the background scroll positions, always scrolling the first background layer pair and also the second pair unless a check (sub_80269E2) says not to.
// symdb: int sub_8030158(CameraState* camera /*r5*/, Toolkit* toolkit /*r10*/)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_applyScrollToBgLayers_8030158.yaml
	thumb_local_start
camera_applyScrollToBgLayers_8030158:
	push {r4-r7,lr}
	ldrh r1, [r5,#oCamera_Unk_04]
	ldrh r2, [r5,#oCamera_Unk_08]
	sub r1, r1, r2
	ldrh r4, [r5,#oCamera_Unk_06]
	ldrh r2, [r5,#oCamera_Unk_0a]
	sub r4, r4, r2
	mov r0, r10
	ldr r0, [r0,#oToolkit_RenderInfoPtr]
	ldrh r6, [r0,#oRenderInfo_Unk_14]
	add r6, r6, r1
	ldrh r7, [r0,#oRenderInfo_Unk_16]
	add r7, r7, r4
	strh r6, [r0,#oRenderInfo_Unk_14]
	strh r7, [r0,#oRenderInfo_Unk_16]
	push {r1,r4}
	bl sub_80269E2
	pop {r1,r4}
	tst r0, r0
	bne locret_8030192
	mov r0, r10
	ldr r0, [r0,#oToolkit_RenderInfoPtr]
	ldrh r6, [r0,#oRenderInfo_Unk_18]
	add r6, r6, r1
	ldrh r7, [r0,#oRenderInfo_Unk_1a]
	add r7, r7, r4
	strh r6, [r0,#oRenderInfo_Unk_18]
	strh r7, [r0,#oRenderInfo_Unk_1a]
locret_8030192:
	pop {r4-r7,pc}
	thumb_func_end camera_applyScrollToBgLayers_8030158

	thumb_local_start
sub_8030194:
	ldrh r1, [r5,#oCamera_Unk_04]
	ldrh r2, [r5,#oCamera_Unk_08]
	sub r1, r1, r2
	ldrh r4, [r5,#oCamera_Unk_06]
	ldrh r2, [r5,#oCamera_Unk_0a]
	sub r4, r4, r2
	mov r0, r10
	ldr r0, [r0,#oToolkit_RenderInfoPtr]
	ldrh r6, [r0,#oRenderInfo_Unk_10]
	add r6, r6, r1
	ldrh r7, [r0,#oRenderInfo_Unk_12]
	add r7, r7, r4
	strh r6, [r0,#oRenderInfo_Unk_10]
	strh r7, [r0,#oRenderInfo_Unk_12]
	mov pc, lr
	thumb_func_end sub_8030194

// symdb: Writes a byte and a word into the camera struct, leaving a pointer to it in r2.
// symdb: void camera_setUnk03_andUnk14(u8 value /* r0 */, u32 word /* r1 */); returns camera ptr in r2
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_writeUnk03_14_80301b2.yaml
	thumb_func_start camera_writeUnk03_14_80301b2
camera_writeUnk03_14_80301b2:
	mov r2, r10
	ldr r2, [r2,#oToolkit_CameraPtr]
	strb r0, [r2,#oCamera_Unk_03]
	str r1, [r2,#oCamera_Unk_14]
	mov pc, lr
	thumb_func_end camera_writeUnk03_14_80301b2

	thumb_func_start sub_80301BC
sub_80301BC:
	mov r2, r10
	ldr r2, [r2,#oToolkit_CameraPtr]
	mov r0, #1
	strb r0, [r2,#3]
	mov r1, r10
	ldr r1, [r1,#oToolkit_GameStatePtr]
	ldr r1, [r1,#oGameState_OverworldPlayerObjectPtr]
	add r1, #0x1c
	str r1, [r2,#0x14]
	mov pc, lr
	thumb_func_end sub_80301BC

	thumb_func_start GetCameraXYZ
GetCameraXYZ:
	mov r3, r10
	ldr r3, [r3,#oToolkit_CameraPtr]
	ldr r0, [r3,#oCamera_X]
	ldr r1, [r3,#oCamera_Y]
	ldr r2, [r3,#oCamera_Z]
	mov pc, lr
	thumb_func_end GetCameraXYZ

// symdb: Writes the (x, y, z) world-space camera position into the camera object referenced by the active toolkit.
// symdb: void setCameraXYZ(s32 x, s32 y, s32 z, void *toolkit /* r10 */); returns the camera pointer in
// symdb: r3; clobbers r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetCameraXYZ.yaml
	thumb_func_start SetCameraXYZ
SetCameraXYZ:
	mov r3, r10
	ldr r3, [r3,#oToolkit_CameraPtr]
	str r0, [r3,#0x30]
	str r1, [r3,#0x34]
	str r2, [r3,#0x38]
	mov pc, lr
	thumb_func_end SetCameraXYZ

// symdb: Camera shake: draws from the secondary RNG (two calls), a cosmetic advance that still shifts the next folder shuffle.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/camera_doShakeEffect_80301e8.yaml
	thumb_local_start
camera_doShakeEffect_80301e8:
	push {lr}
	bl sub_80269D0
	tst r0, r0
	bne loc_8030200
	bl IsCurSubsystemInUse // () -> (bool, !zf)
	beq loc_8030200
	bl battle_isTimeStopPauseOrBattleFlags0x20_800a0a4
	tst r0, r0
	beq loc_8030214
loc_8030200:
	ldrh r0, [r5,#oCamera_Unk_0c]
loc_8030202:
	cmp r0, #0
	beq loc_8030214
	ldrh r6, [r5,#oCamera_Unk_0e]
	lsl r6, r6, #3
	ldr r7, off_8030280 // =byte_8030284
	add r7, r7, r6
	sub r1, r0, #1
	strh r1, [r5,#oCamera_Unk_0c]
	b loc_8030226
loc_8030214:
	ldrh r0, [r5,#oCamera_Unk_10]
	cmp r0, #0
	beq loc_8030266
	ldrh r6, [r5,#oCamera_Unk_12]
	lsl r6, r6, #3
	ldr r7, off_8030280 // =byte_8030284
	add r7, r7, r6
	sub r1, r0, #1
	strh r1, [r5,#oCamera_Unk_10]
loc_8030226:
	bl GetRNGSecondary // () -> void
	ldr r2, [r7]
	and r0, r2
	lsl r0, r0, #0x10
	ldr r2, [r7,#4]
	sub r0, r0, r2
	ldr r2, [r5,#oCamera_X]
	add r2, r2, r0
	str r2, [r5,#oCamera_nextX_3c]
	mov r4, #0
	str r4, [r5,#oCamera_Unk_48]
	ldr r4, off_803027C // =eCamera+76 
	ldrb r4, [r4]
	tst r4, r4
	beq loc_803024C
	neg r0, r0
	lsl r0, r0, #1
	str r0, [r5,#oCamera_Unk_48]
loc_803024C:
	bl GetRNGSecondary // () -> void
	ldr r2, [r7]
	and r0, r2
	lsl r0, r0, #0x10
	ldr r2, [r7,#4]
	sub r0, r0, r2
	ldr r2, [r5,#oCamera_Y]
	add r2, r2, r0
	str r2, [r5,#oCamera_nextY_40]
	ldr r2, [r5,#oCamera_Z]
	str r2, [r5,#oCamera_nextZ_44]
	pop {pc}
loc_8030266:
	mov r2, #0
	strh r2, [r5,#oCamera_Unk_0e]
	ldr r2, [r5,#oCamera_X]
	str r2, [r5,#oCamera_nextX_3c]
	ldr r2, [r5,#oCamera_Y]
	str r2, [r5,#oCamera_nextY_40]
	ldr r2, [r5,#oCamera_Z]
	str r2, [r5,#oCamera_nextZ_44]
	mov r2, #0
	str r2, [r5,#oCamera_Unk_48]
	pop {pc}
	.balign 4, 0
off_803027C:
	.word eCamera+0x4C // eCamera.unk_4C
off_8030280:
	.word byte_8030284
byte_8030284:
	.word 0x1, 0x10000
	.word 0x3, 0x20000
	.word 0x7, 0x40000
	.word 0xf, 0x80000

	.word 0x21002000 // ???
	thumb_func_end camera_doShakeEffect_80301e8

// symdb: Triggers a camera shake effect by writing magnitude and duration into the camera struct.
// symdb: u32 camera_initShakeEffect_80302a8(u16 magnitude, u16 duration); // r2 = camera ptr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_initShakeEffect_80302a8.yaml
	thumb_func_start camera_initShakeEffect_80302a8
camera_initShakeEffect_80302a8:
	mov r2, r10
	ldr r2, [r2,#oToolkit_CameraPtr]
	strh r0, [r2,#oCamera_Unk_0e]
	strh r1, [r2,#oCamera_Unk_0c]
	mov pc, lr
	.word 0x21002000
	thumb_func_end camera_initShakeEffect_80302a8

	thumb_func_start sub_80302B6
sub_80302B6:
	mov r2, r10
	ldr r2, [r2,#oToolkit_CameraPtr]
	strh r0, [r2,#oCamera_Unk_12]
	strh r1, [r2,#oCamera_Unk_10]
	mov pc, lr
	thumb_func_end sub_80302B6

	thumb_func_start sub_80302C0
sub_80302C0:
	mov r2, r10
	ldr r2, [r2,#oToolkit_CameraPtr]
	ldrh r3, [r2,#0xe]
	cmp r0, r3
	blt locret_80302CE
	strh r0, [r2,#0xe]
	strh r1, [r2,#0xc]
locret_80302CE:
	mov pc, lr
	thumb_func_end sub_80302C0

	thumb_local_start
sub_80302D0:
	push {lr}
	ldr r0, off_80302E0 // =off_80302E4
	ldrb r1, [r5,#oCamera_Unk_02]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {pc}
	.byte 0, 0
off_80302E0:
	.word off_80302E4
off_80302E4:
	.word camera_CopyScrollToRenderLayers_80302F8+1
	.word renderInfo_SnapScrollToCamera_8030316+1
	.word render_ClearScrollOffsets_8030336+1
	.word sub_803035E+1
	.word nullsub_60+1
	thumb_func_end sub_80302D0

// symdb: Copies the camera's current X/Y position (masked to 8 bits) into the scroll fields of all three render layers each frame.
// symdb: void sub_80302F8(void /* r10 = toolkit */) // sets r1 = camX, r2 = camY, r3 = renderInfo, r4 =
// symdb: 0xFF, r5 = camera, r7 = toolkit; NZ from "and r2, r4"
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_CopyScrollToRenderLayers_80302F8.yaml
	thumb_local_start
camera_CopyScrollToRenderLayers_80302F8:
	mov r7, r10
	ldr r5, [r7,#oToolkit_CameraPtr]
	ldrh r1, [r5,#oCamera_Unk_04]
	ldrh r2, [r5,#oCamera_Unk_06]
	ldr r3, [r7,#oToolkit_RenderInfoPtr]
	mov r4, #0xff
	and r1, r4
	strh r1, [r3,#oRenderInfo_Unk_10]
	strh r1, [r3,#oRenderInfo_Unk_14]
	strh r1, [r3,#oRenderInfo_Unk_18]
	and r2, r4
	strh r2, [r3,#oRenderInfo_Unk_12]
	strh r2, [r3,#oRenderInfo_Unk_16]
	strh r2, [r3,#oRenderInfo_Unk_1a]
	mov pc, lr
	thumb_func_end camera_CopyScrollToRenderLayers_80302F8

// symdb: Copies the camera position into the render-info scroll offsets (masked to 8 bits) and zeroes two related offsets.
// symdb: void renderInfo_SnapScrollToCamera(Toolkit* toolkit /* r10 */); returns r1=0, r2=camY,
// symdb: r3=renderInfo, r4=0xFF, r5=camera, r7=toolkit; NZ flags set from 0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/renderInfo_SnapScrollToCamera_8030316.yaml
	thumb_local_start
renderInfo_SnapScrollToCamera_8030316:
	mov r7, r10
	ldr r5, [r7,#oToolkit_CameraPtr]
	ldrh r1, [r5,#oCamera_Unk_04]
	ldrh r2, [r5,#oCamera_Unk_06]
	ldr r3, [r7,#oToolkit_RenderInfoPtr]
	mov r4, #0xff
	and r1, r4
	strh r1, [r3,#oRenderInfo_Unk_10]
	strh r1, [r3,#oRenderInfo_Unk_14]
	and r2, r4
	strh r2, [r3,#oRenderInfo_Unk_12]
	strh r2, [r3,#oRenderInfo_Unk_16]
	mov r1, #0
	strh r1, [r3,#oRenderInfo_Unk_18]
	strh r1, [r3,#oRenderInfo_Unk_1a]
	mov pc, lr
	thumb_func_end renderInfo_SnapScrollToCamera_8030316

// symdb: Clears the render info BG scroll offset fields (after briefly writing the masked camera scroll into them, which is then overwritten with zero).
// symdb: void render_ClearScrollOffsets(void); /* in: r10 = toolkit; out: r1 = 0, r2 = camera Y & 0xFF,
// symdb: r3 = renderInfo, r4 = 0xFF, r5 = camera, r7 = toolkit, NZ set from r1 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/render_ClearScrollOffsets_8030336.yaml
	thumb_local_start
render_ClearScrollOffsets_8030336:
	mov r7, r10
	ldr r5, [r7,#oToolkit_CameraPtr]
	ldrh r1, [r5,#oCamera_Unk_04]
	ldrh r2, [r5,#oCamera_Unk_06]
	ldr r3, [r7,#oToolkit_RenderInfoPtr]
	mov r4, #0xff
	and r1, r4
	strh r1, [r3,#oRenderInfo_Unk_10]
	strh r1, [r3,#oRenderInfo_Unk_14]
	strh r1, [r3,#oRenderInfo_Unk_18]
	and r2, r4
	strh r2, [r3,#oRenderInfo_Unk_12]
	strh r2, [r3,#oRenderInfo_Unk_16]
	strh r2, [r3,#oRenderInfo_Unk_1a]
	mov r1, #0
	strh r1, [r3,#oRenderInfo_Unk_10]
	strh r1, [r3,#oRenderInfo_Unk_12]
	strh r1, [r3,#oRenderInfo_Unk_18]
	strh r1, [r3,#oRenderInfo_Unk_1a]
	mov pc, lr
	thumb_func_end render_ClearScrollOffsets_8030336

	thumb_local_start
sub_803035E:
	mov r7, r10
	ldr r5, [r7,#oToolkit_CameraPtr]
	ldrh r1, [r5,#oCamera_Unk_04]
	ldrh r2, [r5,#oCamera_Unk_06]
	ldr r3, [r7,#oToolkit_RenderInfoPtr]
	mov r4, #0xff
	lsl r4, r4, #1
	add r4, #1
	and r1, r4
	strh r1, [r3,#oRenderInfo_Unk_10]
	sub r2, #8
	and r2, r4
	strh r2, [r3,#oRenderInfo_Unk_12]
	mov pc, lr
	thumb_func_end sub_803035E

	thumb_local_start
nullsub_60:
	mov pc, lr
	thumb_func_end nullsub_60

	thumb_func_start initMapTilesState_803037c
// r0 - map group
// r1 - map number
// symdb: Initialize the global map-tiles state (eMapTilesState200be70) with the BG descriptor, palette/tileset pointers, map dimensions, and three per-map callbacks for the current map.
// symdb: void initMapTilesState_803037c(u8 map_group /* r0 */, u8 map_number /* r1 */); preserves r4-r9,
// symdb: r12; clobbers r0-r3, NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/initMapTilesState_803037c.yaml
initMapTilesState_803037c: // (map_group: u8, map_number: u8) -> ()
	push {r4-r7,lr}
	mov r2, r8
	mov r3, r9
	mov r4, r12
	push {r2-r4}

	ldr r5, off_80305E0 // =eMapTilesState200be70

	cmp r0, #INTERNET_MAP_GROUP_START
	bge .isInternetMap

.isRealWorldMap
	ldr r3, off_80303D8 // =off_80329A8 // [*const [MapBGDescriptor]; REAL_WORLD_NUM_GROUPS]
	ldr r4, off_80303DC // =off_8032F6C // [*const [[*const Fn; 3]]; REAL_WORLD_NUM_GROUPS]

	b loc_8030398

.isInternetMap
	ldr r3, off_80303E0 // =off_80329C4 // [Nullable<*const [MapBGDescriptor]>; INTERNET_NUM_GROUPS]
	ldr r4, off_80303E4 // =off_8032F88 // Nullable<[*const [[*const Fn; 3]]>; INTERNET_NUM_GROUPS]

	sub r0, #INTERNET_MAP_GROUP_START

loc_8030398:

  // Index by map_group
	lsl r0, r0, #2
	ldr r3, [r3,r0]

  // Index by map_number
	mov r2, #oMapBGDescriptor_Size
	mul r2, r1
	add r3, r3, r2

	str r3, [r5,#oMapTilesState200be70_MapBGDescriptorPtr]

  // Index by map_group
	ldr r4, [r4,r0]

  // Index by map_number (it is a 3-tuple of callback pointers, 12 bytes)
	mov r2, #0x0c
	mul r2, r1
	add r4, r4, r2

	ldr r2, [r4]
	str r2, [r5,#oMapTilesState200be70_UnkCallback_18]
	ldr r2, [r4,#4]
	str r2, [r5,#oMapTilesState200be70_UnkCallback_1c]
	ldr r2, [r4,#8]
	str r2, [r5,#oMapTilesState200be70_UnkCallback_20]

	ldr r0, [r3,#oMapBGDescriptor_TilemapPtr]
	ldr r1, off_803057C // =eDecompBuffer2013A00
	ldrb r2, [r0,#oMapBGTilemapHeader_Width]
	strb r2, [r5,#oMapTilesState200be70_MapWidth]
	ldrb r2, [r0,#oMapBGTilemapHeader_Height]
	strb r2, [r5,#oMapTilesState200be70_MapHeight] // (byte_200BE71 - 0x200be70)

	ldr r2, [r3,#oMapBGDescriptor_PalettePtr]
	str r2, [r5,#oMapTilesState200be70_PalettePtr] // (dword_200BE80 - 0x200be70)

	ldr r2, [r3,#oMapBGDescriptor_TilesetPtr]
	str r2, [r5,#oMapTilesState200be70_TilesetPtr] // (dword_200BE84 - 0x200be70)

	str r1, [r5,#oMapTilesState200be70_Unk_0c] // (dword_200BE7C - 0x200be70)

	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
	.balign 4, 0
off_80303D8:
	.word off_80329A8 // [*const [MapBGDescriptor]; REAL_WORLD_NUM_GROUPS]
off_80303DC:
	.word off_8032F6C // [*const [[*const Fn; 3]]; REAL_WORLD_NUM_GROUPS]
off_80303E0:
	.word off_80329C4 // [Nullable<*const [MapBGDescriptor]>; INTERNET_NUM_GROUPS]
off_80303E4:
	.word off_8032F88 // Nullable<[*const [[*const Fn; 3]]>; INTERNET_NUM_GROUPS]
	thumb_func_end initMapTilesState_803037c

// symdb: Resets the map tile grid dimensions to the default 32x32.
// symdb: void sub_80303E8(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/mapTiles_ResetDimensionsToDefault_80303E8.yaml
	thumb_func_start mapTiles_ResetDimensionsToDefault_80303E8
mapTiles_ResetDimensionsToDefault_80303E8:
	ldr r1, off_80305E0 // =eMapTilesState200be70
	mov r0, #0x20 
	strb r0, [r1,#oMapTilesState200be70_MapWidth]
	strb r0, [r1,#oMapTilesState200be70_MapHeight] // (byte_200BE71 - 0x200be70)
	mov pc, lr
	thumb_func_end mapTiles_ResetDimensionsToDefault_80303E8

	thumb_func_start sub_80303F2
sub_80303F2:
	ldr r1, off_80305E0 // =eMapTilesState200be70
	mov r0, #0x40 
	strb r0, [r1,#oMapTilesState200be70_MapWidth]
	strb r0, [r1,#oMapTilesState200be70_MapHeight] // (byte_200BE71 - 0x200be70)
	mov pc, lr
	thumb_func_end sub_80303F2

	thumb_func_start sub_80303FC
sub_80303FC:
	push {r4-r7,lr}
	mov r4, r8
	mov r5, r9
	push {r4,r5}
	mov r5, r0
	mov r1, #0
	ldr r4, [r5]
	sub r1, r1, r4
	mov r6, #0
	ldr r4, [r5,#4]
	sub r6, r6, r4
	mov r7, r6
	mov r8, r1
	add r1, r1, r6
	asr r1, r1, #0x10
	neg r1, r1
	mov r6, r7
	mov r2, r8
	sub r6, r6, r2
	asr r6, r6, #1
	mov r4, #0
	sub r6, r6, r4
	ldr r2, [r5,#8]
	add r6, r6, r2
	asr r6, r6, #0x10
	neg r6, r6
	ldr r5, off_80305E0 // =eMapTilesState200be70
	asr r1, r1, #3
	asr r6, r6, #3
	ldrb r2, [r5,#oMapTilesState200be70_MapWidth]
	lsr r2, r2, #1
	ldrb r3, [r5,#oMapTilesState200be70_MapHeight] // (byte_200BE71 - 0x200be70)
	lsr r3, r3, #1
	add r1, r1, r2
	add r6, r6, r3
	cmp r1, #0
	bge loc_8030448
	b loc_8030468
loc_8030448:
	ldrb r2, [r5,#oMapTilesState200be70_MapWidth]
	cmp r1, r2
	blt loc_8030450
	b loc_8030468
loc_8030450:
	cmp r6, #0
	bge loc_8030456
	b loc_8030468
loc_8030456:
	ldrb r3, [r5,#oMapTilesState200be70_MapHeight] // (byte_200BE71 - 0x200be70)
	cmp r6, r3
	blt loc_803045E
	b loc_8030468
loc_803045E:
	pop {r4,r5}
	mov r8, r4
	mov r9, r5
	mov r0, #0
	pop {r4-r7,pc}
loc_8030468:
	pop {r4,r5}
	mov r8, r4
	mov r9, r5
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_80303FC

// symdb: Decompresses the current overworld map's BG tilesets and tilemap, installs them in VRAM, and dispatches the map state's post-load callback.
// symdb: void loadMapTiles_8030472(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/decompAndCopyMapTiles_8030472.yaml
	thumb_func_start decompAndCopyMapTiles_8030472
decompAndCopyMapTiles_8030472: // () -> ()
	push {r4-r7,lr}
	mov r1, r8
	mov r2, r9
	mov r3, r12
	push {r1-r3}

	ldr r5, off_80305E0 // =eMapTilesState200be70
	ldr r0, [r5,#oMapTilesState200be70_PalettePtr] // (dword_200BE80 - 0x200be70)
	mov r2, #0xd
	lsl r2, r2, #5 // r2 = 0x1a0
	add r0, #4
	ldr r1, off_80304E0 // =palette_3001960 
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	// Load two tilesets into VRAM: one for BG1 and one for BG2.
	mov r0, #0
	ldr r7, [r5,#oMapTilesState200be70_TilesetPtr] // (dword_200BE84 - 0x200be70)
	mov r6, r7
.loadOneTileset
	push {r0,r6}
	ldr r0, [r7,#oMapBGTilesetHeader_CompressedDataOffset]
	// src
	add r0, r0, r6
	// dest
	ldr r1, off_803057C // =eDecompBuffer2013A00
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()
	
	ldr r0, off_803057C // =eDecompBuffer2013A00
	ldr r1, [r7,#oMapBGTilesetHeader_VRAMOffset]
	ldr r2, dword_80304E4 // =0x6000000
	add r1, r1, r2
	ldr r2, [r7,#oMapBGTilesetHeader_WordCount]
	lsl r2, r2, #2
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	add r7, #oMapBGTilesetHeader_Size
	pop {r0,r6}
	add r0, #1
	cmp r0, #2
	blt .loadOneTileset

	ldr r3, [r5,#oMapTilesState200be70_MapBGDescriptorPtr]
	ldr r0, [r3,#oMapBGDescriptor_TilemapPtr]
	ldr r1, off_803057C // =eDecompBuffer2013A00
	mov r2, #oMapBGTilemapHeader_Size
	push {r0,r1}
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	pop {r0,r1}
	// src
	add r0, #oMapBGTilemapHeader_Size
	// dest
	add r1, #oMapBGTilemapHeader_Size
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()
	ldr r0, [r5,#oMapTilesState200be70_UnkCallback_1c]
	mov lr, pc
	bx r0
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
	.balign 4, 0
off_80304E0:
	.word palette_3001960
dword_80304E4:
	.word 0x6000000
	thumb_func_end decompAndCopyMapTiles_8030472

	thumb_func_start LoadBGAnimData
LoadBGAnimData: // (bg_anim_data: BGAnimData) -> ()
	push {r4-r7,lr}
	mov r5, r0
	ldr r0, [r5,#oBGAnimData_PaletteSrc]
	tst r0, r0
	beq .noPalette
	add r0, #4
	ldr r1, [r5,#oBGAnimData_PaletteDest]
	ldr r2, [r5,#oBGAnimData_PaletteSize]
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
.noPalette
	ldr r7, [r5,#oBGAnimData_GFXSrc]
	tst r7, r7
	beq .noGFX

	// read offset to gfx
	ldr r0, [r7,#4]
	// src
	add r0, r0, r7
	// dest
	ldr r1, =eDecompressionBuf2034A00 
	// decompress gfx to buffer
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()

	ldr r0, =eDecompressionBuf2034A00 
	ldr r1, [r5,#oBGAnimData_GFXDest]
	// read decompressed gfx size
	ldr r2, [r7]
	lsl r2, r2, #2
	// copy gfx to vram
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	// read tilemap source
	ldr r0, [r5,#oBGAnimData_TilemapSrc]
	// dest
	ldr r1, =eDecompressionBuf2034A00 
	// add offset to compressed tilemap
	add r0, #0xc
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()

	ldr r0, =eDecompressionBuf2034A00 
	ldr r1, [r5,#oBGAnimData_TilemapDestOffset]
	mov r2, r10
	// add tilemap dest offset to base BG tilemap ptr
	ldr r2, [r2,#oToolkit_iBGTileIdBlocks_Ptr]
	add r1, r1, r2
	ldr r3, [r5,#oBGAnimData_TilemapSrc]
	// get tilemap dimensions
	ldrb r2, [r3]
	ldrb r3, [r3,#1]
	// multiply to get total size divided by 2
	mul r2, r3
	lsl r2, r2, #1
	// copy to BG tilemap
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
.noGFX
	pop {r4-r7,pc}
	.balign 4, 0
	.pool
	thumb_func_end LoadBGAnimData

	thumb_func_start sub_8030540
sub_8030540:
	push {r4-r7,lr}
	mov r5, r0
	ldr r0, [r5,#0x10]
	tst r0, r0
	beq loc_8030554
	add r0, #4
	ldr r1, [r5,#0x14]
	ldr r2, [r5,#0x18]
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_8030554:
	ldr r0, [r5,#8]
	// dest
	ldr r1, off_8030578 // =eDecompressionBuf2034A00 
	// src
	add r0, #0xc
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()
	ldr r0, off_8030578 // =eDecompressionBuf2034A00 
	ldr r1, [r5,#0xc]
	mov r2, r10
	ldr r2, [r2,#oToolkit_iBGTileIdBlocks_Ptr]
	add r1, r1, r2
	ldr r3, [r5,#8]
	ldrb r2, [r3]
	ldrb r3, [r3,#1]
	mul r2, r3
	lsl r2, r2, #1
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_8030578:
	.word eDecompressionBuf2034A00
off_803057C:
	.word eDecompBuffer2013A00
	thumb_func_end sub_8030540

// symdb: Each overworld frame, scroll the BG tile map's 32x32 window to the camera: draw the columns, then rows, that came into view.
// symdb: (r10 = toolkit) -> u16 stores into the BG tile-id blocks through the map's callbacks; restores
// symdb: r4-r9, r12; r1/r2/r3 = the r8/r9/r12 it was given; c, v as its last compare (or the redraw
// symdb: callback's)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/scrollBGTileMapToCamera_8030580.yaml
	thumb_func_start scrollBGTileMapToCamera_8030580
scrollBGTileMapToCamera_8030580:
	push {r4-r7,lr}
	mov r1, r8
	mov r2, r9
	mov r3, r12
	push {r1-r3}
	mov r3, r10
	ldr r3, [r3,#oToolkit_CameraPtr]
	ldr r5, off_80305E0 // =eMapTilesState200be70
	mov r4, #4
	ldrsh r0, [r3,r4]
	mov r4, #6
	ldrsh r1, [r3,r4]
	asr r0, r0, #3
	asr r1, r1, #3
	mov r4, #0x4 // (word_200BE74 - 0x200be70)
	ldrsh r2, [r5,r4]
	cmp r0, r2
	beq loc_80305BC
	bgt loc_80305B2
	sub r2, r2, r0
	push {r0,r1}
	bl drawBGTileMapLeftColumns_803066E
	pop {r0,r1}
	b loc_80305BC
loc_80305B2:
	sub r2, r0, r2
	push {r0,r1}
	bl drawBGTileMapRightColumns_80306C8
	pop {r0,r1}
loc_80305BC:
	mov r4, #0x6 // (word_200BE76 - 0x200be70)
	ldrsh r2, [r5,r4]
	cmp r1, r2
	beq loc_80305D4
	bgt loc_80305CE
	sub r2, r2, r1
	bl drawBGTileMapTopRows_8030722
	b loc_80305D4
loc_80305CE:
	sub r2, r1, r2
	bl drawBGTileMapBottomRows_803077C
loc_80305D4:
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
	.balign 4, 0
off_80305E0:
	.word eMapTilesState200be70
	thumb_func_end scrollBGTileMapToCamera_8030580

// symdb: Read a map cell's tile ids from the decompressed tilemap's two layers (cell (0, 0) when off the map).
// symdb: (r0 = map x, r1 = map y, r5 = eMapTilesState200be70) -> r0 = id in the layer at +4, r1 = id in
// symdb: the layer at +8; r2 = r0, r3 = tilemap, r4 = 0, r6 = y * row bytes, r7 = row bytes; flags from
// symdb: cmp r4,#0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/getMapCellTileIds_80305E4.yaml
	thumb_local_start
getMapCellTileIds_80305E4:
	cmp r0, #0
	bge loc_80305EA
	b loc_8030622
loc_80305EA:
	ldrb r6, [r5]
	cmp r0, r6
	blt loc_80305F2
	b loc_8030622
loc_80305F2:
	cmp r1, #0
	bge loc_80305F8
	b loc_8030622
loc_80305F8:
	ldrb r6, [r5,#1]
	cmp r1, r6
	blt loc_8030600
	b loc_8030622
loc_8030600:
	ldr r3, [r5,#0xc]
	mov r4, #8
loc_8030604:
	ldrb r7, [r5]
	lsl r7, r7, #1
loc_8030608:
	ldr r2, [r3,r4]
	add r2, r2, r3
	lsl r6, r0, #1
	add r2, r2, r6
	mov r6, r1
	mul r6, r7
	ldrh r2, [r2,r6]
	push {r2}
	sub r4, #4
	cmp r4, #0
	bgt loc_8030608
	pop {r0,r1}
	mov pc, lr
loc_8030622:
	mov r0, #0
	mov r1, #0
	b loc_8030600
	thumb_func_end getMapCellTileIds_80305E4

// symdb: Write two tile ids into BG tile-id blocks 1 and 2 at the same (column, row).
// symdb: (r0 = tile id for block 1, r1 = tile id for block 2, r3 = column, r4 = row, r10 = toolkit) ->
// symdb: u16 stores at [toolkit+oToolkit_iBGTileIdBlocks_Ptr] + block*0x800 + row*0x40 + column*2; r0 =
// symdb: r1, r2 = 3, r6 = row<<6, r7 = last block entry base; flags from cmp r2,#2
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/setBGTileIdsBlocks1And2_8030628.yaml
	thumb_func_start setBGTileIdsBlocks1And2_8030628
setBGTileIdsBlocks1And2_8030628:
	push {r0,r1}
	mov r2, #1

  // Needs no more than two iterations to be valid due to the pop
loop_803062C:
	pop {r0}
	mov r7, r10
	ldr r7, [r7,#oToolkit_iBGTileIdBlocks_Ptr]

	lsl r6, r2, #0xb
	add r7, r7, r6

	lsl r6, r3, #1
	add r7, r7, r6
	lsl r6, r4, #6
	strh r0, [r7,r6]
	add r2, #1

  // Iterates for r2: 1 and 2
	cmp r2, #2
	ble loop_803062C

	mov pc, lr
	thumb_func_end setBGTileIdsBlocks1And2_8030628

	thumb_local_start
sub_8030646:
	mov r2, #2
	mov r7, r10
	ldr r7, [r7,#oToolkit_iBGTileIdBlocks_Ptr]
	lsl r6, r2, #0xb
	add r7, r7, r6
	lsl r6, r3, #1
	add r7, r7, r6
	lsl r6, r4, #6
	strh r1, [r7,r6]
	mov pc, lr
	thumb_func_end sub_8030646

	thumb_local_start
sub_803065A:
	mov r2, #1
	mov r7, r10
	ldr r7, [r7,#oToolkit_iBGTileIdBlocks_Ptr]
	lsl r6, r2, #0xb
	add r7, r7, r6
	lsl r6, r3, #1
	add r7, r7, r6
	lsl r6, r4, #6
	strh r1, [r7,r6]
	mov pc, lr
	thumb_func_end sub_803065A

// symdb: Draw the left-edge columns of the BG tile map's window that scrolled into view (camera moved left).
// symdb: (r0 = camera tile x, r1 = camera tile y, r2 = tiles moved, r5 = eMapTilesState200be70) -> window
// symdb: entries through the put-tile-ids callback, or a full redraw when it moved 5 or more
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/drawBGTileMapLeftColumns_803066E.yaml
	thumb_local_start
drawBGTileMapLeftColumns_803066E:
	push {lr}
	strh r0, [r5,#4]
	cmp r2, #5
	blt loc_803067E
	ldr r3, [r5,#0x20]
	mov lr, pc
	bx r3
	b locret_80306C6
loc_803067E:
	push {r1}
	mov r7, #0
loc_8030682:
	push {r2,r7}
	mov r8, r0
	mov r9, r1
	sub r0, #0xf
	sub r1, #0xa
	ldrb r6, [r5]
	lsr r6, r6, #1
	ldrb r7, [r5,#1]
	lsr r7, r7, #1
	add r0, r0, r6
	add r1, r1, r7
	bl getMapCellTileIds_80305E4
	mov r4, r9
	mov r3, r8
	sub r3, #0x20 
	mov r6, #0x1f
	and r3, r6
	and r4, r6
	ldr r6, [r5,#0x18]
	mov lr, pc
	bx r6
	pop {r2,r7}
	mov r0, r8
	mov r1, r9
	add r1, #1
	add r7, #1
	cmp r7, #0x20 
	blt loc_8030682
	pop {r1}
	add r0, #1
	sub r2, #1
	cmp r2, #0
	bgt loc_803067E
locret_80306C6:
	pop {pc}
	thumb_func_end drawBGTileMapLeftColumns_803066E

// symdb: Draw the right-edge columns of the BG tile map's window that scrolled into view (camera moved right).
// symdb: (r0 = camera tile x, r1 = camera tile y, r2 = tiles moved, r5 = eMapTilesState200be70) -> window
// symdb: entries through the put-tile-ids callback, or a full redraw when it moved 5 or more
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/drawBGTileMapRightColumns_80306C8.yaml
	thumb_local_start
drawBGTileMapRightColumns_80306C8:
	push {lr}
	strh r0, [r5,#4]
	cmp r2, #5
	blt loc_80306D8
	ldr r3, [r5,#0x20]
	mov lr, pc
	bx r3
	b locret_8030720
loc_80306D8:
	push {r1}
	mov r7, #0
loc_80306DC:
	push {r2,r7}
	mov r8, r0
	mov r9, r1
	add r0, #0xf
	sub r1, #0xa
	ldrb r6, [r5]
	lsr r6, r6, #1
	ldrb r7, [r5,#1]
	lsr r7, r7, #1
	add r0, r0, r6
	add r1, r1, r7
	bl getMapCellTileIds_80305E4
	mov r4, r9
	mov r3, r8
	add r3, #0x1e
	mov r6, #0x1f
	and r3, r6
	and r4, r6
	ldr r6, [r5,#0x18]
	mov lr, pc
	bx r6
	pop {r2,r7}
	mov r0, r8
	mov r1, r9
	add r1, #1
	add r7, #1
	cmp r7, #0x20 
	blt loc_80306DC
	pop {r1}
	sub r0, #1
	sub r2, #1
	cmp r2, #0
	bgt loc_80306D8
locret_8030720:
	pop {pc}
	thumb_func_end drawBGTileMapRightColumns_80306C8

// symdb: Draw the top-edge rows of the BG tile map's window that scrolled into view (camera moved up).
// symdb: (r0 = camera tile x, r1 = camera tile y, r2 = tiles moved, r5 = eMapTilesState200be70) -> window
// symdb: entries through the put-tile-ids callback, or a full redraw when it moved 5 or more
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/drawBGTileMapTopRows_8030722.yaml
	thumb_local_start
drawBGTileMapTopRows_8030722:
	push {lr}
	strh r1, [r5,#6]
	cmp r2, #5
	blt loc_8030732
	ldr r3, [r5,#0x20]
	mov lr, pc
	bx r3
	b locret_803077A
loc_8030732:
	push {r0}
	mov r7, #0
loc_8030736:
	push {r2,r7}
	mov r8, r0
	mov r9, r1
	sub r0, #0xf
	sub r1, #0xa
	ldrb r6, [r5]
	lsr r6, r6, #1
	ldrb r7, [r5,#1]
	lsr r7, r7, #1
	add r0, r0, r6
	add r1, r1, r7
	bl getMapCellTileIds_80305E4
	mov r4, r9
	mov r3, r8
	sub r4, #0x20 
	mov r6, #0x1f
	and r3, r6
	and r4, r6
	ldr r6, [r5,#0x18]
	mov lr, pc
	bx r6
	pop {r2,r7}
	mov r0, r8
	mov r1, r9
	add r0, #1
	add r7, #1
	cmp r7, #0x20 
	blt loc_8030736
	pop {r0}
	add r1, #1
	sub r2, #1
	cmp r2, #0
	bgt loc_8030732
locret_803077A:
	pop {pc}
	thumb_func_end drawBGTileMapTopRows_8030722

// symdb: Draw the bottom-edge rows of the BG tile map's window that scrolled into view (camera moved down).
// symdb: (r0 = camera tile x, r1 = camera tile y, r2 = tiles moved, r5 = eMapTilesState200be70) -> window
// symdb: entries through the put-tile-ids callback, or a full redraw when it moved 5 or more
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/drawBGTileMapBottomRows_803077C.yaml
	thumb_local_start
drawBGTileMapBottomRows_803077C:
	push {lr}
	strh r1, [r5,#6]
	cmp r2, #5
	blt loc_803078C
	ldr r3, [r5,#0x20]
	mov lr, pc
	bx r3
	b locret_80307D4
loc_803078C:
	push {r0}
	mov r7, #0
loc_8030790:
	push {r2,r7}
	mov r8, r0
	mov r9, r1
	sub r0, #0xf
	add r1, #0xa
	ldrb r6, [r5]
	lsr r6, r6, #1
	ldrb r7, [r5,#1]
	lsr r7, r7, #1
	add r0, r0, r6
	add r1, r1, r7
	bl getMapCellTileIds_80305E4
	mov r4, r9
	mov r3, r8
	add r4, #0x14
	mov r6, #0x1f
	and r3, r6
	and r4, r6
	ldr r6, [r5,#0x18]
	mov lr, pc
	bx r6
	pop {r2,r7}
	mov r0, r8
	mov r1, r9
	add r0, #1
	add r7, #1
	cmp r7, #0x20 
	blt loc_8030790
	pop {r0}
	sub r1, #1
	sub r2, #1
	cmp r2, #0
	bgt loc_803078C
locret_80307D4:
	pop {pc}
	.balign 4, 0x00
	thumb_func_end drawBGTileMapBottomRows_803077C

	thumb_func_start sub_80307D8
sub_80307D8:
	push {r4-r7,lr}
	mov r4, r8
	mov r5, r9
	mov r6, r12
	push {r4-r6}
	mov r3, r10
	ldr r3, [r3,#oToolkit_CameraPtr]
	mov r4, #4
	ldrsh r0, [r3,r4]
	mov r4, #6
	ldrsh r1, [r3,r4]
	asr r0, r0, #3
	asr r1, r1, #3
	ldr r5, off_8030804 // =eMapTilesState200be70
	bl redrawBGTileMapWholeWindow_803086C
	pop {r4-r6}
	mov r8, r4
	mov r9, r5
	mov r12, r6
	pop {r4-r7,pc}
	.balign 4, 0
off_8030804:
	.word eMapTilesState200be70
	thumb_func_end sub_80307D8

// symdb: Move the 32x32 BG tile-id window to the camera's tile and redraw every cell through the map's tile-id callbacks.
// symdb: static WindowCell redraw_window(u32 camera, u32 tiles) -> the loop's final carried state (tiles,
// symdb: cell x, cell y); adapter: in r5 = eMapTilesState200be70, r10 = toolkit (the adapter reads the
// symdb: camera pointer from it); out r0 = r1 = 32, r3 = window x, r4 = window y + 32, Z set (cmp 32,
// symdb: 32); r2/r5/r6/r7 and lr keep the last callback's leftovers, r10-r12 untouched
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/redrawBGTileIdsWindowCellByCell_8030808.yaml
	thumb_func_start redrawBGTileIdsWindowCellByCell_8030808
redrawBGTileIdsWindowCellByCell_8030808:
	push {lr}
	mov r7, r10
	ldr r0, [r7,#oToolkit_CameraPtr]
	mov r1, #4
	ldrsh r3, [r0,r1]
	mov r1, #6
	ldrsh r4, [r0,r1]
	asr r3, r3, #3
	asr r4, r4, #3
	strh r3, [r5,#4]
	strh r4, [r5,#6]
	mov r1, #0
loc_8030820:
	push {r3}
	mov r0, #0
loc_8030824:
	push {r0,r1}
	mov r0, r3
	mov r1, r4
	sub r0, #0xf
	sub r1, #0xa
	ldrb r6, [r5]
	lsr r6, r6, #1
	ldrb r7, [r5,#1]
	lsr r7, r7, #1
	add r0, r0, r6
	add r1, r1, r7
	mov r8, r3
	mov r9, r4
loc_803083E:
	bl getMapCellTileIds_80305E4
	mov r3, r8
	mov r4, r9
	mov r6, #0x1f
	and r3, r6
	and r4, r6
	ldr r6, [r5,#0x18]
	mov lr, pc
	bx r6
	mov r3, r8
	mov r4, r9
	add r3, #1
	pop {r0,r1}
	add r0, #1
	cmp r0, #0x20 
	blt loc_8030824
	pop {r3}
	add r4, #1
	add r1, #1
	cmp r1, #0x20 
	blt loc_8030820
	pop {pc}
	thumb_func_end redrawBGTileIdsWindowCellByCell_8030808

// symdb: The maps' whole-window redraw callback (+0x20): redraw both tilemap layers straight into the 32x32 window at the given camera tile.
// symdb: static void redraw_from_tilemap(u32 tiles, u32 window_x, u32 window_y); adapter: in r0/r1 =
// symdb: camera tile, r5 = eMapTilesState200be70; out r8/r9 = the window origin, r4-r7 restored, Z set
// symdb: (cmp 32, 32); r0-r3 and lr keep the last row call's leftovers
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/redrawBGTileMapWholeWindow_803086C.yaml
	thumb_func_start redrawBGTileMapWholeWindow_803086C
redrawBGTileMapWholeWindow_803086C:
	push {r4-r7,lr}
	mov r8, r0
	mov r9, r1
	ldr r4, [r5,#0xc]
	ldr r0, [r4,#4]
	add r0, r0, r4
	mov r1, #1
	ldrb r2, [r5]
	ldrb r3, [r5,#1]
	bl copyTilemapLayerRowsToWindow_8030892
	ldr r0, [r4,#8]
	add r0, r0, r4
	mov r1, #2
	ldrb r2, [r5]
	ldrb r3, [r5,#1]
	bl copyTilemapLayerRowsToWindow_8030892
	pop {r4-r7,pc}
	thumb_func_end redrawBGTileMapWholeWindow_803086C

// symdb: Copy one tilemap layer's 32 rows into the window, filling the rows that fall off the map with tile 0.
// symdb: static void copy_layer_rows(u32 layer_data, u32 layer, u32 map_width, u32 map_height, u32
// symdb: window_x, u32 window_y); adapter: in r0/r1 = layer data / layer, r2/r3 = map width / height,
// symdb: r8/r9 = window origin; out Z set (cmp 32, 32), r4-r7 restored; r0-r3 and lr keep the last row
// symdb: call's leftovers
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyTilemapLayerRowsToWindow_8030892.yaml
	thumb_local_start
copyTilemapLayerRowsToWindow_8030892:
	push {r4-r7,lr}
	sub sp, sp, #8
	str r2, [sp]
	str r3, [sp,#4]
	mov r7, r0
	mov r6, r1
	mov r5, #0
loc_80308A0:
	mov r0, r8
	mov r1, r9
	add r1, r1, r5
	sub r0, #0xf
	sub r1, #0xa
	ldr r2, [sp]
	lsr r2, r2, #1
	ldr r3, [sp,#4]
	lsr r3, r3, #1
	add r0, r0, r2
	add r1, r1, r3
	blt loc_80308E0
	ldr r2, [sp,#4]
	cmp r1, r2
	bge loc_80308E0
	ldr r2, [sp]
	lsl r2, r2, #1
	lsl r0, r0, #1
	mul r2, r1
	add r3, r0, r2
	mov r0, r8
	mov r1, r9
	add r1, r1, r5
	mov r2, #0x1f
	and r0, r2
	and r1, r2
	mov r2, r6
	add r3, r3, r7
	mov r4, #0x20 
	bl bg_writeTileIdRow_80018E0
	b loc_80308FA
loc_80308E0:
	push {r5}
	mov r0, #0
	mov r1, r9
	add r1, r1, r5
	mov r2, #0x1f
	and r1, r2
	mov r2, r6
	mov r3, #0
	mov r4, #0x20 
	mov r5, #1
	bl call_sub_3005EBA
	pop {r5}
loc_80308FA:
	add r5, #1
	cmp r5, #0x20 
	blt loc_80308A0
	add sp, sp, #8
	pop {r4-r7,pc}
	.balign 4, 0
EnterMap_RealWorldMapGroupJumptable:
	.word ACDCTown_EnterMapGroup+1
	.word CentralTown_EnterMapGroup+1
	.word CyberAcademy_EnterMapGroup+1
	.word SeasideTown_EnterMapGroup+1
	.word GreenTown_EnterMapGroup+1
	.word SkyTown_EnterMapGroup+1
	.word ExpoSite_EnterMapGroup+1
RealWorldMapGroupLoadGFXAnimsJumptable:
	.word ACDCTown_LoadGFXAnims+1
	.word CentralTown_LoadGFXAnims+1
	.word CyberAcademy_LoadGFXAnims+1
	.word SeasideTown_LoadGFXAnims+1
	.word GreenTown_LoadGFXAnims+1
	.word SkyTown_LoadGFXAnims+1
	.word ExpoSite_LoadGFXAnims+1

EnterMap_InternetMapGroupJumptable:
	.word RobotControlComp_EnterMapGroup+1
	.word AquariumComp_EnterMapGroup+1
	.word JudgeTreeComp_EnterMapGroup+1
	.word MrWeatherComp_EnterMapGroup+1
	.word nullsub_61+1
	.word PavilionComp_EnterMapGroup+1
	.word nullsub_61+1
	.word nullsub_61+1
	.word HomePages_EnterMapGroup+1
	.word nullsub_61+1
	.word nullsub_61+1
	.word nullsub_61+1
	.word Comps1_EnterMapGroup+1
	.word Comps2_EnterMapGroup+1
	.word nullsub_61+1
	.word nullsub_61+1
	.word CentralArea_EnterMapGroup+1
	.word SeasideArea_EnterMapGroup+1
	.word GreenArea_EnterMapGroup+1
	.word Underground_EnterMapGroup+1
	.word SkyACDCArea_EnterMapGroup+1
	.word Undernet_EnterMapGroup+1
	.word GraveyardImmortalArea_EnterMapGroup+1
InternetMapGroupLoadGFXAnimsJumptable:
	.word RobotControlComp_LoadGFXAnims+1
	.word AquariumComp_LoadGFXAnims+1
	.word JudgeTreeComp_LoadGFXAnims+1
	.word MrWeatherComp_LoadGFXAnims+1
	.word nullsub_62+1
	.word PavilionComp_LoadGFXAnims+1
	.word nullsub_62+1
	.word nullsub_62+1
	.word HomePages_LoadGFXAnims+1
	.word nullsub_62+1
	.word nullsub_62+1
	.word nullsub_62+1
	.word Comps1_LoadGFXAnims+1
	.word Comps2_LoadGFXAnims+1
	.word nullsub_62+1
	.word nullsub_62+1
	.word CentralArea_LoadGFXAnims+1
	.word SeasideArea_LoadGFXAnims+1
	.word GreenArea_LoadGFXAnims+1
	.word Underground_LoadGFXAnims+1
	.word SkyACDCArea_LoadGFXAnims+1
	.word Undernet_LoadGFXAnims+1
	.word GraveyardImmortalArea_LoadGFXAnims+1
EnterMap_UnkMapGroupJumptable:
	.word nullsub_61+1
UnkMapGroupRangeLoadGFXAnimsJumptable:
	.word nullsub_62+1
	thumb_func_end copyTilemapLayerRowsToWindow_8030892

	thumb_local_start
nullsub_61:
	mov pc, lr
	thumb_func_end nullsub_61

	thumb_local_start
nullsub_62:
	mov pc, lr
	thumb_func_end nullsub_62

// 8030A00
// symdb: Dispatches to the per-map-group EnterMap handler from one of three jumptables (real-world, internet, unknown) based on the map group number in r0.
// symdb: void EnterMap_RunMapGroupAsmFunction_8030A00(u32 group /*r0*/); behaves as a tail call —
// symdb: handler's register outputs (r2, r4-r12) pass through to the caller; r0/r1/r3/lr and NZCV
// symdb: clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/EnterMap_RunMapGroupAsmFunction_8030A00.yaml
	thumb_func_start EnterMap_RunMapGroupAsmFunction_8030A00
EnterMap_RunMapGroupAsmFunction_8030A00:
	push {lr}

	cmp r0, #UNKNOWN_MAP_GROUP_START // 0xf0
	bge .unknownMapGroupRange

	cmp r0, #INTERNET_MAP_GROUP_START
	bge .isInternetMap

	ldr r1, =EnterMap_RealWorldMapGroupJumptable

	b .runMapGroupFunction

.isInternetMap
	ldr r1, =EnterMap_InternetMapGroupJumptable
	sub r0, #INTERNET_MAP_GROUP_START
	b .runMapGroupFunction

.unknownMapGroupRange
	ldr r1, =EnterMap_UnkMapGroupJumptable
	sub r0, #UNKNOWN_MAP_GROUP_START

.runMapGroupFunction
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {pc}
	.balign 4, 0
	.pool
	thumb_func_end EnterMap_RunMapGroupAsmFunction_8030A00

	thumb_func_start LoadGFXAnimsForMapGroup
// r0 map group, r1 map number
// symdb: Dispatches a GFX-anim load handler for a map's group via one of three jumptables (real-world, internet, unknown range), keyed on the map group number.
// symdb: (u8 mapGroup in r0, u8 mapNumber in r1) -> void; clobbers r0-r3, r12, lr and flags; preserves
// symdb: nothing beyond the normal caller-saved set
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/LoadGFXAnimsForMapGroup.yaml
LoadGFXAnimsForMapGroup: // (map_group: u8, map_number: u8) -> ()
	push {lr}
	cmp r0, #UNKNOWN_MAP_GROUP_START
	bge .unknownMapGroupRange
	cmp r0, #INTERNET_MAP_GROUP_START
	bge .isInternetMap
	ldr r2, =RealWorldMapGroupLoadGFXAnimsJumptable
	b .runMapGroupFunction
.isInternetMap
	ldr r2, =InternetMapGroupLoadGFXAnimsJumptable
	sub r0, #INTERNET_MAP_GROUP_START
	b .runMapGroupFunction
.unknownMapGroupRange
	ldr r2, =UnkMapGroupRangeLoadGFXAnimsJumptable
	sub r0, #UNKNOWN_MAP_GROUP_START
.runMapGroupFunction
	lsl r0, r0, #2
	ldr r2, [r2,r0]
	mov lr, pc
	bx r2
	pop {pc}
	.balign 4, 0
	.pool
	thumb_func_end LoadGFXAnimsForMapGroup

// symdb: Switches the overworld's active NPC spawn list — frees all existing overworld NPC objects, stores the new list pointer in the game state, and spawns one NPC per entry until a 0xFF terminator.
// symdb: void npc_freeAllObjectsThenSpawnObjectsFromList(const NPCScript *const *list /* r0 */); returns
// symdb: with r0 = pointer to the terminator entry, r1 = number of objects spawned (early exit: r1 =
// symdb: previous list pointer), r2 = 0xFF; flags from the last compare (list vs. current on early exit,
// symdb: terminator vs. 0xFF otherwise); r4-r6 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/npc_freeAllObjectsThenSpawnObjectsFromList.yaml
	thumb_func_start npc_freeAllObjectsThenSpawnObjectsFromList
npc_freeAllObjectsThenSpawnObjectsFromList: // (ptr: [*const NPCScript]) -> ()
	push {r4-r6,lr}
	mov r4, r10
	ldr r4, [r4,#oToolkit_GameStatePtr]

	ldr r1, [r4,#oGameState_Ptr_20]
	cmp r0, r1
	beq .done

	str r0, [r4,#oGameState_Ptr_20]

	push {r0}
	mov r0, #OVERWORLD_NPC_OBJECT_F
	bl FreeAllObjectsOfSpecifiedTypes
	pop {r0}

	mov r1, #0
.loop

  // Index by nth
	ldr r2, [r0]
	cmp r2, #0xff
	beq .done

	bl npc_spawnObjectThenSetUnk10_TempAnimScriptPtr_8030a8c // (_l: *const [*const NPCScript], which: isize, script: *const NPCScript) -> ()

	add r1, #1
	add r0, #4
	b .loop
.done
	pop {r4-r6,pc}
	thumb_func_end npc_freeAllObjectsThenSpawnObjectsFromList

// symdb: Spawns an overworld NPC object with its initial script forced to 0, then stamps the caller's script selector and animation-script pointer onto the new object.
// symdb: void npc_spawnObjectThenSetUnk10_TempAnimScriptPtr_8030a8c(u32 arg0, u32 whichScript, const
// symdb: NPCScript *animScriptPtr, /* r3, r4 passed through as spawn args */); returns the new object
// symdb: pointer in r5 (NULL on failure); r0-r4 and flags are preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/npc_spawnObjectThenSetUnk10_TempAnimScriptPtr_8030a8c.yaml
	thumb_local_start
npc_spawnObjectThenSetUnk10_TempAnimScriptPtr_8030a8c: // (_l: *const [*const NPCScript], which: isize, script: *const NPCScript) -> ()
	push {lr}

	push {r0-r2}
	mov r0, #0
	// writes garbage to xyz, unk_04 but is overwritten later by the npc script
	bl SpawnOverworldNPCObject
	pop {r0-r2}

	tst r5, r5
	beq .objectSpawnFailed

	strb r1, [r5,#oOverworldNPCObject_WhichNPCScript]

  // This gets set by npc_init_809E590
	str r2, [r5,#oOverworldNPCObject_UnkFlags_60] // this is actually temp storage for the animation script pointer

.objectSpawnFailed
	pop {pc}
	.balign 4, 0x00
	thumb_func_end npc_spawnObjectThenSetUnk10_TempAnimScriptPtr_8030a8c

	thumb_func_start decompressCoordEventData_8030aa4
// coordinate effect 
// symdb: Decompresses a map's LZ77-compressed coordinate-event record into the shared scratch buffer and dispatches its four sections (object table, map-script data, chatbox script, object-55 stream) to their respective loaders when the player enters a real-world or internet map.
// symdb: void decompressCoordEventData_8030aa4(s32 map_group /* r0 */, u32 map_number /* r1 */, u32
// symdb: in_r4, u32 in_r5, u32 in_r6, u32 in_r7, u32 in_r8, u32 in_r9, u32 in_r12) -> (r5, r6, r7, r8,
// symdb: r9, r12 restored to entry values); clobbers NZCV r0-r3, lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/decompressCoordEventData_8030aa4.yaml
decompressCoordEventData_8030aa4: // (map_group: u8, map_number: u8) -> ()
	push {r4-r7,lr}
	mov r2, r8
	mov r3, r9
	mov r4, r12
	push {r2-r4}

	cmp r0, #INTERNET_MAP_GROUP_START
	bge loc_8030AB6

	ldr r3, off_8030B00 // =pt_8033530 // [*const [*const ([u32; 4]?, LZ77Compressed<?>)]; REAL_WORLD_NUM_GROUPS]
	b loc_8030ABA

loc_8030AB6:
	ldr r3, off_8030B04 // =pt_803354C // Nullable<[*const [*const ([u32; 4]?, LZ77Compressed<?>)]>; INTERNET_NUM_GROUPS]
	sub r0, #INTERNET_MAP_GROUP_START

loc_8030ABA:

	lsl r0, r0, #2 // map group
	add r3, r3, r0
	ldr r3, [r3]

	lsl r1, r1, #2 // map number
	add r3, r3, r1
	ldr r0, [r3]

	push {r0}

	add r0, #0x10
	ldr r1, off_8030B08 // =DecompBuf_2027A00 
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()

	pop {r6}

	ldr r7, off_8030B08 // =DecompBuf_2027A00 

	ldr r0, [r6,#0]
	add r0, r0, r7
	bl sub_8030B0C

	ldr r0, [r6,#4]
	add r0, r0, r7
	bl sub_8031600

	ldr r0, [r6,#8]
	add r0, r0, r7
	bl chatbox_loadScriptWordAndResetScroll_803189C

	ldr r0, [r6,#0xc]
	add r0, r0, r7
	bl overworldObject55_ReadStreamEntry_8031A68

	pop {r2-r4}
	mov r8, r2
	mov r9, r3
	mov r12, r4
	pop {r4-r7,pc}
	.balign 4, 0
off_8030B00:
	.word pt_8033530 // [*const [*const ([u32; 4]?, LZ77Compressed<?>)]; REAL_WORLD_NUM_GROUPS]
off_8030B04:
	.word pt_803354C // Nullable<[*const [*const ([u32; 4]?, LZ77Compressed<?>)]>; INTERNET_NUM_GROUPS]
off_8030B08:
	.word DecompBuf_2027A00
	thumb_func_end decompressCoordEventData_8030aa4

	thumb_local_start
sub_8030B0C:
	ldr r5, off_8030E10 // =dword_2011D10 
	ldr r1, [r0]
	strh r1, [r5,#0x4] // (word_2011D14 - 0x2011d10)
	add r0, #4
	str r0, [r5]
	mov r0, #0xfe
	strb r0, [r5,#0x8] // (byte_2011D18 - 0x2011d10)
	strb r0, [r5,#0x9] // (byte_2011D19 - 0x2011d10)
	mov pc, lr
	thumb_func_end sub_8030B0C

// symdb: Binary-search a sorted {u16 id, u16 offset} table for an id and return its first entry.
// symdb: (r1 = id, r5 = table header {u32 base; u16 count at +4}) -> r2 = address of the first entry with
// symdb: that id, or 0; r8 = base, r3 = final upper bound, r7 = last compared id
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/findFirstEntryWithId_8030B1E.yaml
	thumb_local_start
findFirstEntryWithId_8030B1E:
	push {lr}
	ldrh r2, [r5,#oUnk_Ex2011a20_Unk_04]
	cmp r2, #0
	beq .loc_8030B66
	mov r2, #0
	ldrh r3, [r5,#oUnk_Ex2011a20_Unk_04]
	ldr r6, [r5,#oUnk_Ex2011a20_UnkPtr_00]
	mov r8, r6

// this is a binary search
// will document later
// r3 = unk04
.loop
	.align 1, 0
	add r4, r2, r3
	lsr r4, r4, #1
	lsl r7, r4, #2
	mov r6, r8
	add r6, r6, r7
	// read hword from [UnkPtr_00 + ((r2 + r3) & ~1) * 2]
	ldrh r7, [r6]
	cmp r1, r7
	beq .loc_8030B4C
	bgt .loc_8030B44
	// r3 = r4, which is (r2 + r3) / 2 from current iteration
	mov r3, r4
	b .loc_8030B48
.loc_8030B44:
	.align 1, 0
	mov r2, r4
	add r2, #1
.loc_8030B48:
	.align 1, 0
	cmp r2, r3
	blt .loop

.loc_8030B4C:
	.align 1, 0
	cmp r1, r7
	bne .loc_8030B66
	ldr r2, [r5]
.loc_8030B52:
	.align 1, 0
	sub r6, #4
	cmp r6, r2
	blt .loc_8030B60
	ldrh r7, [r6]
	cmp r1, r7
	bne .loc_8030B60
	b .loc_8030B52
.loc_8030B60:
	.align 1, 0
	add r6, #4
	mov r2, r6
	pop {pc}
.loc_8030B66:
	.align 1, 0
	mov r2, #NULL
	pop {pc}
	thumb_func_end findFirstEntryWithId_8030B1E

	thumb_func_start checkCollision_8030b6a
checkCollision_8030b6a:
	push {r4-r7,lr}
	mov r2, r8
	mov r3, r9
	mov r4, r12
	push {r2-r4}
	ldr r5, off_8030E10 // =dword_2011D10 
	ldr r2, off_8030C38 // =dword_200F3D0 
	str r0, [r2]
	mov r4, #0
	mov r12, r4
	strb r4, [r5,#0xb] // (byte_2011D1B - 0x2011d10)
	.balign 4, 0
loc_8030B80: .align 1, 0
	mov r1, r5
	add r1, #0x18
	str r1, [r5,#0x14] // (dword_2011D24 - 0x2011d10)
	mov r1, #0
	strb r1, [r5,#0xa] // (byte_2011D1A - 0x2011d10)
	neg r1, r1
	strh r1, [r5,#0x6] // (word_2011D16 - 0x2011d10)
	bl owObject_lineDraw_8030CAC
	mov r2, #0x18
	add r2, r2, r5
	str r2, [r5,#0x10] // (dword_2011D20 - 0x2011d10)
loc_8030B98: .align 1, 0
	ldr r1, [r5,#0x14] // (dword_2011D24 - 0x2011d10)
	cmp r2, r1
	beq loc_8030C0E
	ldrh r1, [r2]
	bl findFirstEntryWithId_8030B1E
	cmp r2, #0
	bne loc_8030BB0
loc_8030BA8: .align 1, 0
	ldr r2, [r5,#0x10] // (dword_2011D20 - 0x2011d10)
	add r2, #0x10
	str r2, [r5,#0x10] // (dword_2011D20 - 0x2011d10)
	b loc_8030B98
loc_8030BB0: .align 1, 0
	ldrh r4, [r2]
	cmp r1, r4
	bne loc_8030BA8
	ldrh r7, [r2,#2]
	ldr r4, [r5]
	add r7, r7, r4
	mov r4, #0
	ldrsb r4, [r7,r4]
	mov r6, #0xa
	ldrsh r3, [r0,r6]
	cmp r3, r4
	blt loc_8030C0A
	ldrb r6, [r7,#2]
	add r4, r4, r6
	cmp r3, r4
	bgt loc_8030C0A
	ldrb r6, [r7,#1]
	strb r6, [r5,#0xc] // (byte_2011D1C - 0x2011d10)
	mov r4, #0x80
	tst r6, r4
	beq loc_8030BEE
	push {r0-r2}
	mov r4, #0x7f
	and r6, r4
	ldr r0, dword_8030CA8 // =0x1640 
	add r0, r0, r6
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	pop {r0-r2}
	bne loc_8030C0A
loc_8030BEE: .align 1, 0
	ldrb r6, [r7,#3]
	lsl r6, r6, #2
	ldr r4, off_8030C3C // =dword_8030C40 
	add r4, r4, r6
	ldr r4, [r4]
	mov lr, pc
	bx r4
	ldrb r4, [r5,#0xb] // (byte_2011D1B - 0x2011d10)
	add r4, r4, r3
	strb r4, [r5,#0xb] // (byte_2011D1B - 0x2011d10)
	cmp r4, #4
	bge loc_8030C1A
	cmp r3, #0
	bne loc_8030B80
loc_8030C0A: .align 1, 0
	add r2, #4
	b loc_8030BB0
loc_8030C0E: .align 1, 0
	mov r0, r12
	pop {r2-r4}
	mov r8, r2
	mov r9, r3
	mov r12, r4
	pop {r4-r7,pc}
loc_8030C1A: .align 1, 0
	ldr r0, off_8030C38 // =dword_200F3D0 
	ldr r0, [r0]
	ldr r6, [r0,#0xc]
	str r6, [r0]
	ldr r6, [r0,#0x10]
	str r6, [r0,#4]
	ldr r6, [r0,#0x14]
	str r6, [r0,#8]
	mov r0, #0
	pop {r2-r4}
	mov r8, r2
	mov r9, r3
	mov r12, r4
	pop {r4-r7,pc}
	.balign 4, 0x00
off_8030C38:
	.word dword_200F3D0
off_8030C3C:
	.word dword_8030C40
dword_8030C40:
	.word 0x0
	.word sub_8031388+1 // 0x01 up left
	.word battle_setupMessageWindow_80313B0+1 // 0x02 down right
	.word battle_runTextboxUpdateAndSetStateBit1_80313D4+1 // 0x03 down left
	.word sub_80313FC+1 // 0x04 up right
	.word sub_8031420+1 // 0x05 corner right
	.word sub_8031478+1 // 0x06 corner down
	.word sub_80314CC+1 // 0x07 corner up
	.word sub_8031520+1 // 0x08 corner left
	.word sub_80311F4+1 // 0x09 vertical right
	.word camera_initAndActivate_803123E+1 // 0x0a horizontal down
	.word sub_8031264+1 // 0x0b horizontal up
	.word sub_803128E+1 // 0x0c vertical left
	.word sub_80312D0+1 // 0x0d ??? weird version of 0x9, used partially for the judge tree comp stump walls https://i.imgur.com/dcfOYtJ.png
	.word sub_8031302+1 // 0x0e ??? likely a weird version of 0xa
	.word sub_8031330+1 // 0x0f ??? weird version of 0xb, used partially for the judge tree comp stump walls https://i.imgur.com/3tXbSRb.png
	.word camera_recenterAndSetCtrlBits_803135E+1 // 0x10 ??? likely a weird version of 0xc
	.word 0x0
	.word 0x0
	.word 0x0
	.word 0x0
	.word 0x0
	.word 0x0
	.word 0x0
	.word 0x0
	.word 0x0
dword_8030CA8:
	.word 0x1640
	thumb_func_end checkCollision_8030b6a

	thumb_local_start
// r0 - pointer to coords
// r5 - pointer to 2011d10
// symdb: Bresenham line draw across an OWObjectCoords from target to current position, calling sub_8030DA2 to plot each tile along the way.
// symdb: void sub_8030CAC(OWObjectCoords* obj, u32 ctx /* r5 */)   /* inputs: r0=obj, r5=ctx, lr */   /*
// symdb: outputs: r0=obj (preserved), r5=ctx (preserved) */   /* clobbers: r1-r4, r6-r8, lr, and flags
// symdb: N/Z/C/V */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/owObject_lineDraw_8030CAC.yaml
owObject_lineDraw_8030CAC:
	push {lr}
	push {r0,r5}
	mov r2, #oOWObjectCoords_NextX
	ldrsh r4, [r0,r2]
	mov r2, #oOWObjectCoords_NextY
	ldrsh r7, [r0,r2]
	bl sub_8030DA2
	mov r2, #2
	ldrsh r1, [r0,r2]
	mov r2, #0xe
	ldrsh r2, [r0,r2]
	sub r1, r1, r2
	mov r6, r1
	cmp r6, #0
	bge loc_8030CCE
	neg r6, r6
loc_8030CCE:
	mov r3, #6
	ldrsh r2, [r0,r3]
	mov r3, #0x12
	ldrsh r3, [r0,r3]
	sub r2, r2, r3
	mov r7, r2
	cmp r7, #0
	bge loc_8030CE0
	neg r7, r7
loc_8030CE0:
	cmp r6, r7
	bgt loc_8030CEC
	blt loc_8030D28
	cmp r1, #0
	bne loc_8030D64
	b loc_8030D92
loc_8030CEC:
	mov r3, #0xe
	ldrsh r4, [r0,r3]
	mov r3, #2
	ldrsh r6, [r0,r3]
	mov r3, #0x12
	ldrsh r7, [r0,r3]
	mov r3, #1
	mov r0, #1
	cmp r1, #0
	bge loc_8030D04
	neg r3, r3
	neg r1, r1
loc_8030D04:
	cmp r2, #0
	bge loc_8030D0C
	neg r0, r0
	neg r2, r2
loc_8030D0C:
	mvn r5, r1
loc_8030D0E:
	add r4, r4, r3
	cmp r4, r6
	beq loc_8030D92
	add r5, r5, r2
	add r5, r5, r2
	cmp r5, r1
	blt loc_8030D22
	add r7, r7, r0
	sub r5, r5, r1
	sub r5, r5, r1
loc_8030D22:
	bl sub_8030DA2
	b loc_8030D0E
loc_8030D28:
	mov r3, #0x12
	ldrsh r7, [r0,r3]
	mov r3, #6
	ldrsh r6, [r0,r3]
	mov r3, #0xe
	ldrsh r4, [r0,r3]
	mov r3, #1
	mov r0, #1
	cmp r1, #0
	bge loc_8030D40
	neg r3, r3
	neg r1, r1
loc_8030D40:
	cmp r2, #0
	bge loc_8030D48
	neg r0, r0
	neg r2, r2
loc_8030D48:
	mvn r5, r2
loc_8030D4A:
	add r7, r7, r0
	cmp r7, r6
	beq loc_8030D92
	add r5, r5, r1
	add r5, r5, r1
	cmp r5, r2
	blt loc_8030D5E
	add r4, r4, r3
	sub r5, r5, r2
	sub r5, r5, r2
loc_8030D5E:
	bl sub_8030DA2
	b loc_8030D4A
loc_8030D64:
	mov r3, #0x12
	ldrsh r7, [r0,r3]
	mov r3, #6
	ldrsh r6, [r0,r3]
	mov r3, #0xe
	ldrsh r4, [r0,r3]
	mov r3, #1
	mov r0, #1
	cmp r1, #0
	bge loc_8030D7C
	neg r3, r3
	neg r1, r1
loc_8030D7C:
	cmp r2, #0
	bge loc_8030D84
	neg r0, r0
	neg r2, r2
loc_8030D84:
	add r7, r7, r0
	cmp r7, r6
	beq loc_8030D92
	add r4, r4, r3
	bl sub_8030DA2
	b loc_8030D84
loc_8030D92:
	pop {r0,r5}
	mov r2, #2
	ldrsh r4, [r0,r2]
	mov r2, #6
	ldrsh r7, [r0,r2]
	bl sub_8030DA2
	pop {pc}
	thumb_func_end owObject_lineDraw_8030CAC

	thumb_local_start
// r0 - pointer to coords
// r5 - pointer to 2011d10
// r4 - next x
// r7 - next y
// symdb: Appends the tile under pixel (r4, r7) to the movement trail recorder at dword_2011D10, skipping duplicates and capping at 16 entries.
// symdb: void sub_8030DA2(s32 x /* r4 */, s32 y /* r7 */); /* r0/r4/r5/r7 preserved, nz/c/v + r8
// symdb: clobbered */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8030DA2.yaml
sub_8030DA2:
	sub sp, sp, #0x10
	str r0, [sp]
	str r5, [sp,#4]
	str r4, [sp,#8]
	str r7, [sp,#0xc]
	asr r4, r4, #3
	asr r7, r7, #3
	ldr r5, off_8030E10 // =dword_2011D10 
	ldrb r0, [r5,#0x9] // (byte_2011D19 - 0x2011d10)
	lsr r0, r0, #1
	add r7, r7, r0
	ldrb r0, [r5,#0x8] // (byte_2011D18 - 0x2011d10)
	lsr r0, r0, #1
	add r4, r4, r0
	lsl r0, r0, #1
	mul r7, r0
	add r7, r7, r4
	ldrh r0, [r5,#0x6] // (word_2011D16 - 0x2011d10)
	cmp r0, r7
	beq loc_8030E02
	ldrb r0, [r5,#0xa] // (byte_2011D1A - 0x2011d10)
	add r4, r0, #1
	cmp r4, #0x10
	bge loc_8030E02
	strh r7, [r5,#0x6] // (word_2011D16 - 0x2011d10)
	strb r4, [r5,#0xa] // (byte_2011D1A - 0x2011d10)
	ldr r4, [r5,#0x14] // (dword_2011D24 - 0x2011d10)
	add r4, #0x10
	str r4, [r5,#0x14] // (dword_2011D24 - 0x2011d10)
	mov r4, #0x10
	mul r4, r0
	add r4, #0x18
	add r5, r5, r4
	strh r7, [r5]
	ldr r4, [sp,#8]
	ldr r7, [sp,#0xc]
	mov r0, #7
	mov r8, r4
	bic r4, r0
	str r4, [r5,#4]
	mov r4, r7
	bic r4, r0
	str r4, [r5,#8]
	mov r4, r8
	ldr r0, [sp]
	ldr r5, [sp,#4]
	add sp, sp, #0x10
	mov pc, lr
loc_8030E02:
	ldr r0, [sp]
	ldr r5, [sp,#4]
	ldr r4, [sp,#8]
	ldr r7, [sp,#0xc]
	add sp, sp, #0x10
	mov pc, lr
	.balign 4, 0
off_8030E10:
	.word dword_2011D10
	thumb_func_end sub_8030DA2

// symdb: line-vs-point hit test; on hit returns the segment/line crossing offset (rx,ry) relative to a reference point, on miss returns (0,0)
// symdb: u32 sub_8030E14(u32 matrix, u32 x1, u32 y1, u32 x2, u32 y2, u32 mode, u32 r9_in)     /* r0:
// symdb: matrix ptr (ref0 = +0/+4, ref1 = +0xC/+0x10) */     /* r2: x1, r4: y1, r3: x2, r5: y2 */     /*
// symdb: r6: mode (1 = one-sided, ignore ref1) */     /* returns: r0 = rx (crossing x relative to ref0; 0
// symdb: on miss) */     /*          r1 = ry (crossing y relative to ref0; 0 on miss) */     /*
// symdb: r4,r6,r7,r8,r9 = per-path working values the caller may keep */     /* clobbers flags; lr
// symdb: clobbered via tail-pop */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8030E14.yaml
	thumb_local_start
sub_8030E14:
	push {lr}
	mov r8, r6
	sub r6, r5, r4
	sub r7, r2, r3
	mul r3, r4
	mul r2, r5
	sub r2, r3, r2
	ldr r3, [r0]
	ldr r4, [r0,#4]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	bge loc_8030E86
	mov r3, r8
	cmp r3, #1
	beq loc_8030E4C
	ldr r3, [r0,#0xc]
	ldr r4, [r0,#0x10]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	blt loc_8030E86
loc_8030E4C:
	ldr r3, [r0]
	mul r3, r6
	add r3, r3, r2
	neg r3, r3
	mov r4, r7
	push {r6,r7}
	mov r6, r3
	mov r7, r4
	bl sub_8031048
	ldr r4, [r0,#4]
	sub r4, r7, r4
	mov r8, r4
	pop {r6,r7}
	ldr r3, [r0,#4]
	mul r3, r7
	add r3, r3, r2
	neg r3, r3
	mov r4, r6
	mov r6, r3
	mov r7, r4
	bl sub_8031048
	ldr r4, [r0]
	sub r4, r7, r4
	mov r9, r4
	mov r0, r9
	mov r1, r8
	pop {pc}
loc_8030E86:
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_8030E14

	thumb_local_start
sub_8030E8C:
	push {lr}
	mov r8, r6
	sub r6, r5, r4
	sub r7, r2, r3
	mul r3, r4
	mul r2, r5
	sub r2, r3, r2
	ldr r3, [r0]
	ldr r4, [r0,#4]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	bge loc_8030EFE
	mov r3, r8
	cmp r3, #1
	beq loc_8030EC4
	ldr r3, [r0,#0xc]
	ldr r4, [r0,#0x10]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	blt loc_8030EFE
loc_8030EC4:
	ldr r3, [r0]
	mul r3, r6
	add r3, r3, r2
	neg r3, r3
	mov r4, r7
	push {r6,r7}
	mov r6, r3
	mov r7, r4
	bl sub_8031048
	ldr r4, [r0,#4]
	sub r4, r7, r4
	mov r8, r4
	pop {r6,r7}
	ldr r3, [r0,#4]
	mul r3, r7
	add r3, r3, r2
	neg r3, r3
	mov r4, r6
	mov r6, r3
	mov r7, r4
	bl sub_8031048
	ldr r4, [r0]
	sub r4, r7, r4
	mov r9, r4
	mov r0, r9
	mov r1, r8
	pop {pc}
loc_8030EFE:
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_8030E8C

	thumb_local_start
sub_8030F04:
	push {lr}
	mov r8, r6
	sub r6, r5, r4
	sub r7, r2, r3
	mul r3, r4
	mul r2, r5
	sub r2, r3, r2
	ldr r3, [r0]
	ldr r4, [r0,#4]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	ble loc_8030F76
	mov r3, r8
	cmp r3, #1
	beq loc_8030F3C
	ldr r3, [r0,#0xc]
	ldr r4, [r0,#0x10]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	bgt loc_8030F76
loc_8030F3C:
	ldr r3, [r0]
	mul r3, r6
	add r3, r3, r2
	neg r3, r3
	mov r4, r7
	push {r6,r7}
	mov r6, r3
	mov r7, r4
	bl sub_8031048
	ldr r4, [r0,#4]
	sub r4, r7, r4
	mov r8, r4
	pop {r6,r7}
	ldr r3, [r0,#4]
	mul r3, r7
	add r3, r3, r2
	neg r3, r3
	mov r4, r6
	mov r6, r3
	mov r7, r4
	bl sub_8031048
	ldr r4, [r0]
	sub r4, r7, r4
	mov r9, r4
	mov r0, r9
	mov r1, r8
	pop {pc}
loc_8030F76:
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_8030F04

// symdb: Tests whether a line segment crosses a two-edge wedge (stored in an object) and returns the intersection coordinates, or (0,0) on no-cross.
// symdb: seg_result col_segEdgeIntersect(u32 obj, u32 xA, u32 yA, u32 xB, u32 yB, u32 mode)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8030F7C.yaml
	thumb_local_start
sub_8030F7C:
	push {lr}
	mov r8, r6
	sub r6, r5, r4
	sub r7, r2, r3
	mul r3, r4
	mul r2, r5
	sub r2, r3, r2
	ldr r3, [r0]
	ldr r4, [r0,#4]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	ble loc_8030FEE
	mov r3, r8
	cmp r3, #1
	beq loc_8030FB4
	ldr r3, [r0,#0xc]
	ldr r4, [r0,#0x10]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	bgt loc_8030FEE
loc_8030FB4:
	ldr r3, [r0]
	mul r3, r6
	add r3, r3, r2
	neg r3, r3
	mov r4, r7
	push {r6,r7}
	mov r6, r3
	mov r7, r4
	bl sub_8031048
	ldr r4, [r0,#4]
	sub r4, r7, r4
	mov r8, r4
	pop {r6,r7}
	ldr r3, [r0,#4]
	mul r3, r7
	add r3, r3, r2
	neg r3, r3
	mov r4, r6
	mov r6, r3
	mov r7, r4
	bl sub_8031048
	ldr r4, [r0]
	sub r4, r7, r4
	mov r9, r4
	mov r0, r9
	mov r1, r8
	pop {pc}
loc_8030FEE:
	mov r0, #0
	mov r1, #0
	pop {pc}
	.balign 4, 0
DebugStrings8030FF4:
	.word DebugStr8031004
	.word DebugStr8031015
	.word DebugStr8031026
	.word DebugStr8031037
DebugStr8031004:
	.hword 0xD00
	.asciz "00 X:%8X Y:%8X"
DebugStr8031015:
	.hword 0xE00
	.asciz "01 X:%8X Y:%8X"
DebugStr8031026:
	.hword 0xF00
	.asciz "02 X:%8X Y:%8X"
DebugStr8031037:
	.hword 0x1000
	.asciz "03 X:%8X Y:%8X"
	thumb_func_end sub_8030F7C

	thumb_local_start
sub_8031048:
	push {r2,r3,lr}
	mov r2, #0
	mov r3, #0
	cmp r7, #0
	beq loc_803106C
	cmp r6, #0
	bge loc_803105A
	neg r6, r6
	mvn r3, r3
loc_803105A:
	cmp r7, #0
	bge loc_8031062
	neg r7, r7
	mvn r3, r3
loc_8031062:
	cmp r6, r7
	blt loc_803106C
	sub r6, r6, r7
	add r2, #1
	b loc_8031062
loc_803106C:
	mov r7, r2
	cmp r3, #0
	beq locret_8031076
	neg r7, r7
	neg r6, r6
locret_8031076:
	pop {r2,r3,pc}
	thumb_func_end sub_8031048

	thumb_local_start
sub_8031078:
	push {r2,r3,lr}
	mov r2, #0
	mov r3, #0
	cmp r7, #0
	beq loc_803109C
	cmp r6, #0
	bge loc_803108A
	neg r6, r6
	mvn r3, r3
loc_803108A:
	cmp r7, #0
	bge loc_8031092
	neg r7, r7
	mvn r3, r3
loc_8031092:
	cmp r6, r7
	blt loc_803109C
	sub r6, r6, r7
	add r2, #1
	b loc_8031092
loc_803109C:
	lsr r7, r7, #1
	cmp r6, r7
	blt loc_80310A4
	add r2, #1
loc_80310A4:
	mov r7, r2
	cmp r3, #0
	beq locret_80310AE
	neg r7, r7
	neg r6, r6
locret_80310AE:
	pop {r2,r3,pc}
	thumb_func_end sub_8031078

// symdb: Adds a delta (scaled to fixed-point) plus the current scroll offsets to the camera position, skipping the update when the delta is zero.
// symdb: void camera_moveByDelta(int dx, int dy); // r0=delta x, r1=delta y (both shifted <<14
// symdb: internally); returns r3=1 if camera updated, 0 if skipped, r4=scroll state base, r6=new y; c/v
// symdb: set from the final y add (update path) or the 'moved==0' compare (skip path)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_moveByDelta_80310B0.yaml
	thumb_local_start
camera_moveByDelta_80310B0:
	push {lr}
	lsl r0, r0, #0xe
	lsl r1, r1, #0xe
	mov r3, #1
	cmp r0, #0
	beq loc_80310BE
	b loc_80310C6
loc_80310BE:
	cmp r1, #0
	beq loc_80310C4
	b loc_80310C6
loc_80310C4:
	mov r3, #0
loc_80310C6:
	cmp r3, #0
	beq locret_80310E4
	ldr r5, off_80310E8 // =dword_200F3D0 
	ldr r5, [r5]
	ldr r4, off_80311F0 // =dword_200F3E0 
	ldr r6, [r5]
	add r6, r6, r0
	ldr r2, [r4,#0x18] // (dword_200F3F8 - 0x200f3e0)
	add r6, r6, r2
	str r6, [r5]
	ldr r6, [r5,#4]
	add r6, r6, r1
	ldr r2, [r4,#0x1c] // (dword_200F3FC - 0x200f3e0)
	add r6, r6, r2
	str r6, [r5,#4]
locret_80310E4:
	pop {pc}
	.balign 4, 0
off_80310E8:
	.word dword_200F3D0
	thumb_func_end camera_moveByDelta_80310B0

// symdb: Converts a sprite object's fixed-point world coordinates into screen coordinates by subtracting the camera scroll offsets.
// symdb: void sprite_worldToScreenPos(struct SpritePos *pos /*r0*/, struct ParentObj *parent /*r5*/,
// symdb: const struct WorldCoords *world /*r6*/)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_worldToScreenPos_80310EC.yaml
	thumb_local_start
sprite_worldToScreenPos_80310EC:
	push {lr}
	ldr r4, [r5,#0x10]
	ldr r2, [r4,#4]
	lsl r2, r2, #2
	ldr r5, [r4,#8]
	lsl r5, r5, #2
	ldr r7, [r6]
	ldr r3, [r0,#0x18]
	add r7, r7, r3
	asr r7, r7, #0xe
	sub r7, r7, r2
	str r7, [r0]
	ldr r7, [r6,#4]
	ldr r3, [r0,#0x1c]
	add r7, r7, r3
	asr r7, r7, #0xe
	sub r7, r7, r5
	str r7, [r0,#4]
	ldr r7, [r6,#0xc]
	asr r7, r7, #0xe
	sub r7, r7, r2
	str r7, [r0,#0xc]
	ldr r7, [r6,#0x10]
	asr r7, r7, #0xe
	sub r7, r7, r5
	str r7, [r0,#0x10]
	pop {pc}
	thumb_func_end sprite_worldToScreenPos_80310EC

// symdb: Zeroes two counter/flag words of the global state struct at dword_200F3E0 and then continues processing it via sub_80310EC.
// symdb: u32 resetStateAndStep_8031122(u32 stateObj /*r0*/, u32 arg /*r5, forwarded to callee*/); returns
// symdb: r0 = result of sub_80310EC
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031122.yaml
	thumb_local_start
sub_8031122:
	push {lr}
	mov r6, r0
	ldr r0, off_80311F0 // =dword_200F3E0 
	mov r2, #0
	mov r3, #0
	str r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	str r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	bl sprite_worldToScreenPos_80310EC
	pop {pc}
	thumb_func_end sub_8031122

	thumb_local_start
sub_8031136:
	push {lr}
	mov r6, r0
	ldr r0, off_80311F0 // =dword_200F3E0 
	ldr r2, [r6,#0xc]
	ldr r7, [r6]
	sub r7, r7, r2
	str r7, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	ldr r2, [r6,#0x10]
	ldr r7, [r6,#4]
	sub r7, r7, r2
	str r7, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	ldr r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	ldr r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	cmp r2, #0
	bgt loc_8031158
	blt loc_8031168
	b loc_8031168
loc_8031158:
	cmp r3, #0
	bgt loc_803115E
	b loc_8031168
loc_803115E:
	cmp r2, r3
	bne loc_8031168
	str r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	str r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	b loc_8031170
loc_8031168:
	mov r2, #0
	mov r3, #0
	str r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	str r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
loc_8031170:
	bl sprite_worldToScreenPos_80310EC
	pop {pc}
	thumb_func_end sub_8031136

	thumb_local_start
sub_8031176:
	push {lr}
	mov r6, r0
	ldr r0, off_80311F0 // =dword_200F3E0 
	ldr r2, [r6,#0xc]
	ldr r7, [r6]
	sub r7, r7, r2
	str r7, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	ldr r2, [r6,#0x10]
	ldr r7, [r6,#4]
	sub r7, r7, r2
	str r7, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	ldr r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	ldr r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	cmp r2, #0
	bgt loc_80311A8
	blt loc_8031198
	b loc_80311A8
loc_8031198:
	cmp r3, #0
	blt loc_803119E
	b loc_80311A8
loc_803119E:
	cmp r2, r3
	bne loc_80311A8
	str r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	str r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	b loc_80311B0
loc_80311A8:
	mov r2, #0
	mov r3, #0
	str r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	str r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
loc_80311B0:
	bl sprite_worldToScreenPos_80310EC
	pop {pc}
	thumb_func_end sub_8031176

// symdb: Computes an entity's movement delta since its last recorded position (dropping diagonal moves) and stores it in the scroll/camera state before converting that state's world position to screen coordinates.
// symdb: u32 scroll_updateObjectDelta_80311B6(void* obj /*r0*/, void* aux /*r5, passed through*/);
// symdb: returns whatever sprite_worldToScreenPos_80310EC returns in r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_80311B6.yaml
	thumb_local_start
sub_80311B6:
	push {lr}
	mov r6, r0
	ldr r0, off_80311F0 // =dword_200F3E0 
	ldr r2, [r6,#0xc]
	ldr r7, [r6]
	sub r7, r7, r2
	str r7, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	ldr r2, [r6,#0x10]
	ldr r7, [r6,#4]
	sub r7, r7, r2
	str r7, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	ldr r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	ldr r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	cmp r2, #0
	beq loc_80311DA
	cmp r3, #0
	beq loc_80311DA
	b loc_80311E0
loc_80311DA:
	str r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	str r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
	b loc_80311E8
loc_80311E0:
	mov r2, #0
	mov r3, #0
	str r2, [r0,#0x18] // (dword_200F3F8 - 0x200f3e0)
	str r3, [r0,#0x1c] // (dword_200F3FC - 0x200f3e0)
loc_80311E8:
	bl sprite_worldToScreenPos_80310EC
	pop {pc}
	.balign 4, 0
off_80311F0:
	.word dword_200F3E0
	thumb_func_end sub_80311B6

// symdb: Likely a small per-frame effect routine that, when sub_8031570 reports a hit/non-zero event, re-runs sub_8031122/sub_80311B6 setup, queries sub_8030E14 for a position delta, neg-halves it via neg;lsr
// symdb: void sub_80311F4(u32* io /* r0 */, u32 arg1 /* r1 */, u32 arg2 /* r2 */, u32 arg5 /* r5 */, u32*
// symdb: ioFlags /* r12, gets |=3 */)   -> sets r0/r1/r2/r5/r12; clobbers r4/r6/r7/r8/r9 and NZCV;
// symdb: preserves caller r0/r1/r2/r5
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_80311F4.yaml
	thumb_local_start
sub_80311F4:
	push {lr}
	push {r0-r2,r5}
	bl sub_8031122
	mov r2, #0
	mov r4, #0x20 
	mov r3, #0x20 
	mov r5, #0
	bl sub_8031570
	mov r3, #0
	cmp r0, #0
	beq loc_8031234
	pop {r0-r2,r5}
	push {r0-r2,r5}
	bl sub_80311B6
	mov r2, #0
	mov r4, #0x20 
	mov r3, #0x20 
	mov r5, #0
	mov r6, #1
	bl sub_8030E14
	neg r0, r0
	lsr r0, r0, #1
	neg r0, r0
	neg r1, r1
	lsr r1, r1, #1
	neg r1, r1
	bl camera_moveByDelta_80310B0
loc_8031234:
	mov r0, r12
	mov r1, #3
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end sub_80311F4

// symdb: Initializes a camera via sub_8031122, snaps it to its current center (halved coords from sub_8030E8C) via camera_moveByDelta_80310B0, and sets bits 0 and 1 of the caller's r12 to mark it active and ready.
// symdb: void camera_initAndActivate_803123E(u32 savedR0, u32 savedR1, u32 savedR2, u32 savedR5, u32*
// symdb: cameraState);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_initAndActivate_803123E.yaml
	thumb_local_start
camera_initAndActivate_803123E:
	push {r0-r2,r5,lr}
	bl sub_8031122
	mov r2, #0
	mov r4, #0
	mov r3, #0x20 
	mov r5, #0x20 
	mov r6, #1
	bl sub_8030E8C
	lsr r0, r0, #1
	asr r1, r1, #1
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #3
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end camera_initAndActivate_803123E

	thumb_local_start
sub_8031264:
	push {r0-r2,r5,lr}
	bl sub_8031122
	mov r2, #0
	mov r4, #0
	mov r3, #0x20 
	mov r5, #0x20 
	mov r6, #1
	bl sub_8030F04
	neg r0, r0
	lsr r0, r0, #1
	neg r0, r0
	lsr r1, r1, #1
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #3
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end sub_8031264

// symdb: Resolves the player/camera pose, optionally pans the camera by half the right-pose delta, and flags the result by ORing 3 into the r12 camera-state word.
// symdb: void sub_803128E(u32 r0, u32 r1, u32 r2, u32 r5, u32* r12 /* in/out */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803128E.yaml
	thumb_local_start
sub_803128E:
	push {lr}
	push {r0-r2,r5}
	bl sub_8031122
	mov r2, #0
	mov r4, #0x20 
	mov r3, #0x20 
	mov r5, #0
	bl math_pointLeftOfLineTest_80315DC
	mov r3, #0
	cmp r0, #0
	beq loc_80312C6
	pop {r0-r2,r5}
	push {r0-r2,r5}
	bl sub_80311B6
	mov r2, #0
	mov r4, #0x20 
	mov r3, #0x20 
	mov r5, #0
	mov r6, #1
	bl sub_8030F7C
	lsr r0, r0, #1
	lsr r1, r1, #1
	bl camera_moveByDelta_80310B0
loc_80312C6:
	mov r0, r12
	mov r1, #3
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end sub_803128E

	thumb_local_start
sub_80312D0:
	push {r0-r2,r5,lr}
	bl sub_80311B6
	mov r2, #0
	mov r4, #0x20 
	sub r4, #0x20 
	mov r3, #0x20 
	mov r5, #0
	sub r5, #0x20 
	mov r6, #1
	bl sub_8030E14
	neg r0, r0
	lsr r0, r0, #1
	neg r0, r0
	neg r1, r1
	lsr r1, r1, #1
	neg r1, r1
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #3
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end sub_80312D0

	thumb_local_start
sub_8031302:
	push {r0-r2,r5,lr}
	bl sub_8031122
	mov r2, #0
	mov r4, #0
	sub r4, #0x20 
	mov r3, #0x20 
	mov r5, #0x20 
	sub r5, #0x20 
	mov r6, #1
	bl sub_8030E8C
	lsr r0, r0, #1
	neg r1, r1
	lsr r1, r1, #1
	neg r1, r1
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #3
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end sub_8031302

	thumb_local_start
sub_8031330:
	push {r0-r2,r5,lr}
	bl sub_8031122
	mov r2, #0
	mov r4, #0
	add r4, #0x20 
	mov r3, #0x20 
	mov r5, #0x20 
	add r5, #0x20 
	mov r6, #1
	bl sub_8030F04
	neg r0, r0
	lsr r0, r0, #1
	neg r0, r0
	lsr r1, r1, #1
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #3
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end sub_8031330

// symdb: Recenter the overworld/map camera to a fixed 64x32 anchor box and OR 0x3 into the r12 control word
// symdb: void camera_recenterAndSetCtrlBits_803135E(void); /* in: implicit r0/r1/r2/r5/r12/lr snapshot;
// symdb: out: r0,r1,r2,r3,r5,r12; clobbers nz,cv,r4,r6-r9,lr; preserves r0,r1,r2,r5 for caller via
// symdb: push/pop */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/camera_recenterAndSetCtrlBits_803135E.yaml
	thumb_local_start
camera_recenterAndSetCtrlBits_803135E:
	push {r0-r2,r5,lr}
	bl sub_80311B6
	mov r2, #0
	mov r4, #0x20 
	add r4, #0x20 
	mov r3, #0x20 
	mov r5, #0
	add r5, #0x20 
	mov r6, #1
	bl sub_8030F7C
	lsr r0, r0, #1
	lsr r1, r1, #1
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #3
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end camera_recenterAndSetCtrlBits_803135E

// symdb: Runs the family's three-step helper sequence (prepare, draw/iterate over an unbounded 0x20-entry extent, finish) and then marks the r12 state flags as active by setting the low bit.
// symdb: void sub_8031388(u32 arg0 /*r0*/, u32 arg1 /*r1*/, u32 arg2 /*r2*/, u32 arg5 /*r5*/); returns
// symdb: with r0-r2/r5 preserved (restored from stack), r12 |= 1, NZ set from the new r12 value,
// symdb: r3/r4/r6/r7-r9 whatever sub_80310B0 left.
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031388.yaml
	thumb_local_start
sub_8031388:
	push {r0-r2,r5,lr}
	bl sub_8031136
	mov r2, #0
	sub r2, #1
	mov r4, #0x20 
	mov r3, #0
	sub r3, #1
	mov r5, #0
	mov r6, #1
	bl sub_8030E14
	mov r1, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #1
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end sub_8031388

// symdb: Runs the full battle message-window setup sequence (prepare, 32x32 layout, finalize) and flags the request as handled in r12.
// symdb: void sub_80313B0(void); /* args in r0, r1, r2, r5 passed through to sub_8031176; r12 = flag word
// symdb: in/out; preserves r0, r1, r2, r5; NZCV on exit reflect (r12|1) */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_setupMessageWindow_80313B0.yaml
	thumb_local_start
battle_setupMessageWindow_80313B0:
	push {r0-r2,r5,lr}
	bl sub_8031176
	mov r2, #0x20 
	mov r4, #0
	mov r3, #0x20 
	mov r5, #0x20 
	mov r6, #1
	bl sub_8030E8C
	mov r1, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #1
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end battle_setupMessageWindow_80313B0

// symdb: Runs the standard battle text-box update sequence (init, fill/clear with fixed parameters, redraw pass) and then marks bit 1 of the r12 battle-state flag word as done.
// symdb: void sub_80313D4(u32 arg0 /*r0*/, u32 arg1 /*r1*/, u32 arg2 /*r2*/, u32 state /*r5*/, u32 flags
// symdb: /*r12*/); // preserves r0-r2, r5; clobbers r3,r4,r6-r9,r12,lr; flags out NZ from "flags |= 2"
// symdb: (CV from callee chains)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_runTextboxUpdateAndSetStateBit1_80313D4.yaml
	thumb_local_start
battle_runTextboxUpdateAndSetStateBit1_80313D4:
	push {r0-r2,r5,lr}
	bl sub_8031136
	mov r2, #0x20 
	mov r4, #0
	sub r4, #1
	mov r3, #0
	mov r5, #0
	sub r5, #1
	mov r6, #1
	bl sub_8030F04
	mov r0, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #2
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end battle_runTextboxUpdateAndSetStateBit1_80313D4

// symdb: Runs a fixed three-call sequence (step handler, a 0x20/0x20/0x20/1 parameterized setup, and a 0-arg call) and then sets bit 1 of the caller's state word in r12.
// symdb: void sub_80313FC(void /* r0, r1, r2, r5: passed through and preserved; r12: in/out state word
// symdb: */); returns updated state in r12 with NZ flags set from it
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_80313FC.yaml
	thumb_local_start
sub_80313FC:
	push {r0-r2,r5,lr}
	bl sub_8031176
	mov r2, #0
	mov r4, #0x20 
	mov r3, #0x20 
	mov r5, #0x20 
	mov r6, #1
	bl sub_8030F7C
	mov r0, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	mov r1, #2
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5,pc}
	thumb_func_end sub_80313FC

// symdb: Drives the camera across a map edge into the adjacent map, in two half-scroll passes (first half via one delta provider, second half via another), folding each pass's completion status into the caller's r12 accumulator.
// symdb: void sub_8031420(u32 r0, u32 r1, u32 r2, u32 r5 /* camera anchor */, u32 r12 /* status
// symdb: accumulator */); leaves r0/r1/r2/r5 unchanged, returns r3 = status of the last camera move (0 =
// symdb: still scrolling, 1 = that pass finished) and r12 with bit0 = pass-1 status, bit1 = pass-2
// symdb: status; clobbers r4/r6-r9, lr and the NZCV flags.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8031420.yaml
	thumb_local_start
sub_8031420:
	push {lr}
	push {r0-r2,r5}
	bl sub_8031136
	mov r2, #0
	sub r2, #1
	mov r4, #0x20 
	mov r3, #0
	sub r3, #1
	mov r5, #0
	mov r6, #0
	bl sub_8030E14
	mov r1, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	lsl r1, r3, #0
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5}
	cmp r3, #1
	beq locret_8031476
	push {r0-r2,r5}
	bl sub_8031136
	mov r2, #0x20 
	mov r4, #0
	sub r4, #1
	mov r3, #0
	mov r5, #0
	sub r5, #1
	mov r6, #0
	bl sub_8030F04
	mov r0, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	lsl r1, r3, #1
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5}
locret_8031476:
	pop {pc}
	thumb_func_end sub_8031420

// symdb: Two-axis camera scroll during battle transitions: horizontal pass with object nudge, then optional vertical pass; accumulates scroll-state bits in r12.
// symdb: void battle_camScrollTwoPass_8031478(u32 r0, u32 r5, u32 *r12_inout); /* returns modified r3,
// symdb: r12; preserves r0-r2, r5 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8031478.yaml
	thumb_local_start
sub_8031478:
	push {lr}
	push {r0-r2,r5}
	bl sub_8031176
	mov r2, #0x20 
	mov r4, #0
	mov r3, #0x20 
	mov r5, #0x20 
	mov r6, #0
	bl sub_8030E8C
	mov r1, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	lsl r1, r3, #0
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5}
	cmp r3, #1
	beq locret_80314CA
	push {r0-r2,r5}
	bl sub_8031136
	mov r2, #0x20 
	mov r4, #0
	sub r4, #1
	mov r3, #0
	mov r5, #0
	sub r5, #1
	mov r6, #0
	bl sub_8030F04
	mov r0, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	lsl r1, r3, #1
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5}
locret_80314CA:
	pop {pc}
	thumb_func_end sub_8031478

	thumb_local_start
sub_80314CC:
	push {lr}
	push {r0-r2,r5}
	bl sub_8031136
	mov r2, #0
	sub r2, #1
	mov r4, #0x20 
	mov r3, #0
	sub r3, #1
	mov r5, #0
	mov r6, #0
	bl sub_8030E14
	mov r1, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	lsl r1, r3, #0
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5}
	cmp r3, #1
	beq locret_803151E
	push {r0-r2,r5}
	bl sub_8031176
	mov r2, #0
	mov r4, #0x20 
	mov r3, #0x20 
	mov r5, #0x20 
	mov r6, #0
loc_803150A:
	bl sub_8030F7C
loc_803150E:
	mov r0, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	lsl r1, r3, #1
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5}
locret_803151E:
	pop {pc}
	thumb_func_end sub_80314CC

	thumb_local_start
sub_8031520:
	push {lr}
	push {r0-r2,r5}
	bl sub_8031176
	mov r2, #0x20 
	mov r4, #0
	mov r3, #0x20 
	mov r5, #0x20 
	mov r6, #0
	bl sub_8030E8C
	mov r1, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	lsl r1, r3, #0
loc_8031540:
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5}
	cmp r3, #1
	beq locret_803156E
	push {r0-r2,r5}
	bl sub_8031176
loc_8031550:
	mov r2, #0
	mov r4, #0x20 
	mov r3, #0x20 
	mov r5, #0x20 
	mov r6, #0
	bl sub_8030F7C
	mov r0, #0
	bl camera_moveByDelta_80310B0
	mov r0, r12
	lsl r1, r3, #1
	orr r0, r1
	mov r12, r0
	pop {r0-r2,r5}
locret_803156E:
	pop {pc}
	thumb_func_end sub_8031520

	thumb_local_start
sub_8031570:
	sub r6, r5, r4
	sub r7, r2, r3
	mul r3, r4
	mul r2, r5
	sub r2, r3, r2
	ldr r3, [r0]
	ldr r4, [r0,#4]
	mov r5, r2
	mul r3, r6
	mul r4, r7
loc_8031584:
	add r3, r3, r4
	add r5, r5, r3
loc_8031588:
	cmp r5, #0
	bge loc_8031590
loc_803158C:
	mov r0, #1
	mov pc, lr
loc_8031590:
	mov r0, #0
	mov pc, lr
	thumb_func_end sub_8031570

// symdb: Evaluates the cross product of a point against a directed edge and returns 1 when the point falls on the negative (clockwise) side, used as the inner test of a polygon/hit-area fill routine.
// symdb: int math_pointCrossHalfPlaneTest(Point* pt /* r0 = {x, y} */, int ax /* r2 */, int bx /* r3 */,
// symdb: int ay /* r4 */, int by /* r5 */); returns 1 if the point is strictly on the negative side of
// symdb: the edge, 0 if on the edge or positive side
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/math_pointCrossHalfPlaneTest_8031594.yaml
	thumb_local_start
math_pointCrossHalfPlaneTest_8031594:
//  ((x*2 - (x & ~7)*2) * (r5 - r4)) + ((y*2 - (y & ~7)*2) * (r2 - r3)) + (r3 * r4 - r2 * r5)
	sub r6, r5, r4
	sub r7, r2, r3
	mul r3, r4
	mul r2, r5
	sub r2, r3, r2
	ldr r3, [r0]
	ldr r4, [r0,#4]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	bge loc_80315B4
	mov r0, #1
	mov pc, lr
loc_80315B4:
	mov r0, #0
	mov pc, lr
	thumb_func_end math_pointCrossHalfPlaneTest_8031594

	thumb_local_start
sub_80315B8:
	sub r6, r5, r4
	sub r7, r2, r3
	mul r3, r4
	mul r2, r5
	sub r2, r3, r2
	ldr r3, [r0]
	ldr r4, [r0,#4]
	mov r5, r2
	mul r3, r6
	mul r4, r7
loc_80315CC: // likely fake pointer
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	ble loc_80315D8
	mov r0, #1
	mov pc, lr
loc_80315D8:
	mov r0, #0
	mov pc, lr
	thumb_func_end sub_80315B8

// symdb: Returns 1 if the point stored at r0 lies on the left side of the directed line through (r2,r4)->(r3,r5), else 0.
// symdb: int math_pointLeftOfLineTest(const Point* point /*r0*/, int p1x /*r2*/, int p2x /*r3*/, int p1y
// symdb: /*r4*/, int p2y /*r5*/)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/math_pointLeftOfLineTest_80315DC.yaml
	thumb_local_start
math_pointLeftOfLineTest_80315DC:
	sub r6, r5, r4
	sub r7, r2, r3
	mul r3, r4
	mul r2, r5
	sub r2, r3, r2
	ldr r3, [r0]
	ldr r4, [r0,#4]
	mov r5, r2
	mul r3, r6
	mul r4, r7
	add r3, r3, r4
	add r5, r5, r3
	cmp r5, #0
	ble loc_80315FC
	mov r0, #1
	mov pc, lr
loc_80315FC:
	mov r0, #0
	mov pc, lr
	thumb_func_end math_pointLeftOfLineTest_80315DC

// symdb: Feeds one 4-byte text command entry into the text printer state block, storing its halfword operand and marking the printer idle with 0xFE end bytes.
// symdb: void textPrinter_QueueEndCommand(u32* cmd) /* r0: pointer to the current text command entry; no
// symdb: return value, no flag contract */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031600.yaml
	thumb_local_start
sub_8031600:
	ldr r5, off_8031780 // =dword_2011A20 
	ldr r1, [r0]
	strh r1, [r5,#0x4] // (word_2011A24 - 0x2011a20)
	add r0, #4
	str r0, [r5]
	mov r0, #0xfe
	strb r0, [r5,#0x6] // (byte_2011A26 - 0x2011a20)
	strb r0, [r5,#0x7] // (byte_2011A27 - 0x2011a20)
	mov pc, lr
	thumb_func_end sub_8031600

	thumb_func_start checkZCoordModifiers_8031612
checkZCoordModifiers_8031612:
	push {r4-r7,lr}
	mov r4, r8
	mov r5, r9
	mov r6, r12
	push {r4-r6}
	ldr r5, off_8031780 // =dword_2011A20
	ldr r2, off_8031688 // =dword_200F3D0 
	str r0, [r2]
	bl getOWObjectGridCellIndex_80316F8
	bl findFirstEntryWithId_8030B1E
	cmp r2, #0
	beq loc_8031678
	mov r3, #0
	.balign 4, 0
loc_8031630: .align 1, 0
	ldrh r4, [r2]
	cmp r1, r4
	bne loc_8031658
	ldrh r7, [r2,#2]
	ldr r4, [r5]
	add r7, r7, r4
	mov r4, #0
	ldrsb r4, [r7,r4]
	mov r6, #0xa
	ldrsh r6, [r0,r6]
	cmp r6, r4
	blt loc_803165E
	cmp r3, #0
	beq loc_8031654
	mov r6, #0
	ldrsb r6, [r3,r6]
	cmp r6, r4
	bgt loc_803165E
loc_8031654: .align 1, 0
	mov r3, r7
	b loc_803165E
loc_8031658: .align 1, 0
	cmp r3, #0
	beq loc_8031678
	b loc_8031662
loc_803165E: .align 1, 0
	add r2, #4
	b loc_8031630
loc_8031662: .align 1, 0
	str r3, [r5,#0x14] // (dword_2011A34 - 0x2011a20)
	ldrb r6, [r3,#3]
	cmp r6, #0xff
	beq loc_8031678
	lsl r6, r6, #2
	ldr r4, off_803168C // =dword_8031690 
	add r4, r4, r6
	ldr r4, [r4]
	mov lr, pc
	bx r4
	b loc_803167C
loc_8031678: .align 1, 0
	mov r0, #0
	mov r1, #0
loc_803167C: .align 1, 0
	pop {r4-r6}
	mov r8, r4
	mov r9, r5
	mov r12, r6
	pop {r4-r7,pc}
	.balign 4, 0x00
off_8031688:
	.word dword_200F3D0
off_803168C:
	.word dword_8031690
dword_8031690:
	.word NULL // 0x0
	.word sub_803178A+1 // 0x1
	.word sub_80317A6+1 // 0x2
	.word sub_80317C2+1 // 0x3
	.word sub_80317DE+1 // 0x4
	.word NULL // 0x5
	.word NULL // 0x6
	.word NULL // 0x7
	.word NULL // 0x8
	.word NULL // 0x9
	.word NULL // 0xa
	.word NULL // 0xb
	.word NULL // 0xc
	.word NULL // 0xd
	.word NULL // 0xe
	.word NULL // 0xf
	.word NULL // 0x10
	.word sub_80317FA+1 // 0x11
	.word sub_8031808+1 // 0x12
	.word sub_803182A+1 // 0x13
	.word sub_8031852+1 // 0x14
	.word sub_8031874+1 // 0x15
	.word NULL // 0x16
	.word NULL // 0x17
	.word NULL // 0x18
	.word NULL // 0x19
	thumb_func_end checkZCoordModifiers_8031612

// symdb: Turn an overworld object's position into a cell index of the layer-region grid.
// symdb: (r0 = object coords, r5 = grid header (Ex2011a20)) -> [r5+8] = (unk06 & ~1) * (y/8 + unk07/2) +
// symdb: x/8 + unk06/2; [r5+0xC] = x & ~7, [r5+0x10] = y & ~7; r1 = the index, r3 = 7
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/getOWObjectGridCellIndex_80316F8.yaml
	thumb_local_start
getOWObjectGridCellIndex_80316F8:
	mov r2, #oOWObjectCoords_X
	ldrsh r1, [r0,r2]
	mov r2, #oOWObjectCoords_Y
	ldrsh r2, [r0,r2]
	asr r1, r1, #3
	asr r2, r2, #3

	// at a glance, unk07 and unk06 seem to be always 0xfe
	ldrb r3, [r5,#oUnk_Ex2011a20_Unk_07]
	lsr r3, r3, #1

	// y/8 + unk07/2
	add r2, r2, r3

	ldrb r3, [r5,#oUnk_Ex2011a20_Unk_06]	
	lsr r3, r3, #1

	// x/8 + unk06/2
	add r1, r1, r3

	lsl r3, r3, #1
	mul r2, r3

	// r2 = unk06 * (y/8 + unk07/2) + x/8 + unk06/2
	add r2, r2, r1
	strh r2, [r5,#oUnk_Ex2011a20_Unk_08]

	mov r2, #oOWObjectCoords_X
	ldrsh r1, [r0,r2]
	mov r2, #oOWObjectCoords_Y
	ldrsh r2, [r0,r2]

	// store x and y with lower 3 bits truncated into unk0c and unk10
	mov r3, #7
	bic r1, r3
	str r1, [r5,#oUnk_Ex2011a20_Unk_0c]
	bic r2, r3
	str r2, [r5,#oUnk_Ex2011a20_Unk_10]

	// return value
	ldrh r1, [r5,#oUnk_Ex2011a20_Unk_08]
	mov pc, lr
	thumb_func_end getOWObjectGridCellIndex_80316F8

// symdb: Computes an entity's (and its next-position) coordinates relative to a doubled target reference point, storing the results in a scratch buffer.
// symdb: Next* battle_calcRelPosToTarget_803172E(void* posBlock /* r0 */, void* targetBlock /* r5 */); //
// symdb: returns r0 = &dword_200F3E0, r6 = posBlock, r7 = last value written
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_calcRelPosToTarget_803172E.yaml
	thumb_local_start
battle_calcRelPosToTarget_803172E:
	mov r6, r0
	ldr r0, off_803175C // =dword_200F3E0 
	ldr r2, [r5,#0xc]
	lsl r2, r2, #1
	ldr r5, [r5,#0x10]
	lsl r5, r5, #1
	ldr r7, [r6]
	asr r7, r7, #0xf
	sub r7, r7, r2
	// (x * 2 - tx * 2)
	str r7, [r0]

	ldr r7, [r6,#4]
	asr r7, r7, #0xf
	sub r7, r7, r5
	// (y * 2 - ty * 2)
	str r7, [r0,#0x4] // (dword_200F3E4 - 0x200f3e0)
	
	ldr r7, [r6,#0xc]
	asr r7, r7, #0xf
	sub r7, r7, r2
	// nextx * 2 - tx * 2
	str r7, [r0,#0xc] // (dword_200F3EC - 0x200f3e0)
	
	ldr r7, [r6,#0x10]
	asr r7, r7, #0xf
	sub r7, r7, r5
	// nexty * 2 - ty * 2
	str r7, [r0,#0x10] // (dword_200F3F0 - 0x200f3e0)
	mov pc, lr
off_803175C:
	.word dword_200F3E0
	thumb_func_end battle_calcRelPosToTarget_803172E

// symdb: Reads the header bytes (signed count at +0, byte at +1, and byte at +2 when requested) of the current entry of the table pointed to by dword_2011A20.
// symdb: int table_GetCurrentEntryHeader(u32 mode) -> r0 = signed byte at entry+0, r1 = entry+2 byte (if
// symdb: mode==1) else 0, r2 = entry pointer, r3 = entry+1 byte, r5 = table base pointer
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/table_GetCurrentEntryHeader_8031760.yaml
	thumb_local_start
table_GetCurrentEntryHeader_8031760:
	ldr r5, off_8031780 // =dword_2011A20 
	cmp r0, #1
	beq loc_8031768
	b loc_8031774
loc_8031768:
	ldr r2, [r5,#0x14] // (dword_2011A34 - 0x2011a20)
	mov r0, #0
	ldrsb r0, [r2,r0]
	ldrb r1, [r2,#2]
	ldrb r3, [r2,#1]
	mov pc, lr
loc_8031774:
	ldr r2, [r5,#0x14] // (dword_2011A34 - 0x2011a20)
	mov r0, #0
	ldrsb r0, [r2,r0]
	mov r1, #0
	ldrb r3, [r2,#1]
	mov pc, lr
	.balign 4, 0
off_8031780:
	.word dword_2011A20
	thumb_func_end table_GetCurrentEntryHeader_8031760

	thumb_local_start
sub_8031784:
	push {lr}
	mov r0, #0
	pop {pc}
	thumb_func_end sub_8031784

	thumb_local_start
sub_803178A:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #4
	mov r4, #0
	mov r3, #4
	mov r5, #0x10
	bl math_pointCrossHalfPlaneTest_8031594
	bl table_GetCurrentEntryHeader_8031760
	add r0, r0, r1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803178A

	thumb_local_start
sub_80317A6:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #8
	mov r4, #0
	mov r3, #8
	mov r5, #0x10
	bl sub_80315B8
	bl table_GetCurrentEntryHeader_8031760
	add r0, r0, r1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_80317A6

	thumb_local_start
sub_80317C2:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #8
	mov r3, #0x10
	mov r5, #8
	bl sub_80315B8
	bl table_GetCurrentEntryHeader_8031760
	add r0, r0, r1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_80317C2

	thumb_local_start
sub_80317DE:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0xc
	mov r3, #0x10
	mov r5, #0xc
	bl math_pointCrossHalfPlaneTest_8031594
	bl table_GetCurrentEntryHeader_8031760
	add r0, r0, r1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_80317DE

	thumb_local_start
sub_80317FA:
	push {lr}
	mov r0, #1
	bl table_GetCurrentEntryHeader_8031760
	add r0, r0, r1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_80317FA

	thumb_local_start
sub_8031808:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	push {r0}
	mov r0, #1
	bl table_GetCurrentEntryHeader_8031760
	add r0, r0, r1
	lsl r0, r0, #1
	pop {r1}
	ldr r2, [r1]
	asr r2, r3
	sub r0, r0, r2
	asr r0, r0, #1
	mov r1, #2
	lsr r1, r3
	pop {pc}
	thumb_func_end sub_8031808

	thumb_local_start
sub_803182A:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	push {r0}
	mov r0, #1
	bl table_GetCurrentEntryHeader_8031760
	add r0, r0, r1
	mov r1, #8
	asr r1, r3
	sub r0, r0, r1
	lsl r0, r0, #1
	pop {r1}
	ldr r2, [r1]
	asr r2, r3
	add r0, r0, r2
	asr r0, r0, #1
	mov r1, #2
	lsr r1, r3
	pop {pc}
	thumb_func_end sub_803182A

	thumb_local_start
sub_8031852:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	push {r0}
	mov r0, #1
	bl table_GetCurrentEntryHeader_8031760
	add r0, r0, r1
	lsl r0, r0, #1
	pop {r1}
	ldr r2, [r1,#4]
	asr r2, r3
	sub r0, r0, r2
	asr r0, r0, #1
	mov r1, #2
	lsr r1, r3
	pop {pc}
	thumb_func_end sub_8031852

	thumb_local_start
sub_8031874:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	push {r0}
	mov r0, #1
	bl table_GetCurrentEntryHeader_8031760
	add r0, r0, r1
	mov r1, #8
	asr r1, r3
	sub r0, r0, r1
	lsl r0, r0, #1
	pop {r1}
	ldr r2, [r1,#4]
	asr r2, r3
	add r0, r0, r2
	asr r0, r0, #1
	mov r1, #2
	lsr r1, r3
	pop {pc}
	thumb_func_end sub_8031874

// symdb: Latches the halfword at the current text-script pointer into the chatbox state (word_2013944), advances the script pointer by 4, and resets two per-line counters/positions to 0xFE.
// symdb: void sub_803189C(u32* scriptPtr) // r0 in: pointer to a word in the script stream; no outputs;
// symdb: clobbers r0, r1, r5 and flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chatbox_loadScriptWordAndResetScroll_803189C.yaml
	thumb_local_start
chatbox_loadScriptWordAndResetScroll_803189C:
	ldr r5, off_8031994 // =dword_2013940 
	ldr r1, [r0]
	strh r1, [r5,#0x4] // (word_2013944 - 0x2013940)
	add r0, #4
	str r0, [r5]
	mov r0, #0xfe
	strb r0, [r5,#0x6] // (byte_2013946 - 0x2013940)
	strb r0, [r5,#0x7] // (byte_2013947 - 0x2013940)
	mov pc, lr
	.byte 0, 0
	thumb_func_end chatbox_loadScriptWordAndResetScroll_803189C

// symdb: Find the layer-region record covering an object's cell and height, and run its kind's handler.
// symdb: (r0 = object) -> records the object at dword_200F3D0; cell = sub_80316F8, first entry =
// symdb: sub_8030B1E; for each entry of that cell whose record {s8 top; u8; u8 height; u8 kind} spans the
// symdb: object's Y (+0xA), stores the record at [dword_2013940+0x14] and calls the kind's handler; r0 =
// symdb: 2 if none matched, else the handler's r0; r4-r9, r12 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/checkLayerPriority_80318b0.yaml
	thumb_func_start checkLayerPriority_80318b0
checkLayerPriority_80318b0:
	push {r4-r7,lr}
	mov r1, r8
	mov r2, r9
	mov r3, r12
	push {r1-r3}
	ldr r5, off_8031994 // =dword_2013940 
	ldr r2, off_8031910 // =dword_200F3D0 
	str r0, [r2]
	bl getOWObjectGridCellIndex_80316F8
	bl findFirstEntryWithId_8030B1E
	cmp r2, #0
	beq loc_8031904
	.balign 4, 0
loc_80318CC: .align 1, 0
	ldrh r4, [r2]
	cmp r1, r4
	bne loc_8031904
	ldrh r7, [r2,#2]
	ldr r4, [r5]
	add r7, r7, r4
	mov r4, #0
	ldrsb r4, [r7,r4]
	mov r6, #0xa
	ldrsh r6, [r0,r6]
	cmp r6, r4
	blt loc_80318EE
	ldrb r3, [r7,#2]
	add r4, r4, r3
	cmp r6, r4
	bgt loc_80318EE
	b loc_80318F2
loc_80318EE: .align 1, 0
	add r2, #4
	b loc_80318CC
loc_80318F2: .align 1, 0
	str r7, [r5,#0x14] // (dword_2013954 - 0x2013940)
	ldrb r6, [r7,#3]
	lsl r6, r6, #2
	ldr r4, off_8031914 // =dword_8031918 
	add r4, r4, r6
	ldr r4, [r4]
	mov lr, pc
	bx r4
	b loc_8031906
loc_8031904: .align 1, 0
	mov r0, #2
loc_8031906: .align 1, 0
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
off_8031910:
	.word dword_200F3D0
off_8031914:
	.word dword_8031918
dword_8031918:
	.word NULL
	.word sub_803199E+1
	.word sub_80319B6+1
	.word sub_80319CE+1
	.word sub_80319E6+1
	.word NULL
	.word NULL
	.word NULL
	.word NULL
	.word sub_80319FE+1
	.word sub_8031A16+1
	.word sub_8031A2E+1
	.word sub_8031A46+1
	.word NULL
	.word NULL
	.word NULL
	.word NULL
	.word sub_8031A5E+1
	.word NULL
	.word NULL
	.word NULL
	.word NULL
	.word NULL
	.word NULL
	.word NULL
	.word NULL
	thumb_func_end checkLayerPriority_80318b0

// symdb: Loads the address of a state/word from RAM into r5 and returns a small mode id (3 for selector 1, otherwise 2) for the caller to act on.
// symdb: int sub_8031980(int selector); /* returns 3 if selector==1 else 2; also sets r5 =
// symdb: &dword_2013940; flags: nz from result, c/v from cmp with 1 */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031980.yaml
	thumb_local_start
sub_8031980:
	push {lr}
	ldr r5, off_8031994 // =dword_2013940 
	cmp r0, #1
	beq loc_803198A
	b loc_803198E
loc_803198A:
	mov r0, #3
	pop {pc}
loc_803198E:
	mov r0, #2
	pop {pc}
	.balign 4, 0
off_8031994:
	.word dword_2013940
	thumb_func_end sub_8031980

	thumb_local_start
sub_8031998:
	push {lr}
	mov r0, #0
	pop {pc}
	thumb_func_end sub_8031998

	thumb_local_start
sub_803199E:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #4
	mov r4, #0
	mov r3, #4
	mov r5, #0x10
	bl math_pointCrossHalfPlaneTest_8031594
	bl sub_8031980
	pop {pc}
	thumb_func_end sub_803199E

	thumb_local_start
sub_80319B6:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #8
	mov r4, #0
	mov r3, #8
	mov r5, #0x10
	bl sub_80315B8
	bl sub_8031980
	pop {pc}
	thumb_func_end sub_80319B6

	thumb_local_start
sub_80319CE:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #8
	mov r3, #0x10
	mov r5, #8
	bl sub_80315B8
	bl sub_8031980
	pop {pc}
	thumb_func_end sub_80319CE

	thumb_local_start
sub_80319E6:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0xc
	mov r3, #0x10
	mov r5, #0xc
	bl math_pointCrossHalfPlaneTest_8031594
	bl sub_8031980
	pop {pc}
	thumb_func_end sub_80319E6

	thumb_local_start
sub_80319FE:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0x10
	mov r3, #0x10
	mov r5, #0
	bl sub_8031570
	bl sub_8031980
	pop {pc}
	thumb_func_end sub_80319FE

	thumb_local_start
sub_8031A16:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0
	mov r3, #0x10
	mov r5, #0x10
	bl math_pointCrossHalfPlaneTest_8031594
	bl sub_8031980
	pop {pc}
	thumb_func_end sub_8031A16

	thumb_local_start
sub_8031A2E:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0
	mov r3, #0x10
	mov r5, #0x10
	bl sub_80315B8
	bl sub_8031980
	pop {pc}
	thumb_func_end sub_8031A2E

	thumb_local_start
sub_8031A46:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0x10
	mov r3, #0x10
	mov r5, #0
	bl math_pointLeftOfLineTest_80315DC
	bl sub_8031980
	pop {pc}
	thumb_func_end sub_8031A46

// symdb: Trivial one-line wrapper that invokes sub_8031980 with argument 1.
// symdb: void sub_8031A5E(void); // lr only; passes through r0, r5 and NZCV from sub_8031980
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031A5E.yaml
	thumb_local_start
sub_8031A5E:
	push {lr}
	mov r0, #1
	bl sub_8031980
	pop {pc}
	thumb_func_end sub_8031A5E

// symdb: Reads one 32-bit entry from an overworld script/data stream into object 55's value field, advances the stream pointer, and resets its two sentinel bytes to 0xFE.
// symdb: void overworldObject55_ReadStreamEntry(u32* stream) // r0 in: pointer to the entry to consume;
// symdb: no register outputs, flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/overworldObject55_ReadStreamEntry_8031A68.yaml
	thumb_local_start
overworldObject55_ReadStreamEntry_8031A68:
	ldr r5, off_8031B90 // =dword_2013920 
	ldr r1, [r0]
	strh r1, [r5,#0x4] // (word_2013924 - 0x2013920)
	add r0, #4
	str r0, [r5]
	mov r0, #0xfe
	strb r0, [r5,#0x6] // (byte_2013926 - 0x2013920)
	strb r0, [r5,#0x7] // (byte_2013927 - 0x2013920)
	mov pc, lr
	thumb_func_end overworldObject55_ReadStreamEntry_8031A68

	thumb_func_start checkCoordinateTrigger_8031a7a
checkCoordinateTrigger_8031a7a: // (coords: * ?) -> ?
	push {r4-r7,lr}
	mov r3, r8
	mov r4, r9
	mov r5, r12
	push {r3-r5}
	ldr r5, off_8031B90 // =dword_2013920 
	ldr r2, off_8031B08 // =dword_200F3D0 
	str r0, [r2]
	bl getOWObjectGridCellIndex_80316F8
	bl findFirstEntryWithId_8030B1E
	cmp r2, #NULL
	beq loc_8031AF6
loc_8031A96:
	.align 1, 0
	ldrh r4, [r2]
	cmp r1, r4
	bne loc_8031AF6
	ldrh r7, [r2,#2]
	ldr r4, [r5]
	add r7, r7, r4
	mov r4, #0
	ldrsb r4, [r7,r4]
	mov r6, #0xa
	ldrsh r6, [r0,r6]
	cmp r6, r4
	blt loc_8031AB8
	ldrb r3, [r7,#2]
	add r4, r4, r3
	cmp r6, r4
	bgt loc_8031AB8
	b loc_8031ABC
loc_8031AB8:
	.align 1, 0
	add r2, #4
	b loc_8031A96
loc_8031ABC:
	.align 1, 0
	str r7, [r5,#0x14] // (dword_2013934 - 0x2013920)
	ldrb r6, [r7,#3]
	mov r12, r6
	lsl r6, r6, #2
	ldr r4, off_8031B0C // =jt_8031B10 
	add r4, r4, r6
	ldr r4, [r4]
	push {r0-r2}
	mov lr, pc
	bx r4
	mov r3, r0
	tst r0, r0
	pop {r0-r2}
	beq loc_8031AB8
	mov r0, r3
	mov r1, r3
	mov r2, r12
	cmp r0, #0xe
	bgt loc_8031AFC
	push {r0-r2}
	ldr r1, dword_8031B78 // =0x16ef 
	add r0, r0, r1
	mov r0, r0
	bl TestEventFlag // (flag: u16) -> !zf
	pop {r0-r2}
	bne loc_8031AFC
	mov r0, #0
	b loc_8031AFC
loc_8031AF6:
	.align 1, 0
	mov r0, #0
	mov r1, #0
	mov r2, #0
loc_8031AFC:
	.align 1, 0
	pop {r3-r5}
	mov r8, r3
	mov r9, r4
	mov r12, r5
	pop {r4-r7,pc}
	.balign 4, 0x00
off_8031B08:
	.word dword_200F3D0
off_8031B0C:
	.word jt_8031B10
jt_8031B10:
	.word 0x0
	.word sub_8031B9A+1 // 0x01
	.word text_setupTextboxAndStartPrint_8031BB2+1 // 0x02
	.word textbox_StepAndRefreshWindow_8031BCA+1 // 0x03
	.word sub_8031BE2+1 // 0x04
	.word 0x0 // 0x05
	.word 0x0 // 0x06
	.word 0x0 // 0x07
	.word 0x0 // 0x08
	.word sub_8031BFA+1 // 0x09
	.word sub_8031C12+1 // 0x0a
	.word sub_8031C2A+1 // 0x0b
	.word sub_8031C42+1 // 0x0c
	.word 0x0 // 0x0d
	.word 0x0 // 0x0e
	.word 0x0 // 0x0f
	.word 0x0 // 0x10
	.word sub_8031C5A+1 // 0x11
	.word sub_8031C5A+1 // 0x12
	.word sub_8031C5A+1 // 0x13
	.word sub_8031C5A+1 // 0x14
	.word sub_8031C5A+1 // 0x15
	.word sub_8031C64+1 // 0x16
	.word sub_8031C7C+1 // 0x17
	.word sub_8031C94+1 // 0x18
	.word sub_8031CAC+1 // 0x19
dword_8031B78:
	.word 0x16EF
	thumb_func_end checkCoordinateTrigger_8031a7a

// symdb: With r0 == 1, return byte 1 of the structure at [[dword_2013920] + 0x14]; otherwise 0.
// symdb: (r0 = query) -> r0 = byte or 0; r5 = object table, r2 = structure (as the original)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8031B7C.yaml
	thumb_local_start
sub_8031B7C:
	ldr r5, off_8031B90 // =dword_2013920 
	cmp r0, #1
	beq loc_8031B84
	b loc_8031B8A
loc_8031B84:
	ldr r2, [r5,#0x14] // (dword_2013934 - 0x2013920)
	ldrb r0, [r2,#1]
	mov pc, lr
loc_8031B8A:
	mov r0, #0
	mov pc, lr
	.balign 4, 0
off_8031B90:
	.word dword_2013920
	thumb_func_end sub_8031B7C

	thumb_local_start
sub_8031B94:
	push {lr}
	mov r0, #0
	pop {pc}
	thumb_func_end sub_8031B94

	thumb_local_start
sub_8031B9A:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #4
	mov r4, #0
	mov r3, #4
	mov r5, #0x10
	bl math_pointCrossHalfPlaneTest_8031594
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031B9A

// symdb: Standard three-step textbox setup — initialise textbox state, open the message window box, then begin printing the text.
// symdb: void text_setupTextboxAndStartPrint(r0 arg0, r5 arg5); // returns to caller with
// symdb: r0/r2/r3/r4/r5/r6/r7/flags as left by sub_8031B7C
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/text_setupTextboxAndStartPrint_8031BB2.yaml
	thumb_local_start
text_setupTextboxAndStartPrint_8031BB2:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #8
	mov r4, #0
	mov r3, #8
	mov r5, #0x10
	bl sub_80315B8
	bl sub_8031B7C
	pop {pc}
	thumb_func_end text_setupTextboxAndStartPrint_8031BB2

// symdb: Advances the text engine by one step, then blits the affected window region and refreshes the text box display.
// symdb: void textbox_StepAndRefreshWindow(void) — takes context in r0/r5 for the text-engine step;
// symdb: returns final callee register/flag state (r0,r2-r7,nzcv) unchanged to caller
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/textbox_StepAndRefreshWindow_8031BCA.yaml
	thumb_local_start
textbox_StepAndRefreshWindow_8031BCA:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #8
	mov r3, #0x10
	mov r5, #8
	bl sub_80315B8
	bl sub_8031B7C
	pop {pc}
	thumb_func_end textbox_StepAndRefreshWindow_8031BCA

// symdb: Runs a three-call setup/update sequence, passing fixed tile parameters (0, 0x10, 0xC, 0xC) to the middle call.
// symdb: void sub_8031BE2(int r0, void* r5); // calls sub_803172E(r0,r5), sub_8031594(r0, 0, 0x10, 0xC,
// symdb: 0xC), then sub_8031B7C(r0, r5); returns whatever the last callee leaves in r0/r3-r7 and flags
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031BE2.yaml
	thumb_local_start
sub_8031BE2:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0xc
	mov r3, #0x10
	mov r5, #0xc
	bl math_pointCrossHalfPlaneTest_8031594
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031BE2

// symdb: Runs a fixed three-step sequence, forwarding caller arguments to sub_803172E, then calling sub_8031570 with fixed args (0, 0x10, 0x10, 0) and finally sub_8031B7C
// symdb: void sub_8031BFA(regs r0, r5) — returns to caller via pop {pc}; all register results and NZCV
// symdb: flags are whatever sub_8031B7C leaves behind
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031BFA.yaml
	thumb_local_start
sub_8031BFA:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0x10
	mov r3, #0x10
	mov r5, #0
	bl sub_8031570
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031BFA

	thumb_local_start
sub_8031C12:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0
	mov r3, #0x10
	mov r5, #0x10
	bl math_pointCrossHalfPlaneTest_8031594
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031C12

// symdb: Runs a fixed three-call helper chain: an init/prepare step on the context, a setup call with hardcoded arguments (1, 0x10, 1, 0x10), and a final update/refresh step.
// symdb: void sub_8031C2A(u32 a /*r0*/, u32 ctx /*r5*/); // only r0 and r5 are meaningfully consumed;
// symdb: everything the caller sees after return is whatever sub_8031B7C leaves in r0-r7 and the NZCV
// symdb: flags
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031C2A.yaml
	thumb_local_start
sub_8031C2A:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #1
	mov r4, #1
	mov r3, #0x10
	mov r5, #0x10
	bl sub_80315B8
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031C2A

// symdb: Thin battle-side wrapper that calls helper sub_803172E, then invokes sub_80315DC with a fixed parameter block (0, 14, 14, 0) and passes its results on to sub_8031B7C.
// symdb: void sub_8031C42(int r0, int r5) // r0/r5 forwarded to sub_803172E; returns whatever sub_8031B7C
// symdb: leaves in r0/r2/r3/r4/r5 and NZCV
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031C42.yaml
	thumb_local_start
sub_8031C42:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0xe
	mov r3, #0xe
	mov r5, #0
	bl math_pointLeftOfLineTest_80315DC
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031C42

// symdb: Call sub_8031B7C with r0 = 1 and return its results.
// symdb: () -> as sub_8031B7C(1)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8031C5A.yaml
	thumb_local_start
sub_8031C5A:
	push {lr}
	mov r0, #1
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031C5A

	thumb_local_start
sub_8031C64:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #2
	mov r4, #0
	mov r3, #2
	mov r5, #0x10
	bl math_pointCrossHalfPlaneTest_8031594
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031C64

// symdb: Thin battle-mode wrapper that calls sub_803172E with the caller's args, invokes sub_80315B8 with the fixed parameters (14, 14, 0, 16), then calls sub_8031B7C to finish a short setup sequence.
// symdb: void sub_8031C7C(int r0, int r5); /* tail-ish: returns whatever the last callee leaves in r0,
// symdb: r2-r7 and NZCV */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031C7C.yaml
	thumb_local_start
sub_8031C7C:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0xe
	mov r4, #0
	mov r3, #0xe
	mov r5, #0x10
	bl sub_80315B8
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031C7C

// symdb: Runs a fixed three-call setup sequence on an object (pointer in r0), then falls straight back to this function's own caller, passing everything through.
// symdb: Next sub_8031C94(void) /* in: r0 (object ptr), r5, lr; out: flags nzcv and r0-r7,lr all passed
// symdb: through from the last callee */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_8031C94.yaml
	thumb_local_start
sub_8031C94:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #2
	mov r3, #0x10
	mov r5, #2
	bl sub_80315B8
	bl sub_8031B7C
	pop {pc}
	thumb_func_end sub_8031C94

// symdb: Computes the target's relative position, then runs a fixed-point half-plane (cross-area) test against a hard-coded test point/normal, and finally calls sub_8031B7C.
// symdb: void sub_8031CAC(void);  // clobbers r2,r3,r4,r6,r7; touches flags N,Z,C,V
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8031CAC.yaml
	thumb_local_start
sub_8031CAC:
	push {lr}
	bl battle_calcRelPosToTarget_803172E
	mov r2, #0
	mov r4, #0xe
	mov r3, #0x10
	mov r5, #0xe
	bl math_pointCrossHalfPlaneTest_8031594
	bl sub_8031B7C
	// <endpool>
	pop {pc}
	thumb_func_end sub_8031CAC

/*For debugging purposes, connect comment at any range!*/
