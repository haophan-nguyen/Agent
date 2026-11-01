/*
 * Copyright 2019 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "board.h"
#include "app.h"

/*******************************************************************************
 * Definitions
 ******************************************************************************/

/*******************************************************************************
 * Prototypes
 ******************************************************************************/

/*******************************************************************************
 * Variables
 ******************************************************************************/

/*******************************************************************************
 * Code
 ******************************************************************************/
void SysTick_Handler(void)
{
    /* Toggle pin connected to LED */
    GPIO_PortToggle(BOARD_LED_GPIO, 1u << BOARD_LED_GPIO_PIN);
}

/*!
 * @brief Main function
 */
int main(void)
{
    /* Board pin init */
    BOARD_InitHardware();

    /* Toggle every 500 ms using the configured processor clock. */
    const uint32_t systickTicks = SystemCoreClock / 2U;
    if ((systickTicks == 0U) || ((systickTicks - 1U) > SysTick_LOAD_RELOAD_Msk))
    {
        /* Reject an interval outside the 24-bit SysTick reload range. */
        while (1)
        {
        }
    }

    /* Preserve the existing priority, control bits, and interrupt masks. */
    SysTick->LOAD = systickTicks - 1U;
    SysTick->VAL = 0U;

    while (1)
    {
    }
}
