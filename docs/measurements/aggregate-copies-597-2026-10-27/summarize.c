// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader of #597's retained raw logs; no timings are invented or imputed.
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const unsigned sizes[] = { 16, 32, 64, 128, 255, 256, 257, 512, 1024, 4096, 8192, 16384, 65536, 262144 };
static const char* const modes[] = { "copy", "kept", "same" };
static const char* const versions[] = { "base", "head", "forced" };
typedef struct Samples Samples;
struct Samples
{
    double values[64];
    double rss[64];
    unsigned count;
    unsigned failures;
};
static Samples compile[14][3][2];
static Samples runtime[14][3][3];

static int order(const void* a, const void* b)
{
    const double x = *(const double*)a;
    const double y = *(const double*)b;
    return (x > y) - (x < y);
}

static double median(double* values, unsigned count)
{
    qsort(values, count, sizeof(double), order);
    return count == 0 ? 0 : count % 2 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) * 0.5;
}

int main(void)
{
    for (unsigned pass = 0; pass < 3; pass += 1)
    {
        char path[128];
        char line[1024];
        snprintf(path, sizeof(path), "logs/compile-%u.csv", pass);
        FILE* file = fopen(path, "r");
        while (file != NULL && fgets(line, sizeof(line), file) != NULL)
        {
            unsigned p, n, sample, status;
            char mode[16], version[16];
            unsigned long long wall, user, system, rss, faults;
            if (sscanf(line, "%u,%u,%15[^,],%15[^,],%u,%u,%llu,%llu,%llu,%llu,%llu", &p, &n, mode, version, &sample, &status,
                       &wall, &user, &system, &rss, &faults) == 11)
            {
                for (unsigned s = 0; s < 14; s += 1)
                {
                    for (unsigned m = 0; m < 3; m += 1)
                    {
                        for (unsigned v = 0; v < 2; v += 1)
                        {
                            if (sizes[s] == n && strcmp(modes[m], mode) == 0 && strcmp(versions[v], version) == 0)
                            {
                                Samples* rows = &compile[s][m][v];
                                rows->failures += status != 0;
                                if (status == 0 && rows->count < 64)
                                {
                                    rows->values[rows->count] = (double)wall / 1e6;
                                    rows->rss[rows->count++] = (double)rss;
                                }
                            }
                        }
                    }
                }
            }
        }
        if (file != NULL) fclose(file);
    }
    puts("compile_summary,size,mode,version,successes,failures,median_ms,min_ms,max_ms,median_peak_kb");
    for (unsigned s = 0; s < 14; s += 1)
    {
        for (unsigned m = 0; m < 3; m += 1)
        {
            for (unsigned v = 0; v < 2; v += 1)
            {
                Samples* rows = &compile[s][m][v];
                const double wall = median(rows->values, rows->count);
                const double rss = median(rows->rss, rows->count);
                printf("compile,%u,%s,%s,%u,%u,%.6f,%.6f,%.6f,%.0f\n", sizes[s], modes[m], versions[v], rows->count, rows->failures, wall,
                       rows->count ? rows->values[0] : 0, rows->count ? rows->values[rows->count - 1] : 0, rss);
                for (unsigned pass = 0; pass < 3; pass += 1)
                {
                    char path[128], line[512];
                    snprintf(path, sizeof(path), "logs/runtime-%s-%u-%u.log", versions[v], sizes[s], pass);
                    FILE* file = fopen(path, "r");
                    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
                    {
                        unsigned n, mode, sample;
                        unsigned long long iterations;
                        double ns;
                        if (sscanf(line, "runtime size=%u mode=%u sample=%u iterations=%llu ns_per_call=%lf", &n, &mode, &sample, &iterations, &ns) == 5 && mode == m)
                        {
                            Samples* measured = &runtime[s][v][m];
                            if (measured->count < 64) measured->values[measured->count++] = ns;
                        }
                    }
                    if (file != NULL) fclose(file);
                }
            }
        }
        for (unsigned pass = 0; pass < 3; pass += 1)
        {
            char path[128], line[512];
            snprintf(path, sizeof(path), "logs/runtime-forced-%u-%u.log", sizes[s], pass);
            FILE* file = fopen(path, "r");
            while (file != NULL && fgets(line, sizeof(line), file) != NULL)
            {
                unsigned n, mode, sample;
                unsigned long long iterations;
                double ns;
                if (sscanf(line, "runtime size=%u mode=%u sample=%u iterations=%llu ns_per_call=%lf", &n, &mode, &sample, &iterations, &ns) == 5)
                {
                    Samples* measured = &runtime[s][2][mode];
                    if (measured->count < 64) measured->values[measured->count++] = ns;
                }
            }
            if (file != NULL) fclose(file);
        }
    }
    puts("runtime_summary,size,mode,version,samples,median_ns,min_ns,max_ns");
    for (unsigned s = 0; s < 14; s += 1)
    {
        for (unsigned m = 0; m < 3; m += 1)
        {
            for (unsigned v = 0; v < 3; v += 1)
            {
                Samples* rows = &runtime[s][v][m];
                const double ns = median(rows->values, rows->count);
                if (rows->count) printf("runtime,%u,%s,%s,%u,%.3f,%.3f,%.3f\n", sizes[s], modes[m], versions[v], rows->count, ns, rows->values[0], rows->values[rows->count - 1]);
            }
        }
    }
    return 0;
}
