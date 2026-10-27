// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original diagnostic entry into the committed #611 metadata/scaling tests. probe_main.c is main.c with
// BUSTER_ELSEWHERE made static, so this standalone diagnostic keeps the compiler's module homes in one unit.
#define BUSTER_UNIT 99
#include "probe_main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    CheckTest test = { .random = 133 };
    check_test_vla_metadata(&test);
    check_test_vla_scaling(&test);
    printf("focused VLA metadata/scaling: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
