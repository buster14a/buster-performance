#define CAT2(a, b) a##b
#define CAT(a, b) CAT2(a, b)
#define K(name) CAT(P, name)
// Differential driver: v_ (buster +vectorize) against r_ (clang -O0), inputs placed against PROT_NONE pages.
#include <stdint.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
typedef struct { int32_t x, y; } P2;
#define P v_
#include "protos.inc"
#undef P
#define P r_
#include "protos.inc"
#undef P

static uint64_t seed = 88172645463325252ull;
static uint8_t rnd(void) { seed ^= seed << 13; seed ^= seed >> 7; seed ^= seed << 17; return (uint8_t)(seed >> 24); }
static long checks;
static long failures;
#define PAGE 4096
#define ARENA (64 * PAGE)
static uint8_t* arena;
// A buffer of `bytes` ending at the guard page after the arena (end = 1), or starting at the arena's first byte after
// the guard before it (end = 0), shifted by `mis` bytes inward.
static uint8_t* place(size_t bytes, int end, size_t mis)
{
    uint8_t* p = end ? arena + ARENA - bytes - mis : arena + mis;
    return p;
}
static void fill(uint8_t* p, size_t bytes, int small)
{
    for (size_t i = 0; i < bytes; i++) p[i] = small ? (uint8_t)(rnd() % 5) : rnd();
}
static void fail(const char* k, long n, long mis, long extra, long long a, long long b)
{
    failures++;
    if (failures < 40) printf("FAIL %s n=%ld mis=%ld extra=%ld got=%lld want=%lld\n", k, n, mis, extra, a, b);
}
#define CHECK(name, got, want, n, mis, extra) do { long long g_ = (long long)(got), w_ = (long long)(want); checks++; if (g_ != w_) fail(name, n, mis, extra, g_, w_); } while (0)

