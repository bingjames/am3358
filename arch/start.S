
#include "asm_def.h"

.global _startup

.section .text.boot, "ax", %progbits
.arm

#define USR_MODE_AND_IRQ_DIS (0xf<<0|0x1<<7)
#define IRQ_DIS (0x1<<7)
#define SYS_MODE (0xf<<0)

_startup:
reset_hdlr:
    mov r0,#0
    mov r1 ,#0
    mov r2 ,#0
    mov r3 ,#0
    mov r4 ,#0
    mov r5 ,#0
    mov r6 ,#0
    mov r7 ,#0
    mov r8 ,#0
    mov r9 ,#0
    mov r10,#0
    mov r11,#0
    mov r12,#0
    mov sp,#0
    mov lr,#0
    mrs r4,cpsr/*把cpsr赋值给r4*/
/*f:flag field(PSR[31:24]),
s:status field(PSR[23:16]),
x:extend field(PSR[15:8]),
c: contorller field(PSR[7:0]),
主要关注f:flag field和c: contorller field
f:flag field主要关注
        N, bit[31] Negative condition flag.
        Z, bit[30] Zero condition flag.
        C, bit[29] Carry condition flag.
        V, bit[28] Overflow condition flag
c: contorller field
        M[4:0],bits[4:0] Mode field. This field determines the current mode of the processor.
            User                     usr                 10000
            FIQ                      fiq                 10001
            IRQ                      irq                 10010
            Supervisor               svc                 10011
            Monitor                  mon                 10110
            Abort                    abt                 10111
            Hyp                      hyp                 11010
            Undefined                und                 11011
            System                   sys                 11111
        T, bit[5] Thumb execution state bit.
        F, bit[6] FIQ mask bit.
        I, bit[7] IRQ mask bit.
*/
    msr spsr_fsxc,r4/*init spsr used cpsr value*/

    /*power on is on svc mode 10011*/
    /*close WDT*/

/*define exception handler*/
    ldr r0,=__stack_start
    cps MODE_SYS/*cps:change processor state*/
    mov sp,r0
    mov lr,#0
    msr spsr_fsxc,r4/*init spsr used cpsr value*/
    sub r0,r0,#0x1000
    cps MODE_ABT
    mov sp,r0
    mov lr,#0
    sub r0,r0,#0x50
    msr spsr_fsxc,r4/*init spsr used cpsr value*/
    cps MODE_UND
    mov sp,r0
    mov lr,#0
    sub r0,r0,#0x50
    msr spsr_fsxc,r4/*init spsr used cpsr value*/
    cps MODE_IRQ
    mov sp,r0
    mov lr,#0
    msr spsr_fsxc,r4/*init spsr used cpsr value*/
    sub r0,r0,#0x200
    cps MODE_FIQ
    mov r8 ,#0
    mov r9 ,#0
    mov r10,#0
    mov r11,#0
    mov r12,#0
    mov sp,r0
    mov lr,#0
    msr spsr_fsxc,r4/*init spsr used cpsr value*/
    sub r0,r0,#0x50
    cps MODE_SVC
    mov sp,r0

setup_vbar:
    @set non-secure mode exception base address/*@符号在汇编中表示注释*/
    ldr r0, =_start
/*这条命令表示把r0的值赋给cp15寄存器中的c12 opc1为0，协处理器的子寄存器
c0 opc2为0的寄存器，即Vector Base Address Register向量基地址寄存器*/
    mcr p15, 0, r0, c12, c0, 0

/*clr DFSR*/
    mov r0,#0
    mcr p15, 0, r0, c5, c0, 0
/*clr DFAR*/
    mcr p15, 0, r0, c6, c0, 0

/*clr IFSR*/
    mov r0,#0
    mcr p15, 0, r0, c5, c0, 1
/*clr IFAR*/
    mcr p15, 0, r0, c6, c0, 2

    /*switch to system mode*/
    mrs r0, cpsr
    //ldr r1,=USR_MODE_AND_IRQ_DIS
    ldr r1,=IRQ_DIS
/*BIC 指令用于对寄存器中的位进行清除操作。BIC 指令的一般形式是 BIC <目标寄存器>, 
<源寄存器1>, <源寄存器2>，它会将源寄存器2的位取反，然后与源寄存器1进行
按位与操作，并将结果存储在目标寄存器中。*/    
    bic r0, r0,r1
    ldr r1,=SYS_MODE
    orr r0, r0,r1
    msr cpsr, r0

/*inject undefined instruction exception*/
//und_code:
//    .word 0xdeadc0de

///*inject swi exception*/
//    swi 123

/*inject prefetch abort exception*/
//ldr pc,=0xFFFFFFF8

/*inject data abort exception*/
//ldr r1, =0x40202000
//ldr r0,[r1]

/*clear bss section method#2*/
    ldr r0, =__bss_start
    ldr r1, =__bss_end
    mov r2, #0
    mov r3, #0
    mov r4, #0
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0
    mov r9, #0

/*
STMIA Rn!, {Rlist}，其中Rn是目标地址寄存器，Rlist是要存储的寄存器列表。
STMIA指令将Rlist中的寄存器值存储到Rn指向的内存地址中，存储后Rn的值会自动增加，
增加的大小取决于Rlist中寄存器的个数。
*/
.bss_clr_loop:
    stmia r0!, {r2,r9}
    cmp r0, r1
/*less then or equal*/
    ble .bss_clr_loop

/*clear stack*/
    ldr r0, =__stack_start
    ldr r1, =__stack_end
/*diff value in stack is zero*/
    ldr r2, =0x5AA5F00F
    ldr r3, =0xA55A0FF0
    mov r4, r2
    mov r5, r3
    mov r6, r2
    mov r7, r3
    mov r8, r2
    mov r9, r3

.stack_clr_loop:
    stmia r0!, {r2,r9}
    cmp r0, r1
/*less then or equal*/
    ble .stack_clr_loop

/*used for application*/
    bl main
/*used for bootloader,.text段的起始地址是flash的地址*/
    /*ldr pc,=0x402F8400*/

halt:
    b halt
