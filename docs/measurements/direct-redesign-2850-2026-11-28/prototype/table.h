// The front prototype's names: one table whose slot holds a name of up to 16 bytes inline (a compare of two words, no
// second load) beside what a plain occurrence of the name emits: the token's kind and data as the stream has them. A
// keyword's slot holds its kind; a macro whose body is one token holds that token; a name the text's own tokens stop
// at (any other macro) has a flag.
//
// A bucket is a cache line of two slots: a lookup loads one line and compares both, and the second slot takes most
// of what would be a second probe. A longer name (6% of occurrences in sqlite3.c) has a 128-bit hash of its bytes as
// its two words (marked by a byte no identifier has), and a hit compares its text.
#ifndef FRONT_TABLE_H
#define FRONT_TABLE_H

#include "ref.h"
#include <immintrin.h>
#include <stdlib.h>

#define SLOT_STOP            0x01u   // the stream's own tokens stop here: an expansion makes what follows
#define SLOT_DELETE          0x02u   // an empty object-like macro: the name goes
#define SLOT_DELETE_IF_PAREN 0x04u   // a one-parameter identity macro: the name goes where a '(' follows
#define SLOT_CHECK           0x08u   // a one-token macro whose token is a name: it stops if that name is a macro's now
#define SLOT_FUNC            0x20u   // a function-like macro: only where a '(' follows; else the name is an identifier
#define SLOT_EVENT           0x2fu
#define SLOT_MACRO           0x80u   // the name is a macro's (of any kind)

#define PLACED_MAIN UINT32_C(0xc0000000)

typedef struct Slot Slot;
struct Slot
{
    uint64_t k0;         // the name's first 8 bytes, zero-padded; a long name's hash (never 0)
    uint64_t k1;         // its next 8; a long name's second hash, its length in the low byte and its top bit set
    uint32_t data;       // what an occurrence emits: the name's id, or a one-token macro's token's data
    uint32_t placed;     // all ones for `for` and `while`, whose data is their place in the text
    uint8_t kind;        // ... and its kind
    uint8_t flags;
    uint8_t base_kind;   // the kind without a macro: K_IDENT or a keyword's
    uint8_t pad;
    uint32_t id;         // 1-based, in order of first occurrence
};
_Static_assert(sizeof(Slot) == 32u, "a name's slot is half a cache line");

#define TABLE_BUCKET_BITS 15u
#define TABLE_BUCKETS (1u << TABLE_BUCKET_BITS)
#define TABLE_SLOTS (2u * TABLE_BUCKETS)
#define TABLE_LONG_BIT (UINT64_C(1) << 63)

typedef struct Table Table;
struct Table
{
    Slot* slots;             // TABLE_BUCKETS lines of two
    uint8_t* pool;           // long names' bytes
    uint32_t* long_text;     // by id: a long name's place in the pool
    uint32_t pool_used;
    uint32_t count;          // names
    uint32_t* replacement;   // by id: a SLOT_CHECK name's token's name's slot
    uint64_t misses;         // lookups past a bucket's two slots, and first occurrences
    uint64_t inserts;
};

static inline uint64_t table_mix(uint64_t a, uint64_t b)
{
    const __uint128_t product = (__uint128_t)a * b;
    return (uint64_t)product ^ (uint64_t)(product >> 64);
}

static inline uint64_t table_hash(uint64_t k0, uint64_t k1)
{
    return table_mix(k0 ^ UINT64_C(0x9E3779B97F4A7C15), k1 ^ UINT64_C(0xC2B2AE3D27D4EB4F));
}

static void table_init(Table* t)
{
    t->slots = (Slot*)aligned_alloc(64, sizeof(Slot) * TABLE_SLOTS);
    t->pool = (uint8_t*)malloc(1u << 20);
    t->long_text = (uint32_t*)calloc(TABLE_SLOTS, 4);
    t->replacement = (uint32_t*)calloc(TABLE_SLOTS, 4);
    memset(t->slots, 0, sizeof(Slot) * TABLE_SLOTS);
    t->pool_used = 0;
    t->count = 0;
    t->misses = 0;
    t->inserts = 0;
}

static void table_reset(Table* t)
{
    memset(t->slots, 0, sizeof(Slot) * TABLE_SLOTS);
    memset(t->replacement, 0, TABLE_SLOTS * 4u);
    t->pool_used = 0;
    t->count = 0;
    t->misses = 0;
    t->inserts = 0;
}

// A long name's two words: a hash of all its bytes, with its length and the mark no short name has.
static inline void table_long_key(const uint8_t* p, uint32_t len, uint64_t* k0, uint64_t* k1)
{
    uint64_t a, b, c, d;
    memcpy(&a, p, 8);
    memcpy(&b, p + 8, 8);
    memcpy(&c, p + len - 16u, 8);
    memcpy(&d, p + len - 8u, 8);
    __uint128_t m1 = (__uint128_t)(a ^ UINT64_C(0x9E3779B97F4A7C15)) * (d ^ UINT64_C(0xC2B2AE3D27D4EB4F));
    __uint128_t m2 = (__uint128_t)(b ^ UINT64_C(0x165667B19E3779F9)) * (c ^ UINT64_C(0x27D4EB2F165667C5));
    if (__builtin_expect(len > 32u, 0))
    {
        // The bytes between the first and the last sixteen.
        for (uint32_t i = 16; i + 16u < len; i += 8u)
        {
            uint64_t w;
            memcpy(&w, p + i, 8);
            m1 = (__uint128_t)((uint64_t)m1 ^ w ^ UINT64_C(0xff51afd7ed558ccd)) * ((uint64_t)(m1 >> 64) ^ UINT64_C(0xc4ceb9fe1a85ec53));
        }
    }
    *k0 = ((uint64_t)m1 ^ (uint64_t)(m2 >> 64)) | 1u;
    *k1 = ((((uint64_t)(m1 >> 64) ^ (uint64_t)m2) & ~UINT64_C(0xff)) | (len & 0xffu)) | TABLE_LONG_BIT;
}

