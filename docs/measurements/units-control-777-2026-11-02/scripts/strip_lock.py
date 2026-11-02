#!/usr/bin/env python3
# Copies a log without exclusive.sh's waiting messages, which name other sessions' jobs: a waiting line, its title,
# link and pull request lines, and any lines of the holder's command up to the next line of a shape this record's
# scripts and tools print.
import re, sys
OWN = re.compile(r'^(memory: wait4|/home/david/buster-fast-bench/777-claude/|test-|check |checker-driver|check-|time-|trace777|list \d|run \d|warm-up|== |-- |   \d|lists|cpu\d|Linux benchpress|clang version|perf version|cc \(GCC\)|mold |build\.sh:|tree |[0-9a-f]{64}  |main |head |shared parts|  shared parts|  reservations|one |two |sqlite|shell|status |runs with|r\d/|objects compared|linked by|42$|463170394|probe status|multicore:|allowed cycle|call graph:|worker budget|  backend|  squeezes|  driver|\d+ lanes?:|watchdog|arenas:|teams:|cpuinfo:|cores:|shared CPUs|sessions|  sessions|part ranges|.*-finished$|c\d+/|one command|alone|link2|time-runs|\d+[.,]\d+,|[a-z0-9-]+/[a-z0-9.-]+: |tree-|fresh|stage|probe-|-c |   4-5|       5 linked|       6-7|\s*\d+,)')
def strip(lines):
    out = []
    skipping = False
    for line in lines:
        if line.startswith('exclusive.sh: waiting'):
            skipping = True
            continue
        if skipping and re.match(r'^  (title|link|pull request):', line):
            continue
        if skipping and not OWN.match(line):
            continue
        skipping = False
        out.append(line)
    return out
src, dst = sys.argv[1], sys.argv[2]
with open(src, errors='replace') as f:
    lines = f.readlines()
kept = strip(lines)
with open(dst, 'w') as f:
    f.writelines(kept)
print(f'{src}: {len(lines) - len(kept)} lines dropped', file=sys.stderr)
