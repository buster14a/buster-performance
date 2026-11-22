from common import *
import collections,csv,gzip,hashlib,json,subprocess
out=D/'live';out.mkdir(exist_ok=True);bad=[]
def get(bin,flags,k,config):
 obj=out/'unit.o';obj.unlink(missing_ok=True);r=subprocess.run([bin,'--lanes','1','-c',*flags,'-o',obj],cwd=ROOT,capture_output=True,env=env|config,timeout=300)
 (out/(k+'.stderr.gz')).write_bytes(gzip.compress(r.stderr,mtime=0));(out/(k+'.stdout.gz')).write_bytes(gzip.compress(r.stdout,mtime=0))
 return r.returncode, hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '-',r.stderr
def rows(raw,tag):
 out=collections.defaultdict(list)
 for l in raw.decode().splitlines():
  if l.startswith('body-'+tag+'-row\t'):
   _,k,n,h=l.split('\t');out[int(k)].append((int(n),h))
 return out
with (out/'comparisons.tsv').open('w') as fp:
 t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(('input','whole-functions','live-attempts','distinct-functions','producer-vs-live-control-differences','live-control-vs-whole-differences','ELF-unchanged','producer-exit'))
 for name,flags in args.items():
  source={'BUSTER_SOURCE_ARITHMETIC_FIELDS':'1','BUSTER_CONTROL_SOURCE_AUDIT':'1'}
  baseline,bh,raw=get(CC,flags,name+'.native-control',native|source);b=rows(raw,'source')
  rc,h,raw=get(CC,flags,name+'.native-arithmetic',native|source|producer);a=rows(raw,'source')
  c,_,raw=get(PRIOR,flags,name+'.ordinary-whole',{'BUSTER_CHECK_BODY_WHOLE_FINGERPRINT':'1'});g=rows(raw,'whole')
  mism=sum(a.get(k)!=b.get(k) for k in set(a)|set(b));prior=sum(1 for k,vals in b.items() for item in vals if item not in g.get(k,[]))
  expected=hashlib.sha256((W/'source-typed-study'/(name+'.o')).read_bytes()).hexdigest();t.writerow((name,len(g),sum(map(len,a.values())),len(a),mism,prior,int(h==bh==expected),rc))
  if not a or mism or h!=bh or h!=expected or rc or baseline:bad.append([name,'live-control',mism,rc])
  if prior:(out/(name+'.whole-deltas.tsv')).write_text(''.join(f'{k}\t{n}\t{v}\t{g.get(k)}\n' for k,vals in b.items() for n,v in vals if (n,v) not in g.get(k,[])))
(out/'failures.json').write_text(json.dumps(bad,indent=2));print('live',bad)
