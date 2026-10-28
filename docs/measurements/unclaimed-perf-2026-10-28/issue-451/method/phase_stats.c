// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original reader of seven alternating benchmark-preprocessor process pairs.
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static double median(double* values)
{
    for (unsigned i = 1; i < 7; i += 1)
    {
        const double value = values[i];
        unsigned at = i;
        while (at != 0 && values[at - 1] > value)
        {
            values[at] = values[at - 1];
            at -= 1;
        }
        values[at] = value;
    }
    return values[3];
}

int main(int argc, char** argv)
{
    FILE* file = argc == 3 ? fopen(argv[1], "r") : NULL;
    int result = file == NULL;
    unsigned role = 2;
    unsigned round = 0;
    bool totals[2][7] = { 0 };
    bool phases[2][7] = { 0 };
    double samples[2][7][7] = { 0 };
    unsigned long expected_input = 0;
    unsigned long expected_output = 0;
    char line[8192];
    while (file != NULL && fgets(line, sizeof(line), file) != NULL)
    {
        if (sscanf(line, "== round %u tree", &round) == 1)
        {
            role = strstr(line, argv[2]) != NULL ? 1 : 0;
            result |= round < 1 || round > 7;
        }
        else if (strstr(line, "input tokens,") != NULL)
        {
            unsigned files = 0;
            unsigned long input = 0;
            unsigned long output = 0;
            const bool parsed = sscanf(line, "%u files, %lu input tokens, %lu output tokens;", &files, &input, &output) == 3;
            if (expected_input == 0)
            {
                expected_input = input;
                expected_output = output;
            }
            result |= !parsed || files != 1 || input != expected_input || output != expected_output;
        }
        else if (role < 2 && round >= 1 && round <= 7)
        {
            double value = 0;
            if (sscanf(line, " vectorized %lf ms", &value) == 1)
            {
                result |= totals[role][round - 1] || !isfinite(value) || value <= 0;
                samples[role][0][round - 1] = value;
                totals[role][round - 1] = true;
            }
            double read = 0, lex = 0, refine = 0, directives = 0, main_loop = 0;
            if (sscanf(line, " read %lf ms lex %lf ms refine %lf ms directives %lf ms main loop/setup %lf ms", &read, &lex, &refine, &directives, &main_loop) == 5)
            {
                result |= phases[role][round - 1];
                const double values[5] = { read, lex, refine, directives, main_loop };
                for (unsigned p = 0; p < 5; p += 1)
                {
                    result |= !isfinite(values[p]) || values[p] < 0;
                    samples[role][p + 1][round - 1] = values[p];
                }
                phases[role][round - 1] = true;
            }
            if (sscanf(line, " then the release %lf ms", &value) == 1)
            {
                result |= !isfinite(value) || value < 0;
                samples[role][6][round - 1] = value;
            }
        }
    }
    if (file != NULL)
    {
        fclose(file);
    }
    for (unsigned r = 0; r < 2; r += 1)
    {
        for (unsigned pass = 0; pass < 7; pass += 1)
        {
            result |= !totals[r][pass] || !phases[r][pass];
        }
    }
    const char* names[7] = { "preprocessing", "read", "lex", "refine", "directives", "main_loop_setup", "release" };
    printf("pairs=7 input_tokens=%lu output_tokens=%lu result=%d\n", expected_input, expected_output, result);
    for (unsigned phase = 0; result == 0 && phase < 7; phase += 1)
    {
        const double base = median(samples[0][phase]);
        const double head = median(samples[1][phase]);
        printf("%s base_ms=%.6f other_ms=%.6f time_change=%+.4f%%\n", names[phase], base, head, 100.0 * (head / base - 1.0));
    }
    return result;
}
