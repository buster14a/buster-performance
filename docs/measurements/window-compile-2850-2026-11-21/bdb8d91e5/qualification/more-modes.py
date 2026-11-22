from pathlib import Path
import csv,hashlib,subprocess
st=Path(__file__).resolve().parent
w=st.parent
compilers=[w/'main-fbef-clean/build/compiler',w/'pending-native-windows/build/compiler']
modes=['--poison-arenas','--scalar','--check-transitions','--attested=verify','--deferred-bodies','--node-window','--node-window-assignments','--node-window-constants','--dump-static','-gmodules']
with (st/'more-modes.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('case','mode','status','same','object','stdout','stderr'))
 for case in ['local','reassigned','shadow','long-block','flags','extern-in-block','cleanup','pragma']:
  src=st/'source-fixtures'/(case+'.c');assert src.is_file()
  for mode in modes:
   receipts=[]
   for cc in compilers:
    obj=st/'more-mode.o';obj.unlink(missing_ok=True)
    r=subprocess.run([cc,mode,'-std=gnu23','-c',src,'-o',obj],capture_output=True,timeout=60)
    receipts.append((r.returncode,*[hashlib.sha256(b).hexdigest() for b in [obj.read_bytes() if obj.exists() else b'',r.stdout,r.stderr]]))
   a,b=receipts;t.writerow([case,mode,b[0],int(a==b),*b[1:]])
