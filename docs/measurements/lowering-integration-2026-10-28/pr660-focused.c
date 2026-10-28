// Original takeover integration runner for the retained-data and bounded-bit-field paths.
#define BUSTER_UNIT 999
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    CheckTest test = { 0 };
    CheckTestTypes types = { 0 };
    const bool ready = check_test_types_open(&types);
    check_test_expect(&test, ready, "focused type storage");
    if (ready)
    {
        check_data_test_bit_fields(&test, &types.table);
        check_data_test_retained_payloads(&test, &types.table);
        check_data_test_aggregate_transaction(&test, &types.table);
        check_data_test_many_fixups(&test, &types.table);
        check_data_test_address_bit_fields(&test, &types.table);
    }
    check_test_types_close(&types);
    printf("static-data integration: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
