import statistics as st, collections, sys
fn = sys.argv[1]
ref = sys.argv[2] if len(sys.argv) > 2 else 'main'
rows = collections.defaultdict(list)
order = []
for line in open(fn):
    p = line.split()
    d = {k: float(v) for k, v in (x.split('=') for x in p[3:])}
    rows[(int(p[0]), p[2])].append(d)
    if p[2] not in order:
        order.append(p[2])
shifts = sorted(set(s for s, _ in rows))
S = 'ls_bad_status2.stli_other'
print('shift build  n  task-clock(ms) median  vs %s   cycles(M) median  vs %s   instr(M)  STLI(M) median' % (ref, ref))
allr = collections.defaultdict(list)
for s in shifts:
    rt = st.median(d['task-clock'] for d in rows[(s, ref)])
    rc = st.median(d['cycles'] for d in rows[(s, ref)])
    for b in order:
        r = rows[(s, b)]
        t = st.median(d['task-clock'] for d in r)
        c = st.median(d['cycles'] for d in r)
        i = st.median(d['instructions'] for d in r)
        x = st.median(d.get(S, 0) for d in r)
        allr[b].append(c / rc - 1)
        print('%5d %-6s %2d  %8.2f  %+6.2f%%   %8.1f  %+6.2f%%   %8.1f  %6.2f' % (s, b, len(r), t, (t / rt - 1) * 100, c / 1e6, (c / rc - 1) * 100, i / 1e6, x / 1e6))
print('median over shifts of cycles vs %s:' % ref, ' '.join('%s %+.2f%%' % (b, st.median(allr[b]) * 100) for b in order))
