from pathlib import Path
import struct,hashlib,json,csv,re,collections,datetime,mmap,os
ROOT=Path('/home/david/Documents/Codex/2026-10-29/act');W=ROOT/'work';D=W/'offline914-newpair-c6-20261030'
op=json.loads((W/'prepare914-offline-operation.json').read_text());plan=json.loads((W/'prepare914-offline-analysis-plan-proof.json').read_text())
def sha(p):
 h=hashlib.sha256()
 with open(p,'rb') as f:
  for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
 return h.hexdigest()
assert sha(W/'prepare914-offline-analysis-plan-proof.json')==op['plan_sha256']
assert sha(W/'prepare914-offline-analysis-plan.md')==op['plan_text_sha256']
checks=[];seen={}
for when in ['preflight_identities','post_identities']:
 for row in op[when]:
  assert row['PASS'] and row['expected']==row['actual']
  p=row['path'];actual=seen.setdefault(p,sha(p)) if p not in seen else seen[p]
  assert actual==row['expected'],p
  checks.append((when,p,actual))
assert len(checks)==158
closure=json.loads((W/'prepare914-offline-static-abi-proof.json').read_text())['dependency_closure']
assert len(closure)==42
assert all(sha(v['path'])==v['sha256'] for v in closure.values())
for row in op['staged_files']:
 p=Path(row['path']);s=p.stat();assert sha(p)==row['sha256'] and s.st_size==row['bytes'] and oct(s.st_mode&0o777)==row['mode'] and s.st_nlink==row['nlink']==1
for row in op['symfs_aliases']:assert Path(row['path']).is_symlink() and str(Path(row['path']).resolve())==row['target']
for p,mode in op['original_source_modes'].items():assert oct(Path(p).stat().st_mode&0o777)==mode
commands=[];tickets=[]
for c,p in zip(op['commands'],plan['commands_in_order'],strict=True):
 assert c['id']==p['id'] and c['attempt']==1 and c['returncode']==0 and c['status']=='GATES_PASSED'
 assert c['exact_child_argv']==p['argv'] and c['exact_outer_argv']==p['exact_proposed_queue_timeout_argv'] and c['exact_child_environment']==p['exact_child_environment']
 g=c['grant'];meta=g['metadata'];assert g['directory']=='running' and meta['cores']=='1' and meta['cpus']=='2,10' and int(meta['pid'])==c['outer_pid'] and meta['owner']=='codex-reviewer-914-input-binding' and c['actual_timeout_allowed_cpus']=='2,10'
 tickets.append(g['ticket'])
 assert '--kill-after=5s' in c['exact_outer_argv'] and '120s' in c['exact_outer_argv']
 for k,f in c['streams'].items():
  assert f==p[k] and sha(f)==c['stream_hashes'][k]
 assert Path(c['streams']['stderr_new_exclusive_path']).stat().st_size==0
 commands.append({'id':c['id'],'ticket':g['ticket'],'returncode':0,'child_stderr_bytes':0,'queue_stderr_bytes':Path(c['streams']['queue_stderr_new_exclusive_path']).stat().st_size,'duration_including_queue_seconds':c['duration_including_queue_seconds'],'active_after_stream_open_observed_seconds':c['active_after_stream_open_observed_seconds'],'queue_wait_whole_epoch_seconds':c['actual_queue_wait_epoch_seconds'],'grant_cpus':'2,10','useful_physical_cores':1})
assert tickets==[str(i).zfill(12) for i in range(837,845)]
class ELF:
 def __init__(self,p):
  self.b=Path(p).read_bytes();b=self.b;assert b[:6]==b'\x7fELF\x02\x01'
  self.ph=[];phoff=struct.unpack_from('<Q',b,32)[0];psz,pn=struct.unpack_from('<HH',b,54)
  for n in range(pn):self.ph.append(struct.unpack_from('<IIQQQQQQ',b,phoff+n*psz))
  so=struct.unpack_from('<Q',b,40)[0];ss,sn=struct.unpack_from('<HH',b,58);self.sections=[struct.unpack_from('<IIQQQQIIQQ',b,so+i*ss) for i in range(sn)]
  self.symbols={};self.reloc={}
  for s in self.sections:
   if s[1] in (2,11):
    st=self.sections[s[6]];strings=b[st[4]:st[4]+st[5]];syms=[]
    for at in range(s[4],s[4]+s[5],s[9]):
     name,info,other,shndx,value,size=struct.unpack_from('<IBBHQQ',b,at);text=strings[name:].split(b'\0',1)[0].decode(errors='replace');syms.append(text)
     if info&15==2 and size:self.symbols[text]=(value,size)
    for r in self.sections:
     if r[1]==4 and r[6]==self.sections.index(s):
      for at in range(r[4],r[4]+r[5],r[9]):
       off,inf,add=struct.unpack_from('<QQq',b,at);self.reloc[off]=(inf&0xffffffff,syms[inf>>32])
 def data(self,va,n):
  for typ,flags,off,vaddr,paddr,filesz,memsz,align in self.ph:
   if typ==1 and va>=vaddr and va-vaddr+n<=filesz:return self.b[off+va-vaddr:off+va-vaddr+n]
  raise AssertionError(('unmapped',hex(va),n))
 def target(self,ra):
  b=self.data(ra-5,5);assert b[0]==0xe8;return ra+struct.unpack_from('<i',b,1)[0]
 def plt(self,target):
  b=self.data(target,16);n=4 if b[:4]==b'\xf3\x0f\x1e\xfa' else 0;n+=b[n]==0xf2;assert b[n:n+2]==b'\xff\x25';got=target+n+6+struct.unpack_from('<i',b,n+2)[0];return got,self.reloc[got]
