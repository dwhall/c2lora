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
  heartbeatLed = Led1Green
  pingPongLed = Led2Blue
  SigPing = Sig("tbd.app.pingpong", 0)
  SigPong = Sig("tbd.app.pingpong", 1)
  pingEvent = Event(sig: SigPing, val: 0)
  pongEvent = Event(sig: SigPong, val: 0)

var
  heartbeat: Actr
  ping, pong: Actr
  heartbeatLedState: bool

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
    setLed(pingPongLed, true)
    discard syscallPostEvent(addr ping, pongEvent)
    RetHandled
  else:
    RetUnhandled

proc heartbeatHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall, forbids: [PrivilegedModeEffect].} =
  case sig
  of SigSysHeartbeat:
    setLed(heartbeatLed, heartbeatLedState)
    heartbeatLedState = not heartbeatLedState
    RetHandled
  else:
    RetUnhandled

proc mainPingPong* =
  ping.initActr(4, 1.ActrPriority, pingHandler)
  pong.initActr(4, 2.ActrPriority, pongHandler)
  heartbeat.initActr(4, 3.ActrPriority, heartbeatHandler)
  initLed(pingPongLed)
  initLed(heartbeatLed)
  discard syscallRegisterActr(addr ping)
  discard syscallRegisterActr(addr pong)
  discard syscallRegisterActr(addr heartbeat)
  discard syscallSubscribe(addr heartbeat, SigSysHeartbeat)
  discard syscallPostEvent(addr ping, pongEvent)
