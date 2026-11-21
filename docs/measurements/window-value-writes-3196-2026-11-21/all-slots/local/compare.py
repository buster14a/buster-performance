from pathlib import Path
import subprocess, os, sys, json, re
# Arguments: ordinary buster checkout; candidate binary; corpus root containing sqlite/, libc/musl,
# musl-generated/, inputs/lua-5.4.8; output folder. Both compilers should be Develop native builds.
tree=Path(sys.argv[1]).resolve()
candidate=Path(sys.argv[2]).resolve()
input_dir=Path(sys.argv[3]).resolve()
out=Path(sys.argv[4]).resolve()
out.mkdir(parents=True, exist_ok=True)
report=[]
args={}
s=input_dir/'sqlite'
args['sqlite']=['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(s),s/'sqlite3.c']
args['lua']=sorted((input_dir/'inputs/lua-5.4.8/src').glob('*.c'))
m=input_dir/'libc/musl'
seen={}
for f in [*sorted(m.glob('src/*/*.c')), *sorted(m.glob('src/*/x86_64/*.c'))]:
    seen.setdefault(f.name, f)
args['musl']=['-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700']
for d in [m/'arch/x86_64',m/'arch/generic',input_dir/'musl-generated/obj/src/internal',m/'src/include',m/'src/internal',input_dir/'musl-generated/obj/include',m/'include']:
    args['musl'].extend(['-I',d])
args['musl'].extend(seen.values())
args['main']=['-march=native','-Isrc','-fwrapv','-funsigned-char','--predefines',tree/'build/predefines.h','src/buster/compiler/main.c']

args['controls']=[Path(__file__).resolve().parent/'controls.c']
for label in ['controls','sqlite','lua','musl','main']:
    for name, options in [('default',[]),('wall',['-Wall','-Wextra'])]:
        data=[]
        for revision, compiler in [('ordinary',tree/'build/compiler'),('slots',candidate)]:
            stem=f'{label}-{name}-{revision}'
            target=out/(stem+'.out')
            with target.open('w') as stream,(out/(stem+'.err')).open('w') as errors:
                cmd=[compiler,'measure-node-machine','--shadow','--passes','0','--window-rows',*options,*args[label]]
                ret=subprocess.run(cmd,cwd=tree,stdout=stream,stderr=errors,env={**os.environ,'LC_ALL':'C'})
            raw=target.read_text()
            fields=[l for l in raw.splitlines() if l.startswith('node-shadow: window rows') and 'ticks' not in l]
            data.append((ret.returncode, fields))
        same=data[0]==data[1]
        clean=all('differences=0' in d[1][0] and 'second-runs-that-differ=0' in d[1][0] and 'tapes that differ in a value alone=0' in ' '.join(d[1]) for d in data if d[1])
        report.append(dict(corpus=label,policy=name,same=same,clean=clean,ordinary=data[0],slots=data[1]))
        (out/'result.json').write_text(json.dumps(report,indent=2)+'\n')
        print(label,name,[(d[0],len(d[1])) for d in data],same,clean,flush=True)
if not all(a['same'] and a['clean'] and a['slots'][0]==0 and a['slots'][1] for a in report):sys.exit(1)
