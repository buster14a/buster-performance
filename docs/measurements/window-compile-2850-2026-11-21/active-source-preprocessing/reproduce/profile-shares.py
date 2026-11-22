from pathlib import Path
import re,collections,json
study=Path(__file__).resolve().parent
profiles=study/'qualification'/'active-paired-profile'
result={}
for arm,tree in [('eager','active-source-eager-base'),('direct','active-source-directives')]:
    repo=study.parent/tree/'src/buster/compiler'
    areas={}
    for name,file in [('pp_copy_file_text_vector','c_preprocessor_impl.c'),('pp_store_file_tokens','c_preprocessor_impl.c'),('pp_count_page_lines','c_preprocessor.c'),('pp_emit_active_tile','c_preprocessor_impl.c'),('pp_prepare_fragment','c_preprocessor_impl.c'),('pp_skip_source_group','c_preprocessor_impl.c')]:
        lines=(repo/file).read_text().splitlines()
        starts=[i for i,v in enumerate(lines) if re.match(r'(static|BUSTER_INLINE) .+\b'+name+r'\(',v)]
        if not starts:continue
        begin=starts[0]+1
        end=next(i+1 for i in range(begin,len(lines)) if lines[i]=='}')
        areas[name]={'file':file,'start':begin,'end':end,'samples':0}
    total=0;cycles=0
    sym=collections.Counter()
    for l in (profiles/(arm+'.flat')).read_text().splitlines():
        match=re.match(r'^\s*[\d.]+%\s+(\d+)\s+\S+\s+\[[^]]+\]\s+(\S+)',l)
        if match:
            n=int(match[1]);total+=n;sym[match[2]]+=n
    for l in (profiles/(arm+'.lines')).read_text().splitlines():
        m=re.match(r'^\s*[\d.]+%\s+(\d+)\s+\S+\s+\[[^]]+\]\s+\S+\s+([^: ]+):(\d+)',l)
        if not m:continue
        for item in areas.values():
            if m[2]==item['file'] and item['start']<=int(m[3])<=item['end']:
                item['samples']+=int(m[1])
    result[arm]={'user_samples':total,'top_leaf_symbols':dict(sym.most_common(20)),'source_line_areas':areas}
print(json.dumps(result,indent=2))
