#!/usr/bin/env python3
# fill.py TEMPLATE ALL.json [KEY=FILE...]: a write-up's template with its numbers filled in:
#   {{=expression}}   a Python expression over `v` (all.json, values.py's) and the helpers below;
#   {{file:KEY}}      the text of a file given as KEY=FILE (itself filled).
# A placeholder that names nothing fails the run: no number is typed by hand.
#   n(x)                       an integer with its commas; count(x) the same, "none" where zero;
#   four(key[, how[, wall]])   the four corpora's counts of the code here, "a, b, c and d" (wall: with -Wall -Wextra);
#   fourpair(key[, wall])      a table's four cells, each "here; before";
#   x(corpus, key[, digits])   a 9700X reading's median with its range, "0.28 (0.27 to 0.29)"; xs(...) with signs;
#   three(key[, digits]), threes(...)   the three corpora's, "a, b and c";
#   xn(corpus, key)            a 9700X count;
#   must(condition)            nothing, or the run fails: beside a verdict's word, the numbers that make it true.
import json, re, sys
v = json.load(open(sys.argv[2]))
files = dict(a.split('=', 1) for a in sys.argv[3:])
SETS = ('default', 'wall', 'everything')
UNITS = ('sqlite', 'lua', 'musl', 'main')
CORPORA = ('sqlite3', 'lua', 'musl')
def n(x): return format(int(x), ',')
def count(x): return 'none' if int(x) == 0 else n(x)
def join(items, last=' and '):
    items = list(items)
    return items[0] if len(items) == 1 else ', '.join(items[:-1]) + last + items[-1]
def semi(items): return '; '.join(items)
def cells(items): return ' | '.join(items)
def four(key, how=n, wall=False): return join([how(v['corpora'][u + ('-wall' if wall else '')][key]) for u in UNITS])
def fourcells(key, how=n, wall=False): return cells([how(v['corpora'][u + ('-wall' if wall else '')][key]) for u in UNITS])
def fourpair(key, wall=False):
    w = '-wall' if wall else ''
    return ' | '.join('%s; %s' % (n(v['corpora'][u + w][key]), n(v['corpora_before'][u + w][key])) for u in UNITS)
def x(corpus, key, digits=2):
    s = v['x'][corpus][key]
    return '%.*f (%.*f to %.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
def xs(corpus, key, digits=2):
    s = v['x'][corpus][key]
    return '%+.*f (%+.*f to %+.*f)' % (digits, s['median'], digits, s['low'], digits, s['high'])
def xm(corpus, key): return v['x'][corpus][key]['median']
def xn(corpus, key): return v['x'][corpus][key]
def three(key, digits=2): return join([x(c, key, digits) for c in CORPORA])
def threes(key, digits=2): return join([xs(c, key, digits) for c in CORPORA])
def must(condition):
    if not condition:
        raise SystemExit('a verdict does not hold')
    return ''
names = dict(v=v, n=n, count=count, join=join, semi=semi, cells=cells, fourcells=fourcells, four=four, fourpair=fourpair, x=x, xs=xs, xm=xm, xn=xn, three=three, threes=threes, must=must, SETS=SETS, UNITS=UNITS,
             CORPORA=CORPORA, len=len, sum=sum, max=max, min=min, abs=abs, str=str, int=int, float=float, round=round, all=all, any=any, sorted=sorted)
def fill(text):
    def expression(m):
        try:
            return str(eval(m.group(1), dict(names)))
        except SystemExit:
            raise SystemExit('a verdict does not hold: ' + m.group(1)[:200])
    def file(m):
        return fill(open(files[m.group(1)]).read()).rstrip('\n')
    text = re.sub(r'\{\{file:([a-z0-9_]+)\}\}', file, text)
    return re.sub(r'\{\{=(.*?)\}\}', expression, text, flags=re.S)
sys.stdout.write(fill(open(sys.argv[1]).read()))
