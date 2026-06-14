## Copyright 2026 Dean Hall See LICENSE for details
##
## Platform-specific definitions needed by KRNL
##

when platform == "nrf52":
  include "plat_nrf52.nim"
else:
  {.error: "`platform` MUST be defined to a value with a match in plat.nim".}
