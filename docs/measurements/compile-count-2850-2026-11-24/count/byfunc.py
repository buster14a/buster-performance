import struct, sys, zlib, hashlib, collections
def uleb(d, at):
    v = 0; s = 0
    while True:
        b = d[at]; at += 1
        v |= (b & 0x7f) << s; s += 7
        if not b & 0x80: return v, at
def load(path):
    d = open(path, 'rb').read()
    w = struct.unpack('<19Q', d[:152])
    assert w[0] == 0xff6c70726f667281 and w[1] == 11
    nrec, ncnt = w[3], w[5]
    rec0 = 152 + w[2]
    cnt0 = rec0 + nrec * 72 + w[4]
    counters = struct.unpack_from('<%dQ' % ncnt, d, cnt0)
    names0 = cnt0 + 8 * ncnt + w[6] + w[7] + w[8]
    names = []
    at, end = names0, names0 + w[12]
    while at < end:
        ulen, at = uleb(d, at); clen, at = uleb(d, at)
        if clen:
            blob = zlib.decompress(d[at:at + clen]); at += clen
        else:
            blob = d[at:at + ulen]; at += ulen
        names += blob.split(b'\x01')
    byhash = {}
    for n in names:
        byhash[struct.unpack('<Q', hashlib.md5(n).digest()[:8])[0]] = n.decode()
    funcs = []
    # CounterPtr (offset 16) is relative to the record; counters are laid out in record order for this writer, so walk.
    index = 0
    for i in range(nrec):
        r = d[rec0 + i * 72: rec0 + (i + 1) * 72]
        nameref, = struct.unpack_from('<Q', r, 0)
        n, = struct.unpack_from('<I', r, 56)
        cptr, = struct.unpack_from('<q', r, 16)
        funcs.append((byhash.get(nameref, hex(nameref)), n, cptr, i))
    return w, counters, funcs
if __name__ == '__main__':
    w, counters, funcs = load(sys.argv[1])
    # Resolve each function's counters by its relative pointer: counter index = (cptr + i*72 - CountersDelta0) / 8, where
    # the first record's counters start at index 0 in the writer's order only if sections are contiguous; derive delta.
    delta = w[13] if w[13] < (1 << 63) else w[13] - (1 << 64)
    out = []
    ok = True
    for name, n, cptr, i in funcs:
        start = (cptr + i * 72 - delta)
        if start % 8 or start < 0 or start // 8 + n > len(counters):
            ok = False; break
        s = start // 8
        out.append((sum(counters[s:s + n]), max(counters[s:s + n]) if n else 0, n, name))
    print('resolved by pointers:', ok, 'functions', len(funcs), 'total', sum(o[0] for o in out), 'of', sum(counters))
    out.sort(reverse=True)
    top = int(sys.argv[2]) if len(sys.argv) > 2 else 40
    total = sum(counters)
    acc = 0
    for s, m, n, name in out[:top]:
        acc += s
        print(f'{s:>12} {100*s/total:5.1f}% {100*acc/total:5.1f}%  max {m:>10}  n {n:>5}  {name[:90]}')