def capture(p):
 f=open(p,'rb');b=mmap.mmap(f.fileno(),0,access=mmap.ACCESS_READ)
 u=lambda off:struct.unpack_from('<Q',b,off)[0];assert b[:8]==b'PERFILE2' and u(8)==104
 attrsize,attr,asize,off,n=struct.unpack_from('<QQQQQ',b,16);assert attrsize==asize and attrsize>=112
 typ,attrs=struct.unpack_from('<II',b,attr);assert typ==0 and u(attr+8)==0 and u(attr+16)==250003 and u(attr+24)==sum(1<<x for x in [0,1,2,5,7,8,12,13]);mask=u(attr+80);assert mask==0xff0fff and struct.unpack_from('<I',b,attr+88)[0]==4096
 samples=[];meta=[];maps=[];records=collections.Counter();loss=collections.Counter();at=off
 while at<off+n:
  typ,misc,size=struct.unpack_from('<IHH',b,at);assert size>=8 and at+size<=off+n;records[typ]+=1
  if typ in [2,13]:loss['lost' if typ==2 else 'lost_samples']+=u(at+(16 if typ==2 else 8))
  if typ in [5,6]:loss['throttles' if typ==5 else 'unthrottles']+=1
  if typ==3:
   pid,tid=struct.unpack_from('<II',b,at+8);name=b[at+16:at+size-24].split(b'\0',1)[0].decode();meta.append((u(at+size-16),pid,0,name,bool(misc&8192)))
  if typ==10:
   pid,tid=struct.unpack_from('<II',b,at+8);address,length,pgoff=struct.unpack_from('<QQQ',b,at+16);prot=struct.unpack_from('<I',b,at+64)[0];name=b[at+72:at+size-24].split(b'\0',1)[0].decode();time=u(at+size-16);maps.append((pid,tid,time,name,address,length,pgoff,prot))
   if name.endswith('/libc.so.6') and prot&4:meta.append((time,pid,1,'libc',address-pgoff))
  if typ==9:
   ip=u(at+8);pid,tid=struct.unpack_from('<II',b,at+16);time=u(at+24);cpu=struct.unpack_from('<I',b,at+32)[0];period=u(at+40);chain=u(at+48);cursor=at+56+8*chain;assert cursor+8<=at+size;abi=u(cursor);cursor+=8;regs={}
   assert abi in (0,2)
   if abi:
    for reg in range(24):
     if mask&(1<<reg):regs[reg]=u(cursor);cursor+=8
   stack=u(cursor);cursor+=8;start=cursor;cursor+=stack;dyn=u(cursor) if stack else 0;cursor+=8 if stack else 0
   assert stack<=4096 and dyn<=stack and cursor==at+size and period>0
   samples.append({'time':time,'pid':pid,'tid':tid,'ip':ip,'period':period,'cpu':cpu,'misc':misc,'regs':regs,'stack_offset':start,'stack_size':dyn})
  at+=size
 assert at==off+n and not any(loss.values())
 meta.sort(key=lambda e:e[:3]);samples.sort(key=lambda s:(s['time'],s['pid']));states={};mi=0
 for s in samples:
  while mi<len(meta) and meta[mi][0]<=s['time']:
   time,pid,kind,name,x=meta[mi];mi+=1;st=states.setdefault(pid,{'compiler':False,'execs':0,'libc':None})
   if kind==0:
    if x:st['libc']=None
    if x and name=='compiler':st['execs']+=1;assert st['execs']==1
    st['compiler']=name=='compiler'
   elif st['compiler']:assert st['libc'] in (None,x);st['libc']=x
  s.update(states[s['pid']])
 return b,f,samples,meta,maps,dict(records)
