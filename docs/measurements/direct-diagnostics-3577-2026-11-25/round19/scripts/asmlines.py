import re, sys
# asmlines.py FILE.s SRC LO HI: the instructions whose line info (innermost) is in SRC:[LO, HI], in address order
path, src, lo, hi = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
cur = None; out = []
for line in open(path):
    m = re.match(r'; (\S+):(\d+)', line)
    if m:
        cur = (m.group(1).split('/')[-1], int(m.group(2))); continue
    m = re.match(r'\s+([0-9a-f]+):\s+(.*)', line)
    if m and cur and cur[0] == src and lo <= cur[1] <= hi:
        out.append((int(m.group(1), 16), cur[1], m.group(2).strip()))
out.sort()
prev = None
for a, ln, ins in out:
    gap = '' if prev is None or a - prev < 16 else '   ...'
    print('%x %5d %s%s' % (a, ln, ins, gap)); prev = a
print(len(out), 'instructions')
