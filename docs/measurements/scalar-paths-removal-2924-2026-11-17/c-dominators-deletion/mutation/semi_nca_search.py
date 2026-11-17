# Transcription of dominators.c's dominators_order + dominators_semi_nca, with and without s4 (compression keeps each
# link's own least). Search small random CFGs for one where the immediate dominators differ.
import random, sys
def order(n, succ, entry):
    begin=[None]*n; vertices=[entry]; parents=[0]; begin[entry]=0
    stack=[[entry,0]]
    while stack:
        f=stack[-1]
        if f[1] < len(succ[f[0]]):
            t=succ[f[0]][f[1]]; f[1]+=1
            if begin[t] is None:
                begin[t]=len(vertices); parents.append(begin[f[0]]); vertices.append(t); stack.append([t,0])
        else:
            stack.pop()
    return begin, vertices, parents
def idoms(n, succ, pred, entry, mutant):
    begin, vertices, parents = order(n, succ, entry)
    parents=list(parents); r=len(vertices)
    anc=[parents[i] for i in range(r)]; least=list(range(r)); semi=[0]*r
    def evaluate(number, processed):
        result=least[number]
        if anc[number] >= processed:
            stack=[]; top=number
            while True:
                stack.append(top); top=anc[top]
                if not (anc[top] >= processed): break
            root=anc[top]; l=least[top]
            while stack:
                v=stack.pop(); anc[v]=root
                l=min(least[v], l)
                if not mutant: least[v]=l
            result=l
        return result
    for number in range(r-1, 0, -1):
        b=vertices[number]; l=parents[number]
        for p in pred[b]:
            s=begin[p]
            if s is not None:
                c = s if s <= number else evaluate(s, number+1)
                l=min(c,l)
        semi[number]=l; least[number]=l
    idom=[None]*n; idom[entry]=entry
    for number in range(1, r):
        c=parents[number]
        while c > semi[number]: c=parents[c]
        parents[number]=c; idom[vertices[number]]=vertices[c]
    return idom
best=None
rng=random.Random(1)
for trial in range(400000):
    n=rng.randint(3,9); m=rng.randint(n-1, 2*n+2)
    edges=[(rng.randrange(n), rng.randrange(n)) for _ in range(m)]
    succ=[[] for _ in range(n)]; pred=[[] for _ in range(n)]
    for a,b in edges: succ[a].append(b); pred[b].append(a)
    if idoms(n,succ,pred,0,False)!=idoms(n,succ,pred,0,True):
        if best is None or (n, len(edges)) < (best[0], len(best[1])):
            best=(n, edges, idoms(n,succ,pred,0,False), idoms(n,succ,pred,0,True))
print(best)
