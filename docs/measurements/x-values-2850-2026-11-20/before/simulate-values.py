#!/usr/bin/env python3
# simulate-values.py LINES...: the values' census's lines (the experiment's `xv` and `xh` lines: a line a record of
# each expression X's rows take on the window, with what the window has of it and its row's entries as the reference's
# tape has them). Candidate rules for each entry's value, from what the window holds, are run over the lines and
# compared with the reference's: for each source of a value, its entries, those whose value is not zero, and those the
# rule gets wrong; and per record swept and per expression, what a values' pass would have to write.
import sys, collections, struct

K = dict(CONST=1, LOCAL=2, LOCAL_ADDRESS=3, GLOBAL=4, GLOBAL_ADDRESS=5, DUP=6, NEG=7, NOT=8, CONVERT=9, LOAD=10, PTR_ADD=21, STORE=28, SET=29, STORE_LOCAL=30,
         SET_LOCAL=31, STORE_GLOBAL=32, SET_GLOBAL=33, CALL=34, DISCARD=35, BRANCH_FALSE=36, BRANCH_TRUE=37, JUMP=38, JUMP_VALUE=39)
ZERO = {6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22, 23, 24, 25, 26, 27, 35}
TEMPORARY = 1 << 63
CONTROL_LABEL = 1 << 62
BOOL_FACT = None  # read from the header where given

