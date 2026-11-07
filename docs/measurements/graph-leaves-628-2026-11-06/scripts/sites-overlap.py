# sites-in.py DUMP BINARY SOURCES STAGE LO HI: peak-sites.py restricted to pushes whose start lies in [LO, HI).
import collections, subprocess, sys
dump, binary, sources, stage, lo, hi = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], int(sys.argv[5], 16), int(sys.argv[6], 16)
text = open(dump).read()
text = text[:text.index('end ' + stage)]
text = text[text.rindex(stage + ' VmHWM'):]
lines = [l.split() for l in text.split('\n') if l.startswith('push')]
lines = [l for l in lines if int(l[2], 16) < hi and int(l[2], 16) + int(l[4]) > lo]
addresses = sorted({f for l in lines for f in l[l.index('frames') + 1:]})
symbols = {}
for a in addresses:
    r = subprocess.run(['addr2line', '-f', '-i', '-e', binary, hex(int(a, 16) - 1)], capture_output=True, text=True).stdout.strip().split('\n')
    symbols[a] = [(r[i], r[i + 1].split('/')[-1].split(' ')[0]) for i in range(0, len(r) - 1, 2)]
sites = collections.defaultdict(lambda: [0, 0, 0])
for l in lines:
    frames = [x for f in l[l.index('frames') + 1:] for x in symbols[f]]
    kept = [(fn, loc) for fn, loc in frames if not loc.startswith('lane.c') and fn != 'check_graph_column']
    key = kept[0] if kept else frames[0]
    sites[key][0] += int(l[l.index('present_kb') + 1]); sites[key][1] += 1; sites[key][2] += int(l[4])
print('present KiB', sum(v[0] for v in sites.values()))
for (fn, loc), v in sorted(sites.items(), key=lambda kv: -kv[1][0]):
    if v[0] >= 512: print(f'{v[0]:8d} KiB {v[1]:3d}x {v[2] / 1048576:7.1f} MB  {fn} {loc}')
