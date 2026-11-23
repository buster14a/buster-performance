import sys
p=sys.argv[1]
s=open(p).read()
old='''        // Each declaration's place, for --list and the tests' records alone.'''
new='''        if (getenv("BUSTER_DEBUG_ATTESTED") != NULL)
        {
            uint64_t h1 = 1469598103934665603ull, h2 = h1, h3 = h1;
            for (uint32_t d = 0; d < census->declaration_count; d += 1)
            {
                h1 = (h1 ^ census->hits[d]) * 1099511628211ull;
                h2 = (h2 ^ census->reached[d]) * 1099511628211ull;
                h3 = (h3 ^ census->reached_without_runtime[d]) * 1099511628211ull;
            }
            uint64_t h4 = 1469598103934665603ull;
            for (uint32_t d = 0; d < census->declaration_count; d += 1)
            {
                if ((census->flags[d] & BUSTER_ATTESTED_DEFINITION) == 0)
                {
                    h4 = (h4 ^ census->firsts[d] ^ (uint64_t)census->lasts[d] << 32 ^ (uint64_t)(census->flags[d] & 0x0f) << 60) * 1099511628211ull;
                    for (uint32_t n = census->name_starts[d]; n < census->name_starts[d + 1]; n += 1) h4 = (h4 ^ census->name_entries[n]) * 1099511628211ull;
                    for (uint32_t n = census->declared_starts[d]; n < census->declared_starts[d + 1]; n += 1) h4 = (h4 ^ census->declared_keys[n] ^ 0x55) * 1099511628211ull;
                }
            }
            for (uint32_t k = 0; k < census->string_count; k += 1) h4 = (h4 ^ census->string_tokens[k] ^ (uint64_t)census->string_declarations[k] << 32) * 1099511628211ull;
            fprintf(stderr, "DUMP %s declarations=%u hits=%016llx reached=%016llx without=%016llx lists=%016llx\\n", path, census->declaration_count, (unsigned long long)h1, (unsigned long long)h2, (unsigned long long)h3, (unsigned long long)h4);
        }
        // Each declaration's place, for --list and the tests' records alone.'''
assert s.count(old)==1
s=s.replace(old,new)
old='''        attested->unit_ready = check_attested_decide(attested, parser, pp);'''
new='''        attested->unit_ready = check_attested_decide(attested, parser, pp);
        if (getenv("BUSTER_DEBUG_ATTESTED") != NULL)
        {
            uint64_t h1 = 1469598103934665603ull, h2 = h1;
            for (uint32_t d = 0; d < attested->declaration_count; d += 1)
            {
                h1 = (h1 ^ attested->hits[d]) * 1099511628211ull;
                h2 = (h2 ^ attested->reached[d]) * 1099511628211ull;
            }
            fprintf(stderr, "DUMPC declarations=%u hits=%016llx reached=%016llx skipped=%u\\n", attested->declaration_count, (unsigned long long)h1, (unsigned long long)h2, attested->skipped_declarations);
        }'''
assert s.count(old)==1
s=s.replace(old,new)
open(p,'w').write(s)
