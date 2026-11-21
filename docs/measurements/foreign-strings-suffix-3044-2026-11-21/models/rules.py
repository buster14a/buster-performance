# Pool sizes of foreign string merging's rules over the SHF_MERGE|SHF_STRINGS sections of ELF objects, in link order.
# main: whole entries only. reference: #3044's branch rule (first earlier equal owner meeting the alignment, else the
# first earlier longer one-byte owner whose end meets it). block: the earliest entry of the group ending with the entry
# (its "block head", necessarily an owner) is the only suffix candidate. flat: block, but only in groups whose one-byte
# entries all have effective alignment 1. Usage: python3 -I rules.py OBJECTS...
import subprocess, re, sys, collections

def sections(path):
    data = open(path, 'rb').read()
    out = []
    for line in subprocess.run(['readelf', '-SW', path], capture_output=True, text=True).stdout.splitlines():
        m = re.match(r'\s*\[\s*\d+\]\s+(\S+)\s+(\S+)\s+[0-9a-f]+\s+([0-9a-f]+)\s+([0-9a-f]+)\s+([0-9a-f]+)\s+(\S*)\s+\d+\s+\d+\s+(\d+)', line)
        if not m or m.group(2) != 'PROGBITS':
            continue
        name, off, size, es, flg, al = m.group(1), int(m.group(3), 16), int(m.group(4), 16), int(m.group(5), 16), m.group(6), int(m.group(7))
        if 'A' in flg and 'M' in flg and 'S' in flg and es in (1, 2, 4) and size != 0:
            out.append((name, flg, es, al, data[off:off + size]))
    return out

def entries_of(paths):
    groups = {}
    ents = []  # (group, unit, alignment, content)
    secs = []
    for p in paths:
        for name, flg, es, al, data in sections(p):
            g = groups.setdefault((name, flg, es), len(groups))
            secs.append((g, es, al, len(data)))
            begin = 0
            for at in range(0, len(data), es):
                if data[at:at + es] == b'\0' * es:
                    off = begin
                    a = al if al else 1
                    while off % a != 0:
                        a //= 2
                    ents.append((g, es, a, data[begin:at + es]))
                    begin = at + es
    return groups, secs, ents

def run(ents, rule):
    size = 0
    out = [0] * len(ents)
    owner = [False] * len(ents)
    equal = collections.defaultdict(list)  # (g, unit, content) -> owner offsets (kept with growing trailing zeros)
    suffix = collections.defaultdict(list)  # (g, content) -> shared offsets of longer one-byte owners
    head = {}
    flat = {}
    if rule in ('block', 'flat'):
        for i, (g, u, a, c) in enumerate(ents):
            if u == 1:
                for k in range(len(c)):
                    head.setdefault((g, c[k:]), i)
                flat[g] = flat.get(g, True) and a == 1
    def first(lst, a):
        for o in lst:
            if o % a == 0:
                return o
        return None
    def keep(lst, o):
        tz = lambda v: (v & -v).bit_length() if v else 64
        if not lst or tz(o) > tz(lst[-1]):
            lst.append(o)
    shared = 0
    for i, (g, u, a, c) in enumerate(ents):
        o = first(equal[(g, u, c)], a)
        if o is None and u == 1:
            if rule == 'reference':
                o = first(suffix[(g, c)], a)
            elif rule == 'block' or (rule == 'flat' and flat[g]):
                h = head[(g, c)]
                if h != i:
                    assert owner[h], (i, h)
                    s = out[h] + len(ents[h][3]) - len(c)
                    o = s if s % a == 0 else None
            shared += o is not None
        if o is None:
            o = (size + a - 1) // a * a
            size = o + len(c)
            owner[i] = True
            keep(equal[(g, u, c)], o)
            if rule == 'reference' and u == 1:
                for k in range(1, len(c)):
                    keep(suffix[(g, c[k:])], o + k)
        out[i] = o
    return size, out, owner

def main():
    groups, secs, ents = entries_of(sys.argv[1:])
    names = {v: k for k, v in groups.items()}
    per = collections.Counter()
    aligns = collections.Counter()
    for g, u, a, c in ents:
        per[(names[g][0], u)] += 1
        aligns[(names[g][0], a)] += 1
    print('sections', len(secs), 'entries', len(ents), 'input bytes', sum(len(e[3]) for e in ents))
    print('entries per group:', dict(per))
    print('entries per (group, effective alignment):', dict(sorted(aligns.items())))
    results = {}
    for rule in ('main', 'reference', 'block', 'flat'):
        results[rule] = run(ents, rule)
        print('%-9s pool %d owners %d' % (rule, results[rule][0], sum(results[rule][2])))
    ref = results['reference'][1]
    # Reference suffix takers (not owners, no equal owner at their offset) by alignment and emptiness, and whether the
    # block head's end is the offset they took.
    import collections as C
    head = {}
    for i, (g, u, a, c) in enumerate(ents):
        if u == 1:
            for k in range(len(c)):
                head.setdefault((g, c[k:]), i)
    owners = results['reference'][2]
    equal_owner = {}
    takers = C.Counter()
    for i, (g, u, a, c) in enumerate(ents):
        if owners[i]:
            equal_owner.setdefault((g, u, c, ref[i]), True)
        if u != 1 or owners[i] or (g, u, c, ref[i]) in equal_owner:
            continue
        h = head[(g, c)]
        at_head = ref[i] == ref[h] + len(ents[h][3]) - len(c)
        takers[(a > 1, len(c) == 1, at_head)] += 1
    print('reference suffix takers by (alignment > 1, empty, at the block head):', dict(sorted(takers.items())))
    for rule in ('block', 'flat'):
        diff = sum(1 for x, y in zip(ref, results[rule][1]) if x != y)
        print('%s: %d entries placed differently from reference; pool %+d bytes' % (rule, diff, results[rule][0] - results['reference'][0]))

main()
