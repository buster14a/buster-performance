#!/usr/bin/env python3
# xh-table.py BEFORE_DIR AFTER_DIR SUFFIX RUNS [JSON]: the tests' holes and the objects' side on the 9700X: the readings
# of job-xh.sh (BEFORE_DIR/{before1,before2}-<corpus>SUFFIX-N.txt, AFTER_DIR/{after1,after2}-<corpus>SUFFIX-N.txt), each
# reading's two runs of the build after against its two of the build before. A median over the readings and their
# least and most; and, with JSON, the same numbers as a file for the write-ups' generators.
import json, re, statistics, sys
before_dir, after_dir, suffix, runs = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
corpora = [('sqlite3', '`sqlite3.c`'), ('lua', 'Lua'), ('musl', 'musl')]
def number(text, pattern, cast=int):
    m = re.search(pattern, text)
    if m is None:
        raise SystemExit('no ' + pattern)
    return cast(m.group(1))
def parts(text, line, names):
    m = re.search(line, text)
    if m is None:
        raise SystemExit('no line ' + line)
    rest = text[m.end():text.index('\n', m.end())]
    return {name: number(rest, re.escape(name) + r'=(\d+)') for name in names}
def read(path):
    text = open(path).read()
    if not re.search(r'^status 0$', text, re.M):
        raise SystemExit(path + ': no status 0')
    r = {}
    r['swept'] = number(text, r'window rows expressions=.* records-swept=(\d+)')
    r['chunks'] = number(text, r'window tests expressions=.* chunks=(\d+)')
    r['taken'] = number(text, r'window rows expressions=\d+ records=\d+ taken=(\d+)')
    r['tests_taken'] = number(text, r'reader-time tests compared=\d+ never-lowered=\d+ taken-there=(\d+)')
    r['t_taken'] = number(text, r'reader-time T expressions=\d+ records=\d+ typed=\d+ taken=(\d+)')
    r['differences'] = number(text, r'window rows expressions=.* differences=(\d+) not-kept')
    tests = parts(text, r'node-shadow: window tests ticks=\d+', ["the records' bytes", 'the loop', "an expression's part", "the tests on T's records"])
    r['tests_bytes'], r['tests_loop'], r['tests_rest'] = tests["the records' bytes"], tests['the loop'], tests["an expression's part"] + tests["the tests on T's records"]
    names = ['the loop', 'the targets', "an expression's part"]
    c2 = parts(text, r'node-shadow: window contexts a second run over the same chunk, not counted: ticks=\d+', names)
    r['c_second'] = sum(c2.values())
    names = ['the reads', 'the shapes', 'the updates and the branches', 'the rows', 'the values', "an expression's part"]
    x2 = parts(text, r'node-shadow: window rows a second run over the same chunk, not counted: ticks=\d+', names)
    r['x_second'] = sum(x2.values())
    r['kernel'] = number(text, r'the kernel in place: to-make=.* ticks=(\d+)')
    r['kernel_made'] = number(text, r'the kernel in place: to-make=\d+ made=(\d+)')
    r['inputs_again'] = number(text, r"inputs from the front's records: .* again-ticks=(\d+)")
    r['inputs_records'] = number(text, r"inputs from the front's records: .* again-ticks=\d+ \([0-9.]+ a record of (\d+)\)")
    r['names'] = number(text, r"the names' pass: names=(\d+)")
    r['names_rest'] = number(text, r"the names' pass: names=\d+ ticks=\d+, of which the declarations' lines it made=\d+ \(\d+ lines\); the rest=(\d+)")
    r['lines'] = number(text, r"declarations'-lines=(\d+)")
    r['lines_again'] = number(text, r"declarations'-lines=\d+ \([^;]*; (\d+) made again")
    m = re.search(r"pointers'-ordered-comparisons-left-out=(\d+)", text)
    r['orders'] = int(m.group(1)) if m else 0
    return r
def stat(values):
    return dict(median=statistics.median(values), low=min(values), high=max(values))
