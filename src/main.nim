## Copyright 2025 Dean Hall, see LICENSE for details
##

import blinky, hard_fault, krnl
import plat/[boot, plat]

#proc default_Handler() {.exportc, noconv.} =
#  discard

proc bootPrj() =
  discard

proc initPrj() =
  initBlinky(ActrPriority(20))

when isMainModule:
  boot.boot()
  bootPrj()
  plat.init()
  var k = new Krnl
  krnl.init(k)
  initPrj()
  plat.lowPowerRunForever()
