{.compile: "vector_table.c".}
{.compile: "stubs.c".}
{.compile: "std.c".}
{.compile: "section_init.c".}

import cm4f/scb
import debug_rtt

proc NimMain() {.importc: "NimMain".}
proc copyDataSection() {.importc, cdecl.}
proc zeroBssSection() {.importc, cdecl.}

let c_vectorTableAddress {.importc: "vectorTableAddress".}: cint

proc Reset_Handler() {.exportc, noconv.} =
  SCB.VTOR = c_vectorTableAddress.uint32
  copyDataSection()
  zeroBssSection()
  rttInit()
  NimMain() # this will call the nim module given to the nim compiler
