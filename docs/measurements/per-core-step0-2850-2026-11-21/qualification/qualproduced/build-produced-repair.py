from pathlib import Path
d=Path(__file__).resolve().parent
g=(d/'build-produced.py').read_text().replace("tools/packedkey.c","tools/packedrepair.c").replace("tools/produced.c","tools/producedrepair.c").replace("tools/producedcols.c","tools/producedrepaircols.c")
exec(compile(g,str(d/'build-produced.py'),'exec'))
for name in ('producedrepair','producedrepaircols'):
 f=d/('tools/'+name+'.c'); s=f.read_text()
 needle='            for(unsigned k=0;k<4;++k) lanes->types[k][g]=types[k];'
 assert s.count(needle)==1
 s=s.replace(needle,'''            const uint8_t op=lanes->operators[g],store=lanes->store[g],count=lanes->counts_whole[g];
            const uint32_t at=(g-lanes->scratch_origin)/64, lane=g%64;
            const uint8_t bytes[8]={op|(facts[2]<<6),types[0]<<4,types[2]|(facts[0]<<4),types[1]<<4,
                                      types[3]|(facts[1]<<4),count,facts[5]|(facts[3]<<5)|(facts[4]<<7),
                                      (store&127)|(facts[6]<<7)};
            const unsigned bad=((types[0]|types[1]|types[2]|types[3]|facts[0]|facts[1])&0xf0) |
                              ((facts[2]|facts[3])&0xfc)|((facts[4]|facts[6])&0xfe)|((count|facts[5])&0xe0)|
                              (op&0xc0)|(store>=127&&store!=255);
            const uint64_t mask=UINT64_C(1)<<lane;
            lanes->key_invalid[at]=(lanes->key_invalid[at]&~mask)|(bad?mask:0);
            for(uint32_t k=0;k<8;++k)
                ((uint8_t*)(void*)&lanes->key_blocks[INDEX])[lane]=bytes[k];'''.replace('INDEX','at*8+k' if name=='producedrepair' else '(uint64_t)k*lanes->key_stride+at'))
 f.write_text(s)
