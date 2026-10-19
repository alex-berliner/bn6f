

// FILE module sound

	thumb_func_start call_m4aSoundMain
call_m4aSoundMain:
	push {lr}
	bl m4aSoundMain
	pop {pc}
	.word unk_2006840
	.word dword_80005BC
	.balign 4, 0
dword_80005BC:
	.hword 0x121c
	.asciz "%D"
	.balign 4, 0
	thumb_func_end call_m4aSoundMain

// symdb: Calls m4aSoundVSync (a ROM-resident wrapper the IWRAM VCount callback uses).
// symdb: () -> m4aSoundVSync()
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/call_m4aSoundVSync.yaml
	thumb_func_start call_m4aSoundVSync
call_m4aSoundVSync:
	push {lr}
	bl m4aSoundVSync
	pop {pc}
	thumb_func_end call_m4aSoundVSync

	thumb_func_start PlaySoundEffect
// (enum SoundEffect idx) -> void
// this can play any song in the song array but
// usage-wise it is only be used for sound effects
// symdb: Thin wrapper that asks the M4A sound engine to start playing the sound effect / music track whose ID is given in r0.
// symdb: void PlaySoundEffect(u32 soundId /* r0, plus args r1-r3 forwarded */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/PlaySoundEffect.yaml
PlaySoundEffect:
	push {r1-r7,lr}
	bl m4a_800061E // () -> void
	pop {r1-r7,pc}
	thumb_func_end PlaySoundEffect

// symdb: Switches the background music to the given song id, doing nothing if that song is already playing.
// symdb: void PlayMusic(u8 song); // r0 = song id; preserves r1-r7 and r10, modifies flags per song
// symdb: comparison
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/PlayMusic.yaml
	thumb_func_start PlayMusic
