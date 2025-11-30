include startup
import p

# RAK19007 Blue  LED2 == p15 on 40p CPU slot == P1.04/LED2
# RAK19007 Green LED1 == p14 on 40p CPU slot == P1.03/LED1

proc delay(t: int) =
  var n = t
  while n > 0:
    dec n
    var x {.volatile.} = 1000
    while x > 0:
      dec x

proc main() =
  const greenPinBit = 1'u32 shl 3
  const bluePinBit = 1'u32 shl 4
  P1.DIRSET = greenPinBit or bluePinBit
  while true:
    P1.OUTSET = greenPinBit or bluePinBit
    delay(1000)
    P1.OUTCLR = greenPinBit or bluePinBit
    delay(1000)
