#!/usr/bin/env python3
# reduce.py RESULTS_DIR: bucket survey.sh's timestamped group samples by --time-stages stage; print per-stage counters.
import sys, gzip, glob, re, collections, statistics
d = sys.argv[1]
def stages_of(path):
    rows = []
    for line in open(path):
        f = line.rstrip('\n').split('\t')
        if len(f) >= 3 and f[0] == 'time-stage' and f[1] not in ('stage', 'total') and '.' not in f[1]:
            rows.append((f[1], float(f[2])))
    return rows
def samples_of(path):
    out = []
    pat = re.compile(r'^\s*(\d+\.\d+):\s+(\d+)\s+(\S+?):\s+[0-9a-f]+\s+(.*)$')
    for line in gzip.open(path, 'rt'):
        m = pat.match(line)
        if m:
            sym = m.group(4).strip()
            sym = re.sub(r'\+0x[0-9a-f]+$', '', sym)
            out.append((float(m.group(1)), int(m.group(2)), m.group(3).replace(':u', ''), sym))
    return out
anchors = {'parse': 'parse_', 'tier0': 'tier0_generate'}
per_stage = collections.defaultdict(lambda: collections.Counter())
per_func = collections.defaultdict(lambda: collections.Counter())
order = []
for sp in sorted(glob.glob(d + '/g*-*.samples.gz')):
    st = stages_of(sp.replace('.samples.gz', '.stages.txt'))
    sm = samples_of(sp)
    if not st or not sm: continue
    starts = {}; acc = 0.0
    for name, ms in st:
        starts[name] = acc; acc += ms
    if not order: order = [n for n, _ in st]
    # Anchor at the first parse_ sample.
    t_parse = next(t for t, p, e, s in sm if s.startswith('parse_'))
    t0 = t_parse - starts['parse'] / 1000.0
    t_tier0 = next((t for t, p, e, s in sm if s.startswith('tier0_generate')), None)
    skew = None if t_tier0 is None else (t_tier0 - t0) * 1000.0 - starts['tier0']
    sys.stderr.write(f'{sp}: samples {len(sm)}, tier0 anchor skew {skew:.3f} ms\n')
    bounds = [(starts[n], starts[n] + ms, n) for n, ms in st]
    for t, p, e, s in sm:
        ms = (t - t0) * 1000.0
        name = 'outside'
        for a, b, n in bounds:
            if a <= ms < b: name = n; break
        per_stage[name][e] += p
        per_func[s][e] += p
runs = len(glob.glob(d + '/g1-*.samples.gz'))
def row(c):
    cyc = c['cycles'] / 2 or 1  # cycles is in both groups
    ins = c['instructions'] or 1
    return (c['cycles'] / 2 / runs / 1e6, ins / c['cycles'] * 2 if c['cycles'] else 0,
            1000 * c['ex_ret_brn_misp'] / ins, 100 * c['de_no_dispatch_per_slot.no_ops_from_frontend'] / 8 / cyc,
            100 * c['de_no_dispatch_per_slot.backend_stalls'] / 8 / cyc, 100 * c['ex_no_retire.load_not_complete'] / cyc,
            1000 * c['ls_dmnd_fills_from_sys.all'] / ins, 1000 * c['ls_dmnd_fills_from_sys.dram_io_near'] / ins,
            1000 * c['op_cache_hit_miss.op_cache_miss'] / ins)
hdr = 'Mcyc/run IPC misp/Ki fe%slots be%slots ldnc%cyc fills/Ki dram/Ki opmiss/Ki'
print('stage'.ljust(20), hdr)
tot = collections.Counter()
for n in order + ['outside']:
    if n in per_stage:
        c = per_stage[n]; tot.update(c)
        print(n.ljust(20), ' '.join(f'{v:8.2f}' for v in row(c)))
print('all'.ljust(20), ' '.join(f'{v:8.2f}' for v in row(tot)))
print()
print('function'.ljust(52), hdr)
for s, c in sorted(per_func.items(), key=lambda kv: -kv[1]['cycles'])[:60]:
    print(s[:52].ljust(52), ' '.join(f'{v:8.2f}' for v in row(c)))
