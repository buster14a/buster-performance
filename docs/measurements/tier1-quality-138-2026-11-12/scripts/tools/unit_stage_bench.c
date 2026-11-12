// unit_stage_bench.c: what the unit stage's two kernels cost on the 9700X, each by its ordered (scalar) and its
// data-parallel form: (1) the call graph's components and levels, on a program's real static call graph (EDGES: a
// "functions N" line, then one "caller callee" line of function indices per distinct direct call edge, as
// tools/call_edges.py writes it from a disassembly), by Tarjan's traversal plus one sweep, and by level-synchronous
// rounds (a gather of each remaining edge's callee's state, a scatter to its caller, 16 edges a vector); (2) the
// splice's operand rebase, on synthetic columns of N nodes (an operation byte and three operand words a node, each
// operand's kind fixed by its operation: immediate, value, block or one of four tables' rows), an operand at a time
// through the kind table, and 64 operations a vector (vpermi2b through the kind table, vpermd of the bases, vpaddd).
// Each form's result is checked against the other's before any timing. Prints cycles (rdtsc, the fastest of RUNS
// repetitions) per run and per item. cc -O2 -march=native -o unit_stage_bench unit_stage_bench.c; taskset -c 2
// ./unit_stage_bench EDGES...
#define _GNU_SOURCE
#include <immintrin.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <x86intrin.h>

enum { RUNS = 2001 };

typedef struct
{
    uint32_t count;
    uint32_t edge_count;
    uint32_t* first;   // CSR by caller: first[f] .. first[f + 1]
    uint32_t* callee;  // by edge
    uint32_t* caller;  // by edge
} Graph;

static Graph graph_read(const char* path)
{
    Graph g = { 0 };
    FILE* file = fopen(path, "r");
    if (file == NULL || fscanf(file, "functions %u", &g.count) != 1) { fprintf(stderr, "cannot read %s\n", path); exit(2); }
    uint32_t capacity = 1u << 16;
    uint32_t* from = malloc(capacity * sizeof(uint32_t));
    uint32_t* to = malloc(capacity * sizeof(uint32_t));
    uint32_t a, b;
    while (fscanf(file, "%u %u", &a, &b) == 2)
    {
        if (g.edge_count == capacity) { capacity *= 2; from = realloc(from, capacity * sizeof(uint32_t)); to = realloc(to, capacity * sizeof(uint32_t)); }
        from[g.edge_count] = a; to[g.edge_count] = b; g.edge_count += 1;
    }
    fclose(file);
    g.first = calloc(g.count + 1, sizeof(uint32_t));
    g.callee = aligned_alloc(64, ((size_t)g.edge_count + 16) * sizeof(uint32_t) / 64 * 64 + 64);
    g.caller = aligned_alloc(64, ((size_t)g.edge_count + 16) * sizeof(uint32_t) / 64 * 64 + 64);
    for (uint32_t e = 0; e < g.edge_count; e += 1) g.first[from[e] + 1] += 1;
    for (uint32_t f = 0; f < g.count; f += 1) g.first[f + 1] += g.first[f];
    uint32_t* at = malloc(g.count * sizeof(uint32_t));
    memcpy(at, g.first, g.count * sizeof(uint32_t));
    for (uint32_t e = 0; e < g.edge_count; e += 1) { g.callee[at[from[e]]] = to[e]; g.caller[at[from[e]]] = from[e]; at[from[e]] += 1; }
    free(at); free(from); free(to);
    return g;
}

