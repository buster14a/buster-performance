"""Compare the genuine object driver, final native columns and graph in fresh processes."""
from pathlib import Path
import csv,hashlib,os,subprocess,sys,tempfile,re
path=Path(__file__).resolve().parent
out=Path(sys.argv[1]).resolve();out.mkdir(exist_ok=True,parents=True)
cc=Path(sys.argv[2]).resolve();g=sys.argv[3]; flags=[];files=[];expect=False
for arg in sys.argv[4:]:
 if not expect and arg.endswith('.c'):files.append(arg)
 else:flags.append(arg)
 expect=arg in ('-I','-include','-isystem','--predefines')
assert files
switches='NODE_SOURCE_CONDITION_ONLY NODE_SPLICE_REPORT NODE_SPLICE_FRONT NODE_SPLICE_ENABLE NODE_PROOF_NO_FP NODE_PROOF_POINTERS NODE_PROOF_CALLS NODE_SOURCE_ROWS NODE_PROOF_NATIVE NODE_CROSS_TYPE_VIEW NODE_CROSS_INCREMENTAL NODE_CROSS_ARG_EPOCH NODE_CROSS_FAST_REQUEST NODE_SOURCE_STRINGS NODE_CROSS_UNINDEXED NODE_SOURCE_CONDITION NODE_SOURCE_CONDITION_ORIGINS NODE_SOURCE_ORIGIN_PUBLISHERS NODE_SOURCE_CONSUME_CONDITION NODE_SOURCE_CONSUME_BRANCH'.split()
options={k:'1' for k in switches};options['NODE_CROSS_CHUNK']='n'
observer=re.compile(rb'^(?:cross-(?:canonical|chunk|cost|keys|view) |node-proof |source-(?:conditions|rows) |splice-(?:taken|local-class): |(?:condition|branch|label|call)-taken )')
def digest(data):return hashlib.sha256(data).hexdigest()
def filehash(file):
 if not file.exists():return '-'
 with file.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
policies=[('default',[]),('debug',['-g']),('wall',['-Wall','-Wextra'])]
if os.environ.get('PHYSICAL_QUICK'):policies=policies[:2]
header=['mode','unit','same','takes','branches','branch_uses','call_rows','call_arguments','local_labels','status','ELF','native','graph','stdout','diagnostic']
with (out/(g+'.tsv')).open('w') as t,tempfile.TemporaryDirectory(dir=out) as scratch:
 tmp=Path(scratch);w=csv.writer(t,delimiter='\t',lineterminator='\n');w.writerow(header)
 for pol,extra in policies:
  for src in files:
   vals=[];logs=[]
   for enabled in False,True:
    suffix=str(int(enabled));elf=tmp/'unit.o';native=tmp/'native';graph=tmp/'graph'
    for f in elf,native,graph:f.unlink(missing_ok=True)
    env=dict(os.environ,NODE_SOURCE_NATIVE_ORACLE=str(native),NODE_SOURCE_GRAPH_ORACLE=str(graph))
    if enabled:env.update(options)
    res=subprocess.run([str(cc),'--lanes','1','-c',*flags,*extra,src,'-o',str(elf)],capture_output=True,env=env,timeout=120)
    diag=b''.join(l for l in res.stderr.splitlines(True) if not observer.match(l))
    vals.append((res.returncode,filehash(elf),filehash(native),filehash(graph),digest(res.stdout),digest(diag)))
    logs.append(diag)
   a,b=vals;tags=re.findall(rb'^branch-taken .*?branches=(\d+)',res.stderr,re.M)
   same=a==b;w.writerow([pol,src,int(same),res.stderr.count(b'condition-taken token='),len(tags),sum(int(k) for k in tags),sum(map(int,re.findall(rb"^call-taken .*?calls=(\d+)",res.stderr,re.M))),sum(map(int,re.findall(rb"^call-taken .*?arguments=(\d+)",res.stderr,re.M))),sum(map(int,re.findall(rb"^label-taken .*?labels=(\d+)",res.stderr,re.M))),*b])
   if not same:
    p=out/(g+'-'+Path(src).stem+'-'+pol+'.diff')
    if not p.exists():p.write_bytes(repr(vals).encode()+b'\n--- ordinary ---\n'+logs[0]+b'\n--- active ---\n'+logs[1])
    print('DIFF',g,src,pol, [header[9+i] for i,(x,y) in enumerate(zip(a,b)) if x!=y],flush=True)
  t.flush()
