#!/usr/bin/env python3
# probes.py STRACE...: the failed opens of a compile by what failed: a name its directory lacks, or a path under a
# subdirectory that is not there (the longest prefix that is a directory, then the component it lacks), with how many
# such components failed twice or more, the asks a second miss would make and the probes they would save.
import os, re, sys
from collections import Counter
for f in sys.argv[1:]:
    failed = []
    opens = 0
    pending = {}
    lines = []
    for line in open(f, errors='replace'):
        # A call another thread interrupted is two lines: `PID call(args <unfinished ...>` and `PID <... call resumed>rest`.
        m = re.match(r'(\d+) +(.*) <unfinished \.\.\.>$', line.rstrip('\n'))
        if m:
            pending[m.group(1)] = m.group(2)
            continue
        m = re.match(r'(\d+) +<\.\.\. \w+ resumed>(.*)$', line.rstrip('\n'))
        if m and m.group(1) in pending:
            line = m.group(1) + ' ' + pending.pop(m.group(1)) + m.group(2)
        lines.append(line)
    for line in lines:
        m = re.search(r'openat\([A-Z_0-9]+, "([^"]*)", [A-Z_|]+\) = (-1 ENOENT|\d+)', line)
        if not m or 'O_DIRECTORY' in line or m.group(1).startswith(('/proc', '/sys/', '/dev/')):
            continue
        opens += 1
        if m.group(2).startswith('-1'):
            failed.append(m.group(1))
    under = Counter()
    names = 0
    for path in failed:
        directory = os.path.dirname(path)
        if os.path.isdir(directory):
            names += 1
        else:
            parts = path.split('/')
            k = len(parts) - 1
            while k > 1 and not os.path.isdir('/'.join(parts[:k])):
                k -= 1
            under[('/'.join(parts[:k]), parts[k])] += 1
    twice = {key: n for key, n in under.items() if n >= 2}
    print(f'{f}: opens {opens}, failed {len(failed)}; under a subdirectory that is not there {sum(under.values())} '
          f'({len(under)} components), of them under one that fails twice or more {sum(twice.values())} ({len(twice)} components); '
          f'a name the directory lacks {names}; asked at the second miss: {len(twice)} asks, {sum(n - 2 for n in twice.values())} probes saved, '
          f'failed opens then {len(failed) - sum(n - 2 for n in twice.values()) + len(twice)}')
