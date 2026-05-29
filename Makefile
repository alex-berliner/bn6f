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

OBJ = build/
OFILES = $(addprefix $(OBJ),$(SFILES:.s=.o))
BUILD_NAME = build/bn6f
ROM = $(BUILD_NAME).gba
ELF := $(ROM:.gba=.elf)
SYM = $(ROM:.gba=.sym)
NOGBASYM = build/bn6f_nogba.sym

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

.PHONY: setup-toolchain syms decompile orig validate function-symbols list-demos clean-conditional-objs

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
	@$(SHA1SUM) -c bn6f.sha1

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
CONDITIONAL_OFILES = build/rom.o

.PHONY: clean-conditional-objs
# Force-rebuild rom.o AND the decomp-flags file every `make decompile`
# / `make all`. The flags file's $(DECOMP_FLAGS_FILE) → $(DECOMP_MANIFEST)
# dependency is timestamp-based and breaks when a stash/restore pattern
# (e.g. `make videos`) uses mv on the manifest — the restored file
# inherits the bak's older mtime and make considers flags.txt up to
# date with empty content. Always regenerate.
clean-conditional-objs:
	@rm -f $(CONDITIONAL_OFILES) $(DECOMP_FLAGS_FILE)

$(ROM): $(ELF)
	$(OBJCOPY) -O binary $(ELF) $(ROM)

# Explicit ELF rules so each ELF lands at its own path (the old pattern
# rule `%.elf: $(OFILES)` hard-coded `-o $(ELF)` regardless of target,
# producing the wrong filename when building bn6f_orig.elf).
$(ELF): clean-conditional-objs $(OFILES)
	$(LD) $(LDFLAGS) -o $@ -T ld_script.ld $(OFILES) $(LIB)

build/bn6f_orig.elf: clean-conditional-objs $(OFILES)
	$(LD) $(LDFLAGS) -o $@ -T ld_script.ld $(OFILES) $(LIB)

build/%.o: %.s | build
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

orig: build/bn6f_orig.elf
	@echo "Saved build/bn6f_orig.elf"

validate: build/bn6f_orig.elf $(ELF)
	$(PY) tools/validate_asm.py build/bn6f_orig.elf $(ELF)

assets: $(LZ_FILES) $(LZ_BINFILES)
	

checksum:
	@$(SHA1SUM) -c bn6f.sha1

fdiff:
	$(PY) tools/fdiff.py $(BUILD_NAME).ign $(ROM) -s2

tail: $(ROM)
	@# Create tail.bin using the tail location in current elf then compile again
	$(PY) tools/gen_obj_tail.py $(ELF) _$(ROM) bin/tail.bin 'tail'
	@echo "Updated tail.bin!"

clean:
	rm -f build/*.o build/*.elf build/*.map build/*.gba build/*.sym build/*.dump
	rm -f *.o *.map *.elf *.dump *.sym
	rm -rf $(CBUILDDIR)
	rm -f $(COMPRESSED_TEXT_ARCHIVES_DIR)/*.lz
	rm -f $(COMPRESSED_TEXT_ARCHIVES_DIR)/*.bin

syms: $(SYM)

$(SYM): $(ELF)
	$(OBJDUMP) -t $< | sort -u | grep -E "^0[23689]" | perl -p -e 's/^(\w{8}) (\w).{6} \S+\t(\w{8}) (\S+)$$/\1 \2 \3 \4/g' > $@

nogbasyms: $(NOGBASYM)

$(NOGBASYM): $(ELF)
	$(OBJDUMP) -t $< | sort -u | grep -E "^0" | perl -p -e 's/^(\w{8}) (\w).{6} \S+\t(\w{8}) (\S+)$$/\1 \4/g' > $@

# ---------------------------------------------------------------------
# Function-symbol extraction (orig-ROM function entry addresses)
# ---------------------------------------------------------------------

FN_SYMS = tools/function_symbols.txt

# Extract function-entry symbols from bn6f_orig.elf.
function-symbols: $(FN_SYMS)

$(FN_SYMS): build/bn6f_orig.elf
	$(OBJDUMP) -t build/bn6f_orig.elf | awk '/ F .text/ { print "0x" $$1, $$NF }' > $@
	@wc -l $@


# === harness (bn6f-track) removed; new validator lives at tools/bn6f-validate/ ===

list-demos:
	@find $(DEMOS_ROOT) \( -name '*.ss*' -o -name 'state.ss*' \) \
		| sed -E 's|$(DEMOS_ROOT)/||; s|\.ss[0-9]*$$||; s|/state$$||' \
		| sort -u
