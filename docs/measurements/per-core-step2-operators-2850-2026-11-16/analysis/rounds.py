# rounds.py DIR DUMP...: the operators by round under the chosen order of the codes, and the windows by their rounds.
import sys, collections
sys.path.insert(0, sys.argv[1])
from schemes import load, made, operands
order=[0,3,1,10,11,14,6,4,12,13,2,7,8,5,9]
pos={c:i for i,c in enumerate(order)}
for path in sys.argv[2:]:
    W=load(path)
    byround=collections.Counter(); wins=collections.Counter()
    for win in W:
        slot={}; mr=-1
        for i,rec in enumerate(win):
            if not made(rec): continue
            p=pos[rec[1]]; r=0
            for o in operands(i,rec):
                if o not in slot: continue
                ro,po=slot[o]
                r=max(r, ro if po<=p else ro+1)
            slot[i]=(r,p); byround[r]+=1; mr=max(mr,r)
        wins[mr+1]+=1
    tot=sum(byround.values())
    print(path.split('/')[-1], 'records by round', dict(sorted(byround.items())), 'share past 2 rounds %.2f%%' % (100*sum(v for k,v in byround.items() if k>=2)/tot), 'past 3 %.2f%%' % (100*sum(v for k,v in byround.items() if k>=3)/tot), 'windows by rounds', dict(sorted(wins.items())))