PlayMusic: // (song: u8) -> ()
	push {r1-r7,lr}
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	ldrb r1, [r7,#oGameState_BGMusicIndicator]
	cmp r0, r1
	beq locret_80005F0
	strb r0, [r7,#oGameState_BGMusicIndicator]
	cmp r0, #0x63
	bne loc_80005EC
	bl sound_dispatchTask_8000630
	b locret_80005F0
loc_80005EC:
	bl m4a_800061E // () -> void
locret_80005F0:
	pop {r1-r7,pc}
	thumb_func_end PlayMusic

	thumb_func_start music_80005F2
music_80005F2: // (bg_music_indicator: u8) -> ()
	push {r1-r7,lr}

	mov r7, r10

	ldr r7, [r7,#oToolkit_GameStatePtr]
	strb r0, [r7,#oGameState_BGMusicIndicator]

	cmp r0, #0x63
	bne loc_8000604

	bl sound_dispatchTask_8000630

	b locret_8000608
loc_8000604:
	bl m4a_800061E // () -> void
locret_8000608:
	pop {r1-r7,pc}
	thumb_func_end music_80005F2

	thumb_func_start sub_800060A
sub_800060A:
	push {r1-r7,lr}
	ldr r1, off_8000864 // =byte_2010B90
	ldrb r1, [r1]
	cmp r1, #0
	bne loc_8000616
	mov r1, #0xff
loc_8000616:
	ldr r3, off_8000868 // =sound_8000822+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r1-r7,pc}
	thumb_func_end sub_800060A

// () -> void
// symdb: Thin wrapper/trampoline that dispatches a call into the m4a sound driver via sound_8000808, passing a routine pointer taken from the song-table area and shielding r10 from being clobbered.
// symdb: void m4a_SoundMainWrapper(/* r0 passed through */, /* r2 passed through */); // r1 = incoming
// symdb: r10 (forwarded as arg), r3 = m4a_SongNumStart|1 (thumb Fn*); preserves r4-r7, r10
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/m4a_800061E.yaml
	thumb_local_start
m4a_800061E:
	push {lr}
	mov r1, r10
	push {r1}
	ldr r3, off_800086C // =m4a_SongNumStart+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r1}
	mov r10, r1
	pop {pc}
	thumb_func_end m4a_800061E

// symdb: Thin wrapper that submits a sound task to the sound engine, handing the engine's dispatcher sound_8000808 the task callback sub_814EA58 and passing the caller's r10 through as an argument.
// symdb: void sound_dispatchTask_8000630(u32 r0, u32 r2); /* r4-r7, r10 preserved context; sets r1 =
// symdb: caller's r10, r3 = &sub_814EA58|1 before calling sound_8000808; returns nzcv and r10 from the
// symdb: callee */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sound_dispatchTask_8000630.yaml
	thumb_local_start
sound_dispatchTask_8000630:
	push {lr}
	mov r1, r10
	push {r1}
	ldr r3, off_8000870 // =sound_tickAllMusicPlayers_814EA58+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r1}
	mov r10, r1
	pop {pc}
	thumb_func_end sound_dispatchTask_8000630

// symdb: Looks up a sound handler by sound id in a table and hands it, with its arguments, to the sound dispatcher sound_8000808 via the shared callback sub_814F9AC.
// symdb: void sound_dispatchSoundRequest(u8 idx /* r0 */, u32 a1 /* r1 */, u32 a2 /* r2 */); returns
// symdb: caller's r10 in r3, passes c/v through from sound_8000808
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sound_dispatchSoundRequest_8000642.yaml
	thumb_func_start sound_dispatchSoundRequest_8000642
sound_dispatchSoundRequest_8000642: // (idx: u8, a1: ?, a2: ?) -> ()
	push {r4-r7,lr}

	lsl r0, r0, #2
	ldr r7, off_8000700 // =off_8000704
	ldr r0, [r7,r0]

	mov r3, r10
	push {r3}
	ldr r3, off_8000874 // =sub_814F9AC+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r3}
	mov r10, r3
	pop {r4-r7,pc}
	thumb_func_end sound_dispatchSoundRequest_8000642

	thumb_func_start sound_800065A
sound_800065A:
	push {r4-r7,lr}
	lsl r0, r0, #2
	ldr r7, off_8000700 // =off_8000704
	ldr r0, [r7,r0]
	mov r3, r10
	push {r3}
	ldr r3, off_8000878 // =sub_814FA14+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r3}
	mov r10, r3
	pop {r4-r7,pc}
	thumb_func_end sound_800065A

	thumb_func_start sound_8000672
sound_8000672:
	push {r4-r7,lr}
	lsl r0, r0, #2
	ldr r7, off_8000700 // =off_8000704
	ldr r0, [r7,r0]
	mov r3, r10
	push {r3}
	ldr r3, off_800087C // =sub_814F988+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r3}
	mov r10, r3
	pop {r4-r7,pc}
	thumb_func_end sound_8000672

// symdb: Looks up a sound cue's handler word in the cue table and dispatches it via sound_8000808 with the caller's context and the shared sound callback.
// symdb: void sound_dispatchCueHandler(u32 cueIndex /*r0*/, u32 arg /*r1*/, u32 context /*r10*/); returns
// symdb: restored context in r2/r10, clobbers r0-r3, preserves r4-r7/r10
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sound_dispatchCueHandler_800068A.yaml
	thumb_func_start sound_dispatchCueHandler_800068A
sound_dispatchCueHandler_800068A:
	push {r4-r7,lr}
	ldr r7, off_8000700 // =off_8000704
	lsl r0, r0, #2
	ldr r0, [r7,r0]
	mov r2, r10
	push {r2}
	ldr r3, off_8000880 // =battle_smashFx_SetParams_814E87C+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r2}
	mov r10, r2
	pop {r4-r7,pc}
	thumb_func_end sound_dispatchCueHandler_800068A

// symdb: Play a background-music track on one of the MML sound channels, also recording the song id in the GameState indicator.
// symdb: void sound_80006A2(u32 song_id /* r0 */, u32 channel_arg /* r1 */, u32 channel_index /* r2 */,
// symdb: void *toolkit /* r10 */); /* clobbers r1-r3,r4-r10,r12,lr; NZCV; preserves r4-r10,r12 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sound_80006A2.yaml
	thumb_func_start sound_80006A2
sound_80006A2:
	push {r4-r7,lr}

	cmp r0, #0x25
	bgt loc_80006B0

	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	strb r0, [r7,#oGameState_BGMusicIndicator]
	b loc_80006B0
loc_80006B0:

	mov r4, r12
	mov r5, r8
	mov r6, r9
	mov r7, r10
	push {r4-r7}
	ldr r7, off_8000700 // =off_8000704
	lsl r2, r2, #2
	ldr r7, [r7,r2]
	mov r4, r0
	mov r5, r1
	ldr r3, off_8000884 // =m4a_SongNumStart+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	mov r0, r7
	ldr r3, off_8000888 // =sound_mplayStop+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	mov r0, r7
	mov r1, #0xff
	mov r2, #0
	ldr r3, off_800088C // =sub_814F9AC+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	mov r0, r4
	ldr r3, off_8000890 // =sub_814E9F0+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	mov r0, r7
	mov r1, r5
	ldr r3, off_8000894 // =sub_814EAF0+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r4-r7}
	mov r12, r4
	mov r8, r5
	mov r9, r6
	mov r10, r7
	pop {r4-r7,pc}
	.word off_2010890
	.balign 4, 0
off_8000700:
	.word off_8000704
off_8000704:
	// 0x00 (0x00)
	.word byte_2010690
	// 0x04 (0x01)
	.word byte_2010910
	// 0x08 (0x02)
	.word byte_2010950
	// 0x0C (0x03)
	.word byte_2010C20
	// 0x10 (0x04)
	.word byte_2010B50
	// 0x14 (0x05)
	.word byte_2010550
	// 0x18 (0x06)
	.word byte_2010650
	// 0x1C (0x07)
	.word byte_20108D0
	// 0x20 (0x08)
	.word byte_2010BE0
	// 0x24 (0x09)
	.word byte_2010610
	// 0x28 (0x0A)
	.word byte_2010990
	// 0x2C (0x0B)
	.word byte_2010C60
	// 0x30 (0x0C)
	.word byte_2010AD0
	// 0x34 (0x0D)
	.word byte_2010510
	// 0x38 (0x0E)
	.word byte_2010810
	// 0x3C (0x0F)
	.word byte_2010A90
	// 0x40 (0x10)
	.word byte_20105D0
	// 0x44 (0x11)
	.word byte_2010B10
	// 0x48 (0x12)
	.word byte_20107D0
	// 0x4C (0x13)
	.word unk_2010490
	// 0x50 (0x14)
	.word byte_2010710
	// 0x54 (0x15)
	.word byte_2010790
	// 0x58 (0x16)
	.word byte_2010A50
	// 0x5C (0x17)
	.word unk_20104D0
	// 0x60 (0x18)
	.word byte_2010750
	// 0x64 (0x19)
	.word byte_20109D0
	// 0x68 (0x1A)
	.word byte_20106D0
	// 0x6C (0x1B)
	.word byte_2010BA0
	// 0x70 (0x1C)
	.word byte_2010850
	// 0x74 (0x1D)
	.word byte_2010A10
	// 0x78 (0x1E)
	.word byte_2010590
	// 0x7C (0x1F)
	.word off_2010890
	thumb_func_end sound_80006A2

// () -> void
// symdb: Asks the sound driver to switch music state (via callback sub_814EA58) and marks the game state so background music is treated as off.
// symdb: void music_stopBgm(u32 argR0, u32 argR2, Toolkit *toolkit /*r10*/); sets r0 = 0xFF, r1 =
// symdb: toolkit, flags NZ from the 0xFF load
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/musicGameState_8000784.yaml
	thumb_func_start musicGameState_8000784
musicGameState_8000784:
	push {r7,lr}
	mov r1, r10
	push {r1}
	ldr r3, off_8000898 // =sound_tickAllMusicPlayers_814EA58+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r1}
	mov r10, r1
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr] // Toolkit.gamestate
	mov r0, #0xff
	strb r0, [r7,#oGameState_BGMusicIndicator] // GameState.bgMusicIndicator
	pop {r7,pc}
	.byte 0, 0
	thumb_func_end musicGameState_8000784

	thumb_local_start
sub_80007A0:
	push {r1-r7,lr}
	mov r1, r10
	push {r1}
	ldr r3, off_800089C // =sub_814E9F0+1
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	pop {r1}
	mov r10, r1
	pop {r1-r7,pc}
	thumb_func_end sub_80007A0

// symdb: Zero-fills the 0x20C-byte work memBlock pointed to by dword_200A490.
// symdb: void zeroFillWorkMemBlock(void) — takes nothing meaningful (r2/r3 preserved for callers); c/v
// symdb: flags are whatever ZeroFillByWord leaves.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/zeroFill_80007B2.yaml
	thumb_func_start zeroFill_80007B2
zeroFill_80007B2:
	push {lr}
	// memBlock
	ldr r0, dword_200A490_p
	// size
	ldr r1, numWords // =0x20c
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end zeroFill_80007B2

// symdb: Drains the battle tick jump-table queue at dword_200A490, calling each pending function pointer with its parameters, then plays any queued sound request via sound_8000808.
// symdb: () -> void ; side effects: clobbers dword_200A490 (the pending-request queue), calls each queued
// symdb: function pointer, may push to sound_8000808's pending SSEQ queue (dword_200A490 / sound queue).
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/main_drainPendingRequestQueueAndForwardSoundReq_80007BE.yaml
	thumb_func_start main_drainPendingRequestQueueAndForwardSoundReq_80007BE
main_drainPendingRequestQueueAndForwardSoundReq_80007BE:
	push {r4-r7,lr}
	ldr r5, dword_200A490_p
	ldr r7, [r5]
	cmp r7, #0
	beq loc_80007F0
	ldrb r0, [r5,#0x4] // (byte_200A494 - 0x200a490)
	add r0, #1
	cmp r0, #0x1a
	blt loc_80007D2
	mov r0, #0
loc_80007D2:
	strb r0, [r5,#0x4] // (byte_200A494 - 0x200a490)
	mov r0, #0
	str r0, [r5,#0x8] // (dword_200A498 - 0x200a490)
	mov r6, #0xc
	add r6, r6, r5
loc_80007DC:
	ldmia r6!, {r0-r3}
	mov r4, r10
	push {r4}
	ldr r4, off_8000804 // =loc_80007E8+1
	mov lr, r4
	bx r3
loc_80007E8:
	pop {r4}
	mov r10, r4
	sub r7, #1
	bne loc_80007DC
loc_80007F0:
	mov r0, #0
	str r0, [r5]
	ldr r6, [r5,#0x8] // (dword_200A498 - 0x200a490)
	cmp r6, #0
	beq locret_8000800
	ldmia r6!, {r0-r3}
	bl sound_8000808 // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
locret_8000800:
	pop {r4-r7,pc}
	.balign 4, 0
off_8000804:
	.word loc_80007E8+1
	thumb_func_end main_drainPendingRequestQueueAndForwardSoundReq_80007BE

// symdb: Appends a 16-byte sound/SSEQ request to the pending-request queue at dword_200A490, dropping it if the queue is full (32 entries).
// symdb: void sound_8000808(u32 word0 /*r0*/, u32 word1 /*r1*/, u32 word2 /*r2*/, u32 word3 /*r3*/) —
// symdb: r0-r3 form the 4-word request; flags returned are those of CMP count,#0x20 when full, else of
// symdb: the address-computation ADD; r4-r7 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sound_8000808.yaml
	thumb_local_start
sound_8000808: // (a0: * ?, a1: ?, a2: ?, a3: * Fn) -> ()
	push {r4-r7,lr}
	ldr r5, dword_200A490_p
	ldr r7, [r5]
	cmp r7, #0x20
	blt loc_8000814
	b locret_8000820
loc_8000814:
	add r6, r7, #1
	str r6, [r5]
	lsl r7, r7, #4
	add r7, #0xc
	add r7, r7, r5
	stmia r7!, {r0-r3}
locret_8000820:
	pop {r4-r7,pc}
	thumb_func_end sound_8000808

// (struct ? *a5, unk8 bgMusInd_a0, unk8 a1, unk8 *a2) -> ?
	thumb_local_start
sound_8000822:
	push {r4-r7,lr}

  // u8 v1_r2
	ldr r3, off_80008A4 // =byte_2010B90
	ldrb r2, [r3]

  // 0 if !(a1 == v1_r2)
	cmp r1, r2
	beq loc_8000854

  // 0 then

	mov r2, #0
	strb r2, [r3]

  // u8 vBGMusicIndicator_r1
	mov r7, r10
	ldr r7, [r7,#oToolkit_GameStatePtr]
	ldrb r1, [r7,#oGameState_BGMusicIndicator]

  // if (bgMusInd_a0 == vBGMusicIndicator_r1) return;
	cmp r0, r1
	beq locret_800085A

  // Write new bgMusInd_a0
	strb r0, [r7,#oGameState_BGMusicIndicator]

  // 1 if (bgMusInd_a0 == 0x63)
	cmp r0, #0x63
	bne loc_8000844

  // 1 then
	ldr r3, off_80008A8 // =sound_tickAllMusicPlayers_814EA58+1
	b loc_8000846

  // 0 else 1 else
loc_8000844:
	ldr r3, off_80008AC // =m4a_SongNumStart+1
loc_8000846:
	push {r4}
	ldr r4, off_80008B0 // =loc_800084E+1
	mov lr, r4
	bx r3
loc_800084E:
	pop {r4}
	mov r10, r4
	b locret_800085A
loc_8000854:
	mov r0, r6
	sub r0, #0x10

  // Writes to struct a5
	str r0, [r5,#8]
 
locret_800085A:
	pop {r4-r7,pc}
	.balign 4, 0
	thumb_func_end sound_8000822

// FILE table
dword_200A490_p:
	.word dword_200A490
	.word unk_200F390
off_8000864:
	.word byte_2010B90
off_8000868:
	.word sound_8000822+1 // (struct ? *a5, unk8 bgMusInd_a0, unk8 a1, unk8 *a2) -> ?
off_800086C:
	.word m4a_SongNumStart+1 // (idx: u16) -> ()
off_8000870:
	.word sound_tickAllMusicPlayers_814EA58+1
off_8000874:
	.word sub_814F9AC+1
off_8000878:
	.word sub_814FA14+1
off_800087C:
	.word sub_814F988+1
off_8000880:
	.word battle_smashFx_SetParams_814E87C+1
off_8000884:
	.word m4a_SongNumStart+1 // (idx: u16) -> ()
off_8000888:
	.word sound_mplayStop+1
off_800088C:
	.word sub_814F9AC+1
off_8000890:
	.word sub_814E9F0+1
off_8000894:
	.word sub_814EAF0+1
off_8000898:
	.word sound_tickAllMusicPlayers_814EA58+1
off_800089C:
	.word sub_814E9F0+1
numWords:
	.word 0x20C
off_80008A4:
	.word byte_2010B90
off_80008A8:
	.word sound_tickAllMusicPlayers_814EA58+1
off_80008AC:
	.word m4a_SongNumStart+1 // (idx: u16) -> ()
off_80008B0:
	.word loc_800084E+1

// FILE module memory

/// Fill r0 with zero.
/// Size is in r1, in bytes.
/// Does a backwards fill for speed
/// tags: "#mod_memory, "
// symdb: Fills a memory range with zero bytes, one byte at a time, walking backwards from the end.
// symdb: void ZeroFillByByte(void* dest /*r0*/, u32 numBytes /*r1*/); flags out from the final decrement
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ZeroFillByByte.yaml
	thumb_func_start ZeroFillByByte
ZeroFillByByte: // (mut_mem: *mut (), num_bytes: usize) -> ()
	push {r0-r2,lr}
	mov r2, #0

loc_loop_80008B8:
	sub r1, #1
	strb r2, [r0,r1]
	bne loc_loop_80008B8

	pop {r0-r2,pc}
	thumb_func_end ZeroFillByByte

// Fill r0 with zero, using halfwords.
// Size is in r1, in bytes.
// Source, destination, and size must be halfword compatible
	thumb_func_start ZeroFillByHalfword
ZeroFillByHalfword:
	push {r0-r3,lr}
	ldr r2, .HalfwordFillCpuSetMask_80008DC // =0x1000000
	lsr r1, r1, #1
	orr r2, r1
	mov r1, r0
	sub sp, sp, #4
	mov r0, #0
	str r0, [sp]
	mov r0, sp
	bl SWI_CpuSet // (src: *const u32, dest: *mut u32, mode: int) -> ()
	add sp, sp, #4
	pop {r0-r3,pc}
	.balign 4, 0
.HalfwordFillCpuSetMask_80008DC:
	.word 0x1000000
	thumb_func_end ZeroFillByHalfword

/// Fill r0 with zero, using words.
/// Size is in r1, in bytes.
/// Source, destination, and size must be word compatible
// symdb: Zero-fills a buffer a word at a time by calling BIOS CpuSet with a fixed-source zero word, leaving all argument registers intact.
// symdb: void ZeroFillByWord(void* dest /*r0*/, u32 sizeBytes /*r1*/); // preserves r0-r3; returns flags
// symdb: N=0, Z=1, C=0, V=0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ZeroFillByWord.yaml
	thumb_func_start ZeroFillByWord
ZeroFillByWord: // (mut_mem: *mut (), num_bytes: usize) -> ()
	push {r0-r3,lr}
	ldr r2, .WordFillCpuSetMask_80008FC // =0x5000000
	lsr r1, r1, #2
	orr r2, r1
	mov r1, r0
	sub sp, sp, #4
	mov r0, #0
	str r0, [sp]
	mov r0, sp
	bl SWI_CpuSet // (src: *const u32, dest: *mut u32, mode: int) -> ()
	add sp, sp, #4
	pop {r0-r3,pc}
	.balign 4, 0
.WordFillCpuSetMask_80008FC:
	.word 0x5000000
	thumb_func_end ZeroFillByWord

// (int a1, int a2) -> void
// Fill r0 with zero, in blocks of eight words.
// Size is in r1, in bytes.
// CpuFastSet will round up the amount of bytes filled to a multiple of eight words
// even though the size specified is converted to a word count
// Source and destination must be word compatible
// Size must be a multiple of eight words
// symdb: Zeroes a byte-length buffer using a BIOS CpuFastSet fill (the BIOS moves eight words per burst, hence the original name).
// symdb: void zeroFillWords(void* dest, u32 lengthBytes); // preserves r0-r3 and lr; returns N=0 Z=1 C=0
// symdb: V=0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ZeroFillByEightWords.yaml
	thumb_func_start ZeroFillByEightWords
ZeroFillByEightWords:
	push {r0-r3,lr}
	ldr r2, .FillCpuFastSetMask_800091C // =0x1000000
	lsr r1, r1, #2
	orr r2, r1
	mov r1, r0
	sub sp, sp, #4
	mov r0, #0
	str r0, [sp]
	mov r0, sp
	bl SWI_CpuFastSet // (src: *const u32, mut_dest: *mut u32, mode: u32) -> ()
	add sp, sp, #4
	pop {r0-r3,pc}
	.balign 4, 0
.FillCpuFastSetMask_800091C:
	.word 0x1000000
	thumb_func_end ZeroFillByEightWords

// (u8 *src, u8 *dest, int byteCount) -> void

// Copy r2 bytes from r0 to r1, in units of bytes.
// symdb: A backwards byte-copy routine (memmove-style), safe when the destination is at or above the source (shifting data toward higher addresses).
// symdb: void CopyBytes(const void *srcEnd /*r0*/, void *dstEnd /*r1*/, int count /*r2*/); // copies
// symdb: count bytes from srcEnd[0..count-1] to dstEnd[0..count-1], // walking from the highest byte down
// symdb: to the lowest. // Returns r2 = 0, r3 = last byte copied (src[0]); // flags from the final subs
// symdb: (1-1): Z=1, C=1, V=0.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/CopyBytes.yaml
	thumb_func_start CopyBytes
CopyBytes:
	sub r2, #1
	ldrb r3, [r0,r2]
	strb r3, [r1,r2]
	bne CopyBytes
	mov pc, lr
	thumb_func_end CopyBytes

// (u16 *src, u16 *dest, int halfwordCount) -> void

// Copy r2 bytes from r0 to r1, in units of halfwords.
// Note that size is specified in bytes, which is then converted to halfword count in function
// Source, destination, and size must be halfword compatible.
	thumb_func_start CopyHalfwords
CopyHalfwords:
	push {r0-r3,lr}
	ldr r3, .HalfwordCopyCpuSetMask_8000938 // =0x0
	lsr r2, r2, #1
	orr r2, r3
	bl SWI_CpuSet // (src: *const u32, dest: *mut u32, mode: int) -> ()
	pop {r0-r3,pc}
	.balign 4, 0
.HalfwordCopyCpuSetMask_8000938:
	.word 0x0
	thumb_func_end CopyHalfwords

/// Copy r2 bytes from r0 to r1, in units of words.
/// Note r2 represents byte count, which is then converted to word count in function
/// Source, destination, and size must be word compatible.
// symdb: Block memory operation via BIOS CpuSet (SWI 5), taking a byte count and converting it to a word count before the call.
// symdb: (u32 *src, u32 *dest, u32 size_bytes) -> void; clobbers flags (N,Z,C from the shift/ORR),
// symdb: preserves r0-r3 and returns to lr via pop {pc}
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/CopyWords.yaml
	thumb_func_start CopyWords
CopyWords: // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	push {r0-r3,lr}
  
	ldr r3, .WordCopyCpuSetMask_800094C

  // let num_words: u32 = size / 4;
	lsr r2, r2, #2

	orr r2, r3

	bl SWI_CpuSet // (src: *const u32, dest: *mut u32, mode: int) -> ()

	pop {r0-r3,pc}
	.balign 4, 0
.WordCopyCpuSetMask_800094C:
	.word 0x4000000
	thumb_func_end CopyWords

// Copy r2 bytes from r0 to r1, in units of eight words, rounded up.
// Note r2 represents byte count, which is then converted to word count in function
// However, CpuFastSet will copy in chunks of eight words (0x20), therefore rounding
// up the word count to a multiple of eight words.
// Source and destination must be word compatible.
// Size must be a multiple of eight words
// symdb: Wrapper around the BIOS CpuFastSet SWI that block-copies memory in eight-word bursts, taking the size in bytes.
// symdb: void CopyByEightWords(const u32* src, u32* dest, u32 sizeBytes); // clobbers flags (NZ from word
// symdb: count, C from the size>>2 shift), preserves r0-r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/CopyByEightWords.yaml
	thumb_func_start CopyByEightWords
CopyByEightWords: // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	push {r0-r3,lr}
  ldr r3, .CopyFastCpuSetMask_8000960 // =0x0

  // let num_words: u32 = size / 4;
	lsr r2, r2, #2

	orr r2, r3

	bl SWI_CpuFastSet // (src: *const u32, mut_dest: *mut u32, mode: u32) -> ()

	pop {r0-r3,pc}
	.balign 4, 0
.CopyFastCpuSetMask_8000960:
	.word 0x0
	thumb_func_end CopyByEightWords

// (u8 *mem, int byteCount, u8 byte) -> void
// Fill r0 with r2, where r2 is treated as a byte.
// Size is in r1, in bytes.
// Does a backwards fill for speed
	thumb_func_start ByteFill
ByteFill:
	// byteCount
	sub r1, #1
	strb r2, [r0,r1]
	bne ByteFill
	mov pc, lr
	thumb_func_end ByteFill

// Fill r0 with r2, where r2 is treated as a halfword.
// Size is in r1, in bytes.
// Source, destination, and size must be halfword compatible
// symdb: Fills a byte range in memory with a 16-bit value using a halfword-mode CpuSet fill.
// symdb: void HalfwordFill(void *dest /* r0 */, u32 byteCount /* r1 */, u16 value /* r2 */); // preserves
// symdb: r0-r3, returns NZCV of "mov r1, r0" (i.e. dest as-if added to 0)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/HalfwordFill.yaml
	thumb_func_start HalfwordFill
HalfwordFill:
	push {r0-r3,lr}
	mov r3, r2
	ldr r2, .HalfwordFillCpuSetMask_8000988 // =0x1000000
	lsr r1, r1, #1
	orr r2, r1
	mov r1, r0
	sub sp, sp, #4
	str r3, [sp]
	mov r0, sp
	bl SWI_CpuSet // (src: *const u32, dest: *mut u32, mode: int) -> ()
	add sp, sp, #4
	pop {r0-r3,pc}
	.balign 4, 0
.HalfwordFillCpuSetMask_8000988:
	.word 0x1000000
	thumb_func_end HalfwordFill

// Fill r0 with r2, where r2 is treated as a word.
// Size is in r1, in bytes.
// Source, destination, and size must be word compatible
	thumb_func_start WordFill
WordFill:
	push {r0-r3,lr}
	mov r3, r2
	ldr r2, .WordFillCpuSetMask_80009A8 // =0x5000000
	lsr r1, r1, #2
	orr r2, r1
	mov r1, r0
	sub sp, sp, #4
	str r3, [sp]
	mov r0, sp
	bl SWI_CpuSet // (src: *const u32, dest: *mut u32, mode: int) -> ()
	add sp, sp, #4
	pop {r0-r3,pc}
	.balign 4, 0
.WordFillCpuSetMask_80009A8:
	.word 0x5000000
	thumb_func_end WordFill

// Fill r0 with r2, where r2 is treated as a word.
// Size is in r1, in bytes.
// CpuFastSet will round up the amount of bytes filled to a multiple of eight words
// even though the size specified is converted to a word count
// Source and destination must be word compatible
// Size must be a multiple of eight words
// symdb: BIOS-assisted memory fill — writes one 32-bit word repeatedly to a destination via SWI CpuFastSet in fixed-source (fill) mode, preserving r0-r3 for the caller.
// symdb: void mem_FillWordsFastSet(u32* dest /*r0*/, u32 byteLength /*r1*/, u32 fillWord /*r2*/); // r3
// symdb: passed through untouched; flags and lr clobbered; r0-r3 preserved on return
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/FillByEightWords.yaml
	thumb_func_start FillByEightWords
FillByEightWords:
	push {r0-r3,lr}
	mov r3, r2
	ldr r2, .FillCpuFastSetMask_80009C8 // =0x1000000
	lsr r1, r1, #2
	orr r2, r1
	mov r1, r0
	sub sp, sp, #4
	str r3, [sp]
	mov r0, sp
	bl SWI_CpuFastSet // (src: *const u32, mut_dest: *mut u32, mode: u32) -> ()
	add sp, sp, #4
	pop {r0-r3,pc}
	.balign 4, 0
.FillCpuFastSetMask_80009C8:
	.word 0x1000000
	thumb_func_end FillByEightWords

	thumb_local_start

memory_80009CC:
	push {r4-r7,lr}
	lsl r3, r3, #2
	ldr r5, off_80009E8 // =off_80009EC
	ldr r5, [r5,r3]
	mov r3, #8
	ldr r7, dword_8000A38 // =0x80000000
loc_80009D8:
	ldr r6, [r5,r3]
	and r6, r7
	bne loc_80009D8
	str r0, [r5]
	str r1, [r5,#4]
	orr r4, r2
	str r4, [r5,#8]
	pop {r4-r7,pc}
	.balign 4, 0
off_80009E8:
	.word off_80009EC
off_80009EC:
	.word DMA0SourceAddress
	.word DMA1SourceAddress
	.word DMA2SourceAddress
	.word DMA3SourceAddress
	thumb_func_end memory_80009CC

	thumb_local_start
memory_80009FC:
	push {r4,lr}
	ldr r3, off_8000A34 // =DMA0SourceAddress
loc_8000A00:
	mov r1, #0
	mov r4, #1
	tst r0, r4
	beq loc_8000A0C
	ldr r2, [r3,#0x8] // (DMA0WordCount - 0x40000b0)
	orr r1, r2
loc_8000A0C:
	mov r4, #2
	tst r0, r4
	beq loc_8000A16
	ldr r2, [r3,#0x14] // (DMA1WordCount - 0x40000b0)
	orr r1, r2
loc_8000A16:
	mov r4, #4
	tst r0, r4
	beq loc_8000A20
	ldr r2, [r3,#0x20] // (DMA2WordCount - 0x40000b0)
	orr r1, r2
loc_8000A20:
	mov r4, #8
	tst r0, r4
	beq loc_8000A2A
	ldr r2, [r3,#0x2c] // (DMA3WordCount - 0x40000b0)
	orr r1, r2
loc_8000A2A:
	ldr r2, dword_8000A38 // =0x80000000
	and r1, r2
	bne loc_8000A00
	pop {r4,pc}
	.balign 4, 0
off_8000A34:
	.word DMA0SourceAddress
dword_8000A38:
	.word 0x80000000
	thumb_func_end memory_80009FC

// symdb: Zeroes the 32-bit word at IWRAM address 0x0200AC1C; a tiny helper wrapper for clearing one state variable.
// symdb: void clearWord_e200AC1C(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/clearWord_e200AC1C.yaml
	thumb_func_start clearWord_e200AC1C
clearWord_e200AC1C:
	ldr r0, off_8000B10 // =dword_200AC1C
	mov r1, #0
	str r1, [r0]
	mov pc, lr
	thumb_func_end clearWord_e200AC1C

	thumb_func_start ProcessGFXTransferQueue
ProcessGFXTransferQueue:
	push {lr}
	mov r0, r8
	mov r1, r9
	push {r0,r1,r4-r7}
	ldr r0, off_8000B10 // =dword_200AC1C
	ldr r1, [r0]
	ldr r2, off_8000B14 // =fiveWordArr200B4B0
loc_8000A52:
	sub r1, #1
	blt loc_8000A96
	mov r8, r1
	mov r9, r2
	ldr r4, [r2,#0x10]
	cmp r4, #1
	bge loc_8000A7C
	ldr r4, [r2,#0xc]
	ldr r0, [r2]
	ldr r1, [r2,#4]
	ldr r2, [r2,#8]
	lsr r2, r2, #2
	mov r3, #3
	bl memory_80009CC
	mov r0, #8
	bl memory_80009FC
	mov r1, r8
	mov r2, r9
	b loc_8000A92
loc_8000A7C:
	sub r4, #1
	lsl r4, r4, #2
	ldr r0, [r2]
	ldr r1, [r2,#4]
	ldr r2, [r2,#8]
	ldr r3, off_8000AA4 // =CopyJumpTable8000AA8
	ldr r3, [r3,r4]
	mov lr, pc
	bx r3
	mov r1, r8
	mov r2, r9
loc_8000A92:
	add r2, #0x14
	b loc_8000A52
loc_8000A96:
	bl clearWord_e200AC1C
	pop {r0,r1,r4-r7}
	mov r8, r0
	mov r9, r1
	pop {pc}
	.balign 4, 0
off_8000AA4:
	.word CopyJumpTable8000AA8
CopyJumpTable8000AA8:
	.word CopyBytes+1
	.word CopyHalfwords+1
	.word CopyWords+1 // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	.word CopyByEightWords+1 // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	thumb_func_end ProcessGFXTransferQueue

	thumb_local_start
QueueUnk00GFXTransfer: // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r3, #0
	b loc_8000ACA

	thumb_local_start
QueueByteAlignedGFXTransfer: // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r3, #1
	b loc_8000ACA

	thumb_local_start
QueueHwordAlignedGFXTransfer: // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r3, #2
	b loc_8000ACA

// symdb: Queues a word-aligned GFX DMA copy into the global GFX transfer ring buffer (handler slot 3, copy_type 3).
// symdb: void queueWordAlignedGfxTransfer_8000AC4(u32 src /* r0 */, u32 dest /* r1 */, u32 size /* r2 */,
// symdb: lr /* lr */) -> (r3, nz/c/v)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/QueueWordAlignedGFXTransfer.yaml
	thumb_func_start QueueWordAlignedGFXTransfer
QueueWordAlignedGFXTransfer: // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r3, #3
	b loc_8000ACA

	thumb_func_start QueueEightWordAlignedGFXTransfer
QueueEightWordAlignedGFXTransfer: // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	mov r3, #4

// r0 - queued source
// r1 - queued dest
// r2 - queued size
// r3 - copy type (preset)
// preserves r0-r2
loc_8000ACA: // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32, copy_type: int) -> ()
	push {r4-r7}
	mov r7, r3
	ldr r3, off_8000B10 // =dword_200AC1C 
	// r4 = count of something?
	ldr r4, [r3]
	cmp r4, #0x60
	bge loc_8000AF4
	mov r5, r4
	add r4, #1
	str r4, [r3]
	ldr r4, off_8000B14 // =fiveWordArr200B4B0
	mov r6, #0x14
	// r5 = count * sizeof(fiveWordArr200B4B0)
	mul r5, r6
	// r4 = fiveWordArr200B4B0[top]
	add r4, r4, r5
	str r0, [r4]
	str r1, [r4,#4]
	str r2, [r4,#8]
	str r7, [r4,#0x10]
	ldr r3, off_8000AF8 // =dword_8000AFC
	lsl r7, r7, #2
	ldr r3, [r3,r7]
	str r3, [r4,#0xc]
loc_8000AF4:
	pop {r4-r7}
	mov pc, lr
	.balign 4, 0
off_8000AF8:
	.word dword_8000AFC
dword_8000AFC:
	.word 0x84000000
	.word 0xffffffff
	.word 0xffffffff
	.word 0xffffffff
	.word 0xffffffff
off_8000B10:
	.word dword_200AC1C
off_8000B14:
	.word fiveWordArr200B4B0
	thumb_func_end QueueUnk00GFXTransfer
	thumb_func_end QueueByteAlignedGFXTransfer
	thumb_func_end QueueHwordAlignedGFXTransfer
	thumb_func_end QueueWordAlignedGFXTransfer
	thumb_func_end QueueEightWordAlignedGFXTransfer


	thumb_local_start
unused_8000B18:
	push {r4-r7,lr}
	mov r7, r0
loc_8000B1C:
	ldr r0, [r7]
	tst r0, r0
	beq locret_8000B2E
	ldr r1, [r7,#4]
	ldr r2, [r7,#8]
	bl QueueUnk00GFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	add r7, #0xc
	b loc_8000B1C
locret_8000B2E:
	pop {r4-r7,pc}
	thumb_func_end unused_8000B18

// (u32 *initRefs) -> void
// This processes an array and performs different actions based on
// the type of u32 element in it.
// If the last bit of the elem is set, then it is a reference to
// compressed data: x_addr = x & ~0x80000000
// Elements are processed in triplets.
// In case of decompression:
//   .word src | 1<<32
//   .word
//   .word dest

// For compressed tuple3[0] case, decompresses tuple3[0] into tuple3[2] and then 
// copies content from tuple3[2] into tuple3[1] discounting the LZ77 data header. 
// If tuple3[1] is NULL, the copying doesn't happen, only decompression from tuple3[0] to tuple3[2].
// The copying into tuple3[1] is routed to an appropriate copy based on the number of bytes alignment.

// For the uncompressed tuple3[0] case, it just copies tuple3[0] into tuple3[1] by tuple3[2] bytes, also routing to copies appropriately.
// It terminates when it encounters a NULL after processing triplets.
// symdb: Table-driven ROM data loader that iterates 12-byte entries, LZ77-decompressing or plain-copying game asset data into RAM until a null terminator.
// symdb: void decompAndCopyData(u32 r0_table_ptr); // reads r2-r7 from caller; returns r1,r2,r3 clobbered
// symdb: by callees, r4-r7 preserved, flags from final test
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/decompAndCopyData.yaml
	thumb_func_start decompAndCopyData
decompAndCopyData:
	push {r4-r7,lr}

	mov r7, r0

loop_processArr_8000B34:
  // can be a compressed ptr
	ldr r0, [r7,#0]

  // NullStop check
	tst r0, r0
	beq ret_reachedTerminator_8000B8C
  
  // C flag is set on shifting compression bit
	lsl r0, r0, #1
	bcs isCompressedRef_8000B46
	lsr r0, r0, #1

  // copy dest
	ldr r1, [r7,#4]

	ldr r2, [r7,#8]
	b switch_8000B5E

isCompressedRef_8000B46:
	lsr r0, r0, #1

  // 3rd is decompression dest
	ldr r1, [r7,#8]
	mov r4, r1

	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()

  // 2nd in tuple can be null for compressed to skip additional copies
	ldr r1, [r7,#4]
	tst r1, r1
	beq continue_advance3Elements_8000B88
  
  // This is the portion after the LZ77 data header
	add r0, r4, #4

  // Loads first u32 from decomp buffer to get byte count
  // LZ77 data header states
  // Bit 8-31  Size of decompressed data
  // Subtracts by four probably to discount the 32-bit header
	ldr r2, [r4]
	lsr r2, r2, #8
	sub r2, #4
  
switch_8000B5E:

  // Determines whether r2 is aligned by 1, 2, 4 bytes (or else assumes 8) and routes to
  // the appropriate copy function

	mov r3, #1
	tst r3, r2
	bne bit0_set_8000B72

	mov r3, #3
	tst r3, r2
	bne bit1_set_8000B78

	// if any bit from 2 to 5 are set
	mov r3, #0x1f
	tst r3, r2
	bne bits5to0_set_8000B7E

	b default_8000B84
bit0_set_8000B72:
	bl CopyBytes // (u8 *src, u8 *dest, int byteCount) -> void

	b continue_advance3Elements_8000B88

bit1_set_8000B78:
	// if bit 0 or bit 1 are set. Since bit 0 was checked already,
	// this is for bit 1
	bl CopyHalfwords // (u16 *src, u16 *dest, int halfwordCount) -> void

	b continue_advance3Elements_8000B88

bits5to0_set_8000B7E:
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	b continue_advance3Elements_8000B88

default_8000B84:
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

continue_advance3Elements_8000B88:
	add r7, #0xc
	b loop_processArr_8000B34

ret_reachedTerminator_8000B8C:
	pop {r4-r7,pc}
	thumb_func_end decompAndCopyData

// (u32 *dataRefs) -> void
// [break] open PET
// symdb: Walks a 12-byte-per-entry list of graphics transfer requests and queues each copy to VRAM at the widest alignment the size permits, transparently LZ77-unpacking any entry that has GFX_SOURCE_PACKED set in its source word.
// symdb: void queueGFXTransfersInList_8000B8E(const GfxTransferEntry *list /*r0*/);
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/QueueGFXTransfersInList.yaml
	thumb_func_start QueueGFXTransfersInList
QueueGFXTransfersInList:
	push {r4-r7,lr}
	mov r7, r0
loc_8000B92:
	ldr r0, [r7]
	tst r0, r0
	beq locret_8000BEA
	lsl r0, r0, #1
	bcs loc_8000BA4
	lsr r0, r0, #1
	ldr r1, [r7,#4]
	ldr r2, [r7,#8]
	b loc_8000BBC
loc_8000BA4:
	lsr r0, r0, #1
	// dest
	ldr r1, [r7,#8]
	mov r4, r1
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()
	ldr r1, [r7,#4]
	tst r1, r1
	beq loc_8000BE6
	add r0, r4, #4
	ldr r2, [r4]
	lsr r2, r2, #8
	sub r2, #4
loc_8000BBC:
	mov r3, #1
	tst r3, r2
	bne loc_8000BD0
	mov r3, #3
	tst r3, r2
	bne loc_8000BD6
	mov r3, #0x1f
	tst r3, r2
	bne loc_8000BDC
	b loc_8000BE2
loc_8000BD0:
	bl QueueByteAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	b loc_8000BE6
loc_8000BD6:
	bl QueueHwordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	b loc_8000BE6
loc_8000BDC:
	bl QueueWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	b loc_8000BE6
loc_8000BE2:
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
loc_8000BE6:
	add r7, #0xc
	b loc_8000B92
locret_8000BEA:
	pop {r4-r7,pc}
	thumb_func_end QueueGFXTransfersInList

	thumb_local_start
unused_8000BEC:
	ldr r0, off_8000BF8 // =VerticalCounter_LY_
	ldrh r0, [r0]
	ldr r1, off_8000BFC // =dword_2009CC0
	ldr r1, [r1]
	add r0, r0, r1
	mov pc, lr
	.balign 4, 0
off_8000BF8:
	.word VerticalCounter_LY_
off_8000BFC:
	.word dword_2009CC0
	thumb_func_end unused_8000BEC

// converts a number to BCD for printing?
// symdb: Convert r0 to 8-digit packed BCD; values of 100000000 and above give 0x99999999.
// symdb: (r0 = value) -> r0 = r2 = BCD (in range); r0 = 0x99999999, r1 = 99999999 otherwise
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/memory_bcdConvert.yaml
	thumb_func_start memory_bcdConvert
memory_bcdConvert: 
	push {r4,r7,lr}
	ldr r1, dword_8000C54 // =0x5f5e0ff
	cmp r0, r1
	bmi loc_8000C0C
	ldr r0, dword_8000C58 // =0x99999999
	b locret_8000C2C
loc_8000C0C:
	ldr r7, off_8000C30 // =off_8000C34
	mov r2, #0
	mov r3, #8
loc_8000C12:
	lsl r2, r2, #4
	ldr r1, [r7]
	mov r4, #0
loc_8000C18:
	cmp r0, r1
	bmi loc_8000C22
	sub r0, r0, r1
	add r4, #1
	b loc_8000C18
loc_8000C22:
	orr r2, r4
	add r7, #4
	sub r3, #1
	bne loc_8000C12
	mov r0, r2
locret_8000C2C:
	pop {r4,r7,pc}
	.balign 4, 0
off_8000C30:
	.word off_8000C34
off_8000C34:
	.word 10000000
	.word 1000000
	.word 100000
	.word 10000
	.word 1000
	.word 100
	.word 10
	.word 1
dword_8000C54:
	.word   99999999
dword_8000C58:
	.word 0x99999999
	thumb_func_end memory_bcdConvert

	thumb_func_start countHexDigits_8000C5C
// get num bcd digits?
// symdb: Returns the number of hexadecimal digits (4-bit nibbles) needed to represent a value, with 0 counting as one digit.
// symdb: int countHexDigits(u32 value); // in: r0 = value; out: r0 = r1 = digit count, nzcv set from
// symdb: "adds r0, r1, #0" on the result
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/countHexDigits_8000C5C.yaml
countHexDigits_8000C5C:
	mov r1, #1

  // 0 if (a0)
	tst r0, r0
	beq loc_8000C6E

  // 0 then
  // u32 i = 0
	mov r1, #0
loc_8000C64:
  // 0.0 while (a0)
	tst r0, r0
	beq loc_8000C6E

  // a0 <<= 4
  // i++
	add r1, #1
	lsr r0, r0, #4

  // 0.0 do
	b loc_8000C64

// 0 endif
loc_8000C6E:
	mov r0, r1
	mov pc, lr
	thumb_func_end countHexDigits_8000C5C

// FILE segment shifts to RNG here

// symdb: Shuffles a byte array in place by performing a caller-given number of random swaps, using the primary game RNG.
// symdb: void ShuffleByteArray(u8* r0 array, u32 r1 length, u32 r2 swapCount) — modifies array in place;
// symdb: returns r0=array, r1=length (unchanged), r2=0 (decremented to zero), r3=index of first swap
// symdb: slot; Z/C/V set by the final decrement (Z set when swapCount reached 0)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ShuffleByteList_PrimaryRNG.yaml
	thumb_func_start ShuffleByteList_PrimaryRNG
ShuffleByteList_PrimaryRNG:
	push {r4-r6,lr}
loc_8000C74:
	push {r0,r2}
	push {r1}
	bl GetPositiveSignedRNG
	pop {r1}
	push {r1}
	svc 6
	mov r3, r1
	pop {r1}
	push {r1,r3}
	bl GetPositiveSignedRNG
	pop {r1}
	push {r1}
	svc 6
	mov r4, r1
	pop {r1,r3}
	pop {r0,r2}
	ldrb r5, [r0,r3]
	ldrb r6, [r0,r4]
	strb r6, [r0,r3]
	strb r5, [r0,r4]
	sub r2, #1
	bne loc_8000C74
	pop {r4-r6,pc}
	thumb_func_end ShuffleByteList_PrimaryRNG

	thumb_local_start
ShuffleByteList_SecondaryRNG:
	push {r4-r6,lr}
loc_8000CA8:
	push {r0,r2}
	push {r1}
	bl GetPositiveSignedRNGSecondary
	pop {r1}
	push {r1}
	svc 6
	mov r3, r1
	pop {r1}
	push {r1,r3}
	bl GetPositiveSignedRNGSecondary
	pop {r1}
	push {r1}
	svc 6
	mov r4, r1
	pop {r1,r3}
	pop {r0,r2}
	ldrb r5, [r0,r3]
	ldrb r6, [r0,r4]
	strb r6, [r0,r3]
	strb r5, [r0,r4]
	sub r2, #1
	bne loc_8000CA8
	pop {r4-r6,pc}
	thumb_func_end ShuffleByteList_SecondaryRNG

// symdb: Shuffles a list of u16 in place with the primary RNG, making r2 swaps of two entries, each index a GetPositiveSignedRNG draw mod r1 (the list length).
// symdb: (r0 = u16 *list, r1 = n, the list length (each index is a draw mod n), r2 = number of swaps,
// symdb: must be nonzero) -> r0 = list, r1 = n, r2 = 0, r3 = 2 * the last swap's first index; r4-r6
// symdb: preserved; clobbers lr and the flags. Two GetPositiveSignedRNG calls per swap.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/ShuffleHwordList_PrimaryRNG.yaml
	thumb_func_start ShuffleHwordList_PrimaryRNG
ShuffleHwordList_PrimaryRNG:
	push {r4-r6,lr}
loc_8000CDC:
	push {r0,r2}
	push {r1}
	bl GetPositiveSignedRNG
	pop {r1}
	push {r1}
	svc 6
	mov r3, r1
	pop {r1}
	push {r1,r3}
	bl GetPositiveSignedRNG
	pop {r1}
	push {r1}
	svc 6
	mov r4, r1
	pop {r1,r3}
	pop {r0,r2}
	add r3, r3, r3
	add r4, r4, r4
	ldrh r5, [r0,r3]
	ldrh r6, [r0,r4]
	strh r6, [r0,r3]
	strh r5, [r0,r4]
	sub r2, #1
	bne loc_8000CDC
	pop {r4-r6,pc}
	thumb_func_end ShuffleHwordList_PrimaryRNG

// symdb: Shuffles a u16 list in place by r2 random swaps: each swap picks two indices as secondary-RNG values modulo the list length (BIOS Div).
// symdb: (r0 = u16 *list, r1 = list length, r2 = number of swaps, at least 1) -> r0, r1 unchanged, r2 =
// symdb: 0, r3 = 2 * the first index of the last swap; r4-r6 restored; clobbers flags.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ShuffleHwordList_SecondaryRNG.yaml
	thumb_func_start ShuffleHwordList_SecondaryRNG
ShuffleHwordList_SecondaryRNG:
	push {r4-r6,lr}
loc_8000D14:
	push {r0,r2}
	push {r1}
	bl GetPositiveSignedRNGSecondary
	pop {r1}
	push {r1}
	svc 6
	mov r3, r1
	pop {r1}
	push {r1,r3}
	bl GetPositiveSignedRNGSecondary
	pop {r1}
	push {r1}
	svc 6
	mov r4, r1
	pop {r1,r3}
	pop {r0,r2}
	add r3, r3, r3
	add r4, r4, r4
	ldrh r5, [r0,r3]
	ldrh r6, [r0,r4]
	strh r6, [r0,r3]
	strh r5, [r0,r4]
	sub r2, #1
	bne loc_8000D14
	pop {r4-r6,pc}
	thumb_func_end ShuffleHwordList_SecondaryRNG

	thumb_local_start
unused_8000D4A:
	push {r7,lr}
	mov r7, r0
	push {r1,r7}
	bl GetPositiveSignedRNG
	pop {r1,r7}
	bl SWI_Div
	ldrb r0, [r7,r1]
	pop {r7,pc}
	thumb_func_end unused_8000D4A

	thumb_local_start
unused_8000D5E:
	push {r4,r6,lr}
	cmp r1, #2
	bmi locret_8000D82
	mov r3, #1
loc_8000D66:
	ldrb r2, [r0,r3]
	mov r4, #0
loc_8000D6A:
	ldrb r6, [r0,r4]
	cmp r2, r6
	bhi loc_8000D74
	strb r2, [r0,r4]
	mov r2, r6
loc_8000D74:
	add r4, #1
	cmp r4, r3
	bmi loc_8000D6A
	strb r2, [r0,r3]
	add r3, #1
	cmp r3, r1
	bmi loc_8000D66
locret_8000D82:
	pop {r4,r6,pc}
	thumb_func_end unused_8000D5E

// symdb: Converts the save/play-time frame counter into a packed-BCD HH:MM:SS.cc value used by the play-time display, capping at 99:59:59.99.
// symdb: u32 playtime_framesToPackedBcd(u32 frames /*r0*/); /* returns packed BCD in r0; r2 =
// symdb: minutes<<16, r3 = seconds<<8 on normal path (preserved on overflow); clobbers nzcv/r1; preserves
// symdb: r4,r7 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/memory_bcd_8000D84.yaml
	thumb_func_start memory_bcd_8000D84
memory_bcd_8000D84:
	push {lr}
	sub sp, sp, #0x10
	ldr r1, dword_8000DD8 // =0x1499727
	cmp r0, r1
	ble loc_8000D92
	ldr r0, dword_8000DDC // =0x99595999
	b loc_8000DD4
loc_8000D92:
	bl clock_breakPlayTimeIntoHMSF_8000DE0
	str r0, [sp]
	str r1, [sp,#4]
	str r2, [sp,#8]
	str r3, [sp,#0xc]
	bl memory_bcdConvert
	str r0, [sp]
	ldr r0, [sp,#4]
	bl memory_bcdConvert
	str r0, [sp,#4]
	ldr r0, [sp,#8]
	bl memory_bcdConvert
	str r0, [sp,#8]
	ldr r0, [sp,#0xc]
	mov r1, #0x64
	mul r0, r1
	mov r1, #0x3c
	svc 6
	bl memory_bcdConvert
	ldr r1, [sp]
	ldr r2, [sp,#4]
	ldr r3, [sp,#8]
	lsl r1, r1, #0x18
	lsl r2, r2, #0x10
	lsl r3, r3, #8
	add r0, r0, r1
	add r0, r0, r2
	add r0, r0, r3
loc_8000DD4:
	add sp, sp, #0x10
	pop {pc}
	.balign 4, 0
dword_8000DD8:
	.word 0x1499727
dword_8000DDC:
	.word 0x99595999
	thumb_func_end memory_bcd_8000D84

// symdb: Splits the play-time frame counter into hours, minutes, seconds and leftover frames via three BIOS divisions.
// symdb: Next sub_8000DE0(u32 totalFrames /* r0 */) -> hours /* r0 */, minutes /* r1 */, seconds /* r2
// symdb: */, frames /* r3 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/clock_breakPlayTimeIntoHMSF_8000DE0.yaml
	thumb_func_start clock_breakPlayTimeIntoHMSF_8000DE0
clock_breakPlayTimeIntoHMSF_8000DE0:
	push {lr}
	sub sp, sp, #0x10
	ldr r1, dword_8000E04 // =0x34bc0
	svc 6
	str r0, [sp]
	mov r0, r1
	ldr r1, off_8000E08 // =0xe10
	svc 6
	str r0, [sp,#4]
	mov r0, r1
	ldr r1, off_8000E0C // =0x3c
	svc 6
	mov r2, r0
	mov r3, r1
	ldr r0, [sp]
	ldr r1, [sp,#4]
	add sp, sp, #0x10
	pop {pc}
	.balign 4, 0
dword_8000E04:
	.word 0x34BC0
off_8000E08:
	.word 0xE10
off_8000E0C:
	.word 0x3C
	thumb_func_end clock_breakPlayTimeIntoHMSF_8000DE0

	thumb_func_start CapIncrementGameTimeFrames
CapIncrementGameTimeFrames: // () -> void
	mov r3, r10
	ldr r3, [r3,#oToolkit_S2001c04_Ptr]
	ldr r0, [r3,#oS2001c04_GameTimeFrames]
	add r0, #1

	// cap frame count
	ldr r1, dword_8000E24 // =0x14988f0
	cmp r0, r1
	ble loc_8000E20
	mov r0, r1
loc_8000E20:

	str r0, [r3,#oS2001c04_GameTimeFrames]
	mov pc, lr
dword_8000E24:
	.word 0x14988F0
	thumb_func_end CapIncrementGameTimeFrames

	thumb_func_start sub_8000E28
sub_8000E28:
	mov r3, r10
	ldr r3, [r3,#oToolkit_S2001c04_Ptr]
	ldr r0, [r3,#0x18]
	mov pc, lr
	thumb_func_end sub_8000E28

// symdb: Trivial stub that does nothing except return 0 in r0.
// symdb: int stub_returnZero(void) /* always returns 0 in r0; flags clobbered */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/stub_returnZero_8000E30.yaml
	thumb_func_start stub_returnZero_8000E30
stub_returnZero_8000E30:
	push {r4-r7,lr}
	mov r4, #0
	mov r0, r4
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end stub_returnZero_8000E30

// symdb: Picks a weighted-random index from a u8 weight table, stirring the RNG and using the current frame counter.
// symdb: u32 sub_8000E3A(const u8* table /* r0 */, s32 count /* r1 */, void* toolkit /* r10 */) -> r0
// symdb: chosen index, r2 chosen index, r3 last table byte read; clobbers r1, nzcv
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/pickWeightedIndex_8000E3A.yaml
	thumb_func_start pickWeightedIndex_8000E3A
pickWeightedIndex_8000E3A:
	push {r4-r7,lr}
	mov r4, r1
	push {r0,r1}
	push {r4}
	bl GetRNG // () -> u32?
	lsr r4, r0, #0x1e
	mov r0, r10
	ldr r0, [r0,#oToolkit_CurFramePtr]
	ldrh r0, [r0]
	mov r1, #3
	and r0, r1
	add r4, r4, r0
loc_8000E54:
	bl GetRNG // () -> u32?
	sub r4, #1
	bge loc_8000E54
	pop {r4}
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	pop {r6,r7}
	sub r7, #1
	push {r6,r7}
	mov r1, #0
loc_8000E6A:
	ldrb r3, [r6,r7]
	add r1, r1, r3
	sub r7, #1
	bge loc_8000E6A
	svc 6
	add r1, #1
	mov r2, #0
	pop {r6,r7}
	mov r0, #0
loc_8000E7C:
	ldrb r3, [r6,r2]
	add r0, r0, r3
	cmp r0, r1
	bge loc_8000E8C
	add r2, #1
	cmp r2, r4
	blt loc_8000E7C
	mov r2, #0
loc_8000E8C:
	mov r0, r2
	pop {r4-r7,pc}
	thumb_func_end pickWeightedIndex_8000E3A

	thumb_local_start
unused_8000E90:
	push {r5,r6,lr}
	add r5, r0, r1
	mov r6, r0
	mov r7, r0
loc_8000E98:
	ldrb r2, [r6]
	cmp r2, #0xff
	beq loc_8000EA2
	strb r2, [r7]
	add r7, #1
loc_8000EA2:
	add r6, #1
	sub r1, #1
	bne loc_8000E98
	mov r1, #0xff
loc_8000EAA:
	cmp r7, r5
	beq locret_8000EB4
	strb r1, [r7]
	add r7, #1
	b loc_8000EAA
locret_8000EB4:
	pop {r5,r6,pc}
	thumb_func_end unused_8000E90

	thumb_func_start sub_8000EB6
sub_8000EB6:
	push {r5-r7,lr}
	add r2, r1, r1
	add r5, r0, r2
	mov r6, r0
	mov r7, r0
	ldr r3, dword_8000EE0 // =0xffff
loc_8000EC2:
	ldrh r2, [r6]
	cmp r2, r3
	beq loc_8000ECC
	strh r2, [r7]
	add r7, #2
loc_8000ECC:
	add r6, #2
	sub r1, #1
	bne loc_8000EC2
loc_8000ED2:
	cmp r7, r5
	beq locret_8000EDC
	strh r3, [r7]
	add r7, #2
	b loc_8000ED2
locret_8000EDC:
	pop {r5-r7,pc}
	.balign 4, 0
dword_8000EE0:
	.word 0xFFFF
	thumb_func_end sub_8000EB6

// symdb: Counts how many of 9 title-screen reward icons the player has earned and returns the count plus a bitmask of which ones
// symdb: void GetTitleScreenIconCount(void) -> (u32 count r0, u16 bitmask r1); clobbers r2-r7, nzcv
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetTitleScreenIconCount.yaml
	thumb_func_start GetTitleScreenIconCount
GetTitleScreenIconCount: // () -> (u8, u16)
	push {r4-r7,lr}

	mov r4, #0
	mov r7, #0

	movflag EVENT_E00
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_8000EFA

	add r4, #1
	mov r0, #0x80
	orr r7, r0

loc_8000EFA:
	mov r0, #0
	bl countEventFlagChips_81207F8

	cmp r0, #0xc8
	blt loc_8000F0A

	add r4, #1
	mov r0, #0x40
	orr r7, r0

loc_8000F0A:
	mov r0, #1
	bl countEventFlagChips_81207F8

	cmp r0, #0x27
	blt loc_8000F1A

	add r4, #1
	mov r0, #0x20
	orr r7, r0

loc_8000F1A:
	mov r0, #2
	bl countEventFlagChips_81207F8

	cmp r0, #5
	blt loc_8000F2A

	add r4, #1
	mov r0, #0x10
	orr r7, r0

loc_8000F2A:
	mov r0, #5
	bl countEventFlagChips_81207F8

	cmp r0, #0xf
	blt loc_8000F3A

	add r4, #1
	mov r0, #8
	orr r7, r0

loc_8000F3A:
	mov r0, #4
	bl countEventFlagChips_81207F8

	cmp r0, #0x1d
	blt loc_8000F4A

	add r4, #1
	mov r0, #4
	orr r7, r0

loc_8000F4A:
	movflag EVENT_370
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_8000F5A

	add r4, #1
	mov r0, #2
	orr r7, r0

loc_8000F5A:
	movflag EVENT_340
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	beq loc_8000F6C

	add r4, #1
	mov r0, #0x10
	lsl r0, r0, #4
	orr r7, r0

loc_8000F6C:
	movflag EVENT_3BD
	mov r2, #5
	bl TestEventFlagRangeFromImmediate // (int a3, int a2) ->
	beq loc_8000F80

	add r4, #1
	mov r0, #0x20
	lsl r0, r0, #4
	orr r7, r0

loc_8000F80:

	mov r0, r4
	mov r1, r7

	pop {r4-r7,pc}

	thumb_func_end GetTitleScreenIconCount

	thumb_func_start sub_8000F86
sub_8000F86:
	push {r4-r7,lr}
	mov r4, r0
	bl toolkit_initAndVerifyWorkArea_0803F838 // () -> !zf
	bne locret_8000FAA
	// flag 7 @ 0x2001C88[0xE<<5 + 0x0] (=2001E48)
	movflag EVENT_E00
	bl SetEventFlagFromImmediate
	// flag 6 @ 0x2001C88[0x10<<5 + 0x0] (=2001E88)
	movflag EVENT_1001
	bl SetEventFlagFromImmediate
	mov r0, r10
	ldr r0, [r0,#oToolkit_S2001c04_Ptr]
	str r4, [r0,#0x18]
	bl save_writeAndVerifyEWRAMToSRAM_803F79E
locret_8000FAA:
	pop {r4-r7,pc}
	thumb_func_end sub_8000F86

// symdb: On entering a map, if the destination differs from the last map, or event flag 0x170C is set, clear the current battle data pointer and three overworld walk-step counters, then always clear flag 0x170C.
// symdb: () -> ; side effects: may zero GameState.CurBattleDataPtr and three counters in S2001c04; clears
// symdb: event flag 0x170C
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_resetStateIfMapChangedOrBattleEventFlag_8000FAC.yaml
	thumb_func_start battle_resetStateIfMapChangedOrBattleEventFlag_8000FAC
battle_resetStateIfMapChangedOrBattleEventFlag_8000FAC:
	push {r4-r7,lr}
	mov r5, r10
	ldr r5, [r5,#oToolkit_GameStatePtr]
	// flag 3 @ 0x2001C88[0x17<<5 + 0x1] (=2001F69)
	movflag EVENT_170C
	bl TestEventFlagFromImmediate // (flag: u16) -> !zf
	bne loc_8000FCE
	ldrb r0, [r5,#oGameState_MapGroup]
	ldrb r1, [r5,#oGameState_LastMapGroup]
	cmp r0, r1
	bne loc_8000FCE
	ldrb r0, [r5,#oGameState_MapNumber]
	ldrb r1, [r5,#oGameState_LastMapNumber]
	cmp r0, r1
	bne loc_8000FCE
	b loc_8000FDC
loc_8000FCE:
	mov r0, #0
	str r0, [r5,#oGameState_CurBattleDataPtr]
	mov r6, r10
	ldr r6, [r6,#oToolkit_S2001c04_Ptr]
	str r0, [r6,#0x1c]
	str r0, [r6,#0x2c]
	str r0, [r6,#0x28]
loc_8000FDC:
	movflag EVENT_170C
	bl ClearEventFlagFromImmediate // (flag: u16) -> ()
	pop {r4-r7,pc}
	thumb_func_end battle_resetStateIfMapChangedOrBattleEventFlag_8000FAC

	thumb_local_start
sub_8000FE6:
	push {r4-r7,lr}
	mov r6, r0
	mov r4, r1
loc_8000FEC:
	mov r0, r6
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8000FFA
	mov r0, r6
	bl reqBBS_addBBSMessage_813e5dc
loc_8000FFA:
	add r6, #1
	sub r4, #1
	bgt loc_8000FEC
	pop {r4-r7,pc}
	thumb_func_end sub_8000FE6

	thumb_local_start
sub_8001002:
	push {r4-r7,lr}
	ldr r0, off_8001010 // =0x17a0
	mov r1, #0xa
	bl sub_8000FE6
	pop {r4-r7,pc}
	.balign 4, 0
off_8001010:
	.word 0x17A0
	thumb_func_end sub_8001002

	thumb_local_start
sub_8001014:
	push {r4-r7,lr}
	mov r6, r0
	mov r4, r1
loc_800101A:
	mov r0, r6
	bl TestEventFlag // (flag: u16) -> !zf
	bne loc_8001028
	mov r0, r6
	bl reqBBS_addRequest_813F9A0
loc_8001028:
	add r6, #1
	sub r4, #1
	bgt loc_800101A
	pop {r4-r7,pc}
	push {r4-r7,lr}
	ldr r0, off_800103C // =0x17a0
	mov r1, #0xa
	bl sub_8001014
	pop {r4-r7,pc}
	.balign 4, 0
off_800103C:
	.word 0x17A0
	thumb_func_end sub_8001014

	thumb_func_start sub_8001040
sub_8001040:
	push {r4-r7,lr}
	mov r5, #1
	lsl r5, r5, #0x10
	b loc_800104A
loc_8001048:
	push {r4-r7,lr}
loc_800104A:
	mov r6, r10
	ldr r6, [r6,#oToolkit_CurFramePtr]
	ldrh r6, [r6]
	lsl r0, r0, #0x10
	orr r0, r1
	orr r0, r2
	mov r7, #0x10
	and r7, r6
	lsr r7, r7, #2
	add r1, r3, r7
	mov r3, #0xff
	and r3, r5
	lsr r2, r5, #0x10
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	tst r4, r4
	beq locret_8001078
	mov r7, #0xf
	and r7, r6
	bne locret_8001078
	mov r0, #0x91
	bl PlaySoundEffect
locret_8001078:
	pop {r4-r7,pc}
	thumb_func_end sub_8001040

// () -> void
// symdb: Copies the overworld player object's X/Y/Z position and facing direction into the game state, presumably to remember where the player stood before a warp.
// symdb: GameState* updatePlayerGameState_800107A(Toolkit* toolkit /* r10 */); returns r3 = game state
// symdb: pointer; clobbers r0, r1.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/updatePlayerGameState_800107A.yaml
	thumb_func_start updatePlayerGameState_800107A
updatePlayerGameState_800107A:
	mov r3, r10
	ldr r3, [r3,#oToolkit_GameStatePtr]
	ldr r1, [r3,#oGameState_OverworldPlayerObjectPtr]
	ldr r0, [r1,#0x1c]
	str r0, [r3,#oGameState_PlayerX]
	ldr r0, [r1,#0x20]
	str r0, [r3,#oGameState_PlayerY]
	ldr r0, [r1,#0x24]
	str r0, [r3,#oGameState_PlayerZ]
	ldrb r0, [r1,#0x10]
	str r0, [r3,#oGameState_FacingDirectionAfterWarp]
	mov pc, lr
	thumb_func_end updatePlayerGameState_800107A

// symdb: Saves the current real-world player position, Z layer, facing direction, and map id into the game state for later restoration.
// symdb: void saveRealWorldPos_8001092(s32 x /*r0*/, s32 y /*r1*/, s32 z /*r2*/,
// symdb: s32 facing /*r3*/, s32 mapId /*r4*/); // preserves: r4 r5 r6 r7 // r10 expected to be the
// symdb: toolkit base; no flags touched
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8001092.yaml
	thumb_local_start
sub_8001092:
	push {r4-r7,lr}
	mov r5, r10
	ldr r5, [r5,#oToolkit_GameStatePtr]
	str r0, [r5,#oGameState_SavedRealWorldX]
	str r1, [r5,#oGameState_SavedRealWorldY]
	str r2, [r5,#oGameState_SavedRealWorldZ]
	str r3, [r5,#oGameState_SavedRealWorldFacingDirection]
	str r4, [r5,#oGameState_SavedRealWorldMapId]
	pop {r4-r7,pc}
	thumb_func_end sub_8001092

	thumb_local_start
sub_80010A4:
	push {r4-r7,lr}
	mov r5, r10
	ldr r5, [r5,#oToolkit_GameStatePtr]
	str r0, [r5,#oGameState_SavedInternetX]
	str r1, [r5,#oGameState_SavedInternetY]
	str r2, [r5,#oGameState_SavedInternetZ]
	str r3, [r5,#oGameState_SavedInternetFacingDirection]
	str r4, [r5,#oGameState_SavedInternetMapId]
	pop {r4-r7,pc}
	thumb_func_end sub_80010A4


// symdb: Returns the navi currently selected on the PET, leaving the game state pointer in r3.
// symdb: u8 GetCurPETNavi(void); inputs r10 (toolkit), lr; outputs r0 (navi id), r3 (game state pointer)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetCurPETNavi.yaml
	thumb_func_start GetCurPETNavi
GetCurPETNavi: // () -> u8
	mov r3, r10
	ldr r3, [r3,#oToolkit_GameStatePtr]
	ldrb r0, [r3,#oGameState_CurPETNavi]
	mov pc, lr
	thumb_func_end GetCurPETNavi


// symdb: Stores the selected PET navi index (r0) into the game state's CurPETNavi byte.
// symdb: void SetCurPETNavi(u8 naviIndex /* r0, via r10 = toolkit, returns game state ptr in r3 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetCurPETNavi.yaml
	thumb_func_start SetCurPETNavi
SetCurPETNavi:
	mov r3, r10
	ldr r3, [r3,#oToolkit_GameStatePtr]
	strb r0, [r3,#oGameState_CurPETNavi]
	mov pc, lr
	thumb_func_end SetCurPETNavi


// symdb: Writes the currently selected PET navi ID (from GetCurPETNavi) into byte +7 of the toolkit's S2001c04 struct.
// symdb: void pet_writeCurNaviIdToS2001c04(r10 toolkitPtr); // in: r10 = toolkit pointer; out: r0 = navi
// symdb: ID (passthrough), r3 = S2001c04 pointer; clobbers lr
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/writeCurPETNaviToS2001c04_Unk07_80010c6.yaml
	thumb_func_start writeCurPETNaviToS2001c04_Unk07_80010c6
writeCurPETNaviToS2001c04_Unk07_80010c6:
	push {lr}
	bl GetCurPETNavi // () -> u8
	mov r3, r10
	ldr r3, [r3,#oToolkit_S2001c04_Ptr]
	strb r0, [r3,#oS2001c04_CurPETNaviId]
	pop {pc}
	thumb_func_end writeCurPETNaviToS2001c04_Unk07_80010c6

// symdb: Reads the max HP and current HP of the navi currently equipped in the PET and returns them as a pair.
// symdb: u16 pet_GetMaxAndCurHPForCurNavi(u8 which_navi); /* returns curHP in r0, maxHP in r1; c=v=0, nz
// symdb: from the adds-encoded "mov r1, r6" (i.e. from maxHP) */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetMaxAndCurHPForCurPETNavi_80010D4.yaml
	thumb_func_start GetMaxAndCurHPForCurPETNavi_80010D4
GetMaxAndCurHPForCurPETNavi_80010D4: // (which_navi: u8) -> (u16, u16)
	push {r4-r7,lr}

	mov r4, r0
	mov r1, #oNaviStats_MaxHP
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16

	mov r6, r0

	mov r0, r4
	mov r1, #oNaviStats_CurHP
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16

	mov r1, r6

	pop {r4-r7,pc}
	thumb_func_end GetMaxAndCurHPForCurPETNavi_80010D4

// symdb: Clamps a requested value for PET navi stat 0x40 to the existing cap held in stat 0x42, then stores it.
// symdb: u8 which_navi (r0), s32 requested_value (r1) -> void (returns via pop {pc}); r4-r7 preserved.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_80010EC.yaml
	thumb_func_start sub_80010EC
sub_80010EC:
	push {r4-r7,lr}
	mov r4, r0
	mov r6, r1
	mov r1, #0x42
	bl GetCurPETNaviStatsHword // (which_navi: u8, which_stat: u8) -> u16
	cmp r6, r0
	ble loc_80010FE
	mov r6, r0
loc_80010FE:
	mov r0, r4
	mov r1, #0x40
	mov r2, r6
	bl SetCurPETNaviStatsHword
	pop {r4-r7,pc}
	thumb_func_end sub_80010EC

	thumb_local_start
sub_800110A:
	push {r4-r7,lr}
	ldr r6, off_8001140 // =byte_8001144
	mov r7, r0
	sub r5, r1, #2
	mov r4, #0xf
loc_8001114:
	ldrh r0, [r7,r5]
	lsr r3, r0, #0xc
	and r3, r4
	lsr r2, r0, #8
	and r2, r4
	lsr r1, r0, #4
	and r1, r4
	and r0, r4
	ldrb r0, [r6,r0]
	ldrb r1, [r6,r1]
	lsl r1, r1, #4
	orr r0, r1
	ldrb r2, [r6,r2]
	lsl r2, r2, #8
	orr r0, r2
	ldrb r3, [r6,r3]
	lsl r3, r3, #0xc
	orr r0, r3
	strh r0, [r7,r5]
	sub r5, #2
	bge loc_8001114
	pop {r4-r7,pc}
off_8001140:
	.word byte_8001144
byte_8001144:
	.byte 0x0, 0x1, 0x2, 0x3, 0x0, 0x5, 0x6, 0x7, 0x0, 0x9, 0xA, 0xB, 0x0, 0xD, 0xE
	.byte 0xF
	thumb_func_end sub_800110A

	thumb_func_start sub_8001154
sub_8001154:
	push {r4-r7,lr}
	pop {r4-r7,pc}
	thumb_func_end sub_8001154

// () -> void
// symdb: Walks a script table (array of {cmd, arg} pairs terminated by a zero cmd) and dispatches each pair to sub_802FE28.
// symdb: void sub_8001158(const void *scriptTable);  // r0 = list ptr; clobbers r0-r3, r5, lr; flags NZ
// symdb: clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/scriptListRun_8001158.yaml
	thumb_func_start scriptListRun_8001158
scriptListRun_8001158:
	push {r4-r7,lr}
	mov r7, r0
loc_800115C:
	ldr r0, [r7]
	tst r0, r0
	beq locret_8001170
	ldr r1, [r7,#4]
	mov r2, #0
	mov r3, #0
	bl sprite_queueOamEntryThunk_802FE28 // (u32 a1, u16 a2, int notUsed, int a4) -> void
	add r7, #8
	b loc_800115C
locret_8001170:
	pop {r4-r7,pc}
	thumb_func_end scriptListRun_8001158

// symdb: Sets GameState's Unk_09 byte (related to "can't jack out" / L-button-message-style control flag) to the given u8
// symdb: (r0 = value) -> void ; side effects: writes Toolkit->GameStatePtr->Unk_09 (a single byte at
// symdb: offset 0x9)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/gameState_setUnk09_8001172.yaml
	thumb_func_start gameState_setUnk09_8001172
gameState_setUnk09_8001172:
	mov r3, r10
	ldr r3, [r3,#oToolkit_GameStatePtr]
	strb r0, [r3,#oGameState_JackOutLockState]
	mov pc, lr
	.balign 4, 0x00
	thumb_func_end gameState_setUnk09_8001172

// symdb: Returns the direction of a fixed-point (x,y) vector as a single byte (0..255 over a full turn), via the BIOS ArcTan2 call.
// symdb: u8 math_vectorAngleByte(s16_16p dx /* r0, upper 16 bits meaningful */, s16_16p dy /* r1, upper
// symdb: 16 bits meaningful */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/calcAngle_800117C.yaml
	thumb_func_start calcAngle_800117C
calcAngle_800117C:
	push {lr}
	asr r2, r0, #0x10
	asr r0, r1, #0x10
	mov r1, r2
	svc 0xa
	lsr r0, r0, #8
	pop {pc}
	thumb_func_end calcAngle_800117C

// symdb: Wraps calcAngle_800117C into one of four octant buckets (1..4) for AI/range logic, returning 0 when the input vector is zero.
// symdb: (r0 = dx, r1 = dy) -> r0 = 0 when r0|r1==0, else a value in {1,2,3,4} (octant bucket derived
// symdb: from the 0..255 angle)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_calcAngleOctant_800118A.yaml
	thumb_func_start battle_calcAngleOctant_800118A
battle_calcAngleOctant_800118A:
	push {lr}
	mov r2, r0
	orr r2, r1
	beq locret_800119E
	bl calcAngle_800117C
	add r0, #0x20
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1e
	add r0, #1
locret_800119E:
	pop {pc}
	thumb_func_end battle_calcAngleOctant_800118A

// symdb: converts an angle index plus magnitude into a (dx, dy) vector using the cosine/sine tables, with the y component negated for screen coordinates
// symdb: (r0 = angle table index, r1 = magnitude/scale) -> r0 = cos(angle)*mag >> 8, r1 = -sin(angle)*mag
// symdb: >> 8; flags clobbered, r2-r3 clobbered
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/math_getPolarVector.yaml
	thumb_func_start math_getPolarVector
math_getPolarVector:
	lsl r0, r0, #1
	ldr r2, off_80011B8 // =math_cosTable
	ldrsh r3, [r2,r0]
	ldr r2, off_80011BC // =byte_80066E0
	ldrsh r2, [r2,r0]
	neg r2, r2
	mul r3, r1
	asr r0, r3, #8
	mul r2, r1
	asr r1, r2, #8
	mov pc, lr
	.balign 4, 0
off_80011B8:
	.word math_cosTable
off_80011BC:
	.word byte_80066E0
	thumb_func_end math_getPolarVector

	thumb_local_start
sub_80011C0:
	push {lr}
	tst r0, r0
	beq loc_80011D0
	sub r0, #1
	lsl r0, r0, #6
	bl math_getPolarVector
	pop {pc}
loc_80011D0:
	mov r0, #0
	mov r1, #0
	pop {pc}
	thumb_func_end sub_80011C0

// symdb: Returns 1 if an overworld object (or NPC) lies within a signed-axis-aligned cube of half-extent `r4` around the point `(r0, r1)` on the XY plane with both Z extents checked `>= 0`; 0 otherwise.
// symdb: (r0 = X0 unsigned fixed, r1 = Y0 unsigned fixed, r2 = X1 unsigned fixed, r3 = Y1 unsigned fixed,
// symdb: r4 = half-extent in q16.16 + Z-extent also r4) -> r0 = 0/1
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/overworldObject_withinBoxCheck_signed_80011D6.yaml
	thumb_func_start overworldObject_withinBoxCheck_signed_80011D6
overworldObject_withinBoxCheck_signed_80011D6:
	sub r0, r0, r2
	add r0, r0, r4
	lsl r2, r4, #1
	cmp r0, r2
	bcs loc_80011EC
	sub r1, r1, r3
	add r1, r1, r4
	cmp r1, r2
	bcs loc_80011EC
	mov r0, #1
	mov pc, lr
loc_80011EC:
	mov r0, #0
	mov pc, lr
	thumb_func_end overworldObject_withinBoxCheck_signed_80011D6

	thumb_local_start
sub_80011F0:
	sub r0, r0, r2
	sub r1, r1, r3
	mov r2, r4
	mul r4, r2
	mov r2, r0
	mul r0, r2
	mov r2, r1
	mul r1, r2
	add r0, r0, r1
	cmp r4, r0
	bmi loc_800120A
	mov r0, #1
	mov pc, lr
loc_800120A:
	mov r0, #0
	mov pc, lr
	thumb_func_end sub_80011F0

// symdb: Math helper that computes, from a target descriptor and current position, how many frames an approach takes and the per-frame step toward it.
// symdb: (r0 = target struct ptr: +0 dx, +4 dy, +8 target coord, all 8.8 fixed point; r1 = cur x, r2 =
// symdb: cur y, r3 = cur coord on the driven axis, r4 = speed (0 = special case), r6 = divisor/param) ->
// symdb: r0/r1 = computed step count and per-frame delta (rounded), or 0,0 when already at/past target
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/battle_calcTargetApproach.yaml
	thumb_func_start battle_calcTargetApproach
battle_calcTargetApproach:
	push {r5,lr}
	tst r4, r4
	bne loc_800123C
loc_8001214:
	ldr r0, [r0,#8]
	sub r0, r3, r0
	bmi loc_8001220
	mov r0, r4
	mov r1, #0
	pop {r5,pc}
loc_8001220:
	lsr r1, r6, #8
	bl SWI_Div
	bl SWI_Sqrt
	mov r2, #0
	mov r1, #0xff
	tst r0, r1
	beq loc_8001234
	mov r2, #1
loc_8001234:
	lsr r0, r0, #8
	add r1, r0, r2
	mov r0, #0
	pop {r5,pc}
loc_800123C:
	ldmia r0!, {r5,r7}
	push {r0,r3}
	sub r1, r1, r5
	asr r1, r1, #8
	mov r5, r1
	mul r1, r5
	sub r2, r2, r7
	asr r2, r2, #8
	mov r5, r2
	mul r2, r5
	add r0, r1, r2
	bl SWI_Sqrt
	lsl r0, r0, #8
	push {r4}
	mov r1, r4
	bl SWI_Div
	pop {r4}
	lsr r4, r4, #1
	cmp r1, r4
	bmi loc_800126A
	add r0, #1
loc_800126A:
	mov r1, r0
	pop {r0,r3}
	tst r1, r1
	beq loc_8001214
	ldr r0, [r0]
	sub r0, r3, r0
	push {r1}
	bl SWI_Div
	pop {r1}
	neg r2, r6
	mul r2, r1
	lsr r2, r2, #1
	add r0, r0, r2
	pop {r5,pc}
	thumb_func_end battle_calcTargetApproach

	thumb_local_start
sub_8001288:
	push {lr}
	ldr r7, [r0]
	sub r1, r1, r7
	ldr r7, [r0,#4]
	sub r2, r2, r7
	push {r1,r2}
	lsl r0, r3, #1
	neg r1, r4
	bl SWI_Div
	lsr r3, r3, #1
	cmp r1, r3
	bmi loc_80012A4
	add r0, #1
loc_80012A4:
	pop {r1,r2}
	push {r0,r1}
	mov r1, r0
	mov r0, r2
	bl SWI_Div
	mov r2, r0
	pop {r0,r1}
	push {r0,r2}
	mov r2, r1
	mov r1, r0
	mov r0, r2
	bl SWI_Div
	mov r1, r0
	pop {r0,r2}
	pop {pc}
	thumb_func_end sub_8001288

	thumb_local_start
sub_80012C6:
	push {lr}
	mov r7, r8
	push {r7}
	sub sp, sp, #8
	str r5, [sp]
	push {r4,r6}
	ldmia r0!, {r3-r5}
	sub r0, r2, r4
	sub r1, r1, r3
	push {r0,r1}
	bl calcAngle_800117C
	mov r8, r0
	mov r4, r0
	pop {r0,r1}
	asr r0, r0, #8
	mov r2, r0
	mul r0, r2
	asr r1, r1, #8
	mov r2, r1
	mul r1, r2
	add r0, r0, r1
	svc 8
	lsl r0, r0, #8
	mov r1, r6
	lsl r1, r1, #1
	svc 6
	mov r1, r0
	mov r0, r4
	bl math_getPolarVector
	pop {r4,r6}
	push {r0,r1}
	lsl r0, r4, #1
	mov r1, r6
	mul r1, r6
	lsl r0, r0, #0x10
	bl SWI_Div
	neg r3, r0
	mul r0, r6
	mov r2, r0
	pop {r0,r1}
	ldr r5, [sp]
	add sp, sp, #8
	mov r4, r8
	add r4, #0x20
	mov r6, #0xe0
	and r4, r6
	lsr r4, r4, #5
	pop {r7}
	mov r8, r7
	pop {pc}
	thumb_func_end sub_80012C6

	thumb_func_start math_getThrowSpeeds
math_getThrowSpeeds:
	push {r4-r6,lr}
	push {r3,r4,r6}
	mov r6, r4
	ldmia r0!, {r3-r5}
	push {r5}
	sub r0, r2, r4
	sub r1, r1, r3
	push {r0,r1}
	bl calcAngle_800117C
	mov r4, r0
	pop {r0,r1}
	asr r0, r0, #8
	mov r2, r0
	mul r0, r2
	asr r1, r1, #8
	mov r2, r1
	mul r1, r2
	add r0, r0, r1
	svc 8
	lsl r0, r0, #8
	mov r1, r6
	svc 6
	mov r1, r0
	mov r0, r4
	bl math_getPolarVector
	pop {r5}
	pop {r3,r4,r6}
	push {r0,r1}
	mov r0, r4
	mul r0, r4
	mul r0, r6
	asr r0, r0, #1
	sub r3, r3, r5
	sub r0, r3, r0
	mov r1, r4
	svc 6
	mov r2, r0
	pop {r0,r1}
	pop {r4-r6,pc}
	thumb_func_end math_getThrowSpeeds

// symdb: Sets the caller-supplied bit(s) in the current battle state's flags word at +0x5c.
// symdb: void battle_orStateFlags5c_ADDRESS(u32 bits /* r0 */) ; returns r1 = battle state ptr, r2 =
// symdb: updated flags word ; clobbers NZ
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_orStateFlags5c_8001382.yaml
	thumb_func_start battle_orStateFlags5c_8001382
battle_orStateFlags5c_8001382:
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldr r2, [r1,#oBattleState_AlliancePermissionFlags]
	orr r2, r0
	str r2, [r1,#oBattleState_AlliancePermissionFlags]
	mov pc, lr
	thumb_func_end battle_orStateFlags5c_8001382

	thumb_local_start
sub_800138E:
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	ldr r2, [r1,#oBattleState_AlliancePermissionFlags]
	bic r2, r0
	str r2, [r1,#oBattleState_AlliancePermissionFlags]
	mov pc, lr
	thumb_func_end sub_800138E

// symdb: Getter that returns the value of the battle state's Unk_5c field.
// symdb: int battle_getStateUnk5c(void) — reads the toolkit pointer from r10 (caller's context), returns
// symdb: the u32 at battleState->Unk_5c in r0; no flags read or meaningful on return.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_getStateUnk5c_800139A.yaml
	thumb_func_start battle_getStateUnk5c_800139A
battle_getStateUnk5c_800139A:
	mov r0, r10
	ldr r0, [r0,#oToolkit_BattleStatePtr]
	ldr r0, [r0,#oBattleState_AlliancePermissionFlags]
	mov pc, lr
	thumb_func_end battle_getStateUnk5c_800139A

// symdb: Stores a caller-supplied word into the current battle state's field at offset 0x5c and hands back the battle state pointer.
// symdb: void battle_SetStateUnk5c(u32 value); /* in: r0=value, r10=toolkit; out: r1=battle state ptr */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/battle_SetStateUnk5c_80013A2.yaml
	thumb_func_start battle_SetStateUnk5c_80013A2
battle_SetStateUnk5c_80013A2:
	mov r1, r10
	ldr r1, [r1,#oToolkit_BattleStatePtr]
	str r0, [r1,#oBattleState_AlliancePermissionFlags]
	mov pc, lr
	thumb_func_end battle_SetStateUnk5c_80013A2

	thumb_local_start
sub_80013AA:
	push {r4-r7,lr}
	sub sp, sp, #0x40
	str r6, [sp,#4]
	str r7, [sp,#0x10]
	ldr r7, off_80014B8 // =eCamera+76
	ldrb r7, [r7]
	str r3, [sp,#0x24]
	str r4, [sp,#0x28]
	str r2, [sp]
	mov r2, #0xff
	and r2, r1
	str r2, [sp,#0x20]
	mov r2, r1
	lsl r2, r2, #0x17
	lsr r2, r2, #0x1f
	eor r2, r7
	str r2, [sp,#0x38]
	neg r2, r2
	add r2, r2, r2
	add r2, #1
	str r2, [sp,#0x18]
	mov r2, r1
	lsl r2, r2, #0x16
	lsr r2, r2, #0x1f
	str r2, [sp,#0x3c]
	neg r2, r2
	add r2, r2, r2
	add r2, #1
	str r2, [sp,#0x1c]
	lsl r5, r5, #0xc
	str r5, [sp,#0x2c]
	ldr r1, [sp,#0x20]
	lsl r1, r1, #2
	ldr r1, [r0,r1]
	add r1, r1, r0
	ldr r2, [r1,#4]
	add r2, r2, r0
	str r2, [sp,#0xc]
	ldr r2, [r1]
	add r2, r2, r0
	str r2, [sp,#8]
	ldr r2, [r1,#8]
	ldr r3, [r2,r0]
	add r2, r2, r3
	add r2, r2, r0
	ldrb r2, [r2]
	lsl r2, r2, #2
	ldr r3, [r1,#0xc]
	add r3, r3, r0
	ldr r2, [r3,r2]
	add r3, r3, r2
	ldr r2, [sp]
	ldr r4, [sp,#4]
	mov r1, #0
	str r1, [sp,#0x14]
loc_8001418:
	ldrb r0, [r3]
	cmp r0, #0xff
	beq loc_80014A8
	ldr r1, [sp,#0x10]
	sub r1, #8
	str r1, [sp,#0x10]
	blt loc_80014A8
	ldr r1, [sp,#0x2c]
	add r0, r0, r1
	ldr r1, [sp,#4]
	add r0, r0, r1
	str r0, [r2,#4]
	ldrb r0, [r3,#4]
	ldrb r1, [r3,#3]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	lsl r4, r0, #2
	add r4, r4, r1
	add r4, r4, r4
	ldr r5, off_80014B4 // =byte_80014BC
loc_8001440:
	add r4, r4, r5
	ldrb r5, [r4]
	ldr r6, [sp,#0x38]
	mul r5, r6
	str r5, [sp,#0x30]
	ldrb r5, [r4,#1]
	ldr r6, [sp,#0x3c]
	mul r5, r6
	str r5, [sp,#0x34]
	lsl r0, r0, #0xe
	lsl r1, r1, #0x1e
	add r0, r0, r1
	mov r1, #2
	ldrsb r4, [r3,r1]
	ldr r1, [sp,#0x1c]
	mul r1, r4
	ldr r4, [sp,#0x28]
	add r1, r1, r4
	ldr r4, [sp,#0x34]
	sub r1, r1, r4
	lsl r1, r1, #0x17
	lsr r1, r1, #0x17
	add r0, r0, r1
	mov r1, #1
	ldrsb r1, [r3,r1]
	ldr r4, [sp,#0x18]
	mul r1, r4
	ldr r4, [sp,#0x24]
	add r1, r1, r4
	ldr r4, [sp,#0x30]
	sub r1, r1, r4
	lsl r1, r1, #0x17
	lsr r1, r1, #7
	add r0, r0, r1
	ldr r1, [sp,#0x38]
	lsl r1, r1, #0x1c
	ldrb r4, [r3,#3]
	mov r5, #0xf0
	and r5, r4
	lsl r5, r5, #0x16
	eor r1, r5
	add r0, r0, r1
	ldr r1, [sp,#0x3c]
	lsl r1, r1, #0x1d
	add r0, r0, r1
	str r0, [r2]
	ldr r1, [sp,#0x14]
	add r1, #1
	str r1, [sp,#0x14]
	add r2, #8
	add r3, #5
	b loc_8001418
loc_80014A8:
	ldr r0, [sp,#8]
	ldr r1, [sp,#0xc]
	ldr r2, [sp,#0x14]
	add sp, sp, #0x40
	pop {r4-r7,pc}
	.balign 4, 0
off_80014B4:
	.word byte_80014BC
off_80014B8:
	.word eCamera+0x4C // eCamera.unk_4C
byte_80014BC:
	.byte 0x8, 0x8, 0x10, 0x10, 0x20, 0x20, 0x40, 0x40
	.word byte_8200810
	.word 0x20401020
	.word 0x20081008
	.word 0x40202010
	thumb_func_end sub_80013AA

// symdb: computes sqrt(x²+y²) of a 2D vector in 20.12 fixed point via the BIOS Sqrt SWI
// symdb: (r0 = x in 20.12 fixed, r1 = y in 20.12 fixed) -> r0 = sqrt(x²+y²) in 20.12 fixed; flags from
// symdb: final lsl
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/calc_hypotFixed12.yaml
	thumb_func_start calc_hypotFixed12
calc_hypotFixed12:
	push {lr}
	asr r0, r0, #0xc
	mov r2, r0
	mul r0, r2
	asr r1, r1, #0xc
	mov r2, r1
	mul r1, r2
	add r0, r0, r1
	svc 8
	lsl r0, r0, #0xc
	pop {pc}
	.balign 4, 0x00
	thumb_func_end calc_hypotFixed12

/// Another function for copying words
/// except it will do a backwards copy if
/// source < dest, otherwise it will do a
/// forwards copy. This may possibly be
/// for when the source and dest overlap

/* (r0:uint * src, r1:uint * dest, r2:int size) -> void
   preserves: r0-r7,lr
   ignores: r4-r12*/
// symdb: Word-aligned memmove — copies a byte count of words from source to destination, copying backwards when the regions overlap with destination above source.
// symdb: void memmoveWords(u32* src /*r0*/, u32* dst /*r1*/, s32 sizeBytes /*r2*/) — preserves r0-r7 and
// symdb: lr, sets NZCV per the final loop-counter subtraction
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyWords_80014EC.yaml
	thumb_func_start copyWords_80014EC
copyWords_80014EC: // 80014EC
	push {r0-r7,lr}
	cmp r0, r1
	blt .doReverseCopy
.forwardsCopyLoop
	ldr r3, [r0]
	str r3, [r1]
	add r0, #4
	add r1, #4
	sub r2, #4
	// while (a3_size > 0);
	bgt .forwardsCopyLoop
	pop {r0-r7,pc}
.doReverseCopy
	sub r2, #4
	add r0, r0, r2
	add r1, r1, r2
.reverseCopyLoop
	ldr r3, [r0]
	str r3, [r1]
	sub r0, #4
	sub r1, #4
	sub r2, #4
	// while (a3_size >= 0);
	bge .reverseCopyLoop
	pop {r0-r7,pc}
	thumb_func_end copyWords_80014EC

/// tags: "#mod_rng, "
// symdb: Resets the primary RNG seed variable to its fixed initial value 0xA338244F.
// symdb: void SeedRNG(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SeedRNG.yaml
	thumb_func_start SeedRNG
SeedRNG: // () -> ()
	ldr r0, rng_8001594 // =0xa338244f
	ldr r1, off_8001598 // =ePrimaryRngSeed
	str r0, [r1]
	mov pc, lr
	thumb_func_end SeedRNG

/// tags: "#mod_rng, "
// symdb: Advances the global primary RNG seed and returns the new 32-bit value.
// symdb: (void) -> u32 nextSeed; preserves r7; returns r0 = new seed (r1/r2/r3 also hold the XOR
// symdb: constant, seed<<1, seed>>31); nz from final EOR, c/v from the "+1" add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetRNG.yaml
	thumb_func_start GetRNG
GetRNG: // () -> u32?
	push {r7,lr}
	ldr r7, off_800159C // =ePrimaryRngSeed
	ldr r0, [r7]
	ldr r1, rng_80015A0 // =0x873ca9e5
	lsl r2, r0, #1
	lsr r3, r0, #0x1f
	add r0, r2, r3
	add r0, #1
	eor r0, r1
	str r0, [r7]
	pop {r7,pc}
	thumb_func_end GetRNG

/// tags: "#mod_rng, "
// symdb: Advances the game's primary RNG seed with a rotate/increment/XOR step and returns the new seed as a non-negative (sign-cleared) value.
// symdb: u32 GetPositiveSignedRNG(void) // in: r7=scratch; out: r0=new seed with bit31 cleared,
// symdb: r2/r3=shift temporaries, c=0, v=0, nz from result; preserves r7
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetPositiveSignedRNG.yaml
	thumb_func_start GetPositiveSignedRNG
GetPositiveSignedRNG:
	push {r7,lr}
	ldr r7, off_80015A4 // =ePrimaryRngSeed
	ldr r0, [r7]
	ldr r1, rng_80015A0 // =0x873ca9e5
	lsl r2, r0, #1
	lsr r3, r0, #0x1f
	add r0, r2, r3
	add r0, #1
	eor r0, r1
	str r0, [r7]
	lsl r0, r0, #1
	lsr r0, r0, #1
	pop {r7,pc}
	thumb_func_end GetPositiveSignedRNG

/// tags: "#mod.rng, "
// symdb: Advances the secondary RNG seed one step and stores it back to eSecondaryRngSeed.
// symdb: void GetRNGSecondary(void); /* leaves new seed in r0, intermediates in r1-r3, sets nz/c/v from
// symdb: the add and eor */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetRNGSecondary.yaml
	thumb_func_start GetRNGSecondary
GetRNGSecondary: // () -> void
	push {r7,lr}
	ldr r7, off_80015A8 // =eSecondaryRngSeed
	ldr r0, [r7]
	ldr r1, rng_80015A0 // =0x873ca9e5
	lsl r2, r0, #1
	lsr r3, r0, #0x1f
	add r0, r2, r3
	add r0, #1
	eor r0, r1
	str r0, [r7]
	pop {r7,pc}
	thumb_func_end GetRNGSecondary

/// tags: "#mod.rng, "
// symdb: Advances the game's secondary RNG seed and returns it as a non-negative signed value for caller convenience.
// symdb: u32 GetPositiveSignedRNGSecondary(void); // in: none (r7 preserved as save/restore scratch) //
// symdb: out: r0 = new seed with bit 31 cleared (always in [0, 0x7FFFFFFF]) //      r2 = old seed << 1,
// symdb: r3 = old seed >> 31 (callers reportedly reuse these) // clobbers: r1, flags NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetPositiveSignedRNGSecondary.yaml
	thumb_func_start GetPositiveSignedRNGSecondary
GetPositiveSignedRNGSecondary:
	push {r7,lr}
	ldr r7, off_80015AC // =eSecondaryRngSeed
	ldr r0, [r7]
	ldr r1, rng_80015A0 // =0x873ca9e5
	lsl r2, r0, #1
	lsr r3, r0, #0x1f
	add r0, r2, r3
	add r0, #1
	eor r0, r1
	str r0, [r7]
	lsl r0, r0, #1
	lsr r0, r0, #1
	pop {r7,pc}
	thumb_func_end GetPositiveSignedRNGSecondary

/// tags: "#mod.rng, #dead, "
// symdb: Steps the unused third RNG state at dword_20018E8 with the primary's recurrence; dead code, no caller.
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/dead_rng_800157C.yaml
	thumb_local_start
dead_rng_800157C:
	push {r7,lr}
	ldr r7, off_80015B0 // =dword_20018E8
	ldr r0, [r7]
	ldr r1, rng_80015A0 // =0x873ca9e5
	lsl r2, r0, #1
	lsr r3, r0, #0x1f
	add r0, r2, r3
	add r0, #1
	eor r0, r1
	str r0, [r7]
	pop {r7,pc}
	.balign 4, 0
rng_8001594:
	.word 0xA338244F
off_8001598:
	.word ePrimaryRngSeed
off_800159C:
	.word ePrimaryRngSeed
rng_80015A0:
	.word 0x873CA9E5
off_80015A4:
	.word ePrimaryRngSeed
off_80015A8:
	.word eSecondaryRngSeed
off_80015AC:
	.word eSecondaryRngSeed
off_80015B0:
	.word dword_20018E8
	thumb_func_end dead_rng_800157C

// symdb: Clears the BG tile ID area of VRAM and reloads the BG tile graphics, resetting a related graphics buffer in the process.
// symdb: void sub_80015B4(void); // no real arguments; r2/r3/r10 are pass-through state that is left
// symdb: untouched (r3 explicitly preserved)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/bg_ClearTilesAndReloadGraphics_80015B4.yaml
	thumb_func_start bg_ClearTilesAndReloadGraphics_80015B4
bg_ClearTilesAndReloadGraphics_80015B4:
	push {lr}
	ldr r0, dword_80015C8 // =0x600e000
	ldr r1, dword_80015CC // =0x2000
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	bl ZeroFillGFX30025c0
	bl copyMemory_8001850
	pop {pc}
	.balign 4, 0
dword_80015C8:
	.word 0x600E000
dword_80015CC:
	.word 0x2000
	thumb_func_end bg_ClearTilesAndReloadGraphics_80015B4

// symdb: Uploads the toolkit's iBG tile-id block table to VRAM each frame, then clears the table to 0x2FF "no tile" entries for the next frame.
// symdb: void copyToVRAMAndClear_iBGTileIdBlocks_Ptr(void) /* r10 = toolkit ptr, r3 preserved; clobbers
// symdb: r0-r2, nzcv, lr */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyToVRAMAndClear_iBGTileIdBlocks_Ptr.yaml
	thumb_func_start copyToVRAMAndClear_iBGTileIdBlocks_Ptr
copyToVRAMAndClear_iBGTileIdBlocks_Ptr:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_iBGTileIdBlocks_Ptr]
	// copies
	ldr r1, dword_80015EC // =0x600e000
	ldr r2, dword_80015F0 // =0x2000
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	mov r0, r10
	ldr r0, [r0,#oToolkit_iBGTileIdBlocks_Ptr]
	ldr r1, dword_80015F4 // =0x800
	ldr r2, fill // =0x2ff02ff
	bl FillByEightWords
	pop {pc}
	.balign 4, 0
dword_80015EC:
	.word 0x600E000
dword_80015F0:
	.word 0x2000
dword_80015F4:
	.word 0x800
fill:
	.word 0x2FF02FF
	thumb_func_end copyToVRAMAndClear_iBGTileIdBlocks_Ptr

/// Disabling this causes a lot of glitchy overlayed graphics from logo screen and throughout.
/// Game remains functional. In the net the background is very glitchy and animating you can't see MegaMan
// symdb: Copies an 8-byte palette/tile slot entry from a ROM table into the toolkit render-info write area.
// symdb: void sub_80015FC(u32 entry_index /* r0 */, void *toolkit /* r10 */); -> void; clobbers r0, r1,
// symdb: r2, r3, N, Z, C, V
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/toolkit_applyOverlayPalette_80015FC.yaml
	thumb_func_start toolkit_applyOverlayPalette_80015FC
toolkit_applyOverlayPalette_80015FC:
	ldr r1, off_8001614 // =byte_8001618
	lsl r0, r0, #3
	add r1, r1, r0

	mov r3, r10
	ldr r2, [r3,#oToolkit_RenderInfoPtr]
	add r2, #4

	ldr r0, [r1]
	str r0, [r2]

	ldr r0, [r1,#4]
	str r0, [r2,#4]

	mov pc, lr
	.balign 4, 0x00
off_8001614:
	.word byte_8001618
byte_8001618:
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x3C, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x8, 0x3C, 0x1, 0x3D, 0x0, 0x0, 0x0, 0x0, 0x8, 0x3C, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x5, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0xB, 0x3F
	.byte 0x8, 0x3C, 0x83, 0x3D, 0x82, 0x3E, 0x8D, 0x3F, 0x8, 0x3C, 0x83, 0x3D, 0xE, 0x3E, 0x8D, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x9, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0x0, 0x0, 0x0, 0x0
	.byte 0x8, 0x3C, 0x83, 0x3D, 0x2, 0x3E, 0x81, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x5E, 0x81, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x85, 0x3F, 0x8, 0x3C, 0x83, 0x3D, 0x2, 0x3E, 0x9, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x5, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x5, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x9, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x1, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x1, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0xA, 0x3E, 0x9, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x1, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x9, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x9, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x9, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x9, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0x1, 0x3E, 0x8, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x5, 0x3F, 0x8, 0x3C, 0x3, 0xE1, 0x2, 0x3E, 0x1, 0x3F
	.byte 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x1, 0x3F, 0x8, 0x3C, 0x3, 0x3D, 0x2, 0x3E, 0x9, 0x3F
	thumb_func_end toolkit_applyOverlayPalette_80015FC

// symdb: Given a map group and map number, fetches that map's byte entry from either the real-world or internet group table and passes it to sub_80015FC (likely the map loader/setup).
// symdb: void map_lookupMapIdByGroupAndNumber_8001708(u8 map_group /*r0*/, u8 map_number /*r1*/); tail-
// symdb: calls sub_80015FC(u8 mapId /*r0*/), so r0 out is sub_80015FC's return value; also clobbers r1,
// symdb: lr and returns sub_80015FC's flags/r2/r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/map_lookupMapIdByGroupAndNumber_8001708.yaml
	thumb_func_start map_lookupMapIdByGroupAndNumber_8001708
map_lookupMapIdByGroupAndNumber_8001708: // (map_group: u8, map_number: u8) -> ()
	push {lr}

	cmp r0, #INTERNET_MAP_GROUP_START
	bge loc_8001712

	ldr r3, off_8001724 // =off_803385C // [*const [u8]; REAL_WORLD_NUM_GROUPS]

	b loc_8001716

loc_8001712:
	ldr r3, off_8001728 // =off_8033878 // [Nullable<*const [u8]>; REAL_WORLD_NUM_GROUPS]
	sub r0, #INTERNET_MAP_GROUP_START

loc_8001716:
	lsl r0, r0, #2
	ldr r3, [r3,r0]

	add r3, r3, r1
	ldrb r0, [r3]

	bl toolkit_applyOverlayPalette_80015FC

	pop {pc}
	.balign 4, 0
off_8001724:
	.word off_803385C // [*const [u8]; REAL_WORLD_NUM_GROUPS]
off_8001728:
	.word off_8033878 // [Nullable<*const [u8]>; REAL_WORLD_NUM_GROUPS]
	thumb_func_end map_lookupMapIdByGroupAndNumber_8001708

// symdb: Flushes cached display-register state (DISPCNT, BG0CTL, MOSAIC, WIN0X, BLDCNT/BLDCOL) from the toolkit's RenderInfo tables into GBA hardware I/O.
// symdb: render_800172C(/* Toolkit * */ r10, /* preserved */ r3, r4, r5, r6, r7) -> /* sets ADDS from
// symdb: ri+4 */ v, nz, c; clobbers r0, r1, r2, lr; preserves r3-r7.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/render_flushDisplayRegisters_800172C.yaml
	thumb_func_start render_flushDisplayRegisters_800172C
render_flushDisplayRegisters_800172C:
	push {r4-r7,lr}

	// (r5_0_pRenderInfo : *mut RenderInfo, r7_0_tk : *mut ToolKit)
	mov r7, r10
	ldr r5, [r7,#oToolkit_RenderInfoPtr]

	// (r5_0_pRenderInfo) -> (r1_0_ioMosaicSize : ?, r2_0 : u16)
	ldr r1, off_8001768 // =MosaicSize
	ldrh r2, [r5,#oRenderInfo_MosaicSize]
	strh r2, [r1]

	// (r5_0_pRenderInfo) -> (r0_0 : ?, r1_1_io : ?, r2_1 : usize)
	mov r0, r5
	add r0, #4
	ldr r1, off_800176C // =BG0Control
	mov r2, #0x38
	bl CopyWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	// (r7_0_tk) -> (r0_1 : Unk200f3a0, r1_2_io : ?, r2_2 : usize)
	// src
	ldr r0, [r7,#oToolkit_Unk200f3a0_Ptr]
	// dest
	ldr r1, off_8001770 // =Window0HorizontalDimensions
	// halfwordCount
	mov r2, #0xc
	bl CopyHalfwords // (u16 *src, u16 *dest, int halfwordCount) -> void

	// (r7_0_tk) -> (r1_3_io : ?, r2_3 : u32?, r5_1_unk : Unk2009740,
	//                            r2_4 : u16?)
	ldr r5, [r7,#oToolkit_Unk2009740_Ptr]
	ldr r1, off_8001774 // =ColorSpecialEffectsSelection
	ldr r2, [r5]
	str r2, [r1]
	ldrh r2, [r5,#4]
	strh r2, [r1,#0x4] // (Brightness_Fade_In_Out_Coefficient - 0x4000050)

	ldr r5, [r7,#oToolkit_RenderInfoPtr]
	ldr r1, off_8001764 // =LCDControl
	ldrh r2, [r5]
	strh r2, [r1]

	pop {r4-r7,pc}
	.balign 4, 0
off_8001764:
	.word LCDControl
off_8001768:
	.word MosaicSize
off_800176C:
	.word BG0Control
off_8001770:
	.word Window0HorizontalDimensions
off_8001774:
	.word ColorSpecialEffectsSelection
	thumb_func_end render_flushDisplayRegisters_800172C

// symdb: Writes a halfword LCD control value (DISPCNT-style) into the current frame's render info struct.
// symdb: void SetRenderInfoLCDControl(u16 lcdControl /*r0*/, r10 = toolkit); out: r1 =
// symdb: toolkit->renderInfo pointer
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetRenderInfoLCDControl.yaml
	thumb_func_start SetRenderInfoLCDControl
SetRenderInfoLCDControl: // (a_00: u16) -> ()
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r0, [r1,#oRenderInfo_LCDControl]
	mov pc, lr
	thumb_func_end SetRenderInfoLCDControl

// symdb: Returns the u16 LCD control value (DISPCNT) recorded in the current frame's render info block.
// symdb: u16 GetRenderInfoLCDControl(void) — reads toolkit via r10 (frame pointer), returns value in r0;
// symdb: clobbers r1
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/GetRenderInfoLCDControl.yaml
	thumb_func_start GetRenderInfoLCDControl
GetRenderInfoLCDControl: // () -> u16
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	ldrh r0, [r1,#oRenderInfo_LCDControl]
	mov pc, lr
	thumb_func_end GetRenderInfoLCDControl

// symdb: Zeros the per-frame sprite/render counters in the toolkit's RenderInfo block so each frame's render-list build starts from a clean state.
// symdb: void renderInfo_clearEntryCounts_8001788(void); // r10 = toolkit pointer, no return value
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/renderInfo_8001788.yaml
	thumb_func_start renderInfo_8001788
renderInfo_8001788: // () -> ()
	mov r0, r10
	ldr r0, [r0,#oToolkit_RenderInfoPtr]
	mov r1, #0
	strh r1, [r0,#oRenderInfo_RenderEntryCountA]
	strh r1, [r0,#oRenderInfo_RenderEntryCountB]
	strh r1, [r0,#oRenderInfo_BGScrollXOffset]
	strh r1, [r0,#oRenderInfo_BGScrollY]
	strh r1, [r0,#oRenderInfo_BG1ScrollXAlt]
	strh r1, [r0,#oRenderInfo_BGScrollY2]
	strh r1, [r0,#oRenderInfo_BG3ScrollY]
	strh r1, [r0,#oRenderInfo_BG2ScrollX]
	mov pc, lr
	thumb_func_end renderInfo_8001788

// symdb: Clears the halfword counter at offset 2 of the current toolkit's render info block.
// symdb: u32 renderInfo_clearCounter_80017A0(Toolkit *toolkit /* r10 */); // returns r1 = 0, clobbers r0
// symdb: and nz flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/renderInfo_80017A0.yaml
	thumb_func_start renderInfo_80017A0
renderInfo_80017A0: // () -> ()
	mov r0, r10
	ldr r0, [r0,#oToolkit_RenderInfoPtr]
	mov r1, #0
	strh r1, [r0,#oRenderInfo_MosaicSize]
	mov pc, lr
	thumb_func_end renderInfo_80017A0

// symdb: Clears all of VRAM (0x6000000-0x600DFFF) with four zero-fill calls, used during video reset/startup.
// symdb: void zeroFillVRAM(void); // r2/r3 preserved; returns with r0=0x600C000, r1=0x20 (tail state of
// symdb: last helper call)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/zeroFillVRAM.yaml
	thumb_func_start zeroFillVRAM
zeroFillVRAM: // () -> ()
	push {lr}
	ldr r0, dword_80017D0 // =0x6000000
	mov r1, #0x40
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	ldr r0, dword_80017D4 // =0x6004000
	mov r1, #0x40
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	ldr r0, dword_80017D8 // =0x6008000
	mov r1, #0x40
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	ldr r0, dword_80017DC // =0x600c000
	mov r1, #0x20
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	pop {pc}
	.balign 4, 0
dword_80017D0:
	.word 0x6000000
dword_80017D4:
	.word 0x6004000
dword_80017D8:
	.word 0x6008000
dword_80017DC:
	.word 0x600C000
	thumb_func_end zeroFillVRAM

// symdb: Zeroes the 4-byte palette buffer at IWRAM 0x3001960 by calling ZeroFillByHalfword with a count of 2 halfwords.
// symdb: void ZeroFill_byte_3001960(void); // trashes r0-r1, preserves r2/r3, passes ZeroFillByHalfword's
// symdb: r1/c/v through to callers
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ZeroFill_byte_3001960.yaml
	thumb_func_start ZeroFill_byte_3001960
ZeroFill_byte_3001960:
	push {lr}
	ldr r0, off_8001800 // =palette_3001960
	mov r1, #2
	bl ZeroFillByHalfword
	pop {pc}
	thumb_func_end ZeroFill_byte_3001960

// symdb: Zeroes the first two halfwords of the palette buffer at palette_3001960 and of BG palette memory (0x5000000) during boot.
// symdb: void main_zeroFillFirstPaletteEntries(void); // preserves r2/r3, returns caller's r3 unchanged
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/main_zeroFill_80017EC.yaml
	thumb_func_start main_zeroFill_80017EC
main_zeroFill_80017EC:
	push {lr}
	ldr r0, off_8001800 // =palette_3001960
	mov r1, #2
	bl ZeroFillByHalfword
	ldr r0, dword_8001804 // =0x5000000
	mov r1, #2
	bl ZeroFillByHalfword
	pop {pc}
	.balign 4, 0
off_8001800:
	.word palette_3001960
dword_8001804:
	.word 0x5000000
	thumb_func_end main_zeroFill_80017EC

// symdb: Copies the game's 0x200-byte palette table from IWRAM to BG palette RAM (0x5000000).
// symdb: void loadBgPaletteTable_ADDRESS(void); // r3 preserved, r0-r2/lr scratch
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyPalletesToIWRAM_8001808.yaml
	thumb_func_start copyPalletesToIWRAM_8001808
copyPalletesToIWRAM_8001808:
	push {lr}
	ldr r0, off_8001818 // =iPalette3001B60
	ldr r1, dword_800181C // =0x5000000
	mov r2, #0x20
	lsl r2, r2, #4
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	pop {pc}
	.balign 4, 0
off_8001818:
	.word iPalette3001B60
dword_800181C:
	.word 0x5000000
	thumb_func_end copyPalletesToIWRAM_8001808

// symdb: Zero-fills the 8-byte scratch struct at toolkit->Unk2009740 before it is reused.
// symdb: void clearToolkitUnk2009740(void) — takes the toolkit pointer in r10 (custom convention),
// symdb: preserves r3; clobbers r0-r2 and flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/zeroFill_e2009740.yaml
	thumb_func_start zeroFill_e2009740
zeroFill_e2009740:
	push {lr}
	mov r2, r10
	// memBlock
	ldr r0, [r2,#oToolkit_Unk2009740_Ptr]
	// size
	mov r1, #8
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end zeroFill_e2009740

// symdb: Zero-fills the 12-byte structure pointed to by the toolkit's oToolkit_Unk200f3a0_Ptr field.
// symdb: void zeroFill_e200F3A0(void /* r10: toolkit base, r3: passed through untouched */), returns with
// symdb: r2 = toolkit base pointer (r10) and r3 unchanged
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/zeroFill_e200F3A0.yaml
	thumb_func_start zeroFill_e200F3A0
zeroFill_e200F3A0:
	push {lr}
	mov r2, r10
	// memBlock
	ldr r0, [r2,#oToolkit_Unk200f3a0_Ptr]
	// size
	mov r1, #0xc
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	thumb_func_end zeroFill_e200F3A0

// symdb: Zero-fills the 0x2000-byte BG tile ID block buffer held by the toolkit, resetting the background tilemap layer's tile data.
// symdb: void bg_ClearBGTileIdBlocks_ADDRESS(tools_t *r10 /* toolkit */, ... /* r2, r3 passed through
// symdb: untouched */); returns r1 = 0x2000 and flags from the inner memset.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/ZeroFillGFX30025c0.yaml
	thumb_func_start ZeroFillGFX30025c0
ZeroFillGFX30025c0:
	push {lr}
	mov r0, r10
	ldr r0, [r0,#oToolkit_iBGTileIdBlocks_Ptr]
	ldr r1, dword_800184C // =0x2000
	bl ZeroFillByEightWords // (int a1, int a2) -> void
	pop {pc}
	.balign 4, 0
dword_800184C:
	.word 0x2000
	thumb_func_end ZeroFillGFX30025c0

// symdb: Loads a fixed 0x800-byte graphics block into VRAM at 0x600D400 and a 32-byte block into IWRAM at 0x3001B40.
// symdb: void loadScreenGfx_8001850(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyMemory_8001850.yaml
	thumb_func_start copyMemory_8001850
copyMemory_8001850:
	push {lr}
	ldr r0, off_8001868 // =dword_86A5520
	ldr r1, dword_800186C // =0x600d400
	ldr r2, dword_8001870 // =0x800
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	ldr r0, off_8001874 // =byte_86BEC80
	ldr r1, off_8001878 // =unk_3001B40
	mov r2, #0x20
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	pop {pc}
	.balign 4, 0
off_8001868:
	.word dword_86A5520
dword_800186C:
	.word 0x600D400
dword_8001870:
	.word 0x800
off_8001874:
	.word byte_86BEC80
off_8001878:
	.word unk_3001B40
	thumb_func_end copyMemory_8001850

// symdb: Writes a single 16-bit BG tile id into the map's tile-id blocks at the given tile coordinates and 32x32 block.
// symdb: void bgmap_WriteTileIdAtBlock(int x, int y, int blockIdx, u16 tileId)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/bgmap_WriteTileIdAtBlock_800187C.yaml
	thumb_func_start bgmap_WriteTileIdAtBlock_800187C
bgmap_WriteTileIdAtBlock_800187C:
	lsl r0, r0, #1
	lsl r1, r1, #6
	lsl r2, r2, #0xb
	add r0, r0, r1
	add r0, r0, r2
	mov r1, r10
	ldr r1, [r1,#oToolkit_iBGTileIdBlocks_Ptr]
	add r1, r1, r0
	strh r3, [r1]
	mov pc, lr
	thumb_func_end bgmap_WriteTileIdAtBlock_800187C

// symdb: Blits a rectangle of 16-bit BG tile ids into one of the toolkit's BG tile-id blocks at the given tile (x,y) offset.
// symdb: void bgTileIdBlit_8001890(s32 tileX, s32 tileY, s32 bgBlockIdx, const u16* src, s32 tileWidth,
// symdb: s32 tileRows); // r0: tile-x offset (in tiles), doubled on exit // r1: tile-y offset (in tiles),
// symdb: on exit = ptr past the last row written // r2: BG tile-id-block index (0x800-byte block),
// symdb: cleared on exit // r3: source pointer (u16*); on exit = src + 2*tileWidth*tileRows // r4: tile
// symdb: width per row // r5: row count; note r5==0 still copies exactly one row // Out flags: from final
// symdb: `cmp r5,#0` on (rowsLeft-1)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8001890.yaml
	thumb_func_start sub_8001890
sub_8001890:
	push {r4-r7,lr}
	mov r6, r10
	ldr r6, [r6,#oToolkit_iBGTileIdBlocks_Ptr]
	lsl r2, r2, #0xb
	add r6, r6, r2
	lsl r0, r0, #1
	add r6, r6, r0
	lsl r1, r1, #6
	add r6, r6, r1
	mov r2, #0
	mov r1, r6
loc_80018A6:
	ldrh r7, [r3]
	strh r7, [r6]
	add r3, #2
	add r6, #2
	add r2, #1
	cmp r2, r4
	blt loc_80018A6
	mov r2, #0
	add r1, #0x40
	mov r6, r1
	sub r5, #1
	cmp r5, #0
	bgt loc_80018A6
	pop {r4-r7,pc}
	thumb_func_end sub_8001890

	thumb_func_start CopyBackgroundTiles
// (int j, int i, int tileBlock32x32, u16 *tileIds, int j_size@R4, int i_size@R5) -> void
// this is copying Tiles for BG0 and BG2
CopyBackgroundTiles: // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	push {r6,r7,lr}
	ldr r7, off_80018CC // =iCopyBackgroundTiles+1
	mov lr, pc
	bx r7
	pop {r6,r7,pc}
off_80018CC:
	.word iCopyBackgroundTiles+1
	thumb_func_end CopyBackgroundTiles

	thumb_func_start call_sub_3005EBA
call_sub_3005EBA:
	push {r6,r7,lr}
	ldr r7, off_80018DC // =sub_3005EBA+1
	mov lr, pc
	bx r7
	pop {r6,r7,pc}
	.balign 4, 0x00
off_80018DC:
	.word sub_3005EBA+1
	thumb_func_end call_sub_3005EBA

// symdb: Copies a horizontal run of BG tile ids from a source buffer into one 32x32 tile-id map block, wrapping columns at 32.
// symdb: void bg_writeTileIdRow(u32 x /*r0*/, u32 y /*r1*/, u32 block /*r2*/, const u16* src /*r3*/, s32
// symdb: count /*r4*/, Toolkit* toolkit /*r10*/) -> leaves r0 = next x (wrapped), r1 = 0x1F, r2 =
// symdb: block<<11, r3 = src past the copy, r4 = remaining count, flags set by final "CMP r4,#0"
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/bg_writeTileIdRow_80018E0.yaml
	thumb_func_start bg_writeTileIdRow_80018E0
bg_writeTileIdRow_80018E0:
	push {r6,r7,lr}
	mov r6, r10
	ldr r6, [r6,#oToolkit_iBGTileIdBlocks_Ptr]
	lsl r2, r2, #0xb
	add r6, r6, r2
	lsl r1, r1, #6
	add r6, r6, r1
	mov r1, #0x1f
	and r0, r1
loc_80018F2:
	ldrh r7, [r3]
	lsl r1, r0, #1
	strh r7, [r6,r1]
	add r0, #1
	mov r1, #0x1f
	and r0, r1
	add r3, #2
	sub r4, #1
	cmp r4, #0
	bgt loc_80018F2
	pop {r6,r7,pc}
	push {r6,r7,lr}
	mov r6, r10
	ldr r6, [r6,#oToolkit_iBGTileIdBlocks_Ptr]
	lsl r2, r2, #0xb
	add r6, r6, r2
	lsl r0, r0, #1
	add r6, r6, r0
	mov r0, #0x1f
	and r1, r0
loc_800191A:
	ldrh r7, [r3]
	lsl r0, r1, #6
	strh r7, [r6,r0]
	add r1, #1
	mov r0, #0x1f
	and r1, r0
	add r3, #2
	sub r4, #1
	cmp r4, #0
	bgt loc_800191A
	pop {r6,r7,pc}
	thumb_func_end bg_writeTileIdRow_80018E0

// symdb: Fills a stripe of OAM attribute pairs (two linked rows per row index) with consecutive tile IDs.
// symdb: void sub_8001930(u32 tile_id_base /* r0, low 12b */,                  u32 high_bits /* r1,
// symdb: placed into bits 12+ */,                  u32 stride_entries /* r2, multiplied by 4 to get byte
// symdb: stride */,                  s32 strip_count /* r3, decremented; 0 loops again, <0 means loop
// symdb: again */,                  OamEntry* dst /* r4 */); // clobbers nz c v r0 r1 r2 r3; preserves r4
// symdb: r5 r6 r7; returns via lr.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/fillOamTileStripes_8001930.yaml
	thumb_func_start fillOamTileStripes_8001930
fillOamTileStripes_8001930:
	push {r4-r7,lr}
	lsl r2, r2, #2
	lsl r1, r1, #0xc
	orr r0, r1
	mov r5, #0
loc_800193A:
	strh r0, [r4]
	add r0, #1
	strh r0, [r4,#2]
	add r0, #1
	add r1, r4, r2
	strh r0, [r1]
	add r0, #1
	strh r0, [r1,#2]
	add r0, #1
	add r4, #4
	add r5, #4
	cmp r5, r2
	blt loc_800193A
	sub r3, #1
	blt loc_800193A
	pop {r4-r7,pc}
	.balign 4, 0x00
	thumb_func_end fillOamTileStripes_8001930

	thumb_func_start SetBGScrollCallbacks
// set the bg scroll callback
// is actually just an arbitrary callback
// but all calls to this function pass
// a callback that modifies BG scroll
// registers (modifies eRenderInfo_Unk_10 to
// eRenderInfo_Unk_1a, which are copied to the
// bg scroll registers)
// r0 - callback 0
// r1 - callback 1
// r2 - hblank interrupt callback
// symdb: Installs a set of BG scroll/HBlank callback pointers and hooks the HBlank callback into IRQ 4.
// symdb: void SetBGScrollCallbacks(void (*callback0)(void), void (*callback1)(void), void
// symdb: (*hblankCallback)(void)); /* only acts when callback0 != NULL; returns r2 = hblankCallback, r3 =
// symdb: callbacks table (when installed), NZ from the tst on r0 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetBGScrollCallbacks.yaml
SetBGScrollCallbacks:
	push {lr}
	tst r0, r0
	beq .callbackZeroNotSet
	ldr r3, off_80019AC // =eBGScrollCallbacks
	str r0, [r3,#oBGScrollCallbacks_Callback0]
	str r1, [r3,#oBGScrollCallbacks_Callback1] // (off_200A888 - 0x200a880)
	str r2, [r3,#oBGScrollCallbacks_HBlankCallback] // (doff_200A884 - 0x200a880)
	mov r0, #4 // hblank
	mov r1, r2
	bl SetInterruptCallback
.callbackZeroNotSet
	pop {pc}
	thumb_func_end SetBGScrollCallbacks

	thumb_func_start SetDummyBGScrollCallbacks
// set all bg callbacks to nullsubs
// symdb: Installs no-op handlers into the BG scroll callback table (both scroll callbacks plus the HBlank callback) and hooks the dummy HBlank handler into the HBlank interrupt slot.
// symdb: void SetDummyBGScrollCallbacks(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/SetDummyBGScrollCallbacks.yaml
SetDummyBGScrollCallbacks:
	push {lr}
	ldr r2, off_80019AC // =eBGScrollCallbacks
	ldr r0, off_800198C // =nullsub_39+1
	str r0, [r2,#oBGScrollCallbacks_Callback0]
	str r0, [r2,#oBGScrollCallbacks_Callback1] // (off_200A888 - 0x200a880)
	ldr r1, dword_8001990 // =nullsub_38+1
	str r1, [r2,#oBGScrollCallbacks_HBlankCallback] // (doff_200A884 - 0x200a880)
	mov r0, #4 // hblank
	bl SetInterruptCallback
	pop {pc}
	.balign 4, 0
off_800198C:
	.word nullsub_39+1
dword_8001990:
	.word nullsub_38+1
	thumb_func_end SetDummyBGScrollCallbacks

// symdb: trampoline that loads slot 0 of eBGScrollCallbacks and tail-calls its handler
// symdb: void CallBGScrollCallback0(void) // reads handler via r0=handler,r1=tableBase at the bx; r4-r12
// symdb: forwarded, r0-r3+flags clobbered by the handler
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/CallBGScrollCallback0.yaml
	thumb_func_start CallBGScrollCallback0
CallBGScrollCallback0:
	push {lr}
	ldr r1, off_80019AC // =eBGScrollCallbacks
	ldr r0, [r1,#oBGScrollCallbacks_Callback0]
	mov lr, pc
	bx r0
	pop {pc}
	thumb_func_end CallBGScrollCallback0

// symdb: Trampoline that invokes the first of the two BG-scroll callbacks stored in eBGScrollCallbacks (slot at offset 8).
// symdb: void CallBGScrollCallback1(void); /* r10 in, lr in; r8 r9 r10 r11 r12 out; nz c v + r0-r7 lr
// symdb: clobbered */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/CallBGScrollCallback1.yaml
	thumb_func_start CallBGScrollCallback1
CallBGScrollCallback1:
	push {lr}
	ldr r1, off_80019AC // =eBGScrollCallbacks
	ldr r0, [r1,#oBGScrollCallbacks_Callback1] // (off_200A888 - 0x200a880)
	mov lr, pc
	bx r0
	pop {pc}
off_80019AC:
	.word eBGScrollCallbacks
	thumb_func_end CallBGScrollCallback1

	thumb_func_start nullsub_35
nullsub_35:
	mov pc, lr
	thumb_func_end nullsub_35

	thumb_func_start nullsub_36
nullsub_36:
	mov pc, lr
	thumb_func_end nullsub_36

// symdb: BG1 scroll callback that advances a diagonal (3:2 slope) scroll, moving the background left/up by 8 and 4 subpixel steps per call.
// symdb: void Next(r10=toolkit, lr=return) -> flags nz/c/v, r1=renderInfoPtr, r2=scrollX, r3=scrollY
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/BGScrollCB_BG1Diagonal3to2Scroll.yaml
	thumb_func_start BGScrollCB_BG1Diagonal3to2Scroll
BGScrollCB_BG1Diagonal3to2Scroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r2, [r1,#oBGScrollCBCounters_Counter0]
	sub r2, #8
	str r2, [r1,#oBGScrollCBCounters_Counter0]
	lsr r2, r2, #4
	ldr r3, [r1,#oBGScrollCBCounters_Counter1] // (dword_2009694 - 0x2009690)
	sub r3, #4
	str r3, [r1,#oBGScrollCBCounters_Counter1] // (dword_2009694 - 0x2009690)
	lsr r3, r3, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r2, [r1,#oRenderInfo_BGScrollXOffset]
	strh r3, [r1,#oRenderInfo_BGScrollY]
	mov pc, lr
	thumb_func_end BGScrollCB_BG1Diagonal3to2Scroll

// symdb: Per-frame background scroll callback that scrolls the BG3 layer diagonally, moving faster on the X axis (8 subpixels/frame) than on Y (4 subpixels/frame), giving a shallow-diagonal "3-to-2" pan.
// symdb: void (in: r10 = toolkit/engine context pointer, lr = return address; out: nz/c/v flags, r1 =
// symdb: render info pointer, r2 = BG3 X offset, r3 = BG3 Y offset; no clobbers beyond r1-r3)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/BGScrollCB_BG3Diagonal3to2Scroll.yaml
	thumb_func_start BGScrollCB_BG3Diagonal3to2Scroll
BGScrollCB_BG3Diagonal3to2Scroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r2, [r1,#oBGScrollCBCounters_Counter0]
	sub r2, #8
	str r2, [r1,#oBGScrollCBCounters_Counter0]
	lsr r2, r2, #4
	ldr r3, [r1,#oBGScrollCBCounters_Counter1] // (dword_2009694 - 0x2009690)
	sub r3, #4
	str r3, [r1,#oBGScrollCBCounters_Counter1] // (dword_2009694 - 0x2009690)
	lsr r3, r3, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r2, [r1,#oRenderInfo_BG2ScrollX]
	strh r3, [r1,#oRenderInfo_BG3ScrollY]
	mov pc, lr
	thumb_func_end BGScrollCB_BG3Diagonal3to2Scroll

// symdb: BG1 scrolling-callback that advances its counter by 4 and writes the divided scroll value into the BG1 vertical scroll slot of the toolkit's render info.
// symdb: void BGScrollCB_BG1UpScroll(void);  /* in: r10 = toolkit ptr; clobbers r1, r3, NZCV */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/BGScrollCB_BG1UpScroll.yaml
	thumb_func_start BGScrollCB_BG1UpScroll
BGScrollCB_BG1UpScroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r3, [r1,#oBGScrollCBCounters_Counter0]
	sub r3, #4
	str r3, [r1,#oBGScrollCBCounters_Counter0]
	lsr r3, r3, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r3, [r1,#oRenderInfo_BGScrollY]
	mov pc, lr
	thumb_func_end BGScrollCB_BG1UpScroll

// symdb: BG3 vertical scroll callback that advances the shared BG-scroll counter0 up by 4 pixels each frame and pushes the per-tile value into the active render info.
// symdb: void BGScrollCB_BG3UpScroll(void) /* in: r10 = oToolkitPtr; clobbers r1, r3, N, Z, C, V */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/BGScrollCB_BG3UpScroll.yaml
	thumb_func_start BGScrollCB_BG3UpScroll
BGScrollCB_BG3UpScroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r3, [r1,#oBGScrollCBCounters_Counter0]
	sub r3, #4
	str r3, [r1,#oBGScrollCBCounters_Counter0]
	lsr r3, r3, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r3, [r1,#oRenderInfo_BG3ScrollY]
	mov pc, lr
	thumb_func_end BGScrollCB_BG3UpScroll

	thumb_func_start BGScrollCB_BG1DownScroll
BGScrollCB_BG1DownScroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r2, [r1,#oBGScrollCBCounters_Counter0]
	add r2, #4
	str r2, [r1,#oBGScrollCBCounters_Counter0]
	lsr r2, r2, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r2, [r1,#oRenderInfo_BGScrollY]
	mov pc, lr
	thumb_func_end BGScrollCB_BG1DownScroll

	thumb_func_start BGScrollCB_BG3DownScroll
BGScrollCB_BG3DownScroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r2, [r1,#oBGScrollCBCounters_Counter0]
	add r2, #4
	str r2, [r1,#oBGScrollCBCounters_Counter0]
	lsr r2, r2, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r2, [r1,#oRenderInfo_BG3ScrollY]
	mov pc, lr
	thumb_func_end BGScrollCB_BG3DownScroll

	thumb_func_start BGScrollCB_BG1SlowRightScroll
BGScrollCB_BG1SlowRightScroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r2, [r1,#oBGScrollCBCounters_Counter0]
	add r2, #1
	str r2, [r1,#oBGScrollCBCounters_Counter0]
	lsr r2, r2, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r2, [r1,#oRenderInfo_BGScrollXOffset]
	mov pc, lr
	thumb_func_end BGScrollCB_BG1SlowRightScroll

	thumb_func_start BGScrollCB_BG3SlowRightScroll
BGScrollCB_BG3SlowRightScroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r2, [r1,#oBGScrollCBCounters_Counter0]
	add r2, #1
	str r2, [r1,#oBGScrollCBCounters_Counter0]
	lsr r2, r2, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r2, [r1,#oRenderInfo_BG2ScrollX]
	mov pc, lr
	thumb_func_end BGScrollCB_BG3SlowRightScroll

	thumb_func_start BGScrollCB_BG1FastLeftScroll
BGScrollCB_BG1FastLeftScroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r2, [r1,#oBGScrollCBCounters_Counter0]
	sub r2, #8
	str r2, [r1,#oBGScrollCBCounters_Counter0]
	lsr r2, r2, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r2, [r1,#oRenderInfo_BGScrollXOffset]
	mov pc, lr
	thumb_func_end BGScrollCB_BG1FastLeftScroll

	thumb_func_start BGScrollCB_BG3FastLeftScroll
BGScrollCB_BG3FastLeftScroll:
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r2, [r1,#oBGScrollCBCounters_Counter0]
	sub r2, #8
	str r2, [r1,#oBGScrollCBCounters_Counter0]
	lsr r2, r2, #4
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	strh r2, [r1,#oRenderInfo_BG2ScrollX]
	mov pc, lr
	thumb_func_end BGScrollCB_BG3FastLeftScroll

	thumb_local_start
BGScrollCB_BG1AccelToVeryFastDownScroll:
	push {lr}
	bl battle_getStateUnk5c_800139A
	mov r1, #0x10
	tst r0, r1
	beq locret_8001AAC
	ldr r1, off_8001AB0 // =eBGScrollCBCounters
	ldr r2, [r1,#oBGScrollCBCounters_Counter0]
	mov r3, #1
	lsl r3, r3, #0xa
	sub r2, r2, r3
	mov r3, #4
	lsl r3, r3, #0x10
	neg r3, r3
	cmp r2, r3
	bge loc_8001A9E
	mov r2, r3
loc_8001A9E:
	str r2, [r1,#oBGScrollCBCounters_Counter0]
	asr r2, r2, #0x10
	mov r1, r10
	ldr r1, [r1,#oToolkit_RenderInfoPtr]
	ldrh r3, [r1,#oRenderInfo_BGScrollY]
	sub r3, r3, r2
	strh r3, [r1,#oRenderInfo_BGScrollY]
locret_8001AAC:
	pop {pc}
	.balign 4, 0
off_8001AB0:
	.word eBGScrollCBCounters
	thumb_func_end BGScrollCB_BG1AccelToVeryFastDownScroll

// symdb: Empty placeholder function that immediately returns to its caller.
// symdb: void nullsub_39(void);  /* no params, no return, no clobbers */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/nullsub_39.yaml
	thumb_func_start nullsub_39
nullsub_39:
	mov pc, lr
	.balign 4, 0x00
off_8001AB8:
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200E580
	.word unk_200E640
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200E440
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200DF40
	.word unk_200DF40
	thumb_func_end nullsub_39

// symdb: Clears the entire eGFXAnimStates block (0x1B0 bytes) to zero, e.g. when (re)initializing the GFX animation-state pool.
// symdb: void gfx_zeroFillAnimStates(void) — takes no meaningful inputs (r2/r3 pass through untouched),
// symdb: returns via pop {pc}; no flags meaningful (NZCV clobbered by the fill call)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/zeroFill_e20094C0.yaml
	thumb_func_start zeroFill_e20094C0
zeroFill_e20094C0:
	push {lr}
	// memBlock
	ldr r0, off_8001C40 // =eGFXAnimStates
	// size
	ldr r1, off_8001B08 // =0x1b0
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	.balign 4, 0
off_8001B08:
	.word 0x1B0
	thumb_func_end zeroFill_e20094C0

	thumb_local_start
sub_8001B0C:
	push {r4-r7,lr}
	ldr r1, off_8001B18 // =off_8001AB8
	lsl r0, r0, #2
	ldr r0, [r1,r0]
	pop {r4-r7,pc}
	.balign 4, 0x00
off_8001B18:
	.word off_8001AB8
	thumb_func_end sub_8001B0C

	thumb_func_start LoadGFXAnim
// r0 struct format: word0 word4 word8 byte9 (multiple fields depending on command)
LoadGFXAnim: // (script: * GFXAnimScript) -> ()
	push {r4-r7,lr}
	mov r1, r8
	mov r2, r9
	mov r3, r12
	push {r1-r3}

	ldr r7, off_8001C40 // =eGFXAnimStates
	ldrb r1, [r0,#oGFXAnimData_Index]
	mov r2, #oGFXAnimState_Size
	mul r2, r1
	add r7, r7, r2

	strb r1, [r7,#oGFXAnimState_Index]

	ldr r1, [r0,#oGFXAnimData_Param0]
	str r1, [r7,#oGFXAnimState_Param0]

	ldr r2, [r0,#oGFXAnimData_Param1]
	str r2, [r7,#oGFXAnimState_Param1]

	ldr r3, [r0,#oGFXAnimData_Command]
	str r3, [r7,#oGFXAnimState_Command_Param2to3]

  // transitions to GFXAnimDataNext
	add r0, #oGFXAnimData_ParamNext

	mov r6, #1

	cmp r3, #8
	beq loc_8001B48
  
	ldr r6, [r0,#oGFXAnimData_Delay - oGFXAnimData_ParamNext]
loc_8001B48:

	strh r6, [r7,#oGFXAnimState_Timer]
	mov r6, #1
	strb r6, [r7,#oGFXAnimState_IsActive]
	str r0, [r7,#oGFXAnimState_LoopAddress]
	str r0, [r7,#oGFXAnimState_CommandPos]

	ldr r6, off_8001B68 // =off_8001C24
	ldrb r1, [r7,#oGFXAnimState_Command]
	ldr r6, [r6,r1]
	mov lr, pc
	bx r6

	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
	.balign 4, 0
off_8001B68:
	.word off_8001C24
	thumb_func_end LoadGFXAnim

// symdb: Stops a running graphics animation: clears its state flag and tears down the palette transform attached to that animation slot.
// symdb: gfxAnim_Terminate(u32 animIndex /* r0 */); passes animIndex on to
// symdb: Terminate_ePalette20097a0_Transform and returns that callee's r1/r2 and c/v flags to the caller
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/TerminateGFXAnim.yaml
	thumb_func_start TerminateGFXAnim
TerminateGFXAnim:
	push {r4-r7,lr}
	push {r0}
	ldr r7, off_8001C40 // =eGFXAnimStates
	mov r1, #oGFXAnimState_Size
	mul r1, r0
	add r7, r7, r1
	mov r0, #0
	strb r0, [r7]
	pop {r0}
	bl Terminate_ePalette20097a0_Transform
	pop {r4-r7,pc}
	thumb_func_end TerminateGFXAnim

// symdb: Returns (via flags) whether the given graphics animation slot is active by testing its state byte.
// symdb: bool IsGFXAnimActive(u32 slot /* r0 */); // result in flags (Z set = inactive), r0 = state byte,
// symdb: r1 clobbered, r4-r7 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/IsGFXAnimActive.yaml
	thumb_func_start IsGFXAnimActive
IsGFXAnimActive:
	push {r4-r7,lr}
	ldr r7, off_8001C40 // =eGFXAnimStates
	mov r1, #oGFXAnimState_Size
	mul r1, r0
	add r7, r7, r1
	ldrb r0, [r7]
	tst r0, r0
	pop {r4-r7,pc}
	thumb_func_end IsGFXAnimActive

	thumb_func_start ProcessGFXAnims
ProcessGFXAnims:
	push {r4-r7,lr}
	mov r1, r8
	mov r2, r9
	mov r3, r12
	push {r1-r3}
	ldr r7, off_8001C40 // =eGFXAnimStates
	mov r4, #0
.loopStruct
	ldrb r1, [r7,#oGFXAnimState_IsActive]
	tst r1, r1
	bne .structIsActive
.doneThisStruct
	add r7, #oGFXAnimState_Size
	add r4, #1
	cmp r4, #NUM_GFX_ANIMS // 0x12
	bge .doneAllStructs
	b .loopStruct
.structIsActive

	ldrh r1, [r7,#oGFXAnimState_Timer]
	sub r1, #1
	strh r1, [r7,#oGFXAnimState_Timer]
	cmp r1, #0
	bgt .doneThisStruct

	ldr r0, [r7,#oGFXAnimState_CommandPos] // extended data start pointer (S8001b1c + 0xc)
	ldr r1, off_8001C00 // =byte_8001C08
	ldrb r2, [r7,#oGFXAnimState_Command] // read LoadGFXAnim type
	ldr r1, [r1,r2]
	add r0, r0, r1

	ldr r1, [r0]
	cmp r1, #0
	beq .noMoreEntries

	cmp r1, #2
	beq .setLoopAddressAndJump

	cmp r1, #1
	bne .gotGFXAnimCommandPos

	ldr r0, [r7,#oGFXAnimState_LoopAddress]
	b .gotGFXAnimCommandPos

.setLoopAddressAndJump
	ldr r0, [r0,#4]
	str r0, [r7,#oGFXAnimState_LoopAddress]
.gotGFXAnimCommandPos
	str r0, [r7,#oGFXAnimState_CommandPos]
	ldr r1, [r0,#4]
	strh r1, [r7,#oGFXAnimState_Timer]

	ldr r6, off_8001C04 // =off_8001C24
	ldrb r1, [r7,#oGFXAnimState_Command]
	ldr r6, [r6,r1]
	mov lr, pc
	bx r6

	b .doneThisStruct
.noMoreEntries
	mov r1, #0
	strb r1, [r7, #oGFXAnimState_IsActive]
	b .doneThisStruct
.doneAllStructs
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
	.balign 4, 0
off_8001C00:
	.word byte_8001C08
off_8001C04:
	.word off_8001C24
byte_8001C08:
	.word 0x8
	.word 0x8
	.word 0x8
	.word 0x8
	.word 0x8
	.word 0x8
	.word 0x8
off_8001C24:
   // 0x0 copy palette
	.word sprite_QueueAnimFrameGfxUpload_8001C44+1 // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
   // 0x4 copy 0x20 sized tiles
	.word gfx_renderAnimTileSheet_8001C94+1 // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
   // 0x8 ???
	.word sub_8001C52+1 // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
  // 0xc manual palette transform
	.word sprite_gfxAnimState_GotoNext_8002310+1 // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
   // 0x10 play sound effect
	.word sub_800232A+1 // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
   // 0x14 set or clear event flag
	.word sub_8002338+1 // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
   // 0x18 copy 0x40 sized tiles
	.word buildGFXAnimFrame_8001CFC+1 // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
off_8001C40:
	.word eGFXAnimStates
	thumb_func_end ProcessGFXAnims

// symdb: Queues an 8-word-aligned VRAM upload of an animation frame's graphics using the frame data linked from the anim state.
// symdb: void sprite_QueueAnimFrameGfxUpload(void* gfxDataNext /* r0 */, GFXAnimState* animState /* r7
// symdb: */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_QueueAnimFrameGfxUpload_8001C44.yaml
	thumb_local_start
sprite_QueueAnimFrameGfxUpload_8001C44: // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
	push {lr}
	ldr r0, [r0,#oGFXAnimData_ParamNext - oGFXAnimData_ParamNext]
	ldr r1, [r7,#oGFXAnimState_Param0]
	ldr r2, [r7,#oGFXAnimState_Param1]
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {pc}
	thumb_func_end sprite_QueueAnimFrameGfxUpload_8001C44

	thumb_local_start
sub_8001C52: // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
	push {lr}
	ldr r5, off_8001C90 // =eMapTilesState200be70
	ldr r5, [r5,#0xc] // (dword_200BE7C - 0x200be70)

	ldrb r2, [r7,#oGFXAnimState_Param3]
	lsl r2, r2, #2
	add r2, #4
	ldr r2, [r5,r2]
	add r5, r5, r2

	mov r6, #0xf0
	lsl r6, r6, #8

	ldrb r2, [r7,#oGFXAnimState_Param2]

	mov r8, r7
loop_8001C6A:
	ldr r1, [r0,#oGFXAnimData_ParamNext - oGFXAnimData_ParamNext]
	ldr r7, [r0,#oGFXAnimData_Delay - oGFXAnimData_ParamNext]
	ldrh r3, [r5,r1]
	and r3, r6
	orr r3, r7
	strh r3, [r5,r1]
	add r0, #8
	sub r2, #1
	bgt loop_8001C6A

	mov r7, r8
	push {r4,r7}
	ldr r5, off_8001C90 // =eMapTilesState200be70
	bl redrawBGTileIdsWindowCellByCell_8030808
	pop {r4,r7}
	mov r0, #0
	strb r0, [r7,#oGFXAnimState_IsActive]
	pop {pc}
	.balign 4, 0
off_8001C90:
	.word eMapTilesState200be70
	thumb_func_end sub_8001C52

// symdb: Renders one frame of an animated GFX tile sheet by decoding each u16 descriptor into an EWRAM scratch buffer and queueing a word-aligned copy to the destination
// symdb: void gfx_renderAnimTileSheet_8001C94(u32 r0 /* *GFXAnimDataNext */,
// symdb: struct GFXAnimState* r7)   -> preserves r4, r7; out c/v from QueueEightWordAlignedGFXTransfer;
// symdb: clobbers r0-r3, r5, r6, r8, r9, r12
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/gfx_renderAnimTileSheet_8001C94.yaml
	thumb_local_start
gfx_renderAnimTileSheet_8001C94: // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
	push {r4,r7,lr}

	// read pointer
	ldr r6, [r0,#oGFXAnimData_ParamNext - oGFXAnimData_ParamNext]

	// get some ewram address?
	ldr r5, off_8001CE4 // =off_8001AB8
	ldrb r4, [r7,#oGFXAnimState_Param3]
	lsl r4, r4, #2
	ldr r5, [r5,r4]

	// read pointer
	ldr r4, [r7,#oGFXAnimState_Param0]
	mov r1, #0
	push {r0}

loc_8001CA6:
	// read from memory
	ldrh r2, [r6,r1]
	// & 0x3ff
	lsl r3, r2, #0x16
	lsr r3, r3, #0x16
	// r3 has mask 0xffc0
	lsl r3, r3, #5
	push {r4,r6}
	// add r3 as offset to r4 pointer
	add r4, r4, r3
	// jumptable
	ldr r0, off_8001CE8 // =off_8001CEC
	// use these bits of r2 for jumptable index
	//    ||
	//    vv
	// 0b 1111 1111 1111
	lsr r2, r2, #0xa
	lsl r2, r2, #2
	ldr r0, [r0,r2]
	mov lr, pc
	bx r0
	pop {r4,r6}
	add r5, #0x20
	add r1, #2

	// upper limit
	ldrb r2, [r7,#oGFXAnimState_Param2]
	lsl r2, r2, #1
	cmp r1, r2
	blt loc_8001CA6
	pop {r0}

	// read same ewram address again
	ldr r0, off_8001CE4 // =off_8001AB8
	ldrb r1, [r7,#oGFXAnimState_Param3]
	lsl r1, r1, #2
	ldr r0, [r0,r1]

	// dest pointer
	ldr r1, [r7,#oGFXAnimState_Param1]

	// size
	ldrb r2, [r7,#oGFXAnimState_Param2]
	lsl r2, r2, #5
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r4,r7,pc}
	.balign 4, 0
off_8001CE4:
	.word off_8001AB8
off_8001CE8:
	.word off_8001CEC
off_8001CEC:
	.word sub_8001D64+1
	.word sub_8001D86+1
	.word sub_8001EAE+1
	.word sub_8001ED0+1
	thumb_func_end gfx_renderAnimTileSheet_8001C94

// symdb: Decodes one frame of a graphics animation stream into the object's per-tile scratch buffer and queues a single aligned DMA-style copy of the finished tiles to the object's destination.
// symdb: void sub_8001CFC(void *params /*r0*/, GFXAnimState *self /*r7*/) -> (r0..r3,r5,r6,flags
// symdb: clobbered; r4/r7 preserved via push/pop)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/buildGFXAnimFrame_8001CFC.yaml
	thumb_local_start
buildGFXAnimFrame_8001CFC: // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
	push {r4,r7,lr}

	// read pointer
	ldr r6, [r0,#oGFXAnimData_ParamNext - oGFXAnimData_ParamNext]

	// get some ewram address?
	ldr r5, off_8001D4C // =off_8001AB8
	ldrb r4, [r7,#oGFXAnimState_Param3]
	lsl r4, r4, #2
	ldr r5, [r5,r4]

	// read pointer
	ldr r4, [r7,#oGFXAnimState_Param0]
	mov r1, #0
	push {r0}

loc_8001D0E:
	// read from memory
	ldrh r2, [r6,r1]
	// & 0x3ff
	lsl r3, r2, #0x16
	lsr r3, r3, #0x16
	// r3 has mask 0xffc0
	lsl r3, r3, #6
	push {r4,r6}
	// add r3 as offset to r4 pointer
	add r4, r4, r3
	// jumptable
	ldr r0, off_8001D50 // =off_8001D54
	// use these bits of r2 for jumptable index
	//    ||
	//    vv
	// 0b 1111 1111 1111
	lsr r2, r2, #0xa
	lsl r2, r2, #2
	ldr r0, [r0,r2]
	mov lr, pc
	bx r0
	pop {r4,r6}
	add r5, #0x40
	add r1, #2

	// upper limit
	ldrb r2, [r7,#oGFXAnimState_Param2]
	lsl r2, r2, #1
	cmp r1, r2
	blt loc_8001D0E
	pop {r0}

	// read same ewram address again
	ldr r0, off_8001D4C // =off_8001AB8
	ldrb r1, [r7,#oGFXAnimState_Param3]
	lsl r1, r1, #2
	ldr r0, [r0,r1]

	// dest pointer
	ldr r1, [r7,#oGFXAnimState_Param1]

	// size
	ldrb r2, [r7,#oGFXAnimState_Param2]
	lsl r2, r2, #6
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
	pop {r4,r7,pc}
	.balign 4, 0
off_8001D4C:
	.word off_8001AB8
off_8001D50:
	.word off_8001D54
off_8001D54:
	.word copyStruct_64bytes_8002000+1
	.word sub_8002042+1
	.word sub_800218C+1
	.word sub_80021CE+1
	thumb_func_end buildGFXAnimFrame_8001CFC

// symdb: Copy 8 words (0x20 bytes) from r4 to r5.
// symdb: (r4 = source, r5 = destination) -> r0 = last word
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sub_8001D64.yaml
	thumb_local_start
sub_8001D64:
	ldr r0, [r4]
	str r0, [r5]
	ldr r0, [r4,#4]
	str r0, [r5,#4]
	ldr r0, [r4,#8]
	str r0, [r5,#8]
	ldr r0, [r4,#0xc]
	str r0, [r5,#0xc]
	ldr r0, [r4,#0x10]
	str r0, [r5,#0x10]
	ldr r0, [r4,#0x14]
	str r0, [r5,#0x14]
	ldr r0, [r4,#0x18]
	str r0, [r5,#0x18]
	ldr r0, [r4,#0x1c]
	str r0, [r5,#0x1c]
	mov pc, lr
	thumb_func_end sub_8001D64

	thumb_local_start
sub_8001D86:
	ldr r2, dword_8001FFC // =0xf0f0f0f0
	mov r9, r2
	ldr r2, dword_8001FF8 // =0xff00ff00
	mov r8, r2
	ldr r0, [r4]
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5]
	ldr r0, [r4,#4]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#4]
	ldr r0, [r4,#8]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#8]
	ldr r0, [r4,#0xc]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0xc]
	ldr r0, [r4,#0x10]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0x10]
	ldr r0, [r4,#0x14]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0x14]
	ldr r0, [r4,#0x18]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0x18]
	ldr r0, [r4,#0x1c]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0x1c]
	mov pc, lr
	thumb_func_end sub_8001D86

	thumb_local_start
sub_8001EAE:
	ldr r0, [r4]
	str r0, [r5,#0x1c]
	ldr r0, [r4,#4]
	str r0, [r5,#0x18]
	ldr r0, [r4,#8]
	str r0, [r5,#0x14]
	ldr r0, [r4,#0xc]
	str r0, [r5,#0x10]
	ldr r0, [r4,#0x10]
	str r0, [r5,#0xc]
	ldr r0, [r4,#0x14]
	str r0, [r5,#8]
	ldr r0, [r4,#0x18]
	str r0, [r5,#4]
	ldr r0, [r4,#0x1c]
	str r0, [r5]
	mov pc, lr
	thumb_func_end sub_8001EAE

	thumb_local_start
sub_8001ED0:
	ldr r2, dword_8001FFC // =0xf0f0f0f0
	mov r9, r2
	ldr r2, dword_8001FF8 // =0xff00ff00
	mov r8, r2
	ldr r0, [r4]
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0x1c]
	ldr r0, [r4,#4]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0x18]
	ldr r0, [r4,#8]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0x14]
	ldr r0, [r4,#0xc]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0x10]
	ldr r0, [r4,#0x10]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#0xc]
	ldr r0, [r4,#0x14]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#8]
	ldr r0, [r4,#0x18]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5,#4]
	ldr r0, [r4,#0x1c]
	mov r2, r8
	lsr r3, r2, #8
	and r2, r0
	and r3, r0
	lsr r0, r2, #8
	lsl r3, r3, #8
	orr r0, r3
	mov r2, #0x10
	ror r0, r2
	mov r2, r9
	lsr r3, r2, #4
	and r2, r0
	and r3, r0
	lsr r0, r2, #4
	lsl r3, r3, #4
	orr r0, r3
	str r0, [r5]
	mov pc, lr
	.balign 4, 0
dword_8001FF8:
	.word 0xFF00FF00
dword_8001FFC:
	.word 0xF0F0F0F0
	thumb_func_end sub_8001ED0

// symdb: Copies a 64-byte (16-word) structure from one buffer to another.
// symdb: void sub_8002000(u32 dst_ptr in r5, u32 src_ptr in r4); clobbers r0
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyStruct_64bytes_8002000.yaml
	thumb_local_start
copyStruct_64bytes_8002000:
	ldr r0, [r4]
	str r0, [r5]
	ldr r0, [r4,#4]
	str r0, [r5,#4]
	ldr r0, [r4,#8]
	str r0, [r5,#8]
	ldr r0, [r4,#0xc]
	str r0, [r5,#0xc]
	ldr r0, [r4,#0x10]
	str r0, [r5,#0x10]
	ldr r0, [r4,#0x14]
	str r0, [r5,#0x14]
	ldr r0, [r4,#0x18]
	str r0, [r5,#0x18]
	ldr r0, [r4,#0x1c]
	str r0, [r5,#0x1c]
	ldr r0, [r4,#0x20]
	str r0, [r5,#0x20]
	ldr r0, [r4,#0x24]
	str r0, [r5,#0x24]
	ldr r0, [r4,#0x28]
	str r0, [r5,#0x28]
	ldr r0, [r4,#0x2c]
	str r0, [r5,#0x2c]
	ldr r0, [r4,#0x30]
	str r0, [r5,#0x30]
	ldr r0, [r4,#0x34]
	str r0, [r5,#0x34]
	ldr r0, [r4,#0x38]
	str r0, [r5,#0x38]
	ldr r0, [r4,#0x3c]
	str r0, [r5,#0x3c]
	mov pc, lr
	thumb_func_end copyStruct_64bytes_8002000

	thumb_local_start
sub_8002042:
	ldr r2, dword_8002188 // =0xff00ff00
	mvn r3, r2
	ldr r0, [r4]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5]
	ldr r0, [r4,#4]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#4]
	ldr r0, [r4,#8]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#8]
	ldr r0, [r4,#0xc]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0xc]
	ldr r0, [r4,#0x10]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x10]
	ldr r0, [r4,#0x14]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x14]
	ldr r0, [r4,#0x18]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x18]
	ldr r0, [r4,#0x1c]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x1c]
	ldr r0, [r4,#0x20]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x20]
	ldr r0, [r4,#0x24]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x24]
	ldr r0, [r4,#0x28]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x28]
	ldr r0, [r4,#0x2c]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x2c]
	ldr r0, [r4,#0x30]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x30]
	ldr r0, [r4,#0x34]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x34]
	ldr r0, [r4,#0x38]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x38]
	ldr r0, [r4,#0x3c]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x3c]
	mov pc, lr
dword_8002188:
	.word 0xFF00FF00
	thumb_func_end sub_8002042

	thumb_local_start
sub_800218C:
	ldr r0, [r4]
	str r0, [r5,#0x1c]
	ldr r0, [r4,#4]
	str r0, [r5,#0x18]
	ldr r0, [r4,#8]
	str r0, [r5,#0x14]
	ldr r0, [r4,#0xc]
	str r0, [r5,#0x10]
	ldr r0, [r4,#0x10]
	str r0, [r5,#0xc]
	ldr r0, [r4,#0x14]
	str r0, [r5,#8]
	ldr r0, [r4,#0x18]
	str r0, [r5,#4]
	ldr r0, [r4,#0x1c]
	str r0, [r5]
	ldr r0, [r4,#0x20]
	str r0, [r5,#0x3c]
	ldr r0, [r4,#0x24]
	str r0, [r5,#0x38]
	ldr r0, [r4,#0x28]
	str r0, [r5,#0x34]
	ldr r0, [r4,#0x2c]
	str r0, [r5,#0x30]
	ldr r0, [r4,#0x30]
	str r0, [r5,#0x2c]
	ldr r0, [r4,#0x34]
	str r0, [r5,#0x28]
	ldr r0, [r4,#0x38]
	str r0, [r5,#0x24]
	ldr r0, [r4,#0x3c]
	str r0, [r5,#0x20]
	mov pc, lr
	thumb_func_end sub_800218C

	thumb_local_start
sub_80021CE:
	ldr r0, [r4]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x1c]
	ldr r0, [r4,#4]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x18]
	ldr r0, [r4,#8]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x14]
	ldr r0, [r4,#0xc]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x10]
	ldr r0, [r4,#0x10]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0xc]
	ldr r0, [r4,#0x14]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#8]
	ldr r0, [r4,#0x18]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#4]
	ldr r0, [r4,#0x1c]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5]
	ldr r0, [r4,#0x20]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x3c]
	ldr r0, [r4,#0x24]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x38]
	ldr r0, [r4,#0x28]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x34]
	ldr r0, [r4,#0x2c]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x30]
	ldr r0, [r4,#0x30]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x2c]
	ldr r0, [r4,#0x34]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x28]
	ldr r0, [r4,#0x38]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x24]
	ldr r0, [r4,#0x3c]
	mov r1, r0
	and r0, r2
	and r1, r3
	lsr r0, r0, #8
	lsl r1, r1, #8
	orr r0, r1
	mov r1, #0x10
	ror r0, r1
	str r0, [r5,#0x20]
	mov pc, lr
	thumb_func_end sub_80021CE

	thumb_local_start
// r0 = [oGFXAnimData_Param0] - jumptable index
// r1 = [oGFXAnimData_ParamNext] - param
// r2 = [oGFXAnimData_Param2] - num palettes
// r3 = [oGFXAnimData_Index] - S20094c0 index
// r4 = [oGFXAnimData_Param1] - dest?
// symdb: Switches a graphics animation state over to the "next" animation referenced by its current animation data slot.
// symdb: void sprite_gfxAnimState_GotoNext(const struct GFXAnimData* animData /*r0*/, struct
// symdb: GFXAnimState* state /*r7*/); r4-r6 passed through as scratch; r4-r7 preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_gfxAnimState_GotoNext_8002310.yaml
sprite_gfxAnimState_GotoNext_8002310: // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
	push {lr}
	push {r4,r7}
	ldr r1, [r0,#oGFXAnimData_ParamNext - oGFXAnimData_ParamNext]
	lsl r1, r1, #1
	lsr r1, r1, #1
	ldrb r0, [r7,#oGFXAnimState_Param0]
	ldrb r2, [r7,#oGFXAnimState_Param2]
	ldrb r3, [r7,#oGFXAnimState_Index]
	ldr r4, [r7,#oGFXAnimState_Param1]
	bl sub_8002378
	pop {r4,r7}
	pop {pc}
	thumb_func_end sprite_gfxAnimState_GotoNext_8002310

	thumb_local_start
sub_800232A: // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
	push {lr}
	ldr r0, [r0,#oGFXAnimData_ParamNext - oGFXAnimData_ParamNext]
	cmp r0, #0
	blt .noSound
	bl PlaySoundEffect
.noSound
	pop {pc}
	thumb_func_end sub_800232A

	thumb_local_start
sub_8002338: // (self: * GFXAnimState $r7, params: * GFXAnimDataNext) -> ()
	push {lr}
	ldr r0, [r0]
	cmp r0, #0
	blt .clearEventFlag
	mov r0, r0
	bl SetEventFlag
	b .done
.clearEventFlag
	lsl r0, r0, #1
	lsr r0, r0, #1
	mov r0, r0
	bl ClearEventFlag // (u16 entryFlagBitfield) -> void
.done
	pop {pc}
	thumb_func_end sub_8002338

// symdb: Loads every GFX animation script from a NULL/negative-terminated array of GFXAnimScript pointers.
// symdb: void LoadGFXAnims(void* gfx_anim_data_arr /* FFStop32<[GFXAnimScript*]> in r0 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/LoadGFXAnims.yaml
	thumb_func_start LoadGFXAnims
LoadGFXAnims: // (gfx_anim_data_arr: * FFStop32<[GFXAnimScript]>) -> ()
	push {r5,lr}
	mov r5, r0
.loadGFXAnimLoop
	ldr r0, [r5]
	cmp r0, #NULL
	blt .done
	bl LoadGFXAnim // (script: * GFXAnimScript) -> ()
	add r5, #4
	b .loadGFXAnimLoop
.done
	pop {r5,pc}
	thumb_func_end LoadGFXAnims

// symdb: Zero-fills the fixed 0x108-byte palette buffer at ePalette20097a0 by word writes.
// symdb: void zeroFill_e20097A0(void); // in: r2 r3 lr (lr only for return); out: flags c v as left by
// symdb: ZeroFillByWord; r2 r3 preserved, r0 r1 and nz clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/zeroFill_e20097A0.yaml
	thumb_func_start zeroFill_e20097A0
zeroFill_e20097A0:
	push {lr}
	// memBlock
	ldr r0, off_8002464 // =ePalette20097a0
	// size
	ldr r1, off_8002374 // =0x108
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	.balign 4, 0
off_8002374:
	.word 0x108
	thumb_func_end zeroFill_e20097A0

// symdb: Fill slot r3 of the software palette table ePalette20097a0 (only when r1 and r2 are nonzero); its flag byte says whether it was filled.
// symdb: (r0 byte, r1 = palette data, r2 = colour count, r3 = slot, r4 word) -> slot fields 1/4/2/8 =
// symdb: r0/r1/r2/r4; byte 0 = r3 = filled
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_8002378.yaml
	thumb_func_start sub_8002378
sub_8002378:
	push {r5-r7,lr}
	ldr r7, off_8002464 // =ePalette20097a0
	mov r6, #oPalette20097a0_Size
	mul r3, r6
	add r7, r7, r3
	mov r3, #0
	tst r1, r1
	beq loc_8002396
	tst r2, r2
	beq loc_8002396
	strb r0, [r7,#oPalette20097a0_Priority]
	str r1, [r7,#oPalette20097a0_SourceAddress]
	strb r2, [r7,#oPalette20097a0_ColorCountOrDepth]
	mov r3, #1
	str r4, [r7,#oPalette20097a0_PalettePointerOrIndex]
loc_8002396:
	strb r3, [r7,#oPalette20097a0_ActiveFlag]
	pop {r5-r7,pc}
	thumb_func_end sub_8002378

// symdb: Frees one entry of the ePalette20097a0 palette pool by clearing its first (active) byte.
// symdb: void Terminate_ePalette20097a0_Transform(u32 index) // r0 = entry index; returns r0=0, r1=entry
// symdb: size, r2=address of cleared byte; sets nz/c/v
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/Terminate_ePalette20097a0_Transform.yaml
	thumb_func_start Terminate_ePalette20097a0_Transform
Terminate_ePalette20097a0_Transform:
	ldr r2, off_8002464 // =ePalette20097a0
	mov r1, #oPalette20097a0_Size
	mul r0, r1
	add r2, r2, r0
	mov r0, #0
	strb r0, [r2,#oPalette20097a0_ActiveFlag]
	mov pc, lr
	thumb_func_end Terminate_ePalette20097a0_Transform

// symdb: Zero-fills the 0xD8-byte palette object at ePalette20097a0 (216 bytes = 16 palettes of 16 BGR555 entries).
// symdb: void sub_80023A8(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/palette_clearEPalette20097a0_80023A8.yaml
	thumb_func_start palette_clearEPalette20097a0_80023A8
palette_clearEPalette20097a0_80023A8:
	push {lr}
	// memBlock
	ldr r0, off_8002464 // =ePalette20097a0
	// size
	ldr r1, off_80023B4 // =0xd8
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {pc}
	.balign 4, 0
off_80023B4:
	.word 0xd8
	thumb_func_end palette_clearEPalette20097a0_80023A8

	thumb_local_start
sub_80023B8:
	ldr r2, off_8002464 // =ePalette20097a0
	mov r1, #oPalette20097a0_Size
	mul r1, r0
	add r2, r2, r1
	ldrb r0, [r2,#oPalette20097a0_ActiveFlag]
	tst r0, r0
	mov pc, lr
	thumb_func_end sub_80023B8

	thumb_local_start
sub_80023C6:
	ldr r2, off_8002464 // =ePalette20097a0
	ldr r3, off_80023DC // =0x108
loc_80023CA:
	ldrb r0, [r2]
	tst r0, r0
	bne locret_80023D8
	add r2, #oPalette20097a0_Size
	cmp r2, r3
	blt loc_80023CA
	mov r0, #0
locret_80023D8:
	mov pc, lr
	.balign 4, 0
off_80023DC:
	.word 0x108
	thumb_func_end sub_80023C6

	thumb_func_start getPalleteAndTransition_80023E0
getPalleteAndTransition_80023E0:
	push {r5-r7,lr}
	ldr r0, off_800243C // =palette_3001960
	ldr r1, off_8002440 // =iPalette3001B60
	mov r2, #0x20
	lsl r2, r2, #4
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	ldr r0, off_8002444 // =byte_3001550
	ldr r1, off_8002448 // =iPallete3001750
	mov r2, #0x20
	lsl r2, r2, #4
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	ldr r5, off_8002464 // =ePalette20097a0
loc_80023FC:
	ldrb r0, [r5,#oPalette20097a0_ActiveFlag]
	tst r0, r0
	beq loc_8002428
	ldr r0, [r5,#oPalette20097a0_SourceAddress] // (dword_20097A4 - 0x20097a0)
	ldrb r2, [r5,#oPalette20097a0_Priority] // (byte_20097A1 - 0x20097a0)
	ldrb r6, [r5,#oPalette20097a0_ColorCountOrDepth] // (byte_20097A2 - 0x20097a0)
	ldr r7, [r5,#oPalette20097a0_PalettePointerOrIndex] // (dword_20097A8 - 0x20097a0)
	cmp r7, #6
	bge loc_800241E
	ldr r6, off_8002438 // =unk_200F388
	add r7, r7, r6
	ldrb r1, [r7]
	ldrb r6, [r7,#1]
	sub r6, r6, r1
	ldr r7, off_8002448 // =iPallete3001750
	lsl r1, r1, #5
	add r7, r7, r1
loc_800241E:
	lsl r6, r6, #5
	ldr r3, off_800244C // =byte_8002450
	ldr r3, [r3,r2]
	mov lr, pc
	bx r3
loc_8002428:
	add r5, #oPalette20097a0_Size
	ldr r6, off_8002464 // =ePalette20097a0
	ldr r0, off_8002460 // =0x108
	add r6, r6, r0
	cmp r5, r6
	blt loc_80023FC
	pop {r5-r7,pc}
	.balign 4, 0
off_8002438:
	.word unk_200F388
off_800243C:
	.word palette_3001960
off_8002440:
	.word iPalette3001B60
off_8002444:
	.word byte_3001550
off_8002448:
	.word iPallete3001750
off_800244C:
	.word byte_8002450
byte_8002450:
	.word palette_addOrSubtractColor+1
	.word palette_addOrSubtractColor+1
	.word palette_fadeTowardWhiteOrBlack+1
	.word palette_fadeTowardWhiteOrBlack+1
off_8002460:
	.word 0x108
off_8002464:
	.word ePalette20097a0
	thumb_func_end getPalleteAndTransition_80023E0

// symdb: Zeroes the 0x50-byte IWRAM/Scratch eStruct at 0x200A6A0, stores three caller parameters into its +4/+8/+C slots, and marks it active (byte at +0 = 1).
// symdb: void initEStruct200a6a0(u32 param1 /*r0*/, u32 param2 /*r1*/, u32 param3 /*r2*/); /* r1..r7
// symdb: preserved; r0 returned = 1 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/Initialize_eStruct200a6a0.yaml
	thumb_func_start Initialize_eStruct200a6a0
Initialize_eStruct200a6a0:
	push {r4-r7,lr}
	ldr r5, off_80024C8 // =eStruct200a6a0
	push {r0-r2}
	// memBlock
	mov r0, r5
	// size
	mov r1, #0x50
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {r0-r2}
	str r0, [r5,#0x4] // (dword_200A6A4 - 0x200a6a0)
	str r1, [r5,#0x8] // (dword_200A6A8 - 0x200a6a0)
	str r2, [r5,#0xc] // (dword_200A6AC - 0x200a6a0)
	mov r0, #1
	strb r0, [r5]
	pop {r4-r7,pc}
	thumb_func_end Initialize_eStruct200a6a0

// symdb: Fires the installed callback on the eStruct200a6a0 event block if it is armed, then clears the whole 0x50-byte block
// symdb: void run_eStruct200a6a0_Callback_8002484(void);  // uses r10, lr on entry; preserves r4-r7;
// symdb: trashes r0-r3, r8, r9, r11, r12, flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/run_eStruct200a6a0_Callback_8002484.yaml
	thumb_func_start run_eStruct200a6a0_Callback_8002484
run_eStruct200a6a0_Callback_8002484:
	push {r4-r7,lr}
	ldr r5, off_80024C8 // =eStruct200a6a0
	ldrb r0, [r5]
	tst r0, r0
	beq loc_8002498
	ldr r0, [r5,#0x8] // (dword_200A6A8 - 0x200a6a0)
	tst r0, r0
	beq loc_8002498
	mov lr, pc
	bx r0
loc_8002498:
	// memBlock
	mov r0, r5
	// size
	mov r1, #0x50
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {r4-r7,pc}
	thumb_func_end run_eStruct200a6a0_Callback_8002484

// symdb: Zero-fills the fixed 0x50-byte global struct at eStruct200a6a0, resetting it to a cleared state.
// symdb: void zeroFill_80024A2(void); // takes nothing in registers, returns r1 and c/v flags as left by
// symdb: ZeroFillByWord (callers effectively ignore them)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/zeroFill_80024A2.yaml
	thumb_func_start zeroFill_80024A2
zeroFill_80024A2:
	push {r4-r7,lr}
	// memBlock
	ldr r0, off_80024C8 // =eStruct200a6a0
	// size
	mov r1, #0x50
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()
	pop {r4-r7,pc}
	thumb_func_end zeroFill_80024A2

// symdb: Invokes the currently armed callback stored in the record at 0x200A6A0, if its armed flag is set.
// symdb: void event_runArmedCallback(void); /* trashes r0, flags; preserves r1-r12 per contract; tail
// symdb: effect: whatever the registered callback does to r1-r3/flags is hidden by the lifter's caller
// symdb: analysis */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/event_runArmedCallback_80024AE.yaml
	thumb_func_start event_runArmedCallback_80024AE
event_runArmedCallback_80024AE:
	push {r4-r7,lr}
	ldr r5, off_80024C8 // =eStruct200a6a0
	ldrb r0, [r5]
	tst r0, r0
	beq locret_80024BE
	ldr r0, [r5,#0x4] // (dword_200A6A4 - 0x200a6a0)
	mov lr, pc
	bx r0
locret_80024BE:
	pop {r4-r7,pc}
	thumb_func_end event_runArmedCallback_80024AE

	thumb_func_start Is_eStruct200a6a0_Initialized
Is_eStruct200a6a0_Initialized:
	ldr r1, off_80024C8 // =eStruct200a6a0
	ldrb r0, [r1]
	tst r0, r0
	mov pc, lr
off_80024C8:
	.word eStruct200a6a0
	thumb_func_end Is_eStruct200a6a0_Initialized

	thumb_local_start
sub_80024CC:
	push {r4-r7,lr}
	mov r4, r8
	mov r5, r9
	push {r4,r5}
	mov r4, #4
	b loc_80024E2
loc_80024D8:
	push {r4-r7,lr}
	mov r4, r8
	mov r5, r9
	push {r4,r5}
	mov r4, #0
loc_80024E2:
	ldr r6, off_80025C0 // =dword_80025C4
	add r6, r6, r4
	mov r8, r6
	mov r9, r1
	mov r4, r2
	mov r6, #1
	tst r2, r6
	beq loc_80024F4
	add r2, #1
loc_80024F4:
	lsr r7, r2, #1
	mov r5, r3
	tst r3, r6
	beq loc_80024FE
	add r3, #1
loc_80024FE:
	lsr r6, r3, #1
	bl sub_8003694
	push {r0,r1}
	sub r0, #0x78
	sub r1, #0x50
	neg r0, r0
	neg r1, r1
	mov r2, #0xf0
	sub r2, r2, r4
	lsr r2, r2, #1
	sub r0, r0, r2
	mov r2, #0xa0
	sub r2, r2, r5
	lsr r2, r2, #1
	sub r1, r1, r2
	mov r2, r10
	ldr r2, [r2,#oToolkit_RenderInfoPtr]
	mov r3, r8
	ldrb r3, [r3]
	strh r0, [r2,r3]
	mov r3, r8
	ldrb r3, [r3,#0x1] // (byte_80025C9 - 0x80025c8)
	strh r1, [r2,r3]
	mov r2, r8
	// tileBlock32x32
	ldrb r2, [r2,#0x2] // (byte_80025CA - 0x80025c8)
	// tileIds
	mov r3, r9
	lsr r4, r4, #3
	// j
	mov r0, #0
	// i
	mov r1, #0
	lsr r5, r5, #3
	bl CopyBackgroundTiles // (j: u32, i: u32, which_tile_block_32x32: u32, tile_ids: *const u16, j_size: u32, i_size: u32 ) -> ()
	pop {r0,r1}
	mov r5, r10
	ldr r5, [r5,#oToolkit_Unk200f3a0_Ptr]
	cmp r0, r7
	bge loc_800254E
	mov r2, #0
	b loc_800255E
loc_800254E:
	mov r4, #0xf0
	add r4, r4, r7
	cmp r0, r4
	ble loc_800255A
	mov r2, #0xf0
	b loc_800255E
loc_800255A:
	mov r4, r7
	sub r2, r0, r4
loc_800255E:
	strb r2, [r5,#3]
	mov r4, r7
	neg r4, r4
	cmp r0, r4
	bge loc_800256C
	mov r2, #0
	b loc_800257C
loc_800256C:
	mov r3, #0xf0
	sub r3, r3, r7
	cmp r0, r3
	ble loc_8002578
	mov r2, #0xf0
	b loc_800257C
loc_8002578:
	mov r4, r7
	add r2, r0, r4
loc_800257C:
	strb r2, [r5,#2]
	mov r4, #0xa0
	add r4, r4, r6
	cmp r1, r6
	bge loc_800258A
	mov r2, #0
	b loc_8002596
loc_800258A:
	cmp r1, r4
	ble loc_8002592
	mov r2, #0xa0
	b loc_8002596
loc_8002592:
	mov r4, r6
	sub r2, r1, r4
loc_8002596:
	strb r2, [r5,#7]
	mov r4, r6
	neg r4, r4
	cmp r1, r4
	bge loc_80025A4
	mov r2, #0
	b loc_80025B4
loc_80025A4:
	mov r3, #0xa0
	sub r3, r3, r6
	cmp r1, r3
	ble loc_80025B0
	mov r2, #0xa0
	b loc_80025B4
loc_80025B0:
	mov r4, r6
	add r2, r1, r4
loc_80025B4:
	strb r2, [r5,#6]
	pop {r4,r5}
	mov r8, r4
	mov r9, r5
	pop {r4-r7,pc}
	.balign 4, 0
off_80025C0:
	.word dword_80025C4
dword_80025C4:
	.word 0xFF031A18
byte_80025C8:
	.byte 0x14
byte_80025C9:
	.byte 0x16
byte_80025CA:
	.byte 0x2, 0xFF
byte_80025CC:
	.byte 0x0, 0x0, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F
	.byte 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F
	.byte 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F, 0xFF, 0x7F
	.byte 0xFF, 0x7F, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
	.byte 0x0, 0x0, 0x0, 0x0
	thumb_func_end sub_80024CC

/// tags: "#mcu, "
// symdb: Resets overworld scene state by zeroing OAM and sound RAM, then reinitializing player/NPC/map object structs, sprite variables, and a small RAM buffer.
// symdb: void resetOverworldScene_800260C(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/resetOverworldScene_800260C.yaml
	thumb_func_start resetOverworldScene_800260C
resetOverworldScene_800260C:
	push {r4,lr}

	ldr r0, dword_800263C // =0x7000000
	ldr r1, off_8002640 // =0x400
	bl ZeroFillByEightWords // (int a1, int a2) -> void

	ldr r0, dword_8002644 // =0x6010000
	ldr r1, dword_8002648 // =0x8000
	bl ZeroFillByEightWords // (int a1, int a2) -> void

	bl copy_8002668

	bl InitializeOWPlayerObjectStruct

	bl InitializeOverworldNPCObjectStructs

	bl InitializeOverworldMapObjectStructs

	bl sprite_resetObjVars_800289C

	ldr r0, off_800264C // =unk_200F388
	mov r1, #7
	bl ZeroFillByByte // (mut_mem: *mut (), num_bytes: usize) -> ()

	pop {r4,pc}
	.balign 4, 0
dword_800263C:
	.word 0x7000000
off_8002640:
	.word 0x400
dword_8002644:
	.word 0x6010000
dword_8002648:
	.word 0x8000
off_800264C:
	.word unk_200F388
	thumb_func_end resetOverworldScene_800260C

// symdb: Copies the 0x200-byte BG palette buffered in IWRAM (iPallete3001750) into hardware BG palette RAM at 0x05000200.
// symdb: void copyPalletesToIWRAM_8002650(void) — no meaningful register inputs; r3 is passed through and
// symdb: preserved; no outputs (CPSR nz clobbered)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/copyPalletesToIWRAM_8002650.yaml
	thumb_func_start copyPalletesToIWRAM_8002650
copyPalletesToIWRAM_8002650:
	push {lr}
	ldr r0, off_8002660 // =iPallete3001750
	ldr r1, dword_8002664 // =0x5000200
	mov r2, #0x20
	lsl r2, r2, #4
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()
	pop {pc}
	.balign 4, 0
off_8002660:
	.word iPallete3001750
dword_8002664:
	.word 0x5000200
	thumb_func_end copyPalletesToIWRAM_8002650

	thumb_func_start copy_8002668
copy_8002668:
	push {lr}

	ldr r0, off_800268C // =dword_86A5500
	ldr r1, off_8002690 // =byte_3001710
	mov r2, #0x20
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	b loc_8002678

// copy both or copy one variants
call_8002676:
	push {lr}

loc_8002678:
	ldr r0, off_8002684 // =byte_80025CC
	ldr r1, off_8002688 // =byte_3001730
	mov r2, #0x20
	bl CopyByEightWords // (src: *const u32, mut_dest: *mut u32, size: u32) -> ()

	pop {pc}
	.balign 4, 0
off_8002684:
	.word byte_80025CC
off_8002688:
	.word byte_3001730
off_800268C:
	.word dword_86A5500
off_8002690:
	.word byte_3001710
	thumb_func_end copy_8002668

// symdb: Thumb↔ARM veneer that tail-calls sprite_queueFramePieces on the IWRAM sprite
// symdb: (r0 = sprite param, r1 = chatbox mugshot?, r2/r3/.. = preserved) -> returns whatever
// symdb: sprite_queueFramePieces returns; side effects: queues OAM for the current animation frame
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sprite_queueFramePiecesViaSub_8002694.yaml
	thumb_func_start sprite_queueFramePiecesViaSub_8002694
sprite_queueFramePiecesViaSub_8002694:
	push {lr}
	ldr r2, off_80026A0 // =sprite_queueFramePieces+1
	mov lr, pc
	bx r2
	pop {pc}
	.balign 4, 0x00
off_80026A0:
	.word sprite_queueFramePieces+1
	thumb_func_end sprite_queueFramePiecesViaSub_8002694

/*For debugging purposes, connect comment at any range!*/
