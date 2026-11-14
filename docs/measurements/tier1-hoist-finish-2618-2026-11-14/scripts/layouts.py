# layouts.py RUNS: run2593.sh's lay/runs.txt (speedtest1 at six layouts, "st ROUND LAYOUT BUILD speedtest1 metric=value...")
# into a table per metric: each layout's medians over the rounds, by build, their ratio and the range of the rounds'
# paired ratios; then the mean of the layouts' log ratios and its 95% interval over the layouts (t, layouts - 1 degrees).
import math
import statistics
import sys

T975 = {1: 12.706, 2: 4.303, 3: 3.182, 4: 2.776, 5: 2.571, 6: 2.447, 7: 2.365}
PADS = [0, 16, 32, 48, 1072, 3088]
METRICS = [("task-clock", "time, ms", 1.0), ("cycles", "user cycles, M", 1e-6), ("instructions", "user instructions, M", 1e-6)]
runs = {}
for line in open(sys.argv[1]):
    words = line.split()
    if len(words) < 5 or words[0] != "st":
        continue
    values = dict(w.split("=", 1) for w in words[5:] if "=" in w)
    runs[(int(words[1]), int(words[2]), words[3])] = {k: float(v) for k, v in values.items()}
rounds = sorted({r for r, _, _ in runs})
layouts = sorted({o for _, o, _ in runs})
print(f"speedtest1 at {len(layouts)} layouts, {len(rounds)} rounds")
for metric, name, scale in METRICS:
    print(f"\n### {name}\n")
    print("| Pad, bytes | base | head | head / base | paired rounds' range |")
    print("| ---: | ---: | ---: | ---: | ---: |")
    logs = []
    for o in layouts:
        base = [runs[(r, o, "base")][metric] for r in rounds]
        head = [runs[(r, o, "head")][metric] for r in rounds]
        paired = [h / b for h, b in zip(head, base)]
        ratio = statistics.median(head) / statistics.median(base)
        logs.append(math.log(ratio))
        print(f"| {PADS[o]} | {statistics.median(base) * scale:.2f} | {statistics.median(head) * scale:.2f} | {ratio:.4f} | {min(paired):.4f} to {max(paired):.4f} |")
    mean = statistics.mean(logs)
    half = T975[len(logs) - 1] * statistics.stdev(logs) / math.sqrt(len(logs))
    print(f"\nMean ratio over the layouts {math.exp(mean):.4f} (95% interval {math.exp(mean - half):.4f} to {math.exp(mean + half):.4f})")
