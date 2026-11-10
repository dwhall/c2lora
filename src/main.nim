## Copyright 2025 Dean Hall, see LICENSE for details
##

import bsp/led
import plat/[boot, debug_rtt, plat, reset]
import plat/nrf52/timer_nrf52
import proj/[hard_fault, proj, proj_timers]
import krnl_impl/[krnl, syscall, systimer]
import apps/[heartbeat, tailchain, pingpong]

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
  mainSysTimer(addr sysTmr, rtc1Timer, projTimerDeclList, projTimerPrescaler)
  when false:
    # show heartbeat and run pingpong
    mainHeartbeat(3, Led2Blue)
    mainPingPong(1, Led1Green)
  else:
    # compare pingpong and tailchain
    mainPingPong(3, Led2Blue)
    mainTailChain(1, Led1Green)
  # TODO: mainKrnl()?
  exitPrivilegedMode()
  # TODO: send SigSysInit* to all registered Actrs after exiting privileged mode
  proj.lowPowerRunForever()

when isMainModule:
  main()
