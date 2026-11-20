#!/usr/bin/env python3
# gen-docs.py RECORD LABEL BASE OUT: the entries' values' piece's two design sections, from their templates
# (node-machine-section.md and one-core-path-section.md beside this script) and the record's files: the census before
# the specification (RECORD/before), the builds' readings and the counters (RECORD/builds/xv-table.txt and
# counters.txt), the final readings (RECORD/final/LABEL-table.txt, by xv-final-table.py), the cloud container's checks
# (RECORD/final/cloud-checks) and the fault rounds (RECORD/faults). Every number in the output is read or computed
# here; values.json keeps them for the other write-ups.
import glob, json, os, re, statistics, subprocess, sys
record, label, base, out = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
here = os.path.dirname(os.path.abspath(__file__))
CORPORA = ('sqlite3', 'lua', 'musl')
NAMES = {'sqlite3': '`sqlite3.c`', 'lua': 'Lua', 'musl': 'musl'}
def n(x):
    return '{:,}'.format(x)
def s(x):
    return '%+.2f' % (0.0 if abs(x) < 0.005 else x)
def three(f, corpora=CORPORA):
    return ' | '.join(f(c) for c in corpora)
values = {'final_label': label, 'base_label': base}

# ---- The census before the specification.
table = open(record + '/before/table.md').read()
def census_row(name):
    m = re.search(r'^\| %s \| (.*) \|$' % re.escape(name), table, re.M)
    assert m, name
    return [c.strip() for c in m.group(1).split('|')]
entries = census_row('their entries; those whose value is not zero')
per = census_row('values that are not zero, a record')
numbered = census_row('**expressions with two or more of an evaluated call, a labeled operator and a postfix update through an address**')
totals = subprocess.run([sys.executable, record + '/before/census-totals.py'], capture_output=True, text=True).stdout
def total(pattern):
    m = re.search(pattern, totals)
    assert m, pattern
    return [int(x) for x in m.groups()]
census_entries, wrong = total(r'entries (\d+) wrong lines (\d+)')
assert wrong == 0
labels, labels_zero = total(r"labels of an operator's own (\d+) zero (\d+)")
calls, calls_zero = total(r"calls' rows (\d+) zero (\d+)")
assert total(r'expressions with two postfix updates through an address (\d+)') == [0]
values['census_entries'] = n(census_entries)
values['census_nonzero'] = ', '.join(re.search(r'\(([\d.]+%)\)', e).group(1) for e in entries[:3]) + ' and ' + re.search(r'\(([\d.]+%)\)', entries[3]).group(1)
values['census_per_record'] = ', '.join(per[:3]) + ' and ' + per[3]
values['census_calls'] = n(calls); values['census_calls_zero'] = n(calls_zero)
values['census_labels'] = n(labels); values['census_labels_zero'] = n(labels_zero)
values['census_numbered'] = "%s of `sqlite3.c`'s, %s of Lua's, %s of musl's and %s of the compiler's own source's" % tuple(numbered)

# ---- The builds.
xv = open(record + '/builds/xv-table.txt').read()
assert 'without status 0: 0' in xv.splitlines()[0], xv.splitlines()[0]
def build(lab, tag, corpus, which, name):
    m = re.search(r'^%s\s+%s\s+%s\s+%s\s+%s\s+([\d.]+) \(([\d.]+) to ([\d.]+)\)$' % (lab, tag, corpus, re.escape(which), re.escape(name)), xv, re.M)
    assert m, (lab, tag, corpus, which, name)
    return tuple(float(x) for x in m.groups())
def build_readings(lab, tag, corpus):
    m = re.search(r'^%s\s+%s\s+%s\s+readings (\d+): .*second-runs-that-differ (\d+) .*values: differ (\S+) ' % (lab, tag, corpus), xv, re.M)
    assert m, (lab, tag, corpus)
    return int(m.group(1)), m.group(2), m.group(3)
BUILDS = (('xv1', 'on', "first: seven lists, each loop reading its records' lines, and a pointer's type's row for its stride; an expression's marked records counted in its part"),
          ('xv2', 'on', "a record's value and a pointer's stride as two columns; the tested values' list from the branches' loop and the updates' from their own; an expression's later marked records by a "
                        "subtraction a block; a member's offset, an update's step and its store's object written under a condition"),
          ('xv3', 'on', "those three written at a place chosen without a branch"),
          ('xv4', 'on', "the stream's start with its sums' ones, by the entries' kinds, and no list for the members; each loop's step in one copy, its columns' addresses loaded once; the numbering's "
                        "expression from a column the reader writes, and its labels' walk over the operators' records alone"),
          ('xv5', 'on', "the fourth's with the columns' and the stream's lines asked for from the rows' write"),
          ('xv6', 'on', "the fifth's with the sweep compiled for size"))
rows = []
for lab, tag, what in BUILDS:
    cells = []
    for c in ('sqlite3', 'lua'):
        r = build_readings(lab, tag, c)
        assert r[1] == '0' and r[2] == '0', (lab, c, r)
        total_first = build(lab, tag, c, 'first run', 'a record swept')
        first = build(lab, tag, c, 'first run', 'the values'); second = build(lab, tag, c, 'second run', 'the values')
        cells.append('%.2f (%.2f to %.2f) | %.2f; %.2f' % (total_first[0], total_first[1], total_first[2], first[0], second[0]))
    rows.append('| %s | %s |' % (what, ' | '.join(cells)))
values['builds_rows'] = rows
values['builds_readings'] = 'two or three'
assert sorted(set(build_readings(lab, tag, c)[0] for lab, tag, _ in BUILDS for c in ('sqlite3', 'lua'))) == [2, 3]
b = {c: build('xb6', 'base', c, 'first run', 'a record swept') for c in ('sqlite3', 'lua')}
values['builds_base_sqlite3'] = '%.2f (%.2f to %.2f)' % b['sqlite3']; values['builds_base_lua'] = '%.2f (%.2f to %.2f)' % b['lua']
# The counters.
counters = {}
for line in open(record + '/builds/counters.txt'):
    f = line.split()
    counters[(f[0], f[1], int(f[2]), f[3], f[4])] = {k: float(v) for k, v in (x.split('=') for x in f[5:])}
