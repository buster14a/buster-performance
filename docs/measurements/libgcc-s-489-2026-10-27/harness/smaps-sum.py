import sys
def parse(p):
    out=[]; cur=None
    for line in open(p):
        parts=line.split()
        if '-' in parts[0] and not parts[0].endswith(':'):
            cur={'hdr':line.strip(),'f':{}}; out.append(cur)
        else:
            k=parts[0].rstrip(':')
            if len(parts)>1 and parts[1].isdigit(): cur['f'][k]=int(parts[1])
    return out
for p in sys.argv[1:]:
    m=parse(p); print(p, 'Rss', sum(x['f'].get('Rss',0) for x in m), 'Anon', sum(x['f'].get('Anonymous',0) for x in m), 'AnonHuge', sum(x['f'].get('AnonHugePages',0) for x in m), 'FilePmd', sum(x['f'].get('FilePmdMapped',0) for x in m))
    for x in m:
        if x['f'].get('Rss',0)>=256: print('  ', x['f'].get('Rss'), 'huge', x['f'].get('AnonHugePages',0), x['f'].get('FilePmdMapped',0), x['hdr'][:110])
