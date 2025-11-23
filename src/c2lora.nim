import startup
import p

proc delay(t: int) =
  var n = t
  while n > 0:
    dec n
    var x {.volatile.} = 500
    while x > 0:
      dec x

proc main() =
  const ledPinNum = 4 # FIXME
  const ledPinBit = 1'u32 shl ledPinNum
  P0.DIR = ledPinBit # might need bit-invert depending on meaning of 0/1
  while true:
    # Turn LED on
    P0.OUTSET = ledPinBit
    delay(1000)
    # Turn LED off
    P0.OUTCLR = ledPinBit
    delay(1000)

proc entry() {.exportc: "entry".} =
  main()
  while true:
    discard