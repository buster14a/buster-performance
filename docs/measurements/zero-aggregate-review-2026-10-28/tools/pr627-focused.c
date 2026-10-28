// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused review checks; production helpers and fixtures come from the named Buster source tree.
#define BUSTER_UNIT 99
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    CheckTest test = { .random = 133 };
    CheckTestTypes types = { 0 };
    const bool ready = check_test_types_open(&types);
    check_test_expect(&test, ready, "type storage");
    if (ready)
    {
        check_data_test_zero_bits(&test);
        check_data_test_symbolic_zero(&test, &types.table);
        check_data_test_zero_batch(&test, &types.table);
        check_data_test_dense_cache(&test, &types.table);
        check_data_test_direct_writes(&test, &types.table);
        check_data_test_boundary_sort(&test);
        check_data_test_bit_fields(&test, &types.table);
        check_data_test_overwrite_oracle(&test, &types.table);
        check_data_test_limits(&test, &types.table);
        check_data_test_complex(&test, &types.table);
        check_data_test_floating(&test);
    }
    check_test_types_close(&types);
    printf("initializer-review-focused: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