def counter(lab, corpus, region, run, key):
    xs = [counters[(lab, corpus, k, region, run)][key] for k in (1, 2)]
    return min(xs), max(xs)
values['counters'] = {'%s %s %s %s %s' % k: v for k, v in counters.items()}
# The functions' sizes (functions.txt: nm -S of each build's executable).
sizes = {}
for line in open(record + '/builds/functions.txt'):
    f = line.split()
    if len(f) == 3:
        sizes.setdefault(f[0], {})[f[1]] = int(f[2])
lines = []
for (lab, tag, what), r in zip(BUILDS, rows):
    lines.append(r + ' %s |' % n(sizes[lab]['node_rows_window_values']))
values['builds_table'] = ("| build | `sqlite3.c`, the rows' sweeps with the values | the values' part: a first run; a second | Lua, the rows' sweeps | the values' part | the values' sweep's code, bytes |\n"
                          "| --- | ---: | ---: | ---: | ---: | ---: |\n" + '\n'.join(lines))
def b3(lab, tag, c, which, name):
    return build(lab, tag, c, which, name)
notes = []
r1 = {c: b3('xv1', 'on', c, 'first run', 'the reads') for c in ('sqlite3', 'lua')}
r2 = {c: b3('xv2', 'on', c, 'first run', 'the reads') for c in ('sqlite3', 'lua')}
r3 = {c: b3('xv3', 'on', c, 'first run', 'the reads') for c in ('sqlite3', 'lua')}
notes.append("- **A value written where its record has one was a branch.** The second build's reads' loop left a member's\n  offset in the record's value's place as `*value = member ? offset : *value`, and the updates' loop wrote an\n"
             "  update's step and its store's object the same way. The compiler made each a store behind a branch on the\n  record's kind, which no predictor learns: the reads read %.2f to %.2f ticks a record swept on `sqlite3.c` where the\n"
             "  first build's read %.2f to %.2f. The third build writes each at a place chosen by arithmetic, the record's own\n  or one past the column's records that no one reads: %.2f to %.2f." % (
                 r2['sqlite3'][1], r2['sqlite3'][2], r1['sqlite3'][1], r1['sqlite3'][2], r3['sqlite3'][1], r3['sqlite3'][2]))
v3 = {c: b3('xv3', 'on', c, 'first run', 'the values') for c in ('sqlite3', 'lua')}; v4 = {c: b3('xv4', 'on', c, 'first run', 'the values') for c in ('sqlite3', 'lua')}
t3 = {c: b3('xv3', 'on', c, 'first run', 'a record swept') for c in ('sqlite3', 'lua')}; t4 = {c: b3('xv4', 'on', c, 'first run', 'a record swept') for c in ('sqlite3', 'lua')}
t1 = {c: b3('xv1', 'on', c, 'first run', 'a record swept') for c in ('sqlite3', 'lua')}
notes.append("- **The two columns and the lists moved read no better by themselves.** The third build's rows' sweeps read %.2f\n  ticks a record swept on `sqlite3.c` for the first's %.2f, and %.2f for %.2f on Lua; its values' part more, %.2f and\n"
             "  %.2f for %.2f and %.2f. Its stream started as zeros, with a list of the members that wrote each one's offset and its\n  sum's 1, and its loops reached each column through the reader's state. The fourth starts the\n"
             "  stream with the sums' ones by the entries' kinds, has a member's offset on the first list, and each loop's step\n  in one copy (`unroll(disable)`): the values' part read %.2f and %.2f, the rows' sweeps %.2f and %.2f, and the\n"
             "  sweep's code is %s bytes for %s. The builds changed more than one thing at a time, and no reading is of the\n  columns alone." % (
                 t3['sqlite3'][0], t1['sqlite3'][0], t3['lua'][0], t1['lua'][0], v3['sqlite3'][0], v3['lua'][0],
                 b3('xv1', 'on', 'sqlite3', 'first run', 'the values')[0], b3('xv1', 'on', 'lua', 'first run', 'the values')[0],
                 v4['sqlite3'][0], v4['lua'][0], t4['sqlite3'][0], t4['lua'][0],
                 n(sizes['xv4']['node_rows_window_values']), n(sizes['xv3']['node_rows_window_values'])))
# A chunk: records and ticks.
def chunk(c):
    m = re.search(r'^xv4\s+on\s+%s\s+readings \d+: .* swept (\d+) ' % c, xv, re.M)
    return int(m.group(1)) / counters[('xv4p', c, 1, 'values', 'first')]['chunks']
for k in list(counters):
    pass
def chunks_of(lab, c):
    t = open(record + '/builds/counters.txt').read()
    m = re.search(r'^%s %s 1 values\s+first\s+chunks=(\d+)' % (lab, c), t, re.M)
    return int(m.group(1))
