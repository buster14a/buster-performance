# peak-sites.py DUMP BINARY SOURCES [STAGE]: ranks the arena pushes of a peak-map dump (peak-map.patch's peak_dump) by
# the resident KiB each holds, the latest push winning a page, labelled by the first frame outside lane.c. With STAGE
# (such as stage-7), the dump's block for that stage mark; without, the whole file (the reader's end).
import collections, subprocess, sys
dump, binary, sources = sys.argv[1], sys.argv[2], sys.argv[3]
text = open(dump).read()
if len(sys.argv) > 4:
    stage = sys.argv[4]
    text = text[:text.index('end ' + stage)]
    text = text[text.rindex(stage + ' VmHWM'):]
lines = [l.split() for l in text.split('\n') if l.startswith('push')]
addresses = sorted({f for l in lines for f in l[l.index('frames') + 1:]})
symbols = {}
for a in addresses:
    r = subprocess.run(['addr2line', '-f', '-i', '-e', binary, hex(int(a, 16) - 1)], capture_output=True, text=True).stdout.strip().split('\n')
    symbols[a] = [(r[i], r[i + 1].split('/')[-1].split(' ')[0]) for i in range(0, len(r) - 1, 2)]
cache = {}
def source_line(location):
    name, _, number = location.partition(':')
    try:
        if name not in cache:
            cache[name] = open(sources + '/' + name).read().split('\n')
        return cache[name][int(number.split()[0]) - 1].strip()[:110]
    except Exception:
        return ''
sites = collections.defaultdict(lambda: [0, 0, 0])
for l in lines:
    frames = [x for f in l[l.index('frames') + 1:] for x in symbols[f]]
    kept = [(fn, loc) for fn, loc in frames if not loc.startswith('lane.c') and fn != 'check_graph_column']
    key = kept[0] if kept else frames[0]
    sites[key][0] += int(l[l.index('present_kb') + 1])
    sites[key][1] += 1
    sites[key][2] += int(l[4])
print('pushes present KiB', sum(v[0] for v in sites.values()))
for (fn, loc), v in sorted(sites.items(), key=lambda kv: -kv[1][0]):
    if v[0] >= 256:
        print(f'{v[0]:8d} KiB {v[1]:3d}x {v[2] / 1048576:7.1f} MB  {fn} {loc}  | {source_line(loc)}')
