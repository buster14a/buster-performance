#!/usr/bin/env python3
# count.py FILE...: probe4.py's lines counted: the statements, those the checker rejects, those that end with a status or
# a take the census refuses, what the reader-time tests refuse, by place.
import re, sys
def read(path):
    rows = []
    for line in open(path):
        line = line.rstrip('\n')
        if not line: continue
        m = re.match(r'(\w+): (.*?)\s+warns=', line)
        f = dict(re.findall(r'(\w[\w-]*)=(\S+)', line[line.index('warns='):]))
        rows.append((m.group(1), m.group(2), f, 'REJECTED' in line, 'STATUS' in line, line))
    return rows
for path in sys.argv[1:]:
    rows = read(path)
    acc = [r for r in rows if not r[3]]
    print(path, 'lines', len(rows), 'rejected', sum(r[3] for r in rows), 'accepted', len(acc))
    print('  status', sum(r[4] for r in acc), 'unsound-lines', sum(int(r[2]['unsound']) > 0 for r in acc), 'unsound-sum', sum(int(r[2]['unsound']) for r in acc))
    print('  reader-refuses lines', sum(int(r[2]['reader-refuses']) > 0 for r in acc), 'census-refuses lines', sum(int(r[2]['census-refuses']) > 0 for r in acc), 'warns lines', sum(int(r[2]['warns']) > 0 for r in acc))
    print('  rdiff', sum(r[2]['rdiff'] not in ('0',) for r in acc), 'window', sum(r[2]['window'] != '0' for r in acc), 'payload', sum(r[2]['payload'] not in ('0', '?') for r in acc), 'kernel', sum(r[2].get('kernel', '0') not in ('0', '?') for r in acc), 'C', sum(r[2]['C'] not in ('0', '?') for r in acc), 'own', sum(r[2]['own'] != '0/0/0/0' for r in acc))
    by = {}
    for r in acc:
        c = by.setdefault(r[0], [0, 0, 0, 0, 0])
        c[0] += 1; c[1] += int(r[2]['warns']) > 0; c[2] += int(r[2]['reader-refuses']) > 0; c[3] += int(r[2]['unsound']) > 0; c[4] += int(r[2]['census-refuses']) > 0
    for k, c in by.items():
        print('   %-9s accepted=%d census-event=%d reader-refuses=%d unsound=%d census-refuses=%d' % (k, *c))
