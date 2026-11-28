// The front prototype's names for several lanes at once: table.h's table (a name of up to 16 bytes inline in a slot,
// two slots a cache line, a longer name by a 128-bit hash and its text), with what lets lanes at different places of
// the text use one table:
//
//   - A slot's content has a version. A macro's binding (a #define, an #undef) has a number, its place in the order the
//     directives made them, and a lane's version is the number of bindings before the text it reads. A slot holds what
//     the name is without a binding (an identifier, a keyword) and what its first binding makes of it, with that
//     binding's version: a lookup takes one or the other by a compare, no branch. A name bound more than once (145 of
//     sqlite3.c's 5,900 bound names) has a list, and its lookups are set aside for it.
//   - A new name is made by a compare-and-exchange on its slot's first key word (0 -> a lock's value -> the key, the
//     key written last): a lane that looks a name up while another makes it finds nothing, an entry being made (it
//     waits) or the whole entry. A name's id is its slot's place, so no counter is shared.
#ifndef FRONT_TABLE_V_H
#define FRONT_TABLE_V_H

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

#define SLOT_BIT_PLACED       0x01u  // without a binding, the token's data is its place in the text (`for`, `while`)
#define SLOT_BIT_BOUND_PLACED 0x02u  // ... and with the first binding
#define SLOT_BIT_BUILTIN      0x40u  // a macro from the start (__LINE__, ...)
#define SLOT_BIT_VERSIONED    0x80u  // bound more than once: the list says what the name is at a version

#define PLACED_MAIN UINT32_C(0xc0000000)
#define VERSION_NEVER UINT32_C(0xffffffff)
#define BIND_NONE UINT32_C(0xffffffff)

typedef struct Slot Slot;
struct Slot
{
    uint64_t k0;         // the name's first 8 bytes, zero-padded; a long name's hash (never 0, never TABLE_LOCKED)
    uint64_t k1;         // its next 8; a long name's second hash, its length in the low byte and its top bit set
    uint32_t data;       // with the first binding: what an occurrence emits
    uint32_t id;         // the slot's place + 1: the name's id, and without a binding its token's data
    uint32_t from;       // the version from which the first binding holds (VERSION_NEVER: never bound)
    uint8_t kind;        // with the first binding: the token's kind
    uint8_t flags;       // ... and SLOT_*
    uint8_t base_kind;   // without a binding: K_IDENT or a keyword's
    uint8_t bits;        // SLOT_BIT_*
};
_Static_assert(sizeof(Slot) == 32u, "a name's slot is half a cache line");

// What a name is at a version.
typedef struct SlotView SlotView;
struct SlotView
{
    uint32_t data;
    uint32_t replacement;   // a SLOT_CHECK name's token's name's slot
    uint8_t kind;
    uint8_t flags;
    uint8_t placed;
};

#define TABLE_BUCKET_BITS 15u
#define TABLE_BUCKETS (1u << TABLE_BUCKET_BITS)
#define TABLE_SLOTS (2u * TABLE_BUCKETS)
#define TABLE_LONG_BIT (UINT64_C(1) << 63)
#define TABLE_LOCKED UINT64_C(2)   // no key: a short name's first byte is a letter's, a long name's hash is odd

