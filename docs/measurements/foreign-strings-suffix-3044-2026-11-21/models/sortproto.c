// sortproto.c: cost and correctness prototype of #3044's sort-based precompute (scratch, not repository code).
// Usage: sortproto FILE RUNS. FILE holds one group's zero-terminated one-byte entries in input order; FILE.model holds
// model.py's sorted order, per-class lcp and m'. Runs the data against a PROT_NONE page before it and one after it,
// checks the dump against the model and times each phase (best of RUNS).
#include <immintrin.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <x86intrin.h>

static const uint8_t* base;
static uint32_t n;
static uint32_t* begin;
static uint32_t* klen;
static uint64_t* keys;
static uint64_t* keys2;
static uint32_t* ents;
static uint32_t* ents2;
static uint32_t* cls_first;
static uint32_t* cls_k;
static uint32_t* cls_lcp;
static uint32_t* cls_mprime;
static uint32_t nc;
static uint32_t* cls_of;
static uint32_t* work;

static uint64_t c_passes, c_runs, c_run_entries, c_max_run, c_levels, c_chunk_loads, c_internal, c_scan_vectors, c_one_vector;

enum
{
    PHASE_KEYS,
    PHASE_SORT,
    PHASE_REFINE,
    PHASE_CLASSES,
    PHASE_SCAN,
    PHASE_COUNT,
};
static const char* phase_names[] = { "keys", "radix", "refine", "classes+lcp", "blocks+m'" };
static uint64_t phase_ticks[PHASE_COUNT];

// Chunk t of an entry's reversed content: the 8 bytes ending 8t before its terminator, the nearest most significant,
// zero past its start. One masked load; none for a chunk wholly past the start.
static uint64_t chunk(uint32_t e, uint32_t t)
{
    const uint32_t k = klen[e];
    const uint8_t* hi = base + begin[e] + k - 8 * t;
    uint64_t v = 0;
    if (k >= 8 * t + 8)
    {
        memcpy(&v, hi - 8, 8);
    }
    else if (k > 8 * t)
    {
        const uint32_t avail = k - 8 * t;
        const __mmask16 m = (__mmask16)(((1u << avail) - 1) << (8 - avail));
        v = (uint64_t)_mm_cvtsi128_si64(_mm_maskz_loadu_epi8(m, hi - 8));
    }
    return v;
}

// Stable LSD radix sort of keys/ents[first, first + count) by bytes, skipping bytes no key changes.
static void radix(uint32_t first, uint32_t count)
{
    uint32_t hist[8][256];
    memset(hist, 0, sizeof(hist));
    uint64_t* k = keys + first;
    uint32_t* e = ents + first;
    uint64_t* k2 = keys2 + first;
    uint32_t* e2 = ents2 + first;
    for (uint32_t i = 0; i < count; i += 1)
    {
        const uint64_t v = k[i];
        for (uint32_t d = 0; d < 8; d += 1)
        {
            hist[d][(v >> (8 * d)) & 255] += 1;
        }
    }
    bool swapped = false;
    for (uint32_t d = 0; d < 8; d += 1)
    {
        if (hist[d][(k[0] >> (8 * d)) & 255] != count)
        {
            uint32_t sum = 0;
            for (uint32_t b = 0; b < 256; b += 1)
            {
                const uint32_t c = hist[d][b];
                hist[d][b] = sum;
                sum += c;
            }
            for (uint32_t i = 0; i < count; i += 1)
            {
                const uint32_t to = hist[d][(k[i] >> (8 * d)) & 255]++;
                k2[to] = k[i];
                e2[to] = e[i];
            }
            uint64_t* sk = k;
            k = k2;
            k2 = sk;
            uint32_t* se = e;
            e = e2;
            e2 = se;
            swapped = !swapped;
            c_passes += 1;
        }
    }
    if (swapped)
    {
        memcpy(keys + first, k, count * sizeof(uint64_t));
        memcpy(ents + first, e, count * sizeof(uint32_t));
    }
}

