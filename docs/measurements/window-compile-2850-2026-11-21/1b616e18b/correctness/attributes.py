from pathlib import Path
import os,sys,tempfile,subprocess,csv,hashlib
d=Path(os.environ.get('BUSTER_EVIDENCE_OUT',Path(__file__).resolve().parent)).resolve();d.mkdir(exist_ok=True);cc=Path(sys.argv[1]).resolve()
attrs={'plain':'','noreturn':'noreturn','unavailable':'unavailable("unavailable")','deprecated':'deprecated("deprecated")','twice':'returns_twice','nonblocking':'nonblocking','nonnull':'nonnull(1)','nothrow':'nothrow','leaf':'leaf','const':'const','pure':'pure','warn':'warning("do not call")','error':'error("invalid")','diagnose':'diagnose_if(1,"test warning","warning")','deny':'diagnose_if(1,"test error","error")','explicit-sysv':'sysv_abi','msabi':'ms_abi','swiftcall':'swiftcall','preserve-most':'preserve_most','no-caller-saved':'no_caller_saved_registers','target':'target("avx2"),always_inline','hidden':'visibility("hidden")','cold':'cold','malloc':'malloc','always-inline':'always_inline','noderef':'noderef','noescape':'noescape','annotate':'annotate("mark")','nonnull-index':'nonnull(1)'}
with tempfile.TemporaryDirectory() as tmp,(d/'attrs.tsv').open('w') as o:
 root=Path(tmp);s=root/'x.c';obj=root/'x.o';w=csv.writer(o,delimiter='\t',lineterminator='\n');w.writerow('attribute place context policy before after taken diag elf'.split())
 for name,value in attrs.items():
  att=('__attribute__(('+value+'))') if value else ''
  decl='extern void f(int *x) '+att+';'
  proto='extern void f(int*);'
  for context in ('void','int'):
   use=context+' g(int *p){ f(p); }'
   cases={'direct':decl+use,'early':decl+proto+use,'late':proto+use+decl,'block':context+' g(int*p){'+decl+'f(p);}', 'typedef':'typedef void Func(int*) '+att+';extern Func f;'+use, 'other':decl.replace('f(','h(')+proto+use}
   for place,source in cases.items():
    s.write_text(source+'\n')
    for policy,flags in [('default',[]),('all',['-Weverything'])]:
     out=[]
     for mode in ('off','on'):
      env=os.environ.copy();obj.unlink(missing_ok=True)
      if mode=='on':env.update(BUSTER_DISCARD_PTR='1',BUSTER_CALL_LOG='1')
      p=subprocess.run([cc,'--node-window',*flags,'-c',s,'-o',obj],capture_output=True,text=True,env=env);old=p.stderr.splitlines();ds=[l for l in old if not l.startswith('ptr-row:')]
      out.append((p.returncode,ds,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '-',len(old)-len(ds)))
     a,b=out;w.writerow((name,place,context,policy,a[0],b[0],b[3],int(a[1]==b[1]),int(a[2]==b[2])))
