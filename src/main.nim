## Copyright 2025 Dean Hall, see LICENSE for details
##

import blinky, hard_fault, krnl
import plat/[boot, plat]

#proc default_Handler() {.exportc, noconv.} =
#  discard

when isMainModule:
  boot.boot()
  # TODO: project-specific boot
  plat.init()
  var k: Krnl
  init(addr k)

  exitPrivilegedMode()

  initBlinky(ActrPriority(20))
  plat.lowPowerRunForever()
