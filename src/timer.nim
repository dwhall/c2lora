## Copyright 2025 Dean Hall, see LICENSE for details

import armv7m/nvic
import nrf52840/rtc
import krnl

var
  timerInterval: uint32
  timerCallback: proc()

proc configureTimer*(interval: uint32, callback: proc()) =
  timerInterval = interval
  timerCallback = callback

  RTC1.TASKS_STOP.TASKS_STOP(1) # Stop RTC
  RTC1.TASKS_CLEAR.TASKS_CLEAR(1) # Clear counter
  RTC1.PRESCALER.PRESCALER(0) # No prescaling: 32.768 kHz / (PRESCALER + 1)
  RTC1.CC(0).COMPARE(timerInterval) # 3277 ticks ≈ 100ms at 32.768 kHz

  RTC1.INTENSET.COMPARE0(1) # Enable interrupt upon COMPARE[0]
  NVIC.NVIC_ISER(0).read().SETENA(17, 1).write() # Enable interrupt on irq17/RTC1

  RTC1.TASKS_START.TASKS_START(1)

proc RTC1_IRQHandler*() {.exportc, noconv.} =
  debugPrint("Hello from RTC1 IRQ!\n")
  if RTC1.EVENTS_COMPARE.read().uint32 != 0:
    RTC1.EVENTS_COMPARE.write(0)
    let nextCompare = RTC1.CC(0).read().COMPARE().uint32 + timerInterval
    RTC1.CC(0).COMPARE(nextCompare)
    timerCallback()
    NVIC.NVIC_ICPR(0).CLRPEND(17, 1)
    while RTC1.EVENTS_COMPARE(0).read().EVENTS_COMPARE().uint32 != 0:
      discard # wait for event to clear
