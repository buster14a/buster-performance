"""Count candidate-vs-Clang differences that the unchanged checker did not have, by return/arm and FP mode."""
from pathlib import Path
import collections, itertools,re,subprocess,sys
base, candidate, clang, outdir=sys.argv[1:]
out=Path(outdir);out.mkdir(parents=True,exist_ok=True)
values = {
 'sym':'(long)&g','array':'(long)array','abs':'(long)(void *)256','int_zero':'0','int_one':'1','int_trunc':'256','int_big':'16777217',
 'exact':'(1.0)','fraction':'(0.5)','negative':'(-0.5)','complex':'(1i)', 'complex_real':'((double _Complex)42)',
 'q0':'(__builtin_object_size(p,0))','q2':'(__builtin_object_size(p,2))',
 'b0':'(__builtin_constant_p(x))','b1':'(__builtin_constant_p(1))','right':'(x||1)','left':'(1||x)','rc':'(x&&0)','lc':'(0&&x)',
 'negative_rc':'(!(x&&0))','numeric_comma':'((void)x,42)','unknown':'x','eq':'(x==1)',
 'half_wide':'((_Float16)(unsigned _BitInt(257))1)','half_hi':'((_Float16)(unsigned _BitInt(257))256)',
 'wide_one':'(unsigned _BitInt(257))1','wide_zero':'(unsigned _BitInt(257))0','wide_ones':'(((unsigned _BitInt(257))1 << 190)|1)','wide_negative':'(-(_BitInt(257))42)',
}
casts = ['char','long','unsigned short','_Float16','double','float','double _Complex','_Bool','__int128','unsigned _BitInt(257)']
contexts={'if':'if ({v}) return 1;', 'not':'if (!({v})) return 1;', 'or':'if (({v}) || x) return 1;', 'arm':'return ({v}) ? 1 : 1/0;', 'opposite':'return ({v}) ? 1/0 : 1;', 'nested':'if ((int)(long)({v})) return 1;'}
def run(cc,file):
 args=[cc,'-std=gnu17','-fsyntax-only','-fno-caret-diagnostics','-Wno-everything','-Wreturn-type','-Wdivision-by-zero',str(file)]
 r=subprocess.run(args,capture_output=True,text=True)
 # An error in one program can suppress diagnostics for later ones in the TU.
 if r.returncode: raise ValueError((cc,r.returncode,r.stderr[:300]))
 outputs=collections.defaultdict(list)
 for line in r.stderr.splitlines():
  m=re.search(r':(\d+):\d+: warning: (.*)',line)
  if m: outputs[int(m[1])].append(m[2])
 return outputs
for strict in ['OFF','ON']:
 lines=['#pragma STDC FENV_ACCESS '+strict,'long g; int array[5];']
 results=[]
 for (v,operand),cast,(context,statement) in itertools.product(values.items(),casts,contexts.items()):
  line=len(lines)+1; expr=f'({cast})({operand})'; lines.append('int f%d(int x,char *p) { '%line+statement.format(v=expr)+' }'); results.append((line,v,cast,context))
 p=out/f'corpus-{strict}.c';p.write_text('\n'.join(lines)+'\n')
 oracle, old, new=(run(cc,p) for cc in [clang,base,candidate]); counts=collections.Counter()
 with (out/f'changes-{strict}.tsv').open('w') as f:
  for l,v,cast,ctx in results:
   a,b,c=(x.get(l,[]) for x in [oracle,old,new])
   label=('stable-correct' if a==c else 'stable-different') if b==c else ('fixed' if c==a else 'regression' if b==a else 'changed-different')
   counts[label]+=1
   if b!=c:print(l,v,cast,ctx,label,a,b,c,sep='\t',file=f)
 print('FENV_ACCESS',strict,len(results),'cases',dict(counts))
