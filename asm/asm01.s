
// symdb: Resets the text-printer/chatbox state, clearing its pending word, flags, character slot and both text buffers.
// symdb: void chatbox_resetPrinterState_801FE00(void); /* preserves incoming r2; returns r3 = ptr to
// symdb: printer state at 0x2036780; clobbers r0, r1, lr and flags */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/chatbox_resetPrinterState_801FE00.yaml
	thumb_func_start chatbox_resetPrinterState_801FE00
chatbox_resetPrinterState_801FE00:
	push {lr}
	ldr r3, off_80200B4 // =eStruct203F7D8
	mov r0, #0
	str r0, [r3]
	ldr r3, off_80200B8 // =eStruct2036780
	mov r0, #0
	strh r0, [r3,#0x2] // (eFlags2036782 - 0x2036780)
	mov r0, #0xff
	strb r0, [r3,#0x4] // (byte_2036784 - 0x2036780)
	ldr r0, off_80200BC // =dword_203F4A0 
	ldr r1, off_80200C0 // =0x200 
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	ldr r0, off_80200C4 // =dword_203CBE0 
	ldr r1, off_80200C8 // =0x100 
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	pop {pc}
	thumb_func_end chatbox_resetPrinterState_801FE00

// symdb: Start or restart the battle-effects overlay (0x10) — reset link state when the slot is free and start it in mode 5, otherwise restart in mode 0 — and flag the overlay as active in the battle-effects struct.
// symdb: void sub_801FE24(void); // inputs:  none meaningful (r10/lr inherited) // outputs: r5 r6 r7 set;
// symdb: preserves r4 r5 r6 r7; clobbers r0 r1 r2 r3 lr, N Z C V
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_801FE24.yaml
	thumb_func_start sub_801FE24
sub_801FE24:
	push {r4,lr}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	bne loc_801FE4A
	bl notZero_eByte200AD04
	beq locret_801FE5C
	mov r0, #0
	bl eLinkState_ResetForNewUse_803DE88
	mov r0, #0x10
	mov r1, #0
	mov r2, #2
	mov r3, #5
	bl sub_803DCE8
	b loc_801FE56
loc_801FE4A:
	mov r0, #0x10
	mov r1, #0
	mov r2, #2
	mov r3, #0
	bl sub_803DCE8
loc_801FE56:
	ldr r3, off_80200CC // =eStruct203F7D8
	mov r0, #1
	strb r0, [r3]
locret_801FE5C:
	pop {r4,pc}
	thumb_func_end sub_801FE24

// symdb: Returns a byte from a global battle sub-state struct (offset 0, likely a finished/idle flag) by loading it from EWRAM pointer `eStruct203F7D8`.
// symdb: () -> r0 = eStruct203F7D8[0]; no side effects beyond reading the byte
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_getSubstateFinishedFlag_801FE5E.yaml
	thumb_func_start battle_getSubstateFinishedFlag_801FE5E
battle_getSubstateFinishedFlag_801FE5E:
	ldr r3, off_80200D0 // =eStruct203F7D8
	ldrb r0, [r3]
	mov pc, lr
	thumb_func_end battle_getSubstateFinishedFlag_801FE5E

	thumb_func_start sub_801FE64
sub_801FE64:
	ldr r1, off_80200D4 // =eStruct203F7D8
	mov r0, #0
	strb r0, [r1]
	mov pc, lr
	thumb_func_end sub_801FE64

// symdb: Per-frame battle handler that drives the Custom Gauge state machine (initial copy-in, normal/custom-condition branch and gauge-state writes) for the active battle.
// symdb: (in: r5=cur state byte, r8..r12=toolkit/BattleState-preserved) -> r0 = pointer to eStruct2036780
// symdb: ; side effects: writes eStruct2083197D8 (offsets 0 and 1), may copy 0x10 bytes from
// symdb: unk_20399F0/unk_2039A00 into eStruct2036780.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_updateCustomGauge_801FE6C.yaml
	thumb_func_start battle_updateCustomGauge_801FE6C
battle_updateCustomGauge_801FE6C:
	push {r4,r6,lr}
	ldr r4, off_80200D8 // =eStruct203F7D8
	ldrb r6, [r4,#0x1] // (eStruct203F7D8+1 - 0x203f7d8)
	mov r0, #2
	strb r0, [r4,#0x1] // (eStruct203F7D8+1 - 0x203f7d8)
	ldrb r0, [r4]
	tst r0, r0
	beq loc_801FED2

	movflag EVENT_172D
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_801FEB6

	strb r6, [r4,#0x1] // (eStruct203F7D8+1 - 0x203f7d8)
	ldrb r0, [r4,#0x1] // (eStruct203F7D8+1 - 0x203f7d8)
	cmp r0, #2
	bne locret_801FEE6
	push {r5}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	pop {r5}
	beq locret_801FEE6
	mov r0, #0
	bl sub_8144D04
	cmp r0, #1
	bne loc_801FEB0
	mov r0, #3
	bl sub_8144D04
	cmp r0, #1
	beq locret_801FEE6
loc_801FEB0:
	mov r0, #4
	strb r0, [r4,#0x1] // (eStruct203F7D8+1 - 0x203f7d8)
	b locret_801FEE6
loc_801FEB6:

	push {r5}
	bl GetBattleEffects // () -> int
	mov r1, #8
	tst r0, r1
	pop {r5}
	bne loc_801FECC

	bl battle_updateLinkState_803DEB4
	strb r0, [r4,#0x1] // (eStruct203F7D8+1 - 0x203f7d8)

	b locret_801FEE6
loc_801FECC:
	strb r6, [r4,#0x1] // (eStruct203F7D8+1 - 0x203f7d8)
	ldrb r0, [r4,#0x1] // (eStruct203F7D8+1 - 0x203f7d8)
	b locret_801FEE6
loc_801FED2:
	ldr r0, off_80200DC // =eStruct2036780
	ldr r1, off_80200E0 // =unk_20399F0 
	mov r2, #0x10
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	ldr r0, off_80200E4 // =eStruct2036780
	ldr r1, off_80200E8 // =unk_2039A00 
	mov r2, #0x10
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

locret_801FEE6:
	pop {r4,r6,pc}
	thumb_func_end battle_updateCustomGauge_801FE6C

// symdb: Trivial getter returning the unknown byte field at offset 1 of the global struct eStruct203F7D8.
// symdb: Next eStruct203F7D8_getUnk01(void); returns u8 in r0 (zero-extended byte at eStruct203F7D8+1).
// symdb: Inputs: lr only. No flags read or written; no other registers clobbered.
// symdb: hypothesis; evidence and how to reproduce it: recomp symbols/db/eStruct203F7D8_getUnk01.yaml
	thumb_func_start eStruct203F7D8_getUnk01
eStruct203F7D8_getUnk01:
	ldr r0, off_80200EC // =eStruct203F7D8
	ldrb r0, [r0,#0x1] // (eStruct203F7D8+1 - 0x203f7d8)
	mov pc, lr
	thumb_func_end eStruct203F7D8_getUnk01

// symdb: State-machine dispatcher for eStruct200BC30 that calls one of two handlers selected by the struct's current jump-table slot, passing the original argument through in r0.
// symdb: void eStruct200BC30_dispatchStateHandler_801FEEE(void* arg /*r0*/); preserves r4-r7; returns
// symdb: with c/v (and everything else except r0-r3) as left by the invoked handler
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eStruct200BC30_dispatchStateHandler_801FEEE.yaml
	thumb_func_start eStruct200BC30_dispatchStateHandler_801FEEE
eStruct200BC30_dispatchStateHandler_801FEEE:
	push {r4-r7,lr}

	mov r7, r0

	bl eStruct200BC30_getJumpOffset00
	ldr r1, off_801FF04 // =off_801FF08 
	ldr r2, [r1,r0]

	mov r0, r7
	mov lr, pc
	bx r2

	pop {r4-r7,pc}
	.balign 4, 0
off_801FF04:
	.word off_801FF08
off_801FF08:
	.word sub_801FF18+1
	.word sub_801FFD6+1
	.word sub_801FFD6+1
	.word sub_801FF18+1
	thumb_func_end eStruct200BC30_dispatchStateHandler_801FEEE

// symdb: Battle link-transfer builder (mode 2): packs each connected player's input record into the transfer buffers dword_203F4A0 / dword_203F5A0, and when no link is connected drains one word of dword_203CBE0 per frame into slot eStruct2036780+8, counting down — the no-link loopback that carries the battle seed.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_801FF18.yaml
	thumb_local_start
sub_801FF18:
	push {r4-r7,lr}
	sub sp, sp, #4

	cmp r0, #2
	bne loc_801FFD2

	ldr r4, off_80200F0 // =eStruct203F7D8
	ldr r5, off_80200F4 // =unk_20399F0 
	mov r6, r10
	ldr r6, [r6,#oToolkit_BattleStatePtr]
	ldr r7, off_80200F8 // =dword_203F4A0 
	ldrh r1, [r5,#0x2] // (word_20399F2 - 0x20399f0)
	mov r2, #0xfc
	lsl r2, r2, #8
	and r2, r1
	beq loc_801FF52
	mov r0, #0
	bl input_recordStateChangeForEntry_800A0D6
	ldrb r1, [r5,#0x6] // (byte_20399F6 - 0x20399f0)
	strb r1, [r6,#oBattleState_Unk_14]
	ldrh r1, [r5,#0xc] // (word_20399FC - 0x20399f0)
	ldr r0, off_80200FC // =unk_2036120 
	strh r1, [r0,#0x2c] // (word_203614C - 0x2036120)
	mov r0, #0x4 // (byte_20399F4 - 0x20399f0)
	ldrsb r0, [r5,r0]
	tst r0, r0
	blt loc_801FF52

	// transfer buffer store 1
	lsl r0, r0, #2
	ldr r1, [r5,#0x8] // (dword_20399F8 - 0x20399f0)
	str r1, [r7,r0]

loc_801FF52:
	add r5, #0x10
	ldr r7, off_8020100 // =dword_203F5A0 
	ldrb r1, [r4]
	tst r1, r1
	beq loc_801FF66
	ldrh r1, [r5,#0x2] // (word_2039A02 - 0x2039a00)
	mov r2, #0xfc
	lsl r2, r2, #8
	and r2, r1
	beq loc_801FF84
loc_801FF66:
	mov r0, #1
	bl input_recordStateChangeForEntry_800A0D6
	ldrb r1, [r5,#0x6] // (byte_2039A06 - 0x2039a00)
	strb r1, [r6,#oBattleState_Unk_15]
	ldrh r1, [r5,#0xc] // (word_2039A0C - 0x2039a00)
	ldr r0, off_8020104 // =unk_20362F0 
	strh r1, [r0,#0x2c] // (word_203631C - 0x20362f0)
	mov r0, #0x4 // (byte_2039A04 - 0x2039a00)
	ldrsb r0, [r5,r0]
	tst r0, r0
	blt loc_801FF84

	// transfer buffer store 2
	lsl r0, r0, #2
	ldr r1, [r5,#0x8] // (dword_2039A08 - 0x2039a00)
	str r1, [r7,r0]

loc_801FF84:
	ldr r5, off_8020108 // =eStruct2036780
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r1, [r0,#oJoypad_Held]
	strh r1, [r5,#0x2] // (eFlags2036782 - 0x2036780)
	str r1, [sp]
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r1, [r0,#oBattleState_Unk_11]
	strb r1, [r5,#0x6] // (byte_2036786 - 0x2036780)
	mov r0, #4
	bl link_getSlotState_803F740
	strh r0, [r5,#0xc] // (word_203678C - 0x2036780)
	ldrb r0, [r4,#0x2] // (eStruct203F7D8+2 - 0x203f7d8)
	mov r1, #1
	tst r0, r1
	beq loc_801FFC6
	bl net_isLinkConnected_803EA2C
	tst r0, r0
	bne loc_801FFD2
	mov r0, #0x3 // (eStruct203F7D8+3 - 0x203f7d8)
	ldrsb r0, [r4,r0]
	sub r0, #1
	strb r0, [r4,#0x3] // (eStruct203F7D8+3 - 0x203f7d8)
	blt loc_801FFC6

	// transfer buffer store 3
	strb r0, [r5,#0x4] // (byte_2036784 - 0x2036780)
	lsl r0, r0, #2
	ldr r1, off_802010C // =dword_203CBE0 
	ldr r0, [r0,r1]
	str r0, [r5,#0x8] // (dword_2036788 - 0x2036780)

	b loc_801FFD2
loc_801FFC6:
	ldrb r0, [r4,#0x2] // (eStruct203F7D8+2 - 0x203f7d8)
	mov r1, #1
	bic r0, r1
	strb r0, [r4,#0x2] // (eStruct203F7D8+2 - 0x203f7d8)
	mov r0, #0xff
	strb r0, [r5,#0x4] // (byte_2036784 - 0x2036780)
loc_801FFD2:
	add sp, sp, #4
	pop {r4-r7,pc}
	thumb_func_end sub_801FF18

// symdb: Battle link-transfer builder (variant): the same packing as sub_801FF18, gated on arg bits 0x8 and 0x10 instead of arg == 2; drains dword_203CBE0 one word per frame (counting down) when no link is connected.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_801FFD6.yaml
	thumb_local_start
sub_801FFD6:
	push {r4-r7,lr}
	sub sp, sp, #8
	str r0, [sp,#4]
	cmp r0, #1
	beq loc_80200A0
	mov r1, #8
	tst r0, r1
	beq loc_801FFEA
	nop 
	b loc_802004E
loc_801FFEA:
	ldr r4, off_8020110 // =eStruct203F7D8
	ldr r5, off_8020114 // =unk_20399F0 
	mov r6, r10
	ldr r6, [r6,#oToolkit_BattleStatePtr]
	ldr r7, off_8020118 // =dword_203F4A0 
	ldrh r1, [r5,#0x2] // (word_20399F2 - 0x20399f0)
	mov r2, #0xfc
	lsl r2, r2, #8
	and r2, r1
	beq loc_802001C
	mov r0, #0
	bl input_recordStateChangeForEntry_800A0D6
	ldrb r1, [r5,#0x6] // (byte_20399F6 - 0x20399f0)
	strb r1, [r6,#oBattleState_Unk_14]
	ldrh r1, [r5,#0xc] // (word_20399FC - 0x20399f0)
	ldr r0, off_802011C // =unk_2036120 
	strh r1, [r0,#0x2c] // (word_203614C - 0x2036120)
	mov r0, #0x4 // (byte_20399F4 - 0x20399f0)
	ldrsb r0, [r5,r0]
	tst r0, r0
	blt loc_802001C

	// transfer buffer store 1
	lsl r0, r0, #2
	ldr r1, [r5,#0x8] // (dword_20399F8 - 0x20399f0)
	str r1, [r7,r0]

loc_802001C:
	add r5, #0x10
	ldr r7, off_8020120 // =dword_203F5A0 
	ldrb r1, [r4]
	tst r1, r1
	beq loc_8020030
	ldrh r1, [r5,#0x2] // (word_2039A02 - 0x2039a00)
	mov r2, #0xfc
	lsl r2, r2, #8
	and r2, r1
	beq loc_802004E
loc_8020030:
	mov r0, #1
	bl input_recordStateChangeForEntry_800A0D6
	ldrb r1, [r5,#0x6] // (byte_2039A06 - 0x2039a00)
	strb r1, [r6,#oBattleState_Unk_15]
	ldrh r1, [r5,#0xc] // (word_2039A0C - 0x2039a00)
	ldr r0, off_8020124 // =unk_20362F0 
	strh r1, [r0,#0x2c] // (word_203631C - 0x20362f0)
	mov r0, #0x4 // (byte_2039A04 - 0x2039a00)
	ldrsb r0, [r5,r0]
	tst r0, r0
	blt loc_802004E

	// transfer buffer store 2
	lsl r0, r0, #2
	ldr r1, [r5,#0x8] // (dword_2039A08 - 0x2039a00)
	str r1, [r7,r0]

loc_802004E:
	ldr r1, [sp,#4]
	mov r2, #0x10
	tst r1, r2
	beq loc_802005A
	nop 
	b loc_80200A0
loc_802005A:
	ldr r5, off_8020128 // =eStruct2036780
	mov r0, r10
	ldr r0, [r0,#oToolkit_JoypadPtr]
	ldrh r1, [r0,#oJoypad_Held]
	strh r1, [r5,#0x2] // (eFlags2036782 - 0x2036780)
	str r1, [sp]
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldrb r1, [r0,#oBattleState_Unk_11]
	strb r1, [r5,#0x6] // (byte_2036786 - 0x2036780)
	mov r0, #4
	bl link_getSlotState_803F740
	strh r0, [r5,#0xc] // (word_203678C - 0x2036780)
	ldrb r0, [r4,#2]
	mov r1, #1
	tst r0, r1
	beq loc_8020094
	mov r0, #3
	ldrsb r0, [r4,r0]
	sub r0, #1
	strb r0, [r4,#3]
	blt loc_8020094

	// transfer buffer store 3
	strb r0, [r5,#0x4] // (byte_2036784 - 0x2036780)
	lsl r0, r0, #2
	ldr r1, off_802012C // =dword_203CBE0 
	ldr r0, [r0,r1]
	str r0, [r5,#0x8] // (dword_2036788 - 0x2036780)
	b loc_80200A0
loc_8020094:
	ldrb r0, [r4,#2]
	mov r1, #1
	bic r0, r1
	strb r0, [r4,#2]
	mov r0, #0xff
	strb r0, [r5,#0x4] // (byte_2036784 - 0x2036780)
loc_80200A0:
	add sp, sp, #8
	pop {r4-r7,pc}
	thumb_func_end sub_801FFD6

// symdb: Posts a battle-mode/flags update into eStruct203F7D8 (writes mode byte at +3 and OR=1 into flags byte at +2); r0 returns 1.
// symdb: (r0 = request code) -> r0 = 1 ; side effects: store 1 byte to (eStruct203F7D8+3), read-modify-
// symdb: write (eStruct203F7D8+2) |= 1
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_requestSetBattleMode_80200A4.yaml
	thumb_func_start battle_requestSetBattleMode_80200A4
battle_requestSetBattleMode_80200A4:
	ldr r3, off_8020130 // =eStruct203F7D8
	strb r0, [r3,#0x3] // (eStruct203F7D8+3 - 0x203f7d8)
	ldrb r0, [r3,#0x2] // (eStruct203F7D8+2 - 0x203f7d8)
	mov r1, #1
	orr r0, r1
	strb r0, [r3,#0x2] // (eStruct203F7D8+2 - 0x203f7d8)
	mov pc, lr
	.balign 4, 0x00
off_80200B4:
	.word eStruct203F7D8
off_80200B8:
	.word eStruct2036780
off_80200BC:
	.word dword_203F4A0
off_80200C0:
	.word 0x200
off_80200C4:
	.word dword_203CBE0
off_80200C8:
	.word 0x100
off_80200CC:
	.word eStruct203F7D8
off_80200D0:
	.word eStruct203F7D8
off_80200D4:
	.word eStruct203F7D8
off_80200D8:
	.word eStruct203F7D8
off_80200DC:
	.word eStruct2036780
off_80200E0:
	.word unk_20399F0
off_80200E4:
	.word eStruct2036780
off_80200E8:
	.word unk_2039A00
off_80200EC:
	.word eStruct203F7D8
off_80200F0:
	.word eStruct203F7D8
off_80200F4:
	.word unk_20399F0
off_80200F8:
	.word dword_203F4A0
off_80200FC:
	.word unk_2036120
off_8020100:
	.word dword_203F5A0
off_8020104:
	.word unk_20362F0
off_8020108:
	.word eStruct2036780
off_802010C:
	.word dword_203CBE0
off_8020110:
	.word eStruct203F7D8
off_8020114:
	.word unk_20399F0
off_8020118:
	.word dword_203F4A0
off_802011C:
	.word unk_2036120
off_8020120:
	.word dword_203F5A0
off_8020124:
	.word unk_20362F0
off_8020128:
	.word eStruct2036780
off_802012C:
	.word dword_203CBE0
off_8020130:
	.word eStruct203F7D8
	thumb_func_end battle_requestSetBattleMode_80200A4

// symdb: Zero-fills the single 4-byte battle object slot at eStruct2038160, resetting that object's state.
// symdb: void eStruct2038160_clearStruct(void); /* no inputs; r2/r3 preserved, flags clobbered */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eStruct2038160_clearStruct.yaml
	thumb_func_start eStruct2038160_clearStruct
eStruct2038160_clearStruct:
	push {lr}
	// memBlock
	ldr r0, off_8020164 // =eStruct2038160
	// size
	mov r1, #4
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end eStruct2038160_clearStruct

// symdb: When the 0x200BC50.5 flag is set and the EWRAM 0x200BC30 jump-offset pair is exactly 0x0C, calls sub_813D66C + dispatch_803C620 and stores r0 into eStruct2038160 byte 0x01; otherwise no-op.
// symdb: () -> void; r0 = dispatch result becomes the new value at 0x2038161 (eStruct2038160 byte 1)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battleObject_checkTerminateFlagAndDispatch_8020140.yaml
	thumb_func_start battleObject_checkTerminateFlagAndDispatch_8020140
battleObject_checkTerminateFlagAndDispatch_8020140:
	push {r7,lr}
	bl test0x200bc50_0x5_813D60C
	beq locret_802015C

	bl eStruct200BC30_getJumpOffset00
	cmp r0, #0xc
	bne locret_802015C

	ldr r7, off_8020168 // =eStruct2038160
	bl sub_813D66C
	bl dispatch_803C620 // () -> (u32?, bool)
	strb r0, [r7,#0x1] // (eStruct2038160_BattleTerminate01 - 0x2038160)

locret_802015C:
	pop {r7,pc}
	thumb_func_end battleObject_checkTerminateFlagAndDispatch_8020140

// symdb: Reads the BattleTerminate01 flag byte from the global eStruct2038160 and returns it in r0.
// symdb: uint8_t eStruct2038160_getBattleTerminate01(void); // inputs: lr; outputs: r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/eStruct2038160_getBattleTerminate01.yaml
	thumb_func_start eStruct2038160_getBattleTerminate01
eStruct2038160_getBattleTerminate01:
	ldr r0, off_802016C // =eStruct2038160
	ldrb r0, [r0,#0x1] // (eStruct2038160_BattleTerminate01 - 0x2038160)
	// <endpool>
	mov pc, lr
	thumb_func_end eStruct2038160_getBattleTerminate01

off_8020164:
	.word eStruct2038160
off_8020168:
	.word eStruct2038160
off_802016C:
	.word eStruct2038160
// symdb: Encounter root table 0 of the four pickBattleSettingsEntry_80AA5F4 chooses from by event flags.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/off_8020170.yaml
off_8020170:
	.word off_8020190
	.word off_80201E4
// symdb: Encounter root table 1 of the four pickBattleSettingsEntry_80AA5F4 chooses from by event flags.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/off_8020178.yaml
off_8020178:
	.word off_8020190
	.word pt_8020240
// symdb: Encounter root table 2 of the four pickBattleSettingsEntry_80AA5F4 chooses from by event flags.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/off_8020180.yaml
off_8020180: // [*const [*const [*const FFStop32<[BattleSettings]>; 16]]; 2]
	// not internet
	.word off_8020190
	// internet
	.word pt_802029C
// symdb: Encounter root table 3 of the four pickBattleSettingsEntry_80AA5F4 chooses from by event flags.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/off_8020188.yaml
off_8020188:
	.word off_8020190
	.word off_80202F8
off_8020190: // [*const [*const FFStop32<[BattleSettings]>; 16]; 21]
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
off_80201E4: // [*const [*const FFStop32<[BattleSettings]>; 16]; INTERNET_NUM_GROUPS]
	.word off_80B1B7C
	.word off_80B1ED8
	.word off_80B23C8
	.word off_80B29CC
	.word off_80B1B7C
	.word off_80B2EDC
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B36BC
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B3970
	.word off_80B41E4
	.word off_80B1B7C
	.word off_80B1B7C
	// in Central Area
	.word off_80B4AB8
	.word off_80B5A0C
	.word off_80B62F8
	.word off_80B66A8
	.word off_80B6C20
	.word off_80B71D4
	.word off_80B79C0
pt_8020240:
	.word off_80B1B7C
	.word off_80B1ED8
	.word off_80B23C8
	.word off_80B29CC
	.word off_80B1B7C
	.word off_80B2EDC
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B36BC
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B3970
	.word off_80B41E4
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B4AF8
	.word off_80B5A0C
	.word off_80B62F8
	.word off_80B66A8
	.word off_80B6C20
	.word off_80B71D4
	.word off_80B79C0
pt_802029C: // [*const [*const FFStop32<[BattleSettings]>; 16]; INTERNET_NUM_GROUPS]
	.word off_80B1B7C
	.word off_80B1ED8
	.word off_80B23C8
	.word off_80B29CC
	.word off_80B1B7C
	.word off_80B2EDC
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B36BC
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B3970
	.word off_80B41E4
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B4AB8
	.word off_80B5A4C
	.word off_80B62F8
	.word off_80B66A8
	.word off_80B6C20
	.word off_80B71D4
	.word off_80B79C0
off_80202F8:
	.word off_80B1B7C
	.word off_80B1ED8
	.word off_80B23C8
	.word off_80B29CC
	.word off_80B1B7C
	.word off_80B2EDC
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B36BC
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B3970
	.word off_80B41E4
	.word off_80B1B7C
	.word off_80B1B7C
	.word off_80B4B38
	.word off_80B5A0C
	.word off_80B62F8
	.word off_80B66A8
	.word off_80B6C20
	.word off_80B71D4
	.word off_80B79C0
	// <endfile>
/*For debugging purposes, connect comment at any range!*/
