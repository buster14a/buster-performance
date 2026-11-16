# roots.py DIR DUMP...: the classes a pass needs where some codes' operators that are their expressions' last records
# are made after every round (they were not kept: the classes are no fewer).
import sys, collections
sys.path.insert(0, sys.argv[1])
from schemes import load, made, operands
NAMES=['arrow','dot','deref','subscript','call','discard','row','store','convert','truth','address','cast','logic','update','other']
order=[0,3,1,10,11,14,6,4,12,13,2,7,8,5,9]   # arrow, subscript, dot, address, cast, other, row, call, logic, update, deref, store, convert, discard, truth
pos={c:i for i,c in enumerate(order)}
def run(W, rootcodes):
    classes=0; rounds=0; sizes=collections.Counter(); percode=collections.Counter(); perrec=collections.Counter()
    for win in W:
        slot={}; seen=collections.Counter(); mr=-1
        for i,rec in enumerate(win):
            if not made(rec): continue
            code=rec[1]; p=pos[code]; r=0
            for o in operands(i,rec):
                if o not in slot: continue
                ro,po=slot[o]
                r=max(r, ro if po<=p else ro+1)
            if rec[6] and code in rootcodes:
                slot[i]=(98,p)   # nothing reads a root
            else:
                slot[i]=(r,p); mr=max(mr,r)
            seen[slot[i]]+=1
        classes+=len(seen); rounds+=mr+1
        for (r,p),n in seen.items():
            percode[order[p]]+=1; perrec[order[p]]+=n
    return classes, rounds, percode, perrec
for path in sys.argv[2:]:
    W=load(path)
    for name,rc in (('none',set()),('discard',{5}),('discard,truth',{5,9}),('discard,truth,store,convert',{5,9,7,8}),('discard,truth,store,convert,update',{5,9,7,8,13}),('all',set(range(15)))):
        c,r,pc,pr=run(W,rc)
        print(path.split('/')[-1], 'roots:',name,'classes',c,'rounds',r)
        if name in ('none','discard,truth,store,convert,update'):
            print('   per code classes/records:', ' '.join('%s %d/%d(%.1f)'%(NAMES[k],pc[k],pr[k],pr[k]/max(pc[k],1)) for k in order))