swept = {c: int(re.search(r'^xv4\s+on\s+%s\s+readings \d+: .* swept (\d+) ' % c, xv, re.M).group(1)) for c in ('sqlite3', 'lua')}
per_chunk = {c: swept[c] / chunks_of('xv4p', c) for c in ('sqlite3', 'lua')}
values['records_a_chunk'] = {c: per_chunk[c] for c in per_chunk}
cy1 = {c: counter('xv4p', c, 'values', 'first', 'cycles') for c in ('sqlite3', 'lua')}; cy2 = {c: counter('xv4p', c, 'values', 'second', 'cycles') for c in ('sqlite3', 'lua')}
ins = {c: counter('xv4p', c, 'values', 'first', 'instructions') for c in ('sqlite3', 'lua')}
bm1 = {c: counter('xv4p', c, 'values', 'first', 'branch-misses') for c in ('sqlite3', 'lua')}; bm2 = {c: counter('xv4p', c, 'values', 'second', 'branch-misses') for c in ('sqlite3', 'lua')}
ic1 = {c: counter('xv4p', c, 'values', 'first', 'L1I-read-misses') for c in ('sqlite3', 'lua')}; ic2 = {c: counter('xv4p', c, 'values', 'second', 'L1I-read-misses') for c in ('sqlite3', 'lua')}
sf1 = {c: counter('xv4p', c, 'values', 'first', 'stalled-frontend') for c in ('sqlite3', 'lua')}; sf2 = {c: counter('xv4p', c, 'values', 'second', 'stalled-frontend') for c in ('sqlite3', 'lua')}
tlb = max(counters[k][key] for k in counters if k[0] == 'xv7p' for key in ('dTLB-read-misses', 'iTLB-read-misses'))
w1 = {c: counter('xv7p', c, "the-rows'-write", 'first', 'cycles') for c in ('sqlite3', 'lua')}; w2 = {c: counter('xv7p', c, "the-rows'-write", 'second', 'cycles') for c in ('sqlite3', 'lua')}
ticks_chunk = {c: v4[c][0] * per_chunk[c] for c in ('sqlite3', 'lua')}
notes.append("- **A chunk's first run pays a cold start, more than work a record.** A build that reads the processor's counters\n  around the sweep (user mode, a chunk's average; `sqlite3.c` has %.0f records a chunk and Lua %.0f): the sweep\n"
             "  executes %s to %s instructions a chunk on `sqlite3.c` and %s to %s on Lua, the same in a chunk's two runs,\n  in %s to %s cycles the first run and %s to %s the second (Lua: %s to %s and %s to %s). The first run has\n"
             "  %.1f to %.1f mispredicted branches a chunk for the second's %.1f to %.1f, %.1f to %.1f instruction-cache misses for\n  %.1f to %.1f, and %s to %s cycles with the front end stalled for %s to %s. No run of either corpus has more than\n"
             "  %.1f TLB misses a chunk, data or instructions. The fourth build's ticks a chunk are nearly the same on the two\n  (%s and %s) though `sqlite3.c`'s chunk has %.0f%% more records. The rows' write, measured the same way,\n"
             "  takes %s to %s cycles a chunk its first run and %s to %s its second on `sqlite3.c`." % (
                 per_chunk['sqlite3'], per_chunk['lua'], n(round(ins['sqlite3'][0])), n(round(ins['sqlite3'][1])), n(round(ins['lua'][0])), n(round(ins['lua'][1])),
                 n(round(cy1['sqlite3'][0])), n(round(cy1['sqlite3'][1])), n(round(cy2['sqlite3'][0])), n(round(cy2['sqlite3'][1])),
                 n(round(cy1['lua'][0])), n(round(cy1['lua'][1])), n(round(cy2['lua'][0])), n(round(cy2['lua'][1])),
                 min(bm1['sqlite3'][0], bm1['lua'][0]), max(bm1['sqlite3'][1], bm1['lua'][1]), min(bm2['sqlite3'][0], bm2['lua'][0]), max(bm2['sqlite3'][1], bm2['lua'][1]),
                 min(ic1['sqlite3'][0], ic1['lua'][0]), max(ic1['sqlite3'][1], ic1['lua'][1]), min(ic2['sqlite3'][0], ic2['lua'][0]), max(ic2['sqlite3'][1], ic2['lua'][1]),
                 n(round(min(sf1['sqlite3'][0], sf1['lua'][0]))), n(round(max(sf1['sqlite3'][1], sf1['lua'][1]))), n(round(min(sf2['sqlite3'][0], sf2['lua'][0]))), n(round(max(sf2['sqlite3'][1], sf2['lua'][1]))),
                 tlb, n(round(ticks_chunk['sqlite3'])), n(round(ticks_chunk['lua'])), 100.0 * (per_chunk['sqlite3'] / per_chunk['lua'] - 1.0),
                 n(round(w1['sqlite3'][0])), n(round(w1['sqlite3'][1])), n(round(w2['sqlite3'][0])), n(round(w2['sqlite3'][1]))))
w4 = {c: b3('xv4', 'on', c, 'first run', 'the rows') for c in ('sqlite3', 'lua')}; w5 = {c: b3('xv5', 'on', c, 'first run', 'the rows') for c in ('sqlite3', 'lua')}
v5 = {c: b3('xv5', 'on', c, 'first run', 'the values') for c in ('sqlite3', 'lua')}; v6 = {c: b3('xv6', 'on', c, 'first run', 'the values') for c in ('sqlite3', 'lua')}
notes.append("- **Two builds that went after the cold start changed nothing.** Asking for the columns' and the stream's lines\n  from the rows' write, the sweep before: the write read %.2f and %.2f for %.2f and %.2f, and the values' part\n"
             "  %.2f and %.2f for %.2f and %.2f. Compiling the sweep for size on top of that (%s bytes for %s): %.2f and %.2f.\n  Neither is in the code." % (
                 w5['sqlite3'][0], w5['lua'][0], w4['sqlite3'][0], w4['lua'][0], v5['sqlite3'][0], v5['lua'][0], v4['sqlite3'][0], v4['lua'][0],
                 n(sizes['xv6']['node_rows_window_values']), n(sizes['xv5']['node_rows_window_values']), v6['sqlite3'][0], v6['lua'][0]))
values['builds_notes'] = '\n'.join(notes)
values['cold_note'] = notes[2]
print(values['builds_table']); print(); print(values['builds_notes'])
# ---- The final readings (xv-final-table.py's output).
T = open('%s/final/%s-table.txt' % (record, label)).read()
assert 'without status 0: 0' in T.splitlines()[0], T.splitlines()[0]
def frow(corpus, name):
    m = re.search(r"^%s\s+%s\s+on\s+([\d.]+) \(([\d.]+) to ([\d.]+)\)\s+off\s+([\d.]+)\s+before\s+([\d.]+)\s+on less off\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)\s+on less before\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)"
                  r"\s+off less before\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)$" % (corpus, re.escape(name)), T, re.M)
    assert m, (corpus, name)
    v = [float(x) for x in m.groups()]
    return dict(on=v[0], lo=v[1], hi=v[2], off=v[3], before=v[4], d=v[5], dlo=v[6], dhi=v[7], e=v[8], elo=v[9], ehi=v[10], f=v[11], flo=v[12], fhi=v[13])
