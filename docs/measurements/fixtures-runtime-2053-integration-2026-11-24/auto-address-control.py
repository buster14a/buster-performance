import tempfile,pathlib as pm,shutil,subprocess as sp
from concurrent.futures import ThreadPoolExecutor
P=pm.Path;root=P.cwd();tmp=P('/tmp/b2053');binary=(tmp/'auto-address-compiler');shutil.copy2(root/'build/compiler',binary)
with tempfile.TemporaryDirectory(prefix='buster-alternate-') as td:
 t=P(td)
 for p in (root/'tests').iterdir():
  if p.name!='driver':(t/p.name).symlink_to(p)
 (t/'driver').mkdir()
 for p in (root/'tests/driver').iterdir():
  if p.name!='auto-address':(t/'driver'/p.name).symlink_to(p)
 d=t/'driver/auto-address';shutil.copytree(root/'tests/driver/auto-address',d)
 cat=d/'catalog.tsv';original=cat.read_bytes();cat.write_bytes(original+b'invalid-data-root-probe\n')
 def run(n):
  args=[str(binary),'test-checker-driver','--executable',str(binary),'--in-process','--part',f'{n}/16','--fixtures',str(t)]
  r=sp.run(args,stdout=sp.PIPE,stderr=sp.STDOUT)
  alt=(str(d)+'/catalog.tsv').encode() in r.stdout
  if alt:
   (tmp/'auto-address-invalid.log').write_bytes(r.stdout)
  print(n,r.returncode,alt,flush=True)
  return n,r.returncode,alt,args
 with ThreadPoolExecutor(3) as ex:results=list(ex.map(run,range(1,17)))
 affected=[row for row in results if row[2]];assert len(affected)==1 and affected[0][1]!=0
 assert all(status==0 or alt for _,status,alt,_ in results)
 cat.write_bytes(original);r=sp.run(affected[0][3],stdout=sp.PIPE,stderr=sp.STDOUT);(tmp/'auto-address-restored.log').write_bytes(r.stdout);print('restored',affected[0][0],r.returncode,flush=True);assert r.returncode==0
