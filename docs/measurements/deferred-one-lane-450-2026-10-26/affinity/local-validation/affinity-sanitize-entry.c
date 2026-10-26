#define main buster_unused_main
#include "sanitize-main.c"
#undef main

int main(int argc, char** argv)
{
    int result = 2;
    if (argc > 1 && strcmp(argv[1], "test-checker-deferred") == 0)
    {
        result = run_checker_deferred_tests(argc - 2, argv + 2);
    }
    else if (argc > 1 && strcmp(argv[1], "test-lanes") == 0)
    {
        result = run_lane_tests(argc - 2, argv + 2);
    }
    return result;
}
