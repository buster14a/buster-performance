// The math check behind buster#1001 (this record's, not part of buster): Granlund and Montgomery's CHOOSE_MULTIPLIER and the planned Tier 1 sequences,
// simulated with exact 32/64-bit register semantics, against C's division. Usage: magic_check [exhaustive]
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

typedef unsigned __int128 u128;

typedef struct { uint64_t multiplier; uint8_t pre; uint8_t post; bool add; } Reciprocal;

// floor((2^k + addend) / divisor) for k <= 128, addend < 2^127, divisor < 2^64.
static u128 quotient_power(uint32_t k, u128 addend, uint64_t divisor)
{
    u128 result;
    if (k < 128)
    {
        result = (((u128)1 << k) + addend) / divisor;
    }
    else
    {
        const u128 all = ~(u128)0;
        result = all / divisor + ((all % divisor) + 1 + addend) / divisor;
    }
    return result;
}

static u128 choose_multiplier(uint64_t divisor, uint32_t bits, uint32_t precision, uint32_t* post)
{
    const uint32_t l = 64 - (uint32_t)__builtin_clzll(divisor - 1);
    u128 low = quotient_power(bits + l, 0, divisor);
    u128 high = quotient_power(bits + l, (u128)1 << (bits + l - precision), divisor);
    uint32_t shift = l;
    while ((low >> 1) < (high >> 1) && shift > 0)
    {
        low >>= 1;
        high >>= 1;
        shift -= 1;
    }
    *post = shift;
    return high;
}

static bool power(uint64_t v) { return v != 0 && (v & (v - 1)) == 0; }

static uint64_t mask_of(uint32_t width) { return width == 8 ? UINT64_MAX : UINT32_MAX; }

static uint64_t magnitude(uint64_t divisor, uint32_t width)
{
    const uint32_t bits = width * 8;
    const uint64_t sign = UINT64_C(1) << (bits - 1);
    const int64_t value = (int64_t)(((divisor & mask_of(width)) ^ sign) - sign);
    return value < 0 ? (uint64_t)0 - (uint64_t)value : (uint64_t)value;
}

static bool eligible(uint64_t divisor, uint32_t width, bool is_signed)
{
    divisor &= mask_of(width);
    const uint64_t a = is_signed ? magnitude(divisor, width) : divisor;
    return is_signed ? (a >= 3 && !power(a)) : (divisor != 0 && !power(divisor));
}

static Reciprocal reciprocal(uint64_t divisor, uint32_t width, bool is_signed)
{
    const uint32_t bits = width * 8;
    Reciprocal r = {0};
    uint32_t post = 0;
    if (is_signed)
    {
        const u128 m = choose_multiplier(magnitude(divisor, width), bits, bits - 1, &post);
        if (m >= ((u128)1 << bits)) { fprintf(stderr, "signed m too large\n"); exit(2); }
        r.multiplier = (uint64_t)m & mask_of(width);
        r.add = m >= ((u128)1 << (bits - 1));
        r.post = (uint8_t)post;
    }
    else
    {
        divisor &= mask_of(width);
        u128 m = choose_multiplier(divisor, bits, bits, &post);
        if (m >= ((u128)1 << bits) && (divisor & 1) == 0)
        {
            const uint32_t e = (uint32_t)__builtin_ctzll(divisor);
            m = choose_multiplier(divisor >> e, bits, bits - e, &post);
            r.pre = (uint8_t)e;
            if (m >= ((u128)1 << bits)) { fprintf(stderr, "even retry m too large\n"); exit(2); }
        }
        r.add = m >= ((u128)1 << bits);
        if (r.add && post == 0) { fprintf(stderr, "add with post 0\n"); exit(2); }
        r.multiplier = (uint64_t)m & mask_of(width);
        r.post = (uint8_t)post;
    }
    return r;
}

// Register semantics: W-bit operations, zero-extending results.
static uint64_t hi_u(uint64_t a, uint64_t b, uint32_t width)
{
    return width == 8 ? (uint64_t)(((u128)a * b) >> 64) : ((a & UINT32_MAX) * (b & UINT32_MAX)) >> 32;
}

static uint64_t hi_s(uint64_t a, uint64_t b, uint32_t width)
{
    if (width == 8)
    {
        return (uint64_t)(((__int128)(int64_t)a * (int64_t)b) >> 64);
    }
    return (uint32_t)(((int64_t)(int32_t)a * (int32_t)b) >> 32);
}

static uint64_t sar(uint64_t a, uint32_t s, uint32_t width)
{
    return width == 8 ? (uint64_t)((int64_t)a >> s) : (uint32_t)((int32_t)a >> s);
}

