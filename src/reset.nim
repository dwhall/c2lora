{.compile: "vector_table.c".}
{.compile: "stubs.c".}
{.compile: "std.c".}
{.compile: "section_init.c".}

when defined(debug):
  {.passc: "-Ideps/RTT/RTT".}
  {.passc: "-Ideps/RTT/Config".}
  {.compile: "deps/RTT/RTT/SEGGER_RTT.c".}
  {.compile: "deps/RTT/RTT/SEGGER_RTT_printf.c".}

  proc rttInit*() {.importc: "SEGGER_RTT_Init", header: "SEGGER_RTT.h"}
  proc debugRTTwrite*(bufferIndex: cint, s: cstring, len: cint): cuint {.importc: "SEGGER_RTT_Write", header: "SEGGER_RTT.h".}
  proc debugRTTwriteStr*(bufferIndex: cint, s: cstring): cuint {.importc: "SEGGER_RTT_WriteString", header: "SEGGER_RTT.h".}
  proc debugRTTprintf*(bufferIndex: cint, format: cstring) {.importc: "SEGGER_RTT_printf", varargs, header: "SEGGER_RTT.h".}
else:
  proc SEGGER_RTT_Init*() {.inline, cdecl.} = discard
  proc debugRTTwrite*(bufferIndex: cint, s: cstring, len: cint): cuint {.inline, cdecl.} = discard
  proc debugRTTwriteStr*(bufferIndex: cint, s: cstring): cuint {.inline, cdecl.} = discard
  proc debugRTTprintf*(bufferIndex: cint, format: cstring) {.inline, cdecl, varargs.} = discard

import cm4f/scb

proc NimMain() {.importc: "NimMain".}
proc copyDataSection() {.importc, cdecl.}
proc zeroBssSection() {.importc, cdecl.}

proc Reset_Handler() {.exportc, noconv.} =
  SCB.VTOR = 0x00026000
  copyDataSection()
  zeroBssSection()
  rttInit()
  discard debugRTTwriteStr(0, "Hello from Nim!\n")
  debugRTTprintf(0, "Counter: %d\n", 42)
  NimMain() # this will call the nim module given to the nim compiler
