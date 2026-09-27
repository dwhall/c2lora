## Copyright 2025 Dean Hall, see LICENSE for details

import armv7m/nvic
import nrf52840/rtc
import krnlpkg/syscall_intf

var
  timerInterval: uint32
  timerCallback: proc()

proc RTC1IrqHandler() {.noconv.} =
  if RTC1.EVENTS_COMPARE(0).read().uint32 != 0:
    RTC1.EVENTS_COMPARE(0).write(0)
    # FOUR clock cycles must happen after the above write
    # and before the proc returns
    # per nRF52840_PS_v1.11.pdf p.175
    let nextCompare = RTC1.CC(0).read().COMPARE().uint32 + timerInterval
    RTC1.CC(0).COMPARE(nextCompare)
    if timerCallback != nil:
      timerCallback()
    NVIC.NVIC_ICPR(0).CLRPEND(irq_RTC1, 1)

proc configureTimer*(interval: uint32, callback: proc()) =
  timerInterval = interval
  timerCallback = callback

  RTC1.TASKS_STOP.TASKS_STOP(1) # Stop RTC
  RTC1.TASKS_CLEAR.TASKS_CLEAR(1) # Clear counter
  RTC1.PRESCALER.PRESCALER(0) # No prescaling: 32.768 kHz / (PRESCALER + 1)
  RTC1.CC(0).COMPARE(timerInterval) # 3277 ticks ≈ 100ms at 32.768 kHz
  RTC1.INTENSET.COMPARE0(1) # Enable interrupt upon COMPARE[0]

  discard syscallRegisterIrqHandler(irq_RTC1, RTC1IrqHandler)

  RTC1.TASKS_START.TASKS_START(1)
