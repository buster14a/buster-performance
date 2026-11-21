import csv,collections,hashlib,os,pathlib,re,shlex,struct,subprocess,sys,tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
d=Path(sys.argv[1]).resolve();cc=Path(sys.argv[2]).resolve();raw=Path(sys.argv[3]).resolve();out=d/'corpora';out.mkdir(exist_ok=True)
def sha(b):return hashlib.sha256(b).hexdigest()
def sections(obj):
 if not obj.exists():return {}
 b=obj.read_bytes();off=struct.unpack_from('<Q',b,40)[0];size,n,st=struct.unpack_from('<HHH',b,58)
 rows=[struct.unpack_from('<IIQQQQIIQQ',b,off+i*size) for i in range(n)]
 names=b[rows[st][4]:rows[st][4]+rows[st][5]]
 return {names[x[0]:names.find(b'\0',x[0])].decode(errors='replace'):sha(b[x[4]:x[4]+x[5]]) for x in rows if x[1]!=8}
jobs=[]
for k,args in zip(('sqlite','lua','musl','buster'),sys.argv[4:8]):
 ws=shlex.split(args);flags=[i for i in ws if not i.endswith('.c')]
 for s in ws:
  if s.endswith('.c'):
   for policy,e in [('default',[]),('debug',['-g'])]:
    jobs.append((k,Path(s).resolve(),flags+e,policy))
def one(job):
 k,s,flags,policy=job
 modes=[]
 with tempfile.TemporaryDirectory(dir=out) as scratch:
  for mode,exe,opts in [('ordinary',cc,[]),('candidate',cc,['--node-window-calls']),('unfixed',raw,['--node-window-calls'])]:
   if mode=='unfixed' and policy=='debug': continue
   o=Path(scratch)/'o';o.unlink(missing_ok=True);m=Path(scratch)/'marks';m.unlink(missing_ok=True)
   env=dict(os.environ,BUSTER_WINDOW_CALL_LOG='1')
   if mode=='candidate' and policy=='debug':env['BUSTER_CALL_FORCE_DEBUG']='1'
   if policy=='debug': env['BUSTER_CALL_MARKS']=str(m)
   p=subprocess.run([exe,'--lanes','1','-c',*flags,*opts,s,'-o',o],capture_output=True,env=env);b=o.read_bytes() if o.exists() else b''
   diag=b''.join(l for l in p.stderr.splitlines(keepends=True) if not l.startswith(b'plain-call:'))
   counts=len(re.findall(rb'^plain-call:',p.stderr,re.M));mark=m.read_bytes() if m.exists() else b''
   witness=sha(b'\n'.join(l.rsplit(b' ',1)[0] for l in mark.splitlines()))
   if len(modes) and (sha(b)!=modes[0]['elf'] or sha(diag)!=modes[0]['diagnostics']):
    missdir=out/(k+'-'+s.name+'-'+policy);missdir.mkdir(exist_ok=True);(missdir/(mode+'.err')).write_bytes(diag)
   modes.append(dict(mode=mode,exit=p.returncode,elf=sha(b),diagnostics=sha(diag),calls=counts,marks=witness,rawmarks=sha(mark),sections=sections(o),nmarks=len(mark.splitlines())))
 a,b=modes[:2];c=modes[2] if len(modes)>2 else None
 diffs=sorted(n for n in set(a['sections'])|set(b['sections']) if a['sections'].get(n)!=b['sections'].get(n))
 return [k,policy,str(s),a['exit'],b['exit'],int(a['diagnostics']==b['diagnostics']),int(a['elf']==b['elf']),int(a['marks']==b['marks']),int(a['rawmarks']==b['rawmarks']),b['nmarks'],b['calls'],c['calls'] if c else '-',','.join(diffs),a['elf'],b['elf']]
head='corpus policy source baseline_status candidate_status same_diagnostics same_elf same_marks same_raw_ids marks calls unfixed_calls different_sections baseline_sha candidate_sha'.split()
with ThreadPoolExecutor(max_workers=2) as pool,(out/'matrix.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(head)
 for i,r in enumerate(pool.map(one,jobs)):
  w.writerow(r)
  if i%100==0:f.flush()
