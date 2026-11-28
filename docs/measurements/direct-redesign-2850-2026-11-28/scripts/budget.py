#!/usr/bin/env python3
# The budget's figures from results/: the stages' counters (two turns of the harness), the stages' parts by the
# timers' build, and the generator's split by the build that makes no code. Run from the record's directory.
SIZE = 9507037
TOKENS = 673391
STAGES = ("setup", "preprocess", "codegen", "write")


def counter(path, stage, key):
    for line in open(path, errors="replace"):
        if line.startswith("median-counters " + stage):
            fields = line.split()
            return int(fields[fields.index(key) + 1])
    raise SystemExit(path + ": no " + stage)


def stage_ms(path):
    for line in open(path, errors="replace"):
        if line.startswith("median-ms"):
            fields = line.split()
            return float(fields[2]), float(fields[4]), float(fields[6]), float(fields[8])
    raise SystemExit(path + ": no medians")


def timers(path):
    rows = {}
    for line in open(path, errors="replace"):
        fields = line.split()
        if line.startswith("timers front-ticks"):
            rows.setdefault("front", []).append(int(fields[2]))
            rows.setdefault("generator", []).append(int(fields[4]))
        elif line.startswith("timers front "):
            rows.setdefault("front " + fields[2], []).append(int(fields[4]))
        elif line.startswith("timers generator expressions"):
            rows.setdefault("expressions", []).append(int(fields[4]))
        elif line.startswith("timers generator bodies"):
            rows.setdefault("bodies", []).append(int(fields[4]))
    return {name: sorted(values)[len(values) // 2] for name, values in rows.items()}


main = ("results/gen-main-1.out", "results/gen-main-2.out")
total = {(stage, key): sum(counter(path, stage, key) for path in main) / 2 for stage in STAGES
         for key in ("cycles", "instructions", "branch-misses", "l1d-read-misses", "stalled-frontend")}
wall = sum(stage_ms(path)[0] for path in main) / 2
print("a compile: %.3f ms, %.3f GB/s" % (wall, SIZE / (wall * 1e6)))
for key in ("cycles", "instructions", "branch-misses", "l1d-read-misses", "stalled-frontend"):
    print("  %-17s" % key, "  ".join("%s %.3f M" % (stage, total[(stage, key)] / 1e6) for stage in STAGES),
          "  all %.3f M" % (sum(total[(stage, key)] for stage in STAGES) / 1e6))
user = sum(total[(stage, "cycles")] for stage in STAGES)
# perf stat around the process: 41 compiles less 1, over 40.
kernel = (279116250 - 10691535) / 40
print("kernel %.2f M cycles a compile; %.2f GHz; %.1f cycles a token, %.1f with the kernel's" %
      (kernel / 1e6, (user + kernel) / (wall * 1e6), user / TOKENS, (user + kernel) / TOKENS))
for rate in (1, 2, 3):
    cycles = SIZE / (rate * 1e9) * 5.5e9
    print("%d GB/s: %.2f ms, %.1f M cycles, %.1f a token" % (rate, SIZE / (rate * 1e6), cycles / 1e6, cycles / TOKENS))

front = total[("preprocess", "cycles")]
generator = total[("codegen", "cycles")]
first = timers("results/timers.out")
parts = {name: ticks for name, ticks in first.items() if name.startswith("front ")}
whole = sum(parts.values())
print("the front's parts (results/timers.out), of %.2f M cycles:" % (front / 1e6))
for name, ticks in parts.items():
    print("  %-22s %5.1f%%  %6.2f M" % (name[6:], 100 * ticks / whole, front * ticks / whole / 1e6))

t1 = timers("results/gen-timers-1.out")
t2 = timers("results/gen-timers-2.out")
n1 = timers("results/gen-nocode-1.out")
g = (t1["generator"] + t2["generator"]) / 2
e = (t1["expressions"] + t2["expressions"]) / 2
b = (t1["bodies"] + t2["bodies"]) / 2
print("the generator's parts, of %.2f M cycles: expressions %.1f%% %.2f M, the rest of the bodies %.1f%% %.2f M, the file scope %.1f%% %.2f M" %
      (generator / 1e6, 100 * e / g, generator * e / g / 1e6, 100 * (b - e) / g, generator * (b - e) / g / 1e6, 100 * (g - b) / g, generator * (g - b) / g / 1e6))
ratio_all = n1["generator"] / t1["generator"]
ratio_expressions = n1["expressions"] / t1["expressions"]
ratio_rest = (n1["bodies"] - n1["expressions"]) / (t1["bodies"] - t1["expressions"])
ratio_file = (n1["generator"] - n1["bodies"]) / (t1["generator"] - t1["bodies"])
print("with no code made (the first turn's two builds): the generator %.1f%%, expressions %.1f%%, the rest %.1f%%, the file scope %.1f%%" %
      (100 * ratio_all, 100 * ratio_expressions, 100 * ratio_rest, 100 * ratio_file))
print("reading: %.2f M (expressions %.2f M, the rest %.2f M, the file scope %.2f M); making code: %.2f M (expressions %.2f M)" %
      (generator * ratio_all / 1e6, generator * e / g * ratio_expressions / 1e6, generator * (b - e) / g * ratio_rest / 1e6, generator * (g - b) / g * ratio_file / 1e6,
       generator * (1 - ratio_all) / 1e6, generator * e / g * (1 - ratio_expressions) / 1e6))
for key in ("cycles", "instructions", "branch-misses", "stalled-frontend"):
    with_code = counter("results/gen-timers-1.out", "codegen", key)
    without = counter("results/gen-nocode-1.out", "codegen", key)
    print("  the generator's %-17s %11d  %11d  %.1f%%" % (key, with_code, without, 100 * without / with_code))
