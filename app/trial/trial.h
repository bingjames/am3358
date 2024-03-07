#ifndef INCLUDE__TRAIL_H
#define INCLUDE__TRAIL_H

#include "debug.h"
#include "compiler.h"
#include "types.h"
#include "Mcu_Delay.h"

#define USED_STD_LIB_C (STD_ON)

typedef struct {
    uint32 sizelen;
    int data[1];
} S1;

typedef struct {
    uint32 sizelen;
    int data[2];
} S2;

typedef struct {
    uint32 sizelen;
    int data[];
} S3;

typedef struct {
    uint32 sizelen;
    int data[2];
} S4;

void trial_parameter(void);

inline static void trial_static_function(void)
{
    int var_i = 0x33;

    var_i = var_i + 1;
}

void trial_test_used(void);

void loop_cnt(void);

#endif
