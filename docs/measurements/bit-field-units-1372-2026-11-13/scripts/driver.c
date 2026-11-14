// #1372's driver, compiled by clang -O2 alike for every k_bits object: N calls of k_bits, each after a store to b.x.
#include <stdio.h>
#include <stdlib.h>

struct B { unsigned x : 3, y : 7, z : 13, w : 9; };
unsigned k_bits(struct B *b);

int main(int argc, char** argv)
{
    const long count = argc > 1 ? atol(argv[1]) : 50000000L;
    struct B b = { 1, 2, 3, 4 };
    unsigned sum = 0;
    for (long i = 0; i < count; i += 1)
    {
        b.x = (unsigned)i;
        sum += k_bits(&b);
    }
    printf("%u\n", sum);
    return 0;
}
