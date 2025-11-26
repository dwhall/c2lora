# c2lora

Codec 2 over LoRa, written in Nim.

## Project Details

[See the wiki](https://github.com/dwhall/c2lora/wiki) for more documentation.

## Requirements

* git 2.51 or later
* [Nim 2.2.0](https://nim-lang.org/install.html) or later
* an `arm-none-eabi-gcc` toolchain such as [ARM GNU Toolchain Version 14.3.Rel1](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
* SDK: [nRF5_SDK_17.1.0_ddde560.zip](https://www.nordicsemi.com/Products/nRF52840/Compatible-downloads#infotabs)
* Python3: to convert .bin to .uf2

## Building

_BE SURE TO INIT AND UPDATE SUBMODULES_

* Build: `nimble build --skipCfg`
* Tests: `nimble test` (none at the moment)

## Releases

None

## References

* [Cortex-M3 LL Details](https://tonyfu97.github.io/ARM-Cortex-M4/)

