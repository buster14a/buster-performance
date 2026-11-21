from pathlib import Path
import os,re,subprocess,csv,hashlib
d=Path(__file__).resolve().parent;r=d/'5dc7d5cca';cc=r/'compiler';orig=d/'a60859270/compiler';f=r/'cases';f.mkdir(exist_ok=True);envs=[{}, {'BUSTER_REGULAR_WINDOW_UNIT_SEEDS':'1'},{'BUSTER_REGULAR_WINDOW_UNIT_SEEDS':'1','BUSTER_REGULAR_WINDOW_MARK_ENDS':'1'}]
def h(b):return hashlib.sha256(b).hexdigest()
with (r/'focused.tsv').open('w') as o:
 t=csv.writer(o,delimiter='\t',lineterminator='\n');t.writerow(['case','policy','status','admitted','replaced','matching_stages','matching_objects','matching_diagnostics','elf'])
 exprs=['2','-2','( 2 )','+x','x','2 * 3','(2 * 3)','x + 1','0x2','077','0x1U']
 voids=['(void)2','((void)(2))','(void)((2))','(void)((((((2))))))','(void)(2+3)','(int)(2)','(void)((x))','(void) + 1','(void)0x2U','((void)2, x)','(void)"lit"']
 for n in range(132):
  if n<110: pad=n*3
  else: pad=(n-110)*127
  x=f/'source.c';x.write_text('int f(int x){'+('x++;'*pad)+'{'+voids[n%len(voids)]+';} return '+exprs[n%len(exprs)]+';}\nint g(int x){if(x) return 5 + 5; (void)7;return x;}\n')
  for pol,opts in [('plain',[]),('debug',['-g']),('warnings',['-Wall','-Wextra']),('tier1',['--tier1'])]:
   rows=[]
   for i,over in enumerate(envs):
    obj=f/(str(i)+'.o');b=orig if i==0 else cc;cmd=[b,'--lanes','1','--node-window','-c',*opts,str(x),'-o',str(obj)]
    q=subprocess.run(cmd,env={**os.environ,**over},capture_output=True);assert q.returncode==0,(cmd,q.stderr[:320])
    e=subprocess.run(cmd+['--time-stages'],env={**os.environ,**over},capture_output=True);assert e.returncode==0
    m=re.search(rb'^node-window: taken=(\d+) ordinary-nodes-replaced=(\d+) summary-nodes=(\d+) graph-nodes=(\d+)',e.stderr,re.M)
    rows.append((tuple(map(int,m.groups())) if m else (),h(obj.read_bytes()),h(q.stderr),q.returncode))
   eq=[len({z[k] for z in rows})==1 for k in range(3)];t.writerow([n,pol,rows[0][3],*((rows[0][0][:2]) if rows[0][0] else (0,0)),*eq,rows[0][1]])
   assert all(eq),(n,pol,rows);o.flush()
