// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Frozen-source byte oracle: write every complete canonical/fixup template in all five modes. No gaps/padding.
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wunterminated-string-initialization"
#include "buster/compiler/x86_64_encoder.c"

static bool write_all(int fd, const uint8_t* data, size_t size)
{
    bool passed = true;
    size_t done = 0;
    while (passed && done < size)
    {
        const ssize_t count = write(fd, data + done, size - done);
        if (count > 0)
        {
            done += (size_t)count;
        }
        else if (count < 0 && errno == EINTR)
        {
            continue;
        }
        else
        {
            passed = false;
        }
    }
    return passed && done == size;
}

int main(int argc, char** argv)
{
    bool passed = argc == 2;
    int fd = passed ? open(argv[1], O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    passed &= fd >= 0;
    passed = passed && x86_encoder_initialize() && x86_encoder_initialize_address32() && x86_encoder_initialize_apx() && x86_encoder_initialize_legacy();
    const X86EncoderMode modes[] = { X86_ENCODER_MODE_64, X86_ENCODER_MODE_ADDRESS32, X86_ENCODER_MODE_APX, X86_ENCODER_MODE_32, X86_ENCODER_MODE_16 };
    for (uint32_t i = 0; passed && i < BUSTER_ARRAY_LENGTH(modes); i += 1)
    {
        const X86TemplateEntry* table = x86_mode_templates(modes[i]);
        const size_t bytes = BUSTER_X86_FORM_TEMPLATES * sizeof(*table);
        passed = write_all(fd, (const uint8_t*)table, bytes) && write_all(fd, (const uint8_t*)(table + BUSTER_X86_FORM_FIXUP), bytes);
    }
    if (fd >= 0)
    {
        passed &= close(fd) == 0;
    }
    printf("complete template dump: %s; %zu modes, %u entries/mode, %zu bytes/entry\n",
        passed ? "pass" : "FAIL", BUSTER_ARRAY_LENGTH(modes), 2 * BUSTER_X86_FORM_TEMPLATES, sizeof(X86TemplateEntry));
    return passed ? 0 : 1;
}
