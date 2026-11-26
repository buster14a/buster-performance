// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
    static const char* const setjmp_sources[3] = {
        "static void *buf[5];\n__attribute__((noinline)) static void jump(void) { __builtin_longjmp(buf, 1); }\n"
        "int run(int a, int b, int c, int d, int e, int f, int g, int h, int i, int j)\n"
        "{ int r = a + (b * (c - (d + (e * (f - (g + (h * (i - (j + __builtin_setjmp(buf)))))))))); if (r == 0) jump(); return r; }\n",
        "static void *buf[5];\n__attribute__((noinline)) static void jump(void) { __builtin_longjmp(buf, 1); }\n"
        "long double run(long double x) { long double r = x + __builtin_setjmp(buf); if (r == x) jump(); return r; }\n",
        "static void *buf[5];\n__attribute__((noinline)) static void jump(void) { __builtin_longjmp(buf, 1); }\n"
        "long double run(long double x) { if (__builtin_setjmp(buf) == 0) { x = x * 2; jump(); } return x; }\n",
    };
