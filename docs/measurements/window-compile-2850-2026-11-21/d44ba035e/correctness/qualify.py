import collections
import os
import itertools
import pathlib
import re
import subprocess
import sys
if len(sys.argv) != 5:
    sys.exit("usage: qualify.py BUSTER_CHECKOUT COMPILER CLANG SCRATCH")
root=pathlib.Path(sys.argv[1]).resolve()
cc=pathlib.Path(sys.argv[2]).resolve()
clang=str(pathlib.Path(sys.argv[3]).resolve())
target=pathlib.Path(sys.argv[4]).resolve()
target.mkdir(parents=True,exist_ok=True)
src=target/'mix.c'
driver=target/'main.c'
codes=[]
for keyword,(left,right),op,wrap in itertools.product(['if','while'],[('a','b'),('a','7'),('9','b'),('G(a)','G(b)')],['==','!=','<','<=','>','>='],[0,1]):
    n=len(codes)
    condition=f'{left} {op} {right}'
    if wrap: condition=f'({condition})'
    codes.append(f'int f{n}(int a,int b) {{ {keyword} ({condition}) return a+{n}; return b-{n}; }}')
for left,right in [('p','q'),('s','a'),('v','a'),('a','a'),('a','2147483647'),('a','*p'),('a','fn(b)'),('a + 1','b')]:
    n=len(codes)
    codes.append(f'int f{n}(int a,int b) {{ int *p=&a,*q=&b; short s=(short)b; volatile int v=b; if ({left}=={right}) return a+{n}; return b-{n}; }}')
src.write_text('#define G(x) (x)\nint fn(int x) {return x+2;}\n'+'\n'.join(codes)+'\n')
driver.write_text('#include <stdio.h>\n'+''.join(f'int f{i}(int,int);\n' for i in range(len(codes)))+'int main(void){int (*fs[])(int,int)={'+','.join('f'+str(i) for i in range(len(codes)))+'}; unsigned long long h=0; for(int a=-10;a<=10;a++) for(int b=-10;b<=10;b++) for(unsigned i=0;i<sizeof(fs)/sizeof(*fs);i++) h=h*31u+(unsigned)fs[i](a,b);printf("%016llx\\n",h);return 0;}\n')
clobj=target/'clang.o'
subprocess.run([clang,'-w','-c',src,'-o',clobj],check=True)
def run_obj(obj):
 exe=target/(obj.stem+'.exe')
 subprocess.run([clang,driver,obj,'-o',exe],capture_output=True,check=True)
 return subprocess.check_output([exe])
expect=run_obj(clobj)
cases=[ [],['-Wall','-Wextra'],['-Werror','-Wno-parentheses-equality','-Wno-tautological-compare'],['-std=c23','-w'],['-Wno-everything','-O1'],['-g'],['--lanes','3'],['--deferred-bodies'],['--attested=verify']]
issues=[]
serial=os.environ.get('COND_TEST_SERIAL')=='1'
for i,opts in enumerate(cases):
 if serial and '--lanes' in opts: continue
 objs=[]
 outputs=[]
 for m,opt in enumerate([[],['--node-window'],['--node-window-conditions']]):
    obj=target/f'{i}-{m}.o'; r=subprocess.run([cc,*opts,*opt,'-c',src,'-o',obj],capture_output=True)
    outputs.append((r.returncode,r.stdout,r.stderr)); objs.append(obj)
 same=all(o==outputs[0] for o in outputs)
 object_same=outputs[0][0]!=0 or all(o.is_file() and o.read_bytes()==objs[0].read_bytes() for o in objs)
 runtime=outputs[0][0]!=0 or all(run_obj(o)==expect for o in objs)
 diag=outputs[0][2].count(b'warning:'); c=subprocess.run([cc,*opts,'--node-window-conditions','--time-stages','-fsyntax-only',src],capture_output=True)
 cnt=re.search(rb'node-window-conditions: controls=(\d+) bounded=(\d+) taken=(\d+) native-rows=(\d+)',c.stderr)
 print(i,opts,outputs[0][0],diag,'pass',same,object_same,runtime,'counters',cnt.groups() if cnt else None,flush=True)
 admissions=[int(x) for x in cnt.groups()] if cnt else [0,0,0,0]
 if i in (0,1,3) and (admissions[2] < 48 or admissions[3] != 3 * admissions[2]):
    issues.append((i,'positive',admissions))
 if not (same and object_same and runtime):
    for j,o in enumerate(outputs): (target/f'{i}-{j}.log').write_bytes(o[1]+o[2])
    issues.append((i,'mix'))
fixture=root/'tests/driver/operand_diagnostics/node_window_conditions.c'
for pl in [[],['-Werror'],['-w']]:
 for std,mode,lanes in itertools.product(['gnu17','c23'],['-c','-fsyntax-only'],['1'] if serial else ['1','3']):
    controls=['-Wall','-fno-caret-diagnostics',f'-std={std}',*pl,mode,str(fixture)]
    obj=target/'fixture.o'; objs=[obj] if mode=='-c' else []
    before=subprocess.run([clang,*controls,*(['-o',obj] if objs else [])],capture_output=True)
    runs=[subprocess.run([cc,*flags,'--lanes',lanes,*controls,*(['-o',obj] if objs else [])],capture_output=True) for flags in ([],['--node-window-conditions'])]
    matches=all((r.returncode,r.stdout,r.stderr)==(before.returncode,before.stdout,before.stderr) for r in runs)
    if not matches:
        issues.append((std,mode,lanes,pl))
        for j,r in enumerate([before,*runs]): (target/f'diagnostics-{std}-{lanes}-{j}.log').write_bytes(r.stdout+r.stderr)
print('functions',len(codes),'calls',len(codes)*21*21,'runtime SHA-like arithmetic digest',expect.decode().strip(),'issues',issues)
sys.exit(bool(issues))
