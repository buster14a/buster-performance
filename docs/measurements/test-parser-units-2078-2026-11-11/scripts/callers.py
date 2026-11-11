import sys, collections
target=sys.argv[2]; depth=int(sys.argv[3])
stacks=[];cur=[]
for line in open(sys.argv[1]):
    line=line.rstrip()
    if not line:
        if cur: stacks.append(cur); cur=[]
        continue
    if line[0] in ' \t':
        parts=line.split(None,1); cur.append(parts[1] if len(parts)>1 else '?')
    else:
        if cur: stacks.append(cur)
        cur=[]
if cur: stacks.append(cur)
total=len(stacks); c=collections.Counter()
for s in stacks:
    syms=[x.split('+')[0].replace(' (inlined)','') for x in s]
    if target in syms:
        i=syms.index(target); c[tuple(syms[i+1:i+1+depth])]+=1
for k,v in c.most_common(15): print(f"{100*v/total:6.2f}%  {' < '.join(k)}")
