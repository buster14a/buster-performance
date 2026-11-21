# Models of foreign string merging's one-byte suffix rule (#3044): the naive reference (as foreign_strings_test.c's),
# the branch's ctz-list index, and the proposed sort-based design. Prints counts and checks all three agree.
import sys, struct, random
from collections import defaultdict

NONE = -1

def ctz(v):
    return 64 if v == 0 else (v & -v).bit_length() - 1

def roundup(v, a):
    return (v + a - 1) // a * a

def entries_of(inputs):
    ents = []
    for s, (data, group, align_log2, unit_log2) in enumerate(inputs):
        unit = 1 << unit_log2
        begin = 0
        while begin < len(data):
            end = begin
            while data[end:end + unit] != b'\0' * unit:
                end += unit
            L = end - begin + unit
            t = ctz(begin) if begin != 0 else 64
            a = min(t, align_log2)
            ents.append((data[begin:begin + L], group, unit, a))
            begin = end + unit
    return ents

def naive(ents):
    out = []
    owner = []
    size = 0
    for x, (c, g, u, a) in enumerate(ents):
        A = 1 << a
        L = len(c)
        found = None
        for p in range(x):
            if owner[p] and ents[p][1] == g and ents[p][2] == u and len(ents[p][0]) == L and out[p] % A == 0 and ents[p][0] == c:
                found = out[p]
                break
        if found is None and u == 1:
            for p in range(x):
                if owner[p] and ents[p][1] == g and ents[p][2] == 1 and len(ents[p][0]) > L:
                    sh = out[p] + len(ents[p][0]) - L
                    if sh % A == 0 and ents[p][0].endswith(c):
                        found = sh
                        break
        owner.append(found is None)
        if found is None:
            found = roundup(size, A)
            size = found + L
        out.append(found)
    return out, size

def branch(ents):
    cand = set((g, c) for (c, g, u, a) in ents if u == 1)
    s1 = defaultdict(list)
    s2 = defaultdict(list)
    out = []
    size = 0
    for x, (c, g, u, a) in enumerate(ents):
        A = 1 << a
        L = len(c)
        found = None
        for off in s1[(g, u, c)]:
            if off % A == 0:
                found = off
                break
        if found is None and u == 1:
            for off in s2.get((g, c), ()):
                if off % A == 0:
                    found = off
                    break
        if found is None:
            found = roundup(size, A)
            size = found + L
            s1[(g, u, c)].append(found)
            if u == 1:
                end = found + L
                for d in range(1, L):
                    key = (g, c[L - d:])
                    if key in cand:
                        lst = s2[key]
                        sh = end - d
                        if not lst or ctz(sh) > ctz(lst[-1]):
                            lst.append(sh)
        out.append(found)
    return out, size

class Stats(defaultdict):
    def __init__(self):
        super().__init__(int)

def key_chunk(c, t):
    # Chunk t of the reversed content (terminator excluded), as the masked u64 load from (terminator - 8(t+1)) reads it:
    # the byte just before the terminator is the most significant.
    body = c[:-1]
    k = len(body)
    lo = max(0, k - 8 * (t + 1))
    hi = max(0, k - 8 * t)
    chunk = body[lo:hi]
    v = 0
    for i in range(8):
        pos = hi - 1 - i
        v = (v << 8) | (body[pos] if pos >= lo else 0)
    return v

