"""Verify that disabling the grammar in the measured binary reproduces the original physical-call receipts."""
import csv,sys
from pathlib import Path
here=Path(__file__).resolve().parent
matrix=Path(sys.argv[1]); previous=Path(sys.argv[2]); out=Path(sys.argv[3])
rows=list(csv.DictReader(matrix.open(),delimiter='\t'))
with out.open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow('source policy same_admissions same_diagnostics same_elf same_native same_references'.split())
 for policy in ['default','wall']:
  data={ (r['corpus'],r['unit']):r for r in csv.DictReader((previous/('sparse-'+policy+'.tsv')).open(),delimiter='\t')}
  for r in rows:
   if r['policy']!=policy:continue
   old=data[('main' if r['corpus']=='buster' else r['corpus'],Path(r['source']).name)]
   cols=[('baseline_calls','calls'),('base_diag','diagnostic_sha256'),('base_elf','object_sha256'),('base_native','native_sha256'),('base_refs','reference_sha256')]
   same=[int((r[n] or '-')==old[k]) for n,k in cols]
   assert all(same),r['source']
   w.writerow([r['source'],policy,*same])
