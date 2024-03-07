#include "trial.h"
#include "debug.h"
#if (USED_STD_LIB_C == STD_ON)
#include <string.h>
#include <stddef.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#endif

//extern static unsigned int var_g = 0x22;
//extern unsigned int var_g;
/*function in static lib*/
extern void lib_gen_drv_func(void);
uint32 var_j_test = 0x33;
static unsigned int var_g = 0x33;

void trial_parameter(void)
{
    int var_i = 0x33;
    static unsigned int var_h = 0x22;

    //var_i = var_g;
    var_i = var_j_test;
    var_i = var_i;
    var_g += 1;

}

const char *var2 = NULL;
const char *var3 = NULL;
char str_list[] = "string";
uint32 string_expression = 'a' + 'b';
void func_test_used(void)
{
    uint8 num = 0;
    var2 = "string";
    var3 = str_list;
    num = sizeof(str_list);
}

uint32 p_ptr_used_argu = 200;
unsigned char q_ptr_used_argu = 'a';
unsigned char q_ptr_used_argu2 = 0x55;
unsigned char q_ptr_used_argu3 = 0x55;
unsigned char q_ptr_used_argu4 = 0x55;
uint32 *p_ptr;
unsigned char *q_ptr;
void foo_test_ptr(void)
{
    p_ptr = &p_ptr_used_argu;
    q_ptr = &q_ptr_used_argu;
    p_ptr = (uint32 *)q_ptr;
    *p_ptr = 100;
}

char array_a[];
char array_a[25];
uint32 lpCntArray[10] = {0};
void fusa_case_test(void)
{
    short cal_aux = 0;
    uint32 cal_aux_cnt = 0;
    uint32 lpCnt = 0;

    cal_aux_cnt = sizeof(char);
    cal_aux_cnt = sizeof(short);
    cal_aux_cnt = sizeof(int);
    cal_aux_cnt = sizeof(long);
    cal_aux_cnt = sizeof(float);
    cal_aux_cnt = sizeof(double);
    cal_aux_cnt = sizeof(cal_aux);
    cal_aux_cnt = sizeof(cal_aux + 1);
    cal_aux_cnt = sizeof(cal_aux + 1.1);

LOOP:

    while (lpCnt < 10) {
        static uint8 cntI = 0;

        if (lpCnt == 5) {
            lpCnt ++;
            goto LOOP;
        }

        lpCntArray[cntI] = lpCnt ++;
        cntI++;
    }
}

void stack_over_test_a(void);
void stack_over_test_b(void);
uint32 stack_used_cnt = 0;

void stack_over_test_a(void)
{
    uint32 a = 0;
    a++;
    stack_over_test_b();
    stack_used_cnt++;

    if (stack_used_cnt > 1024)
        return ;
}

void stack_over_test_b(void)
{
    stack_over_test_a();
}

void stack_over_test(void)
{
    stack_over_test_a();
}

uint32 cal_aux = 0;
S3 argu = {
    .sizelen = 10,
    .data[0] = 1,
    .data[1] = 2,
};
S3 *p1;

S4 argu2 = {
    .sizelen = 10,
    .data[0] = 1,
    .data[1] = 2,
};

void func_flexible_array(void)
{
    cal_aux = sizeof(S1);
    cal_aux = sizeof(S2);
    cal_aux = sizeof(S3);
    p1 = &argu;
    cal_aux = argu2.sizelen;
    cal_aux = argu2.data[0];
    cal_aux = argu2.data[1];
    cal_aux = argu2.data[2];
}

#if (USED_STD_LIB_C==STD_ON)
uint32 cntSavedArray[10] = {0};
void stdarg_test(int arg1, ...)
{
    va_list ap;//用来保存宏va_arg和va_end所需要的信息
    va_start(ap, arg1); //使va_list指向起始的参数
    int i = 0;
    uint8 cnt = 0;

    for (i = arg1; i != -1; i = va_arg(ap, int)) {
        cntSavedArray[cnt] = i;
        cnt++;
    }

    va_end(ap);//释放va_list
}

char test_str[] = "string";
void func_string_meme(void)
{
    uint32 cal_aux = 0;
    //cal_aux = strlen(test_str);
    //cal_aux = sizeof(test_str);
    cal_aux = strlen("string");
    cal_aux = sizeof("string");

}

