##########################################################
# Makefile for STM32 Embedded Project
##########################################################

# Project name
PROJECT = stm32_firmware

# Target MCU
MCU = cortex-m4

# Toolchain
PREFIX = arm-none-eabi-
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

# Help
help:
	@echo "STM32 Firmware Makefile"
	@echo "======================="
	@echo "Targets:"
	@echo "  all      - Build the project (default)"
	@echo "  clean    - Remove build artifacts"
	@echo "  size     - Display size information"
	@echo "  disasm   - Generate disassembly listing"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "Requirements:"
	@echo "  - arm-none-eabi-gcc toolchain installed"

.PHONY: all clean size disasm help