// Tarjan's components, iterative, then levels in component order (callees' components are numbered first): a
// function's level is one above its highest callee's, and UINT32_MAX in a cycle or above one. Returns the level count.
static uint32_t levels_tarjan(const Graph* g, uint32_t* level, uint32_t* index, uint32_t* low, uint32_t* stack, uint32_t* work, uint32_t* edge, uint8_t* on)
{
    uint32_t counter = 0, depth = 0, top = 0, highest = 0;
    memset(index, 0xff, g->count * sizeof(uint32_t));
    memset(on, 0, g->count);
    for (uint32_t root = 0; root < g->count; root += 1)
    {
        if (index[root] != UINT32_MAX) continue;
        work[0] = root; edge[0] = g->first[root]; depth = 1;
        index[root] = low[root] = counter++; stack[top++] = root; on[root] = 1;
        while (depth != 0)
        {
            const uint32_t node = work[depth - 1];
            if (edge[depth - 1] < g->first[node + 1])
            {
                const uint32_t next = g->callee[edge[depth - 1]++];
                if (index[next] == UINT32_MAX)
                {
                    index[next] = low[next] = counter++; stack[top++] = next; on[next] = 1;
                    work[depth] = next; edge[depth] = g->first[next]; depth += 1;
                }
                else if (on[next] && index[next] < low[node]) low[node] = index[next];
            }
            else
            {
                depth -= 1;
                if (depth != 0 && low[node] < low[work[depth - 1]]) low[work[depth - 1]] = low[node];
                if (low[node] == index[node])
                {
                    // The component's members: one function outside a cycle, or a cycle.
                    const uint32_t start = top;
                    uint32_t member;
                    do { member = stack[--top]; on[member] = 0; } while (member != node);
                    bool cyclic = start - top > 1;
                    uint32_t own = 0;
                    for (uint32_t e = g->first[node]; !cyclic && e < g->first[node + 1]; e += 1)
                    {
                        const uint32_t c = g->callee[e];
                        cyclic = c == node || level[c] == UINT32_MAX;
                        own = !cyclic && level[c] + 1 > own ? level[c] + 1 : own;
                    }
                    for (uint32_t k = top; k < start; k += 1) level[stack[k]] = cyclic ? UINT32_MAX : own;
                    highest = !cyclic && own > highest ? own : highest;
                }
            }
        }
    }
    return highest + 1;
}

// Level-synchronous rounds over the edges that still wait: an edge waits while its callee has no level; a function
// with no waiting edge gets the round's level. Each round gathers the callees' states, compresses the waiting edges
// in place and scatters a mark to their callers. What never gets a level is in a cycle or above one.
static uint32_t levels_rounds(const Graph* g, uint32_t* level, uint32_t* wait_callee, uint32_t* wait_caller, uint32_t* pending, uint32_t* open, uint32_t* open_next)
{
    memset(level, 0xff, g->count * sizeof(uint32_t));
    memcpy(wait_callee, g->callee, g->edge_count * sizeof(uint32_t));
    memcpy(wait_caller, g->caller, g->edge_count * sizeof(uint32_t));
    uint32_t waiting = g->edge_count, open_count = g->count, round = 0, assigned = 1;
    for (uint32_t f = 0; f < g->count; f += 1) open[f] = f;
    const __m512i ones = _mm512_set1_epi32(1);
    const __m512i none = _mm512_set1_epi32(-1);
    while (assigned != 0)
    {
        memset(pending, 0, g->count * sizeof(uint32_t));
        uint32_t kept = 0;
        for (uint32_t e = 0; e < waiting; e += 16)
        {
            const __mmask16 live = (__mmask16)(waiting - e >= 16 ? 0xffff : (1u << (waiting - e)) - 1);
            const __m512i callees = _mm512_maskz_loadu_epi32(live, wait_callee + e);
            const __m512i callers = _mm512_maskz_loadu_epi32(live, wait_caller + e);
            const __m512i states = _mm512_mask_i32gather_epi32(none, live, callees, level, 4);
            const __mmask16 still = _mm512_mask_cmpeq_epi32_mask(live, states, none);
            _mm512_mask_i32scatter_epi32(pending, still, callers, ones, 4);
            _mm512_mask_compressstoreu_epi32(wait_callee + kept, still, callees);
            _mm512_mask_compressstoreu_epi32(wait_caller + kept, still, callers);
            kept += (uint32_t)__builtin_popcount(still);
        }
        waiting = kept;
        assigned = 0;
        uint32_t next = 0;
        for (uint32_t k = 0; k < open_count; k += 1)
        {
            const uint32_t f = open[k];
            if (pending[f] == 0) { level[f] = round; assigned += 1; }
            else open_next[next++] = f;
        }
        memcpy(open, open_next, next * sizeof(uint32_t));
        open_count = next;
        round += 1;
    }
    return round - 1;
}

