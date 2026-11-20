import csv,hashlib,json,os,re,statistics,subprocess,sys
from pathlib import Path
d=Path(__file__).resolve().parent;w=d.parent;cwd=w/'compile-evidence'
src='inputs/sqlite3.c'
common=['--tier1','-O2','--lanes','1','-w','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION']
configs={
    'zn-default':('znver5',None,None),
    'zn-64':('znver5','+vectorize','64'),
    'zn-32':('znver5','+vectorize','32'),
    'zn-16':('znver5','+vectorize','16'),
    'x64-default':('x86-64',None,None),
    'x64-16':('x86-64','+vectorize',None),
    'zn-noinline-default':('znver5','-inline',None),
    'zn-noinline-64':('znver5','-inline,+vectorize','64'),
    'zn-noinline-16':('znver5','-inline,+vectorize','16'),
    'x64-noinline-default':('x86-64','-inline',None),
    'x64-noinline-16':('x86-64','-inline,+vectorize',None)}
root=d/'runs';root.mkdir(exist_ok=True)
def sha(p):
    with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def run(key,variant,iteration,traced=False):
    arch,passes,cap=configs[key]
    name=f'{key}-{variant}-{iteration}'+('-trace' if traced else '')
    saved=root/(name+'.sha');stat=root/(name+'.stat');log=root/(name+'.log')
    if saved.exists():return
    exe=w/('width-profile' if variant=='probe' else 'nov20-main-control')/'build/compiler'
    env=dict(os.environ,LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
    if cap and variant=='probe':env['BUSTER_2831_WIDTH']=cap
    if traced:env['BUSTER_2831_TRACE']='1'
    flags=common+['-march='+arch]+(['--tier1-passes='+passes] if passes else [])
    obj=root/(key+'-'+variant+'.o')
    command=[exe,*flags,'--tier1-report','-c',src,'-o',obj]
    rc=subprocess.run(['perf','stat','--no-big-num','-x',';','-e','instructions:u,cycles:u,task-clock','-o',stat,'--',*command],cwd=cwd,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    log.write_bytes(rc.stdout+rc.stderr);rc.check_returncode()
    if traced:assert b'W\t' in rc.stderr and b'sqlite3VdbeExec\t' in rc.stderr,name
    saved.write_text(sha(obj)+'\n')
mode=sys.argv[1]
if mode=='probe':
    keys=list(configs)
    for rep in range(5):
        for i in range(len(keys)):run(keys[(i+3*rep)%len(keys)],'probe',rep)
    for rep in range(2):
        for i in range(len(keys)):run(keys[(i+5*rep)%len(keys)],'probe',rep,True)
elif mode=='control':
    keys=['zn-default','zn-64','x64-default','x64-16','zn-noinline-default','zn-noinline-64','x64-noinline-default','x64-noinline-16']
    for rep in range(5):
        for i in range(len(keys)):run(keys[(i+3*rep)%len(keys)],'control',rep)
else:raise ValueError(mode)
