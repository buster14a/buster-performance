from pathlib import Path
import collections, subprocess, re, concurrent.futures, hashlib, os, sys
root=Path(__file__).resolve().parent
cc=Path(sys.argv[1]).resolve()
out=Path(sys.argv[2]).resolve();out.mkdir(exist_ok=True,parents=True)
option = sys.argv[3] if len(sys.argv) > 3 else '--node-window'
clang=Path(os.environ.get('BUSTER_TEST_CLANG', 'clang'))
kinds=[
 ('alwaysinline','','required(x)', 'static inline __attribute__((always_inline,target("avx2"))) int required(int x){ if (x) return 11; return -9; }\n'),
 ('flatten','__attribute__((flatten))','required(x)','static __attribute__((target("avx2"))) int required(int x){ if (x) return 11; return -9; }\n'),
 ('enabled','__attribute__((target("avx2")))','required(x)','static inline __attribute__((always_inline,target("avx2"))) int required(int x){ if (x) return 11; return -9; }\n'),
 ('clones','__attribute__((target_clones("avx2","default")))','required(x)','static inline __attribute__((always_inline,target("avx2"))) int required(int x){ if (x) return 11; return -9; }\n'),
 ('builtin','','(int)__builtin_ia32_pdep_di(x, 7)',''),
 ('enabled-builtin','__attribute__((target("bmi2")))','(int)__builtin_ia32_pdep_di(x, 7)',''),
]
guards={
'local-eq':'x == y','local-ne':'x != y','local-split':'(x == y) && (x != 0)','same':'x == x','const-always':'2 < 3','const-never':'3 < 2','local-constant':'x == 0',
}
control={
'yes':'if (GUARD) return CALL; return 3 + 4;',
'no':'if (GUARD) return -3; return CALL;',
'both':'if (GUARD) { if (x) return CALL; return -7; } return 3 * 9;',
'after-return':'if (GUARD) return 31; return 4 + 5; return CALL;',
'label':'if (GUARD) goto L; return 31; L: return CALL;',
'switch':'switch (GUARD) { case 0: return 23; case 1: return CALL; } return -11;',
'while':'while (GUARD) { if (x) return CALL; return 4 - 5; } return -2;',
'conditional':'return (GUARD) ? (CALL) : 8;',
'right-and':'if ((GUARD) && (CALL)) return 7; return -17;',
}
jobs=[]
for k,attr,call,decl in kinds:
 for g,cond in guards.items():
  for shape,body in control.items():
   name='-'.join([k,g,shape]); f=out/(name+'.c')
   source=decl+'int visible_{0}(void) {{ return 6 * 7; }}\n'.format(name.replace('-','_'))+attr+' int f(int x,int y){ '+body.replace('GUARD',cond).replace('CALL',call)+' }\n'
   f.write_text(source)
   for debug in (False,True):jobs.append((name,f,debug))
def run(job):
 name,src,debug=job
 flags=['-std=gnu17','-march=x86-64','-Wno-tautological-compare','-fno-caret-diagnostics','-fdiagnostics-color=never']
 if debug: flags+=['-g']
 obj=out/(name+('-debug' if debug else '')+'.o')
 def compile(compiler,options,terminal):
  obj.unlink(missing_ok=True)
  r=subprocess.run([compiler,*flags,*options,*terminal,src,'-o',obj],capture_output=True,timeout=70)
  sha=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else ''
  return r.returncode,r.stdout,r.stderr,sha
 a=compile(cc,[],['-c']);b=compile(cc,[option],['-c']);c=compile(clang,[],['-c'])
 z=compile(cc,[option,'--time-stages'],['-fsyntax-only'])
 match=re.search(rb'node-window: taken=(\d+)',z[2])
 conditions = re.search(rb'node-window-conditions: controls=\d+ bounded=\d+ taken=(\d+)',z[2])
 if a!=b or a[:3]!=c[:3]:
  for suffix,res in [('plain',a),('window',b),('clang',c)]:
   (out/(name+('-debug' if debug else '')+'.'+suffix+'.diag')).write_bytes(res[2])
 obj.unlink(missing_ok=True)
 return [name,debug,a[0],b[0],c[0],int(a==b),int(a[:3]==c[:3]),int(match[1]) if match else -1,int(conditions[1]) if conditions else 0]
stats=collections.Counter()
with (out/'results.tsv').open('w') as o, concurrent.futures.ThreadPoolExecutor(2) as pool:
 for row in pool.map(run,jobs):
  print(*row,sep='\t',file=o)
  stats['pairs']+=1;stats['objects']+=row[2]==0;stats['known_clang_differences']+=not row[6];stats['option_differences']+=not row[5];stats['confirmed_hits']+=row[7]>0;stats['condition_cases_taken']+=row[8]>0;stats['condition_total']+=row[8]
print(dict(stats))
sys.exit(stats['option_differences']!=0)
