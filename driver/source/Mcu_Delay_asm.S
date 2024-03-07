
#include "compiler.h"

.global _startup

.section .text, "ax", %progbits
.arm

    ASM_PUBLIC write_pmcntenset
ASM_FUNCTION(write_pmcntenset) /*virtual timer value register*/
    mcr p15, 0, r0, c9, c12, 1
    bx lr

    ASM_PUBLIC write_pmcr
ASM_FUNCTION(write_pmcr) /*counter frequency register*/
    mcr p15, 0, r0, c9, c12, 0
    bx lr

    ASM_PUBLIC read_pmccntr
ASM_FUNCTION(read_pmccntr) /*counter frequency register*/
    mrc p15, 0, r0, c9, c13, 0
    isb
    bx lr

    ASM_PUBLIC read_pmcnten
ASM_FUNCTION(read_pmcnten) /*virtual timer value register*/
    mrc p15, 0, r0, c9, c12, 1
    bx lr

