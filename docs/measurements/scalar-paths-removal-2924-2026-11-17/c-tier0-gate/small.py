# #2924 C8 gate: validate and compile by finer entry bins (each call the median of 5 rounds). Run in this directory.
import sys, os, statistics
d='ticks'; rounds=5
def load(mask, area):
    per=[]
    for r in range(1, rounds+1):
        per.append([tuple(map(int,l.split())) for l in open(f'{d}/{mask}-{r}.txt') if l.strip() and l.split()[0]==str(area)])
    return [(per[0][i][1], statistics.median(p[i][2] for p in per)) for i in range(len(per[0]))]
for area,name in ((1,'validate'),(0,'compile')):
    v=load('0',area); s=load('0xf',area)
    for lo,hi in ((0,2),(2,4),(4,8),(8,12),(12,16),(16,24),(24,32)):
        sel=[i for i in range(len(v)) if lo<=v[i][0]<hi]
        bv=sum(v[i][1] for i in sel); bs=sum(s[i][1] for i in sel)
        print(f'{name} {lo:3d}-{hi:3d}: {len(sel):5d} calls  vector {bv/len(sel) if sel else 0:7.0f}/call  scalar {bs/len(sel) if sel else 0:7.0f}/call  s/v {bs/bv if bv else 0:.3f}')
