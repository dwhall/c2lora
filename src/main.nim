## Copyright 2025 Dean Hall, see LICENSE for details
##

import blinky, hard_fault, krnl
import plat/[boot, plat]

#proc default_Handler() {.exportc, noconv.} =
#  discard

proc bootPrj() =
  discard

proc initPrj() =
  let p = ActrPriority(20)
  initBlinky(p)

proc main() {.noreturn.} =
  while true:
    plat.restUntilInterrupt()

when isMainModule:
  var k = new Krnl
  boot.boot()
  bootPrj()
  plat.init()
  krnl.init(k)
  initPrj()
  main()
