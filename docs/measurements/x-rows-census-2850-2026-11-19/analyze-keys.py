#!/usr/bin/env python3
# analyze-keys.py CORPUS=FILE.tsv...: the X census's gates with keys derived as X's code reads them. For each part
# and each answer (the number of entries; the entries' kinds and classes): the records in conflict under the key on
# all corpora, the key's rows, and the table learned on all corpora but one read on the one left out.
import sys, collections
corpora = {}
for argument in sys.argv[1:]:
    corpus, path = argument.split('=', 1)
    rows = []
    with open(path) as f:
        names = f.readline().rstrip('\n').split('\t')[1:]
        for line in f:
            parts = line.rstrip('\n').split('\t')
            rows.append((int(parts[0]), dict(zip(names, parts[1:]))))
    corpora[corpus] = rows
NARROW = (1, 2, 3, 4)
def derive(row):
    d = dict(row)
    ctx = int(row['ctx']); facts = int(row['facts']); cls = int(row['class']); tpl = int(row['tpl']); op = int(row['op']); up = int(row['up']); state = int(row['state'])
    tfacts = int(row['tfacts']); tclass = int(row['tclass'])
    # Whether its template ends in a load: no address context, and no address itself.
    d['loads'] = str(1 if (ctx & 1) == 0 and (facts & 4) == 0 else 0)
    d['narrow0'] = str(1 if int(row['c0class']) in NARROW else 0)
    d['narrow1'] = str(1 if int(row['c1class']) in NARROW else 0)
    # A pointer's sum's operator, and a logical operator against a conditional: the cases X's own entries read the operator for.
    d['opx'] = 'subtract' if op == 6 else 'subscript' if op == 29 else 'conditional' if op == 23 else 'or' if op == 22 else 'not' if op == 3 else '-'
    constant = tpl in (1, 3)
    d['cshape'] = '%s/%s/%s/%s/%s/%s' % (ctx & 2, row['constant'], row['category'], 'i' if cls in (1, 3, 5, 7) else 'u' if cls in (2, 4, 6, 8) else 'f' if cls in (9, 10) else 'o', row['ob'], row['off']) if constant else '-'
    d['folded'] = '%s/%s' % (row['fold'], row['tclass'] if row['fold'] == '1' else '-') if constant else '-'
    d['evaluated'] = str(state & 1)
    d['plan'] = str(up & 0x7f) if tpl == 20 else '-'
    d['plan_classes'] = '%d/%d/%d' % ((up >> 8) & 0xff, (up >> 16) & 0xff, (up >> 24) & 0xff) if tpl == 20 else '-'
    # The conversion's shape: none where the context is not a value's or the target is the record's own type or none.
    converts = ctx == 0 and row['same'] == '0'
    d['converts'] = str(1 if converts else 0)
    d['tshape'] = '%d/%d' % (tclass, tfacts & 0x93) if converts else '-'
    d['fshape'] = '%d/%d' % (cls, facts & 0x83) if converts else '-'
    # What follows the row: the state's bits past "evaluated", and for an update's first row its plan.
    d['after_state'] = str(state & 0xfe)
    d['split_plan'] = '%d/%d/%d/%d' % (up & 0x7f, (up >> 8) & 0xff, (up >> 16) & 0xff, (up >> 24) & 0xff) if (state & 8) != 0 else '-'
    d['hook_narrow'] = str(1 if int(row['hc0class']) in NARROW else 0) if (state & 2) != 0 else '-'
    d['branch_narrow'] = str(1 if tclass in NARROW else 0) if (state & 0x10) != 0 else '-'
    d['hook_void'] = str(1 if int(row['hclass']) == 0 else 0) if (state & 4) != 0 else '-'
    d['hook_class'] = row['hclass'] if (state & 4) != 0 else '-'
    d['hook_or'] = str(1 if row['hop'] == '22' else 0) if (state & 2) != 0 else '-'
    d['branch_class'] = row['tclass'] if (state & 0x10) != 0 else '-'
    d['hook_c0'] = row['hc0class'] if (state & 2) != 0 else '-'
    return d
derived = {c: [(n, derive(r)) for n, r in rows] for c, rows in corpora.items()}
total = {c: sum(n for n, _ in rows) for c, rows in derived.items()}
KEYS = {
    ('own', 'count'): ['tpl', 'loads', 'mo', 'narrow0', 'narrow1', 'opx', 'cshape', 'plan', 'plan_classes'],
    ('own', 'entries'): ['tpl', 'loads', 'mo', 'narrow0', 'narrow1', 'op', 'cshape', 'folded', 'plan', 'plan_classes', 'class', 'c0class', 'c1class'],
    ('conv', 'count'): ['evaluated', 'converts', 'fold', 'fshape', 'tshape'],
    ('conv', 'entries'): ['evaluated', 'converts', 'fold', 'fshape', 'tshape'],
    ('after', 'count'): ['after_state', 'split_plan', 'hook_narrow', 'branch_narrow'],
    ('after', 'entries'): ['after_state', 'split_plan', 'hook_c0', 'branch_class', 'hook_class', 'hook_or', 'ob'],
}
def answer(row, part, what):
    text = row[part]
    return (0 if text == '-' else text.count(',') + 1) if what == 'count' else text
everything = [item for rows in derived.values() for item in rows]
print('records: ' + ', '.join('%s %d' % (c, total[c]) for c in derived))
for (part, what), keys in KEYS.items():
    groups = collections.defaultdict(collections.Counter)
    for n, row in everything:
        groups[tuple(row[k] for k in keys)][answer(row, part, what)] += n
    conflict = sum(sum(c.values()) - max(c.values()) for c in groups.values())
    print('\n%s, %s, by %s: %d rows, %d records in conflict' % (part, what, ', '.join(keys), len(groups), conflict))
    worst = sorted(((sum(c.values()) - max(c.values()), k, c) for k, c in groups.items() if len(c) > 1), key=lambda x: -x[0])[:4]
    for lost, k, c in worst:
        print('      in conflict %d: %s -> %s' % (lost, dict(zip(keys, k)), dict(c.most_common(4))))
    for left_out in derived:
        learned = collections.defaultdict(collections.Counter)
        for corpus, rows in derived.items():
            if corpus != left_out:
                for n, row in rows:
                    learned[tuple(row[k] for k in keys)][answer(row, part, what)] += n
        right = wrong = unseen = 0
        for n, row in derived[left_out]:
            key = tuple(row[k] for k in keys)
            if key not in learned:
                unseen += n
            elif learned[key].most_common(1)[0][0] == answer(row, part, what):
                right += n
            else:
                wrong += n
        print('   learned without %-8s read on it: right %d (%.2f%%), flagged %d (%.2f%%), wrong %d (%.3f%%)' % (left_out, right, 100.0 * right / total[left_out], unseen, 100.0 * unseen / total[left_out], wrong,
                                                                                                             100.0 * wrong / total[left_out]))
