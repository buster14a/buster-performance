# analyze.py JOBS_JSON_DIR: per-configuration wall time and runner-minutes, vector items' step timings.
import json, sys, os, re, glob
from datetime import datetime
d = sys.argv[1]
jobs = []
for f in sorted(glob.glob(os.path.join(d, 'job-*.json'))):
    jobs.append(json.load(open(f)))
def t(x): return datetime.strptime(x, '%Y-%m-%dT%H:%M:%SZ') if x else None
def dur(a, b): return (t(b) - t(a)).total_seconds() if a and b else 0
rows = {}
for j in jobs:
    n = j['name']
    if j['conclusion'] == 'skipped' or not j['started_at'] or not j['completed_at']:
        continue
    m = re.match(r'Tests on Ubuntu 26.04 \((x86-64|native|vector), ([a-z ]+), O3\) / (.*)', n)
    if not m: continue
    arch, san, own = m.groups()
    if arch == 'vector':
        key = ('vector', 'pool')
    else:
        key = (arch, san)
    rows.setdefault(key, []).append(j)
for key, js in sorted(rows.items()):
    start = min(t(j['started_at']) for j in js); end = max(t(j['completed_at']) for j in js)
    mins = sum(dur(j['started_at'], j['completed_at']) for j in js) / 60
    print(f"{key[0]:7} {key[1]:8} jobs {len(js):3} wall {(end-start).total_seconds()/60:6.1f} min  runner-minutes {mins:7.1f}  fail {sum(1 for j in js if j['conclusion'] != 'success')}")
