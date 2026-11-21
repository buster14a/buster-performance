from pathlib import Path
import sys,subprocess,os,re,json,hashlib,collections
cc=Path(sys.argv[1]).resolve();out=Path(sys.argv[2]).resolve();out.mkdir(exist_ok=True,parents=True);args=sys.argv[3:]
env={k:'1' for k in ('NODE_PROOF_NO_FP','NODE_PROOF_POINTERS','NODE_PROOF_CALLS','NODE_PROOF_NATIVE','NODE_SOURCE_ROWS','NODE_SPLICE_FRONT','NODE_SPLICE_REPORT','NODE_SPLICE_ENABLE')}
rows=[]
for source,vs in [
 ('ordinary',None),('shadow',{}),('independent',{'NODE_SOURCE_ONLY':'1'}),('string',{'NODE_SOURCE_ONLY':'1','NODE_SOURCE_STRINGS':'1'}),
 ('registry',{'NODE_SOURCE_ONLY':'1','NODE_SOURCE_REFRESH_POINTERS':'1'}),('both',{'NODE_SOURCE_ONLY':'1','NODE_SOURCE_STRINGS':'1','NODE_SOURCE_REFRESH_POINTERS':'1'})]:
 args0=dict(os.environ,**env,**(vs or {})) if vs is not None else dict(os.environ)
 args0.update(NODE_SOURCE_NATIVE_ORACLE=str(out/(source+'.native')))
 obj=out/(source+'.o');p=subprocess.run([str(cc),'--lanes','1','-c',*args,'-o',str(obj)],capture_output=True,env=args0)
 (out/(source+'.err')).write_bytes(p.stderr);(out/(source+'.out')).write_bytes(p.stdout)
 pairs={int(t):(int(k),int(n),int(op)) for t,k,n,op in re.findall(rb'splice-taken: token=(\d+) node=\d+ k=(\d+) n=(\d+) op=(\d+)',p.stderr)}
 if source=='shadow':shadow=pairs
 if source in ('ordinary','shadow'):miss=set();extra=set()
 else:miss=shadow.keys()-pairs.keys();extra=pairs.keys()-shadow.keys()
 stats=[tuple(map(int,x)) for x in re.findall(rb'source-rows selected=(\d+) written=(\d+) entries=(\d+)',p.stderr)]
 rows.append(dict(mode=source,status=p.returncode,accepted=sum(s[0] for s in stats),tapes=sum(s[1] for s in stats),retained_rows=sum(s[2] for s in stats),consumed=len(pairs),missing=len(miss),new=len(extra),missing_types=dict(collections.Counter(map(str,(shadow[i] for i in miss)))),object=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else None,native=hashlib.sha256((out/(source+'.native')).read_bytes()).hexdigest() if (out/(source+'.native')).exists() else None))
print(json.dumps(rows,indent=2))
