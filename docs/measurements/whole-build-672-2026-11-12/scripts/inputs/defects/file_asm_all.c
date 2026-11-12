// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// File-scope assembly: the other files' pieces in one function (a .type directive, a weak and hidden reference, a
// stack alignment and a call of a C function of the unit).
void entry_all_c(void)
{
}
__asm__(".text \n.global entry_all \n.type entry_all,%function \nentry_all: \n.weak marker_all \n.hidden marker_all \n\tlea marker_all(%rip),%rsi \n\tandq $-16,%rsp \n\tcall entry_all_c \n\tret \n");
