// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#include <fenv.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#pragma STDC FENV_ACCESS ON

extern float i32f(const int32_t *);
extern double i32d(const int32_t *);
extern float i64f(const int64_t *);
extern double i64d(const int64_t *);
extern double scaled(const int64_t *, unsigned long);

static uint64_t digest = UINT64_C(14695981039346656037);

static void add(uint64_t bits)
{
    digest ^= bits;
    digest *= UINT64_C(1099511628211);
}

int main(void)
{
    const uint64_t limits[] = {0, 1, UINT64_MAX, INT32_MAX, (uint64_t)(int64_t)INT32_MIN,
        INT64_MAX, (uint64_t)INT64_MIN, (UINT64_C(1)<<24)+1, (UINT64_C(1)<<53)+1,
        UINT64_C(0xfffffffffeffffff), UINT64_C(0xffdfffffffffffff)};
    const int modes[] = {FE_TONEAREST, FE_DOWNWARD, FE_UPWARD, FE_TOWARDZERO};
    const size_t page = (size_t)sysconf(_SC_PAGESIZE);
    uint8_t *memory = mmap(NULL, 2 * page, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (memory == MAP_FAILED || mprotect(memory + page, page, PROT_NONE)) return 1;
    uint64_t random = UINT64_C(0x9e3779b97f4a7c15);
    for (unsigned int m = 0; m < 4; m++)
    {
        if (fesetround(modes[m])) return 2;
        for (unsigned int n = 0; n < 1035; n++)
        {
            random ^= random << 13;
            random ^= random >> 7;
            random ^= random << 17;
            uint64_t bits = n < sizeof(limits)/sizeof(limits[0]) ? limits[n] : random;
            for (unsigned int kind = 0; kind < 5; kind++)
            {
                size_t size = kind < 2 ? 4 : 8;
                void *last = memory + page - size;
                memcpy(last, &bits, size);
                feclearexcept(FE_ALL_EXCEPT);
                uint64_t result = 0;
                if (kind == 0 || kind == 2)
                {
                    float x = kind == 0 ? i32f(last) : i64f(last);
                    uint32_t raw;
                    memcpy(&raw, &x, sizeof(raw));
                    result = raw;
                }
                else
                {
                    double x = kind == 1 ? i32d(last) : kind == 3 ? i64d(last) : scaled((const int64_t *)last - 3, 2);
                    memcpy(&result, &x, sizeof(result));
                }
                add(result);
                add((unsigned int)fetestexcept(FE_ALL_EXCEPT));
            }
        }
    }
    printf("20700 results and exception sets %016" PRIx64 "\n", digest);
    return munmap(memory, 2*page) != 0;
}
