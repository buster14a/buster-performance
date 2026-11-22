import csv
import importlib.util
import shutil
import subprocess
import tarfile
from hashlib import sha256
from pathlib import Path
from statistics import median

here = Path(__file__).resolve().parent
load = importlib.util.spec_from_file_location('standard', here/'package-standard.py')
module = importlib.util.module_from_spec(load)
load.loader.exec_module(module)
raw = here/'raw/results'
output = here/'packet'
rows = []
measure = raw/'livecursor-arena-sqlite'
frozen = (raw/'ordinary-pair-livegroupfixed-sqlite/preflight-baseline.objects').read_bytes()
for p in sorted(measure.glob('*.wall')):
    r,slot,name = p.stem.split('-')
    assert p.with_suffix('.objects').read_bytes() == frozen
    assert p.with_suffix('.stderr').read_bytes() == b''
    values = module.wall_re.search(p.read_text())
    assert values,p
    rows.append(dict(round=r,position=slot,arm=name,**dict(zip(module.wall_fields,map(float,values.groups())))))
assert len(rows) == 18
module.write_tsv(output/'measurements/allocator-observations.tsv',rows,list(rows[0]))
medians = []
for field in module.wall_fields:
    for arm in ['baseline','fixed','cache']:
        values = [r[field] for r in rows if r['arm']==arm]
        by_round = {n:median(r[field] for r in rows if r['round']==n and r['arm']==arm) for n in ('1','2','3')}
        medians.append(dict(metric=field,arm=arm,median=median(values),**{'round_'+k:v for k,v in by_round.items()}))
module.write_tsv(output/'measurements/allocator-summary.tsv',medians,list(medians[0]))
for name in ('livecursor-arena.sh','livegroupcache-one.sh'):
    shutil.copyfile(here/name,output/'reproduce'/name)
head = subprocess.check_output(['git','-C',str(here.parent/'pp-live-group-cache'),'rev-parse','HEAD'],text=True).strip()
patch = subprocess.check_output(['git','-C',str(here.parent/'pp-live-group-cache'),'diff','--binary','0e1d5b825',head])
assert patch==(here/'livegroupcache.patch').read_bytes()
assert sha256(patch).hexdigest() in (raw/'livegroupcache/revision.txt').read_text()
(output/'source/allocator.patch').write_bytes(patch)
(output/'source/allocator-commit.txt').write_bytes(subprocess.check_output(['git','-C',str(here.parent/'pp-live-group-cache'),'show','-s','--format=fuller',head]))
with tarfile.open(output/'measurements/allocator-raw.tar.gz','w:gz') as tf:
    for label in ('livecursor-arena-sqlite','livegroupcache'):
        for f in sorted((raw/label).glob('*')):
            if f.is_file():tf.add(f,arcname=label+'/'+f.name)
for item in medians:
    print(item['metric'],item['arm'],item['median'],item['round_1'],item['round_2'],item['round_3'])
