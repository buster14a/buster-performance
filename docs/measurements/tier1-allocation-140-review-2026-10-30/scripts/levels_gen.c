// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. Measurement harness for buster #140's review (buster-performance record).
static uint64_t random_state = 0x9e3779b97f4a7c15u;
static uint32_t random_next(void)
{
    random_state ^= random_state << 13;
    random_state ^= random_state >> 7;
    random_state ^= random_state << 17;
    return (uint32_t)(random_state >> 11);
}

// The lifetimes of harness.c's shapes 4 (temps-fit: 5% long values) and 6 (one chain): value i is read once, by the
// instruction where its interval [2i+1, 2(i+length)) ends, or by the next one with a free slot.
static void generate(Stream* s, uint32_t shape, uint32_t count)
{
    random_state = 0x9e3779b97f4a7c15u;
    s->count = count;
    s->none = count + 64;
    for (uint32_t slot = 0; slot < count * SLOTS; slot += 1)
    {
        s->ops[slot] = s->none;
    }
    uint8_t* used = calloc(count, 1);
    for (uint32_t i = 0; i < count; i += 1)
    {
        uint32_t length = 1;
        uint8_t class = 0;
        if (shape == 4)
        {
            const uint32_t percent = random_next() % 100;
            length = percent < 5 ? 10 + random_next() % 190 : 1 + random_next() % 3;
            class = (uint8_t)(i % 4 == 0 ? 1 : 0);
        }
        s->classes[i] = class;
        uint32_t reader = i + length;
        while (reader < count && used[reader] == SLOTS)
        {
            reader += 1;
        }
        if (reader < count)
        {
            s->ops[reader * SLOTS + used[reader]] = i;
            used[reader] += 1;
        }
    }
    s->classes[s->none] = 0;
    s->value_register[s->none] = 0;
    free(used);
}

