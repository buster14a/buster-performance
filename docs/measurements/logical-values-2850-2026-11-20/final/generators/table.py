#!/usr/bin/env python3
# table.py VALUES.json [short]: the measured table of the write-ups, from the final readings' numbers (values.py): a
# row a line, a column a corpus. `short` leaves the parts' rows out (the summary page's and the note's).
import json, sys
v = json.load(open(sys.argv[1]))['final']
short = len(sys.argv) > 2
C = ('sqlite3', 'lua', 'musl')
def n(x): return format(int(x), ',')
def row(label, cell):
    print('| %s | %s |' % (label, ' | '.join(cell(v[c]) for c in C)))
def rng(line, field='d'):
    return lambda t: '%s (%s to %s)' % (t[line][field], t[line][field + '_lo'], t[line][field + '_hi'])
def both(line):
    return lambda t: '%s; %s; **%s (%s to %s)**' % (t[line]['on'], t[line]['before'], t[line]['d'], t[line]['d_lo'], t[line]['d_hi'])
def plain(line):
    return lambda t: '%s; %s; %s (%s to %s)' % (t[line]['on'], t[line]['before'], t[line]['d'], t[line]['d_lo'], t[line]['d_hi'])
print('| | `sqlite3.c` | Lua | musl |')
print('| --- | ---: | ---: | ---: |')
row('expressions C decides on the window; the piece before\'s', lambda t: '%s; %s' % (n(t['counts on']['decided']), n(t['counts before']['decided'])))
row('**expressions whose tape X makes, whole; the piece before\'s**', lambda t: '**%s**; %s' % (n(t['counts on']['taken']), n(t['counts before']['taken'])))
row('more of them', lambda t: '+%s (%.2f%% of the expressions)' % (n(t['counts on']['taken'] - t['counts before']['taken']), 100.0 * (t['counts on']['taken'] - t['counts before']['taken']) / t['counts on']['expressions']))
row('their records; the piece before\'s', lambda t: '%s; %s' % (n(t['counts on']['records']), n(t['counts before']['records'])))
row('answers of C\'s; tapes of X\'s that differ from the reference\'s', lambda t: '%d; %d' % (t['counts on']['c_differences'], t['counts on']['differences']))
row('operators\' values C takes; of them listed for their target; commas', lambda t: '%s; %s; %s' % (n(t['more on']['valued']), n(t['more on']['sunk']), n(t['more on']['commas'])))
row('listed for a logical operator or a conditional; the piece before\'s', lambda t: '%s; %s' % (n(t['more on']['logical']), n(t['more before']['logical'])))
row('listed for a comma; the piece before\'s (a selection among them)', lambda t: '%s; %s' % (n(t['more on']['comma']), n(t['more before']['comma'])))
row('listed for X by a turn (an arm with no room, a narrow second operand)', lambda t: '%s' % n(t['counts on']['listed'][1] - t['counts before']['listed'][1]))
row('expressions numbered; the piece before\'s', lambda t: '%s; %s' % (n(t['counts on']['numbered']), n(t['counts before']['numbered'])))
row('**C\'s sweeps, a record of the decided, a chunk\'s second run; the piece before\'s; more**', both('(a second run) C, a record of the decided'))
row('**the rows\' sweeps, a record of the taken, a second run; the piece before\'s; more**', both('(a second run) a record of the taken'))
row('C\'s sweeps, a record of the decided, a first run; the piece before\'s; more', plain('C, a record of the decided'))
row('the rows\' sweeps, a record of the taken, a first run; the piece before\'s; more', plain('the rows, a record of the taken'))
row('C\'s sweeps, a record swept: a first run, more; a second, more', lambda t: '%s; %s' % (rng("C's sweeps, a record swept")(t), rng("(a second run) C's sweeps, a record swept")(t)))
row('the rows\' sweeps, a record swept: a first run, more; a second, more', lambda t: '%s; %s' % (rng("the rows' sweeps, a record swept")(t), rng('(a second run) a record swept')(t)))
row('**the rows\' sweeps, a first run less a second, ticks a chunk; the piece before\'s; more**', both("the rows' sweeps: a chunk's first run less its second, ticks a chunk"))
row('C\'s sweeps, a first run less a second, ticks a chunk; the piece before\'s; more', plain("C's sweeps: a chunk's first run less its second, ticks a chunk"))
if not short:
    row('C\'s loop, a record swept: a first run; the piece before\'s; more', plain("C's loop"))
    row('C\'s loop, a second run; the piece before\'s; more', plain("(a second run) C's loop"))
    row('C\'s targets; its expression\'s part: more', lambda t: '%s; %s' % (t["C's targets"]['d'], t["C's expression's part"]['d']))
    row('the rows\' reads; shapes; write: more', lambda t: '%s; %s; %s' % (t['the reads']['d'], t['the shapes']['d'], t['the rows']['d']))
    row('the updates\' and the branches\' lists and loops: a first run; the piece before\'s; more', plain('the updates and the branches'))
    row('the values: a first run; the piece before\'s; more', plain('the values'))
    row('the values, a second run; the piece before\'s; more', plain('(a second run) the values'))
row('the kernel in place, more; the tests on the window, more', lambda t: '%s; %s' % (rng('the kernel in place, a record')(t), rng('the tests on the window, a record')(t)))
row('the reference\'s C, a record of the decided; its X, a record of the taken', lambda t: '%s; %s' % (t["the reference's C, a record of the decided"]['on'], t["the reference's X, a record of the taken"]['on']))
row('records a chunk; chunks', lambda t: '%d; %s' % (round(t['counts on']['swept'] / t['counts on']['chunks']), n(t['counts on']['chunks'])))
