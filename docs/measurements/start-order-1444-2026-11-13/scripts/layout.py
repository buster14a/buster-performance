#!/usr/bin/env python3
# #1444 item 4: the code small compiles run, by function copy (address) and unit, and the 64 KB windows of .text (the
# kernel's fault-around) it touches as laid out and if the touched functions were packed.
#   layout.py SYMBOLS(readelf -sW) CONTROL.txt.gz... (perf script -F ip,brstack)
import bisect, collections, gzip, re, sys

funcs = []
current = None
for line in gzip.open(sys.argv[1], "rt") if sys.argv[1].endswith(".gz") else open(sys.argv[1]):
    p = line.split()
    if len(p) < 8 or not p[0].endswith(":"):
        continue
    kind, bind, ndx, name = p[3], p[4], p[6], p[7]
    if kind == "FILE":
        current = name
        continue
    if kind == "FUNC" and ndx != "UND":
        size = int(p[2], 0)
        if size and not name.endswith(".buster_split"):
            funcs.append([int(p[1], 16), size, name, current if bind == "LOCAL" else None])
funcs.sort()
# A global's unit: the unit whose locals' range holds it.
ranges = {}
for a, s, n, u in funcs:
    if u:
        lo, hi = ranges.get(u, (1 << 63, 0))
        ranges[u] = (min(lo, a), max(hi, a + s))
for f in funcs:
    if f[3] is None:
        f[3] = "libc/other"
        for u, (lo, hi) in ranges.items():
            if lo <= f[0] < hi:
                f[3] = u
starts = [f[0] for f in funcs]

def find(ip):
    i = bisect.bisect_right(starts, ip) - 1
    return i if i >= 0 and funcs[i][0] <= ip < funcs[i][0] + funcs[i][1] else -1

all_hit = set()
for path in sys.argv[2:]:
    ips = set()
    for line in gzip.open(path, "rt"):
        for tok in line.split():
            for part in tok.split("/")[:2]:
                if part.startswith("0x") or re.match(r"^[0-9a-f]+$", part):
                    try:
                        v = int(part, 16)
                    except ValueError:
                        continue
                    if 0x400000 <= v < 0x7f0000000000:
                        ips.add(v)
    hit = set()
    for ip in ips:
        i = find(ip)
        if i >= 0:
            hit.add(i)
    all_hit |= hit
    windows = {ip >> 16 for ip in ips if find(ip) >= 0}
    pages = {ip >> 12 for ip in ips if find(ip) >= 0}
    total = sum(funcs[i][1] for i in hit)
    byunit = collections.Counter()
    for i in hit:
        byunit[funcs[i][3]] += funcs[i][1]
    print("%s: %d functions, %d KB; %d pages, %d windows as laid out; packed %d windows" % (path.split("/")[-1], len(hit), total >> 10, len(pages), len(windows), (total + 65535) >> 16))
    print("   by unit (KB):", ", ".join("%s %d" % (u, b >> 10) for u, b in byunit.most_common()))
total = sum(funcs[i][1] for i in all_hit)
print("all: %d functions, %d KB, packed %d windows" % (len(all_hit), total >> 10, (total + 65535) >> 16))
with open("hot-functions.txt", "w") as out:
    for i in sorted(all_hit):
        a, s, n, u = funcs[i]
        out.write("%x %d %s %s\n" % (a, s, u, n))
