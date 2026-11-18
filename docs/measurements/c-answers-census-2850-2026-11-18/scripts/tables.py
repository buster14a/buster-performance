#!/usr/bin/env python3
# tables.py [--npz DIR] [--most N] [--fields SETS] [--answers LIST] [--detail]: the census's gates.
# For each of C's answers, by the rule's place (the consumer's operator and the operand's slot for what a consumer gives
# an operand; the record's own operator for its template):
# - on the four corpora together, a greedy search of the fewest fields that leave no record in conflict, and the tables'
#   entries;
# - learned on three corpora (the search and the table) and read on the fourth, each way round: the records whose answer
#   is the table's, those the table flags (a key it has with two answers, or doesn't have), and those it answers wrongly.
# SETS: which fields a key may hold beside its place: window, converted, down, outside (features.py), joined by '+'.
import sys
import collections
import numpy
import features as F

ANSWERS = ('evaluated', 'context', 'source', 'target', 'state', 'template')


def codes_of(columns):
    # One code a record for the tuple of its columns' values, and the number of codes.
    count = len(columns[0]) if columns else 0
    key = numpy.zeros(count, dtype=numpy.int64)
    size = 1
    for column in columns:
        values, inverse = numpy.unique(column, return_inverse=True)
        key = key * len(values) + inverse
        size *= len(values)
        if size > (1 << 40):
            values, key = numpy.unique(key, return_inverse=True)
            size = len(values)
    values, key = numpy.unique(key, return_inverse=True)
    return key, len(values)


def conflicts(key, key_count, answer):
    # The records that are not their key's commonest answer, and the keys.
    values, inverse = numpy.unique(answer, return_inverse=True)
    pair = key * len(values) + inverse
    pairs, counts = numpy.unique(pair, return_counts=True)
    keys = pairs // len(values)
    best = numpy.zeros(key_count, dtype=numpy.int64)
    numpy.maximum.at(best, keys, counts)
    return int(len(answer) - best.sum())


def search(columns, names, answer, most):
    key = numpy.zeros(len(answer), dtype=numpy.int64)
    key_count = 1
    chosen = []
    bad = conflicts(key, key_count, answer)
    coded = {}
    for name in names:
        values, inverse = numpy.unique(columns[name], return_inverse=True)
        if len(values) > 1:
            coded[name] = (inverse, len(values))
    while bad != 0 and len(chosen) < most:
        best = None
        for name, (inverse, size) in coded.items():
            if name in chosen:
                continue
            values, candidate = numpy.unique(key * size + inverse, return_inverse=True)
            b = conflicts(candidate, len(values), answer)
            if best is None or (b, len(values)) < (best[0], best[1]):
                best = (b, len(values), name, candidate)
        if best is None or best[0] >= bad:
            break
        bad, key_count, key = best[0], best[1], best[3]
        chosen.append(best[2])
    return chosen, bad, key_count


def population(data, answer):
    if answer == 'evaluated':
        return data['answered']
    if answer == 'template':
        return data['made']
    return data['answered'] & (data['a']['evaluated'] != 0)


def place(answer):
    return ('op',) if answer == 'template' else ('ctpl', 'cop', 'slot')


def candidates(data, answer, sets):
    names = []
    f = data['f']
    bits = [n for n in f if n.startswith('b_')]
    own = ['class', 'facts', 'kind', 'category', 'constant', 'bitfield', 'effects', 'static', 'vector', 'wide', 'register', 'null']
    operands = [n for n in data['window'] if n[0] in 'lrt' and n not in ('register',) and not n.endswith('zero')]
    if answer == 'template':
        if 'window' in sets:
            names += own + operands + [n for n in bits if n not in ('b_ctvoid', 'b_increment') and 'c0' not in n and 'c1' not in n]
        if 'converted' in sets:
            names += ['c0class', 'c0facts', 'c0kind', 'c1class', 'c1facts', 'c1kind'] + [n for n in bits if 'c0' in n or 'c1' in n]
        if 'down' in sets:
            names += ['own_address', 'own_discard', 'own_branched', 'own_target_void', 'own_target_none', 'slot_root', 'own_same', 'own_target_class', 'own_target_facts']
        if 'outside' in sets:
            names += ['o_known', 'o_local', 'o_compound', 'o_lknown', 'o_llocal', 'o_lregister', 'o_root_known', 'o_root_local', 'truth', 'ltruth', 'member_odd', 'o_tounion']
    else:
        if 'window' in sets:
            names += ['op'] + own + operands + [n for n in data['window'] if n[0] in 'cs' and n not in ('cop', 'slot', 'class', 'constant', 'category', 'static') and not n.endswith('zero')] + \
                     [n for n in bits if 'c0' not in n and 'c1' not in n]
        if 'converted' in sets:
            names += ['ccclass', 'ccfacts', 'cckind']
        if 'down' in sets:
            names += [n for n in data['down'] if n != 'ctpl']
        if 'outside' in sets:
            names += ['catruth', 'cpower', 'cpointer']
    return [n for n in dict.fromkeys(names) if n in f]


