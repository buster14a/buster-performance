// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// convert.c MODE: the throughput of int32 -> float conversions on one core, eight independent ones per iteration,
// 2^27 iterations; `perf stat -e cycles:u` over the run gives cycles per conversion (cycles / 2^30). MODE 0: Tier 1's
// form, `xorps; cvtsi2ss r32` (the source in a general register); 1: `xorps; cvtsi2ss m32` (from memory); 2: clang's
// `vcvtsi2ss m32, xmm15, xmm` (memory, VEX, merging into a register never written); 3: `vcvtsi2ss r32, xmm15, xmm`.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define CONVERT_ITERATIONS (UINT64_C(1) << 27)

#define CONVERT_EIGHT(form) form(1) form(2) form(3) form(4) form(5) form(6) form(7) form(8)
#define CONVERT_REGISTER(n) "xorps %%xmm" #n ", %%xmm" #n "\n\tcvtsi2ss %k[value], %%xmm" #n "\n\t"
#define CONVERT_MEMORY(n) "xorps %%xmm" #n ", %%xmm" #n "\n\tcvtsi2ssl %[memory], %%xmm" #n "\n\t"
#define CONVERT_VEX_MEMORY(n) "vcvtsi2ssl %[memory], %%xmm15, %%xmm" #n "\n\t"
#define CONVERT_VEX_REGISTER(n) "vcvtsi2ss %k[value], %%xmm15, %%xmm" #n "\n\t"
#define CONVERT_CLOBBERS "xmm1", "xmm2", "xmm3", "xmm4", "xmm5", "xmm6", "xmm7", "xmm8", "xmm15"

int main(int argc, char** argv)
{
    const int mode = argc > 1 ? atoi(argv[1]) : 0;
    volatile int32_t source = 12345;
    int32_t value = source;
    int result = 0;
    for (uint64_t i = 0; i < CONVERT_ITERATIONS; i += 1)
    {
        if (mode == 0)
        {
            __asm__ volatile(CONVERT_EIGHT(CONVERT_REGISTER) : : [value] "r"(value) : CONVERT_CLOBBERS);
        }
        else if (mode == 1)
        {
            __asm__ volatile(CONVERT_EIGHT(CONVERT_MEMORY) : : [memory] "m"(source) : CONVERT_CLOBBERS);
        }
        else if (mode == 2)
        {
            __asm__ volatile(CONVERT_EIGHT(CONVERT_VEX_MEMORY) : : [memory] "m"(source) : CONVERT_CLOBBERS);
        }
        else
        {
            __asm__ volatile(CONVERT_EIGHT(CONVERT_VEX_REGISTER) : : [value] "r"(value) : CONVERT_CLOBBERS);
        }
    }
    printf("mode %d: %llu conversions\n", mode, (unsigned long long)(CONVERT_ITERATIONS * 8));
    return result;
}
