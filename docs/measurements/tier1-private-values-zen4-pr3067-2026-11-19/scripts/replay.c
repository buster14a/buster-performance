// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin.
// Independent placement-only replay of the recorded little-endian, 32-bit promotion inputs.
// A final (block,local) pair is read only when scoring the candidates.
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Frontier Frontier;
struct Frontier
{
    uint32_t* blocks;
    size_t count;
    size_t capacity;
};

static void* allocate(size_t count, size_t size)
{
    void* p = calloc(count ? count : 1, size);
    if (p == NULL)
        abort();
    return p;
}

static uint32_t* read_words(size_t count)
{
    uint32_t* rows = allocate(count, sizeof(*rows));
    if (fread(rows, sizeof(*rows), count, stdin) != count)
        abort();
    return rows;
}

static void add_frontier(Frontier* frontier, uint32_t block)
{
    if (!frontier->count || frontier->blocks[frontier->count - 1] != block)
    {
        if (frontier->count == frontier->capacity)
        {
            frontier->capacity = frontier->capacity ? frontier->capacity * 2 : 4;
            frontier->blocks = realloc(frontier->blocks, frontier->capacity * sizeof(*frontier->blocks));
            if (frontier->blocks == NULL)
                abort();
        }
        frontier->blocks[frontier->count++] = block;
    }
}

int main(void)
{
    uint64_t total_candidates = 0, total_final = 0, total_missing = 0;
    uint32_t count = 0;
    uint32_t h[6];
    while (fread(h, sizeof(*h), 1, stdin) == 1)
    {
        if (fread(h + 1, sizeof(*h), 5, stdin) != 5 || h[0] != UINT32_C(0x53534147))
            abort();
        const uint32_t blocks = h[1], locals = h[2], edges = h[3], events = h[4], final = h[5];
        uint32_t* parent = read_words(blocks);
        uint32_t* offsets = read_words((size_t)blocks + 1);
        uint32_t* pred = read_words(edges);
        uint32_t* event = read_words((size_t)events * 3);
        uint32_t* phi_block = read_words(final);
        uint32_t* phi_local = read_words(final);
        Frontier* frontier = allocate(blocks, sizeof(*frontier));
        for (uint32_t b = 0; b < blocks; ++b)
        {
            if (offsets[b + 1] - offsets[b] < 2)
                continue;
            for (uint32_t i = offsets[b]; i < offsets[b + 1]; ++i)
            {
                for (uint32_t x = pred[i]; x != parent[b]; x = parent[x])
                {
                    if (x >= blocks || parent[x] == x)
                        abort();
                    add_frontier(&frontier[x], b);
                }
            }
        }
        unsigned char* defs = allocate(blocks, 1);
        unsigned char* live = allocate(blocks, 1);
        unsigned char* seen = allocate(blocks, 1);
        unsigned char* chosen = allocate(blocks, 1);
        uint32_t* stack = allocate(blocks, sizeof(*stack));
        for (uint32_t slot = 0; slot < locals; ++slot)
        {
            memset(defs, 0, blocks);
            memset(live, 0, blocks);
            memset(chosen, 0, blocks);
            size_t top = 0;
            for (uint32_t i = 0; i < events; ++i)
            {
                const uint32_t* e = event + (size_t)i * 3;
                if (e[0] != slot)
                    continue;
                const uint32_t b = e[1];
                if (b >= blocks)
                    abort();
                if (e[2])
                    defs[b] = 1;
                else if (!defs[b] && !live[b])
                {
                    live[b] = 1;
                    stack[top++] = b;
                }
            }
            while (top)
            {
                const uint32_t b = stack[--top];
                for (uint32_t i = offsets[b]; i < offsets[b + 1]; ++i)
                {
                    const uint32_t p = pred[i];
                    if (!defs[p] && !live[p])
                    {
                        live[p] = 1;
                        stack[top++] = p;
                    }
                }
            }
            memcpy(seen, defs, blocks);
            for (uint32_t b = 0; b < blocks; ++b)
                if (defs[b])
                    stack[top++] = b;
            while (top)
            {
                const Frontier* f = &frontier[stack[--top]];
                for (size_t i = 0; i < f->count; ++i)
                {
                    const uint32_t b = f->blocks[i];
                    if (live[b] && !chosen[b])
                    {
                        chosen[b] = 1;
                        ++total_candidates;
                        if (!seen[b])
                        {
                            seen[b] = 1;
                            stack[top++] = b;
                        }
                    }
                }
            }
            for (uint32_t i = 0; i < final; ++i)
                if (phi_local[i] == slot && !chosen[phi_block[i]])
                    ++total_missing;
        }
        total_final += final;
        ++count;
        for (uint32_t b = 0; b < blocks; ++b)
            free(frontier[b].blocks);
        free(frontier);
        free(parent);
        free(offsets);
        free(pred);
        free(event);
        free(phi_block);
        free(phi_local);
        free(defs);
        free(live);
        free(seen);
        free(chosen);
        free(stack);
    }
    if (ferror(stdin))
        return 2;
    printf("promotions=%u candidates=%llu published=%llu missed=%llu\n", count, (unsigned long long)total_candidates,
           (unsigned long long)total_final, (unsigned long long)total_missing);
    return total_missing != 0 || count == 0;
}
