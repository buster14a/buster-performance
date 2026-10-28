// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Runs the exact permanent #664 fixtures without the rest of the compiler's tests.
// home_fixture.inc is the unmodified function range from tier0_test.c at the recorded source revision.
#pragma clang diagnostic ignored "-Wunused-function"
#include "buster/compiler/tier0_benchmark.c"
#define BUSTER_TIER0_TEST_PAGE 4096u
typedef struct Tier0TestTally Tier0TestTally;
struct Tier0TestTally
{
    uint64_t checks;
    uint64_t failures;
};
static bool tier0_test_expect(Tier0TestTally* tally, bool condition, const char* check, const char* format, ...)
{
    tally->checks += 1;
    if (!condition)
    {
        tally->failures += 1;
        va_list arguments;
        va_start(arguments, format);
        fprintf(stderr, "%s: ", check);
        vfprintf(stderr, format, arguments);
        fputc('\n', stderr);
        va_end(arguments);
    }
    return condition;
}
#include "home_fixture.inc"
int main(void)
{
    Tier0TestTally tally = { 0 };
    tier0_test_home_candidates(&tally, 664);
    tier0_test_home_candidates(&tally, 20261028);
    printf("home checks: %" PRIu64 " checks, %" PRIu64 " failures\n", tally.checks, tally.failures);
    return tally.failures != 0;
}
