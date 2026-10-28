// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader for two alternating windows/whole benchmark-preprocessor pairs.
// Positional input order is windows1, whole1, whole2, windows2; every process must report one complete 21-pass result.
#define _GNU_SOURCE
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct Phase451 Phase451;
struct Phase451
{
    unsigned long long input_tokens;
    unsigned long long output_tokens;
    double values[8];
    unsigned seen;
};

static bool read_phase451(const char* path, Phase451* result)
{
    *result = (Phase451){ 0 };
    FILE* file = fopen(path, "r");
    bool valid = file != NULL;
    char* line = NULL;
    size_t capacity = 0;
    while (valid && getline(&line, &capacity, file) >= 0)
    {
        unsigned files = 0;
        unsigned passes = 0;
        unsigned long long input = 0;
        unsigned long long output = 0;
        if (sscanf(line, "%u files, %llu input tokens, %llu output tokens; %u passes, medians:", &files, &input, &output, &passes) == 4)
        {
            valid = (result->seen & 1) == 0 && files == 1 && passes == 21 && input != 0;
            result->input_tokens = input;
            result->output_tokens = output;
            result->seen |= 1;
        }
        double total = 0;
        if (sscanf(line, " vectorized %lf ms", &total) == 1)
        {
            valid = (result->seen & 2) == 0 && isfinite(total) && total > 0;
            result->values[0] = total;
            result->seen |= 2;
        }
        double read = 0;
        double lex = 0;
        double refine = 0;
        double directives = 0;
        double main_loop = 0;
        if (sscanf(line, " read %lf ms lex %lf ms refine %lf ms directives %lf ms main loop/setup %lf ms", &read, &lex, &refine, &directives, &main_loop) == 5)
        {
            valid = (result->seen & 4) == 0;
            const double values[] = { read, lex, refine, directives, main_loop };
            for (unsigned field = 0; field < 5; field += 1)
            {
                valid = valid && isfinite(values[field]) && values[field] >= 0;
                result->values[field + 1] = values[field];
            }
            result->seen |= 4;
        }
        double release = 0;
        if (sscanf(line, " then the release %lf ms", &release) == 1)
        {
            valid = (result->seen & 8) == 0 && isfinite(release) && release >= 0;
            result->values[6] = release;
            result->seen |= 8;
        }
        double inclusive = 0;
        double printing = 0;
        if (sscanf(line, " -E -P with printing %lf ms (printing %lf ms):", &inclusive, &printing) == 2)
        {
            valid = (result->seen & 16) == 0 && isfinite(inclusive) && inclusive >= 0 && isfinite(printing) && printing >= 0;
            result->values[7] = printing;
            result->seen |= 16;
        }
    }
    if (file != NULL)
    {
        valid = valid && ferror(file) == 0;
        valid = fclose(file) == 0 && valid;
    }
    free(line);
    return valid && result->seen == 31;
}

int main(int argc, char** argv)
{
    Phase451 samples[4] = { 0 };
    bool valid = argc == 5;
    for (unsigned sample = 0; valid && sample < 4; sample += 1)
    {
        valid = read_phase451(argv[sample + 1], &samples[sample]) &&
                (sample == 0 || (samples[sample].input_tokens == samples[0].input_tokens && samples[sample].output_tokens == samples[0].output_tokens));
    }
    if (valid)
    {
        static const char* const names[] = { "preprocessing", "read", "lex", "refine", "directives", "main_loop_setup", "release", "printing" };
        printf("phase451: 2 complete alternating pairs, 21 passes/process, input_tokens=%llu output_tokens=%llu\n", samples[0].input_tokens, samples[0].output_tokens);
        for (unsigned field = 0; field < 8; field += 1)
        {
            const double w1 = samples[0].values[field];
            const double w2 = samples[3].values[field];
            const double h1 = samples[1].values[field];
            const double h2 = samples[2].values[field];
            const double windows = (w1 + w2) * 0.5;
            const double whole = (h1 + h2) * 0.5;
            printf("%s windows_ms=%.6f range=[%.6f,%.6f] whole_ms=%.6f range=[%.6f,%.6f]", names[field],
                   windows, fmin(w1, w2), fmax(w1, w2), whole, fmin(h1, h2), fmax(h1, h2));
            if (whole > 0)
            {
                printf(" windows_vs_whole_pct=%+.6f\n", 100.0 * (windows / whole - 1.0));
            }
            else
            {
                printf(" windows_vs_whole_pct=unavailable\n");
            }
        }
    }
    else
    {
        fprintf(stderr, "phase451: invalid/incomplete or different-work inputs\n");
    }
    return !valid;
}
