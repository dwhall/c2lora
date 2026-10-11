## Copyright 2025 Dean Hall, see LICENSE for details
##

import bsp/led, debug_rtt
import proj/[proj, proj_timers]
import heartbeat, hard_fault, krnl
import krnlpkg/[syscall, systimer]
import plat/[boot, plat, reset, timer]

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
  mainHeartbeat(priority = 20, led = Led1Green)
  exitPrivilegedMode()
  proj.lowPowerRunForever()

when isMainModule:
  main()
