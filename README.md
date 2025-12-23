# STM32 Embedded Firmware Project with CI/CD

[![Unit Tests](https://github.com/gpmontt/c-action-test/workflows/Unit%20Tests/badge.svg)](https://github.com/gpmontt/c-action-test/actions/workflows/test.yml)
[![Static Analysis](https://github.com/gpmontt/c-action-test/workflows/Static%20Analysis/badge.svg)](https://github.com/gpmontt/c-action-test/actions/workflows/static-analysis.yml)

A complete embedded firmware development environment for STM32 microcontrollers using GCC, featuring automated testing, continuous integration, and delivery workflows with GitHub Actions.

> **Note on CI/CD Build Pipeline**: This project does not include an automated firmware build workflow in CI/CD. 
> 
> STM32 projects using STM32CubeIDE require the full IDE environment with HAL libraries, peripheral configurations, and ST-specific toolchain setup. These dependencies are complex to automate in a CI environment and are better handled locally with STM32CubeIDE installed. 
> 
> The Makefile supports local builds once you have the proper toolchain configured.

> **Note on Code Formatting**: Code formatting tools like clang-format are **not recommended** for STM32CubeIDE projects.
>
> STM32CubeIDE generates code with specific formatting styles that are integral to the IDE's code generation process. Projects include:
> - **Auto-generated HAL/LL driver code** from STM32CubeMX with ST's formatting conventions
> - **Vendor middleware** (FreeRTOS, USB, TCP/IP stacks) with their own established styles
> - **Third-party libraries** maintained for years with different coding standards
>
> Applying clang-format to these files would:
> - Break the code generation workflow when regenerating from STM32CubeMX
> - Create merge conflicts when updating vendor libraries
> - Make it difficult to compare with official ST examples and documentation
> - Introduce unnecessary diffs that obscure actual code changes
>
> **For this reason, clang-format configuration and formatting steps have been intentionally removed from this project.**

## 🎯 Project Overview

This project demonstrates best practices for embedded firmware development with:
- **Cross-compilation** for ARM Cortex-M microcontrollers
- **Unit testing** with Unity framework
- **Static analysis** with cppcheck
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
│   ├── test.yml           # Unit tests
│   └── static-analysis.yml # Static code analysis
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

## 🚀 Quick Start

### Install ARM Toolchain

**Option 1: STM32CubeIDE (Recommended - includes all ST tools)**
Download and install [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html) which includes:
- ARM GCC toolchain
- ST-Link utilities
- Debugging tools
- HAL libraries

**Option 2: Standalone ARM GCC**

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

### Flash Firmware to Hardware

**Using ST-Link:**
```bash
make flash-stlink
```

**Using J-Link (Segger):**
```bash
make flash-jlink
```

**Using OpenOCD:**
```bash
make flash-openocd
```

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

## 🤖 CI/CD Pipelines

GitHub Actions automatically run on every push and pull request:

> **Note**: Firmware build automation is not included. See the note on Build Pipeline at the top of this README for explanation.

### 1. **Unit Tests** (`.github/workflows/test.yml`)
- Compiles tests with native GCC
- Runs all test suites
- Reports test results
- Uploads test artifacts

### 2. **Static Analysis** (`.github/workflows/static-analysis.yml`)
- Runs cppcheck on source code
- Checks for common coding errors
- Enforces coding standards
- Fails on critical issues

## 📊 Workflow Status

Check the [Actions tab](https://github.com/gpmontt/c-action-test/actions) to see workflow runs and download artifacts.

## 🎓 Learning Resources

This project is designed to help understand:
- Embedded firmware build systems (local development)
- Cross-compilation for ARM (via Makefile)
- Unit testing for embedded systems
- CI/CD for code quality (testing, analysis)
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
5. Submit a pull request

All PRs must pass CI checks before merging.

## 📄 License

This project is provided as-is for educational purposes.

## 🤝 Support

For questions or issues, please open an issue on GitHub.

---

**Happy Embedded Development! 🚀**