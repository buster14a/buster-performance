from pathlib import Path
import sys
p=Path(sys.argv[1]);p.mkdir(exist_ok=True,parents=True)
def records(name,count=3500):
 return ''.join(f'enum {{ {name}_{i} = ({i} + 2) }}; /* row {i} */\n' for i in range(count))
for choice in [0,1]:
 (p/f'choice{choice}.h').write_text(f'#define TAKE {choice}\n')
 active=records('alpha');other=records('beta');padding='/* bulk fixture padding '+('X'*300000)+' */\n'
 (p/f'plain{choice}.c').write_text(f'#include "choice{choice}.h"\n'+'#define PASS(x) x\n#if TAKE\n'+active+'#else\n'+other+'#endif\n'+padding+'#line 778 "ordinary-primary.c"\nint score(void){return PASS(__LINE__);}\n')
(p/'counter.c').write_text('#define STEP __COUNTER__\nstatic int a=STEP;\n#if STEP==1\n'+records('act',7500)+'#else\n#error wrong live counter\n#endif\n')
(p/'lexnotes.c').write_text('#define V 1\n#if 0\n'+records('silent',6900)+'"unterminated\n/* prefix \u005c\u005cN{FAKE} */\n#else\nint proven;\n#endif junk\n#line 910 "bad-primary.c"\n#error expected error\n')
(p/'fake.c').write_text('/* this block hides physical directive markers\n#if fake\n'+records('dummy',7400).replace('/* row','/ row').replace('*/','/')+'#else\n*/\nint actual;\n')
(p/'forward.c').write_text('#define F(x) (x)\n#if 1\n'+records('count',7500)+'int sum=F(\n#else\n#error lost argument\n#endif\n4);\n')
