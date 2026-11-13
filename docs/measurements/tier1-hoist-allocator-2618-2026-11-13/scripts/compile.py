# compile.py RUNS: run2593.sh's compile-runs.txt ("run ROUND BUILD WHAT metric=value...", warm-ups left out) into each
# input's medians by build, their ratio, and the paired rounds' ratios' median and range.
import statistics
import sys

METRICS = [("task-clock", "time, ms", 1.0), ("cycles", "cycles, M", 1e-6), ("instructions", "instructions, M", 1e-6)]
runs = {}
for line in open(sys.argv[1]):
    words = line.split()
    if len(words) < 4 or words[0] != "run":
        continue
    values = dict(w.split("=", 1) for w in words[4:] if "=" in w)
    runs[(words[3], int(words[1]), words[2])] = {k: float(v) for k, v in values.items()}
print("| Input | Metric | base | head | head / base | paired ratios, median (range) |")
print("| --- | --- | ---: | ---: | ---: | ---: |")
for what in ("sqlite", "lua"):
    rounds = sorted({r for w, r, _ in runs if w == what})
    for metric, name, scale in METRICS:
        base = [runs[(what, r, "base")][metric] for r in rounds]
        head = [runs[(what, r, "head")][metric] for r in rounds]
        paired = [h / b for h, b in zip(head, base)]
        mb, mh = statistics.median(base), statistics.median(head)
        print(f"| {'sqlite3.c' if what == 'sqlite' else 'Lua'} | {name} | {mb * scale:,.2f} | {mh * scale:,.2f} | {mh / mb:.4f} | {statistics.median(paired):.4f} ({min(paired):.4f} to {max(paired):.4f}) |")
