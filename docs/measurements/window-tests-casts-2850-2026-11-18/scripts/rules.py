#!/usr/bin/env python3
# rules.py FILE...: the listed expressions that candidate rules would take off the list, one rule after another.
import sys, collections
KIND = ['none', 'pointer', 'signed', 'unsigned', 'zero', 'tiny', 'small', 'constant']
def kind(b): return KIND[(b >> 3) & 7]
def flagged(b): return (b & 1) != 0
def own_class(own, width):
    if own & 0x20: return 'pointer'
    if own & 0x01: return 'void'
    if own & 0x08: return 'enum'
    if own & 0x02: return 'special'
    if width == 64: return 'int64'
    if width: return 'int<64'
    return 'other'
CAST, SUBSCRIPT, ASSIGN, EQUAL, NOT_EQUAL, CONVERT, VALUE = 24, 29, 27, 16, 17, 36, 0
def parse(o):
    v = o.split('.')
    return dict(op=int(v[0]), sent=int(v[1], 16), all=int(v[2], 16), own=int(v[3], 16), width=int(v[4]), left=int(v[5], 16), right=int(v[6], 16), lp=int(v[7], 16),
                rp=int(v[8], 16), trigger=int(v[9]), always=int(v[10]), lop=int(v[11]), rop=int(v[12]), tests=int(v[13], 16))
def r_cast(o):
    return o['op'] == CAST and o['sent'] == 4 and own_class(o['own'], o['width']) in ('void', 'pointer', 'int64')
def r_cast_void_pointer(o):
    return o['op'] == CAST and o['sent'] == 4 and own_class(o['own'], o['width']) in ('void', 'pointer')
def r_subscript(o):
    return o['op'] == SUBSCRIPT and o['sent'] == 1 and kind(o['left']) == 'pointer' and not flagged(o['left']) and kind(o['right']) in ('zero', 'tiny', 'small', 'constant')
def r_null(o):
    # a pointer compared with or assigned a pointer-typed constant, or a literal zero
    pointer_constant = kind(o['right']) == 'none' and flagged(o['right']) and (o['rp'] & 4) != 0
    return o['op'] in (ASSIGN, EQUAL, NOT_EQUAL) and o['sent'] == 1 and kind(o['left']) == 'pointer' and not flagged(o['left']) and pointer_constant
def r_assign_zero(o):
    return o['op'] == ASSIGN and o['sent'] == 1 and kind(o['left']) == 'pointer' and not flagged(o['left']) and kind(o['right']) == 'zero' and o['rop'] in (VALUE, CAST)
RULES = [('casts: a pointer to void, a pointer or a 64-bit integer', r_cast), ('subscripts: a pointer by a constant', r_subscript), ('a pointer and a null pointer constant', r_null),
         ('a pointer assigned a literal zero', r_assign_zero)]
def initializer_quiet(f, level):
    # level 1: the top no flagged constant; level 2: or a constant of 0 to 126 into a plain integer of 8 bits or more or into a pointer
    if level == 0 or int(f['kind']) != 4: return False
    width, bits, tkind = f['declared'].split('/')
    width, bits = int(width), int(bits, 16)
    if bits & 0x02: return False
    top = int(f['top'].split('/')[0], 16)
    if not flagged(top): return True
    if level >= 2 and kind(top) in ('zero', 'tiny', 'small') and ((width >= 8 and not bits & 0x08) or bits & 0x20): return True
    return False
for path in sys.argv[1:]:
    expressions = []
    for line in open(path, errors='replace'):
        if not line.startswith('census-expr:'): continue
        parts = line.split()
        f = dict(x.split('=', 1) for x in parts[1:11])
        expressions.append((f, [parse(o) for o in parts[11:]]))
    total = len(expressions)
    records = sum(int(f['records']) for f, _ in expressions)
    print('==', path.split('/')[-1], 'listed expressions', total, 'their records', records)
    def remaining(rules, level):
        left = 0; left_records = 0; verdicts = 0; blockers = collections.Counter()
        for f, ops in expressions:
            why = int(f['why'])
            block = []
            if why & 1:
                if int(f['trees']) != 0: block.append('tree')
                if any(not any(r(o) for r in rules) for o in ops): block.append('operator')
            if why & 2 and not initializer_quiet(f, level): block.append('initializer')
            if why & 4: block.append('unsequenced')
            if why & 8: block.append('discard')
            if why & 16: block.append('address')
            if why & 32: block.append('warned')
            if block:
                left += 1; left_records += int(f['records']); blockers['+'.join(block)] += 1
            elif int(f['verdict'], 16) != 0:
                verdicts += 1
        return left, left_records, verdicts, blockers
    for level, label in ((0, ''), (1, ' + initializers whose top is no constant'), (2, ' + initializers of a constant of 0 to 126')):
        for n in range(len(RULES) + 1):
            if level and n not in (0, 1, len(RULES)): continue
            left, left_records, verdicts, blockers = remaining([r for _, r in RULES[:n]], level)
            name = ' + '.join(x for x, _ in RULES[:n]) or 'no rule'
            print('  %-110s listed %6d (%5.1f%%) records %7d (%5.1f%%) taken-off-with-a-verdict %d' % ((name + label)[-110:], left, 100.0 * left / total, left_records, 100.0 * left_records / records, verdicts))
    left, left_records, verdicts, blockers = remaining([r for _, r in RULES], 2)
    print('  what keeps the rest listed:', blockers.most_common(12))
    names = {}
    for line in open(path, errors='replace'):
        if line.startswith('census-op:'):
            g = dict(x.split('=', 1) for x in line.split()[1:])
            names[int(g['code'])] = g['name']
    SENT = [(1, 'C'), (2, 'E'), (4, 'P'), (8, 'V'), (0x10, 'A'), (0x20, 'S'), (0x40, 'Q'), (0x80, 'T')]
    def sent(b): return ''.join(n for m, n in SENT if b & m) or '-'
    def cls(o):
        fl = lambda b: kind(b) + ('+c' if b & 1 else '') + ('+bf' if b & 2 else '')
        return '%s sent=%s %s %s%s' % (names.get(o['op'], o['op']), sent(o['sent']), fl(o['left']), fl(o['right']), (' ' + own_class(o['own'], o['width'])) if o['op'] == CAST else '')
    sole = collections.Counter(); sole_records = collections.Counter()
    rules = [r for _, r in RULES]
    for f, ops in expressions:
        why = int(f['why'])
        if why & ~3 or int(f['trees']) != 0: continue
        if why & 2 and not initializer_quiet(f, 2): continue
        blocking = set(cls(o) for o in ops if not any(r(o) for r in rules))
        if len(blocking) == 1:
            c = next(iter(blocking)); sole[c] += 1; sole_records[c] += int(f['records'])
    print('  expressions one class of operator alone keeps listed (after every rule):')
    for c, n in sole.most_common(int(__import__('os').environ.get('TOP', '22'))):
        print('    %5d expressions %6d records  %s' % (n, sole_records[c], c))
