#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int status = argc < 4;
    if (!status)
    {
        const unsigned count = (unsigned)strtoul(argv[2], NULL, 10);
        const int pointer = strcmp(argv[1], "pointer") == 0;
        const int constant = strcmp(argv[3], "constant") == 0;
        for (unsigned i = 0; i < count; i += 1)
        {
            printf("struct S%u%s;\n", i, pointer ? "" : "{int member;}");
        }
        printf("%s_Generic(%s,", constant ? "enum{N=" : "int f(void){return ", pointer ? "(struct S0*)0" : "*(struct S0*)0");
        for (unsigned i = 0; i < count; i += 1)
        {
            printf("struct S%u%s:%u,", i, pointer ? "*" : "", i);
        }
        printf("default:7)%s\n", constant ? "};_Static_assert(N==0,\"selected\");int f(void){return N;}" : ";}");
        printf("int main(void){return f();}\n");
        status = ferror(stdout) != 0;
    }
    return status;
}