static inline bool table_long_same(const Table* t, const Slot* slot, const uint8_t* p, uint32_t len)
{
    const uint8_t* const q = t->pool + t->long_text[slot->id];
    bool same;
    if (__builtin_expect(len <= 32u, 1))
    {
        const __m128i head = _mm_xor_si128(_mm_loadu_si128((const __m128i*)(const void*)p), _mm_loadu_si128((const __m128i*)(const void*)q));
        const __m128i last = _mm_xor_si128(_mm_loadu_si128((const __m128i*)(const void*)(p + len - 16u)), _mm_loadu_si128((const __m128i*)(const void*)(q + len - 16u)));
        same = _mm_testz_si128(_mm_or_si128(head, last), _mm_or_si128(head, last)) != 0;
    }
    else
    {
        same = memcmp(p, q, len) == 0;
    }
    return same;
}

// The slot of a name the bucket's two slots don't hold: in a later bucket, or made.
static __attribute__((noinline)) Slot* table_miss(Table* t, uint64_t k0, uint64_t k1, uint64_t bucket, const uint8_t* text, uint32_t len)
{
    t->misses += 1u;
    Slot* found = NULL;
    while (found == NULL)
    {
        Slot* const pair = t->slots + 2u * bucket;
        for (uint32_t i = 0; i < 2u && found == NULL; i += 1)
        {
            Slot* const slot = pair + i;
            if (slot->k0 == 0)
            {
                t->count += 1u;
                t->inserts += 1u;
                *slot = (Slot){ .k0 = k0, .k1 = k1, .data = t->count, .placed = 0, .kind = K_IDENT, .flags = 0, .base_kind = K_IDENT, .id = t->count };
                if ((k1 & TABLE_LONG_BIT) != 0)
                {
                    t->long_text[t->count] = t->pool_used;
                    memcpy(t->pool + t->pool_used, text, len);
                    t->pool_used += len + 16u;
                }
                found = slot;
            }
            else if (slot->k0 == k0 && slot->k1 == k1 && ((k1 & TABLE_LONG_BIT) == 0 || table_long_same(t, slot, text, len)))
            {
                found = slot;
            }
        }
        bucket = (bucket + 1u) & (TABLE_BUCKETS - 1u);
    }
    return found;
}

// The slot of the name at `p` (32 bytes are readable there, and 16 before a long name's end).
static inline __attribute__((always_inline)) Slot* table_find_in(Table* t, Slot* slots, const uint8_t* p, uint32_t len)
{
    uint64_t k0;
    uint64_t k1;
    const bool is_long = len > 16u;
    if (__builtin_expect(!is_long, 1))
    {
        uint64_t w0;
        uint64_t w1;
        memcpy(&w0, p, 8);
        memcpy(&w1, p + 8, 8);
        k0 = _bzhi_u64(w0, len * 8u);                          // bzhi keeps the word whole from 64 bits on
        k1 = _bzhi_u64(w1, (len > 8u ? len - 8u : 0u) * 8u);   // 0 bits: nothing
    }
    else
    {
        table_long_key(p, len, &k0, &k1);
    }
    const uint64_t bucket = table_hash(k0, k1) >> (64u - TABLE_BUCKET_BITS);
    Slot* const pair = slots + 2u * bucket;
    // Both slots' compares as words (no branch between them): which of the two is the name's is a select.
    const uint64_t miss0 = (pair[0].k0 ^ k0) | (pair[0].k1 ^ k1);
    const uint64_t miss1 = (pair[1].k0 ^ k0) | (pair[1].k1 ^ k1);
    Slot* slot = pair + (miss0 != 0);
    // (One test of both words' non-zero bits: two tests would be two branches, and which slot holds a name is a
    // coin's toss.)
    if (__builtin_expect((((miss0 | (UINT64_C(0) - miss0)) & (miss1 | (UINT64_C(0) - miss1))) >> 63) != 0, 0))
    {
        slot = table_miss(t, k0, k1, bucket, p, len);
    }
    else if (__builtin_expect(is_long, 0))
    {
        if (__builtin_expect(!table_long_same(t, slot, p, len), 0)) { slot = table_miss(t, k0, k1, bucket, p, len); }
    }
    return slot;
}

static inline __attribute__((always_inline)) Slot* table_find(Table* t, const uint8_t* p, uint32_t len)
{
    return table_find_in(t, t->slots, p, len);
}

// A name's slot, by any length (the oracle's names, the bindings').
static Slot* table_name(Table* t, const char* name, uint32_t len)
{
    uint8_t padded[320] = { 0 };
    memcpy(padded + 32, name, len < 256u ? len : 255u);
    return table_find(t, padded + 32, len < 256u ? len : 255u);
}

static inline uint32_t table_slot_reference(const Table* t, const Slot* slot)
{
    return (uint32_t)(slot - t->slots);
}

static inline const Slot* table_slot_at(const Table* t, uint32_t reference)
{
    return t->slots + reference;
}

#endif
