#!/usr/bin/env python3
# Keeps only the lines this record's own tools print (ab's rounds, time-runs' summaries, the lowering benchmark's lines,
# the scripts' status lines), so that exclusive.sh's waiting messages, whatever their holders' commands span, leave
# nothing behind. Usage: keep_own_lines.py LOG > FILTERED.
import re, sys
trees = r"(qf2|lb3|cq3)"
own = re.compile(r"^(== round \d+ tree \./" + trees + r" |run \d+ list \d+: |list \d+ \[|time-runs: |ab: |lowering-source: |"
                 + trees + r" (-c: |\d+: )|objects: |driver: |lowering: |done$|build\.sh: \d+ sources)")
for line in open(sys.argv[1], errors="replace"):
    if own.match(line):
        sys.stdout.write(line)
