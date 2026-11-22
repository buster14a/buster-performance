import subprocess, sys, collections
cc = '/home/david/.cache/claude-2850/wt-mem/build/cmake/native/Release/compiler'
rows = []
for line in open(sys.argv[1]):
    f = line.rstrip('\n').split('\t')
    if f[0] == 'experiment-push' and len(f) >= 14:
        rows.append(dict(stage=f[1], arena=int(f[2]), begin=int(f[3]), size=int(f[4]), caller=f[5], fresh=int(f[10]), res=int(f[11]), nz=int(f[12]), inf=int(f[13])))
addrs = sorted(set(r['caller'] for r in rows))
names = {}
for a in addrs:
    o = subprocess.run(['addr2line', '-f', '-i', '-e', cc, a], capture_output=True, text=True).stdout.strip().split('\n')
    fn = [o[i] for i in range(0, len(o), 2)]
    loc = [o[i].split('/')[-1] for i in range(1, len(o), 2)]
    chain = [f'{f}@{l}' for f, l in zip(fn, loc) if not f.startswith('arena_push') and not f.startswith('experiment')]
    names[a] = ' < '.join(chain[:2])[:96]
rows = [r for r in rows if r['size'] < (1 << 30)]
MB = 1024.0
tot = collections.defaultdict(lambda: [0, 0.0, 0.0, 0.0, 0.0])
for r in rows:
    size_kb = (r['size'] + 4095) // 4096 * 4
    prior = max(0, size_kb - r['fresh'])
    newly = max(0, r['res'] - prior)
    r['newly'] = newly
    # Of what its stage newly made resident, what holds nothing but zeros or all-ones (an upper bound where part of the range was resident before).
    r['empty'] = max(0, min(newly, r['res'] - r['inf']))
    t = tot[r['stage']]
    t[0] += 1; t[1] += size_kb / MB; t[2] += r['fresh'] / MB; t[3] += newly / MB; t[4] += r['empty'] / MB
print(f"{'pushed in the stage after':<22} {'pushes':>6} {'pushed MB':>10} {'fresh MB':>9} {'newly resident':>14} {'of it empty':>11}")
s = [0, 0.0, 0.0, 0.0, 0.0]
for k, t in tot.items():
    print(f"{k:<22} {t[0]:>6} {t[1]:>10.1f} {t[2]:>9.1f} {t[3]:>14.1f} {t[4]:>11.1f}")
    for i in range(5): s[i] += t[i]
print(f"{'all':<22} {s[0]:>6} {s[1]:>10.1f} {s[2]:>9.1f} {s[3]:>14.1f} {s[4]:>11.1f}")
by = collections.OrderedDict()
for r in rows:
    k = (r['stage'], names[r['caller']])
    c = by.setdefault(k, [0, 0.0, 0.0, 0.0, 0.0, 0.0])
    c[0] += 1; c[1] += r['size'] / 1048576; c[2] += r['fresh'] / MB; c[3] += r['newly'] / MB; c[4] += r['empty'] / MB; c[5] += r['inf'] / MB
n = int(sys.argv[2]) if len(sys.argv) > 2 else 30
print(f"\n{'after':<16} {'n':>3} {'pushed':>7} {'fresh':>6} {'newly':>6} {'empty':>6} {'inform':>6}  caller")
for (stage, name), c in sorted(by.items(), key=lambda kv: -kv[1][4])[:n]:
    print(f"{stage:<16} {c[0]:>3} {c[1]:>7.1f} {c[2]:>6.1f} {c[3]:>6.1f} {c[4]:>6.1f} {c[5]:>6.1f}  {name}")
