from pathlib import Path
import csv,hashlib,os,itertools,shutil,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parent;tree=sys.argv[1];v=w/(tree+'-evidence');out=p/(tree+'-objects');out.mkdir(exist_ok=True);env=dict(os.environ,SOURCE_DATE_EPOCH='1792454400');cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,env=env,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
rows=[];oracle=[]
for arch,schedule in itertools.product(['x86-64','x86-64-v3','znver5'],['default','post']):
 baseargs=['--tier1','--lanes','1','-O2','-march='+arch]+(['--tier1-schedule=post'] if schedule=='post' else [])
 for vname,c in [('before',p/(tree+'-before-cost')),('after',w/tree/'build/compiler')]:
  for name,src,flags in [('leaves',v/'leaves.c',[]),('default',v/'kernels/kernels.c',[]),('unroll',v/'kernels/kernels.c',['--tier1-passes=+unroll'])]:
   o=out/f'{arch}-{schedule}-{vname}-{name}.o';leaf_flags=['-ffp-contract=on'] if tree=='fma' and name=='leaves' else [];run(c,*baseargs,*leaf_flags,*flags,'-c',src.relative_to(v),'-o',o,cwd=v);previous=v/'programs'/f'head-{arch}-{name}.o';reference=sha(previous) if schedule=='default' and previous.exists() else '';rows.append([arch,schedule,vname,name,sha(o),reference])
   if reference:assert sha(o)==reference,(o,reference)
   if name=='leaves' and (tree!='fma' or arch!='x86-64'):
    e=o.with_suffix('');dr=v/('rounding.o' if tree=='convert' else 'oracle.o');run(cc,'-no-pie',dr,o,'-lm','-o',e);r=run(e,capture_output=True,text=True);oracle.append([arch,schedule,vname,sha(e),r.stdout.strip()]);assert r.stdout.strip()
with (out/'objects.tsv').open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['architecture','scheduling','compiler','unit','sha256','original_measured_kernel_sha256']);t.writerows(rows)
with (out/'oracles.tsv').open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['architecture','scheduling','compiler','exe_sha256','output']);t.writerows(oracle)
for a,b in itertools.product(['x86-64','x86-64-v3','znver5'],['default','post']):
 xs=[o[-1] for o in oracle if o[:2]==[a,b]];assert (tree=='fma' and a=='x86-64' and not xs) or len(set(xs))==1
