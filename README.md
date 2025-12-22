# STM32 Embedded Firmware Project with CI/CD

[![Build Firmware](https://github.com/gpmontt/c-action-test/workflows/Build%20Firmware/badge.svg)](https://github.com/gpmontt/c-action-test/actions/workflows/build.yml)
[![Unit Tests](https://github.com/gpmontt/c-action-test/workflows/Unit%20Tests/badge.svg)](https://github.com/gpmontt/c-action-test/actions/workflows/test.yml)
[![Static Analysis](https://github.com/gpmontt/c-action-test/workflows/Static%20Analysis/badge.svg)](https://github.com/gpmontt/c-action-test/actions/workflows/static-analysis.yml)
[![Code Formatting](https://github.com/gpmontt/c-action-test/workflows/Code%20Formatting/badge.svg)](https://github.com/gpmontt/c-action-test/actions/workflows/format.yml)

A complete embedded firmware development environment for STM32 microcontrollers using GCC, featuring automated testing, continuous integration, and delivery workflows with GitHub Actions.

## 🎯 Project Overview

This project demonstrates best practices for embedded firmware development with:
- **Cross-compilation** for ARM Cortex-M microcontrollers
- **Unit testing** with Unity framework
- **Static analysis** with cppcheck
- **Code formatting** with clang-format
- **Automated CI/CD** with GitHub Actions

## 📁 Project Structure

```
.
├── src/                    # Source files
│   ├── main.c             # Main application
│   └── utils.c            # Utility functions
├── inc/                    # Header files
│   ├── main.h
│   └── utils.h
├── startup/                # Startup code
│   ├── startup_stm32.c    # Vector table and reset handler
│   └── stm32_linker.ld    # Linker script
├── tests/                  # Unit tests
│   ├── test_main.c        # Test cases
│   ├── unity/             # Unity test framework
│   └── Makefile           # Test build system
├── .github/workflows/      # CI/CD pipelines
│   ├── build.yml          # Firmware build
│   ├── test.yml           # Unit tests
│   ├── static-analysis.yml # Static code analysis
│   └── format.yml         # Code formatting check
├── Makefile               # Main build system
└── README.md              # This file
```

## 🛠️ Prerequisites

### For Building Firmware (ARM Target)
- `arm-none-eabi-gcc` - ARM cross-compiler toolchain
- `make` - Build automation tool

### For Unit Tests (Native)
- `gcc` - Native C compiler
- `make` - Build automation tool

### For Development (Optional)
- `cppcheck` - Static code analyzer
- `clang-format` - Code formatter

## 🚀 Quick Start

### Install ARM Toolchain

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi
```

**macOS:**
```bash
brew install arm-none-eabi-gcc
```

**Windows:**
Download from [ARM Developer](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm)

### Build Firmware

```bash
# Build the firmware
make

# Clean build artifacts
make clean

# Show memory usage
make size

# Generate disassembly
make disasm
```

Build outputs:
- `build/stm32_firmware.elf` - ELF executable
- `build/stm32_firmware.bin` - Binary image for flashing
- `build/stm32_firmware.hex` - Intel HEX format
- `build/stm32_firmware.map` - Memory map

### Run Unit Tests

```bash
cd tests
make test
```

## 🧪 Testing

### Unit Testing Framework

This project uses [Unity](https://github.com/ThrowTheSwitch/Unity) - a lightweight unit testing framework for C.

#### Running Tests Locally

```bash
cd tests
make test
```

#### Test Coverage

Current test suite covers:
- `add_numbers()` - Mathematical operations
- `is_valid_temperature()` - Input validation and boundary conditions

#### Adding New Tests

1. Create test functions in `tests/test_main.c`:
```c
void test_my_function(void)
{
    TEST_ASSERT_EQUAL(expected, actual);
}
```

2. Register in `main()`:
```c
RUN_TEST(test_my_function);
```

## 🔍 Code Quality

### Static Analysis

Run cppcheck locally:
```bash
cppcheck --enable=all -I inc src/*.c
```

### Code Formatting

Check formatting:
```bash
find src inc tests -name "*.c" -o -name "*.h" | xargs clang-format --dry-run
```

Apply formatting:
```bash
find src inc tests -name "*.c" -o -name "*.h" | xargs clang-format -i
```

## 🤖 CI/CD Pipelines

GitHub Actions automatically run on every push and pull request:

### 1. **Build Firmware** (`.github/workflows/build.yml`)
- Installs ARM GCC toolchain
- Compiles firmware for STM32 target
- Uploads artifacts (ELF, BIN, HEX files)
- Reports memory usage

### 2. **Unit Tests** (`.github/workflows/test.yml`)
- Compiles tests with native GCC
- Runs all test suites
- Reports test results
- Uploads test artifacts

### 3. **Static Analysis** (`.github/workflows/static-analysis.yml`)
- Runs cppcheck on source code
- Checks for common coding errors
- Enforces coding standards
- Fails on critical issues

### 4. **Code Formatting** (`.github/workflows/format.yml`)
- Checks code formatting with clang-format
- Ensures consistent code style
- Fails if formatting is incorrect

## 📊 Workflow Status

Check the [Actions tab](https://github.com/gpmontt/c-action-test/actions) to see workflow runs and download artifacts.

## 🎓 Learning Resources

This project is designed to help understand:
- Embedded firmware build systems
- Cross-compilation for ARM
- Unit testing for embedded systems
- CI/CD for firmware development
- Static analysis and code quality

## 🔧 Configuration

### Target MCU
Default: STM32F4 series (Cortex-M4)

To change the target:
1. Edit `Makefile` - Update `MCU` variable
2. Edit `startup/stm32_linker.ld` - Adjust memory sizes
3. Update `startup/startup_stm32.c` - Add peripheral interrupts if needed

### Compiler Flags
See `Makefile` for compiler and linker flags. Key flags:
- `-mcpu=cortex-m4` - Target CPU
- `-mthumb` - Thumb instruction set
- `-Wall -Wextra -Werror` - Enable warnings
- `-O2` - Optimization level
- `-g` - Debug symbols

## 📈 Suggested Improvements

Based on best practices for embedded CI/CD, consider creating issues for:

### High Priority
1. **Code Coverage Analysis**
   - Integrate gcov/lcov for test coverage metrics
   - Add coverage reporting to CI pipeline
   - Set minimum coverage thresholds

2. **Hardware-in-the-Loop (HIL) Testing**
   - Add Renode or QEMU for emulation
   - Run firmware tests in emulated environment
   - Validate hardware interactions

3. **Security Analysis**
   - Add static security analysis (e.g., Coverity)
   - Scan for vulnerabilities in dependencies
   - Implement secure boot verification

### Medium Priority
4. **Documentation Generation**
   - Integrate Doxygen for API documentation
   - Auto-generate docs on each release
   - Host documentation on GitHub Pages

5. **Release Automation**
   - Create tagged releases automatically
   - Generate release notes from commits
   - Package firmware with metadata

6. **Performance Testing**
   - Add benchmarks for critical functions
   - Track performance regressions
   - Profile memory and execution time

7. **Lint Integration**
   - Add clang-tidy for more checks
   - Integrate MISRA C compliance checking
   - Add custom lint rules

### Low Priority
8. **Multi-platform Support**
   - Test builds on Windows/macOS runners
   - Support different toolchain versions
   - Cross-platform scripts

9. **Dependency Management**
   - Add external library management
   - Version control for dependencies
   - Automated security updates

10. **Advanced Testing**
    - Integration tests
    - Regression test suites
    - Fuzz testing for robust inputs

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `cd tests && make test`
5. Check formatting: `make format-check` (if implemented)
6. Submit a pull request

All PRs must pass CI checks before merging.

## 📄 License

This project is provided as-is for educational purposes.

## 🤝 Support

For questions or issues, please open an issue on GitHub.

---

**Happy Embedded Development! 🚀**