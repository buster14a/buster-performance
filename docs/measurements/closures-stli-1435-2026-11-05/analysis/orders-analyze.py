import statistics as st, collections, sys, math
rows = collections.defaultdict(list)
builds = []
for line in open(sys.argv[1]):
    p = line.split()
    d = {k: float(v) for k, v in (x.split('=') for x in p[3:])}
    rows[(int(p[0]), p[2])].append(d['cycles'])
    if p[2] not in builds:
        builds.append(p[2])
orders = sorted(set(o for o, _ in rows))
med = {(o, b): st.median(rows[(o, b)]) for o in orders for b in builds}
print('orders', len(orders), 'rounds', len(rows[(orders[0], builds[0])]))
for b in builds:
    v = [med[(o, b)] / 1e6 for o in orders]
    print('%-6s cycles(M) per order: median %.1f mean %.1f sd %.1f min %.1f max %.1f' % (b, st.median(v), st.mean(v), st.stdev(v), min(v), max(v)))
noise = st.median(st.stdev(rows[k]) / st.mean(rows[k]) * 100 for k in rows)
print('run-to-run sd within a layout: median %.2f%%' % noise)
for b in builds:
    if b == 'main':
        continue
    r = [math.log(med[(o, b)] / med[(o, 'main')]) * 100 for o in orders]
    m = st.mean(r)
    se = st.stdev(r) / math.sqrt(len(r))
    print('%s / main: mean %+.2f%% (se %.2f, 95%% ci %+.2f..%+.2f), median %+.2f%%, sd %.2f%%, slower at %d/%d, range %+.1f..%+.1f%%' % (b, m, se, m - 1.96 * se, m + 1.96 * se, st.median(r), st.stdev(r), sum(x > 0 for x in r), len(r), min(r), max(r)))
r = [math.log(med[(o, 'pad0')] / med[(o, 'pad0w')]) * 100 for o in orders]
print('pad0 / pad0w: mean %+.2f%% se %.2f median %+.2f%% slower at %d/%d' % (st.mean(r), st.stdev(r) / math.sqrt(len(r)), st.median(r), sum(x > 0 for x in r), len(r)))
print('order 0 (usual):', ' '.join('%s=%.1f' % (b, med[(0, b)] / 1e6) for b in builds))
print('per order (M):', ' | '.join('%d: ' % o + ' '.join('%.0f' % (med[(o, b)] / 1e6) for b in builds) for o in orders))
