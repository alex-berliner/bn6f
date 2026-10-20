
	thumb_func_start sub_812D378
sub_812D378:
	push {r4-r7,lr}
	// j
	mov r0, #0
	// i
	mov r1, #0
	// tileBlock32x32
	mov r2, #1
	// tileIds
	ldr r3, off_812D3A0 // =unk_201D620 
	mov r4, #0x1e
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r0, #0x1e
	neg r0, r0
	// i
	mov r1, #2
	// tileBlock32x32
	mov r2, #1
	// tileIds
	ldr r3, off_812D3A4 // =unk_201DB20 
	mov r4, #0x3c 
	mov r5, #0x11
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	.balign 4, 0
off_812D3A0:
	.word unk_201D620
off_812D3A4:
	.word unk_201DB20
	thumb_func_end sub_812D378

// symdb: Builds an in-battle chip search table and dispatches it to battle objects, then sets a 5x4 list/menu size on the battle UI state.
// symdb: () -> void; r7 points to a context whose +0x28 halfword receives the table entry count + 1
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_initChipSearchList.yaml
	thumb_func_start battle_initChipSearchList
battle_initChipSearchList:
	push {lr}
	ldr r0, off_812D3DC // =word_2023FA0 
	mov r1, #0x20 
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	bl removeFolderChipsFromPack
	ldr r0, off_812D3E0 // =unk_2023FC0 
	mov r1, #1
	bl buildChipSearchTable_811FE7C
	add r0, #1
	strh r0, [r7,#0x28]
	mov r1, r0
	ldr r0, off_812D3E0 // =unk_2023FC0 
	mov r2, #5
	mov r3, #4
	bl battle_fieldLockDispatch_8120018
	mov r1, r10
	ldr r1, [r1,#oToolkit_S2001c04_Ptr]
	mov r0, #5
	strb r0, [r1,#2]
	mov r0, #4
	strb r0, [r1,#3]
	pop {pc}
	.balign 4, 0
off_812D3DC:
	.word word_2023FA0
off_812D3E0:
	.word unk_2023FC0
	thumb_func_end battle_initChipSearchList

// symdb: Renders six sections (folder chips, folder OAM pack, icon slots, pack entries, panel entries, plus a header) into tilemap buffers and copies each into BG tile block 2 as 2-column x 14-row strips (columns 3,1,0xB,0xD,0xE,0x10), then calls sub_812D5EC.
// symdb: () -> r0 = 0 via callees; reads screen-state struct from sub_812D6F8, writes tilemap data
// symdb: buffers at 202DFA0..202E144 and copies them into BG tile block 2
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_renderChipPackScreenTilemap.yaml
	thumb_func_start battle_renderChipPackScreenTilemap
battle_renderChipPackScreenTilemap:
	push {r4-r7,lr}
	bl submenu_getWork
	mov r7, r0
	ldrh r0, [r7,#0x2e]
	ldr r1, off_812D4C4 // =word_2023FA0 
	ldr r2, off_812D4C8 // =unk_202DFA0 
	mov r3, #0xa
	mov r5, #7
	bl sub_8120194
	mov r0, #3
	mov r1, #4
	mov r2, #2
	ldr r3, off_812D4C8 // =unk_202DFA0 
	mov r4, #8
	mov r5, #0xe
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	ldrh r0, [r7,#0x2e]
	ldr r1, off_812D4C4 // =word_2023FA0 
	ldr r2, off_812D4CC // =unk_202E080 
	ldr r3, off_812D4D0 // =byte_812C288 
	ldr r4, dword_812D4D4 // =0x6007600 
	mov r5, #7
	bl battle_loadFolderChipGfx_8120390
	mov r0, #1
	mov r1, #4
	mov r2, #2
	ldr r3, off_812D4CC // =unk_202E080 
	mov r4, #2
	mov r5, #0xe
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	ldrh r0, [r7,#0x2e]
	ldr r1, off_812D4C4 // =word_2023FA0 
	ldr r2, off_812D4D8 // =unk_202E0B8 
	mov r3, #9
	lsl r3, r3, #0xc
	ldr r4, off_812D4DC // =0x35c 
	orr r3, r4
	ldr r4, dword_812D4E0 // =0x6006b80 
	mov r5, #7
	bl battle_buildChipFolderOamPack_81203E4
	mov r0, #0xb
	mov r1, #4
	mov r2, #2
	ldr r3, off_812D4D8 // =unk_202E0B8 
	mov r4, #2
	mov r5, #0xe
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	ldrh r0, [r7,#0x2e]
	ldr r1, off_812D4C4 // =word_2023FA0 
	ldr r2, off_812D4E4 // =unk_202E0F0 
	mov r3, #0xa
	lsl r3, r3, #0xc
	ldr r4, dword_812D4E8 // =0x216 
	orr r3, r4
	mov r5, #7
	bl battle_loadChipIconSlots_8120458
	mov r0, #0xd
	mov r1, #4
	mov r2, #2
	ldr r3, off_812D4E4 // =unk_202E0F0 
	mov r4, #1
	mov r5, #0xe
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	ldrh r0, [r7,#0x2e]
	ldr r1, off_812D4C4 // =word_2023FA0 
	ldr r2, off_812D4EC // =byte_202E10C 
	mov r3, #8
	lsl r3, r3, #0xc
	ldr r4, dword_812D4F0 // =0x34f 
	orr r3, r4
	mov r5, #7
	bl battle_fillChipPackEntries_81204C4
	mov r0, #0xe
	mov r1, #4
	mov r2, #2
	ldr r3, off_812D4EC // =byte_202E10C 
	mov r4, #2
	mov r5, #0xe
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	ldrh r0, [r7,#0x2e]
	ldr r1, off_812D4C4 // =word_2023FA0 
	ldr r2, off_812D4F4 // =byte_202E144 
	mov r3, #0xa
	lsl r3, r3, #0xc
	ldr r4, dword_812D4F8 // =0x200 
	orr r3, r4
	mov r5, #7
	bl sub_8120618
	mov r0, #0x10
	mov r1, #4
	mov r2, #2
	ldr r3, off_812D4F4 // =byte_202E144 
	mov r4, #2
	mov r5, #0xe
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	bl sub_812D5EC
	pop {r4-r7,pc}
	.balign 4, 0
off_812D4C4:
	.word word_2023FA0
off_812D4C8:
	.word unk_202DFA0
off_812D4CC:
	.word unk_202E080
off_812D4D0:
	.word byte_812C288
dword_812D4D4:
	.word 0x6007600
off_812D4D8:
	.word unk_202E0B8
off_812D4DC:
	.word 0x35C
dword_812D4E0:
	.word 0x6006B80
off_812D4E4:
	.word unk_202E0F0
dword_812D4E8:
	.word 0x216
off_812D4EC:
	.word byte_202E10C
dword_812D4F0:
	.word 0x34F
off_812D4F4:
	.word byte_202E144
dword_812D4F8:
	.word 0x200
	thumb_func_end battle_renderChipPackScreenTilemap

// symdb: Fetches the shared submenu work struct (0x02037780) and invokes a fixed draw/queue call with constant coordinates and a ROM data blob (byte_8129178), then a follow-up commit call, as part of the per-frame update of this screen's state handlers.
// symdb: () -> void; no caller consumes a return value (r0-r3, r4=byte_8129178, r6=0x40000000, r7=0x20002
// symdb: are preloaded as extra args for sub_812D600)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/submenu_drawScreenElement.yaml
	thumb_func_start submenu_drawScreenElement
submenu_drawScreenElement:
	push {r4-r7,lr}
	bl submenu_getWork
	mov r5, r0
	mov r0, #2
	mov r1, #0x20 
	mov r2, #0x2a 
	mov r3, #0x13
	ldr r4, off_812D51C // =byte_8129178 
	ldr r6, dword_812D524 // =0x40000000 
	ldr r7, dword_812D520 // =0x20002 
	bl sub_812D600
	bl sub_812D9F0
	pop {r4-r7,pc}
	.balign 4, 0
off_812D51C:
	.word byte_8129178
dword_812D520:
	.word 0x20002
dword_812D524:
	.word 0x40000000
	thumb_func_end submenu_drawScreenElement

	thumb_func_start sub_812D528
sub_812D528:
	push {r4-r7,lr}
	mov r2, #0xc6
	b loc_812D532
	thumb_func_end sub_812D528

	thumb_local_start
sub_812D52E:
	push {r4-r7,lr}
	mov r2, #0x30 
loc_812D532:
	mov r1, #0
	push {r1,r2}
	mov r0, r1
	bl getStructFrom2008450
	pop {r1,r2}
	bne locret_812D546
	ldr r0, off_812D548 // =byte_812C258 
	bl sub_812D56C
locret_812D546:
	pop {r4-r7,pc}
	.balign 4, 0
off_812D548:
	.word byte_812C258
	thumb_func_end sub_812D52E

	thumb_local_start
sub_812D54C:
	push {r4-r7,lr}
	mov r1, #3
	push {r1}
	mov r0, r1
	bl getStructFrom2008450
	pop {r1}
	bne locret_812D564
	mov r2, #0xc0
	ldr r0, off_812D568 // =byte_812C268 
	bl sub_812D56C
locret_812D564:
	pop {r4-r7,pc}
	.balign 4, 0
off_812D568:
	.word byte_812C268
	thumb_func_end sub_812D54C

	thumb_local_start
sub_812D56C:
	push {r4-r7,lr}
	sub sp, sp, #4
	str r2, [sp]
	mov r6, r1
	add r4, r6, #2
	bl battle_spawnEStructRecordsFromTable_80465A0 // (void *a1) -> void
loc_812D57A:
	mov r0, r6
	bl getStructFrom2008450
	beq loc_812D594
	tst r6, r6
	bne loc_812D588
	mov r7, r1
loc_812D588:
	mov r5, r1
	ldr r0, [sp]
	mov r1, #0x58 
	bl sprite_setCoordinates
	str r7, [r5,#0x14]
loc_812D594:
	add r6, #1
	cmp r6, r4
	ble loc_812D57A
	add sp, sp, #4
	pop {r4-r7,pc}
	.byte 0, 0
	thumb_func_end sub_812D56C

	thumb_func_start sub_812D5A0
sub_812D5A0:
	push {r4-r7,lr}
	bl submenu_getWork
	mov r5, r0
	ldr r0, off_812D5CC // =word_2023FA0 
	ldrh r4, [r5,#0x2a]
	ldrh r1, [r5,#0x2e]
	add r4, r4, r1
	mov r1, #0x20 
	mul r1, r4
	add r0, r0, r1
	ldr r2, [r0,#0x1c]
	lsl r0, r2, #0x10
	lsr r0, r0, #0x17
	mov r1, #0x7f
	and r1, r2
	mov r2, #0
	mov r3, r4
	bl setFieldsInThreeTableEntries_811980C
	pop {r4-r7,pc}
	.balign 4, 0
off_812D5CC:
	.word word_2023FA0
	thumb_func_end sub_812D5A0

	thumb_func_start sub_812D5D0
sub_812D5D0:
	push {r4-r7,lr}
	mov r3, r2
	mov r2, r1
	mov r1, r0
	lsl r0, r0, #0x17
	lsr r0, r0, #0x17
	mov r4, r0
	lsl r1, r1, #0x11
	lsr r1, r1, #0x1a
	bl setFieldsInThreeTableEntries_811980C
	mov r0, r4
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_812D5D0

	thumb_local_start
sub_812D5EC:
	push {r4-r7,lr}
	bl submenu_getWork
	mov r7, r0
	mov r0, #0xc6
	mov r1, #0x58 
	mov r2, #0
	bl sprite_setPositionForIdRange3_8119854
	pop {r4-r7,pc}
	thumb_func_end sub_812D5EC

	thumb_local_start
sub_812D600:
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
	bne loc_812D61C
	mov r2, #0
	b loc_812D61E
loc_812D61C:
	ldrh r2, [r5,r3]
loc_812D61E:
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
	bl battleObject_queueOamFromTableRow_811FAF4
	ldr r1, [sp,#0x14]
	lsr r1, r1, #4
	sub r1, #1
	bne loc_812D64C
	ldr r1, off_812D664 // =dword_8129180 
	bl battleObject_advanceAnimTableBy0xFF_8120CC8
	ldr r2, [sp,#8]
	strb r0, [r5,r2]
loc_812D64C:
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
	.word byte_8129178
off_812D664:
	.word dword_8129180
	thumb_func_end sub_812D600

	thumb_local_start
sub_812D668:
	push {r4-r7,lr}
	bl submenu_getWork
	mov r5, r0
	mov r0, #0xa4
	mov r1, #0x20 
	mov r2, #0x34 
	mov r3, #0x15
	ldr r4, off_812D684 // =byte_8129178 
	ldr r6, dword_812D68C // =0x40000000 
	ldr r7, dword_812D688 // =0x2 
	bl sub_812D600
	pop {r4-r7,pc}
	.balign 4, 0
off_812D684:
	.word byte_8129178
dword_812D688:
	.word 0x2
dword_812D68C:
	.word 0x40000000
	thumb_func_end sub_812D668

	thumb_func_start sub_812D690
sub_812D690:
	push {r4-r7,lr}
	bl submenu_getWork
	mov r7, r0
	ldrh r0, [r7,#0x28]
	tst r0, r0
	beq loc_812D6C4
	ldrh r0, [r5,#0x26]
	cmp r0, #4
	beq locret_812D6F4
	cmp r0, #8
	beq locret_812D6F4
	bl sub_812D700
	bne locret_812D6F4
	push {r5,r7}
	mov r5, r7
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	mov r1, #7
	mov r2, #0
	mov r3, #0xa
	bl menu_adjustCursorOrValue_811F7F8
	pop {r5,r7}
loc_812D6C4:
	mov r0, #JOYPAD_B
	bl IsButtonPressed
	bne loc_812D6DC
	mov r0, #JOYPAD_A
	bl IsButtonPressed
	beq locret_812D6F4
	mov r1, #4
	ldrb r0, [r5,#0x11]
	tst r0, r0
	beq loc_812D6E6
loc_812D6DC:
	ldrb r1, [r5,#0x1b]
	mov r0, #1
	orr r1, r0
	strb r1, [r5,#0x1b]
	mov r1, #8
loc_812D6E6:
	strh r1, [r5,#0x26]
	mov r0, #0x81
	cmp r1, #4
	beq loc_812D6F0
	mov r0, #0x83
loc_812D6F0:
	bl PlaySoundEffect
locret_812D6F4:
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_812D690

// symdb: Returns the pointer to the shared work/state struct for the submenu screen cluster at 0x02037780.
// symdb: () -> r0 = pointer to menu work struct (0x02037780); flags unaffected (returns via mov pc, lr)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/submenu_getWork.yaml
	thumb_func_start submenu_getWork
submenu_getWork:
	ldr r0, off_812D6FC // =unk_2037780 
	mov pc, lr
off_812D6FC:
	.word unk_2037780
	thumb_func_end submenu_getWork

	thumb_local_start
sub_812D700:
	push {r7,lr}
	bl submenu_getWork
	mov r7, r0
	mov r0, #JOYPAD_START
	bl IsButtonPressed
	bne loc_812D71E
	ldrb r0, [r5,#2]
	cmp r0, #0x20 
	bne loc_812D742
	mov r0, #JOYPAD_B
	bl IsButtonPressed
	beq locret_812D746
loc_812D71E:
	ldrb r0, [r5,#2]
	cmp r0, #0x20 
	bne loc_812D730
	ldrb r0, [r7,#0xd]
	strb r0, [r5,#2]
	mov r0, #SOUND_EXIT_SUBMENU
	bl PlaySoundEffect
	b locret_812D746
loc_812D730:
	strb r0, [r7,#0xd]
	mov r0, #0x20 
	strb r0, [r5,#2]
	mov r0, #0
	strh r0, [r7,#0x34]
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	b locret_812D746
loc_812D742:
	mov r0, #0
	tst r0, r0
locret_812D746:
	pop {r7,pc}
	thumb_func_end sub_812D700

// symdb: Per-frame handler for an 8-entry menu: moves the cursor up/down with the d-pad (unless some state forbids it) and refreshes a background tile patch each frame.
// symdb: () -> void; r7 = menu state pointer (callee-returned), cursor index stored at [state+0x34]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/submenu_updateCursorAndTiles.yaml
	thumb_func_start submenu_updateCursorAndTiles
submenu_updateCursorAndTiles:
	push {r7,lr}
	bl submenu_getWork
	mov r7, r0
	bl sub_812D700
	bne locret_812D776
	bl sub_812D7A4
	bne loc_812D76E
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r0, [r0,#oJoypad_LowSensitivityHeld]
	mov r1, #7
	mov r2, #1
	ldrh r3, [r7,#0x34]
	bl menu_moveCursorUpDown_811FA22
	strh r0, [r7,#0x34]
loc_812D76E:
	bl copyBgTilesToBlock0
	bl sub_812D668
locret_812D776:
	pop {r7,pc}
	thumb_func_end submenu_updateCursorAndTiles

	thumb_func_start sub_812D778
sub_812D778:
	push {lr}
	ldrb r0, [r5,#2]
	cmp r0, #0x20 
	bne locret_812D788
	bl copyBgTilesToBlock0
	bl sub_812D668
locret_812D788:
	pop {pc}
	.balign 4, 0x00
	thumb_func_end sub_812D778

// symdb: Blits a fixed 8x17 tile patch from the RAM buffer unk_20227A0 into background tile block 0 at position (j=0x15, i=2).
// symdb: () -> void; no flags (r0-r5 set internally, calls CopyBackgroundTiles)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/copyBgTilesToBlock0.yaml
	thumb_func_start copyBgTilesToBlock0
copyBgTilesToBlock0:
	push {r4-r7,lr}
	// j
	mov r0, #0x15
	// i
	mov r1, #2
	// tileBlock32x32
	mov r2, #0
	// tileIds
	ldr r3, off_812D7A0 // =unk_20227A0 
	mov r4, #8
	mov r5, #0x11
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()

	pop {r4-r7,pc}
off_812D7A0:
	.word unk_20227A0
	thumb_func_end copyBgTilesToBlock0
	thumb_local_start
sub_812D7A4:
	push {r4-r7,lr}
	sub sp, sp, #4
	str r5, [sp]
	bl submenu_getWork
	mov r5, r0
	mov r0, #JOYPAD_A
	bl IsButtonPressed
	bne loc_812D7BA
	b loc_812D800
loc_812D7BA:
	mov r0, #SOUND_MENU_SELECT
	bl PlaySoundEffect
	mov r0, r10
	ldr r0, [r0,#oToolkit_S2001c04_Ptr]
	ldrh r2, [r5,#0x34]
	mov r1, #2
	mov r4, #3
	ldrb r3, [r0,r1]
	strb r2, [r0,r1]
	cmp r2, r3
	beq loc_812D7DE
	ldr r1, off_812D808 // =byte_30069A0 
	ldrb r3, [r1,r2]
	mov r1, #4
	eor r3, r1
	strb r3, [r0,r4]
	b loc_812D7E6
loc_812D7DE:
	ldrb r3, [r0,r4]
	mov r1, #4
	eor r3, r1
	strb r3, [r0,r4]
loc_812D7E6:
	ldr r0, off_812D80C // =unk_2023FC0 
	ldrh r1, [r5,#0x28]
	sub r1, #1
	beq loc_812D7F6
	bl battle_fieldLockDispatch_8120018
	bl sub_812D5A0
loc_812D7F6:
	mov r6, #0
	mov r7, #0
	mov r0, #1
	tst r0, r0
	b loc_812D804
loc_812D800:
	mov r0, #0
	tst r0, r0
loc_812D804:
	add sp, sp, #4
	pop {r4-r7,pc}
	.balign 4, 0
off_812D808:
	.word byte_30069A0
off_812D80C:
	.word unk_2023FC0
	.word 0x64
	thumb_func_end sub_812D7A4

	thumb_local_start
sub_812D814:
	push {lr}
	bl submenu_getWork
	ldr r1, [r0,#0x6c]
	tst r1, r1
	beq locret_812D82E
	sub r1, #1
	str r1, [r0,#0x6c]
	bne locret_812D82E
	bl chatbox_8040818
	mov r0, #0
	tst r0, r0
locret_812D82E:
	pop {pc}
	thumb_func_end sub_812D814

	thumb_local_start
sub_812D830:
	push {lr}
	bl submenu_getWork
	ldr r1, [r0,#0x6c]
	tst r1, r1
	pop {pc}
	thumb_func_end sub_812D830

// symdb: Runs text script 0x41 from eTextScript201BA20 once, guarding repeats with a 100-frame cooldown stored in the object's work area.
// symdb: (r5 = object/npc work struct) -> r0 = chatbox script-runner result; no flags of interest
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/npc_runScript41OncePerCooldown.yaml
	thumb_local_start
npc_runScript41OncePerCooldown:
	push {lr}
	ldr r0, [r5,#0x6c]
	tst r0, r0
	bne locret_812D84E
	ldr r0, off_812D850 // =0x64 
	str r0, [r5,#0x6c]
	mov r0, #0x41 
	bl chatbox_runScript_803FD9C_on_eTextScript201BA20
locret_812D84E:
	pop {pc}
	.balign 4, 0
off_812D850:
	.word 0x64
	thumb_func_end npc_runScript41OncePerCooldown

	thumb_func_start sub_812D854
sub_812D854:
	push {lr}
	bl submenu_getWork
	mov r1, r0
	ldrh r0, [r1,#0x2e]
	ldrh r2, [r1,#0x2a]
	add r0, r0, r2
	ldr r1, off_812D87C // =word_2023FA0 
	lsl r0, r0, #5
	add r1, r1, r0
	ldrh r0, [r1,#0x1c]
	lsr r1, r0, #7
	mov r2, #0x7f
	and r0, r2
	lsl r0, r0, #9
	orr r0, r1
	mov r2, #0x80
	lsl r2, r2, #8
	orr r0, r2
	pop {pc}
	.balign 4, 0
off_812D87C:
	.word word_2023FA0
	thumb_func_end sub_812D854

// symdb: State-machine handler that saves the current state, switches the task to state 0x1C, and opens a text script (0x30 or 0x40) in the chatbox, also fixing up an in-progress screen fade.
// symdb: (r0 = unused, r1 = unused, r5 = task struct) -> void; flags clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/t4_transitionToTextState1C.yaml
	thumb_func_start t4_transitionToTextState1C
t4_transitionToTextState1C:
	push {lr}
	bl screenFade_80062C8
	cmp r0, #0xc
	bne loc_812D892
	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
loc_812D892:
	ldrb r0, [r5,#2]
	strb r0, [r5,#0x16]
	mov r0, #0x1c
	strb r0, [r5,#2]
	mov r0, #0
	strb r0, [r5,#0xc]
	strb r0, [r5,#3]
	ldrb r1, [r5,#0x1b]
	mov r0, #1
	tst r1, r0
	bne loc_812D8BC
	mov r1, #0x40 
	bl eStruct200BC30_getRef
	ldrb r0, [r0,#0xe]
	cmp r0, #2
	bne loc_812D8B6
	mov r1, #0x30 
loc_812D8B6:
	mov r0, r1
	bl chatbox_runScript_803FD9C_on_eTextScript201BA20
loc_812D8BC:
	ldrb r0, [r5,#0x16]
	cmp r0, #0
	beq locret_812D8C6
	bl pack_addAllFolderChipsToPack
locret_812D8C6:
	pop {pc}
	thumb_func_end t4_transitionToTextState1C

	thumb_func_start sub_812D8C8
sub_812D8C8:
	push {r4-r7,lr}
	mov r7, r5
	bl ZeroFillGFX30025c0
	bl battle_resetEStructRecords_8046664 // () -> void
	mov r0, #0
	mov r1, #0
	mov r2, #1
	ldr r3, off_812D914 // =dword_201E420 
	mov r4, #0x1e
	mov r5, #0x14
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	mov r5, r7
	bl sub_812D52E
	ldrh r0, [r5,#0x2a]
	mov r1, #0
	mov r2, #0
	bl sub_812D5D0
	mov r1, #0
	bl sub_812D934
	mov r0, #0
	bl sub_812D954

	bl sub_812D54C
	mov r0, #0
	mov r1, #3
	mov r2, #0
	bl sub_812D5D0
	bl battle_spawnEStructsFromTablePair
	pop {r4-r7,pc}
off_812D914:
	.word dword_201E420
	.word byte_812C278
	thumb_func_end sub_812D8C8
// symdb: Wrapper that spawns a batch of eStruct records from one of two hardcoded 0xFF-terminated (id, slot, param) tables.
// symdb: (r0 = unused/ignored) -> r0 = result of battle_spawnEStructRecordsFromTable; secondary entry at
// symdb: sub_812D922 selects the second table
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_spawnEStructsFromTablePair.yaml
	thumb_func_start battle_spawnEStructsFromTablePair
battle_spawnEStructsFromTablePair:
	push {lr}
	ldr r0, off_812D92C // =byte_812C278 
	b loc_812D926
loc_812D922:
	push {lr}
	// a1
	ldr r0, off_812D930 // =byte_812C280 
loc_812D926:
	bl battle_spawnEStructRecordsFromTable_80465A0 // (void *a1) -> void
	pop {pc}
	.balign 4, 0
off_812D92C:
	.word byte_812C278
off_812D930:
	.word byte_812C280
	thumb_func_end battle_spawnEStructsFromTablePair

	thumb_func_start sub_812D934
sub_812D934:
	push {r4,lr}
	lsl r1, r1, #2
	mov r4, r0
	ldr r2, off_812D948 // =off_812D94C 
	ldr r2, [r2,r1]
	mov r3, #0xa
	bl sub_8120228
	pop {r4,pc}
	.balign 4, 0
off_812D948:
	.word off_812D94C
off_812D94C:
	.word unk_202DFA0
	.word unk_202DFC0
	thumb_func_end sub_812D934

	thumb_func_start sub_812D954
sub_812D954:
	push {r4-r7,lr}
	lsl r0, r0, #2
	ldr r1, off_812D9D0 // =off_812D9D4 
	ldr r3, [r1,r0]
	ldr r1, off_812D9DC // =byte_812D9E0 
	ldr r4, [r1,r0]
	tst r0, r0
	beq loc_812D96E
	ldrh r2, [r5,#0x30]
	mov r1, #8
	sub r1, r1, r2
	add r7, r4, r1
	b loc_812D970
loc_812D96E:
	mov r7, r4
loc_812D970:
	ldr r1, off_812D9DC // =byte_812D9E0 
	add r0, #8
	ldr r6, [r1,r0]
	push {r3}
	mov r0, r4
	mov r1, r6
	mov r2, #2
	mov r3, #0
	mov r4, #8
	mov r5, #2
	bl call_sub_3005EBA

	pop {r3}
	mov r0, r7
	mov r1, r6
	mov r2, #2
	mov r4, #8
	mov r5, #2
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_812D954
	thumb_func_start sub_812D99C
sub_812D99C:
	push {r4-r7,lr}
	lsl r0, r0, #2
	ldr r1, off_812D9D0 // =off_812D9D4 
	ldr r3, [r1,r0]
	ldr r1, off_812D9DC // =byte_812D9E0 
	ldr r4, [r1,r0]
	tst r0, r0
	beq loc_812D9B6
	ldrh r2, [r5,#0x30]
	mov r1, #8
	sub r1, r1, r2
	add r7, r4, r1
	b loc_812D9B8
loc_812D9B6:
	mov r7, r4
loc_812D9B8:
	ldr r1, off_812D9DC // =byte_812D9E0 
	add r0, #8
	ldr r6, [r1,r0]
	mov r0, r4
	mov r1, r6
	mov r2, #2
	mov r3, #0
	mov r4, #8
	mov r5, #2
	bl call_sub_3005EBA
	pop {r4-r7,pc}
off_812D9D0:
	.word off_812D9D4
off_812D9D4:
	.word unk_202DFA0
	.word unk_202DFC0
off_812D9DC:
	.word byte_812D9E0
byte_812D9E0:
	.byte 0xB, 0x0, 0x0, 0x0, 0xB, 0x0, 0x0, 0x0, 0x6, 0x0, 0x0, 0x0, 0xD, 0x0, 0x0
	.byte 0x0
	thumb_func_end sub_812D99C

	thumb_local_start
sub_812D9F0:
	push {r4-r7,lr}
	bl submenu_getWork
	mov r5, r0
	ldr r0, dword_812DA30 // =0x92 
	mov r1, #0x1c
	mov r2, #0x28 
	mov r3, #0x2e 
	bl sub_812DA08
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end sub_812D9F0

	thumb_local_start
sub_812DA08:
	push {r4-r7,lr}
	sub sp, sp, #0xc
	str r1, [sp]
	str r2, [sp,#4]
	str r3, [sp,#8]
	lsl r0, r0, #0x10
	ldr r1, [sp]
	orr r0, r1
	ldr r1, dword_812DA34 // =0x20002 
	ldr r2, [sp,#4]
	ldrh r2, [r5,r2]
	ldr r3, [sp,#8]
	ldrh r3, [r5,r3]
	mov r4, #7
	ldr r6, dword_812DA38 // =0xc24c 
	mov r7, #0x64 
	bl object_computeAndQueueOamEntry_811FA98
	add sp, sp, #0xc
	pop {r4-r7,pc}
	.balign 4, 0
dword_812DA30:
	.word 0x92
dword_812DA34:
	.word 0x20002
dword_812DA38:
	.word 0xC24C
	thumb_func_end sub_812DA08

	thumb_func_start sub_812DA3C
sub_812DA3C:
	push {lr}
	mov r0, #6
	bl getStructFrom2008450
	bne locret_812DA4A
	bl submenu_drawScreenElement
locret_812DA4A:
	pop {pc}
	thumb_func_end sub_812DA3C

// symdb: Stores a caller-supplied byte into an NPC state struct, sets its state to 0x30, then makes the chatbox play text script 0x41 from archive eTextScript201BA20 and loads a 0xF0 timer.
// symdb: (r0 = byte parameter stored at [r5,#0x1f], r5 = NPC/object work struct) -> r0 =
// symdb: chatbox_runScript return value; no flags meaningful
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/npc_runDialog41.yaml
	thumb_func_start npc_runDialog41
npc_runDialog41:
	push {lr}
	strb r0, [r5,#0x1f]
	mov r0, #0x30 
	strb r0, [r5,#2]
	mov r0, #0x41 
	bl chatbox_runScript_803FD9C_on_eTextScript201BA20
	mov r0, #0xf0
	strh r0, [r5,#0x28]
	pop {pc}
	thumb_func_end npc_runDialog41

	thumb_func_start sub_812DA60
sub_812DA60:
	push {r0,lr}
	bl screenFade_80062C8
	cmp r0, #0xc
	bne loc_812DA72
	mov r0, #8
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
loc_812DA72:
	bl eStruct200BC30_getJumpOffset00
	cmp r0, #0
	bne loc_812DA80
	bl link_resetHardwareAndClearLinkBuffers_81440D8 // static () -> void
	b loc_812DA84
loc_812DA80:
	bl sub_803C754 // (self: * S200BC50 $r7) -> (u32?, bool)
loc_812DA84:
	mov r1, #0x1c
	strb r1, [r5,#2]
	mov r1, #0
	strb r1, [r5,#0xc]
	strb r1, [r5,#3]
	bl pack_addAllFolderChipsToPack
	// <endpool> <endfile>
	pop {r0,pc}
	thumb_func_end sub_812DA60

/*For debugging purposes, connect comment at any range!*/
