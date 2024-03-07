
#include "compiler.h"
#include "types.h"
#include "Mcu_Delay.h"

#define PMU_EN_CYCLE  0x80000000u
extern void write_pmcntenset(uint32 x);
extern void write_pmcr(uint32 x);
extern uint32 read_pmccntr(void);
extern uint32 read_pmcnten(void);

/**
 * @brief enable pmu counter
 *        this function can only called after Clock_Init();
 *
 */
void Mcu_PmuCounterInit(void)
{
    /*Turn on cycle counter*/
    write_pmcntenset(PMU_EN_CYCLE);

    /*Turn on  Performance Monitor,set cycle counter to 'increase 1 tick every 64 cpu cycle'*/
    write_pmcr(0x9);
}

uint32 Mcu_Read_Cnt(void)
{
    uint32 cnt_value_aux;
    cnt_value_aux = read_pmccntr();
    return cnt_value_aux;
}

boolean Mcu_Cnt_IsEnable(void)
{
    return ((read_pmcnten()&PMU_EN_CYCLE) == PMU_EN_CYCLE);
}

/**
 * @brief udelay
 * @details udelay based on performance monitor unit,
 * @param[in] us delay time in us. max time is 549 s.
 */
void Mcu_udelay(uint32 us)
{
    uint32 start_tick, tick_timeout, current_tick;
    uint32 pmu_abnormal_chk = 0;

    if ((0 == Mcu_Cnt_IsEnable) || (0 == us)) {
        return;
    }

    if (us > 61000000) {
        us = 61000000;
    }

    start_tick = Mcu_Read_Cnt();

    /*make sure cycled information: 100 loops takes: */
    while ((start_tick == Mcu_Read_Cnt()) && (pmu_abnormal_chk < 100));

    /*timeout check is not a must here, just in case the pmccntr abnormal*/
    if (pmu_abnormal_chk < 100) {
        tick_timeout = start_tick + PMU_US_TO_TICK(us);

        if (tick_timeout > start_tick) {
            /*tick_timeout is not overflowed*/
            do {
                current_tick = read_pmccntr();
            } while (
                (current_tick < tick_timeout)  &&
                (current_tick > start_tick)
            );

        } else {
            /*tick_timeout is overflowed*/
            do {
                current_tick = read_pmccntr();
            } while (
                (current_tick > start_tick)    ||
                (current_tick < tick_timeout)
            );

        }
    }
}

