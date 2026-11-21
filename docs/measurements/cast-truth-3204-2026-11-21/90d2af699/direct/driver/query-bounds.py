"""Probe conversion of object-size results at truncation boundaries, including nonconstant and zero bounds."""
from pathlib import Path
import itertools, re, subprocess, sys, collections
old, new, cc, outdir=sys.argv[1:];out=Path(outdir);out.mkdir(parents=True,exist_ok=True)
src=out/'query.c'; categories=collections.Counter(); rows=[]
for mode in ['OFF','ON']:
 lines=['#pragma STDC FENV_ACCESS '+mode]+[f'char a{n}[{n}];' for n in [1,127,128,256,257,258,65536,65537]]
 info=[]
 for source,size,builtin,kind,dest,form in itertools.product(['p','aN','aN+1','&aN[1]'],[1,127,128,256,257,258,65536,65537],['__builtin_object_size','__builtin_dynamic_object_size'],range(4),['char','unsigned char','unsigned short','long','_Bool','double'],['if (Q) return 1; return 1/0;', 'if (Q) return 1/0; return 1;']):
  if source=='p' and size!=1: continue
  operand=source.replace('N',str(size));q=f'({dest}){builtin}({operand},{kind})'
  line=len(lines)+1;lines.append(f'int f{line}(char *p) {{ '+form.replace('Q',q)+' }')
  info.append((line,source,size,builtin,kind,dest,form))
 src.write_text('\n'.join(lines)+'\n')
 def run(binary):
  r=subprocess.run([binary,'-std=gnu17','-fsyntax-only','-fno-caret-diagnostics','-Wno-everything','-Wdivision-by-zero',str(src)],capture_output=True,text=True)
  if r.returncode:raise ValueError(r.stderr[:350])
  return {int(m) for m in re.findall(r':(\d+):\d+: warning:',r.stderr)}
 a,b,c=(run(x) for x in [cc,old,new]);count=collections.Counter()
 for meta in info:
  line=meta[0];x,y,z=(line in rs for rs in [a,b,c]);tag=('kept' if x==y else 'stable-different') if y==z else ('fixed' if x==z else 'regression');count[tag]+=1
  if tag in ('regression','fixed'):rows.append((mode,*meta,tag,x,y,z))
 print(mode,len(info),dict(count))
with (out/'changes.tsv').open('w')as f:
 for row in rows:print(*row,sep='\t',file=f)
