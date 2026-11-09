#include <stdio.h>
#include "source/src/buster/compiler/host_isa.h"
#include "identity-fixture-constant.inc"

int main(void)
{
    fprintf(stderr, "host-vector=%u\n", BUSTER_HOST_VECTOR);
    const size_t size = sizeof(check_test_tier1_reproducible_source) - 1;
    const int status = fwrite(check_test_tier1_reproducible_source, 1, size, stdout) == size ? 0 : 1;
    return status;
}
