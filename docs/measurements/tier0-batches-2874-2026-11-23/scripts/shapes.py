#!/usr/bin/env python3
"""shapes.py DUMP...: how often a statement's shape repeats in the typed streams (buster#2874).

DUMP is BUSTER_TIER0_DUMP_FILE's output from the experiment build: for each function compiled, its count and its
locals' count, then a record an entry: kind, class, the value's predicates, a label bit, the fusion's key kind, key
class and variant, absorbed, the two depths before the entry, the SIB scale's log2; the value; selection's word.

A statement is a run of entries from one where both value stacks are empty to the next such entry. Its raw key is what
the front's passes read of it: each entry's kind, class and label bit, the predicates of the values the fusion tests
(a constant's, a pointer addition's element size, a store's atomic mark, x = x op v's same local), and a call's effect
on the stacks. Its answer is what selection leaves: each entry's key kind, key class, variant, absorbed mark, depths
and word.
"""
import collections
import struct
import sys

CONST, LOCAL, PTR_ADD, STORE, SET, SET_LOCAL, CALL, TAIL_CALL, X86 = 1, 2, 21, 28, 29, 31, 34, 47, 48
GLOBALS = (4, 5, 32, 33)
FITS, COUNT, ZERO, SIZE, PRODUCT, SAME, SIB, SEQUENTIAL = 1, 2, 4, 8, 16, 32, 64, 128


def functions(path):
    data = open(path, "rb").read()
    at = 0
    while at < len(data):
        count, locals_ = struct.unpack_from("<II", data, at)
        at += 8
        entries = []
        for _ in range(count):
            record = data[at:at + 12]
            value, word = struct.unpack_from("<QQ", data, at + 12)
            entries.append((record, value, word))
            at += 28
        yield locals_, entries


def raw_entry(entries, i):
    record, value, word = entries[i]
    kind, cls, predicates, label = record[0], record[1], record[2], record[3]
    kept = 0
    extra = 0
    if kind == CONST:
        kept = predicates & (FITS | COUNT | ZERO)
    elif kind == PTR_ADD:
        kept = predicates & (SIZE | PRODUCT | SIB)
        extra = record[10]
    elif kind in (STORE, SET):
        kept = predicates & SEQUENTIAL
    elif kind == SET_LOCAL:
        kept = predicates & SAME
    elif kind in (CALL, TAIL_CALL, X86):
        # The call's effect on the two stacks: the depths after it less the depths before it.
        nxt = entries[i + 1][0] if i + 1 < len(entries) else None
        extra = ((nxt[8] - record[8]) & 0xff) | (((nxt[9] - record[9]) & 0xff) << 8) if nxt is not None else 0xffff
    elif kind in GLOBALS:
        # The symbol's access, which the key kind carries.
        extra = record[4]
    return (kind, cls, kept, label, extra)


def answer_entry(entries, i):
    record, value, word = entries[i]
    return (record[4], record[5], record[6], record[7], record[8], record[9], word)


def report(name, keys, lengths):
    total = sum(lengths)
    seen = set()
    hit_entries = 0
    hit_units = 0
    counts = collections.Counter()
    weight = collections.Counter()
    for key, length in zip(keys, lengths):
        if key in seen:
            hit_entries += length
            hit_units += 1
        else:
            seen.add(key)
        counts[key] += 1
        weight[key] += length
    print(f"{name}: {len(keys)} units, {total} entries, {total / max(len(keys), 1):.2f} entries a unit; {len(seen)} distinct")
    print(f"  seen before, in stream order: {100.0 * hit_units / max(len(keys), 1):.1f}% of the units, {100.0 * hit_entries / max(total, 1):.1f}% of the entries")
    ranked = sorted(weight.values(), reverse=True)
    covered = 0
    marks = [16, 64, 256, 1024, 4096, 16384]
    line = []
    for n, w in enumerate(ranked, 1):
        covered += w
        if n in marks:
            line.append(f"top {n}: {100.0 * covered / total:.1f}%")
    print("  entries in the commonest shapes: " + ", ".join(line))
    once = sum(weight[k] for k in counts if counts[k] == 1)
    print(f"  entries in shapes seen once: {100.0 * once / total:.1f}%")


def main():
    statements = []
    statement_lengths = []
    blocks = []
    block_lengths = []
    conflicts = {}
    conflicting = 0
    total_entries = 0
    total_functions = 0
    length_histogram = collections.Counter()
    for path in sys.argv[1:]:
        for locals_, entries in functions(path):
            total_functions += 1
            n = len(entries)
            total_entries += n
            starts = [i for i in range(n) if i == 0 or (entries[i][0][8] == 0 and entries[i][0][9] == 0)]
            starts.append(n)
            for a, b in zip(starts, starts[1:]):
                raw = tuple(raw_entry(entries, i) for i in range(a, b))
                answer = tuple(answer_entry(entries, i) for i in range(a, b))
                statements.append(raw)
                statement_lengths.append(b - a)
                length_histogram[min(b - a, 33)] += b - a
                previous = conflicts.setdefault(raw, answer)
                if previous != answer:
                    conflicting += b - a
            for a in range(0, n, 8):
                b = min(a + 8, n)
                # A block's key needs the entries around it too (fusion looks 5 back and 5 on) and its first depths.
                lo, hi = max(a - 5, 0), min(b + 5, n)
                raw = (entries[a][0][8], entries[a][0][9], a - lo) + tuple(raw_entry(entries, i) for i in range(lo, hi))
                blocks.append(raw)
                block_lengths.append(b - a)
    print(f"{total_functions} functions, {total_entries} entries")
    report("statements", statements, statement_lengths)
    print(f"  entries in statements whose raw key has two answers: {100.0 * conflicting / max(total_entries, 1):.2f}%")
    line = []
    for bound in (4, 8, 16, 32):
        share = sum(v for k, v in length_histogram.items() if k <= bound)
        line.append(f"up to {bound} entries: {100.0 * share / total_entries:.1f}%")
    print("  entries by their statement's length: " + ", ".join(line))
    report("blocks of 8 with 5 entries around", blocks, block_lengths)


if __name__ == "__main__":
    main()
