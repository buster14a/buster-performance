#include <stdio.h>
extern int via_table(int), with_region(int), as_size(int);
int extra(int x) { return (x + 3) * (x & 7); }
int main(void)
{
    unsigned sum = 11;
    for (int x = -150; x < 150; ++x)
    {
        sum = sum * 31 + (unsigned)via_table(x);
        sum = sum * 31 + (unsigned)with_region(x);
        sum = sum * 31 + (unsigned)as_size(x);
    }
    printf("%u\n", sum);
    return 0;
}
