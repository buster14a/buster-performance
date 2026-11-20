from pathlib import Path
p=Path(__file__).resolve().parents[1]/'region-batch-count/src/buster/compiler/c_check_tier1_debug_values.c';s=p.read_text();mark='static void check_tier1_debug_region_changes(';a=s.index(mark);s=s[:a]+'''static uint64_t batch_counts[20];
'''+s[a:];a=s.index('    const __m512i limit',a);s=s[:a]+'''    batch_counts[0]++; batch_counts[1]+=end-first; batch_counts[2]+=end>first;
    batch_counts[3]+=end-first>=64; batch_counts[4]+=end-first>=256;
    batch_counts[5]+=live->local_count>=proof->local_count;
    for(unsigned kind=0;kind<3;kind++)
    {
        const unsigned size=16u<<(2*kind);
        uint32_t start=(first+size-1)&~(size-1);
        for(;start<end && size<=end-start;start+=size)
        {
            bool skip=true;
            for(unsigned j=0;j<size;j++) skip &= proof->region_previous[start+j]>first;
            batch_counts[6+2*kind]++;
            batch_counts[7+2*kind]+=skip;
        }
    }
'''+s[a:]
needle='            check_tier1_debug_local_changed(live, (uint32_t)proof->region_events[at + lane]);';s=s.replace(needle,'''            const uint32_t id=(uint32_t)proof->region_events[at+lane];
            batch_counts[12]++; batch_counts[13]+=live->local_queued[id]!=0;
'''+needle)
needle='    return valid;';a=s.rindex(needle);s=s[:a]+'''    fprintf(stderr,"region-batches");for(unsigned i=0;i<14;i++)fprintf(stderr,"\\t%llu",(unsigned long long)batch_counts[i]);fprintf(stderr,"\\n");memset(batch_counts,0,sizeof(batch_counts));
'''+s[a:];p.write_text(s)