def fcounts(corpus, which):
    m = re.search(r"^%s\s+%s\s+expressions (\d+) taken (\d+) \(([\d.]+)%%\) records (\d+) entries (\d+) differences (\d+) unkept (\d+) second-runs-that-differ (\d+) swept (\d+) written (\d+) chunks (\d+);"
                  r" listed (\d+) (\d+) (\d+) (\d+); values: differ (\d+) on-a-list (\d+) lists (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) numbered (\d+) steps (\d+); the same in every run: (\w+)\s+\[(\d+) readings\]$"
                  % (corpus, which), T, re.M)
    assert m, (corpus, which)
    g = m.groups()
    return dict(expressions=int(g[0]), taken=int(g[1]), share=g[2], records=int(g[3]), entries=int(g[4]), differences=int(g[5]), unkept=int(g[6]), again=int(g[7]), swept=int(g[8]), written=int(g[9]),
                chunks=int(g[10]), listed=[int(x) for x in g[11:15]], valued=int(g[15]), on_a_list=int(g[16]), lists=[int(x) for x in g[17:24]], numbered=int(g[24]), steps=int(g[25]), same=g[26],
                readings=int(g[27]))
on = {c: fcounts(c, 'on') for c in CORPORA}; off = {c: fcounts(c, 'off') for c in CORPORA}; before = {c: fcounts(c, 'before') for c in CORPORA}
for c in CORPORA:
    for x in (on[c], off[c], before[c]):
        assert x['same'] == 'True' and x['differences'] == 0 and x['unkept'] == 0 and x['again'] == 0 and x['valued'] == 0, (c, x)
    # Nothing is listed for a value: the tapes made are the piece before's, and the switch's.
    assert all(on[c][k] == before[c][k] == off[c][k] for k in ('expressions', 'taken', 'entries', 'written', 'listed', 'swept', 'chunks')), c
assert len(set(on[c]['readings'] for c in CORPORA)) == 1
readings = on['sqlite3']['readings']
values['readings'] = {2: 'two', 3: 'three', 5: 'five', 7: 'seven'}[readings]
FNAMES = ("the rows' sweeps, a record swept", 'a record of the taken', 'the reads', 'the shapes', 'the updates and the branches', 'the rows', 'the values', "an expression's part",
          "the reference's X, a record of the taken", '(a second run) a record swept', '(a second run) the reads', '(a second run) the shapes', '(a second run) the updates and the branches',
          '(a second run) the rows', '(a second run) the values', "(a second run) an expression's part", 'the kernel in place, a record', 'the tests on the window, a record', "the records' bytes",
          "the tests' loop", "the tests' expression's part", "the tests on T's records", "C's sweeps, a record swept", "C's loop", "C's targets", "C's expression's part")
R = {c: {name: frow(c, name) for name in FNAMES} for c in CORPORA}
SUM = "the rows' sweeps, a record swept"; LATER = '(a second run) a record swept'; VAL = 'the values'; LVAL = '(a second run) the values'
def cell(name, key='on', fmt='%.2f'):
    return lambda c: fmt % R[c][name][key]
