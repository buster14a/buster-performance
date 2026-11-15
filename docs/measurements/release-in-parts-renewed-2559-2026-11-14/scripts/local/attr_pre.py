# attr_pre.py WHOLE_O3.ll PRE.ll: for the functions the whole unit defines, how its final attributes compare with the
# ones inferred before the split (PRE): equal, PRE weaker (a subset), PRE different otherwise.
import re, sys
keep = re.compile(r'memory\([^)]*\)|\bnofree\b|\bnosync\b|\bwillreturn\b|\bnorecurse\b')
head = re.compile(r'^define (?!available_externally).*?@"?([A-Za-z0-9_.$]+)"?\(.*\)\s*(.*?)#(\d+)')
def read(path):
    groups, fns = {}, {}
    for line in open(path):
        if line.startswith('attributes #'):
            m = re.match(r'attributes #(\d+) = \{(.*)\}', line)
            groups[m.group(1)] = frozenset(keep.findall(m.group(2)))
        elif line.startswith('define '):
            m = head.match(line)
            if m:
                fns[m.group(1).replace('.buster_split', '')] = m.group(3)
    return {n: groups.get(g, frozenset()) for n, g in fns.items()}
w = read(sys.argv[1]); p = read(sys.argv[2])
eq = weaker = other = 0; ex = []
for n, a in w.items():
    if n not in p: continue
    b = p[n]
    if a == b: eq += 1
    elif b < a: weaker += 1
    else:
        other += 1
        if len(ex) < 6: ex.append((n, sorted(a), sorted(b)))
print('equal', eq, 'weaker', weaker, 'other', other)
for e in ex: print(e)
