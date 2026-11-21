from pathlib import Path
import sys
p=Path(sys.argv[1]);p.mkdir(parents=True,exist_ok=True)
(p/'switch-off.h').write_text('#define CHOICE 0\n')
(p/'switch-on.h').write_text('#define CHOICE 1\n')
trig='?'+'?'
active=''.join(f'enum {{ enabled_token_{i} = {i} }};\n' for i in range(9500))
silent=''.join(f'unreached_name_{i} + unreachable_{i+5}; /* stripped bytes */\n' for i in range(9500))
for on in (False,True):
 src='#include "switch-'+('on' if on else 'off')+'.h"\n'
 src+='#define ID(x) (x)\n#define TWICE(x) (ID(x)+ID(x))\n'
 src+='#if CHOICE\n'+active+'#else\n#if 0\n'+silent+'#else\nstatic int from_header = TWICE(3);\n#endif\n#endif\n'
 src+='%:if 0\n/* ignored comment with a\n# else\n*/\nR"tag(fake\n#else\n)tag"\n'+'u8"a'+chr(92)+'\n#else"\n%:endif\n'
 src+='#if 0\n'+trig+'= if 0\nnot_visible\n'+trig+'= endif\n#endif\n'
 src+='#line 707 "visible-location.c"\nint read_value(void) {return __LINE__;}\n'
 (p/('on.c' if on else 'off.c')).write_text(src)
(p/'all-active.c').write_text(active+'int read_value(void){return enabled_token_9200;}\n')
(p/'reject.c').write_text('#if 0\n'+silent+'#ifdef\nwhatever\n#else bogus\n'+trig+'=endif\n#else\nint valid;\n#endif extra\n#line 503 "broken-file.c"\n#error visible failure\n')
(p/'unfinished.c').write_text('#if 0\n'+silent+'/* unterminated comment\n')
(p/'macro-args.c').write_text('#define F(x) x\n#define EX(a,b) ((a)+(b))\n#if 0\n'+silent+'#endif\nint n=EX(4,\n#if 0\n'+silent+'#else\nF(3)\n#endif\n);\n')