def prepare(data):
    f, a = data['f'], data['a']
    raw = data['raw']
    # Bits a rule reads, each a recoding of one or two of the line's bytes.
    record_class = numpy.where((f['facts'] & 1) != 0, 8, f['class'])
    f['b_plain'] = ((record_class >= 1) & (record_class <= 10) & ((f['facts'] & 1) == 0)).astype(numpy.int64)
    f['b_scalar'] = ((record_class >= 1) & (record_class <= 10)).astype(numpy.int64)
    f['b_aggregate'] = f['facts'] & 1
    f['b_address_value'] = (f['facts'] >> 2) & 1
    f['b_atomic'] = (f['facts'] >> 6) & 1
    f['b_unfit'] = ((f['facts'] & 0x82) != 0).astype(numpy.int64)
    f['b_void'] = ((f['class'] == 0) & (f['kind'] == 1)).astype(numpy.int64)
    f['b_lvalue'] = (f['category'] == 1).astype(numpy.int64)
    f['b_function'] = (f['category'] == 2).astype(numpy.int64)
    f['b_constant'] = (f['constant'] != 0).astype(numpy.int64)
    f['b_address_constant'] = (f['constant'] == 3).astype(numpy.int64)
    f['b_integer_class'] = ((f['class'] >= 1) & (f['class'] <= 8)).astype(numpy.int64)
    f['b_lname'] = (f['lop'] == 0).astype(numpy.int64)
    f['b_llogical'] = numpy.isin(f['lop'], (3, 21, 22)).astype(numpy.int64)
    f['b_logical'] = numpy.isin(f['op'], (3, 21, 22)).astype(numpy.int64)
    f['b_lconstant'] = (f['lconstant'] != 0).astype(numpy.int64)
    f['b_rinteger'] = ((f['rconstant'] == 1) & (f['rcategory'] == 0)).astype(numpy.int64)
    f['b_latomic'] = (f['lfacts'] >> 6) & 1
    f['b_lpointer'] = (f['lfacts'] >> 3) & 1
    f['b_c0pointer'] = (f['c0facts'] >> 3) & 1
    f['b_c1pointer'] = (f['c1facts'] >> 3) & 1
    f['b_c0scalar'] = ((f['c0class'] >= 1) & (f['c0class'] <= 10)).astype(numpy.int64)
    f['b_c1scalar'] = ((f['c1class'] >= 1) & (f['c1class'] <= 10)).astype(numpy.int64)
    f['b_c0testable'] = (((f['c0facts'] & 1) == 0) & (f['c0class'] < 14) & (f['c0class'] != 0)).astype(numpy.int64)
    f['b_c1testable'] = (((f['c1facts'] & 1) == 0) & (f['c1class'] < 14) & (f['c1class'] != 0)).astype(numpy.int64)
    f['b_ctvoid'] = ((f['cclass'] == 0) & (f['ckind'] == 1)).astype(numpy.int64)
    f['b_increment'] = ((f['cop'] >= 38) & (f['cop'] <= 41)).astype(numpy.int64)
    f['o_known'] = (raw['ob'] >> 1) & 1
    f['o_local'] = (raw['ob'] >> 2) & 1
    f['o_compound'] = (raw['ob'] >> 3) & 1
    f['o_lknown'] = (raw['lob'] >> 1) & 1
    f['o_llocal'] = (raw['lob'] >> 2) & 1
    f['o_lregister'] = (raw['lob'] >> 5) & 1
    f['o_root_known'] = (raw['ro'] >> 1) & 1
    f['o_root_local'] = (raw['ro'] >> 2) & 1
    f['o_power'] = (raw['up'] >> 5) & 1
    f['o_tounion'] = f['tounion']
    f['own_target_class'] = a['target'] & 0xff
    f['own_target_facts'] = (a['target'] >> 8) & 0xff
    f['own_same'] = a['same']
    f['own_address'] = a['address']
    f['own_discard'] = a['discard']
    f['own_branched'] = (a['state'] >> 6) & 1
    f['own_target_void'] = ((data['raw']['ts'] >> 3) & 1)
    f['own_target_none'] = ((data['raw']['ts'] >> 4) & 1)
    f['slot_root'] = (f['slot'] == 9).astype(numpy.int64)
    count = data['count']
    index = numpy.arange(count)
    start = index - raw['r']
    rooted = raw['p'] == 4294967295
    parent = numpy.where(rooted, -1, start + raw['p'])
    first = numpy.full(count, -1, dtype=numpy.int64)
    m = (raw['slot'] == 0) & ~rooted
    first[parent[m]] = index[m]
    condition = numpy.where(parent >= 0, first[numpy.maximum(parent, 0)], -1)
    f['catruth'] = numpy.where(condition >= 0, raw['tr'][numpy.maximum(condition, 0)], 0)
    f['cpower'] = numpy.where(parent >= 0, (raw['up'][numpy.maximum(parent, 0)] >> 5) & 1, 0)
    f['cpointer'] = numpy.where(parent >= 0, (raw['up'][numpy.maximum(parent, 0)] >> 4) & 1, 0)
    f['ltruth'] = numpy.where(first >= 0, raw['tr'][numpy.maximum(first, 0)], 0)


