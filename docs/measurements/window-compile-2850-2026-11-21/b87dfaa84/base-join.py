from pathlib import Path
import csv,collections
d=Path(__file__).resolve().parent;w=d.parent
bases={int(r['parser-token']):r for r in csv.DictReader((w/'pp-object-base-study/coordinates.tsv').open(),delimiter='\t')}
fields={int(r['pp_row']):r for r in csv.DictReader((w/'member-chain-spelling-study/accepted.tsv').open(),delimiter='\t')}
c=collections.Counter()
with (d/'base-source-overlap.tsv').open('w') as f:
 out=csv.writer(f,delimiter='\t');out.writerow(['base-token','base-spelling','pp-row','depth','source-base-candidate','all-field-names-source-bound','some-field-names-source-bound'])
 for l in (w/'member-chain-spelling-study/sqlite.physical.chain.stderr').open():
  if not l.startswith('source-chain\t'):continue
  _,b,last,dep,rows,nd,tp=l.split();b=int(b);dep=int(dep);base=bases.get(b);hits=sum(b+2+2*i in fields for i in range(dep));c['acquired']+=1;c['coordinate-matched-bases']+=bool(base);c['base-and-every-selector']+=bool(base and hits==dep);c['base-and-some-selector']+=bool(base and hits);c['all-field-physical']+=hits==dep
  if base:assert int(base['operator-parser-token'])==b+1
  out.writerow([b,base['spelling'] if base else '',base['pp-row'] if base else '',dep,int(bool(base)),int(hits==dep),int(bool(hits))])
print(dict(c))
