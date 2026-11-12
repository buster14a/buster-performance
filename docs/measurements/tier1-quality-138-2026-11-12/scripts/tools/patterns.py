#!/usr/bin/env python3
# patterns.py DISASSEMBLY INS...: dynamic counts of instruction patterns in Tier 1's code, from gap's per-instruction
# rows (GAP_INSTRUCTIONS=1 gap count ...: "#ins function address tag type count text") summed over the INS files, and
# the executable's objdump -d --no-show-raw-insn text for the static order. Prints "pattern<TAB>instructions<TAB>share
# of the program's instructions". A pattern counts the instructions a fix would remove, named in its row.
import sys, re, collections
dis_path = sys.argv[1]
counts = collections.Counter(); tags = {}; types = {}
for path in sys.argv[2:]:
    for line in open(path):
        f = line.rstrip('\n').split('\t')
        a = int(f[2], 16)
        counts[a] += int(f[5]); tags[a] = f[3]; types[a] = f[4]
order = []  # (address, text, function)
function = None
for line in open(dis_path):
    m = re.match(r'^([0-9a-f]+) <(.+)>:$', line)
    if m:
        function = m.group(2); continue
    m = re.match(r'^\s+([0-9a-f]+):\t(.*)$', line.rstrip('\n'))
    if m and function is not None:
        order.append((int(m.group(1), 16), re.sub(r'\s+#.*$', '', m.group(2)).strip(), function))
index = {a: i for i, (a, t, f) in enumerate(order)}
total = sum(counts.values())
out = collections.Counter()
def c(i): return counts.get(order[i][0], 0)
def text(i): return order[i][1]
def split(t):
    p = t.split(None, 1)
    return p[0], (p[1] if len(p) > 1 else '')
def target(t):
    m = re.match(r'^j\w+\s+([0-9a-f]+)', t)
    return int(m.group(1), 16) if m else None
low = {'%rax': '%al', '%rbx': '%bl', '%rcx': '%cl', '%rdx': '%dl', '%rsi': '%sil', '%rdi': '%dil', '%rbp': '%bpl'}
def family(r):
    # A register's 64-bit name.
    r = r.strip()
    m = re.match(r'^%r(\d+)[dwb]?$', r)
    if m: return '%r' + m.group(1)
    table = {'al': 'rax', 'ax': 'rax', 'eax': 'rax', 'bl': 'rbx', 'bx': 'rbx', 'ebx': 'rbx', 'cl': 'rcx', 'cx': 'rcx', 'ecx': 'rcx', 'dl': 'rdx', 'dx': 'rdx', 'edx': 'rdx',
             'sil': 'rsi', 'si': 'rsi', 'esi': 'rsi', 'dil': 'rdi', 'di': 'rdi', 'edi': 'rdi', 'bpl': 'rbp', 'bp': 'rbp', 'ebp': 'rbp', 'spl': 'rsp', 'sp': 'rsp', 'esp': 'rsp'}
    return '%' + table.get(r[1:], r[1:])
