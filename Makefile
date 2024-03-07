######################################
# target
######################################
TARGET = test_am3358

#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-

# The gcc compiler bin path can be either defined in make command via GCC_PATH
# variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
CC = $(PREFIX)gcc
# -x选项是用来指定输入文件的语言类型 x的全称是language
# assembler-with-cpp 是一个编译器选项，它指示编译器将汇编代码中的 C 预处理指令传
# 递给 C 预处理器进行处理。
# -DASSEMBLY 是一个编译器选项，它用于定义一个名为 ASSEMBLY 的预处理器宏。
AS = $(PREFIX)gcc -xassembler-with-cpp -DASSEMBLY
CP = $(PREFIX)objcopy
DP = $(PREFIX)objdump
#  The -O binary option specifies that the output target should be a
#  raw binary file.
#  The -S option means that all symbol and relocation information will
#  be discarded
BIN = $(CP) -O binary -S
# arm-none-eabi-objdump -D is a command that can be used to disassemble
# binary files into assembly code.
DIS = $(DP) -D
# 如果命令行前加上@符号，则该命令将被静默执行，
# 即不会在终端显示命令本身，只会显示命令的执行结果。
AT = @

# -O0 这个参数告诉编译器不要优化 -O的英文全称 optimization level，
#  意思是优化级别。
#-g选项表示生成调试信息 -g的英文全称 generate debugging information
#-gdwarf-2 -gdwarf-2选项表示生成DWARF version 2格式的调试信息。DWARF
# 是一种用于描述程序结构和数据的标准化调试数据格式。
# -march=armv7-a 指定使用ARMv7-a架构(使用isb等命令时不会编译报错)
OPT = -O0 -g -gdwarf-2 -march=armv7-a

#SRAM TOTAL BYTE IS 0xFBFF byte
# used for bootloader
#NORMAL_START   =0x402F0400
#changed to DDR memory
NORMAL_START   =0x82000000
# used for application
NORMAL_LENGTH  =0xF000

#0x3000byte = 12KB
STACK_LENGTH  =0x3000

#	app/lib_gen/lib_gen_drv.c \
######################################
# source
######################################
# C sources
C_SOURCES =  \
	app/main.c \
	app/trial/trial.c \
	driver/source/Mcu_Delay.c

# ASM sources
ASM_SOURCES = \
	arch/start.S \
	arch/vector.S \
	arch/exception.S \
	driver/source/Mcu_Delay_asm.S

# AS includes
AS_INCLUDES = \
-Iarch/ \
-Iinclude/

#-Iapp/lib_gen \
# C includes
C_INCLUDES =  \
-Idriver/include \
-Iapp/trial \
-Iinclude/

#使用arm-none-eabi-ar -r 目标静态库 需要用到的.o文件生成libs
#示例: arm-none-eabi-ar -r test.a need_file/*.o
Libs=lib/lib_gen_drv.a

# -Werror是一个编译选项，它表示把所有的警告当作错误来处理
# -I是一个编译选项，它表示添加一个或多个头文件的搜索路径
ASFLAGS += -Werror $(AS_INCLUDES)
CFLAGS += $(OPT) $(C_INCLUDES)
ASFLAGS += $(OPT)

# -f 是一个通用的 GCC 选项前缀，它表示“开启某个特性”。
# 用于告诉编译器将每个数据放置到对象文件中的自己的节中。
# 这可以使链接器在链接时更容易地删除未使用的代码和数据。
ASFLAGS += -fdata-sections -ffunction-sections
CFLAGS += -fdata-sections -ffunction-sections
# 测试添加一个全局变量的宏
#ASFLAGS += -DTEST_GLOBAL_MACRO

# Generate dependency information
# -MD 告诉编译器生成依赖文件 D表示dependency
# 这个文件包含了源文件依赖的所有头文件列表。
# 依赖文件通常用于在源文件或头文件被修改后重新构建目标文件。
# -MF指定了依赖文件的名称 F表示file
# $(@:%.o=%.d)表示为每一个目标文件生成依赖文件
# 比如，如果目标文件名是example.o，那么$(@:%.o=%.d)将生成example.d作为依赖文件的名称，
# 这个文件会被-MF选项使用来指定生成依赖文件的名称
CFLAGS += -MD -MF"$(@:%.o=%.d)"
# 未使用的变量或者函数作为warning
#CFLAGS += -Wunused

#######################################
# LDFLAGS
#######################################
# link script
LINK_SCRIPT = arch/lnk.lds
LINK_SCRIPT_IN = arch/lnk.in.lds

