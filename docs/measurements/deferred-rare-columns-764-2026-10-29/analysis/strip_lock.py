#!/usr/bin/env python3
# Drops exclusive.sh's waiting messages from a log: the "exclusive.sh: waiting ..." line, which names the lock's holder
# and its command, and the "  title:", "  link:" and "  pull request:" lines after it. Usage: strip_lock.py IN OUT.
import re
import sys

lines = open(sys.argv[1], encoding="utf-8", errors="replace").read().splitlines(keepends=True)
out = []
dropping = False
for line in lines:
    if line.startswith("exclusive.sh: "):
        dropping = True
        continue
    if dropping and re.match(r"  (title|link|pull request): ", line):
        continue
    dropping = False
    out.append(line)
open(sys.argv[2], "w", encoding="utf-8").writelines(out)
