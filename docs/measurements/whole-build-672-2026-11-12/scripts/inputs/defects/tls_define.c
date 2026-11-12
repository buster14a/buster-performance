// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// A program's own __tls_get_addr, as a C library defines it (musl's src/thread/__tls_get_addr.c).
void* __tls_get_addr(unsigned long* module_and_offset)
{
    return module_and_offset;
}
