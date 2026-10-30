from pathlib import Path
from datetime import datetime,timezone
import subprocess,tarfile,hashlib,json,io,os
W=Path(__file__).resolve().parent;D=W/'prepare914-public-assets';D.mkdir(mode=0o700,exist_ok=False);R=W/'offline914-newpair-c6-20261030';P=W/'publish914-bound-pair/docs/measurements/intrinsic-filter-914-bound-pair-2026-10-30';TAG='intrinsic-filter-914-bound-pair-2026-10-30-c6b5391b';assets=[]
def sha(p):
 h=hashlib.sha256()
 with Path(p).open('rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return h.hexdigest()
def compress(src,name,expect):
 dst=D/name;started=datetime.now(timezone.utc).isoformat();argv=['/usr/bin/zstd','-q','-T1','-3','-c'];h=hashlib.sha256()
 with dst.open('xb') as out:
  os.chmod(dst,0o600);p=subprocess.Popen(argv,stdin=subprocess.PIPE,stdout=out,stderr=subprocess.PIPE)
  with Path(src).open('rb') as f:
   for b in iter(lambda:f.read(1024*1024),b''):h.update(b);p.stdin.write(b)
  p.stdin.close();err=p.stderr.read();rc=p.wait();assert rc==0 and not err and h.hexdigest()==expect
 dec=subprocess.Popen(['/usr/bin/zstd','-q','-d','-c','--',str(dst)],stdout=subprocess.PIPE,stderr=subprocess.PIPE);h2=hashlib.sha256();size=0
 for b in iter(lambda:dec.stdout.read(1024*1024),b''):h2.update(b);size+=len(b)
 err=dec.stderr.read();assert dec.wait()==0 and not err and h2.hexdigest()==expect
 record={'name':name,'local_path':str(dst),'bytes':dst.stat().st_size,'sha256':sha(dst),'raw_bytes':size,'raw_sha256':expect,'compression_argv':argv,'started_at':started,'completed_at':datetime.now(timezone.utc).isoformat(),'decompression_hash_verified':True,'remote_asset_id':None,'uploaded':False};assets.append(record)
for arm in ['base','head']:
 j=json.loads((W/f'prepare914-{arm}-arm-proof.json').read_text());compress(R/f'data/raw/{arm}/profile.perf.data',f'{arm}-bound-c6.perf.data.zst',j['files']['profile.perf.data']['sha256'])
members=[]
def member(path,name,expected=None):
 path=Path(path);h=sha(path);assert expected is None or h==expected;assert not name.startswith('/') and '..' not in Path(name).parts and len(name.encode())<100 and path.is_file() and not path.is_symlink();members.append({'source_path':str(path),'name':name,'sha256':h,'bytes':path.stat().st_size,'original_source_mode':oct(path.stat().st_mode&0o777),'archive_mode':'0600','uid':0,'gid':0,'mtime':0})
A=Path('/home/david/Documents/Codex/2026-10-30/tak-3/work/pr914-acceptance');source_repo=W/'buster';scratch=D/'licenses';scratch.mkdir()
for arm,rev,expect in [('base','d12fd5831f9c73bb7b30505da2ce9616e915143e','e0bbf2ced14fc4bb38c2073887b0fac5f8bf694789f8c9d71b726db8f292f7bf'),('head','58b1191558fbef0b542cbe92b1e2da329f16d7b6','67d5039a94d367f1d8f9b61ace82fb0b9b0ad699d5360bb4979367c247d85c75')]:
 member(R/f'data/bin/{arm}/compiler',f'decoder-material/bin/{arm}/compiler',expect)
 member(R/f'data/raw/{arm}/sqlite.o',f'decoder-material/output/{arm}/sqlite.o','8fb4adbd900d6e19c3bf5857852a8f5dfaf0f30de74b5cf2796c8a01973940c6')
 member(A/f'matched-buster-binaries/{arm}/compile_commands.json',f'decoder-material/build/{arm}/compile_commands.json')
 for n in ['LICENSE','LICENSING.md','THIRD_PARTY_NOTICES.md']+subprocess.check_output(['git','-C',str(source_repo),'ls-tree','-r','--name-only',rev,'LICENSES']).decode().splitlines():
  data=subprocess.check_output(['git','-C',str(source_repo),'show',rev+':'+n]);f=scratch/arm/n;f.parent.mkdir(parents=True,exist_ok=True);f.write_bytes(data);os.chmod(f,0o600);member(f,f'decoder-material/notices/{arm}/{n}')
 for stream in ['primary.txt','chains.txt']:member(R/f'analysis/{arm}/{stream}',f'decoder-material/streams/{arm}/{stream}')
for path,name,expect in [(R/'tools/attribution914','decoder-material/tools/attribution914','e1bc2b42ee0668ff5077f46bd4e13acbf0f2428913e07da8fbb39f42c88e8038'),(R/'tools/reuse_exec.so','decoder-material/tools/reuse_exec.so','534d7636ea4ae41142c535b5646e2b8d864e2615b53a99a9548e4b7485b4fbc2'),(W/'controller914-c6b5391b-attempt1.zip','decoder-material/controller/hosted-artifact-41110005938.zip','7868fb092b23973ed49d4e17585496c059470cdfaa79a984313f77fd99c96992')]:member(path,name,expect)
# First-party sources/notices accompany the immutable existing reader and adapter bytes.
for path,name in [(P/'tools/attribution914.c','decoder-material/tools/attribution914.c'),(P/'tools/reuse_exec.c','decoder-material/tools/reuse_exec.c'),(P/'provenance/performance-LICENSE','decoder-material/tools/LICENSE')]:member(path,name)
assert len({v['name'] for v in members})==len(members)
assert all(not any(x in v['name'] for x in ['libc.so.6','ld-linux-x86-64.so.2','146','safe-p']) for v in members)
name='new-bound-pair-decoder-material.tar.zst';dst=D/name;argv=['/usr/bin/zstd','-q','-T1','-3','-c'];started=datetime.now(timezone.utc).isoformat()
with dst.open('xb') as out:
 os.chmod(dst,0o600);z=subprocess.Popen(argv,stdin=subprocess.PIPE,stdout=out,stderr=subprocess.PIPE)
 with tarfile.open(mode='w|',fileobj=z.stdin,format=tarfile.USTAR_FORMAT) as tar:
  for v in sorted(members,key=lambda x:x['name']):
   info=tarfile.TarInfo(v['name']);info.size=v['bytes'];info.mode=0o600;info.uid=info.gid=0;info.mtime=0
   with Path(v['source_path']).open('rb') as f:tar.addfile(info,f)
 z.stdin.close();err=z.stderr.read();assert z.wait()==0 and not err
# Verify the newly prepared archive strictly as inert data, without extracting or executing it.
z=subprocess.Popen(['/usr/bin/zstd','-q','-d','-c','--',str(dst)],stdout=subprocess.PIPE,stderr=subprocess.PIPE);found=[]
expected={v['name']:v for v in members}
with tarfile.open(mode='r|',fileobj=z.stdout) as tar:
 for m in tar:
  assert m.isfile() and m.name in expected and m.mode==0o600 and m.uid==m.gid==0 and m.mtime==0 and m.name not in found
  d=tar.extractfile(m).read();assert len(d)==expected[m.name]['bytes'] and hashlib.sha256(d).hexdigest()==expected[m.name]['sha256'];found.append(m.name)
err=z.stderr.read();assert z.wait()==0 and not err and set(found)==set(expected)
assets.append({'name':name,'local_path':str(dst),'bytes':dst.stat().st_size,'sha256':sha(dst),'compression_argv':argv,'started_at':started,'completed_at':datetime.now(timezone.utc).isoformat(),'strict_regular_member_verification':True,'member_count':len(members),'remote_asset_id':None,'uploaded':False})
plan={'prepared_at':datetime.now(timezone.utc).isoformat(),'release_tag_proposed':TAG,'release_created':False,'assets_uploaded':False,'no_reused146_release_asset_or_old_capture':True,'no_old_asset_or_tag_changed':True,'all_new_asset_local_files_inert0600':True,'external_runtime_ELFs_not_redistributed':True,'asset_URL_prefix_proposed':'https://github.com/buster14a/buster-performance/releases/download/'+TAG+'/','assets':assets,'decoder_material_members':members,'compression_tool':{'path':'/usr/bin/zstd','sha256':sha('/usr/bin/zstd'),'single_thread':True},'no_archived_packaging_helper_executed':True,'source_files_and_modes_not_modified':True}
(W/'prepare914-publication-asset-plan.json').write_text(json.dumps(plan,indent=2)+'\n');(P/'release-assets.sha256').write_text(''.join(v['sha256']+'  '+v['name']+'\n' for v in assets));(P/'release-assets.json').write_text(json.dumps(plan,indent=2)+'\n');print(json.dumps({'prepared_at':plan['prepared_at'],'assets':[{k:v[k] for k in ['name','bytes','sha256']} for v in assets],'bundle_members':len(members),'no_upload':True},indent=2))
