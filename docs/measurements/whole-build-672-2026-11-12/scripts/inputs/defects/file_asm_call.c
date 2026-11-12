// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
// File-scope assembly: a stack alignment and a call of a C function of the unit.
void entry_call_c(void)
{
}
__asm__(".text \n.global entry_call \nentry_call: \n\tandq $-16,%rsp \n\tcall entry_call_c \n");