// The planned sequence's value (the register semantics above), at the width's bits.
static uint64_t simulate(uint64_t divisor, uint32_t width, bool is_signed, bool remainder, uint64_t x)
{
    const uint32_t bits = width * 8;
    const uint64_t mask = mask_of(width);
    const Reciprocal r = reciprocal(divisor, width, is_signed);
    x &= mask;
    uint64_t rax = 0, rdx = 0, q = 0;
    if (!is_signed && r.pre > 0)
    {
        rax = (x >> r.pre) & mask;
        rdx = r.multiplier;
        rdx = hi_u(rax, rdx, width);
    }
    else
    {
        rax = r.multiplier;
        rdx = is_signed ? hi_s(rax, x, width) : hi_u(rax, x, width);
    }
    if (!is_signed)
    {
        if (r.add)
        {
            rax = (x - rdx) & mask;
            rax >>= 1;
            rax = (rax + rdx) & mask;
            if (r.post > 1) rax >>= (r.post - 1);
            q = rax;
        }
        else
        {
            if (r.post > 0) rdx >>= r.post;
            q = rdx;
        }
    }
    else
    {
        if (r.add) rdx = (rdx + x) & mask;
        if (r.post > 0) rdx = sar(rdx, r.post, width);
        rax = (rdx & mask) >> (bits - 1);
        rdx = (rdx + rax) & mask;
        const uint64_t sign = UINT64_C(1) << (bits - 1);
        const bool negative = ((divisor & mask) & sign) != 0;
        if (negative && !remainder) rdx = (0 - rdx) & mask;
        q = rdx;
    }
    if (remainder)
    {
        const uint64_t a = is_signed ? magnitude(divisor, width) : (divisor & mask);
        q = (q * a) & mask;
        q = (0 - q) & mask;
        q = (q + x) & mask;
    }
    return q & mask;
}

static uint64_t reference(uint64_t divisor, uint32_t width, bool is_signed, bool remainder, uint64_t x)
{
    const uint64_t mask = mask_of(width);
    x &= mask;
    divisor &= mask;
    if (width == 8)
    {
        if (is_signed)
        {
            const int64_t a = (int64_t)x, b = (int64_t)divisor;
            return (uint64_t)(remainder ? a % b : a / b);
        }
        return remainder ? x % divisor : x / divisor;
    }
    if (is_signed)
    {
        const int32_t a = (int32_t)(uint32_t)x, b = (int32_t)(uint32_t)divisor;
        return (uint32_t)(remainder ? a % b : a / b);
    }
    return (uint32_t)(remainder ? (uint32_t)x % (uint32_t)divisor : (uint32_t)x / (uint32_t)divisor);
}

static uint64_t failures;
static uint64_t checks;

static void check(uint64_t divisor, uint32_t width, bool is_signed, bool remainder, uint64_t x)
{
    checks += 1;
    const uint64_t got = simulate(divisor, width, is_signed, remainder, x);
    const uint64_t want = reference(divisor, width, is_signed, remainder, x);
    if (got != want)
    {
        if (failures < 20)
        {
            fprintf(stderr, "FAIL w=%u s=%d r=%d d=%016llx x=%016llx got=%016llx want=%016llx\n", width, is_signed, remainder, (unsigned long long)divisor, (unsigned long long)x,
                    (unsigned long long)got, (unsigned long long)want);
        }
        failures += 1;
    }
}

static uint64_t rng = 0x9e3779b97f4a7c15ull;
static uint64_t next(void) { rng ^= rng << 13; rng ^= rng >> 7; rng ^= rng << 17; return rng; }

static void edges(uint64_t divisor, uint32_t width)
{
    const uint64_t mask = mask_of(width);
    const uint32_t bits = width * 8;
    const uint64_t sign = UINT64_C(1) << (bits - 1);
    for (uint32_t s = 0; s < 2; s += 1)
    {
        if (!eligible(divisor, width, s != 0)) continue;
        const uint64_t a = s ? magnitude(divisor, width) : divisor & mask;
        uint64_t xs[40];
        uint32_t n = 0;
        xs[n++] = 0; xs[n++] = 1; xs[n++] = mask; xs[n++] = mask - 1; xs[n++] = sign; xs[n++] = sign - 1; xs[n++] = sign + 1;
        xs[n++] = a; xs[n++] = a - 1; xs[n++] = a + 1; xs[n++] = 0 - a; xs[n++] = 1 - a; xs[n++] = 0 - a - 1;
        const uint64_t k = (s ? (sign - 1) : mask) / a;
        xs[n++] = k * a; xs[n++] = k * a - 1; xs[n++] = k * a + 1; xs[n++] = 0 - k * a; xs[n++] = 1 - k * a; xs[n++] = 0 - k * a - 1;
        xs[n++] = (k - 1) * a; xs[n++] = (k - 1) * a - 1; xs[n++] = 0 - (k - 1) * a + 1;
        for (uint32_t i = 0; i < 12; i += 1) xs[n++] = next();
        for (uint32_t i = 0; i < n; i += 1)
        {
            check(divisor, width, s != 0, false, xs[i]);
            check(divisor, width, s != 0, true, xs[i]);
        }
    }
}

