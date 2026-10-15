## Copyright 2026 Dean Hall See LICENSE for details
##
## The Heartbeat Actr toggles an LED when it receives the heartbeat event.
## The Ping and Pong Actrs send events to each other to toggle a second LED
## so rapidly that it appears to be solid to the human eye.
##

import bsp/led
import proj/proj
import krnl_intf/[actr, effects, event, signal, syscall]

const
  SigPing = Sig("tbd.app.pingpong", 0)
  SigPong = Sig("tbd.app.pingpong", 1)
  pingEvent = Event(sig: SigPing, val: 0)
  pongEvent = Event(sig: SigPong, val: 0)

var
  ping, pong: Actr
  pingPongLed: BspLed

proc pingHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigPong:
    setLed(pingPongLed, true)
    discard syscallPostEvent(addr pong, pingEvent)
    RetHandled
  else:
    RetUnhandled

proc pongHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigPing:
    setLed(pingPongLed, false)
    discard syscallPostEvent(addr ping, pongEvent)
    RetHandled
  else:
    RetUnhandled

proc mainPingPong*(priority: ActrPriority, led: BspLed) =
  initActr(ping, 4, priority, pingHandler)
  initActr(pong, 4, succ priority, pongHandler)
  pingPongLed = led
  initLed(pingPongLed)
  discard syscallRegisterActr(addr ping)
  discard syscallRegisterActr(addr pong)
  discard syscallPostEvent(addr ping, pongEvent)
