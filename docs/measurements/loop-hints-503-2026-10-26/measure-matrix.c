// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// One bounded default-driver benchmark run over three input sizes and both paths.
// Reuse the original one-case procedure, including its warmups, ordering and exit checks.
#define main measure_case_main
#include "measure.c"
#undef main

int main(int argc, char** argv)
{
    static const char* const names[] = { "tiny", "hints-1024", "sqlite" };
    static char* const modes[] = { "scalar", "vector" };
    bool valid = argc == 7;
    for (unsigned input = 0; valid && input < 3; input += 1)
    {
        for (unsigned mode = 0; valid && mode < 2; mode += 1)
        {
            char samples[4096];
            char summary[4096];
            const int a = snprintf(samples, sizeof(samples), "%s-%s-%s.csv", argv[6], names[input], modes[mode]);
            const int b = snprintf(summary, sizeof(summary), "%s-%s-%s.log", argv[6], names[input], modes[mode]);
            valid = a > 0 && (unsigned)a < sizeof(samples) && b > 0 && (unsigned)b < sizeof(summary);
            valid = valid && freopen(samples, "wb", stdout) != NULL && freopen(summary, "wb", stderr) != NULL;
            if (valid)
            {
                char* arguments[] = { "measure", argv[1], argv[2], argv[input + 3], modes[mode], NULL };
                valid = measure_case_main(5, arguments) == 0;
                valid = fflush(stdout) == 0 && fflush(stderr) == 0 && valid;
            }
        }
    }
    return valid ? 0 : 1;
}
