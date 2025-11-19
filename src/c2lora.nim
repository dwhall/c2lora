{.warning[UnusedImport]: off.}
import startup
{.warning[UnusedImport]: on.}

proc entry() {.exportc: "entry".} =
  var s = @[1,2,3]
  s.add(5)
  # Main loop
  while true:
    discard