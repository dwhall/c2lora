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
  proc rttInit*() {.inline.} = discard
  proc debugRTTwrite*(bufferIndex: cint, s: cstring, len: cint): cuint {.inline.} = discard
  proc debugRTTwriteStr*(bufferIndex: cint, s: cstring): cuint {.inline.} = discard
  proc debugRTTprintf*(bufferIndex: cint, format: cstring) {.inline, varargs.} = discard

