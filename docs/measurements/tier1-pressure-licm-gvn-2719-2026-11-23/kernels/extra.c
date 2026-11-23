#include <stddef.h>
#include <stdint.h>
// Loops with invariant work LICM should hoist.
void x_rows_sum(int32_t *d, const int32_t *s, int w, int h)
{
    for (int i = 0; i + 1 < h; i += 1)
    {
        for (int j = 0; j < w; j += 1)
        {
            d[i * w + j] = s[i * w + j] + s[(i + 1) * w + j];
        }
    }
}
void x_affine(int32_t *d, const int32_t *a, int x, int y, int z, int n)
{
    for (int i = 0; i < n; i += 1)
    {
        d[i] = a[i] * (x * y + z) + (z << 3);
    }
}
int64_t x_window(const int32_t *a, int n, int k)
{
    int64_t s = 0;
    for (int i = 0; i < n - k; i += 1)
    {
        s += a[i + k - 1] - a[i];
    }
    return s;
}
void x_transpose(int32_t *d, const int32_t *s, int n)
{
    for (int i = 0; i < n; i += 1)
    {
        for (int j = 0; j < n; j += 1)
        {
            d[j * n + i] = s[i * n + j];
        }
    }
}
uint32_t x_mix(const uint32_t *a, int n, uint32_t seed, uint32_t mul)
{
    uint32_t h = seed;
    for (int i = 0; i < n; i += 1)
    {
        h = (h ^ a[i]) * (mul | 1u) + (seed >> 7);
    }
    return h;
}
