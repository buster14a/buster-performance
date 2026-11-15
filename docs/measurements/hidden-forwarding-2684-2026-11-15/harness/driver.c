#include <stdio.h>
long kernel(int m);
int main(void)
{
    printf("%ld\n", kernel(CALLS));
    return 0;
}