enum { KINDS = 8, OPS = 128 };

static void rebase_scalar(uint32_t n, const uint8_t* op, const uint32_t* a, const uint32_t* b, const uint32_t* c, uint32_t* oa, uint32_t* ob, uint32_t* oc,
                          const uint8_t kinds[3][OPS], const uint32_t base[16])
{
    for (uint32_t i = 0; i < n; i += 1)
    {
        oa[i] = a[i] + base[kinds[0][op[i]]];
        ob[i] = b[i] + base[kinds[1][op[i]]];
        oc[i] = c[i] + base[kinds[2][op[i]]];
    }
}

static void rebase_vector(uint32_t n, const uint8_t* op, const uint32_t* a, const uint32_t* b, const uint32_t* c, uint32_t* oa, uint32_t* ob, uint32_t* oc,
                          const uint8_t kinds[3][OPS], const uint32_t base[16])
{
    const __m512i bases = _mm512_loadu_si512(base);
    const uint32_t* in[3] = { a, b, c };
    uint32_t* out[3] = { oa, ob, oc };
    for (uint32_t i = 0; i < n; i += 64)
    {
        const uint32_t left = n - i;
        const __mmask64 live = left >= 64 ? ~UINT64_C(0) : (UINT64_C(1) << left) - 1;
        const __m512i ops = _mm512_maskz_loadu_epi8(live, op + i);
        for (uint32_t column = 0; column < 3; column += 1)
        {
            const __m512i kind = _mm512_permutex2var_epi8(_mm512_loadu_si512(kinds[column]), ops, _mm512_loadu_si512(kinds[column] + 64));
            const __m128i quarters[4] = { _mm512_extracti32x4_epi32(kind, 0), _mm512_extracti32x4_epi32(kind, 1), _mm512_extracti32x4_epi32(kind, 2), _mm512_extracti32x4_epi32(kind, 3) };
            for (uint32_t q = 0; q < 4 && i + 16 * q < n; q += 1)
            {
                const __mmask16 part = (__mmask16)(live >> (16 * q));
                const __m512i wide = _mm512_cvtepu8_epi32(quarters[q]);
                const __m512i add = _mm512_permutexvar_epi32(wide, bases);
                const __m512i values = _mm512_maskz_loadu_epi32(part, in[column] + i + 16 * q);
                _mm512_mask_storeu_epi32(out[column] + i + 16 * q, part, _mm512_add_epi32(values, add));
            }
        }
    }
}

static uint64_t rng_state = 0x9e3779b97f4a7c15ull;
static uint32_t rng(void) { rng_state ^= rng_state << 13; rng_state ^= rng_state >> 7; rng_state ^= rng_state << 17; return (uint32_t)(rng_state >> 16); }

