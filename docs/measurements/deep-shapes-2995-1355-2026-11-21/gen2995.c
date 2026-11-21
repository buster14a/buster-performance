// gen2995 SHAPE N > file.c: #2995's deep shapes (regions: N nested statement expressions with a GNU break in a loop;
// bounds: one array of N variable bounds; declarators: one declaration of N variable-length arrays).
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
    int status = 1;
    if (argc == 3)
    {
        const char* shape = argv[1];
        const unsigned n = (unsigned)strtoul(argv[2], 0, 10);
        status = 0;
        if (strcmp(shape, "regions") == 0)
        {
            printf("int f(int x){for(int i=0;i<x;i++){x+=");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("({");
            }
            printf("if(i==3)break;i;");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("});");
            }
            printf("}return x;}\n");
        }
        else if (strcmp(shape, "bounds") == 0)
        {
            printf("int f(int n){int a");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("[n]");
            }
            printf(";return sizeof a>0;}\n");
        }
        else if (strcmp(shape, "declarators") == 0)
        {
            printf("int f(int n){int ");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("%sa%u[n]", k ? "," : "", k);
            }
            printf(";return sizeof a0;}\n");
        }
        else
        {
            status = 1;
        }
    }
    return status;
}
