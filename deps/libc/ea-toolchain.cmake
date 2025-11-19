set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_AR arm-none-eabi-ar)
set(CMAKE_RANLIB arm-none-eabi-ranlib)

# Do not attempt to link test executables
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# CPU flags
set(MCPU_FLAGS "-march=armv7e-m -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16")

set(CMAKE_C_FLAGS "${MCPU_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS "${MCPU_FLAGS}" CACHE STRING "" FORCE)