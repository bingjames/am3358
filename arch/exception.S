.text
.global _start
.global _startup

.global do_undefined_instruction
.global do_software_interrupt
.global do_prefetch_abort
.global do_data_abort

/*它定义了一个名为.text.exception的内存段*/
/*"ax"表示该段具有可执行和可分配属性 allocated/executable */
/*%progbits 是一个type字段的标记，因为全称是program bits,表示该段包含程序内容，
包括代码、数据和调试相关信息*/
.section .text.exception, "ax", %progbits
.arm

do_undefined_instruction:
    /*context switching*/
    stmdb sp!,{r0-r12,lr}
    /*handle undefined instruction*/
    /*context switching*/
    ldmia sp!,{r0-r12,pc}^//^:CPSR = SPSR_[某一种异常模式]

do_software_interrupt:
    /*context switching*/
    stmdb sp!,{r0-r12,lr}
    /*handle software interrupt*/
    /*context switching*/
    ldmia sp!,{r0-r12,pc}^

do_prefetch_abort:
    /*context switching*/
    subs lr,#4
    stmdb sp!,{r0-r12,lr}
    /*handle prefetch abort*/
    /*context switching*/
    ldmia sp!,{r0-r12,pc}^

do_data_abort:
    sub lr,#8
    /*context switching*/
    stmdb sp!,{r0-r12,lr}
    /*handle data abort*/
    /*context switching*/
    ldmia sp!,{r0-r12,pc}^
