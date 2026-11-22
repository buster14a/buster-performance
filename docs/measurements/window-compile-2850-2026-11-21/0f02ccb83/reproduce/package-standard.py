import csv
import re
import statistics
import tarfile
from hashlib import sha256
from pathlib import Path

root = Path(__file__).resolve().parent
raw = root / 'raw/results'
out = root / 'packet/measurements'
oracle = root / 'packet/oracles'
median = statistics.median
wall_re = re.compile(r'run 1 list 1: ([\d.]+) ms wall, ([\d.]+) ms user, ([\d.]+) ms system, (\d+) KiB wait4 peak, (\d+) minor faults, (\d+) major, (\d+) user cycles, (\d+) instructions, status 0')
wall_fields = ('wall_ms', 'user_ms', 'kernel_ms', 'peak_KiB', 'minor_faults', 'major_faults', 'child_user_cycles', 'child_user_instructions')
def write_tsv(name, rows, columns):
    with name.open('w') as stream:
        writer = csv.DictWriter(stream, fieldnames=columns, delimiter='\t', lineterminator='\n')
        writer.writeheader()
        writer.writerows(rows)

if __name__ == '__main__':
    unit_counts = {'sqlite': 1, 'lua': 34, 'musl': 1336, 'main': 1}
    observations = []
    manifests = []
    summary = []
    for label in ('livegroupfixed','livegroup47e','livegroupvec'):
        for workload, count in unit_counts.items():
            group = raw / f'ordinary-pair-{label}-{workload}'
            frozen = (group / 'preflight-baseline.objects').read_bytes()
            assert len(frozen.splitlines()) == count, (group, len(frozen.splitlines()), count)
            objects = list(group.glob('*.objects'))
            assert all(path.read_bytes() == frozen for path in objects),group
            for policy in ('preflight','policy'):
                for ext in ('stdout','stderr'):
                    assert (group/f'{policy}-baseline.{ext}').read_bytes() == (group/f'{policy}-candidate.{ext}').read_bytes(),(group,policy,ext)
            manifests.append(dict(label=label,workload=workload,objects_per_run=count,matched_manifests=len(objects),manifest_sha256=sha256(frozen).hexdigest()))
            if workload != 'sqlite' and label != 'livegroupfixed':
                continue
            assert len(objects) == 30, (group,len(objects))
            with (group/'order.tsv').open() as f:
                samples = list(csv.DictReader(f,delimiter='\t'))
            assert len(samples) == 24
            per_metric = {}
            for sample in samples:
                series = sample['series']
                stem = group / f"{series}-{sample['round']}-{sample['position']}"
                if series == 'wall':
                    values = wall_re.search(stem.with_suffix('.wall').read_text())
                    assert values,stem
                    metrics = dict(zip(wall_fields,map(float, values.groups())))
                else:
                    entries = list(csv.reader(l for l in stem.with_suffix('.perf').read_text().splitlines() if l and not l.startswith('#')))
                    assert all(float(e[4]) == 100 for e in entries),stem
                    metrics = {e[2]:float(e[0]) for e in entries}
                for metric,value in metrics.items():
                    per_metric.setdefault(metric,{}).setdefault(sample['mode'],{}).setdefault(sample['round'],[]).append(value)
                    observations.append(dict(label=label,workload=workload,**sample,metric=metric,value=value))
            for metric,by_arm in per_metric.items():
                base,cand=by_arm['baseline'],by_arm['candidate']
                assert all(len(values)==2 for by_round in (base,cand) for values in by_round.values())
                def overall(arm):
                    return median(v for vs in arm.values() for v in vs)
                def pct(n,d):
                    return round(100*(n/d-1),5) if d else ''
                row=dict(label=label,workload=workload,metric=metric,baseline=overall(base),candidate=overall(cand))
                for rn in ('1','2','3'):
                    row['round_'+rn+'_pct']=pct(median(cand[rn]),median(base[rn]))
                changes=[v for k,v in row.items() if k.startswith('round') and v!='']
                row['median_paired_pct']=median(changes) if changes else ''
                summary.append(row)
    write_tsv(out/'standard-observations.tsv', observations, list(observations[0]))
    write_tsv(out/'standard-summary.tsv',summary,list(summary[0]))
    write_tsv(oracle/'standard-objects.tsv',manifests,list(manifests[0]))
    with tarfile.open(out/'standard-raw.tar.gz','w:gz',compresslevel=5) as tf:
        for name in ('livegroupfixed','livegroup47e','livegroupvec','factsmain0e1d'):
            for folder in sorted(raw.glob(f'ordinary-pair-{name}-*')):
                for p in sorted(folder.glob('*')):
                    if p.is_file():tf.add(p,arcname=folder.name+'/'+p.name)
            for p in sorted((raw/name).glob('*')):
                if p.is_file():tf.add(p,arcname=name+'/'+p.name)
    for row in summary:
        if row['label']=='livegroupfixed' and row['metric']=='wall_ms':
            print(row)
