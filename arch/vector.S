.text
.global _start
.global _startup
.weak do_undefined_instruction
.weak do_software_interrupt
.weak do_prefetch_abort
.weak do_data_abort

/*它定义了一个名为.text.vectors的内存段*/
/*"ax"表示该段具有可执行和可分配属性 allocated/executable */
/*%progbits 是一个type字段的标记，因为全称是program bits,表示该段包含程序内容，
包括代码、数据和调试相关信息*/
.section .text.vectors, "ax", %progbits
/*.arm 是一个汇编指令，它用于指定汇编器生成的代码是 ARM 模式的机器码。
ARM 模式是一种 32 位指令集，用于 ARM 处理器*/
.arm

_start:
	b _startup /*0x0*/
	ldr pc, _undefined_instruction_handler /*0x4*/
	ldr pc, _software_interrupt_handler /*0x8*/
	ldr pc, _prefetch_abort_handler /*0xC*/
	ldr pc, _data_abort_handler /*0x10*/
/*0x14*/
/*0x18*/
/*0x1C*/

_undefined_instruction_handler: .word do_undefined_instruction
_software_interrupt_handler:    .word do_software_interrupt
_prefetch_abort_handler:    .word do_prefetch_abort
_data_abort_handler:    .word do_data_abort


do_undefined_instruction:
    b do_undefined_instruction

do_software_interrupt:
    b do_software_interrupt

do_prefetch_abort:
    b do_prefetch_abort

do_data_abort:
    b do_data_abort