typedef struct { uint64_t divisor; bool is_signed; uint64_t first; uint64_t end; uint64_t failures; } Slice;

static void* exhaustive_slice(void* argument)
{
    Slice* slice = argument;
    for (uint64_t x = slice->first; x < slice->end; x += 1)
    {
        const uint64_t got = simulate(slice->divisor, 4, slice->is_signed, false, x);
        const uint64_t want = reference(slice->divisor, 4, slice->is_signed, false, x);
        if (got != want)
        {
            if (slice->failures < 5)
            {
                fprintf(stderr, "EXHAUSTIVE FAIL s=%d d=%08llx x=%08llx got=%08llx want=%08llx\n", slice->is_signed, (unsigned long long)slice->divisor, (unsigned long long)x,
                        (unsigned long long)got, (unsigned long long)want);
            }
            slice->failures += 1;
        }
    }
    return 0;
}

int main(int argc, char** argv)
{
    const bool exhaustive = argc > 1 && strcmp(argv[1], "exhaustive") == 0;
    // Every divisor to 2^16 at both widths, with edges.
    for (uint64_t d = 2; d <= 65536; d += 1)
    {
        edges(d, 4);
        edges(d, 8);
        edges(0 - d, 4);
        edges(0 - d, 8);
    }
    // Large and random divisors.
    const uint64_t specials[] = { 0x7fffffffu, 0x80000001u, 0xffffffffu, 0xfffffffeu, 0xfffffffdu, 0x7ffffffeu, 0x55555555u, 0xaaaaaaabu, 0xc0000000u + 3, 0x40000001u,
                                  UINT64_C(0x7fffffffffffffff), UINT64_C(0x8000000000000001), UINT64_MAX, UINT64_MAX - 1, UINT64_MAX - 2, UINT64_C(0x5555555555555555),
                                  UINT64_C(0xaaaaaaaaaaaaaaab), UINT64_C(0x100000001), UINT64_C(0xffffffff00000001), UINT64_C(3) << 61, (UINT64_C(3) << 61) + 1,
                                  UINT64_C(0x8000000000000003), UINT64_C(0xc000000000000001), 1000000007, UINT64_C(1000000000000000003), 10, 100, 1000, 641, 6700417 };
    for (uint32_t i = 0; i < sizeof(specials) / sizeof(specials[0]); i += 1)
    {
        for (uint32_t r = 0; r < 64; r += 1)
        {
            edges(specials[i], 4);
            edges(specials[i], 8);
            edges(0 - specials[i], 8);
        }
    }
    for (uint32_t i = 0; i < 2000000; i += 1)
    {
        const uint64_t v = next();
        const uint32_t shift = (uint32_t)(next() % 64);
        edges(v >> shift, 4);
        edges(v >> shift, 8);
    }
    printf("edges: %llu checks, %llu failures\n", (unsigned long long)checks, (unsigned long long)failures);
    if (exhaustive)
    {
        const uint64_t divisors[] = { 3, 5, 6, 7, 10, 12, 14, 25, 641, 0x7fffffff, 0x80000001u, 0xfffffffeu, 0xffffffffu, 0xfffffff9u /* -7 */, 0xfffffffdu /* -3 */, 0xfffffff6u /* -10 */ };
        for (uint32_t i = 0; i < sizeof(divisors) / sizeof(divisors[0]); i += 1)
        {
            for (uint32_t s = 0; s < 2; s += 1)
            {
                if (!eligible(divisors[i], 4, s != 0)) continue;
                pthread_t threads[4];
                Slice slices[4];
                for (uint32_t t = 0; t < 4; t += 1)
                {
                    slices[t] = (Slice){ divisors[i], s != 0, (UINT64_C(1) << 32) / 4 * t, (UINT64_C(1) << 32) / 4 * (t + 1), 0 };
                    pthread_create(&threads[t], 0, exhaustive_slice, &slices[t]);
                }
                uint64_t total = 0;
                for (uint32_t t = 0; t < 4; t += 1)
                {
                    pthread_join(threads[t], 0);
                    total += slices[t].failures;
                }
                printf("exhaustive d=%08llx signed=%u: %llu failures\n", (unsigned long long)divisors[i], s, (unsigned long long)total);
                failures += total;
            }
        }
    }
    return failures != 0;
}
