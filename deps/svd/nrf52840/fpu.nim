# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device
#!fmt: off

import metagenerator
export read, write

declarePeripheral(peripheralName = FPU, baseAddress = 0x40026000'u32, peripheralDesc = "FPU")
declareInterrupt(peripheralName = FPU, interruptName = FPU, interruptValue = 38, interruptDesc = "")
declareRegister(peripheralName = FPU, registerName = UNUSED, addressOffset = 0x000'u32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = false, registerDesc = "Unused.")
