from pathlib import Path
from datetime import datetime,timezone
from collections import defaultdict,Counter
import json,csv,re,struct,mmap,hashlib
W=Path(__file__).resolve().parent;R=W/'offline914-newpair-c6-20261030';op=json.loads((W/'prepare914-offline-operation.json').read_text());assert op['status']=='ALL_8_COMMANDS_COMPLETE_PENDING_INDEPENDENT_REDUCTION' and len(op['commands'])==8
class Image:
 def __init__(self,p):
  self.d=Path(p).read_bytes();h=struct.unpack_from('<16sHHIQQQIHHHHHH',self.d);assert h[0][:6]==b'\x7fELF\x02\x01' and h[2]==62
  self.ph=[struct.unpack_from('<IIQQQQQQ',self.d,h[5]+i*h[9]) for i in range(h[10])];self.sh=[struct.unpack_from('<IIQQQQIIQQ',self.d,h[6]+i*h[11]) for i in range(h[12])];self.symbols={};self.bysection={};self.relocations={}
  for i,s in enumerate(self.sh):
   if s[1] in [2,11]:
    st=self.sh[s[6]];ss=self.d[st[4]:st[4]+st[5]];sym=[]
    for off in range(s[4],s[4]+s[5],s[9]):
     v=struct.unpack_from('<IBBHQQ',self.d,off);name=ss[v[0]:].split(b'\0',1)[0].decode();sym.append((name,v))
     if s[1]==2:self.symbols[name]=v
    self.bysection[i]=sym
  for s in self.sh:
   if s[1]==4:
    syms=self.bysection[s[6]]
    for off in range(s[4],s[4]+s[5],s[9]):
     loc,info,add=struct.unpack_from('<QQq',self.d,off);self.relocations[loc]={'type':info&0xffffffff,'name':syms[info>>32][0]}
  self.family={n:(v[4],v[5]) for n,v in self.symbols.items() if n in ['check_input_intrinsic_initialize','check_input_intrinsic_lookup']};assert 'check_input_intrinsic_initialize' in self.family
 def at(self,a,n):
  matches=[self.d[p[2]+a-p[3]:p[2]+a-p[3]+n] for p in self.ph if p[0]==1 and p[3]<=a and a+n<=p[3]+p[5]];assert len(matches)==1;(x,)=matches;return x
 def owner(self,ip):return next((n for n,(a,size) in self.family.items() if a<=ip<a+size),None)
 def call(self,ra):
  d=self.at(ra-5,5);assert d[0]==0xe8;return ra+struct.unpack_from('<i',d,1)[0]
 def plt_got(self,target):
  p=self.at(target,16);i=4 if p.startswith(b'\xf3\x0f\x1e\xfa') else 0;i+=p[i]==0xf2;assert p[i:i+2]==b'\xff\x25';return target+i+6+struct.unpack_from('<i',p,i+2)[0]
