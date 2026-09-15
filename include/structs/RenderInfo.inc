
	.macro render_info_struct, label:req, struct_entry=label_struct_entry, set_struct_start_address=set_struct_start_address
    // type: struct RenderInfo
	\set_struct_start_address
	set_struct_label \struct_entry, \label
	// look at render_800172C for how data is transferred
	// todo document rest of struct fields
	//
	// bn AUDIT wave 3d "bg3-merge": render_800172C (asm00_0.s:2823-2878)
	// copies this struct's own +0x04..+0x3c (0x38 bytes, CopyWords) to
	// BG0Control (0x04000008) onward, so struct offset X lands at hardware
	// 0x04000008 + (X - 0x04) -- Unk_0a (0x0a) is BG3CNT (0x0400000e), and
	// by the same arithmetic Unk_0c/Unk_0e are BG0HOFS/BG0VOFS,
	// Unk_10/Unk_12 BG1HOFS/BG1VOFS, Unk_14/Unk_16 BG2HOFS/BG2VOFS, and
	// Unk_18/Unk_1a BG3HOFS/BG3VOFS (0x0400001c/0x0400001e). Confirmed live
	// against the real ROM (mgba_capture --watch, base struct at
	// eRenderInfo == 0x0200ac40 per ewram.s so Unk_18 is 0x0200ac58): while
	// the chip window (chipWindowState00SlideIn_8026B04/chipWindowState08SlideOut_8026BF4, this struct's own
	// Unk_18 write at asm03_0.s:907/974/1111) slides in/out, EWRAM
	// 0x0200ac58 counts exactly the 0x78->0 (or reverse) sequence those
	// functions write, in lock-step with the window's own visible motion
	// -- one hardware BG, dragging the HP box along with it (see
	// battle.rs's own hud_bg field in the bn repo for why the Rust port
	// now matches that). The RESULT window (sub_802C34E onward,
	// asm03_0.s:12386+) does NOT: watched 0x0200ac4c-0x0200ac5b (this
	// struct's own Unk_0c..Unk_1a, all four BGs' H/VOFS) across a full
	// result_arrival capture and every one read a constant 0 throughout
	// (BG1/Unk_10's own backdrop drift excepted) even while the window
	// visibly slides in at sub-pixel precision -- so RESULT's own slide is
	// NOT a BGxHOFS scroll of any of the four hardware backgrounds. Which
	// function actually animates it (not sub_802C34E, which only zero-
	// fills eS20364C0 and queues the window's static GFX transfers once)
	// was not located this ticket.
	u16 Unk_00 // loc=0x0
	u16 Unk_02 // loc=0x2
	struct_org 0xa
	u16 BG3Control_0a // loc=0xa
	u16 BG0HOfs_0c // loc=0xc
	u16 BG0VOfs_0e // loc=0xe
	u16 BG1HOfs_10 // loc=0x10
	u16 BG1VOfs_12 // loc=0x12
	u16 BG2HOfs_14 // loc=0x14
	u16 BG2VOfs_16 // loc=0x16
	u16 BG3HOfs_18 // loc=0x18
	u16 BG3VOfs_1a // loc=0x1a
	struct_org 0x40
	u0 Size // loc=0x40
	restore_struct_label
	.endm

	def_struct_offsets render_info_struct, oRenderInfo