static void insertion(uint32_t first, uint32_t count)
{
    for (uint32_t i = first + 1; i < first + count; i += 1)
    {
        const uint64_t v = keys[i];
        const uint32_t x = ents[i];
        uint32_t j = i;
        while (j > first && keys[j - 1] > v)
        {
            keys[j] = keys[j - 1];
            ents[j] = ents[j - 1];
            j -= 1;
        }
        keys[j] = v;
        ents[j] = x;
    }
}

static void sort_range(uint32_t first, uint32_t count)
{
    if (count <= 32)
    {
        insertion(first, count);
    }
    else
    {
        radix(first, count);
    }
}

static uint64_t ticks(void)
{
    _mm_lfence();
    const uint64_t t = __rdtsc();
    _mm_lfence();
    return t;
}

static uint64_t* rkeys;
static uint32_t* work2;
static uint32_t strategy;

// Stable LSD radix sort of (k, e)[0, count) by bytes `from` to 7 that some key changes, through (k2, e2).
static void radix_keys(uint64_t* k, uint32_t* e, uint64_t* k2, uint32_t* e2, uint32_t count, uint32_t top)
{
    uint32_t hist[8][256];
    memset(hist, 0, sizeof(hist));
    for (uint32_t i = 0; i < count; i += 1)
    {
        const uint64_t v = k[i];
        for (uint32_t d = 0; d < top; d += 1)
        {
            hist[d][(v >> (8 * d)) & 255] += 1;
        }
    }
    uint64_t* k0 = k;
    uint32_t* e0 = e;
    for (uint32_t d = 0; d < top; d += 1)
    {
        if (hist[d][(k[0] >> (8 * d)) & 255] != count)
        {
            uint32_t sum = 0;
            for (uint32_t b = 0; b < 256; b += 1)
            {
                const uint32_t c = hist[d][b];
                hist[d][b] = sum;
                sum += c;
            }
            for (uint32_t i = 0; i < count; i += 1)
            {
                const uint32_t to = hist[d][(k[i] >> (8 * d)) & 255]++;
                k2[to] = k[i];
                e2[to] = e[i];
            }
            uint64_t* sk = k;
            k = k2;
            k2 = sk;
            uint32_t* se = e;
            e = e2;
            e2 = se;
            c_passes += 1;
        }
    }
    if (k != k0)
    {
        memcpy(k0, k, count * sizeof(uint64_t));
        memcpy(e0, e, count * sizeof(uint32_t));
    }
}

static void insertion_keys(uint64_t* k, uint32_t* e, uint32_t count)
{
    for (uint32_t i = 1; i < count; i += 1)
    {
        const uint64_t v = k[i];
        const uint32_t x = e[i];
        uint32_t j = i;
        while (j > 0 && k[j - 1] > v)
        {
            k[j] = k[j - 1];
            e[j] = e[j - 1];
            j -= 1;
        }
        k[j] = v;
        e[j] = x;
    }
}

static void sort_keys(uint64_t* k, uint32_t* e, uint64_t* k2, uint32_t* e2, uint32_t count)
{
    if (count <= 32)
    {
        insertion_keys(k, e, count);
    }
    else if (strategy == 0)
    {
        radix_keys(k, e, k2, e2, count, 8);
    }
    else
    {
        // MSD on the top byte, then each bucket by the rest.
        uint32_t hist[257];
        memset(hist, 0, sizeof(hist));
        for (uint32_t i = 0; i < count; i += 1)
        {
            hist[(k[i] >> 56) + 1] += 1;
        }
        for (uint32_t b = 0; b < 256; b += 1)
        {
            hist[b + 1] += hist[b];
        }
        uint32_t bounds[257];
        memcpy(bounds, hist, sizeof(bounds));
        for (uint32_t i = 0; i < count; i += 1)
        {
            const uint32_t to = hist[k[i] >> 56]++;
            k2[to] = k[i];
            e2[to] = e[i];
        }
        c_passes += 1;
        memcpy(k, k2, count * sizeof(uint64_t));
        memcpy(e, e2, count * sizeof(uint32_t));
        for (uint32_t b = 0; b < 256; b += 1)
        {
            const uint32_t first = bounds[b];
            const uint32_t size = bounds[b + 1] - first;
            if (size > 32)
            {
                radix_keys(k + first, e + first, k2 + first, e2 + first, size, 7);
            }
            else if (size > 1)
            {
                insertion_keys(k + first, e + first, size);
            }
        }
    }
}

