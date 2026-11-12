// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// File-scope assembly: a hidden reference inside a function.
__asm__(".text \n.global entry_hidden \nentry_hidden: \n.hidden marker_hidden \n\tlea marker_hidden(%rip),%rsi \n\tret \n");
