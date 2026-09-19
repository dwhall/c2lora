## Copyright 2025 Dean Hall, see LICENSE for details
##

import debug_rtt
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
  mainHeartbeat(priority = ActrPriority(20), intervalMs = 1000)
  plat.lowPowerRunForever()

when isMainModule:
  main()
