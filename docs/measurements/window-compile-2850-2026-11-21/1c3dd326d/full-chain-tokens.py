from pathlib import Path
import subprocess,sys,hashlib,re
exe,description,offset,scratch=sys.argv[1:5]
args=Path(description).read_bytes().split(b'\0');args=[a.decode() for a in args if a];sources=[a for a in args if a.endswith('.c')];flags=[a for a in args if not a.endswith('.c')]
for src in sources[int(offset):int(offset)+32]:
 dest=Path(scratch)/'unit.o';dest.unlink(missing_ok=True)
 t=subprocess.run([exe,'--lanes','1','--time-stages','-c',*flags,src,'-o',str(dest)],capture_output=True)
 if t.returncode:raise SystemExit(f'{src}: {t.returncode}: {t.stderr.decode(errors="replace")[-160:]}')
 counts=re.findall(rb'^time-process\ttokens\t(\d+)$',t.stderr,re.M);assert len(counts)==1, (src, t.stderr[-300:])
 print(Path(src).stem+'.o',int(counts[0]),dest.stat().st_size,hashlib.sha256(dest.read_bytes()).hexdigest(),sep='\t')
