import re, sys, collections
def load(path):
    blocks = {}; values = {}; edges = []
    for line in open(path):
        if line.startswith('B '):
            m = re.match(r'B (\d+) \[(\d+),(\d+)\) preds(.*) succs(.*) phis(.*)', line)
            b = int(m.group(1))
            phis = re.findall(r'v(\d+)\(([^)]*)\)', m.group(6))
            blocks[b] = dict(start=int(m.group(2)), end=int(m.group(3)), preds=[int(x) for x in m.group(4).split()], succs=[int(x) for x in m.group(5).split()], phis=[(int(v), [int(o) for o in ops.split(',')]) for v, ops in phis])
        elif line.startswith('V '):
            parts = line.split()
            v = int(parts[1][1:])
            info = dict(p.split('=',1) for p in parts[2:8] if '=' in p)
            ivs = []
            for iv in re.findall(r'I(\d+)\[(\d+),(\d+)\)\{([^}]*)\}', line):
                frags = []
                for f in iv[3].split(','):
                    pos, loc = f.split(':')
                    frags.append((int(pos), loc))
                ivs.append((int(iv[0]), int(iv[1]), int(iv[2]), frags))
            values[v] = dict(info=info, ivs=ivs)
        elif line.startswith('E '):
            edges.append(line.strip())
    return blocks, values, edges
def loc_at(val, pos):
    for (i, s, e, frags) in val['ivs']:
        if s <= pos < e:
            loc = None
            for (p, l) in frags:
                if p <= pos: loc = l
            return loc
    return None
