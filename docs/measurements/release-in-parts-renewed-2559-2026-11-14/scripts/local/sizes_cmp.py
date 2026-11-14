# sizes_cmp.py WHOLE.o PARTS_DIR: text symbols' total sizes (and counts) in the whole object and across the parts.
import subprocess,sys,collections,glob
def sizes(files):
    s=collections.Counter(); c=collections.Counter()
    for f in files:
        for line in subprocess.run(['nm','-S',f],capture_output=True,text=True).stdout.splitlines():
            p=line.split()
            if len(p)==4 and p[2] in 'tT':
                n=p[3].replace('.buster_split','')
                s[n]+=int(p[1],16); c[n]+=1
    return s,c
w,wc=sizes([sys.argv[1]])
p,pc=sizes(sorted(glob.glob(sys.argv[2]+'/part*.o')))
names=set(w)|set(p)
rows=[(n,w.get(n,0),p.get(n,0),pc.get(n,0)) for n in names if w.get(n,0)!=p.get(n,0)]
tests=lambda n: 'test' in n
print('total whole',sum(w.values()),'parts',sum(p.values()))
filt=[r for r in rows if not tests(r[0])]
print('only in parts (outlined):')
for r in sorted([r for r in filt if r[1]==0],key=lambda r:-r[2])[:25]: print('  %-50s %7d x%d'%(r[0],r[2],r[3]))
print('only in whole:')
for r in sorted([r for r in filt if r[2]==0],key=lambda r:-r[1])[:15]: print('  %-50s %7d'%(r[0],r[1]))
print('size changes:')
for r in sorted([r for r in filt if r[1] and r[2]],key=lambda r:-abs(r[2]-r[1]))[:30]: print('  %-50s %7d -> %7d x%d'%r)
