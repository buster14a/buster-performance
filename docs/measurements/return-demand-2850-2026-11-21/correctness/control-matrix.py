import hashlib, itertools, json, os, re, subprocess, sys
from pathlib import Path
compiler=Path(sys.argv[1]).resolve()
out=Path(sys.argv[2]).resolve()
out.mkdir(parents=True,exist_ok=True)
source=out/'control-matrix.c'
lines=['typedef struct { int a, b; } Pair;', 'extern _Noreturn void stop(void);', 'extern int external(int);', 'extern int (*indirect)(int);']
for i,(kind,shape,end,swap) in enumerate(itertools.product(range(4),range(7),range(8),range(2))):
    result=['int','void','Pair','_Noreturn void'][kind]
    ret=['return x;','return;','return (Pair){x,1};','return;'][kind]
    left,right=('external(x)','indirect(x)') if swap else ('indirect(x)','external(x)')
    shapes=[
        f'if (x) {{ {ret} }}',
        f'if ({left}) {{ if (x<9) goto end; else {ret} }}',
        f'switch (x) {{ case 1: if ({right}) {ret} break; case 2: goto end; default: if ({left}) stop(); }}',
        f'while ({left}) {{ if ({right}) {ret} if (x==3) goto end; break; }}',
        f'if ({left}) goto *p; if (x) goto end; skip: if ({right}) stop();',
        f'__asm__ goto ("" : : : : end); if ({left}) {ret}',
        f'if (({{ int k={left}; k && {right}; }})) {{ {ret} }}',
    ]
    endings=[f'end: {ret}',f'{ret} end: ;', 'end: stop();', f'end: if ({left}) {{ {ret} }}',f'end: for (;;) {{ if ({right}) {ret} }}',f'end: if (x) stop(); else {ret}',f'end: (void)(x ? {left} : {right});',f'end: if (x) {{ {ret} }} else stop();']
    decl='void *p=x ? &&end : &&skip;' if shape==4 else ''
    lines.append(f'{result} candidate_{i}(int x) {{ {decl} {shapes[shape]} {endings[end]} }}')
source.write_text('\n'.join(lines)+'\n')
result=[]
for options in [[],['-Wall','-Wextra'],['-Wno-return-type']]:
    records=[]
    for mode in ['ordinary','on','verify']:
        env={**os.environ,'BUSTER_RETURN_REPORT':'1'}
        if mode=='ordinary':env.pop('BUSTER_RETURN_DEMAND',None)
        else:env['BUSTER_RETURN_DEMAND']=mode
        obj=out/'unit.o'
        obj.unlink(missing_ok=True)
        r=subprocess.run([compiler,'-c',*options,'-o',obj,source],env=env,capture_output=True)
        err=r.stderr.decode(errors='replace')
        reports=re.findall(r'^return-demand: (.*)$',err,re.M)
        normal=''.join(l for l in err.splitlines(keepends=True) if not l.startswith('return-demand: '))
        rec=dict(mode=mode,status=r.returncode,object=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else None,
                 stderr=hashlib.sha256(normal.encode()).hexdigest(),stdout=hashlib.sha256(r.stdout).hexdigest(),
                 warnings=normal.count('warning:'), errors=normal.count('error:'),reports=reports)
        (out/f'{len(result)}-{mode}.err').write_text(err)
        records.append(rec)
    equal=all(all(r[k]==records[0][k] for k in ['status','object','stderr','stdout']) for r in records)
    result.append(dict(options=options,functions=len(lines)-4,equal=equal,results=records))
    (out/'result.json').write_text(json.dumps(result,indent=2)+'\n')
    print(options,equal,records[1],flush=True)
if not all(r['equal'] and r['results'][1]['status']==0 for r in result):sys.exit(1)
