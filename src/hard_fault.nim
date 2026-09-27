## Copyright 2026 Dean Hall See LICENSE for details
##
## Handler for the ARM core Hard Fault exception
##

import armv7m/[core, nvic, scb]
import bsp/led
import plat/debug_rtt

# The fault_Handler overrides the weak symbol in the vector table.
# Any hard fault will trigger this handler, despite no reference from
# the main module.  So we silence a compiler warning by marking it as...
{.used.}

const
  standardDelay = 1000
  longDelay = 5000
  ledToBlink = Led2Blue # blue is bad

func waitBlocking(ticks: int) =
  var outerTicks = ticks
  while outerTicks > 0:
    dec outerTicks
    var innerTicks {.volatile.} = standardDelay
    while innerTicks > 0:
      dec innerTicks

proc blinkLed(led: BspLed, delay: int) =
  setLed(led, true)
  waitBlocking(delay)
  setLed(led, false)
  waitBlocking(delay)

type StackedFrame = object
  r0, r1, r2, r3, r12, lr, pc, xpsr: uint32

proc faultHandlerBody(
    frame: ptr StackedFrame, excReturn: uint32
) {.exportc: "faultHandlerBody", noconv, noreturn.} =
  ## Blinks the LED a number of times to match the exception number.
  ## Repeats the count after a noticeable pause.
  # Fault handler exceptions are higher priority than SysTick
  # which prevents SysTick from interrupting this handler;
  # so we must use blocking waits to flash the LED
  let exnNmbr = IPSR.read().EXN_NUMBER().uint32

  # Print the contents of some fault status registers.
  # SCB fault-status registers are only meaningful while the fault is still
  # active, i.e. read them here rather than after blinking.
  let cfsr = SCB.CFSR.read().uint32
  let hfsr = SCB.HFSR.read().uint32
  let mmfar = SCB.MMFAR.read().uint32
  let bfar = SCB.BFAR.read().uint32
  debugRTTprintf(
    0, "KRNL fault_Handler: exn=%d cfsr=0x%08x hfsr=0x%08x mmfar=0x%08x bfar=0x%08x\n",
    exnNmbr, cfsr, hfsr, mmfar, bfar,
  )

  # Extra state to diagnose exception-return faults (e.g. INVPC).
  # EXC_RETURN and stacked frame are those of the exception that faulted
  # (for INVPC, the stacked PC is the faulting exception-return point).
  debugRTTprintf(
    0,
    "  EXC_RETURN=0x%08x frame@0x%08x pc=0x%08x lr=0x%08x xpsr=0x%08x\n",
    excReturn,
    cast[uint32](frame),
    frame.pc,
    frame.lr,
    frame.xpsr,
  )
  debugRTTprintf(
    0, "  r0=0x%08x r1=0x%08x r2=0x%08x r3=0x%08x r12=0x%08x\n", frame.r0, frame.r1,
    frame.r2, frame.r3, frame.r12,
  )
  # SHCSR: active/pending system exceptions; ICSR: RETTOBASE, VECTACTIVE, VECTPENDING
  # IABR: which external IRQs are active (nested ISRs show up here)
  # IPR0 holds IRQs 0..3 priority; IPR4 holds IRQs 16..19 (RTC1 = IRQ 17)
  debugRTTprintf(
    0,
    "  shcsr=0x%08x icsr=0x%08x ccr=0x%08x iabr0=0x%08x iabr1=0x%08x\n",
    SCB.SHCSR.read().uint32,
    SCB.ICSR.read().uint32,
    SCB.CCR.read().uint32,
    NVIC.NVIC_IABR(0).read().uint32,
    NVIC.NVIC_IABR(1).read().uint32,
  )
  debugRTTprintf(
    0,
    "  ispr0=0x%08x ispr1=0x%08x ipr0=0x%08x ipr4=0x%08x\n",
    NVIC.NVIC_ISPR(0).read().uint32,
    NVIC.NVIC_ISPR(1).read().uint32,
    NVIC.NVIC_IPR(0).read().uint32,
    NVIC.NVIC_IPR(4).read().uint32,
  )

  initLed(ledToBlink)
  while true:
    for i in 0'u32 ..< exnNmbr:
      blinkLed(ledToBlink, standardDelay)
    waitBlocking(longDelay)

proc fault_Handler() {.exportc, noconv, asmNoStackFrame.} =
  ## Captures EXC_RETURN and the stacked frame before any prologue
  ## touches LR or SP, then tail-calls the body.
  asm """
    mov   r1, lr        // EXC_RETURN is in R1
    tst   lr, #4        // EXC_RETURN bit 2: 0 = exn used MSP, 1 = used PSP
    ite   eq
    mrseq r0, msp
    mrsne r0, psp       // ptr to StackedFrame is in R0
    b faultHandlerBody
  """
