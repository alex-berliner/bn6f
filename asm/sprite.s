
// () -> void
// symdb: Skips an object header forward to its attached sprite data block and tail-calls the shared animation loader on it.
// symdb: void sprite_loadObjectSpriteAnimation(ObjectHeader* header /* r5 */, scratch r4); trashes r0-r3
// symdb: and flags; preserves r4/r5; called with lr as return address
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_loadAnimationData.yaml
	thumb_func_start sprite_loadAnimationData
sprite_loadAnimationData:
	push {r4,r5,lr}
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r5, r5, r3
	ldr r4, off_80026C0 // =_sprite_loadAnimationData+1
	mov lr, pc
	bx r4
	pop {r4,r5,pc}
	thumb_func_end sprite_loadAnimationData

// symdb: Tiny trampoline that tail-calls _sprite_loadAnimationData while preserving the caller's r4 around the branch.
// symdb: sprite_loadAnimationData_trampoline_r4Preserved(void); // in: r4, r5, lr; out: r2, r3, r4, lr
// symdb: (NZCV clobbered, r4 preserved)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_loadAnimationData_spritePtrProvidedDirectly.yaml
	thumb_func_start sprite_loadAnimationData_spritePtrProvidedDirectly
sprite_loadAnimationData_spritePtrProvidedDirectly:
	push {r4,lr}
	ldr r4, off_80026C0 // =_sprite_loadAnimationData+1
	mov lr, pc
	bx r4
	pop {r4,pc}
off_80026C0:
	.word _sprite_loadAnimationData+1
	thumb_func_end sprite_loadAnimationData_spritePtrProvidedDirectly

// symdb: Run _sprite_update on the object's sprite struct (header + (byte 2 & 0xF0)).
// symdb: (r5 = object header) -> during the call r3 = sprite offset, r4 = _sprite_update, r5 = sprite;
// symdb: r4/r5 restored
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_update.yaml
	thumb_func_start sprite_update
sprite_update:
	push {r4,r5,lr}
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r5, r5, r3
	ldr r4, off_80026E0 // =_sprite_update+1
	mov lr, pc
	bx r4
	pop {r4,r5,pc}
	thumb_func_end sprite_update

// symdb: Tiny thunk that tail-dispatches to the shared sprite update routine with r4 preset to that routine's own thumb address, preserving the caller's r4 across the call.
// symdb: void sprite_updateTrampoline_ADDRESS(void); // in: r5 forwarded untouched to _sprite_update, lr
// symdb: = return addr; out: r4 = caller's original r4 (preserved), flags clobbered by the callee
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_chatbox_80026D6.yaml
	thumb_func_start sprite_chatbox_80026D6
sprite_chatbox_80026D6:
	push {r4,lr}
	ldr r4, off_80026E0 // =_sprite_update+1
	mov lr, pc
	bx r4
	pop {r4,pc}
off_80026E0:
	.word _sprite_update+1
	thumb_func_end sprite_chatbox_80026D6

// (int a1, int a2, int a3) ->
/* r0 = 0x80
   r1 = sprite category
   r2 = sprite index*/
// symdb: Loads a sprite into an object, clearing its loaded-flag bit and falling back to a placeholder when not found.
// symdb: void sprite_load(void *spriteData, u16 spriteId, u8 subIndex, void *objectHeader); /* returns
// symdb: via r4/r5 preserved, r1 holds original spriteData */ /* in:  r0 spriteData, r1 spriteId, r2
// symdb: subIndex, r5 objectHeader out: r1 = original r0 (spriteData), r4/r5 preserved clobbers: N Z C V,
// symdb: r0 r2 r3 lr */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_load.yaml
	thumb_func_start sprite_load
