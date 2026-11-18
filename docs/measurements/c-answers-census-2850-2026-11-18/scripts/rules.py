#!/usr/bin/env python3
# rules.py [--npz DIR] [--show N]: C's rules (c_check_node_machine_contexts.c) restated over the census's lines, each
# answer made from the fields its rule reads, and compared with what C answered for every record of the four corpora.
# For each answer: the records the restated rule gets right, those it gets wrong (a rule misread: to be none), and what
# the rule read beyond the consumer's template, its operator and the operand's slot, counted:
#   bytes     a byte of the record's own line or of its consumer's (its operator, its standing, a flag);
#   down      one of C's answers for the consumer (its context);
#   payload   a constant's value (a condition's truth, a divisor that is a power of two);
#   identity  what is no byte of the window (an object's storage, a type's row);
#   deep      an operand's operand.
import sys
import collections
import numpy
import features as F

O = {name: i for i, name in enumerate(F.OPS)}
T = {name: i for i, name in enumerate(F.TEMPLATES)}
UPDATES = (38, 51)
SOURCE_GIVEN, SOURCE_NODE, SOURCE_LONG, SOURCE_VOID, SOURCE_NONE, SOURCE_OWN, SOURCE_UP = 1, 2, 4, 8, 16, 32, 64
NEED = ('bytes', 'down', 'payload', 'identity', 'deep')


def links(raw):
    # Each record's place in the file, its consumer's, and its consumer's operands by slot.
    count = len(raw['r'])
    index = numpy.arange(count)
    start = index - raw['r']
    rooted = raw['p'] == 4294967295
    parent = numpy.where(rooted, -1, start + raw['p'])
    child = numpy.full((3, count), -1, dtype=numpy.int64)
    for k in range(3):
        m = (raw['slot'] == k) & ~rooted
        child[k][parent[m]] = index[m]
    return index, parent, child


