#!/usr/bin/env python3
# Keeps only the lines this record's own tools print (ab's rounds, time-runs' runs and summaries, the lowering benchmark's
# lines, the scripts' status lines), so that exclusive.sh's waiting messages, whatever their holders' commands span,
# leave nothing behind.
import re, sys
own = re.compile(r"^(== round \d+ tree \./(main|head|pr2|pr3) |run \d+ list \d+: |list \d+ \[|time-runs: |ab: |lowering-source: |"
                 r"(main|head|pr2|pr3): status |objects: |driver: |lowering: |done$|build\.sh: \d+ sources)")
for line in open(sys.argv[1], errors="replace"):
    if own.match(line):
        sys.stdout.write(line)
