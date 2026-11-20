# The deletion's whole-compile table: head's and base again's user cycles against base, each ab round, and the
# instructions (median over every copy's runs) of head against base.
import re, sys
for name in sys.argv[2:]:
    text = open(f'{sys.argv[1]}/time-{name}.log').read()
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
    print(f'{name}: ' + ' | '.join(f'{b} {", ".join(v)}' for b, v in per.items()) +
          f' | instructions, head less base: {(med("head") - med("base")) / 1e6:+.3f} M of {med("base") / 1e6:.2f} M')
