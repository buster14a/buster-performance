// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Compile with -I pointing to the compiler checkout, then run from that checkout.
#define main build_regression_main
#include "tools/ci/build_regression.c"
#undef main

int main(int argc, char** argv)
{
    if (argc != 2)
    {
        return 2;
    }
    Text sources = read_file(argv[1]);
    const OwnershipUnits units = ownership_units(sources);
    for (uint32_t i = 0; i < sizeof(ownership_exceptions) / sizeof(ownership_exceptions[0]); i += 1)
    {
        const OwnershipException* entry = ownership_exceptions + i;
        if (strcmp(entry->path, "src/buster/compiler/c_checker_test.c") != 0 &&
            strcmp(entry->path, "src/buster/compiler/c_preprocessor_test.c") != 0 &&
            strcmp(entry->path, "src/buster/compiler/test_paths.h") != 0)
        {
            continue;
        }
        uint64_t owners = 0;
        for (const char* name = entry->owners; *name != 0;)
        {
            const size_t length = strcspn(name, " ");
            for (uint32_t u = 0; u < units.count; u += 1)
            {
                if (strlen(units.names[u]) == length && strncmp(name, units.names[u], length) == 0)
                {
                    owners |= UINT64_C(1) << u;
                }
            }
            name += length;
            name += *name == ' ';
        }
        Text source = read_file(entry->path);
        OwnershipStructure result = ownership_structure(&units, owners, source.data);
        printf("%s valid=%u declarations=%u previous=%016llx current=%016llx\n", entry->path,
               result.valid, result.declarations, (unsigned long long)entry->structure, (unsigned long long)result.hash);
        free(source.data);
        if (!result.valid)
        {
            free(sources.data);
            return 1;
        }
    }
    free(sources.data);
    return 0;
}
