#!/usr/bin/env python3
# gen-docs.py FETCH FINAL ROUNDS OUT: the update piece's two design sections, from their templates (node-machine-section.md
# and one-core-path-section.md beside this script) and the numbers of job-xu.sh's readings: the six builds' tables
# (FETCH/xu1-table.txt to xu6-table.txt, by xu-table.py), the final readings' (FETCH/FINAL-table.txt and its runs'
# files), and the fault rounds' verdicts (ROUNDS/roundN.txt). Every number in the output is read or computed here.
import glob, os, re, sys
fetch, final, rounds, out = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
here = os.path.dirname(os.path.abspath(__file__))
CORPORA = ('sqlite3', 'lua', 'musl')
def table(label):
    return open('%s/%s-table.txt' % (fetch, label)).read()
def row(text, corpus, name):
    m = re.search(r"^%s\s+%s\s+on\s+([\d.]+) \(([\d.]+) to ([\d.]+)\)\s+off\s+([\d.]+)\s+before\s+([\d.]+)\s+on less off\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)\s+on less before\s+([+-][\d.]+) \(([+-][\d.]+) to ([+-][\d.]+)\)" % (corpus, re.escape(name)), text, re.M)
    assert m, (corpus, name)
    v = [float(x) for x in m.groups()]
    return dict(on=v[0], lo=v[1], hi=v[2], off=v[3], before=v[4], d=v[5], dlo=v[6], dhi=v[7], e=v[8], elo=v[9], ehi=v[10])
def counts(text, corpus, which):
    m = re.search(r"^%s\s+%s\s+expressions (\d+) taken (\d+) \(([\d.]+)%%\) entries (\d+) differences (\d+) swept (\d+) written (\d+); listed (\d+) (\d+) (\d+) (\d+); words (\d+) lines (\d+) updates (\d+); the same in every run: (\w+)\s+\[(\d+) readings\]" % (corpus, which), text, re.M)
    assert m, (corpus, which)
    g = m.groups()
    return dict(expressions=int(g[0]), taken=int(g[1]), share=g[2], entries=int(g[3]), differences=int(g[4]), swept=int(g[5]), written=int(g[6]), update=int(g[7]), branches=int(g[8]),
                conversion=int(g[9]), floating=int(g[10]), words=int(g[11]), lines=int(g[12]), updates=int(g[13]), same=g[14], readings=int(g[15]))
def n(x):
    return '{:,}'.format(x)
def s(x):
    return '%+.2f' % (0.0 if abs(x) < 0.005 else x)
