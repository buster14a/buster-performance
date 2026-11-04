# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# cases.py LOG: the "== case NAME" sections of ab1236e.sh-style logs (or "== vmstat NAME" closing them), each build's
# medians over its time-runs processes of status 0 (wall, user and system time, minor faults, user cycles), and each
# build's median wall time and user cycles against base's.
import re
import statistics
import sys

cases = []
current = None
run = re.compile(r'^run \d+ list 1 (\S+) (?:placement \d+ )?copy \d+: ([0-9.]+) ms wall, ([0-9.]+) ms user, ([0-9.]+) ms system, '
                 r'(\d+) KiB wait4 peak, (\d+) minor faults, \d+ major, (\d+) user cycles, (\d+) instructions, status 0$')
plain = re.compile(r'^run \d+ list 1 (\S+): ([0-9.]+) ms wall, ([0-9.]+) ms user, ([0-9.]+) ms system, '
                   r'(\d+) KiB wait4 peak, (\d+) minor faults, \d+ major, (\d+) user cycles, (\d+) instructions, status 0$')
for line in open(sys.argv[1]):
    line = line.rstrip('\n')
    match = re.match(r'^== case (.*)$', line)
    if match:
        current = {'name': match.group(1), 'builds': {}}
        cases.append(current)
        continue
    match = run.match(line) or plain.match(line)
    if match and current is not None:
        values = current['builds'].setdefault(match.group(1), [])
        values.append([float(match.group(2)), float(match.group(3)), float(match.group(4)), int(match.group(6)), int(match.group(7))])
for case in cases:
    print('== ' + case['name'])
    base = case['builds'].get('base')
    for build, values in case['builds'].items():
        medians = [statistics.median(v[i] for v in values) for i in range(5)]
        against = ''
        if base and build != 'base':
            bw = statistics.median(v[0] for v in base)
            bc = statistics.median(v[4] for v in base)
            against = '; wall %+.2f%%, user cycles %+.2f%%' % (100.0 * (medians[0] / bw - 1.0), 100.0 * (medians[4] / bc - 1.0))
        print('  %-10s n=%d wall %.3f ms, user %.3f ms, system %.3f ms, faults %d, user cycles %.3f M%s' %
              (build, len(values), medians[0], medians[1], medians[2], medians[3], medians[4] / 1e6, against))
