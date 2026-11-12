// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// File-scope assembly: a weak, hidden reference inside a function, as musl's crt_arch.h takes _DYNAMIC's address.
__asm__(".text \n.global entry_weak \nentry_weak: \n.weak marker \n.hidden marker \n\tlea marker(%rip),%rsi \n\tret \n");
