
#ifndef MCU_DELAY_H
#define MCU_DELAY_H

#include "types.h"

void Mcu_PmuCounterInit(void);
uint32 Mcu_Read_Cnt(void);
boolean Mcu_Cnt_IsEnable(void);
void Mcu_udelay(uint32 us);

#define Mcu_Frequency 500000000

/*为了防止溢出，将64拆成了8*8,us最大值是64s*/
/*1us除以64个500MHZ对应的时间周期，得到1us等于多少个PMU COUNTER*/
/*1us等于1MHZ分之一*/
#define PMU_US_TO_TICK(us) ((uint32)(((us)*(Mcu_Frequency/8000000))/8))

#endif
