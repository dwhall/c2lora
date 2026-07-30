## Copyright 2026 Dean Hall See LICENSE for details
##
## The Blinky Actr toggles an LED when it receives an event.
## It uses a Blue LED connected to pin: P1.04/LED2/RAK19007
##

import nrf52840/p
import krnl

const N = 4
var
  blinky: Actr[N]
  ledState: bool

proc initLed() =
  ## Inits P1.04 as an output, off/low
  ledState = false
  P1.OUTCLR.PIN4(1)
  P1.DIRSET.PIN4(1)

proc toggleLed() =
  ledState = not ledState
  if ledState:
    P1.OUTSET.PIN4(1)
  else:
    P1.OUTCLR.PIN4(1)

proc blinkyHandler(self: Actr[N], event: Event): HandlerReturn {.nimcall.} =
  ## Toggles the LED on ANY event
  toggleLed()

proc initBlinky*(priority: ActrPriority) =
  initLed()
  blinky.priority = priority
  blinky.eventHandler = blinkyHandler
