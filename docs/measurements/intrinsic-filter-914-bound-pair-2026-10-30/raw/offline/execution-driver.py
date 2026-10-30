from pathlib import Path
from datetime import datetime,timezone
import json,hashlib,os,subprocess,time,csv,re,traceback
W=Path(__file__).resolve().parent;P=W/'prepare914-offline-analysis-plan-proof.json';T=W/'prepare914-offline-analysis-plan.md'
def sha(p):
 h=hashlib.sha256()
 with Path(p).open('rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return h.hexdigest()
def utc():return datetime.now(timezone.utc).isoformat()
assert sha(P)=='edfdcf2edf1d34914436ed3fe43d82f63758bb920cbc399829e4b179df3d18df'
assert sha(T)=='d003d4c700b652728dc4c9a71b2da9ccd33d7bd270b44d56b52c58bd6c36bdc7'
plan=json.loads(P.read_text());R=Path(plan['future_analysis_root']);abi=json.loads((W/'prepare914-offline-static-abi-proof.json').read_text());ids=json.loads((W/'prepare914-offline-current-identities.json').read_text());rootproof=W/'prepare914-offline-operation.json'
state={'started_at':utc(),'authorization':'Root LOCAL offline GO after154+155 first decisions saved/published and exact frozenplan+independentpeer clear','plan_sha256':sha(P),'plan_text_sha256':sha(T),'root':str(R),'one_attempt_each_maximum':8,'commands':[],'status':'PREFLIGHT','no_target_reads_or_new_captures':True,'no_retries_or_tools_rebuilt':True}
with rootproof.open('x') as f:json.dump(state,f,indent=2);f.write('\n')
def save():rootproof.write_text(json.dumps(state,indent=2)+'\n')
def current_identities():
 values={p:j['sha256'] for p,j in abi['dependency_closure'].items()}
 values.update({j['path']:j['expected_sha256'] for j in ids['identities']})
 values.update(ids['tool_helpers']);values[ids['policy_paths']['cores_script']]=ids['policy_paths']['cores_script_sha256'];values['/usr/bin/bash']=plan['stream_framing_correction']['local_Bash_sha256'];values['/usr/bin/env']=plan['stream_framing_correction']['local_env_sha256']
 values['/etc/ld.so.cache']=ids['local_loader_cache_sha256']
 checks=[]
 for p,h in values.items():
  actual=sha(p);checks.append({'path':p,'expected':h,'actual':actual,'PASS':h==actual});assert h==actual,(p,h,actual)
 assert not Path('/etc/ld.so.preload').exists() and not Path('/usr/lib/glibc-hwcaps').exists()
 for e in plan['file_copy_plan']:
  actual=sha(e['current_source_path']);checks.append({'path':e['current_source_path'],'expected':e['sha256'],'actual':actual,'PASS':actual==e['sha256']});assert actual==e['sha256']
 return checks
try:
 for n in [154,155]:assert json.loads((W/f'review{n}-proof.json').read_text())['publication_pending'] is False
 assert not R.exists();state['preflight_identities']=current_identities()
 flags=set(next(s.split(':',1)[1].split() for s in Path('/proc/cpuinfo').read_text().splitlines() if s.startswith('flags')));assert set(plan['local_host_metadata']['required_v4_flags_present'])<=flags
 assert not os.environ.get('CORES_HELD') and not os.environ.get('CORES_TOPOLOGY')
 state['local_affinity_before']=sorted(os.sched_getaffinity(0));state['stage_started_at']=utc();state['original_source_modes']={e['current_source_path']:oct(Path(e['current_source_path']).stat().st_mode&0o777) for e in plan['file_copy_plan']}
 R.mkdir(mode=0o700)
 staged=[]
 for e in plan['file_copy_plan']:
  src=Path(e['current_source_path']);dst=Path(e['proposed_destination']);assert dst.is_relative_to(R) and not dst.exists();dst.parent.mkdir(parents=True,exist_ok=True,mode=0o700)
  with src.open('rb') as inp,dst.open('xb') as out:
   os.chmod(dst,0o600)
   for b in iter(lambda:inp.read(1024*1024),b''):out.write(b)
  assert sha(dst)==e['sha256'] and dst.stat().st_nlink==1;os.chmod(dst,int(e['proposed_mode'],8));staged.append({'path':str(dst),'sha256':e['sha256'],'bytes':dst.stat().st_size,'mode':oct(dst.stat().st_mode&0o777),'nlink':dst.stat().st_nlink})
 for e in plan['symfs_symlink_plan']:
  dst=Path(e['path']);target=Path(e['target']);assert dst.is_relative_to(R) and target.is_relative_to(R) and target.is_file();dst.parent.mkdir(parents=True,exist_ok=True,mode=0o700);dst.symlink_to(target);assert dst.resolve()==target.resolve()
 for tree in ['data','sources','tools','symfs']:
  for p in sorted((R/tree).rglob('*'),key=lambda p:len(p.parts),reverse=True):
   if p.is_dir() and not p.is_symlink():os.chmod(p,0o500)
  os.chmod(R/tree,0o500)
 for name in ['home','analysis','analysis/base','analysis/head']:(R/name).mkdir(mode=0o700,exist_ok=True)
 state['staged_files']=staged;state['symfs_aliases']=plan['symfs_symlink_plan'];state['stage_completed_at']=utc();state['status']='READY_EXACT_8_COMMANDS';save()
 def parse_ticket(path):return dict(s.split('=',1) for s in path.read_text().splitlines() if '=' in s)
 def find_ticket(pid):
  for d in ['running','waiting']:
   for p in Path('/run/user/1000/cores',d).glob('*'):
    try:j=parse_ticket(p)
    except (FileNotFoundError,PermissionError):continue
    if j.get('pid')==str(pid):return {'directory':d,'ticket':p.name,'metadata':j}
  return None
 for command in plan['commands_in_order']:
  assert all(not Path(command[k]).exists() for k in ['stdout_new_exclusive_path','stderr_new_exclusive_path','queue_stdout_new_exclusive_path','queue_stderr_new_exclusive_path'])
  entry={'id':command['id'],'started_at':utc(),'exact_outer_argv':command['exact_proposed_queue_timeout_argv'],'exact_child_argv':command['argv'],'exact_child_environment':command['exact_child_environment'],'status':'STARTING_ONE_ATTEMPT','attempt':1,'streams':{k:command[k] for k in ['stdout_new_exclusive_path','stderr_new_exclusive_path','queue_stdout_new_exclusive_path','queue_stderr_new_exclusive_path']}}
  state['commands'].append(entry);state['status']='RUNNING_'+command['id'];save();started=time.monotonic();ticket_seen=None;child_open=None;grant_seen=None
  with Path(command['queue_stdout_new_exclusive_path']).open('xb') as qo,Path(command['queue_stderr_new_exclusive_path']).open('xb') as qe:
   os.chmod(command['queue_stdout_new_exclusive_path'],0o600);os.chmod(command['queue_stderr_new_exclusive_path'],0o600)
   proc=subprocess.Popen(command['exact_proposed_queue_timeout_argv'],cwd=R,stdin=subprocess.DEVNULL,stdout=qo,stderr=qe);entry['outer_pid']=proc.pid;save()
   while proc.poll() is None:
    ticket=find_ticket(proc.pid)
    if ticket and ticket['directory']=='running' and grant_seen is None:
     grant_seen={'observed_at':utc(),**ticket};entry['grant']=grant_seen;save()
    elif ticket and ticket_seen is None:
     ticket_seen={'observed_at':utc(),**ticket};entry['waiting_ticket']=ticket_seen;save()
    if child_open is None and Path(command['stderr_new_exclusive_path']).exists():
     child_open=time.monotonic();entry['child_streams_open_observed_at']=utc();entry['queue_to_child_streams_open_seconds_includes_startup']=child_open-started
     try:entry['actual_timeout_allowed_cpus']=next(s.split(':',1)[1].strip() for s in Path(f'/proc/{proc.pid}/status').read_text().splitlines() if s.startswith('Cpus_allowed_list:'))
     except (FileNotFoundError,StopIteration):pass
     save()
    time.sleep(0.025)
   rc=proc.wait()
  entry.update(returncode=rc,completed_at=utc(),duration_including_queue_seconds=time.monotonic()-started,active_after_stream_open_observed_seconds=time.monotonic()-child_open if child_open is not None else None,status='RETURNED_REQUIRES_GATES');save()
  assert rc==0,('command nonzero/timeout STOP',command['id'],rc)
  assert entry.get('grant'),('No actual grant metadata retained STOP',command['id'])
  md=entry['grant']['metadata'];assert md['cores']=='1' and md['owner']=='codex-reviewer-914-input-binding' and md['title']==f"#914 new bound pair offline {command['id'].replace('-', ' ',1)}";entry['actual_queue_wait_epoch_seconds']=int(md['granted'])-int(md['queued']);entry['grant_timestamp_resolution_seconds']=1
  child_err=Path(command['stderr_new_exclusive_path']);assert child_err.exists() and child_err.stat().st_size==0,('child diagnostics STOP',command['id'])
  for k,p in entry['streams'].items():
   f=Path(p);assert f.is_file() and not f.is_symlink() and f.stat().st_nlink==1;os.chmod(f,0o600)
  arm,kind=command['id'].split('-',1);source=json.loads((W/f'prepare914-{arm}-arm-proof.json').read_text());out=Path(command['stdout_new_exclusive_path'])
  if kind=='audit':
   a=json.loads(out.read_text());assert a['valid'] and all(a[x]==0 for x in ['lost','lost_samples','throttles','unthrottles']);entry['audit']=a
  elif kind=='primary':
   pids=set();count=0;period=0
   for line in out.read_text().splitlines():
    if not line.strip():continue
    m=re.fullmatch(r'\s*compiler\s+(\d+)/(\d+)\s+(\d+)\s+cycles:u:\s+([0-9a-fA-F]+)\s+.*\([^\n]+\)\s*',line);assert m,('bad primary framing',line[:150]);pid,tid,weight=map(int,m.groups()[:3]);assert pid==tid and weight>0;pids.add(pid);count+=1;period+=weight
   assert pids==set(source['fresh_children']['pids']);entry['primary_identity']={'sampled_exact30_ledger_PIDs':sorted(pids),'samples':count,'total_period':period}
  elif kind=='attribution':
   a=json.loads(out.read_text());coverage=json.loads(Path(command['argv'][-1]+'.coverage.json').read_text());assert a['valid'] and coverage['compiler_processes']==30 and all(a[x]==0 for x in ['lost','lost_samples','throttles','unthrottles'])
   earlier=next(e for e in state['commands'] if e['id']==arm+'-primary')['primary_identity'];assert earlier['samples']==a['compiler_samples'] and earlier['total_period']==a['compiler_cycle_period'];entry['summary']=a;entry['coverage']=coverage
  entry['status']='GATES_PASSED';entry['stream_hashes']={k:sha(p) for k,p in entry['streams'].items()};save();print(json.dumps({'id':command['id'],'completed_at':entry['completed_at'],'returncode':rc,'status':'GATES_PASSED','grant_cpus':md['cpus'],'wait_epoch_seconds':entry['actual_queue_wait_epoch_seconds']}),flush=True)
 state['status']='ALL_8_COMMANDS_COMPLETE_PENDING_INDEPENDENT_REDUCTION';state['post_identities']=current_identities()
 assert all(sha(e['proposed_destination'])==e['sha256'] for e in plan['file_copy_plan'])
 assert all(oct(Path(p).stat().st_mode&0o777)==mode for p,mode in state['original_source_modes'].items());state['all_original_modes_unchanged']=True
except BaseException as exc:
 state['status']='STOP_RETAIN_PARTIAL_NO_RETRY';state['failure']=str(exc);state['traceback']=traceback.format_exc()
 try:state['post_failure_identities']=current_identities()
 except BaseException as post:state['post_failure_identity_error']=str(post)
finally:
 state['completed_at']=utc();save();print(json.dumps({'completed_at':state['completed_at'],'status':state['status'],'commands_attempted':len(state['commands']),'failure':state.get('failure')},indent=2),flush=True)
