from pathlib import Path
import csv,gzip,hashlib,json,re,shutil,statistics,subprocess,tarfile
st=Path(__file__).resolve().parent;w=st.parent;tree=w/'default-ordered-integers';rev=subprocess.check_output(['git','-C',tree,'rev-parse','HEAD'],text=True).strip();base='40ae34f9d77afc42face58eff3338b7b1d1ba469';out=w/'perf/docs/measurements/window-compile-2850-2026-11-21'/rev[:9];out.mkdir(exist_ok=True)
subprocess.run(['python3',st/'runtime-edges.py'],check=True)
(out/'implementation.patch').write_bytes(subprocess.check_output(['git','-C',tree,'diff','--binary',base,rev]))
for f in ('qualify.py','stage.py','runtime.py','per-file.sh','package.py','reproduce.py','mutate.py','runtime-edges.py'):shutil.copy(st/f,out/f)
shutil.copy(w/'source-member-operands-study/pair-output.py',out/'pair-output.py')
with tarfile.open(out/'directed-cases.tar.gz','w:gz') as a:
 for f in (w/'ordinary-store-transfers-study/source-oracle/cases').glob('*.c'):a.add(f,arcname=f.name)
for k in ('oracle','per-file','stage','runtime','runtime-edges','mutation'):
 o=out/k;o.mkdir(exist_ok=True)
 for f in (st/k).glob('*.tsv'):shutil.copy(f,o)
 with tarfile.open(o/'raw.tar.gz','w:gz') as a:
  for f in sorted((st/k).rglob('*')):
   if f.is_file() and f.suffix not in ('.exe','.o'):a.add(f,arcname=f.relative_to(st/k))
shutil.copy(st/'oracle/failures.json',out/'oracle')
with tarfile.open(out/'checker-shards.tar.gz','w:gz') as t:
 for f in sorted(st.glob('checker-*.log')):t.add(f,arcname=f.name)
checks=sum(int(re.search(r'(\d+) checks?',p.read_text()).group(1)) for p in st.glob('checker-*.log') if re.search(r'(\d+) checks?',p.read_text()))
qat=list(csv.DictReader((st/'oracle/comparisons.tsv').open(),delimiter='\t'))
per=[row for name in ('sqlite','main','lua','musl') for row in csv.DictReader((st/'per-file'/(name+'.tsv')).open(),delimiter='\t')]
q=list(csv.DictReader((st/'stage/samples.tsv').open(),delimiter='\t'));summary=[]
for name in ('sqlite','buster'):
 for ser,metrics in [('wall',('ns','user-ns','system-ns','minor','peak-kib')),('pmu',('instructions-u','cycles-u'))]:
  a=[r for r in q if r['input']==name and r['series']==ser];n=5 if ser=='wall' else 3;assert len(a)==4*n
  for k in metrics:
   b,c=([statistics.mean(float(v[k]) for v in a if v['mode']==mode and int(v['round'])==i) for i in range(1,n+1)] for mode in ('baseline','candidate'));delta=[y-x for x,y in zip(b,c)]
   summary.append([name,ser,k,statistics.median(b),statistics.median(c),statistics.median(delta),min(delta),max(delta),sum(x<0 for x in delta),n])
