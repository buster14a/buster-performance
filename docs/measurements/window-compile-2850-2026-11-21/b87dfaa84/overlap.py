from pathlib import Path
import bisect,csv,collections
p=Path(__file__).resolve().parent;w=p.parent
rows=list(csv.DictReader((p/'joined.tsv').open(),delimiter='\t'));sel=[r for r in rows if r['selected']=='1'];uses=collections.defaultdict(list)
for r in sel:uses[int(r['base-use']),int(r['final-use'])+1].append(int(r['pp-row']))
with (p/'overlap.tsv').open('w') as f:
 out=csv.writer(f,delimiter='\t');out.writerow(['statement-owner','intervals','accepted-chains','fully-intersecting-chains','partly-intersecting-chains','disjoint-chains','overlapping-hops','disjoint-hops'])
 for study in ['source-store-statements-study','source-condition-statements-study']:
  intervals=[]
  for l in (w/study/'sqlite.new.stderr').open():
   a=l.split()
   if a and a[0] in ('direct-statement','direct-condition'):intervals.append(tuple(map(int,a[1:3])))
  cuts=[v[0] for v in sorted(intervals)]; iv=sorted(intervals);assert all(b<i for (_,b),(i,_) in zip(iv,iv[1:]))
  def hit(t):
   i=bisect.bisect_right(cuts,t)-1
   return iv[i] if i>=0 and t<=iv[i][1] else None
  full=part=membership=0
  for (begin,end),refs in uses.items():
   iv0=hit(begin);matches=sum(bool(hit(t)) for t in refs); membership+=matches
   if iv0 and hit(end)==iv0:full+=1
   elif iv0 or matches or hit(end):part+=1
  out.writerow([study,len(iv),len(uses),full,part,len(uses)-full-part,membership,len(sel)-membership])
