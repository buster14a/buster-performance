// Generate one of two input units. The requested body count includes main.
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv)
{
    if (argc != 3)
    {
        return 1;
    }
    const int count = atoi(argv[1]);
    const int unit = atoi(argv[2]);
    if (count < 2 || count > 1024 || (unit != 0 && unit != 1))
    {
        return 1;
    }
    for (int i = 0; i < count - 1; ++i)
    {
        if (i % 2 == unit)
        {
            printf("int leaf_%u(void) { return %u; }\n", (unsigned)i, (unsigned)i + 1);
        }
        else if (unit == 1)
        {
            printf("extern int leaf_%u(void);\n", (unsigned)i);
        }
    }
    if (unit == 1)
    {
        puts("int main(void) { int result = 0;");
        for (int i = 0; i < count - 1; ++i)
        {
            printf("result += leaf_%u();\n", (unsigned)i);
        }
        printf("return result == %d ? 37 : 1; }\n", count * (count - 1) / 2);
    }
    return ferror(stdout) != 0;
}
