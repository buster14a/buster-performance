from pathlib import Path
import subprocess,shutil,os,hashlib,csv
d=Path(__file__).resolve().parent
p=d/'edges';p.mkdir(exist_ok=True)
cc=d/'compiler'
k=540
inputs={
  'fraction':('struct A{int n;};','struct A','{3}', '{1.75}', 'x[i].n'),
  'integer':('struct A{unsigned char n;};','struct A','{3}', '{0x1234}', 'x[i].n'),
  'negative':('struct A{unsigned n;};','struct A','{3}', '{-1}', 'x[i].n'),
  'shift':('struct A{int n;};','struct A','{3}', '{1 << 34}', 'x[i].n'),
  'division':('struct A{int n;};','struct A','{3}', '{1/0}', 'x[i].n'),
  'bad-member':('struct A{int n;};','struct A','{3}', '{.other=7}', 'x[i].n'),
  'double-write':('struct A{int n;};','struct A','{3}', '{.n=2,.n=7}', 'x[i].n'),
  'excess':('struct A{int n;};','struct A','{3}', '{3,4,5}', 'x[i].n'),
  'short':('struct A{int n,m;};','struct A','{3,4}', '{5}', 'x[i].n'),
  'bad-pointer':('struct A{const int *p;};','struct A','{0}', '{1}', '!!x[i].p'),
  'enum':('enum E{A=1};enum F{B=1};struct T{enum E n;};','struct T','{A}', '{B}', 'x[i].n'),
  'dynamic':('extern int f(void); struct A{int n;};','struct A','{3}', '{f()}', 'x[i].n'),
  'symbol-addend':('static int a[8];struct A{int *p;};','struct A','{&a[2]}','{a+7}', '!!x[i].p'),
  'string-addend':('struct A{const char *p;};','struct A','{"abc"+1}', '{"abc"+2}', 'x[i].p[0]'),
  'embedded-nul':('struct A{const char *p;};','struct A','{"a\\0b"}', '{"hello\\0hi"}', 'x[i].p[2]'),
  'function':('extern int f(void);struct A{int(*p)(void);};','struct A','{f}', '{&f}', '!!x[i].p'),
  'compound':('struct A{int n;};','struct A','{3}', '{((struct A){8}).n}', 'x[i].n'),
  'unselected':('struct A{int n;};','struct A','{3}', '{1 ? 5 : 1/0}', 'x[i].n'),
  'pragma':('struct A{unsigned char n;};','struct A','{3}', '{0x1234}', 'x[i].n'),
}
policies={'default':[], 'wall':['-Wall','-Wextra'], 'all':['-Weverything','-Wno-c++-compat'], 'errors':['-Wall','-Wextra','-Werror']}
def digest(x):return hashlib.sha256(x).hexdigest()
with (p/'results.tsv').open('w') as out:
 w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow(['case','policy','base_status','new_status','same','base_stderr','new_stderr','marker','clang_status'])
 for name,(decl,typ,good,bad,read) in inputs.items():
  src=p/(name+'.c')
  rows=[good if i!=k//2 else bad for i in range(k)]
  pr='#pragma clang diagnostic ignored "-Wconstant-conversion"\n' if name=='pragma' else ''
  src.write_text(pr+decl+'\nstatic const '+typ+' x[] = {\n'+',\n'.join(rows)+'\n};\nint inspect(unsigned i){return '+read+';}\n')
  for policy,opts in policies.items():
   modes=[]
   for arm,extra in [('base',{}),('new',{'BUSTER_WINDOW_DATA_PUBLISH':'1','BUSTER_WINDOW_DATA_AUDIT':'1'})]:
    obj=p/(name+'.'+policy+'.'+arm+'.o');obj.unlink(missing_ok=True)
    proc=subprocess.run([cc,'--lanes','1','-c','-std=gnu23',*opts,src,'-o',obj],env=os.environ|extra,capture_output=True)
    diag=b''.join(l for l in proc.stderr.splitlines(keepends=True) if not l.startswith(b'static-published\t'))
    (p/(name+'.'+policy+'.'+arm+'.diag')).write_bytes(diag)
    marker=next((l.decode().replace('\t',',') for l in proc.stderr.splitlines() if l.startswith(b'static-published\t')),'-')
    modes.append((proc.returncode,proc.stdout,diag,digest(obj.read_bytes()) if obj.exists() else '-'))
   clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
   cp=subprocess.run([clang,'-c','-std=gnu23',*opts,src,'-o',p/'clang.o'],capture_output=True)
   (p/(name+'.'+policy+'.clang.diag')).write_bytes(cp.stderr)
   a,b=modes;w.writerow([name,policy,a[0],b[0],int(a==b),digest(a[2]),digest(b[2]),marker,cp.returncode])
   out.flush()
