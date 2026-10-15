	.macro ai_data_struct, label:req, struct_entry=label_struct_entry, set_struct_start_address=set_struct_start_address
    // type: struct AIData
	\set_struct_start_address \label
	set_struct_label \struct_entry, \label
	enum8 ActorType // loc=0x0
		struct_const ACTOR_TYPE_VIRUS, 0x00
		struct_const ACTOR_TYPE_NAVI, 0x01
		struct_const ACTOR_TYPE_PLAYER, 0x02
	u8 AIIndex // loc=0x1
	u8 DisableCounterDecrement // loc=0x2
	u8 VersionVariant // loc=0x3
	u8 NaviBonusIndex // loc=0x4
	u8 APwrAtk // loc=0x5
	u8 BButton // loc=0x6
	u8 BPwrAtk // loc=0x7
	u8 BLeftAbility // loc=0x8
	u8 PoisonTickCounter // loc=0x9
	u8 SelfDestructTurnCounter // loc=0xa
	u8 AIScratchByte // loc=0xb
	u8 AiDifficultyTier // loc=0xc
	u8 ChargeShotStepIndex // loc=0xd
	u8 AISubordinateSlot // loc=0xe
	u8 BeastOutLockoutTimer // loc=0xf
	u8 CounterHealDamage // loc=0x10
	u8 BeastOutAPwrAtk // loc=0x11
	u8 CounterHitChain // loc=0x12
	u8 BurstShotTimer // loc=0x13
	.space 0x1
	u8 ChipUseDelayAlt // loc=0x15
	u8 Version_16 // loc=0x16
	u8 Version_17 // loc=0x17
	u8 Unk_18 // loc=0x18
	u8 ChipLockoutTimer // loc=0x19
	u8 AttackTeardownScratch // loc=0x1a
	u8 PwrAtkCurChargeTime // loc=0x1b
	u8 PanelDamageReactionFlag // loc=0x1c
	u8 PwrAtkState // loc=0x1d
	u8 PwrAtkButton // loc=0x1e
	struct_org 0x20
	u16 TotalDamageTaken // loc=0x20
	u16 JoypadHeld // loc=0x22
	u16 JoypadPressed // loc=0x24
	u16 JoypadUp // loc=0x26
	u16 JoypadReleased // loc=0x28
	u16 FrozenJoypadReleased // loc=0x2a
	u16 TimeStopMirrorHeld // loc=0x2c
	u16 JoypadHeldPrev // loc=0x2e
	u16 JoypadFrozen // loc=0x30
	u16 CounterHitChainFlag // loc=0x32
	// bool16???
	u16 Anger // loc=0x34
	u16 PoisonDamagePerTick // loc=0x36
	u16 CollisionFreezeTimer // loc=0x38
	u16 ActionRerollFrameCounter // loc=0x3a
	u16 SavedZ16 // loc=0x3c

	struct_org 0x40
	u32 TargetObjectPtr // loc=0x40
	u32 AIFlags // loc=0x44
	u32 Flags // loc=0x48
	u32 AIScriptCounter // loc=0x4c
	u32 SubordinateObjectUnk // loc=0x50
	u32 BubbleSourceObjectPtr // loc=0x54
	u32 SubordinateAIObjectPtr // loc=0x58
	ptr AIScriptOffset // loc=0x5c
	u32 SubordinateObjectPtr // loc=0x60

	struct_org 0x68
	u32 TempAttackObjectPtr // loc=0x68
	u32 Unk_6c // loc=0x6c
	u32 Unk_70 // loc=0x70
	u32 SpawnedSourceObjectPtr // loc=0x74
  // * BattleObject
	ptr BattleObjectPtr // loc=0x78
	u32 Unk_7c // loc=0x7c
	u0 AIState // loc=0x80

	struct_org 0xa0
	u8_arr AttackVars, 0x50 // loc=0xa0

	struct_org 0x100
	u0 Size // loc=0x100
	u0 End // loc=0x100
	restore_struct_label
	.endm

// ai state and ai attack vars might be swapped
	.macro ai_state_struct, label:req, struct_entry=label_struct_entry, set_struct_start_address=set_struct_start_address
    // type: struct AIState
	\set_struct_start_address \label
	set_struct_label \struct_entry, \label
	u8 ScriptId // loc=0x0
	u8 Unk_01 // loc=0x1
	u8 SubState // loc=0x2
	u8 AttackDecisionFlag // loc=0x3
	u8 TurnCounter // loc=0x4
	u8 AttackCounter // loc=0x5
	u8 StepCounter // loc=0x6
	u8 AggressionFlag // loc=0x7
	u16 Timer // loc=0x8
	.space 0x2
	u8 Unk_0c // loc=0xc
	u8 Unk_0d // loc=0xd
	u8 Unk_0e // loc=0xe
	u8 Unk_0f // loc=0xf
	struct_org 0x20
	u0 Size // loc=0x20
	u0 End // loc=0x20
	restore_struct_label
	.endm

	.macro ai_attack_vars_struct, label:req, struct_entry=label_struct_entry, set_struct_start_address=set_struct_start_address
    // type: struct AIAttackVars
	\set_struct_start_address \label
	set_struct_label \struct_entry, \label
	u8 HitElement // loc=0x0
	u8 AttackElement // loc=0x1
	u8 InitFlag // loc=0x2
	u8 AiDifficultyTier // loc=0x3
	u8 ChargeReadyFlag // loc=0x4
	u8 ChipUseDelay // loc=0x5
	u16 AttackBoost // loc=0x6
	u16 Damage // loc=0x8
	u16 ExtraDamage // loc=0xa
	u8 AttackBoost2 // loc=0xc
	u8 TimerOrCycles // loc=0xd
	u8 SubStepIndex // loc=0xe
	u8 AttackStepIndex // loc=0xf
	u16 StepTimer // loc=0x10
	u16 ChargeCycles // loc=0x12
	u16 ChipID // loc=0x14
	u8 TargetPanelX // loc=0x16
	u8 TargetPanelY // loc=0x17
	u16 AttackDuration // loc=0x18
	u8 HasMoved // loc=0x1a
	u8 IsInvincible // loc=0x1b
	u8 Unk_1c // loc=0x1c
	u8 PwrAtkState // loc=0x1d
	u8 Unk_1e // loc=0x1e
	struct_org 0x28
	u32 PanelChooseCallback // loc=0x28
	u32 TargetObjectPtr // loc=0x2c
	u16 ScratchVar // loc=0x30 // also size 4
	u16 Unk_32 // loc=0x32
	u16 AiAttackParam // loc=0x34 // also size 4
	u16 Unk_36 // loc=0x36
	u32 PanelParamFlags2 // loc=0x38
	u32 ScratchPointerOrPanel // loc=0x3c
	u32 Unk_40 // loc=0x40
	u32 Unk_44 // loc=0x44
	struct_org 0x50
	u0 Size // loc=0x50
	u0 End // loc=0x50
	restore_struct_label
	.endm

	def_struct_offsets ai_data_struct, oAIData
	def_struct_offsets ai_state_struct, oAIState
	def_struct_offsets ai_attack_vars_struct, oAIAttackVars
