#ifndef KERNELS_H
#define KERNELS_H
#include <stddef.h>
#include <stdint.h>

typedef struct Particle
{
    int32_t x;
    int32_t y;
    int32_t w;
    int32_t pad;
} Particle;

/* Loops clang -O2 vectorizes. */
int64_t k_sum_i32(const int32_t *a, size_t n);
uint32_t k_sum_u8(const uint8_t *a, size_t n);
uint32_t k_dot_i16(const int16_t *a, const int16_t *b, size_t n);
int32_t k_max_i32(const int32_t *a, size_t n);
size_t k_count_eq_u8(const uint8_t *a, size_t n, uint8_t v);
int64_t k_cond_sum_i32(const int32_t *a, size_t n, int32_t t);
uint64_t k_popcount_u64(const uint64_t *a, size_t n);
int64_t k_aos_sum(const Particle *p, size_t n);
void k_add_i32(int32_t *d, const int32_t *a, const int32_t *b, size_t n);
void k_saxpy_f32(float *y, const float *x, float k, size_t n);
void k_scale_u8(uint8_t *d, const uint8_t *s, unsigned k, size_t n);
void k_blend_u8(uint8_t *d, const uint8_t *a, const uint8_t *b, unsigned alpha, size_t n);
void k_clamp_i32(int32_t *d, const int32_t *a, int lo, int hi, int n);
void k_i32_to_f32(float *d, const int32_t *a, float k, size_t n);
void k_fill_u32(uint32_t *d, uint32_t v, size_t n);
void k_copy_u8(uint8_t *d, const uint8_t *s, size_t n);
void k_stencil3_u8(uint8_t *d, const uint8_t *s, size_t n);
void k_rgb_to_gray(uint8_t *g, const uint8_t *rgb, int n);
void k_matmul_f32(float *c, const float *a, const float *b, size_t n);

/* Loops clang -O2 leaves scalar: the controls for scalar loop quality. */
float k_dot_f32(const float *a, const float *b, size_t n);
void k_prefix_sum_i32(int32_t *a, size_t n);
void k_histogram_u8(uint32_t *h, const uint8_t *a, size_t n);
size_t k_find_u8(const uint8_t *a, size_t n, uint8_t v);
uint32_t k_crc32_table(const uint8_t *a, size_t n, const uint32_t *t);
uint32_t k_fnv1a(const uint8_t *a, size_t n);
#endif
