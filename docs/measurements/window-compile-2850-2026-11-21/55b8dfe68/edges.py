from pathlib import Path
import os,hashlib,subprocess,csv
p=Path(__file__).resolve().parent;exe=p/'compiler';e=p/'edges';e.mkdir(exist_ok=True)
source={'arith':'int f(int a,int b){return (a+b)*3;} int main(void){return f(1,2)!=9;}', 'call':'extern int puts(const char*);int f(void){return puts("hi");} int main(void){return f()<0;}', 'static':'static unsigned long n=1;int f(void){return (int)++n;}int main(void){return f()!=2;}', 'localstatic':'int f(int a){static int v=3;return (v+=a);}int main(void){return f(4)!=7;}', 'always':'__attribute__((always_inline)) static inline int g(int x){return x+4;} int f(int y){return g(y);} int main(void){return f(2)!=6;}', 'unused':'static int gone(int x){return x+1;} int f(int v){return v-1;} int main(void){return f(1);}','weak':'__attribute__((weak)) int f(int x){return x+1;} int main(void){return f(2)!=3;}', 'alias':'int f(int x){return x;} int g(int) __attribute__((alias("f"))); int main(void){return g(2)!=2;}', 'stack':'__attribute__((force_align_arg_pointer)) int f(int x){return x+4;} int main(void){return f(1)!=5;}', 'wide':'unsigned __int128 f(unsigned __int128 x, unsigned __int128 y){return x/y;} int main(void){return f(((unsigned __int128)3<<80),3)!=((unsigned __int128)1<<80);}','switch':(p/'tabled.c').read_text()+'\n'+(p/'run.c').read_text(), 'tls':'_Thread_local int x=4; int f(int a){return(x+=a);} int main(void){return f(2)!=6;}', 'warn':'int f(int x){ return (++x) + x; } int main(void){return 0;}'}
profiles={'default':[], 'warning':['-Wall','-Wextra','-Werror'], 'verify':['--verify'], 'assembly':['-S'], 'debug':['-g'], 'stack':['-fstack-clash-protection'], 'frame':['-fno-omit-frame-pointer'], 'patch':['-fpatchable-function-entry=3,1'], 'tier1':['--tier1'], 'multi':['--lanes','4']};sha=lambda b:hashlib.sha256(b).hexdigest();env={k:v for k,v in os.environ.items() if not k.startswith('BUSTER_CONTROL_')}
with (p/'edges.tsv').open('w',buffering=1) as out:
 w=csv.writer(out,delimiter='\t',lineterminator='\n');w.writerow('case profile status object stdout stderr'.split())
 for k,s in source.items():
  src=e/(k+'.c');src.write_text(s)
  for m,extra in profiles.items():
   rows=[]
   for a in range(2):
    obj=e/(k+'.tmp');obj.unlink(missing_ok=True);flags=['-S'] if m=='assembly' else ['-c',*extra];r=subprocess.run([exe,'--lanes','1',*flags,src,'-o',obj],env=env|{'BUSTER_CONTROL_SOURCE_NATIVE':'1'}|({'BUSTER_CONTROL_EARLY_RELEASE':'1','BUSTER_CONTROL_EARLY_NATIVE':'1','BUSTER_CONTROL_EARLY_POISON':'1'} if a else {}),capture_output=True,timeout=3)
    rows.append((r.returncode,sha(obj.read_bytes()) if obj.exists() else '',sha(r.stdout),sha(r.stderr)))
   w.writerow([k,m,*(int(l==r) for l,r in zip(*rows))]);
   if rows[0]!=rows[1]:print(k,m,rows,flush=True)
