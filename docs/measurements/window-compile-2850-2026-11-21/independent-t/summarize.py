import collections
import re
import sys
from pathlib import Path
text = Path(sys.argv[1]).read_text()
enums = Path('src/buster/compiler/c_check_actions.c').read_text().split('typedef enum CheckOp\n{')[1].split('} CheckOp;')[0]
ops = re.findall(r'^\s*(CHECK_OP_\w+)(?:\s*=.*)?\s*,',enums,re.M)
end = ops.index('CHECK_OP_COUNT') if 'CHECK_OP_COUNT' in ops else len(ops)
ops = ops[:end] + ['cut region','identifier without unqualified built-in integer type/line', 'literal without unqualified built-in integer type/line','string or other unmodelled leaf']
totals=collections.defaultdict(lambda:[0,0,0])
for b,n,m,r in re.findall(r'node-proof bucket=(\d+) roots=(\d+) made=(\d+) records=(\d+)',text):
    for i,v in enumerate([n,m,r]): totals[int(b)][i] += int(v)
reasons=collections.defaultdict(collections.Counter)
for b,r,n in re.findall(r'node-proof refusal bucket=(\d+) reason=(\d+) roots=(\d+)',text):
    reasons[int(b)][ops[int(r)] if int(r)<len(ops) else str(r)] += int(n)
accepted=collections.defaultdict(lambda:collections.defaultdict(lambda:[0,0]))
for b,op,n,r in re.findall(r'node-proof accepted bucket=(\d+) operand=(\d+) roots=(\d+) records=(\d+)',text):
    row=accepted[int(b)][ops[int(op)]]
    row[0]+=int(n); row[1]+=int(r)
compared=re.findall(r'node-proof compared records=(\d+)',text)
for b in sorted(totals):
    print(['statement','condition','return','other','declaration discard'][b],totals[b],reasons[b].most_common(6))
    print(sorted(accepted[b].items(),key=lambda pair:-pair[1][1])[:6])
print('compared expressions',len(compared),'records',sum(map(int,compared)),'mismatching records',sum('node-proof difference ' in line for line in text.splitlines()))

stream=[list(map(int,m)) for m in re.findall(r'node-proof stream roots=(\d+) records=(\d+) bad-roots=(\d+) differences=(\d+)',text)]
if stream:
    print('whole-program stream roots, records, bad roots, wrong records:',[sum(group) for group in zip(*stream)])
    print('unbound regions',text.count('node-proof missing region'),'out of room',text.count('node-proof no space'))
