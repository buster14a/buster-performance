from common import *
import csv,gzip,hashlib,json,shutil,subprocess,tempfile
subprocess.run(['python3',W/'source-counted-parent-study/ensure.py'],check=True)
out=D/'oracle';out.mkdir(exist_ok=True);raw=out/'streams';raw.mkdir(exist_ok=True);cases=out/'cases';cases.mkdir(exist_ok=True)
for fn in (W/'source-projected-members-study/oracle/cases' if (W/'source-projected-members-study/oracle/cases').exists() else W/'source-operand-proof-study/oracle/cases').glob('*.c'):shutil.copy(fn,cases/fn.name)
(cases/'observable.c').write_text('struct P{int a,b;};struct P g={2,3};int f(struct P*p,int x){return p->a*g.b+x;}\n')
def hashfile(path):
 with path.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def store(p):
 sha=hashfile(p);slot=raw/(sha+'.gz')
 if not slot.exists():
  with p.open('rb') as f, gzip.GzipFile(filename=str(slot),mode='wb',mtime=0) as g:shutil.copyfileobj(f,g,1024*1024)
 return sha
failures=[];old=[];historical=[]
with tempfile.TemporaryDirectory(dir=out) as td,(out/'comparisons.tsv').open('w',buffering=1) as f,(out/'admission.tsv').open('w',buffering=1) as af:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('input','policy','mode','same-ordinary','exit','ELF','stdout','stdout-bytes','stderr'))
 at=csv.writer(af,delimiter='\t',lineterminator='\n');at.writerow(('input','policy','mode','selected-summary','stdout-unchanged','ELF-unchanged'))
 td=Path(td);obj=td/'unit.o'
 def run(cc,flags,options,e):
  obj.unlink(missing_ok=True);o=td/'output';err=td/'errors'
  with o.open('wb') as fp,err.open('wb') as ep:r=subprocess.run([cc,'--lanes','1',*options,*flags,'-o',obj],cwd=ROOT,env=env|e,stdout=fp,stderr=ep,timeout=270)
  return (r.returncode,hashfile(obj) if obj.exists() else '-',store(o),o.stat().st_size,store(err))
 for name,flags in [*args.items(),*((p.stem,['-nostdinc','-std=c23',p]) for p in sorted(cases.glob('*.c')))]:
  real=name in args
  options=[('object',['-c']),('typed',['-c','--dump-typed']),('static',['-c','--dump-static']),('both',['-c','--dump-static','--dump-typed']),('strict',['-c','-Wall','-Wextra','-Werror','--dump-static','--dump-typed']),('syntax',['-fsyntax-only']),('attested',['-c','--attested=verify'])]
  for pol,opts in options:
   variants=[('prior-ordinary',PRIOR,{}),('prior-source',PRIOR,native),('corrected-ordinary',CC,{}),('corrected-source',CC,native)]
   rows={k:run(b,flags,opts,e) for k,b,e in variants}
   base=rows['prior-ordinary']
   for m,b,e in variants:
    val=rows[m];same=val==base;t.writerow((name,pol,m,int(same),*val))
    if m=='prior-source' and not same:old.append([name,pol])
    if m.startswith('corrected') and not same:failures.append([name,pol,m])
   if pol=='object' and real:
    for fn in [W/'source-typed-study'/(name+'.o'),W/'native-source-facts-study'/(name+'.cached.o')]:
     exp=hashfile(fn);historical.append([name,str(fn),exp,rows['corrected-source'][1],exp==rows['corrected-source'][1]])
   if (real or name=='observable') and pol in ['object','typed','static','both','attested']:
    result=run(CC,flags,opts,native|{'BUSTER_CONTROL_SOURCE_AUDIT':'1'})
    found=[x.strip() for x in (td/'errors').read_text().splitlines() if x.startswith('control-source-summary\t')]
    at.writerow((name,pol,'corrected-source',' '.join(found) or '-',int(result[2]==rows['corrected-source'][2]),int(result[1]==rows['corrected-source'][1])))
    if (pol=='object')!=bool(found) or result[1:4]!=rows['corrected-source'][1:4]:failures.append([name,pol,'audit admission'])
  print(name,'checked',len(failures),len(old),flush=True)
(out/'failures.json').write_text(json.dumps(failures,indent=2));(out/'prior-differences.json').write_text(json.dumps(old,indent=2));(out/'historical.json').write_text(json.dumps(historical,indent=2))
