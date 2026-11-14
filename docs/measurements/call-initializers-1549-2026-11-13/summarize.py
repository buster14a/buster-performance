#!/usr/bin/env python3
# Each executable's median, minimum and maximum over the rounds, per kernel, in ns per call:
# summarize.py results/rusage-*/kernels.txt (or results/run-*/kernels.txt). With rusage lines, also each executable's
# slow-state runs: those where any kernel took more than 1.5 times that kernel's minimum over all rounds.
import collections
import statistics
import sys

times = collections.defaultdict(list)
per_run = collections.defaultdict(dict)
for line in open(sys.argv[1]):
    fields = line.split()
    if len(fields) >= 4 and fields[2] in ("return", "cleanup", "wrapped"):
        times[(fields[1], fields[2])].append(float(fields[3]))
        per_run[(fields[0], fields[1])][fields[2]] = float(fields[3])
executables = sorted({e for e, _ in times})
for kernel in ("return", "cleanup", "wrapped"):
    for executable in executables:
        x = sorted(times[(executable, kernel)])
        print(f"{executable} {kernel} median {statistics.median(x):.3f} min {x[0]:.3f} max {x[-1]:.3f} n {len(x)}")
for executable in executables:
    slow = [r for (r, e), v in sorted(per_run.items()) if e == executable and any(v[k] > 1.5 * min(times[(e, k)]) for k in v)]
    print(f"{executable} slow-state rounds: {' '.join(slow) if slow else 'none'}")
