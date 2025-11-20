# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device

import metagenerator

#!fmt: off
declarePeripheral(peripheralName = SWI0, baseAddress = 0x40014000'u32, peripheralDesc = "Software interrupt 0")
declareInterrupt(peripheralName = SWI0, interruptName = SWI0_EGU0, interruptValue = 20, interruptDesc = "")
declareRegister(peripheralName = SWI0, registerName = UNUSED, addressOffset = 0x000'u32, readAccess = true, writeAccess = false, registerDesc = "Unused.")
declarePeripheral(peripheralName = SWI1, baseAddress = 0x40015000'u32, peripheralDesc = "Software interrupt 0")
declareInterrupt(peripheralName = SWI1, interruptName = SWI1_EGU1, interruptValue = 21, interruptDesc = "")
declareRegister(peripheralName = SWI1, registerName = UNUSED, addressOffset = 0x000'u32, readAccess = true, writeAccess = false, registerDesc = "Unused.")
declarePeripheral(peripheralName = SWI2, baseAddress = 0x40016000'u32, peripheralDesc = "Software interrupt 0")
declareInterrupt(peripheralName = SWI2, interruptName = SWI2_EGU2, interruptValue = 22, interruptDesc = "")
declareRegister(peripheralName = SWI2, registerName = UNUSED, addressOffset = 0x000'u32, readAccess = true, writeAccess = false, registerDesc = "Unused.")
declarePeripheral(peripheralName = SWI3, baseAddress = 0x40017000'u32, peripheralDesc = "Software interrupt 0")
declareInterrupt(peripheralName = SWI3, interruptName = SWI3_EGU3, interruptValue = 23, interruptDesc = "")
declareRegister(peripheralName = SWI3, registerName = UNUSED, addressOffset = 0x000'u32, readAccess = true, writeAccess = false, registerDesc = "Unused.")
declarePeripheral(peripheralName = SWI4, baseAddress = 0x40018000'u32, peripheralDesc = "Software interrupt 0")
declareInterrupt(peripheralName = SWI4, interruptName = SWI4_EGU4, interruptValue = 24, interruptDesc = "")
declareRegister(peripheralName = SWI4, registerName = UNUSED, addressOffset = 0x000'u32, readAccess = true, writeAccess = false, registerDesc = "Unused.")
declarePeripheral(peripheralName = SWI5, baseAddress = 0x40019000'u32, peripheralDesc = "Software interrupt 0")
declareInterrupt(peripheralName = SWI5, interruptName = SWI5_EGU5, interruptValue = 25, interruptDesc = "")
declareRegister(peripheralName = SWI5, registerName = UNUSED, addressOffset = 0x000'u32, readAccess = true, writeAccess = false, registerDesc = "Unused.")
