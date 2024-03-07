#ifndef DEBUG_H_
#define DEBUG_H_

/*copy from hsdk h:huang*/
/* HSDK debug level */
#define HSDK_EMERG     0  /* System is unusable */
#define HSDK_ALERT     1  /* Action must be taken immediately */
#define HSDK_CRIT      2  /* Critical conditions */
#define HSDK_ERR       3  /* Error conditions */
#define HSDK_WARNING   4  /* Warning conditions */
#define HSDK_NOTICE    5  /* Normal, but significant, condition */
#define HSDK_INFO      6  /* Informational message */
#define HSDK_DEBUG     7  /* Debug-level message */

/* HSDK printf */
#if CONFIG_DEBUG
#if CONFIG_PRINTF_LIB
#include <stdio.h>
#else
#define printf(x...)
#endif/* end of CONFIG_PRINTF_LIB*/
#define hsdk_printf(level, x...)    do { if ((level) <= CONFIG_DEBUG_LEVEL) {printf(x); } } while (0)
#define PANIC()         hsdk_panic((const uint8_t *)__FILE__, (int)__LINE__)
#define ASSERT(x)       do { if (!(x)) PANIC(); } while (0)

static void hsdk_panic(const uint8_t *filename, int linenum)
{
    hsdk_printf(HSDK_EMERG, "Assertion failed at file:%s line: %d\n",
                filename, linenum);
    __BKPT;
    for(;;);
}

#else
#define DBG(level, x...)
#define PANIC()
#define ASSERT(x)
#define hexdump(ptr, len)
#define hexdump8_ex(ptr, len, disp_addr)
#endif

#endif // !DEBUG_H_
