# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device

import metagenerator

#!fmt: off
declarePeripheral(peripheralName = ECB, baseAddress = 0x4000E000'u32, peripheralDesc = "AES ECB Mode Encryption")
declareInterrupt(peripheralName = ECB, interruptName = ECB, interruptValue = 14, interruptDesc = "")
declareRegister(peripheralName = ECB, registerName = TASKS_STARTECB, addressOffset = 0x000'u32, readAccess = false, writeAccess = true, registerDesc = "Start ECB block encrypt")
declareField(peripheralName = ECB, registerName = TASKS_STARTECB, fieldName = TASKS_STARTECB, bitOffset = 0, bitWidth = 1, readAccess = false, writeAccess = true, fieldDesc = "Start ECB block encrypt")
declareRegister(peripheralName = ECB, registerName = TASKS_STOPECB, addressOffset = 0x004'u32, readAccess = false, writeAccess = true, registerDesc = "Abort a possible executing ECB operation")
declareField(peripheralName = ECB, registerName = TASKS_STOPECB, fieldName = TASKS_STOPECB, bitOffset = 0, bitWidth = 1, readAccess = false, writeAccess = true, fieldDesc = "Abort a possible executing ECB operation")
declareRegister(peripheralName = ECB, registerName = EVENTS_ENDECB, addressOffset = 0x100'u32, readAccess = true, writeAccess = true, registerDesc = "ECB block encrypt complete")
declareField(peripheralName = ECB, registerName = EVENTS_ENDECB, fieldName = EVENTS_ENDECB, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "ECB block encrypt complete")
declareRegister(peripheralName = ECB, registerName = EVENTS_ERRORECB, addressOffset = 0x104'u32, readAccess = true, writeAccess = true, registerDesc = "ECB block encrypt aborted because of a STOPECB task or due to an error")
declareField(peripheralName = ECB, registerName = EVENTS_ERRORECB, fieldName = EVENTS_ERRORECB, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "ECB block encrypt aborted because of a STOPECB task or due to an error")
declareRegister(peripheralName = ECB, registerName = INTENSET, addressOffset = 0x304'u32, readAccess = true, writeAccess = true, registerDesc = "Enable interrupt")
declareField(peripheralName = ECB, registerName = INTENSET, fieldName = ENDECB, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Write '1' to enable interrupt for event ENDECB")
declareField(peripheralName = ECB, registerName = INTENSET, fieldName = ERRORECB, bitOffset = 1, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Write '1' to enable interrupt for event ERRORECB")
declareRegister(peripheralName = ECB, registerName = INTENCLR, addressOffset = 0x308'u32, readAccess = true, writeAccess = true, registerDesc = "Disable interrupt")
declareField(peripheralName = ECB, registerName = INTENCLR, fieldName = ENDECB, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Write '1' to disable interrupt for event ENDECB")
declareField(peripheralName = ECB, registerName = INTENCLR, fieldName = ERRORECB, bitOffset = 1, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Write '1' to disable interrupt for event ERRORECB")
declareRegister(peripheralName = ECB, registerName = ECBDATAPTR, addressOffset = 0x504'u32, readAccess = true, writeAccess = true, registerDesc = "ECB block encrypt memory pointers")
declareField(peripheralName = ECB, registerName = ECBDATAPTR, fieldName = ECBDATAPTR, bitOffset = 0, bitWidth = 32, readAccess = true, writeAccess = true, fieldDesc = "Pointer to the ECB data structure (see Table 1 ECB data structure overview)")
