## Copyright 2025 Dean Hall, see LICENSE for details
##

import krnl_impl/[krnl, syscall, systimer]
import plat/[boot, debug_rtt, plat, reset]
import plat/nrf52/timer_nrf52
import apps/[bluebeat, heartbeat]
import bsp/led
import proj/[hard_fault, proj, proj_timers]

var
  k: Krnl
  sysTmr: SysTimer

proc boot() =
  bootPlat()
  # TODO: project-specific boot
  # TODO: bootloader

proc init() =
  initRTT() # project debug
  initPlat()
  initKrnl(addr k)

proc main() {.noreturn.} =
  boot()
  init()
  switchToRamVectorTable()
  mainSysTimer(addr sysTmr, rtc1Timer, projTimerDeclarationList, projTimerPrescaler)
  mainHeartbeat(priority = 2, led = Led1Green)
  mainBluebeat(priority = 1, led = Led2Blue)
  exitPrivilegedMode()
  proj.lowPowerRunForever()

when isMainModule:
  main()
