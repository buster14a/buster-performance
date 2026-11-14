// splice_rule_bench.c: #2541 step 3's rule for the splice's caller's own operands (docs/tier1-unit-inlining.md, "The
// splice's columns": "the caller's own operands move by a step function of the sites before them: K masked adds for a
// few sites, a gather through the destination table for many; which, by K, is measured"). A caller of N nodes in B
// blocks with K expanded sites (sorted node positions, each growing the caller by a callee's nodes and splitting its
// block), its operand columns as ir_inline_copy_run reads them: an operation byte a node, three operand words, each
// operand's kind fixed by its operation (a value, an optional value, a block or kept). Each node's new operands, 16
// nodes a vector, by three forms:
//   gather   step 1's (ir_inline_copy_run): a value through the destination table `values`, a block through
//            `block_first`, two masked gathers a column;
//   adds     for each site before the vector's last node, a compare and a masked add of its growth to the values
//            after it, and the site's own value replaced by its result's place; blocks by the same over the sites' blocks;
//   all      the same over every site, as the splice must (an operand may name a value laid out after its use);
//   permute  K <= 16: each operand's rank among the sites by K compares and masked subtractions, then its shift by one
//            vpermd of the K + 1 cumulative growths (values; blocks the same), the sites' results by K compares.
// Every form's columns are checked against the scalar loop's before any timing. Prints the fastest of RUNS repetitions
// (rdtsc) per node. cc -O2 -march=native -o splice_rule_bench splice_rule_bench.c; taskset -c 2 ./splice_rule_bench
#define _GNU_SOURCE
#include <immintrin.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>

enum
{
    RUNS = 401,
    KIND_KEEP = 0,
    KIND_VALUE = 1,
    KIND_OPTIONAL = 2,
    KIND_BLOCK = 3,
    OPS = 64,
    NONE = 0xffffffffu,
};

typedef struct
{
    uint32_t n;
    uint32_t blocks;
    uint32_t k;
    uint8_t* op;
    uint32_t* in[3];
    uint32_t* out[3];
    uint32_t* values;       // by old node: its new place (a site: its result's)
    uint32_t* block_first;  // by old block: its first part's new index
    uint32_t* site_node;    // by site, ascending
    uint32_t* site_growth;  // by site: the nodes its expansion adds
    uint32_t* site_result;  // by site: its result's new place
    uint32_t* site_block;   // by site: its old block
    uint32_t* site_blocks;  // by site: the blocks its expansion adds (its callee's plus one)
    uint8_t kinds[3][OPS];
} Caller;

static uint64_t state = 0x9e3779b97f4a7c15u;
static uint32_t next_random(void)
{
    state ^= state << 13;
    state ^= state >> 7;
    state ^= state << 17;
    return (uint32_t)(state >> 11);
}

static int compare_u32(const void* x, const void* y)
{
    const uint32_t a = *(const uint32_t*)x;
    const uint32_t b = *(const uint32_t*)y;
    return a < b ? -1 : a > b ? 1 : 0;
}