with (out/'stage/paired.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('input','series','metric','control','candidate','paired-difference','minimum','maximum','faster','rounds'));t.writerows(summary)
with (out/'builds.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(('tree','revision','develop-compiler-sha256','predefines-sha256'))
 for n,r in [('default-integer-control',base),('default-ordered-integers',rev)]:
  t.writerow((n,r,*[hashlib.sha256((w/n/'build'/f).read_bytes()).hexdigest() for f in ('compiler','predefines.h')]))
err=json.loads((st/'oracle/failures.json').read_text());rt=list(csv.DictReader((st/'runtime/results.tsv').open(),delimiter='\t'));runtime_pass=all(len({r['execution-checksum'] for r in rt if r['argc']==str(a)})==1 for a in range(1,10)) and len(rt)==27
text=['# Integer result columns on the ordinary checker loop','',f'Buster `{rev}` applies the integer arithmetic, predicate, store and implicit conversion checker in normal single-translation-unit compilation. It groups the candidate operators within the existing graph walk and calls a separate checked-integer helper to share the original scalar fallback. The frozen control is the unmodified main revision `{base}`. Both ordinary native executables use the same native Develop toolchain and each invocation compiles source directly to an ELF object. [Change](implementation.patch) and [compiler and predefines identities](builds.tsv).','',f'The directed and real-source qualification used {len(qat)//2} input/option combinations across both compilers and found {len(err)} differences in status, stdout, diagnostic locations and text, dumps or ELF. The four frozen workloads provided {len(per):,} per-file builds with default, Wall/Wextra and Weverything policies. {sum(r["same"]!="1" for r in per)} differed. Eight checker shards completed {checks:,} assertions. [Directed comparisons](oracle/comparisons.tsv), [directed C sources](directed-cases.tar.gz), [raw diagnostic and dump streams](oracle/raw.tar.gz), [complete per-file outputs](per-file/raw.tar.gz) and [full checker-shard logs](checker-shards.tar.gz).','',f'A separate executable evaluates 196 functions over all ordered pairs of fourteen integer types. It checks assignments, initialization, comparison, arithmetic and logical negation against the native Clang 23 and ordinary Buster parent under nine runtime inputs. The comparison recorded {int(not runtime_pass)} runtime comparison failures across the 27 invocations. [Execution outcomes](runtime/results.tsv) and [source and compiler streams](runtime/raw.tar.gz).','','| Input | Paired full-object wall | Faster rounds | Paired user cycles | Paired user instructions |','| --- | ---: | ---: | ---: | ---: |']
for name in ('sqlite','buster'):
 s={r[2]:r for r in summary if r[0]==name};a=s['ns'];text.append(f'| {name} | {a[5]/1e6:+.3f} ms | {a[8]}/{a[9]} | {s["cycles-u"][5]:+,.0f} | {s["instructions-u"][5]:+,.0f} |')
text+=['','Five alternating ABBA/BAAB rounds measured each fresh ordinary compiler process on one local Ryzen 9 7940HS core. Three separate rounds measured user cycles and instructions. [Paired results](stage/paired.tsv), [raw wall and counter values](stage/samples.tsv) and [perf and compiler reports](stage/raw.tar.gz).']
text+=['','A second execution matrix exercises the same 196 type pairs with negative values and inputs across char and short conversion boundaries. Clang, main and the candidate agreed on all nine answers. [Per-compiler answers](runtime-edges/results.tsv) and [full source](runtime-edges/raw.tar.gz).']
muts=list(csv.DictReader((st/'mutation/outcomes.tsv').open(),delimiter='\t'))
mobs=muts[0]['ELF']==muts[1]['ELF'] and muts[0]['runtime']==muts[1]['runtime']
mdiff=muts[0]['ELF']!=muts[2]['ELF'] or muts[0]['runtime']!=muts[2]['runtime']
text+=['',f'The executable debugger control reached the specialized integer row in an ordinary native compile. The debugger control recorded {int(not mobs)} differences from the untreated ELF and execution result. Skipping publication of the first checked result produced {int(mdiff)} differing ELF or execution outcome. [Outcomes](mutation/outcomes.tsv), [source and debugger transcripts](mutation/raw.tar.gz) and [reproduction driver](mutate.py).']
text+=['','Use `git apply implementation.patch` in the candidate checkout at the recorded main revision. Compile both checkouts with `./build.sh --config Develop --target compiler --jobs 1`. With the frozen 9,507,037-byte SQLite amalgamation and Buster source checkout at `84a7d3d76891d6c393497e62e6aff38f2b162fc2`, the [standalone reproduction script](reproduce.py) runs the ordinary paired native oracle using `python3 reproduce.py --base BASE/build/compiler --candidate HEAD/build/compiler --sqlite SQLITE/sqlite3.c --buster-source FROZEN_BUSTER --out results`. The script verifies the SQLite SHA-256 and retains stdout, stderr, compiler status and ELF hashes.']
(out/'README.md').write_text('\n'.join(text)+'\n');print(out);print('\n'.join(text[-6:]))

replay=st/'standalone-replay'
res=subprocess.run(['python3',out/'reproduce.py','--base',w/'default-integer-control/build/compiler','--candidate',tree/'build/compiler','--sqlite',w/'switch-inputs/sqlite/sqlite3.c','--buster-source',w/'pregraph-warning-study/compiler-source','--out',replay],capture_output=True,text=True)
(out/'replay.txt').write_text(res.stdout+res.stderr)
replayed=list(csv.DictReader((replay/'comparisons.tsv').open(),delimiter='\t'))
if res.returncode or len(replayed)!=len(qat):raise RuntimeError([res.returncode,len(replayed),len(qat)])
shutil.copy(replay/'comparisons.tsv',out/'replay.tsv')
with (out/'README.md').open('a') as fp:fp.write(f'\nThe standalone reproduction completed {len(replayed)//2} paired cases with zero differences. [Replay output](replay.txt) and [replayed ELF and stream hashes](replay.tsv).\n')

subprocess.run(['python3',st/'long.py'],check=True)
if (st/'long/raw.tar.gz').exists():subprocess.run(['python3',st/'append-long.py'],check=True)
