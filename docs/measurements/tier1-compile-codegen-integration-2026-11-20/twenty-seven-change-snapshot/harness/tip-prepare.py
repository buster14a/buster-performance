from pathlib import Path
import csv,gzip,subprocess,sys
w=Path(__file__).resolve().parent;p=w/'tip-evidence';p.mkdir(exist_ok=True);r=w/'buster';d=w/'tip-candidate';git=lambda tree,*args:subprocess.check_output(['git','-C',tree,*args],text=True).strip()
base=git(w/'late-control','rev-parse','HEAD');control=w/'tip-control'
if not control.exists():control.symlink_to(w/'late-control',target_is_directory=True)
if not d.exists():subprocess.run(['git','-C',r,'worktree','add','--detach',d,base],check=True)
old=list(csv.DictReader((w/'final-evidence/heads.tsv').open(),delimiter='\t'));heads={int(z['pr']):z['commit'] for z in old};heads.update({n:git(w/y,'rev-parse','HEAD') for n,y in [(3144,'unsigned64'),(3145,'region-batch'),(3146,'unsigned32')]})
for head in [git(w/'final-candidate','rev-parse','HEAD'),heads[3145],heads[3146],heads[3144]]:
 if subprocess.run(['git','-C',d,'merge-base','--is-ancestor',head,'HEAD']).returncode:subprocess.run(['git','-C',d,'merge','--no-edit',head],check=True)
head=git(d,'rev-parse','HEAD');(p/'control.txt').write_text(base+'\n');(p/'candidate.txt').write_text(head+'\n')
with (p/'heads.tsv').open('w') as f:q=csv.writer(f,delimiter='\t',lineterminator='\n');q.writerow(['pr','commit']);q.writerows(sorted(heads.items()))
patch=subprocess.check_output(['git','-C',d,'diff','--full-index','--binary',base,head]);(p/'combined.patch.gz').write_bytes(gzip.compress(patch,mtime=0));subprocess.run(['git','-C',control,'apply','--check','-'],input=patch,check=True)
