#!/usr/bin/env python3
# count2.py (in this directory): null2-before.txt against null2-after.txt by source and place: that the tests refuse
# nothing the compiler does not warn of, the same sources in every place, and what they refused before.
import re, sys
def read(path):
    rows = {}
    for line in open(path):
        line = line.rstrip('\n')
        if not line: continue
        m = re.match(r'(\w+): (.*?)\s+warns=', line)
        f = dict(re.findall(r'(\w[\w-]*)=(\S+)', line[line.index('warns='):]))
        f['rejected'] = 'REJECTED' in line; f['status'] = 'STATUS' in line; f['line'] = line
        rows[(m.group(1), m.group(2))] = f
    return rows
b = read('null2-before.txt'); a = read('null2-after.txt')
print('same keys', set(a) == set(b), len(a))
acc = [k for k in a if not a[k]['rejected']]
print('after: refused without the event', sum(int(a[k]['reader-refuses']) > 0 and int(a[k]['warns']) == 0 for k in acc))
print('after: event without refusal', sum(int(a[k]['reader-refuses']) == 0 and int(a[k]['warns']) > 0 for k in acc))
srcs = {}
for k in acc:
    srcs.setdefault(k[1], {})[k[0]] = (int(a[k]['warns']) > 0, int(a[k]['reader-refuses']) > 0)
print('sources accepted somewhere', len(srcs))
warned_everywhere = [s for s, d in srcs.items() if all(v[0] for v in d.values())]
print('sources warned in every place they are accepted', len(warned_everywhere), 'places per source', sorted(set(len(d) for d in srcs.values())))
mixed = [s for s, d in srcs.items() if len(set(v[0] for v in d.values())) > 1]
print('sources warned in some places only', mixed)
print('before: reader-refuses by place', {p: sum(int(b[k]['reader-refuses']) > 0 for k in acc if k[0] == p) for p in ['assign', 'init', 'argument', 'second', 'return']})
print('before: other statuses (status without unsound):', [k for k in acc if b[k]['status'] and int(b[k]['unsound']) == 0])
print('before: payload lines', [k for k in acc if b[k]['payload'] not in ('0', '?')])
# the 38: sources the tests refuse now, by place
ref = {p: sorted(k[1] for k in acc if k[0] == p and int(a[k]['reader-refuses']) > 0) for p in ['assign', 'init', 'argument', 'second', 'return']}
print('same 38 in every place', all(ref[p] == ref['assign'] for p in ref), len(ref['assign']))
bef = {p: sorted(k[1] for k in acc if k[0] == p and int(b[k]['reader-refuses']) > 0) for p in ['assign', 'return']}
print('before assign refused:', bef['assign'])
print('before same in return', bef['assign'] == bef['return'])