answers={}
for arm in ['base','head']:
 D=R/'analysis'/arm;S=json.loads((D/'summary.json').read_text());C=json.loads((D/'proof.csv.coverage.json').read_text());A=json.loads((D/'audit.json').read_text());receipt=json.loads((W/f'prepare914-{arm}-arm-proof.json').read_text());pids=receipt['fresh_children']['pids'];assert S['valid'] and C['compiler_processes']==30
 with (D/'proof.csv').open() as f:proof=list(csv.DictReader(f))
 numeric={k for k in proof[0] if k!='kind'}
 for row in proof:
  for k in numeric:row[k]=int(row[k],0)
  assert row['kind'] in ['family','memcmp','other_libc'] and row['pid'] in pids and row['period']==250003
 totals={kind:{'rows':sum(r['kind']==kind for r in proof),'period':sum(r['period'] for r in proof if r['kind']==kind)} for kind in ['family','memcmp','other_libc']}
 assert totals['family']['rows']==S['family_leaf_samples']==S['family_cfa_proofs'];assert totals['family']['period']==S['family_leaf_cycle_period'];assert totals['memcmp']['rows']==S['attributed_memcmp_samples'];assert totals['memcmp']['period']==S['attributed_memcmp_cycle_period'];assert totals['other_libc']['rows']==S['other_libc_from_family']
 metadata=json.loads((W/'prepare914-offline-map-plan-proof.json').read_text())['arms'][arm]['process_metadata'];exec_times={int(pid):next(c['time'] for c in v['comm'] if c['exec'] and c['comm']=='compiler') for pid,v in metadata.items()};wanted={(r['pid'],r['primary_ip'],r['sp'],r['period']) for r in proof};rawkeys=[];stacks=defaultdict(list);rawcounts=Counter();hardware=0;excluded=0;periods=Counter()
 with (R/f'data/raw/{arm}/profile.perf.data').open('rb') as f,mmap.mmap(f.fileno(),0,access=mmap.ACCESS_READ) as d:
  header=struct.unpack_from('<13Q',d);assert d[:8]==b'PERFILE2' and header[1]==104;attr=header[3];samplemask=struct.unpack_from('<Q',d,attr+24)[0];readformat=struct.unpack_from('<Q',d,attr+32)[0];regmask=struct.unpack_from('<Q',d,attr+80)[0];stacksize=struct.unpack_from('<I',d,attr+88)[0];assert regmask==0xff0fff and stacksize==4096
  pos=header[5];end=pos+header[6]
  while pos<end:
   typ,misc,length=struct.unpack_from('<IHH',d,pos);assert length>=8 and pos+length<=end;rawcounts[typ]+=1
   if typ in [2,13,5,6]:assert False,('raw lost/throttle record',typ)
   if typ==9:
    hardware+=1;ip=struct.unpack_from('<Q',d,pos+8)[0];pid,tid=struct.unpack_from('<II',d,pos+16);time,cpu,unused,period,chain=struct.unpack_from('<QIIQQ',d,pos+24);assert period>0;periods[period]+=1
    cursor=pos+56+8*chain;abi=struct.unpack_from('<Q',d,cursor)[0];cursor+=8;assert abi in [0,2];regs={}
    if abi:
     for reg in range(24):
      if regmask&(1<<reg):regs[reg]=struct.unpack_from('<Q',d,cursor)[0];cursor+=8
    size=struct.unpack_from('<Q',d,cursor)[0];cursor+=8;assert size<=4096;start=cursor;cursor+=size;actual=struct.unpack_from('<Q',d,cursor)[0] if size else 0;cursor+=8 if size else 0;assert actual<=size and cursor==pos+length
    if pid in exec_times and time>=exec_times[pid]:
     assert pid==tid and cpu==2 and period==250003;rawkeys.append((time,pid,tid,ip,period));key=(pid,ip,regs.get(7,0),period)
     if key in wanted:assert misc&7==2 and regs.get(8)==ip;stacks[key].append({'regs':regs,'stack':bytes(d[start:start+actual]),'time':time})
    else:excluded+=1
   pos+=length
  assert pos==end and hardware==A['samples'] and sum(rawcounts.values())==A['records']
 rawkeys.sort(key=lambda v:(v[0],v[1],v[2]));primary=[]
 for line in (D/'primary.txt').read_text().splitlines():
  if line.strip():
   m=re.fullmatch(r'\s*compiler\s+(\d+)/(\d+)\s+(\d+)\s+cycles:u:\s+([0-9a-fA-F]+)\s+.*\([^\n]+\)\s*',line);assert m;primary.append((int(m[1]),int(m[2]),int(m[4],16),int(m[3])))
 assert [(p,t,ip,w) for _,p,t,ip,w in rawkeys]==primary and len(primary)==S['compiler_samples'] and sum(v[-1] for v in primary)==S['compiler_cycle_period'];assert {p for p,_,_,_ in primary}==set(pids)
 elf=Image(R/f'data/bin/{arm}/compiler');rawproofs=[]
 for row in proof:
  key=(row['pid'],row['primary_ip'],row['sp'],row['period']);offset=row['ra_address']-row['sp'];assert offset>=0
  candidates=stacks[key];selected=next((i for i,s in enumerate(candidates) if offset+8<=len(s['stack']) and struct.unpack_from('<Q',s['stack'],offset)[0]==row['raw_ra']),None);assert selected is not None;sample=candidates.pop(selected)
  assert row['cfi_caller'] in [row['raw_ra'],row['raw_ra']-1];call=elf.call(row['raw_ra']);assert (call==row['call_target'] if row['kind']!='other_libc' else row['call_target']==0)
  if row['kind']=='family':name=elf.owner(row['primary_ip']);assert name and call==elf.family[name][0]
  else:
   assert elf.owner(row['raw_ra']-1)
   if row['kind']=='memcmp':got=elf.plt_got(call);assert got==row['got'] and elf.relocations[got]['name']=='memcmp' and elf.relocations[got]['type'] in [6,7]
  rawproofs.append({'kind':row['kind'],'pid':row['pid'],'primary_ip':row['primary_ip'],'matched_raw_time':sample['time'],'saved_RA_matches_raw_stack':True,'original_ELF_E8_call_target':call,'CSV_target_matches_where_defined':row['kind']!='other_libc','memcmp_ELF_PLT_GOT_relocation_matches':row['kind']=='memcmp'})
 perpid=[{'index':i,'pid':pid,'family_samples':sum(r['pid']==pid and r['kind']=='family' for r in proof),'memcmp_samples':sum(r['pid']==pid and r['kind']=='memcmp' for r in proof),'family_period':sum(r['period'] for r in proof if r['pid']==pid and r['kind']=='family'),'memcmp_period':sum(r['period'] for r in proof if r['pid']==pid and r['kind']=='memcmp')} for i,pid in enumerate(pids)]
 estimates={'direct_family_period_per_compile':totals['family']['period']/30,'proven_memcmp_period_per_compile':totals['memcmp']['period']/30,'combined_target_period_per_compile':(totals['family']['period']+totals['memcmp']['period'])/30}
 answers[arm]={'summary':S,'coverage':C,'audit':A,'proof_class_sums':totals,'all_raw_primary_ordinal_PID_TID_IP_period_joins_exact':True,'all_raw_hardware_samples':hardware,'excluded_noncompiler_or_preexec_samples':excluded,'exact30_ledger_PID_TID_set':[[p,p] for p in pids],'all_raw_proof_saved_returns_and_ELF_calls_independently_checked':len(rawproofs),'raw_proof_joins':rawproofs,'family_ELF_symbols':elf.family,'sample_period_counts':dict(periods),'recorded_read_format':readformat,'no_enabled_running_time_fields':readformat&3==0,'CFI_scope':'Actual unchanged qualified reader performed CFI/CFA checks; fresh data reducer independently bound every proof to saved raw return bytes and original ELF E8/PLT/GOT. This reducer does not claim a second libdw CFI execution.','per_process_target_counts':perpid,'estimates':estimates,'coverage_ratios':{'nonuser_samples_fraction':S['nonuser_ip_samples']/S['compiler_samples'],'direct_family_period_fraction':S['family_leaf_cycle_period']/S['compiler_cycle_period'],'memcmp_period_fraction':S['attributed_memcmp_cycle_period']/S['compiler_cycle_period']}}
comparison={k:100*(answers['head']['estimates'][k]/answers['base']['estimates'][k]-1) for k in answers['base']['estimates']};result={'completed_at':datetime.now(timezone.utc).isoformat(),'method':'Fresh Python data-only reduction; no archived helper/decoder rerun or host action','arms':answers,'HEAD_vs_BASE_percent_changes':comparison,'limits':['One sequential BASE->HEAD pair; no independent A/A, placement replication or causal speedup claim','Period-weighted target estimates, not exact function counters/duty/whole inclusive initialization','Unknown/nonuser/otherlibc coverage retained; targetlibm not substituted','No historical146input binding or source acceptance from these arithmetic results alone']};(W/'prepare914-offline-reduction.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'completed_at':result['completed_at'],'target_percent_changes':comparison,'arms':{a:{k:j[k] for k in ['proof_class_sums','estimates','coverage_ratios','all_raw_proof_saved_returns_and_ELF_calls_independently_checked','excluded_noncompiler_or_preexec_samples']} for a,j in answers.items()}},indent=2))
