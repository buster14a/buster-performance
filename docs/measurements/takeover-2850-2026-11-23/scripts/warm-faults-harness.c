// A standalone harness for the warm arenas' lane tests: lane.c and lane_test.c as one object, the tests' main alone.
#define BUSTER_ARRAY_LENGTH(array) (sizeof(array) / sizeof((array)[0]))
#include LANE_C
_Thread_local char oracle_temporary_buffer[4096];
#include LANE_TEST_C
int main(void)
{
    LaneTestTally tally = { 0 };
    lane_test_arena_warm(&tally);
    lane_test_arena_clear(&tally);
    printf("harness: %llu checks, %llu failed\n", (unsigned long long)tally.checks, (unsigned long long)tally.failures);
    return tally.failures != 0 || tally.checks < 6 ? 1 : 0;
}
