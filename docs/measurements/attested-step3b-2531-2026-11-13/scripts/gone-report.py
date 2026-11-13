# gone-report.py DIR: what a skipped token still costs the reader (and the passes), from gone.sh's probe files in DIR: the
# preprocessed units as they are with the compile's skip, less the same units with the emulation's skipped tokens gone,
# by phase, in TSC ticks a token the compile skipped (the least of the rounds each way).
import sys, re
D = sys.argv[1].rstrip('/') + '/'
names = {0: 'count_tokens', 19: '..sparse reserve', 21: '..graph', 22: 'sparse arena', 23: 'bindings init', 1: '..alloc to clears', 24: 'clears: tokens',
         26: 'clears: names', 27: 'clears: tags, builtins', 2: 'none fills', 3: 'tree columns', 4: 'commas..pragmas', 5: 'intrinsic',
         6: 'overload/system/attr/starts', 7: 'walk', 8: 'controls..', 9: 'bindings', 28: 'typo..builtin capacity', 17: '..region+sizeof',
         18: 'expressions', 10: '..events', 11: 'events', 12: 'publish..', 25: 'release'}
order = [0, 19, 21, 22, 23, 1, 24, 26, 27, 2, 3, 4, 5, 6, 7, 8, 9, 28, 17, 18, 10, 11, 12, 25]
def load(f):
    lines = open(D + f).read().split('\n')
    t = lines[0].split()[1:]
    d = {t[i]: int(t[i + 1]) for i in range(0, len(t), 2)}
    m = [re.search(r'skipped \d+ of \d+ file-scope declarations, (\d+) of', line) for line in lines[1:]]
    m = [x for x in m if x]
    return d, int(m[0].group(1)) if m else None
for corpus in ('musl', 'glibc'):
    print('== %s: TSC ticks a skipped token, main and the head' % corpus)
    rows = []
    for tree in ('main', 'head'):
        on = [load('gone-%s-i-on-%s%d.txt' % (corpus, tree, r)) for r in (1, 2)]
        off = [load('gone-%s-live-off-%s%d.txt' % (corpus, tree, r))[0] for r in (1, 2)]
        skipped = on[0][1]
        row = {k: (min(o[0].get('p%d' % k, 0) for o in on) - min(g.get('p%d' % k, 0) for g in off)) / skipped for k in order}
        row['passes'] = min(sum(v for k, v in o[0].items() if k.startswith('a')) for o in on) / skipped
        row['tokens'] = (on[0][0]['tokens'], off[0]['tokens'], skipped)
        rows.append(row)
    for k in order:
        if abs(rows[0][k]) >= 0.3 or abs(rows[1][k]) >= 0.3:
            print('%-28s %7.1f %7.1f' % (names[k], rows[0][k], rows[1][k]))
    reader = [sum(r[k] for k in order) for r in rows]
    print('%-28s %7.1f %7.1f' % ('the reader', reader[0], reader[1]))
    print('%-28s %7.1f %7.1f' % ('the passes', rows[0]['passes'], rows[1]['passes']))
    print('%-28s %7.1f %7.1f' % ('both', reader[0] + rows[0]['passes'], reader[1] + rows[1]['passes']))
    tokens = rows[0]['tokens']
    print('tokens: as they are %d, gone %d (the emulation skipped %d), the compile skipped %d, so that it reads %d tokens the gone units lack' %
          (tokens[0], tokens[1], tokens[0] - tokens[1], tokens[2], tokens[0] - tokens[1] - tokens[2]))
