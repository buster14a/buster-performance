# The floating classifications' measurement (buster #148): medians of measure.log's runs. Each line is "round R TREE run N status S," then perf stat's CSV
# fields (value, unit, event, ...). Every run's status must be 0. Per round, a tree's mean of its 3 runs; then the median
# of the rounds' means, and the median, minimum and maximum of the per-round ratios of the second tree to the first.
import statistics
import sys

path, a, b = sys.argv[1], sys.argv[2], sys.argv[3]
values = {}
statuses = []
for line in open(path):
    if not line.startswith('round '):
        continue
    head, rest = line.split(',', 1)
    words = head.split()
    round_, tree, status = int(words[1]), words[2], int(words[6])
    fields = rest.split(',')
    value, event = float(fields[0]), fields[2]
    statuses.append(status)
    values.setdefault((event, tree, round_), []).append(value)
print(f'runs {len(statuses) // 3}, statuses all 0: {all(s == 0 for s in statuses)}')
for event in ('instructions:u', 'cycles:u', 'task-clock'):
    rounds = sorted({r for (e, t, r) in values if e == event})
    means = {t: [statistics.mean(values[(event, t, r)]) for r in rounds] for t in (a, b)}
    spread = {t: max(max(values[(event, t, r)]) - min(values[(event, t, r)]) for r in rounds) for t in (a, b)}
    ratios = [means[b][i] / means[a][i] - 1 for i in range(len(rounds))]
    ma, mb = statistics.median(means[a]), statistics.median(means[b])
    print(f'{event}: {a} {ma:,.2f}, {b} {mb:,.2f}, difference {mb - ma:+,.2f} ({(mb / ma - 1) * 100:+.4f}%); '
          f'per-round ratios median {statistics.median(ratios) * 100:+.2f}% ({min(ratios) * 100:+.2f}% to {max(ratios) * 100:+.2f}%); '
          f'largest spread within a round {spread[a]:,.0f} and {spread[b]:,.0f}')
