// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// A plain call of the program's own __tls_get_addr, as musl's src/ldso/dl_iterate_phdr.c calls it.
void* __tls_get_addr(unsigned long* module_and_offset);

int entry(void)
{
    unsigned long pair[2] = { 1, 0 };
    return __tls_get_addr(pair) == (void*)pair ? 0 : 1;
}