def sext(bits, cls):
    # A CONST of an integer class holds its value masked to its width and extended from it by its signedness.
    width = 8 << ((cls - 1) // 2)
    if width >= 64:
        return bits & 0xffffffffffffffff
    mask = (1 << width) - 1
    v = bits & mask
    if (cls & 1) and (v >> (width - 1)):
        v |= 0xffffffffffffffff & ~mask
    return v

def one_bits(cls):
    return 0x3f800000 if cls == 9 else 0x3ff0000000000000 if cls == 10 else 1

class Record:
    __slots__ = ('r', 'n', 'op', 'tpl', 'alive', 'own', 'conv', 'length', 'left', 'right', 'size', 'root', 'object', 'symbol', 'payload', 'standing', 'exponent', 'mo',
                 'cls', 'facts', 'tcls', 'tfacts', 'ocls', 'stride0', 'stride_own', 'cflags', 'sense', 'ctx', 'entries')

def parse(line):
    f = line.rstrip('\n').split('\t')
    rec = Record()
    (rec.r, rec.n, rec.op, rec.tpl, rec.alive, rec.own, rec.conv, rec.length, rec.left, rec.right, rec.size, rec.root, rec.object) = (int(x) for x in f[2:15])
    rec.symbol = int(f[15], 16); rec.payload = int(f[16], 16); rec.standing = int(f[17], 16); rec.exponent = int(f[18], 16); rec.mo = int(f[19])
    (rec.cls, rec.facts, rec.tcls, rec.tfacts, rec.ocls) = (int(x) for x in f[20:25])
    rec.stride0 = int(f[25]); rec.stride_own = int(f[26]); rec.cflags = int(f[27], 16); rec.sense = int(f[28]); rec.ctx = int(f[29])
    rec.entries = [tuple(int(y, 16) if i == 2 else int(y) for i, y in enumerate(x.split(':'))) for x in f[30].split(',')] if len(f) > 30 and f[30] else []
    return int(f[1]), rec

counts = collections.Counter(); nonzero = collections.Counter(); wrong = collections.Counter(); examples = {}
shape_entries = collections.Counter()
per_expression = collections.Counter()
records_total = 0; records_with_value = 0; entries_total = 0
lists = collections.Counter()
numbered = collections.Counter(); marked = collections.Counter()
H = {}

def note(source, value, predicted, rec, j):
    counts[source] += 1
    nonzero[source] += value != 0
    if predicted is not None and predicted != value:
        wrong[source] += 1
        examples.setdefault(source, []).append((rec.op, rec.tpl, rec.own, rec.conv, j, rec.entries, hex(predicted)))

def expression(records):
    global records_total, records_with_value, entries_total
    T_CALL = H.get('T_CALL'); T_BRANCHES = H.get('T_BRANCHES'); T_UPDATE = H.get('T_UPDATE')
    n = len(records)
    # A call's row: the evaluated calls before its subtree and those that hold it (its preorder number among them).
    calls = [x for x in records if x.alive and x.tpl == T_CALL]
    rows = {}
    for c in calls:
        lowest = c.r - c.size + 1
        before = sum(1 for o in calls if o.r < lowest)
        depth = sum(1 for o in calls if o.r > c.r and o.r - o.size + 1 <= c.r)
        rows[c.r] = before + depth
    # The labels: each labeled record's first label is its preorder number among the labeled ones (one label each here:
    # an `&&` branched where true and an `||` where false). A tested value's owner comes down from the condition.
    owner = {}; sense = {}
    branched = [x for x in records if x.alive and x.tpl == T_BRANCHES]
    labeled = []
    for x in reversed(records):
        if x.alive and x.tpl == T_BRANCHES:
            if x.op == H['CONDITION']:
                own, s = None, x.sense
                # The reader wrote the CONDITION's sense at its operand's record; its own record's is not written.
                o = records[x.r - 1] if x.root else records[x.r - x.left] if x.left else None
                if o is not None:
                    owner[o.r] = None; sense[o.r] = o.sense
                continue
            own = owner.get(x.r, None); s = x.sense
            if x.op in (H['AND'], H['OR']):
                past = (x.op == H['AND'] and s == 1) or (x.op == H['OR'] and s == 0)
                if past:
                    labeled.append(x)
                a = x.r - x.left; b = x.r - 1
                owner[a] = x.r if past else own
                owner[b] = own
            else:
                owner[x.r - 1] = own
    label = {}
    for x in labeled:
        lowest = x.r - x.size + 1
        label[x.r] = sum(1 for o in labeled if (o.r > x.r and o.r - o.size + 1 <= x.r) or o.r < lowest)
    # The temporaries: two a postfix update through an address, in the order X writes the updates' first rows (their
    # destinations' records').
    kept = [x for x in records if 102 <= x.own <= 106]
    temporaries = {x.r: 2 * i for i, x in enumerate(kept)}
    updates_by_destination = {}
    for u in records:
        if u.alive and u.tpl == T_UPDATE and u.left:
            updates_by_destination[u.r - u.left] = u
    numbered[(min(len(calls), 2), min(len(labeled), 2), min(len(kept), 2))] += 1
    marks = len(calls) + len(labeled) + len(kept)
    marked[min(marks, 2)] += 1
    flags = collections.Counter()
    for x in records:
        records_total += 1
        K_ = [e[0] for e in x.entries]
        any_value = False
        for j, (kind, cls, value) in enumerate(x.entries):
            entries_total += 1
            source = None; predicted = None
            if kind in ZERO:
                source, predicted = 'none (0)', 0
            elif kind == K['CONST']:
                if x.own == 1 and j == 0:
                    if 1 <= cls <= 8:
                        source, predicted = "an integer constant's bits, by its class", sext(x.payload, cls)
                    else:
                        source, predicted = "a floating constant's bits (its significand and exponent, converted)", None
                        flags['floating'] += 1
                elif x.own == 86 and j == 0:
                    if x.tfacts & H.get('BOOL', 0x100):
                        source, predicted = "a folded constant's, to bool", int(sext(x.payload, x.cls) != 0)
                    else:
                        source, predicted = "a folded constant's bits, by its target's class", sext(sext(x.payload, x.cls), cls)
                elif 64 <= x.own <= 73:
                    source, predicted = "an address constant's offset (its payload)", x.payload
                elif x.own in (74, 75, 106) and j == 0:
                    source, predicted = "a member's offset in bytes", x.mo // 8
                elif 87 <= x.own <= 94 and j == 0:
                    if x.own >= 91:
                        source, predicted = "a pointer's update's step (1)", 1
                    else:
                        source, predicted = "an update's step: one, of the class it is computed in", one_bits(x.ocls)
                else:
                    source, predicted = "a test's zero", 0
            elif kind in (K['LOCAL'], K['LOCAL_ADDRESS'], K['GLOBAL'], K['GLOBAL_ADDRESS']):
                if 102 <= x.own <= 111 and kind == K['LOCAL'] and (value & TEMPORARY):
                    t = temporaries.get(x.r)
                    # The six entries: SET_LOCAL address, LOCAL address, LOAD, STORE_LOCAL old, LOCAL address, LOCAL old.
                    source = "a temporary's number"
                    locals_before = sum(1 for (k2, c2, v2) in x.entries[:j] if k2 == K['LOCAL'] and (v2 & TEMPORARY))
                    predicted = TEMPORARY | (t + (1 if locals_before == 2 else 0)) if t is not None else None
                    flags['temporary'] += 1
                else:
                    source, predicted = "its record's object", x.object
                    if kind in (K['GLOBAL'], K['GLOBAL_ADDRESS']) and x.symbol != x.object:
                        source = "its record's object's symbol (not the object)"; predicted = x.symbol
            elif kind in (K['STORE_LOCAL'], K['STORE_GLOBAL'], K['SET_LOCAL'], K['SET_GLOBAL']):
                if value & TEMPORARY:
                    source = "a temporary's number"
                    if 102 <= x.own <= 111:
                        t = temporaries.get(x.r)
                        predicted = TEMPORARY | (t + (1 if kind == K['STORE_LOCAL'] else 0)) if t is not None else None
                    else:
                        predicted = None
                    flags['temporary'] += 1
                else:
                    d = records[x.r - 1] if x.root and x.r > 0 else records[x.r - x.left] if x.left and x.r - x.left >= 0 else None
                    source, predicted = "its destination's record's object", (d.object if d is not None else None)
                    if d is not None and x.object == d.object:
                        counts['(a store by name whose own record has the object too)'] += 1
            elif kind == K['PTR_ADD']:
                if j > 0 and K_[j - 1] == K['CONST'] and (64 <= x.own <= 75 or 102 <= x.own <= 106):
                    source, predicted = "an offset's sum (1)", 1
                elif 91 <= x.own <= 94:
                    source, predicted = "a pointer's update's stride (its own type's)", x.stride_own
                else:
                    source, predicted = "a pointer's stride (its first operand's conversion's)", x.stride0
            elif kind in (K['LOAD'], K['STORE'], K['SET']):
                source, predicted = "an access's value (a vector's bytes, else 0)", 0
            elif kind == K['CALL']:
                source, predicted = "a call's row (its preorder number among the expression's calls)", rows.get(x.r)
                flags['call'] += 1
            elif kind in (K['BRANCH_FALSE'], K['BRANCH_TRUE']):
                o = owner.get(x.r, 'unset')
                predicted = None if o == 'unset' else CONTROL_LABEL if o is None else label.get(o)
                source = "a branch's label: the control's" if value == CONTROL_LABEL else "a branch's label: an operator's own (its preorder number among the labeled)"
                flags['branch'] += 1
            else:
                source, predicted = 'another kind %d' % kind, None
            note(source, value, predicted, x, j)
            if value != 0:
                any_value = True
                lists[source] += 1
        records_with_value += any_value
    key = tuple(sorted(k for k in flags))
    per_expression[key] += 1

current = None; records = []
for path in sys.argv[1:]:
    with open(path, errors='replace') as f:
        for line in f:
            if line.startswith('xh\t'):
                for item in line.rstrip('\n').split('\t')[1:]:
                    k, v = item.split('=')
                    H[k] = int(v)
            elif line.startswith('xv\t'):
                e, rec = parse(line)
                if e != current and records:
                    expression(records); records = []
                current = e
                records.append(rec)
    if records:
        expression(records); records = []
    current = None

print('records %d, with a value that is not zero %d (%.2f%%); entries %d (%.3f a record)' % (records_total, records_with_value, 100.0 * records_with_value / max(1, records_total),
                                                                                         entries_total, entries_total / max(1, records_total)))
print('%-78s %9s %7s %9s %7s' % ('an entry\'s value\'s source', 'entries', 'share', 'not zero', 'wrong'))
for source, n in counts.most_common():
    print('%-78s %9d %6.2f%% %9d %7d' % (source, n, 100.0 * n / entries_total, nonzero[source], wrong[source]))
print('entries with a value that is not zero: %d (%.2f%% of the entries, %.3f a record)' % (sum(nonzero.values()), 100.0 * sum(nonzero.values()) / entries_total, sum(nonzero.values()) / max(1, records_total)))
print('expressions by what their values need beside their records\' lines:')
total = sum(per_expression.values())
for key, n in per_expression.most_common():
    print('   %7d (%5.2f%%) %s' % (n, 100.0 * n / total, ', '.join(key) if key else 'nothing more'))
print('expressions by their evaluated calls, their labeled operators and their postfix updates through an address (0, 1, 2 or more of each):')
for key, n in sorted(numbered.items()):
    print('   %7d (%5.2f%%) calls %d labeled %d kept %d' % (n, 100.0 * n / total, key[0], key[1], key[2]))
print('expressions with two or more of them together: %d (%.2f%%); with one: %d; with none: %d' % (marked[2], 100.0 * marked[2] / total, marked[1], marked[0]))
for source, list_ in examples.items():
    print('WRONG %s: %d, e.g.' % (source, wrong[source]))
    for ex in list_[:4]:
        print('    op=%d tpl=%d own=%d conv=%d entry=%d entries=%s predicted=%s' % ex)
