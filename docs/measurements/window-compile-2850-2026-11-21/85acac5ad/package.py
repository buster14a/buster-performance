from common import *
import csv,hashlib,json,shutil,subprocess,tarfile
tree=CC.parent.parent
def git(*a):return subprocess.check_output(['git','-C',tree,*a])
base=git('rev-parse','HEAD^').decode().strip();rev=git('rev-parse','HEAD').decode().strip();o=W/'perf/docs/measurements/window-compile-2850-2026-11-21'/rev[:9];o.mkdir(exist_ok=True)
(o/'implementation.patch').write_bytes(git('diff','--binary',base,rev))
for p in ('common.py','locations.py','run.py','qualify.py','suites.py','stage.py','profile.py','mutation.py','package.py','per-file.sh','pair-output.py','build.log'):
 if (D/p).exists():shutil.copy(D/p,o/p)
for k in ('oracle','stage','suites','mutation','profile','per-file'):
 q=D/k
 if not q.exists():continue
 dest=o/k;dest.mkdir(exist_ok=True)
 for f in q.iterdir():
  if f.suffix in ['.tsv','.json']:shutil.copy(f,dest/f.name)
 with tarfile.open(dest/'raw.tar.gz','w:gz') as t:
  for f in sorted(q.rglob('*')):
   if f.is_file() and f.suffix not in ['.o','.exe']:t.add(f,arcname=f.relative_to(q))
with (o/'builds.tsv').open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['mode','revision','sha256']);t.writerows([[k,r,hashlib.sha256(p.read_bytes()).hexdigest()] for k,r,p in [('prior-Develop',base,PRIOR),('new-Develop',rev,CC)]])
def tsv(f):return list(csv.DictReader(f.open(),delimiter='\t')) if f.exists() else []
q=D/'oracle';bad=json.loads((q/'failures.json').read_text());hist=json.loads((q/'historical.json').read_text());obs=tsv(q/'comparisons.tsv');fp=tsv(q/'fingerprints.tsv');paired=tsv(D/'stage/paired.tsv');suites=tsv(D/'suites/status.tsv');per=[r for f in (D/'per-file').glob('*.tsv') for r in tsv(f)];mut=tsv(D/'mutation/results.tsv')
text=['# Track counted pointer members on main','',f'Clean main revision `{rev}` applies the first-counted-pointer declaration fact to `{base}`. The checker tests a type-table field before inspecting counted reads and assignments. Type copies preserve the index and speculative rollback clears it precisely when the first declaration was withdrawn. [Production change and synthetic tests](implementation.patch) and [both optimized compiler identities](builds.tsv).','',f'{len(obs):,} ordinary process observations recorded {len(bad)} parent/candidate differences across frozen SQLite and Buster, parsed counted attributes, negative diagnostics and graph dumps. [Outputs and ELF hashes](oracle/comparisons.tsv), [Clang diagnostics](oracle/clang.tsv) and [all directed programs and raw streams](oracle/raw.tar.gz).','','| Input | Scope | Paired wall | Faster wall rounds | Paired instructions | Paired cycles | Faster counter rounds |','| --- | --- | ---: | ---: | ---: | ---: | ---: |']
for n in args:
 for sc in ('native','ordinary','functions'):
  ps={v['metric']:v for v in paired if v['input']==n and v['scope']==sc}
  if len(ps)!=3:continue
  a,ins,cy=ps['ns'],ps['instructions'],ps['cycles'];text.append(f"| {n} | {sc} | {float(a['median-delta'])/1e6:+.3f} ms | {a['faster']}/{a['rounds']} | {float(ins['median-delta']):+,.0f} | {float(cy['median-delta']):+,.0f} | {cy['faster']}/{cy['rounds']} |")
text+=['','Paired local Ryzen 9 7940HS trials used exact Develop builds of the parent and candidate under the same flags. Five alternating ABBA/BAAB wall rounds and three counter rounds emitted the identical frozen native ELF. [Paired results](stage/paired.tsv), [raw observations and ELF hashes](stage/samples.tsv) and [counter streams](stage/raw.tar.gz).']
if suites:text+=['',f"Regression suite exit statuses include {sum(r['exit']!='0' for r in suites)} failing commands out of {len(suites)}. [Suite statuses](suites/status.tsv) and [complete suite output](suites/raw.tar.gz)."]
if per:text+=['',f"Across {len(per):,} SQLite, Buster, Lua and musl file/policy combinations, {sum(r['same']!='1' for r in per)} parent-versus-candidate native status, diagnostic or ELF comparisons differed. [Corpus tables and streams](per-file/raw.tar.gz)."]
if mut:text+=['',f"The debugger observed the production declaration fact on parsed counted-pointer input. With the recorded member the ordinary compiler issued {mut[0]['cannot-use']} read and {mut[0]['cannot-assign']} assignment errors. Zeroing only the declaration fact before the checker ran yielded {mut[-1]['cannot-use']} read and {mut[-1]['cannot-assign']} assignment errors. [Guarded diagnostic outcomes](mutation/results.tsv) and [sources, layouts and debugger traces](mutation/raw.tar.gz)."]
if (o/'profile/config.json').exists():text+=['','Fresh parent and candidate profiles used six ordinary source-native object invocations per workload and arm, with one sample per 250,007 user instructions. [SQLite symbol differences](profile/sqlite.deltas.tsv), [parent SQLite sites](profile/sqlite.control.sites.tsv), [candidate SQLite sites](profile/sqlite.producer.sites.tsv), [Buster symbol differences](profile/main.deltas.tsv) and [raw traces](profile/raw.tar.gz).']
if (D/'oracle/clang-locations.tsv').exists():
 locs=tsv(D/'oracle/clang-locations.tsv');text+=['',f'The per-source Clang check found matching ordered diagnostic locations and severities in {sum(r["same-locations-and-severities"]=="1" for r in locs)} of {len(locs)} comparisons. Exact messages are recorded separately. [Clang event comparisons](oracle/clang-locations.tsv).']
(o/'README.md').write_text('\n'.join(text)+'\n');print(o)
