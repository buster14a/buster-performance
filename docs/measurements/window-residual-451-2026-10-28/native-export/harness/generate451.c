// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
// #451 review: C sources whose line ends are sparse, for benchmark-preprocessor's windows. `generate451 KIND PATH BYTES
// SEED` writes about BYTES bytes of:
// - long-lines: declarations on lines of 5,000 to 12,000 bytes (int vN = 1 + 2 + ...;), one short line in eight;
// - spliced: macros defined over 20 to 200 KB of lines continued by splices (#define MN(X) \, then X(aI, bI) \, ...),
//   as x86_64_encoder.c's BUSTER_X86_VECTOR_FORMS is, with a few short lines between them.
// A splitmix64 sequence from SEED picks the lengths, so a seed always writes the same file.

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint64_t generate_random(uint64_t* state)
{
    *state += 0x9E3779B97F4A7C15ull;
    uint64_t z = *state;
    z = (z ^ (z >> 30)) * 0xBF58476D1CE4E5B9ull;
    z = (z ^ (z >> 27)) * 0x94D049BB133111EBull;
    return z ^ (z >> 31);
}

int main(int argc, char** argv)
{
    int status = 1;
    FILE* file = argc == 5 ? fopen(argv[2], "w") : 0;
    const uint64_t bytes = argc == 5 ? strtoull(argv[3], 0, 0) : 0;
    uint64_t random = argc == 5 ? strtoull(argv[4], 0, 0) : 0;
    const int long_lines = argc == 5 && strcmp(argv[1], "long-lines") == 0;
    const int spliced = argc == 5 && strcmp(argv[1], "spliced") == 0;
    if (file != 0 && (long_lines || spliced))
    {
        uint64_t written = 0;
        uint64_t item = 0;
        while (written < bytes)
        {
            if (long_lines)
            {
                const uint64_t target = generate_random(&random) % 8 == 0 ? 20 + generate_random(&random) % 60 : 5000 + generate_random(&random) % 7001;
                uint64_t line = (uint64_t)fprintf(file, "int v%llu = 1", (unsigned long long)item);
                for (uint64_t term = 2; line + 2 < target; term += 1)
                {
                    line += (uint64_t)fprintf(file, " + %llu", (unsigned long long)term);
                }
                line += (uint64_t)fprintf(file, ";\n");
                written += line;
            }
            else
            {
                const uint64_t target = 20000 + generate_random(&random) % 180001;
                uint64_t macro = (uint64_t)fprintf(file, "#define M%llu(X) \\\n", (unsigned long long)item);
                for (uint64_t i = 0; macro < target; i += 1)
                {
                    macro += (uint64_t)fprintf(file, "    X(a%llu, b%llu, %llu) \\\n", (unsigned long long)i, (unsigned long long)(i * 7), (unsigned long long)(i % 97));
                }
                macro += (uint64_t)fprintf(file, "    X(end, end, 0)\n");
                const uint64_t shorts = 1 + generate_random(&random) % 6;
                for (uint64_t s = 0; s < shorts; s += 1)
                {
                    macro += (uint64_t)fprintf(file, "int x%llu_%llu;\n", (unsigned long long)item, (unsigned long long)s);
                }
                written += macro;
            }
            item += 1;
        }
        status = fclose(file) == 0 ? 0 : 1;
    }
    else
    {
        fprintf(stderr, "usage: generate451 long-lines|spliced PATH BYTES SEED\n");
    }
    return status;
}
