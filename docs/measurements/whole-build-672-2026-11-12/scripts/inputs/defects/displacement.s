# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
# A displacement written as a parenthesized expression before the address's own parentheses, as musl's
# src/string/x86_64/memset.s writes its stores.
    .text
    .globl store
    .type store,@function
store:
    mov %ax,(-1-2)(%rdi,%rdx)
    ret
