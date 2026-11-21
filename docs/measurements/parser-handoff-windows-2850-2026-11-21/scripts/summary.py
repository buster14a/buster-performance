from pathlib import Path
import re, statistics as st, sys
from collections import defaultdict
root=Path(sys.argv[1])
data=defaultdict(lambda:defaultdict(lambda:defaultdict(list)))
def add(kind,round,variant,metric,val):
 data[kind,metric][round][variant].append(float(val))
for name in ('timing-windows','timing-requests','tile-study','tile-followup'):
 d=root/name
 if not (d/'status').exists(): continue
 for row in (d/'status').read_text().splitlines():
  r,pos,v=row.split(); p=d/f'{r}-{pos}-{v}'
  for mode in (['kernels'] if name.startswith('timing-') else ['tree','tree-sizes']):
   fn=Path(str(p)+('.kernels' if name.startswith('timing-') else '-'+mode+'.out'))
   for l in fn.read_text().splitlines():
    m=re.match(r'^\s+(\S+)\s+(\S+) ms\s+\S+ ns/token\s+(\S+) cycles/token \[[^]]+\]\s+(\S+) instructions/token',l)
    if m and (name.startswith('timing-') or m[1]==mode):
     add(name,r,v,m[1]+' cycles/t',m[3]);add(name,r,v,m[1]+' ins/t',m[4])
  for line in Path(str(p)+'.stages').read_text().splitlines():
   cols=line.split('\t')
   if len(cols)>=3 and cols[0]=='time-stage' and cols[1] in ('preprocess','parse','check-input','total'):
    add(name,r,v,cols[1]+' ms',cols[2])
    if len(cols)>=7 and cols[1]=='parse': add(name,r,v,'parse minor faults',cols[5]);add(name,r,v,'parse peak KiB',cols[6])
  for line in Path(str(p)+'.perf').read_text().splitlines():
   cols=line.split(';')
   if len(cols)>=3 and cols[0].isdigit():add(name,r,v,cols[2],cols[0])
  if name.startswith('timing-'):
   for page in ('auto','huge'):
    fn=Path(str(p)+'-'+page+'.wall')
    for line in fn.read_text().splitlines():
     m=re.match(r'run \d+ list \d+: (\S+) ms wall.*?, (\d+) KiB wait4 peak, (\d+) minor faults, \d+ major, (\d+) user cycles, (\d+) instructions, status 0',line)
     if m:
      for metric,value in zip(('wall ms','RSS KiB','faults','cycles','instructions'),m.groups()):add(name,r,v,page+' '+metric,value)
for (kind,metric),rounds in data.items():
 if metric not in ('vector cycles/t','vector ins/t','vector-k6 cycles/t','vector-k6 ins/t','vector-fallback cycles/t','vector-fallback ins/t','tree cycles/t','tree-sizes cycles/t','tree-sizes ins/t','preprocess ms','parse ms','check-input ms','total ms','cycles:u','instructions:u','parse minor faults','auto wall ms','huge wall ms','auto RSS KiB','auto instructions'):continue
 variants=sorted(set(k for arms in rounds.values() for k in arms))
 for v in variants:
  if v=='before':continue
  vals=[(st.median(arms['before']),st.median(arms[v])) for arms in rounds.values() if arms.get('before') and arms.get(v)]
  if not vals:continue
  diff=[100*(b/a-1) for a,b in vals if a]
  print(f'{kind:16s} {metric:26s} {v:9s} {len(vals):2d} {st.median(a for a,b in vals):13,.3f} {st.median(b for a,b in vals):13,.3f} {st.median(diff):+8.3f}% [{min(diff):+.3f},{max(diff):+.3f}]')
