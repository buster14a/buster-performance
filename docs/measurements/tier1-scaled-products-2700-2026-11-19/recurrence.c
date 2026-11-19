// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#include <stdint.h>

#if SCALE == 2
typedef uint32_t Word;
#else
typedef uint64_t Word;
#endif

Word kernel(Word x, Word y, uint32_t count)
{
    for (uint32_t i = 0; i < count; ++i)
    {
        x = y + x * SCALE;
        y ^= x >> 7;
    }
    return x ^ y;
}
