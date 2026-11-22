from pathlib import Path
import subprocess,shlex
d=Path(__file__).resolve().parent;repo=(d/'../member-chain-spelling').resolve();base=(d/'../source-early-release').resolve();b=base/'build/cmake/native';o=d/'objects';o.mkdir(exist_ok=True)
link=shlex.split(subprocess.check_output(['ninja','-f','build-Develop.ninja','-t','commands','Develop/compiler.link'],cwd=b,text=True).splitlines()[-1])[2:-2]
for i,arg in enumerate(link):
 if not (arg.startswith('Develop/parts/') and arg.endswith('/native.o')):continue
 name=arg.split('/')[2];obj=o/(name+'.o')
 if not obj.exists():
  raw=subprocess.check_output(['ninja','-f','build-Develop.ninja','-t','commands',arg],cwd=b,text=True).splitlines()[0]
  flags=shlex.split(raw[:raw.index(' -MD')].replace(str(base),str(repo)).replace('-Xclang -disable-llvm-passes -emit-llvm','').replace('-O3','-O0 -g1'))
  print(name,flush=True);subprocess.run([*flags,'-c',repo/f'src/buster/compiler/{name}.c','-o',obj],check=True)
 link[i]=str(obj)
link[link.index('Develop/compiler.link')]=str(d/'compiler')
link=[arg for arg in link if not arg.startswith(('-Wl,-T,','-Wl,--symbol-ordering-file='))]
if 'clang' in link[0]:link.insert(1,'-Wl,--threads=1')
subprocess.run(link,cwd=b,check=True)
