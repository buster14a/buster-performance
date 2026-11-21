from pathlib import Path
import hashlib,json,os,subprocess,sys
w=Path(__file__).resolve().parents[1];out=w/'program-control-markers-prod-qa'
parent=w/'program-main-3246'; candidate=w/'program-control-markers-prod'; case_set=sys.argv[1]
source=(w/'return-prod-compare.py').read_text();setup=source[source.index('here='):source.index('h=lambda')];scope={**globals(),'__file__':str(w/'return-prod-compare.py')};exec(setup,scope);cases=scope['cases'];flags=scope['flags'];musl=scope['musl'];lua=scope['lua'];candidate_hash=subprocess.run(['git','-C',candidate,'rev-parse','HEAD'],capture_output=True,text=True,check=True).stdout.strip()
if case_set=='focus':
    cases=[(p.stem+'-'+str(i),[*policy,p]) for p in sorted((w/'program-children-markers-focused').glob('*.c')) for i,policy in enumerate([[],['-Wall','-Wextra'],['--scalar'],['--tier1'],['--tier1','--tier1-no-lifetimes'],['--node-window-assignments']])]
elif case_set=='broad':
    cases=[('lua-'+p.stem,[p]) for p in sorted(lua.glob('*.c'))]
    for d in sorted((musl/'src').iterdir()):
        files=sorted(d.glob('*.c'))
        if files:
            for i in sorted(set([0,len(files)//2,len(files)-1])):cases.append(('musl-'+d.name+'-'+files[i].stem,[*flags,files[i]]))
else:
    cases += [(src.stem,[src]) for src in sorted((w/'program-roots-extra').glob('*.c'))]
    cases += [(name+'-deferred',['--deferred-bodies','--lanes','2','--worker-budget','2',*args]) for name,args in cases if name in ('sqlite','lua-parser','controls-default','rare-statements')]
    cases += [(name+'-'+mode,[mode,*args]) for name,args in cases if name in ['sqlite','lua-vm','musl-printf','matrix-default','rare-statements','controls-wall'] for mode in ['--scalar','--node-window','--node-window-assignments']]
    cases += [('window-statement-rows-'+mode,[mode,out/'statements.c']) for mode in ['--node-window','--node-window-assignments','--scalar']]
    cases += [('for-init-'+mode,[mode,out/'for-init.c']) for mode in ['--node-window','--node-window-assignments','--scalar']]
rows=[];h=lambda b:hashlib.sha256(b).hexdigest()
for name,args in cases:
    arms={}
    for arm,tree in [('parent',parent),('candidate',candidate)]:
        obj=out/(case_set+'.o');obj.unlink(missing_ok=True);r=subprocess.run([tree/'build/compiler','-c','-o',obj,*args],cwd=parent,capture_output=True);arms[arm]=dict(status=r.returncode,object=h(obj.read_bytes()) if obj.exists() else None,stdout=h(r.stdout),stderr=h(r.stderr));(out/(name+'-'+arm+'.err')).write_bytes(r.stderr)
    ok=arms['parent']==arms['candidate'];rows.append(dict(case=name,equal=ok,arms=arms))
    if not ok:print('difference',name,arms,flush=True)
    (out/(case_set+'.json')).write_text(json.dumps(dict(candidate=candidate_hash,rows=rows),indent=2)+'\n')
print(f'{len(rows)} cases; {sum(r["equal"] for r in rows)} exact status, object and diagnostics; {sum(r["arms"]["parent"]["status"]==0 for r in rows)} compiled',flush=True)
sys.exit(not all(r['equal'] for r in rows))
