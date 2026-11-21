from pathlib import Path
import os,sys,subprocess,csv,re,hashlib,collections,json
p=Path(__file__).resolve().parent
cc=Path(sys.argv[1]).resolve();d=Path(sys.argv[2]).resolve();d.mkdir(exist_ok=True,parents=True)
src=d/'complete-source.c'
with src.open('w') as o:
 o.write('static int one,two;\nextern int ext(int);\n')
 for i in range(257):
  expr=[f'{i} * 3 + 18',f'({i} - 100)',f'(one + {i}) - two',f'one + two',f'x * 3 + {i}',f'ext({i})',f'((unsigned char){i})',f'-{i}',f'one | {i}',f'({i} ? x : two)',f'{i}',f'(-{i})',f'(one = two, x)'][i%13]
  o.write(f'int fn_{i}(int x) {{ '+(f'one={i}; ' if i%3==0 else '')+f'return {expr}; }}\n')
 o.write('int final(void) { return fn_0(one) + fn_123(two); }\n')
env={k:'1' for k in ('NODE_PROOF_NO_FP','NODE_PROOF_POINTERS','NODE_PROOF_CALLS','NODE_SOURCE_ROWS','NODE_PROOF_NATIVE','NODE_SPLICE_FRONT','NODE_SOURCE_COMPACT','NODE_SOURCE_COMPACT_REPORT','NODE_SPLICE_REPORT')}
def diagnostics(raw):
 return b'\n'.join(l for l in raw.splitlines() if not l.startswith((b'source-rows ',b'node-proof ',b'probe-',b'splice-taken:',b'compact-consumed:',b'compact-taken:',b'splice-local-class:')))
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest() if path.exists() else None
rows=[]
flags=[('basic',[]),('debug',['-g']),('wall',['-Wall','-Wextra']),('nodiag',['-w']),('verify',['--verify']),('strict',['-std=c23']),('two',['--lanes','2']),('tier',['--tier1']),('scalar',['--scalar'])]
for key,args in flags:
 sub=d/key;sub.mkdir(exist_ok=True);seen=[]
 for m in ['plain','source','compact','full']:
  vals=dict(env) if m!='plain' else {}
  if m=='source':vals.pop('NODE_SOURCE_COMPACT',None);vals['NODE_SOURCE_ONLY']='1';vals['NODE_SPLICE_ENABLE']='1'
  if m=='full':vals['NODE_SOURCE_COMPACT_FULL']='1'
  obj=sub/(m+'.o');native=sub/(m+'.native');graph=sub/(m+'.bin')
  for f in [obj,native,graph]:f.unlink(missing_ok=True)
  vals.update(NODE_SOURCE_NATIVE_ORACLE=str(native),NODE_SOURCE_GRAPH_ORACLE=str(graph))
  if key=='debug' and not os.environ.get('FIXED_DEBUG_WITNESS'): vals.pop('NODE_SOURCE_NATIVE_ORACLE',None)
  options=([] if key=='two' else ['--lanes','1'])+args
  cmd=[str(cc),*options,'-c',str(src),'-o',str(obj)]
  r=subprocess.run(cmd,env=dict(os.environ,**vals),capture_output=True)
  (sub/(m+'.err')).write_bytes(r.stderr);(sub/(m+'.out')).write_bytes(r.stdout)
  diag=diagnostics(r.stderr)
  hits=len(re.findall(rb'^compact-taken:',r.stderr,re.M))
  seen.append((r.returncode,sha(obj),sha(native),diag,r.stdout))
  rows.append(dict(policy=key,mode=m,exit=r.returncode,hits=hits,object=sha(obj),native=sha(native),diagnostic=hashlib.sha256(diag).hexdigest()))
  if m in ('compact','full') and r.returncode==0:
   c=subprocess.run([sys.executable,str(p/'graph_check.py'),str(sub),'plain',m,'source'],capture_output=True)
   (sub/(m+'.json')).write_bytes(c.stdout+c.stderr)
   if c.returncode:print(key,m,'graph mismatch',c.stdout.decode()[-500:],flush=True)
 if len(set(seen))!=1:print(key,'DIFFERENCES',[(r[0],r[1],r[2],r[3][:220]) for r in seen],flush=True)
with (d/'results.tsv').open('w') as o:
 f=csv.DictWriter(o,list(rows[0].keys()),delimiter='\t',lineterminator='\n');f.writeheader();f.writerows(rows)