def operands(d):
    raw = d['raw']
    count = d['count']
    index, parent, child = links(raw)
    op, slot, cop, ctpl = raw['op'], raw['slot'], raw['cop'], raw['ctpl']
    root = d['root']
    answered = d['answered']
    fl, st, w = raw['fl'], raw['st'], raw['w']
    facts = (w >> 8) & 0xff
    category = st & 3
    constant = (st >> 2) & 7
    effects = (fl & 0x810) != 0
    caddress = (raw['cctx'] & 1) != 0
    cdiscard = (raw['cctx'] & 4) != 0
    csense = (raw['cstate'] & 0x20) != 0
    cbranched = (raw['cstate'] & 0x40) != 0
    # The consumer's first operand's truth, where the record isn't it.
    first = numpy.where(parent >= 0, child[0][numpy.maximum(parent, 0)], -1)
    truth = numpy.where(first >= 0, raw['tr'][numpy.maximum(first, 0)], 0)
    evaluated = numpy.full(count, -1, dtype=numpy.int64)
    address = numpy.zeros(count, dtype=numpy.int64)
    source = numpy.zeros(count, dtype=numpy.int64)
    state = numpy.zeros(count, dtype=numpy.int64)
    need = numpy.zeros(count, dtype=numpy.int64)

    def rule(mask, e, a=0, s=0, t=0, n=0):
        mask = mask & answered & ~root
        evaluated[mask] = e[mask] if isinstance(e, numpy.ndarray) else e
        address[mask] = a[mask] if isinstance(a, numpy.ndarray) else a
        source[mask] = s[mask] if isinstance(s, numpy.ndarray) else s
        state[mask] = t[mask] if isinstance(t, numpy.ndarray) else t
        need[mask] |= n[mask] if isinstance(n, numpy.ndarray) else n

    is_op = lambda *names: numpy.isin(cop, [O[x] for x in names])
    own_op = lambda *names: numpy.isin(op, [O[x] for x in names])
    tpl = lambda *names: numpy.isin(ctpl, [T[x] for x in names])
    bytes_, down, payload, identity, deep = 1, 2, 4, 8, 16
    # A folded constant evaluates nothing.
    rule(tpl('CONSTANT'), 0)
    wrapper = tpl('PASS') & is_op('CAST', 'CONVERT', 'POSITIVE')
    rule(wrapper & (slot == 0), 1, 0, SOURCE_NODE)
    rule(tpl('PASS') & is_op('ADDRESS') & (slot == 0), 1, 1, SOURCE_NONE)
    rule(tpl('PASS') & is_op('SELECT') & (slot == 0), 1, caddress.astype(numpy.int64), SOURCE_NONE, 0, down)
    rule(tpl('PASS') & is_op('COMMA') & (slot == 0), 1, 0, SOURCE_VOID)
    rule(tpl('PASS') & is_op('COMMA') & (slot == 1), 1, caddress.astype(numpy.int64), numpy.where(cdiscard, SOURCE_VOID, SOURCE_NODE), 0, down)
    # A conditional whose condition is known: the condition for its effects, and the arm its truth takes.
    known = tpl('PASS') & is_op('CONDITIONAL')
    rule(known & (slot == 0), effects.astype(numpy.int64), 0, SOURCE_VOID, 0, bytes_)
    rule(known & (slot == 1), (truth == 2).astype(numpy.int64), 0, SOURCE_NODE, 0, payload)
    rule(known & (slot == 2), (truth == 1).astype(numpy.int64), 0, SOURCE_NODE, 0, payload)
    rule(tpl('DEREFERENCE', 'UNARY', 'TRUTH') & (slot == 0), 1, 0, SOURCE_GIVEN)
    rule(tpl('MEMBER') & (slot == 0), 1, is_op('MEMBER').astype(numpy.int64), SOURCE_GIVEN)
    rule(tpl('BINARY') & (slot < 2), 1, 0, SOURCE_GIVEN)
    rule(tpl('POINTER') & (slot == 0), 1, 0, SOURCE_GIVEN)
    rule(tpl('POINTER') & (slot == 1), 1, 0, SOURCE_LONG)
    named = tpl('STORE_LOCAL', 'STORE_GLOBAL')
    rule(named & is_op('ASSIGN') & (slot == 0), 0)
    rule(named & is_op('ASSIGN') & (slot == 1), 1, 0, SOURCE_NODE)
    rule(named & is_op('INITIALIZE') & (slot == 0), 1, 0, SOURCE_NODE)
    rule(tpl('STORE') & (slot == 0), 1, 1, SOURCE_NONE)
    rule(tpl('STORE') & (slot == 1), 1, 0, SOURCE_NODE)
    # A logical operator or a conditional whose condition isn't known: its condition a value tested after its row, or
    # branches where it is `!`s over an `&&` or an `||` (the record's own state says which: its rule reads its operands).
    branch = tpl('BRANCH')
    own_branched = (raw['state'] & 0x40) != 0
    logical = own_op('LOGICAL_AND', 'LOGICAL_OR', 'NOT')
    rule(branch & (slot == 0), 1, 0, numpy.where(own_branched, SOURCE_NONE, SOURCE_GIVEN),
         numpy.where(own_branched, 0x40 | numpy.where(is_op('LOGICAL_OR'), 0x20, 0), 0x02), numpy.where(logical, bytes_ | deep, bytes_))
    rule(branch & is_op('CONDITIONAL') & (slot == 1), 1, 0, SOURCE_NODE, 0x04)
    rule(branch & is_op('CONDITIONAL') & (slot == 2), 1, 0, SOURCE_NODE)
    rule(branch & ~is_op('CONDITIONAL') & (slot == 1), 1, 0, SOURCE_GIVEN)
    rule(tpl('DECIDED') & (slot == 0), effects.astype(numpy.int64), 0, SOURCE_VOID, 0, bytes_)
    rule(tpl('DECIDED') & (slot == 1), 0)
    rule(tpl('SECOND') & (slot == 0), effects.astype(numpy.int64), 0, SOURCE_VOID, 0, bytes_)
    rule(tpl('SECOND') & (slot == 1), 1, 0, SOURCE_GIVEN)
    # A call: its callee unless it is called directly (a function's designator, an address constant), its arguments.
    direct = (category == 2) & (constant == 3) & ~effects
    rule(tpl('CALL') & (slot == 0), (~direct).astype(numpy.int64), 0, SOURCE_NONE, 0, bytes_)
    rule(tpl('CALL') & (slot >= 3), 1, 0, SOURCE_GIVEN)
    # An update: its destination for its address unless it is a name; its second operand unless it is an increment or a
    # division by a power of two (its consumer's plan says which: a constant's value).
    update = tpl('UPDATE')
    increment = (cop >= 38) & (cop <= 41)
    parent_plan = numpy.where(parent >= 0, raw['up'][numpy.maximum(parent, 0)], 0)
    power = (parent_plan & 32) != 0
    pointer = (parent_plan & 16) != 0
    rule(update & (slot == 0), (op != O['VALUE']).astype(numpy.int64), 1, SOURCE_NONE, 0x08, bytes_)
    divides = is_op('DIVIDE_ASSIGN', 'REMAINDER_ASSIGN')
    rule(update & (slot == 1), (~increment & ~power).astype(numpy.int64), 0, numpy.where(pointer, SOURCE_LONG, SOURCE_GIVEN), 0, numpy.where(divides, payload, 0))
    # An operator evaluated as branches: each operand a branched operator in its turn, or a value tested after its row.
    branches = tpl('BRANCHES')
    past = (is_op('LOGICAL_AND') & csense) | (is_op('LOGICAL_OR') & ~csense)
    sense = numpy.where(is_op('NOT'), ~csense, numpy.where((slot == 0) & past & is_op('LOGICAL_AND', 'LOGICAL_OR'), ~csense, csense))
    rule(branches & (slot < 2), 1, 0, numpy.where(own_branched, SOURCE_NONE, SOURCE_GIVEN), numpy.where(own_branched, 0x40, 0x10) | numpy.where(sense, 0x20, 0),
         numpy.where(logical, bytes_ | deep, bytes_))
    # The root: its consumer's context and target, given; a statement's condition that is branches.
    evaluated[root] = 1
    address[root] = raw['cctx'][root] & 1
    source[root] = numpy.where(raw['ctw'][root] != 0, SOURCE_UP, SOURCE_NONE)
    state[root] = raw['state'][root] & 0x7e
    need[root & (op == O['CONDITION'])] |= bytes_ | deep
    # Its discard: where its target is void and it is no address, a store of an aggregate, a bit-field's assignment or
    # update, or a comma.
    target_void = (raw['ts'] & SOURCE_VOID) != 0
    store = own_op('ASSIGN', 'INITIALIZE') & ((facts & 1) != 0)
    field = ((op == O['ASSIGN']) | ((op >= UPDATES[0]) & (op <= UPDATES[1]))) & ((raw['lfl'] & 4) != 0)
    discard = (address == 0) & target_void & (store | field | (op == O['COMMA']))
    discard[root] = (raw['cctx'][root] & 4) != 0
    return {'evaluated': evaluated, 'address': address, 'source': source, 'state': state, 'discard': discard.astype(numpy.int64), 'need': need, 'parent': parent, 'child': child}


