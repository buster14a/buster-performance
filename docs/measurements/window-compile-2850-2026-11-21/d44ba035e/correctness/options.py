from pathlib import Path
import itertools, subprocess,sys,re
if len(sys.argv) != 4:
    sys.exit("usage: options.py BUSTER_CHECKOUT COMPILER SCRATCH")
r=Path(sys.argv[1]).resolve()
cc=Path(sys.argv[2]).resolve()
d=Path(sys.argv[3]).resolve()
d.mkdir(parents=True,exist_ok=True)
src=r/'tests/checker/node-window-conditions.c'
opts=[['--verify'],['--check-transitions'],['--scalar'],['--poison-arenas'],['--lower-all'],['--tier1'],['--tier1','--tier1-strict'],['--attested=on'],['--attested=verify'],['--attested=off'],['--id-order','7'],['-std=c23','-Werror'],['-g'],['--no-deferred-bodies'],['--deferred-bodies'],['-Werror','-Wno-tautological-compare']]
for i,extra in enumerate(opts):
 out=[]
 for m,mode in enumerate([[],['--node-window'],['--node-window-conditions']]):
  p=d/f'options-{m}.o'
  q=subprocess.run([cc,*mode,'--lanes','1',*extra,'-c',src,'-o',p],capture_output=True)
  out.append((q.returncode,q.stdout,q.stderr,p.read_bytes() if not q.returncode else None))
 assert out[0]==out[1]==out[2],(extra,[(x[0],x[2][-100:]) for x in out])
 p=subprocess.run([cc,'--node-window-conditions','--lanes','1','--time-stages',*extra,'-fsyntax-only',src],capture_output=True)
 cnt=re.search(rb'node-window-conditions: controls=\d+ bounded=\d+ taken=(\d+)',p.stderr)
 print(extra,out[0][0],int(cnt[1]) if cnt else None)
