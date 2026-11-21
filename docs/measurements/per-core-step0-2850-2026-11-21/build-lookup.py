from pathlib import Path
d=Path(__file__).resolve().parent;s=(d/'tools/lanes.c').read_text()
s=s.replace('    struct LanesSlot* slots;', '''    struct LanesSlot* slots;
    uint32_t* offsets;
    uint64_t* lookup_keys;
    uint32_t* lookup_values;
    uint32_t lookup_mask;''')
pos=s.index('static void lanes_type_inputs(')
s=s[:pos]+'''// Build a second, exact dictionary using only the original template table's checked hashes and rows.
static uint32_t lanes_lookup_index(uint64_t hash, uint32_t offset, uint32_t mask)
{
    return ((uint32_t)(hash >> 17) + offset) & mask;
}
static uint32_t lanes_flat_lookup(const Lanes* lanes, uint64_t hash)
{
    const uint32_t bucket = (uint32_t)(hash >> lanes->slot_shift);
    const uint32_t slot = lanes_lookup_index(hash, lanes->offsets[bucket], lanes->lookup_mask);
    return lanes->lookup_keys[slot] == hash ? lanes->lookup_values[slot] : LANES_CHOSEN_MISSED;
}
static void lanes_build_lookup(Lanes* lanes)
{
    uint32_t capacity = 64;
    while (capacity < 2 * lanes->slot_keys) capacity *= 2;
    lanes->offsets = must(calloc(lanes->slot_mask + 1, sizeof(uint32_t)));
    for (;;)
    {
        lanes->lookup_mask = capacity - 1;
        lanes->lookup_keys = must(calloc(capacity, sizeof(uint64_t)));
        lanes->lookup_values = must(calloc(capacity, sizeof(uint32_t)));
        bool success = true;
        for (uint32_t length = 4; length > 0 && success; --length)
        {
            for (uint32_t b = 0; b <= lanes->slot_mask && success; ++b)
            {
                const LanesSlot* bucket = lanes->slots + b;
                uint32_t count = 0;
                while (count != 4 && bucket->checks[count] != 0) ++count;
                if (count != length) continue;
                bool placed = false;
                for (uint32_t offset = 0; offset < capacity && !placed; ++offset)
                {
                    uint32_t positions[4];
                    bool free = true;
                    for (uint32_t i=0; i<count && free; ++i)
                    {
                        positions[i] = lanes_lookup_index(bucket->checks[i], offset, capacity-1);
                        free = lanes->lookup_keys[positions[i]] == 0;
                        for (uint32_t j=0; j<i; ++j) free &= positions[i]!=positions[j];
                    }
                    if (free)
                    {
                        lanes->offsets[b] = offset;
                        for (uint32_t i=0; i<count; ++i)
                        {
                            lanes->lookup_keys[positions[i]] = bucket->checks[i];
                            lanes->lookup_values[positions[i]] = bucket->values[i];
                        }
                        placed = true;
                    }
                }
                success = placed;
            }
        }
        if (success) break;
        free(lanes->lookup_keys);
        free(lanes->lookup_values);
        if (capacity >= (1u << 25)) abort();
        capacity *= 2;
    }
    uint64_t absent = 0, known = 0;
    for (uint32_t b=0; b<=lanes->slot_mask; ++b)
    {
        const LanesSlot* bucket = lanes->slots + b;
        for (uint32_t j=0; j<4 && bucket->checks[j]!=0; ++j)
        {
            const uint64_t h=bucket->checks[j];
            if (lanes_flat_lookup(lanes,h)!=bucket->values[j]) abort();
            ++known;
            const uint64_t other=h^((uint64_t)1<<15);
            bool present=false;
            for (uint32_t i=0;i<4;++i) present |= bucket->checks[i]==other;
            if (!present && lanes_flat_lookup(lanes,other)!=LANES_CHOSEN_MISSED) abort();
            absent+=!present;
        }
    }
    printf("lookup\\tknown=%llu absent=%llu slots=%u\\n",(unsigned long long)known,(unsigned long long)absent,capacity);
}

'''+s[pos:]
pos=s.index('    free(learned);',s.index('static void lanes_type_inputs('))
s=s[:pos]+'    lanes_build_lookup(lanes);\n'+s[pos:]
a=s.index('            const LanesSlot* bucket = &slots[hash >> shift];',s.index('static __attribute__((noinline)) void lanes_choose('));b=s.index('\n',s.index('chosen[base + lanes_hash_order[j]]',a))
s=s[:a]+'''            chosen[base + lanes_hash_order[j]] = lanes_flat_lookup(lanes, hash);'''+s[b:]
s=s.replace('    const LanesSlot* slots = lanes->slots;\n    const uint32_t shift = lanes->slot_shift;\n','')
(d/'tools/flat.c').write_text(s)
