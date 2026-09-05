## Copyright 2025 Dean Hall, see LICENSE for details
##

import armv7m/core
import blinky, clocks, hard_fault, krnl

#proc default_Handler() {.exportc, noconv.} =
#  discard

proc bootPrj() =
  initClocks()

proc initPrj() =
  let p = ActrPriority(20)
  initBlinky(p)

proc main() {.noreturn.} =
  while true:
    WFI()

when isMainModule:
  var k = new Krnl
  boot()
  bootPrj()
  init(k)
  initPrj()
  main()
