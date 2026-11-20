# The gate's whole-list table: each build's user cycles against no bit, per ab round, and instructions against no bit.
import re, sys, os
logs = sys.argv[1]
for list_name in sys.argv[2:] or ("sqlite", "lua", "musl", "dsqlite", "dlua", "f1", "f4", "f16", "f64", "f256"):
    p = os.path.join(logs, f'time-{list_name}.log')
    text = open(p).read()
    rounds = text.split('== round ')[1:]
    per = {}
    instr = {}
    for r in rounds:
        m = re.search(r'list 1, user cycles \(millions\):\n((?:  .*\n)+)', r)
        for line in m.group(1).splitlines():
            mm = re.match(r'\s+([a-z0-9-]+): \d+ runs, median ([0-9.]+)(?:; against none ([-+0-9.]+)%)?', line)
            if mm and mm.group(3):
                per.setdefault(mm.group(1), []).append(mm.group(3) + '%')
        for mm in re.finditer(r'^list 1 ([a-z0-9-]+) \[.*?(\d+) instructions$', r, re.M):
            instr.setdefault(mm.group(1), []).append(int(mm.group(2)))
    base = sorted(instr['none'])[len(instr['none']) // 2]
    cells = []
    for b, v in per.items():
        i = sorted(instr[b])[len(instr[b]) // 2]
        cells.append(f'{b} {", ".join(v)} (instr {100.0 * (i - base) / base:+.2f}%)')
    print(f'{list_name}: ' + ' | '.join(cells))
