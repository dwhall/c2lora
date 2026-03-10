# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device
#!fmt: off

import metagenerator
export read, write

declarePeripheral(peripheralName = APPROTECT, baseAddress = 0x40000000'u32, peripheralDesc = "Access Port Protection")
declareRegister(peripheralName = APPROTECT, registerName = FORCEPROTECT, addressOffset = 0x550'u32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, registerDesc = "Software force enable APPROTECT mechanism until next reset.")
declareField(peripheralName = APPROTECT, registerName = FORCEPROTECT, fieldName = FORCEPROTECT, bitOffset = 0, bitWidth = 8, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Write 0x0 to force enable APPROTECT mechanism")
declareRegister(peripheralName = APPROTECT, registerName = DISABLE, addressOffset = 0x558'u32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, registerDesc = "Software disable APPROTECT mechanism")
declareField(peripheralName = APPROTECT, registerName = DISABLE, fieldName = DISABLE, bitOffset = 0, bitWidth = 8, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Software disable APPROTECT mechanism")
