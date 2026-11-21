from pathlib import Path
import struct,re,sys,json,collections,hashlib
d=Path(sys.argv[1]); base=sys.argv[2]; opt=sys.argv[3]; key_oracle=sys.argv[4] if len(sys.argv)>4 else base
none=(1<<32)-1
head=struct.Struct('<10I')
def load(name):
    raw=(d/(name+'.bin')).read_bytes(); n,narg,vs,cs=struct.unpack_from('<4I',raw)
    stride=head.size+vs+cs+8; assert len(raw)==16+n*stride+4*narg
    def row(i):
        p=16+stride*i
        return head.unpack_from(raw,p),raw[p+head.size:p+head.size+vs],raw[p+head.size+vs:p+stride]
    args=struct.unpack_from('<%dI'%narg,raw,16+n*stride)
    return [row(i) for i in range(n)],args
ordinary,args=load(base); compact,cargs=load(opt)
bytoken=collections.defaultdict(list)
for i,(h,*_) in enumerate(ordinary):bytoken[h[0]].append(i)
log=(d/(opt+'.err')).read_text()
taken=[tuple(map(int,m)) for m in re.findall(r'compact-taken: token=(\d+) operand=(\d+) node=(\d+) removed=(\d+) rows=(\d+)',log)]
whole={int(t) for t in re.findall(r'compact-taken: token=(\d+).* whole=1',log)}
consumed=[int(m) for m in re.findall(r'compact-consumed: token=(\d+)',log)]
ordinary_roots={int(m) for m in re.findall(r'splice-taken: token=(\d+)',(d/(key_oracle+'.err')).read_text())}
assert len(set(x[0] for x in taken))==len(taken)
def children(h,args):
    return [v for v in h[2:5] if v!=none]+list(args[h[5]:h[5]+h[6]])
removed=set();summaries={}; wrapper_ids=set(); orphans=[]; chain_count=0
for token,operand,new,size,rows in taken:
    matched=[i for i in bytoken[token] if ordinary[i][0][2]!=none and ordinary[ordinary[i][0][2]][0][0]==operand]
    assert len(matched)==1,(token,matched)
    wrapper,=matched; top=ordinary[wrapper][0][2];wrapper_ids.add(wrapper)
    old={top};stack=[top]
    while stack:
        for j in children(ordinary[stack.pop()][0],args):
            assert j not in old,(token,j);old.add(j);stack.append(j)
    full=token in whole
    assert len(old)==size+1-int(full) and not (old&removed),(token,len(old),size,full)
    removed|=old if full else old-{top};summaries[wrapper if full else top]=new
    if token not in ordinary_roots:orphans.append(token)
keep=[i for i in range(len(ordinary)) if i not in removed]
assert len(keep)==len(compact),(len(keep),len(compact))
move={old:i for i,old in enumerate(keep)}; bad=collections.Counter();first={}
for n,old in enumerate(keep):
    h,v,e=ordinary[old];k,w,z=compact[n]; root=old in summaries
    checks={'token':h[0]==k[0], 'graph_op':k[1]==(0 if root else h[1]), 'value':v==w, 'diagnostic':h[7]==k[7], 'warnings':h[8:]==k[8:]}
    if root:
        checks.update({'leaf':summaries[old]==n and not children(k,cargs)})
    else:
        oldedges=children(h,args);chain_count+=len(oldedges)
        checks.update({'edges':[move.get(i,-1) for i in oldedges]==children(k,cargs),'conversions/member':e==z})
    for label,ok in checks.items():
        if not ok:
            bad[label]+=1
            first.setdefault(label, dict(old=old,node=n,token=h[0],oldop=h[1],op=k[1],summary=root,difference=[i for i,(a,b) in enumerate(zip(v,w)) if a!=b]))
print(json.dumps(dict(ordinary_nodes=len(ordinary),compact_nodes=len(compact),operands=len(taken),whole_returns=len(whole),removed=len(removed),fallback_edges=chain_count,retained=len(keep),summaries=len(summaries),selected_native_rows=sum(r[-1] for r in taken),ordinary_spliced=len(ordinary_roots),outside_ordinary_native_roots=len(orphans),requested=len(consumed),unique_requested=len(set(consumed)),not_lowered=sorted(set(x[0] for x in taken)-set(consumed))[:20],extra_native=set(consumed)-set(x[0] for x in taken) and 'yes' or 'no',mismatches=bad,first=first),indent=2))
assert not bad
