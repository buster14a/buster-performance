# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# Attributes each mmap'd range's resident pages (smaps at exit) to its call site; counts page-table pages.
import re, sys, collections
maps = []
smaps = []
section = None
for line in open(sys.argv[1]):
    if line.startswith("MMAP "):
        parts = line.rstrip("\n").split(" ", 4)
        addr = int(parts[1], 16)
        length = int(parts[2][4:])
        prot = int(parts[3][5:])
        stack = parts[4] if len(parts) > 4 else ""
        maps.append((addr, length, prot, stack))
    elif line.startswith("STATUS "):
        print(line.strip())
    elif line.startswith("SMAPS"):
        section = "smaps"
        current = None
    elif section == "smaps":
        m = re.match(r"^([0-9a-f]+)-([0-9a-f]+) (\S+)", line)
        if m:
            current = [int(m.group(1), 16), int(m.group(2), 16), m.group(3), 0]
            smaps.append(current)
        elif line.startswith("Rss:") and current is not None:
            current[3] = int(line.split()[1])
def site(stack):
    frames = stack.split(" <- ")
    keep = [f for f in frames if not re.match(r"^(arena_[a-z_]+|pp_array[a-z_]*|lane_[a-z_]+|mmap[a-z0-9_]*)@", f)]
    return keep[0] if keep else frames[0] if frames else "?"
rows = []
for addr, length, prot, stack in maps:
    if addr >= (1 << 63):
        continue
    rss = 0
    vmas = 0
    for b, e, perm, r in smaps:
        if b >= addr and e <= addr + length:
            rss += r
            vmas += 1
    rows.append((addr, length, prot, rss, vmas, site(stack), stack))
by = collections.OrderedDict()
for addr, length, prot, rss, vmas, s, stack in rows:
    k = s
    v = by.setdefault(k, [0, 0, 0, 0])
    v[0] += 1
    v[1] += 1 if rss > 0 else 0
    v[2] += rss
    v[3] += vmas
print("%d mmaps, %d touched, %d KB resident in them" % (len(rows), sum(1 for r in rows if r[3] > 0), sum(r[3] for r in rows)))
print("%5s %7s %8s %5s  %s" % ("maps", "touched", "rss KB", "vmas", "site"))
for k, v in sorted(by.items(), key=lambda kv: -kv[1][0]):
    print("%5d %7d %8d %5d  %s" % (v[0], v[1], v[2], v[3], k))
# Page-table pages for the touched ranges: distinct 2 MB and 1 GB blocks with resident pages.
blocks2m = set(); blocks1g = set(); blocks512g = set()
for b, e, perm, r in smaps:
    if r > 0:
        a = b
        while a < e:
            blocks2m.add(a >> 21); blocks1g.add(a >> 30); blocks512g.add(a >> 39)
            a = ((a >> 21) + 1) << 21
print("whole process: VMAs %d, touched 2MB blocks %d (PTE pages), 1GB %d (PMD pages), 512GB %d (PUD pages)" % (len(smaps), len(blocks2m), len(blocks1g), len(blocks512g)))
