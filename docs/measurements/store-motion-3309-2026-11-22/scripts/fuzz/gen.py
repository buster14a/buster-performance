#!/usr/bin/env python3
# Random loops over globals for #3309: scalars, fields, elements, a union, statics, pointers that may alias them, calls.
import random, sys
seed = int(sys.argv[1]); R = random.Random(seed)
U = 'unsigned long'
scalars = ['ga', 'gb', 'gc', 'sa', 'sb']
ints = ['gi', 'gj']
lv_all = scalars + ints + ['gs16', 'gu8', 'gst.x', 'gst.y', 'gst.z[1]', 'arr[2]', 'arr[5]', 'gun.l', 'gun.i[0]', 'gun.i[1]', 'gun.c[3]', 'tab[1]', 'tab[3]']
flt = ['gd', 'gst.w']
def rd(depth, idx):
    c = R.random()
    if c < 0.30: return R.choice(lv_all)
    if c < 0.40 and idx: return R.choice(idx)
    if c < 0.50: return str(R.randrange(1, 9))
    if c < 0.58: return 'p[%s & 3]' % (R.choice(idx) if idx else '1')
    if c < 0.64: return '*q'
    if c < 0.70: return 'arr[%s & 7]' % (R.choice(idx) if idx else '3')
    if c < 0.74: return 'tab[%s & 3]' % (R.choice(idx) if idx else '2')
    if depth > 2: return R.choice(lv_all)
    return '(%s %s %s)' % (rd(depth + 1, idx), R.choice(['+', '-', '^', '*', '&', '|']), rd(depth + 1, idx))
def lvalue(idx):
    c = R.random()
    if c < 0.62: return R.choice(lv_all)
    if c < 0.72: return 'arr[%s & 7]' % (R.choice(idx) if idx else '1')
    if c < 0.80: return '*q'
    if c < 0.86: return 'p[%s & 3]' % (R.choice(idx) if idx else '0')
    if c < 0.92: return 'tab[%s & 3]' % (R.choice(idx) if idx else '0')
    return '*gp'
def stmt(depth, idx, out, ind, inloop):
    c = R.random()
    pad = '    ' * ind
    if c < 0.55:
        out.append('%s%s %s (%s)(%s);' % (pad, lvalue(idx), R.choice(['+=', '^=', '=', '-=', '|=']), U, rd(0, idx)))
    elif c < 0.62:
        f = R.choice(flt)
        out.append('%s%s = %s * 1.5 + (double)(%s & 7);' % (pad, f, f, rd(1, idx)))
    elif c < 0.74:
        out.append('%sif ((%s) & %d)' % (pad, rd(1, idx), R.choice([1, 2, 4])))
        out.append('%s{' % pad); stmt(depth, idx, out, ind + 1, inloop); out.append('%s}' % pad)
        if R.random() < 0.5:
            out.append('%selse' % pad); out.append('%s{' % pad); stmt(depth, idx, out, ind + 1, inloop); out.append('%s}' % pad)
    elif c < 0.80 and depth < 3:
        v = 'i%d' % depth
        kind = R.random()
        out.append('%sfor (int %s = 0; %s < %s; %s += 1)' % (pad, v, v, R.choice(['n', 'm', '3', '(int)(ga & 3)']) if kind < 0.8 else 'n', v))
        out.append('%s{' % pad)
        for _ in range(R.randrange(1, 4)): stmt(depth + 1, idx + [v], out, ind + 1, True)
        out.append('%s}' % pad)
    elif c < 0.84:
        out.append('%shelper%d((%s)(%s));' % (pad, R.randrange(2), U, rd(1, idx)))
    elif c < 0.88 and inloop:
        out.append('%sif (((%s) & 15) == 3) { %s; }' % (pad, rd(1, idx), R.choice(['break', 'continue'])))
    elif c < 0.92 and inloop:
        out.append('%sif (((%s) & 31) == 5) { return; }' % (pad, rd(1, idx)))
    else:
        out.append('%s%s += %s;' % (pad, R.choice(scalars), R.choice(scalars)))
