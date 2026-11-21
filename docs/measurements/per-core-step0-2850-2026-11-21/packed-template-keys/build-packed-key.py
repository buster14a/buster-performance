from pathlib import Path
d=Path(__file__).resolve().parent
s=(d/'tools/contextindex.c').read_text()
a=s.index('    uint64_t hash = low * LANES_HASH_FIRST;');b=s.index('\n}',a)
s=s[:a]+'''    uint8_t v[17],p[8];
    memcpy(v,&low,8);memcpy(v+8,&high,8);v[16]=(uint8_t)op;
    unsigned bad=((v[1]|v[2]|v[5]|v[6]|v[7]|v[8]|v[9]|v[10])&0xf0)
        | ((v[11]|v[12])&0xfc) | ((v[13]|v[15])&0xfe)
        | ((v[4]|v[14])&0xe0) | (op&0xc0) | (v[0]&0xf8);
    if(bad || (v[3]>=127 && v[3]!=255)){ fprintf(stderr,"packed X key outside domain\\n"); abort(); }
    p[0]=v[16]|v[11]<<6; p[1]=v[1]|v[5]<<4; p[2]=v[7]|v[9]<<4;
    p[3]=v[2]|v[6]<<4; p[4]=v[8]|v[10]<<4; p[5]=v[4]|v[0]<<5;
    p[6]=v[14]|v[12]<<5|v[13]<<7; p[7]=(v[3]&127)|v[15]<<7;
    uint64_t h;memcpy(&h,p,8);
    h=(h^(h>>31))*LANES_HASH_FIRST; h=(h^(h>>29))^LANES_HASH_SECOND;
    if(!h){fprintf(stderr,"reserved setup hash\\n");abort();}
    return h;'''+s[b:]
# An empty row encodes a miss even when an unseen key matches its zero fingerprint.
s=s.replace('    printf("single exact table', '''    const uint64_t absent=(uint64_t)((LANES_CHOSEN_MISSED>>24)<<tbits)<<(64-bits);
    for(uint64_t i=0;i<(UINT64_C(1)<<bits);++i) if(l->single_rows[i]==0) l->single_rows[i]=absent;
    printf("single exact table''')
# Reserve zero code with zero fingerprint in the unlikely event it could be learned.
s=s.replace('*row=(mixed&mask)|((uint64_t)code<<(64-bits));','*row=(mixed&mask)|((uint64_t)code<<(64-bits)); if(!*row) abort();')
a=s.index('        __m512i w[16];',s.index('static __attribute__((noinline)) void lanes_keys'));b=s.index('            const __m512i seeds',a)
vec=['        const __m512i op=_mm512_load_si512(lanes->operators+base);','        __m512i w[8],d[8],q[8],p[8];']
groups=[(0xf0,[1,2,5,6,7,8,9,10]),(0xfc,[11,12]),(0xfe,[13,15]),(0xe0,[4,14]),(0xc0,[16]),(0xf8,[0])]
def value(k):return 'op' if k==16 else f'v[{k}]'
def orx(inputs):
 if len(inputs)==1:return inputs[0]
 if len(inputs)==2:return '_mm512_or_si512('+','.join(inputs)+')'
 return orx(['_mm512_ternarylogic_epi32('+','.join(inputs[:3])+',254)']+inputs[3:])
vec.append('        const __m512i bad='+orx([f'_mm512_and_si512({orx([value(k) for k in ids])},_mm512_set1_epi8((char){m}))' for m,ids in groups])+';')
vec+=['        const __mmask64 bad_lanes=_mm512_test_epi8_mask(bad,bad) | (_mm512_cmpge_epu8_mask(v[3],_mm512_set1_epi8(127)) & _mm512_cmpneq_epi8_mask(v[3],_mm512_set1_epi8(-1)));']
# epi16 shifts spill across the byte boundary; mask the shifted field in both bytes.
for j,terms in enumerate([[(16,0,63),(11,6,3)],[(1,0,15),(5,4,15)],[(7,0,15),(9,4,15)],[(2,0,15),(6,4,15)],[(8,0,15),(10,4,15)],[(4,0,31),(0,5,7)],[(14,0,31),(12,5,3),(13,7,1)],[(3,0,127),(15,7,1)]]):
 vs=[]
 for k,shift,mask in terms:
  x=value(k)
  if shift:x=f'_mm512_slli_epi16({x},{shift})'
  if shift or k==3:x=f'_mm512_and_si512({x},_mm512_set1_epi8((char){mask<<shift}))'
  vs.append(x)
 vec.append(f'        p[{j}]={orx(vs)};')
vec+=['''        for(unsigned j=0;j<4;++j){
            w[2*j]=_mm512_unpacklo_epi8(p[2*j],p[2*j+1]);
            w[2*j+1]=_mm512_unpackhi_epi8(p[2*j],p[2*j+1]);
        }
        for(unsigned j=0;j<2;++j){
            d[4*j]=_mm512_unpacklo_epi16(w[4*j],w[4*j+2]);
            d[4*j+1]=_mm512_unpackhi_epi16(w[4*j],w[4*j+2]);
            d[4*j+2]=_mm512_unpacklo_epi16(w[4*j+1],w[4*j+3]);
            d[4*j+3]=_mm512_unpackhi_epi16(w[4*j+1],w[4*j+3]);
        }
        for(unsigned j=0;j<4;++j){
            q[2*j]=_mm512_unpacklo_epi32(d[j],d[4+j]);
            q[2*j+1]=_mm512_unpackhi_epi32(d[j],d[4+j]);
        }
        __m256i answers[8];
        for(unsigned i=0;i<8;++i){
            __m512i h=_mm512_mullo_epi64(_mm512_xor_si512(q[i],_mm512_srli_epi64(q[i],31)),multiplier_first);
            const __m512i hash=_mm512_ternarylogic_epi64(h,_mm512_srli_epi64(h,29),multiplier_second,150);
''']
s=s[:a]+'\n'.join(vec)+s[b:]
a=s.index('        _mm512_store_si512(lanes->chosen+(base-lanes->scratch_origin)')
b=s.index('\n    }',a)
s=s[:b]+'''
        if(__builtin_expect(bad_lanes!=0,0)){
            for(unsigned j=0;j<4;++j)
                _mm512_mask_store_epi32(lanes->chosen+(base-lanes->scratch_origin)+16*j,(__mmask16)(bad_lanes>>(16*j)),_mm512_set1_epi32(LANES_CHOSEN_MISSED));
        }'''+s[b:]
(d/'tools/packedkey.c').write_text(s)
# Different invertible permutation; uniformly rotates all bytes before the multiply, with no upward fold.
s=s.replace('h=(h^(h>>31))*LANES_HASH_FIRST;','h=((h<<23)|(h>>41))*LANES_HASH_FIRST;').replace('_mm512_xor_si512(q[i],_mm512_srli_epi64(q[i],31))','_mm512_rol_epi64(q[i],23)')
(d/'tools/rotatekey.c').write_text(s)
