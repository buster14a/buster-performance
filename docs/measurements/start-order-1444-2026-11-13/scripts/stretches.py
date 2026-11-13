#!/usr/bin/env python3
# #1444: pages touched in each 2 MB-aligned stretch of each anonymous mapping, from a run in base pages
# (BUSTER_HUGE_PAGES=0): which stretches a huge page would back, and how much of each the run uses.
#   stretches.py STRACE FAULTS
import re, sys, collections
calls = []
cur = None
for line in open(sys.argv[1]):
    if line.startswith(" > "):
        if cur is not None:
            cur["stack"].append(line[3:].strip())
        continue
    m = re.match(r'^(?:\d+\s+)?(mmap|mprotect|madvise)\((.*)\)\s+=\s+(\S+)', line)
    cur = None
    if m:
        cur = {"call": m.group(1), "args": [a.strip() for a in m.group(2).split(",")], "result": m.group(3), "stack": []}
        calls.append(cur)
LAYER = re.compile(r'^(arena_\w+|mmap\w*|__mmap\w*|mprotect\w*|__mprotect\w*|madvise\w*|__madvise\w*|syscall|__GI_\w+|intern_\w+)$')
def who(stack):
    for l in stack:
        m = re.search(r'\(([^+)]+)\+0x[0-9a-f]+\)', l)
        f = m.group(1) if m else l
        if not LAYER.match(f):
            return f
    return "?"
maps = []
huge = []
for c in calls:
    if c["call"] == "mmap" and c["result"].startswith("0x") and "MAP_ANONYMOUS" in c["args"][3]:
        maps.append((int(c["result"], 16), int(c["args"][1]), who(c["stack"])))
    if c["call"] == "madvise" and c["args"][2] == "MADV_HUGEPAGE":
        huge.append((int(c["args"][0], 16), int(c["args"][1])))
pages = set()
for l in open(sys.argv[2]):
    p = l.split()
    if p:
        pages.add(int(p[0], 16) >> 12)
for start, size, name in maps:
    advised = [(a, n) for a, n in huge if start <= a < start + size]
    touched = sorted(q for q in pages if start >> 12 <= q < (start + size) >> 12)
    if not touched:
        continue
    by = collections.Counter(q >> 9 for q in touched)
    hs = []
    for a, n in advised:
        for s in range(a >> 21, (a + n) >> 21):
            hs.append(s)
    hs = set(hs)
    desc = []
    for s in sorted(by):
        desc.append("%s%d" % ("H:" if s in hs else "", by[s]))
    print("%-34s %12d  pages %4d  stretches(H: would be huge): %s" % (name, size, len(touched), " ".join(desc)))
