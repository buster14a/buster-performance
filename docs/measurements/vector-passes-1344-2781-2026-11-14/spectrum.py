import sys, collections
for b in ("tier1", "clang2"):
    rows = []
    for line in open(f"mid200-{b}.dump"):
        c = int(line[:10]); a = int(line[11:19], 16); f = line[20:48].strip(); k = line[49:77].strip(); t = line[78:].rstrip()
        rows.append((c, a, f, k, t))
    total = sum(r[0] for r in rows)
    bycount = collections.Counter(); nstatic = collections.Counter()
    for c, a, f, k, t in rows:
        bycount[c] += c; nstatic[c] += 1
    print(f"== {b}: total {total}, static instructions executed {len(rows)}")
    print("  count  static  dynamic  share")
    for c, d in sorted(bycount.items(), key=lambda x: -x[1])[:22]:
        print(f"  {c:6d} {nstatic[c]:6d} {d:8d} {100*d/total:6.2f}%")
    # buckets
    def bucket(c):
        if c <= 2: return "once (1-2)"
        if c <= 20: return "per 512-byte block (3-20)"
        if c <= 60: return "21-60"
        if c <= 150: return "per 64-byte lane (61-150)"
        if c <= 450: return "151-450"
        return "per token or more (>450)"
    bb = collections.Counter(); bs = collections.Counter()
    for c, a, f, k, t in rows: bb[bucket(c)] += c; bs[bucket(c)] += 1
    for k2, d in bb.most_common(): print(f"  bucket {k2:30s} static {bs[k2]:6d} dynamic {d:8d} {100*d/total:6.2f}%")
