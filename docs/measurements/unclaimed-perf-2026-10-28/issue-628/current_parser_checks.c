// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused sanitizer adapter; main-standalone.c changes only BUSTER_ELSEWHERE so section GC can drop the renamed driver.
#define main buster_unused_main
#include "current-main-standalone.c"
#undef main

int main(void)
{
    const PPOptions options = { .language = { .standard = 2017, .gnu = true }, .no_standard_includes = true };
    char directory[] = "/tmp/buster-parser-628-XXXXXX";
    unsigned failures = parse_test_workspace_budget();
    if (mkdtemp(directory) != NULL)
    {
        failures += parse_test_borrowed_scratch(&options, directory, 628);
        failures += rmdir(directory) != 0;
    }
    else
    {
        failures += 1;
    }
    printf("parser628 focused: %u failures\n", failures);
    return failures != 0;
}
