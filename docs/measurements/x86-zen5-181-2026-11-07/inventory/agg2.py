import sys, collections, glob, os
S=os.path.dirname(os.path.abspath(__file__))
names=[l.split()[1] for l in open(S+'/names.txt')]
def kind(name, mode, reg, rm, index, vvvv, disp):
    if mode==0: return 'REGISTER'
    if name.startswith('LEA'): return 'LEA?'
    if mode & 16: return 'MEMORY_INDEX' if mode & 8 else 'NOBASE'
    return 'MEMORY'
for f in sorted(glob.glob(S+'/out2/*.txt')):
    c=collections.Counter()
    for line in open(f):
        p=list(map(int,line.split()))
        form=(p[0]&0x7fff)%len(names)
        c[(names[form],kind(names[form],p[1],p[2],p[3],p[4],p[5],p[6]))]+=1
    print(os.path.basename(f), len(c))
    for (n,k),v in sorted(c.items(), key=lambda x:-x[1]): print('   ',n,k,v)
