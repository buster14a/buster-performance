import sys, collections
def bucket(c):
    if c <= 2: return "once"
    if c <= 20: return "block"
    if c <= 60: return "21-60"
    if c <= 150: return "lane"
    return "more"
tabs = {}
for b in ("tier1", "clang2"):
    tab = collections.defaultdict(collections.Counter)
    for line in open(f"mid200-{b}.dump"):
        c = int(line[:10]); k = line[49:77].strip()
        tab[bucket(c)][k] += c
    tabs[b] = tab
classes = sorted(set(k for b in tabs for bk in tabs[b] for k in tabs[b][bk]), key=lambda k: -(tabs["tier1"]["lane"][k] + tabs["tier1"]["block"][k]))
print(f"{'class':30s} {'T1 lane':>8s} {'cl lane':>8s} {'T1 block':>9s} {'cl block':>9s} {'T1 all':>8s} {'cl all':>8s} {'excess':>8s}")
tot = collections.Counter()
for k in classes:
    t1l, cll = tabs["tier1"]["lane"][k], tabs["clang2"]["lane"][k]
    t1b, clb = tabs["tier1"]["block"][k], tabs["clang2"]["block"][k]
    t1a = sum(tabs["tier1"][bk][k] for bk in tabs["tier1"]); cla = sum(tabs["clang2"][bk][k] for bk in tabs["clang2"])
    print(f"{k:30s} {t1l:8d} {cll:8d} {t1b:9d} {clb:9d} {t1a:8d} {cla:8d} {t1a-cla:8d}")
    tot["t1l"] += t1l; tot["cll"] += cll; tot["t1b"] += t1b; tot["clb"] += clb; tot["t1a"] += t1a; tot["cla"] += cla
print(f"{'total':30s} {tot['t1l']:8d} {tot['cll']:8d} {tot['t1b']:9d} {tot['clb']:9d} {tot['t1a']:8d} {tot['cla']:8d} {tot['t1a']-tot['cla']:8d}")
