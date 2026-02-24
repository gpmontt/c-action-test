##########################################################
# Makefile for Unit Tests
##########################################################

# Compiler for native tests
CC = gcc

# Directories
SRC_DIR = ../src
INC_DIR = ../inc
UNITY_DIR = unity
BUILD_DIR = build

# Test source files
TEST_SOURCES = test_main.c

# Application source files (excluding main function)
APP_SOURCES = $(SRC_DIR)/utils.c

# Unity framework
UNITY_SOURCES = $(UNITY_DIR)/unity.c

# All sources
SOURCES = $(TEST_SOURCES) $(UNITY_SOURCES)

# Include paths
INCLUDES = -I$(INC_DIR) -I$(UNITY_DIR)

# Compiler flags
CFLAGS = -Wall -Wextra -Werror
CFLAGS += -g
CFLAGS += $(INCLUDES)
CFLAGS += -DUNIT_TEST

# Output binary
TEST_BINARY = $(BUILD_DIR)/test_runner

# Default target
all: test

# Create build directory
$(BUILD_DIR):
	mkdir -p $@

# Compile and link tests
$(TEST_BINARY): $(TEST_SOURCES) $(APP_SOURCES) $(UNITY_SOURCES) | $(BUILD_DIR)
	@echo "Building unit tests..."
	@$(CC) $(CFLAGS) $(APP_SOURCES) $(TEST_SOURCES) $(UNITY_SOURCES) -o $@

# Run tests
test: $(TEST_BINARY)
	@echo "Running unit tests..."
	@./$(TEST_BINARY)

# Clean
clean:
	@echo "Cleaning test artifacts"
	@rm -rf $(BUILD_DIR)

# Help
help:
	@echo "Unit Test Makefile"
	@echo "=================="
	@echo "Targets:"
	@echo "  test     - Build and run unit tests (default)"
	@echo "  clean    - Remove test artifacts"
	@echo "  help     - Show this help message"

.PHONY: all test clean help
