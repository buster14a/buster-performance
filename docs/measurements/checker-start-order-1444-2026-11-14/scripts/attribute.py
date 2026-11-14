#!/usr/bin/env python3
# #1444 items 1 and 2: a small compile's memory system calls and page faults, by the code that made each mapping.
#   attribute.py STRACE FAULTS SECTIONS
# STRACE: strace -f -k -e trace=mmap,munmap,mprotect,madvise,brk's log of one run with the address space's
# randomization off (setarch -R); FAULTS: perf script -F addr,ip,sym of perf record -e page-faults -c 1 -d of another run
# under the same conditions, so that the two runs' mappings are at the same addresses; SECTIONS: readelf -SW's
# sections as "NAME ADDRESS SIZE" lines.
import re
import sys
import collections

# Frames of the arena layer (lane.c) and of libc's wrappers: a mapping is named for the first caller past them.
LAYER = re.compile(r'^(arena_\w+|mmap\w*|__mmap\w*|munmap\w*|__munmap\w*|mprotect\w*|__mprotect\w*|madvise\w*|__madvise\w*|syscall|__GI_\w+|intern_lay_out|intern_initialize\w*|intern_grow)$')

def frames(lines):
    out = []
    for l in lines:
        m = re.search(r'\(([^+)]+)\+0x[0-9a-f]+\)', l)
        out.append(m.group(1) if m else l.strip())
    return out

def caller(stack):
    for f in stack:
        if not LAYER.match(f):
            return f
    return stack[-1] if stack else "?"

calls = []
current = None
for line in open(sys.argv[1]):
    if line.startswith(" > "):
        if current is not None:
            current["stack"].append(line[3:].strip())
        continue
    m = re.match(r'^(?:\d+\s+)?(mmap|munmap|mprotect|madvise|brk)\((.*)\)\s+=\s+(\S+)', line)
    if m:
        current = {"call": m.group(1), "args": [a.strip() for a in m.group(2).split(",")], "result": m.group(3), "stack": []}
        calls.append(current)
    else:
        current = None

mappings = []
heap_start = None
heap_end = 0
count = collections.Counter()
by_caller = collections.Counter()
for c in calls:
    c["frames"] = frames(c["stack"])
    who = caller(c["frames"])
    c["who"] = who
    count[c["call"]] += 1
    by_caller[(c["call"], who, c["args"][2] if c["call"] in ("mprotect", "madvise") else "")] += 1
    if c["call"] == "mmap" and c["result"].startswith("0x") and "MAP_ANONYMOUS" in c["args"][3] and c["args"][4] == "-1":
        mappings.append((int(c["result"], 16), int(c["args"][1]), "%s [%s %s]" % (who, c["args"][2], c["args"][1])))
    if c["call"] == "brk" and c["result"].startswith("0x"):
        heap_start = heap_start if heap_start is not None else int(c["result"], 16)
        heap_end = max(heap_end, int(c["result"], 16))

if heap_start is not None:
    mappings.insert(0, (heap_start, heap_end - heap_start, "brk heap"))
print("system calls:", " ".join("%s %d" % (k, v) for k, v in sorted(count.items())))
print()
print("calls by caller (call, caller, protection or advice):")
for (call, who, arg), n in sorted(by_caller.items(), key=lambda x: (x[0][0], -x[1])):
    print("  %3d %-8s %-48s %s" % (n, call, who, arg))
print()

sections = []
for l in open(sys.argv[3]):
    p = l.split()
    if len(p) == 3:
        try:
            sections.append((p[0], int(p[1], 16), int(p[2], 16)))
        except ValueError:
            pass

regions = collections.Counter()
by_mapping = collections.Counter()
pages = collections.defaultdict(set)
symbols = collections.defaultdict(collections.Counter)
symbol_pages = collections.defaultdict(lambda: collections.defaultdict(set))
total = 0
for l in open(sys.argv[2]):
    p = l.split()
    if not p:
        continue
    a = int(p[0], 16)
    # perf script -F addr,ip,sym prints the address, its symbol, the instruction's address and its symbol.
    sym = re.sub(r'\+0x[0-9a-f]+$', '', p[-1]) if len(p) > 1 else "?"
    total += 1
    region = None
    name = None
    # The process's own mappings first (with the randomization off, small ones are near the stack), then the
    # executable's sections, then what is neither: the stack and the vDSO.
    for start, size, n in mappings:
        if start <= a < start + size:
            name = n
    if name is not None:
        region = "anonymous (heap)" if name == "brk heap" else "anonymous (arenas)"
    else:
        for n, s, z in sections:
            if z and s <= a < s + z:
                region = n
    if region is None:
        region = "(none)" if a == 0 else "stack/vdso" if a >= 0x7ff000000000 else "other"
        if region == "stack/vdso":
            name = "stack/vdso"
    if name is not None:
        by_mapping[name] += 1
        pages[name].add(a >> 12)
        symbols[name][sym] += 1
        symbol_pages[name][sym].add(a >> 12)
    regions[region] += 1

print("each mprotect and madvise: call, bytes, argument, mapping, callers")
for c in calls:
    if c["call"] in ("mprotect", "madvise"):
        a = int(c["args"][0], 16)
        name = "?"
        for start, size, n in mappings:
            if start <= a < start + size:
                name = n.split(" [")[0] + " " + n.split(" ")[-1].rstrip("]")
        callers = [f for f in c["frames"] if not LAYER.match(f)][:4]
        print("  %-8s %12s %-22s %-40s %s" % (c["call"], c["args"][1], c["args"][2], name, " < ".join(callers)))
print()
print("brk and the heap's callers:")
for c in calls:
    if c["call"] == "brk":
        print("  brk(%s) = %s: %s" % (c["args"][0], c["result"], " < ".join(c["frames"][:8])))
print()
print("faults: %d" % total)
for r, c in sorted(regions.items(), key=lambda x: -x[1]):
    print("  %4d %s" % (c, r))
print()
print("faults by mapping (the mapping's caller, protection and bytes): faults, pages, the functions faulting (faults/pages)")
for n, c in sorted(by_mapping.items(), key=lambda x: -x[1]):
    top = ", ".join("%s %d/%d" % (s, k, len(symbol_pages[n][s])) for s, k in symbols[n].most_common(10))
    print("  %4d %4d %-70s %s" % (c, len(pages[n]), n, top))
