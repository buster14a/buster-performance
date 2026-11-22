from pathlib import Path
import argparse,csv,hashlib,os,subprocess
d=Path(__file__).resolve().parent;w=d.parent
parser=argparse.ArgumentParser();parser.add_argument('--base',type=Path,default=w/'default-integer-control/build/compiler');parser.add_argument('--candidate',type=Path,default=w/'default-ordered-integers/build/compiler');parser.add_argument('--out',type=Path,default=d/'runtime');options=parser.parse_args()
out=options.out;out.mkdir(exist_ok=True)
types=['_Bool','char','signed char','unsigned char','short','unsigned short','int','unsigned','long','unsigned long','long long','unsigned long long','__int128','unsigned __int128']
pre=['extern int printf(const char *,...);','typedef unsigned long long U;'];main=['int main(int argc,char**argv){U h=(U)argc;'];
for i,a in enumerate(types):
 for j,b in enumerate(types):
  fn=f'f{i}_{j}';pre.append(f'__attribute__((noinline)) static U {fn}({a} x,{b} y){{{a} a=x;{b} b=y; a=b; b=x; return (U)(a+b) ^ ((U)(x<y)<<6) ^ (U)(x^b) ^ ((U)(x>=a)<<4) ^ ((U)!a<<5) ^ (U)(x*y) ^ (U)(~x) ^ ((U)(x&&y)<<24);}}');main.append(f'h=h*1099511628211ULL ^ {fn}(({a})(argc+{i+1}),({b})(2*argc+{j+4}));')
main+=['printf("%llu\\n",h);return 0;}'];src=out/'matrix.c';src.write_text('\n'.join(pre+main)+'\n')
clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
rows=[]
for label,exe,args in [('clang',clang,['-std=c17','-O2','-funsigned-char','-fwrapv']),('main',options.base,['--lanes','1','-std=c17','-funsigned-char','-fwrapv']),('candidate',options.candidate,['--lanes','1','-std=c17','-funsigned-char','-fwrapv'])]:
 obj=out/(label+'.o');bin=out/(label+'.exe')
 r=subprocess.run([exe,'-c',*args,src,'-o',obj],capture_output=True);(out/(label+'.stderr')).write_bytes(r.stderr);assert r.returncode==0,(label,r.stderr[:500])
 subprocess.run([clang,obj,'-o',bin],check=True)
 for n in range(1,10):
  v=subprocess.run([bin,*['x']*(n-1)],check=True,capture_output=True);rows.append((label,n,v.stdout.decode().strip(),hashlib.sha256(obj.read_bytes()).hexdigest()))
with (out/'results.tsv').open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('compiler','argc','execution-checksum','elf-sha256'));t.writerows(rows)
assert len({k for k,n,v,dig in rows})==3 and all(len({v for k,a,v,dig in rows if a==n})==1 for n in range(1,10))
