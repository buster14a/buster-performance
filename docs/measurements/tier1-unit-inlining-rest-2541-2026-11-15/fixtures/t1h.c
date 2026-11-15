int printf(const char *, ...);
volatile int t1h_sink;
__attribute__((noinline)) void t1h_mark(int y)
{
    t1h_sink = y;
}
#include "t1h.h"
static int t1h_twice(int x)
{
    return t1h_square(x) + t1h_square(x + 1);
}
int main(void)
{
    int total = 0;
    for (int i = 0; i < 3; i += 1)
    {
        total += t1h_twice(i);
    }
    printf("T1H %d\n", total);
    return total != 25;
}
