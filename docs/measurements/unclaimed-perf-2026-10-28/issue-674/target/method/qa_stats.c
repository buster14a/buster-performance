// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original paired-cohort reader. The inputs are the campaign helper's own JSON lines.
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ROUNDS 101

typedef struct Sample Sample;
struct Sample
{
    double rate;
    double user;
    double system;
    double rss;
    double major;
    double failures;
    bool present;
};

static double number(const char* line, const char* key)
{
    const char* found = strstr(line, key);
    return found != NULL ? strtod(found + strlen(key), NULL) : -1;
}

static void order(double* values, unsigned count)
{
    for (unsigned i = 1; i < count; i += 1)
    {
        const double value = values[i];
        unsigned j = i;
        while (j != 0 && values[j - 1] > value)
        {
            values[j] = values[j - 1];
            j -= 1;
        }
        values[j] = value;
    }
}

static double median(double* values, unsigned count)
{
    order(values, count);
    return count % 2 != 0 ? values[count / 2] : (values[count / 2 - 1] + values[count / 2]) * 0.5;
}

int main(int argc, char** argv)
{
    int result = argc < 2;
    for (int input = 1; result == 0 && input < argc; input += 1)
    {
        FILE* file = fopen(argv[input], "r");
        if (file == NULL)
        {
            perror(argv[input]);
            result = 1;
        }
        else
        {
            Sample samples[ROUNDS][2] = { 0 };
            char line[8192];
            unsigned round = ROUNDS;
            unsigned role = 2;
            unsigned read = 0;
            while (fgets(line, sizeof(line), file) != NULL)
            {
                unsigned found_round;
                unsigned found_role;
                if (sscanf(line, "sample round=%u role=%u", &found_round, &found_role) == 2)
                {
                    round = found_round;
                    role = found_role;
                }
                else if (line[0] == '{' && strstr(line, "\"MB_per_s\":") != NULL)
                {
                    if (round >= ROUNDS || role >= 2 || samples[round][role].present)
                    {
                        result = 1;
                    }
                    else
                    {
                        samples[round][role] = (Sample)
                        {
                            .rate = number(line, "\"MB_per_s\":"),
                            .user = number(line, "\"user_s\":"),
                            .system = number(line, "\"system_s\":"),
                            .rss = number(line, "\"maxrss_kb\":"),
                            .major = number(line, "\"major_faults\":"),
                            .failures = number(line, "\"failures\":"),
                            .present = true,
                        };
                        read += 1;
                    }
                }
            }
            fclose(file);
            double rates[2][ROUNDS] = { 0 };
            double gains[ROUNDS] = { 0 };
            double faults[2] = { 0 };
            double failures[2] = { 0 };
            double rss[2][ROUNDS] = { 0 };
            unsigned count = 0;
            unsigned positive = 0;
            for (unsigned r = 0; r < ROUNDS; r += 1)
            {
                if (samples[r][0].present && samples[r][1].present)
                {
                    for (unsigned p = 0; p < 2; p += 1)
                    {
                        rates[p][count] = samples[r][p].rate;
                        rss[p][count] = samples[r][p].rss;
                        faults[p] += samples[r][p].major;
                        failures[p] += samples[r][p].failures;
                        result |= samples[r][p].rate <= 0 || samples[r][p].failures != 0;
                    }
                    gains[count] = 100.0 * (samples[r][1].rate / samples[r][0].rate - 1.0);
                    positive += gains[count] > 0;
                    count += 1;
                }
            }
            result |= count == 0 || read != 2 * count;
            if (count != 0)
            {
                const double base = median(rates[0], count);
                const double head = median(rates[1], count);
                const double paired = median(gains, count);
                printf("%s: pairs=%u MB/s=%.6f->%.6f median_ratio_gain=%.4f%% paired_median_gain=%.4f%% pair_range=[%.4f%%,%.4f%%] positive=%u/%u major=%.0f/%.0f failures=%.0f/%.0f rss=%.0f/%.0f KiB\n",
                       argv[input], count, base, head, 100.0 * (head / base - 1.0), paired,
                       gains[0], gains[count - 1], positive, count, faults[0], faults[1], failures[0], failures[1],
                       median(rss[0], count), median(rss[1], count));
            }
        }
    }
    return result;
}