per_chunk_final = {c: on[c]['swept'] / on[c]['chunks'] for c in CORPORA}
m = []
m.append('| expressions C takes on the window | ' + three(lambda c: n(on[c]['expressions'])) + ' |')
m.append('| their tapes made here, whole | ' + three(lambda c: '%s (%s%%)' % (n(on[c]['taken']), on[c]['share'])) + ' |')
m.append("| tapes that differ from X's on T's columns, in a value too | " + three(lambda c: n(on[c]['differences'])) + ' |')
m.append('| listed for a value | ' + three(lambda c: n(before[c]['taken'] - on[c]['taken'])) + ' |')
m.append("| their entries | " + three(lambda c: n(on[c]['entries'])) + ' |')
m.append('| records on a list, a record swept | ' + three(lambda c: '%.3f' % (on[c]['on_a_list'] / on[c]['swept'])) + ' |')
m.append('| expressions numbered | ' + three(lambda c: '%s (%.2f%% of the tapes)' % (n(on[c]['numbered']), 100.0 * on[c]['numbered'] / on[c]['taken'])) + ' |')
m.append("| **the rows' sweeps and the part, a record swept** | " + three(lambda c: '**%.2f (%.2f to %.2f)**' % (R[c][SUM]['on'], R[c][SUM]['lo'], R[c][SUM]['hi'])) + ' |')
m.append("| the piece before's executable, in the same readings | " + three(cell(SUM, 'before')) + ' |')
m.append("| **more than the piece before's** | " + three(lambda c: '**%s (%s to %s)**' % (s(R[c][SUM]['e']), s(R[c][SUM]['elo']), s(R[c][SUM]['ehi']))) + ' |')
m.append('| with the values off; on less off | ' + three(lambda c: '%.2f; %s' % (R[c][SUM]['off'], s(R[c][SUM]['d']))) + ' |')
m.append("| with the values off, more than the piece before's | " + three(lambda c: '%s (%s to %s)' % (s(R[c][SUM]['f']), s(R[c][SUM]['flo']), s(R[c][SUM]['fhi']))) + ' |')
m.append("| the values' part | " + three(cell(VAL)) + ' |')
m.append('| the reads; on less off | ' + three(lambda c: '%.2f; %s' % (R[c]['the reads']['on'], s(R[c]['the reads']['d']))) + ' |')
m.append('| the shapes | ' + three(cell('the shapes')) + ' |')
m.append("| the updates' and the branches' lists and loops; on less off | " + three(lambda c: '%.2f; %s' % (R[c]['the updates and the branches']['on'], s(R[c]['the updates and the branches']['d']))) + ' |')
m.append('| the rows; on less off | ' + three(lambda c: '%.2f; %s' % (R[c]['the rows']['on'], s(R[c]['the rows']['d']))) + ' |')
m.append("| an expression's part | " + three(cell("an expression's part")) + ' |')
m.append("| a second run over the same chunk; the piece before's | " + three(lambda c: '%.2f; %.2f' % (R[c][LATER]['on'], R[c][LATER]['before'])) + ' |')
m.append("| the values' part in it | " + three(cell(LVAL)) + ' |')
m.append("| the values' part, ticks a chunk: a first run; a second | " + three(lambda c: '%s; %s' % (n(round(R[c][VAL]['on'] * per_chunk_final[c])), n(round(R[c][LVAL]['on'] * per_chunk_final[c])))) + ' |')
m.append("| the records' bytes, which make a record's value; on less off | " + three(lambda c: '%.2f; %s' % (R[c]["the records' bytes"]['on'], s(R[c]["the records' bytes"]['d']))) + ' |')
m.append("| C's loop, which keeps a stride; on less off | " + three(lambda c: '%.2f; %s' % (R[c]["C's loop"]['on'], s(R[c]["C's loop"]['d']))) + ' |')
m.append('| a record of the taken expressions | ' + three(cell('a record of the taken')) + ' |')
m.append("| X on T's columns, a record of theirs | " + three(cell("the reference's X, a record of the taken")) + ' |')
m.append('| records a chunk | ' + three(lambda c: '%.0f' % per_chunk_final[c]) + ' |')
values['measured_table'] = '\n'.join(m)
values['short_table'] = '\n'.join([m[0], m[1], m[2], m[3], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[18], m[19], m[21], m[24]])
values['final'] = {c: {name: R[c][name] for name in FNAMES} for c in CORPORA}
values['final_counts'] = {c: on[c] for c in CORPORA}
# ---- The cloud container's checks: the shadow on the three corpora and the compiler's own source, with the default warnings and with -Wall -Wextra.
checks = record + '/final/cloud-checks'
def shadow(name):
    text = open('%s/shadow/%s' % (checks, name), errors='replace').read()
    x = re.search(r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) their-entries=(\d+) differences=(\d+) not-kept-by-the-reference=(\d+) second-runs-that-differ=(\d+)", text)
    v = re.search(r"window rows values: tapes that differ in a value alone=(\d+); records on a list=(\d+) .*after the first=(\d+); expressions numbered=(\d+)", text)
    l = re.search(r"window rows listed, by an expression's first record's reason: update=(\d+) branches=(\d+) refused-conversion=(\d+) constant-to-a-floating-class=(\d+)", text)
    assert x and v and l, name
    return dict(expressions=int(x.group(1)), taken=int(x.group(3)), share=x.group(4), entries=int(x.group(7)), differences=int(x.group(8)), unkept=int(x.group(9)), again=int(x.group(10)),
                valued=int(v.group(1)), numbered=int(v.group(4)), listed=[int(g) for g in l.groups()])
cloud = {}
for c, name in (('sqlite3', 'sqlite'), ('lua', 'lua'), ('musl', 'musl'), ('main', 'main')):
    a = shadow('%s--passes0--window-rows--list20.out' % name); b2 = shadow('%s--passes0--window-rows-Wall-Wextra--list20.out' % name)
    assert a == b2 and a['differences'] == 0 and a['again'] == 0 and a['valued'] == 0 and a['unkept'] == 0, (c, a, b2)
    cloud[c] = a
status = open('%s/shadow/status.txt' % checks).read().splitlines()
assert all('status 0' in l for l in status if 'status' in l)
values['cloud_runs'] = str(len([l for l in status if 'status' in l]))
values['cloud'] = cloud
# The 9700X's counts of the numbered are the census's.
census_numbered = [int(re.match(r'([\d,]+)', x).group(1).replace(',', '')) for x in numbered]
assert [on[c]['numbered'] for c in CORPORA] == census_numbered[:3] and (cloud['main']['numbered'] == census_numbered[3] or os.environ.get('GEN_STAND_IN')), (
    [on[c]['numbered'] for c in CORPORA], cloud['main']['numbered'], census_numbered)
# The one-statement programs.
agree = re.compile(r' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 ')
agree_values = re.compile(r' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 .*values alone 0 listed [0-9]* numbered [0-9]*$')
probes = {}
for name in ('earlier', 'cases9', 'cases10', 'cases11', 'cases12', 'cases13', 'cases14'):
    probes[name] = open('%s/probes/%s.txt' % (checks, name)).read().splitlines()
    assert all(agree_values.search(l) for l in probes[name]), [l for l in probes[name] if not agree_values.search(l)][:2]
for k in (15, 16, 17, 18, 19, 20):
    probes['cases%d' % k] = open('%s/probes/cases%d.txt' % (checks, k)).read().splitlines()
    assert all(agree_values.search(l) for l in probes['cases%d' % k]), [l for l in probes['cases%d' % k] if not agree_values.search(l)][:2]
old_probes = sum(len(probes[k]) for k in ('earlier', 'cases9', 'cases10', 'cases11', 'cases12', 'cases13', 'cases14'))
new_probes = sum(len(probes['cases%d' % k]) for k in (15, 16, 17, 18, 19, 20))
numbered_probes = len([l for k in probes for l in probes[k] if re.search(r'numbered [1-9]', l)])
values['probes_old'] = n(old_probes); values['probes_new'] = n(new_probes); values['probes_all'] = n(old_probes + new_probes); values['probes_numbered'] = n(numbered_probes)
# The fixtures' tapes: test-checker's part 5 on the code as it is (the pins).
pins = open(record + '/final/pins.txt').read()
def pin(struct, field):
    m = re.search(r'^%s\.%s = (\d+)$' % (struct, re.escape(field)), pins, re.M)
    assert m, (struct, field)
    return int(m.group(1))
