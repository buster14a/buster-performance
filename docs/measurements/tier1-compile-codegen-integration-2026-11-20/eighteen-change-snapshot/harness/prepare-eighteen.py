from pathlib import Path
import csv,subprocess,shutil
w=Path(__file__).resolve().parent;p=w/'eighteen-evidence';p.mkdir(exist_ok=True);base='3804c5e7b9468772d22209774843f06aabd70990'
def git(repo,*args):return subprocess.check_output(['git','-C',repo,*args],text=True).strip()
heads=list(csv.DictReader((w/'fifteen-evidence/heads.tsv').open(),delimiter='\t'))
for n,t in [(3134,'x87-constants'),(3135,'visible-regions'),(3136,'x87-pool')]:heads.append({'pr':str(n),'commit':git(w/t,'rev-parse','HEAD')})
with (p/'heads.tsv').open('w') as f:
 t=csv.DictWriter(f,fieldnames=['pr','commit'],delimiter='\t',lineterminator='\n');t.writeheader();t.writerows(heads)
with (p/'merges.log').open('w') as log:
 def run(repo,*args):subprocess.run(['git','-C',repo,*args],check=True,stdout=log,stderr=log)
 for v in ['control','candidate']:run(w/'buster','worktree','add','--detach','../eighteen-'+v,base)
 s=w/'eighteen-candidate'
 for row in heads:run(s,'merge','--no-edit',row['commit'])
 head=git(s,'rev-parse','HEAD');run(w/'buster','worktree','add','--detach','../eighteen-asan',head)
(p/'control.txt').write_text(base+'\n');(p/'candidate.txt').write_text(head+'\n')
for name in ['build.sh','qualify.sh','sanitize.sh','compare-common.py']:
 a=w/'fifteen-evidence'/name;s=a.read_text().replace('fifteen','eighteen').replace('pull/3133','pull/3136');(p/name).write_text(s)
