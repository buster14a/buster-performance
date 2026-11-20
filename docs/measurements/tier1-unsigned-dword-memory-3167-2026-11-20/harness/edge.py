from pathlib import Path
import csv,hashlib,subprocess
p=Path(__file__).resolve().parent;w=p.parent;d=p/'edges';d.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';rows=[]
run=lambda *a,**kw:subprocess.run(list(map(str,a)),check=True,**kw)
run(cc,'-O2','-ffp-model=strict','-c',p/'boundary.c','-o',d/'oracle.o')
for arch,opts in [('x86-64',['-march=x86-64']),('v3',['-march=x86-64-v3']),('v4',['-march=x86-64-v4']),('no-f',['-march=x86-64-v4','-mno-avx512f']),('znver5',['-march=znver5'])]:
 for mode in ['default','post']:
  for v,c in [('clang',cc),('parent',w/'convert/build/compiler'),('candidate',w/'u32-memory/build/compiler')]:
   if v=='clang' and mode=='post':continue
   tag='-'.join([arch,mode,v]);o=d/(tag+'.o');e=d/tag
   args=['-ffp-model=strict'] if v=='clang' else ['--tier1','--verify','--lanes','1']+(['--tier1-schedule=post'] if mode=='post' else [])
   run(c,*args,*opts,'-O2','-c',p/'edges.c','-o',o);run(cc,'-no-pie',d/'oracle.o',o,'-o',e);answer=run(e,capture_output=True,text=True).stdout.strip();assert answer.startswith('262144 ')
   asm=run('objdump','-d','-Mintel','--no-show-raw-insn',o,capture_output=True,text=True).stdout;(d/(tag+'.asm')).write_text(asm);sites=[l.split(':',1)[-1].strip() for l in asm.splitlines() if 'vcvtusi2' in l and 'DWORD PTR' in l]
   if v=='candidate':assert bool(sites)==(arch in ['v4','znver5']),(tag,sites)
   rows.append([arch,mode,v,len(sites),hashlib.file_digest(o.open('rb'),'sha256').hexdigest(),answer]);print(tag,len(sites),answer,flush=True)
with (d/'results.tsv').open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['architecture','scheduler','compiler','evex_memory_sites','object_sha256','verified']);t.writerows(rows)
