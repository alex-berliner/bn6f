// bindgen entry point for bn6f-harness.
// Just enough mGBA to create a core, load a ROM + real BIOS, and reset.
// More surface (serialize/savestate, etc.) gets added as later bricks need it.
#include <mgba/core/core.h>
#include <mgba/core/config.h>
#include <mgba/core/interface.h>
#include <mgba/core/log.h>
#include <mgba-util/vfs.h>
// B2 (execution control): the GBA core's CPU is an ARMCore; we read PC/LR/
// CPSR off it directly (mGBA installs internal/ headers with the prefix).
#include <mgba/internal/arm/arm.h>
