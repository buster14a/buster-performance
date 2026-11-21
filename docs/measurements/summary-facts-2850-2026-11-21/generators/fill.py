#!/usr/bin/env python3
# fill.py TEMPLATE ALL.json [KEY=FILE...]: a write-up's template with its numbers filled in:
#   {{=expression}}   a Python expression over `v` (all.json, values.py's) and the helpers below;
#   {{file:KEY}}      the text of a file given as KEY=FILE (itself filled).
# A placeholder that names nothing fails the run: no number is typed by hand.
#   n(x)                         an integer with its commas; count(x) the same, "none" where zero;
#   val(corpus, key[, digits[, build]])     a reading's median, as "0.28" (build: None the frozen code's, 'repeat', or
#                                an earlier build's name); sval(...) the same with its sign, "+0.28";
#   rng(corpus, key[, digits[, build]])     "0.28 (0.27 to 0.29)"; srng(...) with signs;
#   three(key[, how[, build]]), threev(key[, digits[, build]]), threes(...)   the three corpora's counts, medians and
#                                signed medians, "a, b and c";
#   cloud(unit, key[, how]), four(key[, how])  the cloud container's counts of a unit (sqlite, lua, musl, main; unit-wall
#                                with the warnings), and the four units', "a, b, c and d";
#   one_in(corpus[, key])        the records swept a call asked, "1,260";
#   xval/xsval/xrng/xsrng(corpus, key[, digits[, which]])   an experiment build's readings ('experiment', 'experiment2');
#   census_rows([first cells...])  the census's own table's header and the rows whose first cell starts so;
#   census_cells(first cell, part)  one part of each of that row's four cells, "a, b, c and d";
#   must(condition)              nothing, or the run fails: beside a verdict's word, the numbers that make it true.
import json, re, sys
v = json.load(open(sys.argv[2]))
files = dict(a.split('=', 1) for a in sys.argv[3:])
CORPORA = ('sqlite3', 'lua', 'musl')
UNITS = ('sqlite', 'lua', 'musl', 'main')
def n(x): return format(int(x), ',')
def count(x): return 'none' if int(x) == 0 else n(x)
def table(build): return v['final'] if build is None else v['repeat'] if build == 'repeat' else v['builds'][build]
def med(corpus, key, build=None): return table(build)[corpus][key]['median']
def low(corpus, key, build=None): return table(build)[corpus][key]['low']
def high(corpus, key, build=None): return table(build)[corpus][key]['high']
def val(corpus, key, digits=2, build=None): return '%.*f' % (digits, med(corpus, key, build))
def sval(corpus, key, digits=2, build=None): return '%+.*f' % (digits, med(corpus, key, build))
def rng(corpus, key, digits=2, build=None):
    s = table(build)[corpus][key]
    return '%.*f (%.*f to %.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
def srng(corpus, key, digits=2, build=None):
    s = table(build)[corpus][key]
    return '%+.*f (%+.*f to %+.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
def join(items, last=' and '):
    items = list(items)
    return items[0] if len(items) == 1 else ', '.join(items[:-1]) + last + items[-1]
def three(key, how=n, build=None): return join([how(table(build)[c][key]) for c in CORPORA])
def threev(key, digits=2, build=None): return join([val(c, key, digits, build) for c in CORPORA])
def threes(key, digits=2, build=None): return join([sval(c, key, digits, build) for c in CORPORA])
def threer(key, digits=2, build=None): return join([rng(c, key, digits, build) for c in CORPORA])
def threesr(key, digits=2, build=None): return join([srng(c, key, digits, build) for c in CORPORA])
def cloud(unit, key, how=n): return how(v['cloud'][unit][key])
def four(key, how=n, wall=False): return join([how(v['cloud'][u + ('-wall' if wall else '')][key]) for u in UNITS])
def one_in(corpus, key='suspects'): return n(round(v['final'][corpus]['swept'] / v['final'][corpus][key]))
def xval(corpus, key, digits=2, which='experiment'): return '%.*f' % (digits, v[which][corpus][key]['median'])
def xsval(corpus, key, digits=2, which='experiment'): return '%+.*f' % (digits, v[which][corpus][key]['median'])
def xrng(corpus, key, digits=2, which='experiment'):
    s = v[which][corpus][key]
    return '%.*f (%.*f to %.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
def xsrng(corpus, key, digits=2, which='experiment'):
    s = v[which][corpus][key]
    return '%+.*f (%+.*f to %+.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
def census_lines():
    return [l.rstrip('\n') for l in open(v['census_dir'] + '/table.md')]
def census_rows(firsts):
    lines = census_lines()
    rows = lines[:2]
    for first in firsts:
        found = [l for l in lines[2:] if l.startswith('| ' + first)]
        if len(found) != 1:
            raise SystemExit('census row %r: %d' % (first, len(found)))
        rows.append(found[0])
    return '\n'.join(rows)
def census_cells(first, part):
    found = [l for l in census_lines()[2:] if l.startswith('| ' + first)]
    if len(found) != 1:
        raise SystemExit('census row %r: %d' % (first, len(found)))
    cells = [c.strip() for c in found[0].replace('\\|', '\x00').strip('|').split('|')][1:]
    return join([c.replace('*', '').split(';')[part].strip() for c in cells])
def must(condition):
    if not condition:
        raise SystemExit('a verdict does not hold')
    return ''
names = dict(v=v, n=n, count=count, val=val, sval=sval, rng=rng, srng=srng, three=three, threev=threev, threes=threes, threer=threer, threesr=threesr, cloud=cloud, four=four,
             one_in=one_in, join=join, len=len, float=float, int=int, round=round, CORPORA=CORPORA, UNITS=UNITS, sum=sum, max=max, min=min, abs=abs, str=str, med=med, low=low,
             high=high, xval=xval, xsval=xsval, xrng=xrng, xsrng=xsrng, census_rows=census_rows, census_cells=census_cells, must=must, all=all, any=any, sorted=sorted)
def fill(text):
    def one(m):
        key = m.group(1)
        if key.startswith('='):
            return str(eval(key[1:], names))
        if key.startswith('file:'):
            return fill(open(files[key[5:]]).read()).rstrip('\n')
        raise SystemExit('unknown placeholder ' + key)
    return re.sub(r'\{\{(.*?)\}\}', one, text, flags=re.S)
sys.stdout.write(fill(open(sys.argv[1]).read()))
