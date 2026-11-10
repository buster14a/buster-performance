// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and README.md.

#define main original_regression_main
#include "tools/ci/build_regression.c"
#undef main
int main(int argc, char** argv)
{
    if (getcwd(root, sizeof(root)) == 0) { return 1; }
    if (realpath("..", work) == 0) { return 1; }
    strcat(work, "/graph-inventory-XXXXXX");
    if (mkdtemp(work) == 0) { return 1; }
    char* command[] = { "./build.sh", "print-sources", 0 };
    Text sources = capture(command);
    const OwnershipUnits units = ownership_units(sources);
    char objects[64][PATH_MAX];
    char* arguments[80] = { "ninja", "-C", "build/cmake/x86-64-g0", "-f", "build-Release.ninja", "-t", "deps" };
    for (uint32_t i = 0; i < units.count; i += 1)
    {
        snprintf(objects[i], sizeof(objects[i]), "CMakeFiles/buster_%.*s.dir/Release/src/buster/compiler/%s.o", (int)strlen(units.names[i]) - 2, units.names[i], units.names[i]);
        arguments[i + 7] = objects[i];
    }
    Text deps = argc == 2 ? read_file(argv[1]) : capture(arguments);
    static OwnershipGraph graph;
    ownership_report(&units, ownership_read(deps.data, root, "Release", &units, &graph));
    ownership_classify(&graph);
    OwnershipException active[128];
    const uint32_t count = ownership_active_exceptions(&graph, active);
    ownership_report(&units, ownership_check(&units, &graph, active, count));
    ownership_check_structure(&units, &graph);
    ownership_check_nonstandard(&units, &graph);
    uint32_t fixtures = 0;
    for (uint32_t i = 0; i < graph.count; i += 1) { fixtures += graph.files[i].fixture; }
    fprintf(stderr, "%u fixtures, %u exceptions, %u single-owner\n", fixtures, count, fixtures - count);
    for (uint32_t i = 0; i < graph.count; i += 1)
    {
        const OwnershipFile* file = &graph.files[i];
        const bool shared = (file->owners & (file->owners - 1)) != 0;
        if (file->fixture && getenv("OWNERSHIP_ALL") != 0)
        {
            char owners[4096];
            ownership_names(&units, file->owners, owners, sizeof(owners));
            const char* reason = "private to its command's unit";
            for (uint32_t j = 0; j < count; j += 1)
            {
                if (strcmp(file->path, active[j].path) == 0) { reason = active[j].reason; }
            }
            printf("%s\t%s\t%s\t%s\n", file->path, shared ? (ownership_fixture_name(file->path) ? "shared-root" : "shared-descendant") : "private", owners, reason);
        }
        else if (file->fixture && shared)
        {
            if (ownership_fixture_name(file->path))
            {
                Text source = read_file(file->path);
                const OwnershipStructure structure = ownership_structure(&units, file->owners, source.data);
                printf("%s\t%u\t%u\t%016llx\n", file->path, structure.valid, structure.declarations, (unsigned long long)structure.hash);
                free(source.data);
            }
        }
    }
    return 0;
}
