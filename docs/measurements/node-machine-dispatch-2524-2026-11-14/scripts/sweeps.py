#!/usr/bin/env python3
# sweeps.py RESULTS ROUND LABEL...: each label's medians over its time-*-ROUNDn.txt runs (ROUND: f for the exploration's
# rounds, g for the final A/B's), per input: T, C (T and C less T), X (all three less T and C) and the three, in cycles and
# instructions a taken evaluated node, and the number of runs; C and X are differences of the sets' medians.
import sys, re, statistics, os, glob
results, round_letter = sys.argv[1], sys.argv[2]
files = ['time-sqlite3', 'time-lua', 'time-sqlite3-repeat2', 'time-lua-repeat2']
pattern = re.compile(r'time sweeps=(\S+) passes=\d+ repeat=\d+ .* per-evaluated-node: cycles=([0-9.]+) instructions=([0-9.]+)')
for f in files:
    for label in sys.argv[3:]:
        sets = {'T': ([], []), 'T+C': ([], []), 'T+C+X': ([], [])}
        for path in sorted(glob.glob(os.path.join(results, label, '%s-%s*.txt' % (f, round_letter)))):
            if not re.search(r'-%s\d+\.txt$' % round_letter, path):
                continue
            for line in open(path):
                m = pattern.search(line)
                if m:
                    sets[m.group(1)][0].append(float(m.group(2)))
                    sets[m.group(1)][1].append(float(m.group(3)))
        if not sets['T'][0]:
            continue
        med = {k: (statistics.median(v[0]), statistics.median(v[1])) for k, v in sets.items()}
        t, tc, tcx = med['T'], med['T+C'], med['T+C+X']
        print('%-21s %-6s T %6.1f %6.1f | C %5.1f %6.1f | X %5.1f %6.1f | three %6.1f %6.1f (%.1f-%.1f) n=%d' % (
            f, label, t[0], t[1], tc[0] - t[0], tc[1] - t[1], tcx[0] - tc[0], tcx[1] - tc[1], tcx[0], tcx[1],
            min(sets['T+C+X'][0]), max(sets['T+C+X'][0]), len(sets['T+C+X'][0])))
