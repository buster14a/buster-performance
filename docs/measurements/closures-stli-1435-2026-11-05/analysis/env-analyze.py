import statistics as st, collections, sys
fn = sys.argv[1]
def parse(fn, keyn):
    rows = []
    for line in open(fn):
        p = line.split()
        d = {k: float(v) for k, v in (x.split('=') for x in p[keyn:])}
        rows.append((p[:keyn], d))
    return rows
env = parse(fn, 2)
by = collections.defaultdict(dict)
for (k, c), d in env:
    by[c][int(k)] = d
ks = sorted(set(by['main']) & set(by['head']))
def corr(x, y):
    mx, my = st.mean(x), st.mean(y)
    sx = sum((a - mx) ** 2 for a in x) ** .5
    sy = sum((b - my) ** 2 for b in y) ** .5
    return sum((a - mx) * (b - my) for a, b in zip(x, y)) / sx / sy
S = 'ls_bad_status2.stli_other'
for c in ('main', 'head'):
    cyc = [by[c][k]['cycles'] for k in ks]
    stli = [by[c][k][S] for k in ks]
    print(c, 'cycles median %.1fM min %.1f max %.1f; stli median %.2fM min %.2f max %.2f; corr(cycles,stli)=%.2f' % (st.median(cyc) / 1e6, min(cyc) / 1e6, max(cyc) / 1e6, st.median(stli) / 1e6, min(stli) / 1e6, max(stli) / 1e6, corr(cyc, stli)))
    mx, my = st.mean(stli), st.mean(cyc)
    b = sum((a - mx) * (y - my) for a, y in zip(stli, cyc)) / sum((a - mx) ** 2 for a in stli)
    print('  slope cycles per STLI event: %.1f' % b)
d = [by['head'][k]['cycles'] / by['main'][k]['cycles'] - 1 for k in ks]
print('head/main-1 per k: median %+.2f%% mean %+.2f%%, head slower at %d/%d' % (st.median(d) * 100, st.mean(d) * 100, sum(x > 0 for x in d), len(ks)))
print('k: main_stli head_stli main_cyc head_cyc')
for k in ks[::8]:
    print(k, '%.2f %.2f %.1f %.1f' % (by['main'][k][S] / 1e6, by['head'][k][S] / 1e6, by['main'][k]['cycles'] / 1e6, by['head'][k]['cycles'] / 1e6))
for c in ('main', 'head'):
    hi = [k for k in ks if by[c][k][S] > 3e6]
    print(c, 'k with stli>3M:', len(hi), hi[:80])
# cycles of head when stli low vs high
for c in ('main', 'head'):
    lo = [by[c][k]['cycles'] for k in ks if by[c][k][S] < 2.5e6]
    hi = [by[c][k]['cycles'] for k in ks if by[c][k][S] >= 2.5e6]
    print(c, 'cycles median at stli<2.5M: %.1fM (n=%d); at stli>=2.5M: %.1fM (n=%d)' % (st.median(lo) / 1e6, len(lo), st.median(hi) / 1e6 if hi else 0, len(hi)))
