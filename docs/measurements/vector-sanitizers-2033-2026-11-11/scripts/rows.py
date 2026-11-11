# rows.py DIR: each x86-64 and native row's wall time, runner-minutes, builds and CPUs, from saved jobs pages.
import json, sys, glob, re
from datetime import datetime
jobs=[]
for f in sorted(glob.glob(sys.argv[1]+'/jobs-*.json')):
    jobs+=json.load(open(f))['jobs']
def t(x): return datetime.strptime(x,'%Y-%m-%dT%H:%M:%SZ')
B='Build the external Clang pragma oracle, the clang server and the compiler'
I="Verify and install this row's compiler product"
T='Run correctness tests within the hosted CPU budget'
rows={}
for j in jobs:
    m=re.match(r'Tests on Ubuntu 26.04 \((x86-64|native), (\w+), O3\) / (.*)', j['name'])
    if not m or j['conclusion']=='skipped' or not j['completed_at']: continue
    rows.setdefault((m.group(1),m.group(2)),[]).append(j)
for k,v in sorted(rows.items()):
    wall=(max(t(j['completed_at']) for j in v)-min(t(j['started_at']) for j in v)).total_seconds()/60
    rm=sum((t(j['completed_at'])-t(j['started_at'])).total_seconds() for j in v)/60
    builds=[]; tests=[]; fails=0
    for j in v:
        fails+= j['conclusion']!='success'
        for s in j['steps']:
            if s['conclusion'] in (None,'skipped') or not s['completed_at']: continue
            d=(t(s['completed_at'])-t(s['started_at'])).total_seconds()
            if s['name']==B: builds.append(int(d))
            if s['name']==T: tests.append(int(d))
    print(f"{k[0]:6} {k[1]:7} jobs {len(v)} wall {wall:5.1f} min runner-min {rm:6.1f} builds {builds} tests max {max(tests) if tests else 0} fails {fails}")
