#!/usr/bin/env python3
# #442: samples (hex RIPs) to functions by nm's symbol table; prints the top functions' shares.
import sys, subprocess, bisect, collections
exe, samples = sys.argv[1], sys.argv[2]; top = int(sys.argv[3]) if len(sys.argv) > 3 else 40
syms = []
for line in subprocess.run(['nm', '-C', exe], capture_output=True, text=True).stdout.splitlines():
    p = line.split(maxsplit=2)
    if len(p) == 3 and p[1] in 'tTwW': syms.append((int(p[0], 16), p[2]))
syms.sort(); addrs = [a for a, _ in syms]
c = collections.Counter(); callers = collections.Counter()
maps = []
for line in open(samples + '.maps'):
    f = line.split()
    lo, hi = (int(x, 16) for x in f[0].split('-'))
    maps.append((lo, hi, int(f[2], 16), f[5] if len(f) > 5 else '[anon]'))
dyn = {}
def dsyms(path):
    if path not in dyn:
        out = subprocess.run(['nm', '-D', '--defined-only', path], capture_output=True, text=True).stdout.splitlines()
        v = sorted((int(l.split()[0], 16), l.split()[2]) for l in out if len(l.split()) == 3)
        dyn[path] = v
    return dyn[path]
def lib(a):
    for lo, hi, off, path in maps:
        if lo <= a < hi:
            if path.startswith('/'):
                # file offset of the address; nm -D gives vaddrs which equal file offsets for libc's text closely enough
                fo = a - lo + off
                v = dsyms(path); k = bisect.bisect_right([x for x, _ in v], fo) - 1
                return f'{path.rsplit("/",1)[-1]}:{v[k][1] if k >= 0 else "?"}'
            return path
    return 'kernel/?'
n = 0
for line in open(samples):
    a, ca = (int(x, 16) for x in line.split()); k = bisect.bisect_right(addrs, a) - 1
    if a < 0x10000000 and k >= 0: c[syms[k][1]] += 1
    else:
        name = lib(a); c[name] += 1
        kc = bisect.bisect_right(addrs, ca) - 1
        if ca < 0x10000000 and kc >= 0: callers[name + ' <- ' + syms[kc][1]] += 1
    n += 1
for name, k in c.most_common(top): print(f'{100*k/n:6.2f}% {k:7d} {name}')
print('samples', n)
print('-- libc callers (from [rsp], leaf-accurate only)')
for name, k in callers.most_common(top): print(f'{100*k/n:6.2f}% {k:7d} {name}')
