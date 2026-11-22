import csv,gzip,hashlib,os,subprocess,sys,tempfile
from pathlib import Path
qa=Path(sys.argv[1]);g,ref,exp=sys.argv[2:5]
flags=[];files=[];take_next=False
for v in sys.argv[5:]:
    if v.endswith('.c') and not take_next:files.append(v)
    else:flags.append(v)
    take_next=v in ('--predefines','-I','-isystem','-include')
assert files
streams=qa/'streams';streams.mkdir(exist_ok=True)
def digest(raw):return hashlib.sha256(raw).hexdigest()
def stream(raw):
    key=digest(raw);f=streams/(key+'.gz')
    if not f.exists():f.write_bytes(gzip.compress(raw,mtime=0))
    return key
with (qa/(g+'.tsv')).open('w') as table,tempfile.TemporaryDirectory(dir=qa) as run:
    out=Path(run)/'test.o'; w=csv.writer(table,delimiter='\t',lineterminator='\n')
    w.writerow(('policy','file','same','code','object','stdout','stderr','reference_code','reference_object','reference_stdout','reference_stderr'))
    for policy,options in [('default',[]),('wall',['-Wall','-Wextra']),('all',['-Weverything','-Wno-c++-compat'])]:
        for f in files:
            receipts=[]
            for cc in ref,exp:
                out.unlink(missing_ok=True)
                r=subprocess.run([cc,'-c','--lanes','1',*options,*flags,f,'-o',str(out)],capture_output=True,timeout=90)
                receipts.append((r.returncode,digest(out.read_bytes()) if out.exists() else '-',stream(r.stdout),stream(r.stderr)))
            a,b=receipts;w.writerow([policy,f,int(a==b),*b,*a])
            if a!=b:print('DIFF',policy,f,a,b,flush=True)
        table.flush()
