	enum_start // type: enum BattleEffect
	flag_enum BATTLE_EFFECT_BOSS_RANK
	flag_enum BATTLE_EFFECT_SHOW_RESULTS
	flag_enum BATTLE_EFFECT_HEAL_BEFORE_BATTLE
	flag_enum BATTLE_EFFECT_NETWORK_BATTLE
	flag_enum BATTLE_EFFECT_HEAL_AFTER_BATTLE
	flag_enum BATTLE_EFFECT_ALLOW_RUNNING_AND_KEEP_FULL_SYNC
	flag_enum BATTLE_EFFECT_DONT_HEAL_AFTER_BATTLE
	flag_enum BATTLE_EFFECT_RANDOMIZE_FOLDER
	flag_enum BATTLE_EFFECT_ALLOW_GAME_OVER
	flag_enum BATTLE_EFFECT_UNK_0x200
	flag_enum BATTLE_EFFECT_TRIPLE_BATTLE
	flag_enum BATTLE_EFFECT_UNK_0x800
	flag_enum BATTLE_EFFECT_UNK_0x1000
	flag_enum BATTLE_EFFECT_UNK_0x2000
	flag_enum BATTLE_EFFECT_ALLOW_LOCENEMY_AND_KEEP_FULL_SYNC
	flag_enum BATTLE_EFFECT_NO_RARE_VIRUSES
	flag_enum BATTLE_EFFECT_UNK_0x10000
	flag_enum BATTLE_EFFECT_UNK_0x20000
	flag_enum BATTLE_EFFECT_UNK_0x40000
	flag_enum BATTLE_EFFECT_UNK_0x80000
	flag_enum BATTLE_EFFECT_NO_DARK_CHIPS
	flag_enum BATTLE_EFFECT_UNK_0x200000
	flag_enum BATTLE_EFFECT_UNK_0x400000
	flag_enum BATTLE_EFFECT_UNK_0x800000

	.equiv BATTLE_ACTORS_PER_SIDE, 4

	// --- The battle sequencer -------------------------------------------------
	// eBattleSequencerState_203CA70's low byte is a PRE-MULTIPLIED byte offset
	// into a handler table, not a state number, so these are 0, 4, 8, ... The
	// banner sequencer (stepBannerSequencer_800801C / BannerSequencerStates_8008038)
	// runs the same table for BATTLE START!, TURN START!, ENEMY DELETED,
	// MEGAMAN DELETED and the result messages.
	// Canon's own run over one battle, measured by the bn project (T7c/T7d):
	// 0x1C for frames 0..10, 0x08 11..41, 0x20 42..43, 0x24 44..143,
	// 0x00 144..146, 0x04 147..206, 0x08 207..315, then 0x0C.
	.equiv BATTLE_SEQ_SETTLE,          0x00 // post-window settle
	.equiv BATTLE_SEQ_BANNER_WAIT,     0x04 // holds until isBannerBusy_801E754 reads 0
	.equiv BATTLE_SEQ_FIGHT,           0x08 // the fight itself
	.equiv BATTLE_SEQ_WIN_COUNT,       0x0c // the RESULT countdown
	.equiv BATTLE_SEQ_LOSE_COUNT,      0x10
	.equiv BATTLE_SEQ_MESSAGE_COUNT,   0x14
	.equiv BATTLE_SEQ_18,              0x18
	.equiv BATTLE_SEQ_1C,              0x1c // the value a PAUSED battle loads with
	.equiv BATTLE_SEQ_WINDOW_OPENING,  0x20 // chip window sliding in
	.equiv BATTLE_SEQ_WINDOW_OPEN,     0x24 // chip window up

	// The four states in which the player executor early-returns without acting
	// (playerObject_update_80EA484 / dispatchBattleFsm_8009158; bn T7q/T7r).

	// --- eBattleState.Index_01, the battle FSM ---------------------------------
	// Also a pre-multiplied byte offset, into BattleFsmStates_80091BC.
	// Observed run: 0x00 -> 0x04 -> 0x08 -> 0x0C, parking at 0x0C, which is the
	// state that drives the banner sequencer (bn T9c/T9d, measured).
	.equiv BATTLE_FSM_STATE_00,        0x00
	.equiv BATTLE_FSM_STATE_04,        0x04
	.equiv BATTLE_FSM_STATE_08,        0x08 // gates on isChipWindowReady_8026A28
	.equiv BATTLE_FSM_STATE_0C,        0x0c // runs the banner sequencer every frame

	// --- The CUSTOM gauge -------------------------------------------------------
	.equiv CUST_GAUGE_FULL,            0x4000 // Struct2035280.CustGaugeValue's cap
	// CustGaugeFlowCounter wraps here: lcm(28, 16), the bar's 4-tile cycle at one
	// step per 7 frames against the marker's 8-frame blink (bn F6/wt/zero-layers).
	.equiv CUST_GAUGE_FLOW_PERIOD,     112
	// The chip window's slide runs RenderInfo.BG3HOfs_18 between these, by
	// CHIP_WINDOW_SLIDE_STEP a call, so exactly ten calls either way.
	.equiv CHIP_WINDOW_SLIDE_FROM,     0x78
	.equiv CHIP_WINDOW_SLIDE_STEP,     0xc

	enum_start // type: enum BattleMode
	enum BATTLE_MODE_NORMAL // 0
	enum BATTLE_MODE_CROSSOVER // 1
	enum BATTLE_MODE_TUTORIAL_1 // 2
	enum BATTLE_MODE_TUTORIAL_2 // 3
	enum BATTLE_MODE_TUTORIAL_3 // 4
	enum BATTLE_MODE_BEAST_OUT_TUTORIAL // 5
	enum BATTLE_MODE_VIRUS_BATTLER // 6
	enum BATTLE_MODE_TOMAHAWKMAN_MINI_GAME // 7
	enum BATTLE_MODE_CROSS_TUTORIAL // 8
	enum BATTLE_MODE_DUSTMAN_MINI_GAME // 9
	enum BATTLE_MODE_HAKUSHAKU_INVINCIBLE_MODE // 10
	enum BATTLE_MODE_HAKUSHAKU_DEFEAT // 11

	enum_start // type: enum BattleResult
	enum BATTLE_RESULT_WON // 0
	enum BATTLE_RESULT_LOST // 1
	enum BATTLE_RESULT_TIED // 2
	enum BATTLE_RESULT_ESCAPED // 3

