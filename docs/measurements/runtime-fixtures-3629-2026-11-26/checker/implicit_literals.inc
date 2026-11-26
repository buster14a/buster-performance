// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
static const char implicit_int_source[] =
            "x = 3;\n"
            "typedef t;\n"
            "t y = 1;\n"
            "int q = 7;\n"
            "*const p = &q;\n"
            "*__restrict r = &q;\n"
            "*__attribute__((unused)) a = &q;\n"
            "struct S { const x; };\n"
            "int tested(int n)\n"
            "{\n"
            "    return x == 3 && sizeof(x) == sizeof(int) && y == 1 && sizeof(y) == sizeof(int) && q == 7 && *p == 7 && *a == 7 &&\n"
            "           *r == 7 && p == &q && a == &q && r == &q && sizeof(*p) == sizeof(int) && sizeof(const) == sizeof(int) &&\n"
            "           sizeof(volatile) == sizeof(int) && sizeof(struct S) == sizeof(int) && (const)1 == 1 ? 0 : 1;\n"
            "}\n";
static const char implicit_int_program_source[] =
            "static x = 3;\n"
            "helper(a) int a; { return a + 1; }\n"
            "tested(n) { register i; i = helper(x + n); return i; }\n";
static const char implicit_int_parameter_source[] =
            "static f(*p) { return *p + (int)sizeof(*p); }\n"
            "static g(const x) { return x * 2; }\n"
            "static h(register r) { return r + 1; }\n"
            "static m(const *p, volatile v) { return *p - v; }\n"
            "int k(int a, *p);\n"
            "int k(int a, int *p) { return a + *p; }\n"
            "int tested(int n) { int v = 5; return f(&v) + g(n) + h(n) + m(&v, n) + k(n, &v); }\n";
