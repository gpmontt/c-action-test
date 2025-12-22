/**
 * @file main.h
 * @brief Main application header for STM32 project
 */

#ifndef MAIN_H
#define MAIN_H

#include <stdint.h>
#include <stdbool.h>

/* Function prototypes */
void SystemInit(void);
void delay_ms(uint32_t ms);
uint32_t add_numbers(uint32_t a, uint32_t b);
bool is_valid_temperature(int16_t temp);
void led_init(void);
void led_on(void);
void led_off(void);
void led_toggle(void);

#endif /* MAIN_H */
