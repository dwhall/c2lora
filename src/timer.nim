# Copyright 2025 Dean Hall, see LICENSE for details

import armv7m/nvic
import nrf52840/[clock, rtc]
import debug_rtt

var
  timerInterval: uint32
  timerCallback: proc()

proc configureTimer*(interval: uint32, callback: proc()) =
  timerInterval = interval
  timerCallback = callback

  # Start the low-frequency clock (LFCLK)
  # Source: Internal RC oscillator (0) or external 32.768 kHz crystal (1)
  CLOCK.TASKS_LFCLKSTOP.TASKS_LFCLKSTOP(1'u32)
  CLOCK.LFCLKSRC.write(0'u32)
  CLOCK.TASKS_LFCLKSTART.TASKS_LFCLKSTART(1'u32)

  # Wait for LFCLK to start
  while CLOCK.EVENTS_LFCLKSTARTED.uint32 == 0:
    discard
  CLOCK.EVENTS_LFCLKSTARTED.EVENTS_LFCLKSTARTED(0'u32)

  #  RTC1.TASKS_STOP.TASKS_STOP(1) # Stop RTC
  RTC1.TASKS_STOP.write(1) # Stop RTC
  RTC1.TASKS_CLEAR.TASKS_CLEAR(1) # Clear counter
  RTC1.PRESCALER.PRESCALER(0) # No prescaling: 32.768 kHz / (PRESCALER + 1)
  RTC1.CC(0).COMPARE(timerInterval) # 3277 ticks ≈ 100ms at 32.768 kHz

  RTC1.INTENSET.COMPARE0(1) # Enable interrupt upon COMPARE[0]
  NVIC.NVIC_ISER(0).read().SETENA(17, 1).write() # Enable interrupt on irq17/RTC1

  RTC1.TASKS_START.TASKS_START(1)

proc RTC1_IRQHandler*() {.exportc, noconv.} =
  discard debugRTTwrite(0, "Hello from RTC1 IRQ!\n", 25)
  if RTC1.EVENTS_COMPARE.read().uint32 != 0:
    RTC1.EVENTS_COMPARE.write(0'u32)
    let nextCompare = RTC1.CC(0).read().COMPARE().uint32 + timerInterval
    RTC1.CC(0).COMPARE(nextCompare)
    timerCallback()
    NVIC.NVIC_ICPR(0).CLRPEND(17, 1'u32)
    while RTC1.EVENTS_COMPARE(0).read().EVENTS_COMPARE().uint32 != 0'u32:
      discard # wait for event to clear
