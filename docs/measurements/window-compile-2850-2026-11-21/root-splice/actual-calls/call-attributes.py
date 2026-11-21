from pathlib import Path
import csv,os,hashlib,subprocess,tempfile,sys
d=Path(__file__).resolve().parent;cc=Path(sys.argv[1]);dest=Path(sys.argv[2]);dest.mkdir(exist_ok=True)
cases={
 'plain':'extern int target(int);',
 'noreturn':'extern int target(int) __attribute__((noreturn));',
 'twice':'extern int target(int) __attribute__((returns_twice));',
 'ms':'extern int target(int) __attribute__((ms_abi));',
 'preserve':'extern int target(int) __attribute__((preserve_most));',
 'unavailable':'extern int target(int) __attribute__((unavailable("unavailable target")));',
 'diagnose':'extern int target(int x) __attribute__((diagnose_if(x<0,"negative argument","error")));',
 'target':'extern int target(int) __attribute__((target("avx2"),always_inline));',
 'deprecated':'extern int target(int) __attribute__((deprecated));',
 'weak':'extern int target(int) __attribute__((weak));',
 'unusedresult':'extern int target(int) __attribute__((warn_unused_result));',
 'alias':'int body(int x){return x;} extern int target(int) __attribute__((alias("body")));',
 'variadic':'extern int target(int,...);',
 'old':'extern int target();',
}
env=dict(NODE_SPLICE_FRONT='1',NODE_SOURCE_ROWS='1',NODE_SOURCE_ONLY='1',NODE_SOURCE_STRINGS='1',NODE_SOURCE_REFRESH_POINTERS='1',NODE_PROOF_NATIVE='1',NODE_PROOF_NO_FP='1',
 NODE_PROOF_CALLS='1',NODE_PROOF_POINTERS='1',NODE_SPLICE_ENABLE='1',NODE_SPLICE_CALLS='1',NODE_SPLICE_REPORT='1')
if os.getenv('CALL_VIEW_TESTS'): env['NODE_CROSS_TYPE_VIEW']='1'
with (dest/'results.tsv').open('w') as f,tempfile.TemporaryDirectory() as tmp:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('case shape policy ordinary source direct status diagnostics elf native'.split())
 for case,declaration in cases.items():
  for shape,statement in [('return','return target(x);'),('statement','target(x); return 0;'),('negative','return target(-4);'),('positive','return target(6);')]:
   path=dest/(case+'-'+shape+'.c')
   path.write_text(declaration+'\nextern int (*pointer_hint)(int);\nint wrapper(int x) {\n'+statement.replace('target(', 'target(\n')+'\n}\n')
   for pol,flags in [('default',[]),('debug',['-g']),('wall',['-Wall','-Wextra']),('error',['-Werror'])]:
    rows=[]
    for e in ({},env):
     obj=Path(tmp)/'a.o';nat=Path(tmp)/'a.native';obj.unlink(missing_ok=True);nat.unlink(missing_ok=True)
     p=subprocess.run([cc,'--lanes','1',*flags,'-c',path,'-o',obj],env=dict(os.environ,**e,NODE_SOURCE_NATIVE_ORACLE=str(nat)),capture_output=True)
     lines=p.stderr.splitlines(keepends=True);diag=b''.join(x for x in lines if not x.startswith((b'splice-',b'source-rows ',b'node-proof ',b'probe-select ',b'cross-view ',b'cross-canonical ',b'cross-call-private ')))
     h=lambda p: hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else '-'
     rows.append((p.returncode,diag,h(obj),h(nat),sum(x.startswith(b'splice-direct:') for x in lines)))
    a,b=rows;w.writerow((case,shape,pol,a[0],b[0],b[4],*[int(x==y) for x,y in zip(a[:4],b[:4])]))
