from pathlib import Path
import csv,gzip,hashlib,json,lzma,os,re,shlex,subprocess,sys
st=Path(__file__).resolve().parent;w=st.parent;doc=w/'perf/docs/measurements/window-compile-2850-2026-11-21/4bd73ecaf'
sys.path.insert(0,str(doc));from reproduce import frozen_args,rows,sha,SQLITE_SHA
cc=w/'body-action-rows/build/compiler';prior=st/'reference/compiler';args=frozen_args(w/'switch-inputs/sqlite/sqlite3.c',w/'pregraph-warning-study/compiler-source');assert sha(w/'switch-inputs/sqlite/sqlite3.c')==SQLITE_SHA
clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
out=st/'oracle';out.mkdir(exist_ok=True);cdir=out/'cases';cdir.mkdir(exist_ok=True)
cases={'int':'int f(int a,int b){int c=a+b;return (c<b)+(a^b)+(a*3)+(a>>3)+(b!=0)+(b&5);}',
 'mixed':'unsigned long f(signed char a, unsigned b, int c, long d){return a+b+c+d+(b<c)+(c>=d);}',
 'scopes':'int f(int x){int y=x;{volatile int x=2;y+=x;}return (x+y)^(x-4);}',
 'known':'constexpr int a=12;int f(int b){int c=3+4;return b+c+(b%a);}',
 'constant':'_Static_assert(2*4==8, "eight");int f(int a){return (a + 0) < (3*4);}',
 'fp':'#pragma STDC FENV_ACCESS ON\nint f(int a,float b){return (a*2)+(b!=0)+(int)(b+2);}',
 'pointer':'int f(int *p,int *q,int i){return p==q || p+i<q || *(p+i)==4;}',
 'bad-operator':'struct S{int x;};int f(struct S a,int b){return a+b;}',
 'zero-div':'int f(int a){return a/0;}',
 'wide':'unsigned __int128 f(unsigned __int128 a,unsigned b){return a+b+(a<3);}',
 'atomic':'struct S{_Atomic(int) c;};int f(struct S*p,int x){return (p->c+3)^(x-5);}',
 'bitfield':'struct S{unsigned x:5;int z:11;};int f(struct S v,int b){return (v.z+b) | (v.x+b);}',
 'unevaluated':'int f(int x,int y){return (x || (++y&&x+y))+(int)sizeof(x+y);}',
 'invalid-shift':'enum{A=1<<-1};int f(int n){return n+A;}',
 'overflow':'int f(int x,int y){int r;return __builtin_add_overflow(x,y,&r)?-1:r;}',
 'assignment':'int f(int a,int b){return (a=3) + (b-=2);}'}
for name,src in cases.items():(cdir/(name+'.c')).write_text(src+'\n')
def command(exe,flags,tag,env):
 clean={k:v for k,v in os.environ.items() if not k.startswith(('BUSTER_CHECK_BODY_','BUSTER_CHECK_SOURCE_DECLARATIONS','BUSTER_BODY_'))};clean.update(env)
 dest=out/'probe.o';dest.unlink(missing_ok=True)
 r=subprocess.run([str(exe),'--lanes','1','-c',*map(str,flags),'-o',dest],env=clean,capture_output=True,timeout=150)
 for ext,data in [('stdout',r.stdout),('stderr',r.stderr)]:(out/f'{tag}.{ext}.gz').write_bytes(gzip.compress(data,mtime=0))
 return r,sha(dest) if dest.exists() else '-'
def labels(stderr,prefix):
 return {k:int(v) for line in stderr.decode().splitlines() if line.startswith(prefix+'\t') for col in line.split('\t')[1:] for k,v in [col.split('=',1)]}
def cpairs(s):
 return tuple((k,int(a),v) for k,(a,v) in sorted(s.items()))
