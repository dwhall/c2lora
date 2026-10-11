## Copyright 2025 Dean Hall, see LICENSE for details
##

import bsp/led, proj, debug_rtt
import heartbeat, hard_fault, krnl
import krnlpkg/syscall
import plat/[boot, plat, reset, timer]

var k: Krnl

proc init() =
  initRTT()
  boot.boot()
  # TODO: project-specific boot
  plat.init()
  initKrnl(addr k, rtc1Timer)

proc main() {.noreturn.} =
  init()
  switchToRamVectorTable()
  exitPrivilegedMode()
  mainHeartbeat(priority = 20, led = Led1Green)
  proj.lowPowerRunForever()

when isMainModule:
  main()
