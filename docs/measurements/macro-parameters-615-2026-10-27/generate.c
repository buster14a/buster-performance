// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Original synthetic inputs for the Buster performance audit, 2026-10-27.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int result = 0;
    const char* kind = argc == 3 ? argv[1] : "";
    unsigned n = argc == 3 ? (unsigned)strtoul(argv[2], NULL, 10) : 0;
    if (argc != 3)
    {
        result = 2;
    }
    else if (!strcmp(kind, "vla"))
    {
        puts("int f(int n) {");
        for (unsigned i = 0; i < n; ++i) printf("typedef int A%u[n];\n", i);
        puts("return n; }");
    }
    else if (!strcmp(kind, "generic") || !strcmp(kind, "generic_const"))
    {
        for (unsigned i = 0; i < n; ++i) printf("struct S%u { int x; };\n", i);
        puts(!strcmp(kind, "generic") ? "int f(void) { return _Generic(0," : "enum { answer = _Generic(0,");
        for (unsigned i = 0; i < n; ++i) printf("struct S%u: %u,\n", i, i);
        puts(!strcmp(kind, "generic") ? "default: 1); }" : "default: 1) };");
    }
    else if (!strcmp(kind, "nested"))
    {
        for (unsigned i = 0; i < n; ++i) printf("struct S%u {\n", i);
        puts("int leaf;");
        for (unsigned i = n; i-- > 1;) printf("} m%u;\n", i);
        puts("};");
    }
    else if (!strcmp(kind, "chain"))
    {
        puts("struct S0 { int leaf; };");
        for (unsigned i = 1; i < n; ++i) printf("struct S%u { struct S%u member; };\n", i, i-1);
    }
    else if (!strcmp(kind, "copy"))
    {
        printf("struct S { char bytes[%u]; };\nvoid f(struct S *a, struct S *b) { *a = *b; }\n", n);
    }
    else if (!strcmp(kind, "zero") || !strcmp(kind, "bss"))
    {
        printf("char a[%u]%s;\n", n, !strcmp(kind, "zero") ? " = {0}" : "");
    }
    else if (!strcmp(kind, "params"))
    {
        puts("int x = sizeof(int (*)(");
        for (unsigned i = 0; i < n; ++i) printf("%sint p%u\n", i ? "," : "", i);
        puts("));");
    }
    else if (!strcmp(kind, "overload"))
    {
        for (unsigned i = 0; i < n; ++i) printf("struct S%u { int x; };\nint f(struct S%u *p) __attribute__((overloadable));\n", i, i);
    }
    else if (!strcmp(kind, "macro") || !strcmp(kind, "macro_unused"))
    {
        printf("#define F(");
        for (unsigned i = 0; i < n; ++i) printf("%sp%u", i ? "," : "", i);
        printf(") ");
        for (unsigned i = 0; i < n; ++i) printf("%sp%u", i ? "+" : "", i);
        puts("");
        if (!strcmp(kind, "macro"))
        {
            printf("F(");
            for (unsigned i = 0; i < n; ++i) printf("%s1", i ? "," : "");
            puts(")");
        }
    }
    else if (!strcmp(kind, "macro_nested"))
    {
        puts("#define F(x) x");
        for (unsigned i = 0; i < n; ++i) printf("F(");
        printf("1");
        for (unsigned i = 0; i < n; ++i) printf(")");
        puts("");
    }
    else if (!strcmp(kind, "enum"))
    {
        puts("enum { A0 = 0,");
        for (unsigned i = 1; i < n; ++i) printf("A%u = A%u + 1,\n", i, i-1);
        puts("};");
    }
    else
    {
        result = 2;
    }
    return ferror(stdout) ? 1 : result;
}