static void precompute(void)
{
    uint64_t t0 = ticks();
    for (uint32_t i = 0; i < n; i += 1)
    {
        keys[i] = chunk(i, 0);
        ents[i] = i;
    }
    uint64_t t1 = ticks();
    phase_ticks[PHASE_KEYS] += t1 - t0;
    sort_keys(keys, ents, keys2, ents2, n);
    uint64_t t2 = ticks();
    phase_ticks[PHASE_SORT] += t2 - t1;
    // Runs tied on key0 with a member longer than 8 are sorted by chunk 1, their ties by chunk 2, and so on. key0
    // is constant across a run, so only ents move; rkeys hold a run's current chunk.
    uint32_t items = 0;
    uint32_t i = 0;
    while (i < n)
    {
        uint32_t j = i + 1;
        uint32_t longest = klen[ents[i]];
        while (j < n && keys[j] == keys[i])
        {
            longest = klen[ents[j]] > longest ? klen[ents[j]] : longest;
            j += 1;
        }
        if (j - i > 1 && longest > 8)
        {
            work[2 * items] = i;
            work[2 * items + 1] = j - i;
            items += 1;
        }
        i = j;
    }
    uint32_t* current = work;
    uint32_t* next = work2;
    for (uint32_t level = 1; items != 0; level += 1)
    {
        c_levels = level;
        uint32_t written = 0;
        for (uint32_t w = 0; w < items; w += 1)
        {
            const uint32_t first = current[2 * w];
            const uint32_t count = current[2 * w + 1];
            c_runs += 1;
            c_run_entries += count;
            c_max_run = count > c_max_run ? count : c_max_run;
            for (uint32_t q = first; q < first + count; q += 1)
            {
                rkeys[q] = chunk(ents[q], level);
                c_chunk_loads += 1;
            }
            sort_keys(rkeys + first, ents + first, keys2 + first, ents2 + first, count);
            uint32_t a = first;
            while (a < first + count)
            {
                uint32_t b = a + 1;
                uint32_t longest = klen[ents[a]];
                while (b < first + count && rkeys[b] == rkeys[a])
                {
                    longest = klen[ents[b]] > longest ? klen[ents[b]] : longest;
                    b += 1;
                }
                if (b - a > 1 && longest > 8 * (level + 1))
                {
                    next[2 * written] = a;
                    next[2 * written + 1] = b - a;
                    written += 1;
                }
                a = b;
            }
        }
        uint32_t* swap = current;
        current = next;
        next = swap;
        items = written;
    }
    uint64_t t3 = ticks();
    phase_ticks[PHASE_REFINE] += t3 - t2;
    // Classes and the lcp of adjacent classes: key0's xor where it differs, else chunk by chunk.
    nc = 0;
    for (uint32_t s = 0; s < n; s += 1)
    {
        const uint32_t e = ents[s];
        uint32_t common = 0;
        bool same = false;
        if (s != 0)
        {
            const uint32_t p = ents[s - 1];
            uint64_t x = keys[s - 1] ^ keys[s];
            uint32_t t = 0;
            const uint32_t shorter = klen[p] < klen[e] ? klen[p] : klen[e];
            while (x == 0 && 8 * (t + 1) < shorter)
            {
                t += 1;
                x = chunk(p, t) ^ chunk(e, t);
                c_chunk_loads += 2;
            }
            common = x != 0 ? 8 * t + ((uint32_t)__builtin_clzll(x) >> 3) : shorter;
            common = common < shorter ? common : shorter;
            same = klen[p] == klen[e] && common == klen[e];
        }
        if (!same)
        {
            cls_first[nc] = e;
            cls_of[e] = nc;
            cls_k[nc] = klen[e];
            cls_lcp[nc] = common;
            nc += 1;
        }
        else
        {
            cls_of[e] = nc - 1;
        }
    }
    uint64_t t4 = ticks();
    phase_ticks[PHASE_CLASSES] += t4 - t3;
    // Internal classes: the block runs while the next classes' lcp reaches the class's length; m' is the least first
    // entry in it. 16 classes a step.
    for (uint32_t c = 0; c < nc; c += 1)
    {
        uint32_t least = UINT32_MAX;
        if (c + 1 < nc && cls_lcp[c + 1] >= cls_k[c])
        {
            c_internal += 1;
            const __m512i k = _mm512_set1_epi32((int)cls_k[c]);
            __m512i mins = _mm512_set1_epi32(-1);
            bool open = true;
            uint32_t j = c + 1;
            uint32_t steps = 0;
            while (open)
            {
                const uint32_t left = nc - j;
                const __mmask16 valid = left >= 16 ? 0xffff : (__mmask16)((1u << left) - 1);
                const __m512i lcps = _mm512_maskz_loadu_epi32(valid, cls_lcp + j);
                const __mmask16 below = (__mmask16)(_mm512_mask_cmplt_epu32_mask(valid, lcps, k) | (__mmask16)~valid);
                const __mmask16 inside = below != 0 ? (__mmask16)((1u << __builtin_ctz(below)) - 1) : (__mmask16)0xffff;
                mins = _mm512_mask_min_epu32(mins, inside, mins, _mm512_maskz_loadu_epi32(inside, cls_first + j));
                steps += 1;
                open = below == 0;
                j += below != 0 ? (uint32_t)__builtin_ctz(below) : 16;
            }
            c_scan_vectors += steps;
            c_one_vector += steps == 1;
            least = _mm512_reduce_min_epu32(mins);
        }
        cls_mprime[c] = least;
    }
    uint64_t t5 = ticks();
    phase_ticks[PHASE_SCAN] += t5 - t4;
}

