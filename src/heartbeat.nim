## Copyright 2026 Dean Hall See LICENSE for details
##
## The Heartbeat Actr toggles an LED when it receives an event.
## It uses a Blue LED connected to pin: P1.04/LED2/RAK19007
##

import bsp/led
import plat/timer
import proj/proj
import krnl

const sysHeartbeatSig = Sig("tbd.sys.heartbeat", 0)

var
  heartbeat: Actr
  ledToBlink: BspLed
  ledState: bool

proc heartbeatHandler(
    self: var Actr, sig: Signal, val: EventValue
): HandlerReturn {.nimcall.} =
  case sig
  of sysHeartbeatSig:
    setLed(ledToBlink, ledState)
    ledState = not ledState
    RetHandled
  else:
    RetUnhandled

proc timerCallback() {.nimcall.} =
  ## Executes in Handler/privileged mode.
  ## Sends an event to the heartbeat Actr
  var count {.global.} = 0'u32
  let sysHeartbeatEvnt = Event(sig: sysHeartbeatSig, val: count)
  inc count
  heartbeat.post(sysHeartbeatEvnt)

proc mainHeartbeat*(priority: ActrPriority, led: BspLed, intervalMs: uint32) =
  heartbeat.initActr(4, priority)
  heartbeat.eventHandler = heartbeatHandler
  ledToBlink = led
  initLed(ledToBlink) # TODO: move to handler's @INIT case
  discard syscallRegisterActr(addr heartbeat)
  let intervalTicks = intervalMs * 32768 div 1000
  configureTimer(intervalTicks, timerCallback)