sprite_load:
	push {r4,r5,lr}
	ldrb r3, [r5,#oObjectHeader_Flags]
	mov r4, #8
	bic r3, r4
	strb r3, [r5,#oObjectHeader_Flags]
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r5, r5, r3
	push {r0-r2}
	lsl r0, r1, #8
	orr r0, r2
	bl lookupValueForIdInTableAt_200DCA0_8002986
	pop {r1-r3}
	tst r0, r0
	beq loc_8002708
	b loc_8002716
loc_8002708:
	ldr r4, off_8002724 // =SpritePointersList
	ldr r4, [r4,r2]
	lsl r3, r3, #2
	ldr r0, [r4,r3]
	cmp r0, #0
	bge loc_8002716
	ldr r0, sprite8002728 // =spriteWhiteDot
loc_8002716:
	push {r1}
	bl sprite_initialize // (void *a1) -> void
	pop {r1}
	strb r1, [r5,#oObjectSprite_Unk_03]
	pop {r4,r5,pc}
	.balign 4, 0
off_8002724:
	.word SpritePointersList
sprite8002728:
	.word spriteWhiteDot
	thumb_func_end sprite_load

// (void *a1) -> void
// symdb: Resets an object's sprite state — zeroes animation/position/timer fields, invalidates the current frame, and sets the default 8x8 cell size.
// symdb: void sprite_init(u32 firstResource /* r0, sprite resource id/base */, SpriteObj* obj /* r5 */);
// symdb: returns c/v from r0+4
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_initialize.yaml
	thumb_local_start
sprite_initialize:
	add r0, #4
	str r0, [r5,#oObjectSprite_Unk_18]
	mov r0, #0
	strb r0, [r5,#oObjectSprite_Unk_03]
	strb r0, [r5,#oObjectSprite_Unk_00]
	str r0, [r5,#oObjectSprite_Unk_24]
	strb r0, [r5,#oObjectSprite_Unk_04]
	strh r0, [r5,#oObjectSprite_Unk_0a]
	strh r0, [r5,#oObjectSprite_Unk_06]
	str r0, [r5,#oObjectSprite_Unk_2c]
	strh r0, [r5,#oObjectSprite_Unk_10]
	strh r0, [r5,#oObjectSprite_Unk_12]
	strb r0, [r5,#oObjectSprite_Unk_14]
	strb r0, [r5,#oObjectSprite_Unk_05]
	str r0, [r5,#oObjectSprite_Unk_30]
	str r0, [r5,#oObjectSprite_Unk_34]
	mvn r0, r0
	str r0, [r5,#oObjectSprite_Unk_28]
	mov r0, #8
	strb r0, [r5,#oObjectSprite_Unk_15]
	mov r0, #8
	strh r0, [r5,#oObjectSprite_Unk_16]
	mov pc, lr
	thumb_func_end sprite_initialize

// (int a1) -> void
// symdb: Initializes the mugshot sprite for a given portrait index and flags the target sprite struct as loaded (0x80 at +0x16).
// symdb: void sprite_loadMugshot_800275A(int mugshotIndex /* r0 */, struct *spriteState /* r5 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/spriteLoadMugshot_800275A.yaml
	thumb_func_start spriteLoadMugshot_800275A
spriteLoadMugshot_800275A:
	push {lr}
	lsl r0, r0, #2
	ldr r1, off_800276C // =mugshotSpritePtrs
	ldr r0, [r0,r1]
	bl sprite_initialize // (void *a1) -> void
	mov r0, #0x80
	strh r0, [r5,#0x16]
	pop {pc}
	.balign 4, 0
off_800276C:
	.word mugshotSpritePtrs
	thumb_func_end spriteLoadMugshot_800275A

// (int a1, int a2) -> void
	thumb_func_start initGuiSprite_8002770
initGuiSprite_8002770:
	mov r2, #0x80
	b loc_8002776
loc_8002774:
	mov r2, #0
loc_8002776:
	push {r4-r6,lr}
	mov r6, r2
	mov r4, r1
	add r5, #0x20
	lsl r0, r0, #2
	ldr r1, off_8002798 // =guiSpritePtrs
	ldr r0, [r0,r1]
	cmp r0, #0
	bge loc_800278A
	mov r0, r4
loc_800278A:
	bl sprite_initialize // (void *a1) -> void
	strb r6, [r5,#3]
	mov r0, #0x80
	strh r0, [r5,#0x16]
	pop {r4-r6,pc}
	.balign 4, 0
off_8002798:
	.word guiSpritePtrs
	thumb_func_end initGuiSprite_8002770

	thumb_local_start
sub_800279C:
	push {r5,lr}
	add r5, #0x20
	lsl r0, r0, #2
	ldr r1, off_80027B0 // =mugshotSpritePtrs
	ldr r0, [r0,r1]
	bl sprite_initialize // (void *a1) -> void
	mov r0, #0x80
	strh r0, [r5,#0x16]
	pop {r5,pc}
	.balign 4, 0
off_80027B0:
	.word mugshotSpritePtrs
	thumb_func_end sub_800279C

// symdb: Writes 0x1 to the render-flush latch at EWRAM 0x0200F350, signalling that the next render-flush pass should execute.
// symdb: (lr = caller's return address) -> r0 = 0x0200F350, r1 = 0x1 (trashed); no other side effects
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sprite_setRenderFlushState_80027B4.yaml
	thumb_func_start sprite_setRenderFlushState_80027B4
sprite_setRenderFlushState_80027B4:
	ldr r0, off_80027BC // =dword_200F350
	ldr r1, dword_80027C0 // =0x1
	str r1, [r0]
	mov pc, lr
	.balign 4, 0
off_80027BC:
	.word dword_200F350
dword_80027C0:
	.word 0x1
	thumb_func_end sprite_setRenderFlushState_80027B4

// symdb: initialises a small graphics/fade state struct used by the battle fade pipeline
// symdb: () -> r0 = 0x32f ; side effects: writes [0x20098A8] = 0x0C, [0x20098A9] = 0, [0x20098AA] = 0x32F
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sprite_initBattleFadeGfxState_80027C4.yaml
	thumb_func_start sprite_initBattleFadeGfxState_80027C4
sprite_initBattleFadeGfxState_80027C4:
	ldr r1, off_8002804 // =byte_20098A8
	mov r0, #0
	strb r0, [r1,#0x1] // (byte_20098A9 - 0x20098a8)
	mov r0, #0xc
	strb r0, [r1]
	ldr r0, dword_8002808 // =0x32f
	strh r0, [r1,#0x2] // (word_20098AA - 0x20098a8)
	mov pc, lr
	thumb_func_end sprite_initBattleFadeGfxState_80027C4

// symdb: Initializes the palette-DMA transfer task state at byte_20098A8, setting entry size 4, entry count 10, and a halfword transfer length of 0x2FF.
// symdb: void sub_80027D4(void)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/palette_InitTransferState_80027D4.yaml
	thumb_func_start palette_InitTransferState_80027D4
palette_InitTransferState_80027D4:
	ldr r1, off_8002804 // =byte_20098A8
	mov r0, #4
	strb r0, [r1,#0x1] // (byte_20098A9 - 0x20098a8)
	mov r0, #0xa
	strb r0, [r1]
	ldr r0, dword_800280C // =0x2ff
	strh r0, [r1,#0x2] // (word_20098AA - 0x20098a8)
	mov pc, lr
	thumb_func_end palette_InitTransferState_80027D4

	thumb_func_start sub_80027E4
sub_80027E4:
	ldr r1, off_8002804 // =byte_20098A8
	mov r0, #4
	strb r0, [r1,#0x1] // (byte_20098A9 - 0x20098a8)
	mov r0, #8
	strb r0, [r1]
	ldr r0, byte_8002810 // =0xff
	strh r0, [r1,#0x2] // (word_20098AA - 0x20098a8)
	mov pc, lr
	thumb_func_end sub_80027E4

	thumb_func_start sub_80027F4
sub_80027F4:
	ldr r1, off_8002804 // =byte_20098A8
	mov r0, #0
	strb r0, [r1,#0x1] // (byte_20098A9 - 0x20098a8)
	mov r0, #0x10
	strb r0, [r1]
	ldr r0, byte_8002810 // =0xff
	strh r0, [r1,#0x2] // (word_20098AA - 0x20098a8)
	mov pc, lr
	.balign 4, 0
off_8002804:
	.word byte_20098A8
dword_8002808:
	.word 0x32F
dword_800280C:
	.word 0x2FF
byte_8002810:
	.byte 0xFF, 0x2, 0x0, 0x0, 0xFF, 0x2, 0x0, 0x0
	thumb_func_end sub_80027F4

// symdb: Copy the sprite's 16-colour palette into its slot of the sprite palette buffer byte_3001550 (slot = high nibble of byte 0x15), applying the colour effect in halfword 6.
// symdb: (r5 = sprite) -> source = field 0x34, or [[0x1C] + 4] + 4 + [0x18]; skip (byte 4 + byte 5) *
// symdb: 0x20 bytes of tiles; copy 0x20 bytes to byte_3001550 + slot * 0x20; halfword 6 != 0:
// symdb: palette_addOrSubtractColor(colour = bits 0-14, add/subtract = bit 15, 0x20 bytes)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_loadPalette_8002818.yaml
	thumb_func_start sprite_loadPalette_8002818
sprite_loadPalette_8002818:
	push {lr}
	ldr r0, [r5,#0x34]
	tst r0, r0
	bne loc_800282A
	ldr r0, [r5,#0x1c]
	ldr r0, [r0,#4]
	add r0, #4
	ldr r1, [r5,#0x18]
	add r0, r0, r1
loc_800282A:
	ldrb r1, [r5,#4]
	ldrb r2, [r5,#5]
	add r1, r1, r2
	lsl r1, r1, #5
	add r0, r0, r1
	ldrb r1, [r5,#0x15]
	lsr r1, r1, #4
	ldr r3, off_8002868 // =byte_3001550
	lsl r1, r1, #5
	add r3, r3, r1
	mov r6, #0
loc_8002840:
	ldr r2, [r0,r6]
	str r2, [r3,r6]
	add r6, #4
	cmp r6, #0x20
	blt loc_8002840
	ldrh r7, [r5,#6]
	tst r7, r7
	beq locret_8002862
	lsl r0, r7, #0x11
	lsr r0, r0, #0x11
	lsr r2, r7, #0xf
	lsl r2, r2, #2
	mov r6, #0x20
	mov r7, r3
	ldr r1, off_8002864 // =palette_addOrSubtractColor+1
	mov lr, pc
	bx r1
locret_8002862:
	pop {pc}
	.balign 4, 0
off_8002864:
	.word palette_addOrSubtractColor+1
off_8002868:
	.word byte_3001550
	thumb_func_end sprite_loadPalette_8002818

// symdb: Resets the sprite palette count at 0x0200F340 (dword_200F340) to 0 after it's been recorded into byte_200F389 by sprite_recordPaletteCount_80028C0.
// symdb: () -> r0 = 0x0200F340 ; no return value to caller (only r0/r1 are clobbered)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sprite_resetPaletteCount_800286C.yaml
	thumb_func_start sprite_resetPaletteCount_800286C
sprite_resetPaletteCount_800286C:
	ldr r0, off_80028CC // =dword_200F340
	mov r1, #0
	str r1, [r0]
	mov pc, lr
	thumb_func_end sprite_resetPaletteCount_800286C

// symdb: Ensures an object's current animation frame's tile graphics are loaded into its VRAM slot, queueing a transfer only when the frame changed.
// symdb: void sprite_loadAnimFrameTiles_8002874(r5: AnimState *state); // preserves r4-r7, clobbers
// symdb: r0-r2/r3/lr, returns flags C/V from the frame-equality compare (or from
// symdb: QueueEightWordAlignedGFXTransfer on the upload path)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_loadAnimFrameTiles_8002874.yaml
	thumb_func_start sprite_loadAnimFrameTiles_8002874
sprite_loadAnimFrameTiles_8002874:
	push {r5,lr}
	ldr r2, [r5,#0x24]
	ldr r0, [r5,#0x1c]
	ldr r0, [r0]
	ldr r1, [r5,#0x18]
	add r0, r0, r1
	cmp r0, r2
	beq locret_8002896
	str r0, [r5,#0x24]
	ldr r2, [r0]
	add r0, #4
	ldr r1, dword_8002898 // =0x6010000
	ldrh r3, [r5,#8]
	lsl r3, r3, #5
	add r1, r1, r3
	bl QueueEightWordAlignedGFXTransfer // (queued_src: *const (), mut_queued_dest: *mut (), queued_size: u32) -> ()
locret_8002896:
	pop {r5,pc}
	.balign 4, 0
dword_8002898:
	.word 0x6010000
	thumb_func_end sprite_loadAnimFrameTiles_8002874

// symdb: Clears the sprite object counter and marks the whole 0x388-entry object table at dword_200A890 as unused (0xFFFFFFFF), likely during sprite subsystem init/reset.
// symdb: void sprite_initObjectPool_800289C(int unused_r3); // r3 passed in but preserved/unused; returns
// symdb: flags from WordFill (v set, nz/c clobbered), r2 clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_resetObjVars_800289C.yaml
	thumb_func_start sprite_resetObjVars_800289C
sprite_resetObjVars_800289C:
	push {lr}
	ldr r1, off_80028B4 // =dword_20093A8
	mov r0, #0
	str r0, [r1]
	ldr r0, off_80028B8 // =dword_200A890
	ldr r1, off_80028BC // =0x388
	mov r2, #0
	mvn r2, r2
	bl WordFill
	pop {pc}
	.balign 4, 0
off_80028B4:
	.word dword_20093A8
off_80028B8:
	.word dword_200A890
off_80028BC:
	.word 0x388
	thumb_func_end sprite_resetObjVars_800289C

// symdb: Record the sprite palette count (dword_200F340) in slot r0 of byte_200F389, after each sprite group is queued.
// symdb: (r0 = slot) -> byte_200F389[r0] = (u8)dword_200F340; r1 = dword_200F340, r2 = &byte_200F389
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sub_80028C0.yaml
	thumb_func_start sub_80028C0
sub_80028C0:
	ldr r1, off_80028CC // =dword_200F340
	ldr r1, [r1]
	ldr r2, off_80028D0 // =byte_200F389
	strb r1, [r2,r0]
	mov pc, lr
	.balign 4, 0
off_80028CC:
	.word dword_200F340
off_80028D0:
	.word byte_200F389
	thumb_func_end sub_80028C0

// symdb: Initializes the 0x50-byte uncompressed-sprite work block at byte_200DCA0, recording the sprite data pointer and pre-filling its tables before a sprite is decompressed into it.
// symdb: void resetUncompSpriteWorkBlock_80028d4(const void *spriteData /* r0 */); // preserves r3, r5;
// symdb: r2/r3/r5 and carry/overflow read back by callers (r2 ends as 0xFF, flags from the last ByteFill)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/initUncompSpriteState_80028d4.yaml
	thumb_func_start initUncompSpriteState_80028d4
initUncompSpriteState_80028d4: // (a0: *const ?) -> ()
	push {r5,lr}
	ldr r5, off_8002BF0 // =byte_200DCA0

	push {r0}

	// memBlock
	mov r0, r5
	// size
	mov r1, #0x50
	bl ZeroFillByWord // (mut_mem: *mut (), num_bytes: usize) -> ()

	pop {r0}

	str r0, [r5,#0x4c] // (dword_200DCEC - 0x200dca0)

	mov r0, r5
	add r0, #4
	mov r1, #0x18
	mov r2, #0x80
	lsl r2, r2, #0x18
	mvn r2, r2
	lsr r2, r2, #0x10
	bl HalfwordFill

	mov r0, r5
	// mem
	add r0, #0x1c
	// byteCount
	mov r1, #0x30
	// byte
	mov r2, #0xff
	bl ByteFill // (u8 *mem, int byteCount, u8 byte) -> void

	pop {r5,pc}
	thumb_func_end initUncompSpriteState_80028d4

	// Load the sprite tilesets and palettes according to the map group's
	// sprite_load_data_struct list (e.g. byte_804E6AC).
	// Disabling this causes some objects to become white dots. (e.g. Welcome to the NetCafe in Central Area 1. See byte_8071BC0.)
	thumb_func_start uncompSprite_8002906
uncompSprite_8002906: // (sprite_load_data: *const SpriteLoadData) -> bool
	push {r4-r7,lr}
	mov r1, r8
	mov r2, r9
	push {r1,r2}

	ldr r5, off_8002BF0 // =byte_200DCA0

	ldr r1, [r5,#0x4c] // (dword_200DCEC - 0x200dca0)

	ldr r4, off_8002BC0 // =SpritePointersList
	ldr r6, dword_8002BC4 // =0x2040000
	mov r7, r0

.loadNextSprite
	ldrb r0, [r7,#oSpriteLoadData_SpriteTypeOffset]
	cmp r0, #0xff
	beq .doneLoadingSprites

	// Find the entry from SpritePointersList, putting its address into r2.
	ldrb r3, [r7,#oSpriteLoadData_SpriteIndex]
	lsl r3, r3, #2
	ldr r2, [r4,r0]
	ldr r2, [r2,r3]
	// Remove the SPRITE_IS_COMPRESSED flag.
	lsl r2, r2, #1
	lsr r2, r2, #1

	mov r8, r2
	ldr r2, [r2]

	lsl r0, r0, #8
	lsr r3, r3, #2
	orr r0, r3
	lsr r2, r2, #8
	add r3, r1, r2
	cmp r3, r6
	bge loc_800297C
  
	mov r9, r0
	ldrb r0, [r5]
	cmp r0, #0xc
	mov r0, r9
	bge loc_800297C

	push {r7}

	ldrb r3, [r5]
	lsl r7, r3, #1
	add r7, #4
	strh r0, [r5,r7]

	lsl r7, r3, #2
	add r7, #0x1c
	add r1, #4
	str r1, [r5,r7]

	// dest
	sub r1, #4
	add r3, #1
	strb r3, [r5]
	push {r1,r2,r4-r6}
	// src
	mov r0, r8
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()

	pop {r1,r2,r4-r6}
	add r1, r1, r2
	str r1, [r5,#0x4c]
	pop {r7}

	add r7, #oSpriteLoadData_Size
	b .loadNextSprite
.doneLoadingSprites
	mov r0, #TRUE
	pop {r1,r2}
	mov r8, r1
	mov r9, r2
	pop {r4-r7,pc}
loc_800297C:
	mov r0, #FALSE
	pop {r1,r2}
	mov r8, r1
	mov r9, r2
	pop {r4-r7,pc}
	thumb_func_end uncompSprite_8002906

// symdb: Looks up an id in a 12-entry table in IWRAM at byte_200DCA0 and returns the matching entry's 32-bit payload, or 0 if the id is not found.
// symdb: u32 lookupValueForIdInTableAt_200DCA0(u32 id /* r0 */); returns payload u32 or 0; r5 preserved
// symdb: (also used internally as the table pointer), r1/r2 scratch, flags clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/lookupValueForIdInTableAt_200DCA0_8002986.yaml
	thumb_local_start
lookupValueForIdInTableAt_200DCA0_8002986:
	push {r5,lr}
	ldr r5, off_8002BF0 // =byte_200DCA0
	mov r2, #0
loc_800298C:
	lsl r1, r2, #1
	add r1, #4
	ldrh r1, [r5,r1]
	cmp r0, r1
	bne loc_800299E
	lsl r1, r2, #2
	add r1, #0x1c
	ldr r0, [r5,r1]
	pop {r5,pc}
loc_800299E:
	add r2, #1
	cmp r2, #0xc
	blt loc_800298C
	mov r0, #0
	pop {r5,pc}
	thumb_func_end lookupValueForIdInTableAt_200DCA0_8002986

	thumb_func_start decompSprites_80029A8
decompSprites_80029A8:
	push {r4-r7,lr}
	mov r1, r8
	mov r2, r9
	mov r3, r12
	push {r1-r3}
	ldr r5, off_8002BF0 // =byte_200DCA0
	ldr r1, [r5,#0x4c] // (dword_200DCEC - 0x200dca0)
	ldr r4, off_8002BC0 // =SpritePointersList
	ldr r6, off_8002BC8 // =dword_2033000
	mov r7, r0
loc_80029BC:
	ldrb r0, [r7]
	mov r2, #0xf0
	and r0, r2
	cmp r0, #0xf0
	beq loc_8002A4C
	cmp r0, #0
	beq loc_8002A48
	ldrb r0, [r7,#2]
	ldrb r2, [r7,#3]
	lsl r2, r2, #0x1f
	lsr r2, r2, #0x17
	add r0, r0, r2
	push {r1}
	bl enemy_getArmPosition_800F26C
	lsl r0, r0, #8
	orr r0, r1
	pop {r1}
	mov r3, r5
	add r3, #4
	mov r9, r1
	mov r2, #0
loc_80029E8:
	ldrh r1, [r3,r2]
	cmp r0, r1
	mov r1, r9
	beq loc_8002A48
	add r2, #2
	cmp r2, #0x18
	blt loc_80029E8
	mov r1, r9
	lsl r2, r0, #0x18
	lsr r2, r2, #0x16
	lsr r3, r0, #8
	ldr r3, [r4,r3]
	ldr r2, [r3,r2]
	cmp r2, #0
	bge loc_8002A48
	lsl r2, r2, #1
	lsr r2, r2, #1
	mov r8, r2
	ldr r2, [r2]
	lsr r2, r2, #8
	add r3, r1, r2
	cmp r3, r6
	bge loc_8002A58
	mov r12, r0
	ldrb r0, [r5]
	cmp r0, #0xc
	mov r0, r12
	bge loc_8002A58
	push {r7}
	ldrb r3, [r5]
	lsl r7, r3, #1
	add r7, #4
	strh r0, [r5,r7]
	lsl r7, r3, #2
	add r7, #0x1c
	add r1, #4
	str r1, [r5,r7]
	// dest
	sub r1, #4
	add r3, #1
	strb r3, [r5]
	push {r1,r2,r4-r6}
	// src
	mov r0, r8
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()
	pop {r1,r2,r4-r6}
	add r1, r1, r2
	str r1, [r5,#0x4c]
	pop {r7}
loc_8002A48:
	add r7, #4
	b loc_80029BC
loc_8002A4C:
	mov r0, #1
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
loc_8002A58:
	mov r0, #0
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
	thumb_func_end decompSprites_80029A8

	thumb_func_start sprite_decompress
sprite_decompress:
	push {r4-r7,lr}
	lsl r0, r0, #8
	orr r0, r1
	mov r1, r8
	mov r2, r9
	mov r3, r12
	push {r1-r3}
	ldr r5, off_8002BF0 // =byte_200DCA0
	ldr r1, [r5,#0x4c] // (dword_200DCEC - 0x200dca0)
	ldr r4, off_8002BC0 // =SpritePointersList
	ldr r6, off_8002BC8 // =dword_2033000
	lsl r2, r0, #0x18
	lsr r2, r2, #0x16
	lsr r3, r0, #8
	ldr r3, [r4,r3]
	ldr r2, [r3,r2]
	cmp r2, #0
	bge loc_8002AD2
	lsl r2, r2, #1
	lsr r2, r2, #1
	mov r8, r2
	ldr r2, [r2]
	lsr r2, r2, #8
	add r3, r1, r2
	cmp r3, r6
	bge loc_8002AD2
	mov r12, r0
	ldrb r0, [r5]
	cmp r0, #0xc
	mov r0, r12
	bge loc_8002AD2
	ldrb r3, [r5]
	lsl r7, r3, #1
	add r7, #4
	strh r0, [r5,r7]
	lsl r7, r3, #2
	add r7, #0x1c
	add r1, #4
	str r1, [r5,r7]
	// dest
	sub r1, #4
	add r3, #1
	strb r3, [r5]
	push {r1,r2}
	// src
	mov r0, r8
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()
	pop {r1,r2}
	add r1, r1, r2
	str r1, [r5,#0x4c] // (dword_200DCEC - 0x200dca0)
	mov r0, #1
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
loc_8002AD2:
	mov r0, #0
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
	thumb_func_end sprite_decompress

	thumb_func_start sub_8002ADE
sub_8002ADE:
	push {r4-r7,lr}
	ldr r5, off_8002BF0 // =byte_200DCA0
	ldr r4, off_8002BC0 // =SpritePointersList
	ldrb r3, [r5]
	cmp r3, #0
	beq locret_8002B2E
	sub r3, #1
	lsl r7, r3, #1
	add r7, #4
	ldrh r0, [r5,r7]
	lsl r2, r0, #0x18
	lsr r2, r2, #0x16
	lsr r3, r0, #8
	ldr r3, [r4,r3]
	ldr r2, [r3,r2]
	cmp r2, #0
	bge locret_8002B2E
	lsl r2, r2, #1
	lsr r2, r2, #1
	mov r8, r2
	ldr r2, [r2]
	ldr r0, [r5,#0x4c] // (dword_200DCEC - 0x200dca0)
	lsr r2, r2, #8
	sub r0, r0, r2
	str r0, [r5,#0x4c] // (dword_200DCEC - 0x200dca0)
	ldrb r3, [r5]
	sub r3, #1
	strb r3, [r5]
	lsl r7, r3, #1
	add r7, #4
	mov r0, #0xff
	mov r1, #0x7f
	lsl r1, r1, #8
	orr r0, r1
	strh r0, [r5,r7]
	lsl r7, r3, #2
	add r7, #0x1c
	mov r0, #0
	mvn r0, r0
	str r0, [r5,r7]
locret_8002B2E:
	pop {r4-r7,pc}
	thumb_func_end sub_8002ADE

	thumb_func_start sprite_decompressTemp
// only one sprite can be decompressed with this function at a time
// e.g. certain objects in dimming attacks
sprite_decompressTemp:
	push {r4-r7,lr}
	lsl r0, r0, #8
	orr r0, r1
	mov r1, r8
	mov r2, r9
	mov r3, r12
	push {r1-r3}
	ldr r5, off_8002BF0 // =byte_200DCA0
	bl sprite_clearSlot_8002BCC
	ldr r1, [r5,#0x4c] // (dword_200DCEC - 0x200dca0)
	ldr r4, off_8002BC0 // =SpritePointersList
	ldr r6, off_8002BC8 // =dword_2033000
	mov r3, r5
	add r3, #4
	mov r9, r1
	mov r2, #0
loc_8002B52:
	ldrh r1, [r3,r2]
	cmp r0, r1
	mov r1, r9
	beq loc_8002BB2
	add r2, #2
	cmp r2, #0x18
	blt loc_8002B52
	mov r1, r9
	lsl r2, r0, #0x18
	lsr r2, r2, #0x16
	lsr r3, r0, #8
	ldr r3, [r4,r3]
	ldr r2, [r3,r2]
	cmp r2, #0
	bge loc_8002BB2
	lsl r2, r2, #1
	lsr r2, r2, #1
	mov r8, r2
	ldr r2, [r2]
	lsr r2, r2, #8
	add r3, r1, r2
	cmp r3, r6
	bge loc_8002BB2
	mov r12, r0
	ldrb r0, [r5]
	cmp r0, #0xc
	mov r0, r12
	bge loc_8002BB2
	ldrb r3, [r5]
	lsl r7, r3, #1
	add r7, #4
	strh r0, [r5,r7]
	lsl r7, r3, #2
	add r7, #0x1c
	add r1, #4
	str r1, [r5,r7]
	// dest
	sub r1, #4
	push {r1,r2}
	// src
	mov r0, r8
	bl SWI_LZ77UnCompReadNormalWrite8bit // (src: *const LZ77Compressed<T>, mut_dest: *mut T -> ()
	pop {r1,r2}
	mov r0, #1
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
loc_8002BB2:
	mov r0, #0
	pop {r1-r3}
	mov r8, r1
	mov r9, r2
	mov r12, r3
	pop {r4-r7,pc}
	.balign 4, 0
off_8002BC0:
	.word SpritePointersList
dword_8002BC4:
	.word 0x2040000
off_8002BC8:
	.word dword_2033000
	thumb_func_end sprite_decompressTemp

// symdb: Reset a sprite slot by hiding its OAM attribute (0x7FFF) and marking its link field as free (-1).
// symdb: void sub_8002BCC(void /* r5 = sprite base */);  /* inputs: r5, lr; outputs: r0, r5; clobbers:
// symdb: nz, c, v; preserved: r0-r7 */
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_clearSlot_8002BCC.yaml
	thumb_local_start
sprite_clearSlot_8002BCC:
	push {r0-r7,lr}
	ldrb r3, [r5]
	lsl r7, r3, #1
	add r7, #4
	mov r0, #0xff
	mov r1, #0x7f
	lsl r1, r1, #8
	orr r0, r1
	strh r0, [r5,r7]
	lsl r7, r3, #2
	add r7, #0x1c
	mov r0, #0
	mvn r0, r0
	str r0, [r5,r7]
	pop {r0-r7,pc}
	thumb_func_end sprite_clearSlot_8002BCC

	thumb_local_start
sub_8002BEA:
	push {r4-r7,lr}
	pop {r4-r7,pc}
	.byte 0, 0
off_8002BF0:
	.word byte_200DCA0
	.word dword_8002BF8
dword_8002BF8:
	.word 0x4E550600
DebugStrSprite_8002BFC: .ascii "COMP\n"
	.ascii "STR:%8x\n"
	.ascii "END:%8x\n"
	.asciz "SIZ:%X/%X\n"
	.word unk_2037800
	.word 0x2040000
	thumb_func_end sub_8002BEA

	thumb_func_start sprite_setScaleParameters
sprite_setScaleParameters:
	push {r5,lr}
	push {r0-r2}
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r5, r5, r3
	b loc_8002C36
	push {r5,lr}
	push {r0-r2}
loc_8002C36:
	ldrb r0, [r5,#oObjectSprite_Unk_11]
	mov r1, #3
	tst r0, r1
	beq loc_8002C4E
	ldrb r3, [r5,#oObjectSprite_Unk_13]
	mov r1, #0x3e
	and r3, r1
	lsr r3, r3, #1
	pop {r0-r2}
	bl sprite_setAffineTransform_802FE7A
	pop {r5,pc}
loc_8002C4E:
	pop {r0-r2}
	pop {r5,pc}
	thumb_func_end sprite_setScaleParameters

	thumb_func_start sprite_setObjWindowMode
sprite_setObjWindowMode:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r1, [r3,#oObjectSprite_Unk_11]
	mov r0, #0xc
	bic r1, r0
	mov r0, #8
	orr r1, r0
	strb r1, [r3,#oObjectSprite_Unk_11]
	mov pc, lr
	thumb_func_end sprite_setObjWindowMode

	thumb_func_start sprite_disableObjWindowMode
sprite_disableObjWindowMode:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r1, [r3,#oObjectSprite_Unk_11]
	mov r0, #0xc
	bic r1, r0
	strb r1, [r3,#oObjectSprite_Unk_11]
	mov pc, lr
	thumb_func_end sprite_disableObjWindowMode

	thumb_func_start sprite_setAlpha_8002c7a
// presumably to have a sprite blend in with the background (alpha blending)
// but the bit to enable alpha blending is not set
// and thus this call does nothing
// original name: sprite_setMosaicScalingParameters_8002c7a
// symdb: Trampoline that sets a sprite object to alpha-blend (effect mode 4) and programs the global blend coefficients from the given alpha level.
// symdb: void sprite_setAlpha_8002c7a(u8 alpha /*r0*/, sprite object in r5, toolkit in r10); tail-calls
// symdb: sprite_setAlpha(r0=alpha, r2=4, r5=object); returns r0=0x3f, r1/r2/r3 and nz/c/v from callee; r7
// symdb: preserved
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_setAlpha_8002c7a.yaml
sprite_setAlpha_8002c7a:
	mov r2, #4
	b sprite_setAlpha

	thumb_func_start sprite_setAlpha
// original name: sprite_setMosaicScalingParameters
sprite_setAlpha:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	push {r7}
	ldrb r1, [r3,#oObjectSprite_Unk_11]
	mov r7, #0xc
	bic r1, r7
	orr r1, r2
	strb r1, [r3,#oObjectSprite_Unk_11]
	pop {r7}
	mov r3, r10
	ldr r3, [r3,#oToolkit_Unk2009740_Ptr]
	ldrb r1, [r3]
	mov r2, #0xc0
	bic r1, r2
	mov r2, #0
	orr r1, r2
	strb r1, [r3]
	strb r0, [r3,#2]
	sub r0, #0x10
	neg r0, r0
	strb r0, [r3,#3]
	mov r0, #0
	strb r0, [r3]
	mov r0, #0x3f
	strb r0, [r3,#1]
	mov pc, lr
	thumb_func_end sprite_setAlpha
	thumb_func_end sprite_setAlpha_8002c7a

	thumb_local_start
sub_8002CB6:
	mov r0, #0xc
	b loc_8002CBA
loc_8002CBA:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r1, [r3,#0x11]
	bic r1, r0
	mov r2, #4
	orr r1, r2
	strb r1, [r3,#0x11]
	mov pc, lr
	thumb_func_end sub_8002CB6

	thumb_func_start sprite_disableAlpha
sprite_disableAlpha:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r1, [r3,#oObjectSprite_Unk_11]
	mov r0, #0xc
	bic r1, r0
	strb r1, [r3,#oObjectSprite_Unk_11]
	mov pc, lr
	thumb_func_end sprite_disableAlpha

// symdb: Reads the mosaic/scaling parameters for an object's attached sprite, returning the flag bits for that sprite and the current global scaling parameter from the toolkit.
// symdb: u8 sprite_getMosaicScalingParameters(ObjectHeader* obj /*r0*/, Toolkit* toolkit /*r10*/, u8*
// symdb: flagsOut /*r2*/); returns r0 = toolkit->Unk2009740_Ptr[2], sets r2 = objSprite->Unk_11 & 0x0C;
// symdb: clobbers r1, r3 and flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_getMosaicScalingParameters.yaml
	thumb_func_start sprite_getMosaicScalingParameters
sprite_getMosaicScalingParameters:
	ldrb r3, [r0,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r0
	ldrb r1, [r3,#oObjectSprite_Unk_11]
	mov r2, #0xc
	and r2, r1
	mov r3, r10
	ldr r3, [r3,#oToolkit_Unk2009740_Ptr]
	ldrb r0, [r3,#2]
	mov pc, lr
	thumb_func_end sprite_getMosaicScalingParameters

	thumb_local_start
sub_8002CF6:
	ldrb r3, [r0,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r0
	ldrb r1, [r3,#0x11]
	mov r0, #4
	and r0, r1
	mov pc, lr
	thumb_func_end sub_8002CF6

	thumb_local_start
sub_8002D06:
	push {r5,lr}
	ldr r3, off_8002D10 // =sprite_projectAndCull+1
	mov lr, pc
	bx r3
	pop {r5,pc}
off_8002D10:
	.word sprite_projectAndCull+1
	thumb_func_end sub_8002D06

// symdb: Adjusts an object's sprite pointer to the nearest 16-byte-aligned scalable sprite data offset, then tail-jumps to a continuation routine that uses the scaled pointer.
// symdb: void sprite_makeScalable(void); // in: r5 = object ptr; out/clobbers: r5, r7, r0-r3, lr;
// symdb: clobbers: N,Z,C,V flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_makeScalable.yaml
	thumb_func_start sprite_makeScalable
sprite_makeScalable:
	push {r5,lr}
	ldrb r3, [r5,#oObjectHeader_SpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r5, r5, r3
	b loc_8002D22
	thumb_func_end sprite_makeScalable

	thumb_local_start
sub_8002D20:
	push {r5,lr}
loc_8002D22:
	ldrb r0, [r5,#oObjectSprite_Unk_11]
	mov r1, #3
	tst r1, r0
	bne loc_8002D4E
	bl battle_allocateActorIndex_802FE48
	cmp r0, #0xff
	beq loc_8002D4E
	ldrb r2, [r5,#oObjectSprite_Unk_11]
	mov r1, #3
	orr r2, r1
	strb r2, [r5,#oObjectSprite_Unk_11]
	push {r7}
	ldrb r7, [r5,#oObjectSprite_Unk_13]
	mov r1, #0x3e
	bic r7, r1
	lsl r0, r0, #1
	orr r7, r0
	strb r7, [r5,#oObjectSprite_Unk_13]
	pop {r7}
	mov r0, #1
	pop {r5,pc}
loc_8002D4E:
	mov r0, #0
	pop {r5,pc}
	thumb_func_end sub_8002D20

// symdb: Strips the "scalable" state from an object's sprite, clearing its scale bits and the matching sprite flag-word bit.
// symdb: void sprite_makeUnscalable(ObjectHeader* r5); clobbers r0-r3 and NZCV; preserves r5; flags are
// symdb: caller-visible (see quirks)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_makeUnscalable.yaml
	thumb_func_start sprite_makeUnscalable
sprite_makeUnscalable:
	push {r5,lr}
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r5, r5, r3
	b loc_8002D60
	push {r5,lr}
loc_8002D60:
	ldrb r0, [r5,#oObjectSprite_Unk_11]
	mov r1, #3
	tst r1, r0
	beq locret_8002D7E
	bic r0, r1
	strb r0, [r5,#oObjectSprite_Unk_11]
	ldrb r0, [r5,#oObjectSprite_Unk_13]
	mov r2, r0
	mov r1, #0x3e
	and r0, r1
	lsr r0, r0, #1
	bic r2, r1
	strb r2, [r5,#oObjectSprite_Unk_13]
	bl flags_clearFlagWordBit_802FE6A
locret_8002D7E:
	pop {r5,pc}
	thumb_func_end sprite_makeUnscalable

// (int pallete) -> void
// symdb: Store r0 (palette index) in byte 4 of the object's sprite struct.
// symdb: (r0 = palette, r5 = object header) -> sprite byte 4 = r0; r3 = sprite; flags of the address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_setPalette.yaml
	thumb_func_start sprite_setPalette
sprite_setPalette:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	strb r0, [r3,#oObjectSprite_Unk_04]
	mov pc, lr
	thumb_func_end sprite_setPalette

// symdb: Returns the palette ID byte stored in an object's sprite data, locating the sprite via the header's sprite-offset nibble.
// symdb: u8 sprite_getPalette(ObjectHeader* header /* r0 */); also returns r3 = pointer to the sprite
// symdb: data, clobbers NZCV
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_getPalette.yaml
	thumb_func_start sprite_getPalette
sprite_getPalette:
	ldrb r3, [r0,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r0
	ldrb r0, [r3,#oObjectSprite_Unk_04]
	mov pc, lr
	thumb_func_end sprite_getPalette

	thumb_local_start
sprite_setAnimationAlt:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	strb r0, [r3,#oObjectSprite_Unk_00]
	mov pc, lr
	thumb_func_end sprite_setAnimationAlt

// (u8 a1) -> void
// symdb: Sets the current animation index for an object's sprite slot by writing it into the slot's first byte.
// symdb: void sprite_setAnimation(u8 animIndex /*r0*/, ObjectHeader* obj /*r5*/)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_setAnimation.yaml
	thumb_func_start sprite_setAnimation
sprite_setAnimation:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	strb r0, [r3,#oObjectSprite_Unk_00]
	mov pc, lr
	thumb_func_end sprite_setAnimation

	thumb_func_start sprite_forceWhitePalette
sprite_forceWhitePalette:
	mov r1, #0xf0
	b sprite_setFinalPalette
sprite_setFinalPalette:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#oObjectSprite_Unk_15]
	mov r2, #0xf0
	bic r0, r2
	orr r0, r1
	strb r0, [r3,#oObjectSprite_Unk_15]
	mov pc, lr
	thumb_func_end sprite_forceWhitePalette

// symdb: Reads an object's sprite record via its VRAM tile offset and returns the sprite's final palette byte (masked to 0xF0).
// symdb: u8 sprite_getFinalPalette(void* objHeader /* r0 */); returns palette in r1 (value & 0xF0)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_getFinalPalette.yaml
	thumb_func_start sprite_getFinalPalette
sprite_getFinalPalette:
	ldrb r3, [r0,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r0
	ldrb r0, [r3,#oObjectSprite_Unk_15]
	mov r1, #0xf0
	and r1, r0
	mov pc, lr
	thumb_func_end sprite_getFinalPalette

// symdb: Clears the high nibble of an object's sprite final-palette byte, leaving only the low nibble.
// symdb: void sprite_clearFinalPalette(u32 objectHeader /* r5 */); returns: r1 = 0xf0, r3 = sprite
// symdb: pointer; flags: N,Z from BIC of masked byte (0..0xF), C,V preserved from header+offset ADD
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_clearFinalPalette.yaml
	thumb_func_start sprite_clearFinalPalette
sprite_clearFinalPalette:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#oObjectSprite_Unk_15]
	mov r1, #0xf0
	bic r0, r1
	strb r0, [r3,#oObjectSprite_Unk_15]
	mov pc, lr
	thumb_func_end sprite_clearFinalPalette

// symdb: Reads the current animation frame's rendering parameters (tile index, flip-disable flag, attribute byte) from an object's sprite data table.
// symdb: void sprite_getFrameParameters(ObjectHeader* header /* r5 */) — out: r0 = attribute byte
// symdb: (sprite+2, with 0xC0 flip bits cleared when flag byte nonzero), r1 = r2 = frame/tile index byte
// symdb: (sprite+0), r3 = sprite data address; flags out: c = 1, v = 0, nz per the flag byte at sprite+1.
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_getFrameParameters.yaml
	thumb_func_start sprite_getFrameParameters
sprite_getFrameParameters:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#oObjectSprite_Unk_02]
	ldrb r1, [r3,#oObjectSprite_Unk_01]
	cmp r1, #0
	beq loc_8002DFE
	mov r1, #0xc0
	bic r0, r1
loc_8002DFE:
	ldrb r1, [r3,#oObjectSprite_Unk_00]
	ldrb r2, [r3,#oObjectSprite_Unk_00]
	mov pc, lr
	thumb_func_end sprite_getFrameParameters

	thumb_func_start sub_8002E04
sub_8002E04:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#3]
	mov r1, #8
	and r0, r1
	mov pc, lr
	thumb_func_end sub_8002E04

// symdb: Set the sprite's OAM priority: bits 2-3 of sprite byte 0x15 = r0 (0-3).
// symdb: (r0 = priority, r5 = object header) -> byte 0x15 = (byte & ~0xC) | r0 << 2; r0 = r0 << 2, r1 =
// symdb: new byte, r2 = 0xC, r3 = sprite
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sprite_setPriority_8002E14.yaml
	thumb_func_start sprite_setPriority_8002E14
sprite_setPriority_8002E14:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	mov r2, #0xc
	ldrb r1, [r3,#oObjectSprite_Unk_15]
	bic r1, r2
	lsl r0, r0, #2
	orr r1, r0
	strb r1, [r3,#oObjectSprite_Unk_15]
	mov pc, lr
	thumb_func_end sprite_setPriority_8002E14

	thumb_local_start
sub_8002E2A:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	mov r1, #0xc
	ldrb r0, [r3,#0x15]
	and r0, r1
	lsr r0, r0, #2
	mov pc, lr
	thumb_func_end sub_8002E2A

// symdb: Turns on the shadow for an object's current sprite by setting the shadow bit and clearing the no-shadow bit in its sprite state byte.
// symdb: void sprite_enableShadow(Object* obj /* r5 */); returns r0 = new sprite state byte, r1 = 4, r3 =
// symdb: sprite struct address; N/Z from the stored byte, C/V left over from the address ADD
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_hasShadow.yaml
	thumb_func_start sprite_hasShadow
sprite_hasShadow:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#oObjectSprite_Unk_03]
	mov r1, #1
	orr r0, r1
	mov r1, #4
	bic r0, r1
	strb r0, [r3,#oObjectSprite_Unk_03]
	mov pc, lr
	thumb_func_end sprite_hasShadow

// symdb: Clears the shadow flag (and the bit-2 flag) in an object's sprite status byte, making the object's shadow stop rendering.
// symdb: void sprite_removeShadow(void *header /* r5 */) — returns r0 = updated sprite status byte, r1 =
// symdb: 4, r3 = sprite struct address; clobbers NZCV flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_removeShadow.yaml
	thumb_func_start sprite_removeShadow
sprite_removeShadow:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#oObjectSprite_Unk_03]
	mov r1, #1
	bic r0, r1
	mov r1, #4
	bic r0, r1
	strb r0, [r3,#oObjectSprite_Unk_03]
	mov pc, lr
	thumb_func_end sprite_removeShadow

	thumb_local_start
sub_8002E68:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldr r0, [r3,#0x1c]
	ldr r0, [r0]
	ldr r1, [r3,#0x18]
	add r0, r0, r1
	ldr r0, [r0]
	lsr r0, r0, #5
	mov pc, lr
	thumb_func_end sub_8002E68

	thumb_local_start
sub_8002E7E:
	ldrb r0, [r5]
	tst r0, r0
	beq loc_8002EA4
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	mov r2, #0xc
	ldrsh r1, [r3,r2]
	mov r2, #0xe
	ldrsb r2, [r3,r2]
	mov r0, #0x10
	lsl r0, r0, #4
	add r0, #0xff
	and r1, r0
	mov r0, #0xff
	and r2, r0
	mov r0, #1
	mov pc, lr
loc_8002EA4:
	mov r0, #0
	mov r1, #0
	mov r2, #0
	mov pc, lr
	thumb_func_end sub_8002E7E

	thumb_func_start sub_8002EAC
sub_8002EAC:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#oObjectSprite_Unk_16]
	mov r1, #2
	orr r0, r1
	strb r0, [r3,#oObjectSprite_Unk_16]
	mov pc, lr
	thumb_func_end sub_8002EAC

	thumb_local_start
sub_8002EBE:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#0x16]
	mov r1, #2
	bic r0, r1
	strb r0, [r3,#0x16]
	mov pc, lr
	thumb_func_end sub_8002EBE

// symdb: Stores a color-shader id into the sprite block selected by an object's high-nibble sprite index.
// symdb: void sprite_setColorShader(u16 shaderId /*r0*/, ObjectHeader* obj /*r5*/); returns r3 = address
// symdb: of the affected sprite block, sets nzcv from the final ADD
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_setColorShader.yaml
	thumb_func_start sprite_setColorShader
sprite_setColorShader:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	strh r0, [r3,#oObjectSprite_Unk_06]
	mov pc, lr
	thumb_func_end sprite_setColorShader

// symdb: Returns the 16-bit color/palette shader value stored in an object's sprite data.
// symdb: u16 sprite_getColorShader(ObjectHeader *header /* r0 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_getColorShader.yaml
	thumb_func_start sprite_getColorShader
sprite_getColorShader:
	ldrb r3, [r0,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r0
	ldrh r0, [r3,#oObjectSprite_Unk_06]
	mov pc, lr
	thumb_func_end sprite_getColorShader

// symdb: Resets an object's sprite color-shader/palette-effect halfword to zero, returning the sprite data pointer.
// symdb: void sprite_clearObjectColorShader(oObjectHeader* header /* r5 */); returns oObjectSprite* in
// symdb: r3, flags c/v set by the final ADD
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_zeroColorShader.yaml
	thumb_func_start sprite_zeroColorShader
sprite_zeroColorShader:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	mov r0, #0
	strh r0, [r3,#oObjectSprite_Unk_06]
	mov pc, lr
	thumb_func_end sprite_zeroColorShader

	thumb_func_start sprite_setMosaicSize
// r0 - mosaic width
// r1 - mosaic height
sprite_setMosaicSize:
	lsl r1, r1, #4
	orr r0, r1
	mov r2, #0x10
	b loc_8002F06
	mov r2, #0x10
	b loc_8002F06
loc_8002F02:
	tst r2, r2
	beq sprite_clearMosaic
loc_8002F06:
	tst r0, r0
	beq sprite_clearMosaic
	lsl r0, r0, #8
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r1, [r3,#oObjectSprite_Unk_11]
	orr r1, r2
	strb r1, [r3,#oObjectSprite_Unk_11]
	mov r3, r10
	ldr r3, [r3,#oToolkit_RenderInfoPtr]
	ldrh r1, [r3,#oRenderInfo_Unk_02]
	mov r2, #0xff
	lsl r2, r2, #8
	bic r1, r2
	orr r1, r0
	strh r1, [r3,#oRenderInfo_Unk_02]
	mov pc, lr
	thumb_func_end sprite_setMosaicSize

// symdb: Clears the mosaic bit (0x10) in an object's sprite flag byte, disabling the mosaic effect on that object's sprite.
// symdb: void sprite_clearMosaic(ObjectHeader* obj /* r5 */) — outputs r0 = 0x10 (mask), r1 = updated
// symdb: flag byte, r3 = sprite struct address, c/v set by the address computation, nz clobbered
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_clearMosaic.yaml
	thumb_func_start sprite_clearMosaic
sprite_clearMosaic:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r1, [r3,#oObjectSprite_Unk_11]
	mov r0, #0x10
	bic r1, r0
	strb r1, [r3,#oObjectSprite_Unk_11]
	mov pc, lr
	thumb_func_end sprite_clearMosaic

// symdb: Reads two sprite/object state values at once: bit 0x10 of the object's sprite Unk_11 flag byte into r2, and the high byte of the toolkit render info halfword at +2 into r0.
// symdb: void obj_getSpriteFlag10AndRenderInfoHigh(ObjectHeader* object /*r0*/, Toolkit* toolkit /*r10*/)
// symdb: -> u8 renderInfoHigh /*r0*/ + u8 flag10 /*r2*/; clobbers r1, r3 and flags
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/obj_getSpriteFlag10AndRenderInfoHigh_8002F3E.yaml
	thumb_func_start obj_getSpriteFlag10AndRenderInfoHigh_8002F3E
obj_getSpriteFlag10AndRenderInfoHigh_8002F3E:
	ldrb r3, [r0,#oObjectHeader_SpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r0
	ldrb r0, [r3,#oObjectSprite_Unk_11]
	mov r2, #0x10
	and r2, r0
	mov r3, r10
	ldr r3, [r3,#oToolkit_RenderInfoPtr]
	ldrh r0, [r3,#oRenderInfo_Unk_02]
	mov r1, #0xff
	bic r0, r1
	lsr r0, r0, #8
	mov pc, lr
	.hword 0x2000
	thumb_func_end obj_getSpriteFlag10AndRenderInfoHigh_8002F3E

// symdb: Set the sprite's flip bits (mask 0x30) in sprite bytes 0x13 and 0x16 from r0 (NPCs pass 1 when mirrored).
// symdb: (r0 = flip, r5 = object header) -> byte 0x13 bits 4-5 = r0 << 4, byte 0x16 bits 4-5 copied from
// symdb: it; r0 = 0x30, r1 = byte 0x16, r2 = flip bits, r3 = sprite
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_setFlip.yaml
	thumb_func_start sprite_setFlip
sprite_setFlip:
	ldrb r3, [r5,#oObjectHeader_SpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r2, [r3,#oObjectSprite_Unk_13]
	mov r1, #0x30
	bic r2, r1
	lsl r0, r0, #4
	orr r2, r0
	strb r2, [r3,#oObjectSprite_Unk_13]
	and r2, r1
	ldrb r1, [r3,#oObjectSprite_Unk_16]
	mov r0, #0x30
	bic r1, r0
	orr r1, r2
	strb r1, [r3,#oObjectSprite_Unk_16]
	mov pc, lr
	thumb_func_end sprite_setFlip

// symdb: Returns the flip value (0-3) stored in bits 4-5 of an object's sprite field Unk_16.
// symdb: u8 sprite_getFlip(ObjectHeader* header /* r0 */)
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_getFlip.yaml
	thumb_func_start sprite_getFlip
sprite_getFlip:
	ldrb r3, [r0,#oObjectHeader_SpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r0
	ldrb r0, [r3,#oObjectSprite_Unk_16]
	mov r1, #0x30
	and r0, r1
	lsr r0, r0, #4
	mov pc, lr
	thumb_func_end sprite_getFlip

// () -> void
	thumb_func_start sprite_noShadow
// shadow moves with sprite's Z
// symdb: Sets an object's sprite attribute flags so the sprite renders without a shadow.
// symdb: void sprite_setNoShadow(ObjectHeader* obj /* r5 */); returns r0 = updated attribute byte, r1 =
// symdb: 1, r3 = sprite record pointer; NZ set from the attribute byte, CV from the sprite address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_noShadow.yaml
sprite_noShadow:
	ldrb r3, [r5,#oObjectHeader_SpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#oObjectSprite_Unk_03]
	mov r1, #4
	orr r0, r1
	mov r1, #1
	bic r0, r1
	strb r0, [r3,#oObjectSprite_Unk_03]
	mov pc, lr
	thumb_func_end sprite_noShadow

// symdb: Stores a 32-bit value into field 0x2c of an object's sprite struct, whose offset is derived from the sprite ID nibble in the object header.
// symdb: void sprite_setUnk0x2c(u32 value /* r0 */, ObjectHeader* header /* r5 */); returns r3 = pointer
// symdb: to the object's sprite struct, flags from the address add
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_setUnk0x2c.yaml
	thumb_func_start sprite_setUnk0x2c
sprite_setUnk0x2c:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	str r0, [r3,#oObjectSprite_Unk_2c]
	mov pc, lr
	thumb_func_end sprite_setUnk0x2c

// symdb: Returns the word at offset 0x2c of an object's sprite record, locating the record via the sprite offset packed in the object header.
// symdb: word sprite_getUnk0x2c(ObjectHeader *r5); also sets carry (side effect of the address add),
// symdb: clobbers r3
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_getUnk0x2c.yaml
	thumb_func_start sprite_getUnk0x2c
sprite_getUnk0x2c:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldr r0, [r3,#oObjectSprite_Unk_2c]
	mov pc, lr
	thumb_func_end sprite_getUnk0x2c

	thumb_local_start
sub_8002FBE:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	mov r1, #0x80
	lsl r1, r1, #0x18
	lsr r1, r0
	ldr r0, [r3,#0x2c]
	orr r0, r1
	str r0, [r3,#0x2c]
	mov pc, lr
	thumb_func_end sub_8002FBE

	thumb_local_start
sub_8002FD4:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	mov r1, #0x80
	lsl r1, r1, #0x18
	lsr r1, r0
	ldr r0, [r3,#0x2c]
	bic r0, r1
	str r0, [r3,#0x2c]
	mov pc, lr
	.hword 0x2000
	thumb_func_end sub_8002FD4

// symdb: Writes a 32-bit value into field +0x30 of whichever 0x10-byte-aligned sub-structure of a scene/npc object is selected by the high nibble of byte +2.
// symdb: void object_writeSubstructField30(Object* obj /*r5*/, u32 value /*r0*/); // returns target
// symdb: address in r3 and sets flags via the ADDS used for the sub-struct offset
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/object_writeSubstructField30_8002FEC.yaml
	thumb_func_start object_writeSubstructField30_8002FEC
object_writeSubstructField30_8002FEC:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	str r0, [r3,#0x30]
	mov pc, lr
	thumb_func_end object_writeSubstructField30_8002FEC

	thumb_local_start
sub_8002FF8:
	mov r0, #0
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	str r0, [r3,#0x34]
	mov pc, lr
	thumb_func_end sub_8002FF8

	thumb_func_start sprite_setField0x3Bit5
sprite_setField0x3Bit5:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#oObjectSprite_Unk_03]
	mov r1, #0x20
	orr r0, r1
	strb r0, [r3,#oObjectSprite_Unk_03]
	mov pc, lr
	thumb_func_end sprite_setField0x3Bit5

	thumb_local_start
sub_8003018:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r0, [r3,#3]
	mov r1, #0x20
	bic r0, r1
	strb r0, [r3,#3]
	mov pc, lr
	thumb_func_end sub_8003018

	thumb_func_start sub_800302A
sub_800302A:
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r1, [r3,#oObjectSprite_Unk_16]
	mov r2, #0xc
	bic r1, r2
	mov r2, #2
	lsl r0, r2
	orr r1, r0
	strb r1, [r3,#oObjectSprite_Unk_16]
	ldrb r0, [r3,#oObjectSprite_Unk_03]
	mov r1, #0x40
	orr r0, r1
	strb r0, [r3,#oObjectSprite_Unk_03]
	mov pc, lr
	thumb_func_end sub_800302A

// symdb: Stores a 4-bit palette bank into the high nibble of byte +0x15 of one 0x10-byte sub-entry of an object, selected by the high nibble of the object's byte at +2.
// symdb: void sprite_setSubEntryPaletteBank(u32 paletteBank /* r0, 0-15 */, void *obj /* r5 */); sets
// symdb: NZ/C/V as side effects, returns r0 = paletteBank << 4, r1 = new byte value, r2 = 0xF0, r3 = sub-
// symdb: entry address
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_setSubEntryPaletteBank_800304A.yaml
	thumb_func_start sprite_setSubEntryPaletteBank_800304A
sprite_setSubEntryPaletteBank_800304A:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	ldrb r1, [r3,#0x15]
	mov r2, #0xf0
	bic r1, r2
	lsl r0, r0, #4
	orr r1, r0
	strb r1, [r3,#0x15]
	mov pc, lr
	thumb_func_end sprite_setSubEntryPaletteBank_800304A

// symdb: Stores a byte into field +0xA of the 16-byte-aligned sub-record selected by the sprite object's bank/index nibble.
// symdb: void sprite_setSubRecordFieldA(u8 value, SpriteObj* obj /* r5 */); // out: r3 = sub-record base,
// symdb: c/v from the ADD
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_setSubRecordFieldA_8003060.yaml
	thumb_func_start sprite_setSubRecordFieldA_8003060
sprite_setSubRecordFieldA_8003060:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	strb r0, [r3,#0xa]
	mov pc, lr
	thumb_func_end sprite_setSubRecordFieldA_8003060

// symdb: Uses the high nibble of a selector byte in a table header to pick a 16-byte slot, writes a caller-supplied halfword into it, and zeroes a wider field that overruns into the next slot.
// symdb: void sub_800306C(u16 value /* r0 */, void* table /* r5 */) // tail-calls back to lr; no return
// symdb: value
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/slotList_storeHalfwordAndClearField_800306C.yaml
	thumb_func_start slotList_storeHalfwordAndClearField_800306C
slotList_storeHalfwordAndClearField_800306C:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	strh r0, [r3,#8]
	mov r0, #0
	str r0, [r3,#0x24]
	mov pc, lr
	thumb_func_end slotList_storeHalfwordAndClearField_800306C

// symdb: Sets an object's x/y position fields within the 0x10-byte sprite sub-entry selected by the high nibble of the resource's byte 2.
// symdb: void sprite_setCoordinates(u16 x /*r0*/, u16 y /*r1*/, SpriteResource* res /*r5*/); returns r3 =
// symdb: selected sub-entry address, NZCV from computing it
// symdb: confirmed; evidence and how to reproduce it: recomp symbols/db/sprite_setCoordinates.yaml
	thumb_func_start sprite_setCoordinates
sprite_setCoordinates:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	strh r0, [r3,#0xc]
	strh r1, [r3,#0xe]
	mov pc, lr
	thumb_func_end sprite_setCoordinates

	thumb_func_start sprite_addCoordinates
sprite_addCoordinates:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	mov r2, #0xc
	ldrsh r2, [r3,r2]
	add r0, r0, r2
	mov r2, #0xc
	strh r0, [r3,r2]
	mov r2, #0xe
	ldrsh r2, [r3,r2]
	add r1, r1, r2
	mov r2, #0xe
	strh r1, [r3,r2]
	mov pc, lr
	thumb_func_end sprite_addCoordinates

	thumb_func_start sprite_getCoordinates
sprite_getCoordinates:
	ldrb r3, [r5,#2]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r3, r3, r5
	mov r0, #0xc
	ldrsh r0, [r3,r0]
	mov r1, #0xe
	ldrsh r1, [r3,r1]
	mov pc, lr
	thumb_func_end sprite_getCoordinates

// symdb: Look up the per-frame (dx, dy) shadow offset entry for a sprite given the current frame index.
// symdb: (r0 = spriteDataPtr?, r1 = frameIndex) -> r0 = dx, r1 = dy (or both 0 if missing/none)
// symdb: probable; evidence and how to reproduce it: recomp symbols/db/sprite_getShadowOffsetForFrame_80030BA.yaml
	thumb_func_start sprite_getShadowOffsetForFrame_80030BA
sprite_getShadowOffsetForFrame_80030BA:
	push {r4-r7,lr}
	mov r5, r0
	ldrb r3, [r5,#oObjectHeader_TypeAndSpriteOffset]
	lsr r3, r3, #4
	lsl r3, r3, #4
	add r5, r5, r3
	ldr r3, [r5,#oObjectSprite_Unk_20]
	ldrb r2, [r3]
	lsl r2, r2, #2
	ldr r0, [r5,#oObjectSprite_Unk_1c]
	ldr r0, [r0,#0xc]
	ldr r3, [r5,#oObjectSprite_Unk_18]
	add r3, r3, r0
	ldr r2, [r3,r2]
	add r2, r2, r3
	mov r4, #0
loc_80030DA:
	ldrb r3, [r2]
	cmp r3, #0xff
	beq loc_80030F4
	cmp r4, r1
	beq loc_80030EA
	add r4, #1
	add r2, #5
	b loc_80030DA
loc_80030EA:
	mov r0, #1
	ldrsb r0, [r2,r0]
	mov r1, #2
	ldrsb r1, [r2,r1]
	pop {r4-r7,pc}
loc_80030F4:
	mov r0, #0
	mov r1, #0
	pop {r4-r7,pc}
	thumb_func_end sprite_getShadowOffsetForFrame_80030BA
	.balign 4, 0x00

/*For debugging purposes, connect comment at any range!*/
