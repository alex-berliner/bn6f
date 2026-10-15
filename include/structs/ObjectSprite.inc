
	.macro object_sprite_struct, label=oObjectSprite, struct_entry=label_struct_entry, set_struct_start_address=set_struct_start_address
    // type: struct ObjectSprite
	set_struct_label \struct_entry, \label
\label:
	u8 AnimationIndex // loc=0x0
	u8 AnimFrameDuration // loc=0x1
	u8 AttributeFlags // loc=0x2
	u8 SpriteFlags2 // loc=0x3
	u8 PaletteIndex // loc=0x4
	u8 PaletteRowIndex // loc=0x5
	u16 ColorShader // loc=0x6
	.space 0x2
	u16 SpriteExtraBytes // loc=0xa
	.space 0x4
	u8 Unk_10 // loc=0x12 // also size 2

	// this might be written to bits 8-15 for obj attribute 0
	// set this to 0x10 to give this sprite a mosaic
	// but the mosaic size is at eRenderInfo+2
	u8 SpriteFlags // loc=0x11

	u8 FrameCounter // loc=0x12 // also size 2
	u8 SpriteFlags3 // loc=0x13
	u8 InitFlag // loc=0x14
	u8 OamAttributes // loc=0x15
	u16 CurFrame // loc=0x16
	u32 AnimationResourcePtr // loc=0x18
	u32 AnimationSubFramePtr // loc=0x1c
	u32 AnimFrameDataPtr // loc=0x20
	u32 SpriteRenderDataPtr // loc=0x24
	u32 SpriteAttrs2Ptr // loc=0x28
	u32 ScriptParam // loc=0x2c
	u32 SpriteFlags4Ptr // loc=0x30
	u32 ScratchByte // loc=0x34
	u0 Size // loc=0x38
	restore_struct_label
	.endm

	.struct 0
	def_struct_offsets object_sprite_struct, oObjectSprite
