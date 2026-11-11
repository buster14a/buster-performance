import sys, glob, statistics as st, collections
d=collections.defaultdict(lambda: collections.defaultdict(list)); pk=collections.defaultdict(lambda: collections.defaultdict(list))
order=[]
for name in ('base','head'):
    for f in sorted(glob.glob(f"{sys.argv[1]}/{name}.*.txt")):
        for l in open(f):
            p=l.rstrip('\n').split('\t')
            if p[0] in ('time-stage','time-check') and len(p)>=3 and p[1] not in ('stage',):
                k=p[0][5:]+' '+p[1]
                try: d[k][name].append(float(p[2]))
                except: continue
                if k not in order: order.append(k)
                if len(p)>=7:
                    try: pk[k][name].append(float(p[6]))
                    except: pass
print("stage\tbase ms median [range]\thead ms median [range]\tdelta ms\tdelta %\tpeak-kb-added base/head medians")
for k in order:
    b=d[k]['base']; h=d[k]['head']
    if not b or not h: continue
    mb=st.median(b); mh=st.median(h)
    if mb<1 and mh<1: continue
    pkb=pk[k]['base']; pkh=pk[k]['head']
    pks=f"{st.median(pkb):.0f}/{st.median(pkh):.0f}" if pkb and pkh else ""
    print(f"{k}\t{mb:.3f} [{min(b):.2f}..{max(b):.2f}]\t{mh:.3f} [{min(h):.2f}..{max(h):.2f}]\t{mh-mb:+.3f}\t{(mh/mb-1)*100 if mb else 0:+.2f}%\t{pks}")
