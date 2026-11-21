from pathlib import Path
import subprocess,sys,os,tempfile,hashlib,csv
d=Path(os.environ.get('BUSTER_EVIDENCE_OUT',Path(__file__).resolve().parent)).resolve();d.mkdir(exist_ok=True)
cc=Path(sys.argv[1]).resolve(); tag=sys.argv[2]
attrs={'plain':'', 'deprecated':'deprecated("obsolete")', 'unavailable':'unavailable("blocked")', 'returns_twice':'returns_twice','noinline':'noinline','always_inline':'always_inline','visibility':'visibility("hidden")','msabi':'ms_abi','sysv':'sysv_abi','cold':'cold','hot':'hot','leaf':'leaf','used':'used', 'pure':'pure','const':'const','warn_unused_result':'warn_unused_result','nonblocking':'nonblocking','noreturn':'noreturn','warn':'warning("warn")','deny':'error("deny")','conditional_error':'diagnose_if(n==7,"denied","error")','conditional_warning':'diagnose_if(n==7,"suspicious","warning")','target':'target("avx2"),always_inline','minsize':'minsize','no_sanitize':'no_sanitize("address")','preserve_most':'preserve_most','preserve_all':'preserve_all'}
with tempfile.TemporaryDirectory() as tmp,(d/('grid-'+tag+'.tsv')).open('w') as f:
 root=Path(tmp); path=root/'x.c'; obj=root/'x.o'
 w=csv.writer(f,delimiter='\t',lineterminator='\n')
 w.writerow(('attribute','placement','arg','off','on','diag','elf','taken'))
 for attribute,value in attrs.items():
  att=('__attribute__(('+value+')) ') if value else ''
  plain='int f(int n); '
  decl='int f(int n) '+att+'; '
  definition=att+'int f(int n){return n+1;} '
  for pos in ('direct','early','late','block','definition','other-entity'):
   for arg in (3,7):
    use='int g(void){return f('+str(arg)+');} '
    src={'direct':decl+use,'early':decl+plain+use,'late':plain+use+decl,'block':'int g(void){'+decl+'return f('+str(arg)+');}', 'definition':definition+use,'other-entity':decl.replace('int f(','int h(')+plain+use}[pos]
    path.write_text(src+'\n'); stats=[]
    for mode in ('off','on'):
     env=os.environ.copy();obj.unlink(missing_ok=True)
     if mode=='on':env.update(BUSTER_CALL_PROTO='1',BUSTER_CALL_LOG='1')
     pp=subprocess.run([cc,'--node-window','-Wall','-Wextra','-c',path,'-o',obj],env=env,capture_output=True,text=True)
     lines=pp.stderr.splitlines();diag=[s for s in lines if not s.startswith('call-row:')]
     stats.append((pp.returncode,diag,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '-',len(lines)-len(diag)))
    off,on=stats;w.writerow((attribute,pos,arg,off[0],on[0],int(off[1]==on[1]),int(off[2]==on[2]),on[3]))
