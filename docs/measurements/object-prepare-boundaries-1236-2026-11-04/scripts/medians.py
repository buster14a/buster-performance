# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# medians.py LOG: stat1236b.sh's "== one ROUND ITERATION BUILD: event=value ... status=N" lines, as each round's and
# build's median of every event, and head's and base-again's against base. A process whose status isn't 0 or whose
# count is missing ("<not counted>") or zero (four processes read cycles:u=0, which can't be) is left out of that
# event's median.
import re
import statistics
import sys

rows = {}
events = []
for line in open(sys.argv[1]):
    match = re.match(r'^== one (\d+) (\d+) (\S+): (.*) status=(\d+)$', line.strip())
    if not match or match.group(5) != '0':
        continue
    key = (match.group(1), match.group(3))
    for pair in match.group(4).replace('<not counted>', '-').replace('<not supported>', '-').split():
        name, value = pair.split('=', 1)
        if name not in events:
            events.append(name)
        if value.isdigit() and int(value) != 0:
            rows.setdefault(key, {}).setdefault(name, []).append(int(value))
for round_ in sorted({k[0] for k in rows}):
    for event in events:
        base = rows.get((round_, 'base'), {}).get(event, [])
        cells = []
        for build in ('base', 'head', 'base-again'):
            values = rows.get((round_, build), {}).get(event, [])
            if not values:
                cells.append('%s -' % build)
                continue
            median = statistics.median(values)
            against = '' if build == 'base' or not base else ' (%+.2f%%)' % (100.0 * (median / statistics.median(base) - 1.0))
            cells.append('%s %d n=%d%s' % (build, median, len(values), against))
        print('round %s %s: %s' % (round_, event, '; '.join(cells)))
