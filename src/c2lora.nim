import nrf52840/[p, timer]
import cm4f/nvic
import reset, hard_fault

const
  bluePinBit = 1'u32 shl 4 # P1.04/LED2/RAK19007 Blue
  timer0Bit = 1'u32 shl irqTIMER0 # TIMER0 interrupt bit in NVIC

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
  NVIC.NVIC_ISER_0 = timer0Bit # Enable TIMER0 interrupt in NVIC

  TIMER0.TASKS_START = 1

proc TIMER0_IRQHandler() {.exportc, noconv.} =
  var ledState {.global, volatile.} = false
  ledState = not ledState
  if ledState:
    P1.OUTSET = bluePinBit
  else:
    P1.OUTCLR = bluePinBit
  NVIC.NVIC_ICPR_0 = timer0Bit # Clear TIMER0 interrupt in NVIC

proc main() =
  P1.DIRSET = bluePinBit
  configureNRFTimer100ms()
  while true:
    waitForInterrupt()

when isMainModule:
  main()
