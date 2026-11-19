#include <algorithm>

extern "C" void sort_b(int *p, unsigned n)
{
    std::sort(p, p + n);
    std::reverse(p, p + n);
}
