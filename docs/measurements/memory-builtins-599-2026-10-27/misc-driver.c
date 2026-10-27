#define BUSTER_UNIT BUSTER_UNIT_BACKEND
#include "buster/compiler/main.c"
_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };
int main(int argc, char **argv)
{
    return run_builtin_misc_lower_tests(argc - 1, argv + 1);
}
