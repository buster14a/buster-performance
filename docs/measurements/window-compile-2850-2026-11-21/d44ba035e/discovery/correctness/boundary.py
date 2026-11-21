from pathlib import Path
import os, sys, subprocess, re, json
d=Path(sys.argv[1]); cc=Path(sys.argv[2]).resolve(); d.mkdir(parents=True,exist_ok=True)
d=d.resolve()
seen=set()
policies=((),('-Wall','-Wextra'),('-Wall','-Wextra','-Werror'))
forms=('if (x < y) return 8;', 'if ((x < y)) return 8;', 'if (((x)) < (y)) return 8;', 'while (x != 3) ++x;', 'if (x < y && x) return 8;', 'if (*p < x) return 8;', 'if (x != x) return 8;')
rows=[]
for offset in range(64):
 for shape,body in enumerate(forms):
  src=d/f'offset-{offset}-{shape}.c'; out=d/'trial.o'
  src.write_text('int f(int x, int y, volatile int *p) { '+ ';' * offset+body+' return x; }\n')
  if shape==0:
   parsed=subprocess.check_output([str(cc),'test-parser','--print-tree',str(src)],text=True)
   pos=int(re.search(r'^\s*(\d+)\s+1\s+if\s+IF\s+\|',parsed,re.M).group(1))%64
   seen.add(pos)
  for policy in policies:
   ordinary=None
   taken=[]
   for mode in ('ordinary','original','control','plain'):
    if out.exists(): out.unlink()
    env=dict(os.environ,BUSTER_CONDITION_DISCOVERY=mode)
    flags=[] if mode=='ordinary' else ['--node-window-conditions']
    a=subprocess.run([str(cc),*flags,*policy,'-c',str(src),'-o',str(out)],env=env,capture_output=True)
    got=(a.returncode,a.stdout,a.stderr,out.read_bytes() if out.exists() else None)
    if ordinary is None: ordinary=got
    assert got==ordinary,(offset,shape,policy,mode,got[:3],ordinary[:3])
    if not policy and mode!='ordinary':
     v=subprocess.run([str(cc),'--node-window-conditions','--time-stages','-fsyntax-only',str(src)],capture_output=True,env=env,check=True)
     take=re.search(rb'node-window-conditions: controls=(\d+) bounded=(\d+) taken=(\d+) native-rows=(\d+)',v.stderr)
     assert take,(offset,shape,mode)
     taken.append(tuple(map(int,take.groups())))
   if not policy:
    assert taken[0]==taken[1],(offset,shape,taken)
    assert taken[2][2]==(1 if shape in (0,3) else 0),(offset,shape,taken)
    rows.append([offset,shape,*taken])
assert seen==set(range(64))
(d/'rows.json').write_text(json.dumps(rows)+'\n')
print(f'{len(rows)} inputs, {len(rows)*len(policies)*4} normal object/diagnostic invocations, {len(rows)*3} independent admission records, all 64 source token offsets in vector width')
