#include <stdio.h>
extern int run_locals(int);
int main(void)
{
    unsigned hash = 1;
    for (int i = -100; i <= 100; ++i) hash = hash * 31 + (unsigned)run_locals(i);
    printf("%u\n",hash);
    return 0;
}
