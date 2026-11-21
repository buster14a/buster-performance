// Review harness for #3044: includes the branch's foreign_strings.c with minimal shims and fuzzes it against an
// independent model of the block-head rule (and, for counting only, the earlier walk rule).
#include <assert.h>
#include <immintrin.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

typedef struct Arena Arena;
struct Arena
{
    uint8_t* base;
    uint64_t length;
    uint64_t capacity;
};

#ifdef SPLIT_ARENA
// Every push is its own heap block, so ASan sees an overrun of any one array; pops free the blocks past the mark.
#define SPLIT_MAX 4096
typedef struct SplitBlock SplitBlock;
struct SplitBlock
{
    const void* arena;
    uint64_t offset;
    void* pointer;
};
static SplitBlock split_blocks[SPLIT_MAX];
static uint32_t split_count;
static void* arena_push(Arena* arena, uint64_t size, uint64_t alignment)
{
    void* result = 0;
    const uint64_t begin = (arena->length + alignment - 1) & ~(alignment - 1);
    if (arena->base != 0 && begin <= arena->capacity && size <= arena->capacity - begin)
    {
        result = aligned_alloc(alignment < 16 ? 16 : alignment, size ? (size + 15) / 16 * 16 : 16);
        // shrink the block's usable range to `size` for ASan: allocate exactly when possible
        free(result);
        result = size % 16 == 0 && size ? aligned_alloc(alignment < 16 ? 16 : alignment, size) : malloc(size ? size : 1);
        assert(((uintptr_t)result & (alignment - 1)) == 0);
#ifndef NO_FILL
        memset(result, 0xcd, size);
#endif
        assert(split_count < SPLIT_MAX);
        split_blocks[split_count++] = (SplitBlock){ .arena = arena, .offset = begin, .pointer = result };
        arena->length = begin + size;
    }
    return result;
}
static void split_pop(Arena* arena, uint64_t length)
{
    uint32_t kept = 0;
    for (uint32_t i = 0; i < split_count; i += 1)
    {
        if (split_blocks[i].arena == arena && split_blocks[i].offset >= length)
        {
            free(split_blocks[i].pointer);
        }
        else
        {
            split_blocks[kept++] = split_blocks[i];
        }
    }
    split_count = kept;
}
#else
static void split_pop(Arena* arena, uint64_t length)
{
    (void)arena;
    (void)length;
}
static void* arena_push(Arena* arena, uint64_t size, uint64_t alignment)
{
    void* result = 0;
    const uintptr_t base = (uintptr_t)arena->base;
    const uintptr_t position = base + arena->length;
    const uintptr_t aligned = (position + alignment - 1) & ~(alignment - 1);
    const uint64_t begin = aligned - base;
    if (base != 0 && begin <= arena->capacity && size <= arena->capacity - begin)
    {
        result = (void*)aligned;
        arena->length = begin + size;
    }
    return result;
}

#endif

static void* arena_push_array(Arena* arena, uint64_t count, uint64_t element_bytes, uint64_t alignment)
{
    uint64_t size = 0;
    void* result = 0;
    if (!__builtin_mul_overflow(count, element_bytes, &size))
    {
        result = arena_push(arena, size, alignment);
    }
    return result;
}

#define BUSTER_ARENA_PUSH_ARRAY(arena, Type, count) ((Type*)arena_push_array((arena), (count), sizeof(Type), _Alignof(Type)))

static void arena_pop_to(Arena* arena, uint64_t length)
{
    assert(length <= arena->length);
    split_pop(arena, length);
    arena->length = length;
}

typedef struct Scratch Scratch;
struct Scratch
{
    Arena* arena;
    uint64_t length;
};

static Arena scratch_arena;

static Scratch scratch_begin(const Arena* conflict)
{
    (void)conflict;
    Scratch s = { .arena = &scratch_arena, .length = scratch_arena.length };
    return s;
}

static void scratch_end(Scratch scratch)
{
    arena_pop_to(scratch.arena, scratch.length);
}

