#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# key_probes.py DUMP [OTHER]: which keys decide what, in a dump of evaluated nodes (inventory-dump.patch's, read by
# sweeps.c). Counts, not timings: the readings that chose sweeps.c's keys.
#   1. Type keys: an operator's nodes whose facts (the lowering key's bytes 2 to 8) two nodes with the same key have
#      differently, with the evaluated operands' facts as the key and with the first two operands' types' class and
#      facts added; and, with OTHER, the keys the two dumps answer differently.
#   2. Context keys: an operand's context and target from its node's operator, context, facts and first two operands'
#      facts; with the operand's own operator added; with its own facts added.
#   3. Template keys: the lowering keys (with the operand count) whose nodes wrote different entries, with each
#      answer's entries (K a node's own, V the conversion asked of it; kind/class).
import collections
import struct
import sys

NONE = 0xffffffff
OPS = ['value', '+x', '-x', '!', '~', '+', '-', '*', '/', '%', '<<', '>>', '<', '<=', '>', '>=', '==', '!=', '&', '|', '^', '&&', '||', '?:', 'cast', '&x', '*x', '=',
       ',', '[]', 'sizeof', 'alignof', '.', '->', 'call', 'initialize', 'convert', 'condition', '++x', '--x', 'x++', 'x--', '+=', '-=', '*=', '/=', '%=', '<<=', '>>=',
       '&=', '|=', '^=', 'select', 'builtin-unary', 'builtin-overflow', 'statement-value', 'va_arg', 'vla-bound', 'vla-extent', 'sizeof-vla', 'builtin-misc',
       'builtin-float', 'builtin-query', 'builtin-atomic', '__real', '__imag', 'builtin-vector', 'builtin-x86', 'builtin-bit-cast']


def name(op):
    return OPS[op] if op < len(OPS) else 'op%d' % op


def bodies(path):
    """Each body's nodes: (key, operand nodes in evaluation order, own entries as (what, kind, class)), first pops only."""
    data = open(path, 'rb').read()
    offset = 0
    while offset + 12 <= len(data):
        magic, pop_count, entry_count = struct.unpack_from('<III', data, offset)
        assert magic == 0x59444f42
        kinds = data[offset + 12: offset + 12 + entry_count]
        classes = data[offset + 12 + entry_count: offset + 12 + 2 * entry_count]
        owners = offset + 12 + entry_count * 10
        pops_at = offset + 12 + entry_count * 18
        own = collections.defaultdict(list)
        for e in range(entry_count):
            pop, what = struct.unpack_from('<II', data, owners + e * 8)
            if what <= 1 and pop < pop_count:
                own[pop].append((what, kinds[e], classes[e]))
        fields = [struct.unpack_from('<12I', data, pops_at + p * 80) for p in range(pop_count)]
        keys = [data[pops_at + p * 80 + 48: pops_at + p * 80 + 80] for p in range(pop_count)]
        children = collections.defaultdict(list)
        for p, f in enumerate(fields):
            if f[6] != NONE and f[1] != NONE and f[1] < pop_count:
                children[f[1]].append(p)
        yield [(keys[p], [keys[c] for c in children.get(p, [])], tuple(own.get(p, [])), fields[p][7]) for p in range(pop_count) if fields[p][6] != NONE]
        offset = pops_at + pop_count * 80


def by_operator(table, operator_of):
    per = collections.Counter()
    conflicting = 0
    for key, answers in table.items():
        if len(answers) > 1:
            conflicting += 1
            per[name(operator_of(key))] += sum(answers.values())
    return conflicting, dict(sorted(per.items(), key=lambda item: -item[1]))


def type_tables(path):
    plain = collections.defaultdict(collections.Counter)
    typed = collections.defaultdict(collections.Counter)
    for nodes in bodies(path):
        for key, operands, _, _ in nodes:
            if operands:
                facts = tuple(bytes(k[2:9]) for k in operands[:3])
                plain[(key[0], len(operands), facts)][bytes(key[2:9])] += 1
                typed[(key[0], len(operands), facts, bytes(key[9:13]))][bytes(key[2:9])] += 1
    return plain, typed


def main():
    path = sys.argv[1]
    other = sys.argv[2] if len(sys.argv) > 2 else None
    print('key probes:', path, other or '')
    # 1. Type keys.
    mine = type_tables(path)
    theirs = type_tables(other) if other else None
    for which, label in ((0, "the evaluated operands' facts"), (1, "with the first two operands' types")):
        conflicting, per = by_operator(mine[which], lambda key: key[0])
        print('type keys, %s: keys=%d conflicting=%d nodes-in-them-by-operator=%s' % (label, len(mine[which]), conflicting, per))
        if theirs:
            differing = collections.Counter()
            shared = 0
            for key, answers in mine[which].items():
                if key in theirs[which]:
                    shared += 1
                    if len(answers) == 1 and len(theirs[which][key]) == 1 and next(iter(answers)) != next(iter(theirs[which][key])):
                        differing[name(key[0])] += 1
            print('type keys, %s: keys-in-both-dumps=%d answered-differently-by-operator=%s' % (label, shared, dict(differing)))
    # 2. Context keys.
    variants = [collections.defaultdict(collections.Counter) for _ in range(3)]
    for nodes in bodies(path):
        for key, operands, _, _ in nodes:
            for index, operand in enumerate(operands):
                base = (key[0], key[1], bytes(key[2:9]), len(operands), min(index, 3), tuple(bytes(k[2:9]) for k in operands[:2]))
                answer = (operand[1], operand[13], operand[14])
                variants[0][base][answer] += 1
                variants[1][base + (operand[0],)][answer] += 1
                variants[2][base + (operand[0], bytes(operand[2:9]))][answer] += 1
    for table, label in zip(variants, ("the node's operator, context, facts and first two operands' facts", "with the operand's operator", "with the operand's operator and facts")):
        conflicting, per = by_operator(table, lambda key: key[0])
        print('context keys, %s: keys=%d conflicting=%d operands-in-them-by-the-node\'s-operator=%s' % (label, len(table), conflicting, per))
    # 3. Template keys.
    templates = collections.defaultdict(collections.Counter)
    for nodes in bodies(path):
        for key, operands, own, times in nodes:
            if times <= 1:
                templates[(bytes(key), len(operands))][own] += 1
    conflicts = sorted(((sum(answers.values()), key, answers) for key, answers in templates.items() if len(answers) > 1), key=lambda item: -item[0])
    print('template keys: keys=%d conflicting=%d nodes-in-them=%d' % (len(templates), len(conflicts), sum(item[0] for item in conflicts)))
    for total, (key, count), answers in conflicts[:10]:
        print('  %s context=%02x facts=%s operand-types=%s target=%s store=%02x operands=%d nodes=%d' % (
            name(key[0]), key[1], key[2:9].hex(), key[9:13].hex(), key[13:15].hex(), key[17], count, total))
        for answer, n in answers.most_common(4):
            print('      x%-6d %s' % (n, ' '.join('%s%d/%d' % ('V' if what else 'K', kind, cls) for what, kind, cls in answer)))


main()
