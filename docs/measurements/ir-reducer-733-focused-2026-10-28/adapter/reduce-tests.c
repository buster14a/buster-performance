#define BUSTER_UNIT 99
#include "oracle-prefix.h"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
#include "buster/compiler/ir_rebuild.c"
#include "buster/compiler/ir_reduce.c"
#include "buster/compiler/ir_reduce_oracle.c"
#include "buster/compiler/ir_reduce_test.c"
#include "buster/compiler/ir_reduce_driver.c"
#include "buster/compiler/ir_reduce_driver_test.c"
int main(int argc, char** argv)
{
    const int result = argc > 1 && strcmp(argv[1], "reduce-ir") == 0 ? run_ir_reduce(argc - 2, argv + 2) : run_ir_reduce_tests(argc - 1, argv + 1);
    return result;
}
