from pathlib import Path
import subprocess,sys,hashlib,collections
p=Path(sys.argv[3]).resolve();p.mkdir(parents=True,exist_ok=True)
exe=Path(sys.argv[1]).resolve()
src=Path(sys.argv[2]).resolve()
flags=['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(src.parent)]
for i,policy in enumerate(([],['-Wall','-Wextra'],['-Weverything'],['-Wall','-Wextra','-Werror'])):
    rows=[]
    for j,params in enumerate(([],['--node-window'],['--node-window-assignments'])):
        path=p/f'output-{j}.o';path.unlink(missing_ok=True)
        run=subprocess.run([str(exe),*params,*flags,*policy,'-c',str(src),'-o',str(path)],capture_output=True)
        row=[run.returncode,run.stdout,run.stderr,path.read_bytes() if path.exists() else b'']
        rows.append(row)
    print(policy, [r[0] for r in rows], len(rows[0][2]),hashlib.sha256(rows[0][2]).hexdigest(),len(rows[0][3]),hashlib.sha256(rows[0][3]).hexdigest(),rows[0]==rows[1]==rows[2]); assert rows[0]==rows[1]==rows[2]
