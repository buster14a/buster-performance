from pathlib import Path
import sys,subprocess,os,tempfile,hashlib,concurrent.futures,json
inputs=[]; opts=[]; skip=False
for x in sys.argv[2:]:
 if skip:opts.append(x);skip=False
 elif x=='-I':opts.append(x);skip=True
 elif x.endswith('.c'):inputs.append(x)
 else:opts.append(x)
log=Path(os.environ['debug_log']); cc=os.environ['cc']; group=sys.argv[1]
def pair(f):
 with tempfile.TemporaryDirectory(prefix='obj-',dir=log) as d:
  obj=Path(d)/'unit.o'; results=[]
  for flag in [[],['--node-window']]:
   obj.unlink(missing_ok=True)
   p=subprocess.run([cc,'-c','--lanes','1',*flag,*opts,f,'-o',str(obj)],cwd=os.environ['src_root'],capture_output=True,timeout=180)
   digest=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else ''
   results.append((p.returncode,p.stdout,p.stderr,digest))
  if results[0]!=results[1]:
   bad=log/(group+'-'+Path(f).name+'-diff.txt');bad.write_text(str([f,[(r[0],r[1],r[2],r[3]) for r in results]]))
  return [f,results[0][0],results[1][0],results[0][3],results[1][3],results[0]==results[1]]
with concurrent.futures.ThreadPoolExecutor(2) as pool: rows=list(pool.map(pair,inputs))
(log/(group+'.json')).write_text(json.dumps(rows,indent=1)+'\n')
print(group,len(rows),sum(r[1]==0 and bool(r[3]) for r in rows),sum(not r[5] for r in rows),flush=True)
sys.exit(any(not r[5] for r in rows))
