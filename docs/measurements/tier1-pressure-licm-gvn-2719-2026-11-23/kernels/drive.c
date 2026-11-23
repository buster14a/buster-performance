#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "kernels.h"
void x_rows_sum(int32_t *d, const int32_t *s, int w, int h);
void x_affine(int32_t *d, const int32_t *a, int x, int y, int z, int n);
int64_t x_window(const int32_t *a, int n, int k);
void x_transpose(int32_t *d, const int32_t *s, int n);
uint32_t x_mix(const uint32_t *a, int n, uint32_t seed, uint32_t mul);
#define N 2048
static int32_t A[N], B[N], D[N]; static uint8_t U[N], V[N], W8[N * 3]; static float F[N], G[N], H[N]; static uint64_t Q[N / 8]; static uint32_t T[256], HI[256]; static Particle P[N / 4];
int main(int argc, char **argv)
{
    int reps = argc > 1 ? 200 : 200;
    uint64_t digest = 0;
    for (int i = 0; i < N; i++) { A[i] = i * 7 - 300; B[i] = (i * 13) % 97; U[i] = (uint8_t)(i * 31); V[i] = (uint8_t)(i * 17); F[i] = (float)(i % 13) * 0.5f; G[i] = (float)(i % 7); }
    for (int i = 0; i < N * 3; i++) W8[i] = (uint8_t)(i * 5);
    for (int i = 0; i < N / 8; i++) Q[i] = 0x9e3779b97f4a7c15ull * (i + 1);
    for (int i = 0; i < 256; i++) T[i] = i * 0x01000193u;
    for (int i = 0; i < N / 4; i++) { P[i].x = i; P[i].y = -i; P[i].w = i & 3; }
    for (int r = 0; r < reps; r++)
    {
        digest += k_sum_i32(A, N) + k_sum_u8(U, N) + k_dot_i16((int16_t *)A, (int16_t *)B, N) + k_max_i32(A, N) + k_count_eq_u8(U, N, 7) + k_cond_sum_i32(A, N, 100) + k_popcount_u64(Q, N / 8) + k_aos_sum(P, N / 4);
        k_add_i32(D, A, B, N); k_saxpy_f32(H, F, 1.5f, N); k_scale_u8(V, U, 3, N); k_blend_u8(V, U, V, 77, N); k_clamp_i32(D, A, -50, 900, N); k_i32_to_f32(H, A, 0.25f, N); k_fill_u32((uint32_t *)D, 5, N); k_copy_u8(V, U, N); k_stencil3_u8(V, U, N); k_rgb_to_gray(V, W8, N);
        if (r % 8 == 0) k_matmul_f32(H, F, G, 40);
        digest += (uint64_t)k_dot_f32(F, G, N); k_prefix_sum_i32(D, N); k_histogram_u8(HI, U, N); digest += k_find_u8(U, N, 255) + k_crc32_table(U, N, T) + k_fnv1a(U, N);
        x_rows_sum(D, A, 64, 32); x_affine(D, A, 3, 5, 7, N); digest += x_window(A, N, 9); x_transpose(D, A, 45); digest += x_mix((uint32_t *)A, N, 12345, 0x01000193u);
        digest += D[r % N] + V[r % N] + (uint64_t)H[r % N];
    }
    printf("%llu\n", (unsigned long long)digest);
    return 0;
}