# ---- The fault rounds.
def joined(path):
    lines = open(path).read().splitlines()
    head = re.match(r'faults: (\d+); with a verdict: (\d+); with two or more: (\d+), of which they differ: (\d+); with none: (\d+)', lines[0])
    assert head and head.group(1) == head.group(2) and head.group(4) == '0' and head.group(5) == '0', lines[0]
    return dict(faults=int(head.group(1)), twice=int(head.group(3)), caught=len([l for l in lines if l.startswith('caught ')]), survived=[l.split()[2] for l in lines if l.startswith('SURVIVED ')])
r1 = joined(record + '/faults/round1-joined.txt')
r2lines = open(record + '/faults/round2.txt').read().splitlines()
assert r2lines[0].startswith('control-passes') and r2lines[-1] == 'job finished'
r2 = dict(faults=len(r2lines) - 2, caught=len([l for l in r2lines if l.startswith('caught ')]), survived=[l.split()[2] for l in r2lines if l.startswith('SURVIVED ')])
assert r2['caught'] + len(r2['survived']) == r2['faults']
no_faults = [l.split(':')[0] for l in open(record + '/faults/faults-values-round2.py.no-faults.txt')]
values['rounds'] = dict(round1=r1, round2=r2, no_faults=no_faults)
# ---- Against its gates.
def zone(e):
    return 'met' if e <= 1.5 else 'refuted' if e >= 2.5 else 'not met'
z = {c: zone(R[c][SUM]['e']) for c in ('sqlite3', 'lua')}
verdict3 = 'refuted' if 'refuted' in z.values() else 'not met' if 'not met' in z.values() else 'met'
quiet = ('the kernel in place, a record', "the tests' loop", "the tests' expression's part", "the tests on T's records", "C's targets", "C's expression's part")
touched = ("the records' bytes", "C's loop")
worst_quiet = max(abs(R[c][name]['d']) for c in ('sqlite3', 'lua') for name in quiet)
worst_touched = max(abs(R[c][name]['d']) for c in ('sqlite3', 'lua') for name in touched)
verdict4 = 'met' if max(worst_quiet, worst_touched) <= 0.3 else 'not met'
g = []
g.append("- **V1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind, a class or a\n  value, on the three corpora on the 9700X (%s, %s and %s tapes), and no chunk's second run differs from its\n"
         "  first. In the cloud container the same on the three and on the compiler's own source (%s tapes of its %s\n  expressions, %s%%), with the default warnings and with `-Wall -Wextra`. The values' fixture has a line a source of a\n"
         "  value (%s tapes), the rows' %s, C's %s and two units of one chunk 3 each: with one of the reference's answers\n  changed for each tape the comparison counts every one, and with one of a chunk's first run's answers changed every\n"
         "  chunk's second run differs. And %s one-statement programs, each a file of its own: %s written for the values (a\n  constant of each class, plain and folded; an address constant; a member; a pointer's sum, subscript and update; a\n"
         "  store and an update by name and through an address; calls nested and side by side; conditions whose operators own\n  a label; postfix updates through an address), %s of the %s with an expression numbered, and the %s of the pieces\n  before." % (
             n(on['sqlite3']['taken']), n(on['lua']['taken']), n(on['musl']['taken']), n(cloud['main']['taken']), n(cloud['main']['expressions']), cloud['main']['share'],
             n(pin('rows_values_expected', 'taken')), n(pin('rows_expected', 'taken')), n(pin('rows_contexts_expected', 'taken')),
             values['probes_all'], values['probes_new'], values['probes_numbered'], values['probes_all'], values['probes_old']))
g.append("- **V2, how much: met.** Every expression whose rows the piece before made has its tape whole: none is listed for a\n  value on the three corpora or the compiler's own source (0.5%% refutes). The numbered expressions are the count's: %s,\n  %s, %s and %s." % (
    n(on['sqlite3']['numbered']), n(on['lua']['numbered']), n(on['musl']['numbered']), n(cloud['main']['numbered'])))
a = R['sqlite3']; l = R['lua']; mu = R['musl']
g.append("- **V3, cost: %s.** The rows' sweeps and the part read %s ticks a record swept more than the piece before's\n  executable on `sqlite3.c` (%s to %s) and %s on Lua (%s to %s); 1.5 was asked and 2.5 refutes. On musl, which the gate\n"
         "  did not name, %s (%s to %s): its chunks are a quarter the size. The values' own part is %.2f, %.2f and %.2f of it;\n  by the switch, on less off, the reads, which leave a member's offset, read %s and %s more on the first two, and the\n"
         "  rows' write %s and %s. With the values off the same executable reads %s and %s more than the piece before's, its\n  two clock's reads around the sweep among them. A chunk's\n"
         "  second run reads the whole %s and %s more than the piece before's, the values' part %.2f and %.2f: the work a\n  record is over what was asked with its code and its tables at hand, and a first run adds a cold start a chunk to it\n"
         "  (%s ticks a chunk for %s on `sqlite3.c`, %s for %s on Lua)." % (
             verdict3, s(a[SUM]['e']), s(a[SUM]['elo']), s(a[SUM]['ehi']), s(l[SUM]['e']), s(l[SUM]['elo']), s(l[SUM]['ehi']), s(mu[SUM]['e']), s(mu[SUM]['elo']), s(mu[SUM]['ehi']),
             a[VAL]['on'], l[VAL]['on'], mu[VAL]['on'], s(a['the reads']['d']), s(l['the reads']['d']), s(a['the rows']['d']), s(l['the rows']['d']),
             s(a[SUM]['f']), s(l[SUM]['f']),
             s(a[LATER]['e']), s(l[LATER]['e']), a[LVAL]['on'], l[LVAL]['on'],
             n(round(a[VAL]['on'] * per_chunk_final['sqlite3'])), n(round(a[LVAL]['on'] * per_chunk_final['sqlite3'])), n(round(l[VAL]['on'] * per_chunk_final['lua'])), n(round(l[LVAL]['on'] * per_chunk_final['lua']))))
