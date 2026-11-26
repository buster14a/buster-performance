import csv
import sys
from pathlib import Path
from statistics import median

evidence = Path(sys.argv[1])
for workload in ('sqlite', 'warnings'):
    print(workload)
    for event in ('cycles:u', 'instructions:u', 'task-clock'):
        series = []
        for revision in ('pr3661', 'pr3663'):
            samples = []
            for i in range(1, 21):
                with (evidence / workload / f'{i}-{revision}.csv').open() as source:
                    measured = {row[2]: float(row[0]) for row in csv.reader(source) if len(row) >= 3}
                samples.append(measured[event])
            series.append(samples)
        base, head = map(median, series)
        paired = [100 * (new / old - 1) for old, new in zip(*series, strict=True)]
        print(f'{event:15} {base:14,.3f} {head:14,.3f} {100 * (head / base - 1):+7.2f}% '
              f'pair range {min(paired):+.2f}..{max(paired):+.2f}%')
    data = evidence / workload
    print('stderr bytes:', *((data / f'0-{revision}.stderr').stat().st_size for revision in ('pr3661', 'pr3663')))
