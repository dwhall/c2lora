# Copyright 2025 Dean Hall, see LICENSE for details

import armv7m/core
import nrf52840/p
import clocks, timer, reset, hard_fault, krnl

# Hardware: P1.04/LED2/RAK19007 Blue

proc default_Handler() {.exportc, noconv.} =
  # TODO: clear interrupt
  discard

const timerInterval = 3277 # ~100 ms

proc timerCallback() =
  var ledState {.global, volatile.} = false
  ledState = not ledState
  if ledState:
    P1.OUTSET.PIN4(1)
  else:
    P1.OUTCLR.PIN4(1)

proc main() =
  P1.DIRSET.PIN4(1)
  P1.OUTSET.PIN4(1) # DWH DEBUG

  initClocks()
  configureTimer(timerInterval, timerCallback)
  while true:
    WFI()

when isMainModule:
  main()
