import sys, glob, collections, statistics as st, re
# perf report -F overhead,period,sym text files: per-symbol median samples' period, base vs head
def load(name):
    runs=[]
    for f in sorted(glob.glob(f"{sys.argv[1]}/{name}.*.txt")):
        d={}
        for l in open(f):
            m=re.match(r'\s*([\d.]+)%\s+(\d+)\s+\[\.\]\s+(.*\S)', l)
            if m:
                k=m.group(3).replace(".buster_split",""); d[k]=d.get(k,0)+int(m.group(2))
        runs.append(d)
    return runs
b=load('base'); h=load('head')
syms=set().union(*b,*h)
rows=[]
for s in syms:
    vb=[r.get(s,0) for r in b]; vh=[r.get(s,0) for r in h]
    rows.append((st.median(vh)-st.median(vb), s, st.median(vb), st.median(vh), min(vb),max(vb),min(vh),max(vh)))
tb=st.median([sum(r.values()) for r in b]); th=st.median([sum(r.values()) for r in h])
print(f"total user cycles sampled: base {tb/1e6:.1f}M head {th/1e6:.1f}M ({(th/tb-1)*100:+.2f}%), {len(b)} and {len(h)} runs")
print("delta(Mcyc)\tbase(M) [range]\thead(M) [range]\tsymbol")
rows.sort()
for r in rows[:15]+[None]+rows[-25:]:
    if r is None: print("..."); continue
    d,s,mb,mh,b0,b1,h0,h1=r
    print(f"{d/1e6:+.2f}\t{mb/1e6:.2f} [{b0/1e6:.2f}..{b1/1e6:.2f}]\t{mh/1e6:.2f} [{h0/1e6:.2f}..{h1/1e6:.2f}]\t{s}")
