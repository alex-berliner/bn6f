
	thumb_local_start
sub_8088CA0:
  push {lr}
	bl sub_8005D88
	mov r0, #0
	pop {pc}
	.balign 4, 0
	thumb_func_end sub_8088CA0

end_func_8088CAC::
	ccs_set_camera_pos hword1=0x0100 hword3=0x0240 hword5=0x0000
	ccs_end

cutscenescript_8088CB4:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x0C byte3=0x08
	cs_wait_screen_fade
	cs_decomp_text_archive ptr1=CompText87B330C + COMPRESSED_PTR_FLAG
	cs_run_cutscene_camera_script ptr1=end_func_8088CAC
	cs_spawn_ow_npc_objects_from_list ptr2=npcscript_list_8059110
	cs_make_ow_player_invisible
	cs_disable_ow_player_wall_collision_809e254
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x08
	cs_wait_screen_fade
	cs_set_cutscene_skip_script ptr1=cutscenescript_8088D2F
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x00
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x3C

cutscenescript_8088CEC:
	cs_disable_cutscene_skip_script
	cs_set_screen_fade byte1=0xFF byte2=0x0C byte3=0x08
	cs_wait_screen_fade
	cs_give_item byte2=0x60 byte3=0x01
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_EVENT_CUR_DIR_LOCKED
	cs_set_event_flag byte1=0xFF event16_2=EVENT_682
	cs_spawn_ow_npc_objects_from_map
	cs_stop_cutscene_camera_script
	cs_chatbox_cmd_8037a70
	cs_ow_player_sprite_special_with_arg byte1=0x04 byte2=0xFF byte3=0x01
	cs_write_ow_player_fixed_anim_select_8037dac byte2=0xFF byte3=0x01
	cs_ow_player_coord_special byte1=0x00 byte2=0xFF byte3=0x01 signedhword4=0x0040 signedhword6=0x0240 signedhword8=0x0000
	cs_make_ow_player_visible
	cs_set_event_flag byte1=0xFF event16_2=EVENT_66C
	cs_pause byte1=0xFF byte2=0x3C
	cs_play_music hword1=0xFFFF
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x08
	cs_wait_screen_fade
	cs_enable_ow_player_wall_collision_809e248
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64

cutscenescript_8088D2F:
	cs_set_chatbox_flags byte2=0x40
	cs_jump destination1=cutscenescript_8088CEC
	cs_end_for_map_reload_maybe_8037c64

ccs_8088D38:
	ccs_set_camera_pos hword1=0xF9C0 hword3=0xFF40 hword5=0x0000
	ccs_end

cutscenescript_8088D40:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_decomp_text_archive ptr1=CompText87B36EC + COMPRESSED_PTR_FLAG
	cs_pause byte1=0xFF byte2=0x01
	cs_run_cutscene_camera_script ptr1=ccs_8088D38
	cs_spawn_ow_npc_objects_from_list ptr2=npcscript_806ECF4
	cs_make_ow_player_invisible
	cs_disable_ow_player_wall_collision_809e254
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x00 byte3=0x08
	cs_wait_screen_fade
	cs_set_cutscene_skip_script ptr1=dword_8088DAC
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x00
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x3C

byte_8088D73:
	cs_disable_cutscene_skip_script
	cs_set_screen_fade byte1=0xFF byte2=0x0C byte3=0x08
	cs_wait_screen_fade
	cs_change_navi_maybe_80382fe byte1=0x06
	cs_spawn_ow_npc_objects_from_map
	cs_stop_cutscene_camera_script
	cs_chatbox_cmd_8037a70
	cs_ow_player_sprite_special_with_arg byte1=0x04 byte2=0xFF byte3=0x04
	cs_write_ow_player_fixed_anim_select_8037dac byte2=0xFF byte3=0x04
	cs_ow_player_coord_special byte1=0x00 byte2=0xFF byte3=0x01 signedhword4=-0x0640 signedhword6=-0x00C0 signedhword8=0x0000
	cs_make_ow_player_visible
	cs_set_event_flag byte1=0xFF event16_2=EVENT_66E
	cs_pause byte1=0xFF byte2=0x3C
	cs_play_music hword1=0xFFFF
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x08
	cs_wait_screen_fade
	cs_enable_ow_player_wall_collision_809e248
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64

dword_8088DAC:
	cs_set_chatbox_flags byte2=0x40
	cs_jump destination1=byte_8088D73

ccs_8088DB4:
	ccs_set_camera_pos hword1=0x0520 hword3=0x0520 hword5=0x0000
	ccs_end

ccs_8088DBC:
	ccs_simple_scroll hword1=0x0018 hword3=0xFF80 hword5=0x0000 hword7=0x0000
	ccs_end

end_ccs_8088DC6:
	.byte 0x00
	.byte 0x00
cutscenescript_8088DC8:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x0C byte3=0x08
	cs_wait_screen_fade
	cs_decomp_text_archive ptr1=CompText87B3A04 + COMPRESSED_PTR_FLAG
	cs_run_cutscene_camera_script ptr1=ccs_8088DB4
	cs_spawn_ow_npc_objects_from_list ptr2=npcscript_806D15C
	cs_make_ow_player_invisible
	cs_disable_ow_player_wall_collision_809e254
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x08
	cs_wait_screen_fade
	cs_set_cutscene_skip_script ptr1=cutscenescript_8088EDD
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x00
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x1E
	cs_spawn_cutscene_process byte1=0x20 ptr2=cutscenescript_8088EE5
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x03
	cs_wait_chatbox byte1=0x80
	cs_disable_cutscene_skip_script
	cs_set_screen_fade byte1=0xFF byte2=0x04 byte3=0x02
	cs_wait_screen_fade
	cs_kill_cutscene_process byte1=0x20
	cs_do_camera_shake byte1=0x00 byte2=0x00 byte3=0x00
	cs_init_eStruct200a6a0 ptr1=battleObject_dispatchBeastOutAction_804CBA4+1 ptr5=clear_renderBlendEffect+1 word9=0x00000003
	cs_set_var byte1=0x08 byte2=0x01
	cs_pause byte1=0xFF byte2=0x5A
	cs_set_screen_fade byte1=0xFF byte2=0x00 byte3=0x02
	cs_wait_screen_fade
	cs_set_cutscene_skip_script ptr1=cutscenescript_8088EDD
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x04
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_var byte1=0x08 byte2=0x02
	cs_wait_var_equal byte1=0x08 byte2=0x04
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_cutscene_camera_script ptr1=ccs_8088DBC
	cs_wait_camera_script
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x05
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_var byte1=0x08 byte2=0x05
	cs_wait_var_equal byte1=0x08 byte2=0x06
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x06
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x3C

cutscenescript_8088E72:
	cs_disable_cutscene_skip_script
	cs_set_screen_fade byte1=0xFF byte2=0x0C byte3=0x08
	cs_wait_screen_fade
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_EVENT_CUR_DIR_LOCKED
	cs_kill_cutscene_process byte1=0x20
	cs_do_camera_shake byte1=0x00 byte2=0x00 byte3=0x00
	cs_set_event_flag byte1=0xFF event16_2=EVENT_680
	cs_run_eStruct200a6a0_callback
	cs_init_eStruct200a6a0 ptr1=battleObject_dispatchBeastOutAction_804CBA4+1 ptr5=clear_renderBlendEffect+1 word9=0x00000003
	cs_spawn_ow_npc_objects_from_map
	cs_stop_cutscene_camera_script
	cs_chatbox_cmd_8037a70
	cs_ow_player_sprite_special_with_arg byte1=0x04 byte2=0xFF byte3=0x04
	cs_write_ow_player_fixed_anim_select_8037dac byte2=0xFF byte3=0x04
	cs_ow_player_coord_special byte1=0x00 byte2=0xFF byte3=0x01 signedhword4=0x0460 signedhword6=0x0520 signedhword8=0x0000
	cs_make_ow_player_visible
	cs_set_event_flag byte1=0xFF event16_2=EVENT_670
	cs_set_event_flag byte1=0xFF event16_2=EVENT_672
	cs_set_event_flag byte1=0xFF event16_2=EVENT_674
	cs_set_event_flag byte1=0xFF event16_2=EVENT_676
	cs_init_minigame_effect byte1=0x00
	cs_call_native_with_return_value ptr1=sub_814187C+1
	cs_call_native_with_return_value ptr1=beast_clearSpawnCoords+1
	cs_pause byte1=0xFF byte2=0x3C
	cs_play_music hword1=0xFFFF
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x08
	cs_wait_screen_fade
	cs_enable_ow_player_wall_collision_809e248
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64

cutscenescript_8088EDD:
	cs_set_chatbox_flags byte2=0x40
	cs_jump destination1=cutscenescript_8088E72

cutscenescript_8088EE5:
	cs_play_sound hword1=0x00E3
	cs_do_camera_shake byte1=0x02 byte2=0x04 byte3=0x00
	cs_pause byte1=0xFF byte2=0x0A
	cs_do_camera_shake byte1=0x01 byte2=0x04 byte3=0x00
	cs_pause byte1=0xFF byte2=0x0A

cutscenescript_8088EF6:
	.word 0x0020005A, 0x0200E34D, 0xF61520FF, 0x0008088E
	.byte 0x00
	.byte 0x00
ccs_8088F08:
	ccs_set_camera_pos hword1=0x0520 hword3=0x0520 hword5=0x0000
	ccs_end

