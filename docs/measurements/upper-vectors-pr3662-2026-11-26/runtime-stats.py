import csv
import pathlib
import statistics
import sys

pr = sys.argv[1]
root = pathlib.Path(__file__).resolve().parent / ('upper-vectors-' + pr)
measurements = ('speedtest1','calls','tables','strings','arithmetic','closures')
for pad in (0, 16, 32, 48):
    if not (root / f'pad-{pad}.txt').exists():
        continue
    with (root / f'pad-{pad}.txt').open() as f:
        data = list(csv.DictReader(f, delimiter=' '))
    medians = {}
    for workload in measurements:
        sample = {}
        for side in ('base3661', f'pr{pr}'):
            rows = [x for x in data if x['side'] == side and x['workload'] == workload]
            if len(rows) == 7:
                sample[side] = [statistics.median(int(row[event]) for row in rows) for event in ('user_cycles','user_instructions')]
        if len(sample) == 2:
            medians[workload] = list(sample.values())
    if len(medians) != len(measurements):
        print(pad,'incomplete',list(medians))
        continue
    medians['Lua 5-script sum'] = [[sum(medians[w][side][event] for w in measurements[1:]) for event in range(2)] for side in range(2)]
    for workload, data in medians.items():
        b,h = data
        print(f'{pad:2d} {workload:16s}',*(f'{b[i]/1e6:10.3f}M → {h[i]/1e6:10.3f}M  {(h[i]/b[i]-1)*100:+6.2f}%' for i in range(2)))
