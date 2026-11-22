from common import *
import csv,gzip,hashlib,json,re,shutil,subprocess
out=D/'oracle';out.mkdir(exist_ok=True);(out/'cases').mkdir(exist_ok=True);streams=out/'streams';streams.mkdir(exist_ok=True)
for f in (W/'ordinary-store-transfers-study/source-oracle/cases').glob('*.c'):
 shutil.copy(f,out/'cases'/f.name)
(out/'cases/chain.c').write_text('int f(int a,int b,int c,short d){return ((((a+b) ^ (b-c))*(int)d) + (a<=b)) != ((c & (a-b)) + (c||d));}\n')
(out/'cases/inherited-fault.c').write_text('int f(int a){return ((1<<-2)+a) ^ ((1/0) | a);}\n')
(out/'cases/shape-attribute.c').write_text('typedef int Aligned __attribute__((aligned(16))); int f(Aligned *p,int q){volatile int v=*p;return (v+q)+(*p>q);}\n')
(out/'cases/short-circuit.c').write_text('int f(int x,int y){return (0 && (x/y)) + (1 || ++x) + (x&&y) + (!x||y);}\n')
(out/'cases/negative-source.c').write_text('struct S{int a;}; int f(struct S a,int b){return (b+1)+(a+b);}\n')
def sha(raw):return hashlib.sha256(raw).hexdigest()
def retain(raw):
 h=sha(raw);p=streams/(h+'.gz')
 if not p.exists():p.write_bytes(gzip.compress(raw,mtime=0))
 return h
def run(cc,flags,opts,extra):
 ob=out/'unit.o';ob.unlink(missing_ok=True);r=subprocess.run([cc,'--lanes','1','-c',*opts,*flags,'-o',ob],env=env|extra,cwd=ROOT,capture_output=True,timeout=270)
 return ((r.returncode,retain(r.stdout),retain(r.stderr),sha(ob.read_bytes()) if ob.exists() else '-'),r.stderr)
def stats(raw):
 rows=[];cs=[]
 for l in raw.decode().splitlines():
  if l.startswith('source-arithmetic\t'):rows.append(dict((k,int(v)) for f in l.split('\t')[1:] for k,v in [f.split('=',1)]))
  if l.startswith('control-source-summary\t'):cs.append(l)
 return rows,cs
