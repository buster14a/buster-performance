#!/usr/bin/env python3
# unit-tables.py SUMMARY BASE: unit-cost's summary (LABEL-NAME-TURN: event=value ...) as one table an event: each
# unit's mean over its turns by every compiler or setting, and its difference from BASE's.
import re, sys, collections
rows = collections.defaultdict(lambda: collections.defaultdict(list))
names = []
units = []
events = []
for line in open(sys.argv[1]):
    m = re.match(r'(\S+)-(\w+)-(\d): (.*)', line)
    if not m:
        continue
    unit, name, turn, rest = m.groups()
    if unit not in units: units.append(unit)
    if name not in names: names.append(name)
    for pair in rest.split():
        event, value = pair.split('=')
        if event not in events: events.append(event)
        rows[(unit, name)][event].append(float(value))
base = sys.argv[2]
others = [n for n in names if n != base]
for event in events:
    print(f'### {event}\n')
    print(f'| unit | {base} | ' + ' | '.join(others) + ' |')
    print('| --- | ---: | ' + ' | '.join('---:' for _ in others) + ' |')
    for unit in units:
        mean = lambda n: sum(rows[(unit, n)][event]) / len(rows[(unit, n)][event])
        b = mean(base)
        cells = [f'{mean(n):,.0f} ({mean(n) - b:+,.0f})' for n in others]
        print(f'| {unit} | {b:,.0f} | ' + ' | '.join(cells) + ' |')
    print()
