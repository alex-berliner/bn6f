//! type: struct Struct2035280

  .macro s_2035280_struct label:req, struct_entry=label_struct_entry, set_struct_start_address=set_struct_start_address
  \set_struct_start_address \label
  set_struct_label \struct_entry, \label

  // The CUSTOM gauge's flow counter. It is 0 for every frame the gauge is below
  // CUST_GAUGE_FULL and reads 1 on the same frame CustGaugeValue first reads
  // CUST_GAUGE_FULL, +1 a frame after that, wrapping at CUST_GAUGE_FLOW_PERIOD.
  // drawCustGauge_801C4E4 derives the bar tile and the L/R marker tile from it
  // alone -- there is no second phase. (bn A8/F6/wt/zero-layers; docs/renames.md)
  u8 CustGaugeFlowCounter // loc=0x0

  struct_org 0x12
  // The chip window's slide position, mirrored here by setChipWindowSlideX_801E71C
  // as (CHIP_WINDOW_SLIDE_FROM - RenderInfo.BG3HOfs_18) while the window moves.
  // drawEmotionWindow_801CDEC adds it into the emotion window's OAM x so that the
  // window rides the slide. (bn F33, measured; docs/renames.md)
  u8 ChipWindowSlideX // loc=0x12

	struct_org 0x17
  u8 NaviStatusGfxIdx // loc=0x17

  struct_org 0x20
  // The CUSTOM gauge itself. Full at CUST_GAUGE_FULL; ClearCustGauge zeroes it,
  // SetCustGauge writes it and AddToCustGauge_801DFB8 adds to it with that cap.
  u16 CustGaugeValue // loc=0x20

  // RetrieveAndRenderEnemyVirusNamesInBattle_801E574 seems to imply that this is an inner array [u16; 4] (size 0x08)
  struct_org 0x28
  u0 VirusNameIdxU16Arr // loc=0x28

	struct_org 0x40
  // The battle-HUD element mask: one bit per HUD element, tested by
  // updateBattleHudElements_801BEE0 and drawBattleHudElements_801BF64 before each
  // element's handler runs. setBattleHudElements_801BECC sets bits and
  // clearBattleHudElements_801BED6 clears them. (bn F27b/F33, measured live)
  flags32 HudElementMask // loc=0x40

	struct_org 0x44
	flags32 UnkFlags_44 // loc=0x44

  // sub_801BE70 implies 0x60
  struct_org 0x60
  u0 Size // loc=0x60

  restore_struct_label
  .endm

  def_struct_offsets s_2035280_struct, oStruct2035280
