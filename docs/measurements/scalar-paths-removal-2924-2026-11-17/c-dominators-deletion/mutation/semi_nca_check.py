# Checks semi_nca_search.py's transcription against the dominance definition (deleted-node reachability) on 20,000
# random graphs, then prints the graph it found, before its renumbering to DFS order for the test fixture.
import random, sys
import os
src=open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'semi_nca_search.py')).read().split('best=None')[0]
exec(src)
def defi(n, succ, entry):
    def reach(omit):
        seen=set()
        if entry==omit: return seen
        st=[entry]; seen.add(entry)
        while st:
            v=st.pop()
            for w in succ[v]:
                if w!=omit and w not in seen: seen.add(w); st.append(w)
        return seen
    R=reach(None)
    doms={b:{d for d in R if (d==b) or b not in reach(d)} for b in R}
    idom=[None]*n
    for b in R:
        strict=doms[b]-{b}
        idom[b]=entry if b==entry else max(strict, key=lambda d: len(doms[d]))
    return idom
rng=random.Random(7); bad=0
for t in range(20000):
    n=rng.randint(1,10); m=rng.randint(0,3*n)
    edges=[(rng.randrange(n), rng.randrange(n)) for _ in range(m)]
    succ=[[] for _ in range(n)]; pred=[[] for _ in range(n)]
    for a,b in edges: succ[a].append(b); pred[b].append(a)
    if idoms(n,succ,pred,0,False)!=defi(n,succ,0): bad+=1
print("transcription vs definition mismatches:", bad)
edges=[(0, 2), (4, 2), (1, 5), (2, 1), (4, 3), (3, 5), (0, 4), (3, 1)]
n=6; succ=[[] for _ in range(n)]; pred=[[] for _ in range(n)]
for a,b in edges: succ[a].append(b); pred[b].append(a)
print("definition", defi(n,succ,0), "correct", idoms(n,succ,pred,0,False), "s4", idoms(n,succ,pred,0,True))
print("dfs order", order(n,succ,0))