#define FLineNumber 100
#if 0
void func_file_read_and_write(void)
{

    FILE *fp;
    char str[FLineNumber + 1];

    fp = fopen("./f_used_to_wr.txt", "ra") ;

    if (fp == NULL) {
        DBG("read file error\n");
        exit(0);
    }

    while (fgets(str, FLineNumber, fp) != NULL) {

    }

    fputs("test success\n", fp);

    fclose(fp);
}
#endif /*func_file_read_and_write endif*/
#endif
uint32 array_b[5] = {1, 2, 3, 4, 5};
void func_array(void);
void func_array(void)
{
    uint32 array_get = 0;
    uint32 *array_get_prt = NULL;
    array_get = (uint32)array_b;
    array_get_prt = array_b;
}

typedef struct test_struct {
    uint32 test_struct_ele;
    uint32 test_struct_ele2;
} test_struct_t, *test_struct_ptr;

test_struct_t test_a;
test_struct_ptr test_struct_ptr_a;
test_struct_t *test_struct_t_ptr_b;

void test_struct(void)
{
    test_struct_ptr_a = &test_a;
    test_struct_t_ptr_b = &test_a;
}


/*const类型测试*/
typedef const struct const_stru {
    uint32 const_stru_var1;
    uint32 *const_stru_var2;
} const_stru_t;

typedef const struct const_stru2 {
    const uint32 *const_stru_var3;
} const_stru2_t;

//const typedef struct const_stru3 {
typedef struct const_stru3 {
    uint32 const_stru_var4;
} const_stru3_t;

const_stru_t const_stru_ptr = {
    .const_stru_var1 = 1,
    .const_stru_var2 = NULL,
};

const_stru3_t const_stru_ptr2 = {
    .const_stru_var4 = 1,
};

void test_struc_const_var(void)
{
    uint32 a = 0xff;
    uint32 b = 0xff;
    const_stru_t const_stru_used_var1 = {
        .const_stru_var1 = 1,
        .const_stru_var2 = &a,
    };
    //const_stru_used_var1.const_stru_var1 = 1;


}

void test_const_var(void)
{
    uint32 a = 22;
    uint32 b = 33;
    uint32 c = 44;
    const uint32 *p1 = &a;
    uint32 const *p2 = &b;
    uint32 *const p3 = &c;
    //*p1 = 33;//非法
    //*p2 = 33;//非法
    //p1 = &b;
    //p2 = &a;
    *p3 = 55;
    //p3 = &a;
}

uint8 test_local_variable_add(uint8 var)
{
    var++;
    return var;
}

uint8 test_local_variable(void)
{
    uint8 a = 0;
    test_local_variable_add(a);

    return a;
}

void trial_test_used(void)
{

    /*funcation test used*/
    func_test_used();

    /*test ptr used*/
    foo_test_ptr();

    /*fusa case test*/
    fusa_case_test();

    /*stack over test*/
    //stack_over_test();

    /*隐式定义*/
    //test_yinshi_shengming();

    /*灵活数组*/
    func_flexible_array();

#if (USED_STD_LIB_C == STD_ON)
    /*stdarg test*/
    stdarg_test(1, 2, 3,
                -1);//也可以不用-1作为结束字符，而在第一个入参使用size表示传入多少个参数

    /*字符串占用的内存空间*/
    func_string_meme();

    /*文件读改写*/
    //func_file_read_and_write();
#endif

    /*数组的数组名*/
    func_array();

    /*结构体指针定义*/
    test_struct();

    /*测试库文件是否链接两次*/
    lib_gen_drv_func();


    /*const类型测试*/
    test_struc_const_var();
    test_const_var();

    /*局部变量测试*/
    uint8 ret = 0;
    ret = test_local_variable();
}

void test_yinshi_shengming(void)
{
    uint32 a = 0;
    a++;
}

uint32 test_num = 0;
uint32 test_num_array[20];
void loop_cnt(void)
{
    while (1) {
        for (uint16 i = 0; i < 20; i++) {
            test_num_array[i] = test_num;

        }

        test_num = test_num + 1;

        if (test_num >= 0xFFFF) {

            test_num = 0;
        }


    }
}

