## Copyright 2026 Dean Hall See LICENSE for details
##
## Platform-specific definitions for the nrf52 processor
##

import nrf52840/[clock, device]

#### Platform constants

func irqCnt*(): int {.compileTime.} =
  48

func fpuAvail*(): bool {.compileTime.} =
  cpu.fpuAvail

func nvicPriorityBits*(): int {.compileTime.} =
  cpu.nvicPriorityBits

#### Platform initialization

proc initClocks() =
  # Start the low-frequency clock (LFCLK)
  # Source: Internal RC oscillator (0) or external 32.768 kHz crystal (1)
  CLOCK.TASKS_LFCLKSTOP.TASKS_LFCLKSTOP(1)
  CLOCK.LFCLKSRC.write(0)
  CLOCK.TASKS_LFCLKSTART.TASKS_LFCLKSTART(1)

  # Wait for LFCLK to start
  while CLOCK.EVENTS_LFCLKSTARTED.uint32 == 0:
    discard
  CLOCK.EVENTS_LFCLKSTARTED.EVENTS_LFCLKSTARTED(0)

proc init*() =
  initClocks()