// main's whole-entry interning on the same entries (scalar link_hash: main hashes eight at a time, so this overstates
// its hash), and the design's loop over the precomputed classes, all alignments 1. Both return the pool size.
static uint64_t link_hash_finish(uint64_t hash)
{
    uint64_t result = (hash ^ (hash >> 30)) * 0xbf58476d1ce4e5b9ull;
    result = (result ^ (result >> 27)) * 0x94d049bb133111ebull;
    return result ^ (result >> 31);
}

static uint64_t link_hash(const uint8_t* bytes, uint64_t length)
{
    uint64_t hash = 0x243F6A8885A308D3ull ^ length;
    const uint64_t words = length == 0 ? 1 : (length + 7) / 8;
    for (uint64_t i = 0; i < words; i += 1)
    {
        const uint64_t offset = i * 8;
        const uint64_t take = length - offset < 8 ? length - offset : 8;
        uint64_t word = 0;
        if (take != 0)
        {
            memcpy(&word, bytes + offset, take);
        }
        hash = (hash ^ word) * 0x9E3779B97F4A7C15ull;
        hash ^= hash >> 32;
    }
    return link_hash_finish(hash);
}

static uint64_t* hashes;
static uint32_t* table;
static uint64_t slots;
static uint32_t* out;
static uint32_t* own_first;
static uint64_t ticks_main_hash, ticks_main_intern, ticks_design_loop;

static uint32_t main_intern(void)
{
    uint64_t t0 = ticks();
    for (uint32_t x = 0; x < n; x += 1)
    {
        hashes[x] = link_hash(base + begin[x], klen[x] + 1);
    }
    uint64_t t1 = ticks();
    memset(table, 0, slots * sizeof(uint32_t));
    uint32_t size = 0;
    for (uint32_t x = 0; x < n; x += 1)
    {
        const uint32_t length = klen[x] + 1;
        uint64_t slot = hashes[x] & (slots - 1);
        bool same = false;
        while (table[slot] != 0 && !same)
        {
            const uint32_t prior = table[slot] - 1;
            same = hashes[prior] == hashes[x] && klen[prior] == klen[x] && memcmp(base + begin[prior], base + begin[x], length) == 0;
            if (!same)
            {
                slot = (slot + 1) & (slots - 1);
            }
        }
        if (same)
        {
            out[x] = out[table[slot] - 1];
        }
        else
        {
            out[x] = size;
            size += length;
            table[slot] = x + 1;
        }
    }
    uint64_t t2 = ticks();
    ticks_main_hash += t1 - t0;
    ticks_main_intern += t2 - t1;
    return size;
}

