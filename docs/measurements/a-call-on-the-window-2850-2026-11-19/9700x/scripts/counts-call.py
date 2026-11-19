#!/usr/bin/env python3
# counts-call.py SHADOW_DIR [record]: the call piece's counts from the shadow's runs with C on the window on the four
# corpora (the default warnings and -Wall -Wextra, which have to agree): the documents' table, or with `record` the
# record's longer one.
import re, sys
d = sys.argv[1]
record = len(sys.argv) > 2 and sys.argv[2] == 'record'
CORPORA = (('sqlite', '`sqlite3.c`'), ('lua', 'Lua'), ('musl', 'musl'), ('main', 'the compiler\'s own source'))
P = {
    'calls': r"kernel in place's calls: to-make=(\d+)",
    'made': r"kernel in place's calls: to-make=\d+ made=(\d+)",
    'whole': r"with-every-argument's-conversion=(\d+)",
    'share': r"with-every-argument's-conversion=\d+ \(([\d.]+)% of the calls to make\)",
    'plain': r"of-them-plain=(\d+)",
    'left': r"left-for-an-argument=(\d+)",
    'kdiff': r"the kernel in place: to-make=\d+ made=\d+ left=\d+ differences=(\d+)",
    'kmade': r"the kernel in place: to-make=\d+ made=(\d+)",
    'kto': r"the kernel in place: to-make=(\d+)",
    'expr': r"window contexts expressions=(\d+)",
    'records': r"window contexts expressions=\d+ records=(\d+)",
    'decided': r"window contexts expressions=\d+ records=\d+ decided=(\d+)",
    'dshare': r"window contexts expressions=\d+ records=\d+ decided=\d+ \(([\d.]+)%\)",
    'drecords': r"their-records=(\d+)",
    'refused': r"of-them-refused=(\d+)",
    'cdiff': r"of-them-refused=\d+ differences=(\d+)",
    'crecords': r"records-that-differ=(\d+)",
    'strides': r"strides-read=(\d+)",
    'asked': r"of-them-asked-of-the-type-table=(\d+)",
    'rules': r"rules-that-read-the-conversions=(\d+)",
    'far': r"out-of-a-block's-reach=(\d+)",
    'swept': r"records-swept=(\d+)",
    'l_call': r"first record's reason: call=(\d+)",
    'l_logic': r"logical-or-conditional=(\d+)",
    'l_update': r"update=(\d+)",
    'l_comma': r"comma-or-selection=(\d+)",
    'l_division': r"division-by-a-constant=(\d+)",
    'l_wide': r"wide-value=(\d+)",
    'l_operator': r"wide-value=\d+ operator=(\d+)",
}
values = {}
for c, _ in CORPORA:
    both = []
    for w in ('', '-Wall-Wextra'):
        t = open('%s/%s--passes0--window-contexts%s--list20.out' % (d, c, w), errors='replace').read()
        both.append({k: re.search(p, t).group(1) for k, p in P.items()})
    assert both[0] == both[1], (c, {k: (both[0][k], both[1][k]) for k in P if both[0][k] != both[1][k]})
    values[c] = both[0]
def n(c, k):
    return '{:,}'.format(int(values[c][k]))
def row(name, f):
    print('| %s | %s |' % (name, ' | '.join(f(c) for c, _ in CORPORA)))
print('| | ' + ' | '.join(name for _, name in CORPORA) + ' |')
print('| --- | ' + ' | '.join('---:' for _ in CORPORA) + ' |')
row('calls the kernel in place is to make', lambda c: n(c, 'calls'))
row('made', lambda c: n(c, 'made'))
row('**with every argument\'s conversion**', lambda c: '**%s (%s%%)**' % (n(c, 'whole'), values[c]['share']))
row('of them plain', lambda c: n(c, 'plain'))
row('left to T for an argument', lambda c: n(c, 'left'))
row('records and conversions that differ from T\'s', lambda c: n(c, 'kdiff'))
if record:
    row('records the kernel in place is to make, and made', lambda c: '%s, %s' % (n(c, 'kto'), n(c, 'kmade')))
    row('expressions the kernel placed and C ran on', lambda c: n(c, 'expr'))
row('**expressions decided on the window**', lambda c: '**%s (%s%%)**' % (n(c, 'decided'), values[c]['dshare']))
if record:
    row('their records', lambda c: n(c, 'drecords'))
row('of them refused, as C refuses them', lambda c: n(c, 'refused'))
row('differ from C' if not record else 'expressions that differ from C\'s, and records', lambda c: n(c, 'cdiff') if not record else '%s, %s' % (n(c, 'cdiff'), n(c, 'crecords')))
row('listed for a call' if not record else 'listed: a call', lambda c: n(c, 'l_call'))
if record:
    row('`&&`, `\\|\\|` or `?:`', lambda c: n(c, 'l_logic'))
    row('an update', lambda c: n(c, 'l_update'))
    row('a comma or a selection', lambda c: n(c, 'l_comma'))
    row('a division by a constant', lambda c: n(c, 'l_division'))
    row('a value the columns don\'t hold whole', lambda c: n(c, 'l_wide'))
    row('another operator', lambda c: n(c, 'l_operator'))
    row('strides read (asked of the type table)', lambda c: '%s (%s)' % (n(c, 'strides'), n(c, 'asked')))
    row('rules that read T\'s two conversions', lambda c: n(c, 'rules'))
    row('consumers and first operands read by loads', lambda c: n(c, 'far'))
    row('records swept', lambda c: n(c, 'swept'))
