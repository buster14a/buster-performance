from pathlib import Path
import os,subprocess,hashlib
d=Path(__file__).resolve().parent;w=d.parent;r=d/'ablation';r.mkdir(exist_ok=True)
configs=[(mode,i) for i in [174,317,621,1244] for mode in ['skip','only']]+[('all',0)]
for rep in range(3):
    for pos in range(len(configs)):
        mode,i=configs[(pos+3*rep)%len(configs)];name=f'{mode}-{i}-{rep}';obj=r/(name+'.o')
        env=dict(os.environ,BUSTER_2831_TRACE='1',BUSTER_2831_META='1',BUSTER_2831_WIDTH='64',SOURCE_DATE_EPOCH='1792454400',LC_ALL='C')
        if mode!='all':env['BUSTER_2831_'+mode.upper()]=str(i)
        args=[w/'width-profile/build/compiler','--tier1','-O2','-march=znver5','--lanes','1','-w','--tier1-passes=+vectorize','-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION','--tier1-report','-c','inputs/sqlite3.c','-o',obj]
        with (r/(name+'.log')).open('wb') as log:subprocess.run(['perf','stat','--no-big-num','-x',';','-e','instructions:u,cycles:u,task-clock','-o',r/(name+'.stat'),'--',*args],cwd=w/'compile-evidence',env=env,stdout=log,stderr=log,check=True)
        (r/(name+'.sha')).write_text(hashlib.file_digest(obj.open('rb'),'sha256').hexdigest()+'\n')
        if rep:obj.unlink()
