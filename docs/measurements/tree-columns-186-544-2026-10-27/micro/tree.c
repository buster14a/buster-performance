// Micro-benchmark of the tree's column derivations on a dumped parent array.
// cc -O3 -march=native tree.c -o tree && taskset -c 4 ./tree sqlite.parents.txt
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>

#define NONE UINT32_MAX
static uint64_t now(void)
{
    unsigned aux;
    return __rdtscp(&aux);
}
static uint64_t phase[4];

static uint32_t n;
static uint32_t* parents;

// main's parser passes (parse_postorder_sorted with sizes).
static void old_parser(uint32_t* last_children, uint32_t* ends, uint32_t* before, uint32_t* postorder, uint32_t* first_children, uint32_t* starts, uint32_t* sizes)
{
    uint32_t count = n;
    memset(last_children, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(before, 0, (uint64_t)count * sizeof(uint32_t));
    for (uint32_t i = 0; i < count; i += 1)
        last_children[parents[i] == NONE ? count : parents[i]] = i;
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t last = last_children[v];
        const uint32_t end = ends[last];
        const uint32_t own = __builtin_unpredictable(last > v) ? end : v;
        ends[v] = own;
        before[own] += 1;
    }
    uint32_t sum = 0;
    for (uint32_t i = 0; i < count; i += 1)
    {
        const uint32_t ending = before[i];
        before[i] = sum;
        sum += ending;
    }
    for (uint32_t v = 0; v < count; v += 1)
        postorder[before[v] + ends[v] - v] = v;
    if (sizes != 0)
    {
        for (uint32_t i = 0; i <= count; i += 1)
            first_children[i] = count;
        for (uint32_t i = count; i-- > 0;)
            first_children[parents[i] == NONE ? count : parents[i]] = i;
        for (uint32_t v = 0; v < count; v += 1)
        {
            const uint32_t first = first_children[v];
            const uint32_t start = starts[first < count ? first : 0];
            starts[v] = __builtin_unpredictable(first < v) ? start : v;
            sizes[before[v] + ends[v] - v] = ends[v] - starts[v] + 1;
        }
    }
}

// main's reader passes (parse_tree_links).
static void old_reader(const uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings)
{
    uint32_t count = n;
    for (uint32_t i = 0; i <= count; i += 1)
    {
        first_children[i] = NONE;
        next_siblings[i] = NONE;
        ends[i] = i;
    }
    for (uint32_t i = count; i-- > 0;)
    {
        const uint32_t parent = parents[i];
        if (parent < count)
        {
            next_siblings[i] = first_children[parent];
            first_children[parent] = i;
        }
    }
    for (uint32_t k = 0; k < count; k += 1)
    {
        const uint32_t token = postorder[k];
        positions[token] = k;
        const uint32_t parent = parents[token];
        if (parent < count && ends[parent] < ends[token])
            ends[parent] = ends[token];
    }
    positions[count] = count;
}

static void forward(uint32_t* before, uint32_t* postorder, uint32_t* positions, const uint32_t* ends)
{
    uint32_t sum = 0;
    for (uint32_t v = 0; v < n; v += 1)
    {
        const uint32_t position = sum + ends[v] - v;
        positions[v] = position;
        postorder[position] = v;
        sum += before[v];
    }
    positions[n] = n;
}

