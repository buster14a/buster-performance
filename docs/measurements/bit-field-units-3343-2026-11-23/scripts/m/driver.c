// #1372's driver, compiled by clang -O2 alike for every kernels object: N calls of the kernel KERNEL names, each after
// a store to one of its record's fields, and the sum of their results printed.
#include <stdio.h>
#include <stdlib.h>
#include "kernels.h"
unsigned k_bits(struct B* b);
unsigned k_init(struct B* out, unsigned n);
unsigned k_union(union U* u);
unsigned k_ms(struct M* m);
unsigned k_wide(struct Q* q);

int main(int argc, char** argv)
{
    const long count = argc > 1 ? atol(argv[1]) : 50000000L;
    struct B b = { 1, 2, 3, 4 };
    union U u = { 0 };
    struct M m = { 1, 2, 3, 4 };
    struct Q q = { 1, 2, 3 };
    unsigned sum = 0;
    for (long i = 0; i < count; i += 1)
    {
#if KERNEL == 0
        b.x = (unsigned)i;
        sum += k_bits(&b);
#elif KERNEL == 1
        sum += k_init(&b, (unsigned)i);
#elif KERNEL == 2
        u.z = (unsigned long long)i * 2654435761u;
        sum += k_union(&u);
#elif KERNEL == 3
        m.x = (unsigned)i;
        sum += k_ms(&m);
#else
        q.a = (unsigned)i;
        sum += k_wide(&q);
#endif
    }
    printf("%u\n", sum);
    return 0;
}