typedef enum ForeignPath
{
    FOREIGN_PATH_VECTOR,
    FOREIGN_PATH_EXACT,
} ForeignPath;

static int hash_mode;

static uint64_t link_hash(const uint8_t* bytes, uint64_t length)
{
    uint64_t hash = 0xcbf29ce484222325ull ^ length;
    if (hash_mode == 0)
    {
        for (uint64_t i = 0; i < length; i += 1)
        {
            hash = (hash ^ bytes[i]) * 0x100000001b3ull;
        }
        hash ^= hash >> 29;
    }
    else if (hash_mode == 1)
    {
        hash = length; // collides for every equal length
    }
    else
    {
        hash = 7; // collides for everything
    }
    return hash;
}

static void link_hash_names(const uint8_t* const* names, const uint32_t* lengths, uint64_t count, uint64_t* hashes)
{
    for (uint64_t i = 0; i < count; i += 1)
    {
        hashes[i] = link_hash(names[i], lengths[i]);
    }
}

#include "/home/user/wt/3044/src/buster/compiler/foreign_strings.c"

// ---------------- model ----------------
typedef struct Model Model;
struct Model
{
    uint32_t count;
    uint32_t size;
    uint32_t* out;
    uint32_t* len;
    const uint8_t** ptr;
    uint32_t* group;
    uint32_t* unit;
    uint8_t* owner;
    uint32_t* section;
    uint32_t* in_off;
    uint32_t differs; // entries whose offset the walk rule places differently (walk model only)
};

// rule: 0 = block head (new), 1 = walk (old)
static void model_build(const ForeignStringInput* inputs, uint32_t input_count, int rule, Model* m)
{
    uint64_t total = 0;
    for (uint32_t s = 0; s < input_count; s += 1)
    {
        total += inputs[s].size;
    }
    m->out = calloc(total + 1, 4);
    m->len = calloc(total + 1, 4);
    m->ptr = calloc(total + 1, sizeof(void*));
    m->group = calloc(total + 1, 4);
    m->unit = calloc(total + 1, 4);
    m->owner = calloc(total + 1, 1);
    m->section = calloc(total + 1, 4);
    m->in_off = calloc(total + 1, 4);
    m->count = 0;
    uint64_t pool = 0;
    for (uint32_t s = 0; s < input_count; s += 1)
    {
        const uint32_t unit = 1u << inputs[s].unit_log2;
        uint32_t begin = 0;
        while (begin < inputs[s].size)
        {
            uint32_t end = begin;
            for (;;)
            {
                uint32_t v = 0;
                memcpy(&v, inputs[s].bytes + end, unit);
                if (v == 0)
                {
                    break;
                }
                end += unit;
            }
            const uint32_t length = end - begin + unit;
            uint64_t alignment = 1ull << inputs[s].alignment_log2;
            while (begin % alignment != 0)
            {
                alignment /= 2;
            }
            const uint8_t* bytes = inputs[s].bytes + begin;
            uint64_t offset = UINT64_MAX;
            for (uint32_t p = 0; offset == UINT64_MAX && p < m->count; p += 1)
            {
                if (m->owner[p] && m->group[p] == inputs[s].group && m->unit[p] == unit && m->len[p] == length && m->out[p] % alignment == 0 &&
                    memcmp(m->ptr[p], bytes, length) == 0)
                {
                    offset = m->out[p];
                }
            }
            if (offset == UINT64_MAX && unit == 1 && rule == 0)
            {
                for (uint32_t p = 0; p < m->count; p += 1)
                {
                    if (m->group[p] == inputs[s].group && m->unit[p] == 1 && m->len[p] >= length && memcmp(m->ptr[p] + m->len[p] - length, bytes, length) == 0)
                    {
                        if (!m->owner[p])
                        {
                            fprintf(stderr, "model: head %u is not an owner\n", p);
                            abort();
                        }
                        const uint64_t shared = (uint64_t)m->out[p] + m->len[p] - length;
                        if (shared % alignment == 0)
                        {
                            offset = shared;
                        }
                        break;
                    }
                }
            }
            if (offset == UINT64_MAX && unit == 1 && rule == 1)
            {
                for (uint32_t p = 0; offset == UINT64_MAX && p < m->count; p += 1)
                {
                    if (m->owner[p] && m->group[p] == inputs[s].group && m->unit[p] == 1 && m->len[p] > length &&
                        memcmp(m->ptr[p] + m->len[p] - length, bytes, length) == 0 && ((uint64_t)m->out[p] + m->len[p] - length) % alignment == 0)
                    {
                        offset = (uint64_t)m->out[p] + m->len[p] - length;
                    }
                }
            }
            const uint32_t e = m->count;
            m->owner[e] = offset == UINT64_MAX;
            if (offset == UINT64_MAX)
            {
                offset = (pool + alignment - 1) / alignment * alignment;
                pool = offset + length;
            }
            m->out[e] = (uint32_t)offset;
            m->len[e] = length;
            m->ptr[e] = bytes;
            m->group[e] = inputs[s].group;
            m->unit[e] = unit;
            m->section[e] = s;
            m->in_off[e] = begin;
            m->count += 1;
            begin = end + unit;
        }
    }
    m->size = (uint32_t)pool;
}