def templates(d, p):
    # A record's template from its own line, its operands' and its context (node_machine_classify and its kin). -1
    # where the restated rule can't say (it would need what the lines don't hold), with `need` saying what was read.
    raw = d['raw']
    count = d['count']
    op, w, st, fl, ob = raw['op'], raw['w'], raw['st'], raw['fl'], raw['ob']
    cls, facts, kind = w & 0xff, (w >> 8) & 0xff, (w >> 16) & 0xff
    category, constant = st & 3, (st >> 2) & 7
    wide = (st & 0x80) != 0
    effects = (fl & 0x810) != 0
    aggregate = (facts & 1) != 0
    address_value = (facts & 4) != 0
    rc = numpy.where(aggregate, 8, cls)
    scalar_class = (rc >= 1) & (rc <= 10)
    plain = scalar_class & ~aggregate
    address = (raw['ctx'] & 1) != 0
    discard = (raw['ctx'] & 4) != 0
    branched = (raw['state'] & 0x40) != 0
    root = d['root']
    child = p['child']
    left_truth = numpy.where(child[0] >= 0, raw['tr'][numpy.maximum(child[0], 0)], 0)
    c0, c1 = raw['c0'], raw['c1']
    c0cls, c0facts, c0kind = c0 & 0xff, (c0 >> 8) & 0xff, (c0 >> 16) & 0xff
    c1cls, c1facts, c1kind = c1 & 0xff, (c1 >> 8) & 0xff, (c1 >> 16) & 0xff
    lw, lst, lfl, lob, lop = raw['lw'], raw['lst'], raw['lfl'], raw['lob'], raw['lop']
    lcls, lfacts = lw & 0xff, (lw >> 8) & 0xff
    rw, rst, rfl, rop = raw['rw'], raw['rst'], raw['rfl'], raw['rop']
    rcls, rfacts = rw & 0xff, (rw >> 8) & 0xff
    scalar = lambda c: (c >= 1) & (c <= 10)
    testable = lambda word: (((word >> 8) & 1) == 0) & ((word & 0xff) < 14) & ((word & 0xff) != 0) & (((word >> 16) & 0xff) != 12) & (((word >> 16) & 0xff) != 13)
    is_op = lambda *names: numpy.isin(op, [O[x] for x in names])
    out = numpy.full(count, -2, dtype=numpy.int64)
    need = numpy.zeros(count, dtype=numpy.int64)
    bytes_, down, payload, identity, deep, operand, converted = 1, 2, 4, 8, 16, 32, 64
    todo = numpy.ones(count, dtype=bool)

    def rule(mask, value, n=0):
        nonlocal todo
        mask = mask & todo
        out[mask] = value[mask] if isinstance(value, numpy.ndarray) else value
        need[mask] |= n[mask] if isinstance(n, numpy.ndarray) else n
        todo = todo & ~mask

    NONE = T['NONE']
    # An operator evaluated as branches, and a call: their own rules.
    rule(branched, T['BRANCHES'], down | converted)
    result_plain = ((scalar(cls)) | (cls == 0)) & ((facts & 0xc3) == 0)
    rule(is_op('CALL'), numpy.where(~address & result_plain, T['CALL'], NONE), down | identity)
    # The refusals every operator shares.
    rule(((facts & 0x82) != 0) | (is_op('CAST') & ((raw['cf0'] & 0x400) != 0)), NONE)
    rule(is_op('VALUE') & ((ob & 2) != 0) & ((ob & 8) != 0) & ((ob & 16) == 0), NONE, identity)
    rule(~address & (category == 1) & ((facts & 0x40) != 0), NONE, down)
    # A folded constant.
    folds = (constant != 0) & ~is_op('INITIALIZE') & ~effects & (((category == 0) & ~address) | ((address | address_value) & (constant == 3)))
    address_takes = ((ob & 1) == 0) | ((ob & 2) != 0)
    takes = numpy.where(constant == 3, address_takes, ((facts & 3) == 0) & (((cls >= 1) & (cls <= 8)) | ((constant == 2) & ((cls == 9) | (cls == 10)))))
    rule(folds, numpy.where(discard | takes, T['CONSTANT'], NONE), numpy.where(constant == 3, down | identity, down))
    # One case an operator.
    value = is_op('VALUE')
    void = (cls == 0) & (kind == 1)
    rule(value & void, T['VOID'])
    rule(value & (address | address_value), numpy.where(address_takes, T['ADDRESS'], NONE), down | identity)
    rule(value & (category == 1) & ((ob & 2) != 0) & plain, numpy.where((ob & 4) != 0, T['LOCAL'], T['GLOBAL']), down | identity)
    rule(value, NONE)
    rule(is_op('CAST', 'CONVERT', 'POSITIVE'), numpy.where(rc < 14, T['PASS'], NONE))
    loads = ~address & ~address_value
    member = is_op('MEMBER', 'ARROW')
    rule(member, numpy.where(((fl & 4) == 0) & (raw['mo'] == 0) & (~loads | scalar_class), T['MEMBER'], NONE), down)
    sums = is_op('ADD', 'SUBTRACT', 'SUBSCRIPT')
    left_pointer = (c0facts & 8) != 0
    right_pointer = (c1facts & 8) != 0
    vector = (fl & 0x1000) != 0
    pointer = ~vector & left_pointer & ~right_pointer & (~is_op('SUBSCRIPT') | address | address_value | scalar_class)
    rule(sums & pointer, T['POINTER'], down | converted)
    rule(sums & ~is_op('SUBSCRIPT') & plain & ~vector & ~left_pointer & ~right_pointer & scalar(c0cls) & scalar(c1cls), T['BINARY'], converted)
    rule(sums, NONE, converted)
    rule(is_op('NEGATIVE', 'BIT_NOT'), numpy.where(plain, T['UNARY'], NONE))
    rule(is_op('NOT', 'CONDITION'), numpy.where(plain & ((c0facts & 1) == 0) & (c0cls < 14) & (c0cls != 0), T['TRUTH'], NONE), converted)
    stores = is_op('ASSIGN', 'INITIALIZE')
    field = is_op('ASSIGN') & ((lfl & 4) != 0)
    storable = plain & ((lfacts & 0x40) == 0) & ~field
    target = numpy.where(is_op('INITIALIZE'), numpy.where(root, raw['ro'], 0), numpy.where(lop == O['VALUE'], lob, 0))
    named = ((target & 1) != 0) & ((target & 2) != 0)
    rule(stores & storable & named, numpy.where((target & 4) != 0, T['STORE_LOCAL'], T['STORE_GLOBAL']), operand | identity)
    rule(stores & storable & is_op('ASSIGN'), T['STORE'], operand)
    rule(stores, NONE, operand)
    rule(is_op('ADDRESS', 'SELECT'), T['PASS'])
    rule(is_op('DEREFERENCE'), numpy.where(aggregate | address | address_value | scalar_class, T['DEREFERENCE'], NONE), down)
    rule(is_op('COMMA'), numpy.where(plain, T['PASS'], NONE))
    # The logical operators and the conditional.
    logical = is_op('LOGICAL_AND', 'LOGICAL_OR', 'CONDITIONAL')
    conditional = is_op('CONDITIONAL')
    rule(logical & address, NONE, down)
    shape = (lop != 255) & (rop != 255) & (~conditional | (raw['top'] != 255))
    classed = plain | (conditional & (rc == 0))
    rule(logical & ~(shape & classed), NONE)
    known = (((lst >> 2) & 7) != 0) & ((lfl & 0x800) == 0) & (left_truth != 0)
    truth = left_truth == 2
    decided = known & ~conditional & (is_op('LOGICAL_OR') == truth)
    # Whether the consumer's conversion goes into the arms (node_machine_sinks): a value's context, a conversion to
    # another class of integer, and a constant among what it evaluates.
    tw = raw['tw']
    tcls, tfacts = tw & 0xff, (tw >> 8) & 0xff
    target_class = numpy.where((tfacts & 1) != 0, 8, tcls)
    empty = (rc == target_class) & (rc < 16) & (((facts ^ tfacts) & 0x81) == 0) & (((facts | tfacts) & 2) == 0) & ((tfacts & 0x90) == 0)
    converts = (raw['ctx'] == 0) & (tw != 0) & (raw['same'] == 0) & ~empty & (target_class >= 1) & (target_class <= 8)
    integer = lambda standing, word, flags: (((standing >> 2) & 7) == 1) & ((standing & 3) == 0) & ((word & 0xff) >= 1) & ((word & 0xff) <= 8) & ((flags & 0x810) == 0)
    arm_b = integer(rst, rw, rfl) & ~(known & ~truth)
    arm_c = (((raw['tst'] >> 2) & 7) == 1) & ((raw['tst'] & 3) == 0) & ~(known & truth)
    sunk = plain & converts & numpy.where(conditional, arm_b | arm_c, ~known | decided)
    rule(logical & sunk, NONE, down | operand | payload)
    rule(logical & known, numpy.where(conditional, T['PASS'], numpy.where(decided, T['DECIDED'], numpy.where(testable(c1), T['SECOND'], NONE))), operand | payload | converted)
    rule(logical, numpy.where(testable(c0) & (conditional | testable(c1)), T['BRANCH'], NONE), operand | converted)
    # The updates.
    updates = (op >= 38) & (op <= 51)
    increment = (op >= 38) & (op <= 41)
    rule(updates & ~(plain & ~address), NONE, down)
    excluded = 0xc3
    stored_pointer = (lfacts & 8) != 0
    name = lop == O['VALUE']
    plan = (lop != 255) & (increment | (rop != 255)) & ((lst & 3) == 1) & scalar(lcls) & scalar(c0cls) & (((lfacts | c0facts) & excluded) == 0) & ((lfl & 0x1004) == 0) & \
           (~name | (((lob & 2) != 0) & ((lob & 32) == 0))) & (increment | stored_pointer | (scalar(c1cls) & ((c1facts & excluded) == 0)))
    divides = is_op('DIVIDE_ASSIGN', 'REMAINDER_ASSIGN') & (((rst >> 2) & 7) == 1)
    rule(updates, numpy.where(plan, T['UPDATE'], NONE), numpy.where(divides, operand | converted | identity | payload, operand | converted | identity))
    # The other binary operators.
    binary = (op >= 7) & (op <= 20)
    divides = is_op('DIVIDE', 'REMAINDER') & (((rst >> 2) & 7) == 1)
    rule(binary, numpy.where(plain & scalar(c0cls) & scalar(c1cls) & ((c0facts & 1) == 0), T['BINARY'], NONE), numpy.where(divides, converted | payload, converted))
    return out, need