// Operations 0..63: 0-39 two values and a kept word (arithmetic), 40-47 a value and two kept (loads, casts), 48-51 a
// branch (a block), 52-55 a conditional branch (a value, two blocks), 56-59 an optional value (a return), 60-63 none.
static void caller_build(Caller* c, uint32_t n, uint32_t k)
{
    memset(c, 0, sizeof(*c));
    c->n = n;
    c->k = k;
    c->blocks = n / 8 + 1;
    for (uint32_t o = 0; o < OPS; o += 1)
    {
        c->kinds[0][o] = o < 48 ? KIND_VALUE : o < 52 ? KIND_BLOCK : o < 56 ? KIND_VALUE : o < 60 ? KIND_OPTIONAL : KIND_KEEP;
        c->kinds[1][o] = o < 40 ? KIND_VALUE : o < 52 ? KIND_KEEP : o < 56 ? KIND_BLOCK : KIND_KEEP;
        c->kinds[2][o] = o >= 52 && o < 56 ? KIND_BLOCK : KIND_KEEP;
    }
    c->op = malloc(n + 64);
    for (int i = 0; i < 3; i += 1)
    {
        c->in[i] = malloc(4 * (size_t)n + 64);
        c->out[i] = malloc(4 * (size_t)n + 64);
    }
    c->values = malloc(4 * (size_t)n + 64);
    c->block_first = malloc(4 * (size_t)c->blocks + 64);
    c->site_node = malloc(4 * (size_t)k + 64);
    c->site_growth = malloc(4 * (size_t)k + 64);
    c->site_result = malloc(4 * (size_t)k + 64);
    c->site_block = malloc(4 * (size_t)k + 64);
    c->site_blocks = malloc(4 * (size_t)k + 64);
    // K distinct site positions.
    uint8_t* taken = calloc(n, 1);
    for (uint32_t s = 0; s < k; s += 1)
    {
        uint32_t p;
        do
        {
            p = 1 + next_random() % (n - 1);
        } while (taken[p]);
        taken[p] = 1;
        c->site_node[s] = p;
    }
    qsort(c->site_node, k, 4, compare_u32);
    // The destination tables, as the rewrite computes them: a node moves by the growth of the sites before it; a site's
    // value is its result's place, the last node of its expansion.
    uint32_t shift = 0;
    uint32_t s = 0;
    for (uint32_t v = 0; v < n; v += 1)
    {
        if (s < k && c->site_node[s] == v)
        {
            c->site_growth[s] = 4 + next_random() % 60;
            c->site_result[s] = v + shift + c->site_growth[s];
            c->values[v] = c->site_result[s];
            c->site_block[s] = v / 8;
            c->site_blocks[s] = 2 + next_random() % 6;
            shift += c->site_growth[s];
            s += 1;
        }
        else
        {
            c->values[v] = v + shift;
        }
    }
    uint32_t block_shift = 0;
    s = 0;
    for (uint32_t b = 0; b < c->blocks; b += 1)
    {
        c->block_first[b] = b + block_shift;
        while (s < k && c->site_block[s] == b)
        {
            block_shift += c->site_blocks[s];
            s += 1;
        }
    }
    // Operations and operands: values mostly near (the last 16 nodes), a fifth anywhere before; blocks anywhere.
    for (uint32_t v = 0; v < n; v += 1)
    {
        const uint32_t r = next_random() % 100;
        c->op[v] = (uint8_t)(r < 60 ? next_random() % 40 : r < 80 ? 40 + next_random() % 8 : r < 84 ? 48 + next_random() % 4 : r < 92 ? 52 + next_random() % 4 : r < 96 ? 56 + next_random() % 4 : 60 + next_random() % 4);
        for (int i = 0; i < 3; i += 1)
        {
            const uint8_t kind = c->kinds[i][c->op[v]];
            uint32_t operand = next_random();
            if (kind == KIND_VALUE || (kind == KIND_OPTIONAL && (next_random() & 1)))
            {
                const uint32_t before = v == 0 ? 1 : v;
                operand = next_random() % 5 == 0 ? next_random() % before : (v > 16 ? v - 1 - next_random() % 16 : next_random() % before);
            }
            else if (kind == KIND_OPTIONAL)
            {
                operand = NONE;
            }
            else if (kind == KIND_BLOCK)
            {
                operand = next_random() % c->blocks;
            }
            c->in[i][v] = operand;
        }
    }
    free(taken);
}

static void form_scalar(const Caller* c)
{
    for (uint32_t v = 0; v < c->n; v += 1)
    {
        for (int i = 0; i < 3; i += 1)
        {
            const uint8_t kind = c->kinds[i][c->op[v]];
            const uint32_t operand = c->in[i][v];
            uint32_t result = operand;
            if (kind == KIND_VALUE || (kind == KIND_OPTIONAL && operand != NONE))
            {
                result = c->values[operand];
            }
            else if (kind == KIND_BLOCK)
            {
                result = c->block_first[operand];
            }
            c->out[i][v] = result;
        }
    }
}

