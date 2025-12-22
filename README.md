# STM32L4 Embedded Project

This is a template project for STM32L4 microcontrollers using GCC and CMake, with automated builds via GitHub Actions. The project is designed to work with STM32Cube tools and includes a "Hello World" LED toggle example.

## Features

- **Microcontroller**: STM32L476RGTx (Cortex-M4 with FPU)
- **Board**: STM32L476RG-Nucleo (or compatible)
- **Toolchain**: ARM GCC (arm-none-eabi-gcc)
- **Build System**: CMake
- **CI/CD**: GitHub Actions for automated builds
- **Example**: LED toggle (LD1 on PA5) - "Hello World" for embedded systems

## Hardware Setup

This project is configured for the **STM32L476RG-Nucleo** development board with default configuration:
- **LD1 (User LED)**: Connected to PA5 (GPIO Port A, Pin 5)
- **Clock**: HSI 16 MHz (default after reset)

The example code toggles LD1 continuously to demonstrate basic GPIO control.

## Project Structure

```
.
├── src/                          # Source files
│   ├── main.c                    # Main application
│   └── startup_stm32l476xx.s     # Startup code
├── include/                      # Header files
│   └── stm32l4xx.h               # Device header
├── cmake/                        # CMake modules
│   └── arm-none-eabi-gcc.cmake   # ARM GCC toolchain file
├── .github/workflows/            # GitHub Actions workflows
│   └── build.yml                 # Build workflow
├── CMakeLists.txt                # CMake build configuration
├── STM32L476RGTx_FLASH.ld        # Linker script
└── README.md                     # This file
```

## Prerequisites

### Local Development

To build this project locally, you need:

1. **ARM GCC Toolchain**: Install arm-none-eabi-gcc
   ```bash
   # Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi
   
   # macOS
   brew install arm-none-eabi-gcc
   
   # Windows
   # Download from: https://developer.arm.com/downloads/-/gnu-rm
   ```

2. **CMake**: Version 3.15 or higher
   ```bash
   # Ubuntu/Debian
   sudo apt-get install cmake
   
   # macOS
   brew install cmake
   
   # Windows
   # Download from: https://cmake.org/download/
   ```

3. **Make** (optional, for easier building)

## Building the Project

### Using CMake (Recommended)

```bash
# Create build directory
mkdir build && cd build

# Configure the project
cmake -DCMAKE_BUILD_TYPE=Release ..

# Build
cmake --build .

# Or for debug build
cmake -DCMAKE_BUILD_TYPE=Debug ..
cmake --build .
```

### Build Artifacts

After a successful build, you'll find these files in the `build/` directory:

- `stm32l4-project.elf` - ELF executable (for debugging)
- `stm32l4-project.hex` - Intel HEX format (for flashing)
- `stm32l4-project.bin` - Binary format (for flashing)
- `stm32l4-project.map` - Memory map file

## Flashing and Running

After building and flashing the firmware, you should see LD1 (the green LED on the Nucleo board) blinking continuously. This is the embedded "Hello World" program.

You can flash the firmware using various tools:

### Using ST-Link
```bash
st-flash write build/stm32l4-project.bin 0x08000000
```

### Using OpenOCD
```bash
openocd -f interface/stlink.cfg -f target/stm32l4x.cfg \
  -c "program build/stm32l4-project.elf verify reset exit"
```

## GitHub Actions CI/CD

The project includes a GitHub Actions workflow that automatically:

1. Checks out the code
2. Installs the ARM GCC toolchain
3. Builds the project
4. Uploads the firmware artifacts

The workflow runs on:
- Push to `main`, `develop`, or `copilot/**` branches
- Pull requests to `main` or `develop`
- Manual trigger via workflow_dispatch

Build artifacts are available in the Actions tab after each successful build.

## Customization

### Modifying LED Behavior

To change the LED toggle speed, modify the delay value in `src/main.c`:
```c
Delay(500000);  // Increase for slower, decrease for faster blinking
```

### Using STM32CubeMX

This project is designed to work with STM32CubeMX for peripheral configuration:
1. Open STM32CubeMX and create a new project for STM32L476RG
2. Configure peripherals as needed
3. Generate code with "Makefile" or "CMake" toolchain
4. Copy the generated HAL drivers to this project
5. Update `CMakeLists.txt` to include HAL sources

### Target MCU

To use a different STM32L4 variant, modify:

1. `CMakeLists.txt`: Update `MCU_MODEL` (e.g., `STM32L432xx`, `STM32L496xx`)
2. Linker script: Adjust memory sizes in `STM32L476RGTx_FLASH.ld`
3. Startup file: Use appropriate startup file for your MCU

### Compiler Flags

Edit `CMakeLists.txt` to modify:
- Optimization level: `-O0`, `-O1`, `-O2`, `-O3`, `-Os`
- Debug info: `-g`, `-g3`
- Warning levels: `-Wall`, `-Wextra`, `-Wpedantic`

## Adding HAL/LL Drivers

To use STM32 HAL or LL drivers:

1. Download STM32CubeL4 from ST website
2. Copy the drivers to your project:
   - `Drivers/STM32L4xx_HAL_Driver/`
   - `Drivers/CMSIS/`
3. Update `CMakeLists.txt` to include driver sources and headers
4. Configure HAL in `stm32l4xx_hal_conf.h`

## Debugging

### Using GDB with OpenOCD

```bash
# Terminal 1: Start OpenOCD
openocd -f interface/stlink.cfg -f target/stm32l4x.cfg

# Terminal 2: Start GDB
arm-none-eabi-gdb build/stm32l4-project.elf
(gdb) target extended-remote :3333
(gdb) load
(gdb) monitor reset halt
(gdb) continue
```

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Ensure the project builds successfully
5. Submit a pull request

## License

This project is provided as-is for educational and development purposes.

## Resources

- [STM32L4 Series](https://www.st.com/en/microcontrollers-microprocessors/stm32l4-series.html)
- [ARM GCC Toolchain](https://developer.arm.com/downloads/-/gnu-rm)
- [CMake Documentation](https://cmake.org/documentation/)
- [STM32CubeL4](https://www.st.com/en/embedded-software/stm32cubel4.html)