def gather(datas, names, mask_of):
    columns = {}
    masks = [mask_of(d) for d in datas]
    for name in names:
        columns[name] = numpy.concatenate([d['f'][name][m] for d, m in zip(datas, masks)])
    return columns, masks


def main():
    arguments = sys.argv[1:]
    directory = 'columns'
    most = 6
    sets = ('window', 'down')
    answers = ANSWERS
    detail = False
    while arguments:
        if arguments[0] == '--npz':
            directory = arguments[1]; arguments = arguments[2:]
        elif arguments[0] == '--most':
            most = int(arguments[1]); arguments = arguments[2:]
        elif arguments[0] == '--fields':
            sets = tuple(arguments[1].split('+')); arguments = arguments[2:]
        elif arguments[0] == '--answers':
            answers = tuple(arguments[1].split(',')); arguments = arguments[2:]
        elif arguments[0] == '--detail':
            detail = True; arguments = arguments[1:]
        else:
            raise SystemExit('unknown argument ' + arguments[0])
    datas = {c: F.load(c, directory) for c in F.CORPORA}
    for d in datas.values():
        prepare(d)
        d['a']['source'] = numpy.where(d['root'], 64, d['a']['selector'] & 0x1f)
    every = [datas[c] for c in F.CORPORA]
    corpora = len(F.CORPORA)
    print('fields a key may hold beside its place: %s; at most %d of them' % ('+'.join(sets), most))
    for answer in answers:
        group_names = place(answer)
        names = candidates(datas['sqlite'], answer, sets)
        columns, masks = gather(every, list(names) + [g for g in group_names if g not in names] + ['op', 'cop'], lambda d: population(d, 'context' if answer == 'source' else answer))
        values = numpy.concatenate([d['a'][answer][m] for d, m in zip(every, masks)])
        owner = numpy.concatenate([numpy.full(int(m.sum()), i) for i, m in enumerate(masks)])
        operator = columns['op'] if answer == 'template' else columns['cop']
        group, group_count = codes_of([columns[g] for g in group_names])
        total = len(values)
        sizes = numpy.bincount(owner, minlength=corpora)
        report = []
        left = 0
        entries = 0
        by_fields = collections.Counter()
        big = numpy.zeros(corpora, dtype=numpy.int64)
        wide = numpy.zeros(corpora, dtype=numpy.int64)
        right = numpy.zeros(corpora, dtype=numpy.int64)
        flagged = numpy.zeros(corpora, dtype=numpy.int64)
        unseen = numpy.zeros(corpora, dtype=numpy.int64)
        wrong = numpy.zeros(corpora, dtype=numpy.int64)
        flagged_by = [collections.Counter() for _ in range(corpora)]
        wrong_by = [collections.Counter() for _ in range(corpora)]
        order = numpy.argsort(group, kind='stable')
        bounds = numpy.flatnonzero(numpy.diff(group[order])) + 1
        for members in numpy.split(order, bounds):
            label = '/'.join(('root' if int(columns[g][members[0]]) == 255 else F.template_name(int(columns[g][members[0]]))) if g == 'ctpl' else
                             F.op_name(int(columns[g][members[0]])) if g in ('cop', 'op') else str(int(columns[g][members[0]])) for g in group_names)
            answer_values = values[members]
            if answer == 'source':
                # A place whose records share a source takes it; else each record's first.
                shared = int(numpy.bitwise_and.reduce(answer_values))
                answer_values = numpy.full(len(members), shared & -shared) if shared != 0 else answer_values & -answer_values
            sub = {n: columns[n][members] for n in names}
            chosen, bad, size = search(sub, names, answer_values, most)
            left += bad
            entries += size
            by_fields[len(chosen)] += len(members)
            owners = owner[members]
            if size > 128:
                big += numpy.bincount(owners, minlength=corpora)
            if len(group_names) + len(chosen) > 8:
                wide += numpy.bincount(owners, minlength=corpora)
            report.append((len(members), label, chosen, bad, size))
            # The table learned on three corpora and read on the fourth.
            key, key_count = codes_of([sub[n] for n in chosen]) if chosen else (numpy.zeros(len(members), dtype=numpy.int64), 1)
            value_codes, value_index = numpy.unique(answer_values, return_inverse=True)
            for held in range(corpora):
                train = owners != held
                test = owners == held
                if not test.any():
                    continue
                pairs = numpy.unique(key[train] * len(value_codes) + value_index[train])
                pair_keys = pairs // len(value_codes)
                distinct = numpy.bincount(pair_keys, minlength=key_count)
                single = numpy.full(key_count, -1, dtype=numpy.int64)
                single[pair_keys] = pairs % len(value_codes)
                seen = distinct[key[test]]
                is_right = (seen == 1) & (single[key[test]] == value_index[test])
                is_wrong = (seen == 1) & (single[key[test]] != value_index[test])
                right[held] += int(is_right.sum())
                flagged[held] += int((seen > 1).sum())
                unseen[held] += int((seen == 0).sum())
                wrong[held] += int(is_wrong.sum())
                test_operator = operator[members][test]
                for o in test_operator[(seen != 1)].tolist():
                    flagged_by[held][o] += 1
                if is_wrong.any():
                    wrong_by[held][label + ' key ' + ('+'.join(chosen) or '(none)')] += int(is_wrong.sum())
        print('== %s: %d records of the four corpora in %d places; fields beside the place -> records %s; in conflict after %d fields: %d (%.3f%%); entries in all %d' %
              (answer, total, group_count, dict(sorted(by_fields.items())), most, left, 100.0 * left / total, entries))
        print('   records in a place whose table is over 128 entries: %s; whose key is over 8 bytes: %s' %
              (', '.join('%s %.2f%%' % (c, 100.0 * big[i] / max(1, sizes[i])) for i, c in enumerate(F.CORPORA)),
               ', '.join('%s %.2f%%' % (c, 100.0 * wide[i] / max(1, sizes[i])) for i, c in enumerate(F.CORPORA))))
        report.sort(key=lambda x: -x[0])
        for count, label, chosen, bad, size in report:
            if detail or bad != 0 or size > 128:
                print('     %-40s %7d records  key %-60s conflicts %5d  table %4d' % (label, count, '+'.join(chosen) or '(none)', bad, size))
        for held, corpus in enumerate(F.CORPORA):
            count = int(sizes[held])
            print('   read on %-6s (the tables learned on the others): %7d records; the tables\' %7d (%.2f%%); flagged: a key with two answers %d, a key not seen %d (%.2f%%); wrong %d' %
                  (corpus, count, right[held], 100.0 * right[held] / count, flagged[held], unseen[held], 100.0 * (flagged[held] + unseen[held]) / count, wrong[held]))
            if flagged_by[held]:
                print('        flagged, by %s operator: %s' % ('its' if answer == 'template' else 'the consumer\'s',
                                                              ', '.join('%s %d' % (F.op_name(o), n) for o, n in flagged_by[held].most_common(10))))
            for text, n in wrong_by[held].most_common(6):
                print('        wrong %4d: place %s' % (n, text))


main()