ccs_8088F10:
	ccs_simple_scroll hword1=0x0018 hword3=0xFF80 hword5=0x0000 hword7=0x0000
	ccs_end

end_ccs_8088F1A:
	.byte 0x00
	.byte 0x00
cutscenescript_8088F1C:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x0C byte3=0x08
	cs_wait_screen_fade
	cs_decomp_text_archive ptr1=CompText87B3E70 + COMPRESSED_PTR_FLAG
	cs_run_cutscene_camera_script ptr1=ccs_8088F08
	cs_spawn_ow_npc_objects_from_list ptr2=npcscript_806D1CC
	cs_make_ow_player_invisible
	cs_disable_ow_player_wall_collision_809e254
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x08
	cs_wait_screen_fade
	cs_set_cutscene_skip_script ptr1=cutscenescript_8088FD4
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x00
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x3C
	cs_play_sound hword1=0x015C
	cs_disable_cutscene_skip_script
	cs_set_screen_fade byte1=0xFF byte2=0x04 byte3=0x02
	cs_wait_screen_fade
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_680
	cs_run_eStruct200a6a0_callback
	cs_load_map_gfx_anims_bg_anim
	cs_end_minigame_effect
	cs_pause byte1=0xFF byte2=0x5A
	cs_decomp_text_archive ptr1=CompText87B3E70 + COMPRESSED_PTR_FLAG
	cs_set_screen_fade byte1=0xFF byte2=0x00 byte3=0x02
	cs_wait_screen_fade
	cs_set_cutscene_skip_script ptr1=cutscenescript_8088FD4
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x01
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_cutscene_camera_script ptr1=ccs_8088F10
	cs_wait_camera_script
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_var byte1=0x08 byte2=0x01
	cs_wait_var_equal byte1=0x08 byte2=0x02
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x07
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_var byte1=0x08 byte2=0x03
	cs_wait_var_equal byte1=0x08 byte2=0x04

byte_8088FA6:
	cs_disable_cutscene_skip_script
	cs_set_screen_fade byte1=0xFF byte2=0x04 byte3=0x10
	cs_wait_screen_fade
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_EVENT_CUR_DIR_LOCKED
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_680
	cs_set_event_flag byte1=0xFF event16_2=EVENT_11F
	cs_run_eStruct200a6a0_callback
	cs_end_minigame_effect
	cs_set_event_flag byte1=0xFF event16_2=EVENT_67A
	cs_do_pet_effect byte1=0xFF byte2=0x01
	cs_pause byte1=0xFF byte2=0x3C
	cs_warp_cmd_8038040_2 byte1=0x1 byte2=0x01 ptr3=unk_8088FDC
	cs_enable_ow_player_wall_collision_809e248
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64

cutscenescript_8088FD4:
	cs_set_chatbox_flags byte2=0x40
	cs_jump destination1=byte_8088FA6

unk_8088FDC:
	.word 0x04000000, 0x00000000, 0x00000000, 0x00000000
ccs_8088FEC:
	ccs_set_camera_pos hword1=0x0100 hword3=0x0240 hword5=0x0000
	ccs_end

cutscenescript_8088FF4:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_decomp_text_archive ptr1=CompText87B41AC + COMPRESSED_PTR_FLAG
	cs_pause byte1=0xFF byte2=0x01
	cs_run_cutscene_camera_script ptr1=ccs_8088FEC
	cs_spawn_ow_npc_objects_from_list ptr2=npcscript_list_8059158
	cs_make_ow_player_invisible
	cs_disable_ow_player_wall_collision_809e254
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x08
	cs_wait_screen_fade
	cs_set_cutscene_skip_script ptr1=dword_8089058
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x00
	cs_wait_chatbox byte1=0x80

byte_8089024:
	cs_disable_cutscene_skip_script
	cs_set_event_flag byte1=0xFF event16_2=EVENT_609
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_682
	cs_set_event_flag byte1=0xFF event16_2=EVENT_683
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_11F
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_EVENT_CUR_DIR_LOCKED
	cs_set_event_flag byte1=0xFF event16_2=EVENT_E7
	cs_cmd_8038346 word1=0x00130214 word5=0x00000003
	cs_pause byte1=0xFF byte2=0x14
	cs_start_fixed_battle hword1=0x003F
	cs_enable_ow_player_wall_collision_809e248
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_pause byte1=0xFF byte2=0x01
	cs_end_for_map_reload_maybe_8037c64

dword_8089058:
	cs_set_chatbox_flags byte2=0x40
	cs_jump destination1=byte_8089024

byte_8089060:
	ccs_set_camera_pos hword1=0x01A0 hword3=0xECA0 hword5=0x0100
	ccs_end

byte_8089068:
	ccs_simple_scroll hword1=0x0020 hword3=0x0000 hword5=0x0080 hword7=0x0000
	ccs_end

ccs_8089072:
	ccs_simple_scroll hword1=0x0020 hword3=0x0000 hword5=0xFF80 hword7=0x0000
	ccs_end

cutscenescript_808907C:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_decomp_text_archive ptr1=CompText87B45A4 + COMPRESSED_PTR_FLAG
	cs_pause byte1=0xFF byte2=0x01
	cs_do_pet_effect byte1=0xFF byte2=0x00
	cs_run_cutscene_camera_script ptr1=byte_8089060
	cs_spawn_ow_npc_objects_from_list ptr2=npcscript_8074E78
	cs_make_ow_player_invisible
	cs_disable_ow_player_wall_collision_809e254
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x04
	cs_wait_screen_fade
	cs_set_cutscene_skip_script ptr1=byte_808910F
	cs_pause byte1=0xFF byte2=0x3C
	cs_set_var byte1=0x08 byte2=0x01
	cs_run_cutscene_camera_script ptr1=byte_8089068
	cs_wait_camera_script
	cs_wait_var_equal byte1=0x08 byte2=0x02
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x00
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_cutscene_camera_script ptr1=ccs_8089072
	cs_wait_camera_script
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_var byte1=0x08 byte2=0x03
	cs_wait_var_equal byte1=0x08 byte2=0x04
	cs_pause byte1=0xFF byte2=0x1E
	cs_run_text_script_not_from_mem byte2=0x04
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x3C

cutscenescript_80890DA:
	cs_disable_cutscene_skip_script
	cs_set_screen_fade byte1=0xFF byte2=0x0C byte3=0x04
	cs_wait_screen_fade
	cs_pause byte1=0xFF byte2=0x5A
	cs_ow_player_sprite_special_with_arg byte1=0x04 byte2=0xFF byte3=0x04
	cs_write_ow_player_fixed_anim_select_8037dac byte2=0xFF byte3=0x04
	cs_ow_player_coord_special byte1=0x00 byte2=0xFF byte3=0x01 signedhword4=0x0000 signedhword6=0x0000 signedhword8=0x0000
	cs_make_ow_player_visible
	cs_set_event_flag byte1=0xFF event16_2=EVENT_60B
	cs_set_enter_map_screen_fade byte1=0xFF byte2=0xFF
	cs_warp_cmd_8038040_2 byte1=0x0 byte2=0x00 ptr3=unk_8089118
	cs_chatbox_cmd_8037a70
	cs_enable_ow_player_wall_collision_809e248
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64

byte_808910F:
	cs_set_chatbox_flags byte2=0x40
	cs_jump destination1=cutscenescript_80890DA
	cs_end_for_map_reload_maybe_8037c64

unk_8089118:
	.word 0x04000201, 0x00000000, 0x00000000, 0x00000000

dword_8089128:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_call_native_with_return_value ptr1=dispatch_8089140+1

cutscenescript_8089130:
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_747
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64
	cs_set_chatbox_flags byte2=0x40
	cs_jump destination1=cutscenescript_8089130
	cs_end_for_map_reload_maybe_8037c64

	thumb_local_start
