# ptable.py: parent.sh's table: each build's user cycles against base, each round; instructions against base (medians
# over every copy's runs).
import re, sys
for name in sys.argv[1:]:
    text = open(f'logs/parent-time-{name}.log').read()
    rounds = text.split('== round ')[1:]
    per = {}; instr = {}
    for r in rounds:
        m = re.search(r'list 1, user cycles \(millions\):\n((?:  .*\n)+)', r)
        for line in m.group(1).splitlines():
            mm = re.match(r'\s+([a-z0-9-]+): \d+ runs, median ([0-9.]+).*?against base ([-+0-9.]+)%', line)
            if mm:
                per.setdefault(mm.group(1), []).append(mm.group(3) + '%')
        for mm in re.finditer(r'^list 1 ([a-z0-9-]+) copy \d+ \[.*?(\d+) instructions$', r, re.M):
            instr.setdefault(mm.group(1), []).append(int(mm.group(2)))
    med = lambda b: sorted(instr[b])[len(instr[b]) // 2]
    print(f'{name}: ' + ' | '.join(f'{b} {", ".join(v)} (instr {(med(b) - med("base")) / 1e6:+.3f} M)' for b, v in per.items()) + f' | base {med("base") / 1e6:.2f} M instructions')
