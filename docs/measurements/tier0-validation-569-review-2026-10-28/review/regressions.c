// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
#define main matrix_main
#include "validation.c"
#undef main
int main(void)
{
    Tier0TestTally tally = { 0 };
    uint8_t kinds[128];
    uint8_t classes[128];
    uint64_t values[128];
    Tier0TestStream stream = { .kinds = kinds, .classes = classes, .values = values, .capacity = 128 };
    uint64_t taken[2] = { 0 };
    uint8_t* pages = mmap(0, 6 * BUSTER_TIER0_TEST_PAGE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    bool valid = pages != MAP_FAILED;
    for (uint32_t column = 0; valid && column < 3; column += 1)
    {
        valid = mprotect(pages + (column * 2 + 1) * BUSTER_TIER0_TEST_PAGE, BUSTER_TIER0_TEST_PAGE, PROT_NONE) == 0;
    }
    if (valid)
    {
        tier0_test_scan_review_regressions(&tally, &stream, pages + BUSTER_TIER0_TEST_PAGE, taken);
    }
    if (pages != MAP_FAILED)
    {
        munmap(pages, 6 * BUSTER_TIER0_TEST_PAGE);
    }
    printf("review regressions: %" PRIu64 " checks, %" PRIu64 " failures\n", tally.checks, tally.failures);
    scratch_release();
    return valid && tally.failures == 0 ? 0 : 1;
}
