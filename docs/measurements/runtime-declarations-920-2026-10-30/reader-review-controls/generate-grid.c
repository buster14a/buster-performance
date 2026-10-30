// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original parser-only synthetic grid, no compiler execution or measured data.
#include <stdio.h>
int main(int argc, char** argv)
{
    int valid = argc == 2;
    const char* states[] = { "plain", "after-scalar" };
    const char* labels[] = { "base", "candidate", "base-again" };
    for (unsigned s = 0; valid && s < 2; s += 1)
    {
        for (unsigned r = 1; valid && r <= 3; r += 1)
        {
            char path[4096];
            valid = snprintf(path, sizeof(path), "%s/time-%s-%u.log", argv[1], states[s], r) < (int)sizeof(path);
            FILE* out = valid ? fopen(path, "w") : NULL;
            valid = valid && out != NULL;
            for (unsigned b = 0; valid && b < 3; b += 1)
            {
                for (unsigned run = 1; run <= 3; run += 1)
                {
                    for (unsigned p = 1; p <= 6; p += 1)
                    {
                        for (unsigned c = 1; c <= 3; c += 1)
                        {
                            fprintf(out, "run %u list 1 %s placement %u copy %u: 100.000 ms wall, 90.000 ms user, 2.000 ms system, 1000 KiB wait4 peak, 30 minor faults, 0 major, 10000 user cycles, 100000 instructions, status 0\n", run, labels[b], p, c);
                        }
                    }
                }
            }
            if (out != NULL)
            {
                valid = fclose(out) == 0 && valid;
            }
        }
    }
    return valid ? 0 : 1;
}
