#!/usr/bin/env python3
# values.py TABLE [XL1_TABLE XL2_TABLE] > values.json: the numbers the write-ups use, from xl-table.py's output of the
# final readings (and the two builds' tables): each line's medians and ranges by corpus, and the counts.
import json, re, sys
def parse(path):
    T = {}
    for line in open(path):
        m = re.match(r'(sqlite3|lua|musl)\s+(.*?)\s+on\s+(-?[\d.]+) \((-?[\d.]+) to (-?[\d.]+)\)\s+before\s+(-?[\d.]+) \((-?[\d.]+) to (-?[\d.]+)\)\s+on less before ([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)', line)
        if m:
            c, name = m.group(1), m.group(2).strip()
            T.setdefault(c, {})[name] = dict(on=m.group(3), on_lo=m.group(4), on_hi=m.group(5), before=m.group(6), before_lo=m.group(7), before_hi=m.group(8), d=m.group(9), d_lo=m.group(10), d_hi=m.group(11))
            continue
        m = re.match(r'(sqlite3|lua|musl)\s+(on|before)\s+C: expressions (\d+) decided (\d+) refused (\d+) differences (\d+) records-that-differ (\d+); rows: expressions (\d+) taken (\d+) \(([\d.]+)%\) records (\d+) entries (\d+) differences (\d+) unkept (\d+) second-runs-that-differ (\d+) swept (\d+) written (\d+) chunks (\d+); listed (\d+) (\d+) (\d+) (\d+); numbered (\d+) steps (\d+); the same in every run: (\w+)\s+\[(\d+) readings\]', line)
        if m:
            g = m.groups()
            T.setdefault(g[0], {})['counts ' + g[1]] = dict(expressions=int(g[2]), decided=int(g[3]), refused=int(g[4]), c_differences=int(g[5]), c_record_differences=int(g[6]), x_expressions=int(g[7]), taken=int(g[8]),
                                                           taken_share=g[9], records=int(g[10]), entries=int(g[11]), differences=int(g[12]), unkept=int(g[13]), second=int(g[14]), swept=int(g[15]), written=int(g[16]),
                                                           chunks=int(g[17]), listed=[int(x) for x in g[18:22]], numbered=int(g[22]), steps=int(g[23]), same=g[24], readings=int(g[25]))
        m = re.match(r'(sqlite3|lua|musl)\s+(on|before)\s+C more: valued (\d+) listed-for-their-target (\d+) commas (\d+); listed: call (\d+) logical-or-conditional (\d+) update (\d+) comma (\d+) division (\d+) wide (\d+) operator (\d+)', line)
        if m:
            g = m.groups()
            T.setdefault(g[0], {})['more ' + g[1]] = dict(valued=int(g[2]), sunk=int(g[3]), commas=int(g[4]), call=int(g[5]), logical=int(g[6]), update=int(g[7]), comma=int(g[8]), division=int(g[9]), wide=int(g[10]), operator=int(g[11]))
        m = re.match(r'runs: (\d+); without status 0: (\d+)', line)
        if m:
            T['runs'] = dict(runs=int(m.group(1)), failed=int(m.group(2)))
    return T
out = {'final': parse(sys.argv[1])}
for name, path in zip(('xl1', 'xl2'), sys.argv[2:4]):
    out[name] = parse(path)
json.dump(out, sys.stdout, indent=1)
