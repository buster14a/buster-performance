#!/usr/bin/env python3
# Keeps only the lines of a 9700X log that this record's own tools print (ab's rounds, time-runs' processes and
# summaries, build.sh's lines, the objects' comparisons, the scripts' last words), so that exclusive.sh's waiting
# messages, whatever their holders' commands span, leave nothing behind.
import re, sys
own = re.compile(r"^(== round |run \d+ list \d+ |list \d+[ ,]|  (main|head|main-again): |time-runs: |build\.sh[: ]|object[ :]|done$|measured$)")
for line in open(sys.argv[1], errors="replace"):
    if own.match(line):
        sys.stdout.write(line)
