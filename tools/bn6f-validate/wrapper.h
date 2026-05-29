// bindgen entry point for bn6f-validate.
// Pulls just the mGBA bits we need: core API, savestate VFile loading,
// and FFmpegEncoder for the lossy-review-mp4 output path.
#include <mgba/core/core.h>
#include <mgba/core/config.h>
#include <mgba/core/interface.h>
#include <mgba/core/log.h>
#include <mgba/core/serialize.h>
#include <mgba-util/vfs.h>
#include <feature/ffmpeg/ffmpeg-encoder.h>
