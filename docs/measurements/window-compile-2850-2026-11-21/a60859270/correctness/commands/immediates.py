"""Check regular builtin-immediate consumers both when a folded integer is permitted and when it is rejected."""
from pathlib import Path
import subprocess,csv,hashlib,sys,re
d=Path(__file__).resolve().parent;r=d/sys.argv[1]/'immediates';r.mkdir(exist_ok=True);cc=d/sys.argv[1]/'compiler';parent=d/'b86eadcbd-compiler';clang=Path('~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
forms=['void f(char*p){__builtin_prefetch(p,E,F);}','void *f(void){return __builtin_frame_address(E);}','void *f(void){return __builtin_return_address(E);}','int f(void){return __builtin_eh_return_data_regno(E);}','unsigned long f(char*p){return __builtin_object_size(p,E);}','unsigned long f(char*p){return __builtin_dynamic_object_size(p,E);}','void *f(char*p){return __builtin_assume_aligned(p,E);}','extern void use(void*);void f(void){use(__builtin_alloca_with_align(16,E));}']
nums=[('((4>>2)&1)','(3&3)'),('((0>>2)&1)','(2|1)'),('(2+1)','(2+3)'),('(2-2)','(2-5)'),('(8+8)','(2&3)'),('(15+1)','(255+1)'),('(1/0)','(4-1)'),('(2-4)','(4+4)'),('(2+0x20)','(0x40|3)')]
flags=[[],['-g'],['-Wall','-Wextra'],['-Weverything'],['-Wall','-Wextra','-Werror'],['-w']]
digest=lambda b:hashlib.sha256(b).hexdigest()
with (r/'cases.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['builtin','expression','policy','status','diagnostics','object','all_equal','clang_same_status'])
 for i,form in enumerate(forms):
  for j,(e,g) in enumerate(nums):
   src=r/(str(i)+'-'+str(j)+'.c');src.write_text(form.replace('E',e).replace('F',g)+'\n')
   for k,policy in enumerate(flags):
    vals=[]
    for m,exe,opts in [('parent',parent,[]),('plain',cc,[]),('option',cc,['--node-window-constants']),('clang',clang,[])]:
     o=r/(m+'.o');o.unlink(missing_ok=True);p=subprocess.run([exe,*opts,*policy,'-c',src,'-o',o],capture_output=True);vals.append([p.returncode,digest(p.stderr),digest(o.read_bytes()) if o.exists() else ''])
    w.writerow([i,j,k,*vals[0],vals[0]==vals[1]==vals[2],vals[0][0]==vals[3][0]]);f.flush()
