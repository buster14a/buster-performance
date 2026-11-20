# perfdiff.py LIST: instructions:u samples (period 100003) by function, summed over three runs, head less base.
import collections, sys
for lst in sys.argv[1:]:
    tot = {}
    for b in ('base', 'head'):
        c = collections.Counter()
        for i in (1, 2, 3):
            for line in open(f'logs/perf/{lst}-{b}-{i}.txt'):
                w = line.split()
                if len(w) >= 3 and w[0].isdigit() and w[1] == '[.]':
                    c[w[2]] += int(w[0])
        tot[b] = c
    keys = set(tot['base']) | set(tot['head'])
    diff = sorted(((tot['head'][k] - tot['base'][k], k) for k in keys), key=lambda x: -abs(x[0]))
    print(lst, 'samples: base', sum(tot['base'].values()), 'head', sum(tot['head'].values()))
    for d, k in diff[:12]:
        print(f'  {d:+6d} {k} (base {tot["base"][k]}, head {tot["head"][k]})')
