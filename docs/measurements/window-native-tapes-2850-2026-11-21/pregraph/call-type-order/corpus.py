import json,os,struct,subprocess,sys,tempfile,hashlib
from collections import Counter
from pathlib import Path
cc,group,out,*args=sys.argv[1:];cc=str(Path(cc).resolve());out=Path(out).resolve();out.mkdir(parents=True,exist_ok=True)
inputs=[];flags=[];n=0
while n<len(args):
 v=args[n];n+=1
 if v in ('-I','--predefines','-include'):
  flags.extend([v,args[n]]);n+=1
 elif v.endswith('.c'):inputs.append(v)
 else:flags.append(v)
res=[];empty=Counter()
for idx,src in enumerate(inputs):
 with tempfile.TemporaryDirectory(dir=out) as dd:
  tmp=Path(dd);tests=[]
  for mode,opt in [('baseline','--node-window'),('published','--node-window-calls')]:
   typ=tmp/(mode+'.trace');elf=tmp/'unit.o'
   if elf.exists():elf.unlink()
   proc=subprocess.run([cc,opt,'--lanes','1','-c',*flags,src,'-o',str(elf)],env=dict(os.environ,NODE_CALL_EFFECT_TRACE=str(typ)),capture_output=True,timeout=120)
   subs=typ.read_bytes().splitlines() if typ.exists() else []
   domain=b'\n'.join(l for l in subs if l.startswith(b'type '))
   sh=lambda b:hashlib.sha256(b).hexdigest()
   nums=sum(l.startswith(b'scheduled ') for l in subs)
   tests.append((proc.returncode,sh(proc.stdout),sh(proc.stderr),sh(elf.read_bytes()) if elf.exists() else '',sh(domain) if domain else '',nums))
  good=tests[0][:5]==tests[1][:5];empty[(good,tests[0][0],bool(tests[1][-1]))]+=1
  if not good:
   print('mismatch',src,tests,flush=True)
  res.append([src,*tests,good])
(out/(group+'.json')).write_text(json.dumps(res,separators=(',',':'))+'\n')
print(group,len(res),sum(x[2][-1] for x in res),dict(empty),flush=True)
