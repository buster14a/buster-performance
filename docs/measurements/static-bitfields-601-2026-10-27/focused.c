// Original focused #601 checked-plan runner; main.c's unused commands are not emitted.
#define BUSTER_UNIT 999
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    CheckTest test = {0};
    CheckTestTypes types = {0};
    const bool ready = check_test_types_open(&types);
    check_test_expect(&test, ready, "focused type storage");
    if (ready)
    {
        check_data_test_bit_fields(&test, &types.table);
    }
    check_test_types_close(&types);
    printf("bit-field focused plans: %llu checks, %llu failed\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
