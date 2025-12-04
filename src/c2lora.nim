{.compile: "vector_table.c".}
{.compile: "stubs.c".}
{.compile: "section_init.c".}
import nrf52840 / p

proc NimMain() {.importc: "NimMain".}
proc copyDataSection() {.importc, cdecl.}
proc zeroBssSection() {.importc, cdecl.}

const
  STANDARD_DELAY  = 1000
  LONG_DELAY      = 5000
  BLUE_PIN_BIT    = 1'u32 shl 4  # P1.04/LED2/RAK19007 Blue
  GREEN_PIN_BIT   = 1'u32 shl 3 # P1.03/LED1/RAK19007 Green

proc read_ipsr(): uint32 {.inline.} =
  asm """
    mrs %0, ipsr
    : "=r"(`result`)
  """

proc startDelay(ticks: int) {.inline, noSideEffect.} =
  var outerTicks = ticks

  while outerTicks > 0:
    dec outerTicks
    var innerTicks {.volatile.} = STANDARD_DELAY
    while innerTicks > 0:
      dec innerTicks

proc blink_LED(pinBit: static uint32, delay: int) =
  P1.OUTSET = pinBit
  startDelay(delay)
  P1.OUTCLR = pinBit
  startDelay(delay)

proc nim_default_handler() {.exportc: "nim_default_handler", noconv.} =
  var ipsr: uint32 = read_ipsr()

  # Blink Green LED based on IPSR value
  P1.DIRSET = GREEN_PIN_BIT
  while true:
    for i in 0 ..< ipsr:
      blink_LED(GREEN_PIN_BIT, STANDARD_DELAY)
    startDelay(LONG_DELAY)

proc main() =
  P1.DIRSET = BLUE_PIN_BIT
  var s = @[1, 2, 3]
  while true:
    # Blink Blue LED based on length of s to prove dynamic memory works
    for _ in 0..<s.len:
      blink_LED(BLUE_PIN_BIT, STANDARD_DELAY)
    startDelay(LONG_DELAY)
    s.add(5)

proc Reset_Handler() {.exportc, noconv.} =
  copyDataSection()
  zeroBssSection()
  NimMain()
  main()
  while true: discard
