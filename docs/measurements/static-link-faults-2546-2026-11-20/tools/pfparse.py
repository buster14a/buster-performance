import re
def parse(path):
    mmaps = []
    samples = []
    cur = None
    mm = re.compile(r'\s*([\d.]+): PERF_RECORD_MMAP2 \S+ \[0x([0-9a-f]+)\(0x([0-9a-f]+)\) @ \S+ \S+ \S+ \S+\]: (\S+) (.*)$')
    sm = re.compile(r'\s*([\d.]+):\s+([0-9a-f]+) (.*)$')
    for line in open(path):
        m = mm.match(line)
        if m:
            t, s, l, prot, name = float(m.group(1)), int(m.group(2), 16), int(m.group(3), 16), m.group(4), m.group(5)
            mmaps.append((t, s, s + l, name, prot))
            cur = None
            continue
        m = sm.match(line)
        if m and not line.startswith('\t'):
            cur = {'t': float(m.group(1)), 'addr': int(m.group(2), 16), 'sym': m.group(3).strip(), 'chain': []}
            samples.append(cur)
            continue
        if line.startswith('\t') and cur is not None:
            parts = line.strip().split(None, 1)
            if len(parts) == 2:
                cur['chain'].append(parts[1])
    return samples, mmaps
def mapping(mmaps, addr, t):
    best = None
    for (mt, s, e, name, prot) in mmaps:
        if mt <= t and s <= addr < e:
            best = (s, e, name, prot)
    return best
