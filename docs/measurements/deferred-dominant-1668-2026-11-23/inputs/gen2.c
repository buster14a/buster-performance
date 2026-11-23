// A synthetic unit for the deferred reader's lane measurements: `bodies` function bodies of `stanzas` blocks each (the
// first of `first` blocks and the second of `second`, when given), after the C library's headers that c-testsuite's
// programs include (stdio.h, stdlib.h and string.h; `-` names them too), none (`bare`), or many more of them (`heavy`,
// for a larger top level). Without SECOND it writes what the earlier record's gen.c writes
// (../../deferred-lane-rule-113-2026-10-25/scripts/gen.c), from which it is made.
//
//   cc -O2 -o gen2 gen2.c && ./gen2 BODIES STANZAS [bare|heavy|-] [FIRST] [SECOND] > unit.c
//
// A stanza is one block of 52 tokens: a local initialized from a call, a struct initialized from it, and an if-else.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int count, char** arguments)
{
    const unsigned long bodies = count >= 3 ? strtoul(arguments[1], 0, 10) : 0;
    const unsigned long stanzas = count >= 3 ? strtoul(arguments[2], 0, 10) : 0;
    const int bare = count >= 4 && strcmp(arguments[3], "bare") == 0;
    const int heavy = count >= 4 && strcmp(arguments[3], "heavy") == 0;
    const unsigned long first = count >= 5 ? strtoul(arguments[4], 0, 10) : stanzas;
    const unsigned long second = count >= 6 ? strtoul(arguments[5], 0, 10) : stanzas;
    static const char* const many[] = {
        "assert.h", "ctype.h", "errno.h", "fcntl.h", "float.h", "inttypes.h", "limits.h", "locale.h", "math.h", "pthread.h",
        "setjmp.h", "signal.h", "stdarg.h", "stdbool.h", "stddef.h", "stdint.h", "stdio.h", "stdlib.h", "string.h", "strings.h",
        "sys/mman.h", "sys/socket.h", "sys/stat.h", "sys/time.h", "sys/types.h", "sys/wait.h", "time.h", "unistd.h", "wchar.h", "wctype.h",
    };
    int status = 1;
    if (bodies != 0)
    {
        if (heavy)
        {
            for (unsigned long i = 0; i < sizeof(many) / sizeof(many[0]); i += 1)
            {
                printf("#include <%s>\n", many[i]);
            }
        }
        else if (!bare)
        {
            printf("#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n");
        }
        else
        {
            printf("unsigned long strlen(const char* s);\n");
        }
        printf("struct P { int a; long b; };\n");
        for (unsigned long b = 0; b < bodies; b += 1)
        {
            printf("int f%lu(int x, const char* s)\n{\n", b);
            for (unsigned long s = 0; s < (b == 0 ? first : b == 1 ? second : stanzas); s += 1)
            {
                printf("    { int v = x * %lu + (int)strlen(s); struct P p = { v, (long)x }; if (p.a > %lu) x += (int)p.b; else x -= v; }\n", s + 3, b + 7);
            }
            printf("    return x;\n}\n");
        }
        status = 0;
    }
    else
    {
        fprintf(stderr, "usage: gen2 BODIES STANZAS [bare|heavy|-] [FIRST] [SECOND]\n");
    }
    return status;
}
