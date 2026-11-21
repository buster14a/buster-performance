#!/usr/bin/env python3
# xs-table.py DIRECTORY SUFFIX RUNS [JSON]: a summary node's side facts on the window, by the shadow's switch: the
# readings of job-xs.sh (DIRECTORY/{on1,off1,off2,on2}-<corpus>SUFFIX-N.txt), each reading's two runs with the facts
# against its two without, in one executable. A median over the readings and their least and most; and, with JSON, the
# same numbers as a file for the write-ups' generators.
# A timed region reads the timer's own cost too (27 ticks a chunk here): the sweep's ticks are those with the facts
# less those of the same region without them, which holds the two timer reads alone.
import json, re, statistics, sys
directory, suffix, runs = sys.argv[1], sys.argv[2], int(sys.argv[3])
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
    r['differences'] = number(text, r'window rows expressions=.* differences=(\d+) not-kept')
    r['again'] = number(text, r'window rows expressions=.* second-runs-that-differ=(\d+)')
    tests = parts(text, r'node-shadow: window tests ticks=\d+', ["the records' bytes", 'the loop', "an expression's part", "the tests on T's records"])
    r['tests_bytes'], r['tests_loop'], r['tests_rest'] = tests["the records' bytes"], tests['the loop'], tests["an expression's part"] + tests["the tests on T's records"]
    names = ['the loop', 'the targets', "an expression's part"]
    c1 = parts(text, r'node-shadow: window contexts ticks=\d+', names)
    c2 = parts(text, r'node-shadow: window contexts a second run over the same chunk, not counted: ticks=\d+', names)
    r['c_first'], r['c_second'] = sum(c1.values()), sum(c2.values())
    names = ['the reads', 'the shapes', 'the updates and the branches', 'the rows', 'the values', "an expression's part"]
    x1 = parts(text, r'node-shadow: window rows ticks=\d+', names)
    x2 = parts(text, r'node-shadow: window rows a second run over the same chunk, not counted: ticks=\d+', names)
    r['x_first'], r['x_second'] = sum(x1.values()), sum(x2.values())
    r['x_turns_second'] = x2['the updates and the branches']
    r['s_first'] = number(text, r'node-shadow: window summaries ticks=(\d+)')
    r['s_second'] = number(text, r'window summaries ticks=.* not counted: ticks=(\d+)')
    r['kernel'] = number(text, r'the kernel in place: to-make=.* ticks=(\d+)')
    r['kept'] = number(text, r'window summaries compared=(\d+)')
    r['kept_references'] = number(text, r'window summaries expressions=\d+ their-references=(\d+)')
    r['program_references'] = number(text, r"the program's references=(\d+)")
    r['listed_references'] = number(text, r'records listed for a reference=(\d+)')
    r['suspects'] = number(text, r'calls asked a record at a time=(\d+)')
    r['reduced'] = number(text, r'expressions reduced=(\d+)')
    r['unknown'] = number(text, r'with-an-unknown=(\d+)')
    r['stop'] = number(text, r'with-a-stop=(\d+)')
    r['decided'] = number(text, r'second operand whose truth is known=(\d+)')
    r['conditions'] = number(text, r"conditions' truths asked=(\d+)")
    r['truths'] = number(text, r'a truth known=(\d+)')
    r['folds'] = number(text, r'a constant folded=(\d+)')
    r['summary_differences'] = sum(number(text, p) for p in (r'reference-differences=(\d+)', r'fact-differences=(\d+)', r'truth-differences=(\d+)', r'fold-differences=(\d+)'))
    r['summary_again'] = number(text, r'window summaries expressions=.* second-runs-that-differ=(\d+)')
    return r
def stat(values):
    return dict(median=statistics.median(values), low=min(values), high=max(values))
