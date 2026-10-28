// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused fixture adapter. Child requests execute the exact frozen compiler, retaining its real command gates.
#include <stdint.h>
static uint64_t diagnostic_walk_failures;
#define main diagnostic_driver_main
#include "main-standalone.c"
#undef main
int main(int argc, char** argv)
{
    int result = 1;
    if (argc > 1)
    {
#if BUSTER_HOST_VECTOR
        argv[0] = "/home/david/Documents/Codex/2026-10-28/solv/work/compat-678-a11/build/compiler";
#else
        argv[0] = "/home/david/Documents/Codex/2026-10-28/solv/work/compat-678-a11-scalar/build/compiler";
#endif
        execv(argv[0], argv);
    }
    else
    {
        char directory[] = "/tmp/buster-location-host-XXXXXX";
        const bool created = mkdtemp(directory) != NULL;
        result = !(created && pp_directive_test_location_option(directory, true));
        if (created) rmdir(directory);
    }
    return result;
}
