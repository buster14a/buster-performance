// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Isolate name comparisons from type interning and source binding. The candidate helper is extracted verbatim
// with one counter increment; the reference is the removed all-pairs scan. IDs model consecutive interned names.
#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
typedef uint32_t TypeId;
static uint64_t visits;
#include "parameter-tree.inc"

int main(void)
{
    const uint32_t counts[] = { 256, 512, 1024, 2048, 4096 };
    bool valid = true;
    puts("parameters,kind,reference_visits,candidate_visits");
    for (uint32_t c = 0; valid && c < sizeof(counts) / sizeof(counts[0]); c += 1)
    {
        const uint32_t count = counts[c];
        CheckConstantParameter* parameters = calloc(count, sizeof(*parameters));
        valid = parameters != NULL;
        for (uint32_t named = 0; valid && named < 2; named += 1)
        {
            CheckConstantPart function = { 0 };
            uint64_t reference = 0;
            visits = 0;
            for (uint32_t i = 0; i < count; i += 1)
            {
                parameters[i] = (CheckConstantParameter){ .name = named ? i + 1024 : 0, .next = UINT32_MAX };
                if (i != 0)
                {
                    parameters[i - 1].next = i;
                }
                for (uint32_t previous = 0; named && previous < i; previous = parameters[previous].next)
                {
                    reference += 1;
                    valid &= parameters[previous].name != parameters[i].name;
                }
                valid &= check_constant_parameter_unique(&function, parameters, i);
            }
            printf("%u,%s,%" PRIu64 ",%" PRIu64 "\n", count, named ? "named" : "unnamed", reference, visits);
            valid &= visits <= (uint64_t)32 * count;
        }
        free(parameters);
    }
    return valid ? 0 : 1;
}
