#include <stdio.h>
long k_struct16(const long *p, int n);
static long data[4096];
int main(void)
{
    for (int i = 0; i < 4096; i++) data[i] = i * 3 + 1;
    long s = 0;
    for (int r = 0; r < 20000; r++) s += k_struct16(data, 4096);
    printf("%ld\n", s);
    return 0;
}
