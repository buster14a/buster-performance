#!/usr/bin/env python3
# xse2-table.py DIRECTORY SUFFIX RUNS [JSON]: the second experiment build's readings (job-xse2.sh, settings 0, 2, 4 and
# 0 again): the side facts' sweep's ticks a record swept with the objects by a loop of a load and a store a reference
# (the mean of a reading's two runs), by a gather of eight quadwords, and by a gather of sixteen doublewords, in one
# executable; a chunk's second run and its first. A median over the readings and their least and most, a form less the
# loop a reading at a time.
import json, re, statistics, sys
directory, suffix, runs = sys.argv[1], sys.argv[2], int(sys.argv[3])
corpora = [('sqlite3', '`sqlite3.c`'), ('lua', 'Lua'), ('musl', 'musl')]
def number(text, pattern):
    m = re.search(pattern, text)
    if m is None:
        raise SystemExit('no ' + pattern)
    return int(m.group(1))
def read(path):
    text = open(path).read()
    return dict(swept=number(text, r'window rows expressions=.* records-swept=(\d+)'), chunks=number(text, r'window tests expressions=.* chunks=(\d+)'),
                first=number(text, r'node-shadow: window summaries ticks=(\d+)'), second=number(text, r'window summaries ticks=.* not counted: ticks=(\d+)'),
                references=number(text, r'records listed for a reference=(\d+)'), status=number(text, r'status (\d)\n'))
def stat(values): return dict(median=statistics.median(values), low=min(values), high=max(values))
out = {}
for corpus, _ in corpora:
    readings = [{s: read('%s/e%s-%s%s-%d.txt' % (directory, s, corpus, suffix, n)) for s in ('0', '2', '4', '0b')} for n in range(1, runs + 1)]
    swept, chunks = readings[0]['0']['swept'], readings[0]['0']['chunks']
    assert all(x['status'] == 0 and x['swept'] == swept for r in readings for x in r.values()), corpus
    t = dict(swept=swept, chunks=chunks, runs=runs, references=readings[0]['0']['references'], references_a_chunk=readings[0]['0']['references'] / chunks)
    for run in ('second', 'first'):
        base = [(r['0'][run] + r['0b'][run]) / 2 for r in readings]
        t['loop_' + run] = stat([b / swept for b in base])
        t['same_twice_' + run] = stat([(r['0b'][run] - r['0'][run]) / swept for r in readings])
        for s, name in (('2', 'eight'), ('4', 'sixteen')):
            t[name + '_more_' + run] = stat([(r[s][run] - b) / swept for r, b in zip(readings, base)])
            t[name + '_more_chunk_' + run] = stat([(r[s][run] - b) / chunks for r, b in zip(readings, base)])
    out[corpus] = t
def plain(s, digits=2): return '%.*f (%.*f to %.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
def signed(s, digits=2): return '%+.*f (%+.*f to %+.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
lines = [
    ('records listed for a reference; a chunk', lambda t: '%s; %.1f' % (format(t['references'], ','), t['references_a_chunk'])),
    ("the sweep with the loop, a record swept, a chunk's second run (a region's two timer reads in it)", lambda t: plain(t['loop_second'])),
    ('the same executable and setting twice in a reading, the second less the first', lambda t: signed(t['same_twice_second'])),
    ('**with a gather of eight quadwords, more**', lambda t: '**' + signed(t['eight_more_second']) + '**'),
    ('with a gather of sixteen doublewords, more', lambda t: signed(t['sixteen_more_second'])),
    ('a first run: with the loop', lambda t: plain(t['loop_first'])),
    ('**a first run: with a gather of eight, more**', lambda t: '**' + signed(t['eight_more_first']) + '**'),
    ('a first run: with a gather of sixteen, more', lambda t: signed(t['sixteen_more_first'])),
]
print('| | ' + ' | '.join(name for _, name in corpora) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in corpora) + ' |')
for name, make in lines:
    print('| ' + name + ' | ' + ' | '.join(make(out[c]) for c, _ in corpora) + ' |')
if len(sys.argv) > 4:
    json.dump(out, open(sys.argv[4], 'w'), indent=1)
