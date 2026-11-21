"""Measure production admissions and the frozen denominator per source file."""
from pathlib import Path
import csv,hashlib,re,subprocess,sys
exe,response,offset,count,outdir=sys.argv[1:]
args=[x.decode() for x in Path(response).read_bytes().split(b'\0') if x];options=[x for x in args if not x.endswith('.c')];sources=[x for x in args if x.endswith('.c')];w=csv.writer(sys.stdout,delimiter='\t',lineterminator='\n');out=Path(outdir)/'unit.o'
for src in sources[int(offset):int(offset)+int(count)]:
 out.unlink(missing_ok=True)
 result=subprocess.run([exe,'--time-stages','--node-window-constants','--lanes','1','-c',*options,src,'-o',str(out)],capture_output=True)
 assert result.returncode==0 and out.is_file() and not result.stdout,(src,result.returncode)
 t=int(re.search(rb'^time-process\ttokens\t(\d+)$',result.stderr,re.M)[1]);hit=re.search(rb'^constant-window: roots=(\d+) removed=(\d+) graph-nodes=(\d+)$',result.stderr,re.M)
 if hit:a,b,g=map(int,hit.groups())
 else:
  assert t==0,(src,t);a=b=g=0
 blob=out.read_bytes();w.writerow([Path(src).stem+'.o',t,a,b,g,len(blob),hashlib.sha256(blob).hexdigest()])
