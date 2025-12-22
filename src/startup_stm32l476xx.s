/**
 ******************************************************************************
 * @file      startup_stm32l476xx.s
 * @brief     STM32L476xx Devices vector table for GCC toolchain.
 ******************************************************************************
 */

.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global g_pfnVectors
.global Default_Handler

/* start address for the initialization values of the .data section */
.word _sidata
/* start address for the .data section */
.word _sdata
/* end address for the .data section */
.word _edata
/* start address for the .bss section */
.word _sbss
/* end address for the .bss section */
.word _ebss

/**
 * @brief  This is the code that gets called when the processor first
 *         starts execution following a reset event.
 */
    .section .text.Reset_Handler
    .weak Reset_Handler
    .type Reset_Handler, %function
Reset_Handler:
    ldr   r0, =_estack
    mov   sp, r0          /* set stack pointer */

/* Copy the data segment initializers from flash to SRAM */
    ldr r0, =_sdata
    ldr r1, =_edata
    ldr r2, =_sidata
    movs r3, #0
    b LoopCopyDataInit

CopyDataInit:
    ldr r4, [r2, r3]
    str r4, [r0, r3]
    adds r3, r3, #4

LoopCopyDataInit:
    adds r4, r0, r3
    cmp r4, r1
    bcc CopyDataInit

/* Zero fill the bss segment. */
    ldr r2, =_sbss
    ldr r4, =_ebss
    movs r3, #0
    b LoopFillZerobss

FillZerobss:
    str  r3, [r2]
    adds r2, r2, #4

LoopFillZerobss:
    cmp r2, r4
    bcc FillZerobss

/* Call the main function */
    bl main
    bx lr
.size Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt.
 */
    .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
    b Infinite_Loop
    .size Default_Handler, .-Default_Handler

/******************************************************************************
*
* The STM32L476xx vector table.
*
******************************************************************************/
    .section .isr_vector,"a",%progbits
    .type g_pfnVectors, %object
    .size g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
    .word _estack
    .word Reset_Handler
    .word NMI_Handler
    .word HardFault_Handler
    .word MemManage_Handler
    .word BusFault_Handler
    .word UsageFault_Handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word SVC_Handler
    .word DebugMon_Handler
    .word 0
    .word PendSV_Handler
    .word SysTick_Handler
    .word WWDG_IRQHandler                   /* Window WatchDog              */
    .word PVD_PVM_IRQHandler                /* PVD/PVM through EXTI         */
    .word TAMP_STAMP_IRQHandler             /* Tamper and TimeStamps        */
    .word RTC_WKUP_IRQHandler               /* RTC Wakeup                   */

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler.
*
*******************************************************************************/

    .weak      NMI_Handler
    .thumb_set NMI_Handler,Default_Handler

    .weak      HardFault_Handler
    .thumb_set HardFault_Handler,Default_Handler

    .weak      MemManage_Handler
    .thumb_set MemManage_Handler,Default_Handler

    .weak      BusFault_Handler
    .thumb_set BusFault_Handler,Default_Handler

    .weak      UsageFault_Handler
    .thumb_set UsageFault_Handler,Default_Handler

    .weak      SVC_Handler
    .thumb_set SVC_Handler,Default_Handler

    .weak      DebugMon_Handler
    .thumb_set DebugMon_Handler,Default_Handler

    .weak      PendSV_Handler
    .thumb_set PendSV_Handler,Default_Handler

    .weak      SysTick_Handler
    .thumb_set SysTick_Handler,Default_Handler

    .weak      WWDG_IRQHandler
    .thumb_set WWDG_IRQHandler,Default_Handler

    .weak      PVD_PVM_IRQHandler
    .thumb_set PVD_PVM_IRQHandler,Default_Handler

    .weak      TAMP_STAMP_IRQHandler
    .thumb_set TAMP_STAMP_IRQHandler,Default_Handler

    .weak      RTC_WKUP_IRQHandler
    .thumb_set RTC_WKUP_IRQHandler,Default_Handler
