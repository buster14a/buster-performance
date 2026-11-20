import sys, collections
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from pfparse import parse, mapping
samples, mmaps = parse(sys.argv[1])
def has(s, names):
    return any(any(n in f for n in names) for f in s['chain'])
first = next(i for i, s in enumerate(samples) if has(s, ['bind_end']))
end = next(i for i, s in enumerate(samples) if i > first and has(s, ['check_driver_write_main', 'executable_write', 'lane_run']))
win = samples[first:end]
# mmaps during window
t0, t1 = win[0]['t'], win[-1]['t']
print('mmaps in window:')
for m in mmaps:
    if t0 <= m[0] <= t1: print('  %.6f %x+%x %s %s' % (m[0], m[1], m[2]-m[1], m[4], m[3]))
groups = collections.defaultdict(list)
for s in win:
    mp = mapping(mmaps, s['addr'], s['t'])
    groups[mp[0] if mp else 0].append(s)
for base, ss in groups.items():
    offs = sorted(set(((s['addr'] - base) >> 12) for s in ss))
    print('mapping %x: %d faults, page offsets (4K) %s' % (base, len(ss), offs if len(offs) < 40 else (str(offs[:20]) + ' ... ' + str(offs[-10:]))))
