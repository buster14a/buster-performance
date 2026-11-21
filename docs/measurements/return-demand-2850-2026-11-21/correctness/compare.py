import os, subprocess, sys, json, hashlib, re
from pathlib import Path
# Arguments: Buster checkout with built compiler; inputs containing sqlite/, inputs/lua-5.4.8,
# libc/musl and musl-generated; a native predefines.h for main.c; new output directory.
tree=Path(sys.argv[1]).resolve()
cc=tree/'build/compiler'
corpus=Path(sys.argv[2]).resolve()
predefines=Path(sys.argv[3]).resolve()
sqlite=corpus/'sqlite'
lua=corpus/'inputs/lua-5.4.8/src'
musl=corpus/'libc/musl'
out=Path(sys.argv[4]).resolve()
out.mkdir(parents=True,exist_ok=True)
obj=out/'unit.o'
musl_flags=['-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700']
for d in [musl/'arch/x86_64', musl/'arch/generic',corpus/'musl-generated/obj/src/internal',musl/'src/include',musl/'src/internal',corpus/'musl-generated/obj/include',musl/'include']:
    musl_flags.extend(['-I',str(d)])
cases=[
    ('sqlite',['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(sqlite),sqlite/'sqlite3.c']),
    ('lua-vm',[lua/'lvm.c']),('lua-parser',[lua/'lparser.c']),
    ('musl-printf',[*musl_flags,musl/'src/stdio/vfprintf.c']),
    ('musl-malloc',[*musl_flags,musl/'src/malloc/mallocng/malloc.c']),
    ('controls-default',[Path(__file__).resolve().parent/'controls.c']),('controls-wall',['-Wall','-Wextra',Path(__file__).resolve().parent/'controls.c']),
    ('controls-no-return',['-Wno-return-type',Path(__file__).resolve().parent/'controls.c']),
    ('compiler-main',['-march=native','-Isrc','-fwrapv','-funsigned-char','--predefines',predefines,'src/buster/compiler/main.c'])]
rows=[]
for name,args in cases:
    modes={}
    for mode in ['ordinary','on','verify']:
        if obj.exists():obj.unlink()
        env={**os.environ,'BUSTER_RETURN_REPORT':'1'}
        if mode!='ordinary':env['BUSTER_RETURN_DEMAND']=mode
        else:env.pop('BUSTER_RETURN_DEMAND',None)
        r=subprocess.run([cc,'-c','-o',obj,*args],cwd=tree,env=env,capture_output=True)
        err=r.stderr.decode(errors='replace')
        (out/f'{name}-{mode}.err').write_text(err)
        stages=re.findall(r'^return-demand: (.*)$',err,re.M)
        normal=''.join(l for l in err.splitlines(keepends=True) if not l.startswith('return-demand: '))
        modes[mode]=dict(status=r.returncode,stdout=r.stdout.hex(),stderr=hashlib.sha256(normal.encode()).hexdigest(),object=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else None,stages=stages)
    keys=['status','stdout','stderr','object']
    equal=all(all(modes['ordinary'][k]==v[k] for k in keys) for v in modes.values())
    print(name,equal,modes['ordinary']['status'],modes['on']['stages'],flush=True)
    rows.append(dict(name=name,same=equal,modes=modes))
    (out/'rows.json').write_text(json.dumps(rows,indent=2)+'\n')
if not all(r['same'] and r['modes']['on']['status']==0 for r in rows): sys.exit(1)
