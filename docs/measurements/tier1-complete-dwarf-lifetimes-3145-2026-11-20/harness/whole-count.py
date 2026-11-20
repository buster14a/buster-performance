from pathlib import Path
import shutil
p=Path(__file__).resolve().parent;w=p.parent;sub=Path('src/buster/compiler')
for n in ['c_check_tier1_debug_values.c','c_check_tier1_debug_regions.c','c_check_debug_tier1_bindings_test.c']:
    shutil.copyfile(w/'region-batch'/sub/n,w/'region-batch-count'/sub/n)
f=w/'region-batch-count'/sub/'c_check_tier1_debug_values.c';s=f.read_text();i=s.index('static void check_tier1_debug_region_changes(');s=s[:i]+'static uint64_t complete_lifetime_counts[5];\n'+s[i:]
i=s.index('    const __m512i limit',i);s=s[:i]+'    complete_lifetime_counts[0]++; complete_lifetime_counts[1]+=end-first;\n'+s[i:]
q='        for (; distinct != 0; distinct &= distinct - 1)';i=s.index(q,i);s=s[:i]+'''        complete_lifetime_counts[2] += (uint32_t)__builtin_popcount((uint32_t)first_in_range);
        complete_lifetime_counts[3] += (uint32_t)__builtin_popcount(distinct);
        for (uint32_t bits = (uint32_t)first_in_range & ~distinct; bits; bits &= bits-1)
            complete_lifetime_counts[4] += live->local_queued[(uint32_t)proof->region_events[at+(uint32_t)__builtin_ctz(bits)]] == 0;
'''+s[i:]
i=s.rindex('    return valid;');s=s[:i]+'''    fprintf(stderr,"complete-lifetimes");for(unsigned i=0;i<5;i++)fprintf(stderr,"\\t%llu",(unsigned long long)complete_lifetime_counts[i]);fprintf(stderr,"\\n");memset(complete_lifetime_counts,0,sizeof(complete_lifetime_counts));
'''+s[i:];f.write_text(s)