def report(name, wrong, mask, raw, label, show):
    total = int(mask.sum())
    bad = wrong & mask
    print('   %-10s %8d records, %d differ' % (name, total, int(bad.sum())))
    if bad.any():
        groups = collections.Counter(zip(raw['ctpl'][bad].tolist(), raw['cop'][bad].tolist(), raw['slot'][bad].tolist(), raw['op'][bad].tolist(), label[bad].tolist()))
        for (ctpl, cop, slot, op, text), n in groups.most_common(show):
            print('        %5d: consumer %s as %s, slot %d, record %s: %s' % (n, F.op_name(cop), 'root' if ctpl == 255 else F.template_name(ctpl), slot, F.op_name(op), text))


def main():
    arguments = sys.argv[1:]
    directory = 'columns'
    show = 12
    while arguments:
        if arguments[0] == '--npz':
            directory = arguments[1]; arguments = arguments[2:]
        elif arguments[0] == '--show':
            show = int(arguments[1]); arguments = arguments[2:]
        else:
            raise SystemExit('unknown argument ' + arguments[0])
    for corpus in F.CORPORA:
        d = F.load(corpus, directory)
        raw, a = d['raw'], d['a']
        p = operands(d)
        answered = d['answered']
        was = a['evaluated'] != 0
        print('== %s: %d records C answers for' % (corpus, int(answered.sum())))
        unruled = answered & (p['evaluated'] < 0)
        if unruled.any():
            groups = collections.Counter(zip(raw['ctpl'][unruled].tolist(), raw['cop'][unruled].tolist(), raw['slot'][unruled].tolist(), a['evaluated'][unruled].tolist()))
            print('   no rule for %d records: %s' % (int(unruled.sum()), ', '.join('%s/%s/%d evaluated=%d: %d' % (F.template_name(k[0]) if k[0] != 255 else 'root', F.op_name(k[1]), k[2], k[3], n)
                                                                                 for k, n in groups.most_common(show))))
        ruled = answered & (p['evaluated'] >= 0)
        text = numpy.array(['' for _ in range(d['count'])], dtype=object)
        report('evaluated', p['evaluated'] != a['evaluated'], ruled, raw, numpy.char.add(numpy.char.add('C ', a['evaluated'].astype(str)), numpy.char.add(' rule ', p['evaluated'].astype(str))), show)
        both = ruled & was & (p['evaluated'] == 1)
        report('address', p['address'] != a['address'], both, raw, numpy.char.add('C ', a['address'].astype(str)), show)
        report('discard', p['discard'] != a['discard'], both, raw, numpy.char.add('C ', a['discard'].astype(str)), show)
        report('target', (p['source'] & a['selector']) == 0, both, raw, numpy.char.add(numpy.char.add('C\'s sources ', a['selector'].astype(str)), numpy.char.add(' rule ', p['source'].astype(str))), show)
        rest = raw['state'] & 0x7e
        report('state', p['state'] != rest, both, raw, numpy.char.add(numpy.char.add('C ', rest.astype(str)), numpy.char.add(' rule ', p['state'].astype(str))), show)
        # A direct update's destination has its split's bit and no other.
        unevaluated = ruled & ~was & (p['evaluated'] == 0)
        report('state (not evaluated)', p['state'] != (raw['state'] & 0x7e), unevaluated, raw, numpy.char.add('C ', (raw['state'] & 0x7e).astype(str)), show)
        needs = collections.Counter()
        for bit, word in enumerate(NEED):
            needs[word] = int(((p['need'] >> bit) & 1)[ruled].sum())
        plain = int((p['need'][ruled] == 0).sum())
        print('   what the operand\'s rule read beyond the consumer\'s template, its operator and the slot: nothing %d (%.2f%%); %s' %
              (plain, 100.0 * plain / int(ruled.sum()), ', '.join('%s %d (%.2f%%)' % (k, v, 100.0 * v / int(ruled.sum())) for k, v in needs.items())))
        sources = collections.Counter(p['source'][both].tolist())
        names = {SOURCE_GIVEN: "T's conversion", SOURCE_NODE: "the consumer's type", SOURCE_LONG: 'long', SOURCE_VOID: 'void', SOURCE_NONE: 'none', SOURCE_UP: "the root's, given"}
        print('   targets by source: %s' % ', '.join('%s %d (%.1f%%)' % (names.get(k, k), v, 100.0 * v / int(both.sum())) for k, v in sources.most_common()))
        made = d['made']
        t, tneed = templates(d, p)
        unruled = made & (t < 0)
        print('   templates: %d records; no rule for %d' % (int(made.sum()), int(unruled.sum())))
        bad = made & (t >= 0) & (t != a['template'])
        print('   templates that differ: %d' % int(bad.sum()))
        groups = collections.Counter(zip(raw['op'][bad].tolist(), a['template'][bad].tolist(), t[bad].tolist()))
        for (o, was_t, rule_t), n in groups.most_common(show * 2):
            print('        %5d: %s: C %s, rule %s' % (n, F.op_name(o), F.template_name(was_t), F.template_name(rule_t)))
        tn = collections.Counter()
        for bit, word in enumerate(('bytes', 'down', 'payload', 'identity', 'deep', 'operand', 'converted')):
            tn[word] = int(((tneed >> bit) & 1)[made].sum())
        print('   what a template\'s rule read beyond the record\'s own line: %s' % ', '.join('%s %d (%.2f%%)' % (k, v, 100.0 * v / int(made.sum())) for k, v in tn.items() if v))
        same = int((a['same'][both] != 0).sum())
        none = int(((a['selector'][both] & SOURCE_NONE) != 0).sum())
        print('   evaluated records %d: target none %d (%.1f%%); the record\'s own type %d (%.1f%%); another type %d (%.1f%%)' %
              (int(both.sum()), none, 100.0 * none / int(both.sum()), same, 100.0 * same / int(both.sum()), int(both.sum()) - none - same, 100.0 * (int(both.sum()) - none - same) / int(both.sum())))


if __name__ == "__main__":
    main()
