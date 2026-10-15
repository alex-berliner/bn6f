//! type: BattleState

	.macro battle_state_struct label=oBattleState, struct_entry=label_struct_entry, set_struct_start_address=set_struct_start_address
	\set_struct_start_address
	set_struct_label \struct_entry, \label
	u8 Index_00 // loc=0x0
	u8 Index_01 // loc=0x1

	union
	u8 StatePhase // loc=0x2
	u8 SubPhaseInitFlag // loc=0x3
	nextu
	u16 StatePhaseAndInitFlag // loc=0x2
	endu

	union
	u8 AliveActorTurnIndex // loc=0x4
	u8 OpponentAliveCount // loc=0x5
	nextu
	u16 Unk_04_05 // loc=0x4
	endu

	u8 BattleField // loc=0x6
	u8 BattlePhase // loc=0x7
	u8 AllianceEntryCount // loc=0x8
	struct_org 0xa
	u8 PauseFlag // loc=0xa
	u8 BattleOverConditionFlag // loc=0xb
	struct_org 0xd
	u8 PlayerSide // loc=0xd
	u8 PanelTurnCount // loc=0xe
	u8 BattleType // loc=0xf
	u8 LoserSide // loc=0x10
	flags8 StateFlags // loc=0x11
		struct_const BATTLE_STATE_UNK_11_FLAG_UNK_BIT_00, 										0x01
		struct_const BATTLE_STATE_UNK_11_FLAG_UNK_BIT_01, 										0x02
		struct_const BATTLE_STATE_UNK_11_FLAG_UNK_BIT_02, 										0x04
		struct_const BATTLE_STATE_UNK_11_FLAG_UNK_BIT_03, 										0x08
		struct_const BATTLE_STATE_UNK_11_FLAG_UNK_BIT_04, 										0x10
		struct_const BATTLE_STATE_UNK_11_FLAG_UNK_BIT_05, 										0x20
		struct_const BATTLE_STATE_UNK_11_FLAG_UNK_BIT_06, 										0x40
		struct_const BATTLE_STATE_UNK_11_FLAG_UNK_BIT_07, 										0x80

	union
	u8 AliveAllianceCount // loc=0x12
	u8 BattleOverSecondaryFlag // loc=0x13
	nextu
	u16 Unk_12_13 // loc=0x12
	endu

	u8 BackgroundType // loc=0x14
	u8 PendingFieldChange // loc=0x15
	u8 PanelTurnStepCounter // loc=0x16
	u8 BeastOutFlag // loc=0x17
	u8 PhaseStepIndex // loc=0x18
	u8 CustGaugeChargeLevel // loc=0x19
	u8 State4EventCount // loc=0x1a
	u8 PanelSelectedCount // loc=0x1b
	u8 PhaseMessageDelayCounter // loc=0x1c
	u8 MessageTimer // loc=0x1d
	u8 BustingLevelCategory // loc=0x1e
	u8 BattleResult // loc=0x1f
	u16 LowHPAlertTimers // loc=0x20

	struct_org 0x28
	u16 CountdownTimer // loc=0x28
	struct_org 0x32
	u16 BattleStateFlags // loc=0x32
	u16 PlayerHPSnapshot // loc=0x34
	u16 Reward2Bonus // loc=0x36
	u16 Unk_38 // loc=0x38
	u16 PendingBattleEndAction // loc=0x3a
	u32 BattleSettings // loc=0x3c
	u32 ChipUseFrameCounter // loc=0x40
	// todo: figure out where these are accessed
	// analyzer detects these but obviously not an imm read
	u8 Unk_44 // loc=0x44
	u8 Unk_45 // loc=0x45
	struct_org 0x5c
	u32 AlliancePermissionFlags // loc=0x5c
	u32 FrameCounter // loc=0x60
	u32 SpriteRenderFrameCounter // loc=0x64
	struct_org 0x80
	u0 AliveBattleActors // loc=0x80
	u8_arr AlivePlayerActors, 0x10 // loc=0x80
	u8_arr AliveOpponentActors, 0x10 // loc=0x90
	u0 BattleObjectList // loc=0xa0
	struct_org 0xc0
	u0 Unk_c0 // loc=0xc0
	struct_org 0xd0
	u0 BattleActors // loc=0xd0
	u8_arr PlayerActors, 0x10 // loc=0xd0
	u8_arr OpponentActors, 0x10 // loc=0xe0
	u0 Size // loc=0xf0
	restore_struct_label
	.endm

// TODO
//	u32 Unk_80 // loc=0x80
//	u32 Unk_84 // loc=0x84
//	u32 Unk_90 // loc=0x90
//	u32 Unk_94 // loc=0x94
//	u32 Unk_b8 // loc=0xb8
//	u32 Unk_bc // loc=0xbc
//	u32 Unk_e0 // loc=0xe0

	def_struct_offsets battle_state_struct, oBattleState
