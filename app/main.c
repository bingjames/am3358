#include "trial.h"
#include "debug.h"
#include "compiler.h"
#include "types.h"
#include "Mcu_Delay.h"
#include "stdarg.h"

/*function in static lib*/
extern void lib_gen_drv_func(void);

char var_a = 0x22;
int var_b = 0x33;
const int var_b2 = 0x2233;

/*const 修饰char类型变量会有反汇编问题*/
const char *var_b3 = (char *)0x402f0454;
char var_c = 0;
char var_d;
static uint32 var_g = 0x22;
static uint32 var_k;

int main(void)
{
    DBG(HSDK_INFO, "Hello AM3358\n");

    int var_e = 0x2233;
    int var_f;
    static uint32 var_h = 0x22;
    static uint32 var_l;

    var_e = var_e + 1;
    var_f = var_b2 + 1;
    var_e = var_f + var_e;
    var_g += 1;

    //trial_parameter();
    //trial_static_function();

    Mcu_PmuCounterInit();

    Mcu_udelay(10);

    /*function in static lib*/
    lib_gen_drv_func();

    trial_test_used();

    loop_cnt();

    while (1) {

    }

    return var_e;
}
