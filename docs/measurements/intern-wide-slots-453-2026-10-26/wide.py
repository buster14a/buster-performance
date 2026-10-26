# #453's experiment: the intern table's buckets as three 20-byte slots (a 16-byte prefix and the id) when
# BUSTER_INTERN_WIDE_SLOTS is 1, four 16-byte slots (a 12-byte prefix and the id) otherwise. Not for commit as is.
import sys
root = sys.argv[1]
def patch(path, pairs):
    p = root + "/" + path
    t = open(p).read()
    for old, new in pairs:
        assert t.count(old) == 1, (path, old[:80], t.count(old))
        t = t.replace(old, new)
    open(p, "w").write(t)
patch("src/buster/compiler/c_intern.c", [
("""#define BUSTER_INTERN_BUCKET_SLOTS 4
#define BUSTER_INTERN_SLOT_BYTES 16
#define BUSTER_INTERN_BUCKET_BYTES (BUSTER_INTERN_BUCKET_SLOTS * BUSTER_INTERN_SLOT_BYTES)
#define BUSTER_INTERN_PREFIX_BYTES 12""",
"""#ifndef BUSTER_INTERN_WIDE_SLOTS
#define BUSTER_INTERN_WIDE_SLOTS 0
#endif
#if BUSTER_INTERN_WIDE_SLOTS
#define BUSTER_INTERN_BUCKET_SLOTS 3
#define BUSTER_INTERN_SLOT_BYTES 20
#define BUSTER_INTERN_PREFIX_BYTES 16
#define BUSTER_INTERN_PREFIX_DWORDS 0x3DEF
#define BUSTER_INTERN_SLOT_CARRY 0x0421
#define BUSTER_INTERN_ID_DWORDS 0x4210
#else
#define BUSTER_INTERN_BUCKET_SLOTS 4
#define BUSTER_INTERN_SLOT_BYTES 16
#define BUSTER_INTERN_PREFIX_BYTES 12
#define BUSTER_INTERN_PREFIX_DWORDS 0x7777
#define BUSTER_INTERN_SLOT_CARRY 0x1111
#define BUSTER_INTERN_ID_DWORDS 0x8888
#endif
#define BUSTER_INTERN_BUCKET_BYTES 64"""),
("""BUSTER_INLINE __m512i intern_bucket_key(__m128i first_bytes)
{
    return _mm512_broadcast_i32x4(first_bytes);
}""",
"""BUSTER_INLINE __m512i intern_bucket_key(__m128i first_bytes)
{
#if BUSTER_INTERN_WIDE_SLOTS
    const __m512i words = _mm512_inserti32x4(_mm512_set1_epi32(-1), first_bytes, 0);
    return _mm512_permutexvar_epi32(_mm512_setr_epi32(0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 4), words);
#else
    return _mm512_broadcast_i32x4(first_bytes);
#endif
}"""),
("""    const uint32_t equal = _mm512_mask_cmpeq_epi32_mask(0x7777, bucket, key);
    return (equal + 0x1111) & 0x8888;""",
"""    const uint32_t equal = _mm512_mask_cmpeq_epi32_mask(BUSTER_INTERN_PREFIX_DWORDS, bucket, key);
    return (equal + BUSTER_INTERN_SLOT_CARRY) & BUSTER_INTERN_ID_DWORDS;"""),
("""    return _mm512_mask_cmpeq_epi32_mask(0x8888, bucket, _mm512_setzero_si512());""",
"""    return _mm512_mask_cmpeq_epi32_mask(BUSTER_INTERN_ID_DWORDS, bucket, _mm512_setzero_si512());"""),
("""// Puts `slot` (a spelling's prefix and id; the spelling has `hash` and is known to be absent) in the first empty slot of
// its probe sequence: its bucket, then the next ones.
static void intern_place(InternTable* table, __m128i slot, uint64_t hash)
{""",
"""// Writes slot `bit` (its id's dword) of `bucket`: the prefix from `first`, then `id`.
BUSTER_INLINE void intern_store_slot(uint8_t* bucket, uint32_t bit, __m128i first, IdentId id)
{
#if BUSTER_INTERN_WIDE_SLOTS
    _mm_storeu_si128((__m128i*)(bucket + (bit - 4) * 4), first);
    memcpy(bucket + bit * 4, &id, sizeof(id));
#else
    _mm_storeu_si128((__m128i*)(bucket + (bit - 3) * 4), _mm_insert_epi32(first, (int)id, 3));
#endif
}

// Puts spelling `id` (its first bytes `first`; the spelling has `hash` and is known to be absent) in the first empty
// slot of its probe sequence: its bucket, then the next ones.
static void intern_place(InternTable* table, __m128i first, IdentId id, uint64_t hash)
{"""),
("""            // Bit 4s + 3 is slot s's id.
            _mm_storeu_si128((__m128i*)(bucket_bytes + ((uint32_t)__builtin_ctz(empties) - 3) * 4), slot);""",
"""            intern_store_slot(bucket_bytes, (uint32_t)__builtin_ctz(empties), first, id);"""),
("""// The slot of spelling `id` from its first 16 bytes (`first`, zero past its end): the first BUSTER_INTERN_PREFIX_BYTES,
// then the id in place of the rest.
BUSTER_INLINE __m128i intern_slot(__m128i first, IdentId id)
{
    return _mm_insert_epi32(first, (int)id, BUSTER_INTERN_PREFIX_BYTES / sizeof(IdentId));
}
""", ""),
("""            intern_place(&grown, intern_slot(intern_first_bytes(bytes, length), id), intern_hash_bytes(bytes, length));""",
"""            intern_place(&grown, intern_first_bytes(bytes, length), id, intern_hash_bytes(bytes, length));"""),
("""        intern_place(table, intern_slot(intern_first_bytes(bytes, length), result), hash);""",
"""        intern_place(table, intern_first_bytes(bytes, length), result, hash);"""),
("""        intern_place(table, intern_slot(_mm512_castsi512_si128(spelling), result), place);""",
"""        intern_place(table, _mm512_castsi512_si128(spelling), result, place);"""),
("""        // Bit 4s + 3 is slot s's id.
        _mm_storeu_si128((__m128i*)(bucket + ((uint32_t)__builtin_ctz(empties) - 3) * 4), intern_slot(_mm512_castsi512_si128(spelling), result));""",
"""        intern_store_slot(bucket, (uint32_t)__builtin_ctz(empties), _mm512_castsi512_si128(spelling), result);"""),
("""static void intern_place_shared(InternTable* table, __m128i slot, uint64_t hash)
{
    const IdentId id = (IdentId)_mm_extract_epi32(slot, BUSTER_INTERN_PREFIX_BYTES / sizeof(IdentId));
    uint8_t prefix[BUSTER_INTERN_SLOT_BYTES];
    _mm_storeu_si128((__m128i*)prefix, slot);""",
"""static void intern_place_shared(InternTable* table, __m128i first, IdentId id, uint64_t hash)
{
    uint8_t prefix[BUSTER_INTERN_SLOT_BYTES];
    _mm_storeu_si128((__m128i*)prefix, first);"""),
("""                intern_place_shared(table, intern_slot(intern_first_bytes(table->records + span.offset, span.length), batch + i), hashes[i]);""",
"""                intern_place_shared(table, intern_first_bytes(table->records + span.offset, span.length), batch + i, hashes[i]);"""),
("""    intern_place_shared(table, intern_slot(intern_first_bytes(bytes, length), id), hash);""",
"""    intern_place_shared(table, intern_first_bytes(bytes, length), id, hash);"""),
])
patch("src/buster/compiler/c_refine.c", [
("""BUSTER_INLINE __m128i refine_key(__m128i first)
{
    return _mm_or_si128(first, _mm_setr_epi32(0, 0, 0, -1));
}""",
"""BUSTER_INLINE __m128i refine_key(__m128i first)
{
#if BUSTER_INTERN_WIDE_SLOTS
    return first;
#else
    return _mm_or_si128(first, _mm_setr_epi32(0, 0, 0, -1));
#endif
}"""),
("""        _mm512_store_si512(keys + j, _mm512_or_si512(first_lanes, _mm512_set4_epi32(-1, 0, 0, 0)));""",
"""        // Four keys at once, each refine_key's.
        _mm512_store_si512(keys + j, BUSTER_INTERN_WIDE_SLOTS ? first_lanes : _mm512_or_si512(first_lanes, _mm512_set4_epi32(-1, 0, 0, 0)));"""),
("""    const __mmask16 matches = _kand_mask16(_kadd_mask16(equal, 0x1111), 0x8888);""",
"""    const __mmask16 matches = _kand_mask16(_kadd_mask16(equal, BUSTER_INTERN_SLOT_CARRY), BUSTER_INTERN_ID_DWORDS);"""),
])
patch("src/buster/compiler/c_refine_test.c", [
("""        const uint32_t prefix[4] = {
            0x64636261,
            0x68676665,
            0x6c6b6a69,
            UINT32_MAX,
        };""",
"""        const uint32_t words = BUSTER_INTERN_PREFIX_BYTES / 4;
        const uint32_t prefix[4] = {
            0x64636261,
            0x68676665,
            0x6c6b6a69,
            words == 4 ? 0x706f6e6du : UINT32_MAX,
        };"""),
("""                for (uint32_t slot = 0; slot < BUSTER_INTERN_BUCKET_SLOTS; slot += 1)
                {
                    const uint32_t matches = (pattern >> (3 * slot)) & 7;
                    for (uint32_t word = 0; word < 3; word += 1)
                    {
                        bucket[4 * slot + word] = prefix[word] ^ (uint32_t)(((matches >> word) & 1) == 0);
                    }
                    const IdentId id = high != 0 ? BUSTER_INTERN_MAX_IDS - 4 + slot : slot + 1;
                    bucket[4 * slot + 3] = id;
                    if (expected == 0 && matches == 7)""",
"""                for (uint32_t slot = 0; slot < BUSTER_INTERN_BUCKET_SLOTS; slot += 1)
                {
                    const uint32_t all = (1u << words) - 1;
                    const uint32_t matches = (pattern >> (words * slot)) & all;
                    for (uint32_t word = 0; word < words; word += 1)
                    {
                        bucket[(words + 1) * slot + word] = prefix[word] ^ (uint32_t)(((matches >> word) & 1) == 0);
                    }
                    const IdentId id = high != 0 ? BUSTER_INTERN_MAX_IDS - 4 + slot : slot + 1;
                    bucket[(words + 1) * slot + words] = id;
                    if (expected == 0 && matches == all)"""),
])
print("patched")
