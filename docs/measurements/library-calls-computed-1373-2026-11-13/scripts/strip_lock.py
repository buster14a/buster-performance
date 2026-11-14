#!/usr/bin/env python3
# Copies a log without exclusive.sh's waiting messages, which name other sessions' jobs: a waiting line, its title, link
# and pull request lines, and the lines of the holder's command up to the next line of a shape this record's scripts,
# builds and tools print.
import re, sys
OWN = re.compile(r'^(-- |\[\d+/\d+\]|build\.sh|ninja|CMake|Build files|[0-9a-f]{64}  |sqlite |perf |   text|\s*\d+\s+\d+\s+\d+\s|base|head|fix|kernels |drv\.o|k-|clang-|instructions|host|round |done|built |record )')
def strip(lines):
    out = []
    skipping = False
    for line in lines:
        if line.startswith('exclusive.sh: waiting'):
            skipping = True
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
