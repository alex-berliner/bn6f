# binary tools used in build
MAKE = make
AS = tools/binutils/bin/arm-none-eabi-as
LD = tools/binutils/bin/arm-none-eabi-ld
OBJCOPY = tools/binutils/bin/arm-none-eabi-objcopy
OBJDUMP := tools/binutils/bin/arm-none-eabi-objdump
GBAGFX = tools/gbagfx/gbagfx
SHA1SUM = sha1sum
PY = py
CC = tools/agbcc/bin/agbcc

# project paths
SRCDIR = asm
BIN = bin
CONST = constants
INC = include
CSRCDIR = src/c
CBUILDDIR = build/c

# project files
SFILES = rom.s data.s ewram.s iwram.s vram.s

# C source files compiled with agbcc
C_SRCS = $(wildcard $(CSRCDIR)/*.c)
C_SFILES = $(patsubst $(CSRCDIR)/%.c,$(CBUILDDIR)/%.s,$(C_SRCS))
C_OFILES = $(patsubst $(CSRCDIR)/%.c,$(CBUILDDIR)/%.o,$(C_SRCS))

# to keep track of compressed files and to build decompressed versions into them
# defines rules to build and compress lz files
include lz_assets.mk

OFILES = $(addprefix $(OBJ),$(SFILES:.s=.o))
BUILD_NAME = bn6f
ROM = $(BUILD_NAME).gba
ELF := $(ROM:.gba=.elf)
SYM = $(ROM:.gba=.sym)
NOGBASYM = bn6f_nogba.sym

# build flags
COMPLIANCE_FLAGS = -g -I$(INC)
WFLAGS =
ARCH = -mcpu=arm7tdmi -march=armv4t -mthumb -mthumb-interwork
CDEBUG =
CFLAGS =
ASFLAGS = $(ARCH) $(WFLAGS) $(COMPLIANCE_FLAGS) --agbasm-colonless-labels --agbasm-colon-defined-global-labels --agbasm-local-labels --agbasm-multiline-macros \
	--agbasm-charmap --agbasm-no-gba-thumb-after-label-disasm-fix
CPP = cpp
CPPFLAGS = -I$(CSRCDIR) -Iconstants/headers -undef -nostdinc -Wall -Wno-trigraphs
CCFLAGS = -O2 -mthumb-interwork

ASDEBUGFLAGS = --agbasm-debug $(@:.o=.dump)
LDFLAGS = -Map $(BUILD_NAME).map
LIB =
CLIB = tools/agbcc/lib/libgcc.a

.PHONY: setup-toolchain syms decompile orig validate function-symbols track track-build smoke verify verify-state list-demos clean-conditional-objs

# One-time toolchain install. Builds the agbcc submodule + gbagfx and
# installs arm-none-eabi-{as,ld,objcopy,objdump} into tools/binutils/bin/
# and agbcc into tools/agbcc/bin/. Idempotent — sub-builds no-op on
# rerun. Not wired into the normal build graph on purpose; see INSTALL.md.
AGBCC_SRC := tools/agbcc-src
setup-toolchain:
	@if [ -x tools/binutils/bin/arm-none-eabi-as ] && [ -x tools/agbcc/bin/agbcc ]; then \
		echo "[setup-toolchain] agbcc/binutils already present."; \
	else \
		if [ ! -f $(AGBCC_SRC)/Makefile ]; then \
			echo "[setup-toolchain] fetching agbcc submodule..."; \
			git submodule update --init --recursive $(AGBCC_SRC); \
		fi; \
		echo "[setup-toolchain] building agbcc (this takes several minutes)..."; \
		$(MAKE) -C $(AGBCC_SRC) || exit $$?; \
		echo "[setup-toolchain] installing into $(CURDIR)/tools..."; \
		$(MAKE) -C $(AGBCC_SRC) install prefix=$(CURDIR) || exit $$?; \
		test -x tools/binutils/bin/arm-none-eabi-as || { echo "setup-toolchain: install finished but tools/binutils/bin/arm-none-eabi-as is missing" >&2; exit 1; }; \
	fi
	@echo "[setup-toolchain] building gbagfx..."
	@$(MAKE) -C tools/gbagfx
	@test -x $(GBAGFX) || { echo "setup-toolchain: gbagfx build did not produce $(GBAGFX)" >&2; exit 1; }
	@echo "[setup-toolchain] done."

# TODO: INTEGRATE SCAN INCLUDES

all: clean-conditional-objs $(ROM)
	@$(SHA1SUM) -c $(BUILD_NAME).sha1

# Modified ROM with C decompiled functions (does not match original SHA1).
# Uses ld_script_decompile.ld which adds a .c_code section in the ROM fill area.
# Conversion list lives in tools/decomp_manifest.txt — one ASM symbol per
# line. For each symbol we generate `--defsym DECOMP_<sym>=1`, which gates
# the `.ifndef DECOMP_<sym>` block in asm/*.s. `make all` builds without
# these flags, so the original ROM still SHA-matches.
DECOMP_MANIFEST = tools/decomp_manifest.txt
DECOMP_SYMS = $(shell awk '!/^[[:space:]]*#/ && NF>0 {print $$1}' $(DECOMP_MANIFEST))
DECOMP_DEFSYMS = $(foreach s,$(DECOMP_SYMS),--defsym DECOMP_$(s)=1)

# Sink the long --defsym chain into a response file. `arm-none-eabi-as`
# accepts `@FILE` and reads whitespace-separated args from it, so the
# (growing-with-manifest) flag list never appears on the command line.
# Cuts ~5KB per assembler invocation out of `make` output.
DECOMP_FLAGS_FILE = build/decomp_flags.txt

$(DECOMP_FLAGS_FILE): $(DECOMP_MANIFEST) | build
	@printf '%s\n' $(DECOMP_DEFSYMS) > $@

build:
	@mkdir -p $@

# Same trick for the linker side — C_OFILES is a similarly long list
# that bloats `make decompile` output. ld also accepts @FILE.
C_OFILES_LIST = build/c_ofiles.txt

$(C_OFILES_LIST): $(C_OFILES) | build
	@printf '%s\n' $(C_OFILES) > $@

decompile: ASFLAGS += @$(DECOMP_FLAGS_FILE)
decompile: clean-conditional-objs $(DECOMP_FLAGS_FILE) $(C_OFILES) $(C_OFILES_LIST) $(OFILES)
	$(LD) $(LDFLAGS) -o $(ELF) -T ld_script_decompile.ld $(OFILES) @$(C_OFILES_LIST) $(CLIB) $(LIB)
	$(OBJCOPY) -O binary $(ELF) $(ROM)

# Top-level .o files that pull in (via `.include`) any asm/*.s sub-file
# containing a per-function `.ifndef DECOMP_*` block. These must be
# rebuilt every invocation so the flag set (target-specific ASFLAGS)
# actually takes effect — otherwise a previous build's .o is reused.
# rom.o aggregates all of asm/*.s.
CONDITIONAL_OFILES = rom.o

.PHONY: clean-conditional-objs
clean-conditional-objs:
	@rm -f $(CONDITIONAL_OFILES)

$(ROM): $(ELF)
	$(OBJCOPY) -O binary $(ELF) $(ROM)

# Explicit ELF rules so each ELF lands at its own path (the old pattern
# rule `%.elf: $(OFILES)` hard-coded `-o $(ELF)` regardless of target,
# producing the wrong filename when building bn6f_orig.elf).
$(ELF): clean-conditional-objs $(OFILES)
	$(LD) $(LDFLAGS) -o $@ -T ld_script.ld $(OFILES) $(LIB)

bn6f_orig.elf: clean-conditional-objs $(OFILES)
	$(LD) $(LDFLAGS) -o $@ -T ld_script.ld $(OFILES) $(LIB)

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

# C compilation: .c -> .i (cpp) -> .s (agbcc) -> .o (assembler)
$(CBUILDDIR):
	mkdir -p $@

$(CBUILDDIR)/%.i: $(CSRCDIR)/%.c | $(CBUILDDIR)
	$(CPP) $(CPPFLAGS) $< -o $@

$(CBUILDDIR)/%.s: $(CBUILDDIR)/%.i
	$(CC) $(CCFLAGS) $< -o $@

$(CBUILDDIR)/%.o: $(CBUILDDIR)/%.s
	$(AS) $(ARCH) -g -I$(INC) $< -o $@

orig: bn6f_orig.elf
	@echo "Saved bn6f_orig.elf"

validate: bn6f_orig.elf $(ELF)
	$(PY) tools/validate_asm.py bn6f_orig.elf $(ELF)

assets: $(LZ_FILES) $(LZ_BINFILES)
	

checksum:
	@$(SHA1SUM) -c $(BUILD_NAME).sha1

fdiff:
	$(PY) tools/fdiff.py $(BUILD_NAME).ign $(ROM) -s2

tail: $(ROM)
	@# Create tail.bin using the tail location in current elf then compile again
	$(PY) tools/gen_obj_tail.py $(ELF) _$(ROM) bin/tail.bin 'tail'
	@echo "Updated tail.bin!"

clean:
	rm -f *.o
	rm -f *.map
	rm -f *.elf
	rm -rf $(CBUILDDIR)
	# rm -f *.gba
	rm -f $(COMPRESSED_TEXT_ARCHIVES_DIR)/*.lz
	rm -f $(COMPRESSED_TEXT_ARCHIVES_DIR)/*.bin

syms: $(SYM)

$(SYM): $(ELF)
	$(OBJDUMP) -t $< | sort -u | grep -E "^0[23689]" | perl -p -e 's/^(\w{8}) (\w).{6} \S+\t(\w{8}) (\S+)$$/\1 \2 \3 \4/g' > $@

nogbasyms: $(NOGBASYM)

$(NOGBASYM): $(ELF)
	$(OBJDUMP) -t $< | sort -u | grep -E "^0" | perl -p -e 's/^(\w{8}) (\w).{6} \S+\t(\w{8}) (\S+)$$/\1 \4/g' > $@

# ---------------------------------------------------------------------
# Verification harness (Rust + libmgba — see issues/concerns/10)
# ---------------------------------------------------------------------

FN_SYMS = tools/function_symbols.txt

# Extract function-entry symbols from bn6f_orig.elf.
function-symbols: $(FN_SYMS)

$(FN_SYMS): bn6f_orig.elf
	$(OBJDUMP) -t bn6f_orig.elf | awk '/ F .text/ { print "0x" $$1, $$NF }' > $@
	@wc -l $@

# Build the Rust function-tracker binary.
track-build:
	cd tools/bn6f-track && cargo build --release

# Smoke test: load ROM, advance FRAMES, print PC twice (determinism check).
FRAMES ?= 300
smoke: track-build $(ROM)
	tools/bn6f-track/target/release/bn6f-track $(abspath $(ROM)) $(FRAMES)

# Function tracker: run FRAMES of no-input boot, hook every entry in
# the symbol table, dump sorted hit counts. Overridable: FRAMES, TRACK_OUTPUT.
TRACK_OUTPUT ?= build/track_hits.txt
track: track-build $(FN_SYMS) $(ROM)
	@mkdir -p $(dir $(TRACK_OUTPUT))
	tools/bn6f-track/target/release/bn6f-track \
		$(abspath $(ROM)) $(FRAMES) \
		$(abspath $(FN_SYMS)) $(abspath $(TRACK_OUTPUT))
	@head -6 $(TRACK_OUTPUT)

# Verify decompiled functions match the ASM oracle via per-call
# (entry, exit) state diff.  All fixtures live under
# tests/fixtures/demos/bk2/ as BizHawk movies; each .bk2 ships with a
# pre-extracted .ss + .input pair (run tools/bk2_extract.py to refresh
# from the .bk2 file).  The top-level `verify` target plays every bk2
# through to the end and diffs the (entry, exit) per-call snapshots
# between the original ROM and the in-progress decompile build.
#
# Workflow per bk2 (driven by `verify-state` under the hood):
#   1. Build original ROM, restore the savestate, replay the input
#      stream, and capture entry snapshots for every DECOMP_FN_ADDR.
#      Compute "expected exits" via isolated (IRQ-disabled) re-runs.
#   2. Build decompile ROM and replay each captured entry — also via
#      isolated runs — capturing the "actual exit". Diff vs expected.
#   3. Report pass/fail per function; exit nonzero on any mismatch.
#
# As more functions are converted, append their entry addresses to
# DECOMP_FN_ADDRS.

# Verbosity for verify*. Default quiet:
#   - record skips its per-target name dump (just prints the count)
#   - replay only prints FAIL lines, not PASS lines
#   - inner `make all` / `make decompile` run with -s (no recipe echo,
#     errors still surface to stderr)
# VERIFY_VERBOSE=1 restores all of the above.
VERIFY_VERBOSE ?= 0
REPLAY_FLAGS = $(if $(filter-out 0,$(VERIFY_VERBOSE)),--verbose,)
VERBOSE_FLAG = $(if $(filter-out 0,$(VERIFY_VERBOSE)),--verbose,)
# Pass `-s` to sub-makes when quiet, so the assembler doesn't echo
# every `arm-none-eabi-as foo.s -o foo.o` line during verify's inner builds.
SUBMAKE_QUIET = $(if $(filter-out 0,$(VERIFY_VERBOSE)),,-s)

# Hash-dedup of identical entry snapshots per target. Default on:
# long bk2 runs hammer the same per-frame poll thousands of times
# with identical state, all of which would test the same code path.
# Set VERIFY_DEDUP=0 to keep every occurrence.
VERIFY_DEDUP ?= 1

# Frame-progress heartbeat during the emulation phase of record. 0
# disables. Heartbeat prints `i/n frames` to stderr every N frames.
VERIFY_PROGRESS_EVERY ?= 3000

RECORD_FLAGS = \
	$(if $(filter 0,$(VERIFY_DEDUP)),--no-dedup,) \
	$(if $(filter-out 0,$(VERIFY_PROGRESS_EVERY)),--progress $(VERIFY_PROGRESS_EVERY),) \
	$(VERBOSE_FLAG)

# Resolve manifest symbols to addresses via the function symbol table.
# (function-symbols depends on bn6f_orig.elf, which `verify` builds first.)
DECOMP_FN_ADDRS = $(shell awk 'NR==FNR { if ($$1 !~ /^[[:space:]]*#/ && NF>0) want[$$1]=1; next } want[$$2] { print $$1 }' $(DECOMP_MANIFEST) $(FN_SYMS) 2>/dev/null)

# Replay each bk2 demo through to the end and diff every call against
# the original ROM.  Frame count for each bk2 is derived from its
# .input file size (one u16 of joypad state packed as 4 bytes per
# frame).
DEMOS_ROOT = tests/fixtures/demos

# Stable per-flavor ROM artefacts. `all` and `decompile` both write
# the same $(ROM) path via the shared $(ELF) → $(ROM) rule, so we
# pre-build both flavors serially and copy them to distinct names
# before handing off to the verify orchestrator.
ROM_ORIG_BUILT   = build/bn6f_orig.gba
ROM_DECOMP_BUILT = build/bn6f_decomp.gba

# Record-output cache. Per-function snapshots keyed on
# (orig_rom_sha, bk2_sha). Steady-state decomp work (only the decomp
# ROM changes between iterations) becomes a full cache hit and skips
# the whole record pass.
VERIFY_CACHE_DIR ?= .verify-cache

# Cross-bk2 parallelism inside the orchestrator. One emulation thread
# per bk2; the inner rayon pool (used by isolated runs and replay)
# is shared, so we don't need to clamp like the old `make -j` fan-out
# did. Defaults to nproc.
VERIFY_PARALLEL ?= $(shell nproc)

verify: track-build $(FN_SYMS) | build
	@$(MAKE) $(SUBMAKE_QUIET) --no-print-directory all
	@cp $(ROM) $(ROM_ORIG_BUILT)
	@$(MAKE) $(SUBMAKE_QUIET) --no-print-directory decompile
	@cp $(ROM) $(ROM_DECOMP_BUILT)
	tools/bn6f-track/target/release/bn6f-track verify-all \
		--orig $(abspath $(ROM_ORIG_BUILT)) \
		--decomp $(abspath $(ROM_DECOMP_BUILT)) \
		--symbols $(abspath $(FN_SYMS)) \
		--demos-root $(abspath $(DEMOS_ROOT)) \
		--cache-dir $(abspath $(VERIFY_CACHE_DIR)) \
		--parallel $(VERIFY_PARALLEL) \
		$(DECOMP_FN_ADDRS)

# `verify-state` is the per-scene worker `verify` dispatches to.
# Useful directly if you want to run a single bk2 (or some other
# state-replay demo) on its own:
#
#   make verify-state STATE_NAME=bk2/intro STATE_FRAMES=6239
#
# Override STATE_FILE / STATE_INPUT explicitly to bypass auto-resolve
# for ad-hoc demos outside the tree.
STATE_NAME    ?=
STATE_SESSION  = tests/fixtures/calls/$(STATE_NAME)

# Auto-resolve STATE_FILE: folder mode first (test has its own dir),
# then flat (test is named <category>/<name>.ss alongside its
# siblings). `wildcard` lets `.ss`, `.ss1`, `.ss2` all match — mGBA's
# GUI writes `.ss1` by default. Pick the first hit.
ifndef STATE_FILE
STATE_FILE := $(firstword \
    $(wildcard $(DEMOS_ROOT)/$(STATE_NAME)/state.ss*) \
    $(wildcard $(DEMOS_ROOT)/$(STATE_NAME).ss*))
endif
# Same dance for STATE_INPUT (optional — empty if no match).
ifndef STATE_INPUT
STATE_INPUT := $(firstword \
    $(wildcard $(DEMOS_ROOT)/$(STATE_NAME)/inputs.input) \
    $(wildcard $(DEMOS_ROOT)/$(STATE_NAME).input))
endif

# STATE_FRAMES default: derive from STATE_INPUT size (4 bytes per
# frame of joypad state) when an input file exists, else 600. Set
# explicitly on the command line to override for ad-hoc demos.
ifndef STATE_FRAMES
ifneq ($(strip $(STATE_INPUT)),)
STATE_FRAMES := $(shell echo $$(( $$(stat -c %s $(STATE_INPUT)) / 4 )))
else
STATE_FRAMES := 600
endif
endif

# Ad-hoc wrapper: ensure build prereqs are in place, then run the
# verify body. The `verify` fan-out skips this wrapper and calls
# verify-state-impl directly because re-evaluating the prereqs from
# parallel workers races on clean-conditional-objs.
verify-state: track-build $(FN_SYMS)
	@$(MAKE) $(SUBMAKE_QUIET) --no-print-directory verify-state-impl

.PHONY: verify-state-impl
verify-state-impl:
ifeq ($(strip $(STATE_NAME)),)
	$(error STATE_NAME not set — e.g. make verify-state STATE_NAME=bk2/intro)
endif
ifeq ($(strip $(STATE_FILE)),)
	$(error no savestate found for "$(STATE_NAME)" — looked for $(DEMOS_ROOT)/$(STATE_NAME)/state.ss* and $(DEMOS_ROOT)/$(STATE_NAME).ss*)
endif
	@echo "[verify-state $(STATE_NAME)] state=$(STATE_FILE) input=$(or $(STATE_INPUT),<none>)"
ifeq ($(strip $(ROM_ORIG_PREBUILT)),)
	@$(MAKE) $(SUBMAKE_QUIET) --no-print-directory all
endif
	@rm -rf $(STATE_SESSION)
	@mkdir -p $(STATE_SESSION)
	@tools/bn6f-track/target/release/bn6f-track record \
		$(abspath $(or $(ROM_ORIG_PREBUILT),$(ROM))) $(STATE_FRAMES) $(abspath $(FN_SYMS)) \
		$(abspath $(STATE_SESSION)) \
		--state $(abspath $(STATE_FILE)) \
		$(if $(STATE_INPUT),--input $(abspath $(STATE_INPUT)),) \
		$(RECORD_FLAGS) $(DECOMP_FN_ADDRS)
	@echo
	@echo "[verify-state $(STATE_NAME)] building decompile ROM and replaying..."
ifeq ($(strip $(ROM_DECOMP_PREBUILT)),)
	@$(MAKE) $(SUBMAKE_QUIET) --no-print-directory decompile
endif
	tools/bn6f-track/target/release/bn6f-track replay \
		$(abspath $(or $(ROM_DECOMP_PREBUILT),$(ROM))) $(abspath $(STATE_SESSION)) $(REPLAY_FLAGS)

# Convenience: list every test that's been authored under demos/.
list-demos:
	@find $(DEMOS_ROOT) \( -name '*.ss*' -o -name 'state.ss*' \) \
		| sed -E 's|$(DEMOS_ROOT)/||; s|\.ss[0-9]*$$||; s|/state$$||' \
		| sort -u
