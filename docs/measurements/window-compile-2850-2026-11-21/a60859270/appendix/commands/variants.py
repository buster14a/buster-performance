from pathlib import Path
import sys,subprocess,csv,hashlib
d=Path(__file__).resolve().parent;r=d/sys.argv[1];res=r/'variants';res.mkdir(exist_ok=True);c=r/'compiler';p=d/'b86eadcbd-compiler';t=d.parent/'window-constants'
tiny=[t/'tests/checker/node-window-constants.c',d.parent/'pure-interior-study/fixture.c',r/'runtime/runtime.c',t/'tests/driver/unused_comparison_failed_assertions.c']
tiny+=sorted((d.parent/'pure-interior-study/f5e195416/random/inputs').glob('*.c'))[::5]
forms=[['-S'],['-S','-g','--tier1'],['-c','--tier1'],['-c','--tier1','--tier1-strict'],['-c','--tier1','--verify','-g'],['-fsyntax-only','--deferred-bodies','--lanes','2'],['-c','--attested=on','-flazy-system-headers','-g'],['-S','--poison-arenas','--shared-parts'],['-c','--dump-static']]
h=lambda b:hashlib.sha256(b).hexdigest()
with (res/'cases.tsv').open('w') as fp:
 a=csv.writer(fp,delimiter='\t',lineterminator='\n');a.writerow(['file','mode','policy','status','stdout','stderr','output','equal'])
 for file in tiny:
  for i,policy in enumerate(forms):
   v=[];o=res/'result.out'
   for exe,opt in [(p,[]),(c,[]),(c,['--node-window-constants'])]:
    o.unlink(missing_ok=True);cmd=[exe,*opt,*policy,file,*([] if '-fsyntax-only' in policy else ['-o',o])];cp=subprocess.run(cmd,cwd=t,capture_output=True)
    v.append([cp.returncode,h(cp.stdout),h(cp.stderr),h(o.read_bytes()) if o.exists() else ''])
   a.writerow([file.name,i,' '.join(policy),*v[0],v[0]==v[1]==v[2]]);fp.flush()
