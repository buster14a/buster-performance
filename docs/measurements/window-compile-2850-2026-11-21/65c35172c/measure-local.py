from pathlib import Path
import csv,hashlib,os,statistics,subprocess,sys,time
d=Path(sys.argv[1]).resolve();w=d.parent
s=(w/'sizeof-expression-study/source-regions.py').read_text();srcargs=s.split("srcargs='''")[1].split("'''")[0].replace('\\\\0','\\0').replace('$1/pregraph-warning-study', '$1/switch-inputs/../pregraph-warning-study').replace('$1/proof-predefines.h', '$1/switch-inputs/../proof-predefines.h')
exe=d/'compiler';common=os.environ.copy();common.update({k:'1' for k in 'BUSTER_SOURCE_ROOT_CURSOR BUSTER_SOURCE_CONTROL_MASKS BUSTER_SOURCE_DIRTY_DIAGNOSTICS BUSTER_SOURCE_WARNING_INDEX BUSTER_SOURCE_CLOSE_CONTEXTS BUSTER_SOURCE_CLASS_CONSUMER BUSTER_SOURCE_BORROW_CHILDREN BUSTER_SOURCE_FIRST_NODE BUSTER_CONTROL_EARLY_RELEASE BUSTER_CONTROL_EARLY_NATIVE BUSTER_SOURCE_WRITE_COLUMNS BUSTER_SOURCE_FILE_DATA BUSTER_SOURCE_GROW_GRAPH BUSTER_SOURCE_RETIRE_LISTS BUSTER_CONTROL_SOURCE_NATIVE BUSTER_PARSE_LIVE_FOREST BUSTER_LIVE_CHECKED_INPUT'.split()})
append = os.environ.get('LIVE_TIMING_APPEND') == '1'
with (d/'wall.tsv').open('a' if append else 'w',buffering=1) as log,(d/'pairs.tsv').open('a' if append else 'w',buffering=1) as pair:
 writer=csv.writer(log,delimiter='\t')
 if not append:writer.writerow(['unit','round','position','prefix_window','wall_ms','sha256'])
 pw=csv.writer(pair,delimiter='\t')
 if not append:pw.writerow(['unit','rounds','control_ms','early_ms','median_paired_ms','lower'])
 for u in os.environ.get('LIVE_TIMING_UNITS','sqlite main').split():
  args=subprocess.check_output(['bash','-c',srcargs,'_',str(w),u]).decode().strip('\0').split('\0')
  expected=hashlib.sha256((w/'source-typed-study'/(u+'.o')).read_bytes()).digest();hist={k:[] for k in ['control','early']}
  for r in range(5):
   part={k:[] for k in hist}
   for j,arm in enumerate(['control','early','early','control'] if r%2==0 else ['early','control','control','early']):
    cut='4294967294' if arm=='control' else '24';env=common|{'BUSTER_PRE_EOF_NATIVE_WINDOW':cut}
    out=d/'timed.o';out.unlink(missing_ok=True);begin=time.perf_counter_ns();proc=subprocess.run([exe,'--lanes','1','-c',*args,'-o',out],env=env,capture_output=True);el=(time.perf_counter_ns()-begin)/1e6
    assert proc.returncode==0 and not proc.stdout and not proc.stderr and hashlib.sha256(out.read_bytes()).digest()==expected,(u,proc.stderr[:300])
    part[arm].append(el);writer.writerow([u,r,j,cut,el,expected.hex()])
   for k in hist:hist[k].append(statistics.mean(part[k]))
  deltas=[b-a for a,b in zip(hist['control'],hist['early'])];pw.writerow([u,len(deltas),*(statistics.median(v) for v in [hist['control'],hist['early'],deltas]),sum(x<0 for x in deltas)])