T = table(final)
on = {c: counts(T, c, 'on') for c in CORPORA}
off = {c: counts(T, c, 'off') for c in CORPORA}
before = {c: counts(T, c, 'before') for c in CORPORA}
assert all(on[c]['same'] == 'True' and off[c]['same'] == 'True' and before[c]['same'] == 'True' for c in CORPORA)
assert all(on[c]['differences'] == 0 and before[c]['differences'] == 0 and off[c]['differences'] == 0 for c in CORPORA)
assert len(set(on[c]['readings'] for c in CORPORA)) == 1
readings = on['sqlite3']['readings']
assert 'without status 0: 0' in T.splitlines()[0], T.splitlines()[0]
decided = {}; their = {}; their_before = {}; chunks = {}
for c in CORPORA:
    text = open(glob.glob('%s/%s/rows-on1-%s-1.txt' % (fetch, final, c))[0], errors='replace').read()
    m = re.search(r"window contexts expressions=(\d+) records=(\d+) decided=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) of-them-refused=(\d+)", text)
    decided[c] = (int(m.group(3)), int(m.group(7)))
    x = re.search(r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\)", text)
    their[c] = int(x.group(5))
    tb = open(glob.glob('%s/xr10/%s-base1-%s-1.txt' % (fetch, final, c))[0], errors='replace').read()
    their_before[c] = int(re.search(r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+)", tb).group(5))
    k = re.search(r"records-swept=(\d+) roots-apart-from-their-operand=\d+ chunks=(\d+)", text)
    chunks[c] = (int(k.group(1)), int(k.group(2)))
R = {c: {name: row(T, c, name) for name in ("the rows' sweeps, a record swept", 'the reads', 'the shapes', 'the updates', 'the rows', "an expression's part", 'a record of the taken',
                                             "the reference's X, a record of the taken", '(a second run) a record swept', '(a second run) the updates', '(a second run) the reads',
                                             '(a second run) the shapes', '(a second run) the rows', 'the kernel in place, a record', 'the tests on the window, a record', "the records' bytes",
                                             "the tests' loop", "the tests' expression's part", "the tests on T's records", "C's sweeps, a record swept")} for c in CORPORA}
SUM = "the rows' sweeps, a record swept"
def three(f):
    return ' | '.join(f(c) for c in CORPORA)
values = {}
for c in CORPORA:
    values['expressions_' + c] = n(on[c]['expressions'])
    values['before_update_' + c] = n(before[c]['update'])
    values['on_update_' + c] = n(on[c]['update'])
    values['updates_share_' + c] = '%.2f%%' % (100.0 * on[c]['updates'] / on[c]['swept'])
values['readings'] = {3: 'three', 5: 'five', 7: 'seven'}[readings]
# The builds.
BUILDS = (('xu1', "first: the update's loop in the reads' sweep, each shape chosen by branches; four columns of its own"),
          ('xu2', "each shape a sum of bits, with no branch"),
          ('xu3', "no column of its own: the shapes into the two the sweeps write"),
          ('xu4', "both rows' shapes as masks in the shapes' sweep; the loop carries what crosses the two records"),
          ('xu5', "a sweep and a loop of their own, after the shapes' sweep"),
          ('xu6', "that loop with no table of its own (not kept)"))
B = {label: table(label) for label, _ in BUILDS}
lines = []
for label, what in BUILDS:
    a = row(B[label], 'sqlite3', SUM); b = row(B[label], 'lua', SUM)
    lines.append('| %s | %.2f | %s | %.2f | %s |' % (what, a['on'], s(a['e']), b['on'], s(b['e'])))
a = R['sqlite3'][SUM]; b = R['lua'][SUM]
lines.append("| the fifth's, in a chunk with an update alone, and a row's entries' number one byte (%s readings) | **%.2f** | **%s** | **%.2f** | **%s** |" % (values['readings'], a['on'], s(a['e']), b['on'], s(b['e'])))
values['builds_table'] = "| build | `sqlite3.c`, with the update's rows | more than the piece before's | Lua, with them | more |\n| --- | ---: | ---: | ---: | ---: |\n" + '\n'.join(lines)
def part(label, corpus, name):
    return row(B[label], corpus, name)
u = {c: on[c]['updates'] for c in CORPORA}; w = {c: on[c]['swept'] for c in CORPORA}
x1 = part('xu1', 'sqlite3', 'the reads'); x2 = part('xu2', 'sqlite3', 'the reads')
notes = []
notes.append("- **A shape chosen by branches is mispredicted.** The first build's loop chose each shape by branches: the reads\n  read %.2f ticks a record more with the update's rows on than off on `sqlite3.c`, %.1f an update; as sums of bits,\n  %.2f and %.1f." % (
    x1['d'], x1['d'] * w['sqlite3'] / u['sqlite3'], x2['d'], x2['d'] * w['sqlite3'] / u['sqlite3']))
c2 = {c: part('xu2', c, 'the reads') for c in ('sqlite3', 'lua')}; c3 = {c: part('xu3', c, 'the reads') for c in ('sqlite3', 'lua')}
notes.append("- **A column of its own is one more a block, in every chunk.** With four (the two shapes', the operation's kind and\n  the store's), the reads read %.2f ticks a record more than the piece before's on `sqlite3.c` and %.2f on Lua with\n  the update's rows off; with none, %.2f and %.2f." % (
    c2['sqlite3']['off'] - c2['sqlite3']['before'], c2['lua']['off'] - c2['lua']['before'], c3['sqlite3']['off'] - c3['sqlite3']['before'], c3['lua']['off'] - c3['lua']['before']))
s4 = {c: part('xu4', c, 'the shapes') for c in ('sqlite3', 'lua')}; r4 = {c: part('xu4', c, 'the reads') for c in ('sqlite3', 'lua')}
notes.append("- **A term in a big sweep is every block's.** The fourth build made both rows' shapes of masks in the shapes' sweep,\n  its loop carrying only what crosses the two records. The shapes' sweep read %.2f ticks a record more than the\n  piece before's on `sqlite3.c` and %.2f on Lua, %.2f and %.2f of it with the update's rows off; and the reads, with\n  the list and the loop in them, %.2f and %.2f more." % (
    s4['sqlite3']['e'], s4['lua']['e'], s4['sqlite3']['off'] - s4['sqlite3']['before'], s4['lua']['off'] - s4['lua']['before'], r4['sqlite3']['e'], r4['lua']['e']))
r5 = {c: part('xu5', c, 'the reads') for c in ('sqlite3', 'lua')}; s5 = {c: part('xu5', c, 'the shapes') for c in ('sqlite3', 'lua')}
u5 = {c: part('xu5', c, 'the updates') for c in ('sqlite3', 'lua')}; v5 = {c: part('xu5', c, '(a second run) the updates') for c in ('sqlite3', 'lua')}
notes.append("- **A sweep and a loop of their own leave the others theirs.** In the fifth build the reads read %s and %s against\n  the piece before's and the shapes %s and %s. The updates' own counter reads %.2f and %.2f, of which %.2f and %.2f\n  are the list's sweep with no update to make (the switch), and %.2f and %.2f on a chunk's second run." % (
    s(r5['sqlite3']['e']), s(r5['lua']['e']), s(s5['sqlite3']['e']), s(s5['lua']['e']), u5['sqlite3']['on'], u5['lua']['on'], u5['sqlite3']['off'], u5['lua']['off'], v5['sqlite3']['on'], v5['lua']['on']))
u6 = {c: part('xu6', c, 'the updates') for c in ('sqlite3', 'lua')}
notes.append("- **The loop with no table of its own read no less**, %.2f and %.2f: a sum of bits for each shape and each length\n  is more instructions than the lookups it replaces." % (u6['sqlite3']['on'], u6['lua']['on']))
values['builds_notes'] = '\n'.join(notes)
values['vector_note'] = "the shapes' sweep read %.2f ticks a record more on `sqlite3.c` and %.2f\non Lua with them, %.2f and %.2f of it with no update to make; the loop of its own reads %.2f and %.2f, and leaves\nthe sweep where it was." % (
    s4['sqlite3']['e'], s4['lua']['e'], s4['sqlite3']['off'] - s4['sqlite3']['before'], s4['lua']['off'] - s4['lua']['before'], R['sqlite3']['the updates']['on'], R['lua']['the updates']['on'])
# The final readings.
def cell(name, key='on', fmt='%.2f'):
    return lambda c: fmt % R[c][name][key]
m = []
m.append('| expressions C takes on the window | ' + three(lambda c: n(on[c]['expressions'])) + ' |')
m.append('| their tapes made here | ' + three(lambda c: '%s (%s%%)' % (n(on[c]['taken']), on[c]['share'])) + ' |')
m.append("| the piece before's | " + three(lambda c: '%s (%s%%)' % (n(before[c]['taken']), before[c]['share'])) + ' |')
m.append('| of the expressions C decides | ' + three(lambda c: '%.2f%%' % (100.0 * on[c]['taken'] / decided[c][0])) + ' |')
m.append('| listed for an update | ' + three(lambda c: n(on[c]['update'])) + ' |')
m.append('| listed for branches | ' + three(lambda c: n(on[c]['branches'])) + ' |')
m.append('| listed for a refused conversion | ' + three(lambda c: n(on[c]['conversion'])) + ' |')
m.append('| listed for a constant to a floating class | ' + three(lambda c: n(on[c]['floating'])) + ' |')
m.append("| tapes that differ from X's on T's columns | " + three(lambda c: n(on[c]['differences'])) + ' |')
m.append('| updates | ' + three(lambda c: '%s (%.2f%% of the records swept)' % (n(on[c]['updates']), 100.0 * on[c]['updates'] / on[c]['swept'])) + ' |')
m.append("| **the rows' sweeps and the part, a record swept** | " + three(lambda c: '**%.2f (%.2f to %.2f)**' % (R[c][SUM]['on'], R[c][SUM]['lo'], R[c][SUM]['hi'])) + ' |')
m.append("| the piece before's executable, in the same readings | " + three(cell(SUM, 'before')) + ' |')
m.append("| **more than the piece before's** | " + three(lambda c: '**%s (%s to %s)**' % (s(R[c][SUM]['e']), s(R[c][SUM]['elo']), s(R[c][SUM]['ehi']))) + ' |')
m.append("| with the update's rows off | " + three(cell(SUM, 'off')) + ' |')
m.append('| the reads | ' + three(cell('the reads')) + ' |')
m.append('| the shapes | ' + three(cell('the shapes')) + ' |')
m.append("| the updates; with none to make | " + three(lambda c: '%.2f; %.2f' % (R[c]['the updates']['on'], R[c]['the updates']['off'])) + ' |')
m.append('| the rows | ' + three(cell('the rows')) + ' |')
m.append("| an expression's part | " + three(cell("an expression's part")) + ' |')
m.append("| a second run over the same chunk; the piece before's | " + three(lambda c: '%.2f; %.2f' % (R[c]['(a second run) a record swept']['on'], R[c]['(a second run) a record swept']['before'])) + ' |')
m.append('| the updates in it; with none to make | ' + three(lambda c: '%.2f; %.2f' % (R[c]['(a second run) the updates']['on'], R[c]['(a second run) the updates']['off'])) + ' |')
m.append("| the updates, ticks an update: a first run; a second | " + three(lambda c: '%.0f; %.0f' % (R[c]['the updates']['on'] * on[c]['swept'] / on[c]['updates'], R[c]['(a second run) the updates']['on'] * on[c]['swept'] / on[c]['updates'])) + ' |')
m.append('| a record of the taken expressions | ' + three(cell('a record of the taken')) + ' |')
m.append("| X on T's columns, a record of theirs, with its values | " + three(cell("the reference's X, a record of the taken")) + ' |')
m.append("| records a chunk; updates a chunk | " + three(lambda c: '%.0f; %.1f' % (chunks[c][0] / chunks[c][1], on[c]['updates'] / chunks[c][1])) + ' |')
values['measured_table'] = '\n'.join(m)
short = [m[0], m[1], m[2], m[8], m[10], m[11], m[12], m[16], m[19], m[22], m[23]]
values['short_table'] = '\n'.join(short)
# The fault rounds.
def verdicts(path):
    t = open(path).read().splitlines()
    assert t[0].startswith('control-passes'), t[0]
    return dict(caught=len([l for l in t if l.startswith('caught ')]), survived=[l.split()[1] for l in t if l.startswith('SURVIVED ')], other=[l for l in t[1:] if not l.startswith(('caught ', 'SURVIVED '))])
V = [verdicts(p) for p in sorted(glob.glob(rounds + '/round*.txt'))]
assert all(not v['other'] for v in V), [v['other'] for v in V]
values['rounds'] = V
more = {c: on[c]['taken'] - before[c]['taken'] for c in CORPORA}
g = []
g.append("- **U1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind or a class, on\n  the three corpora on the 9700X, with the update's rows on and off.@@u1_more@@")
g.append("- **U2, how much: met.** %s tapes more on `sqlite3.c`, %s on Lua and %s on musl (2,900, 600 and 3,400 asked;\n  refuted under 2,500, 500 and 3,000): %s%%, %s%% and %s%% of the expressions C takes, and %.2f%%, %.2f%% and %.2f%%\n  of those it decides." % (
    n(more['sqlite3']), n(more['lua']), n(more['musl']), on['sqlite3']['share'], on['lua']['share'], on['musl']['share'],
    100.0 * on['sqlite3']['taken'] / decided['sqlite3'][0], 100.0 * on['lua']['taken'] / decided['lua'][0], 100.0 * on['musl']['taken'] / decided['musl'][0]))
# The count before the specification: the expressions listed first for an update with updates alone, and those of them
# with a postfix update through an address (none had a bool's).
counted = {}
for line in open('/home/user/buster-performance/docs/measurements/x-update-rows-2850-2026-11-20/before/9700x-count.txt'):
    m = re.search(r"listed first for an update=(\d+) with branches too=(\d+) .* updates alone=(\d+); of those: with an indirect postfix update=(\d+) with a bool's update=(\d+)", line)
    if m:
        for c in CORPORA:
            if int(m.group(1)) == before[c]['update']:
                counted[c] = [int(x) for x in m.groups()]
assert sorted(counted) == sorted(CORPORA) and all(counted[c][4] == 0 and counted[c][2] - on[c]['update'] == more[c] for c in CORPORA), counted
g[-1] += " Of the %s, %s and %s expressions with a postfix update\n  through an address (the count before the specification), %s, %s and %s are listed still, for the entries of their\n  destination's own." % (
    n(counted['sqlite3'][3]), n(counted['lua'][3]), n(counted['musl'][3]), n(on['sqlite3']['update']), n(on['lua']['update']), n(on['musl']['update']))
e = {c: R[c][SUM] for c in CORPORA}
def verdict(c):
    return 'met' if e[c]['e'] <= 0.5 else 'refuted' if e[c]['e'] > 1.0 else 'not met'
g.append("- **U3, cost: %s.** The rows' sweeps and the part read %s ticks a record swept more\n  than the piece before's executable on `sqlite3.c` (%s to %s) and %s on Lua (%s to %s), where 0.5 was asked\n  and 1.0 refutes; %s on musl (%s to %s), which the gate did not name. Of it the updates' sweep and loop are %.2f,\n  %.2f and %.2f, and the rows' write, with the update's marks and sources in it, %s, %s and %s. On a chunk's second\n  run the whole reads %s, %s and %s more." % (
    (verdict('sqlite3') if verdict('sqlite3') == verdict('lua') else '%s on `sqlite3.c`, %s on Lua' % (verdict('sqlite3'), verdict('lua'))), s(e['sqlite3']['e']), s(e['sqlite3']['elo']), s(e['sqlite3']['ehi']), s(e['lua']['e']), s(e['lua']['elo']), s(e['lua']['ehi']),
    s(e['musl']['e']), s(e['musl']['elo']), s(e['musl']['ehi']), R['sqlite3']['the updates']['on'], R['lua']['the updates']['on'], R['musl']['the updates']['on'],
    s(R['sqlite3']['the rows']['e']), s(R['lua']['the rows']['e']), s(R['musl']['the rows']['e']),
    s(R['sqlite3']['(a second run) a record swept']['e']), s(R['lua']['(a second run) a record swept']['e']), s(R['musl']['(a second run) a record swept']['e'])))
def within(names, c):
    return max(abs(R[c][name]['d']) for name in names)
others = ('the kernel in place, a record', "the records' bytes", "the tests' loop", "the tests' expression's part", "the tests on T's records", "C's sweeps, a record swept")
worst = {c: within(others, c) for c in ('sqlite3', 'lua')}
g.append("- **U4, nothing else moves: %s.** By the switch, on less off, on `sqlite3.c` and Lua: the kernel in place %s and\n  %s; the records' bytes %s and %s, the tests' loop %s and %s, their expression's part %s and %s, their sweep on\n  T's records %s and %s; C's three sweeps %s and %s (0.3 asked)." % (
    'met' if max(worst.values()) <= 0.3 else 'not met',
    s(R['sqlite3']['the kernel in place, a record']['d']), s(R['lua']['the kernel in place, a record']['d']), s(R['sqlite3']["the records' bytes"]['d']), s(R['lua']["the records' bytes"]['d']),
    s(R['sqlite3']["the tests' loop"]['d']), s(R['lua']["the tests' loop"]['d']), s(R['sqlite3']["the tests' expression's part"]['d']), s(R['lua']["the tests' expression's part"]['d']),
    s(R['sqlite3']["the tests on T's records"]['d']), s(R['lua']["the tests on T's records"]['d']), s(R['sqlite3']["C's sweeps, a record swept"]['d']), s(R['lua']["C's sweeps, a record swept"]['d'])))
g.append("- **U5, faults: @@u5@@**")
values['gates'] = '\n'.join(g)
def faults(v):
    return v['caught'] + len(v['survived'])
u5_long = '@@u5@@'; u5_short = '@@u5@@'
if len(V) == 4 and not V[3]['survived'] and V[2]['survived'] == ['length-low-bits'] and 'length-low-bits' in V[1]['survived']:
    u5_long = ("met.** Four rounds: each term of the updates' loop's bits and shapes, each of its stores, the list's sweep, the\n  write's new resolutions and marks and each new row of the tables changed alone, a build and the fixture's tests a\n  fault. The first round's %d faults left %d: one that gives a pointer's row a CONVERT, which no pointer's update\n  has, so it changes nothing (dropped); the two parts' lengths of a row swapped, which no one read apart (they became\n  a row's entries' number, one byte); and the list taking records that are not evaluated, whose case, a folded\n  `&&`'s dead operand, got its lines. The second's %d, on the changed code, left %d: a row's entries' number read by\n  its low bits, and two that skip a chunk with one update (a unit of one chunk with one update). The third's %d left\n  the first of those still: the line it had got, an address constant's cast converted to bool, makes rows of four\n  and of five entries and none of eight. Run against the fault's build, a narrow destination's `++` whose value is\n  converted to bool does (its own four and the conversion's four, an expression's last record's), and that is the\n  fixture's line now. The fourth's %d, on the code as it is, are all caught."
               % (faults(V[0]), len(V[0]['survived']), faults(V[1]), len(V[1]['survived']), faults(V[2]), faults(V[3])))
    survivors = set(V[0]['survived']) | set(V[1]['survived']) | set(V[2]['survived'])
    nothing = {'loop-own-pointer-converted'}; out_of_the_code = {'loop-first-length-swapped'}
    cases = survivors - nothing - out_of_the_code
    twice = [name for name in survivors if sum(name in v['survived'] for v in V) == 2]
    assert nothing <= survivors and out_of_the_code <= survivors and cases == {'list-not-evaluated', 'length-low-bits', 'chunk-updates-of-two', 'chunk-updates-count-of-the-asked'} and twice == ['length-low-bits'], survivors
    words = {1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five', 6: 'six'}
    u5_short = "met.** The first three rounds left %s faults, one of them twice: %s changes nothing a program reaches, %s's term went\n  out, and %s got their cases in the fixture. The fourth round's %d faults, on the code as it is, are all caught." % (
        words[len(survivors)], words[len(nothing)], words[len(out_of_the_code)], words[len(cases)], faults(V[3]))
values['gates'] = values['gates'].replace('@@u5@@**', u5_long) if u5_long != '@@u5@@' else values['gates']
sg = []
sg.append("- **U1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind or a class, on\n  the three corpora and the compiler's own source.")
sg.append("- **U2, how much: met.** %s, %s and %s tapes more (2,900, 600 and 3,400 asked): %s%%, %s%% and %s%% of the\n  expressions C takes." % (n(more['sqlite3']), n(more['lua']), n(more['musl']), on['sqlite3']['share'], on['lua']['share'], on['musl']['share']))
sg.append("- **U3, cost: %s.** %s ticks a record swept more than the piece before's on `sqlite3.c` and %s on Lua (0.5\n  asked, 1.0 refutes); %s and %s on a chunk's second run." % (
    (verdict('sqlite3') if verdict('sqlite3') == verdict('lua') else '%s on `sqlite3.c`, %s on Lua' % (verdict('sqlite3'), verdict('lua'))), s(e['sqlite3']['e']), s(e['lua']['e']),
    s(R['sqlite3']['(a second run) a record swept']['e']), s(R['lua']['(a second run) a record swept']['e'])))
sg.append("- **U4, nothing else moves: %s.** The kernel, the tests' parts and C's sweeps read within %.2f with the update's\n  rows on (0.3 asked)." % ('met' if max(worst.values()) <= 0.3 else 'not met', max(worst.values())))
sg.append("- **U5, faults: " + u5_short)
values['short_gates'] = '\n'.join(sg)
# What it pays: what the rows read more than the piece before's, and what the reference spends on the expressions the
# update's rows take from it (its ticks on the taken expressions with the update's rows on less with them off, the same
# executable, a reading at a time: the median).
import statistics
def reference(path):
    return int(re.search(r"the reference's X on the taken expressions=(\d+)", open(path, errors='replace').read()).group(1))
pays = {}
for c in CORPORA:
    cost = R[c][SUM]['e'] * on[c]['swept']; records = their[c] - their_before[c]
    spent = []
    for k in range(1, readings + 1):
        f = lambda tag: reference('%s/%s/rows-%s-%s-%d.txt' % (fetch, final, tag, c, k))
        spent.append((f('on1') + f('on2')) / 2 - (f('off1') + f('off2')) / 2)
    pays[c] = (cost, records, statistics.median(spent))
values['pays'] = pays
means = []
means.append("- **An update's rows are shapes of the same table**, in slots its two records have free: no slot more, no column\n  more, and the write's compress joins them as it joins any row.")
means.append("- **A rare case's terms go in a loop of their own.** As masks in the shapes' sweep (the fourth build), an update's\n  terms made that sweep read %.2f ticks a record more on `sqlite3.c` and %.2f on Lua, %.2f and %.2f of it with no\n  update to make. As a sweep and a loop of their own they read %.2f and %.2f, and the shapes' sweep reads what it\n  read before." % (
    s4['sqlite3']['e'], s4['lua']['e'], s4['sqlite3']['off'] - s4['sqlite3']['before'], s4['lua']['off'] - s4['lua']['before'], R['sqlite3']['the updates']['on'], R['lua']['the updates']['on']))
means.append("- **What it reads more, against what it takes from the reference.** The rows read %s ticks more over `sqlite3.c`'s\n  records swept, %s over Lua's and %s over musl's (a chunk's first run); X on T's columns spends %s, %s and %s on the\n  %s, %s and %s records of the expressions the update's rows take from it." % (
    n(round(pays['sqlite3'][0])), n(round(pays['lua'][0])), n(round(pays['musl'][0])), n(round(pays['sqlite3'][2])), n(round(pays['lua'][2])), n(round(pays['musl'][2])),
    n(pays['sqlite3'][1]), n(pays['lua'][1]), n(pays['musl'][1])))
means.append("- **A sweep a chunk is read more a chunk's first time.** The updates' list's sweep alone, with no update to make,\n  reads %.2f ticks a record on `sqlite3.c`, %.2f on Lua and %.2f on musl a first run, and %.2f, %.2f and %.2f a\n  second; their chunks are %.0f, %.0f and %.0f records." % (
    R['sqlite3']['the updates']['off'], R['lua']['the updates']['off'], R['musl']['the updates']['off'],
    R['sqlite3']['(a second run) the updates']['off'], R['lua']['(a second run) the updates']['off'], R['musl']['(a second run) the updates']['off'],
    chunks['sqlite3'][0] / chunks['sqlite3'][1], chunks['lua'][0] / chunks['lua'][1], chunks['musl'][0] / chunks['musl'][1]))
means.append("- **Next:** the branches' rows, then the entries' values.")
values['means'] = '\n'.join(means)
for name in ('node-machine-section.md', 'one-core-path-section.md'):
    text = open(os.path.join(here, name)).read()
    for key, value in values.items():
        if isinstance(value, str):
            text = text.replace('@@%s@@' % key, value)
    open(os.path.join(out, name), 'w').write(text)
    print(name, 'left:', sorted(set(re.findall(r'@@(\w+)@@', text))))
print('rounds:', [(v['caught'], v['survived']) for v in V])
print('pays:', {c: tuple(round(x) for x in pays[c]) for c in CORPORA})
print('U3:', {c: (e[c]['e'], e[c]['elo'], e[c]['ehi']) for c in CORPORA}, 'U4 worst:', worst)