// The design's loop for alignment 1: the class's own owner, else m' when it is earlier, else a new owner.
static uint32_t design_loop(void)
{
    uint64_t t1 = ticks();
    memset(own_first, 0xff, nc * sizeof(uint32_t));
    uint32_t size = 0;
    for (uint32_t x = 0; x < n; x += 1)
    {
        const uint32_t c = cls_of[x];
        const uint32_t length = klen[x] + 1;
        const uint32_t m = cls_mprime[c];
        if (own_first[c] != UINT32_MAX)
        {
            out[x] = own_first[c];
        }
        else if (m < x)
        {
            out[x] = out[m] + klen[m] - klen[x];
        }
        else
        {
            out[x] = size;
            own_first[c] = size;
            size += length;
        }
    }
    uint64_t t2 = ticks();
    ticks_design_loop += t2 - t1;
    return size;
}

static bool check(const char* path)
{
    char name[4096];
    snprintf(name, sizeof(name), "%s.model", path);
    FILE* f = fopen(name, "r");
    bool ok = f != 0;
    char word[16];
    for (uint32_t line = 0; ok && line < 3; line += 1)
    {
        ok = fscanf(f, "%15s", word) == 1;
        const uint32_t count = line == 0 ? n : nc;
        for (uint32_t i = 0; ok && i < count; i += 1)
        {
            long long v = 0;
            ok = fscanf(f, "%lld", &v) == 1;
            const long long mine = line == 0 ? (long long)ents[i] : line == 1 ? (long long)cls_lcp[i] : cls_mprime[i] == UINT32_MAX ? -1ll : (long long)cls_mprime[i];
            if (ok && v != mine)
            {
                printf("  differs: %s[%u] model %lld proto %lld\n", word, i, v, mine);
                ok = false;
            }
        }
    }
    long long extra = 0;
    ok = ok && fscanf(f, "%lld", &extra) != 1;
    if (f != 0)
    {
        fclose(f);
    }
    return ok;
}