static void model_free(Model* m)
{
    free(m->out);
    free(m->len);
    free(m->ptr);
    free(m->group);
    free(m->unit);
    free(m->owner);
    free(m->section);
    free(m->in_off);
}

// ---------------- generator ----------------
static uint64_t rng;
static uint64_t rnd(void)
{
    rng ^= rng << 13;
    rng ^= rng >> 7;
    rng ^= rng << 17;
    return rng;
}
static uint32_t below(uint32_t n)
{
    return n ? (uint32_t)(rnd() % n) : 0;
}

#define MAX_SECTIONS 16
#define MAX_BYTES (1u << 20)

typedef struct Gen Gen;
struct Gen
{
    // pool of strings to draw from
    uint8_t* strs[4096];
    uint32_t lens[4096];
    uint32_t nstrs;
};

static uint8_t alpha_byte(uint32_t alpha)
{
    static const uint8_t letters[] = { 'a', 'b', 0x80, 0xff, 'c', 0x01, 'd', 0x7f };
    return letters[below(alpha)];
}

static uint32_t gen_length(int shape)
{
    uint32_t r = below(100);
    uint32_t len;
    if (shape == 2)
    {
        len = r < 50 ? below(20) : 7 + below(12);
    }
    else if (r < 40)
    {
        len = below(9);
    }
    else if (r < 75)
    {
        len = 5 + below(14);
    }
    else if (r < 92)
    {
        len = 14 + below(56);
    }
    else
    {
        len = 60 + below(150);
    }
    return len;
}

