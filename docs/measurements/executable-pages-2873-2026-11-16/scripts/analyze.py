import sys, collections, bisect
# symbols
funcs = {}  # address -> (size, name)
for line in open('symbols.txt', errors='replace'):
    p = line.split()
    if len(p) >= 8 and p[0].endswith(':') and p[3] == 'FUNC' and p[6] != 'UND':
        try:
            a = int(p[1], 16); s = int(p[2], 0)
        except ValueError:
            continue
        if s == 0: continue
        if a not in funcs or funcs[a][0] < s:
            funcs[a] = (s, p[7])
START = (0xd527d0, 0xd527d0 + 788*1024 + 400)
CHECK = (0xe18000, 0xe18000 + 0x5a2b35)
TEXT = (0x13bab40, 0x13bab40 + 0x1e3ad9f)
def region(a):
    if a < CHECK[0]: return 'start'
    if a < TEXT[0]: return 'checker'
    return 'text'
def read(path):
    traces = []
    for line in open(path):
        line = line.strip()
        if line == 'trace': traces.append([])
        elif line: traces[-1].append(int(line, 16))
    return traces
def describe(name, addrs):
    by = collections.Counter(); bytes_by = collections.Counter(); wins = set(); pages = set()
    for a in addrs:
        s = funcs[a][0]
        by[region(a)] += 1; bytes_by[region(a)] += s
        for w in range(a >> 16, ((a + s - 1) >> 16) + 1): wins.add(w)
    total = sum(bytes_by.values())
    print(f"{name}: {len(addrs)} functions, {total/1024:.0f} KB (start {by['start']}/{bytes_by['start']/1024:.0f} KB, checker {by['checker']}/{bytes_by['checker']/1024:.0f} KB, text {by['text']}/{bytes_by['text']/1024:.0f} KB); 64K windows their bytes span now {len(wins)}; packed {total/65536:.1f}")
small = {}
for n in ['syntax', 'preprocess', 'tiny', 'hello', 'sqlite']:
    t = read(n + '.txt'); small[n] = t[0]
    describe(n, t[0])
musl = read('musl.txt')
count = collections.Counter()
for t in musl:
    for a in t: count[a] += 1
union = list(count)
describe('musl union', union)
sizes = sorted(len(t) for t in musl)
print('musl per unit functions: min %d median %d max %d' % (sizes[0], sizes[len(sizes)//2], sizes[-1]))
bytes_per = sorted(sum(funcs[a][0] for a in t) for t in musl)
print('musl per unit bytes KB: min %d median %d max %d' % (bytes_per[0]/1024, bytes_per[len(bytes_per)//2]/1024, bytes_per[-1]/1024))
# frequency histogram
n = len(musl)
for lo, hi in [(n, n), (int(0.9*n), n-1), (int(0.5*n), int(0.9*n)-1), (int(0.1*n), int(0.5*n)-1), (10, int(0.1*n)-1), (2, 9), (1, 1)]:
    fs = [a for a in union if lo <= count[a] <= hi]
    print(f"  ran by {lo}..{hi} units: {len(fs)} functions, {sum(funcs[a][0] for a in fs)/1024:.0f} KB")
allf = set(union) | set(small['sqlite']) | set(small['hello']) | set(small['tiny']) | set(small['syntax']) | set(small['preprocess'])
describe('all commands union', list(allf))
print('sqlite not in musl union:', len(set(small['sqlite']) - set(union)), 'functions', sum(funcs[a][0] for a in set(small['sqlite']) - set(union))/1024, 'KB')
print('musl union not in sqlite:', len(set(union) - set(small['sqlite'])), 'functions', sum(funcs[a][0] for a in set(union) - set(small['sqlite']))/1024, 'KB')
# biggest functions in the sqlite set
big = sorted(((funcs[a][0], funcs[a][1], region(a)) for a in small['sqlite']), reverse=True)[:25]
for s, nm, r in big: print(f"   {s/1024:8.1f} KB {r:8s} {nm}")
# cumulative size distribution of sqlite's functions
tot = sum(funcs[a][0] for a in small['sqlite'])
acc = 0
for i, (s, nm, r) in enumerate(sorted(((funcs[a][0], funcs[a][1], region(a)) for a in small['sqlite']), reverse=True)):
    acc += s
    if i + 1 in (10, 25, 50, 100, 200, 400): print(f"   top {i+1}: {acc/1024:.0f} KB of {tot/1024:.0f}")
