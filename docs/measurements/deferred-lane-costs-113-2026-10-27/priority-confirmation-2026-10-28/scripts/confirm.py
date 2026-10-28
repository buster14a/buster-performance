#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Original bounded #683 confirmation controller; no external implementation is incorporated.
import datetime,hashlib,json,os,pathlib,re,shutil,subprocess,time,traceback
ROOT=pathlib.Path(__file__).resolve().parents[1]
E=json.loads((ROOT/'expected.json').read_text())
CORPUS=pathlib.Path('/var/lib/buster-9700x/corpora/preprocessor-391e729af658')
OWNER=pathlib.Path(E['owner_root'])
def utc(): return datetime.datetime.now(datetime.timezone.utc).isoformat()
def digest(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def save(path,value): path.write_text(json.dumps(value,indent=2)+'\n')
def snapshot(stage):
    data={'utc':utc(),'monotonic_ns':time.monotonic_ns(),'binaries':{},'inputs':{},'headers':{},'sources':{},'cpu_policy':{}}
    for label,tree in [('baseline','merge2'),('candidate','merge3')]:
        original=OWNER/tree/'build/compiler'; stat=original.stat(); actual=digest(original)
        assert actual==E['binary_sha256'][label],(label,'owner binary changed',actual)
        data['binaries'][label]={'sha256':actual,'bytes':stat.st_size,'owner_path':str(original),'mtime_ns':stat.st_mtime_ns}
        copied=ROOT/'bin'/label
        if copied.exists(): assert digest(copied)==actual,(label,'snapshot binary changed')
    source=OWNER/'synthetic/h64x3.c'
    assert digest(source)==E['input_sha256'],'h64x3 source changed'
    data['inputs']['owner_h64x3']=digest(source)
    copied=ROOT/'inputs/h64x3.c'
    if copied.exists(): assert digest(copied)==E['input_sha256'],'input snapshot changed'
    predefines=CORPUS/'provenance/gnu17-pinned-predefines.txt'
    assert digest(predefines)==E['predefines_sha256'],'predefines changed'
    data['inputs']['pinned_predefines']=digest(predefines)
    for name,expected in E['headers'].items():
        actual=digest(CORPUS/'headers/usr'/name); assert actual==expected,('header changed',name)
        data['headers'][name]=actual
    for tree,manifest in E['source_manifests'].items():
        data['sources'][tree]={}
        for name,expected in manifest.items():
            actual=digest(OWNER/tree/name); assert actual==expected,('source changed',tree,name)
            data['sources'][tree][name]=actual
    for cpu in E['cpus']:
        policy={}
        for name in ('scaling_governor','energy_performance_preference','scaling_min_freq','scaling_max_freq','scaling_cur_freq'):
            path=pathlib.Path(f'/sys/devices/system/cpu/cpu{cpu}/cpufreq/{name}')
            if path.exists(): policy[name]=path.read_text().strip()
        assert policy.get('scaling_governor')==('performance' if cpu==2 else 'powersave'),('governor changed',cpu,policy)
        data['cpu_policy'][cpu]=policy
    data['lscpu']=subprocess.check_output(['lscpu'],text=True)
    data['uname']=subprocess.check_output(['uname','-a'],text=True).strip()
    data['affinity']=sorted(os.sched_getaffinity(0))
    assert set(E['cpus']).issubset(os.sched_getaffinity(0)),'requested CPUs unavailable'
    save(ROOT/f'{stage}-identities.json',data)
    return data

def run_one(round_number,kind,label,tree):
    name=f'r{round_number:02d}-{kind}-{label}'
    directory=ROOT/'logs'/name; directory.mkdir()
    options=['--predefines',str(CORPUS/'provenance/gnu17-pinned-predefines.txt'),'--clang-features','--no-default-config','--target=x86_64-linux-gnu','-march=znver5','-std=gnu17','-nostdinc','-isystem',str(CORPUS/'headers/usr/lib/clang/23/include'),'-isystem',str(CORPUS/'headers/usr/local/include'),'-isystem',str(CORPUS/'headers/usr/include')]
    command=['taskset','-c','0-7',str(ROOT/'bin'/tree),'benchmark-checker-deferred','--passes',str(E['passes']),'--lanes','2','--cpus',','.join(map(str,E['cpus'])),'--every-lane',*options,str(ROOT/'inputs/h64x3.c')]
    receipt={'round':round_number,'kind':kind,'label':label,'tree':tree,'binary_sha256':E['binary_sha256'][tree],'command':command,'start_utc':utc(),'start_monotonic_ns':time.monotonic_ns()}
    save(directory/'start.json',receipt)
    with (directory/'stdout.txt').open('wb') as output,(directory/'stderr.txt').open('wb') as errors:
        process=subprocess.Popen(command,stdout=output,stderr=errors)
        _,status,usage=os.wait4(process.pid,0)
        process.returncode=os.waitstatus_to_exitcode(status)
    receipt.update(exit=process.returncode,end_utc=utc(),end_monotonic_ns=time.monotonic_ns(),user_seconds=usage.ru_utime,system_seconds=usage.ru_stime,maxrss_kib=usage.ru_maxrss,minor_faults=usage.ru_minflt,major_faults=usage.ru_majflt)
    text=(directory/'stdout.txt').read_text()
    metadata=None; readings=[]
    for line in text.splitlines():
        fields=dict(re.findall(r'(\w+)=([^ ,]+)',line))
        if line.startswith('checker-deferred: file='): metadata=fields
        elif line.startswith('checker-deferred:   lanes='): readings.append(fields)
    receipt.update(metadata=metadata,readings=readings)
    save(directory/'receipt.json',receipt)
    with (ROOT/'trials.jsonl').open('a') as stream: stream.write(json.dumps(receipt)+'\n')
    print(f"{name} tree={tree} exit={process.returncode} one={readings[0].get('whole') if readings else '?'} many={readings[1].get('whole') if len(readings)>1 else '?'}",flush=True)
    assert process.returncode==0,('child failed',name,process.returncode)
    assert metadata and metadata.get('merged')=='yes',('not merged',name)
    assert all(metadata.get(k)==v for k,v in E['metadata'].items()),('input metadata changed',name,metadata)
    assert len(readings)==2 and readings[0]['lanes']=='1' and readings[1]['lanes']=='2',('missing readings',name)
    assert readings[0]['active']=='1' and readings[1]['active']=='2',('active lanes changed',name)
    if tree=='candidate': assert readings[1].get('largest_first')==f"{E['passes']}/{E['passes']}",('primary placement failed',name)

status=1
started=time.monotonic_ns()
try:
    assert os.environ.get('BUSTER_9700X_HELD')=='1','shared lock marker absent'
    assert str(ROOT)==E['root'],'wrong target directory'
    assert not (ROOT/'trials.jsonl').exists(),'confirmation already attempted'
    (ROOT/'logs').mkdir(exist_ok=True)
    (ROOT/'acquired-utc.txt').write_text(utc()+'\n')
    (ROOT/'shared-owner.txt').write_text(pathlib.Path('/var/lib/buster-9700x/owner').read_text())
    for key in ('CPATH','C_INCLUDE_PATH','CPLUS_INCLUDE_PATH','LIBRARY_PATH','COMPILER_PATH','GCC_EXEC_PREFIX','LD_LIBRARY_PATH'): os.environ.pop(key,None)
    os.environ.update(PATH='/usr/bin:/bin',LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
    snapshot('before')
    (ROOT/'bin').mkdir(); (ROOT/'inputs').mkdir()
    for label,tree in [('baseline','merge2'),('candidate','merge3')]:
        shutil.copyfile(OWNER/tree/'build/compiler',ROOT/'bin'/label); (ROOT/'bin'/label).chmod(0o555)
        assert digest(ROOT/'bin'/label)==E['binary_sha256'][label]
    shutil.copyfile(OWNER/'synthetic/h64x3.c',ROOT/'inputs/h64x3.c'); (ROOT/'inputs/h64x3.c').chmod(0o444)
    assert digest(ROOT/'inputs/h64x3.c')==E['input_sha256']
    for rnd in range(1,E['rounds']+1):
        groups=['AA','AB'] if rnd%2 else ['AB','AA']
        for kind in groups:
            pair=[('a1','baseline'),('a2','baseline')] if kind=='AA' else [('a','baseline'),('b','candidate')]
            if rnd%2==0: pair.reverse()
            for label,tree in pair: run_one(rnd,kind.lower(),label,tree)
    snapshot('after')
    status=0
except BaseException:
    traceback.print_exc()
finally:
    save(ROOT/'controller-result.json',{'exit':status,'end_before_unlock_utc':utc(),'held_monotonic_ns':time.monotonic_ns()-started,'completed_trials':sum(1 for _ in (ROOT/'trials.jsonl').open()) if (ROOT/'trials.jsonl').exists() else 0})
raise SystemExit(status)
