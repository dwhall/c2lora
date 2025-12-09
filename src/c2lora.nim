import nrf52840/p
import reset

const
  standardDelay = 1000
  longDelay = 5000
  bluePinBit = 1'u32 shl 4 # P1.04/LED2/RAK19007 Blue
  greenPinBit = 1'u32 shl 3 # P1.03/LED1/RAK19007 Green

proc readIpsr(): uint32 {.inline.} =
  asm """
    mrs %0, ipsr
    : "=r"(`result`)
  """

func waitBlocking(ticks: int) =
  var outerTicks = ticks
  while outerTicks > 0:
    dec outerTicks
    var innerTicks {.volatile.} = standardDelay
    while innerTicks > 0:
      dec innerTicks

proc blinkLed(pinBit: static uint32, delay: int) =
  P1.OUTSET = pinBit
  waitBlocking(delay)
  P1.OUTCLR = pinBit
  waitBlocking(delay)

proc default_Handler() {.exportc, noconv.} =
  ## Blinks green LED based on IPSR value
  let ipsr = readIpsr()
  P1.DIRSET = greenPinBit
  while true:
    for i in 0 ..< ipsr:
      blinkLed(greenPinBit, standardDelay)
    waitBlocking(longDelay)

proc main() =
  P1.DIRSET = bluePinBit
  var s = @[1, 2, 3]
  while true:
    # Blink Blue LED based on length of s to prove dynamic memory works
    for _ in 0 ..< s.len:
      blinkLed(bluePinBit, standardDelay)
    waitBlocking(longDelay)
    s.add(5)

when isMainModule:
  main()
