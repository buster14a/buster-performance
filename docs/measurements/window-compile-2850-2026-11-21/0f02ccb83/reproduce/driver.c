#include "buster/compiler/c_preprocessor_benchmark.c"
_Thread_local char oracle_temporary_buffer[BUSTER_TEST_TEMPORARY_BYTES];
int main(int argc, char **argv) { return run_preprocessor_command(argc - 1, argv + 1); }
