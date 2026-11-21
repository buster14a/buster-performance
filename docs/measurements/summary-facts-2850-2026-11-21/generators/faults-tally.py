#!/usr/bin/env python3
# faults-tally.py DIRECTORY ROUNDS > faults.json: the fault rounds' verdicts, joined by a fault's name from the two
# machines' files (DIRECTORY/9700x-roundN.txt from the list's start up, DIRECTORY/cloud-roundN.txt from its end
# down; a round one machine ran has one file). A line is `caught|SURVIVED INDEX NAME status ...` or
# `not-built INDEX NAME`. A fault both machines ran must have one verdict: the run fails otherwise.
import json, os, re, sys
directory, rounds = sys.argv[1], int(sys.argv[2])
out = {}
for r in range(1, rounds + 1):
    verdicts, both, controls, machines = {}, 0, 0, 0
    for machine in ('9700x', 'cloud'):
        path = '%s/%s-round%d.txt' % (directory, machine, r)
        if not os.path.exists(path):
            continue
        machines += 1
        seen = set()
        for line in open(path):
            words = line.split()
            if not words:
                continue
            if words[0] == 'control-passes':
                controls += 1
            if words[0] not in ('caught', 'SURVIVED', 'not-built'):
                if words[0] not in ('control-passes', 'job'):
                    raise SystemExit('round %d: %s: %s' % (r, machine, line.strip()))
                continue
            name = words[2]
            if name in seen:
                raise SystemExit('round %d: %s twice on %s' % (r, name, machine))
            seen.add(name)
            if name in verdicts:
                both += 1
                if verdicts[name] != words[0]:
                    raise SystemExit('round %d: %s is %s and %s' % (r, name, verdicts[name], words[0]))
            verdicts[name] = words[0]
    def named(v): return sorted(n for n, w in verdicts.items() if w == v)
    out['round%d' % r] = dict(faults=len(verdicts), caught=len(named('caught')), survived=len(named('SURVIVED')), not_built=len(named('not-built')),
                              on_both=both, controls=controls, machines=machines, survivors=named('SURVIVED'), unbuilt=named('not-built'))
json.dump(out, sys.stdout, indent=1)
