## Copyright 2025 Dean Hall, see LICENSE for details
##

import blinky, hard_fault, krnl
import plat/[boot, plat, reset]

proc main() {.noreturn.} =
  boot.boot()
  # TODO: project-specific boot
  plat.init()
  var k: Krnl
  krnl.init(addr k)

  switchToRamVectorTable()
  exitPrivilegedMode()

  initBlinky(ActrPriority(20))
  plat.lowPowerRunForever()

when isMainModule:
  main()
