import sys, glob, os, statistics, collections
# bound-reduce.py DIRECTORY VARIANT...: each variant's median stage times, and their differences from the first variant's.
out = sys.argv[1]; variants = sys.argv[2:]
MIDDLE = ['check-input', 'check-expressions', 'check-declarations', 'static-data', 'check-program', 'select', 'lower']
FRONT = ['preprocess', 'parse']
BACK = ['tier0', 'emit-setup', 'branch-sizing', 'encode', 'unwind', 'code-atoms', 'publish-data', 'object-build', 'object-write']
table = {}
for v in variants:
    runs = collections.defaultdict(list)
    busy = 0
    for f in sorted(glob.glob(os.path.join(out, f'{v}-*.stages'))):
        stage = {}
        pages = ''
        for line in open(f):
            p = line.rstrip('\n').split('\t')
            if p[0] == 'time-stage' and p[1] != 'stage':
                stage[p[1]] = float(p[2])
            if p[0] == 'time-process' and p[1] == 'huge-pages':
                pages = p[2]
            if p[0] == 'time-process' and p[1] == 'tokens':
                stage['tokens'] = float(p[2])
        if pages != 'system':
            busy += 1
            continue
        for k, x in stage.items():
            runs[k].append(x)
        runs['middle'].append(sum(stage.get(k, 0) for k in MIDDLE))
        runs['front'].append(sum(stage.get(k, 0) for k in FRONT))
        runs['back'].append(sum(stage.get(k, 0) for k in BACK))
    table[v] = ({k: statistics.median(x) for k, x in runs.items()}, len(runs['total']), busy)
rows = ['tokens', 'front', 'check-input', 'check-expressions', 'check-declarations', 'check-program', 'select', 'lower', 'middle', 'back', 'total']
print(f'{"":20}' + ''.join(f'{v:>16}' for v in variants))
print(f'{"runs (left out)":20}' + ''.join(f'{str(table[v][1]) + " (" + str(table[v][2]) + ")":>16}' for v in variants))
for r in rows:
    print(f'{r:20}' + ''.join(f'{table[v][0].get(r, 0):16.3f}' for v in variants))
base = table[variants[0]][0]
print()
for r in ['middle', 'front', 'back', 'total']:
    print(f'{r + " less the first":20}' + ''.join(f'{table[v][0][r] - base[r]:+16.3f}' for v in variants))
