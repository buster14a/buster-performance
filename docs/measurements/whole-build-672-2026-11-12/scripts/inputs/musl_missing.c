// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
//
// The two functions the frozen corpus's musl doesn't hold: it is Zig 0.14.1's copy, and Zig supplies memcpy and memmove
// from its own runtime, so its copy has neither's source. These stand in for them in the record's link of the library.
#include <stddef.h>

void* memcpy(void* restrict destination, const void* restrict source, size_t count)
{
    unsigned char* to = destination;
    const unsigned char* from = source;
    for (size_t i = 0; i < count; i += 1)
    {
        to[i] = from[i];
    }
    return destination;
}

void* memmove(void* destination, const void* source, size_t count)
{
    unsigned char* to = destination;
    const unsigned char* from = source;
    if (to < from)
    {
        for (size_t i = 0; i < count; i += 1)
        {
            to[i] = from[i];
        }
    }
    else
    {
        for (size_t i = count; i > 0; i -= 1)
        {
            to[i - 1] = from[i - 1];
        }
    }
    return destination;
}
