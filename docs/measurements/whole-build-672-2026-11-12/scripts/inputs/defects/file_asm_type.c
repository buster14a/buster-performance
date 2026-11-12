// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// File-scope assembly: a function with a .type directive.
__asm__(".text \n.global entry_type \n.type entry_type,%function \nentry_type: \n\txor %rbp,%rbp \n\tret \n");
