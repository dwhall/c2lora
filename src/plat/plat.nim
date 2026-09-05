## Copyright 2026 Dean Hall See LICENSE for details
##
## Platform-specific definitions needed by KRNL
##

type Platform* =
  concept
      ## The quantity of interrupts (not exceptions) available in the processor
      func irqCnt(): int {.compileTime.}
      ## Whether the processor has a floating point unit (FPU)
      func fpuAvail(): bool {.compileTime.}
      ## The number of priority bits implemented in the NVIC
      func nvicPriorityBits(): int {.compileTime.}

const platform {.strdefine.} = ""
when platform == "nrf52":
  include plat_nrf52
else:
  {.error: "`platform` MUST be defined to a value with a match in plat.nim".}
