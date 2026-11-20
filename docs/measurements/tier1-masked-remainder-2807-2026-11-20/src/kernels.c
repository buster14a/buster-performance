/* Array loops as C programmers write them: no restrict, no intrinsics, no pragmas. */
#include "kernels.h"

int64_t k_sum_i32(const int32_t *a, size_t n)
{
    int64_t s = 0;
    for (size_t i = 0; i < n; i += 1)
    {
        s += a[i];
    }
    return s;
}

uint32_t k_sum_u8(const uint8_t *a, size_t n)
{
    uint32_t s = 0;
    for (size_t i = 0; i < n; i += 1)
    {
        s += a[i];
    }
    return s;
}

uint32_t k_dot_i16(const int16_t *a, const int16_t *b, size_t n)
{
    uint32_t s = 0;
    for (size_t i = 0; i < n; i += 1)
    {
        s += (uint32_t)((int32_t)a[i] * (int32_t)b[i]);
    }
    return s;
}

int32_t k_max_i32(const int32_t *a, size_t n)
{
    int32_t m = INT32_MIN;
    for (size_t i = 0; i < n; i += 1)
    {
        if (a[i] > m)
        {
            m = a[i];
        }
    }
    return m;
}

size_t k_count_eq_u8(const uint8_t *a, size_t n, uint8_t v)
{
    size_t c = 0;
    for (size_t i = 0; i < n; i += 1)
    {
        c += a[i] == v;
    }
    return c;
}

int64_t k_cond_sum_i32(const int32_t *a, size_t n, int32_t t)
{
    int64_t s = 0;
    for (size_t i = 0; i < n; i += 1)
    {
        if (a[i] > t)
        {
            s += a[i];
        }
    }
    return s;
}

uint64_t k_popcount_u64(const uint64_t *a, size_t n)
{
    uint64_t s = 0;
    for (size_t i = 0; i < n; i += 1)
    {
        s += (uint64_t)__builtin_popcountll(a[i]);
    }
    return s;
}

int64_t k_aos_sum(const Particle *p, size_t n)
{
    int64_t s = 0;
    for (size_t i = 0; i < n; i += 1)
    {
        s += (int64_t)p[i].x * p[i].w;
    }
    return s;
}

void k_add_i32(int32_t *d, const int32_t *a, const int32_t *b, size_t n)
{
    for (size_t i = 0; i < n; i += 1)
    {
        d[i] = (int32_t)((uint32_t)a[i] + (uint32_t)b[i]);
    }
}

void k_saxpy_f32(float *y, const float *x, float k, size_t n)
{
    for (size_t i = 0; i < n; i += 1)
    {
        y[i] += k * x[i];
    }
}

void k_scale_u8(uint8_t *d, const uint8_t *s, unsigned k, size_t n)
{
    for (size_t i = 0; i < n; i += 1)
    {
        d[i] = (uint8_t)((s[i] * k) >> 8);
    }
}

void k_blend_u8(uint8_t *d, const uint8_t *a, const uint8_t *b, unsigned alpha, size_t n)
{
    for (size_t i = 0; i < n; i += 1)
    {
        d[i] = (uint8_t)((a[i] * alpha + b[i] * (256 - alpha)) >> 8);
    }
}

void k_clamp_i32(int32_t *d, const int32_t *a, int lo, int hi, int n)
{
    for (int i = 0; i < n; i += 1)
    {
        int v = a[i];
        d[i] = v < lo ? lo : v > hi ? hi : v;
    }
}

void k_i32_to_f32(float *d, const int32_t *a, float k, size_t n)
{
    for (size_t i = 0; i < n; i += 1)
    {
        d[i] = (float)a[i] * k;
    }
}

void k_fill_u32(uint32_t *d, uint32_t v, size_t n)
{
    for (size_t i = 0; i < n; i += 1)
    {
        d[i] = v;
    }
}

void k_copy_u8(uint8_t *d, const uint8_t *s, size_t n)
{
    for (size_t i = 0; i < n; i += 1)
    {
        d[i] = s[i];
    }
}

void k_stencil3_u8(uint8_t *d, const uint8_t *s, size_t n)
{
    for (size_t i = 1; i + 1 < n; i += 1)
    {
        d[i] = (uint8_t)((s[i - 1] + 2 * s[i] + s[i + 1] + 2) >> 2);
    }
}

void k_rgb_to_gray(uint8_t *g, const uint8_t *rgb, int n)
{
    for (int i = 0; i < n; i += 1)
    {
        g[i] = (uint8_t)((77 * rgb[3 * i] + 150 * rgb[3 * i + 1] + 29 * rgb[3 * i + 2]) >> 8);
    }
}

void k_matmul_f32(float *c, const float *a, const float *b, size_t n)
{
    for (size_t i = 0; i < n; i += 1)
    {
        for (size_t k = 0; k < n; k += 1)
        {
            float aik = a[i * n + k];
            for (size_t j = 0; j < n; j += 1)
            {
                c[i * n + j] += aik * b[k * n + j];
            }
        }
    }
}

float k_dot_f32(const float *a, const float *b, size_t n)
{
    float s = 0.0f;
    for (size_t i = 0; i < n; i += 1)
    {
        s += a[i] * b[i];
    }
    return s;
}

void k_prefix_sum_i32(int32_t *a, size_t n)
{
    for (size_t i = 1; i < n; i += 1)
    {
        a[i] = (int32_t)((uint32_t)a[i] + (uint32_t)a[i - 1]);
    }
}

void k_histogram_u8(uint32_t *h, const uint8_t *a, size_t n)
{
    for (size_t i = 0; i < n; i += 1)
    {
        h[a[i]] += 1;
    }
}

size_t k_find_u8(const uint8_t *a, size_t n, uint8_t v)
{
    size_t i = 0;
    for (; i < n; i += 1)
    {
        if (a[i] == v)
        {
            break;
        }
    }
    return i;
}

uint32_t k_crc32_table(const uint8_t *a, size_t n, const uint32_t *t)
{
    uint32_t c = 0xffffffffu;
    for (size_t i = 0; i < n; i += 1)
    {
        c = t[(c ^ a[i]) & 0xff] ^ (c >> 8);
    }
    return ~c;
}

uint32_t k_fnv1a(const uint8_t *a, size_t n)
{
    uint32_t h = 2166136261u;
    for (size_t i = 0; i < n; i += 1)
    {
        h = (h ^ a[i]) * 16777619u;
    }
    return h;
}
