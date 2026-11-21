from pathlib import Path
d=Path('return-boundaries/inputs');d.mkdir(parents=True,exist_ok=True)
for n in [0,1,2,3,31,60,61,62,63,64,65,66,124,125,126,127,128,129,130,16375,16376,16377,16378,16379,16380,16381,16382,16383,16384,16385]:
    (d/f'return-{n}.c').write_text(
       '#define RET return\n#define V 17\nint global;\n'+ ';'*n+'int f(int x){ return 0; {RET V;} return x;}\n'
       '#pragma unknown return 123 ;\nint g(void){ RET global; return 2147483647; return 2147483648; return 09u; }\n'
       .replace('return 09u;','return 01u;'))
(d/'negative.c').write_text('int b; int f(int x){return -2;return (2);return x+2;return 08.0;return 012;return 0x0;return 1u;return 2147483648;return 0b1;return __LINE__;}\n')
(d/'attribute.c').write_text('[[vendor::irrelevant(return 3;)]] int g(int n) {return n;}\n')
(d/'pragma.c').write_text('#pragma unknown return 11;\n#define RET(x) return x;\nint h(int x){RET(x) _Pragma("unknown return 11;") RET(13)}\n')
(d/'pragma-gap.c').write_text('int g(void){return\n#pragma unknown\n9; return 3\n#pragma unknown\n;return 5;}\n')
