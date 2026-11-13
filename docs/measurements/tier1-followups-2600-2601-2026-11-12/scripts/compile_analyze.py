# compile_analyze.py RUNS: compile2573.sh's compile-runs.txt into medians by build and the paired rounds' ratios.
import statistics as st
import sys
runs = {}
for line in open(sys.argv[1]):
    w = line.split()
    if len(w) < 4 or w[0] != "run":
        continue
    values = {k: float(x) for k, x in (p.split("=", 1) for p in w[4:])}
    runs.setdefault(w[3], {}).setdefault(w[2], {})[int(w[1])] = values
for what in ("sqlite", "lua"):
    print(f"\n### {what}: {len(runs[what]['base'])} rounds of each build\n")
    print("| Metric | base | head | head / base | paired rounds' ratio, median (range) |\n| --- | ---: | ---: | ---: | ---: |")
    for metric, scale, unit in (("task-clock", 1, "ms"), ("cycles", 1e-6, "M"), ("instructions", 1e-6, "M")):
        base = runs[what]["base"]
        head = runs[what]["head"]
        b = [base[r][metric] for r in base]
        h = [head[r][metric] for r in head]
        pairs = [head[r][metric] / base[r][metric] for r in base if r in head]
        print(f"| {metric}, {unit} | {st.median(b) * scale:.2f} | {st.median(h) * scale:.2f} | {st.median(h) / st.median(b):.4f} | {st.median(pairs):.4f} ({min(pairs):.4f} to {max(pairs):.4f}) |")
