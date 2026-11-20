import sys, re, statistics, collections
# medians.py results.txt: the median time and faults of each section's modes (written when the record was assembled).
section = None
table = collections.OrderedDict()
for line in open(sys.argv[1]):
    if line.startswith('== '):
        section = ', '.join(re.sub(r' \(.*?\)', '', line[3:].split(' [')[0]).split(', ')[:2]).strip()
        sub = ''
        continue
    if line.strip() in ('tmpfs', 'ext4'):
        sub = line.strip()
        continue
    m = re.match(r'mode (\d+):\s+([\d.]+) us,?\s+(\d+) faults', line)
    if m and section:
        table.setdefault((section, sub, int(m.group(1))), []).append((float(m.group(2)), int(m.group(3))))
    m = re.match(r'present: one call ([\d.]+) us, 32 calls ([\d.]+) us', line)
    if m:
        table.setdefault((section, 'one call', 0), []).append((float(m.group(1)), 0))
        table.setdefault((section, '32 calls', 0), []).append((float(m.group(2)), 0))
for (sec, sub, mode), v in table.items():
    t = sorted(x[0] for x in v)
    print('%-34s %-8s mode %d: n=%d median %7.1f us (min %7.1f, max %7.1f) faults %d' % (sec[:34], sub, mode, len(v), statistics.median(t), t[0], t[-1], statistics.median(x[1] for x in v)))