source={'BUSTER_CHECK_BODY_SOURCE_ONLY':'1','BUSTER_CHECK_BODY_ADMIT_ALL':'1'};typed={'BUSTER_CHECK_BODY_ACTION_ROWS':'1'}
bad=[]
with (out/'comparisons.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('input','scope','parent-body-exit','baseline-body-exit','candidate-exit','whole-exit','parent-body-rows','whole-rows','candidate-rows','nodes','rows-vs-ordinary','rows-vs-prior-local','rows-vs-build-control','full-object-vs-prior'))
 for name,flags in list(args.items())+[(k,['-std=c23','-nostdinc',cdir/(k+'.c')]) for k in cases]:
  mainok=name in args
  m0,h0=command(prior,flags,name+'.normal-prior',{})
  m1,h1=command(cc,flags,name+'.normal-candidate',{})
  if mainok and (h0=='-' or h0!=h1 or (m0.returncode,m0.stdout,m0.stderr)!=(m1.returncode,m1.stdout,m1.stderr)):bad.append([name,'ordinary objects'])
  if not mainok:
   c=cdir/(name+'.c');cl=subprocess.run([clang,'-std=c23','-nostdinc','-Wall','-Wextra','-Werror','-fsyntax-only',c],capture_output=True);(out/(name+'.clang.stderr.gz')).write_bytes(gzip.compress(cl.stderr,mtime=0))
   observed=[]
   for label,bin in [('prior',prior),('changed',cc)]:
    o,h=command(bin,[*flags,'-Wall','-Wextra','-Werror','--dump-typed','--dump-static'],name+'.diagnostic-'+label,{})
    observed.append((o.returncode,o.stdout,o.stderr,h))
   if observed[0]!=observed[1] or (m0.returncode,m0.stdout,m0.stderr,h0)!=(m1.returncode,m1.stdout,m1.stderr,h1):bad.append([name,'normal diagnostics, dumps or object'])
  for sc in ('functions','declarations') if mainok else ('functions',):
   marker={'BUSTER_CHECK_SOURCE_DECLARATIONS':'1'} if sc=='declarations' else {}
   baseline,_=command(cc,flags,name+'.'+sc+'.baseline',marker|source)
   parent,_=command(prior,flags,name+'.'+sc+'.prior',marker|source)
   candidate,_=command(cc,flags,name+'.'+sc+'.candidate',marker|source|typed)
   genuine,_=command(cc,flags,name+'.'+sc+'.whole',marker|{'BUSTER_CHECK_BODY_WHOLE_FINGERPRINT':'1'})
   b=rows(baseline.stderr,'source');p=rows(parent.stderr,'source');c=rows(candidate.stderr,'source');g=rows(genuine.stderr,'whole')
   normal=c==g;reference=c==p;local=c==b
   def source_log(raw):
    # Pages and CPU-charge rows describe each allocation policy, independently from diagnostics.
    return [line for line in raw.splitlines() if not line.startswith((b'body-source-row\t',b'body-action-rows\t',b'body-source-pages\t',b'body-source-memory\t'))]
   if not (source_log(parent.stderr)==source_log(baseline.stderr)==source_log(candidate.stderr) and parent.returncode==baseline.returncode==candidate.returncode and parent.stdout==baseline.stdout==candidate.stdout):bad.append([name,sc,'source diagnostics'])
   if not (reference and local) or (mainok and (not normal or not c or candidate.returncode or parent.returncode)):bad.append([name,sc,'source',len(c),len(p),len(g)])
   if not local:
    deltas={k:(b.get(k),c.get(k)) for k in sorted(set(c)|set(b)) if b.get(k)!=c.get(k)};(out/f'{name}.{sc}.different.json').write_text(json.dumps(deltas,indent=2))
   t.writerow((name,sc,parent.returncode,baseline.returncode,candidate.returncode,genuine.returncode,len(p),len(g),len(c),sum(n for n,h in c.values()),int(normal),int(reference),int(local),int(h0==h1)))
   if mainok:
    old=doc/'oracle'/name/(sc+'.tsv.xz');seen={int(x['closing-token']):(int(x['nodes']),x['whole-fingerprint']) for x in csv.DictReader(lzma.decompress(old.read_bytes()).decode().splitlines(),delimiter='\t')}
    # The archived structural fingerprints provide a second independent ordinary reference on the exact frozen source.
    if c!=seen:bad.append([name,sc,'archived whole',sum(c.get(k)!=v for k,v in seen.items()),len(c),len(seen)])
    q=labels(candidate.stderr,'body-action-rows');print(name,sc,q,flush=True)
(out/'failures.json').write_text(json.dumps(bad,indent=2));print('oracle failures',bad);sys.exit(bool(bad))
