import collections, sys
zero=set(open('run1/zero-sites.txt').read().split())
b=collections.Counter(); r=collections.Counter()
for l in open(sys.argv[1]):
    p=l.split()
    b[p[0]]+=int(p[1]); r[p[0]]+=int(p[4])
tot=sum(r.values())
z=sum(v for k,v in r.items() if k in zero); i=sum(v for k,v in r.items() if k.startswith('internal')); g=tot-z-i
print('resident by fresh pushes, MB: all %.1f; the 15 zero sites %.1f; lane.c internal %.1f; garbage-safe sites %.1f'%(tot/1e6,z/1e6,i/1e6,g/1e6))
print('--- zero sites')
for k in sorted(zero,key=lambda k:-r[k]): print('%8.2f MB resident %9.1f MB pushed  %s'%(r[k]/1e6,b[k]/1e6,k))
print('--- top garbage-safe sites by resident')
n=0
for k,v in r.most_common(60):
    if k not in zero and n < int(sys.argv[2]): print('%8.2f MB resident %9.1f MB pushed  %s'%(v/1e6,b[k]/1e6,k)); n+=1
