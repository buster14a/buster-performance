// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
static const char check_driver_truth_rules[] =
    "enum E { A, B, C = 5 };\n"
    "struct S { int m; int a[4]; _Bool b; struct S* p; };\n"
    "int g(void);\n"
    "extern int table[4];\n"
    "int f(int x, int y, unsigned u, _Bool b, double d, struct S s, struct S* p, int* q)\n"
    "{\n"
    "    int r = 0;\n"
    "    if (x) r += 1;\n"                           // rejected: a value
    "    if (p->m == 0) r += 1;\n"                   // rejected: a literal beside no boolean
    "    if (x != 3 && y) r += 1;\n"                 // rejected
    "    if ((x & 8) == 0) r += 1;\n"                // rejected: a literal 0 beside `&`
    "    if (x & 8) r += 1;\n"                       // rejected once asked: no constant 0
    "    if (!(x & 8)) r += 1;\n"                    // rejected once asked
    "    if ((x & 8) && y) r += 1;\n"                // rejected once asked, the `&` as a first operand too
    "    r += (x & 16) ? 1 : 2;\n"                   // rejected once asked by the conditional
    "    if (x == 1 && y == 2) r += 1;\n"            // rejected: two variables
    "    if (x == 1 || p->m == 2) r += 1;\n"         // rejected: a value and a member
    "    if (!x && y) r += 1;\n"                     // rejected: a `!` beside another value's
    "    if (!x || p->m) r += 1;\n"                  // rejected: a `!` of a value beside a member
    "    if (q) r += 1;\n"                           // rejected: an lvalue's address constant
    "    if (s.m) r += 1;\n"                         // rejected: a member's
    "    if (x == y) r += 1;\n"                      // rejected: no literal
    "    if (1) r += 1;\n"                           // a constant
    "    if (0 && x) r += 1;\n"                      // through a logical operator
    "    if (x || 1) r += 1;\n"
    "    if (!0) r += 1;\n"                          // through `!`
    "    if ((_Bool)1) r += 1;\n"                    // through a cast
    "    if (__builtin_constant_p(x)) r += 1;\n"     // a query
    "    if (table) r += 1;\n"                       // an array's address
    "    if (g) r += 1;\n"                           // a function's
    "    if (\"s\") r += 1;\n"                       // a string literal's
    "    if (&x) r += 1;\n"                          // an object's
    "    if (x * 0) r += 1;\n"                       // `x * 0`
    "    if (0 * x) r += 1;\n"
    "    if (x & 0) r += 1;\n"
    "    if ((x & 0) && y) r += 1;\n"
    "    r += (x & 0) ? 1 : 2;\n"
    "    if (x | 1) r += 1;\n"                       // `x | 1`
    "    if (1 | x) r += 1;\n"
    "    if ((x & 8) == 4) r += 1;\n"                // the bitwise equality
    "    if (4 == (x & 8)) r += 1;\n"
    "    if ((x | 8) == 0) r += 1;\n"
    "    if ((x | 8) != -1) r += 1;\n"               // a literal `-` takes
    "    if ((x & 8) == ~0) r += 1;\n"
    "    if ((x < y) == 10) r += 1;\n"               // a boolean value and a literal above 1
    "    if (b == 2) r += 1;\n"                      // a _Bool's
    "    if (10 > b) r += 1;\n"                      // the relational check
    "    if (!x >= 2) r += 1;\n"
    "    if (x == 1 && x == 2) r += 1;\n"            // two comparisons of one variable
    "    if (1 < x || 5 > x) r += 1;\n"              // their constants on the left
    "    if (p->m == A && p->m == B) r += 1;\n"      // a member and enumerators
    "    if (s.a[1] < 2 && s.a[1] > 3) r += 1;\n"    // an element
    "    if (d < 1.5 && d > 2.5) r += 1;\n"          // floating constants
    "    if (x || !x) r += 1;\n"                     // a value and its negation
    "    if (!x && x) r += 1;\n"
    "    if (p->m && !p->m) r += 1;\n"               // a member's
    "    if (s.a[1] || !s.a[1]) r += 1;\n"           // an element's
    "    if ((x == 1 && x == 2) || y) r += 1;\n"     // a logical operator's operand
    "    do { r += 1; } while (x * 0);\n"            // a do statement's condition
    "    while (y && (x | 1)) { r += 1; break; }\n"
    "    r += (x & 8) == 4 ? 1 : 2;\n"               // a conditional's
    "    r += x ?: 2;\n"                             // GNU's, rejected
    "    if (*(int (*)[4])4096) r += 1;\n"           // an lvalue array's address, with no object
    "    if (0 * (x + y)) r += 1;\n"                 // operators whose operands aren't the nodes before them
    "    if (x * (char)0) r += 1;\n"
    "    r += x * (char)0;\n"                        // a product nobody asks
    "    if (1 | (x + y)) r += 1;\n"
    "    if (x && (char)0) r += 1;\n"
    "    if (!(x && (char)0)) r += 1;\n"
    "    if ((_Bool)(x && (char)0)) r += 1;\n"
    "    if ((x && (char)0) || y) r += 1;\n"
    "    if (y && (x && (char)0)) r += 1;\n"
    "    if (x == -1 && x == -2) r += 1;\n"
    "    if (x != -2 || x != -1) r += 1;\n"
    "    if (y && x * (char)0) r += 1;\n"
    "    return r;\n"
    "}\n"
    "_Bool h(int x)\n"                               // through a return's conversion
    "{\n"
    "    return x && (char)0;\n"
    "}\n";

// A unit with a wrapper of _Bool (an aligned one), where a value's type alone doesn't say it is boolean.
static const char check_driver_truth_wrapped[] =
    "typedef _Bool __attribute__((aligned(4))) Wide;\n"
    "int f(Wide w, _Bool b, int x, int y)\n"
    "{\n"
    "    int r = 0;\n"
    "    if (w == 2) r += 1;\n"                     // an aligned _Bool's
    "    if (3 < w) r += 1;\n"
    "    if (b == 2) r += 1;\n"
    "    if (x == 2) r += 1;\n"                     // rejected
    "    if (x != 3 && y) r += 1;\n"                // rejected
    "    return r;\n"
    "}\n";

// xorshift64*.
