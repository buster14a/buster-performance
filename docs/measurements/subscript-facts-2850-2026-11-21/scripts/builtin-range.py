"""Audit the canonical range and partial table guard against the pinned type definitions."""
import re,sys
from pathlib import Path
src=(Path(sys.argv[1])/'src/buster/compiler/c_types.c').read_text()
codes={name:int(num) for name,num in re.findall(r'^#define BUSTER_TYPE_CODE_(\w+) (\d+)$',src,re.M)}
entries={codes[name]:kind for name,kind in re.findall(r'\[BUSTER_TYPE_CODE_(\w+)\] = \{\s*\.name = [^\n]+\n\s*\.kind = BUSTER_TYPE_KIND_(\w+),',src)}
integer={i for i,kind in entries.items() if kind=='INTEGER'}
assert integer==set(range(codes['BOOL'],codes['UINT128']+1)),integer
# Unlike the source proof/executable, the reference knows only the type definition and current table prefix.
cases=0; mutant={}
for rows in range(65):
 for i in range(64):
  for q in range(8):
   raw=(i<<3)|q
   original=i<rows and i in integer
   def test(hi,guard):
    if (not guard or rows>codes['UINT128']) and codes['BOOL']*8<=raw<=(hi*8|7): return True
    return original
   actual=test(codes['UINT128'],True)
   assert original==actual
   for label,fault in [('include-BF16',test(codes['BF16'],True)),('omit-partial-row-guard',test(codes['UINT128'],False))]:
    if fault!=original: mutant[label]=mutant.get(label,0)+1
   cases+=1
print(cases,'canonical qualified row-prefix classifications match',sorted(integer))
print('negative controls',mutant)
assert len(mutant)==2
