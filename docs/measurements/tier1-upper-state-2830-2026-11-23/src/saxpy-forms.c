// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// saxpy.c MODE REPS: y[i] += k * x[i] over 2048 floats, REPS times, by one of seven loop bodies, each loop 64-byte
// aligned; `perf stat -e cycles:u` over the run gives cycles per element (cycles / (REPS * 2048)). Every mode but 6
// starts with `vzeroupper`, as a call into a kernel from clang's code does. MODE 0: Tier 1 +unroll's body at znver5
// (`movss y; movss x; vfmadd231ss; movss` store: legacy moves, eight copies); 1: the same with VEX moves; 2: VEX, the x
// load first; 3: clang's (`vmovss x; vfmadd213ss y-in-memory; vmovss` store); 4: Tier 1's base loop (legacy, one
// element per iteration); 5: VEX, y loaded first as Tier 1 does, with the x load folded into `vfmadd231ss`; 6: mode 0
// after an instruction that
// leaves the upper state dirty (`vpternlogd` on zmm9) and no `vzeroupper`. The first run of this program had no
// `vzeroupper` at all: modes 0, 2 and 4 (legacy moves) then ran 6.0 cycles per element after main's AVX-512 code.
// The arrays are allocated as #2743's harness allocates its own.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define SAXPY_N 2048

#define SAXPY_TIER1(o) "movss " #o "(%[y],%[i],4), %%xmm1\n\tmovss " #o "(%[x],%[i],4), %%xmm2\n\tvfmadd231ss %%xmm2, %[k], %%xmm1\n\tmovss %%xmm1, " #o "(%[y],%[i],4)\n\t"
#define SAXPY_VEX(o) "vmovss " #o "(%[y],%[i],4), %%xmm1\n\tvmovss " #o "(%[x],%[i],4), %%xmm2\n\tvfmadd231ss %%xmm2, %[k], %%xmm1\n\tvmovss %%xmm1, " #o "(%[y],%[i],4)\n\t"
#define SAXPY_VEX_SWAPPED(o) "vmovss " #o "(%[x],%[i],4), %%xmm2\n\tvmovss " #o "(%[y],%[i],4), %%xmm1\n\tvfmadd231ss %%xmm2, %[k], %%xmm1\n\tvmovss %%xmm1, " #o "(%[y],%[i],4)\n\t"
#define SAXPY_VEX_FOLD_X(o) "vmovss " #o "(%[y],%[i],4), %%xmm1\n\tvfmadd231ss " #o "(%[x],%[i],4), %[k], %%xmm1\n\tvmovss %%xmm1, " #o "(%[y],%[i],4)\n\t"
#define SAXPY_CLANG(o) "vmovss " #o "(%[x],%[i],4), %%xmm1\n\tvfmadd213ss " #o "(%[y],%[i],4), %[k], %%xmm1\n\tvmovss %%xmm1, " #o "(%[y],%[i],4)\n\t"
#define SAXPY_EIGHT(body) body(0) body(4) body(8) body(12) body(16) body(20) body(24) body(28)
#define SAXPY_LOOP_FROM(start, body) \
    __asm__ volatile(start "xor %k[i], %k[i]\n\t.p2align 6\n1:\n\t" SAXPY_EIGHT(body) "add $8, %[i]\n\tcmp %[n], %[i]\n\tjb 1b" \
                     : [i] "=&r"(i) \
                     : [y] "r"(y), [x] "r"(x), [n] "r"((uint64_t)SAXPY_N), [k] "x"(k) \
                     : "xmm1", "xmm2", "xmm9", "memory", "cc")
#define SAXPY_LOOP(body) SAXPY_LOOP_FROM("vzeroupper\n\t", body)

static void saxpy(int mode, float* y, const float* x, float k)
{
    uint64_t i = 0;
    if (mode == 0)
    {
        SAXPY_LOOP(SAXPY_TIER1);
    }
    else if (mode == 1)
    {
        SAXPY_LOOP(SAXPY_VEX);
    }
    else if (mode == 2)
    {
        SAXPY_LOOP(SAXPY_VEX_SWAPPED);
    }
    else if (mode == 3)
    {
        SAXPY_LOOP(SAXPY_CLANG);
    }
    else if (mode == 5)
    {
        SAXPY_LOOP(SAXPY_VEX_FOLD_X);
    }
    else if (mode == 6)
    {
        SAXPY_LOOP_FROM("vpternlogd $0xff, %%zmm9, %%zmm9, %%zmm9\n\t", SAXPY_TIER1);
    }
    else
    {
        __asm__ volatile("vzeroupper\n\txor %k[i], %k[i]\n\t.p2align 6\n1:\n\t" SAXPY_TIER1(0) "add $1, %[i]\n\tcmp %[n], %[i]\n\tjb 1b"
                         : [i] "=&r"(i)
                         : [y] "r"(y), [x] "r"(x), [n] "r"((uint64_t)SAXPY_N), [k] "x"(k)
                         : "xmm1", "xmm2", "memory", "cc");
    }
}

int main(int argc, char** argv)
{
    const int mode = argc > 1 ? atoi(argv[1]) : 0;
    const uint64_t reps = argc > 2 ? strtoull(argv[2], NULL, 0) : 100000;
    float* y = aligned_alloc(64, SAXPY_N * sizeof(float));
    float* x = aligned_alloc(64, SAXPY_N * sizeof(float));
    int result = 1;
    if (y != NULL && x != NULL)
    {
        for (uint32_t i = 0; i < SAXPY_N; i += 1)
        {
            y[i] = (float)(i & 7);
            x[i] = (float)(i & 3) * 0.25f;
        }
        for (uint64_t r = 0; r < reps; r += 1)
        {
            saxpy(mode, y, x, 0x1p-20f);
        }
        printf("mode %d: %llu elements, y[5] %g, y - x %lld\n", mode, (unsigned long long)(reps * SAXPY_N), (double)y[5], (long long)((char*)y - (char*)x));
        result = 0;
    }
    free(y);
    free(x);
    return result;
}
