# Exactness of the judge's #3044 prefilter. For every one-byte entry of a multi-length group: an empty entry's head is
# its group's first one-byte entry; a flagged entry's head over the flagged entries alone equals its head over all
# entries (rules.py's: the first entry of the group whose content ends with it); an unflagged entry's full head has its
# own content (an equal entry, which the equal probe already covers). Also prints the flagged fraction.
# Filter: level 8 (content >= 8 bytes): (group, last 8 bytes) seen twice in a bitmap; levels 1..7: receivers with that
# many content bytes set S[h(group, j, bytes)], every entry with more than j content bytes tests its last j bytes at
# each present level j, a hit flags it and sets hit[h]; a receiver whose hit bit is set is flagged.
# Usage: python3 -I filter.py random SEED TRIALS | python3 -I filter.py objects PATHS...
import sys, os, random, collections
M64 = (1 << 64) - 1
GOLD = 0x9E3779B97F4A7C15
def bits_for(count, per):
    b = 9
    while (1 << b) < per * count:
        b += 1
    return b
def h(gid, j, t, b):
    x = (t + gid * 0xD6E8FEB86659FD93 + j * 0xA0761D6478BD642F) & M64
    return ((x * GOLD) & M64) >> (64 - b)
def key0(c):
    n = min(len(c), 8)
    k = 0
    for i in range(n):
        k |= c[len(c) - 1 - i] << (56 - 8 * i)
    return k
def check(ents, per=16):
    # ents: list of (gid, unit, content without terminator); returns (ok, considered, flagged, problems)
    by = collections.defaultdict(list)
    for i, (g, u, c) in enumerate(ents):
        if u == 1:
            by[g].append(i)
    multi = {g for g, ids in by.items() if len(set(len(ents[i][2]) for i in ids)) > 1}
    cand = [i for g in multi for i in by[g]]
    longs = [i for i in cand if len(ents[i][2]) >= 8]
    shorts = [i for i in cand if 1 <= len(ents[i][2]) <= 7]
    b8 = bits_for(len(longs), per)
    bs = bits_for(len(shorts), per)
    seen = set(); twice = set()
    for i in longs:
        g, u, c = ents[i]
        x = h(g, 8, key0(c), b8)
        if x in seen:
            twice.add(x)
        seen.add(x)
    S = set(); present = set()
    for i in shorts:
        g, u, c = ents[i]
        S.add(h(g, len(c), key0(c) >> (64 - 8 * len(c)), bs))
        present.add(len(c))
    hit = set(); flagged = set()
    for i in cand:
        g, u, c = ents[i]
        k = len(c)
        kk = key0(c)
        for j in sorted(present):
            if j < k and j <= 7:
                x = h(g, j, kk >> (64 - 8 * j), bs)
                if x in S:
                    flagged.add(i)
                    hit.add(x)
        if k >= 8 and h(g, 8, kk, b8) in twice:
            flagged.add(i)
    for i in shorts:
        g, u, c = ents[i]
        if h(g, len(c), key0(c) >> (64 - 8 * len(c)), bs) in hit:
            flagged.add(i)
    # Full heads: first entry of the group (one-byte) whose content ends with the entry's.
    head = {}
    first = {}
    for i, (g, u, c) in enumerate(ents):
        if u == 1:
            first.setdefault(g, i)
            for k in range(len(c) + 1):
                head.setdefault((g, c[k:]), i)
    # Restricted heads over flagged entries.
    rhead = {}
    for i in sorted(flagged):
        g, u, c = ents[i]
        for k in range(len(c) + 1):
            rhead.setdefault((g, c[k:]), i)
    problems = 0
    for i in cand:
        g, u, c = ents[i]
        full = head[(g, c)]
        if len(c) == 0:
            ok = full == first[g]
        elif i in flagged:
            ok = rhead[(g, c)] == full
        else:
            ok = ents[full][2] == c
        if not ok:
            problems += 1
    return problems == 0, len(cand), len(flagged), problems

def trial(rng):
    alpha = rng.choice([b'ab', b'abc', bytes([97, 98, 0x80, 0xff])])
    tails = [bytes(rng.choice(alpha) for _ in range(rng.randint(0, 12))) for _ in range(3)]
    words = []
    for _ in range(rng.randint(1, 60)):
        r = rng.random()
        if r < 0.25 and words:
            w = rng.choice(words)  # duplicate
        elif r < 0.6:
            w = rng.choice(tails)
            w = bytes(rng.choice(alpha) for _ in range(rng.choice([0, 1, 2, 6, 7, 8, 9, 10, 16, 17]))) + w
            w = w[-rng.choice([len(w), 7, 8, 9, 15, 16, 17]):] if w else w
        elif r < 0.8 and words:
            w = rng.choice(words)
            w = w[rng.randint(0, len(w)):]  # a suffix of an earlier word
        else:
            w = bytes(rng.choice(alpha) for _ in range(rng.randint(0, 20)))
        words.append(w)
    gids = [rng.choice([0, 1, 0x100, 0xffffffff]) for _ in words] if rng.random() < 0.3 else [0] * len(words)
    units = [2 if rng.random() < 0.05 else 1 for _ in words]
    return [(g, u, w) for g, u, w in zip(gids, units, words)]

if __name__ == '__main__':
    if sys.argv[1] == 'random':
        rng = random.Random(int(sys.argv[2]))
        bad = 0; cons = 0; fl = 0
        for t in range(int(sys.argv[3])):
            ents = trial(rng)
            for per in (16, 1):
                ok, n, f, p = check(ents, per)
                bad += not ok
                if per == 16:
                    cons += n; fl += f
                if not ok and bad < 4:
                    print('MISMATCH per', per, ents)
        print('random seed %s trials %s: failing checks %d; flagged %d of %d considered at 16 bits an entry' % (sys.argv[2], sys.argv[3], bad, fl, cons))
    else:
        here = os.path.dirname(os.path.abspath(__file__))
        src = open(os.path.join(here, '..', 'rules.py')).read().replace('\nmain()\n', '\n')
        rules = {}
        exec(compile(src, 'rules.py', 'exec'), rules)
        groups, secs, ents_r = rules['entries_of'](sys.argv[2:])
        ents = [(g, u, c[:-u] if u == 1 else c) for (g, u, a, c) in ents_r]
        for per in (16, 8):
            ok, n, f, p = check(ents, per)
            print('%d bits an entry: %s; one-byte entries of multi-length groups %d, flagged %d (%.1f%%), problems %d' % (per, 'exact' if ok else 'NOT EXACT', n, f, 100.0 * f / max(n, 1), p))
