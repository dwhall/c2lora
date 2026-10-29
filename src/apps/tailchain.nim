## Copyright 2026 Dean Hall See LICENSE for details
##
## The System Timer emits the SigSysHeartbeat events.
## The Ping and Pong Actrs are given priorities such that
## given simultaneous pending, Ping will execute before Pong.
## Ping sets the LED, Pong clears it.
##

import bsp/led
import proj/[proj, proj_timers]
import krnl_intf/[actr, effects, event, signal, syscall]

var
  ping, pong: Actr
  pingPongLed: BspLed

proc pingHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigSysHeartbeat:
    setLed(pingPongLed, true)
    RetHandled
  else:
    RetUnhandled

proc pongHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigSysHeartbeat:
    setLed(pingPongLed, false)
    RetHandled
  else:
    RetUnhandled

proc mainTailChain*(priority: ActrPriority, led: BspLed) =
  initActr(pong, 4, priority, pongHandler)
  initActr(ping, 4, succ priority, pingHandler) # higher priority executes before lower
  pingPongLed = led
  initLed(pingPongLed)
  syscallRegisterActr(addr ping)
  syscallSubscribe(addr ping, SigSysHeartbeat)
  syscallRegisterActr(addr pong)
  syscallSubscribe(addr pong, SigSysHeartbeat)
