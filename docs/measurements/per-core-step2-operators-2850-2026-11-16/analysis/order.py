# order.py DIR DUMP: a search, by swaps of two codes, for the order of the codes that gives DUMP's windows the fewest
# classes (DIR has schemes.py).
import sys, collections
sys.path.insert(0, sys.argv[1])
from schemes import load, made, operands
W=load(sys.argv[2])
# precompute per window: list of (code, [operand local indices among made], ...)
wins=[]
for win in W:
    idx={}; recs=[]
    for i,rec in enumerate(win):
        if not made(rec): continue
        ops=[idx[o] for o in operands(i,rec) if o in idx]
        idx[i]=len(recs); recs.append((rec[1],ops))
    wins.append(recs)
def cost(order, cap=None):
    pos={c:i for i,c in enumerate(order)}
    classes=0; rounds=0; deep=0
    for recs in wins:
        slot=[]; seen=set(); mr=0
        for code,ops in recs:
            p=pos[code]; r=0
            for o in ops:
                ro,po=slot[o]
                r=max(r, ro if po<=p else ro+1)
            if cap is not None and r>=cap: r=cap; deep+=1
            slot.append((r,p)); seen.add((r,p)); mr=max(mr,r)
        classes+=len(seen); rounds+=mr+1 if recs else 0
    return classes, rounds, deep
NAMES=['arrow','dot','deref','subscript','call','discard','row','store','convert','truth','address','cast','logic','update','other']
order=[0,1,2,3,10,11,6,4,12,9,13,7,8,5,14]
best=cost(order); print('start',best,[NAMES[c] for c in order])
improved=True
while improved:
    improved=False
    for i in range(len(order)):
        for j in range(i+1,len(order)):
            o=order[:]; o[i],o[j]=o[j],o[i]
            c=cost(o)
            if c[0]<best[0]:
                best=c; order=o; improved=True
    print('sweep',best,[NAMES[c] for c in order]); sys.stdout.flush()
print('final',best,[NAMES[c] for c in order], 'cap4', cost(order,4))
