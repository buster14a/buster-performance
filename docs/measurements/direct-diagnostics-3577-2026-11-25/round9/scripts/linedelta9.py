#!/usr/bin/env python3
# linedelta.py BASE_M WORK_M [FUNC]: per-function instruction deltas (work - base), lines mapped through git diff.
import sys, subprocess, re, collections
S='/tmp/claude-0/-home-user/cf3643bc-6e1c-51b2-99ca-175eb97147e4/scratchpad'
R='/home/user/buster-ibs'
BASE='86427a9f5'
TB=float(sys.argv[1]); TW=float(sys.argv[2]); want=sys.argv[3] if len(sys.argv)>3 else None
files=['c_direct_cc.c','c_direct_lex.c','c_direct_types.c','c_direct_x86.c','c_direct.c']
def load(path,total):
    d=collections.defaultdict(float)
    for l in open(path):
        p=l.split()
        if len(p)>=2 and p[0].endswith('%'):
            d[p[1]]+=float(p[0][:-1])*total/100
    return d
B=load(S+'/ibs9/ibs9-lines-base.txt',TB); W=load(S+'/ibs9/ibs9-lines-head.txt',TW)
w2b={}; added={}
for f in files:
    out=subprocess.run(['git','-C',R,'diff','-U0',BASE,'--','src/buster/compiler/'+f],capture_output=True,text=True).stdout
    nw=sum(1 for _ in open(R+'/src/buster/compiler/'+f))
    hunks=[]
    for m in re.finditer(r'^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@',out,re.M):
        bs=int(m.group(1)); bc=int(m.group(2)) if m.group(2) is not None else 1
        ws=int(m.group(3)); wc=int(m.group(4)) if m.group(4) is not None else 1
        hunks.append((bs,bc,ws,wc))
    # walk
    b=1; w=1
    for bs,bc,ws,wc in hunks:
        wstart = ws if wc>0 else ws+1
        bstart = bs if bc>0 else bs+1
        while w < wstart:
            w2b['%s:%d'%(f,w)]='%s:%d'%(f,b); w+=1; b+=1
        for k in range(wc):
            added['%s:%d'%(f,w)]=True; w+=1
        b = bstart + bc
    while w <= nw:
        w2b['%s:%d'%(f,w)]='%s:%d'%(f,b); w+=1; b+=1
# function ranges in the work files
func_of={}
for f in files:
    lines=open(R+'/src/buster/compiler/'+f).read().split('\n')
    cur=None
    for i,l in enumerate(lines):
        n=i+1
        if cur is None and re.match(r'^(static|bool|void|uint|int|FastTok|FastLexed|const|BUSTER_)',l) and '(' in l and not l.rstrip().endswith(';'):
            m=re.search(r"(\w+)\s*\(",re.sub(r"__attribute__\(\(\w+\)\)|BUSTER_\w+ ","",l).split("=")[0])
            if m: cur=m.group(1)
        if cur: func_of['%s:%d'%(f,n)]=cur
        if l.startswith('}'): cur=None
mapped_b=set()
rows=collections.defaultdict(lambda:[0.0,0.0,[]])
for k,v in W.items():
    if k.endswith(':0'): continue
    fn=func_of.get(k,'?'); 
    if added.get(k):
        rows[fn][0]+=v; rows[fn][2].append((v,k,'+'))
    else:
        bk=w2b.get(k); bv=B.get(bk,0.0); mapped_b.add(bk)
        rows[fn][1]+=v-bv; rows[fn][2].append((v-bv,k,'='))
# base lines with no work samples
for bk,bv in B.items():
    if bk in mapped_b or bk.endswith(':0'): continue
    # find work line
    pass
tot=sorted(rows.items(), key=lambda kv: -(kv[1][0]+kv[1][1]))
if want:
    r=rows[want]; print("%s: added %+.2f unchanged %+.2f"%(want,r[0],r[1]))
    for v,k,t in sorted(r[2],reverse=True)[:40]: print("  %+.3f %s %s"%(v,t,k))
    for v,k,t in sorted(r[2])[:10]: print("  %+.3f %s %s"%(v,t,k))
else:
    for fn,(a,u,_) in tot[:45]: print("%+6.2f  added %+5.2f unchanged %+5.2f  %s"%(a+u,a,u,fn))
    print("zero-line: lex %+.2f cc %+.2f types %+.2f x86 %+.2f"%tuple(W.get(f+':0',0)-B.get(f+':0',0) for f in ['c_direct_lex.c','c_direct_cc.c','c_direct_types.c','c_direct_x86.c']))
