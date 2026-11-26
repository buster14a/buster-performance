// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
    static const char* const static_label_sources[4] = {
        "int printf(const char*, ...);\nint f(void) { static int n = 5; return n++; }\nextern int fn __asm__(\"f.n\");\n"
        "int main(void) { f(); printf(\"%d\\n\", fn); return 0; }\n",
        "int printf(const char*, ...);\nextern int fn __asm__(\"f.n\");\nint g(void) { return fn; }\nint f(void) { static int n = 5; return n++; }\n"
        "int main(void) { f(); printf(\"%d\\n\", g()); return 0; }\n",
        "int f(void) { static int n = 5; return n++; }\nint fn __asm__(\"f.n\") = 9;\nint main(void) { return f() + fn; }\n",
        "int f(void) { static int n = 5; return n++; }\nint fm __asm__(\"f.m\") = 9;\nint main(void) { return f() + fm; }\n",
    };
