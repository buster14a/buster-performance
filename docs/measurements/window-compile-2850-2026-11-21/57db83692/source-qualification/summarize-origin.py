from pathlib import Path
from collections import Counter
import re,csv
d=Path(__file__).resolve().parent
with (d/'source-density.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n'); w.writerow('corpus policy slots untouched written_zero self inherited inherited_16blocks uninitialized_reads diagnostics_equal stdout_equal status_equal elf_equal'.split())
 for a in sorted(d.glob('origin-*-on.err')):
  raw=a.read_bytes();group,p=a.name.split('-')[1:3];fields=Counter()
  for m in re.finditer(rb'^origin-survey (.*)$',raw,re.M):fields.update({k.decode():int(v) for k,v in re.findall(rb'(\w+)=(\d+)',m[1])})
  b=a.with_name(a.name.replace('-on.','-off.'))
  norm=b''.join(l for l in raw.splitlines(True) if not l.startswith((b'origin-survey ',b'origin-unwritten ')))
  elf=a.with_suffix('.elf');same=elf.read_bytes()==b.with_suffix('.elf').read_bytes() if elf.exists() else '-'
  w.writerow([group,p,*(fields[k] for k in ('slots','untouched','zero','self','inherited','inherited_16blocks')),raw.count(b'origin-unwritten '),int(norm==b.read_bytes()),int(a.with_suffix('.out').read_bytes()==b.with_suffix('.out').read_bytes()),int(a.with_suffix('.status').read_bytes()==b.with_suffix('.status').read_bytes()),same])