static inline __m512i kinds_of(const Caller* c, int column, __m128i op)
{
    const __m512i table = _mm512_loadu_si512(c->kinds[column]);
    return _mm512_cvtepu8_epi32(_mm512_castsi512_si128(_mm512_permutexvar_epi8(_mm512_castsi128_si512(op), table)));
}

static void form_gather(const Caller* c)
{
    const __m512i none = _mm512_set1_epi32((int32_t)NONE);
    for (uint32_t i = 0; i < c->n; i += 16)
    {
        const uint32_t remaining = c->n - i;
        const __mmask16 mask = remaining >= 16 ? (__mmask16)0xffff : (__mmask16)((1u << remaining) - 1);
        const __m128i op = _mm_maskz_loadu_epi8(mask, c->op + i);
        for (int column = 0; column < 3; column += 1)
        {
            const __m512i kind = kinds_of(c, column, op);
            const __m512i operand = _mm512_maskz_loadu_epi32(mask, c->in[column] + i);
            const __mmask16 optional = _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_OPTIONAL)) & _mm512_cmpneq_epi32_mask(operand, none);
            const __mmask16 value = mask & (_mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_VALUE)) | optional);
            const __mmask16 target = mask & _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_BLOCK));
            __m512i rebased = _mm512_mask_i32gather_epi32(operand, value, operand, (const int*)c->values, 4);
            rebased = _mm512_mask_i32gather_epi32(rebased, target, operand, (const int*)c->block_first, 4);
            _mm512_mask_storeu_epi32(c->out[column] + i, mask, rebased);
        }
    }
}

static void form_adds(const Caller* c)
{
    const __m512i none = _mm512_set1_epi32((int32_t)NONE);
    for (uint32_t i = 0; i < c->n; i += 16)
    {
        const uint32_t remaining = c->n - i;
        const __mmask16 mask = remaining >= 16 ? (__mmask16)0xffff : (__mmask16)((1u << remaining) - 1);
        const __m128i op = _mm_maskz_loadu_epi8(mask, c->op + i);
        for (int column = 0; column < 3; column += 1)
        {
            const __m512i kind = kinds_of(c, column, op);
            const __m512i operand = _mm512_maskz_loadu_epi32(mask, c->in[column] + i);
            const __mmask16 optional = _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_OPTIONAL)) & _mm512_cmpneq_epi32_mask(operand, none);
            const __mmask16 value = mask & (_mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_VALUE)) | optional);
            const __mmask16 target = mask & _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_BLOCK));
            __m512i rebased = operand;
            if (value != 0)
            {
                // Sites only before the run's last node can move its operands, which name earlier nodes.
                for (uint32_t s = 0; s < c->k && c->site_node[s] < i + 16; s += 1)
                {
                    const __m512i site = _mm512_set1_epi32((int32_t)c->site_node[s]);
                    const __mmask16 after = value & _mm512_cmpgt_epu32_mask(operand, site);
                    const __mmask16 at = value & _mm512_cmpeq_epi32_mask(operand, site);
                    rebased = _mm512_mask_add_epi32(rebased, after, rebased, _mm512_set1_epi32((int32_t)c->site_growth[s]));
                    rebased = _mm512_mask_mov_epi32(rebased, at, _mm512_set1_epi32((int32_t)c->site_result[s]));
                }
            }
            if (target != 0)
            {
                for (uint32_t s = 0; s < c->k; s += 1)
                {
                    const __mmask16 after = target & _mm512_cmpgt_epu32_mask(operand, _mm512_set1_epi32((int32_t)c->site_block[s]));
                    rebased = _mm512_mask_add_epi32(rebased, after, rebased, _mm512_set1_epi32((int32_t)c->site_blocks[s]));
                }
            }
            _mm512_mask_storeu_epi32(c->out[column] + i, mask, rebased);
        }
    }
}

