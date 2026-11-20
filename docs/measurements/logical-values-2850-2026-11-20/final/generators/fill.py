#!/usr/bin/env python3
# fill.py TEMPLATE VALUES.json [KEY=FILE...]: a write-up's template with its numbers filled in:
#   {{corpus|line|field}}   a reading or a count of values.json's final table (an integer count gets its commas);
#   {{xl1:corpus|line|field}}, {{xl2:...}}   the same of a build's table;
#   {{=expression}}         a Python expression over `v` (values.json) and the helpers n() (commas), f() (two decimals),
#                           d(keys...) (a derived value, derive.py's), three(name) (a derived value of the three corpora,
#                           "a, b and c"), rng(corpus, line[, table]) (a difference with its range), more(table, corpus) (the expressions more taken) and
#                           val(corpus, line[, field[, table]]);
#   {{file:KEY}}            the text of a file given as KEY=FILE (itself filled).
# A placeholder that names nothing fails the run: no number is typed by hand.
import json, re, sys
v = json.load(open(sys.argv[2]))
files = dict(a.split('=', 1) for a in sys.argv[3:])
def n(x): return format(int(x), ',')
def f(x): return '%.2f' % float(x)
def d(*keys):
    x = v['derived']
    for k in keys: x = x[k]
    return n(x) if isinstance(x, int) else str(x)
def three(name, suffix='', last=' and '):
    a = [d(c, name) + suffix for c in ('sqlite3', 'lua', 'musl')]
    return a[0] + ', ' + a[1] + last + a[2]
def count(x):
    return 'none' if int(x) == 0 else n(x)
def rng(corpus, line, table='final'):
    t = v[table][corpus][line]
    return '%s (%s to %s)' % (t['d'], t['d_lo'], t['d_hi'])
def val(corpus, line, field='d', table='final'):
    return v[table][corpus][line][field]
def more(table, corpus):
    t = v[table][corpus]
    return '+' + n(t['counts on']['taken'] - t['counts before']['taken'])
def rose(corpus, line="C's sweeps: a chunk's first run less its second, ticks a chunk"):
    x = v['final'][corpus][line]['d']
    assert x.startswith('+'), x
    return x[1:]
def one(m):
    key = m.group(1)
    if key.startswith('='):
        return str(eval(key[1:], {'v': v, 'n': n, 'f': f, 'd': d, 'three': three, 'rng': rng, 'val': val, 'more': more, 'rose': rose, 'count': count, 'len': len, 'float': float}))
    if key.startswith('file:'):
        return fill(open(files[key[5:]]).read()).rstrip('\n')
    table = 'final'
    if ':' in key.split('|')[0]:
        table, key = key.split(':', 1)
    corpus, line, field = key.split('|')
    value = v[table][corpus][line][field]
    return n(value) if isinstance(value, int) else str(value)
def fill(text):
    return re.sub(r'\{\{(.*?)\}\}', one, text)
sys.stdout.write(fill(open(sys.argv[1]).read()))
