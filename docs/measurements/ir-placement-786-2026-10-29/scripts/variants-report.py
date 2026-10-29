import re, statistics as st, collections, sys
root = "/home/david/.cache/claude-786/o3/out"
variants = ["v0", "v3", "v4", "v2", "v1"]
names = {"v0": "base", "v3": "pins", "v4": "pins+table", "v2": "pins+table+view", "v1": "restructure"}
ins = collections.defaultdict(list); cyc = collections.defaultdict(list); reps = collections.defaultdict(set); ns = collections.defaultdict(list)
for v in variants:
    for path in ("vector", "scalar", "uses", "cfg"):
        for r in (1, 2, 3):
            ev = {}
            for line in open(f"{root}/{v}-{path}-{r}.csv"):
                p = line.strip().split(",")
                if len(p) > 3 and p[0].isdigit(): ev[p[2]] = int(p[0])
            ins[(v, path)].append(ev["instructions:u"]); cyc[(v, path)].append(ev["cycles:u"])
            rr = []
            for line in open(f"{root}/{v}-{path}-{r}.log"):
                p = line.split()
                if len(p) >= 6 and p[0] == path and re.match(r'^[0-9.]+$', p[1]): rr.append(p[5])
            reps[(v, path)].add(tuple(rr))
        pass
    for r in (1, 2, 3):
        fn = None
        for line in open(f"{root}/{v}-optimize-{r}.log"):
            m = re.match(r'ir-optimize (\S+) input=', line)
            if m: fn = m.group(1)
            m = re.match(r'\s+(scalar|vector) ns/function=([0-9.]+)', line)
            if m and fn: ns[(v, f"{fn} {m.group(1)}")].append(float(m.group(2)))
print("benchmark-ir at fixed work: median instructions and cycles, against base")
for path in ("vector", "scalar", "uses", "cfg"):
    base_i = st.median(ins[("v0", path)]); base_c = st.median(cyc[("v0", path)])
    for v in variants:
        i = st.median(ins[(v, path)]); c = st.median(cyc[(v, path)])
        print(f"  {path:6s} {names[v]:16s} instructions {i:13,.0f} {i/base_i-1:+7.2%}  cycles {c:13,.0f} {c/base_c-1:+7.2%}  repetitions {sorted(reps[(v, path)])}")
print("benchmark-ir-optimize ns/function, median of three, against base")
for key in sorted(set(k for _, k in ns)):
    b = st.median(ns[("v0", key)])
    print(f"  {key:22s} " + "  ".join(f"{names[v]} {st.median(ns[(v, key)])/b-1:+6.1%}" for v in variants[1:]))
