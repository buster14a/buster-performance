from pathlib import Path
import sys
d=Path(sys.argv[1]);d.mkdir(parents=True,exist_ok=True)
cases={
    'plain':'#define N 1\nint f(int,int); int g(void){return f(3,N);}',
    'after':'#define N 1\n[[maybe_unused]] int a; int f(int,int); int g(void){return f(3,N);}',
    'before':'#define N 1\nint f(int,int); int g(void){return f(3,N);} [[maybe_unused]] int a;',
    'direct':'[[__clang__::unused]] int x;',
    'comma':'[[gnu::unused, __clang__::unused]] int x;',
    'trailing':'int x [[__clang__::unused]];',
    'macro-open':'#define L [\nL L __clang__::unused ]] int x;',
    'digraph':'<:<:__clang__::unused:>:> int x;',
    'pragma-gap':'[\n#pragma pack()\n[__clang__::unused]] int x;',
}
for pad in (0,1,60,61,62,63,64,65,126,127,128,129):
 for label,body in cases.items():(d/f'{pad:03d}-{label}.c').write_text(';'*pad+'\n'+body+'\n')
src=Path('pp-scope-dump.c').read_text();at=src.index('        const uint32_t n=parser.tokens.count')
src=src[:at]+'''        const IdentId spelling=intern_find(pp.table,(const uint8_t*)"_Clang",6);
        uint32_t normalized=0;
        for(uint32_t i=0;i<parser.tokens.count;i++) {
            uint32_t from=parse_source_index(&parser.tokens,i);
            if(parser.tokens.kinds[i]==PARSE_KIND_IDENTIFIER && parser.tokens.names[i]==spelling && spelling!=0 &&
               pp.output.kinds[from]==C_TOKEN_NUMERIC_CONSTANT)normalized++;
        }
        fprintf(stderr,"scope-witness %s deferred=%u replay=%u converted=%u\\n",argv[f],pp.history_deferred,pp.history_replay!=NULL,normalized);
'''+src[at:];(d.parent/'scope-witness.c').write_text(src)
