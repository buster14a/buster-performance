#include <stdio.h>
long k_sret(int m);
int main(void)
{
    printf("%ld\n", k_sret(20000000));
    return 0;
}
