/* Device Specific Linker script to configure memory regions. */
SEARCH_DIR(linkers)

MEMORY
{
  FLASH (rx)  : ORIGIN = 0x00026000, LENGTH = 824K
  RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 256K
}

INCLUDE "/common.ld"