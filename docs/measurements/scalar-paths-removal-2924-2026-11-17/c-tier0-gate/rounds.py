# #2924 C8 gate: each small bin round by round, scalar ticks over vector ticks. Run in this directory.
import statistics
d='ticks'; rounds=5
def raw(mask, area):
    return [[tuple(map(int,l.split())) for l in open(f'{d}/{mask}-{r}.txt') if l.strip() and l.split()[0]==str(area)] for r in range(1,rounds+1)]
for area,name,bins in ((0,'compile',((0,2),(2,4))),(1,'validate',((0,4),(4,16))),(2,'inline',((0,4),(4,8),(8,16))),(3,'unwind',((0,4),(4,8),(8,16)))):
    v=raw('0',area); s=raw('0xf',area)
    for lo,hi in bins:
        sel=[i for i in range(len(v[0])) if lo<=v[0][i][1]<hi]
        rs=[sum(s[r][i][2] for i in sel)/max(1,sum(v[r][i][2] for i in sel)) for r in range(rounds)]
        print(f'{name} {lo}-{hi}: {len(sel)} calls, rounds s/v ' + ' '.join(f'{x:.3f}' for x in rs))
