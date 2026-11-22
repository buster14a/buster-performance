import glob, os, statistics, collections, sys
# boundary-reduce.py DIRECTORY VARIANT...: medians of boundary.sh's variants' stages (runs that started on base pages
# left out), and the objects' hashes.
out = sys.argv[1]
vs = sys.argv[2:]
MIDDLE = ['check-input', 'check-expressions', 'check-declarations', 'static-data', 'check-program', 'select', 'lower']
FRONT = ['preprocess', 'parse']
BACK = ['tier0', 'emit-setup', 'branch-sizing', 'encode', 'unwind', 'code-atoms', 'publish-data', 'object-build', 'object-write']
def read(v):
    runs = collections.defaultdict(list)
    for f in sorted(glob.glob(os.path.join(out, v + '-*.stages'))):
        st, extra = {}, {}
        for line in open(f):
            p = line.rstrip('\n').split('\t')
            if p[0] == 'time-stage' and p[1] != 'stage':
                st[p[1]] = float(p[2])
            if p[0] == 'time-process' and p[1] in ('peak-rss-kb', 'minor-faults', 'system-ms', 'user-ms', 'huge-pages'):
                extra[p[1]] = p[2]
        if extra.get('huge-pages') != 'system':
            continue
        for k, x in st.items():
            runs[k].append(x)
        runs['middle'].append(sum(st.get(k, 0) for k in MIDDLE))
        runs['front'].append(sum(st.get(k, 0) for k in FRONT))
        runs['back'].append(sum(st.get(k, 0) for k in BACK))
        for k in ('peak-rss-kb', 'minor-faults', 'system-ms', 'user-ms'):
            runs[k].append(float(extra[k]))
    return {k: statistics.median(x) for k, x in runs.items()}, len(runs['total']), (min(runs['total']), max(runs['total'])) if runs['total'] else (0, 0)
t = {v: read(v) for v in vs}
print(' ' * 20 + ''.join(f'{v:>12}' for v in vs))
print(f'{"runs":20}' + ''.join(f'{t[v][1]:12d}' for v in vs))
for r in ['front', 'preprocess', 'parse', 'check-input', 'check-expressions', 'check-declarations', 'check-program', 'select', 'lower', 'lower.prepare', 'lower.statements',
          'lower.bodies', 'lower.validate', 'middle', 'tier0', 'back', 'total', 'user-ms', 'system-ms', 'peak-rss-kb', 'minor-faults']:
    print(f'{r:20}' + ''.join(f'{t[v][0].get(r, 0):12.3f}' for v in vs))
print(f'{"total, least":20}' + ''.join(f'{t[v][2][0]:12.3f}' for v in vs))
print(f'{"total, most":20}' + ''.join(f'{t[v][2][1]:12.3f}' for v in vs))
if os.path.exists(os.path.join(out, 'objects.txt')):
    print('objects:', open(os.path.join(out, 'objects.txt')).read().strip())
