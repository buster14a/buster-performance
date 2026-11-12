// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// An entry that calls nothing, for a link that only holds the program's own __tls_get_addr beside it.
int entry(void)
{
    return 0;
}
