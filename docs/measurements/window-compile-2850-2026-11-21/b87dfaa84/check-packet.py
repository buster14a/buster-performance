from pathlib import Path
from collections import Counter
import csv,gzip,hashlib,json,sys
p=Path(__file__).resolve().parent
d=p if (p/'probe.oracle.json').exists() else p/'evidence/b87dfaa84'
def sha(data):return hashlib.sha256(data).hexdigest()
winners=[]
for kind,n,typed in [('probe',7,73),('sqlite',14321,381191),('main',9007,659942)]:
 q=json.loads((d/f'{kind}.oracle.json').read_text())
 assert q['tier0_rows']==typed and q['chains']==n and not q['mismatches']
 a=gzip.open(d/f'{kind}.base.typed.gz','rb').read();b=gzip.open(d/f'{kind}.chain.typed.gz','rb').read()
 assert a==b
 if (d/'compact-oracle.sha256').exists():
  rows=(d/'compact-oracle.sha256').read_text()
  assert sha(a)+' '+kind+'.fresh.chain.typed' in rows
for name,expect in [('timing.tsv',96),('compact-timing.tsv',56)]:
 rows=list(csv.DictReader((d/name).open(),delimiter='\t'));assert len(rows)==expect
 assert {r['sha256'] for r in rows}=={'2238999c41e256cc9c14ddbe21e379f0b3c09df25fb642b056e18b8a7ea773a0'}
for fmt in ['',*(['capacity-final-'] if '--capacity' in sys.argv else [])]:
 total=0;reject=0
 for name in ['sqlite','main','lua','musl']:
  rr=list(csv.DictReader(gzip.open(d/(fmt+name+'-policy.tsv.gz'),'rt'),delimiter='\t'));total+=len(rr)
  assert all(r['ref-exit']==r['local-exit'] and all(r[k]=='1' for k in ['obj-equal','stdout-equal','stderr-equal']) for r in rr)
  reject+=sum(r['ref-exit']!='0' for r in rr)
 assert total==6860 and reject==863
rows=list(csv.DictReader(gzip.open(d/'connected-declarations.tsv.gz','rt'),delimiter='\t'))
assert len(rows)==12597 and len({r['pp_row'] for r in rows})==12597
assert all(r['parser_initial_name']=='0' and r['final_name']==r['chosen_declaration_name'] for r in rows)
assert {f.read_text().strip() for f in d.glob('sqlite-runtime-*.stdout')}=={'2941 1092617091591019106'}
print('Artifact verification passed.')
