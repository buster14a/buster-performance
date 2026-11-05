#!/usr/bin/env python3
"""#874 E2 counters: task-clock, page faults, kernel and user cycles for each tree."""
import os
import sys

directory, units = sys.argv[1], sys.argv[2:]


def read(path):
    values = {}
    for line in open(path):
        fields = line.strip().split(',')
        if len(fields) < 3 or fields[0].startswith('#'):
            continue
        try:
            value = float(fields[0])
        except ValueError:
            continue
        values[fields[2]] = value
    return values


print('| Unit | Tree | task-clock ms | page faults | kernel Mcycles | user Mcycles | user instructions |')
print('| --- | --- | ---: | ---: | ---: | ---: | ---: |')
for unit in units:
    for tree in ('fix', 'control'):
        v = read(os.path.join(directory, f'stat-{tree}-{unit}.csv'))
        print(f'| `{unit}.c` | {tree} | {v.get("task-clock", 0):.1f} | {v.get("page-faults", 0):.0f} | '
              f'{v.get("cycles:k", 0) / 1e6:.1f} | {v.get("cycles:u", 0) / 1e6:.1f} | {v.get("instructions:u", 0):.0f} |')
