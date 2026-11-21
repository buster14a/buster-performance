from pathlib import Path
import array,csv,hashlib,os,subprocess,shlex,tempfile
from collections import Counter
from itertools import groupby
d=Path(__file__).resolve().parent
parent=Path(os.environ['BUSTER_COMPILER_SOURCE'])
os.environ['BUSTER_CHECK_DIR']=str(d)
def args(c):
 if c in ('sqlite','lua','musl'):
  aa=shlex.split(subprocess.check_output(['bash','-c','source "$BUSTER_CHECK_DIR/corpora.sh"; printf %s "$'+c+'_arguments"'],cwd=Path(os.environ['BUSTER_CORPUS_DIR']),text=True))
  if c=='lua': aa=[x for x in aa if not x.endswith('.c') or x.endswith('/lvm.c')]
  if c=='musl': aa=[x for x in aa if not x.endswith('.c') or x.endswith('/malloc/lite_malloc.c')]
  return ['--predefines',d/'proof-predefines.h',*aa]
 return ['-march=native','-I'+str(parent/'src'),'-fwrapv','-funsigned-char','--predefines',d/'proof-predefines.h',parent/'src/buster/compiler/main.c']
def compile_one(cc,aa,o,env):
 o.unlink(missing_ok=True)
 p=subprocess.run([cc,'--lanes','1','-c',*aa,'-o',o],env=env,capture_output=True)
 return p.returncode,p.stdout,p.stderr,hashlib.file_digest(o.open('rb'),'sha256').hexdigest() if o.exists() else '-'
def digest(name,values):
 return [name,*list(values)]
def measure(c,trace):
 words=array.array('I');words.frombytes(trace.read_bytes());head=words[:11];size=head[1];assert 11+16*size==len(words),(size,len(words));raw=memoryview(words)[11:];op=raw[::16];shape=raw[2::16];simple=[z==31 for z in shape];value=head[9];conv=head[10]
 counters=Counter();distribution=[];windows=[];ops=Counter()
 for i in range(size):
  row=raw[i*16:i*16+16];o,slot,s,typ,flags,cat,const,payload,*cs=row
  cs=cs[:3]+cs[6:7]+cs[3:6]+cs[7:8];active=sum((bool(x or y)<<b) for b,(x,y) in enumerate(zip(cs[0:4],cs[4:8])))
  ops[(o,active)]+=1
  for key,yes in [('all',True),('leaf',o==value),('converts',o==conv),('compact_record',s&1),('valid_record',s&2),('without_wide_value',s&4),('zero_integer',s&8),('no_overload',s&16),('simple',s==31),('only_low_integer',s==23),('stream_payload',payload),('leaf_stream_payload',payload and o==value),('convert_after_leaf',o==conv and i and op[i-1]==value),('simple_leaf_only_self_conversion',s==31 and cs==[typ,0,0,0,0,0,0,0]),('leaf_only_self_conversion',o==value and cs==[typ,0,0,0,0,0,0,0]),('nonleaf_only_op0',o!=value and active==1),('nonleaf_0_or_1',o!=value and active<=1)]:
   if yes:counters[key]+=1
 for name,bits in [('any_value',(o==value for o in op)),('simple',iter(simple))]:
  runs=Counter(sum(1 for _ in g) for yes,g in groupby(bits) if yes)
  distribution.extend([c,name,length,n] for length,n in sorted(runs.items()))
  for n in (2,4,8,16):
   counters[name+'_run_nodes_ge_'+str(n)]=sum(k*v for k,v in runs.items() if k>=n)
 for width in (16,64):
  blocks=Counter(sum(simple[i:i+width]) for i in range(0,size,width))
  windows.extend([c,width,n,k] for n,k in sorted(blocks.items()))
 return counters,distribution,windows,ops,head
if __name__=='__main__':
 with tempfile.TemporaryDirectory() as tmp:
  tables=[('summary',['case','metric','count']),('runs',['case','population','length','runs']),('windows',['case','width','simple_nodes','blocks']),('conversions',['case','op','active_mask','nodes']),('units',['case','nodes','leaves','overloads','fresh','dense','regions','level_order','transitions','object_sha256'])]
  files=[(d/(n+'.tsv')).open('w',buffering=1) for n,_ in tables];w=[csv.writer(f,delimiter='\t',lineterminator='\n') for f in files]
  for writer,(_,hdr) in zip(w,tables):writer.writerow(hdr)
  for c in ('sqlite','lua','musl','self'):
   o=Path(tmp)/'out.o';tr=Path(tmp)/'trace';tr.unlink(missing_ok=True);aa=args(c);e=compile_one(d/'base',aa,o,os.environ);r=compile_one(d/'census',aa,o,dict(os.environ,BUSTER_CHECK_LEAF_CENSUS=str(tr)));assert e==r and e[0]==0,(c,e[:3],r[:3]);m,a,b,ops,head=measure(c,tr);w[0].writerows([c,k,v] for k,v in sorted(m.items()));w[1].writerows(a);w[2].writerows(b);w[3].writerows([c,k,v,n] for (k,v),n in sorted(ops.items()));w[4].writerow([c,*head[1:9],e[-1]])
