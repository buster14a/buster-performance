"""Compare pointer casts, relocatable integer addresses, and absolute pointer constants against Clang."""
from pathlib import Path
import itertools,re,subprocess,sys,collections
old,new,cc,output=sys.argv[1:];out=Path(output);out.mkdir(parents=True,exist_ok=True)
values={'symbol':'&g','array':'arr','function':'&callee','plus':'&arr[3]','large-displacement':'((char*)&g + (1ul << 63))','weak':'&weak','absolute0':'(int*)0','absolute1':'(int*)1','absolute255':'(int*)255','absolute256':'(int*)256','absolute65536':'(int*)65536','absolute-negative':'(int*)-1L'}
contexts={'if':'if (Q) return 1;', 'not':'if (!(Q)) return 1;', 'arm':'return (Q) ? 1 : 1/0;', 'opposite':'return (Q) ? 1/0 : 1;', 'nested':'if ((char)(long)(Q)) return 1;'}
for e in ['OFF','ON']:
 lines=['#pragma STDC FENV_ACCESS '+e,'int g, arr[17]; extern int weak __attribute__((weak)); int callee(void);']
 keys={}
 for (val,q),via,to,(context,stmt) in itertools.product(values.items(),['direct','long','unsigned long','__int128','_Bool'],['char','unsigned char','int','_Bool','unsigned short','__int128','void *'],contexts.items()):
  v=q if via=='direct' else f'({via})({q})'
  n=len(lines)+1;keys[n]=(val,via,to,context);lines.append(f'int f{n}(void) {{ '+stmt.replace('Q',f'({to})({v})')+' }')
 src=out/'corpus.c';src.write_text('\n'.join(lines)+'\n')
 def run(binary):
  r=subprocess.run([binary,'-std=gnu17','-fsyntax-only','-fno-caret-diagnostics','-Wno-everything','-Wdivision-by-zero','-Wreturn-type',str(src)],capture_output=True,text=True)
  assert r.returncode==0,r.stderr[:500]
  return dict((int(n),m) for n,m in re.findall(r':(\d+):\d+: warning: (.*)',r.stderr))
 a,b,c=map(run,[cc,old,new]); totals=collections.Counter()
 with (out/f'changes-{e}.tsv').open('w')as f:
  for n,k in keys.items():
   x,y,z=(m.get(n) for m in [a,b,c]); label=('kept' if x==y else 'stable-different') if y==z else ('fixed' if x==z else ('regression' if x==y else 'changed-different'));totals[label]+=1
   if y!=z:print(*k,label,x,y,z,sep='\t',file=f)
 print(e,len(keys),dict(totals))
