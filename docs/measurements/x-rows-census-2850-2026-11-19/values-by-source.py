#!/usr/bin/env python3
# values-by-source.py CORPUS=FILE.tsv...: the X census's fourth count: each entry's value's source, read off X's code
# by the entry's kind, its part and its record's template (node_machine_own, node_machine_convert, node_machine_hook,
# node_machine_branch_hook, node_machine_update_first and _last): how many entries take each.
import sys, collections
rows = []
for argument in sys.argv[1:]:
    corpus, path = argument.split('=', 1)
    with open(path) as f:
        names = f.readline().rstrip('\n').split('\t')[1:]
        for line in f:
            parts = line.rstrip('\n').split('\t')
            rows.append((int(parts[0]), dict(zip(names, parts[1:]))))
ZERO = {6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22, 23, 24, 25, 26, 27, 35}  # DUP, NEG, NOT, CONVERT, the operations, the comparisons, DISCARD
def source(part, template, kind, position, kinds):
    if kind in ZERO:
        return 'none (0)'
    if kind in (2, 3, 30, 31):
        return "an object's number (the record's, its destination's, or a temporary's)"
    if kind in (4, 5, 32, 33):
        return "an object's symbol (a table by object)"
    if kind in (10, 28, 29):
        return "an access's value (by the class and the type)"
    if kind == 34:
        return "the call's row (a count of calls)"
    if kind in (36, 37, 38, 39):
        return 'a label (a count of labels)'
    if kind == 21:
        # After a CONST of an offset the PTR_ADD's value is 1; a pointer's sum's and an update's is a stride.
        return 'fixed (1)' if position > 0 and kinds[position - 1] == 1 and template in (1, 3, 8) else "a stride (the type's row)"
    if kind == 1:
        if part != 'own':
            return 'fixed (0)'
        if template == 1:
            return "the record's constant (its payload, or its offset)"
        if template == 3:
            return "the record's offset"
        if template == 8:
            return "the member's offset"
        if template == 20:
            return "the update's constant (1, or its power's count or mask)"
        return 'fixed (0 or 1)'
    return 'other kind %d' % kind
counts = collections.Counter()
for n, row in rows:
    for part in ('own', 'conv', 'after'):
        if row[part] == '-':
            continue
        kinds = [int(e.split(':')[0]) for e in row[part].split(',')]
        for position, kind in enumerate(kinds):
            counts[source(part, int(row['tpl']), kind, position, kinds)] += n
total = sum(counts.values())
print('entries %d' % total)
for name, n in counts.most_common():
    print('   %8d (%5.2f%%) %s' % (n, 100.0 * n / total, name))
