from pathlib import Path
import os,subprocess,shlex,tempfile,csv,hashlib,random,sys,statistics as st
d=Path(__file__).resolve().parent;src=d.parent/'switch-inputs'
args=shlex.split(subprocess.check_output(['bash','-c','source ../switch-local-args.sh; printf %s "$sqlite_arguments"'],cwd=src,text=True))
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
choices=[(cc,m) for cc in sys.argv[2:] for m in ('default','window','calls') if m!='calls' or cc!='parent-release']
with (d/(sys.argv[1]+'.tsv')).open('w',buffering=1) as f,tempfile.TemporaryDirectory() as t:
 temp=Path(t);o=temp/'a.o';stat=temp/'s';w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['round','compiler','mode','user_instructions','user_cycles','branches','branch_misses','faults','object_sha256'])
 for n in range(-1,7):
  random.Random(52635+n).shuffle(choices)
  for cc,m in choices:
   flags={'default':[],'window':['--node-window'],'calls':['--node-window-calls']}[m]
   run=subprocess.run(['perf','stat','-e','instructions:u,cycles:u,branches:u,branch-misses:u,page-faults','-x','\t','-o',stat,'--',d/cc,'--lanes','1',*flags,'-c',*args,'-o',o],capture_output=True);assert run.returncode==0,run.stderr
   h=hashlib.sha256(o.read_bytes()).hexdigest();assert h=='2238999c41e256cc9c14ddbe21e379f0b3c09df25fb642b056e18b8a7ea773a0'
   counts=[line.split('\t')[0] for line in stat.read_text().splitlines() if line and line[0].isdigit()];assert len(counts)==5
   w.writerow([n,cc,m,*counts,h])
