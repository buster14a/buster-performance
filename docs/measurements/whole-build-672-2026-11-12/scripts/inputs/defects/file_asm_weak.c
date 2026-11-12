// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// File-scope assembly: a weak reference inside a function.
__asm__(".text \n.global entry_weak_only \nentry_weak_only: \n.weak marker_only \n\tlea marker_only(%rip),%rsi \n\tret \n");
