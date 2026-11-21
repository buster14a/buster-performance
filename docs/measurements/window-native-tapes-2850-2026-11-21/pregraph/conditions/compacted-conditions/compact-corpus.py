from pathlib import Path
import csv,hashlib,json,os,re,subprocess,sys,tempfile
out,cc,g=Path(sys.argv[1]).resolve(),Path(sys.argv[2]).resolve(),sys.argv[3];out.mkdir(exist_ok=True,parents=True)
base=Path(__file__).resolve().parent
sw=re.search(r'^switches=\((.*?)\)$',(base/'compact-conditions.sh').read_text(),re.M)[1]
opt={k:v for k,v in [i.split('=',1) for i in sw.split()]};opts=dict(opt,NODE_SOURCE_COMPACT='1',NODE_SOURCE_COMPACT_REPORT='1',NODE_SOURCE_COMPACT_CONDITION='1',NODE_SOURCE_COMPACT_READ_CONDITION='1')
flags=[];sources=[];arg=False
for z in sys.argv[4:]:
 if z.endswith('.c') and not arg:sources.append(z)
 else:flags.append(z)
 arg=z in ['--predefines','-include','-I','-isystem']
observer=re.compile(rb'^(?:cross-(?:canonical|chunk|cost|keys|view) |node-proof |source-(?:conditions|rows) |splice-(?:taken|local-class): |(?:condition|branch|label|call)-taken |compact-(?:consumed|taken): )')
def h(f):
 if not f.exists():return '-'
 with f.open('rb') as b:return hashlib.file_digest(b,'sha256').hexdigest()
with (out/(g+'.tsv')).open('w',buffering=1) as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['unit','policy','same','status','taken','removed','consumed','outside_source_only','changed_graph','elf','native','diag','surviving','edges'])
 for p,extra in [('ordinary',[]),('debug',['-g']),('wall',['-Wall','-Wextra'])]:
  for src in sources:
   with tempfile.TemporaryDirectory(dir=out) as temp:
    d=Path(temp);data={};logs={}
    for mode,options in [('source',opt),('compact',opts)]:
     e=dict(os.environ,**options,NODE_SOURCE_NATIVE_ORACLE=str(d/(mode+'.native')),NODE_SOURCE_GRAPH_ORACLE=str(d/(mode+'.bin')))
     r=subprocess.run([str(cc),'--lanes','1','-c',*flags,*extra,src,'-o',str(d/(mode+'.o'))],env=e,capture_output=True,timeout=120)
     err=r.stderr;(d/(mode+'.err')).write_bytes(err);logs[mode]=err
     data[mode]=(r.returncode,h(d/(mode+'.o')),h(d/(mode+'.native')),hashlib.sha256(b''.join(l for l in err.splitlines(True) if not observer.match(l))).hexdigest(),hashlib.sha256(r.stdout).hexdigest())
    a,b=data.values();same=a==b and b[0]==0;changed=h(d/'source.bin')!=h(d/'compact.bin')
    taken=len(re.findall(rb'^compact-taken:',logs['compact'],re.M));consumed=len(re.findall(rb'^compact-consumed:',logs['compact'],re.M))
    j={}
    graph_result=None
    if changed or taken:
     graph_result=subprocess.run([sys.executable,str(base.parent/'source-graph-study/graph_check.py'),str(d),'source','compact','source'],capture_output=True)
     try:j=json.loads(graph_result.stdout)
     except ValueError:pass
     source_taken=set(re.findall(rb'^splice-taken: token=(\d+)',logs['source'],re.M))
     compact_taken=set(re.findall(rb'^compact-taken: token=(\d+)',logs['compact'],re.M))
     actually_used=set(re.findall(rb'^compact-consumed: token=(\d+)',logs['compact'],re.M))
     same=same and graph_result.returncode==0 and j.get('extra_native')=='no' and actually_used==source_taken & compact_taken
    w.writerow([src,p,int(same),b[0],taken,j.get('removed',0),consumed,j.get('outside_ordinary_native_roots',0),int(changed),b[1],b[2],b[3],j.get('retained',''),j.get('fallback_edges','')])
    if not same:
     dest=out/(g+'-'+p+'-'+Path(src).name+'.diff');dest.write_bytes(repr(data).encode()+b'\n'+(graph_result.stdout+graph_result.stderr if graph_result else b'')+b''.join(l for l in logs['compact'].splitlines(True) if not observer.match(l))[:16000])
