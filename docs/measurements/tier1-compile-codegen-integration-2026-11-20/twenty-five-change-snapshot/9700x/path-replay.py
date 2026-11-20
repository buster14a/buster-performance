from pathlib import Path
import csv,hashlib,os,subprocess,sys,tempfile
w=Path(__file__).resolve().parents[1];src=w/'compile-evidence';dest='/home/david/buster-fast-bench/compile-codex-01a1f5e5'
env=dict(os.environ,LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
for name in sys.argv[1:]:
 d=w/(name+'-evidence')/'native';rows=[]
 for rec in csv.DictReader((d/'local-remote-objects.tsv').open(),delimiter='\t'):
  key,v=rec['workload'],rec['compiler'];exe=w/(name+'-'+('control' if v=='base' else 'candidate'))/'build/compiler';args=['-O2','-march=znver5','--lanes','1','-w']
  if key=='lua-lvm':args+=['-g','--tier1','-std=gnu99','-DLUA_COMPAT_5_3','-DLUA_USE_LINUX','inputs/lua/lvm.c']
  elif key=='sqlite-O2':args+=['--tier1','-g','-O2','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION','inputs/sqlite3.c']
  else:args+=['--tier1','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION','inputs/sqlite3.c']
  with tempfile.TemporaryDirectory(dir='/dev/shm') as t:
   obj=Path(t)/'prog.o';subprocess.run(['bwrap','--ro-bind','/','/','--tmpfs','/home','--ro-bind',w,w,'--ro-bind','/home/david/.cache/buster','/home/david/.cache/buster','--ro-bind',src,dest,'--bind',t,t,'--chdir',dest,'--',exe,*args,'-c','-o',obj],env=env,check=True)
   digest=hashlib.file_digest(obj.open('rb'),'sha256').hexdigest();rows.append([key,v,dest,rec['9700x_object'],digest,rec['9700x_object']==digest]);print(name,rows[-1],flush=True)
 with (d/'directory-replay.tsv').open('w') as f:q=csv.writer(f,delimiter='\t',lineterminator='\n');q.writerow(['workload','compiler','replayed_directory','9700x_object_sha256','replay_sha256','identical']);q.writerows(rows)