int main(int argc, char** argv)
{
    for (int k = 1; k < argc; k += 1)
    {
        Graph g = graph_read(argv[k]);
        uint32_t* level_a = malloc(g.count * sizeof(uint32_t));
        uint32_t* level_b = malloc(g.count * sizeof(uint32_t));
        uint32_t* scratch[8];
        for (int s = 0; s < 8; s += 1) scratch[s] = malloc(((size_t)g.count + g.edge_count + 64) * sizeof(uint32_t));
        uint8_t* on = malloc(g.count);
        const uint32_t count_a = levels_tarjan(&g, level_a, scratch[0], scratch[1], scratch[2], scratch[3], scratch[4], on);
        const uint32_t count_b = levels_rounds(&g, level_b, scratch[0], scratch[1], scratch[2], scratch[3], scratch[4]);
        uint32_t cyclic = 0, different = 0;
        for (uint32_t f = 0; f < g.count; f += 1) { cyclic += level_a[f] == UINT32_MAX; different += level_a[f] != level_b[f]; }
        uint64_t best_a = UINT64_MAX, best_b = UINT64_MAX;
        for (int r = 0; r < RUNS; r += 1)
        {
            uint64_t t = __rdtsc();
            levels_tarjan(&g, level_a, scratch[0], scratch[1], scratch[2], scratch[3], scratch[4], on);
            t = __rdtsc() - t; best_a = t < best_a ? t : best_a;
            t = __rdtsc();
            levels_rounds(&g, level_b, scratch[0], scratch[1], scratch[2], scratch[3], scratch[4]);
            t = __rdtsc() - t; best_b = t < best_b ? t : best_b;
        }
        printf("graph\t%s\tfunctions %u\tedges %u\tlevels %u (rounds %u)\tin or above a cycle %u\tdifferent %u\n", argv[k], g.count, g.edge_count, count_a, count_b, cyclic, different);
        printf("levels\ttarjan\t%llu cycles\t%.1f a function and edge\n", (unsigned long long)best_a, (double)best_a / (g.count + g.edge_count));
        printf("levels\trounds\t%llu cycles\t%.1f a function and edge\n", (unsigned long long)best_b, (double)best_b / (g.count + g.edge_count));
    }
    uint8_t kinds[3][OPS];
    uint32_t base[16] = { 0 };
    for (uint32_t kind = 1; kind < KINDS; kind += 1) base[kind] = 1000u * kind + 7;
    for (uint32_t o = 0; o < OPS; o += 1) { kinds[0][o] = (uint8_t)(rng() % KINDS); kinds[1][o] = (uint8_t)(rng() % 3 == 0 ? 0 : rng() % KINDS); kinds[2][o] = (uint8_t)(rng() % 4 != 0 ? 0 : rng() % KINDS); }
    static const uint32_t sizes[] = { 16, 64, 256, 4096, 65536 };
    for (unsigned s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s += 1)
    {
        const uint32_t n = sizes[s];
        uint8_t* op = malloc(n + 64);
        uint32_t* columns[9];
        for (int j = 0; j < 9; j += 1) columns[j] = malloc(((size_t)n + 64) * sizeof(uint32_t));
        for (uint32_t i = 0; i < n; i += 1) { op[i] = (uint8_t)(rng() % OPS); columns[0][i] = rng(); columns[1][i] = rng(); columns[2][i] = rng(); }
        rebase_scalar(n, op, columns[0], columns[1], columns[2], columns[3], columns[4], columns[5], kinds, base);
        rebase_vector(n, op, columns[0], columns[1], columns[2], columns[6], columns[7], columns[8], kinds, base);
        uint32_t different = 0;
        for (uint32_t i = 0; i < n; i += 1) different += columns[3][i] != columns[6][i] || columns[4][i] != columns[7][i] || columns[5][i] != columns[8][i];
        uint64_t best_s = UINT64_MAX, best_v = UINT64_MAX;
        const int inner = n <= 256 ? 64 : 1;
        for (int r = 0; r < RUNS; r += 1)
        {
            uint64_t t = __rdtsc();
            for (int j = 0; j < inner; j += 1) rebase_scalar(n, op, columns[0], columns[1], columns[2], columns[3], columns[4], columns[5], kinds, base);
            t = __rdtsc() - t; best_s = t < best_s ? t : best_s;
            t = __rdtsc();
            for (int j = 0; j < inner; j += 1) rebase_vector(n, op, columns[0], columns[1], columns[2], columns[6], columns[7], columns[8], kinds, base);
            t = __rdtsc() - t; best_v = t < best_v ? t : best_v;
        }
        printf("rebase\tnodes %u\tscalar %.2f cycles a node\tvector %.2f cycles a node\tdifferent %u\n", n, (double)best_s / inner / n, (double)best_v / inner / n, different);
    }
    return 0;
}
