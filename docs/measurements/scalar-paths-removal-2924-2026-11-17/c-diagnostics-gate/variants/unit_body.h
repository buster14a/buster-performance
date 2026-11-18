#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>
#include <unistd.h>
#include <sys/mman.h>
#include <x86intrin.h>
typedef struct String8 String8;
struct String8
{
    char* pointer;
    uint64_t length;
};
#ifndef BUSTER_ARRAY_LENGTH
#define BUSTER_ARRAY_LENGTH(x) (sizeof(x) / sizeof((x)[0]))
#endif
#define BUSTER_S8(s) ((String8){ .pointer = (char*)(s), .length = sizeof(s) - 1 })
#include "buster/compiler/lane.c"
#include "buster/compiler/diagnostic.c"
#include "buster/compiler/diagnostic_test.c"
#include "buster/compiler/diagnostic_benchmark.c"
