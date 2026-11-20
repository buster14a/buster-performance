#!/usr/bin/env python3
# join-round.py LIST 9700X_ROUND CLOUD_ROUND... > joined: a fault round run from its list's two ends at once (the 9700X
# from the first fault up, the cloud container's mutation trees from the last down): each fault's verdict by its name,
# from every file that has it; whether the files that both have a fault agree; and the faults with no verdict.
import re, sys
def load(p):
    src = open(p).read()
    line = [l for l in src.splitlines() if l.startswith('faults = ')][0]
    return [f[0] for f in eval(line[len('faults = '):])]
names = load(sys.argv[1])
verdicts = {}
for path in sys.argv[2:]:
    for line in open(path):
        m = re.match(r'(caught|SURVIVED|not-built|KILLED) (\d+) (\S+)', line)
        if m:
            assert names[int(m.group(2))] == m.group(3), (path, line)
            verdicts.setdefault(m.group(3), []).append((m.group(1), path.split('/')[-2] + '/' + path.split('/')[-1]))
missing = [x for x in names if x not in verdicts]
twice = [x for x in names if len(verdicts.get(x, [])) > 1]
differ = [x for x in twice if len(set(v for v, _ in verdicts[x])) > 1]
print('faults: %d; with a verdict: %d; with two or more: %d, of which they differ: %d; with none: %d' % (len(names), len(names) - len(missing), len(twice), len(differ), len(missing)))
for i, x in enumerate(names):
    v = verdicts.get(x, [])
    print('%-9s %3d %s%s' % (v[0][0] if v else 'NONE', i, x, '' if len(set(a for a, _ in v)) <= 1 else '  DIFFER: ' + ', '.join('%s (%s)' % a for a in v)))
print('caught: %d; SURVIVED: %d; other: %d' % (len([x for x in names if verdicts.get(x) and verdicts[x][0][0] == 'caught']), len([x for x in names if verdicts.get(x) and verdicts[x][0][0] == 'SURVIVED']),
                                              len([x for x in names if verdicts.get(x) and verdicts[x][0][0] not in ('caught', 'SURVIVED')])))
