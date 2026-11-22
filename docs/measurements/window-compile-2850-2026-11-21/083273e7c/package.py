from common import *
import csv,gzip,hashlib,json,shutil,statistics,subprocess,tarfile
tree=CC.parent.parent;rev=subprocess.check_output(['git','-C',tree,'rev-parse','HEAD'],text=True).strip();base='b352534f202b8a739923cd8b5c8953f773f6a9e1';out=W/'perf/docs/measurements/window-compile-2850-2026-11-21'/rev[:9];out.mkdir(exist_ok=True)
(out/'implementation.patch').write_bytes(subprocess.check_output(['git','-C',tree,'diff','--binary',base,rev]))
for f in ('common.py','qualify.py','reproduce.py','stage.py','package.py','live.py','mutation.py'):
 if (D/f).exists():shutil.copy(D/f,out)
for folder in ('oracle','stage','live','mutation'):
 if not (D/folder).exists():continue
 dest=out/folder;dest.mkdir(exist_ok=True)
 for f in sorted((D/folder).glob('*')):
  if f.suffix in ('.tsv','.json'):shutil.copy(f,dest/f.name)
 with tarfile.open(dest/'raw.tar.gz','w:gz') as ar:
  for f in sorted((D/folder).rglob('*')):
   if f.is_file() and f.suffix not in ('.o','.exe'):ar.add(f,arcname=f.relative_to(D/folder))
with (out/'builds.tsv').open('w') as fp:t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['mode','commit','compiler-sha256']);t.writerows([[n,revv,hashlib.sha256(binary.read_bytes()).hexdigest()] for n,revv,binary in [('source-parent',base,PRIOR),('source-arithmetic',rev,CC)]])
q=list(csv.DictReader((D/'stage/samples.tsv').open(),delimiter='\t'));paired=[]
for name in args:
 for scope in ('native','local-stage'):
  src=[r for r in q if r['input']==name and r['scope']==scope]
  for series,metrics in [('wall',['ns','user-ns','system-ns','minor','peak-kib']),('pmu',['instructions-u','cycles-u'])]:
   sub=[r for r in src if r['series']==series];rounds=5 if series=='wall' else 3;assert len(sub)==rounds*4,(name,scope,len(sub))
   for metric in metrics:
    a,b=([statistics.mean(float(r[metric]) for r in sub if r['round']==str(i) and r['mode']==m) for i in range(1,rounds+1)] for m in ('baseline','candidate'));delta=[y-x for x,y in zip(a,b)];paired.append((name,scope,series,metric,statistics.median(a),statistics.median(b),statistics.median(delta),min(delta),max(delta),sum(x<0 for x in delta),rounds))
with (out/'stage/paired.tsv').open('w') as fp:t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['input','scope','series','metric','control','producer','paired-median','minimum','maximum','faster','rounds']);t.writerows(paired)
coverage=list(csv.DictReader((D/'oracle/coverage.tsv').open(),delimiter='\t'))
totals={}
for r in coverage:
 key=(r['input'],r['scope']);row=totals.setdefault(key,dict(bodies=0,nodes=0,leaves=0,candidates=0,proofs=0,chains=0,taken=0));row['bodies']+=1
 for c in ('nodes','leaves','candidates','proofs','chains','taken'):row[c]+=int(r[c])
