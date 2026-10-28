// Original #653 byte oracle: compare every measured object and compiler diagnostic with a baseline observation.
#define _GNU_SOURCE
#include <errno.h>
#include <glob.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define ROOT "qualification-653-lazy-83cfe3b4"

typedef struct Dataset Dataset;
struct Dataset
{
    const char* name;
    unsigned ab;
    unsigned aa;
};

static bool same_file(const char* reference, const char* path, FILE* manifest)
{
    FILE* a = fopen(reference, "rb");
    FILE* b = fopen(path, "rb");
    bool result = a != 0 && b != 0;
    uint64_t bytes = 0;
    bool done = false;
    unsigned char left[65536];
    unsigned char right[65536];
    while (result && !done)
    {
        const size_t n = fread(left, 1, sizeof(left), a);
        const size_t m = fread(right, 1, sizeof(right), b);
        result = n == m && memcmp(left, right, n) == 0;
        bytes += n;
        done = n == 0 || m == 0;
    }
    result = result && ferror(a) == 0 && ferror(b) == 0;
    if (a != 0)
    {
        result = fclose(a) == 0 && result;
    }
    if (b != 0)
    {
        result = fclose(b) == 0 && result;
    }
    fprintf(manifest, "%s\t%llu\t%u\n", path, (unsigned long long)bytes, result);
    if (!result)
    {
        fprintf(stderr, "byte oracle differs or cannot read: %s versus %s\n", reference, path);
    }
    return result;
}

int main(void)
{
    static const Dataset datasets[] = {
        { "deflate", 2016, 1056 },
        { "uncompr", 2016, 1056 },
        { "tiny", 1408, 1408 },
        { "local", 1408, 1408 },
        { "positive", 704, 704 },
        { "sqlite", 88, 88 },
        { "deflate-live", 2016, 1056 },
        { "uncompr-live", 2016, 1056 },
    };
    FILE* manifest = fopen(ROOT "/byte-manifest.tsv", "w");
    bool result = manifest != 0;
    if (manifest != 0)
    {
        fprintf(manifest, "path\tbytes\tidentical\n");
    }
    unsigned total = 0;
    for (unsigned d = 0; result && d < sizeof(datasets) / sizeof(datasets[0]); d += 1)
    {
        const Dataset* dataset = &datasets[d];
        char reference[1024];
        char diagnostic[1024];
        snprintf(reference, sizeof(reference), ROOT "/results/653-%s-ab/samples/r000-role0/output-0000.o", dataset->name);
        snprintf(diagnostic, sizeof(diagnostic), ROOT "/results/653-%s-ab/samples/r000-role0/stderr-0000.txt", dataset->name);
        for (unsigned mode = 0; result && mode < 2; mode += 1)
        {
            for (unsigned kind = 0; result && kind < 2; kind += 1)
            {
                char pattern[1024];
                snprintf(pattern, sizeof(pattern), ROOT "/results/653-%s-%s/samples/r*-role*/%s", dataset->name, mode == 0 ? "ab" : "aa",
                         kind == 0 ? "output-*.o" : "stderr-*.txt");
                glob_t paths = { 0 };
                const int found = glob(pattern, 0, 0, &paths);
                const unsigned expected = mode == 0 ? dataset->ab : dataset->aa;
                result = found == 0 && paths.gl_pathc == expected;
                if (!result)
                {
                    fprintf(stderr, "byte oracle missing observations for %s: got %zu, expected %u\n", pattern, paths.gl_pathc, expected);
                }
                for (size_t p = 0; result && p < paths.gl_pathc; p += 1)
                {
                    result = same_file(kind == 0 ? reference : diagnostic, paths.gl_pathv[p], manifest);
                    total += 1;
                }
                globfree(&paths);
            }
        }
        printf("byte oracle %s: %s (%u A/B + %u A/A objects and their diagnostics)\n", dataset->name, result ? "identical" : "FAILED", dataset->ab, dataset->aa);
        if (d < 6)
        {
            for (unsigned role = 0; result && role < 2; role += 1)
            {
                char path[1024];
                snprintf(path, sizeof(path), ROOT "/results/653-%s-syscalls-%u/output.o", dataset->name, role);
                result = same_file(reference, path, manifest);
                total += 1;
            }
        }
        if (d == 0 || d == 1 || d == 5)
        {
            for (unsigned role = 0; result && role < 2; role += 1)
            {
                char path[1024];
                snprintf(path, sizeof(path), ROOT "/all-syscalls/%s-%s.o", dataset->name, role == 0 ? "base" : "head");
                result = same_file(reference, path, manifest);
                total += 1;
            }
        }
    }
    if (manifest != 0)
    {
        result = fclose(manifest) == 0 && result;
    }
    printf("byte oracle total: %u files, %s\n", total, result ? "passed" : "FAILED");
    return result ? 0 : 1;
}
