// Standalone runner of test-x86-encoder for the C10 mutation campaign.
#include "buster/compiler/host_isa.h"
#include "buster/compiler/x86_64_encoder.c"
#include "buster/compiler/x86_64_encoder_test.c"
int main(int argc, char** argv)
{
    return run_x86_encoder_tests(argc - 1, argv + 1);
}
