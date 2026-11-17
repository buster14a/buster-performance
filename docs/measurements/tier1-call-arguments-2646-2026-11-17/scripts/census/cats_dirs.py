#!/usr/bin/env python3
import sys, os, collections
sys.path.insert(0, os.path.dirname(__file__))
from cats import census
root = sys.argv[1]; top = int(sys.argv[2]) if len(sys.argv) > 2 else 20
mine = sys.argv[3] if len(sys.argv) > 3 else "object.o"
ta = collections.Counter(); tb = collections.Counter(); na = collections.Counter(); nb = collections.Counter()
rows = []
for d in sorted(os.listdir(root)):
    p = os.path.join(root, d)
    a_path = os.path.join(p, mine); b_path = os.path.join(p, "object-clang.o")
    if not (os.path.exists(a_path) and os.path.exists(b_path)): continue
    a = census(a_path); b = census(b_path)
    for n in a:
        if n in b:
            ta.update(a[n][0]); tb.update(b[n][0]); na.update(a[n][1]); nb.update(b[n][1])
            rows.append((a[n][2] - b[n][2], a[n][2], b[n][2], d + ":" + n))
print("%-12s %10s %10s %10s %8s %8s" % ("category", "tier1", "clang", "diff", "n1", "nc"))
for k in sorted(set(ta) | set(tb), key=lambda k: -(ta[k]-tb[k])):
    print("%-12s %10d %10d %+10d %8d %8d" % (k, ta[k], tb[k], ta[k]-tb[k], na[k], nb[k]))
print("%-12s %10d %10d %+10d" % ("total", sum(ta.values()), sum(tb.values()), sum(ta.values())-sum(tb.values())))
rows.sort(reverse=True)
for r in rows[:top]: print("%+7d %7d %7d %s" % r)
print("...")
for r in rows[-10:]: print("%+7d %7d %7d %s" % r)
