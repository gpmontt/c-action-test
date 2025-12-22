/**
 ******************************************************************************
 * @file    main.c
 * @brief   Main program body for STM32L4 - Hello World LED Toggle
 * @note    This example toggles LD1 (PA5) on STM32L476RG-Nucleo board
 ******************************************************************************
 */

#include "stm32l4xx.h"
#include <stdint.h>

/* Function prototypes */
void SystemClock_Config(void);
void GPIO_Init(void);
void Delay(uint32_t count);

/* Main function */
int main(void)
{
    /* Configure the system clock */
    SystemClock_Config();
    
    /* Initialize GPIO for LED */
    GPIO_Init();

    /* Infinite loop - Toggle LED */
    while (1)
    {
        /* Toggle LD1 (PA5) */
        LD1_GPIO_PORT->ODR ^= LD1_PIN;
        
        /* Simple delay */
        Delay(500000);
    }
}

/**
 * @brief  Initialize GPIO for LED
 * @retval None
 */
void GPIO_Init(void)
{
    /* Enable GPIOA clock */
    LD1_GPIO_CLK_ENABLE();
    
    /* Configure PA5 as output */
    /* Clear mode bits for pin 5 (bits 10-11) */
    LD1_GPIO_PORT->MODER &= ~(0x3UL << (5 * 2));
    
    /* Set mode to output (01) for pin 5 */
    LD1_GPIO_PORT->MODER |= (GPIO_MODE_OUTPUT << (5 * 2));
    
    /* Set output type to push-pull (reset state) */
    LD1_GPIO_PORT->OTYPER &= ~(0x1UL << 5);
    
    /* Set output speed to low */
    LD1_GPIO_PORT->OSPEEDR &= ~(0x3UL << (5 * 2));
    
    /* No pull-up, pull-down */
    LD1_GPIO_PORT->PUPDR &= ~(0x3UL << (5 * 2));
}

/**
 * @brief  Simple delay function
 * @param  count: delay count
 * @retval None
 */
void Delay(uint32_t count)
{
    volatile uint32_t i;
    for(i = 0; i < count; i++)
    {
        __asm volatile ("nop");
    }
}

/**
 * @brief  System Clock Configuration
 * @note   Using default HSI (16 MHz) clock
 * @retval None
 */
void SystemClock_Config(void)
{
    /* Using default HSI clock (16 MHz) */
    /* For STM32L4, HSI is enabled by default after reset */
    /* This is a minimal configuration - can be expanded later with STM32CubeMX */
}

/**
 * @brief  This function is executed in case of error occurrence.
 * @retval None
 */
void Error_Handler(void)
{
    /* User can add his own implementation to report the error */
    while (1)
    {
    }
}

#ifdef USE_FULL_ASSERT
/**
 * @brief  Reports the name of the source file and the source line number
 *         where the assert_param error has occurred.
 * @param  file: pointer to the source file name
 * @param  line: assert_param error line source number
 * @retval None
 */
void assert_failed(char *file, uint32_t line)
{
    /* User can add his own implementation to report the file name and line number */
}
#endif
