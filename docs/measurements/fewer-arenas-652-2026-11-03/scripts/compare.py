# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# Per reservation (call site and its n-th occurrence): mapping length and resident KB in each trace.
import re, sys, collections
def load(path):
    maps = []; smaps = []; section = None; current = None
    for line in open(path):
        if line.startswith("MMAP "):
            p = line.rstrip("\n").split(" ", 4)
            frames = p[4].split(" <- ") if len(p) > 4 else ["?"]
            site = next((f for f in frames if not re.match(r"^(arena_[a-z_]+|pp_array[a-z_]*|lane_[a-z_]+|mmap[a-z0-9_]*)@", f)), frames[0])
            maps.append((int(p[1], 16), int(p[2][4:]), site))
        elif line.startswith("SMAPS"):
            section = "s"
        elif section == "s":
            m = re.match(r"^([0-9a-f]+)-([0-9a-f]+) ", line)
            if m:
                current = [int(m.group(1), 16), int(m.group(2), 16), 0]; smaps.append(current)
            elif line.startswith("Rss:") and current:
                current[2] = int(line.split()[1])
    out = collections.OrderedDict(); seen = collections.Counter()
    for a, l, s in maps:
        if a >= 1 << 63: continue
        seen[s] += 1
        rss = sum(r for b, e, r in smaps if b >= a and e <= a + l)
        out[(s, seen[s])] = (l, rss)
    return out
runs = [(p, load(p)) for p in sys.argv[1:]]
keys = list(runs[0][1].keys())
for p, r in runs[1:]:
    for k in r:
        if k not in keys: keys.append(k)
print("%-62s %10s " % ("site#n", "len MB") + " ".join("%10s" % p.split("-nothp")[0][:10] for p, r in runs))
for k in keys:
    l = next((r[k][0] for p, r in runs if k in r), 0)
    print("%-62s %10.1f " % ("%s#%d" % (k[0][:58], k[1]), l / 2**20) + " ".join("%10s" % (r[k][1] if k in r else "-") for p, r in runs))
