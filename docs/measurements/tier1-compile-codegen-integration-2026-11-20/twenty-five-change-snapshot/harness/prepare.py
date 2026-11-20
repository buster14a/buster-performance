from pathlib import Path
import subprocess,csv,gzip,sys
p=Path(__file__).resolve().parent;w=p.parent;repo=w/'buster';dd=w/'final-candidate';base=(w/'eighteen-evidence/control.txt').read_text().strip();control=w/'final-control'
def git(d,*args):return subprocess.check_output(['git','-C',d,*args],text=True).strip()
if not control.exists():control.symlink_to(w/'eighteen-control',target_is_directory=True)
if not dd.exists():subprocess.run(['git','-C',repo,'worktree','add','--detach',dd,(w/'eighteen-evidence/candidate.txt').read_text().strip()],check=True)
heads={int(z['pr']):z['commit'] for z in csv.DictReader((w/'eighteen-evidence/heads.tsv').open(),delimiter='\t')};trees={3120:'convert',3122:'fma',3132:'truncate-load',3138:'x87-double',3139:'fma-addend',3140:'x87-rom',3141:'debug-carriers',3142:'fma-first',3143:'inline-offers',3144:'unsigned64'}
for n,t in trees.items():heads[n]=git(w/t,'rev-parse','HEAD')
with (p/'heads.tsv').open('w') as h:q=csv.writer(h,delimiter='\t',lineterminator='\n');q.writerow(['pr','commit']);q.writerows(sorted(heads.items()))
(p/'control.txt').write_text(base+'\n')
for n in [3120,3122,3132,3138,3139,3140,3141,3142,3143,3144]:
 if subprocess.run(['git','-C',dd,'merge-base','--is-ancestor',heads[n],'HEAD']).returncode:subprocess.run(['git','-C',dd,'merge','--no-edit',heads[n]],check=True)
head=git(dd,'rev-parse','HEAD');(p/'candidate.txt').write_text(head+'\n')
for t in ['asan','msan']:
 dst=w/('final-'+t)
 if not dst.exists():subprocess.run(['git','-C',repo,'worktree','add','--detach',dst,head],check=True)
with (p/'combined.patch').open('wb') as f:subprocess.run(['git','-C',dd,'diff','--binary','--full-index',base,head],stdout=f,check=True)
(p/'combined.patch.gz').write_bytes(gzip.compress((p/'combined.patch').read_bytes(),mtime=0));subprocess.run(['git','-C',control,'apply','--check',p/'combined.patch'],check=True)
for name in ['build.sh','qualify.sh','sanitize.sh','memory.sh','compare-common.py','profile.sh']:
 s=(w/'eighteen-evidence'/name).read_text().replace('eighteen','final').replace('pull/3136','pull/3144')
 (p/name).write_text(s)
