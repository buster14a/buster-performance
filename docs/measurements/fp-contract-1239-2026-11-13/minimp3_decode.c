// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See the repository LICENSE.
// Original adapter; minimp3 itself remains an external, pinned runtime input.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#define MINIMP3_IMPLEMENTATION
#ifdef FP_PCM_FLOAT
#define MINIMP3_FLOAT_OUTPUT
#endif
#include "minimp3/minimp3_ex.h"

int main(int argc, char** argv)
{
    int result = 1;
    if (argc == 2)
    {
        mp3dec_t decoder;
        mp3dec_file_info_t info;
        if (mp3dec_load(&decoder, argv[1], &info, NULL, NULL) == 0)
        {
            const uint64_t metadata[3] = { (uint64_t)info.hz, (uint64_t)info.channels, info.samples };
            result = fwrite(metadata, sizeof(metadata), 1, stdout) != 1 || fwrite(info.buffer, sizeof(*info.buffer), info.samples, stdout) != info.samples;
            free(info.buffer);
        }
    }
    return result;
}
