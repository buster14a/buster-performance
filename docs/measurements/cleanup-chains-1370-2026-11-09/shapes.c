// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// #1370's shapes: N cleanup variables, each followed by an exit. Usage: shapes returns|nested|loop|goto|none N
// ("none" is the returns shape without the cleanup attribute: code that must not change).
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char** argv)
{
    const char* shape = argc > 2 ? argv[1] : "returns";
    const int n = argc > 2 ? atoi(argv[2]) : 10;
    const char* attribute = strcmp(shape, "none") == 0 ? "" : " __attribute__((cleanup(rel)))";
    printf("void rel(int *p);\nint g(int a) { int s = 0;%s\n", strcmp(shape, "loop") == 0 ? " for (int k = 0; k < 3; k++) {" : strcmp(shape, "goto") == 0 ? " {" : "");
    for (int i = 0; i < n; i += 1)
    {
        if (strcmp(shape, "nested") == 0)
        {
            printf("{ int c%d%s = a + %d; if (a == %d) return s; s += c%d;\n", i, attribute, i, i, i);
        }
        else if (strcmp(shape, "loop") == 0)
        {
            printf("int c%d%s = a + %d + k; if (a == %d + k) continue; if (a == %d + 2 * k) break; s += c%d;\n", i, attribute, i, i, i, i);
        }
        else if (strcmp(shape, "goto") == 0)
        {
            printf("int c%d%s = a + %d; if (a == %d) goto fail; s += c%d;\n", i, attribute, i, i, i);
        }
        else
        {
            printf("int c%d%s = a + %d; if (a == %d) return s; s += c%d;\n", i, attribute, i, i, i);
        }
    }
    for (int i = 0; strcmp(shape, "nested") == 0 && i < n; i += 1)
    {
        printf("}");
    }
    printf("%s\n", strcmp(shape, "loop") == 0 ? "} return s; }" : strcmp(shape, "goto") == 0 ? "} return s; fail: return -s; }" : "return s; }");
    return 0;
}
