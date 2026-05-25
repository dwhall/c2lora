# Copyright 2025 Dean Hall, see LICENSE for details

import std/strformat
import armv7m/core
import nrf52840/p
import timer, reset, hard_fault, debug_rtt

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

proc exerciseDebugPrint() =
  debugPrint("Hello from Nim!\n")
  let letters = ['a', 'b', 'z', '\n']
  debugPrint(letters)
  var answer = 42
  debugPrint(fmt"The Answer: {answer}")

proc main() =
  #exerciseDebugPrint()
  P1.DIRSET.PIN4(1)
  P1.OUTSET.PIN4(1) # DWH DEBUG

  configureTimer(timerInterval, timerCallback)
  while true:
    WFI()

when isMainModule:
  main()
