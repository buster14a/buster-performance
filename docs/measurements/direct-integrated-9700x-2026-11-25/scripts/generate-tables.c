#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        return 1;
    }
    if (strcmp(argv[1], "switch") == 0)
    {
        puts("int lookup(int n){ switch(n) {");
        for (unsigned i = 0; i < 4000; ++i)
        {
            printf("case %u: return %u;\n", i, (i * 131u + 33u) % 3367u);
        }
        puts("default: return -1; }}");
    }
    else if (strcmp(argv[1], "unsigned") == 0)
    {
        puts("const unsigned long values[32768] = {");
        for (unsigned i = 0; i < 32768; ++i)
        {
            printf("0x%08xU,", 0x80000000u + i % 256u);
            if (i % 16u == 15u)
            {
                putchar('\n');
            }
        }
        puts("};");
    }
    else
    {
        return 1;
    }
    return ferror(stdout) != 0;
}
