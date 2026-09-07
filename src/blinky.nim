## Copyright 2026 Dean Hall See LICENSE for details
##
## The Blinky Actr toggles an LED when it receives an event.
## It uses a Blue LED connected to pin: P1.04/LED2/RAK19007
##

import bsp/led
import proj/proj
import krnl

const ledToBlink = Led2Blue
var
  blinky: Actr
  ledState: bool

proc blinkyHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall.} =
  ## Toggles the LED on ANY event
  setLed(ledToBlink, ledState)
  ledState = not ledState

proc initBlinky*(priority: ActrPriority) =
  blinky.initActr(4, priority)
  blinky.eventHandler = blinkyHandler
  initLed(ledToBlink) # TODO: move to handler's @INIT case
  discard syscallRegisterActr(addr blinky)
