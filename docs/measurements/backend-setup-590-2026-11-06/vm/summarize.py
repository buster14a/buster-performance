import re, sys, glob, os, collections
d = sys.argv[1]
rows = collections.defaultdict(list)
for p in sorted(glob.glob(os.path.join(d, '*.txt'))):
    name = os.path.basename(p)[:-4]
    parts = name.split('-')
    if parts[0] not in ('empty', 'tiny', 'hello'):
        continue
    key = '-'.join(parts[:-1])
    text = open(p).read()
    r = {}
    m = re.search(r'^default: median of \d+: ([\d.]+) ms wall.*?(\d+) KiB wait4 peak, (\d+) minor', text, re.M)
    if not m:
        print('no default in', name); continue
    r['wall'] = float(m.group(1)); r['peak'] = int(m.group(2)); r['faults'] = int(m.group(3))
    m = re.search(r'^reference: median of \d+: ([\d.]+) ms wall', text, re.M)
    r['tcc'] = float(m.group(1)) if m else float('nan')
    for stage in ('setup', 'backend-setup', 'span', 'outside'):
        m = re.search(r'^  %s\s+([\d.]+)\s+\([^)]*\)\s+(?:[\d.]+%%\s+[\d.-]+\s+(\d+))?' % re.escape(stage), text, re.M)
        r[stage] = float(m.group(1)) if m else float('nan')
        if stage == 'backend-setup' and m and m.group(2):
            r['bs-faults'] = int(m.group(2))
    rows[key].append(r)
print('%-34s %4s %8s %8s %6s %8s %6s %8s %8s %8s %7s' % ('input-thp-cond-exe', 'n', 'wall', 'tcc', 'ratio', 'backend', 'bsflt', 'setup', 'span', 'outside', 'faults'))
for key in sorted(rows):
    rs = rows[key]
    def mean(k):
        v = [r.get(k, float('nan')) for r in rs]
        return sum(v) / len(v)
    print('%-34s %4d %8.3f %8.3f %6.2f %8.3f %6.0f %8.3f %8.3f %8.3f %7.0f' % (key, len(rs), mean('wall'), mean('tcc'), mean('wall') / mean('tcc'), mean('backend-setup'), mean('bs-faults'), mean('setup'), mean('span'), mean('outside'), mean('faults')))
    print('%-34s      rounds: wall %s; backend-setup %s' % ('', ', '.join('%.3f' % r['wall'] for r in rs), ', '.join('%.3f' % r['backend-setup'] for r in rs)))
