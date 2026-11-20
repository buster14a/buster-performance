#!/usr/bin/env python3
# gen-docs.py FETCH FINAL ROUNDS CHECKS OUT: the branches' rows' piece's two design sections, from their templates
# (node-machine-section.md and one-core-path-section.md beside this script) and the numbers of job-xb.sh's readings:
# the five builds' tables (FETCH/xb1-table.txt to xb5-table.txt, by xb-table.py), the final readings' (FETCH/FINAL-table.txt
# and its runs' files), the count before the specification (../before), the cloud container's checks' shadow runs
# (CHECKS/shadow) and probes, the functions' sizes (FETCH/functions.txt, by functions.sh) and the fault rounds' verdicts
# (ROUNDS/roundN.txt). Every number in the output is read or computed here; values.json keeps them for the other write-ups.
import glob, json, os, re, statistics, sys
fetch, final, rounds, checks, out = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
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
    m = re.search(r"^%s\s+%s\s+expressions (\d+) taken (\d+) \(([\d.]+)%%\) entries (\d+) differences (\d+) swept (\d+) written (\d+); listed (\d+) (\d+) (\d+) (\d+); words (\d+) lines (\d+) updates (\d+) branched (\d+); the same in every run: (\w+)\s+\[(\d+) readings\]" % (corpus, which), text, re.M)
    assert m, (corpus, which)
    g = m.groups()
    return dict(expressions=int(g[0]), taken=int(g[1]), share=g[2], entries=int(g[3]), differences=int(g[4]), swept=int(g[5]), written=int(g[6]), update=int(g[7]), branches=int(g[8]),
                conversion=int(g[9]), floating=int(g[10]), words=int(g[11]), lines=int(g[12]), updates=int(g[13]), turns=int(g[14]), same=g[15], readings=int(g[16]))
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
# The switch gives the piece before's answers.
assert all(all(off[c][k] == before[c][k] for k in ('expressions', 'taken', 'entries', 'written', 'update', 'branches', 'conversion', 'floating', 'words', 'lines', 'updates')) and off[c]['turns'] == 0 for c in CORPORA)
assert len(set(on[c]['readings'] for c in CORPORA)) == 1
readings = on['sqlite3']['readings']
assert 'without status 0: 0' in T.splitlines()[0], T.splitlines()[0]
decided = {}; their = {}; their_before = {}; chunks = {}
for c in CORPORA:
    text = open('%s/%s/rows-on1-%s-1.txt' % (fetch, final, c), errors='replace').read()
    m = re.search(r"window contexts expressions=(\d+) records=(\d+) decided=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) of-them-refused=(\d+)", text)
    decided[c] = (int(m.group(3)), int(m.group(7)))
    x = re.search(r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\)", text)
    their[c] = int(x.group(5))
    tb = open('%s/xu8/%s-base1-%s-1.txt' % (fetch, final, c), errors='replace').read()
    their_before[c] = int(re.search(r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+)", tb).group(5))
    k = re.search(r"records-swept=(\d+) roots-apart-from-their-operand=\d+ chunks=(\d+)", text)
    chunks[c] = (int(k.group(1)), int(k.group(2)))
    assert chunks[c][0] == on[c]['swept']
NAMES = ("the rows' sweeps, a record swept", 'the reads', 'the shapes', 'the updates', 'the rows', "an expression's part", 'a record of the taken', "the reference's X, a record of the taken",
         '(a second run) a record swept', '(a second run) the updates', '(a second run) the reads', '(a second run) the shapes', '(a second run) the rows', "(a second run) an expression's part",
         'the kernel in place, a record', 'the tests on the window, a record', "the records' bytes", "the tests' loop", "the tests' expression's part", "the tests on T's records", "C's sweeps, a record swept")
R = {c: {name: row(T, c, name) for name in NAMES} for c in CORPORA}
SUM = "the rows' sweeps, a record swept"
LISTS = 'the updates'
def three(f):
    return ' | '.join(f(c) for c in CORPORA)
values = {}
for c in CORPORA:
    values['expressions_' + c] = n(on[c]['expressions'])
    values['before_branches_' + c] = n(before[c]['branches'])
    values['turns_share_' + c] = '%.2f%%' % (100.0 * on[c]['turns'] / on[c]['swept'])
values['readings'] = {3: 'three', 5: 'five', 7: 'seven'}[readings]
# The count before the specification.
pattern = (r"listed first for branches=(\d+) with another record that lists them=(\d+) alone=(\d+); of those alone: records evaluated as branches=(\d+) of-them-roots=(\d+) tested values=(\d+)"
           r" with a conversion's part=(\d+) of a narrow class=(\d+) rows over eight with the test=(\d+) own entries 0\.\.4=(\d+),(\d+),(\d+),(\d+),(\d+)(?: expressions with such a row=(\d+))?")
count_lines = open(here + '/../before/9700x-count.txt').read().splitlines() + open(here + '/../before/cloud-own-count.txt').read().splitlines()
counted = [re.search(pattern, l).groups() for l in count_lines]
assert len(counted) == 4
C4 = dict(zip(CORPORA + ('main',), counted))
for c in CORPORA:
    assert int(C4[c][0]) == before[c]['branches'] and int(C4[c][6]) == 0, (c, C4[c])
for c in CORPORA + ('main',):
    values['tested_' + c] = n(int(C4[c][5]))
values['main_tested_converted'] = n(int(C4['main'][6]))
# The cloud container's run on the compiler's own source.
def shadow(name):
    text = open('%s/shadow/%s' % (checks, name), errors='replace').read()
    x = re.search(r"window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) their-entries=(\d+) differences=(\d+) not-kept-by-the-reference=(\d+) second-runs-that-differ=(\d+)", text)
    l = re.search(r"window rows listed, by an expression's first record's reason: update=(\d+) branches=(\d+) refused-conversion=(\d+) constant-to-a-floating-class=(\d+)", text)
    return dict(expressions=int(x.group(1)), taken=int(x.group(3)), share=x.group(4), differences=int(x.group(8)), again=int(x.group(10)), update=int(l.group(1)), branches=int(l.group(2)),
                conversion=int(l.group(3)), floating=int(l.group(4)))
cloud = {}
for c, name in (('sqlite3', 'sqlite'), ('lua', 'lua'), ('musl', 'musl'), ('main', 'main')):
    a = shadow('%s--passes0--window-rows--list20.out' % name); b = shadow('%s--passes0--window-rows-Wall-Wextra--list20.out' % name)
    assert a == b and a['differences'] == 0 and a['again'] == 0, (c, a, b)
    cloud[c] = a
status = open('%s/shadow/status.txt' % checks).read().splitlines()
values['cloud_runs'] = str(len([l for l in status if 'status' in l]))
assert all('status 0' in l for l in status if 'status' in l)
values['main_branches'] = n(cloud['main']['branches']); values['main_expressions'] = n(cloud['main']['expressions']); values['main_taken'] = n(cloud['main']['taken'])
values['main_share'] = cloud['main']['share']
for c in CORPORA:
    assert cloud[c]['branches'] == 0
# The builds.
BUILDS = (('xb1', "first: the second list in every chunk, a statement's CONDITION a turn of its own, the loop a function and a clock's read of its own"),
          ('xb2', "one timed region; the bit that lists written where it is set; the second list in a chunk that branches"),
          ('xb3', "a CONDITION takes no turn (the reader writes its sense at its operand); an operand's entries counted once"),
          ('xb4', "the lists' sweep's step in one copy, where the compiler had unrolled it by four"),
          ('xb5', "the branches' loop in the lists' function, its mask in a chunk that branches alone"))
B = {label: table(label) for label, _ in BUILDS}
sizes = {}
for line in open('%s/functions.txt' % fetch):
    m = re.match(r"(\w+) (\w+) (\d+)$", line.strip())
    if m:
        sizes.setdefault(m.group(1), {})[m.group(2)] = int(m.group(3))
def code(label):
    f = sizes[label]
    return f['node_rows_window_updates'] + f.get('node_rows_window_branches', 0)
lines = []
for label, what in BUILDS:
    a = row(B[label], 'sqlite3', SUM); b = row(B[label], 'lua', SUM)
    lines.append('| %s | %.2f | %s | %.2f | %s | %s |' % (what, a['on'], s(a['e']), b['on'], s(b['e']), n(code(label))))
a = R['sqlite3'][SUM]; b = R['lua'][SUM]
lines.append("| the fifth's, an operand's rule with one mask for its shape and its length (%s readings) | **%.2f** | **%s** | **%.2f** | **%s** | %s |" % (
    values['readings'], a['on'], s(a['e']), b['on'], s(b['e']), n(code(final))))
values['builds_table'] = ("| build | `sqlite3.c`, with the branches' rows | more than the piece before's | Lua, with them | more | the lists' and the loops' code, bytes |\n| --- | ---: | ---: | ---: | ---: | ---: |\n"
                          + '\n'.join(lines))
def part(label, corpus, name):
    return row(B[label], corpus, name)
w = {c: on[c]['swept'] for c in CORPORA}; t = {c: on[c]['turns'] for c in CORPORA}
x1 = {c: counts(B['xb1'], c, 'on') for c in CORPORA}; x3 = {c: counts(B['xb3'], c, 'on') for c in CORPORA}
notes = []
notes.append("- **A statement's CONDITION needs no turn.** The first two builds gave every record evaluated as branches a turn:\n  %s on `sqlite3.c`, %s on Lua and %s on musl. A CONDITION's one operand has the CONDITION's own sense, which the\n  reader knows when it registers the expression, so the third build has it write the sense there: %s, %s and %s turns." % (
    n(x1['sqlite3']['turns']), n(x1['lua']['turns']), n(x1['musl']['turns']), n(x3['sqlite3']['turns']), n(x3['lua']['turns']), n(x3['musl']['turns'])))
l3 = {c: part('xb3', c, SUM) for c in ('sqlite3', 'lua')}; l4 = {c: part('xb4', c, SUM) for c in ('sqlite3', 'lua')}
v3 = {c: part('xb3', c, '(a second run) a record swept') for c in ('sqlite3', 'lua')}; v4 = {c: part('xb4', c, '(a second run) a record swept') for c in ('sqlite3', 'lua')}
notes.append("- **The step in one copy.** The compiler had unrolled the lists' sweep's block loop by four, with a remainder's\n  copies: %s bytes of function for %s with `unroll(disable)`, the same work a block. A chunk's first run read\n  %s ticks a record swept more than the piece before's on `sqlite3.c` and %s on Lua unrolled, and %s and %s in one\n  copy; its second run, %s and %s, then %s and %s. A chunk is some %.0f blocks of `sqlite3.c`'s and %.0f of\n  Lua's. What a first run pays for there, the function's bytes or its loops' ends, which a second run over the same\n  chunk has just seen, these readings don't separate." % (
    n(sizes['xb3']['node_rows_window_updates']), n(sizes['xb4']['node_rows_window_updates']), s(l3['sqlite3']['e']), s(l3['lua']['e']), s(l4['sqlite3']['e']), s(l4['lua']['e']),
    s(v3['sqlite3']['e']), s(v3['lua']['e']), s(v4['sqlite3']['e']), s(v4['lua']['e']), chunks['sqlite3'][0] / chunks['sqlite3'][1] / 64.0, chunks['lua'][0] / chunks['lua'][1] / 64.0))
l5 = {c: part('xb5', c, SUM) for c in ('sqlite3', 'lua')}
notes.append("- **The loop where the lists are made.** The fourth build's branches' loop was a function of its own, %s bytes\n  beside the lists' %s; in the lists' function, with its mask computed in a chunk that branches alone, the two are\n  %s bytes, and the rows read %s and %s more than the piece before's (%s and %s before)." % (
    n(sizes['xb4']['node_rows_window_branches']), n(sizes['xb4']['node_rows_window_updates']), n(sizes['xb5']['node_rows_window_updates']), s(l5['sqlite3']['e']), s(l5['lua']['e']),
    s(l4['sqlite3']['e']), s(l4['lua']['e'])))
notes.append("- **`sqlite3.c` moved little, Lua by half.** Across the five builds `sqlite3.c` read from %s to %s more than the\n  piece before's, their readings' ranges overlapping; Lua from %s down to %s." % (
    s(min(part(l, 'sqlite3', SUM)['e'] for l, _ in BUILDS)), s(max(part(l, 'sqlite3', SUM)['e'] for l, _ in BUILDS)), s(max(part(l, 'lua', SUM)['e'] for l, _ in BUILDS)), s(l5['lua']['e'])))
values['builds_notes'] = '\n'.join(notes)
# The final readings.
def cell(name, key='on', fmt='%.2f'):
    return lambda c: fmt % R[c][name][key]
def turn(c, name):
    return R[c][name]['d'] * w[c] / t[c]
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
m.append("| operators with a turn | " + three(lambda c: '%s (%.2f%% of the records swept)' % (n(on[c]['turns']), 100.0 * on[c]['turns'] / on[c]['swept'])) + ' |')
m.append("| **the rows' sweeps and the part, a record swept** | " + three(lambda c: '**%.2f (%.2f to %.2f)**' % (R[c][SUM]['on'], R[c][SUM]['lo'], R[c][SUM]['hi'])) + ' |')
m.append("| the piece before's executable, in the same readings | " + three(cell(SUM, 'before')) + ' |')
m.append("| **more than the piece before's** | " + three(lambda c: '**%s (%s to %s)**' % (s(R[c][SUM]['e']), s(R[c][SUM]['elo']), s(R[c][SUM]['ehi']))) + ' |')
m.append("| with the branches' rows off; on less off | " + three(lambda c: '%.2f; %s' % (R[c][SUM]['off'], s(R[c][SUM]['d']))) + ' |')
m.append('| the reads | ' + three(cell('the reads')) + ' |')
m.append('| the shapes | ' + three(cell('the shapes')) + ' |')
m.append("| the lists and the two loops; with the branches' rows off | " + three(lambda c: '%.2f; %.2f' % (R[c][LISTS]['on'], R[c][LISTS]['off'])) + ' |')
m.append('| the rows | ' + three(cell('the rows')) + ' |')
m.append("| an expression's part | " + three(cell("an expression's part")) + ' |')
m.append("| a second run over the same chunk; the piece before's | " + three(lambda c: '%.2f; %.2f' % (R[c]['(a second run) a record swept']['on'], R[c]['(a second run) a record swept']['before'])) + ' |')
m.append("| the lists and the two loops in it; with the branches' rows off | " + three(lambda c: '%.2f; %.2f' % (R[c]['(a second run) the updates']['on'], R[c]['(a second run) the updates']['off'])) + ' |')
m.append("| the branches' rows, ticks a turn (on less off): a first run; a second | " + three(lambda c: '%.0f; %.0f' % (turn(c, LISTS), turn(c, '(a second run) the updates'))) + ' |')
m.append('| a record of the taken expressions | ' + three(cell('a record of the taken')) + ' |')
m.append("| X on T's columns, a record of theirs, with its values | " + three(cell("the reference's X, a record of the taken")) + ' |')
m.append("| records a chunk; turns a chunk | " + three(lambda c: '%.0f; %.1f' % (chunks[c][0] / chunks[c][1], on[c]['turns'] / chunks[c][1])) + ' |')
values['measured_table'] = '\n'.join(m)
short = [m[0], m[1], m[2], m[8], m[9], m[10], m[11], m[12], m[16], m[19], m[22], m[23]]
values['short_table'] = '\n'.join(short)
# The fault rounds.
def verdicts(path):
    lines = open(path).read().splitlines()
    assert lines[0].startswith('control-passes'), lines[0]
    return dict(caught=len([l for l in lines if l.startswith('caught ')]), survived=[l.split()[1] for l in lines if l.startswith('SURVIVED ')],
                other=[l for l in lines[1:] if not l.startswith(('caught ', 'SURVIVED ', 'job finished'))])
V = [verdicts(p) for p in sorted(glob.glob(rounds + '/round*.txt'))]
assert all(not v['other'] for v in V), [v['other'] for v in V]
values['rounds'] = V
more = {c: on[c]['taken'] - before[c]['taken'] for c in CORPORA}
alone = {c: int(C4[c][2]) for c in CORPORA}
probes = {}
for name in ('earlier', 'cases9', 'cases10', 'cases11', 'cases12'):
    probes[name] = open('%s/probes/%s.txt' % (checks, name)).read().splitlines()
for name in ('cases13', 'cases14'):
    probes[name] = open('%s/%s.txt' % (checks, name)).read().splitlines()
agree = re.compile(r' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 ')
assert all(agree.search(l) for name in probes for l in probes[name]), [l for name in probes for l in probes[name] if not agree.search(l)][:3]
old_probes = sum(len(probes[k]) for k in ('earlier', 'cases9', 'cases10', 'cases11', 'cases12')); new_probes = len(probes['cases13']) + len(probes['cases14'])
values['probes_old'] = n(old_probes); values['probes_new'] = n(new_probes); values['probes_conditions'] = n(len(probes['cases13'])); values['probes_converted'] = n(len(probes['cases14']))
g = []
g.append("- **B1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind or a class, on\n  the three corpora on the 9700X, with the branches' rows on and off. In the cloud container the same on the three\n  and on the compiler's own source (%s tapes of its %s expressions, %s%%), with the default warnings and with\n  `-Wall -Wextra`.@@b1_more@@ And %s one-statement programs, each a file of its own: %s conditions (`&&`, `||` and `!`\n  under an `if`, a `while`, a `do` and a `for`, nested in either operand three deep, a tested value of each class and\n  kind, and conditions C lists), %s tested values that might have a conversion of their own (a decayed array's and\n  function's, a qualified, an atomic and a bit-field's read, a class past double's), and the %s of the pieces before." % (
    values['main_taken'], values['main_expressions'], values['main_share'], n(old_probes + new_probes), values['probes_conditions'], values['probes_converted'], values['probes_old']))
ok2 = all(more[c] >= low for c, low in zip(CORPORA, (2000, 190, 770)))
g.append("- **B2, how much: %s.** %s tapes more on `sqlite3.c`, %s on Lua and %s on musl (2,046, 199 and 790 asked: every\n  expression the count had with no other record that lists it; refuted under 2,000, 190 and 770): %s%%, %s%% and\n  %s%% of the expressions C takes, and %.2f%%, %.2f%% and %.2f%% of those it decides. No expression is listed for\n  branches on the three." % (
    'met' if all(more[c] == alone[c] for c in CORPORA) else ('not met' if ok2 else 'refuted'),
    n(more['sqlite3']), n(more['lua']), n(more['musl']), on['sqlite3']['share'], on['lua']['share'], on['musl']['share'],
    100.0 * on['sqlite3']['taken'] / decided['sqlite3'][0], 100.0 * on['lua']['taken'] / decided['lua'][0], 100.0 * on['musl']['taken'] / decided['musl'][0]))
assert all(on[c]['branches'] == 0 for c in CORPORA)
e = {c: R[c][SUM] for c in CORPORA}
ASKED = {'sqlite3': (0.6, 1.0), 'lua': (0.4, 0.8)}
def verdict(c):
    return 'met' if round(e[c]['e'], 2) <= ASKED[c][0] else 'refuted' if round(e[c]['e'], 2) > ASKED[c][1] else 'not met'
b3 = verdict('sqlite3') if verdict('sqlite3') == verdict('lua') else '%s on `sqlite3.c`, %s on Lua' % (verdict('sqlite3'), verdict('lua'))
g.append("- **B3, cost: %s.** The rows' sweeps and the part read %s ticks a record swept more than the piece before's\n  executable on `sqlite3.c` (%s to %s; 0.6 asked, 1.0 refutes) and %s on Lua (%s to %s; 0.4 asked, 0.8 refutes);\n  %s on musl (%s to %s), which the gate did not name. By the switch, on less off, the lists and the two loops read\n  %s, %s and %s: %.0f, %.0f and %.0f ticks a turn. On a chunk's second run the whole reads %s, %s and %s more than\n  the piece before's." % (
    b3, s(e['sqlite3']['e']), s(e['sqlite3']['elo']), s(e['sqlite3']['ehi']), s(e['lua']['e']), s(e['lua']['elo']), s(e['lua']['ehi']),
    s(e['musl']['e']), s(e['musl']['elo']), s(e['musl']['ehi']), s(R['sqlite3'][LISTS]['d']), s(R['lua'][LISTS]['d']), s(R['musl'][LISTS]['d']),
    turn('sqlite3', LISTS), turn('lua', LISTS), turn('musl', LISTS),
    s(R['sqlite3']['(a second run) a record swept']['e']), s(R['lua']['(a second run) a record swept']['e']), s(R['musl']['(a second run) a record swept']['e'])))
def within(names, c):
    return max(abs(R[c][name]['d']) for name in names)
others = ('the kernel in place, a record', "the records' bytes", "the tests' loop", "the tests' expression's part", "the tests on T's records", "C's sweeps, a record swept")
worst = {c: within(others, c) for c in ('sqlite3', 'lua')}
b4 = 'met' if round(max(worst.values()), 2) <= 0.3 else 'not met'
g.append("- **B4, nothing else moves: %s.** By the switch, on less off, on `sqlite3.c` and Lua: the kernel in place %s and\n  %s; the records' bytes %s and %s, the tests' loop %s and %s, their expression's part %s and %s, their sweep on\n  T's records %s and %s; C's three sweeps %s and %s (0.3 asked)." % (
    b4,
    s(R['sqlite3']['the kernel in place, a record']['d']), s(R['lua']['the kernel in place, a record']['d']), s(R['sqlite3']["the records' bytes"]['d']), s(R['lua']["the records' bytes"]['d']),
    s(R['sqlite3']["the tests' loop"]['d']), s(R['lua']["the tests' loop"]['d']), s(R['sqlite3']["the tests' expression's part"]['d']), s(R['lua']["the tests' expression's part"]['d']),
    s(R['sqlite3']["the tests on T's records"]['d']), s(R['lua']["the tests on T's records"]['d']), s(R['sqlite3']["C's sweeps, a record swept"]['d']), s(R['lua']["C's sweeps, a record swept"]['d'])))
def faults(v):
    return v['caught'] + len(v['survived'])
words = {1: 'one', 2: 'two', 3: 'three', 4: 'four', 5: 'five', 6: 'six', 7: 'seven'}
b5 = '@@b5@@**'; b5_short = '@@b5_short@@**'
NOTHING = {'list-count-not-ended', 'loop-before-the-updates', 'turn-second-before-first', 'operand-narrow-with-void'}
GUARD = {'list-branching-with-two', 'window-branches-count-of-roots'}
REASON = {'reason-a-root-tested'}
if len(V) >= 2 and not V[-1]['survived'] and set(V[0]['survived']) == NOTHING | GUARD | REASON and all(not v['survived'] for v in V[1:]):
    b5 = ("met.** %s rounds: each term of an operand's rule and of an operator's turn, each of their stores, the second\n  list's sweep, the chunk's guard, the reader's sense, each new row of the tables and the listed expression's reason\n  changed alone, a build and the fixture's tests a fault. The first round's %d faults left %d. %s change nothing\n  a program reaches, and are no faults: a count set to the lesser of itself and its block's end, which the loop\n  before it leaves no less; the two loops in the other order (an update that is a tested value has its own part from\n  the one and its conversion's from the other); a second operand given its sense before the first; and void's class\n  taken for a narrow one, which no tested value has (the test is by its upper bound alone now). %s found code to\n  change. The chunk's guard counted the CONDITIONs, which take no turn, so a guard of two for one and a count without\n  them both passed: the count is the turns' now, and a unit of one chunk with one turn separates them (run against\n  the first fault's build before the next round). And the listed expression's reason read its record's consumer\n  behind a test that the record has one, which a fault removed unseen: a build with a line for each listed record\n  with no consumer printed none on the three corpora and the fixture, so the test was a term no record asked. The\n  reason is by the record's own shape now, with no consumer's read. %s" % (
        words[len(V)].capitalize(), faults(V[0]), len(V[0]['survived']), words[len(NOTHING)].capitalize(), words[len(GUARD | REASON)].capitalize(),
        ' '.join("The %s round's %d, on the code as it %s, are all caught." % ({1: 'second', 2: 'third', 3: 'fourth'}[k], faults(V[k]), 'is' if k == len(V) - 1 else 'was then') for k in range(1, len(V)))))
    b5_short = "met.** The first round's %d faults left %d: %s change nothing a program reaches, and %s found code to change\n  (the chunk's guard's count, and the listed expression's reason, which reads no consumer now). The\n  last round's %d faults, on the code as it is, are all caught.**" % (
        faults(V[0]), len(V[0]['survived']), words[len(NOTHING)], words[len(GUARD | REASON)], faults(V[-1]))
    b5_short = b5_short[:-2]
g.append("- **B5, faults: " + b5)
values['gates'] = '\n'.join(g)
sg = []
sg.append("- **B1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind or a class, on\n  the three corpora and the compiler's own source.")
sg.append("- **B2, how much: %s.** %s, %s and %s tapes more (2,046, 199 and 790 asked): %s%%, %s%% and %s%% of the\n  expressions C takes." % ('met' if all(more[c] == alone[c] for c in CORPORA) else ('not met' if ok2 else 'refuted'),
    n(more['sqlite3']), n(more['lua']), n(more['musl']), on['sqlite3']['share'], on['lua']['share'], on['musl']['share']))
sg.append("- **B3, cost: %s.** %s ticks a record swept more than the piece before's on `sqlite3.c` (0.6 asked, 1.0 refutes)\n  and %s on Lua (0.4 and 0.8); %s and %s on a chunk's second run." % (
    b3, s(e['sqlite3']['e']), s(e['lua']['e']), s(R['sqlite3']['(a second run) a record swept']['e']), s(R['lua']['(a second run) a record swept']['e'])))
sg.append("- **B4, nothing else moves: %s.** The kernel, the tests' parts and C's sweeps read within %.2f with the branches'\n  rows on (0.3 asked)." % (b4, max(worst.values())))
sg.append("- **B5, faults: " + b5_short)
values['short_gates'] = '\n'.join(sg)
# What stays a record at a time: the loop's reading, and the update's piece's reading of a rare case's terms in a big
# sweep (its fourth build: the record of that piece).
xu4 = open('/home/user/keep/xupd/fetch/xu4-table.txt').read()
u4 = {c: row(xu4, c, 'the shapes') for c in ('sqlite3', 'lua')}
values['vector_note'] = ("The loop reads %s\nticks a record swept on `sqlite3.c` and %s on Lua by the switch (%.0f and %.0f a turn), and the rows with it %s and\n%s over the piece before's: %s its gate, so that build was not made. What the update's piece read of a rare\ncase's terms in a big sweep stands against it: as masks in the shapes' sweep an update's terms made that sweep\nread %.2f ticks a record more on `sqlite3.c` and %.2f on Lua, %.2f and %.2f of it with no update to make, and an\noperator with a turn is one record in %.0f of `sqlite3.c`'s and one in %.0f of Lua's." % (
    s(R['sqlite3'][LISTS]['d']), s(R['lua'][LISTS]['d']), turn('sqlite3', LISTS), turn('lua', LISTS), s(e['sqlite3']['e']), s(e['lua']['e']),
    'within' if b3 == 'met' else 'not within',
    u4['sqlite3']['e'], u4['lua']['e'], u4['sqlite3']['off'] - u4['sqlite3']['before'], u4['lua']['off'] - u4['lua']['before'], w['sqlite3'] / t['sqlite3'], w['lua'] / t['lua']))
# What it pays.
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
means.append("- **A tested value's test is a shape of the same table**, in the conversion's part its record has free: no slot\n  more, and one column more, a byte a record for a sense.")
means.append("- **What it reads more, against what it takes from the reference.** The rows read %s ticks more over `sqlite3.c`'s\n  records swept and %s over Lua's (a chunk's first run; musl's readings are %s to %s a record); X on T's columns\n  spends %s, %s and %s on the %s, %s and %s records of the expressions the branches' rows take from it." % (
    n(round(pays['sqlite3'][0])), n(round(pays['lua'][0])), s(e['musl']['elo']), s(e['musl']['ehi']), n(round(pays['sqlite3'][2])), n(round(pays['lua'][2])), n(round(pays['musl'][2])),
    n(pays['sqlite3'][1]), n(pays['lua'][1]), n(pays['musl'][1])))
means.append("- **A chunk's first run is the dearer one.** The rows' sweeps read %.2f ticks a record swept on `sqlite3.c`, %.2f on\n  Lua and %.2f on musl a chunk's first run, and %.2f, %.2f and %.2f its second; their chunks are %.0f, %.0f and %.0f\n  records. The fourth build's one copy of a step was read there, and not on a second run." % (
    R['sqlite3'][SUM]['on'], R['lua'][SUM]['on'], R['musl'][SUM]['on'], R['sqlite3']['(a second run) a record swept']['on'], R['lua']['(a second run) a record swept']['on'],
    R['musl']['(a second run) a record swept']['on'], chunks['sqlite3'][0] / chunks['sqlite3'][1], chunks['lua'][0] / chunks['lua'][1], chunks['musl'][0] / chunks['musl'][1]))
means.append("- **The tapes' kinds and classes are made for all but a few expressions:** %s%%, %s%% and %s%% of those C takes on\n  the three corpora, and %s%% of the compiler's own source's, where a qualified bool's read keeps %s listed\n  ([#3185](https://github.com/buster14a/buster/issues/3185))." % (on['sqlite3']['share'], on['lua']['share'], on['musl']['share'], values['main_share'], values['main_branches']))
means.append("- **Next:** the entries' values.")
values['means'] = '\n'.join(means)
for c in CORPORA:
    values['turns_' + c] = n(on[c]['turns']); values['branched_' + c] = n(x1[c]['turns'])
met = [b3 == 'met', b4 == 'met', all(more[c] == alone[c] for c in CORPORA), b5.startswith('met')]
values['verdict_line'] = 'The five gates are met.' if all(met) else 'Its gates: B1 met; B2 %s; B3 %s; B4 %s; B5 %s.' % (
    'met' if met[2] else 'not met', b3, b4, 'met' if met[3] else 'open')
json.dump({k: v for k, v in values.items() if isinstance(v, str)}, open(os.path.join(out, 'values.json'), 'w'), indent=1)
for name in ('node-machine-section.md', 'one-core-path-section.md'):
    text = open(os.path.join(here, name)).read()
    for key, value in values.items():
        if isinstance(value, str):
            text = text.replace('@@%s@@' % key, value)
    open(os.path.join(out, name), 'w').write(text)
    print(name, 'left:', sorted(set(re.findall(r'@@(\w+)@@', text))))
print('rounds:', [(v['caught'], v['survived']) for v in V])
print('pays:', {c: tuple(round(x) for x in pays[c]) for c in CORPORA})
print('B3:', {c: (e[c]['e'], e[c]['elo'], e[c]['ehi']) for c in CORPORA}, b3, 'B4 worst:', worst, b4)
print('more:', more, 'alone:', alone)
