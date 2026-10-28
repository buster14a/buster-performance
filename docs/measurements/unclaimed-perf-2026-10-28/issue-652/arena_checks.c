// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original focused adapter for the arena's capacity, alignment, lifetime and page-policy checks.
#define _GNU_SOURCE
#define BUSTER_ARRAY_LENGTH(a) (sizeof(a) / sizeof((a)[0]))
#include "../issue-652/src/buster/compiler/lane.c"
#include "../issue-652/src/buster/compiler/lane_test.c"
int main(void)
{
    return !lane_test_arenas();
}
