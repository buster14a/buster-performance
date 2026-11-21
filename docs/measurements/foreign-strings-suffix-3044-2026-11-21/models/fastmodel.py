# fastmodel.py DUMP PRODUCER: an independent hashed model of the block-head rule over a dumpsecs.py file, compared with
# the producer's sizes, offsets and pool bytes written by the harness's FASTOUT mode (both paths).
import struct, sys
data = open(sys.argv[1], 'rb').read()
n = struct.unpack_from('<I', data, 0)[0]
at = 4
entries = []  # (group, unit, alignment, bytes incl terminator)
for _ in range(n):
    g, u, a, size = struct.unpack_from('<IBBI', data, at)
    at += 10
    b = data[at:at + size]
    at += size
    unit = 1 << u
    begin = 0
    while begin < size:
        end = begin
        while b[end:end + unit] != b'\0' * unit:
            end += unit
        al = 1 << a
        while begin % al:
            al //= 2
        entries.append((g, unit, al, b[begin:end + unit]))
        begin = end + unit
first = {}
heads = []
for i, (g, unit, al, b) in enumerate(entries):
    if unit == 1:
        c = b[:-1]
        for k in range(len(c) + 1):
            first.setdefault((g, c[len(c) - k:]), i)
        heads.append(first[(g, c)])
    else:
        heads.append(i)
owners = {}
out = []
pool = 0
for i, (g, unit, al, b) in enumerate(entries):
    off = None
    for o in owners.get((g, unit, b), ()):
        if o % al == 0:
            off = o
            break
    h = heads[i]
    if off is None and h < i:
        shared = out[h] + len(entries[h][3]) - len(b)
        if shared % al == 0:
            off = shared
    if off is None:
        off = (pool + al - 1) // al * al
        pool = off + len(b)
        owners.setdefault((g, unit, b), []).append(off)
    out.append(off)
model_pool = bytearray(pool)
for i, (g, unit, al, b) in enumerate(entries):
    model_pool[out[i]:out[i] + len(b)] = b
prod = open(sys.argv[2], 'rb').read()
at = 0
ok = True
for path in ('vector', 'exact'):
    size, count = struct.unpack_from('<II', prod, at)
    at += 8
    offs = struct.unpack_from('<%dI' % count, prod, at)
    at += 4 * count
    pbytes = prod[at:at + size]
    at += size
    same = size == pool and count == len(out) and list(offs) == out and pbytes == bytes(model_pool)
    ok &= same
    print(f'{path}: entries {count} pool {size} model pool {pool} identical: {same}')
sys.exit(0 if ok else 1)
