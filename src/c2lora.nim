## Copyright 2025 Dean Hall, see LICENSE for details
##

import armv7m/core
import blinky, clocks, timer, reset, hard_fault, krnl

proc default_Handler() {.exportc, noconv.} =
  discard

proc bootPrj() =
  initClocks()

proc initPrj() =
  initBlinky(42)

proc main() {.noreturn.} =
  while true:
    WFI()

when isMainModule:
  boot()
  bootPrj()
  init()
  initPrj()
  main()
