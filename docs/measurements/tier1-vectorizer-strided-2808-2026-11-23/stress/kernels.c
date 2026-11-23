// Stress kernels for #3321's vectorizer rules. Built twice: by buster (P = v_) and by clang -O0 (P = r_).
#include <stddef.h>
#include <stdint.h>
#define CAT2(a, b) a##b
#define CAT(a, b) CAT2(a, b)
#define K(name) CAT(P, name)

size_t K(count_eq_u8)(const uint8_t* a, size_t n, uint8_t v) { size_t c = 0; for (size_t i = 0; i < n; i++) c += a[i] == v; return c; }
int K(count_gt_i32)(const int32_t* a, int n, int v) { int c = 0; for (int i = 0; i < n; i++) c += a[i] > v; return c; }
int K(count_lt_i8)(const int8_t* a, int n, int8_t v) { int c = 0; for (int i = 0; i < n; i++) c += a[i] < v; return c; }
size_t K(count_ge_u16)(const uint16_t* a, unsigned n, uint16_t v) { size_t c = 0; for (unsigned i = 0; i < n; i++) c += a[i] >= v; return c; }
int K(count_ne_i64)(const int64_t* a, long n, int64_t v) { int c = 0; for (long i = 0; i < n; i++) c += a[i] != v; return c; }
int K(count_two)(const uint8_t* a, const uint8_t* b, int n) { int c = 0; for (int i = 0; i < n; i++) c += a[i] < b[i]; return c; }
int K(count_sext_u8)(const uint8_t* a, int n) { int c = 0; for (int i = 0; i < n; i++) c += (int)a[i] > 200; return c; }
int K(count_mixed)(const int8_t* a, const uint8_t* b, int n) { int c = 0; for (int i = 0; i < n; i++) c += (int)a[i] < (int)b[i]; return c; }

typedef struct { int32_t x, y; } P2;
int K(aos_sum)(const P2* p, int n) { int s = 0; for (int i = 0; i < n; i++) s += p[i].x + p[i].y; return s; }
long K(aos_x)(const P2* p, long n) { long s = 0; for (long i = 0; i < n; i++) s += p[i].x; return s; }
void K(rgb_to_gray)(uint8_t* out, const uint8_t* rgb, int n) { for (int i = 0; i < n; i++) out[i] = (uint8_t)((rgb[3 * i] * 77 + rgb[3 * i + 1] * 150 + rgb[3 * i + 2] * 29) >> 8); }
void K(pairs_i16)(int16_t* out, const int16_t* in, int n) { for (int i = 0; i < n; i++) out[i] = (int16_t)(in[2 * i] - in[2 * i + 1]); }
int K(stride8_u8)(const uint8_t* a, int n) { int s = 0; for (int i = 0; i < n; i++) s += a[8 * i + 7]; return s; }
long K(stride8_i64)(const int64_t* a, long n) { long s = 0; for (long i = 0; i < n; i++) s += a[8 * i]; return s; }
int K(stride5_i32)(const int32_t* a, int n) { int s = 0; for (int i = 0; i < n; i++) s ^= a[5 * i + 4]; return s; }
int K(stride3_u16)(const uint16_t* a, int n) { int s = 0; for (int i = 0; i < n; i++) s += a[3 * i + 2]; return s; }
int K(stride9_u8)(const uint8_t* a, int n) { int s = 0; for (int i = 0; i < n; i++) s += a[9 * i]; return s; }
int K(neg_stride)(const int32_t* a, int n) { int s = 0; for (int i = 0; i < n; i++) s += a[-2 * i]; return s; }
int K(neg_stride_u8)(const uint8_t* a, int n) { int s = 0; for (int i = 0; i < n; i++) s += a[-3 * i]; return s; }
int K(ptr_stride)(const int16_t* p, int n) { int s = 0; for (int i = 0; i < n; i++, p += 4) s += p[1]; return s; }
void K(strided_store)(int32_t* out, const int32_t* in, int n) { for (int i = 0; i < n; i++) out[2 * i] = in[i]; }
void K(gather_add)(int32_t* out, const int32_t* in, int n) { for (int i = 0; i < n; i++) out[i] = in[2 * i] + in[2 * i + 1] + out[i]; }
// 32-bit indices: signed (wraps under -fwrapv) and unsigned.
int K(idx_s32)(const uint8_t* a, int lo, int hi) { int s = 0; for (int i = lo; i < hi; i++) s += a[3 * i + 1]; return s; }
int K(idx_u32)(const uint8_t* a, unsigned lo, unsigned hi) { int s = 0; for (unsigned i = lo; i < hi; i++) s += a[3u * i + 1u]; return s; }
int K(idx_u32_i32)(const int32_t* a, unsigned lo, unsigned hi) { int s = 0; for (unsigned i = lo; i < hi; i++) s += a[2u * i + 5u]; return s; }
int K(idx_s32_neg)(const uint8_t* a, int lo, int hi) { int s = 0; for (int i = lo; i < hi; i++) s += a[-2 * i + 7]; return s; }
void K(idx_copy_u32)(uint8_t* o, const uint8_t* a, unsigned lo, unsigned hi) { for (unsigned i = lo; i < hi; i++) o[i - lo] = a[2u * i]; }
