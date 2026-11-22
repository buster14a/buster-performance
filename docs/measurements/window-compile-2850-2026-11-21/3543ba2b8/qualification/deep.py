from pathlib import Path
import csv,hashlib,subprocess
st=Path(__file__).resolve().parent;w=st.parent;d=st/'depth-cases';d.mkdir(exist_ok=True)
prefix=''.join(f'typedef int Pad{i};\n' for i in range(2060))
forms={
'paren':lambda n:'int a(int x){return '+'('*n+'x'+')'*n+';}',
'brace':lambda n:'int a(int x){'+'{'*n+'return x;'+'}'*n+'}',
'ternary':lambda n:'int a(int x){return '+'(x?'*n+'1'+':0)'*n+';}',
'case':lambda n:'int a(int x){'+'switch(x){case 1: {'*n+'return x;'+'} }'*n+' return 0;}',
'block-fallback':lambda n:'int a(int x){'+'{'*n+'__asm__ volatile("" : "+r"(x));return x;'+'}'*n+'}',
'repair':lambda n:'int a(int x){return '+'('*n+'missing'+')'*n+';}',
'prefix':lambda n:'int a(int x){return '+'('*n+'x'+')'*n+';} int b( {return 0;}',
'generic':lambda n:'int a(int x){return '+'_Generic((x),int:'*n+'x'+', default:0)'*n+';}',
'compound':lambda n:'typedef struct{int x;}T;int a(int x){T s={.x='+'('*n+'x'+')'*n+'};return s.x;}',
}
cc=[w/'main-fbef-clean/build/compiler',w/'tile-parser-precedence/build/compiler']
clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
sha=lambda v:hashlib.sha256(v).hexdigest()
with (st/'deep.tsv').open('w',buffering=1) as out:
 t=csv.writer(out,delimiter='\t',lineterminator='\n');t.writerow(['name','nest','mode','match','status','stdout','stderr','object','clang_runtime','clang_compile_status'])
 for name,gen in forms.items():
  for n in [0,1,63,64,127,128,253,254,255,256,257,511,2047,2048]:
   f=d/f'{name}-{n}.c';f.write_text(prefix+gen(n)+'\nint main(void){return a(1);}\n')
   for mode,args in [('default',[]),('poison',['--poison-arenas']),('walls',['-Wall','-Wextra']),('all',['-Weverything','-Wno-c++-compat']),('debug',['-g']),('tier',['--tier1'])]:
    observed=[];o=d/'unit.o'
    for c in cc:
     o.unlink(missing_ok=True);r=subprocess.run([c,*args,'-c',f,'-o',o],timeout=50,capture_output=True);observed.append((r.returncode,r.stdout,r.stderr,o.read_bytes() if o.is_file() else b''))
    a,b=observed;match=a==b;runtime='-';clang_status='-'
    if match and b[0]==0 and n in [0,63,255,256,257] and mode=='default':
     ref=d/'reference';exp=d/'candidate';y=subprocess.run([clang,'-fbracket-depth=8192','-O0',f,'-o',ref],capture_output=True)
     clang_status=y.returncode
     if y.returncode==0:
      subprocess.run([clang,'-no-pie',o,'-o',exp],check=True,capture_output=True)
      e=subprocess.run([exp],capture_output=True,timeout=5);z=subprocess.run([ref],capture_output=True,timeout=5);runtime=z.returncode
      match=(e.returncode,e.stdout,e.stderr)==(z.returncode,z.stdout,z.stderr)
    t.writerow([name,n,mode,int(match),b[0],*[sha(v) for v in b[1:]],runtime,clang_status])
    if not match:
     for which,row in zip(['before','after'],observed):(d/(name+'-'+str(n)+'-'+mode+'-'+which+'.log')).write_bytes(row[1]+row[2])
     raise ValueError((name,n,mode,[(v[0],len(v[1]),len(v[2]),len(v[3])) for v in observed]))
