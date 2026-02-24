# Contributing to STM32 Embedded Firmware Project

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## 🌟 How to Contribute

### Reporting Issues
- Use GitHub Issues to report bugs or request features
- Check existing issues before creating a new one
- Provide detailed information:
  - Clear description of the issue
  - Steps to reproduce
  - Expected vs actual behavior
  - Environment details (OS, toolchain version)

### Suggesting Enhancements
- Open an issue with the `enhancement` label
- Describe the feature and its benefits
- Provide use cases and examples
- Consider implementation complexity

## 🔧 Development Setup

### Prerequisites
```bash
# Ubuntu/Debian
sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi gcc make

# macOS
brew install arm-none-eabi-gcc make

# Verification
arm-none-eabi-gcc --version
gcc --version
make --version
```

### Getting Started
```bash
# Fork the repository on GitHub
# Clone your fork
git clone https://github.com/YOUR_USERNAME/c-action-test.git
cd c-action-test

# Add upstream remote
git remote add upstream https://github.com/gpmontt/c-action-test.git

# Create a feature branch
git checkout -b feature/your-feature-name
```

## 📝 Coding Standards

### C Code Style
- Follow existing code style (see `.clang-format`)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Maximum line length: 100 characters

### Code Formatting
```bash
# Check formatting
find src inc tests -name "*.c" -o -name "*.h" | xargs clang-format --dry-run

# Apply formatting
find src inc tests -name "*.c" -o -name "*.h" | xargs clang-format -i
```

### Best Practices
- **No magic numbers**: Use named constants
- **Error handling**: Always check return values
- **Memory safety**: No buffer overflows
- **Const correctness**: Use `const` where applicable
- **Documentation**: Add function headers with Doxygen format

Example function header:
```c
/**
 * @brief Brief description of the function
 * @param param1 Description of parameter 1
 * @param param2 Description of parameter 2
 * @return Description of return value
 */
uint32_t my_function(uint32_t param1, uint32_t param2);
```

## 🧪 Testing Requirements

### Unit Tests
All new functionality must include unit tests.

```bash
# Run tests
cd tests
make test

# Add new test
# Edit tests/test_main.c
void test_my_new_feature(void)
{
    TEST_ASSERT_EQUAL(expected, actual);
}

# Register in main()
RUN_TEST(test_my_new_feature);
```

### Test Guidelines
- One test function per behavior
- Use descriptive test names: `test_function_condition_expectedResult`
- Test edge cases and boundaries
- Keep tests independent and isolated
- Aim for high code coverage

## 🚀 Pull Request Process

### Before Submitting
1. **Build locally**: Ensure code compiles without errors
2. **Run tests**: All tests must pass
3. **Format code**: Apply clang-format
4. **Update docs**: Update README if needed
5. **Check CI**: Ensure no CI failures

### PR Guidelines
- **Clear title**: Summarize the change
- **Description**: Explain what and why
- **Link issues**: Reference related issues
- **Small PRs**: Keep changes focused and reviewable
- **Commits**: Use clear commit messages

### Commit Messages
Follow conventional commit format:
```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Example:
```
feat(testing): add temperature validation tests

Add comprehensive unit tests for is_valid_temperature()
including boundary conditions and edge cases.

Closes #42
```

### PR Checklist
- [ ] Code follows project style guidelines
- [ ] All tests pass locally
- [ ] New tests added for new functionality
- [ ] Documentation updated (if applicable)
- [ ] No build warnings or errors
- [ ] CI checks pass
- [ ] PR description is clear and complete

## 🔍 Code Review Process

### What to Expect
1. Automated CI checks run first
2. Maintainers review code within 2-3 days
3. Address feedback with additional commits
4. Approval required before merging
5. Squash and merge to main branch

### Review Criteria
- **Correctness**: Does it work as intended?
- **Testing**: Are tests adequate?
- **Style**: Does it follow conventions?
- **Documentation**: Is it well documented?
- **Performance**: Any performance concerns?
- **Security**: Any security issues?

## 🏗️ Project Structure

```
├── src/              # Application source code
├── inc/              # Header files
├── startup/          # Startup code and linker scripts
├── tests/            # Unit tests
│   └── unity/        # Unity test framework
├── .github/
│   └── workflows/    # CI/CD pipelines
├── Makefile          # Build system
└── README.md         # Project documentation
```

## 🛠️ Build System

### Makefile Targets
```bash
# Build firmware
make all