primre=re.compile(r'\s*compiler (\d+)/(\d+)\s+(\d+) cycles:u:\s+([0-9a-f]+) (.*) \((.*)\)')
headre=re.compile(r'compiler (\d+)/(\d+)\s+(\d+) cycles:u:\s*')
framere=re.compile(r'\s*([0-9a-f]+) (.*) \((.*)\)')
def chains(path):
 text=Path(path).read_text();out=[]
 for block in text.strip().split('\n\n'):
  lines=block.splitlines();m=headre.fullmatch(lines[0]);assert m;frames=[]
  for line in lines[1:]:
   n=framere.fullmatch(line);assert n;frames.append((int(n[1],16),n[3]))
  assert len(frames)<=128;out.append((int(m[1]),int(m[2]),int(m[3]),frames))
 return out
results={}
for arm in ['base','head']:
 a=D/'analysis'/arm;raw=D/'data/raw'/arm;ledger=[tuple(map(int,x.split())) for x in (raw/'processes.tsv').read_text().splitlines()];assert [x[0] for x in ledger]==list(range(30)) and all(x[2]==0 for x in ledger);pids={x[1] for x in ledger};assert len(pids)==30
 elf=ELF(D/'data/bin'/arm/'compiler');family={n:v for n,v in elf.symbols.items() if n in ['check_input_intrinsic_initialize','check_input_intrinsic_lookup']};assert len(family)==(1 if arm=='base' else 2)
 member=lambda ip:next(((n,v[0],v[1]) for n,v in family.items() if v[0]<=ip<v[0]+v[1]),None)
 b,f,samples,meta,maps,records=capture(raw/'profile.perf.data');selected=[s for s in samples if s['compiler']];audit=json.loads((a/'audit.json').read_text());summary=json.loads((a/'summary.json').read_text());coverage=json.loads((a/'proof.csv.coverage.json').read_text())
 assert audit['valid'] and audit['records']==sum(records.values()) and audit['samples']==len(samples) and all(audit[k]==0 for k in ['lost','lost_samples','throttles','unthrottles'])
 assert {s['pid'] for s in selected}==pids and {(s['pid'],s['tid']) for s in selected}=={(p,p) for p in pids}
 path='/home/david/buster-fast-bench/codex-pr914-input-binding-20261030-1856-5ea2ab42/bin/'+arm+'/compiler'
 for pid in pids:
  comm=[x for x in meta if x[1]==pid and x[2]==0 and x[3]=='compiler' and x[4]];assert len(comm)==1
  mm=[x for x in maps if x[0]==pid and x[3]==path and x[7]&4];assert mm
  assert all(s['time']>=comm[0][0] for s in selected if s['pid']==pid)
 primary=[]
 for line in (a/'primary.txt').read_text().splitlines():
  m=primre.fullmatch(line);assert m;primary.append((int(m[1]),int(m[2]),int(m[3]),int(m[4],16),m[6]))
 chain=chains(a/'chains.txt');proof=list(csv.DictReader((a/'proof.csv').open()));pi=0;total=user=0;count=collections.Counter();weights=collections.Counter();dsos=collections.Counter();pidcounts=collections.defaultdict(collections.Counter);calls=collections.Counter();cfadeltas=collections.Counter()
 assert len(primary)==len(chain)==len(selected)
 for s,p,c in zip(selected,primary,chain,strict=True):
  assert (s['pid'],s['tid'],s['period'],s['ip'])==p[:4] and c[:3]==p[:3] and s['cpu']==2 and s['period']==250003
  frames=c[3];isuser=s['misc']&7==2;own=isuser and member(s['ip']);libc=isuser and p[4].endswith('/libc.so.6');total+=s['period'];user+=s['period'] if isuser else 0;count['nonuser']+=not isuser;count['empty']+=not frames;count['mismatch']+=isuser and bool(frames) and frames[0][0]!=s['ip'];count['empty_user']+=isuser and not frames;count['libc']+=libc;count['libc_short']+=libc and len(frames)<2;dsos[p[4]]+=1
  fi=next((i for i,fr in enumerate(frames[1:],1) if member(fr[0])),None);count['complex']+=libc and fi is not None and fi!=1
  if own or (libc and fi==1):
   r=proof[pi];pi+=1;v={k:int(x,0) for k,x in r.items() if k!='kind'};assert v['pid']==s['pid'] and v['period']==s['period'] and v['primary_ip']==s['ip'];assert len(frames)>=2 and frames[0][0]==s['ip'] and s['regs'][8]==s['ip'] and v['sp']==s['regs'][7]
   assert v['ra_address']==v['cfa']-8 and v['ra_address']>=v['sp'] and v['ra_address']-v['sp']+8<=s['stack_size'];ra=struct.unpack_from('<Q',b,s['stack_offset']+v['ra_address']-v['sp'])[0];assert ra==v['raw_ra'] and v['cfi_caller']==frames[1][0] and frames[1][0] in [ra,ra-1]
   target=elf.target(ra)
   if own:assert r['kind']=='family' and target==own[1] and v['call_target']==target and v['got']==0
   else:
    got,rel=elf.plt(target);assert got==v['got'] and member(ra-1)
    if rel[1]=='memcmp':assert r['kind']=='memcmp' and rel[0] in (6,7) and v['call_target']==target
    else:assert r['kind']=='other_libc' and v['call_target']==0
   count[r['kind']]+=1;weights[r['kind']]+=s['period'];pidcounts[s['pid']][r['kind']]+=1;calls[(r['kind'],hex(target),v['got'])]+=1;cfadeltas[(r['kind'],v['cfa']-v['sp'])]+=1
 assert pi==len(proof)
 expect={'compiler_samples':len(selected),'compiler_cycle_period':total,'user_ip_cycle_period':user,'family_leaf_samples':count['family'],'family_leaf_cycle_period':weights['family'],'attributed_memcmp_samples':count['memcmp'],'attributed_memcmp_cycle_period':weights['memcmp'],'family_cfa_proofs':count['family'],'other_libc_from_family':count['other_libc'],'nonuser_ip_samples':count['nonuser'],'empty_chains':count['empty'],'user_leaf_chain_mismatches':count['mismatch'],'complex_libc_family_chains':count['complex']}
 assert all(summary[k]==v for k,v in expect.items()) and summary['valid']
 assert coverage=={'compiler_processes':30,'excluded_precompiler_samples':sum(not s['compiler'] and s['execs']>0 for s in samples),'empty_user_chains':count['empty_user'],'libc_samples':count['libc'],'libc_short_chains':count['libc_short']}
 estimate={k:weights[k]/30 for k in ['family','memcmp']};estimate['optional_sum_not_full_inclusive']=sum(estimate.values())
 results[arm]={'audit':audit,'summary':summary,'coverage':coverage,'exact_30_sampled_ledger_PID_TID_sets':True,'all_30_one_COMM_EXEC_exact_path_after_epoch':True,'noncompiler_samples_retained':len(samples)-len(selected),'pid_list':sorted(pids),'proof_rows':len(proof),'all_raw_primary_chain_ordinal_joins':len(selected),'all_proof_raw_stack_E8_PLT_GOT_checks':pi,'family_symbol_ranges':family,'calls':{str(k):v for k,v in calls.items()},'cfa_sp_deltas':{str(k):v for k,v in cfadeltas.items()},'primary_dso_counts':dict(dsos),'per_PID_proof_counts':{str(k):dict(v) for k,v in pidcounts.items()},'sampled_cycle_period_estimate_per_successful_compile':estimate,'raw_primary_family_share_percent':100*weights['family']/total,'unattributed_libc_samples':count['libc']-count['memcmp']-count['other_libc']}
 b.close();f.close()
