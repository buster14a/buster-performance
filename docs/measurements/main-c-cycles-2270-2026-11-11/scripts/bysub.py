import sys, statistics as st, collections
# rows: round, sub (seed/offset), build, event, value[, pct]
d=collections.defaultdict(list)
for l in open(sys.argv[1]):
    f=l.rstrip('\n').split('\t')
    try: d[(f[3],f[1],f[2])].append(float(f[4]))
    except: pass
evs=sorted({k[0] for k in d}, key=lambda e:(e!='cycles:u', e))
subs=sorted({k[1] for k in d}, key=int)
for ev in evs:
    print(f"== {ev}: per {sys.argv[2] if len(sys.argv)>2 else 'sub'}: base median, head median, head vs base (N each)")
    deltas=[]; bm=[]; hm=[]
    for s in subs:
        b=d.get((ev,s,'base'),[]); h=d.get((ev,s,'head'),[])
        if not b or not h: continue
        mb=st.median(b); mh=st.median(h); deltas.append((mh/mb-1)*100); bm.append(mb); hm.append(mh)
        print(f"  {s:>5}: {mb:.6g} [{min(b):.4g}..{max(b):.4g}]  {mh:.6g} [{min(h):.4g}..{max(h):.4g}]  {deltas[-1]:+.2f}% ({len(b)},{len(h)})")
    allb=[v for s in subs for v in d.get((ev,s,'base'),[])]; allh=[v for s in subs for v in d.get((ev,s,'head'),[])]
    print(f"  all: base {st.median(allb):.6g}, head {st.median(allh):.6g}, {(st.median(allh)/st.median(allb)-1)*100:+.2f}%; per-{sys.argv[2] if len(sys.argv)>2 else 'sub'} deltas {min(deltas):+.2f}% to {max(deltas):+.2f}%, median {st.median(deltas):+.2f}%; base spread over subs {(max(bm)/min(bm)-1)*100:.2f}%, head {(max(hm)/min(hm)-1)*100:.2f}%")
