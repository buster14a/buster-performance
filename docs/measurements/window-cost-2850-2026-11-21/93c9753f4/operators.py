import itertools,pathlib,subprocess,sys
from collections import defaultdict
# Supply the #3213 executable, candidate executable and output directory.
before,candidate,output=sys.argv[1:4]
out=pathlib.Path(output).resolve()
out.mkdir(parents=True,exist_ok=True)
pieces=['int ga[16], gb[16];','int fn(int);']
def stmt(fn,e,op,p):
    return f'int c{fn}(int *p, int *q, long n, unsigned u) {{ return (({e}) {op} ({p})); }}'
fs=[]
for a,b in itertools.product(['p','q','ga','gb','ga + n','(int*)0','(int*)42','n','u','0','42'],repeat=2):
    for op in ['<','>','<=','>=','==','!=','&&','||']:
        fs.append(stmt(len(fs),a,op,b))
fs+=['int add(int *p, int *q) { return (p - q) != 0; }','int typed(int x,int (*p)(int)) { return fn < p || fn == p; }']
p=out/'operators.c'
p.write_text('\n'.join(pieces + fs)+'\n')
options=[[],['-w'],['-Wall','-Wextra'],['-Wno-ordered-compare-function-pointers','-Wno-ordered-compare-pointer-to-zero'],['-Wno-ordered-compare-function-pointers','-Wno-pointer-integer-compare'],['-Wsign-compare'],['-Weverything','-Wno-c++-compat']]
for index,flags in enumerate(options):
    outs=[]
    for label,binary in [('before',before),('candidate',candidate)]:
        run=subprocess.run([str(binary),'measure-node-machine','--shadow','--window-rows','--passes','0','--list','0',*flags,str(p)],capture_output=True)
        lines=run.stdout.decode().splitlines()
        (out/f'{index}-{label}.log').write_bytes(run.stdout + run.stderr)
        outs.append([l for l in lines if l.startswith(('node-shadow: own tests','node-shadow: window tests expressions=', 'node-shadow: window rows expressions=')) and 'ticks=' not in l])
        if run.returncode:sys.exit(f'{index}-{label}: {run.returncode}')
    if not outs[0] or outs[0]!=outs[1]:sys.exit(f'{index}: comparison differs')
    print(index,','.join(flags) or 'default',len(fs),len(outs[0]))
