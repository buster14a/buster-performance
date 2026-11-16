# schemes.py DUMP...: how many classes and scans a pass needs over the windows of DUMP (windows-body.txt.gz, a body a
# window; windows-packed.txt.gz, packed to 384 records) under each way to class a window's made operators: levels with
# the expressions' last records apart (the first build's), and rounds of the codes in several orders, with and without
# an operator of its operand's own code staying in its class, and with some codes merged.
import sys, itertools, collections
NAMES=['arrow','dot','deref','subscript','call','discard','row','store','convert','truth','address','cast','logic','update','other']
def load(path):
    # A window a `W count` line, then a record a line: kind, code, operator, the operands' distances back (left, right,
    # third; 0 for none), whether it is its expression's last record, and a call's arguments' distances.
    import gzip
    windows=[]; cur=None
    for line in (gzip.open(path, 'rt') if path.endswith('.gz') else open(path)):
        if line[0]=='W':
            cur=[]; windows.append(cur); continue
        f=[int(x) for x in line.split()]
        kind,code,op,l,r,t,root=f[:7]; args=f[7:]
        cur.append((kind,code,op,l,r,t,root,args))
    return windows
def made(rec): return rec[0] in (3,7)
def operands(i,rec):
    out=[]
    for d in (rec[3],rec[4],rec[5]):
        if d: out.append(i-d)
    for d in rec[7]: out.append(i-d)
    return out
def s0(windows, merge=None):
    classes=0; levels=0; total=0
    for win in windows:
        lv=[0]*len(win); seen=set(); lvls=set()
        for i,rec in enumerate(win):
            if not made(rec): continue
            total+=1
            m=max([lv[o] for o in operands(i,rec)] or [0])
            lv[i]=min(m+1,14)
            code=rec[1] if merge is None else merge[rec[1]]
            L=15 if rec[6] else lv[i]
            seen.add((L,code)); lvls.add(L)
        classes+=len(seen); levels+=len(lvls)
    return classes,levels,total
def rounds(windows, order, chain, merge=None, roots=False):
    # order: list of codes (after merge) in a round's sequence; pos[code]
    pos={c:i for i,c in enumerate(order)}
    classes=0; nrounds=0; maxr=collections.Counter()
    for win in windows:
        slot=[None]*len(win); seen=set(); rs=set()
        for i,rec in enumerate(win):
            if not made(rec): continue
            code=rec[1] if merge is None else merge[rec[1]]
            p=pos[code]; r=0
            for o in operands(i,rec):
                if slot[o] is None: continue
                ro,po=slot[o]
                if po<p or (chain and po==p): r=max(r,ro)
                else: r=max(r,ro+1)
            if roots and rec[6]: slot[i]=(99,p)
            else: slot[i]=(r,p)
            seen.add(slot[i]); rs.add(slot[i][0])
        classes+=len(seen); nrounds+=len(rs); maxr[len(rs)]+=1
    return classes,nrounds,maxr
if __name__ == "__main__":
  for path in sys.argv[1:]:
      W=load(path)
      print(path.split('/')[-1], 'windows',len(W))
      c,l,t=s0(W); print(' S0 levels+roots: classes',c,'levels',l,'made',t, 'per class %.2f'%(t/c))
      base=list(range(15))
      orders={
       'lookups,addr,cast,row,logic,truth,update,store,convert,discard,other':[0,1,3,2,4,10,11,6,12,9,13,7,8,5,14],
       'addr,cast,row first, then lookups':[10,11,6,0,1,3,2,4,12,9,13,7,8,5,14],
       'lookups(no call),addr,cast,row,call,logic,truth,update,store,convert,discard,other':[0,1,3,2,10,11,6,4,12,9,13,7,8,5,14],
       'arrow,dot,deref,subscript,addr,cast,row,call,logic,truth,update,store,convert,discard,other':[0,1,2,3,10,11,6,4,12,9,13,7,8,5,14],
      }
      for name,order in orders.items():
          for chain in (False,True):
              for roots in (False,True):
                  c,r,m=rounds(W,order,chain,roots=roots)
                  print('  rounds chain=%d roots=%d [%s]: classes %d rounds %d per class %.2f'%(chain,roots,name[:40],c,r,t/c))
      # merged codes: member(arrow,dot)=0, element(deref,subscript)=2, call=4, discard=5, row=6, store+convert=7, truth+logic=9, address=10, cast=11, update=13, other=14
      merge={0:0,1:0,2:2,3:2,4:4,5:5,6:6,7:7,8:7,9:9,10:10,11:11,12:9,13:13,14:14}
      c,l,t=s0(W,merge); print(' S0 merged: classes',c,'levels',l,'per class %.2f'%(t/c))
      order=[0,2,10,11,6,4,9,13,7,5,14]
      for chain in (False,True):
          for roots in (False,True):
              c,r,m=rounds(W,order,chain,merge,roots)
              print('  merged rounds chain=%d roots=%d: classes %d rounds %d per class %.2f'%(chain,roots,c,r,t/c), dict(sorted(m.items())) if chain and not roots else '')
  