#include "ty.h"
struct After { double d; int *ip; };
int after(struct After *a, unsigned short us)
{
    const struct After *volatile *pp = 0;
    return (int)a->d + us + (pp != 0) + sizeof(int [3][5]);
}
