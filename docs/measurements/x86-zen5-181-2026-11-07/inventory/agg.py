import sys, collections, glob, os
S=os.path.dirname(os.path.abspath(__file__))
names={}
for line in open(S+'/names.txt'):
    i,n=line.split(); names[int(i)]=n
def kind(form,mode,reg,rm,index,disp):
    n=names[form]
    if mode==0:
        if reg==rm and any(n.startswith(p) for p in ('XOR_','SUB_','PXOR','XORPS','XORPD','VPXOR','VXORP','SBB_')) : return 'zero?'
        return 'reg'
    if n.startswith('LEA'):
        b=bool(mode&8); i=bool(mode&16); sc=mode&3; rip=bool(mode&32)
        if rip: return 'lea-rip'
        parts=[]
        if b: parts.append('b')
        if i: parts.append('i' if sc==0 else 'i*%d'%(1<<sc))
        if disp!=0 or (b and rm in (5,13) and not i): parts.append('d')
        return 'lea-'+'+'.join(parts)
    if mode&32: return 'mem-rip'
    if mode&16: return 'mem-index'
    return 'mem'
by={}
for f in sorted(glob.glob(S+'/out/*.txt')):
    src=os.path.basename(f)[:-4]
    c=collections.Counter()
    for line in open(f):
        p=line.split()
        form,mode,reg,rm,index=map(int,p[1:6]); disp=int(p[9]); form=form&0x7fff; seg=form//8354; form=form%8354
        c[(form,kind(form,mode,reg,rm,index,disp))]+=1
    by[src]=c
allc=collections.Counter()
for c in by.values(): allc.update(c)
forms=set(k[0] for k in allc)
print('distinct (form,kind):',len(allc),' distinct forms:',len(forms))
for src,c in by.items():
    print(src, 'cases',len(c),'forms',len(set(k[0] for k in c)))
corp=collections.Counter()
for s in ('tier0-sqlite','tier0-lua','tier1-sqlite','tier1-lua'): corp.update(by[s])
print('corpora cases',len(corp),'forms',len(set(k[0] for k in corp)))
with open(S+'/cases.tsv','w') as o:
    for (form,k),n in sorted(allc.items(), key=lambda x:-x[1]):
        srcs=','.join(s for s,c in by.items() if (form,k) in c)
        o.write('%s\t%s\t%d\t%s\n'%(names[form],k,n,srcs))
