/*小端输出的elf文件*/
OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
/*输出架构是ARM架构*/
OUTPUT_ARCH(arm)
/*程序入口是_start*/
ENTRY(_start)

/*规定MEMORY可读可写属性，起始地址，内存大小*/
MEMORY
{
    NORMAL (rw) : ORIGIN = %NORMAL_START%,  LENGTH = %NORMAL_LENGTH%      /* 62k internal Memory */
}

SECTIONS
{
    /*四字节对齐*/
    .text :ALIGN(4)
    {
/*KEEP 是链接脚本中的一个指令，它用于防止链接器在进行垃圾回收时丢弃未使用的
输入段。链接器有一个 --gc-sections 选项，它可以启用对未使用输入段的垃圾回收
。如果你想保留某些未使用的输入段，那么可以在链接脚本中使用 KEEP 指令来标记
这些段，这样链接器就不会丢弃它们了*/
      KEEP(*(.text.vectors))
      KEEP(*(.text*))
    /*runtime address在NORMAL段*/
    } > NORMAL

    . = ALIGN(4);/*这对下个段比如rodata段没有用*/
    .rodata :ALIGN(4)
    {
      *(.rodata*)
    } > NORMAL

    .data :ALIGN(4)
    {
        data_load_addr = LOADADDR(.data);
        data_start = . ;
        *(.data*)
        data_end = . ;
    } > NORMAL

    __bss_start = .;
    .bss :ALIGN(4)
    {
      *(.bss*)
      *(.COMMON)
    } > NORMAL
    __bss_end = . ;

    .stack (ORIGIN(NORMAL) +LENGTH(NORMAL)-%STACK_LENGTH%): ALIGN(4)
    {
    __stack_start = .;
    . = ALIGN(32);
    . += %STACK_LENGTH%;
    . = ALIGN(32);
    __stack_end = .;
    }
}
