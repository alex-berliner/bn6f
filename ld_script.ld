OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)

MEMORY
{
    ewram_region (w!x) : ORIGIN = 0x02000000, LENGTH = 0x40000
    iwram_region (w!x) : ORIGIN = 0x03000000, LENGTH = 0x8000
    vram_region (w!x) : ORIGIN = 0x06000000, LENGTH = 0x18000
    rom_region (rx) : ORIGIN = 0x08000000, LENGTH = 0x800000
}

SECTIONS
{
    INCLUDE "constants.ld"

    ewram_2000000 (NOLOAD) :
    ALIGN(4)
    {
        build/ewram.o(ewram_2000000);
    } >ewram_region

    OVERLAY . :
    {
        ewram_battle { build/ewram.o(ewram_battle); }
        ewram_2034000 { build/ewram.o(ewram_2034000); }
    } >ewram_region

    iwram (NOLOAD) :
    ALIGN(4)
    {
        build/iwram.o(.data);
    } >iwram_region

    vram_6000000 (NOLOAD) :
    ALIGN(4)
    {
        build/vram.o(vram_6000000);
    } >vram_region
    
    /* start of ROM */

    .text :
    {
        build/rom.o(.text);
    } >rom_region

    iwram_text :
    {
        build/iwram.o(.text);
    } >iwram_region AT>rom_region
    
    .data :
    ALIGN(4)
    {
        build/data.o(.data);
    } >rom_region

    .fill :
    {
        FILL(0xff);
        . = ORIGIN(rom_region) + LENGTH(rom_region) - 1;
        BYTE(0xff);
    } >rom_region
}
