import sys
# pfwindows.py PERF_SCRIPT_TXT SLICES_TXT: whether the stage's snapshot faults are one per 64 KB window of the pages the
# link reads (written when the record was assembled, 2026-11-20). The kernel's fault-around maps the page-cache pages of
# the 64 KB window, aligned in the address space, around a file fault; so a window is counted at the mapping's own
# alignment (its start's page index mod 16), and at every other phase for comparison. slices.txt is another process's
# run of the same link (dbg, DBG2546=1); its slices are file offsets, so its pages can be compared with the faults'.
sys.path.insert(0, sys.argv[0].rsplit('/', 1)[0])
from pfparse import parse, mapping
samples, mmaps = parse(sys.argv[1])
def has(s, names):
    return any(any(n in f for n in names) for f in s['chain'])
first = next(i for i, s in enumerate(samples) if has(s, ['bind_end']))
end = next(i for i, s in enumerate(samples) if i > first and has(s, ['check_driver_write_main', 'executable_write', 'lane_run']))
faulted = []
start = None
for s in samples[first:end]:
    mp = mapping(mmaps, s['addr'], s['t'])
    if mp and mp[2].endswith('.snapshot'):
        start = mp[0]
        faulted.append((s['addr'] - mp[0]) >> 12)
read = set()
for line in open(sys.argv[2]):
    f = line.split()
    if len(f) == 6 and f[0] == 'dbg2546' and int(f[5]) != 0:
        offset, size = int(f[4]), int(f[5])
        read.update(range(offset >> 12, ((offset + size - 1) >> 12) + 1))
phase = (start >> 12) & 15
print('snapshot faults in the stage: %d, at %d distinct pages; the mapping starts at %x, page phase %d' % (len(faulted), len(set(faulted)), start, phase))
print('pages the link reads: %d' % len(read))
print('phase\twindows read\twindows faulted\tfaults outside the windows read\twindows read without a fault')
for p in range(16):
    windows = set((x + p) >> 4 for x in read)
    hit = set((x + p) >> 4 for x in faulted)
    print('%d%s\t%d\t%d\t%d\t%d' % (p, ' (the mapping\'s)' if p == phase else '', len(windows), len(hit), len(hit - windows), len(windows - hit)))
