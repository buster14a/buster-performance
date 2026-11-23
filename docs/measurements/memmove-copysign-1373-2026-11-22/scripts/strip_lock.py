#!/usr/bin/env python3
# Rewrites a log without exclusive.sh's waiting messages, which name other sessions' jobs: each waiting line (the
# holder's owner line) and the indented title, link and pull request lines after it.
import sys
for path in sys.argv[1:]:
    with open(path, errors='replace') as f:
        lines = f.readlines()
    kept = []
    skipping = False
    for line in lines:
        if line.startswith('exclusive.sh: waiting'):
            skipping = True
            continue
        if skipping and line.startswith('  '):
            continue
        skipping = False
        kept.append(line)
    with open(path, 'w') as f:
        f.writelines(kept)
    print(f'{path}: {len(lines) - len(kept)} lines dropped', file=sys.stderr)