int main(int argc, char** argv)
{
    if (argc < 3)
    {
        return 2;
    }
    FILE* f = fopen(argv[1], "rb");
    fseek(f, 0, SEEK_END);
    const long size = ftell(f);
    fseek(f, 0, SEEK_SET);
    uint8_t* data = malloc((size_t)size);
    if (fread(data, 1, (size_t)size, f) != (size_t)size)
    {
        return 1;
    }
    fclose(f);
    const uint32_t runs = (uint32_t)atoi(argv[2]);
    const size_t page = 4096;
    const size_t pages = ((size_t)size + page - 1) / page;
    uint8_t* map = mmap(0, (pages + 2) * page, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    n = 0;
    for (long i = 0; i < size; i += 1)
    {
        n += data[i] == 0;
    }
    begin = malloc((size_t)n * 4);
    klen = malloc((size_t)n * 4);
    keys = malloc((size_t)n * 8);
    keys2 = malloc((size_t)n * 8);
    ents = malloc((size_t)n * 4);
    ents2 = malloc((size_t)n * 4);
    cls_first = malloc((size_t)n * 4);
    cls_k = malloc((size_t)n * 4);
    cls_lcp = malloc((size_t)n * 4);
    cls_mprime = malloc((size_t)n * 4);
    work = malloc((size_t)n * 8 + 8);
    work2 = malloc((size_t)n * 8 + 8);
    rkeys = malloc((size_t)n * 8);
    slots = 1;
    while (slots < 2 * (uint64_t)n)
    {
        slots *= 2;
    }
    hashes = malloc((size_t)n * 8);
    table = malloc(slots * 4);
    out = malloc((size_t)n * 4);
    cls_of = malloc((size_t)n * 4);
    own_first = malloc((size_t)n * 4);
    strategy = argc > 3 ? (uint32_t)atoi(argv[3]) : 0;
    uint32_t e = 0;
    uint32_t start = 0;
    for (long i = 0; i < size; i += 1)
    {
        if (data[i] == 0)
        {
            begin[e] = start;
            klen[e] = (uint32_t)i - start;
            start = (uint32_t)i + 1;
            e += 1;
        }
    }
    bool all = true;
    for (uint32_t layout = 0; layout < 2; layout += 1)
    {
        mprotect(map, (pages + 2) * page, PROT_READ | PROT_WRITE);
        uint8_t* at = layout == 0 ? map + page : map + (pages + 1) * page - (size_t)size;
        memcpy(at, data, (size_t)size);
        mprotect(map, page, PROT_NONE);
        mprotect(map + (pages + 1) * page, page, PROT_NONE);
        base = at;
        uint64_t best[PHASE_COUNT];
        uint64_t best_total = UINT64_MAX;
        uint64_t best_main_hash = UINT64_MAX, best_main_intern = UINT64_MAX, best_design_loop = UINT64_MAX;
        uint32_t last_main = 0, last_design = 0;
        bool sizes_agree = true;
        for (uint32_t p = 0; p < PHASE_COUNT; p += 1)
        {
            best[p] = UINT64_MAX;
        }
        for (uint32_t r = 0; r < runs; r += 1)
        {
            c_passes = c_runs = c_run_entries = c_max_run = c_levels = c_chunk_loads = c_internal = c_scan_vectors = c_one_vector = 0;
            memset(phase_ticks, 0, sizeof(phase_ticks));
            precompute();
            ticks_main_hash = ticks_main_intern = ticks_design_loop = 0;
            const uint32_t main_size = main_intern();
            const uint32_t design_size = design_loop();
            sizes_agree = sizes_agree && main_size >= design_size;
            best_main_hash = ticks_main_hash < best_main_hash ? ticks_main_hash : best_main_hash;
            best_main_intern = ticks_main_intern < best_main_intern ? ticks_main_intern : best_main_intern;
            best_design_loop = ticks_design_loop < best_design_loop ? ticks_design_loop : best_design_loop;
            last_main = main_size;
            last_design = design_size;
            uint64_t total = 0;
            for (uint32_t p = 0; p < PHASE_COUNT; p += 1)
            {
                best[p] = phase_ticks[p] < best[p] ? phase_ticks[p] : best[p];
                total += phase_ticks[p];
            }
            best_total = total < best_total ? total : best_total;
        }
        const bool ok = check(argv[1]);
        all = all && ok;
        printf("%s layout %u: entries %u classes %u agree %d | best total %.1f TSC ticks/entry (", argv[1], layout, n, nc, ok, (double)best_total / n);
        for (uint32_t p = 0; p < PHASE_COUNT; p += 1)
        {
            printf("%s%s %.1f", p != 0 ? ", " : "", phase_names[p], (double)best[p] / n);
        }
        printf(") | radix passes %llu, tied runs %llu (entries %llu, largest %llu, levels %llu), chunk loads %llu, internal %llu (one-vector %llu), scan vectors %llu\n",
               (unsigned long long)c_passes, (unsigned long long)c_runs, (unsigned long long)c_run_entries, (unsigned long long)c_max_run,
               (unsigned long long)c_levels, (unsigned long long)c_chunk_loads, (unsigned long long)c_internal, (unsigned long long)c_one_vector,
               (unsigned long long)c_scan_vectors);
        printf("  main-like: hash %.1f + intern %.1f = %.1f ticks/entry (pool %u) | design: precompute %.1f + loop %.1f = %.1f ticks/entry (pool %u)\n",
               (double)best_main_hash / n, (double)best_main_intern / n, (double)(best_main_hash + best_main_intern) / n, last_main,
               (double)best_total / n, (double)best_design_loop / n, (double)(best_total + best_design_loop) / n, last_design);
    }
    return all ? 0 : 1;
}