fail=[];coverage=[];historic=[];previous=[];clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
with (out/'native.tsv').open('w',buffering=1) as nf,(out/'checked.tsv').open('w',buffering=1) as ff:
 nt=csv.writer(nf,delimiter='\t',lineterminator='\n');nt.writerow(('input','policy','mode','exit','stdout','stderr','ELF','same-ordinary','same-source-base'))
 ft=csv.writer(ff,delimiter='\t',lineterminator='\n');ft.writerow(('input','scope','mode','exit','rows','nodes','matches-prior-source','matches-current-whole','matches-current-source','stdout-sha','stderr-sha'))
 for name,flags in list(args.items())+[(p.stem,['-std=c23','-nostdinc',p]) for p in sorted((out/'cases').glob('*.c'))]:
  real=name in args;policies=[('default',[]),('wall',['-Wall','-Wextra']),('werror',['-Wall','-Wextra','-Werror'])]
  if not real:policies += [('dumps',['--dump-typed','--dump-static'])]
  if not real:
   c=subprocess.run([clang,'-std=c23','-nostdinc','-Wall','-Wextra','-Werror','-fsyntax-only',flags[-1]],capture_output=True);(out/(name+'.clang.stderr.gz')).write_bytes(gzip.compress(c.stderr,mtime=0))
  for policy,options in policies:
   variants=[('prior-ordinary',PRIOR,{}),('prior-source',PRIOR,native),('ordinary',CC,{}),('source-control',CC,native),('source-producer',CC,native|producer)]
   if policy!='default' and real:variants=[('ordinary',CC,{}),('source-control',CC,native),('source-producer',CC,native|producer)]
   rr={key:run(bin,flags,options,x)[0] for key,bin,x in variants}
   for key,bin,x in variants:
    v=rr[key];nt.writerow((name,policy,key,*v,int(v==rr['ordinary']),int(v==rr['source-control'])))
   if rr['source-control']!=rr['source-producer']:fail.append([name,policy,'source native differs'])
   if 'prior-source' in rr and (rr['prior-source']!=rr['source-control'] or rr['prior-ordinary']!=rr['ordinary']):fail.append([name,policy,'previous executable'])
   if rr['ordinary']!=rr['source-control']:previous.append([name,policy,'source vs ordinary before arithmetic'])
   if real and policy=='default':
    for k,f in [('ordinary',W/'source-typed-study'/(name+'.o')),('source',W/'native-source-facts-study'/(name+'.cached.o'))]:
     expected=sha(f.read_bytes());ok=expected==rr['source-producer'][3];historic.append([name,k,expected,rr['source-producer'][3],int(ok)])
     if not ok:fail.append([name,k,'frozen ELF'])
    rc,raw=run(CC,flags,[],native|producer|audit);(out/(name+'.live-source.stderr.gz')).write_bytes(gzip.compress(raw,mtime=0))
    seen,cs=stats(raw);coverage.extend([[name,'native',r] for r in seen]);print(name,'live',cs, {k:sum(r[k] for r in seen) for k in ('nodes','leaves','candidates','proofs','chains','taken')},flush=True)
    if rc[0]!=0 or rc[3]!=rr['source-producer'][3] or not seen:fail.append([name,'live-source audit'])
  for sc in ('functions','declarations') if real else ('functions',):
   marker={'BUSTER_CHECK_SOURCE_DECLARATIONS':'1'} if sc=='declarations' else {}
   compare=[('prior-source',PRIOR,local,'source'),('source-control',CC,local,'source'),('source-producer',CC,local|producer|{'BUSTER_SOURCE_ARITHMETIC_AUDIT':'1'},'source'),('ordinary-whole',CC,{'BUSTER_CHECK_BODY_WHOLE_FINGERPRINT':'1'},'whole')]
   res={};fs={}
   for key,b,x,tag in compare:
    info,raw=run(b,flags,[],marker|x);res[key]=info;fs[key]=fingerprints(raw,tag)
    if key=='source-producer' and real:
     rows,cs=stats(raw);coverage.extend([[name,sc,r] for r in rows])
   for key,b,x,tag in compare:
    v=fs[key];ft.writerow((name,sc,key,res[key][0],len(v),sum(n for n,h in v.values()),int(v==fs['prior-source']),int(v==fs['ordinary-whole']),int(v==fs['source-control']),res[key][1],res[key][2]))
   if fs['source-producer']!=fs['source-control'] or fs['source-control']!=fs['prior-source'] or res['source-control'][0]!=res['source-producer'][0]:
    fail.append([name,sc,'checked output']);(out/(name+'.'+sc+'.differences.json')).write_text(json.dumps({k:(fs['source-control'].get(k),fs['source-producer'].get(k)) for k in set(fs['source-control'])|set(fs['source-producer']) if fs['source-control'].get(k)!=fs['source-producer'].get(k)},indent=2))
   if real and fs['source-control']!=fs['ordinary-whole']:previous.append([name,sc,'existing source vs whole',len(fs['source-control']),len(fs['ordinary-whole'])])
(out/'failures.json').write_text(json.dumps(fail,indent=2));(out/'previous.json').write_text(json.dumps(previous,indent=2));(out/'historical-elf.json').write_text(json.dumps(historic,indent=2))
with (out/'coverage.tsv').open('w') as fp:
 t=csv.writer(fp,delimiter='\t',lineterminator='\n');cols=['close','nodes','leaves','candidates','proofs','chains','taken'];t.writerow(['input','scope',*cols]);t.writerows([name,scope,*[r[k] for k in cols]] for name,scope,r in coverage)
print('difference',fail,'previous',previous,flush=True)

for extra in ('live.py','mutation.py'):
 with (D/(extra+'.log')).open('w') as fp:
  res=subprocess.run(['python3',str(D/extra)],stdout=fp,stderr=subprocess.STDOUT)
  if res.returncode:print(extra,'exit',res.returncode,flush=True)
