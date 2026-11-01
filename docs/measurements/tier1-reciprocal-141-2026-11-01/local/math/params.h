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

