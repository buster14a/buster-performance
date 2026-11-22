from common import *
import csv,gzip,hashlib,shutil,subprocess
d=D/'runtime';d.mkdir(exist_ok=True);clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
def run(cmd,extra,stem):
 r=subprocess.run(cmd,cwd=ROOT,capture_output=True,env=env|extra,timeout=180)
 for suffix,data in [('stdout',r.stdout),('stderr',r.stderr)]: (d/(stem+'.'+suffix+'.gz')).write_bytes(gzip.compress(data,mtime=0))
 assert r.returncode==0,(stem,r.stderr[:1000])
 return r.stdout
rows=[]
for name in ('small','edges','members'):
 src=d/(name+'.c')
 if name!='members':
  orig=W/'default-ordered-integers-study'/('runtime' if name=='small' else 'runtime-edges')/'matrix.c';shutil.copyfile(orig,src)
 else:
  src.write_text('''extern int printf(const char*,...);
struct A{ unsigned value; int other; }; struct B { unsigned first; struct A a; struct B *next; };
struct Bits { unsigned a:3; unsigned b:5; volatile unsigned v; };
__attribute__((noinline)) unsigned eval(struct B *p,struct Bits *b){return (p->next->a.value * 13u) ^ (p->a.value<<2) ^ b->a ^ b->b ^ b->v ^ p->first;}
int main(int argc,char **argv){unsigned i=(unsigned)argc;struct B q={i*7u,{i+3u,2},0};struct B p={i*3u,{i^31u,5},&q};
struct Bits b={i,7u+i,i*17u};printf("%u\\n",eval(&p,&b));return 0;}
''')
 outputs={}
 for mode,cc,extra in [('clang',clang,{}),('ordinary',CC,{}),('source-parent',PRIOR,native),('source-control',CC,native),('producer',CC,native|producer)]:
  obj=d/(name+'.'+mode+'.o');exe=d/(name+'.'+mode+'.exe');args_=['-O2'] if mode=='clang' else ['--lanes','1']
  run([cc,*args_,'-std=c17','-funsigned-char','-fwrapv','-c',src,'-o',obj],extra,name+'.'+mode+'.compile')
  run([clang,obj,'-o',exe],{},name+'.'+mode+'.link')
  digest=hashlib.sha256(obj.read_bytes()).hexdigest(); data=[]
  for argc in range(1,10):
   out=run([exe,*(['v']*(argc-1))],{},name+'.'+mode+'.'+str(argc));data.append(out);rows.append([name,mode,argc,out.decode().strip(),digest])
  outputs[mode]=data
 assert len({tuple(x) for x in outputs.values()})==1,name
with (d/'results.tsv').open('w') as fp:
 t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['source','mode','argc','execution-result','ELF']);t.writerows(rows)
print(len(rows),'runtime checks')
