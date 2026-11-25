import sys,subprocess,collections
name=sys.argv[1]; top=int(sys.argv[2]) if len(sys.argv)>2 else 80
rows=[l.split() for l in open(f'/home/user/dp/{name}-lbr.txt')]
tot_t=sum(int(r[1]) for r in rows); tot_m=sum(int(r[2]) for r in rows)
addrs=[r[0] for r in rows[:600]]
out=subprocess.run(['llvm-symbolizer',f'--obj=/home/user/dp/bin/direct-{name}','--inlines'],input='\n'.join(addrs)+'\n',capture_output=True,text=True).stdout
blocks=[b.strip().split('\n') for b in out.split('\n\n') if b.strip()]
print('taken records',tot_t,'mispredicted',tot_m,'distinct',len(rows))
cum=0; byfn=collections.Counter()
for r,b in zip(rows[:600],blocks):
    desc=' <- '.join(f"{b[i]}@{b[i+1].split('/')[-1].rsplit(':',1)[0]}" for i in range(0,min(len(b),4),2))
    cum+=int(r[2]); byfn[b[-2] if len(b)>=2 else '?']+=int(r[2])
    if rows.index(r)<top: print(f"{int(r[2]):5d}/{int(r[1]):5d}  cum {100*cum/tot_m:4.1f}%  {r[0]} {desc[:120]}")
print('by outer function (top 600 branches):')
for f,v in byfn.most_common(25): print(f"  {100*v/tot_m:5.1f}%  {f}")
