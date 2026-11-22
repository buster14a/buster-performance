#include "buster/compiler/c_refine_benchmark.c"
#include "buster/compiler/c_refine_test.c"
int main(int argc, char** argv)
{
    return run_refinement_tests(argc - 1, argv + 1);
}
