import re, sys, collections
# Reads objdump -d output; prints, per function, a normalized instruction list (addresses and immediates that look
# like code/data addresses replaced), so two builds' functions compare apart from layout.
funcs = collections.OrderedDict()
cur = None
head = re.compile(r'^[0-9a-f]+ <(.+)>:$')
for line in open(sys.argv[1], errors='replace'):
    line = line.rstrip('\n')
    m = head.match(line)
    if m:
        cur = m.group(1); funcs[cur] = []; continue
    if cur is None or not line.startswith(' '):
        continue
    parts = line.split('\t')
    if len(parts) < 2:
        continue
    ins = '\t'.join(parts[1:]).strip()
    ins = re.sub(r'\b[0-9a-f]{5,}\b', 'ADDR', ins)          # absolute targets
    ins = re.sub(r'<([^>+]+)\+0x[0-9a-f]+>', r'<\1+OFF>', ins)  # symbol offsets
    ins = re.sub(r'0x[0-9a-f]{5,}', 'ADDR', ins)             # rip-relative data
    funcs[cur].append(ins)
import json
json.dump(funcs, open(sys.argv[2], 'w'))
