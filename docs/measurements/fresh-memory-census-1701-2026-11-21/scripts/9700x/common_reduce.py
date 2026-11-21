def stages_of(path):
    rows = []
    for line in open(path):
        f = line.rstrip('\n').split('\t')
        if len(f) >= 3 and f[0] == 'time-stage' and f[1] not in ('stage', 'total') and '.' not in f[1]:
            rows.append((f[1], float(f[2])))
    return rows
pat = re.compile(r'^\s*(\d+\.\d+):\s+(\d+)\s+(\S+?):\s+[0-9a-f]+\s+(.*)$')
per = collections.defaultdict(lambda: collections.defaultdict(collections.Counter))
runs = 0
for sp in sorted(glob.glob(d + '/g*-*.samples.gz')):
    st = stages_of(sp.replace('.samples.gz', '.stages.txt'))
    sm = []
    for line in gzip.open(sp, 'rt'):
        m = pat.match(line)
        if m: sm.append((float(m.group(1)), int(m.group(2)), m.group(3).replace(':u', ''), m.group(4).strip()))
    if '/g1-' in sp: runs += 1
    starts = {}; acc = 0.0
    for n, ms in st: starts[n] = acc; acc += ms
    t0 = next(t for t, p, e, s in sm if s.startswith('parse_')) - starts['parse'] / 1000.0
    bounds = [(starts[n], starts[n] + ms, n) for n, ms in st]
    for t, p, e, s in sm:
        ms = (t - t0) * 1000.0
        name = 'outside'
        for a, b, n in bounds:
            if a <= ms < b: name = n; break
        if name in want: per[name][s][e] += p
for n in per:
    tot = sum(c['cycles'] for c in per[n].values()) / 2 / runs / 1e6
    print(f'== {n}: {tot:.2f} M user cycles a run')
    for s, c in sorted(per[n].items(), key=lambda kv: -kv[1]['cycles'])[:25]:
        cyc = c['cycles'] / 2 or 1; ins = c['instructions'] or 1
        print(f"  {s[:60]:60s} {c['cycles']/2/runs/1e6:7.2f} IPC {ins/cyc:4.2f} ldnc {100*c['ex_no_retire.load_not_complete']/cyc:5.1f}% fe {100*c['de_no_dispatch_per_slot.no_ops_from_frontend']/8/cyc:5.1f}% fills/Ki {1000*c['ls_dmnd_fills_from_sys.all']/ins:6.2f}")
