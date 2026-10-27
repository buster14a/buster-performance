// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original strict reader for three process medians per build/state. Run with the twelve hybrid-kernel-*.log files.
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

typedef struct KernelSample KernelSample;
struct KernelSample
{
    double ns;
    double cycles;
    double instructions;
    double misses;
    double throttle;
};

static double median3(double a, double b, double c)
{
    return a < b ? (b < c ? b : a < c ? c : a) : (a < c ? a : b < c ? c : b);
}

int main(int argc, char** argv)
{
    static KernelSample samples[2][2][6][3];
    static bool seen[2][2][6][3];
    bool valid = argc == 13;
    unsigned total = 0;
    for (int file = 1; valid && file < argc; file += 1)
    {
        const char* name = strrchr(argv[file], '/');
        name = name != NULL ? name + 1 : argv[file];
        const bool head = strstr(name, "hybrid-kernel-hybrid-") == name;
        const bool base = strstr(name, "hybrid-kernel-base-") == name;
        const bool after = strstr(name, "after-scalar-") != NULL;
        const char* suffix = strrchr(name, '-');
        const unsigned run = suffix != NULL ? (unsigned)strtoul(suffix + 1, NULL, 10) : 0;
        FILE* input = fopen(argv[file], "r");
        valid = (base || head) && run >= 1 && run <= 3 && input != NULL;
        char line[4096];
        unsigned width = 0;
        unsigned rows = 0;
        while (input != NULL && fgets(line, sizeof(line), input) != NULL)
        {
            unsigned next = 0;
            if (sscanf(line, "classify-all, %u-byte vectors:", &next) == 1)
            {
                width = next;
            }
            char label[32];
            KernelSample sample = { 0 };
            double ipc = 0;
            const int fields = sscanf(line, " %31s vector %lf ns/type %lf cycles/type %lf instructions/type %lf IPC %lf mispredicts/type %lf throttle/type",
                                      label, &sample.ns, &sample.cycles, &sample.instructions, &ipc, &sample.misses, &sample.throttle);
            if (fields == 7)
            {
                const unsigned bucket = strcmp(label, "classify-all") == 0 ? (width == 16 ? 0 : width == 32 ? 1 : width == 64 ? 2 : 6) :
                                        strcmp(label, "batches-1") == 0 ? 3 : strcmp(label, "batches-4") == 0 ? 4 : strcmp(label, "batches-16") == 0 ? 5 : 6;
                valid = valid && bucket < 6;
                if (valid)
                {
                    valid = !seen[head][after][bucket][run - 1];
                    seen[head][after][bucket][run - 1] = true;
                    samples[head][after][bucket][run - 1] = sample;
                    rows += 1;
                    total += 1;
                }
            }
        }
        valid = valid && rows == 6;
        if (input != NULL)
        {
            valid = !ferror(input) && valid;
            fclose(input);
        }
    }
    valid = valid && total == 72;
    if (valid)
    {
        puts("build,state,kernel,processes,median_ns,min_ns,max_ns,instructions,cycles,mispredicts,throttle");
        const char* names[] = { "classify16", "classify32", "classify64", "batches1", "batches4", "batches16" };
        for (unsigned head = 0; head < 2; head += 1)
        {
            for (unsigned after = 0; after < 2; after += 1)
            {
                for (unsigned bucket = 0; bucket < 6; bucket += 1)
                {
                    const KernelSample a = samples[head][after][bucket][0];
                    const KernelSample b = samples[head][after][bucket][1];
                    const KernelSample c = samples[head][after][bucket][2];
                    const double minimum = a.ns < b.ns ? (a.ns < c.ns ? a.ns : c.ns) : b.ns < c.ns ? b.ns : c.ns;
                    const double maximum = a.ns > b.ns ? (a.ns > c.ns ? a.ns : c.ns) : b.ns > c.ns ? b.ns : c.ns;
                    printf("%s,%s,%s,3,%.2f,%.2f,%.2f,%.2f,%.2f,%.3f,%.3f\n", head ? "head" : "base", after ? "after-scalar" : "sustained", names[bucket],
                           median3(a.ns, b.ns, c.ns), minimum, maximum, median3(a.instructions, b.instructions, c.instructions),
                           median3(a.cycles, b.cycles, c.cycles), median3(a.misses, b.misses, c.misses), median3(a.throttle, b.throttle, c.throttle));
                }
            }
        }
    }
    else
    {
        fprintf(stderr, "kernel summary: invalid, duplicate or missing samples (%u rows)\n", total);
    }
    return valid ? 0 : 1;
}
