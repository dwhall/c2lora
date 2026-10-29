## Copyright 2026 Dean Hall See LICENSE for details
##
## The Heartbeat Actr toggles an LED when it receives the heartbeat event.
## The Ping and Pong Actrs send events to each other to toggle a second LED
## so rapidly that it appears to be solid to the human eye.
##

import bsp/led
import proj/[proj, proj_timers]
import krnl_intf/[actr, effects, event, signal, syscall]

const
  SigPing = Sig("tbd.app.pingpong", 0)
  pingEvent = Event(sig: SigPing, val: 0)

var
  ping, pong: Actr
  pingPongLed: BspLed

proc pingHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigSysHeartbeat:
    setLed(pingPongLed, true)
    syscallPostEvent(addr pong, pingEvent)
    RetHandled
  else:
    RetUnhandled

proc pongHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigPing:
    setLed(pingPongLed, false)
    RetHandled
  else:
    RetUnhandled

proc mainPingPong*(priority: ActrPriority, led: BspLed) =
  initActr(pong, 4, priority, pongHandler)
  initActr(ping, 4, succ priority, pingHandler)
  pingPongLed = led
  initLed(pingPongLed)
  syscallRegisterActr(addr ping)
  syscallSubscribe(addr ping, SigSysHeartbeat)
  syscallRegisterActr(addr pong)
