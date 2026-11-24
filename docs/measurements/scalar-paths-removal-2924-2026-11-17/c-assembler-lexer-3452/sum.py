import re, sys, statistics as st, collections
d=collections.defaultdict(list)
for l in open(sys.argv[1]):
    p=l.split(); f,b=p[2],p[1]
    d[(f,b)].append((int(re.search(r'lex_ns=(\d+)',l).group(1)),int(re.search(r'total_ns=(\d+)',l).group(1))))
print(f"{'input':18} {'lex base ms':>11} {'head/base':>9} {'ctrl/base':>9} | {'total base ms':>13} {'head/base':>9} {'ctrl/base':>9}")
for f in sorted({f for f,b in d}):
    m=lambda b,i: st.median(x[i] for x in d[(f,b)])
    print(f"{f:18} {m('base',0)/1e6:11.3f} {m('head',0)/m('base',0):9.3f} {m('ctrl',0)/m('base',0):9.3f} | {m('base',1)/1e6:13.2f} {m('head',1)/m('base',1):9.3f} {m('ctrl',1)/m('base',1):9.3f}")
