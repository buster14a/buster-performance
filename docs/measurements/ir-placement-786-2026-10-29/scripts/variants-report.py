import re, statistics as st, collections, sys
from pathlib import Path
root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[1] / "local/variants"
variants = ["v0", "v3", "v4", "v2", "v1"]
names = {"v0": "base", "v3": "pins", "v4": "pins+table", "v2": "pins+table+view", "v1": "restructure"}
# Select common work within each path before taking whole-process counter medians.
expected_reps = {"vector": (8192, 1), "scalar": (8192, 1), "uses": (4096, 1), "cfg": (32768, 4)}
excluded = []
ins = collections.defaultdict(list); cyc = collections.defaultdict(list); reps = collections.defaultdict(set); ns = collections.defaultdict(list)
for v in variants:
    for path in ("vector", "scalar", "uses", "cfg"):
        for r in (1, 2, 3):
            rr = []; sizes = []
            for line in open(f"{root}/{v}-{path}-{r}.log"):
                m = re.match(r'function: (\d+) instructions,', line)
                if m: sizes.append(int(m.group(1)))
                p = line.split()
                if len(p) >= 6 and p[0] == path and re.match(r'^[0-9.]+$', p[1]): rr.append(int(p[5]))
            if sizes != [32, 262144]:
                raise ValueError(f"{v}-{path}-{r}: unexpected function sizes {sizes}")
            if tuple(rr) != expected_reps[path]:
                excluded.append((f"{v}-{path}-{r}", tuple(rr), expected_reps[path]))
                continue
            ev = {}
            for line in open(f"{root}/{v}-{path}-{r}.csv"):
                p = line.strip().split(",")
                if len(p) > 3 and p[0].isdigit(): ev[p[2]] = int(p[0])
            ins[(v, path)].append(ev["instructions:u"]); cyc[(v, path)].append(ev["cycles:u"])
            reps[(v, path)].add(tuple(rr))
        pass
    for r in (1, 2, 3):
        fn = None
        for line in open(f"{root}/{v}-optimize-{r}.log"):
            m = re.match(r'ir-optimize (\S+) input=', line)
            if m: fn = m.group(1)
            m = re.match(r'\s+(scalar|vector) ns/function=([0-9.]+)', line)
            if m and fn: ns[(v, f"{fn} {m.group(1)}")].append(float(m.group(2)))
print("Historical local trial labels only: source/binary/build identities are incomplete; see README.")
print(f"benchmark-ir matched-work subset: {sum(map(len, ins.values()))}/60 counter samples, against reported base")
for sample, actual, expected in excluded:
    print(f"  excluded {sample}: repetitions {actual}, selected {expected}; raw receipts unchanged")
for path in ("vector", "scalar", "uses", "cfg"):
    if any(not ins[(v, path)] for v in variants):
        raise ValueError(f"{path}: every variant must have matched-work counter samples")
    base_i = st.median(ins[("v0", path)]); base_c = st.median(cyc[("v0", path)])
    for v in variants:
        i = st.median(ins[(v, path)]); c = st.median(cyc[(v, path)])
        print(f"  {path:6s} {v} {names[v]:16s} instructions {i:13,.0f} {i/base_i-1:+7.2%}  cycles {c:13,.0f} {c/base_c-1:+7.2%}  samples {len(ins[(v, path)])}  repetitions {sorted(reps[(v, path)])}")
print("benchmark-ir-optimize ns/function, median of three, against base")
for key in sorted(set(k for _, k in ns)):
    b = st.median(ns[("v0", key)])
    print(f"  {key:22s} " + "  ".join(f"{names[v]} {st.median(ns[(v, key)])/b-1:+6.1%}" for v in variants[1:]))
