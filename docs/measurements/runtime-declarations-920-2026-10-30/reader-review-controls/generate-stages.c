// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original parser-only stage grid, no compiler execution or measured data.
#include <stdio.h>
int main(int argc, char** argv)
{
    int valid = argc == 2;
    const char* labels[] = { "base", "candidate", "base-again" };
    const char* metrics[] = { "preprocess", "check-input", "check-program", "backend-setup", "lower", "total" };
    for (unsigned run = 0; valid && run <= 10; run += 1)
    {
        for (unsigned slot = 0; valid && slot < 3; slot += 1)
        {
            const unsigned b = (slot + run) % 3;
            char path[4096];
            valid = snprintf(path, sizeof(path), "%s/stages/run-%u-%u-%s.stderr", argv[1], run, slot, labels[b]) < (int)sizeof(path);
            FILE* out = valid ? fopen(path, "w") : NULL;
            valid = valid && out != NULL;
            for (unsigned m = 0; valid && m < 6; m += 1)
            {
                const double value = (m == 5 ? 1000 : 100) + run + b * 10 + m;
                fprintf(out, "time-stage\t%s\t%.3f\t1.0\t0.000\t1\t1\n", metrics[m], value);
            }
            if (out != NULL)
            {
                fprintf(out, "time-process\tpeak-rss-kb\t%u\n", 10000 + run + b * 10);
                valid = fclose(out) == 0 && valid;
            }
        }
    }
    return valid ? 0 : 1;
}
