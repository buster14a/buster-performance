// Calls one of kernels.c's functions 50 M times on xorshift64's high bits (#1382's bench.c, its loops' kernels left out
// and an int-valued `&&`/`||` added, #2677).
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int k_null(int a, int b);
int k_clamp(int x);
bool k_and(int a, int b);
bool k_andor(int a, int b, int c);
int k_andori(int a, int b, int c);
static uint64_t state = 0x9e3779b97f4a7c15u;
static inline uint64_t next(void)
{
    state ^= state << 13;
    state ^= state >> 7;
    state ^= state << 17;
    return state;
}
int main(int argc, char** argv)
{
    const char* kernel = argc > 1 ? argv[1] : "";
    long acc = 0;
    enum { CALLS = 50000000 };
    const int which = strcmp(kernel, "null") == 0 ? 0 : strcmp(kernel, "clamp") == 0 ? 2 : strcmp(kernel, "and") == 0 ? 3 : strcmp(kernel, "andor") == 0 ? 4 : strcmp(kernel, "andori") == 0 ? 5 : -1;
    if (which < 0)
    {
        fprintf(stderr, "bench: unknown kernel '%s'\n", kernel);
        return 2;
    }
    for (int i = 0; i < CALLS; i += 1)
    {
        const uint64_t x = next();
        const int a = (int)(x >> 32);
        const int b = (int)(uint32_t)x;
        switch (which)
        {
            case 0: acc += k_null(a, b); break;
            case 2: acc += k_clamp((int)((x >> 40) & 1023) - 256); break;
            case 3: acc += k_and((int)(x >> 56), (int)((x >> 48) & 255)); break;
            case 4: acc += k_andor((int)((x >> 60) & 15), (int)((x >> 56) & 15), (int)((x >> 52) & 15)); break;
            default: acc += k_andori((int)((x >> 60) & 15), (int)((x >> 56) & 15), (int)((x >> 52) & 15)); break;
        }
    }
    printf("%s %ld\n", kernel, acc);
    return 0;
}
