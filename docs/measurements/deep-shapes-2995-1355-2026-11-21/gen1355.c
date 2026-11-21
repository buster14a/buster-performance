// gen1355 SHAPE N > file.c: #1355's else-if chain reproducers (SHAPE gt, gotoin, case, addr, asm, brk, cont, contl).
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
        if (strcmp(shape, "gt") == 0)
        {
            printf("int f(int x){ int r=0; ");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("%sif (x==%u) { int v%u=x; r+=v%u; goto out; } ", k ? "else " : "", k, k, k);
            }
            printf("out: return r; }\n");
        }
        else if (strcmp(shape, "brk") == 0 || strcmp(shape, "contl") == 0)
        {
            const char* jump = strcmp(shape, "brk") == 0 ? "break" : "continue";
            printf("int f(int x){ int r=0; for(;;){ ");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("%sif (x==%u) { int v%u=x; r+=v%u; %s; } ", k ? "else " : "", k, k, k, jump);
            }
            printf("else break; } return r; }\n");
        }
        else if (strcmp(shape, "cont") == 0)
        {
            printf("int f(int x){ int r=0; while (x) { ");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("%sif (x==%u) { r+=1; continue; } ", k ? "else " : "", k);
            }
            printf("else break; } return r; }\n");
        }
        else if (strcmp(shape, "case") == 0)
        {
            // Case labels down an else-if chain: each case at the chain's depth, in a switch whose arms have locals.
            printf("int f(int x){ int r=0; switch (x) { ");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("%scase %u: if (x==%u) { int v%u=x; r+=v%u; } ", k ? "else " : "", k, k, k, k);
            }
            printf("else r=-1; } return r; }\n");
        }
        else if (strcmp(shape, "addr") == 0)
        {
            printf("int f(int x){ static void* const t[%u]={", n);
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("%s&&l%u", k ? "," : "", k);
            }
            printf("}; int r=0; if (x<0) goto *t[(-x)%%%u]; ", n);
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("%sif (x==%u) { int v%u=x; l%u: r+=v%u; } ", k ? "else " : "", k, k, k, k);
            }
            printf("return r; }\n");
        }
        else if (strcmp(shape, "asm") == 0)
        {
            printf("int f(int x){ int r=0; ");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("%sif (x==%u) { int v%u=x; r+=v%u; asm goto(\"\"::::out); } ", k ? "else " : "", k, k, k);
            }
            printf("out: return r; }\n");
        }
        else if (strcmp(shape, "gotoin") == 0)
        {
            // Each arm's block entered by the arm before's goto.
            printf("int f(int x){ int r=0; ");
            for (unsigned k = 0; k < n; k += 1)
            {
                printf("%sif (x==%u) { int v%u=x; in%u: r+=v%u; if (r>%u) goto in%u; } ", k ? "else " : "", k, k, k, k, k * 3 + 1, (k + 1) % n);
            }
            printf("return r; }\n");
        }
        else
        {
            status = 1;
        }
    }
    return status;
}
