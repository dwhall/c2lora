{.compile: "vector_table.c".}
{.compile: "stubs.c".}
{.compile: "std.c".}
{.compile: "linker_symbols.c".}

import cm4f/scb
import debug_rtt

proc NimMain() {.importc: "NimMain".}

let
  c_etext {.importc: "etext".}: ptr UncheckedArray[cuint]
  c_data_start {.importc: "data_start".}: ptr UncheckedArray[cuint]
  c_data_end {.importc: "data_end".}: ptr cuint
  c_bss_start {.importc: "bss_start".}: ptr UncheckedArray[cuint]
  c_bss_end {.importc: "bss_end".}: ptr cuint
  c_vectorTableAddress {.importc: "vectorTableAddress".}: cint

proc copyDataSection =
  var i = 0
  while addr(c_data_start[i]) < c_data_end:
    c_data_start[i] = c_etext[i]
    inc i

proc zeroBssSection =
  var i = 0
  while addr(c_bss_start[i]) < c_bss_end:
    c_bss_start[i] = 0'u32
    inc i

proc Reset_Handler() {.exportc, noconv.} =
  SCB.VTOR = c_vectorTableAddress.uint32
  copyDataSection()
  zeroBssSection()
  rttInit()
  NimMain() # this will call the nim module given to the nim compiler
