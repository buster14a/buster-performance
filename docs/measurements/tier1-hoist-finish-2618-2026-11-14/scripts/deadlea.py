# deadlea.py TSV: executed `lea X(%rip),%R` that a later instruction in the same straight run overwrites before any read
# of R (up to 6 instructions, stopping at branches and calls), by function, with execution counts.
import sys, re, collections
FAM = {}
for a, b, c, d in [('rax','eax','ax','al'),('rbx','ebx','bx','bl'),('rcx','ecx','cx','cl'),('rdx','edx','dx','dl'),('rsi','esi','si','sil'),('rdi','edi','di','dil'),('rbp','ebp','bp','bpl')]:
    for n in (a, b, c, d): FAM[n] = (a, b, c, d)
for i in range(8, 16):
    fam = ('r%d' % i, 'r%dd' % i, 'r%dw' % i, 'r%db' % i)
    for n in fam: FAM[n] = fam
rows = collections.defaultdict(list)
for line in open(sys.argv[1]):
    f = line.rstrip('\n').split('\t')
    if f[0] == '#ins':
        rows[f[1]].append((int(f[2], 16), int(f[5]), f[6].split('#')[0]))
total = collections.Counter()
for fn, ins in rows.items():
    ins.sort()
    for k, (a, c, t) in enumerate(ins):
        m = re.match(r'\s*lea\s+-?0x[0-9a-f]+\(%rip\),%(\w+)', t)
        if not m or c == 0:
            continue
        fam = FAM.get(m.group(1), (m.group(1),))
        for a2, c2, t2 in ins[k + 1:k + 7]:
            if re.match(r'\s*(j|call|ret)', t2):
                break
            regs = re.findall(r'%(\w+)', t2)
            m2 = re.match(r'\s*(mov|lea|movslq|movzbl|movzwl|movl|movq)\s+(.*),%(\w+)\s*$', t2)
            if m2 and m2.group(3) in fam and not any(r in fam for r in re.findall(r'%(\w+)', m2.group(2))):
                total[fn] += c
                break
            if any(r in fam for r in regs):
                break
for fn, c in total.most_common(15):
    print(c, fn)
print('all', sum(total.values()))
