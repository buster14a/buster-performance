from pathlib import Path
d=Path(__file__).resolve().parent
for m in ['producedrepair']:
 s=(d/f'tools/{m}.c').read_text()
 a=s.index('    double medians[2][4];')
 s=s[:a]+'''    for(uint32_t pass=0;pass<passes;++pass) printf("counters\\t%u\\t%llu\\t%llu\\t%llu\\t%llu\\t%llu\\n", pass,
        (unsigned long long)taken_nodes,(unsigned long long)samples[pass][0],(unsigned long long)samples[pass][1],
        (unsigned long long)samples[pass][2],(unsigned long long)samples[pass][3]);
'''+s[a:]
 if m!='dynamic':
  a=s.index('    printf("single exact table')
  s=s[:a]+'''    if(getenv("VERIFY_UNKNOWN_KEYS")){
        uint64_t unseen=0,seen=0;
        for(uint32_t k=0;k<n;++k){
          for(uint32_t trial=0;trial<129;++trial){
            uint64_t h=keys[k];
            if(trial>0&&trial<=64)h^=UINT64_C(1)<<(trial-1);
            else if(trial>64)h^=(UINT64_C(0x9e3779b97f4a7c15)*(trial-64))^(keys[(k+trial)%n]>>7);
            uint32_t wanted=LANES_CHOSEN_MISSED;
            const LanesSlot *old=&l->slots[h & l->slot_mask];
            for(unsigned j=0;j<4;++j)if(old->checks[j] && old->checks[j]==h){wanted=old->values[j];break;}
            const uint64_t mix=mixed_key(h,l->single_seed[h>>58]);
            const uint64_t row=l->single_rows[mix>>(64-bits)];
            if(trial==0){if(wanted!=values[k]) abort();++seen;}else if(wanted==LANES_CHOSEN_MISSED)++unseen;
            const uint32_t code=(uint32_t)(row>>(64-bits));
            uint32_t actual=LANES_CHOSEN_MISSED;
            if(!((row^mix)&mask)) actual=(code&((1u<<tbits)-1))|((code>>tbits)<<24);
            if(actual!=wanted){fprintf(stderr,"unseen-key test disagreed\\n");abort();}
          }
        }
        printf("mutation oracle\\t%llu original keys and %llu refused queries\\n",(unsigned long long)seen,(unsigned long long)unseen);
    }
'''+s[a:]
  # Original four-way membership uses the high bucket bits, as at construction.
  needle='const LanesSlot *old=&l->slots[h & l->slot_mask];'
  assert 'hash >> lanes->slot_shift' in s or '>> lanes->slot_shift' in s or 'slot_log2' in s or 'slot_shift' in s or 'bucket_shift' in s
  s=s.replace(needle,'const LanesSlot *old=&l->slots[h >> l->slot_shift];')
 (d/f'tools/qual{m}.c').write_text(s)
