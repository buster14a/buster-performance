"""Compare adjacent, equally repeated real checker digit passes and whole-process fixed runs."""
import re
import sys
from collections import defaultdict
from pathlib import Path
from statistics import median

directory = Path(sys.argv[1])
runs = defaultdict(dict)
groups = defaultdict(list)
for line in (directory / "status").read_text().splitlines():
    r, corpus, position, mode = line.split()
    prefix = directory / f"{r}-{corpus}-{position}-{mode}"
    counters = {}
    for row in prefix.with_suffix(".perf").read_text().splitlines():
        fields = row.split(";")
        if len(fields) > 2 and fields[0].isdigit():
            counters[fields[2]] = int(fields[0])
    counters["cycles:u+k"] = counters["cycles:u"] + counters["cycles:k"]
    runs[corpus, int(r)][mode] = counters
    if mode != "paired":
        continue
    ticks = defaultdict(int)
    counts = defaultdict(int)
    samples = defaultdict(int)
    for row in prefix.with_suffix(".err").open():
        match = re.match(r"decimal-replay: pass=(\d+) new=([01]) count=(\d+) ticks=(\d+)", row)
        if match:
            step, arm, count, clock = map(int, match.groups())
            assert 2 <= step < 18 and count > 0
            ticks[arm] += clock
            counts[arm] += count
            samples[arm] += 1
    assert counts[0] == counts[1] and samples[0] == samples[1] and counts[0] % 8 == 0
    groups[corpus].append((ticks[0] / counts[0], ticks[1] / counts[1], counts[0] // 8, samples[0] // 8))
for corpus, rounds in groups.items():
    old, new, literal_counts, chunk_counts = list(zip(*rounds))
    assert len(set(literal_counts)) == len(set(chunk_counts)) == 1
    delta = [100 * (b / a - 1) for a, b in zip(old, new)]
    print(f"{corpus} paired {len(rounds)} rounds, {literal_counts[0]} grammar literal rows, {chunk_counts[0]} active chunks; "
          f"{median(old):.3f} -> {median(new):.3f} TSC ticks/literal; {median(delta):+.3f}% [{min(delta):+.3f},{max(delta):+.3f}]")
    pairs = [m for (name, _), m in runs.items() if name == corpus and "old" in m and "new" in m]
    for event in ("cycles:u+k", "instructions:u", "minor-faults"):
        change = [(m["new"][event] - m["old"][event]) / 18 for m in pairs]
        percents = [100 * (m["new"][event] / m["old"][event] - 1) for m in pairs]
        print(f"  {event}, {len(pairs)} fresh 18-fold processes, median difference/repetition {median(change):+,.1f} "
              f"[{min(change):+,.1f},{max(change):+,.1f}]; whole 18-fold process {median(percents):+.3f}% "
              f"[{min(percents):+.3f},{max(percents):+.3f}]")
