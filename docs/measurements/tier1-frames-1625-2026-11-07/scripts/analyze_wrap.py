#!/usr/bin/env python3
# #1625: which callee-saved pushes shrink-wrapping could move. A saved register used in the function's entry run (the
# instructions after its pushes up to and including its first branch, which every path executes) must be saved
# before that use: shrink-wrapping can't move its save or its restores. Only a register first used past a branch can
# be saved later, on the paths that use it. Weighted by a profile's samples of each function's pushes and pops.
# Usage: analyze_wrap.py EXECUTABLE PROFILE...
import collections, re, subprocess, sys

exe = sys.argv[1]
saved_names = ['rbx', 'rbp', 'r12', 'r13', 'r14', 'r15']
aliases = {
    'rbx': ['rbx', 'ebx', 'bx', 'bl', 'bh'],
    'rbp': ['rbp', 'ebp', 'bp', 'bpl'],
    'r12': ['r12', 'r12d', 'r12w', 'r12b'],
    'r13': ['r13', 'r13d', 'r13w', 'r13b'],
    'r14': ['r14', 'r14d', 'r14w', 'r14b'],
    'r15': ['r15', 'r15d', 'r15w', 'r15b'],
}
functions = collections.OrderedDict()
starts = {}
function = None
for line in subprocess.run(['objdump', '-d', '--no-show-raw-insn', exe], capture_output=True, text=True).stdout.split('\n'):
    m = re.match(r'^([0-9a-f]+) <(.*)>:$', line)
    if m:
        function = m.group(2)
        starts.setdefault(function, int(m.group(1), 16))
        functions[function] = []
        continue
    m = re.match(r'^\s+([0-9a-f]+):\s+(\S+)\s*(.*)$', line)
    if m and function is not None:
        functions[function].append((int(m.group(1), 16), m.group(2), m.group(3).split('#')[0].strip()))

def uses(operands, reg):
    return any(re.search(r'%' + a + r'\b', operands) for a in aliases[reg])

# Each function's pushed callee-saved registers, and those first used past its entry run (movable).
pushed = {}
movable = {}
frame_pointer = {}
for name, body in functions.items():
    regs = []
    i = 0
    while i < len(body) and body[i][1] in ('push', 'pushq') and body[i][2].lstrip('%') in saved_names:
        regs.append(body[i][2].lstrip('%'))
        i += 1
    # A frame pointer's push rbp; mov rbp, rsp is the frame's, not a saved register shrink-wrapping moves.
    fp = len(regs) > 0 and regs[0] == 'rbp' and i < len(body) and body[i][1] == 'mov' and body[i][2] == '%rsp,%rbp'
    if fp:
        regs = regs[1:]
    entry = set()
    j = i
    while j < len(body):
        mnemonic, operands = body[j][1], body[j][2]
        for r in regs:
            if uses(operands, r):
                entry.add(r)
        if mnemonic.startswith('j') or mnemonic.startswith('ret'):
            break
        j += 1
    pushed[name] = regs
    movable[name] = [r for r in regs if r not in entry]
    frame_pointer[name] = fp

addresses = {}
for name, body in functions.items():
    for address, mnemonic, operands in body:
        addresses[address] = (name, mnemonic, operands)

for profile in sys.argv[2:]:
    out = subprocess.run(['perf', 'script', '-i', profile, '-F', 'ip,sym,symoff,dso'], capture_output=True, text=True).stdout
    inside = 0
    saves = 0
    movable_saves = 0
    by_function = collections.Counter()
    for line in out.split('\n'):
        parts = line.split()
        if len(parts) < 3 or parts[-1] != '(' + exe + ')':
            continue
        m = re.match(r'^(.*)\+0x([0-9a-f]+)$', parts[1])
        if not m or m.group(1) not in starts:
            continue
        address = starts[m.group(1)] + int(m.group(2), 16)
        if address not in addresses:
            continue
        inside += 1
        name, mnemonic, operands = addresses[address]
        reg = operands.lstrip('%')
        if mnemonic in ('push', 'pushq', 'pop', 'popq') and reg in pushed.get(name, []):
            saves += 1
            if reg in movable[name]:
                movable_saves += 1
                by_function[name] += 1
    print('%s: %d samples in the executable; saved registers\' pushes and pops %d (%.2f%%), of registers first used past the entry run %d (%.2f%%)' %
          (profile, inside, saves, 100.0 * saves / max(inside, 1), movable_saves, 100.0 * movable_saves / max(inside, 1)))
    for name, n in by_function.most_common(5):
        print('    %s: %d (pushed %s, movable %s)' % (name, n, ','.join(pushed[name]), ','.join(movable[name])))
total = sum(1 for n in pushed if pushed[n])
some = sum(1 for n in pushed if movable[n])
print('%s: %d functions push saved registers, %d of them a register first used past the entry run' % (exe, total, some))
