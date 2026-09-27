## Copyright 2025 Dean Hall, see LICENSE for details
##

import bsp/led, proj, debug_rtt
import heartbeat, hard_fault, krnl
import krnlpkg/syscall
import plat/[boot, plat, reset]

var k: Krnl

proc init() =
  initRTT()
  boot.boot()
  # TODO: project-specific boot
  plat.init()
  initKrnl(addr k)

proc main() {.noreturn.} =
  init()
  switchToRamVectorTable()
  exitPrivilegedMode()
  mainHeartbeat(priority = 20, led = Led1Green, intervalMs = 1000)
  proj.lowPowerRunForever()

when isMainModule:
  main()
