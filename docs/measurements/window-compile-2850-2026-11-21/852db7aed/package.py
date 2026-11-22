from pathlib import Path
import csv,gzip,hashlib,json,platform,shutil,statistics,subprocess,tarfile
st=Path(__file__).resolve().parent;w=st.parent;tree=w/'ordinary-action-transfers';rev=subprocess.check_output(['git','-C',tree,'rev-parse','HEAD'],text=True).strip();base='4bd73ecaf27519017ab6d710a3d7c0d4d49071aa';out=w/'perf/docs/measurements/window-compile-2850-2026-11-21'/rev[:9];out.mkdir(exist_ok=True)
(out/'implementation.patch').write_bytes(subprocess.check_output(['git','-C',tree,'diff','--binary',base,rev]))
for file in ('stage.py','qualify.py','package.py','four.sh'):shutil.copy(st/file,out)
for folder,extra in [('stage',('samples.tsv',)),('oracle',('comparisons.tsv','failures.json')),('four',())]:
 dest=out/folder;dest.mkdir(exist_ok=True)
 for k in extra:shutil.copy(st/folder/k,dest/k)
 with tarfile.open(dest/'raw.tar.gz','w:gz') as ar:
  for f in (st/folder).rglob('*'):
   if f.is_file() and f.suffix not in ('.o','.exe'):ar.add(f,arcname=f.relative_to(st/folder))
with tarfile.open(out/'cases.tar.gz','w:gz') as ar:
 for f in (w/'body-action-transfers-study/oracle/cases').glob('*.c'):ar.add(f,arcname=f.name)
q=list(csv.DictReader((st/'stage/samples.tsv').open(),delimiter='\t'));summary=[]
for name in ('sqlite','buster'):
 for ser,metrics in [('wall',('ns','user-ns','system-ns','minor','peak-kib')),('pmu',('instructions-u','cycles-u'))]:
  a=[r for r in q if r['input']==name and r['series']==ser];n=5 if ser=='wall' else 3;assert len(a)==4*n
  for k in metrics:
   b,c=([statistics.mean(float(v[k]) for v in a if v['mode']==mode and int(v['round'])==i) for i in range(1,n+1)] for mode in ('baseline','candidate'));delta=[y-x for x,y in zip(b,c)]
   summary.append([name,ser,k,statistics.median(b),statistics.median(c),statistics.median(delta),min(delta),max(delta),sum(x<0 for x in delta),n])
with (out/'stage/paired.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('input','series','metric','control','candidate','paired-difference','minimum','maximum','faster','rounds'));t.writerows(summary)
errors=json.loads((st/'oracle/failures.json').read_text());comp=list(csv.DictReader((st/'oracle/comparisons.tsv').open(),delimiter='\t'));bunch=[]
for c in ('sqlite','main','lua','musl'):
 for k in ('normal','warn','diagnostic'):
  a=st/'four'/(c+'-prior-'+k);b=st/'four'/(c+'-source-'+k)
  col=[a.with_suffix('.'+ext).read_bytes()==b.with_suffix('.'+ext).read_bytes() for ext in ('status','stdout','stderr','objects')]
  bunch.append([c,k,a.with_suffix('.status').read_text().strip(),len(a.with_suffix('.objects').read_text().splitlines()),*map(int,col)])
with (out/'four/comparisons.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('workload','policy','status','objects','same-status','same-stdout','same-stderr','same-objects'));t.writerows(bunch)
text=['# Integer transfer rows on the ordinary native compilation route','',f'Buster `{rev}` runs the mixed integer and predicate checker during normal graph validation, warning finalization, lowering and native object emission when `BUSTER_CHECK_ORDINARY_ACTION_ROWS=1` is set. All comparisons use the same input paths and compiler flags. The two timed arms use the same native Develop binary on one Ryzen 9 7940HS core. [Source diff](implementation.patch) and [source-local stage](../81a0b26ad/README.md).','',f'The source, native-object, warning-policy and dump oracle recorded {len(errors)} differences in {len(comp)//3} directed or real-source comparisons. Each result records ordinary compiler exit status, standard output, diagnostic streams and ELF hash. Two further scopes on each frozen input compare the specialized checker’s whole-unit checked results to independent reference fingerprints. [Oracle outcomes](oracle/comparisons.tsv), [differences](oracle/failures.json), [raw streams and ordinary checker coverage](oracle/raw.tar.gz) and [directed C sources](cases.tar.gz).','',f'Frozen SQLite, Buster self, Lua and musl whole-workload invocations compared {sum(row[3] for row in bunch):,} object results over three warning policies. {sum(not all(row[4:]) for row in bunch)} of the 12 workload/policy invocations differed. [Whole-workload outcomes](four/comparisons.tsv) and [output and ELF manifests](four/raw.tar.gz).','','| Input | Paired object wall change | Faster rounds | Paired user cycles | Paired user instructions |','| --- | ---: | ---: | ---: | ---: |']
for name in ('sqlite','buster'):
 s={r[2]:r for r in summary if r[0]==name};a=s['ns'];text.append(f'| {name} | {a[5]/1e6:+.3f} ms | {a[8]}/{a[9]} | {s["cycles-u"][5]:+,.0f} | {s["instructions-u"][5]:+,.0f} |')
text+=['','Each fresh process compiled the full input to a native object. Five ABBA/BAAB rounds measured elapsed time and three separate rounds measured user counters through perf. Positive differences indicate additional candidate cost. [All paired metrics](stage/paired.tsv), [per-process samples](stage/samples.tsv) and [raw process output and perf counters](stage/raw.tar.gz).']
(out/'README.md').write_text('\n'.join(text)+'\n');print(out);print('\n'.join(text[-6:]))
