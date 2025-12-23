{.compile: "vector_table.c".}
{.compile: "stubs.c".}
{.compile: "std.c".}
{.compile: "section_init.c".}

import cm4f/scb

proc NimMain() {.importc: "NimMain".}
proc copyDataSection() {.importc, cdecl.}
proc zeroBssSection() {.importc, cdecl.}

proc Reset_Handler() {.exportc, noconv.} =
  SCB.VTOR = 0x00026000
  copyDataSection()
  zeroBssSection()
  NimMain() # this will call the nim module given to the nim compiler