g.append("- **V4, nothing else moves: %s.** By the switch, on less off, on `sqlite3.c` and Lua: the kernel in place %s and %s;\n  the tests' loop %s and %s, their expression's part %s and %s, their sweep on T's records %s and %s; C's targets %s\n"
         "  and %s, its expression's part %s and %s. The two sweeps the piece gives work to: the records' bytes, which make a\n  record's value, %s and %s a record of the tests', at the gate's bound, and C's loop, which keeps a stride, %s and %s\n  (0.3 asked)." % (
             verdict4, s(a['the kernel in place, a record']['d']), s(l['the kernel in place, a record']['d']), s(a["the tests' loop"]['d']), s(l["the tests' loop"]['d']),
             s(a["the tests' expression's part"]['d']), s(l["the tests' expression's part"]['d']), s(a["the tests on T's records"]['d']), s(l["the tests on T's records"]['d']),
             s(a["C's targets"]['d']), s(l["C's targets"]['d']), s(a["C's expression's part"]['d']), s(l["C's expression's part"]['d']),
             s(a["the records' bytes"]['d']), s(l["the records' bytes"]['d']), s(a["C's loop"]['d']), s(l["C's loop"]['d'])))
values['verdicts'] = dict(v3=verdict3, v4=verdict4, zones=z)
values['gates_first'] = g
# V5: the first round's survivors, by what each one found.
S1 = set(r1['survived'])
GONE = {'table-rest-of-any-shape', 'value-object-always', 'value-object-of-constants-alone', 'sweep-floating-folded-too', 'sweep-facts-unmasked', 'seconds-not-guarded', 'seconds-first-of-ends-too',
        'number-with-one'}
CONTROLS = {'compare-first-value-alone', 'compare-value-low-half', 'compare-valued-with-kinds', 'again-values-not-compared', 'again-numbered-not-compared', 'again-steps-not-compared',
            'again-lists-not-compared'}
LINES = {'reader-expression-next', 'first-low-half', 'constant-next-entry-s-class', 'walk-labeled-alone', 'number-the-listed-too', 'seconds-starts-two-on'}
TIGHTENED = {'call-row-holder-s-first-after'}
COUNTED = {x for x in S1 if x.startswith('seconds-')} - GONE - LINES
assert set(no_faults) <= S1 and GONE <= S1 and CONTROLS <= S1 and LINES <= S1 and TIGHTENED <= S1
assert GONE | set(no_faults) | CONTROLS | LINES | TIGHTENED | COUNTED == S1 and len(GONE) + len(no_faults) + len(CONTROLS) + len(LINES) + len(TIGHTENED) + len(COUNTED) == len(S1), sorted(
    S1 - (GONE | set(no_faults) | CONTROLS | LINES | TIGHTENED | COUNTED))
assert not r2['survived'], r2['survived']
words = {5: 'Five', 6: 'Six', 7: 'Seven', 8: 'Eight', 9: 'Nine', 14: 'Fourteen'}
g.append("- **V5, faults: met.** Two rounds: each entry of the values' tables, each term of the sweep's masks and of the later\n  records' arithmetic, each loop's load, shift and store, the two lists made before the sweep, the columns' makers, each\n"
         "  term of the numbering, and the shadow's comparisons and their control, changed alone, a build and the fixture's\n  tests a fault. The first round's %d faults, run from the list's two ends at once (the 9700X and the cloud container:\n"
         "  %d faults by both, with the same verdict each), left %d.\n"
         "  - %s were terms no program separates, and are out of the code: an address's range beside the two variants that\n    are within it; a record's constant's kind beside its object (X's own test is the object's, and a count found no\n"
         "    record of the three corpora with an object and a constant that is no address's); a fold beside a floating\n    class and the reads' mask beside a fold (a folded constant is an integer's with a target the reads read); the\n"
         "    expressions' ends in the subtraction (a borrow that runs on stops at the next expression's first marked record,\n    which no start is); and the numbering's test for two marked records (a count of its calls found none with fewer).\n"
         "  - %s change nothing a program reaches, and are no faults: an object's number sign-extended (it is a token's\n    index and one); an update's step's class read from the operation after it, which is of the same class; a\n"
         "    destination's shape taken through the kept rows' rest's, which are a conversion's part's; an expression's marked\n    records taken from its second record on, its first being a leaf; and an owned record with any conversion's part\n"
         "    taken for a tested value, which a numbered expression has none of.\n"
         "  - %s were the shadow's own comparisons, which no test could fail. The control now changes a value's lowest bit and\n    its highest, a tape's first entry's and its last's, and a value beside a class; and one of a chunk's first run's\n"
         "    answers in thirteen turns, so that the second run's comparison counts every chunk.\n"
         "  - %s were in the later records' arithmetic, where a superfluous record on the list numbered nothing and changed\n    no answer: the list's records are counted and pinned now.\n"
         "  - %s got a line in the fixture, each run against its fault's build before the next round: an expression with two\n    calls beside one C leaves; an operator with no label between a tested value and its owner; a member past 4 GB;\n"
         "    a constant before an entry of a narrower class; a listed expression with two calls; and a call with no\n    argument right after a condition. And one comparison had slack: a call's holder is one whose subtree starts no\n"
         "    later than its own, where the code asked no later than its record.\n"
         "  The second round's %d faults, every one whose text changed, the new ones and the first's survivors, on the code as\n  it is, are all caught." % (
             r1['faults'], r1['twice'], len(r1['survived']), words[len(GONE)], words[len(no_faults)], words[len(CONTROLS)], words[len(COUNTED)], words[len(LINES)], r2['faults']))
values['gates'] = '\n'.join(g)
values['short_gates'] = '\n'.join([
    "- **V1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind, a class or a\n  value, on the three corpora and the compiler's own source; %s one-statement programs agree." % values['probes_all'],
    "- **V2, how much: met.** None is listed for a value.",
    "- **V3, cost: %s.** %s ticks a record swept more than the piece before's on `sqlite3.c` (1.5 asked, 2.5 refutes) and %s\n  on Lua; %s and %s on a chunk's second run." % (
        verdict3, s(a[SUM]['e']), s(l[SUM]['e']), s(a[LATER]['e']), s(l[LATER]['e'])),
    "- **V4, nothing else moves: %s.** The kernel, the tests' other parts and C's other sweeps read within %.2f with the\n  values on; the records' bytes and C's loop, which the piece gives work to, within %.2f (0.3 asked)." % (verdict4, worst_quiet, worst_touched),
    "- **V5, faults: met.** Two rounds. The first's %d faults left %d: %d terms no program separates, which are out of the\n  code; %d that change nothing; and %d that found a control, a count or a fixture's line to add. The second's %d, on the\n  code as it is, are all caught." % (
        r1['faults'], len(r1['survived']), len(GONE), len(no_faults), len(CONTROLS) + len(COUNTED) + len(LINES) + len(TIGHTENED), r2['faults'])])
