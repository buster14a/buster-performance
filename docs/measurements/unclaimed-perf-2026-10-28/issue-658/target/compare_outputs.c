// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original exact-object validator for a samples.c campaign; one task per cohort.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static bool equal_files(const char* left, const char* right)
{
    FILE* first = fopen(left, "rb");
    FILE* second = fopen(right, "rb");
    bool equal = first != NULL && second != NULL;
    unsigned char a[16384];
    unsigned char b[16384];
    while (equal)
    {
        const size_t ac = fread(a, 1, sizeof(a), first);
        const size_t bc = fread(b, 1, sizeof(b), second);
        equal = ac == bc && memcmp(a, b, ac) == 0;
        if (ac != sizeof(a) || bc != sizeof(b))
        {
            equal &= !ferror(first) && !ferror(second);
            break;
        }
    }
    if (first != NULL)
    {
        fclose(first);
    }
    if (second != NULL)
    {
        fclose(second);
    }
    return equal;
}

int main(int argc, char** argv)
{
    unsigned failures = 0;
    const unsigned rounds = argc == 3 ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    if (rounds == 0 || rounds > 101)
    {
        failures += 1;
    }
    else
    {
        char first[4096];
        char current[4096];
        snprintf(first, sizeof(first), "%s/r000-role0/output-0000.o", argv[1]);
        for (unsigned round = 0; round < rounds; round += 1)
        {
            for (unsigned role = 0; role < 2; role += 1)
            {
                const int length = snprintf(current, sizeof(current), "%s/r%03u-role%u/output-0000.o", argv[1], round, role);
                const bool equal = length > 0 && (size_t)length < sizeof(current) && equal_files(first, current);
                if (!equal)
                {
                    fprintf(stderr, "different or absent object: %s\n", current);
                }
                failures += !equal;
            }
        }
    }
    printf("compare outputs: %u objects, %u failures\n", 2 * rounds, failures);
    return failures != 0;
}
