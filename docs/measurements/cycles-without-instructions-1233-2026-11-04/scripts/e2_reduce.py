#!/usr/bin/env python3
"""#1233 E2: each process's samples by event and function, from `perf script -F event,ip,dso -i lua-B-R.data` texts
(lua-B-R.txt in DIRECTORY), functions found by address in each build's nm -n -S (M and A main's, H the merge's),
keyed by name and occurrence; samples outside the executable by their file. Writes CSV: build,run,event,function,
occurrence,address,count."""
import sys, re, bisect, collections, glob, os, csv
def load(path):
    seen = collections.Counter(); starts = []; info = []
    for line in open(path):
        f = line.split()
        if len(f) != 4 or f[2] not in 'tTwW':
            continue
        addr, size, name = int(f[0], 16), int(f[1], 16), f[3]
        seen[name] += 1
        starts.append(addr); info.append(((name, seen[name]), addr, size))
    return starts, info
nm = {'M': load(sys.argv[1]), 'H': load(sys.argv[2])}; nm['A'] = nm['M']
pat = re.compile(r'^\s*(\S+?):\s+([0-9a-f]+)\s+\((.*)\)')
out = csv.writer(sys.stdout)
out.writerow(['build', 'run', 'event', 'function', 'occurrence', 'address', 'count'])
for path in sorted(glob.glob(os.path.join(sys.argv[3], 'lua-*-*.txt'))):
    b, r = os.path.basename(path)[:-4].split('-')[1:3]
    c = collections.Counter(); where = {}
    for line in open(path):
        m = pat.match(line)
        if not m:
            continue
        ev, ip, dso = m.group(1).split('/')[0], int(m.group(2), 16), m.group(3)
        if not dso.endswith('compiler'):
            key, at = ('[' + os.path.basename(dso) + ']', 1), 0
        else:
            starts, info = nm[b]
            i = bisect.bisect_right(starts, ip) - 1
            ok = i >= 0 and ip < info[i][1] + max(info[i][2], 1)
            key, at = (info[i][0], info[i][1]) if ok else (('?', 1), 0)
        c[(ev, key)] += 1; where[key] = at
    for (ev, key), n in sorted(c.items()):
        out.writerow([b, r, ev, key[0], key[1], hex(where[key]), n])
