from pathlib import Path
from tempfile import TemporaryDirectory
import subprocess,sys,random,hashlib,collections
out=Path(__file__).resolve().parent
base,head=(Path(x).resolve() for x in sys.argv[1:3])
rng=random.Random(2850); seen=collections.Counter()
policies=[[],['-Wall','-Wextra'],['-Wall','-Wextra','-Werror'],['-Wno-array-bounds','-Wno-literal-conversion'],['-w']]
modes=[['-c'],['-c','--scalar'],['-c','--deferred-bodies','--lanes','3'],['-fsyntax-only'],['-c','--node-window']]
with TemporaryDirectory() as tmp:
 src=Path(tmp)/'shape.c'; obj=Path(tmp)/'shape.o'
 for file in range(32):
    rows=['extern void use(int); extern int tick(void);']
    for k in range(32):
        name='run_'+str(k)
        source=['int '+name+'(int x) { int a[3]={0}; int z=0;']
        for statement in range(rng.randint(2,10)):
            num=rng.randint(3,19)
            arm=rng.choice(['x','0','1','(x ? 1 : 0)'])
            lit=rng.choice(['0.5','2.75','8.125','127.875'])
            expr=rng.choice([f'(x ? {lit} : 1)',f'a[{num}]',f'(int){lit}',f'(x && a[{num}])'])
            fmt=rng.choice(['if (C) { int v = E; z += v; }','z += (C ? E : 0);','z += sizeof(E);',
                            'z += sizeof(int[(C) ? x+1 : 2]);','z += _Generic(x, int: (C ? E : 0), default: E);',
                            'z += __builtin_choose_expr(0,E,(C ? E : 0));','z += ((C) && (E));','z += ((C) || (E));',
                            'switch ((C)) { case 0: z += E; break; default: break; }','z += ({int v = 0; if(C) v=E; v;});'])
            source.append(fmt.replace('C',arm).replace('E',expr))
        source.append('return z; }');rows.extend(source)
    src.write_text('\n'.join(rows)+'\n')
    for policy in policies:
      for mode in modes:
        vals=[]
        for exe in (base,head):
            obj.unlink(missing_ok=True)
            p=subprocess.run([str(exe),*mode,*policy,str(src),'-o',str(obj)],capture_output=True)
            vals.append((p.returncode,p.stdout,p.stderr,obj.read_bytes() if obj.exists() else None))
        assert vals[0]==vals[1],(file,mode,policy)
        rc,_,stderr,elf=vals[0];assert stderr or not rc
        seen['compares']+=1;seen['rejected']+=bool(rc);seen['objects']+=elf is not None
        seen['diagnostic-bytes-compared']+=len(stderr)
    print(file,32,seen,flush=True)
