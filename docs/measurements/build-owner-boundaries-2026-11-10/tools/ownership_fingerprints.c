// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
// Read the gate's declared boundaries and report their source fingerprints, without changing expectations.
#define main regression_main
#include "build_regression.c"
#undef main
int main(void)
{
    if (getcwd(root, sizeof(root)) == 0)
    {
        fail("can't locate the source checkout");
    }
    snprintf(work, sizeof(work), "/tmp/buster-ownership-fingerprints-XXXXXX");
    if (mkdtemp(work) == 0)
    {
        fail("can't create a capture directory");
    }
    char* arguments[] = { "./build.sh", "print-sources", 0 };
    Text sources = capture(arguments);
    OwnershipUnits units = ownership_units(sources);
    static OwnershipGraph graph;
    OwnershipException active[128];
    puts("configuration\tpath\tdeclarations\tvalid\tactual\texpected\tresult");
    for (uint32_t fuzz = 0; fuzz < 2; fuzz += 1)
    {
        const uint32_t count = ownership_active_exceptions(&graph, fuzz != 0, active);
        for (uint32_t i = 0; i < count; i += 1)
        {
            if (ownership_fixture_name(active[i].path))
            {
                uint64_t owners = 0;
                for (uint32_t j = 0; j < units.count; j += 1)
                {
                    const char* name = active[i].owners;
                    while (*name != 0)
                    {
                        const size_t length = strcspn(name, " ");
                        if (strlen(units.names[j]) == length && strncmp(name, units.names[j], length) == 0)
                        {
                            owners |= UINT64_C(1) << j;
                        }
                        name += length + (name[length] == ' ');
                    }
                }
                Text source = read_file(active[i].path);
                OwnershipStructure structure = ownership_structure(&units, owners, source.data);
                printf("%s\t%s\t%u\t%u\t%016llx\t%016llx\t%s\n", fuzz ? "fuzz" : "ordinary", active[i].path,
                       structure.declarations, structure.valid, (unsigned long long)structure.hash,
                       (unsigned long long)active[i].structure, structure.hash == active[i].structure ? "same" : "review");
                free(source.data);
            }
        }
    }
    free(sources.data);
    char captured[PATH_MAX];
    snprintf(captured, sizeof(captured), "%s/captured", work);
    unlink(captured);
    rmdir(work);
    return 0;
}
