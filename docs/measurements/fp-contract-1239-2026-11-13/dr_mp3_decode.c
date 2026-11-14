// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See the repository LICENSE.
// Original adapter; dr_mp3 itself remains an external, pinned runtime input.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#define DR_MP3_IMPLEMENTATION
#include "dr_libs/dr_mp3.h"

int main(int argc, char** argv)
{
    int result = 1;
    if (argc == 2)
    {
        drmp3_config config;
        drmp3_uint64 frames = 0;
#ifdef FP_PCM_FLOAT
        float* samples = drmp3_open_file_and_read_pcm_frames_f32(argv[1], &config, &frames, NULL);
#else
        drmp3_int16* samples = drmp3_open_file_and_read_pcm_frames_s16(argv[1], &config, &frames, NULL);
#endif
        if (samples != NULL)
        {
            const uint64_t metadata[3] = { config.sampleRate, config.channels, frames * config.channels };
            const size_t count = (size_t)metadata[2];
            result = fwrite(metadata, sizeof(metadata), 1, stdout) != 1 || fwrite(samples, sizeof(*samples), count, stdout) != count;
            drmp3_free(samples, NULL);
        }
    }
    return result;
}
