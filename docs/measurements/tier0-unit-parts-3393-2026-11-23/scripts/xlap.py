# xlap.py MAPOUT FILE:START:END[:INDENT] ...: inserts BUSTER_XLAP(n); before each statement line at INDENT spaces (default 4)
# in [START, END] whose previous code line ends a statement. Writes "n file:line" to MAPOUT. Ranges per file in descending order applied safely.
import sys, re, collections
mapout = sys.argv[1]
specs = collections.defaultdict(list)
for a in sys.argv[2:]:
    p = a.split(':'); specs[p[0]].append((int(p[1]), int(p[2]), int(p[3]) if len(p) > 3 else 4))
import os; n = int(os.environ.get("XLAP_FIRST", "1"))
maps = []
for f, ranges in specs.items():
    lines = open(f).read().split('\n')
    ins = {}
    for start, end, indent in ranges:
        pre = ' ' * indent
        for i in range(start - 1, end):
            l = lines[i]
            if not l.startswith(pre) or l[indent:indent+1] in (' ', '}', '{', '/', '#', '') : continue
            if re.match(r'(else|case|default)\b', l[indent:]): continue
            j = i - 1
            while j >= 0 and (lines[j].strip() == '' or lines[j].strip().startswith('//')): j -= 1
            prev = lines[j].rstrip()
            if not (prev.endswith(';') or prev.endswith('}') or prev.endswith('{')): continue
            if prev.endswith('{') and not lines[j].startswith(' ' * (indent - 4) + '{') and lines[j].strip() != '{': continue
            ins[i] = n; maps.append('%d %s:%d %s' % (n, f.split('/')[-1], i + 1, l.strip()[:70])); n += 1
    out = []
    for i, l in enumerate(lines):
        if i in ins: out.append(' ' * (len(l) - len(l.lstrip())) + 'BUSTER_XLAP(%d);' % ins[i])
        out.append(l)
    open(f, 'w').write('\n'.join(out))
open(mapout, 'w').write('\n'.join(maps) + '\n')
print(n - 1, 'laps')
