from pathlib import Path
import csv,itertools,subprocess
p=Path(__file__).resolve().parent;w=p.parent;d=p/'raw-ir';d.mkdir(exist_ok=True)
rows=[];bits=[]
for sign,exponent,low in itertools.product([0,0x8000],[0,1,0x3fff,0x7ffe,0x7fff],[0,1,0x4000000000000000,0x7fffffffffffffff,0x8000000000000000,0x8000000000000001,0xc000000000000001,0xffffffffffffffff]):
 hi=sign|exponent;bits.append((low,hi))
for j,(lo,hi) in enumerate(bits):
 f=d/f'raw-{j}.ir';f.write_text('function (ptr, i64) -> void {\nb0:\n  %0 = param.ptr 0\n  %1 = param.i64 1\n  %2 = const.f80 0x%04x%016x\n  %%3 = store.void %%0, %%2 align=1\n  %%4 = ret.void\n}\n'.replace('%0 =','%%0 =').replace('%1 =','%%1 =').replace('%2 =','%%2 =')%(hi,lo))
 for v,t in [('parent','x87-double'),('candidate','x87-rom')]:
  result=subprocess.run([w/t/'build/compiler','test-tier1-wide','--file',f],capture_output=True,text=True,timeout=30)
  full=result.stdout+result.stderr
  (d/f'{v}-{j}.log').write_text(full)
  rows.append([j,hex(hi),hex(lo),v,result.returncode,full.splitlines()[-1] if full else '']);
with (d/'results.tsv').open('w') as f:
 s=csv.writer(f,delimiter='\t',lineterminator='\n');s.writerow(['case','sign_exponent','significand','variant','exit','result']);s.writerows(rows)
print(len(rows),'runs;',sum(r[4]==0 for r in rows),'passed')
