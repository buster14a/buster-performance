# deadlea.py DIS TSV...: lea's (rip- or rsp-based) whose destination is overwritten before any read, following straight
# code and unconditional direct jumps; counted by the TSVs' per-instruction counts (gap's #ins rows). Analysis only.
import re, sys
dis, tsvs = sys.argv[1], sys.argv[2:]
ins = {}; order = []
for line in open(dis):
    m = re.match(r'\s+([0-9a-f]+):\t(\S+)\s*(.*)$', line)
    if m:
        a = int(m.group(1), 16); ins[a] = (m.group(2), m.group(3).split('#')[0].strip()); order.append(a)
nxt = {order[i]: order[i+1] for i in range(len(order)-1)}
counts = {}
for t in tsvs:
    for line in open(t):
        f = line.rstrip('\n').split('\t')
        if f[0] == '#ins':
            counts[int(f[2], 16)] = counts.get(int(f[2], 16), 0) + int(f[5])
R64 = ['rax','rcx','rdx','rbx','rsp','rbp','rsi','rdi'] + ['r%d' % i for i in range(8, 16)]
def family(r):
    r = r.lstrip('%')
    for i, b in enumerate(R64):
        if r == b: return i
    alias = {'eax':0,'ecx':1,'edx':2,'ebx':3,'esp':4,'ebp':5,'esi':6,'edi':7,'ax':0,'cx':1,'dx':2,'bx':3,'al':0,'cl':1,'dl':2,'bl':3,'sil':6,'dil':7,'bpl':5,'si':6,'di':7,'bp':5}
    if r in alias: return alias[r]
    m = re.match(r'r(\d+)[dwb]?$', r)
    return int(m.group(1)) if m else None
def regs(s):
    return [family(x) for x in re.findall(r'%([a-z0-9]+)', s) if family(x) is not None]
def fate(start, R):
    a = nxt.get(start); steps = 0
    while a is not None and steps < 40:
        steps += 1
        mn, ops = ins[a]
        if mn == 'jmp' and re.match(r'^[0-9a-f]+ <', ops):
            a = int(ops.split()[0], 16); continue
        if mn.startswith('j') or mn in ('call', 'ret') or mn.startswith('int3') or mn == 'ud2':
            return 'unknown'
        parts = re.split(r',(?![^()]*\))', ops) if ops else []
        dest = parts[-1] if parts else ''
        srcs = parts[:-1]
        read = any(R in regs(p) for p in srcs) or ('(' in dest and R in regs(dest))
        pure_write = mn.startswith(('mov', 'lea', 'xor', 'pop', 'set')) and '(' not in dest and family(dest) == R and not (mn.startswith('xor') and len(srcs) == 1 and family(srcs[0]) != R)
        if read: return 'live'
        if mn.startswith(('movb', 'movw')) or (mn.startswith('mov') and dest.startswith('%') and family(dest) == R and re.match(r'%[a-d][lh]$|%[sd]il|%r\d+[bw]$', dest)):
            return 'unknown'
        if pure_write: return 'dead'
        if family(dest) == R: return 'live'
        a = nxt.get(a)
    return 'unknown'
tot = {}
for a in order:
    mn, ops = ins[a]
    if not mn.startswith('lea') or a not in counts: continue
    kind = 'rip' if '(%rip)' in ops else 'rsp' if '(%rsp' in ops else None
    if kind is None: continue
    R = family(ops.split(',')[-1])
    f = fate(a, R)
    tot[(kind, f)] = tot.get((kind, f), 0) + counts[a]
for k in sorted(tot): print('%s %-8s %8.1f M' % (k[0], k[1], tot[k] / 1e6))
