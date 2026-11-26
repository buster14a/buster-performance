// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.

#define BUSTER_TIER0_TEST_UNSIGNED_VALUES 22
#define BUSTER_TIER0_TEST_UNSIGNED_FLAGS (_MM_EXCEPT_INVALID | _MM_EXCEPT_INEXACT)
// MXCSR's four rounding modes: to nearest, down, up and toward zero.
#define BUSTER_TIER0_TEST_UNSIGNED_MODES 4

// C's conversion of value v for signature `signature` (tier0_test_unsigned_floating's order) under the rounding mode MXCSR
// holds, as clang compiles it: its bits into *bits, and the flags it raised returned. The oracle, out of line, with the
// floating environment's accesses kept in order and its rounding mode honored.
static __attribute__((noinline)) uint32_t tier0_test_unsigned_oracle(uint32_t signature, uint64_t integer, double d, float f, uint64_t* bits)
{
#pragma STDC FENV_ACCESS ON
    volatile uint64_t integer_in = integer;
    volatile double double_in = d;
    volatile float float_in = f;
    _mm_setcsr(_mm_getcsr() & ~(uint32_t)_MM_EXCEPT_MASK);
    uint64_t result = 0;
    if (signature == 0)
    {
        volatile double out = (double)integer_in;
        const double value = out;
        memcpy(&result, &value, sizeof(value));
    }
    else if (signature == 1)
    {
        volatile float out = (float)integer_in;
        const float value = out;
        uint32_t low = 0;
        memcpy(&low, &value, sizeof(value));
        result = low;
    }
    else if (signature == 2)
    {
        volatile uint64_t out = (uint64_t)double_in;
        result = out;
    }
    else
    {
        volatile uint64_t out = (uint64_t)float_in;
        result = out;
    }
    const uint32_t flags = _mm_getcsr() & BUSTER_TIER0_TEST_UNSIGNED_FLAGS;
    *bits = result;
    return flags;
}

// The named values, of each signature's operand class.
static const uint64_t tier0_test_unsigned_integers[BUSTER_TIER0_TEST_UNSIGNED_VALUES] = {
    0, 1, (1ull << 53) - 1, (1ull << 53) + 1, (1ull << 53) + 3, 1ull << 62, (1ull << 63) - 1, 1ull << 63, (1ull << 63) + 1,
    0x8000000000000400ull, 0x8000000000000401ull, 0x8000000000000c00ull, 0x8000008000000000ull, 0x8000008000000001ull,
    0xfffffffffffffbffull, 0xfffffffffffffc00ull, 0xffffff7fffffffffull, 0xffffff8000000000ull, UINT64_MAX, 0x0123456789abcdefull,
    0x8000000000000c01ull, 0x10000000000003ffull,
};
static const double tier0_test_unsigned_doubles[BUSTER_TIER0_TEST_UNSIGNED_VALUES] = {
    0.0, 0.5, 1.0, 1.75, 4503599627370497.0, 0x1p62, 0x1p63 - 1024.0, 0x1p63, 0x1p63 + 2048.0, 0x1p64 - 2048.0,
    1e19, 12345.678, 0x1.fffffffffffffp62, 0x1.0000000000001p63, 0x1.8p63, 9007199254740993.0, 3.0e18, 0x1p63 - 2048.0,
    0x1.23456789abcdep63, 0.999, -0.5, -0.0,
};
static const float tier0_test_unsigned_floats[BUSTER_TIER0_TEST_UNSIGNED_VALUES] = {
    0.0f, 0.5f, 1.0f, 3.5f, 0x1p24f, 0x1.fffffep62f, 0x1p63f, 0x1.000002p63f, 0x1.fffffep63f, 1e19f, 16777217.0f, 0x1p40f,
    0x1.8p63f, 0x1.4p63f, 12345.678f, 0x1p62f, 0x1.000002p62f, 0x1p53f, 0.999f, 0x1.234566p63f, -0.5f, -0.0f,
};
// The signatures: each one's name, and the classes it converts to and from.
static const char* const tier0_test_unsigned_names[4] = { "to double", "to float", "from double", "from float" };
static const uint8_t tier0_test_unsigned_to[4] = { BUSTER_TYPED_CLASS_F64, BUSTER_TYPED_CLASS_F32, BUSTER_TYPED_CLASS_U64, BUSTER_TYPED_CLASS_U64 };
static const uint8_t tier0_test_unsigned_from[4] = { BUSTER_TYPED_CLASS_U64, BUSTER_TYPED_CLASS_U64, BUSTER_TYPED_CLASS_F64, BUSTER_TYPED_CLASS_F32 };

