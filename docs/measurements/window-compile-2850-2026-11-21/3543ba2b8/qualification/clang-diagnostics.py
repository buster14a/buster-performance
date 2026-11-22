from pathlib import Path
import csv,re,subprocess,sys,tarfile
s=Path(sys.argv[1]).resolve();w=s.parent;t=sys.argv[2];out=s/'clang-diagnostic-cases';out.mkdir(exist_ok=True)
clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
sources={
 'undeclared':('int f(int x){return ','unlisted',';}'),
 'not_record':('int f(int x){return ','x.field',';}'),
 'bad_deref':('int f(int x){return ','*x',';}'),
 'bad_mod':('int f(double x){return ','x % 2',';}'),
 'missing_colon':('int f(int x){return ','x ? 1',';}'),
 'duplicate_generic':('int f(int x){return ','_Generic(x, int:1, int:2)',';}'),
 'incomplete_member':('struct S; int f(struct S *p){return ','p->x',';}'),
 'missing_call_arg':('int g(int a); int f(void){return ','g()',';}'),
}
prefix=''.join(f'typedef int Pad{i};\n' for i in range(2060))
rx=re.compile(rb'^.+?:([0-9]+):([0-9]+): (?:fatal )?error: (.*)$',re.M)
with (s/'clang-diagnostics.tsv').open('w',buffering=1) as f:
 table=csv.writer(f,delimiter='\t',lineterminator='\n');table.writerow(['source','nest','same_status_stream','same_clang_first','buster_first','clang_first'])
 for key,(a,b,c) in sources.items():
  for depth in [0,63,254,255,257]:
   src=out/(key+'-'+str(depth)+'.c');src.write_text(prefix+a+'('*depth+b+')'*depth+c+'\n')
   obs=[]
   for label,exe in [('baseline',w/'main-fbef-clean/build/compiler'),('candidate',w/t/'build/compiler'),('clang',clang)]:
    r=subprocess.run([exe,*(['-fbracket-depth=8192'] if label=='clang' else []),'-std=c17','-c',src,'-o',out/'unused.o'],capture_output=True,timeout=30)
    (out/(src.stem+'-'+label+'.stderr')).write_bytes(r.stderr)
    match=rx.search(r.stderr);assert r.returncode>=0,(key,depth,label,r.returncode,r.stderr[-500:])
    first=b':'.join(match.groups()).decode(errors='replace') if match else 'accepted' if r.returncode==0 else 'unlocated diagnostic'
    obs.append(((r.returncode,r.stdout,r.stderr),first))
   a0,b0,c0=obs;same=a0[0]==b0[0];assert same,(key,depth)
   table.writerow([key,depth,int(same),int(b0[1]==c0[1]),b0[1],c0[1]])
