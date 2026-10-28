// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Canonical payload serialization: template32 + layout16 + byte/flag16, independent of entry storage width.
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
_Static_assert(sizeof(X86Instruction) == 16, "instruction records retain their format");
_Static_assert(sizeof(X86Template) == 32, "complete canonical template payload");

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

static bool write_entries(int fd, const X86TemplateEntry* entries)
{
    uint8_t buffer[256 * 64];
    bool passed = true;
    for (uint32_t first = 0; passed && first < BUSTER_X86_FORM_TEMPLATES; first += 256)
    {
        const uint32_t count = BUSTER_X86_FORM_TEMPLATES - first < 256 ? BUSTER_X86_FORM_TEMPLATES - first : 256;
        for (uint32_t i = 0; i < count; i += 1)
        {
            const X86Template* entry = &entries[first + i].template;
            memcpy(buffer + i * 64, entry, 32);
            memcpy(buffer + i * 64 + 32, entry->layout, 16);
            memcpy(buffer + i * 64 + 48, entry->bytes, 16);
        }
        passed = write_all(fd, buffer, count * 64);
    }
    return passed;
}

int main(int argc, char** argv)
{
    bool passed = argc == 2;
    const int fd = passed ? open(argv[1], O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0600) : -1;
    passed &= fd >= 0;
    passed = passed && x86_encoder_initialize() && x86_encoder_initialize_address32() && x86_encoder_initialize_apx() && x86_encoder_initialize_legacy();
    const X86EncoderMode modes[] = { X86_ENCODER_MODE_64, X86_ENCODER_MODE_ADDRESS32, X86_ENCODER_MODE_APX, X86_ENCODER_MODE_32, X86_ENCODER_MODE_16 };
    for (uint32_t i = 0; passed && i < BUSTER_ARRAY_LENGTH(modes); i += 1)
    {
        const X86TemplateEntry* table = x86_mode_templates(modes[i]);
        passed = write_entries(fd, table) && write_entries(fd, table + BUSTER_X86_FORM_FIXUP);
    }
    if (fd >= 0)
    {
        passed &= close(fd) == 0;
    }
    printf("canonical template dump: %s; %zu modes, %u entries/mode, 64 serialized bytes, %zu storage bytes/entry\n",
        passed ? "pass" : "FAIL", BUSTER_ARRAY_LENGTH(modes), 2 * BUSTER_X86_FORM_TEMPLATES, sizeof(X86TemplateEntry));
    passed &= fflush(stdout) == 0 && !ferror(stdout);
    return passed ? 0 : 1;
}
