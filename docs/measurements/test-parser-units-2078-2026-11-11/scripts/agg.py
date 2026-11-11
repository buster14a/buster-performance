import sys, collections
target=sys.argv[2]; depth=int(sys.argv[3]) if len(sys.argv)>3 else 1
stacks=[];cur=[]
for line in open(sys.argv[1]):
    line=line.rstrip()
    if not line:
        if cur: stacks.append(cur); cur=[]
        continue
    if line.startswith('\t') or line.startswith(' '):
        parts=line.split(None,1)
        cur.append(parts[1] if len(parts)>1 else '?')
    else:
        if cur: stacks.append(cur)
        cur=[]
if cur: stacks.append(cur)
total=len(stacks); c=collections.Counter(); n=0
for s in stacks:
    syms=[x.split('+')[0].replace(' (inlined)','') for x in s]
    if target in syms:
        n+=1
        i=syms.index(target)
        path=tuple(syms[max(0,i-depth):i][::-1]) if i>0 else ('<self>',)
        c[path]+=1
print(f"{target}: {n}/{total} samples = {100*n/total:.1f}%")
for k,v in c.most_common(40): print(f"{100*v/total:6.2f}%  {' > '.join(k)}")
