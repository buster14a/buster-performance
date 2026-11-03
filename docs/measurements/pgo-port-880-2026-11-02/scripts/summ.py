import collections,sys
d=collections.defaultdict(list)
for l in open(sys.argv[1]):
    p=l.split()
    if len(p)==5 and p[4].isdigit(): d[(p[0],p[1],p[3])].append(int(p[4]))
vs=[]
for (v,m,e) in d:
    if v not in vs: vs.append(v)
for m in ('syntax','sqlite-c','musl-c'):
    for e in ('instructions:u','cycles:u','ex_ret_near_ret:u','ex_ret_brn_tkn:u'):
        if ('base',m,e) not in d: continue
        b=min(d[('base',m,e)])
        print(f'{m:9s} {e:18s} base {b:14,d}  '+'  '.join(f'{v} {(min(d[(v,m,e)])/b-1)*100:+6.2f}%' for v in vs if v!='base'))
