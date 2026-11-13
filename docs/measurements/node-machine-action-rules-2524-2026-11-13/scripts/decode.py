#!/usr/bin/env python3
# decode.py OPS DIAG [N]: diag.c's lines (DIAG) counted by shape (operator, cast target kind, result kind, constant and
# category, each operand's kind, constant, category, qualified Q, wide W, not builtin *), the N most common; OPS is ops.txt.
import sys, re, collections
ops = {}
for l in open(sys.argv[1]):
    n, name = l.split()
    ops[n] = name.replace('CHECK_OP_', '')
kinds = {'0':'none','1':'void','2':'int','3':'float','4':'nullptr','5':'bitint','6':'complex','7':'ptr','8':'array','9':'incarray','10':'vla','11':'func','12':'vector','13':'extvec','14':'atomic','15':'struct','16':'union','17':'enum','99':'-'}
consts = {'0':'', '1':'I', '2':'F', '3':'A', '4':'L', '5':'D'}
cats = {'0':'r','1':'L','2':'f','3':'x'}
c = collections.Counter()
for l in open(sys.argv[2]):
    if not l.startswith('NMDIAG'): continue
    f = l.split()
    op = ops[f[1].split('=')[1]]
    tgt = kinds.get(f[2].split('=')[1], '?')
    m = re.match(r'res=k(\d+)/c(\d+)/cat(\d+)', f[3])
    res = kinds[m.group(1)] + consts.get(m.group(2),'?') + cats[m.group(3)]
    operands = []
    for o in f[4:]:
        mm = re.match(r'o(\d)=k(\d+)/c(\d+)/cat(\d+)/q(\d)/w(\d)/op(\d+)/b(\d)', o)
        operands.append('%s%s%s%s%s%s' % (kinds[mm.group(2)], consts.get(mm.group(3),'?'), cats[mm.group(4)], 'Q' if mm.group(5)=='1' else '', 'W' if mm.group(6)=='1' else '', '' if mm.group(8)=='1' else '*'))
    key = '%-10s tgt=%-6s res=%-8s %s' % (op, tgt, res, ' '.join(operands))
    c[key] += 1
for k, v in c.most_common(int(sys.argv[3]) if len(sys.argv) > 3 else 80):
    print('%6d %s' % (v, k))
