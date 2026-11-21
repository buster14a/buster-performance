"""Compare exact ordinary parent and option off/on statuses, diagnostics and entire ELF for the ordinary CLI."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import argparse,csv,subprocess,tempfile,os,sys,shlex,hashlib,resource
ap=argparse.ArgumentParser();ap.add_argument('cc',type=Path);ap.add_argument('parent',type=Path);ap.add_argument('out',type=Path);ap.add_argument('suite',choices=['tracked','frozen','generated']);ns=ap.parse_args()
d=Path(__file__).resolve().parent;w=d.parent;cc=ns.cc.resolve();parent=ns.parent.resolve();p=ns.out.resolve();p.mkdir(exist_ok=True);tree=w/'window-constants';source=w/'switch-inputs';fixtures=w/'pure-interior-study';hashf=lambda b:hashlib.sha256(b).hexdigest()
natives={'sqlite':[],'lua':[],'musl':[],'self':[]}
for corpus in ('sqlite','lua','musl'):
 nsargs=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$'+corpus+'_arguments"'],text=True,cwd=source));opts=[s for s in nsargs if not s.endswith('.c')]
 natives[corpus]=[(s,opts,source,corpus) for s in nsargs if s.endswith('.c')]
bs=w/'pregraph-warning-study/compiler-source';natives['self']=[(str(bs/'src/buster/compiler/main.c'),['-march=native','-I'+str(bs/'src'),'-fwrapv','-funsigned-char','--predefines',str(w/'proof-predefines.h')],source,'self')]
sets={
 'tracked':[(s,[],tree,'tracked') for s in subprocess.check_output(['git','ls-files','tests/*.c'],cwd=tree,text=True).splitlines()],
 'frozen':[l for k in natives.values() for l in k],
 'generated':[(str(s),[],tree,'adversarial') for s in sorted((fixtures/'2549fd7dd/matrix/inputs').glob('*.c'))]+[(str(s),[],tree,'random') for s in sorted((fixtures/'f5e195416/random/inputs').glob('*.c'))]+[(str(fixtures/s),[],tree,'focused') for s in ('fixture.c','mutation.c','warning.c')]
}
flags={'frozen':[[],['-g'],['-Wall','-Wextra'],['-Weverything']], 'tracked':[[],['-g','--poison-arenas'],['-Wall','-Wextra'],['-Weverything'],['--scalar'],['--deferred-bodies','--lanes','2'],['--attested=verify','--verify'],['--node-window-assignments','--node-window-constants'],['--node-window-constants','--node-window-assignments']], 'generated':[[],['-g'],['-Wall','-Wextra'],['-Weverything'],['-Werror','-Wall','-Wextra'],['-std=c23','-pedantic'],['-fwrapv','-fno-strict-overflow'],['--verify','--attested=verify']]}[ns.suite]
resource.setrlimit(resource.RLIMIT_CORE,(0,0))
def one(case):
 idx,(src,opts,cwd,corpus)=case;result=[];out=p/(str(idx)+'.o')
 for j,policy in enumerate(flags):
  values=[]
  for mode,exe in [('parent',parent),('plain',cc),('source',cc)]:
   out.unlink(missing_ok=True);f=policy.copy()
   if j>=7 and ns.suite=='tracked' and mode in ('parent','plain'): f=[x for x in f if x!='--node-window-constants']
   if mode=='source' and '--node-window-constants' not in f:f=['--node-window-constants',*f]
   proc=subprocess.run([exe,'--lanes','1',*f,'-c',*opts,src,'-o',out],cwd=cwd,capture_output=True)
   values.append([proc.returncode,hashf(proc.stderr),hashf(proc.stdout),hashf(out.read_bytes()) if out.exists() else ''])
   if mode=='parent' or values[0]!=values[-1]:(p/(str(idx)+'-'+str(j)+'-'+mode+'.err')).write_bytes(proc.stderr)
  equal=values[0]==values[1]==values[2]
  if equal:(p/(str(idx)+'-'+str(j)+'-parent.err')).unlink(missing_ok=True)
  result.append([corpus,src,j,*values[0],*values[1],*values[2],equal])
 out.unlink(missing_ok=True);return result
with ThreadPoolExecutor(max_workers=2) as pool,(p/(ns.suite+'.tsv')).open('w') as f:
 wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(['corpus','source','policy',*[m+'_'+k for m in ['parent','plain','option'] for k in ['status','diagnostics','stdout','elf']],'same'])
 for rows in pool.map(one,enumerate(sets[ns.suite])):wr.writerows(rows);f.flush()