// Build a family of strings: random strings, suffixes of earlier strings, extensions of earlier strings, duplicates.
static void gen_strings(Gen* g, uint32_t count, uint32_t alpha, int shape)
{
    g->nstrs = 0;
    // shape 1: tie-heavy - many strings sharing a long common tail
    uint8_t tail[256];
    uint32_t tail_len = 8 + below(40);
    for (uint32_t i = 0; i < tail_len; i += 1)
    {
        tail[i] = alpha_byte(alpha);
    }
    if (shape == 4)
    {
        // very long shared tails: many members of one tie across many key levels and 64-byte comparison steps
        static uint8_t big[4096];
        const uint32_t big_len = 64 + below(3000);
        for (uint32_t k = 0; k < big_len; k += 1)
        {
            big[k] = alpha_byte(alpha);
        }
        for (uint32_t i = 0; i < count; i += 1)
        {
            uint8_t* s = malloc(4200);
            uint32_t len = 0;
            const uint32_t kind = below(100);
            if (kind < 50)
            {
                const uint32_t pre = below(6);
                for (uint32_t k = 0; k < pre; k += 1)
                {
                    s[len++] = alpha_byte(alpha);
                }
                memcpy(s + len, big, big_len);
                len += big_len;
            }
            else if (kind < 75)
            {
                const uint32_t take = below(big_len + 1);
                memcpy(s, big + big_len - take, take);
                len = take;
            }
            else
            {
                // differs from the tail at one position far from the end
                memcpy(s, big, big_len);
                s[below(big_len)] = alpha_byte(alpha);
                len = big_len;
            }
            g->strs[g->nstrs] = s;
            g->lens[g->nstrs] = len;
            g->nstrs += 1;
        }
        return;
    }
    for (uint32_t i = 0; i < count; i += 1)
    {
        uint8_t* s = malloc(512);
        uint32_t len = 0;
        uint32_t kind = below(100);
        if (shape == 1 && kind < 70)
        {
            uint32_t pre = below(30);
            for (uint32_t k = 0; k < pre; k += 1)
            {
                s[len++] = alpha_byte(alpha);
            }
            uint32_t take = tail_len - below(tail_len < 8 ? tail_len : 8);
            memcpy(s + len, tail + tail_len - take, take);
            len += take;
        }
        else if (g->nstrs != 0 && kind < 25)
        {
            // suffix of an existing string
            uint32_t j = below(g->nstrs);
            uint32_t take = below(g->lens[j] + 1);
            memcpy(s, g->strs[j] + g->lens[j] - take, take);
            len = take;
        }
        else if (g->nstrs != 0 && kind < 50)
        {
            // extension of an existing string
            uint32_t j = below(g->nstrs);
            uint32_t pre = 1 + below(shape == 2 ? 4 : 20);
            for (uint32_t k = 0; k < pre; k += 1)
            {
                s[len++] = alpha_byte(alpha);
            }
            uint32_t take = g->lens[j] < 400 ? g->lens[j] : 400;
            memcpy(s + len, g->strs[j] + g->lens[j] - take, take);
            len += take;
        }
        else if (g->nstrs != 0 && kind < 62)
        {
            // duplicate
            uint32_t j = below(g->nstrs);
            memcpy(s, g->strs[j], g->lens[j]);
            len = g->lens[j];
        }
        else
        {
            len = gen_length(shape);
            for (uint32_t k = 0; k < len; k += 1)
            {
                s[len - 1 - k] = alpha_byte(alpha);
            }
        }
        if (len > 500)
        {
            len = 500;
        }
        g->strs[g->nstrs] = s;
        g->lens[g->nstrs] = len;
        g->nstrs += 1;
    }
}

static void gen_free(Gen* g)
{
    for (uint32_t i = 0; i < g->nstrs; i += 1)
    {
        free(g->strs[i]);
    }
    g->nstrs = 0;
}

typedef struct Case Case;
struct Case
{
    ForeignStringInput inputs[MAX_SECTIONS];
    uint32_t input_count;
    uint8_t* region[MAX_SECTIONS];
    uint64_t region_bytes[MAX_SECTIONS];
};

static long page_size;
static int force_align0;
static int many_groups;

