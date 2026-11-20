#!/usr/bin/env python3
# counters.py RESULTS: the two counter builds' lines (xv4p, xv7p: an experiment's patch that reads the PMU around the
# values' sweep, and around the rows' write in the second, with perf_event_open, user mode alone, a read of each
# counter before and after the region, summed for a chunk's first run and its second): a line a run and a region, the
# counters a chunk. The second build's lines are written to stderr inside the report's stdout, so they are found by
# their fields, not their lines.
import re, sys
results = sys.argv[1]
for label in ('xv4p', 'xv7p'):
    for corpus in ('sqlite3', 'lua'):
        for n in (1, 2):
            t = open('%s/%s/pmu-%s-%d.txt' % (results, label, corpus, n), errors='replace').read()
            for m in re.finditer(r"values-pmu ([a-z' ,]*?)(first|second) run, a chunk \(of (\d+)\): (cycles=[\d.]+ instructions=[\d.]+[^\n]*)", t):
                region = m.group(1).strip(' ,') or 'values'
                print('%s %s %d %-16s %-6s chunks=%s %s' % (label, corpus, n, region.replace(' ', '-'), m.group(2), m.group(3), m.group(4).strip()))