with (out/'oracle/totals.tsv').open('w') as fp:t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['input','scope',*next(iter(totals.values()))]);t.writerows([[*k,*v.values()] for k,v in totals.items()])
bad=json.loads((D/'oracle/failures.json').read_text());prev=json.loads((D/'oracle/previous.json').read_text());hist=json.loads((D/'oracle/historical-elf.json').read_text())
text=['# Source-produced checked integer expressions','',f'Buster `{rev}` runs a postorder integer semantic producer inside the pending source-expression batch on the function-local object compiler `{base}`. A parameter or literal supplies a checked operand word. The source append computes each supported nonleaf’s result type, both promoted operand types and their exact lvalue, promotion and arithmetic-conversion flags. Later source expressions consume earlier arithmetic results before the graph columns are populated. The normal checker consumes a matching proof directly. Rewritten edges, constant evaluation, FP access, overloads, uncertain operand shapes and folds retain their ordinary actions. [Patch](implementation.patch) and [compiler identities](builds.tsv).','','| Input | Native trials | Source-local nodes | Arithmetic proofs produced | Proofs using an earlier arithmetic result | Proofs consumed |','| --- | ---: | ---: | ---: | ---: | ---: |']
for n in args:
 z=totals[n,'native'];text.append(f'| {n} | {z["bodies"]:,} | {z["nodes"]:,} | {z["proofs"]:,} | {z["chains"]:,} | {z["taken"]:,} |')
text += ['',f'Native status, diagnostic text, typed or static output, ELF hashes and checked-graph comparisons recorded {len(bad)} candidate-versus-control differences. {len(prev)} comparisons also record differences already present between ordinary compilation and the parent’s source-local route. The two frozen objects for each real workload matched in {sum(r[-1] for r in hist)} of {len(hist)} checks. [Native outputs](oracle/native.tsv), [checked scopes](oracle/checked.tsv), [differences](oracle/failures.json), [baseline scope differences](oracle/previous.json), [saved object identities](oracle/historical-elf.json), [body-level proof coverage](oracle/coverage.tsv), [totals](oracle/totals.tsv) and [source, statuses and full raw streams](oracle/raw.tar.gz).','','| Input | Scope | Paired wall | Faster wall rounds | Paired user instructions | Paired user cycles |','| --- | --- | ---: | ---: | ---: | ---: |']
for n in args:
 for sc in ('native','local-stage'):
  m={r[3]:r for r in paired if r[:2]==(n,sc)};a=m['ns'];text.append(f'| {n} | {sc} | {a[6]/1e6:+.3f} ms | {a[9]}/{a[10]} | {m["instructions-u"][6]:+,.0f} | {m["cycles-u"][6]:+,.0f} |')
text+=['','All stage measurements used one local Ryzen 9 7940HS core and the same optimized binary. The native comparisons enable the existing source-owned function path on both arms and emit a full ordinary ELF for each process. The stage-only arms admit all complete functions and stop at the same checker boundary. Five alternating ABBA/BAAB rounds measured wall time. Three additional rounds measured user cycles and instructions. [Paired results](stage/paired.tsv), [per-process samples with ELF hashes](stage/samples.tsv) and [raw output and counters](stage/raw.tar.gz).']
if (out/'live/comparisons.tsv').exists():
 live=list(csv.DictReader((out/'live/comparisons.tsv').open(),delimiter='\t'));text+=['',f'Fingerprints were also taken inside the actual source-native trials. The producer and the source-native control differed at {sum(int(r["producer-vs-live-control-differences"]) for r in live)} function endings. The table separately identifies differences between the unchanged local trials and a whole-unit ordinary check. [Native trial fingerprints](live/comparisons.tsv) and [raw per-function records](live/raw.tar.gz).']
if (out/'mutation/results.tsv').exists():
 mut=list(csv.DictReader((out/'mutation/results.tsv').open(),delimiter='\t'));text+=['',f'The debugger selected the first signed comparison proof at the checker input. The untouched source-native function returned `{mut[1]["runtime"]}`. Replacing the source-produced signed operand types with unsigned types returned `{mut[3]["runtime"]}`. The ordinary and observed controls retain their ELF hashes and runtime output. [Guarded outcomes](mutation/results.tsv) and [source and raw debugger transcripts](mutation/raw.tar.gz).']
text+=['','The [standalone replay](reproduce.py) extracts the archived directed sources, accepts the two compiler paths and the frozen SQLite, Buster and predefines paths, and compares complete native outputs and ordinary source-local checked fingerprints without the original study directories.']
(out/'README.md').write_text('\n'.join(text)+'\n');print(out);print('\n'.join(text[5:8]))