# -specs=nano.specs是一个编译选项，它表示使用newlib-nano作为标准C库。
#  newlib-nano是一个针对代码大小优化的C库，它比标准的newlib更小，但是功能也更少
# -T $(LINK_SCRIPT)表示使用$(LINK_SCRIPT)这个变量指定的文件作为链接脚本。-T选项
#  的英文全称是Tape Archive (磁带归档)
#  -Wl 选项的英文全称是 Warning linker，意思是给连接程序发出警告。
#  这个选项可以让你控制连接程序的行为。
#  -Wl 选项可以接受一个或多个参数，通常用空格或等号（‘=’）来分隔选项名和参数。
#  这些参数都会被传递给连接程序
#  -Wl,-Map= 是一个 GCC 选项，它可以让连接程序生成一个映射文件。
#  映射文件可以显示连接程序如何将输入文件的各个部分放置在输出文件的各个段中
#  --cref 是一个 GNU binutils 连接程序的选项，它可以让连接程序在标准输出上
#  打印一个交叉引用表, –cref 的英文全称是 cross-reference
#  --cref用于在生成的Map文件中添加交叉引用（cross reference）信息。
# 具体来说，它告诉链接器生成一个包含所有符号（如函数和变量等）及其被引用（即被调用或使用）情况的列表。
#  -nostartfiles表示不链接标准启动文件。
#  -nodefaultlibs 表示不链接标准库
#  -nostdlib表示不链接系统库。
#  -Wl,--gc-sections表示删除未使用的代码段和数据段。 –gc-sections 的英文全称是
#  garbage collect unused sections
LDFLAGS = -specs=nano.specs -T $(LINK_SCRIPT) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -nostartfiles -nodefaultlibs -nostdlib
# LDFLAGS += -Wl,--gc-sections

#######################################
# build the application
#######################################
# list of objects

# default action: build all
# Make文件的程序入口
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin $(BUILD_DIR)/$(TARGET).dis

#######################################
# build the application
#######################################
# list of objects
# addprefix函数的作用是给一系列文件名添加一个前缀。例如
# $ (addprefix prefix,names…)会把names中的每个文件名都加上prefix这个字符串。
# notdir函数的作用是从一系列文件名中去掉目录部分，只保留文件名。
# $(C_SOURCES:.c=.o)是一个替换函数，它把C_SOURCES变量中的所有.c文件名
# 替换成.o文件名。
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.S=.o)))
# vpath是makefile中的一个指令，它是VPATH的小写形式。VPATH是makefile中的一个变量，
# 它表示搜索路径（Search Path for All Prerequisites）。因此，vpath可能是VPATH的
# 缩写，或者是variable path（变量路径）的意思。  Prerequisites:先决条件
# 表示当make需要找寻.c文件的依赖关系时，会在sort后的目录查找。
# $(dir $(C_SOURCES))是一个提取目录部分的函数，它把C_SOURCES变量中
# 的所有文件名都替换成它们所在的目录名
# # sort函数的作用是对一系列单词进行字典序排序，并去掉重复的单词。例如，
# $ (sort a b a a c)会产生结果‘ a b c ’。
vpath %.c $(sort $(dir $(C_SOURCES)))
vpath %.S $(sort $(dir $(ASM_SOURCES)))

#arm-none-eabi-nm -n -t *.elf(or *.o) > symbol_table.txt来创建symbol table
# 此处的$(LINK_SCRIPT)是为了执行 $(LINK_SCRIPT) : $(LINK_SCRIPT_IN) 而额外添加的
# -c选项表示只进行编译，不进行链接；-o选项表示指定输出文件的名称。

$(BUILD_DIR)/%.elf : $(LINK_SCRIPT) $(OBJECTS)
	$(CC) $(OBJECTS)  $(Libs) $(LDFLAGS) -o $@

$(BUILD_DIR)/%.o : %.c
#	$(AT)echo "$<"
#	$(AT)echo "$@"
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o : %.S
	$(AS) -c $(ASFLAGS) -o $@ $<

$(BUILD_DIR)/%.bin : $(BUILD_DIR)/%.elf
	$(BIN) $< $@

$(BUILD_DIR)/%.dis : $(BUILD_DIR)/%.elf
	$(DIS) $< > $@

$(BUILD_DIR):
	$(AT)mkdir -p $@

$(LINK_SCRIPT) : $(LINK_SCRIPT_IN)
	$(AT)echo "generate link script"
	$(AT)rm $@ -rf
	$(AT)sed "s/%NORMAL_START%/$(NORMAL_START)/g; s/%NORMAL_LENGTH%/$(NORMAL_LENGTH)/g; s/%STACK_LENGTH%/$(STACK_LENGTH)/g;" $< > $@

#######################################
# clean up
#######################################
clean:
	$(AT)rm -fR $(BUILD_DIR)/*

.SECONDARY:
.PHONY: clean cscope help clean_all $(LINK_SCRIPT)