static void form_adds_all(const Caller* c)
{
    const __m512i none = _mm512_set1_epi32((int32_t)NONE);
    for (uint32_t i = 0; i < c->n; i += 16)
    {
        const uint32_t remaining = c->n - i;
        const __mmask16 mask = remaining >= 16 ? (__mmask16)0xffff : (__mmask16)((1u << remaining) - 1);
        const __m128i op = _mm_maskz_loadu_epi8(mask, c->op + i);
        for (int column = 0; column < 3; column += 1)
        {
            const __m512i kind = kinds_of(c, column, op);
            const __m512i operand = _mm512_maskz_loadu_epi32(mask, c->in[column] + i);
            const __mmask16 optional = _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_OPTIONAL)) & _mm512_cmpneq_epi32_mask(operand, none);
            const __mmask16 value = mask & (_mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_VALUE)) | optional);
            const __mmask16 target = mask & _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_BLOCK));
            __m512i rebased = operand;
            if (value != 0)
            {
                // Every site: an operand may name a value placed after its use (layout is not dominance order).
                for (uint32_t s = 0; s < c->k; s += 1)
                {
                    const __m512i site = _mm512_set1_epi32((int32_t)c->site_node[s]);
                    const __mmask16 after = value & _mm512_cmpgt_epu32_mask(operand, site);
                    const __mmask16 at = value & _mm512_cmpeq_epi32_mask(operand, site);
                    rebased = _mm512_mask_add_epi32(rebased, after, rebased, _mm512_set1_epi32((int32_t)c->site_growth[s]));
                    rebased = _mm512_mask_mov_epi32(rebased, at, _mm512_set1_epi32((int32_t)c->site_result[s]));
                }
            }
            if (target != 0)
            {
                for (uint32_t s = 0; s < c->k; s += 1)
                {
                    const __mmask16 after = target & _mm512_cmpgt_epu32_mask(operand, _mm512_set1_epi32((int32_t)c->site_block[s]));
                    rebased = _mm512_mask_add_epi32(rebased, after, rebased, _mm512_set1_epi32((int32_t)c->site_blocks[s]));
                }
            }
            _mm512_mask_storeu_epi32(c->out[column] + i, mask, rebased);
        }
    }
}

// K <= 16: the cumulative growths by rank in one register each (values and blocks), the results' places by site.
static void form_permute(const Caller* c)
{
    const __m512i none = _mm512_set1_epi32((int32_t)NONE);
    uint32_t value_shift[16] = { 0 };
    uint32_t block_shift[16] = { 0 };
    for (uint32_t s = 0; s < c->k && s < 15; s += 1)
    {
        value_shift[s + 1] = value_shift[s] + c->site_growth[s];
        block_shift[s + 1] = block_shift[s] + c->site_blocks[s];
    }
    const __m512i shifts = _mm512_loadu_si512(value_shift);
    const __m512i block_shifts = _mm512_loadu_si512(block_shift);
    for (uint32_t i = 0; i < c->n; i += 16)
    {
        const uint32_t remaining = c->n - i;
        const __mmask16 mask = remaining >= 16 ? (__mmask16)0xffff : (__mmask16)((1u << remaining) - 1);
        const __m128i op = _mm_maskz_loadu_epi8(mask, c->op + i);
        for (int column = 0; column < 3; column += 1)
        {
            const __m512i kind = kinds_of(c, column, op);
            const __m512i operand = _mm512_maskz_loadu_epi32(mask, c->in[column] + i);
            const __mmask16 optional = _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_OPTIONAL)) & _mm512_cmpneq_epi32_mask(operand, none);
            const __mmask16 value = mask & (_mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_VALUE)) | optional);
            const __mmask16 target = mask & _mm512_cmpeq_epi32_mask(kind, _mm512_set1_epi32(KIND_BLOCK));
            __m512i rebased = operand;
            if (value != 0)
            {
                __m512i rank = _mm512_setzero_si512();
                __mmask16 at_any = 0;
                __m512i result = _mm512_setzero_si512();
                for (uint32_t s = 0; s < c->k && c->site_node[s] < i + 16; s += 1)
                {
                    const __m512i site = _mm512_set1_epi32((int32_t)c->site_node[s]);
                    rank = _mm512_mask_sub_epi32(rank, _mm512_cmpgt_epu32_mask(operand, site), rank, _mm512_set1_epi32(-1));
                    const __mmask16 at = _mm512_cmpeq_epi32_mask(operand, site);
                    result = _mm512_mask_mov_epi32(result, at, _mm512_set1_epi32((int32_t)c->site_result[s]));
                    at_any |= at;
                }
                rebased = _mm512_mask_add_epi32(rebased, value, operand, _mm512_permutexvar_epi32(rank, shifts));
                rebased = _mm512_mask_mov_epi32(rebased, value & at_any, result);
            }
            if (target != 0)
            {
                __m512i rank = _mm512_setzero_si512();
                for (uint32_t s = 0; s < c->k; s += 1)
                {
                    rank = _mm512_mask_sub_epi32(rank, _mm512_cmpgt_epu32_mask(operand, _mm512_set1_epi32((int32_t)c->site_block[s])), rank, _mm512_set1_epi32(-1));
                }
                rebased = _mm512_mask_add_epi32(rebased, target, operand, _mm512_permutexvar_epi32(rank, block_shifts));
            }
            _mm512_mask_storeu_epi32(c->out[column] + i, mask, rebased);
        }
    }
}

