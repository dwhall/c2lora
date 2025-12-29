# Copyright 2025 Dean Hall, see LICENSE for details

import nrf52840/p
import timer, reset, hard_fault, debug_rtt

proc default_Handler() {.exportc, noconv.} =
  # TODO: clear interrupt
  discard

const
  bluePinBit = 1'u32 shl 4 # P1.04/LED2/RAK19007 Blue
  timerInterval = 3277'u32 # ~100 ms

proc timerCallback =
    var ledState {.global, volatile.} = false
    ledState = not ledState
    if ledState:
      P1.OUTSET = bluePinBit
    else:
      P1.OUTCLR = bluePinBit

proc main() =
  discard debugRTTwriteStr(0, "Hello from Nim!\n")
  debugRTTprintf(0, "Counter: %d\n", 42)
  P1.DIRSET = bluePinBit
  configureTimer(timerInterval, timerCallback)
  while true:
    asm "  wfi \n"

when isMainModule:
  main()
