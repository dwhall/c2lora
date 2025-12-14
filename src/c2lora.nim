import nrf52840/p
import nrf52840/timer
import cm4f/nvic
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

proc fault_Handler() {.exportc, noconv.} =
  ## Blinks green LED based on IPSR value
  # Fault handlers are higher priority than SysTick
  # which prevents SysTick from interrupting this handler;
  # so we must use blocking waits to flash the LED
  let ipsr = readIpsr()
  P1.DIRSET = greenPinBit
  while true:
    for i in 0 ..< ipsr:
      blinkLed(greenPinBit, standardDelay)
    waitBlocking(longDelay)

proc default_Handler() {.exportc, noconv.} =
  # TODO: clear interrupt
  discard

proc waitForInterrupt() {.inline.} =
  asm """
    wfi
  """

proc configureNRFTimer100ms() =
  # Reference:
  # https://docs.nordicsemi.com/bundle/ps_nrf52840/page/timer.html

  TIMER0.TASKS_STOP  = 1
  TIMER0.TASKS_CLEAR = 1

  TIMER0.MODE        = 0
  TIMER0.BITMODE     = 2 # 24 Bit mode
  TIMER0.PRESCALER   = 4 # 1MHz timer frequency (Cutoff for timer using PCLK1M instead of PCLK16M)

  TIMER0.SHORTS      = 1 shl 0 # COMPARE0_CLEAR
  TIMER0.CC0         = 100000;

  TIMER0.INTENSET = 1 shl 16  # COMPARE0 interrupt enable
  NVIC.NVIC_ISER_0 = 1 shl 8 # Enable TIMER0 interrupt in NVIC

  TIMER0.TASKS_START = 1

proc TIMER0_IRQHandler() {.exportc, noconv.} =
  var ledState {.global, volatile.} = false
  ledState = not ledState
  if ledState:
    P1.OUTSET = bluePinBit
  else:
    P1.OUTCLR = bluePinBit

proc main() =
  P1.DIRSET = bluePinBit
  configureNRFTimer100ms()
  while true:
    waitForInterrupt()

when isMainModule:
  main()
