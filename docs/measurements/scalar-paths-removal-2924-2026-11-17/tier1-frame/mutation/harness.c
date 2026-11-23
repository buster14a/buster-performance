#include "host_isa.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
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
#include "buster/compiler/tier1_frame.c"
#include "buster/compiler/tier1_frame_test.c"
int main(int argc, char** argv) { return run_tier1_frame_tests(argc, argv); }
