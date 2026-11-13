# layout_analyze.py RUNS: layout2602.sh's layout-runs.txt (lines "st ROUND PAD BUILD speedtest1 metric=value...", the
# warm-up round left out) into each placement's medians by build, the head's ratio, the per-round paired ratios' median
# and range, and the placements' mean ratio, for time, user cycles, user instructions and store-to-load forwards.
import statistics
import sys

runs = {}
for line in open(sys.argv[1]):
    words = line.split()
    if len(words) < 5 or words[0] != "st":
        continue
    values = {k: float(v) for k, v in (w.split("=", 1) for w in words[5:] if "=" in w) if v not in ("<not counted>", "<not supported>")}
    runs.setdefault(int(words[2]), {}).setdefault(words[3], {})[int(words[1])] = values
METRICS = [("task-clock", "time, ms", 1.0), ("cycles", "user cycles, M", 1e-6), ("instructions", "user instructions, M", 1e-6), ("ls_stlf", "store-to-load forwards, M", 1e-6)]
for metric, label, scale in METRICS:
    print(f"\n### {label}\n")
    print("| Pad, bytes | base | head | head / base | paired rounds' ratio, median (range) |\n| ---: | ---: | ---: | ---: | ---: |")
    ratios = []
    for pad in sorted(runs):
        base = runs[pad]["base"]
        head = runs[pad]["head"]
        b = statistics.median(base[r][metric] for r in base)
        h = statistics.median(head[r][metric] for r in head)
        pairs = [head[r][metric] / base[r][metric] for r in base if r in head]
        ratios.append(h / b)
        print(f"| {pad} | {b * scale:.2f} | {h * scale:.2f} | {h / b:.4f} | {statistics.median(pairs):.4f} ({min(pairs):.4f} to {max(pairs):.4f}) |")
    print(f"\nMean ratio over the placements {statistics.mean(ratios):.4f} (from {min(ratios):.4f} to {max(ratios):.4f})")
