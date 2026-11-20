from pathlib import Path
import csv,hashlib,json,os,shlex,subprocess,tempfile
p=Path(__file__).resolve().parent;w=p.parent;read=lambda f:list(csv.DictReader(f.open(),delimiter='\t'));env=dict(os.environ,LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
for label,tree in [('addend','fma-addend'),('first','fma-first')]:
 q=w/(label+'-cost-validation');src=w/(tree+'-evidence')/'opus';rows=[]
 with tempfile.TemporaryDirectory() as td:
  out=Path(td)/'unit.o'
  for config in ['portable-nosp','dispatch-nosp']:
   cmds=[x for x in json.loads((src/config/'compile_commands.json').read_text()) if 'CMakeFiles/opus.dir/' in x['command']]
   for arch in ['x86-64-v3','znver5']:
    if label=='addend':refs={r['source']:r['same_object_sha256'] for r in read(src/'final-objects.tsv') if r['configuration']==config and r['target']==arch}
    else:refs={r['source']:r['sha256'] for r in read(src/'compiled'/(config if arch=='znver5' else config+'-'+arch)/'candidate/units.tsv')}
    assert len(refs)==len(cmds)
    for z in cmds:
     f=Path(z['file']);unit=str(f.relative_to(w/'independent-corpus/opus-1.5.2'));args=shlex.split(z['command'])[1:];args[args.index('-o')+1]=str(out)
     subprocess.run([w/tree/'build/compiler','--tier1','--lanes','1','-w','-march='+arch,*args],cwd=z['directory'],env=env,check=True,stdout=subprocess.DEVNULL)
     h=hashlib.file_digest(out.open('rb'),'sha256').hexdigest();rows.append([config,arch,unit,refs[unit],h,h==refs[unit]])
 assert len(rows)==578
 with (q/'opus-rebuild.tsv').open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['configuration','target','source','prior_sha256','current_sha256','identical']);t.writerows(rows)
 print(label,len(rows),sum(z[-1] for z in rows),flush=True)
