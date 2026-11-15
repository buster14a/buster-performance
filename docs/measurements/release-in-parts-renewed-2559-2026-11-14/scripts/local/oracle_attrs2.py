# oracle_attrs.py WHOLE_O3.ll PART_RAW.ll OUT.ll: the whole unit's inferred function attributes (memory, nofree,
# nosync, willreturn, norecurse, mustprogress) on the part's declarations and available_externally bodies.
import re, sys
whole, part, out = sys.argv[1:4]
keep = re.compile(r"memory\([^)]*\)|\bnofree\b|\bnosync\b|\bwillreturn\b|\bnorecurse\b|\bmustprogress\b|\bnoreturn\b|\bcold\b|\bnounwind\b")
groups = {}
fn_group = {}
head = re.compile(r'^(define|declare) .*?@"?([A-Za-z0-9_.$]+)"?\(.*\)\s*(.*?)#(\d+)')
for line in open(whole):
    if line.startswith('attributes #'):
        m = re.match(r'attributes #(\d+) = \{(.*)\}', line)
        groups[m.group(1)] = ' '.join(keep.findall(m.group(2)))
    elif line.startswith('define '):
        m = head.match(line)
        if m:
            fn_group[m.group(2).replace('.buster_split', '')] = m.group(4)
lines = open(part).read().split('\n')
part_groups = {}
for l in lines:
    if l.startswith('attributes #'):
        m = re.match(r'attributes #(\d+) = \{(.*)\}', l)
        part_groups[m.group(1)] = m.group(2)
new_groups = {}
next_id = max(int(k) for k in part_groups) + 1
changed = 0
res = []
for l in lines:
    if l.startswith('declare ') or l.startswith('define available_externally '):
        m = head.match(l)
        if m:
            name = m.group(2).replace('.buster_split', '')
            extra = groups.get(fn_group.get(name, ''), '')
            if extra:
                base = part_groups[m.group(4)]
                base = keep.sub('', base)
                key = (m.group(4), extra)
                if key not in new_groups:
                    new_groups[key] = next_id; next_id += 1
                    part_groups[str(new_groups[key])] = extra + ' ' + base
                start, end = m.span(4)
                l = l[:start] + str(new_groups[key]) + l[end:]
                changed += 1
    res.append(l)
text = '\n'.join(res)
text += '\n' + '\n'.join('attributes #%d = { %s }' % (v, part_groups[str(v)]) for v in new_groups.values()) + '\n'
open(out, 'w').write(text)
print('changed', changed, 'new groups', len(new_groups))
