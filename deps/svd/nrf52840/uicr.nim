# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device
#!fmt: off

import metagenerator
export read, write

declarePeripheral(peripheralName = UICR, baseAddress = 0x10001000'u32, peripheralDesc = "User information configuration registers")
declareRegister(peripheralName = UICR, registerName = NRFFW, addressOffset = 0x00000014'u32, dim = 13, dimIncrement = 4, readAccess = true, writeAccess = true, registerDesc = "Description collection: Reserved for Nordic firmware design")
declareField(peripheralName = UICR, registerName = NRFFW, fieldName = NRFFW, bitOffset = 0, bitWidth = 32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Reserved for Nordic firmware design")
declareRegister(peripheralName = UICR, registerName = NRFHW, addressOffset = 0x00000050'u32, dim = 12, dimIncrement = 4, readAccess = true, writeAccess = true, registerDesc = "Description collection: Reserved for Nordic hardware design")
declareField(peripheralName = UICR, registerName = NRFHW, fieldName = NRFHW, bitOffset = 0, bitWidth = 32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Reserved for Nordic hardware design")
declareRegister(peripheralName = UICR, registerName = CUSTOMER, addressOffset = 0x00000080'u32, dim = 32, dimIncrement = 4, readAccess = true, writeAccess = true, registerDesc = "Description collection: Reserved for customer")
declareField(peripheralName = UICR, registerName = CUSTOMER, fieldName = CUSTOMER, bitOffset = 0, bitWidth = 32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Reserved for customer")
declareRegister(peripheralName = UICR, registerName = PSELRESET, addressOffset = 0x00000200'u32, dim = 2, dimIncrement = 4, readAccess = true, writeAccess = true, registerDesc = "Description collection: Mapping of the nRESET function (see POWER chapter for details)")
declareField(peripheralName = UICR, registerName = PSELRESET, fieldName = PIN, bitOffset = 0, bitWidth = 5, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "GPIO pin number onto which nRESET is exposed")
declareField(peripheralName = UICR, registerName = PSELRESET, fieldName = PORT, bitOffset = 5, bitWidth = 1, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Port number onto which nRESET is exposed")
declareField(peripheralName = UICR, registerName = PSELRESET, fieldName = CONNECT, bitOffset = 31, bitWidth = 1, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Connection")
declareRegister(peripheralName = UICR, registerName = APPROTECT, addressOffset = 0x208'u32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, registerDesc = "Access port protection")
declareField(peripheralName = UICR, registerName = APPROTECT, fieldName = PALL, bitOffset = 0, bitWidth = 8, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Enable or disable access port protection.")
declareRegister(peripheralName = UICR, registerName = NFCPINS, addressOffset = 0x20C'u32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, registerDesc = "Setting of pins dedicated to NFC functionality: NFC antenna or GPIO")
declareField(peripheralName = UICR, registerName = NFCPINS, fieldName = PROTECT, bitOffset = 0, bitWidth = 1, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Setting of pins dedicated to NFC functionality")
declareRegister(peripheralName = UICR, registerName = DEBUGCTRL, addressOffset = 0x210'u32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, registerDesc = "Processor debug control")
declareField(peripheralName = UICR, registerName = DEBUGCTRL, fieldName = CPUNIDEN, bitOffset = 0, bitWidth = 8, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Configure CPU non-intrusive debug features")
declareField(peripheralName = UICR, registerName = DEBUGCTRL, fieldName = CPUFPBEN, bitOffset = 8, bitWidth = 8, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Configure CPU flash patch and breakpoint (FPB) unit behavior")
declareRegister(peripheralName = UICR, registerName = REGOUT0, addressOffset = 0x304'u32, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, registerDesc = "Output voltage from REG0 regulator stage. The maximum output voltage from this stage is given as VDDH - V_VDDH-VDD.")
declareField(peripheralName = UICR, registerName = REGOUT0, fieldName = VOUT, bitOffset = 0, bitWidth = 3, dim = 0, dimIncrement = 0, readAccess = true, writeAccess = true, fieldDesc = "Output voltage from REG0 regulator stage.")
