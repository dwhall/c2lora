# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device

import metagenerator

#!fmt: off
declarePeripheral(peripheralName = CRYPTOCELL, baseAddress = 0x5002A000'u32, peripheralDesc = "ARM TrustZone CryptoCell register interface")
declareInterrupt(peripheralName = CRYPTOCELL, interruptName = CRYPTOCELL, interruptValue = 42, interruptDesc = "")
declareRegister(peripheralName = CRYPTOCELL, registerName = ENABLE, addressOffset = 0x500'u32, readAccess = true, writeAccess = true, registerDesc = "Enable CRYPTOCELL subsystem")
declareField(peripheralName = CRYPTOCELL, registerName = ENABLE, fieldName = ENABLE, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Enable or disable the CRYPTOCELL subsystem")
