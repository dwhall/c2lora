## Copyright 2025 Dean Hall, see LICENSE for details
##

import bsp/led
import plat/[boot, debug_rtt, plat, reset]
import plat/nrf52/timer_nrf52
import proj/[hard_fault, proj, proj_timers]
import krnl_impl/[krnl, syscall, systimer]
import apps/[heartbeat, pingpong]

var
  k: Krnl
  sysTmr: SysTimer

proc boot() =
  ## Initializations necessary for the bootloader
  bootPlat()
  # TODO: project-specific boot
  # TODO: bootloader

proc init() =
  ## Initializations necessary for the kernel
  initRTT() # project debug
  initPlat()
  initKrnl(addr k)

proc main() {.noreturn.} =
  boot()
  init()
  switchToRamVectorTable()
  mainSysTimer(addr sysTmr, rtc1Timer, projTimerDeclarationList, projTimerPrescaler)
  # Heartbeat must precede and be more urgent than pingpong, which doesn't yield
  mainHeartbeat(3, Led2Blue)
  mainPingPong(1, Led1Green) # uses priorities 1 and 2
  # TODO: mainKrnl() to send SigSysInit* to all registered Actrs
  exitPrivilegedMode()
  proj.lowPowerRunForever()

when isMainModule:
  main()
