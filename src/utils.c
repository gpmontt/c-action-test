/**
 * @file utils.c
 * @brief Utility functions for STM32 application
 */

#include "utils.h"

/**
 * @brief Add two numbers
 * @param a First number
 * @param b Second number
 * @return Sum of a and b
 */
uint32_t add_numbers(uint32_t a, uint32_t b)
{
    return a + b;
}

/**
 * @brief Check if temperature is within valid range
 * @param temp Temperature in Celsius
 * @return true if temperature is between -40 and 85 degrees
 */
bool is_valid_temperature(int16_t temp)
{
    return (temp >= -40 && temp <= 85);
}