typedef void (*Form)(const Caller*);

static uint64_t best_of(Form form, const Caller* c)
{
    uint64_t best = UINT64_MAX;
    for (uint32_t r = 0; r < RUNS; r += 1)
    {
        const uint64_t start = __rdtsc();
        form(c);
        __asm__ __volatile__("" ::: "memory");
        const uint64_t cycles = __rdtsc() - start;
        best = cycles < best ? cycles : best;
    }
    return best;
}

static bool same_as_scalar(Form form, Caller* c, uint32_t** expected)
{
    for (int i = 0; i < 3; i += 1)
    {
        memset(c->out[i], 0xab, 4 * (size_t)c->n);
    }
    form(c);
    bool same = true;
    for (int i = 0; i < 3; i += 1)
    {
        same = same && memcmp(c->out[i], expected[i], 4 * (size_t)c->n) == 0;
    }
    return same;
}

int main(void)
{
    const uint32_t sizes[] = { 64, 256, 1024, 4096 };
    const uint32_t sites[] = { 1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 64 };
    printf("nodes\tsites\tgather\tadds\tall\tpermute\t(cycles a node; tsc)\n");
    int failures = 0;
    for (uint32_t z = 0; z < sizeof(sizes) / sizeof(sizes[0]); z += 1)
    {
        for (uint32_t q = 0; q < sizeof(sites) / sizeof(sites[0]); q += 1)
        {
            const uint32_t n = sizes[z];
            const uint32_t k = sites[q];
            if (k * 2 > n)
            {
                continue;
            }
            Caller c;
            caller_build(&c, n, k);
            form_scalar(&c);
            uint32_t* expected[3];
            for (int i = 0; i < 3; i += 1)
            {
                expected[i] = malloc(4 * (size_t)n);
                memcpy(expected[i], c.out[i], 4 * (size_t)n);
            }
            const bool gather_same = same_as_scalar(form_gather, &c, expected);
            const bool adds_same = same_as_scalar(form_adds, &c, expected) && same_as_scalar(form_adds_all, &c, expected);
            const bool permute_same = k > 15 || same_as_scalar(form_permute, &c, expected);
            failures += !gather_same + !adds_same + !permute_same;
            const double gather = (double)best_of(form_gather, &c) / n;
            const double adds = (double)best_of(form_adds, &c) / n;
            const double all = (double)best_of(form_adds_all, &c) / n;
            const double permute = k <= 15 ? (double)best_of(form_permute, &c) / n : 0.0;
            printf("%u\t%u\t%.3f\t%.3f\t%.3f\t%.3f%s\n", n, k, gather, adds, all, permute, gather_same && adds_same && permute_same ? "" : "\tDIFFERENT");
            for (int i = 0; i < 3; i += 1)
            {
                free(expected[i]);
            }
        }
    }
    printf("failures %d\n", failures);
    return failures != 0;
}
