## Copyright 2026 Dean Hall See LICENSE for details
##
## The Heartbeat Actr toggles an LED when it receives an event.
## It uses a Blue LED connected to pin: P1.04/LED2/RAK19007
##

import bsp/led
import proj/[proj, proj_timers]
import krnl
import krnlpkg/[effects, signal]

var
  bluebeat: Actr
  ledToBlink: BspLed
  ledState: bool

proc bluebeatHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigSysHeartbeat:
    setLed(ledToBlink, ledState)
    ledState = not ledState
    RetHandled
  else:
    RetUnhandled

proc mainBluebeat*(priority: ActrPriority, led: BspLed) =
  bluebeat.initActr(4, priority, bluebeatHandler)
  ledToBlink = led
  initLed(ledToBlink) # TODO: move to handler's @INIT case
  discard syscallRegisterActr(addr bluebeat)
  discard syscallSubscribe(addr bluebeat, SigSysHeartbeat)
