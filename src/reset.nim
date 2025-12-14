{.compile: "vector_table.c".}
{.compile: "stubs.c".}
{.compile: "std.c".}
{.compile: "section_init.c".}

proc NimMain() {.importc: "NimMain".}
proc copyDataSection() {.importc, cdecl.}
proc zeroBssSection() {.importc, cdecl.}

proc Reset_Handler() {.exportc, noconv.} =
  copyDataSection()
  zeroBssSection()
  NimMain() # this will call the nim module given to the nim compiler
