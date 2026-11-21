from pathlib import Path
import csv, re, statistics as st, sys
from collections import defaultdict

raw = Path(sys.argv[1])
out = Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)
counts = {'musl': (115610, 154132, 2396), 'sqlite3': (257465, 346998, 2400)}
samples, rounds, summary = [], [], []
by_process = defaultdict(list)
for path in sorted(raw.glob('*.txt')):
    corpus, cache, rd, pos, mode = path.stem.split('-')
    rd, pos = int(rd), int(pos)
    s = path.read_text()
    origin = re.search(r"nodes=(\d+) \([^\n]*the first path's nodes=(\d+)\s+taken by the first path alone: expressions=0 nodes=0\s+by this one alone=0", s)
    assert origin and origin[1] == origin[2], path
    n = int(origin[1])
    assert n == counts[corpus][0]
    checks = re.search(r"first path: emitted=(\d+) wrong-expressions=0 wrong-entries=0\s+this path: emitted=(\d+) wrong-expressions=0 wrong-entries=0", s)
    assert checks and checks[1] == checks[2] and int(checks[1]) == counts[corpus][1], path
    for phrase in ["facts differing from the truth=0", "contexts or targets differing from the truth=0", "templates differing from the first path's=0"]:
        assert phrase in s, path
    if mode != 'qualdynamic':
        oracle = re.search(r"mutation oracle\s+(\d+) original keys and (\d+) refused queries", s)
        assert oracle and int(oracle[1]) == counts[corpus][2] and int(oracle[2]) > 300000, path
    pmu = [list(map(int, line.split()[1:])) for line in s.splitlines() if line.startswith('counters\t')]
    assert [r[0] for r in pmu] == list(range(21)) and all(r[1] == n for r in pmu), path
    for r in pmu: samples.append([corpus,cache,rd,pos,mode,*r])
    stats = [st.median(r[k]/n for r in pmu) for k in (2,3,4,5)]
    by_process[corpus,cache,rd].append((pos,mode,stats))
assert len(by_process) == 20
for (corpus,cache,rd), rawrows in sorted(by_process.items()):
    rows=sorted(rawrows)
    assert [r[0] for r in rows] == list(range(4)) and rows[0][1] == rows[3][1] and rows[1][1] == rows[2][1] and rows[0][1] != rows[1][1]
    for m in sorted({r[1] for r in rows}):
        rounds.append([corpus,cache,rd,m,*[st.mean(r[2][k] for r in rows if r[1] == m) for k in range(4)]])
ref = sys.argv[3]
for corpus,cache in sorted({tuple(r[:2]) for r in rounds}):
    r = [x for x in rounds if x[:2] == [corpus,cache]]
    for mode in sorted({x[3] for x in r}):
        for k,metric in enumerate(['ticks','cycles','instructions','branch misses'],4):
            xs=[x[k] for x in r if x[3]==mode];ys=[x[k] for x in r if x[3]==ref]
            dd=[x-y for x,y in zip(xs,ys)];assert len(xs)==len(ys)==5
            summary.append([corpus,cache,mode,metric,st.median(xs),min(xs),max(xs),st.median(dd),min(dd),max(dd),sum(v<0 for v in dd)])
            if metric in ('cycles','branch misses'):print(corpus,cache,mode,metric,*(round(v,4) for v in summary[-1][4:8]))
for name,head,rr in [
    ('counters',['input','cache','round','position','mode','pass','taken nodes','ticks','cycles','instructions','branch misses'],samples),
    ('rounds',['input','cache','round','mode','ticks/node','cycles/node','instructions/node','branch misses/node'],rounds),
    ('summary',['input','cache','mode','metric per taken node','median','min round mean','max round mean','median paired difference','min difference','max difference','lower rounds'],summary)]:
    with (out/(name+'.tsv')).open('w') as f:
        w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(head);w.writerows(rr)
