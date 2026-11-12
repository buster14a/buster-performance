#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# skip_table.py DIR [FIRST SECOND]: skip.sh's rounds (DIR/stat-WORKLOAD-read-N.csv and -skipped-N.csv; or, with two
# names, another pair of variants: DIR/stat-[WORKLOAD-]FIRST-N.csv and -SECOND-N.csv) by the host's state. A round's
# page faults are one of two counts for a variant, whichever variant it is (huge pages granted to the process's arenas
# at their faults, or not: transparent huge pages are `always` with `defrag` at `madvise`), and the kernel's cycles
# and a part of the user's follow them, so a median over rounds of both states compares two mixtures. For each
# workload this splits each variant's rounds at the middle of its page faults' range (one state when the range is
# under 2% of the count), and prints each state's medians and, for each state both variants have, read over skipped
# (where no state has both, for each variant's state of most rounds);
# and the variants' user cycles over all rounds, which the state moves by about 1%. Where a round has the host's
# counters before and after it (DIR/vmstat-WORKLOAD-VARIANT-N.txt, skip2.sh), a state's row ends with the medians of the
# huge pages given at a fault and refused during its rounds.
import os, re, sys, statistics, collections

directory = sys.argv[1]
FIRST, SECOND = (sys.argv[2], sys.argv[3]) if len(sys.argv) > 3 else ('read', 'skipped')
runs = collections.defaultdict(lambda: collections.defaultdict(list))
for name in sorted(os.listdir(directory)):
    m = re.fullmatch(r'stat-(?:(.+)-)?(' + re.escape(FIRST) + '|' + re.escape(SECOND) + r')-(\d+)\.csv', name)
    if not m:
        continue
    row = {}
    for line in open(os.path.join(directory, name)):
        p = line.strip().split(',')
        if len(p) > 2 and p[0] and not line.startswith('#'):
            try:
                row[p[2]] = float(p[0])
            except ValueError:
                pass
    vmstat = os.path.join(directory, f'vmstat-{m.group(1)}-{m.group(2)}-{m.group(3)}.txt')
    if os.path.exists(vmstat):
        lines = [dict(zip(l.split()[0::2], map(int, l.split()[1::2]))) for l in open(vmstat) if l.strip()]
        if len(lines) == 2:
            for key in lines[0]:
                row['vm:' + key] = lines[1][key] - lines[0][key]
    runs[m.group(1) or ''][m.group(2)].append(row)


def median(rows, key):
    return statistics.median(r[key] for r in rows)


def states(rows):
    faults = [r['page-faults'] for r in rows]
    low, high = min(faults), max(faults)
    if high - low < 0.02 * low:
        return {'one': rows}
    middle = (low + high) / 2
    return {'fewer faults': [r for r in rows if r['page-faults'] < middle], 'more faults': [r for r in rows if r['page-faults'] >= middle]}


print(f'workload\tstate\tvariant\trounds\tuser cycles, M\tkernel cycles, M\tboth, M\tCPU ms\tpage faults\t{FIRST} over {SECOND}: cycles\tCPU ms\thuge pages given at a fault\trefused')
for workload, variants in runs.items():
    by = {v: states(rows) for v, rows in variants.items()}
    names = []
    for v in (FIRST, SECOND):
        for s in by.get(v, {}):
            if s not in names:
                names.append(s)
    for s in names:
        figures = {}
        for v in (FIRST, SECOND):
            rows = by.get(v, {}).get(s)
            if rows:
                u, k, ms, f = median(rows, 'cycles:u'), median(rows, 'cycles:k'), median(rows, 'task-clock'), median(rows, 'page-faults')
                huge = ''
                if all('vm:thp_fault_alloc' in r for r in rows):
                    huge = f"{median(rows, 'vm:thp_fault_alloc'):.0f}\t{median(rows, 'vm:thp_fault_fallback'):.0f}"
                figures[v] = (len(rows), u, k, ms, f, huge)
        for v, (n, u, k, ms, f, huge) in figures.items():
            ratio = '\t'
            if v == SECOND and FIRST in figures:
                r = figures[FIRST]
                ratio = f'{(r[1] + r[2]) / (u + k):.3f}\t{r[3] / ms:.3f}'
            print(f'{workload}\t{s}\t{v}\t{n}\t{u / 1e6:.1f}\t{k / 1e6:.1f}\t{(u + k) / 1e6:.1f}\t{ms:.2f}\t{f:.0f}\t{ratio}\t{huge}')
    if FIRST in variants and SECOND in variants and not any(s in by[FIRST] and s in by[SECOND] for s in names):
        # No state has both variants (one of them was in one state throughout): each variant's state of most rounds.
        r = max(by[FIRST].values(), key=len)
        k = max(by[SECOND].values(), key=len)
        rc, kc = median(r, 'cycles:u') + median(r, 'cycles:k'), median(k, 'cycles:u') + median(k, 'cycles:k')
        print(f"{workload}\teach variant's state of most rounds\t{FIRST} over {SECOND}\t{len(r)}+{len(k)}\t\t\t\t\t\t{rc / kc:.3f}\t{median(r, 'task-clock') / median(k, 'task-clock'):.3f}\t")
    if FIRST in variants and SECOND in variants:
        ur, us = median(variants[FIRST], 'cycles:u'), median(variants[SECOND], 'cycles:u')
        ir, is_ = median(variants[FIRST], 'instructions:u'), median(variants[SECOND], 'instructions:u')
        print(f'{workload}\tall rounds\tuser alone\t{len(variants[FIRST])}+{len(variants[SECOND])}\t{ur / 1e6:.1f} {FIRST}, {us / 1e6:.1f} {SECOND} ({ur / us:.3f})\t\t\t\t\tinstructions {ir / 1e6:.1f} {FIRST}, {is_ / 1e6:.1f} {SECOND} ({ir / is_:.3f})\t')
