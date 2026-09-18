## Copyright 2025 Dean Hall, see LICENSE for details
##

import debug_rtt
import blinky, hard_fault, krnl
import krnlpkg/syscall
import plat/[boot, plat, reset]

var k: Krnl

proc main() {.noreturn.} =
  initRTT()
  boot.boot()
  # TODO: project-specific boot
  plat.init()
  krnl.init(addr k)

  switchToRamVectorTable()
  exitPrivilegedMode()

  initBlinky(ActrPriority(20))
  plat.lowPowerRunForever()

when isMainModule:
  main()
