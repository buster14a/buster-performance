from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,subprocess,os
W=Path(__file__).resolve().parent;WT=W/'publish914-bound-pair';PACK=WT/'docs/measurements/intrinsic-filter-914-bound-pair-2026-10-30';assert not PACK.exists();PACK.mkdir(parents=True)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
origins=[]
def put(src,dst):
 src=Path(src);dst=PACK/dst;assert src.is_file() and not src.is_symlink() and not dst.exists();dst.parent.mkdir(parents=True,exist_ok=True)
 with dst.open('xb') as f:f.write(src.read_bytes())
 os.chmod(dst,0o644);assert sha(src)==sha(dst);origins.append({'destination':str(dst.relative_to(PACK)),'source':str(src),'sha256':sha(src),'bytes':src.stat().st_size,'source_mode':oct(src.stat().st_mode&0o777),'new_Git_mode':'100644','byte_exact':True})
for arm in ['base','head']:
 for n in ['arm.tsv','compiler-argv.txt','processes.tsv','profile.log','collection.complete']:put(W/f'prepare914-{arm}-raw/{arm}/{n}',f'raw/capture/{arm}/{n}')
 for n in ['audit.json','audit.stderr','primary.stderr','chains.stderr','attribution.stderr','summary.json','proof.csv','proof.csv.coverage.json']:
  put(W/f'offline914-newpair-c6-20261030/analysis/{arm}/{n}',f'analysis/{arm}/{n}')
 for phase in ['audit','primary','chains','attribution']:
  for stream in ['stdout','stderr']:put(W/f'offline914-newpair-c6-20261030/analysis/{arm}/{arm}-{phase}.queue.{stream}',f'raw/offline/{arm}/{phase}.queue.{stream}')
 for tag in ['operation.json','preflight-proof.json','transfer-proof.json']:put(W/f'prepare914-{arm}-{tag}',f'raw/capture/{arm}/{tag}')
put(W/'prepare914-offline-operation.json','raw/offline/operation.json')
put(W/'prepare914-offline-result-manifest.json','raw/offline/result-manifest.json')
put(W/'prepare914-offline-reduction.json','analysis/independent-primary-reduction.json')
put(W/'prepare914-offline-result-proof.json','analysis/primary-result-proof.json')
put(W/'prepare914-offline-result.md','analysis/primary-result-report.md')
put(W/'review914-offline-result-peer-proof.json','analysis/peer-result-proof.json')
put(W/'review914-offline-result-peer.md','analysis/peer-result-report.md')
put(W/'review914-offline-result-peer-reduction.json','analysis/independent-peer-reduction.json')
for src,dst in [('prepare914-offline-reduce.py','tools/primary-data-reducer.py'),('review914-offline-result-peer-reduce.py','tools/peer-data-reducer.py'),('prepare914-offline-run-once.py','raw/offline/execution-driver.py'),('prepare914-offline-analysis-plan.md','plans/offline-plan.md'),('prepare914-offline-analysis-plan-proof.json','plans/offline-plan.json'),('prepare914-offline-current-identities.json','raw/runtime/offline-current-identities.json'),('prepare914-offline-static-abi-proof.json','raw/runtime/offline-static-abi.json'),('prepare914-offline-map-plan-proof.json','raw/capture/COMM-MMAP2-plan-binding.json'),('prepare914-pinfix-artifact-proof.json','raw/hosted/artifact-review-proof.json'),('prepare914-pinfix-abi-proof.json','raw/hosted/artifact-target-ABI.json'),('prepare914-pinfix-artifact-download-proof.json','raw/hosted/artifact-download-proof.json'),('prepare914-pinfix-job.log','raw/hosted/job-124249668470.log'),('prepare914-pinfix-artifacts.json','raw/hosted/artifacts-api.json'),('prepare914-private-stage-proof.json','raw/input-stage/primary-proof.json'),('review914-private-stage-result-peer-proof.json','raw/input-stage/peer-proof.json')]:put(W/src,dst)
for p in sorted((W/'prepare914-private-stage-receipts/stage-meta').iterdir()):
 if p.is_file():put(p,'raw/input-stage/'+p.name)
for p in sorted((W/'prepare914-input-binding/docs/measurements/intrinsic-filter-914-input-binding-2026-10-30').iterdir()):
 if p.is_file():put(p,'controller/'+p.name)
workflow=subprocess.check_output(['git','-C',str(W/'performance'),'ls-tree','-r','--name-only','c6b5391bff3a23d082dd28ef2598b7ea76e53300','.github']).decode().splitlines();assert len(workflow)==1
b=subprocess.check_output(['git','-C',str(W/'performance'),'show','c6b5391bff3a23d082dd28ef2598b7ea76e53300:'+workflow[0]]);p=PACK/'controller/hosted-controller-workflow.yml';p.write_bytes(b);origins.append({'destination':str(p.relative_to(PACK)),'source':'Git:c6b5391bff3a23d082dd28ef2598b7ea76e53300:'+workflow[0],'sha256':sha(p),'bytes':len(b),'new_Git_mode':'100644','byte_exact':True})
A=Path('/home/david/Documents/Codex/2026-10-30/tak-3/work/perf-unwind-914')
put(A/'attribution914.c','tools/attribution914.c');put(A/'reuse_exec.c','tools/reuse_exec.c')
put(W/'review146-packet/corpus/runtime-identity.txt','raw/runtime/recording-runtime-package-reference.txt')
for n in ['README.md','LICENSE','THIRD_PARTY_NOTICES.md']:
 p=PACK/'provenance'/('performance-'+n);p.parent.mkdir(exist_ok=True);b=subprocess.check_output(['git','-C',str(W/'performance'),'show','3aee4aef7ed9618354876eb19f855be0889c371a:'+n]);p.write_bytes(b);origins.append({'destination':str(p.relative_to(PACK)),'source':'Git:3aee4aef7ed9618354876eb19f855be0889c371a:'+n,'sha256':sha(p),'bytes':len(b),'new_Git_mode':'100644','byte_exact':True})
(PACK/'provenance/copied-file-origins.json').write_text(json.dumps({'prepared_at':datetime.now(timezone.utc).isoformat(),'files':origins,'no_original_file_or_mode_changed':True,'no_asset_uploaded_or_branch_pushed':True},indent=2)+'\n')
print(json.dumps({'copied_files':len(origins),'new_packet':str(PACK),'text_bytes':sum(e['bytes'] for e in origins)},indent=2))