def design(ents, st):
    n = len(ents)
    groups = defaultdict(list)
    for x, (c, g, u, a) in enumerate(ents):
        if u == 1:
            groups[g].append(x)
    sorted_group = {}
    cls_of = [NONE] * n
    classes = []  # per class: dict
    for g, ids in groups.items():
        lengths = set(len(ents[x][0]) for x in ids)
        if len(lengths) < 2:
            continue
        sorted_group[g] = True
        st['sorted_groups'] += 1
        st['sorted_entries'] += len(ids)
        # Radix statistics: varying bytes of key0, and runs tied on key0 that need further chunks.
        k0 = [key_chunk(ents[x][0], 0) for x in ids]
        vary = 0
        for v in k0:
            vary |= v ^ k0[0]
        st['key0_varying_bytes_max'] = max(st['key0_varying_bytes_max'], sum(1 for i in range(8) if (vary >> (8 * i)) & 0xff))
        order = sorted(ids, key=lambda x: (ents[x][0][:-1][::-1], x))
        # Tie runs on key0 among entries that are not all one content.
        i = 0
        while i < len(order):
            j = i + 1
            while j < len(order) and key_chunk(ents[order[j]][0], 0) == key_chunk(ents[order[i]][0], 0):
                j += 1
            if j - i > 1:
                contents = set(ents[order[q]][0] for q in range(i, j))
                maxk = max(len(ents[order[q]][0]) - 1 for q in range(i, j))
                if maxk > 8:
                    st['tied_entries'] += j - i
                    st['tied_runs'] += 1
                    st['tied_distinct'] += len(contents)
                    st['tied_chunks_max'] = max(st['tied_chunks_max'], (maxk + 7) // 8)
            i = j
        base = len(classes)
        prev = None
        for x in order:
            c = ents[x][0]
            if prev is None or c != prev:
                classes.append({'first': x, 'k': len(c) - 1, 'content': c, 'size': 0, 'lcp': 0})
                if prev is not None:
                    r1 = prev[:-1][::-1]
                    r2 = c[:-1][::-1]
                    l = 0
                    while l < len(r1) and l < len(r2) and r1[l] == r2[l]:
                        l += 1
                    classes[-1]['lcp'] = l
                    if l >= 8:
                        st['lcp_past_key0'] += 1
                prev = c
            classes[-1]['size'] += 1
            cls_of[x] = len(classes) - 1
        end = len(classes)
        st['classes'] += end - base
        # Blocks: an internal class's block runs while the next classes' lcp reaches its length.
        for ci in range(base, end):
            cl = classes[ci]
            j = ci + 1
            mn = 1 << 62
            while j < end and classes[j]['lcp'] >= cl['k']:
                mn = min(mn, classes[j]['first'])
                j += 1
            cl['block_end'] = j
            cl['mprime'] = mn
            if j > ci + 1:
                st['internal_classes'] += 1
                st['scan_classes'] += j - (ci + 1)
                st['scan_vectors'] += (j - (ci + 1) + 15) // 16
            cl['need'] = 0
            cl['lastq'] = -1
            cl['np'] = NONE
        for x in ids:
            cl = classes[cls_of[x]]
            a = ents[x][3]
            if a >= 1:
                st['aligned_entries'] += 1
            if a >= 1 and cl['mprime'] < x:
                cl['need'] = max(cl['need'], a)
                cl['lastq'] = max(cl['lastq'], x)
        for ci in range(base, end):
            cl = classes[ci]
            if cl['need'] >= 1:
                st['needing_classes'] += 1
                st['needing_k%d_need%d' % (cl['k'], cl['need'])] += 1
                st['paint'] += cl['block_end'] - (ci + 1)
                for j in range(ci + 1, cl['block_end']):
                    classes[j]['np'] = ci
    # The sequential loop.
    active = [cl['need'] >= 1 for cl in classes]
    up = [cl['np'] for cl in classes]
    own = defaultdict(list)
    rec = defaultdict(list)
    maxctz = defaultdict(lambda: -1)
    s1 = defaultdict(list)
    out = []
    size = 0

    def find(v):
        while v != NONE and not active[v]:
            w = up[v]
            st['find_steps'] += 1
            if w != NONE and not active[w]:
                up[v] = up[w]
            v = w
        return v

    for x, (c, g, u, a) in enumerate(ents):
        A = 1 << a
        L = len(c)
        found = None
        if u == 1 and g in sorted_group:
            ci = cls_of[x]
            cl = classes[ci]
            for off in own[ci]:
                st['own_reads'] += 1
                if off % A == 0:
                    found = off
                    break
            if found is None and a == 0 and cl['mprime'] < x:
                p = cl['mprime']
                found = out[p] + len(ents[p][0]) - L
                st['shared_static'] += 1
            elif found is None and a >= 1 and cl['mprime'] < x:
                st['aligned_lookups'] += 1
                for off in rec[ci]:
                    st['record_reads'] += 1
                    if off % A == 0:
                        found = off
                        break
                if found is not None:
                    st['shared_aligned'] += 1
            if found is None:
                found = roundup(size, A)
                size = found + L
                if own[ci]:
                    assert ctz(found) > ctz(own[ci][-1])
                    st['extra_own_owners'] += 1
                own[ci].append(found)
                st['owners'] += 1
                st['owner_depths'] += L - 1
                end_off = found + L
                d = find(up[ci])
                while d != NONE:
                    st['visits'] += 1
                    dl = classes[d]
                    if x > dl['lastq']:
                        active[d] = False
                        st['deactivate_late'] += 1
                    else:
                        sh = end_off - (dl['k'] + 1)
                        t = ctz(sh)
                        if t > maxctz[d]:
                            rec[d].append(sh)
                            maxctz[d] = t
                            st['records'] += 1
                            if t >= dl['need']:
                                active[d] = False
                                st['deactivate_met'] += 1
                        else:
                            st['wasted_visits'] += 1
                    d = find(up[d])
        else:
            for off in s1[(g, u, c)]:
                if off % A == 0:
                    found = off
                    break
            if found is None:
                found = roundup(size, A)
                size = found + L
                s1[(g, u, c)].append(found)
        out.append(found)
    return out, size

def branch_depths(ents):
    # The branch's per-owner walk: depths walked and depths at a candidate length (its present bitmap).
    cand_len = defaultdict(set)
    for (c, g, u, a) in ents:
        if u == 1:
            cand_len[g].add(len(c))
    return cand_len

def parse_elf(data, inputs, include_nonalloc=False):
    if data[:4] != b'\x7fELF' or data[4] != 2:
        return
    shoff = struct.unpack_from('<Q', data, 0x28)[0]
    shentsize, shnum, shstrndx = struct.unpack_from('<HHH', data, 0x3a)
    hdrs = [struct.unpack_from('<IIQQQQIIQQ', data, shoff + i * shentsize) for i in range(shnum)]
    strtab = hdrs[shstrndx]
    for h in hdrs:
        name_off, typ, flags, addr, off, size, link, info, align, entsize = h
        if typ == 1 and (flags & 0x30) == 0x30 and entsize in (1, 2, 4) and ((flags & 2) or include_nonalloc):
            nm = data[strtab[4] + name_off:data.index(b'\0', strtab[4] + name_off)]
            body = data[off:off + size]
            al = (align.bit_length() - 1) if align > 1 else 0
            inputs.append((body, (nm, flags, entsize), al, {1: 0, 2: 1, 4: 2}[entsize]))

def parse_path(path, inputs):
    data = open(path, 'rb').read()
    if data[:8] == b'!<arch>\n':
        pos = 8
        while pos + 60 <= len(data):
            hdr = data[pos:pos + 60]
            size = int(hdr[48:58].decode().strip())
            body = data[pos + 60:pos + 60 + size]
            parse_elf(body, inputs)
            pos += 60 + size + (size & 1)
    else:
        parse_elf(data, inputs)

def dense_groups(inputs):
    ids = {}
    res = []
    for (b, g, al, ul) in inputs:
        res.append((b, ids.setdefault(g, len(ids) + 1), al, ul))
    return res

def report(name, ents, st, check_branch=True):
    out_d, size_d = design(ents, st)
    ok = True
    if check_branch:
        out_b, size_b = branch(ents)
        ok = out_b == out_d and size_b == size_d
    one = sum(1 for e in ents if e[2] == 1)
    print(f"{name}: entries {len(ents)} one-byte {one} pool {size_d} agree {ok}")
    print("  " + " ".join(f"{k}={v}" for k, v in sorted(st.items())))
    return ok

def random_trials(seed, trials, naive_check=True):
    rng = random.Random(seed)
    bad = 0
    tot = Stats()
    for trial in range(trials):
        bases = [bytes(rng.choice(b'ab') for _ in range(rng.randint(1, 23))) + b'\0' for _ in range(3)]
        inputs = []
        for s in range(rng.randint(0, 8)):
            data = b''
            for w in range(rng.randint(0, 12)):
                bs = rng.choice(bases)
                data += bs[rng.randint(0, len(bs) - 1):]
            inputs.append((data, rng.randint(0, 2), rng.randint(0, 3), 0))
        # Some wide inputs too.
        if rng.random() < 0.2:
            inputs.append((b'a\0b\0\0\0', rng.randint(0, 2), 1, 1))
        ents = entries_of(inputs)
        st = Stats()
        o1 = naive(ents) if naive_check else None
        o2 = branch(ents)
        o3 = design(ents, st)
        if (naive_check and o1 != o2) or o2 != o3:
            bad += 1
            if bad < 4:
                print("MISMATCH", trial, inputs, o1, o2, o3)
        for k, v in st.items():
            tot[k] += v
    print(f"random seed {seed}: trials {trials} mismatches {bad}")
    print("  " + " ".join(f"{k}={v}" for k, v in sorted(tot.items())))

def hand_cases():
    both = b"compiler\0piler\0"
    compiler = b"compiler\0"
    piler = b"piler\0"
    xpiler = b"xpiler\0"
    cases = [
        (1000, [(both, 1, 0, 0)], 9, [0, 3]),
        (1001, [(compiler, 1, 0, 0), (piler, 2, 0, 0)], 15, [0, 9]),
        (1002, [(bytes([97, 0, 98, 0, 0, 0]), 3, 1, 1), (bytes([98, 0, 0, 0]), 3, 1, 1), (b"\0", 3, 0, 0), (compiler, 3, 0, 0), (b"\0", 3, 0, 0)], 20, [0, 6, 10, 11, 10]),
        (1003, [(both[:9], 4, 0, 0), (piler, 4, 1, 0)], 16, [0, 10]),
        (1004, [(both[:9], 5, 0, 0), (xpiler, 5, 0, 0), (piler, 5, 1, 0), (piler, 5, 0, 0)], 16, [0, 9, 10, 3]),
        (1005, [(b"piler\0compiler\0piler\0", 6, 0, 0)], 15, [0, 6, 0]),
        (1006, [(b"compiler\0piler\0piler\0", 7, 0, 0), (piler, 7, 1, 0), (piler, 7, 0, 0)], 16, [0, 3, 3, 10, 10]),
        (1007, [(b"compiler\0\0", 0, 0, 0)], 9, [0, 8]),
        (1008, [(b"aa\0ab\0ac\0ad\0ae\0af\0ag\0ah\0ai\0aj\0ak\0", 8, 0, 0), (b"\0", 8, 5, 0)], 33, [0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 32]),
    ]
    allok = True
    for num, inputs, size, offs in cases:
        ents = entries_of(inputs)
        st = Stats()
        o, s = design(ents, st)
        on, sn = naive(ents)
        ok = o == offs and s == size and on == offs and sn == size
        allok &= ok
        print(f"case {num}: design {o} size {s} naive {on} expected {offs} size {size} {'ok' if ok else 'BAD'}")
    return allok

if __name__ == '__main__':
    mode = sys.argv[1]
    if mode == 'hand':
        hand_cases()
    elif mode == 'random':
        random_trials(int(sys.argv[2]), int(sys.argv[3]), naive_check=True)
    elif mode == 'corpus':
        inputs = []
        for p in sys.argv[2:]:
            parse_path(p, inputs)
        inputs = dense_groups(inputs)
        ents = entries_of(inputs)
        gs = defaultdict(int)
        for (b, g, al, ul) in inputs:
            gs[(g, al, ul)] += 1
        print("sections by (group, align_log2, unit_log2):", dict(gs) if len(gs) < 30 else len(gs))
        report(sys.argv[2].split('/')[-1], ents, Stats())
