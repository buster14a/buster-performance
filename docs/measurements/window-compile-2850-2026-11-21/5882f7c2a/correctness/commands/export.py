from pathlib import Path
import csv,collections,datetime,hashlib,json,subprocess,shutil,sys,gzip
p=Path(__file__).resolve().parent;r=p/sys.argv[1];w=p.parent;tree=w/'window-constants';o=w/('current-constant-export-'+sys.argv[1]);o.mkdir(exist_ok=True)
def put(name,data):
 dest=o/name;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data)
def redact(b):
 return b.replace(str(w).encode()+b'/',b'work/').replace(str(Path.home()).encode()+b'/',b'~/')
def digest(bytes_):return hashlib.sha256(bytes_).hexdigest()
def cp(src,fn):
 if src.is_file():put(fn,redact(src.read_bytes()))
for script in ['driver.py','stages.py','runtime.py','assertions.py','perf.py','go.sh','cross.sh','perf.sh','msan.sh','refresh.sh','cold.sh','export.py']:cp(p/script,'commands/'+script)
put('source/changes.patch',subprocess.check_output(['git','diff','--binary','b86eadcbd..'+sys.argv[1]],cwd=tree))
put('source/commits.txt',subprocess.check_output(['git','log','--format=%H %s%n%b','b86eadcbd..'+sys.argv[1]],cwd=tree))
put('source/DCO.txt',subprocess.check_output([w/'buster/build/dco','audit','--base','b86eadcbd','--head',sys.argv[1]],cwd=tree))
for fname in ['part5.log','attested.log','fixture.err','assertion-oracle/cases.tsv','runtime/runtime.c','runtime/stage.err','runtime/records.json','msan/part5.log','msan/on.diag','msan/off.diag','extra/checks.tsv','perf/pmu-summary.tsv','perf/sqlite-preflight.json','perf/self-preflight.json','perf/sqlite.json','perf/self.json','perf/lua.json','perf/musl.json','perf/runs.tsv']:
 cp(r/fname,fname)
q=[]
for st in ['frozen','tracked','generated']:
 file=r/st/(st+'.tsv')
 if not file.exists():continue
 put(st+'.tsv.gz',gzip.compress(redact(file.read_bytes()),mtime=0));rows=list(csv.DictReader(file.open(),delimiter='\t'));groups=collections.defaultdict(list)
 for row in rows:groups[(row['corpus'],row['policy'])].append(row)
 for (corpus,ix),a in groups.items():
  q.append([st,corpus,ix,len(a),sum(x['same']=='True' for x in a),sum(x['option_elf']!='' for x in a),sum(x['option_status']!='0' for x in a)])
 for file in (r/st).glob('*.err'):cp(file,'differing-diagnostics/'+st+'/'+file.name)
summ=o/'qualification.tsv'
with summ.open('w') as f:
 wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(['suite','corpus','policy_index','triples','all_observables_equal','ELF_produced','rejected_input']);wr.writerows(q)
stage=r/'stages/stage-counts.tsv';data=[]
if stage.exists():
 put('stages/units.tsv.gz',gzip.compress(redact(stage.read_bytes()),mtime=0))
 for corpus,rs in __import__('itertools').groupby(csv.DictReader(stage.open(),delimiter='\t'),key=lambda x:x['corpus']):
  a=list(rs);data.append([corpus,len(a),*[sum(int(i[k]) for i in a) for k in ['roots','removed','remaining_graph']]])
 put('stages/corpus.tsv',('corpus\tunits\tadmitted\tremoved\tremaining\n'+''.join('\t'.join(map(str,row))+'\n' for row in data)).encode())
cp(p/'README.md','README.md')
cp(p/(sys.argv[1]+'-results.md'),'RESULTS.md')
with (o/'SHA256SUMS').open('w') as f:
 for s in sorted(o.rglob('*')):
  if s.is_file() and s.name!='SHA256SUMS':print(digest(s.read_bytes())+'  '+str(s.relative_to(o)),file=f)