n = len(order)
for i in range(n):
    a, t, f = order[i]
    k = counts.get(a, 0)
    if k == 0:
        continue
    m, ops = split(t)
    tag = tags.get(a, '-')
    # Shifts by zero.
    if m in ('shr', 'shl', 'sar') and ops.startswith('$0x0,'):
        out['shift by zero (the shift)'] += k
    # lea of a register plus a displacement into itself, an add's work.
    mm = re.match(r'^lea\s+(-?0x[0-9a-f]+)\((%\w+)\),(%\w+)$', t)
    if mm and mm.group(2) == mm.group(3):
        out['lea disp(r),r (an add; no instruction saved)'] += 0
    # A jump to the next instruction.
    if m == 'jmp' and i + 1 < n and target(t) == order[i + 1][0]:
        out['jmp to the next instruction'] += k
    # A jump to an unconditional jump (the first jump could go to its target).
    if m == 'jmp' and target(t) in index and split(text(index[target(t)]))[0] == 'jmp' and tag == 'j':
        out['jmp to a jmp (one of the two)'] += k
    # A constant into a register, then stored from it by the next instruction.
    mm = re.match(r'^mov\s+\$(0x[0-9a-f]+|-?\d+),(%\w+)$', t)
    zero = re.match(r'^xor\s+(%\w+),(%\w+)$', t)
    reg = mm.group(2) if mm else zero.group(2) if zero and zero.group(1) == zero.group(2) else None
    if reg and i + 1 < n and c(i + 1) == k:
        m2, o2 = split(text(i + 1))
        s = re.match(r'^(%\w+),(-?(0x)?[0-9a-f]*\(.*\))$', o2)
        if m2 == 'mov' and s and family(s.group(1)) == family(reg):
            out['constant in a register for the next store (the constant)'] += k
        # ... then compared: cmp %reg, x
        s = re.match(r'^(%\w+),(.*)$', o2)
        if m2 in ('cmp', 'test') and s and family(s.group(1)) == family(reg) and not re.match(r'^%', s.group(2)) is None and m2 == 'cmp':
            out['constant in a register for the next compare (the constant)'] += k
    # A constant or a setcc, then a test of that register and a branch: directly, or through a jump to the test.
    if reg or m.startswith('set'):
        r = family(reg) if reg else family(ops)
        j = i + 1
        hops = 0
        # Skip a movzx of the setcc's register and a recomputed value or an edge move that doesn't write r.
        while j < n and hops < 4:
            m2, o2 = split(text(j))
            if m2 == 'jmp' and target(text(j)) in index:
                j = index[target(text(j))]; hops += 1; continue
            if m2 in ('movzbl', 'movzx') and family(o2.split(',')[-1]) == r:
                j += 1; hops += 1; continue
            if m2 in ('lea', 'mov') and tags.get(order[j][0], '-') in ('r', 'e') and family(o2.split(',')[-1]) != r:
                j += 1; hops += 1; continue
            break
        if j + 1 < n:
            m2, o2 = split(text(j)); m3, o3 = split(text(j + 1))
            same = re.match(r'^(%\w+),(%\w+)$', o2)
            if m2 == 'test' and same and same.group(1) == same.group(2) and family(same.group(1)) == r and m3.startswith('j') and m3 != 'jmp':
                if reg:
                    out['constant, then test and branch on it (constant, test, branch; jump threading)'] += 3 * k
                else:
                    out['setcc, then test and branch on it across blocks (setcc, test)'] += 2 * k
    # Three moves that swap two registers through r11, on an edge.
    if tag == 'e' and i + 2 < n and tags.get(order[i + 1][0]) == 'e' and tags.get(order[i + 2][0]) == 'e':
        s1 = re.match(r'^mov\s+(%\w+),%r11$', t); s2 = re.match(r'^mov\s+(%\w+),(%\w+)$', text(i + 1)); s3 = re.match(r'^mov\s+%r11,(%\w+)$', text(i + 2))
        if s1 and s2 and s3 and s2.group(2) == s1.group(1) and s3.group(1) == s2.group(1):
            out['edge moves: a swap of two registers through r11 (3 moves)'] += 3 * k
by_tag = collections.Counter()
by_tag_type = collections.Counter()
for a, k in counts.items():
    by_tag[tags.get(a, '-')] += k
    by_tag_type[(tags.get(a, '-'), types.get(a, '?'))] += k
print(f'total\t{total}\t100.0%')
for name, k in sorted(out.items(), key=lambda x: -x[1]):
    print(f'{name}\t{k}\t{100.0 * k / total:.2f}%')
names = {'S': 'spill', 'L': 'reload', 'T': 'edge spill', 'U': 'edge reload', 'C': 'call save', 'R': 'call restore', 'e': 'edge move', 'a': 'call sequence', 'p': 'entry', 'f': 'frame',
         'r': 'recomputed', 'j': 'branch', 'n': 'node', '-': 'untagged', '_': 'padding'}
print()
for tag, k in sorted(by_tag.items(), key=lambda x: -x[1]):
    detail = ', '.join(f'{ty} {v / 1e6:.1f}' for (tg, ty), v in sorted(by_tag_type.items(), key=lambda x: -x[1]) if tg == tag and v >= 0.5e6)
    print(f'origin {names.get(tag, tag)}\t{k}\t{100.0 * k / total:.2f}%\t{detail}')
