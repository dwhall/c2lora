## Copyright 2026 Dean Hall See LICENSE for details
##
## Platform-specific definitions needed by KRNL
##

import armv7m/core

type Platform* =
  concept
      ## Compile time constants
      ## The quantity of interrupts (not exceptions) available in the processor
      func irqCnt(): int {.compileTime.}
      ## Whether the processor has a floating point unit (FPU)
      func fpuAvail(): bool {.compileTime.}
      ## The number of priority bits implemented in the NVIC
      func nvicPriorityBits(): int {.compileTime.}

      ## Run time functions
      ## Platform initialization
      func init()
      ## Infinite loop that waits for interrupts in low-power state
      proc lowPowerRunForever() {.inline, noreturn.}

const platform {.strdefine.} = ""
when platform == "nrf52":
  include plat_nrf52
else:
  {.error: "`platform` MUST be defined to a value with a match in plat.nim".}

proc lowPowerRunForever*() {.inline, noreturn.} =
  while true:
    WFI()
