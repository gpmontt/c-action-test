cmake_minimum_required(VERSION 3.15)

# Set the toolchain file before project() call
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/cmake/arm-none-eabi-gcc.cmake)

# Project configuration
project(stm32l4-project C ASM)

# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# STM32L4 specific definitions
set(MCU_FAMILY STM32L4xx)
set(MCU_MODEL STM32L476xx)

# Define the MCU-specific compiler flags
set(CPU_FLAGS "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

# Compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CPU_FLAGS} -Wall -Wextra -fdata-sections -ffunction-sections")
set(CMAKE_C_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_C_FLAGS_RELEASE "-O3")

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${CPU_FLAGS} -specs=nano.specs -specs=nosys.specs -Wl,--gc-sections -Wl,-Map=${PROJECT_NAME}.map")

# Add linker script
set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/STM32L476RGTx_FLASH.ld)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T${LINKER_SCRIPT}")

# Include directories
include_directories(
    ${CMAKE_SOURCE_DIR}/include
)

# Add definitions
add_definitions(
    -D${MCU_MODEL}
    -DUSE_HAL_DRIVER
)

# Source files
file(GLOB_RECURSE SOURCES
    "src/*.c"
)

# Startup file
set(STARTUP_FILE ${CMAKE_SOURCE_DIR}/src/startup_stm32l476xx.s)

# Create executable
add_executable(${PROJECT_NAME}.elf
    ${SOURCES}
    ${STARTUP_FILE}
)

# Create hex and bin files
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
    COMMENT "Building ${PROJECT_NAME}.hex and ${PROJECT_NAME}.bin"
)

# Print size information
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_SIZE} ${PROJECT_NAME}.elf
    COMMENT "Size information:"
)
