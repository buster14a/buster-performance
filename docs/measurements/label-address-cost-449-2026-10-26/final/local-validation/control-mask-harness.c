// Focused harness: unit 99 exports no main.c command, so only these kernels' actual dependencies are compiled.
#include <stdbool.h>
static int main_command(int argc, char** argv, bool* found) __attribute__((unused));
#define BUSTER_UNIT 99
#include "../src/buster/compiler/main.c"

_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

int main(void)
{
    CheckTest test = { 0 };
    check_test_control_masks(&test);
    check_test_control_walks(&test);
    printf("control-mask harness: %llu checks, %llu failures\n", (unsigned long long)test.checks, (unsigned long long)test.failures);
    return test.failures != 0;
}
