#define BUSTER_UNIT BUSTER_UNIT_CHECKER
#include "main-smoke.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(void)
{
    CheckTest test = { .random = 612 };
    CheckTestTypes types = { 0 };
    if (check_test_types_open(&types))
    {
        check_test_overloads(&test, "clang");
        check_test_overload_sources(&test, "clang");
    }
    else
    {
        test.failures += 1;
    }
    check_test_types_close(&types);
    fprintf(stderr, "index-smoke: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