// v1: the first fused version (cmov'd store into ends for the pending end).
static void v1(uint32_t* before, uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings)
{
    uint32_t count = n;
    memset(first_children, 0xff, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(before, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t pending = ends[v];
        const uint32_t end = __builtin_unpredictable(first_children[v] != NONE) ? pending : v;
        ends[v] = end;
        before[end] += 1;
        const uint32_t parent = parents[v];
        const uint32_t slot = parent != NONE ? parent : count;
        const uint32_t sibling = first_children[slot];
        next_siblings[v] = parent != NONE ? sibling : NONE;
        ends[__builtin_unpredictable(sibling == NONE && parent < v) ? parent : count + 1] = end;
        first_children[slot] = v;
    }
    first_children[count] = NONE;
    next_siblings[count] = NONE;
    ends[count] = count;
    forward(before, postorder, positions, ends);
}

// v2: last children by a read-modify-write at the parent (an address known early), ends gathered from it.
static void v2(uint32_t* before, uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings, uint32_t* last)
{
    uint32_t count = n;
    memset(first_children, 0xff, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(before, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t f = first_children[v];
        const bool after = f != NONE;
        const uint32_t l = last[v];
        const uint32_t index = after ? l : v;
        const uint32_t e = ends[index];
        const uint32_t end = __builtin_unpredictable(after) ? e : v;
        ends[v] = end;
        before[end] += 1;
        const uint32_t parent = parents[v];
        const uint32_t slot = parent != NONE ? parent : count;
        const uint32_t sibling = first_children[slot];
        next_siblings[v] = parent != NONE ? sibling : NONE;
        const uint32_t old = last[slot];
        last[slot] = __builtin_unpredictable(sibling == NONE) ? v : old;
        first_children[slot] = v;
    }
    first_children[count] = NONE;
    next_siblings[count] = NONE;
    ends[count] = count;
    forward(before, postorder, positions, ends);
}

// v3: v2 with each end's count as the length of the chain of subtrees that end there: a plain store, no RMW.
static void v3(uint32_t* before, uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings, uint32_t* last,
               uint32_t* chains)
{
    uint32_t count = n;
    memset(first_children, 0xff, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(before, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t f = first_children[v];
        const bool after = f != NONE;
        const uint32_t l = last[v];
        const uint32_t index = after ? l : v;
        const uint32_t e = ends[index];
        const uint32_t c = chains[index];
        const uint32_t end = __builtin_unpredictable(after) ? e : v;
        const uint32_t chain = __builtin_unpredictable(after) ? c + 1 : 1;
        ends[v] = end;
        chains[v] = chain;
        before[end] = chain;
        const uint32_t parent = parents[v];
        const uint32_t slot = parent != NONE ? parent : count;
        const uint32_t sibling = first_children[slot];
        next_siblings[v] = parent != NONE ? sibling : NONE;
        const uint32_t old = last[slot];
        last[slot] = __builtin_unpredictable(sibling == NONE) ? v : old;
        first_children[slot] = v;
    }
    first_children[count] = NONE;
    next_siblings[count] = NONE;
    ends[count] = count;
    forward(before, postorder, positions, ends);
}

// v4: links alone first (backward), then ends and counts (backward), then forward.
static void v4(uint32_t* before, uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings, uint32_t* last)
{
    uint32_t count = n;
    uint64_t t0 = now();
    memset(first_children, 0xff, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(before, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    uint64_t t1 = now();
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t parent = parents[v];
        const uint32_t slot = parent != NONE ? parent : count;
        const uint32_t sibling = first_children[slot];
        next_siblings[v] = parent != NONE ? sibling : NONE;
        const uint32_t old = last[slot];
        last[slot] = __builtin_unpredictable(sibling == NONE) ? v : old;
        first_children[slot] = v;
    }
    first_children[count] = NONE;
    next_siblings[count] = NONE;
    uint64_t t2 = now();
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t l = last[v];
        const bool after = first_children[v] != NONE && l > v;
        const uint32_t e = ends[after ? l : v];
        const uint32_t end = __builtin_unpredictable(after) ? e : v;
        ends[v] = end;
        before[end] += 1;
    }
    ends[count] = count;
    uint64_t t3 = now();
    forward(before, postorder, positions, ends);
    uint64_t t4 = now();
    phase[0] += t1 - t0; phase[1] += t2 - t1; phase[2] += t3 - t2; phase[3] += t4 - t3;
}

// v5: v4's links, then the old parser's ends pass (last_children by forward scatter instead of RMW).
static void v5(uint32_t* before, uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings, uint32_t* last)
{
    uint32_t count = n;
    memset(first_children, 0xff, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(before, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(last, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    for (uint32_t i = 0; i < count; i += 1)
        last[parents[i] == NONE ? count : parents[i]] = i;
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t parent = parents[v];
        const uint32_t slot = parent != NONE ? parent : count;
        const uint32_t sibling = first_children[slot];
        next_siblings[v] = parent != NONE ? sibling : NONE;
        first_children[slot] = v;
        const uint32_t l = last[v];
        const uint32_t e = ends[l];
        const uint32_t end = __builtin_unpredictable(l > v) ? e : v;
        ends[v] = end;
        before[end] += 1;
    }
    first_children[count] = NONE;
    next_siblings[count] = NONE;
    ends[count] = count;
    forward(before, postorder, positions, ends);
}



// The forward pass in AVX-512: 16 tokens at a time, the counts' exclusive prefix sum in-register and the positions a
// vector store; the postorder by a scatter (scatter != 0) or by a scalar loop over the positions.
static void forward_avx512(uint32_t* counts, uint32_t* postorder, uint32_t* positions, const uint32_t* ends, bool scatter)
{
    const __m512i iota = _mm512_setr_epi32(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
    const __m512i last = _mm512_set1_epi32(15);
    const __m512i zero = _mm512_setzero_si512();
    __m512i carry = zero;
    uint32_t v = 0;
    for (; v + 16 <= n; v += 16)
    {
        const __m512i c = _mm512_loadu_si512(counts + v);
        __m512i s = c;
        s = _mm512_add_epi32(s, _mm512_alignr_epi32(s, zero, 15));
        s = _mm512_add_epi32(s, _mm512_alignr_epi32(s, zero, 14));
        s = _mm512_add_epi32(s, _mm512_alignr_epi32(s, zero, 12));
        s = _mm512_add_epi32(s, _mm512_alignr_epi32(s, zero, 8));
        const __m512i before = _mm512_add_epi32(carry, _mm512_sub_epi32(s, c));
        const __m512i tokens = _mm512_add_epi32(_mm512_set1_epi32((int)v), iota);
        const __m512i e = _mm512_loadu_si512(ends + v);
        const __m512i position = _mm512_sub_epi32(_mm512_add_epi32(before, e), tokens);
        _mm512_storeu_si512(positions + v, position);
        if (scatter)
        {
            _mm512_i32scatter_epi32(postorder, position, tokens, 4);
        }
        carry = _mm512_permutexvar_epi32(last, _mm512_add_epi32(carry, s));
    }
    uint32_t sum = (uint32_t)_mm_cvtsi128_si32(_mm512_castsi512_si128(carry));
    for (; v < n; v += 1)
    {
        const uint32_t ending = counts[v];
        const uint32_t position = sum + ends[v] - v;
        positions[v] = position;
        if (scatter) postorder[position] = v;
        sum += ending;
    }
    if (!scatter)
    {
        for (uint32_t t = 0; t < n; t += 1)
        {
            postorder[positions[t]] = t;
        }
    }
    positions[n] = n;
}

// v6: v4's links and ends, the counts kept in the positions column, then the AVX-512 forward pass (scatter or not).
static void v6(uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings, uint32_t* last, bool scatter)
{
    uint32_t count = n;
    memset(first_children, 0xff, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(positions, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t parent = parents[v];
        const uint32_t slot = parent != NONE ? parent : count;
        const uint32_t sibling = first_children[slot];
        next_siblings[v] = parent != NONE ? sibling : NONE;
        const uint32_t old = last[slot];
        last[slot] = __builtin_unpredictable(sibling == NONE) ? v : old;
        first_children[slot] = v;
    }
    first_children[count] = NONE;
    next_siblings[count] = NONE;
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t l = last[v];
        const bool after = first_children[v] != NONE && l > v;
        const uint32_t e = ends[after ? l : v];
        const uint32_t end = __builtin_unpredictable(after) ? e : v;
        ends[v] = end;
        positions[end] += 1;
    }
    ends[count] = count;
    forward_avx512(positions, postorder, positions, ends, scatter);
}

// v7: v1's single fused backward pass, the counts in the positions column, then the AVX-512 forward pass.
static void v7(uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings, bool scatter)
{
    uint32_t count = n;
    memset(first_children, 0xff, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(positions, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t pending = ends[v];
        const uint32_t end = __builtin_unpredictable(first_children[v] != NONE) ? pending : v;
        ends[v] = end;
        positions[end] += 1;
        const uint32_t parent = parents[v];
        const uint32_t slot = parent != NONE ? parent : count;
        const uint32_t sibling = first_children[slot];
        next_siblings[v] = parent != NONE ? sibling : NONE;
        ends[__builtin_unpredictable(sibling == NONE && parent < v) ? parent : count + 1] = end;
        first_children[slot] = v;
    }
    first_children[count] = NONE;
    next_siblings[count] = NONE;
    ends[count] = count;
    forward_avx512(positions, postorder, positions, ends, scatter);
}

// v8: v5's passes with the counts in the positions column, then the AVX-512 forward pass (scatter or scalar postorder).
static void v8(uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings, uint32_t* last, int forward_kind)
{
    uint32_t count = n;
    memset(first_children, 0xff, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(positions, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(last, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    for (uint32_t i = 0; i < count; i += 1)
        last[parents[i] == NONE ? count : parents[i]] = i;
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t parent = parents[v];
        const uint32_t slot = parent != NONE ? parent : count;
        const uint32_t sibling = first_children[slot];
        next_siblings[v] = parent != NONE ? sibling : NONE;
        first_children[slot] = v;
        const uint32_t l = last[v];
        const uint32_t e = ends[l];
        const uint32_t end = __builtin_unpredictable(l > v) ? e : v;
        ends[v] = end;
        positions[end] += 1;
    }
    first_children[count] = NONE;
    next_siblings[count] = NONE;
    ends[count] = count;
    if (forward_kind == 0)
    {
        uint32_t sum = 0;
        for (uint32_t v = 0; v < n; v += 1)
        {
            const uint32_t ending = positions[v];
            const uint32_t position = sum + ends[v] - v;
            positions[v] = position;
            postorder[position] = v;
            sum += ending;
        }
        positions[n] = n;
    }
    else
    {
        forward_avx512(positions, postorder, positions, ends, forward_kind == 1);
    }
}

// v9: v5 with the links pass split out again but last children by the forward scatter (three passes and the forward).
static void v9(uint32_t* before, uint32_t* postorder, uint32_t* positions, uint32_t* ends, uint32_t* first_children, uint32_t* next_siblings, uint32_t* last)
{
    uint32_t count = n;
    memset(first_children, 0xff, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(before, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    memset(last, 0, ((uint64_t)count + 1) * sizeof(uint32_t));
    for (uint32_t i = 0; i < count; i += 1)
        last[parents[i] == NONE ? count : parents[i]] = i;
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t l = last[v];
        const uint32_t e = ends[l];
        const uint32_t end = __builtin_unpredictable(l > v) ? e : v;
        ends[v] = end;
        before[end] += 1;
    }
    for (uint32_t v = count; v-- > 0;)
    {
        const uint32_t parent = parents[v];
        const uint32_t slot = parent != NONE ? parent : count;
        const uint32_t sibling = first_children[slot];
        next_siblings[v] = parent != NONE ? sibling : NONE;
        first_children[slot] = v;
    }
    first_children[count] = NONE;
    next_siblings[count] = NONE;
    ends[count] = count;
    forward(before, postorder, positions, ends);
}
static int cmp64(const void* a, const void* b)
{
    uint64_t x = *(const uint64_t*)a, y = *(const uint64_t*)b;
    return x < y ? -1 : x > y;
}

int main(int argc, char** argv)
{
    FILE* f = fopen(argv[1], "r");
    uint32_t cap = 1 << 21;
    parents = malloc(cap * 4);
    long a;
    long b;
    while (fscanf(f, "%ld %ld", &a, &b) == 2)
    {
        parents[n++] = b < 0 ? NONE : (uint32_t)b;
    }
    const uint64_t slots = (uint64_t)n + 256;
    uint32_t* arrays[16];
    for (int i = 0; i < 16; i += 1)
    {
        arrays[i] = aligned_alloc(64, slots * 4);
        memset(arrays[i], 0, slots * 4);
    }
    uint32_t* ref_post = arrays[0];
    uint32_t* ref_pos = arrays[1];
    uint32_t* ref_ends = arrays[2];
    uint32_t* ref_first = arrays[3];
    uint32_t* ref_next = arrays[4];
    uint32_t* t0 = arrays[5];
    uint32_t* t1 = arrays[6];
    uint32_t* t2 = arrays[7];
    uint32_t* t3 = arrays[8];
    uint32_t* t4 = arrays[9];
    uint32_t* post = arrays[10];
    uint32_t* pos = arrays[11];
    uint32_t* ends = arrays[12];
    uint32_t* first = arrays[13];
    uint32_t* next = arrays[14];
    uint32_t* sizes = arrays[15];
    // reference: old parser + old reader
    old_parser(t0, t1, t2, ref_post, t3, t4, sizes);
    old_reader(ref_post, ref_pos, ref_ends, ref_first, ref_next);
    const char* names[] = { "old parser+reader", "old parser only", "old reader only", "v1", "v2", "v3", "v4", "v5", "v6 scatter", "v6 scalar post", "v7 scatter", "v7 scalar post", "v8 scalar fwd", "v8 avx scatter", "v8 avx scalar post", "v9" };
    enum { RUNS = 31 };
    const int only = argc > 2 ? atoi(argv[2]) : -1;
    for (int which = 0; which < 16; which += 1)
    {
        if (only >= 0 && which != only) continue;
        uint64_t times[RUNS];
        for (int r = 0; r < RUNS; r += 1)
        {
            const uint64_t t = now();
            switch (which)
            {
                case 0: old_parser(t0, t1, t2, post, t3, t4, sizes); old_reader(post, pos, ends, first, next); break;
                case 1: old_parser(t0, t1, t2, post, t3, t4, sizes); break;
                case 2: old_reader(ref_post, pos, ends, first, next); break;
                case 3: v1(t0, post, pos, ends, first, next); break;
                case 4: v2(t0, post, pos, ends, first, next, t1); break;
                case 5: v3(t0, post, pos, ends, first, next, t1, t2); break;
                case 6: v4(t0, post, pos, ends, first, next, t1); break;
                case 7: v5(t0, post, pos, ends, first, next, t1); break;
                case 8: v6(post, pos, ends, first, next, t1, true); break;
                case 9: v6(post, pos, ends, first, next, t1, false); break;
                case 10: v7(post, pos, ends, first, next, true); break;
                case 11: v7(post, pos, ends, first, next, false); break;
                case 12: v8(post, pos, ends, first, next, t1, 0); break;
                case 13: v8(post, pos, ends, first, next, t1, 1); break;
                case 14: v8(post, pos, ends, first, next, t1, 2); break;
                case 15: v9(t0, post, pos, ends, first, next, t1); break;
            }
            times[r] = now() - t;
        }
        qsort(times, RUNS, 8, cmp64);
        bool same = true;
        if (which != 1)
        {
            same = memcmp(pos, ref_pos, ((uint64_t)n + 1) * 4) == 0 && memcmp(ends, ref_ends, ((uint64_t)n + 1) * 4) == 0 &&
                   memcmp(first, ref_first, ((uint64_t)n + 1) * 4) == 0 && memcmp(next, ref_next, ((uint64_t)n + 1) * 4) == 0 &&
                   memcmp(post, ref_post, (uint64_t)n * 4) == 0;
        }
        printf("%-20s %7.2f TSC ticks/token (min %7.2f) %s\n", names[which], (double)times[RUNS / 2] / n, (double)times[0] / n, same ? "same" : "DIFFERENT");
        if (which == 6) printf("   v4 phases: memsets %.2f links %.2f ends %.2f forward %.2f\n", (double)phase[0] / RUNS / n, (double)phase[1] / RUNS / n, (double)phase[2] / RUNS / n, (double)phase[3] / RUNS / n);
    }
    return 0;
}
