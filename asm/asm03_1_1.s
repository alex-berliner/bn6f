
	thumb_func_start sub_80385F0
sub_80385F0:
	push {r4-r7,lr}
	ldr r5, off_8038618 // =byte_2011E40
	// memBlock
	mov r0, r5
	// size
	mov r1, #0x10
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r1, r10
	ldr r1, [r1,#oToolkit_MainJumptableIndexPtr]
	mov r0, #0xc
	strb r0, [r1]
	pop {r4-r7,pc}
	thumb_func_end sub_80385F0

	thumb_local_start
sub_8038606:
	push {r4-r7,lr}
	ldr r5, off_8038618 // =byte_2011E40
	ldr r0, off_803861C // =off_8038620
	ldrb r1, [r5]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_8038618:
	.word byte_2011E40
off_803861C:
	.word off_8038620
off_8038620:
	.word sub_8038630+1
	.word sub_8038674+1
	.word sub_803868C+1
	.word sub_80386B2+1
	thumb_func_end sub_8038606

	thumb_local_start
sub_8038630:
	push {r4-r7,lr}
	bl chatbox_8040818
	mov r0, #0xd
	bl toolkit_applyOverlayPalette_80015FC
	ldr r0, dword_8038670 // =0x1340
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()
	bl resetAllGraphicsState_8005F40
	bl runSetupStepAndClearWorkArea_8005F6C
	bl sprite_initBattleFadeGfxState_80027C4
	bl initGfx_80386CC
	mov r0, #0x63
	bl music_80005F2 // (bg_music_indicator: u8) -> ()
	mov r0, #8
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #4
	strb r0, [r5]
	pop {r4-r7,pc}
	.balign 4, 0
dword_8038670:
	.word 0x1340
	thumb_func_end sub_8038630

	thumb_local_start
sub_8038674:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq locret_8038684
	ldr r0, off_8038688 // =0xb4
	strh r0, [r5,#4]
	mov r0, #8
	strb r0, [r5]
locret_8038684:
	pop {r4-r7,pc}
	.balign 4, 0
off_8038688:
	.word 0xB4
	thumb_func_end sub_8038674

	thumb_local_start
sub_803868C:
	push {r4-r7,lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	blt loc_8038698
	strh r0, [r5,#4]
	b locret_80386B0
loc_8038698:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_Pressed]
	mov r1, #0xb
	tst r1, r0
	beq locret_80386B0
	mov r0, #0xc
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0xc
	strb r0, [r5]
locret_80386B0:
	pop {r4-r7,pc}
	thumb_func_end sub_803868C

	thumb_local_start
sub_80386B2:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq locret_80386C4
	ldr r0, off_80386C8 // =0x40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl call_803D1AC // () -> void
locret_80386C4:
	pop {r4-r7,pc}
	.balign 4, 0
off_80386C8:
	.word 0x40
	thumb_func_end sub_80386B2

	thumb_local_start
initGfx_80386CC:
	push {r4-r7,lr}
	bl zeroFillVRAM // () -> ()
	bl ZeroFillGFX30025c0
	// initRefs
	ldr r0, off_80386E0 // =initRefs_80386E4
	bl decompAndCopyData // (u32 *initRefs) -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_80386E0:
	.word initRefs_80386E4
initRefs_80386E4:
	.word NULL
byte_80386E8:
	.byte 0x6, 0x0, 0x0, 0x0, 0x6, 0x1, 0x0, 0x0, 0x6, 0x2, 0x0, 0x0, 0x6, 0x3, 0x0, 0x0, 0x6
	.byte 0x4, 0x0, 0x0, 0xFF, 0xFF, 0xFF, 0xFF
byte_8038700:
	.byte 0x80, 0x42, 0x82, 0x42, 0x84, 0x42, 0x86, 0x42, 0x88
	.byte 0x42, 0x8A, 0x42, 0x8C, 0x42, 0x8E, 0x42, 0x90, 0x42
	.byte 0x92, 0x42, 0x94, 0x42, 0x96, 0x42, 0x98, 0x42, 0x9A
	.byte 0x42, 0x9C, 0x42, 0x9E, 0x42, 0xA0, 0x42, 0xA2, 0x42
	.byte 0xA4, 0x42, 0xA6, 0x42, 0xA8, 0x42, 0xAA, 0x42, 0xAC
	.byte 0x42, 0x81, 0x42, 0x83, 0x42, 0x85, 0x42, 0x87, 0x42
	.byte 0x89, 0x42, 0x8B, 0x42, 0x8D, 0x42, 0x8F, 0x42, 0x91
	.byte 0x42, 0x93, 0x42, 0x95, 0x42, 0x97, 0x42, 0x99, 0x42
	.byte 0x9B, 0x42, 0x9D, 0x42, 0x9F, 0x42, 0xA1, 0x42, 0xA3
	.byte 0x42, 0xA5, 0x42, 0xA7, 0x42, 0xA9, 0x42, 0xAB, 0x42
	.byte 0xAD, 0x42
byte_803875C:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=iPalette3001B60 index=0x00 num_pals=0x0B
	gfx_anim_data data=0x80004210 delay=0x00000006
	gfx_anim_data data=0x80000000 delay=0x00000006
	gfx_anim_end
	gfx_anim_data data=0x00000008 delay=0x03001750
	gfx_anim_data data=0xFF0C010C delay=0x80004210
	gfx_anim_data data=0x00000006 delay=0x80000000
	gfx_anim_data data=0x00000006 delay=0x00000000
	gfx_anim_data data=0x00000008 delay=0x03001B60
	gfx_anim_data data=0xFF0B000C delay=0x80004210
	gfx_anim_data data=0x00000004 delay=0x80000000
	gfx_anim_data data=0x0000000C delay=0x80004210
	gfx_anim_data data=0x00000004 delay=0x80000000
	gfx_anim_data data=0x0000000C delay=0x00000000
	gfx_anim_data data=0x00000008 delay=0x03001750
	gfx_anim_data data=0xFF0C010C delay=0x80004200
	gfx_anim_data data=0x00000004 delay=0x80000000
	gfx_anim_data data=0x0000000C delay=0x80004210
	gfx_anim_data data=0x00000004 delay=0x80000000
	gfx_anim_data data=0x0000000C delay=0x00000000

byte_80387FC:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=iPalette3001B60 index=0x00 num_pals=0x0B
	gfx_anim_data data=0x80003DEF delay=0x0000000C
	gfx_anim_data data=0x800039CE delay=0x0000000C
	gfx_anim_data data=0x800035AD delay=0x0000000C
	gfx_anim_data data=0x8000318C delay=0x0000000C
	gfx_anim_data data=0x80002D6B delay=0x0000000C
	gfx_anim_data data=0x8000294A delay=0x0000000C
	gfx_anim_data data=0x80002529 delay=0x0000000C
	gfx_anim_data data=0x80002108 delay=0x0000000C
	gfx_anim_data data=0x80001CE7 delay=0x0000000C
	gfx_anim_data data=0x800018C6 delay=0x0000000C
	gfx_anim_data data=0x800014A5 delay=0x0000000C
	gfx_anim_data data=0x80001084 delay=0x0000000C
	gfx_anim_data data=0x80000C63 delay=0x0000000C
	gfx_anim_data data=0x80000842 delay=0x0000000C
	gfx_anim_data data=0x80000421 delay=0x0000000C
	gfx_anim_data data=0x80000000 delay=0x0000000C
	gfx_anim_end

byte_803888C:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=iPallete3001750 index=0x01 num_pals=0x0C
	gfx_anim_data data=0x80003DEF delay=0x0000000C
	gfx_anim_data data=0x800039CE delay=0x0000000C
	gfx_anim_data data=0x800035AD delay=0x0000000C
	gfx_anim_data data=0x8000318C delay=0x0000000C
	gfx_anim_data data=0x80002D6B delay=0x0000000C
	gfx_anim_data data=0x8000294A delay=0x0000000C
	gfx_anim_data data=0x80002529 delay=0x0000000C
	gfx_anim_data data=0x80002108 delay=0x0000000C
	gfx_anim_data data=0x80001CE7 delay=0x0000000C
	gfx_anim_data data=0x800018C6 delay=0x0000000C
	gfx_anim_data data=0x800014A5 delay=0x0000000C
	gfx_anim_data data=0x80001084 delay=0x0000000C
	gfx_anim_data data=0x80000C63 delay=0x0000000C
	gfx_anim_data data=0x80000842 delay=0x0000000C
	gfx_anim_data data=0x80000421 delay=0x0000000C
	gfx_anim_data data=0x80000000 delay=0x0000000C
	gfx_anim_end

byte_803891C:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=iPalette3001B60 index=0x00 num_pals=0x0B
	gfx_anim_data data=0x80000002 delay=0x00000001
	gfx_anim_data data=0x80000004 delay=0x00000001
	gfx_anim_data data=0x80000006 delay=0x00000001
	gfx_anim_data data=0x80000008 delay=0x00000001
	gfx_anim_data data=0x8000000A delay=0x00000001
	gfx_anim_data data=0x8000042C delay=0x00000001
	gfx_anim_data data=0x8000084E delay=0x00000001
	gfx_anim_data data=0x80000C70 delay=0x00000001
	gfx_anim_data data=0x80001090 delay=0x00000001
	gfx_anim_data data=0x800014B0 delay=0x00000001
	gfx_anim_data data=0x800018D0 delay=0x00000001
	gfx_anim_data data=0x80002110 delay=0x00000001
	gfx_anim_data data=0x80002950 delay=0x00000001
	gfx_anim_data data=0x80003190 delay=0x00000001
	gfx_anim_data data=0x800039D0 delay=0x00000001
	gfx_anim_data data=0x80004210 delay=0x00000001
	gfx_anim_end

byte_80389AC:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=iPallete3001750 index=0x01 num_pals=0x0C
	gfx_anim_data data=0x80000002 delay=0x00000001
	gfx_anim_data data=0x80000004 delay=0x00000001
	gfx_anim_data data=0x80000006 delay=0x00000001
	gfx_anim_data data=0x80000008 delay=0x00000001
	gfx_anim_data data=0x8000000A delay=0x00000001
	gfx_anim_data data=0x8000042C delay=0x00000001
	gfx_anim_data data=0x8000084E delay=0x00000001
	gfx_anim_data data=0x80000C70 delay=0x00000001
	gfx_anim_data data=0x80001090 delay=0x00000001
	gfx_anim_data data=0x800014B0 delay=0x00000001
	gfx_anim_data data=0x800018D0 delay=0x00000001
	gfx_anim_data data=0x80002110 delay=0x00000001
	gfx_anim_data data=0x80002950 delay=0x00000001
	gfx_anim_data data=0x80003190 delay=0x00000001
	gfx_anim_data data=0x800039D0 delay=0x00000001
	gfx_anim_data data=0x80004210 delay=0x00000001
	gfx_anim_end

byte_8038A3C:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=iPalette3001B60 index=0x00 num_pals=0x0B
	gfx_anim_data data=0x80004210 delay=0x00000003
	gfx_anim_end
	gfx_anim_data data=0x00000008 delay=0x03001750
	gfx_anim_data data=0xFF0C010C delay=0x80004210
	gfx_anim_data data=0x00000003 delay=0x00000000

byte_8038A6C:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=iPalette3001B60 index=0x00 num_pals=0x0B
	gfx_anim_data data=0x80000000 delay=0x00000003
	gfx_anim_end

byte_8038A84:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=iPallete3001750 index=0x01 num_pals=0x0C
	gfx_anim_data data=0x80000000 delay=0x00000003
	gfx_anim_end

	thumb_func_end initGfx_80386CC

	thumb_func_start sub_8038A9C
sub_8038A9C:
	push {lr}
	bl GetTitleScreenIconCount // () -> (u8, u16)
	ldr r2, dword_8038ACC // =0xf6
	and r1, r2
	cmp r1, r2
	bne loc_8038ABC
	// memBlock
	ldr r0, off_8038B00 // =byte_2011E40
	// size
	mov r1, #0x10
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, r10
	ldr r0, [r0,#oToolkit_MainJumptableIndexPtr]
	mov r1, #0xc
	strb r1, [r0]
	b locret_8038AC6
loc_8038ABC:
	ldr r0, off_8038AC8 // =0x40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl call_803D1AC // () -> void
locret_8038AC6:
	pop {pc}
	.balign 4, 0
off_8038AC8:
	.word 0x40
dword_8038ACC:
	.word 0xF6
	thumb_func_end sub_8038A9C

	thumb_func_start cb_8038AD0
cb_8038AD0:
	push {lr}
	ldr r5, off_8038B00 // =byte_2011E40
	ldr r0, off_8038AF0 // =off_8038AF4
	ldrb r1, [r5]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	bl battle_callAIDispatch_8046818
	bl battleObject_updateSpriteGfxForAll_8046854
	bl entity_runAllUpdateHandlers_80465BC
	bl battle_updateEStructSprites_80465F8 // () -> void
	pop {pc}
	.balign 4, 0
off_8038AF0:
	.word off_8038AF4
off_8038AF4:
	.word battle_initReturnSceneGfx+1
	.word sub_8038B64+1
	.word sub_8038F0C+1
off_8038B00:
	.word byte_2011E40
	thumb_func_end cb_8038AD0

// symdb: Full graphics/hardware reset that reinitializes the scene after (or as) a battle-linked scene (re)starts: clears VRAM/palette/tilemap, resets render info, resets e-struct records, inits chatbox and fade, then stores state 4.
// symdb: (r0 = unused entry state, r5 = pointer to scene state byte, written) -> r0 = 4 stored to [r5];
// symdb: sets up screen for scene rendering
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_initReturnSceneGfx.yaml
	thumb_local_start
battle_initReturnSceneGfx:
	push {lr}
	bl zeroFillVRAM // () -> ()
	bl ZeroFill_byte_3001960
	bl ZeroFillGFX30025c0
	mov r0, #0x14
	bl toolkit_applyOverlayPalette_80015FC
	ldr r0, dword_8038B5C // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()
	bl resetAllGraphicsState_8005F40
	bl runSetupStepAndClearWorkArea_8005F6C
	bl sprite_initBattleFadeGfxState_80027C4
	bl decomp_initGfx_8038F30 // () -> void
	bl sub_8038F74
	bl sub_80468BA
	bl battle_resetEStructRecords_8046664 // () -> void
	ldr r0, off_8038B60 // =byte_80386E8
	bl sub_80467FC
	bl chatbox_8040818
	mov r0, #8
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #4
	strb r0, [r5]
	pop {pc}
	.balign 4, 0
dword_8038B5C:
	.word 0x1F40
off_8038B60:
	.word byte_80386E8
	thumb_func_end battle_initReturnSceneGfx

	thumb_local_start
sub_8038B64:
	push {lr}
	ldr r0, off_8038B74 // =off_8038B78
	ldrb r1, [r5,#1]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {pc}
	.balign 4, 0x00
off_8038B74:
	.word off_8038B78
off_8038B78:
	.word sub_8038B80+1
	.word sub_8038B9C+1
	thumb_func_end sub_8038B64

	thumb_local_start
sub_8038B80:
	push {lr}
	bl IsScreenFadeActive // () -> zf
	beq locret_8038B98
	mov r0, #4
	strb r0, [r5,#1]
	mov r0, #0
	strb r0, [r5,#2]
	mov r0, #0x78
	strh r0, [r5,#4]
	mov r0, #0
	strb r0, [r5,#6]
locret_8038B98:
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_8038B80

	thumb_local_start
sub_8038B9C:
	push {lr}
	ldr r0, off_8038BAC // =off_8038BB0
	ldrb r1, [r5,#2]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {pc}
	.balign 4, 0x00
off_8038BAC:
	.word off_8038BB0
off_8038BB0:
	.word sub_8038BEC+1
	.word sub_8038C10+1
	.word sub_8038C78+1
	.word sub_8038CF4+1
	.word sub_8038D7C+1
	.word sub_8038D94+1
	.word sub_8038DB0+1
	.word loc_8038DC8+1
	.word sub_8038DE0+1
	.word sub_8038E14+1
	.word sub_8038E48+1
	.word sub_8038E5C+1
	.word sub_8038E78+1
	.word sub_8038EAC+1
	.word sub_8038EDC+1
	thumb_func_end sub_8038B9C

	thumb_local_start
sub_8038BEC:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038C08
	mov r0, #4
	strb r0, [r5,#2]
	mov r0, #0xa
	strh r0, [r5,#4]
	ldrb r0, [r5,#6]
	bl sub_8038FB4
	ldr r0, off_8038C0C // =0x700
	str r0, [r5,#8]
locret_8038C08:
	pop {pc}
	.balign 4, 0
off_8038C0C:
	.word 0x700
	thumb_func_end sub_8038BEC

	thumb_local_start
sub_8038C10:
	push {lr}
	ldr r0, [r5,#8]
	ldr r1, off_8038C74 // =0x80
	add r0, r0, r1
	str r0, [r5,#8]
	mov r4, r0
	mov r1, #0
	bl sub_811D66C
	mov r0, r4
	mov r1, #1
	bl sub_811D66C
	mov r0, r4
	mov r1, #2
	bl sub_811D66C
	mov r2, #0
	bl sub_811D634
	mov r2, #1
	bl sub_811D634
	mov r2, #2
	bl sub_811D634
	ldrh r0, [r5,#4]
	cmp r0, #9
	bne loc_8038C54
	push {r0}
	mov r0, #0x8c
	bl PlaySoundEffect
	pop {r0}
loc_8038C54:
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038C6C
	mov r0, #8
	strb r0, [r5,#2]
	bl sub_8039074
	ldr r0, off_8038C70 // =byte_803875C
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	mov r0, #4
	strh r0, [r5,#4]
locret_8038C6C:
	pop {pc}
	.balign 4, 0
off_8038C70:
	.word byte_803875C
off_8038C74:
	.word 0x80
	thumb_func_end sub_8038C10

	thumb_local_start
sub_8038C78:
	push {r4,lr}
	ldr r0, [r5,#8]
	mov r1, #0
	lsl r1, r1, #4
	cmp r0, r1
	ble loc_8038C8C
	ldr r1, off_8038CF0 // =0xc0
	sub r0, r0, r1
	str r0, [r5,#8]
	b loc_8038CA2
loc_8038C8C:
	mov r0, #0
	bl sub_811DBF0
	mov r0, #1
	bl sub_811DBF0
	mov r0, #2
	bl sub_811DBF0
	mov r0, #0
	lsl r0, r0, #4
loc_8038CA2:
	mov r4, r0
	mov r1, #0
	bl sub_811D69C
	mov r0, r4
	mov r1, #1
	bl sub_811D69C
	mov r0, r4
	mov r1, #2
	bl sub_811D69C
	mov r2, #0
	bl sub_811D634
	mov r2, #1
	bl sub_811D634
	mov r2, #2
	bl sub_811D634
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038CE8
	mov r0, #0xc
	strb r0, [r5,#2]
	mov r0, #SOUND_LOG_IN_77
	bl PlaySoundEffect
	ldrb r0, [r5,#6]
	bl sub_8039084
	ldr r0, dword_8038CEC // =0x95
	strh r0, [r5,#4]
locret_8038CE8:
	pop {r4,pc}
	.balign 4, 0
dword_8038CEC:
	.word 0x95
off_8038CF0:
	.word 0xC0
	thumb_func_end sub_8038C78

	thumb_local_start
sub_8038CF4:
	push {lr}
	ldr r0, [r5,#8]
	mov r1, #0
	lsl r1, r1, #4
	cmp r0, r1
	ble loc_8038D08
	ldr r1, off_8038D78 // =0xc0
	sub r0, r0, r1
	str r0, [r5,#8]
	b loc_8038D1E
loc_8038D08:
	mov r0, #0
	bl sub_811DBF0
	mov r0, #1
	bl sub_811DBF0
	mov r0, #2
	bl sub_811DBF0
	mov r0, #0
	lsl r0, r0, #4
loc_8038D1E:
	mov r4, r0
	mov r1, #0
	bl sub_811D69C
	mov r0, r4
	mov r1, #1
	bl sub_811D69C
	mov r0, r4
	mov r1, #2
	bl sub_811D69C
	mov r2, #0
	bl sub_811D634
	mov r2, #1
	bl sub_811D634
	mov r2, #2
	bl sub_811D634
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038D70
	ldrb r0, [r5,#6]
	add r0, #1
	cmp r0, #5
	blt loc_8038D66
	bl battle_resetEStructRecords_8046664 // () -> void
	mov r0, #0x10
	strb r0, [r5,#2]
	mov r0, #0x14
	strh r0, [r5,#4]
	b locret_8038D70
loc_8038D66:
	strb r0, [r5,#6]
	mov r0, #0
	strb r0, [r5,#2]
	mov r0, #0xa
	strh r0, [r5,#4]
locret_8038D70:
	pop {pc}
	.balign 4, 0
	.word 0x95
off_8038D78:
	.word 0xC0
	thumb_func_end sub_8038CF4

	thumb_local_start
sub_8038D7C:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038D92
	mov r0, #0x14
	strb r0, [r5,#2]
	mov r0, #0x2e
	strh r0, [r5,#4]
	bl sub_8039024
locret_8038D92:
	pop {pc}
	thumb_func_end sub_8038D7C

	thumb_local_start
sub_8038D94:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038DAA
	ldr r0, off_8038DAC // =0x99
	strh r0, [r5,#4]
	mov r0, #0x18
	strb r0, [r5,#2]
	bl sub_80468BA
locret_8038DAA:
	pop {pc}
	.balign 4, 0
off_8038DAC:
	.word 0x99
	thumb_func_end sub_8038D94

	thumb_local_start
sub_8038DB0:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038DDE
	ldr r0, dword_8038DC4 // =0xf
	strh r0, [r5,#4]
	mov r0, #0x1c
	strb r0, [r5,#2]
	pop {pc}
	.balign 4, 0
dword_8038DC4:
	.word 0xF
loc_8038DC8:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038DDE
	mov r0, #0x32
	strh r0, [r5,#4]
	mov r0, #0x20
	strb r0, [r5,#2]
	bl sub_803916C
locret_8038DDE:
	pop {pc}
	thumb_func_end sub_8038DB0

	thumb_local_start
sub_8038DE0:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038E04
	ldr r0, off_8038E10 // =0x100
	bl PlaySoundEffect
	ldr r0, off_8038E08 // =byte_803891C
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	ldr r0, off_8038E0C // =byte_80389AC
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	mov r0, #0x2e
	strh r0, [r5,#4]
	mov r0, #0x24
	strb r0, [r5,#2]
locret_8038E04:
	pop {pc}
	.balign 4, 0
off_8038E08:
	.word byte_803891C
off_8038E0C:
	.word byte_80389AC
off_8038E10:
	.word 0x100
	thumb_func_end sub_8038DE0

	thumb_local_start
sub_8038E14:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038E3A
	ldr r0, off_8038E3C // =byte_80387FC
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	ldr r0, off_8038E40 // =byte_803888C
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	bl battle_resetEStructRecords_8046664 // () -> void
	bl sub_80390D8
	mov r0, #0x28
	strb r0, [r5,#2]
	ldr r0, dword_8038E44 // =0xd6
	strh r0, [r5,#4]
locret_8038E3A:
	pop {pc}
	.balign 4, 0
off_8038E3C:
	.word byte_80387FC
off_8038E40:
	.word byte_803888C
dword_8038E44:
	.word 0xD6
	thumb_func_end sub_8038E14

	thumb_local_start
sub_8038E48:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038E5A
	mov r0, #4
	strh r0, [r5,#4]
	mov r0, #0x2c
	strb r0, [r5,#2]
locret_8038E5A:
	pop {pc}
	thumb_func_end sub_8038E48

	thumb_local_start
sub_8038E5C:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038E72
	bl sub_80390F8
	ldr r0, off_8038E74 // =0x2d
	strh r0, [r5,#4]
	mov r0, #0x30
	strb r0, [r5,#2]
locret_8038E72:
	pop {pc}
	.balign 4, 0
off_8038E74:
	.word 0x2D
	thumb_func_end sub_8038E5C

	thumb_local_start
sub_8038E78:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne locret_8038EA0
	bl sub_8039180
	ldr r0, off_8038EA4 // =byte_80389AC
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	ldr r0, off_8038EA8 // =byte_8038A3C
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	mov r0, #0x34
	strb r0, [r5,#2]
	mov r0, #6
	strh r0, [r5,#4]
	mov r0, #0xd7
	bl PlaySoundEffect
locret_8038EA0:
	pop {pc}
	.balign 4, 0
off_8038EA4:
	.word byte_80389AC
off_8038EA8:
	.word byte_8038A3C
	thumb_func_end sub_8038E78

	thumb_local_start
sub_8038EAC:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	strh r0, [r5,#4]
	bne loc_8038ECE
	bl sub_8038F74
	ldr r0, off_8038ED4 // =byte_8038A6C
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	ldr r0, off_8038ED8 // =byte_8038A84
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	mov r0, #0x38
	strb r0, [r5,#2]
	mov r0, #6
	strh r0, [r5,#4]
loc_8038ECE:
	bl sub_8039198
	pop {pc}
	.balign 4, 0
off_8038ED4:
	.word byte_8038A6C
off_8038ED8:
	.word byte_8038A84
	thumb_func_end sub_8038EAC

	thumb_local_start
sub_8038EDC:
	push {lr}
	ldrh r0, [r5,#4]
	sub r0, #1
	blt loc_8038EE6
	strh r0, [r5,#4]
loc_8038EE6:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_Pressed]
	ldr r1, dword_8038F08 // =0x3ff
	tst r0, r1
	beq loc_8038EFE
	mov r0, #0xc
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #8
	strb r0, [r5]
loc_8038EFE:
	bl sub_8038F9C
	bl sub_8039198
	pop {pc}
	.balign 4, 0
dword_8038F08:
	.word 0x3FF
	thumb_func_end sub_8038EDC

	thumb_local_start
sub_8038F0C:
	push {lr}
	bl sub_8039198
	bl IsScreenFadeActive // () -> zf
	beq locret_8038F2A
	bl call_803D1AC // () -> void
	bl clear_e200AD04 // () -> ()
	bl init_eStartScreenAnimationControl200B1A0_1
	ldr r0, off_8038F2C // =0x40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
locret_8038F2A:
	pop {pc}
	.balign 4, 0
off_8038F2C:
	.word 0x40
	thumb_func_end sub_8038F0C

// () -> void
	thumb_local_start
decomp_initGfx_8038F30:
	push {lr}
	// initRefs
	ldr r0, off_8038F3C // =initRefs_8038F40
	bl decompAndCopyData // (u32 *initRefs) -> void
	pop {pc}
	.balign 4, 0
off_8038F3C:
	.word initRefs_8038F40
initRefs_8038F40:
	.word dword_86BEAE0
	.word unk_30019E0
	.word 0x20

	.word comp_87E4500 + COMPRESSED_PTR_FLAG
	.word 0x6004000
	.word eDecompBuffer2013A00

	.word dword_87E4FE0
	.word unk_30019A0
	.word 0x40

	.word comp_87E5020 + COMPRESSED_PTR_FLAG
	.word unk_2018A00
	.word eDecompBuffer2013A00

	.word NULL
	thumb_func_end decomp_initGfx_8038F30

	thumb_local_start
sub_8038F74:
	push {r4-r7,lr}
	ldr r0, off_8038F8C // =TextScriptCommError873B9E0
	mov r1, #0x28
	ldr r2, off_8038F90 // =eDecompBuffer2013A00
	ldr r3, dword_8038F94 // =0x6005000
	mov r4, #0x20
	mov r5, #2
	ldr r6, off_8038F98 // =dword_86B7AE0
	mov r7, #0
	bl renderTextGfx_8045F8C
	pop {r4-r7,pc}
	.balign 4, 0
off_8038F8C:
	.word TextScriptCommError873B9E0
off_8038F90:
	.word eDecompBuffer2013A00
dword_8038F94:
	.word 0x6005000
off_8038F98:
	.word dword_86B7AE0
	thumb_func_end sub_8038F74

	thumb_local_start
sub_8038F9C:
	push {r4-r7,lr}
	// j
	mov r0, #3
	// i
	mov r1, #8
	// tileBlock32x32
	mov r2, #3
	// tileIds
	ldr r3, off_8038FB0 // =byte_8038700
	mov r4, #0x17
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_8038FB0:
	.word byte_8038700
	thumb_func_end sub_8038F9C

	thumb_local_start
sub_8038FB4:
	push {r4,r7,lr}
	lsl r7, r0, #3
	mov r4, #1
loc_8038FBA:
	ldr r0, off_8038FE0 // =byte_8038FE4
	add r0, r0, r7
	lsl r1, r4, #2
	ldr r2, [r0,r1]
	mov r0, #0x3a
	mov r1, r4
	bl battle_initEmotionTableEntry_8046670
	sub r4, #1
	bge loc_8038FBA
	mov r0, #0x3a
	mov r1, #2
	ldr r2, off_803900C // =byte_8039010
	lsr r7, r7, #1
	ldr r2, [r2,r7]
	bl battle_initEmotionTableEntry_8046670
	pop {r4,r7,pc}
	.balign 4, 0
off_8038FE0:
	.word byte_8038FE4
byte_8038FE4:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2, 0x1, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x3, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x4, 0x1, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x5, 0x1, 0x0
off_803900C:
	.word byte_8039010
byte_8039010:
	.byte 0x4, 0x0, 0x1, 0x0, 0x4, 0x1, 0x1, 0x0, 0x4, 0x2, 0x1, 0x0, 0x4, 0x3, 0x1, 0x0, 0x4
	.byte 0x4, 0x1, 0x0
	thumb_func_end sub_8038FB4

	thumb_local_start
sub_8039024:
	push {r4,lr}
	ldr r2, dword_8039050 // =0x607
	mov r0, #0x3a
	mov r1, #0
	bl battle_initEmotionTableEntry_8046670
	mov r4, #4
loc_8039032:
	mov r0, #0x3a
	ldr r2, off_8039054 // =byte_8039058
	sub r1, r4, #1
	lsl r1, r1, #2
	ldr r2, [r2,r1]
	mov r1, r4
	bl battle_initEmotionTableEntry_8046670
	sub r4, #1
	bgt loc_8039032
	// src
	ldr r0, dest // =comp_82E8470
	// dest
	ldr r1, off_8039070 // =unk_201AA00
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()
	pop {r4,pc}
	.balign 4, 0
dword_8039050:
	.word 0x607
off_8039054:
	.word byte_8039058
byte_8039058:
	.byte 0x6, 0x0, 0x0, 0x0, 0x6, 0x1, 0x0, 0x0, 0x6, 0x2, 0x0, 0x0, 0x6, 0x3, 0x0, 0x0, 0x6
	.byte 0x4, 0x0, 0x0
dest:
	.word comp_82E8470
off_8039070:
	.word unk_201AA00
	thumb_func_end sub_8039024

	thumb_local_start
sub_8039074:
	push {lr}
	mov r0, #0x3a
	mov r1, #3
	mov r2, #2
	bl battle_initEmotionTableEntry_8046670
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_8039074

	thumb_local_start
sub_8039084:
	push {r4,lr}
	mov r4, r0
	lsl r0, r0, #2
	ldr r1, off_80390A8 // =byte_80390AC
	ldr r2, [r1,r0]
	mov r0, #0x3a
	mov r1, #4
	bl battle_initEmotionTableEntry_8046670
	mov r0, r4
	lsl r0, r0, #2
	ldr r1, off_80390C0 // =byte_80390C4
	ldr r2, [r1,r0]
	mov r0, #0x3a
	mov r1, #5
	bl battle_initEmotionTableEntry_8046670
	pop {r4,pc}
	.balign 4, 0
off_80390A8:
	.word byte_80390AC
byte_80390AC:
	.byte 0x1, 0x0, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x1, 0x2, 0x0, 0x0, 0x1, 0x3, 0x0, 0x0, 0x1
	.byte 0x4, 0x0, 0x0
off_80390C0:
	.word byte_80390C4
byte_80390C4:
	.byte 0x3, 0x0, 0x0, 0x0, 0x3, 0x1, 0x0, 0x0, 0x3, 0x2, 0x0, 0x0, 0x3, 0x3, 0x0, 0x0, 0x3
	.byte 0x4, 0x0, 0x0
	thumb_func_end sub_8039084

	thumb_local_start
sub_80390D8:
	push {lr}
	ldr r2, dword_80390F0 // =0x8
	mov r0, #0x3a
	mov r1, #0
	bl battle_initEmotionTableEntry_8046670
	ldr r2, off_80390F4 // =0x108
	mov r0, #0x3a
	mov r1, #1
	bl battle_initEmotionTableEntry_8046670
	pop {pc}
	.balign 4, 0
dword_80390F0:
	.word 0x8
off_80390F4:
	.word 0x108
	thumb_func_end sub_80390D8

	thumb_local_start
sub_80390F8:
	push {r4,lr}
	mov r4, #4
loc_80390FC:
	ldr r2, off_8039138 // =byte_803913C
	lsl r1, r4, #2
	ldr r2, [r2,r1]
	mov r0, #0x3a
	mov r1, #3
	lsl r3, r4, #1
	add r1, r1, r3
	bl battle_initEmotionTableEntry_8046670
	ldr r2, off_8039150 // =byte_8039154
	lsl r1, r4, #2
	ldr r2, [r2,r1]
	mov r0, #0x3a
	mov r1, #3
	lsl r3, r4, #1
	sub r3, #1
	add r1, r1, r3
	bl battle_initEmotionTableEntry_8046670
	cmp r4, #1
	bne loc_8039130
	mov r0, #0x3a
	mov r1, #0xc
	ldr r2, dword_8039168 // =0x50d
	bl battle_initEmotionTableEntry_8046670
loc_8039130:
	sub r4, #1
	bge loc_80390FC
	pop {r4,pc}
	.balign 4, 0
off_8039138:
	.word byte_803913C
byte_803913C:
	.byte 0x9, 0x0, 0x0, 0x0, 0x9, 0x2, 0x0, 0x0, 0x9, 0x4, 0x0, 0x0, 0x9, 0x1, 0x0, 0x0, 0x9
	.byte 0x3, 0x0, 0x0
off_8039150:
	.word byte_8039154
byte_8039154:
	.byte 0xA, 0x0, 0x0, 0x0, 0xA, 0x2, 0x0, 0x0, 0xA, 0x4, 0x0, 0x0, 0xA, 0x1, 0x0
	.byte 0x0, 0xA, 0x3, 0x0, 0x0
dword_8039168:
	.word 0x50D
	thumb_func_end sub_80390F8

	thumb_local_start
sub_803916C:
	push {lr}
	ldr r2, dword_803917C // =0xb
	mov r0, #0x3a
	mov r1, #6
	bl battle_initEmotionTableEntry_8046670
	pop {pc}
	.balign 4, 0
dword_803917C:
	.word 0xB
	thumb_func_end sub_803916C

	thumb_local_start
sub_8039180:
	push {r4-r7,lr}
	// j
	mov r0, #0
	// i
	mov r1, #0xf
	// tileBlock32x32
	mov r2, #2
	// tileIds
	ldr r3, off_8039194 // =unk_2018A00
	mov r4, #0x20
	mov r5, #5
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_8039194:
	.word unk_2018A00
	thumb_func_end sub_8039180

	thumb_local_start
sub_8039198:
	push {lr}
	mov r3, r10
	ldr r3, [r3,#oToolkit_RenderInfoPtr]
	ldrh r0, [r3,#0x14]
	sub r0, #9
	strh r0, [r3,#0x14]
	pop {pc}
	.balign 4, 0x00
byte_80391A8:
	.byte 0x0, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x1, 0x2
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x3, 0x5, 0x5, 0x5, 0x5, 0x4, 0x5, 0x6, 0x7, 0x5, 0x8, 0x9
	.byte 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x10, 0x11, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x12, 0x13, 0x14
	.byte 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25
	.byte 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x2C, 0x2D, 0x2E, 0x2F, 0x30
	.byte 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F, 0x40, 0x41
	.byte 0x42, 0x43, 0x44, 0x45, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5
	.byte 0x5
byte_80392A8:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=unk_3001B80 index=0x00 num_pals=0x0B
	gfx_anim_data data=0x80001084 delay=0x00000002
	gfx_anim_data data=0x80002108 delay=0x00000002
	gfx_anim_data data=0x8000318C delay=0x00000002
	gfx_anim_data data=0x80004210 delay=0x00000002
	gfx_anim_end

byte_80392D8:
	gfx_anim_manual_pal_transform transform_type=0x00000008 ptr5=unk_3001B80 index=0x00 num_pals=0x0B
	gfx_anim_data data=0x8000318C delay=0x00000002
	gfx_anim_data data=0x80002108 delay=0x00000002
	gfx_anim_data data=0x80001084 delay=0x00000002
	gfx_anim_data data=0x80000000 delay=0x00000001
	gfx_anim_end

// TODO This needs investigation. How is it indexing into a compressed asset?
off_8039308:
	gfx_anim_pal_copy dest=unk_3001AE0 size=0x00000020 index=0x01
	gfx_anim_data_ptr ptr=byte_87E672C delay=0x0000001E
	gfx_anim_data_ptr ptr=compSpriteWhiteDot_84E0C4C+0x00 delay=0x00000001
	gfx_anim_data_ptr ptr=compSpriteWhiteDot_84E0C4C+0x20 delay=0x00000001
	gfx_anim_data_ptr ptr=compSpriteWhiteDot_84E0C4C+0x40 delay=0x00000001
	gfx_anim_data_ptr ptr=compSpriteWhiteDot_84E0C4C+0x60 delay=0x00000001
	gfx_anim_data_ptr ptr=compSpriteWhiteDot_84E0C4C+0x80 delay=0x00000001
	gfx_anim_data_ptr ptr=compSpriteWhiteDot_84E0C4C+0xA0 delay=0x00000001
	gfx_anim_end

byte_8039350:
	gfx_anim_play_sound index=0x03
	gfx_anim_data_no_sound delay=0x0000001E
	gfx_anim_data_sound sound_effect8=0x8D delay=0x00000001
	gfx_anim_end

off_8039370:
	gfx_anim_pal_copy dest=unk_30019C0 size=0x00000020 index=0x02
	gfx_anim_data_ptr ptr=dword_87E66EC delay=0x0000000A
	gfx_anim_data_ptr ptr=dword_87E660C delay=0x00000001
	gfx_anim_end

byte_8039390:
	.byte 0x6, 0x0, 0x0, 0xFF, 0x6, 0x1, 0x1, 0xFF, 0x6, 0x2, 0x2, 0xFF, 0x6, 0x3
	.byte 0x3, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
byte_80393A4:
	.byte 0x1, 0x0, 0x0, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0x76, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x19, 0x0
	.byte 0x20, 0x4E, 0x1, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7
	.byte 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x1A, 0x0, 0x20, 0x4E, 0x1, 0x0, 0x0, 0x0
	.byte 0xA, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0
	.byte 0x0, 0x1A, 0xA, 0x20, 0x4E, 0x0, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0, 0x2, 0x0
	.byte 0x0, 0x0, 0x1E, 0x0, 0x20, 0x4E, 0x1, 0x0, 0x0, 0x0, 0x1E, 0x0, 0x0, 0x0, 0x4
	.byte 0x0, 0x0, 0x0, 0x76, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0
	.byte 0x3, 0x0, 0x0, 0x0, 0x19, 0x0, 0xD0, 0x4E, 0x1, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0x1C, 0x80
	.byte 0xD0, 0x4E, 0x1, 0x0, 0x0, 0x0, 0xA, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x7
	.byte 0x0, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0x1C, 0x83, 0xD0, 0x4E, 0x0, 0x0, 0x0, 0x0
	.byte 0x7, 0x0, 0x0, 0x0, 0x5, 0x0, 0x0, 0x0, 0x1C, 0x88, 0xD0, 0x4E, 0x1, 0x0, 0x0
	.byte 0x0, 0x3C, 0x0, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0xD7, 0x0, 0x0, 0x0, 0x3, 0x0
	.byte 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0xFF, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x2
	.byte 0x0, 0x0, 0x0, 0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x20, 0x0, 0x0, 0x0
	.byte 0x1, 0x0, 0x0, 0x0, 0x14, 0x0, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0xD7, 0x0, 0x0
	.byte 0x0, 0x3, 0x0, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0xFF, 0x0, 0x0, 0x0, 0x1, 0x0
	.byte 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xFF
	.byte 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x5, 0x0, 0x0, 0x0
dword_80394CC:
	.word 0x0
byte_80394D0:
	.byte 0x7, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
byte_80394D8:
	.byte 0x1A, 0xA, 0x20, 0x4E, 0x0, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0, 0x1, 0x0
	.byte 0x0, 0x0, 0x1E, 0x0, 0x20, 0x4E, 0x0, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0
	.byte 0x2, 0x0, 0x0, 0x0, 0x1C, 0x83, 0xD0, 0x4E, 0x0, 0x0, 0x0, 0x0, 0x7, 0x0
	.byte 0x0, 0x0, 0x3, 0x0, 0x0, 0x0, 0x1C, 0x88, 0xD0, 0x4E, 0x0, 0x0, 0x0, 0x0
	.byte 0x8, 0x0, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0x1D, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x8, 0x0, 0x0, 0x0, 0x5, 0x0, 0x0, 0x0, 0x1D, 0x1, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x8, 0x0, 0x0, 0x0, 0x6, 0x0, 0x0, 0x0, 0x1D, 0x2
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x0, 0x0, 0x0, 0x7, 0x0, 0x0, 0x0
	.byte 0x1D, 0x3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x0, 0x0, 0x0, 0x8, 0x0
	.byte 0x0, 0x0, 0x1D, 0x4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x0, 0x0, 0x0
	.byte 0x9, 0x0, 0x0, 0x0, 0x1D, 0x5, 0x0, 0x0, 0x2, 0x0, 0x0, 0x0
	thumb_func_end sub_8039198

	thumb_func_start sub_8039570
sub_8039570:
	push {r4-r7,lr}
	mov r4, #0
	mov r6, #0
	b loc_803957E
loc_8039578:
	push {r4-r7,lr}
	mov r4, r0
	mov r6, #1
loc_803957E:
	ldr r5, off_80395E0 // =eS200A290
	// memBlock
	mov r0, r5
	// size
	ldr r1, off_80395A0 // =0x1b0
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r1, r10
	ldr r1, [r1,#oToolkit_MainJumptableIndexPtr]
	mov r0, #0x18
	strb r0, [r1]
	strb r4, [r5,#0x14] // (byte_200A2A4 - 0x200a290)
	strb r6, [r5,#0x17] // (byte_200A2A7 - 0x200a290)
	mov r0, #8
	strh r0, [r5,#0x24] // (word_200A2B4 - 0x200a290)
	mov r0, #0xb
	strh r0, [r5,#0x26] // (word_200A2B6 - 0x200a290)
	pop {r4-r7,pc}
	.balign 4, 0
off_80395A0:
	.word 0x1B0
	thumb_func_end sub_8039570

	thumb_func_start cb_80395A4
cb_80395A4:
	push {r4-r7,lr}
	ldr r5, off_80395E0 // =eS200A290

	ldr r0, off_80395C4 // =off_80395C8
	ldrb r1, [r5, #oS200A290_Index_00]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0

	bl IsCurSubsystemInUse // () -> (bool, !zf)
	bne locret_80395C0
	mov r0, #0xda
	mov r1, #2
	bl battleObject_setupCustomChipCursorState_803C59C
locret_80395C0:
	pop {r4-r7,pc}
	.balign 4, 0
off_80395C4:
	.word off_80395C8
off_80395C8:
  // 0x00
  .word init_textScene+1
  // 0x04
	.word init_videoSystemsReset+1
  // 0x08
	.word sub_8039658+1
  // 0x0C
	.word sub_80399CE+1
  // 0x10
	.word sub_803A690+1
  // 0x14
	.word sub_803B160+1
off_80395E0:
	.word eS200A290
	thumb_func_end cb_80395A4

// symdb: Initializes a dialog/text-driven scene: resets graphics and render info, loads palette slot 0x11, starts music 0x22, sets up the chatbox and text-script buffer, and writes an initial scene-state byte (8 or 0x10).
// symdb: () -> (); stores state byte and 0 via a pointer returned in r5 by a callee; no return value in
// symdb: r0
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/init_textScene.yaml
	thumb_local_start
init_textScene:
	push {r4-r7,lr}
	bl sub_803FA42
	bl chatbox_8040818
	ldr r0, off_803962C // =0x40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()
	mov r0, #0x11
	bl toolkit_applyOverlayPalette_80015FC
	bl resetAllGraphicsState_8005F40
	bl copyData_803B216
	bl sub_803BEC0
	bl sub_803BA28
	mov r0, #0x22
	bl music_80005F2 // (bg_music_indicator: u8) -> ()
	mov r6, #8
	mov r7, #0
	bl sub_803C3E0
	bne loc_8039626
	mov r6, #0x10
	mov r7, #0
loc_8039626:
	strb r6, [r5]
	strb r7, [r5,#1]
	pop {r4-r7,pc}
	.balign 4, 0
off_803962C:
	.word 0x40
	thumb_func_end init_textScene

// symdb: When no screen fade is running, resets the whole video pipeline: clears VRAM and the BG tile buffer, reloads base graphics, re-inits chatbox/start-screen renderers, and blanks DISPCNT.
// symdb: () -> void; returns early via IsScreenFadeActive flags when a fade is active
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/init_videoSystemsReset.yaml
	thumb_local_start
init_videoSystemsReset:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq locret_8039652
	bl zeroFillVRAM // () -> ()
	bl ZeroFillGFX30025c0
	bl copyMemory_8001850
	bl chatbox_8040818
	bl startScreen_init_802F530 // () -> void
	ldr r0, off_8039654 // =0x40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
locret_8039652:
	pop {r4-r7,pc}
	.balign 4, 0
off_8039654:
	.word 0x40
	thumb_func_end init_videoSystemsReset

	thumb_local_start
sub_8039658:
	push {r4-r7,lr}
	ldr r0, off_8039670 // =off_8039674
	ldrb r1, [r5,#1]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	bl entity_runAllUpdateHandlers_80465BC
	bl battle_updateEStructSprites_80465F8 // () -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_8039670:
	.word off_8039674
off_8039674:
	.word sub_8039694+1
	.word sub_803970C+1
	.word sub_8039734+1
	.word sub_80397DC+1
	.word sub_80397F6+1
	.word sub_8039816+1
	.word sub_8039830+1
	.word sub_8039846+1
	thumb_func_end sub_8039658

	thumb_local_start
sub_8039694:
	push {r4-r7,lr}
	bl resetAllGraphicsState_8005F40
	bl ZeroFillGFX30025c0
	ldr r0, dword_8039708 // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()
	bl cleareMemory_802FF2C
	mov r0, #0x11
	bl toolkit_applyOverlayPalette_80015FC
	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	bl copyData_803B216
	bl sub_803C2EC
	bl battle_resetEStructRecords_8046664 // () -> void
	bl chatbox_8040818
	mov r0, #3
	strb r0, [r5,#5]
	ldrb r0, [r5,#0x14]
	tst r0, r0
	bne loc_80396F8
	ldrb r0, [r5,#0x17]
	tst r0, r0
	bne loc_80396E8
	mov r0, #0x1c
	strb r0, [r5,#1]
	mov r0, #0
	strb r0, [r5,#2]
	b locret_8039706
loc_80396E8:
	bl sub_803993A
	ldrb r0, [r5,#4]
	bl sub_803BB2C
	mov r0, #8
	strb r0, [r5,#1]
	b locret_8039706
loc_80396F8:
	bl sub_803993A
	ldrb r0, [r5,#0x14]
	bl sub_803BB2C
	mov r0, #4
	strb r0, [r5,#1]
locret_8039706:
	pop {r4-r7,pc}
	.balign 4, 0
dword_8039708:
	.word 0x1F40
	thumb_func_end sub_8039694

	thumb_local_start
sub_803970C:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803972A
	mov r0, #8
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	beq loc_803972A
	mov r0, #0
	strb r0, [r5,#0x14]
	mov r0, #0
	bl sub_803BB2C
	mov r0, #8
	strb r0, [r5,#1]
loc_803972A:
	bl sub_803B880
	bl sub_803C2F0
	pop {r4-r7,pc}
	thumb_func_end sub_803970C

	thumb_local_start
sub_8039734:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_80397A8
	bl sub_803995C
	cmp r0, #1
	beq loc_8039794
	cmp r0, #2
	beq loc_803974E
	cmp r0, #3
	beq loc_803974E
	b loc_80397A8
loc_803974E:
	mov r0, #SOUND_SELECT_67
	bl PlaySoundEffect
	ldrb r0, [r5,#4]
	cmp r0, #1
	beq loc_803976C
	cmp r0, #2
	beq loc_8039780
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0xc
	strb r0, [r5,#1]
	b loc_80397A8
loc_803976C:
	mov r0, #SOUND_SELECT_67
	bl PlaySoundEffect
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x10
	strb r0, [r5,#1]
	b loc_80397A8
loc_8039780:
	mov r0, #SOUND_SELECT_67
	bl PlaySoundEffect
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x14
	strb r0, [r5,#1]
	b loc_80397A8
loc_8039794:
	mov r0, #SOUND_UNSELECT_68
	bl PlaySoundEffect
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x18
	strb r0, [r5,#1]
	b loc_80397A8
loc_80397A8:
	bl sub_80397BC
	ldrb r0, [r5,#4]
	ldrb r1, [r5,#6]
	cmp r0, r1
	beq locret_80397BA
	add r0, #0
	bl sub_803BB2C
locret_80397BA:
	pop {r4-r7,pc}
	thumb_func_end sub_8039734

	thumb_local_start
sub_80397BC:
	push {r4-r7,lr}
	bl sub_803B880
	bl sub_803C2F0
	mov r0, #0x38
	ldrb r1, [r5,#4]
	mov r2, #0x10
	mul r1, r2
	add r1, #0x1c
	mov r2, #1
	mov r3, #0
	mov r4, #0
	bl sub_803BC02
	pop {r4-r7,pc}
	thumb_func_end sub_80397BC

	thumb_local_start
sub_80397DC:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_80397F0
	bl cleareMemory_802FF2C
	mov r0, #0xc
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_80397F0:
	bl sub_80397BC
	pop {r4-r7,pc}
	thumb_func_end sub_80397DC

	thumb_local_start
sub_80397F6:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_8039810
	bl cleareMemory_802FF2C
	mov r0, #0
	strb r0, [r5,#8]
	strb r0, [r5,#0xa]
	mov r0, #0x10
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_8039810:
	bl sub_80397BC
	pop {r4-r7,pc}
	thumb_func_end sub_80397F6

	thumb_local_start
sub_8039816:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803982A
	bl cleareMemory_802FF2C
	mov r0, #0x14
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_803982A:
	bl sub_80397BC
	pop {r4-r7,pc}
	thumb_func_end sub_8039816

	thumb_local_start
sub_8039830:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_8039840
	bl cleareMemory_802FF2C
	mov r0, #4
	strb r0, [r5]
loc_8039840:
	bl sub_80397BC
	pop {r4-r7,pc}
	thumb_func_end sub_8039830

	thumb_local_start
sub_8039846:
	push {r4-r7,lr}
	ldr r0, off_8039854 // =off_8039858
	ldrb r1, [r5,#2]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
off_8039854:
	.word off_8039858
off_8039858:
	.word sub_8039864+1
	.word sub_8039888+1
	.word sub_80398B0+1
	thumb_func_end sub_8039846

	thumb_local_start
sub_8039864:
	push {r4-r7,lr}
	ldr r0, dword_8039880 // =0x1240
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	mov r0, #1
	strb r0, [r5,#0x17]
	mov r0, #0
	bl sub_803BB7C
	ldr r0, off_8039884 // =byte_80393A4
	str r0, [r5,#0x2c]
	mov r0, #4
	strb r0, [r5,#2]
	pop {r4-r7,pc}
	.balign 4, 0
dword_8039880:
	.word 0x1240
off_8039884:
	.word byte_80393A4
	thumb_func_end sub_8039864

	thumb_local_start
sub_8039888:
	push {r4-r7,lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_Pressed]
	mov r1, #4
	tst r0, r1
	bne loc_803989C
	bl sub_80398DC
	bne locret_80398AE
loc_803989C:
	mov r0, #4
	mov r1, #0xff
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0xd7
	bl PlaySoundEffect
	mov r0, #8
	strb r0, [r5,#2]
locret_80398AE:
	pop {r4-r7,pc}
	thumb_func_end sub_8039888

	thumb_local_start
sub_80398B0:
	push {r4-r7,lr}
	ldr r0, dword_80398D8 // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	ldrb r0, [r5,#4]
	bl sub_803BB2C
	bl battle_resetEStructRecords_8046664 // () -> void
	bl sub_803993A
	mov r0, #0
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #8
	strb r0, [r5,#1]
	mov r0, #0
	strb r0, [r5,#2]
	pop {r4-r7,pc}
	.balign 4, 0
dword_80398D8:
	.word 0x1F40
	thumb_func_end sub_80398B0

	thumb_local_start
sub_80398DC:
	push {r4-r7,lr}
	mov r4, #1
	ldr r7, [r5,#0x2c]
	bl sub_803BB80
	beq loc_8039932
loc_80398E8:
	ldr r0, [r7]
	cmp r0, #0
	beq loc_8039900
	cmp r0, #1
	beq loc_803990E
	cmp r0, #2
	beq loc_8039918
	cmp r0, #3
	beq loc_803991C
	cmp r0, #4
	beq loc_8039928
	b loc_8039918
loc_8039900:
	ldr r0, [r7,#4]
	ldr r1, [r7,#8]
	ldr r2, [r7,#0xc]
	bl battle_initEmotionTableEntry_8046670
	add r7, #0x10
	b loc_80398E8
loc_803990E:
	ldr r0, [r7,#4]
	bl sub_803BB7C
	add r7, #8
	b loc_8039932
loc_8039918:
	mov r4, #0
	b loc_8039932
loc_803991C:
	ldr r0, [r7,#4]
	ldr r1, [r7,#8]
	bl SetScreenFade // (int a1, int a2) -> void
	add r7, #0xc
	b loc_80398E8
loc_8039928:
	ldr r0, [r7,#4]
	bl PlaySoundEffect
	add r7, #8
	b loc_80398E8
loc_8039932:
	str r7, [r5,#0x2c]
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_80398DC

	thumb_local_start
sub_803993A:
	push {r4-r7,lr}
	ldr r7, off_8039958 // =dword_80394CC
	bl battle_resetEStructRecords_8046664 // () -> void
loc_8039942:
	ldr r0, [r7]
	cmp r0, #2
	beq locret_8039956
	ldr r0, [r7,#4]
	ldr r1, [r7,#8]
	ldr r2, [r7,#0xc]
	bl battle_initEmotionTableEntry_8046670
	add r7, #0x10
	b loc_8039942
locret_8039956:
	pop {r4-r7,pc}
	.balign 4, 0
off_8039958:
	.word dword_80394CC
	thumb_func_end sub_803993A

	thumb_local_start
sub_803995C:
	push {r4-r7,lr}
	ldrb r0, [r5,#4]
	strb r0, [r5,#6]
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	ldrh r7, [r7,#2]
	mov r4, #0
	mov r0, #2
	tst r0, r7
	beq loc_8039974
	mov r4, #1
	b loc_80399C8
loc_8039974:
	mov r0, #1
	tst r0, r7
	beq loc_803997E
	mov r4, #2
	b loc_80399C8
loc_803997E:
	mov r0, #8
	tst r0, r7
	beq loc_8039988
	mov r4, #3
	b loc_80399C8
loc_8039988:
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	ldrh r7, [r7,#4]
	mov r0, #0x40
	tst r0, r7
	beq loc_80399AA
	mov r0, #SOUND_UNK_66
	bl PlaySoundEffect
	ldrb r0, [r5,#4]
	sub r0, #1
	strb r0, [r5,#4]
	bge loc_80399C8
	ldrb r0, [r5,#5]
	sub r0, #1
	strb r0, [r5,#4]
	b loc_80399C8
loc_80399AA:
	mov r0, #0x80
	tst r0, r7
	beq loc_80399C8
	mov r0, #SOUND_UNK_66
	bl PlaySoundEffect
	ldrb r0, [r5,#4]
	add r0, #1
	strb r0, [r5,#4]
	ldrb r1, [r5,#5]
	cmp r0, r1
	blt loc_80399C8
	mov r0, #0
	strb r0, [r5,#4]
	b loc_80399C8
loc_80399C8:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_803995C

	thumb_local_start
sub_80399CE:
	push {r4-r7,lr}
	ldr r0, off_80399E4 // =off_80399E8
	ldrb r1, [r5,#1]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	bl sub_803CB78
	bl sub_803C530
	pop {r4-r7,pc}
	.balign 4, 0
off_80399E4:
	.word off_80399E8
off_80399E8:
  // 0x00
  .word sub_8039A58+1
  // 0x04
	.word sub_8039AB8+1
  // 0x08
	.word sub_8039AE4+1
  // 0x0C
	.word sub_8039B0A+1
  // 0x10
	.word sub_8039B60+1
  // 0x14
	.word sub_8039B82+1
  // 0x18
	.word sub_8039B98+1
  // 0x1C
	.word sub_8039BC0+1
  // 0x20
	.word sub_8039C14+1
  // 0x24
	.word sub_8039C32+1
  // 0x28
	.word sub_8039D08+1
  // 0x2C
	.word sub_8039D66+1
  // 0x30
	.word sub_8039D9A+1
  // 0x34
	.word sub_8039DB4+1
  // 0x38
	.word sub_8039E2C+1
  // 0x3C
	.word sub_8039E80+1
  // 0x40
	.word sub_8039EBA+1
  // 0x44
	.word sub_8039ECC+1
  // 0x48
	.word sub_8039F78+1
  // 0x4C
	.word sub_8039FEC+1
  // 0x50
	.word sub_803A03A+1
  // 0x54
	.word sub_803A054+1
  // 0x58
	.word sub_803A06C+1
  // 0x5C
	.word sub_803A086+1
  // 0x60
	.word sub_803A0A4+1
  // 0x64
	.word sub_803A0BE+1
  // 0x68
	.word sub_803A0D4+1
  // 0x6C
	.word sub_803A0EE+1
	thumb_func_end sub_80399CE

	thumb_local_start
sub_8039A58:
	push {r4-r7,lr}
	ldr r0, dword_8039AB0 // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()
	mov r0, #0x12
	bl toolkit_applyOverlayPalette_80015FC
	bl copyData_803B2E4
	bl chatbox_8040818
	mov r0, #2
	bl sub_803BE30
	bl battle_resetEStructRecords_8046664 // () -> void
	// a1
	ldr r0, off_8039AB4 // =byte_8039390
	bl battle_spawnEStructRecordsFromTable_80465A0 // (void *a1) -> void
	bl sub_803C40C
	mov r0, #0xf0
	mov r1, #0x30
	mov r2, #0x80
	lsl r2, r2, #1
	mov r3, #0x90
	add r0, r0, r5
	add r1, r1, r5
	add r2, r2, r5
	add r3, r3, r5
	bl sub_803C1A8
	bl sub_803C320
	bl sub_803C26A
	mov r0, #4
	strb r0, [r5,#1]
	pop {r4-r7,pc}
	.balign 4, 0
dword_8039AB0:
	.word 0x1F40
off_8039AB4:
	.word byte_8039390
	thumb_func_end sub_8039A58

	thumb_local_start
sub_8039AB8:
	push {r4-r7,lr}
	bl rfu_initLinkSession
	tst r0, r0
	bne loc_8039ADA
	bl sub_803C320
	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x13
	bl sub_803BB2C
	mov r0, #0x10
	strb r0, [r5,#1]
	b loc_8039ADE
loc_8039ADA:
	mov r0, #8
	strb r0, [r5,#1]
loc_8039ADE:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_8039AB8

	thumb_local_start
sub_8039AE4:
	push {r4-r7,lr}
	bl rfu_checkIdMatch
	beq loc_8039B00
	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x13
	bl sub_803BB2C
	mov r0, #0x10
	strb r0, [r5,#1]
	b loc_8039B04
loc_8039B00:
	mov r0, #0xc
	strb r0, [r5,#1]
loc_8039B04:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_8039AE4

	thumb_local_start
sub_8039B0A:
	push {r4-r7,lr}
	bl sub_8146588
	mov r0, r5
	add r0, #0xf0
	bl sub_814695C
	bl sub_803C418
	mov r1, r0
	mov r0, #0x80
	lsl r0, r0, #1
	add r0, r0, r5
	bl sub_81469BC
	bl rfu_initLinkSession
	tst r0, r0
	bne loc_8039B48
	bl sub_803C320
	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x13
	bl sub_803BB2C
	mov r0, #0x10
	strb r0, [r5,#1]
	b loc_8039B5A
loc_8039B48:
	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0xa
	bl sub_803BB2C
	mov r0, #0x18
	strb r0, [r5,#1]
loc_8039B5A:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_8039B0A

	thumb_local_start
sub_8039B60:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_8039B7C
	mov r0, #8
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	beq loc_8039B7C
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x14
	strb r0, [r5,#1]
loc_8039B7C:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_8039B60

	thumb_local_start
sub_8039B82:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_8039B92
	mov r0, #8
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_8039B92:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_8039B82

	thumb_local_start
sub_8039B98:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_8039BBA
	bl sub_803A524
	bne loc_8039BBA
	bl sub_803C320
	mov r0, #0x1c
	strb r0, [r5,#1]
	mov r0, #0x1e
	bl sub_803BB7C
	mov r0, #0
	bl sub_803BB90
loc_8039BBA:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_8039B98

	thumb_local_start
sub_8039BC0:
	push {r4-r7,lr}
	bl sub_803A558
	bne loc_8039C0E
	bl sub_803BB80
	beq loc_8039C0E
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_Pressed]
	mov r1, #2
	tst r0, r1
	beq loc_8039BE6
	mov r0, #0x68
	bl sub_803C28A
	mov r0, #0x68
	strb r0, [r5,#1]
	b loc_8039C0E
loc_8039BE6:
	mov r0, #8
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	beq loc_8039C0E
	bl sub_803BB94
	beq loc_8039C0E
	bl sub_803C558
	mov r0, #0x1e
	bl sub_803BB90
	bl sub_813D638
	beq loc_8039C0E
	mov r0, #0xb
	bl sub_803BB2C
	mov r0, #0x20
	strb r0, [r5,#1]
loc_8039C0E:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_8039BC0

	thumb_local_start
sub_8039C14:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_8039C2C
	mov r0, #0
	strb r0, [r5,#0xe]
	strb r0, [r5,#0xb]
	mov r0, #4
	strb r0, [r5,#0xc]
	mov r0, #0x24
	strb r0, [r5,#1]
loc_8039C2C:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_8039C14

	thumb_local_start
sub_8039C32:
	push {r4-r7,lr}
	mov r0, #1
	bl sub_803CB00
	bl sub_803A558
	bne loc_8039C7C
	mov r0, #2
	bl sub_803CB18
	bne loc_8039C7C
	bl sub_813D638
	bne loc_8039C6A
	bl sub_803C320
	mov r0, #0x1c
	strb r0, [r5,#1]
	mov r0, #0x1e
	bl sub_803BB7C
	mov r0, #0
	bl sub_803BB90
	mov r0, #0xe
	bl sub_803BB2C
	b loc_8039C7C
loc_8039C6A:
	mov r0, #0x66
	bl sub_803A5F4
	beq loc_8039C7C
	ldr r1, off_8039C88 // =dword_8039C8C
	lsl r0, r0, #2
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
loc_8039C7C:
	bl sub_803A104
	mov r0, #1
	bl sub_803CB0C
	pop {r4-r7,pc}
	.balign 4, 0
off_8039C88:
	.word dword_8039C8C
dword_8039C8C:
	.word 0x0
	.word sub_8039C9C+1
	.word sub_8039CB4+1
	.word sub_8039CB4+1
	thumb_func_end sub_8039C32

	thumb_local_start
sub_8039C9C:
	push {r4-r7,lr}
	mov r0, #2
	bl sub_803CB18
	bne loc_8039CB0
	mov r0, #0x68
	bl sub_803C28A
	mov r0, #0x60
	strb r0, [r5,#1]
loc_8039CB0:
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_8039C9C

	thumb_local_start
sub_8039CB4:
	push {r4-r7,lr}
	bl sub_813D638
	mov r2, r0
	ldrb r0, [r5,#0xe]
	ldrb r1, [r5,#0xb]
	add r0, r0, r1
	cmp r0, r2
	bge loc_8039CF4
	bl sub_803C440
	mov r2, r1
	push {r0,r1}
	ldr r1, off_8039D00 // =byte_202AB00
	ldr r3, off_8039D04 // =byte_202AF00
	bl sub_803C150
	pop {r2,r3}
	ldr r0, off_8039D00 // =byte_202AB00
	ldr r1, off_8039D04 // =byte_202AF00
	bl sub_803C2AA
	mov r0, #0xc
	bl sub_803BB2C
	mov r0, #0x28
	strb r0, [r5,#1]
	mov r0, #SOUND_SELECT_67
	bl PlaySoundEffect
	mov r0, #1
	pop {r4-r7,pc}
loc_8039CF4:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_8039D00:
	.word byte_202AB00
off_8039D04:
	.word byte_202AF00
	thumb_func_end sub_8039CB4

	thumb_local_start
sub_8039D08:
	push {r4-r7,lr}
	bl sub_803A558
	bne loc_8039D60
	mov r0, #8
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	beq loc_8039D60
	bl chatbox_GetState_8045F4C
	cmp r0, #0
	bne loc_8039D54
	bl sub_813D638
	mov r2, r0
	ldrb r0, [r5,#0xe]
	ldrb r1, [r5,#0xb]
	add r0, r0, r1
	cmp r0, r2
	bge loc_8039D54
	push {r0}
	bl sub_813D5C8
	pop {r0}
	strb r0, [r5,#0x16]
	mov r0, #4
	bl sub_803CB00
	mov r0, #0x10
	lsl r0, r0, #4
	bl sub_803CB00
	mov r0, #0xd
	bl sub_803BB2C
	mov r0, #0x2c
	strb r0, [r5,#1]
	b loc_8039D60
loc_8039D54:
	mov r0, #0xb
	bl sub_803BB2C
	mov r0, #0x30
	strb r0, [r5,#1]
	b loc_8039D60
loc_8039D60:
	bl sub_803A104
	pop {r4-r7,pc}
	thumb_func_end sub_8039D08

	thumb_local_start
sub_8039D66:
	push {r4-r7,lr}
	bl sub_803A558
	bne loc_8039D94
	mov r0, #0x40
	bl sub_803CB18
	bne loc_8039D94
	mov r0, #8
	bl sub_803CB18
	bne loc_8039D8E
	bl sub_803A252
	mov r0, #0xb
	bl sub_803BB2C
	mov r0, #0x34
	strb r0, [r5,#1]
	b loc_8039D94
loc_8039D8E:
	mov r0, #0x48
	strb r0, [r5,#1]
	b loc_8039D94
loc_8039D94:
	bl sub_803A104
	pop {r4-r7,pc}
	thumb_func_end sub_8039D66

	thumb_local_start
sub_8039D9A:
	push {r4-r7,lr}
	bl sub_803A558
	bne loc_8039DAE
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_8039DAE
	mov r0, #0x24
	strb r0, [r5,#1]
loc_8039DAE:
	bl sub_803A104
	pop {r4-r7,pc}
	thumb_func_end sub_8039D9A

	thumb_local_start
sub_8039DB4:
	push {r4-r7,lr}
	bl sub_803A558
	beq loc_8039DD4
	bl sub_814656C
	tst r0, r0
	bne loc_8039E26
	bl sub_803A25C
	mov r0, #0xf
	bl sub_803BB2C
	mov r0, #0x38
	strb r0, [r5,#1]
	b loc_8039E26
loc_8039DD4:
	mov r0, #8
	bl sub_803CB18
	bne loc_8039DEC
	bl sub_803C330
	beq loc_8039DF2
	bl sub_803C2A0
	mov r0, #0x20
	bl sub_803CB00
loc_8039DEC:
	mov r0, #0x48
	strb r0, [r5,#1]
	b loc_8039E26
loc_8039DF2:
	mov r0, #0x10
	bl sub_803CB18
	beq loc_8039E26
	mov r0, #0x10
	lsl r0, r0, #4
	bl sub_803CB0C
	bl sub_8146CFC
	mov r0, #0
	bl sub_802D070
	bl sub_8147B24
	mov r0, #0x2c
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	bl musicGameState_8000784 // () -> void
	mov r0, #SOUND_BATTLE_START
	bl PlaySoundEffect
	mov r0, #0x3c
	strb r0, [r5,#1]
loc_8039E26:
	bl sub_803A104
	pop {r4-r7,pc}
	thumb_func_end sub_8039DB4

	thumb_local_start
sub_8039E2C:
	push {r4-r7,lr}
	bl sub_803A58C
	beq loc_8039E7A
	mov r0, #8
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	beq loc_8039E7A
	bl sub_8146588
	mov r0, r5
	add r0, #0xf0
	bl sub_814695C
	bl sub_803C418
	mov r1, r0
	mov r0, #0x80
	lsl r0, r0, #1
	add r0, r0, r5
	bl sub_81469BC
	bl rfu_initLinkSession
	tst r0, r0
	bne loc_8039E70
	bl sub_803C320
	mov r0, #0x13
	bl sub_803BB2C
	mov r0, #0x10
	strb r0, [r5,#1]
	b loc_8039E7A
loc_8039E70:
	mov r0, #0xa
	bl sub_803BB2C
	mov r0, #0x18
	strb r0, [r5,#1]
loc_8039E7A:
	bl sub_803A104
	pop {r4-r7,pc}
	thumb_func_end sub_8039E2C

	thumb_local_start
sub_8039E80:
	push {r4-r7,lr}
	bl dispatch_803C620 // () -> (u32?, bool)
	bl IsScreenFadeActive // () -> zf
	beq loc_8039EB4
	bl chatbox_8040818
	bl copyMemory_8001850
	bl resetAllGraphicsState_8005F40
	bl runSetupStepAndClearWorkArea_8005F6C
	bl sprite_initBattleFadeGfxState_80027C4
	bl RandomizeExtraToolkitPointers // () -> ?
	mov r0, #0
	bl getBattleSettingsFromList0 // (int battleSettingsIdx) -> BattleSettings*
	bl initBattleStructsAndVram_80071D4
	mov r0, #0x40
	strb r0, [r5,#1]
	pop {r4-r7,pc}
loc_8039EB4:
	bl sub_803A104
	pop {r4-r7,pc}
	thumb_func_end sub_8039E80

	thumb_local_start
sub_8039EBA:
	push {r4-r7,lr}
	bl battle_main_8007800
	bne locret_8039ECA
	strb r1, [r5,#0x14]
	strb r2, [r5,#0x15]
	mov r0, #0x44
	strb r0, [r5,#1]
locret_8039ECA:
	pop {r4-r7,pc}
	thumb_func_end sub_8039EBA

	thumb_local_start
sub_8039ECC:
	push {r4-r7,lr}
	ldr r0, off_8039EE0 // =dword_8039EE4
	ldrb r1, [r5,#0x14]
	lsl r1, r1, #2
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	bl sub_803F9E4
	pop {r4-r7,pc}
	.balign 4, 0
off_8039EE0:
	.word dword_8039EE4
dword_8039EE4:
	.word 0x0
	.word sub_8039F10+1
	.word sub_8039F24+1
	.word sub_8039F38+1
	.word sub_8039F48+1
	.word sub_8039F58+1
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.word sub_8039F62+1
	.word sub_8039F6A+1
	thumb_func_end sub_8039ECC

	thumb_local_start
sub_8039F10:
	push {r4-r7,lr}
	mov r0, #1
	bl sub_803C3B6
	mov r0, #0x50
	ldrb r1, [r5,#0x15]
	add r0, r0, r1
	bl loc_8039578
	pop {r4-r7,pc}
	thumb_func_end sub_8039F10

	thumb_local_start
sub_8039F24:
	push {r4-r7,lr}
	mov r0, #0
	bl sub_803C3B6
	mov r0, #0x52
	ldrb r1, [r5,#0x15]
	add r0, r0, r1
	bl loc_8039578
	pop {r4-r7,pc}
	thumb_func_end sub_8039F24

	thumb_local_start
sub_8039F38:
	push {r4-r7,lr}
	mov r0, #0
	bl sub_803C3B6
	mov r0, #0x54
	bl loc_8039578
	pop {r4-r7,pc}
	thumb_func_end sub_8039F38

	thumb_local_start
sub_8039F48:
	push {r4-r7,lr}
	mov r0, #0
	bl sub_803C3B6
	mov r0, #0x55
	bl loc_8039578
	pop {r4-r7,pc}
	thumb_func_end sub_8039F48

	thumb_local_start
sub_8039F58:
	push {r4-r7,lr}
	mov r0, #0x56
	bl loc_8039578
	pop {r4-r7,pc}
	thumb_func_end sub_8039F58

	thumb_local_start
sub_8039F62:
	push {r4-r7,lr}
	bl sub_803CCC0
	pop {r4-r7,pc}
	thumb_func_end sub_8039F62

	thumb_local_start
sub_8039F6A:
	push {r4-r7,lr}
	ldr r0, off_8039F74 // =sub_8039570+1
	bl sub_803CB8C
	pop {r4-r7,pc}
	.balign 4, 0
off_8039F74:
	.word sub_8039570+1
	thumb_func_end sub_8039F6A

	thumb_local_start
sub_8039F78:
	push {r4-r7,lr}
	bl sub_803A58C
	push {r0}
	mov r0, #0x10
	bl sub_803CB18
	pop {r0}
	bne loc_8039FBA
	tst r0, r0
	beq loc_8039FE6
	bl sub_803A25C
	mov r0, #SOUND_UNSELECT_68
	bl PlaySoundEffect
	mov r4, #0xf
	mov r0, #0x80
	bl sub_803CB18
	bne loc_8039FAE
	mov r4, #0x10
	mov r0, #0x20
	bl sub_803CB18
	bne loc_8039FAE
	mov r4, #0x11
loc_8039FAE:
	mov r0, r4
	bl sub_803BB2C
	mov r0, #0x4c
	strb r0, [r5,#1]
	b loc_8039FE6
loc_8039FBA:
	mov r0, #0x10
	lsl r0, r0, #4
	bl sub_803CB0C
	bl sub_8146CFC
	mov r0, #0
	bl sub_802D070
	bl sub_8147B24
	mov r0, #0x2c
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	bl musicGameState_8000784 // () -> void
	mov r0, #SOUND_BATTLE_START
	bl PlaySoundEffect
	mov r0, #0x3c
	strb r0, [r5,#1]
loc_8039FE6:
	bl sub_803A104
	pop {r4-r7,pc}
	thumb_func_end sub_8039F78

	thumb_local_start
sub_8039FEC:
	push {r4-r7,lr}
	mov r0, #8
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	beq loc_803A034
	bl sub_8146588
	mov r0, r5
	add r0, #0xf0
	bl sub_814695C
	bl sub_803C418
	mov r1, r0
	mov r0, #0x80
	lsl r0, r0, #1
	add r0, r0, r5
	bl sub_81469BC
	bl rfu_initLinkSession
	tst r0, r0
	bne loc_803A02A
	bl sub_803C320
	mov r0, #0x13
	bl sub_803BB2C
	mov r0, #0x10
	strb r0, [r5,#1]
	b loc_803A034
loc_803A02A:
	mov r0, #0xa
	bl sub_803BB2C
	mov r0, #0x18
	strb r0, [r5,#1]
loc_803A034:
	bl sub_803A104
	pop {r4-r7,pc}
	thumb_func_end sub_8039FEC

	thumb_local_start
sub_803A03A:
	push {r4-r7,lr}
	bl sub_803A5DC
	beq loc_803A04E
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x54 
	strb r0, [r5,#1]
loc_803A04E:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_803A03A

	thumb_local_start
sub_803A054:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803A066
	bl copyMemory_8001850
	bl sub_803CCC0
	pop {r4-r7,pc}
loc_803A066:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_803A054

	thumb_local_start
sub_803A06C:
	push {r4-r7,lr}
	bl sub_803A58C
	beq loc_803A080
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x5c 
	strb r0, [r5,#1]
loc_803A080:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_803A06C

	thumb_local_start
sub_803A086:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803A09A
	bl copyMemory_8001850
	ldr r0, off_803A0A0 // =sub_8039570+1
	bl sub_803CB8C
	pop {r4-r7,pc}
loc_803A09A:
	bl sub_803A1B0
	pop {r4-r7,pc}
	.balign 4, 0
off_803A0A0:
	.word sub_8039570+1
	thumb_func_end sub_803A086

	thumb_local_start
sub_803A0A4:
	push {r4-r7,lr}
	bl sub_803A58C
	beq loc_803A0B8
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x64 
	strb r0, [r5,#1]
loc_803A0B8:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_803A0A4

	thumb_local_start
sub_803A0BE:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803A0CE
	mov r0, #8
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_803A0CE:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_803A0BE

	thumb_local_start
sub_803A0D4:
	push {r4-r7,lr}
	bl sub_803A58C
	beq loc_803A0E8
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x6c 
	strb r0, [r5,#1]
loc_803A0E8:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_803A0D4

	thumb_local_start
sub_803A0EE:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803A0FE
	mov r0, #8
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_803A0FE:
	bl sub_803A1B0
	pop {r4-r7,pc}
	thumb_func_end sub_803A0EE

	thumb_func_start sub_803A104
sub_803A104:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x18]
	tst r0, r0
	beq loc_803A112
	bl sub_803A2A4
	beq locret_803A184
loc_803A112:
	bl sub_803A214
	mov r6, #0
loc_803A118:
	bl sub_813D638
	cmp r6, r0
	bge loc_803A176
	ldrb r0, [r5,#0xb]
	add r0, r0, r6
	bl sub_803C440
	mov r7, r1
	mov r3, r0
	mov r0, #0x24
	mov r1, #0x23
	add r0, #3
	mov r2, #0x20
	mul r2, r6
	add r1, r1, r2
	mov r2, #6
	ldrh r4, [r5,#0x24]
	bl sub_803B814
	mov r0, #0x7b
	mov r1, #0x23
	mov r2, #0x20
	mul r2, r6
	add r1, r1, r2
	mov r2, #7
	mov r3, r7
	ldrh r4, [r5,#0x26]
	bl sub_803B814
	mov r0, r7
	bl sub_8146728
	mov r3, r0
	mov r0, #0x21
	mov r1, #0x1a
	mov r2, #0x20
	mul r2, r6
	add r1, r1, r2
	mov r2, #4
	bl sub_803B9C0
	mov r0, r6
	mov r1, #1
	bl sub_803A238
	b loc_803A17A
loc_803A176:
	bl sub_803A1D8
loc_803A17A:
	add r6, #1
	cmp r6, #4
	blt loc_803A118
	bl chatbox_waitStepUpdateEntities
locret_803A184:
	pop {r4-r7,pc}
	thumb_func_end sub_803A104

// symdb: One frame of a cutscene wait step: test chatbox event flag 0x80, feed a done/not-done flag plus an indexed id to sub_803BBA4, then tick all entity updates and sprite rendering so the world keeps animating while waiting.
// symdb: (r5 = record whose byte at +0x0e is an index; r0-r4 scratch) -> void; sets r4 = 1 when flag 0x80
// symdb: is clear, 0 when set, passes it as r2 to sub_803BBA4
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/chatbox_waitStepUpdateEntities.yaml
	thumb_local_start
chatbox_waitStepUpdateEntities:
	push {r4-r7,lr}
	mov r4, #0
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803A194
	mov r4, #1
loc_803A194:
	mov r0, #4
	mov r1, #0x21
	ldrb r2, [r5,#0xe]
	mov r3, #0x20
	mul r3, r2
	add r1, r1, r3
	mov r2, r4
	bl sub_803BBA4
	bl entity_runAllUpdateHandlers_80465BC
	bl battle_updateEStructSprites_80465F8 // () -> void
	pop {r4-r7,pc}
	thumb_func_end chatbox_waitStepUpdateEntities

	thumb_func_start sub_803A1B0
sub_803A1B0:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x18]
	tst r0, r0
	beq loc_803A1BE
	bl sub_803A2A4
	beq locret_803A1D6
loc_803A1BE:
	bl sub_803A214
	mov r6, #0
loc_803A1C4:
	bl sub_803A1D8
	add r6, #1
	cmp r6, #4
	blt loc_803A1C4
	bl entity_runAllUpdateHandlers_80465BC
	bl battle_updateEStructSprites_80465F8 // () -> void
locret_803A1D6:
	pop {r4-r7,pc}
	thumb_func_end sub_803A1B0

	thumb_local_start
sub_803A1D8:
	push {r4-r7,lr}
	bl sub_803C458
	mov r7, r1
	mov r3, r0
	mov r0, #0x24
	mov r1, #0x23
	add r0, #3
	mov r2, #0x20
	mul r2, r6
	add r1, r1, r2
	mov r2, #6
	ldrh r4, [r5,#0x24]
	bl sub_803B814
	mov r0, #0x7b
	mov r1, #0x23
	mov r2, #0x20
	mul r2, r6
	add r1, r1, r2
	mov r2, #7
	mov r3, r7
	ldrh r4, [r5,#0x26]
	bl sub_803B814
	mov r0, r6
	mov r1, #0
	bl sub_803A238
	pop {r4-r7,pc}
	thumb_func_end sub_803A1D8

	thumb_local_start
sub_803A214:
	push {r4-r7,lr}
	mov r3, #0xf0
	add r3, r3, r5
	mov r0, #0x43
	mov r1, #2
	mov r2, #0xa
	ldrh r4, [r5,#0x24]
	bl sub_803B814
	bl sub_803C418
	mov r3, r0
	mov r0, #0x1a
	mov r1, #7
	mov r2, #4
	bl sub_803B9C0
	pop {r4-r7,pc}
	thumb_func_end sub_803A214

	thumb_local_start
sub_803A238:
	push {r4-r7,lr}
	mov r2, #1
	lsl r2, r0
	tst r1, r1
	bne loc_803A24A
	mov r0, r2
	bl sub_803C30C
	b locret_803A250
loc_803A24A:
	mov r0, r2
	bl sub_803C302
locret_803A250:
	pop {r4-r7,pc}
	thumb_func_end sub_803A238

	thumb_local_start
sub_803A252:
	mov r0, #1
	strb r0, [r5,#0x18]
	mov r0, #0
	strb r0, [r5,#2]
	mov pc, lr
	thumb_func_end sub_803A252

	thumb_local_start
sub_803A25C:
	push {r4-r7,lr}
	mov r0, #0
	strb r0, [r5,#0x18]
	ldr r0, dword_803A298 // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	mov r0, #0
	bl TerminateGFXAnim
	mov r0, #1
	bl TerminateGFXAnim
	mov r0, #4
	bl sub_803B91C
	mov r0, #5
	bl sub_803B91C
	mov r7, r10
	ldr r7, [r7,#oToolkit_RenderInfoPtr]
	mov r0, #0
	strh r0, [r7,#0x14]
	strh r0, [r7,#0x18]
	ldr r0, off_803A29C // =byte_87E672C
	ldr r1, off_803A2A0 // =unk_3001AE0
	mov r2, #0x20
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
dword_803A298:
	.word 0x1F40
off_803A29C:
	.word byte_87E672C
off_803A2A0:
	.word unk_3001AE0
	thumb_func_end sub_803A25C

	thumb_local_start
sub_803A2A4:
	push {r4-r7,lr}
	ldr r0, off_803A2B4 // =off_803A2B8
	ldrb r1, [r5,#2]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	tst r0, r0
	pop {r4-r7,pc}
off_803A2B4:
	.word off_803A2B8
off_803A2B8:
	.word sub_803A2CC+1
	.word sub_803A334+1
	.word sub_803A39C+1
	.word sub_803A3C4+1
	.word sub_803A410+1
	thumb_func_end sub_803A2A4

	thumb_local_start
sub_803A2CC:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803A31C
	ldr r0, dword_803A324 // =0x7f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	mov r3, r10
	ldr r3, [r3,#oToolkit_Unk200f3a0_Ptr]
	mov r0, #0
	strb r0, [r3,#1]
	mov r0, #0
	strb r0, [r3,#5]
	mov r0, #0xf0
	strb r0, [r3]
	mov r0, #0x61
	strb r0, [r3,#4]
	mov r0, #0
	strb r0, [r3,#3]
	mov r0, #0x40
	strb r0, [r3,#7]
	mov r0, #0xf0
	strb r0, [r3,#2]
	mov r0, #0xa1
	strb r0, [r3,#6]
	mov r0, #0x1f
	strb r0, [r3,#8]
	strb r0, [r3,#9]
	mov r0, #0x11
	strb r0, [r3,#0xa]
	ldr r0, off_803A328 // =byte_80392A8
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	ldr r0, off_803A32C // =word_87E672E
	ldrh r0, [r0]
	ldr r1, off_803A330 // =palette_3001960
	strh r0, [r1]
	mov r0, #4
	strb r0, [r5,#2]
loc_803A31C:
	bl chatbox_waitStepUpdateEntities
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
dword_803A324:
	.word 0x7F40
off_803A328:
	.word byte_80392A8
off_803A32C:
	.word word_87E672E
off_803A330:
	.word palette_3001960
	thumb_func_end sub_803A2CC

	thumb_local_start
sub_803A334:
	push {r4-r7,lr}
	mov r3, r10
	ldr r3, [r3,#oToolkit_Unk200f3a0_Ptr]
	ldrb r0, [r3,#5]
	add r0, #0x30
	strb r0, [r3,#5]
	ldrb r0, [r3,#4]
	sub r0, #0x30
	strb r0, [r3,#4]
	ldrb r0, [r3,#7]
	add r0, #0x30
	strb r0, [r3,#7]
	ldrb r0, [r3,#6]
	sub r0, #0x30
	strb r0, [r3,#6]
	cmp r0, #0x71
	bne loc_803A394
	mov r0, #6
	bl sub_803B91C
	push {r4-r7}
	mov r0, #0
	mov r1, #0
	mov r2, #2
	mov r3, #0
	mov r4, #0x1e
	mov r5, #0x14
	bl call_sub_3005EBA
	mov r0, #0
	mov r1, #0
	mov r2, #3
	mov r3, #0
	mov r4, #0x1e
	mov r5, #0x14
	bl call_sub_3005EBA
	pop {r4-r7}
	bl sub_803A422
	mov r0, #0
	strb r0, [r5,#0x19]
	strb r0, [r5,#0x1b]
	mov r0, #0xf
	strb r0, [r5,#0x1a]
	mov r0, #8
	strb r0, [r5,#2]
	b loc_803A398
loc_803A394:
	bl chatbox_waitStepUpdateEntities
loc_803A398:
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_803A334

	thumb_local_start
sub_803A39C:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x1a]
	sub r0, #1
	strb r0, [r5,#0x1a]
	bgt loc_803A3B6
	ldr r0, off_803A3C0 // =byte_80392D8
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	mov r0, #0xb7
	bl PlaySoundEffect
	mov r0, #0xc
	strb r0, [r5,#2]
loc_803A3B6:
	bl sub_803A422
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_803A3C0:
	.word byte_80392D8
	thumb_func_end sub_803A39C

	thumb_local_start
sub_803A3C4:
	push {r4-r7,lr}
	mov r3, r10
	ldr r3, [r3,#oToolkit_Unk200f3a0_Ptr]
	ldrb r0, [r3,#5]
	sub r0, #8
	strb r0, [r3,#5]
	ldrb r0, [r3,#4]
	add r0, #8
	strb r0, [r3,#4]
	ldrb r0, [r3,#7]
	sub r0, #8
	strb r0, [r3,#7]
	ldrb r0, [r3,#6]
	add r0, #8
	strb r0, [r3,#6]
	cmp r0, #0x91
	bne loc_803A3FC
	ldr r0, dword_803A404 // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	ldr r0, off_803A408 // =off_8039308
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	ldr r0, off_803A40C // =byte_8039350
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	mov r0, #0x10
	strb r0, [r5,#2]
loc_803A3FC:
	bl sub_803A422
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
dword_803A404:
	.word 0x1F40
off_803A408:
	.word off_8039308
off_803A40C:
	.word byte_8039350
	thumb_func_end sub_803A3C4

	thumb_local_start
sub_803A410:
	push {r4-r7,lr}
	bl sub_803A422
	bl sub_803A470
	bl sub_803A4D0
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_803A410

	thumb_local_start
sub_803A422:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x19]
	sub r0, #1
	strb r0, [r5,#0x19]
	mov r7, #0
loc_803A42C:
	ldrb r0, [r5,#0x19]
	mov r1, #4
	add r1, r1, r7
	mov r2, #1
	ldr r3, off_803A468 // =unk_202A204
	lsl r4, r7, #6
	add r3, r3, r4
	mov r4, #0x20
	bl bg_writeTileIdRow_80018E0
	add r7, #1
	cmp r7, #4
	blt loc_803A42C
	mov r7, #0
loc_803A448:
	ldrb r0, [r5,#0x19]
	mov r1, #0x20
	sub r0, r1, r0
	mov r1, #0xc
	add r1, r1, r7
	mov r2, #1
	ldr r3, off_803A46C // =word_202A604
	lsl r4, r7, #6
	add r3, r3, r4
	mov r4, #0x20
	bl bg_writeTileIdRow_80018E0
	add r7, #1
	cmp r7, #4
	blt loc_803A448
	pop {r4-r7,pc}
	.balign 4, 0
off_803A468:
	.word unk_202A204
off_803A46C:
	.word word_202A604
	thumb_func_end sub_803A422

	thumb_local_start
sub_803A470:
	push {r4-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_RenderInfoPtr]
	ldrb r0, [r5,#0x1b]
	add r0, #0xc
	mov r1, #0x78
	cmp r0, r1
	ble loc_803A482
	mov r0, r1
loc_803A482:
	strb r0, [r5,#0x1b]
	mov r1, #7
	and r1, r0
	neg r1, r1
	add r1, #8
	strh r1, [r7,#0x14]
	push {r5}
	sub r0, #0x70
	asr r0, r0, #3
	// i
	mov r1, #4
	// tileBlock32x32
	mov r2, #2
	// tileIds
	ldr r3, off_803A4C8 // =reqBBS_requestInfo_textOffsets
	mov r4, #0xe
	mov r5, #4
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r5}
	ldrb r0, [r5,#0x1b]
	mov r1, #0x70
	sub r0, r1, r0
	add r0, #0x90
	mov r1, #7
	and r1, r0
	neg r1, r1
	add r1, #8
	strh r1, [r7,#0x18]
	asr r0, r0, #3
	mov r1, #0xc
	mov r2, #3
	ldr r3, off_803A4CC // =unk_2029E04
	mov r4, #0xe
	mov r5, #4
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_803A4C8:
	.word reqBBS_requestInfo_textOffsets
off_803A4CC:
	.word unk_2029E04
	thumb_func_end sub_803A470

	thumb_local_start
sub_803A4D0:
	push {r4-r7,lr}
	mov r3, #0xf0
	add r3, r3, r5
	mov r0, #8
	mov r1, #0x13
	mov r2, #6
	ldrh r4, [r5,#0x24]
	bl sub_803B814
	bl sub_803C418
	mov r3, r0
	mov r0, #0x58
	mov r1, #0x18
	mov r2, #4
	bl sub_803BA00
	ldr r7, off_803A51C // =0x110
	add r7, r7, r5
	mov r0, #0xa8
	mov r1, #0x83
	mov r2, #6
	mov r3, r7
	ldrh r4, [r5,#0x24]
	bl sub_803B814
	ldr r7, off_803A520 // =0x120
	add r7, r7, r5
	mov r0, r7
	bl sub_8146728
	mov r3, r0
	mov r0, #0x80
	mov r1, #0x88
	mov r2, #4
	bl sub_803BA00
	pop {r4-r7,pc}
	.balign 4, 0
off_803A51C:
	.word 0x110
off_803A520:
	.word 0x120
	thumb_func_end sub_803A4D0

	thumb_local_start
sub_803A524:
	push {r4-r7,lr}
	bl dispatch_803C620 // () -> (u32?, bool)
	mov r4, r0
	tst r1, r1
	bne loc_803A546
	tst r0, r0
	beq loc_803A546
	bl sub_813D978
	ldr r3, off_803A550 // =dword_803A554
	ldrb r0, [r3,r4]
	strb r0, [r5,#1]
	bl sub_8147F98
	mov r0, #1
	pop {r4-r7,pc}
loc_803A546:
	bl sub_8147F98
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_803A550:
	.word dword_803A554
dword_803A554:
	.word 0x585000
	thumb_func_end sub_803A524

	thumb_local_start
sub_803A558:
	push {r4-r7,lr}
	bl dispatch_803C620 // () -> (u32?, bool)
	mov r4, r0
	tst r1, r1
	bne loc_803A584
	tst r0, r0
	beq loc_803A584
	bl sub_813D978
	ldr r3, off_803A5C0 // =dword_803A5C4
	lsl r4, r4, #3
	add r3, r3, r4
	ldr r0, [r3]
	strb r0, [r5,#1]
	ldr r0, [r3,#4]
	mov lr, pc
	bx r0
	bl sub_8148214
	mov r0, #1
	pop {r4-r7,pc}
loc_803A584:
	bl sub_8148214
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_803A558

	thumb_local_start
sub_803A58C:
	push {r4-r7,lr}
	bl dispatch_803C620 // () -> (u32?, bool)
	mov r4, r0
	tst r1, r1
	bne loc_803A5B6
	cmp r0, #1
	beq loc_803A5A6
	bl test0x200bc50_0x5_813D60C
	bne loc_803A5B6
	mov r0, #1
	pop {r4-r7,pc}
loc_803A5A6:
	ldr r3, off_803A5C0 // =dword_803A5C4
	lsl r4, r4, #3
	add r3, r3, r4
	ldr r0, [r3]
	strb r0, [r5,#1]
	ldr r0, [r3,#4]
	mov lr, pc
	bx r0
loc_803A5B6:
	bl sub_8148214
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_803A5C0:
	.word dword_803A5C4
dword_803A5C4:
	.word 0x0
	.word sub_803C34E+1
	.word 0x50
	.word sub_813D750+1
	.word 0x58
	.word sub_803C34E+1
	thumb_func_end sub_803A58C

	thumb_local_start
sub_803A5DC:
	push {r4-r7,lr}
	bl dispatch_803C620 // () -> (u32?, bool)
	bl test0x200bc50_0x5_813D60C
	bne loc_803A5EC
	mov r0, #1
	pop {r4-r7,pc}
loc_803A5EC:
	bl sub_8148214
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_803A5DC

	thumb_func_start sub_803A5F4
sub_803A5F4:
	push {r4-r7,lr}
	mov r6, r0
	ldrb r0, [r5,#0xb]
	strb r0, [r5,#0xd]
	ldrb r0, [r5,#0xe]
	strb r0, [r5,#0xf]
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	ldrh r7, [r7,#2]
	mov r4, #0
	mov r0, #2
	tst r0, r7
	beq loc_803A612
	mov r4, #1
	b loc_803A674
loc_803A612:
	mov r0, #1
	tst r0, r7
	beq loc_803A61C
	mov r4, #2
	b loc_803A674
loc_803A61C:
	mov r0, #8
	tst r0, r7
	beq loc_803A626
	mov r4, #3
	b loc_803A674
loc_803A626:
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	ldrh r7, [r7,#4]
	mov r0, #0x40
	tst r0, r7
	beq loc_803A64C
	ldrb r0, [r5,#0xe]
	sub r0, #1
	strb r0, [r5,#0xe]
	bge loc_803A674
	mov r0, #0
	strb r0, [r5,#0xe]
	ldrb r0, [r5,#0xb]
	sub r0, #1
	strb r0, [r5,#0xb]
	bge loc_803A674
	mov r0, #0
	strb r0, [r5,#0xb]
	b loc_803A674
loc_803A64C:
	mov r0, #0x80
	tst r0, r7
	beq loc_803A674
	ldrb r0, [r5,#0xe]
	add r0, #1
	strb r0, [r5,#0xe]
	cmp r0, #4
	blt loc_803A674
	mov r0, #3
	strb r0, [r5,#0xe]
	ldrb r1, [r5,#0xb]
	add r1, #1
	strb r1, [r5,#0xb]
	ldrb r2, [r5,#0xc]
	sub r2, r2, r0
	cmp r1, r2
	blt loc_803A674
	sub r2, #1
	strb r2, [r5,#0xb]
	b loc_803A674
loc_803A674:
	ldrb r0, [r5,#0xe]
	ldrb r1, [r5,#0xf]
	cmp r0, r1
	bne loc_803A684
	ldrb r0, [r5,#0xb]
	ldrb r1, [r5,#0xd]
	cmp r0, r1
	beq loc_803A68A
loc_803A684:
	mov r0, r6
	bl PlaySoundEffect
loc_803A68A:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_803A5F4

	thumb_local_start
sub_803A690:
	push {r4-r7,lr}
	ldr r0, off_803A6A0 // =off_803A6A4
	ldrb r1, [r5,#1]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.byte 0, 0
off_803A6A0:
	.word off_803A6A4
off_803A6A4:
	.word sub_803A6E4+1
	.word sub_803A79A+1
	.word sub_803A9CC+1
	.word submenu_chipSelectFrameUpdate+1
	.word battle_startTransitionStep+1
	.word sub_803AC2C+1
	.word battle_startInit+1
	.word sub_803AC78+1
	.word sub_803ACA2+1
	.word sub_803ACB2+1
	.word submenu_guestLibraryFrameUpdate+1
	.word battle_startFadeIn+1
	.word sub_803AF1C+1
	.word sub_803AF46+1
	.word battle_condInitModule+1
	.word sub_803AF90+1
	thumb_func_end sub_803A690

	thumb_local_start
sub_803A6E4:
	push {r4-r7,lr}
	ldr r0, dword_803A73C // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()
	mov r0, #0x13
	bl toolkit_applyOverlayPalette_80015FC
	bl copyData_803B3C8
	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0
	strb r0, [r5,#8]
	strb r0, [r5,#0x12]
	strb r0, [r5,#0x1c]
	strb r0, [r5,#0x1d]
	strb r0, [r5,#0x13]
	bl sub_803BEC0
	bl sub_803BA28
	bl sub_803A740
	bl sub_803A752
	bl sub_803A764
	mov r0, #0
	bl sub_803BE30
	mov r0, #1
	bl sub_803BE30
	bl chatbox_8040818
	mov r0, #4
	strb r0, [r5,#1]
	pop {r4-r7,pc}
	.balign 4, 0
dword_803A73C:
	.word 0x1F40
	thumb_func_end sub_803A6E4

// symdb: Initializes battler slots 4 through 9 by calling sub_803B522 on each slot index.
// symdb: void sub_803A740(void /* r1,r2,r3,r10 preserved across call */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803A740.yaml
	thumb_func_start sub_803A740
sub_803A740:
	push {r4-r7,lr}
	mov r4, #4
loc_803A744:
	mov r0, r4
	bl sub_803B522
	add r4, #1
	cmp r4, #9
	ble loc_803A744
	pop {r4-r7,pc}
	thumb_func_end sub_803A740

// symdb: Calls sub_803B674 in a loop with r0 = 4..14 (inclusive), performing an 11-step setup or teardown across that index range.
// symdb: void sub_803A752(u32 ignored_r10, void *lr);  /* r5 out, clobbers r0-r3, lr, nzcv; preserves
// symdb: r4-r7 */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803A752.yaml
	thumb_func_start sub_803A752
sub_803A752:
	push {r4-r7,lr}
	mov r4, #4
loc_803A756:
	mov r0, r4
	bl sub_803B674
	add r4, #1
	cmp r4, #0xf
	ble loc_803A756
	pop {r4-r7,pc}
	thumb_func_end sub_803A752

// symdb: Iterates slot indices 0x1D-0x20 inclusive, calling sub_803B674 for each.
// symdb: void callSub_0x1D_to_0x20_803A764(void);  /* takes r10/lr from caller, returns
// symdb: r0-r3,r5,lr,nz,c,v; r4,r6,r7 preserved */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803A764.yaml
	thumb_func_start sub_803A764
sub_803A764:
	push {r4-r7,lr}
	mov r4, #0x1d
loc_803A768:
	mov r0, r4
	bl sub_803B674
	add r4, #1
	cmp r4, #0x20
	ble loc_803A768
	pop {r4-r7,pc}
	thumb_func_end sub_803A764

	thumb_local_start
sub_803A776:
	push {r4-r7,lr}
	mov r4, #0x10
loc_803A77A:
	mov r0, r4
	bl sub_803B674
	add r4, #1
	cmp r4, #0x1b
	ble loc_803A77A
	pop {r4-r7,pc}
	thumb_func_end sub_803A776

	thumb_local_start
sub_803A788:
	push {r4-r7,lr}
	mov r4, #0x21
loc_803A78C:
	mov r0, r4
	bl sub_803B674
	add r4, #1
	cmp r4, #0x25
	ble loc_803A78C
	pop {r4-r7,pc}
	thumb_func_end sub_803A788

	thumb_local_start
sub_803A79A:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803A7B2
	mov r0, #0x14
	bl sub_803BB2C
	mov r0, #0xf
	bl sub_803BB7C
	mov r0, #8
	strb r0, [r5,#1]
loc_803A7B2:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end sub_803A79A

// symdb: Bootstraps a battle scene by chaining subsystem initializers: two unspecified setups, a channel reset, two SFX loads/plays, and two display/object setups.
// symdb: void battleInitSceneAudioDisplay_803A7B8(void); /* inputs: r5, r10, lr; outputs: r5, r8, r9,
// symdb: r10, r11, r12; clobbers nzcv, r0-r3, lr; preserves r4-r7 */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803A7B8.yaml
	thumb_func_start sub_803A7B8
sub_803A7B8:
	push {r4-r7,lr}
	bl sub_803BA64
	bl sub_803BA74
	mov r0, #0
	bl sub_803BAE2
	mov r0, #0xa
	bl sub_803B522
	mov r0, #0x26
	bl sub_803B674
	mov r0, #0xb
	bl sub_803B522
	mov r0, #0x27
	bl sub_803B674
	mov r0, #0
	bl sub_803A8B4
	bl sub_803A8E2
	pop {r4-r7,pc}
	thumb_func_end sub_803A7B8

// symdb: A guest-library init/setup sequence that toggles a flag, configures two paletted sprite entries (0xA/0x26 and 0xB/0x27), zeroes a layer state, and calls a finalize routine.
// symdb: void sub_803A7EC(void);  // no in/out registers; clobbers r0-r3, r8, r9, r10-r11, lr; flags NZCV
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803A7EC.yaml
	thumb_func_start sub_803A7EC
sub_803A7EC:
	push {r4-r7,lr}
	bl sub_803BA64
	bl sub_803BA74
	mov r0, #1
	bl sub_803BAE2
	mov r0, #0xa
	bl sub_803B522
	mov r0, #0x26
	bl sub_803B674
	mov r0, #0xb
	bl sub_803B522
	mov r0, #0x27
	bl sub_803B674
	mov r0, #0
	bl sub_803A8B4
	bl sub_803A8E2
	pop {r4-r7,pc}
	thumb_func_end sub_803A7EC

// symdb: Initializes a battle-related module by running two setup helpers, registering two related entries (IDs 10/0x26 and 11/0x27), then kicking off the main init sequence with argument 0.
// symdb: void sub_803A820(void) // r5, r10, lr in; nz,c,v,r0-r3,r8-r12,lr out; r4-r9,r12 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_moduleInit_803A820.yaml
	thumb_func_start battle_moduleInit_803A820
battle_moduleInit_803A820:
	push {r4-r7,lr}
	bl sub_803BA64
	bl sub_803BA74
	mov r0, #0xa
	bl sub_803B522
	mov r0, #0x26
	bl sub_803B674
	mov r0, #0xb
	bl sub_803B522
	mov r0, #0x27
	bl sub_803B674
	mov r0, #0
	bl sub_803A8B4
	bl sub_803A8E2
	pop {r4-r7,pc}
	thumb_func_end battle_moduleInit_803A820

// symdb: Mark a battle object's main action as performed, clear its sub-state, and reset state byte to 0.
// symdb: void battlerFinishAction_803A84E(void* r5); clobbers: r0, N/Z flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803A84E.yaml
	thumb_local_start
sub_803A84E:
	mov r0, #1
	strb r0, [r5,#0x1e]
	mov r0, #0
	strb r0, [r5,#0x1c]
	mov r0, #0
	strb r0, [r5,#2]
	mov pc, lr
	thumb_func_end sub_803A84E

// symdb: Resets a battle object: enables it, clears its pending state byte, and forces anim step 4.
// symdb: void resetObjectPose_803A85C(u8* r5) -> nz r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803A85C.yaml
	thumb_local_start
sub_803A85C:
	mov r0, #1
	strb r0, [r5,#0x1e]
	mov r0, #0
	strb r0, [r5,#0x1c]
	mov r0, #4
	strb r0, [r5,#2]
	mov pc, lr
	thumb_func_end sub_803A85C

	thumb_local_start
sub_803A86A:
	mov r0, #1
	strb r0, [r5,#0x1f]
	mov r0, #0
	strb r0, [r5,#0x1d]
	mov r0, #0
	strb r0, [r5,#2]
	mov pc, lr
	thumb_func_end sub_803A86A

// symdb: Marks a battle object's turn as completed and resets its command/action state.
// symdb: void sub_803A878(void *battle_obj); // r5 in -> r0 out (nz, value 4)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803A878.yaml
	thumb_local_start
sub_803A878:
	mov r0, #1
	strb r0, [r5,#0x1f]
	mov r0, #0
	strb r0, [r5,#0x1d]
	mov r0, #4
	strb r0, [r5,#2]
	mov pc, lr
	thumb_func_end sub_803A878

// symdb: Advances an object through a table-driven step sequence, ticking a countdown per step and reloading the next duration from off_803A910 (8 bytes per entry) until the table terminates.
// symdb: void objectStepTable_803A886(u8 stepIndexField, u8 countdownField, void* obj); // r0 = offset of
// symdb: step-index byte, r1 = offset of countdown byte, r5 = object base // returns nothing; clobbers
// symdb: nz,c,v,r2,r3,r6
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/objectStepTable_803A886.yaml
	thumb_local_start
objectStepTable_803A886:
	ldrb r2, [r5,r0]
	tst r2, r2
	beq locret_803A8B2
	ldrb r2, [r5,r1]
	sub r2, #1
	strb r2, [r5,r1]
	bgt locret_803A8B2
	ldrb r6, [r5,r0]
	add r6, #1
	strb r6, [r5,r0]
	lsl r6, r6, #3
	ldr r3, off_803A90C // =off_803A910
	add r3, r3, r6
	ldr r2, [r3]
	tst r2, r2
	bne loc_803A8AE
	mov r2, #0
	strb r2, [r5,r0]
	strb r2, [r5,r1]
	b locret_803A8B2
loc_803A8AE:
	ldr r2, [r3,#4]
	strb r2, [r5,r1]
locret_803A8B2:
	mov pc, lr
	thumb_func_end objectStepTable_803A886

// symdb: Stamps the object's 2x2 tile graphic onto the background at (j=1, i=1+i_offset).
// symdb: void sub_803A8B4(u32 i_offset /* r0 */, void *obj /* r5 */); // returns r0-r3 and flags as
// symdb: CopyBackgroundTiles left them; r4-r7 preserved; // r10 ignored; lr clobbered.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803A8B4.yaml
	thumb_func_start sub_803A8B4
sub_803A8B4:
	push {r4-r7,lr}
	mov r4, r0
	mov r0, #0x1e
	mov r1, #0x1c
	bl objectStepTable_803A886
	ldrb r6, [r5,#0x1e]
	ldr r3, off_803A90C // =off_803A910
	ldrb r0, [r5,#2]
	tst r0, r0
	bne loc_803A8CC
	ldr r3, off_803A95C // =off_803A960
loc_803A8CC:
	// j
	mov r0, #1
	mov r1, #1
	// i
	add r1, r1, r4
	// tileBlock32x32
	mov r2, #0
	lsl r6, r6, #3
	// tileIds
	ldr r3, [r3,r6]
	mov r4, #2
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	thumb_func_end sub_803A8B4

// symdb: Redraws the 2x2 background tile block for an object based on its current step animation.
// symdb: void sub_803A8E2(struct Object *r5, void *r10, uint32_t lr /* return */); flags out: NZ C V
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803A8E2.yaml
	thumb_local_start
sub_803A8E2:
	push {r4-r7,lr}
	mov r0, #0x1f
	mov r1, #0x1d
	bl objectStepTable_803A886
	ldrb r7, [r5,#0x1f]
	ldr r3, off_803A90C // =off_803A910
	ldrb r0, [r5,#2]
	tst r0, r0
	bne loc_803A8F8
	ldr r3, off_803A95C // =off_803A960
loc_803A8F8:
	// j
	mov r0, #1
	// i
	mov r1, #4
	// tileBlock32x32
	mov r2, #0
	lsl r7, r7, #3
	// tileIds
	ldr r3, [r3,r7]
	mov r4, #2
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_803A90C:
	.word off_803A910
off_803A910:
	.word byte_803A9AC
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word byte_803A9C4
	.word 0x1
	.word byte_803A9BC
	.word 0x1
	.word byte_803A9B4
	.word 0x1
	.word byte_803A9AC
	.word 0x2
	.word byte_803A9C4
	.word 0x2
	.word byte_803A9BC
	.word 0x2
	.word byte_803A9B4
	.word 0x2
	.word 0x0
off_803A95C:
	.word off_803A960
off_803A960:
	.word byte_803A9AC
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word byte_803A9B4
	.word 0x1
	.word byte_803A9BC
	.word 0x1
	.word byte_803A9C4
	.word 0x1
	.word byte_803A9AC
	.word 0x2
	.word byte_803A9B4
	.word 0x2
	.word byte_803A9BC
	.word 0x2
	.word byte_803A9C4
	.word 0x2
	.word 0x0
byte_803A9AC:
	.byte 0xB0, 0x42, 0xB1, 0x42, 0xB2, 0x42, 0xB3, 0x42
byte_803A9B4:
	.byte 0xB4, 0x42, 0xB5, 0x42, 0xB6, 0x42, 0xB7, 0x42
byte_803A9BC:
	.byte 0xB8, 0x42, 0xB9, 0x42, 0xBA, 0x42, 0xBB, 0x42
byte_803A9C4:
	.byte 0xBC, 0x42, 0xBD, 0x42, 0xBE, 0x42, 0xBF, 0x42
	thumb_func_end sub_803A8E2

	thumb_local_start
sub_803A9CC:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803A9E0
	bl sub_803BB80
	beq loc_803A9E0
	mov r0, #0xc
	strb r0, [r5,#1]
loc_803A9E0:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end sub_803A9CC

// symdb: Per-frame update for the in-battle chip-select menu: poll the folder cursor and dispatch any button press to a handler, then advance the battle scene and draw the overlay frame.
// symdb: (r0 = 0) -> r0 = clobbered; returns to caller after running the selected handler and the
// symdb: scene/draw updates
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/submenu_chipSelectFrameUpdate.yaml
	thumb_local_start
submenu_chipSelectFrameUpdate:
	push {r4-r7,lr}
	mov r0, #0
	bl submenu_chipSelectCursorMove
	beq loc_803A9FA
	ldr r1, off_803AA08 // =dword_803AA0C
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
loc_803A9FA:
	bl sub_803A7B8
	mov r0, #0
	bl sub_803BC7C
	pop {r4-r7,pc}
	.balign 4, 0
off_803AA08:
	.word dword_803AA0C
dword_803AA0C:
	.word 0x0
	.word handleExitSubmenu_803AA24+1
	.word battleObj_dispatchSubstate_803AA40+1
	.word sub_803ABF4+1
	.word sub_803AB6C+1
	.word sub_803AB94+1
	thumb_func_end submenu_chipSelectFrameUpdate

// symdb: Handles closing/exiting a submenu: confirms the close, clears a state byte, plays the exit-submenu sound, and runs sub_803A84E.
// symdb: void handleExitSubmenu_803AA24(void); // inputs:  r2, r5, lr // outputs: r5, r10 // clobbers:
// symdb: NZCV, r0, r1, r2, r3, lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/handleExitSubmenu_803AA24.yaml
	thumb_func_start handleExitSubmenu_803AA24
handleExitSubmenu_803AA24:
	push {r4-r7,lr}
	mov r0, #0x10
	mov r1, #0x30
	bl sub_803C068
	beq locret_803AA3E
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #SOUND_EXIT_SUBMENU
	bl PlaySoundEffect
	bl sub_803A84E
locret_803AA3E:
	pop {r4-r7,pc}
	thumb_func_end handleExitSubmenu_803AA24

// symdb: Dispatches a battle-object handler based on its substate byte ([r5+8]) via a Thumb-mode jump table.
// symdb: void battleObj_dispatchSubstate(u32 r2, struct* r4, struct* r5, u32 r10, lr); // clobbers
// symdb: r0,r1,r2,r3,r8,r9,r11,r12,lr; nz,c,v
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battleObj_dispatchSubstate_803AA40.yaml
	thumb_func_start battleObj_dispatchSubstate_803AA40
battleObj_dispatchSubstate_803AA40:
	push {r4-r7,lr}
	ldrb r0, [r5,#8]
	mov r1, #0
	cmp r0, #0x3f
	beq loc_803AA70
	add r1, #4
	cmp r0, #0x40
	beq loc_803AA70
	add r1, #4
	cmp r0, #0x3c
	beq loc_803AA70
	add r1, #4
	cmp r0, #0x3a
	beq loc_803AA70
	add r1, #4
	cmp r0, #0x3b
	beq loc_803AA70
	add r1, #4
	cmp r0, #0x3d
	beq loc_803AA70
	add r1, #4
	cmp r0, #0x3e
	beq loc_803AA70
	add r1, #4
loc_803AA70:
	ldr r0, off_803AA7C // =off_803AA80
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803AA7C:
	.word off_803AA80
off_803AA80:
	.word jackInPetMenuSelectState_803AAA0+1
	.word sub_803AAD8+1
	.word submenu_toggleMode+1
	.word sub_803AB20+1
	.word sub_803AB46+1
	.word sub_803AB6C+1
	.word sub_803AB94+1
	.word shopBuyMenu_confirm_803ABB4+1
	thumb_func_end battleObj_dispatchSubstate_803AA40

// symdb: Handles the Pet Accessory menu's jack-in attempt: branches on success/failure to play a sound, queue a dialog/state message, and write the next state byte to the menu's state field (r5+1).
// symdb: void sub_803AAA0(void); // inputs: r2 r4 r5 r10 lr // outputs: r10 // clobbers: nz c v r0 r1 r2
// symdb: r3 lr // preserved: r4 r5 r6 r7 r10
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/jackInPetMenuSelectState_803AAA0.yaml
	thumb_local_start
jackInPetMenuSelectState_803AAA0:
	push {r4-r7,lr}
	mov r0, #0x30
	bl sub_803C248
	bne loc_803AAC6
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r0, #0x16
	bl sub_803BB2C
	mov r0, #0x30
	mov r1, #0x70
	mov r2, #0x20
	bl sub_803C0F6
	mov r0, #0x18
	strb r0, [r5,#1]
	pop {r4-r7,pc}
loc_803AAC6:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	mov r0, #0x14
	bl sub_803BB2C
	mov r0, #0x1c
	strb r0, [r5,#1]
	pop {r4-r7,pc}
	thumb_func_end jackInPetMenuSelectState_803AAA0

	thumb_local_start
sub_803AAD8:
	push {r4-r7,lr}
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r4, #0x1a
	bl sub_803C3E0
	beq loc_803AAEA
	mov r4, #0x18
loc_803AAEA:
	mov r0, r4
	bl sub_803BB2C
	mov r0, #0x10
	strb r0, [r5,#1]
	pop {r4-r7,pc}
	thumb_func_end sub_803AAD8

// symdb: Plays the cursor-move sound, flips a mode flag in a menu state struct, and reconfigures one of two groups of menu slots depending on the new state.
// symdb: (r5 = menu/UI state struct; r0 unused on entry) -> r0 = new state (0/1) after toggle via
// symdb: PlaySoundEffect call; flags clobbered by calls
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/submenu_toggleMode.yaml
	thumb_local_start
submenu_toggleMode:
	push {r4-r7,lr}
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	ldrb r0, [r5,#0x12]
	mov r1, #1
	eor r0, r1
	strb r0, [r5,#0x12]
	cmp r0, #0
	beq loc_803AB0C
	b loc_803AB16
loc_803AB0C:
	bl sub_803A752
	bl sub_803A764
	b locret_803AB1E
loc_803AB16:
	bl sub_803A776
	bl sub_803A788
locret_803AB1E:
	pop {r4-r7,pc}
	thumb_func_end submenu_toggleMode

	thumb_local_start
sub_803AB20:
	push {r4-r7,lr}
	mov r0, #0
	mov r1, #0x30
	mov r2, #0x10
	bl sub_803BFA0
	beq loc_803AB3E
	mov r0, #0x20
	strb r0, [r5,#0x13]
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	bl sub_803A85C
	pop {r4-r7,pc}
loc_803AB3E:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	pop {r4-r7,pc}
	thumb_func_end sub_803AB20

	thumb_local_start
sub_803AB46:
	push {r4-r7,lr}
	mov r0, #1
	mov r1, #0x30
	mov r2, #0x10
	bl sub_803BFA0
	beq loc_803AB64
	mov r0, #0x20
	strb r0, [r5,#0x13]
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	bl sub_803A85C
	pop {r4-r7,pc}
loc_803AB64:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	pop {r4-r7,pc}
	thumb_func_end sub_803AB46

	thumb_func_start sub_803AB6C
sub_803AB6C:
	push {r4-r7,lr}
	ldrb r4, [r5,#0x10]
	ldrh r1, [r5,#0x24]
	add r0, r4, #1
	cmp r0, r1
	bgt loc_803AB8E
	strb r0, [r5,#0x10]
	mov r0, #0x10
	mov r1, #0x30
	bl sub_803C040
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	pop {r4-r7,pc}
loc_803AB8E:
	bl markBattleObjCurDone_803ABDC
	pop {r4-r7,pc}
	thumb_func_end sub_803AB6C

	thumb_func_start sub_803AB94
sub_803AB94:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x10]
	sub r0, #1
	blt locret_803ABB2
	strb r0, [r5,#0x10]
	mov r0, #0x10
	mov r1, #0x30
	bl sub_803C0BE
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	b locret_803ABB2
locret_803ABB2:
	pop {r4-r7,pc}
	thumb_func_end sub_803AB94

// symdb: Shop/buy-menu confirm handler: plays the menu-select sound and runs the purchase callbacks when a shop slot is chosen, otherwise delegates to a sibling handler.
// symdb: void sub_803ABB4(void); /* inputs: r2, r5 (object ptr), lr; outputs/clobbers: r10 preserved,
// symdb: nz/c/v trashed, r0/r1/lr clobbered */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/shopBuyMenu_confirm_803ABB4.yaml
	thumb_local_start
shopBuyMenu_confirm_803ABB4:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x10]
	ldrh r1, [r5,#0x24]
	cmp r0, r1
	bge loc_803ABD6
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #0x10
	mov r1, #0x30
	bl sub_803BF70
	bl sub_803A85C
	pop {r4-r7,pc}
loc_803ABD6:
	bl markBattleObjCurDone_803ABDC
	pop {r4-r7,pc}
	thumb_func_end shopBuyMenu_confirm_803ABB4

// symdb: Marks a battle object as finished with its current action, playing the cur-move sound once.
// symdb: void sub_803ABDC(u32 r2; void *r5 /* battle object */; lr); clobbers r0, nz/c/v
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/markBattleObjCurDone_803ABDC.yaml
	thumb_local_start
markBattleObjCurDone_803ABDC:
	push {r4-r7,lr}
	ldrb r0, [r5,#8]
	cmp r0, #0x3f
	beq locret_803ABF2
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #0x3f
	strb r0, [r5,#8]
locret_803ABF2:
	pop {r4-r7,pc}
	thumb_func_end markBattleObjCurDone_803ABDC

// symdb: Plays the cursor/grid-slide sound effect (SFX SOUND_CUR_MOVE_80) and writes 0x3F to the panel-slot byte at r5+8 to mark it filled.
// symdb: void sub_803ABF4(void); // inputs: r5 (panel-slot pointer), r2, lr; outputs: r5, r10; clobbers
// symdb: NZCV, r0, lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803ABF4.yaml
	thumb_func_start sub_803ABF4
sub_803ABF4:
	push {r4-r7,lr}
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	mov r0, #0x3f
	strb r0, [r5,#8]
	pop {r4-r7,pc}
	thumb_func_end sub_803ABF4

// symdb: Battle-start transition step: fades the screen (or skips if a cutscene state is active), records the next state, then initializes the battle module.
// symdb: (r0 = flag mask 0x80 passed to chatbox flag check; r5 = global state-machine context pointer) ->
// symdb: r0 = battle_moduleInit result; [r5+1] set to next state byte
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_startTransitionStep.yaml
	thumb_local_start
battle_startTransitionStep:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803AC26
	bl chatbox_GetState_8045F4C
	cmp r0, #0
	beq loc_803AC1A
	mov r0, #0xc
	strb r0, [r5,#1]
	b loc_803AC26
loc_803AC1A:
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x14
	strb r0, [r5,#1]
loc_803AC26:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end battle_startTransitionStep

	thumb_local_start
sub_803AC2C:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803AC50
	bl sub_803BA28
	bl sub_803C3E0
	beq loc_803AC48
	mov r0, #8
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
	b loc_803AC50
loc_803AC48:
	mov r0, #4
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_803AC50:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end sub_803AC2C

// symdb: Records a launch-context byte (chatbox/cutscene vs normal) into the battle struct and then initializes the battle module.
// symdb: (r0 = unused flag arg consumed by helper; r5 = battle work struct pointer set up by caller) ->
// symdb: r0 = result of battle_moduleInit_803A820; writes mode byte to [r5+1]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_startInit.yaml
	thumb_local_start
battle_startInit:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803AC72
	bl chatbox_GetState_8045F4C
	cmp r0, #0
	beq loc_803AC6E
	mov r0, #0xc
	strb r0, [r5,#1]
	b loc_803AC72
loc_803AC6E:
	mov r0, #0x20
	strb r0, [r5,#1]
loc_803AC72:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end battle_startInit

	thumb_local_start
sub_803AC78:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803AC9C
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #0x10
	mov r1, #0x30
	bl sub_803C0BE
	mov r0, #0x10
	mov r1, #0x30
	bl sub_803C132
	strb r0, [r5,#0x10]
	mov r0, #0xc
	strb r0, [r5,#1]
loc_803AC9C:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end sub_803AC78

	thumb_local_start
sub_803ACA2:
	push {r4-r7,lr}
	mov r0, #0
	strb r0, [r5,#8]
	mov r0, #0x24
	strb r0, [r5,#1]
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end sub_803ACA2

	thumb_local_start
sub_803ACB2:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803ACC0
	mov r0, #0x28
	strb r0, [r5,#1]
loc_803ACC0:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end sub_803ACB2

// symdb: Per-frame update for the guest-library chip-select screen: polls the folder cursor for button input, dispatches to a button handler via jump table, and otherwise runs the screen's init and overlay-tile draw steps.
// symdb: (r0 = 0 passed to cursor-move poll) -> r0 = handler/button result discarded; no meaningful
// symdb: return; calls into state handlers via blx
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/submenu_guestLibraryFrameUpdate.yaml
	thumb_local_start
submenu_guestLibraryFrameUpdate:
	push {r4-r7,lr}
	mov r0, #0
	bl submenu_chipSelectCursorMove
	beq loc_803ACDA
	ldr r1, off_803ACE8 // =dword_803ACEC
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
loc_803ACDA:
	bl sub_803A7EC
	mov r0, #0
	bl sub_803BC7C
	pop {r4-r7,pc}
	.balign 4, 0
off_803ACE8:
	.word dword_803ACEC
dword_803ACEC:
	.word 0x0
	.word sub_803AD04+1
	.word chipSelect_dispatchState_803AD20+1
	.word sub_803AED8+1
	.word sub_803AE50+1
	.word sub_803AE78+1
	thumb_func_end submenu_guestLibraryFrameUpdate

	thumb_func_start sub_803AD04
sub_803AD04:
	push {r4-r7,lr}
	mov r0, #0x11
	mov r1, #0x90
	bl sub_803C068
	beq locret_803AD1E
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #SOUND_EXIT_SUBMENU
	bl PlaySoundEffect
	bl sub_803A86A
locret_803AD1E:
	pop {r4-r7,pc}
	thumb_func_end sub_803AD04

// symdb: Dispatches to one of seven chip-select screen handlers based on the state byte at r5+0x08.
// symdb: void sub_803AD20(void);  // uses caller-supplied r2/r4/r5/r10 and lr; outputs/clobbers
// symdb: r5/r8/r9/r10/r11/r12 + flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chipSelect_dispatchState_803AD20.yaml
	thumb_func_start chipSelect_dispatchState_803AD20
chipSelect_dispatchState_803AD20:
	push {r4-r7,lr}
	ldrb r0, [r5,#8]
	mov r1, #0
	cmp r0, #0x3f
	beq loc_803AD50
	add r1, #4
	cmp r0, #0x40
	beq loc_803AD50
	add r1, #4
	cmp r0, #0x3c
	beq loc_803AD50
	add r1, #4
	cmp r0, #0x3a
	beq loc_803AD50
	add r1, #4
	cmp r0, #0x3b
	beq loc_803AD50
	add r1, #4
	cmp r0, #0x3d
	beq loc_803AD50
	add r1, #4
	cmp r0, #0x3e
	beq loc_803AD50
	add r1, #4
loc_803AD50:
	ldr r0, off_803AD5C // =off_803AD60
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803AD5C:
	.word off_803AD60
off_803AD60:
	.word handleMenuAction90_803AD80+1
	.word sub_803ADB8+1
	.word sub_803ADDA+1
	.word sub_803AE04+1
	.word sub_803AE2A+1
	.word sub_803AE50+1
	.word sub_803AE78+1
	.word menuSelectElement_803AE98+1
	thumb_func_end chipSelect_dispatchState_803AD20

// symdb: Menu input handler that attempts action 0x90 and branches to a confirm (0x34) or deny (0x38) sub-state with matching SFX.
// symdb: void handleMenuAction90_803AD80(uint32_t r2, struct* r4, struct* r5, void* r10, lr) -> void (r10
// symdb: preserved); clobbers r0/r1/r2/r3/lr and nz/c/v
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/handleMenuAction90_803AD80.yaml
	thumb_local_start
handleMenuAction90_803AD80:
	push {r4-r7,lr}
	mov r0, #0x90
	bl sub_803C248
	bne loc_803ADA6
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r0, #0x17
	bl sub_803BB2C
	mov r0, #0x90
	mov r1, #0xd0
	mov r2, #0x20
	bl sub_803C0F6
	mov r0, #0x34
	strb r0, [r5,#1]
	pop {r4-r7,pc}
loc_803ADA6:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	mov r0, #0x15
	bl sub_803BB2C
	mov r0, #0x38
	strb r0, [r5,#1]
	pop {r4-r7,pc}
	thumb_func_end handleMenuAction90_803AD80

	thumb_local_start
sub_803ADB8:
	push {r4-r7,lr}
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r4, #0x1b
	bl sub_803C3E0
	beq loc_803ADCA
	mov r4, #0x19
loc_803ADCA:
	mov r0, r4
	bl sub_803BB2C
	mov r0, #0
	strb r0, [r5,#3]
	mov r0, #0x2c
	strb r0, [r5,#1]
	pop {r4-r7,pc}
	thumb_func_end sub_803ADB8

	thumb_local_start
sub_803ADDA:
	push {r4-r7,lr}
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	ldrb r0, [r5,#0x12]
	mov r1, #1
	eor r0, r1
	strb r0, [r5,#0x12]
	cmp r0, #0
	beq loc_803ADF0
	b loc_803ADFA
loc_803ADF0:
	bl sub_803A752
	bl sub_803A764
	b locret_803AE02
loc_803ADFA:
	bl sub_803A776
	bl sub_803A788
locret_803AE02:
	pop {r4-r7,pc}
	thumb_func_end sub_803ADDA

	thumb_local_start
sub_803AE04:
	push {r4-r7,lr}
	mov r0, #0
	mov r1, #0x90
	mov r2, #0x11
	bl sub_803BFA0
	beq loc_803AE22
	mov r0, #0x20
	strb r0, [r5,#0x13]
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	bl sub_803A878
	pop {r4-r7,pc}
loc_803AE22:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	pop {r4-r7,pc}
	thumb_func_end sub_803AE04

	thumb_local_start
sub_803AE2A:
	push {r4-r7,lr}
	mov r0, #1
	mov r1, #0x90
	mov r2, #0x11
	bl sub_803BFA0
	beq loc_803AE48
	mov r0, #0x20
	strb r0, [r5,#0x13]
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	bl sub_803A878
	pop {r4-r7,pc}
loc_803AE48:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	pop {r4-r7,pc}
	thumb_func_end sub_803AE2A

	thumb_func_start sub_803AE50
sub_803AE50:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x11]
	add r0, #1
	ldrh r1, [r5,#0x26]
	cmp r0, r1
	bgt loc_803AE72
	strb r0, [r5,#0x11]
	mov r0, #0x11
	mov r1, #0x90
	bl sub_803C040
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	pop {r4-r7,pc}
loc_803AE72:
	bl sub_803AEC0
	pop {r4-r7,pc}
	thumb_func_end sub_803AE50

	thumb_func_start sub_803AE78
sub_803AE78:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x11]
	sub r0, #1
	blt locret_803AE96
	strb r0, [r5,#0x11]
	mov r0, #0x11
	mov r1, #0x90
	bl sub_803C0BE
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	b locret_803AE96
locret_803AE96:
	pop {r4-r7,pc}
	thumb_func_end sub_803AE78

// symdb: Handles the "select" action on a UI list element: if its current index is below its max, plays a select SFX, clears a flag, opens sub-window 0x11 with ID 0x90, then refreshes the menu; otherwise defers to the overflow handler.
// symdb: void menuSelectElement_803AE98(u32 r2, Element* r5, u32 lr) -> r10 preserved; NZCV clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/menuSelectElement_803AE98.yaml
	thumb_local_start
menuSelectElement_803AE98:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x11]
	ldrh r1, [r5,#0x26]
	cmp r0, r1
	bge loc_803AEBA
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #0x11
	mov r1, #0x90
	bl sub_803BF70
	bl sub_803A878
	pop {r4-r7,pc}
loc_803AEBA:
	bl sub_803AEC0
	pop {r4-r7,pc}
	thumb_func_end menuSelectElement_803AE98

	thumb_local_start
sub_803AEC0:
	push {r4-r7,lr}
	ldrb r0, [r5,#8]
	cmp r0, #0x3f
	beq locret_803AED6
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #0x3f
	strb r0, [r5,#8]
locret_803AED6:
	pop {r4-r7,pc}
	thumb_func_end sub_803AEC0

// symdb: Plays the cursor-move SFX (SOUND_CUR_MOVE_80) and marks the object as having already triggered its movement-cursor SFX this step by writing 0x3F to its byte flag.
// symdb: void playCurMoveSfx_803AED8(struct Obj* r5, uint32_t r2, uint32_t lr); flags clobbered (NZCV),
// symdb: r5 and r10 preserved; sets r0 (sound id) for PlaySoundEffect, lr clobbered by bl.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803AED8.yaml
	thumb_func_start sub_803AED8
sub_803AED8:
	push {r4-r7,lr}
	mov r0, #SOUND_CUR_MOVE_80
	bl PlaySoundEffect
	mov r0, #0x3f
	strb r0, [r5,#8]
	pop {r4-r7,pc}
	thumb_func_end sub_803AED8

// symdb: Waits for any chatbox/cutscene to finish, then triggers the fade-in into battle and sets a frame delay, running the battle module step afterwards.
// symdb: (r5 = battle-context struct pointer, preserved from caller; r0/r1 scratch) -> writes frame-delay
// symdb: counter to [r5+1]; calls SetScreenFade and battle_moduleInit_803A820; branches on chatbox flag
// symdb: Z/NZ
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_startFadeIn.yaml
	thumb_local_start
battle_startFadeIn:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803AF16
	ldrb r0, [r5,#3]
	cmp r0, #1
	beq loc_803AF12
	bl chatbox_GetState_8045F4C
	cmp r0, #0
	beq loc_803AF04
	mov r0, #0x28
	strb r0, [r5,#1]
	b loc_803AF16
loc_803AF04:
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x30 
	strb r0, [r5,#1]
	b loc_803AF16
loc_803AF12:
	mov r0, #0xc
	strb r0, [r5,#1]
loc_803AF16:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end battle_startFadeIn

	thumb_local_start
sub_803AF1C:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803AF40
	bl sub_803BA28
	bl sub_803C3E0
	beq loc_803AF38
	mov r0, #8
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
	b loc_803AF40
loc_803AF38:
	mov r0, #4
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_803AF40:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end sub_803AF1C

	thumb_local_start
sub_803AF46:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803AF6A
	bl chatbox_GetState_8045F4C
	cmp r0, #0
	beq loc_803AF5E
	mov r0, #0x28
	strb r0, [r5,#1]
	b loc_803AF6A
loc_803AF5E:
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x3c 
	strb r0, [r5,#1]
loc_803AF6A:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end sub_803AF46

// symdb: Conditionally resets some battle-state bytes/compacts a list when flag 0x80 of eFlags2009F38 is clear, then initializes the battle module.
// symdb: (r0 = scratch for flag test; r5 = state struct pointer, set by caller) -> r0 = clobbered by
// symdb: calls; flags set by the flag test only before the unconditional init call
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_condInitModule.yaml
	thumb_local_start
battle_condInitModule:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_803AF8A
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #0x11
	mov r1, #0x90
	bl sub_803C0BE
	mov r0, #0x28
	strb r0, [r5,#1]
loc_803AF8A:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end battle_condInitModule

	thumb_local_start
sub_803AF90:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803AFBC
	mov r4, #0
	bl sub_803C3E0
	beq loc_803AFA2
	mov r4, #1
loc_803AFA2:
	strb r4, [r5,#4]
	bl sub_803C40C
	bl sub_803C3E8
	bl sub_803C3D8
	bl sub_803F9E4
	mov r0, #8
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_803AFBC:
	bl battle_moduleInit_803A820
	pop {r4-r7,pc}
	thumb_func_end sub_803AF90

// symdb: Moves the chip-select/folder grid cursor in response to the D-pad and returns which button (B/A/Start/L/R) was pressed for the caller's state dispatcher.
// symdb: (r0 = cursor-table index (0..1, callers pass 0); r5 = menu-state object: cursor slot at +8,
// symdb: previous slot at +9; joypad via toolkit at r10) -> r0 = 0 if no action, else 1=B, 2=A, 3=Start,
// symdb: 4=L, 5=R; flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/submenu_chipSelectCursorMove.yaml
	thumb_func_start submenu_chipSelectCursorMove
submenu_chipSelectCursorMove:
	push {r4-r7,lr}
	lsl r6, r0, #2
	ldrb r0, [r5,#8]
	strb r0, [r5,#9]
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	ldrh r3, [r7,#2]
	ldrh r7, [r7,#4]
	mov r4, #0
	mov r0, #2
	tst r0, r7
	beq loc_803AFDE
	mov r4, #1
	b loc_803B03A
loc_803AFDE:
	mov r0, #1
	tst r0, r7
	beq loc_803AFE8
	mov r4, #2
	b loc_803B03A
loc_803AFE8:
	mov r0, #8
	tst r0, r3
	beq loc_803AFF2
	mov r4, #3
	b loc_803B03A
loc_803AFF2:
	mov r0, #0x10
	lsl r0, r0, #4
	tst r0, r7
	beq loc_803AFFE
	mov r4, #4
	b loc_803B03A
loc_803AFFE:
	mov r0, #0x20
	lsl r0, r0, #4
	tst r0, r7
	beq loc_803B00A
	mov r4, #5
	b loc_803B03A
loc_803B00A:
	mov r0, #0xf0
	tst r0, r7
	beq loc_803B03A
	mov r3, #0
	mov r0, #0x40
	tst r0, r7
	bne loc_803B02A
	mov r3, #1
	mov r0, #0x80
	tst r0, r7
	bne loc_803B02A
	mov r3, #2
	mov r0, #0x20
	tst r0, r7
	bne loc_803B02A
	mov r3, #3
loc_803B02A:
	ldr r0, off_803B050 // =off_803B054
	ldr r0, [r0,r6]
	ldrb r1, [r5,#8]
	lsl r1, r1, #2
	add r0, r0, r1
	ldrb r0, [r0,r3]
	strb r0, [r5,#8]
	b loc_803B03A
loc_803B03A:
	ldrb r0, [r5,#8]
	ldrb r1, [r5,#9]
	cmp r0, r1
	beq loc_803B048
	mov r0, #SOUND_MENU_CUR_MOVE
	bl PlaySoundEffect
loc_803B048:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803B050:
	.word off_803B054
off_803B054:
	.word byte_803B05C
	.word byte_803B05C
byte_803B05C:
	.byte 0x19, 0x5, 0x3D, 0x1, 0x15, 0x6, 0x0, 0x2, 0x16, 0x7, 0x1, 0x3, 0x17
	.byte 0x8, 0x2, 0x4, 0x18, 0x9, 0x3, 0x1E, 0x0, 0xA, 0x3E, 0x6, 0x1, 0xB
	.byte 0x5, 0x7, 0x2, 0xC, 0x6, 0x8, 0x3, 0xD, 0x7, 0x9, 0x4, 0xE, 0x8
	.byte 0x23, 0x5, 0xF, 0x3F, 0xB, 0x6, 0x10, 0xA, 0xC, 0x7, 0x11, 0xB, 0xD
	.byte 0x8, 0x12, 0xC, 0xE, 0x9, 0x13, 0xD, 0x28, 0xA, 0x14, 0x40, 0x10, 0xB
	.byte 0x15, 0xF, 0x11, 0xC, 0x16, 0x10, 0x12, 0xD, 0x17, 0x11, 0x13, 0xE, 0x18
	.byte 0x12, 0x2D, 0xF, 0x19, 0x36, 0x15, 0x10, 0x1, 0x14, 0x16, 0x11, 0x2, 0x15
	.byte 0x17, 0x12, 0x3, 0x16, 0x18, 0x13, 0x4, 0x17, 0x32, 0x14, 0x0, 0x37, 0x37
	.byte 0x15, 0x1, 0x19, 0x1B, 0x16, 0x2, 0x1A, 0x1C, 0x17, 0x3, 0x1B, 0x1D, 0x18
	.byte 0x4, 0x1C, 0x37, 0x37, 0x23, 0x4, 0x1F, 0x33, 0x24, 0x1E, 0x20, 0x34, 0x25
	.byte 0x1F, 0x21, 0x35, 0x26, 0x20, 0x22, 0x36, 0x27, 0x21, 0x3D, 0x1E, 0x28, 0x9
	.byte 0x24, 0x1F, 0x29, 0x23, 0x25, 0x20, 0x2A, 0x24, 0x26, 0x21, 0x2B, 0x25, 0x27
	.byte 0x22, 0x2C, 0x26, 0x3E, 0x23, 0x2D, 0xE, 0x29, 0x24, 0x2E, 0x28, 0x2A, 0x25
	.byte 0x2F, 0x29, 0x2B, 0x26, 0x30, 0x2A, 0x2C, 0x27, 0x31, 0x2B, 0x3F, 0x28, 0x32
	.byte 0x13, 0x2E, 0x29, 0x33, 0x2D, 0x2F, 0x2A, 0x34, 0x2E, 0x30, 0x2B, 0x35, 0x2F
	.byte 0x31, 0x2C, 0x36, 0x30, 0x40, 0x2D, 0x37, 0x18, 0x33, 0x2E, 0x1F, 0x32, 0x34
	.byte 0x2F, 0x20, 0x33, 0x35, 0x30, 0x21, 0x34, 0x36, 0x31, 0x22, 0x35, 0x14, 0x32
	.byte 0x1E, 0x19, 0x19, 0x33, 0x1F, 0x37, 0x39, 0x34, 0x20, 0x38, 0x19, 0x35, 0x21
	.byte 0x39, 0x3B, 0x36, 0x22, 0x3A, 0x19, 0x40, 0x3D, 0x22, 0x0, 0x40, 0x3E, 0x22
	.byte 0x0, 0x3D, 0x3F, 0x27, 0x5, 0x3E, 0x40, 0x2C, 0xA, 0x3F, 0x3D, 0x31, 0xF
	thumb_func_end submenu_chipSelectCursorMove

	thumb_local_start
sub_803B160:
	push {r4-r7,lr}
	ldr r0, off_803B170 // =off_803B174
	ldrb r1, [r5,#1]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.byte 0, 0
off_803B170:
	.word off_803B174
off_803B174:
	.word sub_803B184+1
	.word sub_803B1C4+1
	.word sub_803B1D6+1
	.word sub_803B1F8+1
	thumb_func_end sub_803B160

	thumb_local_start
sub_803B184:
	push {r4-r7,lr}
	ldr r0, dword_803B1C0 // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()
	mov r0, #0x14
	bl toolkit_applyOverlayPalette_80015FC
	mov r3, r10
	ldr r3, [r3,#oToolkit_RenderInfoPtr]
	mov r0, #4
	strh r0, [r3,#0x12]
	strh r0, [r3,#0x16]
	strh r0, [r3,#0x1a]
	bl copyData_803B45C
	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x5a 
	bl sub_803BB2C
	mov r0, #4
	strb r0, [r5,#1]
	pop {r4-r7,pc}
	.balign 4, 0
dword_803B1C0:
	.word 0x1F40
	thumb_func_end sub_803B184

	thumb_local_start
sub_803B1C4:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803B1D0
	mov r0, #8
	strb r0, [r5,#1]
loc_803B1D0:
	bl sub_803B518
	pop {r4-r7,pc}
	thumb_func_end sub_803B1C4

	thumb_local_start
sub_803B1D6:
	push {r4-r7,lr}
	mov r0, #8
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	beq loc_803B1F2
	mov r0, #SOUND_UNSELECT_68
	bl PlaySoundEffect
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0xc
	strb r0, [r5,#1]
loc_803B1F2:
	bl sub_803B518
	pop {r4-r7,pc}
	thumb_func_end sub_803B1D6

	thumb_local_start
sub_803B1F8:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_803B210
	bl chatbox_8040818
	mov r0, #2
	strb r0, [r5,#4]
	mov r0, #8
	strb r0, [r5]
	mov r0, #0
	strb r0, [r5,#1]
loc_803B210:
	bl sub_803B518
	pop {r4-r7,pc}
	thumb_func_end sub_803B1F8

	thumb_local_start
copyData_803B216:
	push {r4-r7,lr}
	bl zeroFillVRAM // () -> ()
	bl ZeroFillGFX30025c0
	bl copyMemory_8001850
	// initRefs
	ldr r0, off_803B240 // =initRefs_803B244
	bl decompAndCopyData // (u32 *initRefs) -> void
	mov r0, #0
	bl sub_803B91C
	mov r0, #1
	bl sub_803B91C
	mov r0, #2
	bl sub_803B91C
	pop {r4-r7,pc}
	.balign 4, 0
off_803B240:
	.word initRefs_803B244
initRefs_803B244:
	.word comp_87E4500 + COMPRESSED_PTR_FLAG
	.word 0x6004000
	.word DecompBuf_2027A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word 0x6000020
	.word DecompBuf_2027A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2028200

	.word comp_87E5020 + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2028A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2029200

	.word dword_87E4FE0
	.word unk_30019A0
	.word 0x40

	.word spriteWhiteDot
	.word palette_3001960
	.word 0x40

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word 0x6011000
	.word DecompBuf_2027A00

	.word byte_86A4D40
	.word 0x6010020
	.word 0x240

	.word dword_86A4A40
	.word 0x6010300
	.word 0x100

	.word dword_86A5500
	.word byte_3001550
	.word 0x20

	.word byte_87E5000
	.word byte_30016D0
	.word 0x20

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2032A00

	.word NULL
	thumb_func_end copyData_803B216

	thumb_local_start
copyData_803B2E4:
	push {r4-r7,lr}
	bl zeroFillVRAM // () -> ()
	bl ZeroFillGFX30025c0
	bl copyMemory_8001850
	// initRefs
	ldr r0, off_803B30C // =initRefs_803B310
	bl decompAndCopyData // (u32 *initRefs) -> void
	mov r0, #4
	bl sub_803B91C
	mov r0, #5
	bl sub_803B91C
	mov r0, #0
	strb r0, [r5,#0x18]
	pop {r4-r7,pc}
	.balign 4, 0
off_803B30C:
	.word initRefs_803B310
initRefs_803B310:
	.word comp_87E57BC + COMPRESSED_PTR_FLAG
	.word 0x6004000
	.word DecompBuf_2027A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word 0x6000020
	.word DecompBuf_2027A00

	.word comp_87E6840 + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2028200

	.word comp_87E674C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2028A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2029200

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2029A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2029E00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_202A200

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_202A600

	.word dword_87E660C
	.word unk_30019C0
	.word 0x140

	.word spriteWhiteDot
	.word palette_3001980
	.word 0x40

	.word byte_86A5180
	.word 0x6010020
	.word 0x180

	.word comp_87E6924 + COMPRESSED_PTR_FLAG
	.word 0x6010280
	.word DecompBuf_2027A00

	.word dword_86A5500
	.word byte_3001550
	.word 0x20

	.word dword_87E660C
	.word byte_30015D0
	.word 0x120

	.word NULL
	thumb_func_end copyData_803B2E4

	thumb_local_start
copyData_803B3C8:
	push {r4-r7,lr}
	bl zeroFillVRAM // () -> ()
	bl ZeroFillGFX30025c0
	bl copyMemory_8001850
	// initRefs
	ldr r0, off_803B400 // =initRefs_803B404
	bl decompAndCopyData // (u32 *initRefs) -> void
	mov r3, r10
	ldr r3, [r3,#oToolkit_RenderInfoPtr]
	ldrh r0, [r3,#0x16]
	sub r0, #4
	strh r0, [r3,#0x16]
	ldrh r0, [r3,#0x14]
	sub r0, #2
	strh r0, [r3,#0x14]
	ldrh r0, [r3,#0x1a]
	sub r0, #2
	strh r0, [r3,#0x1a]
	ldrh r0, [r3,#0x18]
	sub r0, #4
	strh r0, [r3,#0x18]
	mov r0, #3
	bl sub_803B91C
	pop {r4-r7,pc}
	.balign 4, 0
off_803B400:
	.word initRefs_803B404
initRefs_803B404:
	.word comp_87E50D4 + COMPRESSED_PTR_FLAG
	.word 0x6004000
	.word DecompBuf_2027A00

	.word comp_87E5550 + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2028200

	.word comp_87E56A0 + COMPRESSED_PTR_FLAG
	.word 0x600D600
	.word DecompBuf_2027A00

	.word dword_87E54B0
	.word palette_3001980
	.word 0xA0

	.word byte_86A4D40
	.word 0x6010020
	.word 0x240

	.word dword_86A4A40
	.word 0x6010300
	.word 0x100

	.word dword_86A5500
	.word byte_3001550
	.word 0x20

	.word NULL
	thumb_func_end copyData_803B3C8

	thumb_local_start
copyData_803B45C:
	push {r4-r7,lr}
	bl zeroFillVRAM // () -> ()
	bl ZeroFillGFX30025c0
	bl copyMemory_8001850
	// initRefs
	ldr r0, off_803B48C // =initRefs_803B490
	bl decompAndCopyData // (u32 *initRefs) -> void
	mov r0, #7
	bl sub_803B91C
	mov r0, #8
	bl sub_803B91C
	mov r0, #9
	bl sub_803B91C
	mov r0, #0xa
	bl sub_803B91C
	pop {r4-r7,pc}
	.balign 4, 0
off_803B48C:
	.word initRefs_803B490
initRefs_803B490:
	.word comp_87E57BC + COMPRESSED_PTR_FLAG
	.word 0x6004000
	.word DecompBuf_2027A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word 0x600C000
	.word DecompBuf_2027A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2028A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2029200

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2029A00

	.word compSpriteWhiteDot_84E0C4C + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2029E00

	.word dword_87E660C
	.word unk_30019C0
	.word 0x140

	.word spriteWhiteDot
	.word unk_3001A40
	.word 0x40

	.word byte_86A4D40
	.word 0x6010020
	.word 0x240

	.word dword_86A4A40
	.word 0x6010300
	.word 0x100

	.word dword_86A5500
	.word byte_3001550
	.word 0x20

	.word NULL
	thumb_func_end copyData_803B45C

	thumb_local_start
sub_803B518:
	push {r4-r7,lr}
	mov r0, #0xa
	bl sub_803B91C
	pop {r4-r7,pc}
	thumb_func_end sub_803B518

// symdb: Picks a 16-byte tutorial-step descriptor for the current state and dispatches to one of two tutorial-script players (<0xA vs ≥0xA).
// symdb: void sub_803B522(u32 state /* r0 */, u32 arg1 /* r1 */, u32 arg2 /* r2 */, u32 arg3 /* r3 */);
// symdb: uses toolkit pointer via r10; clobbers r0,r1,r2,r3,r4,r5,r6,r7,r8 and NZCV; preserves r4..r9,r12
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803B522.yaml
	thumb_func_start sub_803B522
sub_803B522:
	push {r4-r7,lr}
	mov r4, r8
	push {r4}
	mov r8, r0
	mov r7, r10
	ldr r7, [r7,#oToolkit_Unk200a220_Ptr]
	str r1, [r7,#8]
	str r2, [r7,#0xc]
	str r3, [r7,#0x10]
	str r4, [r7,#0x14]
	ldr r7, off_803B570 // =byte_803B574
	mov r1, #0x10
	mul r0, r1
	add r7, r7, r0
	ldr r0, off_803B634 // =TextScript87E36F8
	ldrb r1, [r7]
	ldrb r2, [r7,#3]
	lsl r2, r2, #0x10
	orr r1, r2
	ldr r2, [r7,#4]
	ldr r3, [r7,#0xc]
	ldrb r4, [r7,#1]
	ldrb r5, [r7,#2]
	ldr r6, off_803B638 // =byte_86ACD60
	ldr r7, [r7,#8]
	mov r0, r8
	cmp r0, #0xa
	bge loc_803B562
	ldr r0, off_803B634 // =TextScript87E36F8
	bl sub_8045FC6
	b loc_803B568
loc_803B562:
	ldr r0, off_803B634 // =TextScript87E36F8
	bl loc_8045FE4
loc_803B568:
	pop {r4}
	mov r8, r4
	pop {r4-r7,pc}
	.balign 4, 0
off_803B570:
	.word byte_803B574
byte_803B574:
	.byte 0x1E, 0x7, 0x1, 0x0, 0x0, 0xCA, 0x2, 0x2, 0x0, 0xCE, 0x2, 0x2, 0x0, 0x40
	.byte 0x0, 0x6, 0x1F, 0x7, 0x1, 0x0, 0x0, 0xD2, 0x2, 0x2, 0x0, 0xD6, 0x2, 0x2
	.byte 0x0, 0x44, 0x0, 0x6, 0x20, 0x8, 0x1, 0x0, 0x0, 0xDA, 0x2, 0x2, 0x0, 0xDE
	.byte 0x2, 0x2, 0x0, 0x48, 0x0, 0x6, 0x21, 0x7, 0x1, 0x0, 0x0, 0xE2, 0x2, 0x2
	.byte 0x0, 0xE6, 0x2, 0x2, 0x0, 0x4C, 0x0, 0x6, 0x32, 0x4, 0x1, 0x0, 0x0, 0xCA
	.byte 0x2, 0x2, 0x0, 0xCC, 0x2, 0x2, 0x0, 0xC0, 0x0, 0x6, 0x33, 0x4, 0x1, 0x0
	.byte 0x0, 0xCE, 0x2, 0x2, 0x0, 0xD0, 0x2, 0x2, 0x0, 0xC2, 0x0, 0x6, 0x34, 0x3
	.byte 0x1, 0x0, 0x0, 0xD2, 0x2, 0x2, 0x0, 0xD4, 0x2, 0x2, 0x0, 0xC4, 0x0, 0x6
	.byte 0x35, 0x3, 0x1, 0x0, 0x0, 0xD6, 0x2, 0x2, 0x0, 0xD8, 0x2, 0x2, 0x0, 0xC6
	.byte 0x0, 0x6, 0x36, 0x3, 0x1, 0x0, 0x0, 0xDA, 0x2, 0x2, 0x0, 0xDC, 0x2, 0x2
	.byte 0x0, 0xC8, 0x0, 0x6, 0x37, 0x3, 0x1, 0x0, 0x0, 0xDE, 0x2, 0x2, 0x0, 0xE0
	.byte 0x2, 0x2, 0x0, 0xCA, 0x0, 0x6, 0x38, 0x7, 0x1, 0x0, 0x0, 0xDA, 0x2, 0x2
	.byte 0x0, 0xEA, 0x2, 0x2, 0x0, 0xCC, 0x0, 0x6, 0x39, 0xB, 0x1, 0x0, 0x0, 0xDE
	.byte 0x2, 0x2, 0x0, 0xEE, 0x2, 0x2, 0x0, 0xD0, 0x0, 0x6
off_803B634:
	.word TextScript87E36F8
off_803B638:
	.word byte_86ACD60
	thumb_func_end sub_803B522

	thumb_local_start
sub_803B63C:
	push {r4-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_Unk200a220_Ptr]
	str r1, [r7,#8]
	str r2, [r7,#0xc]
	str r3, [r7,#0x10]
	str r4, [r7,#0x14]
	ldr r7, off_803B668 // =off_803B66C
	mov r1, #0xc
	mul r0, r1
	add r7, r7, r0
	ldr r0, off_803B66C // =TextScript87E36F8
	ldrb r1, [r7]
	ldr r2, [r7,#4]
	ldr r3, [r7,#8]
	ldrb r4, [r7,#1]
	ldrb r5, [r7,#2]
	ldr r6, off_803B670 // =dword_86A5D60
	ldrb r7, [r7,#3]
	bl renderTextGfx_8045F8C
	pop {r4-r7,pc}
	.balign 4, 0
off_803B668:
	.word off_803B66C
off_803B66C:
	.word TextScript87E36F8
off_803B670:
	.word dword_86A5D60
	thumb_func_end sub_803B63C

// symdb: Loads a 32x32 background tile block by index from a ROM table, building the tile-id list via fillOamTileStripes_8001930 and blitting it with CopyBackgroundTiles.
// symdb: void sub_803B674(u32 backgroundIndex /* r0 */, void *unkPtr /* r10 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803B674.yaml
	thumb_func_start sub_803B674
sub_803B674:
	push {r4-r7,lr}
	ldr r7, off_803B6A8 // =byte_803B6AC
	mov r1, #8
	mul r0, r1
	add r7, r7, r0
	ldrh r0, [r7]
	ldrb r1, [r7,#2]
	ldrb r2, [r7,#3]
	ldrb r3, [r7,#4]
	ldr r4, off_803B6A4 // =unk_2030A00
	bl fillOamTileStripes_8001930
	// j
	ldrb r0, [r7,#5]
	// i
	ldrb r1, [r7,#6]
	// tileBlock32x32
	ldrb r2, [r7,#7]
	// tileIds
	mov r3, r4
	ldrb r4, [r7,#3]
	lsl r4, r4, #1
	ldrb r5, [r7,#4]
	lsl r5, r5, #1
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_803B6A4:
	.word unk_2030A00
off_803B6A8:
	.word byte_803B6AC
byte_803B6AC:
	.byte 0x0, 0x2, 0x8, 0x6, 0x1, 0x4, 0x4, 0x2, 0x20, 0x2, 0x8, 0x5, 0x1, 0x10, 0x4
	.byte 0x2, 0x40, 0x2, 0x8, 0x7, 0x1, 0xA, 0x7, 0x2, 0x60, 0x2, 0x8, 0x7, 0x1, 0xA
	.byte 0x9, 0x2, 0x1, 0x0, 0x3, 0x5, 0x1, 0x1, 0x7, 0x3, 0x15, 0x0, 0x3, 0x5, 0x1
	.byte 0x1, 0x9, 0x3, 0x29, 0x0, 0x3, 0x5, 0x1, 0x1, 0xB, 0x3, 0x3D, 0x0, 0x3, 0x5
	.byte 0x1, 0x1, 0xD, 0x3, 0x51, 0x0, 0x3, 0x5, 0x1, 0x1, 0xF, 0x3, 0x65, 0x0, 0x3
	.byte 0x5, 0x1, 0x1, 0x11, 0x3, 0x79, 0x0, 0x3, 0x5, 0x1, 0xC, 0x7, 0x3, 0x8D, 0x0
	.byte 0x3, 0x5, 0x1, 0xC, 0x9, 0x3, 0xA1, 0x0, 0x3, 0x5, 0x1, 0xC, 0xB, 0x3, 0xB5
	.byte 0x0, 0x3, 0x5, 0x1, 0xC, 0xD, 0x3, 0xC9, 0x0, 0x3, 0x5, 0x1, 0xC, 0xF, 0x3
	.byte 0xDD, 0x0, 0x3, 0x5, 0x1, 0xC, 0x11, 0x3, 0x1, 0x1, 0x3, 0x5, 0x1, 0x1, 0x7
	.byte 0x3, 0x15, 0x1, 0x3, 0x5, 0x1, 0x1, 0x9, 0x3, 0x29, 0x1, 0x3, 0x5, 0x1, 0x1
	.byte 0xB, 0x3, 0x3D, 0x1, 0x3, 0x5, 0x1, 0x1, 0xD, 0x3, 0x51, 0x1, 0x3, 0x5, 0x1
	.byte 0x1, 0xF, 0x3, 0x65, 0x1, 0x3, 0x5, 0x1, 0x1, 0x11, 0x3, 0x79, 0x1, 0x3, 0x5
	.byte 0x1, 0xC, 0x7, 0x3, 0x8D, 0x1, 0x3, 0x5, 0x1, 0xC, 0x9, 0x3, 0xA1, 0x1, 0x3
	.byte 0x5, 0x1, 0xC, 0xB, 0x3, 0xB5, 0x1, 0x3, 0x5, 0x1, 0xC, 0xD, 0x3, 0xC9, 0x1
	.byte 0x3, 0x5, 0x1, 0xC, 0xF, 0x3, 0xDD, 0x1, 0x3, 0x5, 0x1, 0xC, 0x11, 0x3, 0x10
	.byte 0x2, 0x5, 0x3, 0x1, 0x17, 0x5, 0x3, 0x20, 0x2, 0x5, 0x3, 0x1, 0x17, 0x7, 0x3
	.byte 0x30, 0x2, 0x5, 0x3, 0x1, 0x17, 0x9, 0x3, 0x40, 0x2, 0x5, 0x3, 0x1, 0x17, 0xB
	.byte 0x3, 0x50, 0x2, 0x5, 0x3, 0x1, 0x17, 0xD, 0x3, 0x0, 0x2, 0x5, 0x3, 0x1, 0x17
	.byte 0x7, 0x3, 0x20, 0x2, 0x5, 0x3, 0x1, 0x17, 0x9, 0x3, 0x30, 0x2, 0x5, 0x3, 0x1
	.byte 0x17, 0xB, 0x3, 0x40, 0x2, 0x5, 0x3, 0x1, 0x17, 0xD, 0x3, 0x50, 0x2, 0x5, 0x3
	.byte 0x1, 0x17, 0xF, 0x3, 0x60, 0x2, 0x2, 0x5, 0x1, 0x8, 0x1, 0x2, 0x80, 0x2, 0x2
	.byte 0xB, 0x1, 0x8, 0x4, 0x2, 0x60, 0x2, 0x2, 0x7, 0x1, 0x8, 0x2, 0x2, 0x20, 0x2
	.byte 0x5, 0x3, 0x1, 0x17, 0x7, 0x3, 0x30, 0x2, 0x5, 0x3, 0x1, 0x17, 0x9, 0x3, 0x40
	.byte 0x2, 0x5, 0x3, 0x1, 0x17, 0xB, 0x3, 0x50, 0x2, 0x5, 0x3, 0x1, 0x17, 0xD, 0x3
	thumb_func_end sub_803B674

	thumb_local_start
sub_803B814:
	push {r4-r7,lr}
	sub sp, sp, #0xc
	str r0, [sp]
	str r1, [sp,#4]
	lsl r2, r2, #0xc
	ldr r0, off_803B874 // =0x420
	orr r2, r0
	str r2, [sp,#8]
	mov r7, r3
	ldr r6, dword_803B870 // =0x40001000
loc_803B828:
	sub r4, #1
	blt loc_803B86C
	ldrb r0, [r7]
	tst r0, r0
	beq loc_803B86C
	ldr r2, [sp]
	mov r1, r2
	ldr r3, off_803B878 // =byte_80391A8
	ldrb r3, [r3,r0]
	lsl r3, r3, #3
	ldr r0, off_803B87C // =byte_2027200
	add r0, #2
	ldrb r0, [r0,r3]
	bl chatbox_8045ED0
	add r1, r1, r0
	str r1, [sp]
	lsl r0, r2, #0x10
	ldr r1, [sp,#4]
	orr r0, r1
	ldr r1, dword_803B870 // =0x40001000
	orr r0, r1
	ldr r1, [sp,#8]
	ldr r2, off_803B878 // =byte_80391A8
	ldrb r3, [r7]
	ldrb r2, [r2,r3]
	lsl r2, r2, #2
	add r1, r1, r2
	mov r2, #2
	mov r3, #7
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	add r7, #1
	b loc_803B828
loc_803B86C:
	add sp, sp, #0xc
	pop {r4-r7,pc}
	.balign 4, 0
dword_803B870:
	.word 0x40001000
off_803B874:
	.word 0x420
off_803B878:
	.word byte_80391A8
off_803B87C:
	.word byte_2027200
	thumb_func_end sub_803B814

	thumb_local_start
sub_803B880:
	push {r4-r7,lr}
	mov r6, #0xf
	mov r7, #0
	bl sub_803C398
	bl memory_bcdConvert
	mov r4, r0
	lsr r2, r4, #8
	and r2, r6
	add r7, r7, r2
	beq loc_803B8A0
	mov r0, #0x68
	mov r1, #0x50
	bl sub_803B8F8
loc_803B8A0:
	lsr r2, r4, #4
	and r2, r6
	add r7, r7, r2
	beq loc_803B8B0
	mov r0, #0x70
	mov r1, #0x50
	bl sub_803B8F8
loc_803B8B0:
	lsl r2, r4, #0
	and r2, r6
	mov r0, #0x78
	mov r1, #0x50
	bl sub_803B8F8
	mov r7, #0
	bl sub_803C398
	mov r0, r1
	bl memory_bcdConvert
	mov r4, r0
	lsr r2, r4, #8
	and r2, r6
	add r7, r7, r2
	beq loc_803B8DA
	mov r0, #0x94
	mov r1, #0x50
	bl sub_803B8F8
loc_803B8DA:
	lsr r2, r4, #4
	and r2, r6
	add r7, r7, r2
	beq loc_803B8EA
	mov r0, #0x9c
	mov r1, #0x50
	bl sub_803B8F8
loc_803B8EA:
	lsl r2, r4, #0
	and r2, r6
	mov r0, #0xa4
	mov r1, #0x50
	bl sub_803B8F8
	pop {r4-r7,pc}
	thumb_func_end sub_803B880

	thumb_local_start
sub_803B8F8:
	push {r4-r7,lr}
	lsl r4, r2, #1
	lsl r0, r0, #0x10
	orr r0, r1
	ldr r1, dword_803B914 // =0x9000
	orr r0, r1
	ldr r1, dword_803B918 // =0xc080
	add r1, r1, r4
	mov r2, #0
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	pop {r4-r7,pc}
	.balign 4, 0
dword_803B914:
	.word 0x9000
dword_803B918:
	.word 0xC080
	thumb_func_end sub_803B8F8

// symdb: Copies one of a small palette/toolkit BG-tile-id entry (loaded from a 12-byte table) into the toolkit's iBGTileIdBlocks blit buffer via sub_8001890.
// symdb: (r0 = table index) -> r0 = 0 ; side effects: writes to one of the toolkit's BG tile-id block
// symdb: buffers through sub_8001890.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_803B91C.yaml
	thumb_func_start sub_803B91C
sub_803B91C:
	push {r4-r7,lr}
	ldr r3, off_803B938 // =off_803B93C
	mov r1, #0xc
	mul r0, r1
	add r3, r3, r0
	ldrb r0, [r3,#5]
	ldrb r1, [r3,#6]
	ldrb r2, [r3,#4]
	ldrb r4, [r3,#7]
	ldrb r5, [r3,#8]
	ldr r3, [r3]
	bl sub_8001890
	pop {r4-r7,pc}
	.balign 4, 0
off_803B938:
	.word off_803B93C
off_803B93C:
	.word unk_2028204
	.byte 0x3, 0x0, 0x0, 0x1E, 0x14, 0xFF, 0xFF, 0xFF, 0x4, 0x8A, 0x2
	.byte 0x2, 0x2, 0x0, 0x8, 0x20, 0x5, 0xFF, 0xFF, 0xFF, 0x4, 0x92
	.byte 0x2, 0x2, 0x1, 0x0, 0x0, 0x1E, 0x20, 0xFF, 0xFF, 0xFF, 0x4
	.byte 0x82, 0x2, 0x2, 0x1, 0x0, 0x0, 0x1E, 0x14, 0xFF, 0xFF, 0xFF
	.byte 0x4, 0x82, 0x2, 0x2, 0x2, 0x0, 0x0, 0x1E, 0x14, 0xFF, 0xFF
	.byte 0xFF, 0x4, 0x8A, 0x2, 0x2, 0x3, 0x0, 0x0, 0x1E, 0x14, 0xFF
	.byte 0xFF, 0xFF, 0x4, 0x92, 0x2, 0x2, 0x1, 0x0, 0x0, 0x1E, 0x14
	.byte 0xFF, 0xFF, 0xFF, 0x4, 0x8A, 0x2, 0x2, 0x1, 0x0, 0x0, 0x1E
	.byte 0x14, 0xFF, 0xFF, 0xFF, 0x4, 0x92, 0x2, 0x2, 0x2, 0x0, 0x0
	.byte 0x1E, 0x14, 0xFF, 0xFF, 0xFF, 0x4, 0x9A, 0x2, 0x2, 0x3, 0x0
	.byte 0x0, 0x1E, 0x14, 0xFF, 0xFF, 0xFF, 0x4, 0x9E, 0x2, 0x2, 0x0
	.byte 0x0, 0x0, 0x1E, 0x2, 0xFF, 0xFF, 0xFF
	thumb_func_end sub_803B91C

	thumb_local_start
sub_803B9C0:
	push {r4-r7,lr}
	lsl r0, r0, #0x10
	orr r0, r1
	ldr r4, dword_803B9F8 // =0x1000
	add r4, r4, r0
	ldr r5, off_803B9FC // =0x414
	lsl r2, r2, #0xc
	orr r5, r2
	mov r0, r3
	bl memory_bcdConvert
	mov r6, r0
	mov r7, #0x1c
loc_803B9DA:
	mov r0, r4
	lsl r1, r7, #0x10
	add r0, r0, r1
	mov r1, r5
	mov r2, #0xf
	and r2, r6
	add r1, r1, r2
	mov r2, #2
	mov r3, #7
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	lsr r6, r6, #4
	sub r7, #7
	bge loc_803B9DA
	pop {r4-r7,pc}
	.balign 4, 0
dword_803B9F8:
	.word 0x1000
off_803B9FC:
	.word 0x414
	thumb_func_end sub_803B9C0

	thumb_local_start
sub_803BA00:
	push {r4-r7,lr}
	push {r0,r1}
	bl sub_803B9C0
	pop {r0,r1}
	sub r0, #0xc
	lsl r0, r0, #0x10
	orr r0, r1
	ldr r1, dword_803BA20 // =0x5000
	orr r0, r1
	ldr r1, dword_803BA24 // =0x41e
	mov r2, #2
	mov r3, #7
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	pop {r4-r7,pc}
	.balign 4, 0
dword_803BA20:
	.word 0x5000
dword_803BA24:
	.word 0x41E
	thumb_func_end sub_803BA00

	thumb_local_start
sub_803BA28:
	push {r4-r7,lr}
	ldr r7, off_803BA60 // =word_2006770
	mov r0, #8
	add r0, r0, r7
	mov r1, r5
	add r1, #0x30
	mov r2, #0x20
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	mov r0, #0x28
	add r0, r0, r7
	mov r1, r5
	add r1, #0x90
	mov r2, #0x20
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	mov r0, #0x10
	mov r1, #0x30
	bl sub_803C132
	strb r0, [r5,#0x10]
	mov r0, #0x11
	mov r1, #0x90
	bl sub_803C132
	strb r0, [r5,#0x11]
	pop {r4-r7,pc}
	.balign 4, 0
off_803BA60:
	.word word_2006770
	thumb_func_end sub_803BA28

// symdb: Thin wrapper around sub_803BA84 that forwards a constant (0x30, 0x50, 0x20, 0x10) argument tuple.
// symdb: void sub_803BA64(void);  // r5 in; r1,r2,r3,r5 out; r0,lr,nzcv clobbered; r4,r6,r7 preserved
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803BA64.yaml
	thumb_func_start sub_803BA64
sub_803BA64:
	push {r4-r7,lr}
	mov r0, #0x30
	mov r1, #0x50
	mov r2, #0x20
	mov r3, #0x10
	bl sub_803BA84
	pop {r4-r7,pc}
	thumb_func_end sub_803BA64

// symdb: Thin wrapper that calls sub_80290 ("battle_80290") with a fixed battle-screen parameter set for what looks like a war-table / chip-deploy effect.
// symdb: void battle_80290_thinWarTableFx(void);  // uses r5 as a preserved scratch pointer; clobbers
// symdb: r0/r1/r2/r3 and NZCV; r5 preserved; lr consumed
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803BA74.yaml
	thumb_local_start
sub_803BA74:
	push {r4-r7,lr}
	mov r0, #0x90
	mov r1, #0xb0
	mov r2, #0x20
	mov r3, #0x11
	bl sub_803BA84
	pop {r4-r7,pc}
	thumb_func_end sub_803BA74

	thumb_local_start
sub_803BA84:
	push {r4-r7,lr}
	sub sp, sp, #8
	str r1, [sp]
	str r3, [sp,#4]
	add r0, r0, r5
	add r1, r1, r5
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	ldr r7, [sp]
	add r7, r7, r5
	mov r4, #0
loc_803BA9A:
	ldrb r0, [r7,r4]
	cmp r0, #0xe6
	beq loc_803BAA4
	add r4, #2
	b loc_803BA9A
loc_803BAA4:
	ldr r7, [sp]
	add r7, r7, r5
	ldr r6, [sp,#4]
	ldrb r6, [r5,r6]
	lsl r6, r6, #1
loc_803BAAE:
	cmp r4, r6
	ble loc_803BAC8
	sub r4, #2
	blt loc_803BAC8
	ldrb r0, [r7,r4]
	cmp r0, #0xe5
	bne loc_803BAC8
	add r1, r7, r4
	mov r0, #0xb2
	strb r0, [r1]
	mov r0, #0xe5
	strb r0, [r1,#1]
	b loc_803BAAE
loc_803BAC8:
	sub r4, #2
	blt loc_803BADE
	ldrb r0, [r7,r4]
	cmp r0, #0xe5
	bne loc_803BAC8
	add r1, r7, r4
	mov r0, #0xb2
	strb r0, [r1]
	mov r0, #0xe5
	strb r0, [r1,#1]
	b loc_803BAC8
loc_803BADE:
	add sp, sp, #8
	pop {r4-r7,pc}
	thumb_func_end sub_803BA84

// symdb: Advances a battle object's animation-phase counter (byte 0x13) and, during the low phase window [0,0x1F], rewrites the targeted sprite record to either an active {0x25, 0xE6} or idle {0x9F, 0xE5} two-byte state.
// symdb: u32 animStep_803BAE2(u32 table_index /* r0 */, void *obj /* r5 */);     // r1 out: 0x3F when
// symdb: outside the window; sub-index when record stays 0xE6;     //         record address when
// symdb: rewritten to idle.     // clobbers r0, NZCV; preserves r4-r7.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803BAE2.yaml
	thumb_func_start sub_803BAE2
sub_803BAE2:
	push {r4-r7,lr}
	ldr r4, off_803BB24 // =dword_803BB28
	lsl r0, r0, #1
	add r4, r4, r0
	ldrb r0, [r5,#0x13]
	add r0, #1
	strb r0, [r5,#0x13]
	mov r1, #0x3f
	and r0, r1
	cmp r0, #0x20
	bge locret_803BB20
	ldrb r0, [r4]
	ldrb r1, [r4,#1]
	mov r7, r5
	add r7, r7, r0
	ldrb r4, [r5,r1]
	lsl r4, r4, #1
	ldrb r0, [r7,r4]
	cmp r0, #0xe6
	beq loc_803BB16
	add r1, r7, r4
	mov r0, #0x9f
	strb r0, [r1]
	mov r0, #0xe5
	strb r0, [r1,#1]
	b locret_803BB20
loc_803BB16:
	add r7, r7, r4
	mov r0, #0x25
	strb r0, [r7]
	mov r0, #0xe6
	strb r0, [r7,#1]
locret_803BB20:
	pop {r4-r7,pc}
	.balign 4, 0
off_803BB24:
	.word dword_803BB28
dword_803BB28:
	.word 0x11B01050
	thumb_func_end sub_803BAE2

// symdb: Selects and displays a network-related text script based on the current main jump table phase.
// symdb: void chatbox_dispatchNetworkScript_803BB2C(TextScriptArchive *archive /*r0*/, Toolkit *toolkit
// symdb: /*r10*/); // preserves r4-r7, clobbers r1-r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803BB2C.yaml
	thumb_func_start sub_803BB2C
sub_803BB2C:
	push {r4-r7,lr}
	mov r1, r0
	mov r3, r10
	ldr r3, [r3,#oToolkit_MainJumptableIndexPtr]
	ldrb r3, [r3]
	cmp r3, #0x28
	beq loc_803BB4A
	cmp r3, #0x30
	beq loc_803BB4A
	cmp r3, #0x4c
	beq loc_803BB52
	ldr r0, off_803BB68 // =TextScript87E36F8
	bl chatbox_runScriptAndSetWhiteDot803FE74 // (TextScriptArchive *archive, u8 scriptIdx) -> void
	b locret_803BB64
loc_803BB4A:
	ldr r0, off_803BB6C // =TextScriptNetworkRequestConnection87F2A1C
	bl chatbox_runScript_803FD9C // (TextScriptArchive *archive, u8 scriptIdx) -> void
	b locret_803BB64
loc_803BB52:
	push {r1}
	bl sub_8123360 // () -> bool
	lsl r1, r0, #2
	ldr r0, TextScriptNetworkEnterFolderNamePtrs_p // =TextScriptNetworkEnterFolderNamePtrs
	ldr r0, [r0,r1]
	pop {r1}
	bl chatbox_runScript_803FD9C // (TextScriptArchive *archive, u8 scriptIdx) -> void
locret_803BB64:
	pop {r4-r7,pc}
	.balign 4, 0
off_803BB68:
	.word TextScript87E36F8
off_803BB6C:
	.word TextScriptNetworkRequestConnection87F2A1C
TextScriptNetworkEnterFolderNamePtrs_p:
	.word TextScriptNetworkEnterFolderNamePtrs
TextScriptNetworkEnterFolderNamePtrs:
	.word TextScriptNetworkEnterFolderName0
	.word TextScriptNetworkEnterFolderName1
	thumb_func_end sub_803BB2C

// symdb: Stores a 32-bit value into the object at offset 0x28 (R5), then returns.
// symdb: void sub_803BB7C(uint32_t value, void *object);
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803BB7C.yaml
	thumb_func_start sub_803BB7C
sub_803BB7C:
	str r0, [r5,#0x28]
	mov pc, lr
	thumb_func_end sub_803BB7C

// symdb: Decrements a 32-bit "uses remaining" counter on the object pointed to by r5; returns 0 if a use was consumed, 1 if already exhausted.
// symdb: // r5 in: pointer to a struct with a u32 use counter at offset 0x28 // returns r0: 0 =
// symdb: decremented, 1 = already <= 0 (no write) // flags out: C/V from the SUBS r0,#1 on the loaded
// symdb: counter value; N/Z clobbered by the final MOV r0,#0/#1 void sub_803BB80(void);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803BB80.yaml
	thumb_func_start sub_803BB80
sub_803BB80:
	ldr r0, [r5,#0x28]
	sub r0, #1
	blt loc_803BB8C
	str r0, [r5,#0x28]
	mov r0, #0
	mov pc, lr
loc_803BB8C:
	mov r0, #1
	mov pc, lr
	thumb_func_end sub_803BB80

	thumb_func_start sub_803BB90
sub_803BB90:
	str r0, [r5,#0x2c]
	mov pc, lr
	thumb_func_end sub_803BB90

	thumb_func_start sub_803BB94
sub_803BB94:
	ldr r0, [r5,#0x2c]
	sub r0, #1
	blt loc_803BBA0
	str r0, [r5,#0x2c]
	mov r0, #0
	mov pc, lr
loc_803BBA0:
	mov r0, #1
	mov pc, lr
	thumb_func_end sub_803BB94

	thumb_local_start
sub_803BBA4:
	push {r4-r7,lr}
	mov r4, r2
	lsl r0, r0, #0x10
	orr r1, r0
	ldr r0, dword_803BBD4 // =0x40001000
	orr r0, r1
	ldrb r2, [r5,#7]
	lsl r2, r2, #1
	ldr r1, off_803BBD8 // =byte_803BBDC
	ldrh r1, [r1,r2]
	ldr r2, dword_803BC00 // =0xb5f00800
	orr r1, r2
	mov r2, #2
	mov r3, #7
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldrb r0, [r5,#7]
	add r0, r0, r4
	cmp r0, #0x12
	blt loc_803BBCE
	mov r0, #0
loc_803BBCE:
	strb r0, [r5,#7]
	pop {r4-r7,pc}
	.balign 4, 0
dword_803BBD4:
	.word 0x40001000
off_803BBD8:
	.word byte_803BBDC
byte_803BBDC:
	.byte 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x5, 0x0, 0x5, 0x0, 0x5
	.byte 0x0, 0x5, 0x0, 0x5, 0x0, 0x5, 0x0, 0x9, 0x0, 0x9, 0x0, 0x9, 0x0, 0x9, 0x0, 0x9, 0x0
	.byte 0x9, 0x0
dword_803BC00:
	// `ldr r2, dword_803BC00` above reads this halfword together with the
	// first instruction of sub_803BC02, i.e. the constant 0xB5F00800.
	.hword 0x800
	thumb_func_end sub_803BBA4

	thumb_local_start
sub_803BC02:
	push {r4-r7,lr}
	lsl r7, r4, #0xa
	mov r4, r3
	push {r2}
	lsl r0, r0, #0x10
	orr r1, r0
	ldr r0, dword_803BC4C // =0x40001000
	orr r0, r1
	ldr r6, dword_803BC50 // =0x9000
	orr r6, r1
	ldrb r2, [r5,#7]
	lsl r2, r2, #1
	ldr r1, off_803BC54 // =byte_803BC58
	ldrh r1, [r1,r2]
	orr r1, r7
	add r7, r1, #4
	mov r2, r4
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	mov r2, #0x10
	lsl r2, r2, #0x10
	add r0, r6, r2
	mov r1, r7
	mov r2, r4
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	pop {r2}
	ldrb r0, [r5,#7]
	add r0, r0, r2
	cmp r0, #0x12
	blt loc_803BC46
	mov r0, #0
loc_803BC46:
	strb r0, [r5,#7]
	pop {r4-r7,pc}
	.balign 4, 0x00
dword_803BC4C:
	.word 0x40001000
dword_803BC50:
	.word 0x9000
off_803BC54:
	.word byte_803BC58
byte_803BC58:
	.byte 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x7, 0x0, 0x7, 0x0, 0x7
	.byte 0x0, 0x7, 0x0, 0x7, 0x0, 0x7, 0x0, 0xD, 0x0, 0xD, 0x0, 0xD, 0x0, 0xD, 0x0, 0xD, 0x0
	.byte 0xD, 0x0
	thumb_func_end sub_803BC02

// symdb: Draws the left/right half-tiles of a per-element overlay frame and advances the column counter (wraps at 0x18).
// symdb: void sub_803BC7C(u32 style, void *overlayState);  // r0=style flag, r5->overlay block; out:
// symdb: r0=new column index, NZCV from final CMP
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803BC7C.yaml
	thumb_func_start sub_803BC7C
sub_803BC7C:
	push {r4-r7,lr}
	ldrb r1, [r5,#8]
	tst r0, r0
	beq loc_803BC8A
	cmp r1, #0x3c
	blt loc_803BC8A
	add r1, #5
loc_803BC8A:
	ldr r4, off_803BD14 // =byte_803BD18
	lsl r0, r1, #2
	add r4, r4, r0
	ldrb r0, [r4]
	lsl r0, r0, #0x10
	ldrb r6, [r4,#1]
	orr r6, r0
	ldr r0, dword_803BCD8 // =0x9000
	orr r0, r6
	ldrb r2, [r5,#0xa]
	lsl r2, r2, #1
	ldr r1, off_803BCE0 // =byte_803BCE4
	ldrh r1, [r1,r2]
	mov r2, #0
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldr r0, dword_803BCDC // =0x9000
	orr r0, r6
	ldrb r1, [r4,#2]
	lsl r1, r1, #0x10
	add r0, r0, r1
	ldrb r2, [r5,#0xa]
	lsl r2, r2, #1
	ldr r1, off_803BCE0 // =byte_803BCE4
	ldrh r1, [r1,r2]
	add r1, #2
	mov r2, #0
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldrb r0, [r5,#0xa]
	add r0, #1
	cmp r0, #0x18
	blt loc_803BCD2
	mov r0, #0
loc_803BCD2:
	strb r0, [r5,#0xa]
	pop {r4-r7,pc}
	.balign 4, 0
dword_803BCD8:
	.word 0x9000
dword_803BCDC:
	.word 0x9000
off_803BCE0:
	.word byte_803BCE4
byte_803BCE4:
	.byte 0x18, 0x0, 0x18, 0x0, 0x18, 0x0, 0x18, 0x0, 0x18, 0x0, 0x18
	.byte 0x0, 0x18, 0x0, 0x18, 0x0, 0x18, 0x0, 0x18, 0x0, 0x18, 0x0
	.byte 0x18, 0x0, 0x1C, 0x0, 0x1C, 0x0, 0x1C, 0x0, 0x1C, 0x0, 0x1C
	.byte 0x0, 0x1C, 0x0, 0x1C, 0x0, 0x1C, 0x0, 0x1C, 0x0, 0x1C, 0x0
	.byte 0x1C, 0x0, 0x1C, 0x0
off_803BD14:
	.word byte_803BD18
byte_803BD18:
	.byte 0x5, 0x38, 0xC, 0xFF, 0x15, 0x38, 0xC, 0xFF, 0x25, 0x38
	.byte 0xC, 0xFF, 0x35, 0x38, 0xC, 0xFF, 0x45, 0x38, 0xC, 0xFF
	.byte 0x5, 0x48, 0xC, 0xFF, 0x15, 0x48, 0xC, 0xFF, 0x25, 0x48
	.byte 0xC, 0xFF, 0x35, 0x48, 0xC, 0xFF, 0x45, 0x48, 0xC, 0xFF
	.byte 0x5, 0x58, 0xC, 0xFF, 0x15, 0x58, 0xC, 0xFF, 0x25, 0x58
	.byte 0xC, 0xFF, 0x35, 0x58, 0xC, 0xFF, 0x45, 0x58, 0xC, 0xFF
	.byte 0x5, 0x68, 0xC, 0xFF, 0x15, 0x68, 0xC, 0xFF, 0x25, 0x68
	.byte 0xC, 0xFF, 0x35, 0x68, 0xC, 0xFF, 0x45, 0x68, 0xC, 0xFF
	.byte 0x5, 0x78, 0xC, 0xFF, 0x15, 0x78, 0xC, 0xFF, 0x25, 0x78
	.byte 0xC, 0xFF, 0x35, 0x78, 0xC, 0xFF, 0x45, 0x78, 0xC, 0xFF
	.byte 0x5, 0x88, 0xC, 0xFF, 0x15, 0x88, 0xC, 0xFF, 0x25, 0x88
	.byte 0xC, 0xFF, 0x35, 0x88, 0xC, 0xFF, 0x45, 0x88, 0xC, 0xFF
	.byte 0x5D, 0x38, 0xC, 0xFF, 0x6D, 0x38, 0xC, 0xFF, 0x7D, 0x38
	.byte 0xC, 0xFF, 0x8D, 0x38, 0xC, 0xFF, 0x9D, 0x38, 0xC, 0xFF
	.byte 0x5D, 0x48, 0xC, 0xFF, 0x6D, 0x48, 0xC, 0xFF, 0x7D, 0x48
	.byte 0xC, 0xFF, 0x8D, 0x48, 0xC, 0xFF, 0x9D, 0x48, 0xC, 0xFF
	.byte 0x5D, 0x58, 0xC, 0xFF, 0x6D, 0x58, 0xC, 0xFF, 0x7D, 0x58
	.byte 0xC, 0xFF, 0x8D, 0x58, 0xC, 0xFF, 0x9D, 0x58, 0xC, 0xFF
	.byte 0x5D, 0x68, 0xC, 0xFF, 0x6D, 0x68, 0xC, 0xFF, 0x7D, 0x68
	.byte 0xC, 0xFF, 0x8D, 0x68, 0xC, 0xFF, 0x9D, 0x68, 0xC, 0xFF
	.byte 0x5D, 0x78, 0xC, 0xFF, 0x6D, 0x78, 0xC, 0xFF, 0x7D, 0x78
	.byte 0xC, 0xFF, 0x8D, 0x78, 0xC, 0xFF, 0x9D, 0x78, 0xC, 0xFF
	.byte 0x5D, 0x88, 0xC, 0xFF, 0x6D, 0x88, 0xC, 0xFF, 0x7D, 0x88
	.byte 0xC, 0xFF, 0x8D, 0x88, 0xC, 0xFF, 0x9D, 0x88, 0xC, 0xFF
	.byte 0xB7, 0x38, 0x2D, 0xFF, 0xB7, 0x38, 0x20, 0xFF, 0xB7, 0x48
	.byte 0x1F, 0xFF, 0xB7, 0x58, 0x12, 0xFF, 0xB7, 0x68, 0x18, 0xFF
	.byte 0xB7, 0x38, 0x2D, 0xFF, 0xB7, 0x38, 0x20, 0xFF, 0xB7, 0x48
	.byte 0x1F, 0xFF, 0xB7, 0x58, 0x12, 0xFF, 0xB7, 0x68, 0x18, 0xFF
	thumb_func_end sub_803BC7C

	thumb_func_start sub_803BE30
sub_803BE30:
	push {r4-r7,lr}
	mov r1, #0x10
	mul r0, r1
	ldr r1, off_803BE88 // =off_803BE8C
	add r0, r0, r1
	ldr r4, [r0]
	ldr r6, [r0,#4]
	ldr r1, [r0,#0xc]
	ldr r0, [r0,#8]
	sub sp, sp, #0x10
	str r4, [sp]
	str r6, [sp,#4]
	str r1, [sp,#0xc]
	str r0, [sp,#8]
loc_803BE4C:
	ldrb r0, [r4,#2]
	cmp r0, #0xe6
	beq loc_803BE78
	ldr r3, [sp,#8]
	push {r4-r7}
	mov r0, r4
	mov r1, #0
	lsl r1, r1, #0x10
	mov r2, r6
	mov r4, #0x20
	lsl r4, r4, #8
	add r2, r2, r4
	mov r7, r6
	mov r4, #1
	mov r5, #1
	ldr r6, off_803BEBC // =byte_86ACD60
	bl sprite_runAnimationScript
	pop {r4-r7}
	add r4, #8
	add r6, #0x80
	b loc_803BE4C
loc_803BE78:
	ldr r0, [sp,#4]
	ldr r1, [sp,#8]
	ldr r2, [sp,#0xc]
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add sp, sp, #0x10
	pop {r4-r7,pc}
	.balign 4, 0
off_803BE88:
	.word off_803BE8C
off_803BE8C:
	.word unk_2024A00
	.word unk_2032A00
	.byte 0x20, 0x80, 0x0, 0x6, 0xE0, 0x1F, 0x0, 0x0, 0x0, 0x4E, 0x2, 0x2
	.byte 0x0, 0x6A, 0x3, 0x2, 0x20, 0xA0, 0x0, 0x6, 0xE0, 0x1F, 0x0, 0x0
	.byte 0x0, 0x72, 0x2, 0x2, 0x0, 0x2A, 0x3, 0x2, 0x0, 0x4, 0x1, 0x6
	.byte 0x0, 0x53, 0x0, 0x0
off_803BEBC:
	.word byte_86ACD60
	thumb_func_end sub_803BE30

// symdb: Expand a static table of text-script word indexes into per-byte 8-byte command records in a RAM buffer.
// symdb: void sub_803BEC0(void /* reads off_803BF18 list, TextScript87E36F8, writes unk_2024A00 buffer,
// symdb: returns via lr with r4-r7 preserved */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803BEC0.yaml
	thumb_func_start sub_803BEC0
sub_803BEC0:
	push {r4-r7,lr}
	ldr r6, off_803BF14 // =off_803BF18
loc_803BEC4:
	ldr r4, [r6]
	tst r4, r4
	beq locret_803BF12
	ldr r1, [r6,#4]
	ldr r7, off_803BF6C // =TextScript87E36F8
	lsl r1, r1, #1
	ldrh r1, [r7,r1]
	add r7, r7, r1
loc_803BED4:
	ldrb r0, [r7]
	cmp r0, #0xe6
	beq loc_803BF0A
	cmp r0, #0xe4
	beq loc_803BEF4
	mov r0, #2
	strh r0, [r4]
	ldrb r0, [r7]
	strb r0, [r4,#2]
	mov r0, #0xe5
	strb r0, [r4,#3]
	mov r0, #0xe6
	strb r0, [r4,#4]
	add r7, #1
	add r4, #8
	b loc_803BED4
loc_803BEF4:
	mov r0, #2
	strh r0, [r4]
	ldrb r0, [r7]
	ldrb r1, [r7,#1]
	strb r0, [r4,#2]
	strb r1, [r4,#3]
	mov r0, #0xe6
	strb r0, [r4,#4]
	add r7, #2
	add r4, #8
	b loc_803BED4
loc_803BF0A:
	mov r0, #0xe6
	strb r0, [r4,#2]
	add r6, #8
	b loc_803BEC4
locret_803BF12:
	pop {r4-r7,pc}
	.balign 4, 0
off_803BF14:
	.word off_803BF18
off_803BF18:
	.word unk_2024A00
off_803BF1C:
	.word 0x28
	.word unk_2024E00
	.byte 0x29, 0x0, 0x0, 0x0, 0x0, 0x52, 0x2, 0x2, 0x2A, 0x0, 0x0, 0x0, 0x0, 0x56
	.byte 0x2, 0x2, 0x2B, 0x0, 0x0, 0x0, 0x0, 0x5A, 0x2, 0x2, 0x2C, 0x0, 0x0, 0x0
	.byte 0x0, 0x5E, 0x2, 0x2, 0x2D, 0x0, 0x0, 0x0, 0x0, 0x62, 0x2, 0x2, 0x2E, 0x0
	.byte 0x0, 0x0, 0x0, 0x66, 0x2, 0x2, 0x2F, 0x0, 0x0, 0x0, 0x0, 0x6A, 0x2, 0x2
	.byte 0x30, 0x0, 0x0, 0x0, 0x0, 0x72, 0x2, 0x2, 0x31, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0
off_803BF6C:
	.word TextScript87E36F8
	thumb_func_end sub_803BEC0

// symdb: Appends one 16-bit script entry to an object's animation/frame queue, looking up the entry from a double-indexed pointer table at off_803C208.
// symdb: void sub_803BF70(u8 indexOffset, u32 baseOffset, struct* obj);   // r0 = byte offset within obj
// symdb: of the write-index counter (read/byte, incremented)   // r1 = extra base offset added to obj for
// symdb: the halfword write target   // r5 = obj pointer (returned untouched)   // clobbers r0, r1, flags
// symdb: (NZCV); preserves r4, r6, r7
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803BF70.yaml
	thumb_local_start
sub_803BF70:
	push {r4-r7,lr}
	mov r6, r0
	mov r7, r1
	ldr r4, off_803BF9C // =off_803C208
	ldrb r0, [r5,#0x12]
	mov r1, #0x10
	mul r0, r1
	ldr r4, [r4,r0]
	ldrb r0, [r5,#8]
	mov r1, #8
	mul r0, r1
	add r4, r4, r0
	ldrh r4, [r4,#2]
	ldrb r0, [r5,r6]
	lsl r0, r0, #1
	mov r1, r5
	add r1, r1, r7
	strh r4, [r0,r1]
	ldrb r0, [r5,r6]
	add r0, #1
	strb r0, [r5,r6]
	pop {r4-r7,pc}
off_803BF9C:
	.word off_803C208
	thumb_func_end sub_803BF70

	thumb_local_start
sub_803BFA0:
	push {r4-r7,lr}
	lsl r6, r0, #2
	add r1, r1, r5
	ldrb r0, [r5,r2]
	lsl r0, r0, #1
	add r0, r0, r1
	ldrb r3, [r0]
	cmp r3, #0xe5
	beq loc_803BFBA
	cmp r3, #0
	beq loc_803BFBA
	cmp r3, #0xe6
	bne loc_803BFC4
loc_803BFBA:
	ldrb r0, [r5,r2]
	sub r0, #1
	blt loc_803BFD6
	lsl r0, r0, #1
	add r0, r0, r1
loc_803BFC4:
	mov r7, r0
	ldrh r4, [r7]
	ldr r1, off_803BFDC // =off_803BFE0
	ldr r1, [r1,r6]
	bl sub_803BFE8
	ldrh r0, [r7]
	cmp r0, r4
	pop {r4-r7,pc}
loc_803BFD6:
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_803BFDC:
	.word off_803BFE0
off_803BFE0:
	.word byte_803C228
	.word byte_803C238
	thumb_func_end sub_803BFA0

	thumb_local_start
sub_803BFE8:
	push {r4-r7,lr}
	ldr r4, off_803C014 // =off_803C208
	mov r6, r0
	mov r7, r1
loc_803BFF0:
	ldrb r0, [r7]
	cmp r0, #0xff
	beq locret_803C012
	ldr r0, [r4,r0]
	ldrh r1, [r6]
	bl sub_803C018
	cmp r0, #0xff
	beq loc_803C00E
	ldrb r1, [r7,#1]
	ldr r1, [r4,r1]
	mov r2, r6
	bl sub_803C034
	b locret_803C012
loc_803C00E:
	add r7, #2
	b loc_803BFF0
locret_803C012:
	pop {r4-r7,pc}
	.balign 4, 0
off_803C014:
	.word off_803C208
	thumb_func_end sub_803BFE8

	thumb_local_start
sub_803C018:
	mov r3, #0
loc_803C01A:
	ldrb r2, [r0,#2]
	cmp r2, #0xe6
	beq loc_803C030
	ldrh r2, [r0,#2]
	cmp r1, r2
	beq loc_803C02C
	add r3, #1
	add r0, #8
	b loc_803C01A
loc_803C02C:
	mov r0, r3
	mov pc, lr
loc_803C030:
	mov r0, #0xff
	mov pc, lr
	thumb_func_end sub_803C018

	thumb_local_start
sub_803C034:
	mov r3, #8
	mul r0, r3
	add r1, r1, r0
	ldrh r0, [r1,#2]
	strh r0, [r2]
	mov pc, lr
	thumb_func_end sub_803C034

	thumb_local_start
sub_803C040:
	push {r4-r7,lr}
	mov r4, #0
	ldrb r6, [r5,r0]
	lsl r6, r6, #1
	add r3, r5, r1
loc_803C04A:
	cmp r4, r6
	bge locret_803C066
	ldrb r0, [r3]
	cmp r0, #0xe6
	beq locret_803C066
	cmp r0, #0xe5
	bne loc_803C060
	mov r0, #0
	strb r0, [r3]
	mov r0, #0xe5
	strb r0, [r3,#1]
loc_803C060:
	add r3, #2
	add r4, #2
	b loc_803C04A
locret_803C066:
	pop {r4-r7,pc}
	thumb_func_end sub_803C040

	thumb_local_start
sub_803C068:
	push {r4-r7,lr}
	mov r6, r0
	mov r7, r1
	mov r4, #1
	ldrb r0, [r5,r6]
	lsl r0, r0, #1
	mov r1, r5
	add r1, r1, r7
	add r0, r0, r1
	ldrb r1, [r0]
	cmp r1, #0xe5
	beq loc_803C088
	cmp r1, #0
	beq loc_803C088
	cmp r1, #0xe6
	bne loc_803C09E
loc_803C088:
	ldrb r0, [r5,r6]
	sub r0, #1
	bge loc_803C092
	mov r0, #0
	mov r4, #0
loc_803C092:
	strb r0, [r5,r6]
	mov r0, r6
	mov r1, r7
	bl sub_803C0BE
	b loc_803C0B8
loc_803C09E:
	mov r2, #0
	strb r2, [r0]
	mov r2, #0xe5
	strb r2, [r0,#1]
	mov r0, r6
	mov r1, r7
	bl sub_803C0BE
	ldrb r0, [r5,r6]
	sub r0, #1
	bge loc_803C0B6
	mov r0, #0
loc_803C0B6:
	strb r0, [r5,r6]
loc_803C0B8:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_803C068

// symdb: Walks a 2-byte-per-entry list to its first 0xE6 terminator and, if that terminator lies past the used range, rewrites trailing free slots (0x00 or 0xE5 entries) into 0xE5 0xE5 pairs.
// symdb: void sub_803C0BE(u32 countOffset /*r0*/, u32 listOffset /*r1*/,                  struct* base
// symdb: /*r5*/, ...); /* out: r1 = address of the last 0xE5/0xE5 slot written (or original listOffset
// symdb: if nothing was written); r3 = base + listOffset;    flags NZ/C/V set from terminator/entry byte
// symdb: compares; r4-r7 preserved. */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803C0BE.yaml
	thumb_func_start sub_803C0BE
sub_803C0BE:
	push {r4-r7,lr}
	mov r4, #0
	ldrb r6, [r5,r0]
	lsl r6, r6, #1
	add r3, r5, r1
	mov r4, #0
loc_803C0CA:
	ldrb r0, [r3,r4]
	cmp r0, #0xe6
	beq loc_803C0D4
	add r4, #2
	b loc_803C0CA
loc_803C0D4:
	cmp r4, r6
	blt locret_803C0F4
	ldrb r0, [r3,r4]
	cmp r0, #0xe6
	beq loc_803C0F0
	cmp r0, #0
	beq loc_803C0E6
	cmp r0, #0xe5
	bne locret_803C0F4
loc_803C0E6:
	add r1, r3, r4
	mov r0, #0xe5
	strb r0, [r1]
	mov r0, #0xe5
	strb r0, [r1,#1]
loc_803C0F0:
	sub r4, #2
	b loc_803C0D4
locret_803C0F4:
	pop {r4-r7,pc}
	thumb_func_end sub_803C0BE

// symdb: Copies a chat/text region with an offset and rewrites trailing 0x00/0xE5 two-byte units to 0xE5 0xE5 until the previous 0xE6 marker.
// symdb: void sub_803C0F6(u8 *src, u8 *dest, int count, int offset)
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803C0F6.yaml
	thumb_local_start
sub_803C0F6:
	push {r4-r7,lr}
	mov r4, r1
	add r0, r0, r5
	add r1, r1, r5
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	add r3, r5, r4
	mov r4, #0
loc_803C106:
	ldrb r0, [r3,r4]
	cmp r0, #0xe6
	beq loc_803C110
	add r4, #2
	b loc_803C106
loc_803C110:
	cmp r4, #0
	blt locret_803C130
	ldrb r0, [r3,r4]
	cmp r0, #0xe6
	beq loc_803C12C
	cmp r0, #0
	beq loc_803C122
	cmp r0, #0xe5
	bne locret_803C130
loc_803C122:
	add r1, r3, r4
	mov r0, #0xe5
	strb r0, [r1]
	mov r0, #0xe5
	strb r0, [r1,#1]
loc_803C12C:
	sub r4, #2
	b loc_803C110
locret_803C130:
	pop {r4-r7,pc}
	thumb_func_end sub_803C0F6

// symdb: Counts halfword-strided table entries until hitting an end marker (0xE5 or 0xE6).
// symdb: u32 sub_803C132(u32 entryIndex r0, u32 byteOffset r1, const u8* tableBase r5) -> r0 = count, r3
// symdb: = marker address, flags N/Z from count (C=V=0)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803C132.yaml
	thumb_func_start sub_803C132
sub_803C132:
	push {r4-r7,lr}
	mov r4, #0
	ldrb r6, [r5,r0]
	lsl r6, r6, #1
	add r3, r5, r1
loc_803C13C:
	ldrb r0, [r3]
	cmp r0, #0xe6
	beq loc_803C14C
	cmp r0, #0xe5
	beq loc_803C14C
	add r4, #1
	add r3, #2
	b loc_803C13C
loc_803C14C:
	mov r0, r4
	pop {r4-r7,pc}
	thumb_func_end sub_803C132

	thumb_func_start sub_803C150
sub_803C150:
	push {r4-r7,lr}
	push {r2,r3}
	ldrh r2, [r5,#0x24]
	mov r3, #0x20
	bl sub_803C168
	pop {r0,r1}
	ldrh r2, [r5,#0x26]
	mov r3, #0x20
	bl sub_803C168
	pop {r4-r7,pc}
	thumb_func_end sub_803C150

	thumb_func_start sub_803C168
sub_803C168:
	push {r4-r7,lr}
	push {r0-r2}
	mov r0, r1
	mov r1, r3
	mov r2, #0xe5
	lsl r3, r2, #8
	orr r2, r3
	bl HalfwordFill
	pop {r0-r2}
	push {r0-r2}
	mov r0, #0xe6
	lsl r2, r2, #1
	strb r0, [r1,r2]
	pop {r0-r2}
	ldr r7, off_803C1A4 // =unk_2026A00
	add r7, #2
loc_803C18A:
	ldrb r3, [r0]
	tst r3, r3
	beq locret_803C1A0
	mov r4, #8
	mul r4, r3
	ldrh r3, [r7,r4]
	strh r3, [r1]
	add r0, #1
	add r1, #2
	sub r2, #1
	bgt loc_803C18A
locret_803C1A0:
	pop {r4-r7,pc}
	.balign 4, 0
off_803C1A4:
	.word unk_2026A00
	thumb_func_end sub_803C168

	thumb_func_start sub_803C1A8
sub_803C1A8:
	push {r4-r7,lr}
	push {r2,r3}
	ldrh r2, [r5,#0x24]
	bl sub_803C1BC
	pop {r0,r1}
	ldrh r2, [r5,#0x26]
	bl sub_803C1BC
	pop {r4-r7,pc}
	thumb_func_end sub_803C1A8

	thumb_func_start sub_803C1BC
sub_803C1BC:
	push {r4-r7,lr}
	mov r4, #0
	str r4, [r0]
	str r4, [r0,#4]
	str r4, [r0,#8]
	str r4, [r0,#0xc]
	ldr r7, off_803C204 // =unk_2026A00
	add r7, #2
loc_803C1CC:
	ldrb r3, [r1]
	cmp r3, #0xe6
	beq locret_803C200
	cmp r3, #0xe5
	beq locret_803C200
	cmp r3, #0
	beq loc_803C1EE
	ldrh r3, [r1]
	mov r4, #0
loc_803C1DE:
	ldrb r6, [r7,r4]
	cmp r6, #0xe6
	beq loc_803C1EE
	ldrh r6, [r7,r4]
	add r4, #8
	cmp r3, r6
	bne loc_803C1DE
	b loc_803C1F2
loc_803C1EE:
	mov r4, #0x21
	lsl r4, r4, #3
loc_803C1F2:
	lsr r4, r4, #3
	sub r4, #1
	strb r4, [r0]
	add r0, #1
	add r1, #2
	sub r2, #1
	bgt loc_803C1CC
locret_803C200:
	pop {r4-r7,pc}
	.balign 4, 0
off_803C204:
	.word unk_2026A00
off_803C208:
	.word unk_2024A00
	.word unk_2025200
	.word unk_2025A00
	.word unk_2026200
	.word unk_2024E00
	.word unk_2025600
	.word unk_2025E00
	.word unk_2026600
byte_803C228:
	.byte 0x0, 0x4, 0x4, 0x0, 0x8, 0x4, 0x10, 0x14, 0x14, 0x10, 0x18, 0x14
	.byte 0xFF, 0x0, 0x0, 0x0
byte_803C238:
	.byte 0x0, 0x8, 0x4, 0xC, 0x8, 0x0, 0x10, 0x18, 0x14, 0x1C, 0x18, 0x10
	.byte 0xFF, 0x0, 0x0, 0x0
	thumb_func_end sub_803C1BC

// symdb: Tests whether a range of 2-byte table slots starting at (base+index) contains only empty/placeholder entries, walking until a 0xE6 terminator.
// symdb: bool isSlotRangeEmpty_803C248(const void *base, u32 index); // r0=base, r5=index (bytes),
// symdb: returns r4=1 if empty / 0 if occupied, sets nz from r4, r5 preserved
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803C248.yaml
	thumb_local_start
sub_803C248:
	push {r4-r7,lr}
	mov r3, r5
	add r3, r3, r0
	mov r4, #1
loc_803C250:
	ldrb r0, [r3]
	add r3, #2
	cmp r0, #0xe6
	beq loc_803C264
	cmp r0, #0xe5
	beq loc_803C250
	cmp r0, #0
	beq loc_803C250
	mov r4, #0
	b loc_803C264
loc_803C264:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_803C248

	thumb_func_start sub_803C26A
sub_803C26A:
	push {r4-r7,lr}
	mov r0, #0x4c
	lsl r0, r0, #2
	add r0, r0, r5
	mov r1, #4
	lsl r1, r1, #2
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #0x54
	lsl r0, r0, #2
	add r0, r0, r5
	mov r1, #4
	lsl r1, r1, #2
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {r4-r7,pc}
	thumb_func_end sub_803C26A

	thumb_func_start sub_803C28A
sub_803C28A:
	push {r4-r7,lr}
	mov r6, r0
	bl sub_813D978
	mov r0, #8
	bl sub_803CB00
	mov r0, r6
	bl PlaySoundEffect
	pop {r4-r7,pc}
	thumb_func_end sub_803C28A

	thumb_func_start sub_803C2A0
sub_803C2A0:
	push {r4-r7,lr}
	mov r0, #8
	bl sub_803CB00
	pop {r4-r7,pc}
	thumb_func_end sub_803C2A0

	thumb_func_start sub_803C2AA
sub_803C2AA:
	push {r4-r7,lr}
	mov r4, r1
	mov r6, r2
	mov r7, r3
	ldr r1, off_803C2DC // =unk_200A400
	mov r2, #0x20
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	mov r0, r4
	ldr r1, off_803C2E0 // =unk_200A420
	mov r2, #0x20
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	mov r0, r6
	ldr r1, off_803C2E4 // =unk_200A3A0
	mov r2, #0x10
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	mov r0, r7
	ldr r1, off_803C2E8 // =unk_200A3B0
	mov r2, #0x10
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_803C2DC:
	.word unk_200A400
off_803C2E0:
	.word unk_200A420
off_803C2E4:
	.word unk_200A3A0
off_803C2E8:
	.word unk_200A3B0
	thumb_func_end sub_803C2AA

	thumb_local_start
sub_803C2EC:
	push {r4-r7,lr}
	pop {r4-r7,pc}
	thumb_func_end sub_803C2EC

	thumb_local_start
sub_803C2F0:
	push {r4-r7,lr}
	mov r3, r10
	ldr r3, [r3,#oToolkit_RenderInfoPtr]
	ldrh r0, [r3,#0x14]
	add r0, #0xa
	strh r0, [r3,#0x14]
	pop {r4-r7,pc}
	thumb_func_end sub_803C2F0

	thumb_local_start
sub_803C2FE:
	push {r4-r7,lr}
	pop {r4-r7,pc}
	thumb_func_end sub_803C2FE

	thumb_local_start
sub_803C302:
	ldr r2, off_803C32C // =eS200A290
	ldrh r1, [r2,#0x20] // (word_200A2B0 - 0x200a290)
	orr r1, r0
	strh r1, [r2,#0x20] // (word_200A2B0 - 0x200a290)
	mov pc, lr
	thumb_func_end sub_803C302

	thumb_local_start
sub_803C30C:
	ldr r2, off_803C32C // =eS200A290
	ldrh r1, [r2,#0x20] // (word_200A2B0 - 0x200a290)
	bic r1, r0
	strh r1, [r2,#0x20] // (word_200A2B0 - 0x200a290)
	mov pc, lr
	thumb_func_end sub_803C30C

	thumb_func_start sub_803C316
sub_803C316:
	push {lr}
	ldr r2, off_803C32C // =eS200A290
	ldrh r1, [r2,#0x20] // (word_200A2B0 - 0x200a290)
	tst r1, r0
	pop {pc}
	thumb_func_end sub_803C316

	thumb_func_start sub_803C320
sub_803C320:
	ldr r2, off_803C32C // =eS200A290
	mov r0, #0
	strh r0, [r2,#0x20] // (word_200A2B0 - 0x200a290)
	strb r0, [r2,#0x16] // (byte_200A2A6 - 0x200a290)
	mov pc, lr
	.balign 4, 0x00
off_803C32C:
	.word eS200A290
	thumb_func_end sub_803C320

	thumb_func_start sub_803C330
sub_803C330:
	push {r4-r7,lr}
	mov r0, #2
	bl sub_803CB18
	bne loc_803C34A
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_Pressed]
	mov r1, #2
	tst r0, r1
	beq loc_803C34A
	mov r0, #1
	pop {r4-r7,pc}
loc_803C34A:
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_803C330

	thumb_func_start sub_803C34E
sub_803C34E:
	push {r4-r7,lr}
	pop {r4-r7,pc}
	thumb_func_end sub_803C34E

// symdb: Initialize the 0x48-byte state block at A_word_2006770 (zero it, fill two 0x20-byte halfword regions with 0xE5E5 plus a 0xE6 terminator) and then call sub_802D150.
// symdb: void initStateBlock_803C352(void);  // no inputs; clobbers r0-r3, lr, flags N Z C V
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/initStateBlock_803C352.yaml
	thumb_local_start
initStateBlock_803C352:
	push {r4-r7,lr}
	ldr r5, off_803C430 // =word_2006770
	// memBlock
	mov r0, r5
	// size
	mov r1, #0x48
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, r5
	add r0, #8
	mov r1, #0x20
	mov r2, #0xe5
	mov r3, #0xe5
	lsl r3, r3, #8
	orr r2, r3
	bl HalfwordFill
	mov r0, r5
	add r0, #8
	mov r1, #0xe6
	strb r1, [r0,#0x10] // (byte_2006788 - 0x2006778)
	mov r0, r5
	add r0, #0x28
	mov r1, #0x20
	mov r2, #0xe5
	mov r3, #0xe5
	lsl r3, r3, #8
	orr r2, r3
	bl HalfwordFill
	mov r0, r5
	add r0, #0x28
	mov r1, #0xe6
	strb r1, [r0,#0x16] // (byte_20067AE - 0x2006798)
	bl sub_802D150
	pop {r4-r7,pc}
	thumb_func_end initStateBlock_803C352

	thumb_local_start
sub_803C398:
	ldr r3, off_803C430 // =word_2006770
	ldr r1, dword_803C3D4 // =0x3e7
	ldrh r2, [r3,#0x4] // (word_2006774 - 0x2006770)
	cmp r2, r1
	ble loc_803C3A4
	mov r2, r1
loc_803C3A4:
	strh r2, [r3,#0x4] // (word_2006774 - 0x2006770)
	ldrh r2, [r3,#0x6] // (word_2006776 - 0x2006770)
	cmp r2, r1
	ble loc_803C3AE
	mov r2, r1
loc_803C3AE:
	strh r2, [r3,#0x6] // (word_2006776 - 0x2006770)
	ldrh r0, [r3,#0x4] // (word_2006774 - 0x2006770)
	ldrh r1, [r3,#0x6] // (word_2006776 - 0x2006770)
	mov pc, lr
	thumb_func_end sub_803C398

	thumb_local_start
sub_803C3B6:
	ldr r3, off_803C430 // =word_2006770
	ldr r1, dword_803C3D4 // =0x3e7
	ldrh r2, [r3,#0x4] // (word_2006774 - 0x2006770)
	add r2, #1
	cmp r2, r1
	ble loc_803C3C4
	mov r2, r1
loc_803C3C4:
	strh r2, [r3,#0x4] // (word_2006774 - 0x2006770)
	ldrh r2, [r3,#0x6] // (word_2006776 - 0x2006770)
	add r2, r2, r0
	cmp r2, r1
	ble loc_803C3D0
	mov r2, r1
loc_803C3D0:
	strh r2, [r3,#0x6] // (word_2006776 - 0x2006770)
	mov pc, lr
	.balign 4, 0
dword_803C3D4:
	.word 0x3E7
	thumb_func_end sub_803C3B6

	thumb_local_start
sub_803C3D8:
	ldr r0, off_803C430 // =word_2006770
	mov r1, #1
	strb r1, [r0,#0x2] // (byte_2006772 - 0x2006770)
	mov pc, lr
	thumb_func_end sub_803C3D8

// symdb: Reads the flag byte at word_2006770+2 (byte_2006772) and returns it in r0 with Z/N flags reflecting its value.
// symdb: bool testByte_2006772(void) // in: lr only; out: r0 = byte value, Z set if zero, N set if bit7
// symdb: set
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803C3E0.yaml
	thumb_func_start sub_803C3E0
sub_803C3E0:
	ldr r0, off_803C430 // =word_2006770
	ldrb r0, [r0,#0x2] // (byte_2006772 - 0x2006770)
	tst r0, r0
	mov pc, lr
	thumb_func_end sub_803C3E0

	thumb_local_start
sub_803C3E8:
	push {r4-r7,lr}
	ldr r0, off_803C408 // =eS200A290
	add r0, #0x70
	ldr r1, off_803C430 // =word_2006770
	add r1, #8
	mov r2, #0x20
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	ldr r0, off_803C408 // =eS200A290
	add r0, #0xd0
	ldr r1, off_803C430 // =word_2006770
	add r1, #0x28
	mov r2, #0x20
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_803C408:
	.word eS200A290
	thumb_func_end sub_803C3E8

// symdb: Draws one primary RNG value and stores its low halfword at word_2006770; plausibly a link-session token.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_803C40C.yaml
	thumb_local_start
sub_803C40C:
	push {r4-r7,lr}
	bl GetRNG // () -> u32?
	ldr r1, off_803C430 // =word_2006770
	strh r0, [r1]
	pop {r4-r7,pc}
	thumb_func_end sub_803C40C

	thumb_local_start
sub_803C418:
	push {r4-r7,lr}
	ldr r1, off_803C430 // =word_2006770
	ldrh r0, [r1]
	mov r3, r10
	ldr r3, [r3,#oToolkit_MainJumptableIndexPtr]
	ldrb r3, [r3]
	cmp r3, #0x18
	beq locret_803C42C
	bl sub_8049D7C
locret_803C42C:
	pop {r4-r7,pc}
	.balign 4, 0
off_803C430:
	.word word_2006770
	thumb_func_end sub_803C418

	thumb_local_start
sub_803C434:
	lsl r0, r0, #2
	ldr r3, off_803C460 // =unk_200A3C0
	str r1, [r3,r0]
	ldr r3, off_803C464 // =unk_200A3E0
	str r2, [r3,r0]
	mov pc, lr
	thumb_func_end sub_803C434

	thumb_func_start sub_803C440
sub_803C440:
	lsl r0, r0, #2
	ldr r3, off_803C464 // =unk_200A3E0
	ldr r1, [r3,r0]
	ldr r3, off_803C460 // =unk_200A3C0
	ldr r0, [r3,r0]
	tst r0, r0
	bne loc_803C450
	ldr r0, off_803C468 // =byte_803C46C
loc_803C450:
	tst r1, r1
	bne locret_803C456
	ldr r1, off_803C478 // =byte_803C47C
locret_803C456:
	mov pc, lr
	thumb_func_end sub_803C440

	thumb_local_start
sub_803C458:
	ldr r0, off_803C468 // =byte_803C46C
	ldr r1, off_803C478 // =byte_803C47C
	mov pc, lr
	.balign 4, 0
off_803C460:
	.word unk_200A3C0
off_803C464:
	.word unk_200A3E0
off_803C468:
	.word byte_803C46C
byte_803C46C:
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x0, 0x0, 0x0, 0x0
off_803C478:
	.word byte_803C47C
byte_803C47C:
	.byte 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x5, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_803C458

	thumb_local_start
sub_803C48C:
	push {r4-r7,lr}
	ldr r5, off_803C4AC // =eS200A290
	mov r4, #0xfe
	mov r0, #8
	bl sub_803CB18
	bne loc_803C4A6
	mov r4, #0xff
	mov r0, #4
	bl sub_803CB18
	beq loc_803C4A6
	ldrb r4, [r5,#0x16] // (byte_200A2A6 - 0x200a290)
loc_803C4A6:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803C4AC:
	.word eS200A290
	thumb_func_end sub_803C48C

	thumb_local_start
sub_803C4B0:
	push {r4-r7,lr}
	ldr r5, off_803C4BC // =eS200A290
	mov r0, #0x10
	bl sub_803CB00
	pop {r4-r7,pc}
	.balign 4, 0
off_803C4BC:
	.word eS200A290
	thumb_func_end sub_803C4B0

	thumb_local_start
sub_803C4C0:
	ldr r0, off_803C4CC // =unk_2006778
	ldr r1, off_803C4D0 // =unk_2006798
	ldr r2, off_803C4D4 // =unk_200A400
	ldr r3, off_803C4D8 // =unk_200A420
	mov pc, lr
	.balign 4, 0
off_803C4CC:
	.word unk_2006778
off_803C4D0:
	.word unk_2006798
off_803C4D4:
	.word unk_200A400
off_803C4D8:
	.word unk_200A420
	thumb_func_end sub_803C4C0

	thumb_local_start
sub_803C4DC:
	push {r4-r7,lr}
	ldr r5, off_803C510 // =eS200A290
	bl sub_813D978
	mov r0, #8
	bl sub_803CB00
	pop {r4-r7,pc}
	thumb_func_end sub_803C4DC

	thumb_local_start
sub_803C4EC:
	push {r4-r7,lr}
	ldr r5, off_803C510 // =eS200A290
	bl sub_813D978
	mov r0, #8
	bl sub_803CB00
	mov r0, #0x80
	bl sub_803CB00
	pop {r4-r7,pc}
	thumb_func_end sub_803C4EC

	thumb_local_start
sub_803C502:
	push {r4-r7,lr}
	ldr r5, off_803C510 // =eS200A290
	mov r0, #8
	bl sub_803CB18
	pop {r4-r7,pc}
	.balign 4, 0
off_803C510:
	.word eS200A290
	thumb_func_end sub_803C502

	thumb_func_start sub_803C514
sub_803C514:
	push {r4-r7,lr}
	ldr r5, off_803C52C // =eS200A290
	mov r4, #0
	mov r0, #0x10
	lsl r0, r0, #4
	bl sub_803CB18
	beq loc_803C526
	mov r4, #1
loc_803C526:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803C52C:
	.word eS200A290
	thumb_func_end sub_803C514

	thumb_local_start
sub_803C530:
	push {r4-r7,lr}
	ldr r5, off_803C54C // =eS200A290
	mov r4, #0
	ldr r0, off_803C554 // =0x200
	bl sub_803CB18
	beq loc_803C546
	ldr r0, off_803C550 // =off_8039370
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	mov r4, #1
loc_803C546:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803C54C:
	.word eS200A290
off_803C550:
	.word off_8039370
off_803C554:
	.word 0x200
	thumb_func_end sub_803C530

	thumb_func_start sub_803C558
sub_803C558:
	push {r4-r7,lr}
	bl sub_803C26A
	bl sub_81467A0
	pop {r4-r7,pc}
	thumb_func_end sub_803C558

	thumb_local_start
sub_803C564:
	push {r4-r7,lr}
	ldr r5, off_803C57C // =eS200A290
	mov r0, #2
	bl sub_803CB00
	pop {r4-r7,pc}
	thumb_func_end sub_803C564

	thumb_local_start
sub_803C570:
	push {r4-r7,lr}
	ldr r5, off_803C57C // =eS200A290
	mov r0, #2
	bl sub_803CB0C
	pop {r4-r7,pc}
	.balign 4, 0
off_803C57C:
	.word eS200A290
	thumb_func_end sub_803C570

	thumb_local_start
sub_803C580:
	push {r4-r7,lr}
	ldr r5, off_803C598 // =eS200A290
	mov r0, #0x40
	bl sub_803CB00
	pop {r4-r7,pc}
	thumb_func_end sub_803C580

	thumb_local_start
sub_803C58C:
	push {r4-r7,lr}
	ldr r5, off_803C598 // =eS200A290
	mov r0, #0x40
	bl sub_803CB0C
	pop {r4-r7,pc}
	.balign 4, 0
off_803C598:
	.word eS200A290
	thumb_func_end sub_803C58C

// symdb: Appends a custom-screen OAM entry and uploads the next chip-cursor tile to VRAM each frame, gated on the chip-cursor singleton's state.
// symdb: (r0 = packed_OAM_word0, r1 = packed_OAM_word1) -> r0 = packed_OAM_word0 ; r0/r1 also clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_setupCustomChipCursorState_803C59C.yaml
	thumb_func_start battleObject_setupCustomChipCursorState_803C59C
battleObject_setupCustomChipCursorState_803C59C:
	push {r4-r7,lr}
	ldr r5, off_803C600 // =byte_200BC60
	push {r0,r1}
	bl library_isCommsBusy_8146BF4
	pop {r0,r1}
	beq locret_803C5EC
	push {r0,r1}
	bl sub_8146BB8
	sub r0, #1
	strb r0, [r5,#0x1] // (byte_200BC61 - 0x200bc60)
	pop {r0,r1}
	lsl r0, r0, #0x10
	orr r1, r0
	ldr r0, dword_803C5F0 // =0x40000000
	orr r0, r1
	ldr r1, dword_803C5F4 // =0xe3f4
	mov r2, #0
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	ldrb r0, [r5]
	add r0, #1
	strb r0, [r5]
	lsr r0, r0, #4
	mov r1, #3
	and r0, r1
	ldrb r1, [r5,#0x1] // (byte_200BC61 - 0x200bc60)
	cmp r0, r1
	ble loc_803C5DE
	mov r0, #0
	strb r0, [r5]
loc_803C5DE:
	lsl r0, r0, #7
	ldr r1, off_803C5F8 // =dword_86A5300
	add r0, r0, r1
	ldr r1, dword_803C5FC // =0x6017e80
	mov r2, #0x80
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
locret_803C5EC:
	pop {r4-r7,pc}
	.balign 4, 0
dword_803C5F0:
	.word 0x40000000
dword_803C5F4:
	.word 0xE3F4
off_803C5F8:
	.word dword_86A5300
dword_803C5FC:
	.word 0x6017E80
off_803C600:
	.word byte_200BC60
	thumb_func_end battleObject_setupCustomChipCursorState_803C59C

	thumb_func_start sub_803C604
sub_803C604:
	push {r4-r7,lr}
	ldr r5, off_803C61C // =eS200A290
	bl sub_803A104
	bl sub_8049BC0
	pop {r4-r7,pc}
	thumb_func_end sub_803C604

	thumb_func_start sub_803C612
sub_803C612:
	push {r4-r7,lr}
	ldr r5, off_803C61C // =eS200A290
	bl sub_803A1B0
	pop {r4-r7,pc}
	.balign 4, 0
off_803C61C:
	.word eS200A290
	thumb_func_end sub_803C612

	thumb_func_start dispatch_803C620
dispatch_803C620: // () -> (u32?, bool)
	push {r4-r7,lr}
	mov r0, #2
	bl sub_803CB0C
	mov r0, #0x40
	bl sub_803CB0C
	ldr r7, off_803C648 // =eS200BC50
	ldrb r0, [r7, #oS200BC50_Index00]
	mov r1, #FALSE
	tst r0, r0
	beq loc_803C642

	lsl r0, r0, #2
	ldr r1, off_803C64C // =dword_803C650
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0

loc_803C642:
	tst r0, r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803C648:
	.word eS200BC50
off_803C64C:
	.word dword_803C650
dword_803C650:
	// 0x00
	.word NULL
	// 0x04
	.word sub_803C6A8+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x08
	.word sub_803C6C0+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x0C
	.word sub_803C6D8+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x10
	.word sub_803C6F4+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x14
	.word dispatch_803C702+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x18
	.word sub_803C76C+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x1C
	.word sub_803C790+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x20
	.word sub_803C83A+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x24
	.word sub_803C842+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x28
	.word sub_803C84A+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x2C
	.word sub_803C85C+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x30
	.word sub_803C86A+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x34
	.word sub_803C94C+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x38
	.word sub_803C97C+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x3C
	.word sub_803C9A4+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x40
	.word sub_803C9B6+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x44
	.word sub_803C9BE+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x48
	.word sub_803CA2C+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x4C
	.word sub_803C94C+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x50
	.word sub_803C94C+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	// 0x54
	.word sub_803C754+1 // (self: * S200BC50 $r7) -> (u32?, bool)
	thumb_func_end dispatch_803C620

	thumb_local_start
sub_803C6A8: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	ldr r0, off_803C6BC // =0x34
	bl sub_813D9A0
	mov r0, #0
	bl sub_813D934
	mov r0, #1
	mov r1, #0
	pop {pc}
	.balign 4, 0
off_803C6BC:
	.word 0x34
	thumb_func_end sub_803C6A8

	thumb_local_start
sub_803C6C0: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	bl sub_813D978
	mov r0, #8
	bl sub_803CB00
	mov r0, #0x80
	bl sub_803CB00
	mov r0, #1
	mov r1, #1
	pop {pc}
	thumb_func_end sub_803C6C0

	thumb_local_start
sub_803C6D8: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	bl rfu_clearAllSlot
	bl sub_813D978
	mov r0, #8
	bl sub_803CB00
	mov r0, #0x80
	bl sub_803CB00
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803C6D8

	thumb_local_start
sub_803C6F4: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	ldr r0, byte_803CAB4 // =0x33
	bl sub_813D9A0
	mov r0, #1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803C6F4

	thumb_local_start
dispatch_803C702: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	ldrb r0, [r7,#2]
	lsl r0, r0, #2
	ldr r1, off_803C714 // =off_803C718
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	tst r0, r0
	pop {pc}
off_803C714:
	.word off_803C718
off_803C718:
	.word sub_803C720+1
	.word sub_803C730+1
	thumb_func_end dispatch_803C702

	thumb_local_start
sub_803C720:
	push {lr}
	mov r0, #0xc8
	strh r0, [r7,#0xa]
	mov r0, #1
	strb r0, [r7,#2]
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803C720

	thumb_local_start
sub_803C730:
	push {lr}
	ldrh r0, [r7,#0xa]
	sub r0, #1
	strh r0, [r7,#0xa]
	bne loc_803C74A
	ldr r0, dword_803C750 // =0x9
	bl sub_813D9A0
	mov r0, #0
	strb r0, [r7]
	mov r0, #1
	mov r1, #0
	pop {pc}
loc_803C74A:
	mov r0, #0
	mov r1, #0
	pop {pc}
	.balign 4, 0
dword_803C750:
	.word 0x9
	thumb_func_end sub_803C730

	thumb_func_start sub_803C754
sub_803C754: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	ldr r0, dword_803C768 // =0x32
	bl sub_813D9A0

	// trigger stop via dispatch_803C620
	mov r0, #0
	strb r0, [r7, #oS200BC50_Index00]

	mov r0, #1
	mov r1, #0
	pop {pc}
	.balign 4, 0
dword_803C768:
	.word 0x32
	thumb_func_end sub_803C754

	thumb_local_start
sub_803C76C: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	mov r0, #2
	bl sub_803CB00
	bl sub_814665C
	bl sub_814673C
	mov r0, #0
	strb r0, [r7,#3]
	ldr r0, off_803C78C // =0x12c
	strh r0, [r7,#0xa]
	mov r0, #0
	mov r1, #0
	pop {pc}
	.balign 4, 0
off_803C78C:
	.word 0x12C
	thumb_func_end sub_803C76C

	thumb_local_start
sub_803C790: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	ldr r1, off_803C7A8 // =off_803C7AC
	ldrb r0, [r7,#3]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	mov r0, #0
	mov r1, #0
	pop {pc}
	.balign 4, 0x00
	.word byte_2010288
off_803C7A8:
	.word off_803C7AC
off_803C7AC:
	.word sub_803C7B4+1
	.word sub_803C7E8+1
	thumb_func_end sub_803C790

	thumb_local_start
sub_803C7B4:
	push {lr}
	bl sub_803CB44
	beq loc_803C7C0
	bl sub_81467A0
loc_803C7C0:
	ldr r1, off_803C7E0 // =byte_2010288
	ldrb r1, [r1]
	tst r1, r1
	beq locret_803C7DE
	bl sub_803CB24
	cmp r0, #0xff
	beq locret_803C7DE
	mov r0, #4
	strb r0, [r7,#3]
	ldr r0, off_803C7E4 // =0xb4
	strh r0, [r7,#0xa]
	mov r0, #0x40
	bl sub_803CB00
locret_803C7DE:
	pop {pc}
	.balign 4, 0
off_803C7E0:
	.word byte_2010288
off_803C7E4:
	.word 0xB4
	thumb_func_end sub_803C7B4

	thumb_local_start
sub_803C7E8:
	push {lr}
	bl sub_803CB24
	cmp r0, #0xff
	beq locret_803C838
	cmp r0, #0xfe
	beq loc_803C7FE
	bl sub_8146808
	cmp r0, #4
	bne loc_803C81E
loc_803C7FE:
	mov r0, #0x40
	bl sub_803CB00
	ldrh r0, [r7,#0xa]
	sub r0, #1
	strh r0, [r7,#0xa]
	bne locret_803C838
	bl sub_813D978
	mov r0, #8
	bl sub_803CB00
	mov r0, #0x80
	bl sub_803CB00
	b locret_803C838
loc_803C81E:
	bl sub_8146888
	tst r0, r0
	bne locret_803C838
	mov r0, #0
	bl sub_813D934
	mov r0, #0
	strb r0, [r7,#3]
	bl sub_8146CFC
	bl sub_813DA84
locret_803C838:
	pop {pc}
	thumb_func_end sub_803C7E8

	thumb_local_start
sub_803C83A: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	mov r0, #1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803C83A

	thumb_local_start
sub_803C842: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803C842

	thumb_local_start
sub_803C84A: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	bl sub_81468F4
	mov r4, r0
	bl sub_814690C
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803C84A

	thumb_local_start
sub_803C85C: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	mov r0, #2
	bl sub_803CB00
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803C85C

	thumb_local_start
sub_803C86A: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	ldr r1, off_803C878 // =off_803C87C
	ldrb r0, [r7,#3]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {pc}
off_803C878:
	.word off_803C87C
off_803C87C:
	.word sub_803C888+1
	.word sub_803C8B4+1
	.word sub_803C8E8+1
	thumb_func_end sub_803C86A

	thumb_local_start
sub_803C888:
	push {lr}
	ldr r0, off_803C944 // =byte_200AF80
	mov r1, #4
	str r1, [r0,#0x14] // (dword_200AF94 - 0x200af80)
	ldr r1, off_803C948 // =unk_200FE70
	str r1, [r0,#0xc] // (dword_200AF8C - 0x200af80)
	bl sub_8146D40
	tst r0, r0
	bne loc_803C8AC
	mov r0, #0x40
	bl sub_803CB00
	mov r0, #2
	bl sub_803CB0C
	mov r0, #4
	strb r0, [r7,#3]
loc_803C8AC:
	bl sub_803C90C
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_803C888

	thumb_local_start
sub_803C8B4:
	push {r4,lr}
	ldr r0, off_803C944 // =byte_200AF80
	mov r4, r0
	bl sub_8146D98
	ldrb r0, [r4,#0x1] // (byte_200AF81 - 0x200af80)
	cmp r0, #1
	bne loc_803C8E0
	ldr r0, [r4,#0xc] // (dword_200AF8C - 0x200af80)
	ldrb r0, [r0]
	tst r0, r0
	beq loc_803C8E0
	mov r0, r4
	mov r1, #1
	bl sub_8146E5C
	mov r0, #0x22
	bl sub_813D9A0
	mov r0, #0
	bl sub_813D934
loc_803C8E0:
	bl sub_803C90C
	pop {r4,pc}
	.balign 4, 0x00
	thumb_func_end sub_803C8B4

	thumb_local_start
sub_803C8E8:
	push {r4,lr}
	ldr r4, off_803C944 // =byte_200AF80
	mov r0, r4
	bl sub_8146D98
	ldrb r0, [r4,#0x1] // (byte_200AF81 - 0x200af80)
	cmp r0, #1
	bne loc_803C906
	ldr r0, [r4,#0xc] // (dword_200AF8C - 0x200af80)
	ldrb r0, [r0]
	tst r0, r0
	beq loc_803C906
	bl sub_813D978
	b locret_803C90A
loc_803C906:
	bl sub_803C90C
locret_803C90A:
	pop {r4,pc}
	thumb_func_end sub_803C8E8

	thumb_local_start
sub_803C90C:
	push {lr}
	ldr r0, off_803C940 // =byte_2010280
	ldrb r0, [r0]
	tst r0, r0
	beq loc_803C91E
	bl sub_8146938
	tst r0, r0
	beq loc_803C926
loc_803C91E:
	mov r0, #2
	mov r1, #0
	pop {pc}
	b loc_803C938
loc_803C926:
	mov r0, #4
	bl sub_803CB18
	beq loc_803C938
	mov r0, #0x22
	bl sub_813D9A0
	mov r0, #8
	strb r0, [r7,#3]
loc_803C938:
	mov r0, #0
	mov r1, #0
	pop {pc}
	.balign 4, 0
off_803C940:
	.word byte_2010280
off_803C944:
	.word byte_200AF80
off_803C948:
	.word unk_200FE70
	thumb_func_end sub_803C90C

	thumb_local_start
sub_803C94C: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	bl IsCurSubsystemInUse // () -> (bool, !zf)
	bne loc_803C966
	ldr r0, dword_803C978 // =0x1
	bl sub_813D9A0
	mov r0, #0
	bl sub_813D934
	mov r0, #1
	mov r1, #0
	pop {pc}
loc_803C966:
	bl sub_813D978
	mov r0, #0
	bl sub_813D934
	mov r0, #1
	mov r1, #0
	pop {pc}
	.balign 4, 0
dword_803C978:
	.word 0x1
	thumb_func_end sub_803C94C

	thumb_local_start
sub_803C97C: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {r4,lr}
	ldr r0, off_803C9A0 // =byte_200AF80
	ldrb r0, [r0,#0x4] // (byte_200AF84 - 0x200af80)
	bl sub_8146918
	mov r4, r0
	bl sub_814690C
	cmp r4, r0
	blt loc_803C99A
	bl sub_813D978
	mov r0, #2
	mov r1, #0
	pop {r4,pc}
loc_803C99A:
	mov r0, #0
	mov r1, #0
	pop {r4,pc}
	.balign 4, 0
off_803C9A0:
	.word byte_200AF80
	thumb_func_end sub_803C97C

	thumb_local_start
sub_803C9A4: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	bl sub_813D978
	mov r0, #0
	bl sub_813D934
	mov r0, #1
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803C9A4

	thumb_local_start
sub_803C9B6: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_803C9B6

	thumb_local_start
sub_803C9BE: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	ldr r1, off_803C9D0 // =off_803C9D4
	ldrb r0, [r7,#3]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	mov r0, #0
	mov r1, #0
	pop {pc}
off_803C9D0:
	.word off_803C9D4
off_803C9D4:
	.word sub_803C9DC+1
	.word sub_803CA10+1
	thumb_func_end sub_803C9BE

	thumb_local_start
sub_803C9DC:
	push {lr}
	mov r0, #8
	bl sub_803CB18
	beq locret_803CA04
	ldr r4, off_803CA08 // =byte_2010144
	// memBlock
	mov r0, r4
	// size
	mov r1, #0x10
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #1
	strb r0, [r4]
	ldr r1, off_803CA0C // =byte_200AF80
	mov r0, #4
	strb r0, [r1,#0x10] // (byte_200AF90 - 0x200af80)
	str r4, [r1,#0x8] // (dword_200AF88 - 0x200af80)
	bl sub_8146D20
	mov r0, #4
	strb r0, [r7,#3]
locret_803CA04:
	pop {pc}
	.balign 4, 0
off_803CA08:
	.word byte_2010144
off_803CA0C:
	.word byte_200AF80
	thumb_func_end sub_803C9DC

	thumb_local_start
sub_803CA10:
	push {lr}
	ldr r4, off_803CA28 // =byte_200AF80
	mov r0, r4
	bl sub_8146C20
	ldrb r0, [r4,#0x2] // (byte_200AF82 - 0x200af80)
	tst r0, r0
	bne locret_803CA24
	mov r0, #1
	strb r0, [r4,#0x5] // (byte_200AF85 - 0x200af80)
locret_803CA24:
	pop {pc}
	.balign 4, 0
off_803CA28:
	.word byte_200AF80
	thumb_func_end sub_803CA10

	thumb_local_start
sub_803CA2C: // (self: * S200BC50 $r7) -> (u32?, bool)
	push {lr}
	ldr r0, off_803CA60 // =byte_200AF80
	ldrb r0, [r0,#0x5] // (byte_200AF85 - 0x200af80)
	tst r0, r0
	beq loc_803CA42
	bl sub_813D978
	mov r0, #8
	bl sub_803CB00
	b loc_803CA4C
loc_803CA42:
	ldr r1, off_803CA54 // =off_803CA58
	ldrb r0, [r7,#3]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
loc_803CA4C:
	mov r0, #0
	mov r1, #0
	pop {pc}
	.balign 4, 0
off_803CA54:
	.word off_803CA58
off_803CA58:
	.word sub_803CA64+1
	.word sub_803CA90+1
off_803CA60:
	.word byte_200AF80
	thumb_func_end sub_803CA2C

	thumb_local_start
sub_803CA64:
	push {lr}
	ldr r4, off_803CAAC // =byte_2010144
	// memBlock
	mov r0, r4
	// size
	mov r1, #0x10
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #1
	strb r0, [r4]
	ldr r1, off_803CAB0 // =byte_200AF80
	mov r0, #4
	strb r0, [r1,#0x10] // (byte_200AF90 - 0x200af80)
	str r4, [r1,#0x8] // (dword_200AF88 - 0x200af80)
	bl sub_8146D20
	tst r0, r0
	beq loc_803CA88
	bl sub_803CA90
loc_803CA88:
	mov r0, #4
	strb r0, [r7,#3]
	pop {pc}
	.byte 0, 0
	thumb_func_end sub_803CA64

	thumb_local_start
sub_803CA90:
	push {r4,lr}
	ldr r4, off_803CAB0 // =byte_200AF80
	mov r0, r4
	bl sub_8146C20
	ldrb r0, [r4,#0x2] // (byte_200AF82 - 0x200af80)
	tst r0, r0
	bne locret_803CAAA
	bl sub_813D978
	mov r0, #8
	bl sub_803CB00
locret_803CAAA:
	pop {r4,pc}
	.balign 4, 0
off_803CAAC:
	.word byte_2010144
off_803CAB0:
	.word byte_200AF80
byte_803CAB4:
	.byte 0x33, 0x0, 0x0, 0x0, 0x5, 0x0, 0x0, 0x0, 0x0, 0xB5, 0x1, 0x20, 0x0, 0x21
	.byte 0x0, 0xBD
	thumb_func_end sub_803CA90

	thumb_local_start
sub_803CAC4:
	push {r4-r7,lr}
	bl sub_813D638
	mov r6, r0
	tst r6, r6
	beq locret_803CAF4
	mov r4, #0
loc_803CAD2:
	mov r0, r4
	bl sub_81466E4
	push {r0}
	mov r0, r4
	bl sub_8146714
	pop {r1}
	push {r0-r3}
	mov r2, r0
	mov r0, r4
	bl sub_803C434
	pop {r0-r3}
	add r4, #1
	sub r6, #1
	bne loc_803CAD2
locret_803CAF4:
	pop {r4-r7,pc}
	.byte 0x0, 0x0
	thumb_func_end sub_803CAC4

	thumb_func_start sub_803CAF8
sub_803CAF8:
	ldr r3, off_803CB20 // =eS200BC50
	ldr r0, [r3,#0xc] // (dword_200BC5C - 0x200bc50)
	mov pc, lr
	.byte 0x0, 0x0
	thumb_func_end sub_803CAF8

	thumb_func_start sub_803CB00
sub_803CB00:
	ldr r3, off_803CB20 // =eS200BC50
	ldr r1, [r3,#0xc] // (dword_200BC5C - 0x200bc50)
	orr r1, r0
	str r1, [r3,#0xc] // (dword_200BC5C - 0x200bc50)
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end sub_803CB00

	thumb_func_start sub_803CB0C
sub_803CB0C:
	ldr r3, off_803CB20 // =eS200BC50
	ldr r1, [r3,#0xc] // (dword_200BC5C - 0x200bc50)
	bic r1, r0
	str r1, [r3,#0xc] // (dword_200BC5C - 0x200bc50)
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end sub_803CB0C

	thumb_func_start sub_803CB18
sub_803CB18:
	ldr r3, off_803CB20 // =eS200BC50
	ldr r1, [r3,#0xc] // (dword_200BC5C - 0x200bc50)
	tst r1, r0
	mov pc, lr
off_803CB20:
	.word eS200BC50
	thumb_func_end sub_803CB18

	thumb_local_start
sub_803CB24:
	push {r4,lr}
	mov r4, #0xfe
	mov r0, #8
	bl sub_803CB18
	bne loc_803CB3C
	mov r4, #0xff
	mov r0, #4
	bl sub_803CB18
	beq loc_803CB3C
	ldrb r4, [r7,#6]
loc_803CB3C:
	mov r0, r4
	tst r0, r0
	pop {r4,pc}
	.balign 4, 0x00
	thumb_func_end sub_803CB24

	thumb_local_start
sub_803CB44:
	push {r4,r7,lr}
	ldr r0, off_803CB74 // =0x200
	bl sub_803CB0C
	mov r4, #0
	mov r0, #1
	bl sub_803CB18
	beq loc_803CB6C
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	ldrh r0, [r7,#oJoypad_Pressed]
	mov r1, #0x30
	lsl r1, r1, #4
	tst r0, r1
	beq loc_803CB6C
	ldr r0, off_803CB74 // =0x200
	bl sub_803CB00
	mov r4, #1
loc_803CB6C:
	mov r0, r4
	tst r0, r0
	pop {r4,r7,pc}
	.balign 4, 0
off_803CB74:
	.word 0x200
	thumb_func_end sub_803CB44

	thumb_func_start sub_803CB78
sub_803CB78:
	push {lr}
	ldr r1, off_803CB88 // =eS200BC50
	ldrb r0, [r1]
	cmp r0, #7
	bne locret_803CB86
	bl sub_803CAC4
locret_803CB86:
	pop {pc}
	.balign 4, 0
off_803CB88:
	.word eS200BC50
	thumb_func_end sub_803CB78

	thumb_func_start sub_803CB8C
sub_803CB8C:
	push {r4-r7,lr}
	ldr r5, off_803CBB8 // =byte_2008978
	mov r4, r0
	// memBlock
	mov r0, r5
	// size
	mov r1, #8
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	str r4, [r5,#0x4] // (dword_200897C - 0x2008978)
	mov r1, r10
	ldr r1, [r1,#oToolkit_MainJumptableIndexPtr]
	mov r0, #0x1c
	strb r0, [r1]
	pop {r4-r7,pc}
	thumb_func_end sub_803CB8C

	thumb_func_start cb_803CBA6
cb_803CBA6:
	push {r4-r7,lr}
	ldr r5, off_803CBB8 // =byte_2008978
	ldr r0, off_803CBBC // =off_803CBC0
	ldrb r1, [r5]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803CBB8:
	.word byte_2008978
off_803CBBC:
	.word off_803CBC0
off_803CBC0:
	.word sub_803CBD0+1
	.word sub_803CC14+1
	.word sub_803CC28+1
	.word t1_screenFadeBlankAndDispatch+1
	thumb_func_end cb_803CBA6

	thumb_local_start
sub_803CBD0:
	push {r4-r7,lr}
	bl chatbox_8040818
	mov r0, #0x15
	bl toolkit_applyOverlayPalette_80015FC
	ldr r0, dword_803CC10 // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()
	bl resetAllGraphicsState_8005F40
	bl runSetupStepAndClearWorkArea_8005F6C
	bl sprite_initBattleFadeGfxState_80027C4
	bl copyData_803CC60
	mov r0, #0x63
	bl music_80005F2 // (bg_music_indicator: u8) -> ()
	mov r0, #8
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #4
	strb r0, [r5]
	pop {r4-r7,pc}
	.balign 4, 0
dword_803CC10:
	.word 0x1F40
	thumb_func_end sub_803CBD0

	thumb_local_start
sub_803CC14:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq locret_803CC26
	mov r0, #0xb
	bl RunTextScriptCommError_803CCB0
	mov r0, #8
	strb r0, [r5]
locret_803CC26:
	pop {r4-r7,pc}
	thumb_func_end sub_803CC14

	thumb_local_start
sub_803CC28:
	push {r4-r7,lr}
	mov r0, #8
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	beq locret_803CC3E
	mov r0, #0xc
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0xc
	strb r0, [r5]
locret_803CC3E:
	pop {r4-r7,pc}
	thumb_func_end sub_803CC28

// symdb: While a screen fade is active, blanks the BG layers (LCD control 0x40), runs a chatbox update, then tail-jumps to a handler pointer stored in a struct at [r5+4].
// symdb: (r0 = unused on entry; r5 = pointer to a struct whose +4 field is a function pointer) -> does
// symdb: not return to caller normally; control passes to the [r5+4] handler, whose return reaches this
// symdb: function's caller; flags clobbered by calls.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/t1_screenFadeBlankAndDispatch.yaml
	thumb_local_start
t1_screenFadeBlankAndDispatch:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq locret_803CC58
	bl chatbox_8040818
	ldr r0, off_803CC5C // =0x40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	ldr r0, [r5,#4]
	mov lr, pc
	bx r0
locret_803CC58:
	pop {r4-r7,pc}
	.balign 4, 0
off_803CC5C:
	.word 0x40
	thumb_func_end t1_screenFadeBlankAndDispatch

	thumb_local_start
copyData_803CC60:
	push {r4-r7,lr}
	bl zeroFillVRAM // () -> ()
	bl ZeroFillGFX30025c0
	// initRefs
	ldr r0, off_803CC84 // =initRefs803CC88
	bl decompAndCopyData // (u32 *initRefs) -> void
	// j
	mov r0, #0
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #1
	ldr r3, off_803CC9C // =byte_2017A00
	// tileIds
	add r3, #4
	mov r4, #0x1e
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_803CC84:
	.word initRefs803CC88
initRefs803CC88:
  .word comp_87E6980 + COMPRESSED_PTR_FLAG
  .word 0x06000020
	.word eDecompBuffer2013A00

	.word comp_87E6BFC + COMPRESSED_PTR_FLAG
	.word NULL
off_803CC9C:
	.word byte_2017A00

	.word byte_87E6BDC
	.word palette_3001960
  .word 0x20

  .word NULL

	thumb_func_end copyData_803CC60

	thumb_local_start
RunTextScriptCommError_803CCB0:
	push {r4-r7,lr}
	mov r1, r0
	ldr r0, off_803CCBC // =TextScriptCommError873B9E0
	bl chatbox_runScript_803FD9C // (TextScriptArchive *archive, u8 scriptIdx) -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_803CCBC:
	.word TextScriptCommError873B9E0
	thumb_func_end RunTextScriptCommError_803CCB0

	thumb_func_start sub_803CCC0
sub_803CCC0:
	push {r4-r7,lr}
	ldr r5, off_803CCE8 // =byte_2009790
	// memBlock
	mov r0, r5
	// size
	mov r1, #8
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r1, r10
	ldr r1, [r1,#oToolkit_MainJumptableIndexPtr]
	mov r0, #0x20
	strb r0, [r1]
	pop {r4-r7,pc}
	thumb_func_end sub_803CCC0

	thumb_func_start cb_803CCD6
cb_803CCD6:
	push {r4-r7,lr}
	ldr r5, off_803CCE8 // =byte_2009790
	ldr r0, off_803CCEC // =off_803CCF0
	ldrb r1, [r5]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803CCE8:
	.word byte_2009790
off_803CCEC:
	.word off_803CCF0
off_803CCF0:
	.word sub_803CCFC+1
	.word sub_803CD40+1
	.word sub_803CD54+1
	thumb_func_end cb_803CCD6

	thumb_local_start
sub_803CCFC:
	push {r4-r7,lr}
	bl chatbox_8040818
	mov r0, #0x16
	bl toolkit_applyOverlayPalette_80015FC
	ldr r0, dword_803CD3C // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()
	bl resetAllGraphicsState_8005F40
	bl runSetupStepAndClearWorkArea_8005F6C
	bl sprite_initBattleFadeGfxState_80027C4
	bl sub_803CD58
	mov r0, #0x63
	bl music_80005F2 // (bg_music_indicator: u8) -> ()
	mov r0, #8
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #4
	strb r0, [r5]
	pop {r4-r7,pc}
	.balign 4, 0
dword_803CD3C:
	.word 0x1F40
	thumb_func_end sub_803CCFC

	thumb_local_start
sub_803CD40:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq locret_803CD52
	mov r0, #0xa
	bl RunTextScriptCommError_803CD64
	mov r0, #8
	strb r0, [r5]
locret_803CD52:
	pop {r4-r7,pc}
	thumb_func_end sub_803CD40

	thumb_local_start
sub_803CD54:
	push {r4-r7,lr}
	pop {r4-r7,pc}
	thumb_func_end sub_803CD54

	thumb_local_start
sub_803CD58:
	push {r4-r7,lr}
	bl zeroFillVRAM // () -> ()
	bl ZeroFillGFX30025c0
	pop {r4-r7,pc}
	thumb_func_end sub_803CD58

	thumb_local_start
RunTextScriptCommError_803CD64:
	push {r4-r7,lr}
	mov r1, r0
	ldr r0, off_803CD70 // =TextScriptCommError873B9E0
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_803CD70:
	.word TextScriptCommError873B9E0
	thumb_func_end RunTextScriptCommError_803CD64

// symdb: Wipes the player's key-item inventory and re-grants a fixed starting set (four copies of key item 0x75 and one of key item 0).
// symdb: void sub_803CD74(void) — reads the toolkit pointer from r10; no return value; clobbers r0-r3,
// symdb: r12, lr and flags; preserves r4-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/keyItems_ResetInventoryAndGrantScenarioItems_803CD74.yaml
	thumb_func_start keyItems_ResetInventoryAndGrantScenarioItems_803CD74
keyItems_ResetInventoryAndGrantScenarioItems_803CD74:
	push {r4-r7,lr}
	mov r0, r10
	// memBlock
	ldr r0, [r0,#oToolkit_KeyItemsPtr]
	// size
	ldr r1, off_803CD94 // =0x190
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #0x75
	mov r1, #4
	bl keyItems_RemoveFromInventoryAndGive_803CDF8
	mov r0, #0
	mov r1, #1
	bl keyItems_RemoveFromInventoryAndGive_803CDF8
	pop {r4-r7,pc}
	.balign 4, 0
off_803CD94:
	.word 0x190
	thumb_func_end keyItems_ResetInventoryAndGrantScenarioItems_803CD74

// symdb: Adds a quantity of a key item (or Navi/PET stat) to the toolkit's save buffer, clamping to the per-slot maximum, and returns whether the add was normal/already-max/capped.
// symdb: u32 GiveItem(u32 item_id /* r0 */, u32 quantity /* r1 */, void *toolkit /* r10 */); flags:
// symdb: nz,c,v clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GiveItem.yaml
	thumb_func_start GiveItem
GiveItem:
	push {r4-r7,lr}
	push {r0,r1}
	bl encryption_copyByteXor6fToToolkitBuffer_8006e3c
	pop {r0,r1}
	mov r2, r10
	ldr r2, [r2,#oToolkit_KeyItemsPtr]
	mov r6, #0xff
	cmp r0, #0x80
	blt loc_803CDB6
	cmp r0, #0x85
	bgt loc_803CDB6
	mov r4, #0x75
	ldrb r6, [r2,r4]
	b loc_803CDC4
loc_803CDB6:
	cmp r0, #0x71
	bne loc_803CDBE
	mov r6, #2
	b loc_803CDC4
loc_803CDBE:
	cmp r0, #0x90
	blt loc_803CDC4
	mov r6, #9
loc_803CDC4:
	ldrb r4, [r2,r0]
	mov r3, #1
	cmp r4, r6
	beq loc_803CDD8
	mov r3, #0
	add r4, r4, r1
	cmp r4, r6
	ble loc_803CDD8
	mov r3, #2
	mov r4, r6
loc_803CDD8:
	strb r4, [r2,r0]
	push {r0-r3}
	cmp r0, #0x71
	bne loc_803CDE4
	bl reloadCurNaviStatBoosts_813c3ac
loc_803CDE4:
	pop {r0-r3}
	mov r4, r0
	mov r0, r3
	push {r0}
	bl pet_addCurNaviStat0x3ECapped_803CF3C
	bl pet_updateNaviStatByte9FromKeyItems
	pop {r0}
	pop {r4-r7,pc}
	thumb_func_end GiveItem

// symdb: Clears the given key item slot in the player's key item inventory and then calls GiveItem to hand the item over.
// symdb: void sub_803CDF8(u32 keyItemSlot /* r0 */, u32 giveItemArg /* r1, passed through to GiveItem */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/keyItems_RemoveFromInventoryAndGive_803CDF8.yaml
	thumb_func_start keyItems_RemoveFromInventoryAndGive_803CDF8
keyItems_RemoveFromInventoryAndGive_803CDF8:
	push {lr}
	mov r2, r10
	ldr r2, [r2,#oToolkit_KeyItemsPtr]
	mov r3, #0
	strb r3, [r2,r0]
	bl GiveItem
	pop {pc}
	thumb_func_end keyItems_RemoveFromInventoryAndGive_803CDF8

// symdb: Removes r1 items from the toolkit's key-item array slot r0, returning a result code (0=taken, 1=empty, 2=not enough).
// symdb: u32 TakeItem(u32 slotIdx /*r0*/, s32 amount /*r1*/, toolkit* tk /*r10*/) -> u32 result /*r0*/;
// symdb: tk->keyItemsPtr also returned in r2 and r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/TakeItem.yaml
	thumb_func_start TakeItem
TakeItem:
	push {r4-r7,lr}
	mov r2, r10
	ldr r2, [r2,#oToolkit_KeyItemsPtr]
	ldrb r4, [r2,r0]
	mov r3, #1
	tst r4, r4
	beq loc_803CE20
	mov r3, #0
	sub r4, r4, r1
	bge loc_803CE20
	mov r3, #2
	add r4, r4, r1
loc_803CE20:
	strb r4, [r2,r0]
	mov r0, r3
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end TakeItem

	thumb_func_start CheckKeyItem
CheckKeyItem:
	push {lr}
	push {r0}
	bl encryption_navicustMaybe_8006e50
	pop {r0}
	bne loc_803CE3E
	mov r1, r10
	ldr r1, [r1,#oToolkit_KeyItemsPtr]
	ldrb r0, [r1,r0]
	tst r0, r0
	pop {pc}
loc_803CE3E:
	mov r0, #0
	pop {pc}
	.balign 4, 0x00
	thumb_func_end CheckKeyItem

// symdb: Syncs the Active Navi's MaxHP (stat 0x42) and CurHP copy into the toolkit's NaviStats entry, only when MapGroup < 0x80 and a "PET navi active" event flag is set.
// symdb: (no args; uses r10 = Toolkit) -> r0 = 0x90 (unused by caller) ; side effect: writes
// symdb: 0x3e/0x40/0x42 fields of the current PET Navi's NaviStats entry
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/pet_syncNaviActiveNaviMaxHP_803CE44.yaml
	thumb_func_start pet_syncNaviActiveNaviMaxHP_803CE44
pet_syncNaviActiveNaviMaxHP_803CE44:
	push {r4-r7,lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_GameStatePtr]
	ldrb r0, [r0,#oGameState_MapGroup]
	cmp r0, #0x80
	bge locret_803CEB4
	mov r0, #0
	mov r4, r0
	mov r4, r0
	mov r1, #0x3e
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	mov r7, r0
	mov r2, r10
	ldr r2, [r2,#oToolkit_Unk2004334_Ptr]
	ldrh r2, [r2]
	add r2, r2, r7
	mov r7, r2
	mov r0, #0
	mov r1, #0x42
	mov r2, r7
	bl SetCurPETNaviStatsHword
	movflag EVENT_PET_NAVI_ACTIVE
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq locret_803CEB4
	mov r0, #0
	mov r1, #0x40
	mov r2, r7
	bl SetCurPETNaviStatsHword
	bl GetCurPETNavi // () -> u8
	cmp r0, #0
	beq locret_803CEB4
	bl GetCurPETNavi // () -> u8
	mov r4, r0
	mov r1, #0x3e
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	mov r7, r0
	bl GetCurPETNavi // () -> u8
	mov r1, #0x42
	mov r2, r7
	bl SetCurPETNaviStatsHword
	bl GetCurPETNavi // () -> u8
	mov r1, #0x40
	mov r2, r7
	bl SetCurPETNaviStatsHword
locret_803CEB4:
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end pet_syncNaviActiveNaviMaxHP_803CE44

// symdb: Sets the current PET navi's HP stat to its max HP, healing it to full.
// symdb: void SetCurNaviHPToFull(void) -> r0=0, Z set / N clear on return; preserves r4-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetCurNaviHPToFull.yaml
	thumb_func_start SetCurNaviHPToFull
SetCurNaviHPToFull:
	push {r4-r7,lr}
	bl GetCurPETNavi // () -> u8
	mov r4, r0
	mov r1, #oNaviStats_MaxHP
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	mov r2, r0
	mov r0, r4
	mov r1, #oNaviStats_CurHP
	bl SetCurPETNaviStatsHword
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end SetCurNaviHPToFull

// symdb: Computes stat 0x3E of the current PET navi plus a 16-bit counter held by the toolkit, and stores the result into stat 0x42 of that same navi.
// symdb: void sub_803CED4(r10: toolkit_ptr); /* reads r4/r6/r7 as live regs (preserved), r10 = toolkit
// symdb: base; returns sum in r2; clobbers r0,r1,r2,r3, flags, lr */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/petnavi_setStat42ToStat3EPlusCounter_803CED4.yaml
	thumb_func_start petnavi_setStat42ToStat3EPlusCounter_803CED4
petnavi_setStat42ToStat3EPlusCounter_803CED4:
	push {r4,r6,r7,lr}
	bl GetCurPETNavi // () -> u8
	mov r4, r0
	mov r1, #0x3e
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	mov r7, r0
	mov r2, r10
	ldr r2, [r2,#oToolkit_Unk2004334_Ptr]
	ldrh r2, [r2]
	add r2, r2, r7
	mov r7, r2
	mov r0, r4
	mov r1, #0x42
	bl SetCurPETNaviStatsHword
	pop {r4,r6,r7,pc}
	thumb_func_end petnavi_setStat42ToStat3EPlusCounter_803CED4

	thumb_local_start
sub_803CEF8:
	push {r4-r7,lr}
	mov r4, r0
	mov r1, #0x42
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	mov r2, r0
	mov r0, r4
	mov r1, #0x40
	bl SetCurPETNaviStatsHword
	pop {r4-r7,pc}
	.byte 0, 0
	thumb_func_end sub_803CEF8

// symdb: Recomputes the selected PET navi's 16-bit stat 0x42 as stat 0x3E plus a global modifier, clamped to at least 1.
// symdb: () -> void; no return value, no flags used
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/pet_recalcCurrentNaviHp.yaml
	thumb_local_start
pet_recalcCurrentNaviHp:
	push {r4,r6,r7,lr}
	bl GetCurPETNavi // () -> u8
	mov r4, r0
	mov r1, #0x3e
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	mov r7, r0
	mov r2, r10
	ldr r2, [r2,#oToolkit_Unk2004334_Ptr]
	ldrh r2, [r2]
	add r2, r2, r7
	mov r7, r2
	cmp r7, #1
	bge loc_803CF30
	mov r7, #1
loc_803CF30:
	mov r0, r4
	mov r1, #0x42
	mov r2, r7
	bl SetCurPETNaviStatsHword
	pop {r4,r6,r7,pc}
	thumb_func_end pet_recalcCurrentNaviHp

// symdb: Adds a per-navi-slot offset to PET navi stat 0x3E, caps it at 1000, writes it back, and propagates the new value through sub_803CF74.
// symdb: void pet_addCurNaviStat0x3ECapped_803CF3C(u8 navi_slot /* r1 */, u32 mustBe0x70 /* r4 */); r4
// symdb: must equal 0x70 or the call returns immediately; r4-r12 are preserved, flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/pet_addCurNaviStat0x3ECapped_803CF3C.yaml
	thumb_local_start
pet_addCurNaviStat0x3ECapped_803CF3C:
	push {r4-r7,lr}
	cmp r4, #0x70
	bne locret_803CFAE
	mov r7, #0x14
	mul r7, r1
	mov r0, #0
	mov r4, r0
	mov r1, #0x3e
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	add r0, r0, r7
	ldr r1, off_803CF70 // =0x3e8
	cmp r0, r1
	ble loc_803CF5A
	mov r0, r1
loc_803CF5A:
	mov r2, r0
	mov r6, r2
	mov r0, r4
	mov r1, #0x3e
	bl SetCurPETNaviStatsHword
	mov r0, r6
	mov r1, r7
	bl pet_addCurNaviHPCapped
	pop {r4-r7,pc}
	.balign 4, 0
off_803CF70:
	.word 0x3E8
	thumb_func_end pet_addCurNaviStat0x3ECapped_803CF3C

// symdb: Adds an amount to the current PET navi's HP stat (0x40), clamping it at the navi's max (stat 0x42).
// symdb: (r0 = navi slot index, r1 = amount to add) -> r0 = undefined (destroyed); no meaningful flags.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/pet_addCurNaviHPCapped.yaml
	thumb_local_start
pet_addCurNaviHPCapped:
	push {r4-r7,lr}
	mov r6, r0
	mov r7, r1
	bl GetCurPETNavi // () -> u8
	mov r4, r0
	bl reloadCurNaviStatBoosts_813c3ac
	mov r0, r4
	mov r1, #0x40
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	add r7, r7, r0
	mov r0, r4
	mov r1, #0x40
	mov r2, r7
	bl SetCurPETNaviStatsHword
	mov r0, r4
	mov r1, #0x42
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	cmp r0, r7
	bge locret_803CFAE
	mov r2, r0
	mov r0, r4
	mov r1, #0x40
	bl SetCurPETNaviStatsHword
locret_803CFAE:
	pop {r4-r7,pc}
	thumb_func_end pet_addCurNaviHPCapped

// symdb: After an item grant, recomputes a capped weighted count from three key-item counters and writes it to byte 9 of the NaviStats for record 0 and the currently selected PET navi.
// symdb: (r0 = ignored (overwritten with 0)) -> r0 = clobbered; no meaningful return value
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/pet_updateNaviStatByte9FromKeyItems.yaml
	thumb_local_start
pet_updateNaviStatByte9FromKeyItems:
	push {r4-r7,lr}
	mov r0, #0
	mov r4, r0
	mov r7, r10
	ldr r7, [r7,#oToolkit_KeyItemsPtr]
	mov r6, #0x72
	add r6, r6, r7
	ldrb r0, [r6]
	mov r6, #0x73
	add r6, r6, r7
	ldrb r1, [r6]
	lsl r1, r1, #1
	mov r6, #0x74
	add r6, r6, r7
	ldrb r2, [r6]
	lsl r3, r2, #1
	add r2, r2, r3
	add r0, r0, r1
	add r0, r0, r2
	add r0, #4
	cmp r0, #0x63
	ble loc_803CFDE
	mov r0, #0x63
loc_803CFDE:
	mov r2, r0
	mov r6, r2
	mov r0, r4
	mov r1, #9
	bl SetCurPETNaviStatsByte // (int a1, int a2, int a3) -> void
	bl GetCurPETNavi // () -> u8
	mov r2, r6
	mov r1, #9
	bl SetCurPETNaviStatsByte // (int a1, int a2, int a3) -> void
	pop {r4-r7,pc}
	thumb_func_end pet_updateNaviStatByte9FromKeyItems

// symdb: Adds the given amount of Zenny to the player's wallet (encrypted), capping at 999999 and returning a status code.
// symdb: u32 giveZenny_803CFF8(s32 amount /* r0 */);  // returns 0=ok, 1=cheat-detected or already full,
// symdb: 2=overflow capped; clobbers r0-r3, lr; preserves r4-r7; needs r10 = toolkit pointer
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GiveZenny.yaml
	thumb_func_start GiveZenny
GiveZenny:
	push {r4-r7,lr}
	bl encryption_zenny_8006f78
	bne loc_803D024
	mov r2, r10
	ldr r2, [r2,#oToolkit_GameStatePtr]
	ldr r1, [r2,#oGameState_ProtectedZenny]
	ldr r4, =999999
	// has max zenny
	mov r3, #1
	cmp r1, r4
	beq loc_803D01A
	// didn't exceed max zenny
	mov r3, #0
	add r1, r1, r0
	cmp r1, r4
	ble loc_803D01A
	// exceeded max zenny
	mov r3, #2
	mov r1, r4
loc_803D01A:
	str r1, [r2,#oGameState_ProtectedZenny]
	mov r0, r3
	bl encryption_zenny_8006f54
	pop {r4-r7,pc}
loc_803D024:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
	.pool
	thumb_func_end GiveZenny

// symdb: Stores a zenny value into the protected zenny save slot and re-encrypts the zenny block, guarded by an integrity check.
// symdb: void sub_803D02C(u32 r0, u32 r1, u32 r2, u32 r3, u32 r4, u32 r5, u32 r6, u32 r7, Toolkit* r10);
// symdb: // r0..r7 preserved, r2/r3/r6/r7 hold callee outputs, nz/c/v from callee
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/protectZenny_803D02C.yaml
	thumb_func_start protectZenny_803D02C
protectZenny_803D02C:
	push {lr}
	bl encryption_zenny_8006f78
	bne locret_803D03E
	mov r1, r10
	ldr r1, [r1,#oToolkit_GameStatePtr]
	str r0, [r1,#oGameState_ProtectedZenny]
	bl encryption_zenny_8006f54
locret_803D03E:
	pop {pc}
	thumb_func_end protectZenny_803D02C

	thumb_func_start TakeZenny
TakeZenny:
	push {lr}
	bl encryption_zenny_8006f78
	bne loc_803D068
	mov r2, r10
	ldr r2, [r2,#oToolkit_GameStatePtr]
	ldr r1, [r2,#oGameState_ProtectedZenny]
	mov r3, #1
	tst r1, r1
	beq loc_803D05E
	mov r3, #0
	sub r1, r1, r0
	bge loc_803D05E
	mov r3, #2
	add r1, r1, r0
loc_803D05E:
	str r1, [r2,#oGameState_ProtectedZenny]
	mov r0, r3
	bl encryption_zenny_8006f54
	pop {pc}
loc_803D068:
	mov r0, #2
	pop {pc}
	thumb_func_end TakeZenny

// symdb: Returns the player's protected (encrypted) zenny amount via the toolkit → game-state chain, or 0 if the encryption check fails.
// symdb: u32 protectedZennyOrZero(u32 zenny /* r0 */, u32 arg1 /* r1 */, toolkit_t *toolkit /* r10 */) ->
// symdb: r0; clobbers r1, lr; flags nz|c|v set by the encryption helper
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/protectedZennyOrZero_803D06C.yaml
	thumb_func_start protectedZennyOrZero_803D06C
protectedZennyOrZero_803D06C:
	push {lr}
	bl encryption_zenny_8006f78
	bne loc_803D07C
	mov r1, r10
	ldr r1, [r1,#oToolkit_GameStatePtr]
	ldr r0, [r1,#oGameState_ProtectedZenny]
	pop {pc}
loc_803D07C:
	mov r0, #0
	pop {pc}
	thumb_func_end protectedZennyOrZero_803D06C

// symdb: Adds the requested BugFrags to the tamper-protected in-game counter, saturating at 9999, and re-encrypts it.
// symdb: uint GiveBugfrags(uint amount /* r0 */) ; uses r10 (toolkit/gameState pointer); clobbers nz c v
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GiveBugfrags.yaml
	thumb_func_start GiveBugfrags
GiveBugfrags:
	push {r4-r7,lr}
	bl encryption_bugfrags_8006fd0
	bne loc_803D0AC
	mov r2, r10
	ldr r2, [r2,#oToolkit_GameStatePtr]
	ldr r1, [r2,#oGameState_ProtectedBugfrags]
	ldr r4, dword_803D0B0 // =0x270f
	mov r3, #1
	cmp r1, r4
	beq loc_803D0A2
	mov r3, #0
	add r1, r1, r0
	cmp r1, r4
	ble loc_803D0A2
	mov r3, #2
	mov r1, r4
loc_803D0A2:
	str r1, [r2,#oGameState_ProtectedBugfrags]
	mov r0, r3
	bl encryption_bugfrags_8006fac
	pop {r4-r7,pc}
loc_803D0AC:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
dword_803D0B0:
	.word 0x270F
	thumb_func_end GiveBugfrags

// symdb: Refreshes the anti-tamper protected BugFrag counter in the game state and recomputes its obfuscated checksum copies
// symdb: () -> void; no arguments; r0 is scratch holding the count written to the state, flags consumed
// symdb: from the integrity-check callee
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/bugfrags_syncProtectedCounters.yaml
	thumb_func_start bugfrags_syncProtectedCounters
bugfrags_syncProtectedCounters:
	push {lr}
	bl encryption_bugfrags_8006fd0
	bne locret_803D0C6
	mov r1, r10
	ldr r1, [r1,#oToolkit_GameStatePtr]
	str r0, [r1,#oGameState_ProtectedBugfrags]
	bl encryption_bugfrags_8006fac
locret_803D0C6:
	pop {pc}
	thumb_func_end bugfrags_syncProtectedCounters

	thumb_func_start TakeBugfrags
TakeBugfrags:
	push {lr}
	bl encryption_bugfrags_8006fd0
	bne loc_803D0F0
	mov r2, r10
	ldr r2, [r2,#oToolkit_GameStatePtr]
	ldr r1, [r2,#oGameState_ProtectedBugfrags]
	mov r3, #1
	tst r1, r1
	beq loc_803D0E6
	mov r3, #0
	sub r1, r1, r0
	bge loc_803D0E6
	mov r3, #2
	add r1, r1, r0
loc_803D0E6:
	str r1, [r2,#oGameState_ProtectedBugfrags]
	mov r0, r3
	bl encryption_bugfrags_8006fac
	pop {pc}
loc_803D0F0:
	mov r0, #2
	pop {pc}
	thumb_func_end TakeBugfrags

// symdb: Returns the anti-tamper Protected BugFrags counter from the global GameState, or 0 if the integrity check fails.
// symdb: () -> r0 = ProtectedBugfrags (u32), or 0 when integrity check fails ; sets Z according to the
// symdb: integrity-check result
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/gameState_getProtectedBugfrags_803D0F4.yaml
	thumb_func_start gameState_getProtectedBugfrags_803D0F4
gameState_getProtectedBugfrags_803D0F4:
	push {lr}
	bl encryption_bugfrags_8006fd0
	bne loc_803D104
	mov r1, r10
	ldr r1, [r1,#oToolkit_GameStatePtr]
	ldr r0, [r1,#oGameState_ProtectedBugfrags]
	pop {pc}
loc_803D104:
	mov r0, #0
	pop {pc}
	thumb_func_end gameState_getProtectedBugfrags_803D0F4

	thumb_func_start GiveNaviCustPrograms
GiveNaviCustPrograms:
	push {r4,lr}
	mov r4, r2
	bl sub_803D148
	mov r1, r4
	bl GiveItem
	pop {r4,pc}
	thumb_func_end GiveNaviCustPrograms

	thumb_func_start sub_803D118
sub_803D118:
	push {r4,lr}
	mov r4, r2
	bl sub_803D148
	mov r1, r4
	bl keyItems_RemoveFromInventoryAndGive_803CDF8
	pop {r4,pc}
	thumb_func_end sub_803D118

	thumb_func_start TakeNaviCustPrograms
TakeNaviCustPrograms:
	push {r4,lr}
	mov r4, r2
	bl sub_803D148
	mov r1, r4
	bl TakeItem
	pop {r4,pc}
	thumb_func_end TakeNaviCustPrograms

	thumb_func_start sub_803D138
sub_803D138:
	push {r4,lr}
	mov r4, r2
	bl sub_803D148
	bl CheckKeyItem
	pop {r4,pc}
	.balign 4, 0x00
	thumb_func_end sub_803D138

	thumb_func_start sub_803D148
sub_803D148:
	push {r4-r7,lr}
	sub r0, #0x90
	mov r6, #0
	mov r4, r0
	mov r5, r1
loc_803D152:
	add r0, r4, r6
	bl battleObject_getByIndex_813B780
	mov r7, r0
	ldrb r0, [r7,#3]
	cmp r0, r5
	beq loc_803D16A
	add r6, #1
	cmp r6, #4
	blt loc_803D152
	mov r0, #0
	b locret_803D16E
loc_803D16A:
	add r0, r4, r6
	add r0, #0x90
locret_803D16E:
	pop {r4-r7,pc}
	thumb_func_end sub_803D148

	thumb_local_start
sub_803D170:
	push {r4,lr}
	mov r4, r2
	bl sub_803D180
	bl CheckKeyItem
	pop {r4,pc}
	.byte 0, 0
	thumb_func_end sub_803D170

	thumb_local_start
sub_803D180:
	push {r4-r7,lr}
	sub r0, #0x90
	mov r6, #0
	mov r4, r0
	mov r5, #0
loc_803D18A:
	add r0, r4, r6
	bl battleObject_getByIndex_813B780
	mov r7, r0
	ldrb r0, [r7,#3]
	cmp r0, r5
	bne loc_803D1A2
	add r6, #1
	cmp r6, #4
	blt loc_803D18A
	mov r0, #0
	b locret_803D1A6
loc_803D1A2:
	add r0, r4, r6
	add r0, #0x90
locret_803D1A6:
	pop {r4-r7,pc}
	thumb_func_end sub_803D180

/// triggers cascade towards start screen initialization and rendering
	thumb_func_start logoScreen_init_803D1A8
logoScreen_init_803D1A8: // () -> ()
  // let v0: bool?;
	mov r0, #1
	b loc_803D1AE

call_803D1AC:
	mov r0, #0

loc_803D1AE:
	push {r4-r7,lr}

	push {r0}

	// memBlock
	ldr r0, off_803D1F8 // =eLogoScreenState
	// size
	mov r1, #8
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()

  // v0
	pop {r0}

	ldr r1, off_803D1F8 // =eLogoScreenState
	strb r0, [r1,#oLogoScreenState_State]

  // trigger logoScreen_dispatch_803D1CA via main_
	mov r1, r10
	ldr r1, [r1,#oToolkit_MainJumptableIndexPtr]
	mov r0, #0x10
	strb r0, [r1]

	pop {r4-r7,pc}
	thumb_func_end logoScreen_init_803D1A8

// symdb: Logo screen state-machine tick — dispatches the current LogoScreenState handler, then animates the "PRESS START" text.
// symdb: void logoScreen_tickState_803D1CA(void) /* uses eLogoScreenState singleton; r4-r7 preserved;
// symdb: r0-r3,r12,clobbers */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/logoScreen_dispatch_803D1CA.yaml
	thumb_func_start logoScreen_dispatch_803D1CA
logoScreen_dispatch_803D1CA:
	push {r4-r7,lr}

	ldr r5, off_803D1F8 // =eLogoScreenState

	ldr r0, off_803D1E0 // =off_803D1E4
	ldrb r1, [r5, #oLogoScreenState_Index_00]
	ldr r0, [r0,r1]

	mov lr, pc
	bx r0

	bl startScreen_AnimatePressStart_803E938
	pop {r4-r7,pc}
	.balign 4, 0
off_803D1E0:
	.word off_803D1E4
off_803D1E4:
  // 0x00
  .word logoScreen_init_803D1FC+1 // (self: *mut LogoScreenState $r5) -> ()
  // 0x04
	.word sub_803D24C+1 // (self: *mut LogoScreenState $r5) -> ()
  // 0x08
	.word tickLogoScreenFade_803D274+1 // (self: *mut LogoScreenState $r5) -> ()
  // 0x0C
	.word logoScreen_handleFade_803D298+1 // (self: *mut LogoScreenState $r5) -> ()
  // 0x10
	.word logoScreen_finish_803D2A6+1 // (self: *const LogoScreenState $r5) -> ()
off_803D1F8:
	.word eLogoScreenState
	thumb_func_end logoScreen_dispatch_803D1CA

// symdb: Initialises the title/logo screen: configures LCD and fade mode, resets graphics, loads logo tiles, starts logo BGM, and advances the state machine to index 4.
// symdb: logoScreen_init(*mut LogoScreenState r5) -> r0 = 4, r4 = fade_mode (4 or 0xC); flags nz/c/v
// symdb: clobbered; r5-r7/r10 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/logoScreen_init_803D1FC.yaml
	thumb_local_start
logoScreen_init_803D1FC: // (self: *mut LogoScreenState $r5) -> ()
	push {lr}

	mov r0, #0xe
	bl toolkit_applyOverlayPalette_80015FC

	mov r4, #0xc
	ldr r0, off_803D244 // =0x40

	ldrb r1, [r5,#oLogoScreenState_State]
	tst r1, r1
	beq loc_803D212

	mov r4, #4
	ldr r0, off_803D248 // =0xc0

loc_803D212:

	bl SetRenderInfoLCDControl // (a_00: u16) -> ()

	bl renderInfo_8001788 // () -> ()
	bl renderInfo_80017A0 // () -> ()

	mov r0, r4
	mov r1, #0xff
	bl SetScreenFade // (int a1, int a2) -> void

	bl resetAllGraphicsState_8005F40

	bl runSetupStepAndClearWorkArea_8005F6C

	bl sprite_initBattleFadeGfxState_80027C4

	bl logoScreen_loadLogoTiles_803D2B8

	mov r0, #0x63
	bl music_80005F2 // (bg_music_indicator: u8) -> ()

  // trigger sub_803D24C via logoScreen_dispatch_803D1CA
	mov r0, #4
	strb r0, [r5, #oLogoScreenState_Index_00]

	pop {pc}
	.balign 4, 0
off_803D244:
	.word 0x40
off_803D248:
	.word 0xC0
	thumb_func_end logoScreen_init_803D1FC

	thumb_local_start
sub_803D24C: // (self: *mut LogoScreenState $r5) -> ()
	push {lr}
	ldr r0, dword_803D270 // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	mov r0, #8
	ldrb r1, [r5,#5]
	tst r1, r1
	beq loc_803D25E
	mov r0, #0
loc_803D25E:
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0xb4
	strb r0, [r5,#4]

  // trigger tickLogoScreenFade_803D274 via logoScreen_dispatch_803D1CA
	mov r0, #8
	strb r0, [r5, #oLogoScreenState_Index_00]

	pop {pc}
	.balign 4, 0
dword_803D270:
	.word 0x1F40
	thumb_func_end sub_803D24C

// symdb: Per-frame logo screen tick: only advances state when the screen fade finishes.
// symdb: void sub_803D274(LogoScreenState *state /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/tickLogoScreenFade_803D274.yaml
	thumb_local_start
tickLogoScreenFade_803D274: // (self: *mut LogoScreenState $r5) -> ()
	push {lr}
	bl IsScreenFadeActive // () -> zf
	beq locret_803D292
	ldrb r0, [r5,#4]
	sub r0, #1
	strb r0, [r5,#4]
	cmp r0, #0
	bgt locret_803D292
	mov r0, #0xc
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void

  // trigger logoScreen_handleFade_803D298 via logoScreen_dispatch_803D1CA
	mov r0, #0xc
	strb r0, [r5, #oLogoScreenState_Index_00]

locret_803D292:
	pop {pc}
	.word 0x3FF
	thumb_func_end tickLogoScreenFade_803D274

// symdb: Logo screen step that, when no screen fade is active, sets the logo state index to 0x10 to queue logoScreen_finish.
// symdb: void sub_803D298(LogoScreenState *self /* r5 */); // uses r0,r1,r3,lr; clobbers nz,c,v; returns
// symdb: void
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/logoScreen_handleFade_803D298.yaml
	thumb_local_start
logoScreen_handleFade_803D298: // (self: *mut LogoScreenState $r5) -> ()
	push {lr}
	bl IsScreenFadeActive // () -> zf
	beq locret_803D2A4

  // trigger logoScreen_finish_803D2A6 via logoScreen_dispatch_803D1CA
	mov r0, #0x10
	strb r0, [r5, #oLogoScreenState_Index_00]

locret_803D2A4:
	pop {pc}
	thumb_func_end logoScreen_handleFade_803D298

// symdb: Wraps up the logo screen by restoring the normal LCD render mode (0x40) and reinitializing the shared screen-start state.
// symdb: (self: *const LogoScreenState in r5) -> void; callers pass r2, r3, r10, lr; r2/r3 preserved,
// symdb: r0/r1 and NZCV left as the last callee set them
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/logoScreen_finish_803D2A6.yaml
	thumb_local_start
logoScreen_finish_803D2A6: // (self: *const LogoScreenState $r5) -> ()
	push {lr}
	ldr r0, off_803D2B4 // =0x40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()
	bl startScreen_init_802F530 // () -> void
	pop {pc}
	.balign 4, 0
off_803D2B4:
	.word 0x40
	thumb_func_end logoScreen_finish_803D2A6

// Disabling this causes logo screen to be all black. No graphics are loaded.
// symdb: Loads and arranges the tiles, tilemaps, and palettes for the Capcom logo and license-message intro screen.
// symdb: void logoScreen_loadLogoTiles_803D2B8(void) // preserves r4-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/logoScreen_loadLogoTiles_803D2B8.yaml
	thumb_local_start
logoScreen_loadLogoTiles_803D2B8:
	push {r4-r7,lr}

	bl zeroFillVRAM // () -> ()

	bl ZeroFillGFX30025c0

	// initRefs
	ldr r0, off_803D2EC // =initRefs803D2F0
	bl decompAndCopyData // (u32 *initRefs) -> void

  // Disabling this causes "Capcom" in the logo screen to disappear
	// j
	mov r0, #0
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #1
	ldr r3, off_803D304 // =eDecompBuffer2013A00
	// tileIds
	add r3, #4
	mov r4, #0x20
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()

  // Disabling this causes the license message in the logo screen to disappear
	// j
	mov r0, #8
	// i
	mov r1, #0x11
	// tileBlock32x32
	mov r2, #2
	// tileIds
	ldr r3, off_803D330 // =CapcomLogoLicenseTilemap_86C41B4
	mov r4, #0xe
	mov r5, #1
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()

	pop {r4-r7,pc}
	.balign 4, 0
off_803D2EC: 
  .word initRefs803D2F0
initRefs803D2F0: 
  // 0x00
  // Disabling this causes Capcom Logo to disappear
  .word CompCapcomLogoTileset_86C3528 + COMPRESSED_PTR_FLAG
  .word 0x06000020
	.word eDecompBuffer2014A00
  // 0x01
	.word CompCapcomLogoTilemap_86C3E94 + COMPRESSED_PTR_FLAG
	.word NULL
off_803D304: 
  // also part of initRefs803D2F0
  .word eDecompBuffer2013A00
  // 0x02
  // Disabling this causes Capcom logo to disappear
  // 0x20 -> 0x10 produces glitchy blue palette for Capcom logo
	.word CapcomLogoPalette_86C3C94
	.word palette_3001960
	.word 0x20
  // 0x03
  // Disabling this causes Capcom license message to disappear
  // 0x1C0 -> 0x0C0 causes only the "LICENSE" part to be loaded of the message
	.word CapcomLogoLicenseTileset_86C3FD4
	.word 0x6001000
	.word 0x1C0 // 14 tiles (each tile being 0x20 bytes)
  // 0x04
  // Disabling this causes Capcom license message to disappear
  // 0x20 -> 0x05 causes the capcom license message to get a red shadow
	.word CapcomLogoLicensePalette_86C4194
	.word palette_3001980
	.word 0x20
  // 0x05
	.word NULL
off_803D330: 
  .word CapcomLogoLicenseTilemap_86C41B4
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x3, 0x0, 0x4, 0x0, 0x5, 0x0, 0x6, 0x0
	.byte 0x7, 0x0, 0x8, 0x0, 0x9, 0x0, 0xA, 0x0, 0xB, 0x0, 0xC, 0x0, 0xD, 0x0, 0xE, 0x0, 0xF
	.byte 0x0, 0x10, 0x0, 0x11, 0x0, 0x12, 0x0, 0x13, 0x0, 0x14, 0x0, 0x15, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x16, 0x0
	.byte 0x17, 0x0, 0x18, 0x0, 0x19, 0x0, 0x1A, 0x0, 0x1B, 0x0, 0x1C, 0x0, 0x1D, 0x0, 0x1E, 0x0, 0x1F
	.byte 0x0, 0x20, 0x0, 0x21, 0x0, 0x22, 0x0, 0x23, 0x0, 0x24, 0x0, 0x25, 0x0, 0x26, 0x0, 0x27, 0x0
	.byte 0x28, 0x0, 0x29, 0x0, 0x2A, 0x0, 0x2B, 0x0, 0x2C, 0x0, 0x2D, 0x0, 0x2E, 0x0, 0x2F, 0x0, 0x30
	.byte 0x0, 0x31, 0x0, 0x32, 0x0, 0x33, 0x0, 0x34, 0x0, 0x35, 0x0, 0x36, 0x0, 0x37, 0x0, 0x38, 0x0
	.byte 0x39, 0x0, 0x3A, 0x0, 0x3B, 0x0, 0x3C, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x1, 0x0, 0x2, 0x0, 0x3, 0x0, 0x4, 0x0, 0x5, 0x0, 0x6, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x3, 0x0, 0x4, 0x0, 0x5, 0x0, 0x6, 0x0, 0x7
	.byte 0x0, 0x8, 0x0, 0x9, 0x0, 0xA, 0x0, 0xB, 0x0, 0xC, 0x0, 0xD, 0x0, 0xE, 0x0, 0xF, 0x0
	.byte 0x10, 0x0, 0x11, 0x0, 0x12, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x13
	.byte 0x0, 0x14, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x14, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x2, 0x0, 0x3, 0x0, 0x4, 0x0, 0x5, 0x0, 0x6
	.byte 0x0, 0x7, 0x0, 0x8, 0x0, 0x9, 0x0, 0xA, 0x0, 0xB, 0x0, 0xC, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
off_803DC78:
	.word eStruct2036780
	.word unk_20399F0
	.word unk_2039A00
	.byte 0x4, 0x0, 0x0, 0x0, 0xB0, 0xB1, 0x0, 0x2, 0x74, 0xDE, 0x1, 0x2, 0x74
	.byte 0xE6, 0x1, 0x2, 0x0, 0x0, 0x0, 0x0
	.word dword_200B1B0
	.word unk_2009450
	.word unk_2009460
	.byte 0x4, 0x0, 0x0, 0x0, 0xB0, 0xB1, 0x0, 0x2, 0x0, 0xBA, 0x1, 0x2, 0x10
	.byte 0xBA, 0x1, 0x2, 0x0, 0x0, 0x0, 0x0
	.word dword_200B1B0
	.word eTextScript201BA00
	.word byte_201BA10
	.word 0x0
	.word dword_200B1B0
	.word unk_201F320
	.word unk_201F5A0
	.word 0x0
	thumb_func_end logoScreen_loadLogoTiles_803D2B8

// symdb: Stores caller-provided link/companion index and two halfword fields into the global eLinkState struct (used to set up a link state configuration).
// symdb: void setLinkStateFields(u32 linkIdx, u16 field0A, u16 field0E);  // preserves r4-r7, tail-call
// symdb: return
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803DCD8.yaml
	thumb_func_start sub_803DCD8
sub_803DCD8:
	push {r4-r7,lr}
	ldr r7, off_803DCE4 // =eLinkState
	str r0, [r7,#0x1c] // (eCamera.pad_6A+2 - 0x20099d0)
	strh r1, [r7,#0xa] // (eCamera.pad_59+1 - 0x20099d0)
	strh r2, [r7,#0xe] // (eCamera.pad_5E - 0x20099d0)
	pop {r4-r7,pc}
off_803DCE4:
	.word eLinkState // eLinkState
	thumb_func_end sub_803DCD8

// symdb: Initialise the camera/screen state block (linked from eLinkState) with a layout record and zero-fill the two destination buffers.
// symdb: void camera_init_803DCE8(void *ptr /*r0*/, u32 layout_ix /*r1*/, u8 unk_53 /*r2*/, u8 unk_52
// symdb: /*r3*/) -> (preserves r2,r4-r7; clobbers r0,r1,lr,nzcv)
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803DCE8.yaml
	thumb_func_start sub_803DCE8
sub_803DCE8:
	push {r4-r7,lr}
	ldr r7, off_803DD5C // =eLinkState
	str r0, [r7,#0x20] // (eCamera.unk_70 - 0x20099d0)
	str r0, [r7,#0x24] // (eCamera.unk_74 - 0x20099d0)
	strb r2, [r7,#0x3] // (eCamera.unk_53 - 0x20099d0)
	strb r3, [r7,#0x2] // (eCamera.unk_52 - 0x20099d0)
	ldr r0, off_803DD58 // =off_803DC78
	lsl r1, r1, #4
	add r0, r0, r1
	ldr r1, [r0]
	str r1, [r7,#0x34] // (eCamera.unk_84 - 0x20099d0)
	ldr r1, [r0,#4]
	str r1, [r7,#0x38] // (eCamera.unk_88 - 0x20099d0)
	ldr r1, [r0,#8]
	str r1, [r7,#0x3c] // (eCamera.unk_8C - 0x20099d0)
	ldrb r1, [r0,#0xc]
	strb r1, [r7]
	strb r1, [r7,#0x1] // (eCamera.unk_51 - 0x20099d0)
	mov r1, #0
	strb r1, [r7,#0x5] // (eCamera.unk_55 - 0x20099d0)
	strb r1, [r7,#0x8] // (eCamera.unk_58 - 0x20099d0)
	strh r1, [r7,#0x18] // (eCamera.unk_68 - 0x20099d0)
	mvn r1, r1
	strh r1, [r7,#0x10] // (eCamera.unk_60 - 0x20099d0)
	strh r1, [r7,#0x12] // (eCamera.unk_62 - 0x20099d0)
	strh r1, [r7,#0x14] // (eCamera.unk_64 - 0x20099d0)
	strh r1, [r7,#0x16] // (eCamera.unk_66 - 0x20099d0)
	ldr r0, [r7,#0x38] // (eCamera.unk_88 - 0x20099d0)
	ldr r1, [r7,#0x24] // (eCamera.unk_74 - 0x20099d0)
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()
	ldr r0, [r7,#0x3c] // (eCamera.unk_8C - 0x20099d0)
	ldr r1, [r7,#0x24] // (eCamera.unk_74 - 0x20099d0)
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {r4-r7,pc}
	thumb_func_end sub_803DCE8

// symdb: Derives a small link-mode selector (0..3) from the eStruct200BC30 jump-offset slot and eLinkState, returning it in r0 with the zero flag set iff it is 0.
// symdb: int sub_803DD30(void) // in: nothing (r7, lr saved); out: r0 = selector (0..3), NZ flags per r0;
// symdb: preserves r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/link_getModeSelector_803DD30.yaml
	thumb_func_start link_getModeSelector_803DD30
link_getModeSelector_803DD30:
	push {r7,lr}
	bl eStruct200BC30_getJumpOffset00
	mov r1, r0
	cmp r1, #0
	beq loc_803DD48
	mov r0, #0
	cmp r1, #4
	beq loc_803DD52
	mov r0, #1
	cmp r1, #8
	beq loc_803DD52
loc_803DD48:
	ldr r7, off_803DD5C // =eLinkState
	ldr r0, [r7,#0x48] // (dword_2009A18 - 0x20099d0)
	mov r1, #3
	and r0, r1
	lsl r0, r0, #0
loc_803DD52:
	tst r0, r0
	pop {r7,pc}
	.balign 4, 0
off_803DD58:
	.word off_803DC78
off_803DD5C:
	.word eLinkState // eLinkState
	thumb_func_end link_getModeSelector_803DD30

	thumb_func_start sub_803DD60
sub_803DD60:
	push {r7,lr}
	bl eStruct200BC30_getJumpOffset00
	mov r1, r0
	cmp r0, #0
	beq loc_803DD76
	mov r0, #0
	cmp r1, #4
	beq locret_803DD86
	cmp r1, #8
	beq loc_803DD84
loc_803DD76:
	ldr r7, off_803DD88 // =eLinkState
	ldr r0, [r7,#0x48] // (dword_2009A18 - 0x20099d0)
	mov r1, #3
	and r0, r1
	lsl r0, r0, #0
	tst r0, r0
	beq locret_803DD86
loc_803DD84:
	mov r0, #1
locret_803DD86:
	pop {r7,pc}
	.balign 4, 0
off_803DD88:
	.word eLinkState // eLinkState
	thumb_func_end sub_803DD60

	thumb_local_start
sub_803DD8C:
	push {r7,lr}
	ldr r7, off_803DDA0 // =eLinkState
	mov r0, #8
	strb r0, [r7]
	strb r0, [r7,#0x1] // (eCamera.unk_51 - 0x20099d0)
	mov r0, #0x10
	strh r0, [r7,#0xc] // (eCamera.unk_5C - 0x20099d0)
	mov r0, #0
	strb r0, [r7,#0x8] // (eCamera.unk_58 - 0x20099d0)
	pop {r7,pc}
off_803DDA0:
	.word eLinkState // eLinkState
	thumb_func_end sub_803DD8C

	thumb_func_start sub_803DDA4
sub_803DDA4:
	push {r7,lr}
	ldr r7, off_803DDBC // =eLinkState
	mov r0, #0x10
	strb r0, [r7]
	mov r0, #0xc
	strb r0, [r7,#0x1] // (eCamera.unk_51 - 0x20099d0)
	mov r0, #0x10
	strh r0, [r7,#0xc] // (eCamera.unk_5C - 0x20099d0)
	mov r0, #0
	strb r0, [r7,#0x8] // (eCamera.unk_58 - 0x20099d0)
	pop {r7,pc}
	.balign 4, 0x00
off_803DDBC:
	.word eLinkState // eLinkState
	thumb_func_end sub_803DDA4

	thumb_local_start
sub_803DDC0:
	push {r7,lr}
	ldr r7, off_803DDD0 // =eLinkState
	mov r0, #8
	strb r0, [r7]
	mov r0, #0x10
	strh r0, [r7,#0xc] // (eCamera.unk_5C - 0x20099d0)
	pop {r7,pc}
	.byte 0, 0
off_803DDD0:
	.word eLinkState // eLinkState
	thumb_func_end sub_803DDC0

	thumb_local_start
sub_803DDD4:
	push {r7,lr}
	mov r1, #1
	ldr r7, off_803DDE8 // =eLinkState
	ldrh r0, [r7,#0xe] // (eCamera.pad_5E - 0x20099d0)
	cmp r0, #2
	blt loc_803DDE2
	mov r1, #0
loc_803DDE2:
	mov r0, r1
	pop {r7,pc}
	.balign 4, 0
off_803DDE8:
	.word eLinkState // eLinkState
	thumb_func_end sub_803DDD4

	thumb_local_start
sub_803DDEC:
	push {r4,r7,lr}
	mov r4, #1
	ldr r7, off_803DE20 // =eLinkState
	ldrb r0, [r7,#0x1] // (eCamera.unk_51 - 0x20099d0)
	cmp r0, #8
	bne loc_803DE1A
	ldrb r0, [r7]
	cmp r0, #8
	bne loc_803DE1A
	ldr r0, [r7,#0x48] // (dword_2009A18 - 0x20099d0)
	bl sub_803DFAC
	mov r1, #0x7f
	and r1, r0
	beq loc_803DE12
	ldrh r0, [r7,#0xc] // (eCamera.unk_5C - 0x20099d0)
	cmp r0, #8
	blt loc_803DE18
	b loc_803DE1A
loc_803DE12:
	ldrh r0, [r7,#0xc] // (eCamera.unk_5C - 0x20099d0)
	tst r0, r0
	bne loc_803DE1A
loc_803DE18:
	mov r4, #0
loc_803DE1A:
	mov r0, r4
	pop {r4,r7,pc}
	.balign 4, 0
off_803DE20:
	.word eLinkState // eLinkState
	thumb_func_end sub_803DDEC

	thumb_func_start sub_803DE24
sub_803DE24:
	push {r4,r7,lr}
	mov r4, #1
	ldr r7, off_803DE58 // =eLinkState
	ldrb r0, [r7,#0x1] // (eCamera.unk_51 - 0x20099d0)
	cmp r0, #0xc
	bne loc_803DE52
	ldrb r0, [r7]
	cmp r0, #0x10
	bne loc_803DE52
	ldr r0, [r7,#0x48] // (dword_2009A18 - 0x20099d0)
	bl sub_803DFAC
	mov r1, #0x7f
	and r1, r0
	beq loc_803DE4A
	ldrh r0, [r7,#0xc] // (eCamera.unk_5C - 0x20099d0)
	cmp r0, #8
	blt loc_803DE50
	b loc_803DE52
loc_803DE4A:
	ldrh r0, [r7,#0xc] // (eCamera.unk_5C - 0x20099d0)
	tst r0, r0
	bne loc_803DE52
loc_803DE50:
	mov r4, #0
loc_803DE52:
	mov r0, r4
	pop {r4,r7,pc}
	.balign 4, 0
off_803DE58:
	.word eLinkState // eLinkState
	thumb_func_end sub_803DE24

// symdb: Sets the boolean flag at EWRAM 0x200A284 to 1 (true), with no other side effects.
// symdb: void setFlag_200A284(void)
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803DE5C.yaml
	thumb_func_start sub_803DE5C
sub_803DE5C:
	push {lr}
	ldr r0, =unk_200A284
	mov r1, #1
	str r1, [r0]
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_803DE5C

	thumb_local_start
sub_803DE68:
	push {lr}
	ldr r0, =unk_200A284
	mov r1, #0
	str r1, [r0]
	pop {pc}
	thumb_func_end sub_803DE68

// symdb: Polls the SIO link library once per frame when SIO comms are enabled (battle)
// symdb: (no args) -> no return ; reads globals `unk_200A284` and calls `libSIOControlPoll_81445F8` when
// symdb: that word is non-zero
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_pollSIOLinkIfActive_803DE72.yaml
	thumb_func_start battle_pollSIOLinkIfActive_803DE72
battle_pollSIOLinkIfActive_803DE72:
	push {lr}
	ldr r0, =unk_200A284
	ldr r0, [r0]
	tst r0, r0
	beq locret_803DE80
	bl libSIOControlPoll_81445F8
locret_803DE80:
	pop {pc}
	.balign 4, 0x00
// 0x803DE84
	.pool
	thumb_func_end battle_pollSIOLinkIfActive_803DE72

// symdb: Resets the eLink/link-battle state block and its side buffers, then stores the caller's state pointer at eLinkState+0x58.
// symdb: void sub_803DE88(void *statePtr /* r0 */); clobbers r0/r1/nz/c/v, preserves r2-r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eLinkState_ResetForNewUse_803DE88.yaml
	thumb_func_start eLinkState_ResetForNewUse_803DE88
eLinkState_ResetForNewUse_803DE88:
	push {r4-r7,lr}
	mov r4, r0
	ldr r0, off_803DF9C // =eLinkState
	mov r6, r0
	mov r1, #0x58
	bl ZeroFillByHalfword
	ldr r0, off_803DFA0 // =byte_200DD10
	mov r1, #0x10
	bl ZeroFillByHalfword
	ldr r0, off_803DFA4 // =unk_2009480
	mov r1, #0x40
	bl ZeroFillByHalfword
	str r4, [r6,#0x58] // (dword_2009A28 - 0x20099d0)
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end eLinkState_ResetForNewUse_803DE88

// symdb: Trivial tail-call wrapper that immediately invokes sub_8144240 and returns its result to the caller.
// symdb: Next sub_803DEAC(void) — entry with lr as return address; r4-r7 are passed through and preserved
// symdb: by the callee; flags (nz c v) clobbered by the callee.
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803DEAC.yaml
	thumb_func_start sub_803DEAC
sub_803DEAC:
	push {r4-r7,lr}
	bl link_initAndReset_8144240
	pop {r4-r7,pc}
	thumb_func_end sub_803DEAC

// symdb: Updates the link-battle state (eLinkState + Camera shake/state fields) and returns a numeric code describing the current link phase.
// symdb: (r0 = timer/group index, r1 = pointer to local stack scratch from caller) -> r0 = link-state
// symdb: code (1, 2, 4, 8, 0x20, or 4) ; side effects: writes to eLinkState and the camera-struct fields
// symdb: at +0x04 (pad_54), +0x06 (pad_56), +0x07 (pad_56+1), +0x0C (eCamera.unk_5C), +0x48; calls
// symdb: TestEventFlagFromImmediate on EVENT_172F.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_updateLinkState_803DEB4.yaml
	thumb_func_start battle_updateLinkState_803DEB4
battle_updateLinkState_803DEB4:
	push {r4-r7,lr}
	mov r6, #1
	ldr r7, off_803DF9C // =eLinkState
	add r0, r7, #6
	ldr r1, off_803DFA0 // =byte_200DD10
	ldr r2, off_803DFA4 // =unk_2009480
	bl link_stateMachineRunStep_8144250
	str r0, [r7,#0x48] // (dword_2009A18 - 0x20099d0)
	push {r0}
	bl timer_IsEnabled_8144CE0
	cmp r0, #5
	pop {r0}
	bne loc_803DED6
	mov r6, #4
	b loc_803DF96
loc_803DED6:
	sub sp, sp, #0x10
	str r0, [sp]
	bl timer_IsEnabled_8144CE0
	cmp r0, #1
	bne loc_803DEFE
	movflag EVENT_172F
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_803DEF8
	ldrh r0, [r7,#0xc] // (eCamera.unk_5C - 0x20099d0)
	tst r0, r0
	beq loc_803DEF8
	sub r0, #1
	strh r0, [r7,#0xc] // (eCamera.unk_5C - 0x20099d0)
	b loc_803DF16
loc_803DEF8:
	mov r1, #1
	strb r1, [r7,#0x6] // (eCamera.pad_56 - 0x20099d0)
	b loc_803DF16
loc_803DEFE:
	cmp r0, #2
	bne loc_803DF16
	ldrb r2, [r7,#0x7] // (eCamera.pad_56+1 - 0x20099d0)
	cmp r2, #2
	bne loc_803DF0E
	mov r0, #0xff
	strb r0, [r7,#0x7] // (eCamera.pad_56+1 - 0x20099d0)
	b loc_803DF16
loc_803DF0E:
	strb r0, [r7,#0x7] // (eCamera.pad_56+1 - 0x20099d0)
	mov r1, #1
	strb r1, [r7,#0x6] // (eCamera.pad_56 - 0x20099d0)
	b loc_803DF16
loc_803DF16:
	ldr r0, [sp]
	mov r1, #3
	and r0, r1
	lsl r0, r0, #0
	str r0, [sp,#4]
	ldr r0, [sp]
	mov r1, #0x1c
	and r0, r1
	lsr r0, r0, #2
	str r0, [sp,#8]
	strb r0, [r7,#0x4] // (eCamera.pad_54 - 0x20099d0)
	ldr r0, [sp]
	mov r1, #0x20
	and r0, r1
	beq loc_803DF7E
	ldr r0, [sp,#8]
	cmp r0, #2
	blt loc_803DF42
	ldr r0, [sp]
	mov r1, #0x40
	and r0, r1
	bne loc_803DF50
loc_803DF42:
	ldr r0, [sp]
	mov r1, #0x20
	lsl r1, r1, #0x10
	and r0, r1
	beq loc_803DF86
	mov r6, #4
	b loc_803DF86
loc_803DF50:
	ldr r0, [sp]
	ldr r1, [sp,#4]
	ldr r2, [sp,#8]
	bl sub_803E018
	mov r6, r0
	cmp r6, #2
	bne loc_803DF86
	ldr r7, [sp,#8]
	bl sub_803E200
	tst r0, r0
	beq loc_803DF86
	cmp r0, #2
	bne loc_803DF72
	mov r6, #0x20
	b loc_803DF86
loc_803DF72:
	cmp r0, #0x20
	bne loc_803DF7A
	mov r6, #4
	b loc_803DF86
loc_803DF7A:
	mov r6, #8
	b loc_803DF86
loc_803DF7E:
	ldr r0, [sp]
	mov r1, #0x40
	and r0, r1
	bne loc_803DF50
loc_803DF86:
	add sp, sp, #0x10
	cmp r6, #4
	bne loc_803DF96
	ldr r0, off_803DF9C // =eLinkState
	ldrb r1, [r0,#0x5] // (eCamera.unk_55 - 0x20099d0)
	tst r1, r1
	beq loc_803DF96
	mov r6, #4
loc_803DF96:
	mov r0, r6
	pop {r4-r7,pc}
	.balign 4, 0
off_803DF9C:
	.word eLinkState // eLinkState
off_803DFA0:
	.word byte_200DD10
off_803DFA4:
	.word unk_2009480
	.word eTimerEnable200F460
	thumb_func_end battle_updateLinkState_803DEB4

	thumb_local_start
sub_803DFAC:
	push {r4-r7,lr}
	mov r4, r0
	mov r6, #0
	mov r1, #1
	lsl r1, r1, #8
	and r1, r4
	beq loc_803DFBE
	mov r0, #0x80
	orr r6, r0
loc_803DFBE:
	mov r1, #0x40
	lsl r1, r1, #0x10
	and r1, r4
	beq loc_803DFCA
	mov r0, #0x40
	orr r6, r0
loc_803DFCA:
	mov r1, #2
	lsl r1, r1, #0x10
	and r1, r4
	beq loc_803DFD6
	mov r0, #2
	orr r6, r0
loc_803DFD6:
	mov r1, #1
	lsl r1, r1, #0x10
	and r1, r4
	beq loc_803DFE2
	mov r0, #1
	orr r6, r0
loc_803DFE2:
	mov r1, #4
	lsl r1, r1, #0x10
	and r1, r4
	beq loc_803DFEE
	mov r0, #4
	orr r6, r0
loc_803DFEE:
	mov r1, #8
	lsl r1, r1, #0x10
	and r1, r4
	beq loc_803DFFA
	mov r0, #8
	orr r6, r0
loc_803DFFA:
	mov r1, #0x10
	lsl r1, r1, #0x10
	and r1, r4
	beq loc_803E006
	mov r0, #0x10
	orr r6, r0
loc_803E006:
	mov r1, #0x20
	lsl r1, r1, #0x10
	and r1, r4
	beq loc_803E012
	mov r0, #0x20
	orr r6, r0
loc_803E012:
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end sub_803DFAC

	thumb_local_start
sub_803E018:
	push {r4-r7,lr}
	push {r0}
	bl ho_803E114
	pop {r0}
	bl sub_803DFAC
	mov r1, #0x7f
	and r1, r0
	bne loc_803E036
	mov r1, #0x80
	and r1, r0
	beq loc_803E03A
	mov r6, #8
	b loc_803E04A
loc_803E036:
	mov r6, #4
	b loc_803E04A
loc_803E03A:
	mov r6, #2
	mov r0, #4
	bl sub_803E7A4
	tst r1, r1
	bne loc_803E04A
	bl sub_803E7D8
loc_803E04A:
	mov r0, r6
	pop {r4-r7,pc}
	.balign 4, 0
	.word byte_2009940
	.word DebugStr803E088
	.word DebugStr803E091
	.word DebugStr803E09E
	.word DebugStr803E0A9
	.word DebugStr803E0B3
	.word DebugStr803E0BC
	.word DebugStr803E0C8
	.word DebugStr803E0D5
	.word DebugStr803E0DF
	.word DebugStr803E0EA
	.word DebugStr803E0F4
	.word DebugStr803E0FE
	.word DebugStr803E108
DebugStr803E088:
	.hword 0x314
	.asciz "ID(%D)"
DebugStr803E091:
	.hword 0x414
	.asciz "PL NUM(%D)"
DebugStr803E09E:
	.hword 0x214
	.asciz "SIO WAIT"
DebugStr803E0A9:
	.hword 0x214
	.asciz "SIO OFF"
DebugStr803E0B3:
	.hword 0x214
	.asciz "SIO ON"
DebugStr803E0BC:
	.hword 0x214
	.asciz "SIO ERROR"
DebugStr803E0C8:
	.hword 0x214
	.asciz "SIO ERROR2"
DebugStr803E0D5:
	.hword 0xA14
	.asciz "ST:0x%X"
DebugStr803E0DF:
	.hword 0x514
	.asciz "RNO:0x%X"
DebugStr803E0EA:
	.hword 0xD14
	.asciz "RECV:%X"
DebugStr803E0F4:
	.hword 0xE14
	.asciz "RECV:%X"
DebugStr803E0FE:
	.hword 0xF14
	.asciz "RECV:%X"
DebugStr803E108:
	.hword 0x60A
	.asciz "S:%D,R:%D"
	thumb_func_end sub_803E018

	thumb_local_start
ho_803E114:
	push {r4-r7,lr}
	mov r0, r8
	mov r3, r9
	push {r0,r3}
	ldr r5, off_803E14C // =byte_200DD10
	ldr r7, off_803E150 // =eLinkState
	ldr r1, off_803E134 // =jt_803E138
	ldrb r0, [r7]
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r0,r3}
	mov r8, r0
	mov r9, r3
	pop {r4-r7,pc}
	.hword 0x0
	.balign 4, 0
off_803E134:
	.word jt_803E138
jt_803E138:
	.word sub_803E154+1
	.word sub_803E16C+1
	.word sub_803E1C0+1
	.word sub_803E1E0+1
	.word sub_803E1D0+1
off_803E14C:
	.word byte_200DD10
off_803E150:
	.word eLinkState // eLinkState
	thumb_func_end ho_803E114

	thumb_local_start
sub_803E154:
	push {lr}
	ldr r0, [r7,#0x1c]
	str r0, [r5,#4]
	ldrh r0, [r7,#0xa]
	strh r0, [r5,#2]
	ldr r0, [r7,#0x44]
	str r0, [r5,#0xc]
	ldr r0, [r7,#0x20]
	str r0, [r5,#8]
	mov r0, #0x60
	strh r0, [r5]
	pop {pc}
	thumb_func_end sub_803E154

	thumb_local_start
sub_803E16C:
	push {lr}
	ldrb r0, [r7,#2]
	lsl r0, r0, #2
	ldr r1, off_803E17C // =off_803E180
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {pc}
off_803E17C:
	.word off_803E180
off_803E180:
	.word sub_803E198+1
	.word sub_803E1AC+1
	.word sub_803E1AC+1
	.word sub_803E1AC+1
	.word sub_803E1AC+1
	.word sub_803E198+1
	thumb_func_end sub_803E16C

	thumb_local_start
sub_803E198:
	push {lr}
	ldr r0, [r7,#0x34]
	mov r4, #0x10
	mov r2, #0
loc_803E1A0:
	ldrh r3, [r0,r2]
	strh r3, [r5,r2]
	add r2, #2
	cmp r2, r4
	blt loc_803E1A0
	pop {pc}
	thumb_func_end sub_803E198

	thumb_local_start
sub_803E1AC:
	push {lr}
	ldr r0, [r7,#0x34]
	mov r4, #0x10
	mov r2, #0
loc_803E1B4:
	ldrh r3, [r0,r2]
	strh r3, [r5,r2]
	add r2, #2
	cmp r2, r4
	blt loc_803E1B4
	pop {pc}
	thumb_func_end sub_803E1AC

	thumb_local_start
sub_803E1C0:
	push {lr}
	ldrh r0, [r7,#0xa]
	strh r0, [r5,#2]
	ldr r0, [r7,#0x1c]
	str r0, [r5,#4]
	mov r0, #0x62
	strh r0, [r5]
	pop {pc}
	thumb_func_end sub_803E1C0

	thumb_local_start
sub_803E1D0:
	push {lr}
	ldrh r0, [r7,#0xa]
	strh r0, [r5,#2]
	ldr r0, [r7,#0x1c]
	str r0, [r5,#4]
	mov r0, #0x62
	strh r0, [r5,#8]
	pop {pc}
	thumb_func_end sub_803E1D0

	thumb_local_start
sub_803E1E0:
	push {lr}
	ldr r0, [r7,#0x54]
	sub r0, #1
	str r0, [r7,#0x54]
	bne loc_803E1EE
	mov r0, #4
	strb r0, [r7]
loc_803E1EE:
	ldr r0, [r7,#0x34]
	mov r4, #0x10
	mov r2, #0
loc_803E1F4:
	mov r3, #0
	strh r3, [r5,r2]
	add r2, #2
	cmp r2, r4
	blt loc_803E1F4
	pop {pc}
	thumb_func_end sub_803E1E0

	thumb_local_start
sub_803E200:
	push {r4-r7,lr}
	ldr r5, off_803E22C // =unk_2009480
	ldr r6, off_803E230 // =eLinkState
	mov r0, #1
	strb r0, [r6,#0x5] // (eCamera.unk_55 - 0x20099d0)
	ldr r1, off_803E218 // =off_803E21C
	ldrb r0, [r6,#0x1] // (eCamera.unk_51 - 0x20099d0)
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803E218:
	.word off_803E21C
off_803E21C:
	.word sub_803E234+1
	.word sub_803E564+1
	.word sub_803E6F8+1
	.word sub_803E740+1
off_803E22C:
	.word unk_2009480
off_803E230:
	.word eLinkState // eLinkState
	thumb_func_end sub_803E200

	thumb_local_start
sub_803E234:
	push {lr}
	ldrb r0, [r6,#2]
	lsl r0, r0, #2
	ldr r1, off_803E244 // =off_803E248
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {pc}
off_803E244:
	.word off_803E248
off_803E248:
	.word sub_803E260+1
	.word sub_803E268+1
	.word sub_803E40C+1
	.word sub_803E548+1
	.word sub_803E548+1
	.word sub_803E260+1
	thumb_func_end sub_803E234

	thumb_local_start
sub_803E260:
	push {lr}
	mov r0, #0
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_803E260

	thumb_local_start
sub_803E268:
	push {r4-r7,lr}
	ldr r4, off_803E278 // =eStruct200F360
	ldrb r0, [r4,#0x1] // (byte_200F361 - 0x200f360)
	ldr r1, off_803E27C // =off_803E280
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803E278:
	.word eStruct200F360
off_803E27C:
	.word off_803E280
off_803E280:
	.word sub_803E288+1
	.word sub_803E34C+1
	thumb_func_end sub_803E268

	thumb_local_start
sub_803E288:
	push {lr}
	mov r3, #2
	mov r0, #4
	mul r3, r0
	sub sp, sp, #0x10
	str r3, [sp]
	str r4, [sp,#4]
	str r5, [sp,#8]
	str r6, [sp,#0xc]
	bl sub_803E88C
	bgt loc_803E330
	mov r4, r5
	mov r2, r7
	mov r1, #0
	mul r1, r3
loc_803E2A8:
	ldrh r0, [r4,r1]
	cmp r0, #0x62
	beq loc_803E326
	cmp r0, #0x60
	bne loc_803E330
	add r4, #2
	sub r2, #1
	bgt loc_803E2A8
	mov r4, r5
	mov r2, r7
	mov r1, #1
	mul r1, r3
	ldr r5, off_803E340 // =dword_803E344
	mov r6, #0
loc_803E2C4:
	ldrh r0, [r4,r1]
	ldrh r3, [r5,r6]
	and r3, r0
	push {r1}
	ldr r1, dword_803E338 // =0x2000
	cmp r3, r1
	pop {r1}
	beq loc_803E2DE
	push {r1}
	ldr r1, dword_803E33C // =0x1000
	cmp r3, r1
	pop {r1}
	bne loc_803E330
loc_803E2DE:
	add r4, #2
	add r6, #2
	sub r2, #1
	bgt loc_803E2C4
	ldr r1, [sp,#4]
	strh r0, [r1,#4]
	ldr r5, [sp,#8]
	ldr r6, [sp,#0xc]
	mov r4, r5
	mov r2, r7
	mov r1, #2
	ldr r3, [sp]
	mul r1, r3
loc_803E2F8:
	push {r1}
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	ldr r1, [r6,#0x1c]
	cmp r0, r1
	beq loc_803E314
	ldr r1, dword_803E348 // =0x4252424a
	cmp r0, r1
	beq loc_803E314
	pop {r1}
	b loc_803E330
loc_803E314:
	pop {r1}
	add r4, #2
	sub r2, #1
	bgt loc_803E2F8
	mov r0, #1
	strh r0, [r6,#0xe]
loc_803E320:
	add sp, sp, #0x10
	mov r0, #0
	pop {pc}
loc_803E326:
	mov r0, #8
	strb r0, [r6]
	bl sub_803E89C
	b loc_803E320
loc_803E330:
	add sp, sp, #0x10
	mov r0, #1
	pop {pc}
	.balign 4, 0
dword_803E338:
	.word 0x2000
dword_803E33C:
	.word 0x1000
off_803E340:
	.word dword_803E344
dword_803E344:
	.word 0x10002000
dword_803E348:
	.word 0x4252424A
	thumb_func_end sub_803E288

	thumb_local_start
sub_803E34C:
	push {lr}
	mov r3, #2
	mov r0, #4
	mul r3, r0
	sub sp, sp, #0x10
	str r3, [sp]
	str r4, [sp,#4]
	str r5, [sp,#8]
	str r6, [sp,#0xc]
	mov r4, r5
	mov r2, r7
	mov r1, #0
	mul r1, r3
loc_803E366:
	ldrh r0, [r4,r1]
	cmp r0, #0x62
	beq loc_803E3F4
	cmp r0, #0x60
	bne loc_803E3FE
	add r4, #2
	sub r2, #1
	bgt loc_803E366
	mov r4, r5
	mov r2, r7
	mov r1, #1
	mul r1, r3
loc_803E37E:
	ldrh r0, [r4,r1]
	ldr r3, dword_803E404 // =0x1010
	and r0, r3
	beq loc_803E3FE
	add r4, #2
	sub r2, #1
	bgt loc_803E37E
	mov r4, r5
	mov r2, r7
	mov r1, #2
	ldr r3, [sp]
	mul r1, r3
loc_803E396:
	push {r1}
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	ldr r1, [r6,#0x1c]
	cmp r0, r1
	beq loc_803E3B2
	ldr r1, dword_803E408 // =0x4252424a
	cmp r0, r1
	beq loc_803E3B2
	pop {r1}
	b loc_803E3FE
loc_803E3B2:
	pop {r1}
	add r4, #2
	sub r2, #1
	bgt loc_803E396
	mov r4, r5
	mov r1, #4
	mul r1, r3
	add r4, #2
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	str r0, [r6,#0x20]
	mov r4, r5
	mov r1, #6
	mul r1, r3
	add r4, #2
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	str r0, [r6,#0x40]
	ldrb r0, [r6,#1]
	add r0, #4
	strb r0, [r6,#1]
	strb r0, [r6]
	mov r0, #2
	strh r0, [r6,#0xe]
loc_803E3EE:
	add sp, sp, #0x10
	mov r0, #0
	pop {pc}
loc_803E3F4:
	mov r0, #8
	strb r0, [r6]
	bl sub_803E89C
	b loc_803E3EE
loc_803E3FE:
	add sp, sp, #0x10
	mov r0, #1
	pop {pc}
	.balign 4, 0
dword_803E404:
	.word 0x1010
dword_803E408:
	.word 0x4252424A
	thumb_func_end sub_803E34C

	thumb_local_start
sub_803E40C:
	push {r4-r7,lr}
	ldr r4, off_803E41C // =eStruct200F360
	ldrb r0, [r4,#0x1] // (byte_200F361 - 0x200f360)
	ldr r1, off_803E420 // =off_803E424
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803E41C:
	.word eStruct200F360
off_803E420:
	.word off_803E424
off_803E424:
	.word sub_803E428+1
	thumb_func_end sub_803E40C

	thumb_local_start
sub_803E428:
	push {r4-r7,lr}
	mov r3, #2
	mov r0, #4
	mul r3, r0
	sub sp, sp, #0x14
	str r7, [sp]
	str r4, [sp,#4]
	str r5, [sp,#8]
	str r6, [sp,#0xc]
	str r3, [sp,#0x10]
	mov r4, #0
	mov r7, #0
loc_803E440:
	mov r0, r4
	bl sub_8144D04
	cmp r0, #1
	bne loc_803E44C
	add r7, #1
loc_803E44C:
	cmp r0, #0
	beq loc_803E534
	add r4, #1
	ldr r0, [sp]
	cmp r4, r0
	blt loc_803E440
	cmp r7, #2
	bne loc_803E534
	ldr r7, [sp]
	mov r4, r5
	mov r1, #0
	ldr r3, [sp,#0x10]
	mul r1, r3
	mov r2, #0
loc_803E468:
	mov r0, r2
	add r0, #1
	bl sub_803E78C
	beq loc_803E47C
	ldrh r0, [r4,r1]
	cmp r0, #0x62
	beq loc_803E52A
	cmp r0, #0x60
	bne loc_803E534
loc_803E47C:
	add r4, #2
	add r2, #1
	cmp r2, r7
	blt loc_803E468
	mov r4, r5
	mov r1, #2
	ldr r3, [sp,#0x10]
	mul r1, r3
	mov r2, #0
loc_803E48E:
	mov r0, r2
	add r0, #1
	bl sub_803E78C
	beq loc_803E4AC
	push {r1}
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	ldr r1, [r6,#0x1c]
	cmp r0, r1
	pop {r1}
	bne loc_803E534
loc_803E4AC:
	add r4, #2
	add r2, #1
	cmp r2, r7
	blt loc_803E48E
	mov r4, r5
	mov r2, r7
	mov r1, #1
	ldr r3, [sp,#0x10]
	mul r1, r3
	mov r2, #0
loc_803E4C0:
	mov r0, r2
	add r0, #1
	bl sub_803E78C
	beq loc_803E4D2
	ldrh r0, [r4,r1]
	ldrh r3, [r6,#0xa]
	cmp r0, r3
	bne loc_803E53A
loc_803E4D2:
	add r4, #2
	add r2, #1
	cmp r2, r7
	blt loc_803E4C0
	mov r4, r5
	mov r1, #4
	ldr r3, [sp,#0x10]
	mul r1, r3
	mov r0, r4
	bl sub_803E8B4
	mov r4, r0
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	str r0, [r6,#0x20]
	mov r4, r5
	mov r1, #6
	ldr r3, [sp,#0x10]
	mul r1, r3
	mov r0, r4
	bl sub_803E8B4
	mov r4, r0
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	str r0, [r6,#0x40]
	ldrb r0, [r6,#1]
	add r0, #4
	strb r0, [r6,#1]
	strb r0, [r6]
	mov r0, #2
	strh r0, [r6,#0xe]
	mov r0, #0
	strh r0, [r6,#0x1c]
	str r0, [r6,#0x30]
	add sp, sp, #0x14
	mov r0, #0
	pop {r4-r7,pc}
loc_803E52A:
	mov r0, #8
	strb r0, [r6]
	bl sub_803E89C
	b loc_803E4C0
loc_803E534:
	add sp, sp, #0x14
	mov r0, #1
	pop {r4-r7,pc}
loc_803E53A:
	add sp, sp, #0x14
	mov r0, #2
	pop {r4-r7,pc}
	.word dword_803E544
	.balign 4, 0
dword_803E544:
	.word 0x10102000
	thumb_func_end sub_803E428

	thumb_local_start
sub_803E548:
	push {r4-r7,lr}
	ldr r4, off_803E558 // =eStruct200F360
	ldrb r0, [r4,#0x1] // (byte_200F361 - 0x200f360)
	ldr r1, off_803E55C // =off_803E560
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803E558:
	.word eStruct200F360
off_803E55C:
	.word off_803E560
off_803E560:
	.word sub_803E428+1
	thumb_func_end sub_803E548

	thumb_local_start
sub_803E564:
	push {lr}
	ldrb r0, [r6,#2]
	lsl r0, r0, #2
	ldr r1, off_803E574 // =off_803E578
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {pc}
off_803E574:
	.word off_803E578
off_803E578:
	.word sub_803E590+1
	.word sub_803E598+1
	.word sub_803E628+1
	.word sub_803E590+1
	.word sub_803E6A2+1
	.word sub_803E69C+1
	thumb_func_end sub_803E564

	thumb_local_start
sub_803E590:
	push {r4-r7,lr}
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_803E590

	thumb_local_start
sub_803E598:
	push {r4-r7,lr}
	ldr r4, off_803E604 // =eStruct200F360
	ldrb r0, [r4]
	tst r0, r0
	bne loc_803E5FE
	add r5, #2
	ldrb r0, [r4,#0x2] // (byte_200F362 - 0x200f360)
	tst r0, r0
	bne loc_803E5BC
	ldrh r2, [r5]
	cmp r2, #0x61
	bne loc_803E5FE
	mov r0, #1
	strb r0, [r4,#0x2] // (byte_200F362 - 0x200f360)
	mov r0, #0
	str r0, [r4,#0x8] // (dword_200F368 - 0x200f360)
	mov r0, #0
	str r0, [r6,#0x28]
loc_803E5BC:
	mov r1, #0x38
	add r1, r1, r6
	ldr r2, [r1]
	mov r1, #0xe
	ldr r7, [r6,#0x28]
	mov r3, #2
	mov r0, #4
	mul r3, r0
	add r5, r5, r3
loc_803E5CE:
	bl sub_803E608
	add r5, r5, r3
	add r7, #2
	sub r1, #2
	bgt loc_803E5CE
	str r7, [r6,#0x28]
	ldr r0, [r6,#0x20]
	cmp r7, r0
	blt loc_803E5FE
	ldr r0, [r6,#0x40]
	ldr r1, [r4,#0x8] // (dword_200F368 - 0x200f360)
	cmp r0, r1
	beq loc_803E5F6
	mov r0, #8
	strb r0, [r6,#1]
	mov r0, #4
	strh r0, [r6,#0xe]
	mov r0, #0x20
	pop {r4-r7,pc}
loc_803E5F6:
	mov r0, #8
	strb r0, [r6,#1]
	mov r0, #4
	strh r0, [r6,#0xe]
loc_803E5FE:
	mov r0, #0
	pop {r4-r7,pc}
	.balign 4, 0
off_803E604:
	.word eStruct200F360
	thumb_func_end sub_803E598

	thumb_local_start
sub_803E608:
	push {r0-r7,lr}
	mov r3, #0
	ldr r0, [r6,#0x28]
	tst r0, r0
	bne loc_803E614
	ldrb r0, [r5,r3]
loc_803E614:
	ldrb r0, [r5,r3]
	strb r0, [r2,r7]
	ldr r1, [r4,#8]
	add r1, r1, r0
	str r1, [r4,#8]
	add r7, #1
	add r3, #1
	cmp r3, #2
	blt loc_803E614
	pop {r0-r7,pc}
	thumb_func_end sub_803E608

	thumb_local_start
sub_803E628:
	push {r4-r7,lr}
	mov r0, r5
	bl sub_803E8B4
	mov r5, r0
	ldr r7, off_803E698 // =eStruct200F360
	ldrb r0, [r7,#0x2] // (byte_200F362 - 0x200f360)
	tst r0, r0
	bne loc_803E64E
	ldrh r2, [r5]
	cmp r2, #0x61
	beq loc_803E644
	mov r0, #0
	b locret_803E696
loc_803E644:
	mov r0, #1
	strb r0, [r7,#0x2] // (byte_200F362 - 0x200f360)
	mov r0, #0
	str r0, [r7,#0x8] // (dword_200F368 - 0x200f360)
	str r0, [r6,#0x28]
loc_803E64E:
	mov r4, #0x38
	bl link_getModeSelector_803DD30
	tst r0, r0
	beq loc_803E65A
	mov r4, #0x3c
loc_803E65A:
	add r1, r4, r6
	ldr r2, [r1]
	mov r1, #0xe
	ldr r7, [r6,#0x28]
	mov r3, #2
	mov r0, #4
	mul r3, r0
	add r5, r5, r3
	ldr r4, off_803E698 // =eStruct200F360
loc_803E66C:
	bl sub_803E608
	add r5, r5, r3
	add r7, #2
	sub r1, #2
	bgt loc_803E66C
	mov r2, #0
	str r7, [r6,#0x28]
	ldr r0, [r6,#0x20]
	cmp r7, r0
	blt loc_803E694
	ldr r0, [r6,#0x40]
	ldr r1, [r4,#0x8] // (dword_200F368 - 0x200f360)
	cmp r0, r1
	beq loc_803E68C
	mov r2, #0x20
loc_803E68C:
	mov r0, #8
	strb r0, [r6,#1]
	mov r0, #4
	strh r0, [r6,#0xe]
loc_803E694:
	mov r0, r2
locret_803E696:
	pop {r4-r7,pc}
	.balign 4, 0
off_803E698:
	.word eStruct200F360
	thumb_func_end sub_803E628

	thumb_local_start
sub_803E69C:
	push {r4-r7,lr}
	nop
	b loc_803E6A4
	thumb_func_end sub_803E69C

	thumb_local_start
sub_803E6A2:
	push {r4-r7,lr}
loc_803E6A4:
	sub sp, sp, #0x10
	mov r0, #0
	str r0, [sp]
	str r0, [sp,#4]
	str r0, [sp,#8]
	mov r1, #0
	mov r2, #4
loc_803E6B2:
	ldr r0, [sp]
	add r0, #1
	str r0, [sp]
	bl sub_803E78C
	beq loc_803E6CA
	cmp r2, #4
	bne loc_803E6C6
	str r1, [sp,#4]
	b loc_803E6C8
loc_803E6C6:
	str r1, [sp,#8]
loc_803E6C8:
	add r2, #4
loc_803E6CA:
	add r1, #2
	cmp r1, #8
	blt loc_803E6B2
	ldr r3, [r6,#0x38]
	ldr r4, [r6,#0x3c]
	ldr r7, [r6,#0x20]
	mov r0, #2
	mov r1, #4
	mul r0, r1
loc_803E6DC:
	ldr r1, [sp,#4]
	ldrh r2, [r5,r1]
	strh r2, [r3]
	ldr r1, [sp,#8]
	ldrh r2, [r5,r1]
	strh r2, [r4]
	add r5, r5, r0
	add r3, #2
	add r4, #2
	sub r7, #2
	bgt loc_803E6DC
	add sp, sp, #0x10
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_803E6A2

	thumb_local_start
sub_803E6F8:
	push {lr}
	sub sp, sp, #0x10
	mov r0, #0
	str r0, [sp]
	ldrb r0, [r6,#8]
	tst r0, r0
	bne loc_803E72E
	mov r3, #2
	mov r1, #4
	mul r3, r1
loc_803E70C:
	mov r2, r5
	ldr r0, [sp]
	add r0, #1
	bl sub_803E78C
	beq loc_803E71E
	ldrh r0, [r2]
	cmp r0, #0x62
	bne loc_803E738
loc_803E71E:
	ldr r0, [sp]
	add r0, #1
	str r0, [sp]
	add r5, #2
	sub r7, #1
	bgt loc_803E70C
	mov r0, #1
	strb r0, [r6,#8]
loc_803E72E:
	ldrh r0, [r6,#0xc]
	tst r0, r0
	beq loc_803E738
	sub r0, #1
	strh r0, [r6,#0xc]
loc_803E738:
	add sp, sp, #0x10
	mov r0, #0
	pop {pc}
	.byte 0, 0
	thumb_func_end sub_803E6F8

	thumb_local_start
sub_803E740:
	push {lr}
	sub sp, sp, #0x10
	mov r0, #0
	str r0, [sp]
	ldrb r0, [r6,#8]
	tst r0, r0
	bne loc_803E77C
	mov r3, #2
	mov r1, #4
	mul r3, r1
loc_803E754:
	mov r2, r5
	ldr r0, [sp]
	add r0, #1
	bl sub_803E78C
	beq loc_803E76C
	mov r1, #8
	mov r0, #4
	mul r1, r0
	ldrh r0, [r2,r1]
	cmp r0, #0x62
	bne loc_803E786
loc_803E76C:
	ldr r0, [sp]
	add r0, #1
	str r0, [sp]
	add r5, #2
	sub r7, #1
	bgt loc_803E754
	mov r0, #1
	strb r0, [r6,#8]
loc_803E77C:
	ldrh r0, [r6,#0xc]
	tst r0, r0
	beq loc_803E786
	sub r0, #1
	strh r0, [r6,#0xc]
loc_803E786:
	add sp, sp, #0x10
	mov r0, #0
	pop {pc}
	thumb_func_end sub_803E740

	thumb_local_start
sub_803E78C:
	push {r0-r3,lr}
	sub r0, #1
	bl sub_8144D04
	cmp r0, #2
	beq locret_803E7A0
	cmp r0, #0xff
	beq locret_803E7A0
	mov r0, #1
	tst r0, r0
locret_803E7A0:
	pop {r0-r3,pc}
	.balign 4, 0x00
	thumb_func_end sub_803E78C

	thumb_local_start
sub_803E7A4:
	push {r4-r7,lr}
	mov r7, r0
	bl link_getModeSelector_803DD30
	ldr r1, off_803E7C8 // =dword_803E7D4
	ldrb r0, [r1,r0]
	cmp r0, #0xff
	beq loc_803E7C2
	mov r1, #8
	mul r1, r7
	add r1, r1, r0
	ldr r0, off_803E7CC // =byte_2009940
	ldrh r0, [r0,r1]
	mov r1, #0
	b locret_803E7C6
loc_803E7C2:
	mov r1, #1
	mov r0, #0
locret_803E7C6:
	pop {r4-r7,pc}
	.balign 4, 0
off_803E7C8:
	.word dword_803E7D4
off_803E7CC:
	.word byte_2009940
	.word eLinkState // eLinkState
dword_803E7D4:
	.word 0x4FFFF02
	thumb_func_end sub_803E7A4

	thumb_local_start
sub_803E7D8:
	push {r7,lr}
	ldrh r1, [r7,#0x14]
	cmp r0, r1
	beq loc_803E7E6
	strh r0, [r7,#0x14]
	mov r1, #0
	strh r1, [r7,#0x18]
loc_803E7E6:
	ldrh r1, [r7,#0x18]
	cmp r1, #8
	beq loc_803E7F2
	add r1, #1
	strh r1, [r7,#0x18]
	b locret_803E80A
loc_803E7F2:
	ldrh r1, [r7,#0x12]
	tst r1, r1
	bne loc_803E800
	strh r0, [r7,#0x16]
	strh r0, [r7,#0x10]
	strh r0, [r7,#0x12]
	b locret_803E80A
loc_803E800:
	ldrh r1, [r7,#0x10]
	strh r1, [r7,#0x12]
	strh r0, [r7,#0x10]
	mov r0, #0
	strh r0, [r7,#0x16]
locret_803E80A:
	pop {r7,pc}
	thumb_func_end sub_803E7D8

	thumb_local_start
sub_803E80C:
	push {r0-r7,lr}
	bl IsCurSubsystemInUse // () -> (bool, !zf)
	beq locret_803E826
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r0, [r0]
	cmp r0, #4
	bne locret_803E826
	tst r2, r2
	bne locret_803E826
	mov r2, #0xc
	strb r2, [r6]
locret_803E826:
	pop {r0-r7,pc}
	thumb_func_end sub_803E80C

	thumb_local_start
sub_803E828:
	push {r0-r2,r7,lr}
	ldrb r1, [r5,#0xe]
	cmp r1, #5
	ble loc_803E832
	b loc_803E838
loc_803E832:
	ldrb r2, [r5,#0xf]
	cmp r2, #5
	ble locret_803E84A
loc_803E838:
	ldr r7, off_803E84C // =eLinkState
	mov r0, r1
	cmp r1, r2
	bge loc_803E842
	mov r0, r2
loc_803E842:
	add r0, #8
	str r0, [r7,#0x54] // (dword_2009A24 - 0x20099d0)
	mov r0, #0xc
	strb r0, [r7]
locret_803E84A:
	pop {r0-r2,r7,pc}
	.balign 4, 0
off_803E84C:
	.word eLinkState // eLinkState
	thumb_func_end sub_803E828

	thumb_local_start
sub_803E850:
	push {r0-r2,r7,lr}
	ldrb r1, [r5,#0xe]
	cmp r1, #5
	ble loc_803E85A
	b loc_803E860
loc_803E85A:
	ldrb r2, [r5,#0xf]
	cmp r2, #5
	ble locret_803E87A
loc_803E860:
	ldr r7, off_803E87C // =eLinkState
	mov r0, r1
	cmp r1, r2
	bge loc_803E86A
	mov r0, r2
loc_803E86A:
	add r0, #8
	ldr r1, [r7,#0x54] // (dword_2009A24 - 0x20099d0)
	cmp r0, r1
	bge loc_803E874
	mov r0, r1
loc_803E874:
	str r0, [r7,#0x54] // (dword_2009A24 - 0x20099d0)
	mov r0, #0xc
	strb r0, [r7]
locret_803E87A:
	pop {r0-r2,r7,pc}
	.balign 4, 0
off_803E87C:
	.word eLinkState // eLinkState
	thumb_func_end sub_803E850

	thumb_local_start
sub_803E880:
	push {lr}
	mov r1, #8
	strb r1, [r0]
	mov r1, #0x10
	strh r1, [r0,#0xc]
	pop {pc}
	thumb_func_end sub_803E880

	thumb_local_start
sub_803E88C:
	push {lr}
	ldr r2, off_803E898 // =eLinkState
	ldrb r0, [r2,#0x4] // (eCamera.pad_54 - 0x20099d0)
	ldrb r1, [r2,#0x3] // (eCamera.unk_53 - 0x20099d0)
	cmp r0, r1
	pop {pc}
off_803E898:
	.word eLinkState // eLinkState
	thumb_func_end sub_803E88C

	thumb_local_start
sub_803E89C:
	push {lr}
	ldr r6, off_803E8B0 // =eLinkState
	mov r0, #0
	strh r0, [r6,#0xe] // (eCamera.pad_5E - 0x20099d0)
	mov r0, #8
	strb r0, [r6,#0x1] // (eCamera.unk_51 - 0x20099d0)
	mov r0, r6
	bl sub_803E880
	pop {pc}
	.balign 4, 0
off_803E8B0:
	.word eLinkState // eLinkState
	thumb_func_end sub_803E89C

	thumb_local_start
sub_803E8B4:
	push {r1-r7,lr}
	mov r7, r0
	mov r6, #1
loc_803E8BA:
	mov r0, r6
	bl sub_803E78C
	beq loc_803E8CC
	bl link_getModeSelector_803DD30
	sub r1, r6, #1
	cmp r0, r1
	bne loc_803E8D4
loc_803E8CC:
	add r6, #1
	cmp r6, #4
	ble loc_803E8BA
	b loc_803E8D8
loc_803E8D4:
	lsl r1, r1, #1
	add r7, r7, r1
loc_803E8D8:
	mov r0, r7
	pop {r1-r7,pc}
	thumb_func_end sub_803E8B4

	thumb_local_start
sub_803E8DC:
	ldr r0, off_803E8EC // =eLinkState
	ldr r0, [r0,#0x24] // (eCamera.unk_74 - 0x20099d0)
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end sub_803E8DC

	thumb_func_start sub_803E8E4
sub_803E8E4:
	ldr r0, off_803E8EC // =eLinkState
	ldrb r0, [r0]
	mov pc, lr
	.balign 4, 0x00
off_803E8EC:
	.word eLinkState // eLinkState
	thumb_func_end sub_803E8E4

	thumb_local_start
sub_803E8F0:
	push {lr}
	mov r0, #0
	tst r0, r0
	pop {pc}
	thumb_func_end sub_803E8F0

// symdb: Returns the address of the eLinkState global.
// symdb: Next* get_eLinkState(void); // out: r0 = &eLinkState
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803E8F8.yaml
	thumb_func_start sub_803E8F8
sub_803E8F8:
	ldr r0, off_803E8FC // =eLinkState
	mov pc, lr
off_803E8FC:
	.word eLinkState // eLinkState
	thumb_func_end sub_803E8F8

// symdb: Resets the 8-byte start-screen animation control block to zero and marks it active with state 0xB4.
// symdb: void startScreen_initAnimationControl200B1A0(void); /* preserves r2/r4, returns r0=0xB4 with NZ
// symdb: flags set from it */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/init_eStartScreenAnimationControl200B1A0_1.yaml
	thumb_func_start init_eStartScreenAnimationControl200B1A0_1
init_eStartScreenAnimationControl200B1A0_1:
	push {r4,lr}
	ldr r0, off_803E960 // =eStartScreenAnimationControl200B1A0
	mov r4, r0
	mov r1, #8
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()

	mov r0, #0xb4
	strb r0, [r4,#0x3]
	pop {r4,pc}
	.balign 4, 0x00
	thumb_func_end init_eStartScreenAnimationControl200B1A0_1

// symdb: Resets the 8-byte start-screen animation control struct and marks it active.
// symdb: void init_startScreenAnimationControl200B1A0_2(void); // flags out: Z=0,C cleared per movs r0,#1
// symdb: (NZ set from result 1)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/init_eStartScreenAnimationControl200B1A0_2.yaml
	thumb_local_start
init_eStartScreenAnimationControl200B1A0_2:
	push {r4,lr}
	ldr r0, off_803E960 // =eStartScreenAnimationControl200B1A0
	mov r4, r0
	mov r1, #8
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #1
	strb r0, [r4,#0x3] // (byte_200B1A3 - 0x200b1a0)
	pop {r4,pc}
	.balign 4, 0x00
	thumb_func_end init_eStartScreenAnimationControl200B1A0_2

// symdb: Checks whether the start-screen (title) animation has finished by comparing its state byte at 0x200B1A0 against 2.
// symdb: bool startScreen_IsTitleAnimationFinished(void) — in: lr only; out: r0 = state byte, NZCV set
// symdb: from CMP r0,#2 (Z set when state == 2)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_IsTitleAnimationFinished_803E928.yaml
	thumb_func_start startScreen_IsTitleAnimationFinished_803E928
startScreen_IsTitleAnimationFinished_803E928:
	ldr r0, off_803E960 // =eStartScreenAnimationControl200B1A0
	ldrb r0, [r0]
	cmp r0, #2
	mov pc, lr
	thumb_func_end startScreen_IsTitleAnimationFinished_803E928

// symdb: Trivial helper that unconditionally sets the CPU flags as "zero" (Z set, N clear), letting callers take a "zero/equal" branch on purpose.
// symdb: void startScreen_TstZero(void) // in: lr only; out: Z=1, N=0 (C, V unchanged); clobbers r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_TstZero.yaml
	thumb_func_start startScreen_TstZero
startScreen_TstZero: // () -> !zf
	mov r0, #0
	tst r0, r0
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end startScreen_TstZero

/// Disabling this causes "Press Start" to disappear
	thumb_func_start startScreen_AnimatePressStart_803E938
startScreen_AnimatePressStart_803E938:
	push {r4,lr}
	ldr r4, off_803E960 // =eStartScreenAnimationControl200B1A0
	ldrb r0, [r4]

	// checks blinking state of Press Screen
	cmp r0, #1
	beq .nonBlinkingState803E94C
	cmp r0, #2
	beq .blinkingState803E958

	// state 0 -- pause PressStart animation till timer runs out
	bl startScreen_DecrementPressStartPauseAnimationTimer

	b .ret
.nonBlinkingState803E94C

  // Disabling this causes "Press Start" to disappear
	bl startScreen_AnimatePressStart_803E978

	bne .ret

  // enable blinking Press Start
  mov r0, #2
  strb r0, [r4]

	b .ret
.blinkingState803E958
  // no change noticed on disable
	bl runPendingWorkIfFlagged_803EA1C
.ret:
	pop {r4,pc}
	.balign 4, 0
off_803E960:
	.word eStartScreenAnimationControl200B1A0
	thumb_func_end startScreen_AnimatePressStart_803E938

// symdb: Ticks down the "PRESS START" title-screen animation frame delay; when the timer hits zero, sets a flag so the animation advances to the next frame.
// symdb: Next startScreen_DecrementPressStartFrameTimer(void) // in: nothing meaningful (r4-r7 preserved,
// symdb: unused) // out: r0 = 1 when the timer just expired (0 otherwise reports the raw decremented
// symdb: value), //      NZ/C/V reflect the final 'sub r0,#1' or 'mov r0,#1' — NZ set iff r0 != 0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/startScreen_DecrementPressStartPauseAnimationTimer.yaml
	thumb_local_start
startScreen_DecrementPressStartPauseAnimationTimer:
	push {r4-r7,lr}
	ldr r5, off_803EA14 // =eStartScreenAnimationControl200B1A0
	
	// decrement timer
	ldrb r0, [r5,#0x3] // (byte_200B1A3 - 0x200b1a0)
	sub r0, #1
	strb r0, [r5,#0x3] // (byte_200B1A3 - 0x200b1a0)

	bne locret_803E974
	mov r0, #1
	strb r0, [r5]
locret_803E974:
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end startScreen_DecrementPressStartPauseAnimationTimer

	thumb_local_start
startScreen_AnimatePressStart_803E978:
	push {r4-r7,lr}
	ldr r5, off_803EA14 // =eStartScreenAnimationControl200B1A0
	mov r6, #1
	bl startScreen_TstZero // () -> !zf
	bne loc_803EA0A
	bl startScreen_runJumpTable_813DA94
	tst r0, r0
	bne loc_803E9A8
	bl test0x200bc50_0x5_813D60C
	beq loc_803EA0A
	cmp r0, #1
	beq loc_803E99C
	bl rfu_REQ_stopMode
	b loc_803E9A8
loc_803E99C:
	bl rfu_REQ_stopMode
	mov r0, #1
	strb r0, [r5,#0x2] // (byte_200B1A2 - 0x200b1a0)
	mov r6, #0
	b loc_803EA0A
loc_803E9A8:
	bl notZero_eByte200AD04
	bne loc_803E9C8
	ldrb r0, [r5,#0x1] // (byte_200B1A1 - 0x200b1a0)
	tst r0, r0
	bne loc_803E9C8
	mov r0, #1
	strb r0, [r5,#0x1] // (byte_200B1A1 - 0x200b1a0)
	bl clear_e200AD04 // () -> ()
	mov r0, #0
	bl battle_resetStateForNewBattle_803F6B0
	bl sub_803F50C
	b loc_803EA0A
loc_803E9C8:
	mov r6, #0
	mov r4, #1
	bl battle_getLinkStateCode_803F560
	beq loc_803E9E6
	mov r6, #1
	mov r4, #0
	ldr r1, off_803EA18 // =word_200AD04
	ldrh r0, [r1,#0x2] // (word_200AD06 - 0x200ad04)
	tst r0, r0
	beq loc_803E9E4
	sub r0, #1
	strh r0, [r1,#0x2] // (word_200AD06 - 0x200ad04)
	b loc_803EA0A
loc_803E9E4:
	mov r6, #0
loc_803E9E6:
	mov r0, r4
	bl setByte_200AD04_803F4EC
	tst r4, r4
	beq loc_803EA0A
	movflag EVENT_1E3
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_803EA0A
	movflag EVENT_7A
	bl SetEventFlagFromImmediate
	movflag EVENT_7B
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
loc_803EA0A:
	mov r0, r6
	tst r0, r0
	pop {r4-r7,pc}
	.word eLinkState // eLinkState
	.balign 4, 0
off_803EA14:
	.word eStartScreenAnimationControl200B1A0
off_803EA18:
	.word word_200AD04
	thumb_func_end startScreen_AnimatePressStart_803E978

// symdb: If the flag byte at 0x200AD04 is non-zero, dispatch to sub_803F560 to service the pending work; otherwise do nothing.
// symdb: void sub_803EA1C(void); // no meaningful inputs or outputs; calls notZero_eByte200AD04 and
// symdb: conditionally sub_803F560, so r0-r3 and flags reflect whatever those leave behind
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/runPendingWorkIfFlagged_803EA1C.yaml
	thumb_local_start
runPendingWorkIfFlagged_803EA1C:
	push {r4-r7,lr}
	bl notZero_eByte200AD04
	beq locret_803EA28
	bl battle_getLinkStateCode_803F560
locret_803EA28:
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end runPendingWorkIfFlagged_803EA1C

// symdb: Returns 1 when the link-connection state byte has reached 0xC (connection fully established), else 0.
// symdb: bool net_isLinkConnected_ADDRESS(void); // r0 = 1 if eLinkState == 0xC, else 0; c/v set by CMP,
// symdb: nz reflects the comparison
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/net_isLinkConnected_803EA2C.yaml
	thumb_func_start net_isLinkConnected_803EA2C
net_isLinkConnected_803EA2C:
	push {lr}
	mov r0, #0
	ldr r1, off_803EA3C // =eLinkState
	ldrb r1, [r1]
	cmp r1, #0xc
	bne locret_803EA3A
	mov r0, #1
locret_803EA3A:
	pop {pc}
	.balign 4, 0
off_803EA3C:
	.word eLinkState // eLinkState
	thumb_func_end net_isLinkConnected_803EA2C

	thumb_local_start
sub_803EA40:
	ldr r1, off_803EBF8 // =eStruct200BC30
	ldrb r0, [r1,#0x2] // (byte_200BC32 - 0x200bc30)
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end sub_803EA40

	thumb_local_start
sub_803EA48:
	ldr r1, off_803EBF8 // =eStruct200BC30
	strb r0, [r1,#0x2] // (byte_200BC32 - 0x200bc30)
	mov pc, lr
	.byte 0, 0
	thumb_func_end sub_803EA48

	thumb_func_start sub_803EA50
sub_803EA50:
	ldr r1, off_803EBF8 // =eStruct200BC30
	ldrb r0, [r1,#0x1] // (byte_200BC31 - 0x200bc30)
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end sub_803EA50

	thumb_func_start sub_803EA58
sub_803EA58:
	ldr r1, off_803EBF8 // =eStruct200BC30
	strb r0, [r1,#0x1] // (byte_200BC31 - 0x200bc30)
	mov pc, lr
	.byte 0, 0
	thumb_func_end sub_803EA58

// symdb: Returns the first byte of the record at EWRAM 0x200BC30, used as an index/offset (likely for a jump-table dispatch on that record).
// symdb: (void) -> u8 r0 (byte at eStruct200BC30[0]); also sets r1 = pointer to eStruct200BC30; lr is
// symdb: used as return (mov pc, lr), no flags guaranteed.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eStruct200BC30_getJumpOffset00.yaml
	thumb_func_start eStruct200BC30_getJumpOffset00
eStruct200BC30_getJumpOffset00:
	ldr r1, off_803EBF8 // =eStruct200BC30
	ldrb r0, [r1]
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end eStruct200BC30_getJumpOffset00

// symdb: Trivial wrapper that pushes lr, calls eStruct200BC30_getJumpOffset00, and returns straight to its own caller, passing results through unchanged.
// symdb: Next eStruct200BC30_getJumpOffset00_pushpop(void); inputs lr (return address), outputs r0, r1,
// symdb: lr (values produced by the callee)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eStruct200BC30_getJumpOffset00_pushpop.yaml
	thumb_func_start eStruct200BC30_getJumpOffset00_pushpop
eStruct200BC30_getJumpOffset00_pushpop:
	push {lr}
	bl eStruct200BC30_getJumpOffset00
	pop {pc}
	thumb_func_end eStruct200BC30_getJumpOffset00_pushpop

// symdb: Stores byte R0 into the "jump offset 00" field of the eStruct200BC30 control byte.
// symdb: void setJumpOffset00_803EA70(u8 value /* r0 */);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eStruct200BC30_setJumpOffset00.yaml
	thumb_func_start eStruct200BC30_setJumpOffset00
eStruct200BC30_setJumpOffset00:
	ldr r1, off_803EBF8 // =eStruct200BC30
	strb r0, [r1]
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end eStruct200BC30_setJumpOffset00

// symdb: Dispatches to one of three mode handlers indexed by a byte in the engine struct eStruct200BC30, preserving r4-r7 for the caller.
// symdb: void next_sub_803EA78(void) /* reads eStruct200BC30[0]; r5 = eStruct200BC30, r1 = off_803EA8C
// symdb: table base; clobbers r0-r3, r8-r12, lr, nzcv; returns via lr */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803EA78.yaml
	thumb_func_start sub_803EA78
sub_803EA78:
	push {r4-r7,lr}
	ldr r5, off_803EBF8 // =eStruct200BC30
	ldrb r0, [r5]
	ldr r1, off_803EA88 // =off_803EA8C
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803EA88:
	.word off_803EA8C
off_803EA8C:
	.word sub_803EA98+1
	.word sub_803EABC+1
	.word sub_803EAD0+1
	thumb_func_end sub_803EA78

	thumb_local_start
sub_803EA98:
	push {lr}
	bl battle_clearScratchBuffers_803EFCC
	ldr r0, off_803EAB8 // =eStruct200F360
	mov r1, #0x20
	bl ZeroFillByHalfword
	ldr r0, off_803EAB0 // =dword_200F444
	ldr r1, dword_803EAB4 // =0xa6c0
	str r1, [r0]
	pop {pc}
	.balign 4, 0
off_803EAB0:
	.word dword_200F444
dword_803EAB4:
	.word 0xA6C0
off_803EAB8:
	.word eStruct200F360
	thumb_func_end sub_803EA98

	thumb_local_start
sub_803EABC:
	push {lr}
	bl sub_8146CFC
	bl battle_clearScratchBuffers_803EFCC
	mov r0, #1
	bl sub_803EA58
	pop {pc}
	.byte 0, 0
	thumb_func_end sub_803EABC

	thumb_local_start
sub_803EAD0:
	push {lr}
	bl sub_8146CFC
	bl battle_clearScratchBuffers_803EFCC
	mov r0, #1
	bl sub_803EA58
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_803EAD0

// symdb: Dispatches based on the mode byte at the start of "eStruct200BC30" to one of three handlers (mode 0/1/2 -> sub_803EB04/sub_803EB14/sub_803EB60), forwarding the handler's full register/flag result to the caller and only restoring r4-r7.
// symdb: void Next_sub_803EAE4(void /* r4,r5,r6,r7 caller-saved; r0,r1,r2,r3,r8,r9,r10,r11,r12,lr,N,Z,C,V
// symdb: from caller */); // Returns whatever the selected handler returns in r0-r3, r8-r12, lr and the
// symdb: flags. // On entry: r5 = eStruct200BC30 (reloaded inside), the chosen handler sees r5->mode
// symdb: struct, r1 = off_803EAF8 table base, r0 = table[mode]. Only r4-r7 are popped back on exit.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803EAE4.yaml
	thumb_func_start sub_803EAE4
sub_803EAE4:
	push {r4-r7,lr}
	ldr r5, off_803EBF8 // =eStruct200BC30
	ldrb r0, [r5]
	ldr r1, off_803EAF4 // =off_803EAF8
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803EAF4:
	.word off_803EAF8
off_803EAF8:
	.word sub_803EB04+1
	.word sub_803EB14+1
	.word sub_803EB60+1
	thumb_func_end sub_803EAE4

// symdb: Thin dispatcher that calls sub_803DEB4 and, only when it returns 2, additionally calls sub_803ED1C.
// symdb: void sub_803EB04(void); /* uses r3 r4 r5 r6 r8 r9 r10 r11 r12 lr in; clobbers nz- c- v? r0 r1 r2
// symdb: r3 r8 r9 r10 r11 r12 lr; preserves r4 r5 r6 r7 */
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803EB04.yaml
	thumb_local_start
sub_803EB04:
	push {lr}
	bl battle_updateLinkState_803DEB4
	cmp r0, #2
	bne locret_803EB12
	bl sub_803ED1C
locret_803EB12:
	pop {pc}
	thumb_func_end sub_803EB04

	thumb_local_start
sub_803EB14:
	push {r4,lr}
	mov r4, #0
	bl dispatch_803C620 // () -> (u32?, bool)
	tst r1, r1
	bne loc_803EB2E
	tst r0, r0
	beq loc_803EB2E
	cmp r0, #2
	beq loc_803EB2C
	mov r0, #2
	strb r0, [r5,#0xe]
loc_803EB2C:
	mov r4, #4
loc_803EB2E:
	ldrb r0, [r5,#1]
	tst r0, r0
	bne loc_803EB3A
	bl sub_8146E78
	b loc_803EB46
loc_803EB3A:
	bl sub_8148884
	cmp r4, #4
	bne loc_803EB46
	mov r0, r4
	b locret_803EB5E
loc_803EB46:
	bl sub_803EBFC
	push {r0}
	bl sub_803EFA0
	pop {r0}
	beq locret_803EB5E
	bl eStruct200BC30_getRef
	mov r1, #8
	strb r1, [r0,#0xe]
	mov r0, #4
locret_803EB5E:
	pop {r4,pc}
	thumb_func_end sub_803EB14

	thumb_local_start
sub_803EB60:
	push {r4,lr}
	mov r4, #0
	bl dispatch_803C620 // () -> (u32?, bool)
	tst r1, r1
	bne loc_803EB7A
	tst r0, r0
	beq loc_803EB7A
	cmp r0, #2
	beq loc_803EB78
	mov r0, #2
	strb r0, [r5,#0xe]
loc_803EB78:
	mov r4, #4
loc_803EB7A:
	ldrb r0, [r5,#1]
	tst r0, r0
	bne loc_803EB86
	bl sub_8147B3C
	b loc_803EB92
loc_803EB86:
	bl sub_8148FC0
	cmp r4, #4
	bne loc_803EB92
	mov r0, r4
	b locret_803EBAA
loc_803EB92:
	bl sub_803EBFC
	push {r0}
	bl sub_803EFA0
	pop {r0}
	beq locret_803EBAA
	bl eStruct200BC30_getRef
	mov r1, #8
	strb r1, [r0,#0xe]
	mov r0, #4
locret_803EBAA:
	pop {r4,pc}
	thumb_func_end sub_803EB60

// symdb: Zero-fills the 0x20-byte work struct at 0x200BC30 (eStruct200BC30).
// symdb: void sub_803EBAC(void) — callers pass r2/r3 (which are preserved and pass through untouched);
// symdb: returns r1 as left by ZeroFillByWord, r2/r3 unchanged; clobbers r0, lr, flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/clearStruct200BC30_803EBAC.yaml
	thumb_func_start clearStruct200BC30_803EBAC
clearStruct200BC30_803EBAC:
	push {lr}
	// memBlock
	ldr r0, off_803EBF8 // =eStruct200BC30
	// size
	mov r1, #0x20
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end clearStruct200BC30_803EBAC

// symdb: Zero-fill the 32-byte field at offset 0x02 of eStruct200BC30.
// symdb: void sub_803EBB8(void);  // clobbers r0, r1, lr, flags NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_803EBB8.yaml
	thumb_func_start sub_803EBB8
sub_803EBB8:
	push {lr}
	ldr r0, off_803EBF8 // =eStruct200BC30
	mov r1, #2
	add r0, r0, r1
	mov r1, #0x20
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end sub_803EBB8

// symdb: Resets the linked-list head at dword_200B1B0 and reinitializes the 0x20-byte state struct at eStruct200BC30, likely at scene/subsystem startup.
// symdb: void sub_803EBC8(void) — takes nothing meaningful from callers (r2/r3 are pass-through and
// symdb: preserved untouched); returns with r2/r3 intact; clobbers r0, r1, flags, lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/resetAndInitStruct200BC30_803EBC8.yaml
	thumb_func_start resetAndInitStruct200BC30_803EBC8
resetAndInitStruct200BC30_803EBC8:
	push {lr}
	ldr r0, off_803EBE0 // =dword_200B1B0
	bl sub_803EF84
	// memBlock
	ldr r0, off_803EBF8 // =eStruct200BC30
	// size
	mov r1, #0x20
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	bl sub_803EF60
	pop {pc}
	.balign 4, 0
off_803EBE0:
	.word dword_200B1B0
	thumb_func_end resetAndInitStruct200BC30_803EBC8

	thumb_local_start
sub_803EBE4:
	ldr r1, off_803EBF8 // =eStruct200BC30
	strb r0, [r1,#0x5] // (eStruct200BC30_JumpOffset05 - 0x200bc30)
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end sub_803EBE4

	thumb_local_start
sub_803EBEC:
	ldr r1, off_803EBF8 // =eStruct200BC30
	ldrb r0, [r1,#0x5] // (eStruct200BC30_JumpOffset05 - 0x200bc30)
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end sub_803EBEC

	thumb_func_start eStruct200BC30_getRef
eStruct200BC30_getRef:
	ldr r0, off_803EBF8 // =eStruct200BC30
	mov pc, lr
off_803EBF8:
	.word eStruct200BC30
	thumb_func_end eStruct200BC30_getRef

	thumb_local_start
sub_803EBFC:
	push {r4-r7,lr}
	ldr r5, off_803EC18 // =eStruct200BC30
	ldr r0, off_803EC0C // =off_803EC10
	ldrb r1, [r5,#0x5] // (eStruct200BC30_JumpOffset05 - 0x200bc30)
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803EC0C:
	.word off_803EC10
off_803EC10:
	.word sub_803EC1C+1
	.word sub_803EC54+1
off_803EC18:
	.word eStruct200BC30
	thumb_func_end sub_803EBFC

	thumb_local_start
sub_803EC1C:
	push {r4-r7,lr}
	mov r7, #1
	mov r0, #0x10
	bl sub_803CB18
	beq loc_803EC50
	bl sub_803F3A8
	tst r0, r0
	bne loc_803EC34
	mov r0, #4
	strb r0, [r5,#5]
loc_803EC34:
	bl sub_803F06C
	tst r1, r1
	beq loc_803EC3C
loc_803EC3C:
	bl sub_803EF7C
	mov r1, r0
	ldr r0, dword_803ED18 // =0xfe
	strh r0, [r1]
	bl sub_803EF7C
	mov r1, #0x10
	bl sub_803F00C
loc_803EC50:
	mov r0, r7
	pop {r4-r7,pc}
	thumb_func_end sub_803EC1C

	thumb_local_start
sub_803EC54:
	push {r4-r7,lr}
	mov r7, #8
	bl sub_803F158
	strb r1, [r5,#9]
	tst r1, r1
	beq loc_803EC68
	cmp r1, #2
	beq loc_803EC7C
	b loc_803EC68
loc_803EC68:
	mov r7, #2
	bl sub_803E8DC
	mov r1, r0
	bl get_eLinkStateUnk38
	bl sub_803F118
	bl sub_803EFFC
loc_803EC7C:
	bl sub_803F3D8
	tst r0, r0
	beq loc_803ECA6
	cmp r0, #2
	bne loc_803ECA6
	mov r4, r2
	bl eStruct200BC30_getJumpOffset00
	cmp r0, #4
	bne loc_803EC9C
	tst r4, r4
	beq loc_803ECA6
	mov r0, #0x10
	orr r7, r0
	b loc_803ECEE
loc_803EC9C:
	tst r4, r4
	bne loc_803ECA6
	mov r0, #0x10
	orr r7, r0
	b loc_803ECEE
loc_803ECA6:
	bl sub_803F06C
	tst r1, r1
	beq loc_803ECBA
	cmp r1, #2
	bne loc_803ECB4
	b loc_803ECC6
loc_803ECB4:
	mov r0, #0x10
	orr r7, r0
	b loc_803ECF8
loc_803ECBA:
	ldrb r0, [r5,#9]
	cmp r0, #1
	bne loc_803ECC6
	mov r0, #0x10
	orr r7, r0
	b loc_803ECF8
loc_803ECC6:
	bl sub_803EF7C
	mov r4, r0
	bl sub_813D91C
	tst r0, r0
	bne loc_803ECDE
	ldrb r0, [r5,#7]
	add r0, #1
	strb r0, [r5,#7]
	strb r0, [r4,#1]
	b loc_803ECE6
loc_803ECDE:
	ldrb r0, [r5,#8]
	add r0, #1
	strb r0, [r5,#8]
	strb r0, [r4,#1]
loc_803ECE6:
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	mov r0, #0xfc
	strb r0, [r4]
loc_803ECEE:
	bl sub_803EF7C
	mov r1, #0x10
	bl sub_803F00C
loc_803ECF8:
	mov r0, r7
	pop {r4-r7,pc}
	thumb_func_end sub_803EC54

	thumb_func_start sub_803ECFC
sub_803ECFC:
	push {lr}
	bl sub_803EF7C
	mov r1, r0
	ldr r0, dword_803ED18 // =0xfe
	strh r0, [r1]
	bl sub_803EF7C
	mov r1, #0x10
	bl sub_803F00C
	pop {pc}
	.word dword_200B1B0
	.balign 4, 0
dword_803ED18:
	.word 0xFE
	thumb_func_end sub_803ECFC

	thumb_local_start
sub_803ED1C:
	push {r4-r7,lr}
	mov r7, r0
	ldr r5, off_803ED48 // =eStruct200BC30
	ldr r0, off_803ED3C // =off_803ED40
	ldrb r1, [r5,#0x5] // (eStruct200BC30_JumpOffset05 - 0x200bc30)
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0
	ldrb r1, [r5,#5]
	tst r1, r1
	bne loc_803ED38
	cmp r0, #4
	bne loc_803ED38
	mov r7, r0
loc_803ED38:
	mov r0, r7
	pop {r4-r7,pc}
	.balign 4, 0
off_803ED3C:
	.word off_803ED40
off_803ED40:
	.word sub_803ED4C+1
	.word sub_803EE98+1
off_803ED48:
	.word eStruct200BC30
	thumb_func_end sub_803ED1C

	thumb_local_start
sub_803ED4C:
	push {r4-r7,lr}
	ldr r5, off_803EE84 // =unk_2009480
	ldr r6, off_803EE88 // =eLinkState
	ldrb r7, [r6,#0x4] // (eCamera.pad_54 - 0x20099d0)
	mov r3, #2
	mov r0, #4
	mul r3, r0
	sub sp, sp, #0x14
	str r7, [sp]
	str r4, [sp,#4]
	str r5, [sp,#8]
	str r6, [sp,#0xc]
	str r3, [sp,#0x10]
	mov r4, #0
	mov r7, #0
loc_803ED6A:
	mov r0, r4
	bl sub_8144D04
	cmp r0, #1
	bne loc_803ED76
	add r7, #1
loc_803ED76:
	cmp r0, #0
	beq loc_803EE6A
	add r4, #1
	ldr r0, [sp]
	cmp r4, r0
	blt loc_803ED6A
	cmp r7, #2
	bne loc_803EE6A
	ldr r7, [sp]
	mov r4, r5
	mov r1, #0
	ldr r3, [sp,#0x10]
	mul r1, r3
loc_803ED90:
	mov r2, #0
loc_803ED92:
	mov r0, r2
	add r0, #1
	bl sub_803E78C
	beq loc_803EDA6
	ldrh r0, [r4,r1]
	cmp r0, #0x62
	beq loc_803EE60
	cmp r0, #0x60
	bne loc_803EE6A
loc_803EDA6:
	add r4, #2
	add r2, #1
	cmp r2, r7
	blt loc_803ED92
	mov r4, r5
	mov r1, #2
	ldr r3, [sp,#0x10]
	mul r1, r3
	mov r2, #0
loc_803EDB8:
	mov r0, r2
	add r0, #1
	bl sub_803E78C
	beq loc_803EDD6
	push {r1}
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	ldr r1, [r6,#0x1c] // (eCamera.pad_6A+2 - 0x20099d0)
	cmp r0, r1
	pop {r1}
	bne loc_803EE6A
loc_803EDD6:
	add r4, #2
	add r2, #1
	cmp r2, r7
	blt loc_803EDB8
	mov r4, r5
	mov r1, #4
	ldr r3, [sp,#0x10]
	mul r1, r3
	mov r0, r4
	bl sub_803E8B4
	mov r4, r0
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	str r0, [r6,#0x20] // (eCamera.unk_70 - 0x20099d0)
	ldr r1, dword_803EE8C // =0x800
	cmp r0, r1
	bne loc_803EE08

	ldr r0, off_803EE90 // =sSubmenu
	ldrb r0, [r0]

	cmp r0, #0xc
	bne loc_803EE6A
loc_803EE08:
	mov r4, r5
	mov r1, #1
	ldr r3, [sp,#0x10]
	mul r1, r3
	mov r0, r4
	bl sub_803E8B4
	mov r4, r0
	ldrh r0, [r4,r1]
	ldr r1, dword_803EE94 // =0x1000

	tst r0, r1
	beq loc_803EE28

	ldr r0, off_803EE90 // =sSubmenu
	ldrb r0, [r0]

	cmp r0, #0xc
	bne loc_803EE6A
loc_803EE28:
	mov r4, r5
	mov r1, #6
	ldr r3, [sp,#0x10]
	mul r1, r3
	mov r0, r4
	bl sub_803E8B4
	mov r4, r0
	ldrh r0, [r4,r1]
	add r1, r1, r3
	ldrh r1, [r4,r1]
	lsl r1, r1, #0x10
	orr r0, r1
	str r0, [r6,#0x40] // (dword_2009A10 - 0x20099d0)
	ldrb r0, [r6,#0x1] // (eCamera.unk_51 - 0x20099d0)
	add r0, #4
	strb r0, [r6,#0x1] // (eCamera.unk_51 - 0x20099d0)
	strb r0, [r6]
	mov r0, #2
	strh r0, [r6,#0xe] // (eCamera.pad_5E - 0x20099d0)
	mov r0, #0
	str r0, [r6,#0x30] // (eCamera.pad_78+8 - 0x20099d0)
	mov r0, #4
	bl sub_803EBE4
	add sp, sp, #0x14
	mov r0, #2
	pop {r4-r7,pc}
loc_803EE60:
	mov r0, #8
	strb r0, [r6]
	bl sub_803E89C
	b loc_803EDB8
loc_803EE6A:
	add sp, sp, #0x14
	mov r0, #2
	bl sub_803EA48
	mov r0, #4
	pop {r4-r7,pc}
	add sp, sp, #0x14
	mov r0, #8
	bl sub_803EA48
	mov r0, #4
	pop {r4-r7,pc}
	.balign 4, 0
off_803EE84:
	.word unk_2009480
off_803EE88:
	.word eLinkState // eLinkState
dword_803EE8C:
	.word 0x800
off_803EE90:
	.word sSubmenu
dword_803EE94:
	.word 0x1000
	thumb_func_end sub_803ED4C

	thumb_local_start
sub_803EE98:
	push {r4-r7,lr}
	sub sp, sp, #0x14
	ldr r6, off_803EF44 // =eLinkState
	ldr r5, off_803EF40 // =unk_2009480
	mov r0, #0
	str r0, [sp]
	str r0, [sp,#4]
	str r0, [sp,#8]
	str r7, [sp,#0xc]
	mov r1, #0
	mov r2, #4
loc_803EEAE:
	ldr r0, [sp]
	add r0, #1
	str r0, [sp]
	bl sub_803E78C
	beq loc_803EEC6
	cmp r2, #4
	bne loc_803EEC2
	str r1, [sp,#4]
	b loc_803EEC4
loc_803EEC2:
	str r1, [sp,#8]
loc_803EEC4:
	add r2, #4
loc_803EEC6:
	add r1, #2
	cmp r1, #8
	blt loc_803EEAE
	ldr r3, [r6,#0x38] // (eCamera.unk_88 - 0x20099d0)
	ldr r4, [r6,#0x3c] // (eCamera.unk_8C - 0x20099d0)
	ldr r7, [r6,#0x20] // (eCamera.unk_70 - 0x20099d0)
	mov r0, #2
	mov r1, #4
	mul r0, r1
loc_803EED8:
	ldr r1, [sp,#4]
	ldrh r2, [r5,r1]
	strh r2, [r3]
	ldr r1, [sp,#8]
	ldrh r2, [r5,r1]
	strh r2, [r4]
	add r5, r5, r0
	add r3, #2
	add r4, #2
	sub r7, #2
	bgt loc_803EED8
	ldr r0, [r6,#0x38] // (eCamera.unk_88 - 0x20099d0)
	ldrb r0, [r0]
	mov r1, #0xfc
	and r0, r1
	cmp r0, #0xfc
	bne loc_803EF00
	ldr r5, [r6,#0x38] // (eCamera.unk_88 - 0x20099d0)
	bl sub_803E828
loc_803EF00:
	ldr r0, [r6,#0x3c] // (eCamera.unk_8C - 0x20099d0)
	ldrb r0, [r0]
	mov r1, #0xfc
	and r0, r1
	cmp r0, #0xfc
	bne loc_803EF12
	ldr r5, [r6,#0x3c] // (eCamera.unk_8C - 0x20099d0)
	bl sub_803E850
loc_803EF12:
	bl sub_803EF7C
	mov r4, r0
	bl sub_8144D18
	strb r0, [r4,#0xe]
	bl sub_8144D24
	strb r0, [r4,#0xf]
	bl eStruct200BC30_getRef
	mov r1, r0
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_Held]
	lsr r0, r0, #8
	strb r0, [r4]
	ldrb r0, [r1,#7]
	add r0, #1
	strb r0, [r1,#7]
	strb r0, [r4,#1]
	add sp, sp, #0x14
	pop {r4-r7,pc}
	.balign 4, 0
off_803EF40:
	.word unk_2009480
off_803EF44:
	.word eLinkState // eLinkState
	thumb_func_end sub_803EE98

	thumb_local_start
sub_803EF48:
	push {r0-r2,lr}
	ldr r1, off_803EF5C // =eStruct200BC30
	ldrb r2, [r1,#0xd] // (byte_200BC3D - 0x200bc30)
	orr r2, r0
	strb r2, [r1,#0xd] // (byte_200BC3D - 0x200bc30)
	pop {r0-r2,pc}
	thumb_func_end sub_803EF48

	thumb_local_start
sub_803EF54:
	push {lr}
	ldr r1, off_803EF5C // =eStruct200BC30
	ldrb r0, [r1,#0xd] // (byte_200BC3D - 0x200bc30)
	pop {pc}
off_803EF5C:
	.word eStruct200BC30
	thumb_func_end sub_803EF54

// symdb: Calls sub_803EF7C to (re)initialize some state and then zero-fills the 0x100-byte buffer it returns.
// symdb: void clearStateBuffer256_803EF60(void) // takes nothing meaningful in r2/r3 (preserved through);
// symdb: clobbers r0/r1, returns garbage in r1
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803EF60.yaml
	thumb_func_start sub_803EF60
sub_803EF60:
	push {lr}
	bl sub_803EF7C
	ldr r1, off_803EF70 // =0x100
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	pop {pc}
	.balign 4, 0
off_803EF70:
	.word 0x100
	thumb_func_end sub_803EF60

// symdb: Trivial getter that returns the word at eLinkState+0x38 to link-related menu/object routines.
// symdb: () -> r0 = eLinkState[0x38]; flags not meaningful (mov pc, lr preserves none intentionally)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/get_eLinkStateUnk38.yaml
	thumb_func_start get_eLinkStateUnk38
get_eLinkStateUnk38:
	ldr r0, off_803EF8C // =eLinkState
	ldr r0, [r0,#0x38] // (eCamera.unk_88 - 0x20099d0)
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end get_eLinkStateUnk38

// symdb: Returns a single 32-bit field at offset 0x34 into the eCamera area (labeled eCamera.unk_84), apparently the camera's "end" value.
// symdb: uint32 sub_803EF7C(void)
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803EF7C.yaml
	thumb_func_start sub_803EF7C
sub_803EF7C:
	ldr r0, off_803EF8C // =eLinkState
	ldr r0, [r0,#0x34] // (eCamera.unk_84 - 0x20099d0)
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end sub_803EF7C

// symdb: Stores the passed value into the link-state camera field at eLinkState+0x34 (aliased as eCamera.unk_84), a one-instruction setter.
// symdb: void link_SetCameraValue(int value) // r0 = value; clobbers r1; no outputs
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803EF84.yaml
	thumb_local_start
sub_803EF84:
	ldr r1, off_803EF8C // =eLinkState
	str r0, [r1,#0x34] // (eCamera.unk_84 - 0x20099d0)
	mov pc, lr
	.balign 4, 0x00
off_803EF8C:
	.word eLinkState // eLinkState
	thumb_func_end sub_803EF84

	thumb_local_start
sub_803EF90:
	push {lr}
	ldr r0, off_803EF9C // =unk_200F380
	mov r1, #4
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	.balign 4, 0
off_803EF9C:
	.word unk_200F380
	thumb_func_end sub_803EF90

	thumb_local_start
sub_803EFA0:
	push {r4-r7,lr}
	mov r4, #1
	mov r7, #0
loc_803EFA6:
	ldr r1, off_803EFC4 // =word_2010420
	lsl r2, r7, #1
	add r1, r1, r2
	ldrh r0, [r1]
	ldr r2, off_803EFC8 // =0x168
	cmp r0, r2
	bge loc_803EFBC
	add r7, #1
	cmp r7, #4
	blt loc_803EFA6
	mov r4, #0
loc_803EFBC:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	.balign 4, 0
off_803EFC4:
	.word word_2010420
off_803EFC8:
	.word 0x168
	thumb_func_end sub_803EFA0

// symdb: Zeros four battle scratch/working buffers (0x20, 0x40, and two 0x200-byte blocks) via ZeroFillByWord.
// symdb: void battle_clearScratchBuffers_803EFCC(void) /* no inputs; preserves r2, r3, C, V; clobbers r0,
// symdb: r1, N, Z */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_clearScratchBuffers_803EFCC.yaml
	thumb_local_start
battle_clearScratchBuffers_803EFCC:
	push {lr}
	// memBlock
	ldr r0, off_803F268 // =byte_200AC20
	// size
	mov r1, #0x20
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	// memBlock
	ldr r0, off_803F260 // =unk_2009AC0
	// size
	mov r1, #0x40
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	// memBlock
	ldr r0, off_803F264 // =byte_200BC70
	// size
	ldr r1, off_803EFF8 // =0x200
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	// memBlock
	ldr r0, off_803F258 // =word_200A010
	// size
	ldr r1, off_803EFF8 // =0x200
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	.byte 0x0, 0x15, 0x0, 0x0, 0x0, 0x15, 0x0, 0x0
	.balign 4, 0
off_803EFF8:
	.word 0x200
	thumb_func_end battle_clearScratchBuffers_803EFCC

	thumb_local_start
sub_803EFFC:
	ldr r0, off_803F268 // =byte_200AC20
	mov r1, #1
	strb r1, [r0,#0x7] // (byte_200AC27 - 0x200ac20)
	mov pc, lr
	thumb_func_end sub_803EFFC

	thumb_local_start
sub_803F004:
	ldr r1, off_803F268 // =byte_200AC20
	ldrb r0, [r1,#0x7] // (byte_200AC27 - 0x200ac20)
	tst r0, r0
	mov pc, lr
	thumb_func_end sub_803F004

	thumb_local_start
sub_803F00C:
	push {r4-r7,lr}
	mov r7, r1
	ldr r1, off_803F260 // =unk_2009AC0
	ldr r5, off_803F268 // =byte_200AC20
	ldrb r4, [r5]
	mov r2, #0x40
	mul r2, r4
	add r1, r1, r2
	mov r6, r1
	mov r2, r7
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	add r4, #1
	mov r0, #7
	and r4, r0
	strb r4, [r5]
	pop {r4-r7,pc}
	.byte 0, 0
	thumb_func_end sub_803F00C

	thumb_func_start sub_803F030
sub_803F030:
	push {r4-r7,lr}
	mov r6, r0
	mov r7, r1
	ldr r3, off_803F268 // =byte_200AC20
	ldrb r4, [r3,#0x2] // (byte_200AC22 - 0x200ac20)
	ldrb r5, [r3]
	cmp r5, r4
	bne loc_803F044
	mov r1, #1
	b loc_803F058
loc_803F044:
	ldr r1, off_803F260 // =unk_2009AC0
	mov r2, #0x40
	mul r2, r4
	add r1, r1, r2
	mov r0, r1
	mov r1, r6
	mov r2, r7
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	mov r1, #0
loc_803F058:
	mov r0, r1
	pop {r4-r7,pc}
	thumb_func_end sub_803F030

	thumb_func_start sub_803F05C
sub_803F05C:
	push {r5,lr}
	ldr r5, off_803F268 // =byte_200AC20
	ldrb r0, [r5,#0x2] // (byte_200AC22 - 0x200ac20)
	add r0, #1
	mov r1, #7
	and r0, r1
	strb r0, [r5,#0x2] // (byte_200AC22 - 0x200ac20)
	pop {r5,pc}
	thumb_func_end sub_803F05C

	thumb_local_start
sub_803F06C:
	push {r5,lr}
	mov r3, #0
	ldr r5, off_803F268 // =byte_200AC20
	ldrb r0, [r5]
	ldrb r1, [r5,#0x2] // (byte_200AC22 - 0x200ac20)
	sub r0, r0, r1
	bgt loc_803F084
	bne loc_803F080
	mov r3, #2
	b loc_803F08A
loc_803F080:
	mov r1, #8
	add r0, r0, r1
loc_803F084:
	cmp r0, #2
	blt loc_803F08A
	mov r3, #1
loc_803F08A:
	mov r1, r3
	pop {r5,pc}
	.byte 0, 0
	thumb_func_end sub_803F06C

	thumb_local_start
sub_803F090:
	push {r5,lr}
	ldr r0, off_803F260 // =unk_2009AC0
	ldr r5, off_803F268 // =byte_200AC20
	ldrb r1, [r5]
	ldrb r2, [r5,#0x2] // (byte_200AC22 - 0x200ac20)
	sub r2, #1
	mov r1, #7
	and r2, r1
	strb r2, [r5,#0x2] // (byte_200AC22 - 0x200ac20)
	pop {r5,pc}
	thumb_func_end sub_803F090

	thumb_local_start
sub_803F0A4:
	push {r4-r7,lr}
	mov r7, r0
	mov r6, r1
	mov r5, r2
	ldrb r1, [r0]
	tst r1, r1
	beq loc_803F0B8
	ldrb r1, [r0,#0xc]
	tst r1, r1
	bne loc_803F0C2
loc_803F0B8:
	push {r0}
	mov r0, #1
	bl sub_803EF48
	pop {r0}
loc_803F0C2:
	mov r1, r3
	ldrb r4, [r5,#3]
	mov r2, #0x40
	mul r2, r4
	add r1, r1, r2
	mov r2, r6
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	add r4, #1
	mov r1, #7
	and r4, r1
	strb r4, [r5,#3]
	ldrh r0, [r5,#8]
	add r0, #1
	strh r0, [r5,#8]
	pop {r4-r7,pc}
	.balign 4, 0x00
	.word 0xFE
	thumb_func_end sub_803F0A4

	thumb_local_start
sub_803F0E8:
	push {r4-r7,lr}
	mov r7, r1
	ldr r5, off_803F268 // =byte_200AC20
	ldrb r4, [r5,#0x3] // (byte_200AC23 - 0x200ac20)
	mov r6, r4
	mov r2, #0x40
	mul r6, r2
	ldr r2, off_803F264 // =byte_200BC70
	add r6, r6, r2
	mov r1, r6
	mov r2, #0xc
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	mov r0, r7
	mov r1, r6
	add r1, #0xc
	mov r2, #0xc
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	add r4, #1
	mov r1, #7
	and r4, r1
	strb r4, [r5,#0x3] // (byte_200AC23 - 0x200ac20)
	pop {r4-r7,pc}
	thumb_func_end sub_803F0E8

	thumb_local_start
sub_803F118:
	push {r4-r7,lr}
	mov r6, r1
	mov r7, r0
	ldr r0, off_803F264 // =byte_200BC70
	ldr r5, off_803F268 // =byte_200AC20
	ldrb r4, [r5,#0x1] // (byte_200AC21 - 0x200ac20)
	mov r2, #0x40
	mul r2, r4
	add r0, r0, r2
	add r0, #0
	mov r1, r7
	mov r2, r6
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	add r7, #0x10
	ldr r0, off_803F264 // =byte_200BC70
	ldr r5, off_803F268 // =byte_200AC20
	ldrb r4, [r5,#0x1] // (byte_200AC21 - 0x200ac20)
	mov r2, #0x40
	mul r2, r4
	add r0, r0, r2
	add r0, #0xc
	mov r1, r7
	mov r2, r6
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	add r4, #1
	mov r1, #7
	and r4, r1
	strb r4, [r5,#0x1] // (byte_200AC21 - 0x200ac20)
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_803F118

	thumb_local_start
sub_803F158:
	push {r5,lr}
	mov r3, #0
	ldr r5, off_803F268 // =byte_200AC20
	ldrb r0, [r5,#0x3] // (byte_200AC23 - 0x200ac20)
	ldrb r1, [r5,#0x1] // (byte_200AC21 - 0x200ac20)
	sub r0, r0, r1
	bgt loc_803F170
	bne loc_803F16C
	mov r3, #2
	b loc_803F176
loc_803F16C:
	mov r1, #8
	add r0, r0, r1
loc_803F170:
	cmp r0, #6
	blt loc_803F176
	mov r3, #1
loc_803F176:
	mov r1, r3
	pop {r5,pc}
	.balign 4, 0x00
	thumb_func_end sub_803F158

	thumb_local_start
sub_803F17C:
	push {r4-r7,lr}
	mov r7, #0x20
	mov r6, r0
	mov r2, #0
loc_803F184:
	ldrb r1, [r0,r2]
	tst r1, r1
	beq loc_803F1B8
	ldrb r1, [r0,r2]
	ldr r3, dword_803F1BC // =0xfe
	cmp r1, r3
	bne loc_803F19A
	add r2, #0xc
	cmp r2, #0xc
	ble loc_803F184
	b loc_803F1B8
loc_803F19A:
	mov r7, #0
	ldr r1, off_803F258 // =word_200A010
	ldr r5, off_803F25C // =unk_200AC30
	ldrb r4, [r5,#0x3] // (byte_200AC33 - 0x200ac30)
	sub r4, #1
	mov r2, #7
	and r4, r2
	mov r2, #0x40
	mul r4, r2
	add r4, r4, r1
	mov r0, r6
	mov r1, r4
	bl sub_803F1C0
	mov r7, r0
loc_803F1B8:
	mov r0, r7
	pop {r4-r7,pc}
	.balign 4, 0
dword_803F1BC:
	.word 0xFE
	thumb_func_end sub_803F17C

	thumb_local_start
sub_803F1C0:
	push {r4-r7,lr}
	mov r7, #0
	mov r6, r0
	mov r4, r1
	mov r5, #0
	mov r2, #0
	add r2, #1
loc_803F1CE:
	ldrb r0, [r4,r2]
	ldrb r1, [r6,r2]
	add r0, #1
	mov r3, #0xff
	and r0, r3
	cmp r0, r1
	beq loc_803F1F2
	sub r0, #1
	and r0, r3
	cmp r0, r1
	bne loc_803F1EC
	mov r0, #4
	lsl r0, r5
	orr r7, r0
	b loc_803F1F2
loc_803F1EC:
	mov r0, #1
	lsl r0, r5
	orr r7, r0
loc_803F1F2:
	add r5, #1
	add r2, #0xc
	cmp r2, #0xd
	ble loc_803F1CE
	mov r2, #0
	add r2, #1
	ldrb r0, [r6,r2]
	mov r2, #0xc
	add r2, #1
	ldrb r1, [r6,r2]
	cmp r0, r1
	beq loc_803F20E
	mov r0, #0x10
	orr r7, r0
loc_803F20E:
	mov r0, r7
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_803F1C0

	thumb_local_start
sub_803F214:
	push {r4-r7,lr}
	mov r6, r0
	mov r7, r1
	tst r2, r2
	beq loc_803F230
	mov r1, #1
	add r1, #0xc
	ldrb r0, [r7,r1]
	mov r1, #1
	add r1, #0
	ldrb r1, [r6,r1]
	sub r0, r0, r1
	beq loc_803F240
	b loc_803F244
loc_803F230:
	mov r1, #1
	add r1, #0
	ldrb r0, [r7,r1]
	mov r1, #1
	add r1, #0xc
	ldrb r1, [r6,r1]
	sub r0, r0, r1
	bne loc_803F244
loc_803F240:
	mov r0, #0
	b locret_803F254
loc_803F244:
	blt loc_803F24A
loc_803F246:
	mov r0, #1
	b locret_803F254
loc_803F24A:
	mov r1, #0xff
	and r0, r1
	cmp r0, #7
	blt loc_803F246
	mov r0, #2
locret_803F254:
	pop {r4-r7,pc}
	.balign 4, 0
off_803F258:
	.word word_200A010
off_803F25C:
	.word unk_200AC30
off_803F260:
	.word unk_2009AC0
off_803F264:
	.word byte_200BC70
off_803F268:
	.word byte_200AC20
	thumb_func_end sub_803F214

	thumb_local_start
sub_803F26C:
	push {r4-r7,lr}
	mov r7, r0
	mov r4, r2
	ldr r5, off_803F4B8 // =unk_200AC30
	ldrb r0, [r5,#0x4] // (byte_200AC34 - 0x200ac30)
	tst r0, r0
	beq loc_803F31A
	bl sub_803F460
	tst r0, r0
	bne locret_803F322
	ldrb r6, [r5,#0x5] // (byte_200AC35 - 0x200ac30)
	mov r1, #0x40
	mul r6, r1
	ldr r1, off_803F4B4 // =word_200A010
	add r6, r6, r1
	ldr r0, off_803F4C4 // =byte_200AC20
	ldrb r0, [r0,#0x3] // (byte_200AC23 - 0x200ac20)
	sub r0, #1
	mov r1, #7
	and r0, r1
	mov r1, #0x40
	mul r0, r1
	ldr r1, off_803F4C0 // =byte_200BC70
	add r1, r1, r0
	mov r4, #0
	mov r0, r6
	bl sub_803F1C0
	mov r1, #5
	and r1, r0
	beq loc_803F2AE
	mov r4, #1
loc_803F2AE:
	mov r0, r7
	mov r1, r6
	mov r2, r4
	bl sub_803F214
	tst r0, r0
	bne loc_803F2F6
	tst r4, r4
	beq loc_803F2CA
	mov r0, #0
	add r0, r0, r7
	mov r1, #0xc
	add r1, r1, r6
	b loc_803F2D2
loc_803F2CA:
	mov r0, #0
	add r0, r0, r6
	mov r1, #0xc
	add r1, r1, r7
loc_803F2D2:
	bl sub_803F0E8
	mov r1, #1
	add r1, #0
	ldrb r0, [r7,r1]
	mov r1, #1
	add r1, #0xc
	ldrb r1, [r7,r1]
	cmp r0, r1
	bne loc_803F2EA
	bl sub_803F324
loc_803F2EA:
	ldrb r0, [r5,#0x5] // (byte_200AC35 - 0x200ac30)
	add r0, #1
	mov r1, #7
	and r0, r1
	strb r0, [r5,#0x5] // (byte_200AC35 - 0x200ac30)
	b locret_803F322
loc_803F2F6:
	ldrb r0, [r5,#0x3] // (byte_200AC33 - 0x200ac30)
	sub r0, #1
	mov r1, #7
	and r0, r1
	mov r4, r0
	mov r1, #0x40
	mul r0, r1
	ldr r1, off_803F4B4 // =word_200A010
	add r0, r0, r1
	mov r1, r7
	bl sub_803F1C0
	mov r1, #0xc
	and r1, r0
	cmp r1, #0xc
	bne loc_803F318
	strb r4, [r5,#0x3] // (byte_200AC33 - 0x200ac30)
loc_803F318:
	b locret_803F322
loc_803F31A:
	ldrb r0, [r5,#0x3] // (byte_200AC33 - 0x200ac30)
	strb r0, [r5,#0x5] // (byte_200AC35 - 0x200ac30)
	mov r0, #1
	strb r0, [r5,#0x4] // (byte_200AC34 - 0x200ac30)
locret_803F322:
	pop {r4-r7,pc}
	thumb_func_end sub_803F26C

	thumb_local_start
sub_803F324:
	ldr r1, off_803F4B8 // =unk_200AC30
	ldrb r0, [r1,#0x4] // (byte_200AC34 - 0x200ac30)
	tst r0, r0
	beq locret_803F330
	mov r0, #0
	strb r0, [r1,#0x4] // (byte_200AC34 - 0x200ac30)
locret_803F330:
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end sub_803F324

	thumb_func_start sub_803F334
sub_803F334:
	push {r4-r7,lr}
	mov r7, r0
	mov r6, r1
	bl sub_803F17C
	tst r0, r0
	bne loc_803F360
	mov r0, r7
	mov r1, r6
	ldr r2, off_803F4C4 // =byte_200AC20
	ldr r3, off_803F4C0 // =byte_200BC70
	bl sub_803F0A4
	mov r0, r7
	mov r1, r6
	ldr r2, off_803F4B8 // =unk_200AC30
	ldr r3, off_803F4B4 // =word_200A010
	bl sub_803F0A4
	bl sub_803F324
	b locret_803F3A6
loc_803F360:
	mov r1, #0x1c
	and r1, r0
	tst r1, r1
	beq loc_803F37C
	mov r0, r7
	bl sub_803F26C
	mov r0, r7
	mov r1, r6
	ldr r2, off_803F4B8 // =unk_200AC30
	ldr r3, off_803F4B4 // =word_200A010
	bl sub_803F0A4
	b locret_803F3A6
loc_803F37C:
	mov r1, #3
	and r1, r0
	beq loc_803F39A
	push {r0}
	mov r0, #2
	bl sub_803EF48
	pop {r0}
	mov r0, r7
	mov r1, r6
	ldr r2, off_803F4B8 // =unk_200AC30
	ldr r3, off_803F4B4 // =word_200A010
	bl sub_803F0A4
	b locret_803F3A6
loc_803F39A:
	mov r0, r7
	mov r1, r6
	ldr r2, off_803F4B8 // =unk_200AC30
	ldr r3, off_803F4B4 // =word_200A010
	bl sub_803F0A4
locret_803F3A6:
	pop {r4-r7,pc}
	thumb_func_end sub_803F334

	thumb_local_start
sub_803F3A8:
	push {r4-r7,lr}
	ldr r0, off_803F4B4 // =word_200A010
	ldr r5, off_803F4B8 // =unk_200AC30
	ldrb r4, [r5,#0x3] // (byte_200AC33 - 0x200ac30)
	mov r2, #0x40
	mul r2, r4
	add r0, r0, r2
	mov r7, #0
	mov r3, r0
	mov r4, #1
loc_803F3BC:
	mov r0, #0xc
	mul r0, r7
	ldrh r1, [r3,r0]
	ldr r2, dword_803F3D4 // =0xfe
	cmp r1, r2
	bne loc_803F3D0
	add r7, #1
	cmp r7, #2
	blt loc_803F3BC
	mov r4, #0
loc_803F3D0:
	mov r0, r4
	pop {r4-r7,pc}
	.balign 4, 0
dword_803F3D4:
	.word 0xFE
	thumb_func_end sub_803F3A8

	thumb_local_start
sub_803F3D8:
	push {r4-r7,lr}
	mov r4, #0
	ldr r5, off_803F4B8 // =unk_200AC30
	ldrb r0, [r5,#0x4] // (byte_200AC34 - 0x200ac30)
	tst r0, r0
	beq loc_803F45C
	mov r4, #1
	ldrb r0, [r5,#0x5] // (byte_200AC35 - 0x200ac30)
	ldrb r1, [r5,#0x3] // (byte_200AC33 - 0x200ac30)
	sub r1, r1, r0
	bge loc_803F3F0
	add r1, #8
loc_803F3F0:
	cmp r1, #3
	blt loc_803F45C
	push {r1}
	ldr r0, off_803F4B4 // =word_200A010
	ldrb r6, [r5,#0x5] // (byte_200AC35 - 0x200ac30)
	mov r2, #0x40
	mul r6, r2
	add r6, r6, r0
	ldr r0, off_803F4C4 // =byte_200AC20
	ldrb r7, [r0,#0x1] // (byte_200AC21 - 0x200ac20)
	sub r7, #1
	mov r1, #7
	and r7, r1
	mov r1, #0x40
	mul r7, r1
	ldr r1, off_803F4C0 // =byte_200BC70
	add r7, r7, r1
	mov r1, #1
	add r1, #0
	ldrb r0, [r7,r1]
	add r0, #1
	mov r1, #0xff
	and r0, r1
	mov r2, #1
	mov r3, #1
	add r3, #0
	ldrb r1, [r6,r3]
	cmp r0, r1
	beq loc_803F42C
	mov r2, #0
loc_803F42C:
	ldr r0, off_803F4B4 // =word_200A010
	ldrb r6, [r5,#0x3] // (byte_200AC33 - 0x200ac30)
	sub r6, #1
	mov r1, #7
	and r6, r1
	mov r1, #0x40
	mul r6, r1
	add r6, r6, r0
	mov r3, #1
	add r3, #0
	ldrb r0, [r6,r3]
	mov r3, #1
	add r3, #0xc
	ldrb r1, [r6,r3]
	sub r0, r0, r1
	bge loc_803F450
	mvn r0, r0
	add r0, #1
loc_803F450:
	cmp r0, #1
	pop {r1}
	bne loc_803F45A
	mov r4, #1
	b loc_803F45C
loc_803F45A:
	mov r4, #2
loc_803F45C:
	mov r0, r4
	pop {r4-r7,pc}
	thumb_func_end sub_803F3D8

	thumb_local_start
sub_803F460:
	push {r4-r7,lr}
loc_803F462:
	ldrb r6, [r5,#5]
	mov r1, #0x40
	mul r6, r1
	ldr r1, off_803F4B4 // =word_200A010
	add r6, r6, r1
	ldr r0, off_803F4C4 // =byte_200AC20
	ldrb r7, [r0,#0x3] // (byte_200AC23 - 0x200ac20)
	sub r7, #1
	mov r1, #7
	and r7, r1
	mov r1, #0x40
	mul r7, r1
	ldr r1, off_803F4C0 // =byte_200BC70
	add r7, r7, r1
	ldrb r0, [r6,#1]
	ldrb r1, [r7,#1]
	add r1, #1
	mov r2, #0xff
	and r1, r2
	cmp r0, r1
	beq loc_803F4B0
	ldrb r0, [r6,#0xd]
	ldrb r1, [r7,#0xd]
	add r1, #1
	mov r2, #0xff
	and r1, r2
	cmp r0, r1
	beq loc_803F4B0
	ldrb r0, [r5,#5]
	add r0, #1
	mov r1, #7
	and r0, r1
	ldrb r1, [r5,#3]
	cmp r0, r1
	bne loc_803F4AC
	mov r0, #1
	b locret_803F4B2
loc_803F4AC:
	strb r0, [r5,#5]
	b loc_803F462
loc_803F4B0:
	mov r0, #0
locret_803F4B2:
	pop {r4-r7,pc}
	.balign 4, 0
off_803F4B4:
	.word word_200A010
off_803F4B8:
	.word unk_200AC30
	.word unk_2009AC0
off_803F4C0:
	.word byte_200BC70
off_803F4C4:
	.word byte_200AC20
	thumb_func_end sub_803F460

// symdb: Zeroes a 4-byte field at IWRAM 0x200AD04 by delegating to ZeroFillByByte.
// symdb: void clear_e200AD04(void); // in: r2 (must be preserved through the call), lr; out: r2
// symdb: preserved, r0/r1/lr and NZCV flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/clear_e200AD04.yaml
	thumb_func_start clear_e200AD04
clear_e200AD04: // () -> ()
	push {lr}

	ldr r0, off_803F55C // =word_200AD04
	mov r1, #4
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()

	pop {pc}
	thumb_func_end clear_e200AD04

	thumb_local_start
sub_803F4D4:
	push {lr}
	mov r2, #0
	ldr r0, off_803F55C // =word_200AD04
	ldrb r1, [r0,#0x1] // (byte_200AD05 - 0x200ad04)
	tst r1, r1
	beq loc_803F4E6
	ldrb r1, [r0]
	tst r1, r1
	bne loc_803F4E8
loc_803F4E6:
	mov r2, #1
loc_803F4E8:
	tst r2, r2
	pop {pc}
	thumb_func_end sub_803F4D4

// symdb: Writes the byte passed in r0 to the global IWRAM variable word_200AD04 and returns that variable's address in r1.
// symdb: void setByte_200AD04(u8 value); /* r0 = value; returns r1 = &word_200AD04; lr clobbered (uses lr
// symdb: as return) */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/setByte_200AD04_803F4EC.yaml
	thumb_func_start setByte_200AD04_803F4EC
setByte_200AD04_803F4EC:
	push {lr}
	ldr r1, off_803F55C // =word_200AD04
	strb r0, [r1]
	pop {pc}
	thumb_func_end setByte_200AD04_803F4EC

	thumb_local_start
sub_803F4F4:
	push {lr}
	ldr r1, off_803F55C // =word_200AD04
	mov r0, #1
	strb r0, [r1,#0x1] // (byte_200AD05 - 0x200ad04)
	pop {pc}
	.byte 0, 0
	thumb_func_end sub_803F4F4

// symdb: Writes the constant 0xB4 (180, likely a frame count of 3 seconds) into the halfword at 0x200AD06, probably (re)starting or resetting a global timer.
// symdb: void setTimerTo180Frames(void)
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803F500.yaml
	thumb_func_start sub_803F500
sub_803F500:
	push {lr}
	ldr r1, off_803F55C // =word_200AD04
	mov r0, #0xb4
	strh r0, [r1,#0x2] // (word_200AD06 - 0x200ad04)
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_803F500

	thumb_local_start
sub_803F50C:
	push {lr}
	ldr r0, off_803F520 // =0x78
	b loc_803F516
loc_803F512:
	push {lr}
	ldr r0, off_803F51C // =0xf0
loc_803F516:
	ldr r1, off_803F55C // =word_200AD04
	strh r0, [r1,#0x2] // (word_200AD06 - 0x200ad04)
	pop {pc}
	.balign 4, 0
off_803F51C:
	.word 0xF0
off_803F520:
	.word 0x78
	thumb_func_end sub_803F50C

// symdb: Loads the event/state byte at 0x200AD04 and returns it with NZ flags set, so callers can branch on "is this flag/counter non-zero".
// symdb: u8 event_checkByte200AD04(void) // in: lr; out: r0 = byte value, r1 = &0x200AD04, NZ flags from
// symdb: the byte
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/notZero_eByte200AD04.yaml
	thumb_func_start notZero_eByte200AD04
notZero_eByte200AD04:
	push {lr}
	ldr r1, off_803F55C // =word_200AD04
	ldrb r0, [r1]
	tst r0, r0
	pop {pc}
	.byte 0, 0
	thumb_func_end notZero_eByte200AD04

// symdb: Per-tick countdown gate — while a flag byte at 200AD04 is set, checks a condition each tick and decrements a halfword counter at 200AD06, clearing the flag when the count runs out.
// symdb: void sub_803F530(void); returns condition via flags: Z set = countdown finished or inactive, Z
// symdb: clear = still counting (r6==1 internally)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/tickCountdownGate_803F530.yaml
	thumb_func_start tickCountdownGate_803F530
tickCountdownGate_803F530:
	push {r4,r6,lr}
	mov r6, #0
	bl notZero_eByte200AD04
	beq loc_803F558
	mov r4, #1
	bl battle_getLinkStateCode_803F560
	beq loc_803F552
	mov r4, #0
	mov r6, #1
	ldr r1, off_803F55C // =word_200AD04
	ldrh r0, [r1,#0x2] // (word_200AD06 - 0x200ad04)
	sub r0, #1
	strh r0, [r1,#0x2] // (word_200AD06 - 0x200ad04)
	bne loc_803F558
	mov r6, #0
loc_803F552:
	mov r0, r4
	bl setByte_200AD04_803F4EC
loc_803F558:
	tst r6, r6
	pop {r4,r6,pc}
	.balign 4, 0
off_803F55C:
	.word word_200AD04
	thumb_func_end tickCountdownGate_803F530

// symdb: Returns a link-battle state code (0xFF, 0x80 or 0) by checking the current battle mode and, in mode 2, polling the link partner and the four link slots.
// symdb: u32 battle_getLinkStateCode_803F560(void); /* out r0 = code (0xFF/0x80/0), out r1 = path-
// symdb: dependent (partner value, leftover, or 0); N/Z set from r0, C=V=0; r4-r7 preserved */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getLinkStateCode_803F560.yaml
	thumb_func_start battle_getLinkStateCode_803F560
battle_getLinkStateCode_803F560:
	push {r4,r6,r7,lr}
	mov r6, #0xff
	bl battle_updateLinkState_803DEB4
	cmp r0, #2
	beq loc_803F574
	cmp r0, #4
	beq loc_803F5A6
	mov r6, #0x80
	b loc_803F5A6
loc_803F574:
	mov r0, #0
	mov r1, #1
	bl sub_813DB24
	cmp r0, #0xff
	bne loc_803F586
	mov r1, r2
	mov r0, #1
	b loc_803F5A6
loc_803F586:
	mov r7, #0
loc_803F588:
	mov r0, r7
	bl sub_8144D04
	cmp r0, #2
	bne loc_803F59C
	cmp r7, #1
	beq loc_803F59A
	cmp r7, #3
	bne loc_803F59C
loc_803F59A:
	mov r6, #0
loc_803F59C:
	add r4, #1
	add r7, #1
	cmp r7, #4
	blt loc_803F588
	mov r1, #0
loc_803F5A6:
	mov r0, r6
	tst r0, r0
	pop {r4,r6,r7,pc}
	.word eLinkState // eLinkState
	thumb_func_end battle_getLinkStateCode_803F560

	thumb_local_start
sub_803F5B0:
	push {r4,lr}
	ldrb r2, [r5,#0xc]
	mov r1, #8
	tst r2, r1
	beq locret_803F5F2
	ldrb r0, [r5,#0xc]
	mov r1, #0x10
	tst r0, r1
	bne locret_803F5F2
	mov r0, #0x40
	ldrh r0, [r5,r0]
	ldr r1, off_803F5F4 // =byte_803F5FC
	mov r2, #0
loc_803F5CA:
	ldrh r3, [r1,r2]
	cmp r3, r0
	beq loc_803F5DA
	add r2, #2
	cmp r2, #0x1a
	blt loc_803F5CA
	mov r0, #0xff
	b locret_803F5F2
loc_803F5DA:
	ldr r1, dword_803F5F8 // =0x127
	sub r0, r3, r1
	ldrh r1, [r5,#0x3e]
	cmp r0, r1
	beq locret_803F5F2
	strh r0, [r5,#0x3e]
	ldrb r1, [r5,#0xc]
	mov r2, #0x10
	orr r1, r2
	strb r1, [r5,#0xc]
	mov r1, #0x1e
	strh r1, [r5,#0x3c]
locret_803F5F2:
	pop {r4,pc}
	.balign 4, 0
off_803F5F4:
	.word byte_803F5FC
dword_803F5F8:
	.word 0x127
byte_803F5FC:
	.byte 0x27, 0x1, 0x28, 0x1, 0x29, 0x1, 0x2A, 0x1, 0x2B, 0x1, 0x2C
	.byte 0x1, 0x2D, 0x1, 0x2E, 0x1, 0x2F, 0x1, 0x30, 0x1, 0x31, 0x1
	.byte 0x32, 0x1, 0x33, 0x1, 0x0, 0x0
	thumb_func_end sub_803F5B0

	thumb_func_start sub_803F618
sub_803F618:
	push {r0-r7,lr}
	ldr r4, byte_803F774+4 // =0x40
	mov r3, #4
	lsl r3, r3, #1
	mul r2, r3
	lsl r1, r1, #1
	add r1, r1, r2
	strh r0, [r4,r1]
	pop {r0-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_803F618

	thumb_local_start
sub_803F62C:
	push {lr}
	mov r0, #0
	mov r1, #0xd
loc_803F632:
	ldrb r2, [r5,r1]
	cmp r2, #1
	bne loc_803F63A
	add r0, #1
loc_803F63A:
	add r1, #1
	cmp r1, #0x10
	ble loc_803F632
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_803F62C

	thumb_func_start sub_803F644
sub_803F644:
	push {r4,lr}
	bl sub_803F664
	ldr r4, dword_803F660 // =0xa6c0
	cmp r0, r4
	beq locret_803F65C
	cmp r1, r4
	beq locret_803F65C
	cmp r2, r4
	beq locret_803F65C
	cmp r3, r4
	beq locret_803F65C
locret_803F65C:
	pop {r4,pc}
	.balign 4, 0
dword_803F660:
	.word 0xA6C0
	thumb_func_end sub_803F644

	thumb_local_start
sub_803F664:
	push {r7,lr}
	ldr r7, byte_803F774+8 // =0x40
	ldrh r0, [r7]
	ldrh r1, [r7,#0x2] // (byte_2009940+2 - 0x2009940)
	ldrh r2, [r7,#0x4] // (byte_2009940+4 - 0x2009940)
	ldrh r3, [r7,#0x6] // (byte_2009940+6 - 0x2009940)
	pop {r7,pc}
	.byte 0x0, 0x0
	thumb_func_end sub_803F664

	thumb_func_start sub_803F674
sub_803F674:
	push {r4-r7,lr}
	ldr r7, off_803F6AC // =eLinkState
	ldr r0, [r7,#0x48] // (dword_2009A18 - 0x20099d0)
	mov r1, #0x1c
	and r0, r1
	lsr r0, r0, #2
	mov r6, r0
	mov r4, #0
	mov r5, #0
	mov r7, #0
loc_803F688:
	cmp r7, r6
	beq loc_803F6A4
	mov r0, r7
	bl sub_8144D04
	cmp r0, #2
	beq loc_803F69E
	cmp r0, #1
	bne loc_803F6A0
	add r4, #1
	b loc_803F6A0
loc_803F69E:
	add r5, #1
loc_803F6A0:
	add r7, #1
	b loc_803F688
loc_803F6A4:
	mov r0, r4
	mov r1, r5
	pop {r4-r7,pc}
	.balign 4, 0
off_803F6AC:
	.word eLinkState // eLinkState
	thumb_func_end sub_803F674

// symdb: Reset eLink/battle state blocks and zero-fill related battle buffers when a fresh battle (or battle-equivalent screen) begins.
// symdb: (r0 = battle-context selector 0..N, r10 = Toolkit) -> r0 = 1 (the flag set) ; side effects:
// symdb: zeroes eStruct200F360, resets eLinkState+side buffers, queues a sub_8144240 call, initialises
// symdb: camera state, initialises the BRE5 magic block, sets Camera.unk_0C = 0x3C, sets event flag
// symdb: 0x172F.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_resetStateForNewBattle_803F6B0.yaml
	thumb_func_start battle_resetStateForNewBattle_803F6B0
battle_resetStateForNewBattle_803F6B0:
	push {r4,r5,lr}
	mov r4, r0
	ldr r0, off_803F73C // =eStruct200F360
	mov r1, #0x20
	bl ZeroFillByHalfword
	bl crt0_entry_trampoline_8000288
	mov r0, #0
	bl eLinkState_ResetForNewUse_803DE88
	bl sub_803DEAC
	mov r0, #0x10
	mov r1, #2
	mov r2, #4
	mov r3, #4
	bl sub_803DCE8
	mov r0, #0
	mov r1, #0
	ldr r2, off_803F730 // =dword_803F734
	lsl r4, r4, #2
	ldr r2, [r2,r4]
	bl sub_813DBC0
	ldr r0, off_803F738 // =eLinkState
	mov r1, #0x3c
	strh r1, [r0,#0xc] // Camera.unk_0C
	// flag 0 @ 0x2001c88[0x2e5] (=2001f6d)
	movflag EVENT_172F
	bl SetEventFlagFromImmediate
	pop {r4,r5,pc}
	thumb_func_end battle_resetStateForNewBattle_803F6B0

	thumb_local_start
sub_803F6F4:
	push {r4,r5,lr}
	mov r4, r0
	ldr r0, off_803F73C // =eStruct200F360
	mov r1, #0x20
	bl ZeroFillByHalfword
	mov r0, #0
	bl eLinkState_ResetForNewUse_803DE88
	mov r0, #0x10
	mov r1, #2
	mov r2, #4
	mov r3, #4
	bl sub_803DCE8
	mov r0, #0
	mov r1, #0
	ldr r2, off_803F730 // =dword_803F734
	lsl r4, r4, #2
	ldr r2, [r2,r4]
	bl sub_813DBC0
	ldr r0, off_803F738 // =eLinkState
	mov r1, #0x3c
	strh r1, [r0,#0xc] // (eCamera.unk_5C - 0x20099d0)
	movflag EVENT_172F
	bl SetEventFlagFromImmediate
	pop {r4,r5,pc}
	.balign 4, 0
off_803F730:
	.word dword_803F734
dword_803F734:
	.word 0x4000
off_803F738:
	.word eLinkState // eLinkState
off_803F73C:
	.word eStruct200F360
	thumb_func_end sub_803F6F4

// symdb: Query a link-player slot's activation state and associated eCamera fields.
// symdb: r0 = linkIndex → c, v, r0 (eCamera.unk_66 or 0), r1 (0 if active, 1 if empty), r2
// symdb: (eCamera.unk_60 or callee scratch); flags set by cmp entry,0xFF
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/link_getSlotState_803F740.yaml
	thumb_func_start link_getSlotState_803F740
link_getSlotState_803F740:
	push {r4-r7,lr}
	mov r7, r0
	bl link_getModeSelector_803DD30
	ldr r1, off_803F768 // =byte_803F774
	ldrb r0, [r1,r0]
	cmp r0, #0xff
	beq loc_803F760
	mov r1, #8
	mul r1, r7
	add r1, r1, r0
	ldr r7, off_803F770 // =eLinkState
	ldrh r2, [r7,#0x10] // (eCamera.unk_60 - 0x20099d0)
	ldrh r0, [r7,#0x16] // (eCamera.unk_66 - 0x20099d0)
	mov r1, #0
	b locret_803F764
loc_803F760:
	mov r1, #1
	mov r0, #0
locret_803F764:
	pop {r4-r7,pc}
	.balign 4, 0
off_803F768:
	.word byte_803F774
	.word byte_2009940
off_803F770:
	.word eLinkState // eLinkState
byte_803F774:
	.byte 0x2, 0xFF, 0xFF, 0x4, 0x40, 0x99, 0x0, 0x2, 0x40, 0x99, 0x0
	.byte 0x2
EXE6_InfoText_timestamp: .asciz "REXE6 F 20060110a US"
	.byte 0x0, 0x0, 0x0
	thumb_func_end link_getSlotState_803F740

// symdb: Entry stub of a multi-entry routine: saves r1-r7 and lr, seeds the shared body's loop counter (r4) to 0, then falls through into the shared code at loc_803F7A2.
// symdb: void sub_803F798(void); // caller's r1-r7 and lr are spilled to the stack by the stub itself;
// symdb: returns to the caller via the shared body's pop {r1-r7,pc}
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/sub_803F798.yaml
	thumb_func_start sub_803F798
sub_803F798:
	push {r1-r7,lr}
	mov r4, #0
	b loc_803F7A2
	thumb_func_end sub_803F798

// symdb: Mirrors the 0x10-byte EWRAM work buffer (0x2000000..0x6710) to Game Pak SRAM, verifying the round-trip checksum before committing and toggling event flag 0x1704.
// symdb: (r0..r3 ignored) -> r0 = 1 on successful verify-write-clear, 0 on verify-fail-then-set-flag
// symdb: retry
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/save_writeAndVerifyEWRAMToSRAM_803F79E.yaml
	thumb_func_start save_writeAndVerifyEWRAMToSRAM_803F79E
save_writeAndVerifyEWRAMToSRAM_803F79E:
	push {r1-r7,lr}
	mov r4, #1
loc_803F7A2:
	bl save_BackupToGamePakWithRetry_803FAB4
	bne loc_803F808
	tst r4, r4
	bne loc_803F7C2
	mov r7, r10
	ldr r6, [r7,#oToolkit_GameStatePtr]
	ldr r7, [r6,#oGameState_OverworldPlayerObjectPtr]
	ldr r0, [r7,#oOWPlayerObject_X]
	str r0, [r6,#oGameState_PlayerX]
	ldr r0, [r7,#oOWPlayerObject_Y]
	str r0, [r6,#oGameState_PlayerY]
	ldr r0, [r7,#oOWPlayerObject_Z]
	str r0, [r6,#oGameState_PlayerZ]
	ldrb r0, [r7,#oOWPlayerObject_FacingDirection]
	str r0, [r6,#oGameState_FacingDirectionAfterWarp]
loc_803F7C2:
	bl rollRngSeedIntoExtraToolkitPtrs_8006e26
	bl info_copyTimestampToWorkArea_803F8B2
	bl s2001c04_ComputeChecksumOfEwramRegion_803F894
	bl save_CommitWorkBufferToGamePak_803FB04
	ldr r0, off_803F888 // =timer_2000000
	ldr r1, dword_803F890 // =0x6710
	bl encryption_xorBufferWithKey_8006df6
	mov r7, #0
loc_803F7DC:
	ldr r0, off_803F888 // =timer_2000000
	ldr r1, dword_803F88C // =0xe000100
	ldr r2, dword_803F890 // =0x6710
	push {r0-r2}
	bl libSave_CopyToGamePak
	pop {r0-r2}
	push {r0-r3,r7}
	bl sub_814D9C4
	mov r4, r0
	pop {r0-r3,r7}
	tst r4, r4
	beq loc_803F814
	add r7, #1
	cmp r7, #3
	blt loc_803F7DC
	push {r0-r2}
	// size
	mov r1, r2
	bl encryption_save_memSetFlags_8006E0E // (u8 *mem, int size) -> void
	pop {r0-r2}
loc_803F808:
	movflag EVENT_1704
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	mov r0, #1
	pop {r1-r7,pc}
loc_803F814:
	push {r0-r2}
	// size
	mov r1, r2
	bl encryption_save_memSetFlags_8006E0E // (u8 *mem, int size) -> void
	pop {r0-r2}
	mov r4, r10
	ldr r4, [r4,#oToolkit_S2001c04_Ptr]
	ldr r4, [r4,#0x68]
	bl s2001c04_ComputeChecksumOfEwramRegion_803F894
	cmp r0, r4
	bne loc_803F7C2
	movflag EVENT_1704
	bl SetEventFlagFromImmediate
	mov r0, #0
	pop {r1-r7,pc}
	thumb_func_end save_writeAndVerifyEWRAMToSRAM_803F79E

// symdb: Re-initialise the save/toolkit work area: zero and checksum the 0x6710-byte EWRAM buffer, re-seed RNG and the extra-toolkit pointer block, and set EVENT_1704 to reflect whether the on-disk save was tampered with or outdated.
// symdb: (r10 = Toolkit, plus any caller globals) -> r0 = bool (FALSE if work area + info-text are still
// symdb: current, TRUE if either failed); ZF cleared/!ZF based on r0 (tst r0,r0 then pop with PC); side
// symdb: effects clobber r0..r3 (toolkit/callee state).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/toolkit_initAndVerifyWorkArea_0803F838.yaml
	thumb_func_start toolkit_initAndVerifyWorkArea_0803F838
toolkit_initAndVerifyWorkArea_0803F838: // () -> !zf
	push {r1-r7,lr}
	ldr r0, dword_803F88C // =0xe000100
	ldr r1, off_803F888 // =timer_2000000
	ldr r2, dword_803F890 // =0x6710
	push {r0-r3}
	bl sub_814D8F0
	pop {r0-r3}
	push {r0-r2}
	// mem
	mov r0, r1
	// size
	mov r1, r2
	bl encryption_save_memSetFlags_8006E0E // (u8 *mem, int size) -> void
	pop {r0-r2}
	bl SetExtraToolkitPointers
	bl verifyEwramWorkAreaChecksum_803F8C4
	bne loc_803F870
	bl infoText_IsTimestampUnchanged_803F8F4
	bne loc_803F870
	mov r4, #FALSE
	movflag EVENT_1704
	bl SetEventFlagFromImmediate
	b loc_803F87E
// symdb: Failure path inside toolkit_initAndVerifyWorkArea_0803F838, taken when the work area's checksum or the info-text timestamp check fails - result TRUE, EVENT_1704 cleared, primary RNG seed reset to 0xA338244F (SeedRNG).
// symdb: A branch target, not a function (reached by bne from two places in
// symdb: toolkit_initAndVerifyWorkArea_0803F838). Sets r4 = TRUE, clears EVENT_1704, calls SeedRNG, then
// symdb: joins the shared tail at loc_803F87E (RandomizeExtraToolkitPointers, r0 = r4, tst r0, r0, pop
// symdb: {r1-r7,pc}), so the function returns r0 = TRUE with Z clear.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/loc_803F870.yaml
loc_803F870:
	mov r4, #TRUE
	movflag EVENT_1704
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	bl SeedRNG // () -> ()
loc_803F87E:
	bl RandomizeExtraToolkitPointers // () -> ?
	mov r0, r4
	tst r0, r0
	pop {r1-r7,pc}
	.balign 4, 0
off_803F888:
	.word timer_2000000
dword_803F88C:
	.word 0xE000100
dword_803F890:
	.word 0x6710
	thumb_func_end toolkit_initAndVerifyWorkArea_0803F838

// symdb: Computes a byte checksum over 16 bytes of EWRAM at 0x2000000+0x6700 and stores it (+24) into the S2001c04 work area's field at offset 0x68.
// symdb: u32 sub_803F894(void) — reads the S2001c04 pointer from the toolkit (r10); returns the checksum
// symdb: in r0; all other registers preserved.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/s2001c04_ComputeChecksumOfEwramRegion_803F894.yaml
	thumb_local_start
s2001c04_ComputeChecksumOfEwramRegion_803F894:
	push {r1-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_S2001c04_Ptr]
	mov r0, #0
	str r0, [r7,#0x68]
	mov r0, #0
	ldr r1, off_803F8EC // =timer_2000000
	ldr r2, dword_803F8F0 // =0x670f
loc_803F8A4:
	ldrb r3, [r1,r2]
	add r0, r0, r3
	sub r2, #1
	bge loc_803F8A4
	add r0, #0x18
	str r0, [r7,#0x68]
	pop {r1-r7,pc}
	thumb_func_end s2001c04_ComputeChecksumOfEwramRegion_803F894

// symdb: Copies the 20-byte InfoText timestamp buffer into the packet/work area at toolkit->S2001c04 + 0x6C.
// symdb: void sub_803F8B2(void); /* reads r10 (toolkit ptr); r0/r1/r2 are left holding CopyBytes' final
// symdb: r0/r1/r2, which callers treat as outputs r1/r2/r3 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/info_copyTimestampToWorkArea_803F8B2.yaml
	thumb_local_start
info_copyTimestampToWorkArea_803F8B2:
	push {lr}
	ldr r0, off_803F914 // =EXE6_InfoText_timestamp
	mov r1, r10
	ldr r1, [r1,#oToolkit_S2001c04_Ptr]
	add r1, #0x6c
	mov r2, #0x14
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	pop {pc}
	thumb_func_end info_copyTimestampToWorkArea_803F8B2

// symdb: Anti-tamper integrity check - recomputes a byte-sum checksum over the 0x6710-byte EWRAM work area and compares it with the stored value, clearing the store and returning 0 on match, 1 on mismatch.
// symdb: int verifyEwramWorkAreaChecksum_803F8C4(void); // r0 out: 0 = checksum OK, 1 = mismatch; NZ
// symdb: flags set from r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/verifyEwramWorkAreaChecksum_803F8C4.yaml
	thumb_local_start
verifyEwramWorkAreaChecksum_803F8C4:
	push {r1-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_S2001c04_Ptr]
	ldr r6, [r7,#0x68]
	mov r0, #0
	str r0, [r7,#0x68]
	mov r0, #0
	ldr r1, off_803F8EC // =timer_2000000
	ldr r2, dword_803F8F0 // =0x670f
loc_803F8D6:
	ldrb r3, [r1,r2]
	add r0, r0, r3
	sub r2, #1
	bge loc_803F8D6
	add r0, #0x18
	cmp r0, r6
	bne loc_803F8E8
	mov r0, #0
	pop {r1-r7,pc}
loc_803F8E8:
	mov r0, #1
	pop {r1-r7,pc}
	.balign 4, 0
off_803F8EC:
	.word timer_2000000
dword_803F8F0:
	.word 0x670F
	thumb_func_end verifyEwramWorkAreaChecksum_803F8C4

// symdb: Compares a 20-byte timestamp stored in the save buffer against the master info-text timestamp, returning 0 when the on-screen info text is still current and 1 when it must be refreshed.
// symdb: bool infoText_IsTimestampUnchanged(void); /* r0 = 0 if all 20 bytes match, r0 = 1 if any differ;
// symdb: nz reflects r0; preserves r1-r7 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/infoText_IsTimestampUnchanged_803F8F4.yaml
	thumb_local_start
infoText_IsTimestampUnchanged_803F8F4:
	push {r1-r7,lr}
	ldr r0, off_803F914 // =EXE6_InfoText_timestamp
	mov r1, r10
	ldr r1, [r1,#oToolkit_S2001c04_Ptr]
	add r1, #0x6c
	mov r2, #0x13
loc_803F900:
	ldrb r3, [r1,r2]
	ldrb r4, [r0,r2]
	cmp r3, r4
	bne loc_803F910
	sub r2, #1
	bge loc_803F900
	mov r0, #0
	pop {r1-r7,pc}
loc_803F910:
	mov r0, #1
	pop {r1-r7,pc}
	.balign 4, 0
off_803F914:
	.word EXE6_InfoText_timestamp
	thumb_func_end infoText_IsTimestampUnchanged_803F8F4

// symdb: Builds a 0x28-byte save block holding the info-text timestamp plus a checksum and writes it to SRAM at 0x0E007E00, retrying up to 3 times and setting/clearing event flag EVENT_172E to report success.
// symdb: () -> r0 = 0 if the SRAM write verified, 1 after 3 failed attempts; sets/clears EVENT_172E
// symdb: accordingly
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/saveInfoTextBlockToSram.yaml
	thumb_local_start
saveInfoTextBlockToSram:
	push {r1-r7,lr}
	ldr r0, off_803F9E0 // =EXE6_InfoText_timestamp
	ldr r1, off_803F9CC // =byte_2006720
	mov r2, #0x14
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	ldr r0, off_803F9D4 // =byte_2006710
	ldr r1, off_803F9DC // =0x28
	mov r2, #0
	ldr r3, off_803F9D0 // =byte_2006714
	str r2, [r3]
loc_803F92E:
	sub r1, #1
	blt loc_803F938
	ldrb r4, [r0,r1]
	add r2, r2, r4
	b loc_803F92E
loc_803F938:
	str r2, [r3]
	mov r7, #0
loc_803F93C:
	ldr r0, off_803F9D4 // =byte_2006710
	ldr r1, dword_803F9D8 // =0xe007e00
	ldr r2, off_803F9DC // =0x28
	push {r0-r2}
	bl libSave_CopyToGamePak
	pop {r0-r2}
	push {r0-r3,r7}
	bl sub_814D9C4
	mov r4, r0
	pop {r0-r3,r7}
	tst r4, r4
	beq loc_803F96A
	add r7, #1
	cmp r7, #3
	blt loc_803F93C
	movflag EVENT_172E
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	mov r0, #1
	pop {r1-r7,pc}
loc_803F96A:
	movflag EVENT_172E
	bl SetEventFlagFromImmediate
	mov r0, #0
	pop {r1-r7,pc}
	thumb_func_end saveInfoTextBlockToSram

	thumb_local_start
sub_803F976:
	push {r1-r7,lr}
	ldr r0, dword_803F9D8 // =0xe007e00
	ldr r1, off_803F9D4 // =byte_2006710
	ldr r2, off_803F9DC // =0x28
	push {r0-r3}
	bl sub_814D8F0
	pop {r0-r3}
	ldr r0, off_803F9E0 // =EXE6_InfoText_timestamp
	ldr r1, off_803F9CC // =byte_2006720
	mov r2, #0
loc_803F98C:
	ldrb r3, [r0,r2]
	ldrb r4, [r1,r2]
	cmp r3, r4
	bne loc_803F9C0
	add r2, #1
	cmp r2, #0x14
	blt loc_803F98C
	ldr r0, off_803F9D4 // =byte_2006710
	ldr r1, off_803F9DC // =0x28
	mov r2, #0
	ldr r4, off_803F9D0 // =byte_2006714
	ldr r3, [r4]
	str r2, [r4]
loc_803F9A6:
	sub r1, #1
	blt loc_803F9B0
	ldrb r4, [r0,r1]
	add r2, r2, r4
	b loc_803F9A6
loc_803F9B0:
	cmp r2, r3
	bne loc_803F9C0
	movflag EVENT_172E
	bl SetEventFlagFromImmediate
	mov r0, #0
	pop {r1-r7,pc}
loc_803F9C0:
	movflag EVENT_172E
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	mov r0, #1
	pop {r1-r7,pc}
	.balign 4, 0
off_803F9CC:
	.word byte_2006720
off_803F9D0:
	.word byte_2006714
off_803F9D4:
	.word byte_2006710
dword_803F9D8:
	.word 0xE007E00
off_803F9DC:
	.word 0x28
off_803F9E0:
	.word EXE6_InfoText_timestamp
	thumb_func_end sub_803F976

	thumb_func_start sub_803F9E4
sub_803F9E4:
	push {r1-r7,lr}
	ldr r0, off_803FAB0 // =EXE6_InfoText_timestamp
	ldr r1, off_803FA9C // =byte_2006750
	mov r2, #0x14
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void
	ldr r0, off_803FAA4 // =dword_2006740
	ldr r1, off_803FAAC // =0x78
	mov r2, #0
	ldr r3, off_803FAA0 // =dword_2006744
	str r2, [r3]
loc_803F9FA:
	sub r1, #1
	blt loc_803FA04
	ldrb r4, [r0,r1]
	add r2, r2, r4
	b loc_803F9FA
loc_803FA04:
	str r2, [r3]
	mov r7, #0
loc_803FA08:
	ldr r0, off_803FAA4 // =dword_2006740
	ldr r1, dword_803FAA8 // =0xe007e80
	ldr r2, off_803FAAC // =0x78
	push {r0-r2}
	bl libSave_CopyToGamePak
	pop {r0-r2}
	push {r0-r3,r7}
	bl sub_814D9C4
	mov r4, r0
	pop {r0-r3,r7}
	tst r4, r4
	beq loc_803FA36
	add r7, #1
	cmp r7, #3
	blt loc_803FA08
	movflag EVENT_1737
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	mov r0, #1
	pop {r1-r7,pc}
loc_803FA36:
	movflag EVENT_1737
	bl SetEventFlagFromImmediate
	mov r0, #0
	pop {r1-r7,pc}
	thumb_func_end sub_803F9E4

	thumb_func_start sub_803FA42
sub_803FA42:
	push {r1-r7,lr}
	ldr r0, dword_803FAA8 // =0xe007e80
	ldr r1, off_803FAA4 // =dword_2006740
	ldr r2, off_803FAAC // =0x78
	push {r0-r3}
	bl sub_814D8F0
	pop {r0-r3}
	ldr r0, off_803FAB0 // =EXE6_InfoText_timestamp
	ldr r1, off_803FA9C // =byte_2006750
	mov r2, #0
loc_803FA58:
	ldrb r3, [r0,r2]
	ldrb r4, [r1,r2]
	cmp r3, r4
	bne loc_803FA8C
	add r2, #1
	cmp r2, #0x14
	blt loc_803FA58
	ldr r0, off_803FAA4 // =dword_2006740
	ldr r1, off_803FAAC // =0x78
	mov r2, #0
	ldr r4, off_803FAA0 // =dword_2006744
	ldr r3, [r4]
	str r2, [r4]
loc_803FA72:
	sub r1, #1
	blt loc_803FA7C
	ldrb r4, [r0,r1]
	add r2, r2, r4
	b loc_803FA72
loc_803FA7C:
	cmp r2, r3
	bne loc_803FA8C
	movflag EVENT_1737
	bl SetEventFlagFromImmediate
	mov r0, #0
	pop {r1-r7,pc}
loc_803FA8C:
	movflag EVENT_1737
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	bl initStateBlock_803C352
	mov r0, #1
	pop {r1-r7,pc}
	.balign 4, 0
off_803FA9C:
	.word byte_2006750
off_803FAA0:
	.word dword_2006744
off_803FAA4:
	.word dword_2006740
dword_803FAA8:
	.word 0xE007E80
off_803FAAC:
	.word 0x78
off_803FAB0:
	.word EXE6_InfoText_timestamp
	thumb_func_end sub_803FA42

// symdb: Backs up the 0x80-byte save block at dword_20067C0 into the game pak backup area, retrying up to three times, and returns 1 if any attempt verified successfully.
// symdb: bool sub_803FAB4(void); returns r0 = 1 if at least one of three attempts copied and verified, r0
// symdb: = 0 if all three failed; r4-r7 and NZ flags (on r0) are the observable outputs; clobbers r0-r3
// symdb: and lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/save_BackupToGamePakWithRetry_803FAB4.yaml
	thumb_local_start
save_BackupToGamePakWithRetry_803FAB4:
	push {r4-r7,lr}
	mov r7, #0
	mov r6, #0
loc_803FABA:
	bl rng_FillSeedBuffer_803FAEE
	ldr r0, off_803FB1C // =dword_20067C0
	ldr r1, dword_803FB20 // =0xe007f80
	ldr r2, off_803FB24 // =0x80
	push {r0-r2}
	bl libSave_CopyToGamePak
	pop {r0-r2}
	push {r0-r3,r6,r7}
	bl sub_814D9C4
	mov r4, r0
	pop {r0-r3,r6,r7}
	tst r4, r4
	bne loc_803FADC
	add r6, #1
loc_803FADC:
	add r7, #1
	cmp r7, #3
	blt loc_803FABA
	cmp r6, #3
	bge loc_803FAEA
	mov r0, #1
	pop {r4-r7,pc}
loc_803FAEA:
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end save_BackupToGamePakWithRetry_803FAB4

// symdb: Fills the 0x80-byte buffer at dword_20067C0 with 32 random 32-bit words from the hardware RNG.
// symdb: void sub_803FAEE(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/rng_FillSeedBuffer_803FAEE.yaml
	thumb_local_start
rng_FillSeedBuffer_803FAEE:
	push {r4-r7,lr}
	mov r7, #0
	ldr r6, off_803FB24 // =0x80
	ldr r4, off_803FB18 // =dword_20067C0
loc_803FAF6:
	bl GetRNG // () -> u32?
	str r0, [r4,r7]
	add r7, #4
	cmp r7, r6
	blt loc_803FAF6
	pop {r4-r7,pc}
	thumb_func_end rng_FillSeedBuffer_803FAEE

// symdb: Writes the caller's value into the save work buffer at dword_20067C0 and flushes the 0x80-byte buffer to the Game Pak save area at 0xE007F80.
// symdb: void save_CommitWorkBufferToGamePak_803FB04(u32 value /* r0, stored as first word of the save
// symdb: block */); all registers r0-r7 preserved (push {r0-r7,lr} / pop {r0-r7,pc}); flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/save_CommitWorkBufferToGamePak_803FB04.yaml
	thumb_local_start
save_CommitWorkBufferToGamePak_803FB04:
	push {r0-r7,lr}
	ldr r4, off_803FB18 // =dword_20067C0
	str r0, [r4]
	ldr r0, off_803FB1C // =dword_20067C0
	ldr r1, dword_803FB20 // =0xe007f80
	ldr r2, off_803FB24 // =0x80
	bl libSave_CopyToGamePak
	pop {r0-r7,pc}
	.balign 4, 0
off_803FB18:
	.word dword_20067C0
off_803FB1C:
	.word dword_20067C0
dword_803FB20:
	.word 0xE007F80
off_803FB24:
	.word 0x80
	thumb_func_end save_CommitWorkBufferToGamePak_803FB04

	thumb_func_start sub_803FB28
sub_803FB28:
	push {lr}
	// memBlock
	ldr r0, off_803FB60 // =eS200F348
	// size
	mov r1, #8
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()

  // trigger cb_dispatchS200F348State_803FB3C via main_
	mov r0, r10
	ldr r0, [r0,#oToolkit_MainJumptableIndexPtr]
	mov r1, #0x14
	strb r1, [r0]

	pop {pc}
	thumb_func_end sub_803FB28

// symdb: Game-over state-machine callback: reads the state index from eS200F348 and dispatches to init (0), playGameOver (4), or update (8), then runs the common post-dispatch routine.
// symdb: cb_dispatchS200F348State(void) -> void
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/cb_dispatchS200F348State_803FB3C.yaml
	thumb_func_start cb_dispatchS200F348State_803FB3C
cb_dispatchS200F348State_803FB3C:
	push {r4-r7,lr}
	ldr r5, off_803FB60 // =eS200F348
	ldr r0, off_803FB50 // =off_803FB54

	ldrb r1, [r5, #oS200F348_Index_00]
	ldr r0, [r0,r1]
	mov lr, pc
	bx r0

	bl renderInfo_applyScrollDelta_803FC14

	pop {r4-r7,pc}
	.balign 4, 0
off_803FB50:
	.word off_803FB54
off_803FB54: 
  // 0x00
  .word scene_gameOverSetup_803FB64+1 // (self: *mut S200F348 $r5) -> ()
  // 0x04
	.word playGameOver_803FB9C+1 // (self: *mut S200F348 $r5) -> ()
  // 0x08
	.word maybeResetStartScreen_803FBC2+1
off_803FB60:
	.word eS200F348
	thumb_func_end cb_dispatchS200F348State_803FB3C

// symdb: Transitions to the game-over screen: renders a chatbox message, resets the display pipeline, tears down the active scene, fades to black, then marks state index 4 and starts a ~3 s countdown.
// symdb: void scene_gameOverSetup(S200F348* self /*r5*/, u32 context /*r1*/) -> r0 = 0xB4 (down-counter
// symdb: value); flags nz reflect r0; r2-r4,r7,lr may change
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/scene_gameOverSetup_803FB64.yaml
	thumb_local_start
scene_gameOverSetup_803FB64: // (self: *mut S200F348 $r5) -> ()
	push {lr}

	bl chatbox_8040818

	mov r0, #0xf
	bl toolkit_applyOverlayPalette_80015FC

	bl copyTileData_803FC64

	ldr r0, dword_803FB98 // =0x1f40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()

	bl renderInfo_8001788 // () -> ()

	bl renderInfo_80017A0 // () -> ()

	bl sub_803FBE8

	mov r0, #8
	mov r1, #0x20 
	bl SetScreenFade // (int a1, int a2) -> void

  // trigger playGameOver_803FB9C via cb_dispatchS200F348State_803FB3C
	mov r0, #4
	strb r0, [r5, #oS200F348_Index_00]

	mov r0, #0xb4
	strh r0, [r5,#oS200F348_DownCounter]

	pop {pc}
	.balign 4, 0
dword_803FB98:
	.word 0x1F40
	thumb_func_end scene_gameOverSetup_803FB64

// symdb: Per-frame tick of the game-over sequence state: decrements DownCounter, plays the game-over jingle when the counter reaches 0xAF, and on expiry starts a screen fade and advances Index to 8.
// symdb: void playGameOver_803FB9C(struct S200F348 *self /* r5 */); /* passes r2/r5/r10/lr in, leaves
// symdb: r0/r1/r10 out (r2/r3/lr/flags clobbered; r4/r5/r6/r7/r10 preserved) */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/playGameOver_803FB9C.yaml
	thumb_local_start
playGameOver_803FB9C: // (self: *mut S200F348 $r5) -> ()
	push {lr}

	ldrh r0, [r5,#oS200F348_DownCounter]
	sub r0, #1
	strh r0, [r5,#oS200F348_DownCounter]

	beq loc_803FBB4

	mov r1, #0xaf
	cmp r0, r1
	bne locret_803FBC0

	mov r0, #SONG_GAME_OVER
	bl PlayMusic // (song: u8) -> ()
	b locret_803FBC0

loc_803FBB4:
	mov r0, #0xc
	mov r1, #8
	bl SetScreenFade // (int a1, int a2) -> void

  // trigger maybeResetStartScreen_803FBC2 via cb_dispatchS200F348State_803FB3C
	mov r0, #8
	strb r0, [r5, #oS200F348_Index_00]

locret_803FBC0:
	pop {pc}
	thumb_func_end playGameOver_803FB9C

// symdb: If no screen fade is in progress, runs the title/start-screen reinit sequence (subsystem reset, start-screen init, clear and init the start-screen animation control) and sets the render-info LCD control to 0x40.
// symdb: void maybeResetStartScreen_803FBC2(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/maybeResetStartScreen_803FBC2.yaml
	thumb_local_start
maybeResetStartScreen_803FBC2:
	push {lr}

	bl IsScreenFadeActive // () -> zf
	beq locret_803FBE0

	bl sub_8006910

	bl startScreen_init_802F530 // () -> void

	bl clear_e200AD04 // () -> ()

	bl init_eStartScreenAnimationControl200B1A0_2

	ldr r0, off_803FBE4 // =0x40
	bl SetRenderInfoLCDControl // (a_00: u16) -> ()

locret_803FBE0:
	pop {pc}
	.balign 4, 0
off_803FBE4:
	.word 0x40
	thumb_func_end maybeResetStartScreen_803FBC2

	thumb_local_start
sub_803FBE8:
	push {lr}
	ldr r0, off_803FCE0 // =eDecompBuffer2013A00
	ldr r1, off_803FC0C // =BG1X_Offset
	mov r2, #1
	ldr r3, dword_803FC10 // =0xa2400000
	bl req_enqueueTask
	ldr r3, off_803FCE0 // =eDecompBuffer2013A00
	mov r2, #0
	mov r1, #0xa0
	lsl r1, r1, #1
	mov r0, #0
loc_803FC00:
	str r0, [r3,r2]
	add r2, #4
	cmp r2, r1
	blt loc_803FC00
	pop {pc}
	.balign 4, 0
off_803FC0C:
	.word BG1X_Offset
dword_803FC10:
	.word 0xA2400000
	thumb_func_end sub_803FBE8

// symdb: Scans the OAM decomp buffer and offsets each row's Y by a scroll delta sourced from the toolkit's render-info field, decrementing that field by 4 first.
// symdb: void sub_803FC14(void);   // inputs:  r10 = oToolkit* (RenderInfoPtr read via r10), r1 passed in
// symdb: but not consumed   // outputs: r0 = final computed row offset, r1 = last byte_803FC50 entry read
// symdb: //          r2 = 0x140 (loop end), r3 = eDecompBuffer2013A00 base   // clobbers: N Z C V (set by
// symdb: final cmp pos,end or cmp cell,0x14)   // preserved: r4 r6 r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/renderInfo_applyScrollDelta_803FC14.yaml
	thumb_local_start
renderInfo_applyScrollDelta_803FC14:
	push {r4,r6,r7,lr}
	mov r3, r10
	ldr r3, [r3,#oToolkit_RenderInfoPtr]
	ldrh r0, [r3,#0x10]
	sub r0, #4
	strh r0, [r3,#0x10]
	ldr r3, off_803FCE0 // =eDecompBuffer2013A00
	mov r2, #0xa0
	lsl r2, r2, #1
	mov r4, #4
	mov r6, #0
	mov r7, #0
loc_803FC2C:
	strh r0, [r3,r6]
	add r6, #2
	cmp r6, r2
	bge locret_803FC48
	sub r4, #1
	bgt loc_803FC2C
	ldrh r0, [r3,r6]
	ldr r1, off_803FC4C // =byte_803FC50
	ldrb r1, [r1,r7]
	sub r0, r0, r1
	mov r4, #8
	add r7, #1
	cmp r7, #0x14
	ble loc_803FC2C
locret_803FC48:
	pop {r4,r6,r7,pc}
	.balign 4, 0
off_803FC4C:
	.word byte_803FC50
byte_803FC50:
	.byte 0x8, 0x10, 0xC, 0x8, 0x10, 0xC, 0x8, 0x10, 0xC, 0x8, 0x10
	.byte 0xC, 0x8, 0x10, 0xC, 0x8, 0x10, 0xC, 0x8, 0x10
	thumb_func_end renderInfo_applyScrollDelta_803FC14

// symdb: One-time graphics/tilemap setup: reset graphics state, decompress the shared init-refs table, clear the tile GFX area, and blit 32x20 and 30x20 background tile maps into VRAM tile blocks 1 and 2.
// symdb: void copyTileData_803FC64(void); /* inputs ignored; clobbers r0-r4, r10, lr, nzcv; preserves r5,
// symdb: r6, r7 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyTileData_803FC64.yaml
	thumb_local_start
copyTileData_803FC64:
	push {r5,lr}
	bl resetAllGraphicsState_8005F40
	bl runSetupStepAndClearWorkArea_8005F6C
	bl sprite_initBattleFadeGfxState_80027C4
	// initRefs
	ldr r0, off_803FCA0 // =initRefs803FCA4
	bl decompAndCopyData // (u32 *initRefs) -> void
	bl ZeroFillGFX30025c0
	// j
	mov r0, #0
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #1
	// tileIds
	ldr r3, off_803FCDC // =eTileIds2018A04
	mov r4, #0x20
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	// j
	mov r0, #0
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #2
	// tileIds
	ldr r3, off_803FCD8 // =eTileIds2017A04
	mov r4, #0x1e
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r5,pc}
	.balign 4, 0
off_803FCA0:
	.word initRefs803FCA4
initRefs803FCA4:
  .word comp_86C41D0 + COMPRESSED_PTR_FLAG
  .word 0x06000000
	.word eDecompBuffer2013A00

	.word dword_86C4660
	.word palette_3001960
	.word 0x20

	.word comp_86C4490 + COMPRESSED_PTR_FLAG
	.word 0x0
	.word byte_2017A00

	.word comp_86C45A8 + COMPRESSED_PTR_FLAG
	.word NULL
	.word unk_2018A00

	.word NULL
off_803FCD8:
	.word eTileIds2017A04
off_803FCDC:
	.word eTileIds2018A04
off_803FCE0:
	.word eDecompBuffer2013A00
byte_803FCE4:
	.byte 0x0, 0x2A, 0x0, 0x0, 0x0, 0x54, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	thumb_func_end copyTileData_803FC64

	thumb_func_start clearChatboxAndEvent
clearChatboxAndEvent:
	push {lr}
	mov r0, r10
	// memBlock
	ldr r0, [r0,#oToolkit_ChatboxPtr]
	// size
	ldr r1, off_803FD04 // =0x230
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	mov r0, #0xc8
	bl chatbox_clear_eFlags2009F38 // (int a1) ->
	pop {pc}
	.balign 4, 0
off_803FD04:
	.word 0x230
	thumb_func_end clearChatboxAndEvent

/*For debugging purposes, connect comment at any range!*/
