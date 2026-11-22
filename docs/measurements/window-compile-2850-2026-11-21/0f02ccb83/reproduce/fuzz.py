from pathlib import Path
import hashlib,random,subprocess,sys
d=Path(__file__).resolve().parent/'fuzz';d.mkdir(exist_ok=True)
ccs=[d.parent/'debug-vector',d.parent/'debug-base']
(d/'macro.h').write_text('#define HEADER(x) ((x) + 1)\n')
total=0; differences=0
for seed in range(140):
 r=random.Random(2850000+seed)
 unit=['#define F(x) x\n#define G(a,b) ((a)+(b))\n#include "macro.h"\n']
 c=0; stack=[]
 for i in range(65):
  if r.randrange(5)==0: unit.append(' '*(60000+r.randrange(16000))+'\n')
  choice=r.randrange(11)
  if not stack or (choice<3 and len(stack)<5):
   unit.append(r.choice(['#if 0\n','#if 1\n','#ifdef F\n','#ifndef UNSET\n','#if defined(FLIP)\n','#if HEADER(1) == 2\n']))
   stack.append(False)
  elif choice<5 and not stack[-1]:
   unit.append(r.choice(['#else\n','#elif defined(F)\n','#elifndef QQQ\n','#elif 0\n','#elif 1\n']))
   stack[-1]=unit[-1].startswith('#else')
  elif choice<7:
   unit.append('#endif\n');stack.pop()
  elif choice==7:
   unit.append(r.choice(['/*\n  #endif\n  */\n','// #else\\\n  #endif\n','"fake #endif"\n','int raw_\\\n spelling;\n']))
  elif choice==8:
   unit.append(r.choice(['#undef FLIP\n','#define FLIP 1\n','#include "macro.h"\n']))
  else:
   unit.append(f'int x_{seed}_{c}=G(HEADER(2),F(1));\n');c+=1
 unit+=['#endif\n']*len(stack)
 if seed%9==0:unit.append('#endif\n')
 if seed%11==0:unit.append('#if 1\nint unclosed;\n')
 unit.append('int tail;\n')
 source=''.join(unit).encode();pad=(1<<20)-len(source)
 if pad>0: source+=(b' '*(pad-1)+b'\n') if pad>1 else b'\n'
 src=d/'sample.c';src.write_bytes(source)
 for flags in [[],['-P','-pedantic','-std=c17']]:
  records=[]
  for exe in ccs:
   cur=subprocess.run([str(exe),*flags,'-I',str(d),str(src)],capture_output=True)
   records.append((cur.returncode,cur.stdout,cur.stderr))
  total+=1
  if records[0]!=records[1]:
   differences+=1
   key=f'{seed}-'+('markers' if not flags else 'pedantic')
   (d/f'{key}.c').write_bytes(source)
   for arm,rec in zip(('candidate','baseline'),records):
    (d/f'{key}-{arm}.out').write_bytes(rec[1]);(d/f'{key}-{arm}.err').write_bytes(rec[2])
   print(key,[(x[0],len(x[1]),len(x[2])) for x in records],flush=True)
print('cases',total,'differences',differences)
sys.exit(bool(differences))
