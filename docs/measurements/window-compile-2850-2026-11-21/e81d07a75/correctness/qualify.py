"""Compare ordinary and compacted action readers on each actual compilation."""
from argparse import ArgumentParser
from pathlib import Path
import csv,hashlib,json,os,re,shlex,struct,subprocess,tempfile
from graph import compare
p=ArgumentParser();p.add_argument('compiler',type=Path);p.add_argument('output',type=Path)
p.add_argument('--policy',choices=['default','debug','wall','all','error','poison','twolanes','combined','scalar','verify','transitions','tier1'],default='default')
p.add_argument('corpora',nargs='+');ns=p.parse_args()
here=Path(__file__).resolve().parent
src=Path(os.environ["BUSTER_CORPUS_ROOT"]).resolve()
policy={'debug':['-g'],'wall':['-Wall','-Wextra'],'all':['-Weverything'],'error':['-Wall','-Wextra','-Werror'],'poison':['--poison-arenas'],'combined':['--node-window-assignments'],'scalar':['--scalar'],'verify':['--verify'],'transitions':['--check-transitions'],'tier1':['--tier1']}.get(ns.policy,[])
def argv(c):
 if c in ('sqlite','lua','musl'):
  s=subprocess.check_output(['bash','-c','source '+shlex.quote(str(here/'corpora.sh'))+'; printf %s "$'+c+'_arguments"'],cwd=src,text=True)
  return shlex.split(s)
 if c=='main':
  base=Path(os.environ["BUSTER_COMPILER_SOURCE"]).resolve()
  return ['-march=native','-I'+str(base/'src'),'-fwrapv','-funsigned-char','--predefines',str(here/'proof-predefines.h'),str(base/'src/buster/compiler/main.c')]
 return [str(here/(c+'.c'))]
def sha(data):return hashlib.sha256(data).hexdigest()
def nativecounts(file):
 pos=0;counts=[0]*5
 with open(file,'rb') as f:
  while h:=f.read(24):
   _,rows,locs,calls,args,sources=struct.unpack('<6I',h)
   for i,k in enumerate((1,rows,locs,calls,args)):counts[i]+=k
   f.seek(rows*(10+4*sources)+locs*2+calls*13+args,1)
  assert f.tell()==os.stat(file).st_size
 return counts
with tempfile.TemporaryDirectory() as d,ns.output.open('w',buffering=1) as out:
 d=Path(d);w=csv.writer(out,delimiter='\t',lineterminator='\n')
 w.writerow('corpus unit status same_status same_diag same_elf same_native calls removed old_graph new_graph old_types new_types edge_count argument_count graph_differences bodies rows locals abi_calls abi_arguments diagnostic_sha256 object_sha256 native_sha256 graph_details same_program_references reference_sha256'.split())
 for corpus in ns.corpora:
  a=argv(corpus);flags=[x for x in a if not x.endswith('.c')]
  for unit in [x for x in a if x.endswith('.c')]:
   raw=[]
   for mode in ('window','window-calls'):
    o=d/(mode+'.o');g=d/(mode+'.g');n=d/(mode+'.n');refs=d/(mode+'.r');log=d/(mode+'.log')
    for f in (o,g,n,refs):f.unlink(missing_ok=True)
    env=dict(os.environ,BUSTER_CALL_REFERENCES=str(refs),NODE_SOURCE_NATIVE_ORACLE=str(n),NODE_SOURCE_GRAPH_ORACLE=str(g),BUSTER_WINDOW_CALL_LOG='1')
    r=subprocess.run([ns.compiler.resolve(),'--lanes','2' if ns.policy=='twolanes' else '1','--node-'+mode,*policy,'-c',*flags,unit,'-o',o],env=env,capture_output=True)
    log.write_bytes(r.stderr)
    diag=b''.join(s for s in r.stderr.splitlines(keepends=True) if not s.startswith(b'plain-call:'))
    raw.append((r.returncode,sha(r.stdout+diag),sha(o.read_bytes()) if o.exists() else '-',sha(n.read_bytes()) if n.exists() else '-',sha(refs.read_bytes()) if refs.exists() else '-'))
   g0=d/'window.g';g1=d/'window-calls.g';n1=d/'window-calls.n'
   admissions=(d/'window-calls.log').read_bytes().count(b'plain-call:');err={}
   if g0.exists() and g1.exists() and admissions:
    try:
     report=compare(g0,g1,d/'window-calls.log');err={k:v for k,v in report['stats'].items() if k.startswith('bad')}
     h=list(map(report.get,['calls','removed','ordinary','compacted','old_types','new_types']))+[report['stats'].get('edges',0),report['stats'].get('arguments',0)]
     if report['old_types']!=report['new_types']:err['type_count']=1
     if err:err['first']=report['samples']
    except Exception as e:h=[admissions]+[-1]*7;err={'exception':repr(e)}
   elif g0.exists() and g1.exists():
    h0=struct.unpack('<6I',g0.open('rb').read(24));h1=struct.unpack('<6I',g1.open('rb').read(24))
    h=[0,0,h0[0],h1[0],h0[-1],h1[-1],0,h0[1]]
    if g0.read_bytes()!=g1.read_bytes():err={'unexpected_graph_change':1}
   else:
    h=[admissions]+[0]*7
    if g0.exists()!=g1.exists() or admissions or raw[1][0]==0:err={'missing_graph_witness':1}
   w.writerow([corpus,Path(unit).name,raw[0][0],*[int(x==y) for x,y in zip(raw[0][:4],raw[1][:4])],*h,int(bool(err)),*(nativecounts(n1) if n1.exists() else [0]*5),*raw[1][1:4],json.dumps(err,sort_keys=True),int(raw[0][4]==raw[1][4]),raw[1][4]])
