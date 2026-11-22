from pathlib import Path
import itertools,subprocess,shutil,csv,hashlib
d=Path(__file__).resolve().parent;w=d.parent;obj=d/'poison.o';src=d/'fields.c'
with (d/'poison.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t');t.writerow(['window','debug','verify','status','object','warnings','equal'])
 for win,debug,verify in itertools.product([0,1,2,2048,2147483647],[False,True],[False,True]):
  twins=[]
  opts=['--poison-arenas','--lanes','1',f'--emit-window={win}']
  if verify:opts+=['--verify']
  if debug:opts+=['-g']
  for tree in ['main-fbef-clean','body-local-emission']:
   obj.unlink(missing_ok=True)
   p=subprocess.run([w/tree/'build/compiler',*opts,'-c',src,'-o',obj],capture_output=True,timeout=15)
   h=lambda data:hashlib.sha256(data).hexdigest()
   twins.append((p.returncode,h(obj.read_bytes()) if obj.exists() else '-',h(p.stderr),h(p.stdout)))
  assert twins[0]==twins[1],(win,opts,twins)
  t.writerow([win,debug,verify,*twins[0][:3],True])
