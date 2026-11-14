# Medians and per-round differences against main of ab.sh's and ab2.sh's perf stat lines: summarize.py AB.txt
# Each line is "<tree> <instructions>,,instructions:u,... <cycles>,,cycles:u,... <msec>,msec,task-clock,...", the mean
# of perf stat -r 5; rounds start with "round N".
import statistics
import sys

rounds = []
for line in open(sys.argv[1]):
    words = line.split()
    if line.startswith("round "):
        rounds.append({})
    elif rounds and len(words) == 4 and ",,instructions:u," in words[1]:
        rounds[-1][words[0]] = (int(words[1].split(",")[0]), int(words[2].split(",")[0]), float(words[3].split(",")[0]))
trees = [t for t in ("base", "head", "head2") if all(t in r for r in rounds)]
print(f"{len(rounds)} rounds")
print("| | instructions | cycles | task-clock |")
print("| --- | ---: | ---: | ---: |")
for t in trees:
    m = [statistics.median(r[t][k] for r in rounds) for k in range(3)]
    print(f"| {t}, median | {m[0] / 1e6:,.2f} M | {m[1] / 1e6:,.2f} M | {m[2]:.2f} ms |")
for t in trees[1:]:
    d = [[r[t][k] - r["base"][k] for r in rounds] for k in range(3)]
    b = [statistics.median(r["base"][k] for r in rounds) for k in range(3)]
    md = [statistics.median(x) for x in d]
    print(f"| {t} − base, median of rounds | {md[0] / 1e6:+.2f} M ({100 * md[0] / b[0]:+.3f}%) | {md[1] / 1e6:+.2f} M ({100 * md[1] / b[1]:+.2f}%) | {md[2]:+.2f} ms ({100 * md[2] / b[2]:+.2f}%) |")
    print(f"| {t} − base, each round's cycles | {', '.join(f'{x / 1e6:+.1f}' for x in d[1])} M | | |")
