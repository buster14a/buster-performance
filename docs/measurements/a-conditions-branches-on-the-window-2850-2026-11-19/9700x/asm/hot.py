#!/usr/bin/env python3
# hot.py LOOP.s...: the loop function's main body by its layout: the instructions from the target of its longest
# backward jump to that jump (blocks the compiler moved out of line, the unlikely ones, lie after it), and of them
# those that write a zmm or a mask register to the frame or read one from it.
import re, sys
for path in sys.argv[1:]:
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
    span, head, tail = best
    body = [(a, op, args) for a, op, args in ins if head <= a <= tail]
    frame = r'\((%rsp|%rbp)[^)]*\)'
    def count(items, pat):
        return sum(1 for a, op, args in items if re.search(pat, op + ' ' + args))
    zs = count(body, r'^vmov\S+ +%zmm\d+,-?(0x[0-9a-f]+)?' + frame)
    zl = count(body, frame + r'.*%zmm\d+') - zs
    ks = count(body, r'^kmov\S+ +%k\d,-?(0x[0-9a-f]+)?' + frame)
    kl = count(body, r'^kmov\S+ +-?(0x[0-9a-f]+)?' + frame + r',%k\d')
    gs = count(body, r'^mov\S* +%r\w+,-?(0x[0-9a-f]+)?' + frame)
    gl = count(body, r'^mov\S* +-?(0x[0-9a-f]+)?' + frame + r',%r\w+')
    anyframe = count(body, frame)
    print('%-14s function %4d instructions; main body %4d instructions, %5d bytes; zmm to the frame %2d, from it %2d; mask to the frame %2d, from it %2d; general to the frame %2d, from it %2d; any frame operand %3d' % (
        path, len(ins), len(body), tail - head, zs, zl, ks, kl, gs, gl, anyframe))
