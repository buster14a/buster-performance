// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
    static const struct
    {
        const char* source;
        const char* option;
        int status;
        const char* message;
        const char* label;
    } cases[] = {
        { "__attribute__((nocf_check)) void f(void) {}\n", "-fcf-protection", 1, "not yet supported", "nocf_check is refused under -fcf-protection" },
        { "__attribute__((nocf_check)) void f(void) {}\n", "-fcf-protection=branch", 1, "not yet supported", "nocf_check is refused under =branch" },
        { "__attribute__((nocf_check)) void f(void) {}\n", "-fcf-protection=return", 0, "'nocf_check' attribute ignored", "nocf_check is ignored under =return, as clang's" },
        { "void* b[5];\nint f(void) { return __builtin_setjmp(b); }\n", "-fcf-protection=return", 1, "the shadow stack's fix",
          "__builtin_setjmp is refused under =return" },
        { "void* b[5];\nvoid f(void) { __builtin_longjmp(b, 1); }\n", "-fcf-protection", 1, "the shadow stack's fix", "__builtin_longjmp is refused under =full" },
        { "__attribute__((target_clones(\"avx2\", \"default\"))) int f(int x) { return x; }\nint g(int x) { return f(x); }\n", "-fcf-protection=branch", 1,
          "multiversioned functions", "multiversioned functions are refused under =branch" },
        { "__attribute__((target_clones(\"avx2\", \"default\"))) int f(int x) { return x; }\nint g(int x) { return f(x); }\n", "-fcf-protection=return", 0, NULL,
          "multiversioned functions compile under =return" },
    };
