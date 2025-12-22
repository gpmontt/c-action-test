/**
 ******************************************************************************
 * @file    stm32l4xx.h
 * @brief   CMSIS STM32L4xx Device Peripheral Access Layer Header File
 ******************************************************************************
 */

#ifndef __STM32L4XX_H
#define __STM32L4XX_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes */
#include <stdint.h>

/* Interrupt Number Definition */
typedef enum
{
    /* Cortex-M4 Processor Exceptions Numbers */
    NonMaskableInt_IRQn         = -14,
    HardFault_IRQn              = -13,
    MemoryManagement_IRQn       = -12,
    BusFault_IRQn               = -11,
    UsageFault_IRQn             = -10,
    SVCall_IRQn                 = -5,
    DebugMonitor_IRQn           = -4,
    PendSV_IRQn                 = -2,
    SysTick_IRQn                = -1,
    
    /* STM32L4 specific Interrupt Numbers */
    WWDG_IRQn                   = 0,
    PVD_PVM_IRQn                = 1,
    TAMP_STAMP_IRQn             = 2,
    RTC_WKUP_IRQn               = 3,
} IRQn_Type;

/* Core Cortex-M4 definitions */
#define __CM4_REV                 0x0001U
#define __MPU_PRESENT             1U
#define __NVIC_PRIO_BITS          4U
#define __Vendor_SysTickConfig    0U
#define __FPU_PRESENT             1U

/* Memory & Peripheral base addresses */
#define FLASH_BASE            ((uint32_t)0x08000000U)
#define SRAM1_BASE            ((uint32_t)0x20000000U)
#define PERIPH_BASE           ((uint32_t)0x40000000U)
#define APB1PERIPH_BASE       PERIPH_BASE
#define APB2PERIPH_BASE       (PERIPH_BASE + 0x00010000U)
#define AHB1PERIPH_BASE       (PERIPH_BASE + 0x00020000U)
#define AHB2PERIPH_BASE       (PERIPH_BASE + 0x08000000U)

/* Peripheral memory map */
#define RCC_BASE              (AHB1PERIPH_BASE + 0x00001000U)
#define GPIOA_BASE            (AHB2PERIPH_BASE + 0x00000000U)
#define GPIOB_BASE            (AHB2PERIPH_BASE + 0x00000400U)

/* Peripheral declaration */
typedef struct
{
    volatile uint32_t CR;           /* RCC clock control register */
    volatile uint32_t ICSCR;        /* RCC internal clock sources calibration register */
    volatile uint32_t CFGR;         /* RCC clock configuration register */
    volatile uint32_t PLLCFGR;      /* RCC PLL configuration register */
    volatile uint32_t PLLSAI1CFGR;  /* RCC PLLSAI1 configuration register */
    volatile uint32_t PLLSAI2CFGR;  /* RCC PLLSAI2 configuration register */
    volatile uint32_t CIER;         /* RCC clock interrupt enable register */
    volatile uint32_t CIFR;         /* RCC clock interrupt flag register */
    volatile uint32_t CICR;         /* RCC clock interrupt clear register */
    uint32_t          RESERVED0;    /* Reserved */
    volatile uint32_t AHB1RSTR;     /* RCC AHB1 peripheral reset register */
    volatile uint32_t AHB2RSTR;     /* RCC AHB2 peripheral reset register */
    volatile uint32_t AHB3RSTR;     /* RCC AHB3 peripheral reset register */
    uint32_t          RESERVED1;    /* Reserved */
    volatile uint32_t APB1RSTR1;    /* RCC APB1 peripheral reset register 1 */
    volatile uint32_t APB1RSTR2;    /* RCC APB1 peripheral reset register 2 */
    volatile uint32_t APB2RSTR;     /* RCC APB2 peripheral reset register */
    uint32_t          RESERVED2;    /* Reserved */
    volatile uint32_t AHB1ENR;      /* RCC AHB1 peripheral clock enable register */
    volatile uint32_t AHB2ENR;      /* RCC AHB2 peripheral clock enable register */
    volatile uint32_t AHB3ENR;      /* RCC AHB3 peripheral clock enable register */
    uint32_t          RESERVED3;    /* Reserved */
    volatile uint32_t APB1ENR1;     /* RCC APB1 peripheral clock enable register 1 */
    volatile uint32_t APB1ENR2;     /* RCC APB1 peripheral clock enable register 2 */
    volatile uint32_t APB2ENR;      /* RCC APB2 peripheral clock enable register */
} RCC_TypeDef;

typedef struct
{
    volatile uint32_t MODER;
    volatile uint32_t OTYPER;
    volatile uint32_t OSPEEDR;
    volatile uint32_t PUPDR;
    volatile uint32_t IDR;
    volatile uint32_t ODR;
    volatile uint32_t BSRR;
    volatile uint32_t LCKR;
    volatile uint32_t AFR[2];
} GPIO_TypeDef;

/* Peripheral instances */
#define RCC                   ((RCC_TypeDef *) RCC_BASE)
#define GPIOA                 ((GPIO_TypeDef *) GPIOA_BASE)
#define GPIOB                 ((GPIO_TypeDef *) GPIOB_BASE)

/* Bit definitions for RCC_AHB2ENR register */
#define RCC_AHB2ENR_GPIOAEN_Pos       (0U)
#define RCC_AHB2ENR_GPIOAEN           (0x1UL << RCC_AHB2ENR_GPIOAEN_Pos)

/* GPIO pin definitions */
#define GPIO_PIN_5                    (0x0020U)  /* Pin 5 selected */

/* GPIO mode definitions */
#define GPIO_MODE_INPUT               (0x00000000U)
#define GPIO_MODE_OUTPUT              (0x00000001U)
#define GPIO_MODE_AF                  (0x00000002U)
#define GPIO_MODE_ANALOG              (0x00000003U)

/* LED definitions for STM32L476RG-Nucleo board */
#define LD1_GPIO_PORT                 GPIOA
#define LD1_PIN                       GPIO_PIN_5
#define LD1_GPIO_CLK_ENABLE()         (RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN)

#ifdef __cplusplus
}
#endif

#endif /* __STM32L4XX_H */
