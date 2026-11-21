import os,sys,hashlib,tempfile,subprocess,json
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
root=Path(os.environ['col_root'])
out=root/'reader-columns-final/corpus'
ccs=[root/d/'build/compiler' for d in ('reader-token-parent','reader-token-columns')]
group=sys.argv[1];opts=[];inputs=[]
for a in sys.argv[2:]:
    (inputs if a.endswith('.c') else opts).append(a)
def check(src):
    results=[]
    with tempfile.TemporaryDirectory(dir=out) as temp:
        obj=Path(temp)/'unit.o'
        for cc in ccs:
            obj.unlink(missing_ok=True)
            r=subprocess.run([cc,'-c',*opts,src,'-o',obj],capture_output=True,timeout=240)
            results.append((r.returncode,hashlib.sha256(r.stdout).hexdigest(),hashlib.sha256(r.stderr).hexdigest(),hashlib.sha256(obj.read_bytes()).hexdigest() if obj.is_file() else ''))
        return [src,*results,results[0]==results[1]]
with ThreadPoolExecutor(2) as pool:rows=list(pool.map(check,inputs))
(out/(group+'.json')).write_text(json.dumps(rows)+'\n')
print(group,len(rows),sum(bool(r[1][3]) for r in rows),sum(not r[-1] for r in rows),flush=True)
sys.exit(any(not r[-1] for r in rows))
