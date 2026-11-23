import bisect, sys, collections, re
syms = []
for line in open('syms.txt'):
    p = line.split()
    if len(p) >= 3: syms.append((int(p[0], 16), p[2]))
syms.sort()
addrs = [a for a, _ in syms]
def stage(n):
    for pre, s in (('pp_root', 'pp-root'), ('pp_', 'pp'), ('file_cache', 'pp'), ('files_', 'pp'), ('tokenize', 'pp'), ('refine', 'pp'), ('intern', 'intern'), ('parse_', 'parse'), ('check_attested', 'attested'),
                   ('check_input', 'check-input'), ('type_', 'types'), ('check_program', 'check-program'), ('check_lower', 'lower'), ('check_units', 'units'), ('check_driver', 'driver'),
                   ('check_', 'check-other'), ('tier0', 'tier0'), ('x86', 'encode'), ('object', 'object'), ('link', 'link'), ('arena', 'arena'), ('__mem', 'mem*'), ('madvise', 'madvise'),
                   ('ioctl', 'ioctl'), ('open64', 'files'), ('close', 'files'), ('pwrite', 'files'), ('pread', 'files'), ('fstat', 'files'), ('diagnostic', 'diag')):
        if n.startswith(pre): return s
    return 'other'
def load(prefix):
    c = collections.Counter(); sc = collections.Counter(); n = 0
    for i in (1, 2, 3):
        for line in open(f'{prefix}.{i}.txt'):
            rip = int(line, 16)
            if rip >= 0x10000000: continue
            j = bisect.bisect_right(addrs, rip) - 1
            name = re.sub(r'\.(buster_split|cold|part|isra|constprop).*', '', syms[j][1])
            c[stage(name)] += 1; sc[name] += 1; n += 1
    return c, sc, n
names = sys.argv[1:]
data = {k: load(k) for k in names}
allst = sorted({s for k in names for s in data[k][0]}, key=lambda s: -data[names[0]][0][s])
print('stage'.ljust(16) + ''.join(k.rjust(10) for k in names))
for s in allst:
    print(s.ljust(16) + ''.join(str(data[k][0][s]).rjust(10) for k in names))
print('total'.ljust(16) + ''.join(str(data[k][2]).rjust(10) for k in names))
if len(names) >= 2:
    a, b = names[0], names[-1]
    diff = collections.Counter({n: data[a][1][n] - data[b][1][n] for n in set(data[a][1]) | set(data[b][1])})
    print(f'--- top symbols by {a} - {b}')
    for n, d in diff.most_common(45): print(f'{d:7d}  {data[a][1][n]:6d} {data[b][1][n]:6d}  {n}')
