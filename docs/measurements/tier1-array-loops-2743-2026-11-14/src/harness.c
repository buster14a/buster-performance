/* Harness for the array-loop kernels. Always built by clang -O2; the kernels' unit is the
   compiler under test's. Usage: harness NAME REPS   (REPS 0 calibrates to about 40 ms)
   Prints: name elements reps seconds ns_per_element digest */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "kernels.h"

enum
{
    BYTES = 8192,
    N_U8 = BYTES,
    N_I16 = BYTES / 2,
    N_I32 = BYTES / 4,
    N_U64 = BYTES / 8,
    N_AOS = BYTES / 16,
    N_RGB = 2730,
    N_MAT = 32,
};

static uint8_t *a8, *b8, *d8, *f8, *rgb8, *g8;
static int16_t *a16, *b16;
static int32_t *a32, *b32, *d32, *p32;
static uint64_t *a64;
static float *af, *bf, *df, *yf, *ma, *mb, *mc;
static Particle *aos;
static uint32_t hist[256];
static uint32_t crc_table[256];
static uint32_t *du32;

static uint64_t rng_state;
static uint64_t rng(void)
{
    uint64_t x = rng_state;
    x ^= x >> 12;
    x ^= x << 25;
    x ^= x >> 27;
    rng_state = x;
    return x * 0x2545F4914F6CDD1Dull;
}

static void *buffer(size_t bytes)
{
    void *p = aligned_alloc(64, (bytes + 63) & ~(size_t)63);
    if (!p)
    {
        abort();
    }
    return p;
}

static uint64_t digest_bytes(uint64_t h, const void *p, size_t bytes)
{
    const uint8_t *b = p;
    for (size_t i = 0; i < bytes; i += 1)
    {
        h = (h ^ b[i]) * 0x100000001B3ull;
    }
    return h;
}

static void initialize(void)
{
    rng_state = 0x9E3779B97F4A7C15ull;
    for (size_t i = 0; i < N_U8; i += 1)
    {
        a8[i] = (uint8_t)rng();
        b8[i] = (uint8_t)rng();
        d8[i] = 0;
        f8[i] = (uint8_t)(rng() % 200);
    }
    f8[N_U8 - 1] = 250;
    for (size_t i = 0; i < 3 * N_RGB; i += 1)
    {
        rgb8[i] = (uint8_t)rng();
    }
    memset(g8, 0, N_RGB);
    for (size_t i = 0; i < N_I16; i += 1)
    {
        a16[i] = (int16_t)(rng() % 2001) - 1000;
        b16[i] = (int16_t)(rng() % 2001) - 1000;
    }
    for (size_t i = 0; i < N_I32; i += 1)
    {
        a32[i] = (int32_t)(rng() >> 33) - (1 << 30);
        b32[i] = (int32_t)(rng() >> 33) - (1 << 30);
        d32[i] = 0;
        p32[i] = (int32_t)(rng() & 0xffff);
        af[i] = (float)(rng() % 2000) / 1000.0f - 1.0f;
        bf[i] = (float)(rng() % 2000) / 1000.0f - 1.0f;
        yf[i] = (float)(rng() % 2000) / 1000.0f - 1.0f;
        df[i] = 0.0f;
        du32[i] = 0;
    }
    for (size_t i = 0; i < N_U64; i += 1)
    {
        a64[i] = rng();
    }
    for (size_t i = 0; i < N_AOS; i += 1)
    {
        aos[i].x = (int32_t)(rng() >> 40) - (1 << 23);
        aos[i].y = (int32_t)rng();
        aos[i].w = (int32_t)(rng() % 1000);
        aos[i].pad = 0;
    }
    for (size_t i = 0; i < N_MAT * N_MAT; i += 1)
    {
        ma[i] = (float)(rng() % 2000) / 1000.0f - 1.0f;
        mb[i] = (float)(rng() % 2000) / 1000.0f - 1.0f;
        mc[i] = 0.0f;
    }
    memset(hist, 0, sizeof(hist));
    for (uint32_t i = 0; i < 256; i += 1)
    {
        uint32_t c = i;
        for (int k = 0; k < 8; k += 1)
        {
            c = (c >> 1) ^ (0xEDB88320u & (0u - (c & 1)));
        }
        crc_table[i] = c;
    }
}

static uint64_t bits_of_float(float f)
{
    uint32_t u;
    memcpy(&u, &f, sizeof(u));
    return u;
}

