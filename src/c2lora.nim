import startup
import p

# RAK19007 Blue  LED2 == p15 on 40p CPU slot == P1.04/LED2
# RAK19007 Green LED1 == p14 on 40p CPU slot == P1.03/LED1

proc delay(t: int) =
  var n = t
  while n > 0:
    dec n
    var x {.volatile.} = 500
    while x > 0:
      dec x

proc main() {.exportc.} =
  const ledPinNum = 4
  const ledPinBit = 1'u32 shl ledPinNum
  P1.DIRSET = ledPinBit
  while true:
    P1.OUTSET = ledPinBit
    delay(1000)

    P1.OUTCLR = ledPinBit
    delay(1000)
