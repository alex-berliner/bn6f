# binary tools used in build
MAKE = make
AS = tools/binutils/bin/arm-none-eabi-as
LD = tools/binutils/bin/arm-none-eabi-ld
OBJCOPY = tools/binutils/bin/arm-none-eabi-objcopy
OBJDUMP := tools/binutils/bin/arm-none-eabi-objdump
GBAGFX = tools/gbagfx/gbagfx
SHA1SUM = sha1sum
PY = py

# project paths
SRC = src
ASMDIR = src/asm
BIN = $(ASMDIR)/bin
CONST = constants
INC = src/asm/include
LDDIR = ld
OBJ = build/

# project files (translation units live in $(ASMDIR), include their parts via -I$(ASMDIR))
SFILES = rom.s data.s ewram.s iwram.s vram.s

# to keep track of compressed files and to build decompressed versions into them
# defines rules to build and compress lz files
include lz_assets.mk

OFILES = $(addprefix $(OBJ),$(SFILES:.s=.o))
BUILD_NAME = bn6f
ROM = $(OBJ)$(BUILD_NAME).gba
ELF = $(OBJ)$(BUILD_NAME).elf
SYM = $(OBJ)$(BUILD_NAME).sym
NOGBASYM = $(OBJ)bn6f_nogba.sym

# build flags
# -I.       : resolves "include/...", "constants/...", "src/..." from repo root
# -I$(ASMDIR): resolves the content includes under src/asm/ ("asm/..." ->
#              src/asm/asm, "data/..." -> src/asm/data, "maps/..." -> src/asm/maps,
#              and the TUs' sibling includes "iwram_data.s" etc.)
COMPLIANCE_FLAGS = -g -I$(INC) -I. -I$(ASMDIR)
WFLAGS =
ARCH = -mcpu=arm7tdmi -march=armv4t -mthumb -mthumb-interwork
CDEBUG =
CFLAGS =
ASFLAGS = $(ARCH) $(WFLAGS) $(COMPLIANCE_FLAGS) --agbasm-colonless-labels --agbasm-colon-defined-global-labels --agbasm-local-labels --agbasm-multiline-macros \
	--agbasm-charmap --agbasm-no-gba-thumb-after-label-disasm-fix

ASDEBUGFLAGS = --agbasm-debug $(@:.o=.dump)
# -L$(LDDIR): find the INCLUDE'd constants.ld; -L$(OBJ): ld_script.ld places
# sections from bare object names (ewram.o, rom.o, ...) now built into $(OBJ).
LDFLAGS = -Map $(OBJ)$(BUILD_NAME).map -L$(LDDIR) -L$(OBJ)
LIB =

.PHONY: setup-toolchain syms assets checksum fdiff tail clean nogbasyms

# One-time toolchain install: clones + builds the agbasm binutils fork and
# agbcc, installing arm-none-eabi-{as,ld,objcopy,objdump} into tools/binutils
# and agbcc into tools/agbcc, then builds gbagfx. Idempotent. Not wired into
# the normal build graph — run it once after checkout (see INSTALL.md).
AGBCC_SRC = tools/agbcc-src
AGBCC_URL = https://github.com/luckytyphlosion/agbcc
AGBCC_BRANCH = new_layout_with_libs
setup-toolchain:
	@if [ -x $(AS) ] && [ -x tools/agbcc/bin/agbcc ]; then \
		echo "[setup-toolchain] toolchain already present."; \
	else \
		[ -d $(AGBCC_SRC) ] || git clone --branch $(AGBCC_BRANCH) --recursive $(AGBCC_URL) $(AGBCC_SRC); \
		$(MAKE) -C $(AGBCC_SRC) -j"$$(nproc)" && $(MAKE) -C $(AGBCC_SRC) install prefix=$(CURDIR) || exit $$?; \
		test -x $(AS) || { echo "setup-toolchain: $(AS) still missing after install" >&2; exit 1; }; \
	fi
	@$(MAKE) -C tools/gbagfx
	@test -x $(GBAGFX) || { echo "setup-toolchain: gbagfx build did not produce $(GBAGFX)" >&2; exit 1; }
	@echo "[setup-toolchain] done."

# TODO: INTEGRATE SCAN INCLUDES

all: $(ROM)
	@$(SHA1SUM) -c $(BUILD_NAME).sha1

$(ROM): $(ELF)
	$(OBJCOPY) -O binary $(ELF) $(ROM)

$(ELF): $(OFILES)
	$(LD) $(LDFLAGS) -o $(ELF) -T $(LDDIR)/ld_script.ld $(LIB)

$(OBJ)%.o: $(ASMDIR)/%.s
	@mkdir -p $(OBJ)
	$(AS) $(ASFLAGS) $< -o $@

assets: $(LZ_FILES) $(LZ_BINFILES)

checksum:
	@$(SHA1SUM) -c $(BUILD_NAME).sha1

fdiff:
	$(PY) tools/fdiff.py $(BUILD_NAME).ign $(ROM) -s2

tail: $(ROM)
	@# Create tail.bin using the tail location in current elf then compile again
	$(PY) tools/gen_obj_tail.py $(ELF) _$(ROM) $(BIN)/tail.bin 'tail'
	@echo "Updated tail.bin!"

clean:
	rm -f $(OBJ)*.o
	rm -f $(OBJ)*.map
	rm -f $(OBJ)*.elf
	rm -f $(COMPRESSED_TEXT_ARCHIVES_DIR)/*.lz
	rm -f $(COMPRESSED_TEXT_ARCHIVES_DIR)/*.bin

syms: $(SYM)

$(SYM): $(ELF)
	$(OBJDUMP) -t $< | sort -u | grep -E "^0[23689]" | perl -p -e 's/^(\w{8}) (\w).{6} \S+\t(\w{8}) (\S+)$$/\1 \2 \3 \4/g' > $@

nogbasyms: $(NOGBASYM)

$(NOGBASYM): $(ELF)
	$(OBJDUMP) -t $< | sort -u | grep -E "^0" | perl -p -e 's/^(\w{8}) (\w).{6} \S+\t(\w{8}) (\S+)$$/\1 \4/g' > $@