static void reads(long n, size_t mis)
{
    for (int small = 0; small < 2; small++)
    {
        uint8_t* a; uint8_t* b; size_t bytes;
        bytes = (size_t)n; a = place(bytes, 1, mis); fill(a, bytes, small);
        uint8_t v = small ? 2 : (n ? a[n / 2] : 9);
        CHECK("count_eq_u8", v_count_eq_u8(a, n, v), r_count_eq_u8(a, n, v), n, mis, small);
        CHECK("count_sext_u8", v_count_sext_u8(a, n), r_count_sext_u8(a, n), n, mis, small);
        CHECK("count_lt_i8", v_count_lt_i8((int8_t*)a, n, (int8_t)v), r_count_lt_i8((int8_t*)a, n, (int8_t)v), n, mis, small);
        b = place(bytes, 0, mis); fill(b, bytes, small);
        CHECK("count_two", v_count_two(a, b, n), r_count_two(a, b, n), n, mis, small);
        CHECK("count_mixed", v_count_mixed((int8_t*)a, b, n), r_count_mixed((int8_t*)a, b, n), n, mis, small);
        CHECK("count_two_same", v_count_two(a, a, n), r_count_two(a, a, n), n, mis, small);
        bytes = 4 * (size_t)n; a = place(bytes, 1, mis); fill(a, bytes, small);
        CHECK("count_gt_i32", v_count_gt_i32((int32_t*)(void*)a, n, 1), r_count_gt_i32((int32_t*)(void*)a, n, 1), n, mis, small);
        bytes = 2 * (size_t)n; a = place(bytes, 1, mis); fill(a, bytes, small);
        CHECK("count_ge_u16", v_count_ge_u16((uint16_t*)(void*)a, n, 300), r_count_ge_u16((uint16_t*)(void*)a, n, 300), n, mis, small);
        bytes = 8 * (size_t)n; a = place(bytes, 1, mis); fill(a, bytes, small);
        CHECK("count_ne_i64", v_count_ne_i64((int64_t*)(void*)a, n, 0), r_count_ne_i64((int64_t*)(void*)a, n, 0), n, mis, small);
        CHECK("aos_sum", v_aos_sum((P2*)(void*)a, n), r_aos_sum((P2*)(void*)a, n), n, mis, small);
        CHECK("aos_x", v_aos_x((P2*)(void*)a, n), r_aos_x((P2*)(void*)a, n), n, mis, small);
        // Strided: exact lengths of the last element read, against the guard page.
        bytes = n ? 8 * (size_t)(n - 1) + 8 : 0; a = place(bytes, 1, mis); fill(a, bytes, small);
        CHECK("stride8_u8", v_stride8_u8(a, n), r_stride8_u8(a, n), n, mis, small);
        bytes = n ? 64 * (size_t)(n - 1) + 8 : 0; if (bytes + 64 < ARENA) { a = place(bytes, 1, mis); fill(a, bytes, small);
        CHECK("stride8_i64", v_stride8_i64((int64_t*)(void*)a, n), r_stride8_i64((int64_t*)(void*)a, n), n, mis, small); }
        bytes = n ? 4 * (5 * (size_t)(n - 1) + 5) : 0; a = place(bytes, 1, mis); fill(a, bytes, small);
        CHECK("stride5_i32", v_stride5_i32((int32_t*)(void*)a, n), r_stride5_i32((int32_t*)(void*)a, n), n, mis, small);
        bytes = n ? 2 * (3 * (size_t)(n - 1) + 3) : 0; a = place(bytes, 1, mis); fill(a, bytes, small);
        CHECK("stride3_u16", v_stride3_u16((uint16_t*)(void*)a, n), r_stride3_u16((uint16_t*)(void*)a, n), n, mis, small);
        bytes = n ? 9 * (size_t)(n - 1) + 1 : 0; a = place(bytes, 1, mis); fill(a, bytes, small);
        CHECK("stride9_u8", v_stride9_u8(a, n), r_stride9_u8(a, n), n, mis, small);
        bytes = n ? 2 * (4 * (size_t)(n - 1) + 2) : 0; a = place(bytes, 1, mis); fill(a, bytes, small);
        CHECK("ptr_stride", v_ptr_stride((int16_t*)(void*)a, n), r_ptr_stride((int16_t*)(void*)a, n), n, mis, small);
        // Negative strides: the lowest element read starts right after the guard page before the arena.
        bytes = n ? 4 * (2 * (size_t)(n - 1) + 1) : 0; a = place(bytes, 0, mis); fill(a, bytes, small);
        if (n) CHECK("neg_stride", v_neg_stride((int32_t*)(void*)(a + bytes - 4), n), r_neg_stride((int32_t*)(void*)(a + bytes - 4), n), n, mis, small);
        bytes = n ? 3 * (size_t)(n - 1) + 1 : 0; a = place(bytes, 0, mis); fill(a, bytes, small);
        if (n) CHECK("neg_stride_u8", v_neg_stride_u8(a + bytes - 1, n), r_neg_stride_u8(a + bytes - 1, n), n, mis, small);
        // Non-wrapping 32-bit indices, the low bound negative for the signed ones.
        for (int lo = -3; lo <= 2; lo += 5)
        {
            int hi = lo + (int)n;
            long first = 3L * lo + 1, last = 3L * (hi - 1) + 1;
            if (n) { bytes = (size_t)(last - first + 1); a = place(bytes, 1, mis); fill(a, bytes, small);
                CHECK("idx_s32", v_idx_s32(a - first, lo, hi), r_idx_s32(a - first, lo, hi), n, mis, lo); }
            first = -2L * (hi - 1) + 7; last = -2L * lo + 7;
            if (n) { bytes = (size_t)(last - first + 1); a = place(bytes, 1, mis); fill(a, bytes, small);
                CHECK("idx_s32_neg", v_idx_s32_neg(a - first, lo, hi), r_idx_s32_neg(a - first, lo, hi), n, mis, lo); }
        }
        for (unsigned lo = 0; lo <= 9; lo += 9)
        {
            unsigned hi = lo + (unsigned)n;
            if (n) { bytes = 3 * (size_t)(hi - 1) + 2; a = place(bytes, 1, mis); fill(a, bytes, small);
                CHECK("idx_u32", v_idx_u32(a, lo, hi), r_idx_u32(a, lo, hi), n, mis, lo);
                bytes = 4 * (2 * (size_t)(hi - 1) + 6); a = place(bytes, 1, mis); fill(a, bytes, small);
                CHECK("idx_u32_i32", v_idx_u32_i32((int32_t*)(void*)a, lo, hi), r_idx_u32_i32((int32_t*)(void*)a, lo, hi), n, mis, lo); }
        }
    }
}

