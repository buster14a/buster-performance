// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// caller.c MODE REPS (clang -O2 -march=znver5): calls Tier 1's saxpy (kernel.c) over 2,048 floats REPS times. MODE 0
// clears the upper state before each call (vzeroupper), as clang's own code does; MODE 1 leaves it dirty (a vpternlogd
// on zmm9 and no vzeroupper), as code that returns from 512-bit code without vzeroupper does (buster#2830).
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define CALLER_N 2048

void saxpy(float* y, const float* x, float k, int n);

int main(int argc, char** argv)
{
    const int mode = argc > 1 ? atoi(argv[1]) : 0;
    const long reps = argc > 2 ? atol(argv[2]) : 100000;
    float* y = aligned_alloc(64, CALLER_N * sizeof(float));
    float* x = aligned_alloc(64, CALLER_N * sizeof(float));
    int result = 1;
    if (y != NULL && x != NULL)
    {
        for (int i = 0; i < CALLER_N; i += 1)
        {
            y[i] = (float)(i & 7);
            x[i] = (float)(i & 3) * 0.25f;
        }
        for (long r = 0; r < reps; r += 1)
        {
            if (mode == 0)
            {
                __asm__ volatile("vzeroupper" ::: "memory");
            }
            else
            {
                __asm__ volatile("vpternlogd $0xff, %%zmm9, %%zmm9, %%zmm9" ::: "xmm9", "memory");
            }
            saxpy(y, x, 0x1p-20f, CALLER_N);
        }
        printf("caller mode %d: %ld elements, y[5] %g\n", mode, reps * CALLER_N, (double)y[5]);
        result = 0;
    }
    free(y);
    free(x);
    return result;
}
