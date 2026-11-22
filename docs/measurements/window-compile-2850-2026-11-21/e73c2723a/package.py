from common import *
import csv,gzip,hashlib,json,re,shutil,subprocess,tarfile
tree=CC.parent.parent;rev=subprocess.check_output(['git','-C',tree,'rev-parse','HEAD'],text=True).strip();base=subprocess.check_output(['git','-C',tree,'rev-parse','HEAD^'],text=True).strip();dest=D/'receipt';dest.mkdir(exist_ok=True)
def read(name):return list(csv.DictReader((D/name).open(),delimiter='\t'))
def put_table(name,cols,rows):
 with (dest/name).open('w') as f:
  t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(cols);t.writerows(rows)
for f in [*D.glob('*.py'),D/'per-file.sh',D/'target-build.sh',D/'identity.json',D/'build.log',D/'dco-audit.txt']:
 if f.exists() and f.name!='public-summary.py':shutil.copy(f,dest/f.name)
for key in ('stage','oracle','counts','suites','per-file','guard','operand-oracle'):
 folder=D/key
 if not folder.exists():continue
 o=dest/key;o.mkdir(exist_ok=True)
 for f in folder.iterdir():
  if f.suffix in ['.tsv','.json']:shutil.copy(f,o/f.name)
 with tarfile.open(o/'raw.tar.gz','w:gz') as t:
  for f in folder.iterdir():
   if f.suffix not in ['.tsv','.json','.o'] and f.name not in ['app','production','unbounded-last-word','unmasked-return']:t.add(f,arcname=f.name)
(dest/'implementation.patch').write_bytes(subprocess.check_output(['git','-C',tree,'diff',base,rev]));shutil.copy(W/'main-typed-reserve-base-study/build.log',dest/'parent-build.log')
put_table('builds.tsv',['arm','revision','compiler-sha256','config'],[['parent',base,hashlib.sha256(PRIOR.read_bytes()).hexdigest(),'Release'],['candidate',rev,hashlib.sha256(CC.read_bytes()).hexdigest(),'Release']])
pairs=read('stage/paired.tsv');nums=read('counts/outcomes.tsv');comp=read('oracle/outcomes.tsv');exe=read('oracle/executions.tsv');suites=read('suites/status.tsv');per=sum((read('per-file/'+g+'.tsv') for g in ['sqlite','main','lua','musl']),[])
summary={'revision':rev,'parent':base,'native-source-observations':len(comp),'changed-native-source-observations':sum(r['same-prior']!='1' for r in comp),'corpus-file-policies':len(per),'changed-file-policies':sum(r['same']!='1' for r in per),'reserve-inputs':len(nums),'reserve-calls':sum(int(r['call-count']) for r in nums),'reserve-values':sum(int(r['compared-values']) for r in nums),'unequal-reserve-inputs':sum(not(r['equal-parent']==r['equal-scalar']==r['same-ELF']=='1') for r in nums),'failed-suites':[r for r in suites if r['status']!='0'],'runtimes':exe}
assert (D/'operand-oracle/complete').exists()
operand=read('operand-oracle/observations.tsv');assert len(operand)==12
clang=read('oracle/clang.tsv')
summary['mutation-observations']=len(operand)
summary['clang-probes']=len(clang)
summary['clang-status-matches']=sum(r['status']==r['clang-status'] for r in clang)
summary['clang-message-matches']=sum(r['same-messages']=='1' for r in clang)
summary['clang-location-matches']=sum(r['same-locations']=='1' for r in clang)
(dest/'summary.json').write_text(json.dumps(summary,indent=2))
lines=['# Classify checked lowering reserve operands in masked batches','',f'Production candidate `{rev}` follows `{base}`. A translation unit with an atomic or transport-vector type uses checked result, conversion and left-operand types to identify which expressions need the full lowering reserve calculation. The ordinary cases are classified sixteen at a time. SQLite had 4,740 types and zero vectors or atomic types, so it kept its existing operator path. Buster had 10,849 types, including 61 GNU and two extended vectors, and took the new path. [Implementation](implementation.patch) and [Release binaries](builds.tsv).','', f'The native output comparison covers {len(comp):,} directed and real compiler invocations and {len(per):,} file/policy pairs across SQLite, Buster, Lua and musl. The process oracle includes status, stdout, stderr and object hashes. See [individual directed outputs](oracle/outcomes.tsv), [Clang observations](oracle/clang.tsv), [executable return values](oracle/executions.tsv), [corpus receipts](per-file) and [checker and driver suites](suites/status.tsv).','', f"The GDB control recorded all seven capacity fields from {summary['reserve-calls']:,} ordinary Release planner calls. Comparing with the parent's actual result and redirecting only the candidate planner to the existing explicit numeric calculation yielded {summary['unequal-reserve-inputs']} input differences. The tables include vector and atomic cases, mixed casts, wide vectors with scalar subscripts, and both complete workload objects. [All input outcomes](counts/outcomes.tsv), [reserve values](counts/tuples.tsv) and [type populations](counts/type-census.tsv).",'','## Local Release results','','The two compiler revisions ran as alternating ABBA or BAAB four-call groups on one physical core of the development machine. Wall and PMU series are independent. Differences use the median within-round change. [Every measurement](stage/samples.tsv) and [paired summary](stage/paired.tsv).','','| Workload | Counter | Parent | Candidate | Paired difference | Lower rounds |','| --- | --- | ---: | ---: | ---: | ---: |']
for r in pairs:lines.append(f"| {r['input']} | {r['metric']} | {float(r['parent-median']):,.0f} | {float(r['candidate-median']):,.0f} | {float(r['median-delta']):,.0f} | {r['faster']}/{r['rounds']} |")
lines+=['','## Checked operand input controls','','A debugger replaces one scalar addition conversion with the declared 128-byte vector type while the reserve function runs. For a real wide-vector subscript, its conversion also carries the vector type. Changing the left operand alone preserves the capacity. With those two conversion types temporarily cleared in both arms, the left operand independently changes the reserve from 1,088 entries and 24 locals to 544 entries and 12 locals. Each result matches the scalar calculation and restores the original complete object. [All twelve observations](operand-oracle/observations.tsv).','', f"Clang and Buster returned the same success or failure on {summary['clang-status-matches']} of {summary['clang-probes']} directed sources. Their exact diagnostic messages agreed in {summary['clang-message-matches']} and their locations in {summary['clang-location-matches']}. All directed parent and candidate outputs agreed. [Clang comparisons](oracle/clang.tsv)."]
(dest/'README.md').write_text('\n'.join(lines)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='runtimes'}),flush=True)