deltas={k:100*(results['head']['sampled_cycle_period_estimate_per_successful_compile'][k]/results['base']['sampled_cycle_period_estimate_per_successful_compile'][k]-1) for k in ['family','memcmp','optional_sum_not_full_inclusive']}
out={'completed_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'operation':str(W/'prepare914-offline-operation.json'),'operation_sha256':sha(W/'prepare914-offline-operation.json'),'plan_sha256':op['plan_sha256'],'all_8_exact_plan_commands_status0':True,'distinct_local_grants':commands,'child_stderr_all_empty':True,'pre_post_identity_rows_validated':len(checks),'fresh_unique_identity_hashes':len(seen),'local_runtime_closure_files_rehashed':len(closure),'new_copies_rehashed':len(op['staged_files']),'internal_symfs_links_verified':len(op['symfs_aliases']),'historical_modes_unchanged':True,'arms':results,'matched_denominator_successful_compiles_each':30,'sampled_estimate_changes_percent':deltas,'CFI_scope':'Unchanged qualified reader/libdw computes actual CFI. Independent new-capture verification checks every produced CFA/RA against recorded stack bytes and CFI-displayed caller, all direct E8 target bytes and libc PLT/GOT relocation symbols; no libdw/tool rerun.','no_helper_decoder_program_or_host_execution':True}
(W/'review914-offline-result-peer-reduction.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({'completed_at':out['completed_at'],'commands':8,'identities':len(checks),'runtime':42,'raw_joins':{k:v['all_raw_primary_chain_ordinal_joins'] for k,v in results.items()},'proof_checks':{k:v['proof_rows'] for k,v in results.items()},'estimates':{k:v['sampled_cycle_period_estimate_per_successful_compile'] for k,v in results.items()},'changes':deltas}))
