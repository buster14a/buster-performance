import argparse
import hashlib
import os
from pathlib import Path
import subprocess
import tempfile
import time

args=argparse.ArgumentParser()
args.add_argument('mode',choices=['normal','debug'])
args.add_argument('base',type=Path);args.add_argument('head',type=Path)
args.add_argument('destination',type=Path);args.add_argument('prefix')
args.add_argument('--rounds',type=int,default=8);args.add_argument('--inputs',type=Path,default=Path(__file__).resolve().parent/'compile-evidence')
opts=args.parse_args()
raw=opts.destination.resolve()
raw.mkdir(parents=True,exist_ok=True)
compilers={'base':opts.base.resolve(), 'head':opts.head.resolve()}
sqlite=['-DSQLITE_THREADSAFE=0','-DSQLITE_OMIT_LOAD_EXTENSION','inputs/sqlite3.c']
cases={'sqlite-tier1':['--tier1',*sqlite]}
if opts.mode=='normal':
    cases['sqlite-tier0']=sqlite
else:
    for level in ['O2','O0']:
        cases['sqlite-'+level]=['--tier1','-g','-'+level,*sqlite]
for source in ['lvm','lparser']:
    cases['lua-'+source]=(['-g'] if opts.mode=='debug' else [])+['--tier1','-std=gnu99','-DLUA_COMPAT_5_3','-DLUA_USE_LINUX','inputs/lua/'+source+'.c']
def mark():
    return time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime())+'\n'+Path('/proc/loadavg').read_text()
with tempfile.TemporaryDirectory(dir='/dev/shm') as folder:
    for round_no in range(opts.rounds+1):
        names=list(cases)
        for i in range(len(names)):
            name=names[(round_no+i)%len(names)]
            args=cases[name]
            for variant in (['base','head'] if (round_no+i)%2==0 else ['head','base']):
                prefix=raw/f'{opts.prefix}-{round_no}-{variant}-{name}'
                obj=Path(folder)/'code.o'
                started=mark()
                cmd=['perf','stat','--no-big-num','-x',';','-e','cycles:u,instructions:u,branches:u,branch-misses:u,task-clock','-o',str(prefix)+'.stat','--',str(compilers[variant]),'-O2','-march=znver5','--lanes','1','-w',*args,'-c','-o',str(obj)]
                subprocess.run(cmd,cwd=opts.inputs,check=True,env=dict(os.environ,LC_ALL='C',SOURCE_DATE_EPOCH='1792454400'))
                Path(str(prefix)+'.load').write_text(started+mark())
                data=obj.read_bytes()
                Path(str(prefix)+'.sha256').write_text(hashlib.sha256(data).hexdigest()+'\n')
                Path(str(prefix)+'.bytes').write_text(str(len(data))+'\n')
