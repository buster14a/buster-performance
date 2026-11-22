from pathlib import Path
import hashlib, subprocess,csv,os
p=Path(__file__).resolve().parent
cases=[['--dump-typed'],['--dump-static'],['--verify'],['--dump-check'],['-g','-c'],['-S'],['-g','-S'],['-fsyntax-only'],['-c'],['--node-window','-c']]
with (p/'observables.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t');w.writerow(['mode','ordinary-exit','chains-exit','stdout-bytes','stderr-bytes','output-bytes','identical'])
 for opts in cases:
  results=[]
  for cc,env in [(p.parent/'main-fbef-clean/build/compiler',{}),(p/'compiler-7844b9bd3',{'BUSTER_CONTROL_MEMBER_OPERANDS':'1','BUSTER_CHAIN_POISON':'1'})]:
   dest=p/'observed.o';dest.unlink(missing_ok=True)
   r=subprocess.run([cc,*opts,'probe.c','-o',dest],cwd=p,capture_output=True,env=os.environ|env)
   results.append((r.returncode,r.stdout,r.stderr,dest.read_bytes() if dest.exists() else b''))
  a,b=results
  w.writerow([' '.join(opts),a[0],b[0],len(a[1]),len(a[2]),len(a[3]),int(a==b)])
