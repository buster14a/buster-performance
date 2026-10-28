#define BUSTER_UNIT 99
#define main foreign_order_unused_main
#include "buster/compiler/main.c"
#undef main

_Thread_local ThreadContext thread_context = { .lane = { .count = 1 } };

int main(int argc, char** argv)
{
    int result = 1;
    if (argc >= 2 && strcmp(argv[1], "link-foreign") == 0)
    {
        result = run_foreign_link(argc - 2, argv + 2);
    }
    else
    {
        Arena arena = arena_reserve(1ull << 34);
        char directory[] = "/tmp/buster-order-XXXXXX";
        const bool ready = arena.base != 0 && mkdtemp(directory) != 0;
        const bool passed = ready && foreign_order_test(directory, &arena);
        printf("retained fixture directory: %s\n", directory);
        arena_release(&arena);
        result = passed ? 0 : 1;
    }
    scratch_release();
    return result;
}
