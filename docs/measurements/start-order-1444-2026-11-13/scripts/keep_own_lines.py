#!/usr/bin/env python3
# #1444's record: keeps only the line shapes this record's own tools print, dropping the 9700X lock's notices
# (exclusive.sh's "waiting" and "busy" lines and the holder's command, title and link, which name other sessions).
#   keep_own_lines.py KIND FILE   (KIND: time-runs or build); rewrites FILE in place
import re, sys
kind, path = sys.argv[1], sys.argv[2]
patterns = {
    "time-runs": [r"^run \d+ list \d+ ", r"^warm-up ", r"^list \d+", r"^  [a-z0-9-]+: \d+ runs, median ", r"^memory: wait4 peaks", r"^time-runs: "],
    "build": [r"^[0-9a-f]{40}$", r"^ \S.* \| +\d+", r"^ \d+ files? changed", r"^\[\d+/\d+\] ", r"^-- ", r"^build\.sh( shifts)?: ", r"^[0-9a-f]{64}  ", r"^done$",
              r"^clang: warning: argument unused during compilation: '-no-pie'"],
}[kind]
keep = [re.compile(p) for p in patterns]
lines = open(path, errors="replace").read().split("\n")
kept = [l for l in lines if any(k.search(l) for k in keep)]
open(path, "w").write("\n".join(kept) + "\n")
print("%s: kept %d of %d lines" % (path, len(kept), len(lines)))
