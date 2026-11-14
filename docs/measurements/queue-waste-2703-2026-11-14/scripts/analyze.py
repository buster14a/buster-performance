import os, json, glob, sys, re, collections, datetime, statistics

D = os.environ.get('QUEUE_DATA', '.') + '/'

def ts(s):
    if not s:
        return None
    return datetime.datetime.fromisoformat(s.replace('Z', '+00:00')).timestamp()

main = set(open(D + 'main.txt').read().split())
runs = []
for line in open(D + 'runs.tsv'):
    rid, concl, st, up, sha, br, att = line.rstrip('\n').split('\t')
    jobs = []
    ok = True
    for p in (1, 2):
        f = D + 'jobs/%s-%d.json' % (rid, p)
        try:
            jobs += json.load(open(f))['jobs']
        except Exception:
            ok = False
    if not ok:
        continue
    pr = re.search(r'pr-(\d+)-', br).group(1)
    fate = 'merged' if sha in main else ('failed' if concl == 'failure' else ('cancelled' if concl == 'cancelled' else 'passed-unmerged'))
    runs.append(dict(id=rid, concl=concl, start=ts(st), sha=sha, pr=pr, br=br, jobs=jobs, fate=fate))

def cat(name):
    n = name
    if n.startswith('Tests on Ubuntu'):
        if 'Build the compiler once' in n:
            return 'row-build'
        if 'Vector draw' in n and 'candidate' in n:
            return 'vector-item'
        if 'Vector draw' in n:
            return 'vector-assign'
        if 'verdict' in n:
            return 'vector-verdict'
        if 'shard' in n:
            return 'shard'
        if 'SQLite' in n:
            return 'sqlite'
        return 'test-other'
    if n.startswith('libFuzzer'):
        return 'fuzz'
    if n.startswith('Auxiliary') or '/' in n and n.split(' / ')[0].startswith('Auxiliary'):
        return 'auxiliary'
    if n.startswith('prepare-hosted-tools'):
        return 'prepare'
    return 'preamble/aggregate:' + n

def dur(j):
    a, b = ts(j['started_at']), ts(j['completed_at'])
    if a is None or b is None or j['conclusion'] == 'skipped':
        return 0.0
    return max(0.0, b - a)

summary = collections.defaultdict(lambda: collections.defaultdict(float))
fatecount = collections.Counter()
fate_rm = collections.defaultdict(float)
walls = collections.defaultdict(list)
for r in runs:
    rm = 0.0
    end = r['start']
    for j in r['jobs']:
        d = dur(j)
        rm += d
        c = cat(j['name'])
        if c.startswith('preamble'):
            c = 'preamble/aggregate'
        summary[r['fate']][c] += d
        if j['completed_at']:
            end = max(end, ts(j['completed_at']))
    r['rm'] = rm / 60
    r['wall'] = (end - r['start']) / 60
    fatecount[r['fate']] += 1
    fate_rm[r['fate']] += rm / 60
    walls[r['fate']].append(r['wall'])

tot = sum(fate_rm.values())
print('runs analysed', len(runs))
for f in fatecount:
    w = sorted(walls[f])
    print('%-16s n=%3d runner-min=%8.0f (%4.1f%%) mean/run=%5.0f wall median=%5.1f p90=%5.1f' % (
        f, fatecount[f], fate_rm[f], 100 * fate_rm[f] / tot, fate_rm[f] / fatecount[f], statistics.median(w), w[int(0.9 * (len(w) - 1))]))
print('total runner-min %.0f, runner-hours %.1f' % (tot, tot / 60))
print()
for f in summary:
    s = summary[f]
    t = sum(s.values())
    print(f, ' '.join('%s=%.0f%%' % (k, 100 * v / t) for k, v in sorted(s.items(), key=lambda x: -x[1])))

json.dump([{k: v for k, v in r.items() if k != 'jobs'} for r in runs], open(D + 'runs-summary.json', 'w'))
