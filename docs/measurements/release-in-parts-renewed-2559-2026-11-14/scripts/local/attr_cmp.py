# attr_cmp.py WHOLE.ll PART.ll...: functions the parts define whose inferred attributes differ from the whole unit's.
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
whole = read(sys.argv[1])
same = differ = 0
examples = []
for p in sys.argv[2:]:
    for n, a in read(p).items():
        if n not in whole:
            continue
        if a == whole[n]:
            same += 1
        else:
            differ += 1
            if len(examples) < 12:
                examples.append((n, sorted(whole[n]), sorted(a)))
print('same', same, 'differ', differ)
for e in examples:
    print(e)
