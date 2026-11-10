## Copyright 2026 Dean Hall See LICENSE for details
##
## The Heartbeat Actr toggles an LED when it receives the heartbeat event.
##

import bsp/led
import proj/[proj, proj_timers]
import krnl_intf/[actr, effects, signal, syscall]

type HeartbeatActr = object of Actr
  ledToBlink: BspLed
  ledState: bool

var heartbeat: HeartbeatActr

proc heartbeatHandler(
    self: var HeartbeatActr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigSysHeartbeat:
    setLed(self.ledToBlink, self.ledState)
    self.ledState = not self.ledState
    RetHandled
  else:
    RetUnhandled

proc mainHeartbeat*(priority: ActrPriority, led: BspLed) =
  initActr(heartbeat, 4, priority, heartbeatHandler)
  heartbeat.ledToBlink = led
  initLed(heartbeat.ledToBlink) # TODO: move to handler's @SigSysInit case
  syscallRegisterActr(addr heartbeat)
  syscallSubscribe(addr heartbeat, SigSysHeartbeat)
