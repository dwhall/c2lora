## Copyright 2025 Dean Hall, see LICENSE for details
##

import bsp/led, proj, debug_rtt
import heartbeat, hard_fault, krnl
import krnlpkg/syscall
import plat/[boot, plat, reset, timer]

var k: Krnl

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
  mainKrnl(rtc1Timer)
  mainHeartbeat(priority = 20, led = Led1Green)
  exitPrivilegedMode()
  proj.lowPowerRunForever()

when isMainModule:
  main()
