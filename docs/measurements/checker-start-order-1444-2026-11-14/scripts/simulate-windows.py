#!/usr/bin/env python3
# #1444, the checker's section: the 64 KB windows the start list's functions touch, from a profiled build's samples, by
# region: .text.buster_start (main.c units' locals outside the checker's section), the by-name ones (first in .text) and
# the checker's section's listed ones, each packed in the list's order from a window's start, with each sample's offset
# in its function kept; under the list's order as given, and grouped by the first sample file that ran each.
#   simulate-windows.py SECTION LIST SYMBOLS.gz SAMPLES.gz...
# SECTION: `readelf -sW` of the checker unit's joined object (native.o), whose FUNC symbols in section 2
# (.text.buster_checker) name the section's functions; LIST: cmake/BusterStartOrder.txt; SYMBOLS and SAMPLES: the
# profiled build's `readelf -sW` and `perf script -F ip,brstack` files, smallest command first.
import bisect, collections, gzip, sys
secnames = set()
for line in open(sys.argv[1]):
    p = line.split()
    if len(p) >= 8 and p[3] == "FUNC" and p[6] == "2":
        secnames.add(p[7].replace(".buster_split", ""))
lines = [l.split() for l in open(sys.argv[2]) if not l.startswith('#') and l.strip()]
funcs = []; current = None
for line in gzip.open(sys.argv[3], "rt"):
    p = line.split()
    if len(p) < 8 or not p[0].endswith(":"): continue
    kind, bind, ndx, name = p[3], p[4], p[6], p[7]
    if kind == "FILE": current = name; continue
    if kind == "FUNC" and ndx != "UND":
        size = int(p[2], 0)
        if size and not name.endswith(".buster_split"):
            funcs.append([int(p[1], 16), size, name, current if bind == "LOCAL" else None])
funcs.sort(); starts = [f[0] for f in funcs]
def find(ip):
    i = bisect.bisect_right(starts, ip) - 1
    return i if i >= 0 and funcs[i][0] <= ip < funcs[i][0] + funcs[i][1] else -1
key = {}
for i, f in enumerate(funcs):
    key.setdefault((f[3] or '-', f[2]), i)
    if f[3] is None: key.setdefault(('-', f[2]), i)
listed = []
for u, n in lines:
    i = key.get((u, n))
    if i is not None: listed.append(i)
controls = []
for path in sys.argv[4:]:
    ips = set()
    for line in gzip.open(path, "rt"):
        for tok in line.split():
            for part in tok.split("/")[:2]:
                if part.startswith("0x"):
                    try: ips.add(int(part, 16))
                    except ValueError: pass
    off = collections.defaultdict(set)
    for ip in ips:
        i = find(ip)
        if i >= 0: off[i].add(ip - funcs[i][0])
    controls.append(off)
def region(i):
    f = funcs[i]
    if f[3] == 'main_unit_checker.c' and f[2] in secnames: return 'checker'
    if f[3] is None or not f[3].startswith('main'): return 'byname'
    return 'start'
def sim(order):
    base = {'start': 0x10000000, 'byname': 0x20000000, 'checker': 0x30000000}
    pos = dict(base); addr = {}
    for i in order:
        r = region(i); addr[i] = pos[r]; pos[r] += (funcs[i][1] + 15) & ~15
    res = []
    for off in controls:
        w = collections.Counter()
        seen = set()
        for i, os in off.items():
            if i in addr:
                for o in os:
                    k = (addr[i] + o) >> 16
                    if k not in seen: seen.add(k); w[region(i)] += 1
        res.append(dict(w))
    return res
print("list order ", sim(listed))
rank = {}
for c, off in enumerate(controls):
    for i in off: rank.setdefault(i, c)
by = sorted(listed, key=lambda i: (rank.get(i, 99), listed.index(i)))
print("by control ", sim(by))
