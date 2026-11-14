#!/usr/bin/env python3
# stats14.py RESULTS: #2531's leftovers' final rounds (run14.sh time): per corpus, lanes and $LABEL, the median of the
# rounds of each way (wall ms, M cycles user + kernel, M kernel cycles, M user instructions, page faults, huge pages
# faulted), and each round's ratio of cycles (and of wall times) against fixF.
import os
import re
import statistics
import sys
import collections

directory = sys.argv[1] if len(sys.argv) > 1 else 'results'


def stat(path):
    values = {}
    for line in open(path):
        parts = line.strip().split(',')
        if len(parts) > 3:
            try:
                values[parts[2]] = float(parts[0])
            except ValueError:
                pass
    return values


def first_number(path):
    try:
        return float(open(path).read().split()[0])
    except (OSError, IndexError, ValueError):
        return None


def huge_pages(path):
    try:
        text = open(path).read()
    except OSError:
        return None
    found = re.search(r'(\d+)', text)
    return int(found.group(1)) if found else None


rows = collections.defaultdict(lambda: collections.defaultdict(dict))
for name in sorted(os.listdir(directory)):
    found = re.match(r'stat14-(musl|glibc)(-[a-z]+)?-(\d+)-(\w+?)-(\d+)\.csv$', name)
    if not found:
        continue
    corpus, label, lanes, way, round_ = found.groups()
    key = (corpus + (label or ''), int(lanes))
    values = stat(os.path.join(directory, name))
    rows[key][int(round_)][way] = {
        'wall': first_number(os.path.join(directory, name.replace('stat14-', 'wall14-').replace('.csv', '.txt'))),
        'cycles': values.get('cycles:u', 0) + values.get('cycles:k', 0),
        'kernel': values.get('cycles:k', 0),
        'instructions': values.get('instructions:u', 0),
        'faults': values.get('page-faults', 0),
        'huge': huge_pages(os.path.join(directory, name.replace('stat14-', 'thp14-').replace('.csv', '.txt'))),
    }

for key in sorted(rows):
    rounds = rows[key]
    print('== %s, %d lane%s: rounds %s' % (key[0], key[1], '' if key[1] == 1 else 's', sorted(rounds)))
    ways = sorted({way for r in rounds.values() for way in r})
    for way in ways:
        taken = [r[way] for r in rounds.values() if way in r]

        def median(field):
            numbers = [t[field] for t in taken if t[field] is not None]
            return statistics.median(numbers) if numbers else float('nan')

        print('  %-8s wall %7.1f ms  cycles %8.1f M  kernel %7.1f M  user instructions %8.1f M  faults %7d  huge pages %s'
              % (way, median('wall'), median('cycles') / 1e6, median('kernel') / 1e6, median('instructions') / 1e6,
                 median('faults'), sorted({t['huge'] for t in taken})))
    for way in ways:
        if way == 'fixF':
            continue
        cycles = sorted(r[way]['cycles'] / r['fixF']['cycles'] for r in rounds.values() if way in r and 'fixF' in r)
        walls = sorted(r[way]['wall'] / r['fixF']['wall'] for r in rounds.values()
                       if way in r and 'fixF' in r and r[way]['wall'] and r['fixF']['wall'])
        if cycles:
            print('  %s against fixF: cycles median %.3f (rounds %s); wall median %.3f (rounds %s)'
                  % (way, statistics.median(cycles), ' '.join('%.3f' % c for c in cycles),
                     statistics.median(walls) if walls else float('nan'), ' '.join('%.3f' % w for w in walls)))
