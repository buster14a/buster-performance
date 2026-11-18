#!/usr/bin/env python3
# roots.py FILE...: the initializations listed after the fourth piece's rules, by what their root's own tests read, and
# what a rule of the root would leave listed.
import sys, collections
here = __file__.rsplit('/', 1)[0]
exec(open(here + '/rules.py').read().split("for path in sys.argv[1:]:")[0])
piece = open(here + '/piece.py').read()
exec(piece[piece.index("ADD, SUBTRACT"):piece.rindex("for path in sys.argv[1:]:")])
ROOT = {0: 'statement', 1: 'condition', 2: 'return', 3: 'switch', 4: 'initializer', 5: 'brace', 6: 'other'}
def top_class(top):
    k = kind(top)
    if not flagged(top): return 'no constant a test reads'
    if k in ('zero', 'tiny', 'small'): return 'an integer constant of 0 to 126'
    if k == 'constant': return 'another integer constant'
    return 'a constant of another kind (%s)' % k
def declared_class(f):
    width, bits, tkind = f['declared'].split('/')
    width, bits = int(width), int(bits, 16)
    if bits == 0: return 'none'
    if bits & 0x02: return 'special'
    if bits & 0x04: return 'aggregate'
    if bits & 0x80: return 'array'
    if bits & 0x08: return 'enumeration'
    if bits & 0x20: return 'pointer'
    if bits & 0x10: return 'floating'
    if width >= 8: return 'integer of 8 bits or more'
    if width: return 'bool'
    return 'other'
for path in sys.argv[1:]:
    table = collections.Counter(); alone = collections.Counter(); verdicts = collections.Counter()
    listed = 0; after = 0; after2 = 0
    for line in open(path, errors='replace'):
        if not line.startswith('census-expr:'): continue
        parts = line.split()
        f = dict(x.split('=', 1) for x in parts[1:11]); ops = [parse(o) for o in parts[11:]]
        w = int(f['why'])
        left = [o for o in ops if not any(r(o) for _, r in RULES)]
        operator = bool(w & 1) and (bool(left) or int(f['trees']) != 0)
        reasons = (1 if operator else 0) | (w & ~1)
        if reasons == 0: continue
        listed += 1
        root_quiet = False; root_quiet2 = False
        if w & 2:
            context = ROOT[int(f['kind'])]
            top = int(f['top'].split('/')[0], 16)
            tc = top_class(top); dc = declared_class(f)
            key = (context, dc, tc)
            table[key] += 1
            if reasons == 2: alone[key] += 1; verdicts[(key, int(f['verdict'], 16) != 0)] += 1
            # the rule: no test of the root's can fire
            if context in ('brace', 'other'): root_quiet = True
            elif dc != 'special' and tc == 'no constant a test reads': root_quiet = True
            elif dc in ('integer of 8 bits or more', 'pointer') and tc == 'an integer constant of 0 to 126': root_quiet = True
            root_quiet2 = root_quiet or (context == 'initializer' and dc == 'pointer' and tc.startswith('a constant of another kind'))
        after += not (reasons == 2 and root_quiet)
        after2 += not (reasons == 2 and root_quiet2)
    print("== %s: listed %d; with a root's rule %d; with a pointer's constant of another kind too %d" % (path.split('/')[-1], listed, after, after2))
    for key, n in table.most_common(16):
        print('   %6d (alone %6d, of them with a verdict %4d)  %s' % (n, alone[key], verdicts[(key, True)], ' | '.join(key)))
