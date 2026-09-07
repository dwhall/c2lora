## Copyright 2026 Dean Hall See LICENSE for details
##
## KRNL: Vector Table definition for ARM Cortex-M device
##
## This module defines the RAM-based vector table used by KRNL.
## See docs/VectorTable.md for details.
##
## Reference:
##     https://developer.arm.com/documentation/ddi0403/latest
##     DDI0403E_e_armv7m_arm.pdf
##     B1.5 Armv7-M exception model
##

{.compile: "vector_table_nrf52.c".}

import plat

type
  ExnHandler = proc()
  IrqHandler* = proc()
  VectorTable* = object
    stackPointer: uint32
    exnHandler: array[1 .. 16, ExnHandler]
    irqHandler: array[IrqNmbr, IrqHandler]

  RamVectorTable* = VectorTable

func setIrqHandler*(self: var VectorTable, irqNmbr: IrqNmbr, handler: IrqHandler) =
  ## Sets the interrupt handler for the given interrupt number.
  self.irqHandler[irqNmbr] = handler

func findIrqHandler*(self: VectorTable, handler: IrqHandler): int =
  self.irqHandler.find(handler)

# The non-volatile Vector Table used at power-on-reset; from vector_table.c
let c_vectorTable* {.importc: "c_vectorTable", used.}: VectorTable

proc initRamVectorTable*(vt: var RamVectorTable, initIsr: IrqHandler) =
  vt.stackPointer = c_vectorTable.stackPointer
  vt.exnHandler = c_vectorTable.exnHandler
  for handler in vt.irqHandler.mitems:
    handler = initIsr
