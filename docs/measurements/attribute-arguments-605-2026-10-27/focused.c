#define BUSTER_UNIT 99
#include "focused-main.c"

_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

int main(void)
{
    CheckTest test = { 0 };
    check_test_attributes(&test, "/usr/bin/clang");
    check_test_attribute_sources(&test, "/usr/bin/clang");
    printf("focused attributes: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
