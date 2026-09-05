## Copyright 2026 Dean Hall See LICENSE for details
##
## Platform-specific definitions for the nrf52 processor
##

import nrf52840/device

func irqCnt*(): int {.compileTime.} =
  48

func fpuAvail*(): bool {.compileTime.} =
  cpu.fpuAvail

func nvicPriorityBits*(): int {.compileTime.} =
  cpu.nvicPriorityBits
