from pathlib import Path
import csv,hashlib,subprocess,difflib,re
from collections import Counter
p=Path(__file__).resolve().parent;ev=p.parent;w=p.parents[1];d=p/'recheck';d.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';opts={'generic':['-march=x86-64'],'v3':['-march=x86-64-v3'],'znver5':['-march=znver5'],'v4':['-march=x86-64-v4'],'v4-no-f':['-march=x86-64-v4','-mno-avx512f']}
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
data=list(csv.DictReader((ev/'results.tsv').open(),delimiter='\t'));rows=[]
for r in data:
 name,mode,v=r['target'],r['schedule'],r['compiler'];f=d/(name+'-'+mode+'-'+v+'.o');exe=f.with_suffix('.exe');compiler={'clang':cc,'parent':w/'eighteen-control/build/compiler','head':w/'unsigned64/build/compiler'}.get(v,w/'unsigned64/build/compiler')
 flags=['-O2',*opts[name]]+(['--tier1','--lanes','1']+(['--tier1-schedule=post'] if mode=='post' else []) if v!='clang' else ['-frounding-math'])
 subprocess.run([compiler,*flags,'-c',ev/'leaves.c','-o',f],check=True);actual=sha(f)
 subprocess.run([cc,'-no-pie',ev/'oracle.o',f,'-o',exe],check=True);o=subprocess.check_output([exe],text=True).strip();assert o==r['oracle']
 changed=actual!=r['object_sha256']
 if changed:
  assert v=='head' and mode=='post' and name in ['znver5','v4']
  def assembly(z):
   lines=subprocess.check_output(['objdump','-d','-Mintel','--no-show-raw-insn',z],text=True).splitlines()[5:]
   return [re.sub(r'^\s*[0-9a-f]+:\s*','',x).strip() for x in lines if x.strip()]
  before=assembly(ev/'checks'/f.name);after=assembly(f);assert Counter(before)==Counter(after)
  (d/(f.stem+'.diff')).write_text(''.join(difflib.unified_diff([x+'\n' for x in before],[x+'\n' for x in after],fromfile='previous',tofile='measured-costs')))
 rows.append([name,mode,v,actual,r['object_sha256'],o]);print(name,mode,v,'schedule-changed' if changed else 'identical',o,flush=True)
assert len(rows)==25
with (p/'object-recheck.tsv').open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(['target','schedule','compiler','new_sha256','previous_sha256','oracle']);t.writerows(rows)
