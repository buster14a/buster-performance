import re, sys, statistics
for path in sys.argv[1:]:
    rounds = []
    cur = None
    for line in open(path):
        if line.startswith('== round'):
            cur = {}
            rounds.append(cur)
            continue
        m = re.match(r'run \d+ list \d+ (\S+) copy \d+: ([\d.]+) ms wall, ([\d.]+) ms user, ([\d.]+) ms system.* (\d+) user cycles, (\d+) instructions, status (\d+)', line)
        if m and cur is not None:
            b = m.group(1)
            cur.setdefault(b, []).append((float(m.group(2)), int(m.group(5)), int(m.group(6)), int(m.group(7))))
    print(path)
    for i, r in enumerate(rounds):
        med = {b: (statistics.median(x[1] for x in v), statistics.median(x[2] for x in v), statistics.median(x[0] for x in v), len(v), sum(x[3] for x in v)) for b, v in r.items()}
        base = med['base']
        out = []
        for b in ('head', 'base-again'):
            c, ins, w, n, st = med[b]
            out.append(f"{b} cycles {100*(c/base[0]-1):+.2f}% wall {100*(w/base[2]-1):+.2f}% instr {(ins-base[1])/1e6:+.3f}M (n={n}, status {st})")
        print(f"  round {i+1}: base {base[0]/1e6:.1f}M cycles {base[2]:.1f} ms; " + "; ".join(out))
