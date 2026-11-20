from pathlib import Path
import csv,hashlib,itertools,os,resource,shutil,subprocess,time
p=Path(__file__).resolve().parent;w=p.parents[1];src=p/'lua-5.4.8/src';tests=p/'lua-5.4.8-tests';cc=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang');env=dict(os.environ,SOURCE_DATE_EPOCH='1792454400',LC_ALL='C')
resource.setrlimit(resource.RLIMIT_CORE,(0,0))
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def run(*a,**kw):return subprocess.run(list(map(str,a)),env=env,check=True,**kw)
def table(n,h,r):
    with (p/n).open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(h);t.writerows(r)
units=sorted(f for f in src.glob('*.c') if f.name not in ('luac.c','onelua.c'));assert len(units)==33
objs=[];exes=[];checks=[]
for mode in ['release','internal']:
    for v,c in [('clang',cc),('control',w/'final-control/build/compiler'),('candidate',w/'final-candidate/build/compiler')]:
        dest=p/(mode+'-'+v);dest.mkdir(exist_ok=True);suite=dest/'suite'
        if not suite.exists():shutil.copytree(tests,suite)
        fs=units+([tests/'ltests/ltests.c'] if mode=='internal' else [])
        flags=['-O2','-std=gnu99','-DLUA_COMPAT_5_3','-DLUA_USE_LINUX','-march=znver5','-w','-I',src]
        if mode=='internal':flags+=['-DLUA_USER_H="ltests.h"','-I',tests/'ltests']
        bflags=[] if v=='clang' else ['--tier1','--lanes','1']
        with (dest/'build.log').open('w') as log:
            status=0
            for f in fs:
                o=dest/(f.stem+'.o')
                if not o.exists():
                    res=subprocess.run(list(map(str,[c,*bflags,*flags,'-c',f,'-o',o])),stdout=log,stderr=log,env=env)
                    if res.returncode:status=res.returncode;break
                objs.append([mode,v,f.name,sha(f),o.stat().st_size,sha(o)])
            if not status:
                e=dest/'lua';run(cc,'-no-pie','-Wl,-E',*[dest/(f.stem+'.o') for f in fs],'-lm','-ldl','-o',e,stdout=log,stderr=log)
                run('make','-s','-C',suite/'libs','CC='+str(cc),'LUA_DIR='+str(src),stdout=log,stderr=log)
        (dest/'build.status').write_text(str(status)+'\n')
        if status:print(mode,v,'build',status,flush=True);continue
        exes.append([mode,v,len(fs),e.stat().st_size,sha(e)])
        if mode=='release':
            for s in sorted((w/'lua-layout-evidence/scripts').glob('*.lua')):
                output=run(e,s,capture_output=True).stdout;assert output==(w/'lea-evidence/lua-clang'/(s.stem+'.result')).read_bytes()
                checks.append([mode,v,s.name,hashlib.sha256(output).hexdigest()])
        for name in (['basic','full'] if mode=='release' else ['full']):
            log=dest/(name+'.log');args=['-e','_U=true'] if name=='basic' else []
            with log.open('w') as h:
                try:r=subprocess.run(list(map(str,[e,*args,'all.lua'])),cwd=suite,stdout=h,stderr=subprocess.STDOUT,env=env,timeout=420).returncode
                except subprocess.TimeoutExpired:r=124
            (dest/(name+'.status')).write_text(str(r)+'\n')
            print(mode,v,name,r,flush=True)
table('objects.tsv',['configuration','compiler','source','source_sha256','object_bytes','object_sha256'],objs)
table('programs.tsv',['configuration','compiler','units','bytes','sha256'],exes)
table('checks.tsv',['configuration','compiler','program','output_sha256'],checks)
(p/'complete').touch()
