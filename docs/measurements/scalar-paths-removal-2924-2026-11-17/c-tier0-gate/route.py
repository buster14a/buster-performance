# #2972: validation calls of 1 to 16 entries by route (ticks-route/0-1.txt from route.sh). Run in this directory.
import statistics, collections
rows=[l.split() for l in open('ticks-route/0-1.txt') if l.startswith('1 ')]
rows=[tuple(map(int,r)) for r in rows]
print('validation calls', len(rows))
small=[r for r in rows if 1<=r[1]<=16]
on=[r for r in small if r[6]==1]; off=[r for r in small if r[6]==0]
print(f'1..16 entries: {len(small)} calls, {len(on)} on the small route, {len(off)} off it')
why=collections.Counter()
for r in off:
    why[('locals' if r[3]>16 else '')+('+calls' if r[4]>16 else '')+('+arguments' if r[5]>16 else '')]+=1
print('off the route because:', dict(why))
if on: print(f'  on: median ticks {statistics.median(r[2] for r in on):.0f}')
if off: print(f'  off: median ticks {statistics.median(r[2] for r in off):.0f}; locals median {statistics.median(r[3] for r in off):.0f} max {max(r[3] for r in off)}; arguments median {statistics.median(r[5] for r in off):.0f}')
for s in (1,2,4,8,12,16):
    a=[r for r in small if r[1]==s]
    print(f'  entries {s:2d}: {len(a)} calls, off {sum(1 for r in a if r[6]==0)}')
