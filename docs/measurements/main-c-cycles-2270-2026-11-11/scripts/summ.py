import sys, statistics as st, collections
d=collections.defaultdict(list)
for l in open(sys.argv[1]):
    r,g,n,ev,v=l.rstrip('\n').split('\t')
    try: d[(ev,n)].append(float(v))
    except: pass
names=[]; evs=[]
for (ev,n) in d:
    if n not in names: names.append(n)
    if ev not in evs: evs.append(ev)
base=sys.argv[2] if len(sys.argv)>2 else names[0]
print("event\t"+"\t".join(f"{n} median [min..max] (N)" for n in names)+"\t"+"\t".join(f"{n}-vs-{base}" for n in names if n!=base))
for ev in evs:
    row=[ev]; meds={}
    for n in names:
        v=d.get((ev,n),[])
        if not v: row.append("-"); continue
        m=st.median(v); meds[n]=m
        row.append(f"{m:.6g} [{min(v):.4g}..{max(v):.4g}] ({len(v)})")
    for n in names:
        if n==base: continue
        b=meds.get(base); h=meds.get(n)
        row.append(f"{(h/b-1)*100:+.2f}%" if b and h is not None else "-")
    print("\t".join(row))
