from pathlib import Path
import collections,gzip,re,sys,shlex,subprocess,hashlib,csv,os,json
d=Path(__file__).resolve().parent;cc=Path(sys.argv[1]).resolve();r=d/'a60859270/deletions';r.mkdir(exist_ok=True);w=d.parent;bs=w/'pregraph-warning-study/compiler-source';src=bs/'src/buster/compiler/main.c'
base=['--lanes','1','--dump-typed','-g','-c','-march=native','-fwrapv','-funsigned-char','-I'+str(bs/'src'),'--predefines',str(w/'proof-predefines.h'),src];paths=[]
for mode in ['plain','option']:
 f=r/(mode+'.rows');err=r/(mode+'.err');o=r/(mode+'.o');env=os.environ.copy();env['BUSTER_INTEGER_WINDOW_RECEIPT']='1'
 with f.open('wb') as out,err.open('wb') as e:q=subprocess.run([cc,*base,*(['--node-window-constants'] if mode=='option' else []),'-o',o],env=env,stdout=out,stderr=e)
 assert not q.returncode,(mode,err);paths.append(f)
pat=re.compile(rb'^(\d+) token=(\d+) op=(\d+) (.*)\n$')
def rows(p):
 with p.open('rb') as f:
  for l in f:
   m=pat.fullmatch(l);assert m,l[:100];yield int(m[1]),int(m[2]),int(m[3]),m[4]
claimed={int(r[1]):[int(i) for i in r] for r in re.findall(rb'^integer-window-receipt: token=(\d+) node=(\d+) removed=(\d+) first=(\d+) last=(\d+)',(r/'option.err').read_bytes(),re.M)}
old=rows(paths[0]);counts=collections.Counter();bad=[]
for i,t,o,v in rows(paths[1]):
 gone=[]
 for j,ot,oo,ov in old:
  if ot==t and ov==v and (o==oo or o==0 and oo in range(1,21)):break
  gone.append((j,ot,oo,ov[:160].decode()))
 else:raise ValueError('missing',i)
 row=claimed.get(i);predicted=row[2] if row is not None else 0;counts['true_removed']+=len(gone);counts['predicted']+=predicted;counts['roots']+=int(row is not None)
 if len(gone)!=predicted:bad.append({'node':i,'token':t,'op':o,'old_op':oo,'old_node':j,'receipt':row,'absent':gone})
assert not list(old)
(r/'mismatches.json').write_text(json.dumps({'totals':dict(counts),'differences':bad},indent=2)+'\n')
