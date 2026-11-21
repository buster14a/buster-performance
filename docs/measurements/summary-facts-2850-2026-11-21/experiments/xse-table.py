#!/usr/bin/env python3
# xse-table.py DIRECTORY SUFFIX RUNS [JSON]: the experiment build's readings (job-xse.sh): the side facts' sweep's ticks
# a record swept on a chunk's second run and on its first, with each setting of the experiment's switch in one
# executable: as it is (the mean of a reading's two runs), with no objects' loop, with the objects by a gather of
# eight, and with no call asked. A median over the readings and their least and most; a setting less the sweep as it
# is, a reading at a time.
import json, re, statistics, sys
directory, suffix, runs = sys.argv[1], sys.argv[2], int(sys.argv[3])
corpora = [('sqlite3', '`sqlite3.c`'), ('lua', 'Lua')]
def number(text, pattern):
    m = re.search(pattern, text)
    if m is None:
        raise SystemExit('no ' + pattern)
    return int(m.group(1))
def read(path):
    text = open(path).read()
    if not re.search(r'^status [01]$', text, re.M):
        raise SystemExit(path + ': no status')
    return dict(swept=number(text, r'window rows expressions=.* records-swept=(\d+)'), first=number(text, r'node-shadow: window summaries ticks=(\d+)'),
                second=number(text, r'window summaries ticks=.* not counted: ticks=(\d+)'), references=number(text, r'records listed for a reference=(\d+)'),
                suspects=number(text, r'calls asked a record at a time=(\d+)'), status=number(text, r'^status (\d)$' if False else r'status (\d)\n'))
def stat(values): return dict(median=statistics.median(values), low=min(values), high=max(values))
out = {}
for corpus, _ in corpora:
    readings = [{s: read('%s/e%s-%s%s-%d.txt' % (directory, s, corpus, suffix, n)) for s in ('0', '1', '2', '3', '0b')} for n in range(1, runs + 1)]
    swept = readings[0]['0']['swept']
    t = dict(swept=swept, runs=runs, references=readings[0]['0']['references'], suspects=readings[0]['0']['suspects'])
    for r in readings:
        assert r['0']['status'] == 0 and r['0b']['status'] == 0 and r['2']['status'] == 0, corpus
        assert all(x['swept'] == swept for x in r.values()), corpus
    for run in ('second', 'first'):
        base = [(r['0'][run] + r['0b'][run]) / 2 for r in readings]
        t['as_it_is_' + run] = stat([b / swept for b in base])
        t['same_twice_' + run] = stat([(r['0b'][run] - r['0'][run]) / swept for r in readings])
        for s, name in (('1', 'no_objects'), ('2', 'gather'), ('3', 'no_calls')):
            t[name + '_' + run] = stat([r[s][run] / swept for r in readings])
            t[name + '_more_' + run] = stat([(r[s][run] - b) / swept for r, b in zip(readings, base)])
    out[corpus] = t
def plain(s, digits=2): return '%.*f (%.*f to %.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
def signed(s, digits=2): return '%+.*f (%+.*f to %+.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
lines = [
    ('records swept; records listed for a reference; calls asked', lambda t: '%s; %s; %s' % (format(t['swept'], ','), format(t['references'], ','), format(t['suspects'], ','))),
    ("the sweep as it is, a record swept, a chunk's second run (a region's two timer reads in it)", lambda t: plain(t['as_it_is_second'])),
    ('the same executable and setting twice in a reading, the second less the first', lambda t: signed(t['same_twice_second'])),
    ("**with no objects' loop, more**", lambda t: '**' + signed(t['no_objects_more_second']) + '**'),
    ('**with the objects by a gather of eight, more**', lambda t: '**' + signed(t['gather_more_second']) + '**'),
    ('with no call asked, more', lambda t: signed(t['no_calls_more_second'])),
    ("a first run: with no objects' loop, more; with the gather, more; with no call asked, more", lambda t: '%s; %s; %s' % (signed(t['no_objects_more_first']), signed(t['gather_more_first']), signed(t['no_calls_more_first']))),
]
print('| | ' + ' | '.join(name for _, name in corpora) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in corpora) + ' |')
for name, make in lines:
    print('| ' + name + ' | ' + ' | '.join(make(out[c]) for c, _ in corpora) + ' |')
if len(sys.argv) > 4:
    json.dump(out, open(sys.argv[4], 'w'), indent=1)
