import os, json, re, datetime, collections, statistics

D = os.environ.get('QUEUE_DATA', '.') + '/'

def ts(s):
    return datetime.datetime.fromisoformat(s.replace('Z', '+00:00')).timestamp() if s else None

main = set(open(D + 'main.txt').read().split())
OUT0 = ts('2026-11-13T22:20:00Z')   # libc6 404 outage: prepare-hosted-tools failed on every cache miss
OUT1 = ts('2026-11-14T02:50:00Z')
agg = collections.defaultdict(lambda: [0, 0.0])
fails = []
after_fail_rm = 0.0
for line in open(D + 'runs.tsv'):
    rid, concl, st, up, sha, br, att = line.rstrip('\n').split('\t')
    jobs = []
    try:
        for p in (1, 2):
            jobs += json.load(open(D + 'jobs/%s-%d.json' % (rid, p)))['jobs']
    except Exception:
        continue
    t0 = min(ts(j['created_at']) for j in jobs)
    run = [j for j in jobs if j['conclusion'] != 'skipped' and j['started_at'] and j['completed_at']]
    rm = sum(ts(j['completed_at']) - ts(j['started_at']) for j in run) / 60
    end = max(ts(j['completed_at']) for j in run)
    fate = 'merged' if sha in main else concl
    period = 'outage' if OUT0 <= t0 <= OUT1 else 'normal'
    agg[(period, fate)][0] += 1
    agg[(period, fate)][1] += rm
    if concl == 'failure':
        bad = [j for j in run if j['conclusion'] in ('failure', 'timed_out')
               and not re.search(r'Integration qualification|Coverage record|verdict', j['name'])]
        if bad:
            first = min(bad, key=lambda j: ts(j['completed_at']))
            tf = ts(first['completed_at'])
            # runner time spent by jobs after the first failure was known
            after = sum(max(0, ts(j['completed_at']) - max(ts(j['started_at']), tf)) for j in run) / 60
            after_fail_rm += after
            fails.append((period, rid, (tf - t0) / 60, (end - t0) / 60, after, first['name'][:90]))
tot = sum(v[1] for v in agg.values())
print('total runner-min %.0f (%.1f runner-hours) over %d runs' % (tot, tot / 60, sum(v[0] for v in agg.values())))
for k in sorted(agg):
    n, rm = agg[k]
    print('  %-7s %-10s n=%3d runner-min %7.0f (%4.1f%%) per run %5.0f' % (k[0], k[1], n, rm, 100 * rm / tot, rm / n))
print('\nfailed candidates: first failing job end vs run end (min), runner-min after first failure')
for f in sorted(fails, key=lambda f: f[1]):
    print('  %-6s %s first-fail %5.1f  run-end %5.1f  after %5.0f  %s' % f)
print('runner-min spent after a failure was already known: %.0f' % after_fail_rm)
