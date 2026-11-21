# #1701 lifetime census: at each mark from parse to object-build, arena bytes resident and how many a later stage
# touches at all, reads, only writes, or never touches. Usage: python3 bounds.py census.tsv
import sys, collections
marks = []; arenas = []; gran = collections.defaultdict(list)
for line in open(sys.argv[1]):
    f = line.rstrip('\n').split('\t')
    if f[0] == 'mark': marks.append(f[2])
    elif f[0] == 'arena': arenas.append((int(f[5]), int(f[6])))
    elif f[0] == 'granule': gran[int(f[1])].append((int(f[3], 16), int(f[4], 16), [int(x) for x in f[5].split(',')]))
first = marks.index('parse'); last = marks.index('object-build')
print('mark stage              resident  any-later  read-later  write-only-later  none-later   (MB)')
first_touched = sum(max(rs) * 4096 for ai in gran for rd, wr, rs in gran[ai])
peak = 0; peak_any = 0; peak_read = 0
for m in range(first, last):
    res = anyl = readl = 0
    for ai, (c, r) in enumerate(arenas):
        if not (c <= m and (r == -1 or r > m)): continue
        for rd, wr, rs in gran[ai]:
            b = rs[m] * 4096 if m < len(rs) else 0
            res += b
            if any(((rd | wr) >> k) & 1 for k in range(m + 1, last + 1)): anyl += b
            if any((rd >> k) & 1 for k in range(m + 1, last + 1)): readl += b
    peak = max(peak, res); peak_any = max(peak_any, anyl); peak_read = max(peak_read, readl)
    print(f'{m:4d} {marks[m]:<18} {res/1e6:8.1f} {anyl/1e6:9.1f} {readl/1e6:10.1f} {(anyl-readl)/1e6:16.1f} {(res-anyl)/1e6:10.1f}')
print(f'arena pages first touched (largest residency of each granule, summed) {first_touched/1e6:.1f} MB; arena peak at a mark {peak/1e6:.1f} MB;'
      f' most touched later {peak_any/1e6:.1f} MB; most read later {peak_read/1e6:.1f} MB')
