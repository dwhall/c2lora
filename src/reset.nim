{.compile: "vector_table.c".}
{.compile: "stubs.c".}
{.compile: "std.c".}

import armv7m/scb
import debug_rtt

proc NimMain() {.importc: "NimMain".}

let # from linker script
  c_etext {.importc: "__etext".}: ptr UncheckedArray[cuint]
  c_data_start {.importc: "__data_start__".}: ptr UncheckedArray[cuint]
  c_data_end {.importc: "__data_end__".}: ptr cuint
  c_bss_start {.importc: "__bss_start__".}: ptr UncheckedArray[cuint]
  c_bss_end {.importc: "__bss_end__".}: ptr cuint

let # from project source
  c_vectorTableAddress {.importc: "vectorTableAddress".}: cint

proc copyDataSection() =
  var i = 0
  while addr(c_data_start[i]) < c_data_end:
    c_data_start[i] = c_etext[i]
    inc i

proc zeroBssSection() =
  var i = 0
  while addr(c_bss_start[i]) < c_bss_end:
    c_bss_start[i] = 0'u32
    inc i

proc Reset_Handler() {.exportc, noconv.} =
  SCB.VTOR.TBLOFF(c_vectorTableAddress.uint32)
  copyDataSection()
  zeroBssSection()
  rttInit()
  NimMain() # this will call the nim module given to the nim compiler
