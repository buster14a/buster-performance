# sites.py DIR: the LBR's mispredicted sites of DIR (sites.top, sites.sym, sites.raw from lbr.sh), by source line.
import sys, collections
def load(d):
    total = int(open(d + '/sites.raw').readline().split()[4])
    entries = int(open(d + '/sites.raw').readline().split()[2])
    top = [l.rstrip('\n').split('\t') for l in open(d + '/sites.top')]
    blocks = open(d + '/sites.sym').read().strip('\n').split('\n\n')
    rows = []
    for (site, m, a), b in zip(top, blocks):
        lines = b.split('\n')
        loc = lines[1].split('/src/buster/compiler/')[-1]
        loc = ':'.join(loc.split(':')[:2])
        rows.append((lines[0], loc, int(m), int(a), site))
    return total, entries, rows
for d in sys.argv[1:]:
    total, entries, rows = load(d)
    print(f'== {d}: {entries} entries, {total} mispredicted')
    cum = 0
    for i, (fn, loc, m, a, site) in enumerate(rows[:int(sys.argv[0:1] and 40)]):
        cum += m
        print(f'{i+1:3d} {m/total*100:5.2f}% {cum/total*100:5.1f}% {m/a*100:4.0f}%  {fn:38s} {loc:36s} {site}')