static uint64_t run_sum_i32(void) { return (uint64_t)k_sum_i32(a32, N_I32); }
static uint64_t run_sum_u8(void) { return k_sum_u8(a8, N_U8); }
static uint64_t run_dot_i16(void) { return k_dot_i16(a16, b16, N_I16); }
static uint64_t run_max_i32(void) { return (uint64_t)(int64_t)k_max_i32(a32, N_I32); }
static uint64_t run_count_eq_u8(void) { return k_count_eq_u8(a8, N_U8, 77); }
static uint64_t run_cond_sum_i32(void) { return (uint64_t)k_cond_sum_i32(a32, N_I32, 12345); }
static uint64_t run_popcount_u64(void) { return k_popcount_u64(a64, N_U64); }
static uint64_t run_aos_sum(void) { return (uint64_t)k_aos_sum(aos, N_AOS); }
static uint64_t run_add_i32(void) { k_add_i32(d32, a32, b32, N_I32); return 0; }
static uint64_t run_saxpy_f32(void) { k_saxpy_f32(yf, af, 0.001f, N_I32); return 0; }
static uint64_t run_scale_u8(void) { k_scale_u8(d8, a8, 181, N_U8); return 0; }
static uint64_t run_blend_u8(void) { k_blend_u8(d8, a8, b8, 77, N_U8); return 0; }
static uint64_t run_clamp_i32(void) { k_clamp_i32(d32, a32, -100000000, 100000000, N_I32); return 0; }
static uint64_t run_i32_to_f32(void) { k_i32_to_f32(df, a32, 0.5f, N_I32); return 0; }
static uint64_t run_fill_u32(void) { k_fill_u32(du32, 0xA5A5A5A5u, N_I32); return 0; }
static uint64_t run_copy_u8(void) { k_copy_u8(d8, a8, N_U8); return 0; }
static uint64_t run_stencil3_u8(void) { k_stencil3_u8(d8, a8, N_U8); return 0; }
static uint64_t run_rgb_to_gray(void) { k_rgb_to_gray(g8, rgb8, N_RGB); return 0; }
static uint64_t run_matmul_f32(void) { memset(mc, 0, N_MAT * N_MAT * sizeof(float)); k_matmul_f32(mc, ma, mb, N_MAT); return 0; }
static uint64_t run_dot_f32(void) { return bits_of_float(k_dot_f32(af, bf, N_I32)); }
static uint64_t run_prefix_sum_i32(void) { k_prefix_sum_i32(p32, N_I32); return 0; }
static uint64_t run_histogram_u8(void) { k_histogram_u8(hist, a8, N_U8); return 0; }
static uint64_t run_find_u8(void) { return k_find_u8(f8, N_U8, 250); }
static uint64_t run_crc32_table(void) { return k_crc32_table(a8, N_U8, crc_table); }
static uint64_t run_fnv1a(void) { return k_fnv1a(a8, N_U8); }

typedef struct Kernel
{
    const char *name;
    uint64_t (*run)(void);
    size_t elements;
} Kernel;

static const Kernel kernels[] =
{
    { "sum_i32", run_sum_i32, N_I32 },
    { "sum_u8", run_sum_u8, N_U8 },
    { "dot_i16", run_dot_i16, N_I16 },
    { "max_i32", run_max_i32, N_I32 },
    { "count_eq_u8", run_count_eq_u8, N_U8 },
    { "cond_sum_i32", run_cond_sum_i32, N_I32 },
    { "popcount_u64", run_popcount_u64, N_U64 },
    { "aos_sum", run_aos_sum, N_AOS },
    { "add_i32", run_add_i32, N_I32 },
    { "saxpy_f32", run_saxpy_f32, N_I32 },
    { "scale_u8", run_scale_u8, N_U8 },
    { "blend_u8", run_blend_u8, N_U8 },
    { "clamp_i32", run_clamp_i32, N_I32 },
    { "i32_to_f32", run_i32_to_f32, N_I32 },
    { "fill_u32", run_fill_u32, N_I32 },
    { "copy_u8", run_copy_u8, N_U8 },
    { "stencil3_u8", run_stencil3_u8, N_U8 - 2 },
    { "rgb_to_gray", run_rgb_to_gray, N_RGB },
    { "matmul_f32", run_matmul_f32, N_MAT * N_MAT * N_MAT },
    { "dot_f32", run_dot_f32, N_I32 },
    { "prefix_sum_i32", run_prefix_sum_i32, N_I32 - 1 },
    { "histogram_u8", run_histogram_u8, N_U8 },
    { "find_u8", run_find_u8, N_U8 },
    { "crc32_table", run_crc32_table, N_U8 },
    { "fnv1a", run_fnv1a, N_U8 },
};

