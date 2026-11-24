#define _GNU_SOURCE
#define BUSTER_ARRAY_LENGTH(a) (sizeof(a) / sizeof((a)[0]))
#include LANE_C
#include "buster/compiler/lane_test.c"
int main(void)
{
    LaneTestTally tally = { 0 };
    lane_test_medium_pages(&tally);
    printf("medium pages: %llu failures\n", (unsigned long long)tally.failures);
    return tally.failures != 0;
}