typedef struct Table Table;
struct Table
{
    Slot* slots;             // TABLE_BUCKETS lines of two
    uint8_t* pool;           // long names' bytes
    uint32_t* long_text;     // by id: a long name's place in the pool
    uint32_t pool_used;      // (atomic)
    uint32_t* replacement;   // by id: the first binding's SLOT_CHECK token's name's slot
    // The bindings, by their number: what each made of its name, and the next binding of the same name.
    SlotView* bind_views;
    uint32_t* bind_next;
    uint32_t* first_bind;    // by id
    uint32_t* last_bind;
    uint32_t bind_cap;
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

static void table_init(Table* t, uint32_t bind_cap)
{
    t->slots = (Slot*)aligned_alloc(64, sizeof(Slot) * TABLE_SLOTS);
    t->pool = (uint8_t*)malloc(1u << 21);
    t->long_text = (uint32_t*)calloc(TABLE_SLOTS + 2u, 4);
    t->replacement = (uint32_t*)calloc(TABLE_SLOTS + 2u, 4);
    t->first_bind = (uint32_t*)malloc((TABLE_SLOTS + 2u) * 4u);
    t->last_bind = (uint32_t*)malloc((TABLE_SLOTS + 2u) * 4u);
    t->bind_cap = bind_cap + 16u;
    t->bind_views = (SlotView*)calloc(t->bind_cap, sizeof(SlotView));
    t->bind_next = (uint32_t*)malloc((size_t)t->bind_cap * 4u);
    memset(t->slots, 0, sizeof(Slot) * TABLE_SLOTS);
    memset(t->first_bind, 0xff, (TABLE_SLOTS + 2u) * 4u);
    memset(t->last_bind, 0xff, (TABLE_SLOTS + 2u) * 4u);
    memset(t->bind_next, 0xff, (size_t)t->bind_cap * 4u);
    t->pool_used = 0;
}

static void table_reset(Table* t)
{
    memset(t->slots, 0, sizeof(Slot) * TABLE_SLOTS);
    memset(t->replacement, 0, (TABLE_SLOTS + 2u) * 4u);
    memset(t->first_bind, 0xff, (TABLE_SLOTS + 2u) * 4u);
    memset(t->last_bind, 0xff, (TABLE_SLOTS + 2u) * 4u);
    memset(t->bind_next, 0xff, (size_t)t->bind_cap * 4u);
    t->pool_used = 0;
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

// The slot of a name the bucket's two slots don't hold: in a later bucket, being made by another lane, or made here.
static __attribute__((noinline)) Slot* table_miss(Table* t, uint64_t k0, uint64_t k1, uint64_t bucket, const uint8_t* text, uint32_t len)
{
    Slot* found = NULL;
    while (found == NULL)
    {
        Slot* const pair = t->slots + 2u * bucket;
        for (uint32_t i = 0; i < 2u && found == NULL; i += 1)
        {
            Slot* const slot = pair + i;
            uint64_t have = __atomic_load_n(&slot->k0, __ATOMIC_ACQUIRE);
            if (have == 0)
            {
                uint64_t expected = 0;
                if (__atomic_compare_exchange_n(&slot->k0, &expected, TABLE_LOCKED, false, __ATOMIC_ACQ_REL, __ATOMIC_ACQUIRE))
                {
                    const uint32_t id = (uint32_t)(slot - t->slots) + 1u;
                    slot->k1 = k1;
                    slot->data = id;
                    slot->id = id;
                    slot->from = VERSION_NEVER;
                    slot->kind = K_IDENT;
                    slot->flags = 0;
                    slot->base_kind = K_IDENT;
                    slot->bits = 0;
                    if ((k1 & TABLE_LONG_BIT) != 0)
                    {
                        const uint32_t at = __atomic_fetch_add(&t->pool_used, len + 16u, __ATOMIC_RELAXED);
                        t->long_text[id] = at;
                        memcpy(t->pool + at, text, len);
                    }
                    // The key last: a lookup that finds it finds the whole entry.
                    __atomic_store_n(&slot->k0, k0, __ATOMIC_RELEASE);
                    found = slot;
                }
                else
                {
                    have = expected;
                }
            }
            if (found == NULL)
            {
                while (have == TABLE_LOCKED) { _mm_pause(); have = __atomic_load_n(&slot->k0, __ATOMIC_ACQUIRE); }
                if (have == k0 && slot->k1 == k1 && ((k1 & TABLE_LONG_BIT) == 0 || table_long_same(t, slot, text, len))) { found = slot; }
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
    const uint64_t miss0 = (pair[0].k0 ^ k0) | (pair[0].k1 ^ k1);
    const uint64_t miss1 = (pair[1].k0 ^ k0) | (pair[1].k1 ^ k1);
    Slot* slot = pair + (miss0 != 0);
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

// What a name is without a binding.
static inline SlotView slot_base_view(const Slot* slot)
{
    const uint8_t placed = slot->bits & SLOT_BIT_PLACED;
    return (SlotView){ .data = placed != 0 ? 0u : slot->id, .replacement = 0, .kind = slot->base_kind, .flags = 0, .placed = placed };
}

// What a name is at a version: without a binding, with its one binding, or by its list.
static inline SlotView slot_view(const Table* t, const Slot* slot, uint32_t version)
{
    SlotView view = slot_base_view(slot);
    if (__builtin_expect((slot->bits & SLOT_BIT_VERSIONED) == 0, 1))
    {
        if (version >= slot->from)
        {
            view = (SlotView){ .data = slot->data, .replacement = t->replacement[slot->id], .kind = slot->kind, .flags = slot->flags,
                               .placed = (uint8_t)((slot->bits / SLOT_BIT_BOUND_PLACED) & 1u) };
        }
    }
    else
    {
        if ((slot->bits & SLOT_BIT_BUILTIN) != 0) { view.flags = SLOT_MACRO | SLOT_STOP; }
        for (uint32_t b = t->first_bind[slot->id]; b != BIND_NONE && b + 1u <= version; b = t->bind_next[b]) { view = t->bind_views[b]; }
    }
    return view;
}

// A keyword's or a built-in macro's slot, before any binding.
static void table_set_base(Table* t, const char* name, uint32_t len, uint8_t keyword_kind, bool placed, bool builtin)
{
    Slot* const slot = table_name(t, name, len);
    if (keyword_kind != 0) { slot->base_kind = keyword_kind; }
    if (placed) { slot->bits |= SLOT_BIT_PLACED; }
    if (builtin)
    {
        const SlotView base = slot_base_view(slot);
        slot->bits |= SLOT_BIT_BUILTIN | (base.placed != 0 ? SLOT_BIT_BOUND_PLACED : 0u);
        slot->from = 0;
        slot->kind = base.kind;
        slot->data = base.data;
        slot->flags = SLOT_MACRO | SLOT_STOP;
    }
}

// The binding number `number` of the name `slot`: `view` is what it makes of the name (an #undef's is the name without
// a binding). One lane makes the bindings, before the lanes that read them start.
static void table_bind(Table* t, Slot* slot, uint32_t number, SlotView view)
{
    const uint32_t id = slot->id;
    if (slot->from == VERSION_NEVER)
    {
        slot->data = view.data;
        slot->kind = view.kind;
        slot->flags = view.flags;
        slot->bits = (uint8_t)((slot->bits & ~SLOT_BIT_BOUND_PLACED) | (view.placed != 0 ? SLOT_BIT_BOUND_PLACED : 0u));
        t->replacement[id] = view.replacement;
        slot->from = number + 1u;
    }
    else
    {
        slot->bits |= SLOT_BIT_VERSIONED;
    }
    if (t->first_bind[id] == BIND_NONE) { t->first_bind[id] = number; }
    else { t->bind_next[t->last_bind[id]] = number; }
    t->last_bind[id] = number;
    t->bind_next[number] = BIND_NONE;
    t->bind_views[number] = view;
}

#endif
