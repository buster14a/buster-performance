from pathlib import Path
import os,json,shutil,hashlib,subprocess
p=Path(__file__).resolve().parent;s=p/'stage';w=p.parents[1]
template=w/'integration-evidence/twelve-native/native-stage'
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
sums=[]
for label,tree in [('base','final-control'),('head','final-candidate')]:
 out=p/(label+'.stripped')
 run('strip','-o',out,w/tree/'build/compiler')
 sums.append(hashlib.file_digest(out.open('rb'),'sha256').hexdigest()+'  compilers/final-'+label)
 run('zstd','-qf','--patch-from='+str(w/'debug-evidence/stage/compilers/debug-base'),out,'-o',s/('final-'+label+'.patch.zst'))
(s/'final.sha256').write_text('\n'.join(sums)+'\n')
for n in ['unpack','confirm']:
 f=s/(n+'-final.sh');script=(template/(n+'-twelve.sh')).read_text().replace('twelve','final')
 if n=='confirm':script=script.replace('sqlite-O2 lua-lparser sqlite-O0 lua-lvm sqlite-tier1','sqlite-O2 lua-lvm sqlite-tier1').replace('round<=7','round<=3')
 f.write_text(script);f.chmod(0o755)
a=p/'native-stage.tar.zst';run('tar','--zstd','-cf',a,'-C',s,'.')
j=dict(title='Check 25 integrated compiler changes on SQLite and the Lua VM on Zen 5',link='https://github.com/buster14a/buster/pull/3144',directory='compile-codex-01a1f5e5',archives=[str(a.relative_to(w))],command='./when-free.sh timeout -k 2 22 ./unpack-final.sh && ./confirm-final.sh',destination='final-evidence/native/results',prefix='final-',extensions=['stat','load','sha256','bytes'],observations=24)
q=w/'native-jobs/09b1-final-integrated.json';tmp=q.with_suffix('.tmp');tmp.write_text(json.dumps(j,indent=2)+'\n');tmp.replace(q)
