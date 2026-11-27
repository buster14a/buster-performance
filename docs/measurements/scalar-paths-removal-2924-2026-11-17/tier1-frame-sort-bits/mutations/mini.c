// One frame planner, from the tree on the include path, behind a wrapper named SIDE.
#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <inttypes.h>
typedef struct String8 String8;
struct String8
{
    char* pointer;
    uint64_t length;
};
#include "buster/compiler/lane.c"
#include "buster/compiler/c_types.c"
#include "buster/compiler/calling_convention.c"
#include "mutated-frame.c"

#ifndef BUSTER_ARRAY_LENGTH
#define BUSTER_ARRAY_LENGTH(a) (sizeof(a)/sizeof((a)[0]))
#endif
#include "buster/compiler/tier1_frame_test.c"
int main(int argc, char** argv)
{
    Tier1FrameTest test = {0};
    if (argc == 2) variant = (unsigned)atoi(argv[1]);
    tier1_frame_test_sort(&test);
    printf("variant %u: %lu failed of %lu checks\n",variant,test.failures,test.checks);
    return test.failures != 0;
}
