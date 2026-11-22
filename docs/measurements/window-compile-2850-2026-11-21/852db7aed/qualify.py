from pathlib import Path
import csv, gzip, hashlib, json, lzma, os, subprocess, sys
st=Path(__file__).resolve().parent
w=st.parent;doc=w/'perf/docs/measurements/window-compile-2850-2026-11-21/4bd73ecaf'
sys.path.insert(0,str(doc));from reproduce import frozen_args, rows
cc=w/'ordinary-action-transfers/build/compiler'; prior=w/'body-action-rows-study/reference/compiler'
out=st/'oracle';out.mkdir(exist_ok=True);streams=out/'streams';streams.mkdir(exist_ok=True)
args=frozen_args(w/'switch-inputs/sqlite/sqlite3.c',w/'pregraph-warning-study/compiler-source')
cases=w/'body-action-transfers-study/oracle/cases'
assert (cases/'integer-matrix.c').exists()
def digest(raw):return hashlib.sha256(raw).hexdigest()
def observe(raw):
 h=digest(raw);p=streams/(h+'.gz')
 if not p.exists():p.write_bytes(gzip.compress(raw,mtime=0))
 return h
base_env={k:v for k,v in os.environ.items() if not k.startswith(('BUSTER_CHECK_ORDINARY_ACTION','BUSTER_CHECK_BODY_','BUSTER_BODY_'))}
def call(exe,name,flags,opts,env=None):
 obj=out/'unit.o';obj.unlink(missing_ok=True)
 r=subprocess.run([exe,'--lanes','1','-c',*opts,*flags,'-o',obj],env=base_env|(env or {}),capture_output=True,timeout=210)
 return [r.returncode,observe(r.stdout),observe(r.stderr),digest(obj.read_bytes()) if obj.exists() else '-']
fail=[]
policies=[('default',[]),('wall',['-Wall','-Wextra']),('werror',['-Wall','-Wextra','-Werror'])]
with (out/'comparisons.tsv').open('w',buffering=1) as fp:
 t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['input','policy','mode','exit','stdout','stderr','object','matches-prior'])
 for name,flags in list(args.items())+[(p.stem,['-std=c23','-nostdinc',p]) for p in sorted(cases.glob('*.c'))]:
  real=name in args;tests=policies if real else policies+[('dumps',['--dump-static','--dump-typed'])]
  for mode,opts in tests:
   control=call(prior,name,flags,opts);local=call(cc,name,flags,opts);trial=call(cc,name,flags,opts,{'BUSTER_CHECK_ORDINARY_ACTION_ROWS':'1'})
   for label,v in [('prior',control),('same-binary',local),('candidate',trial)]:
    t.writerow([name,mode,label,*v,int(v==control)])
   if control!=local or control!=trial:fail.append([name,mode,'streams or native object'])
  if real:
   for scope in ('functions','declarations'):
    env={'BUSTER_CHECK_BODY_WHOLE_FINGERPRINT':'1','BUSTER_CHECK_ORDINARY_ACTION_ROWS':'1','BUSTER_CHECK_ORDINARY_ACTION_RECEIPT':'1'}
    if scope=='declarations':env['BUSTER_CHECK_SOURCE_DECLARATIONS']='1'
    probe=call(cc,name,flags,[],env);raw=gzip.decompress((streams/(probe[2]+'.gz')).read_bytes());(out/(name+'.'+scope+'.rows.gz')).write_bytes(gzip.compress(raw,mtime=0))
    found=rows(raw,'whole');archived={int(x['closing-token']):(int(x['nodes']),x['whole-fingerprint']) for x in csv.DictReader(lzma.decompress((doc/'oracle'/name/(scope+'.tsv.xz')).read_bytes()).decode().splitlines(),delimiter='\t')}
    count=next((x for x in raw.decode().splitlines() if x.startswith('ordinary-action-rows\t')),None)
    print(name,scope,len(found),int(found==archived),count,flush=True)
    if found!=archived or count is None or probe[0]:fail.append([name,scope,'whole checked rows',len(found),len(archived)])
(out/'failures.json').write_text(json.dumps(fail,indent=2))
print('qualification differences',fail,flush=True)
