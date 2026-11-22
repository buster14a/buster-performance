import struct, sys
# refs.py RECORDING.boundary: for each supplied body, whether the objects its function names (the fix-ups) are its
# reference list, and what each has that the other doesn't.
data = open(sys.argv[1], 'rb').read()
magic, version, tokens, count = struct.unpack_from('<4I', data, 0)
blob, = struct.unpack_from('<Q', data, 16)
rows = [struct.unpack_from('<6IQ', data, 24 + 32 * i) for i in range(count)]
base = 24 + 32 * count
def column(cursor, size):
    n, = struct.unpack_from('<Q', data, cursor)
    length = n * size
    padded = (length + 7) & ~7
    return data[cursor + 8: cursor + 8 + length], n, cursor + 8 + padded
same = more_refs = more_fix = 0
only_refs_total = only_fix_total = 0
examples = []
for opening, closing, declaration, refusal, entries, _, offset in rows:
    if refusal != 0: continue
    c = base + offset
    refs, n, c = column(c, 4); references = set(struct.unpack_from(f'<{n}I', refs))
    strings, n, c = column(c, 8); string_objects = {struct.unpack_from('<2I', strings, 8 * i)[0] + 1 for i in range(n)}
    runtimes, n, c = column(c, 4)
    fixups, n, c = column(c, 16)
    named = set()
    for i in range(n):
        place, index, name, payload = struct.unpack_from('<4I', fixups, 16 * i)
        if name == 0: named.add(payload)
    if named == references: same += 1
    else:
        a, b = references - named, named - references
        more_refs += bool(a); more_fix += bool(b)
        only_refs_total += len(a); only_fix_total += len(b)
        if len(examples) < 6: examples.append((opening, sorted(a)[:4], sorted(b)[:4], [x in string_objects for x in sorted(a)[:4]]))
supplied = sum(1 for r in rows if r[3] == 0)
print(f'supplied bodies {supplied}: fix-up objects equal to references in {same}; references has more in {more_refs} ({only_refs_total} objects), fix-ups have more in {more_fix} ({only_fix_total} objects)')
for e in examples: print('  opening', e[0], 'only in references', e[1], '(strings?', e[3], ') only in fix-ups', e[2])