# Clean build artifacts
make clean

# Show memory usage
make size

# Generate disassembly
make disasm

# Run unit tests
cd tests && make test
```

### Adding Source Files
1. Add `.c` file to `src/`
2. Add `.h` file to `inc/`
3. Makefile will automatically pick up new files
4. Add corresponding unit tests

## 🔌 Flashing and Debugging

### Flashing Options

This project supports multiple flashing methods:

#### 1. ST-Link (Recommended for ST boards)
```bash
# Using st-flash utility
st-flash write build/stm32_firmware.bin 0x8000000

# Using OpenOCD
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "program build/stm32_firmware.elf verify reset exit"
```

#### 2. J-Link (Segger J-Link)
J-Link is an excellent option for professional debugging and flashing:

```bash
# Using JLinkExe
JLinkExe -device STM32F407VG -if SWD -speed 4000 -autoconnect 1
# In J-Link console:
# loadfile build/stm32_firmware.hex
# r (reset)
# g (go)
# q (quit)

# Using command file for automation
echo "loadfile build/stm32_firmware.hex
r
g
q" > flash.jlink
JLinkExe -device STM32F407VG -if SWD -speed 4000 -CommanderScript flash.jlink
```

**J-Link Advantages:**
- Professional-grade debug probe
- Fast flash programming
- RTT (Real-Time Transfer) for logging
- Excellent GDB server support
- Wide device support

#### 3. GDB with J-Link
```bash
# Terminal 1: Start J-Link GDB Server
JLinkGDBServer -device STM32F407VG -if SWD -speed 4000

# Terminal 2: Connect with GDB
arm-none-eabi-gdb build/stm32_firmware.elf
(gdb) target remote localhost:2331
(gdb) load
(gdb) monitor reset
(gdb) continue
```

### Hardware Setup
- Connect your debug probe (ST-Link or J-Link) to the SWD pins
- Typical connections: SWDIO, SWCLK, GND, VCC (optional)
- Ensure proper power supply to the target board

## 🔐 Security

### Reporting Vulnerabilities
- **DO NOT** open public issues for security vulnerabilities
- Email maintainers directly with details
- Allow time for fixes before disclosure
- We appreciate responsible disclosure

### Security Best Practices
- No hardcoded credentials
- Validate all inputs
- Check buffer boundaries
- Use secure compiler flags
- Follow MISRA C guidelines (when applicable)

## 📚 Resources

### Documentation
- [ARM GCC Toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain)
- [Unity Testing Framework](https://github.com/ThrowTheSwitch/Unity)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [STM32 Reference Manuals](https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mcus.html)

### Embedded C Resources
- [Embedded C Coding Standard](https://barrgroup.com/embedded-systems/books/embedded-c-coding-standard)
- [MISRA C Guidelines](https://www.misra.org.uk/)

## 🤝 Community

### Communication
- GitHub Issues: Bug reports and feature requests
- Pull Requests: Code contributions
- Discussions: General questions and ideas

### Code of Conduct
- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Focus on the code, not the person

## ❓ Questions?

If you have questions about contributing:
1. Check existing issues and documentation
2. Search for similar questions
3. Open a new issue with your question
4. Tag it with `question` label

## 🎓 Learning Path

New to embedded development? Start here:
1. Read the README
2. Build the project locally
3. Run the unit tests
4. Make a small change (e.g., add a utility function)
5. Write a test for your change
6. Submit your first PR!

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

**Thank you for contributing!** 🚀

Every contribution, no matter how small, helps make this project better.
