{.warning[UnusedImport]: off.}
import startup
{.warning[UnusedImport]: on.}

proc entry() {.exportc: "entry".} =
  
  # Main loop
  while true:
    discard