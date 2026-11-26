// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
//
static void tier1_select_test_node(IrFunction* function, uint32_t i, uint8_t op, uint8_t type, uint32_t a, uint32_t b, uint32_t c)
{
    function->op[i] = op;
    function->type[i] = type;
    function->a[i] = a;
    function->b[i] = b;
    function->c[i] = c;
}

static uint32_t tier1_select_test_append(IrFunction* function, uint32_t* next, uint8_t op, uint8_t type, uint32_t a, uint32_t b, uint32_t c)
{
    const uint32_t node = *next;
    tier1_select_test_node(function, node, op, type, a, b, c);
    *next = node + 1;
    return node;
}