out = {}
for corpus, _ in corpora:
    readings = []
    for n in range(1, runs + 1):
        reading = {}
        for tag in ('before1', 'before2'):
            reading[tag] = read('%s/%s-%s%s-%d.txt' % (before_dir, tag, corpus, suffix, n))
        for tag in ('after1', 'after2'):
            reading[tag] = read('%s/%s-%s%s-%d.txt' % (after_dir, tag, corpus, suffix, n))
        readings.append(reading)
    first = readings[0]['before1']
    swept, chunks = first['swept'], first['chunks']
    for r in readings:
        for tag, x in r.items():
            assert x['swept'] == swept and x['chunks'] == chunks, (corpus, tag)
            assert x['taken'] == first['taken'] and x['tests_taken'] == first['tests_taken'] and x['t_taken'] == first['t_taken'], (corpus, tag)
            assert x['differences'] == 0, (corpus, tag)
    def after(key): return [(r['after1'][key] + r['after2'][key]) / 2 for r in readings]
    def before(key): return [(r['before1'][key] + r['before2'][key]) / 2 for r in readings]
    def more(key): return [a - b for a, b in zip(after(key), before(key))]
    def again(key): return [r['before2'][key] - r['before1'][key] for r in readings]
    def per(values, by): return stat([v / by for v in values])
    t = dict(swept=swept, chunks=chunks, a_chunk=swept / chunks, runs=runs, taken=first['taken'], tests_taken=first['tests_taken'], t_taken=first['t_taken'],
             orders=readings[0]['after1']['orders'], names=first['names'], kernel_made=first['kernel_made'], inputs_records=first['inputs_records'],
             lines_before=first['lines'], lines_after=readings[0]['after1']['lines'], lines_again=readings[0]['after1']['lines_again'])
    for key, by in (('tests_loop', swept), ('tests_bytes', swept), ('tests_rest', swept), ('c_second', swept), ('x_second', swept), ('kernel', first['kernel_made']),
                    ('inputs_again', first['inputs_records']), ('names_rest', first['names'])):
        t[key + '_before'] = per(before(key), by)
        t[key + '_after'] = per(after(key), by)
        t[key] = per(more(key), by)
        t[key + '_same'] = per(again(key), by)
    for key in ('tests_loop', 'tests_bytes'):
        t[key + '_chunk'] = per(more(key), chunks)
    out[corpus] = t
def cell(s, digits=2, sign=False):
    f = '%+.*f' if sign else '%.*f'
    return (f + ' (' + f + ' to ' + f + ')') % (digits, s['median'], digits, s['low'], digits, s['high'])
rows = [
    ('records swept; a chunk', lambda t: '{:,}; {:.0f}'.format(t['swept'], t['a_chunk'])),
    ("pointers' ordered comparisons the loop leaves out", lambda t: '{:,}'.format(t['orders'])),
    ("the tests' loop, a record swept: before", lambda t: cell(t['tests_loop_before'])),
    ("**the tests' loop, more**", lambda t: '**' + cell(t['tests_loop'], 2, True) + '**'),
    ("the build before against itself, its second run less its first", lambda t: cell(t['tests_loop_same'], 2, True)),
    ("the tests' loop, ticks a chunk, more", lambda t: cell(t['tests_loop_chunk'], 0, True)),
    ("the records' bytes' sweep, a record swept, more", lambda t: cell(t['tests_bytes'], 2, True)),
    ("the tests' other parts, more", lambda t: cell(t['tests_rest'], 2, True)),
    ("the names' pass less the lines it makes, a name: before", lambda t: cell(t['names_rest_before'])),
    ("**the names' pass, more**", lambda t: '**' + cell(t['names_rest'], 2, True) + '**'),
    ("the front's inputs made again, a record: before; more", lambda t: cell(t['inputs_again_before']) + '; ' + cell(t['inputs_again'], 2, True)),
    ("the kernel in place, a record made: before; more", lambda t: cell(t['kernel_before']) + '; ' + cell(t['kernel'], 2, True)),
    ("C's sweeps' second run, a record swept, more", lambda t: cell(t['c_second'], 2, True)),
    ("the rows' sweeps' second run, a record swept, more", lambda t: cell(t['x_second'], 2, True)),
]
print('| | ' + ' | '.join(name for _, name in corpora) + ' |')
print('| --- |' + ' ---: |' * len(corpora))
for label, f in rows:
    print('| ' + label + ' | ' + ' | '.join(f(out[c]) for c, _ in corpora) + ' |')
if len(sys.argv) > 5:
    json.dump(out, open(sys.argv[5], 'w'), indent=1, sort_keys=True)
