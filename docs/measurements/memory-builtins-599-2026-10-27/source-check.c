// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#include <stdio.h>
#include <string.h>
extern int subject_wide(int), subject_small(int), oracle_wide(int), oracle_small(int);
extern unsigned char subject_a[512], subject_b[512], oracle_a[512], oracle_b[512];
extern int subject_effects[3], oracle_effects[3];
int main(void)
{
    unsigned checks = 0, failed = 0;
    for (int n = -512; n <= 512; n++)
    {
        int actual = subject_wide(n), expected = oracle_wide(n);
        checks++;
        failed += actual != expected || memcmp(subject_a, oracle_a, 512) || memcmp(subject_b, oracle_b, 512);
        actual = subject_small(n); expected = oracle_small(n);
        checks++;
        failed += actual != expected || memcmp(subject_a, oracle_a, 512) || memcmp(subject_b, oracle_b, 512) || memcmp(subject_effects, oracle_effects, sizeof(subject_effects));
    }
    printf("source acceptance: %u checks, %u failures\n", checks, failed);
    return failed != 0;
}
