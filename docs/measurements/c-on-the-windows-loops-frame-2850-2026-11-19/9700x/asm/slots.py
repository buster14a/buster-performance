#!/usr/bin/env python3
# slots.py LOOP.s: the loop's main body's memory operands by kind: the frame's slots (written and read, by register
# kind), the constants' (rip-relative), and the others' (a pointer and an index).
import re, sys, collections
path = sys.argv[1]
ins = []
for line in open(path):
    m = re.match(r'\s*([0-9a-f]+):\s+(\S+)\s*(.*)', line)
    if m:
        ins.append((int(m.group(1), 16), m.group(2), m.group(3)))
best = None
for a, op, args in ins:
    if op.startswith('j'):
        m = re.match(r'([0-9a-f]+) <', args)
        if m:
            t = int(m.group(1), 16)
            if t < a and (best is None or a - t > best[0]):
                best = (a - t, t, a)
_, head, tail = best
body = [(a, op, args) for a, op, args in ins if head <= a <= tail]
frame = collections.defaultdict(lambda: [0, 0, set()])
rip = 0; other = 0; rip_ops = collections.Counter()
for a, op, args in body:
    args = args.split('#')[0]
    m = re.search(r'(-?0x[0-9a-f]+)?\((%rsp|%rbp)[^)]*\)', args)
    if m:
        slot = m.group(0)
        parts = args.split(',')
        # AT&T: the last operand is the destination.
        dest = parts[-1].strip() if not op.startswith(('cmp', 'test', 'vpcmp', 'vptest', 'kortest', 'ktest')) else ''
        written = slot in dest and op.startswith(('mov', 'vmov', 'kmov'))
        kind = 'zmm' if '%zmm' in args else 'ymm' if '%ymm' in args else 'xmm' if '%xmm' in args else 'k' if re.search(r'%k\d', args) else 'gpr'
        frame[slot][0 if written else 1] += 1
        frame[slot][2].add(kind)
    elif '(%rip)' in args:
        rip += 1; rip_ops[op] += 1
    elif re.search(r'\(%r', args) and not op.startswith('lea'):
        other += 1
kinds = collections.Counter()
for slot, (w, r, k) in frame.items():
    kinds['/'.join(sorted(k))] += 1
print('%s: main body %d instructions; frame slots %d (%s); frame writes %d, frame reads %d; rip-relative operands %d (%s); other memory operands %d' % (
    path, len(body), len(frame), ', '.join('%s %d' % kv for kv in sorted(kinds.items())), sum(v[0] for v in frame.values()), sum(v[1] for v in frame.values()), rip,
    ', '.join('%s %d' % kv for kv in rip_ops.most_common(6)), other))
multi = sorted(frame.items(), key=lambda kv: -(kv[1][0] + kv[1][1]))[:12]
print('   busiest slots (writes, reads, kind): ' + '; '.join('%s %d/%d %s' % (s, v[0], v[1], '/'.join(sorted(v[2]))) for s, v in multi))