# ---- What stays a record at a time.
listed_share = {c: on[c]['on_a_list'] / on[c]['swept'] for c in CORPORA}
second_share = {c: 100.0 * on[c]['numbered'] / on[c]['taken'] for c in CORPORA}
values['scalar'] = (
    "- **The lists' loops:** %.2f, %.2f and %.2f listed records a record swept. A value is a load from a column and a store at\n  its row's place, which is the sum of two columns' bytes for its record: the places are no register's eight in a\n"
    "  row, and a scatter is 88 micro-operations on Zen 5, one every 17 cycles (\"SIMD and Zen 5\" in the coding style).\n  The vector makes the lists. The specification named two things to measure against the loops if they read over\n"
    "  their gate. The first is in the code since the second build: a column of each record's one value (the rows'\n  sweeps read %.2f and %.2f in the first build and %.2f and %.2f in the fourth). The second is not: the values\n"
    "  written by slots as the kinds are, eight quadwords a register through a compress. What the counters say of the\n  loops is that their work is not the cost a chunk's first run pays: the sweep executes the same instructions in\n"
    "  both runs, and takes %s to %s cycles a chunk the first and %s to %s the second on `sqlite3.c`.\n"
    "  [#@@followup@@](https://github.com/buster14a/buster/issues/@@followup@@) has that cold start, for every sweep of the\n  window, and the by-slots build as what to measure there.\n"
    "- **The numbering:** %.2f%%, %.2f%% and %.2f%% of the tapes. A call's row and a label are preorder numbers in the\n  expression's tree, and the reference numbers them a record at a time too. The sweep finds those expressions with\n"
    "  no test an expression: one subtraction a block." % (
        listed_share['sqlite3'], listed_share['lua'], listed_share['musl'], t1['sqlite3'][0], t1['lua'][0], t4['sqlite3'][0], t4['lua'][0],
        n(round(cy1['sqlite3'][0])), n(round(cy1['sqlite3'][1])), n(round(cy2['sqlite3'][0])), n(round(cy2['sqlite3'][1])),
        second_share['sqlite3'], second_share['lua'], second_share['musl']))
values['short_scalar'] = (
    "The lists' loops, %.2f, %.2f and %.2f listed records a record swept: a value is a load from a column and a store at its\nrow's place, and the places are no register's eight in a row. And the numbering, for %.2f%%, %.2f%% and %.2f%% of the\n"
    "tapes: a call's row and a label are preorder numbers in the expression's tree. The by-slots build the specification\nnamed against the loops was not made: the counters put a first run's cost in a cold start a chunk, not in the loops'\n"
    "work ([#@@followup@@](https://github.com/buster14a/buster/issues/@@followup@@))." % (
        listed_share['sqlite3'], listed_share['lua'], listed_share['musl'], second_share['sqlite3'], second_share['lua'], second_share['musl']))
ticks_more = {c: R[c][SUM]['e'] * on[c]['swept'] for c in CORPORA}
reference = {c: R[c]["the reference's X, a record of the taken"]['on'] for c in CORPORA}
values['means'] = '\n'.join([
    "- **X's tapes are whole on the window** for %s%%, %s%% and %s%% of the expressions C takes on the three corpora: a kind,\n  a class and a value an entry, compared with X's on T's columns." % (on['sqlite3']['share'], on['lua']['share'], on['musl']['share']),
    "- **What they cost against the reference.** The rows' sweeps and the part read %.2f, %.2f and %.2f ticks a record of the\n  taken expressions; X on T's columns reads %.2f, %.2f and %.2f a record of theirs.%s" % (
        R['sqlite3']['a record of the taken']['on'], R['lua']['a record of the taken']['on'], R['musl']['a record of the taken']['on'], reference['sqlite3'], reference['lua'], reference['musl'],
        (" **On musl the window's rows now read more than the reference does:** its\n  chunks are a quarter of `sqlite3.c`'s, and its rows' sweeps read %.2f ticks a record swept a chunk's first run and %.2f\n  its second." % (
            R['musl'][SUM]['on'], R['musl'][LATER]['on'])) if R['musl']['a record of the taken']['on'] > reference['musl'] else ''),
    "- **The cost gate was written from work a record, and the window's sweeps pay by the chunk too.** The values' part\n  reads %.2f, %.2f and %.2f ticks a record swept a chunk's first run and %.2f, %.2f and %.2f its second; their chunks are\n"
    "  %.0f, %.0f and %.0f records. A gate for a pass over the window is two numbers: cycles a chunk and work a record." % (
        R['sqlite3'][VAL]['on'], R['lua'][VAL]['on'], R['musl'][VAL]['on'], R['sqlite3'][LVAL]['on'], R['lua'][LVAL]['on'], R['musl'][LVAL]['on'],
        per_chunk_final['sqlite3'], per_chunk_final['lua'], per_chunk_final['musl']),
    "- **Next:** `&&` and `||` as values, `?:` and a comma, in C and in X on the window together."])
# ---- The templates.
for name in ('node-machine-section.md', 'one-core-path-section.md'):
    text = open(here + '/' + name).read()
    for key in re.findall(r'@@(\w+)@@', text):
        if key == 'followup':
            continue
        assert key in values and isinstance(values[key], str), key
        text = text.replace('@@%s@@' % key, values[key])
    open(out + '/' + name, 'w').write(text)
json.dump(values, open(out + '/values.json', 'w'), indent=1, sort_keys=True)
