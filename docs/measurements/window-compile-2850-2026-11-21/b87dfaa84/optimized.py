import pathlib,shlex,subprocess
d=pathlib.Path(__file__).resolve().parent
template=(d/'../source-early-release').resolve(); target=(d/'../member-chain-native').resolve()
o=d/'optimized';o.mkdir(exist_ok=True);b=template/'build/cmake/native'; old=b/'Develop/parts/main_unit_checker'; inp='CMakeFiles/buster_main_unit_checker.dir/Develop/src/buster/compiler/main_unit_checker.c.o'
commands=lambda goal:subprocess.check_output(['ninja','-f','build-Develop.ninja','-t','commands',goal],cwd=b,text=True).splitlines()
lines=commands('Develop/parts/main_unit_checker/native.o')
def invoke(args):
 print(str(args[-1])[-70:],flush=True)
 subprocess.run(args,check=True,cwd=o)
c=shlex.split(lines[0].replace(str(template),str(target)))
c=[s.replace(inp,str(o/'checker.bc')) for s in c]
invoke(c)
def adapted(line):
 return shlex.split(line[line.index(' && ')+4:].replace(str(old),str(o)).replace(str(b/inp),str(o/'checker.bc')))
invoke(adapted(lines[3]))
for line in lines[4:]:
 if ' -x ir ' in line or '-DOUTPUT=' in line: invoke(adapted(line))
link=shlex.split(commands('Develop/compiler.link')[-1])[2:-2];link[link.index('Develop/parts/main_unit_checker/native.o')]=str(o/'native.o');link[link.index('Develop/compiler.link')]=str(d/'compiler-develop')
if any('clang' in e for e in link[:1]):link.insert(1,'-Wl,--threads=1')
subprocess.run(link,check=True,cwd=b)
subprocess.run(['python',d/'timing.py'],check=True)
