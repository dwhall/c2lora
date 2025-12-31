# Copyright 2025 Dean Hall, see LICENSE for details

import std/strformat
import cm4f/core
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

proc exerciseDebugPrint =
  debugPrint("Hello from Nim!\n")
  let letters = ['a', 'b', 'z', '\n']
  debugPrint(letters)
  var answer = 42
  debugPrint(fmt"The Answer: {answer}")

proc main() =
  exerciseDebugPrint()
  P1.DIRSET = bluePinBit
  configureTimer(timerInterval, timerCallback)
  while true:
    WFI()

when isMainModule:
  main()
