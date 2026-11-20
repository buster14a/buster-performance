#!/usr/bin/env python3
# census-f.py FILE...: the side facts' census (BUSTER_CENSUS_F=1 lines of measure-node-machine --shadow --window-rows):
# for each expression the window takes whole, the window's records at reader time (fw, fr) beside what the program's
# own walks say of its root after the pipeline (fo): its references, its return fact, its branch truth and its value.
# Candidate rules for each fact are run over the records and compared with the program's answers.
import collections, gzip, lzma, sys
CONTROL = {0: 'EVALUATE', 1: 'INITIALIZE', 2: 'VLA', 4: 'RETURN', 5: 'SWITCH', 12: 'JUMP_INDIRECT', 14: 'RESULT', 17: 'BRANCH_FALSE', 18: 'BRANCH_TRUE', 255: 'none'}
OP_VALUE, OP_CALL, OP_COMMA, OP_CONDITIONAL, OP_AND, OP_OR, OP_NOT = 0, 34, 28, 23, 21, 22, 3
OBJECT, SYMBOL = 0x04, 0x08
def units(path):
    pending = {}
    current = None
    answers = None
    opener = gzip.open if path.endswith('.gz') else lzma.open if path.endswith('.xz') else open
    with opener(path, 'rt', errors='replace') as f:
        for line in f:
            if not line.startswith('f') or line[1:3] not in ('w\t', 'r\t', 'u\t', 'o\t'):
                continue
            p = line.rstrip('\n').split('\t')
            if p[0] == 'fw':
                if answers is not None:
                    yield current, pending, answers
                    pending, answers = {}, None
                pending[int(p[1])] = dict(record=int(p[2]), operand=int(p[3]), count=int(p[4]), token=int(p[5]), records=[])
            elif p[0] == 'fr':
                pending[int(p[1])]['records'].append(dict(r=int(p[2]), x=int(p[3]), op=int(p[4]), flags=int(p[5]), value=int(p[6], 16), alive=int(p[7]), template=int(p[8]),
                                                          standing=int(p[9]), cls=int(p[10]), left=int(p[11]), right=int(p[12]), size=int(p[13]), token=int(p[14]),
                                                          ups=int(p[15]) if len(p) > 15 else 0, place=int(p[16]) if len(p) > 16 else 0, callee=int(p[17]) if len(p) > 17 else 0,
                                                          line=int(p[18], 16) if len(p) > 18 else 0))
            elif p[0] == 'fu':
                if answers is not None:
                    yield current, pending, answers
                    pending = {}
                current, answers = p[1], {}
            elif p[0] == 'fo':
                refs = [int(x) for x in p[16].split(',')] if len(p) > 16 and p[16] else []
                answers[int(p[1])] = dict(kind=int(p[2]), op=int(p[3]), fact=int(p[4]), branched=int(p[5]), branch=int(p[6]), constant=int(p[7]), integer=int(p[8]), flags=int(p[9], 16),
                                          known=int(p[10]), truth=int(p[11]), inner_op=int(p[12]), inner_kind=int(p[13]), controlled=int(p[14]), count=int(p[15]), refs=refs)
    if answers is not None:
        yield current, pending, answers