// Stores: out at every offset from in within +-off bytes, results compared byte for byte.
static uint8_t ref[ARENA];
static void writes(long n, size_t mis)
{
    for (long off = -24; off <= 24; off++)
    {
        size_t in_bytes = 3 * (size_t)n, span = in_bytes + 64;
        uint8_t* base = place(span + 48, 1, mis);
        uint8_t* in = base + 24;
        uint8_t* out = in + off;
        fill(base, span + 48, 0); memcpy(ref, base, span + 48);
        v_rgb_to_gray(out, in, n);
        uint8_t* rbase = ref; r_rgb_to_gray(ref + 24 + off, ref + 24, n);
        checks++; if (memcmp(base, rbase, span + 48)) fail("rgb_to_gray", n, mis, off, 0, 1);
        fill(base, span + 48, 0); memcpy(ref, base, span + 48);
        v_pairs_i16((int16_t*)(void*)(in + 2 * (off / 2)), (int16_t*)(void*)in, (int)n / 2);
        r_pairs_i16((int16_t*)(void*)(ref + 24 + 2 * (off / 2)), (int16_t*)(void*)(ref + 24), (int)n / 2);
        checks++; if (memcmp(base, ref, span + 48)) fail("pairs_i16", n, mis, off, 0, 1);
        fill(base, span + 48, 0); memcpy(ref, base, span + 48);
        v_strided_store((int32_t*)(void*)(in + 4 * (off / 4)), (int32_t*)(void*)in, (int)n / 3);
        r_strided_store((int32_t*)(void*)(ref + 24 + 4 * (off / 4)), (int32_t*)(void*)(ref + 24), (int)n / 3);
        checks++; if (memcmp(base, ref, span + 48)) fail("strided_store", n, mis, off, 0, 1);
        fill(base, span + 48, 0); memcpy(ref, base, span + 48);
        v_gather_add((int32_t*)(void*)(in + 4 * (off / 4)), (int32_t*)(void*)in, (int)n / 3);
        r_gather_add((int32_t*)(void*)(ref + 24 + 4 * (off / 4)), (int32_t*)(void*)(ref + 24), (int)n / 3);
        checks++; if (memcmp(base, ref, span + 48)) fail("gather_add", n, mis, off, 0, 1);
    }
}

// Wrapping 32-bit indices over a large NORESERVE mapping; only the windows read are filled.
static void wraps(void)
{
    size_t big = (size_t)17 << 30;
    uint8_t* m = mmap(0, big, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
    if (m == MAP_FAILED) { printf("SKIP wraps: no 17 GiB mapping\n"); return; }
    for (long n = 0; n <= 300; n++)
    {
        for (long back = 0; back <= n + 2; back += (back < 70 ? 1 : 37))
        {
            // unsigned 3u*i+1 over u8: wraps at i = 0x55555555 + ...
            unsigned lo = 0x55555555u - (unsigned)back, hi = lo + (unsigned)n;
            fill(m, 2048, 0); fill(m + ((size_t)1 << 32) - 2048, 2048, 0);
            CHECK("wrap idx_u32", v_idx_u32(m, lo, hi), r_idx_u32(m, lo, hi), n, 0, back);
            // unsigned 2u*i+5 over i32: indices up to 2^32 elements (16 GiB)
            lo = 0x7FFFFFFDu - (unsigned)back; hi = lo + (unsigned)n;
            fill(m, 4096, 0); fill(m + ((size_t)16 << 30) - 4096, 4096, 0);
            CHECK("wrap idx_u32_i32", v_idx_u32_i32((int32_t*)(void*)m, lo, hi), r_idx_u32_i32((int32_t*)(void*)m, lo, hi), n, 0, back);
            // signed 3*i+1 under -fwrapv: from near INT_MAX to near INT_MIN; a in the middle of 4 GiB.
            uint8_t* a = m + ((size_t)1 << 31) + 4096;
            int slo = 0x2AAAAAAA - (int)back, shi = slo + (int)n;
            fill(a + 0x7FFFF000L, 8192, 0); fill(a - 0x80000000L, 8192, 0);
            CHECK("wrap idx_s32", v_idx_s32(a, slo, shi), r_idx_s32(a, slo, shi), n, 0, back);
            // signed -2*i+7: i near INT_MIN/2 wraps
            slo = -0x40000000 + 4 - (int)back; shi = slo + (int)n;
            fill(a + 0x7FFFE000L, 8192, 0); fill(a - 0x80000000L, 8192, 0);
            CHECK("wrap idx_s32_neg", v_idx_s32_neg(a, slo, shi), r_idx_s32_neg(a, slo, shi), n, 0, back);
            // store of a wrapping unsigned load index
            static uint8_t o1[400], o2[400];
            lo = 0x80000000u - (unsigned)back; hi = lo + (unsigned)n;
            fill(m, 2048, 0); fill(m + ((size_t)1 << 32) - 2048, 2048, 0);
            memset(o1, 7, sizeof o1); memset(o2, 7, sizeof o2);
            v_idx_copy_u32(o1, m, lo, hi); r_idx_copy_u32(o2, m, lo, hi);
            checks++; if (memcmp(o1, o2, sizeof o1)) fail("wrap idx_copy_u32", n, 0, back, 0, 1);
        }
    }
    munmap(m, big);
}

int main(void)
{
    uint8_t* region = mmap(0, ARENA + 2 * PAGE, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    arena = region + PAGE;
    mprotect(arena, ARENA, PROT_READ | PROT_WRITE);
    for (long n = 0; n <= 300; n++)
        for (size_t mis = 0; mis < 9; mis += (mis < 4 ? 1 : 4))
            reads(n, mis);
    for (long n = 301; n < 2100; n += 97) reads(n, 1);
    for (long n = 0; n <= 200; n++) writes(n, n % 5);
    wraps();
    printf("%ld checks, %ld failures\n", checks, failures);
    return failures != 0;
}