// Places `size` bytes so that they end at a PROT_NONE page (end) or start right after one (start).
static uint8_t* guarded_copy(const uint8_t* src, uint32_t size, bool at_end, uint8_t** region, uint64_t* region_bytes)
{
    const uint64_t pages = ((uint64_t)size + page_size - 1) / page_size;
    const uint64_t bytes = (pages + 2) * page_size;
    uint8_t* map = mmap(0, bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    assert(map != MAP_FAILED);
    mprotect(map, page_size, PROT_NONE);
    mprotect(map + (pages + 1) * page_size, page_size, PROT_NONE);
    uint8_t* dest = at_end ? map + (pages + 1) * page_size - size : map + page_size;
    memcpy(dest, src, size);
    mprotect(map + page_size, pages * page_size, PROT_READ);
    *region = map;
    *region_bytes = bytes;
    return dest;
}

static const uint32_t group_values[] = { 0, 1, 7, UINT32_MAX, UINT32_MAX - 1, 0x80000000u };

static void case_build(Case* c, Gen* g, int shape)
{
    c->input_count = 1 + below(shape == 3 ? MAX_SECTIONS : 6);
    uint32_t groups = 1 + below(3);
    static uint8_t buffer[MAX_BYTES];
    for (uint32_t s = 0; s < c->input_count; s += 1)
    {
        ForeignStringInput* in = &c->inputs[s];
        uint32_t r = below(100);
        in->unit_log2 = r < 80 ? 0 : r < 92 ? 1 : 2;
        in->alignment_log2 = force_align0 ? 0 : (uint8_t)(below(100) < 50 ? 0 : below(7));
        in->group = many_groups ? (uint32_t)(rnd() >> (32 + below(30))) : group_values[below(groups)];
        const uint32_t unit = 1u << in->unit_log2;
        const bool pad = below(100) < 35; // gcc .rodata.str1.8-like padding between strings
        uint32_t n = below(100) < 10 ? 0 : 1 + below(shape == 1 || shape == 4 ? 120 : 40);
        uint32_t size = 0;
        for (uint32_t i = 0; i < n && size + 20000 < MAX_BYTES; i += 1)
        {
            const uint32_t j = below(g->nstrs);
            if (unit == 1)
            {
                memcpy(buffer + size, g->strs[j], g->lens[j]);
                size += g->lens[j];
                buffer[size++] = 0;
            }
            else
            {
                // wide units: each unit from a string byte, sometimes with zero high bytes
                for (uint32_t k = 0; k < g->lens[j]; k += 1)
                {
                    memset(buffer + size, 0, unit);
                    buffer[size + (below(2) ? 0 : unit - 1)] = g->strs[j][k];
                    size += unit;
                }
                memset(buffer + size, 0, unit);
                size += unit;
            }
            if (pad)
            {
                const uint32_t a = 1u << in->alignment_log2;
                while (size % a != 0)
                {
                    memset(buffer + size, 0, unit);
                    size += unit;
                }
            }
        }
        in->size = size;
        in->bytes = size ? guarded_copy(buffer, size, below(2), &c->region[s], &c->region_bytes[s]) : 0;
        if (!size)
        {
            c->region[s] = 0;
        }
    }
}

static void case_free(Case* c)
{
    for (uint32_t s = 0; s < c->input_count; s += 1)
    {
        if (c->region[s])
        {
            munmap(c->region[s], c->region_bytes[s]);
        }
    }
}

static uint64_t failures;
static uint64_t memory_failures;
static uint64_t walk_differs_entries;
static uint64_t walk_differs_cases;
static uint64_t heads_total;

static void dump_case(const Case* c)
{
    for (uint32_t s = 0; s < c->input_count; s += 1)
    {
        const ForeignStringInput* in = &c->inputs[s];
        fprintf(stderr, "  section %u: group %u unit %u align %u size %u:", s, in->group, 1u << in->unit_log2, 1u << in->alignment_log2, in->size);
        for (uint32_t b = 0; b < in->size && b < 400; b += 1)
        {
            const uint8_t ch = in->bytes[b];
            if (ch == 0)
            {
                fprintf(stderr, "|");
            }
            else if (ch >= 'a' && ch <= 'z')
            {
                fprintf(stderr, "%c", ch);
            }
            else
            {
                fprintf(stderr, "\\x%02x", ch);
            }
        }
        fprintf(stderr, "\n");
    }
}

static bool check_case(const Case* c, uint64_t trial, uint64_t scratch_capacity, uint64_t output_capacity)
{
    Model m = { 0 };
    model_build(c->inputs, c->input_count, 0, &m);
    Model w = { 0 };
    model_build(c->inputs, c->input_count, 1, &w);
    uint32_t differ = 0;
    for (uint32_t e = 0; e < m.count; e += 1)
    {
        differ += m.out[e] != w.out[e];
    }
    walk_differs_entries += differ;
    walk_differs_cases += differ != 0 || m.size != w.size;
    bool ok = true;
    for (int path = 0; path < 2; path += 1)
    {
        static uint8_t* out_base;
        static uint8_t* scr_base;
        if (!out_base)
        {
            out_base = malloc(1u << 28);
            scr_base = malloc(1u << 28);
        }
        Arena out = { .base = out_base, .length = 64, .capacity = output_capacity };
        scratch_arena = (Arena){ .base = scr_base, .length = 128, .capacity = scratch_capacity };
        memset(out_base, 0xa5, 4096);
        ForeignStrings result = { .size = 0xdeadbeef };
        const ForeignStringsError error = foreign_strings_build(c->inputs, c->input_count, path ? FOREIGN_PATH_EXACT : FOREIGN_PATH_VECTOR, &out, &result);
        if (scratch_arena.length != 128)
        {
            fprintf(stderr, "trial %llu: scratch length %llu after build\n", (unsigned long long)trial, (unsigned long long)scratch_arena.length);
            ok = false;
        }
        if (error == FOREIGN_STRINGS_ERROR_MEMORY && (scratch_capacity < (1u << 28) || output_capacity < (1u << 28)))
        {
            memory_failures += 1;
            if (out.length != 64 || result.size != 0xdeadbeef)
            {
                fprintf(stderr, "trial %llu: memory failure changed output (length %llu)\n", (unsigned long long)trial, (unsigned long long)out.length);
                ok = false;
            }
            goto next;
        }
        if (error != FOREIGN_STRINGS_ERROR_NONE)
        {
            fprintf(stderr, "trial %llu path %d: error %d\n", (unsigned long long)trial, path, error);
            ok = false;
            goto next;
        }
        bool same = result.count == m.count && result.size == m.size;
        uint32_t first_bad = UINT32_MAX;
        for (uint32_t e = 0; same && e < m.count; e += 1)
        {
            if (result.output_offset[e] != m.out[e] || result.lengths[e] != m.len[e] || result.input_offset[e] != m.in_off[e])
            {
                same = false;
                first_bad = e;
            }
        }
        // independent: every entry's bytes are in the pool at its offset
        for (uint32_t e = 0; same && e < m.count; e += 1)
        {
            if (memcmp(result.bytes + result.output_offset[e], m.ptr[e], m.len[e]) != 0)
            {
                same = false;
                first_bad = e;
            }
        }
        if (!same)
        {
            ok = false;
            fprintf(stderr, "trial %llu path %d: mismatch: count %u/%u size %u/%u first bad entry %u", (unsigned long long)trial, path, result.count, m.count, result.size,
                    m.size, first_bad);
            if (first_bad != UINT32_MAX && first_bad < result.count)
            {
                fprintf(stderr, " (got %u want %u len %u)", result.output_offset[first_bad], m.out[first_bad], m.len[first_bad]);
            }
            fprintf(stderr, "\n");
        }
        if (same)
        {
            uint8_t* pool = calloc(m.size + 1, 1);
            for (uint32_t e = 0; e < m.count; e += 1)
            {
                memcpy(pool + m.out[e], m.ptr[e], m.len[e]);
            }
            if (memcmp(pool, result.bytes, m.size) != 0)
            {
                fprintf(stderr, "trial %llu path %d: pool bytes (padding) differ\n", (unsigned long long)trial, path);
                ok = false;
            }
            free(pool);
        }
    next:
        if (out.length > 64)
        {
            arena_pop_to(&out, 64);
        }
    }
    if (!ok)
    {
        failures += 1;
        if (failures < 4)
        {
            dump_case(c);
        }
    }
    model_free(&m);
    model_free(&w);
    return ok;
}

int main(int argc, char** argv)
{
    page_size = sysconf(_SC_PAGESIZE);
    const uint64_t trials = argc > 1 ? strtoull(argv[1], 0, 0) : 1000;
    rng = argc > 2 ? strtoull(argv[2], 0, 0) : 0x1234567;
    hash_mode = argc > 3 ? atoi(argv[3]) : 0;
    const int starve = argc > 4 ? atoi(argv[4]) : 0;
    force_align0 = getenv("ALIGN0") != 0;
    many_groups = getenv("MANYGROUPS") != 0;
    if (getenv("FILE"))
    {
        FILE* f = fopen(getenv("FILE"), "rb");
        uint32_t n = 0;
        assert(fread(&n, 4, 1, f) == 1);
        ForeignStringInput* inputs = calloc(n + 1, sizeof(ForeignStringInput));
        for (uint32_t i = 0; i < n; i += 1)
        {
            uint32_t g = 0;
            uint8_t u = 0;
            uint8_t a = 0;
            uint32_t size = 0;
            assert(fread(&g, 4, 1, f) == 1 && fread(&u, 1, 1, f) == 1 && fread(&a, 1, 1, f) == 1 && fread(&size, 4, 1, f) == 1);
            uint8_t* bytes = malloc(size + 1);
            assert(fread(bytes, 1, size, f) == size);
            inputs[i] = (ForeignStringInput){ .bytes = bytes, .size = size, .group = g, .alignment_log2 = a, .unit_log2 = u };
        }
        fclose(f);
        if (getenv("FASTOUT"))
        {
            static uint8_t* ob;
            static uint8_t* sb;
            ob = malloc(1u << 30);
            sb = malloc(1u << 30);
            FILE* o = fopen(getenv("FASTOUT"), "wb");
            for (int path = 0; path < 2; path += 1)
            {
                Arena out = { .base = ob, .length = 0, .capacity = 1u << 30 };
                scratch_arena = (Arena){ .base = sb, .length = 0, .capacity = 1u << 30 };
                ForeignStrings r = { 0 };
                const ForeignStringsError error = foreign_strings_build(inputs, n, path ? FOREIGN_PATH_EXACT : FOREIGN_PATH_VECTOR, &out, &r);
                assert(error == 0);
                fwrite(&r.size, 4, 1, o);
                fwrite(&r.count, 4, 1, o);
                fwrite(r.output_offset, 4, r.count, o);
                // the pool bytes, to check against the model's
                fwrite(r.bytes, 1, r.size, o);
            }
            fclose(o);
            return 0;
        }
        Model head = { 0 };
        Model walk = { 0 };
        model_build(inputs, n, 0, &head);
        model_build(inputs, n, 1, &walk);
        uint32_t differ = 0;
        for (uint32_t e = 0; e < head.count; e += 1)
        {
            differ += head.out[e] != walk.out[e];
        }
        static uint8_t* out_bytes;
        static uint8_t* scr_bytes;
        out_bytes = malloc(1u << 30);
        scr_bytes = malloc(1u << 30);
        int ok = 1;
        for (int path = 0; path < 2; path += 1)
        {
            Arena out = { .base = out_bytes, .length = 0, .capacity = 1u << 30 };
            scratch_arena = (Arena){ .base = scr_bytes, .length = 0, .capacity = 1u << 30 };
            ForeignStrings r = { 0 };
            const ForeignStringsError error = foreign_strings_build(inputs, n, path ? FOREIGN_PATH_EXACT : FOREIGN_PATH_VECTOR, &out, &r);
            int same = error == 0 && r.size == head.size && r.count == head.count;
            for (uint32_t e = 0; same && e < r.count; e += 1)
            {
                same = r.output_offset[e] == head.out[e];
            }
            ok &= same;
        }
        printf("entries %u producer matches head model: %s; pool head %u walk %u; entries placed differently %u\n", head.count, ok ? "yes" : "NO", head.size, walk.size,
               differ);
        return !ok;
    }
    if (getenv("FIXTURES"))
    {
        static const uint8_t both[] = "compiler\0piler";
        static const uint8_t xpiler[] = "xpiler";
        static const uint8_t piler[] = "piler";
        static const uint8_t owners[] = "aa\0ab\0ac\0ad\0ae\0af\0ag\0ah\0ai\0aj\0ak";
        static const uint8_t zero[] = { 0 };
        ForeignStringInput later[4] = {
            { .bytes = both, .size = 9, .group = 5 },
            { .bytes = xpiler, .size = sizeof(xpiler), .group = 5 },
            { .bytes = piler, .size = sizeof(piler), .group = 5, .alignment_log2 = 1 },
            { .bytes = piler, .size = sizeof(piler), .group = 5 },
        };
        ForeignStringInput growth[2] = {
            { .bytes = owners, .size = sizeof(owners), .group = 8 },
            { .bytes = zero, .size = 1, .group = 8, .alignment_log2 = 5 },
        };
        const ForeignStringInput* sets[2] = { later, growth };
        const uint32_t counts[2] = { 4, 2 };
        const char* names[2] = { "1004", "1008" };
        for (uint32_t f = 0; f < 2; f += 1)
        {
            for (int rule = 0; rule < 2; rule += 1)
            {
                Model mm = { 0 };
                model_build(sets[f], counts[f], rule, &mm);
                printf("%s %s model: size %u offsets", names[f], rule ? "walk" : "head", mm.size);
                for (uint32_t e = 0; e < mm.count; e += 1)
                {
                    printf(" %u", mm.out[e]);
                }
                printf("\n");
            }
        }
        return 0;
    }
    if (getenv("HAND"))
    {
        static const uint8_t a[] = "xab";
        static const uint8_t b[] = "yzab\0\0ab";
        ForeignStringInput inputs[2] = {
            { .bytes = a, .size = 4, .group = 0, .alignment_log2 = 0, .unit_log2 = 0 },
            { .bytes = b, .size = 9, .group = 0, .alignment_log2 = 1, .unit_log2 = 0 },
        };
        Model head = { 0 };
        Model walk = { 0 };
        model_build(inputs, 2, 0, &head);
        model_build(inputs, 2, 1, &walk);
        static uint8_t out_bytes[1 << 20];
        static uint8_t scr_bytes[1 << 20];
        Arena out = { .base = out_bytes, .length = 0, .capacity = sizeof(out_bytes) };
        scratch_arena = (Arena){ .base = scr_bytes, .length = 0, .capacity = sizeof(scr_bytes) };
        ForeignStrings r = { 0 };
        const ForeignStringsError error = foreign_strings_build(inputs, 2, FOREIGN_PATH_VECTOR, &out, &r);
        printf("error %d producer size %u offsets:", error, r.size);
        for (uint32_t e = 0; e < r.count; e += 1)
        {
            printf(" %u", r.output_offset[e]);
        }
        printf("\nhead model size %u offsets:", head.size);
        for (uint32_t e = 0; e < head.count; e += 1)
        {
            printf(" %u", head.out[e]);
        }
        printf("\nwalk model size %u offsets:", walk.size);
        for (uint32_t e = 0; e < walk.count; e += 1)
        {
            printf(" %u", walk.out[e]);
        }
        printf("\n");
        return 0;
    }
    for (uint64_t t = 0; t < trials; t += 1)
    {
        Gen g = { 0 };
        const int shape = getenv("SHAPE") ? atoi(getenv("SHAPE")) : (int)below(5);
        const uint32_t alpha = 1 + below(shape == 2 ? 8 : 3);
        gen_strings(&g, 1 + below(shape == 1 ? 300 : 120), alpha, shape);
        Case c = { 0 };
        case_build(&c, &g, shape);
        uint64_t scratch_capacity = 1u << 28;
        uint64_t output_capacity = 1u << 28;
        if (starve)
        {
            scratch_capacity = 128 + below(1u << (8 + below(10)));
            if (below(4) == 0)
            {
                output_capacity = 64 + below(1u << (8 + below(10)));
            }
        }
        check_case(&c, t, scratch_capacity, output_capacity);
        case_free(&c);
        gen_free(&g);
    }
    printf("memory failures %llu\n", (unsigned long long)memory_failures);
    printf("trials %llu failures %llu walk-differs cases %llu entries %llu\n", (unsigned long long)trials, (unsigned long long)failures,
           (unsigned long long)walk_differs_cases, (unsigned long long)walk_differs_entries);
    return failures != 0;
}
