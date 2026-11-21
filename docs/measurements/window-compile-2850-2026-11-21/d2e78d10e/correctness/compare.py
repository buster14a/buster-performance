from pathlib import Path
from itertools import product
import hashlib,os,subprocess,sys,tempfile
out=Path(__file__).resolve().parent
root=out.parent
repo=Path(os.environ.get('WARNING_QA_SOURCE',root/'assignment-opt-in')).resolve()
sources=Path(os.environ.get('WARNING_QA_CORPUS',root/'switch-inputs')).resolve()
base,head=[Path(x).resolve() for x in sys.argv[1:3]]
sql=sources/'sqlite';lua=sources/'inputs/lua-5.4.8/src'
predefines=Path(os.environ.get('WARNING_QA_PREDEFINES',repo/'build/predefines.h')).resolve()
cases={
 'sqlite':(['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I'+str(sql)],sql/'sqlite3.c'),
 'main':(['-march=znver5','-I'+str(repo/'src'),'-fwrapv','-funsigned-char','--predefines',str(predefines)],repo/'src/buster/compiler/main.c'),
 'lua':([],lua/'lvm.c'),
 'literal':([],out/'literal-edges.c'), 'directed':([],out/'reach.c'), 'pragma':([],out/'pragma-reach.c'), 'reject':([],out/'rejected.c')
}
modes={'ordinary':['-c'],'scalar':['-c','--scalar'],'deferred':['-c','--deferred-bodies','--lanes','3'],'syntax':['-fsyntax-only'],'debug':['-g','-c'],'window':['-c','--node-window']}
policies={'default':[],'wall':['-Wall','-Wextra'],'wallerror':['-Wall','-Wextra','-Werror'],'bounds-error':['-Werror=array-bounds'],'silent':['-w'],'uninit':['-Wuninitialized']}
literal='--literal' in sys.argv
facts=literal or '--facts' in sys.argv
def digest(data):
 return hashlib.sha256(data).hexdigest()
with tempfile.TemporaryDirectory() as tmp:
 obj=Path(tmp)/'out.o'
 for case,(flags,source) in cases.items():
  if os.environ.get("ONLY_CASE") and case not in os.environ["ONLY_CASE"].split(","): continue
  if facts:
   from itertools import chain
   combinations=product(('ordinary','deferred') if case!='main' else ('ordinary',), ('default','wall'))
  else:
   combinations=product(('ordinary',) if case in ('sqlite','main','lua') else modes,policies if case not in ('sqlite','main','lua') else ('default','wall','wallerror'))
  for mode,policy in combinations:
   if os.environ.get("ONLY_POLICY") and policy not in os.environ["ONLY_POLICY"].split(","): continue
   results=[]; rows=[] 
   for compiler in (base,head):
    obj.unlink(missing_ok=True)
    cmd=[str(compiler),*modes[mode],*policies[policy],*flags,str(source),'-o',str(obj)]
    if facts: cmd=['gdb','-q','-nx','-batch','-x',str(out/('literal.gdb' if literal else 'facts.gdb')),'--args',*cmd]
    run=subprocess.run(cmd,capture_output=True,cwd=repo)
    if facts:
     r=[line.strip() for line in run.stdout.splitlines() if line.startswith(b'literal-context ' if literal else b'facts nodes ')]
     if not r and case!='reject':
      raise RuntimeError((case,mode,policy,run.stdout[-850:],run.stderr[-850:]))
     results.append((r,obj.read_bytes() if obj.exists() else None));rows.append(r)
    else: results.append((run.returncode,run.stdout,run.stderr,obj.read_bytes() if obj.exists() else None))
   assert results[0]==results[1], (case,mode,policy,rows)
   if facts: print(case,mode,policy,[s.decode() for s in rows[0]],flush=True)
   else:
    rc,stdout,stderr,elf=results[0]
    assert rc==0 or stderr, (case, mode,policy)
    assert mode=='syntax' or rc!=0 or bool(elf),(case,mode,policy)
    print(case,mode,policy,rc,len(stdout),len(stderr),digest(stderr),len(elf) if elf else None,digest(elf) if elf else None,flush=True)
