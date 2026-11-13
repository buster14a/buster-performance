// A compile-time stress for #1372's unit lookup: a struct of 256 one-bit fields (one run, 32 units of 8 bytes), and
// 64 functions that each read and update every field through a pointer, 32,768 bit-field accesses in all. Each access
// walks back over its run's members and chains its units, the lookup's worst shape.
#include <stdio.h>

int main(void)
{
    printf("struct F {");
    for (int f = 0; f < 256; f += 1)
    {
        printf(" unsigned f%d : 1;", f);
    }
    printf(" };\n");
    for (int g = 0; g < 64; g += 1)
    {
        printf("unsigned g%d(struct F *p) { unsigned s = 0;", g);
        for (int f = 0; f < 256; f += 1)
        {
            printf(" s += p->f%d; p->f%d ^= s;", f, f);
        }
        printf(" return s; }\n");
    }
    return 0;
}
