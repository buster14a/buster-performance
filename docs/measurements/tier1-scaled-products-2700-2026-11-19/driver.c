// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if SCALE == 2
typedef uint32_t Word;
#else
typedef uint64_t Word;
#endif

extern Word kernel(Word, Word, uint32_t);

int main(int argc, char** argv)
{
    uint32_t count = argc > 1 ? (uint32_t)strtoul(argv[1], 0, 10) : 0;
    const Word x = (Word)UINT64_C(0x31be747fda21789d);
    const Word y = (Word)UINT64_C(0xe23a7833bc43976b);
    printf("%016" PRIx64 "\n", (uint64_t)kernel(x, y, count));
    return 0;
}
