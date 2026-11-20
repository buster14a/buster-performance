from pathlib import Path
p=Path(__file__).resolve().parent
import random
random.seed(1387);bits=1<<63;raw=[]
def add(lo,hi):
 if (lo,hi) not in raw:raw.append((lo,hi))
for neg in (0,0x8000):
 add(0,neg)
 for e in (-16382,-1074,-1022,-150,-149,-127,-126,-125,-25,-1,0,1,23,54,126,127,128,1023,16383):
  for m in (0,1<<40,0x7fffff<<40,1):
   add(bits|m,neg|(e+16383))
 add(1,neg);add(bits-1,neg)
 for _ in range(18):
  e=random.randrange(-126,128);add(bits|random.randrange(1<<23)<<40,neg|(e+16383))
def val(lo,hi):
 exponent=hi&32767
 return ('-' if hi&32768 else '')+('0x1.' if exponent else '0x0.')+format((lo&(bits-1))*2,'016x')+'p'+str(exponent-16383 if exponent else -16382)+'L'
src=['extern long double pass(long double);'];decl=[];rows=[]
for k,(low,high) in enumerate(raw):
 c=val(low,high)
 args=[('long double','get','void',f'return {c};'),('void','put','long double *out',f'*out = {c};'),('long double','arg','void',f'return pass({c});'),('long double','plus','long double x',f'return x + {c};'),('long double','minus','long double x',f'return {c} - x;'),('int','less','long double x',f'return x < {c};'),('long double','choose','int x',f'return x ? {c} : 0x1.0000000000000002p0L;')]
 for typ,n,a,b in args:
  name=f'{n}_{k}';decl.append(f'{typ} {name}({a});');src.append(f'{typ} {name}({a}) {{ {b} }}')
 rows.append('{ UINT64_C(0x%016x), 0x%04x, '%(low,high)+', '.join(f'{n}_{k}' for _,n,_,_ in args)+' },')
(p/'leaves.c').write_text('\n'.join(src)+'\n');(p/'cases.h').write_text('\n'.join(decl)+'\nstatic const struct Case cases[] = {\n'+'\n'.join(rows)+'\n};\n');(p/'constants.tsv').write_text('case\textended_significand\textended_sign_exponent\tliteral\teligible_binary32\n'+''.join(f'{i}\t{lo:016x}\t{hi:04x}\t{val(lo,hi)}\t{int((hi&32767)==0 and lo==0 or 16257<=(hi&32767)<=16510 and lo>>63 and not lo%(1<<40))}\n' for i,(lo,hi) in enumerate(raw)))
