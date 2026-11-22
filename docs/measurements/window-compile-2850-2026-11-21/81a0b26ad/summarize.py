from pathlib import Path
import csv,gzip,hashlib,json,re,shutil,statistics,subprocess,sys,tarfile
st=Path(__file__).resolve().parent;w=st.parent;tree=w/'body-action-transfers';base='4bd73ecaf27519017ab6d710a3d7c0d4d49071aa';rev=subprocess.check_output(['git','-C',tree,'rev-parse','HEAD'],text=True).strip()
dest=w/'perf/docs/measurements/window-compile-2850-2026-11-21'/rev[:9];dest.mkdir(parents=True,exist_ok=True)
def frame(fname,header,rows):
 with (dest/fname).open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(header);t.writerows(rows)
def freq(d):
 return {key:int(val) for kv in d.split('\t')[1:] for key,val in [kv.split('=',1)]}
for f in ('oracle.py','stage.py','census.py','summarize.py'):shutil.copy(st/f,dest/f)
(dest/'implementation.patch').write_bytes(subprocess.check_output(['git','-C',tree,'diff','--binary',base,rev]))
(dat:=dest/'oracle').mkdir(exist_ok=True);shutil.copy(st/'oracle/comparisons.tsv',dat);shutil.copy(st/'oracle/failures.json',dat);(dest/'stage').mkdir(exist_ok=True)
for k,files in [('oracle',list((st/'oracle').glob('*.gz'))+list((st/'oracle/cases').glob('*.c'))),('stage',list((st/'stage').glob('*.stderr'))+list((st/'stage').glob('*.perf')))]:
 with tarfile.open(dest/k/'raw.tar.gz','w:gz') as t:
  for f in files:t.add(f,arcname=str(f.relative_to(st/k)))
shutil.copy(st/'stage/samples.tsv',dest/'stage')
q=list(csv.DictReader((st/'stage/samples.tsv').open(),delimiter='\t'));summary=[];audit=[];coverage=[];ops=[]
for name in ('sqlite','buster'):
 for sc in ('functions','declarations'):
  each=[x for x in q if x['input']==name and x['scope']==sc]
  for series,metrics in [('wall',('ns','user-ns','system-ns','minor','peak-kib')),('pmu',('instructions-u','cycles-u'))]:
   sets=[x for x in each if x['series']==series];n=len(sets)//4;assert n==(5 if series=='wall' else 3)
   for m in metrics:
    vals={k:[statistics.mean(float(x[m]) for x in sets if x['mode']==k and int(x['round'])==i) for i in range(1,n+1)] for k in ('baseline','candidate')};a,b=vals.values();d=[y-x for x,y in zip(a,b)];summary.append([name,sc,series,m,statistics.median(a),statistics.median(b),statistics.median(d),min(d),max(d),sum(y<0 for y in d),n])
  for mode in ('baseline','candidate'):
   samples=[x for x in each if x['series']=='coverage' and x['mode']==mode];measures=[]
   for x in samples:
    k=f'{name}.{sc}.coverage.{x["round"]}.{x["position"]}.{mode}.stderr';lines=(st/'stage'/k).read_text().splitlines();measures.append(freq(next(s for s in lines if s.startswith('body-check-cost\t'))))
   for key in measures[0]:audit.append([name,sc,mode,key,statistics.median(x[key] for x in measures)])
   rr=freq(next(s for s in lines if s.startswith('body-action-rows\t')));coverage.append([name,sc,mode,*rr.values()])
   for s in lines:
    if s.startswith('body-action-op\t'):op,count=s.split('\t')[1:];ops.append([name,sc,mode,op,count])
frame('stage/paired.tsv',['input','scope','series','metric','control-median','candidate-median','paired-median','min','max','faster','rounds'],summary)
frame('stage/check-cost.tsv',['input','scope','mode','metric','median'],audit)
frame('stage/coverage.tsv',['input','scope','mode',*list(rr)],coverage)
frame('stage/operators.tsv',['input','scope','mode','checkop','rows'],ops)
bad=json.loads((st/'oracle/failures.json').read_text());text=['# Mixed integer transfer rows in the function-local checker','',f'Buster `{rev}` extends the existing source-local checker `{base}`. Each block classifies up to sixteen source operators. Within that block, expressions run in their original postorder and can read an immediately preceding result. Unknown arithmetic uses the type system’s existing integer-promotion and pair-conversion tables. Eligible predicates use the checked operand type and category, including unqualified pointers. The producer writes the result type, flags and each operand conversion. The ordinary checker handles folds, exceptional contexts and unrecognized forms. [Source patch](implementation.patch)','',f'The source/checked-output oracle has {len(bad)} recorded differences. Each source scope compares the candidate, checked on the function-local graph, against both the ordinary whole graph and the preceding source-local implementation, including earlier independent archived fingerprints for both frozen inputs. The directed fixtures cover type conversions, integer faults, sequencing, volatile and atomic accesses, floating environments and ineligible operands. A 196-function matrix covers every pair of fourteen standard and 128-bit integer types with eighteen binary operators and three unary or conditional forms. [Per-input cases](oracle/comparisons.tsv), [differences](oracle/failures.json) and [raw source and output](oracle/raw.tar.gz).','','| Input | Scope | Nodes | Checked actions taken | Paired stage wall change | Paired user instructions |','| --- | --- | ---: | ---: | ---: | ---: |']
for name in ('sqlite','buster'):
 for sc in ('functions','declarations'):
  c=next(x for x in coverage if x[:3]==[name,sc,'candidate']);r=dict(zip(rr,c[3:]));wl=next(x for x in summary if x[:4]==[name,sc,'wall','ns']);ins=next(x for x in summary if x[:4]==[name,sc,'pmu','instructions-u'])
  text.append(f'| {name} | {sc} | {r["nodes"]:,} | {r["taken"]:,} | {wl[6]/1e6:+.3f} ms ({wl[-2]}/{wl[-1]} faster) | {ins[6]:+,.0f} |')
text+=['','The matched local 7940HS Develop stage starts a fresh process, preprocesses, parses and checks the selected source range. Both modes stop at the same reader boundary before normal source finalizers and native output. The wall series uses five alternating ABBA/BAAB rounds per workload and scope. Three separate rounds per workload and scope record user-mode instructions and cycles. The instrumented stage breakdown uses a fenced x86 timestamp counter around the existing checker boundaries. It includes workspace and validation, discovery of constant contexts, allocation and initialization of the result stream, action dispatch and the completion passes. Output and scratch byte counts report arena charges. [Per-mode coverage](stage/coverage.tsv), [individual operator counts](stage/operators.tsv), [stage breakdown](stage/check-cost.tsv), [paired measurements](stage/paired.tsv), [samples](stage/samples.tsv) and [raw reports](stage/raw.tar.gz).']
(dest/'README.md').write_text('\n'.join(text)+'\n');print(dest);print('\n'.join(text[6:14]))
