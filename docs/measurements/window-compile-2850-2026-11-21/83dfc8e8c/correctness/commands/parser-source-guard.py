from pathlib import Path
import subprocess,csv,os,itertools,hashlib,re
d=Path(__file__).resolve().parent;r=d/'83dfc8e8c';out=r/'source-map';out.mkdir(exist_ok=True);cc=r/'compiler';parent=r/'parent';legacy=d/'816f2e5d3/window-constants-merge-train/compiler';tree=d.parent/'window-constants';fixture=tree/'tests/checker/node-window-constants.c';h=lambda b:hashlib.sha256(b).hexdigest();policies=[[],['-g'],['-Wall','-Wextra'],['-g','--poison-arenas'],['--tier1'],['--attested=verify','--verify','--poison-arenas']]
with (out/'cases.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['case','map','policy','status_equal','diagnostics_equal','object_equal','hash','roots','removed'])
 for i,(op,lhs,rhs) in enumerate(itertools.product(['+','|','&','-','^'],['0x20','055','0x3ff','0755','2147483647','0x1p-3','0xbeefU'],['0','0x7','01','0x40'])):
  for m in ['identity','pragma','colon']:
   head={'identity':'','pragma':'#pragma clang diagnostic ignored "-Wunused-variable"\n','colon':'[[gnu::unused]] static int dummy;\n'}[m]
   file=out/'case.c';s=head+'#define L ('+lhs+')\n#define R ('+rhs+')\nint test(int x) { return x + (L '+op+' R); }\n';file.write_text(s)
   for j,opts in enumerate(policies):
    results=[]
    for name,b,flags in [('parent',parent,[]),('plain',cc,[]),('option',cc,['--node-window-constants'])]:
     obj=out/'case.o';obj.unlink(missing_ok=True);cmd=[b,'--lanes','1','-c',*opts,*flags,file,'-o',obj];q=subprocess.run(cmd,capture_output=True);results.append([q.returncode,h(q.stderr),h(obj.read_bytes()) if obj.exists() else ''])
    equal=[len({x[i] for x in results})==1 for i in range(3)];assert all(equal),(i,m,j,results,s)
    a=subprocess.run([cc,'--lanes','1','--time-stages','--node-window-constants','-c',*opts,file,'-o',out/'case.o'],capture_output=True)
    mat=re.search(rb'^constant-window: roots=(\d+) removed=(\d+)',a.stderr,re.M);v=map(int,mat.groups()) if mat else (0,0)
    w.writerow([i,m,j,*equal,results[0][2],*v]);f.flush()
 # Preserve clean negative and positive controls on exactly the declared source. The old image lacks the feature branch's test-only preprocessor switch.
 with (out/'original-regression.tsv').open('w') as g:
  wr=csv.writer(g,delimiter='\t',lineterminator='\n');wr.writerow(['map','mode','status','roots','removed','object'])
  for m,flags in [('identity',[]),('pragma',['-DWINDOW_REMAPPED_SOURCE'])]:
   for n,b in [('before',legacy),('after',cc)]:
    obj=out/(m+'-'+n+'.o');q=subprocess.run([b,'--lanes','1','--node-window-constants','--time-stages','-g','-c',*flags,fixture,'-o',obj],capture_output=True);match=re.search(rb'^constant-window: roots=(\d+) removed=(\d+)',q.stderr,re.M);assert match and q.returncode==0;(out/(m+'-'+n+'.diag')).write_bytes(q.stderr);wr.writerow([m,n,q.returncode,*[int(x) for x in match.groups()],h(obj.read_bytes())])
