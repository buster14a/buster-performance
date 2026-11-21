from pathlib import Path
import csv,subprocess,shlex,os,sys,random,tempfile,hashlib,re
d=Path(__file__).resolve().parent;src=Path(os.environ["BUSTER_CORPUS_ROOT"]).resolve();cpu=min(os.sched_getaffinity(0));os.sched_setaffinity(0,{cpu})
argv=shlex.split(subprocess.check_output(['bash','-c','source '+shlex.quote(str(d/'corpora.sh'))+'; printf %s "$sqlite_arguments"'],cwd=src,text=True))
choices=[('parent-default','parent-release',[]),('head-default','clean-release',[]),('parent-window','parent-release',['--node-window']),('head-window','clean-release',['--node-window']),('head-calls','clean-release',['--node-window-calls'])]
with tempfile.TemporaryDirectory() as td,(d/'true-profile.tsv').open('w',buffering=1) as f,(d/'true-stage.tsv').open('w',buffering=1) as sf,(d/'true-stat.tsv').open('w',buffering=1) as stats:
 tmp=Path(td);o=tmp/'unit.o';data=tmp/'perf.data';sw=csv.writer(sf,delimiter='\t',lineterminator='\n');sw.writerow(['round','mode','stage','ms'])
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['round','mode','period','symbol']);tw=csv.writer(stats,delimiter='\t',lineterminator='\n');tw.writerow(['round','mode','instructions','cycles','branches','misses','faults'])
 for n in range(7):
  random.Random(14301+n).shuffle(choices)
  for name,bin,flag in choices:
   cc=d/bin;args=[cc,'--lanes','1',*flag,'-c',*argv,'-o',o]
   rc=subprocess.run(['perf','stat','-x','\t','-o',tmp/'stat','-e','instructions:u,cycles:u,branches:u,branch-misses:u,page-faults','--',*args],check=True,capture_output=True)
   counts=[line.split('\t')[0] for line in (tmp/'stat').read_text().splitlines() if line and line[0].isdigit()];assert len(counts)==5,counts
   tw.writerow([n,name,*counts])
   pr=subprocess.run([cc,'--time-stages',*args[1:]],capture_output=True,check=True,text=True)
   for line in pr.stderr.splitlines():
    m=re.match(r'time-stage\t([^\t]+)\t([.\d]+)\t',line)
    if m:sw.writerow([n,name,*m.groups()])
   if n<5:
    subprocess.run(['perf','record','--no-buildid-cache','--no-buildid','-o',data,'-e','instructions:u','-c','49999','--',*args],stdout=subprocess.DEVNULL,stderr=subprocess.PIPE,check=True)
    # Process the recorded user instruction pointer histogram, including individual inlined regions as present in the executable.
    rep=subprocess.check_output(['perf','report','-i',data,'--stdio','--no-children','--percent-limit','0','--show-total-period','--field-separator','|','-F','period,symbol'],text=True,stderr=subprocess.DEVNULL)
    for line in rep.splitlines():
     m=re.match(r'\s*(\d+)\s*\|\s*(?:\[.\]\s*)?(.+)',line)
     if m:w.writerow([n,name,m[1],m[2].strip()])
    data.unlink(missing_ok=True)
   assert hashlib.sha256(o.read_bytes()).hexdigest()=='2238999c41e256cc9c14ddbe21e379f0b3c09df25fb642b056e18b8a7ea773a0'
