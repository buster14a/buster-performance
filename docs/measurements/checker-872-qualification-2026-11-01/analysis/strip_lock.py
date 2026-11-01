#!/usr/bin/env python3
# #872: remove the lock's waiting messages, which name other sessions' work, from a published log.
import sys

for path in sys.argv[1:]:
    out = []
    skip = 0
    for line in open(path, errors='replace'):
        if line.startswith('exclusive.sh: waiting for the 9700X'):
            skip = 2
            continue
        if skip:
            skip -= 1
            continue
        out.append(line)
    open(path, 'w', errors='replace').writelines(out)
