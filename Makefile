##########################################################
# Makefile for STM32 Embedded Project
##########################################################

# Project name
PROJECT = stm32_firmware

# Target MCU
MCU = cortex-m4

# Device specific (for flashing/debugging)
# Change this to match your specific STM32 device
DEVICE ?= STM32F407VG

# Toolchain
# First check if STM32CubeIDE toolchain is available, then fallback to system
STM32CUBE_GCC_PATH ?= /opt/st/stm32cubeide/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.*/tools/bin
ARM_TOOLCHAIN_PATH ?= $(shell find $(STM32CUBE_GCC_PATH) -name "arm-none-eabi-gcc" 2>/dev/null | head -1 | xargs dirname 2>/dev/null)

# If STM32CubeIDE not found, check system PATH
ifeq ($(ARM_TOOLCHAIN_PATH),)
    ARM_TOOLCHAIN_PATH := $(shell dirname $$(which arm-none-eabi-gcc 2>/dev/null) 2>/dev/null)
endif

# If still not found, use relative path (assumes it's in PATH)
ifeq ($(ARM_TOOLCHAIN_PATH),)
    PREFIX = arm-none-eabi-
else
    PREFIX = $(ARM_TOOLCHAIN_PATH)/arm-none-eabi-
endif

CC = $(PREFIX)gcc
AS = $(PREFIX)as
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump
SIZE = $(PREFIX)size

# Directories
SRC_DIR = src
INC_DIR = inc
STARTUP_DIR = startup
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj

# Source files
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
C_SOURCES += $(STARTUP_DIR)/startup_stm32.c

# Object files
OBJECTS = $(addprefix $(OBJ_DIR)/, $(notdir $(C_SOURCES:.c=.o)))

# Include paths
INCLUDES = -I$(INC_DIR)

# Compiler flags
CFLAGS = -mcpu=$(MCU)
CFLAGS += -mthumb
CFLAGS += -mfloat-abi=soft
CFLAGS += -Wall -Wextra -Werror
CFLAGS += -fdata-sections -ffunction-sections
CFLAGS += -O2
CFLAGS += -g
CFLAGS += $(INCLUDES)

# Linker flags
LDFLAGS = -mcpu=$(MCU)
LDFLAGS += -mthumb
LDFLAGS += -specs=nosys.specs
LDFLAGS += -T$(STARTUP_DIR)/stm32_linker.ld
LDFLAGS += -Wl,-Map=$(BUILD_DIR)/$(PROJECT).map
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -Wl,--print-memory-usage

# Default target
all: $(BUILD_DIR)/$(PROJECT).elf $(BUILD_DIR)/$(PROJECT).bin $(BUILD_DIR)/$(PROJECT).hex
	@echo "Build complete!"
	@$(SIZE) $(BUILD_DIR)/$(PROJECT).elf

# Create build directories
$(BUILD_DIR) $(OBJ_DIR):
	mkdir -p $@

# Compile C source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo "Compiling $<"
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(STARTUP_DIR)/%.c | $(OBJ_DIR)
	@echo "Compiling $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# Link
$(BUILD_DIR)/$(PROJECT).elf: $(OBJECTS) | $(BUILD_DIR)
	@echo "Linking $@"
	@$(CC) $(LDFLAGS) $(OBJECTS) -o $@

# Generate binary file
$(BUILD_DIR)/$(PROJECT).bin: $(BUILD_DIR)/$(PROJECT).elf
	@echo "Creating binary: $@"
	@$(OBJCOPY) -O binary $< $@

# Generate hex file
$(BUILD_DIR)/$(PROJECT).hex: $(BUILD_DIR)/$(PROJECT).elf
	@echo "Creating hex: $@"
	@$(OBJCOPY) -O ihex $< $@

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts"
	@rm -rf $(BUILD_DIR)

# Display size information
size: $(BUILD_DIR)/$(PROJECT).elf
	@$(SIZE) $<

# Disassemble
disasm: $(BUILD_DIR)/$(PROJECT).elf
	@$(OBJDUMP) -d $< > $(BUILD_DIR)/$(PROJECT).lst

# Flash using ST-Link
flash-stlink: $(BUILD_DIR)/$(PROJECT).bin
	@echo "Flashing with ST-Link..."
	st-flash write $< 0x8000000

# Flash using J-Link
flash-jlink: $(BUILD_DIR)/$(PROJECT).hex
	@echo "Flashing with J-Link..."
	@TMPFILE=$$(mktemp /tmp/flash_jlink_XXXXXX.cmd); \
	echo "loadfile $<\nr\ng\nq" > $$TMPFILE; \
	JLinkExe -device $(DEVICE) -if SWD -speed 4000 -CommanderScript $$TMPFILE; \
	rm -f $$TMPFILE

# Flash using OpenOCD with ST-Link
flash-openocd: $(BUILD_DIR)/$(PROJECT).elf
	@echo "Flashing with OpenOCD..."
	openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
		-c "program $< verify reset exit"

# Help
help:
	@echo "STM32 Firmware Makefile"
	@echo "======================="
	@echo "Targets:"
	@echo "  all          - Build the project (default)"
	@echo "  clean        - Remove build artifacts"
	@echo "  size         - Display size information"
	@echo "  disasm       - Generate disassembly listing"
	@echo "  flash-stlink - Flash firmware using ST-Link"
	@echo "  flash-jlink  - Flash firmware using J-Link"
	@echo "  flash-openocd - Flash firmware using OpenOCD"
	@echo "  help         - Show this help message"
	@echo ""
	@echo "Requirements:"
	@echo "  - arm-none-eabi-gcc toolchain installed"
	@echo "  - For flashing: st-flash, JLinkExe, or openocd"

.PHONY: all clean size disasm flash-stlink flash-jlink flash-openocd help
