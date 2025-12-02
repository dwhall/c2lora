{.compile: "vector_table.c".}

import nrf52840 / p


# Forward declaration
proc NimMain() {.importc: "NimMain".}


proc delay(t: int) =
  var n = t
  while n > 0:
    dec n
    var x {.volatile.} = 1000
    while x > 0:
      dec x

proc main() =
  const greenPinBit = 1'u32 shl 3 # P1.03/LED1/RAK19007 Green
  const bluePinBit = 1'u32 shl 4  # P1.04/LED2/RAK19007 Blue
  P1.DIRSET = greenPinBit or bluePinBit
  while true:
    P1.OUTSET = greenPinBit or bluePinBit
    delay(1000)
    P1.OUTCLR = greenPinBit or bluePinBit
    delay(1000)

proc Reset_Handler() {.exportc, noconv.} =
  #NimMain()  # FIXME: unmet dependencies
  main()
  while true: discard
