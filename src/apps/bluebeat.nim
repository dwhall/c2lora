## Copyright 2026 Dean Hall See LICENSE for details
##
## The Heartbeat Actr toggles an LED when it receives an event.
## It uses a Blue LED connected to pin: P1.04/LED2/RAK19007
##

import bsp/led
import proj/[proj, proj_timers]
import krnl_intf/[actr, effects, signal, syscall]

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
  newActr(bluebeat, 4, priority, bluebeatHandler)
  ledToBlink = led
  initLed(ledToBlink) # TODO: move to handler's @INIT case
  syscallRegisterActr(addr bluebeat)
  syscallSubscribe(addr bluebeat, SigSysHeartbeat)