total = collections.Counter()
for path in sys.argv[1:]:
    c = collections.Counter()
    kinds = collections.Counter()
    facts = collections.Counter()
    per = collections.Counter()
    examples = collections.defaultdict(list)
    for unit, windows, answers in units(path):
        c['units'] += 1
        for root, w in windows.items():
            c['taken'] += 1
            a = answers.get(root)
            if a is None:
                c['no answer'] += 1
                continue
            records = w['records']
            c['records'] += len(records)
            kinds[CONTROL.get(a['kind'], str(a['kind']))] += 1
            # References: the program's set against the candidates'.
            oracle = set(a['refs'])
            assert len(oracle) == len(a['refs'])
            c['references'] += len(oracle)
            per[min(len(oracle), 6)] += 1
            leaves = [r for r in records if r['size'] == 1]
            named = {r['value'] for r in records if r['flags'] & OBJECT and r['flags'] & SYMBOL}
            leaf_named = {r['value'] for r in leaves if r['flags'] & OBJECT and r['flags'] & SYMBOL}
            leaf_objects = {r['value'] for r in leaves if r['flags'] & OBJECT}
            leaf_addresses = {r['value'] for r in leaves if r['flags'] & OBJECT and r['op'] == OP_VALUE and (r['standing'] >> 2) & 7 == 3}
            leaf_static = {r['value'] for r in leaves if r['flags'] & OBJECT and r['line'] & 0x80}
            leaf_either = {r['value'] for r in leaves if r['flags'] & OBJECT and (r['line'] & 0x80 or r['flags'] & SYMBOL)}
            c['leaves with an object'] += sum(1 for r in leaves if r['flags'] & OBJECT)
            c['leaves with a static object or a symbol'] += sum(1 for r in leaves if r['flags'] & OBJECT and (r['line'] & 0x80 or r['flags'] & SYMBOL))
            c['of them not evaluated'] += sum(1 for r in leaves if r['flags'] & OBJECT and (r['line'] & 0x80 or r['flags'] & SYMBOL) and not r['alive'])
            for name, candidate in (('symbol records', named), ('symbol leaves', leaf_named), ('object leaves', leaf_objects), ('address leaves', leaf_addresses),
                                    ('static-flag leaves', leaf_static), ('static-flag or symbol leaves', leaf_either)):
                c['refs exact: ' + name] += candidate == oracle
                c['refs missing: ' + name] += len(oracle - candidate)
                c['refs extra: ' + name] += len(candidate - oracle)
            if leaf_either != oracle and len(examples['refs']) < 12:
                examples['refs'].append((unit, w['token'], sorted(oracle - leaf_either), sorted(leaf_either - oracle),
                                         [(r['op'], hex(r['flags']), r['value'], r['standing'], r['size'], r['alive'], hex(r['line'])) for r in records if r['value'] in (oracle ^ leaf_either)][:6]))
            if a['kind'] in (17, 18) and a['branched'] and not (a['known'] and a['constant'] != 0) and len(examples['branch']) < 6:
                examples['branch'].append((unit, w['token'], [(r['op'], r['standing'], r['ups'], r['place']) for r in records][:14]))
            # The return fact: 1 a stop, 2 an unknown.
            facts[a['fact']] += 1
            calls = [r for r in records if r['op'] == OP_CALL]
            c['expressions with a call'] += bool(calls)
            c['calls'] += len(calls)
            by_x = {r['x']: r for r in records}
            indirect = 0
            for call in calls:
                callee = by_x.get(call['x'] - call['left'])
                direct = callee is not None and callee['op'] == OP_VALUE and (callee['flags'] & (OBJECT | SYMBOL)) == (OBJECT | SYMBOL)
                indirect += not direct
            c['indirect calls'] += indirect
            candidate_unknown = 2 if indirect else 0
            c['fact exact: unknown iff an indirect call'] += candidate_unknown == a['fact']
            # The flow's own reduction over the window's records: a call's fact from its callee's leaf, its operands' facts
            # joined, and an `&&`, an `||` or a `?:` keeping its condition's, an unknown of either arm and a stop of both arms.
            fact = {}
            children = collections.defaultdict(list)
            for r in records:
                if r['ups'] != 0:
                    children[r['x'] + r['ups']].append(r)
            for r in records:
                own = 0
                if r['op'] == OP_CALL:
                    own = 2 if not r['callee'] & 4 else 1 if r['callee'] & 1 else 2 if r['callee'] & 2 else 0
                kids = children.get(r['x'], [])
                if r['op'] in (OP_AND, OP_OR, OP_CONDITIONAL):
                    condition = sum(fact[k['x']] for k in kids if k['place'] == 0 and False) or 0
                    condition = 0
                    arms = []
                    for k in kids:
                        if k['place'] == 0: condition |= fact[k['x']]
                        else: arms.append(fact[k['x']])
                    own |= condition
                    for arm in arms: own |= arm & 2
                    if r['op'] == OP_CONDITIONAL and len(arms) == 2 and arms[0] & arms[1] & 1: own |= 1
                else:
                    for k in kids: own |= fact[k['x']]
                fact[r['x']] = own
            reduced = fact[records[-1]['x']] if records else 0
            c['fact exact: the reduction on the records'] += reduced == a['fact']
            stops = any(r['op'] == OP_CALL and r['callee'] & 1 for r in records)
            c['expressions with a call of a noreturn function'] += stops
            c['calls of a library name the flow leaves unknown'] += sum(1 for r in records if r['op'] == OP_CALL and r['callee'] & 4 and not r['callee'] & 1 and r['callee'] & 2)
            if reduced != a['fact']:
                c['fact differs: program %d, reduction %d' % (a['fact'], reduced)] += 1
                if len(examples['fact']) < 8:
                    examples['fact'].append((unit, w['token'], a['fact'], reduced, [(r['op'], r['callee'], r['ups'], r['place']) for r in records if r['op'] in (OP_CALL, OP_AND, OP_OR, OP_CONDITIONAL)][:8]))
            # A condition's truth, and a constant value.
            branch = a['kind'] in (17, 18)
            if branch:
                c['conditions'] += 1
                c['conditions with a branch truth'] += a['branched']
                c['conditions with a known value'] += a['known'] and a['constant'] != 0
                c['conditions decided by an operand alone'] += a['branched'] and not (a['known'] and a['constant'] != 0)
            fold = a['integer'] and a['constant'] != 0 and a['known'] and not (a['flags'] & 0x10)
            c['roots with a constant integer value and no effect'] += fold
            c['of them a condition'] += fold and branch
            c['of them with a comma'] += fold and any(r['op'] == OP_COMMA for r in records)
            c['switch selectors'] += a['kind'] == 5
            c['switch selectors of an enumeration (the kind %d)' % a['inner_kind']] += a['kind'] == 5
            c['roots with no control'] += a['controlled'] == 0
    print('==', path)
    for k in ('units', 'taken', 'no answer', 'records', 'references', 'leaves with an object', 'leaves with a static object or a symbol', 'of them not evaluated', 'expressions with a call', 'calls', 'indirect calls', 'conditions', 'conditions with a branch truth',
              'conditions with a known value', 'conditions decided by an operand alone', 'roots with a constant integer value and no effect', 'of them a condition', 'of them with a comma',
              'switch selectors', 'roots with no control'):
        print('%-52s %d' % (k, c[k]))
    for k in sorted(c):
        if k.startswith('refs ') or k.startswith('fact ') or k.startswith('switch selectors of') or k.startswith('expressions with a call of') or k.startswith('calls of a library'):
            print('%-52s %d' % (k, c[k]))
    print('by control:', dict(kinds.most_common()))
    print('return facts (0 none, 1 stops, 2 unknown, 3 both):', dict(sorted(facts.items())))
    print('references an expression (6: six or more):', dict(sorted(per.items())))
    for name, rows in examples.items():
        for row in rows:
            print('  example', name, row)
