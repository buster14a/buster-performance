import sys, re, collections
# Parse `perf script --show-mmap-events -F time,addr,ip,sym` output of a page-fault record.
# Classify each fault by mapping (latest mmap covering addr) and by stage (time window or callchain roots).
path = sys.argv[1]
start_fn = sys.argv[2] if len(sys.argv) > 2 else 'bind_end'
mmaps = []  # (time, start, end, name, prot)
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
def mapping(addr, t):
    best = None
    for (mt, s, e, name, prot) in mmaps:
        if mt <= t and s <= addr < e:
            best = (s, e, name, prot)
    return best
roots = sys.argv[3].split(',') if len(sys.argv) > 3 else ['bind_end', 'check_driver_link_check', 'dynamic_static_inputs', 'link_check']
sel = [s for s in samples if any(any(r in f for r in roots) for f in s['chain'])]
print('samples', len(samples), 'selected', len(sel))
bymap = collections.Counter()
byfn = collections.Counter()
bymapfn = collections.Counter()
for s in sel:
    mp = mapping(s['addr'], s['t'])
    key = '%s %s %x+%x' % (mp[2], mp[3], mp[0], mp[1]-mp[0]) if mp else 'unmapped-or-brk %x' % s['addr']
    bymap[key] += 1
    fn = s['chain'][0] if s['chain'] else s['sym']
    byfn[fn] += 1
    bymapfn[(key, fn)] += 1
for k, v in bymap.most_common(): print('%5d %s' % (v, k))
print('--- by function')
for k, v in byfn.most_common(25): print('%5d %s' % (v, k))
print('--- by mapping and function')
for k, v in bymapfn.most_common(40): print('%5d %s | %s' % (v, k[0], k[1]))