def function(k):
    out = ['__attribute__((noinline)) void f%d(%s* p, %s* q, int n, int m)' % (k, U, U), '{']
    shape = R.random()
    if shape < 0.75:
        out.append('    for (int i0 = 0; i0 < n; i0 += 1)'); out.append('    {')
        for _ in range(R.randrange(1, 6)): stmt(1, ['i0'], out, 2, True)
        out.append('    }')
    elif shape < 0.88:
        out.append('    int i0 = 0;'); out.append('    do'); out.append('    {')
        for _ in range(R.randrange(1, 5)): stmt(1, ['i0'], out, 2, True)
        out.append('        i0 += 1;'); out.append('    } while (i0 < n);')
    else:
        out.append('    int i0 = 0;'); out.append('    while ((%s) + (%s)i0 < (%s)(n * 3))' % (R.choice(scalars + ['gst.x']), U, U) if False else '    while (i0 < n && ((ga + (%s)i0) & 63) != 62)' % U); out.append('    {')
        for _ in range(R.randrange(1, 5)): stmt(1, ['i0'], out, 2, True)
        out.append('        i0 += 1;'); out.append('    }')
    for _ in range(R.randrange(0, 3)): stmt(0, [], out, 1, False)
    out.append('}')
    return '\n'.join(out)
print('#include <stdio.h>')
print('%s ga = 1, gb = 2, gc = 3; static %s sa = 4, sb = 5; unsigned int gi = 6, gj = 7; unsigned short gs16 = 8; unsigned char gu8 = 9;' % (U, U))
print('double gd = 1.5; struct S { %s x; unsigned int y; unsigned int z[3]; double w; } gst = { 10, 11, { 12, 13, 14 }, 2.5 };' % U)
print('%s arr[8] = { 1, 2, 3, 4, 5, 6, 7, 8 }; static %s tab[4] = { 9, 8, 7, 6 }; union V { %s l; unsigned int i[2]; unsigned char c[8]; } gun = { 77 }; %s* gp = &gc;' % (U, U, U, U))
print('__attribute__((noinline)) void helper0(%s x) { ga += x; gst.y ^= (unsigned int)x; }' % U)
print('__attribute__((noinline)) void helper1(%s x) { sb = sb * 3 + x; arr[x & 7] += 1; }' % U)
nf = R.randrange(3, 7)
for k in range(nf): print(function(k))
print('static void show(const char* s) { printf("%s %lu %lu %lu %lu %lu %u %u %u %u | %.3f %lu %u %u %.3f | %lu %lu %lu %lu %lu %lu %lu %lu | %lu %lu %lu %lu | %lu\\n", s, ga, gb, gc, sa, sb, gi, gj, gs16, gu8, gd, gst.x, gst.y, gst.z[1], gst.w, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6], arr[7], tab[0], tab[1], tab[2], tab[3], gun.l); }')
print('int main(void)')
print('{')
print('    %s local[4] = { 21, 22, 23, 24 }; %s cell = 31;' % (U, U))
targets_p = ['local', 'arr', 'arr + 4', 'tab']
targets_q = ['&cell', '&ga', '&gb', '&gst.x', '&arr[2]', '&gun.l', '&sa', '&tab[1]', '&local[1]']
for r in range(R.randrange(8, 16)):
    k = R.randrange(nf)
    if R.random() < 0.3: print('    gp = %s;' % R.choice(['&gc', '&ga', '&sb', '&arr[5]', '&cell']))
    print('    f%d(%s, %s, %d, %d); show("f%d");' % (k, R.choice(targets_p), R.choice(targets_q), R.choice([0, 1, 2, 3, 5, 9, 17]), R.choice([0, 1, 2, 4]), k))
print('    printf("%lu %lu %lu %lu %lu\\n", local[0], local[1], local[2], local[3], cell);')
print('    return 0;')
print('}')
