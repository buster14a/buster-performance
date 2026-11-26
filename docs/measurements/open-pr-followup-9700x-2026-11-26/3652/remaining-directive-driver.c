#include <stdio.h>
#include <stdlib.h>

int tested(int n);

int main(int argc, char **argv)
{
    long iterations = argc == 2 ? strtol(argv[1], 0, 10) : 1000000;
    unsigned long checksum = 0;
    for (long i = 0; i < iterations; ++i)
        checksum += (unsigned int)tested((int)(i % 211) - 105);
    printf("%lu\n", checksum);
    return 0;
}
