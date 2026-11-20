#!/usr/bin/env python3
# census-table.py: the specification's table of the values' census, from the simulation's outputs beside this file
# (sim-sqlite3.txt, sim-lua.txt, sim-musl.txt, sim-own.txt): a row a source of a value, its entries and those whose value is not
# zero; no rule of the simulation may have a wrong entry.
import re, os
here = os.path.dirname(os.path.abspath(__file__))
C = ('sqlite3', 'lua', 'musl', 'own')
T = {c: open('%s/sim-%s.txt' % (here, c)).read() for c in C}
assert all('WRONG' not in T[c] for c in C)
def head(c):
    m = re.search(r'records (\d+), with a value that is not zero (\d+) \(([\d.]+)%\); entries (\d+) \(([\d.]+) a record\)', T[c])
    z = re.search(r'entries with a value that is not zero: (\d+) \(([\d.]+)% of the entries, ([\d.]+) a record\)', T[c])
    return dict(records=int(m.group(1)), valued=int(m.group(2)), entries=int(m.group(4)), nonzero=int(z.group(1)), share=z.group(2), a_record=z.group(3))
def source(c, name):
    m = re.search(r'^%s\s+(\d+)\s+([\d.]+)%%\s+(\d+)\s+(\d+)$' % re.escape(name), T[c], re.M)
    return (int(m.group(1)), int(m.group(3)), int(m.group(4))) if m else (0, 0, 0)
def n(x):
    return '{:,}'.format(x)
H = {c: head(c) for c in C}
def expressions(c):
    return sum(int(x) for x in re.findall(r'^\s+(\d+) \(\s*[\d.]+%\) calls', T[c], re.M))
def numbered(c):
    m = re.search(r'expressions with two or more of them together: (\d+) \(([\d.]+)%\)', T[c])
    return int(m.group(1)), m.group(2)
rows = [('expressions the rows take; their records', lambda c: '%s; %s' % (n(expressions(c)), n(H[c]['records']))),
        ('their entries; those whose value is not zero', lambda c: '%s; %s (%s%%)' % (n(H[c]['entries']), n(H[c]['nonzero']), H[c]['share'])),
        ('values that are not zero, a record', lambda c: H[c]['a_record'])]
SOURCES = (("its record's object: a name's read, an address constant's, an update's read by name", "its record's object"),
           ("its destination's record's object: a store or an update by name", "its destination's record's object"),
           ("an integer constant's bits, by its class", "an integer constant's bits, by its class"),
           ("a folded constant's, by its target's class; to bool", ("a folded constant's bits, by its target's class", "a folded constant's, to bool")),
           ("a member's offset in bytes", "a member's offset in bytes"),
           ("the 1 of an offset's sum (a member's, an address constant's)", "an offset's sum (1)"),
           ("an address constant's offset", "an address constant's offset (its payload)"),
           ("a pointer's stride (a sum's, a subscript's)", "a pointer's stride (its first operand's conversion's)"),
           ("a pointer's update's stride; its step's 1", ("a pointer's update's stride (its own type's)", "a pointer's update's step (1)")),
           ("an update's step: one, of the class it is computed in", "an update's step: one, of the class it is computed in"),
           ("a floating constant's bits", "a floating constant's bits (its significand and exponent, converted)"),
           ("a branch's label: the control's", "a branch's label: the control's"),
           ("a branch's label: an operator's own", "a branch's label: an operator's own (its preorder number among the labeled)"),
           ("a call's row", "a call's row (its preorder number among the expression's calls)"),
           ("a temporary's number", "a temporary's number"),
           ("an access's value (a vector's bytes, else 0)", "an access's value (a vector's bytes, else 0)"),
           ("a test's zero", "a test's zero"),
           ("none: an operation's, a conversion's, a discard's", "none (0)"))
total_checked = {c: 0 for c in C}
print('| | `sqlite3.c` | Lua | musl | the compiler\'s own source |')
print('| --- | ---: | ---: | ---: | ---: |')
for name, f in rows:
    print('| %s | %s |' % (name, ' | '.join(f(c) for c in C)))
print('| **by its source: entries; of them not zero** | | | | |')
for name, keys in SOURCES:
    keys = keys if isinstance(keys, tuple) else (keys,)
    cells = []
    for c in C:
        e = sum(source(c, k)[0] for k in keys); z = sum(source(c, k)[1] for k in keys); w = sum(source(c, k)[2] for k in keys)
        assert w == 0
        total_checked[c] += e
        cells.append('%s; %s' % (n(e), n(z)))
    print('| %s | %s |' % (name, ' | '.join(cells)))
assert all(total_checked[c] == H[c]['entries'] for c in C), (total_checked, {c: H[c]['entries'] for c in C})
print('| **expressions with two or more of an evaluated call, a labeled operator and a postfix update through an address** | %s |' % ' | '.join('%s (%s%%)' % (n(numbered(c)[0]), numbered(c)[1]) for c in C))