dispatch_8089140:
	push {r4-r7, lr}
	ldr r0, =off_8089154
	ldrb r1, [r5, #0]
	ldr r0, [r0, r1]
	mov lr, pc
	bx r0
	tst r0, r0
	pop {r4-r7, pc}
	.pool
	thumb_func_end dispatch_8089140

off_8089154: 
  .word sub_8089160+1
	.word sub_808917C+1
	.word sub_8089234+1

	thumb_local_start
sub_8089160:
	push {r4-r7,lr}
	mov r0, #0
	bl camera_writeUnk03_14_80301b2
	mov r0, #0
	bl doPETEffect_8033fc0
	mov r0, #0
	bl submenu_loadSelectedEntryGfx
	mov r0, #4
	strb r0, [r5]
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_8089160

	thumb_local_start
sub_808917C:
	push {r4-r7,lr}
	mov r7, r10
	ldr r7, [r7,#4]
	ldrh r0, [r7,#2]
	mov r1, #0x20
	lsl r1, r1, #4
	tst r1, r0
	bne loc_80891F4
	ldrh r0, [r7]
	ldr r3, off_8089204 // =byte_8089208
	mov r4, #0
loc_8089192:
	ldrb r2, [r3,r4]
	mov r1, r2
	and r1, r0
	cmp r1, r2
	beq loc_80891A4
	add r4, #1
	cmp r4, #8
	blt loc_8089192
	b loc_80891EE
loc_80891A4:
	mov r7, #0
	mov r1, #2
	tst r0, r1
	beq loc_80891AE
	mov r7, #0x10
loc_80891AE:
	bl GetCameraXYZ
	sub sp, sp, #0xc
	ldr r3, off_8089210 // =off_8089214
	lsl r6, r4, #1
	add r3, r3, r6
	add r3, r3, r7
	mov r6, #0
	ldrsb r6, [r3,r6]
	lsl r6, r6, #0x10
	mov r7, #1
	ldrsb r7, [r3,r7]
	lsl r7, r7, #0x10
	add r0, r0, r6
	add r1, r1, r7
	str r0, [sp]
	str r1, [sp,#4]
	str r2, [sp,#8]
	mov r0, sp
	bl sub_80303FC
	bne loc_80891E6
	ldr r0, [sp]
	ldr r1, [sp,#4]
	ldr r2, [sp,#8]
	bl SetCameraXYZ
	b loc_80891EC
loc_80891E6:
	mov r0, r4
	bl sprite_queueIndexedOamEntry
loc_80891EC:
	add sp, sp, #0xc
loc_80891EE:
	bl sub_8089280
	b loc_80891FE
loc_80891F4:
	mov r0, #SOUND_EXIT_SUBMENU
	bl PlaySoundEffect
	mov r0, #8
	strb r0, [r5]
loc_80891FE:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_8089204:
	.word byte_8089208
byte_8089208: 
  .byte 0x50, 0x90, 0xA0, 0x60, 0x40, 0x10, 0x80, 0x20
off_8089210:
	.word off_8089214
off_8089214: 
  .word GeneralLCDStatus_STAT_LYC_
	.byte 0xFC, 0x0, 0x0, 0xFC, 0x4, 0xFC, 0x2, 0x2, 0xFC, 0x4, 0xFE, 0xFE
	.byte 0x8, 0x0, 0x0, 0x8, 0xF8, 0x0, 0x0, 0xF8, 0x8, 0xF8, 0x4, 0x4
	.byte 0xF8, 0x8, 0xFC, 0xFC
	thumb_func_end sub_808917C

	thumb_local_start
sub_8089234:
	push {r4-r7,lr}
	bl camera_targetPlayer
	mov r0, #1
	bl doPETEffect_8033fc0
	mov r0, #0
	pop {r4-r7,pc}
	thumb_func_end sub_8089234

// symdb: Menu cursor-move handler: copies the selected entry's 0x80-byte record into a work buffer, decompresses its display graphics into VRAM, and plays the cursor-move sound effect.
// symdb: (r0 = selected entry index into table byte_87DE44C, stride 0x80) -> r0 destroyed; loads 0x20
// symdb: words to byte_30016F0, LZ77 asset to VRAM 0x6014800, plays SOUND_MENU_CUR_MOVE
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/submenu_loadSelectedEntryGfx.yaml
	thumb_local_start
submenu_loadSelectedEntryGfx:
	push {r4-r7,lr}
	ldr r1, off_8089278 // =byte_87DE44C
	lsl r0, r0, #5
	add r0, r0, r1
	ldr r1, off_808927C // =byte_30016F0
	mov r2, #0x20
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	// initRefs
	ldr r0, off_8089264 // =byte_8089268
	bl decompAndCopyData // (u32 *initRefs) -> void
	mov r0, #SOUND_MENU_CUR_MOVE
	bl PlaySoundEffect
	pop {r4-r7,pc}
	.balign 4, 0
off_8089264: 
  .word byte_8089268
byte_8089268: 
  .word unk_87DDD4C
	.word 0x6014800
	.word 0x700
	.word NULL
off_8089278:
	.word byte_87DE44C
off_808927C:
	.word byte_30016F0
	thumb_func_end submenu_loadSelectedEntryGfx

// symdb: Selects one of two structurally identical script command tables based on (frame & 0x1F) < 8, runs it via scriptListRun_8001158, then always runs a fixed third table — driving a frame-gated, blink-like sprite animation.
// symdb: () -> void; r0-r2 scratch, no meaningful return value
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8089280.yaml
	thumb_local_start
sub_8089280:
	push {r4-r7,lr}
	ldr r0, off_80892A0 // =byte_80892A4
	mov r1, r10
	ldr r1, [r1,#oToolkit_CurFramePtr]
	ldrh r1, [r1]
	mov r2, #0x1f
	and r1, r2
	cmp r1, #8
	bge loc_8089294
	ldr r0, off_80892F0 // =byte_80892F4
loc_8089294:
	bl scriptListRun_8001158 // () -> void
	ldr r0, off_8089340 // =byte_8089344
	bl scriptListRun_8001158 // () -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_80892A0: 
  .word byte_80892A4
byte_80892A4: 
  .byte 0x8, 0x0, 0x8, 0x0, 0x47, 0xD2, 0x0, 0x0, 0x4, 0x0, 0x74, 0x0, 0x40
	.byte 0xD2, 0x0, 0x0, 0x8, 0x0, 0xE0, 0x0, 0x41, 0xD2, 0x0, 0x0, 0x4D, 0x0
	.byte 0xE4, 0x0, 0x42, 0xD2, 0x0, 0x0, 0x4D, 0x0, 0x4, 0x0, 0x46, 0xD2, 0x0
	.byte 0x0, 0x90, 0x0, 0xE0, 0x0, 0x43, 0xD2, 0x0, 0x0, 0x94, 0x0, 0x74, 0x0
	.byte 0x44, 0xD2, 0x0, 0x0, 0x90, 0x0, 0x8, 0x0, 0x45, 0xD2, 0x0, 0x0, 0x48
	.byte 0x0, 0x70, 0x40, 0x54, 0xD2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
off_80892F0: 
  .word byte_80892F4
byte_80892F4: 
  .byte 0x8, 0x0, 0x8, 0x0, 0x4F, 0xD2, 0x0, 0x0, 0x4, 0x0, 0x74, 0x0, 0x48
	.byte 0xD2, 0x0, 0x0, 0x8, 0x0, 0xE0, 0x0, 0x49, 0xD2, 0x0, 0x0, 0x4D, 0x0
	.byte 0xE4, 0x0, 0x4A, 0xD2, 0x0, 0x0, 0x4D, 0x0, 0x4, 0x0, 0x4E, 0xD2, 0x0
	.byte 0x0, 0x90, 0x0, 0xE0, 0x0, 0x4B, 0xD2, 0x0, 0x0, 0x94, 0x0, 0x74, 0x0
	.byte 0x4C, 0xD2, 0x0, 0x0, 0x90, 0x0, 0x8, 0x0, 0x4D, 0xD2, 0x0, 0x0, 0x48
	.byte 0x0, 0x70, 0x40, 0x54, 0xD2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
off_8089340: 
  .word byte_8089344
byte_8089344: 
  .byte 0x78, 0x40, 0x14, 0x80, 0x58, 0xD2, 0x0, 0x0, 0x78, 0x40
	.byte 0x34, 0x80, 0x60, 0xD2, 0x0, 0x0, 0x78, 0x40, 0x54, 0x80
	.byte 0x68, 0xD2, 0x0, 0x0, 0x88, 0x40, 0x14, 0x40, 0x70, 0xD2
	.byte 0x0, 0x0, 0x88, 0x40, 0x34, 0x40, 0x74, 0xD2, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_8089280

// symdb: Queues one hard-coded OAM entry (a fixed screen sprite/overlay) selected by index from a table.
// symdb: (r0 = entry index) -> r0 = clobbered; no meaningful return
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sprite_queueIndexedOamEntry.yaml
	thumb_local_start
sprite_queueIndexedOamEntry:
	push {r4-r7,lr}
	ldr r1, off_8089388 // =byte_808938C
	lsl r0, r0, #3
	add r1, r1, r0
	ldr r0, [r1]
	ldr r1, [r1,#4]
	mov r2, #0
	mov r3, #1
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	pop {r4-r7,pc}
	.balign 4, 0
off_8089388: 
  .word byte_808938C
byte_808938C: 
  .byte 0x4, 0x0, 0xDC, 0x40, 0x50, 0xD2, 0x0, 0x0, 0x8C, 0x0, 0xDC
	.byte 0x40, 0x50, 0xD2, 0x0, 0x0, 0x8C, 0x0, 0x4, 0x40, 0x50, 0xD2
	.byte 0x0, 0x0, 0x4, 0x0, 0x4, 0x40, 0x50, 0xD2, 0x0, 0x0, 0x0
	.byte 0x0, 0x70, 0x40, 0x50, 0xD2, 0x0, 0x0, 0x49, 0x0, 0xE0, 0x40
	.byte 0x50, 0xD2, 0x0, 0x0, 0x90, 0x0, 0x70, 0x40, 0x50, 0xD2, 0x0
	.byte 0x0, 0x49, 0x0, 0x0, 0x40, 0x50, 0xD2, 0x0, 0x0
byte_80893CC:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x0C byte3=0x08
	cs_wait_screen_fade
	cs_call_native_with_return_value ptr1=t4_mapEnterSetupObjectsAndFlags+1

byte_80893DC:
	cs_pause byte1=0xFF byte2=0x3C
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x08
	cs_wait_screen_fade

cutscenescript_80893E4:
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_746
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64
	cs_set_chatbox_flags byte2=0x40
	cs_jump destination1=cutscenescript_80893E4
	cs_end_for_map_reload_maybe_8037c64

// symdb: Per-map entry routine: clears and respawns map objects, picks one of two setup variants via story flags, then sets story flag 7/0x40 and applies the SoulWeapons overworld state.
// symdb: (void) -> r0 = 0; no flags meaningfully returned
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/t4_mapEnterSetupObjectsAndFlags.yaml
	thumb_local_start
t4_mapEnterSetupObjectsAndFlags:
	push {r4-r7, lr}
	mov r0, #0x20
	bl FreeAllObjectsOfSpecifiedTypes
	bl mapObject_spawnMapObjectsForMap
	mov r3, r10
	ldr r3, [r3, #0x3c]
	ldrh r0, [r3, #4]
	ldr r1, =0x290
	cmp r0, r1
	bne loc_8089434
	ldrb r0, [r3, #6]
	cmp r0, #0x23
	bne loc_8089434
	mov r0, #6
	mov r1, #0x16
	bl TestEventFlagFromImmediate
	bne loc_8089424
	mov r0, #0
	bl sub_8035450
	b loc_8089434
loc_8089424:
	mov r0, #6
	mov r1, #0x1a
	bl TestEventFlagFromImmediate
	bne loc_8089434
	mov r0, #1
	bl sub_8035450
loc_8089434:
	mov r0, #7
	mov r1, #0x40
	bl SetEventFlagFromImmediate
	bl soulWeapons_apply_8142510
	mov r0, #0
	pop {r4-r7, pc}
	.pool
	thumb_func_end t4_mapEnterSetupObjectsAndFlags

byte_8089448:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_decomp_text_archive ptr1=TextScript87DE48C
	cs_set_event_flag byte1=0xFF event16_2=EVENT_1731
	cs_pause byte1=0xFF byte2=0x01
	cs_ow_player_sprite_special_with_arg byte1=0x04 byte2=0xFF byte3=0x04
	cs_write_ow_player_fixed_anim_select_8037dac byte2=0xFF byte3=0x04
	cs_pause byte1=0xFF byte2=0x1E
	cs_set_screen_fade byte1=0xFF byte2=0x08 byte3=0x08
	cs_wait_screen_fade
	cs_pause byte1=0xFF byte2=0x14
	cs_run_text_script_not_from_mem byte2=0x0A
	cs_wait_chatbox byte1=0x80
	cs_pause byte1=0xFF byte2=0x1E
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_744
	cs_clear_event_flag byte1=0xFF event16_2=EVENT_745
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64
	cs_end_for_map_reload_maybe_8037c64
	cs_end_for_map_reload_maybe_8037c64
	cs_end_for_map_reload_maybe_8037c64

byte_8089480: 
  .byte 0x20, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x18, 0x0, 0x8
byte_808948A: 
  .byte 0x1C, 0x0, 0x0, 0x0, 0x0, 0x0
	.word off_8001800
byte_8089494: 
  .byte 0x0, 0xC0, 0x18, 0xC0, 0xF8, 0x0, 0x0, 0x8
byte_808949C: 
  .byte 0x0, 0xC0, 0xFC, 0x60, 0xE6, 0x0, 0x0, 0x8
byte_80894A4: 
  .byte 0x0, 0x40, 0xF, 0x80, 0x6, 0x0, 0x0, 0x8
byte_80894AC: 
  .byte 0x0, 0xC0, 0xF8, 0xE0, 0x15, 0x80, 0x3, 0x8
byte_80894B4: 
  .byte 0x0, 0x0, 0xEF, 0x80, 0x16, 0x0, 0x0, 0x8
byte_80894BC: 
  .byte 0x0, 0x80, 0xED, 0xC0, 0x2, 0x80, 0xFF, 0x8
byte_80894C4: 
  .byte 0x0, 0x60, 0xD, 0x20, 0xE2, 0xE0, 0xFE, 0x8
byte_80894CC: 
  .byte 0x0, 0xE0, 0x1, 0x80, 0x0, 0xE0, 0xFE, 0x8
byte_80894D4: 
  .byte 0x90, 0x0, 0x0, 0x1, 0x0, 0x0, 0xA8, 0xFE, 0x0, 0x0, 0xCC, 0xFF
	.byte 0x0, 0x0, 0x0, 0x0, 0x90, 0x1, 0x0, 0x1, 0x0, 0x0, 0xAC, 0xFE
	.byte 0x0, 0x0, 0xF4, 0x0, 0x0, 0x0, 0x0, 0x0, 0x90, 0x2, 0x0, 0x7
	.byte 0x0, 0x0, 0xFA, 0xFF, 0x0, 0x0, 0x66, 0x1, 0x0, 0x0, 0xE0, 0xFF
	.byte 0x91, 0x0, 0x0, 0x3, 0x0, 0x0, 0xCC, 0x0, 0x0, 0x0, 0xC2, 0xFE
	.byte 0x0, 0x0, 0x40, 0x0, 0x91, 0x1, 0x0, 0x1, 0x0, 0x0, 0x8, 0xFF
	.byte 0x0, 0x0, 0xC8, 0xFF, 0x0, 0x0, 0x0, 0x0, 0x91, 0x2, 0x0, 0x5
	.byte 0x0, 0x0, 0xC0, 0x1, 0x0, 0x0, 0xE, 0xFF, 0x0, 0x0, 0x0, 0x0
	.byte 0x93, 0x0, 0x0, 0x3, 0x0, 0x0, 0x4, 0x0, 0x0, 0x0, 0x1E, 0x0
	.byte 0x0, 0x0, 0x40, 0x0, 0x93, 0x1, 0x0, 0x7, 0x0, 0x0, 0xE, 0x0
	.byte 0x0, 0x0, 0xF4, 0x1, 0x0, 0x0, 0x0, 0x0
byte_8089554:
	cs_lock_player_for_non_npc_dialogue_809e0b0
	cs_nop_80377d0
	cs_decomp_text_archive ptr1=TextScript87DE48C
	cs_pause byte1=0xFF byte2=0x01
	cs_call_native_with_return_value ptr1=battleObject_runUpdateJumpTable_80895A8+1
	cs_jump_if_var_equal byte1=0x08 byte2=0x00 destination3=cutscenescript_808956E
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64

cutscenescript_808956E:
	cs_disable_cutscene_skip_script
	cs_set_screen_fade byte1=0xFF byte2=0x0C byte3=0x08
	cs_wait_screen_fade
	cs_pause byte1=0xFF byte2=0x3C
	cs_set_cur_navi_hp_to_full
	cs_ow_player_sprite_special_with_arg byte1=0x04 byte2=0xFF byte3=0x04
	cs_write_ow_player_fixed_anim_select_8037dac byte2=0xFF byte3=0x04
	cs_ow_player_coord_special byte1=0x00 byte2=0xFF byte3=0x01 signedhword4=0x0000 signedhword6=0x0000 signedhword8=0x0000
	cs_set_event_flag byte1=0xFF event16_2=EVENT_744
	cs_set_event_flag byte1=0xFF event16_2=EVENT_740
	cs_set_enter_map_screen_fade byte1=0xFF byte2=0xFF
	cs_warp_cmd_8038040_2 byte1=0x80 byte2=0x00 ptr3=NULL
	cs_chatbox_cmd_8037a70
	cs_unlock_player_after_non_npc_dialogue_809e122
	cs_end_for_map_reload_maybe_8037c64
	cs_end_for_map_reload_maybe_8037c64
	cs_end_for_map_reload_maybe_8037c64
	cs_end_for_map_reload_maybe_8037c64

	thumb_func_end sprite_queueIndexedOamEntry

// symdb: BattleObject dispatch — read the 1-byte state at [r5] and tail-jump to one of 34 state-specific handlers, returning their NZ-flag as boolean in r0.
// symdb: (r5 = BattleObject*, r10 = Toolkit*) -> r0 = bool (r0==0 false, non-zero true) ; side effects:
// symdb: full state handler called via jump table at 0x80895C0; clobbers r0-r3,r6,r12,lr; preserves
// symdb: r4,r5,r7-r10
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_runUpdateJumpTable_80895A8.yaml
	thumb_local_start
battleObject_runUpdateJumpTable_80895A8:
	push {r4-r7,lr}
	mov r7, #0x70 
	add r7, r7, r5
	ldrb r0, [r5]
	ldr r1, off_80895BC // =jt_80895C0 
	ldr r0, [r1,r0]
	mov lr, pc
	bx r0
loc_80895B8:
	tst r0, r0
	pop {r4-r7,pc}
off_80895BC:
	.word jt_80895C0
jt_80895C0:
	.word owPlayer_beastOutFacingStep+1
	.word sub_80896B0+1
	.word sub_80896C4+1
	.word battle_scenarioEffectInputStep+1
	.word sub_8089792+1
	.word battleObject_beastOut_checkOrInit_80897A6+1
	.word beastOverworldAi_decideTransformOrIdle_8089C16+1
	.word sub_8089C78+1
	.word battle_tickChipLockoutAndFade_80897E8+1
	.word sub_8089808+1
	.word battle_chipLockoutExpiredSetState+1
	.word battle_initBeastOutAiTurn_808983A+1
	.word battle_tickBeastSp_808985A+1
	.word sub_808989C+1
	.word battleObject_beastModeAiPhaseInit_80898B2+1
	.word battle_processChipLockout+1
	.word ai_setStateIfTeamAlive+1
	.word owPlayer_cutsceneTurnAnimStep+1
	.word battle_chipLockoutExpire+1
	.word sub_808997E+1
	.word sub_808999C+1
	.word sub_80899D8+1
	.word object_stepRunCameraScriptOnLastActor+1
	.word battleObject_beastOutActivate_8089A10+1
	.word battle_handleChipLockoutTransition_8089A60+1
	.word ai_chipLockoutWaitState+1
	.word battle_handleBeastOutStep_8089AE8+1
	.word battle_tickChipLockoutLockoutAndAttack_8089B2E+1
	.word owPlayer_handleBeastSpawnTransition_8089B54+1
	.word sub_8089B7E+1
	.word sub_8089B94+1
	.word battle_waitChipLockoutEnd+1
	.word ai_event745OnceInit+1
	.word battle_aiChipLockoutWait+1
	.word ai_setupStateTimer1C+1
	thumb_func_end battleObject_runUpdateJumpTable_80895A8

// symdb: Overworld Beast-Out step: sets player facing then plays the matching fixed animation (facing value as id on the zero path, table-indexed 0x29–0x2C on the nonzero path), clears AIData+0x18 or runs a sub-chain, and writes the next state byte (0x74 or 4) into [r5].
// symdb: (r0 = arg passed to sub_814219C, r5 = caller object whose first byte is the next state) -> r0 =
// symdb: 1 always; flags from sub_814219C branch
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/owPlayer_beastOutFacingStep.yaml
	thumb_local_start
owPlayer_beastOutFacingStep:
	push {r4-r7,lr}
	bl e_scenarioEffectStateCountersAnySet
	bne loc_808966E
	mov r0, #4
	bl SetOWPlayerFacingDirection
	bl GetOWPlayerFacingDirection
	bl owPlayer_setS200ace0_fixedAnimationSelect_809e13c
	mov r0, #0
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x74 
	strb r0, [r5]
	b loc_80896A0
loc_808966E:
	bl selectSoulWeaponCursorDir
	mov r4, r0
	bl sub_8142990
	mov r1, r4
	bl getSoulWeaponCursorDir8
	bl SetOWPlayerFacingDirection
	bl GetOWPlayerFacingDirection
	ldr r1, off_80896A4 // =byte_80896A8 
	ldrb r0, [r1,r0]
	bl owPlayer_setS200ace0_fixedAnimationSelect_809e13c
	bl battle_initBeastSpAIChipQueues
	mov r0, #0
	bl e_setScenarioEffectStateB
	bl cutscene_startCameraScript
	mov r0, #4
	strb r0, [r5]
loc_80896A0:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_80896A4:
	.word byte_80896A8
byte_80896A8:
	.byte 0xFF, 0x29, 0xFF, 0x2A, 0xFF, 0x2B, 0xFF, 0x2C
	thumb_func_end owPlayer_beastOutFacingStep

	thumb_local_start
sub_80896B0:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x13]
	tst r0, r0
	bne loc_80896C0
	bl sub_8089CF8
	mov r0, #0xc
	strb r0, [r5]
loc_80896C0:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_80896B0

	thumb_local_start
sub_80896C4:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x13]
	tst r0, r0
	bne loc_80896D0
	mov r0, #0xc
	strb r0, [r5]
loc_80896D0:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_80896C4

// symdb: State-machine step for the scenario effect screen: polls the chip-select input handler and either starts the camera script or advances the state byte to 0x10/0x18 depending on which button was pressed.
// symdb: (no args; r5 = caller-set pointer to a state/state-machine byte) -> r0 = 1 always; no flags used
// symdb: by caller
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_scenarioEffectInputStep.yaml
	thumb_local_start
battle_scenarioEffectInputStep:
	push {r4-r7,lr}
	bl battleObject_scenarioEffectInputHandler_8089704
	beq loc_8089700
	cmp r0, #1
	beq loc_80896FA
	cmp r0, #2
	beq loc_80896F4
	bl camera_startCutsceneScript
	mov r0, #1
	bl sub_80468EC
	mov r0, #0x18
	strb r0, [r5]
	b loc_8089700
loc_80896F4:
	mov r0, #0x10
	strb r0, [r5]
	b loc_8089700
loc_80896FA:
	bl cutscene_startCameraScript
	b loc_8089700
loc_8089700:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_scenarioEffectInputStep

// symdb: Battle custom-screen handler that maps joypad (A/B/L/R) inputs over the active scenario-effect slot in the chip-select state, playing the appropriate cue and returning a non-zero code on a successful change.
// symdb: in (r10 = toolkit, lr) -> r0 = 0 (no change) / 1 (select changed) / 2 (confirm) / 3 (cancel) ;
// symdb: side effects: PlaySoundEffect, mutation of scenario-effect state field via sub_81421C8, and
// symdb: reads scenario-effect active flag and sub_8142A84.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_scenarioEffectInputHandler_8089704.yaml
	thumb_local_start
battleObject_scenarioEffectInputHandler_8089704:
	push {r4-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	ldrh r7, [r7,#2]
	mov r4, #0
	mov r0, #1
	tst r0, r7
	beq loc_8089738
	bl battle_getScenarioEffectStateField_81421D0
	bl battle_checkScenarioEffectActive_8142190
	beq loc_8089730
	bl sub_8142A84
	beq loc_808972E
	mov r0, #SOUND_SELECT_67
	bl PlaySoundEffect
	mov r4, #2
	b loc_808978C
loc_808972E:
	b loc_808978C
loc_8089730:
	mov r0, #SOUND_CANT_JACK_IN
	bl PlaySoundEffect
	b loc_808978C
loc_8089738:
	mov r0, #2
	tst r0, r7
	beq loc_8089748
	mov r0, #SOUND_UNSELECT_68
	bl PlaySoundEffect
	mov r4, #3
	b loc_808978C
loc_8089748:
	mov r7, r10
	ldr r7, [r7,#oToolkit_JoypadPtr]
	ldrh r7, [r7,#4]
	mov r0, #0x40 
	tst r0, r7
	beq loc_808976C
	mov r0, #0x66 
loc_8089756:
	bl PlaySoundEffect
	bl battle_getScenarioEffectStateField_81421D0
	sub r0, #1
	bge loc_8089764
	mov r0, #3
loc_8089764:
	bl e_setScenarioEffectStateB
	mov r4, #1
	b loc_808978C
loc_808976C:
	mov r0, #0x80
	tst r0, r7
	beq loc_808978C
	mov r0, #SOUND_UNK_66
	bl PlaySoundEffect
	bl battle_getScenarioEffectStateField_81421D0
	add r0, #1
	cmp r0, #4
	blt loc_8089784
	mov r0, #0
loc_8089784:
	bl e_setScenarioEffectStateB
	mov r4, #1
	b loc_808978C
loc_808978C:
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end battleObject_scenarioEffectInputHandler_8089704

	thumb_local_start
sub_8089792:
	push {r4-r7,lr}
	bl battle_getScenarioEffectStateField_81421D0
	add r0, #2
	bl ai_runChatScript
	mov r0, #0x14
	strb r0, [r5]
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_8089792

// symdb: Beast-Out AI/sub-behavior tick that, when not yet active, gates on chatbox state and either triggers the Beast-Out scenario or starts the timer-driven Beast-Out state, writing state bytes to the AIData/AIState pointed at by r5.
// symdb: (r0 = unused, r1 = unused, r2 = unused, r3 = unused, r5 = AIData/AIState object ptr) -> r0 = 1
// symdb: (always) ; side effects: writes state fields in *r5, calls chatbox/Battle scenario helpers
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_beastOut_checkOrInit_80897A6.yaml
	thumb_local_start
battleObject_beastOut_checkOrInit_80897A6:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x13]
	tst r0, r0
	bne loc_80897E4
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_80897E4
	bl chatbox_GetState_8045F4C
	cmp r0, #0
	beq loc_80897C8
	bl battle_initBeastSpAIChipQueues
	mov r0, #0xc
	strb r0, [r5]
	b loc_80897E4
loc_80897C8:
	bl ow_freeMapObjectTrio
	bl battle_getScenarioEffectStateField_81421D0
	bl sub_81421B2
	mov r0, #1
	bl sub_80468EC
	mov r0, #0xa
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x20 
	strb r0, [r5]
loc_80897E4:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battleObject_beastOut_checkOrInit_80897A6

// symdb: Per-frame handler: if eFlags2009F38 bit 0x80 is unset, tick chip lockout via sub_8089CB4 and on its non-zero return trigger a screen fade (0x4 / 0xff) and write 0x24 to the r5-pointed state's byte; always returns 1
// symdb: (r5 = battle state pointer) -> r0 = 1 ; side effects: may call SetScreenFade(4, 0xff) and store
// symdb: 0x24 to [r5]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_tickChipLockoutAndFade_80897E8.yaml
	thumb_local_start
battle_tickChipLockoutAndFade_80897E8:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_8089804
	bl battle_tickChipLockout_8089CB4
	beq loc_8089804
	mov r0, #4
	mov r1, #0xff
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x24 
	strb r0, [r5]
loc_8089804:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_tickChipLockoutAndFade_80897E8

	thumb_local_start
sub_8089808:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_8089822
	mov r0, #0
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #5
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x28 
	strb r0, [r5]
loc_8089822:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_8089808

// symdb: Per-frame battle tick: when the chip-use lockout timer runs out, calls an unknown handler and writes state 0x2C to the battle work byte at r5.
// symdb: () -> r0 = 1 always; r5 must already point to the battle-state struct; reads/writes
// symdb: ChipLockoutTimer (AIData+0x18) via callee
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_chipLockoutExpiredSetState.yaml
	thumb_local_start
battle_chipLockoutExpiredSetState:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_8089836
	bl sub_8142BB6
	mov r0, #0x2c 
	strb r0, [r5]
loc_8089836:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_chipLockoutExpiredSetState

// symdb: Initializes AI state for a BeastOut attack turn during the first non-faded frame after a scene fade ends.
// symdb: (r5 = AIData*, r7 = ?BattleObject*, lr) -> r0 = 1 ; no other side effects observable from
// symdb: callers
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_initBeastOutAiTurn_808983A.yaml
	thumb_local_start
battle_initBeastOutAiTurn_808983A:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_8089856
	bl battle_initAIChipQueueSlot3
	bl battleScenarioEffect_isActive_814216E
	str r0, [r7,#0xc]
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x30 
	strb r0, [r5]
loc_8089856:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_initBeastOutAiTurn_808983A

// symdb: Per-frame BeastOut/SP-cust cursor lockout/orchestration step for a battle actor; sets sub-action byte and returns 1
// symdb: (r5 = AIData-like struct, r7 = battle state?, r10 = Toolkit) -> r0 = 1 ; side effects: writes
// symdb: sub-action byte at [r5]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_tickBeastSp_808985A.yaml
	thumb_local_start
battle_tickBeastSp_808985A:
	push {r4-r7,lr}
	mov r0, #0
	bl battle_countAliveActorsOnTeam_8142C20
	mov r4, r0
	bl battleScenarioEffect_isActive_814216E
	cmp r0, r4
	bne loc_8089898
	bl battle_tickChipLockout_8089CB4
	beq loc_8089898
	bl battleScenarioEffect_isActive_814216E
	ldr r1, [r7,#0xc]
	cmp r0, r1
	beq loc_8089882
	mov r0, #0x34 
	strb r0, [r5]
	b loc_8089898
loc_8089882:
	bl sub_8142ADA
	bne loc_8089892
	bl camera_startCutsceneScript
	mov r0, #0x18
	strb r0, [r5]
	b loc_8089898
loc_8089892:
	mov r0, #0x3c 
	strb r0, [r5]
	b loc_8089898
loc_8089898:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_tickBeastSp_808985A

	thumb_local_start
sub_808989C:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_80898AE
	mov r0, #7
	bl ai_runChatScript
	mov r0, #0x38 
	strb r0, [r5]
loc_80898AE:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_808989C

// symdb: Picks the next AI sub-phase for a Beast-mode battle object by picking one of three PwrAtk phase IDs (0x5C / 0x18 / 0x3C) into the AI's Unk_18 state byte.
// symdb: (r5 = ...AIData) -> r0 = 1 ; side effect: stores a u8 to [r5+0x18], possibly calls init helpers
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_beastModeAiPhaseInit_80898B2.yaml
	thumb_local_start
battleObject_beastModeAiPhaseInit_80898B2:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_80898E4
	bl battleScenarioEffect_isActive_814216E
	bne loc_80898CE
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x5c 
	strb r0, [r5]
	b loc_80898E4
loc_80898CE:
	bl sub_8142ADA
	bne loc_80898DE
	bl camera_startCutsceneScript
	mov r0, #0x18
	strb r0, [r5]
	b loc_80898E4
loc_80898DE:
	mov r0, #0x3c 
	strb r0, [r5]
	b loc_80898E4
loc_80898E4:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battleObject_beastModeAiPhaseInit_80898B2

// symdb: Per-frame chip-lockout handler: decrements AIData+0x18 via battle_tickChipLockout_8089CB4; if the timer has not expired it returns 1 immediately, else calls sub_8142BFA, writes 0x40 to [r5] and returns 1.
// symdb: (r5 = some battle/AI struct pointer, set by caller) -> r0 = 1 always; calls
// symdb: battle_tickChipLockout_8089CB4 and sub_8142BFA
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_processChipLockout.yaml
	thumb_local_start
battle_processChipLockout:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_80898F8
	bl sub_8142BFA
	mov r0, #0x40 
	strb r0, [r5]
loc_80898F8:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_processChipLockout

// symdb: If any actor on team 0x10 is still alive, triggers an AI action, loads a 30-frame value into AIData+0x18, and sets the AI state byte to 0x44; always returns 1.
// symdb: (no meaningful args; r5 = AI/entity context set up by callee) -> r0 = 1; flags from tst r0,r0
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ai_setStateIfTeamAlive.yaml
	thumb_local_start
ai_setStateIfTeamAlive:
	push {r4-r7,lr}
	mov r0, #0x10
	bl battle_countAliveActorsOnTeam_8142C20
	tst r0, r0
	beq loc_8089918
	mov r0, #8
	bl ai_runChatScript
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x44 
	strb r0, [r5]
loc_8089918:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end ai_setStateIfTeamAlive

// symdb: Cutscene/object step that, after a short delay, makes the overworld player turn toward a fixed direction and play a fixed animation while a cutscene camera script runs.
// symdb: (r5 = object/AIData struct) -> r0 = 1 (step continues/finished); no meaningful flags
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/owPlayer_cutsceneTurnAnimStep.yaml
	thumb_local_start
owPlayer_cutsceneTurnAnimStep:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_808994E
	bl battle_tickChipLockout_8089CB4
	beq loc_808994E
	bl getSoulWeaponCursorDir8ByEffect
	bl SetOWPlayerFacingDirection
	bl GetOWPlayerFacingDirection
	ldr r1, off_8089954 // =byte_8089958 
	ldrb r0, [r1,r0]
	bl owPlayer_setS200ace0_fixedAnimationSelect_809e13c
	bl camera_startCutsceneScript
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x48 
	strb r0, [r5]
loc_808994E:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_8089954:
	.word byte_8089958
byte_8089958:
	.byte 0xFF, 0x2E, 0xFF, 0x2F, 0xFF, 0x30, 0xFF, 0x31
	thumb_func_end owPlayer_cutsceneTurnAnimStep

// symdb: When called each frame for an entity with a chip-lockout timer: if the [r5+0x13] flag is clear, ticks the lockout timer; if the ticker reports the lockout just expired, starts a mode-4 screen fade via SetScreenFade(4,0xFF) and transitions the entity's state byte at [r5] to 0x4C. Always returns 1.
// symdb: (r5 = entity/AI struct, set by caller) -> r0 = 1 always; calls SetScreenFade(4, 0xFF) and stores
// symdb: state 0x4C on expiry
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_chipLockoutExpire.yaml
	thumb_local_start
battle_chipLockoutExpire:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x13]
	tst r0, r0
	bne loc_808997A
	bl battle_tickChipLockout_8089CB4
	beq loc_808997A
	mov r0, #4
	mov r1, #0xff
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #0x4c 
	strb r0, [r5]
loc_808997A:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_chipLockoutExpire

	thumb_local_start
sub_808997E:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_8089998
	mov r0, #0
	mov r1, #0x10
	bl SetScreenFade // (int a1, int a2) -> void
	mov r0, #5
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x50 
	strb r0, [r5]
loc_8089998:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_808997E

	thumb_local_start
sub_808999C:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_80899D4
	bl e_popScenarioEffectEntry
	tst r0, r0
	beq loc_80899B2
	bl ow_dealDamageToCurrentNavi
	b loc_80899C2
loc_80899B2:
	bl e_clearScenarioEffectStateFlag
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x54 
	strb r0, [r5]
	b loc_80899D4
loc_80899C2:
	bl GetCurPETNavi // () -> u8
	bl GetMaxAndCurHPForCurPETNavi_80010D4 // (which_navi: u8) -> (u16, u16)
	tst r0, r0
	beq loc_80899B2
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
loc_80899D4:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_808999C

	thumb_local_start
sub_80899D8:
	push {r4-r7,lr}
	bl IsScreenFadeActive // () -> zf
	beq loc_80899EE
	bl battle_tickChipLockout_8089CB4
	beq loc_80899EE
	bl sub_8142BF4
	mov r0, #0x58 
	strb r0, [r5]
loc_80899EE:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_80899D8

// symdb: Step that, when only one actor remains alive on team 0 (battleScenarioEffect_isActive_814216E returns 1), runs camera_startCutsceneScript and writes 0x18 into the byte at r5; otherwise does nothing; always returns 1.
// symdb: (r5 = cutscene/camera object pointer, fields read/written via [r5]) -> r0 = 1 always; sets [r5]
// symdb: = 0x18 and launches camera script when counts match, else nothing.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/object_stepRunCameraScriptOnLastActor.yaml
	thumb_local_start
object_stepRunCameraScriptOnLastActor:
	push {r4-r7,lr}
	mov r0, #0
	bl battle_countAliveActorsOnTeam_8142C20
	mov r4, r0
	bl battleScenarioEffect_isActive_814216E
	cmp r0, r4
	bne loc_8089A0C
	bl camera_startCutsceneScript
	mov r0, #0x18
	strb r0, [r5]
loc_8089A0C:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end object_stepRunCameraScriptOnLastActor

// symdb: Beast-Out activation handler for a battle object: when its chip-lockout flag clears, look up the soul-weapon script and start its Beast-Out camera/AI.
// symdb: (r5 = BattleObjectAIDataPtr) -> r0 = 1 ; sets AIData Unk_3c / Unk_13 / Unk_18 / byte0, calls
// symdb: cutscene camera + AI helpers
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_beastOutActivate_8089A10.yaml
	thumb_local_start
battleObject_beastOutActivate_8089A10:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_8089A36
	bl GetSoulWeaponsMapIndex
	ldr r1, off_8089A3C // =off_8089A40 
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	str r0, [r5,#0x3c]
	bl SetCutsceneCameraScript
	mov r0, #1
	strb r0, [r5,#0x13]
	mov r0, #0x3c 
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x60 
	strb r0, [r5]
loc_8089A36:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_8089A3C:
	.word off_8089A40
off_8089A40:
	.word byte_8089494
	.word byte_808949C
	.word byte_80894A4
	.word byte_80894AC
	.word byte_80894B4
	.word byte_80894BC
	.word byte_80894C4
	.word byte_80894CC
	thumb_func_end battleObject_beastOutActivate_8089A10

// symdb: Drives the chip-lockout state transition in battle: clears/updates event flags, plays the appropriate map music (Forte/SoulWeapons-gated), then resets the chip-lockout timer/state to 0x64 and returns 1.
// symdb: () -> r0 = 1 ; side effects: clears/sets event flags, mutates GameState->Unk_15, plays map music
// symdb: via sub_8035408 / PlaySoundEffect(0x164) / playCertainMapMusicBasedOnEventByte_8036e44 +
// symdb: PlayMapMusic, calls sub_8089CB0(0x1e), writes 0x64 to a battle-object byte at [r5]
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_handleChipLockoutTransition_8089A60.yaml
	thumb_local_start
battle_handleChipLockoutTransition_8089A60:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_8089AC6
	bl battle_getSoulWeaponBase_81427CE
	mov r0, r0
	bl ClearEventFlag // (u16 entryFlagBitfield) -> void
	bl e_scenarioEffectStateCountersAnySet
	str r0, [r7,#0x10]
	bl e_clearScenarioEffectValue
	movflag EVENT_740
	bl SetEventFlagFromImmediate
	movflag EVENT_225
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	mov r0, r10
	ldr r0, [r0,#oToolkit_GameStatePtr]
	mov r1, #0
	strb r1, [r0,#oGameState_SavedByte]
	movflag EVENT_28
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_8089ABA
	bl GetSoulWeaponsMapIndex
	cmp r0, #6
	bge loc_8089ABA
	bl sprite_loadBeastSpAnims
	mov r0, #0x65 
	add r0, #0xff
	bl PlaySoundEffect
	bl playCertainMapMusicBasedOnEventByte_8036e44
	bl PlayMapMusic // () -> ()
loc_8089ABA:
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x64 
	strb r0, [r5]
	b loc_8089AC6
loc_8089AC6:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_handleChipLockoutTransition_8089A60

// symdb: AI state handler that idles while the chip lockout timer runs, then on expiry performs an action, restarts the 30-frame lockout, and switches the AI state to 0x68.
// symdb: (r5 = AIData struct pointer, r0 unused on entry) -> r0 = 1 always; flags from
// symdb: battle_tickChipLockout used internally
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ai_chipLockoutWaitState.yaml
	thumb_local_start
ai_chipLockoutWaitState:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_8089AE4
	mov r0, #0xc
	bl ai_runChatScript
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x68 
	strb r0, [r5]
	b loc_8089AE4
loc_8089AE4:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end ai_chipLockoutWaitState

// symdb: Beast-out AI step: when chatbox/cutscene flag 0x80 is clear, advance chip-lockout and decide the controlled beast's next facing/animation state.
// symdb: (r0 = toolkit via r10, r5 = battleObject, r7 = ?, lr) -> r0 = 1 ; side effects: clears PanelY in
// symdb: battle object, sets OW player facing to 4 (down), pushes a fixed OW player animation via
// symdb: eStruct200ace0, rewrites battle object byte0 to either 0x70 or 0x6c, calls sub_8089CB0(0|0x1e)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_handleBeastOutStep_8089AE8.yaml
	thumb_local_start
battle_handleBeastOutStep_8089AE8:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_8089B2A
	bl battle_tickChipLockout_8089CB4
	beq loc_8089B2A
	bl cutsceneCamera_focusCameraOnPlayerMaybe_8036faa
	mov r0, #0
	strb r0, [r5,#0x13]
	mov r0, #4
	bl SetOWPlayerFacingDirection
	bl GetOWPlayerFacingDirection
	bl owPlayer_setS200ace0_fixedAnimationSelect_809e13c
	ldr r0, [r7,#0x10]
	tst r0, r0
	bne loc_8089B20
	mov r0, #0
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x70 
	strb r0, [r5]
	b loc_8089B2A
loc_8089B20:
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x6c 
	strb r0, [r5]
loc_8089B2A:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_handleBeastOutStep_8089AE8

// symdb: AI handler that locks the chip queue and queues a PwrAtk chip when the chip lockout timer is active.
// symdb: (r5 = AIData*, r7 = ?, r10 = Toolkit*) -> r0 = 1 ; side effects: writes AIData[0x18]=0x70, calls
// symdb: chatbox_8045EDC with r1=Toolkit+0x10, calls sub_8089CA4(0x11), calls sub_8089CB0(0x1e).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_tickChipLockoutLockoutAndAttack_8089B2E.yaml
	thumb_local_start
battle_tickChipLockoutLockoutAndAttack_8089B2E:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_8089B50
	mov r0, #2
	ldr r1, [r7,#0x10]
	bl chatbox_8045EDC
	mov r0, #0x11
	bl ai_runChatScript
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x70 
	strb r0, [r5]
	b loc_8089B50
loc_8089B50:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_tickChipLockoutLockoutAndAttack_8089B2E

// symdb: Overworld player handler that, when chatbox event flag 0x80 is set, finishes a BeastOut spawn by facing the player toward their navi, kicking off its fixed animation and clearing a request BBS flag, then writes 0x18 into the AI state's byte at r5.
// symdb: (r5 = ptr to AI/BattleObject state, r10 = toolkit) -> r0 = 1 ; sets BYTE [r5+?] = 0x18, mutates
// symdb: OWPlayer facing and eStruct200ace0, clears flag in oReqBBS2001150
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/owPlayer_handleBeastSpawnTransition_8089B54.yaml
	thumb_local_start
owPlayer_handleBeastSpawnTransition_8089B54:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_8089B7A
	bl battle_tickChipLockout_8089CB4
	beq loc_8089B7A
	mov r0, #4
	bl SetOWPlayerFacingDirection
	bl GetOWPlayerFacingDirection
	bl owPlayer_setS200ace0_fixedAnimationSelect_809e13c
	bl reqBBS_clearFlag_8140A0C
	mov r0, #0x18
	strb r0, [r5]
loc_8089B7A:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end owPlayer_handleBeastSpawnTransition_8089B54

	thumb_local_start
sub_8089B7E:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_8089B90
	mov r0, #0
	bl ai_runChatScript
	mov r0, #0x78 
	strb r0, [r5]
loc_8089B90:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_8089B7E

	thumb_local_start
sub_8089B94:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_8089BA6
	mov r0, #1
	strb r0, [r5,#8]
	mov r0, #0
	pop {r4-r7,pc}
loc_8089BA6:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end sub_8089B94

// symdb: Battle-side handler that idles while the chip lockout timer runs, then once it expires fires an action (0xD) and sets an 0x80 flag.
// symdb: (r5 = state object whose byte field receives 0x80) -> r0 = 1 always; no flags guaranteed
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_waitChipLockoutEnd.yaml
	thumb_local_start
battle_waitChipLockoutEnd:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_8089BBC
	mov r0, #0xd
	bl ai_runChatScript
	mov r0, #0x80
	strb r0, [r5]
loc_8089BBC:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_waitChipLockoutEnd

// symdb: One-time AI trigger: if chatbox flag bit 0x80 is clear, sets event 745 and resets the entity's AI state, then returns 1.
// symdb: (r5 = AI/entity control struct) -> r0 = 1 always; sets EVENT_745 when flag bit 0x80 was clear
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ai_event745OnceInit.yaml
	thumb_local_start
ai_event745OnceInit:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_8089BE0
	movflag EVENT_745
	bl SetEventFlagFromImmediate
	mov r0, #0
	strb r0, [r5,#8]
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x1c
	strb r0, [r5]
loc_8089BE0:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end ai_event745OnceInit

// symdb: AI routine that waits until the chip lockout timer expires, then issues action 0xE and stores state 0x88 before returning 1.
// symdb: (implicit r5 = byte state field pointer) -> r0 = 1 always; flags from battle_tickChipLockout
// symdb: result inside
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_aiChipLockoutWait.yaml
	thumb_local_start
battle_aiChipLockoutWait:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_8089BF6
	mov r0, #0xe
	bl ai_runChatScript
	mov r0, #0x88
	strb r0, [r5]
loc_8089BF6:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end battle_aiChipLockoutWait

// symdb: AI step that, unless event flag 0x80 (of eFlags2009F38) is set, resets the AI object's state byte and starts a 0x1E-frame timer in AIData.
// symdb: (r5 = AIData struct pointer, r0/r1 unused on entry) -> r0 = 1 (always); sets byte AIData+0x00 =
// symdb: 0x1C, byte AIData+0x08 = 0, halfword AIData+0x18 = 0x1E
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ai_setupStateTimer1C.yaml
	thumb_local_start
ai_setupStateTimer1C:
	push {r4-r7,lr}
	mov r0, #0x80
	bl chatbox_mask_eFlags2009F38 // (int flag) -> int
	bne loc_8089C12
	mov r0, #0
	strb r0, [r5,#8]
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x1c
	strb r0, [r5]
loc_8089C12:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end ai_setupStateTimer1C

// symdb: Beast-mode overworld AI step: drives transform/fail handling by inspecting the current PET navi and HP, sets the OW player animation, then writes a new state byte.
// symdb: (r5 = AIData ptr, r10 = Toolkit ptr) -> r0 = 1 ; side effects: writes AIData+0x00, AIData+0x08,
// symdb: AIData+0x13, anim field in s200ace0, possibly raises event 0x1719 via
// symdb: owPlayer_setS200ace0_fixedAnimationSelect_809e13c
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/beastOverworldAi_decideTransformOrIdle_8089C16.yaml
	thumb_local_start
beastOverworldAi_decideTransformOrIdle_8089C16:
	push {r4-r7,lr}
	ldrb r0, [r5,#0x13]
	tst r0, r0
	bne loc_8089C74
	mov r0, #1
	strb r0, [r5,#8]
	bl GetCurPETNavi // () -> u8
	bl GetMaxAndCurHPForCurPETNavi_80010D4 // (which_navi: u8) -> (u16, u16)
	tst r0, r0
	bne loc_8089C4A
	strb r0, [r5,#8]
	bl GetCurPETNavi // () -> u8
	cmp r0, #0
	bne loc_8089C3E
	mov r0, #0x3a 
	bl owPlayer_setS200ace0_fixedAnimationSelect_809e13c
loc_8089C3E:
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x84
	strb r0, [r5]
	b loc_8089C74
loc_8089C4A:
	bl GetOWPlayerFacingDirection
	bl owPlayer_setS200ace0_fixedAnimationSelect_809e13c
	mov r0, #0x1e
	bl ai_setAIDataUnk18_8089CB0
	bl battleScenarioEffect_isActive_814216E
	beq loc_8089C6A
	bl e_scenarioEffectStateCountersAnySet
	bne loc_8089C6A
	mov r0, #0x7c 
	strb r0, [r5]
	b loc_8089C74
loc_8089C6A:
	mov r0, #0
	bl ai_setAIDataUnk18_8089CB0
	mov r0, #0x1c
	strb r0, [r5]
loc_8089C74:
	mov r0, #1
	pop {r4-r7,pc}
	thumb_func_end beastOverworldAi_decideTransformOrIdle_8089C16

	thumb_local_start
sub_8089C78:
	push {r4-r7,lr}
	bl battle_tickChipLockout_8089CB4
	beq loc_8089C9A
	bl cutsceneCamera_focusCameraOnPlayerMaybe_8036faa
	mov r0, #0
	strb r0, [r5,#0x13]
	bl GetSoulWeaponsMapIndex
	ldr r1, off_8089CA0 // =byte_80894D4
	mov r2, #0x10
	mul r2, r0
	add r1, r1, r2
	str r1, [r5,#0x34]
	mov r0, #0
	pop {r4-r7,pc}
loc_8089C9A:
	mov r0, #1
	pop {r4-r7,pc}
	.balign 4, 0
off_8089CA0:
	.word byte_80894D4
	thumb_func_end sub_8089C78

// symdb: Wrapper that forwards r0 (script index) and the TextScriptArchive* at [r5+0x30] to chatbox_runScript, queuing the AI-controlled entity's dialogue script.
// symdb: (r0 = script index u8; r5 = AI/context struct whose +0x30 holds TextScriptArchive*) -> r0 =
// symdb: chatbox_runScript return; calls chatbox_runScript(archive=[r5+0x30], idx=r0)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ai_runChatScript.yaml
	thumb_local_start
ai_runChatScript:
	push {r4-r7,lr}
	mov r1, r0
	ldr r0, [r5,#0x30]
	bl chatbox_runScript // (archive: *const TextScriptArchive, script_idx: u8) -> ()
	pop {r4-r7,pc}
	thumb_func_end ai_runChatScript

// symdb: Stores the halfword from r0 into AIData+0x18 (Unk_18) of the AIData struct pointed to by r5.
// symdb: (r0 = halfword value, r5 = AIData*) -> (none, void); side effect: *(AIData* r5 + 0x18) = r0 as
// symdb: u16
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ai_setAIDataUnk18_8089CB0.yaml
	thumb_local_start
ai_setAIDataUnk18_8089CB0:
	strh r0, [r5,#0x18]
	mov pc, lr
	thumb_func_end ai_setAIDataUnk18_8089CB0

// symdb: decrements ChipLockoutTimer (AIData+0x18) and returns whether it hit/exceeded zero this frame
// symdb: (r5 = *AIData) -> r0 = 0 if timer remained >0 after decrement, 1 if it reached 0 or was already
// symdb: <=0; r0 holds the new timer value on the 0 path
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_tickChipLockout_8089CB4.yaml
	thumb_local_start
battle_tickChipLockout_8089CB4:
	ldrh r0, [r5,#0x18]
	sub r0, #1
	blt loc_8089CC0
	strh r0, [r5,#0x18]
	mov r0, #0
	mov pc, lr
loc_8089CC0:
	mov r0, #1
	mov pc, lr
	thumb_func_end battle_tickChipLockout_8089CB4

// symdb: Cutscene step that loads camera script byte_8089480 into a context object and starts it playing.
// symdb: (r5 = scenario/cutscene context object; args unused) -> r0 clobbered; stores camera script ptr
// symdb: at [r5,#0x3c], sets byte [r5,#0x13] = 1
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/cutscene_startCameraScript.yaml
	thumb_local_start
cutscene_startCameraScript:
	push {r4-r7,lr}
	bl battleObject_scenarioEffectInitPlayerOffsetMatrix_81429CA
	ldr r0, off_8089CD8 // =byte_8089480
	str r0, [r5,#0x3c]
	bl SetCutsceneCameraScript
	mov r0, #1
	strb r0, [r5,#0x13]
	pop {r4-r7,pc}
	.balign 4, 0
off_8089CD8:
	.word byte_8089480
	thumb_func_end cutscene_startCameraScript

// symdb: Cutscene-object step that launches a fixed camera script and flags the object as camera-active.
// symdb: (r5 = cutscene/state object, r0 = ignored on entry) -> r0 = 0 from callees; stores camera script
// symdb: pointer at [r5+0x3C], sets byte [r5+0x13] = 1
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/camera_startCutsceneScript.yaml
	thumb_local_start
camera_startCutsceneScript:
	push {r4-r7,lr}
	ldr r0, off_8089CF4 // =byte_808948A
	str r0, [r5,#0x3c]
	bl SetCutsceneCameraScript
	mov r0, #1
	strb r0, [r5,#0x13]
	bl ow_freeMapObjectTrio
	bl battle_initAIChipQueueSlot3
	pop {r4-r7,pc}
	.balign 4, 0
off_8089CF4:
	.word byte_808948A
	thumb_func_end camera_startCutsceneScript

	thumb_local_start
sub_8089CF8:
	push {r4-r7,lr}
	mov r4, #0
loc_8089CFC:
	mov r0, #0x12
	bl sub_8004822
	str r5, [r7]
	add r7, #4
	add r4, #1
	cmp r4, #3
	blt loc_8089CFC
	pop {r4-r7,pc}
	thumb_func_end sub_8089CF8

// symdb: Frees up to three overworld map objects whose pointers are stored consecutively in a caller-provided array.
// symdb: (r7 = base of array of 3 object pointers) -> r0 = last FreeOverworldMapObject result; frees each
// symdb: non-null entry, leaving the array contents unchanged
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ow_freeMapObjectTrio.yaml
	thumb_local_start
ow_freeMapObjectTrio:
	push {r4-r7,lr}
	mov r4, #0
loc_8089D12:
	ldr r5, [r7]
	tst r5, r5
	beq loc_8089D1C
	bl FreeOverworldMapObject
loc_8089D1C:
	add r7, #4
	add r4, #1
	cmp r4, #3
	blt loc_8089D12
	pop {r4-r7,pc}
	thumb_func_end ow_freeMapObjectTrio

// symdb: Initializes AI chip-queue slots for two specific battle actors (slots 4 and 3), as part of the Beast SP setup.
// symdb: () -> void; no return value, flags not meaningful
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_initBeastSpAIChipQueues.yaml
	thumb_local_start
battle_initBeastSpAIChipQueues:
	push {r4-r7,lr}
	mov r0, #4
	mov r1, #1
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
	mov r0, #0
	bl sub_80468EC
	mov r0, #3
	mov r1, #0
	mov r2, #1
	bl battleObject_initAIChipQueueSlot_80468C6
	pop {r4-r7,pc}
	thumb_func_end battle_initBeastSpAIChipQueues

// symdb: Resets/initializes the AI chip-queue slot for battle actor slot 3 (called during beast-out battle setup).
// symdb: () -> r0 = 0; no meaningful return
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_initAIChipQueueSlot3.yaml
	thumb_local_start
battle_initAIChipQueueSlot3:
	push {r4-r7,lr}
	mov r0, #0
	bl sub_80468EC
	mov r0, #3
	mov r1, #0
	mov r2, #0
	bl battleObject_initAIChipQueueSlot_80468C6
	// <endpool> <endfile>
	pop {r4-r7,pc}
	thumb_func_end battle_initAIChipQueueSlot3

/*For debugging purposes, connect comment at any range!*/
