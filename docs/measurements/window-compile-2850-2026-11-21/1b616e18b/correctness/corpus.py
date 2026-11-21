from pathlib import Path
import subprocess,shlex,hashlib,os,csv,sys
d=Path(__file__).resolve().parent
src=Path(os.environ['BUSTER_CORPUS_ROOT']).resolve()
cc=Path(os.environ['CALL_CC']).resolve()
suffix=os.environ.get('CALL_RUN','actual')
manifests={}
for corpus in sys.argv[1:]:
 var=corpus+'_arguments'
 raw=subprocess.check_output(['bash','-c','source "$BUSTER_CORPUS_SCRIPT"; printf %s "$'+var+'"'],cwd=src,text=True,env=dict(os.environ,BUSTER_CORPUS_SCRIPT=str(d/"corpora.sh")))
 allargs=shlex.split(raw)
 flags=[a for a in allargs if not a.endswith('.c')]
 files=[a for a in allargs if a.endswith('.c')]
 dest=d/(corpus+'-'+suffix);dest.mkdir(exist_ok=True)
 with (dest/'results.tsv').open('w',buffering=1) as f:
  w=csv.writer(f,delimiter='\t',lineterminator='\n')
  w.writerow('unit off_rc on_rc taken diag_equal elf_equal off_sha on_sha'.split())
  for file in files:
   name=Path(file).name;res=[]
   for mode in ('off','on'):
    output=dest/(name+'-'+mode+'.o');output.unlink(missing_ok=True)
    env=os.environ.copy()
    if mode=='on':env.update(BUSTER_DISCARD_PTR='1',BUSTER_CALL_LOG='1')
    r=subprocess.run([cc,'--node-window','--lanes','1','-c',*shlex.split(os.environ.get('BUSTER_PTR_CFLAGS','')),*flags,file,'-o',output],env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    (dest/(name+'-'+mode+'.err')).write_text(r.stderr)
    ds=[l for l in r.stderr.splitlines() if not l.startswith('ptr-row:')]
    res.append((r.returncode,ds,hashlib.sha256(output.read_bytes()).hexdigest() if output.is_file() else '-',len(r.stderr.splitlines())-len(ds)))
   a,b=res;w.writerow((name,a[0],b[0],b[3],int(a[1]==b[1]),int(a[2]==b[2]),a[2],b[2]))
