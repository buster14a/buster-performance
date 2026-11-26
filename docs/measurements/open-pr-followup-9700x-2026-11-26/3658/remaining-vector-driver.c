#include <stdio.h>
#include <stdlib.h>

#define DRIVER(N) \
    typedef unsigned Vec##N __attribute__((vector_size(4 * (N)))); \
    void put_v##N(Vec##N*, const unsigned*, unsigned); \
    static unsigned long run_##N(void) \
    { \
        Vec##N output; \
        unsigned input[N]; \
        unsigned long sum = 0; \
        for (unsigned i = 0; i < N; ++i) \
        { \
            input[i] = 17u * (i + 1u); \
        } \
        for (unsigned i = 0; i < 20000000u; ++i) \
        { \
            put_v##N(&output, input, i); \
            sum += output[(i * 7u) % N]; \
        } \
        return sum; \
    }
DRIVER(4)
DRIVER(8)
DRIVER(16)

int main(int argc, char** argv)
{
    if (argc != 2)
        return 2;
    int n = atoi(argv[1]);
    unsigned long result = n == 4 ? run_4() : n == 8 ? run_8() : run_16();
    printf("%lu\n", result);
    return 0;
}
