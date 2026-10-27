// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original aggregator: medians and ranges of the per-process medians, keyed by workload and stage.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

typedef struct Case Case;
struct Case
{
    uint32_t shape;
    uint32_t n;
    uint32_t f;
    uint32_t after;
    char stage[8];
    double samples[2][16];
    uint32_t counts[2];
};

static double median(double* samples, uint32_t count)
{
    for (uint32_t i = 1; i < count; i += 1)
    {
        const double sample = samples[i];
        uint32_t j = i;
        while (j != 0 && samples[j - 1] > sample)
        {
            samples[j] = samples[j - 1];
            j -= 1;
        }
        samples[j] = sample;
    }
    const double result = count % 2 == 0 ? (samples[count / 2 - 1] + samples[count / 2]) / 2 : samples[count / 2];
    return result;
}

int main(int argc, char** argv)
{
    Case cases[256] = { 0 };
    uint32_t count = 0;
    bool valid = argc > 1;
    for (int file = 1; valid && file < argc; file += 1)
    {
        FILE* input = fopen(argv[file], "r");
        valid = input != 0;
        char line[1024];
        while (valid && fgets(line, sizeof(line), input) != 0)
        {
            uint32_t shape;
            uint32_t n;
            uint32_t f;
            uint32_t reps;
            uint32_t after;
            char stage[8];
            char variant[8];
            double value;
            double minimum;
            double maximum;
            unsigned long long base_bytes;
            unsigned long long head_bytes;
            if (sscanf(line, "%u,%u,%u,%7[^,],%7[^,],%u,%lf,%lf,%lf,%llu,%llu,%u", &shape, &n, &f, stage, variant, &reps, &value, &minimum, &maximum, &base_bytes, &head_bytes, &after) == 12)
            {
                uint32_t index = 0;
                while (index < count && (cases[index].shape != shape || cases[index].n != n || cases[index].f != f || cases[index].after != after || strcmp(cases[index].stage, stage) != 0))
                {
                    index += 1;
                }
                valid = index < 256;
                if (valid && index == count)
                {
                    cases[index].shape = shape;
                    cases[index].n = n;
                    cases[index].f = f;
                    cases[index].after = after;
                    strcpy(cases[index].stage, stage);
                    count += 1;
                }
                const uint32_t v = strcmp(variant, "base") == 0 ? 0 : 1;
                if (valid)
                {
                    valid = cases[index].counts[v] < 16;
                    if (valid)
                    {
                        cases[index].samples[v][cases[index].counts[v]] = value;
                        cases[index].counts[v] += 1;
                    }
                }
            }
        }
        if (input != 0)
        {
            fclose(input);
        }
    }
    puts("shape,N,F,stage,after_scalar_ms,processes,base_ns,head_ns,speedup,delta_percent,base_min,base_max,head_min,head_max");
    for (uint32_t i = 0; valid && i < count; i += 1)
    {
        Case* item = cases + i;
        valid = item->counts[0] != 0 && item->counts[0] == item->counts[1];
        if (valid)
        {
            const uint32_t length = item->counts[0];
            const double base = median(item->samples[0], length);
            const double head = median(item->samples[1], length);
            printf("%u,%u,%u,%s,%u,%u,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f\n", item->shape, item->n, item->f, item->stage, item->after, length, base, head, base / head, (head / base - 1) * 100, item->samples[0][0], item->samples[0][length - 1], item->samples[1][0], item->samples[1][length - 1]);
        }
    }
    return valid ? 0 : 1;
}
