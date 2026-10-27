// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original #606 fresh-process benchmark. Two warm-up rounds, then a balanced rotating four-command comparison.
#define main compile_run_main
#include "compile_run.c"
#undef main
#include <stdbool.h>
#include <string.h>
#include <sys/stat.h>

static bool files_equal(const char* a_path, const char* b_path)
{
    FILE* a = fopen(a_path, "rb");
    FILE* b = fopen(b_path, "rb");
    bool same = a != NULL && b != NULL;
    size_t count = 0;
    do
    {
        unsigned char a_bytes[4096];
        unsigned char b_bytes[4096];
        count = same ? fread(a_bytes, 1, sizeof(a_bytes), a) : 0;
        same = same && count == fread(b_bytes, 1, sizeof(b_bytes), b) && memcmp(a_bytes, b_bytes, count) == 0;
    } while (same && count != 0);
    same = same && !ferror(a) && !ferror(b);
    if (a != NULL) { fclose(a); }
    if (b != NULL) { fclose(b); }
    return same;
}

int main(int argc, char** argv)
{
    int result = argc == 4 ? 0 : 2;
    if (result == 0)
    {
        const char* name = argv[1];
        const int rounds = atoi(argv[2]);
        const bool stages = strcmp(argv[3], "yes") == 0;
        const bool sqlite = strcmp(name, "sqlite") == 0;
        const bool profile = getenv("BUSTER_606_COMPARE") != NULL;
        const char* directory = profile ? "profile-results" : "results";
        result = rounds < 1 || rounds > 100 || (!sqlite && strcmp(name, "lines") != 0 && strcmp(name, "small") != 0) ? 2 : 0;
        mkdir(directory, 0700);
        for (int round = -2; result == 0 && round < rounds; round += 1)
        {
            for (int index = 0; result == 0 && index < 4; index += 1)
            {
                const int choice = (index + round + 4) % 4;
                const char* version = choice < 2 ? "base" : "head";
                const char* mode = choice % 2 == 0 ? "c" : "g";
                char compiler[256];
                char input[256];
                char output[256];
                char errors[256];
                snprintf(compiler, sizeof(compiler), "./%s/build/compiler", profile ? "prof" : version);
                snprintf(input, sizeof(input), "inputs/%s.c", name);
                snprintf(output, sizeof(output), "%s/%s-%s-%s.o", directory, name, version, mode);
                snprintf(errors, sizeof(errors), "%s/%s-%s-%d-%s-%s.log", directory, name, argv[3], round, version, mode);
                if (profile)
                {
                    if (choice < 2) { setenv("BUSTER_606_OLD", "1", 1); }
                    else { unsetenv("BUSTER_606_OLD"); }
                }
                char* child[32] = { "compile_run", errors, compiler, "--lanes", "1", "-c" };
                int count = 6;
                if (choice % 2 != 0) { child[count++] = "-g"; }
                if (stages) { child[count++] = "--time-stages"; }
                if (sqlite)
                {
                    child[count++] = "-DSQLITE_OMIT_LOAD_EXTENSION";
                    child[count++] = "-DSQLITE_THREADSAFE=0";
                    child[count++] = "-DSQLITE_ENABLE_MEMSYS5";
                    child[count++] = "-DSQLITE_ENABLE_RTREE";
                }
                child[count++] = input;
                child[count++] = "-o";
                child[count++] = output;
                child[count] = NULL;
                printf("%s\t%s\t%d\t%s\t%s\t", name, argv[3], round, version, mode);
                result = compile_run_main(count, child);
            }
            for (int mode = 0; result == 0 && mode < 2; mode += 1)
            {
                char base[256];
                char head[256];
                snprintf(base, sizeof(base), "%s/%s-base-%s.o", directory, name, mode == 0 ? "c" : "g");
                snprintf(head, sizeof(head), "%s/%s-head-%s.o", directory, name, mode == 0 ? "c" : "g");
                result = files_equal(base, head) ? 0 : 3;
            }
        }
    }
    return result;
}
