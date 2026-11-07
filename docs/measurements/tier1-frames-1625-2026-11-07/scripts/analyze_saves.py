#!/usr/bin/env python3
# #1625: the share of a profile's samples (IBS op, user mode) in an executable's code that are callee-saved registers'
# pushes and pops (rbx, rbp, r12 to r15), the saves and restores shrink-wrapping would move: by instruction from
# objdump, by sample IP from perf script. Usage: analyze_saves.py EXECUTABLE PROFILE...
import collections, re, subprocess, sys

exe = sys.argv[1]
saved = {'%rbx', '%rbp', '%r12', '%r13', '%r14', '%r15'}
instructions = {}
starts = {}
function = None
for line in subprocess.run(['objdump', '-d', '--no-show-raw-insn', exe], capture_output=True, text=True).stdout.split('\n'):
    m = re.match(r'^([0-9a-f]+) <(.*)>:$', line)
    if m:
        function = m.group(2)
        starts.setdefault(function, int(m.group(1), 16))
        continue
    m = re.match(r'^\s+([0-9a-f]+):\s+(\S+)\s*(.*)$', line)
    if m:
        instructions[int(m.group(1), 16)] = (m.group(2), m.group(3).strip(), function)

def kind(entry):
    mnemonic, operands, _ = entry
    if mnemonic in ('push', 'pushq') and operands in saved:
        return 'push'
    if mnemonic in ('pop', 'popq') and operands in saved:
        return 'pop'
    return 'other'

for profile in sys.argv[2:]:
    # Each sample's symbol and offset, which objdump's addresses name the same way in a PIE executable.
    out = subprocess.run(['perf', 'script', '-i', profile, '-F', 'ip,sym,symoff,dso'], capture_output=True, text=True).stdout
    counts = collections.Counter()
    functions = collections.Counter()
    total = 0
    inside = 0
    for line in out.split('\n'):
        parts = line.split()
        if len(parts) < 3 or 'kernel' in parts[-1]:
            continue
        total += 1
        m = re.match(r'^(.*)\+0x([0-9a-f]+)$', parts[1])
        ip = starts[m.group(1)] + int(m.group(2), 16) if m and m.group(1) in starts and parts[-1] == '(' + exe + ')' else -1
        if ip in instructions:
            inside += 1
            k = kind(instructions[ip])
            counts[k] += 1
            if k != 'other':
                functions[instructions[ip][2]] += 1
    saves = counts['push'] + counts['pop']
    print('%s: %d user samples, %d in the executable; callee-saved pushes %d, pops %d: %.2f%% of the executable\'s samples' %
          (profile, total, inside, counts['push'], counts['pop'], 100.0 * saves / max(inside, 1)))
    for name, n in functions.most_common(5):
        print('    %s: %d' % (name, n))
