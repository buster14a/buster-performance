"""Exercise the failed-assertion requirement and optional-notes consumer under folded source operands."""
from pathlib import Path
import subprocess,sys,hashlib,csv,itertools,os
p=Path(__file__).resolve().parent;r=p/sys.argv[1]/'assertion-oracle';r.mkdir(exist_ok=True);parent=p/'b86eadcbd-compiler';orig=p/'5882f7c2a/compiler';fixed=p/sys.argv[1]/'compiler';clang=Path('~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
prefix='#define S(x) _Static_assert(x, "result")\n#define COMPARE(x,y) ((x) == (y))\n#define ONE 1\n'
exprs=['7 < 8','7 >= 8','-1','~0','4 - 4','2 + 3','9 / 4','5 % 3','0x50 ^ 0x50','COMPARE(1,2)','(unsigned)(2 + 1) - 3u','(ONE + 2)','2 / (3 - 3)','(1 << 3)','(4 << -2)','17 >> 3','1 && 0','0 || 1']
parents=['(E,0)','((E) && 0)','(0 && (E))','((E) == ((E) + 1))','((E) != (E))','((E) ^ (E))','((E) ? 0 : 0)','((E) > ((E)+3))','(__builtin_choose_expr(0,(E),0))','(_Generic((E),int: 0, default:(E)))','((sizeof((E))==1) && (E))','(!sizeof((int[(!!(E))+1]){0}))','(((E),1) && 1)']
forms=['S(EXPR);','void f(void) { S(EXPR); }','struct x { int i; S(EXPR); };']
policies=[[],['-g'],['-w'],['-Wall','-Wextra','-Werror'],['-std=c23','-pedantic'],['-Weverything']]
def obs(exe,args,f):
 q=subprocess.run([exe,*args,'-fsyntax-only',f],capture_output=True)
 return q.returncode,hashlib.sha256(q.stderr).hexdigest(),hashlib.sha256(q.stdout).hexdigest()
with (r/'cases.tsv').open('w') as outf:
 w=csv.writer(outf,delimiter='\t',lineterminator='\n');w.writerow(['form','expression','parent','policy','parent_status','before_equal','corrected_equal','clang_same_status'])
 for fi,form in enumerate(forms):
  for j,expr in enumerate(exprs):
   # Keep each operator family as a single compilation. The included assertions still have individual source marks.
   f=r/('case-%d-%02d.c'%(fi,j));f.write_text(prefix+'\n'.join(form.replace('EXPR',pa.replace('E',expr)).replace('void f(void)','void f%d(void)'%i).replace('struct x ','struct x%d '%i) for i,pa in enumerate(parents))+'\n')
   for k,flags in enumerate(policies):
    a=obs(parent,flags,f);b=obs(orig,['--node-window-constants',*flags],f);c=obs(fixed,['--node-window-constants',*flags],f);l=obs(clang,flags,f)
    w.writerow([fi,j,len(parents),k,a[0],a==b,a==c,a[0]==l[0]]);outf.flush()
