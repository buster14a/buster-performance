#include <algorithm>

extern "C" void sort_b(int *, unsigned);

static __attribute__((noinline)) void sort_a(int *p, unsigned n)
{
    std::sort(p, p + n);
}

int main()
{
    int v[] = {4, 2, 8, -1, 2, 6, 9, 0, 13, 7, -5, 3, 1, 6, 4, 11, 5, 6, 2};
    unsigned n = sizeof(v) / sizeof(v[0]);
    sort_a(v, n);
    for (unsigned i = 1; i < n; ++i)
        if (v[i-1] > v[i])
            return 1;
    sort_b(v, n);
    for (unsigned i = 1; i < n; ++i)
        if (v[i-1] < v[i])
            return 2;
    return v[0] == 13 && v[n-1] == -5 ? 42 : 3;
}