out = {}
for corpus, _ in corpora:
    readings = [{tag: read('%s/%s-%s%s-%d.txt' % (directory, tag, corpus, suffix, n)) for tag in ('on1', 'off1', 'off2', 'on2')} for n in range(1, runs + 1)]
    first = readings[0]['on1']
    swept, chunks = first['swept'], first['chunks']
    for r in readings:
        for tag, x in r.items():
            assert x['swept'] == swept and x['chunks'] == chunks and x['taken'] == first['taken'], (corpus, tag)
            assert x['differences'] == 0 and x['again'] == 0 and x['summary_differences'] == 0 and x['summary_again'] == 0, (corpus, tag)
            assert (x['kept'] == 0) == tag.startswith('off'), (corpus, tag)
            assert x['decided'] == first['decided'], (corpus, tag)
    def on(key): return [(r['on1'][key] + r['on2'][key]) / 2 for r in readings]
    def off(key): return [(r['off1'][key] + r['off2'][key]) / 2 for r in readings]
    def more(key): return [a - b for a, b in zip(on(key), off(key))]
    def per(values, by): return stat([v / by for v in values])
    t = dict(swept=swept, chunks=chunks, a_chunk=swept / chunks, runs=runs)
    for key in ('taken', 'kept', 'kept_references', 'program_references', 'listed_references', 'suspects', 'reduced', 'unknown', 'stop', 'decided', 'conditions', 'truths', 'folds'):
        t[key] = first[key]
    t['timer'] = per(off('s_second'), chunks)
    t['sweep_second'] = per(more('s_second'), swept)
    t['sweep_first'] = per(more('s_first'), swept)
    t['sweep_second_chunk'] = per(more('s_second'), chunks)
    t['sweep_first_chunk'] = per(more('s_first'), chunks)
    t['sweep_cold'] = per([a - b for a, b in zip(more('s_first'), more('s_second'))], chunks)
    t['bytes'] = per(more('tests_bytes'), swept)
    t['loop'] = per(more('tests_loop'), swept)
    t['tests_two'] = per([a + b for a, b in zip(more('tests_bytes'), more('tests_loop'))], swept)
    t['tests_two_chunk'] = per([a + b for a, b in zip(more('tests_bytes'), more('tests_loop'))], chunks)
    t['together_second'] = per([a + b + c for a, b, c in zip(more('s_second'), more('tests_bytes'), more('tests_loop'))], swept)
    t['together_first'] = per([a + b + c for a, b, c in zip(more('s_first'), more('tests_bytes'), more('tests_loop'))], swept)
    t['rows_second'] = per(more('x_second'), swept)
    t['rows_first'] = per(more('x_first'), swept)
    t['rows_cold'] = per([(a1 - a2) - (b1 - b2) for a1, a2, b1, b2 in zip(on('x_first'), on('x_second'), off('x_first'), off('x_second'))], chunks)
    t['turns_second'] = per(more('x_turns_second'), swept)
    t['rows_all_second'] = per([a + b for a, b in zip(more('x_second'), more('s_second'))], swept)
    t['rows_all_first'] = per([a + b for a, b in zip(more('x_first'), more('s_first'))], swept)
    t['rows_all_cold'] = per([(a + b) - (c + d) for a, b, c, d in zip(more('x_first'), more('s_first'), more('x_second'), more('s_second'))], chunks)
    t['c_second'] = per(more('c_second'), swept)
    t['c_cold'] = per([(a1 - a2) - (b1 - b2) for a1, a2, b1, b2 in zip(on('c_first'), on('c_second'), off('c_first'), off('c_second'))], chunks)
    t['kernel'] = per(more('kernel'), swept)
    t['tests_rest'] = per(more('tests_rest'), swept)
    t['rows_off_first'] = per(off('x_first'), swept)
    t['rows_off_second'] = per(off('x_second'), swept)
    out[corpus] = t
def signed(s, digits=2):
    return '%+.*f (%+.*f to %+.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
def plain(s, digits=2):
    return '%.*f (%.*f to %.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
lines = [
    ('records swept; chunks; records a chunk', lambda t: '%s; %s; %.0f' % (format(t['swept'], ','), format(t['chunks'], ','), t['a_chunk'])),
    ("expressions whose facts are kept; their references; the program's (a set an expression)", lambda t: '%s; %s; %s' % (format(t['kept'], ','), format(t['kept_references'], ','), format(t['program_references'], ','))),
    ('of them with an unknown for a return fact; with a stop', lambda t: '%s; %s' % (format(t['unknown'], ','), format(t['stop'], ','))),
    ("records listed for a reference; calls asked a record at a time; expressions reduced", lambda t: '%s; %s; %s' % (format(t['listed_references'], ','), format(t['suspects'], ','), format(t['reduced'], ','))),
    ("**the sweep, a record swept, a chunk's second run**", lambda t: '**' + plain(t['sweep_second']) + '**'),
    ('the sweep, a record swept, a first run', lambda t: plain(t['sweep_first'])),
    ("the tests' records' bytes, a record swept, more with the facts (their one run)", lambda t: signed(t['bytes'])),
    ("the tests' loop, more (its one run)", lambda t: signed(t['loop'])),
    ("**the three together, the sweep by its second run**", lambda t: '**' + signed(t['together_second']) + '**'),
    ('the three together, the sweep by its first run', lambda t: signed(t['together_first'])),
    ("**the sweep, a first run less a second, ticks a chunk**", lambda t: '**' + plain(t['sweep_cold'], 0) + '**'),
    ("the sweep, ticks a chunk: a first run; a second", lambda t: '%s; %s' % (plain(t['sweep_first_chunk'], 0), plain(t['sweep_second_chunk'], 0))),
    ("the tests' bytes and loop, ticks a chunk, more", lambda t: signed(t['tests_two_chunk'], 0)),
    ("**the rows' sweeps, the facts' among them, a record swept, a second run, more**", lambda t: '**' + signed(t['rows_all_second']) + '**'),
    ("**the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more**", lambda t: '**' + signed(t['rows_all_cold'], 0) + '**'),
    ("the rows' other sweeps, a second run, more", lambda t: signed(t['rows_second'])),
    ("of them the turns' lists and loops, where the listing is", lambda t: signed(t['turns_second'])),
    ("the rows' other sweeps, a first run less a second, ticks a chunk, more", lambda t: signed(t['rows_cold'], 0)),
    ("C's sweeps, a second run, more; a first run less a second, ticks a chunk, more", lambda t: '%s; %s' % (signed(t['c_second']), signed(t['c_cold'], 0))),
    ('the kernel in place, more', lambda t: signed(t['kernel'])),
    ("the tests' other parts, more", lambda t: signed(t['tests_rest'])),
    ("the rows' sweeps without the facts, a record swept: a first run; a second", lambda t: '%s; %s' % (plain(t['rows_off_first']), plain(t['rows_off_second']))),
    ("the timed region with no sweep in it, ticks a chunk", lambda t: plain(t['timer'], 1)),
]
print('| | ' + ' | '.join(name for _, name in corpora) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in corpora) + ' |')
for name, make in lines:
    print('| ' + name + ' | ' + ' | '.join(make(out[corpus]) for corpus, _ in corpora) + ' |')
if len(sys.argv) > 4:
    json.dump(out, open(sys.argv[4], 'w'), indent=1)