static uint64_t digest_all(uint64_t h)
{
    h = digest_bytes(h, d8, N_U8);
    h = digest_bytes(h, g8, N_RGB);
    h = digest_bytes(h, d32, N_I32 * sizeof(int32_t));
    h = digest_bytes(h, p32, N_I32 * sizeof(int32_t));
    h = digest_bytes(h, df, N_I32 * sizeof(float));
    h = digest_bytes(h, yf, N_I32 * sizeof(float));
    h = digest_bytes(h, du32, N_I32 * sizeof(uint32_t));
    h = digest_bytes(h, mc, N_MAT * N_MAT * sizeof(float));
    h = digest_bytes(h, hist, sizeof(hist));
    return h;
}

static double now(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return (double)t.tv_sec + (double)t.tv_nsec * 1e-9;
}

static double time_reps(const Kernel *k, uint64_t reps)
{
    double start = now();
    for (uint64_t r = 0; r < reps; r += 1)
    {
        k->run();
    }
    return now() - start;
}

int main(int argc, char **argv)
{
    int result = 1;
    a8 = buffer(N_U8); b8 = buffer(N_U8); d8 = buffer(N_U8); f8 = buffer(N_U8);
    rgb8 = buffer(3 * N_RGB); g8 = buffer(N_RGB);
    a16 = buffer(BYTES); b16 = buffer(BYTES);
    a32 = buffer(BYTES); b32 = buffer(BYTES); d32 = buffer(BYTES); p32 = buffer(BYTES);
    a64 = buffer(BYTES); du32 = buffer(BYTES);
    af = buffer(BYTES); bf = buffer(BYTES); df = buffer(BYTES); yf = buffer(BYTES);
    ma = buffer(N_MAT * N_MAT * sizeof(float)); mb = buffer(N_MAT * N_MAT * sizeof(float)); mc = buffer(N_MAT * N_MAT * sizeof(float));
    aos = buffer(N_AOS * sizeof(Particle));
    if (argc == 2 && strcmp(argv[1], "list") == 0)
    {
        for (size_t i = 0; i < sizeof(kernels) / sizeof(kernels[0]); i += 1)
        {
            printf("%s\n", kernels[i].name);
        }
        result = 0;
    }
    else if (argc == 3)
    {
        const Kernel *k = 0;
        for (size_t i = 0; i < sizeof(kernels) / sizeof(kernels[0]); i += 1)
        {
            if (strcmp(kernels[i].name, argv[1]) == 0)
            {
                k = &kernels[i];
            }
        }
        if (k)
        {
            /* The digest: three calls from the initial state, the same for every build. */
            initialize();
            uint64_t h = 0xcbf29ce484222325ull;
            for (int r = 0; r < 3; r += 1)
            {
                uint64_t v = k->run();
                h = digest_bytes(h, &v, sizeof(v));
            }
            h = digest_all(h);
            initialize();
            uint64_t reps = strtoull(argv[2], 0, 10);
            double seconds = 0.0;
            if (reps == 0)
            {
                reps = 1;
                while ((seconds = time_reps(k, reps)) < 0.02 && reps < (1ull << 40))
                {
                    reps *= 2;
                }
                reps = (uint64_t)((double)reps * 0.04 / seconds) + 1;
                double best = 1e30;
                for (int sample = 0; sample < 7; sample += 1)
                {
                    seconds = time_reps(k, reps);
                    if (seconds < best)
                    {
                        best = seconds;
                    }
                }
                seconds = best;
            }
            else
            {
                seconds = time_reps(k, reps);
            }
            printf("%s %zu %llu %.6f %.4f %016llx\n", k->name, k->elements, (unsigned long long)reps, seconds, seconds * 1e9 / ((double)reps * (double)k->elements), (unsigned long long)h);
            result = 0;
        }
    }
    if (result)
    {
        fprintf(stderr, "usage: harness list | harness NAME REPS\n");
    }
    return result;
}
