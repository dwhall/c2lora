## Copyright 2026 Dean Hall See LICENSE for details
##
## The Heartbeat Actr toggles an LED when it receives the heartbeat event.
##

import bsp/led
import proj/[proj, proj_timers]
import krnl_intf/[actr, effects, signal, syscall]

var
  heartbeat: Actr
  ledToBlink: BspLed
  ledState: bool

proc heartbeatHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigSysHeartbeat:
    setLed(ledToBlink, ledState)
    ledState = not ledState
    RetHandled
  else:
    RetUnhandled

proc mainHeartbeat*(priority: ActrPriority, led: BspLed) =
  heartbeat.initActr(4, priority, heartbeatHandler)
  ledToBlink = led
  initLed(ledToBlink) # TODO: move to handler's @INIT case
  discard syscallRegisterActr(addr heartbeat)
  discard syscallSubscribe(addr heartbeat, SigSysHeartbeat)
